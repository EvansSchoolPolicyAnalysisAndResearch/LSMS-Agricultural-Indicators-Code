/*
-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of a set of agricultural development indicators 
				  using the Uganda National Panel Survey (UNPS) LSMS-ISA Wave 1 (2009-10)
*Author(s)		: Didier Alia, David Coomes, Elan Ebeling, Nina Forbes, Nida Haroon
				  Muel Kiel, Anu Sidhu, Isabella Sun, Emma Weaver, Ayala Wineman, 
				  C. Leigh Anderson, &  Travis Reynolds

*Acknowledgments: We acknowledge the helpful contributions of members of the World Bank's LSMS-ISA team, the FAO's RuLIS team, IFPRI, IRRI, 
				  and the Bill & Melinda Gates Foundation Agricultural Development Data and Policy team in discussing indicator construction decisions. 
				  All coding errors remain ours alone.
*Date			: 4 February 2020

----------------------------------------------------------------------------------------------------------------------------------------------------*/


*W1_EPAR_UW_378_Uganda_EFW_1.22.19_CH_2.4.20CJS.do
*Data source
*----------------------------------------------------------------------------
*The Uganda National Panel Survey was collected by the Uganda Bureau of Statistics (UBOS) 
*and the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture(LSMS - ISA)
*The data were collected over the period 2009 - 2010. //EFW 1.22.19 Which months?
*All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
*http://microdata.worldbank.org/index.php/catalog/1001

*Throughout the do-file, we sometimes use the shorthand LSMS to refer to the Tanzania National Panel Survey.


*Summary of Executing the Master do.file
*-----------
*This Master do.file constructs selected indicators using the Uganda UNPS (UN LSMS) data set.
*Using data files from within the "Uganda UNPS - LSMS-ISA - Wave 1 (2009-10)" folder within the "Raw DTA files" folder, 
*the do.file first constructs common and intermediate variables, saving dta files when appropriate 
*in the folder "/Tanzania TNPS - LSMS-ISA - Wave 4 (2014-15)/TZA_W4_created_data" within the "Final DTA files" folder. //EFW 1.22.19 Update this with new file paths. Double check with Leigh et al. that OK to change
*These variables are then brought together at the household, plot, or individual level, saving dta files at each level when available 
*in the folder "Tanzania TNPS - LSMS-ISA - Wave 4 (2014-15)" within the "Final DTA files" folder. //EFW 1.22.19 Update this with new file path 

*The processed files include all households, individuals, and plots in the sample.
*Toward the end of the do.file, a block of code estimates summary statistics (mean, standard error of the mean, minimum, first quartile, median, third quartile, maximum) 
*of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager.
*The results are outputted in the excel file "Uganda_NPS_LSMS_ISA_W1_summary_stats.xlsx" in the "Tanzania TNPS - LSMS-ISA - Wave 4 (2014-15)" within the "Final DTA files" folder. //EFW 1.22.19 Update this with new file paths
*It is possible to modify the condition  "if rural==1" in the portion of code following the heading "SUMMARY STATISTICS" to generate all summary statistics for a different sub_population.


/*
OUTLINE OF THE DO.FILE
Below are the list of the main files created by running this Master do.file
 					
*INTERMEDIATE FILES					MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD IDS						Uganda_NPS_LSMS_ISA_W1_hhids.dta
*INDIVIDUAL IDS						Uganda_NPS_LSMS_ISA_W1_person_ids.dta
*HOUSEHOLD SIZE						Uganda_NPS_LSMS_ISA_W1_hhsize.dta
*PARCEL AREAS						Uganda_NPS_LSMS_ISA_W1_plot_areas.dta
*PLOT-CROP DECISION MAKERS			Uganda_NPS_LSMS_ISA_W1_plot_decision_makers.dta
*TLU (Tropical Livestock Units)		Uganda_NPS_LSMS_ISA_W1_TLU_Coefficients.dta

*GROSS CROP REVENUE					Uganda_NPS_LSMS_ISA_W1_tempcrop_harvest.dta
									Uganda_NPS_LSMS_ISA_W1_tempcrop_sales.dta
									Uganda_NPS_LSMS_ISA_W1_permcrop_harvest.dta
									Uganda_NPS_LSMS_ISA_W1_permcrop_sales.dta
									Uganda_NPS_LSMS_ISA_W1_hh_crop_production.dta
									Uganda_NPS_LSMS_ISA_W1_plot_cropvalue.dta
									Uganda_NPS_LSMS_ISA_W1_parcel_cropvalue.dta
									Uganda_NPS_LSMS_ISA_W1_crop_residues.dta
									Uganda_NPS_LSMS_ISA_W1_hh_crop_prices.dta
									Uganda_NPS_LSMS_ISA_W1_crop_losses.dta
*CROP EXPENSES						Uganda_NPS_LSMS_ISA_W1_wages_mainseason.dta
									Uganda_NPS_LSMS_ISA_W1_wages_shortseason.dta
									
									Uganda_NPS_LSMS_ISA_W1_fertilizer_costs.dta
									Uganda_NPS_LSMS_ISA_W1_seed_costs.dta
									Uganda_NPS_LSMS_ISA_W1_land_rental_costs.dta
									Uganda_NPS_LSMS_ISA_W1_asset_rental_costs.dta
									Uganda_NPS_LSMS_ISA_W1_transportation_cropsales.dta
									
*CROP INCOME						Uganda_NPS_LSMS_ISA_W1_crop_income.dta
									
*LIVESTOCK INCOME					Uganda_NPS_LSMS_ISA_W1_livestock_products.dta
									Uganda_NPS_LSMS_ISA_W1_livestock_expenses.dta
									Uganda_NPS_LSMS_ISA_W1_hh_livestock_products.dta
									Uganda_NPS_LSMS_ISA_W1_livestock_sales.dta
									Uganda_NPS_LSMS_ISA_W1_TLU.dta
									Uganda_NPS_LSMS_ISA_W1_livestock_income.dta

*FISH INCOME						Uganda_NPS_LSMS_ISA_W1_fishing_expenses_1.dta
									Uganda_NPS_LSMS_ISA_W1_fishing_expenses_2.dta
									Uganda_NPS_LSMS_ISA_W1_fish_income.dta
																	
*SELF-EMPLOYMENT INCOME				Uganda_NPS_LSMS_ISA_W1_self_employment_income.dta
									Uganda_NPS_LSMS_ISA_W1_agproducts_profits.dta
									Uganda_NPS_LSMS_ISA_W1_fish_trading_revenue.dta
									Uganda_NPS_LSMS_ISA_W1_fish_trading_other_costs.dta
									Uganda_NPS_LSMS_ISA_W1_fish_trading_income.dta
									
*WAGE INCOME						Uganda_NPS_LSMS_ISA_W1_wage_income.dta
									Uganda_NPS_LSMS_ISA_W1_agwage_income.dta
*OTHER INCOME						Uganda_NPS_LSMS_ISA_W1_other_income.dta
									Uganda_NPS_LSMS_ISA_W1_land_rental_income.dta

*FARM SIZE / LAND SIZE				Uganda_NPS_LSMS_ISA_W1_land_size.dta
									Uganda_NPS_LSMS_ISA_W1_farmsize_all_agland.dta
									Uganda_NPS_LSMS_ISA_W1_land_size_all.dta
*FARM LABOR							Uganda_NPS_LSMS_ISA_W1_farmlabor_mainseason.dta
									Uganda_NPS_LSMS_ISA_W1_farmlabor_shortseason.dta
									Uganda_NPS_LSMS_ISA_W1_family_hired_labor.dta
*VACCINE USAGE						Uganda_NPS_LSMS_ISA_W1_vaccine.dta
*USE OF INORGANIC FERTILIZER		Uganda_NPS_LSMS_ISA_W1_fert_use.dta
*USE OF IMPROVED SEED				Uganda_NPS_LSMS_ISA_W1_improvedseed_use.dta

*REACHED BY AG EXTENSION			Uganda_NPS_LSMS_ISA_W1_any_ext.dta
*USE OF FORMAL FINANACIAL SERVICES	Uganda_NPS_LSMS_ISA_W1_fin_serv.dta
*GENDER PRODUCTIVITY GAP 			Uganda_NPS_LSMS_ISA_W1_gender_productivity_gap.dta
*MILK PRODUCTIVITY					Uganda_NPS_LSMS_ISA_W1_milk_animals.dta
*EGG PRODUCTIVITY					Uganda_NPS_LSMS_ISA_W1_eggs_animals.dta

*CROP PRODUCTION COSTS PER HECTARE	Uganda_NPS_LSMS_ISA_W1_hh_cost_land.dta
									Uganda_NPS_LSMS_ISA_W1_hh_cost_inputs_lrs.dta
									Uganda_NPS_LSMS_ISA_W1_hh_cost_inputs_srs.dta
									Uganda_NPS_LSMS_ISA_W1_hh_cost_seed_lrs.dta
									Uganda_NPS_LSMS_ISA_W1_hh_cost_seed_srs.dta		
									Uganda_NPS_LSMS_ISA_W1_cropcosts_perha.dta

*RATE OF FERTILIZER APPLICATION		Uganda_NPS_LSMS_ISA_W1_fertilizer_application.dta
*HOUSEHOLD'S DIET DIVERSITY SCORE	Uganda_NPS_LSMS_ISA_W1_household_diet.dta
*WOMEN'S CONTROL OVER INCOME		Uganda_NPS_LSMS_ISA_W1_control_income.dta
*WOMEN'S AG DECISION-MAKING			Uganda_NPS_LSMS_ISA_W1_make_ag_decision.dta
*WOMEN'S ASSET OWNERSHIP			Uganda_NPS_LSMS_ISA_W1_ownasset.dta
*AGRICULTURAL WAGES					Uganda_NPS_LSMS_ISA_W1_ag_wage.dta
*CROP YIELDS						Uganda_NPS_LSMS_ISA_W1_yield_hh_crop_level.dta

*FINAL FILES						MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD VARIABLES				Uganda_NPS_LSMS_ISA_W1_household_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			Uganda_NPS_LSMS_ISA_W1_individual_variables.dta	
*PLOT-LEVEL VARIABLES				Uganda_NPS_LSMS_ISA_W1_gender_productivity_gap.dta
*SUMMARY STATISTICS					Uganda_NPS_LSMS_ISA_W1_summary_stats.xlsx
*/
clear
set more off
clear matrix
clear mata
*set maxvar 8000 - was not in original draft do-file - is this needed? CJS 2.4.2020
ssc install findname

//set directories
*These paths correspond to the folders where the raw data files are located and where the created data and final data will be stored.
*wfh global folder

global root_folder "R:/Project/EPAR/Working Files/378 - LSMS Burkina Faso, Malawi, Uganda/uganda-wave1-2009-10"
global UGS_W1_raw_data 	"${root_folder}/raw_data"
global UGS_W1_created_data "${root_folder}/temp"
global UGS_W1_final_data  "${root_folder}/outputs"
global directory "R:\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\_SUMMARY_STATS"

****************************
*EXCHANGE RATE AND INFLATION
****************************
global NPS_LSMS_ISA_W1_exchange_rate 3690.85
global NPS_LSMS_ISA_W1_gdp_ppp_dollar 1270.608398
    // https://data.worldbank.org/indicator/PA.NUS.PPP //updated 4.6.23 to 2017 value
global NPS_LSMS_ISA_W1_cons_ppp_dollar 1221.087646
	 // https://data.worldbank.org/indicator/PA.NUS.PRVT.PP //updated 4.6.23 to 2017 value
global NPS_LSMS_ISA_W1_inflation  0.59959668237 // CPI_Survey_Year/CPI_2017 -> CPI_2010/CPI_2017 ->  (100/166.7787747)
//https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2016&locations=UG&start=2010 // The data were collected over the period 2009 - 2010

********Currency Conversion Factors*********

*THRESHOLDS FOR WINSORIZATION
********************************************************************************
global wins_lower_thres 1    						//Threshold for winzorization at the bottom of the distribution of continous variables
global wins_upper_thres 99							//Threshold for winzorization at the top of the distribution of continous variables

/*
********************************************************************************
RE-SCALING SURVEY WEIGHTS TO MATH POPULATION ESTIMATES
********************************************************************************
*1.5.23 SAW Might need to do this at some point. Below NGA Wave 3 Reference. 
*DYA.11.1.2020 Re-scaling survey weights to match population estimates
*https://databank.worldbank.org/source/world-development-indicators#
global Nigeria_GHS_W3_pop_tot 181137448
global Nigeria_GHS_W3_pop_rur 94484916
global Nigeria_GHS_W3_pop_urb 86652532
*/
********************************************************************************
*GLOBALS OF PRIORITY CROPS 
********************************************************************************
//Purpose: Generate a crop .dta file that only contains the priority crops. This is used in for a couple of other indicators down the line. You can edit this section to change which crops you are examining.

*Enter the 12 priority crops here (maize, rice, wheat, sorghum, pearl millet (or just millet if not disaggregated), cowpea, groundnut, common bean, yam, sweet potato, cassava, banana)
*plus any crop in the top ten crops by area planted that is not already included in the priority crops - limit to 6 letters or they will be too long!
*For consistency, add the 12 priority crops in order first, then the additional top ten crops
global topcropname_area  "maize cassav beans fldpea swtptt fmillt sybea banana coffee grdnt sorgum"
global topcrop_area "130 630 210 221 620 141 320 741 810 310 150"
global comma_topcrop_area "130, 630, 210, 221, 620, 141, 320, 741, 810, 310, 150"
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
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_cropname_table.dta", replace //This gets used to generate the monocrop files.
*All cropID match with UG w5 except for banana which has 3 different typesof crops banana food 741 banana beer 742 banana 744. 
********************************************************************************
*THRESHOLDS FOR WINSORIZATION
********************************************************************************
global wins_lower_thres 1    						//Threshold for winzorization at the bottom of the distribution of continous variables
global wins_upper_thres 99							//Threshold for winzorization at the top of the distribution of continous variables

********************************************************************************
*HOUSEHOLD IDS* 
********************************************************************************
use "${UGS_W1_raw_data}/2009_GSEC1.dta", clear
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

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hhids.dta" , replace 

********************************************************************************
*WEIGHTS*
********************************************************************************
use "${UGS_W1_raw_data}/2009_GSEC1.dta", clear
rename wgt09 weight // AA, in SAW code, mult=wgt09 
merge m:1 HHID using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hhid.dta"
keep HHID weight rural 

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_weights.dta" , replace

********************************************************************************
*INDIVIDUAL IDS*
********************************************************************************
use "${UGS_W1_raw_data}/2009_GSEC2.dta" , clear 
gen female=h2q3==2 
ren h2q1 individual
lab var female "1= individual is female"
gen age=h2q8 // AA: 1,061 missing values geneerated 
lab var age "individual age" 
gen hh_head=h2q4==1
lab var hh_head "1=individual household head"
keep HHID PID female age hh_head individual

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_person_ids.dta" , replace 

********************************************************************************
*HOUSEHOLD SIZE*
********************************************************************************
use "${UGS_W1_raw_data}/2009_GSEC2.dta", clear
gen hh_members = 1 
ren h2q4 realhead // relationship to household head 
ren h2q3 gender // sex (gender) ------> "variable already defined" !!!!!!
gen fhh = (realhead==1 & gender==2) // we only want the households with a female head og household, even if its a small number 
collapse (sum) hh_members (max) fhh, by (HHID) 
lab var hh_members "Number of household members"
lab var fhh "1= Female-headed household" 

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hhsize.dta", replace 

********************************************************************************
*PLOT AREA*
********************************************************************************
use "${UGS_W1_raw_data}/2009_AGSEC4A.dta" , clear 
gen season=1 
append using "${UGS_W1_raw_data}/2009_AGSEC4B.dta" , generate(last) 
replace season=2 if last==1 
label var season "season = 1 is 1st cropping season of 2011, 2 if 2nd cropping season of 2011" 
//check for plot area varriable 
gen plot_area=A4aq8 // vlaues are in acres (total area of plot planted) A4aq9 percentage of crop planted in the plot area 
replace plot_area = A4bq8 if plot_area==. //values are in acres 
replace plot_area = plot_area * 0.404686 //conversion factor is 0.404686 ha = 1 acre.
rename plot_area ha_planted 
 
*Now, generate variables to fix issus with the percentage of a plot that crops are planted on not adding up to 100 (both above and below). This is complicated so each line below explains the procedure 
gen percent_planted = A4aq9/100
replace percent_planted = A4bq9/ 100 if percent_planted==. 

*rainy season, dry seaon (create and append/ replace parcelID to combine seasons into one column) 
rename A4aq2 parcelID
replace parcelID = A4bq2 if season ==2

*similar to rainy and dry season, create a singular column for plotID 
rename A4aq4 plotID
replace plotID = A4bq4 if season ==2

bys Hhid parcelID plotID season : egen total_percent_planted = sum(percent_planted) //generate variable for total percent of a plot that is planted (all crops) 
duplicates tag Hhid parcelID plotID season, g(dupes) //generate a duplicates ratio to check for all crops on a specific plot. the number in dupes indicates all of the crops on a plot minus one (the "oiginal") 

gen missing_ratios = dupes > 0 & percent_planted ==. //now use that duplicate variable to find crops that dont have any indication of how much a plot they take up, even though there are multiple crops on that plot (otherwise, duplicate woud equal 0) 
bys Hhid parcelID plotID season : egen total_missing =sum(missing_ratios) //generate a count, per plot, of how many crops do not have a percentage planted value. 
gen remaining_land = 1 - total_percent_planted if total_percent_planted <1 //calculate the amount of remaining land on a plot (that can be divided up amongst crops with no percenatage planted) if it doesn't add up to 100% 
bys Hhid parcelID plotID season :  egen any_missing = max(missing_ratios)
*fix monocropped plots 
replace percent_planted = 1 if percent_planted == . & any_missing == 0 //monocropped plots are marked with a percentage of 100% - impacts large amount of crops 
*fix plots with or without missing percentages that add up to 100% or more 
replace percent_planted = 1/(dupes +1) if any_missing == 1 & total_percent_planted >=1 // if there are any missing percentages and plot is at or above 100%, everything on the plot is equally divided (as dupes indicates the number of crops on that plot minus one) - this impacts crops 
replace percent_planted = percent_planted/total_percent_planted if total_percent_planted > 1 //some crops still add up to over 100%, but these ones aren't missing percentages. So we need to reduce them all proportionally so they add up tp 100% but dont loose their relative importance. 
*Fix plot that add up to less than 100% and have missing percentages 
replace percent_planted = remaining_land/total_missing if missing_ratios == 1 & percent_planted == . & total_percent_planted < 1 //if any plots are missing a percentage but are below 100%, the remaining land is subdivided amongst the number of crops missing a perctange - impacts 302 crops

*Bring everything together
collapse(max) ha_planted (sum) percent_planted, by(Hhid parcelID plotID season)
gen plot_area = ha_planted / percent_planted
bys Hhid parcelID season : egen total_plot_area = sum(plot_area)
generate plot_area_pct = plot_area/total_plot_area
keep Hhid parcelID plotID season plot_area total_plot_area plot_area_pct ha_planted
rename Hhid HHID
tempfile sea1 sea2 sea3 // Ahana: why are these temp files being created? 
save `sea1'

use "${UGS_W1_raw_data}/2009_AGSEC2A.dta", clear 
ren A2aq2 parcelID
ren Hhid HHID
save `sea2'

use "${UGS_W1_raw_data}/2009_AGSEC2B.dta", clear 
ren A2bq2 parcelID
ren Hhid HHID
save `sea3'

use `sea1', clear
merge m:1 HHID parcelID using `sea2', nogen 
merge m:1 HHID parcelID using `sea3', nogen // use a temporary file to merge the 1 to many, sea1, sea2, sea3 to merge raw data together (combines the appended season w additonally appened season variables in additional data set) 

***generating field_size using merged variables***
generate parcel_acre = parcelID // Replaced missing GPS estimation here to get parcel size in acres if we have it, but many parcels do not have gps estimation
replace parcel_acre = A2bq4 if parcel_acre == . 
replace parcel_acre = A2aq5 if parcel_acre == . // Replaced missing GPS values with farmer estimation, which is less accurate but has full coverage (and is also in acres) 
replace parcel_acre = A2bq5 if parcel_acre == . // see above 
gen field_size = plot_area_pct*parcel_acre // Using calculated percentages of plots (out of total plots per parcel) to estimate plot size using more accurate parcel measurements 
replace field_size = field_size * 0.404686 // CONVERSION FACTOR IS 0.404686 ha = 1 acre 
gen parcel_ha = parcel_acre * 0.404686 
*cleaning up and saving the data 
rename plotID plot_id 
rename parcelID parcel_id 
keep HHID parcel_id plot_id season field_size plot_area total_plot_area parcel_acre ha_planted parcel_ha
drop if field_size == . 
label var field_size "area of plot (ha)"
label var HHID "household identifier"
tostring HHID , format(%18.0f) replace 

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_areas.dta" , replace 

********************************************************************************
*PLOT DECISION MAKERS
********************************************************************************
use "${UGS_W1_raw_data}/2009_GSEC2.dta" , clear 
ren PID personid 
gen female =h2q3==2
ren h2q8 age 
gen head= h2q4==1 if h2q4!=. 
keep personid female age HHID head 
lab var female "1=Idividual is female"
lab var age "Individual age"
lab var head "1=Individual is the head of household"
/* destring HHID, personid, replace // bad idea because this looses info, converting to string downstream. 
sort HHID personid 
quietly buy HHID personid: gen dup = cond(_N==1, 0, _n_ 
drop id dup>1 //76 observations deleted 
drop dup 
*duplicates drop HHID personid, force // Q. delete? // AK - dropping duplicates created by destringing
*/

save "${UGS_W1_created_data/Uganda_NPS_LSMS_ISA_W1_TLU_gender_merge.dta}" , replace 

use "${UGS_W1_raw_data}/2009_AGSEC3A.dta" , clear 
ren Hhid HHID
gen season =1 
append using "${UGS_W1_raw_data}/2009_AGSEC3B.dta" 
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

use "${UGS_W1_raw_data}/2009_AGSEC2A.dta" , clear 
ren Hhid HHID
gen season =1 
append using "${UGS_W1_raw_data}/2009_AGSEC2B.dta" 
replace season =2 if season == . 
*ren A3aq3 plot_id 
ren A2aq2 parcel_id // using parcel ID 
drop if parcel_id == .
merge 1:m HHID season parcel_id using `plotid'

*Gender/age variables
gen individual = A2aq28a   
replace individual = A2bq26a if individual == . & A2bq26a!=.
merge m:1 HHID individual using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_person_ids.dta", gen(dm1_merge) keep(1 3) //Dropping unmatched from using

*first decision-maker variable
gen dm1_female = female
drop female individual

*second decision-maker
gen individual = A2aq28b 
replace individual = A2bq26b if individual == . & A2bq26b!=.                                                                
merge m:1 HHID individual using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_person_ids.dta", gen(dm2_merge) keep(1 3) //Dropping unmatched from using
gen dm2_female = female
drop female individual

*Constructing three-part gendered decision-maker variable; male only (=1) female only (=2) or mixed (=3)
gen dm_gender = 1 if (dm1_female==0 | dm1_female==.) & (dm2_female==0 | dm2_female==.) & !(dm1_female==. & dm2_female==.)		
replace dm_gender = 2 if (dm1_female==1 | dm1_female==.) & (dm2_female==1 | dm2_female==.) & !(dm1_female==. & dm2_female==.)
replace dm_gender = 3 if dm_gender==. & !(dm1_female==. & dm2_female==.)
la def dm_gender 1 "Male only" 2 "Female only" 3 "Mixed gender"
la val dm_gender dm_gender
lab var  dm_gender "Gender of plot manager/decision maker"


*Replacing observations without gender of plot manager with gender of HOH
merge m:1 HHID using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hhsize.dta", nogen 								
replace dm_gender = 1 if fhh==0 & dm_gender==.
replace dm_gender = 2 if fhh==1 & dm_gender==.
//ren plotnum parcel_id 
drop if  parcel_id==.
keep HHID season plot_id parcel_id dm_gender //cultivated
//plot id's correction 
duplicates drop HHID season parcel_id, force

//lab var cultivated "1=Plot has been cultivated"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_decision_makers.dta", replace

********************************************************************************
*FORMALIZED LAND RIGHTS
*******************************************************************************
use "${UGS_W1_raw_data}/2009_AGSEC2a.dta", clear
gen season = 1 
append using "${UGS_W1_raw_data}/2009_AGSEC2B.dta" 
replace season = 2 if season == . 
gen formal_land_rights = 1 if A2aq25<4
replace formal_land_rights = 0 if A2aq25==4 

*starting with first owner 
preserve
gen individual=A2aq26a
replace individual=A2aq26b if individual==. & A2aq26b!=. 
ren Hhid HHID
merge m:1 HHID individual using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_person_ids.dta" , nogen keep(3) // individual similar to PID 
keep HHID individual female formal_land_rights
tempfile p1 
save `p1', replace 
restore 

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_land_rights_hh.dta" , replace 

********************************************************************************
** 								ALL PLOTS									  **
********************************************************************************

********************************************************************************
*CROP VALUES*
********************************************************************************
use "${UGS_W1_raw_data}/2009_AGSEC5a" , clear 
ren A5aq1 A5bq1
ren A5aq3 A5bq3
ren A5aq4 A5bq4
ren A5aq5 A5bq5
gen season=1
append using "${UGS_W1_raw_data}/2009_AGSEC5B"
replace season=2 if season==.
ren A5bq1 parcel_id
ren A5bq3 plot_id
rename A5bq5 crop_code 
rename A5bq4 crop_name 

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
clonevar conv_factor_sold = A5bq6d //  A5AQ7D not in dataset, used closed variable 
replace conv_factor_sold = A5bq6d if season==2 
replace conv_factor_sold = 1 if sold_unit_code==1
gen sold_qty=A5aq7a
replace sold_qty=A5bq7a if sold_qty==.
gen quant_sold_kg = sold_qty*conv_factor_sold 

tostring Hhid, format(%18.0f) replace
rename Hhid HHID
merge m:1 HHID using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hhids.dta", nogen keepusing(region district county subcounty parish ea weight) keep(1 3)
label values crop_code cropID //apply crop labels to crop_code_master

**********************************
** Standard Conversion Factor Table **
**********************************
***We merge Crop Sold Conversion Factor at the crop-unit-regional level***
merge m:1 crop_code sold_unit_code region using "${UGS_W1_created_data}/UG_Conv_fact_sold_table_update.dta", keep(1 3) nogen 

***We merge Crop Sold Conversion Factor at the crop-unit-national level***
*This is for HHID with missing regional information. 
merge m:1 crop_code sold_unit_code  using "${UGS_W1_created_data}/UG_Conv_fact_sold_table_national_update.dta", keep(1 3) nogen 

*We create Quantity Sold (kg using standard  conversion factor table for each crop- unit and region). 
replace s_conv_factor_sold = sn_conv_factor_sold if region!=. // We merge the national standard conversion factor for those HHID with missing regional info. 
gen s_quant_sold_kg = sold_qty*s_conv_factor_sold
replace s_quant_sold_kg=. if sold_qty==0 | sold_unit_code==.
gen s_price_unit = sold_value/s_quant_sold_kg 
gen obs1 = s_price_unit!=.


// Loop for price per kg for each crop at different geographic dissagregate using Standard price per kg variable (from standard conversion factor table)
	foreach i in region district county subcounty parish ea HHID {
		preserve
		bys `i' crop_code /*sold_unit_code*/ : egen s_obs_`i'_price = sum(obs1)
		collapse (median) s_price_unit_`i' = s_price_unit [aw=weight], by /*(`i' sold_unit_code crop_code obs_`i'_price)*/ (crop_code /*sold_unit_code*/ `i' s_obs_`i'_price)
		tempfile s_price_unit_`i'_median
		save `s_price_unit_`i'_median'
		restore
	}
	preserve
	collapse (median) s_price_unit_country = s_price_unit (sum) s_obs_country_price = obs1 [aw=weight], by(crop_code /*sold_unit_code*/)
	tempfile s_price_unit_country_median
	save `s_price_unit_country_median'
	restore

***We merge Crop Harvested Conversion Factor at the crop-unit-regional ***
clonevar  unit_code= unit_code_harv
merge m:1 crop_code unit_code region using "${UGS_W1_created_data}/UG_Conv_fact_harvest_table_update.dta", keep(1 3) nogen 

***We merge Crop Harvested Conversion Factor at the crop-unit-national ***
merge m:1 crop_code unit_code using "${UGS_W1_created_data}/UG_Conv_fact_harvest_table_national_update.dta", keep(1 3) nogen 
*This is for HHID that are missing regional information

*From Conversion factor section to calculate medians
clonevar quantity_harv=A5aq6a
replace quantity_harv=A5bq6a if quantity_harv==.
gen quant_harv_kg = quantity_harv*conv_factor_harv 
replace s_conv_factor_harv = sn_conv_factor_harv if region!=. // We merge the national standard conversion factor for those HHID with missing regional info.
gen s_quant_harv_kg = quantity_harv*s_conv_factor_harv 

**********************************
* Update: Standard Conversion Factor Table END **
**********************************
*Create Price unit for converted sold quantity (kgs)
gen price_unit=sold_value/(quant_sold_kg)
label var price_unit "Average sold value per kg of harvest sold"
gen obs = price_unit!=.
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_value.dta", replace 
*We collapse to get to a unit of analysis at the HHID, parcel, plot, season level instead of ... plot, season, condition and unit of crop harvested*/

//This loop below creates a value for the price of each crop at the given regional levels seen in the first line. It stores this in temporary storage to allow for cleaner, simpler code, but could be stored permanently if you want.
	foreach i in region district county subcounty parish ea HHID {
		preserve
		bys `i' crop_code /*sold_unit_code*/ : egen obs_`i'_price = sum(obs)
		collapse (median) price_unit_`i' = price_unit [aw=weight], by /*(`i' sold_unit_code crop_code obs_`i'_price)*/ (crop_code /*sold_unit_code*/ `i' obs_`i'_price)
		*rename sold_unit_code unit_code_harv //needs to be done for a merge near the end of the all_plots indicator
		tempfile price_unit_`i'_median
		save `price_unit_`i'_median'
		restore
	}
	preserve
	collapse (median) price_unit_country = price_unit (sum) obs_country_price = obs [aw=weight], by(crop_code /*sold_unit_code*/)
	*rename sold_unit_code unit_code_harv //needs to be done for a merge near the end of the all_plots indicator
	tempfile price_unit_country_median
	save `price_unit_country_median'
	
	restore
**********************************
** [Harvest and Sold] Crop Unit Conversion Factors  **
**********************************
**********************************
** Plot Variables **
**********************************
*Ahana Comment: Had to go into "${UGS_W1_raw_data}/2009_AGSEC4A" to make the variable names the same in order to append it propoerly
preserve 
use "${UGS_W1_raw_data}/2009_AGSEC4A", clear 
gen season=1
rename A4aq2 A4bq2
rename A4aq6 A4bq6
rename A4aq4 A4bq4
append using "${UGS_W1_raw_data}/2009_AGSEC4B"
replace season=2 if season==.
gen crop_code_plant=A4bq6
*rename hhid HHID
rename A4bq4 plot_id
rename A4bq2 parcel_id
*rename A4aq5 crop_code_plant //crop codes for what was planted
*encode crop_code_plant, replace
drop if crop_code_plant == .
clonevar crop_code_master = crop_code_plant 
tostring Hhid, format(%18.0f) replace
rename Hhid HHID
merge m:1 HHID parcel_id plot_id season using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_areas.dta", nogen keep(1 3)	

gen perm_tree = 1 if inlist(crop_code_master, 460, 630, 700, 710, 720, 740, 750, 760, 770, 780, 810, 820, 830, 870) //dodo, cassava, oranges, pawpaw, pineapple, bananas, mango, jackfruit, avocado, passion fruit, coffee, cocoa, tea, and vanilla, and 740 banana that is still 741 742 and 744
replace perm_tree = 0 if perm_tree == .
lab var perm_tree "1 = Tree or permanent crop" // 
duplicates drop HHID parcel_id plot_id crop_code_plant season, force
rename crop_code_plant crop_code
tempfile plotplanted
save `plotplanted'
restore
merge m:1 HHID parcel_id plot_id crop_code season using `plotplanted', nogen keep(1 3)
**********************************
** Plot Variables After Merge **
**********************************
*Generate crops_plot variable for number of crops per plot. This is used to fix issues around intercropping and relay cropping being reported inaccurately for our purposes.
	preserve
		gen obs2 = 1
		replace obs2 = 0 if inrange(A5aq17,1,6) | inrange(A5bq17,1,6) //obs = 0 if crop was lost for some reason like theft, flooding, pests, etc. SAW 6.29.22 Should it be 1-5 not 1-4?
		collapse (sum) crops_plot = obs2, by(HHID parcel_id plot_id season)
		tempfile ncrops 
		save `ncrops'
	restore 
	merge m:1 HHID parcel_id plot_id season using `ncrops', nogen
	gen contradict_mono = 1 if A4aq9 == 100 | A4bq9 == 100 & crops_plot > 1 //6 plots have >1 crop but list monocropping
	gen contradict_inter = 1 if crops_plot == 1
	replace contradict_inter = . if A4aq9 == 100 | A4aq8 == 1 | A4bq9 == 100 | A4bq8 == 1 //meanwhile 145 list intercropping or mixed cropping but only report one crop

*Generate variables around lost and replanted crops
	gen lost_crop = inrange(A5aq17,1,6) | inrange(A5bq17,1,6) // SAW I think it should be intange(var,1,5) why not include "other"
	bys HHID parcel_id plot_id season : egen max_lost = max(lost_crop) //more observations for max_lost than lost_crop due to parcels where intercropping occurred because one of the crops grown simultaneously on the same plot was lost
	gen replanted = (max_lost == 1 & crops_plot > 0)
	drop if replanted == 1 & lost_crop == 1 //Crop expenses should count toward the crop that was kept, probably. 89 plots did not replant; keeping and assuming yield is 0.

	*Generating monocropped plot variables (Part 1)
	bys HHID parcel_id plot_id season: egen crops_avg = mean(crop_code_master) //Checks for different versions of the same crop in the same plot and season
	gen purestand = 1 if crops_plot == 1 //This includes replanted crops
	bys HHID parcel_id plot_id season : egen permax = max(perm_tree)
	bys HHID parcel_id plot_id season  : gen plant_date_unique = _n
	bys HHID parcel_id plot_id season : egen plant_dates = max(plant_date_unique)
	
	*Generating mixed stand plot variables (Part 2)
	gen mixed = (A4aq8 == 2 | A4bq8 == 2)
	bys HHID parcel_id plot_id season : egen mixed_max = max(mixed)
	replace purestand = 1 if crop_code == crops_avg //multiple types of the same crop do not count as intercropping
	replace purestand = 0 if purestand == . //assumes null values are just 0 
	lab var purestand "1 = monocropped, 0 = intercropped or relay cropped"
	drop crops_plot crops_avg 
	*plant_dates harv_dates plant_date_unique harv_date_unique permax
	

**# Bookmark #1: Check
	gen percent_field = ha_planted/field_size
*Generating total percent of purestand and monocropped on a field
	bys HHID parcel_id plot_id season: egen total_percent = total(percent_field)
	*Dealing with crops which have monocropping larger than plot size or monocropping that fills plot size and still has intercropping to add
	replace percent_field = percent_field/total_percent if total_percent > 1 & purestand == 0
	replace percent_field = 1 if percent_field > 1 & purestand == 1
	replace ha_planted = percent_field*field_size

**********************************
** Crop Harvest Value **
**********************************
*Update Incorporating median price per kg to calculate Value of Harvest ($) -using WB Conversion factors 
foreach i in  region district county subcounty parish ea HHID {	
	merge m:1 `i' /*unit_code*/ crop_code using `price_unit_`i'_median', nogen keep(1 3)
	merge m:1 /*unit_code*/ crop_code using `price_unit_country_median', nogen keep(1 3)
}
rename price_unit val_unit

*Incorporating median standard price per kg to calculate Value of Harvest ($) - Using Standard Conversion Factors 
foreach i in  region district county subcounty parish ea HHID {	
	merge m:1 `i' /*unit_code*/ crop_code using `s_price_unit_`i'_median', nogen keep(1 3)
	merge m:1 /*unit_code*/ crop_code using `s_price_unit_country_median', nogen keep(1 3)
}
rename s_price_unit s_val_unit

*Generate a definitive list of value variables
// Prefer observed prices first, starting at the highest level (country) and moving to the lowest level 
recode obs_* (.=0) //ALT 
foreach i in country region district county subcounty parish ea {
	replace val_unit = price_unit_`i' if obs_`i'_price > 9
}
	gen val_missing = val_unit == .
	replace val_unit = price_unit_HHID if price_unit_HHID != .
gen value_harvest = val_unit*quant_harv_kg 

*  Sebastian Note: Generate a definitive list of value variables: Same as above but using the standard price per kg instead of the wb price per kg
recode s_obs_* (.=0) //ALT 
foreach i in country region district county subcounty parish ea {
	replace s_val_unit = s_price_unit_`i' if s_obs_`i'_price > 9
}
	gen s_val_missing = s_val_unit == .
	replace s_val_unit = s_price_unit_HHID if s_price_unit_HHID != .

gen s_value_harvest = s_val_unit*s_quant_harv_kg 


preserve
	ren unit_code_harv unit
	collapse (mean) val_unit, by (HHID crop_code unit)
	ren val_unit hh_price_mean
	lab var hh_price_mean "Average price reported for this crop-unit in the household"
	save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_for_wages2.dta", replace
	restore

	*AgQuery+
collapse (sum) quant_harv_kg value_harvest ha_planted percent_field s_quant_harv_kg s_value_harvest, by(region district county subcounty parish ea HHID parcel_id plot_id season crop_code_master purestand field_size /*month_planted month_harvest*/)
	bys HHID parcel_id plot_id season : egen percent_area = sum(percent_field)
	bys HHID parcel_id plot_id season : gen percent_inputs = percent_field / percent_area
	drop percent_area //Assumes that inputs are +/- distributed by the area planted. Probably not true for mixed tree/field crops, but reasonable for plots that are all field crops
	merge m:1 HHID parcel_id plot_id season using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
	save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_all_plots.dta", replace

********************************************************************************
** 								ALL PLOTS END								  **
*******************************************************************************
********************************************************************************
*                              GROSS CROP REVENUE                              *
********************************************************************************
*Temporary crops (both seasons) 
use "${UGS_W1_raw_data}/2009_AGSEC5A.dta", clear 
rename A5aq1 A5bq1
rename A5aq3 A5bq3
rename A5aq5 A5bq5
append using "${UGS_W1_raw_data}/2009_AGSEC5B.dta"
* Standardizing major variable names across waves/files
rename Hhid HHID
rename A5bq1 parcel_id 
rename A5bq3 plot_id 
rename A5bq5 crop_code 
rename A5aq6a qty_harvest 

replace qty_harvest = A5bq6a if qty_harvest ==. 
drop if plot_id == . 
*recode crop_code  (741 742 744 = 740) //740 is bananas, which is being reduced from different types to just bananas. Same for peas (220).
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
merge m:1 HHID using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hhids.dta", nogen keepusing(region district county subcounty parish ea weight) keep(1 3)
***We merge Crop Sold Conversion Factor at the crop-unit-regional level***
merge m:1 crop_code sold_unit_code region using "${UGS_W1_created_data}/UG_Conv_fact_sold_table.dta", keep(1 3) nogen 

***We merge Crop Sold Conversion Factor at the crop-unit-national level***
*This is for HHID with missiong regional information. 
merge m:1 crop_code sold_unit_code  using "${UGS_W1_created_data}/UG_Conv_fact_sold_table_national.dta", keep(1 3) nogen 

rename A5aq6d conversion 
replace conversion = A5bq6d if conversion==. & A5bq6d!=. 
gen conversion_sold=A5aq6c
replace conversion_sold = A5bq6c if conversion_sold ==. 
gen kgs_harvest = qty_harvest * conversion 
** Used A5aq6d as conversion factor since questionnaire labelled that as the conversion to kgs 
replace s_conv_factor_sold = sn_conv_factor_sold if region!=. //  We merge the national standard conversion factor for those HHID with missing regional info. 
gen kgs_sold = qty_sold*s_conv_factor_sold
collapse (sum) value_sold kgs_sold, by (HHID crop_code)
lab var value_sold "Value of sales of this crop"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_cropsales_value.dta", replace

use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_all_plots.dta", clear

ren crop_code_master crop_code
collapse (sum) s_value_harvest s_quant_harv_kg quant_harv_kg , by (HHID crop_code) // Update: SW We start using the standarized version of value harvested and kg harvested
merge 1:1 HHID crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_cropsales_value.dta"

replace s_value_harvest = value_sold if value_sold>s_value_harvest & value_sold!=. /* In a few cases, sales value reported exceeds the estimated value of crop harvest */
ren value_sold value_crop_sales 
recode  s_value_harvest value_crop_sales  (.=0)
collapse (sum) s_value_harvest value_crop_sales kgs_sold s_quant_harv_kg quant_harv_kg, by (HHID crop_code)
ren s_value_harvest value_crop_production
lab var value_crop_production "Gross value of crop production, summed over main and short season"
lab var value_crop_sales "Value of crops sold so far, summed over main and short season"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hh_crop_values_production.dta", replace

collapse (sum) value_crop_production value_crop_sales, by (HHID)
lab var value_crop_production "Gross value of crop production for this household"
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hh_crop_production.dta", replace

use "${UGS_W1_raw_data}/2009_AGSEC5A.dta", clear 
rename A5aq1 A5bq1
rename A5aq3 A5bq3
rename A5aq5 A5bq5
append using "${UGS_W1_raw_data}/2009_AGSEC5B.dta"
* Standardizing major variable names across waves/files
rename Hhid HHID
rename A5bq1 parcel_id 
rename A5bq3 plot_id 
rename A5bq5 crop_code 
rename A5aq6a qty_harvest 

*recode crop_code  (741 742 744 = 740) //740 is bananas, which is being reduced from different types to just bananas. Same for peas (220).
drop if crop_code==.
rename A5aq16 percent_lost
replace percent_lost = A5bq16 if percent_lost==. & A5bq16!=.
replace percent_lost = 100 if percent_lost > 100 & percent_lost!=. 
tostring HHID, format(%18.0f) replace
merge m:1 HHID crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hh_crop_values_production.dta", nogen keep(1 3)
gen value_lost = value_crop_production * (percent_lost/100)
recode value_lost (.=0)
collapse (sum) value_lost, by (HHID)
rename value_lost crop_value_lost
lab var crop_value_lost "Value of crop production that had been lost by the time of survey"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_losses.dta", replace

********************************************************************************
** 								CROP EXPENSES								  **
******************************************************************************** 
	*********************************
	* 			LABOR				*
	*********************************
*Hired Labor 
use "${UGS_W1_raw_data}/2009_AGSEC3A", clear 
gen season = 1	
rename Hhid HHID
rename A3aq1 A3bq1
rename A3aq3 A3bq3
rename A3aq5 A3bq5
append using "${UGS_W1_raw_data}/2009_AGSEC3B"
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
merge m:1 HHID parcel_id plot_id season using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_areas.dta", nogen keep(1 3) keepusing(field_size)
merge m:1 HHID using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_weights.dta", nogen keep(1 3) keepusing(weight)
merge m:1 HHID using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hhids.dta", nogen keep(1 3)
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

use "${UGS_W1_raw_data}/2009_AGSEC3A", clear 
gen season = 1
rename Hhid HHID
rename A3aq1 a3bq1
rename A3aq3 a3bq3
rename A3aq5 a3bq5
append using "${UGS_W1_raw_data}/2009_AGSEC3B"
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
use "${UGS_W1_raw_data}/2009_GSEC2", clear 
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
merge m:1 HHID using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hhids.dta", nogen keep(1 3) //merge in regional data (districts, etc.)
keep region district county subcounty parish ea HHID parcel_id plot_id season gender days labor_type fam_worker_count

foreach i in region district county subcounty parish ea HHID {
	merge m:1 `i' gender season using `wage_`i'_median', nogen keep(1 3) 
}
	merge m:1 gender season using `wage_country_median', nogen keep(1 3) //1,692 with missing vals b/c they don't have matches on pid, see code above

	gen wage = wage_HHID
	*recode wage (.=0)
foreach i in country region district county subcounty parish ea {
	replace wage = wage_`i' if obs_`i' > 9
	} //Goal of this loop is to get median wages to infer value of family labor as an implicit expense. Uses continually more specific values by geography to fill in gaps of implicit labor value.

egen wage_sd = sd(wage_HHID), by(gender season)
egen mean_wage = mean(wage_HHID), by(gender season)
replace wage = wage_HHID if wage_HHID != . & abs(wage_HHID - mean_wage) / wage_sd < 3 
* Total days of work for family labor but not for each individual on the hhhd we need to divide total days by number of subgroups of gender that were included as workers in the farm within each household. OR we could assign median wages irrespective of gender (we would need to calculate that in family hired by geographic levels of granularity irrespective ofgender)
by HHID parcel_id plot_id season, sort: egen numworkers = count(_n)
replace days = days/numworkers // If we divided by famworkers we would not be capturing the total amount of days worked. 
gen val = wage * days
append using `all_hired'
keep region district county subcounty parish ea HHID parcel_id plot_id season days val labor_type gender
drop if val == . & days == .
merge m:1 HHID parcel_id plot_id season using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
collapse (sum) val days, by(HHID parcel_id plot_id season labor_type gender dm_gender) // Number of workers is not measured by this survey, may affect agwage section
	la var gender "Gender of worker"
	la var dm_gender "Plot manager gender"
	la var labor_type "Hired, exchange, or family labor"
	la var days "Number of person-days per plot"
	la var val "Total value of hired labor (Naira)"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_labor_long.dta", replace

preserve
collapse (sum) labor_ = days, by (HHID parcel_id plot_id labor_type)
reshape wide labor_, i(HHID parcel_id plot_id) j(labor_type) string
		la var labor_family "Number of family person-days spent on plot, all seasons"
		la var labor_hired "Number of hired labor person-days spent on plot, all seasons"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_labor_days.dta", replace
restore

preserve
	gen exp = "exp" if strmatch(labor_type,"hired")
	replace exp = "imp" if strmatch(exp, "")
	collapse (sum) val, by(HHID parcel_id plot_id exp dm_gender) 
	gen input = "labor"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_labor.dta", replace
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
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hh_cost_labor.dta", replace

******************************************************************************
** CHEMICALS, FERTILIZER, LAND, ANIMALS (excluded for Uganda), AND MACHINES **
******************************************************************************
*Notes: This is still part of the Crop Expenses Section.
**********************    PESTICIDES/HERBICIDES   ******************************
use "${UGS_W1_raw_data}/2009_AGSEC3A", clear 
gen season = 1
rename Hhid HHID
rename A3aq1 a3bq1
rename A3aq3 a3bq3
rename A3aq5 a3bq5
append using "${UGS_W1_raw_data}/2009_AGSEC3B"
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
use "${UGS_W1_raw_data}/2009_AGSEC10", clear 

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
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_areas.dta", clear
collapse (sum) ha_planted, by(HHID)
ren ha_planted ha_planted_total
tempfile ha_planted_total
save `ha_planted_total'
restore
	
preserve
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_areas.dta", clear
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
merge m:1 HHID using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hhids.dta", nogen keep(1 3)
save `plot_inputs'
*Notes: Does the quantity for machinery matters here? Right now we haven't constructed a qtymechimp qtymechexp variable so quantity var for mech is always missing. Let Josh now so he can update UG W5.

******************************************************************************
****************************     FERTILIZER   ********************************** 
******************************************************************************
*SAW Using Josh Code as reference which uses Nigeria W3 Code.
use "${UGS_W1_raw_data}/2009_AGSEC3A", clear 
rename Hhid HHID
gen season = 1
rename A3aq1 a3bq1
rename A3aq3 a3bq3
append using "${UGS_W1_raw_data}/2009_AGSEC3B"
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

********************************************************************************
***************************    LAND RENTALS   **********************************

//Get parcel rent data
use "${UGS_W1_raw_data}/2009_AGSEC2B", clear 
ren A2bq2 parcel_id
ren A2bq9 valparcelrentexp //rent paid for PARCELS (not plots) for BOTH cropping seasons (so total rent, inclusive of both seasons, at a parcel level)
tostring Hhid, format(%18.0f) replace
rename Hhid HHID
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_rental.dta", replace

//Calculate rented parcel area (in ha)
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_areas.dta", replace
merge m:1 HHID parcel_id using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_rental.dta", nogen keep (3)
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
*SAW 1.3.23 I will use Josh code as reference (UG w5) that uses NGA wave 3 as reference itself.

//Clean up raw data and generate initial estimates	
use "${UGS_W1_raw_data}/2009_AGSEC4A", clear 
gen season=1
rename A4aq2 A4bq2 
rename A4aq4 A4bq4 
ren A4aq6 A4bq6
append using "${UGS_W1_raw_data}/2009_AGSEC4B"
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
merge m:1 HHID using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_weights.dta", nogen keep(1 3) keepusing(weight)
merge m:1 HHID parcel_id plot_id season using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_areas.dta", nogen keep(1 3) keepusing(field_size)
merge m:1 HHID parcel_id plot_id season using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
drop region ea district county subcounty parish weight rural //regurb not in data 
merge m:1 HHID using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hhids.dta", nogen keep(1 3) //merge in regional data (districts, etc.)
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

merge m:1 HHID using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hhids.dta", nogen keep(1 3) //merge in regional data (districts, etc.) 
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

//Need this for quantities and not sure where it should go.
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
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_input_quantities.dta", replace
restore

append using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_labor.dta"
collapse (sum) val, by (HHID parcel_id plot_id season exp input dm_gender)
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_cost_inputs_long.dta", replace

preserve
collapse (sum) val, by(HHID exp input) //JHG 7_5_22: includes both seasons, is that okay?
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hh_cost_inputs_long.dta", replace
restore

**# Check before collapse what is happening by category....losing something or divi  ding something 
preserve
collapse (sum) val_ = val, by(HHID parcel_id plot_id season exp dm_gender)
reshape wide val_, i(HHID parcel_id plot_id season dm_gender) j(exp) string
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_cost_inputs.dta", replace //This gets used below.
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
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_cost_inputs_wide.dta", replace //Used for monocropped plots, this is important for that section
collapse (sum) val*, by(HHID)

unab vars3 : *_exp_male //just get stubs from one
local stubs3 : subinstr local vars3 "_exp_male" "", all
foreach i in `stubs3' {
	egen `i'_exp_hh = rowtotal(`i'_exp_male `i'_exp_female `i'_exp_mixed)
	egen `i'_imp_hh=rowtotal(`i'_exp_hh `i'_imp_male `i'_imp_female `i'_imp_mixed)
}
**# Bookmark #2
egen val_exp_hh = rowtotal(*_exp_hh)
egen val_imp_hh = rowtotal(*_imp_hh)
drop val_mech_imp* // AR: Don't have machinery input data 
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hh_cost_inputs_verbose.dta", replace 


//Create area planted tempfile for use at the end of the crop expenses section
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_all_plots.dta", replace 
collapse (sum) ha_planted, by(HHID parcel_id plot_id season)
tempfile planted_area
save `planted_area' 

//We can do this (JHG 7_5_22: what is "this"?) more simply by:
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_cost_inputs_long.dta", clear
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
merge m:1 HHID parcel_id plot_id season using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_areas.dta", nogen keep(1 3) keepusing(field_size) //do per-ha expenses at the same time
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
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hh_cost_inputs.dta", replace 

************************************************************************
********************************************************************************
** 								MONOCROPPED PLOTS							  **
********************************************************************************
//Setting things up for AgQuery first
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_all_plots.dta", replace
keep if purestand == 1 //1 = monocropped // Ahana: 6170 obersvations missing
ren crop_code_master cropcode
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_monocrop_plots.dta", replace

use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_all_plots.dta", replace
keep if purestand == 1 //1 = monocropped //File now has 6170 obersvations

merge 1:1 HHID parcel_id plot_id season using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
ren crop_code_master cropcode
ren ha_planted monocrop_ha
ren s_quant_harv_kg kgs_harv_mono // SAW: We use Kilogram harvested using standard units table (across all waves) and price per kg methodology
ren s_value_harvest val_harv_mono // SAW: We use Kilogram harvested using standard units table (across all waves) and price per kg methodology

forvalues k = 1(1)$nb_topcrops  {		
preserve	
local c : word `k' of $topcrop_area
local cn : word `k' of $topcropname_area
local cn_full : word `k' of $topcropname_area_full
keep if cropcode == `c'			
ren monocrop_ha `cn'_monocrop_ha
drop if `cn'_monocrop_ha == 0 		
ren kgs_harv_mono kgs_harv_mono_`cn'
ren val_harv_mono val_harv_mono_`cn'
gen `cn'_monocrop = 1
la var `cn'_monocrop "HH grows `cn_full' on a monocropped plot"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_`cn'_monocrop.dta", replace
	
foreach i in `cn'_monocrop_ha kgs_harv_mono_`cn' val_harv_mono_`cn' { 
gen `i'_male = `i' if dm_gender == 1
gen `i'_female = `i' if dm_gender == 2
gen `i'_mixed = `i' if dm_gender == 3
}
	
la var `cn'_monocrop_ha "Total `cn' monocrop hectares - Household"
la var `cn'_monocrop "Household has at least one `cn' monocrop"
la var kgs_harv_mono_`cn' "Total kilograms of `cn' harvested - Household"
la var val_harv_mono_`cn' "Value of harvested `cn' (UGSH)"
foreach g in male female mixed {		
la var `cn'_monocrop_ha_`g' "Total `cn' monocrop hectares on `g' managed plots - Household"
la var kgs_harv_mono_`cn'_`g' "Total kilograms of `cn' harvested on `g' managed plots - Household"
la var val_harv_mono_`cn'_`g' "Total value of `cn' harvested on `g' managed plots - Household"
}
collapse (sum) *monocrop* kgs_harv* val_harv*, by(HHID /*season*/)
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_`cn'_monocrop_hh_area.dta", replace
restore
}


use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_cost_inputs_long.dta", clear
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
	merge 1:1 HHID parcel_id plot_id season using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_`cn'_monocrop.dta", nogen keep(3)
	collapse (sum) val*, by(HHID)
	foreach i in `input_names' {
		egen val_`i'_`cn'_hh = rowtotal(val_`i'_`cn'_male val_`i'_`cn'_female val_`i'_`cn'_mixed)
	}

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_inputs_`cn'.dta", replace
restore
}
*Notes: Final datasets are sum of all cost at the household level for specific crops.



**# Stopped here for clean committ 

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
use "${UGS_W1_raw_data}/2009_AGSEC6A", clear 
rename A6aq3 livestockid
gen tlu_coefficient = 0.5 if (livestockid == 1 | livestockid == 2 | livestockid == 3 | livestockid == 4 | livestockid == 5 | livestockid == 6 | livestockid == 7 | livestockid == 8) // This includes calves, bulls, oxen, heifer, cows, and horses (exotic/cross and indigenous)
replace tlu_coefficient = 0.3 if A6aq2 == "Mules / Horses" //Includes indigenous donkeys and mules
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep livestockid tlu_coefficient
duplicates drop
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_tlu_livestock.dta", replace

*for small animals
use "${UGS_W1_raw_data}/2009_AGSEC6B", clear 
destring A6bq3, replace
rename A6bq3 livestockid  // id was string converted to numeric
gen tlu_coefficient = 0.1 if (livestockid == 13 | livestockid == 14 | livestockid == 15 | livestockid == 16 | livestockid == 18 | livestockid == 19 | livestockid == 20) // This includes goats and sheeps (indigenous, exotic/cross, male, and female)
replace tlu_coefficient = 0.2 if (livestockid == 21) //This includes pigs (indigenous and exotic/cross)
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep livestockid tlu_coefficient
duplicates drop
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_tlu_small_animals.dta", replace

*For poultry and misc.
use "${UGS_W1_raw_data}/2009_AGSEC6C", clear 
rename A6cq3 livestockid
destring livestockid, replace // id was string converted to numeric 
gen tlu_coefficient = 0.01 if (livestockid == 32 | livestockid == 36 | livestockid == 39 | livestockid == 40 | livestockid == 41 | livestockid == 31 | livestockid == 38 | livestockid == 33| livestockid == 34| livestockid == 35 |livestockid==31 ) // This includes chicken (all kinds), turkey, ducks, geese, and rabbits
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep livestockid tlu_coefficient
duplicates drop
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_tlu_poultry_misc.dta", replace
*NOTES:  SAW: There's an additional categoty of beehives (==28) that we are not currently adding to any tlu_coefficient. Did not find it in another survey.

*Combine 3 TLU .dtas into a single .dta
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_tlu_livestock.dta", clear
append using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_tlu_small_animals.dta"
append using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_tlu_poultry_misc.dta"
*Indigenous/Exotic/Cross not mentioned for sheep/goats and pigs
label def livestockid 1 "Exotic/cross - Calves" 2 "Exotic/cross - Bulls" 3 "Exotic/cross - Oxen" 4 "Exotic/cross - Heifer" 5 "Exotic/cross - Cows" 6 "Indigenous - Calves" 7 "Indigenous - Bulls" 8 "Indigenous - Oxen" 13 "Male Goats" 14 "Female Goats" 15 "Male Sheep" 16 "Exotic/Cross - Female Sheep" 17 "Exotic/Cross - Male Goats" 18 "Female Goats" 19 "Male Goats" 20 "Female Sheep" 21 "Pigs" 31 "Rabbits" 32 "Backyard Chicken" 33 "Parent stock" 34 "Parent Stock" 35 "Layers" 36 "Pullet Chicken" 37 "Growers" 38 "Broilers" 39 "Turkeys" 40 "Ducks" 41 "Geese and other animals"
label val livestockid livestockid //JHG 12_30_21: have to reassign labels to values after append (possibly unnecessary since this is an intermediate step, don't delete code though because it is necessary)
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_tlu_all_animals.dta", replace 
*************************************************************************
**********************    HOUSEHOLD LIVESTOCK OWNERSHIP   ***********************
//Step 2: Generate ownership variables per household

*Combine HHID and livestock data into a single sheet
use "${UGS_W1_raw_data}/2009_AGSEC6A", clear 
append using "${UGS_W1_raw_data}/2009_AGSEC6B" 
append using "${UGS_W1_raw_data}/2009_AGSEC6C"
gen livestockid = A6aq3
destring A6bq3, replace 
destring A6cq3, replace 
replace livestockid=A6bq3 if livestockid==.
replace  livestockid=A6cq3 if livestockid==.
merge m:m livestockid using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_tlu_all_animals.dta", nogen
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

gen num_cattle_now = livestock_number_now if cattle == 1
gen num_cows_now = livestock_number_now if cows == 1
gen num_smallrum_now = livestock_number_now if smallrum == 1
gen num_poultry_now = livestock_number_now if poultry == 1
gen num_chickens_now = livestock_number_now if chickens == 1
gen num_other_now = livestock_number_now if otherlivestock == 1
gen num_tlu_now = livestock_number_now * tlu_coefficient

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

recode num_* (. = 0) //replace all null values for number variables with 0


//Step 4: Aggregate to household level. Clean up and save data
collapse (sum) num*, by (Hhid)
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
tostring Hhid, format(%18.0f) replace
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_TLU_Coefficients.dta", replace


********************************************************************************
**                           LIVESTOCK INCOME       		         		  **
********************************************************************************
*SAW 7.5.22 We will use Nigeria Wave 3 as reference to write this section. This section was previously written in older version of Uganda W3 with different format.

* Load the data
use "${UGS_W1_raw_data}/2009_AGSEC7.dta", clear

* Place livestock costs into categories
generate cost_hired_labor_livestock	= A7q4 	if A7q2 == 1
generate cost_fodder_livestock		= A7q4	if A7q2 == 2
generate cost_vaccines_livestock	= A7q4	if A7q2 == 3
generate cost_other_livestock		= A7q4	if A7q2 == 4
* Water costs are not captured outside of "other"
generate cost_water_livestock		= 0

recode cost_* (.=0)
preserve
	* Species is not captured for livestock costs, and so this disaggregation
	* is impossible. Created for conformity with other waves
	gen cost_lrum = .
	keep Hhid cost_lrum
	label variable cost_lrum "Livestock expenses for large ruminants"
	save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_lrum_expenses.dta", replace
restore

* Collapse Livestock costs to the household level
collapse (sum) cost_*, by(Hhid)

label variable cost_water_livestock			"Cost for water for livestock"
label variable cost_fodder_livestock 		"Cost for fodder for livestock"
label variable cost_vaccines_livestock 		/*
	*/ "Cost for vaccines and veterinary treatment for livestock"
label variable cost_hired_labor_livestock	"Cost for hired labor for livestock"

* Save to disk
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_livestock_expenses.dta", /*
	*/ replace

*****************************    LIVESTOCK PRODUCTS        *******************************
*1. Milk
use "${UGS_W3_raw_data}/AGSEC8B", clear
rename AGroup_ID livestock_code
gen livestock_code2="1. Milk"
keep if livestock_code==101 | livestock_code==105 //Exotic+Indigenous large ruminants. Leaving out small ruminants because small ruminant milk accounts only for 0.04% of total production, and there's no price information
ren a8bq1 animals_milked
ren a8bq2 days_milked
rename a8bq3 liters_perday_peranimal
recode animals_milked days_milked liters_perday_peranimal (.=0)
gen milk_liters_produced = animals_milked*liters_perday_peranimal*days_milked
lab var milk_liters_produced "Liters of milk produced in past 12 months"
rename a8bq7 liters_sold_per_year //ALT: The question asks how many liters did you sell per year but lists units as liters/day. Looking at the data, it's mostly liters/year but there's a tenfold difference between liters/animal in some responses, and estimated prices vary pretty wildly. It seems like the going rate is around 800-1000 USH/L, but some reports of per-day sales are resulting in highly inflated values.

rename a8bq6 liters_per_year_to_dairy // dairy instead of cheese //ALT Q asks for liters/day, but the numbers don't make sense and I think most answers are liters/year
rename a8bq9 earnings_sales //Unsure if this earnings for past 12 months or per day //ALT: It's past twelve months
recode liters_sold_per_year liters_per_year_to_dairy (.=0)
*gen liters_sold_day = (liters_sold_per_year + liters_per_year_to_dairy)/days_milked 
gen price_per_liter = earnings_sales / liters_sold_per_year
gen price_per_unit = price_per_liter  
gen quantity_produced = milk_liters_produced
recode price_per_liter price_per_unit (0=.) 
//gen earnings_milk_year = earnings_per_day_milk*months_milked*30 
*gen earnings_milk_year=price_per_liter*(liters_sold_per_year + liters_per_year_to_dairy) //ALT: Double check and make sure this is actually what we want.
keep HHID livestock_code livestock_code2  milk_liters_produced price_per_liter price_per_unit quantity_produced earnings_sales
lab var price_per_liter "Price of milk per liter sold"
lab var price_per_unit "Price of milk per unit sold"
lab var quantity_produced "Quantity of milk produced"
lab var earnings_sales "Total earnings of sale of milk produced"
tostring HHID, format(%18.0f) replace
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products_milk.dta", replace

*2. Eggs
use "${UGS_W3_raw_data}/AGSEC8C.dta", clear
rename AGroup_ID livestock_code
rename a8cq1 months_produced //how many poultry laid eggs in the last 3 months (different qs. from TNPS)
rename a8cq2 quantity_month //what quantity of eggs were produced in the last 3 months
recode months_produced quantity_month (.=0)
gen quantity_produced = quantity_month*4 //ALT: per the label, this is supposed to be an estimate of eggs produced in the last year. There's not much else we can do besides extrapolate from the last three months.
lab var quantity_produced "Quantity of this product produced in past year"
rename a8cq3 sales_quantity // eggs sold in the last 3 months
rename a8cq5 earnings_sales
recode sales_quantity months_produced quantity_month earnings_sales (.=0)
gen price_per_unit = earnings_sales / sales_quantity
keep HHID livestock_code quantity_produced price_per_unit earnings_sales
// units not included
gen livestock_code2 = "2. Eggs"
tostring HHID, format(%18.0f) replace
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products_other.dta", replace
*SAW: Notes: Why the quantity produce is extrapolated to 1 year while the quantity sales and earning sales are not? For milk the earning sales variable it's at the 1 year unit, should the earning sales unit of timw across products be the same? -If we end up getting a sum of all these categories at the hh level?
*Notes 2: Should we include Livestock production Meat as well? Why not?

*3. Meat // SAW 7.8.22 I;ll add a subsection on meat as well just in case we decide to use it, otherwise exclude it. 
/*
use "${UGS_W3_raw_data}/AGSEC8A.dta", clear
rename AGroup_ID livestock_code
gen livestock_code2 = "3. Meat"
rename a8aq1 number_slaught
rename a8aq2 meat_mean
gen quantity_produced = number_slaught*meat_mean
label var quantity_produced "Total live meat slaughtered (kg) in the past 12 months"
rename a8aq3 sales_quantity
rename a8aq5 earnings_sales
gen price_per_unit = earnings_sales/sales_quantity
keep HHID livestock_code sales_quantity earnings_sales livestock_code2 quantity_produced price_per_unit number_slaught meat_mean
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products_meat.dta", replace
*Notes: Quantity_sales =0 if hh produced but did not sale, . if did not produce=slaughtered anything. Should we change the 0 to . in the first case?
*/
*We append the 3 subsection of livestock earnings
append using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products_milk.dta"
*append using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products_other.dta"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products.dta", replace

use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products.dta", replace
*tostring HHID, format(%18.0f) replace
merge m:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_weights.dta", keep(1 3) nogen
collapse (median) price_per_unit [aw=weight], by (livestock_code2 livestock_code) //Nigeria also uses by quantity_sol_season_unit but UGanda does not have that information, though units should be the same within livestock_code2 (product type). Also, we could include by livestock_code (type of animal)
ren price_per_unit price_unit_median_country
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products_prices_country.dta", replace
*SAW Notes: For some specific type of animal we don't have any information on median price_unit (meat) , I assigned missing median price_unit values based on similar type of animals and product type.

use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products.dta", replace
merge m:1 livestock_code2 livestock_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products_prices_country.dta", nogen keep(1 3) //SAW We have an issue with price units for some types of meat products and specific animal tpye. I assign those price_unit values for the missing based on similar types of animals with information.
keep if quantity_produced!=0
gen value_produced = price_per_unit * quantity_produced 
replace value_produced = price_unit_median_country * quantity_produced if value_produced==.
replace value_produced = value_produced*4 if livestock_code2=="2. Eggs" // SAW Like we said earlier, eggs sales is for the past 3 months we need to extrapolate for the whole year.
lab var price_unit_median_country "Price per liter (milk) or per egg/liter/container honey or palm wine, imputed with local median prices if household did not sell"
gen value_milk_produced = price_per_unit * quantity_produced if livestock_code2=="1. Milk"
replace value_milk_produced = quantity_produced * price_unit_median_country if livestock_code2=="1. Milk" & value_milk_produced==.
gen value_eggs_produced = price_per_unit * quantity_produced if livestock_code2=="2. Eggs"
replace value_eggs_produced = quantity_produced * price_unit_median_country if livestock_code2=="2. Eggs" & value_eggs_produced==.

*Share of total production sold
gen sales_livestock_products = earnings_sales	
/*Agquery 12.01*/
//No way to limit this to just cows and chickens b/c the actual livestock code is missing.
gen sales_milk = earnings_sales if livestock_code2=="1. Milk"
gen sales_eggs = earnings_sales if livestock_code2=="2. Eggs"
*gen sales_meat = earnings_sales if livestock_code2=="3. Meat"
collapse (sum) value_milk_produced value_eggs_produced /*value_meat_produced*/ sales_livestock_products /*agquery*/ sales_milk sales_eggs /*sales_meat*/, by (HHID)
*Share of production sold
*First, constructing total value
egen value_livestock_products = rowtotal(value_milk_produced value_eggs_produced /*value_meat_produced*/)
*Now, the share
gen share_livestock_prod_sold = sales_livestock_products/value_livestock_products
replace share_livestock_prod_sold = 1 if share_livestock_prod_sold>1 & share_livestock_prod_sold!=.
lab var share_livestock_prod_sold "Percent of production of livestock products that is sold" 
/*AgQuery 12.01*/
gen prop_dairy_sold = sales_milk / value_milk_produced // There;s some issues with some values>1 - the milk dataset does not make a lot of sense.
gen prop_eggs_sold = sales_eggs / value_eggs_produced
*gen prop_meat_sold = sales_meat / value_meat_produced
**
lab var value_milk_produced "Value of milk produced"
lab var value_eggs_produced "Value of eggs produced"
*lab var value_meat_produced "Value of meat produced"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products.dta", replace

******************











/* Old Code
*Price per kg 
gen price_kg = value_sold/kgs_sold
lab var price_kg "price per kg sold" 
recode price_kg (0=.) 
tostring HHID, format(%18.0f) replace
merge m:1 HHID using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hhids.dta" //Getting an error thay HHID is double in master but string in data. How to fix this? ALT 10.25.19 - converted HHID to string 
drop if _merge==2 
drop _merge 

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_sales.dta", replace
//ATL 12.2.19 : Looks like this section works, but sometimes crops that are not harvested are sold 

*Imute crop prices from sales 
//median price at the ea level 
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_sales.dta", clear 
gen observation = 1 
bys region district county subcounty parish ea crop_code: egen obs_ea = count (observation) 
collapse (median) price_kg [aw=weight], by (region district county subcounty parish ea crop_code obs_ea) 
rename price_kg price_kg_median_ea 
lab var price_kg_median_ea "Median price per kg for this crop in the enumeration area" 
lab var obs_ea "Number of sales observations for this crop in the enumeration area" 
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_ea.dta" , replace 

//median price at the parish level 
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_sales.dta" , clear 
gen observation = 1 
bys region district county subcounty parish crop_code: egen obs_parish = count(observation)
collapse (median) price_kg [aw=weight], by (region district county subcounty parish crop_code obs_parish) 
rename price_kg price_kg_median_parish 
lab var price_kg_median_parish "Median price per kg for this crop in the parish" 
lab var obs_parish "Number of sales observations for this crop in the parish" 
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_parish.dta", replace 

//median price at the subcounty level 
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_sales.dta", clear 
gen observation = 1 
bys region district county subcounty crop_code: egen obs_sub = count(observation) 
collapse (median) price_kg [aw=weight], by (region district county subcounty crop_code obs_sub) 
rename price_kg price_kg_median_sub 
lab var  price_kg_median_sub "Median price per kg for this crop in the subcounty" 
lab var obs_sub "Number of sales observations for this crop in the subcounty" 
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_subcounty.dta", replace 

//median price at the county level 
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_sales.dta", clear
gen observation = 1 
bys region district county subcounty crop_code: egen obs_sub = count(observation)
collapse (median) price_kg [aw=weight], by (region district county subcounty crop_code obs_sub) 
rename price_kg price_kg_median_sub 
lab var price_kg_median_sub "Median price per kg for this crop in the subcounty" 
lab var obs_sub "Number of sales observations for this crop in the subcounty" 
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_subcounty.dta", replace 

//median price at the district level 
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_sales.dta", clear 
gen observation = 1 
bys region district crop_code: egen obs_district = count(observation) 
collapse (median) price_kg [aw=weight], by (region district crop_code obs_district) 
rename price_kg price_kg_median_district 
lab var price_kg_median_district "Median price per kg for this crop in the district" 
lab var obs_district "Number of sales observations for this crop in the district" 
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_district.dta", replace 

//median price at the region level 
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_sales.dta", clear 
gen observation = 1 
bys region crop_code: egen obs_region = count(observation) 
collapse (median) price_kg [aw=weight], by (region crop_code obs_region) 
rename price_kg price_kg_median_region 
lab var price_kg_median_region "Median price per kg for this crop in the region" 
lab var obs_region "Number of sales observations for this crop in the region" 
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices-region.dta", replace 

//median price at the country level 
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_sales.dta", clear  
gen obeservation = 1 
bys crop_code: egen obs_country = count(obeservation)
collapse (median) price_kg [aw=weight], by (crop_code obs_country) 
rename price_kg price_kg_median_country
lab var price_kg_median_country "Median price per kg for this crop in the country" 
lab var obs_country "Number of sales observations for this crop in the country" 
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_country.dta", replace 

*Pull prices into harvest estimates 
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_sales.dta", clear 
merge m:1 region district county subcounty parish ea crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_ea.dta", nogen 
merge m:1 region district county subcounty parish crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_parish.dta", nogen 
merge m:1 region district county subcounty crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_subcounty.dta", nogen 
merge m:1 region district county crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_county.dta", nogen 
merge m:1 region district crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_district.dta", nogen 
merge m:1 region crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_region.dta", nogen 
merge m:1 crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_country.dta", nogen 

gen price_kg_hh= price_kg 

//Impute prices based on local median values 
replace price_kg =price_kg_median_ea if price_kg==. & obs_ea >= 10 & crop_code!=890 
replace price_kg =price_kg_median_parish if price_kg==. & obs_paris >= 10 & crop_code!=890 
replace price_kg =price_kg_median_county if price_kg==. & obs_county >= 10 & crop_code!=890
replace price_kg =price_kg_median_district if price_kg==. & obs_district >= 10 & crop_code!=890 
replace price_kg =price_kg_median_region if price_kg==. & obs_region >=10 & crop_code!=890 
replace price_kg =price_kg_median_country if price_kg==. & obs_country >=10 & crop_code!=890 
lab var price_kg "price per kgm with missing values imputed using local median values" 

//computing value harvest as price_kg * kg_harvest as done in Ethiopia baseline 
gen value_harvest_imputed = kgs_harvest * price_kg_hh if price_kg_hh!=. //This instrument doesnt ask about value harvest, just value sold. 
replace value_harvest_imputed = kgs_harvest * price_kg if value_harvest_imputed==. 
replace value_harvest_imputed = 0 if value_harvest_imputed==. 
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_values_tempfile.dta", replace 

preserve 
recode value_harvest_imputed value_sold kgs_harvest qty_sold (.=0) 
collapse (sum) value_harvest_imputed value_sold kgs_harvest qty_sold, by(HHID crop_code)
ren value_harvest_imputed value_crop_production 
lab var value_crop_production "Gross value of crop production" 
rename value_sold value_crop_sales 
lab var value_crop_sales "Values of crops sold so far" 
lab var kgs_harvest "Kgs harvested of this crop" 
ren qty_sold kgs_sold 
lab var kgs_sold "Kgs sold of this crop" 
tostring HHID, format(%18.0f) replace 
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_values_production.dat", replace 
restore 

*The file above will be used is the estimation intermediate variables: gross value of crop production, Totals value of crop sold, total quantity harvested 
collapse (sum) value_harvest_imputed value_sold, by (HHID) 
replace value_harvest_imputed = value_sold if value_sold>value_harvest_imputed & value_sold!=. & value_harvest_imputed!=. //changes made 
rename value_harvest_imputed value_crop_production 
lab var value_crop_production "Gross value of crop porduction for this household"
*This is estimated usinf household reposnses for values of crop production sold. This is used to calculate a price per kg and the multiplied by the kgs harvested. 
* prices are imputed using local median values when there are no sales. 
rename value_sold value_crop_sales 
lab var value_crop_sales "Value of crops sold so far" 
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production 
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold" 
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hh_crop_production.dta", replace 

*Plot value of crop produciton 
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_values_tempfile.dta", clear 
collapse (sum) value_harvest_imputed, by (HHID parcel_id plot_id) 
rename value_harvest_imputed plot_value_harvest 
lab var plot_value_harvest "Value of crop harvest on this plot" 
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_cropvalue.dta" , replace 

*crop values for inputs in agricultural product processing (self-employment) 
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_sales.dta" , clear 
merge m:1 region district county subcounty parish ea crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_ea.dta", nogen 
merge m:1 region district county subcounty parish crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_parish.dta", nogen 
merge m:1 region district county subcounty crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_subcounty.dta", nogen 
merge m:1 region district county crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_county.dta", nogen 
merge m:1 region district crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_district.dta", nogen 
merge m:1 region crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_region.dta", nogen
merge m:1 crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_country.dta", nogen 
replace price_kg = price_kg_median_ea if price_kg==. & obs_ea >= 10 & crop_code!=890 //Don't impute prices for "other" crops 
replace price_kg = price_kg_median_parish if price_kg==. & obs_parish >=10 & crop_code!=890 
replace price_kg = price_kg_median_sub if price_kg==. & obs_sub >= 10 & crop_code!=890 
replace price_kg = price_kg_median_county if price_kg==. & obs_county >=10 & crop_code!=890 
replace price_kg = price_kg_median_district if price_kg==. & obs_district >=10 & crop_code!=890 
replace price_kg = price_kg_median_region if price_kg==. & obs_region >=10 & crop_code!=890 
replace price_kg = price_kg_median_country if price_kg==. & obs_country >=10 & crop_code!=890 
lab var price_kg "Price per kg, with missing values imputed using local median values" 
gen value_harvest_imputed = kgs_harvest * price_kg if price_kg!=. //This instrument doesnt ask about value harvest, just value sold. 
replace value_harvest_imputed = kgs_harvest * price_kg if value_harvest_imputed==. 
replace value_harvest_imputed = 0 if value_harvest_imputed==. 
*keep HHID crop_code price_kg 
*duplicates drop 
recode price_kg (.=0)
collapse (mean) price_kg, by (HHID crop_code) 
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hh_crop_prices.dta", replace 

*crops lost post-harvest // construct this as value crop production * percent lost similar to Ethiopia waves 
use "${UGS_W1_raw_data}//2009_AGSEC5A", clear 
append using "${UGS_W1_raw_data}/2009_AGSEC5B" 
ren A5aq1 parcel_id 
ren A5aq3 plot_id 
rename A5aq5 crop_code 
rename Hhid HHID
drop if plot_id == . // observations droppes 
rename A5aq16 percent_lost 
replace percent_lost = A5bq16 if percent_lost==. & A5bq16!=. 

*collapse (sum) percent_lost, by (HHID crop_code) // EFW 6.5.19 fixing a mistake from my coe 
replace percent_lost = 100 if percent_lost > 100 & percent_lost!=.  // changes made 
merge m:1 HHID crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hh_crop_values_production.dta" 
drop if _merge==2 //0 dropped 

gen value_lost = value_crop_production * (percent_lost/100) 
recode value_lost (.=0) 
collapse (sum) value_lost, by (HHID) 
rename value_lost crop_value_lost 
lab var crop_value_lost "Value of crop production that had been lost by the time of survey: 
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_losses.dta", replace 
/*
/*

********************************************************************************
*Crop Unit Conversion Factors* 
********************************************************************************
 *create conversion factors for harvest 
 use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_value.dta" , replace 
 clonevar quantity_harv=A5aq6a
 replace quantity_harv=A5aq6b if quantity==. 
 *rename a5aq6a quantity 
clonevar condition_harv=A5aq6b 
replace condition_harv=A5aq6b if condition==. 
*renmae a5aq6b condition 
clonevar conv_fact_harv_raw=A5aq6d 
replace conv_fact_harv_raw=A5bq6d if condition==. 
*renmane a5aq6d cinv_fact_raw  
recode crop_code (741 742 744 = 740) // same for bananas (740) 
label define cropID 740 "Bananas" , modify //need to add new codes to the value label, cropID 
label values crop_code cropID //appply crop labels to crop_code_master 
collapse (median) conv_fact_harv_raw, by (crop_code condition_harv unit_code)
rename conv_fact_harv_raw conv_fact_median 
lab var conv_fact_median "Median value of supplied conversioin factor by crop type, condition, and unit code"
drop if conv_fact_med == .| crop_code==. | condition ==. 
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_conv_fact_harv.dta" , replace 
 
 *create conversion factors for sold crops (this is exactly the same with different variable names for use with merges later)
 use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_w1_crop_value.dta" , replace 
 clonevar quantity_harv=A5aq6a 
 replace quantity_harv=A5bq6a if quantity==. 
 *rename a5aq6a quantity 
 clonevar condition_harv=A5aq6b 
 replace condition_harv=A5bq6b if condition_harv==. 
 *rename a5aq6b condition 
 clonevar conv_fact_harv_raw=A5aq6d
 replace conv_fact_harv_raw=A5bq6d 
replace conv_fact_harv_raw=A5bq6d if conv_fact_harv_raw==. 
*rename a5aq6d conv_fact_raw 
recode crop_code (741 742 744 = 740) // which is being reduced from different types to just coffee. same for bananas (740) and pease (220) 
label define cropId 740 "Bananas" , modify //need to add new codes to the value label, cropID 
label values crop_code cropID //apply crop labels to crop_code_master 
collapse (median) conv_fact_harv_raw, by (crop_code condition_harv unit_code) 
rename conv_fact_harv_raw conv_fact_sold_median
lab var conv_fact_sold_median"Median value of suplied conversion factor by crop type, condition, and unit code" 
drop if conv_fact_sold_median ==. | crop_code ==. | condition_harv ==.
rename unit_code sold_unit_code // done to make a megre later easier, at this point it just represents an abstract unit code 
*rename condition_harv conditioin// agaian, done to make a merge a lot easier
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_conv_fact_sold.dta" , replace 

*SAW: NOTES: Should we create the Price Unit by converting the Sold quantities to kg units using the median conversion factor sold instead of the Given values for each observation (which we know have variation across same unit of analysis (crop type and unit code sold))


********************************************************************************
*Plot Variables* 
********************************************************************************
*SW 28.06.22 
*SAW: Onlys focus on the following Variables that we can construct with 4A and 4B only that we are looking for: Date planted, permanent crops,  intercropped/monocropped, purestand, just focus on those. 
 *Clean Up file and combine both seasons 
 use "${UGS_W1_raw_data}/2009_AGSEC4A" , clear 
 gen season=1 
 append using "${UGS_W1_raw_data}/2009_AGSEC4B"
 replace season=2 if season==. 
 *rename HHID hhid 
 rename A4aq4 plotID 
 replace plotID=A4bq4 if plotID==. 
 rename plotID plot_id 
 rename A4aq2 parcelID 
 replace parcelID=A4bq2 if parcelID==.
 rename A4aq6 cropID
 rename cropID crop_code_plant //crop codes for what was planted 
 drop if crop_code_plant==.
 rename parcelID parcel_id
 clonevar crop_code_master = crop_code_plant //we want to keep the crop IDs intact while reducing the number of categories in the master version 
 recode crop_code_master (741 742 744 = 740) // 740 is bananas, which is being reduced from different types to just bananas. same for peas (220). 
 label define L_CROP_LIST 740 "Bananas" , modify //need to add new codes to the value label, cropID
 label values crop_code_master L_CROP_LIST //apply crop labels to crop_code_master
 rename Hhid HHID
 tostring HHID, format(%18.0f) replace 

*Merge area variables (now calculated in plot areas section earlier) 
merge m:1 HHID parcel_id plot_id season using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_areas.dta" 

/*AA: Can't create time variables, not collected in this section (month planted, harvested, and length of time grown)
gen month_planted = Crop_Planted_Month 
replace month_planted = Crop_Planted_Month2 if season==2
replace month_planted=. if month_planted==99 //no changes
lab var month_planted "Month of planting relative to December year_planted (both cropping seasons)" // we have 
gen year_planted = 2010 if Crop_Planted_Year==1 | (Crop_Planted_Year2==1 & season==2)
replace year_planted= 2011 if Crop_Planted_Year==2 | (Crop_Planted_Year2==2 & season==2)
 tostring HHID, format(%18.0f) replace
*rename crop_code_plant crop_code
*/
*creating time varibales (month planted, harvested, and length of time grown) 
*not possible with wave 1 and 2, they do not account for month 

merge m:m HHID parcel_id plot_id /*crop_code*/ season using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_value.dta" , nogen keep (1 3) 
rename crop_code crop_code_harvest 
drop if crop_code_harvest ==. 

/*gen month_harvest = a5aq6e 
replace month_harvest = a5bq6e if season==2 
lab var month_harvest "Month of planting relative to 2009 ANd 2010

not possible with survey provided
deviates a lot from Uganda Wave 3, onward, since all the surveys in Wave 1 lack the month harvested, unable to to create variables such as months_grown, month_harvest, month_planted, etc. 
*/

//gen edate_harvest=mdy
*AA: no planting dates
gen perm_tree = 1 if inlist(crop_code_master, 460, 630, 700, 710, 720, 740, 750, 760, 770, 780, 810, 820, 830, 870) //dodo, cassava, oranges, pawpaw, pineapple, bananas, mango, jackfruit, avocado, passion fruit, coffee, cocoa, tea, and vanilla, in that order SAW everythins works except for 740 banana that is still 741 742 and 744
replace perm_tree = 0 if perm_tree == .
lab var perm_tree "1 = Tree or permanent crop"

*generate crops_plot varibale for number of crops per plot. This is used to fix issues with intercroping and relay cropping being reported innacurately for our puropse

	preserve 
		gen obs2=1 
		replace obs = 0 if inrange(A5aq17,1,4) |inrange(A5bq17,1,5) //obs= 0 if crop was lost for some reason like theft, flooding, pests, etc. AA 5. 17. 23 Should it be 1-5 not 1-4? 
		collapse (sum) crops_plot = obs2, by (HHID parcel_id plot_id season)
		tempfile ncrops 
		save `ncrops'
	restore 
	merge m:1 HHID parcel_id plot_id season using `ncrops', nogen 
	*drop if hh_agric == . 
	gen contradict_mono = 1 if A4aq9 == 100 | A4bq9 == 1 & crops_plot >1 // (13,412 mising values generated) 
	gen contradict_inter = 1 if crops_plot == 1 
	replace contradict_inter = . if A4aq9 == 100 | A4aq8 ==1 | A4bq9 == 100 | A4bq8 ==1 // (768 real chnages made, 768 to missing) 
	
*Generate varibales around lost and replanted crops 
	gen lost_crop=inrange(A5aq17, 1,5) | inrange(A5bq17, 1, 5) // SAW I think it should be intage(var, 1, 5) whynot include "other" 
	bys HHID parcel_id plot_id season : egen max_lost = max(lost_crop) // more observations for max_lost than lost_crop due to parcels where inercroppping occured because one of the crops grown simultaneously on the same plot was lost 
	/* gen month_lost = month_planted if lost_crop==1 
	gen month_kept = month_planted of lost_crop==0 
	bys hhid plot_id : egen max_month_lost = max(month_lost) 
	bys hhid plot_id : egen min_month_kept = min(month_kept)
	 gen replanted = (max_lost==1 & crops_plot>0 & min_month_kept>max_month_lost)* / //Have to figure out interplanted. // JHG 1_7_22 ; should I keep this code that's been edited out from Nigeria code? */
	 gen replanted = (max_lost == 1 & crops_plot > 0) 
	 drop if replanted == 1 & lost_crop == 1 //crop expeses should count toward the crop that was kept, propbably. 293 observations delected; keeping and assuming yeild is 0 
	 
	 *generating monocroped plot varibales (part 1) 
	 bys HHID parcel_id plot_id season: egen crops_avg = mean(crop_code_master) // chehcks for different versions of the same crop in the same plot and season 
	 gen purestand = 1 if crops_plot == 1 //this includes repplanted crops 
	 bys HHID parcel_id plot_id season : egen permax = max(perm_tree) 
	
	/* AA : the following code does not fit into Wave 1, since the harvest dates/ months cannot be determined,   most of the orignial/reference code was removed
	
crop_planted_Month Crop_Planted_Year Crop_Planted_Month2 Crop_Planted_Year2 : gen plant_date_unique = _n
	*replace plant_date_unique = . if a4aq9_1 == 99 | a4bq9_1 == 99 //JHG  1_12_22: added this code to remove permanent crops with unknown planting dates, so they are omitted from this analysis */
	
	bys HHID parcel_id plot_id season : gen plant_date_unique = _n
	*replace plant_date_unique == . if a4aq9_1 == 99 | a4bq9_1 == 99 // AA: what does this do> this would never be coded as a 99 so I dont really understanf - currently 1, 2 or . 
	*JHG  1_12_22: added this code to remove permanent crops with unknown planting dates, so they are omitted from this analysis SAW No Unknow planting dates
	bys HHID parcel_id plot_id season  : gen harv_date_unique = _n // AA: harvest was all in the same year (2009)
	bys HHID parcel_id plot_id season : egen plant_dates = max(plant_date_unique)
	bys HHID parcel_id plot_id season : egen harv_dates = max(harv_date_unique)
	replace purestand = 0 if (crops_plot > 1 & (harv_dates > 1)) | (crops_plot > 1 & permax == 1) //Multiple crops planted or harvested in the same month are not relayed; may omit some crops that were purestands that preceded or followed a mixed crops 
	
*generating mixed stand plot varibales (part 2) 
	gen mixed = (A4aq7 ==2 | A4bq7 ==2)
	bys HHID parcel_id plot_id season : egen mixed_max = max(mixed)
	
	/* replace purestand = 1 if crops_plot > 1 & plant_dates == 1 & permax == 0 & mixed_max  == 0 
	// JHG 1_14_22 : 8  replacements, all of which report missing crop_code vlaues. Should all missing crop_code values be dropped> If so, this should be done at an early stage.
	// I dropped the values after the latest merge above, and there were zero replacements for this line of code. 
	no relay cropping? */
	*gen relay = 1 if crops_plot > 1 & plant_dates == 1 & harv_dates == 1 & permax == 0 & mixed_max == 0* 
	replace purestand = 1 if crop_code_plant == crops_avg // multiple types of the smae crop do not count as intercropping 
	replace purestand = 0 if purestand == . // assumes null vaalues are just 0 SAW should we assume null values are intercropped? or maybe information?? 
	lab var purestand "1 = monocropped, 0 = intercropped or relay cropped"
	drop crops_plot crops_avg harv_dates harv_date_unique permax 
	
	/* JHG 1_14_22: Can't do this section because no ha_harvest infromation. 1,598 plts have ha_planted >> field_size 
	Okay, now we should be able to rlatively accurately rescale plots. 
	//Let's first consider that planting might  be misreported but harvest is accurate
	replace ha_planted = ha_harvest if ha_planted > field_size & ha_harvest < ha_planted & ha_harvest!=. //x# of chnages */
	
	gen percent_field= ha_planted/field_size 
*generating total percent of purestand and monocropped on a field 
	bys HHID parcel_id plot_id season : egen total_percent = total(percent_field)
	
	*Dealing with crops which have monocropping larger than plot size or monocropping that fills plot size and still has intercropping to add 
	replace percent_field = percent_field/total_percent if total_percent > 1 & purestand == 0
	replace percent_field = 1 if percent_field > 1 & purestand == 1 
	// 2,134 real changes made 
	replace ha_planted = percent_field*field_size 
	**replace ha_harvest = ha_planted if ha_harvest > ha_planted // no ha_harvest variable in survey 
	
	*renaming variables for merge to work // JHG 1/20/2022: section is unecessary if we can't get conversion factors to work  
	ren A5aq6a quantity_harvested
	replace quantity_harvested = A5bq6a if quantity_harvested == . 
	ren crop_code_harvest crop_code 
	recode crop_code (741 742 744 = 740)(221 222 223 224 = 220) // which is being reduced from different types to just code. same for bananas (740) and peas (220) 
	label define cropID 740 "Bananas" 220 "Peas" , modify //need to add new codes to the value label, cropID 
	label values crop_code cropID 
	rename A5aq6b condition_harv 
	replace condition_harv	= A5bq6b if condition_harv == . 
	
* 	rename a5aq6c condition // SAW Question a5aq7b and a5bq7b are missing! Which is condition of sold crops - Assumption: We will use same as condition_harvested
	*replace condition = a5bq6c if condition == .
	//JHG 1/20/2022: can't do any conversion without conversion factors, there are currently no good substitutes for what they provide and that is very inconsistent within units (different conversion factors for same unit and crop). To get around this, we decided to use median values by crop, condition, and unit given what the survey provides.
	
	*merging in conversion factors and generating value fo harvest variables 
	merge m:1 crop_code condition_harv sold_unit_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_conv_fact_sold.dta", keep (1 3) gen(cfs_merge) //
	merge m:1 crop_code condition_harv using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_conv_fact_sold.dta",keep (1 3) gen(cfh_merge)
	gen quant_sold_kg = sold_qty * conv_fact_sold_median if cfs_merge == 3 
	gen quant_harv_kg = quantity_harvested * conv_fact_sold_median // not all harvested is sold,  in fact , most is not, 
* AA : ask peter !!!!! 13,163 missing variables formed in each equation, seems fairly large amount to have unmatched 
	gen total_sold_value = price_unit * sold_qty 
	gen value_harvest = price_unit * quantity_harvested 
	rename price_unit val_unit 
	gen val_kg = total_sold_value/quant_sold_kg if cfs_merge == 3
	
	
//AA: must renamne Hhid to HHID in order to merge HHID's and not mess up the previou code, from here on out all hhid variables should be coded in all caps to make merges easier 

	
	*generating plot weights, then generating value of both permantely saved and temporarily stored for later use 
	merge m:1 HHID using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hhids.dta", nogen keepusing (weight) keep(1 3) // 13,163 matched (the code matches!)
	gen plotweight = ha_planted * weight // 280 missing values generated
	gen obs3 = quantity_harvested > 0 & quantity_harvested !=. 
	foreach i in region district county subcounty parish ea HHID { // JGH JHG 1_28_22: county_code and parish_code are not currently labeled, just numerical
preserve
bys crop_code `i' : egen obs_`i'_kg = sum(obs3)
	collapse (median) val_kg_`i' = val_kg  [aw = plotweight], by (`i' crop_code obs_`i'_kg)
	tempfile val_kg_`i'_median
	save `val_kg_`i'_median'
restore	

}

preserve 
collapse (median) val_kg_country = val_kg (sum) obs_country_kg = obs3 [aw = plotweight], by (crop_code)
tempfile val_kg_country_median 
save `val_kg_country_median'
restore 

 

foreach i in region district county subcounty parish ea HHID { //something in here breaks when looking for unit_code
preserve
	bys `i' crop_code sold_unit_code : egen obs_`i'_unit = sum(obs3)
	collapse (median) val_unit_`i' = val_unit [aw = plotweight], by (`i' sold_unit_code crop_code obs_`i'_unit)
	rename sold_unit_code unit_code //done for the merge a few lines below
	tempfile val_unit_`i'_median
	save `val_unit_`i'_median'
restore 
	merge m:1 `i' unit_code crop_code using `price_unit_`i'_median', nogen keep(1 3)
	merge m:1 `i' unit_code crop_code using `val_unit_`i'_median', nogen keep(1 3)
	merge m:1 `i'  crop_code using `val_kg_`i'_median', nogen keep(1 3)
} 

preserve 
collapse (median) val_unit_country = val_unit (sum) obs_country_unit = obs [aw = plotweight], by (crop_code unit_code)
save "${UGS_W1_created_data/Uganda_NPS_LSMS_ISA_W1_crop_prices_median_country.dta}", replace // This used for self-employment income 
restore 

merge m:1 unit_code crop_code using `price_unit_country_median', nogen keep(1 3) 
//merge m:1 unit_code crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_median_country.dta", nogen keep(1 3) 
merge m:1 crop_code using `val_kg_country_median', nogen keep(1 3) 


*Generate a definitive list of value variables 

foreach i in region district county subcounty parish ea {
	replace val_unit = price_unit_`i' if obs_`i'_price > 9
	replace val_kg = val_kg_`i' if obs_`i'_kg  > 9 //JHG 1_28_22: why 9?
}
	gen val_missing = val_unit == .
	replace val_unit = price_unit_HHID if price_unit_HHID != .

foreach i in region district county subcounty parish ea { //JHG 1_28_22: is this filling in empty variables with other geographic levels?
	replace val_unit = val_unit_`i' if obs_`i'_unit > 9 & val_missing == 1
}
	replace val_unit = val_unit_HHID if val_unit_HHID != . & val_missing == 1 //household variables are last resort if the above loops didn't fill in the values
	replace val_kg = val_kg_HHID if val_kg_HHID != . //Preferring household values where available.
	
//All that for these two lines that generate actual harvest values : 
	replace value_harvest = val_unit* quantity_harvested if value_harvest == . 
	replace value_harvest = val_kg* quant_harv_kg if value_harvest == .

	//removed country, revist later// 
	
//XX real changes total. But note we can also subsitute local values for households with weird prices, which might work better then winsorizing. 
	//replacing conversioins for unkown units 
	replace val_unit = value_harvest / quantity_harvested if val_unit == . 
preserve 
	ren unit_code unit 
	collapse (mean) val_unit, by (HHID crop_code unit) 
	ren val_unit hh_price_mean 
	lab var hh_price_mean "average price reported for this crop-unit in the household"
	save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_for_wages.dta", replace 
	restore 
	
*SAW 03.23.23

/* //AA 03.23.23 : CSIRO Data Request 
preserve 
merge m:1 ea using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_ea_coorde.dta", nogen keep(1 3)
ren region adm1 
ren district adm2 
ren county adm3 
ren ea adm4 
*ren hhid hhID 
*ren plot_id plotID 
ren crop_code_plant crop// The original, unmodified crop code 
*ren area_est plot_area_reported //farmer estimated plot area - may need to be created 
ren feild_size plot_area_measured 
*replace plot_area_meaured = . if gps_meas==0 
ren percent_field crop_area_share 
gen planting_month = month(plant_date) 
gen planting_year = year(plant_date) 
gen harvest_month_begin = month(harv_date) 
gen harvest_month_end = month(harv_end)
gen harvest_year_begin = year(harv_date) 
gen harvest_year_end = year(harv_date) 
keep adm* HHID parcel_id plot_id crop /*plot_area_reported*/ plot_area_measured crop_area_share 
planting_month planting_year harvest_month_begin harvest_month_end harvest_year_beging 
harvest_year_end / *gps_meas* / purestand 
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_all_plots_dates.dta", replace 
restore 
*/

*AgQuery+
	collapse (sum) quant_harv_kg value_harvest ha_planted percent_field, by(region district county subcounty parish ea HHID parcel_id plot_id season crop_code_master purestand field_size /*month_planted month_harvest*/)
	bys HHID parcel_id plot_id season : egen percent_area = sum(percent_field) 
	bys HHID parcel_id plot_id season : gen percent_inputs = percent_field / percent_area 
	drop percent_area //assumes that inputs are +/- distributed by the area planted. Probably not true fof mixed tree/field crops, but reasonable for plotd that are all fiels crops 
	//labor should be weighted by growing season length, though. 
	merge m:1 HHID season parcel_id using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender) 
	gen ha_harvested = ha_planted
	save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_all_plots.dta", replace 
	
*Notes: AA removed months-harvested and plant_date from W3 template 

// merge not working, problem with plot decsions makers, does not contain plot_id OR season variable, problem with seasons generation, must ask peter/sebastian/andrew how to fix plot decisions and complete merge to finish plot variables section 

* merge resolved! (thanks andrew) 

********************************************************************************
** 								ALL PLOTS END								  **
********************************************************************************
/*TESTING planted crops and generate mean area planted, yield by area planted, mean value harvested by area planted by household and compare to w3.
use "${UGA_W2_created_data}/Uganda_NPS_W2_all_plots.dta", clear

*mean area planted
gen maize_planted = ha_planted if crop_code_master == 130
collapse (sum) maize_planted, by (HHID)
* maize planted mean = .31
gen cassava_planted = ha_planted if crop_code_master == 630
collapse (sum) cassava_planted, by (HHID)
* cassava planted mean = .27

*yield by area (kg_harvest / ha_planted)
gen maize_yield = quant_harv_kg / ha_planted if crop_code_master == 130
collapse (sum) maize_yield, by (HHID)
* maize yield mean = 5226.9
gen cassava_yield = quant_harv_kg / ha_planted if crop_code_master == 630
collapse (sum) cassava_yield, by (HHID)
* maize yield mean = 6078

*mean value harvested by area planted
gen maize_value_harv = value_harvest / ha_planted if crop_code_master == 130
collapse (sum) maize_value_harv, by (HHID)
*mean value harvested by area planted = 2.24e+07 
gen cassava_value_harv = value_harvest / ha_planted if crop_code_master == 630
collapse (sum) cassava_value_harv, by (HHID)
*mean value harvested by area planted =  1.51e+07*/ */

********************************************************************************
** 								ALL PLOTS 2.0 Version						  **
********************************************************************************
*SAW new additions, AA 06/24/2023
/*

/*Purpose:
Crop values section is about finding out the value of sold crops. It saves the results in temporary storage that is deleted once the code stops running, so the entire section must be ran at once (conversion factors require output from Crop Values section).

Plot variables section is about pretty much everything else you see below in all_plots.dta. It spends a lot of time creating proper variables around intercropped, monocropped, and relay cropped plots, as the actual data collected by the survey seems inconsistent here.

Many intermediate spreadsheets are generated in the process of creating the final .dta

Sebastian Idea of All Plots:
Using : 5A and 5B Quantification of production 
**Section 1: Crop Value **
1. We calculate the Price Unit variable (Average sold value per kg of harvest sold) ($Sold value/Crop sold converted to kgs = sold_value/(sold_qty*conv_factor_sold)) by using the Sold conversion factor (Raw variable not the calculated median), sold quantity, and value of crop sold.
1.1 [/Uganda_NPS_LSMS_ISA_W3_crop_value.dta] Variables created: A) Crop Harvest: Condition crop harvested, unit code of crop harvested, conversion factor of crop harvested.
B) Crop Sold: Unit code of crop sold, conversion factor crop sold (No information on condition crop sold)
C) Price unit ($Sold value/Crop sold converted to kgs = sold_value/(sold_qty*conv_factor_sold)).
D) Median Price Unit: For each crop for each geographic location: region, district, county, subcounty, parish, ea, and HHID, and national level (Not including the Unit code of crop sold given that crops are already comparable using the raw sold conversion factor (not the median sold conversion factor))

**Section 2: Plot Variables **
Using : 4A and 4B Quantification of production 
1. Plot Variables:[This old section is very messy, need to work on it] 

2. Variables created: Time of crop planting (year and month), permanent crop, purestand, monocrop/intercrop indicator, 
** AA, W1 not applicable beacause there are no time of cropping/ yearly measurements in W1 or W2 Uganda 



C) Unit of analysis: crop value dataset is at the plot crop type, condition and unit type season level.
2. We calculate the median Price Unit for each crop for each geographic location: region, district, county, subcounty, parish, ea, and HHID, and national level
3. We calculate the median crop conversion factor for by crop, condition of crop harvested, and unit code of crop harvested. 
4. We calculate the median value of supplied conversion factor by crop type sold, and unit code of crop sold (condition of crop sold not available). The missing condition of crop sold might explain the differences in conversion factors for same crop type and sold unit code. Then, why would we calculate the median after using the sold conversion factors to calculate the price unit? 
Using : 4A and 4B Quantification of production 
5. Plot Variables:[This old section is very messy, need to work on it] Time of crop planting (year and month), permanent crop, purestand, monocrop/intercrop indicator, 
6. Estimating Area planted at the plot level (only available at the parcel level) by using 

*Meeting with Peter: We need to use the actual conversion factor sold and conversion factor harvest variables instead of the MEDIAN conversion factors (both sold and harvested)

Final goal is all_plots.dta. This file has regional, hhid, plotid, crop code, fieldsize, monocrop dummy variable, relay cropping variable, quantity of harvest, value of harvest, hectares planted and harvested, number of trees planted, plot manager gender, percent inputs(?), percent field (?), and months grown variables.
 
**********************************
** Crop Values **
**********************************
use "${UGS_W1_raw_data}/2009_AGSEC5A.dta", clear 
gen season=1 
append using "${UGS_W1_raw_data}/2009_AGSEC5B.dta"
replace season=2 if season==.
*SAW Update 5/19/23 Unit of Crop Harvested 
clonevar condition_harv = A5aq6a 
replace condition_harv = A5bq6a if season==2 
clonevar unit_code_harv = A5aq6b
replace unit_code_harv = A5bq6b if unit_code==. 
clonevar conv_factor_harv = A5aq6c 
replace conv_factor_harv = A5bq6c if season==2 
replace conv_factor_harv = 1 if unit_code_harv==1 

**check in w/ Andrew/Peter/Sebastian to try and re-write this section to include the fourth A5aq6d variable 

*Unit of Crop Sold
clonevar sold_unit_code =A5aq7a
replace sold_unit_code =A5bq7a if sold_unit_code==. 
clonevar sold_value = A5aq8 
replace sold_value= A5aq8 if sold_value==. // SAW 05.05.23 It seems like the var a5aq8 "what was the value?" refers to the total value of the crop sold in contrast to UG w5 that shows price unit. 

*doublecheck w/ Andrew/Peter that using A5aq6d and A5bq6d will work as anaccurate conversion factor measurement (afformentioned fourth variable)
clonevar conv_factor_sold = A5aq6d
replace conv_factor_sold = A5bq6d if season==2 
replace conv_factor_sold = 1 if sold_unit_code==1 
gen sold_qty=A5aq7a 
replace sold_qty=A5bq7a if sold_qty==. 
gen quant_sold_kg = sold_qty*conv_factor_sold

*Notes: We do have condition/state and unit code of crop harvest, but we only have Unit of crop sold (no condition_sold) and kg conversion factor for sold quantities. 
*Notes: Checking for consistency of conversion factors for crop harvested: (There are some differences per same crop condition_harv, and unit_code_harv)
*Notes: Checking for consistency of conversion factors for crop sold: (There are some differences per same crop type, and unit_code_harv) same if we include condition_harvested. This variation might be explained by the missingi information on condition crop sold.

*SAW 5.23.2023 From Conversion Factor Section to calculate medians 
clonevar quantity_harv=A5aq6a
replace quantity_harv=A5bq6a if quantity_harv==.
gen quant_harv_kg = quantity_harv*conv_factor_harv

rename Hhid HHID

tostring HHID, format(%18.0f) replace 
merge m:1 HHID using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hhids.dta", nogen keepusing(region district county subcounty parish ea weight)

rename A5aq1 parcel_id 
rename A5aq3 plot_id 
rename A5aq4 crop_name 
rename A5aq5 crop_code  

recode crop_code (741 742 744= 740) //Same for bananas (740) 
label define cropID 740 "Bananas", modify //need to add new codes to the value label, cropID 
label values crop_code cropID //apply crop labels to crop_code_master 

*AA 30.06.2023 We do not have information about the year/month/date harvested in Uganda w1, so the following code is commented out, yet preserved to demonstrate the use of year of harvest for other waves which include timelines of harvest in the questionaire 

/*gen month_harv_date = a5aq6e
replace month_harv_date = a5bq6e if season==2
gen harv_date = ym(2011,month_harv_date)
format harv_date %tm
label var harv_date "Harvest start date"

gen month_harv_end = a5aq6f
replace month_harv_end = a5bq6f
gen harv_end = ym(2011,month_harv_end) if month_harv_end>month_harv_date
replace harv_end = ym(2012,month_harv_end) if month_harv_end<month_harv_date
format harv_end %tm
label var harv_end "Harvest end date"*/

*SAW 5.19.2023 Create Price unit for converted sold quantity (kgs) 
gen price_unit=sold_value/(quant_sold_kg)
label var price_unit "Average sold value per kg of harvest sold"
gen obs = price_unit!=. 
*Checking price_unit mean and sd for each type of crop _. bys cropd_code: sum price_unit 

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_value.dta", replace 
*We collapse to get to a unit of analysis at the HHID, parcel, plot, season level instead of... plot, season, condition and unit of crop harvested*/

*keep HHID parcel_id plot_id crop_code season condition_harv unit_code_harv conv_factor_harv quant_harv_kg sold_unit_code sold_qty quant_sold_kg sold_value conv_factor_sold region district county subcounty parish ea weight obs price_unit

** harv_date harv_end  month_harv_date month_harv_end not included in Uganda w1, but should be included, starting w/ uganda w3

//This loop below creates a value for the price of each crop at the given regional levels seen in the first line. It stores this in temporary storage to allow for cleaner, simpler code, but could be stored permanently if you want.

foreach i in region district county subcounty parish ea HHID {
		preserve
		bys `i' crop_code /*sold_unit_code*/ : egen obs_`i'_price = sum(obs)
		collapse (median) price_unit_`i' = price_unit [aw=weight], by (`i' /*sold_unit_code*/ crop_code obs_`i'_price)
		*rename sold_unit_code unit_code //needs to be done for a merge near the end of the all_plots indicator
		tempfile price_unit_`i'_median
		save `price_unit_`i'_median'
		restore
	}
	preserve
	collapse (median) price_unit_country = price_unit (sum) obs_country_price = obs [aw=weight], by(crop_code /*sold_unit_code*/)
	*rename sold_unit_code unit_code //needs to be done for a merge near the end of the all_plots indicator
	tempfile price_unit_country_median
	save `price_unit_country_median'
	restore
/*
 *We collapse to get to a unit of analysis at the HHID, parcel, plot, season level instead of ... plot, season, condition and unit of crop harvested
collapse (sum) quantity_harv_kg sold_value quantity_sold_kg obs (mean) price_unit (min), by(HHID parcel_id plot_id crop_code season region ea district county subcounty parish weight)
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_value_croplevel.dta", replace 
*/
 
**********************************
** [Harvest and Sold] Crop Unit Conversion Factors  **
**********************************
*Notes: This section was used to calculate the median crop unit conversion factors for harvest and sold variables. Now, we will use the raw variable from the World bank.
*SAW:  Methodological decisions NOTES: Should we create the Price Unit - and the median price units by location - by converting the Sold quantities to kg units using the median conversion factor sold instead of the Given values for each observation (which we know have variation across same unit of analysis (crop type and unit code sold))

**********************************
** Plot Variables **
**********************************
*SW 06.24.2023  
*SAW: Only focus on the following Variables that we can constructs with 4A and 4B only that we are looking for: Date planted, permanent crops, intercroppped/monocropped, purestand, just focus on those. 
*Clean up file and combine both seasons

//ask about matching the variables and the issues with stringing/destringing the varibales, how to save infromation, etc. 07.17.2023

/*
preserve
 use "${UGS_W1_raw_data}/2009_AGSEC4A" , clear 
 gen season=1 
 append using "${UGS_W1_raw_data}/2009_AGSEC4B"
 replace season=2 if season==. 
 *rename HHID hhid 
 rename A4aq4 plotID 
 replace plotID=A4bq4 if plotID==. 
 rename plotID plot_id 
 rename A4aq2 parcelID 
 replace parcelID=A4bq2 if parcelID==.
 rename A4aq6 cropID
 rename A4aq5 crop_code
 rename cropID crop_code_plant //crop codes for what was planted 
 drop if crop_code_plant==.
 rename parcelID parcel_id
 clonevar crop_code_master = crop_code_plant //we want to keep the crop IDs intact while reducing the number of categories in the master version 
 recode crop_code_master (741 742 744 = 740) // 740 is bananas, which is being reduced from different types to just bananas. same for peas (220). 
 rename Hhid HHID
 label define L_CROP_LIST 740 "Bananas" , modify //need to add new codes to the value label, cropID
 label values crop_code_master L_CROP_LIST //apply crop labels to crop_code_master
 tostring HHID, format(%18.0f) replace 

*Merge area variables (now calculated in plot areas section earlier)

merge m:1 HHID parcel_id plot_id season using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_areas.dta" , nogen keep (1 3) 

*No need to create time variables (month planted, harvsted, and length of time grown) since these variables are not included in Uganda Wave 1, the section commented out below is from Uganda w3 

/*gen month_planted = Crop_Planted_Month 
gen year_planted = 2010 if Crop_Planted_Year==1 | (Crop_Planted_Year2==1 & season==2)
replace year_planted= 2011 if Crop_Planted_Year==2 | (Crop_Planted_Year2==2 & season==2)

/* OLD
gen month_planted = Crop_Planted_Month+(year_planted-2009)*12
replace month_planted = Crop_Planted_Month2+(year_planted-2009)*12 if season==2
lab var month_planted "Month of planting relative to January 2009 (both cropping seasons)" // we have a variable with the year as well which is different than w5 actually w5 also has the year variable might want to check with Josh
*/
*SAW 4/24/23 SAW Update based on Andrew's request
gen month_planted = Crop_Planted_Month
replace month_planted = Crop_Planted_Month2 if season==2
gen plant_date = ym(year_planted,month_planted)
format plant_date %tm
label var plant_date "Plantation start date"
clonevar crop_code =  crop_code_plant*/

gen perm_tree = 1 if inlist(crop_code_master, 460, 630, 700, 710, 720, 740, 750, 760, 770, 780, 810, 820, 830, 870) //dodo, casava, oranges, bananas, pawpaw, pineapple, mango, jackfruit, avacado, passion fruit, coffee, coacoa, tea, and vanilla, in that order SAW everything works except for 740 banana that is still 741 742 and 744 
replace perm_tree = 0 if perm_tree == . 
lab var perm_tree "1 = Tree or permanent crop" // JHG 1_14_22: What about perennial, non-tree crops like cocoyam (which I think is also called taro?) 
duplicates drop HHID parcel_id plot_id crop_code season, force 
tempfile plotplanted 
save `plotplanted'

merge m:1 HHID parcel_id plot_id crop_code season using `plotplanted', nogen keep(1 3) 




//ask peter about where to have the restore function, why the code is referncing q5 past the merge, and if the 2.0 version doesnt run becuase of the original all plots and plot varibales section! 




restore
**********************************
** Plot Variables After Merge **
**********************************
*SAW 4/24/23 Update 

* Following section commented out because it UG w1 does not include timelines/ months grown 
 
/*gen months_grown1 = harv_date - plant_date if perm_tree==0
replace harv_date = ym(2012,month_harv_date) if months_grown1<=0
gen months_grown = harv_date - plant_date if perm_tree==0*/


*Generate crops_plot variable for number of crops per plot. This is used to fix issues around intercropping and relay cropping being reported inaccurately for our purposes.
preserve
		gen obs2 = 1
		replace obs2 = 0 if inrange(A5aq17,1,4) | inrange(A5bq17,1,5) //obs = 0 if crop was lost for some reason like theft, flooding, pests, etc. SAW 6.29.22 Should it be 1-5 not 1-4?
		collapse (sum) crops_plot = obs2, by(HHID parcel_id plot_id season)
		tempfile ncrops 
		save `ncrops'
	restore 
	merge m:1 HHID parcel_id plot_id season using `ncrops', nogen
	*drop if hh_agric == .

	gen contradict_mono = 1 if A4aq9 == 100 | A4bq9 == 100 & crops_plot > 1 //6 plots have >1 crop but list monocropping
	gen contradict_inter = 1 if crops_plot == 1
	replace contradict_inter = . if A4aq9 == 100 | A4aq8 == 1 | A4bq9 == 100 | A4bq8 == 1 //meanwhile 145 list intercropping or mixed cropping but only report one crop

	
*Generate variables around lost and replanted crops
	gen lost_crop = inrange(A5aq17, 1,5) | inrange(A5bq17,1,5) // SAW I think it should be intange(var,1,5) why not include "other"
	bys HHID parcel_id plot_id season : egen max_lost = max(lost_crop) //more observations for max_lost than lost_crop due to parcels where intercropping occurred because one of the crops grown simultaneously on the same plot was lost
	/*gen month_lost = month_planted if lost_crop==1 
	gen month_kept = month_planted if lost_crop==0
	bys hhid plot_id : egen max_month_lost = max(month_lost)
	bys hhid plot_id : egen min_month_kept = min(month_kept)
	gen replanted = (max_lost==1 & crops_plot>0 & min_month_kept>max_month_lost)*/ //Gotta filter out interplanted. //JHG 1_7_22: should I keep this code that's been edited out from Nigeria code?
	gen replanted = (max_lost == 1 & crops_plot > 0)
	drop if replanted == 1 & lost_crop == 1 //Crop expenses should count toward the crop that was kept, probably. 89 plots did not replant; keeping and assuming yield is 0.

	*Generating monocropped plot variables (Part 1)
	bys HHID parcel_id plot_id season: egen crops_avg = mean(crop_code_master) //Checks for different versions of the same crop in the same plot and season
	gen purestand = 1 if crops_plot == 1 //This includes replanted crops
	bys HHID parcel_id plot_id season : egen permax = max(perm_tree)
	
/*
bys HHID parcel_id plot_id season Crop_Planted_Month Crop_Planted_Year Crop_Planted_Month2 Crop_Planted_Year2 : gen plant_date_unique = _n
	*replace plant_date_unique = . if a4aq9_1 == 99 | a4bq9_1 == 99 //JHG  1_12_22: added this code to remove permanent crops with unknown planting dates, so they are omitted from this analysis SAW No Unknow planting dates
	bys HHID parcel_id plot_id season a5aq6e a5bq6e : gen harv_date_unique = _n // SAW harvest was all in the same year (2011)
	bys HHID parcel_id plot_id season : egen plant_dates = max(plant_date_unique)
	bys HHID parcel_id plot_id season : egen harv_dates = max(harv_date_unique)
	replace purestand = 0 if (crops_plot > 1 & (plant_dates > 1 | harv_dates > 1)) | (crops_plot > 1 & permax == 1) //Multiple crops planted or harvested in the same month are not relayed; may omit some crops that were purestands that preceded or followed a mixed crop */
	
	
	*Generating mixed stand plot variables (Part 2)
	gen mixed = (A4aq8 == 2 | A4bq8 == 2)
	bys HHID parcel_id plot_id season : egen mixed_max = max(mixed)
	/*replace purestand = 1 if crops_plot > 1 & plant_dates == 1 & harv_dates == 1 & permax == 0 & mixed_max == 0 //JHG 1_14_22: 8 replacements, all of which report missing crop_code values. Should all missing crop_code values be dropped? If so, this should be done at an early stage.
	//I dropped the values after the latest merge above, and there were zero replacements for this line of code. No relay cropping?
	gen relay = 1 if crops_plot > 1 & plant_dates == 1 & harv_dates == 1 & permax == 0 & mixed_max == 0 */
	replace purestand = 1 if crop_code_plant == crops_avg //multiple types of the same crop do not count as intercropping
	replace purestand = 0 if purestand == . //assumes null values are just 0 SAW Should we assume null values are intercropped?  or maybe missing information??
	lab var purestand "1 = monocropped, 0 = intercropped or relay cropped"
	drop crops_plot crops_avg plant_dates harv_dates plant_date_unique harv_date_unique permax
	
		/*JHG 1_14_22: Can't do this section because no ha_harvest information. 1,598 plots have ha_planted > field_size
	Okay, now we should be able to relatively accurately rescale plots.
	replace ha_planted = ha_harvest if ha_planted == . //X # of changes
	//Let's first consider that planting might be misreported but harvest is accurate
	replace ha_planted = ha_harvest if ha_planted > field_size & ha_harvest < ha_planted & ha_harvest!=. //X# of changes */
	
	gen percent_field = ha_planted/field_size
*Generating total percent of purestand and monocropped on a field
	bys HHID parcel_id plot_id season: egen total_percent = total(percent_field)
//about 25% of plots have a total intercropped sum greater than 1
//about 265 of plots have a total monocropped sum greater than 1

	*Dealing with crops which have monocropping larger than plot size or monocropping that fills plot size and still has intercropping to add
	replace percent_field = percent_field/total_percent if total_percent > 1 & purestand == 0
	replace percent_field = 1 if percent_field > 1 & purestand == 1
	//8568 changes made
	replace ha_planted = percent_field*field_size
	***replace ha_harvest = ha_planted if ha_harvest > ha_planted //no ha_harvest variable in survey

**********************************
** Crop Harvest Value **
**********************************
*SAW 6/27/23 Update 
foreach i in  region district county subcounty parish ea HHID {	
	merge m:1 `i' /*unit_cd*/ crop_code using `price_unit_`i'_median', nogen keep(1 3)
	merge m:1 /*unit_cd*/ crop_code using `price_unit_country_median', nogen keep(1 3)
}

rename price_unit val_unit
*Generate a definitive list of value variables
//JHG 1_28_22: We're going to prefer observed prices first, starting at the highest level (country) and moving to the lowest level (ea, I think - need definitive ranking of these geographies)
recode obs_* (.=0) //ALT 
foreach i in country region district county subcounty parish ea {
	replace val_unit = price_unit_`i' if obs_`i'_price > 9
	*replace val_kg = val_kg_`i' if obs_`i'_kg  > 9 //JHG 1_28_22: why 9?
}
	gen val_missing = val_unit == .
	replace val_unit = price_unit_HHID if price_unit_HHID != .
/*
foreach i in country region district county subcounty parish ea { //JHG 1_28_22: is this filling in empty variables with other geographic levels?
	replace val_unit = val_unit_`i' if obs_`i'_unit > 9 & val_missing == 1
}
	replace val_unit = val_unit_HHID if val_unit_HHID != . & val_missing == 1 //household variables are last resort if the above loops didn't fill in the values
	replace val_kg = val_kg_HHID if val_kg_HHID != . //Preferring household values where available.
*/
gen value_harvest = val_unit*quant_harv_kg 

preserve
	ren unit_code_harv unit
	collapse (mean) val_unit, by (HHID crop_code unit)
	ren val_unit hh_price_mean
	lab var hh_price_mean "Average price reported for this crop-unit in the household"
	save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_prices_for_wages.dta", replace
	restore
	
*SAW 4/24/23 Update

/*	//ALT 03.23.23: CSIRO Data Request
preserve
merge m:1 ea using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_ea_coords.dta", nogen keep(1 3)
ren region adm1
ren district adm2
ren county adm3
ren ea adm4
*ren hhid hhID
*ren plot_id plotID
ren crop_code_plant crop //The original, unmodified crop code 
*ren area_est plot_area_reported   //farmer estimated plot area - may need to be created
ren field_size plot_area_measured 
*replace plot_area_measured = . if gps_meas==0
ren percent_field crop_area_share
gen planting_month = month(plant_date)
gen planting_year = year(plant_date)
gen harvest_month_begin = month(harv_date)
gen harvest_month_end = month(harv_end)
gen harvest_year_begin = year(harv_date)
gen harvest_year_end = year(harv_date)
keep adm* HHID parcel_id plot_id crop /*plot_area_reported*/ plot_area_measured crop_area_share planting_month planting_year harvest_month_begin harvest_month_end harvest_year_begin harvest_year_end /*gps_meas*/ purestand
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_all_plots_date.dta", replace
restore
	*/

*AgQuery+
	collapse (sum) quant_harv_kg value_harvest ha_planted percent_field (max) months_grown plant_date harv_date harv_end, by(region district county subcounty parish ea HHID parcel_id plot_id season crop_code_master purestand field_size /*month_planted month_harvest*/)
	bys HHID parcel_id plot_id season : egen percent_area = sum(percent_field)
	bys HHID parcel_id plot_id season : gen percent_inputs = percent_field / percent_area
	drop percent_area //Assumes that inputs are +/- distributed by the area planted. Probably not true for mixed tree/field crops, but reasonable for plots that are all field crops
	//Labor should be weighted by growing season length, though. 
	merge m:1 HHID parcel_id plot_id season using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
	save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_all_plots.dta", replace

*SAW 5/19/23 Which relevant information are we trying to merge here? Here the unit of analysis is at the PLot crop season level, while the crop value dataset is at the plot crop type, condition and unit season level ? Should we collapse the crop_value dataset first? */

*/

********************************************************************************
** 								ALL PLOTS END								  **
********************************************************************************



********************************************************************************
** 								CROP EXPENSES								  **
******************************************************************************** 
*SAW 30.6.22 The old version of Uganda W3 does not seem to have anything similar to what Crop Expenses section should look like. We will use Josh coding as reference - that uses Nieria Wave 3 as reference itself. 

*JHG 5_3_22: I am going to copy in chunks of Nigeria W3 code at a time and work on them. It is waaaaaay longer than the code that was originally here, so I'm not sure all of it will be relevant. We'll see. Anyways, this is the beginning of the Nigeria W3 code.

//ALT 05.05.21: New labor module. The old one was unwieldy and I'm pretty sure values were still getting dropped. This is better. And I need it for agquery.
//New file structure (transformed into whatever we need for the rest of the code to run using reshape wide) | hhid | plotid | dm_gender | season | labor type | worker gender | days worked | price of labor | value of labor |
//This cuts down 400+ lines into ~100 lines and saves repetition of labor variables elsewhere.
//ALT 05.07.21: Now new module for all crop expenses.

/* Explanation of changes
This section has been formatted significantly differently from previous waves and the Tanzania template file (see also NGA W3 and TZA W3-5).
Previously, inconsistent nomenclature forced the complete enumeration of variables at each step, which led to accidental omissions messing with prices.
This section is designed to reduce the amount of code needed to compute expenses and ensure everything gets included. I accomplish this by 
taking advantage of Stata's "reshape" command to take a wide-formatted file and convert it to long (see help(reshape) for more info). The resulting file has 
additional columns for expense type ("input") and whether the expense should be categorized as implicit or explicit ("exp"). This allows simple file manipulation using
collapse rather than rowtotal and can easily be converted back into our standard "wide" format using reshape. 

*/
	*********************************
	* 			LABOR				*
	*********************************
	//Purpose: This section will develop indicators around inputs related to crops, such as labor (hired and family), pesticides/herbicides, animal power (not measured for Uganda), machinery/tools, fertilizer, land rent, and seeds. //JHG 5_3_22: edit this description later
/*
*SAW 1/3/23 I will do Hired Labor again given that wagehired gives the total wages payed for the total number of days worked hired and not wages per day for each men, women, or children. Notes: 1. I created a variable of total persondays hired by adding dayshiredmale, dayshiredfemale and dayshiredchild. 2. I created a variable of wages per person per day by dividing the wageshired variable -which represent the total amount of hired labored payed for all person-days irrespective of the gender - by totaldayshired. 3. I assigned the new wages per person-day to each gender that worked in that particular household, so if both women and men work in that particular hh, parcel, plot they will be assigned the same wage, since we cannot differentiate between the wages payed for each particular gender. 
*NOTE: OLD VERSION OF HIRED LABOR CAN BE FOUND IN OLDER DO-FILES. */

*Hired Labor 
//Note: no information on the number of people, only person-days hired and total value (cash and in-kind) of daily wages

use "${UGS_W1_raw_data}/2009_AGSEC3A", clear 
gen season = 1 
append using "${UGS_W1_raw_data}/2009_AGSEC3B" 
replace season =2 if season ==. 


*Seb Consulting support $5 dollars  STAR
replace HHID = Hhid if HHID==""
rename A3aq1 parcel_id 
replace parcel_id = a3bq1 if parcel_id==.
rename  A3aq3 plot_id 
replace plot_id = a3bq3 if plot_id==.
*Seb Consulting END


ren A3aq42a dayshiredmale 
replace dayshiredmale =a3bq42a if dayshiredmale == . 
replace dayshiredmale = . if dayshiredmale == 0 
 
ren A3aq42b dayshiredfemale
replace dayshiredfemale = a3bq42b if dayshiredfemale == . 
replace dayshiredfemale = . if dayshiredfemale == 0 
ren A3aq42c dayshiredchild 
replace dayshiredchild = a3bq42c if dayshiredchild == . 
replace dayshiredchild = . if dayshiredchild == 0 

ren A3aq43 wagehired 
replace wagehired = a3bq43 if wagehired == . 
gen wagehiredmale = wagehired if dayshiredmale !=. 
gen wagehiredfemale = wagehired if dayshiredfemale !=. 
gen wagehiredchild = wagehired if dayshiredchild !=. 
// 
recode dayshired* (.=0) 
gen dayshiredtotal = dayshiredmale + dayshiredfemale + dayshiredchild // 6.30.22 SAW "How much did you pay including the value of in-kind payments for these days of labor?" Not 100% sure this is the same as what is mentioned above. Maybe the variable wagehored is for the total? Might want to check Uganda wages to see if it's payment per day per person or for the total number of days... 
replace wagehiredmale = wagehiredmale/dayshiredtotal
replace wagehiredfemale = wagehiredfemale/dayshiredtotal 
replace wagehiredchild = wagehiredchild/dayshiredtotal
// 
keep HHID parcel_id plot_id season *hired* 
drop wagehired dayshiredtotal 

*6.39.22 SAW We need to drop duplicates in order to conduct the following code reshape 6 observations droped 
duplicates drop HHID parcel_id plot_id season, force 
reshape long dayshired wagehired, i(HHID parcel_id plot_id season) j(gender) string 
reshape long days wage, i(HHID parcel_id plot_id season gender) j(labor_type) string 
recode wage day (. =0) 
drop if wage == 0 & days == 0 
/*REPLACE WAGE = WAGE/NUMBER //alt 08.16.21 : The question is "How much did you pay in total per day to the hired <laborers>. "For getting median wages for implicit values, we need the wage/person/day*/ 
* 6.30.22 SAW "How much did you pay including the value of the in-kind payments for these days of labor?" Not 100% sure this is the same as what is mentitioned above. Maybe the varibale wagehired is for total? Might want to check Uganda wages to to see if it's payment per person or for the total number of days... 
gen val =  wage*days 
tostring HHID, format (%18.0f) replace 
merge m:1 HHID parcel_id plot_id season using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_areas.dta", nogen keep(1 3) keepusing(field_size) 
merge m:1 HHID using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_weights", nogen keep(1 3) keepusing(weight) 
merge m:1 HHID using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hhids.dta", nogen keep(1 3) 
gen plotweight = weight * field_size //hh crossesctional weight multiplied by the plot area 
recode wage (0 =.)
gen obs = wage !=. 

*Median wages 
foreach i in region district county subcounty parish ea HHID {
	di "`i'"
	preserve 
	bys `i' season gender : egen obs_`i' = sum(obs) 
	collapse (median) wage_`i' = wage [aw = plotweight], by (`i' season gender obs_`i')
	tempfile wage_`i'_median 
	save `wage_`i'_median'
restore
}
preserve

collapse (median) wage_country = wage (sum) obs_country = obs [aw = plotweight], by (season gender) 
tempfile wage_country_median 
save `wage_country_median'
restore 

drop obs plotweight wage rural 
tempfile all_hired 
save `all_hired'
*SAW: I need to make whether we want to include children labor in our calculations.... (ehtical reasons?) What is the stnadard? (Include/not include) 

******************************  FAMILY LABOR   *********************************
*SAW 1/3/23  I will do Family Labor based on the updates on Hired labor. 
*This section combines both seasons and renames variables to be more useful
use "${UGS_W1_raw_data}/2009_AGSEC3A", clear
gen season = 1
append using "${UGS_W1_raw_data}/2009_AGSEC3B" 
replace season = 2 if season == .

//complete append for parcel and plot id after season 2 
replace HHID = Hhid if HHID==""
rename A3aq1 parcel_id 
replace parcel_id = a3bq1 if parcel_id==.
rename  A3aq3 plot_id 
replace plot_id = a3bq3 if plot_id==.
ren A3aq39 days //a3aq39 "For this plot how many days did they work?", a3aq38 "How many household members worked on this plot during the first season of 2010?" . Not sure if a3aq39 is total days or days total days per person (a3aq38)? 1/3/23 QUestionare says its person days.. will use that. 
rename A3aq38 fam_worker_count // number of hh members who worked on the plot 
ren A3aq40* PID_* //The  number of total family members working on plot (farm_worker_count) can be higher than the pid_* vars since a max of 3 hh members are counted. 
keep HHID parcel_id plot_id season PID_* days fam_worker_count 

preserve 
use "${UGS_W1_raw_data}/2009_GSEC2", clear 
gen male = h2q3 == 1 
gen age = h2q8 
drop PID 
ren h2q1 PID
keep HHID PID age male 
isid HHID PID 
tempfile members 
save `members', replace 
restore 

duplicates drop HHID parcel_id plot_id season, force // 0 observations dropped 
reshape long PID, i(HHID parcel_id plot_id season) j(colid) string 
drop if days == . 
tostring HHID, format(%18.0f) replace 
*tostring PID, format(%18.0f) replace 
merge m:1 HHID PID using `members', nogen keep (1 3) 


gen gender = "child" if age < 16 
replace gender = "male" if gender=="" & male == 1 
replace gender = "female" if gender=="" & male == 0 
replace gender = "unknown" if gender=="" & male == . 
gen labor_type = "family"
drop if gender == "unknown"
merge m:1 HHID using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hhids.dta", nogen keep(1 3) //merge in regional data (districts, etc.) 
keep region district county subcounty parish ea HHID parcel_id plot_id season gender days labor_type fam_worker_count 

foreach i in region district county subcounty parish ea HHID {
	merge m:1 `i' gender season using `wage_`i'_median', nogen keep(1 3) 
}
	merge m:1 gender season using `wage_country_median', nogen keep(1 3) //JHG 5_12_22: 1,692 with missing vals b/c they don't have matches on pid, see code above

foreach i in region district county subcounty parish ea HHID { 
	merge m:1 `i' gender season using `wage_`i'_median', nogen keep(1 3) 
}
	merge m:1 gender season using `wage_country_median', nogen keep(1 3) ///JHG 5_12_22: 1,692 with missing vals b/c they don't have matches on pid, see code above
	
	gen wage = wage_HHID 
	*recode wage (.=0)
foreach i in country region district county subcounty parish ea {
	replace wage = wage_`i' if obs_`i' >9 
} // Goal of this loop is to get median wages to infer value of family labor as an implicit expense. Uses continually more specific values by geography to fill in the gaps of implicit labor value 

egen wage_sd = sd(wage_HHID), by(gender season) 
egen mean_wage = mean(wage_HHID), by(gender season) 
/* The below code assumes that wages are normally distributed and values below the 0.15th percentile and above the 99.85th percentile are outliers, keeping the median values for the area in those instances.
In reality, what we see is that it trims a significant amount of right skew - the max value is 7.5 stdevs above the mean while the min is only 0.58 below. 
JHG 5_18_22: double-check with Andrew about percentiles in above text
*/
replace wage = wage_HHID if wage_HHID != . & abs(wage_HHID - mean_wage) / wage_sd < 3 //Using household wage when avilable, but commiting impausibly high or low values. Changed about 6,7000 hh obs, max goes from 500,000 -> 500,000 mean 45,000 -> 41,000 : min 10,00 -> 2,000 
//JHG 5_18_22: dpuble-check with Andrew about the code above because the max did not chnage. Also I ran the Nigeria code and this text (the version there) didn't match what happened for wage or wage_hhid 
* SAW Because he got total days of work for family labor but not for each individual on the hhid we need to divide total days by number of subgroups of gender that were included as workers in the garm within each household. OR we could assign median wages irrespective of gender (we would need to calculate that in family hired by geographic levels of granularity irrespective of gender)
by HHID parcel_id plot_id season, sort :egen numworkers = count(_n) 
replace days = days/numworker // IF we divided by famworkers we would not ne capturing the total amount of days worked 
gen val = wage * days 
append using `all_hired'
keep region district county subcounty parish ea HHID parcel_id plot_id season days val labor_type gender 
drop if val == . & days == . 
merge m:1 HHID parcel_id plot_id season using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_decision_makers.dta" , nogen keep(1 3) keepusing(dm_gender) 
collapse (sum) val days, by (HHID parcel_id plot_id season labor_type gender dm_gender) //JHG 5_18_22 : Number of workers is not measured by this survey, may affect agwage section 
	la var gender "Gender of worker"
	la var dm_gender "Plot manager gender"
	la var labor_type "Hired, exchnage, of family labor"
	la var days "Number of person-days per plot"
	la var val "Total value of hired labor (Naria)"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_labor_long.dta" , replace 

preserve 
collapse (sum) labor_ = days, by (HHID parcel_id plot_id labor_type) 
reshape wide labor_, i(HHID parcel_id plot_id) j(labor_type) string 
	la var labor_family "Number of family person-days spent on plot, all seasons"
	la var labor_hired "Number of hired labor person-days spent on plot, all seasons"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_labor_days.dta", replace 
restore
//At this point  all code below is legacy; we could cut it with some changes to how the summary stats get processed. 
preserve 
	gen exp = "exp" if strmatch(labor_type, "hired")
	replace exp = "imp" if  strmatch(exp, "")
	collapse (sum) val, by (HHID parcel_id plot_id exp dm_gender) //JHG 5_18_22: no season? 
	gen input = "labor" 
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_labor.dta", replace 
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
drop if dm_gender2 == "" //JHG 5_18_22: 169 observations lost, due to missing values in both plot decision makers and gender of head of hh. Looked into it but couldn't find a way to fill these gaps, although I did minimize them.
reshape wide val*, i(HHID parcel_id plot_id) j(dm_gender2) string 
collapse (sum) val*, by(HHID) 
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hh_cost_labor.dta", replace 



















































































