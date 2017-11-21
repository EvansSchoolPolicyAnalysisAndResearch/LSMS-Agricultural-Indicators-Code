
/*-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of a set of agricultural development indicators 
				  using the Tanzania National Panel Survey (TNPS) LSMS-ISA Wave 4 (2014-15)
*Author(s)		: Jack Knauer, David Coomes, Didier Alia, Ayala Wineman, Josh Merfeld, Pierre Biscaye, C. Leigh Anderson, &  Travis Reynolds

*Acknowledgments: We acknowledge the helpful contributions of members of the World Bank's LSMS-ISA team, the FAO's RuLIS team, IFPRI, IRRI, 
				  and the Bill & Melinda Gates Foundation Agricultural Development Data and Policy team in discussing indicator construction decisions. 
				  All coding errors remain ours alone.
*Date			: 10 November 2017

----------------------------------------------------------------------------------------------------------------------------------------------------*/


*Data source
*-----------
*The Tanzania National Panel Survey was collected by the Tanzania National Bureau of Statistics (NBS) 
*and the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture(LSMS - ISA)
*The data were collected over the period October 2015 - January 2016.
*All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
*http://microdata.worldbank.org/index.php/catalog/2862

*Throughout the do-file, we sometimes use the shorthand LSMS to refer to the Tanzania National Panel Survey.


*Summary of Executing the Master do.file
*-----------
*This Master do.file constructs selected indicators using the Tanzania TNPS (TZA LSMS) data set.
*First, save the raw unzipped data files from the World Bank in the "Raw DTA files\Wave 4 (2014-15)" folder  
*The do.file draws on these raw data files to first construct common and intermediate variables, saving dta files when appropriate 
*in the folder "Final DTA files\Wave 4 (2014-15)\created_data".
*These variables are then brought together at the household, plot, or individual level, saving dta files at each level when available 
*in the folder "Final DTA files\Wave 4 (2014-15)".

*The processed files include all households, individuals, and plots in the sample.
*Toward the end of the do.file, a block of code estimates summary statistics (mean, standard error of the mean, minimum, first quartile, median, third quartile, maximum) 
*of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager.
*The results are outputted in the excel file "Tanzania_NPS_LSMS_ISA_W4_summary_stats.xlsx" in the "Final DTA files\Wave 4 (2014-15)".
*It is possible to modify the condition  "if rural==1" in the portion of code following the heading "SUMMARY STATISTICS" to generate all summary statistics for a different sub_population.

*Information on EPAR's cleaning and construction decisions is available in the documents
*"EPAR_UW_335_Indicator Construction Summary Tables" and "EPAR_UW_335_General Considerations and Principles for Indicator Construction".

 
/*OUTLINE OF THE DO.FILE
Below are the list of the main files created by running this Master do.file
 					
*INTERMEDIATE FILES					MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD IDS						Tanzania_NPS_LSMS_ISA_W4_hhids.dta
*INDIVIDUAL IDS						Tanzania_NPS_LSMS_ISA_W4_person_ids.dta
*HOUSEHOLD SIZE						Tanzania_NPS_LSMS_ISA_W4_hhsize.dta
*PARCEL AREAS						Tanzania_NPS_LSMS_ISA_W4_plot_areas.dta
*PLOT-CROP DECISION MAKERS			Tanzania_NPS_LSMS_ISA_W4_plot_decision_makers.dta
*TLU (Tropical Livestock Units)		Tanzania_NPS_LSMS_ISA_W4_TLU_Coefficients.dta

*GROSS CROP REVENUE					Tanzania_NPS_LSMS_ISA_W4_tempcrop_harvest.dta
									Tanzania_NPS_LSMS_ISA_W4_tempcrop_sales.dta
									Tanzania_NPS_LSMS_ISA_W4_permcrop_harvest.dta
									Tanzania_NPS_LSMS_ISA_W4_permcrop_sales.dta
									Tanzania_NPS_LSMS_ISA_W4_hh_crop_production.dta
									Tanzania_NPS_LSMS_ISA_W4_plot_cropvalue.dta
									Tanzania_NPS_LSMS_ISA_W4_parcel_cropvalue.dta
									Tanzania_NPS_LSMS_ISA_W4_crop_residues.dta
									Tanzania_NPS_LSMS_ISA_W4_hh_crop_prices.dta
									Tanzania_NPS_LSMS_ISA_W4_crop_losses.dta
*CROP EXPENSES						Tanzania_NPS_LSMS_ISA_W4_wages_mainseason.dta
									Tanzania_NPS_LSMS_ISA_W4_wages_shortseason.dta
									
									Tanzania_NPS_LSMS_ISA_W4_fertilizer_costs.dta
									Tanzania_NPS_LSMS_ISA_W4_seed_costs.dta
									Tanzania_NPS_LSMS_ISA_W4_land_rental_costs.dta
									Tanzania_NPS_LSMS_ISA_W4_asset_rental_costs.dta
									Tanzania_NPS_LSMS_ISA_W4_transportation_cropsales.dta
									
*CROP INCOME						Tanzania_NPS_LSMS_ISA_W4_crop_income.dta
									
*LIVESTOCK INCOME					Tanzania_NPS_LSMS_ISA_W4_livestock_products.dta
									Tanzania_NPS_LSMS_ISA_W4_livestock_expenses.dta
									Tanzania_NPS_LSMS_ISA_W4_hh_livestock_products.dta
									Tanzania_NPS_LSMS_ISA_W4_livestock_sales.dta
									Tanzania_NPS_LSMS_ISA_W4_TLU.dta
									Tanzania_NPS_LSMS_ISA_W4_livestock_income.dta

*FISH INCOME						Tanzania_NPS_LSMS_ISA_W4_fishing_expenses_1.dta
									Tanzania_NPS_LSMS_ISA_W4_fishing_expenses_2.dta
									Tanzania_NPS_LSMS_ISA_W4_fish_income.dta
																	
*SELF-EMPLOYMENT INCOME				Tanzania_NPS_LSMS_ISA_W4_self_employment_income.dta
									Tanzania_NPS_LSMS_ISA_W4_agproducts_profits.dta
									Tanzania_NPS_LSMS_ISA_W4_fish_trading_revenue.dta
									Tanzania_NPS_LSMS_ISA_W4_fish_trading_other_costs.dta
									Tanzania_NPS_LSMS_ISA_W4_fish_trading_income.dta
									
*WAGE INCOME						Tanzania_NPS_LSMS_ISA_W4_wage_income.dta
									Tanzania_NPS_LSMS_ISA_W4_agwage_income.dta
*OTHER INCOME						Tanzania_NPS_LSMS_ISA_W4_other_income.dta
									Tanzania_NPS_LSMS_ISA_W4_land_rental_income.dta

*FARM SIZE / LAND SIZE				Tanzania_NPS_LSMS_ISA_W4_land_size.dta
									Tanzania_NPS_LSMS_ISA_W4_farmsize_all_agland.dta
									Tanzania_NPS_LSMS_ISA_W4_land_size_all.dta
*FARM LABOR							Tanzania_NPS_LSMS_ISA_W4_farmlabor_mainseason.dta
									Tanzania_NPS_LSMS_ISA_W4_farmlabor_shortseason.dta
									Tanzania_NPS_LSMS_ISA_W4_family_hired_labor.dta
*VACCINE USAGE						Tanzania_NPS_LSMS_ISA_W4_vaccine.dta
*USE OF INORGANIC FERTILIZER		Tanzania_NPS_LSMS_ISA_W4_fert_use.dta
*USE OF IMPROVED SEED				Tanzania_NPS_LSMS_ISA_W4_improvedseed_use.dta

*REACHED BY AG EXTENSION			Tanzania_NPS_LSMS_ISA_W4_any_ext.dta
*USE OF FORMAL FINANACIAL SERVICES	Tanzania_NPS_LSMS_ISA_W4_fin_serv.dta
*GENDER PRODUCTIVITY GAP 			Tanzania_NPS_LSMS_ISA_W4_gender_productivity_gap.dta
*MILK PRODUCTIVITY					Tanzania_NPS_LSMS_ISA_W4_milk_animals.dta
*EGG PRODUCTIVITY					Tanzania_NPS_LSMS_ISA_W4_eggs_animals.dta

*CROP PRODUCTION COSTS PER HECTARE	Tanzania_NPS_LSMS_ISA_W4_hh_cost_land.dta
									Tanzania_NPS_LSMS_ISA_W4_hh_cost_inputs_lrs.dta
									Tanzania_NPS_LSMS_ISA_W4_hh_cost_inputs_srs.dta
									Tanzania_NPS_LSMS_ISA_W4_hh_cost_seed_lrs.dta
									Tanzania_NPS_LSMS_ISA_W4_hh_cost_seed_srs.dta		
									Tanzania_NPS_LSMS_ISA_W4_cropcosts_perha.dta

*RATE OF FERTILIZER APPLICATION		Tanzania_NPS_LSMS_ISA_W4_fertilizer_application.dta
*HOUSEHOLD'S DIET DIVERSITY SCORE	Tanzania_NPS_LSMS_ISA_W4_household_diet.dta
*WOMEN'S CONTROL OVER INCOME		Tanzania_NPS_LSMS_ISA_W4_control_income.dta
*WOMEN'S AG DECISION-MAKING			Tanzania_NPS_LSMS_ISA_W4_make_ag_decision.dta
*WOMEN'S ASSET OWNERSHIP			Tanzania_NPS_LSMS_ISA_W4_ownasset.dta
*AGRICULTURAL WAGES					Tanzania_NPS_LSMS_ISA_W4_ag_wage.dta
*CROP YIELDS						Tanzania_NPS_LSMS_ISA_W4_yield_hh_crop_level.dta

*FINAL FILES						MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD VARIABLES				Tanzania_NPS_LSMS_ISA_W4_household_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			Tanzania_NPS_LSMS_ISA_W4_individual_variables.dta	
*PLOT-LEVEL VARIABLES				Tanzania_NPS_LSMS_ISA_W4_gender_productivity_gap.dta
*SUMMARY STATISTICS					Tanzania_NPS_LSMS_ISA_W4_summary_stats.xlsx
*/


clear
set more off

//set directories
*These paths correspond to the folders where the raw data files are located and where the created data and final data will be stored.
global raw_data 	"Raw DTA files\Wave 4 (2014-15)"
global created_data "Final DTA files\Wave 4 (2014-15)\created_data"
global final_data  	"Final DTA files\Wave 4 (2014-15)"
  
 
************************
*HOUSEHOLD IDS
************************
use "${raw_data}\Household\hh_sec_a.dta", clear
rename hh_a01_1 region 
rename hh_a01_2 region_name
rename hh_a02_1 district
rename hh_a02_2 district_name
rename hh_a03_1 ward 
rename hh_a03_2 ward_name
rename hh_a03_3a village 
rename hh_a03_3b village_name
rename hh_a04_1 ea
rename y4_weights weight
gen rural = (clustertype==1)
keep y4_hhid region district ward village region_name district_name ward_name village_name ea rural weight strataid clusterid
lab var rural "1=Household lives in a rural area"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hhids.dta", replace



************************
*INDIVIDUAL IDS
************************
use "${raw_data}\Household\hh_sec_b.dta", clear
keep y4_hhid indidy4 hh_b02 hh_b04 hh_b05
gen female=hh_b02==2 
lab var female "1= indivdual is female"
gen age=hh_b04
lab var age "Indivdual age"
gen hh_head=hh_b05==1 
lab var hh_head "1= individual is household head"
drop hh_b02 hh_b04 hh_b05
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_person_ids.dta", replace
 
 
 
************************
*HOUSEHOLD SIZE
************************
use "${raw_data}\Household\hh_sec_b.dta", clear
gen hh_members = 1
rename hh_b05 relhead 
rename hh_b02 gender
gen fhh = (relhead==1 & gender==2)
collapse (sum) hh_members (max) fhh, by (y4_hhid)
lab var hh_members "Number of household members"
lab var fhh "1= Female-headed household"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hhsize.dta", replace



************************
*PLOT AREAS
************************
use "${raw_data}\Agriculture\ag_sec_2a.dta", clear
append using "${raw_data}\Agriculture\ag_sec_2b.dta"
rename plotnum plot_id
gen area_acres_est = ag2a_04
replace area_acres_est = ag2b_15 if area_acres_est==.
gen area_acres_meas = ag2a_09
replace area_acres_meas = ag2b_20 if area_acres_meas==.
keep if area_acres_est !=.
keep y4_hhid plot_id area_acres_est area_acres_meas
lab var area_acres_meas "Plot are in acres (GPSd)"
lab var area_acres_est "Plot area in acres (estimated)"
gen area_est_hectares=area_acres_est* (1/2.47105)  
gen area_meas_hectares= area_acres_meas* (1/2.47105)
lab var area_meas_hectares "Plot are in hectares (GPSd)"
lab var area_est_hectares "Plot area in hectares (estimated)"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_plot_areas.dta", replace



************************
*PLOT DECISION MAKERS
************************
use "${raw_data}/Household/hh_sec_b.dta", clear
ren indidy4 personid			// personid is the roster number, combination of household_id2 and personid are unique id for this wave
gen female =hh_b02==2
gen age = hh_b04
gen head = hh_b05==1 if hh_b05!=.
keep personid female age y4_hhid head
lab var female "1=Individual is a female"
lab var age "Individual age"
lab var head "1=Individual is the head of household"
save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_gender_merge.dta", replace

use "${raw_data}/Agriculture/ag_sec_3a.dta", clear
drop if plotnum==""
gen cultivated = ag3a_03==1
gen season=1
append using "${raw_data}/Agriculture/ag_sec_3b.dta"
replace season=2 if season==.
drop if plotnum==""
drop if ag3b_03==. & ag3a_03==.
replace cultivated = 1 if  ag3b_03==1 
*Gender/age variables
gen personid = ag3a_08_1
replace personid =ag3b_08_1 if personid==. &  ag3b_08_1!=.
merge m:1 y4_hhid personid using  "${created_data}/Tanzania_NPS_LSMS_ISA_W4_gender_merge.dta", gen(dm1_merge) keep(1 3)		// Dropping unmatched from using
*First decision-maker variables
gen dm1_female = female
drop female personid
*Second owner
gen personid = ag3a_08_2
replace personid =ag3b_08_2 if personid==. &  ag3b_08_2!=.
merge m:1 y4_hhid personid using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_gender_merge.dta", gen(dm2_merge) keep(1 3)		// Dropping unmatched from using
gen dm2_female = female
drop female personid
*Third
gen personid = ag3a_08_3
replace personid =ag3b_08_3 if personid==. &  ag3b_08_3!=.
merge m:1 y4_hhid personid using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_gender_merge.dta", gen(dm3_merge) keep(1 3)		// Dropping unmatched from using
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
merge m:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hhsize.dta", nogen 								// all matched
replace dm_gender = 1 if fhh==0 & dm_gender==.
replace dm_gender = 2 if fhh==1 & dm_gender==.
ren plotnum plot_id 
drop if  plot_id==""
keep y4_hhid plot_id plotname dm_gender  cultivated  
lab var cultivated "1=Plot has been cultivated"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_plot_decision_makers.dta", replace



************************
*TLU (Tropical Livestock Units)
************************
use "${raw_data}\Livestock and Fisheries\lf_sec_02.dta", clear
*Rename lvstckid livestock_code_tanz_lsms
gen tlu_coefficient=0.5 if (lvstckid==1|lvstckid==2|lvstckid==3|lvstckid==4|lvstckid==5|lvstckid==6)
replace tlu_coefficient=0.1 if (lvstckid==7|lvstckid==8)
replace tlu_coefficient=0.2 if (lvstckid==9)
replace tlu_coefficient=0.01 if (lvstckid==10|lvstckid==11|lvstckid==12|lvstckid==13)
replace tlu_coefficient=0.3 if (lvstckid==14)
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep y4_hhid lvstckid tlu_coefficient
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_TLU_Coefficients.dta", replace



************************
*GROSS CROP REVENUE
************************
*Temporary crops (both seasons)
use "${raw_data}\Agriculture\ag_sec_4a.dta", clear
append using "${raw_data}\Agriculture\ag_sec_4b.dta"
drop if plotnum==""
rename zaocode crop_code
rename zaoname crop_name
rename plotnum plot_id
rename ag4a_19 harvest_yesno
replace harvest_yesno = ag4b_19 if harvest_yesno==.
rename ag4a_28 kgs_harvest
replace kgs_harvest = ag4b_28 if kgs_harvest==.
rename ag4a_29 value_harvest
replace value_harvest = ag4b_29 if value_harvest==.
replace kgs_harvest = 0 if harvest_yesno==2
replace value_harvest = 0 if harvest_yesno==2
drop if y4_hhid=="1230-001" & crop_code==71 /* Bananas belong in permanent crops file */
replace kgs_harvest = 5200 if y4_hhid=="6415-001" & crop_code==51 /* This is clearly a typo, one missing zero */
collapse (sum) kgs_harvest value_harvest, by (y4_hhid crop_code plot_id)
lab var kgs_harvest "Kgs harvested of this crop, summed over main and short season"
lab var value_harvest "Value harvested of this crop, summed over main and short season"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_tempcrop_harvest.dta", replace

use "${raw_data}\Agriculture\ag_sec_5a.dta", clear
append using "${raw_data}\Agriculture\ag_sec_5b.dta"
drop if zaocode==.
rename zaocode crop_code
rename zaoname crop_name
rename ag5a_01 sell_yesno
replace sell_yesno = ag5b_01 if sell_yesno==.
rename ag5a_02 quantity_sold
replace quantity_sold = ag5b_02 if quantity_sold==.
rename ag5a_03 value_sold
replace value_sold = ag5b_03 if value_sold==.
keep if sell_yesno==1
replace crop_code = 31 if y4_hhid=="5985-001" & crop_code==32 /* This is a typo, crops didn't match across production and sales files */
collapse (sum) quantity_sold value_sold, by (y4_hhid crop_code)
lab var quantity_sold "Kgs sold of this crop, summed over main and short season"
lab var value_sold "Value sold of this crop, summed over main and short season"
gen price_kg = value_sold / quantity_sold
lab var price_kg "Price per kg sold"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_tempcrop_sales.dta", replace

*Permanent and tree crops
use "${raw_data}\Agriculture\ag_sec_6a.dta", clear
append using "${raw_data}\Agriculture\ag_sec_6b.dta"
drop if plotnum==""
rename zaocode crop_code
rename zaoname crop_name
rename ag6a_09 kgs_harvest
rename plotnum plot_id
replace kgs_harvest = ag6b_09 if kgs_harvest==.
replace kgs_harvest = 115 if y4_hhid=="1230-001" & crop_code==71 /* Typo */
collapse (sum) kgs_harvest, by (y4_hhid crop_code plot_id)
lab var kgs_harvest "Kgs harvested of this crop, summed over main and short season"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_permcrop_harvest.dta", replace

use "${raw_data}\Agriculture\ag_sec_7a.dta", clear
append using "${raw_data}\Agriculture\ag_sec_7b.dta"
drop if zaocode==.
rename zaocode crop_code
rename zaoname crop_name
rename ag7a_02 sell_yesno
replace sell_yesno = ag7b_02 if sell_yesno==.
rename ag7a_03 quantity_sold
replace quantity_sold = ag7b_03 if quantity_sold==.
rename ag7a_04 value_sold
replace value_sold = ag7b_04 if value_sold==.
keep if sell_yesno==1
recode quantity_sold value_sold (.=0)
collapse (sum) quantity_sold value_sold, by (y4_hhid crop_code)
lab var quantity_sold "Kgs sold of this crop, summed over main and short season"
lab var value_sold "Value sold of this crop, summed over main and short season"
gen price_kg = value_sold / quantity_sold
lab var price_kg "Price per kg sold"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_permcrop_sales.dta", replace

*Prices of permanent and tree crops need to be imputed from sales.
use "${created_data}\Tanzania_NPS_LSMS_ISA_W4_permcrop_sales.dta", clear
append using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_tempcrop_sales.dta"
merge m:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hhids.dta"
drop if _merge==2
drop _merge
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_crop_sales.dta", replace

use "${created_data}\Tanzania_NPS_LSMS_ISA_W4_crop_sales.dta", clear
gen observation = 1
bys region district ward ea crop_code: egen obs_ea = count(observation)
collapse (median) price_kg [aw=weight], by (region district ward ea crop_code obs_ea)
rename price_kg price_kg_median_ea
lab var price_kg_median_ea "Median price per kg for this crop in the enumeration area"
lab var obs_ea "Number of sales observations for this crop in the enumeration area"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_crop_prices_ea.dta", replace
use "${created_data}\Tanzania_NPS_LSMS_ISA_W4_crop_sales.dta", clear
gen observation = 1
bys region district ward crop_code: egen obs_ward = count(observation)
collapse (median) price_kg [aw=weight], by (region district ward crop_code obs_ward)
rename price_kg price_kg_median_ward
lab var price_kg_median_ward "Median price per kg for this crop in the ward"
lab var obs_ward "Number of sales observations for this crop in the ward"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_crop_prices_ward.dta", replace
use "${created_data}\Tanzania_NPS_LSMS_ISA_W4_crop_sales.dta", clear
gen observation = 1
bys region district crop_code: egen obs_district = count(observation) /* Should this be divided by rural/urban? */
collapse (median) price_kg [aw=weight], by (region district crop_code obs_district)
rename price_kg price_kg_median_district
lab var price_kg_median_district "Median price per kg for this crop in the district"
lab var obs_district "Number of sales observations for this crop in the district"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_crop_prices_district.dta", replace
use "${created_data}\Tanzania_NPS_LSMS_ISA_W4_crop_sales.dta", clear
gen observation = 1
bys region crop_code: egen obs_region = count(observation)
collapse (median) price_kg [aw=weight], by (region crop_code obs_region)
rename price_kg price_kg_median_region
lab var price_kg_median_region "Median price per kg for this crop in the region"
lab var obs_region "Number of sales observations for this crop in the region"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_crop_prices_region.dta", replace
use "${created_data}\Tanzania_NPS_LSMS_ISA_W4_crop_sales.dta", clear
gen observation = 1
bys crop_code: egen obs_country = count(observation)
collapse (median) price_kg [aw=weight], by (crop_code obs_country)
rename price_kg price_kg_median_country
lab var price_kg_median_country "Median price per kg for this crop in the country"
lab var obs_country "Number of sales observations for this crop in the country"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_crop_prices_country.dta", replace

*Pull prices into harvest estimates
use "${created_data}\Tanzania_NPS_LSMS_ISA_W4_tempcrop_harvest.dta", clear
append using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_permcrop_harvest.dta"
merge m:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hhids.dta"
drop if _merge==2
drop _merge
/* collapse (sum) kgs_harvest value_harvest, by (y4_hhid crop_code)  
lab var kgs_harvest "Kgs harvested of this crop, summed over main and short season"
lab var value_harvest "Value harvested of this crop, summed over main and short season" */
merge m:1 y4_hhid crop_code using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_crop_sales.dta"
drop _merge
merge m:1 region district ward ea crop_code using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_crop_prices_ea.dta"
drop _merge
merge m:1 region district ward crop_code using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_crop_prices_ward.dta"
drop _merge
merge m:1 region district crop_code using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_crop_prices_district.dta"
drop _merge
merge m:1 region crop_code using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_crop_prices_region.dta"
drop _merge
merge m:1 crop_code using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_crop_prices_country.dta"
drop _merge
gen price_kg_hh = price_kg
/*How do value estimates stack up against observed sales prices?
gen price_kg_check = value_harvest / kgs_harvest */
replace price_kg = price_kg_median_ea if price_kg==. & obs_ea >= 10 & crop_code!=998 /* Don't impute prices for "other" crops */
replace price_kg = price_kg_median_ward if price_kg==. & obs_ward >= 10 & crop_code!=998
replace price_kg = price_kg_median_district if price_kg==. & obs_district >= 10 & crop_code!=998
replace price_kg = price_kg_median_region if price_kg==. & obs_region >= 10 & crop_code!=998
replace price_kg = price_kg_median_country if price_kg==. & crop_code!=998 
lab var price_kg "Price per kg, with missing values imputed using local median values"
gen value_harvest_imputed = value_harvest
replace value_harvest_imputed = kgs_harvest * price_kg_hh if price_kg_hh!=. /* Use observed hh price if it exists */
replace value_harvest_imputed = kgs_harvest * price_kg if value_harvest_imputed==.
replace value_harvest_imputed = value_harvest if value_harvest_imputed==. & crop_code==998 /* "Other" */
*replace value_harvest_imputed = value_sold if kgs_harvest==0 & value_sold!=0 & value_sold!=.
*replace value_harvest_imputed = value_sold if value_sold>value_harvest_imputed & value_sold!=. & value_harvest_imputed!=. /* In a few cases, the kgs sold exceeds the kgs harvested */
replace value_harvest_imputed = 0 if value_harvest_imputed==.
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_crop_values_tempfile.dta", replace 
collapse (sum) value_harvest_imputed value_sold, by (y4_hhid crop_code)
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hh_crop_values_production.dta", replace
collapse (sum) value_harvest_imputed value_sold, by (y4_hhid)
replace value_harvest_imputed = value_sold if value_sold>value_harvest_imputed & value_sold!=. & value_harvest_imputed!=. /* In a few cases, the kgs sold exceeds the kgs harvested */
rename value_harvest_imputed value_crop_production
lab var value_crop_production "Gross value of crop production for this household"
*This is estimated using household value estimated for temporary crop production plus observed sales prices for permanent/tree crops.
*Prices are imputed using local median values when there are no sales.
*For "Other" permament/tree crops, if there are no observed prices, we can't estimate the value. For now, this has been given a value of zero.
rename value_sold value_crop_sales
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hh_crop_production.dta", replace

*Plot value of crop production
use "${created_data}\Tanzania_NPS_LSMS_ISA_W4_crop_values_tempfile.dta", clear
collapse (sum) value_harvest_imputed, by (y4_hhid plot_id)
rename value_harvest_imputed plot_value_harvest
lab var plot_value_harvest "Value of crop harvest on this plot"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_plot_cropvalue.dta", replace

*Crop residues (captured only in Tanzania) 
use "${raw_data}\Agriculture\ag_sec_5a.dta", clear
append using "${raw_data}\Agriculture\ag_sec_5b.dta"
gen residue_sold_yesno = (ag5a_33==7) /* Just 3 observations of sales of crop residue */
rename ag5a_35 value_cropresidue_sales
recode value_cropresidue_sales (.=0)
collapse (sum) value_cropresidue_sales, by (y4_hhid)
lab var value_cropresidue_sales "Value of sales of crop residue (considered an agricultural byproduct)"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_crop_residues.dta", replace

*For temporary crops, are we imputing with estimated value harvested or observed sales values?
*For now, with estimated values. Using the sales info could only be at crop-unit combinations. RIGA did the same.

*Crop values for inputs in agricultural product processing (self-employment)
use "${created_data}\Tanzania_NPS_LSMS_ISA_W4_tempcrop_harvest.dta", clear
append using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_permcrop_harvest.dta"
merge m:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hhids.dta"
drop if _merge==2
drop _merge
/* collapse (sum) kgs_harvest value_harvest, by (y4_hhid crop_code)  
lab var kgs_harvest "Kgs harvested of this crop, summed over main and short season"
lab var value_harvest "Value harvested of this crop, summed over main and short season" */
merge m:1 y4_hhid crop_code using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_crop_sales.dta"
drop _merge
merge m:1 region district ward ea crop_code using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_crop_prices_ea.dta"
drop _merge
merge m:1 region district ward crop_code using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_crop_prices_ward.dta"
drop _merge
merge m:1 region district crop_code using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_crop_prices_district.dta"
drop _merge
merge m:1 region crop_code using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_crop_prices_region.dta"
drop _merge
merge m:1 crop_code using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_crop_prices_country.dta"
drop _merge
/*How do value estimates stack up against observed sales prices?
gen price_kg_check = value_harvest / kgs_harvest */
replace price_kg = price_kg_median_ea if price_kg==. & obs_ea >= 10 & crop_code!=998 /* Don't impute prices for "other" crops */
replace price_kg = price_kg_median_ward if price_kg==. & obs_ward >= 10 & crop_code!=998
replace price_kg = price_kg_median_district if price_kg==. & obs_district >= 10 & crop_code!=998
replace price_kg = price_kg_median_region if price_kg==. & obs_region >= 10 & crop_code!=998
replace price_kg = price_kg_median_country if price_kg==. & crop_code!=998 
lab var price_kg "Price per kg, with missing values imputed using local median values"
gen value_harvest_imputed = value_harvest
replace value_harvest_imputed = kgs_harvest * price_kg if value_harvest_imputed==.
replace value_harvest_imputed = value_harvest if value_harvest_imputed==. & crop_code==998 /* "Other" */
replace value_harvest_imputed = 0 if value_harvest_imputed==.
keep y4_hhid crop_code price_kg 
duplicates drop
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hh_crop_prices.dta", replace

*Crops lost post-harvest
use "${raw_data}\Agriculture\ag_sec_7a.dta", clear
append using "${raw_data}\Agriculture\ag_sec_7b.dta"
append using "${raw_data}\Agriculture\ag_sec_5a.dta"
append using "${raw_data}\Agriculture\ag_sec_5b.dta" 
drop if zaocode==.
rename zaocode crop_code
rename ag7a_16 value_lost
replace value_lost = ag7b_16 if value_lost==.
replace value_lost = ag5a_32 if value_lost==.
replace value_lost = ag5b_32 if value_lost==.
recode value_lost (.=0)
collapse (sum) value_lost, by (y4_hhid crop_code)
merge 1:1 y4_hhid crop_code using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hh_crop_values_production.dta"
drop if _merge==2
*Ignore the merge issues for now. Not worth it.
*Cap farmer-estimated losses at analyst-estimated value of production.
*br if value_lost > value_harvest_imputed
replace value_lost = value_harvest_imputed if value_lost > value_harvest_imputed
collapse (sum) value_lost, by (y4_hhid)
rename value_lost crop_value_lost
lab var crop_value_lost "Value of crop production that had been lost by the time of survey"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_crop_losses.dta", replace

*Gross crop income files
use "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hh_crop_production.dta", clear
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_crop_losses.dta"
drop _merge
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_crop_residues.dta"
drop _merge
*Variables: value_crop_production value_cropresidue_sales crop_value_lost  



************************
*CROP EXPENSES
************************
*Expenses: Hired labor
use "${raw_data}\Agriculture\ag_sec_3a.dta", clear
rename ag3a_74_4 wages_landprep_planting
rename ag3a_74_8 wages_weeding
rename ag3a_74_16 wages_harvesting
recode wages_landprep_planting wages_weeding wages_harvesting (.=0)
gen wages_paid_mainseason = wages_landprep_planting + wages_weeding + wages_harvesting 
collapse (sum) wages_paid_mainseason, by (y4_hhid)
lab var wages_paid_mainseason  "Wages paid for hired labor (crops) in main growing season"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_wages_mainseason.dta", replace

use "${raw_data}\Agriculture\ag_sec_3b.dta", clear
rename ag3b_74_4 wages_landprep_planting
rename ag3b_74_8 wages_weeding
rename ag3b_74_16 wages_harvesting
recode wages_landprep_planting wages_weeding wages_harvesting (.=0)
gen wages_paid_shortseason = wages_landprep_planting + wages_weeding + wages_harvesting 
collapse (sum) wages_paid_shortseason, by (y4_hhid)
lab var wages_paid_shortseason  "Wages paid for hired labor (crops) in short growing season"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_wages_shortseason.dta", replace

*Expenses: Inputs
use "${raw_data}\Agriculture\ag_sec_3a.dta", clear
append using "${raw_data}\Agriculture\ag_sec_3b.dta"
gen value_fertilizer_1 = ag3a_51
replace value_fertilizer_1 = ag3b_51 if value_fertilizer_1==.
gen value_fertilizer_2 = ag3a_58
replace value_fertilizer_2 = ag3b_58 if value_fertilizer_2==.
recode value_fertilizer_1 value_fertilizer_2 (.=0)
gen value_fertilizer = value_fertilizer_1 + value_fertilizer_2
gen value_herbicide = ag3a_63
replace value_herbicide = ag3b_63 if value_herbicide==.
gen value_pesticide = ag3a_65c
replace value_pesticide = ag3b_65c if value_pesticide==.
recode value_herbicide value_pesticide (.=0)
gen value_manure_purchased = ag3a_45
replace value_manure_purchased = ag3b_45 if value_manure_purchased==.
recode value_manure_purchased (.=0)
*As I understand the survey instrument, the value of inputs obtained on credit is already captured in the question "What was the total value of the --- purchased?"
collapse (sum) value_fertilizer value_herbicide value_pesticide value_manure_purchased, by (y4_hhid)
lab var value_fertilizer "Value of fertilizer purchased (not necessarily the same as used) in main and short growing seasons"
lab var value_herbicide "Value of herbicide purchased (not necessarily the same as used) in main and short growing seasons"
lab var value_pesticide "Value of pesticide purchased (not necessarily the same as used) in main and short growing seasons"
lab var value_manure_purchased "Value of manure purchased (not what was used) in main and short growing seasons"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_fertilizer_costs.dta", replace

*Seed
use "${raw_data}\Agriculture\ag_sec_4a.dta", clear
append using "${raw_data}\Agriculture\ag_sec_4b.dta"
gen cost_seed = ag4a_12
replace cost_seed = ag4b_12 if cost_seed==.
recode cost_seed (.=0)
collapse (sum) cost_seed, by (y4_hhid)
lab var cost_seed "Expenditures on seed for temporary crops"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_seed_costs.dta", replace
*Note that planting material for permanent crops is not captured anywhere.

*Land rental
use "${raw_data}\Agriculture\ag_sec_3a.dta", clear
append using "${raw_data}\Agriculture\ag_sec_3b.dta"
gen rental_cost_land = ag3a_33
replace rental_cost_land = ag3b_33 if rental_cost_land==.
recode rental_cost_land (.=0)
collapse (sum) rental_cost_land, by (y4_hhid)
lab var rental_cost_land "Rental costs paid for land"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_land_rental_costs.dta", replace

*Rental of agricultural tools, machines, animal traction
use "${raw_data}\Agriculture\ag_sec_11.dta", clear
gen animal_traction = (itemid>=3 & itemid<=5)
gen ag_asset = (itemid<3 | itemid>8)
gen tractor = (itemid>=6 & itemid<=8)
rename ag11_09 rental_cost
gen rental_cost_animal_traction = rental_cost if animal_traction==1
gen rental_cost_ag_asset = rental_cost if ag_asset==1
gen rental_cost_tractor = rental_cost if tractor==1
recode rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor (.=0)
collapse (sum) rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor, by (y4_hhid)
lab var rental_cost_animal_traction "Costs for renting animal traction"
lab var rental_cost_ag_asset "Costs for renting other agricultural items"
lab var rental_cost_tractor "Costs for renting a tractor"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_asset_rental_costs.dta", replace

*Transport costs for crop sales
use "${raw_data}\Agriculture\ag_sec_5a.dta", clear
append using "${raw_data}\Agriculture\ag_sec_5b.dta"
rename ag5a_22 transport_costs_cropsales
replace transport_costs_cropsales = ag5b_22 if transport_costs_cropsales==.
recode transport_costs_cropsales (.=0)
collapse (sum) transport_costs_cropsales, by (y4_hhid)
lab var transport_costs_cropsales "Expenditures on transportation for crop sales of temporary crops"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_transportation_cropsales.dta", replace


*Crop costs 
use "${created_data}\Tanzania_NPS_LSMS_ISA_W4_asset_rental_costs.dta", clear
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_land_rental_costs.dta"
drop _merge
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_seed_costs.dta"
drop _merge
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_fertilizer_costs.dta"
drop _merge
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_wages_shortseason.dta"
drop _merge
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_wages_mainseason.dta"
drop _merge
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_transportation_cropsales.dta"
drop _merge
recode rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor rental_cost_land cost_seed value_fertilizer /*
*/ value_herbicide value_pesticide value_manure_purchased wages_paid_shortseason wages_paid_mainseason transport_costs_cropsales (.=0)
egen crop_production_expenses = rowtotal(rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor rental_cost_land cost_seed value_fertilizer /*
*/ value_herbicide value_pesticide value_manure_purchased wages_paid_shortseason wages_paid_mainseason transport_costs_cropsales)
lab var crop_production_expenses "Total crop production expenses"
save "$created_data\Tanzania_NPS_LSMS_ISA_W4_crop_income.dta", replace




************
*LIVESTOCK INCOME
************

*Expenses
use "${raw_data}\Livestock and Fisheries\lf_sec_04.dta", clear
append using "${raw_data}\Livestock and Fisheries\lf_sec_03.dta"
append using "${raw_data}\Livestock and Fisheries\lf_sec_05.dta"
rename lf04_04 cost_fodder_livestock
rename lf04_09 cost_water_livestock
rename lf03_14 cost_vaccines_livestock /* Includes costs of treatment */
rename lf05_07 cost_hired_labor_livestock 
recode cost_fodder_livestock cost_water_livestock cost_vaccines_livestock cost_hired_labor_livestock (.=0)
collapse (sum) cost_fodder_livestock cost_water_livestock cost_vaccines_livestock cost_hired_labor_livestock, by (y4_hhid)
lab var cost_water_livestock "Cost for water for livestock"
lab var cost_fodder_livestock "Cost for fodder for livestock"
lab var cost_vaccines_livestock "Cost for vaccines and veterminary treatment for livestock"
lab var cost_hired_labor_livestock "Cost for hired labor for livestock"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_expenses", replace

*Livestock products
use "${raw_data}\Livestock and Fisheries\lf_sec_06.dta", clear
rename lvstckcat livestock_code 
keep if livestock_code==1 | livestock_code==2
rename lf06_01 animals_milked
rename lf06_02 months_milked
rename lf06_03 liters_per_day 
recode animals_milked months_milked liters_per_day (.=0)
gen milk_liters_produced = (animals_milked * months_milked * 30 * liters_per_day) /* 30 days per month */
lab var milk_liters_produced "Liters of milk produced in past 12 months"
rename lf06_08 liters_sold_per_day
rename lf06_10 liters_perday_to_cheese /* Refers only to processed products there were sold. May need to value these inputs */
*Because we don't have separated values for milk and processed products, we're not going to value processed products for own-consumption. 
*We're implicitly assuming that the ratio of milk converted to products and consumed raw by the household mirrors what was sold.
rename lf06_11 earnings_per_day_milk
recode liters_sold_per_day liters_perday_to_cheese (.=0)
gen liters_sold_day = liters_sold_per_day + liters_perday_to_cheese 
*Where the estimates of # eggs sold exceeds the calculation of what was produced, let's take the lower value.
gen price_per_liter = earnings_per_day_milk / liters_sold_day
gen price_per_unit = price_per_liter
gen quantity_produced = milk_liters_produced
keep y4_hhid livestock_code milk_liters_produced price_per_liter price_per_unit quantity_produced
lab var price_per_liter "Price of milk per liter sold"
lab var price_per_unit "Price of milk per unit sold"
lab var quantity_produced "Quantity of milk produced"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_products_milk", replace

use "${raw_data}\Livestock and Fisheries\lf_sec_08.dta", clear
rename productid livestock_code
rename lf08_02 months_produced
rename lf08_03_1 quantity_month
rename lf08_03_2 quantity_month_unit
*The units listed here do not seem logical. You can't have liters of skins, liters of eggs, pieces of honey.
*In addition, sales are so rare that we won't find prices for the odd item-unit combinations.
*Some obvious units, like a tray of eggs, are missing.
replace quantity_month_unit = 3 if livestock_code==1
replace quantity_month_unit = 1 if livestock_code==2
replace quantity_month_unit = 3 if livestock_code==3
recode months_produced quantity_month (.=0)
gen quantity_produced = months_produced * quantity_month /* Units are pieces for eggs & skin, liters for honey */
lab var quantity_produced "Quantity of this product produed in past year"
rename lf08_05_1 sales_quantity
rename lf08_05_2 sales_unit
replace sales_unit = 3 if livestock_code==1
replace sales_unit = 1 if livestock_code==2
replace sales_unit = 3 if livestock_code==3
rename lf08_06 earnings_sales
recode sales_quantity months_produced quantity_month earnings_sales (.=0)
gen price_per_unit = earnings_sales / sales_quantity
keep y4_hhid livestock_code quantity_produced price_per_unit
replace livestock_code = 21 if livestock_code==1
replace livestock_code = 22 if livestock_code==2
replace livestock_code = 23 if livestock_code==3
label define livestock_code_label 21 "Eggs" 22 "Honey" 23 "Skins"
label values livestock_code livestock_code_label
bys livestock_code: sum price_per_unit
gen price_per_unit_hh = price_per_unit
lab var price_per_unit "Price of milk per unit sold"
lab var price_per_unit_hh "Price of milk per unit sold at household level"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_products_other", replace

use "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_products_milk", clear
append using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_products_other"
merge m:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hhids.dta"
drop if _merge==2
drop _merge
replace price_per_unit = . if price_per_unit == 0 
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_products", replace

use "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_products", clear
keep if price_per_unit !=. 
gen observation = 1
bys region district ward ea livestock_code: egen obs_ea = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district ward ea livestock_code obs_ea)
rename price_per_unit price_median_ea
lab var price_median_ea "Median price per unit for this livestock product in the ea"
lab var obs_ea "Number of sales observations for this livestock product in the ea"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_products_prices_ea.dta", replace
use "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region district ward livestock_code: egen obs_ward = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district ward livestock_code obs_ward)
rename price_per_unit price_median_ward
lab var price_median_ward "Median price per unit for this livestock product in the ward"
lab var obs_ward "Number of sales observations for this livestock product in the ward"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_products_prices_ward.dta", replace
use "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region district livestock_code: egen obs_district = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district livestock_code obs_district)
rename price_per_unit price_median_district
lab var price_median_district "Median price per unit for this livestock product in the district"
lab var obs_district "Number of sales observations for this livestock product in the district"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_products_prices_district.dta", replace
use "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_unit [aw=weight], by (region livestock_code obs_region)
rename price_per_unit price_median_region
lab var price_median_region "Median price per unit for this livestock product in the region"
lab var obs_region "Number of sales observations for this livestock product in the region"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_products_prices_region.dta", replace
use "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_unit [aw=weight], by (livestock_code obs_country)
rename price_per_unit price_median_country
lab var price_median_country "Median price per unit for this livestock product in the country"
lab var obs_country "Number of sales observations for this livestock product in the country"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_products_prices_country.dta", replace

use "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_products", clear
merge m:1 region district ward ea livestock_code using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_products_prices_ea.dta"
drop _merge
merge m:1 region district ward livestock_code using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_products_prices_ward.dta"
drop _merge
merge m:1 region district livestock_code using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_products_prices_district.dta"
drop _merge
merge m:1 region livestock_code using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_products_prices_region.dta"
drop _merge
merge m:1 livestock_code using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_products_prices_country.dta"
drop _merge
replace price_per_unit = price_median_ea if price_per_unit==. & obs_ea >= 10
replace price_per_unit = price_median_ward if price_per_unit==. & obs_ward >= 10
replace price_per_unit = price_median_district if price_per_unit==. & obs_district >= 10 
replace price_per_unit = price_median_region if price_per_unit==. & obs_region >= 10 
replace price_per_unit = price_median_country if price_per_unit==.
lab var price_per_unit "Price per unit of this livestock product, with missing values imputed using local median values"
*The milk of small ruminants is never sold? Just 15 obs of HHs that produce this milk. Value it as cow milk.
gen price_cowmilk_med = price_median_country if livestock_code==1
egen price_cowmilk = max(price_cowmilk_med)
replace price_per_unit = price_cowmilk if livestock_code==2
lab var price_per_unit "Price per liter (milk) or per egg/liter/container honey, imputed with local median prices if household did not sell"
gen value_milk_produced = milk_liters_produced * price_per_unit 
gen value_eggs_produced = quantity_produced * price_per_unit if livestock_code==21
gen value_other_produced = quantity_produced * price_per_unit if livestock_code==22 | livestock_code==23
collapse (sum) value_milk_produced value_eggs_produced value_other_produced, by (y4_hhid)
lab var value_milk_produced "Value of milk produced"
lab var value_eggs_produced "Value of eggs produced"
lab var value_other_produced "Value of honey and skins produced"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hh_livestock_products", replace
*Watch out for outliers.

use "${raw_data}\Livestock and Fisheries\lf_sec_07.dta", clear
rename lf07_03 sales_dung
recode sales_dung (.=0)
collapse (sum) sales_dung, by (y4_hhid)
lab var sales_dung "Value of dung sold" 
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_dung.dta", replace


*Sales (live animals)
use "${raw_data}\Livestock and Fisheries\lf_sec_02.dta", clear
rename lvstckid livestock_code
rename lf02_26 income_live_sales 
rename lf02_25 number_sold 
rename lf02_30 number_slaughtered 
rename lf02_32 number_slaughtered_sold 
rename lf02_33 income_slaughtered
rename lf02_08 value_livestock_purchases
*br y4_hhid livestock_code income_live_sales number_sold number_slaughtered number_slaughtered_sold income_slaughtered 
*bys livestock_code: tab number_slaughtered_sold /* Very few slaughtered animals are sold. */
recode income_live_sales number_sold number_slaughtered number_slaughtered_sold income_slaughtered value_livestock_purchases (.=0)
gen price_per_animal = income_live_sales / number_sold
lab var price_per_animal "Price of live animale sold"
merge m:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hhids.dta"
drop if _merge==2
drop _merge
keep y4_hhid weight region district ward ea livestock_code number_sold income_live_sales number_slaughtered income_slaughtered price_per_animal value_livestock_purchases
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hh_livestock_sales", replace

*Implicit prices
use "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district ward ea livestock_code: egen obs_ea = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district ward ea livestock_code obs_ea)
rename price_per_animal price_median_ea
lab var price_median_ea "Median price per unit for this livestock in the ea"
lab var obs_ea "Number of sales observations for this livestock in the ea"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_prices_ea.dta", replace
use "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district ward livestock_code: egen obs_ward = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district ward livestock_code obs_ward)
rename price_per_animal price_median_ward
lab var price_median_ward "Median price per unit for this livestock in the ward"
lab var obs_ward "Number of sales observations for this livestock in the ward"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_prices_ward.dta", replace
use "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district livestock_code: egen obs_district = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district livestock_code obs_district)
rename price_per_animal price_median_district
lab var price_median_district "Median price per unit for this livestock in the district"
lab var obs_district "Number of sales observations for this livestock in the district"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_prices_district.dta", replace
use "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_animal [aw=weight], by (region livestock_code obs_region)
rename price_per_animal price_median_region
lab var price_median_region "Median price per unit for this livestock in the region"
lab var obs_region "Number of sales observations for this livestock in the region"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_prices_region.dta", replace
use "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_animal [aw=weight], by (livestock_code obs_country)
rename price_per_animal price_median_country
lab var price_median_country "Median price per unit for this livestock in the country"
lab var obs_country "Number of sales observations for this livestock in the country"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_prices_country.dta", replace

use "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hh_livestock_sales", clear
merge m:1 region district ward ea livestock_code using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_prices_ea.dta"
drop _merge
merge m:1 region district ward livestock_code using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_prices_ward.dta"
drop _merge
merge m:1 region district livestock_code using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_prices_district.dta"
drop _merge
merge m:1 region livestock_code using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_prices_region.dta"
drop _merge
merge m:1 livestock_code using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_prices_country.dta"
drop _merge /* All have merges */
replace price_per_animal = price_median_ea if price_per_animal==. & obs_ea >= 10
replace price_per_animal = price_median_ward if price_per_animal==. & obs_ward >= 10
replace price_per_animal = price_median_district if price_per_animal==. & obs_district >= 10
replace price_per_animal = price_median_region if price_per_animal==. & obs_region >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_sold = price_per_animal * number_sold
gen value_slaughtered = price_per_animal * number_slaughtered
replace value_slaughtered = income_slaughtered if (value_slaughtered < income_slaughtered) & number_slaughtered!=0 /* Replace value of slaughtered animals with income from slaughtered-sales if the latter is larger */
gen value_livestock_sales = value_sold + value_slaughtered
collapse (sum) value_livestock_sales value_livestock_purchases, by (y4_hhid)
drop if y4_hhid==""
lab var value_livestock_sales "Value of livestock sold and slaughtered (with slaughtered livestock that weren't sold valued at local median prices for live animal sales)"
lab var value_livestock_purchases "Value of livestock purchases (seems to span only the agricutlural season, not the year)"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_sales", replace

*TLU (Tropical Livestock Units)
use "${raw_data}\Livestock and Fisheries\lf_sec_02.dta", clear
merge m:m lvstckid using  "${created_data}\Tanzania_NPS_LSMS_ISA_W4_TLU_Coefficients.dta"
drop if _merge==2
drop _merge
rename lvstckid livestock_code
rename lf02_03 number_1yearago
rename lf02_04_1 number_today_indigenous
rename lf02_04_2 number_today_exotic
recode number_today_indigenous number_today_exotic (.=0)
gen number_today = number_today_indigenous + number_today_exotic
gen tlu_1yearago = number_1yearago * tlu_coefficient
gen tlu_today = number_today * tlu_coefficient
rename lf02_26 income_live_sales 
rename lf02_25 number_sold 
*Lots of things are valued in between here, but it isn't a complete story.
*So livestock holdings will be valued using observed sales prices.
gen price_per_animal = income_live_sales / number_sold
merge m:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hhids.dta"
drop if _merge==2
drop _merge
merge m:1 region district ward ea livestock_code using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_prices_ea.dta"
drop _merge
merge m:1 region district ward livestock_code using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_prices_ward.dta"
drop _merge
merge m:1 region district livestock_code using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_prices_district.dta"
drop _merge
merge m:1 region livestock_code using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_prices_region.dta"
drop _merge
merge m:1 livestock_code using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_prices_country.dta"
drop _merge 
replace price_per_animal = price_median_ea if price_per_animal==. & obs_ea >= 10
replace price_per_animal = price_median_ward if price_per_animal==. & obs_ward >= 10
replace price_per_animal = price_median_district if price_per_animal==. & obs_district >= 10
replace price_per_animal = price_median_region if price_per_animal==. & obs_region >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_1yearago = number_1yearago * price_per_animal
gen value_today = number_today * price_per_animal
collapse (sum) tlu_1yearago tlu_today value_1yearago value_today, by (y4_hhid)
lab var tlu_1yearago "Tropical Livestock Units as of 12 months ago"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
lab var value_1yearago "Value of livestock holdings from one year ago"
lab var value_today "Value of livestock holdings today"
drop if y4_hhid==""
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_TLU.dta", replace


*Livestock income
use "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_sales", clear
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hh_livestock_products"
drop _merge
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_dung.dta"
drop _merge
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_expenses"
drop _merge
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_TLU.dta"
drop _merge
*3,352 households, as expected.
gen livestock_income = value_livestock_sales - value_livestock_purchases /*
*/ + (value_milk_produced + value_eggs_produced + value_other_produced + sales_dung) /*
*/ - (cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_water_livestock)
lab var livestock_income "Net livestock income (value of production and consumption minus expenditures)"
save "$created_data\Tanzania_NPS_LSMS_ISA_W4_livestock_income", replace

 

************
*FISH INCOME
************
*Fishing expenses
use "${raw_data}\Livestock and Fisheries\lf_sec_09.dta", clear
rename lf09_02_1 weeks_fishing
rename lf09_02_2 days_per_week
recode weeks_fishing days_per_week (.=0)
collapse (max) weeks_fishing days_per_week, by (y4_hhid) /* Time allocations captured at individual level, fishing income captured at household level. 
It's not clear whether these would be concurrent or sequential. */
keep y4_hhid weeks_fishing days_per_week
lab var weeks_fishing "Weeks spent working as a fisherman (maximum observed across individuals in household)"
lab var days_per_week "Days per week spent working as a fisherman (maximum observed across individuals in household)"
save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_weeks_fishing.dta", replace

*Section 10 - Hired labor
*use "${raw_data}\Livestock and Fisheries\lf_sec_10.dta", clear
*Not found in the actual data set - Need to ask about this.

use "${raw_data}\Livestock and Fisheries\lf_sec_11a.dta", clear
*Purchases (not rentals) are not captured in this income estimate, though they are captured in the data set.
rename lf11_03 weeks
rename lf11_07 fuel_costs_week
rename lf11_08 rental_costs_fishing 
recode weeks fuel_costs_week rental_costs_fishing (.=0)
gen cost_fuel = fuel_costs_week * weeks
collapse (sum) cost_fuel rental_costs_fishing, by (y4_hhid)
lab var cost_fuel "Costs for fuel over the past year"
lab var rental_costs_fishing "Costs for other fishing expenses over the past year"
save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_fishing_expenses_1.dta", replace

use "${raw_data}\Livestock and Fisheries\lf_sec_11b.dta", clear
merge m:1 y4_hhid using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_weeks_fishing.dta"
gen cost = lf11b_10_1 if lf11b_10_1>=4 /* Exclude taxes, per RuLIS guidelines */
rename lf11b_10_2 unit
gen cost_paid = cost if unit==4 | unit==3
replace cost_paid = cost * weeks_fishing if unit==2
replace cost_paid = cost * weeks_fishing * days_per_week if unit==1
collapse (sum) cost_paid, by (y4_hhid)
lab var cost_paid "Other costs paid for fishing activities"
save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_fishing_expenses_2.dta", replace
*Watch out for outliers.

use "${raw_data}\Livestock and Fisheries\lf_sec_12.dta", clear
rename lf12_02_3 fish_code 
drop if fish_code==. /* "Other" = 33 */
rename lf12_05_1 fish_quantity_year
rename lf12_05_2 fish_quantity_unit
rename lf12_12_2 unit 
rename lf12_12_4 price_per_unit 
*rename lf12_12_6 unit_2
*rename lf12_12_8 price_unit_2
*Just two observations of processing type #2, not worth using this to value fish catches. 
merge m:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hhids.dta"
drop if _merge==2
drop _merge
collapse (median) price_per_unit [aw=weight], by (fish_code unit)
rename price_per_unit price_per_unit_median
replace price_per_unit_median = . if fish_code==33
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_fish_prices.dta", replace

use "${raw_data}\Livestock and Fisheries\lf_sec_12.dta", clear
rename lf12_02_3 fish_code 
drop if fish_code==. 
rename lf12_05_1 fish_quantity_year
rename lf12_05_2 unit
merge m:1 fish_code unit using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_fish_prices.dta"
drop if _merge==2
drop _merge
rename lf12_12_1 quantity_1
rename lf12_12_2 unit_1
rename lf12_12_4 price_unit_1
rename lf12_12_5 quantity_2
rename lf12_12_6 unit_2
rename lf12_12_8 price_unit_2
recode quantity_1 quantity_2 fish_quantity_year (.=0)
gen income_fish_sales = (quantity_1 * price_unit_1) + (quantity_2 * price_unit_2)
gen value_fish_harvest = (fish_quantity_year * price_unit_1) if unit==price_unit_1 /* Use household's price, if it's observed */
replace value_fish_harvest = (fish_quantity_year * price_per_unit_median) if value_fish_harvest==.
*count if fish_quantity_year!=0 & value_fish_harvest==. /* No missing values */
collapse (sum) value_fish_harvest income_fish_sales, by (y4_hhid)
recode value_fish_harvest income_fish_sales (.=0)
*count if value_fish_harvest < income_fish_sales /* Value of harvest is always larger */
lab var value_fish_harvest "Value of fish harvest (including what is sold), with values imputed using a national median for fish-unit-prices"
lab var income_fish_sales "Value of fish sales"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_fish_income.dta", replace



************
*SELF-EMPLOYMENT INCOME
************
use "${raw_data}\Household\hh_sec_n.dta", clear
rename hh_n19 months_activ
rename hh_n20 monthly_profit
gen annual_selfemp_profit = monthly_profit * months_activ
recode annual_selfemp_profit (.=0)
collapse (sum) annual_selfemp_profit, by (y4_hhid)
lab var annual_selfemp_profit "Estimated annual net profit from self-employment over previous 12 months"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_self_employment_income.dta", replace

*Processed crops - Seems like this is wrapped up in self-employment in other surveys.
use "${raw_data}\Agriculture\ag_sec_10.dta", clear
rename zaocode crop_code
rename zaoname crop_name
rename ag10_06 byproduct_sold_yesno
rename ag10_07_1 byproduct_quantity
rename ag10_07_2 byproduct_unit
rename ag10_08 kgs_used_in_byproduct /* refers to raw crop, value needs to be netted out. */
rename ag10_11 byproduct_price_received
rename ag10_13 other_expenses_yesno
rename ag10_14 byproduct_other_costs
merge m:1 y4_hhid crop_code using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hh_crop_prices.dta"
drop _merge
recode byproduct_quantity kgs_used_in_byproduct byproduct_other_costs (.=0)
gen byproduct_sales = byproduct_quantity * byproduct_price_received
gen byproduct_crop_cost = kgs_used_in_byproduct * price_kg
gen byproduct_profits = byproduct_sales - (byproduct_crop_cost + byproduct_other_costs)
collapse (sum) byproduct_profits, by (y4_hhid)
lab var byproduct_profits "Net profit from sales of agricultural processed products or byproducts"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_agproducts_profits.dta", replace

*Fish trading
use "${raw_data}\Livestock and Fisheries\lf_sec_09.dta", clear
rename lf09_04_1 weeks_fish_trading 
recode weeks_fish_trading (.=0)
collapse (max) weeks_fish_trading, by (y4_hhid) /* Time allocations captured at individual level, fish trading income captured at household level. 
It's not clear whether these would be concurrent or sequential. */
keep y4_hhid weeks_fish_trading
lab var weeks_fish_trading "Weeks spent working as a fish trader (maximum observed across individuals in household)"
save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_weeks_fish_trading.dta", replace

use "${raw_data}\Livestock and Fisheries\lf_sec_13a.dta", clear
rename lf13a_03_1 quant_fish_purchased_1
rename lf13a_03_4 price_fish_purchased_1
rename lf13a_03_5 quant_fish_purchased_2
rename lf13a_03_8 price_fish_purchased_2
rename lf13a_04_1 quant_fish_sold_1
rename lf13a_04_4 price_fish_sold_1
rename lf13a_04_5 quant_fish_sold_2
rename lf13a_04_8 price_fish_sold_2
recode quant_fish_purchased_1 price_fish_purchased_1 quant_fish_purchased_2 price_fish_purchased_2 /*
*/ quant_fish_sold_1 price_fish_sold_1 quant_fish_sold_2 price_fish_sold_2 (.=0)
gen weekly_fishtrade_costs = (quant_fish_purchased_1 * price_fish_purchased_1) + (quant_fish_purchased_2 * price_fish_purchased_2)
gen weekly_fishtrade_revenue = (quant_fish_sold_1 * price_fish_sold_1) + (quant_fish_sold_2 * price_fish_sold_2)
gen weekly_fishtrade_profit = weekly_fishtrade_revenue - weekly_fishtrade_costs
collapse (sum) weekly_fishtrade_profit, by (y4_hhid)
lab var weekly_fishtrade_profit "Average weekly profits from fish trading (sales minus purchases), summed across individuals"
keep y4_hhid weekly_fishtrade_profit
save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_fish_trading_revenue.dta", replace

use "${raw_data}\Livestock and Fisheries\lf_sec_13b.dta", clear
rename lf13b_06 weekly_costs_for_fish_trading
recode weekly_costs_for_fish_trading (.=0)
collapse (sum) weekly_costs_for_fish_trading, by (y4_hhid)
lab var weekly_costs_for_fish_trading "Weekly costs associated with fish trading, in addition to purchase of fish"
keep y4_hhid weekly_costs_for_fish_trading
save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_fish_trading_other_costs.dta", replace

use "${created_data}/Tanzania_NPS_LSMS_ISA_W4_weeks_fish_trading.dta", clear
merge 1:1 y4_hhid using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_fish_trading_revenue.dta" 
drop _merge
merge 1:1 y4_hhid using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_fish_trading_other_costs.dta"
drop _merge
replace weekly_fishtrade_profit = weekly_fishtrade_profit - weekly_costs_for_fish_trading
gen fish_trading_income = (weeks_fish_trading * weekly_fishtrade_profit)
lab var fish_trading_income "Estimated net household earnings from fish trading over previous 12 months"
keep y4_hhid fish_trading_income
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_fish_trading_income.dta", replace

 
************
*WAGE INCOME
************

use "${raw_data}\Household\hh_sec_e.dta", clear
rename hh_e04ab wage_yesno
rename hh_e29 number_months
rename hh_e30 number_weeks
rename hh_e31 number_hours
rename hh_e26_1 most_recent_payment
replace most_recent_payment = . if hh_e20_2=="921"
rename hh_e26_2 payment_period
rename hh_e28_1 most_recent_payment_other
replace most_recent_payment_other = . if hh_e20_2=="921"
rename hh_e28_2 payment_period_other
rename hh_e36 secondary_wage_yesno
rename hh_e44_1 secwage_most_recent_payment
replace secwage_most_recent_payment = . if hh_e38_2=="921"
rename hh_e44_2 secwage_payment_period
rename hh_e46_1 secwage_recent_payment_other
rename hh_e46_2 secwage_payment_period_other
rename hh_e50 secwage_hours_pastweek
gen annual_salary_cash = most_recent_payment if payment_period==8
replace annual_salary_cash = ((number_months/6)*most_recent_payment) if payment_period==7
replace annual_salary_cash = ((number_months/4)*most_recent_payment) if payment_period==6
replace annual_salary_cash = (number_months*most_recent_payment) if payment_period==5
replace annual_salary_cash = (number_months*(number_weeks/2)*most_recent_payment) if payment_period==4
replace annual_salary_cash = (number_months*number_weeks*most_recent_payment) if payment_period==3
replace annual_salary_cash = (number_months*number_weeks*(number_hours/8)*most_recent_payment) if payment_period==2
replace annual_salary_cash = (number_months*number_weeks*number_hours*most_recent_payment) if payment_period==1
gen wage_salary_other = most_recent_payment_other if payment_period_other==8
replace wage_salary_other = ((number_months/6)*most_recent_payment_other) if payment_period_other==7
replace wage_salary_other = ((number_months/4)*most_recent_payment_other) if payment_period_other==6
replace wage_salary_other = (number_months*most_recent_payment_other) if payment_period_other==5
replace wage_salary_other = (number_months*(number_weeks/2)*most_recent_payment_other) if payment_period_other==4
replace wage_salary_other = (number_months*number_weeks*most_recent_payment_other) if payment_period_other==3
replace wage_salary_other = (number_months*number_weeks*(number_hours/8)*most_recent_payment_other) if payment_period_other==2
replace wage_salary_other = (number_months*number_weeks*number_hours*most_recent_payment_other) if payment_period_other==1
recode annual_salary_cash wage_salary_other (.=0)
gen annual_salary = annual_salary_cash + wage_salary_other
tab secwage_payment_period
*I honestly don't think we can value secondary wage employment.
collapse (sum) annual_salary, by (y4_hhid)
lab var annual_salary "Estimated annual earnings from non-agricultural wage employment over previous 12 months"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_wage_income.dta", replace

*TASCO codes: 921 is an agricultural laborer.
*Gives slightly different response than hh_e21_2: What kind of trade or business is it connected with?


*Agwage
use "${raw_data}\Household\hh_sec_e.dta", clear
rename hh_e04ab wage_yesno
rename hh_e29 number_months
rename hh_e30 number_weeks
rename hh_e31 number_hours
rename hh_e26_1 most_recent_payment
replace most_recent_payment = . if hh_e20_2!="921"
rename hh_e26_2 payment_period
rename hh_e28_1 most_recent_payment_other
replace most_recent_payment_other = . if hh_e20_2!="921"
rename hh_e28_2 payment_period_other
rename hh_e36 secondary_wage_yesno
rename hh_e44_1 secwage_most_recent_payment
replace secwage_most_recent_payment = . if hh_e38_2!="921"
rename hh_e44_2 secwage_payment_period
rename hh_e46_1 secwage_recent_payment_other
rename hh_e46_2 secwage_payment_period_other
rename hh_e50 secwage_hours_pastweek
gen annual_salary_cash = most_recent_payment if payment_period==8
replace annual_salary_cash = ((number_months/6)*most_recent_payment) if payment_period==7
replace annual_salary_cash = ((number_months/4)*most_recent_payment) if payment_period==6
replace annual_salary_cash = (number_months*most_recent_payment) if payment_period==5
replace annual_salary_cash = (number_months*(number_weeks/2)*most_recent_payment) if payment_period==4
replace annual_salary_cash = (number_months*number_weeks*most_recent_payment) if payment_period==3
replace annual_salary_cash = (number_months*number_weeks*(number_hours/8)*most_recent_payment) if payment_period==2
replace annual_salary_cash = (number_months*number_weeks*number_hours*most_recent_payment) if payment_period==1
gen wage_salary_other = most_recent_payment_other if payment_period_other==8
replace wage_salary_other = ((number_months/6)*most_recent_payment_other) if payment_period_other==7
replace wage_salary_other = ((number_months/4)*most_recent_payment_other) if payment_period_other==6
replace wage_salary_other = (number_months*most_recent_payment_other) if payment_period_other==5
replace wage_salary_other = (number_months*(number_weeks/2)*most_recent_payment_other) if payment_period_other==4
replace wage_salary_other = (number_months*number_weeks*most_recent_payment_other) if payment_period_other==3
replace wage_salary_other = (number_months*number_weeks*(number_hours/8)*most_recent_payment_other) if payment_period_other==2
replace wage_salary_other = (number_months*number_weeks*number_hours*most_recent_payment_other) if payment_period_other==1
recode annual_salary_cash wage_salary_other (.=0)
gen annual_salary = annual_salary_cash + wage_salary_other
collapse (sum) annual_salary, by (y4_hhid)
rename annual_salary annual_salary_agwage
lab var annual_salary_agwage "Estimated annual earnings from agricultural wage employment over previous 12 months"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_agwage_income.dta", replace


************
*OTHER INCOME
************

use "${raw_data}\Household\hh_sec_q1.dta", clear
append using "${raw_data}\Household\hh_sec_q2.dta"
append using "${raw_data}\Household\hh_sec_o1.dta"
rename hh_q06 rental_income
rename hh_q07 pension_income
rename hh_q08 other_income
rename hh_q23 cash_received
rename hh_q26 inkind_gifts_received
rename hh_o03 assistance_cash
rename hh_o04 assistance_food
rename hh_o05 assistance_inkind
recode rental_income pension_income other_income cash_received inkind_gifts_received assistance_cash assistance_food assistance_inkind (.=0)
gen remittance_income = cash_received + inkind_gifts_received
gen assistance_income = assistance_cash + assistance_food + assistance_inkind
collapse (sum) rental_income pension_income other_income remittance_income assistance_income, by (y4_hhid)
lab var rental_income "Estimated income from rentals of buildings, tools, land, transport animals over previous 12 months"
lab var pension_income "Estimated income from a pension AND INTEREST over previous 12 months"
lab var other_income "Estimated income from any OTHER source over previous 12 months"
lab var remittance_income "Estimated income from remittances over previous 12 months"
lab var assistance_income "Estimated income from a food aid, food-for-work, etc. over previous 12 months"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_other_income.dta", replace

use "${raw_data}\Agriculture\ag_sec_3a.dta", clear
rename ag3a_04 land_rental_income_mainseason
append using "${raw_data}\Agriculture\ag_sec_3b.dta"
rename ag3b_04 land_rental_income_shortseason
recode land_rental_income_mainseason land_rental_income_shortseason (.=0)
gen land_rental_income = land_rental_income_mainseason + land_rental_income_shortseason
collapse (sum) land_rental_income, by (y4_hhid)
lab var land_rental_income "Estimated income from renting out land over previous 12 months"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_land_rental_income.dta", replace

 

************
*FARM SIZE / LAND SIZE
************

use "${raw_data}\Agriculture\ag_sec_3a.dta", clear
append using "${raw_data}\Agriculture\ag_sec_3b.dta"
gen cultivated = (ag3a_03==1 | ag3b_03==1)
rename plotnum plot_id
collapse (max) cultivated, by (y4_hhid plot_id)
lab var cultivated "1= Parcel was cultivated in this data set"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_parcels_cultivated.dta", replace

use "${created_data}\Tanzania_NPS_LSMS_ISA_W4_parcels_cultivated.dta", clear
merge 1:1 y4_hhid plot_id using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_plot_areas.dta"
drop if _merge==2
replace area_acres_meas=. if area_acres_meas<0 // Some GPS measures are zero
replace area_acres_meas = area_acres_est if area_acres_meas==. // For now, just take the measures when available. This is not satisfactory.
collapse (sum) area_acres_meas, by (y4_hhid)
rename area_acres_meas farm_area
replace farm_area = farm_area * (1/2.47105) /* Convert to hectares */
lab var farm_area "Land size (denominator for land productivitiy), in hectares" // Uses measures
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_land_size.dta", replace
*3,352 households (including non-farmers)

*For Tanzania, we don't have per-unit median area measures to use in imputing missing GPS observations.

*All agricultural land
use "${raw_data}\Agriculture\ag_sec_3a.dta", clear
append using "${raw_data}\Agriculture\ag_sec_3b.dta"
rename plotnum plot_id
drop if plot_id==""
gen rented_out = (ag3a_03==2 | ag3a_03==3 | ag3b_03==2 | ag3b_03==3)
gen cultivated_short = (ag3b_03==1)
bys y4_hhid plot_id: egen plot_cult_short = max(cultivated_short)
replace rented_out = 0 if plot_cult_short==1 // If cultivated in short season, not considered rented out in long season.
drop if rented_out==1
gen agland = (ag3a_03==1 | ag3a_03==4 | ag3b_03==1 | ag3b_03==4) // All cultivated AND fallow plots, pasture is captured within "other" (can't be separated out)
keep if agland==1 
collapse (max) agland, by (y4_hhid plot_id)
lab var agland "1= Parcel was used for crop cultivation or left fallow in this past year (forestland and other uses excluded)"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_parcels_agland.dta", replace

use "${created_data}\Tanzania_NPS_LSMS_ISA_W4_parcels_agland.dta", clear
merge 1:1 y4_hhid plot_id using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_plot_areas.dta"
drop if _merge==2
replace area_acres_meas=. if area_acres_meas<0
replace area_acres_meas = area_acres_est if area_acres_meas==. // For now, just take the measures when available. This is not satisfactory.
collapse (sum) area_acres_meas, by (y4_hhid)
rename area_acres_meas farm_size_agland
replace farm_size_agland = farm_size_agland * (1/2.47105) /* Convert to hectares */
lab var farm_size_agland "Land size in hectares, including all plots cultivated or left fallow" // Uses measures
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_farmsize_all_agland.dta", replace

use "${raw_data}\Agriculture\ag_sec_3a.dta", clear
append using "${raw_data}\Agriculture\ag_sec_3b.dta"
rename plotnum plot_id
drop if plot_id==""
gen rented_out = (ag3a_03==2 | ag3a_03==3 | ag3b_03==2 | ag3b_03==3)
gen cultivated_short = (ag3b_03==1)
bys y4_hhid plot_id: egen plot_cult_short = max(cultivated_short)
replace rented_out = 0 if plot_cult_short==1 // If cultivated in short season, not considered rented out in long season.
drop if rented_out==1
gen plot_held = 1
collapse (max) plot_held, by (y4_hhid plot_id)
lab var plot_held "1= Parcel was NOT rented out in the main season"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_parcels_held.dta", replace

use "${created_data}\Tanzania_NPS_LSMS_ISA_W4_parcels_held.dta", clear
merge 1:1 y4_hhid plot_id using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_plot_areas.dta"
drop if _merge==2
replace area_acres_meas=. if area_acres_meas<0
replace area_acres_meas = area_acres_est if area_acres_meas==. // For now, just take the measures when available. This is not satisfactory.
collapse (sum) area_acres_meas, by (y4_hhid)
rename area_acres_meas land_size
replace land_size = land_size * (1/2.47105) /* Convert to hectares */
lab var land_size "Land size in hectares, including all plots listed by the household" // Uses measures
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_land_size_all.dta", replace



************
*FARM LABOR
************

*Farm labor
use "${raw_data}\Agriculture\ag_sec_3a.dta", clear
rename ag3a_74_1 landprep_women 
rename ag3a_74_2 landprep_men 
rename ag3a_74_3 landprep_child 
rename ag3a_74_5 weeding_men 
rename ag3a_74_6 weeding_women 
rename ag3a_74_7 weeding_child 
rename ag3a_74_13 harvest_men 
rename ag3a_74_14 harvest_women 
rename ag3a_74_15 harvest_child
recode landprep_women landprep_men landprep_child weeding_men weeding_women weeding_child harvest_men harvest_women harvest_child (.=0)
egen days_hired_mainseason = rowtotal(landprep_women landprep_men landprep_child weeding_men weeding_women weeding_child harvest_men harvest_women harvest_child) 
recode ag3a_72_1 ag3a_72_2 ag3a_72_3 ag3a_72_4 ag3a_72_5 ag3a_72_6 (.=0)
egen days_flab_landprep = rowtotal(ag3a_72_1 ag3a_72_2 ag3a_72_3 ag3a_72_4 ag3a_72_5 ag3a_72_6)
recode ag3a_72_7 ag3a_72_8 ag3a_72_9 ag3a_72_10 ag3a_72_11 ag3a_72_12 (.=0)
egen days_flab_weeding = rowtotal(ag3a_72_7 ag3a_72_8 ag3a_72_9 ag3a_72_10 ag3a_72_11 ag3a_72_12)
recode ag3a_72_13 ag3a_72_14 ag3a_72_15 ag3a_72_16 ag3a_72_17 ag3a_72_18 (.=0)
egen days_flab_harvest = rowtotal(ag3a_72_13 ag3a_72_14 ag3a_72_15 ag3a_72_16 ag3a_72_17 ag3a_72_18)
gen days_famlabor_mainseason = days_flab_landprep + days_flab_weeding + days_flab_harvest
collapse (sum) days_hired_mainseason days_famlabor_mainseason, by (y4_hhid)
lab var days_hired_mainseason  "Workdays for hired labor (crops) in main growing season"
lab var days_famlabor_mainseason  "Workdays for family labor (crops) in main growing season"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_farmlabor_mainseason.dta", replace

use "${raw_data}\Agriculture\ag_sec_3b.dta", clear
rename ag3b_74_1 landprep_women 
rename ag3b_74_2 landprep_men 
rename ag3b_74_3 landprep_child 
rename ag3b_74_5 weeding_men 
rename ag3b_74_6 weeding_women 
rename ag3b_74_7 weeding_child 
rename ag3b_74_13 harvest_men 
rename ag3b_74_14 harvest_women 
rename ag3b_74_15 harvest_child
recode landprep_women landprep_men landprep_child weeding_men weeding_women weeding_child harvest_men harvest_women harvest_child (.=0)
egen days_hired_shortseason = rowtotal(landprep_women landprep_men landprep_child weeding_men weeding_women weeding_child harvest_men harvest_women harvest_child) 
recode ag3b_72_1 ag3b_72_2 ag3b_72_3 ag3b_72_4 ag3b_72_5 ag3b_72_6 (.=0)
egen days_flab_landprep = rowtotal(ag3b_72_1 ag3b_72_2 ag3b_72_3 ag3b_72_4 ag3b_72_5 ag3b_72_6)
recode ag3b_72_7 ag3b_72_8 ag3b_72_9 ag3b_72_10 ag3b_72_11 ag3b_72_12 (.=0)
egen days_flab_weeding = rowtotal(ag3b_72_7 ag3b_72_8 ag3b_72_9 ag3b_72_10 ag3b_72_11 ag3b_72_12)
recode ag3b_72_13 ag3b_72_14 ag3b_72_15 ag3b_72_16 ag3b_72_17 ag3b_72_18 (.=0)
egen days_flab_harvest = rowtotal(ag3b_72_13 ag3b_72_14 ag3b_72_15 ag3b_72_16 ag3b_72_17 ag3b_72_18)
gen days_famlabor_shortseason = days_flab_landprep + days_flab_weeding + days_flab_harvest
collapse (sum) days_hired_shortseason days_famlabor_shortseason, by (y4_hhid)
lab var days_hired_shortseason  "Workdays for hired labor (crops) in short growing season"
lab var days_famlabor_shortseason  "Workdays for family labor (crops) in short growing season"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_farmlabor_shortseason.dta", replace

*Labor
use "${created_data}\Tanzania_NPS_LSMS_ISA_W4_farmlabor_mainseason.dta", clear
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_farmlabor_shortseason.dta"
drop _merge
recode days*  (.=0)
collapse (sum) days*, by(y4_hhid)
egen labor_hired =rowtotal(days_hired_mainseason days_hired_shortseason)
egen labor_family=rowtotal(days_hired_mainseason  days_famlabor_shortseason)
egen labor_total = rowtotal(days_hired_mainseason days_famlabor_mainseason days_hired_shortseason days_famlabor_shortseason)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm in the past year"
lab var labor_hired "Total labor days (hired) allocated to the farm in the past year"
lab var labor_family "Total labor days (family) allocated to the farm in the past year"
lab var labor_total "Total labor days (hired +family) allocated to the farm in the past year"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_family_hired_labor.dta", replace
 
 
***************
*VACCINE USAGE
***************
use "${raw_data}\Livestock and Fisheries/lf_sec_03.dta", clear
gen vac_animal=.
replace vac_animal=1 if lf03_03==1 | lf03_03==2
replace vac_animal=0 if lf03_03==3
replace vac_animal=. if lf03_03==.
collapse (max) vac_animal, by (y4_hhid)
lab var vac_animal "1= Household has an animal vaccinated"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_vaccine.dta", replace
 
 
***************
*USE OF INORGANIC FERTILIZER
***************
use "${raw_data}/Agriculture/ag_sec_3a.dta", clear
append using "${raw_data}/Agriculture/ag_sec_3b.dta" 
gen use_inorg_fert=.
replace use_inorg_fert=1 if ag3a_47==1 | ag3a_47==1 | ag3b_47==1 | ag3b_47==1  //DYA: ADDING SHORT RAINY SEASON
replace use_inorg_fert=0 if ag3a_47==2 & ag3a_47==2 | ag3b_47==2 & ag3b_47==2
recode use_inorg_fert (.=0)
collapse (max) use_inorg_fert, by (y4_hhid)
lab var use_inorg_fert "1 = Household uses inorganic fertilizer"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_fert_use.dta", replace
  
 
*********************
*USE OF IMPROVED SEED
*********************
use "${raw_data}/Agriculture/ag_sec_4a.dta", clear 
append using "${raw_data}/Agriculture/ag_sec_4b.dta" 
gen imprv_seed_new=.
replace imprv_seed_new=1 if ag4a_08==1 | ag4a_08==3 | ag4b_08==1 | ag4b_08==3 
replace imprv_seed_new=0 if ag4a_08==2 | ag4a_08==4 | ag4b_08==2 | ag4b_08==4 

gen imprv_seed_old=.
replace imprv_seed_old=1 if ag4a_10b==1 | ag4a_10b==3 | ag4b_10b==1 | ag4a_10b==3
replace imprv_seed_old=0 if ag4a_10b==2 | ag4a_10b==4 | ag4b_10b==2 | ag4b_10b==4
replace imprv_seed_old=. if ag4a_10b==. | ag4b_10b==. 
gen imprv_seed_use=.
replace imprv_seed_use=1 if imprv_seed_new==1 | imprv_seed_old==1
replace imprv_seed_use=0 if imprv_seed_new==0 & imprv_seed_old==0 
recode imprv_seed_use (.=0)
collapse (max) imprv_seed_use, by (y4_hhid)
lab var imprv_seed_use "1 = Household uses improved seed"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_improvedseed_use.dta", replace
   

*********************
*REACHED BY AG EXTENSION
*********************
use "${raw_data}/Agriculture/ag_sec_12b.dta", clear
**Government Extension
gen advice_gov = .
replace advice_gov = 1 if sourceid==1 & ag12b_08==1 
replace advice_gov = 0 if sourceid==1 & ag12b_08==2
**NGO
gen advice_ngo = .
replace advice_ngo = 1 if sourceid==2 & ag12b_08==1
replace advice_ngo = 0 if sourceid==2 & ag12b_08==2
**Cooperative/ Farmer Association
gen advice_coop = .
replace advice_coop = 1 if sourceid==3 & ag12b_08==1
replace advice_coop = 0 if sourceid==3 & ag12b_08==2
**Large Scale Farmer
gen advice_farmer = .
replace advice_farmer = 1 if sourceid==4 & ag12b_08==1
replace advice_farmer = 0 if sourceid==4 & ag12b_08==2
**Radio
gen advice_radio = .
replace advice_radio = 1 if sourceid==5 & ag12b_08==1
replace advice_radio = 0 if sourceid==5 & ag12b_08==2
**Publication
gen advice_pub = .
replace advice_pub = 1 if sourceid==6 & ag12b_08==1
replace advice_pub = 0 if sourceid==6 & ag12b_08==2
**Neighbor
gen advice_neigh = .
replace advice_neigh = 1 if sourceid==7 & ag12b_08==1
replace advice_neigh = 0 if sourceid==7 & ag12b_08==2
**Other
gen advice_other = .
replace advice_other = 1 if sourceid==8 & ag12b_08==1
replace advice_other = 0 if sourceid==8 & ag12b_08==2
**advice on prices from extension
gen advice_prices_ext=.
replace advice_prices_ext=1 if advice_gov==1 | advice_ngo==1 | advice_coop==1 | advice_radio==1  | advice_pub==1
replace advice_prices_ext=0 if advice_gov==0 | advice_ngo==0 | advice_coop==0 | advice_farmer==1 | advice_farmer==0  | advice_neigh==1 | advice_neigh==0 | advice_other==1 | advice_other==0
collapse (max) advice_prices_ext, by (y4_hhid)
tempfile TZ_price_ext
save `TZ_price_ext'
*Gen Variables For Advice on variety of topics: 
use "${raw_data}/Agriculture/ag_sec_12a.dta", clear
**Government Extension
gen advice_gov = .
replace advice_gov = 1 if sourceid==1 & ag12a_02==2
**NGO
gen advice_ngo = .
replace advice_ngo = 1 if sourceid==2 & ag12a_02==1
replace advice_ngo = 0 if sourceid==2 & ag12a_02==2
**Cooperative/ Farmer Association
gen advice_coop = .
replace advice_coop = 1 if sourceid==3 & ag12a_02==1
replace advice_coop = 0 if sourceid==3 & ag12a_02==2
**Large Scale Farmer
gen advice_farmer = .
replace advice_farmer = 1 if sourceid==4 & ag12a_02==1
replace advice_farmer = 0 if sourceid==4 & ag12a_02==2
**Other
gen advice_other = .
replace advice_other = 1 if sourceid==5 & ag12a_02==1
replace advice_other = 0 if sourceid==5& ag12a_02==2
**advice on prices from extension
gen advice_many_ext=.
replace advice_many_ext=1 if advice_gov==1 | advice_ngo==1 | advice_coop==1
replace advice_many_ext=0 if advice_gov==0 | advice_ngo==0 | advice_coop==0 | advice_farmer==1 | advice_farmer==0 | advice_other==1 | advice_other==0
collapse (max) advice_many_ext, by (y4_hhid)
merge 1:1 y4_hhid using `TZ_price_ext', nogen
**reached by extension
gen ext_reach=.
replace ext_reach=1 if advice_prices_ext==1 | advice_many_ext==1
replace ext_reach=0 if advice_prices_ext==0 & advice_many_ext==0
drop advice_many_ext advice_prices_ext
lab var ext_reach "1 = Household reached by extensition services"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_any_ext.dta", replace
 
 
*********************
*USE OF FORMAL FINANACIAL SERVICES
*********************
use "${raw_data}/Household/hh_sec_p.dta", clear
append using "${raw_data}/Household/hh_sec_q1.dta" 
gen borrow_bank=.
replace borrow_bank=1 if hh_p03==1
replace borrow_bank=0 if hh_p03==.
gen borrow_micro=.
replace borrow_micro=1 if hh_p03==2
replace borrow_micro=0 if hh_p03==.
gen borrow_mortgage=.
replace borrow_mortgage=1 if hh_p03==3
replace borrow_mortgage=0 if hh_p03==.
gen borrow_insurance=.
replace borrow_insurance=1 if hh_p03==4
replace borrow_insurance=0 if hh_p03==.
gen borrow_other_fin=.
replace borrow_other_fin=1 if hh_p03==5
replace borrow_other_fin=0 if hh_p03==.
gen borrow_neigh=.
replace borrow_neigh=1 if hh_p03==6
replace borrow_neigh=0 if hh_p03==.
gen borrow_merch=.
replace borrow_merch=1 if hh_p03==7
replace borrow_merch=0 if hh_p03==.
gen borrow_lender=.
replace borrow_lender=1 if hh_p03==8
replace borrow_lender=0 if hh_p03==.
gen borrow_employer=.
replace borrow_employer=1 if hh_p03==9
replace borrow_employer=0 if hh_p03==.
gen borrow_relig=.
replace borrow_relig=1 if hh_p03==10
replace borrow_relig=0 if hh_p03==.
gen borrow_ngo=.
replace borrow_ngo=1 if hh_p03==11
replace borrow_ngo=0 if hh_p03==.
gen borrow_group=.
replace borrow_group=1 if hh_p03==12
replace borrow_group=0 if hh_p03==.
gen borrow_other=.
replace borrow_other=1 if hh_p03==13
replace borrow_other=0 if hh_p03==.
gen use_fin_serv=.
replace use_fin_serv=1 if  borrow_bank==1 |  borrow_micro==1 | borrow_mortgage==1 |  borrow_insurance==1 | borrow_other_fin==1 | hh_q01_1==1 | hh_q01_2==1 | hh_q01_3==1 | hh_q01_4==1 | hh_q10==1
replace use_fin_serv=0 if hh_p03==. & hh_q10==2 & hh_q01_1==2 & hh_q01_2==2 & hh_q01_3==2 & hh_q01_4==2 &  borrow_neigh>=0 &  borrow_merch>=0 & borrow_lender>=0 &  borrow_employer>=0 &  borrow_relig>=0 & borrow_ngo>=0 &  borrow_group>=0 &  borrow_other>=0
replace use_fin_serv=. if hh_q01_1==. & hh_q01_2==. & hh_q01_3==. & hh_q01_4==. & hh_q10==.
collapse (max) use_fin_serv, by (y4_hhid)
lab var use_fin_serv "1= Household uses formal financial services"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_fin_serv.dta", replace
 

************************
*GENDER PRODUCTIVITY GAP (PLOT LEVEL)
************************
use "${created_data}\Tanzania_NPS_LSMS_ISA_W4_plot_cropvalue.dta", clear
merge 1:1 y4_hhid plot_id using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_plot_areas.dta", keep (1 3) nogen
merge 1:1 y4_hhid plot_id  using  "${created_data}\Tanzania_NPS_LSMS_ISA_W4_plot_decision_makers.dta", keep (1 3) nogen
merge m:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hhids.dta", keep (1 3) nogen
replace  area_meas_hectares =area_est_hectares if area_meas_hectares==. & area_est_hectares!=.
gen plot_weight=area_meas_hectares*weight
lab var plot_weight "Weight for plots (weighted by plot area)"
drop if area_meas_hectares==.
*Winsorize
global winsorize_vars area_meas_hectares plot_value_harvest
foreach p of global winsorize_vars {
_pctile `p'   [aw=plot_weight] , p(1 99)   // It's not clear whether plot_weight should be used here.
replace `p' = r(r1) if `p' < r(r1)  & `p'!=.
replace `p' = r(r2) if `p' > r(r2)  & `p'!=.
}
global exchange_rate 2158
global ppp_dollar 691.41
global inflation 0.04933815  // inflation rate 2015-2016. Data was collectedduring oct2014-2015. We want to ajhust value to 2016
gen plot_value_harvest_usd=plot_value_harvest / ($exchange_rate/(1+$inflation))
gen plot_productivity_usd = plot_value_harvest_usd / area_meas_hectares
lab var plot_productivity_usd "Value of crop production per hectare (plot-level) (PPP $/ha))"
lab var plot_value_harvest_usd "Value of crop production (plot-level) (2016 $USD /ha))"

gen plot_value_harvest_ppp=plot_value_harvest /  ($ppp_dollar/(1+$inflation))  
gen plot_productivity_ppp = plot_value_harvest_ppp / area_meas_hectares
lab var plot_productivity_ppp "Value of crop production per hectare (plot-level) (PPP $/ha))"
lab var plot_value_harvest_ppp "Value of crop production (plot-level) (2016 $USD))"
drop   cultivated

tabstat plot_productivity_usd  [aw=plot_weight]  if dm_gender!=. & rural==1, stat(mean sd p50   min max N) col(stat) save
gen plot_productivity_all_usd=el(r(StatTotal),1,1)
tabstat plot_productivity_usd  [aw=plot_weight]   if dm_gender==1 & rural==1, stat(mean sd p50   min max N) col(stat) save
gen plot_productivity_male_usd=el(r(StatTotal),1,1)
tabstat plot_productivity_usd  [aw=plot_weight]   if dm_gender==2  & rural==1, stat(mean sd p50   min max N) col(stat) save 
gen plot_productivity_female_usd=el(r(StatTotal),1,1)
tabstat plot_productivity_usd  [aw=plot_weight]   if dm_gender==3 & rural==1, stat(mean sd p50   min max N) col(stat) save   
gen plot_productivity_mixed_usd=el(r(StatTotal),1,1) if  dm_gender!=. & rural==1
gen gender_prod_gap1=100*(plot_productivity_male-plot_productivity_female)/plot_productivity_male
sum gender_prod_gap1
lab var gender_prod_gap "Gender productivity gap (%)"
save "${final_data}\Tanzania_NPS_LSMS_ISA_W4_gender_productivity_gap.dta", replace
  
  
************
*MILK PRODUCTIVITY
************
*Total production
use "${raw_data}/Livestock and Fisheries/lf_sec_06.dta", clear
gen ruminants_large = lvstckcat==1
keep if ruminants_large
gen milk_animals = lf06_01			// number of livestock milked (by holder)
gen months_milked = lf06_02			// average months milked in last year (by holder)
gen liters_day = lf06_03			// average quantity (liters) per day (questionnaire sounds like this question is TOTAL, not per head)
gen liters_per_largeruminant = (liters_day*365*(months_milked/12))	// liters per day times 365 (for yearly total) to get TOTAL AVERAGE across all animals times months milked over 12 to scale down to actual amount
keep if milk_animals!=0 & milk_animals!=.
drop if liters_per_largeruminant==.
keep y4_hhid   milk_animals months_milked liters_per_largeruminant 
lab var milk_animals "Number of large ruminants that was milke (household)"
lab var months_milked "Average months milked in last year (household)"
lab var liters_per_largeruminant "average quantity (liters) per day (household)"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_milk_animals.dta", replace


************
*EGG PRODUCTIVITY
************
*Have to get total owned poultry and then number of eggs
use "${raw_data}/Livestock and Fisheries/lf_sec_02.dta", clear
egen poultry_owned = rowtotal(lf02_04_1 lf02_04_2) if inlist(lvstckid,10,11,12)
*Summing total eggs and number of hens to household (instead of holder)
collapse (sum) poultry_owned, by(y4_hhid)
tempfile eggs_animals_hh 
save `eggs_animals_hh'
*Number of eggs
use "${raw_data}/Livestock and Fisheries/lf_sec_08.dta", clear
keep if productid==1			// keeping eggs only
gen eggs_months = lf08_02		// number of months eggs were produced
gen eggs_per_month = lf08_03_1 if lf08_03_2==3			// eggs per month - "pieces" (how do we convert kgs and liters?)
gen eggs_total_year = eggs_month*eggs_per_month			// eggs per month times number of months produced in last 12 months
merge 1:1 y4_hhid using  `eggs_animals_hh', nogen keep(1 3)		// all matched from master; dropping not matched from using

gen egg_poultry_year = eggs_total_year/poultry_owned		
keep y4_hhid eggs_months eggs_per_month eggs_total_year poultry_owned egg_poultry_year
lab var eggs_months "Number of months eggs were produced (household)"
lab var eggs_per_month "Number of months eggs that were produced per month (household)"
lab var eggs_total_year "Total number of eggs that was produced (household)"
lab var poultry_owned "Total number of poulty owned (household)"
lab var egg_poultry_year "Egg productivtiy per poultry owned per year"
save "${created_data}\Tanzania_NPS_LSMS_ISA_W4_eggs_animals.dta", replace


************
*CROP PRODUCTION COSTS PER HECTARE
************
*Constructed using both implicit and explicit costs and only main rainy season (meher)
*NOTE: There's some overlap with crop production expenses above, but this is because the variables were created separately.


 
*Land rental rates*
*********
*  LRS  *
*********
use "${raw_data}/Agriculture/ag_sec_2a.dta", clear
drop if plotnum==""
gen plot_ha = ag2a_09/2.47105							// ag2a_09 is GPS-measured area in acres
replace plot_ha = ag2a_04/2.47105 if plot_ha==.			// replace with farmer-reported if missing (also in acres)
keep plot_ha plotnum y4_hhid
ren plotnum plot_id
lab var plot_ha "Plot area in hectare" 
save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_plot_area_lrs.dta", replace
*Getting plot rental rate
use "${raw_data}/Agriculture/ag_sec_3a.dta", clear
ren plotnum plot_id
merge 1:1 plot_id y4_hhid using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_plot_area_lrs.dta" , nogen		// all matched
drop if plot_id==""
gen cultivated = ag3a_03==1
merge m:1 y4_hhid plot_id using  "${created_data}\Tanzania_NPS_LSMS_ISA_W4_plot_decision_makers.dta", nogen keep (1 3)
*Total rent - rescaling to a YEARLY value
*NOTE: Although this is yearly, we shouldn't be double counting plots. We merge LRS into SRS first, then only match SRS to SRS if missing.
tab ag3a_34_1 ag3a_34_2, nol
gen plot_rental_rate = ag3a_33*(12/ag3a_34_1) if ag3a_34_2==1			// if monthly (scaling up by number of months; all observations are <=12)
replace plot_rental_rate = ag3a_33*(1/ag3a_34_1) if ag3a_34_2==2		// if yearly (scaling down by number of years; all observations are >=1)
*keep y4_hhid plot_id plotname cultivated dm_gender plot_ha plot_rental_rate
save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_rent_nomiss_lrs.dta", replace					// NOTE: gender variables are here

preserve
	gen value_rented_land_male = plot_rental_rate if dm_gender==1
	gen value_rented_land_female = plot_rental_rate if dm_gender==2
	gen value_rented_land_mixed = plot_rental_rate if dm_gender==3
	collapse (sum) value_rented_land_* value_rented_land = plot_rental_rate, by(y4_hhid)
	lab var value_rented_land_male "Value of rented land (male-managed plot)
	lab var value_rented_land_female "Value of rented land (female-managed plot)
	lab var value_rented_land_mixed "Value of rented land (mixed-managed plot)
	save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_rental_rate_lrs.dta", replace
restore

gen ha_rental_rate_hh = plot_rental_rate/plot_ha
preserve
	keep if plot_rental_rate!=. & plot_rental_rate!=0			// keeping only plots that were rented (not zero and not missing)
	collapse (sum) plot_rental_rate plot_ha, by(y4_hhid)		// summing to household level (only plots that were rented)
	gen ha_rental_hh_lrs = plot_rental_rate/plot_ha				// household specific rental rate
	keep ha_rental_hh_lrs y4_hhid
	lab var ha_rental_hh_lrs "Area of rented plot during the long run season"
	save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_rental_rate_hhid_lrs.dta", replace
restore

*Merging in geographic variables
merge m:1 y4_hhid using "${raw_data}/Household/hh_sec_a.dta", nogen assert(2 3) keep(3)		// some not matched from USING; dropping these
*Geographic medians
bys hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a: egen ha_rental_count_vil = count(ha_rental_rate_hh)
bys hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a: egen ha_rental_rate_vil = median(ha_rental_rate_hh)
bys hh_a01_1 hh_a02_1 hh_a03_1: egen ha_rental_count_ward = count(ha_rental_rate_hh)
bys hh_a01_1 hh_a02_1 hh_a03_1: egen ha_rental_rate_ward = median(ha_rental_rate_hh)
bys hh_a01_1 hh_a02_1: egen ha_rental_count_dist = count(ha_rental_rate_hh)
bys hh_a01_1 hh_a02_1: egen ha_rental_rate_dist = median(ha_rental_rate_hh)
bys hh_a01_1: egen ha_rental_count_reg = count(ha_rental_rate_hh)
bys hh_a01_1: egen ha_rental_rate_reg = median(ha_rental_rate_hh)
egen ha_rental_rate_nat = median(ha_rental_rate_hh)
*Now, getting median rental rate at the lowest level of aggregation with at least ten observations
gen ha_rental_rate = ha_rental_rate_vil if ha_rental_count_vil>=10		// only 17 non-missing observations (single village)
replace ha_rental_rate = ha_rental_rate_ward if ha_rental_count_ward>=10 & ha_rental_rate==.	// 0 changes
replace ha_rental_rate = ha_rental_rate_dist if ha_rental_count_dist>=10 & ha_rental_rate==.	// 451 changes
replace ha_rental_rate = ha_rental_rate_reg if ha_rental_count_reg>=10 & ha_rental_rate==.		// 2493 changes - majority of households
replace ha_rental_rate = ha_rental_rate_nat if ha_rental_rate==.				// 1314 changes
collapse (firstnm) ha_rental_rate, by(hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a)
lab var ha_rental_rate "Land rental rate per ha"
save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_rental_rate_lrs.dta", replace

*  SRS  *
use "${raw_data}/Agriculture/ag_sec_2b.dta", clear
drop if plotnum==""
gen plot_ha = ag2b_20/2.47105						// ag2a_09 is GPS-measured area in acres
replace plot_ha = ag2b_15/2.47105 if plot_ha==.		// replacing with farmer-reported if missing
keep plot_ha plotnum y4_hhid
ren plotnum plot_id
save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_plot_area_srs.dta", replace
*Getting plot rental rate
use "${raw_data}/Agriculture/ag_sec_3b.dta", clear
drop if plotnum==""
gen cultivated = ag3b_03==1
ren  plotnum plot_id
merge m:1 y4_hhid plot_id using  "${created_data}\Tanzania_NPS_LSMS_ISA_W4_plot_decision_makers.dta", nogen 
merge 1:1 plot_id y4_hhid using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_plot_area_lrs.dta", nogen					// 16 not matched (new SRS plots)
merge 1:1 plot_id y4_hhid using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_plot_area_srs.dta", nogen update replace		// only 16 matched (new SRS plots) - plot_ha updated with non-missing values from SRS
*Total rent - rescaling to a YEARLY value
tab ag3b_34_1 ag3b_34_2, nol					// Questions ONLY for new plots
gen plot_rental_rate = ag3b_33*(12/ag3b_34_1) if ag3b_34_2==1			// if monthly (scaling up by number of months)
replace plot_rental_rate = ag3b_33*(1/ag3b_34_1) if ag3b_34_2==2		// if yearly (scaling down by number of years)
*gen cultivated = ag3b_03==1
save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_rent_nomiss_srs.dta", replace
preserve
	gen value_rented_land_male = plot_rental_rate if dm_gender==1
	gen value_rented_land_female = plot_rental_rate if dm_gender==2
	gen value_rented_land_mixed = plot_rental_rate if dm_gender==3
	lab var value_rented_land_male "Value of rented land (male-managed plot)
	lab var value_rented_land_female "Value of rented land (female-managed plot)
	lab var value_rented_land_mixed "Value of rented land (mixed-managed plot)	
	collapse (sum) value_rented_land_* value_rented_land = plot_rental_rate, by(y4_hhid)
	save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_rental_rate_srs.dta", replace
restore
gen ha_rental_rate_hh = plot_rental_rate/plot_ha
preserve
	keep if plot_rental_rate!=. & plot_rental_rate!=0			// keeping only plots that were rented (not zero and not missing)
	collapse (sum) plot_rental_rate plot_ha, by(y4_hhid)		// summing to household level (only plots that were rented)
	gen ha_rental_hh_srs = plot_rental_rate/plot_ha				// household specific rental rate
	keep ha_rental_hh_srs y4_hhid
	lab var ha_rental_hh_srs "Area of rented plot during the short run season"
	save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_rental_rate_hhid_srs.dta", replace
restore
*Merging in geographic variables
merge m:1 y4_hhid using "${raw_data}/Household/hh_sec_a.dta", nogen assert(2 3) keep(3)		// some not matched from USING
*Geographic medians
bys hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a: egen ha_rental_count_vil = count(ha_rental_rate_hh)
bys hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a: egen ha_rental_rate_vil = median(ha_rental_rate_hh)
bys hh_a01_1 hh_a02_1 hh_a03_1: egen ha_rental_count_ward = count(ha_rental_rate_hh)
bys hh_a01_1 hh_a02_1 hh_a03_1: egen ha_rental_rate_ward = median(ha_rental_rate_hh)
bys hh_a01_1 hh_a02_1: egen ha_rental_count_dist = count(ha_rental_rate_hh)
bys hh_a01_1 hh_a02_1: egen ha_rental_rate_dist = median(ha_rental_rate_hh)
bys hh_a01_1: egen ha_rental_count_reg = count(ha_rental_rate_hh)
bys hh_a01_1: egen ha_rental_rate_reg = median(ha_rental_rate_hh)
egen ha_rental_rate_nat = median(ha_rental_rate_hh)
*Now, getting median rental rate at the lowest level of aggregation with at least ten observations
gen ha_rental_rate = ha_rental_rate_vil if ha_rental_count_vil>=10		// only 17 non-missing observations (single village)
replace ha_rental_rate = ha_rental_rate_ward if ha_rental_count_ward>=10 & ha_rental_rate==.	// 0 changes
replace ha_rental_rate = ha_rental_rate_dist if ha_rental_count_dist>=10 & ha_rental_rate==.	// 451 changes
replace ha_rental_rate = ha_rental_rate_reg if ha_rental_count_reg>=10 & ha_rental_rate==.		// 2493 changes - majority of households
replace ha_rental_rate = ha_rental_rate_nat if ha_rental_rate==.				// 1314 changes
collapse (firstnm) ha_rental_rate_srs = ha_rental_rate, by(hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a)
lab var ha_rental_rate "Land rental rate per ha in the short run season"
save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_rental_rate_srs.dta", replace


*Now getting total ha of all plots that were cultivated at least once
use "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_rent_nomiss_lrs.dta", clear
append using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_rent_nomiss_srs.dta"
collapse (max) cultivated plot_ha, by(y4_hhid plot_id)		// collapsing down to household-plot level
gen ha_cultivated_plots = plot_ha if cultivate==1			// non-missing only if plot was cultivated in at least one season
collapse (sum) ha_cultivated_plots, by(y4_hhid)				// total ha of all plots that were cultivated in at least one season
lab var ha_cultivated_plots "Area of cultivated plots (ha)"
save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_cultivated_plots_ha.dta", replace

use "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_rental_rate_lrs.dta", clear
append using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_rental_rate_srs.dta"
collapse (sum) value_rented_land*, by(y4_hhid)		// total over BOTH seasons (total spent on rent over course of entire year)
lab var value_rented_land "Value of rented land (household expenditures)"
lab var value_rented_land_male "Value of rented land (household expenditures - male-managed plots)"
lab var value_rented_land_female "Value of rented land (household expenditures - female-managed plots)"
lab var value_rented_land_mixed "Value of rented land (household expenditures - mixed-managed plots)"
save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_rental_rate.dta", replace


*Now getting area planted
*  LRS  *
use "${raw_data}/Agriculture/ag_sec_4a.dta", clear
drop if plotnum==""
ren  plotnum plot_id
merge m:1 y4_hhid plot_id using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_rent_nomiss_lrs.dta", nogen keep(1 3)
*First rescaling
gen percent_plot = 0.25*(ag4a_02==1) + 0.5*(ag4a_02==2) + 0.75*(ag4a_02==3)
replace percent_plot = 1 if ag4a_01==1
bys y4_hhid plot_id: egen total_percent_plot = total(percent_plot)		// total "percent" of plot planted
replace percent_plot = percent_plot*(1/total_percent_plot) if total_percent_plot>1 & total_percent_plot!=.	// rescaling (down) if total percent is larger than 1; 3,044 changes (55 percent of observations!)
*Merging in total plot area from previous module
merge m:1 plot_id y4_hhid using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_plot_area_lrs", nogen assert(2 3) keep(3)			// 1,096 not merged from USING
gen ha_planted = percent_plot*plot_ha
gen ha_planted_male = ha_planted if dm_gender==1
gen ha_planted_female = ha_planted if dm_gender==2
gen ha_planted_mixed = ha_planted if dm_gender==3
*Merging in geographic variables
merge m:1 y4_hhid using "${raw_data}/Household/hh_sec_a.dta", nogen assert(2 3) keep(3)			// 1,096 not merged from USING
*Now merging in aggregate rental costs
merge m:1 hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_rental_rate_lrs", nogen assert(2 3) keep(3)			// 1,096 not merged from USING
*Now merging in rental costs of individual plots
merge m:1 y4_hhid plot_id using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_rent_nomiss_lrs.dta", nogen keep(1 3)
*Now merging in household rental rate
merge m:1 y4_hhid using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_rental_rate_hhid_lrs.dta", nogen keep(1 3)
gen value_owned_land = ha_planted*ha_rental_rate if ag3a_33==0 | ag3a_33==.		// ag3a_33 is the rent variable; constructing value_owned_land only if not rented (equals zero or equals missing)
replace value_owned_land = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (ag3a_33==0 | ag3a_33==.)		// replacing with household's actual rental rate if available - still not valuing rented plots, though
*Now creating gender value
gen value_owned_land_male = ha_planted*ha_rental_rate if (ag3a_33==0 | ag3a_33==.) & dm_gender==1
replace value_owned_land_male = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (ag3a_33==0 | ag3a_33==.) & dm_gender==1
*Female
gen value_owned_land_female = ha_planted*ha_rental_rate if (ag3a_33==0 | ag3a_33==.) & dm_gender==2
replace value_owned_land_female = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (ag3a_33==0 | ag3a_33==.) & dm_gender==2
*Mixed
gen value_owned_land_mixed = ha_planted*ha_rental_rate if (ag3a_33==0 | ag3a_33==.) & dm_gender==3
replace value_owned_land_mixed = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (ag3a_33==0 | ag3a_33==.) & dm_gender==3
collapse (sum) value_owned_land* ha_planted*, by(y4_hhid plot_id)			// summing ha_planted across crops on same plot
lab var value_owned_land "Value of owned land that was cultivated (household)"
lab var value_owned_land_male "Value of owned land (male-managed)"
lab var value_owned_land_female "Value of owned land (female-managed)"
lab var value_owned_land_mixed "Value of owned land (mixed-managed)"
lab var ha_planted "Area planted (household)"
lab var ha_planted_male "Area planted (male-managed)"
lab var ha_planted_female "Area planted (female-managed)"
lab var ha_planted_mixed "Area planted (mixed-managed)"
save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_cost_land_lrs.dta", replace


*  SRS  *
*Now getting area planted
use "${raw_data}/Agriculture/ag_sec_4b.dta", clear
drop if plotnum==""
ren plotnum plot_id 
merge m:1 y4_hhid plot_id using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_rent_nomiss_lrs.dta", nogen keep(1 3) keepusing(dm_gender)
merge m:1 y4_hhid plot_id using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_rent_nomiss_srs.dta", nogen keep(1 3) keepusing(dm_gender) update
*First rescaling
gen percent_plot = 0.25*(ag4b_02==1) + 0.5*(ag4b_02==2) + 0.75*(ag4b_02==3)
replace percent_plot = 1 if ag4b_01==1
bys y4_hhid plot_id: egen total_percent_plot = total(percent_plot)
replace percent_plot = percent_plot*(1/total_percent_plot) if total_percent_plot>1 & total_percent_plot!=.	// rescaling if total percent is larger than 1
*3,044 changes (55 percent of observations)!
*Merging in total plot area
merge m:1 plot_id y4_hhid using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_plot_area_lrs", nogen keep(1 3) keepusing(plot_ha)						// 1,096 not merged from USING; 25 not matched from master
merge m:1 plot_id y4_hhid using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_plot_area_srs", nogen keepusing(plot_ha) update							// 25 not matched from LRS now matched and missing values updated
gen ha_planted = percent_plot*plot_ha
gen ha_planted_male = ha_planted if dm_gender==1
gen ha_planted_female = ha_planted if dm_gender==2
gen ha_planted_mixed = ha_planted if dm_gender==3
*Merging in geographic variables
merge m:1 y4_hhid using "${raw_data}/Household/hh_sec_a.dta", nogen assert(2 3) keep(3)			// 1,096 not merged from USING
*Now merging in rental costs
merge m:1 hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_rental_rate_lrs", nogen assert(2 3) keep(3)			// using LRS for plots
*Now merging in rental costs actually incurred by household
merge m:1 y4_hhid plot_id using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_rent_nomiss_lrs.dta", nogen keep(1 3)
*Now merging in household rental rate
merge m:1 y4_hhid using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_rental_rate_hhid_lrs.dta", nogen keep(1 3)		// using LRS again; 190 matched
merge m:1 y4_hhid using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_rental_rate_hhid_srs.dta", nogen	update			// merging SRS, too; 20 matched, but all appear to be matched from LRS, so no updating
gen value_owned_land = ha_planted*ha_rental_rate if ag3a_33==0 | ag3a_33==.		// ag3a_33 is the rent variable
replace value_owned_land = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (ag3a_33==0 | ag3a_33==.)		// replacing with household's LRS rental rate if available
*Now creating gender value
gen value_owned_land_male = ha_planted*ha_rental_rate if (ag3a_33==0 | ag3a_33==.) & dm_gender==1
replace value_owned_land_male = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (ag3a_33==0 | ag3a_33==.) & dm_gender==1
*Female
gen value_owned_land_female = ha_planted*ha_rental_rate if (ag3a_33==0 | ag3a_33==.) & dm_gender==2
replace value_owned_land_female = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (ag3a_33==0 | ag3a_33==.) & dm_gender==2
*Mixed
gen value_owned_land_mixed = ha_planted*ha_rental_rate if (ag3a_33==0 | ag3a_33==.) & dm_gender==3
replace value_owned_land_mixed = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (ag3a_33==0 | ag3a_33==.) & dm_gender==3

collapse (sum) value_owned_land* ha_planted*, by(y4_hhid plot_id)			// summing ha_planted across crops on same plot
append using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_cost_land_lrs.dta"						// appending LRS data

preserve
	*We also want to create a total area planted variable, double counting plots, for fertilizer application rate
	collapse (sum) ha_planted*, by(y4_hhid)
	save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_ha_planted_total.dta", replace
restore
collapse (max) ha_planted* value_owned_land*, by(y4_hhid plot_id)			// taking max area planted (and value owned) by plot so as to not double count plots that were planted in both seasons
collapse (sum) ha_planted* value_owned_land*, by(y4_hhid)					// now summing to household

lab var value_owned_land "Value of owned land that was cultivated (household)"
lab var value_owned_land_male "Value of owned land (male-managed plots)"
lab var value_owned_land_female "Value of owned land (female-managed plots)"
lab var value_owned_land_mixed "Value of owned land (mixed-managed plots)"
lab var ha_planted "Area planted (household)"
lab var ha_planted_male "Area planted (male-managed plots)"
lab var ha_planted_female "Area planted (female-managed plots)"
lab var ha_planted_mixed "Area planted (mixed-managed plots)"
save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_cost_land.dta", replace



*****************
*Now input costs*
*****************
*********
*  LRS  *
*********
*In section 3 are fertilizer, hired labor, and family labor
use "${raw_data}/Agriculture/ag_sec_3a.dta", clear
drop if plotnum==""			// continuing with this (all missing values)
*Merging in geographic variables first (for constructing prices)
merge m:1 y4_hhid using "${raw_data}/Household/hh_sec_a.dta", nogen assert(2 3) keep(3)			// 1,262 not merged from USING; all matched from master
*Gender variables
ren  plotnum plot_id
merge m:1 y4_hhid plot_id using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_rent_nomiss_lrs.dta", nogen keep(1 3) keepusing(dm_gender)

*Starting with fertilizer
*NOTE: Questionnaire seems to assume all inorganic fertilizer must be purchased
egen value_inorg_fert_lrs = rowtotal(ag3a_51 ag3a_58)			// inorganic fertilizer (all purchased)
egen value_herb_pest_lrs = rowtotal(ag3a_63 ag3a_65c)			// her/pesticide (all purchased)
gen value_org_purchased_lrs = ag3a_45						// PURCHASED organic fertilizer

preserve
	gen fert_org_kg = ag3a_42		// quantity of organic fertilizer (kg)
	egen fert_inorg_kg = rowtotal(ag3a_49 ag3a_56)		// quantity of inorganic fertilizer (kg)
	gen fert_inorg_kg_male = fert_inorg_kg if dm_gender==1
	gen fert_inorg_kg_female = fert_inorg_kg if dm_gender==2
	gen fert_inorg_kg_mixed = fert_inorg_kg if dm_gender==3
	collapse (sum) fert_org_kg fert_inorg_kg*, by(y4_hhid)
	lab var fert_org_kg "Organic fertilizer (kgs)"
	lab var fert_inorg_kg "Inorganic fertilizer (kgs)"	
	lab var fert_inorg_kg_male "Inorganic fertilizer (kgs) for male-managed crops"
	lab var fert_inorg_kg_female "Inorganic fertilizer (kgs) for female-managed crops"
	lab var fert_inorg_kg_mixed "Inorganic fertilizer (kgs) for mixed-managed crops"
	save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_fert_lrs.dta", replace
restore

*For organic fertilizer value, we need to construct prices (note that there are relatively few prices, so many will be at higher levels of aggregation)
recode ag3a_42 ag3a_44 (.=0)						// so I can do next line
gen org_fert_notpurchased = ag3a_42-ag3a_44			// total amount minus amount purchased
replace org_fert_notpurchased = 0 if org_fert_notpurchased<0			// 3 changes; assuming all was purchased (and purchased, not total, is the correct quantity)
gen org_fert_purchased = ag3a_44					// kg purchased
gen org_fert_price = ag3a_45/org_fert_purchased		// total paid divided by kg (so tzs per kg)

*Household-specific value
preserve
	keep if org_fert_purchased!=0 & org_fert_purchased!=.		// keeping only plots that had purchased organic fertilizer
	collapse (sum) org_fert_purchased ag3a_45, by(y4_hhid)		// total kg purchased and total paid
	gen org_fert_price_hh = ag3a_45/org_fert_purchased
	save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_org_fert_lrs.dta", replace
restore
merge m:1 y4_hhid using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_org_fert_lrs.dta", nogen

*Geographic medians
bys hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a: egen org_price_count_vil = count(org_fert_price)
bys hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a: egen org_price_vil = median(org_fert_price) 
bys hh_a01_1 hh_a02_1 hh_a03_1: egen org_price_count_ward = count(org_fert_price)
bys hh_a01_1 hh_a02_1 hh_a03_1: egen org_price_ward = median(org_fert_price) 
bys hh_a01_1 hh_a02_1: egen org_price_count_dist = count(org_fert_price)
bys hh_a01_1 hh_a02_1: egen org_price_dist = median(org_fert_price) 
bys hh_a01_1: egen org_price_count_reg = count(org_fert_price)
bys hh_a01_1: egen org_price_reg = median(org_fert_price)
egen org_price_nat = median(org_fert_price)
drop org_fert_price
gen org_fert_price = org_price_vil if org_price_count_vil>=10
replace org_fert_price = org_price_ward if org_price_count_ward>=10 & org_fert_price==.
replace org_fert_price = org_price_dist if org_price_count_dist>=10 & org_fert_price==.
replace org_fert_price = org_price_reg if org_price_count_reg>=10 & org_fert_price==.
replace org_fert_price = org_price_nat if org_fert_price==.			// ALL changes are at national level
replace org_fert_price = org_fert_price_hh if org_fert_price_hh!=. & org_fert_price_hh!=0		// replace with household-level price when available (101 changes)

gen value_org_notpurchased_lrs = org_fert_price*org_fert_notpurchased						// total value not purchased

*Hired labor
egen prep_labor = rowtotal(ag3a_74_1 ag3a_74_2 ag3a_74_3)		// we have to include male, female, and child labor together (cannot disaggregate wages)
egen weed_labor = rowtotal(ag3a_74_5 ag3a_74_6 ag3a_74_7)		// we have to include male, female, and child labor together (cannot disaggregate wages)
egen harv_labor = rowtotal(ag3a_74_13 ag3a_74_14 ag3a_74_15)	// we have to include male, female, and child labor together (cannot disaggregate wages)

*Hired wages:
gen prep_wage = ag3a_74_4/prep_labor
gen weed_wage = ag3a_74_8/weed_labor
gen harv_wage = ag3a_74_16/harv_labor

*Hired costs
gen prep_labor_costs = ag3a_74_4
gen weed_labor_costs = ag3a_74_8
gen harv_labor_costs = ag3a_74_16

egen value_hired_labor_prep_lrs = rowtotal(*_labor_costs)

*Constructing a household-specific wage
preserve
	collapse (sum) prep_labor weed_labor harv_labor *labor_costs, by(y4_hhid)		// summing total amount of labor and total wages paid to the household level
	gen prep_wage_hh = prep_labor_costs/prep_labor									// total costs divided by total labor at the household level
	gen weed_wage_hh = weed_labor_costs/weed_labor
	gen harv_wage_hh = harv_labor_costs/harv_labor
	recode *wage* (0=.)			// missing if zero
	save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_wages_hh_lrs.dta", replace
restore
*Merging right back in
merge m:1 y4_hhid using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_wages_hh_lrs.dta", nogen

*Going to construct wages separately for each type
*Constructing for each labor type
foreach i in prep weed harv{
	bys hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a: egen `i'_wage_count_vil = count(`i'_wage)
	bys hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a: egen `i'_wage_price_vil = median(`i'_wage)
	bys hh_a01_1 hh_a02_1 hh_a03_1: egen `i'_wage_count_ward = count(`i'_wage)
	bys hh_a01_1 hh_a02_1 hh_a03_1: egen `i'_wage_price_ward = median(`i'_wage)
	bys hh_a01_1 hh_a02_1: egen `i'_wage_count_dist = count(`i'_wage)
	bys hh_a01_1 hh_a02_1: egen `i'_wage_price_dist = median(`i'_wage)
	bys hh_a01_1: egen `i'_wage_count_reg = count(`i'_wage)
	bys hh_a01_1: egen `i'_wage_price_reg = median(`i'_wage)
	egen `i'_wage_price_nat = median(`i'_wage)
	
	*Creating wage rate
	gen `i'_wage_rate = `i'_wage_price_vil if `i'_wage_count_vil>=10
	replace `i'_wage_rate = `i'_wage_price_ward if `i'_wage_count_ward>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_wage_price_dist if `i'_wage_count_dist>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_wage_price_reg if `i'_wage_count_reg>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_wage_price_nat if `i'_wage_rate==.
}
sum *wage_rate, d		// prep slighly higher than weed slightly higher than harv

*Since we have to construct a single wage variable for all three genders, we do not need to disaggregate family labor by gender (or age)
*prep
egen prep_fam_labor_tot = rowtotal(ag3a_72_1 ag3a_72_2 ag3a_72_3 ag3a_72_4 ag3a_72_5 ag3a_72_6)
*weed
egen weed_fam_labor_tot = rowtotal(ag3a_72_7 ag3a_72_8 ag3a_72_9 ag3a_72_10 ag3a_72_11 ag3a_72_12)
*prep
egen harv_fam_labor_tot = rowtotal(ag3a_72_13 ag3a_72_14 ag3a_72_15 ag3a_72_16 ag3a_72_17 ag3a_72_18)

*Generating family values for each activity
gen fam_prep_val = prep_fam_labor_tot*prep_wage_rate											// using aggregate wage
replace fam_prep_val = prep_fam_labor_tot*prep_wage_hh if prep_wage_hh!=0 & prep_wage_hh!=.		// using actual household wage rate if available
gen fam_weed_val = weed_fam_labor_tot*weed_wage_rate
replace fam_weed_val = weed_fam_labor_tot*weed_wage_hh if weed_wage_hh!=0 & weed_wage_hh!=.
gen fam_harv_val = harv_fam_labor_tot*harv_wage_rate
replace fam_harv_val = harv_fam_labor_tot*harv_wage_hh if harv_wage_hh!=0 & harv_wage_hh!=.

*Summing at the plot level
egen value_fam_labor_lrs = rowtotal(fam_prep_val fam_weed_val fam_harv_val)

*Renaming (dropping lrs)
rename *_lrs *

foreach i in value_inorg_fert value_herb_pest value_org_purchased value_org_notpurchased value_hired_labor_prep value_fam_labor{
	gen `i'_male = `i' if dm_gender==1
	gen `i'_female = `i' if dm_gender==2
	gen `i'_mixed = `i' if dm_gender==3
}

collapse (sum) value_*, by(y4_hhid)
save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_cost_inputs_lrs.dta", replace


*********
*  SRS  *
*********
*In section 3 are fertilizer, hired labor, and family labor
use "${raw_data}/Agriculture/ag_sec_3b.dta", clear
drop if plotnum==""			// continuing with this (all missing values)
*Merging in geographic variables first (for constructing prices)
merge m:1 y4_hhid using "${raw_data}/Household/hh_sec_a.dta", nogen assert(2 3) keep(3)			// 1,262 not merged from USING; all matched from master
*Gender variables
ren plotnum plot_id
merge m:1 y4_hhid plot_id using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_rent_nomiss_lrs.dta", nogen keep(1 3) keepusing(dm_gender)

*Starting with fertilizer
*NOTE: Questionnaire seems to assume all inorganic fertilizer must be purchased
egen value_inorg_fert_srs = rowtotal(ag3b_51 ag3b_58)
egen value_herb_pest_srs = rowtotal(ag3b_63 ag3b_65c)
gen value_org_purchased_srs = ag3b_45

preserve
	gen fert_org_kg = ag3b_42
	egen fert_inorg_kg = rowtotal(ag3b_49 ag3b_56)
	gen fert_inorg_kg_male = fert_inorg_kg if dm_gender==1
	gen fert_inorg_kg_female = fert_inorg_kg if dm_gender==2
	gen fert_inorg_kg_mixed = fert_inorg_kg if dm_gender==3
	collapse (sum) fert_org_kg fert_inorg_kg*, by(y4_hhid)
	save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_fert_srs.dta", replace
restore

*For organic fertilizer value, we need to construct prices (note that there are relatively few prices, so many will be at higher levels of aggregation)
recode ag3b_42 ag3b_44 (.=0)
gen org_fert_notpurchased = ag3b_42-ag3b_44			// total amount minus amount purchased
replace org_fert_notpurchased = 0 if org_fert_notpurchased<0			// 0 changes
gen org_fert_purchased = ag3b_44					// kg purchased
gen org_fert_price = ag3b_45/org_fert_purchased		// total paid divided by kg (so tzs per kg)

*Household-specific value
preserve
	keep if org_fert_purchased!=0 & org_fert_purchased!=.		// keeping only plots that had purchased organic fertilizer
	collapse (sum) org_fert_purchased ag3b_45, by(y4_hhid)		// total kg purchased and total paid
	gen org_fert_price_hh = ag3b_45/org_fert_purchased
	save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_org_fert_srs.dta", replace
restore
merge m:1 y4_hhid using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_org_fert_srs.dta", nogen

*Geographic medians
bys hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a: egen org_price_count_vil = count(org_fert_price)
bys hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a: egen org_price_vil = median(org_fert_price) 
bys hh_a01_1 hh_a02_1 hh_a03_1: egen org_price_count_ward = count(org_fert_price)
bys hh_a01_1 hh_a02_1 hh_a03_1: egen org_price_ward = median(org_fert_price) 
bys hh_a01_1 hh_a02_1: egen org_price_count_dist = count(org_fert_price)
bys hh_a01_1 hh_a02_1: egen org_price_dist = median(org_fert_price) 
bys hh_a01_1: egen org_price_count_reg = count(org_fert_price)
bys hh_a01_1: egen org_price_reg = median(org_fert_price)
egen org_price_nat = median(org_fert_price)
drop org_fert_price
gen org_fert_price = org_price_vil if org_price_count_vil>=10
replace org_fert_price = org_price_ward if org_price_count_ward>=10 & org_fert_price==.
replace org_fert_price = org_price_dist if org_price_count_dist>=10 & org_fert_price==.
replace org_fert_price = org_price_reg if org_price_count_reg>=10 & org_fert_price==.
replace org_fert_price = org_price_nat if org_fert_price==.			// ALL changes are at national level
replace org_fert_price = org_fert_price_hh if org_fert_price_hh!=. & org_fert_price_hh!=0		// replace with household-level price when available; 27 changes

gen value_org_notpurchased_srs = org_fert_price*org_fert_notpurchased						// total value not purchased

*Hired labor
egen prep_labor = rowtotal(ag3b_74_1 ag3b_74_2 ag3b_74_3)		// we have to include male, female, and child labor together (cannot disaggregate wages)
egen weed_labor = rowtotal(ag3b_74_5 ag3b_74_6 ag3b_74_7)		// we have to include male, female, and child labor together (cannot disaggregate wages)
egen harv_labor = rowtotal(ag3b_74_13 ag3b_74_14 ag3b_74_15)	// we have to include male, female, and child labor together (cannot disaggregate wages)

*Hired wages:
gen prep_wage = ag3b_74_4/prep_labor
gen weed_wage = ag3b_74_8/weed_labor
gen harv_wage = ag3b_74_16/harv_labor

*Hired costs
gen prep_labor_costs = prep_labor*prep_wage
gen weed_labor_costs = weed_labor*weed_wage
gen harv_labor_costs = harv_labor*harv_wage

egen value_hired_labor_prep_srs = rowtotal(*_labor_costs)

*Constructing a household-specific wage
preserve
	collapse (sum) prep_labor weed_labor harv_labor *labor_costs, by(y4_hhid)
	gen prep_wage_hh = prep_labor_costs/prep_labor			// total costs divided by total labor at the household level
	gen weed_wage_hh = weed_labor_costs/weed_labor
	gen harv_wage_hh = harv_labor_costs/harv_labor
	recode *wage* (0=.)
	save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_wages_hh_srs.dta", replace
restore
*Merging right back in
merge m:1 y4_hhid using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_wages_hh_srs.dta", nogen

*Going to construct wages separately for each type
*Constructing for each labor type
foreach i in prep weed harv{
	bys hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a: egen `i'_wage_count_vil = count(`i'_wage)
	bys hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a: egen `i'_wage_price_vil = median(`i'_wage)
	bys hh_a01_1 hh_a02_1 hh_a03_1: egen `i'_wage_count_ward = count(`i'_wage)
	bys hh_a01_1 hh_a02_1 hh_a03_1: egen `i'_wage_price_ward = median(`i'_wage)
	bys hh_a01_1 hh_a02_1: egen `i'_wage_count_dist = count(`i'_wage)
	bys hh_a01_1 hh_a02_1: egen `i'_wage_price_dist = median(`i'_wage)
	bys hh_a01_1: egen `i'_wage_count_reg = count(`i'_wage)
	bys hh_a01_1: egen `i'_wage_price_reg = median(`i'_wage)
	egen `i'_wage_price_nat = median(`i'_wage)
	
	*Creating wage rate
	gen `i'_wage_rate = `i'_wage_price_vil if `i'_wage_count_vil>=10
	replace `i'_wage_rate = `i'_wage_price_ward if `i'_wage_count_ward>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_wage_price_dist if `i'_wage_count_dist>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_wage_price_reg if `i'_wage_count_reg>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_wage_price_nat if `i'_wage_rate==.
}

sum *wage_rate, d		// median actually the same for all three (but not means)

*Since we have to construct a single wage variable for all three genders, we do not need to disaggregate family labor by gender
*prep
egen prep_fam_labor_tot = rowtotal(ag3b_72_1 ag3b_72_2 ag3b_72_3 ag3b_72_4 ag3b_72_5 ag3b_72_6)
*weed
egen weed_fam_labor_tot = rowtotal(ag3b_72_7 ag3b_72_8 ag3b_72_9 ag3b_72_10 ag3b_72_11 ag3b_72_12)
*prep
egen harv_fam_labor_tot = rowtotal(ag3b_72_13 ag3b_72_14 ag3b_72_15 ag3b_72_16 ag3b_72_17 ag3b_72_18)
*Generating family values for each activity
gen fam_prep_val = prep_fam_labor_tot*prep_wage_rate											// aggregate wage rate
replace fam_prep_val = prep_fam_labor_tot*prep_wage_hh if prep_wage_hh!=0 & prep_wage_hh!=.		// using actual household wage rate if valid
gen fam_weed_val = weed_fam_labor_tot*weed_wage_rate
replace fam_weed_val = weed_fam_labor_tot*weed_wage_hh if weed_wage_hh!=0 & weed_wage_hh!=.
gen fam_harv_val = harv_fam_labor_tot*harv_wage_rate
replace fam_harv_val = harv_fam_labor_tot*harv_wage_hh if harv_wage_hh!=0 & harv_wage_hh!=.
egen value_fam_labor_srs = rowtotal(fam_prep_val fam_weed_val fam_harv_val)
rename *_srs *

foreach i in value_inorg_fert value_herb_pest value_org_purchased value_org_notpurchased value_hired_labor_prep value_fam_labor{
	gen `i'_male = `i' if dm_gender==1
	gen `i'_female = `i' if dm_gender==2
	gen `i'_mixed = `i' if dm_gender==3
}

collapse (sum) value_*, by(y4_hhid)
save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_cost_inputs_srs.dta", replace

use  "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_cost_inputs_lrs.dta", clear
append using  "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_cost_inputs_srs.dta"
collapse (sum) value_*, by(y4_hhid)

foreach v of varlist *prep*  {
	local l`v' = subinstr("`v'","_prep","",1)
	ren `v' `l`v''
}


********
* Seed *
********
*********
*  LRS  *
*********
use "${raw_data}/Agriculture/ag_sec_4a.dta", clear
drop if plotnum==""
ren plotnum plot_id
merge m:1 y4_hhid plot_id using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_rent_nomiss_lrs.dta", nogen keep(1 3) keepusing(dm_gender)
tab ag4a_10_2 ag4a_10c_2		// ALMOST everyone answers using same units for total seeds used and total seeds purchased (20 out of 1904 do not, or 1.05 percent)
*Given these numbers, I am going to ASSUME everyone answers using the same units.
*Also assuming all "others" are the same unit (lots of measurement error here; might just want to set these to missing so we know direction of bias)
gen seeds_not_purchased = ag4a_10_1 - ag4a_10c_1					// not purchased is total minus purchased
replace seeds_not_purchased = 0 if seeds_not_purchased<0			// assuming zero if negative (20 observations)
replace seeds_not_purchased = ag4a_10_1 if seeds_not_purchased==.	// total for those that have missing purchased
gen seeds_purchased = ag4a_10c_1									// purchased
*NOTE: Ignoring type of seed (improved, traditional, etc.) due to lack of observations
*NOTE: We also have lack of observations for many crops
*Now, getting seed prices
gen seed_price_hh = ag4a_12/ag4a_10c_1			// amount paid divided by amount

*Household-specific values
preserve
	drop if ag4a_12==0 | ag4a_12==.				// dropping zero/missings for amount paid
	collapse (sum) ag4a_12 ag4a_10c_1, by(y4_hhid zaocode)
	gen seed_price_hh_crop = ag4a_12/ag4a_10c_1
	save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_seeds_hh_lrs.dta", replace
restore
merge m:1 y4_hhid zaocode using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_seeds_hh_lrs.dta", nogen

*Geographically
*Merging in geographic variables first
merge m:1 y4_hhid using "${raw_data}/Household/hh_sec_a.dta", nogen assert(2 3) keep(3)
bys zaocode ag4a_10_2 hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a: egen seed_count_vil = count(seed_price_hh)		// by village AND unit AND crop
bys zaocode ag4a_10_2 hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a: egen seed_price_vil = median(seed_price_hh)
bys zaocode ag4a_10_2 hh_a01_1 hh_a02_1 hh_a03_1: egen seed_count_ward = count(seed_price_hh)
bys zaocode ag4a_10_2 hh_a01_1 hh_a02_1 hh_a03_1: egen seed_price_ward = median(seed_price_hh)
bys zaocode ag4a_10_2 hh_a01_1 hh_a02_1: egen seed_count_dist = count(seed_price_hh)
bys zaocode ag4a_10_2 hh_a01_1 hh_a02_1: egen seed_price_dist = median(seed_price_hh)
bys zaocode ag4a_10_2 hh_a01_1: egen seed_count_reg = count(seed_price_hh)
bys zaocode ag4a_10_2 hh_a01_1: egen seed_price_reg = median(seed_price_hh)
bys zaocode ag4a_10_2: egen seed_price_nat = median(seed_price_hh)
gen seed_price = seed_price_vil if seed_count_vil>=10
replace seed_price = seed_price_ward if seed_count_ward>=10 & seed_price==.
replace seed_price = seed_price_dist if seed_count_dist>=10 & seed_price==.
replace seed_price = seed_price_reg if seed_count_reg>=10 & seed_price==.
replace seed_price = seed_price_nat if seed_price==.			// 702 at the national level
gen value_seeds_not_purchased_lrs = seeds_not_purchased*seed_price			// 90 missings generated
replace value_seeds_not_purchased_lrs = seeds_not_purchased*seed_price_hh_crop if seed_price_hh_crop!=. & seed_price_hh_crop!=0			// replace with household value when available; 119 changes
gen value_seeds_purchased_lrs = ag4a_12
rename *_lrs *

foreach i in value_seeds_purchased value_seeds_not_purchased{
	gen `i'_male = `i' if dm_gender==1
	gen `i'_female = `i' if dm_gender==2
	gen `i'_mixed = `i' if dm_gender==3
}

collapse (sum) value_* , by(y4_hhid)
sum value_seeds_purchased, d
sum value_seeds_not_purchased, d

save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_cost_seed_lrs.dta", replace

*********
*  SRS  *
*********
use "${raw_data}/Agriculture/ag_sec_4b.dta", clear
drop if plotnum==""
ren plotnum plot_id
merge m:1 y4_hhid plot_id using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_rent_nomiss_lrs.dta", nogen keep(1 3) keepusing(dm_gender)
tab ag4b_10_2 ag4b_10c_2		// ALMOST everyone answers using same units for total seeds used and total seeds purchased (20 out of 1904 do not, or 1.05 percent)
*Given these numbers, I am going to ASSUME everyone answers using the same units.
*Also assuming all "others" are the same unit (lots of measurement error here; might just want to set these to missing so we know direction of bias)
gen seeds_not_purchased = ag4b_10_1 - ag4b_10c_1					// not purchased is total minus purchased
replace seeds_not_purchased = 0 if seeds_not_purchased<0			// assuming zero if negative (20 observations)
replace seeds_not_purchased = ag4b_10_1 if seeds_not_purchased==.	// total for those that have missing purchased
gen seeds_purchased = ag4b_10c_1									// purchased

*NOTE: Ignoring type of seed (improved, traditional, etc.) due to lack of observations
*NOTE: We also have lack of observations for many crops
*Now, getting seed prices
gen seed_price_hh = ag4b_12/ag4b_10c_1			// amount paid divided by amount

*Household-specific values
preserve
	drop if ag4b_12==0 | ag4b_12==.				// dropping zero/missings for amount paid
	collapse (sum) ag4b_12 ag4b_10c_1, by(y4_hhid zaocode)
	gen seed_price_hh_crop = ag4b_12/ag4b_10c_1
	save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_seeds_hh_srs.dta", replace
restore
merge m:1 y4_hhid zaocode using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_seeds_hh_srs.dta", nogen

*Geographically
*Merging in geographic variables first
merge m:1 y4_hhid using "${raw_data}/Household/hh_sec_a.dta", nogen assert(2 3) keep(3)
bys zaocode ag4b_10_2 hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a: egen seed_count_vil = count(seed_price_hh)		// by village AND unit AND crop
bys zaocode ag4b_10_2 hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a: egen seed_price_vil = median(seed_price_hh)
bys zaocode ag4b_10_2 hh_a01_1 hh_a02_1 hh_a03_1: egen seed_count_ward = count(seed_price_hh)
bys zaocode ag4b_10_2 hh_a01_1 hh_a02_1 hh_a03_1: egen seed_price_ward = median(seed_price_hh)
bys zaocode ag4b_10_2 hh_a01_1 hh_a02_1: egen seed_count_dist = count(seed_price_hh)
bys zaocode ag4b_10_2 hh_a01_1 hh_a02_1: egen seed_price_dist = median(seed_price_hh)
bys zaocode ag4b_10_2 hh_a01_1: egen seed_count_reg = count(seed_price_hh)
bys zaocode ag4b_10_2 hh_a01_1: egen seed_price_reg = median(seed_price_hh)
bys zaocode ag4b_10_2: egen seed_price_nat = median(seed_price_hh)

gen seed_price = seed_price_vil if seed_count_vil>=10
replace seed_price = seed_price_ward if seed_count_ward>=10 & seed_price==.
replace seed_price = seed_price_dist if seed_count_dist>=10 & seed_price==.
replace seed_price = seed_price_reg if seed_count_reg>=10 & seed_price==.
replace seed_price = seed_price_nat if seed_price==.
gen value_seeds_not_purchased_srs = seeds_not_purchased*seed_price			// 104 missings
replace value_seeds_not_purchased_srs = seeds_not_purchased*seed_price_hh_crop if seed_price_hh_crop!=. & seed_price_hh_crop!=0			// 23 changes
gen value_seeds_purchased_srs = ag4b_12
rename *_srs *

foreach i in value_seeds_purchased value_seeds_not_purchased{
	gen `i'_male = `i' if dm_gender==1
	gen `i'_female = `i' if dm_gender==2
	gen `i'_mixed = `i' if dm_gender==3
}

collapse (sum) value_* , by(y4_hhid)
sum value_seeds_purchased, d
sum value_seeds_not_purchased, d

save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_cost_seed_srs.dta", replace


*Rental of agricultural tools, machines, animal traction
use "${raw_data}\Agriculture\ag_sec_11.dta", clear
gen animal_traction = (itemid>=3 & itemid<=5)
gen ag_asset = (itemid<3 | itemid>8)
gen tractor = (itemid>=6 & itemid<=8)
rename ag11_09 rental_cost
gen rental_cost_animal_traction = rental_cost if animal_traction==1
gen rental_cost_ag_asset = rental_cost if ag_asset==1
gen rental_cost_tractor = rental_cost if tractor==1
recode rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor (.=0)
collapse (sum) rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor, by (y4_hhid)
lab var rental_cost_animal_traction "Costs for renting animal traction"
lab var rental_cost_ag_asset "Costs for renting other agricultural items"
lab var rental_cost_tractor "Costs for renting a tractor"
egen value_ag_rentals = rowtotal(rental_cost_*)
lab var value_ag_rentals "Value of rented equipment (household level"
 save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_asset_rental_costs.dta", replace

* merging cost variable together
use "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_cost_land.dta", clear
append using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_rental_rate.dta"
append using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_cost_inputs_lrs.dta"
append using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_cost_inputs_srs.dta"
append using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_cost_seed_lrs.dta"
append using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_cost_seed_srs.dta"
append using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_asset_rental_costs.dta"
collapse (sum) value_* ha_planted*, by(y4_hhid)

lab var value_owned_land "Value of owned land that was cultivated (household)"
lab var value_owned_land_male "Value of owned land (male-managed plots)"
lab var value_owned_land_female "Value of owned land (female-managed plots)"
lab var value_owned_land_mixed "Value of owned land (mixed-managed plots)"
lab var value_rented_land "Value of rented land that was cultivated (household)"
lab var value_rented_land_male "Value of rented land (male-managed plots)"
lab var value_rented_land_female "Value of rented land (female-managed plots)"
lab var value_rented_land_mixed "Value of rented land (mixed-managed plots)"
lab var ha_planted "Area planted (household)"
lab var ha_planted_male "Area planted (male-managed plots)"
lab var ha_planted_female "Area planted (female-managed plots)"
lab var ha_planted_mixed "Area planted (mixed-managed plots)"
lab var value_seeds_not_purchased "Value of seeds not purchased (household)"
lab var value_seeds_not_purchased_male "Value of seeds not purchased (male-managed plots)"
lab var value_seeds_not_purchased_female "Value of seeds not purchased (female-managed plots)"
lab var value_seeds_not_purchased_mixed "Value of seeds not purchased (mixed-managed plots)"
lab var value_seeds_purchased "Value of seeds purchased (household)"
lab var value_seeds_purchased_male "Value of seeds purchased (male-managed plots)"
lab var value_seeds_purchased_female "Value of seeds purchased (female-managed plots)"
lab var value_seeds_purchased_mixed "Value of seeds purchased (mixed-managed plots)"
lab var value_herb_pest "Value of herbicide_pesticide (household)"
lab var value_herb_pest_male "Value of herbicide_pesticide (male-managed plots)"
lab var value_herb_pest_female "Value of herbicide_pesticide (female-managed plots)"
lab var value_herb_pest_mixed "Value of herbicide_pesticide (mixed-managed plots)"
lab var value_inorg_fert "Value of inorganic fertilizer (household)"
lab var value_inorg_fert_male "Value of inorganic fertilizer (male-managed plots)"
lab var value_inorg_fert_female "Value of inorganic fertilizer female-managed plots)"
lab var value_inorg_fert_mixed "Value of inorganic fertilizer (mixed-managed plots)"
lab var value_org_purchased "Value organic fertilizer purchased (household)"
lab var value_org_purchased_male "Value organic fertilizer purchased (male-managed plots)"
lab var value_org_purchased_female "Value organic fertilizer purchased (female-managed plots)"
lab var value_org_purchased_mixed "Value organic fertilizer purchased (mixed-managed plots)"
lab var value_org_notpurchased "Value organic fertilizer not purchased (household)"
lab var value_org_notpurchased_male "Value organic fertilizer not purchased (male-managed plots)"
lab var value_org_notpurchased_female "Value organic fertilizer not purchased (female-managed plots)"
lab var value_org_notpurchased_mixed "Value organic fertilizer not purchased (mixed-managed plots)"
foreach v of varlist *prep*  {
	local l`v' = subinstr("`v'","_prep","",1)
	ren `v' `l`v''
}
lab var value_hired_labor "Value of hired labor (household)"
lab var value_hired_labor_male "Value of hired labor (male-managed crops)"
lab var value_hired_labor_female "Value of hired labor (female-managed crops)"
lab var value_hired_labor_mixed "Value of hired labor (mixed-managed crops)"
lab var value_fam_labor "Value of family labor (household)"
lab var value_fam_labor_male "Value of family labor (male-managed crops)"
lab var value_fam_labor_female "Value of family labor (female-managed crops)"
lab var value_fam_labor_mixed "Value of family labor (mixed-managed crops)"
lab var value_ag_rentals "Value of rented equipment (household level"
  
recode ha_planted* (0=.)

egen costs_total_hh = rowtotal(value_ag_rentals value_owned_land value_rented_land value_inorg_fert value_herb_pest value_org_purchased value_org_notpurchased ///
value_hired_labor value_fam_labor value_seeds_not_purchased value_seeds_purchased)
replace costs_total_hh = costs_total_hh/ha_planted

*Creating total costs by gender (NOTE: excludes ag_rentals because those are at the household level)
foreach i in male female mixed{
	egen costs_total_hh_`i' = rowtotal(value_owned_land_`i' value_rented_land_`i' value_inorg_fert_`i' value_herb_pest_`i' value_org_purchased_`i' ///
	value_org_notpurchased_`i' value_hired_labor_`i' value_fam_labor_`i' value_seeds_not_purchased_`i' value_seeds_purchased_`i')
	replace costs_total_hh_`i' = (costs_total_hh_`i'/ha_planted_`i') 
}
*Recoding zeros as missings
recode costs_total_hh* (0=.)		// should be no zeros for implicit costs


egen costs_total_explicit_hh = rowtotal(value_ag_rentals value_rented_land value_inorg_fert value_herb_pest value_org_purchased value_hired_labor value_seeds_purchased)
replace costs_total_explicit_hh = costs_total_explicit_hh/ha_planted
replace costs_total_explicit_hh = costs_total_explicit_hh 
la var costs_total_explicit_hh "Total explicit crop production costs per hectare, $/ha"
count if costs_total_explicit_hh==0		// 361 zeros

*Creating explicit costs by gender (NOTE: excludes ag_rentals because those are at the household level)
foreach i in male female mixed{
	egen costs_total_explicit_hh_`i' = rowtotal(value_rented_land_`i' value_inorg_fert_`i' value_herb_pest_`i' value_org_purchased_`i' value_hired_labor_`i' value_seeds_purchased_`i')
	replace costs_total_explicit_hh_`i' = (costs_total_explicit_hh_`i'/ha_planted_`i') 
}

lab var costs_total_hh "Explicit + implicit costs of crop production (household level) per ha (local currency)"
lab var costs_total_hh_male "Explicit + implicit costs of crop production (male-managed crops) per ha (local currency)"
lab var costs_total_hh_female "Explicit + implicit costs of crop production (female-managed crops) per ha (local currency)"
lab var costs_total_hh_mixed "Explicit + implicit costs of crop production (mixed-managed crops) per ha (local currency)"
lab var costs_total_explicit_hh "Explicit costs of crop production (household level) per ha (local currency)"
lab var costs_total_explicit_hh_male "Explicit costs of crop production (male-managed crops) per ha (local currency)"
lab var costs_total_explicit_hh_female "Explicit costs of crop production (female-managed crops) per ha (local currency)"
lab var costs_total_explicit_hh_mixed "Explicit costs of crop production (mixed-managed crops) per ha (local currency)"
save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_cropcosts_perha.dta", replace

************
*RATE OF FERTILIZER APPLICATION
************
use "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_ha_planted_total.dta", clear
append using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_fert_lrs.dta"
append using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_hh_fert_srs.dta"
collapse (sum) ha_planted* fert_org_kg* fert_inorg_kg*, by(y4_hhid)
*merge 1:1 y4_hhid using "$created_data/male_head.dta", nogen keep(1 3)
*Recoding ha planted before creating rates
winsor2 ha_planted*, cuts(1 99) replace
gen inorg_fert_rate = fert_inorg_kg/ha_planted
gen inorg_fert_rate_male = fert_inorg_kg_male/ha_planted_male
gen inorg_fert_rate_female = fert_inorg_kg_female/ha_planted_female
gen inorg_fert_rate_mixed = fert_inorg_kg_mixed/ha_planted_mixed
*winsor2 inorg_fert_rate*, cuts(0 99) replace
drop ha_planted- fert_org_kg
drop fert_inorg_* 
lab var inorg_fert_rate "Rate of fertilizer application (kgs/ha) (household level)"
lab var inorg_fert_rate_male "Rate of fertilizer application (kgs/ha) (male-managed crops)"
lab var inorg_fert_rate_female "Rate of fertilizer application (kgs/ha) (female-managed crops)"
lab var inorg_fert_rate_mixed "Rate of fertilizer application (kgs/ha) (mixed-managed crops)"
save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_fertilizer_application.dta", replace


************
*WOMEN'S DIET QUALITY
************
*Women's diet quality: proportion of women consuming nutrient-rich foods (%)
*Information not available


************
*HOUSEHOLD'S DIET DIVERSITY SCORE
************
* TZA LSMS 4 does not report individual consumption but instead household level consumption of various food items.
* Thus, only the proportion of householdd eating nutritious food can be estimated
use "${raw_data}\Household\hh_sec_j1.dta" , clear
* recode food items to map HDDS food categories
recode itemcode 	(101/112 1081 1082 				=1	"CEREALS" )  //// 
					(201/207    					=2	"WHITE ROOTS,TUBERS AND OTHER STARCHES"	)  ////
					(602 601 603	 				=3	"VEGETABLES"	)  ////	
					(703 701 702					=4	"FRUITS"	)  ////	
					(801/806 						=5	"MEAT"	)  ////					
					(807							=6	"EGGS"	)  ////
					(808/810 						=7  "FISH") ///
					(401  501/504					=8	"LEGUMES, NUTS AND SEEDS") ///
					(901/903						=9	"MILK AND MILK PRODUCTS")  ////
					(1001 1002   					=10	"OILS AND FATS"	)  ////
					(301/303 704 1104 				=11	"SWEETS"	)  //// 
					(1003 1004 1101/1103 1105/1108 =14 "SPICES, CONDIMENTS, BEVERAGES"	)  ////
					,generate(Diet_ID)
				
gen adiet_yes=(hh_j01==1)
ta Diet_ID   
** Now, collapse to food group level; household consumes a food group if it consumes at least one item
collapse (max) adiet_yes, by(y4_hhid   Diet_ID) 
label define YesNo 1 "Yes" 0 "No"
label val adiet_yes YesNo
* Now, estimate the number of food groups eaten by each individual
collapse (sum) adiet_yes, by(y4_hhid )
/*
There are no established cut-off points in terms of number of food groups to indicate
adequate or inadequate dietary diversity for the HDDS. 
Can use either cut-off or 6 (=12/2) or cut-off=mean(socore) 
*/
ren adiet_yes number_foodgroup 
sum number_foodgroup 
local cut_off1=6
local cut_off2=round(r(mean))
gen household_diet_cut_off1=(number_foodgroup>=`cut_off1')
gen household_diet_cut_off2=(number_foodgroup>=`cut_off2')
lab var household_diet_cut_off1 "1= houseold consumed at least `cut_off1' of the 12 food groups last week" 
lab var household_diet_cut_off2 "1= houseold consumed at least `cut_off2' of the 12 food groups last week" 
label var number_foodgroup "Number of food groups individual consumed last week HDDS"
save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_household_diet.dta", replace
 
 
************
*WOMEN'S CONTROL OVER INCOME
************
*Code as 1 if a woman is listed as one of the decision-makers for at least 1 income-related area; 
*can report on % of women who make decisions, taking total number of women HH members as denominator
*Inmost cases, TZA LSMS 4 lsit the first TWO decision makers.
*Indicator may be biased downward if some women would participate in decisions about the use of income
*but are not listed among the first two
 
/*
Areas of decision making to be considered
Decision-making areas
*	Control over crop production income
*	Control over livestock production income
*	Control over fish production income
*	Control over farm (all) production income
*	Control over wage income
*	Control over business income
*	Control over nonfarm (all) income
*	Control over (all) income
*/

* First append all files with information on who control various types of income
use "${raw_data}\Agriculture\ag_sec_4a", clear
append using "${raw_data}\Agriculture\ag_sec_4b"
append using "${raw_data}\Agriculture\ag_sec_5a"
append using "${raw_data}\Agriculture\ag_sec_5b"
append using "${raw_data}\Agriculture\ag_sec_6a"
append using "${raw_data}\Agriculture\ag_sec_6b"
append using "${raw_data}\Agriculture\ag_sec_7a"
append using "${raw_data}\Agriculture\ag_sec_7b"
append using "${raw_data}\Agriculture\ag_sec_10"
append using "${raw_data}\Livestock and Fisheries\lf_sec_02.dta"
append using "${raw_data}\Livestock and Fisheries\lf_sec_06.dta"
append using "${raw_data}\Livestock and Fisheries\lf_sec_08.dta"
append using "${raw_data}\Household\hh_sec_n.dta"
append using "${raw_data}\Household\hh_sec_q2.dta"
append using "${raw_data}\Household\hh_sec_o1.dta"

gen type_decision="" 
gen controller_income1=.
gen controller_income2=.
* control of harvest from annual crops
replace type_decision="control_annualharvest" if  !inlist( ag4a_30_1, .,0,99) |  !inlist( ag4a_30_2, .,0,99) 
replace controller_income1=ag4a_30_1 if !inlist( ag4a_30_1, .,0,99)  
replace controller_income2=ag4a_30_2 if !inlist( ag4a_30_2, .,0,99)
replace type_decision="control_annualharvest" if  !inlist( ag4b_30_1, .,0,99) |  !inlist( ag4b_30_2, .,0,99) 
replace controller_income1=ag4b_30_1 if !inlist( ag4b_30_1, .,0,99)  
replace controller_income2=ag4b_30_2 if !inlist( ag4b_30_2, .,0,99)
* control of harvest from permanent crops
replace type_decision="control_permharvest" if  !inlist( ag6a_08_1, .,0,99) |  !inlist( ag6a_08_2, .,0,99) 
replace controller_income1=ag6a_08_1 if !inlist( ag6a_08_1, .,0,99)  
replace controller_income2=ag6a_08_2 if !inlist( ag6a_08_2, .,0,99)
replace type_decision="control_permharvest" if  !inlist( ag6b_08_1, .,0,99) |  !inlist( ag6b_08_2, .,0,99) 
replace controller_income1=ag6b_08_1 if !inlist( ag6b_08_1, .,0,99)  
replace controller_income2=ag6b_08_2 if !inlist( ag6b_08_2, .,0,99)
* control_annualsales
replace type_decision="control_annualsales" if  !inlist( ag5a_10_1, .,0,99) |  !inlist( ag5a_10_2, .,0,99) 
replace controller_income1=ag5a_10_1 if !inlist( ag5a_10_1, .,0,99)  
replace controller_income2=ag5a_10_2 if !inlist( ag5a_10_2, .,0,99)
replace type_decision="control_annualsales" if  !inlist( ag5b_10_1, .,0,99) |  !inlist( ag5b_10_2, .,0,99) 
replace controller_income1=ag5b_10_1 if !inlist( ag5b_10_1, .,0,99)  
replace controller_income2=ag5b_10_2 if !inlist( ag5b_10_2, .,0,99)
* append who controle earning from sale to customer 2
preserve
replace type_decision="control_annualsales" if  !inlist( ag5a_17_1, .,0,99) |  !inlist( ag5a_17_2, .,0,99) 
replace controller_income1=ag5a_17_1 if !inlist( ag5a_17_1, .,0,99)  
replace controller_income2=ag5a_17_2 if !inlist( ag5a_17_2, .,0,99)
replace type_decision="control_annualsales" if  !inlist( ag5b_17_1, .,0,99) |  !inlist( ag5b_17_2, .,0,99) 
replace controller_income1=ag5b_17_1 if !inlist( ag5b_17_1, .,0,99)  
replace controller_income2=ag5b_17_2 if !inlist( ag5b_17_2, .,0,99)
keep if !inlist( ag5a_17_1, .,0,99) |  !inlist( ag5a_17_2, .,0,99)  | !inlist( ag5b_17_1, .,0,99) |  !inlist( ag5b_17_2, .,0,99) 
keep y4_hhid type_decision controller_income1 controller_income2
tempfile saletocustomer2
save `saletocustomer2'
restore
append using `saletocustomer2'  
* control_permsales
replace type_decision="control_permsales" if  !inlist( ag7a_06_1, .,0,99) |  !inlist( ag7a_06_2, .,0,99) 
replace controller_income1=ag7a_06_1 if !inlist( ag7a_06_1, .,0,99)  
replace controller_income2=ag7a_06_2 if !inlist( ag7a_06_2, .,0,99)
replace type_decision="control_permsales" if  !inlist( ag7b_06_1, .,0,99) |  !inlist( ag7b_06_2, .,0,99) 
replace controller_income1=ag7b_06_1 if !inlist( ag7b_06_1, .,0,99)  
replace controller_income2=ag7b_06_2 if !inlist( ag7b_06_2, .,0,99)
* control_processedsales
replace type_decision="control_processedsales" if  !inlist( ag10_10_1, .,0,99) |  !inlist( ag10_10_2, .,0,99) 
replace controller_income1=ag10_10_1 if !inlist( ag10_10_1, .,0,99)  
replace controller_income2=ag10_10_2 if !inlist( ag10_10_2, .,0,99)
* livestock_sales (live)
replace type_decision="control_livestocksales" if  !inlist( lf02_27_1, .,0,99) |  !inlist( lf02_27_2, .,0,99) 
replace controller_income1=lf02_27_1 if !inlist( lf02_27_1, .,0,99)  
replace controller_income2=lf02_27_2 if !inlist( lf02_27_2, .,0,99)
* append who controle earning from livestock_sales (slaughtered)
preserve
replace type_decision="control_livestocksales" if  !inlist( lf02_35_1, .,0,99) |  !inlist( lf02_35_2, .,0,99) 
replace controller_income1=lf02_35_1 if !inlist( lf02_35_1, .,0,99)  
replace controller_income2=lf02_35_2 if !inlist( lf02_35_2, .,0,99)
keep if  !inlist( lf02_35_1, .,0,99) |  !inlist( lf02_35_2, .,0,99) 
keep y4_hhid type_decision controller_income1 controller_income2
tempfile control_livestocksales2
save `control_livestocksales2'
restore
append using `control_livestocksales2' 
* control milk_sales
replace type_decision="control_milksales" if  !inlist( lf06_13_1, .,0,99) |  !inlist( lf06_13_2, .,0,99) 
replace controller_income1=lf06_13_1 if !inlist( lf06_13_1, .,0,99)  
replace controller_income2=lf06_13_2 if !inlist( lf06_13_2, .,0,99)
* control control_otherlivestock_sales
replace type_decision="control_otherlivestock_sales" if  !inlist( lf08_08_1, .,0,99) |  !inlist( lf08_08_2, .,0,99) 
replace controller_income1=lf08_08_1 if !inlist( lf08_08_1, .,0,99)  
replace controller_income2=lf08_08_2 if !inlist( lf08_08_2, .,0,99)
* Fish production income 
*No information available

* Business income 
* Tanzania LSMS 4 did not ask directly about of who control Business Income
* We are making the assumption that whoever owns the business might have some sort of control over the income generated by the business.
* We don't think that the business manager have control of the business income. If she does, she is probaly listed as owner
* control_businessincome
replace type_decision="control_businessincome" if  !inlist( hh_n05_1, .,0,99) |  !inlist( hh_n05_2, .,0,99) 
replace controller_income1=hh_n05_1 if !inlist( hh_n05_1, .,0,99)  
replace controller_income2=hh_n05_2 if !inlist( hh_n05_2, .,0,99)

** --- Wage income --- *
* There is no question in Tanzania LSMS on who control wage earnings
* and we can't assume that the wage earner always controle the wage income
 

* control_remittance
replace type_decision="control_remittance" if  !inlist( hh_q25_1, .,0,99) |  !inlist( hh_q25_2, .,0,99) 
replace controller_income1=hh_q25_1 if !inlist( hh_q25_1, .,0,99)  
replace controller_income2=hh_q25_2 if !inlist( hh_q25_2, .,0,99)
* append who controle in-kind remittances
preserve
replace type_decision="control_remittance" if  !inlist( hh_q27_1, .,0,99) |  !inlist( hh_q27_2, .,0,99) 
replace controller_income1=hh_q27_1 if !inlist( hh_q27_1, .,0,99)  
replace controller_income2=hh_q27_2 if !inlist( hh_q27_2, .,0,99)
keep if  !inlist( hh_q27_1, .,0,99) |  !inlist( hh_q27_2, .,0,99) 
keep y4_hhid type_decision controller_income1 controller_income2
tempfile control_remittance2
save `control_remittance2'
restore
append using `control_remittance2'
* control_assistance income
replace type_decision="control_assistance" if  !inlist( hh_o07_1, .,0,99) |  !inlist( hh_o07_2, .,0,99) 
replace controller_income1=hh_o07_1 if !inlist( hh_o07_1, .,0,99)  
replace controller_income2=hh_o07_2 if !inlist( hh_o07_2, .,0,99)

keep y4_hhid type_decision controller_income1 controller_income2
 
preserve
keep y4_hhid type_decision controller_income2
drop if controller_income2==.
ren controller_income2 controller_income
tempfile controller_income2
save `controller_income2'
restore
keep y4_hhid type_decision controller_income1
drop if controller_income1==.
ren controller_income1 controller_income
append using `controller_income2'
 
* create group
gen control_cropincome=1 if  type_decision=="control_annualharvest" ///
							| type_decision=="control_permharvest" ///
							| type_decision=="control_annualsales" ///
							| type_decision=="control_permsales" ///
							| type_decision=="control_processedsales"
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
collapse (max) control_* , by(y4_hhid controller_income )  //any decision
gen control_all_income=1 if  control_farmincome== 1 | control_nonfarmincome==1
recode 	control_all_income (.=0)															
ren controller_income indidy4
*	Now merge with member characteristics
merge 1:1 y4_hhid indidy4  using  "${created_data}\Tanzania_NPS_LSMS_ISA_W4_person_ids.dta", nogen 
*  5  member ID in decision files not in member list
recode control_* (.=0)
lab var control_cropincome "1=invidual has control over crop income"
lab var control_livestockincome "1=invidual has control over livestock income"
lab var control_farmincome "1=invidual has control over farm (crop or livestock) income"
lab var control_businessincome "1=invidual has control over business income"
lab var control_nonfarmincome "1=invidual has control over non-farm (business or remittances) income"
lab var control_all_income "1=invidual has control over at least one type of income"
save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_control_income.dta", replace

************
*WOMEN'S PARTICIPATION IN AGRICULTURAL DECISION MAKIN
************
*	Code as 1 if a woman is listed as one of the decision-makers for at least 2 plots, crops, or livestock activities; 
*	can report on % of women who make decisions, taking total number of women HH members as denominator
*	In most cases, TZA LSMS 4 lists the first TWO decision makers.
*	Indicator may be biased downward if some women would participate in decisions but are not listed among the first two
* first append all files related to agricultural activities with income in who participate in the decision making
use "${raw_data}\Agriculture\ag_sec_3a", clear
append using "${raw_data}\Agriculture\ag_sec_3b"
append using "${raw_data}\Agriculture\ag_sec_4a"
append using "${raw_data}\Agriculture\ag_sec_4b"
append using "${raw_data}\Agriculture\ag_sec_5a"
append using "${raw_data}\Agriculture\ag_sec_5b"
append using "${raw_data}\Agriculture\ag_sec_6a"
append using "${raw_data}\Agriculture\ag_sec_6b"
append using "${raw_data}\Agriculture\ag_sec_7a"
append using "${raw_data}\Agriculture\ag_sec_7b"
append using "${raw_data}\Agriculture\ag_sec_10"
append using "${raw_data}\Livestock and Fisheries\lf_sec_02.dta"
append using "${raw_data}\Livestock and Fisheries\lf_sec_05.dta"
append using "${raw_data}\Livestock and Fisheries\lf_sec_06.dta"
append using "${raw_data}\Livestock and Fisheries\lf_sec_08.dta"
gen type_decision="" 
gen decision_maker1=.
gen decision_maker2=.
gen decision_maker3=.
* planting_input
replace type_decision="planting_input" if  !inlist( ag3a_08_1, .,0,99) |  !inlist( ag3a_08_2, .,0,99) |  !inlist( ag3a_08_3, .,0,99) 
replace decision_maker1=ag3a_08_1 if !inlist( ag3a_08_1, .,0,99)  
replace decision_maker2=ag3a_08_2 if !inlist( ag3a_08_2, .,0,99)
replace decision_maker3=ag3a_08_2 if !inlist( ag3a_08_3, .,0,99)
replace type_decision="planting_input" if  !inlist( ag3b_08_1, .,0,99) |  !inlist( ag3b_08_2, .,0,99) |  !inlist( ag3b_08_3, .,0,99) 
replace decision_maker2=ag3b_08_1 if !inlist( ag3b_08_1, .,0,99)  
replace decision_maker2=ag3b_08_2 if !inlist( ag3b_08_2, .,0,99)
replace decision_maker3=ag3b_08_3 if !inlist( ag3b_08_3, .,0,99)

* append who make decision about input use
preserve
replace type_decision="planting_input" if  !inlist( ag3a_09_1, .,0,99) |  !inlist( ag3a_09_2, .,0,99) |  !inlist( ag3a_09_3, .,0,99) 
replace decision_maker1=ag3a_09_1 if !inlist( ag3a_09_1, .,0,99)  
replace decision_maker2=ag3a_09_2 if !inlist( ag3a_09_2, .,0,99)
replace decision_maker3=ag3a_09_2 if !inlist( ag3a_09_3, .,0,99)
replace type_decision="planting_input" if  !inlist( ag3b_09_1, .,0,99) |  !inlist( ag3b_09_2, .,0,99) |  !inlist( ag3b_09_3, .,0,99) 
replace decision_maker2=ag3b_09_1 if !inlist( ag3b_09_1, .,0,99)  
replace decision_maker2=ag3b_09_2 if !inlist( ag3b_09_2, .,0,99)
replace decision_maker3=ag3b_09_3 if !inlist( ag3b_09_3, .,0,99)                        
keep if !inlist( ag3a_09_1, .,0,99) |  !inlist( ag3a_09_2, .,0,99) |  !inlist( ag3a_09_3, .,0,99) |  !inlist( ag3b_09_1, .,0,99) |  !inlist( ag3b_09_2, .,0,99) |  !inlist( ag3b_09_3, .,0,99) 
keep y4_hhid type_decision decision_maker*
tempfile planting_input2
save `planting_input2'
restore
* harvest
replace type_decision="harvest" if  !inlist( ag4a_30_1, .,0,99) |  !inlist( ag4a_30_2, .,0,99)  
replace decision_maker1=ag4a_30_1 if !inlist( ag4a_30_1, .,0,99)  
replace decision_maker2=ag4a_30_2 if !inlist( ag4a_30_2, .,0,99)
replace type_decision="harvest" if  !inlist( ag4b_30_1, .,0,99) |  !inlist( ag4b_30_2, .,0,99)  
replace decision_maker1=ag4b_30_1 if !inlist( ag4b_30_1, .,0,99)  
replace decision_maker2=ag4b_30_2 if !inlist( ag4b_30_2, .,0,99)

* sales_annualcrop
replace type_decision="sales_annualcrop" if  !inlist( ag5a_09_1, .,0,99) |  !inlist( ag5a_09_2, .,0,99) 
replace decision_maker1=ag5a_09_1 if !inlist( ag5a_09_1, .,0,99)  
replace decision_maker2=ag5a_09_2 if !inlist( ag5a_09_2, .,0,99)
replace type_decision="sales_annualcrop" if  !inlist( ag5b_09_1, .,0,99) |  !inlist( ag5b_09_2, .,0,99) 
replace decision_maker1=ag5b_09_1 if !inlist( ag5b_09_1, .,0,99)  
replace decision_maker2=ag5b_09_2 if !inlist( ag5b_09_2, .,0,99)
* append who make negotiate sale to custumer 2
preserve
replace type_decision="sales_annualcrop" if  !inlist( ag5a_16_1, .,0,99) |  !inlist( ag5a_16_1, .,0,99) 
replace decision_maker1=ag5a_16_1 if !inlist( ag5a_16_1, .,0,99)  
replace decision_maker2=ag5a_16_2 if !inlist( ag5a_16_2, .,0,99)
replace type_decision="sales_annualcrop" if  !inlist( ag5b_16_1, .,0,99) |  !inlist( ag5b_16_1, .,0,99) 
replace decision_maker1=ag5b_16_1 if !inlist( ag5b_16_1, .,0,99)  
replace decision_maker2=ag5b_16_2 if !inlist( ag5b_16_2, .,0,99)
keep if !inlist( ag5a_16_1, .,0,99) |  !inlist( ag5a_16_1, .,0,99) | !inlist( ag5b_16_1, .,0,99) |  !inlist( ag5b_16_1, .,0,99)
keep y4_hhid type_decision decision_maker*
tempfile sales_annualcrop2
save `sales_annualcrop2'
restore
append using `sales_annualcrop2'  

* sales_permcrop
replace type_decision="sales_permcrop" if  !inlist( ag7a_05_1, .,0,99) |  !inlist( ag7a_05_2, .,0,99)  
replace decision_maker1=ag7a_05_1 if !inlist( ag7a_05_1, .,0,99)  
replace decision_maker2=ag7a_05_2 if !inlist( ag7a_05_2, .,0,99)
replace type_decision="sales_permcrop" if  !inlist( ag7b_05_1, .,0,99) |  !inlist( ag7b_05_2, .,0,99)  
replace decision_maker1=ag7b_05_1 if !inlist( ag7b_05_1, .,0,99)  
replace decision_maker2=ag7b_05_2 if !inlist( ag7b_05_2, .,0,99)
* sales_processcrop
replace type_decision="sales_processcrop" if  !inlist( ag10_09_1, .,0,99) |  !inlist( ag10_09_2, .,0,99)  
replace decision_maker1=ag10_09_1 if !inlist( ag10_09_1, .,0,99)  
replace decision_maker2=ag10_09_2 if !inlist( ag10_09_2, .,0,99)
  
* keep/manage livesock
replace type_decision="livestockowners" if  !inlist( lf05_01_1, .,0,99) |  !inlist( lf05_01_2, .,0,99)  
replace decision_maker1=lf05_01_1 if !inlist( lf05_01_1, .,0,99)  
replace decision_maker2=lf05_01_2 if !inlist( lf05_01_2, .,0,99)
    
keep y4_hhid type_decision decision_maker1 decision_maker2 decision_maker3
 
preserve
keep y4_hhid type_decision decision_maker2
drop if decision_maker2==.
ren decision_maker2 decision_maker
tempfile decision_maker2
save `decision_maker2'
restore

preserve
keep y4_hhid type_decision decision_maker3
drop if decision_maker3==.
ren decision_maker3 decision_maker
tempfile decision_maker3
save `decision_maker3'
restore


keep y4_hhid type_decision decision_maker1
drop if decision_maker1==.
ren decision_maker1 decision_maker
append using `decision_maker2'
append using `decision_maker3'
  

* number of time appears as decision maker
bysort y4_hhid decision_maker : egen nb_decision_participation=count(decision_maker)
drop if nb_decision_participation==1


gen make_decision_crop=1 if  type_decision=="planting_input" ///
							| type_decision=="harvest" ///
							| type_decision=="sales_annualcrop" ///
							| type_decision=="sales_permcrop" ///
							| type_decision=="sales_processcrop"
recode 	make_decision_crop (.=0)

gen make_decision_livestock=1 if  type_decision=="manage_livestock" 
recode 	make_decision_livestock (.=0)

gen make_decision_ag=1 if make_decision_crop==1 | make_decision_livestock==1
recode 	make_decision_ag (.=0)

collapse (max) make_decision_* , by(y4_hhid decision_maker )  //any decision


ren decision_maker indidy4 

* Now merge with member characteristics
merge 1:1 y4_hhid indidy4  using  "${created_data}\Tanzania_NPS_LSMS_ISA_W4_person_ids.dta", nogen 
* 1 member ID in decision files not in member list
 
recode make_decision_* (.=0)

lab var make_decision_crop "1=invidual makes decision about crop production activities"
lab var make_decision_livestock "1=invidual makes decision about livestock production activities"
lab var make_decision_ag "1=invidual makes decision about agricultural (crop or livestock) production activities"
save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_make_ag_decision.dta", replace

 
************
*WOMEN'S OWNERSHIP OF ASSETS
************
* Code as 1 if a woman is sole or joint owner of any specified productive asset; 
* can report on % of women who own, taking total number of women HH members as denominator
* In most cases, TZA LSMS 4 as the first TWO owners.
* Indicator may be biased downward if some women would have been not listed among the two the first 2 asset-owners can also claim ownership of some assets

*First, append all files with information on asset ownership
use "${raw_data}\Agriculture\ag_sec_3a.dta", clear
append using "${raw_data}\Agriculture\ag_sec_3b.dta" 
append using "${raw_data}\Livestock and Fisheries\lf_sec_05.dta"

gen type_asset=""
gen asset_owner1=.
gen asset_owner2=.

* Ownership of land.
replace type_asset="landowners" if  !inlist( ag3a_29_1, .,0,99) |  !inlist( ag3a_29_2, .,0,99) 
replace asset_owner1=ag3a_29_1 if !inlist( ag3a_29_1, .,0,99)  
replace asset_owner2=ag3a_29_1 if !inlist( ag3a_29_2, .,0,99)
replace type_asset="landowners" if  !inlist( ag3b_29_1, .,0,99) |  !inlist( ag3b_29_2, .,0,99) 
replace asset_owner1=ag3b_29_1 if !inlist( ag3b_29_1, .,0,99)  
replace asset_owner2=ag3b_29_1 if !inlist( ag3b_29_2, .,0,99)
* append who hss right to sell or use
preserve
replace type_asset="landowners" if  !inlist( ag3a_31_1, .,0,99) |  !inlist( ag3a_31_2, .,0,99) 
replace asset_owner1=ag3a_31_1 if !inlist( ag3a_31_1, .,0,99)  
replace asset_owner2=ag3a_31_2 if !inlist( ag3a_31_2, .,0,99)
replace type_asset="landowners" if  !inlist( ag3b_31_1, .,0,99) |  !inlist( ag3b_31_2, .,0,99) 
replace asset_owner1=ag3b_31_1 if !inlist( ag3b_31_1, .,0,99)  
replace asset_owner2=ag3b_31_2 if !inlist( ag3b_31_2, .,0,99)
keep if !inlist( ag3a_31_1, .,0,99) |  !inlist( ag3a_31_2, .,0,99)   | !inlist( ag3b_31_1, .,0,99) |  !inlist( ag3b_31_2, .,0,99) 
keep y4_hhid type_asset asset_owner*
tempfile land2
save `land2'
restore
append using `land2'  
 
*non-poultry livestock (keeps/manages)
replace type_asset="livestockowners" if  !inlist( lf05_01_1, .,0,99) |  !inlist( lf05_01_2, .,0,99)  
replace asset_owner1=lf05_01_1 if !inlist( lf05_01_1, .,0,99)  
replace asset_owner2=lf05_01_2 if !inlist( lf05_01_2, .,0,99)
    
  
* non-farm equipment,  large durables/appliances, mobile phone
* SECTION M: HOUSEHOLD ASSETS - does not report who in the household own them) 
* No ownership of non-farm equipment,  large durables/appliances, mobile phone

keep y4_hhid type_asset asset_owner1 asset_owner2  
 
preserve
keep y4_hhid type_asset asset_owner2
drop if asset_owner2==.
ren asset_owner2 asset_owner
tempfile asset_owner2
save `asset_owner2'
restore
 

keep y4_hhid type_asset asset_owner1
drop if asset_owner1==.
ren asset_owner1 asset_owner
append using `asset_owner2'
 

gen own_asset=1 

collapse (max) own_asset, by(y4_hhid asset_owner)
ren asset_owner indidy4
 
* Now merge with member characteristics
merge 1:1 y4_hhid indidy4  using  "${created_data}\Tanzania_NPS_LSMS_ISA_W4_person_ids.dta", nogen 
* 3 member ID in assed files not is member list
 
recode own_asset (.=0)
 
lab var own_asset "1=invidual owns an assets (land or livestock)"
save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_ownasset.dta", replace
 


**************
*AGRICULTURAL WAGES
**************
*Only long rainy season as the number of valid observation for SRS is too small (only 16 plots cultivated)
use "${raw_data}\Agriculture\ag_sec_3a.dta", clear
* The survey reports total wage paid and amount of hired labor: wage=total paid/ amount of labor
* set wage paid to . if zero or negative
recode ag3a_74_*(0=.)
* Sample size for children too small+ interviewer manure seemed to have suggested that children are not paid. THus focus on men and women.
ren ag3a_74_2 hired_male_lanprep
ren ag3a_74_1 hired_female_lanprep
ren ag3a_74_4 hlabor_paid_lanprep
ren ag3a_74_5 hired_male_weedingothers
ren ag3a_74_6 hired_female_weedingothers
ren ag3a_74_8 hlabor_paid_weedingothers
ren ag3a_74_14 hired_male_harvest
ren ag3a_74_13 hired_female_harvest
ren ag3a_74_16 hlabor_paid_harvest
*grouping of activities
recode hired* hlabor* (.=0)
gen wage_group1=(hlabor_paid_lanprep + hlabor_paid_weedingothers) /(hired_male_lanprep+hired_female_lanprep+hired_male_weedingothers+hired_female_weedingothers)
recode wage_group1 (0=.)
gen wage_group2=(hlabor_paid_harvest) /(hired_male_harvest+hired_female_harvest)
recode wage_group2 (0=.)
* Wage data not disagregated  by gender. Implicite assumption (but likely false) from the interviewer manual is that women and men are paid the same wage (DOUBLE CHECK THIS)
* set all 0 wage to missing 
recode wage_group1 wage_group2 (0=.)
** put in lon-form with a variable indicating activities group
preserve 
keep  y4_hhid plotnum wage_group1
ren wage_group1 all_wage
gen labor_group=1
label var labor_group "Activities grouping"
tempfile wage_group1
save `wage_group1'
restore
preserve 
keep y4_hhid plotnum wage_group2
ren wage_group2 all_wage
gen labor_group=2
label var labor_group "Activities grouping"
tempfile wage_group2
save `wage_group2'
restore
use `wage_group1', clear
append using `wage_group2'
count //11,074 obs
**NO GENDER DIFFERENTIATION
* get average average/meadian wage accross group of activities to wage at household level 
collapse (mean)  all_wage,by(y4_hhid labor_group)
gen wage_preharvest_activities = all_wage if labor_group==1
gen wage_harvest_activities = all_wage if labor_group==2
gen wage_all_activities=all_wage
bys y4_hhid: egen wage_preharvesft = max(wage_preharvest )
bys y4_hhid: egen wage_harvest = max(wage_harvest )
collapse (mean) wage_all_activities wage_preharvest_activities wage_harvest_activities, by(y4_hhid)
lab var wage_all_activities "Daily agricultural wage (local currency)"
lab var wage_preharvest_activities "Daily agricultural wage for pre-harvest activities (local currency)"
lab var wage_harvest_activities "Daily agricultural wage for harvest and post-harvest activities (local currency)"
save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_ag_wage.dta", replace


                                             
**************
*CROP YIELDS
**************

* crops
use "${raw_data}/Agriculture/ag_sec_4a.dta", clear
* Percent of area
gen pure_stand = ag4a_01==1
gen any_pure = pure_stand==1
gen any_mixed = pure_stand==0
gen percent_field = 0.25 if ag4a_02==1
replace percent_field = 0.50 if ag4a_02==2
replace percent_field = 0.75 if ag4a_02==3
replace percent_field = 1 if pure_stand==1
duplicates report y4_hhid plotnum zaocode		// There area 6 duplicates
duplicates drop y4_hhid plotnum zaocode, force	// The percent_field and pure_stand variables are the same, so dropping duplicates

*Total area on field
bys y4_hhid plotnum: egen total_percent_field = total(percent_field)			            // total on plot across ALL crops
replace percent_field = percent_field/total_percent_field if total_percent_field>1			// Rescaling
drop if plotnum==""
ren plotnum plot_id 
*Merging in variables from tzn4_field
merge m:1 y4_hhid plot_id using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_plot_areas.dta" , nogen keep(1 3)    // dropping those only in using
merge m:1 y4_hhid plot_id using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_plot_decision_makers" , nogen keep(1 3)
gen field_area =  area_acres_meas*(1/2.47105)
ren cultivated field_cultivated  
gen field_area_cultivated = field_area if field_cultivated==1
gen crop_area_planted = percent_field*field_area_cultivated 
keep crop_area_planted* y4_hhid plot_id zaocode dm_* any_* pure_stand dm_gender  field_area
save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_plot_crop_area.dta", replace

*Now to harvest
use "${raw_data}/Agriculture/ag_sec_4a.dta", clear
gen kg_harvest = ag4a_28
replace kg_harvest = 0 if ag4a_20==3
drop if kg_harvest==.							// dropping those with missing kg (to prevent collapsing problems below with zeros instead of missings)
gen area_harv_ha= ag4a_21*0.404686						//83 missing values all have quantity harvested=0
keep y4_hhid plotnum zaocode kg_harvest area_harv_ha
ren plotnum plot_id 
*Merging decision maker and intercropping variables
merge m:1 y4_hhid plot_id zaocode using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_plot_crop_area.dta", nogen keep(1 3)			// All matched

//Add production of permanent crops (cassava!)
preserve
use "${raw_data}/Agriculture/ag_sec_6b.dta", clear
keep if zaocode==21 //cassava
gen kg_harvest = ag6b_09
gen pure_stand = ag6b_05==2
gen any_pure = pure_stand==1
gen any_mixed = pure_stand==0
ren plotnum plot_id
merge m:1 y4_hhid plot_id using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_plot_areas.dta", nogen keep(1 3)	                // dropping those only in using
merge m:1 y4_hhid plot_id using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_plot_decision_makers" , nogen keep(1 3) 
gen field_area=area_acres_est*0.404686
gen area_harv_ha= field_area if ag6b_02!=. 	//set harvested area to field size; no area reported for perm crops; 23 missing values all have quantity harvested=0
keep y4_hhid plot_id zaocode kg_harvest area_harv_ha pure_stand any_pure any_mixed field_area dm_gender 
tempfile  cassava
save `cassava', replace
restore 
append using `cassava'

*rescaling area harvested to area planted if area harvested > area planted
replace area_harv_ha = field_area if area_harv_ha > field_area & area_harv_ha !=.
*1,193 changes made
replace area_harv_ha=. if area_harv_ha==0 //3 to missing

*Creating area and quantity variables by decision-maker and type of planting
ren kg_harvest harvest 
ren area_harv_ha area_harv 
ren any_mixed inter
gen harvest_male = harvest if dm_gender==1
gen area_harv_male = area_harv if dm_gender==1
gen harvest_female = harvest if dm_gender==2
gen area_harv_female = area_harv if dm_gender==2
gen harvest_mixed = harvest if dm_gender==3
gen area_harv_mixed = area_harv if dm_gender==3
gen area_harv_inter= area_harv if inter==1
gen area_harv_pure= area_harv if inter==0
gen harvest_inter= harvest if inter==1
gen harvest_pure= harvest if inter==0
gen harvest_inter_male= harvest if dm_gender==1 & inter==1
gen harvest_pure_male= harvest if dm_gender==1 & inter==0
gen harvest_inter_female= harvest if dm_gender==2 & inter==1
gen harvest_pure_female= harvest if dm_gender==2 & inter==0
gen harvest_inter_mixed= harvest if dm_gender==3 & inter==1
gen harvest_pure_mixed= harvest if dm_gender==3 & inter==0
gen area_harv_inter_male= area_harv if dm_gender==1 & inter==1
gen area_harv_pure_male= area_harv if dm_gender==1 & inter==0
gen area_harv_inter_female= area_harv if dm_gender==2 & inter==1
gen area_harv_pure_female= area_harv if dm_gender==2 & inter==0
gen area_harv_inter_mixed= area_harv if dm_gender==3 & inter==1
gen area_harv_pure_mixed= area_harv if dm_gender==3 & inter==0
collapse (sum) area_* /*count_**/ harvest* , by (y4_hhid zaocode)
global croplist "11, 12, 13, 32, 31, 47, 21"
keep if inlist( zaocode, $croplist)
recode zaocode (31 47=31)
*trimm area
*merging survey weights
merge m:1 y4_hhid using  "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hhids.dta", nogen keep(1 3)

global croplist "11 12 13 32 31 21"
foreach x of varlist area_harv* {
	foreach c of global croplist {
	di "`c'"
		_pctile `x'  [aw=weight]  if zaocode==`c' , p(1 99)
		replace `x' = r(r1) if `x' < r(r1)  & zaocode==`c'
		replace `x' = r(r2) if (`x' > r(r2) & `x' !=.)  &  zaocode==`c'
	}
}

*constructing area_weights
 
gen ar_wgt= weight*area_harv
gen ar_wgt_male = weight*area_harv_male if area_harv_male !=. 
gen ar_wgt_female = weight*area_harv_female if area_harv_female !=.
gen ar_wgt_mixed = weight*area_harv_mixed if area_harv_mixed !=.
gen ar_wgt_pure = weight*area_harv_pure if area_harv_pure !=.  
gen ar_wgt_inter = weight*area_harv_inter if area_harv_inter !=.  
gen ar_wgt_pure_male = weight*area_harv_pure_male if area_harv_pure_male !=.  
gen ar_wgt_pure_female = weight*area_harv_pure_female if area_harv_pure_female !=.  
gen ar_wgt_pure_mixed = weight*area_harv_pure_mixed if area_harv_pure_mixed !=.  
gen ar_wgt_inter_male = weight*area_harv_inter_male if area_harv_inter_male !=. 
gen ar_wgt_inter_female = weight*area_harv_inter_female if area_harv_inter_female !=. 
gen ar_wgt_inter_mixed = weight*area_harv_inter_mixed if area_harv_inter_mixed !=. 

* Now start estimate of yields by crop
*replacing all area harvested of 0 as missing (can't have area harvested =0)
foreach x of varlist area_*{
	replace `x'=. if `x'==0
}
gen yield = harvest/area_harv
gen yield_male = harvest_male/area_harv_male 
gen yield_female = harvest_female/area_harv_female
gen yield_mixed = harvest_mixed/area_harv_mixed 
gen yield_inter = harvest_inter/area_harv_inter
gen yield_pure = harvest_pure/area_harv_pure
gen yield_inter_male = harvest_inter_male/area_harv_inter_male
gen yield_inter_female = harvest_inter_female/area_harv_inter_female
gen yield_inter_mixed = harvest_inter_mixed /area_harv_inter_mixed
gen yield_pure_male = harvest_pure_male/area_harv_pure_male
gen yield_pure_female = harvest_pure_female/area_harv_pure_female
gen yield_pure_mixed = harvest_pure_mixed/area_harv_pure_mixed

*Winsorizing top 1% of final yield variables  // I don't think this should be for each variable (as it previously was), but rather for each crop.
global croplist "11 12 13 32 31 21"
foreach p of global  croplist {
	_pctile yield   [aw=weight]  if zaocode==`p', p(99)
	gen crop`p'_99th = r(r1)
}

foreach x of varlist yield* {
	replace `x' = crop11_99th if (zaocode==11 & `x' > crop11_99th & `x' !=.)
	replace `x' = crop12_99th if (zaocode==12 & `x' > crop12_99th & `x' !=.)
	replace `x' = crop13_99th if (zaocode==13 & `x' > crop13_99th & `x' !=.)
	replace `x' = crop21_99th if (zaocode==21 & `x' > crop21_99th & `x' !=.)
	replace `x' = crop31_99th if (zaocode==31 & `x' > crop31_99th & `x' !=.)
	replace `x' = crop32_99th if (zaocode==32 & `x' > crop32_99th & `x' !=.)
}
drop crop*_99th 
save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_crop_harvest_area_yield.dta", replace
  

  
 
*Yield at the household level
use "${created_data}/Tanzania_NPS_LSMS_ISA_W4_crop_harvest_area_yield.dta", clear
foreach v of varlist harvest*  area_harv* yield* ar_wgt*  {
	separate `v', by(zaocode)
	local `v'11 = subinstr("`v'11","11","_maize",1)
	ren `v'11  ``v'11'
	local `v'12 = subinstr("`v'12","12","_rice",1)
	ren `v'12  ``v'12'
	local `v'13 = subinstr("`v'13","13","_sorghum",1)
	ren `v'13  ``v'13'
	local `v'21 = subinstr("`v'21","21","_cassava",1)
	ren `v'21  ``v'21'
	local `v'31 = subinstr("`v'31","31","_beans",1)
	ren `v'31  ``v'31'
	local `v'32 = subinstr("`v'32","32","_cowpeas",1)
	ren `v'32  ``v'32'
}
collapse (firstnm) *maize *rice *sorghum *cassava *beans *cowpeas, by(y4_hhid)
recode  *maize *rice *sorghum *cassava *beans *cowpeas (0=.)
 
local vars maize rice  sorghum cassava beans cowpeas
foreach p of local vars {

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

lab var yield_`p' "Yield of `p' (kgs/ha) (household)" 
lab var yield_male_`p' "Yield of `p' (kgs/ha) (male-managed plots)" 
lab var yield_female_`p' "Yield of `p' (kgs/ha) (female-managed plots)" 
lab var yield_mixed_`p' "Yield of `p' (kgs/ha) (mixed-managed plots)"
lab var yield_pure_`p' "Yield of `p' (kgs/ha) - purestand (household)"
lab var yield_pure_male_`p'  "Yield of `p' (kgs/ha) - purestand (male-managed plots)"
lab var yield_pure_female_`p'  "Yield of `p' (kgs/ha) - purestand (female-managed plots)"
lab var yield_pure_mixed_`p'  "Yield of `p' (kgs/ha) - purestand (mixed-managed plots)"
lab var yield_inter_`p' "Yield of `p' (kgs/ha) - intercrop (household)"
lab var yield_inter_male_`p' "Yield of `p' (kgs/ha) - intercrop (male-managed plots)" 
lab var yield_inter_female_`p' "Yield of `p' (kgs/ha) - intercrop (female-managed plots)"
lab var yield_inter_mixed_`p' "Yield  of `p' (kgs/ha) - intercrop (mixed-managed plots)"

lab var ar_wgt_`p' "Area-adjusted weight for `p' (household)" 
lab var ar_wgt_male_`p' "Area-adjusted weight for `p' (male-managed plots)" 
lab var ar_wgt_female_`p' "Area-adjusted weight for `p' (female-managed plots)" 
lab var ar_wgt_mixed_`p' "Area-adjusted weight for `p' (mixed-managed plots)"
lab var ar_wgt_pure_`p' "Area-adjusted weight for `p' - purestand (household)"
lab var ar_wgt_pure_male_`p'  "Area-adjusted weight for `p' - purestand (male-managed plots)"
lab var ar_wgt_pure_female_`p'  "Area-adjusted weight for `p' - purestand (female-managed plots)"
lab var ar_wgt_pure_mixed_`p'  "Area-adjusted weight for `p' - purestand (mixed-managed plots)"
lab var ar_wgt_inter_`p' "Area-adjusted weight for `p' - intercrop (household)"
lab var ar_wgt_inter_male_`p' "Area-adjusted weight for `p' - intercrop (male-managed plots)" 
lab var ar_wgt_inter_female_`p' "Area-adjusted weight for `p' - intercrop (female-managed plots)"
lab var ar_wgt_inter_mixed_`p' "Area-adjusted weight for `p' - intercrop (mixed-managed plots)"

}
*drop cassava yield which are not valid since area harvested was not recorded
recode yield*cassava  (0/max=.)
save "${created_data}/Tanzania_NPS_LSMS_ISA_W4_yield_hh_crop_level.dta", replace
 
 

************************
*HOUSEHOLD VARIABLES
************************

use "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hhids.dta", clear

*Gross crop income 
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hh_crop_production.dta", nogen
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_crop_losses.dta", nogen
recode value_crop_production crop_value_lost (.=0)
*Variables: value_crop_production crop_value_lost

*Crop costs
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_asset_rental_costs.dta", nogen
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_land_rental_costs.dta", nogen
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_seed_costs.dta", nogen
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_fertilizer_costs.dta", nogen
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_wages_shortseason.dta", nogen
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_wages_mainseason.dta", nogen
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_transportation_cropsales.dta", nogen
recode rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor rental_cost_land cost_seed value_fertilizer /*
*/ value_herbicide value_pesticide value_manure_purchased wages_paid_shortseason wages_paid_mainseason transport_costs_cropsales (.=0)
egen crop_production_expenses = rowtotal(rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor rental_cost_land cost_seed value_fertilizer /*
*/ value_herbicide value_pesticide value_manure_purchased wages_paid_shortseason wages_paid_mainseason transport_costs_cropsales)
gen crop_income = value_crop_production - crop_production_expenses - crop_value_lost
lab var crop_production_expenses "Crop production expenditures (explicit)"
lab var crop_income "Net crop revenue (value of production minus crop expenses)"

*Livestock income
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_sales", nogen
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hh_livestock_products", nogen
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_dung.dta", nogen
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_livestock_expenses", nogen
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_TLU.dta", nogen
gen livestock_income = value_livestock_sales - value_livestock_purchases /*
*/ + (value_milk_produced + value_eggs_produced + value_other_produced + sales_dung) /*
*/ - (cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_water_livestock)
lab var livestock_income "Net livestock income (value of production and consumption minus expenditures)"

*Fish income
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_fish_income.dta", nogen
merge 1:1 y4_hhid using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_fishing_expenses_1.dta", nogen
merge 1:1 y4_hhid using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_fishing_expenses_2.dta", nogen
gen fishing_income = value_fish_harvest - cost_fuel - rental_costs_fishing - cost_paid
lab var fishing_income "Net fish income (value of production and consumption minus expenditures)"


*Self-employment income
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_self_employment_income.dta", nogen
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_fish_trading_income.dta", nogen
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_agproducts_profits.dta", nogen
egen self_employment_income = rowtotal(annual_selfemp_profit fish_trading_income byproduct_profits)
*Variables: self_employment_income
lab var self_employment_income "Income from self-employment (business)"

*Wage income
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_wage_income.dta", nogen
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_agwage_income.dta", nogen
recode annual_salary annual_salary_agwage (.=0)
rename annual_salary wage_income
rename annual_salary_agwage agwage_income
*Variables: wage_income agwage_income

*Other income

merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_other_income.dta", nogen
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_land_rental_income.dta", nogen
egen other_income_sources = rowtotal (rental_income pension_income other_income remittance_income assistance_income land_rental_income)
lab var other_income_sources "Income from transfers, remittances, other revenue streams not captured elsewhere"


*Farm size
merge 1:1 y4_hhid using  "${created_data}\Tanzania_NPS_LSMS_ISA_W4_land_size.dta", nogen
merge 1:1 y4_hhid using  "${created_data}\Tanzania_NPS_LSMS_ISA_W4_land_size_all.dta", nogen
merge 1:1 y4_hhid using  "${created_data}\Tanzania_NPS_LSMS_ISA_W4_farmsize_all_agland.dta", nogen
recode land_size (.=0)

*Labor
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_family_hired_labor.dta", nogen
 
*Household size
merge 1:1 y4_hhid using  "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hhsize.dta", nogen
 
*Rates of vaccine usage, improved seeds, etc.
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_vaccine.dta", nogen
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_fert_use.dta", nogen
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_improvedseed_use.dta", nogen
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_any_ext.dta", nogen
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_fin_serv.dta", nogen
*Variables: use_fin_serv ext_reach use_inorg_fert vac_animal
recode use_fin_serv ext_reach use_inorg_fert imprv_seed_use vac_animal (.=0)
replace vac_animal=. if tlu_today==0 
replace use_inorg_fert=. if farm_area==0 | farm_area==. // Area cultivated this year
replace ext_reach=. if (value_crop_production==0 & livestock_income==0 & farm_area==0 & tlu_today==0)
replace ext_reach=. if farm_area==.
replace imprv_seed_use=. if farm_area==.
*use_fin_serv=. if (value_crop_production==0 & livestock_income==0 & farm_area==0 & tlu_today==0) // It seems like this can be relevant for all households.

*Milk productivity
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_milk_animals.dta", nogen
*Egg productivity
merge 1:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_eggs_animals.dta", nogen


*Costs of crop production per hectare
merge 1:1 y4_hhid using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_cropcosts_perha.dta", nogen

*Rate of fertilizer application 
merge 1:1 y4_hhid using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_fertilizer_application.dta", nogen

*Agricultural wage rate
merge 1:1 y4_hhid using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_ag_wage.dta", nogen
ren wage_all_activities all_wage
drop  wage_preharvest_activities wage_harvest_activities
*Crop yields 
merge 1:1 y4_hhid using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_yield_hh_crop_level.dta", nogen


*Identify agricultural households
gen ag_hh = (value_crop_production!=0 | livestock_income!=0 | (farm_area!=0 & farm_area!=.) | tlu_today!=0)
lab var ag_hh "1= Agricultural household"
count if ag_hh==1  

*Address outliers
global income_vars crop livestock fishing self_employment wage agwage other // Winsorize income variables
foreach p of global income_vars {
_pctile `p'_income  [aw=weight] , p(1 99) 
replace `p'_income = r(r1) if `p'_income < r(r1)  & `p'_income!=.
replace `p'_income = r(r2) if `p'_income > r(r2)  & `p'_income!=.
}
global wins_vars farm_area farm_size_agland costs_total_hh costs_total_hh_male costs_total_hh_female costs_total_hh_mixed /*
*/ costs_total_explicit_hh costs_total_explicit_hh_male costs_total_explicit_hh_female costs_total_explicit_hh_mixed // Winsorize other variables (99th percentile only)
foreach p of global wins_vars {
_pctile `p'  [aw=weight]  , p(99) 
replace `p' = r(r1) if `p' > r(r1) & `p'!=.
}
global wins_vars ha_planted ha_planted_male ha_planted_female ha_planted_mixed liters_per_largeruminant   egg_poultry_year /*egg and milk*/ inorg_fert_rate inorg_fert_rate_male /*
*/ inorg_fert_rate_female inorg_fert_rate_mixed all_wage // Winsorize other variables (1st and 99th percentile)
foreach p of global wins_vars {
_pctile `p'  [aw=weight] , p(1 99) 
replace `p' = r(r1) if `p' < r(r1) & `p'!=.
replace `p' = r(r2) if `p' > r(r2) & `p'!=.
}

*Create final income variables
egen total_income = rowtotal(crop_income livestock_income fishing_income self_employment_income wage_income agwage_income other_income)
egen nonfarm_income = rowtotal(fishing_income self_employment_income wage_income other_income)
egen farm_income = rowtotal(crop_income livestock_income)
gen share_nonfarm = nonfarm_income/total_income
replace share_nonfarm = 0 if nonfarm_income < 0
replace share_nonfarm = . if total_income < 0
gen percapita_income = total_income/hh_members
gen land_productivity = value_crop_production/farm_area
gen labor_productivity = value_crop_production/labor_total  
global productivity_vars land_productivity labor_productivity // Winsorize productivity vars
foreach p of global productivity_vars {
_pctile `p'  [aw=weight] , p(1 99) 
replace `p' = r(r1) if `p' < r(r1) & `p' != . 
replace `p' = r(r2) if `p' > r(r2) & `p' != . 
}
foreach p of global income_vars {
gen share_`p' = `p'_income / total_income
replace share_`p' = 0 if nonfarm_income < 0
replace share_`p' = . if total_income < 0
lab var share_`p' "Share of household income from `p'"
}

*Convert monetary values to 2016 Purchasing Power Parity international dollars
global exchange_rate 2158
global ppp_dollar 691.41   // https://data.worldbank.org/indicator/PA.NUS.PPP
global inflation 0.04933815  // inflation rate 2015-2016. Data was collectedduring oct2014-2015. We want to ajhust value to 2016
*Global inflation 0.04933815
rename costs_total_explicit_hh_female costs_total_explicit_hh_fem
rename costs_total_explicit_hh_mixed costs_explicit_hh_mix
global monetary_vars crop_income livestock_income percapita_income total_income nonfarm_income farm_income land_productivity labor_productivity /*
*/ all_wage costs_total_hh costs_total_hh_male costs_total_hh_female costs_total_hh_mixed /*
*/ costs_total_explicit_hh costs_total_explicit_hh_male costs_total_explicit_hh_fem costs_explicit_hh_mix
foreach p of global monetary_vars {
gen `p'_ppp = `p' / (${ppp_dollar}/(1+$inflation))
}
foreach p of global monetary_vars {
gen `p'_usd = `p' / (${exchange_rate}/(1+$inflation))   
}


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

lab var costs_total_hh_ppp "Explicit + implicit costs of crop production (household level) per ha (PPP $)"
lab var costs_total_hh_male_ppp "Explicit + implicit costs of crop production (male-managed crops) per ha (PPP $)"
lab var costs_total_hh_female_ppp "Explicit + implicit costs of crop production (female-managed crops) per ha (PPP $)"
lab var costs_total_hh_mixed_ppp "Explicit + implicit costs of crop production (mixed-managed crops) per ha (PPP $)"
lab var costs_total_explicit_hh_ppp "Explicit costs of crop production (household level) per ha (PPP $)"
lab var costs_total_explicit_hh_male_ppp "Explicit costs of crop production (male-managed crops) per ha (PPP $)"
lab var costs_total_explicit_hh_fem_ppp "Explicit costs of crop production (female-managed crops) per ha (PPP $)"
lab var costs_explicit_hh_mix_ppp "Explicit costs of crop production (mixed-managed crops) per ha (PPP $)"
lab var all_wage_ppp "Daily wage (PPP $ / workday)"
lab var farm_income_ppp "Farm income (PPP $)"
lab var crop_income_ppp "Crop income (PPP $)"
lab var livestock_income_ppp "Livestock income (PPP $)"
lab var percapita_income_ppp "Per capita income (PPP $)"
lab var total_income_ppp "Total household income (PPP $)"
lab var nonfarm_income_ppp "Nonfarm income (excludes agricultural wages)(PPP $)"
lab var land_productivity_ppp "Land productivity (gross value production per ha cultivated) (PPP $)"

lab var costs_total_hh_usd "Explicit + implicit costs of crop production (household level) per ha (2016 $USD)"
lab var costs_total_hh_male_usd "Explicit + implicit costs of crop production (male-managed crops) per ha (2016 $USD)"
lab var costs_total_hh_female_usd "Explicit + implicit costs of crop production (female-managed crops) per ha (2016 $USD)"
lab var costs_total_hh_mixed_usd "Explicit + implicit costs of crop production (mixed-managed crops) per ha (2016 $USD)"
lab var costs_total_explicit_hh_usd "Explicit costs of crop production (household level) per ha (2016 $USD)"
lab var costs_total_explicit_hh_male_usd "Explicit costs of crop production (male-managed crops) per ha (2016 $USD)"
lab var costs_total_explicit_hh_fem_usd "Explicit costs of crop production (female-managed crops) per ha (2016 $USD)"
lab var costs_explicit_hh_mix_usd "Explicit costs of crop production (mixed-managed crops) per ha (2016 $USD)"
lab var all_wage_usd "Daily wage (2016 $USD / workday)"
lab var farm_income_usd "Farm income (2016 $USD)"
lab var crop_income_usd "Crop income (2016 $USD)"
lab var livestock_income_usd "Livestock income (2016 $USD)"
lab var percapita_income_usd "Per capita income (2016 $USD)"
lab var total_income_usd "Total household income (2016 $USD)"
lab var nonfarm_income_usd "Nonfarm income (excludes agricultural wages)(2016 $USD)"
lab var land_productivity_usd "Land productivity (gross value production per ha cultivated) (2016 $USD)"
lab var labor_productivity_usd "Labor productivity (gross value production per labor-day) (2016 $USD)"
lab var total_income "Total household income in local currency"
lab var share_nonfarm "Share of household income derived from nonfarm sources"
lab var percapita_income "Household incom per household member per day, in the local currency"
lab var land_productivity "Gross crop income per hectare cultivated, in the local currency"
lab var labor_productivity "Gross crop income per labor-day on the farm, in the local currency"
lab var ag_hh "1= Household has some land cultivated, some livestock, some crop income, or some livestock income"
lab var farm_income "Farm income (local currency)"
lab var nonfarm_income "Non farm income (local currency)"
save "${final_data}/Tanzania_NPS_LSMS_ISA_W4_household_variables.dta", replace



**************
*INDIVIDUAL-LEVEL VARIABLES
**************
use "${created_data}\Tanzania_NPS_LSMS_ISA_W4_person_ids.dta", clear
merge m:1 y4_hhid   using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_household_diet.dta", nogen
merge 1:1 y4_hhid indidy4 using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_control_income.dta", nogen  keep(1 3)
merge 1:1 y4_hhid indidy4 using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_make_ag_decision.dta", nogen  keep(1 3)
merge 1:1 y4_hhid indidy4 using "${created_data}/Tanzania_NPS_LSMS_ISA_W4_ownasset.dta", nogen  keep(1 3)
merge m:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hhsize.dta", nogen keep (1 3)
merge m:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hhids.dta", nogen keep (1 3)
*merge in hh variable tpo determin ag household
merge m:1 y4_hhid using "${final_data}/Tanzania_NPS_LSMS_ISA_W4_household_variables.dta", nogen keep (1 3)
drop value_crop_production- ar_wgt_inter_mixed_cowpeas total_income - small_farm_household
replace   make_decision_ag =. if ag_hh==0
save "${final_data}/Tanzania_NPS_LSMS_ISA_W4_individual_variables.dta", replace
 
**************
*SUMMARY STATISTICS
************** 
/*
All the pre-processed files include all households, individuals, and plots in the sample. 
The summary statistics are outputted only for the sub_population of households, individuals, and plots in rural areas. 
To consider a different sup_population or the entire sample, you have to modify the condition "if rural==1".
*/ 

use "${final_data}/Tanzania_NPS_LSMS_ISA_W4_household_variables.dta", replace
** Statistics list 1 -   share_nonfarm nonfarm_income_usd total_income_usd all_wage_usd
global household_indicators1 share_nonfarm nonfarm_income_usd total_income_usd total_income_ppp 
global final_indicator1  
foreach v of global household_indicators1 {
	gen `v'_female_hh=`v' if fhh==1
	gen `v'_male_hh=`v' if fhh==0
	global final_indicator1 $final_indicator1 `v'  `v'_female_hh  `v'_male_hh
}
gen female_wage_usd_female_hh=0   
gen male_wage_usd_female_hh=0  if fhh==0
global final_indicator1 $final_indicator1 all_wage_usd  female_wage_usd_female_hh male_wage_usd_female_hh
tabstat ${final_indicator1} [aw=weight] if rural==1, stat(mean semean sd p25 p50 p75  min max N) col(stat) save
matrix final_indicator1=r(StatTotal)'
qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered) // get standard errors of the mean
matrix semean1=(.)
matrix colnames semean1=semean_wei
foreach v of global final_indicator1 {
	qui svy, subpop(if rural==1): mean `v'
	matrix semean1=semean1\(el(r(table),2,1))
}
matrix final_indicator1=final_indicator1,semean1[2..rowsof(semean1),.]
matrix list final_indicator1 


** Statistics list 2 - labor_productivity_usd land_productivity_usd
gen labor_weight=weight*labor_total
gen land_weight=weight*farm_area
matrix final_indicator2=(.,.,.,.,.,.,.,.,.,.)
global household_indicators2  labor  land 
foreach v of global household_indicators2 {
	global final_indicator2 ""	
	gen `v'_female_hh=`v'_productivity_usd if fhh==1
	gen `v'_male_hh=`v'_productivity_usd if fhh==0
	global final_indicator2 $final_indicator2 `v'_productivity_usd  `v'_female_hh  `v'_male_hh
	tabstat $final_indicator2 [aw=`v'_weight] if rural==1, stat(mean semean sd p25 p50 p75  min max N) col(stat) save
	matrix temp2=r(StatTotal)'	
	qui svyset clusterid [pweight=`v'_weight], strata(strataid) singleunit(centered) // get standard errors of the mean
	matrix semean2=(.)
	matrix colnames semean2=semean_wei
	foreach v of global final_indicator2 {
		qui svy, subpop(if rural==1): mean `v'
		matrix semean2=semean2\(el(r(table),2,1))
	}
	matrix temp2=temp2,semean2[2..rowsof(semean2),.]
	matrix final_indicator2=final_indicator2\temp2
}	
matrix final_indicator2 =final_indicator2[2..rowsof(final_indicator2), .]
matrix list final_indicator2 


 
** Statistics list 4  - yields 
global final_indicator4 beans female_beans male_beans mixed_beans /*
*/ cowpeas female_cowpeas male_cowpeas mixed_cowpeas/*
*/ maize female_maize male_maize mixed_maize/*
*/ rice female_rice male_rice mixed_rice/*
*/ sorghum female_sorghum male_sorghum mixed_sorghum/*
*/ cassava female_cassava male_cassava mixed_cassava/*
*/ pure_beans pure_female_beans pure_male_beans pure_mixed_beans/*
*/ pure_cowpeas pure_female_cowpeas pure_male_cowpeas pure_mixed_cowpeas/*
*/ pure_maize pure_female_maize pure_male_maize pure_mixed_maize/*
*/ pure_rice pure_female_rice pure_male_rice pure_mixed_rice/*
*/ pure_sorghum pure_female_sorghum pure_male_sorghum pure_mixed_sorghum/*
*/ pure_cassava pure_female_cassava pure_male_cassava pure_mixed_cassava/*
Cassava yield does not make send because areab harvested not reported*//*
*/
recode yield*cassava  (.=0)    
matrix final_indicator4=(.,.,.,.,.,.,.,.,.,.)
foreach v of global final_indicator4 {
	tabstat yield_`v' [aw=ar_wgt_`v'] if rural==1, stat(mean semean sd p25 p50 p75  min max N) col(stat) save
	matrix temp4=r(StatTotal)'
	qui svyset clusterid [pweight=ar_wgt_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean	
	capture noisily qui svy, subpop(if rural==1): mean yield_`v'
	matrix final_indicator4=final_indicator4\(temp4,el(r(table),2,1))	
}
matrix final_indicator4 =final_indicator4[2..rowsof(final_indicator4), .]
matrix list final_indicator4 

** Statistics list 5  - milk and egg productivities
ren liters_per_largeruminant liters_per_all
gen liters_per_cow=0  /*not possible for TZA so all is missing*/
gen liters_per_buffalo=0 /*not possible for TZA so all is missing*/

gen weight_milk=milk_animals*weight
gen weight_egg=poultry_owned*weight
global household_indicators5 liters_per_all liters_per_cow liters_per_buffalo egg_poultry_year
global final_indicator5  
foreach v of global household_indicators5 {
	gen `v'_female_hh=`v' if fhh==1
	gen `v'_male_hh=`v' if fhh==0
	global final_indicator5 $final_indicator5 `v'  `v'_female_hh  `v'_male_hh
}

global milkvar liters_per_all liters_per_all_female_hh liters_per_all_male_hh liters_per_cow liters_per_cow_female_hh liters_per_cow_male_hh liters_per_buffalo liters_per_buffalo_female_hh liters_per_buffalo_male_hh
tabstat $milkvar  [aw=weight_milk] if rural==1 , stat(mean semean sd p25 p50 p75  min max N) col(stat) save 
matrix final_indicator5=r(StatTotal)' 
qui svyset clusterid [pweight=weight_milk], strata(strataid) singleunit(centered) // get standard errors of the mean	
matrix semean5=(.)
matrix colnames semean5=semean_wei
foreach v of global milkvar {
	qui svy, subpop(if rural==1): mean `v'
	matrix semean5=semean5\(el(r(table),2,1))
}
matrix final_indicator5=final_indicator5,semean5[2..rowsof(semean5),.]

global eggvar egg_poultry_year egg_poultry_year_female_hh egg_poultry_year_male_hh
tabstat $eggvar [aw=weight_egg] if rural==1, stat(mean semean sd p25 p50 p75  min max N) col(stat) save
matrix temp5=r(StatTotal)' 
matrix semean5=(.)
matrix colnames semean5=semean_wei
foreach v of global eggvar {
	qui svy, subpop(if rural==1): mean `v'
	matrix semean5=semean5\(el(r(table),2,1))
}
matrix temp5=temp5,semean5[2..rowsof(semean5),.]
matrix final_indicator5=final_indicator5\temp5
matrix list final_indicator5 

 
** Statistics list 7  - percapita_income_usd crop_income_usd livestock_income_usd
global household_indicators7  percapita_income_usd percapita_income_ppp crop_income_usd livestock_income_usd
global final_indicator7  
foreach v of global household_indicators7 {
	gen `v'_female_hh=`v' if fhh==1
	gen `v'_male_hh=`v' if fhh==0
	global final_indicator7 $final_indicator7 `v'  `v'_female_hh  `v'_male_hh
}
tabstat ${final_indicator7} [aw=weight]  if rural==1, stat(mean semean sd p25 p50 p75  min max N) col(stat) save
matrix final_indicator7=r(StatTotal)'
qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered) // get standard errors of the mean
matrix semean7=(.)
matrix colnames semean7=semean_wei
foreach v of global final_indicator7 {
	qui svy, subpop(if rural==1): mean `v'
	matrix semean7=semean7\(el(r(table),2,1))
}
matrix final_indicator7=final_indicator7,semean7[2..rowsof(semean7),.]
matrix list final_indicator7 


** Statistics list 9 -  imprv_seed_use
gen imprv_seed_use_all_hh=imprv_seed_use if rural==1 
gen imprv_seed_use_female_hh=imprv_seed_use if rural==1 & fhh==1
gen imprv_seed_use_male_hh=imprv_seed_use if rural==1 & fhh==0
gen imprv_seed_use_shf=imprv_seed_use if rural==1 & small_farm_household==1

global final_indicator9 imprv_seed_use_all_hh imprv_seed_use_female_hh  imprv_seed_use_male_hh imprv_seed_use_shf   
tabstat ${final_indicator9} [aw=weight]  if ag_hh==1 & rural==1, stat(mean semean sd p25 p50 p75  min max N) col(stat) save
matrix final_indicator9=r(StatTotal)'
qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered) // get standard errors of the mean
matrix semean9=(.)
matrix colnames semean9=semean_wei
foreach v of global final_indicator9 {
	qui svy, subpop(if rural==1 & ag_hh==1): mean `v'
	matrix semean9=semean9\(el(r(table),2,1))
}
matrix final_indicator9=final_indicator9,semean9[2..rowsof(semean9),.]
matrix list final_indicator9 


** Statistics list 10  - inorg_fert_rate_all
ren inorg_fert_rate inorg_fert_rate_all
ren ha_planted ha_planted_all
global final_indicator10 all male female mixed
matrix final_indicator10=(.,.,.,.,.,.,.,.,.,.)
foreach v of global final_indicator10 {
	gen  area_weight_`v'=weight*ha_planted_`v'
	tabstat inorg_fert_rate_`v' [aw=area_weight_`v'] if rural==1 & ag_hh==1 , stat(mean semean sd p25 p50 p75  min max N) col(stat) save
	matrix temp10=r(StatTotal)'
	qui svyset clusterid [pweight=area_weight_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean	
	capture noisily qui svy, subpop(if rural==1& ag_hh==1): mean inorg_fert_rate_`v'
	matrix final_indicator10=final_indicator10\(temp10,el(r(table),2,1))
}
matrix final_indicator10 =final_indicator10[2..rowsof(final_indicator10), .]
matrix list final_indicator10 
 
 
** Statistics list 11 -  use_inorg_fert vac_animal ext_reach use_fin_serv 
global household_indicators11 use_inorg_fert vac_animal ext_reach use_fin_serv 
global final_indicator11 ""
foreach v of global household_indicators11 {
	gen `v'_all_hh=`v' if  rural==1 
	gen `v'_female_hh=`v' if  rural==1  &  fhh==1
	gen `v'_male_hh=`v' if  rural==1  & fhh==0
	gen `v'_shf=`v' if rural==1 & small_farm_household==1
	global final_indicator11 $final_indicator11 `v'_all_hh   `v'_female_hh  `v'_male_hh `v'_shf
}
tabstat ${final_indicator11} [aw=weight]  if rural==1 & ag_hh==1, stat(mean semean sd p25 p50 p75  min max N) col(stat) save
matrix final_indicator11=r(StatTotal)'
qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered) // get standard errors of the mean
matrix semean11=(.)
matrix colnames semean11=semean_wei
foreach v of global final_indicator11 {
	qui svy, subpop(if rural==1): mean `v'
	matrix semean11=semean11\(el(r(table),2,1))
}
matrix final_indicator11=final_indicator11,semean11[2..rowsof(semean11),.]
matrix list final_indicator11 


** Statistics list 12 - costs_total_hh_usd 
ren costs_total_hh_usd  costs_total_hh_all_usd 
global final_indicator12 all female male  mixed
matrix final_indicator12=(.,.,.,.,.,.,.,.,.,.)
foreach v of global final_indicator12 {
	tabstat costs_total_hh_`v'_usd  [aw=area_weight_`v']  if rural==1 & ag_hh==1, stat(mean semean sd p25 p50 p75  min max N) col(stat) save
	matrix temp12=r(StatTotal)'
	qui svyset clusterid [pweight=area_weight_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean	
	capture noisily qui svy, subpop(if rural==1 & ag_hh==1): mean costs_total_hh_`v'_usd
	matrix final_indicator12=final_indicator12\(temp12,el(r(table),2,1))
}
matrix final_indicator12 =final_indicator12[2..rowsof(final_indicator12), .]
matrix list final_indicator12 

 
 
** Statistics list 13 - costs_total_explicit_hh_usd
ren costs_total_explicit_hh_usd costs_total_explicit_hh_all_usd     
ren costs_explicit_hh_mix_usd costs_total_explicit_hh_mix_usd
global final_indicator13 all fem male  mix
matrix final_indicator13=(.,.,.,.,.,.,.,.,.,.)
foreach v of global final_indicator13 {
	tabstat costs_total_explicit_hh_`v'_usd   [aw=area_weight_`v']   if rural==1 & ag_hh==1, stat(mean semean sd p25 p50 p75  min max N) col(stat) save
	matrix temp13=r(StatTotal)'
	qui svyset clusterid [pweight=area_weight_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean	
	capture noisily qui svy, subpop(if rural==1 & ag_hh==1): mean costs_total_explicit_hh_`v'_usd
	matrix final_indicator13=final_indicator13\(temp13,el(r(table),2,1))
}
matrix final_indicator13 =final_indicator13[2..rowsof(final_indicator13), .]
matrix list final_indicator13 
 
 
** Statistics list 14 - proportion_cropvalue_sold
gen prop_cropvalue_sold_all=proportion_cropvalue_sold  
gen prop_cropvalue_sold_female_hh=proportion_cropvalue_sold  if fhh==1
gen prop_cropvalue_sold_male_hh=proportion_cropvalue_sold if  fhh==0
global final_indicator14 prop_cropvalue_sold_all prop_cropvalue_sold_female_hh  prop_cropvalue_sold_male_hh   
tabstat ${final_indicator14} [aw=weight]   if rural==1 & ag_hh==1, stat(mean semean sd p25 p50 p75  min max N) col(stat) save
matrix final_indicator14=r(StatTotal)'
qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered) // get standard errors of the mean
matrix semean14=(.)
matrix colnames semean14=semean_wei
foreach v of global final_indicator14 {
	qui svy, subpop(if rural==1): mean `v'
	matrix semean14=semean14\(el(r(table),2,1))
}
matrix final_indicator14=final_indicator14,semean14[2..rowsof(semean14),.]
matrix list final_indicator14 


** Statistics list 16 - farm_size_agland
gen farm_size_agland_all=farm_size_agland  
gen farm_size_agland_female_hh=farm_size_agland  if fhh==1
gen farm_size_agland_male_hh=farm_size_agland if  fhh==0
global final_indicator16 farm_size_agland_all farm_size_agland_female_hh  farm_size_agland_male_hh   
tabstat ${final_indicator16} [aw=weight]   if rural & ag_hh==1, stat(mean semean sd p25 p50 p75  min max N) col(stat) save
matrix final_indicator16=r(StatTotal)'
qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered) // get standard errors of the mean
matrix semean16=(.)
matrix colnames semean16=semean_wei
foreach v of global final_indicator14 {
	qui svy, subpop(if rural==1): mean `v'
	matrix semean16=semean16\(el(r(table),2,1))
}
matrix final_indicator16=final_indicator16,semean16[2..rowsof(semean16),.]
matrix list final_indicator16 


** Statistics list 3 - plot_productivity_usd
use  "${final_data}\Tanzania_NPS_LSMS_ISA_W4_gender_productivity_gap.dta",  clear
*(Mean_Male-Mean_Female)/Mean_Male
qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered) // get standard errors of the mean
tabstat plot_productivity_usd  [aw=plot_weight]  if rural==1 & dm_gender!=.    , stat(mean semean sd p25 p50 p75  min max N) col(stat) save
matrix temp_all=r(StatTotal)'
qui svy, subpop(if rural==1 & dm_gender!=. ): mean plot_productivity_usd
matrix plot_productivity_all_usd=temp_all,el(r(table),2,1)
 

tabstat plot_productivity_usd  [aw=plot_weight]   if rural==1 & dm_gender==1 , stat(mean semean sd p25 p50 p75  min max N) col(stat) save
matrix temp_female=r(StatTotal)'
qui svy, subpop(if rural==1 & dm_gender==1): mean plot_productivity_usd
matrix plot_productivity_female_usd=temp_female,el(r(table),2,1)
 
tabstat plot_productivity_usd  [aw=plot_weight]   if rural==1 & dm_gender==2 , stat(mean semean sd p25 p50 p75  min max N) col(stat) save
matrix temp_male=r(StatTotal)'
qui svy, subpop(if rural==1 & dm_gender==2): mean plot_productivity_usd
matrix plot_productivity_male_usd=temp_male,el(r(table),2,1)
 
tabstat plot_productivity_usd  [aw=plot_weight]   if rural==1 & dm_gender==2 , stat(mean semean sd p25 p50 p75  min max N) col(stat) save
matrix temp_mixed=r(StatTotal)'
qui svy, subpop(if rural==1 & dm_gender==3): mean plot_productivity_usd
matrix plot_productivity_mixed_usd=temp_mixed,el(r(table),2,1)
  
matrix final_indicator3=(plot_productivity_all_usd\plot_productivity_female_usd\plot_productivity_male_usd\plot_productivity_mixed_usd)
matrix list final_indicator3 



** Statistics list 6 - gender_prod_gap1
*(Mean_Male-Mean_Female)/Mean_Male
tabstat gender_prod_gap1 , stat(mean semean sd p25 p50 p75  min max N) col(stat) save
matrix final_indicator6=r(StatTotal)',.
matrix list final_indicator6 

** Statistics list 8  - women diet - not available
matrix final_indicator8=J(6,10,.)
matrix list final_indicator8 

** Statistics list 15
* Keep only adult women
use "${final_data}/Tanzania_NPS_LSMS_ISA_W4_individual_variables.dta", clear
merge m:1 y4_hhid using "${created_data}\Tanzania_NPS_LSMS_ISA_W4_hhids.dta", nogen
keep if female==1
keep if age>=18
global household_indicators15 control_all_income make_decision_ag own_asset    /*number_foodgroup women_diet*/
global final_indicator15 ""
foreach v of global household_indicators15 {
	gen `v'_female_hh=`v' if  fhh==1
	gen `v'_male_hh=`v' if fhh==0
	global final_indicator15 $final_indicator15 `v'  `v'_female_hh  `v'_male_hh 
}
tabstat ${final_indicator15} [aw=weight] if rural==1 , stat(mean semean sd  p25 p50 p75  min max N) col(stat) save
matrix final_indicator15=r(StatTotal)'
qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered) // get standard errors of the mean
matrix semean15=(.)
matrix colnames semean15=semean_wei
foreach v of global final_indicator15 {
	qui svy, subpop(if rural==1): mean `v'
	matrix semean15=semean15\(el(r(table),2,1))
}
matrix final_indicator15=final_indicator15,semean15[2..rowsof(semean15),.]
matrix list final_indicator15 

* All together
matrix final_indicator_all =(.,.,.,.,.,.,.,.,.,.)
forvalue i=1/16 {
	matrix final_indicator_all=final_indicator_all\final_indicator`i'
}
matrix final_indicator_all =final_indicator_all[2..rowsof(final_indicator_all), .] 
matrix list final_indicator_all 
matrix colname final_indicator_all =  mean semean_simple sd p25 p50 p75 min max N semean_strata
* Export to Excel
putexcel set "$final_data\Tanzania_NPS_LSMS_ISA_W4_summary_stats.xlsx", replace
putexcel A1=matrix(final_indicator_all)  , names 
