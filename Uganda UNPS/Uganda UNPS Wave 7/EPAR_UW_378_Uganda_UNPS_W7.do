
/*
-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of a set of agricultural development indicators 
				  using the Uganda National Panel Survey (UNPS) LSMS-ISA Wave 7 (2018-19).
*Author(s)		: TBC

*Acknowledgments: We acknowledge the helpful contributions of members of the World Bank's LSMS-ISA team, the FAO's RuLIS team, IFPRI, IRRI, 
				  and the Bill & Melinda Gates Foundation Agricultural Development Data and Policy team in discussing indicator construction decisions. 
				  All coding errors remain ours alone.
*Date			: This  Version - January 31, 2023
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
*The results are outputted in the excel file "Uganda_NPS_W7_summary_stats.xlsx" in the "/uganda-wave7-2018-19/final data" folder. // not yet available
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
*JHG: not sure what to set inflation rate at (rate between which years? Depends on the purpose of this global). Once that is known, change comment above

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
ren h2q4 relhead 

ren h2q3 gender
gen fhh = (relhead==1 & gender==2) 
collapse (sum) hh_members (max) fhh, by (hhid)	

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
label var season "Season = 1 if 2nd cropping season of 2017, 2 if 1st cropping season of 2018" // need to check again
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

*First decision-maker variables 
gen individ = s3aq03_3
replace individ = s3bq03_3 if individ == "." & s3bq03_3 != "."

merge m:1 hhid individ using  "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_person_ids.dta", gen(dm1_merge) keep(1 3)		// Dropping unmatched from using
gen dm1_female = female

drop female indiv

* multiple decision makers 
gen dm_gendermult=s3aq03_2==2
replace dm_gendermult=s3bq03_2==2 if dm_gendermult==0

*Second decision-maker variables // data only available on primary decision maker in wave 7


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
replace is_plot_intercropped=1 if per_intercropped!=.  
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
    *duplicates report hhid parcel_id
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

*Combine hhid and livestock data into a single sheet
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
	merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_areas.dta", nogen keep(1 3) // terrible merge, only 1325 matched
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
	
	
	* Note: crop loss and replanting not reported in the UG dta.
	
	
		
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

* Note: expected harvest not reported in UG data

	
	

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
 
 
 
 * Note: sub sections yet to be coded
     * Crop prices
	 * Plot value of crop production
	 * Crop values for inputs in agricultural product processing (self-employment)
     * Crops lost post-harvest



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


// PA: no wages reported in season 2
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
gen formal_land_rights = (s2aq23==1 | s2aq23==2 | s2aq23==3 | a2aq32==1)	// Note: no data on formal ownership reported in season 2

/*
*Individual level (for women) // no owner reported in season 2
replace ag3a_29_1 = ag3b_29_1 if ag3a_29_1==.
replace ag3a_29_2 = ag3b_29_2 if ag3a_29_2==.
*/

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


*Expenses  * Note: section missing in the raw data



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
*ren lf08_03_2 quantity_month_unit
*replace quantity_month_unit = 3 if livestock_code==1
*replace quantity_month_unit = 1 if livestock_code==2
*replace quantity_month_unit = 3 if livestock_code==3
recode months_produced quantity_month (.=0)
gen quantity_produced = months_produced * quantity_month /* Units are pieces for eggs & skin, liters for honey */
lab var quantity_produced "Quantity of this product produed in past year"
ren s8cq03 sales_quantity
*ren lf08_05_2 sales_unit

*replace sales_unit = 3 if livestock_code==101
*replace sales_unit = 1 if livestock_code==102
*replace sales_unit = 3 if livestock_code==103
ren s8cq05 earnings_sales

recode sales_quantity months_produced quantity_month earnings_sales (.=0)
gen price_per_unit = earnings_sales / sales_quantity
keep hhid livestock_code quantity_produced price_per_unit earnings_sales
*replace livestock_code = 21 if livestock_code==1
*replace livestock_code = 22 if livestock_code==2
*replace livestock_code = 23 if livestock_code==3
*label define livestock_code_label 21 "Eggs" 
*label values livestock_code livestock_code_label
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

* Note: No ea and ward in the W7 UG data 

/*
use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_products", clear
keep if price_per_unit !=. 
gen observation = 1
bys region district ward ea livestock_code: egen obs_ea = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district ward ea livestock_code obs_ea)
ren price_per_unit price_median_ea
lab var price_median_ea "Median price per unit for this livestock product in the ea"
lab var obs_ea "Number of sales observations for this livestock product in the ea"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_products_prices_ea.dta", replace
use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region district ward livestock_code: egen obs_ward = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district ward livestock_code obs_ward)
ren price_per_unit price_median_ward
lab var price_median_ward "Median price per unit for this livestock product in the ward"
lab var obs_ward "Number of sales observations for this livestock product in the ward"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_products_prices_ward.dta", replace
*/

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
 
 * Note: sale of dung not reported in UG data  
 

*Sales (live animals)
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC6A.dta", clear
ren LiveStockID livestock_code
ren s6aq14b income_live_sales 
ren s6aq14a number_sold 
ren s6aq15 number_slaughtered 
*ren lf02_32 number_slaughtered_sold // variable not reported in UG data

*replace number_slaughtered = number_slaughtered_sold if number_slaughtered < number_slaughtered_sold  
*ren lf02_33 income_slaughtered
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



*Implicit prices // to check 
/*
use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district ward ea livestock_code: egen obs_ea = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district ward ea livestock_code obs_ea)
ren price_per_animal price_median_ea
lab var price_median_ea "Median price per unit for this livestock in the ea"
lab var obs_ea "Number of sales observations for this livestock in the ea"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_prices_ea.dta", replace
use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district ward livestock_code: egen obs_ward = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district ward livestock_code obs_ward)
ren price_per_animal price_median_ward
lab var price_median_ward "Median price per unit for this livestock in the ward"
lab var obs_ward "Number of sales observations for this livestock in the ward"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_prices_ward.dta", replace
*/

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


*gen value_slaughtered_sold = price_per_animal * number_slaughtered_sold 
* gen value_slaughtered_sold = income_slaughtered 
*replace value_slaughtered_sold = income_slaughtered if (value_slaughtered_sold < income_slaughtered) & number_slaughtered!=0 /* Replace value of slaughtered animals with income from slaughtered-sales if the latter is larger */
*replace value_slaughtered = value_slaughtered_sold if (value_slaughtered_sold > value_slaughtered) & (number_slaughtered > number_slaughtered_sold) //replace value of slaughtered with value of slaughtered sold if value sold is larger
gen value_livestock_sales = value_lvstck_sold /*+ value_slaughtered_sold */

collapse (sum) value_livestock_sales value_livestock_purchases value_lvstck_sold value_slaughtered, by (hhid)
drop if hhid==""
lab var value_livestock_sales "Value of livestock sold (live and slaughtered)"
lab var value_livestock_purchases "Value of livestock purchases (seems to span only the agricutlural season, not the year)"
lab var value_slaughtered "Value of livestock slaughtered (with slaughtered livestock that weren't sold valued at local median prices for live animal sales)"
lab var value_lvstck_sold "Value of livestock sold live" 
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_sales", replace
 
 
 
*TLU (Tropical Livestock Units)
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC6A.dta", clear
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC6B.dta"
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC6C.dta"
gen lvstckid=LiveStockID
replace lvstckid=ALiveStock_Small_ID if lvstckid==. & ALiveStock_Small_ID!=.
replace lvstckid=APCode if lvstckid==. & APCode!=.

gen tlu_coefficient=0.5 if (lvstckid==1|lvstckid==2|lvstckid==3|lvstckid==4|lvstckid==5|lvstckid==6|lvstckid==7|lvstckid==8|lvstckid==9|lvstckid==10) // large ruminants 
replace tlu_coefficient=0.1 if (lvstckid==13|lvstckid==14|lvstckid==15|lvstckid==16|lvstckid==18|lvstckid==19|lvstckid==20|lvstckid==21) // sheeps, goats 
replace tlu_coefficient=0.2 if (lvstckid==17|lvstckid==22) // pigs 
replace tlu_coefficient=0.01 if (lvstckid==23|lvstckid==24|lvstckid==25|lvstckid==26|lvstckid==27) // poultry 
replace tlu_coefficient=0.3 if (lvstckid==11|lvstckid==12) // horses, donkeys/mules
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
ren lvstckid livestock_code
ren s6aq06 number_1yearago
replace number_1yearago=s6bq06 if number_1yearago==. & s6bq06!=.
replace number_1yearago=s6cq06 if number_1yearago==. & s6cq06!=.
ren s6aq03a number_t
replace number_t=s6bq03a if number_t==. & s6bq03a!=.
replace number_t=s6cq03a if number_t==. & s6cq03a!=.
gen number_today_indigenous=number_t if (inlist(livestock_code,6,7,8,9,10,11,12,18,19,20,21,22,23,26,27))
gen number_today_exotic=number_t if (inlist(livestock_code,1,2,3,4,5,13,14,15,16,17,24,25))
recode number_today_indigenous number_today_exotic (.=0)
gen number_today = number_today_indigenous + number_today_exotic
gen tlu_1yearago = number_1yearago * tlu_coefficient
gen tlu_today = number_today * tlu_coefficient


ren s6aq14b income_live_sales 
replace income_live_sales=s6bq14b if income_live_sales==. & s6bq14b!=.
replace income_live_sales=s6cq14b if income_live_sales==. & s6cq14b!=.

ren s6aq14a number_sold 
replace number_sold=s6bq14a if number_sold==. & s6bq14a!=.
replace number_sold=s6cq14a if number_sold==. & s6cq14a!=.

ren s6aq12 lost_disease
replace lost_disease=s6bq12 if lost_disease==. & s6bq12!=.
replace lost_disease=s6cq12 if lost_disease==. & s6cq12!=.

ren s6aq11 lost_injury
replace lost_injury=s6bq11 if lost_injury==. & s6bq11!=.
replace lost_injury=s6cq11 if lost_injury==. & s6cq11!=.

egen mean_12months = rowmean(number_today number_1yearago)
egen animals_lost12months = rowtotal(lost_disease lost_injury)
gen share_imp_herd_cows = number_today_exotic/(number_today) if (inlist(livestock_code,1,2,3,4,5)) // variable should be defined after summing totals at household level
gen species = (inlist(livestock_code,1,2,3,4,5,6,7,8,910)) + 2*(inlist(livestock_code,13,14,15,16,18,19,20,21)) + 3*(inlist(livestock_code,17,22)) + 4*(inlist(livestock_code,11,12)) + 5*(inlist(livestock_code,23,24,25,26,27))
recode species (0=.)
la def species 1 "Large ruminants (cows, buffalos)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses, donkeys)" 5 "Poultry"
la val species species

preserve
*Now to household level
*First, generating these values by species
collapse (firstnm) share_imp_herd_cows (sum) number_today number_1yearago animals_lost12months lost_disease number_today_exotic lvstck_holding=number_today, by(hhid species)
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
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_herd_characteristics", replace
restore

gen price_per_animal = income_live_sales / number_sold
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhids.dta", nogen keep(1 3)
*merge m:1 region district ward ea livestock_code using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_prices_ea.dta", nogen
*merge m:1 region district ward livestock_code using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_prices_ward.dta", nogen
merge m:1 region district livestock_code using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_prices_district.dta", nogen
merge m:1 region livestock_code using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_prices_region.dta", nogen
merge m:1 livestock_code using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_prices_country.dta", nogen
recode price_per_animal (0=.)
*replace price_per_animal = price_median_ea if price_per_animal==. & obs_ea >= 10
*replace price_per_animal = price_median_ward if price_per_animal==. & obs_ward >= 10
replace price_per_animal = price_median_district if price_per_animal==. & obs_district >= 10
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
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_TLU.dta", replace



*Livestock income // to check 

/*
use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_sales", clear
merge 1:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_livestock_products", nogen
*merge 1:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_dung.dta", nogen
merge 1:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_expenses", nogen
merge 1:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_TLU.dta", nogen
gen livestock_income = value_lvstck_sold + value_slaughtered - value_livestock_purchases /*
*/ + (value_milk_produced + value_eggs_produced + value_other_produced) /*
*/ - (cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_water_livestock)
lab var livestock_income "Net livestock income"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_income", replace
*/


 
********************************************************************************
*FISH INCOME // systematic fishing dta not collected in Uganda 
********************************************************************************


********************************************************************************
*SELF-EMPLOYMENT INCOME // PA: no profits recorded in the labour module 
********************************************************************************
use "${Uganda_NPS_W7_raw_data}/HH/GSEC8", clear 


ren s8q30 months_activ
ren s8q78 monthly_profit
gen annual_selfemp_profit = monthly_profit * months_activ if s8q22==3
recode annual_selfemp_profit (.=0)
collapse (sum) annual_selfemp_profit, by (hhid)
lab var annual_selfemp_profit "Estimated annual net profit from self-employment over previous 12 months"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_self_employment_income.dta", replace



********************************************************************************
*NON-AG WAGE INCOME
********************************************************************************
use "${Uganda_NPS_W7_raw_data}/HH/GSEC8", clear
ren PID pid 
ren s8q04 wage_yesno
ren s8q30 number_months
ren s8q30b number_weeks 
* ren number_hours // no single variable captures this in the UG data but can be calculated 
ren s8q78 most_recent_payment
replace most_recent_paymen=s8q31a if most_recent_paymen==0 & s8q31a!=. & s8q31a!=0
ren s8q31c payment_period

gen non_ag_wage= 1 if (h8q19b_oneDigit==1 | h8q19b_oneDigit==2 | h8q19b_oneDigit==3 | h8q19b_oneDigit==4 | h8q19b_oneDigit==5 | h8q19b_oneDigit==6 | h8q19b_oneDigit==8 | h8q19b_oneDigit==9 | h8q19b_oneDigit==10)

replace most_recent_payment=. if non_ag_wage!=1

* ren s8q45b most_recent_payment_other // presumably this was to capture payment in kind which was not captured in the UGA data
* ren hh_e28_2 payment_period_other

ren s8q37 secondary_wage_yesno
ren s8q80 secwage_most_recent_payment
replace secwage_most_recent_payment=s8q45b if secwage_most_recent_payment==0 & s8q45b!=. & s8q45b!=0
ren s8q45c secwage_payment_period

* ren hh_e46_1 secwage_recent_payment_other // see comment for primary work above 
* ren hh_e46_2 secwage_payment_period_other
* ren hh_e50 secwage_hours_pastweek

gen annual_salary_cash = (number_months*most_recent_payment) // most recent payment is reported for the whole of last month
recode annual_salary_cash (.=0)
gen annual_salary = annual_salary_cash 

collapse (sum) annual_salary, by (hhid)
lab var annual_salary "Annual earnings from non-agricultural wage"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_wage_income.dta", replace


********************************************************************************
*AG WAGE INCOME
********************************************************************************
use "${Uganda_NPS_W7_raw_data}/HH/GSEC8", clear
ren PID pid 
ren s8q04 wage_yesno
ren s8q30 number_months
ren s8q30b number_weeks 
ren s8q78 most_recent_payment
replace most_recent_paymen=s8q31a if most_recent_paymen==0 & s8q31a!=. & s8q31a!=0
ren s8q31c payment_period
gen agwage = 1 if (h8q19b_oneDigit==7)
replace most_recent_payment=. if agwage!=1
gen secagwage = 1 if (h8q38b_oneDigit==5) 

gen annual_salary_cash = (number_months*most_recent_payment)

recode annual_salary_cash (.=0)
gen annual_salary = annual_salary_cash
collapse (sum) annual_salary, by (hhid)
ren annual_salary annual_salary_agwage
lab var annual_salary_agwage "Annual earnings from agricultural wage"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_agwage_income.dta", replace


********************************************************************************
*OTHER INCOME // income sources identified but amount of income not recorded 
********************************************************************************
use "${Uganda_NPS_W7_raw_data}/HH/GSEC7_2", clear
keep if s11q04==1
ta IncomeSource, gen(income_)
ren income_1 rental_income
replace rental_income=income_2 if rental_income==0 & income_2==1
replace rental_income=income_3 if rental_income==0 & income_3==1
replace rental_income=income_4 if rental_income==0 & income_4==1
replace rental_income=income_5 if rental_income==0 & income_5==1
replace rental_income=income_6 if rental_income==0 & income_6==1
replace rental_income=income_7 if rental_income==0 & income_7==1
replace rental_income=income_11 if rental_income==0 & income_11==1

ren income_8 pension_income
ren income_9 remittance_income
replace remittance_income=income_10 if remittance_income==1 & income_10==1

ren income_12 other_income


recode rental_income pension_income other_income remittance_income (.=0)


collapse (sum) rental_income pension_income other_income remittance_income, by (hhid)
lab var rental_income "Estimated income from rentals of buildings, tools, land, transport animals over previous 12 months"
lab var pension_income "Estimated income from a pension AND INTEREST over previous 12 months"
lab var other_income "Estimated income from any OTHER source over previous 12 months"
lab var remittance_income "Estimated income from remittances over previous 12 months"
*lab var assistance_income "Estimated income from a food aid, food-for-work, etc. over previous 12 months"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_other_income.dta", replace


use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC2A.dta", clear 
gen season=1
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC2B.dta" 
replace season = 2 if season == .
ren parcelID parcel_id
ren s2aq14 land_rental_income_mainseason // income recoded in main season covers both seasons 
recode land_rental_income_mainseason (.=0)
gen land_rental_income = land_rental_income_mainseason 
collapse (sum) land_rental_income, by (hhid)
lab var land_rental_income "Estimated income from renting out land over previous 12 months"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_land_rental_income.dta", replace


********************************************************************************
*FARM SIZE / LAND SIZE
********************************************************************************
*Determining whether crops were grown on a plot
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC4A.dta", clear 
gen season=1
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC4B.dta" 
replace season = 2 if season == .
ren parcelID parcel_id
ren pltid plot_id
drop if plot_id==.
gen crop_grown = 1 
collapse (max) crop_grown, by(hhid plot_id)
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_crops_grown.dta", replace

use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC2A.dta", clear 
gen season=1
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC2B.dta" 
replace season = 2 if season == .
ren parcelID parcel_id
gen cultivated = (s2aq11a==1 | s2aq11a==2 | s2aq11b==1 | s2aq11b==2)
replace cultivated = (a2bq12a==1 | a2bq12a==2 | a2bq12b==1 | a2bq12b==2) if (s2aq11a==. & s2aq11b==.)
replace cultivated=. if cultivated==0 & (s2aq11a==. & s2aq11b==. & a2bq12a==. & a2bq12b==.)
collapse (max) cultivated, by (hhid parcel_id)
lab var cultivated "1= Parcel was cultivated in this data set"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_parcels_cultivated.dta", replace


use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC2A.dta", clear 
gen season=1
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC2B.dta" 
replace season = 2 if season == .
ren parcelID parcel_id
gen cultivated = (s2aq11a==1 | s2aq11a==2 | s2aq11b==1 | s2aq11b==2)
replace cultivated = (a2bq12a==1 | a2bq12a==2 | a2bq12b==1 | a2bq12b==2) if (s2aq11a==. & s2aq11b==.)
replace cultivated=. if cultivated==0 & (s2aq11a==. & s2aq11b==. & a2bq12a==. & a2bq12b==.)
keep if cultivated==1
gen area_acres_meas=s2aq5 if (s2aq5!=. & s2aq5!=0)
replace area_acres_meas=s2aq4 if area_acres_meas==. & (s2aq4!=. & s2aq4!=0)
replace area_acres_meas=s2aq05 if area_acres_meas==. & (s2aq05!=. & s2aq05!=0)
replace area_acres_meas=s2aq04 if area_acres_meas==. & (s2aq04!=. & s2aq04!=0)
collapse (sum) area_acres_meas, by (hhid)
ren area_acres_meas farm_area
replace farm_area = farm_area * (1/2.47105) /* Convert to hectares */
lab var farm_area "Land size (denominator for land productivitiy), in hectares" 
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_land_size.dta", replace


*All agricultural land 
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC2A.dta", clear 
gen season=1
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC2B.dta" 
replace season = 2 if season == .
ren parcelID parcel_id
gen rented_out = (s2aq11a==3 | s2aq11b==3 | a2bq12a==3 | a2bq12b==3)
replace rented_out=. if rented_out==0 & (s2aq11a==. & s2aq11b==. & a2bq12a==. & a2bq12b==.)
gen other_land_use= (s2aq11a==7 | s2aq11a==8 | s2aq11b==7 | s2aq11b==8 | a2bq12a==6 | a2bq12a==7 | a2bq12b==6 | a2bq12b==7)
replace other_land_use=. if other_land_use==0 & (s2aq11a==. & s2aq11b==. & a2bq12a==. & a2bq12b==.)
drop if rented_out==1 | other_land_use==1
gen agland = 1  
collapse (max) agland, by (hhid)
merge 1:m hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_crops_grown.dta"
drop if _m!=3
drop _m crop_grown
lab var agland "1= Parcel was used for crop cultivation or left fallow in this past year (forestland and other uses excluded)"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_parcels_agland.dta", replace


use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_land_size.dta", clear
merge 1:m hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_parcels_agland.dta"
drop if _merge==2
collapse (mean) farm_area, by (hhid)
ren farm_area farm_size_agland
lab var farm_size_agland "Land size in hectares, including all plots cultivated or left fallow" 
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_farmsize_all_agland.dta", replace


use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC2A.dta", clear 
gen season=1
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC2B.dta" 
replace season = 2 if season == .
ren parcelID parcel_id
gen rented_out = (s2aq11a==3 | s2aq11b==3 | a2bq12a==3 | a2bq12b==3)
replace rented_out=. if rented_out==0 & (s2aq11a==. & s2aq11b==. & a2bq12a==. & a2bq12b==.)
drop if rented_out==1 
gen parcel_held = 1  
collapse (sum) parcel_held, by (hhid)
lab var parcel_held "1= Parcel was NOT rented out in the main season" // confusion of parcel with plot 
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_parcels_held.dta", replace


use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC2A.dta", clear 
gen season=1
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC2B.dta" 
replace season = 2 if season == .
ren parcelID parcel_id
gen rented_out = (s2aq11a==3 | s2aq11b==3 | a2bq12a==3 | a2bq12b==3)
replace rented_out=. if rented_out==0 & (s2aq11a==. & s2aq11b==. & a2bq12a==. & a2bq12b==.)
drop if rented_out==1 
gen area_acres_meas=s2aq5 if (s2aq5!=. & s2aq5!=0)
replace area_acres_meas=s2aq4 if area_acres_meas==. & (s2aq4!=. & s2aq4!=0)
replace area_acres_meas=s2aq05 if area_acres_meas==. & (s2aq05!=. & s2aq05!=0)
replace area_acres_meas=s2aq04 if area_acres_meas==. & (s2aq04!=. & s2aq04!=0)
collapse (sum) area_acres_meas, by (hhid)
ren area_acres_meas land_size
replace land_size = land_size * (1/2.47105) /* Convert to hectares */
lab var land_size "Land size in hectares, including all plots listed by the household except those rented out" 
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_land_size_all.dta", replace

*Total land holding including cultivated and rented out
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC2A.dta", clear 
gen season=1
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC2B.dta" 
replace season = 2 if season == .
ren parcelID parcel_id
gen area_acres_meas=s2aq5 if (s2aq5!=. & s2aq5!=0)
replace area_acres_meas=s2aq4 if area_acres_meas==. & (s2aq4!=. & s2aq4!=0)
replace area_acres_meas=s2aq05 if area_acres_meas==. & (s2aq05!=. & s2aq05!=0)
replace area_acres_meas=s2aq04 if area_acres_meas==. & (s2aq04!=. & s2aq04!=0)
collapse (sum) area_acres_meas, by (hhid)
ren area_acres_meas land_size_total
replace land_size_total = land_size_total * (1/2.47105) /* Convert to hectares */
lab var land_size_total "Total land size in hectares, including rented in and rented out plots"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_land_size_total.dta", replace


********************************************************************************
*OFF-FARM HOURS
********************************************************************************
use "${Uganda_NPS_W7_raw_data}/HH/GSEC8", clear
ren PID pid 
egen primary_hours = rowtotal (s8q36a s8q36b s8q36c s8q36d s8q36e s8q36f s8q36g) if (s8q04==1 | s8q06==1 | s8q08==1 | s8q10==1) & s8q22!=6
egen secondary_hours = rowtotal(s8q43a s8q43b s8q43c s8q43d s8q43e s8q43f s8q43g) if h8q38b_oneDigit!=5 & h8q38b_oneDigit!=.
egen off_farm_hours = rowtotal(primary_hours secondary_hours) if (primary_hours!=. | secondary_hours!=.)
gen off_farm_any_count = off_farm_hours!=0 if off_farm_hours!=.
gen member_count = 1
collapse (sum) off_farm_hours off_farm_any_count member_count, by(hhid)
la var member_count "Number of HH members age 5 or above"
la var off_farm_any_count "Number of HH members with positive off-farm hours"
la var off_farm_hours "Total household off-farm hours"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_off_farm_hours.dta", replace


********************************************************************************
*FARM LABOR
********************************************************************************
*Family labor // family labor days data missing in this section 
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC3A.dta", clear 
ren parcelID parcel_id
ren pltid plot_id
drop if plot_id==.
ren s3aq35a days_hired_men
ren s3aq35b days_hired_women
ren s3aq35c days_hired_children
recode days_hired_men days_hired_women days_hired_children (.=0)
gen days_hired_mainseason = days_hired_men + days_hired_women + days_hired_children
collapse (sum) days_hired_mainseason /*days_famlabor_mainseason*/, by (hhid plot_id)
lab var days_hired_mainseason  "Workdays for hired labor (crops) in main growing season"
*lab var days_famlabor_mainseason  "Workdays for family labor (crops) in main growing season"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_farmlabor_mainseason.dta", replace


use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC3B.dta", clear
ren parcelID parcel_id
ren pltid plot_id
drop if plot_id==.
*ren s3aq35a days_hired_men
ren s3bq35b days_hired_women
*ren s3aq35c days_hired_children
recode /*days_hired_men days_hired_children */ days_hired_women (.=0)
gen days_hired_shortseason = /*days_hired_men + days_hired_children*/ days_hired_women
collapse (sum) days_hired_shortseason /*days_famlabor_shortseason*/, by (hhid plot_id)
lab var days_hired_shortseason  "Workdays for hired labor (crops) in short growing season"
*lab var days_famlabor_shortseason  "Workdays for family labor (crops) in short growing season"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_farmlabor_shortseason.dta", replace



*Hired Labor
use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_farmlabor_mainseason.dta", clear
merge 1:1 hhid plot_id using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_farmlabor_shortseason.dta", nogen 

recode days*  (.=0)
collapse (sum) days*, by(hhid plot_id)
egen labor_hired =rowtotal(days_hired_mainseason days_hired_shortseason)
*egen labor_family=rowtotal(days_famlabor_mainseason  days_famlabor_shortseason)
*egen labor_total = rowtotal(days_hired_mainseason days_famlabor_mainseason days_hired_shortseason days_famlabor_shortseason)
*lab var labor_total "Total labor days (family, hired, or other) allocated to the farm"
lab var labor_hired "Total labor days (hired) allocated to the farm"
*lab var labor_family "Total labor days (family) allocated to the farm"
*lab var labor_total "Total labor days allocated to the farm"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_family_hired_labor.dta", replace
collapse (sum) labor_*, by(hhid)
*lab var labor_total "Total labor days (family, hired, or other) allocated to the farm"
lab var labor_hired "Total labor days (hired) allocated to the farm"
*lab var labor_family "Total labor days (family) allocated to the farm"
*lab var labor_total "Total labor days allocated to the farm" 
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_family_hired_labor.dta", replace




********************************************************************************
*VACCINE USAGE // Note: section raw data missing
********************************************************************************

********************************************************************************
*ANIMAL HEALTH - DISEASES  // Note: section raw data missing
********************************************************************************

********************************************************************************
*LIVESTOCK WATER, FEEDING, AND HOUSING  // Note: section raw data missing
********************************************************************************

********************************************************************************
*USE OF INORGANIC FERTILIZER
********************************************************************************
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC3A.dta", clear 
gen season=1
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC3B.dta" 
replace season = 2 if season == .
ren parcelID parcel_id
ren pltid plot_id

gen use_inorg_fert=(s3aq13==1 | s3bq13==1) if (s3aq13!=. | s3bq13!=.)
collapse (max) use_inorg_fert, by (hhid)
lab var use_inorg_fert "1 = Household uses inorganic fertilizer"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_fert_use.dta", replace
  
  
*Fertilizer use by farmers (a farmer is an individual listed as plot manager)
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC3A.dta", clear 
gen season=1
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC3B.dta" 
replace season = 2 if season == .
ren parcelID parcel_id
ren pltid plot_id
drop if plot_id==.

gen all_use_inorg_fert=(s3aq13==1 | s3bq13==1) if (s3aq13!=. | s3bq13!=.)

*keep hhid s3aq03_3 s3bq03_3 all_use_inorg_fert 
ren s3aq03_3 farmerid
replace farmerid= s3bq03_3 if farmerid=="" 

* Note: no second/third decision maker reported in W7 


collapse (max) all_use_inorg_fert, by(hhid farmerid)
drop if farmerid=="" 
ren farmerid individ

merge 1:1 hhid individ using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_person_ids.dta"
drop if _m==2
drop _m 
keep hhid individ all_use_inorg_fert
lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"

gen farm_manager=1 if individ!=""
recode farm_manager (.=0)
lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_farmer_fert_use.dta", replace


********************************************************************************
*USE OF IMPROVED SEED
********************************************************************************
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC4A.dta", clear 
gen season=1
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC4B.dta" 
replace season = 2 if season == .
ren parcelID parcel_id
ren pltid plot_id
ren cropID cropcode
drop if plot_id==.
gen imprv_seed_use= (s4aq13==2) if s4aq13!=.
replace imprv_seed_use=s4bq13==2 if imprv_seed_use==. & s4bq13!=.


*Use of seed by crop
forvalues k=1/$nb_topcrops {
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	
	gen imprv_seed_`cn'=imprv_seed_use if cropcode==`c'
	gen hybrid_seed_`cn'=.
}
collapse (max) imprv_seed_* hybrid_seed_*, by(hhid)
lab var imprv_seed_use "1 = Household uses improved seed"
foreach v in $topcropname_area {
	lab var imprv_seed_`v' "1= Household uses improved `v' seed"
	lab var hybrid_seed_`v' "1= Household uses improved `v' seed"
}
*Replacing permanent crop seed information with missing because this section does not ask about permanent crops 
replace imprv_seed_cassav = . 
replace imprv_seed_banana = . 

save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_improvedseed_use.dta", replace
  
  
  
  
*Seed adoption by farmers ( a farmer is an individual listed as plot manager)
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC4A.dta", clear 
gen season=1
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC4B.dta" 
replace season = 2 if season == .
ren parcelID parcel_id
ren pltid plot_id
ren cropID cropcode
drop if plot_id==.
gen imprv_seed_use= (s4aq13==2) if s4aq13!=.
replace imprv_seed_use=s4bq13==2 if imprv_seed_use==. & s4bq13!=.
ren imprv_seed_use all_imprv_seed_use
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_farmer_improvedseed_use_temp.dta", replace



*Use of seed by crop
forvalues k=1/$nb_topcrops {
	use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_farmer_improvedseed_use_temp.dta", clear
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	*Adding adoption of improved maize seeds
	gen all_imprv_seed_`cn'=all_imprv_seed_use if cropcode==`c'  
	gen all_hybrid_seed_`cn' =. 
	*We also need a variable that indicates if farmer (plot manager) grows crop
	gen `cn'_farmer= cropcode==`c' 
	ren s4aq06_1 individ
	replace individ= s4bq06_1 if individ==""
	
	collapse (max) all_imprv_seed_use  all_imprv_seed_`cn' all_hybrid_seed_`cn'  `cn'_farmer, by (hhid individ)
	save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_farmer_improvedseed_use_temp_`cn'.dta", replace
}

*Combining all crop disaggregated files together
foreach v in $topcropname_area {
	merge 1:1 hhid individ all_imprv_seed_use using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_farmer_improvedseed_use_temp_`v'.dta", nogen
}	 

drop if individ==""
merge 1:1 hhid individ using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_person_ids.dta", nogen
lab var all_imprv_seed_use "1 = Individual farmer (plot manager) uses improved seeds"
foreach v in $topcropname_area {
	lab var all_imprv_seed_`v' "1 = Individual farmer (plot manager) uses improved seeds - `v'"
	lab var all_hybrid_seed_`v' "1 = Individual farmer (plot manager) uses hybrid seeds - `v'"
	lab var `v'_farmer "1 = Individual farmer (plot manager) grows `v'"
}

gen farm_manager=1 if individ!=""
recode farm_manager (.=0)
lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
*Replacing permanent crop seed information with missing because this section does not ask about permanent crops
replace all_imprv_seed_cassav = . 
replace all_imprv_seed_banana = . 
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_farmer_improvedseed_use.dta", replace





********************************************************************************
*REACHED BY AG EXTENSION
********************************************************************************
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC9B.dta", clear

gen receive_advice=(h9q03a__1==1 | h9q03a__2==1 | h9q03a__3==1 | h9q03a__4==1 | h9q03a__5==1 | h9q03a__7==1 | h9q03a__6==1) if (h9q03a__1!=. | h9q03a__2!=. | h9q03a__3!=. | h9q03a__4!=. | h9q03a__5!=. | h9q03a__7!=. | h9q03a__6!=.) // ag12b_08
preserve
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC9A.dta", clear
ren source_ID sourceid
tempfile UG_advice2
save `UG_advice2'
restore
append using  `UG_advice2' // why append?? these are not two seasons??

**Government Extension
gen advice_gov = (sourceid==1)
replace advice_gov = (sourceid==7) if advice_gov==0 

* Input supplier
gen advice_input_sup=(sourceid==2)
**NGO
gen advice_ngo = (sourceid==3)
**Cooperative/ Farmer Association
gen advice_coop = (sourceid==4)
**Large Scale Farmer
gen advice_farmer =(sourceid==5)
**Other
gen advice_other = (sourceid==6)

// not an option in UG data
/*
**Radio
gen advice_radio = (sourceid==5 & receive_advice==1)
**Publication 
gen advice_pub = (sourceid==6 & receive_advice==1)
**Neighbor
gen advice_neigh = (sourceid==7 & receive_advice==1)
*/

**advice on prices from extension
*Five new variables  ext_reach_all, ext_reach_public, ext_reach_private, ext_reach_unspecified, ext_reach_ict  
gen ext_reach_public=(advice_gov==1)
gen ext_reach_private=(advice_ngo==1 | advice_coop==1 | advice_input_sup==1 | advice_farmer==1)
gen ext_reach_unspecified=(advice_other==1)
*gen ext_reach_ict=(advice_radio==1)
gen ext_reach_all=(ext_reach_public==1 | ext_reach_private==1 | ext_reach_unspecified==1)
collapse (max) ext_reach_* , by (hhid)
lab var ext_reach_all "1 = Household reached by extensition services - all sources"
lab var ext_reach_public "1 = Household reached by extensition services - public sources"
lab var ext_reach_private "1 = Household reached by extensition services - private sources"
lab var ext_reach_unspecified "1 = Household reached by extensition services - unspecified sources"
*lab var ext_reach_ict "1 = Household reached by extensition services through ICT"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_any_ext.dta", replace
 

********************************************************************************
*USE OF FORMAL FINANCIAL SERVICES // needs to be checked again; mixed borrowing with use?
********************************************************************************
use "${Uganda_NPS_W7_raw_data}//HH/GSEC7_1", clear
append using "${Uganda_NPS_W7_raw_data}//HH/GSEC7_4"

ta CB16__1, gen(bank)
ren bank2 borrow_bank


ta CB16__2, gen (micro1_)
ta CB16__3, gen (micro2_)
ta CB16__4, gen (micro3_)
ta CB16__5, gen (micro4_)
ta CB16__6, gen (micro5_)
ta CB16__7, gen (micro6_)
ta CB16__8, gen (micro7_)
ta CB16__10, gen (micro8_)
ta CB16__12, gen (micro10_)
ta CB16__13, gen (micro11_)
ta CB16__14, gen (micro12_)

ren micro1_2 borrow_micro
replace borrow_micro=micro2_2 if borrow_micro==0 & micro2_2==1
replace borrow_micro=micro3_2 if borrow_micro==0 & micro3_2==1
replace borrow_micro=micro4_2 if borrow_micro==0 & micro4_2==1
replace borrow_micro=micro5_2 if borrow_micro==0 & micro5_2==1
replace borrow_micro=micro6_2 if borrow_micro==0 & micro6_2==1
replace borrow_micro=micro7_2 if borrow_micro==0 & micro7_2==1
replace borrow_micro=micro8_2 if borrow_micro==0 & micro8_2==1
replace borrow_micro=micro10_2 if borrow_micro==0 & micro10_2==1
replace borrow_micro=micro11_2 if borrow_micro==0 & micro11_2==1
replace borrow_micro=micro12_2 if borrow_micro==0 & micro12_2==1

ta CB16__97, gen (fin1_)
ta CB16__96, gen (fin2_)
ren fin1_2 borrow_other_fin
replace borrow_other_fin=fin2_2 if borrow_other_fin==0 & fin2_2==1


ta CB16__9, gen(ngo)
ren ngo2 borrow_ngo


gen use_MM=CB06H==1
gen use_fin_serv_bank= CB06B==1
gen use_fin_serv_credit= borrow_bank==1 | borrow_micro==1 | borrow_ngo==1  | borrow_other_fin==1
gen use_fin_serv_digital=use_MM==1

gen use_fin_serv_others= CB06X==1 


gen use_fin_serv_all=use_fin_serv_bank==1 | use_fin_serv_credit==1 | use_fin_serv_digital==1 | use_fin_serv_others==1  | use_fin_serv_credit==1

recode use_fin_serv* (.=0)

collapse (max) use_fin_serv_*, by (hhid)
lab var use_fin_serv_all "1= Household uses formal financial services - all types"
lab var use_fin_serv_bank "1= Household uses formal financial services - bank accout"
lab var use_fin_serv_credit "1= Household uses formal financial services - credit"
*lab var use_fin_serv_insur "1= Household uses formal financial services - insurance"
lab var use_fin_serv_digital "1= Household uses formal financial services - digital"
lab var use_fin_serv_others "1= Household uses formal financial services - others"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_fin_serv.dta", replace


********************************************************************************
*MILK PRODUCTIVITY
********************************************************************************
*Total production
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC8B.dta", clear
ren AGroup_ID livestock_code 
keep if livestock_code==101 | livestock_code==102
ren s8bq01 milk_animals
ren s8bq02 months_milked
ren s8bq03 liters_day 
gen liters_per_largeruminant = (liters_day*365*(months_milked/12))	
keep if milk_animals!=0 & milk_animals!=.
drop if liters_per_largeruminant==.
keep hhid milk_animals months_milked liters_per_largeruminant 
lab var milk_animals "Number of large ruminants that was milk (household)"
lab var months_milked "Average months milked in last year (household)"
lab var liters_per_largeruminant "average quantity (liters) per year (household)"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_milk_animals.dta", replace


********************************************************************************
*EGG PRODUCTIVITY
********************************************************************************

use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC6C.dta", clear
gen poultry_owned = s6cq03a if (APCode==1 | APCode==2 | APCode==3 | APCode==4)
collapse (sum) poultry_owned, by(hhid)
tempfile eggs_animals_hh 
save `eggs_animals_hh'

use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC8C.dta", clear	
gen eggs_months = s8cq01/3	// number of layers was reported for the last three months thus the need to divide by 3 to get monthly total				
gen eggs_per_month = s8cq02/3	// number of eggs laid was reported for the last three months thus the need to divide by 3 to get monthly total			
collapse (sum) eggs_months eggs_per_month, by(hhid)
gen eggs_total_year = eggs_month*eggs_per_month*12 // multiply by 12 to get the annual total 
merge 1:1 hhid using  `eggs_animals_hh', nogen keep(1 3)			
keep hhid eggs_months eggs_per_month eggs_total_year poultry_owned 
lab var eggs_months "Number of months eggs were produced (household)"
lab var eggs_per_month "Number of months eggs that were produced per month (household)"
lab var eggs_total_year "Total number of eggs that was produced (household)"
lab var poultry_owned "Total number of poulty owned (household)"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_eggs_animals.dta", replace




********************************************************************************
*LAND RENTAL // PA: Need to check again. Variable created under crop expenses above 
********************************************************************************

* LRS *
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC4A.dta", clear 
gen season=1
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC4B.dta" 
replace season = 2 if season == .

ren parcelID parcel_id
ren pltid plot_id
gen plot_are=s4aq07 if s4aq07!=.
replace plot_are=s4bq07 if plot_are==. & s4bq07!=.

gen plot_ha = s4aq07/2.47105						
keep plot_ha *_id hhid
collapse (sum) plot_ha, by (hhid)
lab var plot_ha "Plot area in hectare" 
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_area_lrs.dta", replace

use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_decision_makers.dta", clear // to be used to add plot managers shortly
keep if season==1
tempfile season 
save `season'

*Getting plot rental rate
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC2B.dta", clear
ren parcelID parcel_id
gen land_rent=a2bq09
gen cultivated = (a2bq12a==1 | a2bq12a==2) if a2bq12a!=.
replace cultivated =(a2bq12b==1 | a2bq12b==2) if a2bq12b!=. & cultivated==0
collapse (sum) land_rent (max) cultivated, by (hhid)
merge 1:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_area_lrs.dta" , nogen		

merge 1:m hhid using  `season', nogen keep (1 3)
gen plot_rental_rate = land_rent/plot_ha
recode plot_rental_rate (0=.) 
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_rent_nomiss_lrs.dta", replace					

preserve
gen value_rented_land_male = plot_rental_rate if dm_gender==1
gen value_rented_land_female = plot_rental_rate if dm_gender==2
gen value_rented_land_mixed = plot_rental_rate if dm_gender==3
collapse (sum) value_rented_land_* value_rented_land = plot_rental_rate, by(hhid)
lab var value_rented_land_male "Value of rented land (male-managed plot)
lab var value_rented_land_female "Value of rented land (female-managed plot)
lab var value_rented_land_mixed "Value of rented land (mixed-managed plot)
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_rental_rate_lrs.dta", replace
restore

gen ha_rental_rate_hh = plot_rental_rate/plot_ha
preserve
keep if plot_rental_rate!=. & plot_rental_rate!=0			
collapse (sum) plot_rental_rate plot_ha, by(hhid)		
gen ha_rental_hh_lrs = plot_rental_rate/plot_ha				
keep ha_rental_hh_lrs hhid
lab var ha_rental_hh_lrs "Area of rented plot during the long run season"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_rental_rate_hhid_lrs.dta", replace
restore

*Merging in geographic variables
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhids.dta", nogen keep(3)	

*Geographic medians
bys region district_name subcounty_code parish_code: egen ha_rental_count_par = count(ha_rental_rate_hh)
bys region district_name subcounty_code parish_code: egen ha_rental_rate_par = median(ha_rental_rate_hh)
bys region district_name subcounty_code: egen ha_rental_count_subc = count(ha_rental_rate_hh)
bys region district_name subcounty_code: egen ha_rental_rate_subc = median(ha_rental_rate_hh)
bys region district_name: egen ha_rental_count_dist = count(ha_rental_rate_hh)
bys region district_name: egen ha_rental_rate_dist = median(ha_rental_rate_hh)
bys region: egen ha_rental_count_reg = count(ha_rental_rate_hh)
bys region: egen ha_rental_rate_reg = median(ha_rental_rate_hh)
egen ha_rental_rate_nat = median(ha_rental_rate_hh)

*Now, getting median rental rate at the lowest level of aggregation with at least ten observations
gen ha_rental_rate = ha_rental_rate_par if ha_rental_count_par>=10		
replace ha_rental_rate = ha_rental_rate_subc if ha_rental_count_subc>=10 & ha_rental_rate==.	
replace ha_rental_rate = ha_rental_rate_dist if ha_rental_count_dist>=10 & ha_rental_rate==.	
replace ha_rental_rate = ha_rental_rate_reg if ha_rental_count_reg>=10 & ha_rental_rate==.		
replace ha_rental_rate = ha_rental_rate_nat if ha_rental_rate==.				
collapse (firstnm) ha_rental_rate, by(hhid region district_name subcounty_code parish_code)

lab var ha_rental_rate "Land rental rate per ha"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_rental_rate_lrs.dta", replace


* Note: rent reported in UG data covers both seasons 


*Now getting total ha of all plots that were cultivated at least once
use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_rent_nomiss_lrs.dta", clear
*append using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_rent_nomiss_srs.dta"
collapse (max) cultivated plot_ha, by(hhid plot_id)		// collapsing down to household-plot level
gen ha_cultivated_plots = plot_ha if cultivate==1			// non-missing only if plot was cultivated in at least one season
collapse (sum) ha_cultivated_plots, by(hhid)				// total ha of all plots that were cultivated in at least one season
lab var ha_cultivated_plots "Area of cultivated plots (ha)"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_cultivated_plots_ha.dta", replace

use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_rental_rate_lrs.dta", clear
*append using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_rental_rate_srs.dta"
*collapse (sum) value_rented_land*, by(hhid)		// total over BOTH seasons (total spent on rent over course of entire year)
lab var value_rented_land "Value of rented land (household expenditures)"
lab var value_rented_land_male "Value of rented land (household expenditures - male-managed plots)"
lab var value_rented_land_female "Value of rented land (household expenditures - female-managed plots)"
lab var value_rented_land_mixed "Value of rented land (household expenditures - mixed-managed plots)"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_rental_rate.dta", replace



*Now getting area planted
*  LRS  *
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC4A.dta", clear
ren parcelID parcel_id
ren pltid plot_id
merge m:1 hhid parcel_id plot_id using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_rent_nomiss_lrs.dta", nogen keep(1 3)
gen percent_plot = s4aq09
replace percent_plot=100 if percent_plot==. & s4aq08==1 & s4aq08!=.
drop plot_ha	
gen plot_ha = s4aq07/2.47105	


*Merging in total plot area from previous module
*merge m:1 plot_id hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_area_lrs", nogen assert(2 3) keep(3)	
	
gen ha_planted = (percent_plot/100)*plot_ha
gen ha_planted_male = ha_planted if dm_gender==1
gen ha_planted_female = ha_planted if dm_gender==2
gen ha_planted_mixed = ha_planted if dm_gender==3



*Merging in geographic variables
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhids.dta", nogen keep(3)				
*Now merging in aggregate rental costs
merge m:1 hhid region district_name subcounty_code parish_code using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_rental_rate_lrs", nogen keep(3)				
*Now merging in rental costs of individual plots
*merge m:1 hhid plot_id using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_rent_nomiss_lrs.dta", nogen keep(1 3)
*Now merging in household rental rate
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_rental_rate_hhid_lrs.dta", nogen keep(1 3)

gen value_owned_land = ha_planted*ha_rental_rate 	
replace value_owned_land = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. 

*Now creating gender value
gen value_owned_land_male = ha_planted*ha_rental_rate if dm_gender==1
*replace value_owned_land_male = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & dm_gender==1
*Female
gen value_owned_land_female = ha_planted*ha_rental_rate if  dm_gender==2
*replace value_owned_land_female = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & dm_gender==2
*Mixed
gen value_owned_land_mixed = ha_planted*ha_rental_rate if dm_gender==3
*replace value_owned_land_mixed = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & dm_gender==3

collapse (sum) value_owned_land* ha_planted*, by(hhid plot_id)			// summing ha_planted across crops on same plot
lab var value_owned_land "Value of owned land that was cultivated (household)"
lab var value_owned_land_male "Value of owned land (male-managed)"
lab var value_owned_land_female "Value of owned land (female-managed)"
lab var value_owned_land_mixed "Value of owned land (mixed-managed)"
lab var ha_planted "Area planted (household)"
lab var ha_planted_male "Area planted (male-managed)"
lab var ha_planted_female "Area planted (female-managed)"
lab var ha_planted_mixed "Area planted (mixed-managed)"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_cost_land_lrs.dta", replace

*  SRS  *
*Now getting area planted
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC4B.dta", clear
ren parcelID parcel_id
ren pltid plot_id
merge m:1 hhid parcel_id plot_id using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_rent_nomiss_lrs.dta", nogen keep(1 3)
gen percent_plot = s4bq09
replace percent_plot=100 if percent_plot==. & s4bq08==1 & s4bq08!=.
drop plot_ha	
gen plot_ha = s4bq07/2.47105	


*Merging in total plot area
*merge m:1 plot_id hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_area_lrs", nogen keep(1 3) keepusing(plot_ha)						
*merge m:1 plot_id hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_area_srs", nogen keepusing(plot_ha) update							
gen ha_planted = percent_plot*plot_ha
gen ha_planted_male = ha_planted if dm_gender==1
gen ha_planted_female = ha_planted if dm_gender==2
gen ha_planted_mixed = ha_planted if dm_gender==3

*Merging in geographic variables
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhids.dta", nogen keep(3)				
*Now merging in aggregate rental costs
merge m:1 hhid region district_name subcounty_code parish_code using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_rental_rate_lrs", nogen keep(3)				
*Now merging in rental costs of individual plots
*merge m:1 hhid plot_id using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_rent_nomiss_lrs.dta", nogen keep(1 3)
*Now merging in household rental rate
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_rental_rate_hhid_lrs.dta", nogen keep(1 3)
	
gen value_owned_land = ha_planted*ha_rental_rate 
*replace value_owned_land = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. 	
*Now creating gender value
gen value_owned_land_male = ha_planted*ha_rental_rate if dm_gender==1
*replace value_owned_land_male = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (ag3a_33==0 | ag3a_33==.) & dm_gender==1
*Female
gen value_owned_land_female = ha_planted*ha_rental_rate if dm_gender==2
*replace value_owned_land_female = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (ag3a_33==0 | ag3a_33==.) & dm_gender==2
*Mixed
gen value_owned_land_mixed = ha_planted*ha_rental_rate if dm_gender==3
*replace value_owned_land_mixed = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (ag3a_33==0 | ag3a_33==.) & dm_gender==3
collapse (sum) value_owned_land* ha_planted*, by(hhid plot_id)			
append using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_cost_land_lrs.dta"						

preserve
collapse (sum) ha_planted*, by(hhid)
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_ha_planted_total.dta", replace
restore
collapse (sum) ha_planted* value_owned_land*, by(hhid plot_id)			// taking max area planted (and value owned) by plot so as to not double count plots that were planted in both seasons
collapse (sum) ha_planted* value_owned_land*, by(hhid)					// now summing to household
lab var value_owned_land "Value of owned land that was cultivated (household)"
lab var value_owned_land_male "Value of owned land (male-managed plots)"
lab var value_owned_land_female "Value of owned land (female-managed plots)"
lab var value_owned_land_mixed "Value of owned land (mixed-managed plots)"
lab var ha_planted "Area planted (household)"
lab var ha_planted_male "Area planted (male-managed plots)"
lab var ha_planted_female "Area planted (female-managed plots)"
lab var ha_planted_mixed "Area planted (mixed-managed plots)"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_cost_land.dta", replace



********************************************************************************
*INPUT COST *
********************************************************************************
*  LRS  *
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC3A.dta", clear
ren parcelID parcel_id
ren pltid plot_id

*Merging in geographic variables first (for constructing prices)
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhids.dta", nogen keep(3)		
*Gender variables
merge m:1 hhid parcel_id plot_id using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_rent_nomiss_lrs.dta", nogen keep(1 3) keepusing(dm_gender)
*Starting with fertilizer
gen value_inorg_fert_lrs = s3aq18			
gen value_herb_pest_lrs = s3aq27		
gen value_org_purchased_lrs = s3aq08 				

preserve
gen fert_org_kg = s3aq05	// need to verify if these are reported in kilograms and if not convert 
gen fert_inorg_kg = s3aq15	
gen fert_inorg_kg_male = fert_inorg_kg if dm_gender==1
gen fert_inorg_kg_female = fert_inorg_kg if dm_gender==2
gen fert_inorg_kg_mixed = fert_inorg_kg if dm_gender==3

collapse (sum) fert_org_kg fert_inorg_kg*, by(hhid)
lab var fert_org_kg "Organic fertilizer (kgs)"
lab var fert_inorg_kg "Inorganic fertilizer (kgs)"	
lab var fert_inorg_kg_male "Inorganic fertilizer (kgs) for male-managed crops"
lab var fert_inorg_kg_female "Inorganic fertilizer (kgs) for female-managed crops"
lab var fert_inorg_kg_mixed "Inorganic fertilizer (kgs) for mixed-managed crops"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_fert_lrs.dta", replace
restore

recode s3aq05 s3aq07 (.=0) if s3aq04!=.			
gen org_fert_notpurchased = s3aq05-s3aq07			
replace org_fert_notpurchased = 0 if org_fert_notpurchased<0	
gen org_fert_purchased = s3aq07						
gen org_fert_price = s3aq08 /org_fert_purchased		
recode org_fert_price (0=.) 

*Household-specific value
preserve
keep if org_fert_purchased!=0 & org_fert_purchased!=.		
collapse (sum) org_fert_purchased s3aq08, by(hhid)		
gen org_fert_price_hh = s3aq08/org_fert_purchased
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_org_fert_lrs.dta", replace
restore
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_org_fert_lrs.dta", nogen

*Geographic medians
bys region district_name subcounty_code parish_code: egen org_price_count_par = count(org_fert_price)
bys region district_name subcounty_code parish_code: egen org_price_par = median(org_fert_price) 
bys region district_name subcounty_code: egen org_price_count_subc = count(org_fert_price)
bys region district_name subcounty_code: egen org_price_subc = median(org_fert_price) 
bys region district_name: egen org_price_count_dist = count(org_fert_price)
bys region district_name: egen org_price_dist = median(org_fert_price) 
bys region: egen org_price_count_reg = count(org_fert_price)
bys region: egen org_price_reg = median(org_fert_price)
egen org_price_nat = median(org_fert_price)
drop org_fert_price
gen org_fert_price = org_price_par if org_price_count_par>=10
replace org_fert_price = org_price_subc if org_price_count_subc>=10 & org_fert_price==.
replace org_fert_price = org_price_dist if org_price_count_dist>=10 & org_fert_price==.
replace org_fert_price = org_price_reg if org_price_count_reg>=10 & org_fert_price==.
replace org_fert_price = org_price_nat if org_fert_price==.			
replace org_fert_price = org_fert_price_hh if org_fert_price_hh!=. & org_fert_price_hh!=0		
gen value_org_notpurchased_lrs = org_fert_price*org_fert_notpurchased	



* Note: In UGA, labor not broken down by specific farm activity 
		
*Hired labor
egen hired_labor = rowtotal(s3aq35a s3aq35b s3aq35c) if (s3aq35a!=. & s3aq35b!=. & s3aq35c!=.)

*Hired wages:
gen hired_wage = s3aq36

*Hired costs
gen hired_labor_costs = s3aq36

gen value_hired_labor_lrs = hired_labor_costs
*Constructing a household-specific wage
preserve
collapse (sum) hired_labor hired_wage hired_labor_costs, by(hhid)		
gen hired_wage_hh = hired_labor_costs/hired_labor									
recode *wage* (0=.)			
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_wages_hh_lrs.dta", replace
restore

*Merging right back in
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_wages_hh_lrs.dta", nogen

*Going to construct wages separately for each type
*Constructing for each labor type
foreach i in hired {
	recode `i'_wage (0=.) 
	bys region district_name subcounty_code parish_code: egen `i'_wage_count_par = count(`i'_wage)
	bys region district_name subcounty_code parish_code: egen `i'_wage_price_par = median(`i'_wage)
	bys region district_name subcounty_code: egen `i'_wage_count_subc = count(`i'_wage)
	bys region district_name subcounty_code: egen `i'_wage_price_subc = median(`i'_wage)
	bys region district_name: egen `i'_wage_count_dist = count(`i'_wage)
	bys region district_name: egen `i'_wage_price_dist = median(`i'_wage)
	bys region: egen `i'_wage_count_reg = count(`i'_wage)
	bys region: egen `i'_wage_price_reg = median(`i'_wage)
	egen `i'_wage_price_nat = median(`i'_wage)
	*Creating wage rate
	gen `i'_wage_rate = `i'_wage_price_par if `i'_wage_count_par>=10
	replace `i'_wage_rate = `i'_wage_price_subc if `i'_wage_count_subc>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_wage_price_dist if `i'_wage_count_dist>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_wage_price_reg if `i'_wage_count_reg>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_wage_price_nat if `i'_wage_rate==.
}

* Note: In UGA, no family labour was reported in LRS 

*Renaming (dropping lrs)
ren *_lrs *
foreach i in value_inorg_fert value_herb_pest value_org_purchased value_org_notpurchased value_hired_labor {
	gen `i'_male = `i' if dm_gender==1
	gen `i'_female = `i' if dm_gender==2
	gen `i'_mixed = `i' if dm_gender==3
}
collapse (sum) value_*, by(hhid)
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_cost_inputs_lrs.dta", replace


*  SRS  *
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC3B.dta", clear
ren parcelID parcel_id
ren pltid plot_id

*Merging in geographic variables first (for constructing prices)
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhids.dta", nogen keep(3)		
*Gender variables
merge m:1 hhid parcel_id plot_id using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_rent_nomiss_lrs.dta", nogen keep(1 3) keepusing(dm_gender)
*Starting with fertilizer
gen value_inorg_fert_srs = s3bq18			
gen value_herb_pest_srs = s3bq27
gen value_org_purchased_srs = s3bq08

preserve
gen fert_org_kg = s3bq05
gen fert_inorg_kg = s3bq15	
gen fert_inorg_kg_male = fert_inorg_kg if dm_gender==1
gen fert_inorg_kg_female = fert_inorg_kg if dm_gender==2
gen fert_inorg_kg_mixed = fert_inorg_kg if dm_gender==3
collapse (sum) fert_org_kg fert_inorg_kg*, by(hhid)

save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_fert_srs.dta", replace
restore
recode s3bq05 s3bq07 (.=0) if s3bq04!=.			
gen org_fert_notpurchased = s3bq05-s3bq07		
replace org_fert_notpurchased = 0 if org_fert_notpurchased<0			
gen org_fert_purchased = s3bq07					
gen org_fert_price = s3bq05/org_fert_purchased		
recode org_fert_price (0=.)

*Household-specific value
preserve
keep if org_fert_purchased!=0 & org_fert_purchased!=.		
collapse (sum) org_fert_purchased s3bq05, by(hhid)		
gen org_fert_price_hh = s3bq05/org_fert_purchased
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_org_fert_srs.dta", replace
restore
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_org_fert_srs.dta", nogen

*Geographic medians
bys region district_name subcounty_code parish_code: egen org_price_count_par = count(org_fert_price)
bys region district_name subcounty_code parish_code: egen org_price_par = median(org_fert_price) 
bys region district_name subcounty_code: egen org_price_count_subc = count(org_fert_price)
bys region district_name subcounty_code: egen org_price_subc = median(org_fert_price) 
bys region district_name: egen org_price_count_dist = count(org_fert_price)
bys region district_name: egen org_price_dist = median(org_fert_price) 
bys region: egen org_price_count_reg = count(org_fert_price)
bys region: egen org_price_reg = median(org_fert_price)
egen org_price_nat = median(org_fert_price)
drop org_fert_price
gen org_fert_price = org_price_par if org_price_count_par>=10
replace org_fert_price = org_price_subc if org_price_count_subc>=10 & org_fert_price==.
replace org_fert_price = org_price_dist if org_price_count_dist>=10 & org_fert_price==.
replace org_fert_price = org_price_reg if org_price_count_reg>=10 & org_fert_price==.
replace org_fert_price = org_price_nat if org_fert_price==.			
replace org_fert_price = org_fert_price_hh if org_fert_price_hh!=. & org_fert_price_hh!=0		
gen value_org_notpurchased_srs = org_fert_price*org_fert_notpurchased	

* Note: Ag labor data missing in SRS (except hired women days) thus hired labor not coded


ren *_srs *
foreach i in value_inorg_fert value_herb_pest value_org_purchased value_org_notpurchased {
	gen `i'_male = `i' if dm_gender==1
	gen `i'_female = `i' if dm_gender==2
	gen `i'_mixed = `i' if dm_gender==3
}
collapse (sum) value_*, by(hhid)
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_cost_inputs_srs.dta", replace
/*
use  "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_cost_inputs_lrs.dta", clear
append using  "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_cost_inputs_srs.dta"
collapse (sum) value_*, by(hhid)
foreach v of varlist *prep*  {
	local l`v' = subinstr("`v'","_prep","",1)
	ren `v' `l`v''
}
*/




********************************************************************************
* SEED COST * Note: there is no breakdown of seeds between purchased and not purchased in the raw data. Also, quantity of seed purchased is not reported thus impossible to compute unit price. 
********************************************************************************

********************************************************************************
*AGRICULTURAL WAGES
********************************************************************************
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC3A.dta", clear
gen season=1 
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC3B.dta" 
replace season=2 if season==.

ren parcelID parcel_id
ren pltid plot_id
drop if plot_id==.


*Hired wages:
gen hired_wage = s3aq36 // wage paid is not reported in season 2

*Hired costs
gen hired_labor_costs = s3aq36
gen wage_paid_aglabor = hired_labor_costs
*Constructing a household-specific wage
collapse (sum) wage_paid_aglabor, by(hhid)										
recode wage* (0=.)	
keep hhid wage_paid_aglabor 
lab var wage_paid_aglabor "Daily wage in agriculture"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_ag_wage.dta", replace



********************************************************************************
*RATE OF FERTILIZER APPLICATION
********************************************************************************
use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_cost_land.dta", clear
append using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_fert_lrs.dta"
append using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_fert_srs.dta"
collapse (sum) ha_planted* fert_org_kg* fert_inorg_kg*, by(hhid)
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhids.dta", keep (1 3) nogen
drop ha_planted*
lab var fert_inorg_kg "Quantity of fertilizer applied (kgs) (household level)"
lab var fert_inorg_kg_male "Quantity of fertilizer applied (kgs) (male-managed plots)"
lab var fert_inorg_kg_female "Quantity of fertilizer applied (kgs) (female-managed plots)"
lab var fert_inorg_kg_mixed "Quantity of fertilizer applied (kgs) (mixed-managed plots)"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_fertilizer_application.dta", replace


********************************************************************************
*WOMEN'S DIET QUALITY
********************************************************************************
*Women's diet quality: proportion of women consuming nutrient-rich foods (%)
*Information not available

********************************************************************************
*HOUSEHOLD'S DIET DIVERSITY SCORE
********************************************************************************

use "${Uganda_NPS_W7_raw_data}/HH/GSEC15B", clear


* recode food items to map HDDS food categories
recode coicop_5 	(1111/1115				=1	"CEREALS" )  //// 
					(1175 1177 1179 		=2	"WHITE ROOTS,TUBERS AND OTHER STARCHES"	)  ////
					(1171/1174	 			=3	"VEGETABLES"	)  ////	
					(1161 1162 1165			=4	"FRUITS"	)  ////	
					(1121 1122 1125 		=5	"MEAT"	)  ////					
					(1148					=6	"EGGS"	)  ////
					(1131 1132 				=7  "FISH") ///
					(1168 1169 1176			=8	"LEGUMES, NUTS AND SEEDS") ///
					(1141 1143 1145 1146	=9	"MILK AND MILK PRODUCTS")  ////
					(1151/1153   			=10	"OILS AND FATS"	)  ////
					(1181 1184 1186 		=11	"SWEETS"	)  //// 
					(1193 1194              =14 "SPICES, CONDIMENTS, BEVERAGES"	)  ////
					,generate(Diet_ID)		
gen adiet_yes=(CEB03==1)
ta Diet_ID  
drop if Diet_ID>14 
** Now, collapse to food group level; household consumes a food group if it consumes at least one item
collapse (max) adiet_yes, by(hhid   Diet_ID) 
label define YesNo 1 "Yes" 0 "No"
label val adiet_yes YesNo
* Now, estimate the number of food groups eaten by each individual
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
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_household_diet.dta", replace
 

 
********************************************************************************
*WOMEN'S CONTROL OVER INCOME
********************************************************************************

// Decision-making areas
*	Control over crop production income
*	Control over livestock production income
*	Control over fish production income
*	Control over farm (all) production income
*	Control over wage income
*	Control over business income
*	Control over nonfarm (all) income
*	Control over (all) income


* First append all files with information on who control various types of income
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC5A", clear   	// use of crop sales earnings/output - s5aq11f_1 s5aq11g s5aq11h/ s5aq06a_2_1 s5aq06a3 s5aq06a4
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC5B" 	// use of crop sales earnings/output - s5bq11f_1 s5bq11g s5bq11h/ s5bq06a_2_1 s5bq06a3_1 s5bq06a4_1
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC6A" 	//owns cattle & pack animals - s6aq03b s6aq03c
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC6B" 	//owns small animals - s6bq03b s6bq03c
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC6C" 	//owns poultry - s6cq03b s6cq03c
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC8A" 	// meat production - who controls the revenue - s8aq06a s8aq06b
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC8B" 	// milk production - who controls the revenue - s8bq10a s8bq10b
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC8C" 	// egg production - who controls the revenue - s8cq6a s8cq6b


append using "${Uganda_NPS_W7_raw_data}/HH/GSEC8"	// wage control (s8q31d1 s8q31d2 for primary) (s8q45d1 s8q45d2 for secondary)
append using "${Uganda_NPS_W7_raw_data}/HH/GSEC7_1" //other hh income data does not contain explit identification of controller but decided to use the identity of "person responsible for the income section in the survey"

append using "${Uganda_NPS_W7_raw_data}/HH/GSEC12_2" //Non-Agricultural Household Enterprises/Activities - h12q19a h12q19b



gen type_decision="" 
gen controller_income1=.
gen controller_income2=. 


* Control Over Harvest from Crops *
destring s5aq06a_2_1, gen(s5aq06a_2)
replace type_decision="control_harvest" if  !inlist(s5aq06a_2, .,0,-99) |  !inlist(s5aq06a3, .,0,99) |  !inlist(s5aq06a4, .,0,99) // first cropping season
replace controller_income1=s5aq06a_2 if !inlist(s5aq06a_2, .,0,-99) // primary controller
replace controller_income2=s5aq06a3 if !inlist(s5aq06a3, .,0,99) // 2 controllers, first listed
replace controller_income2=s5aq06a4 if controller_income2==. & !inlist(s5aq06a4, .,0,99) // 2 controllers, second listed

destring s5bq06a_2_1, gen(s5bq06a2)
replace type_decision="control_harvest" if  !inlist(s5bq06a2, .,0,-99) |  !inlist(s5bq06a3_1, .,0,99) |  !inlist(s5bq06a4_1, .,0,99) // second cropping season
replace controller_income1=s5bq06a2 if !inlist(s5bq06a2, .,0,99) // primary controller
replace controller_income2=s5bq06a3_1 if !inlist(s5bq06a3_1, .,0,99) // 2 controllers, first listed
replace controller_income2=s5bq06a4_1 if controller_income2==. & !inlist(s5bq06a4_1, .,0,99) // 2 controllers, second listed

* Control Over Sales Income *
destring s5aq11f_1, gen(s5aq11f1)
replace type_decision="control_sales" if  !inlist(s5aq11f1, .,0,-99) |  !inlist(s5aq11g, .,0,99) |  !inlist(s5aq11h, .,0,99)  // first cropping season
replace controller_income1=s5aq11f1 if !inlist(s5aq11f1, .,0,-99)  
replace controller_income2=s5aq11h if !inlist(s5aq11h, .,0,99)
replace controller_income2=s5aq11h if controller_income2==. & !inlist(s5aq11h, .,0,99)

destring s5bq11f_1, gen(s5bq11f1)  
replace type_decision="control_sales" if  !inlist(s5bq11f1, .,0,-99) |  !inlist(s5bq11g, .,0,99) |  !inlist(s5bq11h, .,0,99) // second cropping season
replace controller_income1=s5bq11f1 if !inlist(s5bq11f1, .,0,-99)  
replace controller_income2=s5bq11g if !inlist(s5bq11g, .,0,99)
replace controller_income2=s5bq11h if controller_income2==. & !inlist(s5bq11h, .,0,99)

* Control Over Income from Slaughtered Livestock Sales * 		 	
replace type_decision="control_livestocksales" if  !inlist(s8aq06a, .,0,99) |  !inlist(s8aq06b, .,0,99) 
replace controller_income1=s8aq06a if !inlist(s8aq06a, .,0,99)  
replace controller_income2=s8aq06b if !inlist(s8aq06b, .,0,99)

* Control Over Income from Milk Sales *  
replace type_decision="control_milksales" if  !inlist(s8bq10a, .,0,99) |  !inlist(s8bq10b, .,0,99) 
replace controller_income1=s8bq10a if !inlist(s8bq10a, .,0,99)  
replace controller_income2=s8bq10b if !inlist(s8bq10b, .,0,99)

* Control Over Income from Egg Sales *  
replace type_decision="control_egg_sales" if  !inlist(s8cq6a, .,0,99) |  !inlist(s8cq6b, .,0,99) 
replace controller_income1=s8cq6a if !inlist(s8cq6a, .,0,99)  
replace controller_income2=s8cq6b if !inlist(s8cq6b, .,0,99)

* Fish Production Income *
//Fish production not included in UGA LSMS W7

* Business Income *  
replace type_decision="control_businessincome" if  !inlist(h12q19a, .,0,99) | !inlist(h12q19b, .,0,99) 
replace controller_income1=h12q19a if !inlist(h12q19a, .,0,99)  
replace controller_income2=h12q19b if !inlist(h12q19b, .,0,99)


* Wage Income control * (s8q31d1 s8q31d2 for primary) (s8q45d1 s8q45d2 for secondary)

replace type_decision="control_wageincome" if !inlist(s8q31d1, .,0,99) | !inlist(s8q31d2, .,0,99) | !inlist(s8q45d1, .,0,99) | !inlist(s8q45d2, .,0,99) 
replace controller_income1=s8q31d1 if !inlist(s8q31d1, .,0,99) 
replace controller_income1=s8q45d1 if controller_income1==. & !inlist(s8q45d1, .,0,99) 

replace controller_income2=s8q31d2 if !inlist(s8q31d2, .,0,99) 
replace controller_income2=s8q45d2 if controller_income2==. & !inlist(s8q45d2, .,0,99) 

* Control Over Remittances
destring h7_respondent, gen(h7_respond)
replace type_decision="control_remittance" if s11q01==7
replace controller_income1= h7_respond if !inlist(h7_respond, .,0,-99) & s11q01==7


* Control Over Assistance Income
replace type_decision="control_assistance" if s11q01==6
replace controller_income1= h7_respond if !inlist(h7_respond, .,0,-99) & s11q01==6 

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
gen control_cropincome=1 if  type_decision=="control_harvest" | type_decision=="control_sales"					
recode 	control_cropincome (.=0)	
							
gen control_livestockincome=1 if  type_decision=="control_livestocksales" | type_decision=="control_milksales" | type_decision=="control_egg_sales"		
recode 	control_livestockincome (.=0)

gen control_farmincome=1 if  control_cropincome==1 | control_livestockincome==1							
recode 	control_farmincome (.=0)	
						
gen control_businessincome=1 if  type_decision=="control_businessincome" 
recode 	control_businessincome (.=0)
																					
gen control_nonfarmincome=1 if  type_decision=="control_remittance" | type_decision=="control_assistance" | control_businessincome== 1					   
recode 	control_nonfarmincome (.=0)		
																
collapse (max) control_* , by(hhid controller_income )  //any decision
gen control_all_income=1 if  control_farmincome== 1 | control_nonfarmincome==1

recode 	control_all_income (.=0)															
ren controller_income ind
tostring ind, gen (individ)

*Now merge with member characteristics
merge 1:1 hhid individ using  "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_person_ids.dta", nogen keep(3)
recode control_* (.=0)
lab var control_cropincome "1=invidual has control over crop income"
lab var control_livestockincome "1=invidual has control over livestock income"
lab var control_farmincome "1=invidual has control over farm (crop or livestock) income"
lab var control_businessincome "1=invidual has control over business income"
lab var control_nonfarmincome "1=invidual has control over non-farm (business or remittances) income"
lab var control_all_income "1=invidual has control over at least one type of income"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_control_income.dta", replace



********************************************************************************
*WOMEN'S PARTICIPATION IN AGRICULTURAL DECISION MAKIN
********************************************************************************

use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC3A", clear // planting input decision maker - s3aq03_3
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC3B" // s3bq03_3
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC5A" // s5aq06a_2_1 s5aq06a3 s5aq06a4
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC5B" // s5bq06a_2_1 s5bq06a3_1 s5bq06a4_1
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC6A" 	//owns cattle & pack animals - s6aq03b s6aq03c
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC6B" 	//owns small animals - s6bq03b s6bq03c
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC6C" 	//owns poultry - s6cq03b s6cq03c

gen type_decision="" 
gen decision_maker1=.
gen decision_maker2=.
gen decision_maker3=.

* planting_input
destring s3aq03_3, gen(s3aq033)
replace type_decision="planting_input" if  !inlist(s3aq033, .,0,99) 
replace decision_maker1=s3aq033 if !inlist(s3aq033, .,0,99)  

destring s3bq03_3, gen(s3bq033)
replace type_decision="planting_input" if  !inlist(s3bq033, .,0,99) 
replace decision_maker2=s3bq033 if !inlist(s3bq033, .,0,99)  

* harvest control 
destring s5aq06a_2_1, gen(s5aq06a2)
replace type_decision="harvest" if  !inlist(s5aq06a2, .,0,-99) |  !inlist(s5aq06a3, .,0,99)  |  !inlist(s5aq06a4, .,0,99) 
replace decision_maker1=s5aq06a2 if !inlist(s5aq06a2, .,0,-99)  
replace decision_maker2=s5aq06a3 if !inlist(s5aq06a3, .,0,99)
replace decision_maker3=s5aq06a4 if !inlist(s5aq06a4, .,0,99)

destring s5bq06a_2_1, gen(s5bq06a2)
replace type_decision="harvest" if  !inlist(s5bq06a2, .,0,-99) |  !inlist(s5bq06a3_1, .,0,99)  |  !inlist(s5bq06a4_1, .,0,99) 
replace decision_maker1=s5bq06a2 if !inlist(s5bq06a2, .,0,-99)  
replace decision_maker2=s5bq06a3_1 if !inlist(s5bq06a3_1, .,0,99)
replace decision_maker3=s5bq06a4_1 if !inlist(s5bq06a4_1, .,0,99)


* control livesock -  
replace type_decision="livestockowners" if  !inlist(s6aq03b, .,0,99) |  !inlist(s6aq03c, .,0,99)  
replace decision_maker1=s6aq03b if !inlist(s6aq03b, .,0,99)  
replace decision_maker2=s6aq03c if !inlist(s6aq03c, .,0,99)
 
replace type_decision="livestockowners" if  !inlist(s6bq03b, .,0,99) |  !inlist(s6bq03c, .,0,99)  
replace decision_maker1=s6bq03b if !inlist(s6bq03b, .,0,99)  
replace decision_maker2=s6bq03c if !inlist(s6bq03c, .,0,99)
 
replace type_decision="livestockowners" if  !inlist(s6cq03b, .,0,99) |  !inlist(s6cq03c, .,0,99)  
replace decision_maker1=s6cq03b if !inlist(s6cq03b, .,0,99)  
replace decision_maker2=s6cq03c if !inlist(s6cq03c, .,0,99)


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
gen make_decision_crop=1 if  type_decision=="planting_input" | type_decision=="harvest" 
							
												
recode 	make_decision_crop (.=0)
gen make_decision_livestock=1 if  type_decision=="livestockowners"   
recode 	make_decision_livestock (.=0)
gen make_decision_ag=1 if make_decision_crop==1 | make_decision_livestock==1
recode 	make_decision_ag (.=0)
collapse (max) make_decision_* , by(hhid decision_maker )  //any decision
ren decision_maker ind
tostring ind, gen (individ)
*Now merge with member characteristics
merge 1:1 hhid individ using  "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_person_ids.dta", nogen keep(3)
* 1 member ID in decision files not in member list
recode make_decision_* (.=0)
lab var make_decision_crop "1=invidual makes decision about crop production activities"
lab var make_decision_livestock "1=invidual makes decision about livestock production activities"
lab var make_decision_ag "1=invidual makes decision about agricultural (crop or livestock) production activities"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_make_ag_decision.dta", replace

 
********************************************************************************
*WOMEN'S OWNERSHIP OF ASSETS
********************************************************************************

use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC2A", clear // land ownership 
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC6A" 	//owns cattle & pack animals - s6aq03b s6aq03c
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC6B" 	//owns small animals - s6bq03b s6bq03c
append using "${Uganda_NPS_W7_raw_data}/Agric/AGSEC6C" 	//owns poultry - s6cq03b s6cq03c
append using "${Uganda_NPS_W7_raw_data}/HH/GSEC14"
*use "${Uganda_NPS_W7_raw_data}/HH/GSEC14", clear

gen type_asset=""
gen asset_owner1=.
gen asset_owner2=.

* Ownership of land
tostring s2aq24__0, gen(s2aq24_0)
destring s2aq24_0, gen(s2aq240)
replace type_asset="landowners" if  !inlist(s2aq240, .,0,99) |  !inlist(s2aq24__1, .,0,99) 
replace asset_owner1=s2aq240 if !inlist(s2aq240, .,0,99)  
replace asset_owner2=s2aq24__1 if !inlist(s2aq24__1, .,0,99)

* no land ownership reported in season 2 (which makes sense since land is not easily transferable except over long periods of time)

* append who hss right to sell or use
preserve
tostring s2aq27__0, gen(s2aq27_0)
destring s2aq27_0, gen(s2aq270)
replace type_asset="landowners" if  !inlist(s2aq270, .,0,99) |  !inlist(s2aq27__1, .,0,99) 
replace asset_owner1=s2aq270 if !inlist(s2aq270, .,0,99)  
replace asset_owner2=s2aq27__1 if !inlist(s2aq27__1, .,0,99)
* no hss right to sell or use recoded in season 2
keep if !inlist(s2aq270, .,0,99) |  !inlist(s2aq27__1, .,0,99)   
keep hhid type_asset asset_owner*
tempfile land2
save `land2'
restore
append using `land2'  

*non-poultry livestock (keeps/manages)
replace type_asset="livestockowners" if  !inlist(s6aq03b, .,0,99) |  !inlist(s6aq03c, .,0,99)  
replace asset_owner1=s6aq03b if !inlist(s6aq03b, .,0,99)  
replace asset_owner2=s6aq03c if !inlist(s6aq03c, .,0,99)
 
replace type_asset="livestockowners" if  !inlist(s6bq03b, .,0,99) |  !inlist(s6bq03c, .,0,99)  
replace asset_owner1=s6bq03b if !inlist(s6bq03b, .,0,99)  
replace asset_owner2=s6bq03c if !inlist(s6bq03c, .,0,99)

* household assets -  
replace type_asset="household_assets" if  !inlist(h14q03a, .,0,99) |  !inlist(h14q03b, .,0,99)  
replace asset_owner1=h14q03a if !inlist(h14q03a, .,0,99)  
replace asset_owner2=h14q03b if !inlist(h14q03b, .,0,99)


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
ren asset_owner ind
tostring ind, gen (individ)
*Now merge with member characteristics
merge 1:1 hhid individ using  "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_person_ids.dta", nogen keep(3)
* 3 member ID in assed files not is member list
recode own_asset (.=0)
lab var own_asset "1=invidual owns an assets (land or livestock)"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_ownasset.dta", replace
 

********************************************************************************
*CROP YIELDS
********************************************************************************
* crops
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC4A.dta", clear 
ren parcelID parcel_id
ren pltid plot_id
ren cropID crop_id

* Percent of area
gen pure_stand = s4aq08==1 if s4aq08!=.
gen any_pure = pure_stand==1
gen any_mixed = pure_stand==0 
gen percent_field = s4aq09 

duplicates report hhid parcel_id plot_id crop_id
duplicates drop hhid parcel_id plot_id crop_id, force		


*Merging in variables from parcel 
merge m:1 hhid parcel_id plot_id using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_LRS_plot_areas.dta", nogen keep(1 3)  
merge m:1 hhid parcel_id plot_id using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_LRS_plot_decision_makers", nogen keep(1 3)
gen field_area =  field_size 

*gen intercropped_yn = (ag4a_04==1) //See EPAR Technical Report #354 "Crop Yield Measurement on Multi-Cropped Plots" 
*replace intercropped_yn = . if ag4a_04==. //replace intercropped variable with missing if we do not know that it was or was not intercropped 

gen mono_field = percent_field if pure_stand==1 //not intercropped 
gen int_field = percent_field if any_mixed==1 

*Generating total percent of purestand and monocropped on a field
bys hhid plot_id: egen total_percent_int_sum = total(int_field) 
bys hhid plot_id: egen total_percent_mono = total(mono_field) 

//Dealing with crops which have monocropping larger than plot size or monocropping that fills plot size and still has intercropping to add
gen oversize_plot = (total_percent_mono >100)
replace oversize_plot = 1 if total_percent_mono >=100 & total_percent_int_sum >0 
bys hhid plot_id: egen total_percent_field = total(percent_field)			            
replace percent_field = percent_field/total_percent_field if total_percent_field>100 & oversize_plot ==1
replace total_percent_mono = 100 if total_percent_mono>100

gen total_percent_inter = 100-total_percent_mono 
bys hhid plot_id: egen inter_crop_number = total(any_mixed) 
gen percent_inter = (int_field/total_percent_inter)*total_percent_inter if total_percent_field >1 

replace percent_inter = int_field if total_percent_field<=1		
replace percent_inter = percent_field if oversize_plot ==1 & any_mixed==1
ren cultivated field_cultivated  

gen field_area_cultivated = field_area if field_cultivated==1
gen crop_area_planted = percent_field*field_area_cultivated  if any_mixed == 0 
replace crop_area_planted = percent_inter*field_area_cultivated  if any_mixed == 1 
gen us_total_area_planted = total_percent_field*field_area_cultivated 
gen us_inter_area_planted = total_percent_int_sum*field_area_cultivated 
keep crop_area_planted* hhid parcel_id plot_id crop_id dm_* any_* pure_stand dm_gender  field_area us* /*area_est_hectares area_meas_hectares */
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_crop_area.dta", replace




*Now to harvest
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC5A.dta", clear 
ren parcelID parcel_id
ren pltid plot_id
ren cropID crop_id

gen kg_harvest = s5aq06a_1 * a5aq6d  // CONVERSION INTO KGS MISSING IN PREVIOUS CODE
gen harv_less_plant=(harvest==2)		//yes if they harvested less than they planted
gen no_harv=(harvest==3) 
drop if kg_harvest==.							
* gen area_harv_ha= ag4a_21*0.404686	// area harvested not reported in the UG data 			
keep hhid parcel_id plot_id crop_id kg_harvest no_harv /*area_harv_ha*/ harv_less_plant

*Merging decision maker and intercropping variables
merge 1:1 hhid parcel_id plot_id crop_id using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_crop_area.dta", nogen /*keep(1 3)*/ // we still want to keep those that report an area planted but no harvest	
merge m:1 hhid parcel_id plot_id using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_LRS_plot_decision_makers", nogen keep(1 3)


//Add production of permanent crops (cassava and banana)
  *Note: permanent crops are not reported as standalone in the Uganda 
  *Note: Area harvested not reported thus not possible to compute this



*Creating area and quantity variables by decision-maker and type of planting
ren kg_harvest harvest 
*ren area_harv_ha area_harv 
ren any_mixed inter
gen harvest_male = harvest if dm_gender==1
*gen area_harv_male = area_harv if dm_gender==1
gen harvest_female = harvest if dm_gender==2
*gen area_harv_female = area_harv if dm_gender==2
gen harvest_mixed = harvest if dm_gender==3
*gen area_harv_mixed = area_harv if dm_gender==3
*gen area_harv_inter= area_harv if inter==1
*gen area_harv_pure= area_harv if inter==0
gen harvest_inter= harvest if inter==1
gen harvest_pure= harvest if inter==0
gen harvest_inter_male= harvest if dm_gender==1 & inter==1
gen harvest_pure_male= harvest if dm_gender==1 & inter==0
gen harvest_inter_female= harvest if dm_gender==2 & inter==1
gen harvest_pure_female= harvest if dm_gender==2 & inter==0
gen harvest_inter_mixed= harvest if dm_gender==3 & inter==1
gen harvest_pure_mixed= harvest if dm_gender==3 & inter==0
*gen area_harv_inter_male= area_harv if dm_gender==1 & inter==1
*gen area_harv_pure_male= area_harv if dm_gender==1 & inter==0
*gen area_harv_inter_female= area_harv if dm_gender==2 & inter==1
*gen area_harv_pure_female= area_harv if dm_gender==2 & inter==0
*gen area_harv_inter_mixed= area_harv if dm_gender==3 & inter==1
*gen area_harv_pure_mixed= area_harv if dm_gender==3 & inter==0
gen area_plan_male = crop_area_planted if dm_gender==1
gen area_plan_female = crop_area_planted if dm_gender==2
gen area_plan_mixed = crop_area_planted if dm_gender==3
gen area_plan_inter= crop_area_planted if inter==1
gen area_plan_pure= crop_area_planted if inter==0
gen area_plan_inter_male= crop_area_planted if dm_gender==1 & inter==1
gen area_plan_pure_male= crop_area_planted if dm_gender==1 & inter==0
gen area_plan_inter_female= crop_area_planted if dm_gender==2 & inter==1
gen area_plan_pure_female= crop_area_planted if dm_gender==2 & inter==0
gen area_plan_inter_mixed= crop_area_planted if dm_gender==3 & inter==1
gen area_plan_pure_mixed= crop_area_planted if dm_gender==3 & inter==0
*recode number_trees_planted (.=0)

collapse (sum) /*area_harv**/ harvest* area_plan* crop_area_planted /*number_trees_planted*/, by (hhid crop_id)
*merging survey weights
merge m:1 hhid using  "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhids.dta", nogen keep(1 3)
*Saving area planted for Shannon diversity index
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_crop_area_plan_LRS.dta", replace





/////Generating yield variables for short rainy season////
* crops
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC4B.dta", clear 
ren parcelID parcel_id
ren pltid plot_id
ren cropID crop_id

* Percent of area
gen pure_stand = s4bq08==1 if s4bq08!=.
gen any_pure = pure_stand==1
gen any_mixed = pure_stand==0 
gen percent_field = s4bq09

duplicates report hhid parcel_id plot_id crop_id
duplicates drop hhid parcel_id plot_id crop_id, force		


*Merging in variables from parcel 
merge m:1 hhid parcel_id plot_id using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_SRS_plot_areas.dta", nogen keep(1 3)  
merge m:1 hhid parcel_id plot_id using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_SRS_plot_decision_makers", nogen keep(1 3)
gen field_area =  field_size 

*gen intercropped_yn = (ag4a_04==1) //See EPAR Technical Report #354 "Crop Yield Measurement on Multi-Cropped Plots" 
*replace intercropped_yn = . if ag4a_04==. //replace intercropped variable with missing if we do not know that it was or was not intercropped 

gen mono_field = percent_field if pure_stand==1 //not intercropped 
gen int_field = percent_field if any_mixed==1 

*Generating total percent of purestand and monocropped on a field
bys hhid plot_id: egen total_percent_int_sum = total(int_field) 
bys hhid plot_id: egen total_percent_mono = total(mono_field) 

//Dealing with crops which have monocropping larger than plot size or monocropping that fills plot size and still has intercropping to add
gen oversize_plot = (total_percent_mono >100)
replace oversize_plot = 1 if total_percent_mono >=100 & total_percent_int_sum >0 
bys hhid plot_id: egen total_percent_field = total(percent_field)			            
replace percent_field = percent_field/total_percent_field if total_percent_field>100 & oversize_plot ==1
replace total_percent_mono = 100 if total_percent_mono>100

gen total_percent_inter = 100-total_percent_mono 
bys hhid plot_id: egen inter_crop_number = total(any_mixed) 
gen percent_inter = (int_field/total_percent_inter)*total_percent_inter if total_percent_field >1 

replace percent_inter = int_field if total_percent_field<=1		
replace percent_inter = percent_field if oversize_plot ==1 & any_mixed==1
ren cultivated field_cultivated  

gen field_area_cultivated = field_area if field_cultivated==1
gen crop_area_planted = percent_field*field_area_cultivated  if any_mixed == 0 
replace crop_area_planted = percent_inter*field_area_cultivated  if any_mixed == 1 
gen us_total_area_planted = total_percent_field*field_area_cultivated 
gen us_inter_area_planted = total_percent_int_sum*field_area_cultivated 
keep crop_area_planted* hhid parcel_id plot_id crop_id dm_* any_* pure_stand dm_gender  field_area us* /*area_est_hectares area_meas_hectares */
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_crop_area_SRS.dta", replace




*Now to harvest
use "${Uganda_NPS_W7_raw_data}/Agric/AGSEC5B.dta", clear 
ren parcelID parcel_id
ren pltid plot_id
ren cropID crop_id

gen kg_harvest = s5bq06a_1 * a5bq6d  // CONVERSION INTO KGS MISSING IN PREVIOUS CODE
gen harv_less_plant=(harvest_b==2)			//yes if they harvested less than they planted
gen no_harv=(harvest_b==3) 
drop if kg_harvest==.							
* gen area_harv_ha= ag4a_21*0.404686	// area harvested not reported in the UG data 			
keep hhid parcel_id plot_id crop_id kg_harvest no_harv /*area_harv_ha*/ harv_less_plant 



*Merging decision maker and intercropping variables
merge 1:1 hhid parcel_id plot_id crop_id using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_crop_area_SRS.dta", nogen /*keep(1 3)*/ //we still want to keep those that report an area planted but no harvest		

	

*Creating area and quantity variables by decision-maker and type of planting
ren kg_harvest harvest 
*ren area_harv_ha area_harv 
ren any_mixed inter
gen harvest_male = harvest if dm_gender==1
*gen area_harv_male = area_harv if dm_gender==1
gen harvest_female = harvest if dm_gender==2
*gen area_harv_female = area_harv if dm_gender==2
gen harvest_mixed = harvest if dm_gender==3
*gen area_harv_mixed = area_harv if dm_gender==3
*gen area_harv_inter= area_harv if inter==1
*gen area_harv_pure= area_harv if inter==0
gen harvest_inter= harvest if inter==1
gen harvest_pure= harvest if inter==0
gen harvest_inter_male= harvest if dm_gender==1 & inter==1
gen harvest_pure_male= harvest if dm_gender==1 & inter==0
gen harvest_inter_female= harvest if dm_gender==2 & inter==1
gen harvest_pure_female= harvest if dm_gender==2 & inter==0
gen harvest_inter_mixed= harvest if dm_gender==3 & inter==1
gen harvest_pure_mixed= harvest if dm_gender==3 & inter==0
*gen area_harv_inter_male= area_harv if dm_gender==1 & inter==1
*gen area_harv_pure_male= area_harv if dm_gender==1 & inter==0
*gen area_harv_inter_female= area_harv if dm_gender==2 & inter==1
*gen area_harv_pure_female= area_harv if dm_gender==2 & inter==0
*gen area_harv_inter_mixed= area_harv if dm_gender==3 & inter==1
*gen area_harv_pure_mixed= area_harv if dm_gender==3 & inter==0
gen area_plan_male = crop_area_planted if dm_gender==1
gen area_plan_female = crop_area_planted if dm_gender==2
gen area_plan_mixed = crop_area_planted if dm_gender==3
gen area_plan_inter= crop_area_planted if inter==1
gen area_plan_pure= crop_area_planted if inter==0
gen area_plan_inter_male= crop_area_planted if dm_gender==1 & inter==1
gen area_plan_pure_male= crop_area_planted if dm_gender==1 & inter==0
gen area_plan_inter_female= crop_area_planted if dm_gender==2 & inter==1
gen area_plan_pure_female= crop_area_planted if dm_gender==2 & inter==0
gen area_plan_inter_mixed= crop_area_planted if dm_gender==3 & inter==1
gen area_plan_pure_mixed= crop_area_planted if dm_gender==3 & inter==0
collapse (sum) /*area_harv**/ harvest* area_plan* crop_area_planted, by (hhid crop_id)
*Adding here total planted and harvested area summed accross all plots, crops, and seasons.
*Saving area planted for Shannon diversity index
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_crop_area_plan_SRS.dta", replace



 
********************************************************************************
*SHANNON DIVERSITY INDEX
********************************************************************************
*Area planted
*Bringing in area planted for LRS
use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_crop_area_plan_LRS.dta", clear
append using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_crop_area_plan_SRS.dta"
//we don't want to count crops that are grown in the SRS and LRS as different.
collapse (sum) area_plan* crop_area_planted, by(hhid crop_id)
*Some households have crop observations, but the area planted=0. These are permanent crops. Right now they are not included in the SDI unless they are the only crop on the plot, but we could include them by estimating an area based on the number of trees planted
*drop if area_plan==0
drop if crop_id==.
*generating area planted of each crop as a proportion of the total area
preserve 
collapse (sum) area_plan_hh=crop_area_planted area_plan_female_hh=area_plan_female area_plan_male_hh=area_plan_male area_plan_mixed_hh=area_plan_mixed, by(hhid)
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_crop_area_plan_shannon.dta", replace
restore
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_crop_area_plan_shannon.dta", nogen		//all matched
recode area_plan_female area_plan_male area_plan_female_hh area_plan_male_hh area_plan_mixed area_plan_mixed_hh (0=.)
gen prop_plan = crop_area_planted/area_plan_hh
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
bysort hhid crop_id : gen nvals_tot = _n==1
gen nvals_female = nvals_tot if area_plan_female!=0 & area_plan_female!=.
gen nvals_male = nvals_tot if area_plan_male!=0 & area_plan_male!=. 
gen nvals_mixed = nvals_tot if area_plan_mixed!=0 & area_plan_mixed!=.
collapse (sum) sdi=sdi_crop sdi_female=sdi_crop_female sdi_male=sdi_crop_male sdi_mixed=sdi_crop_mixed num_crops_hh=nvals_tot num_crops_female=nvals_female ///
num_crops_male=nvals_male num_crops_mixed=nvals_mixed (max) allmissing_female allmissing_male allmissing_mixed, by(hhid)
*la var sdi "Shannon diversity index"
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
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_shannon_diversity_index.dta", replace



********************************************************************************
*CONSUMPTION
******************************************************************************** 
use "${Uganda_NPS_W7_raw_data}/HH/pov2018_19.dta", clear
ren cpexp30  total_cons // using real consumption-adjusted for region price disparities
ren equiv adulteq
gen peraeq_cons = (total_cons / adulteq)
gen percapita_cons = (total_cons / hsize)
gen daily_peraeq_cons = peraeq_cons/30 
gen daily_percap_cons = percapita_cons/30
lab var total_cons "Total HH consumption"
lab var peraeq_cons "Consumption per adult equivalent"
lab var percapita_cons "Consumption per capita"
lab var daily_peraeq_cons "Daily consumption per adult equivalent"
lab var daily_percap_cons "Daily consumption per capita" 
keep hhid total_cons peraeq_cons percapita_cons daily_peraeq_cons daily_percap_cons adulteq
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_consumption.dta", replace




********************************************************************************
*HOUSEHOLD FOOD PROVISION* // DATA MISSING in W7
********************************************************************************


********************************************************************************
*HOUSEHOLD ASSETS*
********************************************************************************
use "${Uganda_NPS_W7_raw_data}/HH/GSEC14", clear
* ren hh_m03 price_purch
ren h14q05 value_today
* ren hh_m02 age_item
ren h14q04 num_items
*dropping items if hh doesnt report owning them 
tostring h14q03, gen(asset)
drop if asset=="3"
collapse (sum) value_assets=value_today, by(hhid)
la var value_assets "Value of household assets"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_assets.dta", replace 

********************************************************************************
                         *DISTANCE TO AGRO DEALERS*
********************************************************************************



********************************************************************************
                          *HOUSEHOLD VARIABLES*
********************************************************************************
* This section and final summary statistics datasets are currently being coded. Please continue checking our EPAR Github for future updates.