/*
-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of a set of agricultural development indicators 
				  using the Malawi National Panel Survey (IHS3) LSMS-ISA Wave 1 (2010-2011)
*Author(s)		: Didier Alia, Pierre Biscaye, David Coomes, Kelsey Figone, Melissa Howlett, Jack Knauer, Josh Merfeld,  Micah McFeely,
				  Isabella Sun, Chelsea Sweeney, Emma Weaver, Ayala Wineman, Sam Kenney
				  C. Leigh Anderson, & Travis Reynolds

*Acknowledgments: We acknowledge the helpful contributions of members of the World Bank's LSMS-ISA team, the FAO's RuLIS team, IFPRI, IRRI, 
				  and the Bill & Melinda Gates Foundation Agricultural Development Data and Policy team in discussing indicator construction decisions. 
				  All coding errors remain ours alone.
*Date			: April 1st, 2024

----------------------------------------------------------------------------------------------------------------------------------------------------*/


*Data source
*-----------
*The Malawi National Panel Survey was collected by the National Statistical Office in Zomba 
*and the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture(LSMS - ISA)
*The data were collected over the period March 2010 - March 2011.
*All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
*http://microdata.worldbank.org/index.php/catalog/1003

*Throughout the do-file, we sometimes use the shorthand LSMS to refer to the Malawi National Panel Survey.

*Summary of Executing the Master do.file
*-----------
*This Master do.file constructs selected indicators using the Malawi IHS3 (MWI LSMS) data set.
*Using data files from within the "378 - LSMS Burkina Faso, Malawi, Uganda" folder within the "data" folder, 
*the do.file first constructs common and intermediate variables, saving dta files when appropriate 
*in \\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave1-2010-11\outputs 
*These variables are then brought together at the household, plot, or individual level, saving dta files at each level when available 
*at the file path "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave1-2010-11\outputs"

*The processed files include all households, individuals, and plots in the sample where possible.
*Toward the end of the do.file, a block of code estimates summary statistics (mean, standard error of the mean, minimum, first quartile, median, third quartile, maximum) 
*of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager.
*The results will be outputted in the excel file "Malawi_IHS_W1_summary_stats.xlsx" at the file path "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave1-2010-11\outputs"
*It is possible to modify the condition  "if rural==1" in the portion of code following the heading "SUMMARY STATISTICS" to generate all summary statistics for a different sub_population.

 
/*
OUTLINE OF THE DO.FILE
Below are the list of the main files created by running this Master do.file

*INTERMEDIATE FILES					MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD IDS						Malawi_IHS_W1_hhids.dta
*INDIVIDUAL IDS						Malawi_IHS_W1_person_ids.dta
*HOUSEHOLD SIZE						Malawi_IHS_W1_hhsize.dta
*PARCEL AREAS						Malawi_IHS_W1_plot_areas.dta
*PLOT-CROP DECISION MAKERS			Malawi_IHS_W1_plot_decision_makers.dta
*TLU (Tropical Livestock Units)		Malawi_IHS_W1_TLU_Coefficients.dta

*GROSS CROP REVENUE					Malawi_IHS_W1_tempcrop_harvest.dta
									Malawi_IHS_W1_tempcrop_sales.dta
									Malawi_IHS_W1_permcrop_harvest.dta
									Malawi_IHS_W1_permcrop_sales.dta
									Malawi_IHS_W1_hh_crop_production.dta
									Malawi_IHS_W1_plot_cropvalue.dta
									Malawi_IHS_W1_parcel_cropvalue.dta
									Malawi_IHS_W1_crop_residues.dta
									Malawi_IHS_W1_hh_crop_prices.dta
									Malawi_IHS_W1_crop_losses.dta
*CROP EXPENSES						Malawi_IHS_W1_wages_mainseason.dta
									Malawi_IHS_W1_wages_shortseason.dta
									
									Malawi_IHS_W1_fertilizer_costs.dta
									Malawi_IHS_W1_seed_costs.dta
									Malawi_IHS_W1_land_rental_costs.dta
									Malawi_IHS_W1_asset_rental_costs.dta
									Malawi_IHS_W1_transportation_cropsales.dta
									
*CROP INCOME						Malawi_IHS_W1_crop_income.dta
									
*LIVESTOCK INCOME					Malawi_IHS_W1_livestock_products.dta
									Malawi_IHS_W1_livestock_expenses.dta
									Malawi_IHS_W1_hh_livestock_products.dta
									Malawi_IHS_W1_livestock_sales.dta
									Malawi_IHS_W1_TLU.dta
									Malawi_IHS_W1_livestock_income.dta

*FISH INCOME						Malawi_IHS_W1_fishing_expenses_1.dta
									Malawi_IHS_W1_fishing_expenses_2.dta
									Malawi_IHS_W1_fish_income.dta
																	
*SELF-EMPLOYMENT INCOME				Malawi_IHS_W1_self_employment_income.dta
									Malawi_IHS_W1_agproducts_profits.dta
									Malawi_IHS_W1_fish_trading_revenue.dta
									Malawi_IHS_W1_fish_trading_other_costs.dta
									Malawi_IHS_W1_fish_trading_income.dta
									
*WAGE INCOME						Malawi_IHS_W1_wage_income.dta
									Malawi_IHS_W1_agwage_income.dta
*OTHER INCOME						Malawi_IHS_W1_other_income.dta
									Malawi_IHS_W1_land_rental_income.dta

*FARM SIZE / LAND SIZE				Malawi_IHS_W1_land_size.dta
									Malawi_IHS_W1_farmsize_all_agland.dta
									Malawi_IHS_W1_land_size_all.dta
*FARM LABOR							Malawi_IHS_W1_farmlabor_mainseason.dta
									Malawi_IHS_W1_farmlabor_shortseason.dta
									Malawi_IHS_W1_family_hired_labor.dta
*VACCINE USAGE						Malawi_IHS_W1_vaccine.dta
*USE OF INORGANIC FERTILIZER		Malawi_IHS_W1_fert_use.dta
*USE OF IMPROVED SEED				Malawi_IHS_W1_improvedseed_use.dta

*REACHED BY AG EXTENSION			Malawi_IHS_W1_any_ext.dta
*USE OF FORMAL FINANACIAL SERVICES	Malawi_IHS_W1_fin_serv.dta
*GENDER PRODUCTIVITY GAP 			Malawi_IHS_W1_gender_productivity_gap.dta
*MILK PRODUCTIVITY					Malawi_IHS_W1_milk_animals.dta
*EGG PRODUCTIVITY					Malawi_IHS_W1_eggs_animals.dta

*CROP PRODUCTION COSTS PER HECtaRE	Malawi_IHS_W1_hh_cost_land.dta
									Malawi_IHS_W1_hh_cost_inputs_lrs.dta
									Malawi_IHS_W1_hh_cost_inputs_srs.dta
									Malawi_IHS_W1_hh_cost_seed_lrs.dta
									Malawi_IHS_W1_hh_cost_seed_srs.dta		
									Malawi_IHS_W1_cropcosts_perha.dta

*RATE OF FERTILIZER APPLICATION		Malawi_IHS_W1_fertilizer_application.dta
*HOUSEHOLD'S DIET DIVERSITY SCORE	Malawi_IHS_W1_household_diet.dta
*WOMEN'S CONTROL OVER INCOME		Malawi_IHS_W1_control_income.dta
*WOMEN'S AG DECISION-MAKING			Malawi_IHS_W1_make_ag_decision.dta
*WOMEN'S ASSET OWNERSHIP			Malawi_IHS_W1_ownasset.dta
*AGRICULTURAL WAGES					Malawi_IHS_W1_ag_wage.dta
*CROP YIELDS						Malawi_IHS_W1_yield_hh_crop_level.dta

*FINAL FILES						MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD VARIABLES				Malawi_IHS_W1_household_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			Malawi_IHS_W1_individual_variables.dta	
*PLOT-LEVEL VARIABLES				Malawi_IHS_W1_gender_productivity_gap.dta
*SUMMARY STATISTICS					Malawi_IHS_W1_summary_stats.xlsx
*/

clear
set more off

clear matrix	
clear mata	
set maxvar 8000		

//set directories
*These paths correspond to the folders where the raw data files are located and where the created data and final data will be stored.
global Malawi_IHS_W1_raw_data "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave1-2010-11\Raw DTA Files"
global Malawi_IHS_W1_created_data "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave1-2010-11\Final DTA Files\created_data"
global Malawi_IHS_W1_final_data "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave1-2010-11\Final DTA Files\outputs"

********************************************************************************
*RE-SCALING SURVEY WEIGHTS TO MATCH POPULATION ESTIMATES
********************************************************************************
*https://databank.worldbank.org/source/world-development-indicators#
//population data from 2010, the last year in which data were collected for this wave
global Malawi_IHS_W1_pop_tot 14718422
global Malawi_IHS_W1_pop_rur 12430590
global Malawi_IHS_W1_pop_urb 2287832

********************************************************************************
* EXCHANGE RATE AND INFLATION FOR CONVERSION IN USD *
********************************************************************************
global Malawi_IHS_W1 730.27		//https://data.worldbank.org/indicator/PA.NUS.FCRF?end=2017&locations=MW&start=2011
global Malawi_IHS_W1_gdp_ppp_dollar 251.07    //https://data.worldbank.org/indicator/PA.NUS.PPP?end=2017&locations=MW&start=2011
global Malawi_IHS_W1_cons_ppp_dollar 241.93	 //https://data.worldbank.org/indicator/PA.NUS.PRVT.PP?end=2017&locations=MW&start=2011
global Malawi_IHS_W1_inflation 0.29394474 // CPI Survey Year 2010/CPI of Poverty Line Baseline Year 2017=100/340.2 //https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2017&locations=MW&start=2009

global Malawi_IHS_W1_poverty_threshold (1.90*78.77*100/107.6) //see calculation and sources below
//WB's previous (PPP) poverty threshold is $1.90. 
//Multiplied by 78.77 - 2011 PPP conversion factor, private consumption (LCU per international $) - Malawi - https://data.worldbank.org/indicator/PA.NUS.PRVT.PP?end=2011&locations=MW&start=2011
//Multiplied by 100 - 2010 Consumer price index (2010=100) - Malawi - https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2010&locations=MW&start=2010
//Divided by 107.6 - 2011 Consumer price index (2010=100) - Malawi - https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2011&locations=MW&start=2011
global Malawi_IHS_W1_poverty_ifpri (109797*100/340.2/365) //see calculation and sources below
//MWI government set national poverty line to MWK109,797 in January 2017 values //https://massp.ifpri.info/files/2019/05/IFPRI_KeyFacts_Poverty_Final.pdf
//Multiplied by CPI in 2010 of 100 //https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2017&locations=MW&start=2009
//Divided by CPI in 2017 of 340.2 //https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2017&locations=MW&start=2009
//Divide  by # of days in year (365) to get daily amount
global Malawi_IHS_W1_poverty_215 (2.15* $Malawi_IHS_W1_inflation * $Malawi_IHS_W1_cons_ppp_dollar)  //WB's new (PPP) poverty threshold of $2.15 multiplied by globals
 
********************************************************************************
* THRESHOLDS FOR WINSORIZATION *
********************************************************************************
global wins_lower_thres 1    						//  Threshold for winzorization at the bottom of the distribution of continous variables
global wins_upper_thres 99							//  Threshold for winzorization at the top of the distribution of continous variables


********************************************************************************
* GLOBALS OF PRIORITY CROPS *
********************************************************************************
*Determined by the top 12 crops by area cultivated for MWI W1 (see All Plots)
global topcropname_area "maize tobacc grdnt pigpea nkhwni beans sorgum soybn rice cotton swtptt pmill"
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
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_cropname_table.dta", replace //This gets used to generate the monocrop files.

********************************************************************************
* HOUSEHOLD IDS *
********************************************************************************
use "${Malawi_IHS_W1_raw_data}\Household\hh_mod_a_filt.dta", clear
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
keep case_id stratum district ta ea rural region weight 
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hhids.dta", replace
// This dataset includes case_id as a unique identifier, along with its location identifiers (i.e. rural, ea, etc.).

********************************************************************************
* WEIGHTS * 
********************************************************************************
use "${Malawi_IHS_W1_raw_data}\Household\hh_mod_a_filt.dta", clear
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
keep case_id region stratum district ta ea rural weight  
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_weights.dta", replace

********************************************************************************
* INDIVIDUAL IDS *
********************************************************************************
use "${Malawi_IHS_W1_raw_data}\Household\hh_mod_b.dta", clear
keep case_id hh_b01 hh_b03 hh_b04 hh_b05a
ren hh_b01 indiv
gen female= (hh_b03==2)
lab var female "1= Individual is female"
gen age=hh_b05a
lab var age "Individual age"
gen hh_head= (hh_b04==1)
lab var hh_head "1= individual is household head"
drop hh_b03 hh_b04 hh_b05a
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_person_ids.dta", replace
//This rescales the weights to match the population better (original weights underestimate total population and overestimate rural population)
********************************************************************************
* HOUSEHOLD SIZE *
********************************************************************************
use "${Malawi_IHS_W1_raw_data}\Household\hh_mod_b.dta", clear
gen hh_members = 1
rename hh_b04 relhead 
rename hh_b03 gender
gen fhh = (relhead==1 & gender==2)
collapse (sum) hh_members (max) fhh, by (case_id)
lab var hh_members "Number of household members"
lab var fhh "1= Female-headed household"

merge 1:1 case_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hhids.dta", nogen keep(2 3)
total hh_members [pweight=weight]
matrix temp =e(b)
gen weight_pop_tot=weight*${Malawi_IHS_W1_pop_tot}/el(temp,1,1)
total hh_members [pweight=weight_pop_tot]
lab var weight_pop_tot "Survey weight - adjusted to match total population"
*Adjust to match total population but also rural and urban
total hh_members [pweight=weight] if rural==1
matrix temp =e(b)
gen weight_pop_rur=weight*${Malawi_IHS_W1_pop_rur}/el(temp,1,1) if rural==1
total hh_members [pweight=weight_pop_tot]  if rural==1

total hh_members [pweight=weight] if rural==0
matrix temp =e(b)
gen weight_pop_urb=weight*${Malawi_IHS_W1_pop_urb}/el(temp,1,1) if rural==0
total hh_members [pweight=weight_pop_urb]  if rural==0

egen weight_pop_rururb=rowtotal(weight_pop_rur weight_pop_urb)
total hh_members [pweight=weight_pop_rururb]
lab var weight_pop_rururb "Survey weight - adjusted to match rural and urban population"
drop weight_pop_rur weight_pop_urb
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hhsize.dta", replace

********************************************************************************
* GPS COORDINATES *
********************************************************************************
use "${Malawi_IHS_W1_raw_data}\Geovariables\HH_level\householdgeovariables.dta", clear
merge 1:1 case_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hhids.dta", nogen keep(3) 
ren lat_modified latitude
ren lon_modified longitude
keep case_id latitude longitude
gen GPS_level = "hhid"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_LSMS_ISA_hh_coords.dta", replace

********************************************************************************
* PLOT AREAS *
********************************************************************************
use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_p.dta", clear
gen season=2 //perm
ren ag_p0b plot_id
ren ag_p0d crop_code_perm // note: no need to recode/align values + labels with crop_code_long; just using crop_code_perm for collapse internal to this section
ren ag_p02a area
ren ag_p02b unit
duplicates drop //one duplicate entry
drop if plot_id=="" //6,732 observations deleted // A large number of obs have no plot_id (and are also zeroes) there's no reason to hold on to these observations since they cannot be matched with any other module and don't appear to contain meaningful information.
keep if strpos(plot_id, "T") & plot_id!=""
collapse (max) area, by(case_id plot_id crop_code_perm season unit)
collapse (sum) area, by(case_id plot_id season unit)
recode area (0=.)
drop if area==. & unit==.

gen area_acres_est = area if unit==1 //Permanent crops in acres
replace area_acres_est = (area*2.47105) if unit == 2 & area_acres_est ==. //Permanent crops in hectares
replace area_acres_est = (area*0.000247105) if unit == 3 & area_acres_est ==.	//Permanent crops in square meters
keep case_id plot_id season area_acres_est

tempfile ag_perm
save `ag_perm'

use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_c.dta", clear
gen season=0 //rainy
append using "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_j.dta", gen(dry)
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

gen field_size= (area_acres_est* (1/2.47105))
replace field_size = (area_acres_meas* (1/2.47105))  if field_size==. & area_acres_meas!=. 

keep if area_acres_est !=. | area_acres_meas !=. //13,491 obs deleted - Keep if acreage or GPS measure info is available
keep case_id plot_id season area_acres_est area_acres_meas field_size 			
gen gps_meas = area_acres_meas!=. 
lab var gps_meas "Plot was measured with GPS, 1=Yes"

lab var area_acres_meas "Plot are in acres (GPSd)"
lab var area_acres_est "Plot area in acres (estimated)"
gen area_est_hectares=area_acres_est* (1/2.47105)  
gen area_meas_hectares= area_acres_meas* (1/2.47105)
lab var area_meas_hectares "Plot are in hectares (GPSd)"
lab var area_est_hectares "Plot area in hectares (estimated)"

save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_plot_areas.dta", replace

********************************************************************************
* PLOT DECISION MAKERS * 
********************************************************************************
use "${Malawi_IHS_W1_raw_data}\Household\hh_mod_b.dta", clear
ren hh_b01 indiv // indiv is the roster number, combination of case_id and indiv are unique id for this wave
drop if indiv==. //0 observations deleted
gen female=hh_b03==2 
gen age=hh_b05a
gen head = hh_b04==1 //if hh_b04!=. 
keep indiv female age case_id head
lab var female "1=Individual is a female"
lab var age "Individual age"
lab var head "1=Individual is the head of household"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_gender_merge.dta", replace

use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_p.dta", clear
ren ag_p0b plot_id
gen season=2
ren ag_p0d crop_code_perm
//In the absence of knowing a plot decision maker on any tree/perm plots (T1, T2,...TN) that do not show up in rainy/dry data, we are creating an assumption that the person that decides what to do with earnings for a particular crop is also the plot decision maker. We are only applying this assumption to households that grow a certain crop uniquely on one plot, but not multiple.
keep case_id plot_id crop_code_perm season
duplicates tag case_id crop_code_perm, gen(dups)

preserve
keep if dups > 0
keep case_id plot_id season
duplicates drop
tempfile dm_p_hoh
save `dm_p_hoh' //reserve the multiple instances of similar crops for use in another recipe
restore

drop if dups>0 //restricting observations to those where a unique crop is grown on only one plot
drop dups
tempfile one_plot_per_crop
save `one_plot_per_crop'

use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_q.dta", clear
ren ag_q06a indiv1 
ren ag_q06b indiv2 
ren ag_q0b crop_code_perm
duplicates drop case_id crop_code_perm indiv1 indiv2, force
merge m:1 case_id crop_code_perm using `one_plot_per_crop', keep (1 3) nogen
keep case_id plot_id indi*
gen season=2
tempfile dm_p
save `dm_p'

use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_d.dta", clear
rename ag_d00 plot_id
drop if plot_id=="" //275 observations deleted
gen season=0
tempfile dm_r
ren ag_d01 indiv1 //manager
ren ag_d04a indiv2 //owner
keep case_id plot_id  indiv*
duplicates drop
save `dm_r'

use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_k.dta", clear
ren ag_k0a plot_id
drop if plot_id==""
gen season=1
gen indiv1 =ag_k02 //manager
gen indiv2=ag_k05a //owner
keep case_id plot_id indiv*
duplicates drop
append using `dm_r'
append using `dm_p'
replace indiv1=indiv2 if indiv1==.
drop indiv2
ren indiv1 indiv
preserve
bys case_id plot_id : egen mindiv = min(indiv)
keep if mindiv==.
duplicates drop
append using `dm_p_hoh' //670 obs
merge m:m case_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_gender_merge.dta", nogen keep(3)
*keep if head==1 //511 obs - hope those 159 plots were fallow
tempfile hoh_plots
save `hoh_plots'
restore
drop if indiv==.
merge m:1 case_id indiv using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_gender_merge.dta", keep (1 3) nogen
append using `hoh_plots'
preserve
duplicates drop case_id plot_id season female, force
duplicates tag case_id plot_id season, g(dups)
gen dm_gender = 1 if female==0
replace dm_gender = 2 if female==1
replace dm_gender = 3 if dups > 0
keep case_id plot_id season dm_gender
duplicates drop
restore
//w/o season - note no difference
duplicates drop case_id plot_id female, force
duplicates tag case_id plot_id, g(dups)
gen dm_gender = 1 if female==0
replace dm_gender = 2 if female==1
replace dm_gender = 3 if dups > 0
keep case_id plot_id dm_gender
duplicates drop

keep case_id plot_id dm_gender
drop if dm_gender==.
drop if plot_id == ""
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_plot_decision_makers.dta", replace

********************************************************************************
* FORMALIZED LAND RIGHTS *
********************************************************************************

use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_d.dta", clear
gen season=0
append using "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_k.dta"
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
gen indiv=ag_d04a
replace indiv=ag_k05a if ag_k05a!=. & indiv==.
merge m:1 case_id indiv using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_person_ids.dta", keep (1 3) nogen //9 observations where formal_land_rights==1 but indiv is not merging
ren indiv primary_land_owner
ren female primary_land_owner_female
drop age hh_head

//Secondary Land Owner
gen indiv=ag_d04b
replace indiv=ag_k05b if ag_k05b!=. & indiv==.
merge m:1 case_id indiv using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_person_ids.dta", keep (1 3) nogen //0 observations where formal_land_rights==1 but indiv is not merging
ren indiv secondary_land_owner
ren female secondary_land_owner_female
drop age hh_head

gen formal_land_rights_f=1 if formal_land_rights==1 & (primary_land_owner_female==1 | secondary_land_owner_female==1)
preserve
collapse (max) formal_land_rights_f, by(case_id)		
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_land_rights_ind.dta", replace
restore
collapse (max) formal_land_rights_hh=formal_land_rights, by(case_id)
keep case_id formal_land_rights_hh
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_land_rights_hh.dta", replace


********************************************************************************
* CALORIC CONVERSION *
********************************************************************************
	capture confirm file "${Malawi_IHS_W1_created_data}/caloric_conversionfactor.dta"
	if !_rc {
	use "${Malawi_IHS_W1_created_data}/caloric_conversionfactor.dta", clear
	
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
	
	save "${Malawi_IHS_W1_created_data}/caloric_conversionfactor_crop_codes.dta", replace 
	}
	else {
	di as error "Updated calorie conversion factor file not present; caloric conversion will likely be incomplete"
	}

********************************************************************************
* CONVERSION FACTOR SCRIPT * - development purposes only, do not run as external user	
********************************************************************************
/*
*HARVESTED CROPS*
	use "${Malawi_IHS_W1_raw_data}/Agriculture/ag_mod_g.dta", clear
	append using "${Malawi_IHS_W1_raw_data}/Agriculture/ag_mod_m.dta"
	append using "${Malawi_IHS_W1_raw_data}/Agriculture/ag_mod_p.dta"
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
	use "${Malawi_IHS_W1_raw_data}/Agriculture/ag_mod_i.dta", clear
	append using "${Malawi_IHS_W1_raw_data}/Agriculture/ag_mod_o.dta"
	append using "${Malawi_IHS_W1_raw_data}/Agriculture/ag_mod_q.dta"


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
	save "${Malawi_IHS_W1_created_data}\MWI_IHS_W1_unit_os.dta", replace
	*/

********************************************************************************
* ALL PLOTS * 
********************************************************************************
	*********************************
	* 		   CROP VALUES          *
	*********************************

//Nonstandard unit values (kg values in plot variables section)
	use "${Malawi_IHS_W1_raw_data}/Agriculture/ag_mod_i.dta", clear
	gen season=0 //rainy season
	append using "${Malawi_IHS_W1_raw_data}/Agriculture/ag_mod_o.dta"
	recode season (.=1) //dry season
	append using "${Malawi_IHS_W1_raw_data}/Agriculture/ag_mod_q.dta"
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
	
	keep case_id crop_code_long sold_qty unit sold_value
	
	merge m:1 case_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_weights.dta", nogen keepusing(region stratum district ta ea rural weight) // 1,896 matched, 2,033 not matched
	keep case_id sold_qty unit sold_value crop_code_long region stratum district ta ea rural weight
	gen price_unit = sold_value/sold_qty // 2,034 missing values; n = 1895
	lab var price_unit "Average sold value per crop unit"
	gen obs=price_unit!=.
	
	merge m:1 case_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hhids.dta", nogen keep(1 3)	
	
	*create a value for the price of each crop at different levels
	foreach i in region district ta ea case_id {
	preserve
	bys `i' crop_code_long unit : egen obs_`i'_price = sum(obs) 
	collapse (median) price_unit_`i'=price_unit [aw=weight], by (`i' crop_code_long unit obs_`i'_price) 
	tempfile price_unit_`i'_median
	save `price_unit_`i'_median'
	restore
	}
	
	collapse (median) price_unit_country = price_unit (sum) obs_country_price=obs [aw=weight], by(crop_code_long unit)
	tempfile price_unit_country_median
	save `price_unit_country_median'

	*********************************
	* 		 PLOT VARIABLES    		*
	*********************************
	// Integration of updated conversion factor file (cf.dta) to convert non-standard units (e.g. volume of crop)
	// to standard weight units (kg) based on physical characteristics of the crop and other survey information was successful:
	// legacy conversion factor file merge resulted in 28,941 matched observations and 6,578 unmatched observations (from using);
	// updated conversion factor file merge resulted in 31,704 matched observations and 3,814 unmatched observations (from using).
	// Outstanding unmatched observations may be caused by several possible contributing factors, primarily the following:
	// some observations are recorded as units == "Other (specify)" with unconvertible responses.
	
	use "${Malawi_IHS_W1_raw_data}/Agriculture/ag_mod_p.dta", clear //tree/perm
	ren ag_p0d crop_code_long
	recode crop_code_long (1=49)(2=50)(3=51)(4=52)(5=53)(6=54)(7=55)(8=56)(9=57)(10=58)(11=59)(12=60)(13=61)(14=62)(15=63)(16=64)(17=65)(18=48)
	tempfile treeperm
	save `treeperm'
	
	use "${Malawi_IHS_W1_raw_data}/Agriculture/ag_mod_g.dta", clear //rainy 
	gen season=0 //create variable for season
	ren ag_g0d crop_code_long
	append using "${Malawi_IHS_W1_raw_data}/Agriculture/ag_mod_m.dta" //dry
	replace crop_code_long = ag_m0d if crop_code_long == . & ag_m0d != .
	recode season(.=1)
	append using `treeperm'
	recode season (.=2)
	lab var season "season: 0=rainy, 1=dry, 2=tree crop"
	label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
	label values season season
	ren ag_g0b plot_id
	replace plot_id=ag_m0b if plot_id==""
	replace plot_id=ag_p0b if plot_id==""
	ren ag_p03 number_trees_planted // number of trees planted during last 12 months
	
	label define relabel /*these exist already*/ 1 "MAIZE LOCAL" 2 "MAIZE COMPOSITE/OPV" 3 "MAIZE HYBRID" 4 "MAIZE HYBRID RECYCLED" 5 "TOBACCO BURLEY" 6 "TOBACCO FLUE CURED" 7 "TOBACCO NNDF" 8 "TOBACCOSDF" 9 "TOBACCO ORIENTAL" 10 "OTHER TOBACCO (SPECIFY)" 11 "GROUNDNUT CHALIMBANA" 12 "GROUNDNUT CG7" 13 "GROUNDNUT MANIPINTA" 14 "GROUNDNUT MAWANGA" 15 "GROUNDNUT JL24" 16 "OTHER GROUNDNUT(SPECIFY)" 17 "RISE LOCAL" 18 "RISE FAYA" 19 "RISE PUSSA" 20 "RISE TCG10" 21 "RISE IET4094 (SENGA)" 22 "RISE WAMBONE" 23 "RISE KILOMBERO" 24 "RISE ITA" 25 "RISE MTUPATUPA" 26 "OTHER RICE(SPECIFY)"  28 "SWEET POTATO" 29 "IRISH [MALAWI] POTATO" 30 "WHEAT" 34 "BEANS" 35 "SOYABEAN" 36 "PIGEONPEA(NANDOLO" 37 "COTTON" 38 "SUNFLOWER" 39 "SUGAR CANE" 40 "CABBAGE" 41 "TANAPOSI" 42 "NKHWANI" 43 "THERERE/OKRA" 44 "TOMATO" 45 "ONION" 46 "PEA" 47 "PAPRIKA" 48 "OTHER (SPECIFY)"/*cleaning up these existing labels*/ 27 "GROUND BEAN (NZAMA)" 31 "FINGER MILLET (MAWERE)" 32 "SORGHUM" 33 "PEARL MILLET (MCHEWERE)" /*now creating unique codes for tree crops*/ 49 "CASSAVA" 50 "TEA" 51 "COFFEE" 52 "MANGO" 53 "ORANGE" 54 "PAWPAW/PAPAYA" 55 "BANANA" 56 "AVOCADO" 57 "GUAVA" 58 "LEMON" 59 "NAARTJE (TANGERINE)" 60 "PEACH" 61 "POZA (CUSTADE APPLE)" 62 "MASUKU (MEXICAN APPLE)" 63 "MASAU" 64 "PINEAPPLE" 65 "MACADEMIA" /*adding other specified crop codes*/ 105 "MAIZE GREEN" 203 "SWEET POTATO WHITE" 204 "SWEET POTATO ORANGE" 207 "PLANTAIN" 208 "COCOYAM (MASIMBI)" 301 "BEAN, WHITE" 302 "BEAN, BROWN" 308 "COWPEA (KHOBWE)" 405 "CHINESE CABBAGE" 409 "CUCUMBER" 410 "PUMPKIN" 1800 "FODDER TREES" 1900 "FERTILIZER TREES" 2000 "FUEL WOOD TREES", modify
label val crop_code relabel
	
	gen crop_code=crop_code_long //Generic level (without detail)
	recode crop_code (1 2 3 4=1)(5 6 7 8 9 10=5)(11 12 13 14 15 16=11)(17 18 19 20 21 22 23 24 25 26=17)
	la var crop_code "Generic level crop code"
	label define relabel2 /*these exist already*/ 1 "MAIZE" 5 "TOBACCO" 11 "GROUNDNUT" 17 "RICE" 28 "SWEET POTATO" 29 "IRISH [MALAWI] POTATO" 30 "WHEAT" 34 "BEANS" 35 "SOYABEAN" 36 "PIGEONPEA(NANDOLO" 37 "COTTON" 38 "SUNFLOWER" 39 "SUGAR CANE" 40 "CABBAGE" 41 "TANAPOSI" 42 "NKHWANI" 43 "THERERE/OKRA" 44 "TOMATO" 45 "ONION" 46 "PEA" 47 "PAPRIKA" 48 "OTHER (SPECIFY)"/*cleaning up these existing labels*/ 27 "GROUND BEAN (NZAMA)" 31 "FINGER MILLET (MAWERE)" 32 "SORGHUM" 33 "PEARL MILLET (MCHEWERE)" /*now creating unique codes for tree crops*/ 49 "CASSAVA" 50 "TEA" 51 "COFFEE" 52 "MANGO" 53 "ORANGE" 54 "PAWPAW/PAPAYA" 55 "BANANA" 56 "AVOCADO" 57 "GUAVA" 58 "LEMON" 59 "NAARTJE (TANGERINE)" 60 "PEACH" 61 "POZA (CUSTADE APPLE)" 62 "MASUKU (MEXICAN APPLE)" 63 "MASAU" 64 "PINEAPPLE" 65 "MACADEMIA" /*adding other specified crop codes*/ 105 "MAIZE GREEN" 203 "SWEET POTATO WHITE" 204 "SWEET POTATO ORANGE" 207 "PLANTAIN" 208 "COCOYAM (MASIMBI)" 301 "BEAN, WHITE" 302 "BEAN, BROWN" 308 "COWPEA (KHOBWE)" 405 "CHINESE CABBAGE" 409 "CUCUMBER" 410 "PUMPKIN" 1800 "FODDER TREES" 1900 "FERTILIZER TREES" 2000 "FUEL WOOD TREES", modify
	label val crop_code relabel2
	drop if crop_code==.
	
	*Create area variables
	gen crop_area_share=ag_g03
	label var crop_area_share "Proportion of plot planted with crop"
	replace crop_area_share=ag_m03 if crop_area_share==. & ag_m03!=.
	
	//converting answers to proportions
	replace crop_area_share=0.125 if crop_area_share==1 // Less than 1/4
	replace crop_area_share=0.25 if crop_area_share==2 
	replace crop_area_share=0.5 if crop_area_share==3
	replace crop_area_share=0.75 if crop_area_share==4
	replace crop_area_share=.875 if crop_area_share==5 // More than 3/4 
	replace crop_area_share=1 if ag_g02==1 | ag_m02==1 //planted on entire plot for both rainy and dry season
	merge m:1 case_id plot_id season using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_plot_areas.dta", keep(1 3) nogen
	gen ha_planted=crop_area_share*area_meas_hectares
	
	replace ha_planted=crop_area_share*area_est_hectares if ha_planted==. & area_est_hectares!=. & area_est_hectares!=0
	// convert area to hectares.
	//ag_p02b is unit: 1-acre 2-hectare 3-sq meter 4-other but no observations in units other than acres
	replace ha_planted=ag_p02a* (1/2.47105) if ag_p02b==1 & ha_planted==. & (ag_p02a!=. & ag_p02a!=0 & ag_p02b!=0 & ag_p02b!=.)
	replace ha_planted=ag_p02a*(1/10000) if ag_p02b==3 & ha_planted==. & (ag_p02a!=. & ag_p02a!=0 & ag_p02b!=0 & ag_p02b!=.)
	ren ea_id ea
	save "${Malawi_IHS_W1_created_data}\MLW_W1_ha_planted.dta", replace

	drop crop_area_share
	
	gen ha_harvested=ha_planted
	
	*Create time variables (month planted, harvest, and length of time grown)
	
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
	collapse (max) days_grown, by(case_id plot_id)
	save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_plot_season_length.dta", replace
	restore
	
	//all observations of months_grown less than or equal to 11 months.
	gen year_harvested=year_planted if harvest_month_begin>month_planted
	replace year_harvested=year_planted+1 if harvest_month_begin<month_planted
	replace year_harvested=. if year_planted!=2007 & year_planted!=2008 & year_planted!=2009 & year_planted!=2010
	
	gen date_planted = mdy(month_planted, 1, ag_g05b) if ag_g05b!=. //1,847 missing values
	replace date_planted = mdy(month_planted-12, 1, ag_g05b) if month_planted>12 & ag_g05b!=. //0 real changes
	replace date_planted = mdy(month_planted-12, 1, ag_m05b) if month_planted>12 & ag_m05b!=. //0 real changes
	replace date_planted = mdy(month_planted, 1, ag_m05b) if date_planted==. & ag_m05b!=. //0 real changes
	gen date_harvested = mdy(harvest_month_begin, 1, ag_g05b) if ag_g05b==2010
	replace date_harvested = mdy(harvest_month_begin, 1, ag_m05b) if date_harvested==. & ag_m05b==2010
	replace date_harvested = mdy(harvest_month_begin, 1, ag_g05b) if month_planted<=12 & harvest_month_begin>month_planted & date_harvest==. & ag_g05b!=. //assuming if planted in 2010 and month harvested is later than planted, it was harvested in 2010
	replace date_harvested = mdy(harvest_month_begin, 1, ag_m05b) if month_planted<=12 & harvest_month_begin>month_planted & date_harvest==. & ag_m05b!=.
	replace date_harvested = mdy(harvest_month_begin, 1, ag_g05b+1) if month_planted<=12 & harvest_month_begin<month_planted & date_harvest==. & ag_g05b!=.
	replace date_harvested = mdy(harvest_month_begin, 1, ag_m05b+1) if month_planted<=12 & harvest_month_begin<month_planted & date_harvest==. & ag_m05b!=.
	
	format date_planted %td
	format date_harvested %td
	gen days_grown=date_harvest-date_planted
	
	bys plot_id case_id : egen min_date_harvested = min(date_harvested)
	bys plot_id case_id : egen max_date_planted = max(date_planted)
	gen overlap_date = min_date_harvested - max_date_planted
	
	*Generate crops_plot variable for number of crops per plot. This is used to fix issues around intercropping and relay cropping being reported inaccurately for our purposes.
	preserve
		gen obs=1
		replace obs=0 if ag_g13a==0 | ag_m11a==0 | ag_p09a==0  //333 real changes made; would have been 0 if no crops were harvested
		collapse(sum)crops_plot=obs, by(case_id plot_id season)
		//br if crops_plot>1
		tempfile ncrops
		save `ncrops'
	restore
	
	merge m:1 case_id plot_id season using `ncrops', nogen
	
	gen contradict_mono = 1 if (ag_g01==1 | ag_m01==1) & crops_plot >1
	gen contradict_inter = 1 if (ag_g01==2 | ag_m01==2) & crops_plot ==1 
	replace contradict_inter = . if ag_g01==1 | ag_m01==1 

	
	*Generating monocropped plot variables (Part 1)
	bys case_id plot_id season: egen crops_avg= mean(crop_code) //checks for diff versions of same crop in the same plot
	gen purestand=1 if crops_plot==1 | crops_avg == crop_code //3,299 missing values
	gen perm_crop=1 if crop_code_long!=.
	bys case_id plot_id: egen permax = max(perm_crop) //no gardenid for W1

	bys case_id plot_id month_planted year_planted : gen plant_date_unique=_n
	bys case_id plot_id harvest_month_begin : gen harv_date_unique=_n // survey does not ask year of harvest for crops
	bys case_id plot_id : egen plant_dates = max(plant_date_unique)
	bys case_id plot_id : egen harv_dates = max(harv_date_unique) 

	replace purestand=0 if (crops_plot>1 & (plant_dates>1 | harv_dates>1))  | (crops_plot>1 & permax==1)  //3,393 real changes
	gen any_mixed=!(ag_g01==1 | ag_m01==1 | (perm_crop==1 & purestand==1)) 
	bys case_id plot_id : egen any_mixed_max = max(any_mixed)
	replace purestand=1 if crops_plot>1 & plant_dates==1 & harv_dates==1 & permax==0 & any_mixed_max==0 //0 replacements
	
	replace purestand=1 if crop_code_long==crops_avg //28 real changes
	replace purestand=0 if purestand==. //51 real changes
	drop crops_plot crops_avg plant_dates harv_dates plant_date_unique harv_date_unique permax
	
	//rescaling plots 
	replace ha_planted = ha_harvest if ha_planted==. //0 changes
	//Let's first consider that planting might be misreported but harvest is accurate
	replace ha_planted = ha_harvest if ha_planted > area_meas_hectares & ha_harvest < ha_planted & ha_harvest!=. //0 changes
	gen percent_field=ha_planted/area_meas_hectares //5,471 missing values generated

	*Generating total percent of purestand and monocropped on a field
	bys case_id plot_id: egen total_percent = total(percent_field)
	
	replace percent_field = percent_field/total_percent if total_percent>1 & purestand==0
	replace percent_field = 1 if percent_field>1 & purestand==1
	
	replace ha_planted = percent_field*area_meas_hectares
	replace ha_harvest = ha_planted if ha_harvest > ha_planted
	
	/*Note - confusing results in survey: ag_g09 represents panel visit 1 and ag_g13 represents panel visit 2, both during rainy season. 
	count if ag_g09b != . & ag_g09a != 0 & ag_g13b != . & ag_g13a != 0 // 2,977 observations where panel visit 1 and panel visit 2 both record values
	*/

	/* Determining what hhs are responding to q09 vs. q13 vs. both. All Panel 1 hhs? All Panel 2 hhs? All Cross-Section hhs?
	preserve
	keep case_id visit ea plot_id crop_code_long ag_g13a ag_g13b ag_g09a ag_g09b // 35,519 obs
	keep if ag_g09b == . &  ag_g13b != . // 23,693 obs
	collapse (mean) visit, by(case_id) // 9,157 obs
	merge 1:1 case_id using "${Malawi_IHS_W1_raw_data}/Household/hh_mod_a_filt.dta", keep(3) // all obs matched from master
	tab qx_type // 7,298 cross-section; 926 Panel A; 933 Panel B
	restore

	preserve
	keep case_id visit ea plot_id crop_code_long ag_g13a ag_g13b ag_g09a ag_g09b // 35,519 obs
	keep if ag_g09b != . // 3,088 obs
	count if ag_g13b == . // 111 missing values
	gen q13 = 1 if ag_g13b != .
	recode q13 .=0
	collapse (mean) visit (min) q13, by(case_id) // 1,585 unique households, all visit == 2
	tab q13 // 87 hhs that record a real value for question 9 but not question 13 // 1,498 hhs that record a real value for both
	merge 1:1 case_id using "${Malawi_IHS_W1_raw_data}/Household/hh_mod_a_filt.dta", keep(3) // all obs matched from master
	tab qx_type // 741 Panel A, 844 Panel B
	tab qx_type q13 // where q13 == 0 - 42 Panel A, 45 Panel B
	restore
	//conclusion: Panel visit does not appear to predict whether or not the hh responded to question 9 or 13. All of the cross-sectional hhs responded to question 13 and none responded to question 9
	*/
	
	rename ag_g13b unit
	replace unit = ag_g09b if unit == . // 111 real changes
	replace unit = ag_m11b if unit == . // 1645 real changes
	replace unit = ag_p09b if unit == . // 5653 real changes
	drop if unit == 50 // 1 obs deleted
	
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
	merge m:1 case_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hhids.dta", nogen keep(1 3)
	
	*renaming condition vars in master to match using file 
	gen condition=ag_g09c
	lab define condition 1 "S: SHELLED" 2 "U: UNSHELLED" 3 "N/A", modify
	lab val condition condition
	replace condition = ag_g13c if condition==. & ag_g13c !=. //23,525 reach changes
	replace condition = ag_m11c if condition==. & ag_m11c !=. //0 real changes made, no observations for ag_m11c
	replace condition=3 if condition==. & crop_code!=. & unit!=. // conversion factor file is designed to create more merges provided recoding blank conditions to n/a
	
	capture {
		confirm file `"${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_cf.dta"'
	} 
	if !_rc {
	merge m:1 region crop_code_long unit condition using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_cf.dta", keep(1 3) gen(cf_merge) 
} 
else {
 di as error "Updated conversion factors file not present; harvest data will likely be incomplete"
}

	//Multiply by shelled/unshelled cf for unshelled units
	gen quant_harv_kg= quantity_harvested*conversion

	preserve
	keep quant_harv_kg crop_code_long crop_code case_id plot_id season
	save "${Malawi_IHS_W1_created_data}/Malawi_IHS_W1_yield_1_6_23.dta", replace
	restore	

merge m:1 case_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_weights.dta", nogen //33,610 matched, 2,011 not matched

foreach i in region district ta ea case_id {
	merge m:1 `i' crop_code_long unit using `price_unit_`i'_median', nogen keep(1 3)
	}
merge m:1 unit crop_code_long using `price_unit_country_median', nogen keep(1 3)
//Using giving household price priority; take hhid out if results are looking weird
gen value_harvest = price_unit_case_id * quant_harv_kg 
gen missing_price = value_harvest == .
foreach i in region district ta ea { //decending order from largest to smallest geographical figure
replace value_harvest = quantity_harvested * price_unit_`i' if missing_price == 1 & obs_`i' > 9 & obs_`i' != . 
}
replace value_harvest = quantity_harvested * price_unit_country if value_harvest==.

	//gen value_harvest = price_unit_country * quant_harv_kg 
	gen val_unit = value_harvest/quantity_harvested
	gen val_kg = value_harvest/quant_harv_kg
	merge m:1 case_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_weights.dta", nogen keep(1 3)
	gen plotweight = ha_planted*conversion
	gen obs=quantity_harvested>0 & quantity_harvested!=.
	
preserve
	collapse (mean) val_kg, by (case_id crop_code_long)
	ren val_kg hh_price_mean
	lab var hh_price_mean "Average price reported for this for 1 kg in the household"
	save "${Malawi_IHS_W1_created_data}/Malawi_IHS_W1_hh_crop_prices_for_wages.dta", replace
restore

	*********************************
	*   ADDING CALORIC CONVERSION	*
	*********************************
	capture {
		confirm file `"${Malawi_IHS_W1_created_data}/caloric_conversionfactor_crop_codes.dta"'
	} 
	if _rc!=0 {
		display "Note: file ${Malawi_IHS_W1_created_data}/caloric_conversionfactor_crop_codes.dta does not exist - skipping calorie calculations"		
	}
	if _rc==0{
		merge m:1 crop_code using "${Malawi_IHS_W1_created_data}/caloric_conversionfactor_crop_codes.dta", nogen keep(1 3)
	
		// logic for units: calories / 100g * kg * 1000g/kg * edibe perc * 100 / perc * 1/1000 = cal
		gen calories = cal_100g * quant_harv_kg * edible_p / .1 
		count if missing(calories) //3,575 then 3,567 missing then 2,939 missing (pea fix) then 2,757 (cassava populated with sweet potato)
		//unit is blank on 352 observations - nothing we can do there; quantity_harvested only blank on 16 observations; 2,433 due to conversion being blank - likely because IHS Agri Conversion file has many . in conversion
	}

	// save all_plots.dta on crop_code_long
	preserve
	collapse (sum) quant_harv_kg value_harvest ha_planted ha_harvest number_trees_planted percent_field /*calories*/ (max) months_grown, by(region district ea case_id plot_id crop_code_long purestand area_meas_hectares season)
	bys case_id plot_id : egen percent_area = sum(percent_field)
	bys case_id plot_id : gen percent_inputs = percent_field/percent_area
	drop percent_area //Assumes that inputs are +/- distributed by the area planted. Probably not true for mixed tree/field crops, but reasonable for plots that are all field crops
	//Labor should be weighted by growing season length
	merge m:1 case_id plot_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
	order region district ea case_id
	save "${Malawi_IHS_W1_created_data}/Malawi_IHS_W1_all_plots_long.dta", replace
	restore

//AgQuery
	collapse (sum) quant_harv_kg value_harvest ha_planted ha_harvest number_trees_planted percent_field /*calories*/ (max) months_grown, by(region district ea case_id plot_id crop_code purestand area_meas_hectares season)
	bys case_id plot_id : egen percent_area = sum(percent_field)
	bys case_id plot_id : gen percent_inputs = percent_field/percent_area
	drop percent_area //Assumes that inputs are +/- distributed by the area planted. Probably not true for mixed tree/field crops, but reasonable for plots that are all field crops
	//Labor should be weighted by growing season length 

	merge m:1 case_id plot_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
	
	order region district ea case_id
	
	preserve
	drop if plot_id == ""
	save "${Malawi_IHS_W1_created_data}/Malawi_IHS_W1_all_plots2.dta", replace
	restore
	
	save "${Malawi_IHS_W1_created_data}/Malawi_IHS_W1_all_plots.dta", replace
	
	/* CODE USED TO DETERMINE THE TOP CROPS
	use "${Malawi_IHS_W1_created_data}/Malawi_IHS_W1_all_plots.dta", clear
	merge m:1 case_id using "${Malawi_IHS_W1_created_data}/Malawi_IHS_W1_hhsize.dta"
	gen area= ha_planted*weight 
	collapse (sum) area, by (crop_code_short) */


********************************************************************************
* TLU (Tropical Livestock Units) *
********************************************************************************
use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_r1.dta", clear
gen tlu_coefficient=0.5 if (ag_r0a==301|ag_r0a==302|ag_r0a==303|ag_r0a==304|ag_r0a==306)
replace tlu_coefficient=0.1 if (ag_r0a==307|ag_r0a==308)
replace tlu_coefficient=0.2 if (ag_r0a==309)
replace tlu_coefficient=0.01 if (ag_r0a==310|ag_r0a==311|ag_r0a==312|ag_r0a==313|ag_r0a==314|ag_r0a==315|ag_r0a==316)
replace tlu_coefficient=0.3 if (ag_r0a==305) 
lab var tlu_coefficient "Tropical Livestock Unit coefficient"

*Owned
gen cattle=inrange(ag_r0a,301,304)
gen smallrum=inlist(ag_r0a,307,308,309)
gen poultry=inrange(ag_r0a,310,316)
gen other_ls=inlist(ag_r0a,305,306)
gen cows=inrange(ag_r0a,303,303)
gen chickens=inrange(ag_r0a,310,313) //MMH 6.8.19: included chicken layer (310), local hen (311), chicken broiler (312), local cock (313)
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
collapse (sum) tlu_* nb_*  , by (case_id)
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
drop if case_id==""
save "${Malawi_IHS_W1_created_data}/Malawi_IHS_W1_TLU_Coefficients.dta", replace


********************************************************************************
* GROSS CROP REVENUE *
********************************************************************************
* Three goals
* 1. Total value of all crop sales by hhid (summed up over all crops)
* 2. Total value of post harvest losses by hhid (summed up over all crops)
* 3. Amount sold (kgs) of unique crops by hhid

use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_q.dta", clear
ren ag_q0b crop_code_long
recode crop_code_long (1=49)(2=50)(3=51)(4=52)(5=53)(6=54)(7=55)(8=56)(9=57)(10=58)(11=59)(12=60)(13=61)(14=62)(15=63)(16=64)(17=65)
tempfile tree_perm
save `tree_perm'

use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_i.dta", clear
append using "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_o.dta"
ren ag_i0b crop_code_long
append using `tree_perm'

* Creating a value variable for value of crop sold
rename ag_i03 value
replace value = ag_o03 if value == . & ag_o03 != .
replace value = ag_q03 if value == . & ag_q03 != .
recode value (.=0)

ren ag_i02a qty
replace qty = ag_o02a if qty == . & ag_o02a != .
replace qty=ag_q02a if qty==. & ag_o02a!=. 
gen unit=ag_i02b
replace unit= ag_o02b if unit==.
replace qty=ag_q02b if qty==. 
gen unit_os = ag_i02b_os
replace unit_os = ag_q02b_os if unit_os == ""

replace qty =ag_i12a if qty==. & ag_i12a!=. //0 changes
replace unit=ag_i12b if unit==. & ag_i12b!=. //0 changes
replace value= ag_i13 if value==. & ag_i13!=. //0 changes

ren ag_i02c condition 
replace condition= ag_o02c if condition==.
replace condition=3 if condition==. 
merge m:1 case_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hhids.dta", nogen keepusing(region district ta rural ea weight) keep(1 3)
***We merge Crop Sold Conversion Factor at the crop-unit-regional level***
merge m:1 region crop_code_long unit condition using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_cf.dta", gen(cf_merge) keep (1 3) //6,072 matched,  41,292 unmatched because raw data donot report any unit or value for the remaining observations; there's not much we can do to make more matches here

***We merge Crop Sold Conversion Factor at the crop-unit-national level***

*We create Quantity Sold (kg using standard conversion factor table for each crop- unit and region).
replace conversion=conversion if region!=. //  We merge the national standard conversion factor for those hhid with missing regional info. 
gen kgs_sold = qty*conversion 
collapse (sum) value kgs_sold (first) crop_code_long, by (case_id crop_code)
drop if crop_code ==.
lab var value "Value of sales of this crop"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_cropsales_value.dta", replace

use "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_all_plots_long.dta", clear

collapse (sum) value_harves, by(case_id crop_code_long)
merge 1:1 case_id crop_code_long using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_cropsales_value.dta", nogen
replace value_harvest = value if value>value_harvest & value_!=. /* In a few cases, sales value reported exceeds the estimated value of crop harvest */
ren value value_crop_sales 
recode  value_harvest value_crop_sales  (.=0)
collapse (sum) value_harvest value_crop_sales, by (case_id crop_code_long)
drop if crop_code ==.
ren value_harvest value_crop_production
lab var value_crop_production "Gross value of crop production, summed over main and short season"
lab var value_crop_sales "Value of crops sold so far, summed over main and short season"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_crop_values_production.dta", replace

collapse (sum) value_crop_production value_crop_sales, by (case_id)
lab var value_crop_production "Gross value of crop production for this household"
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hh_crop_production.dta", replace

*Crops lost post-harvest
use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_i.dta", clear
ren ag_i0b crop_code_long

append using "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_o.dta"
replace crop_code_long = ag_o0b if crop_code_long==.
drop if crop_code==. // 9440 observations deleted 
rename ag_i36e percent_lost
replace percent_lost = ag_o36d if percent_lost==. & ag_o36d!=.
replace percent_lost = 100 if percent_lost > 100 & percent_lost!=.

merge m:1 case_id crop_code_long using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_crop_values_production.dta", nogen keep(1 3)
gen value_lost = value_crop_production * (percent_lost/100)
recode value_lost (.=0)
collapse (sum) value_lost, by (case_id)
rename value_lost crop_value_lost
lab var crop_value_lost "Value of crop production that had been lost by the time of survey"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_crop_losses.dta", replace


********************************************************************************
* CROP EXPENSES *
********************************************************************************
	*********************************
	* 			LABOR				*
	*********************************
	*Crop payments rainy
	use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_d.dta", clear 
	ren ag_d00 plot_id
	ren ag_d46g crop_code_long
	ren ag_d46h qty
	ren ag_d46i unit
	ren ag_d46j condition
	ren ea_id ea
	keep case_id plot_id ea crop_code qty unit condition
	gen season=0
	tempfile rainy_crop_payments
	save `rainy_crop_payments'
	
	*Crop payments dry
	use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_k.dta", clear 
	ren ag_k0a plot_id
	ren ag_k46g crop_code_long
	ren ag_k46h qty
	ren ag_k46i unit
	ren ag_k46j condition
	ren ea_id ea
	keep case_id plot_id ea crop_code qty unit condition
	gen season=1
	tempfile dry_crop_payments
	save `dry_crop_payments'

	//Not including in-kind payments as part of wages b/c they are not disaggregated by worker gender (but including them as an explicit expense at the end of the labor section)
	use `rainy_crop_payments'
	append using `dry_crop_payments'
	lab var season "season: 0=rainy, 1=dry, 2=tree crop"
	label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
	label values season season
	merge m:1 case_id crop_code_long using "${Malawi_IHS_W1_created_data}/Malawi_IHS_W1_hh_crop_prices_for_wages.dta", nogen keep (1 3) //423 matched
	recode qty hh_price_mean (.=0)
	gen val = qty*hh_price_mean
	keep case_id val plot_id season
	gen exp = "exp"
	merge m:1 plot_id case_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_plot_decision_makers.dta", nogen keep (1 3) keepusing(dm_gender)
	tempfile inkind_payments
	save `inkind_payments'

	*Hired rainy
	//This code creates three temporary files for exchange labor in the rainy season: rainy_hired_all, rainy_hired_nonharvest, and rainy_hired_harvest. Will append nonharvest and harvest to compare to all.
	local qnums "46 47 48" //qnums refer to question numbers on instrument
	foreach q in `qnums' {
		use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_d.dta", clear
		ren ag_d00 plot_id
		ren ea_id ea
		merge m:1 case_id ea using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hhids.dta", nogen
		ren ag_d`q'a dayshiredmale
		ren ag_d`q'c dayshiredfemale
		ren ag_d`q'e dayshiredchild
		ren ag_d`q'b wagehiredmale
		ren ag_d`q'd wagehiredfemale
		ren ag_d`q'f wagehiredchild
		keep region stratum district ta ea rural case_id plot_id *hired*
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
	use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_k.dta", clear 
	ren ag_k0a plot_id
	ren ea_id ea
	merge m:1 case_id ea using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hhids.dta", nogen
	ren ag_k46a dayshiredmale
	ren ag_k46c dayshiredfemale
	ren ag_k46e dayshiredchild
	ren ag_k46b wagehiredmale
	ren ag_k46d wagehiredfemale
	ren ag_k46f wagehiredchild
	keep region stratum district ta ea rural case_id plot_id *hired* 
	gen season=1
	tempfile dry_hired_all
	save `dry_hired_all' 

	use `rainy_hired_all'
	append using `dry_hired_all'
	lab var season "season: 0=rainy, 1=dry, 2=tree crop"
	label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
	label values season season
	duplicates report region stratum district ta ea case_id plot_id season
	duplicates tag region stratum district ta ea case_id plot_id season, gen(dups)
	//br if dups>0

	duplicates drop region stratum district ta ea case_id plot_id season, force
	drop dups
	reshape long dayshired wagehired, i(region stratum district ta ea case_id plot_id season) j(gender) string //fix zone state etc.
	reshape long days wage, i(region stratum district ta ea case_id plot_id gender season) j(labor_type) string
	recode wage days /*number inkind*/ (.=0) //no number on MWI
	drop if wage==0 & days==0
	gen val = wage*days
	
	/*The Malawi W1 instrument did not ask survey respondents to report number of laborers per day by laborer type. As such, we cannot say with certainty whether survey respondents reported wages paid as [per SINGLE hired laborer by laborer type (male, female, child) per day] or [per ALL hired laborers by laborer type (male, female, child) per day]. Looking at the collapses and scatterplots, it would seem that survey respondents had mixed interpretations of the question, making the value of hired labor more difficult to interpret. As such, we cannot impute the value of hired labor for observations where this is missing, hence the geographic medians section is commented out.*/

	tempfile all_hired
	save `all_hired'

	*Exchange rainy
	use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_d.dta", clear
	/*This code creates three temporary files for exchange labor in the rainy season: rainy_exchange_all, rainy_exchange_nonharvest, and rainy_exchange_harvest. Will append nonharvest and harvest to compare to all.*/
	local qnums "50 52 54" //question numbers
	foreach q in `qnums' {
		use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_d.dta", clear
		ren ag_d00 plot_id
		ren ea_id ea
		merge m:1 case_id ea using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hhids.dta", nogen
		ren ag_d`q'a daysnonhiredmale
		ren ag_d`q'b daysnonhiredfemale
		ren ag_d`q'c daysnonhiredchild
		keep region stratum district ta ea rural case_id plot_id daysnonhired*
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
		duplicates drop region stratum district ta ea rural case_id plot_id season, force //1 duplicate deleted
		reshape long daysnonhired, i(region stratum district ta ea rural case_id plot_id season) j(gender) string
		//reshape long days, i(region stratum district ta ea rural case_id plot_id season gender) j(labor_type) string
		tempfile rainy_exchange`suffix'
		save `rainy_exchange`suffix'', replace
	}
	
	*Exchange dry
    use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_k.dta", clear
	ren ag_k0a plot_id
	ren ea_id ea
	merge m:1 case_id ea using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hhids.dta", nogen
	ren ag_k47a daysnonhiredmale
	ren ag_k47b daysnonhiredfemale
	ren ag_k47c daysnonhiredchild
	keep region stratum district ta ea rural case_id plot_id daysnonhired*
	gen season=1 //dry
	duplicates drop  region stratum district ta ea rural case_id plot_id season, force //3 duplicates deleted
	reshape long daysnonhired, i(region stratum district ta ea rural case_id plot_id season) j(gender) string
	tempfile dry_exchange_all
    save `dry_exchange_all', replace
	append using `rainy_exchange_all'
	lab var season "season: 0=rainy, 1=dry, 2=tree crop"
	label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
	label values season season
	reshape long days, i(region stratum district ta ea rural case_id plot_id season gender) j(labor_type) string
	tempfile all_exchange
	save `all_exchange', replace

	//creates tempfile `members' to merge with household labor later
	use "${Malawi_IHS_W1_raw_data}\Household\hh_mod_b.dta", clear
	ren hh_b01 indiv
	isid case_id indiv
	gen male= (hh_b03==1)
	gen age=hh_b05a
	lab var age "Individual age"
	keep case_id indiv age male
	tempfile members
	save `members', replace

	*Household labor, rainy and dry
	local seasons rainy dry
	foreach season in `seasons' {
		di "`season'"
		if "`season'"=="rainy" {
			local qnums  "42 43 44" //refers to question numbers
			local dk d //refers to module d
			local ag ag_d00
		} 
		else {
			local qnums "43 44 45" //question numbers differ for module k than d
			local dk k //refers to module k
			local ag ag_k0a
		}
		use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_`dk'.dta", clear
		ren `ag' plot_id
		ren ea_id ea
		merge m:1 case_id ea using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hhids.dta", nogen //merges in household info
		
		forvalues k=1(1)3 {
			local q : word `k' of `qnums'
			if `k' == 1 { //where 1 refers to the first value in qnums, question 42 - planting
			local suffix "_planting" 
		}
		else if `k' == 2 { //where 2 refers to the second value in qnums, question 43 - nonharvest
			local suffix "_nonharvest"
		}
		else if `k' == 3 { //where 3 refers to the third value in qnums, question 44 - harvest
			local suffix "_harvest"
		}
		ren ag_`dk'`q'a indiv1`suffix'
		ren ag_`dk'`q'b weeks_worked1`suffix'
		ren ag_`dk'`q'c days_week1`suffix'
		ren ag_`dk'`q'd hours_day1`suffix'
		ren ag_`dk'`q'e indiv2`suffix'
		ren ag_`dk'`q'f weeks_worked2`suffix'
		ren ag_`dk'`q'g days_week2`suffix'
		ren ag_`dk'`q'h hours_day2`suffix'
		ren ag_`dk'`q'i indiv3`suffix'
		ren ag_`dk'`q'j weeks_worked3`suffix'
		ren ag_`dk'`q'k days_week3`suffix'
		ren ag_`dk'`q'l hours_day3`suffix'
		ren ag_`dk'`q'm indiv4`suffix'
		ren ag_`dk'`q'n weeks_worked4`suffix'
		ren ag_`dk'`q'o days_week4`suffix'
		ren ag_`dk'`q'p hours_day4`suffix'
		}
		keep region stratum district ta ea rural case_id plot_id indiv* weeks_worked* days_week* hours_day*
		gen season = "`season'"
		unab vars : *`suffix' //this line generates a list of all the variables that end in suffix 
		local stubs : subinstr local vars "_`suffix'" "", all //this line removes `suffix' from the end of all of the variables that currently end in suffix
		duplicates drop  region stratum district ta ea rural case_id plot_id season, force //one duplicate entry
		reshape long indiv weeks_worked days_week hours_day, i(region stratum district ta ea rural case_id plot_id season) j(num_suffix) string //reshaping double-wide data (planting, nonharvest, harvest, along with persons 1-4)
		split num_suffix, parse(_)
		if "`season'"=="rainy" {
			tempfile rainy
			save `rainy'
		}
		else {
			append using `rainy'
		}
	}

	gen days=weeks_worked*days_week
	gen hours=weeks_worked*days_week*hours_day
	drop if days==. // 307,522 observations deleted
	drop if hours==. //75 observations deleted
	//rescaling fam labor to growing season duration
	preserve
	collapse (sum) days_rescale=days, by(region stratum district ta ea rural case_id plot_id indiv /*season tag*/ season)
	merge m:1 case_id plot_id using"${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_plot_season_length.dta", nogen keep(1 3)
	replace days_rescale = days_grown if days_rescale > days_grown
	tempfile rescaled_days
	save `rescaled_days'
	restore
	//Rescaling to season
	bys case_id plot_id indiv : egen tot_days = sum(days)
	gen days_prop = days/tot_days 
	merge m:1 region stratum district ta ea rural case_id plot_id indiv /*season tag*/ season using `rescaled_days' //all matched
	replace days = days_rescale * days_prop if tot_days > days_grown
	merge m:1 case_id indiv using `members', nogen keep (1 3)
	gen gender="child" if age<15
	replace gender="male" if strmatch(gender,"") & male==1
	replace gender="female" if strmatch(gender,"") & male==0
	gen labor_type="family"
	keep region stratum district ta ea rural case_id plot_id season gender days labor_type
	gen season_fix=0 if season=="rainy"
	replace season_fix=1 if season=="dry"
	drop season
	ren season_fix season
	lab var season "season: 0=rainy, 1=dry, 2=tree crop"
	label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
	label values season season
	append using `all_exchange'

	//Labor expense estimates are severely understated for several reasons: 1. the survey instrument did not ask for number of hired labors. Therefore, the constructed value of hired labor for some households could represent all hired labor costs or per laborer hired labor costs. 2. We typically use the value of hired labor to imput the value of family and nonhired (exchange) labor. However, due to issues with how hired labor is contructed, we cannot use these values to impute the value of family or nonhired (exchange) labor.

	gen val = .
	append using `all_hired'
	keep region stratum district ta ea rural case_id plot_id season days val labor_type gender //MGM: number does not exist for MWI W1
	drop if val==.&days==.
	merge m:1 plot_id case_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)

	// begin chunk: impute values for family and nonhired labor from hired labor by gender (176,670 obs missing out of 180,141 total obs)
	// 1) given hh hired labor for for one plot, impute value of nonhired/family labor given daily wage (val/day) by gender
	// 2) given hh did not hire labor for that plot, impute value of nonhired/family labor given median daily wage (val/day) by gender, district, and season

	preserve
	keep if labor_type == "hired"
	drop if days == 0 | val == 0
	gen hired_wage = val/days
	keep case_id plot_id gender season hired_wage
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

	merge m:1 case_id plot_id gender season using `hired_gender_season', nogen keep(1 3)
	replace val = hired_wage * days if labor_type == "nonhired" | labor_type == "family" // 12,483 real changes
	count if (labor_type == "nonhired" | labor_type == "family") & val == . // 163,882 missing obs for nonhired/family labor despite imputation
	merge m:1 district gender season using `hired_dist_gen_season', nogen keep(1 3)
	replace val = med_dist_gen_wage * days if val == . & (labor_type == "nonhired" | labor_type == "family") // 155,593 real changes
	count if (labor_type == "nonhired" | labor_type == "family") & val == . // 8,294 missing obs for nonhired/family labor despite imputation
	drop if days == 0

	// end chunk

	collapse (sum) val days, by(case_id plot_id season labor_type gender dm_gender) //number does not exist for MWI W1
	la var gender "Gender of worker"
	la var dm_gender "Plot manager gender"
	la var labor_type "Hired, exchange, or family labor"
	la var days "Number of person-days per plot" 
	save "${Malawi_IHS_W1_created_data}/Malawi_IHS_W1_plot_labor_long.dta",replace
	preserve
	collapse (sum) labor_=days, by (case_id plot_id labor_type season)
	reshape wide labor_, i(case_id plot_id season) j(labor_type) string
		la var labor_family "Number of family person-days spent on plot, all seasons"
		la var labor_nonhired "Number of exchange (free) person-days spent on plot, all seasons"
		la var labor_hired "Number of hired labor person-days spent on plot, all seasons"
	save "${Malawi_IHS_W1_created_data}/Malawi_IHS_W1_plot_labor_days.dta",replace 

	//AgQuery
	restore
	// code below is legacy; possible to cut with some updates to summary stats section
	preserve
	gen exp="exp" if strmatch(labor_type,"hired")
	replace exp="imp" if strmatch(exp,"")
	append using `inkind_payments'
	collapse (sum) val, by(case_id plot_id exp dm_gender /*season tag*/ season)
	gen input="labor"
	drop if plot_id == "" | val == 0
	save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_plot_labor.dta", replace //this gets used below.
	restore

	collapse (sum) val, by(case_id plot_id season labor_type dm_gender)
	ren val val_ 
	reshape wide val_, i(case_id plot_id season dm_gender) j(labor_type) string
	ren val* val*_
	gen season_fix="rainy" if season==0
	replace season_fix="dry" if season==1
	drop season
	ren season_fix season
	reshape wide val*, i(case_id plot_id dm_gender) j(season) string
	gen dm_gender2 = "male" if dm_gender==1
	replace dm_gender2 = "female" if dm_gender==2
	replace dm_gender2 = "mixed" if dm_gender==3 
	replace dm_gender2 = "unknown" if dm_gender==.
	drop dm_gender
	ren val* val*_ 
	reshape wide val*, i(case_id plot_id) j(dm_gender2) string
	collapse (sum) val*, by(case_id)
	save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hh_cost_labor.dta", replace


	*********************************
	* 		LAND/PLOT RENTS			*
	*********************************
	* Crops Payments
	use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_d.dta", clear
	gen season=0
	append using "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_k.dta"
	replace season=1 if season==.
	gen cultivate = 0
	replace cultivate = 1 if ag_d14 == 1
	replace cultivate = 1 if ag_k15 == 1 // SS. The question i
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
	
	keep case_id plot_id cultivate season crop_code* qty* unit* condition* payment_period
	reshape long crop_code qty unit condition, i (case_id season plot_id payment_period cultivate) j(payment_status) string
	ren crop_code crop_code_long
	drop if crop_code_long==. //cannot estimate crop values for payments we do not have crop types for
	drop if qty==. //cannot estimate crop values for payments we do not have qty for
	
	// normally, we would execute a conversion of unit [ag_d08c and ag_d10c] = "Other (specify)" to another value for unit that is convertible via cf.dta
	// however, only one observation for ag_d08c and ag_d10c have the value "Other (specify)". That observation does not have a valid crop_code ('.')
	// so, we skip the step of manually converting O/S units to normal units
	
	merge m:1 case_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hhsize.dta", keepusing (region district ta ea) keep(1 3) nogen
	merge m:1 region crop_code_long unit condition using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_cf.dta", keep (1 3) // matched 32 out of 33
	merge m:1 case_id crop_code_long using "${Malawi_IHS_W1_created_data}/Malawi_IHS_W1_hh_crop_prices_for_wages.dta", nogen keep (1 3) //matched 32 out of 33

	gen val=qty*hh_price_mean // one observation possibly data entry error: qty is 50 and unit is 50 kg bag; if this is a data entry error, we are greatly overstating expenses for this observation; reminder to explore winsorization to solve this issue.
	drop qty unit crop_code_long condition hh_price_mean payment_status
	keep if val!=. //14 obs deleted; cannot monetize crop payments without knowing the mean hh price
	tempfile plotrentbycrops
	save `plotrentbycrops'


	* Rainy Cash + In-Kind
	use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_d.dta", clear
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
	keep case_id plot_id val season cult payment_period
	tempfile rainy_land_rents
	save `rainy_land_rents', replace

	* Dry Cash + In-Kind
	use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_k.dta", clear 
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
	keep case_id plot_id val cult payment_period
	gen season = 1 //"Dry"

	* Combine dry + rainy + payments-by-crop
	append using `rainy_land_rents'
	append using `plotrentbycrops'
	lab var season "season: 0=rainy, 1=dry, 2=tree crop"
	label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
	label values season season
	gen input="plotrent"
	gen exp="exp" //all rents are explicit

	duplicates report case_id plot_id season
	duplicates tag case_id plot_id season, gen(dups)
	//br if dups>0
	duplicates drop case_id plot_id season, force //two duplicate entries
	drop dups

	//This chunk identifies and deletes duplicate observations across season modules where an annual payment is recorded twice
	gen check=1 if payment_period==2 & val>0 & val!=.
	duplicates report case_id plot_id payment_period check
	duplicates tag case_id plot_id payment_period check, gen(dups)
	//br if dups>0 & check==1
	drop if dups>0 & check==1 & season==1 // dropping one entry for which the annual plot rents was recorded in both the rainy and dry module
	drop dups check

	gen qty=0
	recode val (.=0)
	collapse (sum) val, by (case_id plot_id season exp input qty cultivate)

	merge m:1 case_id plot_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_plot_areas.dta", keep (1 3)
	count if _m==1 & plot_id!="" & val!=. & val>0
			drop if _m != 3 //9,179 obs deleted
			drop _m

		* Calculate quantity of plot rents etc. 
		replace qty = field_size if val > 0 & val! = . //1,304 changes
		keep case_id plot_id season input exp val qty
		tempfile plotrents
		save `plotrents'	

	******************************************
	* FERTILIZER, PESTICIDES, AND HERBICIDES *
	******************************************
	**# Bookmark #1
	use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_d.dta", clear
	gen season=0
	append using   "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_k.dta"
	ren ag_d00 plot_id
	replace plot_id = ag_k0a if plot_id==""
	drop if plot_id==""
	replace season=1 if season==.
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

	keep case_id ea_id plot_id qty* unit* itemcode* season
	collapse (firstnm) item* qty* unit*, by(case_id ea_id plot_id season) 
	unab vars : *1
	local stubs : subinstr local vars "1" "", all
	reshape long `stubs', i(case_id ea_id plot_id season) j(obs)
	reshape long qty unit itemcode, i(case_id ea_id plot_id season obs) j(input) string
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
	collapse (sum) qty, by(case_id ea_id input itemcode unit season)
	drop if qty==0 | qty==.
	bys case_id ea_id itemcode season : egen max_unit = max(unit)
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
	gen n_units = 0.23*itemcode==1 + 0.18 * itemcode==2 + 0.24*itemcode==3 + 0.46*itemcode==4 + 0.10*itemcode==5 if unit==1
	gen p_units = 0.21*itemcode==1 + 0.46 * itemcode==2 + 0.2*itemcode==5 if unit==1
	gen k_units = 0.1*itemcode==5 if unit==1

	gen n_units_org = 0.02*itemcode==0 

	collapse (sum) n_units p_units k_units n_units_org, by(case_id plot_id) 
	la var n_units "Nitrogen applied as inorganic fertilizer (kg)"
	la var p_units "Phosphate applied (kg)"
	la var k_units "Potash applied (kg)"
	la var n_units_org "Nitrogen applied as manure (assuming 2% N) (kg) "
	save "${Malawi_IHS_W1_created_data}/Malawi_IHS_W1_fertilizer_kg_application.dta", replace
	
	//Question layout here is a bit weird - ag_f/l01 represents the total amount of fertilizer applied. This may be lower than the total amount purchased - the way the questions are worded seems meant to avoid that (i.e., "how much of <this> input"), but I don't think it's reasonable to conclude that most respondents understood that. 

	use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_f.dta", clear
	gen season = 0 
	append using "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_l.dta"
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

	keep qty* unit* otherunit* val* case_id itemcode input season
	gen dummya = _n
	unab vars : *1
	local stubs : subinstr local vars "1" "", all
	reshape long `stubs', i (case_id dummya itemcode input) j(entry_no)
	drop entry_no
	replace dummya=_n
	unab vars2 : *exp
	local stubs2 : subinstr local vars2 "exp" "", all
	reshape long `stubs2', i(case_id dummya itemcode input) j(exp) string
	replace dummya=_n
	reshape long qty unit val, i(case_id exp dummya itemcode input) j(type) string
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
	collapse (sum) val qty, by(season case_id input itemcode exp unit)

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
	merge m:1 case_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_weights.dta", nogen keep(1 3)
	gen obs=1
	foreach i in region district ta ea {
		bys `i' input itemcode : egen obs_`i' = sum(obs)
		bys `i' itemcode input unit season : egen price_unit_`i'=median(price_unit)
	}
	bys `i' itemcode input unit season : egen price_unit_`i'=median(price_unit)
	keep ea case_id itemcode unit price_unit_* obs_* input
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
	bys case_id input itemcode season : egen tot_qty = sum(qty)
	gen exp_ratio = qty/tot_qty if exp=="exp"
	replace exp_ratio = 0 if exp_ratio == . & input!="transfert"
	collapse (sum) qty val (max) exp_ratio, by(case_id input itemcode unit season)
	ren input input_hh
	merge 1:1 case_id season itemcode using `hh_input_kg', nogen
	recode hh_qty_kg qty (.=0)
	replace qty = hh_qty_kg if qty < hh_qty_kg 
	*assert qty == hh_qty_kg
	replace qty=0 if input_hh=="transfert" //0 changes 2.29.24
	recode val (0=.)
	keep if qty>0 //1,727 deleted 2.29.24 
	drop hh_qty_kg
	replace exp_ratio = 0 if exp_ratio == . // we assume that missing values correspond to items that were consumed but not purchased, an implicit category
	preserve
	gen ratioimp = 1 - exp_ratio
	ren exp_ratio ratioexp
	reshape long ratio, i(case_id itemcode season) j(exp) string
	tempfile phys_inputs1
	save `phys_inputs1'
	restore
	tempfile phys_inputs
	save `phys_inputs'

	drop if input=="transfert" | val==.
	gen price_kg = val/qty  //note apparent data entry error for 23:21:0 in hhid==101012040045
	merge m:1 case_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_weights.dta", nogen keep(1 3)
	gen obs=1
	foreach i in region district ta ea case_id {
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
	merge m:1 case_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_weights.dta", nogen keep(1 3) keepusing(region district ta ea)
	foreach i in region district ta ea case_id {
	merge m:1 `i' itemcode input season using `input_price_`i'', nogen keep(1 3)
	}
	merge m:1 itemcode input season using `input_price_country', nogen


	gen val = qty*price_kg_case_id
	gen missing_val = val==.
	recode obs* (.=0)
	foreach i in country region district ta ea {
		replace val = qty*price_kg_`i' if unit==2 & missing_val==1 & obs_`i' > 9
	}
	//generate exp/imp observations on a plot-level based on hh-level data
	merge m:1 case_id itemcode season using `phys_inputs', keepusing(exp_ratio) keep(1 3)
	drop if case_id == "" | exp_ratio == .
	duplicates drop // 125 duplicates dropped
	collapse (sum) qty val (mean) exp_ratio obs_* price_kg_* missing_*, by(case_id ea_id plot_id season input unit itemcode ea district ta region) //60 duplicate observations where qty and val were different. E.g. val1 = 40 and val2 = 30
	gen ratioimp = 1-exp_ratio
	ren exp_ratio ratioexp
	reshape long ratio, i(case_id plot_id season itemcode) j(exp) string
	replace val = val * ratio
	drop ratio
	drop if plot_id == "" | val == 0 // removes null values

	tempfile phys_inputs_plot
	save `phys_inputs_plot'

	*********************************
	* 			 SEED			    *
	*********************************
	use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_h.dta", clear
	gen season = 0
	append using "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_n.dta"
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

	keep qty* unit* val* case_id seedcode season
	gen dummya = _n
	unab vars : *1
	local stubs : subinstr local vars "1" "", all
	reshape long `stubs', i (case_id dummya seedcode) j(entry_no)
	drop entry_no
	replace dummya=_n
	unab vars2 : *exp
	local stubs2 : subinstr local vars2 "exp" "", all
	drop if qtyseedexp==. & valseedsexp==.
	reshape long `stubs2', i(case_id dummya seedcode) j(exp) string
	replace dummya=_n
	reshape long qty unit val, i(case_id exp dummya seedcode) j(input) string
	tab val if exp=="imp" & input=="seedtrans"
	drop if strmatch(exp,"imp") & strmatch(input, "seedtrans") //No implicit transportation costs
	label define unitrecode 1 "Kilogram" 4 "Pail (small)" 5 "Pail (large)" 6 "No 10 Plate" 7 "No 12 Plate" 8 "Bunch" 9 "Piece" 11 "Basket (Dengu)" 120 "Packet, modify
	label values unit unitrecode

	drop if (qty==. | qty==0) & strmatch(input, "seed") //7,500 obs deleted - cannot impute val without qty for seed
	drop if unit==. & strmatch(input, "seed") //0 obs deleted - cannot impute val without unit for seed
	gen byte qty_missing = missing(qty) //only relevant to seedtrans
	gen byte val_missing = missing(val)
	collapse (sum) val qty, by(case_id unit seedcode exp input qty_missing val_missing /*season tag*/ season)
	replace qty =. if qty_missing
	replace val =. if val_missing
	drop qty_missing val_missing

	ren seedcode crop_code_long
	drop if crop_code_long==. & strmatch(input, "seed") //0 obs deleted
	gen condition=1 
	replace condition=3 if inlist(crop_code, 5, 6, 7, 8, 10, 28, 29, 30, 31, 32, 33, 37, 39, 40, 41, 42, 43, 44, 45, 47) //4,896 real changes //these are crops for which the cf file only has entries with condition as N/A
	merge m:1 case_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hhsize.dta", keepusing (region district ta ea) keep(1 3) nogen
	merge m:1 region crop_code_long unit condition using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_cf.dta", keep (1 3)

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

	use "${Malawi_IHS_W1_raw_data}\Household\hh_mod_m.dta", clear // reported at the household level
	rename hh_m0a itemid
	gen anml = (itemid>=609 & itemid<=610) // Ox Cart, Ox Plow
	gen mech = (itemid>=601 & itemid<= 608 | itemid>=611 & itemid<=612 | itemid>=613 & itemid <=625) // Hand hoe, slasher, axe, sprayer, panga knife, sickle, treadle pump, watering can, ridger, cultivator, generator, motor pump, grain mill, other, chicken house, livestock and poultry kraal, storage house, granary, barn, pig sty and tractor (to align with NGA LSMS-ISA)
	rename hh_m14 rental_cost 
	gen rental_cost_anml = rental_cost if anml==1
	gen rental_cost_mech = rental_cost if mech==1
	recode rental_cost_anml rental_cost_mech (.=0)

	collapse (sum) rental_cost_anml rental_cost_mech, by (case_id)
	lab var rental_cost_anml "Costs for renting animal traction"
	lab var rental_cost_mech "Costs for renting other agricultural items" 
	save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_asset_rental_costs.dta", replace

	ren rental_cost_* val*
	reshape long val, i(case_id) j(var) string
	ren var input
	gen exp = "exp" //all rents are explict
	tempfile asset_rental
	save `asset_rental'

	*********************************************
	*   TREE/ PERMANENT CROP TRANSPORTATION	    *
	*********************************************
	use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_q.dta", clear
	ren ag_q10 valtreetrans
	collapse (sum) val, by (case_id)
	reshape long val, i(case_id) j(var) string
	ren var input
	gen exp = "exp"
	tempfile tree_transportation
	save `tree_transportation'

	*********************************************
	*       TEMPORARY CROP TRANSPORTATION       *
	*********************************************
	use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_o.dta", clear
	append using "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_i.dta"
	egen valtempcroptrans = rowtotal(ag_i10 ag_o10)
	collapse (sum) val, by(case_id)
	reshape long val, i(case_id) j(var) string
	ren var input
	gen exp = "exp"
	tempfile tempcrop_transportation
	save `tempcrop_transportation'

	*********************************************
	*     	COMBINING AND GETTING PRICES	    *
	*********************************************

	use `plotrents', clear
	save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_cost_per_plot.dta", replace 

	recast str50 case_id, force 
	merge m:1 case_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_weights.dta",gen(weights) keep(1 3) keepusing(weight region district ea ta) //added geo vars here to avoid having to merge in later using a diff file

	merge m:1 case_id plot_id season using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_plot_areas.dta", gen(plotareas) keep(1 3) keepusing(field_size) 
	merge m:1 case_id plot_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_plot_decision_makers.dta", gen(dms) keep(1 3) keepusing(dm_gender) 
	gen plotweight = weight*field_size // 02.07.24: Still ~3000 missing values here, needs follow-up
	tempfile all_plot_inputs
	save `all_plot_inputs', replace

	* Calculating Geographic Medians for PLOT LEVEL files
	keep if strmatch(exp,"exp") & qty!=. 
	recode val (0=.)
	*drop if unit==0 //Remove things with unknown units
	gen price = val/qty
	drop if price==.
	gen obs=1

	* dropped "unit" and "itemcode" from all of these loops bc we don't have them anymore (since phys inputs is not at plot level)
	capture restore,not 
	foreach i in ea ta district region case_id {
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
	foreach i in ea ta district region case_id {
		merge m:1 `i' input using `price_`i'_median', nogen keep(1 3) 
	}
		merge m:1 input using `price_country_median', nogen keep(1 3)
		recode price_case_id (.=0)
		gen price=price_case_id
	foreach i in country ea ta district region  {
		replace price = price_`i' if obs_`i' > 9 & obs_`i'!=.
	}
	
	
	//Default to household prices when available
	replace price = price_case_id if price_case_id>0
	replace qty = 0 if qty <0 
	recode val qty (.=0)
	drop if val==0 & qty==0 //Dropping unnecessary observations.
	replace val=qty*price if val==0

	append using `phys_inputs_plot'

	* For PLOT LEVEL data, add in plot_labor data
	append using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_plot_labor.dta" 
	collapse (sum) val, by (case_id plot_id exp input dm_gender /*season tag*/ season) 
	drop if plot_id == "" // drop null values from labor append

	* Save PLOT-LEVEL Crop Expenses (long)
	save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_plot_cost_inputs_long.dta",replace 

	* Save PLOT-Level Crop Expenses (wide, does not currently get used in MWI W4 code)
	preserve
	collapse (sum) val_=val, by(case_id plot_id exp dm_gender /*season tag*/ season)
	reshape wide val_, i(case_id plot_id dm_gender /*season tag*/ season) j(exp) string 
	save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_plot_cost_inputs.dta", replace // This used to get used below in CROP EXPENSES - currently commented out, we'll see if it gets revived
	restore

	*Aggregate PLOT-LEVEL crop expenses data up to HH level and append to HH LEVEL data.	
	preserve
	use "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_plot_cost_inputs_long.dta", clear
	collapse (sum) val, by(case_id input exp /*season tag*/ season)
	tempfile plot_to_hh_cropexpenses
	save `plot_to_hh_cropexpenses', replace
	restore


*** HH LEVEL Files: seed, asset_rental, phys inputs
	use `seed', clear
	append using `asset_rental'
	append using `phys_inputs1'
	append using `tree_transportation'
	append using `tempcrop_transportation'
	recast str50 case_id, force
	merge m:1 case_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_weights.dta", nogen keep(1 3) keepusing(weight region district ea ta) // merge in hh weight & geo data 
	tempfile all_HH_LEVEL_inputs
	save `all_HH_LEVEL_inputs', replace

	* Calculating Geographic Medians for HH LEVEL files
	keep if strmatch(exp,"exp") // & qty!=. //qty not a relevant filter
	recode val (0=.)
	drop if unit==0 | unit == . //Remove things with unknown units.
	gen price = val/qty
	drop if price==. // drops 33,281 observations
	gen obs=1

	* Plotweight has been changed to aw = qty*weight (where weight is population weight) 
	foreach i in ea ta district region case_id {
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
	foreach i in ea ta district region case_id {
		merge m:1 `i' input unit itemcode using `price_`i'_median', nogen keep(1 3) 
	}
		merge m:1 input unit itemcode using `price_country_median', nogen keep(1 3)
		recode price_case_id (.=0)
		gen price=price_case_id
	foreach i in country ea ta district region  {
		replace price = price_`i' if obs_`i' > 9 & obs_`i'!=.
	}
	
	//Default to household prices when available
	replace price = price_case_id if price_case_id>0
	replace qty = 0 if qty <0 // Remove any households reporting negative quantities of fertilizer.
	recode val qty (.=0)
	drop if val==0 & qty==0 //Dropping unnecessary observations.
	replace val=qty*price if val==0
	replace input = "orgfert" if itemcode==5
	replace input = "inorg" if strmatch(input,"fert")

	preserve
	keep if strpos(input,"orgfert") | strpos(input,"inorg") | strpos(input,"herb") | strpos(input,"pest")
	//Unfortunately we have to compress liters and kg here, which isn't ideal.
	collapse (sum) qty_=qty, by(case_id /*plot_id garden*/ input season)
	reshape wide qty_, i(case_id season) j(input) string
	ren qty_inorg inorg_fert_rate
	ren qty_orgfert org_fert_rate
	ren qty_pest pest_rate
	ren qty_herb herb_rate
	la var inorg_fert_rate "Qty inorganic fertilizer used (kg)"
	la var org_fert_rate "Qty organic fertilizer used (kg)"
	la var herb_rate "Qty of herbicide used (kg/L)"
	la var pest_rate "Qty of pesticide used (kg/L)"	
	save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_input_quantities.dta", replace
	restore	
	
	* Save HH-LEVEL Crop Expenses (long)
	preserve
	collapse (sum) val, by(case_id exp input region district ea ta)
	save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hh_cost_inputs_long.dta", replace
	restore

	* COMBINE HH-LEVEL crop expenses (long) with PLOT level data (long) aggregated up to HH LEVEL:
	use "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hh_cost_inputs_long.dta", clear
	append using `plot_to_hh_cropexpenses'
	collapse (sum) val, by(case_id exp input region district ea ta)
	save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hh_cost_inputs_long_complete.dta", replace


********************************************************************************
* MONOCROPPED PLOTS *
********************************************************************************
use "${Malawi_IHS_W1_created_data}/Malawi_IHS_W1_all_plots.dta", clear
	keep if purestand==1 //& relay!=1 //MWI does not distinguish relay crops
	save "${Malawi_IHS_W1_created_data}/Malawi_IHS_W1_monocrop_plots.dta", replace
	
//Setting things up for AgQuery first
use "${Malawi_IHS_W1_created_data}/Malawi_IHS_W1_all_plots.dta", clear
	merge m:1 case_id plot_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
	ren ha_planted monocrop_ha
	ren quant_harv_kg kgs_harv_mono
	ren value_harvest val_harv_mono
	collapse (sum) *mono*, by(case_id plot_id crop_code dm_gender)
	
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
	save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_monocrop_plots.dta", replace
	
	foreach i in `cn'_monocrop_ha kgs_harv_mono_`cn' val_harv_mono_`cn' `cn'_monocrop {
		gen `i'_male = `i' if dm_gender==1
		gen `i'_female = `i' if dm_gender==2
		gen `i'_mixed = `i' if dm_gender==3
	}
	collapse (sum) *monocrop_ha* kgs_harv_mono* val_harv_mono* (max) `cn'_monocrop `cn'_monocrop_male `cn'_monocrop_female `cn'_monocrop_mixed, by(case_id)
	la var `cn'_monocrop_ha "Total `cn' monocrop hectares - Household"
	la var `cn'_monocrop "Household has at least one `cn' monocrop"
	la var kgs_harv_mono_`cn' "Total kilograms of `cn' harvested - Household"
	la var val_harv_mono_`cn' "Value of harvested `cn' (MWK)"
	foreach g in male female mixed {
		la var `cn'_monocrop_ha_`g' "Total `cn' monocrop hectares on `g' managed plots - Household"
		la var kgs_harv_mono_`cn'_`g' "Total kilograms of `cn' harvested on `g' managed plots - Household"
		la var val_harv_mono_`cn'_`g' "Total value of `cn' harvested on `g' managed plots - Household"
	}
	save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_`cn'_monocrop_hh_area.dta", replace
	}
	}
restore
}

use "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_plot_cost_inputs_long.dta", clear
merge m:1 case_id plot_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
collapse (sum) val, by(case_id plot_id dm_gender input)
levelsof input, clean l(input_names)
	ren val val_
	reshape wide val_, i(case_id plot_id dm_gender) j(input) string
	gen dm_gender2 = "male" if dm_gender==1
	replace dm_gender2 = "female" if dm_gender==2
	replace dm_gender2 = "mixed" if dm_gender==3
	replace dm_gender2 = "unknown" if dm_gender==.
	drop dm_gender
foreach cn in $topcropname_area {
preserve
	//keep if strmatch(exp, "exp")
	//drop exp
	capture confirm file "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_`cn'_monocrop.dta"
	if !_rc {
	ren val* val*_`cn'_
	reshape wide val*, i(case_id plot_id) j(dm_gender2) string
	merge 1:1 case_id plot_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_`cn'_monocrop.dta", nogen keep(3)
	count
	if(r(N) > 0){
	collapse (sum) val*, by(case_id)
	foreach i in `input_names' {
		egen val_`i'_`cn'_hh = rowtotal(val_`i'_`cn'_male val_`i'_`cn'_female val_`i'_`cn'_mixed val_`i'_`cn'_unknown)
	}
	save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_inputs_`cn'.dta", replace
	}
	}
restore
}

drop if plot_id==""
//drop missing plot_ids
//for backwards compatibility

********************************************************************************
* LIVESTOCK INCOME *
********************************************************************************
*Expenses
use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_r1.dta", clear
append using "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_r2.dta"
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
	collapse (sum) cost_fodder_livestock cost_vaccines_livestock cost_othervet_livestock cost_hired_labor_livestock cost_input_livestock, by (case_id)
	egen cost_lrum = rowtotal (cost_fodder_livestock cost_vaccines_livestock cost_othervet_livestock cost_hired_labor_livestock cost_input_livestock)
	keep case_id cost_lrum
	lab var cost_lrum "Livestock expenses for large ruminants"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_lrum_expenses", replace
restore 

preserve 
	rename ag_r0a livestock_code
	gen species = (inlist(livestock_code, 301,302,303,304,3304)) + 2*(inlist(livestock_code,307,308)) + 3*(livestock_code==309) + 4*(livestock_code==3305) + 5*(inlist(livestock_code, 311,313,315,319,3310,3314))
	recode species (0=.)
	la def species 1 "Large ruminants (calf, steer/heifer, cow, bull, ox)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses, donkeys)" 5 "Poultry"
	la val species species

	collapse (sum) cost_medical_livestock, by (case_id species) 
	rename cost_medical_livestock ls_exp_med
		foreach i in ls_exp_med{
			gen `i'_lrum = `i' if species==1
			gen `i'_srum = `i' if species==2
			gen `i'_pigs = `i' if species==3
			gen `i'_equine = `i' if species==4
			gen `i'_poultry = `i' if species==5
		}
	
collapse (firstnm) *lrum *srum *pigs *equine *poultry, by(case_id)

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
	save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_expenses_animal", replace
restore 

collapse (sum) cost_fodder_livestock cost_vaccines_livestock cost_othervet_livestock cost_medical_livestock cost_hired_labor_livestock cost_input_livestock, by (case_id)
lab var cost_fodder_livestock "Cost for fodder for livestock"
lab var cost_vaccines_livestock "Cost for vaccines for livestock"
lab var cost_othervet_livestock "Cost for other veterinary treatment for livestock"
lab var cost_medical_livestock "Cost for vaccines, medicines and other veterinary treatment for livestock"
lab var cost_hired_labor_livestock
lab var cost_input_livestock "Cost for inputs for livestock"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_expenses", replace

*Livestock products 
* Milk
use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_s.dta", clear
rename ag_s0a product_code
keep if product_code==401
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
keep case_id product_code milk_liters_produced price_per_liter price_per_unit quantity_produced earnings_milk_year 
lab var price_per_liter "Price of milk per liter sold"
lab var price_per_unit "Price of milk per unit sold" 
lab var quantity_produced "Quantity of milk produced"
lab var earnings_milk_year "Total earnings of sale of milk produced"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_products_milk", replace

* Other livestock products
// Includes milk, eggs, honey, meat, hides/skins, and manure.
use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_s.dta", clear
rename ag_s0a livestock_code
rename ag_s02 months_produced
rename ag_s03a quantity_month
rename ag_s03b quantity_month_unit

replace livestock_code = 404 if strmatch(ag_s0a_os, "CHICKEN") | strmatch(ag_s0a_os, "CHICKEN MEAT") | strmatch(ag_s0a_os, "DOVE") | strmatch(ag_s0a_os, "PIGEON")
replace quantity_month_unit =. if livestock_code==401 & quantity_month_unit!=1     // milk, keeping only liters. 
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
keep case_id livestock_code quantity_produced price_per_unit earnings_sales

label define livestock_code_label 401 "Milk" 402 "Chicken Eggs" 403 "Guinea Fowl Eggs" 404 "Meat" 406 "Skin/Hide" 407 "Manure"
label values livestock_code livestock_code_label
bys livestock_code: sum price_per_unit
gen price_per_unit_hh = price_per_unit
lab var price_per_unit "Price of milk per unit sold"
lab var price_per_unit_hh "Price of milk per unit sold at household level"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_products_other", replace

use "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_products_milk", clear
append using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_products_other"
recode price_per_unit (0=.)
merge m:1 case_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hhids.dta"
drop if _merge==2
drop _merge
replace price_per_unit = . if price_per_unit == 0 
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_products", replace

* ea Level
use "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_products", clear
keep if price_per_unit !=. 
gen observation = 1
bys region district ta ea livestock_code: egen obs_ea = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district ta ea livestock_code obs_ea)
rename price_per_unit price_median_ea
lab var price_median_ea "Median price per unit for this livestock product in the ea"
lab var obs_ea "Number of sales observations for this livestock product in the ea"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_products_prices_ea.dta", replace

* ta Level
use "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region district ta livestock_code: egen obs_ta = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district ta livestock_code obs_ta)
rename price_per_unit price_median_ta
lab var price_median_ta "Median price per unit for this livestock product in the ta"
lab var obs_ta "Number of sales observations for this livestock product in the ta"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_products_prices_ta.dta", replace

* District Level
use "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region district livestock_code: egen obs_district = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district livestock_code obs_district)
rename price_per_unit price_median_district
lab var price_median_district "Median price per unit for this livestock product in the district"
lab var obs_district "Number of sales observations for this livestock product in the district"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_products_prices_district.dta", replace

* Region Level
use "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_unit [aw=weight], by (region livestock_code obs_region)
rename price_per_unit price_median_region
lab var price_median_region "Median price per unit for this livestock product in the region"
lab var obs_region "Number of sales observations for this livestock product in the region"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_products_prices_region.dta", replace

* Country Level
use "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_unit [aw=weight], by (livestock_code obs_country)
rename price_per_unit price_median_country
lab var price_median_country "Median price per unit for this livestock product in the country"
lab var obs_country "Number of sales observations for this livestock product in the country"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_products_prices_country.dta", replace

use "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_products", clear
merge m:1 region district ta ea livestock_code using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_products_prices_ea.dta"
drop _merge
merge m:1 region district ta livestock_code using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_products_prices_ta.dta"
drop _merge
merge m:1 region district livestock_code using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_products_prices_district.dta"
drop _merge
merge m:1 region livestock_code using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_products_prices_region.dta"
drop _merge
merge m:1 livestock_code using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_products_prices_country.dta"
drop _merge
replace price_per_unit = price_median_ea if price_per_unit==. & obs_ea >= 10
replace price_per_unit = price_median_ta if price_per_unit==. & obs_ta >= 10
replace price_per_unit = price_median_district if price_per_unit==. & obs_district >= 10 
replace price_per_unit = price_median_region if price_per_unit==. & obs_region >= 10 
replace price_per_unit = price_median_country if price_per_unit==.
lab var price_per_unit "Price per unit of this livestock product, with missing values imputed using local median values"

gen value_milk_produced = milk_liters_produced * price_per_unit 
gen value_eggs_produced = quantity_produced * price_per_unit if livestock_code==402|livestock_code==403
gen value_other_produced = quantity_produced * price_per_unit if livestock_code== 404|livestock_code==406|livestock_code==407
egen sales_livestock_products = rowtotal(earnings_sales earnings_milk_year)		
collapse (sum) value_milk_produced value_eggs_produced value_other_produced sales_livestock_products, by (case_id)

*First, constructing total value
egen value_livestock_products = rowtotal(value_milk_produced value_eggs_produced value_other_produced)
lab var value_livestock_products "value of livesotck prodcuts produced (milk, eggs, other)"
*Now, the share
gen share_livestock_prod_sold = sales_livestock_products/value_livestock_products
replace share_livestock_prod_sold = 1 if share_livestock_prod_sold>1 & share_livestock_prod_sold!=.
lab var share_livestock_prod_sold "Percent of production of livestock products that is sold" 
lab var value_milk_produced "Value of milk produced"
lab var value_eggs_produced "Value of eggs produced"
lab var value_other_produced "Value of skins, meat and manure produced"
recode value_milk_produced value_eggs_produced value_other_produced (0=.)
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hh_livestock_products", replace
 
* Manure (Dung)
use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_s.dta", clear
rename ag_s0a livestock_code
rename ag_s06 earnings_sales
gen sales_manure=earnings_sales if livestock_code==407 
recode sales_manure (.=0)
collapse (sum) sales_manure, by (case_id)
lab var sales_manure "Value of manure sold" 
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_manure.dta", replace

*Sales (live animals)
use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_r1.dta", clear
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
merge m:1 case_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hhids.dta"
drop if _merge==2
drop _merge
keep case_id weight region district ta ea livestock_code number_sold income_live_sales number_slaughtered price_per_animal value_livestock_purchases
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hh_livestock_sales", replace

*Implicit prices 
* ea Level
use "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district ta ea livestock_code: egen obs_ea = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district ta ea livestock_code obs_ea)
rename price_per_animal price_median_ea
lab var price_median_ea "Median price per unit for this livestock in the ea"
lab var obs_ea "Number of sales observations for this livestock in the ea"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_prices_ea.dta", replace

* ta Level
use "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district ta livestock_code: egen obs_ta = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district ta livestock_code obs_ta)
rename price_per_animal price_median_ta
lab var price_median_ta "Median price per unit for this livestock in the ta"
lab var obs_ta "Number of sales observations for this livestock in the ta"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_prices_ta.dta", replace

* District Level
use "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district livestock_code: egen obs_district = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district livestock_code obs_district)
rename price_per_animal price_median_district
lab var price_median_district "Median price per unit for this livestock in the district"
lab var obs_district "Number of sales observations for this livestock in the district"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_prices_district.dta", replace

* Region Level
use "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_animal [aw=weight], by (region livestock_code obs_region)
rename price_per_animal price_median_region
lab var price_median_region "Median price per unit for this livestock in the region"
lab var obs_region "Number of sales observations for this livestock in the region"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_prices_region.dta", replace

* Country Level
use "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_animal [aw=weight], by (livestock_code obs_country)
rename price_per_animal price_median_country
lab var price_median_country "Median price per unit for this livestock in the country"
lab var obs_country "Number of sales observations for this livestock in the country"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_prices_country.dta", replace

use "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hh_livestock_sales", clear
merge m:1 region district ta ea livestock_code using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_prices_ea.dta"
drop _merge
merge m:1 region district ta livestock_code using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_prices_ta.dta"
drop _merge
merge m:1 region district livestock_code using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_prices_district.dta"
drop _merge
merge m:1 region livestock_code using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_prices_region.dta"
drop _merge
merge m:1 livestock_code using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_prices_country.dta"
drop _merge
replace price_per_animal = price_median_ea if price_per_animal==. & obs_ea >= 10
replace price_per_animal = price_median_ta if price_per_animal==. & obs_ta >= 10
replace price_per_animal = price_median_district if price_per_animal==. & obs_district >= 10
replace price_per_animal = price_median_region if price_per_animal==. & obs_region >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_lvstck_sold = price_per_animal * number_sold
gen value_slaughtered = price_per_animal * number_slaughtered

collapse (sum) value_livestock_purchases value_lvstck_sold, by (case_id)
drop if case_id==""
lab var value_livestock_purchases "Value of livestock purchases"
lab var value_lvstck_sold "Value of livestock sold live" 
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_sales", replace

*TLU (Tropical Livestock Units)
use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_r1.dta", clear
rename ag_r0a lvstckid
gen tlu_coefficient=0.5 if (lvstckid==301|lvstckid==302|lvstckid==303|lvstckid==304|lvstckid==3304) // calf, steer/heifer, cow, bull, ox
replace tlu_coefficient=0.1 if (lvstckid==307|lvstckid==308) //goats, sheep
replace tlu_coefficient=0.2 if (lvstckid==309) // pigs
replace tlu_coefficient=0.01 if (lvstckid==311|lvstckid==313|lvstckid==315|lvstckid==319|lvstckid==3310|lvstckid==3314) // local hen, cock, duck, dove/pigeon, chicken layer/broiler, turkey/guinea fowl
replace tlu_coefficient=0.3 if (lvstckid==3305) // donkey/mule/horse
lab var tlu_coefficient "Tropical Livestock Unit coefficient"

rename lvstckid livestock_code
rename ag_r07 number_1yearago
rename ag_r02 number_today_total
rename ag_r03 number_today_exotic
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
gen species = (inlist(livestock_code,301,302,202,204,3304)) + 2*(inlist(livestock_code,307,308)) + 3*(livestock_code==309) + 4*(livestock_code==3305) + 5*(inlist(livestock_code,311,313,315,319,3310,3314))
recode species (0=.)
la def species 1 "Large ruminants (calves, steer/heifer, cows, bulls, oxen)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses, donkeys, mules)" 5 "Poultry"
la val species species
ren ea_id ea

*Now to household level
*First, generating these values by species
preserve
collapse (firstnm) share_imp_herd_cows (sum) number_today_total number_1yearago animals_lost12months lost_disease number_today_exotic lvstck_holding=number_today_total, by(case_id species)
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
collapse (sum) number_today_total number_today_exotic (firstnm) *lrum *srum *pigs *equine *poultry share_imp_herd_cows, by(case_id)

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
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_herd_characteristics", replace
restore

gen price_per_animal = income_live_sales / number_sold
merge m:1 case_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hhids.dta"
drop if _merge==2
drop _merge
merge m:1 region district ta ea livestock_code using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_prices_ea.dta"
drop _merge
merge m:1 region district ta livestock_code using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_prices_ta.dta"
drop _merge
merge m:1 region district livestock_code using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_prices_district.dta"
drop _merge
merge m:1 region livestock_code using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_prices_region.dta"
drop _merge
merge m:1 livestock_code using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_prices_country.dta"
drop _merge 
recode price_per_animal (0=.)
replace price_per_animal = price_median_ea if price_per_animal==. & obs_ea >= 10
replace price_per_animal = price_median_ta if price_per_animal==. & obs_ta >= 10
replace price_per_animal = price_median_district if price_per_animal==. & obs_district >= 10
replace price_per_animal = price_median_region if price_per_animal==. & obs_region >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_1yearago = number_1yearago * price_per_animal
gen value_today = number_today_total * price_per_animal
collapse (sum) tlu_1yearago tlu_today value_1yearago value_today, by (case_id)
lab var tlu_1yearago "Tropical Livestock Units as of 12 months ago"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
gen lvstck_holding_tlu = tlu_today
lab var lvstck_holding_tlu "Total HH livestock holdings, TLU"  
lab var value_1yearago "Value of livestock holdings from one year ago"
lab var value_today "Value of livestock holdings today"
drop if case_id==""
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_TLU.dta", replace

*Livestock income
use "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_sales", clear
merge 1:1 case_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hh_livestock_products"
drop _merge
merge 1:1 case_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_manure.dta"
drop _merge
merge 1:1 case_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_expenses"
drop _merge
merge 1:1 case_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_TLU.dta"
drop _merge

gen livestock_income = value_lvstck_sold + - value_livestock_purchases ///
+ (value_milk_produced + value_eggs_produced + value_other_produced + sales_manure) ///
- (cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_othervet_livestock + cost_input_livestock)

lab var livestock_income "Net livestock income"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_income.dta", replace

********************************************************************************
* FISH INCOME *
********************************************************************************
*Fishing expenses  
// Method of calculating ft and pt weeks and days consistent with ag module indicators for rainy/dry seasons
use "${Malawi_IHS_W1_raw_data}\Fisheries\fs_mod_c.dta", clear
append using "${Malawi_IHS_W1_raw_data}\Fisheries\fs_mod_g.dta"
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
collapse (max) weeks_fishing days_per_week, by (case_id) 
keep case_id weeks_fishing days_per_week
lab var weeks_fishing "Weeks spent working as a fisherman (maximum observed across individuals in household)"
lab var days_per_week "Days per week spent working as a fisherman (maximum observed across individuals in household)"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_weeks_fishing.dta", replace

use "${Malawi_IHS_W1_raw_data}\Fisheries\fs_mod_d1.dta", clear
append using "${Malawi_IHS_W1_raw_data}\Fisheries\fs_mod_h2.dta"
merge m:1 case_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_weeks_fishing.dta"
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
collapse (sum) cost_fuel rental_costs_fishing, by (case_id)
lab var cost_fuel "Costs for fuel over the past year"
lab var rental_costs_fishing "Costs for other fishing expenses over the past year"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_fishing_expenses_1.dta", replace // Not including hired labor costs, keeping consistent with other LSMS-ISA countries. May reassess.

*TODO: Other needs to get disaggregated

* Fish Prices
use "${Malawi_IHS_W1_raw_data}\Fisheries\fs_mod_e1.dta", clear
append using "${Malawi_IHS_W1_raw_data}\Fisheries\fs_mod_i1.dta"
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
merge m:1 case_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hhids.dta"
drop if _merge==2
drop _merge
recode price_per_unit (0=.) 
collapse (median) price_per_unit [aw=weight], by (fish_code unit)
rename price_per_unit price_per_unit_median
replace price_per_unit_median = . if fish_code==11
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_fish_prices.dta", replace

* Value of fish harvest & sales 
use "${Malawi_IHS_W1_raw_data}\Fisheries\fs_mod_e1.dta", clear
append using "${Malawi_IHS_W1_raw_data}\Fisheries\fs_mod_i1.dta"
rename fs_e02 fish_code 
replace fish_code=fs_i02 if fish_code==. 
recode fish_code (12=11) // recoding "aggregate" from low season to "other"
rename fs_e06a fish_quantity_year // high season
replace fish_quantity_year=fs_i06a if fish_quantity_year==. // low season
rename fs_e06b unit  // piece, dozen/bundle, kg, small basket, large basket
merge m:1 fish_code unit using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_fish_prices.dta"
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
collapse (sum) value_fish_harvest income_fish_sales, by (case_id)
recode value_fish_harvest income_fish_sales (.=0)
lab var value_fish_harvest "Value of fish harvest (including what is sold), with values imputed using a national median for fish-unit-prices"
lab var income_fish_sales "Value of fish sales"
//Need some sort of SOP for when value_harvest > 0 but income = 0 due to missing information
//Questionable values: small dataset and it looks like only some of the prices were recorded
//per piece. Others look like they are totals. 
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_fish_income.dta", replace

********************************************************************************
* SELF-EMPLOYMENT INCOME *
********************************************************************************
*Self-employment income
use "${Malawi_IHS_W1_raw_data}\Household\hh_mod_n2.dta", clear
rename hh_n40 last_months_profit
gen self_employed_yesno = .
replace self_employed_yesno = 1 if last_months_profit !=.
replace self_employed_yesno = 0 if last_months_profit == .
collapse (max) self_employed_yesno (sum) last_months_profit, by(case_id)
lab var self_employed_yesno "1=Household has at least one member with self-employment income"
drop if self != 1
ren last_months_profit self_employ_income
lab var self_employ_income "self employment income in previous month"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_self_employment.dta", replace

*Fish trading
use "${Malawi_IHS_W1_raw_data}\Fisheries\fs_mod_c.dta", clear
append using "${Malawi_IHS_W1_raw_data}\Fisheries\fs_mod_g.dta"
rename fs_c04a weeks_fish_trading 
replace weeks_fish_trading=fs_g04a if weeks_fish_trading==.
recode weeks_fish_trading (.=0)
collapse (max) weeks_fish_trading, by (case_id) 
keep case_id weeks_fish_trading
lab var weeks_fish_trading "Weeks spent working as a fish trader (maximum observed across individuals in household)"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_weeks_fish_trading.dta", replace

use "${Malawi_IHS_W1_raw_data}\Fisheries\fs_mod_f1.dta", clear
append using "${Malawi_IHS_W1_raw_data}\Fisheries\fs_mod_f2.dta"
append using "${Malawi_IHS_W1_raw_data}\Fisheries\fs_mod_j1.dta"
append using "${Malawi_IHS_W1_raw_data}\Fisheries\fs_mod_j2.dta"
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
collapse (sum) weekly_fishtrade_profit, by (case_id)
lab var weekly_fishtrade_profit "Average weekly profits from fish trading (sales minus purchases), summed across individuals"
keep case_id weekly_fishtrade_profit
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_fish_trading_revenues.dta", replace   

use "${Malawi_IHS_W1_raw_data}\Fisheries\fs_mod_f2.dta", clear
append using "${Malawi_IHS_W1_raw_data}\Fisheries\fs_mod_j2.dta"
rename fs_f05 weekly_costs_for_fish_trading //  Other costs: Hired labor, transport, packaging, ice, tax.
replace weekly_costs_for_fish_trading=fs_j05 if weekly_costs_for_fish_trading==.
recode weekly_costs_for_fish_trading (.=0)
collapse (sum) weekly_costs_for_fish_trading, by (case_id)
lab var weekly_costs_for_fish_trading "Weekly costs associated with fish trading, in addition to purchase of fish"
keep case_id weekly_costs_for_fish_trading
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_fish_trading_other_costs.dta", replace

use "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_weeks_fish_trading.dta", clear
merge 1:1 case_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_fish_trading_revenues.dta" 
drop _merge
merge 1:1 case_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_fish_trading_other_costs.dta"
drop _merge
replace weekly_fishtrade_profit = weekly_fishtrade_profit - weekly_costs_for_fish_trading
gen fish_trading_income = (weeks_fish_trading * weekly_fishtrade_profit)
lab var fish_trading_income "Estimated net household earnings from fish trading over previous 12 months"
keep case_id fish_trading_income
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_fish_trading_income.dta", replace

//The results are messy due to the underlying data rather than coding errors. I think the sample
//size is a little to small to effectively deal with outliers.

********************************************************************************
* NON-AG WAGE INCOME *
********************************************************************************
use "${Malawi_IHS_W1_raw_data}\Household\hh_mod_e.dta", clear
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
collapse (sum) annual_salary, by (case_id)
lab var annual_salary "Annual earnings from non-agricultural wage"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_wage_income.dta", replace

********************************************************************************
* AG WAGE INCOME *
********************************************************************************
use "${Malawi_IHS_W1_raw_data}\Household\hh_mod_e.dta", clear
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
collapse (sum) annual_salary, by (case_id)
rename annual_salary annual_salary_agwage
lab var annual_salary_agwage "Annual earnings from agricultural wage"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_agwage_income.dta", replace 


********************************************************************************
* OTHER INCOME *
********************************************************************************
use "${Malawi_IHS_W1_created_data}/Malawi_IHS_W1_hh_crop_prices_for_wages.dta", clear
keep if crop_code==1 //instrument measures food assistance in maize
ren hh_price_mean price_kg
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hh_maize_prices.dta", replace

use "${Malawi_IHS_W1_raw_data}\Household\hh_mod_p.dta", clear
append using "${Malawi_IHS_W1_raw_data}\Household\hh_mod_r.dta"
append using "${Malawi_IHS_W1_raw_data}\Household\hh_mod_o.dta"
merge m:1 case_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hh_maize_prices.dta"
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
collapse (sum) rental_income pension_investment_income asset_sale_income other_income remittance_income assistance_income, by (case_id)
lab var rental_income "Estimated income from rentals of buildings, land, vehicles over previous 12 months"
lab var pension_investment_income "Estimated income from a pension AND INTEREST/INVESTMENT/INTEREST over previous 12 months"
lab var other_income "Estimated income from inheritance, lottery/gambling and ANY OTHER source over previous 12 months"
lab var asset_sale_income "Estimated income from household asset and real estate sales over previous 12 months"
lab var remittance_income "Estimated income from remittances over previous 12 months"
lab var assistance_income "Estimated income from food aid, food-for-work, cash transfers etc. over previous 12 months"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_other_income.dta", replace


********************************************************************************
* FARM SIZE / LAND SIZE *
********************************************************************************
use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_d.dta", clear // * The below code calculates only agricultural land rental income
append using "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_k.dta"
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
collapse (sum) land_rental_income, by (case_id)
lab var land_rental_income "Estimated income from renting out land over previous 12 months"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_land_rental_income.dta", replace


********************************************************************************
* FARM SIZE / LAND SIZE *
********************************************************************************

*Determining whether crops were grown on a plot
use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_g.dta", clear
append using "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_m.dta"
ren ag_g0b plot_id
drop if plot_id==""
drop if ag_g0d==. // crop code
gen crop_grown = 1 
collapse (max) crop_grown, by(case_id plot_id)
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_crops_grown.dta", replace


use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_k.dta", clear
rename ag_k0a plot_id
ren ea_id ea
tempfile ag_mod_k_numeric
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_ag_mod_k_temp.dta", replace  // Renaming plot ids, to work with Module D and K together.
use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_d.dta", clear
rename ag_d00 plot_id
append using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_ag_mod_k_temp.dta"
gen cultivated = (ag_d14==1 | ag_k15==1) //  cultivated plots in rainy or dry seasons
collapse (max) cultivated, by (case_id plot_id)
lab var cultivated "1= Parcel was cultivated in this data set"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_parcels_cultivated.dta", replace

use "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_parcels_cultivated.dta", clear
merge 1:1 case_id plot_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_plot_areas.dta",
drop if _merge==2
keep if cultivated==1
replace area_acres_meas=. if area_acres_meas<0 
replace area_acres_meas = area_acres_est if area_acres_meas==. 
collapse (sum) area_acres_meas, by (case_id)
rename area_acres_meas farm_area
replace farm_area = farm_area * (1/2.47105) /* Convert to hectares */ 
lab var farm_area "Land size (denominator for land productivitiy), in hectares" 
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_land_size.dta", replace

* All agricultural land
use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_d.dta", clear
rename ag_d00 plot_id
append using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_ag_mod_k_temp.dta"
drop if plot_id==""
merge m:1 case_id plot_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_crops_grown.dta", nogen

gen rented_out = (ag_d14==2 |ag_k15==2)
gen cultivated_dry = (ag_k15==1)
bys case_id plot_id: egen plot_cult_dry = max(cultivated_dry)
replace rented_out = 0 if plot_cult_dry==1 //  If cultivated in short season, not considered rented out in long season.

drop if rented_out==1 & crop_grown!=1
gen agland = (ag_d14==1 | ag_d14==4 |ag_k15==1 | ag_k15==4) // All cultivated AND fallow plots, forests/woodlot & pasture is captured within "other" (can't be separated out)

drop if agland!=1 & crop_grown==.
collapse (max) agland, by (case_id plot_id)
lab var agland "1= Parcel was used for crop cultivation or left fallow in this past year (forestland and other uses excluded)" //This label is too long and gets truncated
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_parcels_agland.dta", replace

use "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_parcels_agland.dta", clear
merge 1:1 case_id plot_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_plot_areas.dta"
drop if _merge==2
replace area_acres_meas=. if area_acres_meas<0
replace area_acres_meas = area_acres_est if area_acres_meas==. 
replace area_acres_meas = area_acres_est if area_acres_meas==0 & (area_acres_est>0 & area_acres_est!=.)		
collapse (sum) area_acres_meas, by (case_id)
rename area_acres_meas farm_size_agland
replace farm_size_agland = farm_size_agland * (1/2.47105)
lab var farm_size_agland "Land size in hectares, including all plots cultivated or left fallow" 
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_farmsize_all_agland.dta", replace


use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_d.dta", clear
append using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_ag_mod_k_temp.dta"
drop if plot_id=="" //Drops a lot of obs
gen rented_out = (ag_d14==2 | ag_d14==3 | ag_k15==2 | ag_k15==3) // rented out (2) & gave out for free (3)
gen cultivated_dry = (ag_k15==1)
bys case_id plot_id: egen plot_cult_dry = max(cultivated_dry)
replace rented_out = 0 if plot_cult_dry==1 // If cultivated in dry season, not considered rented out in rainy season.
drop if rented_out==1
gen plot_held = 1
collapse (max) plot_held, by (case_id plot_id)
lab var plot_held "1= Parcel was NOT rented out in the main season"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_parcels_held.dta", replace

use "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_parcels_held.dta", clear
merge 1:1 case_id plot_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_plot_areas.dta"
drop if _merge==2
replace area_acres_meas=. if area_acres_meas<0
replace area_acres_meas = area_acres_est if area_acres_meas==. 
collapse (sum) area_acres_meas, by (case_id)
rename area_acres_meas land_size
lab var land_size "Land size in hectares, including all plots listed by the household except those rented out" 
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_land_size_all.dta", replace

*Total land holding including cultivated and rented out
use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_d.dta", clear
rename ag_d00 plot_id
append using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_ag_mod_k_temp.dta"
drop if plot_id==""
merge m:1 case_id plot_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_plot_areas.dta", nogen keep(1 3)
replace area_acres_meas=. if area_acres_meas<0
replace area_acres_meas = area_acres_est if area_acres_meas==. 
replace area_acres_meas = area_acres_est if area_acres_meas==0 & (area_acres_est>0 & area_acres_est!=.)	
collapse (max) area_acres_meas, by(case_id plot_id)
rename area_acres_meas land_size_total
collapse (sum) land_size_total, by(case_id)
replace land_size_total = land_size_total * (1/2.47105) /* Convert to hectares */
lab var land_size_total "Total land size in hectares, including rented in and rented out plots"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_land_size_total.dta", replace


********************************************************************************
* OFF-FARM HOURS *
********************************************************************************
use "${Malawi_IHS_W1_raw_data}\Household\hh_mod_e.dta", clear
gen primary_hours = hh_e22 * hh_e23 * hh_e24 if !inlist(hh_e19b, 62, 63, 64, 71) & hh_e19b!=. 
* Excluding agr. & animal husbandry workers, forestry workers, fishermen & hunters, miners & quarrymen per TZ. 
gen secondary_hours = hh_e36 * hh_e37 * hh_e38 if hh_e33b!=21 & hh_e33b!=.  
* Excluding ag & animal husbandry. Confirm use of occup. code variabe hh_e33b
gen ownbiz_hours =  (hh_e08 + hh_e09) * 52 //  TZ used # of hrs as unpaid family worker on non-farm hh. biz. // *52 = annualize
* "How many hours in the last seven days did you run or do any kind of non-agricultural or non-fishing 
* household business, big or small, for yourself?" &
* "How many hours in the last seven days did you help in any of the household's non-agricultural or non-fishing household businesses, if any"?
egen off_farm_hours = rowtotal(primary_hours secondary_hours ownbiz_hours)
gen off_farm_any_count = off_farm_hours!=0
gen member_count = 1
collapse (sum) off_farm_hours off_farm_any_count member_count, by(case_id)
la var member_count "Number of HH members age 5 or above"
la var off_farm_any_count "Number of HH members with positive off-farm hours"
la var off_farm_hours "Total household off-farm hours (annualized)"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_off_farm_hours.dta", replace

// off-farm hours annualized - "past 7 days" assumed to carry forward all year, etc.


********************************************************************************
* FARM LABOR *
********************************************************************************
** Family labor
* Rainy Season
use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_d.dta", clear
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
collapse (sum) days_hired_rainyseason days_famlabor_rainyseason, by (case_id plot_id)
lab var days_hired_rainyseason  "Workdays for hired labor (crops) in rainy season"
lab var days_famlabor_rainyseason  "Workdays for family labor (crops) in rainy season"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_plot_farmlabor_rainyseason.dta", replace

* Dry Season
use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_k.dta", clear
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
ren ag_k0a plot_id
collapse (sum) days_hired_dryseason days_famlabor_dryseason, by (case_id plot_id)
lab var days_hired_dryseason  "Workdays for hired labor (crops) in dry season"
lab var days_famlabor_dryseason  "Workdays for family labor (crops) in dry season"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_plot_farmlabor_dryseason.dta", replace


*Hired Labor
use "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_plot_farmlabor_rainyseason.dta", clear
merge 1:1 case_id plot_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_plot_farmlabor_dryseason.dta"
drop _merge
recode days*  (.=0)
collapse (sum) days*, by(case_id plot_id)
egen labor_hired =rowtotal(days_hired_rainyseason days_hired_dryseason)
egen labor_family=rowtotal(days_famlabor_rainyseason  days_famlabor_dryseason)
egen labor_total = rowtotal(days_hired_rainyseason days_famlabor_rainyseason days_hired_dryseason days_famlabor_dryseason)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm"
lab var labor_hired "Total labor days (hired) allocated to the farm"
lab var labor_family "Total labor days (family) allocated to the farm"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_plot_family_hired_labor.dta", replace
collapse (sum) labor_*, by(case_id)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm"
lab var labor_hired "Total labor days (hired) allocated to the farm"
lab var labor_family "Total labor days (family) allocated to the farm"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_family_hired_labor.dta", replace


********************************************************************************
* VACCINE USAGE *
********************************************************************************
use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_r1.dta", clear
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

collapse (max) vac_animal*, by (case_id)
lab var vac_animal "1=Household has an animal vaccinated"
	foreach i in vac_animal {
		local l`i' : var lab `i'
		lab var `i'_lrum "`l`i'' - large ruminants"
		lab var `i'_srum "`l`i'' - small ruminants"
		lab var `i'_pigs "`l`i'' - pigs"
		lab var `i'_equine "`l`i'' - equine"
		lab var `i'_poultry "`l`i'' - poultry"
	}
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_vaccine.dta", replace

use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_r1.dta", clear
gen all_vac_animal=ag_r24>0
replace all_vac_animal = 0 if ag_r24==0  
replace all_vac_animal = . if ag_r24==.
keep case_id ag_r06a ag_r06b all_vac_animal
ren ag_r06a farmerid1
ren ag_r06b farmerid2
gen t=1
gen patid=sum(t)
reshape long farmerid, i(patid) j(idnum)
drop t patid

collapse (max) all_vac_animal , by(case_id farmerid)
gen indiv=farmerid
drop if indiv==.
merge 1:1 case_id indiv using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_gender_merge.dta", nogen
lab var all_vac_animal "1 = Individual farmer (livestock keeper) uses vaccines"
gen livestock_keeper=1 if farmerid!=.
recode livestock_keeper (.=0)
lab var livestock_keeper "1=Indvidual is listed as a livestock keeper (at least one type of livestock)" 
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_farmer_vaccine.dta", replace


********************************************************************************
* ANIMAL HEALTH - DISEASES *
********************************************************************************
use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_r1.dta", clear
gen disease_animal = 1 if ag_r22==1 // Answered "yes" for "Did livestock suffer from any disease in last 12m?"
replace disease_animal = . if (ag_r22==.) 
gen disease_ASF = ag_r23a==14  //  African swine fever
gen disease_amapl = ag_r23a==22 // Amaplasmosis
gen disease_bruc = ag_r23a== 1 // Brucelosis
gen disease_mange = ag_r23a==20 // Mange
gen disease_NC= ag_r23a==10 // New Castle disease
gen disease_spox= ag_r23a==11 // Small pox
gen disease_other = inrange(ag_r23a, 2, 9) | inrange(ag_r23a, 12, 13) | inrange(ag_r23a,15,19) | ag_r23a==21 | ag_r23a > 22 //adding "other" category to capture rarer diseases. Either useful or useless b/c every household had something in that category

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

collapse (max) disease_*, by (case_id)
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

save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_livestock_diseases.dta", replace

********************************************************************************
* LIVESTOCK WATER, FEEDING, AND HOUSING *
********************************************************************************
*Omitting this section. MWI W1 has questions about feed and other inputs,
*but nothing about water/housing.


********************************************************************************
* USE OF INORGANIC FERTILIZER *
********************************************************************************
use "${Malawi_IHS_W1_raw_data}/Agriculture/ag_mod_d.dta", clear
append using "${Malawi_IHS_W1_raw_data}/Agriculture/ag_mod_k.dta" 
gen use_inorg_fert=.
replace use_inorg_fert=0 if ag_d38==2| ag_k39==2
replace use_inorg_fert=1 if ag_d38==1| ag_k39==1
recode use_inorg_fert (.=0)
collapse (max) use_inorg_fert, by (case_id)
lab var use_inorg_fert "1 = Household uses inorganic fertilizer"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_fert_use.dta", replace

*Fertilizer use by farmers (a farmer is an individual listed as plot manager)
use "${Malawi_IHS_W1_raw_data}/Agriculture/ag_mod_d.dta", clear
append using "${Malawi_IHS_W1_raw_data}/Agriculture/ag_mod_k.dta" 
gen all_use_inorg_fert=(ag_d38==1 | ag_k39==1)

ren ag_d01 farmerid
replace farmerid= ag_k02 if farmerid==.

collapse (max) all_use_inorg_fert , by(case_id farmerid)
gen indiv=farmerid
drop if indiv==.
merge 1:1 case_id indiv using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_gender_merge.dta", nogen

lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
gen farm_manager=1 if farmerid!=.
recode farm_manager (.=0)
lab var farm_manager "1=Individual is listed as a manager for at least one plot" 
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_farmer_fert_use.dta", replace

********************************************************************************
* FERTILIZER APPLICATION RATE *
********************************************************************************
/*Shelved pending agreement on conversion
use "${Malawi_IHS_W1_raw_data}/Agriculture/ag_mod_d.dta", clear
append using "${Malawi_IHS_W1_raw_data}/Agriculture/ag_mod_k.dta" */

//Skeleton section for now, build out with rest of model code. Note for waves 2, 3, and 4, input quantities should be switched to plot level.
//Shift section closer to "Rate of Fertilizer Application"
use "${Malawi_IHS_W1_created_data}/Malawi_IHS_W1_all_plots.dta", clear
collapse (sum) ha_planted, by(case_id plot_id)
merge 1:1 case_id plot_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_fertilizer_kg_application.dta", nogen
gen n_rate = n_units / ha_planted 
gen p_rate = p_units / ha_planted
gen k_rate = k_units / ha_planted 
gen n_rate_org = n_units_org / ha_planted 
la var n_rate "Inorganic N application (kg/ha)"
la var p_rate "Phosphate application (kg/ha)"
la var k_rate "Potash application (kg/ha)"
la var n_rate_org "Organic N application from manure (kg/ha)"

save  "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_fertilizer_application_plot.dta", replace

collapse (sum) ha_planted *units*, by(case_id)
gen n_rate_hh = n_units / ha_planted 
gen p_rate_hh = p_units / ha_planted
gen k_rate_hh = k_units / ha_planted 
gen n_rate_org_hh = n_units_org / ha_planted 
la var n_rate_hh "Inorganic N application (kg/ha), hh avg"
la var p_rate_hh "Phosphate application (kg/ha), hh avg"
la var k_rate_hh "Potash application (kg/ha), hh avg"
la var n_rate_org_hh "Organic N application from manure (kg/ha), hh avg"

save  "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_fertilizer_application.dta", replace

********************************************************************************
* USE OF IMPROVED SEED *
********************************************************************************
/* MWI W2 does not distinguish between traditional/improved
In MWI W1, the enumerator lists the variety, so it might be possible to do this
section for some crops. */


********************************************************************************
* PLOT MANAGERS *
********************************************************************************
//This section combines all the variables that we're interested in at manager level
//(inorganic fertilizer, improved seed) into a single operation.
//Doing improved seed and agrochemicals at the same time.

use "${Malawi_IHS_W1_raw_data}/Agriculture/ag_mod_d.dta", clear	
append using "${Malawi_IHS_W1_raw_data}/Agriculture/ag_mod_k.dta"	
ren ag_d20a crop_code
replace crop_code = ag_d20b if crop_code == . & ag_d20b != .	
replace crop_code = ag_k21a if crop_code == . & ag_k21a != .	
replace crop_code = ag_k21b if crop_code == . & ag_k21b != .	
drop if crop_code == .	
gen use_imprv_seed = 1 if crop_code == 2 | crop_code == 12 | crop_code == 18 | crop_code == 21 | crop_code == 23 | crop_code == 25 // MAIZE COMPOSITE/OPV | GROUNDNUT CG7 | RISE FAYA | RISE IET4094 (SENGA) | RISE KILOMBERO | RISE MTUPATUPA	
recode use_imprv_seed .=0	
gen use_hybrid_seed = 1 if crop_code == 3 | crop_code == 4 | crop_code == 15 | crop_code == 19 | crop_code == 20 // MAIZE HYBRID | MAIZE HYBRID RECYCLED | GROUNDNUT JL24 | RISE PUSSA | RISE TCG10 	
recode use_hybrid_seed .=0	
ren ag_d00 plot_id	
collapse (max) use_imprv_seed use_hybrid_seed, by(case_id plot_id crop_code)	
tempfile imprv_hybr_seed	
save `imprv_hybr_seed'	

use "${Malawi_IHS_W1_raw_data}/Agriculture/ag_mod_d.dta", clear	
ren ag_d00 plot_id	
append using "${Malawi_IHS_W1_raw_data}/Agriculture/ag_mod_k.dta"	
replace plot_id = ag_k0a if plot_id == "" & ag_k0a != ""	
ren ag_d01 pid	
replace pid = ag_k02 if pid == . & ag_k02 != .	
keep case_id plot_id pid	
ren pid indiv	
drop if plot_id == ""	
merge m:1 case_id indiv using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_gender_merge.dta", nogen keep(1 3) // 20,321 matched / 3442 not matched	
tempfile personids	
save `personids'	

use "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_plot_cost_inputs_long.dta", clear
keep if inlist(input, "inorg", "orgfert")
gen use_org_fert = 1 if input == "orgfert"
recode use_org_fert (.=0)
gen use_inorg_fert = 1 if input == "inorg"
recode use_inorg_fert (.=0)
keep case_id plot_id use_*
duplicates drop case_id plot_id, force
tempfile plotfertilizer
save `plotfertilizer'

use `imprv_hybr_seed', clear	
merge m:1 case_id plot_id using `plotfertilizer', nogen keep(1 3)
merge m:m case_id plot_id using `personids', nogen keep(1 3)

preserve
ren use_imprv_seed all_imprv_seed_
ren use_hybrid_seed all_hybrid_seed_	
collapse (max) all*, by(case_id indiv female crop_code)	
merge m:1 crop_code using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_cropname_table.dta", nogen keep(3)
drop crop_code
gen farmer_ = 1
reshape wide all_imprv_seed_ all_hybrid_seed_ farmer_, i(case_id indiv female) j(crop_name) string
recode farmer_* (.=0)
ren farmer_* *_farmer
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_farmer_improved_hybrid_seed_use.dta", replace
restore	

collapse (max) use_*, by(case_id indiv female)	
gen all_imprv_seed_use = use_imprv_seed	
gen all_hybrid_seed_Use = use_hybrid_seed
gen all_org_fert_use = use_org_fert
gen all_inorg_fert_use = use_inorg_fert

preserve	
collapse (max) use_*, by(case_id)	
la var use_imprv_seed "1 = household uses improved seed for at least one crop"	
la var use_hybrid_seed "1 = household uses hybrid seed for at least one crop"
la var use_inorg_fert "1=household uses inorganic fertilizer on at least one plot"
la var use_org_fert "1=household uses organic fertilizer on at least one plot"	
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_input_use.dta", replace	
restore	


********************************************************************************
* REACHED BY AG EXTENSION *
********************************************************************************
use "${Malawi_IHS_W1_raw_data}/Agriculture/ag_mod_t1.dta", clear
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

collapse (max) ext_reach_* , by (case_id)
lab var ext_reach_all "1 = Household reached by extension services - all sources"
lab var ext_reach_public "1 = Household reached by extension services - public sources"
lab var ext_reach_private "1 = Household reached by extension services - private sources"
lab var ext_reach_unspecified "1 = Household reached by extension services - unspecified sources"
lab var ext_reach_ict "1 = Household reached by extension services through ICT"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_any_ext.dta", replace


********************************************************************************
* MOBILE PHONE OWNERSHIP *
********************************************************************************
use "${Malawi_IHS_W1_raw_data}\Household\hh_mod_f.dta", clear
ren hh_f34 mobile_owned
recode mobile_owned (.=0)
drop if mobile_owned == 0
keep case_id mobile_owned
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_mobile_own.dta", replace


********************************************************************************
* USE OF FORMAL FINANCIAL SERVICES *
********************************************************************************
use "${Malawi_IHS_W1_raw_data}\Household\hh_mod_f.dta", clear
append using "${Malawi_IHS_W1_raw_data}\Household\hh_mod_s1.dta"
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

collapse (max) use_fin_serv_*, by (case_id)
lab var use_fin_serv_all "1= Household uses formal financial services - all types"
lab var use_fin_serv_credit "1= Household uses formal financial services - credit"
lab var use_fin_serv_others "1= Household uses formal financial services - others"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_fin_serv.dta", replace


********************************************************************************
* MILK PRODUCTIVITY *
********************************************************************************
*Total production
use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_s.dta", clear
rename ag_s0a product_code
keep if product_code==401
rename ag_s02 months_milked
rename ag_s03a qty_milk_per_month
gen milk_liters_produced = months_milked * qty_milk_per_month if ag_s03b==1 | ag_s03b == 7 // Liters only, omits kg (1), piece (3), bucket (2)
replace milk_liters_produced = milk_liters_produced * 1.5 if ag_s03b == 7 // Units [Other (specify)] == "1500ML"
lab var milk_liters_produced "Liters of milk produced in past 12 months"
lab var months_milked "Average months milked in last year (household)"
drop if milk_liters_produced == .
keep case_id months_milked milk_liters_produced
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_milk_animals.dta", replace


********************************************************************************
* EGG PRODUCTIVITY *
********************************************************************************
use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_r1.dta", clear
rename ag_r0a livestock_code
gen poultry_owned = ag_r02 if inlist(livestock_code, 310,311,312,313,314,315,316) // local hen, local cock, duck, other, dove/pigeon, chicken layer/chicken-broiler and turkey/guinea fowl
collapse (sum) poultry_owned, by(case_id)
tempfile eggs_animals_hh 
save `eggs_animals_hh'

use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_s.dta", clear
rename ag_s0a product_code
keep if product_code==402 | product_code==403
rename ag_s02 eggs_months // # of months in past year that hh. produced eggs
rename ag_s03a eggs_per_month  // avg. qty of eggs per month in past year
rename ag_s03b quantity_month_unit
replace quantity_month = round(quantity_month/0.06) if product_code==402 & quantity_month_unit==2
// using MW IHS Food Conversion factors.pdf. Cannot convert ox-cart & ltrs for eggs 
replace quantity_month_unit = 3 if product_code== 402 & quantity_month_unit==2    
replace quantity_month_unit =. if product_code==402 & quantity_month_unit!=3  // chicken eggs, pieces
replace quantity_month_unit =. if product_code== 403 & quantity_month_unit!=3 // guinea fowl eggs, pieces
recode eggs_months eggs_per_month (.=0)
collapse (sum) eggs_per_month (max) eggs_months, by (case_id) // Collapsing chicken & guinea fowl eggs
gen eggs_total_year = eggs_months* eggs_per_month // Units are pieces for eggs 
merge 1:1 case_id using  `eggs_animals_hh', nogen keep(1 3)			
keep case_id eggs_months eggs_per_month eggs_total_year poultry_owned 

lab var eggs_months "Number of months eggs were produced (household)"
lab var eggs_per_month "Number of eggs that were produced per month (household)"
lab var eggs_total_year "Total number of eggs that was produced in a year (household)"
lab var poultry_owned "Total number of poultry owned (household)"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_eggs_animals.dta", replace


********************************************************************************
* CROP PRODUCTION COSTS PER HECTARE *
********************************************************************************
use "${Malawi_IHS_W1_created_data}/Malawi_IHS_W1_all_plots.dta", clear
collapse (sum) ha_planted, by(case_id plot_id purestand area_meas_hectares) // using area_meas_hectares instead of field_size
reshape long ha_, i(case_id plot_id purestand area_meas_hectares) j(area_type) string
tempfile plot_areas
save `plot_areas'

use "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_plot_cost_inputs_long.dta", clear
collapse (sum) cost_=val, by(case_id plot_id dm_gender exp)
reshape wide cost_, i(case_id plot_id dm_gender) j(exp) string
recode cost_exp cost_imp (.=0) // note: no obs where cost_imp > 0
gen cost_total=cost_imp+cost_exp
drop cost_imp
collapse (sum) cost_* (max) dm_gender, by(case_id plot_id)
merge 1:m case_id plot_id using `plot_areas', nogen keep(3)
gen cost_exp_ha_ = cost_exp/ha_ 
gen cost_total_ha_ = cost_total/ha_
recode cost_exp_ha_ cost_total_ha_ (.=0)
collapse (mean) cost*ha_ [aw=area_meas_hectares], by(case_id dm_gender area_type)
gen dm_gender2 = "male"
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
replace dm_gender2 = "unknown" if dm_gender==.
drop dm_gender
replace area_type = "harvested" if strmatch(area_type,"harvest")
reshape wide cost*_, i(case_id dm_gender2) j(area_type) string
ren cost* cost*_
reshape wide cost*, i(case_id) j(dm_gender2) string
ren *_planted_* *_*

foreach i in male female mixed unknown {
	la var cost_exp_ha_`i' "Explicit cost per hectare by `i'-managed plots"
	la var cost_total_ha_`i' "Total cost per hectare by `i'-managed plots"
	}
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_cropcosts.dta", replace


********************************************************************************
* RATE OF FERTILIZER APPLICATION *
********************************************************************************
use "${Malawi_IHS_W1_created_data}/Malawi_IHS_W1_all_plots.dta", clear
collapse (sum) ha_planted, by(case_id season dm_gender)
merge m:1 case_id season using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_input_quantities.dta", nogen keep(1 3)
gen dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
replace dm_gender2 = "unknown" if dm_gender==.
drop dm_gender
ren ha_planted ha_planted_
ren inorg_fert_rate fert_inorg_kg_ 
ren org_fert_rate fert_org_kg_ 
ren pest_rate pest_kg_
ren herb_rate herb_kg_
reshape wide ha_planted_ fert_inorg_kg_ fert_org_kg_ pest_kg_ herb_kg_, i(case_id season) j(dm_gender2) string
collapse (sum) *male *mixed *unknown, by(case_id)
recode ha_planted* (0=.)
foreach i in ha_planted fert_inorg_kg fert_org_kg pest_kg herb_kg {
	egen `i' = rowtotal(`i'_*)
}

merge m:1 case_id using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_weights.dta", keep (1 3) nogen
_pctile ha_planted [aw=weight]  if ha_planted!=0 , p($wins_lower_thres $wins_upper_thres)
foreach x of varlist ha_planted ha_planted_male ha_planted_female ha_planted_mixed ha_planted_unknown{	
		replace `x' =r(r1) if `x' < r(r1)   & `x' !=. &  `x' !=0 
		replace `x' = r(r2) if  `x' > r(r2) & `x' !=.    
}
lab var fert_inorg_kg "Inorganic fertilizer (kgs) for household"
lab var fert_org_kg "Organic fertilizer (kgs) for household" 
lab var pest_kg "Pesticide (kgs) for household"
lab var herb_kg "Herbicide (kgs) for household"
lab var ha_planted "Area planted (ha), all crops, for household"

foreach i in male female mixed unknown {
lab var fert_inorg_kg_`i' "Inorganic fertilizer (kgs) for `i'-managed plots"
lab var fert_org_kg_`i' "Organic fertilizer (kgs) for `i'-managed plots" 
lab var pest_kg_`i' "Pesticide (kgs) for `i'-managed plots"
lab var herb_kg_`i' "Herbicide (kgs) for `i'-managed plots"
lab var ha_planted_`i' "Area planted (ha), all crops, `i'-managed plots"
}
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_fertilizer_application.dta", replace


********************************************************************************
* WOMEN'S DIET QUALITY *
********************************************************************************
*Women's diet quality: proportion of women consuming nutrient-rich foods (%)
*Information not available


********************************************************************************
* HOUSEHOLDS DIET DIVERSITY SCORE *
********************************************************************************
* Malawi LSMS 1 does not report individual consumption but instead household level consumption of various food items.
* Thus, only the proportion of households eating nutritious food can be estimated
use "${Malawi_IHS_W1_raw_data}\Household\hh_mod_g1.dta" , clear
ren hh_g02 itemcode
* recode food items to map HDDS food categories //Including prepared foods in their respective categories
recode itemcode 	(101/117 820 					=1	"CEREALS" )  ////  Also includes biscuits, buns, scones // Added cooked maize from vendor
					(201/209 821 828				=2	"WHITE ROOTS,TUBERS AND OTHER STARCHES"	)  ////Including chips and samosas
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
collapse (max) adiet_yes, by(case_id Diet_ID) 
label define YesNo 1 "Yes" 0 "No"
label val adiet_yes YesNo
* Now, estimate the number of food groups eaten by each individual
collapse (sum) adiet_yes, by(case_id )
ren adiet_yes number_foodgroup 
sum number_foodgroup 
local cut_off1=6
local cut_off2=round(r(mean))
gen household_diet_cut_off1=(number_foodgroup>=`cut_off1')
gen household_diet_cut_off2=(number_foodgroup>=`cut_off2')
lab var household_diet_cut_off1 "1= household consumed at least `cut_off1' of the 12 food groups last week" 
lab var household_diet_cut_off2 "1= household consumed at least `cut_off2' of the 12 food groups last week" 
label var number_foodgroup "Number of food groups individual consumed last week HDDS"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_household_diet.dta", replace
 

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
use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_i.dta", clear  // control over crop sale earnings rainy season
append using "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_o.dta" // control over crop sale earnings dry season
append using "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_q.dta" // control over permanent crop sale earnings
* Control over Livestock production income
append using "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_s.dta" // control over livestock product sale earnings
append using "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_r1.dta" // control over livestock sale earnings
* Control over wage income
append using "${Malawi_IHS_W1_raw_data}\Household\hh_mod_e.dta" // control over salary payment, allowances/gratuities, ganyu labor earnings 
* Control over business income
append using "${Malawi_IHS_W1_raw_data}\Household\hh_mod_n2.dta" // household enterprise ownership
* Control over program assistance 
append using "${Malawi_IHS_W1_raw_data}\Household\hh_mod_r.dta"
* Control over other income 
append using "${Malawi_IHS_W1_raw_data}\Household\hh_mod_p.dta"
* Control over remittances
append using "${Malawi_IHS_W1_raw_data}\Household\hh_mod_o.dta"


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
keep case_id type_decision controller_income1 controller_income2
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
keep case_id type_decision controller_income1 controller_income2
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
keep case_id type_decision controller_income1 controller_income2
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
keep case_id type_decision controller_income1 controller_income2
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
use "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_person_ids.dta", clear
keep if hh_head == 1
gen fhh = hh_head if female == 1
recode fhh .=0
collapse (max) hh_head indiv fhh, by(case_id) // removes single duplicate value
tempfile hh_head_roster
save `hh_head_roster'
restore

preserve
recode hh_o11 (2=0)
recode hh_o11 (.=0)
collapse (sum) hh_o11, by(case_id)
gen type_decision=""
gen controller_income1=. 
replace type_decision="control_remittance" if hh_o11 > 0  
merge m:1 case_id using `hh_head_roster', nogen keep(3)
replace controller_income1=indiv if hh_o11 > 0
keep case_id type_decision controller_income1
tempfile remittance_cash
save `remittance_cash'
restore
append using `remittance_cash'

* append who controls in-kind remittances
preserve
recode hh_o15 (2=0)
recode hh_o15 (.=0)
collapse (sum) hh_o15, by(case_id)
gen type_decision=""
gen controller_income1=. 
replace type_decision="control_remittance" if hh_o15 > 0  
merge m:1 case_id using `hh_head_roster', nogen keep(3)
replace controller_income1=indiv if hh_o15 > 0
keep case_id type_decision controller_income1
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


keep case_id type_decision controller_income1 controller_income2

preserve
keep case_id type_decision controller_income2
drop if controller_income2==.
ren controller_income2 controller_income
tempfile controller_income2
save `controller_income2'
restore
keep case_id type_decision controller_income1
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
																		
collapse (max) control_* , by(case_id controller_income )  //any decision
gen control_all_income=1 if  control_farmincome== 1 | control_nonfarmincome==1
recode 	control_all_income (.=0)															
ren controller_income indiv
*	Now merge with member characteristics
merge 1:1 case_id indiv  using  "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_person_ids.dta", nogen keep (3) // 20433/20433  matched

recode control_* (.=0)
lab var control_cropincome "1=individual has control over crop income"
lab var control_livestockincome "1=individual has control over livestock income"
lab var control_farmincome "1=individual has control over farm (crop or livestock) income"
lab var control_businessincome "1=individual has control over business income"
lab var control_salaryincome "1= individual has control over salary income"
lab var control_nonfarmincome "1=individual has control over non-farm (business, salary, assistance, remittances or other income) income"
lab var control_all_income "1=individual has control over at least one type of income"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_control_income.dta", replace


********************************************************************************
*WOMEN'S PARTICIPATION IN AGRICULTURAL DECISION-MAKING*
********************************************************************************
*	Code as 1 if a woman is listed as one of the decision-makers for at least 2 plots, crops, or livestock activities; 
*	can report on % of women who make decisions, taking total number of women HH members as denominator
*	In most cases, MWI LSMS 4 lists the first TWO decision makers.
*	Indicator may be biased downward if some women would participate in decisions but are not listed among the first two
*	first append all files related to agricultural activities with income in who participate in the decision making

use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_d.dta", clear
append using "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_k.dta" 
append using "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_g.dta"
append using "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_m.dta"
append using "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_i.dta"
append using "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_o.dta"
append using "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_p.dta"
append using "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_q.dta"
append using "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_r1.dta"
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

keep case_id type_decision decision_maker*
tempfile planting_input1
save `planting_input1'
restore
append using `planting_input1' 

*Livestock owners
replace type_decision="livestockowners" if !inlist(ag_r05a, .,0,99) | !inlist(ag_r05b, .,0,99)
replace decision_maker1=ag_r05a if !inlist(ag_r05a, .,0,99) 
replace decision_maker2=ag_r05b if !inlist(ag_r05b, .,0,99) 

keep case_id type_decision decision_maker1 decision_maker2 decision_maker3

preserve
keep case_id type_decision decision_maker2
drop if decision_maker2==.
ren decision_maker2 decision_maker
tempfile decision_maker2
save `decision_maker2'
restore

keep case_id type_decision decision_maker1
drop if decision_maker1==.
ren decision_maker1 decision_maker
append using `decision_maker2'

* number of time appears as decision maker
bysort case_id decision_maker : egen nb_decision_participation=count(decision_maker)
drop if nb_decision_participation==1
gen make_decision_crop=1 if  type_decision=="planting_input" ///
							| type_decision=="harvest"
recode 	make_decision_crop (.=0)
gen make_decision_livestock=1 if  type_decision=="livestockowners"   
recode 	make_decision_livestock (.=0)
gen make_decision_ag=1 if make_decision_crop==1 | make_decision_livestock==1
recode 	make_decision_ag (.=0)
collapse (max) make_decision_* , by(case_id decision_maker )  //any decision
ren decision_maker indiv 
* Now merge with member characteristics
merge 1:1 case_id indiv  using  "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_person_ids.dta", nogen // 12,861 matched
recode make_decision_* (.=0)
lab var make_decision_crop "1=invidual makes decision about crop production activities"
lab var make_decision_livestock "1=invidual makes decision about livestock production activities"
lab var make_decision_ag "1=invidual makes decision about agricultural (crop or livestock) production activities"

save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_make_ag_decision.dta", replace


********************************************************************************
*WOMEN'S OWNERSHIP OF ASSETS*
********************************************************************************
* Code as 1 if a woman is sole or joint owner of any specified productive asset; 
* can report on % of women who own, taking total number of women HH members as denominator
* MWI W1 asked to list the first TWO owners.
* Indicator may be biased downward if some women would have been not listed among the two the first 2 asset-owners can also claim ownership of some assets

*First, append all files with information on asset ownership
use "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_d.dta", clear //rainy
append using "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_k.dta" //dry
append using "${Malawi_IHS_W1_raw_data}\Agriculture\ag_mod_r1.dta"
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

keep case_id type_asset asset_owner1 asset_owner2  

preserve
keep case_id type_asset asset_owner2
drop if asset_owner2==.
ren asset_owner2 asset_owner
tempfile asset_owner2
save `asset_owner2'
restore

keep case_id type_asset asset_owner1
drop if asset_owner1==.
ren asset_owner1 asset_owner
append using `asset_owner2'
gen own_asset=1 
collapse (max) own_asset, by(case_id asset_owner)
ren asset_owner indiv

* Now merge with member characteristics
merge 1:1 case_id indiv  using  "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_person_ids.dta", nogen 
recode own_asset (.=0)
lab var own_asset "1=invidual owns an assets (land or livestock)"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_ownasset.dta", replace


********************************************************************************
*CROP YIELDS* - DEV 
********************************************************************************
use "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_all_plots.dta", clear
gen number_trees_planted_banana = number_trees_planted if crop_code == 55
recode crop_code (52 53 54 56 57 58 59 60 61 62 63 64=100) // recode to "other fruit":  mango, orange, papaya, avocado, guava, lemon, tangerine, peach, poza, masuku, masau, pineapple
gen number_trees_planted_other_fruit = number_trees_planted if crop_code == 100
gen number_trees_planted_cassava = number_trees_planted if crop_code == 49
gen number_trees_planted_tea = number_trees_planted if crop_code == 50
gen number_trees_planted_coffee = number_trees_planted if crop_code == 51 
recode number_trees_planted_banana number_trees_planted_other_fruit number_trees_planted_cassava number_trees_planted_tea number_trees_planted_coffee (.=0)
collapse (sum) number_trees_planted*, by(case_id)
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_trees.dta", replace

use "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_all_plots2.dta", clear
collapse (sum) area_harv_=ha_harvest area_plan_=ha_planted harvest_=quant_harv_kg, by(case_id dm_gender purestand crop_code)
drop if purestand == .
gen mixed = "inter" if purestand==0
replace mixed="pure" if purestand==1
gen dm_gender2="male"
replace dm_gender2="female" if dm_gender==2
replace dm_gender2="mixed" if dm_gender==3
drop dm_gender purestand
duplicates tag case_id dm_gender2 crop_code mixed, gen(dups)
drop if dups > 0
drop dups
reshape wide harvest_ area_harv_ area_plan_, i(case_id dm_gender2 crop_code) j(mixed) string
ren area* area*_
ren harvest* harvest*_
reshape wide harvest* area*, i(case_id crop_code) j(dm_gender2) string
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

use "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hhids.dta", clear
merge 1:m case_id using `areas_sans_hh', keep(1 3) nogen
drop ea stratum weight district ta rural region

save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hh_crop_area_plan.dta", replace // temporary measure while we work on plot_decision_makers

// DEV SECTION BELOW - IN PROGRESS 4.4.2024
*Total planted and harvested area summed accross all plots, crops, and seasons.
preserve
	collapse (sum) all_area_harvested=area_harv all_area_planted=area_plan, by(case_id)
	replace all_area_harvested=all_area_planted if all_area_harvested>all_area_planted & all_area_harvested!=.
	save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hh_area_planted_harvested_allcrops.dta", replace
restore
keep if inlist(crop_code, $comma_topcrop_area)
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_crop_harvest_area_yield.dta", replace

**Yield at the household level

*Value of crop production
merge m:1 crop_code using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_cropname_table.dta", nogen keep(1 3) // 4,395 matched, 17,088 not matched (Master)
merge 1:1 case_id crop_code using "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hh_crop_production.dta", nogen keep(1 3)
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
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_trees.dta"
collapse (sum) harvest* area_harv*  area_plan* total_planted_area* total_harv_area* kgs_harvest*   value_harv* value_sold* number_trees_planted*  , by(hhid) 
recode harvest*   area_harv* area_plan* kgs_harvest* total_planted_area* total_harv_area*    value_harv* value_sold* (0=.)
egen kgs_harvest = rowtotal(kgs_harvest_*)
la var kgs_harvest "Quantity harvested of all crops (kgs) (household) (summed accross all seasons)" 

*ren variables
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

drop if hhid== 200156 | hhid==200190 | hhid==310091 // households that have an area planted or harvested but indicated that they rented out or did not cultivate 
foreach p of global topcropname_area {
	gen grew_`p'=(total_harv_area_`p'!=. & total_harv_area_`p'!=.0 ) | (total_planted_area_`p'!=. & total_planted_area_`p'!=.0)
	lab var grew_`p' "1=Household grew `p'" 
	gen harvested_`p'= (total_harv_area_`p'!=. & total_harv_area_`p'!=.0 )
	lab var harvested_`p' "1= Household harvested `p'"
}
replace grew_banana =1 if  number_trees_planted_banana!=0 & number_trees_planted_banana!=. 
replace grew_cassav =1 if number_trees_planted_cassava!=0 & number_trees_planted_cassava!=. 
replace grew_cocoa =1 if number_trees_planted_cocoa!=0 & number_trees_planted_cocoa!=. 
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_yield_hh_crop_level.dta", replace


********************************************************************************
*SHANNON DIVERSITY INDEX*
********************************************************************************
// need to finish crop yields, which requires gross crop revenue and all plots/plot decision-makers


********************************************************************************
*CONSUMPTION*
********************************************************************************

use "${Malawi_IHS_W1_raw_data}/Round 1 (2010) Consumption Aggregate.dta", clear
ren rexpagg total_cons
ren pcrexpagg percapita_cons
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
keep case_id total_cons percapita_cons peraeq_cons daily_cons daily_percap_cons daily_peraeq_cons adulteq hhsize
save "${Malawi_IHS_W1_created_data}/Malawi_IHS_W1_consumption.dta", replace


********************************************************************************
*HOUSEHOLD FOOD PROVISION*
********************************************************************************
use "${Malawi_IHS_W1_raw_data}/Household/hh_mod_a_filt.dta", clear
merge 1:1 case_id using "${Malawi_IHS_W1_raw_data}/Household/hh_mod_h.dta", nogen
gen int_month = hh_a23b_1
replace int_month = hh_a23b_2 if qx_type=="Panel B"
gen int_year = hh_a23c_1
replace int_year=hh_a23c_2 if qx_type=="Panel B"
gen food_insec_mar_2009 = hh_h05a_01 == "X" if int_month <  4 & int_year!=2011
gen food_insec_apr_2009 = hh_h05a_02 == "X" if int_month <  5 & int_year!=2011
gen food_insec_may_2009 = hh_h05a_03 == "X" if int_month <  6 & int_year!=2011
gen food_insec_jun_2009 = hh_h05a_04 == "X" if int_month <  7 & int_year!=2011 
gen food_insec_jul_2009 = hh_h05a_05 == "X" if int_month <  8 & int_year!=2011
gen food_insec_aug_2009 = hh_h05a_06 == "X" if int_month <  9 & int_year!=2011
gen food_insec_sep_2009 = hh_h05a_07 == "X" if int_month < 10 & int_year!=2011
gen food_insec_oct_2009 = hh_h05a_08 == "X" if int_month < 11 & int_year!=2011
gen food_insec_nov_2009 = hh_h05a_09 == "X" if int_year!=2011
gen food_insec_dec_2009 = hh_h05a_10 == "X" if int_year!=2011
gen food_insec_jan_2010 = hh_h05b_01 == "X" if int_year!=2011
gen food_insec_feb_2010 = hh_h05b_02 == "X" if int_year!=2011
gen food_insec_mar_2010 = hh_h05b_03 == "X" if int_month >  3 & int_year!=2011
gen food_insec_apr_2010 = hh_h05b_04 == "X" if int_month >  4 & int_year!=2011
gen food_insec_may_2010 = hh_h05b_05 == "X" if int_month >  5 | (int_year==2011 & int_month==5)
gen food_insec_jun_2010 = hh_h05b_06 == "X" if int_month >  6 | int_year==2011
gen food_insec_jul_2010 = hh_h05b_07 == "X" if int_month >  7 | int_year==2011
gen food_insec_aug_2010 = hh_h05b_08 == "X" if int_month >  8 | int_year==2011
gen food_insec_sep_2010 = hh_h05b_09 == "X" if int_month >  9 | int_year==2011
gen food_insec_oct_2010 = hh_h05b_10 == "X" if int_month > 10 | int_year==2011
gen food_insec_nov_2010 = hh_h05b_11 == "X" if int_year == 2011
gen food_insec_dec_2010 = hh_h05b_12 == "X" if int_year == 2011
gen food_insec_jan_2011 = hh_h05b_13 == "X" if int_year == 2011
gen food_insec_feb_2011 = hh_h05b_14 == "X" if int_year == 2011
gen food_insec_mar_2011 = hh_h05b_15 == "X" if int_year == 2011

egen months_food_insec = rowtotal (food_insec_*)
lab var months_food_insec "Number of months where the household experienced any food insecurity"
keep case_id months_food_insec
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_food_security.dta", replace


********************************************************************************
*FOOD SECURITY*
********************************************************************************
use "${Malawi_IHS_W1_raw_data}/Round 1 (2010) Consumption Aggregate.dta", clear
ren rexp_cat011 fdconstot
gen daily_per_aeq_fdcons = fdconstot / adulteq / 365
gen daily_percap_fdcons = fdconstot / hhsize / 365
keep case_id ea_id region urban district hhsize adulteq fdconstot daily_per_aeq_fdcons daily_percap_fdcons
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_food_cons.dta", replace


********************************************************************************
*HOUSEHOLD ASSETS*
********************************************************************************
use "${Malawi_IHS_W1_raw_data}\Household\hh_mod_l.dta", clear
ren hh_l05 value_today
ren hh_l04 age_item
ren hh_l03 num_items
/*
dropping items that don't report prices
drop if itemcode==413 | itemcode==414 | itemcode==416 | itemcode==424 | itemcode==436 | itemcode==440
*/
collapse (sum) value_assets=value_today, by(case_id)
la var value_assets "Value of household assets"
save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_hh_assets.dta", replace 


********************************************************************************
*HOUSEHOLD VARIABLES*
********************************************************************************



********************************************************************************
*INDIVIDUAL LEVEL VARIABLES*
********************************************************************************


********************************************************************************
*PLOT LEVEL VARIABLES*
********************************************************************************



********************************************************************************
*SUMMARY STATISTICS*
********************************************************************************