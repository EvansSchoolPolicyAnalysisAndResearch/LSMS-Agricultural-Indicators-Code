/*------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of a set of agricultural development indicators 
				  using the Uganda National Panel Survey (UNPS) LSMS-ISA Wave 1 (2009-10)
*Author(s)		: Didier Alia, David Coomes, Elan Ebeling, Nina Forbes, Nida
				  Haroon, Muel Kiel, Anu Sidhu, Isabella Sun, Emma Weaver,
				  Ayala Wineman, C. Leigh Anderson, &  Travis Reynolds

*Acknowledgments: We acknowledge the helpful contributions of members of the
				  World Bank's LSMS-ISA team, the FAO's RuLIS team, IFPRI,
				  IRRI, and the Bill & Melinda Gates Foundation Agricultural
				  Development Data and Policy team in discussing indicator
				  construction decisions. 
				  All coding errors remain ours alone.
*Date			: 22 January 2019
------------------------------------------------------------------------------*/



*Data source
*-----------
* The Uganda National Panel Survey was collected by the Uganda Bureau of 
* Statistics (UBOS) and the World Bank's Living Standards Measurement Study -
* Integrated Surveys on Agriculture(LSMS - ISA)
* The data were collected over the period November 2010 - October 2011. 
* All the raw data, questionnaires, and basic information documents are
* available for downloading free of charge at the following link
* http://microdata.worldbank.org/index.php/catalog/2166

* Throughout the do-file, we sometimes use the shorthand LSMS to refer to the
* Uganda National Panel Survey.


*Summary of Executing the Master do.file
*-----------
// BEGIN SAK 1.22.19 updated to the new folder structure
* This Master do.file constructs selected indicators using the Uganda UNPS 
* (UN LSMS) data set.
* Using data files from within the "\raw_data" folder, 
* the do.file first constructs common and intermediate variables, saving dta
* files when appropriate in the folder
* "\temp" 
*
* These variables are then brought together at the household, plot, or 
* individual level, saving dta files at each level when available in the
* folder "\output". 


* The processed files include all households, individuals, and plots in the 
* sample. Toward the end of the do.file, a block of code estimates summary 
* statistics (mean, standard error of the mean, minimum, first quartile, 
* median, third quartile, maximum) 
* of final indicators, restricted to the rural households only, disaggregated '
* by gender of head of household or plot manager.

* The results are outputted in the excel file 
* "Uganda_NPS_W2_summary_stats.xlsx" in the 
* "\output\uganda-wave2-2010-11-unps" folder. 

//// END SAK File Path Changes

* It is possible to modify the condition  "if rural==1" in the portion of code 
* following the heading "SUMMARY STATISTICS" to generate all summary 
* statistics for a different sub_population.


/*
OUTLINE OF THE DO.FILE
Below are the list of the main files created by running this Master do.file
 					
*INTERMEDIATE FILES					MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD IDS						Uganda_NPS_W2_hhids.dta
*INDIVIDUAL IDS						Uganda_NPS_W2_person_ids.dta
*HOUSEHOLD SIZE						Uganda_NPS_W2_hhsize.dta
*PLOT AREAS							Uganda_NPS_W2_plot_areas.dta
*PLOT-CROP DECISION MAKERS			Uganda_NPS_W2_plot_decision_makers.dta
*TLU (Tropical Livestock Units)		Uganda_NPS_W2_TLU_Coefficients.dta

*GROSS CROP REVENUE					Uganda_NPS_W2_tempcrop_harvest.dta
									Uganda_NPS_W2_tempcrop_sales.dta
									Uganda_NPS_W2_permcrop_harvest.dta
									Uganda_NPS_W2_permcrop_sales.dta
									Uganda_NPS_W2_hh_crop_production.dta
									Uganda_NPS_W2_plot_cropvalue.dta
									Uganda_NPS_W2_parcel_cropvalue.dta
									Uganda_NPS_W2_crop_residues.dta
									Uganda_NPS_W2_hh_crop_prices.dta
									Uganda_NPS_W2_crop_losses.dta
*CROP EXPENSES						Uganda_NPS_W2_wages_mainseason.dta
									Uganda_NPS_W2_wages_shortseason.dta
									
									Uganda_NPS_W2_fertilizer_costs.dta
									Uganda_NPS_W2_seed_costs.dta
									Uganda_NPS_W2_land_rental_costs.dta
									Uganda_NPS_W2_asset_rental_costs.dta
									Uganda_NPS_W2_transportation_cropsales.dta
									
*CROP INCOME						Uganda_NPS_W2_crop_income.dta
									
*LIVESTOCK INCOME					Uganda_NPS_W2_livestock_products.dta
									Uganda_NPS_W2_livestock_expenses.dta
									Uganda_NPS_W2_hh_livestock_products.dta
									Uganda_NPS_W2_livestock_sales.dta
									Uganda_NPS_W2_TLU.dta
									Uganda_NPS_W2_livestock_income.dta

*FISH INCOME						Uganda_NPS_W2_fishing_expenses_1.dta
									Uganda_NPS_W2_fishing_expenses_2.dta
									Uganda_NPS_W2_fish_income.dta
																	
*SELF-EMPLOYMENT INCOME				Uganda_NPS_W2_self_employment_income.dta
									Uganda_NPS_W2_agproducts_profits.dta
									Uganda_NPS_W2_fish_trading_revenue.dta
									Uganda_NPS_W2_fish_trading_other_costs.dta
									Uganda_NPS_W2_fish_trading_income.dta
									
*WAGE INCOME						Uganda_NPS_W2_wage_income.dta
									Uganda_NPS_W2_agwage_income.dta
*OTHER INCOME						Uganda_NPS_W2_other_income.dta
									Uganda_NPS_W2_land_rental_income.dta

*FARM SIZE / LAND SIZE				Uganda_NPS_W2_land_size.dta
									Uganda_NPS_W2_farmsize_all_agland.dta
									Uganda_NPS_W2_land_size_all.dta
*FARM LABOR							Uganda_NPS_W2_farmlabor_mainseason.dta
									Uganda_NPS_W2_farmlabor_shortseason.dta
									Uganda_NPS_W2_family_hired_labor.dta
*VACCINE USAGE						Uganda_NPS_W2_vaccine.dta
*USE OF INORGANIC FERTILIZER		Uganda_NPS_W2_fert_use.dta
*USE OF IMPROVED SEED				Uganda_NPS_W2_improvedseed_use.dta

*REACHED BY AG EXTENSION			Uganda_NPS_W2_any_ext.dta
*USE OF FORMAL FINANACIAL SERVICES	Uganda_NPS_W2_fin_serv.dta
*GENDER PRODUCTIVITY GAP 			Uganda_NPS_W2_gender_productivity_gap.dta
*MILK PRODUCTIVITY					Uganda_NPS_W2_milk_animals.dta
*EGG PRODUCTIVITY					Uganda_NPS_W2_eggs_animals.dta

*CROP PRODUCTION COSTS PER HECTARE	Uganda_NPS_W2_hh_cost_land.dta
									Uganda_NPS_W2_hh_cost_inputs_lrs.dta
									Uganda_NPS_W2_hh_cost_inputs_srs.dta
									Uganda_NPS_W2_hh_cost_seed_lrs.dta
									Uganda_NPS_W2_hh_cost_seed_srs.dta		
									Uganda_NPS_W2_cropcosts_perha.dta

*RATE OF FERTILIZER APPLICATION		Uganda_NPS_W2_fertilizer_application.dta
*HOUSEHOLD'S DIET DIVERSITY SCORE	Uganda_NPS_W2_household_diet.dta
*WOMEN'S CONTROL OVER INCOME		Uganda_NPS_W2_control_income.dta
*WOMEN'S AG DECISION-MAKING			Uganda_NPS_W2_make_ag_decision.dta
*WOMEN'S ASSET OWNERSHIP			Uganda_NPS_W2_ownasset.dta
*AGRICULTURAL WAGES					Uganda_NPS_W2_ag_wage.dta
*CROP YIELDS						Uganda_NPS_W2_yield_hh_crop_level.dta

*FINAL FILES						MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD VARIABLES				Uganda_NPS_W2_household_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			Uganda_NPS_W2_individual_variables.dta	
*PLOT-LEVEL VARIABLES				Uganda_NPS_W2_gender_productivity_gap.dta
*SUMMARY STATISTICS					Uganda_NPS_W2_summary_stats.xlsx
*/

clear
clear matrix
clear mata
set more off
set maxvar 8000

// set directories
* These paths correspond to the folders where the raw data files are located 
* and where the created data and final data will be stored.
local root_folder "//netid.washington.edu/wfs/EvansEPAR/Project/EPAR/Working Files/378 - LSMS Burkina Faso, Malawi, Uganda/uganda-wave2-2010-11"
global UGA_W2_raw_data "`root_folder'/raw_data"
global UGA_W2_final_data "`root_folder'/outputs"
global UGA_W2_created_data "`root_folder'/temp"

* Some other useful local variables
local genders "male female mixed"
local gender_len : list sizeof genders

* Priority Crops (crop code)
* maize 		(130)		rice 			(120)		wheat 	(111)
* sorghum 		(150)		finger millet	(141)		cowpea	(222)
* groundnut 	(310)		common bean 	(210)		yam 	(640)
* sweet potato	(620)		cassava 		(630)		banana	(741) 
// SAK NOTE 20190131: Banana is divided into three categories Banana food 
// (741), Banana beer(742), and Banana sweet (744). For this analysis only 
// Banana Food is used

global topcropname_area "maize rice wheat sorgum pmill cowpea grdnt beans yam swtptt cassav banana"
global topcrop_area "130 120 111 150 141 222 310 210 640 620 630 741"
global comma_topcrop_area"130, 120, 111, 150, 141, 222, 310, 210, 640, 620, 630, 741"


* Get the length of the crop list. 
local crop_len : list sizeof global(topcropname_area)

* Create data for the species data
local species_list "lrum srum pigs equine poultry"
local species_len : list sizeof local(species_list)

* Define labels for our species categories
label define species 	1 "Large ruminants (cows, buffalos)"	/*
					*/	2 "Small ruminants (sheep, goats)"		/*
					*/	3 "Pigs"								/*
					*/	4 "Equine (horses, donkeys)"			/*
					*/	5 "Poultry (including rabbits)"


********************************************************************************
*                          EXCHANGE RATE AND INFLATION                         *
********************************************************************************

// SAK 1.22.19 Ask Emma which year to use for exchange rate/inflation rate, etc 

global NPS_LSMS_ISA_W2_exchange_rate  3690.85 //EFW 4.19.19 use 2016
// https://data.worldbank.org/indicator/PA.NUS.PPP?end=2016&locations=UG&start=2011&view=chart&year_low_desc=false
global NPS_LSMS_ISA_W2_gdp_ppp_dollar 833.54

global NPS_LSMS_ISA_W2_cons_ppp_dollar 946.89
//https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2016&locations=UG&start=2011
global NPS_LSMS_ISA_W2_inflation 0.359 //(158.5 - 116.6)/116.6 https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2016&locations=UG&start=2011 //EFW 4.19.19 updated see calculations

********************************************************************************
*                                HOUSEHOLD  IDS                                *
********************************************************************************
use "${UGA_W2_raw_data}/GSEC1.dta", clear

* Rename variables to EPAR standard
rename h1aq1 district
rename h1aq2b county
rename h1aq3b subcounty
rename h1aq4b parish
rename stratum strataid
rename wgt10 weight // Includes split off households
// SAK NOTE 20190124_1: All of the numeric codes have been removed from this
// version of the survey.

gen rural = urban==0
rename comm ea

keep HHID region district county subcounty parish ea rural weight strataid
lab var rural "1=Household lives in a rural area"
save "${UGA_W2_created_data}/Uganda_NPS_W2_hhids.dta", replace


********************************************************************************
*                                INDIVIDUAL IDS                                *
********************************************************************************
use "${UGA_W2_raw_data}/GSEC2.dta", clear
keep HHID PID h2q1 h2q3 h2q4 h2q8

rename h2q1 personid
* Fixing errors in transcription for PID/personid
replace personid = 5			if PID == "102100060805"
replace personid = 11			if PID == "103300030411"
replace PID = "10330005110202" 	if PID == "1033000511020"
replace personid = 3			if PID == "10330005110203"
replace personid = 8			if PID == "104300080608"
replace personid = 10			if PID == "105300080810"
replace personid = 5			if PID == "108300270905"
replace personid = 11			if PID == "109300040911"
replace personid = 13			if PID == "112100011013"
replace personid = 6			if PID == "11530004040206"
replace personid = 8			if PID == "11530004040208"
replace personid = 9			if PID == "11530004040209"
replace personid = 7			if PID == "302300051007"
replace personid = 5			if PID == "307300220105"
replace personid = 8			if PID == "320300270708"
replace personid = 4			if PID == "321300280804"
* Dropping duplicate entries
drop if PID == "40230025056"
drop if PID == "11310004095"
* Household 1053003307 has all kinds of crazy, lucky for us only personid 1
* is needed for this analysis
drop if HHID == "1053003307" & personid != 1

* Create female dummy variable and drop the gender variable
gen female = h2q3==0
lab var female "1= indidividual is female"
drop h2q3

* Create head of household dummy variable and drop relationship to hh
gen hh_head = h2q4==1
lab var hh_head "1= individual is household head"
drop h2q4

* Set Age to EPAR standard label
rename h2q8 age
lab var age "Individual age"

* Save data to temp folder
save "${UGA_W2_created_data}/Uganda_NPS_W2_person_ids.dta", replace


********************************************************************************
*                                HOUSEHOLD SIZE                                *
********************************************************************************
use "${UGA_W2_raw_data}/GSEC2.dta"


* Create female-headed household dummy variable 1 if person is head of 
* household and female
gen fhh = (h2q4==1 & h2q3==0)

* Combine all the members of a househould into one entry to get size of 
* household and whether or not the househould is headed by a female.
gen hh_members = 1

collapse (sum) hh_members (max) fhh, by (HHID)

* Label the created variables
lab var fhh "1= Female-headed househould"
lab var hh_members "Number of househould members"

save "${UGA_W2_created_data}/Uganda_NPS_W2_hhsize.dta", replace

********************************************************************************
*                                  PLOT AREAS                                  *
********************************************************************************

* In Uganda plot areas are not measured or estimated. All areas are measured
* at the parcel level.

use "${UGA_W2_raw_data}/AGSEC2A.dta"
append using "${UGA_W2_raw_data}/\AGSEC2B.dta" 

* Renaming for consistency across waves and files
rename prcid parcel_id

* 
rename a2aq4 area_acres_meas
replace area_acres_meas = a2bq4 if area_acres_meas==.

* Rename parcel area estimates
rename a2aq5 area_acres_est
replace area_acres_est = a2bq5 if area_acres_est==.

* Get rid of entries which don't have a recorded area and excess variables
drop if area_acres_est == . & area_acres_meas == .
keep HHID parcel_id area_acres_est area_acres_meas 

* Create variable with areas converted to hectares
gen area_est_hectares = area_acres_est * (1/2.47105)
gen area_meas_hectares = area_acres_meas * (1/2.47105)

* Calculate the best value for the parcel area, i.e. the measured if available,
* otherwise use the estimated area
gen plot_area = area_meas_hectares * ~missing(area_meas_hectares) + /*
	*/	area_est_hectares * missing(area_meas_hectares)



lab var area_acres_est		"Plot area in acres (estimated)"
lab var area_acres_meas		"Plot area in acres (GPSd)"
lab var area_meas_hectares	"Plot area in hectares (GPSd)"
lab var area_est_hectares	"Plot area in hectares (estimated)"
lab var plot_area 			"Best measure of plot area in hectares"

save "${UGA_W2_created_data}/Uganda_NPS_W2_plot_areas.dta", replace

********************************************************************************
*                             PLOT DECISION MAKERS                             *
********************************************************************************

use "${UGA_W2_raw_data}/GSEC2.dta",clear


* Create dummy var for if the person is female
gen female = h2q3 == 0
lab var female "1=Individual is a female"

* Rename/relabel age question for consistency
rename h2q8 age
lab var age "Individual age"

* Create dummy variable for marking if the person is head of the household
gen head = h2q4 == 1 if h2q4 != .
lab var head "1=Individual is the head of the household"
rename h2q4 relhead

rename h2q1 personid

* Fixing errors in transcription for PID/personid
replace personid = 5 if PID == "102100060805"
replace personid = 11 if PID == "103300030411"
replace PID = "10330005110202" if PID == "1033000511020"
replace personid = 3 if PID == "10330005110203"
replace personid = 8 if PID == "104300080608"
replace personid = 10 if PID == "105300080810"
replace personid = 5 if PID == "108300270905"
replace personid = 11 if PID == "109300040911"
replace personid = 13 if PID == "112100011013"
replace personid = 6 if PID == "11530004040206"
replace personid = 8 if PID == "11530004040208"
replace personid = 9 if PID == "11530004040209"
replace personid = 7 if PID == "302300051007"
replace personid = 5 if PID == "307300220105"
replace personid = 8 if PID == "320300270708"
replace personid = 4 if PID == "321300280804"
* Dropping duplicate entries
drop if PID == "40230025056"
drop if PID == "11310004095"
* Household 1053003307 has all kinds of crazy, lucky for us only personid 1
* is needed for this analysis
drop if HHID == "1053003307" & personid != 1


* Only keep relevant data
keep personid female age HHID head PID

* Save and close
save "${UGA_W2_created_data}/Uganda_NPS_W2_gender_merge.dta", replace

* Load Owned Plot Data and set ownership status
use "${UGA_W2_raw_data}/AGSEC2A.dta", clear
gen ownership_status = 1

* Append Unowned Plot data set its ownership status
append using "${UGA_W2_raw_data}/AGSEC2B.dta"
replace ownership_status = 2 if ownership_status == .

* Drop entries without required parcel id or use information
rename prcid parcel_id
drop if missing(parcel_id) 

* Set the plot to cultivated if it is owned or unowned and cultivated in the 
* first or second season - Note 1=Annual Crops, 2=Perennial Crops
gen cultivated = a2aq13a == 2 | a2aq13b ==2 | a2aq13a == 1 | a2aq13b ==1 
lab var cultivated "1=Plot has been cultivated"

* Generate a personid from first plot manager for gender merge purposes
generate	personid = a2aq27a 
replace		personid = a2bq25a if personid == .

* Get gender and age data for the first plot manager
merge m:1 HHID personid using /*
*/ "${UGA_W2_created_data}/Uganda_NPS_W2_gender_merge.dta", /*
*/ gen (dm1_merge) keep(1 3) // Dropping unmatched from using

* set the female dummy variable for plot manager 1
generate dm1_female = female
drop female personid

* Get the personid for the second plot manager
generate	personid = a2aq27b 
replace 	personid = a2bq25b if personid == .

* Get gender and age data for the second plot manager
merge m:1 HHID personid using /*
*/ "${UGA_W2_created_data}/Uganda_NPS_W2_gender_merge.dta", /*
*/ gen (dm2_merge) keep(1 3)

* set the female dummy variable for plot manager 2
gen dm2_female = female
drop female personid

* Constructing three-part gendered decision-maker variable:
* male only (=1) female only (=2) or mixed (=3)
gen dm_gender		= 1 if 	(dm1_female==0 			|	missing(dm1_female)) &/*
						*/	(dm2_female==0 			|	missing(dm2_female)) &/*
						*/ !(missing(dm1_female) 	& 	missing(dm2_female))

replace dm_gender	= 2 if 	(dm1_female==1 			|	missing(dm1_female)) &/*
						*/	(dm2_female==1			|	missing(dm2_female)) &/*
						*/ !(missing(dm1_female) 	&	missing(dm2_female))

replace dm_gender	= 3 if missing(dm_gender) & !(dm1_female==. & dm2_female==.)

* Set variable and value labels.
label define	dm_gender 1 "Male only" 2 "Female only" 3 "Mixed gender"
label value		dm_gender dm_gender
label variable  dm_gender "Gender of plot manager/decision maker"

*Replacing observations without gender of plot manager with gender of HOH
merge m:1 HHID using /*
	*/"${UGA_W2_created_data}/Uganda_NPS_W2_hhsize.dta", /*
	*/ nogen keep(1 3)
replace dm_gender = 1 if fhh == 0 & missing(dm_gender)
replace dm_gender = 2 if fhh == 1 & missing(dm_gender)

keep HHID parcel_id dm_gender cultivated

save "${UGA_W2_created_data}/Uganda_NPS_W2_plot_decision_makers.dta", /*
	*/ replace

********************************************************************************
*                                  AREA PLANTED                                *
********************************************************************************
use "${UGA_W2_raw_data}/AGSEC4A.dta", clear
append using "${UGA_W2_raw_data}/AGSEC4B.dta", gen(season)


// Standardizing some names across waves and files. 
rename pltid plot_id
rename cropID crop_code
rename prcid parcel_id

// Create hectares planted
gen ha_planted = a4aq8 *(1/2.47105)
replace ha_planted = a4bq8*(1/2.47105) if missing(ha_planted)

collapse (sum) ha_planted, by (HHID parcel_id plot_id crop_code season)

save "${UGA_W2_created_data}/Uganda_NPS_W2_area_planted_temp.dta", /*
*/ replace



********************************************************************************
*                              MONOCROPPED PLOTS                               *
********************************************************************************

//EFW 4.19.19 Can you update the below to be consistent with other waves? This is important for when we need to make changes to the code so that it is easier for other (especially newer) RAs to update it
use "${UGA_W2_raw_data}/AGSEC5A.dta", clear
append using "${UGA_W2_raw_data}/AGSEC5B", gen(season)

* Standardize plot variable names
rename a5aq6a qty_harvest 
replace qty_harvest = a5bq6a if missing(qty_harvest)
rename a5aq6d conversion
replace conversion = a5bq6d if missing(conversion)

rename pltid plot_id
rename cropID crop_code
rename prcid parcel_id

drop if missing(plot_id) | missing(parcel_id)

xi i.crop_code, noomit

* Loop through the list of crops and
forvalues k=1(1)`crop_len' {
	preserve //EFW 4.19.19 Why is this preserve/restore necessary?
		local c		: word `k' of $topcrop_area
		local cn	: word `k' of $topcropname_area
		
		* Figure out kgs_harv 
		gen kgs_harv_mono_`cn'= qty_harvest * conversion if crop_code == `c'
		recode kgs_harv_mono_`cn' (.=0)
		* Tons of duplicates on the crop-plot level which makes the merge
		* impossible.  Collapse to the plot level to deal with that.
		collapse (sum) kgs_harv_mono_`cn' (max) _Icrop_code_*, by /*
			*/ (HHID parcel_id plot_id crop_code season)
		
		merge 1:1 HHID parcel_id plot_id crop_code season using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_area_planted_temp.dta",/*
		*/ keep(3)
		
		* Collapse further to parcel level as that is the only level we have for
		* some waves/data files.
		collapse (sum) kgs_harv_mono_`cn' ha_planted (max) _Icrop_code_*, /* 
			*/ by(HHID parcel_id season)
		egen crop_count = rowtotal(_Icrop_code_*)
		* Get rid of intercropped/ not monocropped parcels
		keep if crop_count == 1 & _Icrop_code_`c' == 1
		gen `cn'_monocrop_ha = ha_planted
		drop if `cn'_monocrop_ha == 0

		save /*
		*/ "${UGA_W2_created_data}/Uganda_NPS_W2_`cn'_monocrop.dta", /*
		*/ replace
	restore
}

* Creating Gender Disaggregation and collapsing to the household level
forvalues k=1(1)`crop_len' {
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	use "${UGA_W2_created_data}/Uganda_NPS_W2_`cn'_monocrop.dta", /*
	*/ clear
	merge m:1 HHID parcel_id using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_plot_decision_makers.dta"

	* Disaggregate the kgs_harv_mono and monocrop_ha by the gender of the plot 
	* manager(s)
	foreach i in `cn'_monocrop_ha kgs_harv_mono_`cn' {
		forvalues j = 1 (1) `gender_len' {
			local g : word `j' of `genders'
			gen `i'_`g'		= `i'	if dm_gender == `j'
		}
	}

	* Create dummy variables for plot manager gender (male, female, mixed)
	forvalues j = 1 (1) `gender_len' {
		local g : word `j' of `genders'
		gen `cn'_monocrop_`g' = dm_gender == `j'
	}

	* Roll things up to the household level
	collapse (sum) `cn'_monocrop_ha* kgs_harv_mono_`cn'* (max) /*
	*/ `cn'_monocrop_male `cn'_monocrop_female `cn'_monocrop_mixed /*
	*/ `cn'_monocrop = _Icrop_code_`c', by(HHID)

	* Label the monocrop variables now that the collapse is completed. 
	label variable kgs_harv_mono_`cn' "monocropped `cn' harvested(kgs)"
	label variable `cn'_monocrop "1=hh has monocropped `cn' plots"
	label variable `cn'_monocrop_ha "monocropped `cn' area(ha) planted"
	
	* Replace any extraneous data with missing
	replace `cn'_monocrop_ha	= .		if	`cn'_monocrop != 1
	replace kgs_harv_mono_`cn'	= .		if	`cn'_monocrop != 1

	* Same for the gendered versions of the variables. 
	foreach g in `genders' {
		foreach i in `cn'_monocrop_ha kgs_harv_mono_`cn' {
			replace `i'_`g' = .	if ~`cn'_monocrop
			replace `i'_`g' = .	if ~`cn'_monocrop_`g'
			replace `i'_`g' = .	if ~`cn'_monocrop_ha_`g'
			
			* Then label the gendered versions of the variables
			local l`i' : variable label `i'
			label variable `i'_`g' "`l`i'' - `g' managed plots"		
		}
		label variable `cn'_monocrop_`g' /*
		*/ "1=hh has `g' managed monocropped `cn' plots"
	}

	save "${UGA_W2_created_data}/Uganda_NPS_W2_`cn'_monocrop_hh_area.dta", /*
		*/ replace 
}

********************************************************************************
*                                 LIVESTOCK  + TLUs                            *
********************************************************************************
use "${UGA_W2_raw_data}/AGSEC6A.dta", clear
append using "${UGA_W2_raw_data}/AGSEC6B.dta"
append using "${UGA_W2_raw_data}/AGSEC6C.dta"
drop if HHID == ""

  /********/
 /* TLUs */
/********/
gen lvstckid = a6aq3
replace lvstckid = a6bq3 if missing(lvstckid) & ~missing(a6bq3)
replace lvstckid = a6cq3 if missing(lvstckid) & ~missing(a6cq3)

* Generate the TLU Coefficient based on the animal type
*Indigenous and Exotic Cattle represented in 1-10
gen tlu_coefficient 	= 0.5 if inrange(lvstckid, 1, 10)

* Donkeys
replace tlu_coefficient = .3 if lvstckid == 11

* No Horse mule disaggregation using the average of the two tlu's
replace tlu_coefficient = .55 if lvstckid == 12

* Indigeneous and exotic goats and sheep, male and female represented in 13-20
replace tlu_coefficient = .10 if inrange(lvstckid, 13, 20)

* Pigs
replace tlu_coefficient = .20 if lvstckid == 21

* Rabbits, backyard chicken, parent stock for broilers, parent stock for layers
* layers, pullet chicks, growers, broilers, turkeys, ducks, and geese and other
* birds represented in 31-41
replace tlu_coefficient = .01 if inrange(lvstckid, 31, 41)

  /*******************/
 /* Owned Livestock */
/*******************/
* Create dummy variables for our categories of livestock
* Cattle (Calves, Bulls, Oxen, Heifer, and Cows) 1-10
gen cattle 		= inrange(lvstckid, 1, 10)

* Small ruminants (Goats and Sheep) 13-20
gen smallrum	= inrange(lvstckid, 13, 20)

* Poultry (Chicken, Turkeys, Geese) 32-41
gen poultry		= inrange(lvstckid, 32, 41)

* Other Livestock (Donkeys, Horses/Mules, Pigs, Rabbits) 11, 12, 21, 31
gen other_ls 	= inlist(lvstckid, 11, 12, 21, 31)

* Cows (Exotic and Indigeneous) 5, 10
gen cows		= inlist(lvstckid, 5, 10)

* Chickens (Backyard chicken, Parent stock for broilers, Parent Stock for 
* layers, Pullet Chicks, Growers, Broilers) 32-38
gen chicken		= inrange(lvstckid, 32, 38)

/* Livestock Holdings 1 year ago */
* There are only livestock holdings from 1 year ago for cattle
gen nb_ls_1yearago		= a6aq7

* Assign the amount of livestock owned 1 year ago to the various categories
gen nb_cattle_1yearago		= nb_ls_1yearago	if cattle == 1
gen nb_cows_1yearago		= nb_ls_1yearago	if cows == 1
gen tlu_1yearago			= nb_ls_1yearago * tlu_coefficient

* For small ruminants there is no data from 1 year ago, only 6 months ago. 
* Created as missing for compatibility
gen nb_smallrum_1yearago	= . 

* For Poulty data is for 3 months ago, created as missing for compatibility.
gen nb_poultry_1yearago		= . 
gen nb_chickens_1yearago	= . 

* Other cuts across the different data files and therefore some elements have
* one year ago, some 6 months and some 3 months. Created as missing for
* compatibility
gen nb_other_ls_1yearago	= .

/* Current Livestock Holdings */
* Combine ownership numbers from all of the different livestock subsections
egen nb_ls_today = rowtotal(a6aq5a a6bq5a a6cq5a) if lvstckid != 42

* Assign the amount of livestock owned today to the various categories
gen nb_cattle_today		= nb_ls_today	if cattle == 1
gen nb_smallrum_today	= nb_ls_today	if smallrum == 1
gen nb_poultry_today	= nb_ls_today	if poultry == 1
gen nb_other_ls_today	= nb_ls_today 	if other_ls == 1
gen nb_cows_today		= nb_ls_today	if cows == 1
gen nb_chickens_today	= nb_ls_today	if chicken == 1
gen tlu_today			= nb_ls_today * tlu_coefficient

* Collapse to the household level
recode tlu_* nb_* (. = 0)
collapse (sum) tlu_* nb_*, by (HHID)

* Label the newly created variables (today)
lab var nb_cattle_today "Number of cattle owned as of the time of survey"
lab var nb_smallrum_today "Number of small ruminants owned as of the time of survey"
lab var nb_poultry_today "Number of poultry owned as of the time of survey"
lab var nb_other_ls_today "Number of other livestock (donkey, horse/mule, pigs, and rabbits) owned as of the time of survey"
lab var nb_cows_today "Number of cows owned as of the time of survey"
lab var nb_chickens_today "Number of chickens owned as of the time of survey"
lab var tlu_today "Tropical Livestock Units as of the time of survey"

* Label the newly created variables (1 year ago)
lab var nb_cattle_1yearago "Number of cattle owned as of 12 months ago"
lab var nb_cows_1yearago "Number of cows owned as of 12 months ago"
lab var tlu_1yearago "Tropical Livestock Units as of 12 months ago"
lab var nb_smallrum_1yearago /*
	*/ "Number of small ruminants owned as of 12 months ago"
lab var nb_poultry_1yearago "Number of cattle poultry as of 12 months ago"
lab var nb_other_ls_1yearago /*
	*/ "Number of other livestock (dog, donkey, and other) owned as of 12 months ago"
lab var nb_chickens_1yearago "Number of chickens owned as of 12 months ago"

* Get rid of the TLU coefficient
drop tlu_coefficient

save "${UGA_W2_created_data}/Uganda_NPS_W2_TLU_Coefficients.dta", /*
	*/ replace

********************************************************************************
*                              GROSS CROP REVENUE                              *
********************************************************************************
use "${UGA_W2_raw_data}/AGSEC5A", clear
append using "${UGA_W2_raw_data}/AGSEC5B.dta"

* Drop observations without a plot id or a parcel id
drop if missing(pltid) | missing(prcid)

* Standardizing major variable names across waves/files
rename pltid plot_id
rename cropID crop_code
rename prcid parcel_id

* Set uniform variable names across seasons/waves for: 
* quantity harvested		condition at harvest 	unit of measure at harvest
* conversion to kg			quantity sold			condition at sale
* unit of measure at sale	value harvested

rename a5aq6a qty_harvest
replace qty_harvest =  a5bq6a 		if missing(qty_harvest)

rename a5aq6b condition_harv
replace condition_harv = a5bq6b 	if missing(condition_harv)

rename a5aq6c unit_harv 
replace unit_harv = a5bq6c 			if missing(unit_harv)

rename a5aq6d conversion
replace conversion = a5bq6d 		if missing(conversion)

rename a5aq7a qty_sold
replace qty_sold = a5bq7a 			if missing(qty_sold)

rename a5aq7b condition_sold
replace condition_sold = a5bq7b		if missing(condition_sold)

rename a5aq7c unit_sold
replace unit_sold = a5bq7c 			if missing(unit_sold)

rename a5aq8 value_sold
replace value_sold = a5bq8 			if missing(value_sold)

* KGs harvested = quantity harvested times conversion factor
gen kgs_harvest = qty_harvest * conversion
* There is one observation with some qty_harvest but no conversion which can be
* converted into kgs easily
replace kgs_harvest = qty_harvest * 20 if unit_harv == 37 & missing(kgs_harvest)

* KGs sold = quantity sold * conversion if the units and condition have not
* changed since harvest
gen kgs_sold = qty_sold * conversion if condition_sold == condition_harv & /*
	*/ unit_sold == unit_harv

* Find out what units_sold are used for entries where condition or units changed
* from harvest to sale
// bysort unit_sold : count if missing(kgs_sold) & qty_sold > 0 & qty_sold != .

* Codes for Units sold with a missing value for kgs_sold and some qty_sold:
* 01: kilograms				02: Gram					03: Litre 
* 04: Small Cup w/ Handle	05: Metre					06: Square Metre (???)
* 07: Yard 					08: Millilitre				09: Sack (120kg)^
* 10: Sack (100kg)^			11: Sack (80kg)^			12: Sack (50kg)^
* 15: Jerrican (10lts)		18: Jerrican (2lts)			20: Tin (20lts)
* 22: Plastic Basin (15lts)	24: Bottle (500ml)			25: Bottle (350ml)
* 30: Kimbo Tin (1???)		32: Cup/Mug (0.5lt)			33: Glass (.25lt)
* 37: Basket (20kg)^		38: Basket (10kg)^			39: Basket (5kg)^
* 44: Buns (100g)^			45: Buns (50g)^				50: Packet (1kg)^
* 58: Fish - Cut up to 1 kg	60: Fish - Cut Above 2 kg	63: Crate
* 67: Bunch (big)			68: Bunch (medium)			69: Bunch (small)
* 70: Cluster (unspecified)	74: Gologolo (4-5lts)		80: Tot (50ml)
* 85: Number of Units		87: Other (specify)			98+: Invalid
* The largest group is those missing units sold 
* Entries marked with ^ are easily converted to kgs_sold and that is done below

replace kgs_sold = qty_sold 		if (unit_sold == 1 | unit_sold == 50 ) /*
													 */& missing(kgs_sold)
replace kgs_sold = qty_sold * 120 	if unit_sold == 9  & missing(kgs_sold)
replace kgs_sold = qty_sold * 100 	if unit_sold == 10 & missing(kgs_sold)
replace kgs_sold = qty_sold * 80 	if unit_sold == 11 & missing(kgs_sold)
replace kgs_sold = qty_sold * 50 	if unit_sold == 12 & missing(kgs_sold)
replace kgs_sold = qty_sold * 20	if unit_sold == 37 & missing(kgs_sold)
replace kgs_sold = qty_sold * 10	if unit_sold == 38 & missing(kgs_sold)
replace kgs_sold = qty_sold * 5 	if unit_sold == 39 & missing(kgs_sold)
replace kgs_sold = qty_sold / 10	if unit_sold == 44 & missing(kgs_sold)
replace kgs_sold = qty_sold / 20	if unit_sold == 45 & missing(kgs_sold)


* For those missing information on units or condition sold but without conflict
* between condition sold or unit sold 
replace kgs_sold = qty_sold * conversion if missing(kgs_sold) 				& /*
		*/  (qty_sold > 0   &  ~missing(conversion)  &  ~missing(qty_sold)) & /*
		*/ ((missing(condition_sold) |    condition_sold == condition_harv) & /*
		*/  (missing(unit_sold)      |    unit_sold      ==      unit_harv))
// NOTE: There are still 323 which have not been addressed by the above measures
// Two largest categories of units are Tin (20lts) - 102 - and Missing - 75. 

*Collapse to parcel level and label
collapse (sum) kgs_harvest kgs_sold value_sold , /*
		*/ by (HHID parcel_id plot_id crop_code)

* Calculate the price per kg
gen price_kg = value_sold / kgs_sold
recode price_kg (0 = .)

* Merge in Household data
merge m:1 HHID using "${UGA_W2_created_data}/Uganda_NPS_W2_hhids.dta"/*
	*/, keep(1 3)
drop _merge

* Label generated variables
lab var kgs_harvest /*
	*/ "Kgs harvested of this crop summed over both growing seasons"
lab var value_sold "Value sold of this crop summed over both growing seasons"
lab var kgs_sold "Kgs sold of this crop summed over both growing seasons"
lab var price_kg "Price per kg sold"


save "${UGA_W2_created_data}/Uganda_NPS_W2_crop_sales.dta", replace

  /*********************************/
 /* Impute Crop Prices from Sales */
/*********************************/

use "${UGA_W2_created_data}/Uganda_NPS_W2_crop_sales.dta", clear
gen observation = 1

* Median Price at the enumeration area level
preserve
	bysort region district county subcounty parish ea crop_code : /*
		*/ egen obs_ea = count(observation)
	* Find the median price and the number of observations
	collapse (median) price_kg [aw=weight] , /*
		*/ by (region district county subcounty parish ea obs_ea crop_code) 
	rename price_kg price_kg_median_ea

	label variable price_kg_median_ea /*
		*/ "Median price per kg for this crop in the enumeration area"
	label variable obs_ea /*
		*/ "Number of sales observed for this crop in the enumeration area"
	save "${UGA_W2_created_data}/Uganda_NPS_W2_crop_prices_ea.dta", /*
		*/ replace
restore

* Median Price at the parish level
preserve
	bysort region district county subcounty parish crop_code : /*
		*/ egen obs_parish = count(observation)
	* Find the median price and the number of observations
	collapse (median) price_kg [aw=weight] , /*
		*/ by (region district county subcounty parish obs_parish crop_code) 
	rename price_kg price_kg_median_parish

	label variable price_kg_median_parish /*
		*/ "Median price per kg for this crop in the Parish"
	label variable obs_parish /*
		*/ "Number of sales observed for this crop in the Parish"
	save/*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_crop_prices_parish.dta",/*
	*/ replace
restore

* Median Price at the subcounty level
preserve
	bysort region district county subcounty crop_code : /*
		*/ egen obs_sub = count(observation)
	* Find the median price and the number of observations
	collapse (median) price_kg [aw=weight] , /*
		*/ by (region district county subcounty obs_sub crop_code) 
	rename price_kg price_kg_median_sub

	label variable price_kg_median_sub /*
		*/ "Median price per kg for this crop in the Subcounty"
	label variable obs_sub /*
		*/ "Number of sales observed for this crop in the Subcounty"
	save/*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_crop_prices_subcounty.dta",/*
	*/ replace
restore

* Median Price at the county level
preserve
	bysort region district county crop_code : /*
		*/ egen obs_county = count(observation)
	* Find the median price and the number of observations
	collapse (median) price_kg [aw=weight] , /*
		*/ by (region district county obs_county crop_code) 
	rename price_kg price_kg_median_county

	label variable price_kg_median_county /*
		*/ "Median price per kg for this crop in the County"
	label variable obs_county /*
		*/ "Number of sales observed for this crop in the County"
	save/*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_crop_prices_county.dta",/*
	*/ replace
restore

* Median Price at the District level
preserve
	bysort region district crop_code : /*
		*/ egen obs_district = count(observation)
	* Find the median price and the number of observations
	collapse (median) price_kg [aw=weight] , /*
		*/ by (region district obs_district crop_code) 
	rename price_kg price_kg_median_district

	label variable price_kg_median_district /*
		*/ "Median price per kg for this crop in the District"
	label variable obs_district /*
		*/ "Number of sales observed for this crop in the District"
	save/*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_crop_prices_district.dta",/*
	*/ replace
restore

* Median Price at the Region level
preserve
	*Count number of observations
	bysort region crop_code : /*
		*/ egen obs_region = count(observation)
	* Find the median price for the region
	collapse (median) price_kg [aw=weight] , /*
		*/ by (region obs_region crop_code) 
	rename price_kg price_kg_median_region

	label variable price_kg_median_region /*
		*/ "Median price per kg for this crop in the Region"
	label variable obs_region /*
		*/ "Number of sales observed for this crop in the Region"
	save/*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_crop_prices_region.dta",/*
	*/ replace
restore

* Median Price at the Country level
preserve
	bysort crop_code : /*
		*/ egen obs_country = count(observation)
	* Find the median price and the number of observations
	collapse (median) price_kg [aw=weight] , /*
		*/ by ( obs_country crop_code) 
	rename price_kg price_kg_median_country

	label variable price_kg_median_country /*
		*/ "Median price per kg for this crop in the Country"
	label variable obs_country /*
		*/ "Number of sales observed for this crop in the Coutry"
	save/*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_crop_prices_country.dta",/*
	*/ replace
restore

drop observation

* Merge back in the median prices found above
* Enumeration Area
merge m:1 region district county subcounty parish ea crop_code /*
	*/ using "${UGA_W2_created_data}/Uganda_NPS_W2_crop_prices_ea", /*
	*/ nogen
* Parish
merge m:1 region district county subcounty parish crop_code  using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_crop_prices_parish", /*
	*/ nogen 
* Subcounty
merge m:1 region district county subcounty crop_code using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_crop_prices_subcounty", /*
	*/ nogen
* County
merge m:1 region district county crop_code using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_crop_prices_county", /*
	*/ nogen
* District
merge m:1 region district crop_code using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_crop_prices_district", /*
	*/ nogen
* Region
merge m:1 region crop_code using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_crop_prices_region", /*
	*/ nogen
* Country
merge m:1 crop_code using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_crop_prices_country", /*
	*/ nogen

gen price_kg_hh = price_kg

* Impute prices using median values from the smallest area with at least
* 10 observations (excludes crops marked as other)
replace price_kg = price_kg_median_ea		if missing(price_kg) & /*
	*/ obs_ea 		>= 10 	& crop_code != 890	&	~missing(obs_ea)

replace price_kg = price_kg_median_parish	if missing(price_kg) & /*
	*/ obs_parish	>= 10	& crop_code != 890	&	~missing(obs_parish)

replace price_kg = price_kg_median_sub		if missing(price_kg) & /*
	*/ obs_sub		>= 10 	& crop_code != 890	&	~missing(obs_sub)

replace price_kg = price_kg_median_county	if missing(price_kg) & /*
	*/ obs_country	>= 10	& crop_code != 890	&	~missing(obs_county)

replace price_kg = price_kg_median_district	if missing(price_kg) & /*
	*/ obs_district	>= 10 	& crop_code != 890	& 	~missing(obs_district)

replace price_kg = price_kg_median_region	if missing(price_kg) & /*
	*/ obs_region 	>= 10	& crop_code != 890	&	~missing(obs_region)

replace price_kg = price_kg_median_country	if missing(price_kg) & /*
	*/ obs_country	>= 10	& crop_code != 890	&	~missing(obs_country)

label variable price_kg /*
	*/ "Price per kg, with missing values imputed using local median values"

* Since we don't have value harvested this is the best we can do. Value 
* harvested is equal to the price per kg times the number of kgs. When there is
* no value_sold or kg_sold value the smallest area median with at least 10 
* observations is used for the price per kilogram.
gen value_harvest_imputed = kgs_harvest * price_kg
recode value_harvest_imputed (. = 0)

save "${UGA_W2_created_data}/Uganda_NPS_W2_crop_values_temp.dta", /*
		*/ replace
  /**************************************/
 /* Household Crop Values - Production */
/**************************************/
preserve

	recode value_sold kgs_harvest kgs_sold (. = 0)
	* Collapse to the Crop-Household level for values sold and harvested, and
	* kgs sold and harvested
	collapse (sum) value_harvest_imputed value_sold kgs_harvest kgs_sold, /*
		*/ by(HHID crop_code)

	* Rename and label variables 
	rename value_harvest_imputed value_crop_production
	rename value_sold value_crop_sales 

	label variable value_crop_production "Gross value of crop production"
	label variable value_crop_sales "Value of crop sold so far"
	label variable kgs_harvest "Kgs harvested of this crop"
	label variable kgs_sold "Kgs sold of this crop"
	save "${UGA_W2_created_data}/Uganda_NPS_W2_hh_crop_values_production.dta", /*
		*/ replace
restore

  /******************************/
 /* Household Mean Crop Prices */ 
/******************************/
preserve

	collapse (mean) price_kg, by (HHID crop_code)
	save "${UGA_W2_created_data}/Uganda_NPS_W2_hh_crop_prices.dta", /*
		*/replace
restore

* Collapse value vars to the household level across all crops
collapse (sum) value_harvest_imputed value_sold, by(HHID) 

* If the estimate for value harvested is less than the reported value sold 
* replace the estimate with the reported value sold - you cannot sell more than
* you harvest.
replace value_harvest_imputed = value_sold if 							  /*
	*/ value_sold > value_harvest_imputed	 &	~missing(value_sold) 	& /*
	*/ ~missing(value_harvest_imputed)

* Calculate the proportion of crops sold vs. harvested
gen proportion_cropvalue_sold = value_sold / value_harvest_imputed

* Rename and label value variables to reflect that this is for all crops in 
* the household. 
rename value_harvest_imputed value_crop_production
rename value_sold value_crop_sales

* label constructed variables. 
label variable value_crop_production /*
	*/ "Gross value of crop production for the household"
label variable value_crop_production "Value of all crops sold so far"
label variable proportion_cropvalue_sold /*
	*/ "Proportion of crop value produced which has been sold"
save "${UGA_W2_created_data}/Uganda_NPS_W2_hh_crop_production.dta", /*
	*/ replace

  /***************************/
 /* Crops Lost Post Harvest */
/***************************/
use "${UGA_W2_raw_data}/AGSEC5A", clear
append using "${UGA_W2_raw_data}/AGSEC5B.dta"

* Drop observations without a plot id or a parcel id
drop if missing(pltid) | missing(prcid)

* Standardizing major variable names across waves/files
rename pltid plot_id
rename cropID crop_code
rename prcid parcel_id

* Unify the first and second season responses into one variable
rename a5aq6a qty_harvest
replace qty_harvest =  a5bq6a 	if missing(qty_harvest)

rename a5aq6d conversion
replace conversion = a5bq6d 	if missing(conversion)

rename a5aq16 percent_lost
replace percent_lost = a5bq16	if missing(percent_lost)

* Some of the entries have percent lost from 1-100 rather than 0-1
replace percent_lost = percent_lost / 100 if percent_lost > 1 & /*
		*/ ~missing(percent_lost)

* KGs harvested = quantity harvested times conversion factor
gen kgs_harvest = qty_harvest * conversion

* Calculate the Kgs Lost
gen kgs_lost = kgs_harvest * percent_lost

* merge in price per kg data. 
merge m:1 HHID parcel_id plot_id crop_code using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_crop_values_temp.dta", /*
	*/ keep(1 3)

* Multiple kgs lost by price per kg (imputed) to 
gen crop_value_lost = kgs_lost * price_kg

* Sum losses for the entire household. 
collapse (sum) crop_value_lost, by(HHID)
label variable crop_value_lost /*
	*/ "Value of crop production which had been lost by the time of the survey"
save "${UGA_W2_created_data}/Uganda_NPS_W2_crop_losses.dta", replace


********************************************************************************
*                                 CROP EXPENSES                                *
********************************************************************************

  /*******************/
 /* Expenses: Labor */
/*******************/
use "${UGA_W2_raw_data}/AGSEC3A.dta", clear

drop if missing(pltid) | missing(prcid)

merge 1:m HHID prcid pltid using /*
	*/ "${UGA_W2_raw_data}/AGSEC5A", keep(1 3) nogen

* Rename pltid and prcid for cross wave/file standardization
rename pltid plot_id
rename prcid parcel_id
rename a3aq43 wages_paid_main

* Merge in plot manager gender information.
merge m:1 HHID parcel_id using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_plot_decision_makers.dta"
gen season = 0

foreach cn in $topcropname_area {
	preserve

		gen wages_paid_main_`cn' = wages_paid_main
		* Disaggregate wages by gender
		forvalues i=1 (1) `gender_len' {
			local g : word `i' of `genders'
			gen wages_paid_main_`cn'_`g' = wages_paid_main if dm_gender == `i'
		}
		* Merge in data for previous monocrop information
		merge m:1 HHID parcel_id season using /*
		*/ "${UGA_W2_created_data}/Uganda_NPS_W2_`cn'_monocrop.dta", /*
		*/ nogen keep(3) // assert(1 3)
		collapse (sum) wages_paid_main_`cn'*, by (HHID)
		
		* Label newly created variables
		label variable wages_paid_main_`cn' /*
		*/ "Wages paid for hired labor in the first growing season - Monocropped `cn' plots"
		foreach g in `genders' {
			label variable wages_paid_main_`cn'_`g' /*
			*/ "Wages paid for hired labor in the first growing season - `g'-managed Monocropped `cn' plots"
		}
		save "${UGA_W2_created_data}/Uganda_NPS_W2_wages_mainseason_`cn'.dta", /*
		*/ replace
	restore
}

* Collapse to the household level
collapse (sum) wages_paid_main, by (HHID)
* Label wages paid
label variable wages_paid_main /*
	*/ "Wages paid for hired labor (crops) in the first growing season"

save "${UGA_W2_created_data}/Uganda_NPS_W2_wages_mainseason.dta", /*
	*/ replace

/* Labor Expenses Second Growing Season */

use "${UGA_W2_raw_data}/AGSEC3B", clear

* Get rid of entries missing necessary information
drop if missing(pltid) | missing(prcid)

* merge in crop data
merge 1:m HHID prcid pltid using /*
	*/ "${UGA_W2_raw_data}/AGSEC5B", keep(1 3) nogen

* Rename for consistency across waves/countries
rename pltid plot_id
rename prcid parcel_id
rename a3bq43 wages_paid_short

* Merge in plot manager gender data
merge m:1 HHID parcel_id using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_plot_decision_makers.dta"
* Generating season used to match with the monocrop data
gen season = 1

foreach cn in $topcropname_area {
	preserve
		gen wages_paid_short_`cn' = wages_paid_short
		* Merge in data for previous monocrop information
		merge m:1 HHID parcel_id season using /*
		*/ "${UGA_W2_created_data}/Uganda_NPS_W2_`cn'_monocrop.dta", /*
		*/ nogen keep(3) // assert(1 3)
		* Disaggregate wages paid by gender
		forvalues i=1 (1) `gender_len' {
			local g : word `i' of `genders'
			gen wages_paid_short_`cn'_`g' = wages_paid_short if dm_gender == `i'
		}

		// NOTE: No one surveyed in this wave planted wheat during the second 
		// growing season the quiet count and if `r(N)' != 0 prevent the code 
		// from crashing when this happens. 
		quiet count
		if `r(N)' != 0 collapse (sum) wages_paid_short_`cn'*, by (HHID)
		
		* Label newly created variables
		label variable wages_paid_short_`cn' /*
		*/ "Wages paid for hired labor in the second growing season - Monocropped `cn' plots"
		* Label the gender disaggregrated versions of the variable
		foreach g in `genders' {
			label variable wages_paid_short_`cn'_`g' /*
			*/ "Wages paid for hired labor in the second growing season - Monocropped `g' `cn' plots"
		}
		save "${UGA_W2_created_data}/Uganda_NPS_W2_wages_shortseason_`cn'.dta", /*
		*/ replace
	restore
}

* Now collapse the general wages paid to the household level
collapse (sum) wages_paid_short, by (HHID)

label variable wages_paid_short /*
	*/ "Wages paid for hired labor (crops) in the second growing season"
save "${UGA_W2_created_data}/Uganda_NPS_W2_wages_shortseason.dta", /*
	*/ replace
 
  /***************/
 /* Land Rights */
/***************/

use "${UGA_W2_raw_data}/AGSEC2A", clear

* The respondent has formal land rights to the parcel in questions (Certificate
* of title, customary ownership, or occupancy)
gen formal_land_rights = a2aq25 != 4

* Is either of the owners a woman?
* Check gender of first owner
preserve
	* Rename first owner variable to individ for merging
	rename a2aq26a personid
	* Mergin in gender data
	merge m:1 HHID personid using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_person_ids", keep(3) nogen
	* Drop unnecessary columns
	keep HHID personid female formal_land_rights
	* Create a temporary save file for owner 1 gender/rights data
	tempfile owner1
	save `owner1', replace
restore

* Check gender of second owner
preserve 
	* Rename second owner variable to individ for merging
	rename a2aq26b personid
	* Mergin in gender data
	merge m:1 HHID personid using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_person_ids", keep(3) nogen
	keep HHID personid female formal_land_rights
	* Add in the information from the first owner
	append using `owner1'
	* Create a dummy interaction variable for women with formal landrights
	gen formal_land_rights_f =	 formal_land_rights == 1	&	female == 1
	* Roll everything up to the individual level
	collapse (max) formal_land_rights_f, by(HHID personid)
	save "${UGA_W2_created_data}/Uganda_NPS_W2_land_rights_ind.dta", /*
		*/ replace
restore
* Roll land rights information up to the househould level
collapse (max) formal_land_rights_hh = formal_land_rights, by (HHID)
save "${UGA_W2_created_data}/Uganda_NPS_W2_land_rights_hh.dta", replace

  /********************/
 /* Expenses: Inputs */
/********************/
use "${UGA_W2_raw_data}/AGSEC3A", clear
append using "${UGA_W2_raw_data}/AGSEC3B", gen(season)
drop if missing(prcid) | missing(pltid)

* Rename key variables for cross wave/country compliance
rename prcid parcel_id
rename pltid plot_id

* Combine the purchase value of inputs for both seasons into a single variable
* For fertilizer,
gen value_inorg_fert 		= a3aq19
replace value_inorg_fert 	= a3bq19	if missing(value_inorg_fert)
* and pesticide
gen value_pesticide 		= a3aq31 
replace value_pesticide 	= a3bq31	if missing(value_pesticide)

recode value_* (.=0)

* Create monocropped plots disaggregation
foreach cn in $topcropname_area {
	preserve
		* Merge in plot manager gender data
		merge m:1 HHID parcel_id using /*
		*/ "${UGA_W2_created_data}/Uganda_NPS_W2_plot_decision_makers"
		* Merge in monocropped plot data
		merge m:1 HHID parcel_id season using /*
		*/ "${UGA_W2_created_data}/Uganda_NPS_W2_`cn'_monocrop", /*
		*/ keep(3) nogen //assert(1 3)
		foreach i in value_inorg_fert value_pesticide {
			gen `i'_`cn' = `i'
			* Perform gender disaggregations
			forvalues j = 1 (1) `gender_len' {
				local g : word `j' of `genders'
				gen `i'_`cn'_`g'		= `i'	if dm_gender == `j'
			}
		}
		* Roll fertilizer and pesticide costs up to the household level
		collapse (sum) value_inorg_fert_`cn'* value_pesticide_`cn'*, by (HHID)
		* Label variables
		lab var value_inorg_fert_`cn' /*
		*/ "Value of fertilizer purchased (not used) all seasons - Monocropped `cn' plots only"
		lab var value_pesticide_`cn' /*
		*/ "Value of pesticide purchased (not used) all seasons - Monocropped `cn' plots only"
		*Label gendered versions of the variables
		foreach g in `genders' {
			label variable value_inorg_fert_`cn'_`g' /*
			*/"Value of fertilizer purchased - `g' managed Monocropped `cn' plots only"
			label variable value_pesticide_`cn'_`g' /*
			*/"Value of pesticide purchased - `g' managed Monocropped `cn' plots only"
		}
		save "${UGA_W2_created_data}/Uganda_NPS_W2_fertilizer_costs_`cn'.dta", /*
			*/ replace
	restore
}

*Roll up inputs to household level
collapse (sum) value_inorg_fert value_pesticide, by (HHID)

* *Label the new variables
label variable value_inorg_fert /*
	*/ "Value of fertilizer purchased (not the same as used) all seasons"
label variable value_pesticide /*
	*/ "Value of pesticide purchased (not the same as used) all seasons"

* Save to disk
save "${UGA_W2_created_data}/Uganda_NPS_W2_fertilizer_costs.dta", /*
	*/ replace

  /******************/
 /* Expenses: Seed */
/******************/
* Load in data
use "${UGA_W2_raw_data}/AGSEC4A", clear
append using "${UGA_W2_raw_data}/AGSEC4B", gen(season)
* Rename key variables for cross wave/country compliance
rename prcid parcel_id
rename pltid plot_id

* Create a unified seed cost variable across seasons
gen cost_seed = a4aq11
replace cost_seed = a4bq11 if missing(cost_seed)
recode cost_seed (.=0)

* Disaggregate by crop - monocropped plots only
foreach cn in $topcropname_area {
	preserve
		* Merge in decision maker gender data
		merge m:1 HHID parcel_id  using /*
		*/ "${UGA_W2_created_data}/Uganda_NPS_W2_plot_decision_makers"
		
		* Disaggregate by gender
		forvalues j = 1 (1) `gender_len' {
			local g : word `j' of `genders'
			gen cost_seed_`cn'_`g' = cost_seed if dm_gender == `j'
		}

		* Change name to include crop name
		rename cost_seed cost_seed_`cn'

		* Collapse to the parcel-season level
		collapse (sum) cost_seed_`cn'*, by(HHID parcel_id season)

		* Merge in monocrop plot data created earlier.
		merge 1:1 HHID parcel_id season using /*
		*/ "${UGA_W2_created_data}/Uganda_NPS_W2_`cn'_monocrop", /*
		*/ nogen keep(3) assert(1 3)	
		* Collapse to the household level
		collapse (sum) cost_seed_`cn'*, by(HHID)
		* Label the new variables
		lab var cost_seed_`cn' /*
		*/ "Expenditures on seed for temporary crops - Monocropped `cn' plots only"
		* Label gendered versions of the variable
		foreach g in `genders' {
			label variable cost_seed_`cn'_`g' /*
			*/ "Expenditures on seed for temporary crops - `g'-managed Monocropped `cn' plots only"
		}
		* Save to disk
		save "${UGA_W2_created_data}/Uganda_NPS_W2_seed_costs_`cn'.dta", /*
			*/ replace
	restore
}

* Collapse to the household level
collapse (sum) cost_seed, by(HHID)
label variable cost_seed "Expenditures on seed for temporary crops"
save "${UGA_W2_created_data}/Uganda_NPS_W2_seed_costs.dta", replace

  /*************************/
 /* Expenses: Land Rental */
/*************************/


* Load the data
use "${UGA_W2_raw_data}/AGSEC2B", clear

* Rename key variables for cross wave/country compliance
rename	prcid parcel_id
rename	a2bq9 rental_cost_land

*	Recode missing to 0, assume missing entry means they did not have to pay 
* 	to use the land
recode	rental_cost_land (.=0)

* Count the number of seasons the land was used for crop cultivation
gen	seasons_productive = inlist(a2bq15a, 1, 2, 3, 6) + /*
	*/	inlist(a2bq15b, 1, 2, 4, 6)
	
foreach cn in $topcropname_area {
	preserve
		* Merge in gender of plot manager
		merge 1:1 HHID parcel_id using /*
		*/ "${UGA_W2_created_data}/Uganda_NPS_W2_plot_decision_makers"
		* Merge in Monocrop info getting rid of any unmatched plots
		merge 1:m HHID parcel_id using /*
		*/ "${UGA_W2_created_data}/Uganda_NPS_W2_`cn'_monocrop", /*
		*/ nogen  keep(3) assert(1 3)
		
		* Prevent divide by zero problem		
		recode seasons_productive (0=1)
		
		* Create the crop specific version of the variable
		gen rental_cost_land_`cn' = rental_cost_land / seasons_productive

		* Disaggregate by gender of the plot manager
		forvalues j = 1 (1) `gender_len' {
			local g : word `j' of `genders'
			gen rental_cost_land_`cn'_`g' = rental_cost_land if dm_gender == `j'
		}
		* Collapse to the Household level
		collapse (sum) rental_cost_land_`cn'*, by(HHID)
		// NOTE SAK 20190701:  This will double count any rental costs for plots
		// planted in both seasons. 

		* Label the new variables
		label variable rental_cost_land_`cn' /*
		*/ "Rental costs paid for land - Monocropped `cn' plots only"
		foreach g in `genders' {
			label variable rental_cost_land_`cn'_`g' /*
			*/ "Rental costs paid for land - `g'-managed Monocropped `cn' plots only"
		}
		save "${UGA_W2_created_data}/Uganda_NPS_W2_land_rental_costs_`cn'.dta", /*
			*/ replace
	restore
}
collapse (sum) rental_cost_land, by(HHID)
label variable rental_cost_land "Rental costs paid for land"
save "${UGA_W2_created_data}/Uganda_NPS_W2_land_rental_costs.dta", /*
	*/ replace

  /***************************/
 /* Expenses: Asset Rentals */
/***************************/

* Load the data from disk
use "${UGA_W2_raw_data}/AGSEC10", clear

* Is this observation related to animal traction (ox plough)
gen animal_traction	= itmcd == 14
* Is this observation related to machine traction (plough, tractor, trailer,
* harrow/cultivator)
gen tractor 		= inlist(itmcd, 2, 6, 15, 16)
* Everything else
gen ag_asset		= ~tractor & ~animal_traction & ~missing(itmcd)

* Rename for ease
rename a10q8 rental_cost

* Assign rental costs to categories
gen rental_cost_animal_traction	= rental_cost	if animal_traction
gen rental_cost_tractor			= rental_cost	if tractor
gen rental_cost_ag_asset		= rental_cost 	if ag_asset


* Collapse to the household level
collapse (sum) rental_cost_*, by(HHID)

* Label the newly created variables
label variable rental_cost_animal_traction "Costs for renting animal traction"
label variable rental_cost_ag_asset "Costs for renting other agricultural items"
label variable rental_cost_tractor "Costs for renting a tractor"
save "${UGA_W2_created_data}/Uganda_NPS_W2_asset_rental_costs.dta", /*
	*/ replace

  /****************************/
 /* Expenses: Crop Transport */
/****************************/
* Load the data
use "${UGA_W2_raw_data}/AGSEC5A", clear
append using "${UGA_W2_raw_data}/AGSEC5B"

* Rename key variables for cross wave/country compliance
rename prcid parcel_id

* Consolidate transport costs across seassons 
rename a5aq10 transport_costs_cropsales
replace transport_costs_cropsales = a5bq10 if missing(transport_costs_cropsales)
recode transport_costs_cropsales (.=0)
* Collapse to the household level.
collapse (sum) transport_costs_cropsales, by(HHID)

* Label the new variable.
label variable transport_costs_cropsales /*
	*/ "Expenditures on transportation for crop sales"

* Save to disk
save "${UGA_W2_created_data}/Uganda_NPS_W2_transportation_cropsales.dta", /*
	*/ replace

  /******************************/
 /* Expenses: Total Crop Costs */
/******************************/
* Load and merge all the data just created
use "${UGA_W2_created_data}/Uganda_NPS_W2_asset_rental_costs", clear
merge 1:1 HHID using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_land_rental_costs", nogen
merge 1:1 HHID using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_seed_costs", nogen
merge 1:1 HHID using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_fertilizer_costs", nogen
merge 1:1 HHID using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_wages_shortseason", nogen
merge 1:1 HHID using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_wages_mainseason", nogen
merge 1:1 HHID using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_transportation_cropsales", /*
	*/ nogen

* Recode any missing values to 0
recode rental_cost_* cost_seed value_* wages_paid_* transport_costs_* (.=0)

* Sum all the costs for the household
egen crop_production_expenses = rowtotal(*cost* value_* wages_paid_*)


* Label the newly created variable
label variable crop_production_expenses "Total crop production expenses"

* Save to disk
save "${UGA_W2_created_data}/Uganda_NPS_W2_crop_income.dta", replace


********************************************************************************
*                               LIVESTOCK INCOME                               *
********************************************************************************

  /**********************/
 /* Livestock Expenses */
/**********************/
* Load the data
use "${UGA_W2_raw_data}/AGSEC7", clear

* Place livestock costs into categories
generate cost_hired_labor_livestock	= a7q4 	if a7q2 == 1
generate cost_fodder_livestock		= a7q4	if a7q2 == 2
generate cost_vaccines_livestock	= a7q4	if a7q2 == 3
generate cost_other_livestock		= a7q4	if a7q2 == 4
* Water costs are not captured outside of "other"
generate cost_water_livestock		= 0

recode cost_* (.=0)
preserve
	* Species is not captured for livestock costs, and so this disaggregation
	* is impossible. Created for conformity with other waves
	gen cost_lrum = .
	keep HHID cost_lrum
	label variable cost_lrum "Livestock expenses for large ruminants"
	save "${UGA_W2_created_data}/Uganda_NPS_W2_lrum_expenses", replace
restore

* Collapse Livestock costs to the household level
collapse (sum) cost_*, by(HHID)

label variable cost_water_livestock			"Cost for water for livestock"
label variable cost_fodder_livestock 		"Cost for fodder for livestock"
label variable cost_vaccines_livestock 		/*
	*/ "Cost for vaccines and veterinary treatment for livestock"
label variable cost_hired_labor_livestock	"Cost for hired labor for livestock"

* Save to disk
save "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_expenses.dta", /*
	*/ replace


  /**********************/
 /* Livestock Products */
/**********************/
* Load the data from disk
use "${UGA_W2_raw_data}/AGSEC8", clear

* Rename key variables for conformity across waves/countries
rename a8q2 livestock_code
rename a8q3 months_produced
rename a8q4 quantity_month
rename a8q5 unit
rename a8q6 quantity_month_sold
rename a8q7 earnings_month

* Minor data cleaning
drop if missing(livestock_code)
recode months_produced (12/max = 12)
* drop if there is a unit of 'other'
drop if unit == 6

* Standardize units. For all items reported with multiple units, the units
* were converted to the unit with the greatest number of observations,
* regardless of what the unit was. No products had observations with more than
* two units (except honey)

* Trays of eggs to numbers of eggs
replace unit			= 4 				  if livestock_code == 5 & unit == 3
replace quantity_month 	= quantity_month * 30 if livestock_code == 5 & unit == 3
* Litres of Ghee to KG.
replace unit 		   = 1 if livestock_code == 4 & unit == 2
replace quantity_month = quantity_month * .91	if livestock_code == 4 & /*
	*/	unit == 2
* Kgs of Honey to litres
replace unit 		   = 2 if livestock_code == 6 & unit == 1
replace quantity_month = quantity_month / 1.42 if livestock_code == 6 & /*
	*/	unit == 1

* Calculate amount produced, quantity produced, etc.
gen quantity_produced 	= months_produced * quantity_month
gen price_per_unit		= earnings_month  / quantity_month_sold 
gen earnings_sales		= earnings_month  * months_produced
gen price_per_unit_hh 	= price_per_unit

* Pull out milk observations for cross-country compatibility
gen price_per_liter		= price_per_unit 	if inlist(livestock_code, 1, 3) & /*
										*/  unit == 2
gen earnings_milk_year	= earnings_sales  	if inlist(livestock_code, 1, 3)

* Replace per unit prices (including price_per_liter for milk) with missing 
* rather than 0
recode price_per_*		(0=.)

* Label all of the newly created information
lab var quantity_produced	"Quantity of this product produced in past year"
lab var price_per_liter		"Price of milk per liter sold"
lab var price_per_unit		"Unit price of the livestock product"
lab var price_per_unit_hh 	"Unit price of the livestock product"
lab var earnings_milk_year	"Total earnings of sale of milk produced"

* The next section seeks to impute prices based on the median per unit price
* for each of the goods. 
gen observation = 1 if ~missing(price_per_unit)
merge m:1 HHID using "${UGA_W2_created_data}/Uganda_NPS_W2_hhids", /*
	*/ nogen keep(1 3)
save "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_products", replace

* Price Imputation *
********************
preserve
	bysort region district county subcounty parish ea livestock_code : /*
		*/ egen obs_ea = count(observation)
	* Find the median price and the number of observations
	collapse (median) price_per_unit [aw=weight] , /*
		*/ by (region district county subcounty parish ea obs_ea /*
			*/ livestock_code) 
	rename price_per_unit price_median_ea

	label variable price_median_ea /*
		*/ "Median price per kg for this livestock product in the enumeration area"
	label variable obs_ea /*
		*/ "Number of sales observed for this livestock product in the enumeration area"
	save "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_product_prices_ea.dta", /*
		*/ replace
restore

* Median Price at the parish level
preserve
	bysort region district county subcounty parish livestock_code : /*
		*/ egen obs_parish = count(observation)
	* Find the median price and the number of observations
	collapse (median) price_per_unit [aw=weight] , /*
		*/ by (region district county subcounty parish obs_parish /*
		*/ livestock_code) 
	rename price_per_unit price_median_parish

	label variable price_median_parish /*
		*/ "Median price per kg for this livestock product in the Parish"
	label variable obs_parish /*
		*/ "Number of sales observed for this livestock product in the Parish"
	save/*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_product_prices_parish.dta",/*
	*/ replace
restore

* Median Price at the subcounty level
preserve
	bysort region district county subcounty livestock_code : /*
		*/ egen obs_sub = count(observation)
	* Find the median price and the number of observations
	collapse (median) price_per_unit [aw=weight] , /*
		*/ by (region district county subcounty obs_sub livestock_code) 
	rename price_per_unit price_median_sub

	label variable price_median_sub /*
		*/ "Median price per kg for this livestock product in the Subcounty"
	label variable obs_sub /*
		*/ "Number of sales observed for this livestock product in the Subcounty"
	save/*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_product_prices_subcounty.dta",/*
	*/ replace
restore

* Median Price at the county level
preserve
	bysort region district county livestock_code : /*
		*/ egen obs_county = count(observation)
	* Find the median price and the number of observations
	collapse (median) price_per_unit [aw=weight] , /*
		*/ by (region district county obs_county livestock_code) 
	rename price_per_unit price_median_county

	label variable price_median_county /*
		*/ "Median price per kg for this livestock product in the County"
	label variable obs_county /*
		*/ "Number of sales observed for this livestock product in the County"
	save/*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_product_prices_county.dta",/*
	*/ replace
restore

* Median Price at the District level
preserve
	bysort region district livestock_code : /*
		*/ egen obs_district = count(observation)
	* Find the median price and the number of observations
	collapse (median) price_per_unit [aw=weight] , /*
		*/ by (region district obs_district livestock_code) 
	rename price_per_unit price_median_district

	label variable price_median_district /*
		*/ "Median price per kg for this livestock product in the District"
	label variable obs_district /*
		*/ "Number of sales observed for this livestock product in the District"
	save/*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_product_prices_district.dta",/*
	*/ replace
restore

* Median Price at the Region level
preserve
	*Count number of observations
	bysort region livestock_code : /*
		*/ egen obs_region = count(observation)
	* Find the median price for the region
	collapse (median) price_per_unit [aw=weight] , /*
		*/ by (region obs_region livestock_code) 
	rename price_per_unit price_median_region

	label variable price_median_region /*
		*/ "Median price per kg for this livestock product in the Region"
	label variable obs_region /*
		*/ "Number of sales observed for this livestock product in the Region"
	save/*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_product_prices_region.dta",/*
	*/ replace
restore

* Median Price at the Country level
preserve
	bysort livestock_code : /*
		*/ egen obs_country = count(observation)
	* Find the median price and the number of observations
	collapse (median) price_per_unit [aw=weight] , /*
		*/ by ( obs_country livestock_code) 
	rename price_per_unit price_median_country

	label variable price_median_country /*
		*/ "Median price per kg for this livestock product in the Country"
	label variable obs_country /*
		*/ "Number of sales observed for this livestock product in the Country"
	save/*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_product_prices_country.dta",/*
	*/ replace
restore

drop observation
* Merge back in the median prices found above
* Enumeration Area
merge m:1 region district county subcounty parish ea livestock_code /*
	*/	using "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_product_prices_ea", /*
	*/	nogen
* Parish
merge m:1 region district county subcounty parish livestock_code /*
	*/	using "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_product_prices_parish", /*
	*/ nogen 
* Subcounty
merge m:1 region district county subcounty livestock_code /*
		*/using "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_product_prices_subcounty", /*
	*/ nogen
* County
merge m:1 region district county livestock_code using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_product_prices_county", /*
	*/ nogen
* District
merge m:1 region district livestock_code using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_product_prices_district", /*
	*/ nogen
* Region
merge m:1 region livestock_code using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_product_prices_region", /*
	*/ nogen
* Country
merge m:1 livestock_code using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_product_prices_country", /*
	*/ nogen

* Replace missing prices with imputed prices
replace price_per_unit = price_median_ea		if price_per_unit == . & /*
	*/ obs_ea		>= 10
replace price_per_unit = price_median_parish	if price_per_unit == . & /*
	*/ obs_parish	>= 10
replace price_per_unit = price_median_sub 		if price_per_unit == . & /*
	*/ obs_sub		>= 10
replace price_per_unit = price_median_county 	if price_per_unit == . & /*
	*/ obs_county	>= 10
replace price_per_unit = price_median_district	if price_per_unit == . & /*
	*/ obs_district	>= 10
replace price_per_unit = price_median_region	if price_per_unit == . & /*
	*/ obs_region	>= 10

* Disaggregate into separate livestock products
gen value_milk_produced			= quantity_produced * price_per_unit /*
	*/ if inlist(livestock_code, 1, 3)
gen value_eggs_produced			= quantity_produced * price_per_unit /*
	*/ if livestock_code == 5
gen value_other_produced		= quantity_produced * price_per_unit /*
	*/ if inlist(livestock_code, 2, 4, 6, 13, 14, 15)
gen sales_livestock_products	= earnings_sales

* Collapse to the household level
collapse (sum) value_*_produced sales_livestock_products, by(HHID)

* Sum total value of livestock products sold
egen value_livestock_products	= rowtotal(value_*_produced)

* Calculate share of livestock products sold
gen share_livestock_prod_sold	= sales_livestock_products / /*
	*/ value_livestock_products

* Label the variables
label variable value_livestock_products /*
	*/ "value of livestock products produced (milk, egss, other)"
label variable value_other_produced	/*
	*/ "value of ghee, honey, skins, goat milk and blood produced"
label variable value_eggs_produced	"Value of eggs produced"
label variable value_milk_produced	"Value of milk produced"

* Recode 0s to missing
recode value_*_produced 		(0=.)

* Save to disk
save "${UGA_W2_created_data}/Uganda_NPS_W2_hh_livestock_products", /*
	*/ replace

  /***********************/
 /* Sales: Live Animals */
/***********************/
* Load data from disk
use "${UGA_W2_raw_data}/AGSEC6A", clear
append using "${UGA_W2_raw_data}/AGSEC6B"
append using "${UGA_W2_raw_data}/AGSEC6C"

* Rename key variables for consistency across instruments
rename a6aq3 livestock_code
replace livestock_code = a6bq3	if missing(livestock_code)
replace livestock_code = a6cq3	if missing(livestock_code)

* Get rid of observations missing a livestock_code
drop if missing(livestock_code)

* Combine value labels for livestock_codes from the three files
* From Small Animals (Goat, sheep, pigs)
levelsof a6bq3, local(levs)
foreach v of local levs {
	label define a6aq3 `v' "`: label (a6bq3) `v''", add
}

* From Poultry/Rabbits/etc.
levelsof a6cq3, local(levs)
foreach v of local levs {
	label define a6aq3 `v' "`: label (a6cq3) `v''", add
}

* Combine number sold from three different files 
// NOTE: For small animals the amount is for the last 6 months and for Poultry
// and others the amount is the last 3 months. These are multiplied by 2 and 4 
// respectively to estimate the number for the last 12 months.
gen number_sold 			= a6aq14
replace number_sold			= a6bq14 * 2	if missing(number_sold)
replace number_sold			= a6cq14 * 4	if missing(number_sold)

* Combine income live sales from the three different files
// NOTE: see above for explanation of the multiplication for small animals and 
// poultry
gen income_live_sales		= a6aq15
replace income_live_sales	= a6bq15 * 2	if missing(income_live_sales)
replace income_live_sales	= a6cq15 * 4	if missing(income_live_sales)

* Combine number slaughtered from the three different files.
// NOTE: see above for explanation of the multiplication for small animals and 
// poultry
gen number_slaughtered		= a6aq16
replace number_slaughtered	= a6bq16 * 2	if missing(number_slaughtered)
replace number_slaughtered	= a6cq16 * 4	if missing(number_slaughtered)

* Combine value of livestock purchases from the three different files
gen value_livestock_purchases		= a6aq13
replace value_livestock_purchases	= a6bq13 * 2 /*
		*/ if missing(value_livestock_purchases)
replace value_livestock_purchases	= a6cq13 * 4 /*
		*/ if missing(value_livestock_purchases)

* Calculate the price per live animal sold
gen price_per_animal		= income_live_sales / number_sold

* Merge in geographic data
merge m:1 HHID using "${UGA_W2_created_data}/Uganda_NPS_W2_hhids", /*
	*/ keep(1 3) nogen

drop a6* rural strata

save "${UGA_W2_created_data}/Uganda_NPS_W2_hh_livestock_sales", replace

* Impute Prices *
*****************
gen observation = 1

* Median Price at the enumeration area level
preserve
	bysort region district county subcounty parish ea livestock_code : /*
		*/ egen obs_ea = count(observation)
	* Find the median price and the number of observations
	collapse (median) price_per_animal [aw=weight] , /*
		*/ by (region district county subcounty parish ea obs_ea /*
			*/ livestock_code ) 
	rename price_per_animal price_median_ea

	label variable price_median_ea /*
		*/ "Median price per animal for this livestock in the enumeration area"
	label variable obs_ea /*
		*/ "Number of sales observed for this livestock in the enumeration area"
	save "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_ea.dta", /*
		*/ replace
restore

* Median Price at the parish level
preserve
	bysort region district county subcounty parish livestock_code : /*
		*/ egen obs_parish = count(observation)
	* Find the median price and the number of observations
	collapse (median) price_per_animal [aw=weight] , /*
		*/ by (region district county subcounty parish obs_parish /*
		*/ livestock_code ) 
	rename price_per_animal price_median_parish

	label variable price_median_parish /*
		*/ "Median price per kg for this livestock in the Parish"
	label variable obs_parish /*
		*/ "Number of sales observed for this livestock in the Parish"
	save/*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_parish.dta",/*
	*/ replace
restore

* Median Price at the subcounty level
preserve
	bysort region district county subcounty livestock_code : /*
		*/ egen obs_sub = count(observation)
	* Find the median price and the number of observations
	collapse (median) price_per_animal [aw=weight] , /*
		*/ by (region district county subcounty obs_sub livestock_code) 
	rename price_per_animal price_median_sub

	label variable price_median_sub /*
		*/ "Median price per kg for this livestock in the Subcounty"
	label variable obs_sub /*
		*/ "Number of sales observed for this livestock in the Subcounty"
	save/*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_subcounty.dta",/*
	*/ replace
restore

* Median Price at the county level
preserve
	bysort region district county livestock_code : /*
		*/ egen obs_county = count(observation)
	* Find the median price and the number of observations
	collapse (median) price_per_animal [aw=weight] , /*
		*/ by (region district county obs_county livestock_code) 
	rename price_per_animal price_median_county

	label variable price_median_county /*
		*/ "Median price per kg for this livestock in the County"
	label variable obs_county /*
		*/ "Number of sales observed for this livestock in the County"
	save/*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_county.dta",/*
	*/ replace
restore

* Median Price at the District level
preserve
	bysort region district livestock_code : /*
		*/ egen obs_district = count(observation)
	* Find the median price and the number of observations
	collapse (median) price_per_animal [aw=weight] , /*
		*/ by (region district obs_district livestock_code) 
	rename price_per_animal price_median_district

	label variable price_median_district /*
		*/ "Median price per kg for this livestock in the District"
	label variable obs_district /*
		*/ "Number of sales observed for this livestock in the District"
	save/*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_district.dta",/*
	*/ replace
restore

* Median Price at the Region level
preserve
	*Count number of observations
	bysort region livestock_code : /*
		*/ egen obs_region = count(observation)
	* Find the median price for the region
	collapse (median) price_per_animal [aw=weight] , /*
		*/ by (region obs_region livestock_code) 
	rename price_per_animal price_median_region

	label variable price_median_region /*
		*/ "Median price per kg for this livestock in the Region"
	label variable obs_region /*
		*/ "Number of sales observed for this livestock in the Region"
	save/*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_region.dta",/*
	*/ replace
restore

* Median Price at the Country level
preserve
	bysort livestock_code : /*
		*/ egen obs_country = count(observation)
	* Find the median price and the number of observations
	collapse (median) price_per_animal [aw=weight] , /*
		*/ by ( obs_country livestock_code ) 
	rename price_per_animal price_median_country

	label variable price_median_country /*
		*/ "Median price per kg for this livestock in the Country"
	label variable obs_country /*
		*/ "Number of sales observed for this livestock in the Country"
	save/*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_country.dta",/*
	*/ replace
restore

drop observation
* Merge back in the median prices found above
* Enumeration Area
merge m:1 region district county subcounty parish ea livestock_code /*
	*/ using "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_ea", /*
	*/ nogen
* Parish
merge m:1 region district county subcounty parish livestock_code /*
	*/ using "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_parish", /*
	*/ nogen 
* Subcounty
merge m:1 region district county subcounty livestock_code /*
		*/using "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_subcounty", /*
	*/ nogen
* County
merge m:1 region district county livestock_code using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_county", /*
	*/ nogen
* District
merge m:1 region district livestock_code using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_district", /*
	*/ nogen
* Region
merge m:1 region livestock_code using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_region", /*
	*/ nogen
* Country
merge m:1 livestock_code using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_country", /*
	*/ nogen

* Replace missing prices with imputed prices
replace price_per_animal = price_median_ea			if price_per_animal == . &/*
	*/ obs_ea		>= 10
replace price_per_animal = price_median_parish		if price_per_animal == . &/*
	*/ obs_parish	>= 10
replace price_per_animal = price_median_sub 		if price_per_animal == . &/*
	*/ obs_sub		>= 10
replace price_per_animal = price_median_county 		if price_per_animal == . &/*
	*/ obs_county	>= 10
replace price_per_animal = price_median_district	if price_per_animal == . &/*
	*/ obs_district	>= 10
replace price_per_animal = price_median_region		if price_per_animal == . &/*
	*/ obs_region	>= 10
replace price_per_animal = price_median_country		if price_per_animal == . &/*
	*/ obs_country	>= 10
* Calculate final values
gen value_lvstck_sold		= income_live_sales
replace value_lvstck_sold	= price_per_animal * number_sold 	/*
	*/ if missing(value_lvstck_sold)
// NOTE: No values were given for slaughtered sales. Using price of live animal
// sales to estimate the value of of sluaghtered animals
gen value_slaughtered		= price_per_animal * number_slaughtered
gen value_livestock_sales 	= value_lvstck_sold * value_slaughtered

collapse (sum) value_*, by(HHID)
drop if HHID == ""
label variable value_livestock_sales /*
	*/ "Value of livestock sold (live and slaughtered)"
label variable value_lvstck_sold "Value of livestock sold live"
label variable value_slaughtered /*
	*/ "Value of livestock slaughtered (with slaughtered livestock valued at local median prices for live animal sales)"
label variable value_livestock_purchases "Value of livestock purchases"
save "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_sales", replace

 
  /**********************************/
 /* TLU (Tropical Livestock Units) */
/**********************************/
* Load the data from disk.
use "${UGA_W2_raw_data}/AGSEC6A", clear
append using "${UGA_W2_raw_data}/AGSEC6B"
append using "${UGA_W2_raw_data}/AGSEC6C"

* Rename key variables for consistency across instruments
rename a6aq3 livestock_code
replace livestock_code = a6bq3	if missing(livestock_code)
replace livestock_code = a6cq3	if missing(livestock_code)

* Get rid of observations missing a livestock_code
drop if missing(livestock_code)

* Generate the TLU Coefficient based on the animal type
*Indigenous and Exotic Cattle represented in 1-10
gen tlu_coefficient 	= 0.5 if inrange(livestock_code, 1, 10)

* Donkeys
replace tlu_coefficient = .3 if livestock_code == 11

* No Horse mule disaggregation using the average of the two tlu's
replace tlu_coefficient = .55 if livestock_code == 12

* Indigeneous and exotic goats and sheep, male and female represented in 13-20
replace tlu_coefficient = .10 if inrange(livestock_code, 13, 20)

* Pigs
replace tlu_coefficient = .20 if livestock_code == 21

* Rabbits, backyard chicken, parent stock for broilers, parent stock for layers
* layers, pullet chicks, growers, broilers, turkeys, ducks, and geese and other
* birds represented in 31-41
replace tlu_coefficient = .01 if inrange(livestock_code, 31, 41)


* Combine value labels for livestock_codes from the three files
* From Small Animals (Goat, sheep, pigs)
levelsof a6bq3, local(levs)
foreach v of local levs {
	label define a6aq3 `v' "`: label (a6bq3) `v''", add
}

* From Poultry/Rabbits/etc.
levelsof a6cq3, local(levs)
foreach v of local levs {
	label define a6aq3 `v' "`: label (a6cq3) `v''", add
}

* Combine the number of animals from the three different subsections
* into the same variable name
gen 	number_today 			= a6aq5a
replace number_today 			= a6bq5a		if missing(number_today)
replace number_today			= a6cq5a		if missing(number_today)

* Same for the number of animals one year ago.
gen 	number_1yearago			= a6aq7
replace number_1yearago			= a6bq7			if missing(number_1yearago)
replace number_1yearago			= a6cq7			if missing(number_1yearago)

* And animals died in the last 12 months
gen 	animals_died			= a6aq10a
replace animals_died			= a6bq10a * 2	if missing(animals_died)
replace animals_died			= a6bq10b * 4	if missing(animals_died)

* And animals which have been 'lost' in the last 12 months
gen 	animals_lost			= a6aq10b
replace animals_lost			= a6bq10b * 2	if missing(animals_lost)
replace animals_lost			= a6cq10b * 4	if missing(animals_lost)

* And income from live sales over the last 12 months
gen 	income_live_sales		= a6aq15
replace income_live_sales		= a6bq15 * 2	if missing(income_live_sales)
replace income_live_sales		= a6cq15 * 4	if missing(income_live_sales)

* And the number sold over the last 12 months
gen 	number_sold				= a6aq14
replace number_sold				= a6bq14 * 2	if missing(number_sold)
replace number_sold				= a6cq14 * 4	if missing(number_sold)

* Calculate  the number of animals lost in the last 12 months and the mean 
* number between 1 year ago and today (at time of survey)
gen 	animals_lost12months	= animals_died + animals_lost
egen 	mean_12months			= rowmean(number_today number_1yearago)
* Disaggregate live animals
gen 	number_today_exotic		= number_today	if /*
		*/ inrange(livestock_code, 1, 5) | inrange(livestock_code, 13, 16)
recode	number_today_exotic 	(.=0)



* Calculate the TLUs
gen 	tlu_today				= number_today * tlu_coefficient
gen 	tlu_1yearago			= number_1yearago * tlu_coefficient

preserve
	* Only keep the cows
	keep if livestock_code == 5 | livestock_code == 10
	* Collapse to the household level, requires you to have separated out
	* number_today_exotic 
	bysort HHID : egen herd_cows_tot = sum(number_today)
	
	* Calculate the percentage of cows which are improved
	gen share_imp_herd_cows	= number_today_exotic / herd_cows_tot
	* collapse to household to deal with differences between exotic and 
	* indigenous observations
	collapse (max) share_imp_herd_cows, by (HHID)
	tempfile cows
	save `cows', replace
restore

merge m:1 HHID using `cows', nogen

* Break into our species rather than instrument's livestock code
gen species	= 			1 * (inrange(livestock_code, 1, 10)) 	+ /*
					*/	2 * (inrange(livestock_code, 11, 12))	+ /*
					*/	3 * (livestock_code == 21) 				+ /*
					*/	4 * (inrange(livestock_code, 13, 20))	+ /*
					*/	5 * (inrange(livestock_code, 31, 41))
					
label value species species

preserve
	* Collapse to the species level
	collapse (firstnm) share_imp_herd_cows (sum) number_1yearago	/*
		*/ animals_lost12months number_today_exotic 				/*
		*/ lvstck_holding = number_today, by(HHID species)
	* Recalculate the mean number of animals for the last 12 months at the 
	* collapsed level
	egen mean_12months	= rowmean(lvstck_holding number_1yearago)
	* Are there any improved animals of this species
	gen any_imp_herd	= number_today_exotic != 0	& /*
		*/ ~missing(number_today_exotic) & lvstck_holding != 0 &  /*
		*/ ~missing(lvstck_holding)
	* Create a local for the repeated variables - Leaves out any_imp_herd 
	* because it is not used in all the loops/places that the others are
	local ls_vars lvstck_holding mean_12months animals_lost12months 

	* Disaggregate by species
	foreach i in `ls_vars' any_imp_herd {
		* Use a loop to reshape the data
		forvalues k=1(1)`species_len' {
			local s	: word `k' of `species_list'
			gen `i'_`s' = `i' if species == `k'
		}
	}
	* Collapse again to the household level
	collapse (max) any_imp_herd (firstnm) *_lrum *_srum /*
		*/ *_pigs *_equine *_poultry share_imp_herd_cows, by(HHID)

	* Check if there are any improved large ruminants, small ruminants, or
	* poultry.
	egen any_imp_herd_all 	= rowmax(any_imp_herd_lrum any_imp_herd_srum /*
		*/ any_imp_herd_poultry)
	* Sum the large ruminants, small ruminants and poultry
	egen lvstck_holding_all = rowtotal(lvstck_holding_lrum 	/*
		*/ lvstck_holding_srum lvstck_holding_poultry)

	* Gen blank versions of the name livestock variables for labeling. This
	* way we can create the base labels then modify them for each species 
	* in a loop rather than having to label each of these as at the species
	* level by hand
	foreach i in `ls_vars' {
		gen `i' = .
	}	

	* Create the base labels
	label variable lvstck_holding /*
		*/"Total number of livestock holdings (# of animals)"
	label variable any_imp_herd "At least one improved animal in herd"
	label variable share_imp_herd_cows /*
		*/ "Share of improved animals in total herd - Cows only"
	label variable animals_lost12months /*
		*/ "Total number of livestock lost to disease or injury"
	label variable mean_12months /*
		*/"Average number of livestock today and one year ago"
	label variable lvstck_holding_all /*
		*/ "Total number of livestock holdings (# of animals) - large ruminants small ruminants, poultry"
	label variable any_imp_herd_all /*
		*/ "1=hh has any improved lrum, srum or poultry"

	foreach i in `ls_vars' any_imp_herd {
		* Capture the value of current variables label
		local l : var lab `i'
		* Append species info and apply label to species
		lab var `i'_lrum 	"`l' - large ruminants"
		lab var `i'_srum 	"`l' - small ruminants"
		lab var `i'_pigs 	"`l' - pigs"
		lab var `i'_equine	"`l' - equine"
		lab var `i'_poultry	"`l' - poultry"
	}
	* Relabling any_imp_herd to reflect it is all animals
	label variable any_imp_herd /*
		*/ "At least one improved animal in herd - all animals"
	* Drop the variables created solely for labeling purposes
	drop `ls_vars'

	* Households which report missing numbers for some types of livestock should
	* be counted as having no livestock
	recode lvstck_holding* (.=0)
	save "${UGA_W2_created_data}/Uganda_NPS_W2_herd_characteristics",/*
		*/ replace

restore
* Calculate the per animal price for live animals
gen 	price_per_animal		= income_live_sales / number_sold

* Merge in Imputed prices for missing values
merge m:1 HHID using "${UGA_W2_created_data}/Uganda_NPS_W2_hhids", /*
	*/ keep(1 3) nogen
* Enumeration Area
merge m:1 region district county subcounty parish ea livestock_code /*
*/ using "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_ea", /*
*/ nogen
* Parish
merge m:1 region district county subcounty parish livestock_code /*
*/using "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_parish", /*
*/ nogen 
* Subcounty
merge m:1 region district county subcounty livestock_code /*
*/using "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_subcounty", /*
*/ nogen
* County
merge m:1 region district county livestock_code using /*
*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_county", /*
*/ nogen

* District
merge m:1 region district livestock_code using /*
*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_district", /*
*/ nogen
* Region
merge m:1 region livestock_code using /*
*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_region", /*
*/ nogen
* Country
merge m:1 livestock_code using /*
*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_country", /*
*/ nogen

* Replace missing prices with imputed prices
replace price_per_animal = price_median_ea			if price_per_animal == . &/*
	*/ obs_ea		>= 10
replace price_per_animal = price_median_parish		if price_per_animal == . &/*
	*/ obs_parish	>= 10
replace price_per_animal = price_median_sub 		if price_per_animal == . &/*
	*/ obs_sub		>= 10
replace price_per_animal = price_median_county 		if price_per_animal == . &/*
	*/ obs_county	>= 10
replace price_per_animal = price_median_district	if price_per_animal == . &/*
	*/ obs_district	>= 10
replace price_per_animal = price_median_region		if price_per_animal == . &/*
	*/ obs_region	>= 10
replace price_per_animal = price_median_country		if price_per_animal == . &/*
	*/ obs_country	>= 10 

* Calculate the value of the herd today and 1 year ago
gen value_1yearago	= number_1yearago * price_per_animal
gen value_today		= number_today * price_per_animal

* Collapse TLUs and livestock holdings values to the household level
collapse (sum) tlu_today tlu_1yearago value_*, by(HHID)
drop if HHID == ""

* I really don't know why we do it, but for conformity:
gen lvstck_holding_tlu = tlu_today

* Label constructed variables
label variable tlu_1yearago	"Tropical Livestock Units as of 12 months ago"
label variable tlu_today	"Tropical Livestock Units as of the time of survey"
label variable lvstck_holding_tlu	"Total HH livestock holdings, TLU"
label variable value_1yearago	"Value of livestock holdings from one year ago"
label variable value_today		"Vazlue of livestock holdings today"

* Save data to disk
save "${UGA_W2_created_data}/Uganda_NPS_W2_TLU", replace

  /********************/
 /* Livestock Income */
/********************/
* Load data from disk, and merge in various expense and revenue files
use "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_sales", clear
merge 1:1 HHID using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_hh_livestock_products", /*
	*/ nogen
merge 1:1 HHID using /*
	*/"${UGA_W2_created_data}/Uganda_NPS_W2_livestock_expenses", nogen
merge 1:1 HHID using "${UGA_W2_created_data}/Uganda_NPS_W2_TLU", nogen

* Calculate the value of income from livestock holdings (revenue - expenses)
gen livestock_income = value_lvstck_sold + value_slaughtered - /*
	*/ value_livestock_purchases + (value_milk_produced + value_eggs_produced /*
	*/ + value_other_produced) - (cost_hired_labor_livestock + /*
	*/ cost_fodder_livestock + cost_vaccines_livestock + cost_water_livestock /*
	*/ + cost_other_livestock)
* Label the new variable
label variable livestock_income "Net livestock income"

save "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_income", replace

********************************************************************************
*                                 FISH  INCOME                                 *
********************************************************************************
* Fishing section of survey was removed in wave 2 None of this can be
* constructed

********************************************************************************
*                            SELF-EMPLOYMENT INCOME                            *
********************************************************************************
use "${UGA_W2_raw_data}/GSEC12", clear

* Rename key variables to make them easier to work with
rename	h12q12 months_activ
rename	h12q13 monthly_income
rename	h12q15 monthly_wages
rename	h12q16 monthly_materials
rename	h12q17 monthly_other_expenses
* Fix invalid values. (Number of months greater than 12)
recode months_activ (12/max = 12)

* Calculate the profit
gen		annual_selfemp_profit = months_activ * (monthly_income - monthly_wages/*
		*/ - monthly_materials - monthly_other_expenses)
recode	annual_selfemp_profit (.=0)
// 90 Enterprises are reported as unprofitable

* Collapse to the household level
collapse (sum) annual_selfemp_p
* Recode responses whrofit, by(HHID)
// 78 households are reported to be engaged in unprofitable enterprise
* Label constructed variables
label variable annual_selfemp_profit /*
	*/"Estimated annual net profit from self-employment over previous 12 months"

* Save to disk
save "${UGA_W2_created_data}/Uganda_NPS_W2_self_employment_income", /*
	*/ replace

  /*******************/
 /* Processed Crops */
/*******************/
* Not applicable for this Instrument

  /****************/
 /* Fish Trading */
/****************/
* Not applicable for this instrument

********************************************************************************
*                                    INCOME                                    *
********************************************************************************
  /**********************/
 /* Non-Ag Wage Income */
/**********************/

* Load data from disk (Household section 8)
use "${UGA_W2_raw_data}/GSEC8", clear

* Set variable names to cross-wave standard
rename	h8q30	num_months
rename	h8q30b	num_weeks
rename 	h8q31c	pay_period

* Combine cash and non-cash payments into one variable
gen		most_recent_payment	= h8q31a + h8q31b

egen	num_hours			= rowtotal(h8q36*)
* Note this is necessary to improve the accuracy of the rowmean function
recode	h8q36*			(0=.)
egen	avg_hrs_per_day		= rowmean(h8q36*)
recode	h8q36*			(.=0)

gen		hrs_worked_annual	= num_hours * num_weeks * num_months

* Calculate the hourly wage by dividing most recent payment by the number of 
* hours - which varies based on the payment period
gen 	hourly_wage			= most_recent_payment / ( 1 * (pay_period == 1) + /*
	*/	avg_hrs_per_day * (pay_period == 2) + num_hours * (pay_period == 3) + /*
	*/ 	num_hours * num_weeks * (pay_period == 4))

* if we decided to include wages from secondary jobs uncomment this section
* rename	h8q44	sec_months
* rename	h8q44_1	sec_weeks
* rename 	h8q45c	sec_period
* rename	h8q43	sec_hours

* gen		sec_payment			= h8q45a + h8q45b

* gen		hrs_worked_sec		= sec_hours * sec_weeks * sec_months
* gen 	hourly_wage_sec		= sec_payment / ( 1 * (sec_period == 1) + /*
* 	*/	8 * (sec_period == 2) + sec_hours * (pay_period == 3) + /*
* 	*/	sec_hours * sec_weeks * (sec_period == 4))

* Everything up to this point is the same regardless of ag or non-ag wage so 
* preserve here, do the non-ag wage calculation then restore and do the ag wage
* calculation
preserve
	* Calculate the annual salary if it was earned in a non-ag job
	gen annual_salary 			= hourly_wage * hrs_worked_annual if /*
		*/	~inlist(h8q19a, 611, 612, 613, 614, 621, 921)

	* Collapse to the household level
	collapse (sum) annual_salary, by(HHID)

	* Label the created variable
	lab var annual_salary "Annual earnings from non-agricultural wage"

	* Save data to disk.
	save "${UGA_W2_created_data}/Uganda_NPS_W2_wage_income", replace
restore

  /******************/
 /* Ag Wage Income */
/******************/
* Calculate the annual salary if it was earned in a non-ag job
gen annual_salary 			= hourly_wage * hrs_worked_annual if /*
	*/	~inlist(h8q19a, 611, 612, 613, 614, 621, 921)

* Collapse to the household level
collapse (sum) annual_salary, by(HHID)

* Label the created variable
lab var annual_salary "Annual earnings from agricultural wage"

* Save data to disk.
save "${UGA_W2_created_data}/Uganda_NPS_W2_agwage_income", replace

  /****************/
 /* Other Income */
/****************/
* Load data from disk
use "${UGA_W2_raw_data}/GSEC11", clear

* Rename key variables for easier use
rename	h11q2	income_code
rename	h11q5	cash_pay
rename	h11q6	inkind_pay

* Disaggregate by income type and add together inkind and cash payments
gen		rental_income		= cash_pay + inkind_pay	if /*
	*/	inrange(income_code, 21, 23)

* For pension income inkind pay is not supposed to be recorded
gen		pension_income		= cash_pay				if /*
	*/	income_code ==  41

gen		remittance_income	= cash_pay + inkind_pay	if /*
	*/	inlist(income_code, 42, 43) 

gen 	other_income		= cash_pay + inkind_pay if /*
	*/	inlist(income_code, 44, 45) | inrange(income_code, 23, 36)

* Set missing values to 0 (assuming the respondent did not have any income from
* that source)
recode *_income (.=0)

* Collapse disaggregated income to the household level
collapse (sum) *_income, by(HHID)

* Label the disaggregated income variables
label variable rental_income /*
	*/	"Estimated income from rentals of buildings, tools, land, transport animals over previous 12 months"
label variable pension_income /*
	*/	"Estimated income from a pension over previous 12 months" 
label variable remittance_income /*
	*/	"Estimated income from remittances over previous 12 months"
label variable other_income /*
	*/	"Estimated income from any OTHER source over previous 12 months"

* Save to disk
save "${UGA_W2_created_data}/Uganda_NPS_W2_other_income", replace

* Land Rental Income *
**********************
* Load land rental data
use "${UGA_W2_raw_data}/AGSEC2A", clear

* Rename key variable to cross instrument standard
rename a2aq16 land_rental_income
* Set missing values to 0 (assuming the respondent did not have any income from
* that source)
recode land_rental_income (.=0)

* Collapse to the household level
collapse (sum) land_rental_income, by(HHID)

* Label newly created variable
label variable land_rental_income /*
	*/ "Estimated income from renting out land over previous 12 months"

* Save to disk
save "${UGA_W2_created_data}/Uganda_NPS_W2_land_rental_income", replace

********************************************************************************
*                             FARM SIZE / LAND SIZE                            *
********************************************************************************
  /***************/
 /* Crops Grown */
/***************/
* Load data from disk First season
use "${UGA_W2_raw_data}/AGSEC4A", clear
* Append data from second season
append using "${UGA_W2_raw_data}/AGSEC4B"

* Drop incomplete entries
drop if missing(cropID, prcid, pltid)

* Rename key variables for cross file compatibility
rename pltid plot_id
rename prcid parcel_id
rename cropID crop_code

* Create a crop grown variable for any remaining observations
gen crop_grown = 1

* Collapse to the parcel level
collapse (max) crop_grown, by(HHID parcel_id)

* Save to disk
save "${UGA_W2_created_data}/Uganda_NPS_W2_crops_grown", replace

  /*******************/
 /* Plot Cultivated */
/*******************/
* Load data from disk
use "${UGA_W2_raw_data}/AGSEC2A", clear
append using "${UGA_W2_raw_data}/AGSEC2B"
* Rename key variables for cross file compatibility
rename prcid parcel_id

* Create a boolean, was the parcel cultivated
gen	cultivated	= inlist(a2aq13a, 1, 2) | inlist(a2aq13b, 1, 2) | /*
	*/	inlist(a2bq15a, 1, 2) | inlist(a2bq15b, 1, 2)

* Collapse to the parcel level
collapse (max) cultivated, by(HHID parcel_id)

* Label newly created variable
label variable cultivated "1= Parcel was cultivated in this data set"
* Save data to disk
save "${UGA_W2_created_data}/Uganda_NPS_W2_parcels_cultivated", replace

  /*************/
 /* Farm Area */
/*************/
* Load data from disk
use "${UGA_W2_created_data}/Uganda_NPS_W2_parcels_cultivated", replace

* Merge in parcel areas
merge 1:1 HHID parcel_id using /*
	*/	"${UGA_W2_created_data}/Uganda_NPS_W2_plot_areas", keep(1 3) /*
	*/	nogen
keep if cultivated

* Clean nonsensical answers (doesn't appear to be a problem in this instrument)
replace area_meas_hectares	= . if area_meas_hectares < 0
replace area_meas_hectares	= area_est_hectares if missing(area_meas_hectares)



* collapse to the household level and rename
collapse (sum) farm_area = area_meas_hectares, by(HHID)

* Label the newly created farm_area variable
label variable farm_area /*
	*/	"Land size (denominator for land productivity) in hectares"
* Save to disk
save "${UGA_W2_created_data}/Uganda_NPS_W2_land_size", replace


  /*************************/
 /* All Agricultural Land */
/*************************/
* Load data from disk
use "${UGA_W2_raw_data}/AGSEC2A", clear
append using "${UGA_W2_raw_data}/AGSEC2B"

* Rename key variables for cross file compatibility
rename	prcid parcel_id

* Drop incomplete entries
drop if	missing(parcel_id, HHID)

* Merge in crop growing data created earlier
merge m:1 HHID parcel_id using /*
	*/	"${UGA_W2_created_data}/Uganda_NPS_W2_crops_grown", nogen

* Check if the plot was rented out in either season
gen		rented_out = inlist(a2aq13a, 3, 4) | inlist(a2aq13b, 3, 4)

* Drop any plot which was rented out and did not have crops grown on it
drop if	rented_out == 1	& crop_grown != 1

* Check the use of the land is agricultural and drop it if it is not
gen		agland = inlist(a2aq13a, 1, 2, 5, 6) | inlist(a2aq13b, 1, 2, 5, 6)
drop if	agland != 1 & missing(crop_grown)

* Collapse to the parcel level
collapse (max) agland, by(HHID parcel_id)

* Label the newly created variable
label variable agland /*
	*/ "1= Parcel was used for crop cultivatioon or left fallow in this past year (forestland and other uses excluded)"

* Save to disk
save "${UGA_W2_created_data}/Uganda_NPS_W2_parcels_agland", replace

* Load back from disk *facepalm*
use "${UGA_W2_created_data}/Uganda_NPS_W2_parcels_agland", clear

* Merge in plot areas
merge 1:1 HHID parcel_id using /*
	*/	"${UGA_W2_created_data}/Uganda_NPS_W2_plot_areas", keep(1 3)

* Make area_meas_hectares the best possible estimate of the land size
replace	area_meas_hectares	= . if area_meas_hectares < 0
replace	area_meas_hectares	= area_est_hectares if /*
	*/	missing(area_meas_hectares)	| (area_meas_hectares == 0 & /*
	*/	area_est_hectares > 0 		& ~missing(area_est_hectares))

* Collapse to the household level to get total agland farm size
collapse (sum) farm_size_agland = area_meas_hectares, by(HHID)

label variable farm_size_agland /*
	*/ "Land size in hectares, including all plots cultivated or left fallow" 
save "${UGA_W2_created_data}/Uganda_NPS_W2_farmsize_all_agland", /*
	*/	replace

  /*************/
 /* Land Size */
/*************/
* Load data from disk
use "${UGA_W2_raw_data}/AGSEC2A", clear
append using "${UGA_W2_raw_data}/AGSEC2B"

* Rename key variables for cross file compatibility
rename	prcid parcel_id

* Drop incomplete entries
drop if	missing(parcel_id, HHID)

* Check if the plot was rented out in both seasons
gen		rented_out = inlist(a2aq13a, 3, 4) & inlist(a2aq13b, 3, 4)
* If it was rented out get rid of it
drop if	rented_out
* Create a new variable to mark the plot as one which was not rented out
gen 	plot_held = 1

* Collapse to the parcel level
collapse (max) plot_held, by(HHID parcel_id)

* Label the newly created variable
label variable plot_held "1= Parcel was NOT rented out in both seasons"

* Save to disk
save "${UGA_W2_created_data}/Uganda_NPS_W2_parcels_held", replace

* And load it from disk (again) *facepalm*
use "${UGA_W2_created_data}/Uganda_NPS_W2_parcels_held", clear
merge 1:1 HHID parcel_id using /*
	*/	"${UGA_W2_created_data}/Uganda_NPS_W2_plot_areas", keep(1 3)

* Make area_meas_hectares the best possible estimate of the land size
replace	area_meas_hectares	= . if area_meas_hectares < 0
replace	area_meas_hectares	= area_est_hectares if /*
	*/	missing(area_meas_hectares)	| (area_meas_hectares == 0 & /*
	*/	area_est_hectares > 0 		& ~missing(area_est_hectares))

* Collapse to the household level to get total farm size
collapse (sum) land_size = area_meas_hectares, by(HHID)
* Label the newly created variable
label variable land_size /*
	*/ "Land size in hectares, including all plots listed by the household except those rented out"
save "${UGA_W2_created_data}/Uganda_NPS_W2_land_size_all", replace

  /***********************/
 /* Total Land Holdings */
/***********************/
use "${UGA_W2_raw_data}/AGSEC2A", clear
append using "${UGA_W2_raw_data}/AGSEC2B"

* Rename key variables for cross file compatibility
rename	prcid parcel_id

* Drop incomplete entries
drop if	missing(parcel_id, HHID)
merge 1:1 HHID parcel_id using /*
	*/	"${UGA_W2_created_data}/Uganda_NPS_W2_plot_areas", keep(1 3)

* Make area_meas_hectares the best possible estimate of the land size
replace	area_meas_hectares	= . if area_meas_hectares < 0
replace	area_meas_hectares	= area_est_hectares if /*
	*/	missing(area_meas_hectares)	| (area_meas_hectares == 0 & /*
	*/	area_est_hectares > 0 		& ~missing(area_est_hectares))
* Deal with duplicated parcel data by collapsing -max- to the parcel level 
collapse (max) area_meas_hectares, by(HHID parcel_id)

* Collapse -sum- to the household level to get total farm size
collapse (sum) land_size_total = area_meas_hectares, by(HHID)

* Label the newly created variable
label variable land_size_total /*
	*/ "Total land size in hectares, including rented in and rented out plots" 

save "${UGA_W2_created_data}/Uganda_NPS_W2_land_size_total", replace

********************************************************************************
*                                OFF-FARM HOURS                                *
********************************************************************************

* Load data from disk (Household section 8)
use "${UGA_W2_raw_data}/GSEC8", clear

* Add up hours spent for each hh member for non-agricultural work.
* h8q36* adds up all parts of h8q36 (e.g. h8q36a + h8q36b + ...)
* h8q19b divides jobs into broad categories, 6 is ag and fisheries
* h8q19a provides a more specific job, 921 is "Agricultural, Fishery and 
* Related laborers"
egen primary_hours	= rowtotal(h8q36*)	if h8q19b != 6	&	h8q19a !=921

* Same as above for secondary hours except hours are reported as a weekly total
gen secondary_hours	= h8q43				if h8q38b != 6	&	h8q38a != 921

* Add up primary and secondary hours
* NOTE use egen rowtotal as a simple + equals missing if either primary or 
* secondary hours is missing
egen off_farm_hours = rowtotal(primary_hours secondary_hours)

* Create variable equal to 1 if the hh member worked more than 0 hours off farm 
gen off_farm_any_count	= off_farm_hours > 0 & ~missing(off_farm_hours)
gen member_count 		= 1

* Collapse to the household level
collapse (sum) off_farm_hours off_farm_any_count member_count, by(HHID)
label variable member_count		"Number of HH members age 5 or above"
label variable off_farm_hours	"Total household off-farm hours"
label variable off_farm_any_count	/*
	*/	"Number of HH members with positive off-farm hours"

* Save the data
save "${UGA_W2_created_data}/Uganda_NPS_W2_off_farm_hours.dta", replace

********************************************************************************
*                                  FARM LABOR                                  *
********************************************************************************

* NOTE: Uganda does not have a main season and a short season. For cross 
* country compatibility this section codes the first visit as "the long season"
* and the second visit as "the short season" as Uganda provides little data
* beyond those two categories

  /***************/
 /* Main Season */
/***************/
* Load AgSec3a (Agricultural Inputs and Labor First Visit) from disk
use "${UGA_W2_raw_data}/AGSEC3A", clear

* Standardize the names of key variables
rename prcid parcel_id

* Uganda provides family days of labor worked as single aggregate number
rename a3aq39 days_famlabor_mainseason 

* Uganda only differentiates hired labor by man, woman and child. Combining them
* all at once rather than renaming then recoding
egen days_hired_mainseason = rowtotal(a3aq42*)

* Recode missings for the newly created variables to 0
recode days_*_mainseason (.=0)

* Collapse everything to the plot (parcel) level
collapse (sum) days_*_mainseason, by(HHID parcel_id)

* Label the newly created variables
label variable days_hired_mainseason /*
	*/	"Workdays for hired labor (crops) in main growing season"
label variable days_famlabor_mainseason /*
	*/	"Workdays for family labor (crops) in main growing season"

* Save to disk
save "${UGA_W2_created_data}/Uganda_NPS_W2_farmlabor_mainseason", /*
	*/	replace


  /****************/
 /* Short Season */
/****************/
* Load AgSec3B (Agricultural Inputs and Labor Second Visit) from disk
use "${UGA_W2_raw_data}/AGSEC3B", clear

* Standardize the names of key variables
rename prcid parcel_id

* Uganda provides family days of labor worked as single aggregate number
rename a3bq39 days_famlabor_shortseason 

* Uganda only differentiates hired labor by man, woman and child. Combining them
* all at once rather than renaming then recoding
egen days_hired_shortseason = rowtotal(a3bq42*)

* Recode missings for the newly created variables to 0
recode days_*_shortseason (.=0)

* Collapse the two created variables to the parcel level to stay consistent with
* other data
collapse (sum) days_*_shortseason, by(HHID parcel_id)

* Label the newly created variables
label variable days_hired_shortseason /*
	*/	"Workdays for hired labor (crops) in short growing season"
label variable days_famlabor_shortseason /*
	*/	"Workdays for family labor (crops) in short growing season"

* Save to disk
save "${UGA_W2_created_data}/Uganda_NPS_W2_farmlabor_shortseason", /*
	*/	replace


  /***************/
 /* All Seasons */
/***************/

* Load/Merge the two newly created files
use "${UGA_W2_created_data}/Uganda_NPS_W2_farmlabor_mainseason", clear

merge 1:1 HHID parcel_id using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_farmlabor_shortseason", /*
	*/ nogen

* Sum days labor by type across seasons
egen labor_hired	= rowtotal(days_hired_*)
egen labor_family	= rowtotal(days_famlabor_*)

* Calculate total amount of labor used at the parcel level
egen labor_total	= rowtotal(labor_*)

* Label the newly created variables
label variable labor_hired	"Total labor days (hired) allocated to the farm"
label variable labor_family	"Total labor days (family) allocated to the farm"
label variable labor_total	/*
	*/	"Total labor days (family, hired, other) allocated to the farm"

* Save the Parcel level data to the disk
save "${UGA_W2_created_data}/Uganda_NPS_W2_plot_family_hired_labor", /*
	*/	replace

* Collapse labor variables to the household level
collapse  (sum) labor_*, by(HHID)

* Relabel the variables to get rid of the junk added by collapse
label variable labor_hired	"Total labor days (hired) allocated to the farm"
label variable labor_family	"Total labor days (family) allocated to the farm"
label variable labor_total 	/*
	*/	"Total labor days (family, hired, or other) allocated to the farm"

* Save household level data to the disk
save "${UGA_W2_created_data}/Uganda_NPS_W2_family_hired_labor", replace

********************************************************************************
*                                VACCINE  USAGE                                *
********************************************************************************
/*	 __NOTE__ SAK 20190107: Only Large Ruminants and Equines have data on 
 *	vaccines. The Sheep, goats, pigs module and the poultry/rabbit module
 *	do not include data on vaccine usage.
 */

* 	Load Agricultural Section 6A - Livestock Ownership: Cattle and Pack Animals
* 	dta from Disk
use "${UGA_W2_raw_data}/AGSEC6A", clear

* Standardize key variables across waves
rename	a6aq3 livestock_code
/*	__NOTE__ SAK 20200107: a6aq18 response of 1 means all animals are 
 *	vaccinated, response of 2 is some animals vaccinated
 */
gen		vac_animal	= inlist(a6aq18, 1, 2)

gen		species = 	inrange(livestock_code, 1, 10) + /*
				*/	4*(inlist(livestock_code, 11, 12))	
* Don't use data if no species is specified
recode species (0=.)

* Set the value labels based on the species value labels created earlier
/* 	__NOTE__ SAK 20190107 label the value of species is pointless as it is 
 *	dropped by the collapse
 */
label values species species
disp "`species_len'"
* Use a loop to reshape the data
forvalues k=1(1)`species_len' {
	local s	: word `k' of `species_list'
	gen vac_animal_`s' = vac_animal if species == `k'
}
* Finish the reshape by collapsing species to the household level
collapse (max) vac_animal*, by(HHID)

* Label the new variables
lab var vac_animal "1= Household has an animal vaccinated"
* Label the animal category specific dummy variables
foreach i in vac_animal {
	local l`i' : var lab `i'
	lab var `i'_lrum "`l`i'' - large ruminants"
	lab var `i'_srum "`l`i'' - small ruminants"
	lab var `i'_pigs "`l`i'' - pigs"
	lab var `i'_equine "`l`i'' - equine"
	lab var `i'_poultry "`l`i'' - poultry"
}

* Save the Vaccine dummies to disk
save "${UGA_W2_created_data}/Uganda_NPS_W2_vaccine", replace

* Load AgSec 6A, B, and C: Livestock Ownership. (contains vaccine data)
use "${UGA_W2_raw_data}/AGSEC6A", replace
append using "${UGA_W2_raw_data}/AGSEC6B"
append using "${UGA_W2_raw_data}/AGSEC6C"

* Create a dummy variable of "livestock keeper uses vaccines" across all animals
gen all_vac_animal = inlist(a6aq18, 1, 2)
* Set to missing if they don't own any of the animal in question
replace all_vac_animal = . if missing(a6aq18) | a6aq4 != 1


* Rename farmer id
rename a6aq17a personid1
rename a6aq17b personid2

replace personid1 = a6bq17a if missing(personid1)
replace personid2 = a6bq17b if missing(personid2)

replace personid1 = a6cq17a if missing(personid1)
replace personid2 = a6cq17b if missing(personid2)

rename a6aq3 lvstckid  

replace lvstckid = a6bq3 if missing(lvstckid)
replace lvstckid = a6cq3 if missing(lvstckid)


* Only keep the relevant variables a6aq3 is needed for the reshape
keep HHID lvstckid all_vac_animal personid*

* Drop entries with no livestock keeper listed
drop if missing(personid1) & missing(personid2)

* DO NOT DUPLICATE
* There are duplicate entries in agsec6b and agsec6c, since this data is only
* used for livestock keeper information, this sorting then dropping duplicates
* method insures that entries with missing second farmers are below ones with
* both farmers meaning all data is preserved. There are no instances in this 
* data where one farmer is in the entry with one farmer and not also in the 
* other entry (whether it has one or two farmers).
sort HHID lvstckid personid1 personid2
duplicates drop HHID lvstckid, force
* END DO NOT DUPLICATE

* Reshaping data to create a file at the livestock-keeper unit of analysis 
* rather than the livestock species unit of analysis. 
reshape long personid, i(HHID lvstckid) j(_)

* Get rid of any entries which are missing a personid
drop if missing(personid)

* Condense down to one entry per livestock keeper. 
collapse (max) all_vac_animal, by(HHID personid)


* Mark all of the remaining people as livestock-keepers with a dummy variable
gen livestock_keeper = 1

* Merge in gender data for later gender disaggregation of proportions
merge 1:1 HHID personid using "${UGA_W2_created_data}/Uganda_NPS_W2_gender_merge", nogen

* Any people which were not part of the data before the merge should be set as
* not being livestock keepers
recode livestock_keeper (.=0)

* Label newly created variables
label variable all_vac_animal /*
	*/	"1= Individual farmer (livestock keeper) uses vaccines"
label variable livestock_keeper /*
	*/	"1= Individual is listed as a livestock keeper (at least one type of livestock)"
save "${UGA_W2_created_data}/Uganda_NPS_W2_farmer_vaccine", replace
********************************************************************************
*                           ANIMAL HEALTH - DISEASES                           *
********************************************************************************

  /***************************************************************************/
 /* Cannot Construct in this Instrument. No questions about animal diseases */
/***************************************************************************/


********************************************************************************
*                    LIVESTOCK WATER, FEEDING, AND HOUSING                     *
********************************************************************************

  /*********************************************************************/
 /* Cannot Construct in this Instrument. No questions on these topics */
/*********************************************************************/

********************************************************************************
*                         USE OF  INORGANIC FERTILIZER                         *
********************************************************************************
* Load data on Agricultural and Labor Inputs (first and second visit)
use "${UGA_W2_raw_data}/AGSEC3A", clear
append using "${UGA_W2_raw_data}/AGSEC3B" 

* Make 1 = to yes and 0= no on inorganic fertilizer use questions and assume 
* missing answers are no inorganic fertilizer
recode a3aq14 a3bq14 (2=0) (.=0)

* Combine the inorganic fertilizer question from both seasons into 1 variable
egen use_inorg_fert = rowmax(a3aq14 a3bq14)

* Perserve before collapsing to the household level (prevents duplicating work)
preserve
	collapse (max) use_inorg_fert, by(HHID)
	label variable use_inorg_fert "1 = Household uses inorganic fertilizer"
	save "${UGA_W2_created_data}/Uganda_NPS_W2_fert_use", replace
restore

* Parcel manager level *
************************
* Rename to the individual level variable name
rename use_inorg_fert all_use_inorg_fert

* Plot managers are only at the parcel level
collapse (max) all_use_inorg_fert, by(HHID prcid)

* Merge in plot manager details from land holdings data
merge 1:1 HHID prcid using "${UGA_W2_raw_data}/AGSEC2A", nogen keep(1 3)
merge 1:1 HHID prcid using "${UGA_W2_raw_data}/AGSEC2B", nogen keep(1 3)

* Set the values for the two plot managers
egen personid1 = rowfirst(a2aq27a a2bq25a)
egen personid2 = rowfirst(a2aq27b a2bq25b)

* reshape data so each row has a single personid
reshape long personid, i(HHID prcid)

* drop the missing people created by the reshape
drop if missing(personid)

* Collapse to the individual level
collapse (max) all_use_inorg_fert, by(HHID personid)

* Mark existing individuals as farm manager
gen farm_manager	= 1
* create a farmer id for consistency
gen farmerid		= personid

* Merge in data on farmer's gender from created gender merge file
merge 1:1 HHID personid using /*
	*/	"${UGA_W2_created_data}/Uganda_NPS_W2_gender_merge", nogen
* Set in new entries (i.e. those with no entry before the merge) as non farm 
* managers
recode farm_manager (.=0)

* Label the newly created variables
label variable farm_manager /*
	*/	"1= Individual is listed as a manager for at least one plot"
label variable all_use_inorg_fert /*
	*/	"1= Individual farmer (plot manager) uses inorganic fertilizer"
save "${UGA_W2_created_data}/Uganda_NPS_W2_farmer_fert_use", /*
	*/	replace

********************************************************************************
*                             USE OF IMPROVED SEED                             *
********************************************************************************
  /*******************/
 /* Household Level */
/*******************/

* Load "Crops Grown and Types of Seed Used" first and second visit data
use "${UGA_W2_raw_data}/AGSEC4A", clear
append using "${UGA_W2_raw_data}/AGSEC4B", gen(season)

* recode and combine improved seed variables
recode	a4aq13 a4bq13 		(1=0) (2=1) (.=0)
egen 	imprv_seed_use	= 	rowmax(a4aq13 a4bq13)

* Loop through the list of Gates Priority Crops and create dummy variables for
* whether or not the plot was planted with improved seed of each crop
forvalues k=1(1)`crop_len' {
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area

	* Create the improved seed by crop dummy
	gen imprv_seed_`cn'		=	imprv_seed_use 	if cropID	==	`c'
	* there is no hybrid seed question so set it to missing.
	gen hybrid_seed_`cn'	=	.
}

* by preserving before the collapse you don't need to create new dummy variables
* for each crop later, we will have them at the plot-crop level when we evaluate
* the data at the individual level. 
preserve
	* Collapse to the household level
	collapse (max) imprv_seed_* hybrid_seed_*, by(HHID)

	* Label the newly created variables
	label variable imprv_seed_use "1= Household uses improved seed"

	* Loop through all of the top crops and label the crop specific version of 
	* the dummy.
	foreach cn in $topcropname_area {
		label variable imprv_seed_`cn' 	"1= Household uses improved `cn' seed"
		label variable hybrid_seed_`cn'	"1= Household uses hybrid `cn' seed"
	}

	save "${UGA_W2_created_data}/Uganda_NPS_W2_improvedseed_use", replace
restore
  /********************/
 /* Individual level */
/********************/
* Merge in data on the parcel managers AGSEC2A - Owned Parcels; AGSEC2B - 
* Rented Parcels
merge m:1 HHID prcid using "${UGA_W2_raw_data}/AGSEC2A", keep(1 3) nogen
merge m:1 HHID prcid using "${UGA_W2_raw_data}/AGSEC2B", keep(1 3) nogen

* Combine the plot manager variables from the owned dta (AGSEC2A) with the 
* and the rented dta (AGSEC2B)
egen personid1	=	rowfirst(a2aq27a a2bq25a)
egen personid2	= 	rowfirst(a2aq27b a2bq25b)

* reshape date from crop plot level to farmer crop plot level
gen index = _n
reshape long personid, i(index) j(_)

* Drop all the entries created with a missing person id (i.e. the second entry
* for parcels with only one parcel manager)
drop if missing(personid)

* Rename all of the variables to the individual level version (add all_ to the
* front of the variable name)
foreach v in imprv_seed_* hybrid_seed_* {
	rename `v' all_`v'
}

* Collapse to the farmer level
collapse (max) all_imprv_seed_* all_hybrid_seed_*, by(HHID personid)

* Any person who hasn't been removed at this point is a farm manager and should
* be marked before merging in the gender data.
gen farm_manager	= 	1

*Label relevant variables
label variable all_imprv_seed_use /*
	*/	"1= Individual farmer (plot manager) uses improved seed"
label variable farm_manager /*
	*/	"1= Individual is listed as a manager for at least one plot"

* label crop specific versions of the all_imprv_seed and all_hybrid_seed.
* Also create and label the farmer dummy for all farmers of 
foreach cn in $topcropname_area {
	* If the value of all_imprv_seed and all_hybrid_seed is missing then the
	* farm manager did not grow this particular crop
	gen `cn'_farmer 	= 	~missing(all_imprv_seed_`cn') 	| /*
		*/	~missing(all_hybrid_seed_`cn')

	label variable all_imprv_seed_`cn' /*
		*/	"1= Individual Farmer (plot manager) uses improved seeds - `cn'"
	label variable all_hybrid_seed_`cn' /*
		*/	"1= Individual Farmer (plot manager) uses hybrid seed - `cn'"
	label variable `cn'_farmer "1= Individual farmer (plot manager) grows `cn'"
}

* Merge in the gender data
merge 1:1 HHID personid using /*
	*/	"${UGA_W2_created_data}/Uganda_NPS_W2_gender_merge", nogen
* Set the value of Farm manager to 0 for people who did not show up prior to the
* merge of gender data and therefore have farm_manager == .
recode farm_manager (.=0)

save "${UGA_W2_created_data}/Uganda_NPS_W2_farmer_improved_seed_use", replace
//Continue
********************************************************************************
*                           REACHED BY AG EXTENSION                            *
********************************************************************************

*use "${UGA_W2_raw_data}/AGSEC9", clear

* Rename certain variables for ease of use
*rename a9q2 source
*rename a9q3 advice_

* Replace source data with cross wave/country standards. No standard for input
* supplier so I'm just making one up
*replace source	= 	"gov"		if source == "NAADS"
*replace source 	=	"input"		if source == "INPUT SUPPLIER"
*replace source	= 	"ngo"		if source == "NGO"
*replace source	= 	"coop"		if source == "COOPERATIVE"
*replace source	= 	"farmer"	if source == "LARGE SCALE FARMER"
*replace source	=	"other"		if source == "OTHERS"

* reshape to get one entry per household
*reshape wide advice_, i(HHID) j(source) string
* Uganda data does not have entries for sources from which the farm did not 
* receive advice. The reshape creates these as blank entries recode to 0 to 
* represent that the farm did not receive advice from that source
*recode advice_* (.=0)

* Create the actual variables we care about
*gen ext_reach_public		=	advice_gov == 1
*egen ext_reach_private		=	rowmax(advice_ngo advice_coop)
*egen ext_reach_unspecified	=	rowmax(advice_other advice_input)
* No data is collected on ICT sources of extenstion
*gen ext_reach_ict			=	.
*egen ext_reach_all			=	rowmax(ext_reach_*)

* Get rid of the advice variables, they are not reported in the final data
*keep HHID ext_reach_*

* Set labels for the newly created variables
*label variable ext_reach_all /*
*	*/	"1= Household reached by extension services - all sources"
*label variable ext_reach_public /*
*	*/	"1= Household reached by extension services - public sources"
*label variable ext_reach_private /*
*	*/	"1= Household reached by extension services - private sources"
*label variable ext_reach_unspecified /*
*	*/	"1= Household reached by extension services - unspecified sources"
*label variable ext_reach_ict /*
*	*/	"1= Household reached by extension services through ICT"

*save "${UGA_W2_created_data}/Uganda_NPS_W2_any_ext", replace


//*AKS takes over from here in order to complete 380 project for Uganda Group Membership work */

********************************************************************************
*								HOUSEHOLD ASSETS							   *
********************************************************************************
*use "${UGA_W2_raw_data}/GSEC14A.dta", clear
*ren h14q5 value_today
*ren h14q4 num_items
*collapse (sum) value_assets=value_today, by(HHID)
*la var value_assets "Value of household assets"
*save "${UGA_W2_created_data}/Uganda_W2_hh_assets.dta", replace 

********************************************************************************
*                      USE OF FORMAL  FINANCIAL SERVICES                       *
********************************************************************************
use "${UGA_W2_raw_data}/AGSEC2.dta", clear
gen informed_training_NAADS=(a9q11==1)
gen part_training_NAADS=(a9q12==1) if informed_training_NAADS==1
gen informed_farmersgroup_NAADS=(a9q13==1)
gen part_farmersgroup_NAADS=(a9q14==1) if informed_farmersgroup_NAADS==1
collapse (max) informed_* part* , by (HHID)
lab var informed_training_NAADS "1 = member of HH is informed on NAADS trainings"
lab var part_training_NAADS "1 = member of HH partcipated in NAADS trainings"
lab var informed_farmersgroup_NAADS "1 = member of HH is informed on NAADS farmer's groups"
lab var part_farmersgroup_NAADS "1 = member of HH is a member  NAADS farmer's groups" 
save "${UGA_W2_created_data}/Uganda_NPS_W2_hh_groupmembership.dta", replace
