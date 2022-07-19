
/*
-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of a set of agricultural development indicators 
				  using the Uganda National Panel Survey (UNPS) LSMS-ISA Wave 7 (2018-19).
*Author(s)		: Didier Alia, Andrew Tomes, Peter Agamile, & C. Leigh Anderson

*Acknowledgments: We acknowledge the helpful contributions of members of the World Bank's LSMS-ISA team, the FAO's RuLIS team, IFPRI, IRRI, 
				  and the Bill & Melinda Gates Foundation Agricultural Development Data and Policy team in discussing indicator construction decisions. 
				  All coding errors remain ours alone.
*Date			: This  Version - July 18, 2022
----------------------------------------------------------------------------------------------------------------------------------------------------*/


*Data source
*-----------
*The Uganda National Panel Survey was collected by the Uganda National Bureau of Statistics (UBOS) 
*and the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture(LSMS - ISA)
*The data were collected over the period February 2018 - February 2019.
*All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
*http://microdata.worldbank.org/index.php/catalog/2862

*Throughout the do-file, we sometimes use the shorthand LSMS to refer to the Uganda National Panel Survey.


*Summary of Executing the Master do.file
*-----------
*This Master do.file constructs selected indicators using the Uganda UNPS (UN LSMS) data set.
*Using data files from within the "raw_data" folder within the "uganda-wave7-2018-19" folder, 
*the do.file first constructs common and intermediate variables, saving dta files when appropriate 
*in the folder "/uganda-wave7-2018-19/created data".
*These variables are then brought together at the household, plot, or individual level, saving dta files at each level when available 
*in the folder "/uganda-wave7-2018-19/final data".

*The processed files include all households, individuals, and plots in the sample.
*Toward the end of this do.file, there is a reference to another do.file that estimates summary statistics (mean, standard error of the mean, minimum, first quartile, median, third quartile, maximum) 
*of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager or farm size.
*The results are outputted in the excel file "Uganda_NPS_W7_summary_stats.xlsx" in the "/uganda-wave7-2018-19/final data" folder.
*It is possible to modify the condition  "if rural==1" in the portion of code following the heading "SUMMARY STATISTICS" to generate all summary statistics for a different sub_population.
										
 
/*
OUTLINE OF THE DO.FILE
Below are the list of the main files created by running this Master do.file
 					
*MAIN INTERMEDIATE FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD IDS						Uganda_NPS_W7_hhids.dta
*INDIVIDUAL IDS						Uganda_NPS_W7_person_ids.dta
*HOUSEHOLD SIZE						Uganda_NPS_W7_hhsize.dta
*PLOT AREAS							Uganda_NPS_W7_plot_areas.dta
*PLOT-CROP DECISION MAKERS			Uganda_NPS_W7_plot_decision_makers.dta

*MONOCROPPED PLOTS					Uganda_NPS_W7_[CROP]_monocrop_hh_area.dta
									
*TLU (Tropical Livestock Units)		Uganda_NPS_W7_TLU_Coefficients.dta

*GROSS CROP REVENUE					Uganda_NPS_W7_tempcrop_harvest.dta
									Uganda_NPS_W7_tempcrop_sales.dta
									Uganda_NPS_W7_permcrop_harvest.dta
									Uganda_NPS_W7_permcrop_sales.dta
									Uganda_NPS_W7_hh_crop_production.dta
									Uganda_NPS_W7_plot_cropvalue.dta
									Uganda_NPS_W7_crop_residues.dta
									Uganda_NPS_W7_hh_crop_prices.dta
									Uganda_NPS_W7_crop_losses.dta

*CROP EXPENSES						Uganda_NPS_W7_wages_mainseason.dta
									Uganda_NPS_W7_wages_shortseason.dta
									Uganda_NPS_W7_fertilizer_costs.dta
									Uganda_NPS_W7_seed_costs.dta
									Uganda_NPS_W7_land_rental_costs.dta
									Uganda_NPS_W7_asset_rental_costs.dta
									Uganda_NPS_W7_transportation_cropsales.dta
									
*CROP INCOME						Uganda_NPS_W7_crop_income.dta
									
*LIVESTOCK INCOME					Uganda_NPS_W7_livestock_expenses.dta
									Uganda_NPS_W7_hh_livestock_products.dta
									Uganda_NPS_W7_dung.dta
									Uganda_NPS_W7_livestock_sales.dta
									Uganda_NPS_W7_TLU.dta
									Uganda_NPS_W7_livestock_income.dta

*FISH INCOME						Uganda_NPS_W7_fishing_expenses_1.dta
									Uganda_NPS_W7_fishing_expenses_2.dta
									Uganda_NPS_W7_fish_income.dta
																	
*SELF-EMPLOYMENT INCOME				Uganda_NPS_W7_self_employment_income.dta
									Uganda_NPS_W7_agproducts_profits.dta
									Uganda_NPS_W7_fish_trading_revenue.dta
									Uganda_NPS_W7_fish_trading_other_costs.dta
									Uganda_NPS_W7_fish_trading_income.dta
									
*WAGE INCOME						Uganda_NPS_W7_wage_income.dta
									Uganda_NPS_W7_agwage_income.dta

*OTHER INCOME						Uganda_NPS_W7_other_income.dta
									Uganda_NPS_W7_land_rental_income.dta
									
*FARM SIZE / LAND SIZE				Uganda_NPS_W7_land_size.dta
									Uganda_NPS_W7_farmsize_all_agland.dta
									Uganda_NPS_W7_land_size_all.dta
									Uganda_NPS_W7_land_size_total.dta

*OFF-FARM HOURS						Uganda_NPS_W7_off_farm_hours.dta

*FARM LABOR							Uganda_NPS_W7_farmlabor_mainseason.dta
									Uganda_NPS_W7_farmlabor_shortseason.dta
									Uganda_NPS_W7_family_hired_labor.dta
									
*VACCINE USAGE						Uganda_NPS_W7_vaccine.dta
									Uganda_NPS_W7_farmer_vaccine.dta
									
*ANIMAL HEALTH						Uganda_NPS_W7_livestock_diseases.dta
									Uganda_NPS_W7_livestock_feed_water_house.dta

*USE OF INORGANIC FERTILIZER		Uganda_NPS_W7_fert_use.dta
									Uganda_NPS_W7_farmer_fert_use.dta

*USE OF IMPROVED SEED				Uganda_NPS_W7_improvedseed_use.dta
									Uganda_NPS_W7_farmer_improvedseed_use.dta

*REACHED BY AG EXTENSION			Uganda_NPS_W7_any_ext.dta
*USE OF FORMAL FINANACIAL SERVICES	Uganda_NPS_W7_fin_serv.dta
*MILK PRODUCTIVITY					Uganda_NPS_W7_milk_animals.dta
*EGG PRODUCTIVITY					Uganda_NPS_W7_eggs_animals.dta

*CROP PRODUCTION COSTS PER HECTARE	Uganda_NPS_W7_hh_rental_rate.dta
									Uganda_NPS_W7_hh_cost_land.dta
									Uganda_NPS_W7_hh_cost_inputs_lrs.dta
									Uganda_NPS_W7_hh_cost_inputs_srs.dta
									Uganda_NPS_W7_hh_cost_seed_lrs.dta
									Uganda_NPS_W7_hh_cost_seed_srs.dta
									Uganda_NPS_W7_asset_rental_costs.dta
									Uganda_NPS_W7_cropcosts_total.dta
									
*AGRICULTURAL WAGES					Uganda_NPS_W7_ag_wage.dta

*RATE OF FERTILIZER APPLICATION		Uganda_NPS_W7_fertilizer_application.dta
*HOUSEHOLD'S DIET DIVERSITY SCORE	Uganda_NPS_W7_household_diet.dta

*WOMEN'S CONTROL OVER INCOME		Uganda_NPS_W7_control_income.dta
*WOMEN'S AG DECISION-MAKING			Uganda_NPS_W7_make_ag_decision.dta
*WOMEN'S ASSET OWNERSHIP			Uganda_NPS_W7_ownasset.dta

*CROP YIELDS						Uganda_NPS_W7_yield_hh_crop_level.dta
*SHANNON DIVERSITY INDEX			Uganda_NPS_W7_shannon_diversity_index.dta
*CONSUMPTION						Uganda_NPS_W7_consumption.dta
*HOUSEHOLD FOOD PROVISION			Uganda_NPS_W7_food_insecurity.dta
*HOUSEHOLD ASSETS					Uganda_NPS_W7_hh_assets.dta


*FINAL FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD VARIABLES				Uganda_NPS_W7_household_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			Uganda_NPS_W7_individual_variables.dta	
*PLOT-LEVEL VARIABLES				Uganda_NPS_W7_field_plot_variables.dta
*SUMMARY STATISTICS					Uganda_NPS_W7_summary_stats.xlsx
*/

 
clear	
set more off
clear matrix	
clear mata	
set maxvar 10000	
ssc install findname  // need this user-written ado file for some commands to work




global directory "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda" 




// set directories: These paths correspond to the folders where the raw data files are located and where the created data and final data will be stored.
global Uganda_NPS_W7_raw_data 			"$directory/uganda-wave7-2018-19/raw_data"
global Uganda_NPS_W7_created_data 		"$directory/uganda-wave7-2018-19/created_data" 
global Uganda_NPS_W7_final_data  		"$directory/uganda-wave7-2018-19/final_data" 
		

 
********************************************************************************
*EXCHANGE RATE AND INFLATION FOR CONVERSION IN SUD IDS
********************************************************************************
global Uganda_NPS_W7_exchange_rate 3727.069		// Rate for 2018 from https://data.worldbank.org/indicator/PA.NUS.FCRF?end=2020&locations=UG&start=1960 (replaced this> https://www.exchangerates.org.uk/USD-UGX-spot-exchange-rates-history-2015.html). instead of using a spot rate, think its better to use the annual average rate from WB.
global Uganda_NPS_W7_gdp_ppp_dollar 1295.951   		// Rate for 2018 from https://data.worldbank.org/indicator/PA.NUS.PPP?locations=UG
global Uganda_NPS_W7_cons_ppp_dollar 1223.25		// Rate for 2018 from https://data.worldbank.org/indicator/PA.NUS.PRVT.PP?locations=UG
global Uganda_NPS_W7_inflation 00  		// inflation rate X-Y (years). Data was collected during the time period Oct 2015-Jan 2016. We want to adjust the monetary values to Z (year).

********************************************************************************
*THRESHOLDS FOR WINSORIZATION
********************************************************************************
global wins_lower_thres 1    						//Threshold for winzorization at the bottom of the distribution of continous variables
global wins_upper_thres 99							//Threshold for winzorization at the top of the distribution of continous variables


********************************************************************************
*GLOBALS OF PRIORITY CROPS 
********************************************************************************


*Enter the 12 priority crops here (maize, rice, wheat, sorghum, pearl millet (or just millet if not disaggregated), cowpea, groundnut, common bean, yam, sweet potato, cassava, banana)
*plus any crop in the top ten crops by area planted that is not already included in the priority crops - limit to 6 letters or they will be too long!
*For consistency, add the 12 priority crops in order first, then the additional top ten crops
global topcropname_area "maize rice wheat sorgum pmill cowpea grdnt beans yam swtptt cassav banana cotton sunflr pigpea coffee simsim" 
  
  

global topcrop_area "130 120 111 150 141 222 310 210 640 620 630 741 520 741 330 223 810 340" // missing crops with multiple codes: banana, coffee, peas
global comma_topcrop_area "130, 120, 111, 150, 141, 222, 310, 210, 640, 620, 630, 520, 741, 330, 223, 810, 340"

global nb_topcrops : list sizeof global(topcropname_area) 
display "$nb_topcrops"



********************************************************************************
*HOUSEHOLD IDS
********************************************************************************

use "${Uganda_NPS_W7_raw_data}/HH/GSEC1", clear
ren hwgt_W7  weight  // using the crossectional weight that applies to all respondents
gen rural = urban == 0 
gen strataid = region
ren district district_name

keep hhid region district district_name subcounty_code subcounty_name parish_code parish_name rural weight strataid // ea and village variables missing in this section
label var rural "1 = Household lives in a rural area"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhids.dta", replace


********************************************************************************
*INDIVIDUAL IDS
********************************************************************************

use "${Uganda_NPS_W7_raw_data}/HH/GSEC2", clear
destring pid_unps, gen(indiv) ignore ("P" "-") //PID is a string variable that contains some of the information we need to identify household members later in the file, need to destring and ignore the "P", leading "0", and the "-"
gen female = h2q3==2
label var female "1= individual is female"
gen age = h2q8
label var age "Individual age"
gen hh_head = h2q4==1 
label var hh_head "1= individual is household head"
ren PID ind
tostring ind, gen (individ)

*clean up and save data
label var indiv "Personal identification"
label var individ "Roster number (identifier within household)"
keep hhid indiv individ female age hh_head
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_person_ids.dta", replace

 
********************************************************************************
*HOUSEHOLD SIZE
********************************************************************************
use "${Uganda_NPS_W7_raw_data}/HH/GSEC2", clear
gen hh_members = 1
ren h2q4 relhead //relhead: relationship to head of household

ren h2q3 gender
gen fhh = (relhead==1 & gender==2) // fhh: female head of household
collapse (sum) hh_members (max) fhh, by (hhid)	// Aggregate households to sum the number of people in each house and note whether they have a female head of household or not

*Clean and save data
label var hh_members "Number of household members"
label var fhh "1 = Female-headed household"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhsize.dta", replace

********************************************************************************
*PLOT AREAS // need to separate plot area from parcel area
********************************************************************************

* plot area cultivated
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC4A.dta", clear
gen season = 1
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC4B.dta", gen (last)		
replace season = 2 if last==1
label var season "Season = 1 if 2nd cropping season of 2017, 2 if 1st cropping season of 2018" 
ren cropID cropcode
gen plot_area = s4aq07 //values are in acres
replace plot_area = s4bq07 if plot_area==. //values are in acres
replace plot_area = plot_area * 0.404686 //conversion factor is 0.404686 ha = 1 acre.
collapse (sum) plot_area, by (hhid parcelID pltid season)
bys hhid parcelID season : egen total_plot_area = sum(plot_area)
gen plot_area_pct = plot_area/total_plot_area
keep hhid parcelID pltid season plot_area total_plot_area plot_area_pct
tempfile plarea
save `plarea'
 

use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC2A.dta", clear
gen season = 1
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC2B.dta", gen (last)		
replace season = 2 if last==1
tostring parcelID, gen (parid)
drop parcelID
 
destring parid, gen (parcelID)
merge 1:m hhid parcelID season using `plarea', nogen
drop if pltid==.



*generating field_size
gen parcel_area = s2aq4 
replace parcel_area = s2aq04 if parcel_area == . 
replace parcel_area = s2aq5 if parcel_area == . // 966 values input from farmer estimates (introduces noise in later analysis)
replace parcel_area = s2aq05 if parcel_area == . // 538 changes
gen field_size = plot_area_pct*parcel_area //using calculated percentages of plots (out of total plots per parcel) to estimate plot size using more accurate parcel measurements
replace field_size = field_size/2.471 //convert acres to hectares

*cleaning up and saving the data
ren pltid plot_id
ren parcelID parcel_id
keep hhid parcel_id plot_id season field_size
drop if field_size == .
label var field_size "Area of plot (ha)"
label var hhid "Household identifier"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_areas.dta", replace

********************************************************************************
*PLOT DECISION MAKERS
********************************************************************************


use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC3A.dta", clear 

gen season=1
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC3B.dta" 
replace season = 2 if season == .

ren parcelID parcel_id
ren pltid plot_id

***drop if ag3b_03==. & ag3a_03==. 
***replace cultivated = 1 if  ag3b_03==1 

*First decision-maker variables 
gen individ = s3aq03_3
replace individ = s3bq03_3 if individ == "." & s3bq03_3 != "."

merge m:1 hhid individ using  "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_person_ids.dta", gen(dm1_merge) keep(1 3)		// Dropping unmatched from using
gen dm1_female = female

drop female indiv

* multiple decision makers 
gen dm_gendermult=s3aq03_2==2
replace dm_gendermult=s3bq03_2==2 if dm_gendermult==0



*Constructing three-part gendered decision-maker variable; male only (= 1) female only (= 2) or mixed (= 3)
keep hhid parcel_id plot_id season dm*
gen dm_gender = 1 if (dm1_female == 0 | dm1_female == .) & !(dm1_female == .) //if both dm1 and dm2 are null, then dm_gender is null
replace dm_gender = 2 if (dm1_female == 1 | dm1_female == .) & !(dm1_female == .) //if both dm1 and dm2 are null, then dm_gender is null

replace dm_gender = 3 if dm_gender == . & dm1_female == . & dm_gendermult==1 //no mixed-gender managed plots

label def dm_gender 1 "Male only" 2 "Female only" 3 "Mixed gender"
label val dm_gender dm_gender
label var dm_gender "Gender of plot manager/decision maker"

*Replacing observations without gender of plot manager with gender of HOH
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhsize.dta", nogen
replace dm_gender = 1 if fhh == 0 & dm_gender == .
replace dm_gender = 2 if fhh == 1 & dm_gender == . 
drop if plot_id == . 
keep hhid parcel_id plot_id season dm_gender fhh //***cultivated, also plotname was here but is not a variable in this wave
***lab var cultivated "1=Plot has been cultivated"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_decision_makers.dta", replace




**************
*AREA PLANTED*
**************
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC4A", clear 
gen season = 1
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC4B"
replace season = 2 if season == .
ren cropID cropcode
ren parcelID parcel_id
ren pltid plot_id

// check variable for cultivated
gen plot_ha_planted = s4aq07*(1/2.47105)
replace plot_ha_planted = s4bq07*(1/2.47105) if plot_ha_planted==.


* introduce area in ha 
merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_areas.dta", nogen keep(1 3)
			
*Adjust for inter-croppinp
gen per_intercropped=s4aq09
replace per_intercropped=s4bq09 if per_intercropped==.  // ta a4bq9  - no obs. No intercropping in second season/visit? 

gen  is_plot_intercropped=s4aq08==2 | s4bq08==2
replace is_plot_intercropped=1 if per_intercropped!=.  // 11 changes 
*Scale down percentage
bys  hhid parcel_id plot_id   : egen total_percent_planted = total(per_intercropped) if is_plot_intercropped==1 
replace plot_ha_planted=plot_ha_planted if is_plot_intercropped==0
replace plot_ha_planted=plot_ha_planted*(per_intercropped/total_percent_planted) if is_plot_intercropped==1 
*Now sum area planted for sub-plots should not exceed field size. If so rescal proportionally including for monocrops
bys  hhid parcel_id  : egen total_ha_planted = total(plot_ha_planted)

replace plot_ha_planted=plot_ha_planted*(field_size/total_ha_planted) if total_ha_planted>field_size & total_ha_planted!=.
gen  ha_planted=plot_ha_planted 

save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_area_planted_temp.dta", replace



********************************************************************************
*MONOCROPPED PLOTS
********************************************************************************


*Generating area harvested and kilograms harvested - for monocropped plots
forvalues k=1(1)$nb_topcrops  {		
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC4A.dta", clear
	append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC5A.dta"
	gen season = 1
	append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC4B.dta", gen(short)
	append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC5B.dta"
	replace season = 2 if season == .
    ren parcelID parcel_id 
    drop if parcel_id==.
    ren pltid plot_id
	ren cropID cropcode
    ren a5aq6d conversion
    replace conversion = a5bq6d if conversion==. & a5bq6d!=.
    ren s5aq06a_1 qty_harvest
    replace qty_harvest = s5bq06a_1 if qty_harvest==. & s5bq06a_1!=. 
	gen kgs_harv_mono_`cn' = qty_harvest*conversion if cropcode==`c'
    collapse (sum) kgs_harv_mono_`cn', by(hhid parcel_id plot_id cropcode season)

	
	
	*merge in area planted
    merge 1:1 hhid parcel_id plot_id cropcode season using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_area_planted_temp.dta" 

	
    xi i.cropcode, noomit
    collapse (sum) kgs_harv_mono_`cn' (max) _Icropcode_*, by(hhid parcel_id plot_id season ha_planted) 
    egen crop_count = rowtotal(_Icropcode_*)
    keep if crop_count==1 & _Icropcode_`c'==1
    *duplicates report HHID parcel_id
    collapse (sum) kgs_harv_mono_`cn' ha_planted (max) _Icropcode_*, by(hhid parcel_id plot_id season)

    gen `cn'_monocrop_ha=ha_planted
    drop if `cn'_monocrop_ha==0 									 
    gen `cn'_monocrop=1
        
	
	save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_`cn'_monocrop.dta", replace
}
 
*Adding in gender of plot manager - for monocropped plots
forvalues k=1(1)$nb_topcrops  {		
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_`cn'_monocrop.dta", clear
	merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_decision_makers.dta", keep (1 3) nogen 
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
	collapse (sum) `cn'_monocrop_ha* kgs_harv_mono_`cn'* (max) `cn'_monocrop_male `cn'_monocrop_female `cn'_monocrop_mixed `cn'_monocrop = _Icropcode_`c', by(hhid) 
	lab var `cn'_monocrop_ha "monocropped `cn' area(ha) planted" 
	lab var kgs_harv_mono_`cn' "monocropped `cn' harvested(kg)"
	lab var `cn'_monocrop "1=hh has monocropped `cn' plots"
	foreach i in male female mixed {
		replace `cn'_monocrop_ha = . if `cn'_monocrop!=1
		replace `cn'_monocrop_ha_`i' =. if  `cn'_monocrop!=1
		replace `cn'_monocrop_ha_`i' =. if `cn'_monocrop_`i'==0
		replace `cn'_monocrop_ha_`i' =. if `cn'_monocrop_ha_`i'==0	
		replace kgs_harv_mono_`cn' = . if `cn'_monocrop!=1 
		replace kgs_harv_mono_`cn'_`i' =. if  `cn'_monocrop!=1 
		replace kgs_harv_mono_`cn'_`i' =. if `cn'_monocrop_`i'==0 
		replace kgs_harv_mono_`cn'_`i' =. if `cn'_monocrop_ha_`i'==0
		local l`cn'_monocrop_ha : var lab `cn'_monocrop_ha
		la var `cn'_monocrop_ha_`i' "`l`cn'_monocrop_ha' - `i' managed plots"
		local lkgs_harv_mono_`cn' : var lab kgs_harv_mono_`cn'
		la var kgs_harv_mono_`cn'_`i' "`lkgs_harv_mono_`cn'' - `i' managed plots"
		la var `cn'_monocrop_`i' "1=hh has `i' managed monocropped `cn' plots"
	}
	save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_`cn'_monocrop_hh_area.dta", replace
}



********************************************************************************
*TLU (Tropical Livestock Units)
********************************************************************************

// Step 1: Create three TLU coefficient .dta files for later use, stripped of HHIDs

*For livestock
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC6A.dta", clear
ren LiveStockID livestockid
gen tlu_coefficient = 0.5 if (livestockid == 1 | livestockid == 2 | livestockid == 3 | livestockid == 4 | livestockid == 5 | livestockid == 6 | livestockid == 7 | livestockid == 8 | livestockid == 9 | livestockid == 10 | livestockid == 12) // This includes calves, bulls, oxen, heifer, cows, and horses (exotic/cross and indigenous)
replace tlu_coefficient = 0.3 if livestockid == 11 | livestockid == 12 //Includes indigenous donkeys & mules and horses 
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep livestockid tlu_coefficient
duplicates drop
save "${Uganda_NPS_W7_created_data}/tlu_livestock.dta", replace

*for small animals
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC6B.dta", clear
ren ALiveStock_Small_ID livestockid
gen tlu_coefficient = 0.1 if (livestockid == 13 | livestockid == 14 | livestockid == 15 | livestockid == 16 | livestockid == 18 | livestockid == 19 | livestockid == 20 | livestockid == 21) // This includes goats and sheeps (indigenous, exotic/cross, male, and female)
replace tlu_coefficient = 0.2 if (livestockid == 17 | livestockid == 22) //This includes pigs (indigenous and exotic/cross)
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep livestockid tlu_coefficient
duplicates drop
save "${Uganda_NPS_W7_created_data}/tlu_small_animals.dta", replace

*For poultry and misc.
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC6C.dta", clear
ren APCode livestockid
gen tlu_coefficient = 0.01  // This includes chicken (all kinds), turkey, ducks, geese, and rabbits)
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep livestockid tlu_coefficient
duplicates drop
save "${Uganda_NPS_W7_created_data}/tlu_poultry_misc.dta", replace

*Combine 3 TLU .dtas into a single .dta
use "${Uganda_NPS_W7_created_data}/tlu_livestock.dta", clear
append using "${Uganda_NPS_W7_created_data}/tlu_small_animals.dta"
append using "${Uganda_NPS_W7_created_data}/tlu_poultry_misc.dta"
label def livestockid 1 "Exotic/cross - Calves" 2 "Exotic/cross - Bulls" 3 "Exotic/cross - Oxen" 4 "Exotic/cross - Heifer" 5 "Exotic/cross - Cows" 6 "Indigenous - Calves" 7 "Indigenous - Bulls" 8 "Indigenous - Oxen" 9 "Indigenous - Heifer" 10 "Indigenous - Cows" 11 "Indigenous - Donkeys/Mules" 12 "Indigenous - Horses" 13 "Exotic/Cross - Male Goats" 14 "Exotic/Cross - Female Goats" 15 "Exotic/Cross - Male Sheep" 16 "Exotic/Cross - Female Sheep" 17 "Exotic/Cross - Pigs" 18 "Indigenous - Male Goats" 19 "Indigenous - Female Goats" 20 "Indigenous - Male Sheep" 21 "Indigenous - Female Sheep" 22 "Indigenous - Pigs" 23 "Indigenous Dual-Purpose Chicken" 24 "Layers (Exotic/Cross Chicken)" 25 "Broilers (Exotic/Cross Chicken)" 26 "Other Poultry and Birds (Turkeys/Ducks/Geese)" 27 "Rabbits"
label val livestockid livestockid 
save "${Uganda_NPS_W7_created_data}/tlu_all_animals.dta", replace


// Step 2: Generate ownership variables per household

*Combine HHID and livestock data into a single sheet
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC6A.dta", clear
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC6B.dta"
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC6C.dta"
gen livestockid = LiveStockID
replace livestockid = ALiveStock_Small_ID if livestockid == .
replace livestockid = APCode if livestockid == .
drop LiveStockID ALiveStock_Small_ID APCode
merge m:m livestockid using "${Uganda_NPS_W7_created_data}/tlu_all_animals.dta", nogen
label val livestockid livestockid //have to reassign labels to values after creating new variable
label var livestockid "Livestock Species ID Number"
sort hhid livestockid //Put back in order

*Generate ownership dummy variables for livestock categories: cattle (& cows alone), small ruminants, poultry (& chickens alone), & other
gen cattle = inrange(livestockid, 1, 10) //calves, bulls, oxen, heifer, and cows
gen cows = inlist(livestockid, 5, 10) //just cows
gen smallrum = inlist(livestockid, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 27) //goats, sheep, pigs, and rabbits
gen poultry = inrange(livestockid, 23, 26) //chicken, turkey, ducks, and geese
gen chickens = inrange(livestockid, 23, 25) //just chicken (all kinds)
gen otherlivestock = inlist(livestockid, 11, 12) //donkeys/mules and horses

  
*Generate "number of animals" variable per livestock category and household (Time of Survey)
ren s6aq03b ls_ownership_now
drop if ls_ownership == 2 //2 = do not own this animal anytime within the past 12 months (eliminates non-owners for all relevant time periods)
ren s6bq03b sa_ownership_now
drop if sa_ownership == 2 //2 = see above
ren s6cq03c po_ownership_now
drop if po_ownership == 2 //2 = see above

  
ren s6aq03a ls_number_now
ren s6bq03a sa_number_now
ren s6cq03a po_number_now 
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
ren s6aq06 ls_number_past
ren s6bq06 sa_number_past
ren s6cq06 po_number_past
gen livestock_number_past = ls_number_past
replace livestock_number_past = sa_number_past if livestock_number_past == .
replace livestock_number_past = po_number_past if livestock_number_past == .
lab var livestock_number_past "Number of animals owned 12 months before survey (see livestockid for type)"

gen num_cattle_past = livestock_number_past if cattle == 1
gen num_cows_past = livestock_number_past if cows == 1
gen num_smallrum_past = livestock_number_past if smallrum == 1
gen num_poultry_past = livestock_number_past if poultry == 1
gen num_chickens_past = livestock_number_past if chickens == 1
gen num_other_past = livestock_number_past if otherlivestock == 1
gen num_tlu_past = livestock_number_past * tlu_coefficient

     
//Step 3: Generate animal sales variables (sold alive)
ren s6aq14b ls_avgvalue
ren s6bq14b sa_avgvalue
ren s6cq14b po_avgvalue
ren s6aq14a num_ls_sold
ren s6bq14a num_sa_sold
ren s6cq14a num_po_sold

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

//Step 4: Aggregate to household level. Clean up and save data
collapse (sum) num*, by (hhid)
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
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_TLU_Coefficients.dta", replace



********************************************************************************
*ALL PLOTS
********************************************************************************


	***************************
	*Crop Values 
	***************************
	use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC5A.dta", clear
	gen season = 1
	append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC5B.dta"
	replace season = 2 if season == .
	ren s5aq07a_1 sold_qty
	replace sold_qty = s5bq07a_1 if sold_qty == .
	ren s5aq07c_1 sold_unit_code 
	replace sold_unit_code=s5bq07c_1 if sold_unit_code==.
	ren s5aq08_1 sold_value
	replace sold_value=s5bq08_1 if sold_value==.
	ren pltid plot_id
	ren parcelID parcel_id
	ren cropID crop_code
	gen unit_cd=a5bq6b
	replace unit_cd=a5aq6c if unit_cd==.
	keep hhid parcel_id plot_id crop_code unit_cd season sold_unit_code sold_qty sold_value s5aq06e_1 s5aq06e_1_1 s5bq06e_1 s5bq06e_1_1
	save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_crop_value.dta", replace
	
	* not saved among files for creation of panel, need to revisit
	merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhids.dta", nogen keepusing(district subcounty_code parish_code region weight)
	keep hhid parcel_id plot_id crop_code unit_cd sold_qty sold_value district subcounty_code parish_code region weight
	ren subcounty_code scounty_code
	drop if district_name==. & scounty_code==. & parish_code 
	gen price_unit = sold_value/sold_qty 
	label var price_unit "Average sold value per crop unit"
	gen obs = price_unit != .
	
	* create a value for the price of each crop at different levels 
	foreach i in district scounty_code parish_code region hhid {
		preserve
		bys `i' crop_code unit_cd : egen obs_`i'_price = sum(obs)
		collapse (median) price_unit_`i' = price_unit [aw=weight], by (`i' unit_cd crop_code obs_`i'_price)
		drop if crop_code==. | unit_cd==.
		tempfile price_unit_`i'_median
		save `price_unit_`i'_median'
		save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_price_unit_`i'_median.dta", replace 
		restore
	}
	
	collapse (median) price_unit_country = price_unit (sum) obs_country_price = obs [aw=weight], by(crop_code unit_cd)
	drop if crop_code==. | unit_cd==.
	tempfile price_unit_country_median
	save `price_unit_country_median'
	save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_price_unit_country_median.dta", replace
	
	
	
	***************************
	*Plot variables
	***************************	
	*Clean up file and combine both seasons
	use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC4A.dta", clear
	gen season = 1
	append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC4B.dta"
	replace season = 2 if season == .
	
	ren pltid plot_id
	ren parcelID parcel_id
	ren cropID crop_code
	drop if crop_code == .
	gen crop_code_master = crop_code 
	recode crop_code_master (811 812 = 810) (742 744 = 741) (222 223 224 = 221)
	label define cropID 810 "Coffee" 740 "Bananas" 220 "Peas", modify //need to add new codes to the value label, cropID
	label values crop_code_master cropID //apply crop labels to crop_code_master
	
	*Create area variables
	ren s4aq07 acre_planted_s1  //s1 = season 1
	gen ha_planted_s1 = acre_planted_s1 * 0.404686 //conversion factor is 0.404686 ha = 1 acre.
	label var ha_planted_s1 "Hectares planted per-plot in the last cropping season of 2014"
	ren s4bq07 acre_planted_s2 //s2 = season 2
	gen ha_planted_s2 = acre_planted_s2 * 0.404686 //conversion factor is 0.404686 ha = 1 acre.
	label var ha_planted_s2 "Hectares planted per-plot in the first cropping season of 2015"
	merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_areas.dta", nogen keep(1 3) 
	replace ha_planted_s1 = field_size * s4aq09 / 100 if s4aq09 != . & s4aq09 != 0  
	replace ha_planted_s2 = field_size * s4bq09 /100 if s4bq09 != . & s4bq09 != 0 
 	gen ha_planted = ha_planted_s1
	replace ha_planted = ha_planted_s2 if ha_planted == . 
	
	tempfile haplanted 
	save `haplanted'
	
	*Creating time variables (month planted, harvested, and length of time grown)
	* month planted
	gen month_planted = s4aq09_1
	replace month_planted = s4bq09_1 if season == 2 
	* year planted
	gen year_planted1 = s4aq09_2
	replace year_planted1 = 9999 if year_planted1==9998 | year_planted1<2017 // set year for perennial crops
	gen year_planted2 = s4bq09_2
	replace year_planted2 = 2018 if year_planted2==20186
	replace year_planted2 = 9999 if year_planted2==9998 | year_planted2<2018
	gen year_planted = year_planted1
	replace year_planted = year_planted2 if year_planted==.
	lab var month_planted "Month of planting relative to December 2018 (both cropping seasons)"
	lab var year_planted "Year of planting (perennial crops=9999)"
	merge m:m hhid parcel_id plot_id crop_code season using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_crop_value.dta", nogen
	* month harvest started
	gen month_harvest = s5aq06e_1  // use start start month
	replace month_harvest = s5bq06e_1 if season == 2
	
	* year harvest started
	gen year_harv1 = s5aq06e_1_1
	replace year_harv1 = 2017 if year_harv1<2017
	gen year_harv2 = s5bq06e_1_1
	replace year_harv2 = 2018 if year_harv2==20186 | year_harv2<2018 | year_harv2==2048
	gen year_harvested = year_harv1
	replace year_harvested = year_harv2 if year_harvested==.
	lab var month_harvest "Month of planting relative to December 2018 (both cropping seasons)"
	lab var year_planted "Year harvest started"
	
	* months crop grown
	gen months_grown = month_harvest - month_planted if year_harvested==year_planted  // planting + harvesting in the same calendar year 
	replace months_grown = 12 - month_planted + month_harvest if year_harvested==year_planted+1 // months in the first calendar year when crop planted 
	replace months_grown = 12 - month_planted if months_grown<1 // reconcile crops for which month planted is later than month harvested in the same year
	replace months_grown = 4 if months_grown==0 // replace months grown=4 (1 season) if month crop planted == month crop harvested == december in the same year
	
	
	
	
	*Generate crops_plot variable for number of crops per plot. This is used to fix issues around intercropping and relay cropping being reported inaccurately for our purposes.
	preserve
		gen obs = 1
		collapse (sum) crops_plot = obs, by(hhid parcel_id plot_id season)
		tempfile ncrops 
		save `ncrops'
	restore 
	merge m:1 hhid parcel_id plot_id season using `ncrops', nogen
	
	gen contradict_mono = 1 if s4aq09 == 100 | s4bq09 == 100 & crops_plot > 1 //6 plots have >1 crop but list monocropping
	gen contradict_inter = 1 if crops_plot == 1
	replace contradict_inter = . if s4aq09 == 100 | s4aq08 == 1 | s4bq09 == 100 | s4bq08 == 1 //meanwhile 64 list intercropping or mixed cropping but only report one crop
	
	
		
	use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC5A.dta", clear
	gen season = 1
	append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC5B.dta"
	replace season = 2 if season == .
	ren pltid plot_id
	ren parcelID parcel_id
	ren cropID crop_code
	gen unit_cd=a5bq6b
	replace unit_cd=a5aq6c if unit_cd==.
	merge 1:1 hhid parcel_id plot_id crop_code season using `haplanted', nogen keep(1 3)
	
	ren a5aq6d conv_fact
    replace conv_fact = a5bq6d if conv_fact==. & a5bq6d!=.
    ren s5aq06a_1 quantity_harvested
    replace quantity_harvested = s5bq06a_1 if quantity_harvested==. & s5bq06a_1!=. 
	
	gen quant_harv_kg= quantity_harvested*conv_fact
	ren s5aq08_1 value_harvest // value of harvest isn't recorded in the uganda dta, use market sale value for now 
	replace value_harvest = s5bq08_1 if value_harvest==. & s5bq08_1!=.
	gen val_unit = value_harvest/quantity_harvested
	gen val_kg = value_harvest/quant_harv_kg
	
	merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhids.dta", nogen keepusing(district subcounty_code parish_code region weight) 
	ren subcounty_code scounty_code
	gen plotweight = ha_planted*weight
	gen obs=quantity_harvested>0 & quantity_harvested!=.
	foreach i in district scounty_code parish_code region hhid {
	
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

foreach i in district scounty_code parish_code region hhid {
preserve
	bys `i' crop_code unit_cd : egen obs_`i'_unit = sum(obs)
	collapse (median) val_unit_`i'=val_unit  [aw=plotweight], by (`i' unit_cd crop_code obs_`i'_unit)
	tempfile val_unit_`i'_median
	save `val_unit_`i'_median'
restore
	merge m:1 `i' unit_cd crop_code using `price_unit_`i'_median', nogen keep(1 3)
	merge m:1 `i' unit_cd crop_code using `val_unit_`i'_median', nogen keep(1 3)
	merge m:1 `i' crop_code using `val_kg_`i'_median', nogen keep(1 3)
}
preserve

collapse (median) val_unit_country = val_unit (sum) obs_country_unit=obs [aw=plotweight], by(crop_code unit_cd)
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_crop_prices_median_country.dta", replace //This gets used for self-employment income.
restore

merge m:1 unit_cd crop_code using `price_unit_country_median', nogen keep(1 3)
merge m:1 unit_cd crop_code using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_crop_prices_median_country.dta", nogen keep(1 3)
merge m:1 crop_code using `val_kg_country_median', nogen keep(1 3)




//We're going to prefer observed prices first
foreach i in district scounty_code parish_code region hhid {
	replace val_unit = price_unit_`i' if obs_`i'_price>9
	replace val_kg = val_kg_`i' if obs_`i'_kg >9
}
	gen val_missing = val_unit==.
	replace val_unit = price_unit_hhid if price_unit_hhid!=.

foreach i in district scounty_code parish_code region hhid {
	replace val_unit = val_unit_`i' if obs_`i'_unit > 9 & val_missing==1
}
	replace val_unit = val_unit_hhid if val_unit_hhid!=. & val_missing==1
	replace val_kg = val_kg_hhid if val_kg_hhid!=. //Preferring household values where available.
//All that for these two lines:
	replace value_harvest=val_unit*quantity_harvested if value_harvest==.
	replace value_harvest=val_kg*quant_harv_kg if value_harvest==.
//167 real changes total. But note we can also subsitute local values for households with weird prices, which might work better than winsorizing.
	//Replacing conversions for unknown units
	replace val_unit = value_harvest/quantity_harvested if val_unit==.
preserve
	ren unit_cd unit
	collapse (mean) val_unit, by (hhid crop_code unit)
	ren val_unit hh_price_mean
	lab var hh_price_mean "Average price reported for this crop-unit in the household"
	save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_crop_prices_for_wages.dta", replace
restore


	
	
	

********************************************************************************
*GROSS CROP REVENUE
********************************************************************************


***Temporary crops (both seasons)
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC5A.dta", clear
gen season = 1
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC5B.dta"
replace season = 2 if season == .
	
ren pltid plot_id
ren parcelID parcel_id
ren cropID crop_code

* harvest (2nd season in 2017 & 1st season in 2018)

ren a5aq6d conversion_harvest
replace conversion_harvest = a5bq6d if conversion_harvest == . 
ren s5aq06a_1 harvest_amount 
replace harvest_amount = s5bq06a_1 if harvest_amount == . 
gen kgs_harvest = harvest_amount * conversion_harvest 

collapse (sum) kgs_harvest, by (hhid crop_code plot_id)
replace kgs_harvest = . if kgs_harvest == 0
lab var kgs_harvest "Kgs harvested of this crop, summed over main and short season"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_tempcrop_harvest.dta", replace 

* value sold
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC5A.dta", clear
gen season = 1
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC5B.dta"
replace season = 2 if season == .
ren pltid plot_id
ren parcelID parcel_id
ren cropID crop_code

ren s5aq08_1 value_sold
replace value_sold = s5bq08_1 if value_sold == . 
ren a5aq6d conversion_sold
replace conversion_sold = a5bq6d if conversion_sold == . 
ren s5aq07a_1 amount_sold
replace amount_sold = s5bq07a_1 if amount_sold == . 
gen kgs_sold = amount_sold * conversion_sold
collapse(sum) value_sold kgs_sold, by (hhid crop_code) 
replace value_sold = . if value_sold == 0
replace kgs_sold = . if kgs_sold == 0

lab var kgs_sold "Kgs sold of this crop, summed over main and short season"
lab var value_sold "Value sold of this crop, summed over main and short season"
gen price_kg = value_sold / kgs_sold
lab var price_kg "Price per kg sold"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_tempcrop_sales.dta", replace
 
 


********************************************************************************
*CROP EXPENSES
******************************************************************************** 
*Expenses: Hired labor
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC3A.dta", clear
gen season = 1
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC3B.dta"
replace season = 2 if season == .
ren s3aq36  wages_paid_main // no wages reported in season 2 data 


*Monocropped plots
*renaming list of topcrops for hired labor. Permanent crops are not listed in short rainy season - cassava and banana
global topcropname_annual "maize rice wheat sorgum pmill cowpea grdnt beans yam swtptt cotton sunflr pigpea"

foreach cn in $topcropname_annual {		//labor for permanent crops is all recorded in the SRS
	preserve
	gen short = 0
	ren parcelID parcel_id
	ren pltid plot_id
	*disaggregate by gender of plot manager
	merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_decision_makers.dta"
	foreach i in wages_paid_main{
	gen `i'_`cn' = `i'
	gen `i'_`cn'_male = `i' if dm_gender==1 
	gen `i'_`cn'_female = `i' if dm_gender==2 
	gen `i'_`cn'_mixed = `i' if dm_gender==3 
	}

	*Merge in monocropped plots
	merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_`cn'_monocrop.dta", nogen /*assert(1 3)*/ keep(3)		
	collapse (sum) wages_paid_main_`cn'*, by(hhid)		
	lab var wages_paid_main_`cn' "Wages for hired labor in main growing season - Monocropped `cn' plots"
	foreach g in male female mixed {
		lab var wages_paid_main_`cn'_`g' "Wages for hired labor in main growing season - Monocropped `g' `cn' plots"
	}
	save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_wages_mainseason_`cn'.dta", replace

	restore
} 
keep if season==1
collapse (sum) wages_paid_main, by (hhid) 
lab var wages_paid_main  "Wages paid for hired labor (crops) in main growing season"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_wages_mainseason.dta", replace


// no wages reported in season 2
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC3A.dta", clear
gen season = 1
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC3B.dta"
replace season = 2 if season == .
ren s3aq36  wages_paid_short // no wages reported in season 2 data 


*Monocropped plots
global topcropname_short "maize rice sorgum cowpea grdnt beans yam swtptt cassav banana cotton" //shorter list of crops because not all crops have observations in short season

foreach cn in $topcropname_short {		
	preserve
	gen short = 1
	ren parcelID parcel_id
	ren pltid plot_id
	*disaggregate by gender of plot manager
	merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_decision_makers.dta"
	foreach i in wages_paid_short{
	gen `i'_`cn' = `i'
	gen `i'_`cn'_male = `i' if dm_gender==1 
	gen `i'_`cn'_female = `i' if dm_gender==2 
	gen `i'_`cn'_mixed = `i' if dm_gender==3 
	}
	*Merge in monocropped plots
	merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_`cn'_monocrop.dta", nogen /*assert(1 3)*/ keep(3)	
	collapse (sum) wages_paid_short_`cn'*, by(hhid)	
	lab var wages_paid_short_`cn' "Wages paid for hired labor in short growing season - Monocropped `cn' plots"
	foreach g in male female mixed {
		lab var wages_paid_short_`cn'_`g' "Wages paid for hired labor in short growing season - Monocropped `g' `cn' plots"
	}
	save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_wages_shortseason_`cn'.dta", replace
	restore
} 

keep if season==2
collapse (sum) wages_paid_short, by (hhid)
lab var wages_paid_short "Wages paid for hired labor (crops) in short growing season"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_wages_shortseason.dta", replace




*Expenses: Inputs
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC2A.dta", clear
gen season = 1
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC2B.dta", gen(short)	
replace season = 2 if season == .


*formalized land rights
gen formal_land_rights = (s2aq23==1 | s2aq23==2 | s2aq23==3 | a2aq32==1)	// no data on formal ownership reported in season 2


*Starting with first owner
preserve
ren s2aq24__0 indivi
tostring indivi, gen(individ)
merge m:1 hhid individ using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_person_ids.dta", nogen keep(3)		// keep only matched
keep hhid individ female formal_land_rights
tempfile p1
save `p1', replace
restore

*Now second owner
preserve
ren s2aq24__1 indivi
tostring indivi, gen(individ)
merge m:1 hhid individ using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_person_ids.dta", nogen keep(3)		// keep only matched (just 2)	
keep hhid individ female
append using `p1'
gen formal_land_rights_f = formal_land_rights==1 if female==1
collapse (max) formal_land_rights_f, by(hhid individ)		
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_land_rights_ind.dta", replace
restore	

preserve
collapse (max) formal_land_rights_hh=formal_land_rights, by(hhid)		// taking max at household level; equals one if they have official documentation for at least one plot
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_land_rights_hh.dta", replace
restore


* fertilizer and pesticide purchase 
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC3A.dta", clear
gen season = 1
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC3B.dta"
replace season = 2 if season == .

gen value_fertilizer = s3aq27
replace value_fertilizer = s3bq27 if value_fertilizer==.

gen value_pesticide = s3aq18
replace value_pesticide = s3bq18 if value_pesticide==.

gen value_manure_purch = s3aq08
replace value_manure_purch = s3bq08 if value_manure_purch==.


*Monocropped plots
foreach cn in $topcropname_area {					
	preserve
	ren parcelID parcel_id
	ren pltid plot_id
	*disaggregate by gender plot manager
	merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_decision_makers.dta"
	*Merge in monocropped plots
	merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_`cn'_monocrop.dta", nogen /*assert(1 3)*/ keep(3)		// only in master and matched; keeping only matched, because these are the maize monocropped plots
	foreach i in value_fertilizer value_pesticide value_manure_purch {
	gen `i'_`cn' = `i'
	gen `i'_`cn'_male = `i' if dm_gender==1
	gen `i'_`cn'_female = `i' if dm_gender==2
	gen `i'_`cn'_mixed = `i' if dm_gender==3
}
	collapse (sum) value_fertilizer_`cn'* value_pesticide_`cn'* value_manure_purch_`cn'*, by(hhid)	
	lab var value_fertilizer_`cn' "Value of fertilizer purchased (not necessarily the same as used) in main and short growing seasons - Monocropped `cn' plots only"
	lab var value_pesticide_`cn' "Value of pesticide purchased (not necessarily the same as used) in main and short growing seasons - Monocropped `cn' plots only"
	lab var value_manure_purch_`cn' "Value of manure purchased (not necessarily the same as used) in main and short growing seasons - Monocropped `cn' plots only"
	save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_fertilizer_costs_`cn'.dta", replace
	restore
}

*In the survey instrument, the value of inputs obtained on credit is already captured in the question "What was the total value of the --- purchased?"
collapse (sum) value_fertilizer value_pesticide value_manure_purch, by (hhid) 
lab var value_fertilizer "Value of fertilizer purchased (not necessarily the same as used) in main and short growing seasons" 
lab var value_pesticide "Value of pesticide purchased (not necessarily the same as used) in main and short growing seasons"
lab var value_manure_purch "Value of manure purchased (not necessarily the same as used) in main and short growing seasons"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_fertilizer_costs.dta", replace




 
*Seed
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC4A.dta", clear
gen season = 1
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC4B.dta", gen(short)	
replace season = 2 if season == .

gen cost_seed = s4aq15
replace cost_seed = s4bq15 if cost_seed==.
recode cost_seed (.=0) 

*Monocropped plots
foreach cn in $topcropname_annual {		//seed costs for permanent crops not included in survey(cassava and banana)
*seed costs for monocropped plots
	preserve
	ren parcelID parcel_id
	ren pltid plot_id
	*disaggregate by gender of plot manager
	merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_decision_makers.dta"
	gen cost_seed_male=cost_seed if dm_gender==1
	gen cost_seed_female=cost_seed if dm_gender==2
	gen cost_seed_mixed=cost_seed if dm_gender==3
	*Merge in monocropped plots
	merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_`cn'_monocrop.dta", nogen /*assert(1 3)*/ keep(3)		// only in master and matched; keeping only matched
	collapse (sum) cost_seed_`cn' = cost_seed cost_seed_`cn'_male = cost_seed_male cost_seed_`cn'_female = cost_seed_female cost_seed_`cn'_mixed = cost_seed_mixed, by(hhid)		// renaming all to "_`cn'" suffix
	lab var cost_seed_`cn' "Expenditures on seed for crops - Monocropped `cn' plots only"
	save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_seed_costs_`cn'.dta", replace
	restore
}

collapse (sum) cost_seed, by (hhid)
lab var cost_seed "Expenditures on seed for temporary crops"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_seed_costs.dta", replace
*Note that planting material for permanent crops is not captured anywhere.


*Land rental
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC2A.dta", clear
gen season = 1
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC2B.dta", gen(short)	
replace season = 2 if season == .

	
gen rental_cost_land = a2bq09 // rent recoded in season 2 covers the both season 1 & 2
recode rental_cost_land (.=0)

*Monocropped plots
foreach cn in $topcropname_area {		
	preserve
	ren parcelID parcel_id
	*disaggregate by gender of plot manager
	merge 1:m hhid parcel_id season using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_decision_makers.dta"
	*Merge in monocropped plots
	merge 1:1 hhid parcel_id plot_id season using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_`cn'_monocrop.dta", nogen /*assert(1 3)*/ keep(3)		// only in master and matched; keeping only matched
	gen rental_cost_land_`cn'=rental_cost_land
	gen rental_cost_land_`cn'_male=rental_cost_land if dm_gender==1
	gen rental_cost_land_`cn'_female=rental_cost_land if dm_gender==2
	gen rental_cost_land_`cn'_mixed=rental_cost_land if dm_gender==3
	collapse (sum) rental_cost_land_`cn'* , by(hhid)				// Now, this sum should be only rental costs for parcels that are maize monocrops
	lab var rental_cost_land_`cn' "Rental costs paid for land - Monocropped `cn' plots only"
	save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_land_rental_costs_`cn'.dta", replace
	restore
}

collapse (sum) rental_cost_land, by (hhid)
lab var rental_cost_land "Rental costs paid for land"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_land_rental_costs.dta", replace



*Rental of agricultural tools, machines, animal traction
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC10.dta", clear
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC11.dta"

gen animal_traction = (AGroup_ID==101 | AGroup_ID==105 | AGroup_ID==109 | AGroup_ID==110)
gen ag_asset = (A10itemcod_ID>0 & A10itemcod_ID<6 | A10itemcod_ID>6 & A10itemcod_ID<15 | A10itemcod_ID>18)
gen tractor = (A10itemcod_ID==6 | A10itemcod_ID>14 & A10itemcod_ID<19)

ren s10q08a rental_cost


gen rental_cost_animal_traction = s11q05a if animal_traction==1 // PA: this is rental revenue NOT COST
gen rental_cost_ag_asset = rental_cost if ag_asset==1
gen rental_cost_tractor = rental_cost if tractor==1

recode rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor (.=0)
collapse (sum) rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor, by (hhid)
lab var rental_cost_animal_traction "Costs for renting animal traction"
lab var rental_cost_ag_asset "Costs for renting other agricultural items"
lab var rental_cost_tractor "Costs for renting a tractor"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_asset_rental_costs.dta", replace




*Transport costs for crop sales
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC5A.dta", clear
gen season = 1
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC5B.dta", gen(short)	
replace season = 2 if season == .

ren s5aq10_1 transport_costs_cropsales
replace transport_costs_cropsales = s5bq10_2 if transport_costs_cropsales==.
recode transport_costs_cropsales (.=0)
collapse (sum) transport_costs_cropsales, by (hhid)
lab var transport_costs_cropsales "Expenditures on transportation for crop sales of temporary crops"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_transportation_cropsales.dta", replace


*Crop costs 
use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_asset_rental_costs.dta", clear
merge 1:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_land_rental_costs.dta", nogen
merge 1:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_seed_costs.dta", nogen
merge 1:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_fertilizer_costs.dta", nogen
merge 1:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_wages_shortseason.dta", nogen
merge 1:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_wages_mainseason.dta", nogen
merge 1:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_transportation_cropsales.dta",nogen
recode rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor rental_cost_land cost_seed value_fertilizer  /*
*/ value_pesticide wages_paid_short wages_paid_main transport_costs_cropsales (.=0)
egen crop_production_expenses = rowtotal(rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor rental_cost_land cost_seed value_fertilizer /*
*/ value_pesticide wages_paid_short wages_paid_main transport_costs_cropsales)
lab var crop_production_expenses "Total crop production expenses"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_crop_income.dta", replace



 

********************************************************************************
*LIVESTOCK INCOME
********************************************************************************
* Expenses data is currently missing in the raw LSMS-ISA Wave 7


*Livestock products

use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC8B.dta", clear
ren AGroup_ID livestock_code 
keep if livestock_code==101 | livestock_code==102
ren s8bq01 animals_milked
ren s8bq02 months_milked
ren s8bq03 liters_per_day 
recode animals_milked months_milked liters_per_day (.=0)
gen milk_liters_produced = (animals_milked * months_milked * 30 * liters_per_day) /* 30 days per month */
lab var milk_liters_produced "Liters of milk produced in past 12 months"
ren s8bq05a liters_sold_per_day
ren s8bq07 liters_perday_to_cheese 
ren s8bq09 earnings_per_day_milk

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
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_products_milk", replace

use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC8C.dta", clear
ren AGroup_ID livestock_code 

ren s8cq01 months_produced
ren s8cq02 quantity_month

recode months_produced quantity_month (.=0)
gen quantity_produced = months_produced * quantity_month /* Units are pieces for eggs & skin, liters for honey */
lab var quantity_produced "Quantity of this product produed in past year"
ren s8cq03 sales_quantity
ren s8cq05 earnings_sales

recode sales_quantity months_produced quantity_month earnings_sales (.=0)
gen price_per_unit = earnings_sales / sales_quantity
keep hhid livestock_code quantity_produced price_per_unit earnings_sales

bys livestock_code: sum price_per_unit
gen price_per_unit_hh = price_per_unit
lab var price_per_unit "Price of egg per unit sold"
lab var price_per_unit_hh "Price of egg per unit sold at household level"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_products_other", replace

use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_products_milk", clear
append using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_products_other"
recode price_per_unit (0=.)
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhids.dta"
drop if _merge==2
drop _merge
replace price_per_unit = . if price_per_unit == 0 
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_products", replace


use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region district livestock_code: egen obs_district = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district livestock_code obs_district)
ren price_per_unit price_median_district
lab var price_median_district "Median price per unit for this livestock product in the district"
lab var obs_district "Number of sales observations for this livestock product in the district"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_products_prices_district.dta", replace

use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_unit [aw=weight], by (region livestock_code obs_region)
ren price_per_unit price_median_region
lab var price_median_region "Median price per unit for this livestock product in the region"
lab var obs_region "Number of sales observations for this livestock product in the region"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_products_prices_region.dta", replace

use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_unit [aw=weight], by (livestock_code obs_country)
ren price_per_unit price_median_country
lab var price_median_country "Median price per unit for this livestock product in the country"
lab var obs_country "Number of sales observations for this livestock product in the country"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_products_prices_country.dta", replace

use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_products", clear
*merge m:1 region district ward ea livestock_code using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_products_prices_ea.dta", nogen
*merge m:1 region district ward livestock_code using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_products_prices_ward.dta", nogen
merge m:1 region district livestock_code using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_products_prices_district.dta", nogen
merge m:1 region livestock_code using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_products_prices_region.dta", nogen
merge m:1 livestock_code using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_products_prices_country.dta", nogen
*replace price_per_unit = price_median_ea if price_per_unit==. & obs_ea >= 10
*replace price_per_unit = price_median_ward if price_per_unit==. & obs_ward >= 10
replace price_per_unit = price_median_district if price_per_unit==. & obs_district >= 10 
replace price_per_unit = price_median_region if price_per_unit==. & obs_region >= 10 
replace price_per_unit = price_median_country if price_per_unit==.
lab var price_per_unit "Price per unit of this livestock product, with missing values imputed using local median values"
gen price_cowmilk_med = price_median_country if livestock_code==1
egen price_cowmilk = max(price_cowmilk_med)
replace price_per_unit = price_cowmilk if livestock_code==2
lab var price_per_unit "Price per liter (milk) or per egg/liter/container honey, imputed with local median prices if household did not sell"
gen value_milk_produced = milk_liters_produced * price_per_unit 
gen value_eggs_produced = quantity_produced * price_per_unit if livestock_code==21
gen value_other_produced = quantity_produced * price_per_unit if livestock_code==22 | livestock_code==23
egen sales_livestock_products = rowtotal(earnings_sales earnings_milk_year)		

collapse (sum) value_milk_produced value_eggs_produced value_other_produced sales_livestock_products, by (hhid)
*First, constructing total value
egen value_livestock_products = rowtotal(value_milk_produced value_eggs_produced value_other_produced)
lab var value_livestock_products "value of livesotck prodcuts produced (milk, eggs, other)"
*Now, the share
gen share_livestock_prod_sold = sales_livestock_products/value_livestock_products
replace share_livestock_prod_sold = 1 if share_livestock_prod_sold>1 & share_livestock_prod_sold!=.
lab var share_livestock_prod_sold "Percent of production of livestock products that is sold" 
lab var value_milk_produced "Value of milk produced"
lab var value_eggs_produced "Value of eggs produced"
lab var value_other_produced "Value of honey and skins produced"
recode value_milk_produced value_eggs_produced value_other_produced (0=.)
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_livestock_products", replace
 

*Sales (live animals)
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC6A.dta", clear
ren LiveStockID livestock_code
ren s6aq14b income_live_sales 
ren s6aq14a number_sold 
ren s6aq15 number_slaughtered 


ren s6aq13b value_livestock_purchases
recode income_live_sales number_sold number_slaughtered /*number_slaughtered_sold income_slaughtered*/ value_livestock_purchases (.=0)
gen price_per_animal = income_live_sales / number_sold
lab var price_per_animal "Price of live animale sold"
recode price_per_animal (0=.) 
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhids.dta"
drop if _merge==2
drop _merge
keep hhid weight region district livestock_code number_sold income_live_sales number_slaughtered /*number_slaughtered_sold income_slaughtered*/ price_per_animal value_livestock_purchases
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_livestock_sales", replace



use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district livestock_code: egen obs_district = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district livestock_code obs_district)
ren price_per_animal price_median_district
lab var price_median_district "Median price per unit for this livestock in the district"
lab var obs_district "Number of sales observations for this livestock in the district"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_prices_district.dta", replace
use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_animal [aw=weight], by (region livestock_code obs_region)
ren price_per_animal price_median_region
lab var price_median_region "Median price per unit for this livestock in the region"
lab var obs_region "Number of sales observations for this livestock in the region"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_prices_region.dta", replace
use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_animal [aw=weight], by (livestock_code obs_country)
ren price_per_animal price_median_country
lab var price_median_country "Median price per unit for this livestock in the country"
lab var obs_country "Number of sales observations for this livestock in the country"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_prices_country.dta", replace

use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_livestock_sales", clear
*merge m:1 region district ward ea livestock_code using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_prices_ea.dta", nogen
*merge m:1 region district ward livestock_code using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_prices_ward.dta", nogen
merge m:1 region district livestock_code using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_prices_district.dta", nogen
merge m:1 region livestock_code using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_prices_region.dta", nogen
merge m:1 livestock_code using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_prices_country.dta", nogen
*replace price_per_animal = price_median_ea if price_per_animal==. & obs_ea >= 10
*replace price_per_animal = price_median_ward if price_per_animal==. & obs_ward >= 10
replace price_per_animal = price_median_district if price_per_animal==. & obs_district >= 10
replace price_per_animal = price_median_region if price_per_animal==. & obs_region >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_lvstck_sold = price_per_animal * number_sold
gen value_slaughtered = price_per_animal * number_slaughtered


gen value_livestock_sales = value_lvstck_sold /*+ value_slaughtered_sold */

collapse (sum) value_livestock_sales value_livestock_purchases value_lvstck_sold value_slaughtered, by (hhid)
drop if hhid==""
lab var value_livestock_sales "Value of livestock sold (live and slaughtered)"
lab var value_livestock_purchases "Value of livestock purchases (seems to span only the agricutlural season, not the year)"
lab var value_slaughtered "Value of livestock slaughtered (with slaughtered livestock that weren't sold valued at local median prices for live animal sales)"
lab var value_lvstck_sold "Value of livestock sold live" 
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_sales", replace
 
 