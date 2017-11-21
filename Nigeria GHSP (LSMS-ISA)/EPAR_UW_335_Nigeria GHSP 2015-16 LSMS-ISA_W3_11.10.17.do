
/*-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of a set of agricultural development indicators 
				  using the Nigeria General Household Survey (GHS) LSMS-ISA Wave 3 (2015-16)
*Author(s)		: Jack Knauer, David Coomes, Didier Alia, Ayala Wineman, Josh Merfeld, Pierre Biscaye, C. Leigh Anderson, &  Travis Reynolds

*Acknowledgments: We acknowledge the helpful contributions of members of the World Bank's LSMS-ISA team, the FAO's RuLIS team, IFPRI, IRRI, 
				  and the Bill & Melinda Gates Foundation Agricultural Development Data and Policy team in discussing indicator construction decisions. 
				  All coding errors remain ours alone.
*Date			: 10 November 2017
----------------------------------------------------------------------------------------------------------------------------------------------------*/


*Data source
*-----------
*The Nigeria General Household Survey was collected by the Nigeria National Bureau of Statistics (NBS) 
*and the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture(LSMS - ISA)
*The data were collected over the period  September - October 2015, November - December 2015, and February - April 2016.
*All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
*http://microdata.worldbank.org/index.php/catalog/2734

*Throughout the do-file, we sometimes use the shorthand LSMS to refer to the Nigeria General Household Survey .


*Summary of Executing the Master do.file
*-----------
*This Master do.file constructs selected indicators using the Nigeria General Household Survey (NG LSMS) data set.
*First, save the raw unzipped data files from the World Bank in the "Raw DTA files\Wave 3 (2015-16)" folder  
*The do.file draws on these raw data files to first construct common and intermediate variables, saving dta files when appropriate 
*in the folder "Final DTA files\Wave 3 (2015-16)\created_data".
*These variables are then brought together at the household, plot, or individual level, saving dta files at each level when available 
*in the folder "Final DTA files\Wave 3 (2015-16)".

*The processed files include all households, individuals, and plots in the sample.
*Toward the end of the do.file, a block of code estimates summary statistics (mean, standard error of the mean, minimum, first quartile, median, third quartile, maximum) 
*of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager.
*The results are outputted in the excel file "Nigeria_GHSP_LSMS_ISA_W3_summary_stats.xlsx" in the folder "Final DTA files\Wave 3 (2015-16)".
*It is possible to modify the condition  "if rural==1" in the portion of code following the heading "SUMMARY STATISTICS" to generate all summary statistics for a different sub_population.

*Information on EPAR's cleaning and construction decisions is available in the documents
*"EPAR_UW_335_Indicator Construction Summary Tables" and "EPAR_UW_335_General Considerations and Principles for Indicator Construction".


/*OUTLINE OF THE DO.FILE
Below are the list of the main files created by running this Master do.file
 					
*INTERMEDIATE FILES					MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD IDS						Nigeria_GHSP_LSMS_ISA_W3_hhids.dta
*INDIVIDUAL IDS						Nigeria_GHSP_LSMS_ISA_W3_person_ids.dta
*HOUSEHOLD SIZE						Nigeria_GHSP_LSMS_ISA_W3_hhsize.dta
*HEAD OF HOUSEHOLD					Nigeria_GHSP_LSMS_ISA_W3_male_head.dta
*PARCEL AREAS						Nigeria_GHSP_LSMS_ISA_W3_plot_areas.dta
*PLOT-CROP DECISION MAKERS			Nigeria_GHSP_LSMS_ISA_W3_plot_decision_makers.dta
*TLU (Tropical Livestock Units)		Nigeria_GHSP_LSMS_ISA_W3_TLU_Coefficients.dta
*GROSS CROP REVENUE					Nigeria_GHSP_LSMS_ISA_W3_cropsales_value.dta
									Nigeria_GHSP_LSMS_ISA_W3_hh_crop_production.dta
									Nigeria_GHSP_LSMS_ISA_W3_plot_cropvalue.dta
									Nigeria_GHSP_LSMS_ISA_W3_crop_losses.dta
*CROP EXPENSES						Nigeria_GHSP_LSMS_ISA_W3_wages_postplanting.dta
									Nigeria_GHSP_LSMS_ISA_W3_wages_postharvest.dta									
									Nigeria_GHSP_LSMS_ISA_W3_fertilizer_costs.dta
									Nigeria_GHSP_LSMS_ISA_W3_chemical_costs.dta
									Nigeria_GHSP_LSMS_ISA_W3_manure_costs.dta
									Nigeria_GHSP_LSMS_ISA_W3_seed_costs.dta
									Nigeria_GHSP_LSMS_ISA_W3_land_rental_costs.dta
									Nigeria_GHSP_LSMS_ISA_W3_asset_rental_costs.dta									
*CROP INCOME						Nigeria_GHSP_LSMS_ISA_W3_crop_income.dta
									Nigeria_GHSP_LSMS_ISA_W3_livestock_products.dta

*LIVESTOCK INCOME					Nigeria_GHSP_LSMS_ISA_W3_livestock_expenses.dta
									Nigeria_GHSP_LSMS_ISA_W3_hh_livestock_products.dta
									Nigeria_GHSP_LSMS_ISA_W3_livestock_sales.dta
									Nigeria_GHSP_LSMS_ISA_W3_TLU.dta
									Nigeria_GHSP_LSMS_ISA_W3_livestock_income.dta

*FISH INCOME						Nigeria_GHSP_LSMS_ISA_W3_fishing_expenses_1.dta
									Nigeria_GHSP_LSMS_ISA_W3_fishing_expenses_2.dta
									Nigeria_GHSP_LSMS_ISA_W3_fish_income.dta
																	
*SELF-EMPLOYMENT INCOME				Nigeria_GHSP_LSMS_ISA_W3_self_employment_income.dta
									Nigeria_GHSP_LSMS_ISA_W3_agproduct_income.dta
									
*WAGE INCOME						Nigeria_GHSP_LSMS_ISA_W3_wage_income.dta
									Nigeria_GHSP_LSMS_ISA_W3_agwage_income.dta

*OTHER INCOME						Nigeria_GHSP_LSMS_ISA_W3_remittance_income.dta
									Nigeria_GHSP_LSMS_ISA_W3_other_income.dta
									Nigeria_GHSP_LSMS_ISA_W3_land_rental_income.dta

*FARM SIZE / LAND SIZE				Nigeria_GHSP_LSMS_ISA_W3_land_size.dta
									Nigeria_GHSP_LSMS_ISA_W3_farmsize_all_agland.dta
									Nigeria_GHSP_LSMS_ISA_W3_land_size_all.dta

*FARM LABOR							Nigeria_GHSP_LSMS_ISA_W3_farmlabor_postplanting.dta
									Nigeria_GHSP_LSMS_ISA_W3_farmlabor_postharvest
					
*VACCINE USAGE						Nigeria_GHSP_LSMS_ISA_W3_vaccine.dta
*USE OF INORGANIC FERTILIZER		Nigeria_GHSP_LSMS_ISA_W3_fert_use.dta
*USE OF IMPROVED SEED				Nigeria_GHSP_LSMS_ISA_W3_improvedseed_use.dta
*REACHED BY AG EXTENSION			Nigeria_GHSP_LSMS_ISA_W3_any_ext.dta
*USE OF FORMAL FINANACIAL SERVICES	Nigeria_GHSP_LSMS_ISA_W3_fin_serv.dta
*GENDER PRODUCTIVITY GAP 			Nigeria_GHSP_LSMS_ISA_W3_gender_productivity_gap.dta

*CROP PRODUCTION COSTS PER HECTARE	Nigeria_GHSP_LSMS_ISA_W3_hh_cost_land.dta
									Nigeria_GHSP_LSMS_ISA_W3_hh_cost_prep_labor.dta
									Nigeria_GHSP_LSMS_ISA_W3_hh_cost_mid_labor.dta
									Nigeria_GHSP_LSMS_ISA_W3_hh_cost_harv_labor.dta
									Nigeria_GHSP_LSMS_ISA_W3_hh_cost_seed.dta	
									Nigeria_GHSP_LSMS_ISA_W3_hh_cost_inputs.dta									
									Nigeria_GHSP_LSMS_ISA_W3_cropcosts_perha.dta

*RATE OF FERTILIZER APPLICATION		Nigeria_GHSP_LSMS_ISA_W3_fertilizer_application.dta
*HOUSEHOLD'S DIET DIVERSITY SCORE	Nigeria_GHSP_LSMS_ISA_W3_household_diet.dta
*WOMEN'S CONTROL OVER INCOME		Nigeria_GHSP_LSMS_ISA_W3_control_income.dta
*WOMEN'S AG DECISION-MAKING			Nigeria_GHSP_LSMS_ISA_W3_make_ag_decision.dta
*WOMEN'S ASSET OWNERSHIP			Nigeria_GHSP_LSMS_ISA_W3_make_ownasset.dta
*AGRICULTURAL WAGES					Nigeria_GHSP_LSMS_ISA_W3_ag_wage.dta
*CROP YIELDS						Nigeria_GHSP_LSMS_ISA_W3_yield_hh_level.dta

*FINAL FILES						MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD VARIABLES				Nigeria_GHSP_LSMS_ISA_W3_household_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			Nigeria_GHSP_LSMS_ISA_W3_individual_variables.dta	
*PLOT-LEVEL VARIABLES				Nigeria_GHSP_LSMS_ISA_W3_gender_productivity_gap.dta
*SUMMARY STATISTICS					Nigeria_GHSP_LSMS_ISA_W3_summary_stats.xlsx

*/


clear
clear matrix
clear mata
program drop _all
set more off


//set directories
*Nigeria General HH survey (NG LSMS)  Wave 3
global raw_data "Raw DTA files\Wave 3 (2015-16)"
global created_data  "Final DTA files\Wave 3 (2015-16)\created_data"
global final_data  "Final DTA files\Wave 3 (2015-16)"
  

*************************************
*************************************
**                                 **
** Creating Intermediate Variables **
**                                 **
*************************************
*************************************


*****************
* HOUSEHOLD IDS *
*****************

use "${raw_data}\HHTrack.dta", clear
merge m:1 hhid using "${raw_data}\sectaa_plantingw3.dta"
gen rural = (sector==2)
lab var rural "1= Rural"
keep hhid zone state lga ea wt_wave3 rural
rename wt_wave3 weight
save  "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_hhids.dta", replace

*****************
* WEIGHTS *
*****************

use "${raw_data}\HHTrack.dta", clear
merge m:1 hhid using "${raw_data}\sectaa_plantingw3.dta"
gen rural = (sector==2)
lab var rural "1= Rural"
keep hhid zone state lga ea wt_wave3 rural
rename wt_wave3 weight
save  "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_weights.dta", replace



******************
* INDIVIDUAL IDS *
******************
use "${raw_data}\PTrack.dta", clear
keep hhid indiv sex age 
gen female= sex==2
la var female "1= individual is female"
la var age "Individual age"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_person_ids.dta", replace


******************
* HOUSEHOLD SIZE *
******************

use "${raw_data}\sect1_plantingw3.dta", clear
gen hh_members = 1
rename s1q3 relhead 
rename s1q2 gender
gen fhh = (relhead==1 & gender==2)
collapse (sum) hh_members (max) fhh, by (hhid)
lab var hh_members "Number of household members"
lab var fhh "1= Female-headed household"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_hhsize.dta", replace



******************
*HEAD OF HOUSEHOLD *
******************
*Creating HOH gender
clear 
use "$raw_data/PTrack.dta"
gen female_head = 0
replace female_head =1 if (relat_w3v1==1 | relat_w3v2==1) & sex ==1
collapse (max) female_head, by(hhid)
save "$created_data/Nigeria_GHSP_LSMS_ISA_W3_male_head.dta", replace


**************
* PLOT AREAS *
**************

*starting with planting
clear
use "${raw_data}/sect11a1_plantingw3"

*merging in planting section to get cultivated status
merge 1:1 hhid plotid using "${raw_data}/sect11b1_plantingw3", nogen

*merging in harvest section to get areas for new plots
merge 1:1 hhid plotid using "${raw_data}/secta1_harvestw3.dta", gen(plot_merge)

ren s11aq4a area_size
ren s11aq4b area_unit
ren sa1q9a area_size2
ren sa1q9b area_unit2
ren s11aq4c area_meas_sqm
ren sa1q9c area_meas_sqm2
gen cultivate = s11b1q27 ==1 
*assuming new plots are cultivated
replace cultivate = 1 if sa1q3==1


*using conversion factors from LSMS-ISA Nigeria Wave 2 Basic Information Document (Wave 3 unavailable, but Waves 1 & 2 are identical) //PEB confirmed it is identical for W3
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

*farmer reported field size for post-planting
gen field_size= area_size if area_unit==6
replace field_size = area_size*0.0667 if area_unit==4									//reported in plots
replace field_size = area_size*0.404686 if area_unit==5		    						//reported in acres
replace field_size = area_size*0.0001 if area_unit==7									//reported in square meters

replace field_size = area_size*0.00012 if area_unit==1 & zone==1						//reported in heaps
replace field_size = area_size*0.00016 if area_unit==1 & zone==2
replace field_size = area_size*0.00011 if area_unit==1 & zone==3
replace field_size = area_size*0.00019 if area_unit==1 & zone==4
replace field_size = area_size*0.00021 if area_unit==1 & zone==5
replace field_size = area_size*0.00012 if area_unit==1 & zone==6

replace field_size = area_size*0.0027 if area_unit==2 & zone==1							//reported in ridges
replace field_size = area_size*0.004 if area_unit==2 & zone==2
replace field_size = area_size*0.00494 if area_unit==2 & zone==3
replace field_size = area_size*0.0023 if area_unit==2 & zone==4
replace field_size = area_size*0.0023 if area_unit==2 & zone==5
replace field_size = area_size*0.00001 if area_unit==2 & zone==6

replace field_size = area_size*0.00006 if area_unit==3 & zone==1						//reported in stands
replace field_size = area_size*0.00016 if area_unit==3 & zone==2
replace field_size = area_size*0.00004 if area_unit==3 & zone==3
replace field_size = area_size*0.00004 if area_unit==3 & zone==4
replace field_size = area_size*0.00013 if area_unit==3 & zone==5
replace field_size = area_size*0.00041 if area_unit==3 & zone==6

*replacing farmer reported with GPS if available
replace field_size = area_meas_sqm*0.0001 if area_meas_sqm!=.               					//4,692 changes

*farmer reported field size for post-harvest added fields
replace field_size= area_size2 if area_unit2==6 & field_size==.
replace field_size = area_size2*0.0667 if area_unit2==4	& field_size==.		            	//reported in plots
replace field_size = area_size2*0.404686 if area_unit2==5 & field_size==.					//reported in acres
replace field_size = area_size2*0.0001 if area_unit2==7	& field_size==.		            	//reported in square meters

replace field_size = area_size2*0.00012 if area_unit2==1 & zone==1 & field_size==.			//reported in heaps
replace field_size = area_size2*0.00016 if area_unit2==1 & zone==2 & field_size==.
replace field_size = area_size2*0.00011 if area_unit2==1 & zone==3 & field_size==.
replace field_size = area_size2*0.00019 if area_unit2==1 & zone==4 & field_size==.
replace field_size = area_size2*0.00021 if area_unit2==1 & zone==5 & field_size==.
replace field_size = area_size2*0.00012 if area_unit2==1 & zone==6 & field_size==.

replace field_size = area_size2*0.0027 if area_unit2==2 & zone==1 & field_size==.			//reported in ridges
replace field_size = area_size2*0.004 if area_unit2==2 & zone==2 & field_size==.
replace field_size = area_size2*0.00494 if area_unit2==2 & zone==3 & field_size==.
replace field_size = area_size2*0.0023 if area_unit2==2 & zone==4 & field_size==.
replace field_size = area_size2*0.0023 if area_unit2==2 & zone==5 & field_size==.
replace field_size = area_size2*0.00001 if area_unit2==2 & zone==6 & field_size==.

replace field_size = area_size2*0.00006 if area_unit2==3 & zone==1 & field_size==.			//reported in stands
replace field_size = area_size2*0.00016 if area_unit2==3 & zone==2 & field_size==.
replace field_size = area_size2*0.00004 if area_unit2==3 & zone==3 & field_size==.
replace field_size = area_size2*0.00004 if area_unit2==3 & zone==4 & field_size==.
replace field_size = area_size2*0.00013 if area_unit2==3 & zone==5 & field_size==.
replace field_size = area_size2*0.00041 if area_unit2==3 & zone==6 & field_size==.

*replacing farmer reported with GPS if available
replace field_size = area_meas_sqm2*0.0001 if area_meas_sqm2!=.               //793 changes

la var field_size "Area of plot (ha)"
rename plotid plot_id

save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_plot_areas.dta", replace


************************
* PLOT DECISION MAKERS *
************************

*Creating gender variables for plot manager from post-planting
use "${raw_data}/sect1_plantingw3.dta", clear
gen female = s1q2==2 if s1q2!=.
gen age = s1q6

*dropping duplicates (data is at holder level so some individuals are listed multiple times, we only need one record for each)
duplicates drop hhid indiv, force
save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_gender_merge_temp.dta", replace

*adding in gender variables for plot manager from post-harvest
use "${raw_data}/sect1_harvestw3.dta", clear
gen female = s1q2==2 if s1q2!=.
gen age = s1q4

duplicates drop hhid indiv, force
merge 1:1 hhid indiv using "$created_data/Nigeria_GHSP_LSMS_ISA_W3_gender_merge_temp.dta", nogen 		// keeping ALL
keep hhid indiv female age
save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_gender_merge.dta", replace

*Using planting data 	
use "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_plot_areas.dta", clear 
	
//Post-Planting
*First manager 
gen indiv = s11aq6a
merge m:1 hhid indiv using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_gender_merge_temp.dta", gen(dm1_merge) keep(1 3) 
gen dm1_female = female if s11aq6a!=.
drop indiv 

*Second manager 
gen indiv = s11aq6b
merge m:1 hhid indiv using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_gender_merge_temp.dta", gen(dm2_merge) keep(1 3)			
gen dm2_female = female & s11aq6b!=.
drop indiv 

//Post-Harvest (only reported for "new" plot)
*First manager 
gen indiv = sa1q11
merge m:1 hhid indiv using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_gender_merge_temp.dta", gen(dm4_merge) keep(1 3)			
gen dm3_female = female & sa1q11!=.
drop indiv 

*Second manager 
gen indiv = sa1q11b
merge m:1 hhid indiv using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_gender_merge_temp.dta", gen(dm5_merge) keep(1 3)			
gen dm4_female = female & sa1q11b!=.
drop indiv 

*Replace PP with PH if missing
replace dm1_female=dm3_female if dm1_female==.
replace dm2_female=dm4_female if dm1_female==.

*Constructing three-part gendered decision-maker variable; male only (=1) female only (=2) or mixed (=3)
gen dm_gender = 1 if (dm1_female==0 | dm1_female==.) & (dm2_female==0 | dm2_female==.) & !(dm1_female==. & dm2_female==.)
replace dm_gender = 2 if (dm1_female==1 | dm1_female==.) & (dm2_female==1 | dm2_female==.) & !(dm1_female==. & dm2_female==.)
replace dm_gender = 3 if dm_gender==. & !(dm1_female==. & dm2_female==.)
la def dm_gender 1 "Male only" 2 "Female only" 3 "Mixed gender"
 
*replacing observations without gender of plot manager with gender of HOH
merge m:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_hhsize.dta", nogen keep(1 3)

replace dm_gender=1 if fhh ==0 & dm_gender==. //0 changes
replace dm_gender=2 if fhh ==1 & dm_gender==. //0 changes

gen dm_male = dm_gender==1
gen dm_female = dm_gender==2
gen dm_mixed = dm_gender==3


keep field_size plot_id hhid dm_* fhh 

save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_plot_decision_makers", replace



**********************
* GROSS CROP REVENUE *
**********************

**Creating median crop prices at different geographic levels to use for imputation**

*median prices at state level
use "${raw_data}\secta3i_harvestw3.dta", clear
rename cropname crop_name
rename cropcode crop_code
rename sa3iq3 harvest_yesno
keep if harvest_yesno==1
rename sa3iq6i quantity_harvested
rename sa3iq6ii quantity_harvested_unit
rename sa3iq6ii_os quantity_harvested_unit_other
rename sa3iq6a value_harvested
collapse (sum) value_harvested quantity_harvested, by (hhid crop_code quantity_harvested_unit)
gen price_per_unit = value_harvested / quantity_harvested /* Has to be at unit-level because units for a single crop can vary across plots within a household */
gen observation=1
merge m:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_weights.dta"
collapse (median) price_per_unit (count) observation [aw = weight], by (crop_code quantity_harvested_unit zone state)
rename observation obs_state
rename price_per_unit price_per_unit_median_state
lab var price_per_unit_median_state "Median price for this crop-unit combination in the state"
rename quantity_harvested_unit unit
save  "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_crop_prices_median_state.dta", replace

*median prices at zone level
use "${raw_data}\secta3i_harvestw3.dta", clear
rename cropname crop_name
rename cropcode crop_code
rename sa3iq3 harvest_yesno
keep if harvest_yesno==1
rename sa3iq6i quantity_harvested
rename sa3iq6ii quantity_harvested_unit
rename sa3iq6ii_os quantity_harvested_unit_other
rename sa3iq6a value_harvested
collapse (sum) value_harvested quantity_harvested, by (hhid crop_code quantity_harvested_unit)
gen price_per_unit = value_harvested / quantity_harvested /* Has to be at unit-level because units for a single crop can vary across plots within a household */
gen observation=1
merge m:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_weights.dta"
collapse (median) price_per_unit (count) observation [aw = weight], by (crop_code quantity_harvested_unit zone)
rename observation obs_zone
rename price_per_unit price_per_unit_median_zone
lab var price_per_unit_median_zone "Median price for this crop-unit combination in the zone"
rename quantity_harvested_unit unit
save  "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_crop_prices_median_zone.dta", replace

*median prices at country level
use "${raw_data}\secta3i_harvestw3.dta", clear
rename cropname crop_name
rename cropcode crop_code
rename sa3iq3 harvest_yesno
keep if harvest_yesno==1
rename sa3iq6i quantity_harvested
rename sa3iq6ii quantity_harvested_unit
rename sa3iq6ii_os quantity_harvested_unit_other
rename sa3iq6a value_harvested
collapse (sum) value_harvested quantity_harvested, by (hhid crop_code quantity_harvested_unit)
gen price_per_unit = value_harvested / quantity_harvested /* Has to be at unit-level because units for a single crop can vary across plots within a household */
merge m:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_weights.dta"
collapse (median) price_per_unit [aw = weight], by (crop_code quantity_harvested_unit)
rename price_per_unit price_per_unit_median
lab var price_per_unit_median "Median price for this crop-unit combination in the country"
rename quantity_harvested_unit unit
save  "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_crop_prices_median_country.dta", replace


*Generating Value of crop sales
use "${raw_data}\secta3ii_harvestw3.dta", clear
rename cropcode crop_code 
rename sa3iiq6 sales_value
recode sales_value (.=0)
collapse (sum) sales_value, by (hhid crop_code)
lab var sales_value "Value of sales of this crop"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_cropsales_value.dta", replace

use "${raw_data}\secta3i_harvestw3.dta", clear
rename cropname crop_name
rename cropcode crop_code
rename sa3iq3 harvest_yesno
rename sa3iq6i quantity_harvested
rename sa3iq6ii quantity_harvested_unit
rename sa3iq6ii_os quantity_harvested_unit_other
rename sa3iq6a value_harvested
replace value_harvested = 0 if harvest_yesno==2
replace value_harvested = 0 if value_harvested==. & quantity_harvested == 0
rename sa3iq6b finished_harvest
rename sa3iq6d1 quantity_to_harvest
rename sa3iq6d2 quantity_to_harvest_unit
rename sa3iq6d2_os quantity_to_harvest_unit_other
gen price_per_unit = value_harvested / quantity_harvested
gen same_unit = 1 if quantity_harvested_unit == quantity_to_harvest_unit
replace same_unit = 0 if quantity_harvested_unit != quantity_to_harvest_unit & finished_harvest==2
tab same_unit if finished_harvest==2
lab var same_unit "Units for harevst (completed and future) are the same"
gen value_still_to_harvest = quantity_to_harvest * price_per_unit if same_unit==1
replace value_still_to_harvest = 0 if finished_harvest==1 |  harvest_yesno==2
*61 cases where we can't value the quantity still to be harvested.
gen unit = quantity_to_harvest_unit
merge m:1 zone state crop_code unit using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_crop_prices_median_state.dta" 
drop if _merge==2
drop _merge
merge m:1 zone crop_code unit using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_crop_prices_median_zone.dta" 
drop if _merge==2
drop _merge
merge m:1 crop_code unit using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_crop_prices_median_country.dta" 
drop if _merge==2
drop _merge
replace value_still_to_harvest = quantity_to_harvest * price_per_unit_median_state if same_unit==0 & obs_state>=10
replace value_still_to_harvest = quantity_to_harvest * price_per_unit_median_zone if same_unit==0 & obs_zone>=10 & value_still_to_harvest==.
replace value_still_to_harvest = quantity_to_harvest * price_per_unit_median if same_unit==0 & value_still_to_harvest==.
*13 observations that we still can't quite value.
replace value_still_to_harvest = 0 if finished_harvest==2 & value_still_to_harvest==. & same_unit!=. & quantity_to_harvest!=.
replace value_still_to_harvest = 0 if finished_harvest==2 & quantity_to_harvest==. /* Missing information, might be a typo */
drop unit
gen unit = quantity_harvested_unit
merge m:1 zone state crop_code unit using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_crop_prices_median_state.dta" 
drop if _merge==2
drop _merge
merge m:1 zone crop_code unit using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_crop_prices_median_zone.dta" 
drop if _merge==2
drop _merge
merge m:1 crop_code unit using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_crop_prices_median_country.dta" 
drop if _merge==2
drop _merge
replace value_harvested = quantity_harvested * price_per_unit_median if harvest_yesno==1 & value_harvested==.
*If we don't have a value in the data, and don't otherwise find the crop-unit combination in the data set, let's assume this = zero?
replace value_harvested = 0 if harvest_yesno==1 & value_harvested==. /* 34 replacements. Revisit this decision later. */
replace value_still_to_harvest=0 if hhid==290128 & value_still_to_harvest==. /* typo */
gen value_harvest = value_harvested + value_still_to_harvest
lab var value_harvest "Value of crop harvest, already harvested and what is expected"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_crop_values_tempfile.dta", replace 
collapse (sum) value_harvest, by (hhid crop_code)
save  "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_hh_crop_values_production.dta", replace 
merge 1:1 hhid crop_code using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_cropsales_value.dta"
replace value_harvest = sales_value if sales_value>value_harvest & sales_value!=. /* In a few cases, sales value reported exceeds the estimated value of crop harvest */
collapse (sum) value_harvest sales_value, by (hhid)
rename value_harvest value_crop_production
lab var value_crop_production "Gross value of crop production for this household"
rename sales_value value_crop_sales
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_hh_crop_production.dta", replace

*Generating value of crop production at plot level
use "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_crop_values_tempfile.dta", clear
rename plotid plot_id
collapse (sum) value_harvest, by (hhid plot_id)
rename value_harvest plot_value_harvest
lab var plot_value_harvest "Value of crop harvest on this plot"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_plot_cropvalue.dta", replace
****THIS IS THE PLOT FILE ****


*Crops lost post-harvest
use "${raw_data}\secta3ii_harvestw3.dta", clear
rename cropname crop_name
rename cropcode crop_code
rename sa3iiq18c share_lost
merge m:1 hhid crop_code using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_hh_crop_values_production.dta"
drop if _merge==2 /* Crops for which zero was harvested */
drop _merge
recode share_lost (.=0)
gen crop_value_lost = value_harvest * (share_lost/100)
collapse (sum) crop_value_lost, by (hhid)
lab var crop_value_lost "Value of crops lost between harvest and survey time"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_crop_losses.dta", replace


*****************
* CROP EXPENSES *
*****************

use  "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_crop_values_tempfile.dta", clear
keep hhid crop_code quantity_harvested_unit price_per_unit
rename quantity_harvested_unit unit
collapse (mean) price_per_unit, by (hhid crop_code unit)
rename price_per_unit hh_price_mean
lab var hh_price_mean "Average price reported for this crop-unit in the household"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_hh_crop_prices_for_wages.dta", replace

*Expenses: Hired labor
use "${raw_data}\sect11c1_plantingw3.dta", clear
rename s11c1q2 number_men
rename s11c1q3 number_days_men
rename s11c1q4 wage_perday_men
rename s11c1q5 number_women
rename s11c1q6 number_days_women
rename s11c1q7 wage_perday_women
rename s11c1q8 number_children
rename s11c1q9 number_days_children
rename s11c1q10 wage_perday_children
gen wages_paid_men = /*number_men **/ number_days_men * wage_perday_men
gen wages_paid_women = /*number_women **/ number_days_women * wage_perday_women 
gen wages_paid_children = /*number_children **/ number_days_children * wage_perday_children
recode wages_paid_men wages_paid_women wages_paid_children (.=0)
gen wages_paid_aglabor_postplant =  wages_paid_men + wages_paid_women + wages_paid_children
collapse (sum) wages_paid_aglabor_postplant, by (hhid)
lab var wages_paid_aglabor_postplant "Wages paid for hired labor (crops), as captured in post-planting survey"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_wages_postplanting.dta", replace

use "${raw_data}\secta2_harvestw3.dta", clear
*Harvest
rename sa2q2 number_men
rename sa2q3 number_days_men
rename sa2q4 wage_perday_men
rename sa2q5 number_women
rename sa2q6 number_days_women
rename sa2q7 wage_perday_women
rename sa2q8 number_children
rename sa2q9 number_days_children
rename sa2q10 wage_perday_children
*Before harvest
ren sa2q1c number_men2  		// Adding to capture hired labor used between planting and harvesting
ren sa2q1d number_days_men2
ren sa2q1e wage_perday_men2
ren sa2q1f number_women2
ren sa2q1g number_days_women2
ren sa2q1h wage_perday_women2
ren sa2q1i number_children2
ren sa2q1j number_days_children2
ren sa2q1k wage_perday_children2
recode number_days_men wage_perday_men number_days_men2 wage_perday_men2 number_days_women wage_perday_women number_days_women2 wage_perday_women2 /*
*/ number_days_children wage_perday_children number_days_children2 wage_perday_children2 (.=0)
gen wages_paid_men = /*number_men **/ (number_days_men * wage_perday_men) + (number_days_men2 * wage_perday_men2)
gen wages_paid_women = /*number_women **/ (number_days_women * wage_perday_women) + (number_days_women2 * wage_perday_women2)
gen wages_paid_children = /*number_children **/ (number_days_children * wage_perday_children) + (number_days_children2 * wage_perday_children2)
recode wages_paid_men wages_paid_women wages_paid_children (.=0)
gen wages_paid_aglabor_postharvest =  wages_paid_men + wages_paid_women + wages_paid_children
*Value wages paid in the form of harvest at either the household crop-unit value OR the median crop-unit value in the country.
rename sa2q1m_a crop_code 
rename sa2q1m_b quantity 
rename sa2q1m_c unit
merge m:1 hhid crop_code unit using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_hh_crop_prices_for_wages.dta", nogen keep (1 3)
merge m:1 crop_code unit using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_crop_prices_median_country.dta", nogen keep (1 3)
gen inkind_payment = quantity * hh_price_mean
replace inkind_payment = quantity * price_per_unit_median if quantity!=. & inkind_payment==.
lab var inkind_payment "Wages paid out from the harvest, for work between planting and harvest"
drop crop_code quantity unit price hh_price_mean price_per_unit_median
rename sa2q11a crop_code 
rename sa2q11b quantity 
rename sa2q11c unit
merge m:1 hhid crop_code unit using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_hh_crop_prices_for_wages.dta", nogen keep (1 3)
merge m:1 crop_code unit using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_crop_prices_median_country.dta", nogen keep (1 3)
gen inkind_payment2 = quantity * hh_price_mean
replace inkind_payment2 = quantity * price_per_unit_median if quantity!=. & inkind_payment==.
lab var inkind_payment2 "Wages paid out from the harvest, for harvest/threshing labor"
recode inkind_payment inkind_payment2 (.=0)
*br wages_paid_aglabor_postharvest inkind_payment inkind_payment2
replace wages_paid_aglabor_postharvest = wages_paid_aglabor_postharvest + inkind_payment + inkind_payment2
collapse (sum) wages_paid_aglabor_postharvest, by (hhid)
lab var wages_paid_aglabor_postharvest "Wages paid for hired labor (crops), as captured in post-harvest survey"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_wages_postharvest.dta", replace

*Expenses: Inputs
use "${raw_data}\secta11d_harvestw3.dta", clear
rename s11dq5d expenditure_subsidized_fert
rename s11dq19 value_fertilizer_1
rename s11dq29 value_fertilizer_2
rename s11dq10 cost_transport_free_fert
rename s11dq17 cost_transport_fertilizer_1
rename s11dq31 cost_transport_fertilizer_2
recode expenditure_subsidized_fert value_fertilizer_1 value_fertilizer_2 cost_transport_free_fert cost_transport_fertilizer_1 cost_transport_fertilizer_2 (.=0)
gen value_fertilizer = value_fertilizer_1 + value_fertilizer_2
gen cost_transport_fertilizer = cost_transport_fertilizer_1 + cost_transport_fertilizer_2
collapse (sum) expenditure_subsidized_fert value_fertilizer cost_transport_fertilizer cost_transport_free_fert, by (hhid)
lab var value_fertilizer "Value of fertilizer purchased (not necessarily the same as used)"
lab var expenditure_subsidized_fert "Expenditure on subsidized fertilizer"
lab var cost_transport_free_fert "Cost of transportation associated with free fertilizer"
lab var cost_transport_fertilizer "Cost of transportation associated with purchased fertilizer"
*Interesting that this was not asked post-planting.
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_fertilizer_costs.dta", replace

*Other chemicals
use "${raw_data}\secta11c2_harvestw3.dta", clear
recode s11c2q13a s11c2q13b s11c2q14a s11c2q14b (.=0) /* Check for missing obs. here */
gen value_herbicide_1 = s11c2q13a + s11c2q14a
gen value_herbicide_2 = s11c2q13b + s11c2q14b
recode s11c2q4a s11c2q4b s11c2q5a s11c2q5b (.=0)
gen value_pesticide_1 = s11c2q4a + s11c2q5a
gen value_pesticide_2 = s11c2q4b + s11c2q5b
gen value_herbicide = value_herbicide_1 + value_herbicide_2
gen value_pesticide = value_pesticide_1 + value_pesticide_2
collapse (sum) value_herbicide value_pesticide, by (hhid)
lab var value_herbicide "Value of herbicide purchased (not necessarily the same as used)"
lab var value_pesticide "Value of pesticide purchased (not necessarily the same as used)"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_chemical_costs.dta", replace

*Manure
use "${raw_data}\secta11d_harvestw3.dta", clear
rename s11dq39 value_manure_purchased
rename s11dq41 cost_transport_manure
recode value_manure_purchased cost_transport_manure (.=0) 
collapse (sum) value_manure_purchased cost_transport_manure, by (hhid)
lab var value_manure_purchased "Value of manure purchased (not what was used)"
lab var cost_transport_manure "Cost transport for manure that was purchased"
*Expenditures on transport for manure purchased are also captured in thie data set.
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_manure_costs.dta", replace

*Seed 
use "${raw_data}\sect11e_plantingw3.dta", clear
rename s11eq21 cost_seed_1
rename s11eq33 cost_seed_2
rename s11eq19 cost_transportation_seed_1
rename s11eq31 cost_transportation_seed_2
recode cost_seed_1 cost_seed_2 cost_transportation_seed_1 cost_transportation_seed_2 (.=0)
gen cost_seed = cost_seed_1 + cost_seed_2
gen cost_transportation_seed = cost_transportation_seed_1 + cost_transportation_seed_2
collapse (sum) cost_seed cost_transportation_seed, by (hhid)
lab var cost_seed "Cost of purchased seed"
lab var cost_transportation_seed "Cost of transportation associated with purchased seed"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_seed_costs.dta", replace

*Land rental
use "${raw_data}\sect11b1_plantingw3.dta", clear
gen rented_plot = (s11b1q4==2)
rename s11b1q13 rental_cost_cash 
rename s11b1q14 rental_cost_inkind
recode rental_cost_cash rental_cost_inkind (.=0)
gen rental_cost_land = rental_cost_cash + rental_cost_inkind
collapse (sum) rental_cost_land, by (hhid)
lab var rental_cost_land "Rental costs paid for land"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_land_rental_costs.dta", replace

*Rental of agricultural tools, machines, animal traction
use "${raw_data}\secta11c2_harvestw3.dta", clear
*Animal traction rental can't easily be calculated, as the units for rental are not in days.
rename s11c2q21 days_oxen_rental
rename s11c2q23a animal_rent_quantity
rename s11c2q23b animal_rent_unit
rename s11c2q23c animal_rent_unit_other
rename s11c2q24a animal_rent_inkind_quantity
rename s11c2q24b animal_rent_inkind_unit
rename s11c2q25 animal_rent_feeding_costs
rename s11c2q32 rental_cost_ag_assets_cash
rename s11c2q33 rental_cost_ag_assets_inkind
gen animal_rent_paid = days_oxen_rental * animal_rent_quantity if animal_rent_unit ==2
replace animal_rent_paid = days_oxen_rental * (animal_rent_quantity/8) if animal_rent_unit ==1 /* Assume oxen have 8-hour workday */
replace animal_rent_paid = animal_rent_quantity if animal_rent_unit ==6
gen hectares_ploughed = animal_rent_quantity if animal_rent_unit==4 
replace animal_rent_paid = days_oxen_rental * (animal_rent_quantity/8) if animal_rent_unit_other == "8 Days"
*If unit is given in acre or hectare or the number of plots, we'll assume the entire plot is ploughed. Will grab this from land area estimates LATER.
gen animal_rent_per_ha = (animal_rent_quantity/2.47105) if animal_rent_unit==4 
replace animal_rent_per_ha = animal_rent_quantity if animal_rent_unit==5
rename plotid plot_id
merge 1:1 hhid plot_id using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_plot_areas.dta" /* The merge isn't perfect, but we are doing this to value oxen rental for just 22 plots */
gen animal_rent_area = animal_rent_per_ha * field_size
recode animal_rent_paid animal_rent_feeding_costs rental_cost_ag_assets_cash rental_cost_ag_assets_inkind animal_rent_area (.=0)
replace animal_rent_paid = animal_rent_paid + animal_rent_feeding_costs + animal_rent_area
gen rental_cost_ag_assets = rental_cost_ag_assets_cash + rental_cost_ag_assets_inkind
collapse (sum) animal_rent_paid rental_cost_ag_assets, by (hhid)
lab var animal_rent_paid "Cost for renting animal traction"
lab var rental_cost_ag_assets "Cost for renting agricultural machine/equipment (including tractors)"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_asset_rental_costs.dta", replace



********************
* LIVESTOCK INCOME *
********************

*Expenses
use "${raw_data}\sect11j_plantingw3.dta", clear
rename s11jq2a cost_cash
rename s11jq2b cost_inkind
recode cost_cash cost_inkind (.=0)
gen cost_hired_labor_livestock = (cost_cash + cost_inkind) if item_cd==1 | item_cd==4
gen cost_fodder_livestock = (cost_cash + cost_inkind) if item_cd==2
gen cost_vaccines_livestock = (cost_cash + cost_inkind) if item_cd==3 /* Includes treatment */
gen cost_other_livestock = (cost_cash + cost_inkind) if item_cd>=5 & item_cd<=9
recode cost_hired_labor_livestock cost_fodder_livestock cost_vaccines_livestock cost_other_livestock (.=0)
collapse (sum) cost_hired_labor_livestock cost_fodder_livestock cost_vaccines_livestock cost_other_livestock, by (hhid)
lab var cost_fodder_livestock "Cost for fodder for livestock"
lab var cost_vaccines_livestock "Cost for vaccines and veterminary treatment for livestock"
lab var cost_hired_labor_livestock "Cost for hired labor for livestock"
lab var cost_other_livestock "Cost for any other expenses for livestock"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_livestock_expenses.dta", replace

use "${raw_data}\sect11k_plantingw3.dta", clear
rename prod_cd livestock_code
rename s11kq2 months_produced
rename s11kq3a quantity_produced
rename s11kq3b quantity_produced_unit /* 1 "Other" = crate */
rename s11kq5a quantity_sold_season
rename s11kq5b quantity_sold_season_unit
rename s11kq6 earnings_from_sales
*Valuing so many odd units is going to be extremely difficult.
recode quantity_produced quantity_sold_season months_produced (.=0)
gen price_unit = earnings_from_sales / quantity_sold_season
bys livestock_code: count if quantity_sold_season !=0
*67 milk, 44 eggs, 2 palm wine, across many, many (> 25) units.
*Mushrooms and hunting can never be valued. Very few obs.
keep hhid livestock_code months_produced quantity_produced quantity_produced_unit quantity_sold_season quantity_sold_season_unit earnings_from_sales price_unit
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_hh_livestock_products.dta", replace

use "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_hh_livestock_products", clear
merge m:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_weights.dta"
drop if _merge==2
collapse (median) price_unit [aw=weight], by (livestock_code quantity_sold_season_unit)
rename price_unit price_unit_median_country
rename quantity_sold_season_unit unit
replace price_unit_median_country = 100 if livestock_code == 1 & unit==1 /* 1 kg per liter */
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_livestock_products_prices_country.dta", replace

use "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_hh_livestock_products", clear
replace quantity_produced_unit = 80 if livestock_code==2 & (quantity_produced_unit==70 | quantity_produced_unit==82 | quantity_produced_unit==90 | quantity_produced_unit==191 /*
*/ | quantity_produced_unit==141 | quantity_produced_unit==160 | quantity_produced_unit==3 | quantity_produced_unit==1)
*These units are never sold, so let's AT LEAST give them the credit of 1-piece, even though these are small heaps of eggs, etc.
replace quantity_produced_unit = 3 if livestock_code==1 & (quantity_produced_unit==1 | quantity_produced_unit==70 | quantity_produced_unit==81  | quantity_produced_unit==80 | quantity_produced_unit==191)
gen unit = quantity_produced_unit 
merge m:1 livestock_code unit using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_livestock_products_prices_country.dta"
drop if _merge==2
drop _merge
gen value_produced = price_unit * quantity_produced * months_produced if quantity_produced_unit == quantity_sold_season_unit
replace value_produced = price_unit_median_country * quantity_produced * months_produced if value_produced==.
replace value_produced = earnings_from_sales if value_produced==.
*At least make sure we've captured all sales income.
*Some of these units: 8 pieces of milk.
*I think there is no conversion file for livestock products.
lab var price_unit "Price per liter (milk) or per egg/liter/container honey or palm wine, imputed with local median prices if household did not sell"
gen value_milk_produced = quantity_produced * price_unit  if livestock_code==1
gen value_eggs_produced = quantity_produced * price_unit if livestock_code==2
gen value_other_produced = quantity_produced * price_unit if livestock_code!=1 & livestock_code!=2
collapse (sum) value_milk_produced value_eggs_produced value_other_produced, by (hhid)
lab var value_milk_produced "Value of milk produced"
lab var value_eggs_produced "Value of eggs produced"
lab var value_other_produced "Value of honey and skins produced"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_livestock_products.dta", replace

*Sales (live animals)
use "${raw_data}\sect11i_plantingw3.dta", clear
rename animal_cd livestock_code 
rename s11iq16 number_sold 
rename s11iq17 income_live_sales 
rename s11iq19a number_slaughtered_sale 
rename s11iq19b number_slaughtered_consumption 
rename s11iq11 value_livestock_purchases
recode number_sold income_live_sales number_slaughtered_sale number_slaughtered_consumption value_livestock_purchases (.=0)
gen number_slaughtered = number_slaughtered_sale + number_slaughtered_consumption 
lab var number_slaughtered "Number slaughtered for sale and home consumption"
gen price_per_animal = income_live_sales / number_sold
merge m:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_weights.dta"
drop if _merge==2
drop _merge
keep if price_per_animal !=. & price_per_animal!=0
keep hhid weight zone state lga ea livestock_code number_sold income_live_sales number_slaughtered price_per_animal value_livestock_purchases
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_hh_livestock_sales", replace
*Note that we could have used respondent estimates of the value of their livestock. Hmm.

*Implicit prices (based on observed sales)
use "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_hh_livestock_sales", clear
gen observation = 1
bys zone state lga ea livestock_code: egen obs_ea = count(observation)
collapse (median) price_per_animal [aw=weight], by (zone state lga ea livestock_code obs_ea)
rename price_per_animal price_median_ea
lab var price_median_ea "Median price per unit for this livestock in the ea"
lab var obs_ea "Number of sales observations for this livestock in the ea"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_livestock_prices_ea.dta", replace
use "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_hh_livestock_sales", clear
gen observation = 1
bys zone state lga livestock_code: egen obs_lga = count(observation)
collapse (median) price_per_animal [aw=weight], by (zone state lga livestock_code obs_lga)
rename price_per_animal price_median_lga
lab var price_median_lga "Median price per unit for this livestock in the lga"
lab var obs_lga "Number of sales observations for this livestock in the lga"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_livestock_prices_lga.dta", replace
use "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_hh_livestock_sales", clear
gen observation = 1
bys zone state livestock_code: egen obs_state = count(observation)
collapse (median) price_per_animal [aw=weight], by (zone state livestock_code obs_state)
rename price_per_animal price_median_state
lab var price_median_state "Median price per unit for this livestock in the state"
lab var obs_state "Number of sales observations for this livestock in the state"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_livestock_prices_state.dta", replace
use "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_hh_livestock_sales", clear
gen observation = 1
bys zone livestock_code: egen obs_zone = count(observation)
collapse (median) price_per_animal [aw=weight], by (zone livestock_code obs_zone)
rename price_per_animal price_median_zone
lab var price_median_zone "Median price per unit for this livestock in the zone"
lab var obs_zone "Number of sales observations for this livestock in the zone"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_livestock_prices_zone.dta", replace
use "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_hh_livestock_sales", clear
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_animal [aw=weight], by (livestock_code obs_country)
rename price_per_animal price_median_country
lab var price_median_country "Median price per unit for this livestock in the country"
lab var obs_country "Number of sales observations for this livestock in the country"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_livestock_prices_country.dta", replace

use "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_hh_livestock_sales", clear
merge m:1 zone state lga ea livestock_code using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_livestock_prices_ea.dta"
drop _merge
merge m:1 zone state lga livestock_code using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_livestock_prices_lga.dta"
drop _merge
merge m:1 zone state livestock_code using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_livestock_prices_state.dta"
drop _merge
merge m:1 zone livestock_code using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_livestock_prices_zone.dta"
drop _merge
merge m:1 livestock_code using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_livestock_prices_country.dta"
drop _merge /* All have merges */
replace price_per_animal = price_median_ea if price_per_animal==. & obs_ea >= 10
replace price_per_animal = price_median_lga if price_per_animal==. & obs_lga >= 10
replace price_per_animal = price_median_state if price_per_animal==. & obs_state >= 10
replace price_per_animal = price_median_zone if price_per_animal==. & obs_zone >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_sold = price_per_animal * number_sold
gen value_slaughtered = price_per_animal * number_slaughtered
*Nigeria LSMS doesn't capture income from slaughtered sales
gen value_livestock_sales = value_sold + value_slaughtered
collapse (sum) value_livestock_sales value_livestock_purchases, by (hhid)
lab var value_livestock_sales "Value of livestock sold and slaughtered (with slaughtered livestock that weren't sold valued at local median prices for live animal sales)"
lab var value_livestock_purchases "Value of livestock purchases (seems to span only the agricultural season, not the previous year)"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_livestock_sales.dta", replace


*TLU (Tropical Livestock Units)
use "${raw_data}\sect11i_plantingw3.dta", clear
gen tlu=0.5 if (animal_cd==101|animal_cd==102|animal_cd==103|animal_cd==104|animal_cd==105|animal_cd==106|animal_cd==107|animal_cd==109)
replace tlu=0.3 if (animal_cd==108)
replace tlu=0.1 if (animal_cd==110|animal_cd==111)
replace tlu=0.2 if (animal_cd==112)
replace tlu=0.01 if (animal_cd==113|animal_cd==114|animal_cd==115|animal_cd==116|animal_cd==117|animal_cd==118|animal_cd==119|animal_cd==120|animal_cd==121)
replace tlu=0.7 if (animal_cd==122)
lab var tlu "Tropical Livestock Unit coefficient"
rename animal_cd livestock_code
rename tlu tlu_coefficient
rename s11iq2 number_today 
rename s11iq3 price_per_animal_est /* Estimated by the respondent */
rename s11iq6 number_start_agseason 
gen tlu_start_agseason = number_start_agseason * tlu_coefficient
gen tlu_today = number_today * tlu_coefficient
rename s11iq16 number_sold 
rename s11iq17 income_live_sales 
gen price_per_animal = income_live_sales / number_sold
merge m:1 zone state lga ea livestock_code using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_livestock_prices_ea.dta"
drop _merge
merge m:1 zone state lga livestock_code using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_livestock_prices_lga.dta"
drop _merge
merge m:1 zone state livestock_code using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_livestock_prices_state.dta"
drop _merge
merge m:1 zone livestock_code using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_livestock_prices_zone.dta"
drop _merge
merge m:1 livestock_code using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_livestock_prices_country.dta"
drop _merge /* All have merges */
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
lab var value_start_agseason "Value of livestock holdings from one year ago"
lab var value_today "Value of livestock holdings today"
lab var value_today_est "Value of livestock holdings today, per estimates (not observed sales)"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_TLU.dta", replace
*This is a very short time period to observe changes in livestock holdings. 
*Maybe value of animals today should have come from the estimated values (not sales)?
*With India AgDev, I've been inconsistent with how I valued livestock holdings today and 1 year ago.



***************
* FISH INCOME *
***************
	
use "${raw_data}\secta9a2_harvestw3.dta", clear
rename fish_cd fish_code
rename sa9aq5b unit
rename sa9aq6 price_per_unit
merge m:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_weights.dta"
drop if _merge==2
collapse (median) price_per_unit [aw=weight], by (fish_code unit)
rename price_per_unit price_per_unit_median
replace price_per_unit_median = . if fish_code==5 /* "Other */
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_fish_prices_1.dta", replace /* Caught fish */

use "${raw_data}\secta9a2_harvestw3.dta", clear
rename fish_cd fish_code
rename sa9aq7b unit
rename sa9aq8 price_per_unit
merge m:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_weights.dta"
drop if _merge==2
collapse (median) price_per_unit [aw=weight], by (fish_code unit)
rename price_per_unit price_per_unit_median
replace price_per_unit_median = . if fish_code==5 /* "Other */
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_fish_prices_2.dta", replace /* Harvested fish */

use "${raw_data}\secta9a2_harvestw3.dta", clear
keep if sa9aq2==1
rename fish_cd fish_code
rename sa9aq3 weeks_fishing
rename sa9aq4a1 quantity_caught /* on average per week */
rename sa9aq4a2 quantity_caught_unit
rename sa9aq4b1 quantity_harvested /* on average per week */
rename sa9aq4b2 quantity_harvested_unit
rename sa9aq5b sold_unit
rename sa9aq6 price_per_unit
rename sa9aq7b sold_unit_harvested
rename sa9aq8 price_per_unit_harvested
recode quantity_caught quantity_harvested (.=0)
rename quantity_caught_unit unit
merge m:1 fish_code unit using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_fish_prices_1.dta"
drop if _merge==2
drop _merge
gen value_fish_caught = (quantity_caught * price_per_unit) if unit==sold_unit
replace value_fish_caught = (quantity_caught * price_per_unit_median) if value_fish_caught==.
replace value_fish_caught = (quantity_caught * price_per_unit) if unit==91 & sold_unit==90 & value_fish_caught==. /* For 1 obs that can't be valued, we'll equate a small and medium heap. */
rename unit quantity_caught_unit 
rename quantity_harvested_unit unit
drop price_per_unit_median
merge m:1 fish_code unit using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_fish_prices_2.dta"
drop if _merge==2
drop _merge
gen value_fish_harvest = (quantity_harvested * price_per_unit_harvested) if unit==sold_unit_harvested
replace value_fish_harvest = (quantity_harvested * price_per_unit_median) if value_fish_harvest==.
replace value_fish_harvest = (quantity_harvested * (3500*10)) if unit==80 & sold_unit_harvested==1 & value_fish_harvest==. /* 10 kg bag = (10 * 1 kg) */
replace value_fish_harvest = (quantity_harvested * (600)) if unit==3 & sold_unit_harvested==. & value_fish_harvest==.
replace value_fish_harvest = value_fish_harvest * weeks_fishing /* Multiply average weekly earnings by number of weeks */
replace value_fish_caught = value_fish_caught * weeks_fishing
recode value_fish_harvest value_fish_caught weeks_fishing (.=0)
collapse (median) value_fish_harvest value_fish_caught (max) weeks_fishing, by (hhid)
lab var value_fish_caught "Value of fish caught over the past 12 months"
lab var value_fish_harvest "Value of fish harvested over the past 12 months"
lab var weeks_fishing "Maximum number weeks fishing for any species"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_fish_income.dta", replace

use "${raw_data}\secta9b2_harvestw3.dta", clear
rename sa9bq7 rental_costs_day
rename sa9bq6 days_rental
rename sa9bq9 maintenance_costs_per_week
rename sa9bq8 fuel_per_week /* Multiply this by weeks fishing */
recode days_rental rental_costs_day maintenance_costs_per_week (.=0)
gen rental_costs_fishing = rental_costs_day * days_rental
gen fish_expenses_1 = fuel_per_week + maintenance_costs_per_week
collapse (sum) fish_expenses_1, by (hhid)
lab var fish_expenses_1 "Expenses associated with boat rental and maintenance per week" /* This isn't only for rented boats. */
merge 1:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_fish_income.dta"
replace fish_expenses_1 = fish_expenses_1 * weeks_fishing
keep hhid fish_expenses_1
lab var fish_expenses_1 "Expenses associated with boat rental and maintenance over the year"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_fishing_expenses_1.dta", replace

use "${raw_data}\secta9b3_harvestw3.dta", clear
rename sa9bq10a number_men
rename sa9bq10b weeks_men
rename sa9bq11a number_women
rename sa9bq11b weeks_women
rename sa9bq12a number_children
rename sa9bq12b weeks_child
rename sa9bq15a wages_week_man
rename sa9bq15b wages_week_woman
rename sa9bq15c wages_week_child
rename sa9bq19a cash_men
rename sa9bq19b cash_women
rename sa9bq19c cash_child
rename sa9bq22a costs_feed 
rename sa9bq22b costs_irrigation 
rename sa9bq22c costs_maintenance 
rename sa9bq22d costs_fishnets 
rename sa9bq22e costs_other
recode number_men weeks_men number_women weeks_women number_children weeks_child wages_week_man wages_week_woman /*
*/ wages_week_child cash_men cash_women cash_child costs_feed costs_irrigation costs_maintenance costs_fishnets costs_other (.=0)
gen fish_expenses_2 = (number_men * weeks_men * wages_week_man) + (number_women * weeks_women * wages_week_woman) + /*
*/ (number_children * weeks_child * wages_week_child) + (cash_men + cash_women + cash_child) + /*
*/ (costs_feed + costs_irrigation + costs_maintenance + costs_fishnets + costs_other)
keep hhid fish_expenses_2
lab var fish_expenses_2 "Expenses associated with hired labor and fish pond maintenance"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_fishing_expenses_2.dta", replace



**************************
* SELF-EMPLOYMENT INCOME *
**************************	
	
use "${raw_data}\sect9_harvestw3.dta", clear
*It's not obvious to me where is the start/end of 12 months.
*Here, we're taking the first 12 months asked about.
local vars s9q10a s9q10b s9q10c s9q10d s9q10e s9q10f s9q10g s9q10h s9q10i s9q10j s9q10k s9q10l 
foreach p of local vars {
replace `p' = "1" if `p'=="X"
replace `p' = "0" if `p'==""
destring `p', replace
}
egen months_activ = rowtotal(s9q10a - s9q10l)
rename s9q27a monthly_profit
gen annual_selfemp_profit = monthly_profit * months_activ
recode annual_selfemp_profit (.=0)
collapse (sum) annual_selfemp_profit, by (hhid)
lab var annual_selfemp_profit "Estimated annual net profit from self-employment over previous 12 months (Feb 15 - Jan 16)"
*4,613 HHs in total. 3,287 of them have current or closed non-farm enterprises.
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_self_employment_income.dta", replace

*Sales of processed crops were captured separately.
*Value crop inputs used in the processed products.
use "${raw_data}\secta3i_harvestw3.dta", clear
rename cropname crop_name
rename cropcode crop_code
rename sa3iq3 harvest_yesno
rename sa3iq6i quantity_harvested
rename sa3iq6ii unit
rename sa3iq6ii_os quantity_harvested_unit_other
rename sa3iq6a value_harvested
replace value_harvested = 0 if harvest_yesno==2
replace value_harvested = 0 if value_harvested==. & quantity_harvested == 0
rename sa3iq6b finished_harvest
rename sa3iq6d1 quantity_to_harvest
rename sa3iq6d2 quantity_to_harvest_unit
rename sa3iq6d2_os quantity_to_harvest_unit_other
collapse (sum) value_harvested quantity_harvested, by (hhid crop_code unit)
gen price_per_unit = value_harvested / quantity_harvested
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_hh_crop_unit_values.dta", replace

use "${raw_data}\secta3ii_harvestw3.dta", clear
rename cropname crop_name
rename cropcode crop_code
rename sa3iiq19 sell_processedcrop_yesno
rename sa3iiq20a quant_processed_crop_sold
rename sa3iiq20b unit
rename sa3iiq20b_os quant_proccrop_sold_unit_other
rename sa3iiq21 value_processed_crop_sold
merge m:1 hhid crop_code unit using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_hh_crop_unit_values.dta"
drop if _merge==2
drop _merge
merge m:1 crop_code unit using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_crop_prices_median_country.dta" 
drop if _merge==2
drop _merge
gen price_received = value_processed_crop_sold / quant_processed_crop_sold
gen price_as_input = price_per_unit
replace price_as_input = price_per_unit_median if price_as_input==.
replace price_as_input = price_received if price_as_input > price_received /* Where unit-value of input exceeds the unit-value of processed output, we'll cap the per-unit price at the processed output price */
gen value_crop_input = quant_processed_crop_sold * price_as_input
gen profit_processed_crop_sold = value_processed_crop_sold - value_crop_input
collapse (sum) profit_processed_crop_sold, by (hhid)
lab var profit_processed_crop_sold "Net value of processed crops sold, with crop inputs valued at the unit price for the harvest"
*Note that inputs/ expenses are not captured here. Might need to assume at least one unit raw product goes into processed, and deduct that value.
*This brings us back to the crop-unit issue in Nigeria. Hard to value these!
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_agproduct_income.dta", replace




***************
* WAGE INCOME *
***************

use "${raw_data}\sect3_harvestw3.dta", clear
rename s3q13b activity_code
rename s3q14 sector_code
rename s3q12b1 mainwage_yesno
rename s3q16 mainwage_number_months
rename s3q17 mainwage_number_weeks
rename s3q18 mainwage_number_hours
rename s3q21a mainwage_recent_payment
gen ag_activity = (sector_code==1)
replace mainwage_recent_payment = . if ag_activity==1 // exclude ag wages 
rename s3q21b mainwage_payment_period
rename s3q24a mainwage_recent_payment_other
replace mainwage_recent_payment_other = . if ag_activity==1
rename s3q24b mainwage_payment_period_other
rename s3q27 sec_sector_code
rename s3q25 secwage_yesno
rename s3q29 secwage_number_months
rename s3q30 secwage_number_weeks
rename s3q31 secwage_number_hours
rename s3q34a secwage_recent_payment
gen sec_ag_activity = (sec_sector_code==1)
replace secwage_recent_payment = . if sec_ag_activity==1 // exclude ag wages 
rename s3q34b secwage_payment_period
rename s3q37a secwage_recent_payment_other
replace secwage_recent_payment_other = . if sec_ag_activity==1
rename s3q44b other_sector_code
rename s3q37b secwage_payment_period_other
rename s3q42 othwage_yesno
rename s3q45 othwage_number_months
rename s3q46 othwage_number_weeks
rename s3q47 othwage_number_hours
rename s3q49a othwage_recent_payment
replace othwage_recent_payment = . if other_sector_code==1 // exclude ag wages
rename s3q49b othwage_payment_period
gen othwage_recent_payment_other = .
gen othwage_payment_period_other = .

local vars main sec oth
foreach p of local vars {
gen `p'wage_salary_cash = `p'wage_recent_payment if `p'wage_payment_period==8
replace `p'wage_salary_cash = ((`p'wage_number_months/6)*`p'wage_recent_payment) if `p'wage_payment_period==7
replace `p'wage_salary_cash = ((`p'wage_number_months/4)*`p'wage_recent_payment) if `p'wage_payment_period==6
replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_recent_payment) if `p'wage_payment_period==5
replace `p'wage_salary_cash = (`p'wage_number_months*(`p'wage_number_weeks/2)*`p'wage_recent_payment) if `p'wage_payment_period==4
replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_number_weeks*`p'wage_recent_payment) if `p'wage_payment_period==3
replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_number_weeks*(`p'wage_number_hours/8)*`p'wage_recent_payment) if `p'wage_payment_period==2
replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_number_weeks*`p'wage_number_hours*`p'wage_recent_payment) if `p'wage_payment_period==1
gen `p'wage_salary_other = `p'wage_recent_payment_other if `p'wage_payment_period_other==8
replace `p'wage_salary_other = ((`p'wage_number_months/6)*`p'wage_recent_payment_other) if `p'wage_payment_period_other==7
replace `p'wage_salary_other = ((`p'wage_number_months/4)*`p'wage_recent_payment_other) if `p'wage_payment_period_other==6
replace `p'wage_salary_other = (`p'wage_number_months*`p'wage_recent_payment_other) if `p'wage_payment_period_other==5
replace `p'wage_salary_other = (`p'wage_number_months*(`p'wage_number_weeks/2)*`p'wage_recent_payment_other) if `p'wage_payment_period_other==4
replace `p'wage_salary_other = (`p'wage_number_months*`p'wage_number_weeks*`p'wage_recent_payment_other) if `p'wage_payment_period_other==3
replace `p'wage_salary_other = (`p'wage_number_months*`p'wage_number_weeks*(`p'wage_number_hours/8)*`p'wage_recent_payment_other) if `p'wage_payment_period_other==2
replace `p'wage_salary_other = (`p'wage_number_months*`p'wage_number_weeks*`p'wage_number_hours*`p'wage_recent_payment_other) if `p'wage_payment_period_other==1
recode `p'wage_salary_cash `p'wage_salary_other (.=0)
gen `p'wage_annual_salary = `p'wage_salary_cash + `p'wage_salary_other
}
gen annual_salary = mainwage_annual_salary + secwage_annual_salary + othwage_annual_salary
collapse (sum) annual_salary, by (hhid)
lab var annual_salary "Estimated annual earnings from non-agricultural wage employment over previous 12 months"
*It's not clear why there are just 4,582 HHs in this file.
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_wage_income.dta", replace


*Ag wage income
use "${raw_data}\sect3_harvestw3.dta", clear
rename s3q13b activity_code
rename s3q14 sector_code
rename s3q12b1 mainwage_yesno
rename s3q16 mainwage_number_months
rename s3q17 mainwage_number_weeks
rename s3q18 mainwage_number_hours
rename s3q21a mainwage_recent_payment
gen ag_activity = (sector_code==1)
replace mainwage_recent_payment = . if ag_activity!=1 // include only ag wages
rename s3q21b mainwage_payment_period
rename s3q24a mainwage_recent_payment_other
replace mainwage_recent_payment_other = . if ag_activity!=1 // include only ag wages
rename s3q24b mainwage_payment_period_other
rename s3q25 secwage_yesno
rename s3q27 sec_sector_code
rename s3q29 secwage_number_months
rename s3q30 secwage_number_weeks
rename s3q31 secwage_number_hours
rename s3q34a secwage_recent_payment
gen sec_ag_activity = (sec_sector_code==1)
replace secwage_recent_payment = . if sec_ag_activity!=1
rename s3q34b secwage_payment_period
rename s3q37a secwage_recent_payment_other
replace secwage_recent_payment_other = . if sec_ag_activity!=1 // include only ag wages
rename s3q37b secwage_payment_period_other
rename s3q42 othwage_yesno
rename s3q44b other_sector_code
rename s3q45 othwage_number_months
rename s3q46 othwage_number_weeks
rename s3q47 othwage_number_hours
rename s3q49a othwage_recent_payment
replace othwage_recent_payment = . if other_sector_code!=1 // include only ag wages
rename s3q49b othwage_payment_period
gen othwage_recent_payment_other = .
gen othwage_payment_period_other = .
local vars main sec oth
foreach p of local vars {
gen `p'wage_salary_cash = `p'wage_recent_payment if `p'wage_payment_period==8
replace `p'wage_salary_cash = ((`p'wage_number_months/6)*`p'wage_recent_payment) if `p'wage_payment_period==7
replace `p'wage_salary_cash = ((`p'wage_number_months/4)*`p'wage_recent_payment) if `p'wage_payment_period==6
replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_recent_payment) if `p'wage_payment_period==5
replace `p'wage_salary_cash = (`p'wage_number_months*(`p'wage_number_weeks/2)*`p'wage_recent_payment) if `p'wage_payment_period==4
replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_number_weeks*`p'wage_recent_payment) if `p'wage_payment_period==3
replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_number_weeks*(`p'wage_number_hours/8)*`p'wage_recent_payment) if `p'wage_payment_period==2
replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_number_weeks*`p'wage_number_hours*`p'wage_recent_payment) if `p'wage_payment_period==1
gen `p'wage_salary_other = `p'wage_recent_payment_other if `p'wage_payment_period_other==8
replace `p'wage_salary_other = ((`p'wage_number_months/6)*`p'wage_recent_payment_other) if `p'wage_payment_period_other==7
replace `p'wage_salary_other = ((`p'wage_number_months/4)*`p'wage_recent_payment_other) if `p'wage_payment_period_other==6
replace `p'wage_salary_other = (`p'wage_number_months*`p'wage_recent_payment_other) if `p'wage_payment_period_other==5
replace `p'wage_salary_other = (`p'wage_number_months*(`p'wage_number_weeks/2)*`p'wage_recent_payment_other) if `p'wage_payment_period_other==4
replace `p'wage_salary_other = (`p'wage_number_months*`p'wage_number_weeks*`p'wage_recent_payment_other) if `p'wage_payment_period_other==3
replace `p'wage_salary_other = (`p'wage_number_months*`p'wage_number_weeks*(`p'wage_number_hours/8)*`p'wage_recent_payment_other) if `p'wage_payment_period_other==2
replace `p'wage_salary_other = (`p'wage_number_months*`p'wage_number_weeks*`p'wage_number_hours*`p'wage_recent_payment_other) if `p'wage_payment_period_other==1
recode `p'wage_salary_cash `p'wage_salary_other (.=0)
gen `p'wage_annual_salary = `p'wage_salary_cash + `p'wage_salary_other
}
gen annual_salary_agwage = mainwage_annual_salary + secwage_annual_salary + othwage_annual_salary
collapse (sum) annual_salary_agwage, by (hhid)
lab var annual_salary_agwage "Estimated annual earnings from agricultural wage employment over previous 12 months"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_agwage_income.dta", replace 
/*Note: It seems possible that we're not capturing agricultural wage work, or that 
most agricultural labor is sold on an "exchange" basis, rather than for a wage. 
So far, we have a "loose" definition of agricultural wage work as any wage work in the agricultural sector (not just laborers). */



***************
*OTHER INCOME *
***************

use "${raw_data}\sect6_harvestw3.dta", clear
*To convert from US dollars and Euros, we'll use the June 2015 exchange rate.
*https://fx-rate.net/NGN/?date_input=2015-06-05
*1 USD --> 199 naira; 1 Euro --> 223.1 naira for June 5, 2015 

rename s6q4a cash_received
rename s6q4b cash_received_unit
rename s6q8a inkind_received
rename s6q8b inkind_received_unit
local vars cash_received inkind_received
foreach p of local vars {
replace `p' = `p'*199 if `p'_unit==1
replace `p' = `p'*223.1 if `p'_unit==2
replace `p'_unit = 5 if `p'_unit==1|`p'_unit==2
tab `p'_unit
}

recode cash_received inkind_received (.=0)
gen remittance_income = cash_received + inkind_received
collapse (sum) remittance_income, by (hhid)
lab var remittance_income "Estimated income from OVERSEAS remittances over previous 12 months"
*Note that this does not capture domestic remittances, which is confusing.
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_remittance_income.dta", replace

use "${raw_data}\sect13_harvestw3.dta", clear
append using "${raw_data}\sect14_harvestw3.dta"
append using "${raw_data}\secta4_harvestw3.dta"
rename s13q2 investment_income
rename s13q5 rental_income_buildings
rename s13q8 other_income 
rename s14q2a assistance_cash
rename s14q2d assistance_food
rename s14q2e assistance_inkind
rename sa4q7 rental_income_assets
recode investment_income rental_income_buildings other_income assistance_cash assistance_food assistance_inkind rental_income_assets (.=0)
gen assistance_income = assistance_cash + assistance_food + assistance_inkind
collapse (sum) investment_income rental_income_buildings other_income assistance_income rental_income_assets, by (hhid)
lab var investment_income "Estimated income from interest or investments over previous 12 months"
lab var rental_income_buildings "Estimated income from rentals of buildings, tools, land, transport animals over previous 12 months"
lab var other_income "Estimated income from any OTHER source over previous 12 months"
lab var assistance_income "Estimated income from a food aid, food-for-work, etc. over previous 12 months"
lab var rental_income_assets "Estimated income from rentals of tools and other agricultural assets over previous 12 months"
*Does not seem to include animal traction or buildings.
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_other_income.dta", replace

*Land rental
use "${raw_data}\sect11b1_plantingw3.dta", clear
rename s11b1q29 year_rented
rename s11b1q31 land_rental_income_cash
rename s11b1q33 land_rental_income_inkind
recode land_rental_income_cash land_rental_income_inkind (.=0)
gen land_rental_income = land_rental_income_cash + land_rental_income_inkind
replace land_rental_income = . if year_rented < 2015 | year_rented == .
collapse (sum) land_rental_income, by (hhid)
lab var land_rental_income "Estimated income from renting out land over previous 12 months"
*This low rate of renting out land seems very unrealistic.
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_land_rental_income.dta", replace


*Income from gathering forest products (not sure whether this should be valued)
use "${raw_data}\sect11e_harvestw3.dta", clear
rename s11eq10 value_used
rename s11eq11 value_purchased
recode value_used value_purchased (.=0)
gen value_forest_products = value_used - value_purchased
collapse (sum) value_forest_products, by (hhid)
lab var value_forest_products "Value of bamboo and grass gathered and used by the household"
*Since this is often negative, suggesting the enumerators didn't understand the questionnaire, I suggest we skip this.




***********************
* FARM SIZE/LAND SIZE *
***********************

use "${raw_data}\secta3i_harvestw3.dta", clear
gen cultivated = 1
merge m:1 hhid plotid using "${raw_data}\sect11b1_plantingw3.dta"
rename s11b1q27 cultivated_this_year
replace cultivated = 1 if cultivated_this_year==1 & cultivated==.
rename plotid plot_id
collapse (max) cultivated, by (hhid plot_id)
lab var cultivated "1= Parcel was cultivated in this data set"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_parcels_cultivated.dta", replace

use "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_plot_areas.dta", clear
merge m:1 hhid plot_id using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_parcels_cultivated.dta"
keep if cultivated==1
collapse (sum) field_size, by (hhid plot_id)
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_plot_sizes.dta", replace
collapse (sum) field_size, by (hhid)
rename field_size farm_area
lab var farm_area "Land size (denominator for land productivitiy), in hectares" /* Uses measures */
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_land_size.dta", replace

*All Agricultural Land
use "${raw_data}\sect11b1_plantingw3.dta", clear
rename plotid plot_id
gen agland = (s11b1q27==1 | s11b1q28==1 | s11b1q28==6) // Cultivated, fallow, or pasture
keep if agland==1
keep hhid plot_id agland
lab var agland "1= Plot was cultivated, left fallow, or used for pasture"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_parcels_agland.dta", replace


use "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_plot_areas.dta", clear
merge 1:1 hhid plot_id using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_parcels_agland.dta", nogen
keep if agland==1
collapse (sum) field_size, by (hhid)
rename field_size farm_size_agland
lab var farm_size_agland "Land size in hectares, including all plots cultivated, fallow, or pastureland"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_farmsize_all_agland.dta", replace




************
*LAND SIZE
************

use "${raw_data}\sect11b1_plantingw3.dta", clear
rename plotid plot_id
gen rented_out = 1 if s11b1q29==2015 // It's not logical that there are so few rented-out plots
drop if rented_out==1
gen plot_held=1
keep hhid plot_id plot_held
lab var plot_held "1= Plot was NOT rented out in 2015"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_parcels_held.dta", replace

use "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_plot_areas.dta", clear
merge 1:1 hhid plot_id using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_parcels_held.dta", nogen
keep if plot_held==1
collapse (sum) field_size, by (hhid)
rename field_size land_size
lab var land_size "Land size in hectares, including all plots listed by the household (and not rented out)"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_land_size_all.dta", replace 





************
*FARM LABOR
************

use "${raw_data}\sect11c1_plantingw3.dta", clear
rename s11c1q2 number_men
rename s11c1q3 number_days_men
rename s11c1q5 number_women
rename s11c1q6 number_days_women
rename s11c1q8 number_children
rename s11c1q9 number_days_children
gen days_men = number_men * number_days_men 
gen days_women = number_women * number_days_women  
gen days_children = number_children * number_days_children 
recode days_men days_women days_children (.=0)
gen days_hired_postplant =  days_men + days_women + days_children
rename s11c1q1a2 weeks_1 
rename s11c1q1a3 days_week_1 
rename s11c1q1b2 weeks_2
rename s11c1q1b3 days_week_2
rename s11c1q1c2 weeks_3
rename s11c1q1c3 days_week_3
rename s11c1q1d2 weeks_4
rename s11c1q1d3 days_week_4
recode weeks_1 days_week_1 weeks_2 days_week_2 weeks_3 days_week_3 weeks_4 days_week_4 (.=0)
gen days_famlabor_postplant = (weeks_1 * days_week_1) + (weeks_2 * days_week_2) + (weeks_3 * days_week_3) + (weeks_4 * days_week_4)
collapse (sum) days_hired_postplant days_famlabor_postplant, by (hhid)
lab var days_hired_postplant "Workdays for hired labor (crops), as captured in post-planting survey"
lab var days_famlabor_postplant "Workdays for family labor (crops), as captured in post-planting survey"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_farmlabor_postplanting.dta", replace

use "${raw_data}\secta2_harvestw3.dta", clear
rename sa2q2 number_men
rename sa2q3 number_days_men
rename sa2q5 number_women
rename sa2q6 number_days_women
rename sa2q8 number_children
rename sa2q9 number_days_children
gen days_men = number_men * number_days_men 
gen days_women = number_women * number_days_women  
gen days_children = number_children * number_days_children 
recode days_men days_women days_children (.=0)
gen days_hired_postharvest =  days_men + days_women + days_children

*From between planting and harvest
rename sa2q1c number_men2 // Hired labor
rename sa2q1d number_days_men2 
rename sa2q1f number_women2 
rename sa2q1g number_days_women2 
rename sa2q1i number_children2 
rename sa2q1j number_days_children2 
gen days_men2 = number_men2 * number_days_men2
gen days_women2 = number_women2 * number_days_women2  
gen days_children2 = number_children2 * number_days_children2 
recode days_men2 days_women2 days_children2 (.=0)
gen days_hired_postharvest2 =  days_men2 + days_women2 + days_children2
replace days_hired_postharvest = days_hired_postharvest + days_hired_postharvest2 // Includes pre-harvest AND harvest labor

rename sa2q1b_a2 weeks_1 
rename sa2q1b_a3 days_week_1 
rename sa2q1b_b2 weeks_2
rename sa2q1b_b3 days_week_2
rename sa2q1b_c2 weeks_3
rename sa2q1b_c3 days_week_3
rename sa2q1b_d2 weeks_4
rename sa2q1b_d3 days_week_4
rename sa2q1b_e2 weeks_5
rename sa2q1b_e3 days_week_5
rename sa2q1b_f2 weeks_6
rename sa2q1b_f3 days_week_6
rename sa2q1b_g2 weeks_7
rename sa2q1b_g3 days_week_7
rename sa2q1b_h2 weeks_8
rename sa2q1b_h3 days_week_8
rename sa2q1a2 weeks_9
rename sa2q1a3 days_week_9
rename sa2q1b2 weeks_10
rename sa2q1b3 days_week_10
rename sa2q1c2 weeks_11
rename sa2q1c3 days_week_11
rename sa2q1d2 weeks_12
rename sa2q1d3 days_week_12
rename sa2q1e2 weeks_13
rename sa2q1e3 days_week_13
rename sa2q1f2 weeks_14
rename sa2q1f3 days_week_14
rename sa2q1g2 weeks_15
rename sa2q1g3 days_week_15
rename sa2q1h2 weeks_16
rename sa2q1h3 days_week_16
rename sa2q1n_a number_exchange_men2 // Exchange labor before harvest
rename sa2q1n_b number_exchange_women2 
rename sa2q1n_c number_exchange_children2 
rename sa2q12a number_exchange_men // Exchange labor for harvest, we understand this to be "person-days", as only the number of days was asked.
rename sa2q12b number_exchange_women 
rename sa2q12c number_exchange_children

recode number_exchange_men2 number_exchange_women2 number_exchange_children2 number_exchange_men number_exchange_women number_exchange_children (.=0)
recode weeks_1 days_week_1 weeks_2 days_week_2 weeks_3 days_week_3 weeks_4 days_week_4 /*
*/ weeks_5 days_week_5 weeks_6 days_week_6 weeks_7 days_week_7 weeks_8 days_week_8 /*
*/ weeks_9 days_week_9 weeks_10 days_week_10 weeks_11 days_week_11 weeks_12 days_week_12 /*
*/ weeks_13 days_week_13 weeks_14 days_week_14 weeks_15 days_week_15 weeks_16 days_week_16 (.=0)
gen days_famlabor_postharvest = (weeks_1 * days_week_1) + (weeks_2 * days_week_2) + (weeks_3 * days_week_3) + (weeks_4 * days_week_4) /*
*/ + (weeks_5 * days_week_5) + (weeks_6 * days_week_6) + (weeks_7 * days_week_7) + (weeks_8 * days_week_8) + /*
*/ (weeks_9 * days_week_9) + (weeks_10 * days_week_10) + (weeks_11 * days_week_11) + (weeks_12 * days_week_12) + /*
*/ (weeks_13 * days_week_13) + (weeks_14 * days_week_14) + (weeks_15 * days_week_15) + (weeks_16 * days_week_16)
gen days_exchange_labor_postharvest = number_exchange_men2 + number_exchange_women2 + number_exchange_children2 /*
*/ + number_exchange_men + number_exchange_women + number_exchange_children
collapse (sum) days_hired_postharvest days_famlabor_postharvest days_exchange_labor_postharvest, by (hhid)
lab var days_hired_postharvest "Workdays for hired labor (crops), as captured in post-harvest survey"
lab var days_famlabor_postharvest "Workdays for family labor (crops), as captured in post-harvest survey"
lab var days_exchange_labor_postharvest "Workdays (lower-bound estimate) of exchange labor, as captured in post-harvest survey"
save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_farmlabor_postharvest.dta", replace 



*****************
* VACCINE USAGE *
*****************

use "${raw_data}/sect11i_plantingw3.dta", clear
gen vac_animal=.
replace vac_animal=1 if s11iq22>=1 & s11iq1==1
replace vac_animal=0 if s11iq22==0 & s11iq1==1
replace vac_animal=. if s11iq22==.
collapse (max) vac_animal, by (hhid)
lab var vac_animal "1= Household has an animal vaccinated"
save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_vaccine.dta", replace



*******************************
* USE OF INORGANIC FERTILIZER *
*******************************

use "${raw_data}/secta11d_harvestw3.dta", clear
gen use_inorg_fert=0
replace use_inorg_fert=1 if s11dq1a==1
replace use_inorg_fert=0 if s11dq1==2 | s11dq1a==2
replace use_inorg_fert=. if s11dq1==1 & s11dq1a==.
collapse (max) use_inorg_fert, by (hhid)
la var use_inorg_fert "1= Household uses inorganic fertilizer"
save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_fert_use.dta", replace 


************************
* USE OF IMPROVED SEED *
************************

use "${raw_data}/sect11e_plantingw3.dta", clear
gen imprv_seed_use=.
replace imprv_seed_use=1 if s11eq3b==1 |  s11eq3b==2
replace imprv_seed_use=0 if s11eq3b==3 |  s11eq3b==4
replace imprv_seed_use=. if s11eq3b==.
collapse (max) imprv_seed_use, by (hhid)
la var imprv_seed_use "1= Household uses improved seed"
save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_improvedseed_use.dta", replace 




***************************
* REACHED BY AG EXTENSION *
***************************


use "${raw_data}/sect11l1_plantingw3.dta", clear
merge m:m hhid using "${raw_data}/secta5a_harvestw3.dta", nogen

gen no_info_pp=.
replace no_info_pp=1 if s11l1q1==2 & s11l1q2==.

gen ext_pp=.
replace ext_pp=1 if s11l1q2==1 | s11l1q2==2 | s11l1q2==3 | s11l1q2==4 | s11l1q2==5 | s11l1q2==6 | s11l1q2==7 | s11l1q2==8 | s11l1q2==9 | s11l1q2==12 | s11l1q2==13
replace ext_pp=0 if s11l1q2==10 | s11l1q2==11 | s11l1q2==14 | no_info_pp==1

gen no_info_ph=.
replace no_info_ph=1 if sa5aq1==2 & sa5aq2==.

gen ext_ph=.
replace ext_ph=1 if sa5aq2==1 | sa5aq2==2 | sa5aq2==3 | sa5aq2==4 | sa5aq2==5 | sa5aq2==6 | sa5aq2==7 | sa5aq2==8 | sa5aq2==9 | sa5aq2==12 | sa5aq2==13
replace ext_ph=0 if sa5aq2==10 | sa5aq2==11 | sa5aq2==14 | no_info_ph==1

gen ext_reach=.
replace ext_reach=1 if ext_pp==1 | ext_ph==1 
replace ext_reach=0 if ext_pp==0 & ext_ph==0 
replace ext_reach=. if ext_pp==. & ext_ph==. 

collapse (max) ext_reach, by (hhid)
la var ext_reach "1= Household reached by extention services"


save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_any_ext.dta", replace 




************************************
* USE OF FORMAL FINANCIAL SERVICES *
************************************

use "${raw_data}/sect4a_plantingw3.dta", clear
merge m:m hhid using "${raw_data}/sect4b_plantingw3.dta", nogen
merge m:m hhid using "${raw_data}/sect4c1_plantingw3.dta", nogen
merge m:m hhid using "${raw_data}/sect4c3_plantingw3.dta", nogen
merge m:m hhid using "${raw_data}/sect9_harvestw3.dta", nogen

gen rec_loan=0
replace rec_loan=1 if s4cq1==1 & s4cq12==2
replace rec_loan=0 if s4cq1==2 | s4cq12==1
replace rec_loan=. if s4cq1==.

gen use_fin_serv=0
replace use_fin_serv=1 if s4aq1==1 | s4aq8==1 | s4aq16==1 | s4bq10b==1 | rec_loan==1 | s9q17==1
replace use_fin_serv=0 if s4aq1==2 & s4aq8==2 & s4aq16==2 & s4bq10b==2 & rec_loan==0 & s9q17==2
replace use_fin_serv=. if s4aq1==. & s4aq8==. & s4aq16==. & s4bq10b==. & s4cq1==. & s9q17==.

collapse (max) use_fin_serv, by (hhid)
la var use_fin_serv "1= Household uses formal financial services"

save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_fin_serv.dta", replace 




*************************
*GENDER PRODUCTIVITY GAP
*************************

use "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_plot_areas.dta", clear
merge m:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_weights.dta", keep (1 3) nogen
merge 1:1 hhid plot_id using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_plot_cropvalue.dta", keep (1 3) nogen
merge 1:1 hhid plot_id using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_plot_decision_makers", keep (1 3) nogen // Bring in the gender file
gen plot_weight = field_size*weight
ren field_size  area_meas_hectares
lab var plot_weight "Weight for plots (weighted by plot area)"
drop if area_meas_hectares==.
keep if cultivate==1

*winsorize
sum area_meas_hectares  [aw=weight]  if dm_gender==1  , d  
replace area_meas_hectares =r(p99) if area_meas_hectares>r(p99) & area_meas_hectares!=. &  dm_gender==1
sum plot_value_harvest [aw=weight]   if dm_gender==1  , d  
replace plot_value_harvest =r(p99) if plot_value_harvest>r(p99) & plot_value_harvest!=. &  dm_gender==1

sum area_meas_hectares [aw=weight]   if dm_gender==2  , d  
replace area_meas_hectares =r(p99) if area_meas_hectares>r(p99) & area_meas_hectares!=. &  dm_gender==2
sum plot_value_harvest [aw=weight]   if dm_gender==2  , d  
replace plot_value_harvest =r(p99) if plot_value_harvest>r(p99) & plot_value_harvest!=. &  dm_gender==2

sum area_meas_hectares [aw=weight]   if dm_gender==3  , d  
replace area_meas_hectares =r(p99) if area_meas_hectares>r(p99) & area_meas_hectares!=. &  dm_gender==3
sum plot_value_harvest [aw=weight]   if dm_gender==3  , d  
replace plot_value_harvest =r(p99) if plot_value_harvest>r(p99) & plot_value_harvest!=. &  dm_gender==3

*exchange rate
global exchange_rate 199.04975
global ppp_dollar 94.10
gen plot_value_harvest_usd=plot_value_harvest/$exchange_rate
gen plot_productivity_usd = plot_value_harvest_usd / area_meas_hectares
lab var plot_productivity_usd "Value of crop production per hectare (plot-level) (2016 USD/ha)"
lab var plot_value_harvest_usd "Value of crop production (plot-level) (2016 USD/ha)"

gen plot_value_harvest_ppp= plot_value_harvest/$ppp_dollar
gen plot_value_productivity_ppp= plot_value_harvest_ppp/ area_meas_hectares
lab var plot_value_productivity_ppp "Value of crop production per hectare (plot-level) (PPP/ha)"
lab var plot_value_harvest_ppp "Value of crop production (plot-level) (PPP/ha)"

tabstat plot_productivity_usd  [aw=plot_weight]  if rural==1 &  dm_gender!=., stat(mean sd p50   min max N) col(stat) save
gen plot_productivity_all_usd=el(r(StatTotal),1,1)
tabstat plot_productivity_usd  [aw=plot_weight]   if rural==1 & dm_gender==1, stat(mean sd p50   min max N) col(stat) save
gen plot_productivity_male_usd=el(r(StatTotal),1,1)
tabstat plot_productivity_usd  [aw=plot_weight]   if rural==1 & dm_gender==2, stat(mean sd p50   min max N) col(stat) save 
gen plot_productivity_female_usd=el(r(StatTotal),1,1)
tabstat plot_productivity_usd  [aw=plot_weight]   if rural==1 & dm_gender==3, stat(mean sd p50   min max N) col(stat) save   
gen plot_productivity_mixed_usd=el(r(StatTotal),1,1) if rural==1 & dm_gender!=.
gen gender_prod_gap1=100*(plot_productivity_male-plot_productivity_female)/plot_productivity_male
sum gender_prod_gap1
lab var gender_prod_gap "Gender productivity gap (%)"
save "${final_data}\Nigeria_GHSP_LSMS_ISA_W3_gender_productivity_gap.dta", replace
 

*********************
* MILK PRODUCTIVITY *
*********************

*Cannot construct




********************
* EGG PRODUCTIVITY *
********************

*Cannot construct



*************************************
* CROP PRODUCTION COSTS PER HECTARE *
*************************************



*Land rental rates
use "${raw_data}/sect11b1_plantingw3.dta", clear
ren plotid plot_id
merge 1:1 plot_id hhid using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_plot_areas", nogen keep(1 3)
merge 1:1 plot_id hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_plot_decision_makers", nogen keep (1 3)
egen plot_rental_rate = rowtotal(s11b1q13 s11b1q14)		// cash (s11b1q13) and in-kind (s11b1q14)
recode plot_rental_rate (0=.)
preserve
	gen value_rented_land = plot_rental_rate
	gen value_rented_land_male = plot_rental_rate if dm_gender==1
	gen value_rented_land_female = plot_rental_rate if dm_gender==2
	gen value_rented_land_mixed = plot_rental_rate if dm_gender==3
	collapse (sum) value_rented_land_* value_rented_land = plot_rental_rate, by(hhid)			// total paid for rent at household level
	save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_hh_rental_rate.dta", replace
restore
gen ha_rental_rate_hh = plot_rental_rate/field_size

*Now, getting total area of all plots that were cultivated this year (almost all plots; 97.4 percent)
*gen cultivate = s11b1q27==1
preserve
	gen ha_cultivated_plots = field_size if cultivate==1					// non-missing only if plot was cultivated
	collapse (sum) ha_cultivated_plots, by(hhid)		// total ha of all plots that were cultivated
	save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_hh_cultivated_plots_ha.dta", replace
restore

*Now, getting household-level average rental rate (for households that rented any)
preserve
	keep if plot_rental_rate!=. & plot_rental_rate!=0			// keeping only plots that were rented (and non-zero paid)
	collapse (sum) plot_rental_rate field_size, by(hhid)			// collapsing total paid and area rented to household level
	gen ha_rental_hh = plot_rental_rate/field_size				// naira per ha
	drop field_size
	save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_rental_rate_hh.dta", replace			// this data will have the actual rental rates for households
restore

*Geographic medians
bys zone state lga sector: egen ha_rental_count_sect = count(ha_rental_rate_hh)
bys zone state lga sector: egen ha_rental_rate_sect = median(ha_rental_rate_hh)
bys zone state lga: egen ha_rental_count_lga = count(ha_rental_rate_hh)
bys zone state lga: egen ha_rental_rate_lga = median(ha_rental_rate_hh)
bys zone state: egen ha_rental_count_state = count(ha_rental_rate_hh)
bys zone state: egen ha_rental_rate_state = median(ha_rental_rate_hh)
bys zone: egen ha_rental_count_zone = count(ha_rental_rate_hh)
bys zone: egen ha_rental_rate_zone = median(ha_rental_rate_hh)
egen ha_rental_rate_nat = median(ha_rental_rate_hh)

gen ha_rental_rate = ha_rental_rate_sect if ha_rental_count_sect>=10
replace ha_rental_rate = ha_rental_rate_lga if ha_rental_count_lga>=10 & ha_rental_rate==.
replace ha_rental_rate = ha_rental_rate_state if ha_rental_count_state>=10 & ha_rental_rate==.
replace ha_rental_rate = ha_rental_rate_zone if ha_rental_count_zone>=10 & ha_rental_rate==.
replace ha_rental_rate = ha_rental_rate_nat if ha_rental_rate==.

collapse (firstnm) ha_rental_rate, by(zone state lga sector)
save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_rental_rate.dta", replace


*Now getting area planted
use "${raw_data}/sect11f_plantingw3.dta", clear
ren plotid plot_id
*Merging in gender of plot manager
merge m:1 plot_id hhid using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_plot_areas", nogen keep(1 3)

*There are a lot of unconventional measurements
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

gen ha_planted = s11fq1a*conversion

*Rescaling
merge m:1 plot_id hhid using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_plot_areas", nogen keep(1 3)			// merging in plot areas; 120 not merged from USING, dropping these
merge m:1 plot_id hhid using "$created_data\Nigeria_GHSP_LSMS_ISA_W3_plot_decision_makers", nogen keep(1 3)
bys plot_id hhid: egen total_ha_planted = total(ha_planted)						// total REPORTED ha planted
replace ha_planted = ha_planted*(field_size/total_ha_planted) if total_ha_planted>field_size	// 8,419 changes! almost everything!
sum ha_planted, d							// this is MUCH better; mean=0.242 and median=0.104

gen ha_planted_male = ha_planted if dm_gender==1
gen ha_planted_female = ha_planted if dm_gender==2
gen ha_planted_mixed = ha_planted if dm_gender==3

ren plot_id plotid

*Merging in rental rate (both at aggregate level and at household level)
merge m:1 hhid plotid using "${raw_data}/sect11b1_plantingw3.dta", nogen keep(1 3)		// merging to get whether plot was rented. 120 not merged from USING; dropping these
egen plot_rent = rowtotal(s11b1q13 s11b1q14)										// total paid for rent (on plot)
merge m:1 hhid using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_rental_rate_hh.dta", nogen keep(1 3)			// household's average rental rate (total rent paid divided by total ha rented at household level)
merge m:1 zone state lga sector using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_rental_rate.dta", nogen keep(1 3)	// aggregate rental rates

gen value_owned_land = ha_planted*ha_rental_rate if (plot_rent==. | plot_rent==0)		// generate value owned using aggregate rental rate - only for plots that were not rented
replace value_owned_land = ha_planted*ha_rental_hh if (plot_rent==. | plot_rent==0) & ha_rental_hh!=. & ha_rental_hh!=0		// replace value owned when household had valid rental observations on OTHER plots - still not including plots that were actually rented

*Repeating for male
gen value_owned_land_male = ha_planted*ha_rental_rate if (plot_rent==. | plot_rent==0) & dm_gender==1
replace value_owned_land_male = ha_planted*ha_rental_hh if (plot_rent==. | plot_rent==0) & ha_rental_hh!=. & ha_rental_hh!=0 & dm_gender==1

*Repeating for female
gen value_owned_land_female = ha_planted*ha_rental_rate if (plot_rent==. | plot_rent==0) & dm_gender==2
replace value_owned_land_female = ha_planted*ha_rental_hh if (plot_rent==. | plot_rent==0) & ha_rental_hh!=. & ha_rental_hh!=0 & dm_gender==2

*Repeating for mixed
gen value_owned_land_mixed = ha_planted*ha_rental_rate if (plot_rent==. | plot_rent==0) & dm_gender==3
replace value_owned_land_mixed = ha_planted*ha_rental_hh if (plot_rent==. | plot_rent==0) & ha_rental_hh!=. & ha_rental_hh!=0 & dm_gender==3

collapse (sum) value_owned_land* ha_planted*, by(hhid)
save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_hh_cost_land.dta", replace





*Prep labor costs
use "${raw_data}/sect11c1_plantingw3.dta", clear		// PREP LABOR
*Merging in gender of plot manager
rename plotid plot_id
merge m:1 plot_id hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_plot_decision_makers", nogen keep(1 3) keepusing (dm_gender)

*NOTE: It is not clear to me from the questionnaire whether we should construct hired days as days times individuals or just days. I THINK it is the former, but I'm not completely sure.
gen male_hired_days = s11c1q3*s11c1q2
gen female_hired_days = s11c1q6*s11c1q5
gen child_hired_days = s11c1q9*s11c1q8

gen wage_male = s11c1q4/s11c1q2		// total paid per day to all men divided by number of men
gen wage_female = s11c1q7/s11c1q5
gen wage_child = s11c1q10/s11c1q8
sum wage_*, d
recode wage_* (0=.)

gen value_male_hired = male_hired_days*wage_male
gen value_female_hired = female_hired_days*wage_female
gen value_child_hired = child_hired_days*wage_child

*Generating average wage at the household level
preserve
	foreach i in male female child{
		gen wage_`i'_total = wage_`i'*`i'_hired_days		// wage per day times number of hired days
	}
	collapse (sum) wage_*_total *hired_days, by(hhid)		// summing total paid to all workers and total number of hired days to household level.
	foreach i in male female child{
		gen wage_`i'_hh = wage_`i'_total/`i'_hired_days		// generating an average household wage as total wage paid divided by total hired days (naira per day)
	}
	keep wage_*_hh hhid
	save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_hh_wages_prep.dta", replace
restore

*Geographic medians
foreach i in male female child{
	bys zone state lga sector: egen `i'_count_sect = count(wage_`i')
	bys zone state lga sector: egen `i'_price_sect = median(wage_`i')
	bys zone state lga: egen `i'_count_lga = count(wage_`i')
	bys zone state lga: egen `i'_price_lga = median(wage_`i')
	bys zone state: egen `i'_count_state = count(wage_`i')
	bys zone state: egen `i'_price_state = median(wage_`i')
	bys zone: egen `i'_count_zone = count(wage_`i')
	bys zone: egen `i'_price_zone = median(wage_`i')
	egen `i'_price_nat = median(wage_`i')
	
	*Generating wage
	gen `i'_wage_rate = `i'_price_sect if `i'_count_sect>=10
	replace `i'_wage_rate = `i'_price_lga if `i'_count_lga>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_price_state if `i'_count_state>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_price_zone if `i'_count_zone>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_price_nat if `i'_wage_rate==.
}

*To do family labor, we first need to merge in gender
preserve
	use "${raw_data}/sect1_plantingw3.dta", clear
	ren indiv pid
	isid hhid pid		// check
	gen male = s1q2==1
	gen age = s1q6
	keep hhid pid age male
	tempfile members
	save `members', replace
restore
*Starting with "member 1"
gen pid = s11c1q1a1
merge m:1 hhid pid using `members', gen(fam_merge1) keep(1 3)
count if s11c1q1a3!=0 & s11c1q1a3!=. & fam_merge1==1			// 0
ren male male1
ren pid pid1 
ren age age1
*Now "member 2"
gen pid = s11c1q1b1
merge m:1 hhid pid using `members', gen(fam_merge2) keep(1 3)
ren male male2
ren pid pid12
ren age age2
*Now "member 3"
gen pid = s11c1q1c1
merge m:1 hhid pid using `members', gen(fam_merge3) keep(1 3)
ren male male3
ren pid pid13
ren age age3
*Now "member 4"
gen pid = s11c1q1d1
merge m:1 hhid pid using `members', gen(fam_merge4) keep(1 3)
ren male male4
ren pid pid14
ren age age4

recode male1 male2 male3 male4 (.=1)		// NOTE: Assuming male if missing (replaces a lot of missings because there often isn't a male3 or male4 reported. However, this will not effect estimates since days worked will be missing for these.
gen male_fam_days1 = s11c1q1a2*s11c1q1a3 if male1 & age1>=15		// if male and older than 15 or age is missing; NOTE: Assuming missing ages are adults
gen male_fam_days2 = s11c1q1b2*s11c1q1b3 if male2 & age2>=15
gen male_fam_days3 = s11c1q1c2*s11c1q1c3 if male3 & age3>=15
gen male_fam_days4 = s11c1q1d2*s11c1q1d3 if male4 & age4>=15
gen female_fam_days1 = s11c1q1a2*s11c1q1a3 if !male1 & age1>=15		//  NOTE: Assuming missing ages are adults
gen female_fam_days2 = s11c1q1b2*s11c1q1b3 if !male2 & age2>=15
gen female_fam_days3 = s11c1q1c2*s11c1q1c3 if !male3 & age3>=15
gen female_fam_days4 = s11c1q1d2*s11c1q1d3 if !male4 & age4>=15
gen child_fam_days1 = s11c1q1a2*s11c1q1a3 if age1<15
gen child_fam_days2 = s11c1q1b2*s11c1q1b3 if age2<15
gen child_fam_days3 = s11c1q1c2*s11c1q1c3 if age3<15
gen child_fam_days4 = s11c1q1d2*s11c1q1d3 if age4<15

egen total_male_fam_days = rowtotal(male_fam_days*)
egen total_female_fam_days = rowtotal(female_fam_days*)
egen total_child_fam_days = rowtotal(child_fam_days*)

*And here are the total costs
merge m:1 hhid using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_hh_wages_prep.dta", nogen keep(1 3)		// merging in household-level wage rates; all matched

*Now, valuing household labor
*Using aggregate wages
gen value_male_nonhired = total_male_fam_days*male_wage_rate
gen value_female_nonhired = total_female_fam_days*female_wage_rate
gen value_child_nonhired = total_child_fam_days*child_wage_rate
*Now, replacing with household wage rate where available
replace value_male_nonhired = total_male_fam_days*wage_male_hh if (wage_male_hh!=. & wage_male_hh!=0)
replace value_female_nonhired = total_female_fam_days*wage_female_hh if (wage_female_hh!=. & wage_female_hh!=0)
replace value_child_nonhired = total_child_fam_days*wage_child_hh if (wage_child_hh!=. & wage_child_hh!=0)

egen value_hired_labor = rowtotal(value_male_hired value_female_hired value_child_hired)
egen value_fam_labor = rowtotal(value_male_nonhired value_female_nonhired value_child_nonhired)

gen value_hired_labor_male = value_hired_labor if dm_gender==1
gen value_hired_labor_female = value_hired_labor if dm_gender==2
gen value_hired_labor_mixed = value_hired_labor if dm_gender==3
gen value_fam_labor_male = value_fam_labor if dm_gender==1
gen value_fam_labor_female = value_fam_labor if dm_gender==2
gen value_fam_labor_mixed = value_fam_labor if dm_gender==3

collapse (sum) value_hired* value_fam*, by(hhid)
save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_hh_cost_prep_labor.dta", replace



* Between planting and harvest labor 
use "${raw_data}/secta2_harvestw3.dta", clear
*Merging in gender of plot manager
rename plotid plot_id
merge m:1 plot_id hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_plot_decision_makers", nogen keep(1 3) keepusing(dm_gender)

gen male_hired_days = sa2q1d*sa2q1c
gen female_hired_days = sa2q1g*sa2q1f
gen child_hired_days = sa2q1j*sa2q1i

gen wage_male = sa2q1e/sa2q1c
gen wage_female = sa2q1h/sa2q1f
gen wage_child = sa2q1k/sa2q1i
recode wage_* (0=.)

gen value_male_hired = male_hired_days*sa2q1e
gen value_female_hired = female_hired_days*sa2q1h
gen value_child_hired = child_hired_days*sa2q1k

*Generating average wage at the household level
preserve
	foreach i in male female child{
		gen wage_`i'_total = wage_`i'*`i'_hired_days
	}
	collapse (sum) wage_*_total *hired_days, by(hhid)		// summing total paid to all workers and total number of hired days to household level.
	foreach i in male female child{
		gen wage_`i'_hh = wage_`i'_total/`i'_hired_days	// generating an average household wage as total wage paid divided by total hired days (naira per day)
	}
	keep wage_*_hh hhid
	save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_hh_wages_mid.dta", replace
restore

*Geographic medians
foreach i in male female child{
	bys zone state lga sector: egen `i'_count_sect = count(wage_`i')
	bys zone state lga sector: egen `i'_price_sect = median(wage_`i')
	bys zone state lga: egen `i'_count_lga = count(wage_`i')
	bys zone state lga: egen `i'_price_lga = median(wage_`i')
	bys zone state: egen `i'_count_state = count(wage_`i')
	bys zone state: egen `i'_price_state = median(wage_`i')
	bys zone: egen `i'_count_zone = count(wage_`i')
	bys zone: egen `i'_price_zone = median(wage_`i')
	egen `i'_price_nat = median(wage_`i')
	
	*Generating wage
	gen `i'_wage_rate = `i'_price_sect if `i'_count_sect>=10
	replace `i'_wage_rate = `i'_price_lga if `i'_count_lga>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_price_state if `i'_count_state>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_price_zone if `i'_count_zone>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_price_nat if `i'_wage_rate==.
}

*To do family labor, we first need to merge in gender
preserve
	use "${raw_data}/sect1_harvestw3.dta", clear
	ren indiv pid
	isid hhid pid		// check
	gen male = s1q2==1
	gen age = s1q4
	keep hhid pid age male
	tempfile members
	save `members', replace
restore
*Starting with "member 1"
gen pid = sa2q1b_a1
merge m:1 hhid pid using `members', gen(fam_merge1) keep(1 3)
count if sa2q1b_a3!=0 & sa2q1b_a3!=. & fam_merge1==1			// 0
ren male male1
ren pid pid1 
ren age age1
*Now "member 2"
gen pid = sa2q1b_b1
merge m:1 hhid pid using `members', gen(fam_merge2) keep(1 3)
ren male male2
ren pid pid12
ren age age2
*Now "member 3"
gen pid = sa2q1b_c1
merge m:1 hhid pid using `members', gen(fam_merge3) keep(1 3)
ren male male3
ren pid pid13
ren age age3
*Now "member 4"
gen pid = sa2q1b_d1
merge m:1 hhid pid using `members', gen(fam_merge4) keep(1 3)
ren male male4
ren pid pid14
ren age age4

recode male1 male2 male3 male4 (.=1)			// NOTE: Assuming male if missing (replaces a lot of missings because there often isn't a male3 or male4 reported. However, this will not effect estimates since days worked will be missing for these.
gen male_fam_days1 = sa2q1b_a2*sa2q1b_a3 if male1 & age1>=15				// NOTE: assuming adult if age is missing
gen male_fam_days2 = sa2q1b_b2*sa2q1b_b3 if male2 & age2>=15
gen male_fam_days3 = sa2q1b_c2*sa2q1b_c3 if male3 & age3>=15
gen male_fam_days4 = sa2q1b_d2*sa2q1b_d3 if male4 & age4>=15
gen female_fam_days1 = sa2q1b_a2*sa2q1b_a3 if !male1 & age1>=15				// NOTE: assuming adult if age is missing
gen female_fam_days2 = sa2q1b_b2*sa2q1b_b3 if !male2 & age2>=15
gen female_fam_days3 = sa2q1b_c2*sa2q1b_c3 if !male3 & age3>=15
gen female_fam_days4 = sa2q1b_d2*sa2q1b_d3 if !male4 & age4>=15
gen child_fam_days1 = sa2q1b_a2*sa2q1b_a3 if age1<15
gen child_fam_days2 = sa2q1b_b2*sa2q1b_b3 if age2<15
gen child_fam_days3 = sa2q1b_c2*sa2q1b_c3 if age3<15
gen child_fam_days4 = sa2q1b_d2*sa2q1b_d3 if age4<15

egen total_male_fam_days = rowtotal(male_fam_days*)
egen total_female_fam_days = rowtotal(female_fam_days*)
egen total_child_fam_days = rowtotal(child_fam_days*)

*And here are the total costs
merge m:1 hhid using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_hh_wages_mid.dta", nogen keep(1 3)		// merging in household-level wage rates; all matched
*Aggregat wages first
gen value_male_nonhired = total_male_fam_days*male_wage_rate
gen value_female_nonhired = total_female_fam_days*female_wage_rate
gen value_child_nonhired = total_child_fam_days*child_wage_rate
*Now household wages when available
replace value_male_nonhired = total_male_fam_days*wage_male_hh if (wage_male_hh!=. & wage_male_hh!=0)
replace value_female_nonhired = total_female_fam_days*wage_female_hh if (wage_female_hh!=. & wage_female_hh!=0)
replace value_child_nonhired = total_child_fam_days*wage_child_hh if (wage_child_hh!=. & wage_child_hh!=0)

egen value_hired_mid_labor = rowtotal(value_male_hired value_female_hired value_child_hired)
egen value_fam_mid_labor = rowtotal(value_male_nonhired value_female_nonhired value_child_nonhired)

gen value_hired_mid_labor_male = value_hired_mid_labor if dm_gender==1
gen value_hired_mid_labor_female = value_hired_mid_labor if dm_gender==2
gen value_hired_mid_labor_mixed = value_hired_mid_labor if dm_gender==3
gen value_fam_mid_labor_male = value_fam_mid_labor if dm_gender==1
gen value_fam_mid_labor_female = value_fam_mid_labor if dm_gender==2
gen value_fam_mid_labor_mixed = value_fam_mid_labor if dm_gender==3

collapse (sum) value_hired* value_fam*, by(hhid)
save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_hh_cost_mid_labor.dta", replace





* Harvest labor
use "${raw_data}/secta2_harvestw3.dta", clear
*Merging in gender of plot manager
ren plotid plot_id
merge m:1 plot_id hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_plot_decision_makers", nogen keep(1 3) keepusing(dm_gender)

gen male_hired_days = sa2q3*sa2q2
gen female_hired_days = sa2q6*sa2q5
gen child_hired_days = sa2q9*sa2q8

gen wage_male = sa2q4/sa2q2
gen wage_female = sa2q7/sa2q5
gen wage_child = sa2q10/sa2q8
recode wage_* (0=.)

gen value_male_hired = male_hired_days*wage_male
gen value_female_hired = female_hired_days*wage_female
gen value_child_hired = child_hired_days*wage_child

*Generating average wage at the household level
preserve
	foreach i in male female child{
		gen wage_`i'_total = wage_`i'*`i'_hired_days
	}
	collapse (sum) wage_*_total *hired_days, by(hhid)		// summing total paid to all workers and total number of hired days to household level.
	foreach i in male female child{
		gen wage_`i'_hh = wage_`i'_total/`i'_hired_days	// generating an average household wage as total wage paid divided by total hired days (naira per day)
	}
	keep wage_*_hh hhid
	save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_hh_wages_harv.dta", replace
restore

*Geographic medians
foreach i in male female child{
	bys zone state lga sector: egen `i'_count_sect = count(wage_`i')
	bys zone state lga sector: egen `i'_price_sect = median(wage_`i')
	bys zone state lga: egen `i'_count_lga = count(wage_`i')
	bys zone state lga: egen `i'_price_lga = median(wage_`i')
	bys zone state: egen `i'_count_state = count(wage_`i')
	bys zone state: egen `i'_price_state = median(wage_`i')
	bys zone: egen `i'_count_zone = count(wage_`i')
	bys zone: egen `i'_price_zone = median(wage_`i')
	egen `i'_price_nat = median(wage_`i')
	
	*Generating wage
	gen `i'_wage_rate = `i'_price_sect if `i'_count_sect>=10
	replace `i'_wage_rate = `i'_price_lga if `i'_count_lga>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_price_state if `i'_count_state>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_price_zone if `i'_count_zone>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_price_nat if `i'_wage_rate==.
}

*To do family labor, we first need to merge in gender
preserve
	use "${raw_data}/sect1_harvestw3.dta", clear
	ren indiv pid
	isid hhid pid		// check
	gen male = s1q2==1
	gen age = s1q4
	keep hhid pid age male
	tempfile members
	save `members', replace
restore
*Starting with "member 1"
gen pid = sa2q1a1
merge m:1 hhid pid using `members', gen(fam_merge1) keep(1 3)
ren male male1
ren pid pid1 
ren age age1
*Now "member 2"
gen pid = sa2q1b1
merge m:1 hhid pid using `members', gen(fam_merge2) keep(1 3)
ren male male2
ren pid pid12
ren age age2
*Now "member 3"
gen pid = sa2q1c1
merge m:1 hhid pid using `members', gen(fam_merge3) keep(1 3)
ren male male3
ren pid pid13
ren age age3
*Now "member 4"
gen pid = sa2q1d1
merge m:1 hhid pid using `members', gen(fam_merge4) keep(1 3)
ren male male4
ren pid pid14
ren age age4
*Now "member 5"
gen pid = sa2q1e1
merge m:1 hhid pid using `members', gen(fam_merge5) keep(1 3)
ren male male5
ren pid pid15
ren age age5
*Now "member 6"
gen pid = sa2q1f1
merge m:1 hhid pid using `members', gen(fam_merge6) keep(1 3)
ren male male6
ren pid pid16
ren age age6
*Now "member 7"
gen pid = sa2q1g1
merge m:1 hhid pid using `members', gen(fam_merge7) keep(1 3)
ren male male7
ren pid pid17
ren age age7
*Now "member 8"
gen pid = sa2q1h1
merge m:1 hhid pid using `members', gen(fam_merge8) keep(1 3)
ren male male8
ren pid pid18
ren age age8

recode male1 male2 male3 male4 male5 male6 male7 male8 (.=1)			// NOTE: Assuming male if missing (replaces a lot of missings because there often isn't a male3 or male4 reported. However, this will not effect estimates since days worked will be missing for these.
gen male_fam_days1 = sa2q1a2*sa2q1a3 if male1 & age1>=15				// NOTE: assuming adult if age is missing
gen male_fam_days2 = sa2q1b2*sa2q1b3 if male2 & age2>=15
gen male_fam_days3 = sa2q1c2*sa2q1c3 if male3 & age3>=15
gen male_fam_days4 = sa2q1d2*sa2q1d3 if male4 & age4>=15
gen male_fam_days5 = sa2q1e2*sa2q1e3 if male5 & age5>=15
gen male_fam_days6 = sa2q1f2*sa2q1f3 if male6 & age6>=15
gen male_fam_days7 = sa2q1g2*sa2q1g3 if male7 & age7>=15
gen male_fam_days8 = sa2q1h2*sa2q1h3 if male8 & age8>=15
gen female_fam_days1 = sa2q1a2*sa2q1a3 if !male1 & age1>=15				// NOTE: assuming adult if age is missing
gen female_fam_days2 = sa2q1b2*sa2q1b3 if !male2 & age2>=15
gen female_fam_days3 = sa2q1c2*sa2q1c3 if !male3 & age3>=15
gen female_fam_days4 = sa2q1d2*sa2q1d3 if !male4 & age4>=15
gen female_fam_days5 = sa2q1e2*sa2q1e3 if !male5 & age5>=15
gen female_fam_days6 = sa2q1f2*sa2q1f3 if !male6 & age6>=15
gen female_fam_days7 = sa2q1g2*sa2q1g3 if !male7 & age7>=15
gen female_fam_days8 = sa2q1h2*sa2q1h3 if !male8 & age8>=15
gen child_fam_days1 = sa2q1a2*sa2q1a3 if age1<15
gen child_fam_days2 = sa2q1b2*sa2q1b3 if age2<15
gen child_fam_days3 = sa2q1c2*sa2q1c3 if age3<15
gen child_fam_days4 = sa2q1d2*sa2q1d3 if age4<15
gen child_fam_days5 = sa2q1e2*sa2q1e3 if age5<15
gen child_fam_days6 = sa2q1f2*sa2q1f3 if age6<15
gen child_fam_days7 = sa2q1g2*sa2q1g3 if age7<15
gen child_fam_days8 = sa2q1h2*sa2q1h3 if age8<15


egen total_male_fam_days = rowtotal(male_fam_days*)
egen total_female_fam_days = rowtotal(female_fam_days*)
egen total_child_fam_days = rowtotal(child_fam_days*)

*And here are the total costs
merge m:1 hhid using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_hh_wages_harv.dta", nogen keep(1 3)		// merging in household-level wage rates; all matched
*Aggregat wages first
gen value_male_nonhired = total_male_fam_days*male_wage_rate
gen value_female_nonhired = total_female_fam_days*female_wage_rate
gen value_child_nonhired = total_child_fam_days*child_wage_rate
*Now household wages when available
replace value_male_nonhired = total_male_fam_days*wage_male_hh if (wage_male_hh!=. & wage_male_hh!=0)
replace value_female_nonhired = total_female_fam_days*wage_female_hh if (wage_female_hh!=. & wage_female_hh!=0)
replace value_child_nonhired = total_child_fam_days*wage_child_hh if (wage_child_hh!=. & wage_child_hh!=0)

egen value_hired_harv_labor = rowtotal(value_male_hired value_female_hired value_child_hired)
egen value_fam_harv_labor = rowtotal(value_male_nonhired value_female_nonhired value_child_nonhired)

gen value_hired_harv_labor_male = value_hired_harv_labor if dm_gender==1
gen value_hired_harv_labor_female = value_hired_harv_labor if dm_gender==2
gen value_hired_harv_labor_mixed = value_hired_harv_labor if dm_gender==3
gen value_fam_harv_labor_male = value_fam_harv_labor if dm_gender==1
gen value_fam_harv_labor_female = value_fam_harv_labor if dm_gender==2
gen value_fam_harv_labor_mixed = value_fam_harv_labor if dm_gender==3

collapse (sum) value_hired* value_fam*, by(hhid)
save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_hh_cost_harv_labor.dta", replace




*Seeds
use "${raw_data}/sect11e_plantingw3.dta", clear
ren plotid plot_id
merge m:1 plot_id hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_plot_decision_makers", nogen keep(1 3) keepusing(dm_gender)

tab s11eq18b		// a LOT of non-traditional units (around 97 percent of observations)
*NOTE: Do we use the ag conversion factors, even though those are really for the cultivated crop?
*Problem is that we don't have enough observations for a lot of these units to do this by unit (and then crop...)

gen same_unit_own = s11eq6b==s11eq18b if s11eq6b!=0 & s11eq6b!=. & s11eq18b!=0 & s11eq18b!=.			// reported purchased and own seeds in same units?
tab same_unit_own			// 81 percent in same units

gen same_unit_free = s11eq10b==s11eq18b if s11eq10b!=0 & s11eq10b!=. & s11eq18b!=0 & s11eq18b!=.		// reported purchased and free seeds in same units?
tab same_unit_free			// 71 percents (though only 49 observations)

preserve
	use "${raw_data}/ag_conv_w3.dta", clear
	ren conv_NC_1 conv_zone_1
	ren conv_NE_2 conv_zone_2
	ren conv_NW_3 conv_zone_3
	ren conv_SE_4 conv_zone_4
	ren conv_SS_5 conv_zone_5
	ren conv_SW_6 conv_zone_6
	reshape long conv_zone_, i(crop_cd unit_cd) j(zone)
	ren conv_zone_ conversion
	tempfile conversion
	save `conversion', replace
restore
*Merging with zone and unit code
gen unit_cd = s11eq18b 
gen crop_cd = s11eq17
tab unit_cd			// 1,856 non-missing values
merge m:1 unit_cd crop_cd zone using `conversion', nogen keep(1 3)			// 1,417 matched
*NOTE: Doesn't look like we can really use non_purchased seeds here

*NOTE: For now, just taking purchased seeds
egen value_seeds_purchased = rowtotal(s11eq19 s11eq21 s11eq31 s11eq33)

gen value_seeds_purchased_male = value_seeds_purchased if dm_gender==1
gen value_seeds_purchased_female = value_seeds_purchased if dm_gender==2
gen value_seeds_purchased_mixed = value_seeds_purchased if dm_gender==3

collapse (sum) value_seeds_purchased*, by(hhid)
save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_hh_cost_seed.dta", replace



* Pesticides/Herbicides 
use "${raw_data}/secta11c2_harvestw3.dta", clear
ren plotid plot_id
merge m:1 plot_id hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_plot_decision_makers", nogen keep(1 3) keepusing(dm_gender)

egen value_pesticide = rowtotal(s11c2q4a s11c2q4b s11c2q5a s11c2q5b)
tab s11c2q6			// 23 people report getting free pesticide
tab s11c2q7b		// all LITERS

*Constructing pesticide prices
replace s11c2q2a = s11c2q2a/1000 if s11c2q2b==2			// g to kg
replace s11c2q2a = s11c2q2a/100 if s11c2q2b==4			// cl to l
recode s11c2q2b (2=1) (4=3) (5=3)						// NOTE: Assuming "5" is l (most common value)
gen pesticide_price = value_pesticide/s11c2q2a if s11c2q2b==3		// only doing for LITERS, since all free pesticide is reported in liters

*Constructing household values
preserve			// only doing for liters (since all free pesticide is reported in liters)
	keep if value_pesticide!=0 & value_pesticide!=. & s11c2q2b==3
	collapse (sum) value_pesticide s11c2q2a, by(hhid)
	gen pesticide_price_hh = value_pesticide/s11c2q2a
	save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_hh_pest_price.dta", replace
restore
merge m:1 hhid using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_hh_pest_price.dta", nogen

bys zone state lga sector: egen pest_count_sect = count(pesticide_price)
bys zone state lga sector: egen pest_price_sect = median(pesticide_price)
bys zone state lga: egen pest_count_lga = count(pesticide_price)
bys zone state lga: egen pest_price_lga = median(pesticide_price)
bys zone state: egen pest_count_state = count(pesticide_price)
bys zone state: egen pest_price_state = median(pesticide_price)
bys zone: egen pest_count_zone = count(pesticide_price)
bys zone: egen pest_price_zone = median(pesticide_price)
egen pest_price_nat = median(pesticide_price)

gen value_pesticide_free = s11c2q7a*pest_price_sect if pest_count_sect>=10
replace value_pesticide_free = s11c2q7a*pest_price_lga if pest_count_lga>=10 & value_pesticide_free==.
replace value_pesticide_free = s11c2q7a*pest_price_state if pest_count_state>=10 & value_pesticide_free==.
replace value_pesticide_free = s11c2q7a*pest_price_zone if pest_count_zone>=10 & value_pesticide_free==.
replace value_pesticide_free = s11c2q7a*pest_price_nat if value_pesticide_free==.
replace value_pesticide_free = s11c2q7a*pesticide_price_hh if pesticide_price_hh!=0 & pesticide_price_hh!=.			// replace with household value when not missing - 12 changes

*Now herbicide
egen value_herbicide = rowtotal(s11c2q13a s11c2q13b s11c2q14a s11c2q14b)
tab s11c2q11b		// amount purchased
tab s11c2q15		// 11 people report getting free herbicide
tab s11c2q16b		// g and l

*Constructing herbicide prices
replace s11c2q11a = s11c2q11a/1000 if s11c2q11b==2		// g to kg
replace s11c2q11a = s11c2q11a/100 if s11c2q11b==4		// cl to l
recode s11c2q11b (2=1) (4=3)		// recoding units, as well

gen herbicide_price = value_herbicide/s11c2q11a
gen value_herb_kg = value_herbicide if s11c2q11b==1
gen value_herb_l = value_herbicide if s11c2q11b==3
gen qty_herb_kg = s11c2q11a if s11c2q11b==1
gen qty_herb_l = s11c2q11a if s11c2q11b==3

*Constructing household values
preserve
	replace qty_herb_kg = . if value_herb_kg==. | value_herb_kg==0
	replace qty_herb_l = . if value_herb_l==. | value_herb_l==0
	collapse (sum) value_herb_* qty_herb_*, by(hhid)
	gen herb_price_hh_kg = value_herb_kg/qty_herb_kg	// naira per kg
	gen herb_price_hh_l = value_herb_l/qty_herb_l		// naira per l
	save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_hh_herb_price.dta", replace
restore
merge m:1 hhid using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_hh_herb_price.dta", nogen
drop value_herb_*

bys s11c2q11b zone state lga sector: egen herb_count_sect = count(herbicide_price)
bys s11c2q11b zone state lga sector: egen herb_price_sect = median(herbicide_price)
bys s11c2q11b zone state lga: egen herb_count_lga = count(herbicide_price)
bys s11c2q11b zone state lga: egen herb_price_lga = median(herbicide_price)
bys s11c2q11b zone state: egen herb_count_state = count(herbicide_price)
bys s11c2q11b zone state: egen herb_price_state = median(herbicide_price)
bys s11c2q11b zone: egen herb_count_zone = count(herbicide_price)
bys s11c2q11b zone: egen herb_price_zone = median(herbicide_price)
bys s11c2q11b: egen herb_price_nat = median(herbicide_price)

gen herb_price_kg = herb_price_sect if herb_count_sect>=10 & s11c2q11b==1
replace herb_price_kg = herb_price_lga if herb_count_lga>=10 & s11c2q11b==1 & herb_price_kg==.
replace herb_price_kg = herb_price_state if herb_count_state>=10 & s11c2q11b==1 & herb_price_kg==.
replace herb_price_kg = herb_price_zone if herb_count_zone>=10 & s11c2q11b==1 & herb_price_kg==.
replace herb_price_kg = herb_price_nat if s11c2q11b==1 & herb_price_kg==.
replace herb_price_kg = herb_price_hh_kg if herb_price_hh_kg!=. & herb_price_hh_kg!=0

gen herb_price_l = herb_price_sect if herb_count_sect>=10 & s11c2q11b==3
replace herb_price_l = herb_price_lga if herb_count_lga>=10 & s11c2q11b==3 & herb_price_l==.
replace herb_price_l = herb_price_state if herb_count_state>=10 & s11c2q11b==3 & herb_price_l==.
replace herb_price_l = herb_price_zone if herb_count_zone>=10 & s11c2q11b==3 & herb_price_l==.
replace herb_price_l = herb_price_nat if s11c2q11b==3 & herb_price_l==.
replace herb_price_l = herb_price_hh_l if herb_price_hh_l!=. & herb_price_hh_l!=0

gen value_herbicide_free = s11c2q7a*herb_price_kg if s11c2q16b==1			// for kg
replace value_herbicide_free = s11c2q7a*herb_price_l if s11c2q16b==3		// for l


tab s11c2q21		// number of days total
tab s11c2q23b		// payment units (e.g. days, acres, etc.)

*NOTE: Assuming 0.5 acres per day (https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4635562/ says a pair of draft cattle can plow 1 acre in about 2.2 days, at 4.3 hours per day)
gen paid_cash = s11c2q23a if s11c2q23b==6		// full planting period
replace paid_cash = s11c2q23a*s11c2q21*5 if s11c2q23b==1				// ASSUME FIVE HOURS PER DAY: payment times number of days times 5 if unit is payment per hour
replace paid_cash = s11c2q23a*s11c2q21 if s11c2q23b==2					// payment times number of days if unit is payment per day
replace paid_cash = s11c2q23a*s11c2q21*0.5 if s11c2q23b==4				// acres times 0.5 to put payment into days. then times days (e.g. if you hired for one day but paid "per acre" and they did half an acre, you pay half of the "per acre" price)
replace paid_cash = s11c2q23a*s11c2q21*(0.5/2.47105) if s11c2q23b==5	// hectares times 2.47105 for acres, then acres times 0.5 to put payment into days. then times days (e.g. if you hired for one day but paid "per hectare" and they did half an acre, you pay (0.5/2.47105)~0.202 of the "per hectare" price)
replace paid_cash = s11c2q23a*s11c2q21/8 if s11c2q23c=="8 Days"			// "Other" unit: payment divided by 8 times number of days if reported as "8 days"

gen paid_inkind = s11c2q24a if s11c2q24b==6		// full planting period
replace paid_inkind = s11c2q24a*s11c2q21*5 if s11c2q24b==1		// ASSUME FIVE HOURS PER DAY: payment times number of days times 5 if unit is payment per hour
replace paid_inkind = s11c2q24a*s11c2q21 if s11c2q24b==2		// payment times number of days if unit is payment per day
*No other units reported

*Animal rent and machine rent
egen value_animal_rent = rowtotal(paid_cash paid_inkind s11c2q25)		// cash paid plus in-kind paid plus amount spent on feed
egen value_machine_rent = rowtotal(s11c2q32 s11c2q33)

*Generating gender vars
foreach i in value_pesticide value_pesticide_free value_herbicide value_herbicide_free value_animal_rent value_machine_rent{
	gen `i'_male = `i' if dm_gender==1
	gen `i'_female = `i' if dm_gender==2
	gen `i'_mixed = `i' if dm_gender==3
}

collapse (sum) value_*, by(hhid)
save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_hh_cost_inputs.dta", replace




* Fert/Pest
use "${raw_data}/secta11d_harvestw3.dta", clear
ren plotid plot_id
merge m:1 plot_id hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_plot_decision_makers", nogen keep(1 3) keepusing(dm_gender)

tab s11dq2		// 140 observations said fertilizer was left over
tab s11dq4b		// almost all in kg

*First commercial source:
tab s11dq16b s11dq28b			// everyone that purchased from two sources reported in the SAME UNIT
tab s11dq16b					// most are in kilos, but some im grams and liters
egen commercial_fert_total = rowtotal(s11dq16a s11dq28a)			// total quantity
egen commercial_fert_purchased = rowtotal(s11dq19 s11dq29)			// total PAID

replace commercial_fert_total = commercial_fert_total/1000 if s11dq16b==2			// grams to kilograms
recode s11dq16b (2=1)				// recoding units, as well

gen fert_price = commercial_fert_purchased/commercial_fert_total
gen fert_price_kg = fert_price if s11dq16b==1
gen fert_price_l = fert_price if s11dq16b==3			// doing these two in order to construct prices separately for kg and l (though there are not many l prices; might be better to assume kg=l, as I do for other sections?)

*Getting a household average price (summing across plots)
preserve
	gen fert_purchased_kg = commercial_fert_total if s11dq16b==1		// total kg purchased
	gen fert_purchased_l = commercial_fert_total if s11dq16b==3			// total l purchased
	gen fert_paid_kg = commercial_fert_purchased if s11dq16b==1			// total paid for kg
	gen fert_paid_l = commercial_fert_purchased if s11dq16b==3			// total paid for l
	collapse (sum) fert_purchased_* fert_paid_*, by(hhid)
	gen fert_price_hh = fert_paid_kg/fert_purchased_kg					// total paid per unit
	replace fert_price_hh = fert_paid_l/fert_purchased_l if fert_price_hh==.	// can do at household level without worrying about units because they report free and leftover fertilizer in the same units as purchased (except one single observation; for that one assume kg price = l price)
	save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_fert_price_hh.dta", replace
restore
*Merging prices back in immediately
merge m:1 hhid using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_fert_price_hh.dta", nogen assert(3)		// all matched

*Geographic price medians
foreach i in kg l{
	bys zone state lga sector: egen `i'_fert_count_sect = count(fert_price_`i')
	bys zone state lga sector: egen `i'_fert_price_sect = median(fert_price_`i')
	bys zone state lga: egen `i'_fert_count_lga = count(fert_price_`i')
	bys zone state lga: egen `i'_fert_price_lga = median(fert_price_`i')
	bys zone state: egen `i'_fert_count_state = count(fert_price_`i')
	bys zone state: egen `i'_fert_price_state = median(fert_price_`i')
	bys zone: egen `i'_fert_count_zone = count(fert_price_`i')
	bys zone: egen `i'_fert_price_zone = median(fert_price_`i')
	egen `i'_fert_price_nat = median(fert_price_`i')
	
	gen `i'_price = `i'_fert_price_sect if `i'_fert_count_sect>=10
	replace `i'_price = `i'_fert_price_lga if `i'_fert_count_lga>=10 & `i'_price==.
	replace `i'_price = `i'_fert_price_state if `i'_fert_count_state>=10 & `i'_price==.
	replace `i'_price = `i'_fert_price_zone if `i'_fert_count_zone>=10 & `i'_price==.
	replace `i'_price = `i'_fert_price_nat if `i'_price==.
}

*"Left over" fertilizer
gen left_fert = s11dq4a
replace left_fert = s11dq4a/1000 if s11dq4b==2			// g to kg

gen value_fert_leftover = left_fert*kg_price if s11dq4b==1 | s11dq4b==2		// kg (and g, for which we fixed the quantity two lines above)
replace value_fert_leftover = left_fert*l_price if s11dq4b==3				// l
replace value_fert_leftover = left_fert*fert_price_hh if fert_price_hh!=0 & fert_price_hh!=.		// replacing with household value when available

*"Free" fertilizer
gen free_fert = sect11dq8a
replace free_fert = sect11dq8a/1000 if sect11dq8b==2			// g to kg

gen value_fert_free = free_fert*kg_price		// kg (and g, for which we fixed the quantity two lines above)
replace value_fert_free = free_fert*fert_price_hh if fert_price_hh!=0 & fert_price_hh!=.			// replacing with household value when available

egen value_inorg_purchased = rowtotal(s11dq5d commercial_fert_purchased s11dq10 s11dq17 s11dq31)		// includes all payments (including transport for free fertilizer)
egen value_inorg_notpurchased = rowtotal(value_fert_left value_fert_free)

*Total inorganic fertilizer applied
*Commercial fertilizer
*NOTE: Treating 1 L = 1 KG
gen fert1_kg = s11dq16a		// all l and kg
gen fert2_kg = s11dq28a if s11dq28b==1 | s11dq28b==3		// l and kg
replace fert2_kg = s11dq28a/1000 if s11dq28b==2			// g
egen commercial_fert_kg = rowtotal(fert1_kg fert2_kg)

*"E-wallet subsidy" fertilizer
*All are already in kg
tab s11dq5c2
gen subsidy_fert = s11dq5c1				// all are kg

*"Left over" fertilizer
*NOTE: Treating 1 L = 1 KG
gen left_fert_kg = s11dq4a if s11dq4b==1 | s11dq4b==3	// kg and l
replace left_fert_kg = s11dq4a/1000 if s11dq4b==2		// g

*"Free" fertilizer
*NOTE: No liters here
gen free_fert_kg = sect11dq8a if sect11dq8b==1
replace free_fert_kg = sect11dq8a/1000 if sect11dq8b==2		// g

*Now getting total - four types of inorganic (commercial, leftover, free, and subsidy)
egen fert_inorg_kg = rowtotal(commercial_fert_kg left_fert_kg free_fert_kg subsidy_fert)
gen fert_inorg_kg_male = fert_inorg_kg if dm_gender==1
gen fert_inorg_kg_female = fert_inorg_kg if dm_gender==2
gen fert_inorg_kg_mixed = fert_inorg_kg if dm_gender==3

*Organic Fertilizer
tab s11dq37b			// 1255 kg, 28 g
replace s11dq37a = s11dq37a/1000 if s11dq37b==2			// to kg
recode s11dq37b (2=1)			// to kg
gen fert_org_kg = s11dq37a

*Purchased organic fert
tab s11dq38b			// 234 kg, 5 g
replace s11dq38a = s11dq38a/1000 if s11dq38b==2			// to kg
recode s11dq38b (2=1)			// to kg

gen value_org_purchased = s11dq39
gen org_price_kg = value_org_purchased/s11dq38a

*Want to use household prices where available
preserve
	replace s11dq38a = . if value_org_purchased==. | value_org_purchased==0
	collapse (sum) value_org_purchased s11dq38a, by(hhid)
	gen org_price_hh = value_o/s11dq38a
	keep hhid org_price_hh
	save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_org_fert_price_hh.dta", replace
restore
*Immediately merging back in
merge m:1 hhid using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_org_fert_price_hh.dta", nogen assert(3)

bys zone state lga sector: egen org_count_sect = count(org_price_kg)
bys zone state lga sector: egen org_price_sect = median(org_price_kg)
bys zone state lga: egen org_count_lga = count(org_price_kg)
bys zone state lga: egen org_price_lga = median(org_price_kg)
bys zone state: egen org_count_state = count(org_price_kg)
bys zone state: egen org_price_state = median(org_price_kg)
bys zone: egen org_count_zone = count(org_price_kg)
bys zone: egen org_price_zone = median(org_price_kg)
egen org_price_nat = median(org_price_kg)

gen org_price = org_price_sect if org_count_sect>=10
replace org_price = org_price_lga if org_count_lga>=10 & org_price==.
replace org_price = org_price_state if org_count_state>=10 & org_price==.
replace org_price = org_price_zone if org_count_zone>=10 & org_price==.
replace org_price = org_price_nat if org_price==.

recode s11dq37a s11dq38a (.=0)
gen org_notpurchased = s11dq37a-s11dq38a
replace org_notpurchased = 0 if org_notpurchased<0			// not allowing negatives

gen value_org_notpurchased = org_price*org_notpurchased
replace value_org_notpurchased = org_price_hh*org_notpurchased if org_price_hh!=0 & org_price_hh!=.			// replace with household value when available
recode s11dq41 (.=0)
replace value_org_purchased = value_org_purchased + s11dq41			// including transport costs in purchased value

preserve
	recode fert_inorg_kg fert_org_kg (.=0)
	collapse (sum) fert_inorg_kg* fert_org_kg, by(hhid)
	save "$created_data/Nigeria_GHSP_LSMS_ISA_W3_hh_fert.dta", replace
restore

foreach i in value_inorg_purchased value_inorg_notpurchased value_org_purchased value_org_notpurchased{
	gen `i'_male = `i' if dm_gender==1
	gen `i'_female = `i' if dm_gender==2
	gen `i'_mixed = `i' if dm_gender==3
}

collapse (sum) value_inorg_purchased* value_inorg_notpurchased* value_org_purchased* value_org_notpurchased*, by(hhid)
save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_hh_cost_fert.dta", replace


use "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_hh_cost_land.dta", clear
merge 1:1 hhid using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_hh_rental_rate.dta", nogen
merge 1:1 hhid using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_hh_cost_prep_labor.dta", nogen keep(1 3)
merge 1:1 hhid using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_hh_cost_mid_labor.dta", nogen keep(1 3)
merge 1:1 hhid using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_hh_cost_harv_labor.dta", nogen keep(1 3)		// 19 not matched from master
merge 1:1 hhid using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_hh_cost_fert.dta", nogen keep(1 3)				// 19
merge 1:1 hhid using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_hh_cost_inputs.dta", nogen keep(1 3)			// 19

merge 1:1 hhid using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_male_head.dta", nogen keep(1 3)

gen exchange_rate=199 //pulling from Ayala's income files
recode ha_planted* (0=.)

*Winsorizing area before constructing
*winsor2 ha_planted*, cuts(1 99) replace

*Adding winsor code (COMMENT OUT LINE ABOVE IF USING THIS)
foreach x of varlist ha_planted*{
	_pctile `x', p(1 99)
	replace `x' = r(r1) if `x' < r(r1)
	replace `x' = r(r2) if (`x' > r(r2) & `x' !=.)
}


egen costs_total_hh = rowtotal(value_owned_land value_rented_land value_fam_labor value_hired_labor value_fam_mid_labor ///
value_hired_mid_labor value_fam_harv_labor value_hired_harv_labor value_inorg_notpurchased value_inorg_purchased value_org_notpurchased ///
value_org_purchased value_herbicide_free value_herbicide value_pesticide_free value_pesticide value_animal_rent value_machine_rent)
replace costs_total_hh = costs_total_hh/ha_planted
*replace costs_total_hh = costs_total_hh/exchange_rate

*Creating total costs by gender (excludes seeds)
foreach i in male female mixed{
	egen costs_total_hh_`i' = rowtotal(value_owned_land_`i' value_rented_land_`i' value_fam_labor_`i' value_hired_labor_`i' value_fam_mid_labor_`i' ///
	value_hired_mid_labor_`i' value_fam_harv_labor_`i' value_hired_harv_labor_`i' value_inorg_notpurchased_`i' value_inorg_purchased_`i' value_org_notpurchased_`i' ///
	value_org_purchased_`i' value_herbicide_free_`i' value_herbicide_`i' value_pesticide_free_`i' value_pesticide_`i' value_animal_rent_`i' value_machine_rent_`i')
	replace costs_total_hh_`i' = (costs_total_hh_`i'/ha_planted_`i') /*exchange_rate*/
}
*Recoding zeros as missings
recode costs_total_hh* (0=.)		// should be no zeros for implicit costs


egen costs_total_explicit_hh = rowtotal(value_rented_land value_hired_labor value_hired_mid_labor value_hired_harv_labor value_inorg_purchased value_org_purchased ///
value_herbicide value_pesticide value_animal_rent value_machine_rent)
replace costs_total_explicit_hh = costs_total_explicit_hh/ha_planted
*replace costs_total_explicit_hh = costs_total_explicit_hh/exchange_rate
sum costs_total_explicit_hh, d		
count if costs_total_explicit_hh==0			// 233 zeros (zeros are technically possible here)

*Creating explicit costs by gender (excludes seeds)
foreach i in male female mixed{
	egen costs_total_explicit_hh_`i' = rowtotal(value_rented_land_`i' value_hired_labor_`i' value_hired_mid_labor_`i' value_hired_harv_labor_`i' value_inorg_purchased_`i' ///
	value_org_purchased_`i' value_herbicide_`i' value_pesticide_`i' value_animal_rent_`i' value_machine_rent_`i')
	replace costs_total_explicit_hh_`i' = (costs_total_explicit_hh_`i'/ha_planted_`i') /*exchange_rate*/
}

lab var costs_total_hh "Explicit + implicit costs of crop production (household level) per ha (local currency)"
lab var costs_total_hh_male "Explicit + implicit costs of crop production (male-managed crops) per ha (local currency)"
lab var costs_total_hh_female "Explicit + implicit costs of crop production (female-managed crops) per ha (local currency)"
lab var costs_total_hh_mixed "Explicit + implicit costs of crop production (mixed-managed crops) per ha (local currency)"
lab var costs_total_explicit_hh "Explicit costs of crop production (household level) per ha (local currency)"
lab var costs_total_explicit_hh_male "Explicit costs of crop production (male-managed crops) per ha (local currency)"
lab var costs_total_explicit_hh_female "Explicit costs of crop production (female-managed crops) per ha (local currency)"
lab var costs_total_explicit_hh_mixed "Explicit costs of crop production (mixed-managed crops) per ha (local currency)"
save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_cropcosts_perha.dta", replace




**********************************
* RATE OF FERTILIZER APPLICATION *
**********************************

use "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_hh_fert.dta", clear
append using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_hh_cost_land.dta" 				// since there is only a single season, can use this file (i.e. didn't need to sum across separate seasons)
collapse (sum) ha_planted* fert_*, by(hhid)

merge 1:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_hhsize.dta", nogen keep(1 3)
recode ha_planted* (0=.)

gen inorg_fert_rate = fert_inorg_kg/ha_planted
foreach i in male female mixed{
	gen inorg_fert_rate_`i' = fert_inorg_kg_`i'/ha_planted_`i'
}

lab var fert_inorg_kg "Inorganic fertilizer (kgs) for (household)"
lab var fert_inorg_kg_male "Inorganic fertilizer (kgs) for (male-managed plots)"
lab var fert_inorg_kg_female "Inorganic fertilizer (kgs) for (female-managed plots)"
lab var fert_inorg_kg_mixed "Inorganic fertilizer (kgs) for (mixed-managed plots)"
lab var inorg_fert_rate "Rate of fertilizer application (kgs/ha) (household level)"
lab var inorg_fert_rate_male "Rate of fertilizer application (kgs/ha) (male-managed crops)"
lab var inorg_fert_rate_female "Rate of fertilizer application (kgs/ha) (female-managed crops)"
lab var inorg_fert_rate_mixed "Rate of fertilizer application (kgs/ha) (mixed-managed crops)"
save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_fertilizer_application.dta", replace




************
*WOMEN'S DIET QUALITY
************
*Women's diet quality: proportion of women consuming nutrient-rich foods (%)
*Information not available


************
*HOUSEHOLD'S DIET DIVERSITY SCORE
************
* since the diet variable is available in botn PP and PH datasets, we first append the two together
use "${raw_data}\sect7b_plantingw3.dta" , clear
keep zone state lga sector ea hhid item_cd item_desc s7bq1
gen survey="PP"
preserve
use "${raw_data}\sect10b_harvestw3.dta" , clear
keep zone state lga sector ea hhid item_cd item_desc s10bq1
ren  s10bq1  s7bq1 // rename the variable indicating household consumption of food items to harminize accross data set
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

/*
There are no established cut-off points in terms of number of food groups to indicate
adequate or inadequate dietary diversity for the HDDS. 
Can use either cut-off or 6 (=12/2) or cut-off=mean(socore) 
*/
ren adiet_yes number_foodgroup 
local cut_off1=6
sum number_foodgroup  if survey=="PP"
local cut_off2PP=round(r(mean))
sum number_foodgroup  if survey=="PH"
local cut_off2PH=round(r(mean))
gen household_diet_cut_off1PP=(number_foodgroup>=`cut_off1')   if survey=="PP"
gen household_diet_cut_off1PH=(number_foodgroup>=`cut_off1')   if survey=="PH"
gen household_diet_cut_off2PP=(number_foodgroup>=`cut_off2PP') if survey=="PP"
gen household_diet_cut_off2PH=(number_foodgroup>=`cut_off2PH') if survey=="PH"
gen number_foodgroupPP=number_foodgroup if survey=="PP"
gen number_foodgroupPH=number_foodgroup if survey=="PH"
collapse (firstnm) *PP *PH, by(hhid)
lab var household_diet_cut_off1PP "1= houseold consumed at least `cut_off1' of the 12 food groups last week - PP"
lab var household_diet_cut_off1PP "1= houseold consumed at least `cut_off1' of the 12 food groups last week - PH" 
lab var household_diet_cut_off2PP "1= houseold consumed at least `cut_off2PP' of the 12 food groups last week - PP"
lab var household_diet_cut_off2PP "1= houseold consumed at least `cut_off2PP' of the 12 food groups last week - PH"  
label var number_foodgroupPP "Number of food groups individual consumed last week HDDS - PP"
label var number_foodgroupPH "Number of food groups individual consumed last week HDDS - PH"
save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_household_diet.dta", replace


************
*WOMEN'S CONTROL OVER INCOME
************
*Code as 1 if a woman is listed as one of the decision-makers for at least 1 income-related area; 
*can report on % of women who make decisions, taking total number of women HH members as denominator
*Inmost cases, NGA LSMS 3 lsit the first TWO decision makers.
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
use "${raw_data}\secta3i_harvestw3", clear
append using "${raw_data}\secta3ii_harvestw3"
append using "${raw_data}\secta8_harvestw3"
append using "${raw_data}\sect11k_plantingw3.dta"
append using "${raw_data}\sect11i_plantingw3.dta"
append using "${raw_data}\secta8_harvestw3.dta"
append using "${raw_data}\sect11k_plantingw3.dta"
append using "${raw_data}\sect9_harvestw3.dta"
append using "${raw_data}\sect3_plantingw3.dta"
append using "${raw_data}\sect3_harvestw3.dta"
append using "${raw_data}\sect13_harvestw3.dta"
gen type_decision="" 
gen controller_income1=.
gen controller_income2=.
* control of harvest from annual crops
replace type_decision="control_annualharvest" if  !inlist( sa3iq6e1, .,0,99, 98) |  !inlist( sa3iq6e2, .,0,99, 98) 
replace controller_income1=sa3iq6e1 if !inlist(sa3iq6e1, .,0,99, 98)  
replace controller_income2=sa3iq6e2 if !inlist(sa3iq6e2, .,0,99, 98)
* control_annualsales
replace type_decision="control_annualsales" if  !inlist( sa3iiq9a, .,0,99, 98) |  !inlist( sa3iiq9b, .,0,99, 98) 
replace controller_income1=sa3iiq9a if !inlist( sa3iiq9a, .,0,99, 98)  
replace controller_income2=sa3iiq9b if !inlist( sa3iiq9b, .,0,99, 98)
* append who controls earning from sale to customer 2
preserve
replace type_decision="control_annualsales" if  !inlist( sa3iiq23a, .,0,99, 98) |  !inlist( sa3iiq23b, .,0,99, 98) 
replace controller_income1=sa3iiq23a if !inlist( sa3iiq23a, .,0,99, 98)  
replace controller_income2=sa3iiq23b if !inlist( sa3iiq23b, .,0,99, 98)
keep if !inlist(sa3iiq23a, .,0,99, 98) |  !inlist(sa3iiq23b, .,0,99, 98)
keep hhid type_decision controller_income1 controller_income2
tempfile control_annualsales2
save `control_annualsales2'
restore
append using `control_annualsales2'  
* control_processedsales (both in PP and PH)
replace type_decision="control_processedsales" if ( !inlist( sa8q8a, .,0,99, 98) |  !inlist( sa8q8b, .,0,99, 98))  &  inlist(byprod_cd, 6,7,8)
replace controller_income1=sa8q8a if !inlist( sa8q8a, .,0,99, 98)   &  inlist(byprod_cd, 6,7,8)
replace controller_income2=sa8q8b if !inlist( sa8q8b, .,0,99, 98) &  inlist(byprod_cd, 6,7,8)
* append who controle earning from sales of processed crops PHs 
preserve
replace type_decision="control_processedsales" if ( !inlist( s11kq7a, .,0,99, 98) |  !inlist( s11kq7b, .,0,99, 98) )  &  inlist(byprod_cd, 6,7,8)
replace controller_income1=s11kq7a if !inlist( s11kq7a, .,0,99, 98)   &  inlist(byprod_cd, 6,7,8)
replace controller_income2=s11kq7b if !inlist( s11kq7b, .,0,99, 98)  &  inlist(byprod_cd, 6,7,8)
keep if (!inlist(s11kq7a, .,0,99, 98) |  !inlist(s11kq7b, .,0,99, 98)) &  inlist(byprod_cd, 6,7,8)
keep hhid type_decision controller_income1 controller_income2
tempfile control_processedsales2
save `control_processedsales2'
restore
append using `control_processedsales2' 
* control_livestocksales
replace type_decision="control_livestocksales" if  !inlist( s11iq4a, .,0,99, 98) |  !inlist( s11iq4b, .,0,99, 98) 
replace controller_income1=s11iq4a if !inlist(s11iq4a, .,0,99, 98)  
replace controller_income2=s11iq4b if !inlist(s11iq4b, .,0,99, 98)
* control_otherlivestock_sales (both in PP and PH)
replace type_decision="control_otherlivestock_sales" if ( !inlist( sa8q8a, .,0,99, 98) |  !inlist( sa8q8b, .,0,99, 98))  &  !inlist(byprod_cd, 6,7,8)
replace controller_income1=sa8q8a if !inlist( sa8q8a, .,0,99, 98)   &  !inlist(byprod_cd, 6,7,8)
replace controller_income2=sa8q8b if !inlist( sa8q8b, .,0,99, 98) &  !inlist(byprod_cd, 6,7,8)
* append who controle earning from sales of processed crops PHs 
preserve
replace type_decision="control_otherlivestock_sales" if ( !inlist( s11kq7a, .,0,99, 98) |  !inlist( s11kq7b, .,0,99, 98) )  &  !inlist(byprod_cd, 6,7,8)
replace controller_income1=s11kq7a if !inlist( s11kq7a, .,0,99, 98)   &  !inlist(byprod_cd, 6,7,8)
replace controller_income2=s11kq7b if !inlist( s11kq7b, .,0,99, 98)  &  !inlist(byprod_cd, 6,7,8)
keep if (!inlist(s11kq7a, .,0,99, 98) |  !inlist(s11kq7b, .,0,99, 98)) &  !inlist(byprod_cd, 6,7,8)
keep hhid type_decision controller_income1 controller_income2
tempfile control_otherlivestock_sales2
save `control_otherlivestock_sales2'
restore
append using `control_otherlivestock_sales2' 
* control_businessincome
replace type_decision="control_businessincome" if  !inlist( s9q5a1, .,0,99, 98) |  !inlist( s9q5a2, .,0,99, 98) 
replace controller_income1=s9q5a1 if !inlist( s9q5a1, .,0,99, 98)  
replace controller_income2=s9q5a2 if !inlist( s9q5a2, .,0,99, 98)
* append who controle earning 
preserve
replace type_decision="control_businessincome" if  !inlist( s9q5b1, .,0,99, 98) |  !inlist( s9q5b2, .,0,99, 98) 
replace controller_income1=s9q5b1 if !inlist( s9q5b1, .,0,99, 98)  
replace controller_income2=s9q5b2 if !inlist( s9q5b2, .,0,99, 98)
keep if !inlist(s9q5b1, .,0,99, 98) |  !inlist(s9q5b2, .,0,99, 98)
keep hhid type_decision controller_income1 controller_income2
tempfile control_businessincome2
save `control_businessincome2'
restore
append using `control_businessincome2' 
* control_wageincome
replace type_decision="control_wageincome" if  !inlist( s3q22a, .,0,99, 98) |  !inlist( s3q22b, .,0,99, 98) 
replace controller_income1=s3q22a if !inlist( s3q22a, .,0,99, 98)  
replace controller_income2=s3q22b if !inlist( s3q22b, .,0,99, 98)
* append who controle earning 
preserve
replace type_decision="control_wageincome" if  !inlist( s3q35a, .,0,99, 98) |  !inlist( s3q35b, .,0,99, 98) 
replace controller_income1=s3q35a if !inlist( s3q35a, .,0,99, 98)  
replace controller_income2=s3q35b if !inlist( s3q35b, .,0,99, 98)
keep if !inlist(s3q35a, .,0,99, 98) |  !inlist(s3q35b, .,0,99, 98)
keep hhid type_decision controller_income1 controller_income2
tempfile control_wageincome2
save `control_wageincome2'
restore
append using `control_wageincome2'
* control_otherincome
replace type_decision="control_otherincome" if  !inlist( s13q2b1, .,0,99, 98) |  !inlist( s13q2b2, .,0,99, 98) 
replace controller_income1=s13q2b1 if !inlist( s13q2b1, .,0,99, 98)  
replace controller_income2=s13q2b2 if !inlist( s13q2b2, .,0,99, 98)
* append who controle other income 2 
preserve
replace type_decision="control_otherincome" if  !inlist( s13q5b1, .,0,99, 98) |  !inlist( s13q5b2, .,0,99, 98) 
replace controller_income1=s13q5b1 if !inlist( s13q5b1, .,0,99, 98)  
replace controller_income2=s13q5b2 if !inlist( s13q5b2, .,0,99, 98)
keep if !inlist(s13q5b1, .,0,99, 98) |  !inlist(s13q5b2, .,0,99, 98)
keep hhid type_decision controller_income1 controller_income2
tempfile control_otherincome2
save `control_otherincome2'
restore
* append who controle other income 3 
preserve
replace type_decision="control_otherincome" if  !inlist( s13q8b1, .,0,99, 98) |  !inlist( s13q8b2, .,0,99, 98) 
replace controller_income1=s13q8b1 if !inlist( s13q8b1, .,0,99, 98)  
replace controller_income2=s13q8b2 if !inlist( s13q8b2, .,0,99, 98)
keep if !inlist(s13q8b1, .,0,99, 98) |  !inlist(s13q8b2, .,0,99, 98)
keep hhid type_decision controller_income1 controller_income2
tempfile control_otherincome3
save `control_otherincome3'
restore
append using `control_otherincome2'
append using `control_otherincome3'

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
* Using gender from planting and harvesting sections
*merge 1:1 hhid indiv  using  "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_person_ids.dta", nogen keep (2 3) //Using gender from planting and harvesting sections
*  5  member ID in decision files not in member list
merge 1:1 hhid indiv using "${raw_data}/sect1_plantingw3.dta", nogen
merge 1:1 hhid indiv using "${raw_data}/sect1_harvestw3.dta"
gen female2 = s1q2 ==2
recode control_* (.=0)

lab var control_cropincome "1=invidual has control over crop income"
lab var control_livestockincome "1=invidual has control over livestock income"
lab var control_farmincome "1=invidual has control over farm (crop or livestock) income"
lab var control_businessincome "1=invidual has control over business income"
lab var control_nonfarmincome "1=invidual has control over non-farm (business or remittances) income"
lab var control_all_income "1=invidual has control over at least one type of income"
save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_control_income.dta", replace



************
*WOMEN'S PARTICIPATION IN AGRICULTURAL DECISION MAKING
************
* Code as 1 if a woman is listed as one of the decision-makers for at least 2 plots, crops, or livestock activities; 
* can report on % of women who make decisions, taking total number of women HH members as denominator
* In most cases, NGA LSMS 3 lists the first TWO decision makers.
* Indicator may be biased downward if some women would participate in decisions but are not listed among the first two
* first append all files related to agricultural activities with income in who participate in the decision making
* planting_input	
use "${raw_data}\sect11a1_plantingw3.dta", clear
append using "${raw_data}\sect11b1_plantingw3.dta" 
append using "${raw_data}\sect11e_plantingw3.dta" 
append using "${raw_data}\secta1_harvestw3.dta" 
append using "${raw_data}\secta11d_harvestw3.dta" 
append using "${raw_data}\secta3i_harvestw3.dta"
append using "${raw_data}\secta3ii_harvestw3.dta"
append using "${raw_data}\secta8_harvestw3.dta"
append using "${raw_data}\sect11k_plantingw3.dta"
append using "${raw_data}\sect11i_plantingw3.dta"
append using "${raw_data}\secta8_harvestw3.dta"

/*
*Using gender reported in planting and harvesting
merge m:m hhid indiv using "${raw_data}/sect1_plantingw3.dta", nogen 
merge m:m hhid using "${raw_data}/sect1_harvestw3.dta", nogen
*/


gen type_decision="" 
gen decision_maker1=.
gen decision_maker2=.
* planting_input - manage plot
replace type_decision="planting_input" if  !inlist( s11aq6a, .,0,99, 98) |  !inlist( s11aq6b, .,0,99, 98)  
replace decision_maker1=s11aq6a if !inlist( s11aq6a, .,0,99, 98)  
replace decision_maker2=s11aq6b if !inlist( s11aq6b, .,0,99, 98)
* append who make decision about plot
preserve
replace type_decision="planting_input" if  !inlist( s11b1q12a, .,0,99, 98) |  !inlist( s11b1q12b, .,0,99, 98) |  !inlist( s11b1q12c, .,0,99, 98) 
replace decision_maker1=s11b1q12a if !inlist( s11b1q12a, .,0,99, 98)  
replace decision_maker2=s11b1q12b if !inlist( s11b1q12b, .,0,99, 98)
replace decision_maker2=s11b1q12c if !inlist( s11b1q12c, .,0,99, 98)
keep if  !inlist( s11b1q12a, .,0,99, 98) |  !inlist( s11b1q12b, .,0,99, 98) |  !inlist( s11b1q12c, .,0,99, 98) 
keep hhid type_decision decision_maker*
tempfile planting_input2
save `planting_input2'
restore
append using `planting_input2'  
* append who make decision about plot (others2)
preserve
replace type_decision="planting_input" if  !inlist( s11b1q16b1, .,0,99, 98) |  !inlist( s11b1q16b2, .,0,99, 98) 
replace decision_maker1=s11b1q16b1 if !inlist( s11b1q16b1, .,0,99, 98)  
replace decision_maker2=s11b1q16b2 if !inlist( s11b1q16b2, .,0,99, 98)
keep if  !inlist( s11b1q16b1, .,0,99, 98) |  !inlist( s11b1q16b2, .,0,99, 98)  
keep hhid type_decision decision_maker*
tempfile planting_input3
save `planting_input3'
restore
append using `planting_input3'  
* append who make decision about input (chose seed)
preserve
replace type_decision="planting_input" if  !inlist( s11eq15a, .,0,99, 98) |  !inlist( s11eq15b, .,0,99, 98) 
replace decision_maker1=s11eq15a if !inlist( s11eq15a, .,0,99, 98)  
replace decision_maker2=s11eq15b if !inlist( s11eq15b, .,0,99, 98)
keep if  !inlist( s11eq15a, .,0,99, 98) |  !inlist( s11eq15b, .,0,99, 98)  
keep hhid type_decision decision_maker*
tempfile planting_input4
save `planting_input4'
restore
append using `planting_input4'  
* append who make decision about input (paid seed)
preserve
replace type_decision="planting_input" if  !inlist( s11eq27a, .,0,99, 98) |  !inlist( s11eq27b, .,0,99, 98) 
replace decision_maker1=s11eq27a if !inlist( s11eq27a, .,0,99, 98)  
replace decision_maker2=s11eq27b if !inlist( s11eq27b, .,0,99, 98)
keep if  !inlist( s11eq27a, .,0,99, 98) |  !inlist( s11eq27b, .,0,99, 98)  
keep hhid type_decision decision_maker*
tempfile planting_input5
save `planting_input5'
restore
append using `planting_input5'   
* append who make decision about input (manage plot)
preserve
replace type_decision="planting_input" if  !inlist( sa1q11, .,0,99, 98) |  !inlist( sa1q11b, .,0,99, 98) 
replace decision_maker1=sa1q11 if !inlist( sa1q11, .,0,99, 98)  
replace decision_maker2=sa1q11b if !inlist( sa1q11b, .,0,99, 98)
keep if  !inlist( sa1q11, .,0,99, 98) |  !inlist( sa1q11b, .,0,99, 98)  
keep hhid type_decision decision_maker*
tempfile planting_input6
save `planting_input6'
restore
append using `planting_input6'
* append who make decision about (owner plot)  
preserve
replace type_decision="planting_input" if  !inlist( sa1q14, .,0,99, 98) |  !inlist( sa1q14b, .,0,99, 98) 
replace decision_maker1=sa1q14 if !inlist( sa1q14, .,0,99, 98)  
replace decision_maker2=sa1q14b if !inlist( sa1q14b, .,0,99, 98)
keep if  !inlist( sa1q14, .,0,99, 98) |  !inlist( sa1q14b, .,0,99, 98)  
keep hhid type_decision decision_maker*
tempfile planting_input7
save `planting_input7'
restore
append using `planting_input7'
* append who make decision about plot (decsision maker)  
preserve
replace type_decision="planting_input" if  !inlist( sa1q22a, .,0,99, 98) |  !inlist( sa1q22b, .,0,99, 98)  |  !inlist( sa1q22c, .,0,99, 98) |  !inlist( sa1q22d, .,0,99, 98)
replace decision_maker1=sa1q22a if !inlist( sa1q22a, .,0,99, 98)  
replace decision_maker2=sa1q22b if !inlist( sa1q22b, .,0,99, 98)
replace decision_maker1=sa1q22c if !inlist( sa1q22c, .,0,99, 98)  
replace decision_maker2=sa1q22d if !inlist( sa1q22d, .,0,99, 98)
keep if  !inlist( sa1q22a, .,0,99, 98) |  !inlist( sa1q22b, .,0,99, 98)  
keep hhid type_decision decision_maker*
tempfile planting_input8
save `planting_input8'
restore
append using `planting_input8'
* append who make decision about plot (manage)
preserve
replace type_decision="planting_input" if  !inlist( sa1q24a, .,0,99, 98) |  !inlist( sa1q24b, .,0,99, 98) |  !inlist( sa1q24c, .,0,99, 98) 
replace decision_maker1=sa1q24a if !inlist( sa1q24a, .,0,99, 98)  
replace decision_maker2=sa1q24b if !inlist( sa1q24b, .,0,99, 98)
replace decision_maker2=sa1q24c if !inlist( sa1q24c, .,0,99, 98)
keep if  !inlist( sa1q24a, .,0,99, 98) |  !inlist( sa1q24b, .,0,99, 98) |  !inlist( sa1q24c, .,0,99, 98) 
keep hhid type_decision decision_maker*
tempfile planting_input9
save `planting_input9'
restore
append using `planting_input9'  
* append who make decision about input (fertilizer)  
preserve
replace type_decision="planting_input" if  !inlist( s11dq25a, .,0,99, 98) |  !inlist( s11dq25b, .,0,99, 98) 
replace decision_maker1=s11dq25a if !inlist( s11dq25a, .,0,99, 98)  
replace decision_maker2=s11dq25b if !inlist( s11dq25b, .,0,99, 98)
keep if  !inlist( s11dq25a, .,0,99, 98) |  !inlist( s11dq25b, .,0,99, 98)  
keep hhid type_decision decision_maker*
tempfile planting_input10
save `planting_input10'
restore
append using `planting_input10'
* sales_crop
replace type_decision="sales_crop" if  !inlist( sa3iiq8a, .,0,99, 98) |  !inlist( sa3iiq8b, .,0,99, 98)  
replace decision_maker1=sa3iiq8a if !inlist( sa3iiq8a, .,0,99, 98)  
replace decision_maker2=sa3iiq8b if !inlist( sa3iiq8b, .,0,99, 98)
* sales_processcrop
replace type_decision="sales_processcrop" if  (!inlist( sa8q7a, .,0,99, 98) |  !inlist( sa8q7b, .,0,99, 98))  & inlist(byprod_cd, 6,7,8)
replace decision_maker1=sa8q7a if !inlist( sa8q7a, .,0,99, 98)  & inlist(byprod_cd, 6,7,8) 
replace decision_maker2=sa8q7b if !inlist( sa8q7b, .,0,99, 98)  & inlist(byprod_cd, 6,7,8)
* keep/manage livesock
replace type_decision="livestockowners" if  !inlist( s11iq4a, .,0,99, 98) |  !inlist( s11iq4b, .,0,99, 98)  
replace decision_maker1=s11iq4a if !inlist( s11iq4a, .,0,99, 98)  
replace decision_maker2=s11iq4b if !inlist( s11iq4b, .,0,99, 98)
* Append who make decision about plot
preserve
replace type_decision="livestockowners" if  !inlist( s11iq5a, .,0,99, 98) |  !inlist( s11iq5b, .,0,99, 98) 
replace decision_maker1=s11iq5a if !inlist( s11iq5a, .,0,99, 98)  
replace decision_maker2=s11iq5b if !inlist( s11iq5b, .,0,99, 98)
keep if  !inlist( s11iq5a, .,0,99, 98) |  !inlist( s11iq5b, .,0,99, 98)  
keep hhid type_decision decision_maker*
tempfile livestockowners2
save `livestockowners2'
restore
append using `livestockowners2'  
* otherlivestock_sales
replace type_decision="otherlivestock_sales" if  (!inlist( sa8q7a, .,0,99, 98) |  !inlist( sa8q7b, .,0,99, 98))  & !inlist(byprod_cd, 6,7,8)
replace decision_maker1=sa8q7a if !inlist( sa8q7a, .,0,99, 98)   & !inlist(byprod_cd, 6,7,8)
replace decision_maker2=sa8q7b if !inlist( sa8q7b, .,0,99, 98)  & !inlist(byprod_cd, 6,7,8)
   
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

gen make_decision_livestock=1 if  type_decision=="manage_livestock" ///
							| type_decision=="otherlivestock_sales"
recode 	make_decision_livestock (.=0)

gen make_decision_ag=1 if make_decision_crop==1 | make_decision_livestock==1
recode 	make_decision_ag (.=0)

collapse (max) make_decision_* , by(hhid decision_maker )  //any decision
ren decision_maker indiv 

*	Now merge with member characteristics
*merge 1:1 hhid indiv  using  "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_person_ids.dta", nogen keep (2 3) //Using gender from planting and harvesting sections
merge 1:1 hhid indiv using "${raw_data}/sect1_plantingw3.dta", nogen
merge 1:1 hhid indiv using "${raw_data}/sect1_harvestw3.dta"
gen female = s1q2 ==2
recode make_decision_* (.=0)

lab var make_decision_crop "1=invidual makes decision about crop production activities"
lab var make_decision_livestock "1=invidual makes decision about livestock production activities"
lab var make_decision_ag "1=invidual makes decision about agricultural (crop or livestock) production activities"
save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_make_ag_decision.dta", replace


************
*WOMEN'S OWNERSHIP OF ASSETS
************
* Code as 1 if a woman is sole or joint owner of any specified productive asset; 
* can report on % of women who own, taking total number of women HH members as denominator
* In most cases, NGA LSMS 3 as the first TWO owners.
* Indicator may be biased downward if some women would have been not listed among the two the first 2 asset-owners can also claim ownership of some assets
 
*First, append all files with information on asset ownership
use "${raw_data}\sect11b1_plantingw3.dta", clear
append using "${raw_data}\sect11e_plantingw3.dta" 
append using "${raw_data}\secta1_harvestw3.dta"
append using "${raw_data}\sect11i_plantingw3.dta"
append using "${raw_data}\secta4_harvestw3.dta"
append using "${raw_data}\sect5_plantingw3.dta"
 
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
* Append who has title
preserve
replace type_asset="landowners" if  !inlist( s11b1q8b1, .,0,99, 98) |  !inlist( s11b1q8b2, .,0,99, 98)  |  !inlist( s11b1q8b3, .,0,99, 98)
replace asset_owner1=s11b1q8b1 if !inlist( s11b1q8b1, .,0,99, 98)  
replace asset_owner2=s11b1q8b2 if !inlist( s11b1q8b2, .,0,99, 98)
replace asset_owner3=s11b1q8b3 if !inlist( s11b1q8b3, .,0,99, 98)
keep if !inlist( s11b1q8b1, .,0,99, 98) |  !inlist( s11b1q8b2, .,0,99, 98)  |  !inlist( s11b1q8b3, .,0,99, 98)
keep hhid type_asset asset_owner*
tempfile land3
save `land3'
restore
append using `land3' 
* Livestock owners
replace type_asset="livestockowners" if  !inlist( s11iq4a, .,0,99, 98) |  !inlist( s11iq4b, .,0,99, 98)  
replace asset_owner1=s11iq4a if !inlist( s11iq4a, .,0,99, 98)  
replace asset_owner2=s11iq4b if !inlist( s11iq4b, .,0,99, 98)
    	
* AGRICULTURAL CAPITAL
replace type_asset="agcapialowner" if  !inlist( sa4q2a, .,0,99, 98) |  !inlist( sa4q2b, .,0,99, 98) |  !inlist( sa4q2c, .,0,99, 98) |  !inlist( sa4q2d, .,0,99, 98) 
replace asset_owner1=sa4q2a if !inlist( sa4q2a, .,0,99, 98)  
replace asset_owner2=sa4q2b if !inlist( sa4q2b, .,0,99, 98)
replace asset_owner3=sa4q2c if !inlist( sa4q2c, .,0,99, 98)  
replace asset_owner4=sa4q2d if !inlist( sa4q2d, .,0,99, 98)
* Non farm assets (equipment)
drop if inlist(item_cd, 301 , 302 , 303, 304 , 305 ,  306, 321,  322 , 323, 324, 326, 325,  327,  329)
replace type_asset="nonfarm_asset" if  !inlist( s5q2, .,0,99, 98) |  !inlist( s5q2b, .,0,99, 98)  
replace asset_owner1=s5q2 if !inlist( s5q2, .,0,99, 98)  
replace asset_owner2=s5q2b if !inlist( s5q2b, .,0,99, 98)
    	
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
* Now merge with member characteristics
*merge 1:1 hhid indiv  using  "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_person_ids.dta" //Using gender from planting and harvesting sections 
merge 1:1 hhid indiv using "${raw_data}/sect1_plantingw3.dta", nogen
merge 1:1 hhid indiv using "${raw_data}/sect1_harvestw3.dta"
gen female = s1q2 ==2

recode own_asset (.=0)
lab var own_asset "1=invidual owns an assets (land or livestock)"
save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_make_ownasset.dta", replace




**************
*AGRICULTURAL WAGES
**************

use "${raw_data}\sect11c1_plantingw3.dta", clear
recode s11c1q4 s11c1q7 s11c1q10 (0=.) // 6 obs 0 male wage; 3 obs with 0 female wage; 1 obs with 0 child wage
*To be consistent with other instrument focus the analysis only on wage for male and female and average wage accross gender
* The question asked total wage paid. Daily wage is obtained by dividing total paid/number of worker
ren s11c1q3 hired_male_day
ren s11c1q6 hired_female_day
gen  male_wage=s11c1q4/hired_male_day
gen  female_wage=s11c1q7/hired_female_day
*  total paid wage/number of hired labor
recode male_wage hired_male_day female_wage hired_female_day (.=0) // set missing to zero to count observation with no male hired labor or with no female hired labor
gen all_wage=(male_wage*hired_male_day+ female_wage*hired_female_day)/(hired_male_day+hired_female_day)
* re-set 0 to missing
recode male_wage hired_male_day female_wage hired_female_day (0=.) 
* get average wage accross all plots and crops to obtain wage at household level by  activities
collapse (mean) male_wage female_wage all_wage,by(zone state lga sector ea hhid)
** group activities
gen  labor_group=1  //"pre-planting + planting + other non-harvesting"
tempfile nga_labor_group1
save `nga_labor_group1', replace

** ---------------- Beging wage for harvest and Post-harvest activities ---------------- **  

** load the wage data file
use "${raw_data}\secta2_harvestw3.dta", clear
recode sa2q1e sa2q1h sa2q1k (0=.) // 5 obs 0 male wage; 4 obs with 0 female wage; 2 obs with 0 child wage
*To be consistent with other instrument focus the analysis only on wage for male and female and average wage accross gender
* The question asked total wage paid. Daily wage is obtained by dividing total paid/number of worker
ren sa2q1d hired_male_day
ren sa2q1g hired_female_day
gen  male_wage=sa2q4/hired_male_day
gen  female_wage=sa2q7/hired_female_day
* total paid wage/number of hired labor
recode male_wage hired_male_day female_wage hired_female_day (.=0) // set missing to zero to count observation with no male hired labor or with no female hired labor
gen all_wage=(male_wage*hired_male_day+ female_wage*hired_female_day)/(hired_male_day+hired_female_day)
* re-set 0 to missing
recode male_wage hired_male_day female_wage hired_female_day (0=.) 
* get average wage accross all plots and crops to obtain wage at household level by  activities
collapse (mean) male_wage female_wage all_wage,by(zone state lga sector ea hhid)
** group activities
gen  labor_group=2  //"harvesting + threshing"
tempfile nga_labor_group2
save `nga_labor_group2', replace

use `nga_labor_group1', clear
append using `nga_labor_group2'
 
gen all_wage_preharvest = all_wage if labor_group==1
gen all_wage_harvest = all_wage if labor_group==2
gen female_wage_preharvest = female_wage if labor_group==1
gen female_wage_harvest = female_wage if labor_group==2
gen male_wage_preharvest = male_wage if labor_group==1
gen male_wage_harvest = male_wage if labor_group==2
collapse (mean) all_wage* female_wage*  male_wage*, by(hhid)
lab var all_wage  "Daily agricultural wage (local currency)"
lab var all_wage_preharvest "Daily agricultural wage for pre-harvest activities (local currency)"
lab var all_wage_harvest "Daily agricultural wage for harvest and post-harvest activities (local currency)"
lab var female_wage "Daily agricultural wage (local currency)  - paid to female workers)"
lab var female_wage_preharvest "Daily agricultural wage for harvest and pre-harvest activities (local currency) - paid to female workers"
lab var female_wage_harvest "Daily agricultural wage for harvest and post-harvest activities (local currency) - paid to female workers"
lab var male_wage "Daily agricultural wage (local currency)  - paid to male workers)"
lab var male_wage_preharvest  "Daily agricultural wage for harvest and pre-harvest activities (local currency) - paid to male workers"
lab var male_wage_harvest  "Daily agricultural wage for harvest and post-harvest activities (local currency) - paid to male workers"
save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_ag_wage.dta", replace



****************
* Crop Yield   *
****************
	
clear
use "${raw_data}/sect11f_plantingw3"

ren plotid plot_id
ren cropcode crop_code

*including monocropping and relay cropping (plant one crop, harvest, then plant another) as monocropping
gen purestand= 0
replace purestand= 1 if s11fq2==1 | s11fq2==3 
gen any_pure= purestand==1
gen any_mixed = purestand==0

keep any_pure any_mixed hhid plot_id crop_code

duplicates drop hhid plot_id crop_code, force //4 obs deleted

save "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_area_planted", replace


* Area conversion factors
use "${raw_data}/ag_conv_w3", clear
ren crop_cd crop_code
ren conv_NC_1 conv_fact1
ren conv_NE_2 conv_fact2
ren conv_NW_3 conv_fact3
ren conv_SE_4 conv_fact4
ren conv_SS_5 conv_fact5
ren conv_SW_6 conv_fact6
sort crop_code unit_cd conv_national

reshape long conv_fact, i(crop_code unit_cd conv_national) j(zone)

save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_ng3_cf.dta", replace


clear
use "${raw_data}/secta3i_harvestw3.dta"

rename cropname crop_name
rename cropcode crop_code
rename sa3iq3 harvest_yesno
rename sa3iq6i quantity_harvested
rename sa3iq6ii quantity_harvested_unit
rename sa3iq6ii_os quantity_harvested_unit_other
rename sa3iq6a value_harvested
rename sa3iq5c percent_harv
rename sa3iq5a area_harv
rename sa3iq5b area_harv_unit
ren plotid plot_id

*merging in field sizes
merge m:1 hhid plot_id using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_plot_areas.dta", gen(_plot_merge) keep(1 3)
*11,956 matched

*generating area harvested as percent of plot area
gen area_harv_ha= field_size*(percent_harv/100)

*replacing area harvested with area reported by farmer
replace area_harv_ha= area_harv if area_harv_unit==6 & area_harv_ha ==.
replace area_harv_ha = area_harv*0.0667 if area_harv_unit==4	& area_harv_ha ==.		//reported in plots
replace area_harv_ha = area_harv*0.404686 if area_harv_unit==5 & area_harv_ha ==.			//reported in acres

replace area_harv_ha = area_harv*0.0001 if area_harv_unit==7	& area_harv_ha ==.		//reported in square meters

replace area_harv_ha = area_harv*0.00012 if area_harv_unit==1 & zone==1 & area_harv_ha ==.		//reported in heaps
replace area_harv_ha = area_harv*0.00016 if area_harv_unit==1 & zone==2 & area_harv_ha ==.
replace area_harv_ha = area_harv*0.00011 if area_harv_unit==1 & zone==3 & area_harv_ha ==.
replace area_harv_ha = area_harv*0.00019 if area_harv_unit==1 & zone==4 & area_harv_ha ==.
replace area_harv_ha = area_harv*0.00021 if area_harv_unit==1 & zone==5 & area_harv_ha ==.
replace area_harv_ha = area_harv*0.00012 if area_harv_unit==1 & zone==6 & area_harv_ha ==.

replace area_harv_ha = area_harv*0.0027 if area_harv_unit==2 & zone==1 & area_harv_ha ==.			//reported in ridges
replace area_harv_ha = area_harv*0.004 if area_harv_unit==2 & zone==2 & area_harv_ha ==.
replace area_harv_ha = area_harv*0.00494 if area_harv_unit==2 & zone==3 & area_harv_ha ==.
replace area_harv_ha = area_harv*0.0023 if area_harv_unit==2 & zone==4 & area_harv_ha ==.
replace area_harv_ha = area_harv*0.0023 if area_harv_unit==2 & zone==5 & area_harv_ha ==.
replace area_harv_ha = area_harv*0.00001 if area_harv_unit==2 & zone==6 & area_harv_ha ==.

replace area_harv_ha = area_harv*0.00006 if area_harv_unit==3 & zone==1 & area_harv_ha ==.			//reported in stands
replace area_harv_ha = area_harv*0.00016 if area_harv_unit==3 & zone==2 & area_harv_ha ==.
replace area_harv_ha = area_harv*0.00004 if area_harv_unit==3 & zone==3 & area_harv_ha ==.
replace area_harv_ha = area_harv*0.00004 if area_harv_unit==3 & zone==4 & area_harv_ha ==.
replace area_harv_ha = area_harv*0.00013 if area_harv_unit==3 & zone==5 & area_harv_ha ==.
replace area_harv_ha = area_harv*0.00041 if area_harv_unit==3 & zone==6 & area_harv_ha ==.

//PEB cap area harvested at field size
replace area_harv_ha=field_size if area_harv_ha>field_size & area_harv_ha!=.
//601 changes made, mean area is 0.4886

//PEB rescale area harvested for plots where total area harvested across crops is greater than total plot area
bys hhid plot_id: egen total_harvested_ha = sum(area_harv_ha)			// total on plot across ALL crops
gen harvested_ratio=total_harvested_ha/field_size
replace area_harv_ha=area_harv_ha/harvested_ratio if harvested_ratio>1 & harvested_ratio!=. //rescale area harvested if total area harvested across crops>plot area
//6,136 changes, mean area is 0.2912
drop total_harvested_ha harvested_ratio

*PEB replacing all area harvested of 0 as missing (can't have area harvested =0)
replace area_harv_ha=. if area_harv_ha==0

*renaming unit code for merge 
ren quantity_harvested_unit unit_cd

*merging in conversion factors
merge m:1 crop_code unit_cd zone using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_ng3_cf.dta", gen(cf_merge)
*not matched 6,808
*matched 7,998

gen quant_harv_kg= quantity_harvested*conv_fact
*still missing 4,654 observations with no conversion listed at zone or national level; many very specific units

*PEB Adding code to using median conversion factors at lowest possible area to try and avoid missings; units/conversions seem somewhat stable across crops
bys unit_cd zone state: egen state_conv_unit = median(conv_fact)
bys unit_cd zone: egen zone_conv_unit = median(conv_fact)
bys unit_cd: egen national_conv = median(conv_fact)
replace conv_fact = state_conv_unit if conv_fact==. & unit_cd!=900		// Not for "other" ones -- 919 changes
replace conv_fact = zone_conv_unit if conv_fact==. & unit_cd!=900		// Not for "other" ones -- 190 changes
replace conv_fact = national_conv if conv_fact==. & unit_cd!=900

replace quant_harv_kg= quantity_harvested*conv_fact
replace quant_harv_kg= quantity_harvested if unit_cd==1
replace quant_harv_kg= quantity_harvested/1000 if unit_cd==2
//still 3,543 obs with no conversion listed

drop if quant_harv_kg==.
*5,243 observations dropped

keep crop_code quant_harv_kg hhid area_harv_ha plot_id field_size

*merging in gender variables
merge m:1 hhid plot_id using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_plot_decision_makers", gen(_merge_gender)
*728 not matched (from using)
*9,563 matched
*No quant_harv for all obs not matched
drop if quant_harv_kg==. //728 dropped

*merging in intercrop variables
merge m:1 hhid plot_id crop_code using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_area_planted", gen(_intercrop_merge) keep(1 3)
*171 not matched (could be new plots since planting survey)

*Creating area and quantity variables by decision-maker and type of planting
ren quant_harv_kg harvest 
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


*collapsing to HH-crop level
collapse (sum) harvest* area_harv* (max) dm_* inter field_size, by(hhid crop_code)
global croplist "1110, 1010, 1080, 1070, 1020"
keep if inlist(crop_code, $croplist)

*merging in weights
merge m:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_weights.dta", nogen keep(1 3)

global croplist "1110 1010 1080 1070 1020"
foreach x of varlist area_harv*{
	foreach c of global croplist{
	di "`c'"
		_pctile `x' [aw=weight] if crop_code==`c', p(1 99)
		replace `x' = r(r1) if `x' < r(r1) & crop_code ==`c'
		replace `x' = r(r2) if (`x' > r(r2) & `x' !=.) & crop_code==`c'
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
global croplist "1110 1010 1080 1070 1020"
foreach p of global croplist{
	_pctile yield [aw=weight] if crop_code==`p', p(99)
	gen crop_`p'_99th = r(r1)
}

foreach x of varlist yield* {
	replace `x' = crop_1110_99th if (crop_code==1110 & `x' > crop_1110_99th & `x' !=.)
	replace `x' = crop_1010_99th if (crop_code==1010 & `x' > crop_1010_99th & `x' !=.)
	replace `x' = crop_1080_99th if (crop_code==1080 & `x' > crop_1080_99th & `x' !=.)
	replace `x' = crop_1070_99th if (crop_code==1070 & `x' > crop_1070_99th & `x' !=.)
	replace `x' = crop_1020_99th if (crop_code==1020 & `x' > crop_1020_99th & `x' !=.)
}

drop crop*_99th 
save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_crop_harvest_area_yield.dta", replace



*Yield at the household level
use "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_crop_harvest_area_yield.dta", clear
foreach v of varlist harvest*  area_harv* yield* ar_wgt*  {
	separate `v', by(crop_code)
	local `v'1110 = subinstr("`v'1110","1110","_rice",1)
	ren `v'1110  ``v'1110'
	local `v'1010 = subinstr("`v'1010","1010","_beans",1)
	ren `v'1010  ``v'1010'
	local `v'1080 = subinstr("`v'1080","1080","_maize",1)
	ren `v'1080  ``v'1080'
	local `v'1070 = subinstr("`v'1070","1070","_sorghum",1)
	ren `v'1070  ``v'1070'
	local `v'1020 = subinstr("`v'1020","1020","_cassava",1)
	ren `v'1020  ``v'1020'
}
collapse (firstnm) *maize *rice *sorghum *cassava *beans, by(hhid)
recode  *maize *rice *sorghum *beans (0=.)

local vars maize rice  sorghum cassava beans
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

save "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_yield_hh_level.dta", replace
 


 
 
***************************************************
***************************************************
**                                               **
** Creating Variables for Indicator Construction **
**                                               **
***************************************************
***************************************************



************
*HOUSEHOLD VARIABLES
************

use "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_hhids.dta", clear

*Gross crop income 
merge 1:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_hh_crop_production.dta", nogen
merge 1:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_crop_losses.dta", nogen
recode value_crop_production crop_value_lost (.=0)
*Variables: value_crop_production crop_value_lost

*Crop costs
merge 1:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_asset_rental_costs.dta", nogen
merge 1:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_land_rental_costs.dta", nogen
merge 1:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_seed_costs.dta", nogen
merge 1:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_manure_costs.dta", nogen
merge 1:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_chemical_costs.dta", nogen
merge 1:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_fertilizer_costs.dta", nogen
merge 1:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_wages_postplanting.dta", nogen
merge 1:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_wages_postharvest.dta", nogen
recode animal_rent_paid rental_cost_ag_assets rental_cost_land cost_seed cost_transportation_seed value_manure_purchased /*
*/ cost_transport_manure expenditure_subsidized_fert value_fertilizer cost_transport_fertilizer cost_transport_free_fert /*
*/ value_herbicide value_pesticide wages_paid_aglabor_postplant wages_paid_aglabor_postharvest (.=0)
egen crop_production_expenses = rowtotal(animal_rent_paid rental_cost_ag_assets rental_cost_land cost_seed cost_transportation_seed  /*
*/ value_manure_purchased cost_transport_manure expenditure_subsidized_fert value_fertilizer cost_transport_fertilizer /*
*/ cost_transport_free_fert value_herbicide value_pesticide wages_paid_aglabor_postplant wages_paid_aglabor_postharvest)
gen crop_income = value_crop_production - crop_production_expenses - crop_value_lost
lab var crop_production_expenses "Crop production expenditures (explicit)"
lab var crop_income "Net crop revenue (value of production minus crop expenses)"

*Fish income
merge 1:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_fish_income.dta", nogen
merge 1:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_fishing_expenses_1.dta", nogen
merge 1:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_fishing_expenses_2.dta", nogen
gen fish_income_fishfarm = value_fish_harvest - fish_expenses_1 - fish_expenses_2
gen fish_income_fishing = value_fish_caught - fish_expenses_1 - fish_expenses_2
*Very large outliers.
gen fishing_income = fish_income_fishing
recode fishing_income fish_income_fishing fish_income_fishfarm (.=0)
lab var fish_income_fishing "Net fishing income (value of production and consumption minus expenditures)"
lab var fish_income_fishfarm "Net fish farm income (value of production minus expenditures)"
lab var fishing_income "Net fishing income (value of production and consumption minus expenditures)"

*Livestock income
merge 1:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_livestock_sales.dta", nogen
merge 1:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_livestock_expenses.dta", nogen
merge 1:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_livestock_products.dta", nogen
merge 1:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_TLU.dta", nogen
*Number of obs are not consistent across these files.
*Zero values if not found?
*3,022 obs. (4,613 in the data set) 
*adding in fish farm income to livestock income
gen livestock_income = value_livestock_sales - value_livestock_purchases /*
*/ + ( value_milk_produced + value_eggs_produced + value_other_produced) /*
*/ - ( cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_other_livestock) + fish_income_fishfarm
recode livestock_income (.=0)
lab var livestock_income "Net livestock income (value of production and consumption minus expenditures)"
gen livestock_expenses = ( cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_other_livestock)
lab var livestock_expenses "Expenditures on livestock purchases and maintenance"
gen livestock_product_revenue = ( value_milk_produced + value_eggs_produced + value_other_produced)
lab var livestock_product_revenue "Gross revenue from sale of livestock products"

*Self-employment income
merge 1:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_self_employment_income.dta", nogen
merge 1:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_agproduct_income.dta", nogen
egen self_employment_income = rowtotal(profit_processed_crop_sold annual_selfemp_profit)
recode self_employment_income (.=0)
lab var self_employment_income "Income from self-employment (business)"

*Wage income
merge 1:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_agwage_income.dta", nogen
merge 1:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_wage_income.dta", nogen
recode annual_salary annual_salary_agwage (.=0)
rename annual_salary wage_income
rename annual_salary_agwage agwage_income

*Other income
merge 1:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_other_income.dta", nogen
merge 1:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_remittance_income.dta", nogen
merge 1:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_other_income.dta", nogen
egen other_income_sources = rowtotal(investment_income rental_income_buildings other_income assistance_income rental_income_assets remittance_income)
recode other_income_sources (.=0)
lab var other_income_sources "Income from transfers, remittances, other revenue streams not captured elsewhere"
drop other_income
rename other_income_sources other_income

*Farm size
merge 1:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_land_size_all.dta", nogen
merge 1:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_farmsize_all_agland.dta", nogen
merge 1:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_land_size.dta", nogen
recode land_size (.=0)

*Labor
merge 1:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_farmlabor_postplanting.dta", nogen
merge 1:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_farmlabor_postharvest.dta", nogen
egen labor_total = rowtotal(days_hired_postplant days_famlabor_postplant days_hired_postplant days_famlabor_postplant days_hired_postharvest days_famlabor_postharvest days_exchange_labor_postharvest) 

*Household size
merge 1:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_hhsize.dta", nogen

*Rates of vaccine, improved seeds, inorganic fertilizer, extensions, and formal financial services 
merge 1:1 hhid using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_vaccine.dta", nogen
merge 1:1 hhid using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_fert_use.dta", nogen
merge 1:1 hhid using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_improvedseed_use.dta", nogen
merge 1:1 hhid using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_any_ext.dta", nogen
merge 1:1 hhid using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_fin_serv.dta", nogen
recode use_fin_serv ext_reach use_inorg_fert imprv_seed_use vac_animal (.=0)
replace vac_animal=. if tlu_today==0 
replace use_inorg_fert=. if farm_area==0 | farm_area==. // Area cultivated this year
replace ext_reach=. if (value_crop_production==0 & livestock_income==0 & farm_area==0 & tlu_today==0)
replace ext_reach=. if farm_area==.
replace imprv_seed_use=. if farm_area==.

*Cost of crop production per hectare
merge 1:1 hhid using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_cropcosts_perha.dta", nogen

*Rate of fertilizer application
merge 1:1 hhid using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_fertilizer_application.dta", nogen

*Agricultural wage rate
merge 1:1 hhid using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_ag_wage.dta", nogen
*ren wage_all_activities all_wage
*drop  wage_preharvest_activities wage_harvest_activities

*Crop yields
merge 1:1 hhid using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_yield_hh_level.dta", nogen 

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
global wins_vars ha_planted ha_planted_male ha_planted_female ha_planted_mixed /*liters_per_largeruminant   egg_poultry_year egg and milk*/ inorg_fert_rate inorg_fert_rate_male /*
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
global exchange_rate 199.04975
global ppp_dollar 94.1   // https://data.worldbank.org/indicator/PA.NUS.PPP
rename costs_total_explicit_hh_female costs_total_explicit_hh_fem
rename costs_total_explicit_hh_mixed costs_explicit_hh_mix
global monetary_vars crop_income livestock_income percapita_income total_income nonfarm_income farm_income land_productivity labor_productivity /*
*/ all_wage female_wage male_wage costs_total_hh costs_total_hh_male costs_total_hh_female costs_total_hh_mixed /*
*/ costs_total_explicit_hh costs_total_explicit_hh_male costs_total_explicit_hh_fem costs_explicit_hh_mix
foreach p of global monetary_vars {
gen `p'_ppp = `p' / ${ppp_dollar}
}
foreach p of global monetary_vars {
gen `p'_usd = `p' / ${exchange_rate}   
}
sum ha_planted ha_planted_male ha_planted_female ha_planted_mixed 

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
lab var female_wage_ppp "Daily wage (PPP $ / workday) - female workers"
lab var male_wage_ppp "Daily wage (PPP $ / workday) - male workers"
lab var farm_income_ppp "Farm income (PPP $)"
lab var crop_income_ppp "Crop income (PPP $)"
lab var livestock_income_ppp "Livestock income (PPP $)"
lab var percapita_income_ppp "Per capita income (PPP $)"
lab var total_income_ppp "Total household income (PPP $)"
lab var nonfarm_income_ppp "Nonfarm income (excludes agricultural wages)(PPP $)"
lab var land_productivity_ppp "Land productivity (gross value production per ha cultivated) (PPP $)"
lab var all_wage_usd "Daily wage ($ / workday)"
lab var female_wage_usd "Daily wage ($ / workday) - female workers"
lab var male_wage_usd "Daily wage ($ / workday) - male workers"

lab var costs_total_hh_usd "Explicit + implicit costs of crop production (household level) per ha (2016 USD)"
lab var costs_total_hh_male_usd "Explicit + implicit costs of crop production (male-managed crops) per ha (2016 USD)"
lab var costs_total_hh_female_usd "Explicit + implicit costs of crop production (female-managed crops) per ha (2016 USD)"
lab var costs_total_hh_mixed_usd "Explicit + implicit costs of crop production (mixed-managed crops) per ha (2016 USD)"
lab var costs_total_explicit_hh_usd "Explicit costs of crop production (household level) per ha (2016 USD)"
lab var costs_total_explicit_hh_male_usd "Explicit costs of crop production (male-managed crops) per ha (2016 USD)"
lab var costs_total_explicit_hh_fem_usd "Explicit costs of crop production (female-managed crops) per ha (2016 USD)"
lab var costs_explicit_hh_mix_usd "Explicit costs of crop production (mixed-managed crops) per ha (2016 USD)"
lab var all_wage_usd "Daily wage (2016 USD / workday)"
lab var farm_income_usd "Farm income (2016 USD)"
lab var crop_income_usd "Crop income (2016 USD)"
lab var livestock_income_usd "Livestock income (2016 USD)"
lab var percapita_income_usd "Per capita income (2016 USD)"
lab var total_income_usd "Total household income (2016 USD)"
lab var nonfarm_income_usd "Nonfarm income (excludes agricultural wages)(2016 USD)"
lab var land_productivity_usd "Land productivity (gross value production per ha cultivated) (2016 USD)"
lab var labor_productivity_usd "Labor productivity (gross value production per labor-day) (2016 USD)"
lab var total_income "Total household income in local currency"
lab var share_nonfarm "Share of household income derived from nonfarm sources"
lab var percapita_income "Household incom per household member per day, in the local currency"
lab var land_productivity "Gross crop income per hectare cultivated, in the local currency"
lab var labor_productivity "Gross crop income per labor-day on the farm, in the local currency"
lab var ag_hh "1= Household has some land cultivated, some livestock, some crop income, or some livestock income"
lab var farm_income "Farm income (local currency)"
lab var nonfarm_income "Non farm income (local currency)"
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm in the past year"
*lab var exchange_rate "Exchange rate (local currency to USD in 2016)"
lab var all_wage "Daily agricultural wage (local currency)"
lab var male_wage "Daily agricultural wage for men (local currency)"
lab var female_wage "Daily agricultural wage for women (local currency)"
lab var labor_productivity_ppp "Labor productivity (gross value production per labor-day) (PPP $)"
*Clean up the data file
drop cost_hired_labor_livestock cost_fodder_livestock cost_vaccines_livestock cost_other_livestock /*
*/ value_milk_produced value_eggs_produced value_other_produced /*
*/ fish_income_fishing fish_income_fishfarm value_fish_harvest fish_expenses_1 fish_expenses_2 value_fish_caught /*
*/ investment_income rental_income_buildings /*other_income*/ assistance_income rental_income_assets remittance_income /*
*/ days_hired_postplant days_famlabor_postplant days_hired_postharvest days_famlabor_postharvest days_exchange_labor_postharvest /*
*/ value_owned_land value_owned_land_male value_owned_land_female value_owned_land_mixed /*ha_planted ha_planted_male /*
*/ ha_planted_female ha_planted_mixed*/ value_rented_land_male value_rented_land_female value_rented_land_mixed /*
*/ value_rented_land value_hired_labor value_hired_labor_male value_hired_labor_female value_hired_labor_mixed /*
*/ value_fam_labor value_fam_labor_male value_fam_labor_female value_fam_labor_mixed value_hired_mid_labor /*
*/ value_hired_mid_labor_male value_hired_mid_labor_female value_hired_mid_labor_mixed value_fam_mid_labor /*
*/ value_fam_mid_labor_male value_fam_mid_labor_female value_fam_mid_labor_mixed value_hired_harv_labor /*
*/ value_hired_harv_labor_male value_hired_harv_labor_female value_hired_harv_labor_mixed value_fam_harv_labor /*
*/ value_fam_harv_labor_male value_fam_harv_labor_female value_fam_harv_labor_mixed value_inorg_purchased /*
*/ value_inorg_purchased_male value_inorg_purchased_female value_inorg_purchased_mixed value_inorg_notpurchased /*
*/ value_inorg_notpurchased_male value_inorg_notpurchased_female value_inorg_notpurchased_mixed value_org_purchased /*
*/ value_org_purchased_male value_org_purchased_female value_org_purchased_mixed value_org_notpurchased /*
*/ value_org_notpurchased_male value_org_notpurchased_female value_org_notpurchased_mixed value_pesticide_free /*
*/ value_herbicide_free value_animal_rent value_machine_rent value_pesticide_male value_pesticide_female /*
*/ value_pesticide_mixed value_pesticide_free_male value_pesticide_free_female value_pesticide_free_mixed /*
*/ value_herbicide_male value_herbicide_female value_herbicide_mixed value_herbicide_free_male value_herbicide_free_female /*
*/ value_herbicide_free_mixed value_animal_rent_male value_animal_rent_female value_animal_rent_mixed value_machine_rent_male /*
*/ value_machine_rent_female value_machine_rent_mixed /*wt_w3v1 wt_wave3*/ fert_inorg_kg fert_inorg_kg_male fert_inorg_kg_female /*
*/ fert_inorg_kg_mixed fert_org_kg harvest_maize - area_harv_pure_mixed_maize  harvest_rice - area_harv_pure_mixed_rice /*
*/ harvest_sorghum - area_harv_pure_mixed_sorghum harvest_cassava - area_harv_pure_mixed_cassava harvest_beans - area_harv_pure_mixed_beans /*
*/ tlu_start_agseason value_start_agseason value_today value_today_est /*
*/ animal_rent_paid rental_cost_ag_assets rental_cost_land cost_seed cost_transportation_seed value_manure_purchased /*
*/ cost_transport_manure value_herbicide value_pesticide expenditure_subsidized_fert value_fertilizer /*
*/ cost_transport_fertilizer cost_transport_free_fert wages_paid_aglabor_postplant wages_paid_aglabor_postharvest weeks_fishing /*
*/ annual_selfemp_profit profit_processed_crop_sold exchange_rate female_head share_crop /*    
*/ share_livestock share_fishing share_self_employment share_wage share_agwage share_other       
save "${final_data}/Nigeria_GHSP_LSMS_ISA_W3_household_variables.dta", replace



**************
*INDIVIDUAL-LEVEL VARIABLES
**************
*use "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_person_ids.dta", clear
use "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_gender_merge.dta", clear
merge m:1 hhid using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_household_diet.dta", nogen
merge 1:1 hhid indiv using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_control_income.dta", nogen  keep(1 3)
merge 1:1 hhid indiv using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_make_ag_decision.dta", nogen  keep(1 3)
merge 1:1 hhid indiv using "${created_data}/Nigeria_GHSP_LSMS_ISA_W3_make_ownasset.dta", nogen  keep(1 3)
merge m:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_hhsize.dta", nogen keep (1 3)
merge m:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_hhids.dta", nogen keep (1 3)
*merge in hh variable to determine ag household
merge m:1 hhid using "${final_data}/Nigeria_GHSP_LSMS_ISA_W3_household_variables.dta", nogen keep (1 3)
drop value_crop_production- ar_wgt_inter_mixed_beans total_income - small_farm_household
replace   make_decision_ag =. if ag_hh==0
keep zone state lga ea hhid indiv weight female age rural ag_hh fhh control_all_income make_decision_ag own_asset
save "${final_data}/Nigeria_GHSP_LSMS_ISA_W3_individual_variables.dta", replace
*List the variables for the codebook
foreach var of varlist *{
di "`var'" _col(20) /*"`: var l `var''" _col(50)  */
}
foreach var of varlist *{
di /*"`var'" _col(20)*/ "`: var l `var''" _col(80) 
}


**************
*PLOT-LEVEL VARIABLES
**************

*List variables of the plot-level data, too.
use "${final_data}\Nigeria_GHSP_LSMS_ISA_W3_gender_productivity_gap.dta", clear
label define dm_gender 1 "Male only" 2 "Female only" 3 "Mixed"
label values dm_gender dm_gender
lab var dm_gender "Gender of decision-maker(s)"
rename gender_prod_gap1 gender_prod_gap
rename plot_value_productivity_ppp plot_productivity_ppp
keep zone state lga ea hhid weight plot_id rural dm_gender area_meas_hectares plot_weight plot_value_harvest plot_value_harvest_usd plot_productivity_usd plot_productivity_ppp gender_prod_gap
save "${final_data}\Nigeria_GHSP_LSMS_ISA_W3_gender_productivity_gap.dta", replace
*List the variables for the codebook
foreach var of varlist *{
di "`var'" _col(20) /*"`: var l `var''" _col(50)  */
}
foreach var of varlist *{
di /*"`var'" _col(20)*/ "`: var l `var''" _col(80) 
}


**************
*SUMMARY STATISTICS
**************
/*
All the pre-processed files include all households, individuals, and plots in the sample. 
The summary statistics are outputted only for the sub_population of households, individuals, and plots in rural areas. 
To consider a different sup_population or the entire sample, you have to modify the condition "if rural==1".
*/ 

use "${final_data}/Nigeria_GHSP_LSMS_ISA_W3_household_variables.dta", replace
gen clusterid=ea
gen strataid=state
** Statistics list 1 -   share_nonfarm nonfarm_income_usd total_income_usd all_wage_usd
global household_indicators1 share_nonfarm nonfarm_income_usd total_income_usd total_income_ppp all_wage_usd
global final_indicator1  
foreach v of global household_indicators1 {
	gen `v'_female_hh=`v' if fhh==1
	gen `v'_male_hh=`v' if fhh==0
	global final_indicator1 $final_indicator1 `v'  `v'_female_hh  `v'_male_hh
}
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
	tabstat $final_indicator2 [aw=`v'_weight]if rural==1, stat(mean semean sd p25 p50 p75  min max N) col(stat) save
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
*/ maize female_maize male_maize mixed_maize/*
*/ rice female_rice male_rice mixed_rice/*
*/ sorghum male_sorghum mixed_sorghum/*
*/ cassava female_cassava male_cassava mixed_cassava/*
*/ pure_beans pure_male_beans /*
*/ pure_maize pure_male_maize pure_mixed_maize/*
*/ pure_rice pure_female_rice pure_male_rice pure_mixed_rice /*
*/ pure_sorghum pure_male_sorghum /*
*/ pure_cassava pure_female_cassava pure_male_cassava pure_mixed_cassava/*
Cassava yield does not make send because area harvested not reported*//*
*/   
   
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

 
** Statistics list 7  - percapita_income_usd percapita_income_ppp crop_income_usd livestock_income_usd
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

*costs_total_hh costs_total_hh_male costs_total_hh_female costs_total_hh_mixed costs_total_explicit_hh costs_total_explicit_hh_male costs_total_explicit_hh_female costs_total_explicit_hh_mixed

** Statistics list 13 - costs_total_explicit_hh_usd
ren costs_total_explicit_hh_usd costs_total_explicit_hh_all_usd     
ren costs_explicit_hh_mix_usd costs_total_explicit_hh_mix_usd
global final_indicator13 all fem male  mix
matrix final_indicator13=(.,.,.,.,.,.,.,.,.,.)
foreach v of global final_indicator13 {
	tabstat costs_total_explicit_hh_`v'_usd   [aw=area_weight_`v']   if  rural==1 & ag_hh==1, stat(mean semean sd p25 p50 p75  min max N) col(stat) save
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
use  "${final_data}\Nigeria_GHSP_LSMS_ISA_W3_gender_productivity_gap.dta",  clear
gen clusterid=ea
gen strataid=state
*(Mean_Male-Mean_Female)/Mean_Male
qui svyset clusterid [pweight=plot_weight], strata(strataid) singleunit(centered) // get standard errors of the mean
tabstat plot_productivity_usd  [aw=plot_weight]  if  rural==1 & dm_gender!=.    , stat(mean semean sd p25 p50 p75  min max N) col(stat) save
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
 
tabstat plot_productivity_usd  [aw=plot_weight]   if rural==1 & dm_gender==3 , stat(mean semean sd p25 p50 p75  min max N) col(stat) save
matrix temp_mixed=r(StatTotal)'
qui svy, subpop(if rural==1 & dm_gender==3): mean plot_productivity_usd
matrix plot_productivity_mixed_usd=temp_mixed,el(r(table),2,1)
  
matrix final_indicator3=(plot_productivity_all_usd\plot_productivity_female_usd\plot_productivity_male_usd\plot_productivity_mixed_usd)
matrix list final_indicator3 

** Statistics list 6 - gender_prod_gap1
*(Mean_Male-Mean_Female)/Mean_Male
tabstat gender_prod_gap if rural==1   , stat(mean semean sd p25 p50 p75  min max N) col(stat) save
matrix final_indicator6=r(StatTotal)',.
matrix list final_indicator6 

** Statistics list 8  - women diet - not available for Nigeria LSMS
matrix final_indicator8=J(6,10,.)
matrix list final_indicator8 

** Statistics list 15
*keep only adult women
use "${final_data}/Nigeria_GHSP_LSMS_ISA_W3_individual_variables.dta", clear
merge m:1 hhid using "${created_data}\Nigeria_GHSP_LSMS_ISA_W3_hhids.dta", nogen
gen clusterid=ea
gen strataid=state
keep if female==1
keep if age>=18
global household_indicators15 control_all_income make_decision_ag own_asset    /*number_foodgroup women_diet*/
global final_indicator15 ""
foreach v of global household_indicators15 {
	gen `v'_female_hh=`v' if  fhh==1
	gen `v'_male_hh=`v' if fhh==0
	global final_indicator15 $final_indicator15 `v'  `v'_female_hh  `v'_male_hh 
}
tabstat ${final_indicator15} [aw=weight] if rural==1, stat(mean semean sd  p25 p50 p75  min max N) col(stat) save
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
	if `i' == 5 continue
	matrix final_indicator_all=final_indicator_all\final_indicator`i'
}
matrix list final_indicator_all 
matrix colname final_indicator_all = mean semean_simple sd p25 p50 p75 min max N semean_strata
* Export to Excel
putexcel set "$final_data\Nigeria_GHSP_LSMS_ISA_W3_summary_stats.xlsx", replace
putexcel A1=matrix(final_indicator_all)  , names 

	


