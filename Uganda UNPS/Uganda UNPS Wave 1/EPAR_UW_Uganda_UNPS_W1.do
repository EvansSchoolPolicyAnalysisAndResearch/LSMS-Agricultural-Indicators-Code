
/*
--------------------------------------------------------------------------------------
*Title/Purpose: Agricultural Development Indicators for the LSMS-ISA, Uganda National Panel Survey (UNPS) LSMS-ISA Wave 1 (2009-10)

*Author(s): Didier Alia & C. Leigh Anderson; uw.eparx@uw.edu
															  
*Date : March 31st, 2025

*Dataset Version: UGA_2005-2009_UNPS_v03_M
--------------------------------------------------------------------------------------*/


*Data source
*----------------------------------------------------------------------------
*The Uganda National Panel Survey was collected by the Uganda Bureau of Statistics (UBOS) 
*and the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture(LSMS - ISA)
*The data were collected over the period 2009 - 2010. 
*All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
*http://microdata.worldbank.org/index.php/catalog/1001

*Throughout the do-file, we sometimes use the shorthand LSMS to refer to the Tanzania National Panel Survey.


*Summary of Executing the Master do.file
*This Master do.file constructs selected indicators using the Uganda UNPS (UN LSMS) data set.
*Using data files from within the "Uganda UNPS - LSMS-ISA - Wave 1 (2009-10)" folder within the "Raw DTA files" folder, 
*the do.file first constructs common and intermediate variables, saving dta files when appropriate.
*The processed files include all households, individuals, and plots in the sample.
*Toward the end of the do.file, a block of code estimates summary statistics (mean, standard error of the mean, minimum, first quartile, median, third quartile, maximum) 
*of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager.
*The results are outputted in the excel file "Uganda_NPS_W1_summary_stats.xlsx" in the "Tanzania TNPS - LSMS-ISA - Wave 4 (2014-15)" within the "Final DTA files" folder. //EFW 1.22.19 Update this with new file paths
*It is possible to modify the condition  "if rural==1" in the portion of code following the heading "SUMMARY STATISTICS" to generate all summary statistics for a different sub_population.


/*
OUTLINE OF THE DO.FILE
Below are the list of the main files created by running this Master do.file
 					
*INTERMEDIATE FILES					MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD IDS						Uganda_NPS_W1_hhids.dta
*INDIVIDUAL IDS						Uganda_NPS_W1_person_ids.dta
*HOUSEHOLD SIZE						Uganda_NPS_W1_hhsize.dta
*PARCEL AREAS						Uganda_NPS_W1_plot_areas.dta
*PLOT-CROP DECISION MAKERS			Uganda_NPS_W1_plot_decision_makers.dta
*TLU (Tropical Livestock Units)		Uganda_NPS_W1_TLU_Coefficients.dta

*GROSS CROP REVENUE					Uganda_NPS_W1_tempcrop_harvest.dta
									Uganda_NPS_W1_tempcrop_sales.dta
									Uganda_NPS_W1_permcrop_harvest.dta
									Uganda_NPS_W1_permcrop_sales.dta
									Uganda_NPS_W1_hh_crop_production.dta
									Uganda_NPS_W1_plot_cropvalue.dta
									Uganda_NPS_W1_parcel_cropvalue.dta
									Uganda_NPS_W1_crop_residues.dta
									Uganda_NPS_W1_hh_crop_prices.dta
									Uganda_NPS_W1_crop_losses.dta
*CROP EXPENSES						Uganda_NPS_W1_wages_mainseason.dta
									Uganda_NPS_W1_wages_shortseason.dta
									
									Uganda_NPS_W1_fertilizer_costs.dta
									Uganda_NPS_W1_seed_costs.dta
									Uganda_NPS_W1_land_rental_costs.dta
									Uganda_NPS_W1_asset_rental_costs.dta
									Uganda_NPS_W1_transportation_cropsales.dta
									
*CROP INCOME						Uganda_NPS_W1_crop_income.dta
									
*LIVESTOCK INCOME					Uganda_NPS_W1_livestock_products.dta
									Uganda_NPS_W1_livestock_expenses.dta
									Uganda_NPS_W1_hh_livestock_products.dta
									Uganda_NPS_W1_livestock_sales.dta
									Uganda_NPS_W1_TLU.dta
									Uganda_NPS_W1_livestock_income.dta

*FISH INCOME						Uganda_NPS_W1_fishing_expenses_1.dta
									Uganda_NPS_W1_fishing_expenses_2.dta
									Uganda_NPS_W1_fish_income.dta
																	
*SELF-EMPLOYMENT INCOME				Uganda_NPS_W1_self_employment_income.dta
									Uganda_NPS_W1_agproducts_profits.dta
									Uganda_NPS_W1_fish_trading_revenue.dta
									Uganda_NPS_W1_fish_trading_other_costs.dta
									Uganda_NPS_W1_fish_trading_income.dta
									
*WAGE INCOME						Uganda_NPS_W1_wage_income.dta
									Uganda_NPS_W1_agwage_income.dta
*OTHER INCOME						Uganda_NPS_W1_other_income.dta
									Uganda_NPS_W1_land_rental_income.dta

*FARM SIZE / LAND SIZE				Uganda_NPS_W1_land_size.dta
									Uganda_NPS_W1_farmsize_all_agland.dta
									Uganda_NPS_W1_land_size_all.dta
*FARM LABOR							Uganda_NPS_W1_farmlabor_mainseason.dta
									Uganda_NPS_W1_farmlabor_shortseason.dta
									Uganda_NPS_W1_family_hired_labor.dta
*VACCINE USAGE						Uganda_NPS_W1_vaccine.dta
*USE OF INORGANIC FERTILIZER		Uganda_NPS_W1_fert_use.dta
*USE OF IMPROVED SEED				Uganda_NPS_W1_improvedseed_use.dta

*REACHED BY AG EXTENSION			Uganda_NPS_W1_any_ext.dta
*USE OF FORMAL FINANACIAL SERVICES	Uganda_NPS_W1_fin_serv.dta
*GENDER PRODUCTIVITY GAP 			Uganda_NPS_W1_gender_productivity_gap.dta
*MILK PRODUCTIVITY					Uganda_NPS_W1_milk_animals.dta
*EGG PRODUCTIVITY					Uganda_NPS_W1_eggs_animals.dta

*CROP PRODUCTION COSTS PER HECTARE	Uganda_NPS_W1_hh_cost_land.dta
									Uganda_NPS_W1_hh_cost_inputs_lrs.dta
									Uganda_NPS_W1_hh_cost_inputs_srs.dta
									Uganda_NPS_W1_hh_cost_seed_lrs.dta
									Uganda_NPS_W1_hh_cost_seed_srs.dta		
									Uganda_NPS_W1_cropcosts_perha.dta

*RATE OF FERTILIZER APPLICATION		Uganda_NPS_W1_fertilizer_application.dta
*HOUSEHOLD'S DIET DIVERSITY SCORE	Uganda_NPS_W1_household_diet.dta
*WOMEN'S CONTROL OVER INCOME		Uganda_NPS_W1_control_income.dta
*WOMEN'S AG DECISION-MAKING			Uganda_NPS_W1_make_ag_decision.dta
*WOMEN'S ASSET OWNERSHIP			Uganda_NPS_W1_ownasset.dta
*AGRICULTURAL WAGES					Uganda_NPS_W1_ag_wage.dta
*CROP YIELDS						Uganda_NPS_W1_yield_hh_crop_level.dta

*FINAL FILES						MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD VARIABLES				Uganda_NPS_W1_household_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			Uganda_NPS_W1_individual_variables.dta	
*PLOT-LEVEL VARIABLES				Uganda_NPS_W1_gender_productivity_gap.dta
*SUMMARY STATISTICS					Uganda_NPS_W1_summary_stats.xlsx
*/
clear
set more off
clear matrix
clear mata
set maxvar 10000
ssc install findname

//set directories
*These paths correspond to the folders where the raw data files are located and where the created data andNon Ag Waves Income Secondary Job final data will be stored.


global directory "../.."
global Uganda_NPS_W1_raw_data 	"$directory/Uganda UNPS/Uganda UNPS Wave 1/Raw DTA Files"
global Uganda_NPS_W1_created_data "$directory/Uganda UNPS/Uganda UNPS Wave 1/Final DTA Files/created_data"
global Uganda_NPS_W1_final_data  "$directory/Uganda UNPS/Uganda UNPS Wave 1/Final DTA Files/final_data"
global Uganda_NPS_conv_factors "$directory/Uganda UNPS/Nonstandard Unit Conversion Factors"
global summary_stats "$directory/_Summary_statistics/EPAR_UW_335_SUMMARY_STATISTICS.do" //Path to the summary statistics file. This can take a long time to run, so comment out if you don't need it. The do file will end with an error.


*Wave 1 does not ask the same questions about time worked as subsequent Uganda waves; thus, we use Wave 2 to estimate median weeks worked by occupation with the assumption that time in employment does not vary substantially. Skip lines 2296-2327, 2347-2356, 2442, 2450-2453 if you do not need these variables or download the Uganda Wave 2 raw data (see Uganda Wave 2 readme)
*Wave 1 also doesn't use secondary wage variables in the final analysis, due to which we have commented out the code. However, if you wish to use the code feel free to uncomment the required lines. 

global Uganda_NPS_W2_raw_data 	"$directory/Uganda UNPS/Uganda UNPS Wave 2/Raw DTA Files"
global Uganda_NPS_W2_created_data "$directory/Uganda UNPS/Uganda UNPS Wave 2/Final DTA Files/created_data"
global Uganda_NPS_W2_final_data  "$directory/Uganda UNPS/Uganda UNPS Wave 2/Final DTA Files/final_data"

****************************
*EXCHANGE RATE AND INFLATION
****************************
global Uganda_NPS_W1_exchange_rate 2248.58 //https://archive.bou.or.ug/bou/collateral/interbank_forms/2010/Aug/Major_27Aug10.html
global Uganda_NPS_W1_gdp_ppp_dollar 1251.63 // 1270.608398
    // https://data.worldbank.org/indicator/PA.NUS.PPP 
global Uganda_NPS_W1_cons_ppp_dollar 1219.19	// 1221.087646
	 // https://data.worldbank.org/indicator/PA.NUS.PRVT.PP value
global Uganda_NPS_W1_inflation  0.59959668237 // CPI_Survey_Year/CPI_2017 -> CPI_2010/CPI_2017 ->  (100/166.7787747)
//https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2016&locations=UG&start=2010 // The data were collected over the period 2009 - 2010
global Uganda_NPS_W1_poverty_190 ((1.90*944.26)*(100/116.6)) 
global Uganda_NPS_W1_poverty_npl 29.100 // Source for poverty line: https://documents.worldbank.org/en/publication/documents-reports/documentdetail/456801530034180435/poverty-maps-of-uganda. Since in the same year as survey not adjusted for inflation. 
global Uganda_NPS_W1_poverty_215 (2.15*($Uganda_NPS_W1_inflation)*$Uganda_NPS_W1_cons_ppp_dollar) 

********Currency Conversion Factors*********

*THRESHOLDS FOR WINSORIZATION
********************************************************************************
global wins_lower_thres 1    						//Threshold for winzorization at the bottom of the distribution of continous variables
global wins_upper_thres 99							//Threshold for winzorization at the top of the distribution of continous variables
global wins_5_thres 5								//Threshold for winzorization at the bottom of the distribution of continous variables
global wins_95_thres 95							//Threshold for winzorization at the top of the distribution of continous variables
//08.12.2024 - many of the variables are not getting winsorised enough so using 95 for sometime
********************************************************************************
*RE-SCALING SURVEY WEIGHTS TO MATH POPULATION ESTIMATES
********************************************************************************
*https://databank.worldbank.org/source/world-development-indicators#
global Uganda_NPS_W1_pop_tot 31412520
global Uganda_NPS_W1_pop_rur 5930056
global Uganda_NPS_W1_pop_urb 25482464


********************************************************************************
*GLOBALS OF PRIORITY CROPS 
********************************************************************************
//Purpose: Generate a crop .dta file that only contains the priority crops. This is used in for a couple of other indicators down the line. You can edit this section to change which crops you are examining.

*Enter the 12 priority crops here (maize, rice, wheat, sorghum, pearl millet (or just millet if not disaggregated), cowpea, groundnut, common bean, yam, sweet potato, cassava, banana)
*plus any crop in the top ten crops by area planted that is not already included in the priority crops - limit to 6 letters or they will be too long!
*For consistency, add the 12 priority crops in order first, then the additional top ten crops
global topcropname_area "maize cassav beans fldpea swtptt fmillt sybea banana coffee grdnt sorgum"
global topcrop_area "130 630 210 221 620 141 320 740 810 310 150"
global comma_topcrop_area "130, 630, 210, 221, 620, 141, 320, 740, 810, 310, 150"
global topcropname_area_full "maize cassava beans fieldpeas sweetpotato fingermillet soyabeans banana coffee groundnut sorghum"
global nb_topcrops : list sizeof global(topcropname_area) // Gets the current length of the global macro list "topcropname_area"
set obs $nb_topcrops //Update if number of crops changes
egen rnum = seq(), f(1) t($nb_topcrops)
gen crop_code = .
gen crop_name = ""
forvalues k = 1 (1) $nb_topcrops {
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area 
	replace crop_code = `c' if rnum == `k'
	replace crop_name = "`cn'" if rnum == `k'
}
drop rnum
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_cropname_table.dta", replace //This gets used to generate the monocrop files.
*All cropID match with UG w5 except for banana which has 3 different typesof crops banana food 741 banana beer 742 banana 744. 


********************************************************************************
*HOUSEHOLD IDS* 
********************************************************************************
use "${Uganda_NPS_W1_raw_data}/2009_GSEC1.dta", clear
ren h1aq1 district
ren h1aq2 county 
ren h1aq2b county_name 
ren h1aq3 subcounty 
ren h1aq3b subcounty_name 
ren h1aq4 parish 
ren h1aq4b parish_name
ren comm ea 
ren wgt09 weight  // includes split off households 
gen rural=urban==0 
keep region district county county_name subcounty subcounty_name parish parish_name ea HHID rural stratum weight 
lab var rural "1=Household lives in rural area"

save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hhids.dta" , replace 

********************************************************************************
*WEIGHTS*
********************************************************************************
/* Superseded
use "${Uganda_NPS_W1_raw_data}/2009_GSEC1.dta", clear
rename wgt09 weight // AA, in SAW code, mult=wgt09 
merge m:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hhids.dta"
keep HHID weight rural 

save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_weights.dta" , replace
*/
********************************************************************************
*INDIVIDUAL IDS*
********************************************************************************
use "${Uganda_NPS_W1_raw_data}/2009_GSEC2.dta" , clear 
gen female=h2q3==2 
ren h2q1 personid
lab var female "1= individual is female"
gen age=h2q8 // AA: 1,061 missing values geneerated 
lab var age "individual age" 
gen hh_head=h2q4==1
lab var hh_head "1=individual household head"
keep HHID PID female age hh_head personid

save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_person_ids.dta" , replace 

********************************************************************************
*HOUSEHOLD SIZE*
********************************************************************************
use "${Uganda_NPS_W1_raw_data}/2009_GSEC2.dta", clear
gen hh_members = 1 
ren h2q4 realhead // relationship to household head 
ren h2q3 gender // sex (gender) ------> "variable already defined" !!!!!!
gen fhh = (realhead==1 & gender==2) // we only want the households with a female head og household, even if its a small number 
collapse (sum) hh_members (max) fhh, by (HHID) 
lab var hh_members "Number of household members"
lab var fhh "1= Female-headed household" 

*save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hhsize.dta", replace 

*Re-scaling survey weights to match population estimates
merge 1:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hhids.dta", nogen keep(2 3)
*Adjust to match total population
total hh_members [pweight=weight]
matrix temp =e(b)
gen weight_pop_tot=weight*${Uganda_NPS_W1_pop_tot}/el(temp,1,1)
total hh_members [pweight=weight_pop_tot]
lab var weight_pop_tot "Survey weight - adjusted to match total population"
*Adjust to match total population but also rural and urban
total hh_members [pweight=weight] if rural==1
matrix temp =e(b)
gen weight_pop_rur=weight*${Uganda_NPS_W1_pop_rur}/el(temp,1,1) if rural==1
total hh_members [pweight=weight_pop_tot]  if rural==1
total hh_members [pweight=weight] if rural==0
matrix temp =e(b)
gen weight_pop_urb=weight*${Uganda_NPS_W1_pop_urb}/el(temp,1,1) if rural==0
total hh_members [pweight=weight_pop_urb]  if rural==0
egen weight_pop_rururb=rowtotal(weight_pop_rur weight_pop_urb)
total hh_members [pweight=weight_pop_rururb]  
lab var weight_pop_rururb "Survey weight - adjusted to match rural and urban population"
drop weight_pop_rur weight_pop_urb
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_weights.dta", replace

********************************************************************************
*PLOT AREA*
********************************************************************************
use "${Uganda_NPS_W1_raw_data}/2009_AGSEC4A.dta" , clear 
gen season=1 
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC4B.dta"
replace season=2 if season==.
label var season "season = 1 is 1st cropping season of 2011, 2 if 2nd cropping season of 2011" 
rename A4aq2 parcel_id
replace parcel_id = A4bq2 if season ==2
rename A4aq4 plot_id
replace plot_id = A4bq4 if season ==2
//check for plot area varriable 
gen ha_planted=A4aq8 // vlaues are in acres (total area of plot planted) A4aq9 percentage of crop planted in the plot area 
replace ha_planted = A4bq8 if ha_planted==. //values are in acres 
replace ha_planted = ha_planted * 0.404686 //conversion factor is 0.404686 ha = 1 acre.

 rename Hhid HHID
  bys HHID parcel_id plot_id season : gen ncrops=_N
*Now, generate variables to fix issus with the percentage of a plot that crops are planted on not adding up to 100 (both above and below). This is complicated so each line below explains the procedure 

recode ha_planted (.=0)
bys HHID plot_id parcel_id : egen max_ha_planted = max(ha_planted) //should be total area planted by plot
replace ha_planted=max_ha_planted

gen percent_planted = A4aq9/100
replace percent_planted = A4bq9/ 100 if percent_planted==. 
replace percent_planted=1 if ncrops==1 & percent_planted==.

bys HHID parcel_id plot_id season : egen total_percent_planted = sum(percent_planted) //generate variable for total percent of a plot that is planted (all crops)
gen missing_ratio=percent_planted==.
bys HHID parcel_id plot_id season : egen tot_miss = sum(missing_ratio)
replace percent_planted = percent_planted/total_percent_planted if total_percent_planted > 1
replace percent_planted = 1/tot_miss if missing_ratio & tot_miss==ncrops
replace percent_planted = (1-total_percent_planted)/tot_miss if missing_ratio & tot_miss < ncrops

gen crop_code=A4aq6
replace crop_code=A4bq6 if crop_code==.

preserve 
keep HHID parcel_id plot_id crop_code percent_planted season
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_crop_areas.dta", replace
restore

*Bring everything together
collapse(max) ha_planted (sum) percent_planted, by(HHID parcel_id plot_id season)
gen plot_area = ha_planted / percent_planted
bys HHID parcel_id season : egen total_plot_area = sum(plot_area)
generate plot_area_pct = plot_area/total_plot_area
keep HHID parcel_id plot_id season plot_area total_plot_area plot_area_pct ha_planted


tempfile sea1 sea2 sea3 // 

tempfile sea1 sea2 sea3 // 
save `sea1'

use "${Uganda_NPS_W1_raw_data}/2009_AGSEC2A.dta", clear 
ren A2aq2 parcel_id
ren Hhid HHID
save `sea2'

use "${Uganda_NPS_W1_raw_data}/2009_AGSEC2B.dta", clear 
ren A2bq2 parcel_id
ren Hhid HHID
save `sea3'

use `sea1', clear
merge m:1 HHID parcel_id using `sea2', nogen 
merge m:1 HHID parcel_id using `sea3', nogen // use a temporary file to merge the 1 to many, sea1, sea2, sea3 to merge raw data together (combines the appended season w additonally appened season variables in additional data set) 

***generating field_size using merged variables***
generate parcel_acre = parcel_id // Replaced missing GPS estimation here to get parcel size in acres if we have it, but many parcels do not have gps estimation
replace parcel_acre = A2bq4 if parcel_acre == . 
replace parcel_acre = A2aq5 if parcel_acre == . // Replaced missing GPS values with farmer estimation, which is less accurate but has full coverage (and is also in acres) 
replace parcel_acre = A2bq5 if parcel_acre == . // see above 
gen field_size = plot_area_pct*parcel_acre // Using calculated percentages of plots (out of total plots per parcel) to estimate plot size using more accurate parcel measurements 
replace field_size = field_size * 0.404686 // CONVERSION FACTOR IS 0.404686 ha = 1 acre 
gen parcel_ha = parcel_acre * 0.404686 
*cleaning up and saving the data 
keep HHID parcel_id plot_id season field_size plot_area total_plot_area parcel_acre ha_planted parcel_ha
drop if field_size == . 
label var field_size "area of plot (ha)"
label var HHID "household identifier"
tostring HHID , format(%18.0f) replace 

save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_areas.dta" , replace 

********************************************************************************
*PLOT DECISION MAKERS
********************************************************************************
/*
use "${Uganda_NPS_W1_raw_data}/2009_AGSEC3A.dta" , clear 
gen season =1 
ren Hhid HHID
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC3B.dta" 
replace season =2 if season == . 
ren A3aq1 parcel_id
replace parcel_id=a3bq1 if a3bq1!=. & parcel_id==.
ren A3aq3 plot_id
replace plot_id=a3bq3 if a3bq3!=. & plot_id==.
keep HHID season parcel_id plot_id
drop if parcel_id == .
drop if plot_id == .

tempfile plotid
save `plotid'
*/
use "${Uganda_NPS_W1_raw_data}/2009_AGSEC2A.dta" , clear 

append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC2B.dta" 
ren Hhid HHID
gen formal_land_rights = (A2aq25==1 | A2aq25==2 | A2aq25==3)
*ren A3aq3 plot_id 
ren A2aq2 parcel_id // using parcel ID 
replace parcel_id= A2bq2 if parcel_id==.
drop if parcel_id == .
gen personid1 = A2aq28a
replace personid1=A2bq26a if personid1==.   
gen personid2=A2aq28b
replace personid2=A2bq26b if personid2==.
keep HHID /*plot_id*/ parcel_id /*season*/ personid* formal_land_rights
reshape long personid, i(HHID parcel_id formal_land_rights) j(id_no)                                                          
merge m:1 HHID personid using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_person_ids.dta", nogen keep(1 3) //Dropping unmatched from using
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_dm_ids.dta", replace
preserve 
gen formal_land_rights_f=formal_land_rights if female==1
collapse (max) formal_land_rights_f, by(HHID personid) 
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_land_rights_ind.dta", replace
collapse (max) formal_land_rights_hh=formal_land_rights, by(HHID)
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_land_rights_hh.dta", replace
restore 
gen dm1_gender=female+1 if id_no==1
collapse (mean) female (firstnm) dm1_gender, by(HHID /*plot_id*/ parcel_id /*season*/)
gen dm_gender=3 if female!=.
replace dm_gender=1 if female==0
replace dm_gender=2 if female==1

*Replacing observations without gender of plot manager with gender of HOH
merge m:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_weights.dta", nogen keep(1 3) keepusing(fhh)							
replace dm_gender = 1 if fhh==0 & dm_gender==.
replace dm_gender = 2 if fhh==1 & dm_gender==.
replace dm1_gender=dm_gender if dm_gender < 3 & dm1_gender==.
la def dm_gender 1 "Male only" 2 "Female only" 3 "Mixed gender"
la val dm_gender dm_gender
la val dm1_gender dm_gender
lab var  dm_gender "Gender of plot manager/decision maker"
//lab var cultivated "1=Plot has been cultivated"
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_decision_makers.dta", replace

********************************************************************************
*FORMALIZED LAND RIGHTS - Using Wave 2
*******************************************************************************
*see above


********************************************************************************
** 								ALL PLOTS									  **
********************************************************************************

	*****************************
	*CROP VALUES*
	*****************************
use "${Uganda_NPS_W1_raw_data}/2009_AGSEC5a" , clear 
ren A5aq1 A5bq1
ren A5aq3 A5bq3
ren A5aq4 A5bq4
ren A5aq5 A5bq5
gen season=1
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC5B"
replace season=2 if season==.
ren A5bq1 parcel_id
ren A5bq3 plot_id
rename A5bq5 crop_code 
rename A5bq4 crop_name 
gen pct_lost=A5aq16/100
replace pct_lost=A5bq16/100 if pct_lost==.

drop if crop_code==. & crop_name=="" //3471 crop_code observations were dropped since they are missing from the raw data 
* Unit of Crop Harvested 
drop if parcel_id==. & plot_id==. // 20 observations deleted since no plot or parcel id 
recode A5aq6a (99999=.a) if A5aq11==. //(1410 quantities (99999) changed to missing since the entire row doesn't have any information)
clonevar condition_harv = A5aq6b
replace condition_harv = A5bq6b if season==2
clonevar unit_code_harv=A5aq6c
replace unit_code_harv=A5bq6c if unit_code==.

clonevar conv_factor_harv = A5aq6d 
replace conv_factor_harv = A5bq6d if season==2
replace conv_factor_harv = 1 if unit_code_harv==1

*Unit of Crop Sold
clonevar sold_unit_code =A5aq7c 
replace sold_unit_code=A5bq7c if sold_unit_code==.
clonevar sold_value= A5aq8
replace sold_value=A5aq8 if sold_value==. 


gen sold_qty=A5aq7a
replace sold_qty=A5bq7a if sold_qty==. // 4323 have missing quantities and no reason for no harvest mentioned 

drop if plot_id==. | parcel_id==. | crop_code==. // 649 deleted

*gen quant_sold_kg = sold_qty*conv_factor_sold 

tostring Hhid, format(%18.0f) replace
rename Hhid HHID
merge m:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_HHIDs.dta", nogen keepusing(region district county subcounty parish ea weight) keep(1 3)
label values crop_code cropID //apply crop labels to crop_code_master

**********************************
** Standard Conversion Factor Table **
**********************************
***We merge Crop Sold Conversion Factor at the crop-unit-regional level***

merge m:1 crop_code sold_unit_code region using "${Uganda_NPS_conv_factors}/UG_Conv_fact_sold_table.dta", keep(1 3) nogen 
***We merge Crop Sold Conversion Factor at the crop-unit-national level***
*This is for HHID with missing regional information. 
merge m:1 crop_code sold_unit_code using "${Uganda_NPS_conv_factors}/UG_Conv_fact_sold_table_national.dta", keep(1 3) nogen 

*We create Quantity Sold (kg using standard  conversion factor table for each crop- unit and region). 
replace s_conv_factor_sold = sn_conv_factor_sold if region==. // We merge the national standard conversion factor for those HHID with missing regional info. 
gen quant_sold_kg = sold_qty*s_conv_factor_sold
replace quant_sold_kg=. if sold_qty==0 | sold_unit_code==.
gen price_unit = sold_value/quant_sold_kg 
gen obs = price_unit!=.

// Loop for price per kg for each crop at different geographic dissagregate using Standard price per kg variable (from standard conversion factor table)
	foreach i in region district county subcounty parish ea HHID{
		preserve
		recode crop_code (741 742 744 = 740) (224 = 223)
		collapse (median) price_unit_`i' = price_unit (rawsum) obs_`i'=obs [aw=weight], by(`i' crop_code)
		tempfile price_unit_`i'_median
		save `price_unit_`i'_median'
		restore
	}
	preserve
	collapse (median) price_unit_country = price_unit (rawsum) obs_country_price = obs [aw=weight], by(crop_code)
	tempfile price_unit_country_median
	save `price_unit_country_median'
	restore

***We merge Crop Harvested Conversion Factor at the crop-unit-regional ***
clonevar  unit_code= unit_code_harv

merge m:1 crop_code unit_code region using "${Uganda_NPS_conv_factors}/UG_Conv_fact_harvest_table.dta", keep(1 3) nogen 

***We merge Crop Harvested Conversion Factor at the crop-unit-national ***
merge m:1 crop_code unit_code using "${Uganda_NPS_conv_factors}/UG_Conv_fact_harvest_table_national.dta", keep(1 3) nogen 


*This is for HHID that are missing regional information

*From Conversion factor section to calculate medians
clonevar quantity_harv=A5aq6a
replace quantity_harv=A5bq6a if quantity_harv==.
replace quantity_harv=. if quantity_harv==99999
*gen quant_harv_kg = quantity_harv*conv_factor_harv 

gen quant_harv_kg = quantity_harv*s_conv_factor_harv 
replace s_conv_factor_harv = sn_conv_factor_harv if region!=. // We merge the national standard conversion factor for those HHID with missing regional info.

*Date/month is not there 
label var price_unit "Average sold value per kg of harvest sold"
preserve
	ren unit_code_harv unit
	collapse (mean) val_unit=price_unit, by (HHID crop_code unit)
	ren val_unit hh_price_mean
	lab var hh_price_mean "Average price reported for this crop-unit in the household"
	save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_crop_prices_for_wages.dta", replace
restore
gen quant_lost_kg =  quant_harv_kg*pct_lost 
gen value_harvest=quant_harv_kg*price_unit 
gen value_lost=quant_lost_kg*price_unit
collapse (sum) quant_harv_kg quant_sold_kg quant_lost_kg value_harvest value_lost (mean) price_unit, by(HHID parcel_id plot_id crop_code season)
*Checking price_unit mean and sd for each type of crop ->  bys crop_code: sum price_unit
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_crop_value.dta", replace 

**********************************
** Plot Variables **
**********************************

use "${Uganda_NPS_W1_raw_data}/2009_AGSEC4A", clear 
gen season=1
rename A4aq2 A4bq2
rename A4aq6 A4bq6
rename A4aq4 A4bq4
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC4B"
replace season=2 if season==.
gen crop_code_plant=A4bq6
rename Hhid HHID
rename A4bq4 plot_id
rename A4bq2 parcel_id
*rename A4aq5 crop_code_plant //crop codes for what was planted
*encode crop_code_plant, replace
drop if crop_code_plant == .
gen use_imprv_seed = (A4aq13==2) if A4aq13!=.
replace use_imprv_seed= (A4bq13==2) if use_imprv_seed==. & A4bq13!=.
clonevar crop_code = crop_code_plant //we want to keep the original crop IDs intact while reducing the number of categories in the master version
merge 1:1 HHID parcel_id plot_id crop_code season using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_crop_areas.dta", nogen keep(1 3)	
recode crop_code (741 742 744 = 740) (224 = 223) //740 is bananas, which is being reduced from different types to just bananas. Same for peas (220).
label define cropID 740 "BANANAS", modify //need to add new codes to the value label, cropID
label values crop_code cropID //apply crop labels to crop_code_master

merge m:1 HHID parcel_id plot_id season using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_areas.dta", nogen keep(1 3)	
drop ha_planted //Misnomer, to fix.
	gen ha_planted=percent_planted*field_size
	gen perm_tree = 1 if inlist(crop_code, 460, 630, 700, 710, 720, 740, 750, 760, 770, 780, 810, 820, 830, 870) //dodo, cassava, oranges, pawpaw, pineapple, bananas, mango, jackfruit, avocado, passion fruit, coffee, cocoa, tea, and vanilla, in that order SAW everythins works except for 740 banana that is still 741 742 and 744
replace perm_tree = 0 if perm_tree == .

	*plant_dates harv_dates plant_date_unique harv_date_unique permax
	gen ha_harvest=ha_planted
merge m:1 HHID parcel_id plot_id crop_code season using  "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_crop_value.dta", nogen keep(1 3)
merge m:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hhids.dta", nogen keep(1 3)
//To add: lost crops
	collapse (sum) percent_field=percent_planted /*To fix*/ quant_harv_kg value_harvest ha_harvest ha_planted  /* plant_date months_grown s_quant_harv_kg s_value_harvest harv_date harv_end*/, by(region district county /*subcounty*/ parish ea HHID parcel_id plot_id season crop_code field_size perm_tree /*month_planted month_harvest*/)
		gen purestand=1
	bys HHID parcel_id plot_id season : egen permax = max(perm_tree)
	bysort HHID parcel_id plot_id season: gen cropcount= _N
	bysort HHID parcel_id plot_id : gen permcount=sum(perm_tree)
	gen perm_code =crop_code if perm_tree==1 
	bys HHID parcel_id plot_id : egen mean_pc = mean(perm_code)	
	replace purestand = 0 if cropcount>1
	replace purestand = 0 if cropcount==1 & permcount>1
	replace purestand = 0 if cropcount==1 & permcount==1 & crop_code!=mean_pc & mean_pc!=.
	lab var perm_tree "1 = Tree or permanent crop"

	lab var purestand "1 = monocropped, 0 = intercropped"
	bys HHID parcel_id plot_id season : egen percent_area = sum(percent_field)
	bys HHID parcel_id plot_id season : gen percent_inputs = percent_field / percent_area
	drop percent_area //Assumes that inputs are +/- distributed by the area planted. Probably not true for mixed tree/field crops, but reasonable for plots that are all field crops
	//Labor should be weighted by growing season length, though. 
	merge m:1 HHID parcel_id /*season*/ using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm*)
	save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_all_plots.dta", replace

********************************************************************************
** 								ALL PLOTS END								  **
*******************************************************************************
********************************************************************************
*                              GROSS CROP REVENUE                              *
********************************************************************************
*Temporary crops (both seasons) 
use "${Uganda_NPS_W1_raw_data}/2009_AGSEC5A.dta", clear 
rename A5aq1 A5bq1
rename A5aq3 A5bq3
rename A5aq5 A5bq5
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC5B.dta"
* Standardizing major variable names across waves/files
rename Hhid HHID
rename A5bq1 parcel_id 
rename A5bq3 plot_id 
rename A5bq5 crop_code 
gen qty_harvest=A5aq6a
replace qty_harvest = A5bq6a if qty_harvest ==. 
drop if plot_id == . 
recode crop_code (811 812 = 810) (741 742 744 = 740) (224 = 223) //740 is bananas, which is being reduced from different types to just bananas. Same for peas (220).
 
* Set uniform variable names across seasons/waves for: 
* quantity harvested		condition at harvest 	unit of measure at harvest
* conversion to kg			quantity sold			condition at sale
rename A5aq7a qty_sold 
replace qty_sold = A5bq7a if qty_sold==. & A5bq7a!=.
ren A5aq8 value_sold
replace value_sold =A5bq8 if value_sold == . 
recode value_sold (.=0)
gen sold_unit_code=A5aq7c
replace sold_unit_code=A5bq7c if sold_unit_code==.
tostring HHID, format(%18.0f) replace
merge m:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hhids.dta", nogen keepusing(region district county subcounty parish ea weight) keep(1 3)
***We merge Crop Sold Conversion Factor at the crop-unit-regional level***
merge m:1 crop_code sold_unit_code region using "${Uganda_NPS_conv_factors}/UG_Conv_fact_sold_table.dta", keep(1 3) nogen 

***We merge Crop Sold Conversion Factor at the crop-unit-national level***
*This is for HHID with missiong regional information. 
merge m:1 crop_code sold_unit_code  using "${Uganda_NPS_conv_factors}/UG_Conv_fact_sold_table_national.dta", keep(1 3) nogen 

rename A5aq6d conversion 
replace conversion = A5bq6d if conversion==. & A5bq6d!=. 
gen conversion_sold=A5aq6c
replace conversion_sold = A5bq6c if conversion_sold ==. 
gen kgs_harvest = qty_harvest * conversion 
** Used A5aq6d as conversion factor since questionnaire labelled that as the conversion to kgs 
replace s_conv_factor_sold = sn_conv_factor_sold if region!=. //  We merge the national standard conversion factor for those HHID with missing regional info. 
gen kgs_sold = qty_sold*s_conv_factor_sold

recode crop_code (811 812 = 810) (741 742 744 = 740) (224 = 223) //740 is bananas, which is being reduced from different types to just bananas. Same for peas (220).
collapse (sum) value_sold kgs_sold, by (HHID crop_code)
lab var value_sold "Value of sales of this crop"
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_cropsales_value.dta", replace

use "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_all_plots.dta", clear
*ren crop_code_master crop_code
collapse (sum) value_harvest quant_harv_kg , by (HHID crop_code) 
merge 1:1 HHID crop_code using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_cropsales_value.dta"
recode value_harvest value_sold (.=0)

replace value_harvest = value_sold if value_sold>value_harvest & value_sold!=. /* In a few cases, sales value reported exceeds the estimated value of crop harvest */
ren value_sold value_crop_sales 
collapse (sum) value_harvest value_crop_sales kgs_sold quant_harv_kg, by (HHID crop_code)
ren value_harvest value_crop_production
lab var value_crop_production "Gross value of crop production, summed over main and short season"
lab var value_crop_sales "Value of crops sold so far, summed over main and short season"
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hh_crop_values_production.dta", replace

collapse (sum) value_crop_production value_crop_sales, by (HHID)
lab var value_crop_production "Gross value of crop production for this household"
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hh_crop_production.dta", replace

use "${Uganda_NPS_W1_raw_data}/2009_AGSEC5A.dta", clear 
rename A5aq1 A5bq1
rename A5aq3 A5bq3
rename A5aq5 A5bq5
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC5B.dta"
* Standardizing major variable names across waves/files
rename Hhid HHID
rename A5bq1 parcel_id 
rename A5bq3 plot_id 
rename A5bq5 crop_code 
rename A5aq6a qty_harvest 

recode crop_code (811 812 = 810) (741 742 744 = 740) (224 = 223) //740 is bananas, which is being reduced from different types to just bananas. Same for peas (220).

drop if crop_code==.
rename A5aq16 percent_lost
replace percent_lost = A5bq16 if percent_lost==. & A5bq16!=.
replace percent_lost = 100 if percent_lost > 100 & percent_lost!=. 
tostring HHID, format(%18.0f) replace
merge m:1 HHID crop_code using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hh_crop_values_production.dta", nogen keep(1 3)
gen value_lost = value_crop_production * (percent_lost/100)
recode value_lost (.=0)
collapse (sum) value_lost, by (HHID)
rename value_lost crop_value_lost
lab var crop_value_lost "Value of crop production that had been lost by the time of survey"
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_crop_losses.dta", replace

********************************************************************************
** 								CROP EXPENSES								  **
******************************************************************************** 
	*********************************
	* 			LABOR				*
	*********************************
*Hired Labor 

	//Purpose: This section will develop indicators around inputs related to crops, such as labor (hired and family), pesticides/herbicides, animal power (not measured for Uganda), machinery/tools, fertilizer, land rent, and seeds. //JHG 5_3_22: edit this description later
use "${Uganda_NPS_W1_raw_data}/2009_AGSEC3A", clear 
gen season = 1	
rename Hhid HHID
rename A3aq1 A3bq1
rename A3aq3 A3bq3
rename A3aq5 A3bq5
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC3B"
replace season = 2 if season == .
rename A3bq1 parcel_id 
rename A3bq3 plot_id 
rename A3bq5 crop_code 

ren A3aq42a dayshiredmale
replace dayshiredmale = a3bq42a if dayshiredmale == .
replace dayshiredmale = . if dayshiredmale == 0

ren A3aq42b dayshiredfemale
replace dayshiredfemale = a3bq42b if dayshiredfemale == .
replace dayshiredfemale = . if dayshiredfemale == 0
ren A3aq42c dayshiredchild
replace dayshiredchild = a3bq42c if dayshiredchild == .
replace dayshiredchild = . if dayshiredchild == 0	

ren A3aq43 wagehired
replace wagehired = a3bq43 if wagehired == .
gen wagehiredmale = wagehired if dayshiredmale != .
gen wagehiredfemale = wagehired if dayshiredfemale != .
gen wagehiredchild = wagehired if dayshiredchild != .
//
recode dayshired* (.=0)
gen dayshiredtotal = dayshiredmale + dayshiredfemale + dayshiredchild 
replace wagehiredmale = wagehiredmale/dayshiredtotal
replace wagehiredfemale = wagehiredfemale/dayshiredtotal
replace wagehiredchild = wagehiredchild/dayshiredtotal
//
keep HHID parcel_id plot_id season *hired*
drop wagehired dayshiredtotal

duplicates drop HHID parcel_id plot_id season, force
reshape long dayshired wagehired, i(HHID parcel_id plot_id season) j(gender) string
reshape long days wage, i(HHID parcel_id plot_id season gender) j(labor_type) string
recode wage days (. = 0)
drop if wage == 0 & days == 0

gen val = wage*days
tostring HHID, format(%18.0f) replace
merge m:1 HHID parcel_id plot_id season using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_areas.dta", nogen keep(1 3) keepusing(field_size)
merge m:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_weights.dta", nogen keep(1 3) keepusing(weight)
merge m:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hhids.dta", nogen keep(1 3)
gen plotweight = weight * field_size //hh crossectional weight multiplied by the plot area
recode wage (0 = .)
gen obs = wage != .

*Median wages
foreach i in region district county subcounty parish ea HHID {
preserve
	bys `i' season gender : egen obs_`i' = sum(obs)
	collapse (median) wage_`i' = wage [aw = plotweight], by (`i' season gender obs_`i')
	tempfile wage_`i'_median
	save `wage_`i'_median'
restore
}
preserve
collapse (median) wage_country = wage (sum) obs_country = obs [aw = plotweight], by(season gender)
tempfile wage_country_median
save `wage_country_median'
restore

drop obs plotweight wage rural
tempfile all_hired
save `all_hired'

******************************  FAMILY LABOR   *********************************

use "${Uganda_NPS_W1_raw_data}/2009_AGSEC3A", clear 
gen season = 1
rename Hhid HHID
rename A3aq1 a3bq1
rename A3aq3 a3bq3
rename A3aq5 a3bq5
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC3B"
replace season = 2 if season == .
rename a3bq1 parcel_id 
rename a3bq3 plot_id 
rename a3bq5 crop_code 
ren A3aq39 days 
rename A3aq38 fam_worker_count // number of hh members who worked on the plot
replace fam_worker_count=a3bq38 if fam_worker_count==.
ren A3aq40* PID_* // The number of total family members working on plot (fam_worker_count) can be higher than the pid_* vars since a max of 3 hh members are counted.
keep HHID parcel_id plot_id season PID* days fam_worker_count
preserve
use "${Uganda_NPS_W1_raw_data}/2009_GSEC2", clear 
*Ahana: PID in both long and wide format...so in order to take convert to long deleted the long version for now to keep on the wide version for easier manipulation for later 
drop PID
rename h2q1 PID
gen male = h2q3 == 1
gen age = h2q8
keep HHID PID age male 
isid HHID PID
tempfile members
save `members', replace
restore

duplicates drop  HHID parcel_id plot_id season, force // 0 deleted 

reshape long PID, i(HHID parcel_id plot_id season) j(colid) string
drop if days == . // lost 33771 obervations 
tostring HHID, format(%18.0f) replace

merge m:1 HHID PID using `members', nogen keep(1 3) // 8923 unmatched obervations lots of missing plotids which is also affecting the general generation of pid 
gen gender = "child" if age < 16
replace gender = "male" if strmatch(gender, "") & male == 1
replace gender = "female" if strmatch(gender, "") & male == 0 
replace gender = "unknown" if strmatch(gender, "") & male == .
gen labor_type = "family"
drop if gender == "unknown"
merge m:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hhids.dta", nogen keep(1 3) //merge in regional data (districts, etc.)
keep region district county subcounty parish ea HHID parcel_id plot_id season gender days labor_type fam_worker_count

foreach i in region district county subcounty parish ea HHID {
	merge m:1 `i' gender season using `wage_`i'_median', nogen keep(1 3) 
}
	merge m:1 gender season using `wage_country_median', nogen keep(1 3) //1,692 with missing vals b/c they don't have matches on pid, see code above

	gen wage = wage_HHID
	*recode wage (.=0) 
* Total days of work for family labor but not for each individual on the hhhd we need to divide total days by number of subgroups of gender that were included as workers in the farm within each household. OR we could assign median wages irrespective of gender (we would need to calculate that in family hired by geographic levels of granularity irrespective ofgender)
by HHID parcel_id plot_id season, sort: egen numworkers = count(_n)
replace days = days/numworkers // If we divided by famworkers we would not be capturing the total amount of days worked. 
gen val = wage * days
append using `all_hired'
keep region district county subcounty parish ea HHID parcel_id plot_id season days val labor_type gender
drop if val == . & days == .
merge m:1 HHID parcel_id  using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
collapse (sum) val days, by(HHID parcel_id plot_id season labor_type gender dm_gender) // Number of workers is not measured by this survey, may affect agwage section
	la var gender "Gender of worker"
	la var dm_gender "Plot manager gender"
	la var labor_type "Hired, exchange, or family labor"
	la var days "Number of person-days per plot"
	la var val "Total value of hired labor (Naira)"
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_labor_long.dta", replace

preserve
collapse (sum) labor_ = days, by (HHID parcel_id plot_id labor_type)
reshape wide labor_, i(HHID parcel_id plot_id) j(labor_type) string
		la var labor_family "Number of family person-days spent on plot, all seasons"
		la var labor_hired "Number of hired labor person-days spent on plot, all seasons"
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_labor_days.dta", replace
restore

preserve
	gen exp = "exp" if strmatch(labor_type,"hired")
	replace exp = "imp" if strmatch(exp, "")
	collapse (sum) val, by(HHID parcel_id plot_id exp dm_gender) 
	gen input = "labor"
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_labor.dta", replace
restore	
//And now we go back to wide
collapse (sum) val, by(HHID parcel_id plot_id season labor_type dm_gender)
ren val val_ 
reshape wide val_, i(HHID parcel_id plot_id season dm_gender) j(labor_type) string
ren val* val*_
reshape wide val*, i(HHID parcel_id plot_id dm_gender) j(season)
gen dm_gender2 = "male" if dm_gender == 1
replace dm_gender2 = "female" if dm_gender == 2
replace dm_gender2 = "mixed" if dm_gender == 3
drop dm_gender
ren val* val*_
drop if dm_gender2 == "" //69 observations lost, due to missing values in both plot decision makers and gender of head of hh. Looked into it but couldn't find a way to fill these gaps, although I did minimize them. SAW: We need to fix this at some point, this is due to missing geographic information. 
reshape wide val*, i(HHID parcel_id plot_id) j(dm_gender2) string
collapse (sum) val*, by(HHID)
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hh_cost_labor.dta", replace

******************************************************************************
** CHEMICALS, FERTILIZER, LAND, ANIMALS (excluded for Uganda), AND MACHINES **
******************************************************************************
*Notes: This is still part of the Crop Expenses Section.
**********************    PESTICIDES/HERBICIDES   ******************************
use "${Uganda_NPS_W1_raw_data}/2009_AGSEC3A", clear 
gen season = 1
rename Hhid HHID
rename A3aq1 a3bq1
rename A3aq3 a3bq3
rename A3aq5 a3bq5
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC3B"
replace season = 2 if season == .
rename a3bq1 parcel_id 
rename a3bq3 plot_id 
rename a3bq5 crop_code 

ren A3aq28a unitpest //unit code for total pesticides used, first planting season (kg = 1, litres = 2)
ren A3aq28b qtypest //quantity of unit for total pesticides used, first planting season
replace unitpest = a3bq28a if unitpest == . //add second planting season
replace qtypest = a3bq28b if qtypest == . //add second planting season
ren A3aq30 qtypestexp //amount of total pesticide that is purchased
replace qtypestexp = a3bq30 if qtypestexp == . //add second planting season
gen qtypestimp = qtypest - qtypestexp //this calculates the non-purchased amount of pesticides used	
ren A3aq8 valpestexp // only 4 obersvations here 
replace valpestexp = a3bq8 if valpestexp == .	
gen valpestimp= .
rename unitpest unitpestexp
gen unitpestimp = unitpestexp
drop qtypest
 
gen qtyanmlexp = .
gen qtyanmlimp = .
gen unitanmlexp = .
gen unitanmlimp = .
gen valanmlexp = .
gen valanmlimp = .
tostring HHID, format(%18.0f) replace
*************************    MACHINERY INPUTS   ********************************

preserve //This section creates raw data on value of machinery/tools
use "${Uganda_NPS_W1_raw_data}/2009_AGSEC10", clear 

*drop if own_implement == 2 //2 = no farm implement owned, rented, or used (separated by implement). AR: 11145 deleted (only 825 observations left)
label variable A10q2 "From whom did you receive the credit?"
ren A10q3 qtymechimp //number of owned machinery/tools - variable does not exist 
*Value of all items does not exist created a blank variable in order to collapse later 
gen valmechimp=.
*ren A10q2 valmechimp //total value of owned machinery/tools, not per-item
ren A10q7 qtymechexp //number of rented machinery/tools
ren A10q8 valmechexp //total value of rented machinery/tools, not per-item
rename Hhid HHID
* one HHID is missing
*drop if HHID=="."
collapse (sum) valmechimp valmechexp, by(HHID) //combine values for all tools, don't combine quantities since there are many varying types of tools 
*drop if HHID=="."
*isid HHID //check for duplicate hhids, which there shouldn't be after the collapse
tostring HHID, format(%18.0f) replace
tempfile rawmechexpense
save `rawmechexpense', replace
restore

preserve
use "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_areas.dta", clear
collapse (sum) ha_planted, by(HHID)
ren ha_planted ha_planted_total
tempfile ha_planted_total
save `ha_planted_total'
restore
	
preserve
use "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_areas.dta", clear
merge m:1 HHID using `ha_planted_total', nogen
gen planted_percent = ha_planted / ha_planted_total //generates a per-plot and season percentage of total ha planted / SAW ha_planted_total its total area planted for both seasons per HHID 
tempfile planted_percent
save `planted_percent'
restore

merge m:1 HHID parcel_id plot_id season using `planted_percent', nogen
merge m:1 HHID using `rawmechexpense', nogen
replace valmechexp = valmechexp * planted_percent //replace total with plot and season specific value of rented machinery/tools

//Now to reshape long and get all the medians at once.
keep HHID parcel_id plot_id season qty* val* unit*
unab vars : *exp //create a local macro called vars out of every variable that ends with exp
local stubs : subinstr local vars "exp" "", all //create another local called stubs with exp at the end, with "exp" removed. This is for the reshape below
duplicates drop HHID parcel_id plot_id season, force // we need to  drop 3 duplicates so reshape can run
*rename qtypest qtypesticide
reshape long `stubs', i(HHID parcel_id plot_id season) j(exp) string
reshape long val qty unit, i(HHID parcel_id plot_id season exp) j(input) string
gen itemcode=1
tempfile plot_inputs
tostring HHID, format(%18.0f) replace
merge m:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hhids.dta", nogen keep(1 3)
save `plot_inputs'
*Notes: Does the quantity for machinery matters here? Right now we haven't constructed a qtymechimp qtymechexp variable so quantity var for mech is always missing. Let Josh now so he can update UG W5.

******************************************************************************
****************************     FERTILIZER   ********************************** 
******************************************************************************

* NEE 11/11/2024 referencing Ethiopia W5 - issue#442


use "${Uganda_NPS_W1_raw_data}/2009_AGSEC3A", clear 
rename Hhid HHID
gen season = 1 
rename A3aq1 a3bq1
rename A3aq3 a3bq3

append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC3B"
replace season = 2 if season == . 
rename a3bq1 parcel_id 
rename a3bq3 plot_id 

********** Inorganic Fertilizer ********** 

// Nitrate
gen usefertexp1 = 1 if A3aq15 == 1 | a3bq15 == 1
gen qtyferttotal1 = A3aq16 if A3aq15 == 1
replace qtyferttotal1 = a3bq16 if qtyferttotal1 == . & a3bq15 == 1
gen unitfertexp1 = 1 if A3aq15 == 1 | a3bq15 == 1 // quantity in Kg 
gen qtyfertexp1 = A3aq18 if A3aq15 == 1 // purchased in Kg
replace qtyfertexp1 = a3bq18 if qtyfertexp1 == . & a3bq15 == 1
gen valfertexp1 = A3aq19 if A3aq15 == 1 // purchased in UShs
replace valfertexp1 = a3bq19 if valfertexp1 == . & a3bq15 == 1
gen qtyfertimp1 = qtyferttotal1 - qtyfertexp1 // imputed Kg

// Phosphate
gen usefertexp2 = 1 if A3aq15 == 2 | a3bq15 == 2
gen qtyferttotal2 = A3aq16 if A3aq15 == 2
replace qtyferttotal2 = a3bq16 if qtyferttotal2 == . & a3bq15 == 2
gen unitfertexp2 = 1 if A3aq15 == 2 | a3bq15 == 2
gen qtyfertexp2 = A3aq18 if A3aq15 == 2
replace qtyfertexp2 = a3bq18 if qtyfertexp2 == . & a3bq15 == 2
gen valfertexp2 = A3aq19 if A3aq15 == 2
replace valfertexp2 = a3bq19 if valfertexp2 == . & a3bq15 == 2
gen qtyfertimp2 = qtyferttotal2 - qtyfertexp2

// Potash
gen usefertexp3 = 1 if A3aq15 == 3 | a3bq15 == 3
gen qtyferttotal3 = A3aq16 if A3aq15 == 3
replace qtyferttotal3 = a3bq16 if qtyferttotal3 == . & a3bq15 == 3
gen unitfertexp3 = 1 if A3aq15 == 3 | a3bq15 == 3
gen qtyfertexp3 = A3aq18 if A3aq15 == 3
replace qtyfertexp3 = a3bq18 if qtyfertexp3 == . & a3bq15 == 3
gen valfertexp3 = A3aq19 if A3aq15 == 3
replace valfertexp3 = a3bq19 if valfertexp3 == . & a3bq15 == 3
gen qtyfertimp3 = qtyferttotal3 - qtyfertexp3

// Mixed
gen usefertexp4 = 1 if A3aq15 == 4 | a3bq15 == 4
gen qtyferttotal4 = A3aq16 if A3aq15 == 4
replace qtyferttotal4 = a3bq16 if qtyferttotal4 == . & a3bq15 == 4
gen unitfertexp4 = 1 if A3aq15 == 4 | a3bq15 == 4
gen qtyfertexp4 = A3aq18 if A3aq15 == 4
replace qtyfertexp4 = a3bq18 if qtyfertexp4 == . & a3bq15 == 4
gen valfertexp4 = A3aq19 if A3aq15 == 4
replace valfertexp4 = a3bq19 if valfertexp4 == . & a3bq15 == 4
gen qtyfertimp4 = qtyferttotal4 - qtyfertexp4


********** Organic Fertilizer ********** 

// Organic fertilizer for two seasons
gen usefertexp5 = 1 if A3aq5 != . | a3bq5 != .
gen qtyfertexp5 = A3aq5 if A3aq5 != .
replace qtyfertexp5 = a3bq5 if qtyfertexp5 == . & a3bq5 != .
gen unitfertexp5 = 1 if A3aq5 != . | a3bq5 != .
gen valfertexp5 = A3aq8 if A3aq5 != .
replace valfertexp5 = a3bq8 if valfertexp5 == . & a3bq5 != .

********** Labels & Grouping ********** 

gen itemcode = .
replace itemcode = 1 if usefertexp1 == 1 // Nitrate 	- n_kg
replace itemcode = 2 if usefertexp2 == 1 // Phosphate 	- p_kg
replace itemcode = 3 if usefertexp3 == 1 // Potash		- k_kg
replace itemcode = 4 if usefertexp4 == 1 // Mixed
replace itemcode = 5 if usefertexp5 == 1 // Organic

label define itemcodefert 1 "Nitrate" 2 "Phosphate" 3 "Potash" 4 "Mixed" 5 "Organic"
label values itemcode itemcodefert

keep use* qty* unit* val* HHID parcel_id plot_id season
unab vars : *1
local stubs : subinstr local vars "1" "", all
display "`stubs'"
reshape long `stubs', i(HHID parcel_id plot_id season) j(itemcode)

unab vars2 : *exp*
local stubs2 : subinstr local vars2 "exp" "", all
display "`stubs2'"
reshape long `stubs2', i(HHID parcel_id plot_id season itemcode) j(exp) string 

reshape long use qty unit val, i(HHID parcel_id plot_id season itemcode exp) j(input) string
collapse (sum) qty* val*, by(HHID parcel_id plot_id season exp itemcode use)

gen input = ""
replace input = "inorg" if  itemcode>=1 & itemcode<=4 
replace input = "orgfert" if itemcode == 5 
/*
label define inputgroup 1 "inorg" 2 "orgfert" 
*label define inputgroup "inorg" = 1 "orgfert" = 2
*replace input = "inorg" if itemcode <= 4
*replace input = "orgfert" if itemcode == 5
replace input = 1 if itemcode <= 4 
replace input = 2 if itemcode == 5 
label values input inputgroup 


********** Clean-Up Data **********
drop if missing(itemcode)
drop if missing(exp)
drop if missing(input)
*duplicates drop HHID parcel_id plot_id season itemcode, force
recode qty (. = 0)
recode val (. = 0)
collapse (sum) qty val, by(HHID parcel_id plot_id season itemcode exp input)
*/

duplicates drop HHID parcel_id plot_id season itemcode, force
tempfile phys_inputs
save `phys_inputs'
*restore



/* older code fore fertiizers
*SAW Using Josh Code as reference which uses Nigeria W3 Code.
use "${Uganda_NPS_W1_raw_data}/2009_AGSEC3A", clear 
rename Hhid HHID
gen season = 1
rename A3aq1 a3bq1
rename A3aq3 a3bq3
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC3B"
replace season = 2 if season == .
rename a3bq1 parcel_id 
rename a3bq3 plot_id 

************************    INORGANIC FERTILIZER   ****************************** 
ren A3aq15 itemcodefert //what type of inorganic fertilizer (1 = nitrate, 2 = phosphate, 3 = potash, 4 = mixed); this can be used for purchased and non-purchased amounts
replace itemcodefert = a3bq15 if itemcodefert == . //add second season
ren A3aq16 qtyferttotal1 //quantity of inorganic fertilizer used; thankfully, only measured in kgs
replace qtyferttotal1 = a3bq16 if qtyferttotal1 == . //add second season
ren A3aq18 qtyfertexp1 //quantity of purchased inorganic fertilizer used; only measured in kgs
replace qtyfertexp1 = a3bq18 if qtyfertexp1 == . //add second season
ren A3aq19 valfertexp1 //value of purchased inorganic fertilizer used, not all fertilizer
replace valfertexp1 = a3bq19 if valfertexp1 == . //add second season
gen qtyfertimp1 = qtyferttotal1 - qtyfertexp1

*************************    ORGANIC FERTILIZER   *******************************
ren A3aq5 qtyferttotal2 //quantity of organic fertilizer used; only measured in kg
replace qtyferttotal2 = a3bq5 if qtyferttotal2 == . //add second season
ren A3aq7 qtyfertexp2 //quantity of purchased organic fertilizer used; only measured in kg
replace qtyfertexp2 = a3bq7 if qtyfertexp2 == . //add second season
replace itemcodefert = 5 if qtyferttotal2 != . //Current codes are 1-4; we'll add 5 as a temporary label for organic
label define fertcode 1 "Nitrate" 2 "Phosphate" 3 "Potash" 4 "Mixed" 5 "Organic" , modify //need to add new codes to the value label, fertcode
label values itemcodefert fertcode //apply organic label to itemcodefert
ren A3aq8 valfertexp2 //value of purchased organic fertilizer, not all fertilizer
replace valfertexp2 = a3bq8 if valfertexp2 == . //add second season 
gen qtyfertimp2 = qtyferttotal2 - qtyfertexp2
tostring HHID, format(%18.0f) replace

//Clean-up data
keep item* qty* val* HHID parcel_id plot_id season
drop if itemcodefert == .
gen dummya = 1
gen dummyb = sum(dummya) //dummy id for duplicates
drop dummya
duplicates drop HHID parcel_id plot_id season, force // we need to  drop 3 duplicates so reshape can run
unab vars : *2 
local stubs : subinstr local vars "2" "", all
reshape long `stubs', i(HHID parcel_id plot_id season) j(entry_no) string 
drop entry_no
drop if (qtyferttotal == . & qtyfertexp == .)
unab vars2 : *exp
local stubs2 : subinstr local vars2 "exp" "", all
gen dummyc = sum(dummyb) //This process of creating dummies and summing them was done to create individual IDs for each row (can just use _n command, but we weren't aware at the time)
drop dummyb
reshape long `stubs2', i(HHID parcel_id plot_id season dummyc) j(exp) string
gen dummyd = sum(dummyc)
drop dummyc
reshape long qty val itemcode, i(HHID parcel_id plot_id season exp dummyd) j(input) string
recode qty val (. = 0)
collapse (sum) qty* val*, by(HHID parcel_id plot_id season exp input itemcode)
tempfile phys_inputs
save `phys_inputs'
*/
********************************************************************************
***************************    LAND RENTALS   **********************************

//Get parcel rent data
use "${Uganda_NPS_W1_raw_data}/2009_AGSEC2B", clear 
ren A2bq2 parcel_id
ren A2bq9 valparcelrentexp //rent paid for PARCELS (not plots) for BOTH cropping seasons (so total rent, inclusive of both seasons, at a parcel level)
tostring Hhid, format(%18.0f) replace
rename Hhid HHID
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_rental.dta", replace

//Calculate rented parcel area (in ha)
use "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_areas.dta", replace
merge m:1 HHID parcel_id using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_rental.dta", nogen keep (3)
gen qtyparcelrentexp = parcel_ha if valparcelrentexp > 0 & valparcelrentexp != .
gen qtyparcelrentimp = parcel_ha if qtyparcelrentexp == . //this land does not have an agreement with owner, but is rented

//Estimate rented plot value, using percentage of parcel 
gen plot_percent = field_size / parcel_ha
gen valplotrentexp = plot_percent * valparcelrentexp
gen qtyplotrentexp = qtyparcelrentexp * plot_percent
gen qtyplotrentimp = qtyparcelrentimp * plot_percent //quantity of "imp" land is that which is not rented

//Clean-up data
keep HHID parcel_id plot_id season valparcelrent* qtyparcelrent* valplotrent* qtyplotrent* 

	preserve //this section creates a variable, duplicate, which can tell if a plot was rented over two seasons. This way, rent is disaggregated by plot and by season.
	collapse (sum) plot_id, by(HHID parcel_id season)
	duplicates tag HHID parcel_id, generate(duplicate) 
	drop plot_id
	collapse (max) duplicate, by(HHID parcel_id)
	tempfile parcel_rent
	save `parcel_rent'
	restore

merge m:1 HHID parcel_id using `parcel_rent', nogen 
sort HHID parcel_id plot_id
*by hhid parcel_id plot_id : egen dumseason = total(season) if duplicate == 1
reshape long valparcelrent qtyparcelrent valplotrent qtyplotrent, i(HHID parcel_id plot_id season) j(exp) string
reshape long val qty, i(HHID parcel_id plot_id season exp) j(input) string
gen valseason = val / 2 if duplicate == 1
drop duplicate
gen unit = 1 //dummy var
gen itemcode = 1 //dummy var
tempfile plotrents
save `plotrents'


******************************    SEEDS   **************************************
//Clean up raw data and generate initial estimates	
use "${Uganda_NPS_W1_raw_data}/2009_AGSEC4A", clear 
gen season=1
rename A4aq2 A4bq2 
rename A4aq4 A4bq4 
ren A4aq6 A4bq6
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC4B"
replace season = 2 if season == .
ren A4bq2 plot_id
ren A4bq4 parcel_id
ren A4bq6 crop_code
drop if crop_code==.
ren A4aq8 purestand 
replace purestand = A4bq8 if purestand==.
ren Hhid HHID
ren A4aq11	valseeds //only value for purchased seeds. There is no quantity for purchased seeds
replace valseeds = A4bq11 if valseeds == . //add second season


keep val* purestand HHID parcel_id plot_id crop_code season //unit* qty*
gen dummya = 1
gen dummyb = sum(dummya) //dummy id for duplicates, similar process as above for fertilizers
drop dummya
reshape long val, i(HHID parcel_id plot_id season dummyb) j(input) string //qty unit
collapse (sum) val , by(HHID parcel_id plot_id season input crop_code purestand) //qty unit


ren crop_code itemcode
collapse (sum) val , by(HHID parcel_id plot_id season input itemcode ) // dropped qty
gen exp = "exp"
tostring HHID, format(%18.0f) replace

//Combining and getting prices.
append using `plotrents'
append using `plot_inputs'
append using `phys_inputs'
merge m:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_weights.dta", nogen keep(1 3) keepusing(weight)
merge m:1 HHID parcel_id plot_id season using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_areas.dta", nogen keep(1 3) keepusing(field_size)
merge m:1 HHID parcel_id using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
drop region ea district county subcounty parish weight rural //regurb not in data 
merge m:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hhids.dta", nogen keep(1 3) //merge in regional data (districts, etc.)

//Need this for quantities and not sure where it should go.
preserve 
keep if strmatch(input,"orgfert") | strmatch(input,"inorg") | strmatch(input,"pest") //would also have herbicide here if Uganda tracked herbicide separately of pesticides

		gen n_kg =qty*itemcode==1
		gen p_kg = qty*itemcode==2
		gen k_kg = qty*itemcode==3
		gen pest_kg = qty*strmatch(input, "pest")
		gen inorg_fert_kg = qty*strmatch(input, "inorg")
		gen org_fert_kg = qty if itemcode >=5 & itemcode!=.
		collapse (sum) qty *kg, by(HHID parcel_id plot_id season input)
		*reshape wide *kg, i(HHID parcel_id plot_id season) j(input) string
		 //collapse (max) use_irrigation (sum) *kg, by(hhid holder_id parcel_id field_id)
		la var inorg_fert_kg "Kg inorganic fertilizer used"
		la var org_fert_kg "Kg organic fertilizer used"
		la var n_kg "Kg of nitrogen applied"
		la var p_kg "Kg of phosphorus applied"
		la var k_kg "Kg of potassium applied"		

save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_input_quantities.dta", replace
restore


tempfile all_plot_inputs
save `all_plot_inputs' //Woo, now we can estimate values.

//Calculating geographic medians
keep if strmatch(exp,"exp") & qty != . //Keep only explicit prices with actual values for quantity
recode val (0 = .)
*drop if unit == 0 //Remove things with unknown units.
gen price = val/qty
drop if price == . //6,246 observations now remaining
gen obs = 1
gen plotweight = weight*field_size

//3 missing values 

*drop rural plotweight parish subcounty district
foreach i in region district county subcounty parish ea HHID {
preserve
	bys `i' input unit itemcode : egen obs_`i' = sum(obs)
	collapse (median) price_`i' = price [aw = plotweight], by (`i' input unit itemcode obs_`i')
	tempfile price_`i'_median
	save `price_`i'_median'
restore
} //this loop generates a temporary file for prices at the different geographic levels specified in the first line of the loop (region, district, etc.)

preserve
bysort input  itemcode : egen obs_country = sum(obs) //unit
collapse (median) price_country = price [aw = plotweight], by(input  itemcode obs_country) //unit
tempfile price_country_median
save `price_country_median'
restore

//Combine all price information into one variable, using household level prices where available in enough quantities but replacing with the medians from larger and larger geographic areas to fill in gaps, up to the national level
use `all_plot_inputs', clear //AR: 61 not matched - no HHIDs! Is that a problem? 

merge m:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hhids.dta", nogen keep(1 3) //merge in regional data (districts, etc.) 
drop if HHID==" "
*drop strataid clusterid rural pweight parish_code scounty_code district_name
foreach i in region district county subcounty parish ea HHID {
	merge m:1 `i' input unit itemcode using `price_`i'_median', nogen keep(1 3) 
}
	merge m:1 input  itemcode using `price_country_median', nogen keep(1 3) //unit
	recode price_HHID (. = 0)
	gen price = price_HHID
foreach i in country region district county subcounty parish ea {
	replace price = price_`i' if obs_`i' > 9 & obs_`i' != .
}

replace price = price_HHID if price_HHID > 0
replace qty = 0 if qty < 0 //2 households reporting negative quantities
recode val qty (. = 0)
drop if val == 0 & qty == 0 //Dropping unnecessary observations.
replace val = qty*price if val == 0 //11,258 estimates created
replace input = "orgfert" if itemcode == 5
replace input = "inorg" if strmatch(input,"fert")


/*
preserve 
keep if strmatch(input,"orgfert") | strmatch(input,"inorg") | strmatch(input,"pest") //would also have herbicide here if Uganda tracked herbicide separately of pesticides
collapse (sum) qty_ = qty, by(HHID parcel_id plot_id season input)
reshape wide qty_, i(HHID parcel_id plot_id season) j(input) string
ren qty_inorg inorg_fert_rate
ren qty_orgfert org_fert_rate
ren qty_pest pest_rate
la var inorg_fert_rate "Qty inorganic fertilizer used (kg)"
la var org_fert_rate "Qty organic fertilizer used (kg)"
la var pest_rate "Qty of pesticide used (kg)"
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_input_quantities.dta", replace
restore
*/


append using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_labor.dta"
collapse (sum) val, by (HHID parcel_id plot_id season exp input dm_gender)
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_cost_inputs_long.dta", replace

preserve
collapse (sum) val, by(HHID exp input) //JHG 7_5_22: includes both seasons, is that okay?
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hh_cost_inputs_long.dta", replace
restore
preserve
collapse (sum) val_ = val, by(HHID parcel_id plot_id season exp dm_gender)
reshape wide val_, i(HHID parcel_id plot_id season dm_gender) j(exp) string
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_cost_inputs.dta", replace //This gets used below.
restore


ren val val_ 
reshape wide val_, i(HHID parcel_id plot_id season exp dm_gender) j(input) string
ren val* val*_
reshape wide val*, i(HHID parcel_id plot_id season dm_gender) j(exp) string //Ahana's note - the exp==total does not have gender so those values would be unknown
gen dm_gender2 = "male" if dm_gender == 1
replace dm_gender2 = "female" if dm_gender == 2
replace dm_gender2 = "mixed" if dm_gender == 3
replace dm_gender2 = "unknown" if dm_gender == . 
drop dm_gender
ren val* val*_
reshape wide val*, i(HHID parcel_id plot_id season) j(dm_gender2) string
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_cost_inputs_wide.dta", replace //Used for monocropped plots, this is important for that section
collapse (sum) val*, by(HHID)

unab vars3 : *_exp_male //just get stubs from one
local stubs3 : subinstr local vars3 "_exp_male" "", all
foreach i in `stubs3' {
	egen `i'_exp_hh = rowtotal(`i'_exp_male `i'_exp_female `i'_exp_mixed)
	egen `i'_imp_hh=rowtotal(`i'_exp_hh `i'_imp_male `i'_imp_female `i'_imp_mixed)
}

egen val_exp_hh = rowtotal(*_exp_hh)
egen val_imp_hh = rowtotal(*_imp_hh)
drop val_mech_imp* // AR: Don't have machinery input data 
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hh_cost_inputs_verbose.dta", replace 


//Create area planted tempfile for use at the end of the crop expenses section
use "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_all_plots.dta", replace 
collapse (sum) ha_planted, by(HHID parcel_id plot_id season)
tempfile planted_area
save `planted_area' 

//We can do this (JHG 7_5_22: what is "this"?) more simply by:
use "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_cost_inputs_long.dta", clear
//back to wide
drop input
collapse (sum) val, by(HHID parcel_id plot_id season exp dm_gender)
gen dm_gender2 = "male" if dm_gender == 1
replace dm_gender2 = "female" if dm_gender == 2
replace dm_gender2 = "mixed" if dm_gender == 3
replace dm_gender2 = "unknown" if dm_gender == . 
drop dm_gender
ren val* val*_
reshape wide val*, i(HHID parcel_id plot_id season dm_gender2) j(exp) string
ren val* val*_
*destring HHID, replace
merge m:1 HHID parcel_id plot_id season using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_areas.dta", nogen keep(1 3) keepusing(field_size) //do per-ha expenses at the same time
*tostring HHID, format(%18.0f) replace
merge m:1 HHID parcel_id plot_id season using `planted_area', nogen keep(1 3)
reshape wide val*, i(HHID parcel_id plot_id season) j(dm_gender2) string
collapse (sum) val* field_size* ha_planted*, by(HHID) 
foreach i in male female mixed {
gen cost_expli_`i' = val_exp_`i'
egen cost_total_`i' = rowtotal(val_exp_`i' val_imp_`i')
}
egen cost_expli_hh = rowtotal(val_exp*)
egen cost_total_hh = rowtotal(val*)
drop val*
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hh_cost_inputs.dta", replace 

************************************************************************
********************************************************************************
** 								MONOCROPPED PLOTS							  **
********************************************************************************
//Setting things up for AgQuery first

use "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_all_plots.dta", replace
//temp kludge - replace if there is a better solution - ALT 01.17.24
recode crop_code (811 812 = 810) (741 742 744 = 740) (224 = 223) //740 is bananas, which is being reduced from different types to just bananas. Same for peas (220).bys HHID plot_id parcel_id season : egen avg_crop_code = mean(crop_code)
*replace purestand = 1 if avg_crop_code == crop_code
keep if purestand == 1 //1 = monocropped // 
collapse (sum) ha_planted percent_field quant_harv_kg value_harvest percent_inputs, by(HHID parcel_id plot_id season region district county  parish ea dm_gender field_size crop_code)
*assert ha_planted <= field_size
duplicates report HHID plot_id parcel_id season crop_code

collapse (sum) ha_planted percent_field quant_harv_kg value_harvest percent_inputs, by(HHID parcel_id plot_id season region district county  parish ea dm_gender field_size crop_code) //  subcounty not in dataset 
*assert ha_planted <= field_size
duplicates report HHID plot_id parcel_id season crop_code


use "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_all_plots.dta", replace
keep if purestand == 1 //1 = monocropped // Ahana: 6170 obersvations missing

*ren crop_code_master cropcode
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_monocrop_plots.dta", replace

use "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_all_plots.dta", replace

keep if purestand == 1 //1 = monocropped //File now has 12123 obersvations

*merge 1:1 HHID parcel_id plot_id season using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)

merge m:1 HHID parcel_id using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
ren crop_code cropcode
ren ha_planted monocrop_ha

ren quant_harv_kg kgs_harv_mono // SAW: We use Kilogram harvested using standard units table (across all waves) and price per kg methodology
ren value_harvest val_harv_mono // SAW: We use Kilogram harvested using standard units table (across all waves) and price per kg methodology

*This loop creates 17 values using the nb_topcrops global (as that is the number of priority crops), then generates two .dtas for each priority crop that contains household level variables (split by season). You can change which priority crops it uses by adjusting the priority crops global section near the top of this code.

forvalues k = 1(1)$nb_topcrops  {		
preserve	
local c : word `k' of $topcrop_area
local cn : word `k' of $topcropname_area
local cn_full : word `k' of $topcropname_area_full

di "Processing `cn_full', cropcode is `c' and name is `cn'"

keep if cropcode == `c'			
ren monocrop_ha `cn'_monocrop_ha
drop if `cn'_monocrop_ha==0 | `cn'_monocrop_ha==. 		
ren kgs_harv_mono kgs_harv_mono_`cn'
ren val_harv_mono val_harv_mono_`cn'
gen `cn'_monocrop = 1
la var `cn'_monocrop "HH grows `cn_full' on a monocropped plot"
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_`cn'_monocrop.dta", replace
	
foreach i in `cn'_monocrop_ha kgs_harv_mono_`cn' val_harv_mono_`cn' { 
gen `i'_male = `i' if dm_gender == 1
gen `i'_female = `i' if dm_gender == 2
gen `i'_mixed = `i' if dm_gender == 3
}
	
la var `cn'_monocrop_ha "Total `cn' monocrop hectares - Household"
la var `cn'_monocrop "Household has at least one `cn' monocrop"
la var kgs_harv_mono_`cn' "Total kilograms of `cn' harvested - Household"
la var val_harv_mono_`cn' "Value of harvested `cn' (UGAH)"
foreach g in male female mixed {		
la var `cn'_monocrop_ha_`g' "Total `cn' monocrop hectares on `g' managed plots - Household"
la var kgs_harv_mono_`cn'_`g' "Total kilograms of `cn' harvested on `g' managed plots - Household"
la var val_harv_mono_`cn'_`g' "Total value of `cn' harvested on `g' managed plots - Household"
}
collapse (sum) *monocrop* kgs_harv* val_harv*, by(HHID /*season*/)
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_`cn'_monocrop_hh_area.dta", replace
restore
}


use "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_cost_inputs_long.dta", clear
foreach cn in $topcropname_area {
preserve
	keep if strmatch(exp, "exp")
	drop exp
	levelsof input, clean l(input_names)
	ren val val_
	reshape wide val_, i(HHID parcel_id plot_id dm_gender season) j(input) string
	ren val* val*_`cn'_
	gen dm_gender2 = "male" if dm_gender==1
	replace dm_gender2 = "female" if dm_gender==2
	replace dm_gender2 = "mixed" if dm_gender==3
	drop dm_gender
	drop if dm_gender2 =="" // 
	reshape wide val*, i(HHID parcel_id plot_id season) j(dm_gender2) string
	merge 1:1 HHID parcel_id plot_id season using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_`cn'_monocrop.dta", nogen keep(3)
	collapse (sum) val*, by(HHID)
	foreach i in `input_names' {
		egen val_`i'_`cn'_hh = rowtotal(val_`i'_`cn'_male val_`i'_`cn'_female val_`i'_`cn'_mixed)
	}

save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_inputs_`cn'.dta", replace
restore
}
*Notes: Final datasets are sum of all cost at the household level for specific crops.

***************************************1*****************************************
**                     TLU (TROPICAL LIVESTOCK UNITS)       				  **
********************************************************************************
/*
Purpose: 
1. Generate coefficients to convert different types of farm animals into the standardized "tropical livestock unit," which is usually based around the weight of an animal (kg of meat) 

2. Generate variables whether a household owns certain types of farm animals, both currently and over the past 12 months, and how many they own. Separate into pre-specified categories such as cattle, poultry, etc. Convert into TLUs

3. Grab information on livestock sold alive and calculate total value.
*/
***************************    TLU COEFFICENTS   *******************************
//Step 1: Create three TLU coefficient .dta files for later use, stripped of HHIDs

*For livestock
use "${Uganda_NPS_W1_raw_data}/2009_AGSEC6A", clear 
rename A6aq3 livestockid
gen tlu_coefficient = 0.5 if (livestockid == 1 | livestockid == 2 | livestockid == 3 | livestockid == 4 | livestockid == 5 | livestockid == 6 | livestockid == 7 | livestockid == 8) // This includes calves, bulls, oxen, heifer, cows, and horses (exotic/cross and indigenous)
replace tlu_coefficient = 0.3 if A6aq2 == "Mules / Horses" //Includes indigenous donkeys and mules
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep livestockid tlu_coefficient
duplicates drop
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_tlu_livestock.dta", replace

*for small animals
use "${Uganda_NPS_W1_raw_data}/2009_AGSEC6B", clear 
destring A6bq3, replace
rename A6bq3 livestockid  // id was string converted to numeric
gen tlu_coefficient = 0.1 if (livestockid == 13 | livestockid == 14 | livestockid == 15 | livestockid == 16 | livestockid == 18 | livestockid == 19 | livestockid == 20) // This includes goats and sheeps (indigenous, exotic/cross, male, and female)
replace tlu_coefficient = 0.2 if (livestockid == 21) //This includes pigs (indigenous and exotic/cross)
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep livestockid tlu_coefficient
duplicates drop
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_tlu_small_animals.dta", replace

*For poultry and misc.
use "${Uganda_NPS_W1_raw_data}/2009_AGSEC6C", clear 
rename A6cq3 livestockid
destring livestockid, replace // id was string converted to numeric 
gen tlu_coefficient = 0.01 if (livestockid == 32 | livestockid == 36 | livestockid == 39 | livestockid == 40 | livestockid == 41 | livestockid == 31 | livestockid == 38 | livestockid == 33| livestockid == 34| livestockid == 35 |livestockid==31 ) // This includes chicken (all kinds), turkey, ducks, geese, and rabbits
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep livestockid tlu_coefficient
duplicates drop
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_tlu_poultry_misc.dta", replace

*Combine 3 TLU .dtas into a single .dta
use "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_tlu_livestock.dta", clear
append using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_tlu_small_animals.dta"
append using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_tlu_poultry_misc.dta"

*Indigenous/Exotic/Cross not mentioned for sheep/goats and pigs
label def livestockid 1 "Exotic/cross - Calves" 2 "Exotic/cross - Bulls" 3 "Exotic/cross - Oxen" 4 "Exotic/cross - Heifer" 5 "Exotic/cross - Cows" 6 "Indigenous - Calves" 7 "Indigenous - Bulls" 8 "Indigenous - Oxen" 13 "Male Goats" 14 "Female Goats" 15 "Male Sheep" 16 "Exotic/Cross - Female Sheep" 17 "Exotic/Cross - Male Goats" 18 "Female Goats" 19 "Male Goats" 20 "Female Sheep" 21 "Pigs" 31 "Rabbits" 32 "Backyard Chicken" 33 "Parent stock" 34 "Parent Stock" 35 "Layers" 36 "Pullet Chicken" 37 "Growers" 38 "Broilers" 39 "Turkeys" 40 "Ducks" 41 "Geese and other animals"
label val livestockid livestockid 
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_tlu_all_animals.dta", replace 
*************************************************************************
**********************    HOUSEHOLD LIVESTOCK OWNERSHIP   ***********************
//Step 2: Generate ownership variables per household

*Combine HHID and livestock data into a single sheet
use "${Uganda_NPS_W1_raw_data}/2009_AGSEC6A", clear 
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC6B" 
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC6C"
gen livestockid = A6aq3
destring A6bq3, replace 
destring A6cq3, replace 
replace livestockid=A6bq3 if livestockid==.
replace  livestockid=A6cq3 if livestockid==.
merge m:m livestockid using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_tlu_all_animals.dta", nogen
label val livestockid livestockid //have to reassign labels to values after creating new variable
label var livestockid "Livestock Species ID Number"
sort Hhid livestockid //Put back in order

*Generate ownership dummy variables for livestock categories: cattle (& cows alone), small ruminants, poultry (& chickens alone), & other
gen cattle = inrange(livestockid, 1, 8) //calves, bulls, oxen, heifer, and cows
gen cows = inlist(livestockid, 5, 8) //just cows
gen smallrum = inlist(livestockid, 13, 14, 15, 16, 17, 18, 19, 20, 21, 31) //goats, sheep, pigs, and rabbits
gen poultry = inrange(livestockid, 31, 41) //chicken, turkey, ducks, and geese
gen chickens = inrange(livestockid, 32, 38) //just chicken (all kinds)
gen otherlivestock = inlist(livestockid, 8) //donkeys/mules and horses

*Generate "number of animals" variable per livestock category and household (Time of Survey)
rename A6aq4 ls_ownership_now
drop if ls_ownership == 2 //2 = do not own this animal anytime within the past 12 months (eliminates non-owners for all relevant time periods)
rename A6bq4 sa_ownership_now
drop if sa_ownership == 2 //2 = see above
rename A6cq4 po_ownership_now
drop if po_ownership == 2 //2 = see above

rename A6aq5 ls_number_now
rename A6bq5 sa_number_now
rename A6cq5 po_number_now 
gen livestock_number_now = ls_number_now
replace livestock_number_now = sa_number_now if livestock_number_now == .
replace livestock_number_now = po_number_now if livestock_number_now == .
lab var livestock_number_now "Number of animals owned at time of survey (see livestockid for type)"

gen nb_cattle_today = livestock_number_now if cattle == 1
gen nb_cows_today = livestock_number_now if cows == 1
gen nb_smallrum_today = livestock_number_now if smallrum == 1
gen nb_poultry_today = livestock_number_now if poultry == 1
gen nb_chickens_today = livestock_number_now if chickens == 1
gen nb_other_today = livestock_number_now if otherlivestock == 1
gen nb_tlu_today = livestock_number_now * tlu_coefficient

*Generate "number of animals" variable per livestock category and household (12 Months Before Survey)
rename A6aq7 ls_number_past
rename A6bq7 sa_number_past
rename A6cq7 po_number_past
gen livestock_number_past = ls_number_past
replace livestock_number_past = sa_number_past if livestock_number_past == .
replace livestock_number_past = po_number_past if livestock_number_past == .
lab var livestock_number_past "Number of animals owned 12 months before survey (see livestockid for type)" 
*SAW 7.5.22 Though, a6Xq6 refers to different types of animals the time of ownership asked in each question is different (12 months for livestock, 6 months for small animals, and 3 motnhs for poultry)

gen num_cattle_past = livestock_number_past if cattle == 1
gen num_cows_past = livestock_number_past if cows == 1
gen num_smallrum_past = livestock_number_past if smallrum == 1
gen num_poultry_past = livestock_number_past if poultry == 1
gen num_chickens_past = livestock_number_past if chickens == 1
gen num_other_past = livestock_number_past if otherlivestock == 1
gen num_tlu_past = livestock_number_past * tlu_coefficient

//Step 3: Generate animal sales variables (sold alive)
rename A6aq15 ls_avgvalue
rename A6bq15 sa_avgvalue
rename A6cq15 po_avgvalue
rename A6aq14 num_ls_sold
rename A6bq14 num_sa_sold
rename A6cq14 num_po_sold

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

recode num_* nb_* (. = 0) //replace all null values for number variables with 0

//Step 4: Aggregate to household level. Clean up and save data
collapse (sum) num* nb*, by (Hhid)
lab var num_ls_sold "Number of animals sold alive (livestock)"
lab var num_sa_sold "Number of animals sold alive (small animals)"
lab var num_po_sold "Number of animals sold alive (poultry)"
lab var num_totalvalue "Total value of animals sold alive"
lab var nb_cattle_today "Number of cattle owned as of the time of survey"
lab var nb_smallrum_today "Number of small ruminants owned as of the time of survey"
lab var nb_poultry_today "Number of poultry owned as of the time of survey"
lab var nb_other_today "Number of other livestock (donkey, horse/mule, pigs, and rabbits) owned as of the time of survey"
lab var nb_cows_today "Number of cows owned as of the time of survey"
lab var nb_chickens_today "Number of chickens owned as of the time of survey"
lab var nb_tlu_today "Number of Tropical Livestock Units at time of survey"
lab var num_cattle_past "Number of cattle owned 12 months before survey"
lab var num_cows_past "Number of cows owned 12 months before survey"
lab var num_smallrum_past "Number of small ruminants owned 12 months before survey"
lab var num_poultry_past "Number of poultry owned 12 months before survey"
lab var num_chickens_past "Number of chickens owned 12 months before survey"  
lab var num_other_past "Number of other livestock (donkeys/mules & horses) owned 12 months before survey"
lab var num_tlu_past "Number of Tropical Livestock Units 12 months before survey"
tostring Hhid, format(%18.0f) replace
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_TLU_Coefficients.dta", replace


********************************************************************************
**                           LIVESTOCK INCOME       		         		  **
********************************************************************************
* Nigeria Wave 3 as reference to write this section. 
use "${Uganda_NPS_W1_raw_data}/2009_AGSEC7.dta", clear
* Place livestock costs into categories
generate cost_hired_labor_livestock	= A7q4 	if A7q2 == 1
generate cost_fodder_livestock		= A7q4	if A7q2 == 2
generate cost_vaccines_livestock	= A7q4	if A7q2 == 3
generate cost_other_livestock		= A7q4	if A7q2 == 4
* AR: Why are we looking at water cost? 
generate cost_water_livestock		= 0

recode cost_* (.=0)
preserve
	* Species is not captured for livestock costs, and so this disaggregation is impossible. Created for conformity with other waves
	gen cost_lrum = .
	keep Hhid cost_lrum
	label variable cost_lrum "Livestock expenses for large ruminants"
	save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_lrum_expenses.dta", replace
restore

* Collapse Livestock costs to the household level
rename Hhid HHID
collapse (sum) cost_*, by(HHID)

label variable cost_water_livestock			"Cost for water for livestock"
label variable cost_fodder_livestock 		"Cost for fodder for livestock"
label variable cost_vaccines_livestock 		/*
	*/ "Cost for vaccines and veterinary treatment for livestock"
label variable cost_hired_labor_livestock	"Cost for hired labor for livestock"

* Save to disk
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_livestock_expenses.dta", /*
	*/ replace

*****************************    LIVESTOCK PRODUCTS        *******************************
*1. Milk
use "${Uganda_NPS_W1_raw_data}/2009_AGSEC8.dta", clear
rename A8q2 livestock_code
*CPK: dropping anything that is not milk, ghee or eggs
keep if inlist(livestock_code,1,2,3,4,5)
ren A8q4 prod_permonth
drop if prod_permonth==. //2042 obs deleted
ren A8q5 unit_prod
ren A8q3 prod_months
gen qty_produced = prod_months*prod_permonth
* Trays of eggs to numbers of eggs
replace qty_produced 	= qty_produced * 30 if livestock_code == 5 & unit_prod == 3
*kg of ghee to liters
replace qty_produced 	= qty_produced /.91 if livestock_code == 4 & unit_prod == 1
lab var qty_produced "Production in past 12 months"
ren A8q6 qty_sold 
*AR: Why are these being changed? 
replace unit			= 4 				  if livestock_code == 5 & unit_prod == 3
replace unit			= 2 				  if livestock_code == 4 & unit_prod == 1
gen earnings_sales = A8q7*prod_months 
lab var earnings_sales "Earnings in past 12 months"
drop A8q7
gen price_kg = earnings_sales/qty_sold
rename Hhid HHID
tostring HHID, format(%18.0f) replace
drop if prod_months==0
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hh_livestock_products.dta", replace

******************
* Price Imputation * 
********************
use "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hh_livestock_products.dta", clear
merge m:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_weights.dta", keep(1 3) nogen
collapse (median) price_kg [aw=weight], by (livestock_code)
ren price_kg price_kg_median_country
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_livestock_products_prices_country.dta", replace

* Livestock Products * 
********************
use "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hh_livestock_products.dta", clear
merge m:1 livestock_code using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_livestock_products_prices_country.dta", nogen keep(1 3)
keep if qty_produced !=0

gen value_produced = price_kg * qty_produced 
replace value_produced = price_kg_median_country * qty_produced if value_produced==.
replace value_produced = earnings_sales if value_produced==. //0 changes 
lab var price_kg "Price per liter kgs or egg using local median prices if household did not sell"

gen value_milk_produced = value_produced if livestock_code==1 |livestock_code==2|livestock_code==3
gen value_eggs_produced = value_produced if livestock_code==5
gen value_ghee_produced = value_produced if livestock_code==4

*Share of total production sold
gen sales_livestock_products = earnings_sales	
gen sales_milk = earnings_sales if livestock_code==1 |livestock_code==2|livestock_code==3
gen sales_eggs = earnings_sales if livestock_code==5
gen sales_ghee = earnings_sales if livestock_code==4
collapse (sum) value_milk_produced value_eggs_produced value_ghee_produced sales_livestock_products /*agquery*/ sales_milk sales_eggs sales_ghee, by (HHID)

*Share of production sold
*First, constructing total value
egen value_livestock_products = rowtotal(value_milk_produced value_eggs_produced value_ghee_produced)
*Now, the share
gen share_livestock_prod_sold = sales_livestock_products/value_livestock_products
replace share_livestock_prod_sold = 1 if share_livestock_prod_sold>1 & share_livestock_prod_sold!=.
lab var share_livestock_prod_sold "Percent of livestock products that is sold" 
/*AgQuery 12.01*/
gen prop_dairy_sold = sales_milk / value_milk_produced
gen prop_eggs_sold = sales_eggs / value_eggs_produced
**
lab var value_milk_produced "Value of milk produced"
lab var value_eggs_produced "Value of eggs produced"
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_livestock_products.dta", replace

****************************************************************************
*LIVESTOCK SOLD (LIVE)*  
***************************************************************************
*look at individual created data for this
use "${Uganda_NPS_W1_raw_data}/2009_AGSEC6A.dta", clear
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC6B"
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC6C"

* Rename key variables for consistency across instruments
rename A6aq3 livestock_code
destring A6bq3, replace
lab define A6bq3 13 "Male goats" 
replace livestock_code = A6bq3	if missing(livestock_code)
destring A6cq3, replace
replace livestock_code = A6cq3	if missing(livestock_code)
drop if missing(livestock_code) //only 5

ren A6aq4 animal_owned
replace animal_owned=A6bq4 if animal_owned==.
replace animal_owned=A6cq4 if animal_owned==.
keep if animal_owned==1

* Combine value labels for livestock_codes from the three files
* From Small Animals (Goat, sheep, pigs)
levelsof A6bq3, local(levs)
foreach v of local levs {
	label define A6aq3 `v' "`: label (A6bq3) `v''", add
}

* From Poultry/Rabbits/etc.
levelsof A6cq3, local(levs)
foreach v of local levs {
	label define A6cq3 `v' "`: label (A6cq3) `v''", add
}

* Combine number sold from three different files 

gen number_sold 			= A6aq14
replace number_sold			= A6bq14 * 2	if missing(number_sold)
replace number_sold			= A6cq14 * 4	if missing(number_sold)

* Combine income live sales from the three different files
gen income_live_sales		= A6aq15
replace income_live_sales	= A6bq15 * 2	if missing(income_live_sales)
replace income_live_sales	= A6cq15 * 4	if missing(income_live_sales)

* Combine number slaughtered from the three different files.
gen number_slaughtered		= A6aq16
replace number_slaughtered	= A6bq16 * 2 if missing(number_slaughtered)
replace number_slaughtered	= A6cq16 * 4	if missing(number_slaughtered)

* Combine value of livestock purchases from the three different files
gen value_livestock_purchases		= A6aq13
replace value_livestock_purchases	= A6bq13 * 2 /*
		*/ if missing(value_livestock_purchases)
replace value_livestock_purchases	= A6cq13 * 4 /*
		*/ if missing(value_livestock_purchases)

* Calculate the price per animal sold has many outliers - and high standard deviation as well 
gen price_per_animal		= income_live_sales / number_sold
lab var price_per_animal "Price of live animal sold" 
recode number_sold income_live_sales number_slaughtered value_livestock_purchases (.=0)
ren Hhid HHID
merge m:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hhids", nogen keep(1 3) 

keep HHID region rural weight district county subcounty parish ea price_per_animal number_sold income_live_sales number_slaughtered value_livestock_purchases livestock_code

* Price of livetock 
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hh_livestock_sales", replace

use "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hh_livestock_sales", clear
gen obs = 1
foreach i in region district county subcounty parish ea {
preserve
bys `i' livestock_code : egen obs_`i' =sum(obs)
collapse (median) price_median_`i'=price_per_animal [aw=weight], by(`i' obs_`i' livestock_code)
tempfile livestock_prices_`i'
save `livestock_prices_`i''
restore 
merge m:1 `i' livestock_code using `livestock_prices_`i'', nogen keep(1 3)
}

preserve
collapse (median) price_median_country=price_per_animal (sum) obs_country = obs [aw=weight], by(livestock_code) //Collapsing the obs here is unnecessary b/c we assume there will be >9 per livestock species per country; however, it makes the loop in the next block run.
tempfile livestock_prices_country
save `livestock_prices_country'
restore
merge m:1 livestock_code using `livestock_prices_country', nogen keep(1 3) 

foreach i in region district county subcounty parish ea country {
	replace price_per_animal = price_median_`i' if obs_`i' > 9 & price_per_animal==.
}

lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_lvstck_sold = price_per_animal * number_sold
gen value_slaughtered = price_per_animal * number_slaughtered
*gen value_slaughtered_sold = price_per_animal * number_slaughtered_sold 
gen value_livestock_sales = value_lvstck_sold + value_slaughtered // SAW Not sure about this, just following methodology of older UG w3 version (in this case,this inlclues the value of slaughtered animals for sales and own consumption)
collapse (sum) value_livestock_sales value_livestock_purchases value_lvstck_sold value_slaughtered /*AgQuery 12.01value_slaughtered_sold*/, by (HHID)
lab var value_livestock_sales "Value of livestock sold (live and slaughtered)"
lab var value_livestock_purchases "Value of livestock purchases (seems to span only the agricutlural season, not the year)"
lab var value_slaughtered "Value of livestock slaughtered (with slaughtered livestock that weren't sold valued at local median prices for live animal sales)"
lab var value_lvstck_sold "Value of livestock sold live" 
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_livestock_sales", replace

********************************************************************************
**           TLU  		         	         	      **
********************************************************************************
use "${Uganda_NPS_W1_raw_data}/2009_AGSEC6A", clear
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC6B"
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC6C"
ren Hhid HHID
* Rename key variables for consistency across instruments
rename A6aq3 livestock_code
destring A6bq3, replace
replace livestock_code = A6bq3	if missing(livestock_code)
destring A6cq3, replace
replace livestock_code = A6cq3	if missing(livestock_code)

* Get rid of observations missing a livestock_code
drop if missing(livestock_code) // 5 obs deleted

//Making sure value labels for 6B and 6C get carried over.
label define A6aq3 13 "Exotic/Cross - Male Goats"/*
						*/ 14 "Exotic/Cross - Female Goats"/*
						*/ 15 "Exotic/Cross - Male Sheep"/*
						*/ 16 "Exotic/Cross - Female Sheep"/*
						*/ 17 "Indigenous - Male Goats"/*
						*/ 18 "Indigenous - Female Goats"/*
						*/ 19 "Indigenous - Male Sheep"/*
						*/ 20 "Indigenous - Female Sheep"/*
						*/ 21 "Indigenous - Pigs"/*
						*/ 31 "Indigenous - Rabbits"/*
						*/ 32 "Indigenous - Backyard chicken)"/*
						*/ 33 "Indigenous - Parent stock for broilers"/*
						*/ 34 "Indigenous - Parent stock for layers"/*
						*/ 35 "Indigenous - Layers"/*
						*/ 36 "Indigenous - Pullet Chicken"/*
						*/ 37 "Indigenous - Growers"/*
						*/ 38 "Indigenous - Broilers"/*
						*/ 39 "Indigenous - Turkeys"/*
						*/ 40 "Indigenous - Ducks"/*
						*/ 41 "Indigenous - Geese and other birds"/*
						*/ 42 "Indigenous - Beehives", modify
		
label define A6aq3 7 "Equines", modify
		
* Generate the TLU Coefficient based on the animal type
*Indigenous and Exotic Cattle represented in 1-10
gen tlu_coefficient 	= 0.5 if inrange(livestock_code, 1, 10)

* Donkeys
replace tlu_coefficient = .3 if livestock_code == 7

* No Horse mule disaggregation using the average of the two tlu's
replace tlu_coefficient = .55 if livestock_code == 8

* Indigeneous and exotic goats and sheep, male and female represented in 13-20
replace tlu_coefficient = .10 if inrange(livestock_code, 13, 20)

* Pigs
replace tlu_coefficient = .20 if livestock_code == 21

* Rabbits, backyard chicken, parent stock for broilers, parent stock for layers
* layers, pullet chicks, growers, broilers, turkeys, ducks, and geese and other
* birds represented in 31-41
replace tlu_coefficient = .01 if inrange(livestock_code, 31, 41)

* Combine the number of animals from the three different subsections
* into the same variable name
gen 	number_today 			= A6aq5
replace number_today 			= A6bq5		if missing(number_today)
replace number_today			= A6cq5		if missing(number_today)

* Same for the number of animals one year ago.
gen 	number_1yearago			= A6aq7
replace number_1yearago			= A6bq7			if missing(number_1yearago)
replace number_1yearago			= A6cq7			if missing(number_1yearago)

* And animals died and lost in the last 12 months
gen 	animals_died_lost			= A6aq10
replace animals_died_lost			= A6bq10 * 2	if missing(animals_died)
replace animals_died_lost			= A6cq10 * 4	if missing(animals_died)

* And income from live sales over the last 12 months
gen 	income_live_sales		= A6aq15
replace income_live_sales		= A6bq15 * 2	if missing(income_live_sales)
replace income_live_sales		= A6cq15 * 4	if missing(income_live_sales)

* And the number sold over the last 12 months
gen 	number_sold				= A6aq14
replace number_sold				= A6bq14 * 2	if missing(number_sold)
replace number_sold				= A6cq14 * 4	if missing(number_sold)

* Calculate  the number of animals lost in the last 12 months and the mean 
* number between 1 year ago and today (at time of survey)
gen 	animals_lost12months	= animals_died_lost		
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

* Create data for the species data
local species_list "lrum srum pigs equine poultry"
local species_len : list sizeof local(species_list)
* Define labels for our species categories
label define species 	1 "Large ruminants (cows, buffalos)"	/*
					*/	2 "Small ruminants (sheep, goats)"		/*
					*/	3 "Pigs"								/*
					*/	4 "Equine (horses, donkeys)"			/*
					*/	5 "Poultry (including rabbits)"

* Break into our species rather than instrument's livestock code
gen species	= 			1 * (inrange(livestock_code, 1, 10)) 	+ /*
					*/	2 * (inrange(livestock_code, 11, 12))	+ /*
					*/	3 * (livestock_code == 21) 				+ /*
					*/	4 * (inrange(livestock_code, 13, 20))	+ /*
					*/	5 * (inrange(livestock_code, 31, 41))
				
label value species species
drop if species ==0. 

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
		replace lvstck_holding_lrum = . if lvstck_holding_lrum > 500000
		replace lvstck_holding_srum = . if lvstck_holding_srum > 500000
		replace lvstck_holding_poultry = . if lvstck_holding_poultry > 500000
	* Sum the large ruminants, small ruminants and poultry
	egen lvstck_holding_all = rowtotal(lvstck_holding_lrum 	/*
		*/ lvstck_holding_srum lvstck_holding_poultry)
	replace lvstck_holding_all = . if lvstck_holding_all > 500000
	
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
	save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_herd_characteristics",/*
		*/ replace

restore
* Calculate the per animal price for live animals
gen 	price_per_animal		= income_live_sales / number_sold

*cpk new below 10/2/23
merge m:1 livestock_code using `livestock_prices_country', nogen keep(1 3)

* Merge in Imputed prices for missing values
merge m:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hhids", /*
	*/ keep(1 3) nogen
foreach i in region district county subcounty parish ea {
	merge m:1 `i' livestock_code using  `livestock_prices_`i'', nogen keep(1 3)
	replace price_per_animal = price_median_`i' if obs_`i' > 9 & price_per_animal==.
}

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
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_TLU", replace

********************************************************************************
**                                 FISH INCOME    		         	          **
********************************************************************************
* No Fish Income data collected in Uganda w3. (Similar to other Uganda waves)

********************************************************************************
**                          SELF-EMPLOYMENT INCOME   		    	          **
********************************************************************************
//Purpose: This section is meant to calculate the value of all activities the household undertakes that would be classified as self-employment. This includes profit from business

*Generate profit from business activities (revenue net of operating costs)
use "${Uganda_NPS_W1_raw_data}/2009_GSEC12", clear
ren h12q12 months_activ // how many months did the business operate
ren h12q13 monthly_revenue //  avg monthly gross revenues when active
ren h12q15 wage_expense // avg expenditure on wages // SAW Check if its av expen on wage per individual or total (since we got an indicator for number of people hired)
ren h12q16 materials_expense // avg expenditures on raw materials
ren h12q17 operating_expense // other operating expenses (fuel, kerosine)
recode monthly_revenue wage_expense materials_expense operating_expense (. = 0)
gen monthly_profit = monthly_revenue - (wage_expense + materials_expense + operating_expense)
count if monthly_profit < 0 & monthly_profit != . // W3 has some hhs with negative profit (86)
gen annual_selfemp_profit = monthly_profit * months_activ
collapse (sum) annual_selfemp_profit, by (HHID)
lab var annual_selfemp_profit "Estimated annual net profit from self-employment over previous 12 months"
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_self_employment_income.dta", replace

********************************************************************************
**                             OFF-FARM HOURS      	    	                  **
********************************************************************************
//Purpose: This indicator is meant to create variables related to the amount of hours per-week (based on the 7 days prior to the survey) that household members individually worked at primary and secondary income-generating activities (i.e., jobs).

use "${Uganda_NPS_W1_raw_data}/2009_GSEC8.dta", clear
ren Hhid HHID
*Use ISIC codes for non-farm activities 
egen primary_hours = rowtotal (H8q36a H8q36b H8q36c H8q36d H8q36e H8q36f H8q36g) if (H8q04==1 | H8q06==1 | H8q08==1 | H8q10==1) & H8q22!=6 // includes work for someone else, work without payment for the house, apprentice etc. for all work MAIN JOB excluding "Working on the household farm or with household livestock.." Last 7 days total hours worked per person
gen secondary_hours =  H8q43 if H8q38b!=6 & H8q38b!=.
egen off_farm_hours = rowtotal(primary_hours secondary_hours) if (primary_hours!=. | secondary_hours!=.)
gen off_farm_any_count = off_farm_hours!=0 if off_farm_hours!=.
gen member_count = 1
collapse (sum) off_farm_hours off_farm_any_count member_count, by(HHID)
la var member_count "Number of HH members age 5 or above"
la var off_farm_any_count "Number of HH members with positive off-farm hours"
la var off_farm_hours "Total household off-farm hours, for the past 7 days"
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_off_farm_hours.dta", replace

********************************************************************************
**                          NON-AG WAGE INCOME  	     	    	          **
********************************************************************************
use "${Uganda_NPS_W2_raw_data}/GSEC8.dta", clear
merge m:1 HHID using "${Uganda_NPS_W2_raw_data}/GSEC1.dta"
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
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_wage_hours_imputation_urban.dta", replace
restore
sort industry
collapse(median) weeks (max) h8q44_1, by(industry) 
sort industry
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_wage_hours_imputation.dta", replace

use "${Uganda_NPS_W1_raw_data}/2009_GSEC8.dta", clear
ren Hhid HHID
merge m:1 HHID using "${Uganda_NPS_W1_raw_data}/2009_GSEC1.dta"
//Classification of Industry to get median wage for imputation, taken from r coding
g industry=1 if H8q20b<=2 //"agriculture, hunting and forestry" and "fishing"
replace industry=2 if H8q20b==3 //"mining and quarrying"
replace industry=3 if H8q20b==4 //"manufacturing"
replace industry=4 if H8q20b==5 //"electricity, gas, and water supply
replace industry=5 if H8q20b==6 //"construction"
replace industry=6 if H8q20b==7 //"sale, maintenance, and repair of motor vehicles, motorcycles and personal household goods"
replace industry=7 if H8q20b>=8 & H8q20b<=9 //"hotels and restaurants", "transport, storage and communications"
replace industry=8 if H8q20b>=10 & H8q20b<=11 //"financial intermediation", "real estate, renting and business activities"
replace industry=9 if H8q20b>=12 & H8q20b<=15 //"public administration and defence; compulsory social security", "education", "health and social work", "other community, social and personal service activities"
replace industry=10 if H8q20b>=16 & H8q20b<=17 //"private households with employed persons", "extra-territorial organizations and bodies"

label define industry 1 "Agriculture & fishing" 2 " Mining" 3 "Manufacturing" 4 "Electricity & utilities" 5 "Construction" 6 "Commerce" 7 "Transport, storage, communication"  8 "Finance, insurance, real estate" 9 "Services" 10 "Unknown" 
label values industry industry

*merge in median weeks worked
sort urban industry
merge m:1 urban industry using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_wage_hours_imputation_urban.dta", nogen keep(1 3)
ren weeks weeks_urban

sort industry
merge m:1 industry using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_wage_hours_imputation.dta", nogen keep (1 3)
ren weeks weeks_industry
gen weeks = weeks_urban
replace weeks = weeks_industry if weeks == .


//Wage Income
rename H8q30 number_months
egen number_hours = rowtotal(H8q36a H8q36b H8q36c H8q36d H8q36e H8q36f H8q36g) 
rename H8q31a most_recent_payment
replace most_recent_payment = . if (industry > 1)
rename H8q31c payment_period
rename H8q31b most_recent_payment_other
replace most_recent_payment_other = . if (industry > 1)


rename H8q44 secwage_number_months
rename h8q44_1 secwage_number_weeks
replace secwage_number_weeks=. if secwage_number_weeks>4 
gen secwage_hours_pastweek = H8q43  // Total hours worked in 2ndary job for the past week. 
rename H8q45a secwage_most_recent_payment
replace secwage_most_recent_payment = . if (industry > 1)
rename H8q45c secwage_payment_period
rename H8q45b secwage_recent_payment_other
replace secwage_recent_payment_other = . if (industry > 1)

*Non Ag Wages Income Main Job
gen annual_salary_cash = most_recent_payment*number_months if payment_period==4
replace annual_salary_cash = most_recent_payment*weeks if payment_period==3
replace annual_salary_cash = most_recent_payment*weeks*(number_hours/8) if payment_period==2 
replace annual_salary_cash = most_recent_payment*weeks*number_hours if payment_period==1

gen wage_salary_other = most_recent_payment_other*number_months if payment_period==4
replace wage_salary_other = most_recent_payment_other*weeks if payment_period==3
replace wage_salary_other = most_recent_payment_other*weeks*(number_hours/8) if payment_period==2
replace wage_salary_other = most_recent_payment_other*weeks*number_hours if payment_period==1

*Non Ag Waves Income Secondary Job
gen annual_salary_cash_sec = secwage_most_recent_payment*secwage_number_months if secwage_payment_period==4
replace annual_salary_cash_sec = secwage_most_recent_payment*secwage_number_weeks if secwage_payment_period==3
replace annual_salary_cash_sec = secwage_most_recent_payment*secwage_number_weeks*(secwage_hours_pastweek/8) if secwage_payment_period==2 // SAW Why is it divided by 8? Is 8 the average numbers of hours worked per day?
replace annual_salary_cash_sec = secwage_most_recent_payment*secwage_number_weeks*secwage_hours_pastweek if secwage_payment_period==1

gen wage_salary_other_sec = secwage_recent_payment_other*secwage_number_months if secwage_payment_period==4
replace wage_salary_other_sec = secwage_recent_payment_other*secwage_number_weeks if secwage_payment_period==3
replace wage_salary_other_sec = secwage_recent_payment_other*secwage_number_weeks*(secwage_hours_pastweek/8) if secwage_payment_period==2
replace wage_salary_other_sec = secwage_recent_payment_other*secwage_number_weeks*secwage_hours_pastweek if secwage_payment_period==1

recode annual_salary_cash wage_salary_other annual_salary_cash_sec wage_salary_other_sec (.=0)

gen annual_salary = annual_salary_cash //+ wage_salary_other + annual_salary_cash_sec + wage_salary_other_sec
*drop if (h8q19a > 610 & h8q19a < 623) | h8q19a == 921
collapse(sum) annual_salary, by (HHID)
lab var annual_salary "Annual earnings from non-agricultural wage (both Main and Secondary Job)"
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_wage_income.dta", replace

********************************************************************************
**                          AG WAGE INCOME  	     	        	          **
********************************************************************************
*impute these using median values by industry and type of residence using UGA W2

use "${Uganda_NPS_W1_raw_data}/2009_GSEC8.dta", clear
ren Hhid HHID
merge m:1 HHID using "${Uganda_NPS_W1_raw_data}/2009_GSEC1.dta", keep (1 3)
//Classification of Industry to get median wage for imputation, taken from r coding
g industry=1 if H8q20b<=2 //"agriculture, hunting and forestry" and "fishing"
replace industry=2 if H8q20b==3 //"mining and quarrying"
replace industry=3 if H8q20b==4 //"manufacturing"
replace industry=4 if H8q20b==5 //"electricity, gas, and water supply
replace industry=5 if H8q20b==6 //"construction"
replace industry=6 if H8q20b==7 //"sale, maintenance, and repair of motor vehicles, motorcycles and personal household goods"
replace industry=7 if H8q20b>=8 & H8q20b<=9 //"hotels and restaurants", "transport, storage and communications"
replace industry=8 if H8q20b>=10 & H8q20b<=11 //"financial intermediation", "real estate, renting and business activities"
replace industry=9 if H8q20b>=12 & H8q20b<=15 //"public administration and defence; compulsory social security", "education", "health and social work", "other community, social and personal service activities"
replace industry=10 if H8q20b>=16 & H8q20b<=17 //"private households with employed persons", "extra-territorial organizations and bodies"
label define industry 1 "Agriculture & fishing" 2 " Mining" 3 "Manufacturing" 4 "Electricity & utilities" 5 "Construction" 6 "Commerce" 7 "Transport, storage, communication"  8 "Finance, insurance, real estate" 9 "Services" 10 "Unknown" 
label values industry industry
*merge in median weeks worked
sort urban industry
merge m:1 urban industry using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_wage_hours_imputation_urban.dta", nogen keep(1 3)
ren weeks weeks_urban
sort industry
merge m:1 industry using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_wage_hours_imputation.dta", nogen keep (1 3)
ren weeks weeks_industry
gen weeks = weeks_urban
replace weeks = weeks_industry if weeks == .

// AG Wage Income
ren Pid PID 
merge 1:1 HHID PID using "${Uganda_NPS_W2_raw_data}/GSEC8", nogen 
rename H8q30 number_months
egen number_hours = rowtotal(H8q36a H8q36b H8q36c H8q36d H8q36e H8q36f H8q36g) 
rename H8q31a most_recent_payment
replace most_recent_payment = . if industry!=1 // SAW We get rid of all non agricultural related wages 
rename H8q31c payment_period
rename H8q31b most_recent_payment_other
*SAW We do the same for Secondary Jobs
rename h8q44 secwage_number_months
rename h8q44_1 secwage_number_weeks
replace secwage_number_weeks=. if secwage_number_weeks>4 // number of weeks worked per month cant be higher than 4 (10 obs)
gen secwage_hours_pastweek = h8q43  // Total hours worked in 2ndary job for the past week. 
rename H8q45a secwage_most_recent_payment
replace secwage_most_recent_payment = . if industry!=1 // SAW We get rid of all non agricultural related wages 
rename H8q45c secwage_payment_period
rename H8q45b secwage_recent_payment_other

*Non Ag Wages Income Main Job
gen annual_salary_cash = most_recent_payment*number_months if payment_period==4
replace annual_salary_cash = most_recent_payment*weeks if payment_period==3
replace annual_salary_cash = most_recent_payment*weeks*(number_hours/8) if payment_period==2 // SAW Why is it divided by 8? Is 8 the average numbers of hours worked per day?
replace annual_salary_cash = most_recent_payment*weeks*number_hours if payment_period==1

gen wage_salary_other = most_recent_payment_other*number_months if payment_period==4
replace wage_salary_other = most_recent_payment_other*weeks if payment_period==3
replace wage_salary_other = most_recent_payment_other*weeks*(number_hours/8) if payment_period==2
replace wage_salary_other = most_recent_payment_other*weeks*number_hours if payment_period==1


/*Non Ag Waves Income Secondary Job
gen annual_salary_cash_sec = secwage_most_recent_payment*secwage_number_months if secwage_payment_period==4
replace annual_salary_cash_sec = secwage_most_recent_payment*secwage_number_weeks if secwage_payment_period==3
replace annual_salary_cash_sec = secwage_most_recent_payment*secwage_number_weeks*(secwage_hours_pastweek/8) if secwage_payment_period==2 // SAW Why is it divided by 8? Is 8 the average numbers of hours worked per day?
replace annual_salary_cash_sec = secwage_most_recent_payment*secwage_number_weeks*secwage_hours_pastweek if secwage_payment_period==1

gen wage_salary_other_sec = secwage_recent_payment_other*secwage_number_months if secwage_payment_period==4
replace wage_salary_other_sec = secwage_recent_payment_other*secwage_number_weeks if secwage_payment_period==3
replace wage_salary_other_sec = secwage_recent_payment_other*secwage_number_weeks*(secwage_hours_pastweek/8) if secwage_payment_period==2
replace wage_salary_other_sec = secwage_recent_payment_other*secwage_number_weeks*secwage_hours_pastweek if secwage_payment_period==1

recode annual_salary_cash wage_salary_other annual_salary_cash_sec wage_salary_other_sec (.=0)
*/
gen annual_salary = annual_salary_cash //+ wage_salary_other + annual_salary_cash_sec + wage_salary_other_sec
collapse(sum) annual_salary, by (HHID)
rename annual_salary annual_salary_agwage
lab var annual_salary_agwage "Annual earnings from agricultural wage"
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_agwage_income.dta", replace
********************************************************************************
**                               OTHER INCOME 	        	    	          **
********************************************************************************
use "${Uganda_NPS_W1_raw_data}/2009_GSEC11.dta", clear
gen rental_income_cash = h11aq05 if ( h11aq03==21 |  h11aq03==22 |  h11aq03==23) // 
gen rental_income_inkind = h11aq06 if ( h11aq03==21 |  h11aq03==22 |  h11aq03==23)
gen pension_income_cash = h11aq05 if h11aq03==41 // 
gen pension_income_inkind = h11aq06 if h11aq03==41
gen assistance_cash = h11aq05 if (h11aq03==42 | h11aq03==43) // Remittances and assistance received locally and from outside
gen assistance_inkind = h11aq06 if (h11aq03==42 | h11aq03==43)
gen other_income_cash = h11aq05 if (h11aq03==32 | h11aq03==33 | h11aq03==34 | h11aq03==35 | h11aq03==36 | h11aq03==44 | h11aq03==45) // SAW E
gen other_income_inkind = h11aq06 if (h11aq03==32 | h11aq03==33 |h11aq03==34 | h11aq03==35 | h11aq03==36 | h11aq03==44 | h11aq03==45)
recode rental_income_cash rental_income_inkind pension_income_cash pension_income_inkind assistance_cash assistance_inkind other_income_cash other_income_inkind (.=0)
gen remittance_income = assistance_cash + assistance_inkind // 
gen pension_income = pension_income_cash + pension_income_inkind
gen rental_income = rental_income_cash + rental_income_inkind
gen other_income = other_income_cash + other_income_inkind
collapse (sum) remittance_income pension_income rental_income other_income, by(HHID)

lab var rental_income "Estimated income from rentals of buildings, tools, land, transport animals over previous 12 months"
lab var pension_income "Estimated income from a pension over previous 12 months" 
lab var other_income "Estimated income from any OTHER source over previous 12 months"
lab var remittance_income "Estimated income from remittances over previous 12 months"
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_other_income.dta", replace
 

********************************************************************************
**                           LAND RENTAL INCOME        	    	              **
********************************************************************************

use "${Uganda_NPS_W1_raw_data}/2009_AGSEC2A.dta", clear
ren Hhid HHID
rename A2aq14 land_rental_income
recode land_rental_income (.=0)
//since missing are recoded to 0 doing the same for the ones coded at 999/9999
recode land_rental_income (9999=.0)
recode land_rental_income (999=.0)
collapse(sum) land_rental_income, by(HHID)
lab var land_rental_income "Estimated income from renting out land over previous 12 months"
tostring HHID, format(%18.0f) replace
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_land_rental_income.dta", replace


********************************************************************************
**                           LAND SIZE       	    	              **
********************************************************************************
*Using Uganda W7 Code as reference. 

use "${Uganda_NPS_W1_raw_data}/2009_AGSEC4A", clear 
gen season=1
rename A4aq2 A4bq2 
rename A4aq4 A4bq4 
ren A4aq6 A4bq6
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC4B"
replace season = 2 if season == .
ren A4bq2 parcel_id
ren A4bq4 plot_id
ren Hhid HHID
drop if plot_id==.
gen crop_grown = 1 
collapse (max) crop_grown, by(HHID plot_id) 
tostring HHID, format(%18.0f) replace
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_crops_grown.dta", replace

use "${Uganda_NPS_W1_raw_data}/2009_AGSEC2A.dta", clear
gen season=1
ren A2aq2 A2bq2 
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC2B.dta"
replace season = 2 if season == .
ren A2bq2 parcel_id
ren Hhid HHID
gen cultivated = (A2aq13a==1 | A2aq13a==2 | A2aq13b==1 | A2aq13b==2)
replace cultivated = (A2bq15a==1 | A2bq15a==2 | A2bq15b==1 | A2bq15b==2) if (A2aq13a==. & A2aq13b==.)
replace cultivated=. if cultivated==0 & (A2aq13a==. & A2aq13b==. & A2bq15a==. & A2bq15b==.)
collapse (max) cultivated, by (HHID parcel_id)
lab var cultivated "1= Parcel was cultivated in this data set"
tostring HHID, format(%18.0f) replace
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_parcels_cultivated.dta", replace

use "${Uganda_NPS_W1_raw_data}/2009_AGSEC2A.dta", clear
gen season=1
ren A2aq2 A2bq2 
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC2B.dta"
replace season = 2 if season == .
ren A2bq2 parcel_id
ren Hhid HHID
gen cultivated = (A2aq13a==1 | A2aq13a==2 | A2aq13b==1 | A2aq13b==2)
replace cultivated = (A2bq15a==1 | A2bq15a==2 | A2bq15b==1 | A2bq15b==2) if (A2aq13a==. & A2aq13b==.)
replace cultivated=. if cultivated==0 & (A2aq13a==. & A2aq13b==. & A2bq15a==. & A2bq15b==.)
keep if cultivated==1
gen area_acres_meas = A2aq4
replace area_acres_meas = A2bq4 if area_acres_meas==. & (A2bq4!=. | A2bq4!=0)
replace area_acres_meas = A2aq5 if area_acres_meas==. & (A2aq5!=. | A2aq5!=0)
replace area_acres_meas = A2bq5 if area_acres_meas==. & (A2bq5!=. | A2bq5!=0)
collapse (sum) area_acres_meas, by (HHID)
ren area_acres_meas farm_area
replace farm_area = farm_area * (1/2.47105) /* Convert to hectares */
lab var farm_area "Land size (denominator for land productivitiy), in hectares" 
tostring HHID, format(%18.0f) replace
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_land_size.dta", replace

*All agricultural land 
use "${Uganda_NPS_W1_raw_data}/2009_AGSEC2A.dta", clear
gen season=1
ren A2aq2 A2bq2 
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC2B.dta"
replace season = 2 if season == .
ren Hhid HHID
gen rented_out = (A2aq13a==3 | A2aq13b==3 | A2aq13a==3 | A2aq13b==3)
replace rented_out=. if rented_out==0 & (A2aq13a==. |A2aq13b==. | A2bq15a==. | A2bq15b==.)
gen other_land_use= (A2aq13a==7 | A2aq13a==96 | A2aq13b==7 | A2aq13b==96 | A2bq15a==6 | A2bq15a==96 | A2bq15b==6 | A2bq15b==96)
replace other_land_use=. if other_land_use==0 & (A2aq13a==. & A2aq13b==. & A2bq15a==. & A2bq15b==.)
drop if rented_out==1 | other_land_use==1
gen agland = 1  
collapse (max) agland, by (HHID)
tostring HHID, format(%18.0f) replace
merge 1:m HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_crops_grown.dta", keep(3)
drop _m crop_grown
lab var agland "1= Parcel was used for crop cultivation or left fallow in this past year (forestland and other uses excluded)"
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_parcels_agland.dta", replace

use "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_land_size.dta", replace
merge 1:m HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_parcels_agland.dta", keep(3)
collapse (mean) farm_area, by(HHID)
rename farm_area farm_size_agland
lab var farm_size_agland "Land size in hectares, including all plots cultivated or left fallow" 
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_farmsize_all_agland.dta", replace

use "${Uganda_NPS_W1_raw_data}/2009_AGSEC2A.dta", clear
gen season=1
ren A2aq2 A2bq2 
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC2B.dta"
replace season = 2 if season == .
ren Hhid HHID
gen rented_out = (A2aq13a==3 | A2aq13b==3 | A2aq13a==3 | A2aq13b==3)
replace rented_out=. if rented_out==0 & (A2aq13a==. |A2aq13b==. | A2bq15a==. | A2bq15b==.)
drop if rented_out==1 
gen parcel_held = 1  
collapse (sum) parcel_held, by (HHID)
lab var parcel_held "1= Parcel was NOT rented out in the main season" // confusion of parcel with plot 
tostring HHID, format(%18.0f) replace
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_parcels_held.dta", replace

use "${Uganda_NPS_W1_raw_data}/2009_AGSEC2A.dta", clear
gen season=1
ren A2aq2 A2bq2 
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC2B.dta"
replace season = 2 if season == .
ren Hhid HHID
gen rented_out = (A2aq13a==3 | A2aq13b==3 | A2aq13a==3 | A2aq13b==3)
replace rented_out=. if rented_out==0 & (A2aq13a==. |A2aq13b==. | A2bq15a==. | A2bq15b==.)
drop if rented_out==1 
gen area_acres_meas = A2aq4 if (A2aq4!=. & A2aq4!=0)
replace area_acres_meas = A2bq4 if area_acres_meas==. & (A2bq4!=. | A2bq4!=0)
replace area_acres_meas = A2aq5 if area_acres_meas==. & (A2aq5!=. | A2aq5!=0)
replace area_acres_meas =  A2bq5 if area_acres_meas==. & (A2bq5!=. | A2bq5!=0)

collapse (sum) area_acres_meas, by (HHID)
ren area_acres_meas land_size
replace land_size = land_size * (1/2.47105) /* Convert to hectares */
lab var land_size "Land size in hectares, including all plots listed by the household except those rented out"
tostring HHID, format(%18.0f) replace
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_land_size_all.dta", replace

*Total land holding including cultivated and rented out
use "${Uganda_NPS_W1_raw_data}/2009_AGSEC2A.dta", clear
gen season=1
ren A2aq2 A2bq2 
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC2B.dta"
replace season = 2 if season == .
ren Hhid HHID
gen area_acres_meas = A2aq4 if (A2aq4!=. & A2aq4!=0)
replace area_acres_meas = A2bq4 if area_acres_meas==. & (A2bq4!=. | A2bq4!=0)
replace area_acres_meas = A2aq5 if area_acres_meas==. & (A2aq5!=. | A2aq5!=0)
replace area_acres_meas =  A2bq5 if area_acres_meas==. & (A2bq5!=. | A2bq5!=0)
collapse (sum) area_acres_meas, by (HHID)
ren area_acres_meas land_size_total
replace land_size_total = land_size_total * (1/2.47105) /* Convert to hectares */
lab var land_size_total "Total land size in hectares, including rented in and rented out plots"
tostring HHID, format(%18.0f) replace
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_land_size_total.dta", replace


********************************************************************************
**                             FARM LABOR       	    	                  **
********************************************************************************

*1.  Hired Labor and Family labor  1st Visit and 2nd visit (main and short season)
use "${Uganda_NPS_W1_raw_data}/2009_AGSEC3A.dta", clear
ren A3aq3 plot_id
ren A3aq1 parcel_id
ren Hhid HHID
drop if plot_id==.
ren A3aq42a days_hired_men
ren A3aq42b days_hired_women
ren A3aq42c days_hired_children // Person days hired labor
*Raw data does have high standard deviation...which very high days of hiring men, women and children 
recode days_hired_men days_hired_women days_hired_children (.=0)
gen days_hired_mainseason = days_hired_men + days_hired_women + days_hired_children
rename A3aq41 days_famlabor_mainseason // SAW Person days family labor (questionnaire does not differentiate across gender, children)
recode days_famlabor_mainseason (.=0)
collapse (sum) days_hired_mainseason days_famlabor_mainseason, by (HHID parcel_id plot_id) 
lab var days_hired_mainseason  "Workdays for hired labor (crops) in main growing season"
lab var days_famlabor_mainseason  "Workdays for family labor (crops) in main growing season"
tostring HHID, format(%18.0f) replace
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_farmlabor_mainseason.dta", replace

use "${Uganda_NPS_W1_raw_data}/2009_AGSEC3B.dta", clear
ren a3bq3 plot_id
ren a3bq1 parcel_id
drop if plot_id==.
ren a3bq42a days_hired_men
ren a3bq42b days_hired_women
ren a3bq42c days_hired_children // Person days hired labor
recode days_hired_men days_hired_women days_hired_children (.=0)
gen days_hired_shortseason = days_hired_men + days_hired_children + days_hired_women
rename a3bq39 days_famlabor_shortseason // SAW Again, no granularity on men, women, children
recode days_famlabor_shortseason (.=0)
collapse (sum) days_hired_shortseason days_famlabor_shortseason, by (HHID parcel_id plot_id)
lab var days_hired_shortseason  "Workdays for hired labor (crops) in short growing season"
lab var days_famlabor_shortseason  "Workdays for family labor (crops) in short growing season"
tostring HHID, format(%18.0f) replace
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_farmlabor_shortseason.dta", replace

*2. We merge both seasons into one dataset
use "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_farmlabor_mainseason.dta", replace
merge 1:1 HHID parcel_id plot_id using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_farmlabor_shortseason.dta", nogen
recode days* (.=0)
collapse (sum) days*, by(HHID parcel_id plot_id)
egen labor_hired = rowtotal(days_hired_mainseason days_hired_shortseason)
egen labor_family = rowtotal(days_famlabor_mainseason days_famlabor_shortseason)
egen labor_total = rowtotal(days_hired_mainseason days_hired_shortseason days_famlabor_mainseason days_famlabor_shortseason) 
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm"
lab var labor_hired "Total labor days (hired) allocated to the farm"
lab var labor_family "Total labor days (family) allocated to the farm"
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_family_hired_labor.dta", replace
collapse (sum) labor_*, by (HHID) 
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm"
lab var labor_hired "Total labor days (hired) allocated to the farm"
lab var labor_family "Total labor days (family) allocated to the farm"
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_family_hired_labor.dta", replace
********************************************************************************
*                                VACCINE  USAGE                                *
********************************************************************************
/*	 Only Large Ruminants and Equines have data on 
 *	vaccines. The Sheep, goats, pigs module and the poultry/rabbit module
 *	do not include data on vaccine usage.
 */

* 	Load Agricultural Section 6A - Livestock Ownership: Cattle and Pack Animals
* 	dta from Disk
use "${Uganda_NPS_W1_raw_data}/2009_AGSEC6A", clear
ren Hhid HHID 
* Standardize key variables across waves
rename	A6aq3 livestock_code
/*	__NOTE__ SAK 20200107: a6aq18 response of 1 means all animals are 
 *	vaccinated, response of 2 is some animals vaccinated
 */
gen		vac_animal	= inlist(A6aq18, 1, 2)
*Don't have as many categories as other waves. Also mules and donkeys have been labelled as indigenous bulls and oxen. Have taken the livestock_code as the correct label. 
gen		species = 	inrange(livestock_code, 1, 6) + /*
				*/	4*(inlist(livestock_code, 7, 8))	
* Don't use data if no species is specified
recode species (0=.)
label values species species
la def species 1 "Large ruminants (cows, buffalos)" 4 "Equines (donkeys, mules, horses)"

*A loop to create species variables
foreach i in vac_animal {
	gen `i'_lrum = `i' if species==1
	*gen `i'_srum = `i' if species==2
	*gen `i'_pigs = `i' if species==3
	gen `i'_equines = `i' if species==4
}
collapse (max) vac_animal*, by (HHID)
lab var vac_animal "1= Household has an animal vaccinated"
foreach i in vac_animal {
	local l`i' : var lab `i'
	lab var `i'_lrum "`l`i'' - large ruminants"
	*lab var `i'_srum "`l`i'' - small ruminants"
	*lab var `i'_pigs "`l`i'' - pigs"
	lab var `i'_equines "`l`i'' - equine"
}

tostring HHID, format(%18.0f) replace
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_vaccine.dta", replace

*basing this off of Nigeria W3
use "${Uganda_NPS_W1_raw_data}/2009_AGSEC6A", clear
gen all_vac_animal=A6aq18<=2 
rename A6aq3 livestock_code
ren Hhid HHID
preserve
keep HHID all_vac_animal A6aq17a
ren A6aq17a farmerid
tempfile farmer1
save `farmer1'
restore
preserve
keep HHID  A6aq17b  all_vac_animal 
ren A6aq17b farmerid
tempfile farmer2
save `farmer2'
restore
use   `farmer1', replace
append using  `farmer2'
collapse (max) all_vac_animal , by(HHID farmerid)
gen personid = farmerid
drop if personid==. 
merge 1:1 HHID personid using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_person_ids.dta", nogen
keep HHID farmerid all_vac_animal personid female age
lab var all_vac_animal "1 = Individual farmer (livestock keeper) uses vaccines"
gen livestock_keeper=1 if farmerid!=.
recode livestock_keeper (.=0)
lab var livestock_keeper "1=Indvidual is listed as a livestock keeper (at least one type of livestock)" 
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_farmer_vaccine", replace

********************************************************************************
**                        ANIMAL HEALTH - DISEASES     	    	              **
********************************************************************************
*Comments: No information available on types of diseases suffered by [livestock_id], we only have information on which types of diseases hhid vaccineted for.

********************************************************************************
**                   LIVESTOCK WATER, FEEDING, AND HOUSING     	              **
********************************************************************************
 /* Cannot Construct in this Instrument. No questions on these topics */


********************************************************************************
**                      USE OF INORGANIC FERTILIZER         	              **
********************************************************************************
*SAW 9.26.22 Using Uganda Wave 7 as reference. 
use "${Uganda_NPS_W1_raw_data}/2009_AGSEC3A.dta", clear
gen season=1
ren A3aq1 a3bq1
ren A3aq3 a3bq3
ren Hhid HHID
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC3B.dta"
replace season = 2 if season == .
ren a3bq1 parcel_id
ren a3bq3 plot_id
gen use_inorg_fert=(A3aq14==1 | a3bq14==1) if (A3aq14!=. | a3bq14!=.)
replace use_inorg_fert=. if use_inorg_fert==0
collapse (max) use_inorg_fert, by (HHID)
tostring HHID, format(%18.0f) replace
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_fert_use.dta", replace


**************************************
************* PLOT MANAGER ***********
************************************** 
*Using Wave 2 as reference 
use "${Uganda_NPS_W1_raw_data}/2009_AGSEC4A", clear
ren A4aq2 A4bq2 
ren A4aq4 A4bq4
ren A4aq6 A4aq6
gen season=1
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC4B"
replace season = 2 if season == .
ren A4bq2 parcel_id
ren A4bq4 plot_id
ren A4aq6 crop_code
ren Hhid HHID
* recode and combine improved seed variables
recode	A4aq13 A4bq13 		(1=0) (2=1) (.=0)
egen 	imprv_seed_use	= 	rowmax(A4aq13 A4bq13)

recode crop_code  (741 742 744 = 740)


recode crop_code (811 812 = 810) (741 742 744 = 740) (224 = 223) //740 is bananas, which is being reduced from different types to just bananas. Same for peas (220).

label define crop_code 740 "BANANAS", modify
rename parcel_id parcel_id
rename plot_id plot_id
gen cropping_syst = A4aq7
replace cropping_syst = A4bq7 if cropping_syst ==.
collapse (max) imprv_seed_use, by(HHID parcel_id plot_id crop_code season)
tempfile imprv_seed
save `imprv_seed'

use "${Uganda_NPS_W1_raw_data}/2009_AGSEC2A.dta", clear
gen season=1
ren A2aq2 A2bq2 
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC2B.dta"
replace season = 2 if season == .
ren Hhid HHID
egen personid1	=	rowfirst(A2aq27a A2bq25a)
egen personid2	= 	rowfirst(A2aq27b A2bq25b)
rename A2bq2 parcel_id
keep personid* HHID parcel_id
reshape long personid, i(HHID parcel_id) j(personidno)
drop personidno
drop if personid==.
 
merge m:1 HHID personid using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_person_ids", nogen keep (1 3)
tempfile personids 
save `personids'

use "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_input_quantities.dta", clear
foreach i in n p k inorg_fert org_fert pest {
	recode `i'_kg (.=0)
	replace `i'_kg=1 if `i'_kg >0 
	ren `i'_kg use_`i'
}
collapse (max) use_*, by(HHID parcel_id plot_id season)
merge 1:m HHID plot_id parcel_id season using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_all_plots.dta", nogen keep(1 3) keepusing(crop_code)
*ren crop_code_master crop_code
collapse (max) use*, by(HHID plot_id parcel_id crop_code season)
merge 1:1 HHID parcel_id plot_id crop_code season using `imprv_seed',nogen
recode use* (.=0)
preserve 
keep HHID parcel_id plot_id crop_code imprv_seed_use
ren imprv_seed_use imprv_seed_
gen hybrid_seed_ = .
collapse (max) imprv_seed_ hybrid_seed_, by(HHID crop_code)
merge m:1 crop_code using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_cropname_table.dta", nogen keep(3)
drop crop_code
reshape wide imprv_seed_ hybrid_seed_, i(HHID) j(crop_name) string
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_imprvseed_crop.dta", replace 
restore 

merge m:m HHID parcel_id using `personids', nogen keep(1 3)
preserve
ren imprv_seed_use all_imprv_seed_
gen all_hybrid_seed_ =.
collapse (max) all*, by(HHID personid female crop_code)
merge m:1 crop_code using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_cropname_table.dta", nogen keep(3)
drop crop_code
gen farmer_=1
reshape wide all_imprv_seed_ all_hybrid_seed_ farmer_, i(HHID personid female) j(crop_name) string
recode farmer_* (.=0)
ren farmer_* *_farmer
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_farmer_improvedseed_use.dta", replace
restore

ren imprv_seed_use use_imprv_seed
collapse (max) use_*, by(HHID personid female)
gen all_imprv_seed_use = use_imprv_seed 

preserve
	collapse (max) use_inorg_fert use_imprv_seed use_org_fert use_pest, by (HHID)
	la var use_inorg_fert "1= Household uses inorganic fertilizer"
	la var use_pest "1 = household uses pesticide"
	la var use_org_fert "1= household uses organic fertilizer"
	la var use_imprv_seed "1=household uses improved or hybrid seeds for at least one crop"
	gen use_hybrid_seed = .
	la var use_hybrid_seed "1=household uses hybrid seeds (not in this wave - see imprv_seed)"
	save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_input_use.dta", replace 
restore

preserve
gen farm_manager=1 if personid!=.
	recode farm_manager (.=0)
	lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
	ren use_inorg_fert all_use_inorg_fert
	replace all_use_inorg_fert = . if farm_manager==0 
	lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
	destring personid, replace 
	save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_farmer_fert_use.dta", replace 
restore


********************************************************************************
*                           REACHED BY AG EXTENSION                            *
********************************************************************************

use "${Uganda_NPS_W1_raw_data}/2009_AGSEC10", clear
rename Hhid HHID 
label variable A10q2 "Source"
ta A10q2, gen(newvar)
gen ext_reach_public=(newvar4==1)
gen ext_reach_private=(newvar1==1 | newvar2==1 | newvar3==1 | newvar5==1)
gen ext_reach_unspecified=(newvar6==1)
*gen ext_reach_ict=(advice_radio==1)
gen ext_reach_all=(ext_reach_public==1 | ext_reach_private==1 | ext_reach_unspecified==1)
collapse (max) ext_reach_* , by (HHID)
lab var ext_reach_all "1 = Household reached by extensition services - all sources"
lab var ext_reach_public "1 = Household reached by extensition services - public sources"
lab var ext_reach_private "1 = Household reached by extensition services - private sources"
lab var ext_reach_unspecified "1 = Household reached by extensition services - unspecified sources"
*lab var ext_reach_ict "1 = Household reached by extensition services through ICT"
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_any_ext.dta", replace


********************************************************************************
*								HOUSEHOLD ASSETS							   *
********************************************************************************
use "${Uganda_NPS_W1_raw_data}/2009_GSEC14.dta", clear
ren h14q5 value_today
ren h14q4 num_items
*dropping items if hh doesnt report owning them 
tostring h14q3, gen(asset)
drop if asset=="0"
collapse (sum) value_assets=value_today, by(HHID)
la var value_assets "Value of household assets"
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hh_assets.dta", replace


********************************************************************************
*                      USE OF FORMAL FINANCIAL SERVICES                       *
********************************************************************************
//CPK: Different options than those in wave 7. Couldn't make certain categories that were present in that wave. Disregarded relative/friend.There was also no NGO category, generated this but left it empty. 

use "${Uganda_NPS_W1_raw_data}/2009_GSEC13.dta", clear
ta h13q16, gen (borrow)

rename borrow1 borrow_bank
rename borrow10 borrow_other_fin
gen borrow_micro= borrow3==1 | borrow4==1 | borrow6==1 | borrow8==1 | borrow9==1 
gen use_fin_serv_credit= borrow_bank==1 | borrow_micro==1  | borrow_other_fin==1
gen borrow_NGO = 0
//Ahana - look into this CPK: No information on saving in the data even though this was included in the survey. Generated these but left them empty. This means the only variable with data in the final variables was use_fin_serv_all and use_fin_serv_credit
gen use_fin_serv_bank=h13q19==1 | h13q20==1 // if they have an account with a bank and non formal institution 

gen use_fin_serv_digital= 0
gen use_fin_serv_others= h13q25==1
gen use_fin_serv_insur= h13q21==1 | h13q22==1
gen use_fin_serv_all=use_fin_serv_bank==1 | use_fin_serv_credit==1 | use_fin_serv_digital==1 | use_fin_serv_others==1 | use_fin_serv_insur==1

collapse (max) use_fin_serv_*, by (HHID)
lab var use_fin_serv_all "1= Household uses formal financial services - all types"
lab var use_fin_serv_bank "1= Household uses formal financial services - bank accout"
lab var use_fin_serv_credit "1= Household uses formal financial services - credit"
lab var use_fin_serv_digital "1= Household uses formal financial services - digital"
lab var use_fin_serv_others "1= Household uses formal financial services - others"
lab var use_fin_serv_insur "1= Household uses formal financial services - insurance"

save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_fin_serv.dta", replace

********************************************************************************
*MILK PRODUCTIVITY
********************************************************************************
use "${Uganda_NPS_W1_raw_data}/2009_AGSEC8", clear
ren Hhid HHID
keep if A8q2==1 | A8q2==2 | A8q2==3 // keeping only milk - don't have information on ruminants in this wave
gen milk_permonth = A8q4
gen milk_production = A8q3
*Should we not be converting all the milk into liters here?
*drop if milk_production ==0
gen liters_milk_produced = milk_permonth*milk_production
label variable liters_milk_produced "Average quantity (liters) per year per household"
collapse (sum) liters_milk_produced, by(HHID)
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_milk_animals.dta", replace

********************************************************************************
*EGG PRODUCTIVITY
********************************************************************************
use "${Uganda_NPS_W1_raw_data}/2009_AGSEC6C", clear
rename A6cq3 livestock_code
destring livestock_code, replace 
ren Hhid HHID
gen poultry_owned = A6cq5 if (livestock_code==32 | livestock_code==35 | livestock_code==38 | livestock_code==33|livestock_code==34| livestock_code==36 | livestock_code==37)
collapse (sum) poultry_owned, by(HHID)
tempfile eggs_animals_hh 
save `eggs_animals_hh'

use "${Uganda_NPS_W1_raw_data}/2009_AGSEC8", clear
ren Hhid HHID
gen eggs_months = A8q3 if A8q2==5 
gen eggs_per_month = A8q4 if A8q2==5 
collapse (sum) eggs_months eggs_per_month, by(HHID)
*drop if eggs_months==0
gen eggs_total_year = eggs_per_month*eggs_months // multiply to get the annual total 
merge m:1 HHID using  `eggs_animals_hh', nogen keep(1 3)			
lab var eggs_months " How many months poultry laid eggs in the last year"
lab var eggs_per_month "Total number of eggs that were produced per month (household)"
lab var eggs_total_year "Total number of eggs that was produced in the year(household)"
lab var poultry_owned "Total number of poulty owned (household)"
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_eggs_animals.dta", replace

********************************************************************************
*AGRICULTURAL WAGES
********************************************************************************
use "${Uganda_NPS_W1_raw_data}/2009_AGSEC3A.dta", clear
gen season=1
ren A3aq1 a3bq1
ren A3aq3 a3bq3
ren Hhid HHID
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC3B.dta"
replace season = 2 if season == .
ren a3bq1 parcel_ID
ren a3bq3 plot_ID
drop if plot_ID==.
*2406 observation deleted. still have 17,281

*Hired wages:
gen hired_wage = A3aq43 // wage paid is not reported in season 2

*Hired costs
gen hired_labor_costs = A3aq43
gen wage_paid_aglabor = hired_labor_costs
*Constructing a household-specific wage
collapse (sum) wage_paid_aglabor, by(HHID)										
recode wage* (0=.)	
keep HHID wage_paid_aglabor 
lab var wage_paid_aglabor "Daily wage in agriculture"
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_ag_wage.dta", replace


********************************************************************************
**                      CROP PRODUCTION COSTS PER HECTARE                      **
********************************************************************************
*All the preprocessing is done in the crop expenses section */

use "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_all_plots.dta", clear
collapse (sum) ha_planted /*ha_harvest*/, by (HHID parcel_id plot_id purestand field_size /*season*/)       
duplicates report HHID parcel_id plot_id /*season*/
*duplicates tag HHID parcel_id plot_id season, g(dupes)
*br if dupes > 0
duplicates drop HHID parcel_id plot_id /*season*/, force // CPK: WAY too many deleted here - this is wrong
reshape long ha_, i(HHID parcel_id plot_id /*season*/ purestand field_size) j(area_type) string
tempfile plot_areas
save `plot_areas'
*# Bookmark #1
use "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_cost_inputs_long.dta", replace
collapse (sum) cost_=val, by(HHID parcel_id plot_id /*season*/ dm_gender exp)  
reshape wide cost_, i(HHID parcel_id plot_id /*season*/ dm_gender) j(exp) string  
recode cost_exp cost_imp (.=0)
*drop cost_total
gen cost_total=cost_imp+cost_exp
drop cost_imp
drop if plot_id ==.
merge m:1 HHID parcel_id plot_id /*season*/ using `plot_areas', nogen keep(3)
gen cost_exp_ha_ = cost_exp/ha_ 
gen cost_total_ha_ = cost_total/ha_
replace dm_gender=1 if dm_gender==.
collapse (mean) cost*ha_ [aw=field_size], by(HHID /*parcel_id*/ /*plot_id*/ /*season*/ dm_gender area_type)
gen dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
drop dm_gender // SAW There are 20 obs with no info on dm_gender which was causing the doubles in the code above
*gen dummy = _n
*replace area_type = "harvested" if strmatch(area_type,"harvest")

reshape wide cost*_, i(HHID dm_gender2 /*dummy*/) j(area_type) string
*drop dummy
ren cost* cost*_
*gen dummy = _n
*replace dm_gender2 = "missing" if dm_gender2==""
reshape wide cost*, i(HHID /*season*/) j(dm_gender2) string
*drop dummy

foreach i in male female mixed {
	foreach j in planted /*harvested*/ {
		la var cost_exp_ha_`j'_`i' "Explicit cost per hectare by area `j', `i'-managed plots"
		la var cost_total_ha_`j'_`i' "Total cost per hectare by area `j', `i'-managed plots"
	}
}
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_cropcosts.dta", replace

********************************************************************************
*LAND RENTAL 
*******************************************************************************
*To do

********************************************************************************
*INPUT COST *
********************************************************************************* 
* Moved to crop expenses

********************************************************************************
*RATE OF FERTILIZER APPLICATION
********************************************************************************

use "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_all_plots.dta", clear
collapse (sum) ha_planted, by(HHID parcel_id plot_id season dm_gender) 
merge 1:m HHID parcel_id plot_id season using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_input_quantities.dta", keep(1 3) nogen
*merge 1:1 HHID parcel_id plot_id season using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_input_quantities.dta", keep(1 3) nogen
collapse (sum) ha_planted n_kg p_kg k_kg inorg_fert_kg org_fert_kg pest_kg, by(HHID parcel_id plot_id dm_gender) // at the plot level for both seasons

drop if ha_planted==0
unab vars : *kg 
local vars `vars' ha_planted
recode *kg (.=0)

gen dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
drop dm_gender
ren ha_planted ha_planted_
ren *kg *kg_ 
drop if dm_gender2=="" // Might be a better way to allow reshape work without losing this info. 
reshape wide *_ /*herb_kg_*/, i(HHID parcel_id plot_id) j(dm_gender2) string
collapse (sum) *male *mixed, by(HHID)
recode ha_planted* (0=.)

foreach i in `vars' {
	egen `i' = rowtotal(`i'_*)
}
merge m:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hhids.dta", keep (1 3) nogen
_pctile ha_planted [aw=weight]  if ha_planted!=0 , p($wins_lower_thres $wins_upper_thres)
foreach x of varlist ha_planted ha_planted_male ha_planted_female ha_planted_mixed {
		replace `x' =r(r1) if `x' < r(r1)   & `x' !=. &  `x' !=0 
		replace `x' = r(r2) if  `x' > r(r2) & `x' !=.    
}
lab var inorg_fert_kg "Inorganic fertilizer (kgs) for household"
lab var org_fert_kg "Organic fertilizer (kgs) for household" 
lab var pest_kg "Pesticide (kgs) for household"
*lab var herb_kg "Herbicide (kgs) for household"
lab var ha_planted "Area planted (ha), all crops, for household"
la var n_kg "Nitrogen from inorganic fertilizers (kg) for hh"
la var p_kg "Phosphorus from inorganic fertilizers (kg) for hh"
la var k_kg "Potassium from inorganic fertilizers (kg) for hh"

foreach i in male female mixed {
lab var inorg_fert_kg_`i' "Inorganic fertilizer (kgs) for `i'-managed plots"
lab var org_fert_kg_`i' "Organic fertilizer (kgs) for `i'-managed plots" 
lab var pest_kg_`i' "Pesticide (kgs) for `i'-managed plots"
*lab var herb_kg_`i' "Herbicide (kgs) for `i'-managed plots"
lab var ha_planted_`i' "Area planted (ha), all crops, `i'-managed plots"
lab var n_kg "Nitrogen from inorganic fertilizers (kg) for hh"
la var p_kg "Phosphorus from inorganic fertilizers (kg) for hh"
la var k_kg "Potassium from inorganic fertilizers (kg) for hh"
}
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_fertilizer_application.dta", replace


********************************************************************************
*WOMEN'S DIET QUALITY
*******************************************************************************
*Women's diet quality: proportion of women consuming nutrient-rich foods (%)
*Information not available

**# Not working

********************************************************************************
*HOUSEHOLD'S DIET DIVERSITY SCORE
********************************************************************************
*No available data to construct rCSI module.
*Constructing FCS
use "${Uganda_NPS_W1_raw_data}/2009_GSEC15B", clear
tostring HHID, format(%18.0f) replace
ren h15bq3b days
recode days (8=7)
recode days (.=0)

recode h15bq2 		(110/116  					=1	"CEREALS" )  								//// A
					(101/109    				=2	"WHITE ROOTS,TUBERS AND OTHER STARCHES"	) 	//// B
					(140/146					=3	"LEGUMES, NUTS AND SEEDS" ) 				//// C
					(135/139	 				=4	"VEGETABLES"	)  							//// D
					(117/124 					=5	"MEAT, EGGS, FISH"	)                       //// E				
					(130/134					=6	"FRUITS"	)  							    //// F
					(125						=7	"MILK AND MILK PRODUCTS" )					//// G
					(127/129   					=8	"OILS AND FATS"	)							//// H
					(147 151 154 				=9	"SWEETS"	) 								//// I
					(148/150 152 153 160		=10 "SPICES, CONDIMENTS, BEVERAGES"	)			//// J
					,generate(foodgroup)
keep if foodgroup<10

keep foodgroup HHID days
collapse (sum) days, by(HHID foodgroup)
reshape wide days, i(HHID) j(foodgroup)
gen max_days = max(days1, days2)
gen min_days = min(days1, days2)
gen sum_days = days1+days2
gen fcs_a =.
replace fcs_a =7 if max_days==7
replace fcs_a=max_days if min_days==0
replace fcs_a=((max_days+min_days)/2) if sum_days>7
drop days1 days2 /*days10*/ *_days
ren fcs_a days1
reshape long days, i(HHID) j(foodgroup)
gen weight = .
replace weight = 2 if foodgroup==1 							// max of A and B 
replace weight = 3 if foodgroup == 3 						// C
replace weight = 1 if foodgroup == 4 | foodgroup == 6 		// D & F
replace weight = 4 if foodgroup == 5 | foodgroup == 7   	// E & G
replace weight = 0.5 if foodgroup == 8 | foodgroup == 9 	// H & I
gen fcs =. 
replace fcs = days*weight
collapse (sum) fcs, by (HHID)
label var fcs "Food Consumption Score"
gen fcs_poor = (fcs <= 21)
gen fcs_borderline = (fcs > 21 & fcs <= 35)
gen fcs_acceptable = (fcs > 35)
label var fcs_poor "1 = Household has poor Food Consumption Score (0-21)"
label var fcs_borderline "1 = Household has borderline Food Consumption Score (21.5 - 35)"
label var fcs_acceptable "1 = Household has acceptable Food Consumption Score (> 35)"

*merge 1:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_household_diet.dta", nogen 
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_fcs.dta", replace
*save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_household_thresholds.dta", replace

*Constructing HDDS
use "${Uganda_NPS_W1_raw_data}/2009_GSEC15B", clear
*rename Hhid HHID
tostring HHID, format(%18.0f) replace
recode h15bq2 		(110/116  					=1	"CEREALS" )  //// A
					(101/109    				=2	"WHITE ROOTS,TUBERS AND OTHER STARCHES"	)  //// B
					(135/139	 				=3	"VEGETABLES"	)  ////	D
					(130/134					=4	"FRUITS"	)  ////	F
					(117/121 					=5	"MEAT"	)  ////	E				
					(124						=6	"EGGS"	)  //// E
					(122 123 					=7  "FISH") /// 	E
					(140/146					=8	"LEGUMES, NUTS AND SEEDS") ///	C
					(125						=9	"MILK AND MILK PRODUCTS")  //// G
					(127/129   					=10	"OILS AND FATS"	)  //// H
					(147 151 154 				=11	"SWEETS"	)  //// I
					(148/150 152 153 160 		=14 "SPICES, CONDIMENTS, BEVERAGES"	)  //// J
					,generate(Diet_ID)
keep if Diet_ID<15

gen adiet_yes=h15bq3b!=.

ta Diet_ID
** Now, collapse to food group level; household consumes a food group if it consumes at least one item
collapse (max) adiet_yes, by(HHID Diet_ID) 
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

merge 1:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_fcs.dta", nogen 
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_household_diet.dta", replace



/*
use "${Uganda_NPS_W1_raw_data}/2009_GSEC15B", clear
*rename Hhid HHID
tostring HHID, format(%18.0f) replace
recode h15bq2 		(110/116  					=1	"CEREALS" )  //// A
					(101/109    				=2	"WHITE ROOTS,TUBERS AND OTHER STARCHES"	)  //// B
					(135/139	 				=3	"VEGETABLES"	)  ////	D
					(130/134					=4	"FRUITS"	)  ////	F
					(117/121 					=5	"MEAT"	)  ////	E				
					(124						=6	"EGGS"	)  //// E
					(122 123 					=7  "FISH") /// 	E
					(140/146					=8	"LEGUMES, NUTS AND SEEDS") ///	C
					(125						=9	"MILK AND MILK PRODUCTS")  //// G
					(127/129   					=10	"OILS AND FATS"	)  //// H
					(147 151 154 				=11	"SWEETS"	)  //// I
					(148/150 152 153 160 		=14 "SPICES, CONDIMENTS, BEVERAGES"	)  //// J
					,generate(Diet_ID)
keep if Diet_ID<15

gen adiet_yes=h15bq3b!=.

ta Diet_ID
** Now, collapse to food group level; household consumes a food group if it consumes at least one item
collapse (max) adiet_yes, by(HHID Diet_ID) 
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
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_household_diet.dta", replace
*/





********************************************************************************
                     * WOMEN'S CONTROL OVER INCOME *
********************************************************************************
*CPK: this is definitely wrong... Don't know what to do about the most definitely wrong PersonIDs from enterprise income!
* First append all files with information on who control various types of income
use "${Uganda_NPS_W1_raw_data}/2009_AGSEC5A", clear
ren Hhid HHID
append using  "${Uganda_NPS_W1_raw_data}/2009_AGSEC5B"
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC6A" 
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC6B" 	
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC6C" 	
append using  "${Uganda_NPS_W1_raw_data}/2009_AGSEC8"
append using "${Uganda_NPS_W1_raw_data}/2009_GSEC12" //  //Non-Agricultural Household Enterprises/Activities - h12q19a h12q19b

gen type_decision="" 
gen double controller_income1=.
gen double controller_income2=.
*Don't have household level so have used Wave 2 as reference by using personid level data
replace type_decision="control_annualharvest" if  !inlist( A5aq11, .,0,99) |  !inlist( A5bq11, .,0,99) 
replace controller_income1=A5aq11 if !inlist( A5aq11, .,0,99)  
replace controller_income1=A5bq11 if !inlist( A5bq11, .,0,99)
replace type_decision="control_livestocksales" if  !inlist( A8q9a, .,0,99) |  !inlist( A8q9b, .,0,99) 
replace controller_income1=A8q9a if !inlist( A8q9a, .,0,99)  
replace controller_income2=A8q9b if !inlist( A8q9b, .,0,99)
gen h12q5aa = h12q05a
gen h12q5bb = h12q05b
destring h12q5bb, replace 
rename h12q05a enterprise1
rename h12q05b enterprise2
*reshape long enterprise, i(HHID pltid prcid cropID)
* control_businessincome
replace type_decision="control_businessincome" if  !inlist( h12q5aa, .,0,99) |  !inlist( h12q5bb, .,0,99) 
replace controller_income1=h12q5aa if !inlist( h12q5aa, .,0,99)  
replace controller_income2=h12q5bb if !inlist( h12q5bb, .,0,99)

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
							*| type_decision=="control_annualsales" ///
							*| type_decision=="control_permsales" ///
							*| type_decision=="control_processedsales"
recode 	control_cropincome (.=0)								
gen control_livestockincome=1 if  type_decision=="control_livestocksales" ///
							*| type_decision=="control_milksales" ///
							*| type_decision=="control_otherlivestock_sales"				
recode 	control_livestockincome (.=0)

gen control_farmincome=1 if  control_cropincome==1 | control_livestockincome==1							
recode 	control_farmincome (.=0)							
gen control_businessincome=1 if  type_decision=="control_businessincome" 
recode 	control_businessincome (.=0)																					
gen control_nonfarmincome=1 if  control_businessincome== 1 
							  *| type_decision=="control_assistance" ///
							  *| type_decision=="control_remittance" ///
recode control_nonfarmincome (.=0)																		
collapse (max) control_* , by(HHID controller_income)  //any decision
gen control_all_income=1 if  control_farmincome== 1 | control_nonfarmincome==1
recode 	control_all_income (.=0)															
ren controller_income personid
*	Now merge with member characteristics
*tostring HHID, format(%18.0f) replace
ren personid PID 
tostring PID, format(%18.0f) replace
merge m:1 HHID PID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_person_ids.dta", nogen 
recode control_* (.=0)
lab var control_cropincome "1=invidual has control over crop income"
lab var control_livestockincome "1=invidual has control over livestock income"
lab var control_farmincome "1=invidual has control over farm (crop or livestock) income"
lab var control_nonfarmincome "1=invidual has control over non-farm (business) income"
lab var control_all_income "1=invidual has control over at least one type of income"

save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_control_income.dta", replace

******************************************************************************
            * WOMEN'S PARTICIPATION IN AGRICULTURAL DECISION MAKING *
********************************************************************************
**# Not complete
*Ahana: Similar to wave too not much can be done here...any thoughts?  No control question...can we bring in the person ids like last case and reattaempt this section? 
use "${Uganda_NPS_W1_raw_data}/2009_AGSEC3A", clear
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC3B"
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC5A"
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC5B"
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC6A"
gen type_decision=""
gen double decision_maker1=.
gen double decision_maker2=.


********************************************************************************
                      * WOMEN'S OWNERSHIP OF ASSETS *
********************************************************************************
*/
use "${Uganda_NPS_W1_raw_data}/2009_AGSEC2", clear
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC2A"
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC2B"
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC6A"
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC6B"
append using "${Uganda_NPS_W1_raw_data}/2009_AGSEC6C"
gen type_asset=""
gen double asset_owner1=.
gen double asset_owner2=.
replace type_asset="landowners" if !missing(A2bq24a) | !missing(A2bq24b)
replace asset_owner1=A2bq24a 
replace asset_owner2=A2bq24b
*append who has right to sell or use
*preserve
replace type_asset="landowners" if !missing(A2aq26a) | !missing(A2aq26b)
replace asset_owner1=A2aq26a if asset_owner1==.
replace asset_owner2=A2aq26b if asset_owner2==.
*Ownership of Livestock(Cattle and pack animals)
replace type_asset="livestockowners" if !missing(A6aq17a) | !missing(A6aq17b)
replace asset_owner1=A6aq17a if asset_owner1==.
replace asset_owner2=A6aq17b if asset_owner2==.
ren Hhid HHID
*Ownership of small animals - control question does not exist 
/*
replace type_asset="livestockowners" if !missing(A6bq17a) | !missing(A6bq17b)
replace asset_owner1=A6bq17a if asset_owner1==.
replace asset_owner2=A6bq17b if asset_owner2==.
*Ownership of Poultry and others
replace type_asset="livestockowners" if !missing(A6cq17a) | !missing(A6cq17b)
replace asset_owner1=A6cq17a if asset_owner1==.
replace asset_owner2=A6cq17b if asset_owner2==.
*/
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
*tostring HHID, format(%18.0f) replace
tostring PID, format(%18.0f) replace
* Now merge with member characteristics
merge 1:1 HHID PID  using  "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_person_ids.dta", nogen 
* 3 member ID in assed files not is member list
recode own_asset (.=0)
lab var own_asset "1=invidual owns an assets (land or livestock)"
drop if PID == ""/*19 observations deleted*/
duplicates drop PID, force /*1 observation deleted*/
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_ownasset.dta", replace

********************************************************************************
                          * AGRICULTURAL WAGES **
********************************************************************************
use "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_labor_long.dta", clear 
keep if strmatch(labor_type,"hired") & (strmatch(gender,"male") | strmatch(gender,"female"))
collapse (sum) wage_paid_aglabor_=val hired_=days, by(HHID gender)
reshape wide wage_paid_aglabor_ hired_, i(HHID) j(gender) string
egen wage_paid_aglabor = rowtotal(wage*)
egen hired_all = rowtotal(hired*)
lab var wage_paid_aglabor "Daily agricultural wage paid for hired labor (local currency)"
lab var wage_paid_aglabor_female "Daily agricultural wage paid for hired labor - female workers(local currency)"
lab var wage_paid_aglabor_male "Daily agricultural wage paid for hired labor - male workers (local currency)"
lab var hired_all "Total hired labor (number of persons days)"
lab var hired_female "Total hired labor (number of persons days) -female workers"
lab var hired_male "Total hired labor (number of persons days) -male workers"
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_ag_wage.dta", replace

********************************************************************************
                          * CROP YIELDS *
*******************************************************************************
use "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_all_plots.dta", clear

gen no_harvest = ha_harvest == .
gen area_plan = ha_planted
gen area_harv = ha_harvest
gen harvest = quant_harv_kg

gen mixed = "inter"
replace mixed = "pure" if purestand == 1

gen dm_gender2 = "unknown"
replace dm_gender2 = "male" if dm_gender == 1
replace dm_gender2 = "female" if dm_gender == 2
replace dm_gender2 = "mixed" if dm_gender == 3

foreach i in harvest area_plan area_harv {
	foreach j in inter pure {
		gen `i'_`j' = `i' if mixed == "`j'"
		foreach k in male female mixed {
			gen `i'_`j'_`k' = `i' if mixed == "`j'" & dm_gender2 == "`k'"
			capture confirm var `i'_`k'
			if _rc {
				gen `i'_`k' = `i' if dm_gender2 == "`k'"
			}
		}
	}
}

collapse (sum) harvest* area* (max) no_harvest, by(HHID crop_code)

unab vars : harvest* area*
foreach var in `vars' {
	replace `var' = . if `var' == 0 & no_harvest == 1
}

replace area_plan = . if area_plan == 0
replace area_harv = . if area_plan == . | (area_harv == 0 & no_harvest == 1)

unab vars2 : area_plan_*
local suffix : subinstr local vars2 "area_plan_" "", all
foreach var in `suffix' {
	replace area_plan_`var' = . if area_plan_`var' == 0
	replace harvest_`var' = . if area_plan_`var' == . | (harvest_`var' == 0 & no_harvest == 1)
	replace area_harv_`var' = . if area_plan_`var' == . | (area_harv_`var' == 0 & no_harvest == 1)
}

drop no_harvest

save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hh_crop_area_plan.dta", replace


/*
use "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_all_plots.dta", replace
*ren crop_code_master crop_code
//Legacy stuff- agquery gets handled above.
replace dm_gender = 3 if dm_gender==.
collapse (sum) /*area_harv_=ha_harvest*/ area_plan_=ha_planted harvest_=quant_harv_kg, by(HHID dm_gender purestand crop_code)
gen mixed = "inter" if purestand==0
replace mixed="pure" if purestand==1
gen dm_gender2="male"
replace dm_gender2="female" if dm_gender==2
replace dm_gender2="mixed" if dm_gender==3
drop dm_gender purestand
reshape wide harvest_ /*area_harv_*/ area_plan_, i(HHID dm_gender2 crop_code) j(mixed) string
ren area* area*_
ren harvest* harvest*_
reshape wide harvest* area*, i(HHID crop_code) j(dm_gender2) string
foreach i in harvest area_plan /*area_harv*/ {
	egen `i' = rowtotal (`i'_*)
	foreach j in inter pure {
		egen `i'_`j' = rowtotal(`i'_`j'_*) 
	}
	foreach k in male female mixed {
		egen `i'_`k' = rowtotal(`i'_*_`k')
	}
	
}
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hh_crop_area_plan.dta", replace
*/
*Total planted and harvested area summed accross all plots, crops, and seasons.
preserve
collapse (sum) /*all_area_harvested=area_harv*/ all_area_planted=area_plan, by(HHID)
*replace all_area_harvested=all_area_planted if all_area_harvested>all_area_planted & all_area_harvested!=.
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hh_area_planted_harvested_allcrops.dta", replace
restore
keep if inlist(crop_code, $comma_topcrop_area)
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_crop_harvest_area_yield.dta", replace

*Yield at the household level
use "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_crop_harvest_area_yield.dta", clear
*ren crop_code_master crop_code
*Value of crop production
merge m:1 crop_code using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_cropname_table.dta", nogen keep(1 3)
merge 1:1 HHID crop_code using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hh_crop_values_production.dta", nogen keep(1 3)
ren value_crop_production value_harv_
ren value_crop_sales value_sold_
foreach i in harvest area {
	ren `i'* `i'*_
}
gen total_planted_area_ = area_plan_
*gen total_harv_area_ = area_harv_ 
gen kgs_harvest_ = harvest_

drop crop_code kgs_sold quant_harv_kg 

unab vars : *_
reshape wide `vars', i(HHID) j(crop_name) string
collapse (sum) harvest* /*area_harv**/  area_plan* total_planted_area* /*total_harv_area**/ kgs_harvest* value_harv* value_sold* /*number_trees_planted**/  , by(HHID) 
recode harvest*   /*area_harv**/ area_plan* kgs_harvest* total_planted_area* /*total_harv_area**/ value_harv* value_sold* (0=.)
egen kgs_harvest = rowtotal(kgs_harvest_*)
la var kgs_harvest "Quantity harvested of all crops (kgs) (household) (summed accross all seasons)" 


*rename variables 
foreach p in $topcropname_area count {
if r(N)>0 {
*foreach p of global topcropname_area if _N!=0 {
	di "`p'"
	lab var value_harv_`p' "Value harvested of `p' (Naira) (household)" 
	lab var value_sold_`p' "Value sold of `p' (Naira) (household)" 
	lab var kgs_harvest_`p'  "Quantity harvested of `p' (kgs) (household) (summed accross all seasons)" 
	*lab var total_harv_area_`p'  "Total area harvested of `p' (ha) (household) (summed accross all seasons)" 
	lab var total_planted_area_`p'  "Total area planted of `p' (ha) (household) (summed accross all seasons)" 
	lab var harvest_`p' "Quantity harvested of `p' (kgs) (household)" 
	lab var harvest_male_`p' "Quantity harvested of `p' (kgs) (male-managed plots)" 
	lab var harvest_female_`p' "Quantity harvested of `p' (kgs) (female-managed plots)" 
	*lab var harvest_mixed_`p' "Quantity harvested of `p' (kgs) (mixed-managed plots)"
	lab var harvest_pure_`p' "Quantity harvested of `p' (kgs) - purestand (household)"
	lab var harvest_pure_male_`p'  "Quantity harvested of `p' (kgs) - purestand (male-managed plots)"
	lab var harvest_pure_female_`p'  "Quantity harvested of `p' (kgs) - purestand (female-managed plots)"
	*lab var harvest_pure_mixed_`p'  "Quantity harvested of `p' (kgs) - purestand (mixed-managed plots)"
	lab var harvest_inter_`p' "Quantity harvested of `p' (kgs) - intercrop (household)"
	lab var harvest_inter_male_`p' "Quantity harvested of `p' (kgs) - intercrop (male-managed plots)" 
	lab var harvest_inter_female_`p' "Quantity harvested of `p' (kgs) - intercrop (female-managed plots)"
	*lab var harvest_inter_mixed_`p' "Quantity harvested  of `p' (kgs) - intercrop (mixed-managed plots)" 
	lab var area_plan_`p' "Area planted of `p' (ha) (household)" 
	lab var area_plan_male_`p' "Area planted of `p' (ha) (male-managed plots)" 
	lab var area_plan_female_`p' "Area planted of `p' (ha) (female-managed plots)" 
	*lab var area_plan_mixed_`p' "Area planted of `p' (ha) (mixed-managed plots)"
	lab var area_plan_pure_`p' "Area planted of `p' (ha) - purestand (household)"
	lab var area_plan_pure_male_`p'  "Area planted of `p' (ha) - purestand (male-managed plots)"
	lab var area_plan_pure_female_`p'  "Area planted of `p' (ha) - purestand (female-managed plots)"
	*lab var area_plan_pure_mixed_`p'  "Area planted of `p' (ha) - purestand (mixed-managed plots)"
	lab var area_plan_inter_`p' "Area planted of `p' (ha) - intercrop (household)"
	lab var area_plan_inter_male_`p' "Area planted of `p' (ha) - intercrop (male-managed plots)" 
	lab var area_plan_inter_female_`p' "Area planted of `p' (ha) - intercrop (female-managed plots)"
	*lab var area_plan_inter_mixed_`p' "Area planted  of `p' (ha) - intercrop (mixed-managed plots)"
}
}

foreach p of global topcropname_area {
    count
    capture confirm variable total_planted_area_`p'
    if !_rc {
        gen grew_`p' = (total_planted_area_`p' != . & total_planted_area_`p' != 0)
        lab var grew_`p' "1=Household grew `p'" 
    }
    else {
        di "Variable total_planted_area_`p' does not exist. Skipping..."
    }
}

*replace grew_banana =1 if  number_trees_planted_banana!=0 & number_trees_planted_banana!=. 
*replace grew_cassav =1 if number_trees_planted_cassava!=0 & number_trees_planted_cassava!=. 
*replace grew_cocoa =1 if number_trees_planted_cocoa!=0 & number_trees_planted_cocoa!=. 
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_yield_hh_crop_level.dta", replace

* VALUE OF CROP PRODUCTION  // using 335 output
use "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hh_crop_values_production.dta", replace
*Grouping following IMPACT categories but also mindful of the consumption categories.
recode crop_code 	(210/222			=1	"Beans and Cowpeas" )  ////   Beans, ,Cow peas
					(630  					=2	"Cassava"	)  //// 630 Cassava, 
					(520	 				=3	"Cotton"	)  ////	
					(650					=4	"Coco yam"	)  ////	
					(310 						=5	"Groundnuts"	)  ////					
					(150							=6	"Sorgum"	)  ////
					(130						=7  "Maize") ///
					(700 710 720 750 760 770 780 					=8	"Fruits") /// oranges, paw paw, pineapples, mango, jackfruit, avocado, passion fruit 
					(141						=9	"Millet")  //// finger Millet
					(120   					=10	"Rice"	)  ////
					(640				=11	"Yam"	)  //// 
					(221 223 224 =12 "Other nuts,seeds, and pulses"	)  ////  221  223 224 field peas, pigeon peas, chick peas,
					(741 742 744						=13	"Bananas")  ////  banana food, banana beer, banana swwet
					(410 420 440 450 460 470   					=14	"Vegetables"	)  ////  cabbage, tomatoes, onions, pumpkins, dodo, egglplants 
					(890 =15 "Other"	)  //// 
					(610						=16	"Potato")  ////  
					(620 					=17	"Sweet Potato"	)  ////  
					(320				=18	"Soya beans"	)  //// 
					(510 =19 "Sugar"	)  //// 
					(111						=20	"Wheat")  ////  
					(820					=21	"Cocoa"	)  ////  
					(830					=22	"Tea"	)  ////  
					(870					=23	"Vanilla"	)  ////  
					(320				=11	"Oils and Fat"	)  //// 
					(810 =24 "Coffee all"	)  //// 
					(330 =25 "Sunflower"	)  //// 
					(340 =26 "Simsim"	)  //// 
					(530 =27 "Tobacco"	)  //// 
					,generate(commodity)

gen type_commodity=	""
replace type_commodity = "Low" if inlist(commodity, 13, 2, 4, 7, 9, 12, 16, 6, 17, 11) 
/// banans, cassava, cocoyam, maize, millet, other nuts and seeds, potato, sorghum , sweet potato, yam 
replace type_commodity = "High" if inlist(commodity, 1, 21, 8, 5, 10, 18, 14, 13) 
/// beans and cowpeas, cocoa, fruits, groundnuts, rice, soybeans vegetables, bananas, 
replace type_commodity = "Out" if inlist(commodity, 3, 11, 19) 
/// cotton, oils n fats, sugar

preserve
collapse (sum) value_crop_production value_crop_sales, by(HHID commodity) 
ren value_crop_production value_pro
ren value_crop_sales value_sal
separate value_pro, by(commodity)
separate value_sal, by(commodity)
foreach s in pro sal {
	ren value_`s'1 value_`s'_beanc 
	ren value_`s'2 value_`s'_casav 
	ren value_`s'3 value_`s'_coton 
	ren value_`s'4 value_`s'_cyam 
	ren value_`s'5 value_`s'_gdnut 
	ren value_`s'6 value_`s'_sorg 
	ren value_`s'7 value_`s'_maize
	ren value_`s'8 value_`s'_fruit
	ren value_`s'9 value_`s'_mill 
	ren value_`s'10 value_`s'_rice
	ren value_`s'11 value_`s'_oilc
	ren value_`s'12 value_`s'_onuts 
	ren value_`s'13 value_`s'_bana
	ren value_`s'14 value_`s'_vegs
	ren value_`s'15 value_`s'_oths
	ren value_`s'16 value_`s'_pota 
	ren value_`s'17 value_`s'_spota
	ren value_`s'18 value_`s'_sybea
	ren value_`s'19 value_`s'_suga
	ren value_`s'20 value_`s'_whea
	ren value_`s'21 value_`s'_cocoa
	ren value_`s'22 value_`s'_tea 
	ren value_`s'23 value_`s'_vanil
	ren value_`s'24 value_`s'_coffe
	ren value_`s'25 value_`s'_sunfl
	ren value_`s'26 value_`s'_simsim
	ren value_`s'27 value_`s'_tobac
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
collapse (sum) value_*, by(HHID)
foreach x of varlist value_* {
	lab var `x' "`l`x''"
}

drop value_pro value_sal
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hh_crop_values_production_grouped.dta", replace
restore

collapse (sum) value_crop_production value_crop_sales, by(HHID type_commodity) 
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
collapse (sum) value_*, by(HHID)
foreach x of varlist value_* {
	lab var `x' "`l`x''"
}
drop value_pro value_sal
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hh_crop_values_production_type_crop.dta", replace

********************************************************************************
                          * SHANNON DIVERSITY INDEX *
*******************************************************************************
use "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hh_crop_area_plan.dta", replace
drop if area_plan==0 
preserve 
collapse (sum) area_plan_hh=area_plan area_plan_female_hh=area_plan_female area_plan_male_hh=area_plan_male area_plan_mixed_hh=area_plan_mixed, by(HHID)
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hh_crop_area_plan_shannon.dta", replace
restore
merge m:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hh_crop_area_plan_shannon.dta", nogen	
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
bysort HHID (sdi_crop_female) : gen allmissing_female = mi(sdi_crop_female[1])
bysort HHID (sdi_crop_male) : gen allmissing_male = mi(sdi_crop_male[1])
bysort HHID (sdi_crop_mixed) : gen allmissing_mixed = mi(sdi_crop_mixed[1])
*Generating number of crops per household
bysort HHID crop_code : gen nvals_tot = _n==1
gen nvals_female = nvals_tot if area_plan_female!=0 & area_plan_female!=.
gen nvals_male = nvals_tot if area_plan_male!=0 & area_plan_male!=. 
gen nvals_mixed = nvals_tot if area_plan_mixed!=0 & area_plan_mixed!=.
collapse (sum) sdi=sdi_crop sdi_female=sdi_crop_female sdi_male=sdi_crop_male sdi_mixed=sdi_crop_mixed num_crops_hh=nvals_tot num_crops_female=nvals_female ///
num_crops_male=nvals_male num_crops_mixed=nvals_mixed (max) allmissing_female allmissing_male allmissing_mixed, by(HHID)
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
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_shannon_diversity_index.dta", replace

********************************************************************************
                          * CONSUMPTION *
********************************************************************************
use "${Uganda_NPS_W1_raw_data}/pov2009_10", clear
ren nrrexp  total_cons 
*ren cpexp30  total_cons 
ren equiv_m adulteq
ren welfare peraeq_cons
ren hhid HHID
tostring HHID, format(%18.0f) replace
merge 1:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_weights.dta", nogen keep(1 3) // all merges 

gen percapita_cons = (total_cons / hh_members)
gen daily_peraeq_cons = peraeq_cons/30
gen daily_percap_cons = percapita_cons/30 
lab var total_cons "Total HH consumption, in 05/06 prices, spatially and temporally adjusted in 11/12"
lab var peraeq_cons "Consumption per adult equivalent, in 05/06 prices, spatially and temporally adjusted in 11/12"
lab var percapita_cons "Consumption per capita, in 05/06 prices, spatially and temporally adjusted in 11/12"
lab var daily_peraeq_cons "Daily consumption per adult equivalent, in 05/06 prices, spatially and temporally adjusted in 11/12"
lab var daily_percap_cons "Daily consumption per capita, in 05/06 prices, spatially and temporally adjusted in 11/12" 
keep HHID total_cons peraeq_cons percapita_cons daily_peraeq_cons daily_percap_cons adulteq poor09
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_consumption.dta", replace

**We create an adulteq dataset for summary statistics sections
use "${Uganda_NPS_W1_raw_data}/UNPS 2009-10 Consumption Aggregate.dta", clear
rename equiv adulteq
keep HHID adulteq
tostring HHID, format(%18.0f) replace
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hh_adulteq.dta", replace

********************************************************************************
                          * FOOD SECURITY *
********************************************************************************

use "${Uganda_NPS_W1_raw_data}/2009_GSEC15B", clear
destring HHID, replace 
rename h15bq5 fd_home
rename h15bq7 fd_awayhome
rename h15bq9 fd_ownp
rename h15bq11 fd_gift
egen food_total = rowtotal(fd*) 
collapse (sum) fd* food_total, by(HHID)
duplicates report HHID
merge 1:1 HHID using "${Uganda_NPS_W1_raw_data}/UNPS 2009-10 Consumption Aggregate.dta", nogen keep(1 3)
tostring HHID, format(%18.0f) replace
merge 1:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_weights.dta", nogen keep(1 3)
drop if equiv ==.
recode fd* food_total (0=.)
gen daily_peraeq_fdcons = food_total/equiv /365 
gen daily_percap_fdcons = food_total/hh_members/365
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_food_cons.dta", replace

********************************************************************************
                          * FOOD PROVISION *
********************************************************************************
use "${Uganda_NPS_W1_raw_data}/2009_GSEC17A", clear //Have you been faced with a situation when you did not have enough food to feed in the last 12 months Yes/No answer? Maybe this works? The questionnaire includes months when this happened but the actual dataset does not. 
*append using "${Uganda_NPS_W1_raw_data}/2009_GSEC17"
gen food_insecurity = 1 if h17q09==1
replace food_insecurity = 0 if food_insecurity==.
collapse (sum) months_food_insec= food_insecurity, by(HHID)
lab var months_food_insec "Number of months where the household experienced any food insecurity" 
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_food_insecurity.dta", replace

********************************************************************************
                          *HOUSEHOLD ASSETS*
********************************************************************************
*SW 1.19.23 This section is written using Nigeria Wave 3 as reference. (Available for Uganda wave 7 as well)
use "${Uganda_NPS_W1_raw_data}/2009_GSEC14", clear 
rename h14q5 value_today
rename h14q4 num_items
*dropping items if hh doesnt report owning them 
keep if h14q3==1
collapse (sum) value_assets=value_today, by(HHID)
la var value_assets "Value of household assets in Shs"
format value_assets %20.0g
save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hh_assets.dta", replace

********************************************************************************
                         *DISTANCE TO AGRO DEALERS*
********************************************************************************
*Cannot create in this instrument

********************************************************************************

********************************************************************************
                          *HOUSEHOLD VARIABLES*
********************************************************************************

global empty_vars ""
use "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hhids.dta", clear
merge 1:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hh_adulteq.dta", nogen keep(1 3)
*Gross crop income
merge 1:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hh_crop_production.dta", nogen keep(1 3)
merge 1:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_crop_losses.dta", nogen keep(1 3)
recode value_crop_production crop_value_lost (.=0)

* Production by group and type of crops
merge 1:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hh_crop_values_production_grouped.dta", nogen
merge 1:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hh_crop_values_production_type_crop.dta", nogen
recode value_pro* value_sal* (.=0)
merge 1:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hh_cost_inputs.dta", nogen

*Crop Costs
//Merge in summarized crop costs:
gen crop_production_expenses = cost_expli_hh
gen crop_income = value_crop_production - crop_production_expenses - crop_value_lost
lab var crop_production_expenses "Crop production expenditures (explicit)"
lab var crop_income "Net crop revenue (value of production minus crop expenses)"
*top crop costs by area planted

foreach c in $topcropname_area { 
	 merge 1:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_inputs_`c'.dta", nogen
	 merge 1:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_`c'_monocrop_hh_area.dta", nogen
}

//setting up empty variable list: create these with a value of missing and then recode all of these to missing at the end of the HH section (some may be recoded to 0 in this section)
foreach c in $topcropname_area {
	recode `c'_monocrop (.=0) 
*disaggregate by gender of plot manager
foreach i in male female mixed hh {
	egen `c'_exp_`i' = rowtotal(/*val_anml_`c'_`i'*/ val_mech_`c'_`i' val_labor_`c'_`i' val_pest_`c'_`i' val_inorg_`c'_`i' val_orgfert_`c'_`i' val_plotrent_`c'_`i' val_seeds_`c'_`i' /*val_transfert_`c'_`i' val_seedtrans_`c'_`i'*/) //These are already narrowed to explicit costs
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

//drop rental_cost_land* cost_seed* value_fertilizer* cost_trans_fert* value_herbicide* value_pesticide* value_manure_purch* cost_trans_manure*
drop /*val_anml* val_mech**/ val_labor* /*val_herb**/ val_inorg* val_orgfert* val_plotrent* val_seeds* /*val_transfert* val_seedtrans**/ val_pest* val_parcelrent* //

*Land rights

merge 1:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_land_rights_hh.dta", nogen keep(1 3)
la var formal_land_rights_hh "Household has documentation of land rights (at least one plot)"

*Fish Income // SAW No fish income for Uganda wave 3 
gen fish_income_fishfarm = 0
gen fish_income_fishing =0
gen fishing_income = 0
lab var fish_income_fishing "Net fishing income (value of production and consumption minus expenditures)"
lab var fish_income_fishfarm "Net fish farm income (value of production minus expenditures)"
lab var fishing_income "Net fishing income (value of production and consumption minus expenditures)"

//adding - starting list of missing variables - recode all of these to missing at end of HH level file
global empty_vars $empty_vars fish_income*

*Livestock income
merge 1:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_livestock_sales.dta", nogen keep(1 3)
merge 1:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_livestock_expenses.dta", nogen keep(1 3)
merge 1:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_livestock_products.dta", nogen keep(1 3)
merge 1:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_TLU.dta", nogen keep(1 3)
merge 1:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_herd_characteristics.dta", nogen keep(1 3)
ren HHID Hhid
merge 1:1 Hhid using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_TLU_Coefficients.dta", nogen keep(1 3)
ren Hhid HHID
lab var sales_livestock_products "Value of sales of livestock products"
lab var value_livestock_products "Value of livestock products"
recode value_livestock_sales value_livestock_purchases value_milk_produced  value_eggs_produced /*value_other_produced fish_income_fishfarm*/  cost_*livestock (.=0)
gen livestock_income = value_slaughtered + value_lvstck_sold - value_livestock_purchases /*
*/ + ( value_milk_produced + value_eggs_produced/*value_other_produced*/) /*
*/ - ( cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_water_livestock + cost_other_livestock) /*fish_income_fishfarm*/
*Notes: SAW should we include value of livestock products here?
recode livestock_income (.=0)
lab var livestock_income "Net livestock income (value of production and consumption minus expenditures)"
*gen livestock_expenses = ( cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_other_livestock)
gen livestock_expenses = (cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_water_livestock + cost_other_livestock)
lab var livestock_expenses "Expenditures on livestock purchases and maintenance"
ren cost_vaccines_livestock ls_exp_vac 
gen livestock_product_revenue = ( value_milk_produced + value_eggs_produced /*value_other_produced*/)
lab var livestock_product_revenue "Gross revenue from sale of livestock products"
lab var sales_livestock_products "Value of sales of livestock products"
lab var value_livestock_products "Value of livestock products"
gen animals_lost12months =0 
gen mean_12months=0
la var animals_lost12months "Total number of livestock  lost to disease"
la var mean_12months "Average number of livestock  today and 1  year ago"
*gen any_imp_herd_all = . 
foreach v in ls_exp_vac /*any_imp_herd*/{
foreach i in lrum srum poultry {
	gen `v'_`i' = .
	}
}
//adding - starting list of missing variables - recode all of these to missing at end of HH level file
global empty_vars $empty_vars animals_lost12months mean_12months /*ls_exp_vac_lrum* *ls_exp_vac_srum* *ls_exp_vac_poultry* any_imp_herd_*/

*Self-employment income
merge 1:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_self_employment_income.dta", nogen keep(1 3)
*merge 1:1 HHID using  "${UGA_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_agproducts_profits.dta", nogen keep(1 3)
*SAW: This dataset it is not calculated in Uganda waves. Want to make sure the reason why (not available or it is already part of the self_employment_income dta)
egen self_employment_income = rowtotal(/*profit_processed_crop_sold*/ annual_selfemp_profit)
recode self_employment_income (.=0)
lab var self_employment_income "Income from self-employment (business)"

*Wage income
merge 1:1 HHID using  "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_agwage_income.dta", nogen keep(1 3)
merge 1:1 HHID using  "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_wage_income.dta", nogen keep(1 3)
recode annual_salary annual_salary_agwage (.=0)
ren annual_salary nonagwage_income
ren annual_salary_agwage agwage_income

*Off-farm hours
merge 1:1 HHID using  "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_off_farm_hours.dta", nogen keep(1 3)

*Other income
merge 1:1 HHID using  "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_other_income.dta", nogen keep(1 3)
*merge 1:1 HHID using  "${UGA_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_remittance_income.dta", nogen keep(1 3)
*SAW: Remittance income is already included in the other income dataset. (Need to check why)
egen transfers_income = rowtotal (remittance_income pension_income)
*SAW There is a confusion between remittance income and assistance income in the UGanda Other Income section that needs to be revised.
lab var transfers_income "Income from transfers including pension, remittances, and assisances)"
egen all_other_income = rowtotal (rental_income other_income)
lab var all_other_income "Income from other revenue streams not captured elsewhere"
drop other_income

*Farm Size
merge 1:1 HHID using  "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_land_size.dta", nogen keep(1 3)
merge 1:1 HHID using  "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_land_size_all.dta", nogen keep(1 3)
merge 1:1 HHID using  "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_farmsize_all_agland.dta", nogen keep(1 3)
merge 1:1 HHID using  "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_land_size_total.dta", nogen keep(1 3)
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
//Fix
merge 1:1 HHID using  "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_family_hired_labor.dta", nogen keep(1 3)
recode labor_hired labor_family (.=0) 

*Household size
merge 1:1 HHID using  "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_weights.dta", nogen keep(1 3)

*Rates of vaccine usage, improved seeds, etc.
merge 1:1 HHID using  "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_vaccine.dta", nogen keep(1 3)
*merge 1:1 HHID using  "${UGA_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_fert_use.dta", nogen keep(1 3)
*merge 1:1 HHID using  "${UGA_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_improvedseed_use.dta", nogen keep(1 3)
merge 1:1 HHID using  "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_input_use.dta", nogen keep(1 3)
*SAW: This Input Use dataset comes from the Plot Manager section that is constructed in the Nigeria Wave 3 do file which includes fert use and improved seed use along pesticides and fertilizers into one single dataset. We might want to construct this section in Uganda for fewer lines of code in the future. (It comes adter the Fertilizer Use and Improved Seed sections in Uganda)
merge 1:1 HHID using  "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_imprvseed_crop.dta", nogen keep(1 3)
merge 1:1 HHID using  "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_any_ext.dta", nogen keep(1 3)
*merge 1:1 HHID using  "${UGA_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_fin_serv.dta", nogen keep(1 3) // SAW Not Available for Uganda Wave 3 dta missing
ren use_imprv_seed imprv_seed_use //ALT 02.03.22: Should probably fix code to align this with other inputs.
ren use_hybrid_seed hybrid_seed_use
recode /*use_fin_serv**/ ext_reach* use_inorg_fert imprv_seed_use vac_animal (.=0)
replace vac_animal=. if tlu_today==0 
replace use_inorg_fert=. if farm_area==0 | farm_area==. // Area cultivated this year
recode ext_reach* (0 1=.) if (value_crop_production==0 & livestock_income==0 & farm_area==0 & farm_area==. &  tlu_today==0)
replace imprv_seed_use=. if farm_area==.  
global empty_vars $empty_vars hybrid_seed*

*Milk productivity
merge 1:1 HHID using  "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_milk_animals.dta", nogen keep(1 3)
gen costs_dairy = .
gen costs_dairy_percow = .
la var costs_dairy "Dairy production cost (explicit)"
la var costs_dairy_percow "Dairy production cost (explicit) per cow"
gen liters_per_cow = . 
gen liters_per_buffalo = . 
gen share_imp_dairy = . 
*gen milk_animals = . 
global empty_vars $empty_vars *costs_dairy* *costs_dairy_percow* share_imp_dairy /*liters_per_cow *liters_per_largerruminant*/

*Egg productivity
merge 1:1 HHID using  "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_eggs_animals.dta", nogen keep(1 3) // eggs_months eggs_per_month eggs_total_year poultry_owned
*gen liters_milk_produced = milk_months_produced * milk_quantity_produced // SAW 2.20.23 Decided to produce this in the milk productivity section
*lab var liters_milk_produced "Total quantity (liters) of milk per year (household)"
*gen eggs_total_year =eggs_quantity_produced * eggs_months_produced
*lab var eggs_total_year "Total number of eggs that was produced (household)"
gen egg_poultry_year = . 
*gen poultry_owned = .
global empty_vars $empty_vars *egg_poultry_year


*Costs of crop production per hectare
*merge 1:1 HHID  using  "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_cropcosts.dta", nogen keep(1 3)
 
*Rate of fertilizer application 
merge 1:1 HHID using  "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_fertilizer_application.dta", nogen keep(1 3)


*Agricultural wage rate
merge 1:1 HHID using  "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_ag_wage.dta", nogen keep(1 3)


*Crop yields 
merge 1:1 HHID using  "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_yield_hh_crop_level.dta", nogen keep(1 3)


*Total area planted and harvested accross all crops, plots, and seasons
merge 1:1 HHID using  "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hh_area_planted_harvested_allcrops.dta", nogen keep(1 3)

 
*Household diet
merge 1:1 HHID using  "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_household_diet.dta", nogen keep(1 3)


*consumption 
merge 1:1 HHID using  "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_consumption.dta", nogen keep(1 3)

*Household assets
merge 1:1 HHID using  "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hh_assets.dta", nogen keep(1 3)

*Food insecurity
merge 1:1 HHID using  "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_food_insecurity.dta", nogen keep(1 3)
gen hhs_little = . 
gen hhs_moderate = . 
gen hhs_severe = . 
gen hhs_total = . 
global empty_vars $empty_vars hhs_* 

*SAW 3/14/23 The section Food Security and Food Consumption at the hh level has not been included yet in nigeria and uganda even though it is available. Any reasons why?

*Distance to agrodealer // cannot construct 
gen dist_agrodealer = . 
global empty_vars $empty_vars *dist_agrodealer

*Livestock health // cannot construct
gen disease_animal=. 
global empty_vars $empty_vars disease_animal* disease_* 

*CPK: don't have livestock feeding, water, and housing section
*merge 1:1 HHID using  "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_livestock_feed_water_house.dta", nogen keep(1 3)

*Shannon Diversity index
merge 1:1 HHID using  "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_shannon_diversity_index.dta", nogen keep(1 3)

*Farm Production 
recode value_crop_production  value_livestock_products value_slaughtered  value_lvstck_sold (.=0)
gen value_farm_production = value_crop_production + value_livestock_products + value_slaughtered + value_lvstck_sold
lab var value_farm_production "Total value of farm production (crops + livestock products)"
gen value_farm_prod_sold = value_crop_sales + sales_livestock_products + value_livestock_sales 
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
lab  var fishing_hh "1= Household has some fishing income" // SAW Not Available

****getting correct subpopulations***** 
*Recoding missings to 0 for households growing crops
recode grew* (.=0)
*all rural households growing specific crops 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode value_harv_`cn' value_sold_`cn' kgs_harvest_`cn' total_planted_area_`cn' /*total_harv_area_`cn'*/ `cn'_exp (.=0) if grew_`cn'==1
	recode value_harv_`cn' value_sold_`cn' kgs_harvest_`cn' total_planted_area_`cn' /*total_harv_area_`cn'*/ `cn'_exp (nonmissing=.) if grew_`cn'==0
}

*all rural households engaged in livestock production of a given species - CPK: don't have the Livestock Water, Feeding, and Housing section so can't do this loop
/*
foreach i in lrum srum poultry {
	recode lost_disease_`i' ls_exp_vac_`i' /*disease_animal_`i'*/ feed_grazing_`i' water_source_nat_`i' water_source_const_`i' water_source_cover_`i' lvstck_housed_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode lost_disease_`i' ls_exp_vac_`i' /*disease_animal_`i'*/ feed_grazing_`i' water_source_nat_`i' water_source_const_`i' water_source_cover_`i' lvstck_housed_`i'(.=0) if lvstck_holding_`i'==1	
}
*/
*households engaged in crop production


recode cost_expli_hh value_crop_production value_crop_sales labor_hired labor_family farm_size_agland /*all_area_harvested*/ all_area_planted  encs num_crops_hh multiple_crops (.=0) if crop_hh==1
recode cost_expli_hh value_crop_production value_crop_sales labor_hired labor_family farm_size_agland /*all_area_harvested*/ all_area_planted  encs num_crops_hh multiple_crops (nonmissing=.) if crop_hh==0

*all rural households engaged in livestock production 
recode animals_lost12months* mean_12months* livestock_expenses disease_animal /*feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed*/ (.=0) if livestock_hh==1
recode animals_lost12months* mean_12months* livestock_expenses disease_animal /*feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed*/ (nonmissing=.) if livestock_hh==0		

*all rural households 
recode /*DYA.10.26.2020*/ /*hrs_ag_activ hrs_wage_off_farm hrs_wage_on_farm hrs_unpaid_off_farm hrs_domest_fire_fuel hrs_off_farm hrs_on_farm hrs_domest_all hrs_other_all hrs_self_off_farm*/ off_farm_hours off_farm_any_count crop_income livestock_income self_employment_income nonagwage_income agwage_income /*fishing_income*/ transfers_income all_other_income value_assets (.=0)
*all rural households engaged in dairy production
recode costs_dairy liters_milk_produced value_milk_produced (.=0) if dairy_hh==1 		
recode costs_dairy liters_milk_produced value_milk_produced (nonmissing=.) if dairy_hh==0		
*all rural households eith egg-producing animals
recode eggs_total_year value_eggs_produced (.=0) if egg_hh==1
recode eggs_total_year value_eggs_produced (nonmissing=.) if egg_hh==0

global gender "female male mixed" //ALT 08.04.21
*Variables winsorized at the top 1% only 

global wins_var_top1 value_crop_production value_crop_sales value_harv* value_sold* kgs_harv* /*kgs_harv_mono*/ total_planted_area* /*total_harv_area*/ labor_hired labor_family animals_lost12months mean_12months /*lost_disease*/ liters_milk_produced costs_dairy eggs_total_year value_eggs_produced value_milk_produced off_farm_hours off_farm_any_count crop_production_expenses value_assets cost_expli_hh livestock_expenses ls_exp_vac* sales_livestock_products value_livestock_products value_livestock_sales value_farm_production value_farm_prod_sold  value_pro* value_sal*

gen wage_paid_aglabor_mixed=. //create this just to make the loop work and delete after
foreach v of varlist $wins_var_top1 {
	_pctile `v' [aw=weight] , p($wins_upper_thres)  
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' -Winzorized top ${wins_upper_thres}%"
}

*Variables winsorized at the top 1% only - for variables disaggregated by the gender of the plot manager
global wins_var_top1_gender=""
foreach v in $topcropname_area {
	global wins_var_top1_gender $wins_var_top1_gender `v'_exp
}
gen cost_total = cost_total_hh
gen cost_expli = cost_expli_hh //ALT 08.04.21: Kludge til I get names fully consistent
*global wins_var_top1_gender $wins_var_top1_gender cost_total cost_expli inorg_fert_kg wage_paid_aglabor
global wins_var_top1_gender $wins_var_top1_gender cost_total cost_expli /*fert_inorg_kg*/ inorg_fert_kg org_fert_kg n_kg p_kg k_kg pest_kg wage_paid_aglabor


foreach v of varlist $wins_var_top1_gender {
	_pctile `v' [aw=weight] , p($wins_upper_thres)  
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top ${wins_upper_thres}%"
	
	*some variables are disaggreated by gender of plot manager. For these variables, we use the top 1% percentile to winsorize gender-disagregated variables
	foreach g of global gender {
		gen w_`v'_`g'=`v'_`g'
		replace  w_`v'_`g' = r(r1) if w_`v'_`g' > r(r1) & w_`v'_`g'!=.
		local l`v'_`g' : var lab `v'_`g'
		lab var  w_`v'_`g'  "`l`v'_`g'' - Winzorized top ${wins_upper_thres}%"
	}
}


drop *wage_paid_aglabor_mixed
egen w_labor_total=rowtotal(w_labor_hired w_labor_family)
local llabor_total : var lab labor_total 
lab var w_labor_total "`labor_total' - Winzorized top ${wins_upper_thres}%"

*Variables winsorized both at the top 1% and bottom 1% 
global wins_var_top1_bott1  /* 
*/ farm_area farm_size_agland /*all_area_harvested*/ all_area_planted ha_planted /*
*/ crop_income livestock_income /*fishing_income*/ self_employment_income nonagwage_income agwage_income transfers_income all_other_income total_cons percapita_cons daily_percap_cons peraeq_cons daily_peraeq_cons /* 
*/ *_monocrop_ha* /*dist_agrodealer*/ land_size_total

foreach v of varlist $wins_var_top1_bott1 {
	_pctile `v' [aw=weight] , p($wins_lower_thres $wins_upper_thres) 
	gen w_`v'=`v'
	replace w_`v'= r(r1) if w_`v' < r(r1) & w_`v'!=. & w_`v'!=0  /* we want to keep actual zeros */
	replace w_`v'= r(r2) if  w_`v' > r(r2)  & w_`v'!=.		
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top ${wins_upper_thres}% and bottom ${wins_lower_thres}%"
	*some variables  are disaggreated by gender of plot manager. For these variables, we use the top and bottom 1% percentile to winsorize gender-disagregated variables
	if "`v'"=="ha_planted" {
		foreach g of global gender {
			gen w_`v'_`g'=`v'_`g'
			replace w_`v'_`g'= r(r1) if w_`v'_`g' < r(r1) & w_`v'_`g'!=. & w_`v'_`g'!=0  /* we want to keep actual zeros */
			replace w_`v'_`g'= r(r2) if  w_`v'_`g' > r(r2)  & w_`v'_`g'!=.		
			local l`v'_`g' : var lab `v'_`g'
			lab var  w_`v'_`g'  "`l`v'_`g'' - Winzorized top ${wins_upper_thres}% and bottom ${wins_lower_thres}%"		
		}		
	}
}


*Winsorizing variables that go into yield at the top and bottom 5% //IHS 10.2.19
global allyield male female mixed inter inter_male inter_female inter_mixed pure  pure_male pure_female pure_mixed
global wins_var_top1_bott1_2 /*area_harv*/  area_plan harvest //ALT 08.04.21: Breaking here. To do: figure out where area_harv comes from.
foreach v of global wins_var_top1_bott1_2 {
	foreach c of global topcropname_area {
		_pctile `v'_`c'  [aw=weight] , p(1 99)
		gen w_`v'_`c'=`v'_`c'
		replace w_`v'_`c' = r(r1) if w_`v'_`c' < r(r1)   &  w_`v'_`c'!=0 
		replace w_`v'_`c' = r(r2) if (w_`v'_`c' > r(r2) & w_`v'_`c' !=.)  		
		local l`v'_`c'  : var lab `v'_`c'
		lab var  w_`v'_`c' "`l`v'_`c'' - Winzorized top ${wins_95_thres}% and bottom ${wins_5_thres}%"	
		* now use pctile from area for all to trim gender/inter/pure area
		foreach g of global allyield {
			gen w_`v'_`g'_`c'=`v'_`g'_`c'
			replace w_`v'_`g'_`c' = r(r1) if w_`v'_`g'_`c' < r(r1) &  w_`v'_`g'_`c'!=0 
			replace w_`v'_`g'_`c' = r(r2) if (w_`v'_`g'_`c' > r(r2) & w_`v'_`g'_`c' !=.)  	
			local l`v'_`g'_`c'  : var lab `v'_`g'_`c'
			lab var  w_`v'_`g'_`c' "`l`v'_`g'_`c'' - Winzorized top ${wins_95_thres}% and bottom ${wins_5_thres}%"
			
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
 
  /*Yield by Area Harvested // SAW 2.20.23 Area Harvest not available 
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
} */

*generate inorg_fert_rate, costs_total_ha, and costs_explicit_ha using winsorized values
foreach v in inorg_fert org_fert n p k /*herb*/ pest /*urea npk*/ {
	gen `v'_rate=w_`v'_kg/w_ha_planted
	foreach g of global gender {
		gen `v'_rate_`g'=w_`v'_kg_`g'/ w_ha_planted_`g'	
	}
}

gen cost_total_ha=w_cost_total/w_ha_planted 
gen cost_expli_ha=w_cost_expli/w_ha_planted				
gen cost_explicit_hh_ha=w_cost_expli_hh/w_ha_planted
foreach g of global gender {
	gen cost_total_ha_`g'=w_cost_total_`g'/ w_ha_planted_`g' 
	gen cost_expli_ha_`g'=w_cost_expli_`g'/ w_ha_planted_`g' 
}

lab var inorg_fert_rate "Rate of fertilizer application (kgs/ha) (household)"
lab var org_fert_rate "Rate of organic fertilizer application (kgs/ha) (household)"
lab var n_rate "Rate of nitrogen application (kgs/ha) (household)"
lab var k_rate "Rate of postassium application (kgs/ha) (household)"
lab var p_rate "Rate of phosphorus appliction (kgs/ha) (household)"
lab var pest_rate "Rate of pesticide application (kgs/ha) (household)"
*lab var herb_rate "Rate of herbicide application (kgs/ha) (household)"
*lab var urea_rate "Rate of urea application (kgs/ha) (household)"
*lab var npk_rate "Rate of NPK fertilizer application (kgs/ha) (household)" 

foreach g in $gender {
lab var inorg_fert_rate_`g' "Rate of fertilizer application (kgs/ha) (`g'-managed crops)"
lab var cost_total_ha_`g' "Explicit  implicit costs (per ha) of crop production (`g'-managed plots)"
lab var cost_expli_ha_`g' "Explicit costs (per ha) of crop production (`g'-managed plots)"
lab var org_fert_rate_`g' "Rate of organic fertilizer application (kgs/ha) (`g'-managed plots)"
lab var n_rate_`g' "Rate of nitrogen application (kgs/ha) (`g'-managed plots)"
lab var k_rate_`g' "Rate of postassium application (kgs/ha) (`g'-managed plots)"
lab var p_rate_`g' "Rate of phosphorus appliction (kgs/ha) (`g'-managed plots)"
lab var pest_rate_`g' "Rate of pesticide application (kgs/ha) (`g'-managed plots)"
*lab var herb_rate_`g' "Rate of herbicide application (kgs/ha) (`g'-managed plots)"
*lab var urea_rate_`g' "Rate of urea application (kgs/ha) (`g'-managed plots)"
*lab var npk_rate_`g' "Rate of NPK fertilizer application (kgs/ha) (`g'-managed plots)"
}

lab var cost_total_ha "Explicit  implicit costs (per ha) of crop production (household level)"		
lab var cost_expli_ha "Explicit costs (per ha) of crop production (household level)"
lab var cost_explicit_hh_ha "Explicit costs (per ha) of crop production (household level)"


/*
*generate inorg_fert_rate, costs_total_ha, and costs_explicit_ha using winsorized values
gen inorg_fert_rate = w_inorg_fert_kg/w_ha_planted
gen cost_total_ha = w_cost_total / w_ha_planted
gen cost_expli_ha = w_cost_expli / w_ha_planted 

foreach g of global gender {
	gen inorg_fert_rate_`g'=w_inorg_fert_kg_`g'/ w_ha_planted_`g'
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
*/


*This is proving to cause an error for some reason! 

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

 *Hours per capita using winsorized version off_farm_hours 
 /*
foreach x in /*ag_activ wage_off_farm wage_on_farm unpaid_off_farm domest_fire_fuel off_farm on_farm domest_all other_all*/ off_farm_hours /*off_farm_any_count*/ {
	local l`v':var label hrs_`x'
	gen hrs_`x'_pc_all = hrs_`x'/member_count
	lab var hrs_`x'_pc_all "Per capital (all) `l`v''"
	gen hrs_`x'_pc_any = hrs_`x'/nworker_`x'
    lab var hrs_`x'_pc_any "Per capital (only worker) `l`v''"
}
*/
gen hrs_off_farm_pc_all = off_farm_hours/member_count
lab var hrs_off_farm_pc_all "Per capita (all) Total hours Total household off-farm hours, for the past 7 days"
gen hrs_off_farm_pc_any = off_farm_hours/off_farm_any_count 
lab var hrs_off_farm_pc_any  "Per capita (only worker) Total hours Total household off-farm hours, for the past 7 days"
*SAW 3/13/23 Here, only worker represents the number of hh members with off farm work hours. In nigeria w3 nworker might represent something else. Nee to check. Notes: We don't havre information for the set of indicators shown in NGA w3 (e.g. unpaid_off_farm domes_fire_fuel domes_all etc.)

*generating total crop production costs per hectare
gen cost_expli_hh_ha = w_cost_expli_hh / w_ha_planted
lab var cost_expli_hh_ha "Explicit costs (per ha) of crop production (household level)"

*land and labor productivity
gen land_productivity = w_value_crop_production/w_farm_area
gen labor_productivity = w_value_crop_production/w_labor_total 
lab var land_productivity "Land productivity (value production per ha cultivated)"
lab var labor_productivity "Labor productivity (value production per labor-day)"   
global empty_vars $empty_vars labor_productivity w_value_crop_production w_kgs_harvest

/*
*milk productivity
gen liters_per_largeruminant= .
la var liters_per_largeruminant "Average quantity (liters) per year (household)"
global empty_vars $empty_vars liters_per_largeruminant		
*/

*milk productivity
gen liters_per_largeruminant= w_liters_milk_produced
la var liters_per_largeruminant "Average quantity (liters) per year (household)"
*SAW 3/13/23 Not sure why Nga w3 does not calculate this.. what is the rationale for adding empty_vars when there's information available?

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
global empty_vars $empty_vars cost_per_lit_milk months_food_insec
* 3/13/23 SAW No information available, -though, variables have been created.


*****getting correct subpopulations***
*all rural housseholds engaged in crop production 
recode inorg_fert_rate org_fert_rate n_rate p_rate k_rate /*herb_rate*/ pest_rate /*urea_rate npk_rate*/ cost_total_ha cost_expli_ha cost_expli_hh_ha land_productivity labor_productivity (.=0) if crop_hh==1
recode inorg_fert_rate org_fert_rate n_rate p_rate k_rate /*herb_rate*/ pest_rate /*urea_rate npk_rate*/ cost_total_ha cost_expli_ha cost_expli_hh_ha land_productivity labor_productivity (nonmissing=.) if crop_hh==0
*recode inorg_fert_rate cost_total_ha cost_expli_ha cost_expli_hh_ha land_productivity labor_productivity (.=0) if crop_hh==1
*recode inorg_fert_rate cost_total_ha cost_expli_ha cost_expli_hh_ha land_productivity labor_productivity (nonmissing=.) if crop_hh==0


*all rural households engaged in livestock production of a given species - Ahana not figured out mortality rate
/*
foreach i in lrum srum poultry{
	recode mortality_rate_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode mortality_rate_`i' (.=0) if lvstck_holding_`i'==1	
}
*/
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

/*
*all rural households harvesting specific crops 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_hv_`cn' (.=0) if harvested_`cn'==1 
	recode yield_hv_`cn' (nonmissing=.) if harvested_`cn'==0 
}
*/
*SAW 3/13/23 No information on yield by area harvested (no info of harvested area.) We could calculate this indicators using area yield by area planted potentially. Check with Andrew/Didier.

*households growing specific crops that have also purestand plots of that crop 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_pl_pure_`cn' (.=0) if grew_`cn'==1 & w_area_plan_pure_`cn'!=. 
	recode yield_pl_pure_`cn' (nonmissing=.) if grew_`cn'==0 | w_area_plan_pure_`cn'==.  
}

/*all rural households harvesting specific crops (in the long rainy season) that also have purestand plots 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_hv_pure_`cn' (.=0) if harvested_`cn'==1 & w_area_plan_pure_`cn'!=. 
	recode yield_hv_pure_`cn' (nonmissing=.) if harvested_`cn'==0 | w_area_plan_pure_`cn'==.  
}
*/
*SAW 3/13/23 No information on yield by area harvested (no info of harvested area.) We could calculate this indicators using area yield by area planted potentially. Check with Andrew/Didier.

*households engaged in dairy production  
recode costs_dairy_percow cost_per_lit_milk (.=0) if dairy_hh==1				
recode costs_dairy_percow cost_per_lit_milk (nonmissing=.) if dairy_hh==0		

*now winsorize ratios only at top 1% 
global wins_var_ratios_top1 inorg_fert_rate org_fert_rate n_rate p_rate k_rate /*herb_rate*/ pest_rate /*urea_rate npk_rate*/ cost_total_ha cost_expli_ha cost_expli_hh_ha /*		
*/ land_productivity labor_productivity /*
*/ mortality_rate* liters_per_largeruminant liters_per_cow liters_per_buffalo egg_poultry_year costs_dairy_percow /*
*/ /*DYA.10.26.2020*/  hrs_*_pc_all hrs_*_pc_any cost_per_lit_milk 

foreach v of varlist $wins_var_ratios_top1 {
	_pctile `v' [aw=weight] , p($wins_upper_thres)  
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top ${wins_upper_thres}%"
	*some variables  are disaggreated by gender of plot manager. For these variables, we use the top 1% percentile to winsorize gender-disagregated variables
	*if "`v'" =="inorg_fert_rate" | "`v'" =="cost_total_ha"  | "`v'" =="cost_expli_ha" {
	if inlist("`v'", "inorg_fert_rate",   "cost_total_ha", "cost_expli_ha", "n_rate", "p_rate") | inlist("`v'", "k_rate", "pest_rate") {
		foreach g of global gender {
			gen w_`v'_`g'=`v'_`g'
			replace  w_`v'_`g' = r(r1) if w_`v'_`g' > r(r1) & w_`v'_`g'!=.
			local l`v'_`g' : var lab `v'_`g'
			lab var  w_`v'_`g'  "`l`v'_`g'' - Winzorized top ${wins_upper_thres}%"
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
	lab var  w_`v'_exp_ha  "`l`v'_exp_ha - Winzorized top ${wins_upper_thres}%"
		*now by gender using the same method as above
		foreach g of global gender {
		gen w_`v'_exp_ha_`g'= `v'_exp_ha_`g'
		replace w_`v'_exp_ha_`g' = r(r1) if w_`v'_exp_ha_`g' > r(r1) & w_`v'_exp_ha_`g'!=.
		local l`v'_exp_ha_`g' : var lab `v'_exp_ha_`g'
		lab var w_`v'_exp_ha_`g' "`l`v'_exp_ha_`g'' - Winzorized top ${wins_upper_thres}%"
	}

	*winsorizing cost per kilogram
	_pctile `v'_exp_kg [aw=weight] , p($wins_upper_thres)  
	gen w_`v'_exp_kg=`v'_exp_kg
	replace  w_`v'_exp_kg = r(r1) if  w_`v'_exp_kg > r(r1) &  w_`v'_exp_kg!=.
	local l`v'_exp_kg : var lab `v'_exp_kg
	lab var  w_`v'_exp_kg  "`l`v'_exp_kg' - Winzorized top ${wins_upper_thres}%"
		*now by gender using the same method as above
		foreach g of global gender {
		gen w_`v'_exp_kg_`g'= `v'_exp_kg_`g'
		replace w_`v'_exp_kg_`g' = r(r1) if w_`v'_exp_kg_`g' > r(r1) & w_`v'_exp_kg_`g'!=.
		local l`v'_exp_kg_`g' : var lab `v'_exp_kg_`g'
		lab var w_`v'_exp_kg_`g' "`l`v'_exp_kg_`g'' - Winzorized top ${wins_upper_thres}%"
	}
}

*now winsorize ratio only at top 1% - yield 
foreach c of global topcropname_area {
	foreach i in yield_pl /*yield_hv*/{
		_pctile `i'_`c' [aw=weight] ,  p(95)  //IHS WINSORIZING YIELD FOR NIGERIA AT 5 PERCENT. 
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
	*replace w_yield_hv_`c'=. if w_area_plan_`c'<0.05
	foreach g of global allyield  {
		replace w_yield_pl_`g'_`c'=. if w_area_plan_`c'<0.05
		*replace w_yield_hv_`g'_`c'=. if w_area_plan_`c'<0.05	
	}
}
*SAW 3/13/23 Not sure if this applies for Uganda, must check with Andrew/Didier

*Create final income variables using un_winzorized and un_winzorized values
egen total_income = rowtotal(crop_income livestock_income /*fishing_income*/ self_employment_income nonagwage_income agwage_income transfers_income all_other_income)

egen nonfarm_income = rowtotal(/*fishing_income*/ self_employment_income nonagwage_income transfers_income all_other_income)

egen farm_income = rowtotal(crop_income livestock_income agwage_income)

lab var  nonfarm_income "Nonfarm income (excludes ag wages)"
gen percapita_income = total_income/hh_members
lab var total_income "Total household income"
lab var percapita_income "Household incom per hh member per year"
lab var farm_income "Farm income"

egen w_total_income = rowtotal(w_crop_income w_livestock_income /*w_fishing_income*/ w_self_employment_income w_nonagwage_income w_agwage_income w_transfers_income w_all_other_income)

egen w_nonfarm_income = rowtotal(/*w_fishing_income*/ w_self_employment_income w_nonagwage_income w_transfers_income w_all_other_income)
egen w_farm_income = rowtotal(w_crop_income w_livestock_income w_agwage_income)
lab var  w_nonfarm_income "Nonfarm income (excludes ag wages) - Winzorized top ${wins_upper_thres}%"
lab var w_farm_income "Farm income - Winzorized top ${wins_upper_thres}%"
gen w_percapita_income = w_total_income/hh_members
lab var w_total_income "Total household income - Winzorized top ${wins_upper_thres}%"
lab var w_percapita_income "Household income per hh member per year - Winzorized top ${wins_upper_thres}%"
global income_vars crop livestock /*fishing*/ self_employment nonagwage agwage transfers all_other
foreach p of global income_vars {
	gen `p'_income_s = `p'_income
	replace `p'_income_s = 0 if `p'_income_s < 0
	gen w_`p'_income_s = w_`p'_income
	replace w_`p'_income_s = 0 if w_`p'_income_s < 0 
}

egen w_total_income_s = rowtotal(w_crop_income_s w_livestock_income_s /*w_fishing_income_s*/ w_self_employment_income_s w_nonagwage_income_s w_agwage_income_s  w_transfers_income_s w_all_other_income_s)

foreach p of global income_vars {
	gen w_share_`p' = w_`p'_income_s / w_total_income_s
	lab var w_share_`p' "Share of household (winsorized) income from `p'_income"
}
egen w_nonfarm_income_s = rowtotal(/*w_fishing_income_s*/ w_self_employment_income_s w_nonagwage_income_s w_transfers_income_s w_all_other_income_s)

gen w_share_nonfarm = w_nonfarm_income_s / w_total_income_s
lab var w_share_nonfarm "Share of household income (winsorized) from nonfarm sources"
foreach p of global income_vars {
	drop `p'_income_s  w_`p'_income_s 
}
drop w_total_income_s w_nonfarm_income_s

***getting correct subpopulations
*all rural households 
//note that consumption indicators are not included because there is missing consumption data and we do not consider 0 values for consumption to be valid
//ALT 08.16.21: Kludge for imprv seed use - for consistency, it should really be use_imprv_seed 
recode w_total_income w_percapita_income w_crop_income w_livestock_income /*w_fishing_income_s*/ w_nonagwage_income w_agwage_income w_self_employment_income w_transfers_income w_all_other_income /*
*/ w_share_crop w_share_livestock /*w_share_fishing*/ w_share_nonagwage w_share_agwage w_share_self_employment w_share_transfers w_share_all_other w_share_nonfarm /*
*/ /*use_fin_serv*/ use_inorg_fert use_org_fert use_pest imprv_seed_use /*
*/ formal_land_rights_hh  /*DYA.10.26.2020*/ *_hrs_*_pc_all   w_value_assets /*
*/ lvstck_holding_tlu lvstck_holding_all lvstck_holding_lrum lvstck_holding_srum lvstck_holding_poultry (.=0) if rural==1 
 
 
*all rural households engaged in livestock production
recode vac_animal w_share_livestock_prod_sold livestock_expenses w_ls_exp_vac (. = 0) if livestock_hh==1 
recode vac_animal w_share_livestock_prod_sold livestock_expenses w_ls_exp_vac (nonmissing = .) if livestock_hh==0 

*all rural households engaged in livestock production of a given species
*no vaccine data vac_animal_`i' w_ls_exp_vac
foreach i in lrum /*srum poultry*/{
recode vac_animal_`i' any_imp_herd_`i' animals_lost12months_`i' w_ls_exp_vac_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode vac_animal_`i' any_imp_herd_`i' animals_lost12months_`i' w_ls_exp_vac_`i' (.=0) if lvstck_holding_`i'==1	
}

*households engaged in crop production
recode *proportion_cropvalue_sold *farm_size_agland *labor_family *labor_hired /*
*/ imprv_seed_use use_inorg_fert use_org_fert use_pest /*use_herb*/ *labor_productivity *land_productivity /*
*/ *inorg_fert_rate *org_fert_rate *n_rate p_rate k_rate /*herb_rate*/ pest_rate /*urea_rate npk_rate*/ /*
*/ *cost_expli_hh *cost_expli_hh_ha *cost_expli_ha *cost_total_ha /*
*/ *value_crop_production *value_crop_sales *all_area_planted /**all_area_harvested*/ (.=0) if crop_hh==1

recode *proportion_cropvalue_sold *farm_size_agland *labor_family *labor_hired /*
*/ imprv_seed_use use_inorg_fert use_org_fert use_pest /*use_herb*/ *labor_productivity *land_productivity /*
*/ *inorg_fert_rate *org_fert_rate *n_rate p_rate k_rate /*herb_rate*/ pest_rate /*urea_rate npk_rate*/ /*
*/ *cost_expli_hh *cost_expli_hh_ha *cost_expli_ha *cost_total_ha /*
*/ *value_crop_production *value_crop_sales *all_area_planted /**all_area_harvested*/ (nonmissing= . ) if crop_hh==0

/*
*households engaged in crop production
recode w_proportion_cropvalue_sold w_farm_size_agland w_labor_family w_labor_hired /*
*/ imprv_seed_use use_inorg_fert w_labor_productivity w_land_productivity /*
*/ w_inorg_fert_rate w_cost_expli_hh w_cost_expli_hh_ha w_cost_expli_ha w_cost_total_ha /*
*/ w_value_crop_production w_value_crop_sales w_all_area_planted /*w_all_area_harvested*/ (.=0) if crop_hh==1
recode w_proportion_cropvalue_sold w_farm_size_agland w_labor_family w_labor_hired /*
*/ imprv_seed_use use_inorg_fert w_labor_productivity w_land_productivity /*
*/ w_inorg_fert_rate w_cost_expli_hh w_cost_expli_hh_ha w_cost_expli_ha w_cost_total_ha /*
*/ w_value_crop_production w_value_crop_sales w_all_area_planted /*w_all_area_harvested*/ (nonmissing= . ) if crop_hh==0
*/	
	
*hh engaged in crop or livestock production
recode ext_reach* (.=0) if (crop_hh==1 | livestock_hh==1)
recode ext_reach* (nonmissing=.) if crop_hh==0 & livestock_hh==0

*all rural households growing specific crops 
gen  imprv_seed_wheat=.
gen hybrid_seed_wheat=.
gen lvstck_housed_poultry=.
gen lvstck_housed_srum=.
gen lvstck_housed_lrum=.
gen feed_grazing_lrum=.
gen feed_grazing_poultry=.
gen feed_grazing_srum=.
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode imprv_seed_`cn' hybrid_seed_`cn' w_yield_pl_`cn' /*
	*/ w_value_harv_`cn' w_value_sold_`cn' w_kgs_harvest_`cn' w_total_planted_area_`cn' /*w_total_harv_area_`cn'*/ (.=0) if grew_`cn'==1
	recode imprv_seed_`cn' hybrid_seed_`cn' w_yield_pl_`cn' /*
	*/ w_value_harv_`cn' w_value_sold_`cn' w_kgs_harvest_`cn' w_total_planted_area_`cn' /*w_total_harv_area_`cn'*/ (nonmissing=.) if grew_`cn'==0
}
/*
*all rural households that harvested specific crops
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode w_yield_hv_`cn' (.=0) if harvested_`cn'==1
	recode w_yield_hv_`cn' (nonmissing=.) if harvested_`cn'==0
}
*/
*SAW 3/13/23 Here, we could do it with w_yield_planted_cn.

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
gen individual_weight=hh_members*weight
gen adulteq_weight=adulteq*weight


* Poverty Indicator Updates
*Rural poverty headcount ratio
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


****Currency Conversion Factors***
gen ccf_loc = (1/$Uganda_NPS_W1_inflation) 
lab var ccf_loc "currency conversion factor - 2017 $UGX"
gen ccf_usd = ccf_loc/$Uganda_NPS_W1_exchange_rate
lab var ccf_usd "currency conversion factor - 2017 $USD"
gen ccf_1ppp = ccf_loc/$Uganda_NPS_W1_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2017 $Private Consumption PPP"
gen ccf_2ppp = ccf_loc/$Uganda_NPS_W1_gdp_ppp_dollar
lab var ccf_2ppp "currency conversion factor - 2017 $GDP PPP"


*Poverty indicators 
gen poverty_under_190= (daily_percap_cons < $Uganda_NPS_W1_poverty_190)
la var poverty_under_190"Household per-capita conumption is below $1.90 in 2011 $ PPP"
gen poverty_under_215 = (daily_percap_cons < $Uganda_NPS_W1_poverty_215)
la var poverty_under_215 "Household per-capita consumption is below $2.15 in 2017 $ PPP"


*We merge the national poverty line provided by the World bank 
preserve
use "${Uganda_NPS_W1_raw_data}/pov2009_10.dta", clear
tostring hhid, g(hhid2) format(%18.0g)
*destring hhid2, g(hhid3)
*assert hhid == hhid2
ren hhid2 HHID
tempfile pov2009
save `pov2009'
restore
merge 1:1 HHID using `pov2009', nogen keep(1 3) 
rename poor poverty_under_npl
la var poverty_under_npl "Household per-capita consumption is below national poverty line in 05/06 PPP prices"

*generating clusterid and strataid
gen clusterid=ea
gen strataid=region

*dropping unnecessary varables
drop *_inter_*


global empty_vars $empty_vars feed* lvstck_housed*
*Recode to missing any variables that cannot be created in this instrument
*replace empty vars with missing
foreach v of varlist $empty_vars { 
	replace `v' = .
}
*CPK: where did total income go?? percapita_income? water* lvstck_housed*
// Removing intermediate variables to get below 5,000 vars
keep HHID fhh poverty* clusterid strataid *weight* /*wgt*/ region /*regurb*/ district county subcounty parish ea rural farm_size* *total_income* /*
*/ *percapita_income* *percapita_cons* *daily_percap_cons* *peraeq_cons* *daily_peraeq_cons* /*
*/ *income* *share* *proportion_cropvalue_sold *farm_size_agland hh_members adulteq *labor_family *labor_hired use_inorg_fert vac_* /*
*/  ext_* /*use_fin_**/ lvstck_holding* *mortality_rate* /*lost_disease*/ disease* any_imp* formal_land_rights_hh /*
*/ *livestock_expenses* *ls_exp_vac* *prop_farm_prod_sold /*DYA.10.26.2020*/ *hrs_*   months_food_insec *value_assets* hhs_* *dist_agrodealer /*
*/ encs* num_crops_* multiple_crops* imprv_seed_* hybrid_seed_* *labor_total *farm_area *labor_productivity* *land_productivity* /*
*/ *wage_paid_aglabor* *labor_hired /*ar_h_wgt_* *yield_hv_**/ ar_pl_wgt_* *yield_pl_* *liters_per_* /*milk_animals*/ poultry_owned *costs_dairy* *cost_per_lit* /*
*/ *egg_poultry_year* *inorg_fert_rate* *ha_planted* *cost_expli_hh* *cost_expli_ha* *monocrop_ha* *kgs_harv_mono* *cost_total_ha* /*
*/ *_exp* poverty_under_* *value_crop_production* *value_harv* *value_crop_sales* *value_sold* *kgs_harvest* *total_planted_area* /**total_harv_area**/ /*
*/ *all_area_* grew_* agactivities_hh ag_hh crop_hh livestock_hh fishing_hh *_milk_produced* *eggs_total_year *value_eggs_produced* /*
*/ *value_livestock_products* *value_livestock_sales* *total_cons* /*nb_cattle_today nb_poultry_today*/ bottom_40_percap bottom_40_peraeq /*
*/ ccf_loc ccf_usd ccf_1ppp ccf_2ppp nb_* *sales_livestock_products area_plan* /*area_harv**/  *value_pro* *value_sal*
*SAW 3/14/23 Need to check for the ones available in Uganda but not in Nigeria.


gen ssp = (farm_size_agland <= 2 & farm_size_agland != 0) & (nb_cows_today <= 10 & nb_smallrum_today <= 10 & nb_chickens_today <= 50)

ren weight weight_orig 
ren weight_pop_rururb weight
la var weight_orig "Original survey weight"
la var weight "Weight adjusted to match rural/urban populations"
tostring HHID, replace 

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
gen hhid_panel = HHID 
lab var hhid_panel "panel hh identifier" 
gen geography = "Uganda"
la var geography "Location of survey"
gen survey = "LSMS-ISA"
la var survey "Survey type (LSMS or AgDev)"
gen year = "2011-12"
la var year "Year survey was carried out"
gen instrument = 25
la var instrument "Wave and location of survey"
capture label define instrument 11 "Tanzania NPS Wave 1" 12 "Tanzania NPS Wave 2" 13 "Tanzania NPS Wave 3" 14 "Tanzania NPS Wave 4" 15 "Tanzania NPS SDD" 16 "Tanzania NPS Wave 5" /*
	*/ 21 "Ethiopia ESS Wave 1" 22 "Ethiopia ESS Wave 2" 23 "Ethiopia ESS Wave 3" 24 "Ethiopia ESS Wave 4" 25 "Ethiopia ESS Wave 5" /*
	*/ 31 "Nigeria GHS Wave 1" 32 "Nigeria GHS Wave 2" 33 "Nigeria GHS Wave 3" 34 "Nigeria GHS Wave 4" 35 "Nigeria GHS Wave 5"/*
	*/ 41 "Malawi IHS/IHPS Wave 1" 42 "Malawi IHS/IHPS Wave 2" 43 "Malawi IHS/IHPS Wave 3" 44 "Malawi IHS/IHPS Wave 4" /*
    */ 51 "Uganda NPS Wave 1" 52 "Uganda NPS Wave 2" 53 "Uganda NPS Wave 3" 54 "Uganda NPS Wave 4" 55 "Uganda NPS Wave 5" /*W6 does not exist*/ 56 "Uganda NPS Wave 7" 57 "Uganda NPS Wave 8" /* 
*/ 61 "Burkina Faso EMC Wave 1" /* 
*/ 71 "Mali EACI Wave 1" 72 "Mali EACI Wave 2" /*
*/ 81 "Niger ECVMA Wave 1" 82 "Niger ECVMA Wave 2"
label values instrument instrument	
*SAW Notes: We need an actual number for Uganda waves. 
saveold  "${Uganda_NPS_W1_final_data}/Uganda_NPS_W1_household_variables.dta", replace
use  "${Uganda_NPS_W1_final_data}/Uganda_NPS_W1_household_variables.dta", clear

********************************************************************************
                          *INDIVIDUAL-LEVEL VARIABLES*
********************************************************************************
*SAW 14/04/23 This section uses Nigeria Wave 3 as reference
use "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_person_ids.dta", clear
*use "${UGA_W2_created_data}/Uganda_NPS_W2_control_income.dta", clear
merge 1:1 HHID PID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_control_income.dta", nogen keep(1 3)
*merge 1:1 HHID PID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_make_ag_decision.dta", nogen keep(1 3)
merge 1:1 HHID PID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_ownasset.dta", nogen keep(1 3)
merge m:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_weights.dta", nogen keep(1 3)
merge 1:1 HHID personid using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_farmer_fert_use.dta", nogen keep(1 3) 
 
merge 1:1 HHID personid using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_farmer_improvedseed_use.dta", nogen keep(1 3)
merge 1:1 HHID personid using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_farmer_vaccine.dta", nogen keep(1 3)
merge m:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_hhids.dta", nogen keep(1 3)

*Land rights
destring personid, replace 
destring PID, replace
merge 1:1 HHID personid using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_land_rights_ind.dta", nogen keep(1 3)
recode formal_land_rights_f (.=0) if female==1	
la var formal_land_rights_f "Individual has documentation of land rights (at least one plot) - Women only"

*getting correct subpopulations (women aged 18 or above in rural households)
recode control_all_income /*make_decision_ag*/ own_asset formal_land_rights_f (.=0) if female==1 
recode control_all_income /*make_decision_ag*/ own_asset formal_land_rights_f (nonmissing=.) if female==0
*destring HHID, replace 
*merge in hh variable to determine ag household
preserve
use "${Uganda_NPS_W1_final_data}/Uganda_NPS_W1_household_variables.dta", clear
keep HHID ag_hh
tempfile ag_hh
save `ag_hh'
restore
merge m:1 HHID using `ag_hh', nogen keep (1 3)
*replace   make_decision_ag =. if ag_hh==0

* NA in NG_LSMS-ISA
gen women_diet=.
gen  number_foodgroup=.
foreach c in wheat /*beans*/ {
	gen all_imprv_seed_`c' = .
	gen all_hybrid_seed_`c' = .
	gen `c'_farmer = .
}



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

/*
*generate missings
foreach g in all male female{
	foreach c in wheat beans{
	gen `g'_imprv_seed_`c' = .
	gen `g'_hybrid_seed_`c' = .
	}
}
*/

gen female_use_inorg_fert=all_use_inorg_fert if female==1
gen male_use_inorg_fert=all_use_inorg_fert if female==0
lab var male_use_inorg_fert "1 = Individual male farmers (plot manager) uses inorganic fertilizer"
lab var female_use_inorg_fert "1 = Individual female farmers (plot manager) uses inorganic fertilizer"
gen female_imprv_seed_use=all_imprv_seed_use if female==1
gen male_imprv_seed_use=all_imprv_seed_use if female==0
lab var male_imprv_seed_use "1 = Individual male farmer (plot manager) uses improved seeds" 
lab var female_imprv_seed_use "1 = Individual female farmer (plot manager) uses improved seeds"

/*gen female_vac_animal=vac_animal if female==1
gen male_vac_animal=all_vac_animal if female==0
lab var male_vac_animal "1 = Individual male farmers (livestock keeper) uses vaccines"
lab var female_vac_animal "1 = Individual female farmers (livestock keeper) uses vaccines"
*/

*replace empty vars with missing 
global empty_vars *hybrid_seed* women_diet number_foodgroup
foreach v of varlist $empty_vars { 
	replace `v' = .
}

ren weight weight_orig 
ren weight_pop_rururb weight
la var weight_orig "Original survey weight"
la var weight "Weight adjusted to match rural/urban populations"

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
gen hhid_panel = HHID 
lab var hhid_panel "panel hh identifier" 
ren PID indid
gen geography = "Nigeria"
gen survey = "LSMS-ISA"
gen year = "2009-10"
gen instrument = 51
capture label define instrument 11 "Tanzania NPS Wave 1" 12 "Tanzania NPS Wave 2" 13 "Tanzania NPS Wave 3" 14 "Tanzania NPS Wave 4" 15 "Tanzania NPS SDD" 16 "Tanzania NPS Wave 5" /*
	*/ 21 "Ethiopia ESS Wave 1" 22 "Ethiopia ESS Wave 2" 23 "Ethiopia ESS Wave 3" 24 "Ethiopia ESS Wave 4" 25 "Ethiopia ESS Wave 5" /*
	*/ 31 "Nigeria GHS Wave 1" 32 "Nigeria GHS Wave 2" 33 "Nigeria GHS Wave 3" 34 "Nigeria GHS Wave 4" 35 "Nigeria GHS Wave 5"/*
	*/ 41 "Malawi IHS/IHPS Wave 1" 42 "Malawi IHS/IHPS Wave 2" 43 "Malawi IHS/IHPS Wave 3" 44 "Malawi IHS/IHPS Wave 4" /*
    */ 51 "Uganda NPS Wave 1" 52 "Uganda NPS Wave 2" 53 "Uganda NPS Wave 3" 54 "Uganda NPS Wave 4" 55 "Uganda NPS Wave 5" /*W6 does not exist*/ 56 "Uganda NPS Wave 7" 57 "Uganda NPS Wave 8" /* 
*/ 61 "Burkina Faso EMC Wave 1" /* 
*/ 71 "Mali EACI Wave 1" 72 "Mali EACI Wave 2" /*
*/ 81 "Niger ECVMA Wave 1" 82 "Niger ECVMA Wave 2"
label values instrument instrument

label values instrument instrument	
gen strataid=region
gen clusterid=ea
saveold "${Uganda_NPS_W1_final_data}/Uganda_NPS_W1_individual_variables.dta", replace


********************************************************************************
*PLOT -LEVEL VARIABLES
********************************************************************************

*GENDER PRODUCTIVITY GAP
use "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_all_plots.dta", replace
collapse (sum) plot_value_harvest = value_harvest, by(HHID parcel_id plot_id season)
tempfile crop_values 
save `crop_values' // season level

use "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_areas.dta", replace // plot-season level
merge m:1 HHID using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_weights.dta", keep (1 3) nogen // hh level
merge 1:1 HHID parcel_id plot_id season using `crop_values', keep (1 3) nogen //  plot-season level
merge m:1 HHID parcel_id using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_decision_makers.dta", keep (1 3) nogen //  plot-season level
merge m:1 HHID parcel_id plot_id using "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_plot_labor_days.dta", keep (1 3) nogen // plot level
*destring HHID, replace 
merge m:1 HHID using "${Uganda_NPS_W1_final_data}/Uganda_NPS_W1_household_variables.dta", nogen keep (1 3) keepusing(ag_hh fhh farm_size_agland region ea)
recode farm_size_agland (.=0) 
gen rural_ssp=(farm_size_agland<=4 & farm_size_agland!=0) & rural==1 

*keep if cultivate==1 // 3/15/23 We need to generate this indicator
ren field_size  area_meas_hectares
egen labor_total = rowtotal(labor_family labor_hired /*labor_nonhired*/) // labor_nonhired needs to be created too. 
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
lab var w_plot_value_harvest "Value of crop harvest on this plot - Winzorized top ${wins_upper_thres}%"

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
	lab var  w_`v'  "`l`v'' - Winzorized top ${wins_upper_thres}%"
}	

/* SAW 4/20/23 OLD VERSION 
*Convert monetary values to USD and PPP
global monetary_val plot_value_harvest plot_productivity  plot_labor_prod 
foreach p of global monetary_val {
	gen `p'_1ppp = (1) * `p' / $NPS_LSMS_ISA_W3_cons_ppp_dollar
	gen `p'_2ppp = (1) * `p' / $NPS_LSMS_ISA_W3_gdp_ppp_dollar
	gen `p'_usd = (1) * `p' / $NPS_LSMS_ISA_W3_exchange_rate
	gen `p'_loc = (1) * `p' 
	local l`p' : var lab `p' 
	lab var `p'_1ppp "`l`p'' (2016 $ Private Consumption PPP)"
	lab var `p'_2ppp "`l`p'' (2016 $ GDP PPP)"
	lab var `p'_usd "`l`p'' (2016 $ USD)"
	lab var `p'_loc "`l`p'' 2016 (NGN)"  
	lab var `p' "`l`p'' (NGN)"  
	gen w_`p'_1ppp = (1) * w_`p' / $NPS_LSMS_ISA_W3_cons_ppp_dollar
	gen w_`p'_2ppp = (1) * w_`p' / $NPS_LSMS_ISA_W3_gdp_ppp_dollar
	gen w_`p'_usd = (1) * w_`p' /  $NPS_LSMS_ISA_W3_exchange_rate
	gen w_`p'_loc = (1) * w_`p' 
	local lw_`p' : var lab w_`p'
	lab var w_`p'_1ppp "`lw_`p'' (2016 $ Private Consumption PPP)"
	lab var w_`p'_2ppp "`lw_`p'' (2016 $ GDP PPP)"
	lab var w_`p'_usd "`lw_`p'' (2016 $ USD)"
	lab var w_`p'_loc "`lw_`p'' 2106 (NGN)"
	lab var w_`p' "`lw_`p'' (NGN)" 
}
*/

****Currency Conversion Factors***
gen ccf_loc = (1/$Uganda_NPS_W1_inflation) 
lab var ccf_loc "currency conversion factor - 2017 $UGX"
gen ccf_usd = ccf_loc/$Uganda_NPS_W1_exchange_rate
lab var ccf_usd "currency conversion factor - 2017 $USD"
gen ccf_1ppp = ccf_loc/$Uganda_NPS_W1_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2017 $Private Consumption PPP"
gen ccf_2ppp = ccf_loc/$Uganda_NPS_W1_gdp_ppp_dollar
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
	lab var `p'_loc "`l`p'' (2017 UGX)" 
	lab var `p' "`l`p'' (UGX)"  
	gen w_`p'_1ppp = w_`p' * ccf_1ppp
	gen w_`p'_2ppp = w_`p' * ccf_2ppp
	gen w_`p'_usd = w_`p' * ccf_usd
	gen w_`p'_loc = w_`p' * ccf_loc
	local lw_`p' : var lab w_`p'
	lab var w_`p'_1ppp "`lw_`p'' (2017 $ Private Consumption PPP)"
	lab var w_`p'_2ppp "`lw_`p'' (2017 $ GDP PPP)"
	lab var w_`p'_usd "`lw_`p'' (2017 $ USD)"
	lab var w_`p'_loc "`lw_`p'' (2017 UGX)" 
	lab var w_`p' "`lw_`p'' (UGX)" 
}

*We are reporting two variants of gender-gap
* mean difference in log productivitity without and with controls (plot size and region/state)
* both can be obtained using a simple regression.
* use clustered standards errors
gen clusterid=ea
gen strataid=region
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
svy, subpop(if rural==1) : reg  lplot_productivity_usd male_dummy larea_meas_hectares i.region  
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
svy, subpop(  if rural==1 & rural_ssp==1): reg  lplot_productivity_usd male_dummy larea_meas_hectares i.region
matrix b1b=e(b)
gen gender_prod_gap1b_ssp=100*el(b1b,1,1)
sum gender_prod_gap1b_ssp
lab var gender_prod_gap1b_ssp "Gender productivity gap (%) - regression in logs with controls - SSP"
matrix V1b=e(V)
gen segender_prod_gap1b_ssp= 100*sqrt(el(V1b,1,1)) 
sum segender_prod_gap1b_ssp
lab var segender_prod_gap1b_ssp "SE Gender productivity gap (%) - regression in logs with controls - SSP"


*LS_SSP
svy, subpop(  if rural==1 & rural_ssp==0): reg  lplot_productivity_usd male_dummy larea_meas_hectares i.region
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
rename v1 UGA_wave1

save "${Uganda_NPS_W1_created_data}/Uganda_NPS_W1_gendergap.dta", replace 
restore

/*BET.12.4.2020 - END*/ 

foreach i in 1ppp 2ppp loc{
	gen w_plot_productivity_all_`i'=w_plot_productivity_`i'
	gen w_plot_productivity_female_`i'=w_plot_productivity_`i' if dm_gender==2
	gen w_plot_productivity_male_`i'=w_plot_productivity_`i' if dm_gender==1
	gen w_plot_productivity_mixed_`i'=w_plot_productivity_`i' if dm_gender==3
}

*Create weight 
gen plot_labor_weight= w_labor_total*weight
ren weight weight_orig 
ren weight_pop_rururb weight
la var weight_orig "Original survey weight"
la var weight "Weight adjusted to match rural/urban populations"

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
gen HHID_panel = HHID 
lab var HHID_panel "panel hh identifier" 
gen geography = "Uganda"
gen survey = "LSMS-ISA"
gen year = "2009-10"
gen instrument = 51
//Only runs if label isn't already defined.
capture label define instrument 11 "Tanzania NPS Wave 1" 12 "Tanzania NPS Wave 2" 13 "Tanzania NPS Wave 3" 14 "Tanzania NPS Wave 4" 15 "Tanzania NPS SDD" 16 "Tanzania NPS Wave 5" /*
	*/ 21 "Ethiopia ESS Wave 1" 22 "Ethiopia ESS Wave 2" 23 "Ethiopia ESS Wave 3" 24 "Ethiopia ESS Wave 4" 25 "Ethiopia ESS Wave 5" /*
	*/ 31 "Nigeria GHS Wave 1" 32 "Nigeria GHS Wave 2" 33 "Nigeria GHS Wave 3" 34 "Nigeria GHS Wave 4" 35 "Nigeria GHS Wave 5"/*
	*/ 41 "Malawi IHS/IHPS Wave 1" 42 "Malawi IHS/IHPS Wave 2" 43 "Malawi IHS/IHPS Wave 3" 44 "Malawi IHS/IHPS Wave 4" /*
    */ 51 "Uganda NPS Wave 1" 52 "Uganda NPS Wave 2" 53 "Uganda NPS Wave 3" 54 "Uganda NPS Wave 4" 55 "Uganda NPS Wave 5" /*W6 does not exist*/ 56 "Uganda NPS Wave 7" 57 "Uganda NPS Wave 8" /* 
*/ 61 "Burkina Faso EMC Wave 1" /* 
*/ 71 "Mali EACI Wave 1" 72 "Mali EACI Wave 2" /*
*/ 81 "Niger ECVMA Wave 1" 82 "Niger ECVMA Wave 2"
label values instrument instrument			
saveold "${Uganda_NPS_W1_final_data}/Uganda_NPS_W1_field_plot_variables.dta", replace 

********************************************************************************
*SUMMARY STATISTICS
******************************************************************************** 
/*
All the pre-processed files include all households, individuals, and plots in the sample. 
The summary statistics are outputted only for the sub_population of households, individuals, and plots in rural areas. 
The code for outputting the summary statistics is in a separare dofile that is called here
*/ 
global list_instruments  "Uganda_NPS_W1"
do "$summary_stats"


************************************ STOP ************************************
