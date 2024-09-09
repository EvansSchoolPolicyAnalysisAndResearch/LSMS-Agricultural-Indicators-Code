
/*-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of a set of agricultural development indicators 
				  using the Nigeria General Household Survey (GHS) LSMS-ISA Wave 3 (2015-16)
*Author(s)		: Didier Alia, Andrew Tomes, C. Leigh Anderson

*Acknowledgments: We acknowledge the helpful contributions of members of Pierre Biscaye, David Coomes, Jack Knauer, Josh Merfeld,  
				  Isabella Sun, Chelsea Sweeney, Emma Weaver, Ayala Wineman, Travis Reynolds, the World Bank's LSMS-ISA team, the FAO's RuLIS team, IFPRI, IRRI, 
				  and the Bill & Melinda Gates Foundation Agricultural Development Data and Policy team in discussing indicator construction decisions. 
				  
				  All coding errors remain ours alone.

*Date			: 18th July 2024
*Dataset Version	: NGA_2012_GHSP-W2_v02_M
----------------------------------------------------------------------------------------------------------------------------------------------------*/


*Data source
*-----------
*The Nigeria General Household Survey was collected by the Nigeria National Bureau of Statistics (NBS) 
*and the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture(LSMS - ISA)
*The data were collected over the period  August - October 2012 and February - April 2013.
*All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
*http://microdata.worldbank.org/index.php/catalog/2734

*Throughout the do-file, we sometimes use the shorthand LSMS to refer to the Nigeria General Household Survey .


*Summary of Executing the Master do.file
*-----------
*This Master do.file constructs selected indicators using the Nigeria General Household Survey (NG LSMS) data set.
*Using data files from within the "Nigeria GHSP - LSMS-ISA - Wave 2 (2012-13)" folder within the "Raw DTA files" folder, 
*the do.file first constructs common and intermediate variables, saving dta files when appropriate 
*in the folder "\Nigeria GHS Wave 2\created_data" within the "Final DTA files" folder.
*These variables are then brought together at the household, plot, or individual level, saving dta files at each level when available 
*in the folder "Nigeria GHS Wave 2" within the "Final DTA files" folder.

*The processed files include all households, individuals, and plots in the sample.
*Toward the end of the do.file, a block of code estimates summary statistics (mean, standard error of the mean, minimum, first quartile, median, third quartile, maximum) 
*of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager.
*The results are outputted in the excel file "Nigeria_GHS_W2_summary_stats.xlsx" in the "Nigeria GHS Wave 2" within the "Final DTA files" folder.
*It is possible to modify the condition  "if rural==1" in the portion of code following the heading "SUMMARY STATISTICS" to generate all summary statistics for a different sub_population.

*The following refer to running this Master do.file with EPAR's cleaned data files. Information on EPAR's cleaning and construction decisions is available in the documents
*"EPAR_UW_335_Indicator Construction Summary Tables" and "EPAR_UW_335_General Considerations and Principles for Indicator Construction.docx" within the folder "Supporting documents".


/*OUTLINE OF THE DO.FILE
Below are the list of the main files created by running this Master do.file
 					
*INTERMEDIATE FILES					MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD IDS					Nigeria_GHS_W2_hhids.dta
*INDIVIDUAL IDS					Nigeria_GHS_W2_person_ids.dta
*HOUSEHOLD SIZE					Nigeria_GHS_W2_hhsize.dta
*HEAD OF HOUSEHOLD				Nigeria_GHS_W2_male_head.dta
*PARCEL AREAS					Nigeria_GHS_W2_plot_areas.dta
*PLOT-CROP DECISION MAKERS			Nigeria_GHS_W2_plot_decision_makers.dta
*PLOT-CROP PLANTING/HARVEST DATA		Nigeria_GHS_W2_all_plots.dta
*GROSS CROP REVENUE				Nigeria_GHS_W2_cropsales_value.dta
						Nigeria_GHS_W2_hh_crop_values_production.dta
						Nigeria_GHS_W2_hh_crop_production.dta
*CROP EXPENSES					Nigeria_GHS_W2_hh_cost_labor.dta
						Nigeria_GHS_W2_plot_cost_inputs.dta *Plot
						Nigeria_GHS_W2_hh_cost_inputs.dta *Household
*TLU (Tropical Livestock Units)			Nigeria_GHS_W2_TLU_Coefficients.dta
						Nigeria_GHS_W2_herd_characteristics.dta
*LIVESTOCK INCOME				Nigeria_GHS_W2_livestock_expenses.dta
						Nigeria_GHS_W2_hh_livestock_products.dta
						Nigeria_GHS_W2_livestock_sales.dta
						Nigeria_GHS_W2_livestock_income.dta
*FISH INCOME					Nigeria_GHS_W3_fishing_expenses_1.dta	
						Nigeria_GHS_W3_fishing_expenses_2.dta						
*SELF-EMPLOYMENT INCOME				Nigeria_GHS_W2_self_employment_income.dta
						Nigeria_GHS_W2_agproduct_income.dta
*WAGE INCOME					Nigeria_GHS_W2_wage_income.dta
						Nigeria_GHS_W2_agwage_income.dta
*OTHER INCOME					Nigeria_GHS_W2_remittance_income.dta
						Nigeria_GHS_W2_other_income.dta
						Nigeria_GHS_W2_land_rental_income.dta
*FARM SIZE / LAND SIZE				Nigeria_GHS_W2_land_size.dta
						Nigeria_GHS_W2_farmsize_all_agland.dta
						Nigeria_GHS_W2_land_size_all.dta
*FARM LABOR					Nigeria_GHS_W2_farmlabor_postplanting.dta
						Nigeria_GHS_W2_farmlabor_postharvest
						Nigeria_GHS_W2_family_hired_labor.dta
*VACCINE USAGE					Nigeria_GHS_W2_farmer_vaccine.dta
*ANIMAL HEALTH					Nigeria_GHS_W2_livestock_diseases
*INPUT USE BY MANAGERS/HOUSEHOLDS		Nigeria_GHS_W2_farmer_fert_use.dta
						Nigeria_GHS_W2_input_use.dta
*REACHED BY AG EXTENSION			Nigeria_GHS_W2_any_ext.dta
*MOBILE PHONE OWNERSHIP				Nigeria_GHS_W2_mobile_own.dta
*USE OF FORMAL FINANACIAL SERVICES		Nigeria_GHS_W2_fin_serv.dta
*LIVESTOCK PRODUCTIVITY				Nigeria_GHS_W2_milk_animals.dta
						Nigeria_GHS_W2_egg_animals.dta
*CROP PRODUCTION COSTS PER HECTARE		Nigeria_GHS_W2_cropcosts.dta
*FERTILIZER APPLICATION RATES			Nigeria_GHS_W2_fertilizer_application.dta 
*HOUSEHOLD'S DIET DIVERSITY SCORE		Nigeria_GHS_W2_household_diet.dta
*WOMEN'S CONTROL OVER INCOME			Nigeria_GHS_W2_control_income.dta
*WOMEN'S AG DECISION-MAKING			Nigeria_GHS_W2_make_ag_decision.dta
*WOMEN'S ASSET OWNERSHIP			Nigeria_GHS_W2_make_ownasset.dta
*SHANNON DIVERSITY INDEX			Nigeria_GHS_W2_shannon_diversity_index
*CONSUMPTION					Nigeria_GHS_W2_consumption.dta 
*ASSETS						Nigeria_GHS_W2_hh_assets.dta
*GENDER PRODUCTIVITY GAP 			Nigeria_GHS_W2_gender_productivity_gap.dta

*FINAL FILES						MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD VARIABLES				Nigeria_GHS_W2_household_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			Nigeria_GHS_W2_individual_variables.dta	
*PLOT-LEVEL VARIABLES				Nigeria_GHS_W2_gender_productivity_gap.dta
*SUMMARY STATISTICS					Nigeria_GHS_W2_summary_stats.xlsx
*/


clear
clear matrix
clear mata
program drop _all
set more off
set maxvar 10000
ssc install findname

*Set location of raw data and output
global directory			"LSMS-Agricultural-Indicators-Code" //Update this to match the path to your local repo

//set directories
*Nigeria General HH survey (NG LSMS)  Wave 2
global Nigeria_GHS_W2_raw_data "$directory/Nigeria GHS/Nigeria GHS Wave 2/Raw DTA Files/NGA_2012_GHSP-W2_v02_M"
global Nigeria_GHS_W2_created_data  "$directory/Nigeria GHS/Nigeria GHS Wave 2/Final DTA Files/created_data"
global Nigeria_GHS_W2_final_data  "$directory/Nigeria GHS/Nigeria GHS Wave 2/Final DTA Files/final_data" 
  
********************************************************************************
*EXCHANGE RATE AND INFLATION FOR CONVERSION IN USD
********************************************************************************
global Nigeria_GHS_W2_exchange_rate 199.04975  	// ALT: This was originally from Bloomberg in W3. I'm switching to https://fx-rate.net/NGN/?date_input=2018-06-05
												// Because it has other conversion rates that can be used below. There's a fairly big discrepancy between fx-rate and wb (306 N/USD for WB 2018 vs 358 N/USD for fx-rate) 
//global Nigeria_GHS_W1_pound_exchange 476.5
//global Nigeria_GHS_W1_euro_exchange 418.7

/* COMMENTING THIS OUT TEMPORARILY 
//ALT 03.20.23: Updating to 2017 values
global Nigeria_GHS_W2_gdp_ppp_dollar 115.1
global Nigeria_GHS_W2_cons_ppp_dollar 112.1 
global Nigeria_GHS_W2_inflation = 0.6298 //134.9/214.2
*/

global Nigeria_GHS_W2_exchange_rate 199.04975		// https://www.bloomberg.com/quote/USDETB:CUR
global Nigeria_GHS_W2_gdp_ppp_dollar 115.9778	// https://data.worldbank.org/indicator/PA.NUS.PPP
global Nigeria_GHS_W2_cons_ppp_dollar 112.0983276		// https://data.worldbank.org/indicator/PA.NUS.PRVT.P
global Nigeria_GHS_W2_inflation 0.587791		// inflation rate 2013-2016. Data was collected during 2012-2013. We want to ajhust value to 2017


//Poverty threshold calculation - It's probably easier to do up here than at the end of the code for ease of transparency and adjustability
//Per W3, we convert WB's international poverty threshold to 2011$ using the PA.NUS.PRVT.PP WB info then inflate to the last year of the survey using CPI
global Nigeria_GHS_W2_poverty_threshold (1.90*83.58) * 134.9/110.8
global Nigeria_GHS_W2_poverty_nbs 376.52 * $Nigeria_GHS_W2_inflation //ALT: To do: adjust for inflation
global Nigeria_GHS_W2_poverty_215 2.15*$Nigeria_GHS_W2_inflation * $Nigeria_GHS_W2_cons_ppp_dollar  //New 2023 WB poverty threshold

********************************************************************************
*THRESHOLDS FOR WINSORIZATION
********************************************************************************
global wins_lower_thres 1    						//  Threshold for winzorization at the bottom of the distribution of continous variables
global wins_upper_thres 99							//  Threshold for winzorization at the top of the distribution of continous variables



*DYA.11.1.2020 Re-scaling survey weights to match population estimates
*https://databank.worldbank.org/source/world-development-indicators#
global Nigeria_GHS_W2_pop_tot 170075932
global Nigeria_GHS_W2_pop_rur 93123376
global Nigeria_GHS_W2_pop_urb 76952556


********************************************************************************
*PRIORITY CROPS //change these globals if you are interested in a different crop
********************************************************************************
////Limit crop names in variables to 6 characters or the variable names will be too long! 
global topcropname_area "maize rice sorgum millet cowpea grdnt yam swtptt cassav banana cocoa soy" 
global comma_topcrop_area "1080, 1110, 1070, 1100, 1010, 1060, 1120, 2181, 1020, 2030, 3040, 2220"
global topcrop_area = subinstr("$comma_topcrop_area",","," ",.) //removing commas from the list above
global nb_topcrops : list sizeof global(topcropname_area) // Gets the current length of the global macro list "topcropname_area" 
display "$nb_topcrops"
global nb_topcrops : list sizeof global(topcropname_area) // Gets the current length of the global macro list "topcropname_area" 
set obs $nb_topcrops //Update if number of crops changes
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
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_cropname_table.dta", replace //This gets used to generate the monocrop files.

********************************************************************************
* HOUSEHOLD IDS *
********************************************************************************
use "${Nigeria_GHS_W2_raw_data}/HHTrack.dta", clear
merge m:1 hhid using "${Nigeria_GHS_W2_raw_data}/secta_plantingw2.dta"
gen rural = (sector==2)
lab var rural "1= Rural"
keep hhid zone state lga ea wt_wave2 rural
ren wt_wave2 weight
drop if weight == . //Non-surveyed households
recast double weight
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hhids.dta", replace

********************************************************************************
* WEIGHTS *
********************************************************************************
/* //ALT: Redundant 
use "${Nigeria_GHS_W2_raw_data}/HHTrack.dta", clear
merge m:1 hhid using "${Nigeria_GHS_W2_raw_data}/secta_plantingw2.dta"
gen rural = (sector==2)
lab var rural "1= Rural"
keep hhid zone state lga ea wt_wave2 rural
ren wt_wave2 weight
save  "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_weights.dta", replace
*/

********************************************************************************
* INDIVIDUAL IDS *
********************************************************************************
use "${Nigeria_GHS_W2_raw_data}/PTrack.dta", clear
keep hhid indiv sex age 
gen female= sex==2
la var female "1= individual is female"
la var age "Individual age"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_person_ids.dta", replace


********************************************************************************
* HOUSEHOLD SIZE *
********************************************************************************

use "${Nigeria_GHS_W2_raw_data}/PTrack.dta", clear
gen hh_members = 1 
ren sex gender
gen fhh = ((relat_w2v1==1 | relat_w2v2==1) & gender==2)
collapse (sum) hh_members (max) fhh, by (hhid)
lab var hh_members "Number of household members"
lab var fhh "1= Female-headed household"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hhsize2.dta", replace



*DYA 08.12.2020 - correcting estimates of hh size following Ayala suggestion.
*Initial individidual not longer in the hh were counted as hh members though they have moved away
use "${Nigeria_GHS_W2_raw_data}/sect1_plantingw2.dta", clear
gen hh_members = 1 if s1q4==1
keep if hh_members!=.
ren s1q2 gender
ren s1q3 rela_hh
gen fhh =gender==2 & rela_hh==1
collapse (sum) hh_members (max) fhh, by (hhid)
lab var hh_members "Number of household members"
lab var fhh "1= Female-headed household"
*DYA.11.1.2020 Re-scaling survey weights to match population estimates
merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hhids.dta", nogen
*Adjust to match total population
total hh_members [pweight=weight]
matrix temp =e(b)
gen weight_pop_tot=weight*${Nigeria_GHS_W2_pop_tot}/el(temp,1,1)
total hh_members [pweight=weight_pop_tot]
lab var weight_pop_tot "Survey weight - adjusted to match total population"
*Adjust to match total population but also rural and urban
total hh_members [pweight=weight] if rural==1
matrix temp =e(b)
gen weight_pop_rur=weight*${Nigeria_GHS_W2_pop_rur}/el(temp,1,1) if rural==1
total hh_members [pweight=weight_pop_tot]  if rural==1

total hh_members [pweight=weight] if rural==0
matrix temp =e(b)
gen weight_pop_urb=weight*${Nigeria_GHS_W2_pop_urb}/el(temp,1,1) if rural==0
total hh_members [pweight=weight_pop_urb]  if rural==0

egen weight_pop_rururb=rowtotal(weight_pop_rur weight_pop_urb)
total hh_members [pweight=weight_pop_rururb]  
lab var weight_pop_rururb "Survey weight - adjusted to match rural and urban population"
drop weight_pop_rur weight_pop_urb
recast double weight*
*drop hh_members
*merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hhsize2.dta", nogen
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hhsize.dta", replace
keep hhid zone state lga ea weight* rural
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_weights.dta", replace
*end hh_member correction

//ALT: Copy paste section
********************************************************************************
* PLOT AREAS *
********************************************************************************
*starting with planting
clear


*using conversion factors from LSMS-ISA Nigeria Wave 2 Basic Information Document (Waves 1 & 2 are identical)
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
set obs 42 //6 zones x 7 units
egen zone=seq(), f(1) t(6) b(7)
egen area_unit=seq(), f(1) t(7)
gen conversion=1 if area_unit==6
gen area_size=1 //This makes it easy for me to copy-paste existing code rather than having to write a new block
replace conversion = area_size*0.0667 if area_unit==4									//reported in plots
replace conversion = area_size*0.404686 if area_unit==5		    						//reported in acres
replace conversion = area_size*0.0001 if area_unit==7									//reported in square meters

replace conversion = area_size*0.00012 if area_unit==1 & zone==1						//reported in heaps
replace conversion = area_size*0.00016 if area_unit==1 & zone==2
replace conversion = area_size*0.00011 if area_unit==1 & zone==3
replace conversion = area_size*0.00019 if area_unit==1 & zone==4
replace conversion = area_size*0.00021 if area_unit==1 & zone==5
replace conversion = area_size*0.00012 if area_unit==1 & zone==6

replace conversion = area_size*0.0027 if area_unit==2 & zone==1							//reported in ridges
replace conversion = area_size*0.004 if area_unit==2 & zone==2
replace conversion = area_size*0.00494 if area_unit==2 & zone==3
replace conversion = area_size*0.0023 if area_unit==2 & zone==4
replace conversion = area_size*0.0023 if area_unit==2 & zone==5
replace conversion = area_size*0.00001 if area_unit==2 & zone==6

replace conversion = area_size*0.00006 if area_unit==3 & zone==1						//reported in stands
replace conversion = area_size*0.00016 if area_unit==3 & zone==2
replace conversion = area_size*0.00004 if area_unit==3 & zone==3
replace conversion = area_size*0.00004 if area_unit==3 & zone==4
replace conversion = area_size*0.00013 if area_unit==3 & zone==5
replace conversion = area_size*0.00041 if area_unit==3 & zone==6

drop area_size
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_landcf.dta", replace

use "${Nigeria_GHS_W2_raw_data}/sect11a1_plantingw2"
*merging in planting section to get cultivated status
merge 1:1 hhid plotid using "${Nigeria_GHS_W2_raw_data}/sect11b1_plantingw2", nogen
*merging in harvest section to get areas for new plots
merge 1:1 hhid plotid using "${Nigeria_GHS_W2_raw_data}/secta1_harvestw2.dta", gen(plot_merge)
ren s11aq4a area_size
ren s11aq4b area_unit
ren sa1q9a area_size2
ren sa1q9b area_unit2
ren s11aq4c area_meas_sqm
ren sa1q9c area_meas_sqm2
gen cultivate = s11b1q27 ==1 
*assuming new plots are cultivated
replace cultivate = 1 if sa1q3==1
merge m:1 zone area_unit using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_landcf.dta", nogen keep(1 3) 
*farmer reported field size for post-planting
gen field_size= area_size*conversion
*replacing farmer reported with GPS if available
replace field_size = area_meas_sqm*0.0001 if area_meas_sqm!=.               				
gen gps_meas = (area_meas_sqm!=. | area_meas_sqm2!=.)
la var gps_meas "Plot was measured with GPS, 1=Yes"
*farmer reported field size for post-harvest added fields
drop area_unit conversion
ren area_unit2 area_unit
merge m:1 zone area_unit using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_landcf.dta", nogen keep(1 3)
replace field_size= area_size2*conversion if field_size==.
*replacing farmer reported with GPS if available
replace field_size = area_meas_sqm2*0.0001 if area_meas_sqm2!=.               
la var field_size "Area of plot (ha)"
ren plotid plot_id
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_areas.dta", replace

********************************************************************************
* PLOT DECISION MAKERS *
********************************************************************************
*Creating gender variables for plot manager from post-planting
use "${Nigeria_GHS_W2_raw_data}/sect1_plantingw2.dta", clear
gen female = s1q2==2 if s1q2!=.
gen age = s1q6
*dropping duplicates (data is at holder level so some individuals are listed multiple times, we only need one record for each)
duplicates drop hhid indiv, force
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_gender_merge_temp.dta", replace

*adding in gender variables for plot manager from post-harvest
use "${Nigeria_GHS_W2_raw_data}/sect1_harvestw2.dta", clear
gen female = s1q2==2 if s1q2!=.
gen age = s1q4
duplicates drop hhid indiv, force
drop s1q36 s1q37b                
merge 1:1 hhid indiv using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_gender_merge_temp.dta", nogen 		
keep hhid indiv female age
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_gender_merge.dta", replace

*Using planting data 	
use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_areas.dta", clear 
gen indiv1 = s11aq6a
gen indiv2 = s11aq6b
gen indiv3 = sa1q11
gen indiv4 = sa1q11b
preserve
keep hhid plot_id indiv*
reshape long indiv, i(hhid plot_id) j(individ)
merge m:1 hhid indiv using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_gender_merge_temp.dta", keep(3)
collapse (mean) female, by(hhid plot_id) 
gen dm_gender = 3
replace dm_gender = 1 if female==0
replace dm_gender = 2 if female==1
tempfile dm_genders
save `dm_genders'
restore
merge 1:1 hhid plot_id using `dm_genders', nogen
la def dm_gender 1 "Male only" 2 "Female only" 3 "Mixed gender"
*replacing observations without gender of plot manager with gender of HOH
merge m:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hhsize2.dta" //nogen keep(1 3)
replace dm_gender=1 if fhh ==0 & dm_gender==. 
replace dm_gender=2 if fhh ==1 & dm_gender==. 
gen dm_male = dm_gender==1
gen dm_female = dm_gender==2
gen dm_mixed = dm_gender==3
keep field_size plot_id hhid dm_* fhh 
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_decision_makers", replace


********************************************************************************
*formalized land rights*
********************************************************************************
use "${Nigeria_GHS_W2_raw_data}/sect11b1_plantingw2.dta", clear
*DYA.11.21.2020  we need to recode . to 0 or exclude them as . as treated as very large numbers in Stata
gen formal_land_rights=1 if (s11b1q8>=1 & s11b1q8!=.) | (s11b1q10a>=1 & s11b1q10a!=.)  | (s11b1q10b>=1 & s11b1q10b!=.) | (s11b1q10c>=1 & s11b1q10c!=.) | (s11b1q10d>=1 & s11b1q10d!=.)								// Note: Including anything other than "no documents" as formal
*Individual level (for women)
*Starting with first owner
preserve
ren s11b1q6a indiv
merge m:1 hhid indiv using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_person_ids.dta", nogen keep(3)		
keep hhid indiv female formal_land_rights
tempfile p1
save `p1', replace
restore
*Now second owner
preserve
ren s11b1q6b indiv		
merge m:1 hhid indiv using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_person_ids.dta", nogen keep(3)		
keep hhid indiv female
append using `p1'
gen formal_land_rights_f = formal_land_rights==1 if female==1
collapse (max) formal_land_rights_f, by(hhid indiv)		
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_land_rights_ind.dta", replace
restore	
collapse (max) formal_land_rights_hh=formal_land_rights, by(hhid)		// taking max at household level; equals one if they have official documentation for at least one plot
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_land_rights_hh.dta", replace


********************************************************************************
*crop unit conversion factors
********************************************************************************
use "${Nigeria_GHS_W2_raw_data}/w2agnsconversion", clear
ren cropcode crop_code
ren nscode unit_cd
drop if kg==0
ren conversion  conv_fact
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_ng3_cf.dta", replace


********************************************************************************
*ALL PLOTS
********************************************************************************
//ALT 08.27.21: The next ~1100 lines or so are imported from the code I wrote for W3 to replace the other crop sections.
use "${Nigeria_GHS_W2_raw_data}/secta3_harvestW2.dta", clear
	keep if sa3q3==1
	ren sa3q11a qty1
	ren sa3q11b unit_cd1
	ren sa3q12 value1
	replace unit_cd1 = sa3q6a2 if unit_cd1==.
	replace qty1=sa3q6a1 if unit_cd1!=. & unit_cd1==sa3q6a2 & (qty1==0 | qty1==.)
	replace qty1 = . if unit_cd1==. | qty1==0 

	//This adds ~150 obs
	ren sa3q16a qty2
	ren sa3q16b unit_cd2
	ren sa3q17 value2 
	keep zone state lga sector ea hhid cropcode qty* unit_cd* value*
	gen dummy = _n
	reshape long qty unit_cd value, i(zone state lga sector ea hhid cropcode dummy) j(idno)
	drop idno dummy //not necessary
	merge m:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_weights.dta", nogen keepusing(weight_pop_rururb)
	ren cropcode crop_code
	gen price_unit = value/qty
	gen obs=price_unit!=.
	foreach i in zone state lga ea hhid {
		preserve
		bys `i' crop_code unit_cd : egen obs_`i'_price = sum(obs)
		collapse (median) price_unit_`i'=price_unit /*[aw=weight_pop_rururb]*/, by (`i' unit_cd crop_code obs_`i'_price) 
		tempfile price_unit_`i'_median
		save `price_unit_`i'_median'
		restore
	}
	collapse (median) price_unit_country = price_unit (sum) obs_country_price=obs [aw=weight_pop_rururb], by(crop_code unit_cd)
	tempfile price_unit_country_median
	save `price_unit_country_median'

use "${Nigeria_GHS_W2_raw_data}/sect11f_plantingW2.dta", clear
merge 1:1 hhid plotid cropid using "${Nigeria_GHS_W2_raw_data}/sect11g_plantingW2.dta", nogen 
	ren cropcode crop_code_11f
	gen perm_crop=(s11gq2!=.)
	gen number_trees_planted = s11gq2
	replace number_trees_planted=. if number_trees_planted==999 //999 = farmer doesn't know. Still a permanent crop, we just don't know how many there are. Attempting to estimate based on normal stand densities is unreliable.
	merge 1:1 hhid plotid /*cropcode*/ cropid using "${Nigeria_GHS_W2_raw_data}/secta3_harvestW2.dta"
	ren plotid plot_id
	ren cropcode crop_code_a3i //i.e., if harvested units are different from planted units
	//Consolidating cropcodes
	replace crop_code_11f=crop_code_a3i if crop_code_11f==.
	replace crop_code_a3i = crop_code_11f if crop_code_a3i==.
	gen crop_code_master =crop_code_11f //Generic level
	recode crop_code_master (1053=1050) (1061 1062 = 1060) (1081 1082=1080) (1091 1092 1093 = 1090) (1111=1110) (2191 2192 2193=2190) /*Counting this generically as pumpkin, but it is different commodities
	*/				 (3181 3182 3183 3184 = 3180) (2170=2030) (3113 3112 3111 = 3110) (3022=3020) (2142 2141 = 2140) (1121 1122 1123 1124=1120)
	la values crop_code_master cropcode
	gen area_unit=s11fq1b
	replace area_unit=s11fq4b if area_unit==.
	merge m:1 zone area_unit using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_landcf.dta", nogen keep(1 3)
	gen ha_planted = s11fq1a*conversion
	replace ha_planted = s11fq4a*conversion if ha_planted==.
	drop conversion area_unit
	ren sa3q5b area_unit
	merge m:1 zone area_unit using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_landcf.dta", nogen keep(1 3)
	gen ha_harvest = sa3q5a*conversion
	merge m:1 hhid plot_id using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_areas.dta", nogen keep(1 3) //keepusing(field_size)
	drop area_unit

	preserve
		gen obs=1
		replace obs=0 if inrange(sa3q4,1,5) & perm_crop!=1
		collapse (sum) crops_plot=obs, by(hhid plot_id)
		tempfile ncrops 
		save `ncrops'
	restore //286 plots have >1 crop but list monocropping, 382 say intercropping; meanwhile 130 list intercropping or mixed cropping but only report one crop
	merge m:1 hhid plot_id using `ncrops', nogen
	
	gen lost_crop=inrange(sa3q4,1,5) & perm_crop!=1
	bys hhid plot_id : egen max_lost = max(lost_crop)
	gen replanted = (max_lost==1 & crops_plot>0)
	drop if replanted==1 & lost_crop==1 //Crop expenses should count toward the crop that was kept, probably.

	//95 plots did not replant; keeping and assuming yield is 0.
	bys hhid plot_id : egen crops_avg = mean(crop_code_master) //Checks for different versions of the same crop in the same plot
	gen purestand=1 if crops_plot==1 //This includes replanted crops
	replace perm_crop = 1 if crop_code_master==1020 //I don't see any indication that cassava is grown as a seasonal crop in Nigeria
	bys hhid plot_id : egen permax = max(perm_crop)
	bys hhid plot_id s11fq3a s11fq3b : gen plant_date_unique=_n
	//bys hhid plot_id sa3q4a1 sa3q4a2 : gen harv_date_unique=_n
	bys hhid plot_id : egen plant_dates = max(plant_date_unique)
	//bys hhid plot_id : egen harv_dates = max(harv_date_unique) //ALT 09.01.21: They don't appear to have harvest date in this wave, so I have to omit. May result in some incorrect classifications.
	replace purestand=0 if (crops_plot>1 & (plant_dates>1 /*| harv_dates>1*/))  | (crops_plot>1 & permax==1)  //Multiple crops planted or harvested in the same month are not relayed; may omit some crops that were purestands that preceded or followed a mixed crop.
	gen any_mixed = !(s11fq2==1 | s11fq2==3)
	bys hhid plot_id : egen any_mixed_max = max(any_mixed)
	replace purestand=1 if crops_plot>1 & plant_dates==1 /*& harv_dates==1*/ & permax==0 & any_mixed_max==0 //54 replacements, maybe half of which are proper relay crops; still some huge head-scratchers.
	gen relay=1 if crops_plot>1 & crops_plot>1 & plant_dates==1 /*& harv_dates==1*/ & permax==0 & any_mixed_max==0 //Looks like relay crops are reported either as relays or as monocrops 
	replace purestand=1 if crop_code_11f==crops_avg
	replace purestand=0 if purestand==.
	drop crops_plot crops_avg plant_dates /*harv_dates*/ plant_date_unique /*harv_date_unique*/ permax
	//Okay, now we should be able to relatively accurately rescale plots.
	replace ha_planted = ha_harvest if ha_planted==. //182 changes
	//Let's first consider that planting might be misreported but harvest is accurate
	replace ha_planted = ha_harvest if ha_planted > field_size & ha_harvest < ha_planted & ha_harvest!=. //4,476 changes
	gen percent_field=ha_planted/field_size
*Generating total percent of purestand and monocropped on a field
	bys hhid plot_id: egen total_percent = total(percent_field)
//about 60% of plots have a total intercropped sum greater than 1
//about 3% of plots have a total monocropped sum greater than 1
//Dealing with crops which have monocropping larger than plot size or monocropping that fills plot size and still has intercropping to add
	replace percent_field = percent_field/total_percent if total_percent>1 & purestand==0
	replace percent_field = 1 if percent_field>1 & purestand==1
	//407 changes made


	replace ha_planted = percent_field*field_size
	replace ha_harvest = ha_planted if ha_harvest > ha_planted
	
	*renaming unit code for merge
	ren sa3q6a2 unit_cd 
	//replace unit_cd = s11fq11b if unit_cd==.
	ren sa3q6a1 quantity_harvested
	//replace quantity_harvested = s11fq11a if quantity_harvested==.
	*merging in conversion factors
	ren crop_code_a3i crop_code
	merge m:1 crop_code unit_cd using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_ng3_cf.dta", keep(1 3) gen(cf_merge)
	
	//ALT: Back-converting processed palm oil into oil palm fruit kg from code I wrote for W4
	replace quantity_harvested = quantity_harvested*0.89*10 if crop_code==3180 & unit_cd==91
	replace quantity_harvested = quantity_harvested*0.89*20 if crop_code==3180 & unit_cd==92
	replace quantity_harvested = quantity_harvested*0.89*25 if crop_code==3180 & unit_cd==93
	replace quantity_harvested = quantity_harvested*0.89*50 if crop_code==3180 & unit_cd==94
	replace quantity_harvested = quantity_harvested*0.89 if crop_code==3180 & unit==3
	replace quantity_harvested=quantity_harvested/0.17 if crop_code==3180 & inlist(unit_cd,91,92,93,94,3) //Oil content (w/w) of oil palm fruit, 
	replace unit_cd=1 if crop_code==3180 & inlist(unit_cd,91,92,93,94,3)
	replace conv_fact=1 if unit_cd==1
	replace conv_fact=0.001 if unit_cd==2
	//92 entries w/o conversions at this point.
	gen quant_harv_kg= quantity_harvested*conv_fact
	
	ren sa3q18 value_harvest
	gen val_unit = value_harvest/quantity_harvested
	gen val_kg = value_harvest/quant_harv_kg
	merge m:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_weights.dta", nogen keep(1 3)
	gen plotweight = ha_planted*weight_pop_rururb
	gen obs=quantity_harvested>0 & quantity_harvested!=.
	foreach i in zone state lga ea hhid {
preserve
	bys crop_code `i' : egen obs_`i'_kg = sum(obs)
	collapse (median) val_kg_`i'=val_kg [aw=plotweight], by (`i' crop_code obs_`i'_kg)
	tempfile val_kg_`i'_median
	save `val_kg_`i'_median'
restore
}
preserve
collapse (median) val_kg_country = val_kg (sum) obs_country_kg=obs [aw=plotweight], by(crop_code)
tempfile val_kg_country_median
save `val_kg_country_median'
restore

foreach i in zone state lga ea hhid {
preserve
	bys `i' crop_code unit_cd : egen obs_`i'_unit = sum(obs)
	collapse (median) val_unit_`i'=val_unit, by (`i' unit_cd crop_code obs_`i'_unit)
	tempfile val_unit_`i'_median
	save `val_unit_`i'_median'
restore
	merge m:1 `i' unit_cd crop_code using `price_unit_`i'_median', nogen keep(1 3)
	merge m:1 `i' unit_cd crop_code using `val_unit_`i'_median', nogen keep(1 3)
	merge m:1 `i' crop_code using `val_kg_`i'_median', nogen keep(1 3)
}
preserve
collapse (median) val_unit_country = val_unit (sum) obs_country_unit=obs [aw=plotweight], by(crop_code unit_cd)
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_crop_prices_median_country.dta", replace //This gets used for self-employment income.
restore

merge m:1 unit_cd crop_code using `price_unit_country_median', nogen keep(1 3)
merge m:1 unit_cd crop_code using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_crop_prices_median_country.dta", nogen keep(1 3)
merge m:1 crop_code using `val_kg_country_median', nogen keep(1 3)

//We're going to prefer observed prices first
foreach i in country zone state lga ea {
	replace val_unit = price_unit_`i' if obs_`i'_price>9
	replace val_kg = val_kg_`i' if obs_`i'_kg >9
}
	gen val_missing = val_unit==.
	replace val_unit = price_unit_hhid if price_unit_hhid!=.

foreach i in country zone state lga ea {
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
	save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_crop_prices_for_wages.dta", replace
restore
/* No expected harvest
	gen same_unit=unit_cd==sa3q6d2
	//ALT 05.12.21: I feel like we should include the expected harvest.
	drop unit_cd quantity_harvested *conv* cf_merge
	ren sa3q6d2 unit_cd
	ren sa3q6d1 quantity_harvested
	merge m:1 crop_code unit_cd using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_ng3_cf.dta", nogen keep(1 3)
	gen quant_harv_kg2= quantity_harvested*conv_fact
	gen val_harv2 = 0
	recode quant_harv_kg2 quantity_harvested (.=0)
foreach i in country zone state lga ea {
	replace val_harv2=quantity_harvested*val_unit_`i' if same_unit==1 & obs_`i'_unit>9 & val_unit_`i'!=.
	replace val_harv2=quant_harv_kg2*val_kg_`i' if same_unit==0 & obs_`i'_kg >9 & val_kg_`i'!=.
}
	replace val_harv2=quantity_harvested*val_unit_hhid if same_unit==1 & val_unit_hhid!=.
	replace val_harv2=quant_harv_kg2*val_kg_hhid if same_unit==0 & val_kg_hhid != . 
//The few that don't have the same units are in somewhat suspicious units. (I'm pretty sure you can't measure bananas in liters)
	recode quant_harv* (.=0)
	replace quant_harv_kg = quant_harv_kg+quant_harv_kg2
	replace value_harvest = value_harvest+val_harv2
	//Only affects 966 obs 
	drop val_harv2 quant_harv_kg2 val_* obs*
	*/
//AgQuery
	collapse (sum) quant_harv_kg value_harvest ha_planted ha_harvest number_trees_planted percent_field /*(max) months_grown*/, by(zone state lga sector ea hhid plot_id crop_code_master purestand relay field_size gps_meas)
	bys hhid plot_id : egen percent_area = sum(percent_field)
	bys hhid plot_id : gen percent_inputs = percent_field/percent_area
	drop percent_area //Assumes that inputs are +/- distributed by the area planted. Probably not true for mixed tree/field crops, but reasonable for plots that are all field crops
	//Labor should be weighted by growing season length, though. 
	merge m:1 hhid plot_id using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
	save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_all_plots.dta",replace

/*
Monocrop plots are in their own section below
*/

********************************************************************************
* GROSS CROP REVENUE *
********************************************************************************
*Generating Value of crop sales
use "${Nigeria_GHS_W2_raw_data}/secta3_harvestW2.dta", clear
	keep if sa3q3==1
	ren sa3q11a qty1
	ren sa3q11b unit_cd1
	ren sa3q12 value1
//This adds ~150 obs
	ren sa3q16a qty2
	ren sa3q16b unit_cd2
	ren sa3q17 value2
	ren cropcode crop_code
keep hhid crop_code qty* value* unit* 
gen dummy = _n
reshape long qty value unit_cd, i(hhid crop_code dummy) j(idno)
drop idno dummy
ren qty quantity_sold
ren val sales_value
*merging in conversion factors
merge m:1 crop_code unit_cd using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_ng3_cf.dta", gen(cf_merge)
gen kgs_sold= quantity_sold*conv_fact
collapse (sum) sales_value kgs_sold, by (hhid crop_code)
lab var sales_value "Value of sales of this crop"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_cropsales_value.dta", replace 


use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_all_plots.dta", clear
ren crop_code_master crop_code
collapse (sum) value_harvest , by (hhid crop_code) 
merge 1:1 hhid crop_code using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_cropsales_value.dta", nogen
replace value_harvest = sales_value if sales_value>value_harvest & sales_value!=. /* In a few cases, sales value reported exceeds the estimated value of crop harvest */
ren sales_value value_crop_sales 
recode  value_harvest value_crop_sales  (.=0)
collapse (sum) value_harvest value_crop_sales, by (hhid crop_code)
ren value_harvest value_crop_production
lab var value_crop_production "Gross value of crop production, summed over main and short season"
lab var value_crop_sales "Value of crops sold so far, summed over main and short season"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_crop_values_production.dta", replace 
//Legacy code 

collapse (sum) value_crop_production value_crop_sales, by (hhid)
lab var value_crop_production "Gross value of crop production for this household"
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
replace proportion_cropvalue_sold = . if proportion_cropvalue_sold > 1 // HKS 4/11/23: We should not have household reporting significantly more value crop sold than value crop produced/harvested; so for now, we are eliminating the proportions that are greater than 1 for AQP
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_crop_production.dta", replace

/*In the all plots file
Generating value of crop production at plot level
use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_all_plots.dta", clear
collapse (sum) value_harvest, by (hhid plot_id)
ren value_harvest plot_value_harvest
lab var plot_value_harvest "Value of crop harvest on this plot"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_cropvalue.dta", replace
*/

/*Crops lost post-harvest
use "${Nigeria_GHS_W2_raw_data}/secta3_harvestW2.dta", clear
ren cropname crop_name
ren cropcode crop_code
ren sa3q18c share_lost
merge m:1 hhid crop_code using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_crop_values_production.dta", nogen keep(1 3)
recode share_lost (.=0)
gen crop_value_lost = value_crop_production * (share_lost/100)
collapse (sum) crop_value_lost, by (hhid)
lab var crop_value_lost "Value of crops lost between harvest and survey time"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_crop_losses.dta", replace
*/

********************************************************************************
* CROP EXPENSES *
********************************************************************************

	*********************************
	* 			LABOR				*
	*********************************
	*Hired
use "${Nigeria_GHS_W2_raw_data}/sect11c1_plantingW2.dta", clear	
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
	keep zone state lga ea hhid plot_id *hired*
	gen season="pp"
tempfile postplanting_hired
save `postplanting_hired'


use "${Nigeria_GHS_W2_raw_data}/secta2_harvestW2.dta", clear
ren plotid plot_id
	ren sa2q11a crop_code
	ren sa2q11b qty
	ren sa2q11c unit
	ren sa2q2 numberhiredmale 
	ren sa2q3 dayshiredmale
	ren sa2q5 numberhiredfemale
	ren sa2q6 dayshiredfemale
	ren sa2q8 numberhiredchild
	ren sa2q9 dayshiredchild
	ren sa2q4 wagehiredmale //Wage per person/per day
	ren sa2q7 wagehiredfemale
	ren sa2q10 wagehiredchild
	keep zone state lga ea hhid plot_id *hired* crop_code qty unit
	gen season="ph"
tempfile harvest_hired
save `harvest_hired'

use `postplanting_hired'
//append using `mid_hired' - no midseason
append using `harvest_hired'
preserve
	//Not including in-kind payments as part of wages b/c they are not disaggregated by worker gender (but including them as an explicit expense below)
	merge m:1 hhid crop_code unit using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_crop_prices_for_wages.dta", nogen keep(1 3)
	recode qty hh_price_mean (.=0)
	gen val = qty*hh_price_mean
	keep hhid val plot_id
	gen exp = "exp"
	merge m:1 plot_id hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_decision_makers", nogen keep(1 3) keepusing(dm_gender)
	tempfile inkind_payments
	save `inkind_payments'
restore
	drop qty crop_code unit
reshape long numberhired dayshired wagehired /*inkindhired*/, i(zone state lga ea hhid plot_id season) j(gender) string
reshape long number days wage /*inkind*/, i(zone state lga ea hhid plot_id gender season) j(labor_type) string
	recode wage days number /*inkind*/ (.=0)
	drop if wage==0 & days==0 & number==0 /*& inkind==0*/
	replace wage = wage/number //ALT 08.16.21: The question is "How much did you pay in total per day to the hired <laborers>." For getting median wages for implicit values, we need the wage/person/day
//	gen val = wage*days*number
merge m:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_weights.dta", nogen keep(1 3) keepusing(weight_pop_rururb)
merge m:1 hhid plot_id using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_areas.dta", nogen keep(1 3) keepusing(field_size)
gen plotweight = weight*field_size
recode wage (0=.)
gen obs=wage!=.
*Median wages

foreach i in zone state lga ea hhid {
preserve
	bys `i' season gender : egen obs_`i' = sum(obs)
	collapse (median) wage_`i'=wage [aw=plotweight], by (`i' season gender obs_`i')
	tempfile wage_`i'_median
	save `wage_`i'_median'
restore
merge m:1 `i' season gender using `wage_`i'_median', nogen
}
preserve
collapse (median) wage_country = wage (sum) obs_country=obs [aw=plotweight], by(season gender)
tempfile wage_country_median
save `wage_country_median'
restore
merge m:1 season gender using `wage_country_median', nogen
gen wage_plot=wage
//Borrowing code from below
foreach i in country zone state lga ea {
	replace wage = wage_`i' if obs_`i' > 9 & wage_`i'!=.
}
egen wage_sd = sd(wage_plot), by(gender season)
egen mean_wage = mean(wage_plot), by(gender season)
/* The below code assumes that wages are normally distributed and values below the 0.15th percentile and above the 99.85th percentile are outliers, keeping the median values for the area in those instances.
In reality, what we see is that it trims a significant amount of right skew - the max value is 14 stdevs above the mean while the min is only 1.15 below. 
*/
replace wage=wage_plot if wage_plot !=. & abs(wage_hhid-mean_wage)/wage_sd <3 

gen val = wage*days*number
drop obs* plotweight wage* mean* *sd
tempfile all_hired
save `all_hired'

//Family labor
use "${Nigeria_GHS_W2_raw_data}/sect11c1_plantingW2.dta", clear
	ren plotid plot_id
	ren s11c1q1*1 pid*
	ren s11c1q1*2 weeks_worked*
	ren s11c1q1*3 days_week*
keep zone state lga sector ea hhid plot_id pid* weeks_worked* days_week*
gen season="pp"
tempfile postplanting_family
save `postplanting_family'

use "${Nigeria_GHS_W2_raw_data}/secta2_harvestW2.dta", clear
	ren plotid plot_id
/*	ren sa2q1b_*1 pid*
	ren sa2q1b_*2 weeks_worked*
	ren sa2q1b_*3 days_week*
preserve
keep zone state lga sector ea hhid plot_id pid* weeks_worked* days_week*
gen season="mid"
tempfile mid_family
save `mid_family'
restore
	drop pid* weeks_worked* days_week* */
	ren sa2q1*1 pid*
	ren sa2q1*2 weeks_worked*
	ren sa2q1*3 days_week*
preserve
keep zone state lga sector ea hhid plot_id pid* weeks_worked* days_week*
gen season="ph"
tempfile harvest_family
save `harvest_family'
//exchange labor, note no planting data
restore
	/*drop pid* weeks_worked* days_week*
	ren sa2q1n_a daysnonhiredmale
	ren sa2q1n_b daysnonhiredfemale
	ren sa2q1n_c daysnonhiredchild*/
/*preserve
	keep zone state lga sector ea hhid plot_id days* 
	gen season="mid"
	tempfile mid_exchange
	save `mid_exchange'
restore*/
	drop days*
	ren sa2q11a daysnonhiredmale
	ren sa2q11b daysnonhiredfemale
	ren sa2q11c daysnonhiredchild
	gen season="ph"
	//append using `mid_exchange'
	reshape long daysnonhired, i(zone state lga sector ea hhid plot_id season) j(gender) string
	reshape long days, i(zone state lga sector ea hhid plot_id season gender) j(labor_type) string
tempfile all_exchange
save `all_exchange'

use "${Nigeria_GHS_W2_raw_data}/sect1_plantingW2.dta", clear
ren indiv pid
isid hhid pid	
gen male = s1q2==1
gen age = s1q6
keep hhid pid age male
tempfile members
save `members', replace

use `postplanting_family',clear
//append using `mid_family'
append using `harvest_family'
reshape long pid weeks_worked days_week, i(zone state lga sector ea hhid plot_id season) j(colid) string
gen days=weeks_worked*days_week
drop if days==.
merge m:1 hhid pid using `members', nogen keep(1 3)
gen gender="child" if age<16
replace gender="male" if strmatch(gender,"") & male==1
replace gender="female" if strmatch(gender,"") & male==0
gen labor_type="family"
keep zone state lga sector ea hhid plot_id season gender days labor_type
append using `all_exchange'
foreach i in zone state lga ea hhid {
	merge m:1 `i' gender season using `wage_`i'_median', nogen keep(1 3) 
}
	merge m:1 gender season using `wage_country_median', nogen keep(1 3) //~234 with missing vals b/c they don't have matches on pid

	gen wage=wage_hhid
foreach i in country zone state lga ea {
	replace wage = wage_`i' if obs_`i' > 9
}
egen wage_sd = sd(wage_hhid), by(gender season)
egen mean_wage = mean(wage_hhid), by(gender season)
/* The below code assumes that wages are normally distributed and values below the 0.15th percentile and above the 99.85th percentile are outliers, keeping the median values for the area in those instances.
In reality, what we see is that it trims a significant amount of right skew - the max value is 14 stdevs above the mean while the min is only 1.15 below. 
*/
replace wage=wage_hhid if wage_hhid !=. & abs(wage_hhid-mean_wage)/wage_sd <3 

gen val = wage*days
append using `all_hired'
keep zone state lga sector ea hhid plot_id season days val labor_type gender number
drop if val==.&days==.
merge m:1 plot_id hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_decision_makers", nogen keep(3) keepusing(dm_gender) //2 not matched from master (household is registered as moved)
collapse (sum) number val days, by(hhid plot_id season labor_type gender dm_gender) //this is a little confusing, but we need "gender" and "number" for the agwage file.
	la var gender "Gender of worker"
	la var dm_gender "Plot manager gender"
	la var labor_type "Hired, exchange, or family labor"
	la var days "Number of person-days per plot"
	la var val "Total value of hired labor (Naira)"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_labor_long.dta",replace
preserve
	collapse (sum) labor_=days, by (hhid plot_id labor_type)
	reshape wide labor_, i(hhid plot_id) j(labor_type) string
		la var labor_family "Number of family person-days spent on plot, all seasons"
		la var labor_nonhired "Number of exchange (free) person-days spent on plot, all seasons"
		la var labor_hired "Number of hired labor person-days spent on plot, all seasons"
	save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_labor_days.dta",replace //AgQuery
restore
//At this point all code below is legacy; we could cut it with some changes to how the summary stats get processed.
preserve
	gen exp="exp" if strmatch(labor_type,"hired")
	replace exp="imp" if strmatch(exp,"")
	append using `inkind_payments'
	collapse (sum) val, by(hhid plot_id exp dm_gender)
	gen input="labor"
	save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_labor.dta", replace //this gets used below.
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
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_cost_labor.dta", replace

	******************************************************
	* CHEMICALS, FERTILIZER, LAND, ANIMALS, AND MACHINES *
	******************************************************

	*** Pesticides/Herbicides/Animals/Machines
use "${Nigeria_GHS_W2_raw_data}/sect11c2_plantingW2.dta", clear
ren plotid plot_id
ren s11c2q2a qtypestexp
ren s11c2q2b unitpestexp
ren s11c2q4a valpestexp1
ren s11c2q4b valpestexp2
ren s11c2q5a valpestexp3
ren s11c2q5b valpestexp4
egen valpestexp=rowtotal(valpestexp*)

ren s11c2q7a qtypestimp
ren s11c2q7b unitpestimp

ren s11c2q11a qtyherbexp
ren s11c2q11b unitherbexp
ren s11c2q13a valherbexp1
ren s11c2q13b valherbexp2
ren s11c2q14a valherbexp3
ren s11c2q14b valherbexp4
egen valherbexp = rowtotal(valherbexp*)

ren s11c2q16a qtyherbimp
ren s11c2q16b unitherbimp

foreach i in herbexp pestexp herbimp pestimp {
	replace qty`i'=qty`i'/1000 if unit`i'==2 & qty`i'>9 //Many people reporting 1-5 grams of pesticide/herbicide on their plot - assuming this is likely a typo (and values bear this out)
	replace unit`i'=1 if unit`i'==2
	replace qty`i'=qty`i'/100 if unit`i'==4 & qty`i'>9
	replace unit`i'=3 if unit`i'==4
}

*NOTE: Assuming 0.5 acres per day (https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4635562/ says a pair of draft cattle can plow 1 acre in about 2.2 days, at 4.3 hours per day)
*ALT 05.05.21 To keep this consistent with everything else and to produce a valuation for own animals used, I'm changing this to per-day cost
ren s11c2q21 qtyanmlexp
gen valanmlexp1=0
replace valanmlexp1 = s11c2q23a if s11c2q23b==6		// full planting period
replace valanmlexp1 = s11c2q23a*5*qtyanmlexp if s11c2q23b==1				// ASSUME FIVE HOURS PER DAY: payment times number of days times 5 if unit is payment per hour
replace valanmlexp1 = s11c2q23a*qtyanmlexp if s11c2q23b==2					// payment times number of days if unit is payment per day
replace valanmlexp1 = s11c2q23a*0.5*qtyanmlexp if s11c2q23b==4				// acres times 0.5 to put payment into days. then times days (e.g. if you hired for one day but paid "per acre" and they did half an acre, you pay half of the "per acre" price)
replace valanmlexp1 = s11c2q23a*qtyanmlexp*(0.5/2.47105) if s11c2q23b==5	// hectares times 2.47105 for acres, then acres times 0.5 to put payment into days. then times days (e.g. if you hired for one day but paid "per hectare" and they did half an acre, you pay (0.5/2.47105)~0.202 of the "per hectare" price)
replace valanmlexp1 = s11c2q23a/8*qtyanmlexp if s11c2q23c=="8 Days"			// "Other" unit: payment divided by 8 times number of days if reported as "8 days"

gen valanmlexp2 = 0
replace valanmlexp2 = s11c2q24a if s11c2q24b==6		// full planting period
replace valanmlexp2 = s11c2q24a*5*qtyanmlexp if s11c2q24b==1		// ASSUME FIVE HOURS PER DAY: payment times number of days times 5 if unit is payment per hour
replace valanmlexp2 = s11c2q24a*qtyanmlexp if s11c2q24b==2		// payment times number of days if unit is payment per day

gen valanmlexp = valanmlexp1+valanmlexp2
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
gen valmechexp=s11c2q32+s11c2q33
gen qtymechexp=valmechexp!=.
gen unitmechexp=0
//More dummies

drop *exp1 *exp2 *exp3 *exp4
//Now to reshape long and get all the medians at once.
keep zone state lga sector ea hhid plot_id qty* val* unit*
unab vars : *exp
local stubs : subinstr local vars "exp" "", all
reshape long `stubs', i(zone state lga sector ea hhid plot_id) j(exp) string
reshape long val qty unit, i(zone state lga sector ea hhid plot_id exp) j(input) string
gen itemcode=1
tempfile plot_inputs
save `plot_inputs'

	***Fertilizer
use "${Nigeria_GHS_W2_raw_data}/sect11d_plantingW2.dta", clear

//Prices for imp inputs
ren plotid plot_id
ren s11dq15 itemcodefertexp1
ren s11dq16 qtyfertexp1
//ren s11dq16b unitfertexp1 all in Kg
ren s11dq19 valfertexp1
ren s11dq27 itemcodefertexp2
ren s11dq28 qtyfertexp2
//ren s11dq28b unitfertexp2
ren s11dq29 valfertexp2

//Leftover fertilizer
ren s11dq3 itemcodefertimp1
ren s11dq4 qtyfertimp1
//ren s11dq4b unitfertimp1
ren s11dq7 itemcodefertimp2
ren s11dq8 qtyfertimp2

ren s11dq10 valtransfertexp1 //All transportation costs are explicit
ren s11dq17 valtransfertexp2
ren s11dq31 valtransfertexp3
//ren s11dq41 valtransfertexp4 

//ALT: 3 obs with OS, two are manure and one is 20-10-10
replace itemcodefertimp2 = 3 if s11dq7b!=""
replace itemcodefertimp2 = 1 if s11dq7b=="201010"

keep item* qty* val* zone state lga ea sector hhid plot_id
gen dummya=_n //Stata requires all lines in a reshape to be uniquely identifiable, even though that is not necessary for what we're doing here. Hence this dummy variable.
unab vars : *2
local stubs : subinstr local vars "2" "", all
reshape long `stubs', i(zone state lga ea hhid sector plot_id dummya) j(entry_no)
drop entry_no
unab vars2 : *exp
local stubs2 : subinstr local vars2 "exp" "", all
drop if (itemcodefertexp==. & itemcodefertimp==.)
replace dummya = _n
reshape long `stubs2', i(zone state lga ea sector hhid plot_id dummya) j(exp) string
replace dummya = _n
reshape long qty val itemcode, i(zone state lga ea hhid sector plot_id exp dummya) j(input) string
gen unit = 1 if strmatch(input, "fert")
recode qty val (.=0)
collapse (sum) qty* val*, by(zone state ea lga sector hhid plot_id exp input itemcode)
tempfile phys_inputs
save `phys_inputs'

//Get area planted first
use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_all_plots.dta",clear
collapse (sum) ha_planted, by(hhid plot_id)
tempfile planted_area
save `planted_area' 

use "${Nigeria_GHS_W2_raw_data}/secta3_harvestW2.dta", clear //Including sharecrops as rental expenses 
ren cropcode crop_code 
ren plotid plot_id
ren sa3q8a qty
ren sa3q8b unit
merge m:1 hhid crop_code unit using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_crop_prices_for_wages.dta", keep(1 3) nogen
gen val_sharecrop = qty*hh_price_mean 
//Only 26 obs with nonzero sharecrop vals.
recode val_sharecrop (.=0)
collapse (sum) val_sharecrop, by(hhid plot_id)
tempfile sharecrop_vals
save `sharecrop_vals'

use "${Nigeria_GHS_W2_raw_data}/sect11b1_plantingW2.dta", clear
ren plotid plot_id
ren s11b1q27 cultivate
merge 1:1 hhid plot_id using `sharecrop_vals', nogen
egen valplotrentexp=rowtotal(s11b1q13 s11b1q14 val_sharecrop)
merge 1:1 plot_id hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_areas", nogen keep(1 3) keepusing(field_size)
merge 1:1 plot_id hhid using `planted_area'
gen qtyplotrentexp=field_size if valplotrentexp>0 & valplotrentexp!=.
replace qtyplotrentexp=ha_planted if qtyplotrentexp==. & valplotrentexp>0 & valplotrentexp!=. //as in quantity of land rented
gen qtyplotrentimp = field_size if qtyplotrentexp==.
replace qtyplotrentimp = ha_planted if qtyplotrentimp==. & qtyplotrentexp==.
keep if cultivate==1 //No need for uncultivated plots
keep zone state lga ea sector hhid plot_id valplotrent* qtyplotrent* 
reshape long valplotrent qtyplotrent, i(zone state lga ea sector hhid plot_id) j(exp) string
reshape long val qty, i(zone state lga ea sector hhid plot_id exp) j(input) string
gen unit=1 //dummy var
gen itemcode=1 //dummy var
tempfile plotrents
save `plotrents'

use "${Nigeria_GHS_W2_raw_data}/sect11e_plantingW2.dta", clear
//Issues with alternative crop codes here - not sure how much trouble the shelled vs unshelled issue really is, but we only have conversions for the generic crop levels in this wave.

ren plotid plot_id
ren s11eq5 itemcodeseedsimp1
ren s11eq6a qtyseedsimp1
ren s11eq6b unitseedsimp1

ren s11eq9 itemcodeseedsimp2
ren s11eq10a qtyseedsimp2
ren s11eq10b unitseedsimp2

ren s11eq12 valseedtransexp1 //all transportation is explicit
ren s11eq17 itemcodeseedsexp1
ren s11eq18a qtyseedsexp1
ren s11eq18b unitseedsexp1
ren s11eq19 valseedtransexp2
ren s11eq21 valseedsexp1
ren s11eq29 itemcodeseedsexp2
ren s11eq30a qtyseedsexp2
ren s11eq30b unitseedsexp2
ren s11eq31 valseedtransexp3
ren s11eq33 valseedsexp2

keep item* qty* unit* val* zone state lga ea sector hhid plot_id
gen dummya=_n //dummy id for duplicates
unab vars : *1
local stubs : subinstr local vars "1" "", all
reshape long `stubs', i(zone state lga ea hhid sector plot_id dummya) j(entry_no)
drop entry_no
replace dummya=_n
unab vars2 : *exp
local stubs2 : subinstr local vars2 "exp" "", all
drop if qtyseedsexp==. & valseedsexp==.
reshape long `stubs2', i(zone state lga ea sector hhid plot_id dummya) j(exp) string
replace dummya = _n
reshape long qty unit val itemcode, i(zone state lga ea hhid sector plot_id exp dummya) j(input) string
drop if strmatch(exp,"imp") & strmatch(input,"seedtrans") //No implicit transportation costs
recode itemcode (1053=1050) (1061 1062 = 1060) (1081 1082=1080) (1091 1092 1093 = 1090) (1111=1110) (2191 2192 2193=2190) (3181 3182 3183 3184 = 3180) (2170=2030) /*
*/ 				(3113 3112 3111 = 3110) (3022=3020) (2142 2141 = 2140) /*(1121 1122 1123 1124=1120)*/
collapse (sum) val qty, by(zone state lga ea hhid sector plot_id unit itemcode exp input)
ren itemcode crop_code
ren unit unit_cd
drop if crop_code==. & strmatch(input,"seeds")
replace unit_cd = 31 if unit_cd==32 //Both large mudu, not sure where the surplus unit code came from.

merge m:1 crop_code unit_cd using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_ng3_cf.dta", nogen keep(1 3)
//The problem is that not all of these are seeds (see w4) and so some of the conversions are probably off.
ren conv_fact conversion
replace conversion = 10 if crop_code==1020 & inrange(unit_cd,160,162) //10 stems per bundle, regardless of size
replace conversion = 1 if inrange(unit_cd,80,82) | (unit_cd==1 & conversion==.) //pieces //why there are kgs not converted at this point is beyond my ken. 
gen unit=1 if inlist(unit_cd,160,161,162,80,81,82) //pieces
replace unit=2 if unit==. //Weight, meaningless for transportation
replace unit=0 if conversion==. //useless for price calculations
replace qty=qty*conversion if conversion!=.
ren crop_code itemcode
recode val (.=0)
collapse (sum) val qty, by(zone state lga ea hhid sector plot_id exp input itemcode unit) //Eventually, quantity won't matter for things we don't have units for.
//Combining and getting prices.
append using `plotrents'
append using `plot_inputs'
append using `phys_inputs'
merge m:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_weights.dta",nogen keep(1 3) keepusing(weight_pop_rururb)
merge m:1 hhid plot_id using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_areas.dta", nogen keep(1 3) keepusing(field_size)
merge m:1 hhid plot_id using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_decision_makers",nogen keep(1 3) keepusing(dm_gender)
tempfile all_plot_inputs
save `all_plot_inputs' //Woo, now we have 81k unique entries and can estimate vals.

keep if strmatch(exp,"exp") & qty!=. //Now for geographic medians
gen plotweight = weight*field_size
recode val (0=.)
drop if unit==0 //Remove things with unknown units.
gen price = val/qty
drop if price==.
gen obs=1

foreach i in zone state lga ea hhid {
preserve
	bys `i' input unit itemcode : egen obs_`i' = sum(obs)
	collapse (median) price_`i'=price [aw=plotweight], by (`i' input unit itemcode obs_`i')
	tempfile price_`i'_median
	save `price_`i'_median'
restore
}

preserve
bys input unit itemcode : egen obs_country = sum(obs)
collapse (median) price_country = price [aw=plotweight], by(input unit itemcode obs_country)
tempfile price_country_median
save `price_country_median'
restore

use `all_plot_inputs',clear
foreach i in zone state lga ea hhid {
	merge m:1 `i' input unit itemcode using `price_`i'_median', nogen keep(1 3) 
}
	merge m:1 input unit itemcode using `price_country_median', nogen keep(1 3)
	recode price_hhid (.=0)
	gen price=price_hhid
foreach i in country zone state lga ea {
	replace price = price_`i' if obs_`i' > 9 & obs_`i'!=.
}
//Default to household prices when available
replace price = price_hhid if price_hhid>0
replace qty = 0 if qty <0 //4 households reporting negative quantities of fertilizer.
recode val qty (.=0)
drop if val==0 & qty==0 //Dropping unnecessary observations.
replace val=qty*price if val==0
**# Bookmark #1 
replace input = "orgfert" if itemcode==3 //ALT 06.29.23: Error, previously this was 5 to conform to wave 4; here the code is 3
replace input = "inorg" if strmatch(input,"fert")
preserve
	//Need this for quantities and not sure where it should go.
	keep if /*strmatch(input,"orgfert") |*/ strmatch(input,"inorg") | strmatch(input,"herb") | strmatch(input,"pest")
	//Unfortunately we have to compress liters and kg here, which isn't ideal.
	collapse (sum) qty_=qty, by(hhid plot_id input)
	reshape wide qty_, i(hhid plot_id) j(input) string
	ren qty_inorg inorg_fert_rate
	//ren qty_orgfert org_fert_rate
	ren qty_herb herb_rate
	ren qty_pest pest_rate
	la var inorg_fert_rate "Qty inorganic fertilizer used (kg)"
	//la var org_fert_rate "Qty organic fertilizer used (kg)"
	la var herb_rate "Qty of herbicide used (kg/L)"
	la var pest_rate "Qty of pesticide used (kg/L)"
	save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_input_quantities.dta", replace
restore
append using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_labor.dta"
collapse (sum) val, by (hhid plot_id exp input dm_gender)

save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_cost_inputs_long.dta",replace //Used for agQuery
preserve
collapse (sum) val, by(hhid exp input) 
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_cost_inputs_long.dta", replace //ALT 02.07.2022: Holdover from W4.
restore
preserve
	collapse (sum) val_=val, by(hhid plot_id exp dm_gender)
	reshape wide val_, i(hhid plot_id dm_gender) j(exp) string
	save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_cost_inputs.dta", replace //This gets used below.
restore
	
//This version of the code retains identities for all inputs; not strictly necessary for later analyses.
ren val val_ 
reshape wide val_, i(hhid plot_id exp dm_gender) j(input) string
ren val* val*_
reshape wide val*, i(hhid plot_id dm_gender) j(exp) string
drop if dm_gender==. //One empty row for some reason.
gen dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
drop dm_gender
ren val* val*_
reshape wide val*, i(hhid plot_id) j(dm_gender2) string
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_cost_inputs_wide.dta", replace //Used for monocrop plots
collapse (sum) val*, by(hhid)

unab vars3 : *_exp_male //just get stubs from one
local stubs3 : subinstr local vars3 "_exp_male" "", all
foreach i in `stubs3' {
	egen `i'_exp_hh = rowtotal(`i'_exp_male `i'_exp_female `i'_exp_mixed)
	egen `i'_imp_hh=rowtotal(`i'_exp_hh `i'_imp_male `i'_imp_female `i'_imp_mixed)
}
egen val_exp_hh=rowtotal(*_exp_hh)
egen val_imp_hh=rowtotal(*_imp_hh)
drop val_mech_imp* val_seedtrans_imp* val_transfert_imp* val_feedanml_imp* //Not going to have any data
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_cost_inputs_verbose.dta", replace


//We can do this more simply by:
use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_cost_inputs_long.dta", clear
//back to wide
drop input
collapse (sum) val, by(hhid plot_id exp dm_gender)
drop if dm_gender==. //One empty row for some reason.
gen dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
drop dm_gender
ren val* val*_
reshape wide val*, i(hhid plot_id dm_gender2) j(exp) string
ren val* val*_
merge 1:1 hhid plot_id using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_areas.dta", nogen keep(1 3) keepusing(field_size) //do per-ha expenses at the same time
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
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_cost_inputs.dta", replace

********************************************************************************
* MONOCROPPED PLOTS *
********************************************************************************

//Setting things up for AgQuery first
use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_all_plots.dta", clear
	keep if purestand==1 & relay!=1 //For now, omitting relay crops.
	ren crop_code_master cropcode
	//merge 1:1 hhid plot_id using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_cost_inputs.dta", nogen keep(1 3)
	/*Easy way, starting from previous line
	merge 1:1 hhid plot_id using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_cost_inputs_wide.dta", nogen keep(1 3) //If we want to keep identities of all inputs
	merge m:1 cropcode using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_cropname_table.dta", nogen keep(3) //Filter down to crops we have names for.
	local listvars = "firstvar-lastvar" //Note to look this up
	foreach i in `listvars' {
		ren `i' `i'_
	}
	gen grew_ = 1 //Only plots where <cropname> was grown are here
	reshape wide *_, i(hhid cropcode) j(cropname)
	recode grew_* (.=0)
	//ALT note that the nomenclature here will be different than is standard in these files, but this is quicker and, I think, easier than the way we currently do it (one file to merge in at the end instead of several). I'm not using these files for agquery.
*/
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_monocrop_plots.dta", replace


use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_all_plots.dta", clear
	keep if purestand==1 & relay!=1 //For now, omitting relay crops.
	//File now has 2550 unique entries after omitting the crops that were "replaced" - it should be noted that some these were grown in mixed plots and only one crop was lost. Which is confusing.
	merge 1:1 hhid plot_id using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
	ren crop_code_master cropcode
	ren ha_planted monocrop_ha
	ren quant_harv_kg kgs_harv_mono
	ren value_harvest val_harv_mono

forvalues k=1(1)$nb_topcrops  {		
preserve	
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	local cn_full : word `k' of $topcropname_area_full
	keep if cropcode==`c'			
	ren monocrop_ha `cn'_monocrop_ha 
	drop if `cn'_monocrop_ha==0 |  `cn'_monocrop_ha==.	
	ren kgs_harv_mono kgs_harv_mono_`cn'
	ren val_harv_mono val_harv_mono_`cn'
	gen `cn'_monocrop=1
	la var `cn'_monocrop "HH grows `cn_full' on a monocropped plot"
	drop if dm_gender==.
	save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_`cn'_monocrop.dta", replace
	
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
	save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_`cn'_monocrop_hh_area.dta", replace
restore
}

use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_cost_inputs_long.dta", clear
foreach cn in $topcropname_area {
preserve
	keep if strmatch(exp, "exp")
	drop exp
	levelsof input, clean l(input_names)
	ren val val_
	reshape wide val_, i(hhid plot_id dm_gender) j(input) string
	ren val* val*_`cn'_
	drop if dm_gender==.
	gen dm_gender2 = "male" if dm_gender==1
	replace dm_gender2 = "female" if dm_gender==2
	replace dm_gender2 = "mixed" if dm_gender==3
	drop dm_gender
	reshape wide val*, i(hhid plot_id) j(dm_gender2) string
	merge 1:1 hhid plot_id using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_`cn'_monocrop.dta", nogen keep(3)
	collapse (sum) val*, by(hhid)
	foreach i in `input_names' {
		egen val_`i'_`cn'_hh = rowtotal(val_`i'_`cn'_male val_`i'_`cn'_female val_`i'_`cn'_mixed)
	}
	//To do: labels
	save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_inputs_`cn'.dta", replace
restore
}


********************************************************************************
*TLU (Tropical Livestock Units)
********************************************************************************

use "${Nigeria_GHS_W2_raw_data}/sect11i_plantingw2.dta", clear
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
gen smallrum=inlist(lvstckid,110,  111, 119,  120)
gen largerum = inlist(lvstckid,101,102,103,104,105,106,107) // HKS 6.16.23
gen poultry=inrange(lvstckid,113,118)
gen other_ls=inlist(lvstckid,108,109, 121, 122, 123)
gen cows=inrange(lvstckid,105,105)
gen chickens=inrange(lvstckid,113,116)
ren s11iq6 nb_ls_stardseas
gen nb_cattle_stardseas=nb_ls_stardseas if cattle==1 
gen nb_smallrum_stardseas=nb_ls_stardseas if smallrum==1 
gen nb_poultry_stardseas=nb_ls_stardseas if poultry==1 
gen nb_other_ls_stardseas=nb_ls_stardseas if other_ls==1 
gen nb_cows_stardseas=nb_ls_stardseas if cows==1 
gen nb_chickens_stardseas=nb_ls_stardseas if chickens==1 
gen nb_ls_today =s11iq2
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
*save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_TLU_Coefficients.dta", replace
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_TLU_Coefficients_wlargerum_061623.dta", replace // HKS 6.16.23


********************************************************************************
* LIVESTOCK INCOME *
********************************************************************************
*Expenses
use "${Nigeria_GHS_W2_raw_data}/sect11j_plantingw2.dta", clear
ren s11jq2a cost_cash
ren s11jq2b cost_inkind
recode cost_cash cost_inkind (.=0)
gen cost_hired_labor_livestock = (cost_cash + cost_inkind) if item_cd==1 | item_cd==4
gen cost_fodder_livestock = (cost_cash + cost_inkind) if item_cd==2
gen cost_vaccines_livestock = (cost_cash + cost_inkind) if item_cd==3 /* Includes treatment */
**cannot dissaggregate costs by livestock species
gen cost_other_livestock = (cost_cash + cost_inkind) if item_cd>=5 & item_cd<=9
recode cost_hired_labor_livestock cost_fodder_livestock cost_vaccines_livestock cost_other_livestock (.=0)
collapse (sum) cost_hired_labor_livestock cost_fodder_livestock cost_vaccines_livestock cost_other_livestock, by (hhid)
lab var cost_fodder_livestock "Cost for fodder for livestock"
lab var cost_vaccines_livestock "Cost for vaccines and veterminary treatment for livestock"
lab var cost_hired_labor_livestock "Cost for hired labor for livestock"
lab var cost_other_livestock "Cost for any other expenses for livestock"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_livestock_expenses.dta", replace

use "${Nigeria_GHS_W2_raw_data}/sect11k_plantingw2.dta", clear
ren prod_cd livestock_code
ren s11kq2 months_produced
ren s11kq3a quantity_produced
ren s11kq3b quantity_produced_unit /* 1 "Other" = crate */
ren s11kq5a quantity_sold_season
ren s11kq5b quantity_sold_season_unit
ren s11kq6 earnings_sales
recode quantity_produced quantity_sold_season months_produced (.=0)
gen price_unit = earnings_sales / quantity_sold_season
recode price_unit (0=.)
bys livestock_code: count if quantity_sold_season !=0
keep hhid livestock_code months_produced quantity_produced quantity_produced_unit quantity_sold_season quantity_sold_season_unit earnings_sales price_unit
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_livestock_products.dta", replace

use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_livestock_products", clear
merge m:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_weights.dta"
drop if _merge==2
collapse (median) price_unit [aw=weight_pop_rururb], by (livestock_code quantity_sold_season_unit)
ren price_unit price_unit_median_country
ren quantity_sold_season_unit unit
replace price_unit_median_country = 100 if livestock_code == 1 & unit==1 /* 1 kg per liter */
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_livestock_products_prices_country.dta", replace

use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_livestock_products", clear
replace quantity_produced_unit = 16 if livestock_code==2 & (quantity_produced_unit==91 | quantity_produced_unit==15 | quantity_produced_unit==12 | quantity_produced_unit==11 /*
*/ | quantity_produced_unit==10 | quantity_produced_unit==8 | quantity_produced_unit==2 | quantity_produced_unit==1)
replace quantity_produced_unit = 3 if livestock_code==1 & (quantity_produced_unit==2 | quantity_produced_unit==8)
gen unit = quantity_produced_unit 
merge m:1 livestock_code unit using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_livestock_products_prices_country.dta", nogen keep(1 3) 
keep if quantity_produced!=0
gen value_produced = price_unit * quantity_produced * months_produced if quantity_produced_unit == quantity_sold_season_unit
replace value_produced = price_unit_median_country * quantity_produced * months_produced if value_produced==.
replace value_produced = earnings_sales if value_produced==.
lab var price_unit "Price per liter (milk) or per egg/liter/container honey or palm wine, imputed with local median prices if household did not sell"
gen value_milk_produced = quantity_produced * price_unit * months_produced if livestock_code==1
replace value_milk_produced = quantity_produced * price_unit_median_country * months_produced if livestock_code==1 & value_milk_produced==.
gen value_eggs_produced = quantity_produced * price_unit * months_produced if livestock_code==2
replace value_eggs_produced = quantity_produced * price_unit_median_country * months_produced if livestock_code==2 & value_eggs_produced==.
gen value_other_produced = quantity_produced * price_unit * months_produced if livestock_code!=1 & livestock_code!=2
*Share of total production sold
gen sales_livestock_products = earnings_sales	
/*Agquery 12.01*/
//No way to limit this to just cows and chickens b/c the actual livestock code is missing.
gen sales_milk = earnings_sales if livestock_code==1
gen sales_eggs = earnings_sales if livestock_code==2
collapse (sum) value_milk_produced value_eggs_produced value_other_produced sales_livestock_products /*agquery*/ sales_milk sales_eggs, by (hhid)
*Constructing total value
egen value_livestock_products = rowtotal(value_milk_produced value_eggs_produced value_other_produced)
*Construct share
gen share_livestock_prod_sold = sales_livestock_products/value_livestock_products
/*AgQuery 12.01*/
gen prop_dairy_sold = sales_milk / value_milk_produced
gen prop_eggs_sold = sales_eggs / value_eggs_produced
**
replace share_livestock_prod_sold = 1 if share_livestock_prod_sold>1 & share_livestock_prod_sold!=.
lab var share_livestock_prod_sold "Percent of production of livestock products that is sold" 
lab var value_milk_produced "Value of milk produced"
lab var value_eggs_produced "Value of eggs produced"
lab var value_other_produced "Value of honey and skins produced"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_livestock_products.dta", replace

*Sales (live animals)
use "${Nigeria_GHS_W2_raw_data}/sect11i_plantingw2.dta", clear
ren animal_cd livestock_code 
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
merge m:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_weights.dta", nogen keep(1 3) 
keep if price_per_animal !=. & price_per_animal!=0
keep hhid weight_pop_rururb zone state lga ea livestock_code number_sold income_live_sales number_slaughtered number_slaughtered_sold price_per_animal value_livestock_purchases
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_livestock_sales", replace

*Implicit prices (based on observed sales)
use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_livestock_sales", clear
gen observation = 1
bys zone state lga ea livestock_code: egen obs_ea = count(observation)
collapse (median) price_per_animal [aw=weight_pop_rururb], by (zone state lga ea livestock_code obs_ea)
ren price_per_animal price_median_ea
lab var price_median_ea "Median price per unit for this livestock in the ea"
lab var obs_ea "Number of sales observations for this livestock in the ea"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_livestock_prices_ea.dta", replace
use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_livestock_sales", clear
gen observation = 1
bys zone state lga livestock_code: egen obs_lga = count(observation)
collapse (median) price_per_animal [aw=weight_pop_rururb], by (zone state lga livestock_code obs_lga)
ren price_per_animal price_median_lga
lab var price_median_lga "Median price per unit for this livestock in the lga"
lab var obs_lga "Number of sales observations for this livestock in the lga"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_livestock_prices_lga.dta", replace
use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_livestock_sales", clear
gen observation = 1
bys zone state livestock_code: egen obs_state = count(observation)
collapse (median) price_per_animal [aw=weight_pop_rururb], by (zone state livestock_code obs_state)
ren price_per_animal price_median_state
lab var price_median_state "Median price per unit for this livestock in the state"
lab var obs_state "Number of sales observations for this livestock in the state"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_livestock_prices_state.dta", replace
use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_livestock_sales", clear
gen observation = 1
bys zone livestock_code: egen obs_zone = count(observation)
collapse (median) price_per_animal [aw=weight_pop_rururb], by (zone livestock_code obs_zone)
ren price_per_animal price_median_zone
lab var price_median_zone "Median price per unit for this livestock in the zone"
lab var obs_zone "Number of sales observations for this livestock in the zone"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_livestock_prices_zone.dta", replace
use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_livestock_sales", clear
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_animal [aw=weight_pop_rururb], by (livestock_code obs_country)
ren price_per_animal price_median_country
lab var price_median_country "Median price per unit for this livestock in the country"
lab var obs_country "Number of sales observations for this livestock in the country"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_livestock_prices_country.dta", replace

use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_livestock_sales", clear
merge m:1 zone state lga ea livestock_code using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_livestock_prices_ea.dta", nogen 
merge m:1 zone state lga livestock_code using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_livestock_prices_lga.dta", nogen 
merge m:1 zone state livestock_code using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_livestock_prices_state.dta", nogen 
merge m:1 zone livestock_code using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_livestock_prices_zone.dta", nogen 
merge m:1 livestock_code using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_livestock_prices_country.dta", nogen 
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
collapse (sum) value_livestock_sales value_livestock_purchases value_lvstck_sold value_slaughtered value_slaughtered_sold, by (hhid)
lab var value_livestock_sales "Value of livestock sold (live and slaughtered)"
lab var value_livestock_purchases "Value of livestock purchases (seems to span only the agricutlural season, not the year)"
lab var value_slaughtered "Value of livestock slaughtered (with slaughtered livestock that weren't sold valued at local median prices for live animal sales)"
lab var value_lvstck_sold "Value of livestock sold live" 
/* AgQuery 12.01*/ gen prop_meat_sold = value_slaughtered_sold/value_slaughtered 
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_livestock_sales.dta", replace

*TLU (Tropical Livestock Units)
use "${Nigeria_GHS_W2_raw_data}/sect11i_plantingw2.dta", clear
gen tlu=0.5 if (animal_cd==101|animal_cd==102|animal_cd==103|animal_cd==104|animal_cd==105|animal_cd==106|animal_cd==107|animal_cd==109)
replace tlu=0.3 if (animal_cd==108)
replace tlu=0.1 if (animal_cd==110|animal_cd==111)
replace tlu=0.2 if (animal_cd==112)
replace tlu=0.01 if (animal_cd==113|animal_cd==114|animal_cd==115|animal_cd==116|animal_cd==117|animal_cd==118|animal_cd==119|animal_cd==120|animal_cd==121)
replace tlu=0.7 if (animal_cd==122)
lab var tlu "Tropical Livestock Unit coefficient"
ren animal_cd livestock_code
ren tlu tlu_coefficient
ren s11iq2 number_today 
ren s11iq3 price_per_animal_est /* Estimated by the respondent */
ren s11iq6 number_start_agseason 
gen tlu_start_agseason = number_start_agseason * tlu_coefficient
gen tlu_today = number_today * tlu_coefficient
ren s11iq16 number_sold 
ren s11iq17 income_live_sales 
gen lost_disease = s11iq21b + s11iq21d
*Livestock mortality rate and percent of improved livestock breeds
egen mean_agseas = rowmean(number_today number_start_agseas)
egen animals_lost_agseas = rowtotal(s11iq21b s11iq21d)	// Only animals lost to disease, thefts and death by accidents not included
gen species = (inlist(livestock_code,101,102,103,104,105,106,107)) + 2*(inlist(livestock_code,110,111)) + 3*(livestock_code==112) + 4*(inlist(livestock_code,108,109,122)) + 5*(inlist(livestock_code,113,114,115,116,117,118,120))
recode species (0=.)
la def species 1 "Large ruminants (cows, buffalos)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses, donkeys, camel)" 5 "Poultry"
la val species specieses
preserve
*Now to household level
*First, generating these values by species
collapse (sum) number_today number_start_agseas animals_lost_agseas lost_disease lvstck_holding=number_today, by(hhid species)
egen mean_agseas = rowmean(number_today number_start_agseas)
*A loop to create species variables
foreach i in animals_lost_agseas mean_agseas lvstck_holding lost_disease{
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==2
	gen `i'_pigs = `i' if species==3
	gen `i'_equine = `i' if species==4
	gen `i'_poultry = `i' if species==5
}
*Now we can collapse to household (taking firstnm because these variables are only defined once per household)
collapse (sum) number_today  (firstnm) *lrum *srum *pigs *equine *poultry , by(hhid)
*Overall any improved herd
drop  number_today
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
}
*Total livestock holding for large ruminants, small ruminants, and poultry
gen lvstck_holding_all = lvstck_holding_lrum + lvstck_holding_srum + lvstck_holding_poultry
la var lvstck_holding_all "Total number of livestock holdings (# of animals) - large ruminants, small ruminants, poultry"

recode lvstck_holding* (.=0)

drop lvstck_holding animals_lost_agseas mean_agseas lost_disease
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_herd_characteristics", replace
restore

gen price_per_animal = income_live_sales / number_sold
recode price_per_animal (0=.)
merge m:1 zone state lga ea livestock_code using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_livestock_prices_ea.dta", nogen 
merge m:1 zone state lga livestock_code using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_livestock_prices_lga.dta", nogen 
merge m:1 zone state livestock_code using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_livestock_prices_state.dta", nogen 
merge m:1 zone livestock_code using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_livestock_prices_zone.dta", nogen 
merge m:1 livestock_code using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_livestock_prices_country.dta", nogen 
replace price_per_animal = price_median_ea if price_per_animal==. & obs_ea >= 10
replace price_per_animal = price_median_lga if price_per_animal==. & obs_lga >= 10
replace price_per_animal = price_median_state if price_per_animal==. & obs_state >= 10
replace price_per_animal = price_median_zone if price_per_animal==. & obs_zone >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_start_agseason = number_start_agseason * price_per_animal
gen value_today = number_today * price_per_animal
gen value_today_est = number_today * price_per_animal_est
collapse (sum) tlu_start_agseason tlu_today value_start_agseason value_today value_today_est, by (hhid)
lab var tlu_start_agseason "Tropical Livestock Units as of the start of the agricultural season"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
gen lvstck_holding_tlu = tlu_today
lab var lvstck_holding_tlu "Total HH livestock holdings, TLU"  
lab var value_start_agseason "Value of livestock holdings from one year ago"
lab var value_today "Value of livestock holdings today"
lab var value_today_est "Value of livestock holdings today, per estimates (not observed sales)"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_TLU.dta", replace


********************************************************************************
* FISH INCOME *
********************************************************************************
use "${Nigeria_GHS_W2_raw_data}/secta9a2_harvestw2.dta", clear
ren fish_cd fish_code
ren sa9aq5b unit
ren sa9aq6 price_per_unit
recode price_per_unit (0=.)
merge m:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_weights.dta"
drop if _merge==2
collapse (median) price_per_unit [aw=weight_pop_rururb], by (fish_code unit)
ren price_per_unit price_per_unit_median
replace price_per_unit_median = . if fish_code==5 /* "Other */
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_fish_prices_1.dta", replace /* Caught fish */

use "${Nigeria_GHS_W2_raw_data}/secta9a2_harvestw2.dta", clear
ren fish_cd fish_code
ren sa9aq7b unit
ren sa9aq8 price_per_unit
recode price_per_unit (0=.)
merge m:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_weights.dta"
drop if _merge==2
collapse (median) price_per_unit [aw=weight_pop_rururb], by (fish_code unit)
ren price_per_unit price_per_unit_median
replace price_per_unit_median = . if fish_code==5 /* "Other */
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_fish_prices_2.dta", replace /* Harvested fish */

use "${Nigeria_GHS_W2_raw_data}/secta9a2_harvestw2.dta", clear
keep if sa9aq2==1
ren fish_cd fish_code
ren sa9aq3 weeks_fishing
ren sa9aq4a1 quantity_caught /* on average per week */
ren sa9aq4a2 quantity_caught_unit
ren sa9aq4b1 quantity_harvested /* on average per week */
ren sa9aq4b2 quantity_harvested_unit
ren sa9aq5b sold_unit
ren sa9aq6 price_per_unit
ren sa9aq7b sold_unit_harvested
ren sa9aq8 price_per_unit_harvested
recode quantity_caught quantity_harvested (.=0)
ren quantity_caught_unit unit
merge m:1 fish_code unit using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_fish_prices_1.dta", nogen keep(1 3)
gen value_fish_caught = (quantity_caught * price_per_unit) if unit==sold_unit
replace value_fish_caught = (quantity_caught * price_per_unit_median) if value_fish_caught==.
ren unit quantity_caught_unit 
ren quantity_harvested_unit unit
drop price_per_unit_median
merge m:1 fish_code unit using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_fish_prices_2.dta", nogen keep(1 3)
gen value_fish_harvest = (quantity_harvested * price_per_unit_harvested) if unit==sold_unit_harvested
replace value_fish_harvest = (quantity_harvested * price_per_unit_median) if value_fish_harvest==.
replace value_fish_harvest = (quantity_harvested * (600)) if unit==3 & sold_unit_harvested==. & value_fish_harvest==.
replace value_fish_harvest = value_fish_harvest * weeks_fishing /* Multiply average weekly earnings by number of weeks */
replace value_fish_caught = value_fish_caught * weeks_fishing
recode value_fish_harvest value_fish_caught weeks_fishing (.=0)
collapse (median) value_fish_harvest value_fish_caught (max) weeks_fishing, by (hhid)
lab var value_fish_caught "Value of fish caught over the past 12 months"
lab var value_fish_harvest "Value of fish harvested over the past 12 months"
lab var weeks_fishing "Maximum number weeks fishing for any species"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_fish_income.dta", replace

use "${Nigeria_GHS_W2_raw_data}/secta9b2_harvestw2.dta", clear
ren sa9bq7 rental_costs_day
ren sa9bq6 days_rental
ren sa9bq9 maintenance_costs_per_week
ren sa9bq8 fuel_per_week /* Multiply this by weeks fishing */
recode days_rental rental_costs_day maintenance_costs_per_week (.=0)
gen rental_costs_fishing = rental_costs_day * days_rental
gen fish_expenses_1 = fuel_per_week + maintenance_costs_per_week
collapse (sum) fish_expenses_1, by (hhid)
lab var fish_expenses_1 "Expenses associated with boat rental and maintenance per week" /* This isn't only for rented boats. */
merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_fish_income.dta"
replace fish_expenses_1 = fish_expenses_1 * weeks_fishing
keep hhid fish_expenses_1
lab var fish_expenses_1 "Expenses associated with boat rental and maintenance over the year"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_fishing_expenses_1.dta", replace

use "${Nigeria_GHS_W2_raw_data}/secta9b3_harvestw2.dta", clear
ren sa9bq10a number_men
ren sa9bq10b weeks_men
ren sa9bq11a number_women
ren sa9bq11b weeks_women
ren sa9bq12a number_children
ren sa9bq12b weeks_child
ren sa9bq15a wages_week_man
ren sa9bq15b wages_week_woman
ren sa9bq15c wages_week_child
ren sa9bq19a cash_men
ren sa9bq19b cash_women
ren sa9bq19c cash_child
ren sa9bq22a costs_feed 
ren sa9bq22b costs_irrigation 
ren sa9bq22c costs_maintenance 
ren sa9bq22d costs_fishnets 
ren sa9bq25 costs_other
recode number_men weeks_men number_women weeks_women number_children weeks_child wages_week_man wages_week_woman /*
*/ wages_week_child cash_men cash_women cash_child costs_feed costs_irrigation costs_maintenance costs_fishnets costs_other (.=0)
gen fish_expenses_2 = (number_men * weeks_men * wages_week_man) + (number_women * weeks_women * wages_week_woman) + /*
*/ (number_children * weeks_child * wages_week_child) + (cash_men + cash_women + cash_child) + /*
*/ (costs_feed + costs_irrigation + costs_maintenance + costs_fishnets + costs_other)
keep hhid fish_expenses_2
lab var fish_expenses_2 "Expenses associated with hired labor and fish pond maintenance"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_fishing_expenses_2.dta", replace


********************************************************************************
* SELF-EMPLOYMENT INCOME *
********************************************************************************	
use "${Nigeria_GHS_W2_raw_data}/sect9_harvestw2.dta", clear
ren s9q10 months_activ
recode months_activ (12/max=12)
ren s9q27 monthly_sales
recode monthly_sales (.=0)
gen monthly_profit=monthly_sales
egen monthly_selfemp_cost=rowtotal(s9q28a-s9q28j)
recode monthly_selfemp_cost monthly_sales (.=0)
*DYA 01.13.2020 Assume monthly expenses are zero only if monthly sales are zero
replace monthly_selfemp_cost=0 if monthly_sales==0
gen monthly_selfemp_profit = monthly_sales - monthly_selfemp_cost
gen annual_selfemp_profit = monthly_selfemp_profit * months_activ
recode annual_selfemp_profit (.=0)
collapse (sum) annual_selfemp_profit, by (hhid)
lab var annual_selfemp_profit "Estimated annual net profit from self-employment since last interview"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_self_employment_income.dta", replace

*Sales of processed crops were captured separately.
*Value crop inputs used in the processed products.
use "${Nigeria_GHS_W2_raw_data}/secta3_harvestw2.dta", clear
ren cropname crop_name
ren cropcode crop_code
ren sa3q3 harvest_yesno
ren sa3q6a1 quantity_harvested
ren sa3q6a2 unit_cd
ren sa3q18 value_harvested
ren sa3q11a quantity_sold1
ren sa3q11b unit_quanity_sold1
ren sa3q12 value_sold1
ren sa3q16a quantity_sold2
ren sa3q16b unit_quanity_sold2
ren sa3q17 value_sold2
replace value_harvested = 0 if harvest_yesno==2
replace value_harvested = 0 if value_harvested==. & quantity_harvested == 0
gen total_quantity_sold = quantity_sold1 + quantity_sold1
collapse (sum) value_harvested quantity_harvested, by (hhid crop_code unit_cd)
gen price_per_unit = value_harvested / quantity_harvested
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_crop_unit_values.dta", replace


use "${Nigeria_GHS_W2_raw_data}/secta3_harvestw2.dta", clear
ren cropname crop_name
ren cropcode crop_code
ren sa3q9 sell_processedcrop_yesno
ren sa3q11a quant_processed_crop_sold
ren sa3q11b unit_cd
gen quant_proccrop_sold_unit_other=.
ren sa3q12 value_processed_crop_sold
merge m:1 hhid crop_code unit_cd using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_crop_unit_values.dta", nogen keep(1 3)
merge m:1 crop_code unit_cd using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_crop_prices_median_country.dta", nogen keep(1 3)
gen price_received = value_processed_crop_sold / quant_processed_crop_sold
gen price_as_input = price_per_unit
replace price_as_input = val_unit_country if price_as_input==.
replace price_as_input = price_received if price_as_input > price_received /* Where unit-value of input exceeds the unit-value of processed output, we'll cap the per-unit price at the processed output price */
gen value_crop_input = quant_processed_crop_sold * price_as_input
gen profit_processed_crop_sold = value_processed_crop_sold - value_crop_input
collapse (sum) profit_processed_crop_sold, by (hhid)
lab var profit_processed_crop_sold "Net value of processed crops sold, with crop inputs valued at the unit price for the harvest"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_agproduct_income.dta", replace


/*DYA.10.26.2020 OLD
********************************************************************************
*OFF-FARM HOURS
********************************************************************************
use "${Nigeria_GHS_W2_raw_data}/sect3a_harvestw2.dta", clear
*Start with first wage job; no agriculture (which also includes mining/livestock)
gen primary_hours = s3aq15 if  s3aq11>2 &  s3aq11!=.		// s3q14<2 is ag/mining
gen secondary_hours = s3aq27 if  s3aq23>2 & s3aq23!=.
egen off_farm_hours = rowtotal(primary_hours secondary_hours)
gen off_farm_any_count = off_farm_hours!=0
gen member_count = 1
collapse (sum) off_farm_hours off_farm_any_count member_count, by(hhid)
la var member_count "Number of HH members age 5 or above"
la var off_farm_any_count "Number of HH members with positive off-farm hours"
la var off_farm_hours "Total household off-farm hours"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_off_farm_hours.dta", replace
*/


********************************************************************************
*OFF-FARM HOURS
********************************************************************************
use "${Nigeria_GHS_W2_raw_data}/sect3a_harvestw2.dta", clear
gen  hrs_main_wage_off_farm=s3aq15 if (s3aq11>1 & s3aq11!=.) 	// s3q14 1   is agriculture (exclude mining). 
gen  hrs_sec_wage_off_farm= s3aq27 if (s3aq23>1 & s3aq23!=.) 
egen hrs_wage_off_farm= rowtotal(hrs_main_wage_off_farm hrs_sec_wage_off_farm) 
gen  hrs_main_wage_on_farm=s3aq15 if (s3aq11<=1 & s3aq11!=.)  
gen  hrs_sec_wage_on_farm= s3aq27 if (s3aq23<=1 & s3aq23!=.)  
egen hrs_wage_on_farm= rowtotal(hrs_main_wage_on_farm hrs_sec_wage_on_farm)
egen hrs_unpaid_off_farm= rowtotal(s3aq38)
drop *main* *sec*  
recode s3aq39b1 s3aq39b2 s3aq40b1 s3aq40b2 (.=0) 
gen hrs_domest_fire_fuel=(s3aq39b1+ s3aq39b2/60+s3aq40b1+s3aq40b2/60)*7  // hours worked just yesterday
gen  hrs_ag_activ=.
gen  hrs_self_off_farm=.
egen hrs_off_farm=rowtotal(hrs_wage_off_farm hrs_self_off_farm)
egen hrs_on_farm=rowtotal(hrs_ag_activ hrs_wage_on_farm)
egen hrs_domest_all=rowtotal(hrs_domest_fire_fuel)
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
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_off_farm_hours.dta", replace


********************************************************************************
* WAGE INCOME *
********************************************************************************
use "${Nigeria_GHS_W2_raw_data}/sect3a_harvestw2.dta", clear
ren s3aq10b activity_code
ren s3aq11 sector_code
ren s3aq4 mainwage_yesno
ren s3aq13 mainwage_number_months
ren s3aq14 mainwage_number_weeks
ren s3aq15 mainwage_number_hours
ren s3aq18a1 mainwage_recent_payment
gen ag_activity = (sector_code==1)
replace mainwage_recent_payment = . if ag_activity==1 // exclude ag wages 
ren s3aq18a2 mainwage_payment_period
ren s3aq20a mainwage_recent_payment_other
replace mainwage_recent_payment_other = . if ag_activity==1
ren s3aq20b mainwage_payment_period_other
ren s3aq23 sec_sector_code
ren s3aq21 secwage_yesno
ren s3aq25 secwage_number_months
ren s3aq26 secwage_number_weeks
ren s3aq27 secwage_number_hours
ren s3aq30a1 secwage_recent_payment
gen sec_ag_activity = (sec_sector_code==1)
replace secwage_recent_payment = . if sec_ag_activity==1 // exclude ag wages 
ren s3aq30a2 secwage_payment_period
ren s3aq32a secwage_recent_payment_other
replace secwage_recent_payment_other = . if sec_ag_activity==1
ren s3aq32b secwage_payment_period_other
ren s3aq1 worked_as_employee
recode  mainwage_number_months secwage_number_months (12/max=12)
recode  mainwage_number_weeks secwage_number_weeks (52/max=52)
recode  mainwage_number_hours secwage_number_hours (84/max=84)
local vars main sec 
foreach p of local vars {
	replace `p'wage_recent_payment=. if worked_as_employee!=1
	gen `p'wage_salary_cash = `p'wage_recent_payment if `p'wage_payment_period==8
	replace `p'wage_salary_cash = ((`p'wage_number_months/6)*`p'wage_recent_payment) if `p'wage_payment_period==7
	replace `p'wage_salary_cash = ((`p'wage_number_months/4)*`p'wage_recent_payment) if `p'wage_payment_period==6
	replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_recent_payment) if `p'wage_payment_period==5
	replace `p'wage_salary_cash = (`p'wage_number_months*(`p'wage_number_weeks/2)*`p'wage_recent_payment) if `p'wage_payment_period==4
	replace `p'wage_salary_cash = (`p'wage_number_weeks*`p'wage_recent_payment) if `p'wage_payment_period==3
	replace `p'wage_salary_cash = (`p'wage_number_weeks*(`p'wage_number_hours/8)*`p'wage_recent_payment) if `p'wage_payment_period==2
	replace `p'wage_salary_cash = (`p'wage_number_weeks*`p'wage_number_hours*`p'wage_recent_payment) if `p'wage_payment_period==1

	replace `p'wage_recent_payment_other=. if worked_as_employee!=1
	gen `p'wage_salary_other = `p'wage_recent_payment_other if `p'wage_payment_period_other==8
	replace `p'wage_salary_other = ((`p'wage_number_months/6)*`p'wage_recent_payment_other) if `p'wage_payment_period_other==7
	replace `p'wage_salary_other = ((`p'wage_number_months/4)*`p'wage_recent_payment_other) if `p'wage_payment_period_other==6
	replace `p'wage_salary_other = (`p'wage_number_months*`p'wage_recent_payment_other) if `p'wage_payment_period_other==5
	replace `p'wage_salary_other = (`p'wage_number_months*(`p'wage_number_weeks/2)*`p'wage_recent_payment_other) if `p'wage_payment_period_other==4
	replace `p'wage_salary_other = (`p'wage_number_weeks*`p'wage_recent_payment_other) if `p'wage_payment_period_other==3
	replace `p'wage_salary_other = (`p'wage_number_weeks*(`p'wage_number_hours/8)*`p'wage_recent_payment_other) if `p'wage_payment_period_other==2
	replace `p'wage_salary_other = (`p'wage_number_weeks*`p'wage_number_hours*`p'wage_recent_payment_other) if `p'wage_payment_period_other==1
	recode `p'wage_salary_cash `p'wage_salary_other (.=0)
	gen `p'wage_annual_salary = `p'wage_salary_cash + `p'wage_salary_other
}
gen annual_salary = mainwage_annual_salary + secwage_annual_salary
collapse (sum) annual_salary, by (hhid)
lab var annual_salary "Estimated annual earnings from non-agricultural wage employment over previous 12 months"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_wage_income.dta", replace

*Ag wage income
use "${Nigeria_GHS_W2_raw_data}/sect3a_harvestw2.dta", clear
ren s3aq10b activity_code
ren s3aq11 sector_code
ren s3aq4 mainwage_yesno
ren s3aq13 mainwage_number_months
ren s3aq14 mainwage_number_weeks
ren s3aq15 mainwage_number_hours
ren s3aq18a1 mainwage_recent_payment
gen ag_activity = (sector_code==1)
replace mainwage_recent_payment = . if ag_activity!=1 // include only ag wages
ren s3aq18a2 mainwage_payment_period
ren s3aq20a mainwage_recent_payment_other
replace mainwage_recent_payment_other = . if ag_activity!=1 // include only ag wages
ren s3aq20b mainwage_payment_period_other
ren s3aq23 sec_sector_code
ren s3aq21 secwage_yesno
ren s3aq25 secwage_number_months
ren s3aq26 secwage_number_weeks
ren s3aq27 secwage_number_hours
ren s3aq30a1 secwage_recent_payment
gen sec_ag_activity = (sec_sector_code==1)
replace secwage_recent_payment = . if sec_ag_activity!=1
ren s3aq30a2 secwage_payment_period
ren s3aq32a secwage_recent_payment_other
replace secwage_recent_payment_other = . if sec_ag_activity!=1 // include only ag wages
ren s3aq32b secwage_payment_period_other
ren s3aq1 worked_as_employee
recode  mainwage_number_months secwage_number_months (12/max=12)
recode  mainwage_number_weeks secwage_number_weeks (52/max=52)
recode  mainwage_number_hours secwage_number_hours (84/max=84)

local vars main sec 
foreach p of local vars {
	replace `p'wage_recent_payment=. if worked_as_employee!=1
	gen `p'wage_salary_cash = `p'wage_recent_payment if `p'wage_payment_period==8
	replace `p'wage_salary_cash = ((`p'wage_number_months/6)*`p'wage_recent_payment) if `p'wage_payment_period==7
	replace `p'wage_salary_cash = ((`p'wage_number_months/4)*`p'wage_recent_payment) if `p'wage_payment_period==6
	replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_recent_payment) if `p'wage_payment_period==5
	replace `p'wage_salary_cash = (`p'wage_number_months*(`p'wage_number_weeks/2)*`p'wage_recent_payment) if `p'wage_payment_period==4
	replace `p'wage_salary_cash = (`p'wage_number_weeks*`p'wage_recent_payment) if `p'wage_payment_period==3
	replace `p'wage_salary_cash = (`p'wage_number_weeks*(`p'wage_number_hours/8)*`p'wage_recent_payment) if `p'wage_payment_period==2
	replace `p'wage_salary_cash = (`p'wage_number_weeks*`p'wage_number_hours*`p'wage_recent_payment) if `p'wage_payment_period==1

	replace `p'wage_recent_payment_other=. if worked_as_employee!=1
	gen `p'wage_salary_other = `p'wage_recent_payment_other if `p'wage_payment_period_other==8
	replace `p'wage_salary_other = ((`p'wage_number_months/6)*`p'wage_recent_payment_other) if `p'wage_payment_period_other==7
	replace `p'wage_salary_other = ((`p'wage_number_months/4)*`p'wage_recent_payment_other) if `p'wage_payment_period_other==6
	replace `p'wage_salary_other = (`p'wage_number_months*`p'wage_recent_payment_other) if `p'wage_payment_period_other==5
	replace `p'wage_salary_other = (`p'wage_number_months*(`p'wage_number_weeks/2)*`p'wage_recent_payment_other) if `p'wage_payment_period_other==4
	replace `p'wage_salary_other = (`p'wage_number_weeks*`p'wage_recent_payment_other) if `p'wage_payment_period_other==3
	replace `p'wage_salary_other = (`p'wage_number_weeks*(`p'wage_number_hours/8)*`p'wage_recent_payment_other) if `p'wage_payment_period_other==2
	replace `p'wage_salary_other = (`p'wage_number_weeks*`p'wage_number_hours*`p'wage_recent_payment_other) if `p'wage_payment_period_other==1
	recode `p'wage_salary_cash `p'wage_salary_other (.=0)
	gen `p'wage_annual_salary = `p'wage_salary_cash + `p'wage_salary_other
}
gen annual_salary_agwage = mainwage_annual_salary + secwage_annual_salary
collapse (sum) annual_salary_agwage, by (hhid)
lab var annual_salary_agwage "Estimated annual earnings from agricultural wage employment over previous 12 months"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_agwage_income.dta", replace 


********************************************************************************
*OTHER INCOME *
********************************************************************************
use "${Nigeria_GHS_W2_raw_data}/sect6_harvestw2.dta", clear
*To convert from US dollars and Euros, we'll use the June 2015 exchange rate.
*https://fx-rate.net/NGN/?date_input=2012-06-05
*1 USD --> 162.2 naira; 1 Euro --> 250.1 naira for June 5, 2012 
ren s6q4a cash_received
ren s6q4b cash_received_unit
ren s6q8a inkind_received
ren s6q8b inkind_received_unit
local vars cash_received inkind_received
foreach p of local vars {
	replace `p' = `p'*162.2 if `p'_unit==1
	replace `p' = `p'*250.1 if `p'_unit==2
	replace `p'_unit = 5 if `p'_unit==1|`p'_unit==2
	tab `p'_unit
}
recode cash_received inkind_received (.=0)
gen remittance_income = cash_received + inkind_received
collapse (sum) remittance_income, by (hhid)
lab var remittance_income "Estimated income from OVERSEAS remittances over previous 12 months"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_remittance_income.dta", replace

use "${Nigeria_GHS_W2_raw_data}/sect13_harvestw2.dta", clear
append using "${Nigeria_GHS_W2_raw_data}/sect14_harvestw2.dta"
append using "${Nigeria_GHS_W2_raw_data}/secta42_harvestw2.dta"
ren s13q2 investment_income
ren s13q5 rental_income_buildings
ren s13q8 other_income 
ren s14q2a assistance_cash
ren s14q2d assistance_food
ren s14q2e assistance_inkind
ren sa4q7 rental_income_assets
recode investment_income rental_income_buildings other_income assistance_cash assistance_food assistance_inkind rental_income_assets (.=0)
gen assistance_income = assistance_cash + assistance_food + assistance_inkind
collapse (sum) investment_income rental_income_buildings other_income assistance_income rental_income_assets, by (hhid)
lab var investment_income "Estimated income from interest or investments over previous 12 months"
lab var rental_income_buildings "Estimated income from rentals of buildings, tools, land, transport animals over previous 12 months"
lab var other_income "Estimated income from any OTHER source over previous 12 months"
lab var assistance_income "Estimated income from a food aid, food-for-work, etc. over previous 12 months"
lab var rental_income_assets "Estimated income from rentals of tools and other agricultural assets over previous 12 months"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_other_income.dta", replace


********************************************************************************
* FARM SIZE/LAND SIZE *
********************************************************************************
//some plot areas are missing in NG wave 2, replacing with area planted if plot size is missing
*Starting with area planted
use "${Nigeria_GHS_W2_raw_data}/sect11f_plantingw2.dta", clear
ren plotid plot_id
*Merging in gender of plot manager
merge m:1 plot_id hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_areas.dta", nogen keep(1 3)
*There are a lot of unconventional measurements
//Conversion is already in the file 
/*
*Using conversion factors from BID
*Heaps
gen conversion = 0.00012 if zone==1 & s11fq1b==1
replace conversion = 0.00016 if zone==2 & s11fq1b==1
replace conversion = 0.00011 if zone==3 & s11fq1b==1
replace conversion = 0.00019 if zone==4 & s11fq1b==1
replace conversion = 0.00021 if zone==5 & s11fq1b==1
replace conversion = 0.00012 if zone==6 & s11fq1b==1
*Ridges
replace conversion = 0.0027 if zone==1 & s11fq1b==2
replace conversion = 0.004 if zone==2 & s11fq1b==2
replace conversion = 0.00494 if zone==3 & s11fq1b==2
replace conversion = 0.0023 if zone==4 & s11fq1b==2
replace conversion = 0.0023 if zone==5 & s11fq1b==2
replace conversion = 0.0001 if zone==6 & s11fq1b==2
*Stands
replace conversion = 0.00006 if zone==1 & s11fq1b==3
replace conversion = 0.00016 if zone==2 & s11fq1b==3
replace conversion = 0.00004 if zone==3 & s11fq1b==3
replace conversion = 0.00004 if zone==4 & s11fq1b==3
replace conversion = 0.00013 if zone==5 & s11fq1b==3
replace conversion = 0.00041 if zone==6 & s11fq1b==3
*Plots
replace conversion = 0.0667 if s11fq1b==4
*Acres
replace conversion = 0.404686 if s11fq1b==5
*Hectares
replace conversion = 1 if s11fq1b==6
*Square meters
replace conversion = 0.0001 if s11fq1b==7
*/
gen ha_planted = s11fq1a*conversion
keep hhid plot_id ha_planted
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_planted_areas.dta", replace

use "${Nigeria_GHS_W2_raw_data}/secta3_harvestw2.dta", clear
gen cultivated = 1
merge m:1 hhid plotid using "${Nigeria_GHS_W2_raw_data}/sect11b1_plantingw2.dta"
ren s11b1q27 cultivated_this_year

preserve 
use "${Nigeria_GHS_W2_raw_data}/sect11g_plantingw2.dta", clear
gen cultivated=1 if (s11gq8a!=. & s11gq8a!=0) | (s11gq4!=. & s11gq4!=0)
collapse (max) cultivated, by (hhid plotid)
tempfile tree
save `tree', replace
restore
append using `tree'
replace cultivated = 1 if cultivated_this_year==1 & cultivated==.
ren plotid plot_id
collapse (max) cultivated, by (hhid plot_id)
lab var cultivated "1= Parcel was cultivated in this data set"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_parcels_cultivated.dta", replace

use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_areas.dta", clear
merge m:1 hhid plot_id using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_parcels_cultivated.dta"
keep if cultivated==1
collapse (sum) field_size, by (hhid plot_id)
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_sizes.dta", replace
collapse (sum) field_size, by (hhid)
ren field_size farm_area
lab var farm_area "Land size (denominator for land productivitiy), in hectares" /* Uses measures */
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_land_size.dta", replace

*All Agricultural Land
use "${Nigeria_GHS_W2_raw_data}/sect11b1_plantingw2.dta", clear
ren plotid plot_id
gen agland = (s11b1q27==1 | s11b1q28==1) // Cultivated, fallow, or pasture
merge m:1 hhid plot_id using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_parcels_cultivated.dta", nogen keep(1 3)

preserve 
use "${Nigeria_GHS_W2_raw_data}/sect11g_plantingw2.dta", clear
gen cultivated=1 if (s11gq8a!=. & s11gq8a!=0) | (s11gq4!=. & s11gq4!=0)
collapse (max) cultivated, by (hhid plotid)
ren plotid plot_id
tempfile tree
save `tree', replace
restore
append using `tree'
replace agland=1 if cultivated==1
collapse (max) agland, by (hhid plot_id)
keep if agland==1
keep hhid plot_id agland
lab var agland "1= Plot was cultivated, left fallow, or used for pasture"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_parcels_agland.dta", replace

use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_areas.dta", clear
merge 1:1 hhid plot_id using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_parcels_agland.dta", nogen
*merge 1:m hhid plot_id using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_planted_areas.dta", nogen	
keep if agland==1
*replace field_size = ha_planted if field_size==. & ha_planted!=.	
*14 observations changed
collapse (sum) field_size, by (hhid)
ren field_size farm_size_agland
lab var farm_size_agland "Land size in hectares, including all plots cultivated, fallow, or pastureland"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_farmsize_all_agland.dta", replace

*Total land holding including cultivated and rented out
use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_areas.dta", clear
collapse (sum) field_size, by (hhid)
ren field_size land_size_total
lab var land_size_total "Total land size in hectares, including rented in and rented out plots"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_land_size_total.dta", replace


********************************************************************************
*LAND SIZE
********************************************************************************
use "${Nigeria_GHS_W2_raw_data}/sect11b1_plantingw2.dta", clear
ren plotid plot_id
gen rented_out = 1 if s11b1q29==2012 // It's not logical that there are so few rented-out plots
drop if rented_out==1
gen plot_held=1
keep hhid plot_id plot_held
lab var plot_held "1= Plot was NOT rented out in 2012"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_parcels_held.dta", replace

use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_areas.dta", clear
merge 1:1 hhid plot_id using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_parcels_held.dta", nogen
keep if plot_held==1
collapse (sum) field_size, by (hhid)
ren field_size land_size
lab var land_size "Land size in hectares, including all plots listed by the household (and not rented out)"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_land_size_all.dta", replace 



********************************************************************************
*FARM LABOR
********************************************************************************
use "${Nigeria_GHS_W2_raw_data}/sect11c1_plantingw2.dta", clear
ren s11c1q2 number_men
ren s11c1q3 number_days_men
ren s11c1q5 number_women
ren s11c1q6 number_days_women
ren s11c1q8 number_children
ren s11c1q9 number_days_children
gen days_men_pp = number_men * number_days_men 
gen days_women_pp = number_women * number_days_women  
gen days_children_pp = number_children * number_days_children 
recode days_men_pp days_women_pp days_children_pp (.=0)
gen days_hired_postplant =  days_men_pp + days_women_pp + days_children_pp
ren s11c1q1a2 weeks_1 
ren s11c1q1a3 days_week_1 
ren s11c1q1b2 weeks_2
ren s11c1q1b3 days_week_2
ren s11c1q1c2 weeks_3
ren s11c1q1c3 days_week_3
ren s11c1q1d2 weeks_4
ren s11c1q1d3 days_week_4
recode weeks_1 days_week_1 weeks_2 days_week_2 weeks_3 days_week_3 weeks_4 days_week_4 (.=0)
gen days_famlabor_postplant = (weeks_1 * days_week_1) + (weeks_2 * days_week_2) + (weeks_3 * days_week_3) + (weeks_4 * days_week_4)
*labor productivity at the plot level
ren plotid plot_id
collapse (sum) days_hired_postplant days_famlabor_postplant days_men_pp days_women_pp, by (hhid plot_id)
lab var days_hired_postplant "Workdays for hired labor (crops), as captured in post-planting survey"
lab var days_famlabor_postplant "Workdays for family labor (crops), as captured in post-planting survey"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_farmlabor_postplanting.dta", replace
collapse (sum) days_hired_postplant days_famlabor_postplant, by (hhid)
lab var days_hired_postplant "Workdays for hired labor (crops), as captured in post-planting survey"
lab var days_famlabor_postplant "Workdays for family labor (crops), as captured in post-planting survey"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_farmlabor_postplanting.dta", replace

use "${Nigeria_GHS_W2_raw_data}/secta2_harvestw2.dta", clear
ren sa2q2 number_men
ren sa2q3 number_days_men
ren sa2q5 number_women
ren sa2q6 number_days_women
ren sa2q8 number_children
ren sa2q9 number_days_children
gen days_men_ph = number_men * number_days_men 
gen days_women_ph = number_women * number_days_women  
gen days_children_ph = number_children * number_days_children 
recode days_men_ph days_women_ph days_children_ph (.=0)
gen days_hired_postharvest =  days_men_ph + days_women_ph + days_children_ph
ren sa2q1a2 weeks_1
ren sa2q1a3 days_week_1
ren sa2q1b2 weeks_2
ren sa2q1b3 days_week_2
ren sa2q1c2 weeks_3
ren sa2q1c3 days_week_3
ren sa2q1d2 weeks_4
ren sa2q1d3 days_week_4
ren sa2q12a number_exchange_men // Exchange labor for harvest, we understand this to be "person-days", as only the number of days was asked.
ren sa2q12b number_exchange_women 
ren sa2q12c number_exchange_children
recode number_exchange_men number_exchange_women number_exchange_children (.=0)
recode weeks_1 days_week_1 weeks_2 days_week_2 weeks_3 days_week_3 weeks_4 days_week_4 (.=0)
gen days_famlabor_postharvest = (weeks_1 * days_week_1) + (weeks_2 * days_week_2) + (weeks_3 * days_week_3) + (weeks_4 * days_week_4)
gen days_exchange_labor_postharvest = number_exchange_men + number_exchange_women + number_exchange_children
*labor productivity at the plot level
ren plotid plot_id
collapse (sum) days_hired_postharvest days_famlabor_postharvest days_exchange_labor_postharvest days_men_ph days_women_ph, by (hhid plot_id)
lab var days_hired_postharvest "Workdays for hired labor (crops), as captured in post-harvest survey"
lab var days_famlabor_postharvest "Workdays for family labor (crops), as captured in post-harvest survey"
lab var days_exchange_labor_postharvest "Workdays (lower-bound estimate) of exchange labor, as captured in post-harvest survey"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_farmlabor_postharvest.dta", replace 
collapse (sum) days_hired_postharvest days_famlabor_postharvest days_exchange_labor_postharvest, by (hhid)
lab var days_hired_postharvest "Workdays for hired labor (crops), as captured in post-harvest survey"
lab var days_famlabor_postharvest "Workdays for family labor (crops), as captured in post-harvest survey"
lab var days_exchange_labor_postharvest "Workdays (lower-bound estimate) of exchange labor, as captured in post-harvest survey"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_farmlabor_postharvest.dta", replace 

*labor 
use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_farmlabor_postplanting.dta", clear
merge 1:1  hhid plot_id using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_farmlabor_postharvest.dta", nogen
recode days*  (.=0)
collapse (sum) days*, by(hhid plot_id)
egen labor_hired =rowtotal(days_hired_postplant days_hired_postharvest ) 
egen labor_family=rowtotal(days_famlabor_postplant days_famlabor_postharvest )
egen labor_total = rowtotal(labor_hired labor_family days_exchange_labor_postharvest)
egen labor_hired_male = rowtotal(days_men_pp days_men_ph)
egen labor_hired_female = rowtotal(days_women_pp days_women_ph)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm in the past year"
lab var labor_hired "Total labor days (hired) allocated to the farm in the past year"
lab var labor_family "Total labor days (family) allocated to the farm in the past year"
lab var labor_total "Total labor days (hired +family) allocated to the farm in the past year"
lab var labor_hired_male "Workdays for male hired labor allocated to the farm in the past year"
lab var labor_hired_female "Workdays for female hired labor allocated to the farm in the past year"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_family_hired_labor.dta", replace
recode labor_*  (.=0)
collapse (sum) labor_*, by(hhid)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm in the past year"
lab var labor_hired "Total labor days (hired) allocated to the farm in the past year"
lab var labor_family "Total labor days (family) allocated to the farm in the past year"
lab var labor_total "Total labor days (hired +family) allocated to the farm in the past year" 
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_family_hired_labor.dta", replace


********************************************************************************
* VACCINE USAGE *
********************************************************************************
use "${Nigeria_GHS_W2_raw_data}/sect11i_plantingw2.dta", clear
gen vac_animal= s11iq22>=1 & s11iq1==1
replace  vac_animal=. if   animal_other=="DOG" | animal_other=="XO" | animal_other=="``" | animal_other=="." | animal_other==","  // set to missing if animal is dog, cat, or unspecified
replace vac_animal=. if s11iq1==2 | s11iq1==.
lab var vac_animal "1= Household has an animal vaccinated"
*disagregating vaccine usage by animal type 
ren animal_cd livestock_code
gen species = (inlist(livestock_code,101,102,103,104,105,106,107)) + 2*(inlist(livestock_code,110,111)) + 3*(livestock_code==112) + 4*(inlist(livestock_code,108,109,122)) + 5*(inlist(livestock_code,113,114,115,116,117,118,120))
recode species (0=.)
la def species 1 "Large ruminants (cows, buffalos)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses, donkeys)" 5 "Poultry"
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
lab var vac_animal "1= Household has an animal vaccinated"
foreach i in vac_animal {
	local l`i' : var lab `i'
	lab var `i'_lrum "`l`i'' - large ruminants"
	lab var `i'_srum "`l`i'' - small ruminants"
	lab var `i'_pigs "`l`i'' - pigs"
	lab var `i'_equine "`l`i'' - equine"
	lab var `i'_poultry "`l`i'' - poultry"
}
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_vaccine.dta", replace

*vaccine use livestock keeper  
use "${Nigeria_GHS_W2_raw_data}/sect11i_plantingw2.dta", clear
gen all_vac_animal= s11iq22>=1 & s11iq1==1
replace  all_vac_animal=. if   animal_other=="DOG" | animal_other=="XO" | animal_other=="``" | animal_other=="." | animal_other==","  // set to missing if animal is dog, cat, or unspecified
replace all_vac_animal=. if s11iq1==2 | s11iq1==.

preserve
keep hhid s11iq5a all_vac_animal 
ren s11iq5a farmerid
tempfile farmer1
save `farmer1'
restore
preserve
keep hhid  s11iq5b  all_vac_animal 
ren s11iq5b farmerid
tempfile farmer2
save `farmer2'
restore
use   `farmer1', replace
append using  `farmer2'
collapse (max) all_vac_animal , by(hhid farmerid)
gen indiv=farmerid
drop if indiv==.
merge 1:1 hhid indiv using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_gender_merge_temp.dta", nogen
keep hhid farmerid all_vac_animal indiv female age
lab var all_vac_animal "1 = Individual farmer (livestock keeper) uses vaccines"
gen livestock_keeper=1 if farmerid!=.
recode livestock_keeper (.=0)
lab var livestock_keeper "1=Indvidual is listed as a livestock keeper (at least one type of livestock)" 
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_farmer_vaccine.dta", replace


********************************************************************************
*ANIMAL HEALTH - DISEASES
********************************************************************************
use "${Nigeria_GHS_W2_raw_data}/sect11i_plantingw2.dta", clear
gen disease_animal = 1 if s11iq20==1
replace disease_animal = 0 if s11iq20==2
gen disease_fmd = (s11iq21a==4 | s11iq21c==4 )
gen disease_lump = (s11iq21a==5 | s11iq21c==5 )
gen disease_bruc = (s11iq21a==7 | s11iq21c==7 )
gen disease_cbpp = (s11iq21a==9 | s11iq21c==9 )
gen disease_bq = (s11iq21a==6 | s11iq21c==6 )
ren animal_cd livestock_code
gen species = (inlist(livestock_code,101,102,103,104,105,106,107)) + 2*(inlist(livestock_code,110,111)) + 3*(livestock_code==112) + 4*(inlist(livestock_code,108,109,122)) + 5*(inlist(livestock_code,113,114,115,116,117,118,120))
recode species (0=.)
la def species 1 "Large ruminants (cows, buffalos)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses, donkeys)" 5 "Poultry"
la val species species
*A loop to create species variables
foreach i in disease_animal disease_fmd disease_lump disease_bruc disease_cbpp disease_bq{
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==2
	gen `i'_pigs = `i' if species==3
	gen `i'_equine = `i' if species==4
	gen `i'_poultry = `i' if species==5
}
collapse (max) disease_*, by (hhid)
lab var disease_animal "1= Household has animal that suffered from disease"
lab var disease_fmd "1= Household has animal that suffered from foot and mouth disease"
lab var disease_lump "1= Household has animal that suffered from lumpy skin disease"
lab var disease_bruc "1= Household has animal that suffered from black quarter"
lab var disease_cbpp "1= Household has animal that suffered from brucelosis"
lab var disease_bq "1= Household has animal that suffered from black quarter"
foreach i in disease_animal disease_fmd disease_lump disease_bruc disease_cbpp disease_bq{
	local l`i' : var lab `i'
	lab var `i'_lrum "`l`i'' - large ruminants"
	lab var `i'_srum "`l`i'' - small ruminants"
	lab var `i'_pigs "`l`i'' - pigs"
	lab var `i'_equine "`l`i'' - equine"
	lab var `i'_poultry "`l`i'' - poultry"
}
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_livestock_diseases.dta", replace

********************************************************************************
*LIVESTOCK WATER, FEEDING, AND HOUSING
********************************************************************************
**cannot construct

********************************************************************************
* PLOT MANAGERS *
********************************************************************************
//This section combines all the variables that we're interested in at manager level
//(inorganic fertilizer, improved seed) into a single operation.
//Doing improved seed and agrochemicals at the same time.
use "${Nigeria_GHS_W2_raw_data}/sect11e_plantingW2.dta", clear
gen use_imprv_seed=. //NA for W2
ren plotid plot_id
ren cropcode crop_code
//Crop recode
recode crop_code (1053=1050) (1061 1062 = 1060) (1081 1082=1080) (1091 1092 1093 = 1090) (1111=1110) (2191 2192 2193=2190) /*Counting this generically as pumpkin, but it is different commodities
	*/				 (3181 3182 3183 3184 = 3180) (2170=2030) (3113 3112 3111 = 3110) (3022=3020) (2142 2141 = 2140) (1121 1122 1123 1124=1120)
collapse (max) use_imprv_seed, by(hhid plot_id crop_code)
tempfile imprv_seed
save `imprv_seed'
use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_areas.dta", clear
ren s11aq6a pid1
ren s11aq6b pid2
replace pid1=sa1q11 if pid1==.
replace pid2=sa1q11b if pid2==.
keep hhid plot_id pid*
reshape long pid, i(hhid plot_id) j(pidno)
drop pidno
drop if pid==.
ren pid indiv
merge m:1 hhid indiv using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_gender_merge.dta", nogen keep(1 3)
tempfile personids
save `personids'

use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_input_quantities.dta", clear
foreach i in inorg_fert pest herb {
	recode `i'_rate (.=0)
	replace `i'_rate=1 if `i'_rate >0 
	ren `i'_rate use_`i'
}
collapse (max) use_*, by(hhid plot_id)
merge 1:m hhid plot_id using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_all_plots.dta", nogen keep(1 3) keepusing(crop_code_master)
ren crop_code_master crop_code
collapse (max) use*, by(hhid plot_id crop_code)
merge 1:1 hhid plot_id crop_code using `imprv_seed',nogen
recode use* (.=0)
preserve 
keep hhid plot_id crop_code use_imprv_seed
ren use_imprv_seed imprv_seed_
gen hybrid_seed_ = .
collapse (max) imprv_seed_ hybrid_seed_, by(hhid crop_code)
merge m:1 crop_code using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_cropname_table.dta", nogen keep(3)
drop crop_code
reshape wide imprv_seed_ hybrid_seed_, i(hhid) j(crop_name) string
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_imprvseed_crop.dta",replace //ALT: this is slowly devolving into a kludgy mess as I try to keep continuity up in the hh_vars section.
restore 


merge m:m hhid plot_id using `personids', nogen keep(1 3) //Many-to-many merges are unpopular because the odds of accidentally inflating values by collapsing on duplicates goes way up; however, we only need to know whether *any* person managing a given plot used <input> for *at least one* crop grown on that plot. In this case the duplication is not improper.
preserve
ren use_imprv_seed all_imprv_seed_
gen all_hybrid_seed_ =.
collapse (max) all*, by(hhid indiv female crop_code)
merge m:1 crop_code using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_cropname_table.dta", nogen keep(3)
drop crop_code
gen farmer_=1
reshape wide all_imprv_seed_ all_hybrid_seed_ farmer_, i(hhid indiv female) j(crop_name) string
recode farmer_* (.=0)
ren farmer_* *_farmer
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_farmer_improvedseed_use.dta", replace
restore


collapse (max) use_*, by(hhid indiv female) //Going to be 100% empty for improved seed
gen all_imprv_seed_use = use_imprv_seed
//Temp code to get the values out faster
/*	collapse (max) use_*, by(hhid)
	merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_weights.dta", nogen keep(3)
	recode use* (.=0)
	collapse (mean) use* [aw=weight_pop_rururb] */
//Legacy files, replacing the code below.

preserve
	collapse (max) use_inorg_fert use_imprv_seed use_pest use_herb, by (hhid)
	la var use_inorg_fert "1= Household uses inorganic fertilizer"
	la var use_pest "1 = household uses pesticide"
	la var use_herb "1 = household uses herbicide"
	//la var use_org_fert "1= household uses organic fertilizer" //NA for this wave
	la var use_imprv_seed "1=household uses improved or hybrid seeds (NA for W2)"
	gen use_hybrid_seed = .
	la var use_hybrid_seed "1=household uses hybrid seeds (NA for W2)"
	gen imprv_seed_use = . //Legacy
	gen hybrid_seed_use = . //Legacy
	save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_input_use.dta", replace 
restore

preserve
	ren use_inorg_fert all_use_inorg_fert
	//This is a little misnomer for the file because it now contains all inputs, but I need it for AgQuery (input use being only at the hh level)
	lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
	gen farm_manager=1 if indiv!=.
	recode farm_manager (.=0)
	lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
	save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_farmer_fert_use.dta", replace
restore


********************************************************************************
* REACHED BY AG EXTENSION *
********************************************************************************
/*OLD
use "${Nigeria_GHS_W2_raw_data}/sect11l1_plantingw2.dta", clear
ren s11l1q1 receive_advice
ren s11l1q2 sourceid
preserve
use  "${Nigeria_GHS_W2_raw_data}/secta5a_harvestw2.dta", clear
ren sa5aq1 receive_advice
ren sa5aq2 sourceid
ren sa5aq2b sourceid_other
tempfile advie_ph
save `advie_ph'
restore
append using `advie_ph'

* BET 03.26.2021 Some corrections to source types (govt, coop)
**Government Extension
gen advice_gov = ((sourceid==1 | sourceid==3)  & receive_advice==1)
**private Extension
gen advice_private = (sourceid==2 & receive_advice==1)
**NGO
gen advice_ngo = (sourceid==4 & receive_advice==1)
**Cooperative/ Farmer Association
gen advice_coop = ((sourceid==5  | sourceid==6) & receive_advice==1)
**Radio
gen advice_media = (sourceid==12 & receive_advice==1)
**Publication
gen advice_pub = (sourceid==13 & receive_advice==1)
**Neighbor
gen advice_neigh = ((sourceid==8 | sourceid==10 | sourceid==11) & receive_advice==1)
**Other (farmer field schools, ext courses, other)
gen advice_other = ((sourceid==7 | sourceid==9 | sourceid==14)  & receive_advice==1)

gen ext_reach_all=(advice_gov==1 | advice_ngo==1 | advice_coop==1 | advice_media==1  | advice_pub==1)
gen ext_reach_public=(advice_gov==1)
gen ext_reach_private=(advice_ngo==1 | advice_coop==1)
gen ext_reach_unspecified=(advice_media==1 | advice_pub==1 | advice_other==1)
gen ext_reach_ict=(advice_media==1)


*BET 03.25.2021
*seed use
preserve
use "${Nigeria_GHS_W2_raw_data}/sect11e_plantingw2.dta", clear
gen seed_ext_advice=0
replace seed_ext_advice=1 if (s11eq7==2 | s11eq7==3 | s11eq7==4) // BT 11.24.20 adding in if farmer recieved advice from input supplier or fellow farmer
tempfile advice_seed
save `advice_seed'
restore
append using `advice_seed'

*fertilizer use
preserve
use "${Nigeria_GHS_W2_raw_data}/sect11d_plantingw2.dta", clear
gen fert_ext_advice=0
replace fert_ext_advice=1 if (s11dq5==2 | s11dq5==3 | s11dq5==4) // BT 11.24.20 adding in if farmer recieved advice from input supplier or fellow farmer
tempfile advice_fert
save `advice_fert'
restore
append using `advice_fert'

replace ext_reach_all=1 if (fert_ext_advice==1 | seed_ext_advice==1) & ext_reach_all==0 
replace ext_reach_private=1 if (fert_ext_advice==1 | seed_ext_advice==1) & ext_reach_private==0 

collapse (max) ext_reach_* , by (hhid)
lab var ext_reach_all "1 = Household reached by extensition services - all sources"
lab var ext_reach_public "1 = Household reached by extensition services - public sources"
lab var ext_reach_private "1 = Household reached by extensition services - private sources"
lab var ext_reach_unspecified "1 = Household reached by extensition services - unspecified sources"
lab var ext_reach_ict "1 = Household reached by extensition services through ICT"

save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_any_ext.dta", replace 
*/


*Extension
use "${Nigeria_GHS_W2_raw_data}\sect11l1_plantingw2.dta", clear
ren s11l1q1 receive_advice
ren s11l1q2 sourceid
preserve
use  "${Nigeria_GHS_W2_raw_data}\secta5a_harvestw2.dta", clear
ren sa5aq1 receive_advice
ren sa5aq2 sourceid
ren sa5aq2b sourceid_other
tempfile advie_ph
save `advie_ph'
restore
append using `advie_ph'

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

*DYA.04.26.2022 added here
*gen ext_reach_all=(advice_gov==1 | advice_ngo==1 | advice_coop==1 | advice_media==1  | advice_pub==1)
gen ext_reach_public=(advice_gov_ag==1 & advice_gov_fish==1)
gen ext_reach_private=(advice_ngo==1 | advice_coop==1)
gen ext_reach_unspecified=(advice_media==1 | advice_pub==1 | advice_other==1)
gen ext_reach_ict=(advice_media==1)
*End


*Advice All // BT 11.24.20 added in lead farmers and peer farmers as sources (sourceid = 10 or 11)
gen advice_all = ((sourceid==1 | sourceid==2 | sourceid==3 | sourceid==4 | sourceid==5 | sourceid==6 | sourceid==7 | sourceid==8 | sourceid==9 | sourceid==10 | sourceid==11| sourceid==12 | sourceid==13 | sourceid==14 )  & receive_advice==1)

*seed use
preserve
use "${Nigeria_GHS_W2_raw_data}\sect11e_plantingw2.dta", clear
gen seed_ext_advice=0
replace seed_ext_advice=1 if (s11eq7==2 | s11eq7==3 | s11eq7==4) // BT 11.24.20 adding in if farmer recieved advice from input supplier or fellow farmer
tempfile advice_seed
save `advice_seed'
restore
append using `advice_seed'
replace advice_all=1 if seed_ext_advice==1 & advice_all==0 

*fertilizer use
preserve
use "${Nigeria_GHS_W2_raw_data}\sect11d_plantingw2.dta", clear
gen fert_ext_advice=0
replace fert_ext_advice=1 if (s11dq5==2 | s11dq5==3 | s11dq5==4) // BT 11.24.20 adding in if farmer recieved advice from input supplier or fellow farmer
tempfile advice_fert
save `advice_fert'
restore
append using `advice_fert'
replace advice_all=1 if fert_ext_advice==1 & advice_all==0 

collapse (max) advice_* , by (hhid)
ren advice_all ext_reach_all
save  "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_any_ext.dta", replace 


********************************************************************************
* MOBILE PHONE OWNERSHIP *
********************************************************************************
*BET 03.25.2021
use "${Nigeria_GHS_W2_raw_data}/sect5a_plantingw2.dta", clear
append using "${Nigeria_GHS_W2_raw_data}/sect5_harvestw2.dta"

recode s5q1 s5q10  (.=0) // recode missing to zero phones 
gen  hh_number_mobile_owned_ph=s5q10   // number mobile phones owned post harvest
recode hh_number_mobile_owned* (.=0)
gen mobile_owned= hh_number_mobile_owned_ph>0
collapse (max) mobile_owned hh_number_mobile_owned, by(hhid)
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_mobile_own.dta", replace

********************************************************************************
* USE OF FORMAL FINANCIAL SERVICES *
********************************************************************************
use "${Nigeria_GHS_W2_raw_data}/sect4a_plantingw2.dta", clear
append using "${Nigeria_GHS_W2_raw_data}/sect4b_plantingw2.dta" 
append using "${Nigeria_GHS_W2_raw_data}/sect9_harvestw2.dta" 
gen use_bank_acount=s4aq1==1
gen use_bank_other= ((s9q17==1 |  s9q18==1) &( s9q19a==1 |  s9q19b==1))
gen use_saving=s4aq9b==3 | s4aq9d==1 | s4aq9f==1
gen use_MM=.
gen rec_loans4cq1=s4aq11==1 &  (s4aq12b==3 | s4aq12b==4 | s4aq12d==3 | s4aq12d==4 | s4aq12f==3 |  s4aq12f==4 )
gen use_credit_selfemp= (s9q17==1 |  s9q18==1) &( s9q19a==1 |  s9q19b==1)
gen use_insur=s4aq16==1
gen use_fin_serv_bank= use_bank_acount==1
gen use_fin_serv_credit= use_credit_selfemp==1 | rec_loans4cq1==1   
gen use_fin_serv_insur= use_insur==1
gen use_fin_serv_digital=use_MM==1
gen use_fin_serv_others= use_saving==1
gen use_fin_serv_all=use_fin_serv_bank==1 | use_fin_serv_credit==1 | use_fin_serv_insur==1 | use_fin_serv_digital==1 |  use_fin_serv_others==1
recode use_fin_serv* (.=0)
collapse (max) use_fin_serv_*, by (hhid)
lab var use_fin_serv_all "1= Household uses formal financial services - all types"
lab var use_fin_serv_bank "1= Household uses formal financial services - bank accout"
lab var use_fin_serv_credit "1= Household uses formal financial services - credit"
lab var use_fin_serv_insur "1= Household uses formal financial services - insurance"
lab var use_fin_serv_digital "1= Household uses formal financial services - digital"
lab var use_fin_serv_others "1= Household uses formal financial services - others"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_fin_serv.dta", replace 

 
********************************************************************************
* MILK PRODUCTIVITY *
********************************************************************************
*Cannot construct per animal, only total
use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_livestock_products.dta", clear
keep if livestock_code == 1 & quantity_produced!=0
replace quantity_produced = quantity_produced/100 if quantity_produced_unit==4
replace quantity_produced_unit = 3 if quantity_produced_unit==4
replace quantity_produced_unit = 3 if livestock_code==1 & (quantity_produced_unit==2 | quantity_produced_unit==8)
gen milk_quantity_produced = quantity_produced
gen milk_months_produced = months_produced
drop if quantity_produced_unit==. | quantity_produced_unit==5 | quantity_produced_unit==9
collapse (sum) milk_months_produced milk_quantity_produced , by (hhid)
drop if milk_months_produced==0 | milk_quantity_produced==0
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_milk_animals.dta", replace


********************************************************************************
* EGG PRODUCTIVITY *
********************************************************************************
*Cannot construct per animal, only total
use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_livestock_products.dta", clear
keep if livestock_code==2 & quantity_produced!=0
replace quantity_produced_unit = 16 if livestock_code==2 & (quantity_produced_unit==91 | quantity_produced_unit==15 | quantity_produced_unit==12 | quantity_produced_unit==11 /*
*/ | quantity_produced_unit==10 | quantity_produced_unit==8 | quantity_produced_unit==2 | quantity_produced_unit==1)
gen eggs_quantity_produced = quantity_produced
gen eggs_months_produced = months_produced
drop if quantity_produced_unit==.
collapse (sum) eggs_months_produced eggs_quantity_produced, by (hhid)
drop if eggs_months_produced==0 | eggs_quantity_produced==0
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_egg_animals.dta", replace


********************************************************************************
* CROP PRODUCTION COSTS PER HECTARE *
********************************************************************************
*All the preprocessing is done in the crop expenses section
use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_all_plots.dta", clear
collapse (sum) ha_planted ha_harvest, by(hhid plot_id purestand field_size)
reshape long ha_, i(hhid plot_id purestand field_size) j(area_type) string
tempfile plot_areas
save `plot_areas'
use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_cost_inputs_long.dta", clear
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
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_cropcosts.dta", replace



********************************************************************************
* RATE OF FERTILIZER APPLICATION *
********************************************************************************
//ALT 08.04.21: Added in org fert, herbicide, and pesticide; additional coding needed to integrate these into summary stats
use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_all_plots.dta", clear
collapse (sum) ha_planted, by(hhid plot_id dm_gender)
merge 1:1 hhid plot_id using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_input_quantities.dta", nogen keep(1 3) //11 plots have expenses but don't show up in the all_plots roster.
gen dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
drop dm_gender
ren ha_planted ha_planted_
ren inorg_fert_rate fert_inorg_kg_ 
//ren org_fert_rate fert_org_kg_ 
ren pest_rate pest_kg_
ren herb_rate herb_kg_
reshape wide ha_planted_ fert_inorg_kg_ pest_kg_ herb_kg_, i(hhid plot_id) j(dm_gender2) string
collapse (sum) *male *mixed, by(hhid)
recode ha_planted* (0=.)
foreach i in ha_planted fert_inorg_kg pest_kg herb_kg {
	egen `i' = rowtotal(`i'_*)
}
merge m:1 hhid using  "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_weights.dta", keep (1 3) nogen
_pctile ha_planted [aw=weight_pop_rururb]  if ha_planted!=0 , p($wins_lower_thres $wins_upper_thres)
foreach x of varlist ha_planted ha_planted_male ha_planted_female ha_planted_mixed {
		replace `x' =r(r1) if `x' < r(r1)   & `x' !=. &  `x' !=0 
		replace `x' = r(r2) if  `x' > r(r2) & `x' !=.    
}
lab var fert_inorg_kg "Inorganic fertilizer (kgs) for household"
//lab var fert_org_kg "Organic fertilizer (kgs) for household" 
lab var pest_kg "Pesticide (kgs) for household"
lab var herb_kg "Herbicide (kgs) for household"
lab var ha_planted "Area planted (ha), all crops, for household"

foreach i in male female mixed {
lab var fert_inorg_kg_`i' "Inorganic fertilizer (kgs) for `i'-managed plots"
//lab var fert_org_kg_`i' "Organic fertilizer (kgs) for `i'-managed plots" 
lab var pest_kg_`i' "Pesticide (kgs) for `i'-managed plots"
lab var herb_kg_`i' "Herbicide (kgs) for `i'-managed plots"
lab var ha_planted_`i' "Area planted (ha), all crops, `i'-managed plots"
}
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_fertilizer_application.dta", replace


********************************************************************************
*WOMEN'S DIET QUALITY
********************************************************************************
*Women's diet quality: proportion of women consuming nutrient-rich foods (%)
*Information not available


********************************************************************************
*HOUSEHOLD'S DIET DIVERSITY SCORE
******************************************************************************** 
* since the diet variable is available in botn PP and PH datasets, we first append the two together
use "${Nigeria_GHS_W2_raw_data}/sect7b_plantingw2.dta" , clear
keep zone state lga sector ea hhid item_cd item_desc s7bq1
gen survey="PP"
preserve
use "${Nigeria_GHS_W2_raw_data}/sect10b_harvestw2.dta" , clear
keep zone state lga sector ea hhid item_cd item_desc s10bq1
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
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_household_diet.dta", replace


********************************************************************************
*WOMEN'S CONTROL OVER INCOME
********************************************************************************
*Code as 1 if a woman is listed as one of the decision-makers for at least 1 income-related area; 
*can report on % of women who make decisions, taking total number of women HH members as denominator
*Inmost cases, NGA LSMS 2 lsit the first TWO decision makers.
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
*/

* First append all files with information on who control various types of income
use "${Nigeria_GHS_W2_raw_data}/sect11b1_plantingw2", clear
append using "${Nigeria_GHS_W2_raw_data}/sect11d_plantingw2"
append using "${Nigeria_GHS_W2_raw_data}/sect11e_plantingw2"
append using "${Nigeria_GHS_W2_raw_data}/sect11h_plantingw2"
append using "${Nigeria_GHS_W2_raw_data}/sect11i_plantingw2"
append using "${Nigeria_GHS_W2_raw_data}/sect11k_plantingw2"
append using "${Nigeria_GHS_W2_raw_data}/secta1_harvestw2"
append using "${Nigeria_GHS_W2_raw_data}/secta3_harvestw2"
append using "${Nigeria_GHS_W2_raw_data}/secta6_harvestw2"
append using "${Nigeria_GHS_W2_raw_data}/secta8_harvestw2"
append using "${Nigeria_GHS_W2_raw_data}/sect3a_plantingw2"
append using "${Nigeria_GHS_W2_raw_data}/sect6_plantingw2"
append using "${Nigeria_GHS_W2_raw_data}/sect10_plantingw2"
append using "${Nigeria_GHS_W2_raw_data}/sect3a_harvestw2", force
append using "${Nigeria_GHS_W2_raw_data}/sect7_harvestw2", force
append using "${Nigeria_GHS_W2_raw_data}/sect9_harvestw2", force
append using "${Nigeria_GHS_W2_raw_data}/sect13_harvestw2", force
append using "${Nigeria_GHS_W2_raw_data}/sect14_harvestw2", force
gen type_decision="" 
gen controller_income1=.
gen controller_income2=.
* control of harvest from annual crops
replace type_decision="control_annualharvest" if  !inlist( sa3q6b1, .,0,99, 98) |  !inlist( sa3q6b2, .,0,99, 98) 
replace controller_income1=sa3q6b1 if !inlist(sa3q6b1, .,0,99, 98)  
replace controller_income2=sa3q6b2 if !inlist(sa3q6b2, .,0,99, 98)
* control_annualsales -PP
replace type_decision="control_annualsales" if  !inlist( s11hq7a, .,0,99, 98) |  !inlist( s11hq7b, .,0,99, 98)  
replace controller_income1=s11hq7a if !inlist(s11hq7a, .,0,99, 98)  
replace controller_income2=s11hq7b if !inlist(s11hq7b, .,0,99, 98)
* append who controls earning from sale to customer 2 -PP
preserve
replace type_decision="control_annualsales" if  !inlist( s11hq14a, .,0,99, 98) |  !inlist( s11hq14b, .,0,99, 98) 
replace controller_income1=s11hq14a if !inlist( s11hq14a, .,0,99, 98)  
replace controller_income2=s11hq14b if !inlist( s11hq14b, .,0,99, 98)
keep if !inlist(s11hq14b, .,0,99, 98) |  !inlist(s11hq14b, .,0,99, 98)
keep hhid type_decision controller_income1 controller_income2
tempfile control_annualsales2
save `control_annualsales2'
restore
append using `control_annualsales2' 
* append who controls earning from sale to customer 1 - PH
preserve
replace type_decision="control_annualsales" if  !inlist( sa3q12c1, .,0,99, 98) |  !inlist( sa3q12c2, .,0,99, 98) 
replace controller_income1=sa3q12c1 if !inlist( sa3q12c1, .,0,99, 98)  
replace controller_income2=sa3q12c2 if !inlist( sa3q12c2, .,0,99, 98)
keep if !inlist(sa3q12c1, .,0,99, 98) |  !inlist(sa3q12c2, .,0,99, 98)
keep hhid type_decision controller_income1 controller_income2
tempfile control_annualsales3
save `control_annualsales3'
restore
append using `control_annualsales3'
* append who controls earning from sale to customer 2 - PH
preserve
replace type_decision="control_annualsales" if  !inlist( sa3q17b1, .,0,99, 98) |  !inlist( sa3q17b2, .,0,99, 98) 
replace controller_income1=sa3q17b1 if !inlist( sa3q17b1, .,0,99, 98)  
replace controller_income2=sa3q17b2 if !inlist( sa3q17b2, .,0,99, 98)
keep if !inlist(sa3q17b1, .,0,99, 98) |  !inlist(sa3q17b2, .,0,99, 98)
keep hhid type_decision controller_income1 controller_income2
tempfile control_annualsales4
save `control_annualsales4'
restore
append using `control_annualsales4'
* control_livestocksales
replace type_decision="control_livestocksales" if  !inlist( sa6q19b1, .,0,99, 98) |  !inlist( sa6q19b2, .,0,99, 98) 
replace controller_income1=sa6q19b1 if !inlist(sa6q19b1, .,0,99, 98)  
replace controller_income2=sa6q19b2 if !inlist(sa6q19b2, .,0,99, 98)
* control_otherlivestock_sales (both in PP and PH)
replace type_decision="control_otherlivestock_sales" if ( !inlist( sa8q8a, .,0,99, 98) |  !inlist( sa8q8b, .,0,99, 98))  
replace controller_income1=sa8q8a if !inlist( sa8q8a, .,0,99, 98)   &  !inlist(byprod_cd, 6,7,8)
replace controller_income2=sa8q8b if !inlist( sa8q8b, .,0,99, 98) &  !inlist(byprod_cd, 6,7,8)
* append who controle earning from sales of processed crops PHs 
preserve
replace type_decision="control_otherlivestock_sales" if ( !inlist( s11kq7a, .,0,99, 98) |  !inlist( s11kq7b, .,0,99, 98) ) 
replace controller_income1=s11kq7a if !inlist( s11kq7a, .,0,99, 98) 
replace controller_income2=s11kq7b if !inlist( s11kq7b, .,0,99, 98) 
keep if (!inlist(s11kq7a, .,0,99, 98) |  !inlist(s11kq7b, .,0,99, 98)) 
keep hhid type_decision controller_income1 controller_income2
tempfile control_otherlivestock_sales2
save `control_otherlivestock_sales2'
restore
append using `control_otherlivestock_sales2' 
* control_businessincome
replace type_decision="control_businessincome" if  !inlist( s6q5a, .,0,99, 98) |  !inlist( s6q5b, .,0,99, 98) 
replace controller_income1=s6q5a if !inlist( s6q5a, .,0,99, 98)  
replace controller_income2=s6q5b if !inlist( s6q5b, .,0,99, 98)
* append who controle earning 
preserve
replace type_decision="control_businessincome" if  !inlist( s6q6a, .,0,99, 98) |  !inlist( s6q6b, .,0,99, 98) 
replace controller_income1=s6q6a if !inlist( s6q6a, .,0,99, 98)  
replace controller_income2=s6q6b if !inlist( s6q6b, .,0,99, 98)
keep if !inlist(s6q6a, .,0,99, 98) |  !inlist(s6q6b, .,0,99, 98)
keep hhid type_decision controller_income1 controller_income2
tempfile control_businessincome2
save `control_businessincome2'
restore
append using `control_businessincome2' 
* append who controle earning 
preserve
replace type_decision="control_businessincome" if  !inlist( s9q5a1, .,0,99, 98) |  !inlist( s9q5a2, .,0,99, 98) 
replace controller_income1=s9q5a1 if !inlist( s9q5a1, .,0,99, 98)  
replace controller_income2=s9q5a2 if !inlist( s9q5a2, .,0,99, 98)
keep if !inlist(s9q5a1, .,0,99, 98) |  !inlist(s9q5a2, .,0,99, 98)
keep hhid type_decision controller_income1 controller_income2
tempfile control_businessincome3
save `control_businessincome3'
restore
append using `control_businessincome3' 
* append who controle earning 
preserve
replace type_decision="control_businessincome" if  !inlist( s9q5b1, .,0,99, 98) |  !inlist( s9q5b2, .,0,99, 98) 
replace controller_income1=s9q5b1 if !inlist( s9q5b1, .,0,99, 98)  
replace controller_income2=s9q5b2 if !inlist( s9q5b2, .,0,99, 98)
keep if !inlist(s9q5b1, .,0,99, 98) |  !inlist(s9q5b2, .,0,99, 98)
keep hhid type_decision controller_income1 controller_income2
tempfile control_businessincome4
save `control_businessincome4'
restore
append using `control_businessincome4' 
* control_wageincome
replace type_decision="control_wageincome" if  !inlist( s3aq22a, .,0,99, 98) |  !inlist( s3aq22b, .,0,99, 98) 
replace controller_income1=s3aq22a if !inlist( s3aq22a, .,0,99, 98)  
replace controller_income2=s3aq22b if !inlist( s3aq22b, .,0,99, 98)
* append who controle earning 
preserve
replace type_decision="control_wageincome" if  !inlist( s3aq35a, .,0,99, 98) |  !inlist( s3aq35b, .,0,99, 98) 
replace controller_income1=s3aq35a if !inlist( s3aq35b, .,0,99, 98)  
replace controller_income2=s3aq35b if !inlist( s3aq35b, .,0,99, 98)
keep if !inlist(s3aq35a, .,0,99, 98) |  !inlist(s3aq35b, .,0,99, 98)
keep hhid type_decision controller_income1 controller_income2
tempfile control_wageincome2
save `control_wageincome2'
restore
append using `control_wageincome2'
* append who controle earning 
preserve
replace type_decision="control_wageincome" if  !inlist( s3aq18b1, .,0,99, 98) |  !inlist( s3aq18b2, .,0,99, 98) 
replace controller_income1=s3aq18b1 if !inlist( s3aq18b1, .,0,99, 98)  
replace controller_income2=s3aq18b2 if !inlist( s3aq18b2, .,0,99, 98)
keep if !inlist(s3aq18b1, .,0,99, 98) |  !inlist(s3aq18b2, .,0,99, 98)
keep hhid type_decision controller_income1 controller_income2
tempfile control_wageincome3
save `control_wageincome3'
restore
append using `control_wageincome3'
* append who controle earning 
preserve
replace type_decision="control_wageincome" if  !inlist( s3aq30b1, .,0,99, 98) |  !inlist( s3aq30b2, .,0,99, 98) 
replace controller_income1=s3aq30b1 if !inlist( s3aq30b1, .,0,99, 98)  
replace controller_income2=s3aq30b2 if !inlist( s3aq30b2, .,0,99, 98)
keep if !inlist(s3aq30b1, .,0,99, 98) |  !inlist(s3aq30b2, .,0,99, 98)
keep hhid type_decision controller_income1 controller_income2
tempfile control_wageincome4
save `control_wageincome4'
restore
append using `control_wageincome4'
* control_otherincome
replace type_decision="control_otherincome" if  !inlist( s10q3a, .,0,99, 98) |  !inlist( s10q3b, .,0,99, 98) 
replace controller_income1=s10q3a if !inlist( s10q3a, .,0,99, 98)  
replace controller_income2=s10q3b if !inlist( s10q3b, .,0,99, 98)
* append who controle other income 2 
preserve
replace type_decision="control_otherincome" if  !inlist( s13q2b1, .,0,99, 98) |  !inlist( s13q2b2, .,0,99, 98) 
replace controller_income1=s13q2b1 if !inlist( s13q5b1, .,0,99, 98)  
replace controller_income2=s13q2b2 if !inlist( s13q2b2, .,0,99, 98)
keep if !inlist(s13q2b1, .,0,99, 98) |  !inlist(s13q2b2, .,0,99, 98)
keep hhid type_decision controller_income1 controller_income2
tempfile control_otherincome2
save `control_otherincome2'
append using `control_otherincome2'
restore
* append who controle other income 3 
preserve
replace type_decision="control_otherincome" if  !inlist( s10q7a, .,0,99, 98) |  !inlist( s10q7b, .,0,99, 98) 
replace controller_income1=s10q7a if !inlist( s10q7a, .,0,99, 98)  
replace controller_income2=s10q7b if !inlist( s10q7b, .,0,99, 98)
keep if !inlist(s10q7a, .,0,99, 98) |  !inlist(s10q7b, .,0,99, 98)
keep hhid type_decision controller_income1 controller_income2
tempfile control_otherincome3
save `control_otherincome3'
restore
append using `control_otherincome3'
* append who controle other income 4 
preserve
replace type_decision="control_otherincome" if  !inlist( s13q5b1, .,0,99, 98) |  !inlist( s13q5b2, .,0,99, 98) 
replace controller_income1=s13q5b1 if !inlist( s13q5b1, .,0,99, 98)  
replace controller_income2=s13q5b2 if !inlist( s13q5b2, .,0,99, 98)
keep if !inlist(s13q5b1, .,0,99, 98) |  !inlist(s13q5b2, .,0,99, 98)
keep hhid type_decision controller_income1 controller_income2
tempfile control_otherincome4
save `control_otherincome4'
restore
append using `control_otherincome4'
* append who controle other income 5 
preserve
replace type_decision="control_otherincome" if  !inlist( s10q11a, .,0,99, 98) |  !inlist( s10q11b, .,0,99, 98) 
replace controller_income1=s10q11a if !inlist( s10q11a, .,0,99, 98)  
replace controller_income2=s10q11b if !inlist( s10q11b, .,0,99, 98)
keep if !inlist(s10q11a, .,0,99, 98) |  !inlist(s10q11b, .,0,99, 98)
keep hhid type_decision controller_income1 controller_income2
tempfile control_otherincome5
save `control_otherincome5'
restore
append using `control_otherincome5'
* append who controle other income 6 
preserve
replace type_decision="control_otherincome" if  !inlist( s13q8b1, .,0,99, 98) |  !inlist( s13q8b2, .,0,99, 98) 
replace controller_income1=s13q8b1 if !inlist( s13q8b1, .,0,99, 98)  
replace controller_income2=s13q8b2 if !inlist( s13q8b2, .,0,99, 98)
keep if !inlist(s13q8b1, .,0,99, 98) |  !inlist(s13q8b2, .,0,99, 98)
keep hhid type_decision controller_income1 controller_income2
tempfile control_otherincome6
save `control_otherincome6'
restore
append using `control_otherincome6'
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
 
* Create group
gen control_cropincome=1 if  type_decision=="control_harvest" ///
							| type_decision=="control_cropsales" ///
							| type_decision=="control_processedsales" 
recode 	control_cropincome (.=0)				
gen control_livestockincome=1 if  type_decision=="control_livestocksales" ///
							| type_decision=="control_otherlivestock_sales" 							
recode 	control_livestockincome (.=0)
gen control_farmincome=1 if  control_cropincome==1 | control_livestockincome==1							
recode 	control_farmincome (.=0)			
gen control_businessincome=1 if  type_decision=="control_businessincome" 
recode 	control_businessincome (.=0)												
gen control_wageincome=1 if  type_decision=="control_wageincome" 
recode 	control_wageincome (.=0)												
gen control_nonfarmincome=1 if  type_decision=="control_otherincome" ///
							  | control_businessincome== 1 | control_wageincome==1
recode 	control_nonfarmincome (.=0)															
collapse (max) control_* , by(hhid controller_income )  //any decision
gen control_all_income=1 if  control_farmincome== 1 | control_nonfarmincome==1
recode 	control_all_income (.=0)															
ren controller_income indiv
*	Now merge with member characteristics
merge 1:1 hhid indiv using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_person_ids.dta", nogen
recode control_* (.=0)
lab var control_cropincome "1=invidual has control over crop income"
lab var control_livestockincome "1=invidual has control over livestock income"
lab var control_farmincome "1=invidual has control over farm (crop or livestock) income"
lab var control_businessincome "1=invidual has control over business income"
lab var control_nonfarmincome "1=invidual has control over non-farm (business or remittances) income"
lab var control_all_income "1=invidual has control over at least one type of income"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_control_income.dta", replace



********************************************************************************
*WOMEN'S PARTICIPATION IN AGRICULTURAL DECISION MAKING
********************************************************************************
* Code as 1 if a woman is listed as one of the decision-makers for at least 2 plots, crops, or livestock activities; 
* can report on % of women who make decisions, taking total number of women HH members as denominator
* In most cases, NGA LSMS 2 lists the first TWO decision makers.
* Indicator may be biased downward if some women would participate in decisions but are not listed among the first two
* first append all files related to agricultural activities with income in who participate in the decision making
* planting_input	
use "${Nigeria_GHS_W2_raw_data}/sect11b1_plantingw2", clear
append using "${Nigeria_GHS_W2_raw_data}/sect11a_plantingw2"
append using "${Nigeria_GHS_W2_raw_data}/sect11d_plantingw2"
append using "${Nigeria_GHS_W2_raw_data}/sect11e_plantingw2"
append using "${Nigeria_GHS_W2_raw_data}/sect11h_plantingw2"
append using "${Nigeria_GHS_W2_raw_data}/sect11i_plantingw2"
append using "${Nigeria_GHS_W2_raw_data}/sect11k_plantingw2"
append using "${Nigeria_GHS_W2_raw_data}/secta1_harvestw2"
append using "${Nigeria_GHS_W2_raw_data}/secta3_harvestw2"
append using "${Nigeria_GHS_W2_raw_data}/secta6_harvestw2"
append using "${Nigeria_GHS_W2_raw_data}/secta8_harvestw2"
gen type_decision="" 
gen decision_maker1=.
gen decision_maker2=.
* planting_input - manage plot
replace type_decision="planting_input" if  !inlist( sa1q2, .,0,99, 98)
replace decision_maker1=sa1q2 if !inlist( sa1q2, .,0,99, 98)  
* append who make decision about plot
preserve
replace type_decision="planting_input" if   !inlist( sa1q11, .,0,99, 98) |  !inlist( sa1q11b, .,0,99, 98) 
replace decision_maker1=sa1q2 if !inlist( sa1q2, .,0,99, 98)  
replace decision_maker2=sa1q11 if !inlist( sa1q11, .,0,99, 98)
replace decision_maker2=sa1q11b if !inlist( sa1q11b, .,0,99, 98)
keep if  !inlist( sa1q2, .,0,99, 98) |  !inlist( sa1q11, .,0,99, 98) |  !inlist( sa1q11b, .,0,99, 98) 
keep hhid type_decision decision_maker*
tempfile planting_input2
save `planting_input2'
restore
append using `planting_input2'  
* append who paid for fertilizer 1
preserve
replace type_decision="planting_input" if  !inlist( s11dq13a, .,0,99, 98) |  !inlist( s11dq13b, .,0,99, 98)   
replace decision_maker1=s11dq13a if !inlist( s11dq13a, .,0,99, 98)  
replace decision_maker2=s11dq13b if !inlist( s11dq13b,.,0,99, 98)
keep if  !inlist( s11dq13a, .,0,99, 98) |  !inlist( s11dq13b, .,0,99, 98)  
keep hhid type_decision decision_maker*
tempfile planting_input3
save `planting_input3'
restore
append using `planting_input3'  
* append who paid fertilizer 2
preserve
replace type_decision="planting_input" if  !inlist( s11dq25a, .,0,99, 98) |  !inlist( s11dq25b, .,0,99, 98) 
replace decision_maker1=s11dq25a if !inlist( s11dq25a, .,0,99, 98)  
replace decision_maker2=s11dq25b if !inlist( s11dq25b, .,0,99, 98)
keep if  !inlist( s11dq25a, .,0,99, 98) |  !inlist( s11dq25b, .,0,99, 98)  
keep hhid type_decision decision_maker*
tempfile planting_input4
save `planting_input4'
restore
append using `planting_input4'
* append who paid for seeds 1
preserve
replace type_decision="planting_input" if  !inlist( s11eq15a, .,0,99, 98) |  !inlist( s11eq15b, .,0,99, 98) 
replace decision_maker1=s11eq15a if !inlist( s11eq15a, .,0,99, 98)  
replace decision_maker2=sa1q22b if !inlist( sa1q22b, .,0,99, 98)
replace decision_maker1=sa1q22c if !inlist( sa1q22c, .,0,99, 98)  
keep if  !inlist( s11eq15a, .,0,99, 98) |  !inlist( s11eq15b, .,0,99, 98)  
keep hhid type_decision decision_maker*
tempfile planting_input5
save `planting_input5'
restore
append using `planting_input5'
* append who paid for seeds 2
preserve
replace type_decision="planting_input" if  !inlist( s11eq27a, .,0,99, 98) |  !inlist( s11eq27b, .,0,99, 98) |  !inlist( sa1q24c, .,0,99, 98) 
replace decision_maker1=s11eq27a if !inlist( s11eq27a, .,0,99, 98)  
replace decision_maker2=s11eq27b if !inlist( s11eq27b, .,0,99, 98)
keep if  !inlist( s11eq27a, .,0,99, 98) |  !inlist( s11eq27b, .,0,99, 98) 
keep hhid type_decision decision_maker*
tempfile planting_input6
save `planting_input6'
restore
append using `planting_input6'
* append who make decision about plot from PH
preserve
replace type_decision="planting_input" if  !inlist( sa1q21, .,0,99, 98) |  !inlist( sa1q22a, .,0,99, 98) |  !inlist( sa1q22b, .,0,99, 98) |  !inlist( sa1q22c, .,0,99, 98) |  !inlist(sa1q22d, .,0,99, 98) 
replace decision_maker1=sa1q21  if !inlist( sa1q21, .,0,99, 98)  
replace decision_maker2=sa1q22a if !inlist( sa1q22a, .,0,99, 98)
replace decision_maker2=sa1q22b if !inlist( sa1q22b, .,0,99, 98)
replace decision_maker2=sa1q22c if !inlist( sa1q22c, .,0,99, 98)
replace decision_maker2=sa1q22d if !inlist( sa1q22d, .,0,99, 98)
keep if  !inlist( sa1q21, .,0,99, 98) |  !inlist( sa1q22a, .,0,99, 98) | !inlist( sa1q22b, .,0,99, 98) |  !inlist( sa1q22c, .,0,99, 98) |  !inlist( sa1q22d, .,0,99, 98) 
keep hhid type_decision decision_maker*
tempfile planting_input7
save `planting_input7'
restore
append using  `planting_input7'
* append who manage decision about plot from PH
preserve
replace type_decision="planting_input" if  !inlist( sa1q24a, .,0,99, 98) |  !inlist( sa1q24b, .,0,99, 98) |  !inlist( sa1q24c, .,0,99, 98) 
replace decision_maker1=sa1q24a  if !inlist( sa1q24a, .,0,99, 98)  
replace decision_maker2=sa1q24b if !inlist( sa1q24b, .,0,99, 98)
replace decision_maker2=sa1q24c if !inlist( sa1q24c, .,0,99, 98)
keep if  !inlist( sa1q24a, .,0,99, 98) |  !inlist( sa1q24b, .,0,99, 98) | !inlist( sa1q24c, .,0,99, 98)  
keep hhid type_decision decision_maker*
tempfile planting_input8
save `planting_input8'
restore
append using  `planting_input8'
*take crop to market
replace type_decision="sales_crop" if  !inlist( sa3q12b1, .,0,99, 98) |  !inlist( sa3q12b2, .,0,99, 98)  
replace decision_maker1=sa3q12b1 if !inlist( sa3q12b1, .,0,99, 98)  
replace decision_maker2=sa3q12b2 if !inlist( sa3q12b2, .,0,99, 98)
* sales_processcrop
replace type_decision="sales_processcrop" if  (!inlist( sa8q7a, .,0,99, 98) |  !inlist( sa8q7b, .,0,99, 98))  & inlist(byprod_cd, 6,7,8)
replace decision_maker1=sa8q7a if !inlist( sa8q7a, .,0,99, 98)  & inlist(byprod_cd, 6,7,8) 
replace decision_maker2=sa8q7b if !inlist( sa8q7b, .,0,99, 98)  & inlist(byprod_cd, 6,7,8)
* keep/manage livesock
replace type_decision="livestockowners" if  !inlist( s11iq5a, .,0,99, 98) |  !inlist( s11iq5b, .,0,99, 98)  
replace decision_maker1=s11iq5a if !inlist( s11iq5a, .,0,99, 98)  
replace decision_maker2=s11iq5b if !inlist( s11iq5b, .,0,99, 98)
* Append livestock owner
preserve
replace type_decision="livestockowners" if  !inlist( s11iq4a, .,0,99, 98) |  !inlist( s11iq4b, .,0,99, 98) 
replace decision_maker1=s11iq4a if !inlist( s11iq4a, .,0,99, 98)  
replace decision_maker2=s11iq4b if !inlist( s11iq4b, .,0,99, 98)
keep if  !inlist( s11iq4a, .,0,99, 98) |  !inlist( s11iq4b, .,0,99, 98)  
keep hhid type_decision decision_maker*
tempfile livestockowners2
save `livestockowners2'
restore
append using `livestockowners2' 
* Append livestock owner2
preserve
replace type_decision="livestockowners" if  !inlist( sa6q4a, .,0,99, 98) |  !inlist( sa6q4b, .,0,99, 98) 
replace decision_maker1=sa6q4a if !inlist( sa6q4a, .,0,99, 98)  
replace decision_maker2=sa6q4b if !inlist( sa6q4b, .,0,99, 98)
keep if  !inlist( sa6q4a, .,0,99, 98) |  !inlist( sa6q4b, .,0,99, 98)  
keep hhid type_decision decision_maker*
tempfile livestockowners2
save `livestockowners2'
restore
append using `livestockowners2'  
* Append livestock owner3
preserve
replace type_decision="livestockowners" if  !inlist( sa6q5a, .,0,99, 98) |  !inlist( sa6q5b, .,0,99, 98) 
replace decision_maker1=sa6q5a if !inlist( sa6q5a, .,0,99, 98)  
replace decision_maker2=sa6q5b if !inlist( sa6q5b, .,0,99, 98)
keep if  !inlist( sa6q5a, .,0,99, 98) |  !inlist( sa6q5b, .,0,99, 98)  
keep hhid type_decision decision_maker*
tempfile livestockowners2
save `livestockowners2'
restore
append using `livestockowners2'
keep hhid type_decision decision_maker1 decision_maker2  
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
bysort hhid decision_maker : egen nb_decision_participation=count(decision_maker)
drop if nb_decision_participation==1
*	Create group
gen make_decision_crop=1 if  type_decision=="planting_input" ///
							| type_decision=="harvest" ///
							| type_decision=="sales_crop" ///
							| type_decision=="sales_processcrop"
recode 	make_decision_crop (.=0)
gen make_decision_livestock=1 if  type_decision=="livestockowners" | type_decision=="otherlivestock_sales" 
recode 	make_decision_livestock (.=0)
gen make_decision_ag=1 if make_decision_crop==1 | make_decision_livestock==1
recode 	make_decision_ag (.=0)
collapse (max) make_decision_* , by(hhid decision_maker )  //any decision
ren decision_maker indiv 
*	Now merge with member characteristics
merge 1:1 hhid indiv using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_person_ids.dta", nogen
recode make_decision_* (.=0)
lab var make_decision_crop "1=invidual makes decision about crop production activities"
lab var make_decision_livestock "1=invidual makes decision about livestock production activities"
lab var make_decision_ag "1=invidual makes decision about agricultural (crop or livestock) production activities"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_make_ag_decision.dta", replace


********************************************************************************
*WOMEN'S OWNERSHIP OF ASSETS
********************************************************************************
* Code as 1 if a woman is sole or joint owner of any specified productive asset; 
* can report on % of women who own, taking total number of women HH members as denominator
* In most cases, NGA LSMS 2 as the first TWO owners.
* Indicator may be biased downward if some women would have been not listed among the two the first 2 asset-owners can also claim ownership of some assets
 
*First, append all files with information on asset ownership
use "${Nigeria_GHS_W2_raw_data}/sect11b1_plantingw2", clear
append using "${Nigeria_GHS_W2_raw_data}/sect11i_plantingw2"
append using "${Nigeria_GHS_W2_raw_data}/secta1_harvestw2"
append using "${Nigeria_GHS_W2_raw_data}/sect7_harvestw2", force
append using "${Nigeria_GHS_W2_raw_data}/secta6_harvestw2"
gen type_asset=""
gen asset_owner1=.
gen asset_owner2=. 
gen asset_owner3=. 
gen asset_owner4=. 
* Ownership of land.
replace type_asset="landowners" if  !inlist( s11b1q6a, .,0,99, 98) |  !inlist( s11b1q6b, .,0,99, 98) 
replace asset_owner1=s11b1q6a if !inlist( s11b1q6a, .,0,99, 98)  
replace asset_owner2=s11b1q6b if !inlist( s11b1q6b, .,0,99, 98)
replace type_asset="landowners" if  !inlist( sa1q14, .,0,99, 98) |  !inlist( sa1q14b, .,0,99, 98) 
replace asset_owner1=sa1q14 if !inlist( sa1q14, .,0,99, 98)  
replace asset_owner2=sa1q14b if !inlist( sa1q14b, .,0,99, 98)
* append who hss right to sell or use
preserve
replace type_asset="landowners" if  !inlist( s11b1q22a, .,0,99, 98) |  !inlist( s11b1q22b, .,0,99, 98)  |  !inlist( s11b1q22c, .,0,99, 98)
replace asset_owner1=s11b1q22a if !inlist( s11b1q22a, .,0,99, 98)  
replace asset_owner2=s11b1q22b if !inlist( s11b1q22b, .,0,99, 98)
replace asset_owner3=s11b1q22c if !inlist( s11b1q22c, .,0,99, 98)
replace type_asset="landowners" if  !inlist( sa1q18a, .,0,99, 98) |  !inlist( sa1q18b, .,0,99, 98)  |  !inlist( sa1q18c, .,0,99, 98)
replace asset_owner1=sa1q18a if !inlist( sa1q18a, .,0,99, 98)  
replace asset_owner2=sa1q18b if !inlist( sa1q18b, .,0,99, 98)
replace asset_owner3=sa1q18c if !inlist( sa1q18c, .,0,99, 98)
keep if  !inlist( s11b1q22a, .,0,99, 98) |  !inlist( s11b1q22b, .,0,99, 98)  |  !inlist( s11b1q22c, .,0,99, 98) |  !inlist( sa1q18a, .,0,99, 98) |  !inlist( sa1q18b, .,0,99, 98)  |  !inlist( sa1q18c, .,0,99, 98)
keep hhid type_asset asset_owner*
tempfile land2
save `land2'
restore
append using `land2'  
 
* Livestock owners
replace type_asset="livestockowners" if  !inlist( s11iq4a, .,0,99, 98) |  !inlist( s11iq4b, .,0,99, 98)  
replace asset_owner1=s11iq4a if !inlist( s11iq4a, .,0,99, 98)  
replace asset_owner2=s11iq4b if !inlist( s11iq4b, .,0,99, 98)
* Livestock owners
replace type_asset="livestockowners" if  !inlist( sa6q4a, .,0,99, 98) |  !inlist( sa6q4b, .,0,99, 98)  
replace asset_owner1=sa6q4a if !inlist( sa6q4a, .,0,99, 98)  
replace asset_owner2=sa6q4b if !inlist( sa6q4b, .,0,99, 98)
    	   
* AGRICULTURAL CAPITAL
replace type_asset="agcapialowner" if  !inlist( s7q8a, .,0,99, 98) |  !inlist( s7q8b, .,0,99, 98) |  !inlist( s7q8c, .,0,99, 98)  
replace asset_owner1=s7q8a if !inlist( s7q8a, .,0,99, 98)  
replace asset_owner2=s7q8b if !inlist( s7q8b, .,0,99, 98)
replace asset_owner3=s7q8c if !inlist( s7q8c, .,0,99, 98)      	
keep hhid type_asset asset_owner1  asset_owner2 asset_owner3 asset_owner4  
 
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
collapse (max) own_asset, by(hhid asset_owner)
ren asset_owner indiv
*	Now merge with member characteristics
merge 1:1 hhid indiv using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_person_ids.dta", nogen
recode own_asset (.=0)
lab var own_asset "1=invidual owns an assets (land or livestock)"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_ownasset.dta", replace


********************************************************************************
*AGRICULTURAL WAGES
********************************************************************************
*All preprocessing done in ag expenses
use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_labor_long.dta", clear
keep if strmatch(labor_type,"hired") & (strmatch(gender,"male") | strmatch(gender,"female"))
collapse (sum) wage_paid_aglabor_=val hired_=number, by(hhid gender)
reshape wide wage_paid_aglabor_ hired_, i(hhid) j(gender) string
egen wage_paid_aglabor = rowtotal(wage*)
egen hired_all = rowtotal(hired*)
lab var wage_paid_aglabor "Daily agricultural wage paid for hired labor (local currency)"
lab var wage_paid_aglabor_female "Daily agricultural wage paid for hired labor - female workers(local currency)"
lab var wage_paid_aglabor_male "Daily agricultural wage paid for hired labor - male workers (local currency)"
lab var hired_all "Total hired labor (number of persons)"
lab var hired_female "Total hired labor (number of persons) -female workers"
lab var hired_male "Total hired labor (number of persons) -male workers"
//keep hhid wage_paid_aglabor wage_paid_aglabor_female wage_paid_aglabor_male //Why did we get number of persons only to drop it at the end?
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_ag_wage.dta", replace

********************************************************************************
*CROP YIELDS
********************************************************************************
//ALT: This section is still here for legacy file compatibility; the data have already been generated by this point, it's just a matter of reshaping them into a format that later code will accept. With some modification to the final variables code, this section could be shortened significantly.
/*File structure:
	in hh_crop_area_plan.dta (by hhid crop_code):
		Prefixes:
			harvest (= kgs harvest??) 
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

use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_all_plots.dta", clear
ren crop_code_master crop_code
gen number_trees_planted_banana = number_trees_planted if crop_code==2030 
gen number_trees_planted_cassava = number_trees_planted if crop_code==1020 
gen number_trees_planted_cocoa = number_trees_planted if crop_code==3040
recode number_trees_planted_banana number_trees_planted_cassava number_trees_planted_cocoa (.=0) 
collapse (sum) number_trees_planted*, by(hhid)
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_trees.dta", replace

use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_all_plots.dta", clear
ren crop_code_master crop_code
//Legacy stuff- agquery gets handled above.
collapse (sum) area_harv_=ha_harvest area_plan_=ha_planted harvest_=quant_harv_kg, by(hhid dm_gender purestand crop_code)
gen mixed = "inter" if purestand==0
replace mixed="pure" if purestand==1
gen dm_gender2="male"
replace dm_gender2="female" if dm_gender==2
replace dm_gender2="mixed" if dm_gender==3
drop dm_gender purestand
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
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_crop_area_plan.dta", replace


*Total planted and harvested area summed accross all plots, crops, and seasons.
preserve
	collapse (sum) all_area_harvested=area_harv all_area_planted=area_plan, by(hhid)
	replace all_area_harvested=all_area_planted if all_area_harvested>all_area_planted & all_area_harvested!=.
	save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_area_planted_harvested_allcrops.dta", replace
restore
keep if inlist(crop_code, $comma_topcrop_area)
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_crop_harvest_area_yield.dta", replace

*Yield at the household level
use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_crop_harvest_area_yield.dta", clear
*Value of crop production
merge m:1 crop_code using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_cropname_table.dta", nogen keep(1 3)
merge 1:1 hhid crop_code using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_crop_values_production.dta", nogen keep(1 3)
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
merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_trees.dta"
collapse (sum) harvest* area_harv*  area_plan* total_planted_area* total_harv_area* kgs_harvest*   value_harv* value_sold* number_trees_planted*  , by(hhid) 
recode harvest*   area_harv* area_plan* kgs_harvest* total_planted_area* total_harv_area*    value_harv* value_sold* (0=.)
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

foreach p of global topcropname_area {
	gen grew_`p'=(total_harv_area_`p'!=. & total_harv_area_`p'!=.0 ) | (total_planted_area_`p'!=. & total_planted_area_`p'!=.0)
	lab var grew_`p' "1=Household grew `p'" 
	gen harvested_`p'= (total_harv_area_`p'!=. & total_harv_area_`p'!=.0 )
	lab var harvested_`p' "1= Household harvested `p'"
}
replace grew_banana =1 if  number_trees_planted_banana!=0 & number_trees_planted_banana!=. 
replace grew_cassav =1 if number_trees_planted_cassava!=0 & number_trees_planted_cassava!=. 
replace grew_cocoa =1 if number_trees_planted_cocoa!=0 & number_trees_planted_cocoa!=. 
//drop harvest- harvest_pure_mixed area_harv- area_harv_pure_mixed area_plan- area_plan_pure_mixed value_harv value_sold total_planted_area total_harv_area  
//ALT 08.16.21: No drops necessary; only variables here are the ones that are listed in the labeling block above.
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_yield_hh_crop_level.dta", replace
 



* VALUE OF CROP PRODUCTION  // using 335 output
use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_crop_values_production.dta", clear
*Grouping following IMPACT categories but also mindful of the consumption categories.
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
replace crop_group=	"Vegetables"	if crop_code==	2101
replace crop_group=	"Vegetables"	if crop_code==	2102
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
replace crop_group=	"Other other"	if crop_code==	9999

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
replace type_commodity=	"Low"	if crop_code==	1053
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
replace type_commodity=	"Low"	if crop_code==	2120
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
replace type_commodity=	"Low"	if crop_code==	3062
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
replace type_commodity=	"Low"	if crop_code==	9999
*/

* CJS 10.21 revising commodity high/low classification
replace type_commodity=	"High"	if crop_code==	1010
replace type_commodity=	"Low"	if crop_code==	1020
replace type_commodity=	"Low"	if crop_code==	1040
replace type_commodity=	"Out"	if crop_code==	1050
replace type_commodity=	"Out"	if crop_code==	1051
replace type_commodity=	"Out"	if crop_code==	1052
replace type_commodity=	"Out"	if crop_code==	1053
replace type_commodity=	"High"	if crop_code==	1060
replace type_commodity=	"High"	if crop_code==	1061
replace type_commodity=	"High"	if crop_code==	1062
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
replace type_commodity=	"High"	if crop_code==	1110
replace type_commodity=	"High"	if crop_code==	1111
replace type_commodity=	"High"	if crop_code==	1112
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
replace type_commodity=	"High"	if crop_code==	2101
replace type_commodity=	"High"	if crop_code==	2102
replace type_commodity=	"High"	if crop_code==	2103
replace type_commodity=	"Out"	if crop_code==	2110
replace type_commodity=	"High"	if crop_code==	2120
replace type_commodity=	"High"	if crop_code==	2130
replace type_commodity=	"High"	if crop_code==	2140
replace type_commodity=	"High"	if crop_code==	2141
replace type_commodity=	"High"	if crop_code==	2142
replace type_commodity=	"Out"	if crop_code==	2143
replace type_commodity=	"High"	if crop_code==	2150
replace type_commodity=	"High"	if crop_code==	2160
replace type_commodity=	"Low"	if crop_code==	2170
replace type_commodity=	"Low"	if crop_code==	2180
replace type_commodity=	"Low"	if crop_code==	2181
replace type_commodity=	"High"	if crop_code==	2190
replace type_commodity=	"High"	if crop_code==	2191
replace type_commodity=	"High"	if crop_code==	2192
replace type_commodity=	"High"	if crop_code==	2193
replace type_commodity=	"High"	if crop_code==	2194
replace type_commodity=	"High"	if crop_code==	2195
replace type_commodity=	"Low"	if crop_code==	2200
replace type_commodity=	"High"	if crop_code==	2210
replace type_commodity=	"High"	if crop_code==	2220
replace type_commodity=	"Out"	if crop_code==	2230
replace type_commodity=	"Out"	if crop_code==	2240
replace type_commodity=	"Out"	if crop_code==	2250
replace type_commodity=	"High"	if crop_code==	2260
replace type_commodity=	"High"	if crop_code==	2270
replace type_commodity=	"Low"	if crop_code==	2280
replace type_commodity=	"Out"	if crop_code==	2290
replace type_commodity=	"Out"	if crop_code==	2291
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
replace type_commodity=	"Out"	if crop_code==	3100
replace type_commodity=	"High"	if crop_code==	3110
replace type_commodity=	"High"	if crop_code==	3111
replace type_commodity=	"High"	if crop_code==	3112
replace type_commodity=	"High"	if crop_code==	3113
replace type_commodity=	"High"	if crop_code==	3120
replace type_commodity=	"High"	if crop_code==	3130
replace type_commodity=	"High"	if crop_code==	3140
replace type_commodity=	"High"	if crop_code==	3150
replace type_commodity=	"High"	if crop_code==	3160
replace type_commodity=	"High"	if crop_code==	3170
replace type_commodity=	"Out"	if crop_code==	3180
replace type_commodity=	"High"	if crop_code==	3181
replace type_commodity=	"High"	if crop_code==	3182
replace type_commodity=	"Out"	if crop_code==	3183
replace type_commodity=	"Out"	if crop_code==	3184
replace type_commodity=	"High"	if crop_code==	3190
replace type_commodity=	"High"	if crop_code==	3200
replace type_commodity=	"High"	if crop_code==	3210
replace type_commodity=	"High"	if crop_code==	3220
replace type_commodity=	"High"	if crop_code==	3221
replace type_commodity=	"Out"	if crop_code==	3230
replace type_commodity=	"Out"	if crop_code==	3231
replace type_commodity=	"Out"	if crop_code==	3232
replace type_commodity=	"High"	if crop_code==	3240
replace type_commodity=	"High"	if crop_code==	3250
replace type_commodity=	"High"	if crop_code==	3260
replace type_commodity=	"Out"	if crop_code==	9999

preserve
//ALT 10.27.21: These codes were wrong; updated. Do we want to omit coffee and tea?
collapse (sum) value_crop_production value_crop_sales, by( hhid commodity) 
ren value_crop_production value_pro
ren value_crop_sales value_sal
separate value_pro, by(commodity)
separate value_sal, by(commodity)
foreach s in pro sal {
	ren value_`s'1 value_`s'_bana
	ren value_`s'2 value_`s'_beanc
	ren value_`s'3 value_`s'_casav
	ren value_`s'4 value_`s'_cocoa
	ren value_`s'5 value_`s'_cyam
	ren value_`s'6 value_`s'_coffee //ALT added
	ren value_`s'7 value_`s'_coton
	ren value_`s'8 value_`s'_fruit 
	ren value_`s'9 value_`s'_gdnut
	ren value_`s'10 value_`s'_maize 
	ren value_`s'11 value_`s'_mill 
	ren value_`s'12 value_`s'_oilc 
	ren value_`s'13 value_`s'_onuts
	ren value_`s'14 value_`s'_oths 
	ren value_`s'15 value_`s'_plant  
	ren value_`s'16 value_`s'_pota  
	ren value_`s'17 value_`s'_rice 
	ren value_`s'18 value_`s'_sorg 
	ren value_`s'19 value_`s'_sybea
	ren value_`s'20 value_`s'_spice
	ren value_`s'21 value_`s'_suga
	ren value_`s'22 value_`s'_spota
	ren value_`s'24 value_`s'_vegs
	ren value_`s'25 value_`s'_whea 
	ren value_`s'26 value_`s'_yam
} 

foreach x of varlist value_pro_* {
	local l`x':var label `x'
	local l`x'= subinstr("`l`x''","value_pro, commodity == ","Value of production, ",.) 
	lab var `x' "`l`x''"
}
foreach x of varlist value_sal_* {
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
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_crop_values_production_grouped.dta", replace
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
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_crop_values_production_type_crop.dta", replace
*End DYA 9.13.2020 


********************************************************************************
*SHANNON DIVERSITY INDEX
********************************************************************************
*Area planted
*Bringing in area planted for LRS
use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_crop_area_plan.dta", clear
*Some households have crop observations, but the area planted=0. These are permanent crops. Right now they are not included in the SDI unless they are the only crop on the plot, but we could include them by estimating an area based on the number of trees planted
drop if area_plan==0
*generating area planted of each crop as a proportion of the total area
preserve 
collapse (sum) area_plan_hh=area_plan area_plan_female_hh=area_plan_female area_plan_male_hh=area_plan_male area_plan_mixed_hh=area_plan_mixed, by(hhid)
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_crop_area_plan_shannon.dta", replace
restore

merge m:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_crop_area_plan_shannon.dta", nogen		//all matched
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
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_shannon_diversity_index.dta", replace 

 
********************************************************************************
*CONSUMPTION
******************************************************************************** 
use "${Nigeria_GHS_W2_raw_data}/PTrack.dta", clear
ren sex gender
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
collapse (sum) adulteq, by(hhid)
lab var adulteq "Adult-Equivalent"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_adulteq.dta", replace 


use "${Nigeria_GHS_W2_raw_data}/cons_agg_wave2_visit1.dta", clear
ren  totcons totcons_v1
merge 1:1 hhid using "${Nigeria_GHS_W2_raw_data}/cons_agg_wave2_visit2.dta", nogen
ren  totcons totcons_v2
merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_adulteq.dta"
*use "${Nigeria_GHS_W2_raw_data}/cons_agg_w2.dta", clear
*Per the Nigeria BID in Wave 2, we should average the consumption aggregat for the tow visits
egen totcons=rowmean(totcons_v1 totcons_v2)  
gen percapita_cons = totcons
gen daily_percap_cons = percapita_cons/365
gen total_cons = (totcons *hhsize)
gen peraeq_cons = total_cons/adulteq
gen daily_peraeq_cons = peraeq_cons/365
la var percapita_cons "Yearly HH consumption per person"	
la var total_cons "Total yearly HH consumption - averaged over two visits"								
la var peraeq_cons "Yearly HH consumption per adult equivalent"				
la var daily_peraeq_cons "Daily HH consumption per adult equivalent"		
la var daily_percap_cons "Daily HH consumption per person" 		
keep hhid adulteq totcons percapita_cons daily_percap_cons total_cons peraeq_cons daily_peraeq_cons 
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_consumption.dta", replace
 
  
********************************************************************************
*HOUSEHOLD FOOD PROVISION*
********************************************************************************
use "${Nigeria_GHS_W2_raw_data}/sect12_harvestw2.dta", clear
foreach i in a b c d e f{
	gen food_insecurity_`i' = (s12q6`i'!=.)
}
egen months_food_insec = rowtotal (food_insecurity_*) 
keep hhid food_insecurity_* months_food_insec
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_food_insecurity.dta", replace


********************************************************************************
*HOUSEHOLD ASSETS*
********************************************************************************
use "${Nigeria_GHS_W2_raw_data}/sect5b_plantingw2.dta", clear
ren s5q4 value_today
ren s5q3 age_item
collapse (sum) value_assets=value_today, by(hhid)
la var value_assets "Value of household assets"
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_assets.dta", replace 

	*********************************
	*		FOOD SECURITY			*
	*********************************
**Part of poverty estimation, imported from W4

use "${Nigeria_GHS_W2_raw_data}/cons_agg_wave2_visit1.dta", clear
drop totcons
egen fdconstot = rowtotal(fd*)
keep hhid fd*
ren fd* fd*_pp
tempfile visit1
save `visit1'
use "${Nigeria_GHS_W2_raw_data}/cons_agg_wave2_visit2.dta",	clear
drop totcons
egen fdconstot = rowtotal(fd*)
keep hhid fd* 
ren fd* fd*_ph
merge 1:1 hhid using `visit1', nogen
merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_adulteq.dta", nogen keep(1 3)
merge 1:1 hhid using  "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hhsize.dta", nogen keep(1 3)
replace fdconstot_ph = fdconstot_pp if fdconstot_ph == . | fdconstot_ph==0
drop if adulteq==.
recode fdconstot_pp fdconstot_ph (0=.)
reshape long fdconstot_, i(hhid) j(season) string
ren fdconstot_ fdconstot
gen daily_peraeq_fdcons = fdconstot/adulteq/365
gen daily_percap_fdcons = fdconstot/hh_members/365
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_food_cons.dta", replace
keep hhid daily* season
ren daily* daily*_ 
reshape wide daily*_, i(hhid) j(season) string
//drop if daily_peraeq_fdcons_ph > 7000 | daily_peraeq_fdcons_pp > 7000 //Outliers.
tempfile fdcons
save `fdcons'
	
use "${Nigeria_GHS_W2_raw_data}/sect9_plantingw2.dta", clear
//drop s9q8a
recode s9q1* s9q5 (.=0) (2=0) 
egen dep_food = rowmax(s9q1* s9q5) 
egen total_dep_food = rowtotal(s9q1* s9q5)
gen calor_insuf = s9q1d==1 | s9q1e == 1 | s9q1f == 1 | s9q1g == 1 | s9q1h == 1 | s9q1i == 1 | s9q5==1
gen nutr_insuf = calor_insuf==0 & (s9q1b==1 | s9q1c==1)
gen precarious = nutr_insuf == 0 & calor_insuf==0 & (s9q1a==1)
gen secure=precarious==0 & calor_insuf==0 & nutr_insuf==0

keep hhid dep_food total_dep_food calor_insuf nutr_insuf precarious secure
merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_food_insecurity.dta", nogen
merge 1:1 hhid using `fdcons', nogen
drop if daily_peraeq_fdcons_pp==. //Not sure what the missing values here signify.
egen min_fdcons = rowmin(daily_peraeq_fdcons_*) //Get lowest
egen max_fdcons = rowmax(daily_peraeq_fdcons_*) 
gen avg_fdcons = (daily_peraeq_fdcons_ph + daily_peraeq_fdcons_pp)/2
save "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_food_dep.dta", replace

	********************************************************************************
	*HOUSEHOLD VARIABLES
	********************************************************************************
	global empty_vars ""
	global topcropname_area_full  "maize rice wheat sorgum millet cowpea grdnt beans yam swtptt cassav banana cocoa soy" //adding beans and wheat becuase they are not included in Nigieria

	use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_weights.dta", clear

	*Gross crop income 
	merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_crop_production.dta", nogen keep(1 3)
	recode value_crop_production (.=0)


	*Start DYA 9.13.2020 
	* Production by group and type of crops
	merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_crop_values_production_grouped.dta", nogen
	merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_crop_values_production_type_crop.dta", nogen
	recode value_pro* value_sal* (.=0)
	*End DYA 9.13.2020 

	merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_cost_inputs.dta", nogen

	*Crop costs
	//Merge in summarized crop costs:
	gen crop_production_expenses = cost_expli_hh
	gen crop_income = value_crop_production - crop_production_expenses
	lab var crop_production_expenses "Crop production expenditures (explicit)"
	lab var crop_income "Net crop revenue (value of production minus crop expenses)"
	*top crop costs by area planted
	foreach c in $topcropname_area {
		merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_inputs_`c'.dta", nogen
		merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_`c'_monocrop_hh_area.dta",nogen
	}

	foreach c in $topcropname_area {
		recode `c'_monocrop (.=0) 
		//egen `c'_exp = rowtotal(val_anml_`c' val_mech_`c' val_labor_`c' val_herb_`c' val_inorg_`c' val_orgfert_`c' val_plotrent_`c' val_seeds_`c' val_transfert_`c' val_seedtrans_`c') //Need to be careful to avoid including val_harv
		//lab var `c'_exp "Crop production expenditures (explicit) - Monocropped `c' plots only"
		//la var `c'_monocrop_ha "Total `c' monocrop hectares planted - Household" 

	*disaggregate by gender of plot manager
	foreach i in male female mixed hh {
		egen `c'_exp_`i' = rowtotal(val_anml_`c'_`i' val_mech_`c'_`i' val_labor_`c'_`i' val_herb_`c'_`i' val_inorg_`c'_`i' /*val_orgfert_`c'_`i'*/ val_plotrent_`c'_`i' val_seeds_`c'_`i' val_transfert_`c'_`i' val_seedtrans_`c'_`i') //These are already narrowed to explicit costs
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
	//ALT 07.30.24: This line is causing an error 
	//drop rental_cost_land* cost_seed* value_fertilizer* cost_trans_fert* value_herbicide* value_pesticide* value_manure_purch* cost_trans_manure*
	drop val_anml* val_mech* val_labor* val_herb* val_inorg* /*val_orgfert**/ val_plotrent* val_seeds* val_transfert* val_seedtrans* //
	*Land rights
	merge 1:1 hhid using  "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_land_rights_hh.dta", nogen keep(1 3)
	la var formal_land_rights_hh "Household has documentation of land rights (at least one plot)"

	*Fish income
	merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_fish_income.dta", nogen keep(1 3)
	merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_fishing_expenses_1.dta", nogen keep(1 3)
	merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_fishing_expenses_2.dta", nogen keep(1 3)
	gen fish_income_fishfarm = value_fish_harvest - fish_expenses_1 - fish_expenses_2
	gen fish_income_fishing = value_fish_caught - fish_expenses_1 - fish_expenses_2
	gen fishing_income = fish_income_fishing
	recode fishing_income fish_income_fishing fish_income_fishfarm (.=0)
	lab var fish_income_fishing "Net fishing income (value of production and consumption minus expenditures)"
	lab var fish_income_fishfarm "Net fish farm income (value of production minus expenditures)"
	lab var fishing_income "Net fishing income (value of production and consumption minus expenditures)"

	*Livestock income
	merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_livestock_sales.dta", nogen keep(1 3)
	merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_livestock_expenses.dta", nogen keep(1 3)
	merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_livestock_products.dta", nogen keep(1 3)
	merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_TLU.dta", nogen keep(1 3)
	merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_herd_characteristics.dta", nogen keep(1 3)
	recode value_livestock_sales value_livestock_purchases value_milk_produced  value_eggs_produced value_other_produced fish_income_fishfarm  cost_*livestock (.=0)
	*merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_TLU_Coefficients.dta", nogen keep(1 3)
	merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_TLU_Coefficients_wlargerum_061623.dta", nogen keep (1 3) // HKS 6.16.23

	gen livestock_income = value_slaughtered + value_lvstck_sold - value_livestock_purchases /*
	*/ + ( value_milk_produced + value_eggs_produced + value_other_produced) /*
	*/ - ( cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_other_livestock) + fish_income_fishfarm
	recode livestock_income (.=0)
	recode value_milk_produced value_eggs_produced (0=.)
	lab var livestock_income "Net livestock income (value of production and consumption minus expenditures)"
	gen livestock_expenses = ( cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_other_livestock)
	lab var livestock_expenses "Expenditures on livestock purchases and maintenance"
	ren cost_vaccines_livestock ls_exp_vac 
	gen livestock_product_revenue = ( value_milk_produced + value_eggs_produced + value_other_produced)
	lab var livestock_product_revenue "Gross revenue from sale of livestock products"
	lab var sales_livestock_products "Value of sales of livestock products"
	lab var value_livestock_products "Value of livestock products"
	gen any_imp_herd_all = . 
	foreach v in ls_exp_vac any_imp_herd{
	foreach i in lrum srum poultry {
		gen `v'_`i' = .
		}
	}
	global empty_vars $empty_vars ls_exp_vac_* any_imp_herd_* use_fin_serv_digital

	*Self-employment income
	merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_self_employment_income.dta", nogen keep(1 3)
	merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_agproduct_income.dta", nogen keep(1 3)
	egen self_employment_income = rowtotal(profit_processed_crop_sold annual_selfemp_profit)
	recode self_employment_income (.=0)
	lab var self_employment_income "Income from self-employment (business)"

	*Wage income
	merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_agwage_income.dta", nogen keep(1 3)
	merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_wage_income.dta", nogen keep(1 3)
	recode annual_salary annual_salary_agwage (.=0)
	ren annual_salary nonagwage_income
	ren annual_salary_agwage agwage_income

	*Off-farm hours
	merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_off_farm_hours.dta", nogen keep(1 3)

	*Other income
	merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_other_income.dta", nogen keep(1 3)
	merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_remittance_income.dta", nogen keep(1 3)
	merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_other_income.dta", nogen keep(1 3)
	egen transfers_income = rowtotal (remittance_income assistance_income)
	lab var transfers_income "Income from transfers including pension, remittances, and assisances)"
	egen all_other_income = rowtotal (investment_income rental_income_buildings other_income  rental_income_assets)
	lab var all_other_income "Income from other revenue streams not captured elsewhere"
	drop other_income

	*Farm size
	merge 1:1 hhid using  "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_land_size.dta", nogen keep(1 3)
	merge 1:1 hhid using  "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_land_size_all.dta", nogen keep(1 3)
	merge 1:1 hhid using  "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_farmsize_all_agland.dta", nogen keep(1 3)
	merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_land_size_total.dta", nogen
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
merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_family_hired_labor.dta", nogen keep(1 3)
recode labor_hired labor_family (.=0) 

*Household size
merge 1:1 hhid using  "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hhsize.dta", nogen keep(1 3)
 
*Rates of vaccine usage, improved seeds, etc.
merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_vaccine.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_input_use.dta", nogen keep(1 3)
//merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_improvedseed_use.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_any_ext.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_fin_serv.dta", nogen keep(1 3)
recode use_fin_serv* ext_reach* use_inorg_fert vac_animal (.=0)
replace vac_animal=. if tlu_today==0 
replace use_inorg_fert=. if farm_area==0 | farm_area==. // Area cultivated this year
recode ext_reach* (0 1=.) if (value_crop_production==0 & livestock_income==0 & farm_area==0 & farm_area==. &  tlu_today==0)
global empty_vars $empty_vars *seed* 
 
*Milk productivity
merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_milk_animals.dta", nogen keep(1 3)
gen costs_dairy = .
gen costs_dairy_percow = .
gen share_imp_dairy = . 
gen liters_per_cow= .
gen liters_per_buffalo= . 
gen milk_animals = . 
global empty_vars $empty_vars *costs_dairy* *costs_dairy_percow* share_imp_dairy *liters_per_cow *liters_per_buffalo milk_animals
**# Bookmark #1

*Egg productivity
merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_egg_animals.dta", nogen keep(1 3)
gen liters_milk_produced = milk_months_produced * milk_quantity_produced
lab var liters_milk_produced "Total quantity (liters) of milk per year (household)"
gen eggs_total_year =eggs_quantity_produced * eggs_months_produced
lab var eggs_total_year "Total number of eggs that was produced (household)"
//gen egg_poultry_year = .
//gen poultry_owned = .
global empty_vars $empty_vars *egg_poultry_year poultry_owned
 
*Costs of crop production per hectare
merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_cropcosts.dta", nogen keep(1 3)
 
*Rate of fertilizer application 
merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_fertilizer_application.dta", nogen keep(1 3)

*Agricultural wage rate
merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_ag_wage.dta", nogen keep(1 3)

*Crop yields 
merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_yield_hh_crop_level.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_area_planted_harvested_allcrops.dta", nogen keep(1 3)
  
*Household diet
merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_household_diet.dta", nogen keep(1 3)

*Consumption
merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_consumption.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_adulteq.dta", nogen keep(1 3)

*Household assets
merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hh_assets.dta", nogen keep(1 3)

*Food insecurity
merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_food_insecurity.dta", nogen keep(1 3)
gen hhs_little = . 
gen hhs_moderate = . 
gen hhs_severe = . 
gen hhs_total = . 
global empty_vars $empty_vars hhs_* 

*Distance to agrodealer // cannot construct 
gen dist_agrodealer = . 
global empty_vars $empty_vars *dist_agrodealer
 
*Shannon Diversity index
merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_shannon_diversity_index.dta", nogen keep(1 3)

*Livestock health
merge 1:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_livestock_diseases.dta", nogen keep(1 3)

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
global empty_vars $empty_vars feed_grazing* water_source_* lvstck_housed*

*Farm Production 
recode value_crop_production  value_livestock_products value_slaughtered  value_lvstck_sold (.=0)
gen value_farm_production = value_crop_production + value_livestock_products + value_slaughtered + value_lvstck_sold
lab var value_farm_production "Total value of farm production (crops + livestock products)"
gen value_farm_prod_sold = value_crop_sales + sales_livestock_products + value_livestock_sales 
lab var value_farm_prod_sold "Total value of farm production that is sold" 
replace value_farm_prod_sold = 0 if value_farm_prod_sold==. & value_farm_production!=.


*Agricultural households
recode value_crop_production crop_income livestock_income farm_area tlu_today land_size farm_size_agland (.=0)  //DYA 09.25.19
gen ag_hh = (value_crop_production!=0 | crop_income!=0 | livestock_income!=0 | farm_area!=0 | tlu_today!=0)
lab var ag_hh "1= Household has some land cultivated, some livestock, some crop income, or some livestock income"
replace  ag_hh=0 if ag_hh==1 & crop_income!=0 & (land_size==0 | land_size==.)    //DYA 09.25.19 

*household with egg-producing animals  
gen egg_hh = (value_eggs_produced>0 & value_eggs_produced!=.)
lab var egg_hh "1=Household engaged in egg production"
*household engaged in dairy production
gen dairy_hh = (value_milk_produced>0 & value_milk_produced!=.)
lab var dairy_hh "1= Household engaged in dairy production" 

*Households engage in ag activities including working in paid ag jobs
gen agactivities_hh =ag_hh==1 | (agwage_income!=0 & agwage_income!=.)
lab var agactivities_hh "1=Household has some land cultivated, livestock, crop income, livestock income, or ag wage income"


*creating crop households and livestock households
gen crop_hh = (value_crop_production!=0  | farm_area!=0 | farm_size_agland!=0) //DYA 09.25.19
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
*households engaged in crop production
recode cost_expli_hh value_crop_production value_crop_sales labor_hired labor_family farm_size_agland all_area_harvested all_area_planted encs num_crops_hh multiple_crops (.=0) if crop_hh==1
recode cost_expli_hh value_crop_production value_crop_sales labor_hired labor_family farm_size_agland all_area_harvested all_area_planted encs num_crops_hh multiple_crops (nonmissing=.) if crop_hh==0
*all rural households engaged in livestock production 
recode animals_lost_agseas* mean_agseas* livestock_expenses (.=0) if livestock_hh==1
recode animals_lost_agseas* mean_agseas* livestock_expenses (nonmissing=.) if livestock_hh==0
*all rural households 
recode /*DYA.10.26.2020*/ hrs_ag_activ hrs_wage_off_farm hrs_wage_on_farm hrs_unpaid_off_farm hrs_domest_fire_fuel hrs_off_farm hrs_on_farm hrs_domest_all hrs_other_all hrs_self_off_farm crop_income livestock_income self_employment_income nonagwage_income agwage_income fishing_income transfers_income all_other_income value_assets (.=0)
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
*/ animals_lost_agseas* mean_agseas* lost_disease* /*
*/ liters_milk_produced costs_dairy /*
*/ eggs_total_year value_eggs_produced value_milk_produced /*
*/ /*DYA.10.26.2020*/ hrs_ag_activ hrs_wage_off_farm hrs_wage_on_farm hrs_unpaid_off_farm hrs_domest_fire_fuel hrs_off_farm hrs_on_farm hrs_domest_all hrs_other_all hrs_self_off_farm  crop_production_expenses value_assets cost_expli_hh /*
*/ livestock_expenses ls_exp_vac* sales_livestock_products value_livestock_products value_livestock_sales /*
*/ value_farm_production value_farm_prod_sold   value_pro* value_sal*

gen wage_paid_aglabor_mixed=. //create this just to make the loop work and delete after
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
gen cost_total = cost_total_hh
gen cost_expli = cost_expli_hh //ALT 08.04.21: Kludge til I get names fully consistent
global wins_var_top1_gender $wins_var_top1_gender cost_total cost_expli fert_inorg_kg wage_paid_aglabor

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
* gen labor_total  as sum of winsorized labor_hired and labor_family
egen w_labor_total=rowtotal(w_labor_hired w_labor_family)
local llabor_total : var lab labor_total 
lab var w_labor_total "`labor_total' - Winzorized top 1%"

*Variables winsorized both at the top 1% and bottom 1% 
global wins_var_top1_bott1  /* 
*/ farm_area farm_size_agland all_area_harvested all_area_planted ha_planted /*
*/ crop_income livestock_income fishing_income self_employment_income nonagwage_income agwage_income transfers_income all_other_income /* 
*/ total_cons percapita_cons daily_percap_cons peraeq_cons daily_peraeq_cons /*
*/ *_monocrop_ha dist_agrodealer

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

*Winsorizing variables that go into yield at the top and bottom 5% //IHS 10.2.19
global allyield male female mixed inter inter_male inter_female inter_mixed pure  pure_male pure_female pure_mixed
global wins_var_top1_bott1_2 area_harv  area_plan harvest 
foreach v of global wins_var_top1_bott1_2 {
	foreach c of global topcropname_area { 
		_pctile `v'_`c'  [aw=weight_pop_rururb] , p(1 99)
		gen w_`v'_`c'=`v'_`c'
		replace w_`v'_`c' = r(r1) if w_`v'_`c' < r(r1)   &  w_`v'_`c'!=0 
		replace w_`v'_`c' = r(r2) if (w_`v'_`c' > r(r2) & w_`v'_`c' !=.)  		
		local l`v'_`c'  : var lab `v'_`c'
		lab var  w_`v'_`c' "`l`v'_`c'' - Winzorized top and bottom 5%"	
		* now use pctile from area for all to trim gender/inter/pure area
		foreach g of global allyield {
			gen w_`v'_`g'_`c'=`v'_`g'_`c'
			replace w_`v'_`g'_`c' = r(r1) if w_`v'_`g'_`c' < r(r1) &  w_`v'_`g'_`c'!=0 
			replace w_`v'_`g'_`c' = r(r2) if (w_`v'_`g'_`c' > r(r2) & w_`v'_`g'_`c' !=.)  	
			local l`v'_`g'_`c'  : var lab `v'_`g'_`c'
			lab var  w_`v'_`g'_`c' "`l`v'_`g'_`c'' - Winzorized top and bottom 5%"
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
	lab var ar_pl_wgt_`c' "Harvested area-adjusted weight for `c' (household)"
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
global animal_species lrum srum poultry 
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
gen liters_per_largeruminant=.
global empty_vars $empty_vars *liters_per_largeruminant

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
	gen `c'_exp_kg = w_`c'_exp / w_kgs_harv_mono_`c' 
	la var `c'_exp_kg "Costs per kg - Monocropped `c' plots"
	foreach g of global gender {
		gen `c'_exp_kg_`g'=w_`c'_exp_`g'/ w_kgs_harv_mono_`c'_`g' 
	}
}

*dairy
gen cost_per_lit_milk = w_costs_dairy/w_liters_milk_produced 
global empty_vars $empty_vars *cost_per_lit_milk*

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

gen egg_poultry_year = . // SRK 8.8.24 - just to get section to run 

*now winsorize ratios only at top 1% 
global wins_var_ratios_top1 /*
*/ inorg_fert_rate cost_total_ha cost_expli_ha cost_expli_hh_ha /*		
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
	if "`v'" =="inorg_fert_rate" | "`v'" =="cost_total_ha"  | "`v'" =="cost_expli_ha"  {
		foreach g of global gender {
			gen w_`v'_`g'=`v'_`g'
			replace  w_`v'_`g' = r(r1) if w_`v'_`g' > r(r1) & w_`v'_`g'!=.
			local l`v'_`g' : var lab `v'_`g'
			lab var  w_`v'_`g'  "`l`v'_`g'' - Winzorized top 1%"
		}	
	}
}

*Winsorizing crop ratios
foreach v of global topcropname_area {
	*first winsorizing costs per hectare
	_pctile `v'_exp_ha [aw=weight_pop_rururb] , p($wins_upper_thres)  
	gen w_`v'_exp_ha=`v'_exp_ha
	replace  w_`v'_exp_ha = r(r1) if  w_`v'_exp_ha > r(r1) &  w_`v'_exp_ha!=.
	local l`v'_exp_ha : var lab `v'_exp_ha
	lab var  w_`v'_exp_ha  "`l`v'_exp_ha' - Winzorized top 1%"
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

*now winsorize ratio only at top 5% - yield 
foreach c of global topcropname_area {
foreach i in yield_pl yield_hv{
	_pctile `i'_`c' [aw=weight_pop_rururb] ,  p(95)  //WINSORIZING YIELD FOR NIGERIA AT 5 PERCENT.
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

***DYA 12.06.19 Because of the use of odd area units in Nigeria, we have many tiny plots. We are reporting yield when area_plan>0.1ha
foreach c of global topcropname_area {
	replace w_yield_pl_`c'=. if w_area_plan_`c'<0.05
	replace w_yield_hv_`c'=. if w_area_plan_`c'<0.05
	foreach g of global allyield  {
		replace w_yield_pl_`g'_`c'=. if w_area_plan_`c'<0.05
		replace w_yield_hv_`g'_`c'=. if w_area_plan_`c'<0.05	
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
*/ formal_land_rights_hh  /*DYA.10.26.2020*/ *_hrs_*_pc_all  months_food_insec w_value_assets /*hhs_little hhs_moderate hhs_severe hhs_total*/ /*
*/ lvstck_holding_tlu lvstck_holding_all lvstck_holding_lrum lvstck_holding_srum lvstck_holding_poultry (.=0) if rural==1 
  
*all rural households engaged in livestock production
recode vac_animal w_share_livestock_prod_sold livestock_expenses w_ls_exp_vac(. = 0) if livestock_hh==1 
recode vac_animal w_share_livestock_prod_sold livestock_expenses w_ls_exp_vac(nonmissing = .) if livestock_hh==0 

*all rural households engaged in livestcok production of a given species
foreach i in lrum srum poultry{
	recode vac_animal_`i' any_imp_herd_`i' w_lost_disease_`i' w_ls_exp_vac_`i'(nonmissing=.) if lvstck_holding_`i'==0
	recode vac_animal_`i' any_imp_herd_`i' w_lost_disease_`i' w_ls_exp_vac_`i'(.=0) if lvstck_holding_`i'==1	
}

*households engaged in crop production
recode w_proportion_cropvalue_sold w_farm_size_agland w_labor_family w_labor_hired /*
*/ imprv_seed_use use_inorg_fert /*w_dist_agrodealer*/ w_labor_productivity w_land_productivity /*
*/ w_inorg_fert_rate w_cost_expli_hh w_cost_expli_hh_ha w_cost_expli_ha w_cost_total_ha /*
*/ w_value_crop_production w_value_crop_sales w_all_area_planted w_all_area_harvested (.=0) if crop_hh==1
recode w_proportion_cropvalue_sold w_farm_size_agland w_labor_family w_labor_hired /*
*/ imprv_seed_use use_inorg_fert /*w_dist_agrodealer*/ w_labor_productivity w_land_productivity /*
*/ w_inorg_fert_rate w_cost_expli_hh w_cost_expli_hh_ha w_cost_expli_ha w_cost_total_ha /*
*/ w_value_crop_production w_value_crop_sales w_all_area_planted w_all_area_harvested (nonmissing= . ) if crop_hh==0
		
*hh engaged in crop or livestock production
recode ext_reach* (.=0) if (crop_hh==1 | livestock_hh==1)
recode ext_reach* (nonmissing=.) if crop_hh==0 & livestock_hh==0

*all rural households growing specific crops 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	gen imprv_seed_`cn' = . 
	gen hybrid_seed_`cn' = . //Not able to construct these for wave 2
	recode w_yield_pl_`cn' /*
	*/ w_value_harv_`cn' w_value_sold_`cn' w_kgs_harvest_`cn' w_total_planted_area_`cn' w_total_harv_area_`cn' (.=0) if grew_`cn'==1
	recode w_yield_pl_`cn' /*
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
gen w_aglabor_weight_female=. //cannot create in this instrument  
lab var w_aglabor_weight_female "Hired labor-adjusted household weights -female workers"
gen w_aglabor_weight_male=. // cannot create in this instrument
lab var w_aglabor_weight_male "Hired labor-adjusted household weights -male workers"
gen weight_milk= milk_animals*weight
gen poultry_owned=. // SRK 8.8.24 - just to make this section run
gen weight_egg= poultry_owned*weight
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
foreach  v in all female male mixed {
	gen  area_weight_`v'=weight_pop_rururb*w_ha_planted_`v'
}
gen w_ha_planted_weight=w_ha_planted_all*weight_pop_rururb
gen individual_weight=hh_members*weight_pop_rururb
gen adulteq_weight=adulteq*weight_pop_rururb

****Currency Conversion Factors***
gen ccf_loc = (1/$Nigeria_GHS_W2_inflation) 
lab var ccf_loc "currency conversion factor - 2017 $NGN"
gen ccf_usd = ccf_loc/$Nigeria_GHS_W2_exchange_rate 
lab var ccf_usd "currency conversion factor - 2017 $USD"
gen ccf_1ppp = ccf_loc/$Nigeria_GHS_W2_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2017 $Private Consumption PPP"
gen ccf_2ppp = ccf_loc/$Nigeria_GHS_W2_gdp_ppp_dollar
lab var ccf_2ppp "currency conversion factor - 2017 $GDP PPP"

*Rural poverty headcount ratio

gen poverty_under_1_9 = (daily_percap_cons<$Nigeria_GHS_W2_poverty_threshold)
gen poverty_under_2_15 = daily_percap_cons < $Nigeria_GHS_W2_poverty_215
gen poverty_under_npl = daily_percap_cons < $Nigeria_GHS_W2_poverty_nbs

la var poverty_under_1_9 "Household has a percapita conumption of under $1.90 in 2011 PPP$"
la var poverty_under_2_15 "Household has a percapita consumption of under $2.15 in 2017 PPP$"
la var poverty_under_npl "Household has a percapita consumption below the national Nigerian poverty line"

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

*dropping unnecessary variables and recoding to missing any variables that cannot be created in this instrument
//ALT: I think these vars were removed in the recode
//drop *_inter_* 
/*value_rented_land value_owned_land* /*
*/ value_hired* value_fam* /*
*/ household_diet_cut_off* */

*create missing crop variables (no wheat or beans)
foreach x of varlist *maize* {
	foreach c in wheat beans {
		gen `x'_x = .
		ren *maize*_x *`c'*
	}
}
global empty_vars $empty_vars *wheat* *beans* 

*replace all tree crop area with 0s because we do not believe tree crop area in NGA is accurate
foreach c in $tree_cropname{
	global empty_vars $empty_vars *yield_*_`c' *total_planted_area_`c' *total_harv_area_`c' *`c'_exp_ha*
}

*replace empty vars with missing 
foreach v of varlist $empty_vars { 
	replace `v' = .
}

// Removing intermediate variables to get below 5,000 vars
keep hhid fhh clusterid strataid *weight* *wgt* zone state lga ea rural farm_size* *total_income* /*
*/ *percapita_income* *percapita_cons* *daily_percap_cons* *peraeq_cons* *daily_peraeq_cons* /*
*/ *income* *share* *proportion_cropvalue_sold *farm_size_agland hh_members adulteq *labor_family *labor_hired use_inorg_fert vac_* /*
*/ feed* water* lvstck_housed* ext_* use_fin_* lvstck_holding* *mortality_rate* *lost_disease* disease* any_imp* formal_land_rights_hh /*
*/ *livestock_expenses* *ls_exp_vac* *prop_farm_prod_sold /*DYA.10.26.2020*/ *hrs_*   months_food_insec *value_assets* hhs_* *dist_agrodealer /*
*/ encs* num_crops_* multiple_crops* imprv_seed_* hybrid_seed_* *labor_total *farm_area *labor_productivity* *land_productivity* /*
*/ *wage_paid_aglabor* *labor_hired ar_h_wgt_* *yield_hv_* ar_pl_wgt_* *yield_pl_* *liters_per_* milk_animals poultry_owned *costs_dairy* *cost_per_lit* /*
*/ *egg_poultry_year* *inorg_fert_rate* *ha_planted* *cost_expli_hh* *cost_expli_ha* *monocrop_ha* *kgs_harv_mono* *cost_total_ha* /*
*/ *_exp* poverty_under_1_9 poverty_under_2_15 poverty_under_npl *value_crop_production* *value_harv* *value_crop_sales* *value_sold* *kgs_harvest* *total_planted_area* *total_harv_area* /*
*/ *all_area_* grew_* agactivities_hh ag_hh crop_hh livestock_hh fishing_hh *_milk_produced* *eggs_total_year *value_eggs_produced* /*
*/ *value_livestock_products* *value_livestock_sales* *total_cons* nb_cattle_today *sales_livestock_products nb_cows_today lvstck_holding_srum  nb_smallrum_today nb_chickens_today nb_poultry_today /*HKS 6.6.23*/ nb_largerum_t nb_smallrum_t nb_chickens_t bottom_40_percap bottom_40_peraeq /*
*/ ccf_loc ccf_usd ccf_1ppp ccf_2ppp *sales_livestock_products area_plan* area_harv*  *value_pro* *value_sal* *inter*

gen ssp = (farm_size_agland <= 2 & farm_size_agland != 0) & (nb_largerum_today <= 10 & nb_smallrum_today <= 10 & nb_chickens_today <= 50)

ren weight weight_sample 
la var weight_sample "Original survey sampling weight"
ren weight_pop_rururb weight
la var weight "Weight adjusted by rural and urban population"

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
gen hhid_panel = hhid 
lab var hhid_panel "panel hh identifier" 
gen geography = "Nigeria" 
gen survey = "LSMS-ISA" 
gen year = "2012-13" 
gen instrument = 32
//Only runs if label isn't already defined.
capture label define instrument 11 "Tanzania NPS Wave 1" 12 "Tanzania NPS Wave 2" 13 "Tanzania NPS Wave 3" 14 "Tanzania NPS Wave 4" 15 "Tanzania NPS Wave 5" /*
	*/ 21 "Ethiopia ESS Wave 1" 22 "Ethiopia ESS Wave 2" 23 "Ethiopia ESS Wave 3" 24 "Ethiopia ESS Wave 4" 25 "Ethiopia ESS Wave 5" /*
	*/ 31 "Nigeria GHS Wave 1" 32 "Nigeria GHS Wave 2" 33 "Nigeria GHS Wave 3" 34 "Nigeria GHS Wave 4"/*
	*/ 41 "Malawi IHS/IHPS Wave 1" 42 "Malawi IHS/IHPS Wave 2" 43 "Malawi IHS/IHPS Wave 3" 44 "Malawi IHS/IHPS Wave 4" /*
    */ 51 "Uganda NPS Wave 1" 52 "Uganda NPS Wave 2" 53 "Uganda NPS Wave 3" 54 "Uganda NPS Wave 4" 55 "Uganda NPS Wave 5" /*W6 does not exist*/ 56 "Uganda NPS Wave 7" 57 "Uganda NPS Wave 8" /* 
*/ 61 "Burkina Faso EMC Wave 1" /* 
*/ 71 "Mali EACI Wave 1" 72 "Mali EACI Wave 2" /*
*/ 81 "Niger ECVMA Wave 1" 82 "Niger ECVMA Wave 2" 

label values instrument instrument	

saveold "${Nigeria_GHS_W2_final_data}/Nigeria_GHS_W2_household_variables.dta", replace // HKS 6.16.23 

********************************************************************************
*INDIVIDUAL-LEVEL VARIABLES
********************************************************************************
use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_person_ids.dta", clear
merge 1:1 hhid indiv using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_control_income.dta", nogen  keep(1 3)
merge 1:1 hhid indiv using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_make_ag_decision.dta", nogen  keep(1 3)
merge 1:1 hhid indiv using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_ownasset.dta", nogen  keep(1 3)
merge m:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_hhsize.dta", nogen keep (1 3)
merge 1:1 hhid indiv using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_farmer_fert_use.dta", nogen  keep(1 3)
merge 1:1 hhid indiv using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_farmer_improvedseed_use.dta", nogen  keep(1 3)
merge 1:1 hhid indiv using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_farmer_vaccine.dta", nogen  keep(1 3)
merge m:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_weights.dta", nogen keep (1 3)

*Land rights
merge 1:1 hhid indiv using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_land_rights_ind.dta", nogen
recode formal_land_rights_f (.=0) if female==1		
la var formal_land_rights_f "Individual has documentation of land rights (at least one plot) - Women only"

*getting correct subpopulations (women aged 18 or above in rural households) 
recode control_all_income make_decision_ag own_asset formal_land_rights_f (.=0) if female==1 
recode control_all_income make_decision_ag own_asset formal_land_rights_f (nonmissing=.) if female==0

preserve
use "${Nigeria_GHS_W2_final_data}/Nigeria_GHS_W2_household_variables.dta", clear
keep hhid ag_hh
tempfile ag_hh
save `ag_hh'
restore
merge m:1 hhid using `ag_hh', nogen keep (1 3)
replace   make_decision_ag =. if ag_hh==0

*Variables that cannot be created in this instrument
gen women_diet = . 
gen  number_foodgroup = .
global empty_vars women_diet number_foodgroup

*create missing crop variables (no wheat or beans)
foreach x of varlist *maize* {
foreach c in wheat beans {
	gen `x'_x = .
	ren *maize*_x *`c'*
}
}

*Set improved seed adoption to missing if household is not growing crop
foreach v in $topcropname_area_full {
	replace all_imprv_seed_`v' =. if `v'_farmer==0 | `v'_farmer==.
	recode all_imprv_seed_`v' (.=0) if `v'_farmer==1
	replace all_hybrid_seed_`v' =. if  `v'_farmer==0 | `v'_farmer==.
	recode all_hybrid_seed_`v' (.=0) if `v'_farmer==1
	gen female_imprv_seed_`v'=all_imprv_seed_`v' if female==1
	gen male_imprv_seed_`v'=all_imprv_seed_`v' if female==0
	gen female_hybrid_seed_`v'=all_hybrid_seed_`v' if female==1
	gen male_hybrid_seed_`v'=all_hybrid_seed_`v' if female==0
}

global empty_vars $empty_vars *seed* 
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
foreach v of varlist $empty_vars { 
	replace `v' = .
}
ren weight weight_sample 
la var weight_sample "Original survey sampling weight"
ren weight_pop_rururb weight
la var weight "Weight adjusted by rural and urban population"

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
gen hhid_panel = hhid 
lab var hhid_panel "panel hh identifier" 
gen geography = "Nigeria" 
gen survey = "LSMS-ISA" 
gen year = "2012-13" 
gen instrument = 32
//Only runs if label isn't already defined.
capture label define instrument 11 "Tanzania NPS Wave 1" 12 "Tanzania NPS Wave 2" 13 "Tanzania NPS Wave 3" 14 "Tanzania NPS Wave 4" 15 "Tanzania NPS Wave 5" /*
	*/ 21 "Ethiopia ESS Wave 1" 22 "Ethiopia ESS Wave 2" 23 "Ethiopia ESS Wave 3" 24 "Ethiopia ESS Wave 4" 25 "Ethiopia ESS Wave 5" /*
	*/ 31 "Nigeria GHS Wave 1" 32 "Nigeria GHS Wave 2" 33 "Nigeria GHS Wave 3" 34 "Nigeria GHS Wave 4"/*
	*/ 41 "Malawi IHS/IHPS Wave 1" 42 "Malawi IHS/IHPS Wave 2" 43 "Malawi IHS/IHPS Wave 3" 44 "Malawi IHS/IHPS Wave 4" /*
    */ 51 "Uganda NPS Wave 1" 52 "Uganda NPS Wave 2" 53 "Uganda NPS Wave 3" 54 "Uganda NPS Wave 4" 55 "Uganda NPS Wave 5" /*W6 does not exist*/ 56 "Uganda NPS Wave 7" 57 "Uganda NPS Wave 8" /* 
*/ 61 "Burkina Faso EMC Wave 1" /* 
*/ 71 "Mali EACI Wave 1" 72 "Mali EACI Wave 2" /*
*/ 81 "Niger ECVMA Wave 1" 82 "Niger ECVMA Wave 2" 

label values instrument instrument	
gen strataid=state
gen clusterid=ea
saveold "${Nigeria_GHS_W2_final_data}/Nigeria_GHS_W2_individual_variables.dta", replace
 
********************************************************************************
*PLOT -LEVEL VARIABLES
********************************************************************************
*GENDER PRODUCTIVITY GAP
use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_all_plots.dta", clear
collapse (sum) plot_value_harvest = value_harvest, by(hhid plot_id)
tempfile crop_values 
save `crop_values'

use "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_areas.dta", clear
merge m:1 hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_weights.dta", keep (1 3) nogen
merge 1:1 hhid plot_id using `crop_values', nogen keep(1 3)
merge 1:1 hhid plot_id using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_decision_makers", keep (1 3) nogen // Bring in the gender file
//ALT 09.02: New labor file.
merge 1:1 plot_id  hhid using "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_plot_labor_days.dta", keep (1 3) nogen

/*DYA.12.2.2020*/ merge m:1 hhid using "${Nigeria_GHS_W2_final_data}/Nigeria_GHS_W2_household_variables.dta", nogen keep (1 3) keepusing(ag_hh fhh farm_size_agland)
/*DYA.12.2.2020*/ recode farm_size_agland (.=0) 
/*DYA.12.2.2020*/ gen rural_ssp=(farm_size_agland<=4 & farm_size_agland!=0) & rural==1 

keep if cultivate==1
ren field_size  area_meas_hectares
egen labor_total = rowtotal(labor*) 
global winsorize_vars area_meas_hectares  labor_total  

foreach p of global winsorize_vars { 
	gen w_`p' =`p'
	local l`p' : var lab `p'
	_pctile w_`p'   [aw=weight_pop_rururb] if w_`p'!=0 , p($wins_lower_thres $wins_upper_thres)    
	replace w_`p' = r(r1) if w_`p' < r(r1)  & w_`p'!=. & w_`p'!=0
	replace w_`p' = r(r2) if w_`p' > r(r2)  & w_`p'!=.
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


****Currency Conversion Factors***
gen ccf_loc = (1/$Nigeria_GHS_W2_inflation) 
lab var ccf_loc "currency conversion factor - 2017 $NGN"
gen ccf_usd = ccf_loc/$Nigeria_GHS_W2_exchange_rate 
lab var ccf_usd "currency conversion factor - 2017 $USD"
gen ccf_1ppp = ccf_loc/$Nigeria_GHS_W2_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2017 $Private Consumption PPP"
gen ccf_2ppp = ccf_loc/$Nigeria_GHS_W2_gdp_ppp_dollar
lab var ccf_2ppp "currency conversion factor - 2017 $GDP PPP"

global monetary_val plot_value_harvest plot_productivity  plot_labor_prod 
foreach p of global monetary_val {
	gen `p'_1ppp = `p' * ccf_1ppp
	gen `p'_2ppp = `p' * ccf_2ppp
	gen `p'_usd = `p' * ccf_usd 
	gen `p'_loc =  `p' * ccf_loc 
	local l`p' : var lab `p' 
	lab var `p'_1ppp "`l`p'' (2017 $ Private Consumption PPP)"
	lab var `p'_2ppp "`l`p'' (2017 $ GDP PPP)"
	lab var `p'_usd "`l`p'' (2017$ USD)"
	lab var `p'_loc "`l`p'' (2017 NGN)" 
	lab var `p' "`l`p'' (NGN)"  
	gen w_`p'_1ppp = w_`p' * ccf_1ppp
	gen w_`p'_2ppp = w_`p' * ccf_2ppp
	gen w_`p'_usd = w_`p' * ccf_usd
	gen w_`p'_loc = w_`p' * ccf_loc
	local lw_`p' : var lab w_`p'
	lab var w_`p'_1ppp "`lw_`p'' (2017 $ Private Consumption PPP)"
	lab var w_`p'_2ppp "`lw_`p'' (2017 $ GDP PPP)"
	lab var w_`p'_usd "`lw_`p'' (2017 $ USD)"
	lab var w_`p'_loc "`lw_`p'' (2017 NGN)" 
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

/*BET.12.4.2020 - START*/ 


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
rename v1 NGA_wave2

save   "${Nigeria_GHS_W2_created_data}/Nigeria_GHS_W2_gendergap.dta", replace
restore
/*BET.12.4.2020 - END*/ 

gen plot_labor_weight= w_labor_total*weight_pop_rururb
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
ren weight weight_sample 
la var weight_sample "Original survey sampling weight"
ren weight_pop_rururb weight
la var weight "Weight adjusted by rural and urban population"

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
gen hhid_panel = hhid 
lab var hhid_panel "panel hh identifier" 
gen geography = "Nigeria" 
gen survey = "LSMS-ISA" 
gen year = "2012-13" 
gen instrument = 32
//Only runs if label isn't already defined.
capture label define instrument 11 "Tanzania NPS Wave 1" 12 "Tanzania NPS Wave 2" 13 "Tanzania NPS Wave 3" 14 "Tanzania NPS Wave 4" 15 "Tanzania NPS Wave 5" /*
	*/ 21 "Ethiopia ESS Wave 1" 22 "Ethiopia ESS Wave 2" 23 "Ethiopia ESS Wave 3" 24 "Ethiopia ESS Wave 4" 25 "Ethiopia ESS Wave 5" /*
	*/ 31 "Nigeria GHS Wave 1" 32 "Nigeria GHS Wave 2" 33 "Nigeria GHS Wave 3" 34 "Nigeria GHS Wave 4"/*
	*/ 41 "Malawi IHS/IHPS Wave 1" 42 "Malawi IHS/IHPS Wave 2" 43 "Malawi IHS/IHPS Wave 3" 44 "Malawi IHS/IHPS Wave 4" /*
    */ 51 "Uganda NPS Wave 1" 52 "Uganda NPS Wave 2" 53 "Uganda NPS Wave 3" 54 "Uganda NPS Wave 4" 55 "Uganda NPS Wave 5" /*W6 does not exist*/ 56 "Uganda NPS Wave 7" 57 "Uganda NPS Wave 8" /* 
*/ 61 "Burkina Faso EMC Wave 1" /* 
*/ 71 "Mali EACI Wave 1" 72 "Mali EACI Wave 2" /*
*/ 81 "Niger ECVMA Wave 1" 82 "Niger ECVMA Wave 2" 
label values instrument instrument		
drop s11aq5c-sa1q8 sa1q10c-sa1q38f
saveold "${Nigeria_GHS_W2_final_data}/Nigeria_GHS_W2_field_plot_variables.dta", replace
 
 
********************************************************************************
*SUMMARY STATISTICS
******************************************************************************** 
/*
All the pre-processed files include all households, individuals, and plots in the sample. 
The summary statistics are outputted only for the sub_population of households, individuals, and plots in rural areas. 
The code for outputting the summary statistics is in a separare dofile that is called here
*/ 
*Parameters
global list_instruments  "Nigeria_GHS_W2"
 do "${directory}\_Summary_Statistics\EPAR_UW_335_SUMMARY_STATISTICS.do"	
 
