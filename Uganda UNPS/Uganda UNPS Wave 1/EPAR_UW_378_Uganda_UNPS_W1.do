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
global root_folder "//netid.washington.edu/wfs/EvansEPAR/Project/EPAR/Working Files/378 - LSMS Burkina Faso, Malawi, Uganda/uganda-wave1-2009-10"
global root_folder "/Volumes/wfs/Project/EPAR/Working Files/378 - LSMS Burkina Faso, Malawi, Uganda/uganda-wave1-2009-10" // AM 09.09.21
global root_folder "R:\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\uganda-wave1-2009-10" //AA this global works when in the office

global UGS_W1_raw_data 	"${root_folder}/raw_data"
global UGS_W1_created_data "${root_folder}/temp"
global UGS_W1_final_data  "${root_folder}/outputs"



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
*was not in original draft do-file - is this needed? CJS 2.4.2020

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
global topcropname_area "maize rice wheat sorgum fmillt grdnt beans yam swtptt cassav banana cotton sunflr coffee irptt" //JHG: added coffee (Robusta/Arabica), finger millet, and irish potatoes as they are all in the top 10 for Uganda (and pearl millet is not grown there)
*global topcropname_area "maize rice wheat sorgum fmillt cowpea grdnt beans yam swtptt cassav banana cotton sunflr pigpea coffee irptt" // SAW Original code - we take cowpea and pigpea out to run code
global topcrop_area "130 120 111 150 141 310 210 640 620 630 740 520 330 810 610"
global comma_topcrop_area "130, 120, 111, 150, 141, 310, 210, 640, 620, 630, 740, 520, 330, 810, 610"
global topcropname_area_full "maize rice wheat sorghum fingermillet groundnut beans yam sweetpotato cassava banana cotton sunflower coffee irishpotato"
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
*SAW 6.15.22 All cropID match with UG w5 except for banana whichhas 3 different typesof crops banana food 741 banana beer 742 banana 744. Need to compile all 3 into one category.

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

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_weight.dta" , replace

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
*SAW 2.18.22 I might need to recode this section to create field_size variable required to code All Plot section. We need field size at the plot level, currently only at parcel level. By using area planted size as a % of total area planted size per parcel we might be able to proxy field size at the plot level. Reference code Uganda W5
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

*simialr to rainy and dry season, create a singular column for plotID 
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
tempfile sea1 sea2 sea3 
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
generate parcel_acre = parcelID // JHG 10_27_2021: replaced missing GPS estimation here to get parcel size in acres if we have it, but many parcels do not have gps estimation
replace parcel_acre = A2bq4 if parcel_acre == . 
replace parcel_acre = A2aq5 if parcel_acre == . // JHG 10_27_2021 replaced misiing GPS values with farmer estimation, which is less accurate but has full coverage (and is also in acres) 
replace parcel_acre = A2bq5 if parcel_acre == . // see above 
gen field_size = plot_area_pct*parcel_acre // using calculated percentages of plots (out of total plots per parcel) to estimate plot size using more accurate parcel measurements 
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
gen head= h2q4==1 if h2q4!=. // Q. should I keep realhead or hh_head? I have one underlying variabe 5/8/19 
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

//EWF 4.17.19 Chnaging this section below. We need section 3A and 3B for plant decision maker, but this doesnt inlcude information on whether the plot is cultivated. 
//however, is doesn't seem like we ever use this "cultiated" variable we generate here (we generate it elsewhere and use that). So, I suggest we dont gen cultivated here which makes this section a lot more straightforward
//I've commented out the other code and made these chnages for now, but we should discuss (perhaps with Dave and Isabella) to make sure this makes sense. 

/*/ALT 10.28.19 Experimented with replacing Sec3a/3b (plot innputs) with Sec 2a. Didinot help. 
use "${UGS_W1_raw_data/2009_AGSEC3A.dta}" , clear 
gen season =1 
append using "${UGS_W1_raw_data}/2009_AGEC3B.dta"
replace season = 2 if season == .
*ren plotID plot_id 
*ren parcelID parcel_id// using parcel ID 
*drop  if plot_id == . 
tempfile plot_inputs
save 'plot_inputs' , replace

use "${UGS_W1_raw_data}/2009_AGSEC2A.dta" , clear 
append using "{UGS_W1_raw_data}/2009_AgSEC2B.dta"
merge 1:m HHID parcelID using 'plot_inputs'
renplotID plot-id 
ren parcelID parcel_id
*/

// PA 5/24/2023: Since the plot managers are not reported in section 3 but 2, we need to create plotid in section 3 and then merge with section 2 to take the management to plot level (we could try with section 5 since the specific variable we use in section 2 is about control of output)
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


*Gender/age variables // Double check section 
/* gen double personid a3bq3 // DMC code // who was the primary decision maker during the first cropping? \replace person id a3bq3_3 if personid==. // who was the primary decision maker during the second cropping? // EFW 
5.21.19 zero observations where (a3aq3_4a1=.0 so include both as person 1// ALT: Leaving these as string */

*use "${UGS_W1_raw_data}/2009_AGSEC2A.dta", clear //land household owns

/*count if a2aq2 == . //0 observations
gen cultivated = (A2aq13a==1 | A2aq13a==2) //first cropping season
replace cultivated = 1 if (A2aq13b==1 | A2aq13b==2) //second cropping season
ren A2aq2 plotnum
rename plotnum crop_code

append using "${UGS_W1_raw_data}/2009_AGSEC2B.dta" //land household has user rights to

replace plotnum = A2bq2 if plotnum == .
drop if plotnum == .
ren Hhid HHID
replace cultivated = 1 if (A2bq15a==1 | A2bq15a==2 | A2bq15b==1 | A2bq15b==2) //first & second cropping season
*/

*Gender/age variables
gen individual = A2aq28a   //"Who usually (mainly) works on this parcel?" //Decided to NOT use "Who managed/controls the output from this parcel?" because less similar to questions in W1
replace individual = A2bq26a if individual == . & A2bq26a!=.
merge m:1 HHID individual using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_person_ids.dta", gen(dm1_merge) keep(1 3) //Dropping unmatched from using

*first decision-maker variable
gen dm1_female = female
drop female individual

*second decision-maker
gen individual = A2aq28b //"Who usually (mainly) works on this parcel?" //Decided to NOT use "Who managed/controls the output from this parcel?" because less similar to questions in wave 3 & 2 
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
keep HHID parcel_id dm_gender //cultivated
//lab var cultivated "1=Plot has been cultivated"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_decision_makers.dta", replace

*EFW 1.31.19 Renaming variables in 5A/5B related to area planted to can merge in below in monocropped plots
* moved to mononcroped plots, AA

********************************************************************************
*FORMALIZED LAND RIGHTS
********************************************************************************
** Not in original order under original W1.dta, double check if placement makes sense overall** 

use "${UGS_W1_raw_data}/2009_AGSEC2a.dta", clear
gen season = 1 
append using "${UGS_W1_raw_data}/2009_AGSEC2B.dta" 
replace season = 2 if season == . 
gen formal_land_rights = 1 if A2aq25<4
replace formal_land_rights = 0 if A2aq25==4 //SAW 1.31.23 Here I added this line for HH w/o documents as sero (previously we only had 1's and missing information) 

*starting with first owner 
preserve
gen individual=A2aq26a
replace individual=A2aq26b if individual==. & A2aq26b!=. // AA 4.24.23 by writting this line, there is no need to repeat another chunk of code  for second owner (check the sections commented out below)
*tostring PID, gen(pid) format (%18.0f) 
*tostring A2aq26a, gen(PID) format (%18.0f) 
*tostring Hhid, gen(HHid) format (%18.0f) 
*drop Hhid 
ren Hhid HHID
merge m:1 HHID individual using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_person_ids.dta" , nogen keep(3) // individual similar to PID 
*string and HHID+individual formated 
keep HHID individual female formal_land_rights
tempfile p1 
save `p1', replace 
restore 
 
/* now second owner 
preserve 
tostring a2aq26b , gen(PID) format(%18.0f) 
tostring HHID, format(%18.0f) replace 
mergem m:1 HHID PID using "${UGS_w1_created_data}/Uganda_NPS_LSMS_ISA_W1_persons_id.dta" , nogen keep(3) //PID 
string and HHID+PID formatted 
keep HHID PID female formal_land_rights 
append using `p1'
gen formal_land_rights_f, by (HHID PID) */

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_land_rights_hh.dta" , replace 

********************************************************************************
** 								ALL PLOTS									  **
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

********************************************************************************
*CROP VALUES*
********************************************************************************
use "${UGS_W1_raw_data}/2009_AGSEC5a" , clear 
append using "${UGS_W1_raw_data}/2009_AGSEC5B"
rename Hhid HHID
gen sold_qty=A5aq6a
gen season=1 if sold_qty!=. 
replace season = 2 if season == . & A5aq7a !=. 
*rename a5aq6a sold_qty 
clonevar unit_code=A5aq6c 
replace unit_code=A5aq6c if unit_code ==. 
gen sold_unit_code= A5aq7a
replace sold_unit_code= A5bq7c if sold_unit_code==. 
gen sold_value=A5aq8 
replace sold_value=A5bq8 if sold_value ==. // SAW 05;05.22 It seems like var a5aq8 "What was the value?" refers to total value of the crop sold in contrast to UG w5 that shows price unit. 
*use "$UGS_W1_created_data/Uganda_NPS_LSMS_ISA_W1_TLU_hhids,dta", clear 
*tostring HHID, format (%18.0f) replace 
merge m:1 HHID using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hhids.dta", nogen keepusing (region district county subcounty parish ea weight)
gen price_unit=sold_value/sold_qty
label var price_unit "Average sold value per crop unit"
gen obs = price_unit!=. 

// *AA 5.17.23* must renmae parcel_id, plot_id, crop_name, and crop_code so that merges later in the code are able to run more efficetintly (was running into issues in the plot variables section)

rename A5aq1 parcel_id 
rename A5aq3 plot_id 
rename A5aq4 crop_name 
rename A5aq5 crop_code  

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_value.dta" , replace 
keep HHID sold_unit_code crop_code sold_qty sold_value region district county subcounty parish ea weight obs price_unit 

*SAW The price_unit var has a mean of 29500 and around 7000 obs vs UG W% price unit mean of 2400 and 7000 observation EVEN after controlling for sold quantity. Maybe UG w5 it's also diving by kg or liters?

//This loop below creates a value for the price of each crop at the given regional levels seen in the first line. It stores this in temporary storage to allow for cleaner, simpler code, but could be stored permanently if you want. 
foreach i in region district county subcounty parish ea HHID {
		preserve
		bys `i' crop_code sold_unit_code : egen obs_`i'_price = sum(obs)
		collapse (median) price_unit_`i' = price_unit [aw=weight], by (`i' sold_unit_code crop_code  obs_`i'_price)
		rename sold_unit_code unit_code //needs to be done for a merge near the end of the all_plots indicator
		tempfile price_unit_`i'_median
		save `price_unit_`i'_median'
		restore
	}
	collapse (median) price_unit_country = price_unit (sum) obs_country_price = obs [aw=weight], by(sold_unit_code crop_code)
	rename sold_unit_code unit_code //needs to be done for a merge near the end of the all_plots indicator
	tempfile price_unit_country_median
	save `price_unit_country_median'

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

********************************************************************************
*Plot Variables* 
********************************************************************************
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
	replace purestand = 0 if (crops_plot > 1 & (harv_dates > 1)) | (crops_plot > 1 & permax == 1) //Multiple crops planted or harvested in the same month are not relayed; may omit some crops that were purestands that preceded or followed a mixed crops */ 
	
*generating mixed stand plot varibales (part 2) 
	gen mixed = (A4aq7 ==2 | A4bq7 ==2)
	bys HHID parcel_id plot_id season : egen mixed_max = max(mixed)
	
	/* replace purestand = 1 if crops_plot > 1 & plant_dates == 1 & permax == 0 & mixed_max  == 0 
	// JHG 1_14_22 : 8  replacements, all of which report missing crop_code vlaues. Should all missing crop_code values be dropped> If so, this should be done at an eraly stage. 
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
	recode crop_code (741 742 744 = 740)(221 222 223 224 = 220) // whic is being reduced from different types to just code. same for bananas (740) and peas (220) 
	label define cropID 740 "Bananas" 220 "Peas" , modify //need to add new codes to the value label, cropID 
	label values crop_code cropID 
	rename A5aq6b condition_harv 
	replace condition_harv	= A5bq6b if condition_harv == . 
	
* 	rename a5aq6c condition // SAW Question a5aq7b and a5bq7b are missing! Which is condition of sold crops - Assumption: We will use same as confition_harvested
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
	foreach i in region district county subcounty parish ea HHID { // JGH JHG 1_28_22: scounty_code and parish_code are not currently labeled, just numerical
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
	merge m:1 HHID parcel_id using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender) 
	gen ha_harvested = ha_planted
	save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_all_plots.dta", replace 
	
*Notes: AA removed months-harvested and plant_date from W3 template 

// merge not working, problem with plot decsions makers, does not contain plot_id OR season variable, problem with seasons generation, must ask peter/sebastian/andrew how to fix plot decisions and complete merge to finish plot variables section 

********************************************************************************
** 								ALL PLOTS END								  **
********************************************************************************	
********************************************************************************
*                              GROSS CROP REVENUE                              *
********************************************************************************

//ALT: A lot of this is redundant (variables already computed for "all plots")  and can be removed (or should be incorporated into the crop valuation code at the beginning of the section.)




