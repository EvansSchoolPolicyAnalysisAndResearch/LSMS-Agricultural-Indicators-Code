
/*-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of a set of agricultural development indicators 
				  using the Ethiopia Socioeconomic Survey (ESS) LSMS-ISA Wave 3 (2015-16)
*Author(s)		: Jack Knauer, David Coomes, Didier Alia, Ayala Wineman, Josh Merfeld, Pierre Biscaye, C. Leigh Anderson, &  Travis Reynolds

*Acknowledgments: We acknowledge the helpful contributions of members of the World Bank's LSMS-ISA team, the FAO's RuLIS team, IFPRI, IRRI, 
				  and the Bill & Melinda Gates Foundation Agricultural Development Data and Policy team in discussing indicator construction decisions. 
				  All coding errors remain ours alone.
*Date			: 10 November 2017
----------------------------------------------------------------------------------------------------------------------------------------------------*/


*Data source
*-----------
*The Ethiopia Socioeconomic Survey was collected by the Ethiopia Central Statistical Agency (CSA) 
*and the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture(LSMS - ISA)
*The data were collected over the period September - November 2015, and February - April 2016.
*All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
*http://microdata.worldbank.org/index.php/catalog/2783

*Throughout the do-file, we sometimes use the shorthand LSMS to refer to the Ethiopia Socioeconomic Survey.


*Summary of Executing the Master do.file
*-----------
*This Master do.file constructs selected indicators using the Ethiopia ESS (ETH LSMS) data set.
*First, save the raw unzipped data files from the World Bank in the "Raw DTA files\Wave 3 (2015-16)" folder  
*The do.file draws on these raw data files to first construct common and intermediate variables, saving dta files when appropriate 
*in the folder "Final DTA files\Wave 3 (2015-16)\created_data".
*These variables are then brought together at the household, plot, or individual level, saving dta files at each level when available 
*in the folder "Final DTA files\Wave 3 (2015-16)".

*The processed files include all households, individuals, and plots in the sample.
*Toward the end of the do.file, a block of code estimates summary statistics (mean, standard error of the mean, minimum, first quartile, median, third quartile, maximum) 
*of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager.
*The results are outputted in the excel file "Ethiopia_ESS_LSMS_ISA_W3_summary_stats.rtf" in the folder "Final DTA files\Wave 3 (2015-16)".
*It is possible to modify the condition  "if rural==1" in the portion of code following the heading "SUMMARY STATISTICS" to generate all summary statistics for a different sub_population.

*Information on EPAR's cleaning and construction decisions is available in the documents
*"EPAR_UW_335_Indicator Construction Summary Tables" and "EPAR_UW_335_General Considerations and Principles for Indicator Construction".

 
/*OUTLINE OF THE DO.FILE
Below are the list of the main files created by running this Master do.file
 	
	
*INTERMEDIATE FILES					MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD IDS						Ethiopia_ESS_LSMS_ISA_W3_hhids.dta
*WEIGHTS AND GENDER OF HEAD			Ethiopia_ESS_LSMS_ISA_W3_male_head
*INDIVIDUAL GENDER					Ethiopia_ESS_LSMS_ISA_W3_gender_merge_both.dta
*PLOT-CROP DECISION MAKERS			Ethiopia_ESS_LSMS_ISA_W3_field_gender_dm.dta
*AGRICULTURAL LAND DUMMY AND AREA 	Ethiopia_ESS_LSMS_ISA_W3_fields_agland.dta
*AG LAND AREA HOUSEHOLD				Ethiopia_ESS_LSMS_ISA_W3_farmsize_all_agland.dta

*FERTILIZER APPLICATION (KG)		Ethiopia_ESS_LSMS_ISA_W3_hh_fert.dta
*POST-PLANTING EXPENSES -  		    Ethiopia_ESS_LSMS_ISA_W3_hh_pp_inputs_value.dta
   EXPLICIT AND IMPLICIT

* HARVEST LABOR COSTS				Ethiopia_ESS_LSMS_ISA_W3_hh_cost_harv_labor.dta

*AREA PLANTED						Ethiopia_ESS_LSMS_ISA_W3_hh_area_land.dta
*GROSS CROP REVENUE AND CROP LOST	Ethiopia_ESS_LSMS_ISA_W3_crop_sales.dta
									Ethiopia_ESS_LSMS_ISA_W3_hh_crop_values_production.dta
									Ethiopia_ESS_LSMS_ISA_W3_hh_crop_production.dta
									Ethiopia_ESS_LSMS_ISA_W3_crop_production_parcel.dta
									Ethiopia_ESS_LSMS_ISA_W3_crop_losses.dta
*LAND RENTAL RATES					Ethiopia_ESS_LSMS_ISA_W3_hh_rental_parcel.dta					
									Ethiopia_ESS_LSMS_ISA_W3_hh_rental_rate.dta
*LAND VALUE - RENTED LAND			Ethiopia_ESS_LSMS_ISA_W3_hh_rental_value.dta						
*VALUE OF AREA PLANTED				Ethiopia_ESS_LSMS_ISA_W3_hh_cost_land.dta

*USE OF IMPROVED SEED				Ethiopia_ESS_LSMS_ISA_W3_hh_imprv_seed.dta						
*COST OF SEEDS						Ethiopia_ESS_LSMS_ISA_W3_hh_cost_seed.dta
*USE OF EXTENSION					Ethiopia_ESS_LSMS_ISA_W3_ext_reach.dta
*LIVESTOCK OWNERSHIP				Ethiopia_ESS_LSMS_ISA_W3_livestock_sales.dta
*LIVESTOCK EXPENSES					Ethiopia_ESS_LSMS_ISA_W3_livestock_expenses.dta
*LIVESTOCK VACCINATION				Ethiopia_ESS_LSMS_ISA_W3_livestock_vaccination.dta
*LIVESTOCK EARNINGS AND PRODUCTION	Ethiopia_ESS_LSMS_ISA_W3_livestock_products.dta
*WAGE INCOME						Ethiopia_ESS_LSMS_ISA_W3_wage_income.dta
*DIETARY DIVERSITY					Ethiopia_ESS_LSMS_ISA_W3_household_diet.dta
*USE OF FINANCIAL SERVICES			Ethiopia_ESS_LSMS_ISA_W3_fin_serv.dta			
*SELF-EMPLOYMENT INCOME				Ethiopia_ESS_LSMS_ISA_W3_self_employment_income.dta
*OTHER INCOME						Ethiopia_ESS_LSMS_ISA_W3_other_income.dta
*ASSISTANCE INCOME					Ethiopia_ESS_LSMS_ISA_W3_assistance_income.dta
*WOMEN'S AG DECISION-MAKING			Ethiopia_ESS_LSMS_ISA_W3_ag_decision.dta
*WOMEN'S CONTROL OVER INCOME		Ethiopia_ESS_LSMS_ISA_W3_control_income.dta
*WOMEN'S OWNERSHIP OF ASSETS		Ethiopia_ESS_LSMS_ISA_W3_women_otherasset_owner.dta
*YIELDS								Ethiopia_ESS_LSMS_ISA_W3_crop_ALL.dta
									Ethiopia_ESS_LSMS_ISA_W3_yield_hh_crop_level	.dta						
*FINAL FILES						MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD-LEVEL VARIABLES			Ethiopia_ESS_LSMS_ISA_W3_household_variables.dta
*FIELD-LEVEL VARIABLES				Ethiopia_ESS_LSMS_ISA_W3_field_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			Ethiopia_ESS_LSMS_ISA_W3_individual_variables.dta	
*SUMMARY STATISTICS					Ethiopia_ESS_LSMS_ISA_W3_summary_stats.xlsx

*/


clear
set more off 

//Set directories
*These paths indicate where the raw data files are located and where the created data and final data will be stored.
global raw_data 			"Raw DTA files\Wave 3 (2015-16)"
global created_data			"Final DTA files\Wave 3 (2015-16)\created_data"
global final_data			"Final DTA files\Wave 3 (2015-16)"



******************
*IDENTIFYING WHETHER HOUSEHOLDS WERE INTERVIEWED POST-PLANTING AND POST-HARVEST
******************
*Interviewed post-planting
use "$raw_data/Post-Planting/sect_cover_pp_w3.dta", clear
keep household_id2
duplicates drop
gen interview_pping = 1
lab var interview_pping "1= HH was interviewed post-planting"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_pp_interview.dta", replace

*Interviewed post-harvest
use "$raw_data/Post-Harvest/sect_cover_ph_w3.dta", clear
keep household_id2
duplicates drop
gen interview_postharvest = 1
lab var interview_postharvest "1= HH was interviewed post-harvest"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_ph_interview.dta", replace



******************
*HOUSEHOLD IDS
******************
use "$raw_data/Household/sect_cover_hh_w3.dta", clear
rename saq01 region
rename saq02 zone
rename saq03 woreda
rename saq04 town
rename saq05 subcity
rename saq06 kebele
rename saq07 ea
rename saq08 household
rename pw_w3 weight
rename rural rural2
gen rural = (rural2==1)
lab var rural "1=Rural"
keep region zone woreda town subcity kebele ea household rural household_id2 weight
*Just a few cases where households are not uniquely identified by region zone woreda kebele ea household
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hhids.dta", replace


******************
*WEIGHTS AND GENDER OF HEAD
******************
use "$raw_data/Household/sect1_hh_w3.dta", clear
gen fhh = hh_s1q03==2 if hh_s1q02==1		// assuming missing is male - 1 if hh_s1q03==2 and 0 otherwise

*We need to change the strata based on sampling methodology (see BID for more information)
gen clusterid = ea_id2
gen strataid=saq01 if rural==1 //assign region as strataid to rural respondents; regions from from 1 to 7 and then 12 to 15
gen stratum_id=.
replace stratum_id=16 if rural==2 & saq01==1 //Tigray, small town
replace stratum_id=17 if rural==2 & saq01==3 //Amhara, small town
replace stratum_id=18 if rural==2 & saq01==4 //Oromiya, small town
replace stratum_id=19 if rural==2 & saq01==7 //SNNP, small town
replace stratum_id=20 if rural==2 & (saq01==2 | saq01==5 | saq01==6 | saq01==12 | saq01==13 | saq01==15) //Other regions, small town
replace stratum_id=21 if rural==3 & saq01==1 //Tigray, large town
replace stratum_id=22 if rural==3 & saq01==3 //Amhara, large town
replace stratum_id=23 if rural==3 & saq01==4 //Oromiya, large town
replace stratum_id=24 if rural==3 & saq01==7 //SNNP, large town
replace stratum_id=25 if rural==3 & saq01==14 //Addis Ababa, large town
replace stratum_id=26 if rural==3 & (saq01==2 | saq01==5 | saq01==6 | saq01==12 | saq01==13 | saq01==15) //Other regions, large town
replace strataid=stratum_id if rural!=1 //assign new strata IDs to urban respondents, stratified by region and small or large towns

gen hh_members = 1
collapse (max) fhh (firstnm) pw_w3 clusterid strataid (sum) hh_members, by(household_id2)
lab var hh_members "Number of household members"
lab var fhh "1=Female-headed household"
lab var strataid "Strata ID (updated) for svyset"
lab var clusterid "Cluster ID for svyset"
lab var pw_w3 "Household weight"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_male_head.dta", replace


******************
*INDIVIDUAL GENDER
******************
*Using gender from planting and harvesting
use "$raw_data/Post-Harvest/sect1_ph_w3.dta", clear
gen personid = ph_s1q00
gen female =ph_s1q03==2	// NOTE: Assuming missings are MALE

*dropping duplicates (data is at holder level so some individuals are listed multiple times, we only need one record for each)
duplicates drop household_id2 personid, force
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_gender_merge_ph.dta", replace		// only PH

*Harvest
use "$raw_data/Post-Planting/sect1_pp_w3.dta", clear
ren pp_s1q00 personid
gen female =pp_s1q03==2	// NOTE: Assuming missings are MALE

duplicates drop household_id2 personid, force
merge 1:1 household_id2 personid using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_gender_merge_ph.dta", nogen 		// keeping ALL
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_gender_merge_both.dta", replace


*******************
*PLOT DECISION-MAKERS
*******************
*Gender/age variables
use "$raw_data/Post-Planting/sect3_pp_w3.dta", clear
gen cultivated = pp_s3q03==1			// if plot was cultivated

*First owner/decision maker
gen personid = pp_s3q10a
merge m:1 household_id2 personid using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_gender_merge_both.dta", gen(dm1_merge) keep(1 3)			// Dropping unmatched from using
*10,057 not matched from master
*23,248 matched
tab dm1_merge cultivate		// Almost all unmatched observations are due to field not being cultivated
*First decision-maker variables
gen dm1_female = female
drop female personid

*Second owner/dec
gen personid = pp_s3q10c_a
merge m:1 household_id2 personid using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_gender_merge_both.dta", gen(dm2_merge) keep(1 3)			// Dropping unmatched from using
*17,293 not matched from master
*16,012 matched
gen dm2_female = female
drop female personid

*Third
gen personid = pp_s3q10c_b
merge m:1 household_id2 personid using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_gender_merge_both.dta", gen(dm3_merge) keep(1 3)			// Dropping unmatched from using
*29,644 not matched from master
*3,661 matched
gen dm3_female = female
drop female personid

*Constructing three-part gendered decision-maker variable; male only (=1) female only (=2) or mixed (=3)
gen dm_gender = 1 if (dm1_female==0 | dm1_female==.) & (dm2_female==0 | dm2_female==.) & (dm3_female==0 | dm3_female==.) & !(dm1_female==. & dm2_female==. & dm3_female==.)
replace dm_gender = 2 if (dm1_female==1 | dm1_female==.) & (dm2_female==1 | dm2_female==.) & (dm3_female==1 | dm3_female==.) & !(dm1_female==. & dm2_female==. & dm3_female==.)
replace dm_gender = 3 if dm_gender==. & !(dm1_female==. & dm2_female==. & dm3_female==.)
la def dm_gender 1 "Male only" 2 "Female only" 3 "Mixed gender"
la val dm_gender dm_gender
lab var dm_gender "Gender of decision-maker(s)"
keep dm_gender holder_id household_id2 field_id parcel_id
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_field_gender_dm.dta", replace


*******************
* ALL AREA CONSTRUCTION
*******************
use "$raw_data/Post-Planting/sect3_pp_w3.dta", clear
gen cultivated = pp_s3q03==1			// if plot was cultivated
*Generating some conversioon factors
gen area = pp_s3q02_a 
gen local_unit = pp_s3q02_c
gen area_sqmeters_gps = pp_s3q05_a
replace area_sqmeters_gps = . if area_sqmeters_gps<0
*The following individual files are used to create geographic aggregates for non-standard units
preserve
	keep household_id2 parcel_id field_id area local_unit area_sqmeters_gps
	merge m:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hhids.dta"
	drop if _merge==2
	drop _merge
	gen sqmeters_per_unit = area_sqmeters_gps/area
	gen observations = 1
	collapse (median) sqmeters_per_unit (count) observations [aw=weight], by (region zone local_unit)
	rename sqmeters_per_unit sqmeters_per_unit_zone 
	rename observations obs_zone
	lab var sqmeters_per_unit_zone "Square meters per local unit (median value for this region and zone)"
	save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_area_lookup_zone.dta", replace
restore
preserve
	replace area_sqmeters_gps=. if area_sqmeters_gps<0
	keep household_id2 parcel_id field_id area local_unit area_sqmeters_gps
	merge m:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hhids.dta"
	drop if _merge==2
	drop _merge
	gen sqmeters_per_unit = area_sqmeters_gps/area
	gen observations = 1
	collapse (median) sqmeters_per_unit (count) observations [aw=weight], by (region local_unit)
	rename sqmeters_per_unit sqmeters_per_unit_region
	rename observations obs_region
	lab var sqmeters_per_unit_region "Square meters per local unit (median value for this region)"
	save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_area_lookup_region.dta", replace
restore
preserve
	replace area_sqmeters_gps=. if area_sqmeters_gps<0
	keep household_id2 parcel_id field_id area local_unit area_sqmeters_gps
	merge m:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hhids.dta"
	drop if _merge==2
	drop _merge
	gen sqmeters_per_unit = area_sqmeters_gps/area
	gen observations = 1
	collapse (median) sqmeters_per_unit (count) observations [aw=weight], by (local_unit)
	rename sqmeters_per_unit sqmeters_per_unit_country
	rename observations obs_country
	lab var sqmeters_per_unit_country "Square meters per local unit (median value for the country)"
	save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_area_lookup_country.dta", replace
restore

*Now creating area - starting with sq meters
gen area_meas_hectares = pp_s3q02_a*10000 if pp_s3q02_c==1			// hectares to sq m
replace area_meas_hectares = pp_s3q02_a if pp_s3q02_c==2			// already in sq m

*For rest of units, we need to use the conversion factors
gen region = saq01
gen zone = saq02
gen woreda = saq03
merge m:1 region zone woreda local_unit using "$raw_data/Land Area Conversion Factor/ET_local_area_unit_conversion.dta", gen(conversion_merge) keep(1 3)	// 66 not matched from using, dropped
*20,826 not matched from master
*12,479 matched
replace area_meas_hectares = pp_s3q02_a*conversion if !inlist(pp_s3q02_c,1,2) & pp_s3q02_c!=.			// non-traditional units

*Field area is currently farmer reported. Let's replace with GPS area when available
replace area_meas_hectares = pp_s3q05_a if pp_s3q05_a!=. & pp_s3q05_a>0			// 32,205 changes
replace area_meas_hectares = area_meas_hectares*0.0001						// Changing back into hectares

*Using our own created conversion factors for still missings observations
merge m:1 region zone local_unit using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_area_lookup_zone.dta", nogen
replace area_meas_hectares = (area*(sqmeters_per_unit_zone/10000)) if local_unit!=11 & area_meas_hectares==. & obs_zone>=10
merge m:1 region local_unit using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_area_lookup_region.dta", nogen
replace area_meas_hectares = (area*(sqmeters_per_unit_region/10000)) if local_unit!=11 & area_meas_hectares==. & obs_region>=10
merge m:1 local_unit using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_area_lookup_country.dta", nogen
replace area_meas_hectares = (area*(sqmeters_per_unit_country/10000)) if local_unit!=11 & area_meas_hectares==.

count if area!=. & area_meas_hectares==.
*tab local_unit if area!=. & area_meas_hectares==.
*56, They are all "other" category. These cannot be imputed regardless. We'll assume they are small and give them a value of zero.
replace area_meas_hectares = 0 if area_meas_hectares == .
lab var area_meas_hectares "Field area measured in hectares, with missing obs imputed using local median per-unit values"

merge 1:1 holder_id parcel_id field_id using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_field_gender_dm.dta", nogen
gen area_meas_hectares_male = area_meas_hectares if dm_gender==1
gen area_meas_hectares_female = area_meas_hectares if dm_gender==2
gen area_meas_hectares_mixed = area_meas_hectares if dm_gender==3

*Constructing areas at different levels (field, parcel, and household)
preserve
	*************
	* FIELD AREA (no collapse)
	*************
	keep household_id2 holder_id parcel_id field_id area_meas_hectares
	save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_field_area.dta", replace
	*************
	* PARCEL AREA (collapse to holder/parcel)
	*************
	collapse (sum) land_size = area_meas_hectares, by(household_id2 holder_id parcel_id)
	lab var land_size "Parcel area measured in hectares, with missing obs imputed using local median per-unit values"
	save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_parcel_area.dta", replace
	*************
	* HOUSEHOLD AREA (collapse to household)
	*************
	collapse (sum) area_meas_hectares_hh = land_size, by(household_id2)
	lab var area_meas_hectares_hh "Total area measured in hectares, with missing obs imputed using local median per-unit values"
	save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_household_area.dta", replace
restore
*************
* CULTIVATED (HH) AREA (keep if cultivated and collapse to household)
*************
preserve
	keep if cultivated==1
	collapse (sum) farm_area = area_meas_hectares farm_area_male = area_meas_hectares_male farm_area_female = area_meas_hectares_female farm_area_mixed = area_meas_hectares_mixed, by (household_id2)
	lab var farm_area "Land size, all cultivated plots (denominator for land productivitiy), in hectares" /* Uses measures */
	save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_farm_area.dta", replace
restore
**************
* AGRICULTURAL LAND DUMMY AND AREA (keep if "ag land" and save at field level)
**************
preserve
	gen agland = (pp_s3q03==1 | pp_s3q03==2 | pp_s3q03==3 | pp_s3q03==5) // Cultivated, prepared for Belg season, pasture, or fallow. Excludes forest and "other" (which seems to include rented-out)
	keep if agland==1
	keep household_id2 parcel_id field_id holder_id agland area_meas_hectares
	rename area_meas_hectares farm_size_agland_field
	lab var farm_size_agland "Field size in hectares, including all plots cultivated, fallow, or pastureland"
	lab var agland "1= Plot was used for cultivated, pasture, or fallow"
	save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_fields_agland.dta", replace
	***************
	*AG LAND AREA HOUSEHOLD (collapse "ag land" to household level)
	***************
	collapse (sum) farm_size_agland = farm_size_agland_field, by (household_id2)
	lab var farm_size_agland "Total land size in hectares, including all plots cultivated, fallow, or pastureland"
	save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_farmsize_all_agland.dta", replace
restore


****************
* FERTILIZER APPLICATION (KG)
****************
use "$raw_data/Post-Planting/sect3_pp_w3.dta", clear
*Merging in gender
merge m:1 holder_id parcel_id field_id using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_field_gender_dm.dta", nogen

*For fertilizer 
egen fert_inorg_kg = rowtotal(pp_s3q16 pp_s3q19 pp_s3q20a_2 pp_s3q20a_7)		// all are already in kg (Urea, DAP, NPS, other)
gen fert_inorg_kg_male = fert_inorg_kg if dm_gender==1
gen fert_inorg_kg_female = fert_inorg_kg if dm_gender==2
gen fert_inorg_kg_mixed = fert_inorg_kg if dm_gender==3

gen use_inorg_fert = 0
replace use_inorg_fert = 1 if pp_s3q15==1 | pp_s3q18==1 | pp_s3q20a_1==1 | pp_s3q20a==1
replace use_inorg_fert = 0 if (pp_s3q14==2 | pp_s3q15==2) & pp_s3q18==2 & pp_s3q20a_1==2 & pp_s3q20a==2
replace use_inorg_fert = . if pp_s3q14==1 & pp_s3q15==. & pp_s3q18==. & pp_s3q20a_1==. & pp_s3q20a==.

recode fert_inorg_kg* (.=0)
collapse (sum) fert_inorg_kg* (max) use_inorg_fert, by(household_id2)
lab var fert_inorg_kg "Inorganic fertilizer (kgs) for all plots"
lab var fert_inorg_kg_male "Inorganic fertilizer (kgs) for male-managed plots"
lab var fert_inorg_kg_female "Inorganic fertilizer (kgs) for female-managed plots"
lab var fert_inorg_kg_mixed "Inorganic fertilizer (kgs) for mixed-managed plots"
lab var use_inorg_fert "Household uses any inorganic fertilizer"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_fert.dta", replace


*********************
* POST-PLANTING EXPENSES - EXPLICIT AND IMPLICIT
*********************
use "$raw_data/Post-Planting/sect3_pp_w3.dta", clear

*Fertilizer expenses (EXPLICIT)
rename pp_s3q16d value_urea
rename pp_s3q19d value_DAP
rename pp_s3q20a_5 value_NPS
rename pp_s3q20c value_other_chemicals
egen value_fert = rowtotal(value_urea value_DAP value_NPS value_other_chemicals)

*Hired Labor
rename pp_s3q28_a number_men
rename pp_s3q28_b number_days_men
rename pp_s3q28_c wage_perday_men
rename pp_s3q28_d number_women
rename pp_s3q28_e number_days_women
rename pp_s3q28_f wage_perday_women
rename pp_s3q28_g number_children
rename pp_s3q28_h number_days_children
rename pp_s3q28_i wage_perday_children

gen wage_male = wage_perday_men/number_men				// wage per day for a single man
gen wage_female = wage_perday_women/number_women		// wage per day for a single woman
gen wage_child = wage_perday_child/number_children					// wage per day for a single child
recode wage_male wage_female wage_child (0=.)		// if they are "hired" but don't get paid, we don't want to consider that a wage observation below

*Getting household-level wage rate by taking a simple mean across crops and activities
preserve
	recode wage_male number_days_men wage_female number_days_women (.=0) // set missing to zero to count observation with no male hired labor or with no female hired labor
	gen all_wage = (wage_male*number_days_men + wage_female*number_days_women)/(number_days_men + number_days_women)	// weighted average at the HOUSEHOLD level
	* re-set 0 to missing
	recode wage_male number_days_men wage_female number_days_women (0=.) 
	* get average wage accross all plots and crops to obtain wage at household level by  activities
	collapse (mean) wage_male wage_female all_wage,by(rural saq01 saq02 saq03 saq04 saq05 household_id2)
	count // nb obs reduced to 3,643
	** group activities
	gen  labor_group=1  //"pre-planting + planting + other non-harvesting"
	lab var all_wage "Daily agricultural wage (local currency)"
	lab var wage_male "Daily male agricultural wage (local currency)"
	lab var wage_female "Daily female agricultural wage (local currency)"
	save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_eth_labor_group1", replace
restore

*Geographic medians of wages
foreach i in male female child{			// constructing for male, female, and child separately
	*By EA
	bys saq01 saq02 saq03 saq04 saq05: egen `i'_count_ea = count(wage_`i')		// ea
	bys saq01 saq02 saq03 saq04 saq05: egen `i'_price_ea = median(wage_`i')
	*By kebele
	bys saq01 saq02 saq03 saq04: egen `i'_count_keb = count(wage_`i')			// kebele
	bys saq01 saq02 saq03 saq04: egen `i'_price_keb = median(wage_`i')
	*By woreda
	bys saq01 saq02 saq03: egen `i'_count_wor = count(wage_`i')					// woreda
	bys saq01 saq02 saq03: egen `i'_price_wor = median(wage_`i')
	*By zone
	bys saq01 saq02: egen `i'_count_zone = count(wage_`i')						// zoner
	bys saq01 saq02: egen `i'_price_zone = median(wage_`i')
	*By region
	bys saq01: egen `i'_count_reg = count(wage_`i')								// region
	bys saq01: egen `i'_price_reg = median(wage_`i')
	*National
	egen `i'_price_nat = median(wage_`i')
	
	*Generating wage
	gen `i'_wage_rate = `i'_price_ea if `i'_count_ea>=10			// by counstruction, there are no missing counts
	replace `i'_wage_rate = `i'_price_keb if `i'_count_keb>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_price_wor if `i'_count_wor>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_price_zone if `i'_count_zone>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_price_reg if `i'_count_reg>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_price_nat if `i'_wage_rate==.
}

*Value of hired labor (EXPLICIT)
gen value_male_hired = wage_perday_men*number_days_men			// average wage times number of days
gen value_female_hired = wage_perday_women*number_days_women
gen value_child_hired = wage_perday_children*number_days_children

*Days of hired labor
gen days_men = number_men * number_days_men 
gen days_women = number_women * number_days_women  
gen days_children = number_children * number_days_children 
egen days_hired_pp =  rowtotal(days_men days_women days_children)

*Value of family labor (IMPLICIT)
preserve
	*To do family labor, we first need to merge in individual gender
	use "$raw_data/Post-Planting/sect1_pp_w3.dta", clear
	ren pp_s1q00 pid
	drop if pid==.
	isid holder_id pid				// check 
	ren pp_s1q02 age
	gen male = pp_s1q03==1
	keep holder_id pid age male
	tempfile members
	save `members', replace			// will use this temp file to merge in genders (and ages)
restore
*Starting with "member 1"
gen pid = pp_s3q27_a				// PID for member 1
merge m:1 holder_id pid using `members', gen(fam_merge1) keep(1 3)		// many not matched from master 
tab pp_s3q27_a fam_merge1, m		// most are due to household id=0 or missing in MASTER (0 means nobody engaged)
count if fam_merge1==1 & pp_s3q27_c!=. & pp_s3q27_c!=0		// just 30 observations
ren male male1		// renaming in order to merge again
ren pid pid1 
ren age age1
*Now "member 2"
gen pid = pp_s3q27_e				// PID for member 2
merge m:1 holder_id pid using `members', gen(fam_merge2) keep(1 3)		// many not matched from master 
ren male male2		// renaming in order to merge again
ren pid pid12
ren age age2
*Now "member 3"
gen pid = pp_s3q27_i				// PID for member 3
merge m:1 holder_id pid using `members', gen(fam_merge3) keep(1 3)		// many not matched from master 
ren male male3		// renaming in order to merge again
ren pid pid13
ren age age3
*Now "member 4"
gen pid = pp_s3q27_m				// PID for member 4
merge m:1 holder_id pid using `members', gen(fam_merge4) keep(1 3)		// many not matched from master 
ren male male4		// renaming in order to merge again
ren pid pid14
ren age age4

recode male1 male2 male3 male4 (.=1)			// NOTE: Assuming male if missing (there are a couple dozen)
gen male_fam_days1 = pp_s3q27_b*pp_s3q27_c if male1 & age1>=15		// if male and older than 15 or age is missing; NOTE: Assuming missing ages are adults
gen male_fam_days2 = pp_s3q27_f*pp_s3q27_g if male2 & age2>=15
gen male_fam_days3 = pp_s3q27_j*pp_s3q27_k if male3 & age3>=15
gen male_fam_days4 = pp_s3q27_n*pp_s3q27_o if male4 & age4>=15
gen female_fam_days1 = pp_s3q27_b*pp_s3q27_c if !male1 & age1>=15	//  NOTE: Assuming missing ages are adults
gen female_fam_days2 = pp_s3q27_f*pp_s3q27_g if !male2 & age2>=15
gen female_fam_days3 = pp_s3q27_j*pp_s3q27_k if !male3 & age3>=15
gen female_fam_days4 = pp_s3q27_n*pp_s3q27_o if !male4 & age4>=15
gen child_fam_days1 = pp_s3q27_b*pp_s3q27_c if age1<15
gen child_fam_days2 = pp_s3q27_f*pp_s3q27_g if age2<15
gen child_fam_days3 = pp_s3q27_j*pp_s3q27_k if age3<15
gen child_fam_days4 = pp_s3q27_n*pp_s3q27_o if age4<15

egen total_male_fam_days = rowtotal(male_fam_days*)				// total male family days
egen total_female_fam_days = rowtotal(female_fam_days*)
egen total_child_fam_days = rowtotal(child_fam_days*)

*"Free" labor days (IMPLICIT)
recode pp_s3q29* (.=0)
gen total_male_free_days = pp_s3q29_a*pp_s3q29_b
gen total_female_free_days = pp_s3q29_c*pp_s3q29_d
gen total_child_free_days = pp_s3q29_e*pp_s3q29_f

*Here are the total non-hired days (family plus free)
egen total_male_nonhired_days = rowtotal(total_male_fam_days total_male_free_days)		// family days plus "free" labor
egen total_female_nonhired_days = rowtotal(total_female_fam_days total_female_free_days)
egen total_child_nonhired_days = rowtotal(total_child_fam_days total_child_free_days)
egen days_nonhired_pp = rowtotal(total_male_nonhired_days total_female_nonhired_days total_child_nonhired_days)	// total days

*And here are the total costs using geographically constructed wage rates
gen value_male_nonhired = total_male_nonhired_days*male_wage_rate
gen value_female_nonhired = total_female_nonhired_days*female_wage_rate
gen value_child_nonhired = total_child_nonhired_days*child_wage_rate

*Replacing with own wage rate where available
*First, getting wage at the HOUSEHOLD level
bys household_id2: egen male_wage_tot = total(value_male_hired)	// total paid to all male workers at the household level (original question at the holder/field level)
bys household_id2: egen male_days_tot = total(number_days_men)		// total DAYS of male workers
bys household_id2: egen female_wage_tot = total(value_female_hired)		// total paid to all female workers
bys household_id2: egen female_days_tot = total(number_days_women)				// total DAYS of female workers
bys household_id2: egen child_wage_tot = total(value_child_hired)		// total paid to all child workers
bys household_id2: egen child_days_tot = total(number_days_children)				// total DAYS of child workers
gen wage_male_hh = male_wage_tot/male_days_tot					// total paid divided by total days at the household level
gen wage_female_hh = female_wage_tot/female_days_tot			// total paid divided by total days
gen wage_child_hh = child_wage_tot/child_days_tot				// total paid divided by total days
recode wage_*_hh (0=.)											// don't want to use the zeros
sum wage_*_hh			// no zeros
*Now, replacing when household-level wage not missing
replace value_male_nonhired = total_male_nonhired_days*wage_male_hh if wage_male_hh!=.
replace value_female_nonhired = total_female_nonhired_days*wage_female_hh if wage_female_hh!=.
replace value_child_nonhired = total_child_nonhired_days*wage_child_hh if wage_child_hh!=.

egen value_hired_prep_labor = rowtotal(value_male_hired value_female_hired value_child_hired)
egen value_fam_prep_labor = rowtotal(value_male_nonhired value_female_nonhired value_child_nonhired)

*******************************
* Generating gender variables *
*******************************
*Merging in gender
merge m:1 holder_id parcel_id field_id using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_field_gender_dm.dta", nogen
*Fertilizer value
gen value_fert_male = value_fert if dm_gender==1
gen value_fert_female = value_fert if dm_gender==2
gen value_fert_mixed = value_fert if dm_gender==3
*Hired labor
gen value_hired_prep_labor_male = value_hired_prep_labor if dm_gender==1
gen value_hired_prep_labor_female = value_hired_prep_labor if dm_gender==2
gen value_hired_prep_labor_mixed = value_hired_prep_labor if dm_gender==3
gen days_hired_pp_male = days_hired_pp if dm_gender==1
gen days_hired_pp_female = days_hired_pp if dm_gender==2
gen days_hired_pp_mixed = days_hired_pp if dm_gender==3
*Fam labor
gen value_fam_prep_labor_male = value_fam_prep_labor if dm_gender==1
gen value_fam_prep_labor_female = value_fam_prep_labor if dm_gender==2
gen value_fam_prep_labor_mixed = value_fam_prep_labor if dm_gender==3
gen days_nonhired_pp_male = days_nonhired_pp if dm_gender==1
gen days_nonhired_pp_female = days_nonhired_pp if dm_gender==2
gen days_nonhired_pp_mixed = days_nonhired_pp if dm_gender==3

*Collapsing to household-level input costs (explicit - value hired prep labor and value fert; implicit - value fam prep labor)
collapse (sum) value_hired* value_fam* value_fert* days_hired_pp* days_nonhired*, by(household_id2)
lab var value_hired_prep_labor "Wages paid for hired labor (crops), as captured in post-planting survey"
sum value_*
lab var value_hired_prep_labor "Value of all pre-harvest hired labor used on the farm"
lab var value_hired_prep_labor_male "Value of all pre-harvest hired labor used on male-managed plots"
lab var value_hired_prep_labor_female "Value of all pre-harvest hired labor used on female-managed plots"
lab var value_hired_prep_labor_mixed "Value of all pre-harvest hired labor used on mixed-managed plots"
lab var value_fam_prep_labor "Value of all pre-harvest non-hired labor used on the farm"
lab var value_fam_prep_labor_male "Value of all pre-harvest non-hired labor used on male-managed plots"
lab var value_fam_prep_labor_female "Value of all pre-harvest non-hired labor used on female-managed plots"
lab var value_fam_prep_labor_mixed "Value of all pre-harvest non-hired labor used on mixed-managed plots"
lab var value_fert "Value of all fertilizer used on the farm"
lab var value_fert_male "Value of all fertilizer used on male-managed plots"
lab var value_fert_female "Value of all fertilizer used on female-managed plots"
lab var value_fert_mixed "Value of all fertilizer used on mixed-managed plots"
lab var days_hired_pp "Days of pre-harvest hired labor used on farm"
lab var days_hired_pp_male "Days of pre-harvest hired labor used on male_managed-plots"
lab var days_hired_pp_female "Days of pre-harvest hired labor used on female_managed-plots"
lab var days_hired_pp_mixed "Days of pre-harvest hired labor used on mixed_managed-plots"
lab var days_nonhired_pp "Days of pre-harvest non-hired labor used on farm"
lab var days_nonhired_pp_male "Days of pre-harvest non-hired labor used on male_managed-plots"
lab var days_nonhired_pp_female "Days of pre-harvest non-hired labor used on female_managed-plots"
lab var days_nonhired_pp_mixed "Days of pre-harvest non-hired labor used on mixed_managed-plots"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_pp_inputs_value.dta", replace


************
* HARVEST LABOR COSTS
************
use "$raw_data/Post-Harvest/sect10_ph_w3.dta", clear		// START HERE (harvest labor)

*Hired labor (EXPLICIT)
rename ph_s10q01_a number_men
rename ph_s10q01_b number_days_men
rename ph_s10q01_c wage_perday_men
rename ph_s10q01_d number_women
rename ph_s10q01_e number_days_women
rename ph_s10q01_f wage_perday_women
rename ph_s10q01_g number_children
rename ph_s10q01_h number_days_children
rename ph_s10q01_i wage_perday_children

gen wage_male = wage_perday_men/number_men				// wage per day for a single man
gen wage_female = wage_perday_women/number_women		// wage per day for a single woman
gen wage_child = wage_perday_child/number_children					// wage per day for a single child
recode wage_male wage_female wage_child (0=.)		// if they are "hired" but don't get paid, we don't want to consider that a wage observation below

preserve
	recode wage_male number_days_men wage_female number_days_women (.=0) // set missing to zero to count observation with no male hired labor or with no female hired labor
	gen all_wage=(wage_male*number_days_men + wage_female*number_days_women)/(number_days_men + number_days_women)
	* re-set 0 to missing
	recode wage_male number_days_men wage_female number_days_women (0=.) 
	* get average wage accross all plots and crops to obtain wage at household level by  activities
	collapse (mean) wage_male wage_female all_wage, by(rural saq01 saq02 saq03 saq04 saq05 household_id2)
	count // nb obs reduced to 3,643
	** group activities
	gen  labor_group=2  //"pre-planting + planting + other non-harvesting"
	lab var all_wage "Daily agricultural wage (local currency)"
	save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_eth_labor_group2", replace
restore

gen value_male_hired = /*number_men **/ number_days_men * wage_perday_men
gen value_female_hired = /*number_women **/ number_days_women * wage_perday_women 
gen value_child_hired = /*number_children **/ number_days_children * wage_perday_children

gen days_men = number_men * number_days_men 
gen days_women = number_women * number_days_women  
gen days_children = number_children * number_days_children 
egen days_hired_harv =  rowtotal(days_men days_women days_children)

*Geographic medians
foreach i in male female child{
	*By EA
	bys saq01 saq02 saq03 saq04 saq05: egen `i'_count_ea = count(wage_`i')
	bys saq01 saq02 saq03 saq04 saq05: egen `i'_price_ea = median(wage_`i')
	*By kebele
	bys saq01 saq02 saq03 saq04: egen `i'_count_keb = count(wage_`i')
	bys saq01 saq02 saq03 saq04: egen `i'_price_keb = median(wage_`i')
	*By woreda
	bys saq01 saq02 saq03: egen `i'_count_wor = count(wage_`i')
	bys saq01 saq02 saq03: egen `i'_price_wor = median(wage_`i')
	*By zone
	bys saq01 saq02: egen `i'_count_zone = count(wage_`i')
	bys saq01 saq02: egen `i'_price_zone = median(wage_`i')
	*By region
	bys saq01: egen `i'_count_reg = count(wage_`i')
	bys saq01: egen `i'_price_reg = median(wage_`i')
	*National
	egen `i'_price_nat = median(wage_`i')
	
	*Generating wage
	gen `i'_wage_rate = `i'_price_ea if `i'_count_ea>=10
	replace `i'_wage_rate = `i'_price_keb if `i'_count_keb>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_price_wor if `i'_count_wor>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_price_zone if `i'_count_zone>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_price_reg if `i'_count_reg>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_price_nat if `i'_wage_rate==.
}

*To do family labor, we first need to merge in individual gender
preserve
	use "$raw_data/Post-Harvest/sect1_ph_w3.dta", clear
	ren ph_s1q00 pid
	drop if pid==.
	isid holder_id pid				// check 
	ren ph_s1q02 age
	gen male = ph_s1q03==1
	keep holder_id pid age male
	tempfile members
	save `members', replace
restore
*Starting with "member 1"
gen pid = ph_s10q02_a
merge m:1 holder_id pid using `members', gen(fam_merge1) keep(1 3)		// many not matched from master 
tab ph_s10q02_a fam_merge1, m		// most are due to household id=0 or missing in MASTER (0 means nobody engaged)
count if fam_merge==1 & ph_s10q02_c!=0 & ph_s10q02_c!=.			// just 17 observations with positive days that were not merged. NOTE: Want to assume these are males? females?
ren male male1
ren pid pid1 
ren age age1
*Now "member 2"
gen pid = ph_s10q02_e
merge m:1 holder_id pid using `members', gen(fam_merge2) keep(1 3)		// many not matched from master 
ren male male2
ren pid pid12
ren age age2
*Now "member 3"
gen pid = ph_s10q02_i
merge m:1 holder_id pid using `members', gen(fam_merge3) keep(1 3)		// many not matched from master 
ren male male3
ren pid pid13
ren age age3
*Now "member 4"
gen pid = ph_s10q02_m
merge m:1 holder_id pid using `members', gen(fam_merge4) keep(1 3)		// many not matched from master 
ren male male4
ren pid pid14
ren age age4

*Family labor (IMPLICIT)
recode male1 male2 male3 male4 (.=1)			// NOTE: Assuming male if missing (there are only a couple in post-harvest)
gen male_fam_days1 = ph_s10q02_b*ph_s10q02_c if male1 & age1>=15		// NOTE: Assuming missing ages are adults
gen male_fam_days2 = ph_s10q02_f*ph_s10q02_g if male2 & age2>=15
gen male_fam_days3 = ph_s10q02_j*ph_s10q02_k if male3 & age3>=15
gen male_fam_days4 = ph_s10q02_n*ph_s10q02_o if male4 & age4>=15
gen female_fam_days1 = ph_s10q02_b*ph_s10q02_c if !male1 & age1>=15
gen female_fam_days2 = ph_s10q02_f*ph_s10q02_g if !male2 & age2>=15
gen female_fam_days3 = ph_s10q02_j*ph_s10q02_k if !male3 & age3>=15
gen female_fam_days4 = ph_s10q02_n*ph_s10q02_o if !male4 & age4>=15
gen child_fam_days1 = ph_s10q02_b*ph_s10q02_c if age1<15
gen child_fam_days2 = ph_s10q02_f*ph_s10q02_g if age2<15
gen child_fam_days3 = ph_s10q02_j*ph_s10q02_k if age3<15
gen child_fam_days4 = ph_s10q02_n*ph_s10q02_o if age4<15

egen total_male_fam_days = rowtotal(male_fam_days*)				// total male family days
egen total_female_fam_days = rowtotal(female_fam_days*)
egen total_child_fam_days = rowtotal(child_fam_days*)

*Also including "free" labor as priced (IMPLICIT)
recode ph_s10q03* (.=0)
gen total_male_free_days = ph_s10q03_a*ph_s10q03_b
gen total_female_free_days = ph_s10q03_c*ph_s10q03_d
gen total_child_free_days = ph_s10q03_e*ph_s10q03_f

*Here are the total days
egen total_male_nonhired_days = rowtotal(total_male_fam_days total_male_free_days)		// family days plus "free" labor
egen total_female_nonhired_days = rowtotal(total_female_fam_days total_female_free_days)
egen total_child_nonhired_days = rowtotal(total_child_fam_days total_child_free_days)
egen days_nonhired_harv = rowtotal(total_male_nonhired_days total_female_nonhired_days total_child_nonhired_days)	// total days

*And here are the total costs using geographically constructed wage rates
gen value_male_nonhired = total_male_nonhired_days*male_wage_rate
gen value_female_nonhired = total_female_nonhired_days*female_wage_rate
gen value_child_nonhired = total_child_nonhired_days*child_wage_rate

*Replacing with own wage rate where available
*First, creating household average wage
bys household_id2: egen male_wage_tot = total(value_male_hired)	// total paid to all male workers at the household level (original question at the holder/field level)
bys household_id2: egen male_days_tot = total(number_days_men)		// total DAYS of male workers
bys household_id2: egen female_wage_tot = total(value_female_hired)		// total paid to all female workers
bys household_id2: egen female_days_tot = total(number_days_women)				// total DAYS of female workers
bys household_id2: egen child_wage_tot = total(value_child_hired)		// total paid to all child workers
bys household_id2: egen child_days_tot = total(number_days_children)				// total DAYS of child workers
gen wage_male_hh = male_wage_tot/male_days_tot					// total paid divided by total days at the household level
gen wage_female_hh = female_wage_tot/female_days_tot			// total paid divided by total days
gen wage_child_hh = child_wage_tot/child_days_tot				// total paid divided by total days
recode wage_*_hh (0=.)											// don't want to use the zeros
sum wage_*_hh			// no zeros
*Now, replacing when not missing
replace value_male_nonhired = total_male_nonhired_days*wage_male_hh if wage_male_hh!=.
replace value_female_nonhired = total_female_nonhired_days*wage_female_hh if wage_female_hh!=.
replace value_child_nonhired = total_child_nonhired_days*wage_child_hh if wage_child_hh!=.

egen value_hired_harv_labor = rowtotal(value_male_hired value_female_hired value_child_hired)
egen value_fam_harv_labor = rowtotal(value_male_nonhired value_female_nonhired value_child_nonhired)		// note that "fam" labor includes free labor

*******************************
* Generating gender variables *
*******************************
*Merging in gender
merge m:1 holder_id parcel_id field_id using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_field_gender_dm.dta", nogen
gen value_hired_harv_labor_male = value_hired_harv_labor if dm_gender==1
gen value_hired_harv_labor_female = value_hired_harv_labor if dm_gender==2
gen value_hired_harv_labor_mixed = value_hired_harv_labor if dm_gender==3
gen days_hired_harv_male = days_hired_harv if dm_gender==1
gen days_hired_harv_female = days_hired_harv if dm_gender==2
gen days_hired_harv_mixed = days_hired_harv if dm_gender==3
gen value_fam_harv_labor_male = value_fam_harv_labor if dm_gender==1
gen value_fam_harv_labor_female = value_fam_harv_labor if dm_gender==2
gen value_fam_harv_labor_mixed = value_fam_harv_labor if dm_gender==3
gen days_nonhired_harv_male = days_nonhired_harv if dm_gender==1
gen days_nonhired_harv_female = days_nonhired_harv if dm_gender==2
gen days_nonhired_harv_mixed = days_nonhired_harv if dm_gender==3

collapse (sum) value_hired* days_hired* value_fam* days_nonhired*, by(household_id2)
sum value_*
lab var value_hired_harv_labor "Value of all harvest hired labor used on the farm"
lab var value_hired_harv_labor_male "Value of all harvest hired labor used on male-managed plots"
lab var value_hired_harv_labor_female "Value of all harvest hired labor used on female-managed plots"
lab var value_hired_harv_labor_mixed "Value of all harvest hired labor used on mixed-managed plots"
lab var value_fam_harv_labor "Value of all harvest non-hired labor used on the farm"
lab var value_fam_harv_labor_male "Value of all harvest non-hired labor used on male-managed plots"
lab var value_fam_harv_labor_female "Value of all harvest non-hired labor used on female-managed plots"
lab var value_fam_harv_labor_mixed "Value of all harvest non-hired labor used on mixed-managed plots"
lab var days_hired_harv "Days of harvest hired labor used on farm"
lab var days_hired_harv_male "Days of harvest hired labor used on male_managed-plots"
lab var days_hired_harv_female "Days of harvest hired labor used on female_managed-plots"
lab var days_hired_harv_mixed "Days of harvest hired labor used on mixed_managed-plots"
lab var days_nonhired_harv "Days of harvest non-hired labor used on farm"
lab var days_nonhired_harv_male "Days of harvest non-hired labor used on male_managed-plots"
lab var days_nonhired_harv_female "Days of harvest non-hired labor used on female_managed-plots"
lab var days_nonhired_harv_mixed "Days of harvest non-hired labor used on mixed_managed-plots"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_cost_harv_labor.dta", replace


****************
*AREA PLANTED
****************
use "$raw_data/Post-Planting/sect4_pp_w3.dta", clear
*Percent of area
gen pure_stand = pp_s4q02==1
gen any_pure = pure_stand==1
gen any_mixed = pure_stand==0
gen percent_field = pp_s4q03/100
replace percent_field = 1 if pure_stand==1

*Total area on field
bys holder_id parcel_id field_id: egen total_percent_field = total(percent_field)
*Rescale percent plated if percented planted on field is over 1
replace percent_field = percent_field/total_percent_field if total_percent_field>1			// 219 changes

*Merging in area
merge m:1 holder_id parcel_id field_id using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_field_area", nogen keep(1 3)	// dropping those only in using; 4 not matched from master
*Merging in gender
merge m:1 holder_id parcel_id field_id using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_field_gender_dm.dta", nogen keep(1 3)	// 4 not matched from master

*NOTE: we will create only ha_planted here, not value of land. We need to use ha_planted in the crop production do-file,
*but we needed the crop production data for value. Therefore, we construct area_planted and value separately
gen ha_planted = percent_field*area_meas_hectares
drop if ha_planted==0 | ha_planted==.

gen ha_planted_male = percent_field*area_meas_hectares if dm_gender==1
gen ha_planted_female = percent_field*area_meas_hectares if dm_gender==2
gen ha_planted_mixed = percent_field*area_meas_hectares if dm_gender==3
gen ha_planted_purestand = percent_field*area_meas_hectares if any_pure==1
gen ha_planted_mixedstand = percent_field*area_meas_hectares if any_mixed==1
gen ha_planted_male_pure = percent_field*area_meas_hectares if dm_gender==1 & any_pure==1
gen ha_planted_female_pure = percent_field*area_meas_hectares if dm_gender==2 & any_pure==1
gen ha_planted_mixed_pure = percent_field*area_meas_hectares if dm_gender==3 & any_pure==1
gen ha_planted_male_mixed = percent_field*area_meas_hectares if dm_gender==1 & any_mixed==1
gen ha_planted_female_mixed = percent_field*area_meas_hectares if dm_gender==2 & any_mixed==1
gen ha_planted_mixed_mixed = percent_field*area_meas_hectares if dm_gender==3 & any_mixed==1

drop crop_code
rename pp_s4q01_b crop_code
*Collapsing to holder-field-crop level
preserve
	collapse (sum) ha_planted* (firstnm) any_pure any_mixed, by(household_id2 holder_id parcel_id field_id crop_code)
	lab var ha_planted "Area of land that was cultivated (household)"
	lab var ha_planted_male "Area of land that was cultivated (male-managed)"
	lab var ha_planted_female "Area of land that was cultivated (female-managed)"
	lab var ha_planted_mixed "Area of land that was cultivated (mixed-managed)"
	lab var ha_planted_purestand "Area of land that was cultivated (pure stands)"
	lab var ha_planted_mixedstand "Area of land that was cultivated (mixed stands)"
	lab var ha_planted_male_pure "Area of land that was cultivated (male-managed pure stands)"
	lab var ha_planted_female_pure "Area of land that was cultivated (female-managed pure stands)"
	lab var ha_planted_mixed_pure "Area of land that was cultivated (mixed-managed pure stands)"
	lab var ha_planted_male_mixed "Area of land that was cultivated (male-managed mixed stands)"
	lab var ha_planted_female_mixed "Area of land that was cultivated (female-managed mixed stands)"
	lab var ha_planted_mixed_mixed "Area of land that was cultivated (mixed-managed mixed stands)"
	save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_holder_crop_area_land.dta", replace
restore

*Collapsing to household-crop level
preserve
	collapse (sum) ha_planted*, by(household_id2 crop_code)
	lab var ha_planted "Area of land that was cultivated (household)"
	lab var ha_planted_male "Area of land that was cultivated (male-managed)"
	lab var ha_planted_female "Area of land that was cultivated (female-managed)"
	lab var ha_planted_mixed "Area of land that was cultivated (mixed-managed)"
	lab var ha_planted_purestand "Area of land that was cultivated (pure stands)"
	lab var ha_planted_mixedstand "Area of land that was cultivated (mixed stands)"
	lab var ha_planted_male_pure "Area of land that was cultivated (male-managed pure stands)"
	lab var ha_planted_female_pure "Area of land that was cultivated (female-managed pure stands)"
	lab var ha_planted_mixed_pure "Area of land that was cultivated (mixed-managed pure stands)"
	lab var ha_planted_male_mixed "Area of land that was cultivated (male-managed mixed stands)"
	lab var ha_planted_female_mixed "Area of land that was cultivated (female-managed mixed stands)"
	lab var ha_planted_mixed_mixed "Area of land that was cultivated (mixed-managed mixed stands)"
	save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_crop_area_land.dta", replace
restore

collapse (sum) ha_planted*, by(household_id2)
lab var ha_planted "Area of land that was cultivated (household)"
lab var ha_planted_male "Area of land that was cultivated (male-managed)"
lab var ha_planted_female "Area of land that was cultivated (female-managed)"
lab var ha_planted_mixed "Area of land that was cultivated (mixed-managed)"
lab var ha_planted_purestand "Area of land that was cultivated (pure stands)"
lab var ha_planted_mixedstand "Area of land that was cultivated (mixed stands)"
lab var ha_planted_male_pure "Area of land that was cultivated (male-managed pure stands)"
lab var ha_planted_female_pure "Area of land that was cultivated (female-managed pure stands)"
lab var ha_planted_mixed_pure "Area of land that was cultivated (mixed-managed pure stands)"
lab var ha_planted_male_mixed "Area of land that was cultivated (male-managed mixed stands)"
lab var ha_planted_female_mixed "Area of land that was cultivated (female-managed mixed stands)"
lab var ha_planted_mixed_mixed "Area of land that was cultivated (mixed-managed mixed stands)"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_area_land.dta", replace


**********
*CONVERSION FACTORS
**********
*Before harvest, need to prepare the conversion factors
use "$raw_data/Food and Crop Conversion Factors/Crop_CF_Wave3.dta", clear
*Reshape to crop/unit/region level
ren mean_cf_nat mean_cf100
sort crop_code unit_cd mean_cf100
duplicates drop crop_code unit_cd, force

reshape long mean_cf, i(crop_code unit_cd) j(region)
recode region (99=5)
ren mean_cf conversion
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_cf.dta", replace


***********
*GROSS CROP REVENUE AND CROP LOST
************
*Crops excluding tree crops, vegetables, root crops
use "$raw_data/Post-Harvest/sect11_ph_w3.dta", clear
rename saq01 region
rename saq02 zone
rename saq03 woreda
rename saq04 kebele
rename saq05 ea
rename saq06 household
rename ph_s11q01 sell_yesno
rename ph_s11q03_a quantity_sold
rename ph_s11q03_b quantity_sold_unit
gen unit_cd = quantity_sold_unit
rename ph_s11q04 sales_value
rename ph_s11q22_e percent_sold
*This is for crop sales below
preserve
	keep if sell_yesno==1 
	*Need to standardize the units.
	save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_sales_1.dta", replace
restore

rename ph_s11q15_1 quantity_lost
rename ph_s11q15_2 quantity_lost_units /* We can't value this for now */
rename ph_s11q15_4 percent_lost
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_lost_1.dta", replace


*Tree crops, vegetables, root crops
use "$raw_data/Post-Harvest/sect12_ph_w3.dta", clear
rename saq01 region
rename saq02 zone
rename saq03 woreda
rename saq04 kebele
rename saq05 ea
rename saq06 household
rename ph_s12q06 sell_yesno
rename ph_s12q07 quantity_sold
rename ph_s12q0b quantity_sold_unit
gen unit_cd = quantity_sold_unit
rename ph_s12q08 sales_value
rename ph_s12q19_f percent_sold
preserve
	keep if sell_yesno==1 
	*Need to standardize the units.
	save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_sales_2.dta", replace
restore

rename ph_s12q12 share_lost
rename ph_s12q13 value_lost /* It's not clear why different types of crops were valued so differently. */
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_lost_2.dta", replace


*Appending one and two together
use "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_sales_1.dta", clear
append using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_sales_2.dta"
merge m:1 crop_code unit_cd using "$raw_data/Food and Crop Conversion Factors/Crop_CF_Wave3.dta" 
drop if _merge==2
gen kgs_sold = quantity_sold * mean_cf_nat /* Here, if conversion value is missing, this will be a missing observation in the imputed median price estimation. */

collapse (sum) kgs_sold sales_value (max) percent_sold, by (household_id2 crop_code) /* For duplicated obs, we'll take the maximum reported % sold. */
gen price_kg = sales_value / kgs_sold
lab var price_kg "Price received per kgs sold"
drop if price_kg==. | price_kg==0
keep household_id2 crop_code price_kg sales_value percent_sold
merge m:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hhids.dta"
drop if _merge==2
drop _merge
replace crop_code=6 if household_id2=="030101088800204020" & crop_code==1 /* Typo, crops mismatched between files on production and sales */
lab var sales_value "Value of all crop sales"
lab var percent_sold "Percent of crops sold"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_sales.dta", replace 		// household crop level

*Generating median crop prices
gen observation = 1
preserve
	bys region zone woreda kebele ea crop_code: egen obs_ea = count(observation)
	collapse (median) price_kg [aw=weight], by (region zone woreda kebele ea crop_code obs_ea)
	rename price_kg price_kg_median_ea
	lab var price_kg_median_ea "Median price per kg for this crop in the enumeration area"
	lab var obs_ea "Number of sales observations for this crop in the enumeration area"
	save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_ea.dta", replace
restore
preserve
	bys region zone woreda kebele crop_code: egen obs_kebele = count(observation)
	collapse (median) price_kg [aw=weight], by (region zone woreda kebele crop_code obs_kebele)
	rename price_kg price_kg_median_kebele
	lab var price_kg_median_kebele "Median price per kg for this crop in the kebele"
	lab var obs_kebele "Number of sales observations for this crop in the kebele"
	save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_kebele.dta", replace
restore
preserve
	bys region zone woreda crop_code: egen obs_woreda = count(observation)
	collapse (median) price_kg [aw=weight], by (region zone woreda crop_code obs_woreda)
	rename price_kg price_kg_median_woreda
	lab var price_kg_median_woreda "Median price per kg for this crop in the woreda"
	lab var obs_woreda "Number of sales observations for this crop in the woreda"
	save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_woreda.dta", replace
restore
preserve
	bys region zone crop_code: egen obs_zone = count(observation)
	collapse (median) price_kg [aw=weight], by (region zone crop_code obs_zone)
	rename price_kg price_kg_median_zone
	lab var price_kg_median_zone "Median price per kg for this crop in the zone"
	lab var obs_zone "Number of sales observations for this crop in the zone"
	save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_zone.dta", replace
restore
preserve
	bys region crop_code: egen obs_region = count(observation)
	collapse (median) price_kg [aw=weight], by (region crop_code obs_region)
	rename price_kg price_kg_median_region
	lab var price_kg_median_region "Median price per kg for this crop in the region"
	lab var obs_region "Number of sales observations for this crop in the region"
	save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_region.dta", replace
restore
*Last one, no preserve
bys crop_code: egen obs_country = count(observation)
collapse (median) price_kg [aw=weight], by (crop_code obs_country)
rename price_kg price_kg_median_country
lab var price_kg_median_country "Median price per kg for this crop in the country"
lab var obs_country "Number of sales observations for this crop in the country"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_country.dta", replace


*Value crop production by parcel
use "$raw_data/Post-Harvest/sect9_ph_w3.dta", clear
ren saq01 region
ren ph_s9q04_b unit_cd		// for merge
merge m:1 crop_code unit_cd region using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_cf.dta", gen(cf_merge) 
bys crop_code unit_cd: egen national_conv = median(conversion)
replace conversion = national_conv if conversion==.			// replacing with median if missing -- 1,517

*There is some variation in conversion across crops, but they seem to correlate well enough to use units
bys unit_cd region: egen national_conv_unit = median(conversion)
replace conversion = national_conv_unit if conversion==. & unit_cd!=900		// Not for "other" ones -- 2,105 changes

tab unit_cd			// 0.43 percent (111) of field-crop observations are reported with "other" units
tab crop_name ph_s9qo4_b_other if unit_cd==900
*None of the "other" units are for cereal crops so will skip adding in those food conversion factors

gen kg_harvest = ph_s9q05
replace kg_harvest = ph_s9q04_a*conversion if kg_harvest==.
drop if kg_harvest==.

merge m:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hhids.dta", nogen keep(1 3)
merge m:1 region zone woreda kebele crop_code using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_kebele.dta", nogen keep(1 3)
merge m:1 region zone woreda crop_code using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_woreda.dta", nogen keep(1 3)
merge m:1 region zone crop_code using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_zone.dta", nogen keep(1 3)
merge m:1 region crop_code using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_region.dta", nogen keep(1 3)
merge m:1 crop_code using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_country.dta", nogen keep(1 3)
merge m:1 household_id2 crop_code using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_sales.dta", nogen keepusing(price_kg) keep(1 3)
rename price_kg price_kg_hh
gen price_kg = price_kg_hh
replace price_kg = price_kg_median_kebele if price_kg==. & obs_kebele >= 10
replace price_kg = price_kg_median_woreda if price_kg==. & obs_woreda >= 10
replace price_kg = price_kg_median_zone if price_kg==. & obs_zone >= 10
replace price_kg = price_kg_median_region if price_kg==. & obs_region >= 10
replace price_kg = price_kg_median_country if price_kg==. 
lab var price_kg "Price per kg, with all values imputed using local median values of observed sales"
gen value_harvest = kg_harvest * price_kg
lab var value_harvest "Value of harvest"
*For Ethiopia LSMS, "other" crops are at least categorized as being legumes, cereals, etc. 
*So we will take the median per-kg price to value these crops.

*First collapsing by household CROP
preserve
	*Creating area harvested variables from area planted (DMC)
	merge 1:1 holder_id parcel_id field_id crop_code using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_holder_crop_area_land.dta", nogen keep(1 3)
	*NOTE: We dropped plots with 0 or missing area planted. We should therefore not include any reported harvest on those plots (though only 49 of them)
	*so as to note overestimate yield
	drop if ha_planted==0 | ha_planted==.
	gen ha_harv = ha_planted
	replace ha_harv = ha_planted*(ph_s9q09/100) if ph_s9q08==1
	gen ha_harv_male = ha_planted_male
	replace ha_harv_male = ha_planted_male*(ph_s9q09/100) if ph_s9q08==1
	gen ha_harv_female = ha_planted_female
	replace ha_harv_female = ha_planted_female*(ph_s9q09/100) if ph_s9q08==1
	gen ha_harv_mixed = ha_planted_mixed
	replace ha_harv_mixed = ha_planted_mixed*(ph_s9q09/100) if ph_s9q08==1
	gen ha_harv_purestand = ha_planted_purestand
	replace ha_harv_purestand = ha_planted_purestand*(ph_s9q09/100) if ph_s9q08==1
	gen ha_harv_mixedstand = ha_planted_mixedstand
	replace ha_harv_mixedstand = ha_planted_mixedstand*(ph_s9q09/100) if ph_s9q08==1
	gen ha_harv_male_pure = ha_planted_male_pure
	replace ha_harv_male_pure = ha_planted_male_pure*(ph_s9q09/100) if ph_s9q08==1
	gen ha_harv_female_pure = ha_planted_female_pure
	replace ha_harv_female_pure = ha_planted_female_pure*(ph_s9q09/100) if ph_s9q08==1
	gen ha_harv_mixed_pure = ha_planted_mixed_pure
	replace ha_harv_mixed_pure = ha_planted_mixed_pure*(ph_s9q09/100) if ph_s9q08==1
	gen ha_harv_male_mixed = ha_planted_male_mixed
	replace ha_harv_male_mixed = ha_planted_male_mixed*(ph_s9q09/100) if ph_s9q08==1
	gen ha_harv_female_mixed = ha_planted_female_mixed
	replace ha_harv_female_mixed = ha_planted_female_mixed*(ph_s9q09/100) if ph_s9q08==1
	gen ha_harv_mixed_mixed = ha_planted_mixed_mixed
	replace ha_harv_mixed_mixed = ha_planted_mixed_mixed*(ph_s9q09/100) if ph_s9q08==1
	*Merging in gender
	merge m:1 holder_id parcel_id field_id using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_field_gender_dm.dta", nogen keep(1 3)
	gen kg_harvest_male = kg_harvest if dm_gender==1
	gen kg_harvest_female = kg_harvest if dm_gender==2
	gen kg_harvest_mixed = kg_harvest if dm_gender==3
	gen kg_harvest_purestand = kg_harvest if any_pure==1
	gen kg_harvest_mixedstand = kg_harvest if any_mixed==1
	gen kg_harvest_male_pure = kg_harvest if dm_gender==1 & any_pure==1
	gen kg_harvest_female_pure = kg_harvest if dm_gender==2 & any_pure==1
	gen kg_harvest_mixed_pure = kg_harvest if dm_gender==3 & any_pure==1
	gen kg_harvest_male_mixed = kg_harvest if dm_gender==1 & any_mixed==1
	gen kg_harvest_female_mixed = kg_harvest if dm_gender==2 & any_mixed==1
	gen kg_harvest_mixed_mixed = kg_harvest if dm_gender==3 & any_mixed==1
	gen count_male = 1 if dm_gender==1
	gen count_female = 1 if dm_gender==2
	gen count_mixed = 1 if dm_gender==3
	gen count_purestand = 1 if any_pure==1
	gen count_mixedstand = 1 if any_mixed==1
	gen count_male_pure = 1 if dm_gender==1 & any_pure==1
	gen count_female_pure = 1 if dm_gender==2 & any_pure==1
	gen count_mixed_pure = 1 if dm_gender==3 & any_pure==1
	gen count_male_mixed = 1 if dm_gender==1 & any_mixed==1
	gen count_female_mixed = 1 if dm_gender==2 & any_mixed==1
	gen count_mixed_mixed = 1 if dm_gender==3 & any_mixed==1
	merge m:1 holder_id parcel_id field_id using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_field_gender_dm.dta", nogen
	gen value_harvest_male = value_harvest if dm_gender==1
	gen value_harvest_female = value_harvest if dm_gender==2
	gen value_harvest_mixed = value_harvest if dm_gender==3
	collapse (sum) ha_harv* kg_harvest* value_harvest* count_*, by (household_id2 crop_code)
	lab var ha_harv "Area of land that was harvested (household)"
	lab var ha_harv_male "Area of land that was harvested (male-managed)"
	lab var ha_harv_female "Area of land that was harvested (female-managed)"
	lab var ha_harv_mixed "Area of land that was harvested (mixed-managed)"
	lab var ha_harv_purestand "Area of land that was harvested (pure stands)"
	lab var ha_harv_mixedstand "Area of land that was harvested (mixed stands)"
	lab var ha_harv_male_pure "Area of land that was harvested (male-managed pure stands)"
	lab var ha_harv_female_pure "Area of land that was harvested (female-managed pure stands)"
	lab var ha_harv_mixed_pure "Area of land that was harvested (mixed-managed pure stands)"
	lab var ha_harv_male_mixed "Area of land that was harvested (male-managed mixed stands)"
	lab var ha_harv_female_mixed "Area of land that was harvested (female-managed mixed stands)"
	lab var ha_harv_mixed_mixed "Area of land that was harvested (mixed-managed mixed stands)"
	lab var kg_harvest "Harvest in kg (household)"
	lab var kg_harvest_male "Harvest in kg (male-managed)"
	lab var kg_harvest_female "Harvest in kg (female-managed)"
	lab var kg_harvest_mixed "Harvest in kg (mixed-managed)"
	lab var kg_harvest_purestand "Harvest in kg (pure stands)"
	lab var kg_harvest_mixedstand "Harvest in kg (mixed stands)"
	lab var kg_harvest_male_pure "Harvest in kg (male-managed pure stands)"
	lab var kg_harvest_female_pure "Harvest in kg (female-managed pure stands)"
	lab var kg_harvest_mixed_pure "Harvest in kg (mixed-managed pure stands)"
	lab var kg_harvest_male_mixed "Harvest in kg (male-managed mixed stands)"
	lab var kg_harvest_female_mixed "Harvest in kg (female-managed mixed stands)"
	lab var kg_harvest_mixed_mixed "Harvest in kg (mixed-managed mixed stands)"
	lab var count_male "Number of fields (male-managed)"
	lab var count_female "Number of fields (female-managed)"
	lab var count_mixed "Number of fields (mixed-managed)"
	lab var count_purestand "Number of fields (pure stands)"
	lab var count_mixedstand "Number of fields (mixed stands)"
	lab var count_male_pure "Number of fields (male-managed pure stands)"
	lab var count_female_pure "Number of fields (female-managed pure stands)"
	lab var count_mixed_pure "Number of fields (mixed-managed pure stands)"
	lab var count_male_mixed "Number of fields (male-managed mixed stands)"
	lab var count_female_mixed "Number of fields (female-managed mixed stands)"
	lab var count_mixed_mixed "Number of fields (mixed-managed mixed stands)"
	save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_crop_values_production.dta", replace			// household CROP level
	
	*Merging in crop sales to make some changes; this is at household-crop level
	merge 1:1 household_id2 crop_code using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_sales.dta", nogen
	*Some household-level changes
	replace value_harvest = sales_value if percent_sold==100 /* If the household sold 100% of this crop, then that is the value of production, even if odd units had been reported. */
	replace value_harvest = sales_value if kg_harvest==0 & sales_value>0 & sales_value!=.
	replace value_harvest = sales_value if sales_value>value_harvest & sales_value!=. & value_harvest!=. /* In a few cases, the kgs sold exceeds the kgs harvested */
	count if value_harvest==. /* 168 household-crop observations can't be valued. Assume value is zero. */
	replace value_harvest=0 if value_harvest==.
	
	collapse (sum) value_harvest value_harvest_male value_harvest_female value_harvest_mixed sales_value, by(household_id2)
	rename value_harvest value_crop_production
	rename sales_value value_crop_sales
	gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
	lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
	lab var value_crop_sales "Value of crops sold so far"
	lab var value_crop_production "Gross value of crop production for this household"
	drop if household_id2==""
	save  "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_crop_production.dta", replace	
restore

gen cultivated=1
preserve
	*Field-level harvest value
	collapse (sum) field_value_harvest = value_harvest (max) cultivated, by (household_id2 holder_id parcel_id field_id)
	lab var field_value_harvest "Value of crop production on field"
	lab var cultivated "Field was cultivated"
	save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_production_field.dta", replace
restore
*Now collapsing to parcel
collapse (sum) value_harvest (max) cultivated, by (household_id2 holder_id parcel_id)
rename value_harvest value_crop_production_parcel
lab var cultivated "1= Field was cultivated in this data set"
lab var value_crop_production_parcel "Gross value of crop production for this parcel"
drop if household_id2==""
save  "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_production_parcel.dta", replace		// 9,700 parcels cultivated


*Now, using crop production to value LOSSES
use "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_lost_1.dta", clear
append using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_lost_2.dta"
replace percent_lost = share_lost if percent_lost==.
merge m:1 household_id2 crop_code using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_crop_values_production.dta"
drop if _merge==2
drop _merge
*It is evident that sometimes crops were harvested but then the module on sales was not asked.
*91 cases where the amount lost was reported in quantity (crop-units) but no percent lost is given.
*Use conversion file to get from units to kgs, then use the price files to get from kgs to monetary values.
merge m:1 crop_code unit_cd using "$raw_data/Food and Crop Conversion Factors/Crop_CF_Wave3.dta"
drop if _merge==2
drop _merge
gen kgs_lost = quantity_lost * mean_cf_nat
sum kgs_lost if percent_lost==0 /* If both a quantity and share lost were given, we'll take the share to be consistent with section 12. */
lab var kgs_lost "Estimated number of kgs of this crop that were lost post-harvest"
merge m:1 household_id2 crop_code using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_sales.dta"
drop _merge
merge m:1 region zone woreda kebele crop_code using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_kebele.dta"
drop _merge
merge m:1 region zone woreda crop_code using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_woreda.dta"
drop _merge
merge m:1 region zone crop_code using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_zone.dta"
drop _merge
merge m:1 region crop_code using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_region.dta"
drop _merge
merge m:1 crop_code using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_prices_country.dta"
drop _merge
rename price_kg price_kg_hh
gen price_kg = price_kg_hh
replace price_kg = price_kg_median_kebele if price_kg==. & obs_kebele >= 10
replace price_kg = price_kg_median_woreda if price_kg==. & obs_woreda >= 10
replace price_kg = price_kg_median_zone if price_kg==. & obs_zone >= 10
replace price_kg = price_kg_median_region if price_kg==. & obs_region >= 10
replace price_kg = price_kg_median_country if price_kg==. 
lab var price_kg "Price per kg, with all values imputed using local median values of observed sales"
count if (kgs_lost>0 & kgs_lost!=.) | (percent_lost>0 & percent_lost!=.)
replace kgs_lost = 0 if percent_lost!=0 & percent_lost!=.
recode kgs_lost percent_lost (.=0)
gen value_quantity_lost = kgs_lost * price_kg
*br crop_code value_harvest value_quantity_lost kgs_lost percent_lost
/*If the estimated value lost (just 10 obs) exceeds the value produced (We're relying on kg-estimates to value harvest, 
and the units reported can also differ across files), then we'll cap the losses at the value of production */
replace value_quantity_lost = value_harvest if value_quantity_lost > value_harvest & value_quantity_lost!=.
gen crop_value_lost = (value_harvest * (percent_lost/100)) + value_quantity_lost
recode crop_value_lost (.=0)

*Also doing transport costs for crop sales here
rename ph_s11q09 value_transport_cropsales
recode value_transport_cropsales (.=0)

collapse (sum) crop_value_lost value_transport_cropsales, by (household_id2)
lab var crop_value_lost "Value of crop losses"
lab var value_transport_cropsales "Expenditures on transportation for crop sales of temporary crops"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_losses.dta", replace



*************
* LAND RENTAL RATES
*************
use "$raw_data/Post-Planting/sect2_pp_w3.dta", clear
drop if pp_s2q01b==2				// parcel no longer owned or rented
*There is no area question for parcel. Merging constructed area from fields (which was collapsed to parcel)

*Renaming 
rename pp_s2q13_a land_rental_income_cash
rename pp_s2q13_b land_rental_income_inkind
rename pp_s2q13_c land_rental_income_share
rename pp_s2q07_a rental_cost_cash
rename pp_s2q07_b rental_cost_inkind
rename pp_s2q07_c rental_cost_share
recode land_rental_income_cash land_rental_income_inkind (.=0)
gen land_rental_income_upfront = land_rental_income_cash + land_rental_income_inkind
gen rented_plot = (pp_s2q03==3)

*Need to merge in value harvested here
merge 1:1 household_id2 holder_id parcel_id using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_production_parcel.dta", nogen keep(1 3) /* This is created above." */
*Now merging in area of PARCEL (the area this dataset is at); "land_size" is area variable
merge 1:1 holder_id parcel_id using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_parcel_area.dta", nogen keep(1 3)
*5,713 parcels for which I have no value harvested? 
*These parcels include the homestead (very smart!). Just 71 were cultivated this season but not found in the crop harvest file. Maybe those plots were lost in the interim? 
replace rental_cost_cash = rental_cost_share if rental_cost_share>100 & rental_cost_share!=. /* These two columns seems to be switched for a few parcels */
replace rental_cost_share = 0 if rental_cost_share>100 & rental_cost_share!=.
gen rental_cost_sharecrop = value_crop_production_parcel * (rental_cost_share/100)
recode rental_cost_cash rental_cost_inkind rental_cost_sharecrop (.=0)
gen rental_cost_land = rental_cost_cash + rental_cost_inkind + rental_cost_sharecrop
*Saving at parcel level with rental costs
preserve
	keep rental_cost_land holder_id parcel_id 
	save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_rental_parcel.dta", replace
restore

gen any_rent = rented_plot!=0 & rented_plot!=.

gen plot_rental_rate = rental_cost_land/land_size							// at the parcel level; rent divided by rented acres (birr per ha)
recode plot_rental_rate (0=.)											// we don't want to count zeros as valid observations
gen area_meas_hectares_parcel_rental = land_size if rented_plot==1

*Getting a household-level "average" rental rate
bys household_id2: egen plot_rental_total = total(rental_cost_land)
bys household_id2: egen plot_rental_total_area = total(area_meas_hectares_parcel_rental)
gen hh_rental_rate = plot_rental_total/plot_rental_total_area			// total divided by area for birr per ha for households that paid any
recode hh_rental_rate (0=.)					// zero is missing

*Creating geographic medians
*By EA
bys saq01 saq02 saq03 saq04 saq05: egen ha_rental_count_ea = count(plot_rental_rate)
bys saq01 saq02 saq03 saq04 saq05: egen ha_rental_price_ea = median(plot_rental_rate)
*By kebele
bys saq01 saq02 saq03 saq04: egen ha_rental_count_keb = count(plot_rental_rate)
bys saq01 saq02 saq03 saq04: egen ha_rental_price_keb = median(plot_rental_rate)
*By woreda
bys saq01 saq02 saq03: egen ha_rental_count_wor = count(plot_rental_rate)
bys saq01 saq02 saq03: egen ha_rental_price_wor = median(plot_rental_rate)
*By zone
bys saq01 saq02: egen ha_rental_count_zone = count(plot_rental_rate)
bys saq01 saq02: egen ha_rental_price_zone = median(plot_rental_rate)
*By region
bys saq01: egen ha_rental_count_reg = count(plot_rental_rate)
bys saq01: egen ha_rental_price_reg = median(plot_rental_rate)
*National
egen ha_rental_price_nat = median(plot_rental_rate)

*Generating rental rate per hectare
gen ha_rental_rate = hh_rental_rate			// using household value when available
replace ha_rental_rate = ha_rental_price_ea if ha_rental_count_ea>=10 & ha_rental_rate==.
replace ha_rental_rate = ha_rental_price_keb if ha_rental_count_keb>=10 & ha_rental_rate==.
replace ha_rental_rate = ha_rental_price_wor if ha_rental_count_wor>=10 & ha_rental_rate==.
replace ha_rental_rate = ha_rental_price_zone if ha_rental_count_zone>=10 & ha_rental_rate==.
replace ha_rental_rate = ha_rental_price_reg if ha_rental_count_reg>=10 & ha_rental_rate==.
replace ha_rental_rate = ha_rental_price_nat if ha_rental_rate==.
collapse (sum) land_rental_income_upfront (firstnm) ha_rental_rate, by(household_id2)
lab var land_rental_income_upfront "Estimated income from renting out land over previous 12 months (upfront payments only)"
lab var ha_rental_rate "Household's `average' rental rate per hectare"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_rental_rate.dta", replace


*************
* LAND VALUE - RENTED LAND
*************
*Starting at field area
use "$created_data/Ethiopia_ESS_LSMS_ISA_W3_field_area", clear
*Merging in gender
merge 1:1 holder_id parcel_id field_id using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_field_gender_dm.dta", nogen
*Merging in rental costs paid
merge m:1 holder_id parcel_id using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_rental_parcel.dta", nogen	// 96.1 percent matched
*Merging in parcel area ("land_size")
merge m:1 household_id2 holder_id parcel_id using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_parcel_area.dta", nogen	// 6 not matched from using
gen percent_field = area_meas_hectares/land_size			// field area divided by land size
gen value_rented_land = rental_cost_land			// value paid in rent, including share crop
*Note that rent is at the parcel level, but decision-maker is at the field level (below parcel).
*Allocating rental costs based on percent of parcel taken up by field
gen value_rented_land_male = value_rented_land*percent_field if dm_gender==1			// male rental rate is percent of parcel times rental cost of parcel
gen value_rented_land_female = value_rented_land*percent_field if dm_gender==2
gen value_rented_land_mixed = value_rented_land*percent_field if dm_gender==3
collapse (sum) value_rented_*, by(household_id2)				// total rental costs at the household level
lab var value_rented_land "Value of rented land (household expenditures)"
lab var value_rented_land_male "Value of rented land (household expenditures) for male-managed plots"
lab var value_rented_land_female "Value of rented land (household expenditures) for female-managed plots"
lab var value_rented_land_mixed "Value of rented land (household expenditures) for mixed-managed plots"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_rental_value.dta", replace


****************
*VALUE OF AREA PLANTED
****************
use "$raw_data/Post-Planting/sect4_pp_w3.dta", clear
*Percent of area
gen pure_stand = pp_s4q02==1
gen any_pure = pure_stand==1
gen any_mixed = pure_stand==0
gen percent_field = pp_s4q03/100
replace percent_field = 1 if pure_stand==1

*Total area on field
bys holder_id parcel_id field_id: egen total_percent_field = total(percent_field)
replace percent_field = percent_field/total_percent_field if total_percent_field>1			// 219 changes

*Merging in area
merge m:1 holder_id parcel_id field_id using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_field_area", nogen keep(1 3)	// dropping those only in using
*Merging in gender
merge m:1 holder_id parcel_id field_id using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_field_gender_dm.dta", nogen
*4 not matched from master
*30,337 matched
*NOTE: we will create ha_planted here but we won't save it in the datafile. We had to construct ha_planted above 
*for use in the crop production do-file, but we needed the crop production data for value. Therefore, we have to
*construct area_planted and value separately
gen ha_planted = percent_field*area_meas_hectares
gen ha_planted_male = percent_field*area_meas_hectares if dm_gender==1
gen ha_planted_female = percent_field*area_meas_hectares if dm_gender==2
gen ha_planted_mixed = percent_field*area_meas_hectares if dm_gender==3
gen ha_planted_purestand = percent_field*area_meas_hectares if any_pure==1
gen ha_planted_mixedstand = percent_field*area_meas_hectares if any_mixed==1
gen ha_planted_male_pure = percent_field*area_meas_hectares if dm_gender==1 & any_pure==1
gen ha_planted_female_pure = percent_field*area_meas_hectares if dm_gender==2 & any_pure==1
gen ha_planted_mixed_pure = percent_field*area_meas_hectares if dm_gender==3 & any_pure==1
gen ha_planted_male_mixed = percent_field*area_meas_hectares if dm_gender==1 & any_mixed==1
gen ha_planted_female_mixed = percent_field*area_meas_hectares if dm_gender==2 & any_mixed==1
gen ha_planted_mixed_mixed = percent_field*area_meas_hectares if dm_gender==3 & any_mixed==1

*Merging in sect2 for rental variables
merge m:1 holder_id parcel_id using "$raw_data/Post-Planting/sect2_pp_w3.dta", gen(sect2_merge) keep(1 3)		// 173 not matched from master
*Merging in rental rate
merge m:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_rental_rate.dta", nogen keep(1 3) keepusing(ha_rental_rate)

*Value of all OWNED (that is, not rented) land
gen value_owned_land = ha_rental_rate*ha_planted if (pp_s2q07_a==. | pp_s2q07_a==0) & (pp_s2q07_b==. | pp_s2q07_b==0) & (pp_s2q07_c==. | pp_s2q07_c==0)	// cash AND in kind AND share must be zero or missing
gen value_owned_land_male = ha_rental_rate*ha_planted_male if (pp_s2q07_a==. | pp_s2q07_a==0) & (pp_s2q07_b==. | pp_s2q07_b==0) & (pp_s2q07_c==. | pp_s2q07_c==0)
gen value_owned_land_female = ha_rental_rate*ha_planted_female if (pp_s2q07_a==. | pp_s2q07_a==0) & (pp_s2q07_b==. | pp_s2q07_b==0) & (pp_s2q07_c==. | pp_s2q07_c==0)
gen value_owned_land_mixed = ha_rental_rate*ha_planted_mixed if (pp_s2q07_a==. | pp_s2q07_a==0) & (pp_s2q07_b==. | pp_s2q07_b==0) & (pp_s2q07_c==. | pp_s2q07_c==0)
gen value_owned_land_purestand = ha_rental_rate*ha_planted_purestand if (pp_s2q07_a==. | pp_s2q07_a==0) & (pp_s2q07_b==. | pp_s2q07_b==0) & (pp_s2q07_c==. | pp_s2q07_c==0)
gen value_owned_land_mixedstand = ha_rental_rate*ha_planted_mixedstand if (pp_s2q07_a==. | pp_s2q07_a==0) & (pp_s2q07_b==. | pp_s2q07_b==0) & (pp_s2q07_c==. | pp_s2q07_c==0)
gen value_owned_land_male_pure = ha_rental_rate*ha_planted_male_pure if (pp_s2q07_a==. | pp_s2q07_a==0) & (pp_s2q07_b==. | pp_s2q07_b==0) & (pp_s2q07_c==. | pp_s2q07_c==0)
gen value_owned_land_female_pure=  ha_rental_rate*ha_planted_female_pure if (pp_s2q07_a==. | pp_s2q07_a==0) & (pp_s2q07_b==. | pp_s2q07_b==0) & (pp_s2q07_c==. | pp_s2q07_c==0)
gen value_owned_land_mixed_pure = ha_rental_rate*ha_planted_mixed_pure if (pp_s2q07_a==. | pp_s2q07_a==0) & (pp_s2q07_b==. | pp_s2q07_b==0) & (pp_s2q07_c==. | pp_s2q07_c==0)
gen value_owned_land_male_mixed = ha_rental_rate*ha_planted_male_mixed if (pp_s2q07_a==. | pp_s2q07_a==0) & (pp_s2q07_b==. | pp_s2q07_b==0) & (pp_s2q07_c==. | pp_s2q07_c==0)
gen value_owned_land_female_mixed = ha_rental_rate*ha_planted_female_mixed if (pp_s2q07_a==. | pp_s2q07_a==0) & (pp_s2q07_b==. | pp_s2q07_b==0) & (pp_s2q07_c==. | pp_s2q07_c==0)
gen value_owned_land_mixed_mixed = ha_rental_rate*ha_planted_mixed_mixed if (pp_s2q07_a==. | pp_s2q07_a==0) & (pp_s2q07_b==. | pp_s2q07_b==0) & (pp_s2q07_c==. | pp_s2q07_c==0)

drop crop_code
ren pp_s4q01_b crop_code

collapse (sum) value_owned_land*, by(household_id2)
lab var value_owned_land "Value of owned land that was cultivated (household)"
lab var value_owned_land_male "Value of owned land that was cultivated (male-managed)"
lab var value_owned_land_female "Value of owned land that was cultivated (female-managed)"
lab var value_owned_land_mixed "Value of owned land that was cultivated (mixed-managed)"
lab var value_owned_land_male_pure "Value of owned land that was cultivated (male-managed pure stands)"
lab var value_owned_land_female_pure "Value of owned land that was cultivated (female-managed pure stands)"
lab var value_owned_land_mixed_pure "Value of owned land that was cultivated (mixed-managed pure stands)"
lab var value_owned_land_male_mixed "Value of owned land that was cultivated (male-managed mixed stands)"
lab var value_owned_land_female_mixed "Value of owned land that was cultivated (female-managed mixed stands)"
lab var value_owned_land_mixed_mixed "Value of owned land that was cultivated (mixed-managed mixed stands)"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_cost_land.dta", replace


****************
*USE OF IMPROVED SEED
****************
use "$raw_data/Post-Planting/sect4_pp_w3.dta", clear
gen imprv_seed_use=.
replace imprv_seed_use=1 if pp_s4q11==2
replace imprv_seed_use=0 if pp_s4q11==1
collapse (max) imprv_seed_use, by(household_id2)
lab var imprv_seed_use "Household uses any improved seeds"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_imprv_seed.dta", replace


*********
*COST OF SEEDS
*********
*Purchased, free, and left-over seeds are all seeds used (see question 19 in section 5)
use "$raw_data/Post-Planting/sect5_pp_w3.dta", clear
recode pp_s5q05_a pp_s5q05_b pp_s5q14_a pp_s5q14_b pp_s5q18_a pp_s5q18_b (.=0)
gen kg_seed_purchased = pp_s5q05_a + pp_s5q05_b/1000		// kg + g/1000
gen seed_value = pp_s5q08
rename pp_s5q07 value_transport_purchased_seed
rename pp_s5q16 value_transport_free_seed

gen kg_seed_free = pp_s5q14_a + pp_s5q14_b/1000
gen kg_seed_own = pp_s5q18_a + pp_s5q18_b/1000
*Seed not purchased
egen kg_seed_not_purchased = rowtotal(kg_seed_free kg_seed_own)

*Constructing prices
gen seed_price_hh = seed_value/kg_seed_purchased			// value per kg
recode seed_price_hh (0=.)									// don't want to count zero as a "valid" price observation

*Geographic medians
bys crop_code saq01 saq02 saq03 saq04 saq05: egen seed_count_ea = count(seed_price_hh)
bys crop_code saq01 saq02 saq03 saq04 saq05: egen seed_price_ea = median(seed_price_hh)
bys crop_code saq01 saq02 saq03 saq04: egen seed_count_keb = count(seed_price_hh)
bys crop_code saq01 saq02 saq03 saq04: egen seed_price_keb = median(seed_price_hh)
bys crop_code saq01 saq02 saq03: egen seed_count_wor = count(seed_price_hh)
bys crop_code saq01 saq02 saq03: egen seed_price_wor = median(seed_price_hh)
bys crop_code saq01 saq02: egen seed_count_zone = count(seed_price_hh)
bys crop_code saq01 saq02: egen seed_price_zone = median(seed_price_hh)
bys crop_code saq01: egen seed_count_reg = count(seed_price_hh)
bys crop_code saq01: egen seed_price_reg = median(seed_price_hh)
bys crop_code: egen seed_price_nat = median(seed_price_hh)

*A lot will be at higher levels of aggregation (region and national) due to lack of observations for many crops
gen seed_price = seed_price_ea if seed_count_ea>=10			// 365 values
replace seed_price = seed_price_keb if seed_count_keb>=10 & seed_price==.	// no changes
replace seed_price = seed_price_wor if seed_count_wor>=10 & seed_price==.	// 233 changes
replace seed_price = seed_price_zone if seed_count_zone>=10 & seed_price==.	// 1266 changes
replace seed_price = seed_price_reg if seed_count_reg>=10 & seed_price==.	// 6844 changes
replace seed_price = seed_price_nat if seed_price==.						// 3333 changes

gen value_purchased_seed = seed_value
gen value_non_purchased_seed = seed_price*kg_seed_not_purchased
*Now, replacing with household price when available
*First, constructing "price" at the household level
bys household_id2 crop_code: egen seed_value_hh = total(seed_value)					// summing total value of seed to household
bys household_id2 crop_code: egen kg_seed_purchased_hh = total(kg_seed_purchased)		// summing total value of seed purchased to HH
gen seed_price_hh_non = seed_value_hh/kg_seed_purchased_hh
*Now, replacing when household price is not missing
replace value_non_purchased_seed = (seed_price_hh_non)*kg_seed_not_purchased if seed_price_hh_non!=. & seed_price_hh_non!=0

*Merging in gender
*merge m:1 holder_id parcel_id field_id using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_field_level", nogen keep(1 3) keepusing(dm_gender)	// dropping those only in using
*NOTE: We cannot appropriately value seeds by gender because seed module is at the holder-crop level, not field level. Maybe in the future we could allocate them based on percentage of area planted with the crop?

collapse (sum) value_purchased_seed value_non_purchased_seed value_transport*, by(household_id2)			// collapsing to HOUSEHOLD, not holder
lab var value_purchased_seed "Value of purchased seed"
lab var value_transport_purchased_seed "Cost of transport for purchased seed"
lab var value_transport_free_seed "Cost of transport for free seed"
lab var value_purchased_seed "Value of seed purchased (household)"
lab var value_non_purchased_seed "Value of seed not purchased (household)"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_cost_seed.dta", replace


*************
*USE OF EXTENSION
*************
use "$raw_data/Post-Planting/sect5_pp_w3.dta", clear
merge m:m household_id2 using "$raw_data/Post-Planting/sect3_pp_w3.dta", keepusing(household_id2 pp_s3q11) nogen
merge m:m household_id2 using "$raw_data/Post-Planting/sect7_pp_w3.dta", keepusing(household_id2 pp_s7q04) nogen
gen ext_reach=.
replace ext_reach=1 if pp_s3q11==1 | pp_s7q04==1 | pp_s5q02==4
replace ext_reach=0 if pp_s3q11==2 & pp_s7q04==2
collapse (max) ext_reach, by(household_id2)
lab var ext_reach"Household reached by extension, public or private"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_ext_reach.dta", replace



**************
* LIVESTOCK OWNERSHIP
**************
use "$raw_data/Livestock/sect8_2_ls_w3.dta", clear

*TLU (Tropical Livestock Units)
gen tlu_coefficient=0.5 if (ls_code==1|ls_code==2|ls_code==3|ls_code==4|ls_code==5|ls_code==6)
replace tlu_coefficient = 0.1 if (ls_code==7|ls_code==8|ls_code==9|ls_code==10|ls_code==11|ls_code==12)
replace tlu_coefficient = 0.7 if (ls_code==13|ls_code==14|ls_code==15)
replace tlu_coefficient = 0.01 if (ls_code==16|ls_code==17|ls_code==18|ls_code==19)
replace tlu_coefficient = 0.5 if (ls_code==20)
replace tlu_coefficient = 0.6 if (ls_code==21)
replace tlu_coefficient = 0.3 if (ls_code==22)
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
ren ls_code livestock_code

rename ls_sec_8_2aq01 number_1yearago
rename ls_sec_8_2aq02 number_born 
rename ls_sec_8_2aq04 number_purchased 
rename ls_sec_8_2aq05 value_livestock_purchases 
rename ls_sec_8_2aq07 number_gifts_received 
rename ls_sec_8_2aq09 number_gifts_given 
rename ls_sec_8_2aq11 number_lost 
rename ls_sec_8_2aq13 number_sold 
rename ls_sec_8_2aq14 value_sold
rename ls_sec_8_2aq16 number_slaughtered
rename ls_sec_8_2aq18 income_slaughtered
replace number_sold = value_sold if number_sold > value_sold /* columns seem to be switched */
replace number_purchased = value_livestock_purchases if number_purchased > value_livestock_purchases
replace number_purchased = 0 if number_purchased >= 1000 & value_livestock_purchases ==.
replace number_gifts_received = 0 if number_gifts_received >= 1000 /* Seem to have reported value of gifts, not number of animals */
replace number_born = 0 if number_born >= 1000
recode number_1yearago number_born number_purchased number_gifts_received number_gifts_given number_lost number_sold number_slaughtered (.=0)
*replace number_slaughtered = 0 if number_slaughtered > (number_1yearago + number_born + number_purchased + number_gifts_received)
*replace number_sold = 0 if number_sold > (number_1yearago + number_born + number_purchased + number_gifts_received)
gen number_today = number_1yearago + number_born + number_purchased + number_gifts_received - number_gifts_given - number_lost - number_sold - number_slaughtered
replace number_today = 0 if number_today < 0 /* My best effort to clean this up */
gen tlu_1yearago = number_1yearago * tlu_coefficient
gen tlu_today = number_today * tlu_coefficient
*We can't estimate the value of animals slaughtered because we don't know the number of slaughtered animals that were sold.
*Although we might be able to estimate the value as though they were live sales.
recode number_sold number_slaughtered value_livestock_purchases (.=0)
*Bee colonies not captured in TLU.
gen price_per_animal = value_sold / number_sold
merge m:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hhids.dta"
drop if _merge==2
drop _merge

*Prices
preserve
	keep if price_per_animal !=.		// no zeros
	gen observation = 1
	bys region zone woreda kebele livestock_code: egen obs_kebele = count(observation)
	collapse (median) price_per_animal [aw=weight], by (region zone woreda kebele livestock_code obs_kebele)
	rename price_per_animal price_median_kebele
	lab var price_median_kebele "Median price per unit for this livestock in the kebele"
	lab var obs_kebele "Number of sales observations for this livestock in the kebele"
	save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_prices_kebele.dta", replace
restore
preserve
	keep if price_per_animal !=.
	gen observation = 1
	bys region zone woreda livestock_code: egen obs_woreda = count(observation)
	collapse (median) price_per_animal [aw=weight], by (region zone woreda livestock_code obs_woreda)
	rename price_per_animal price_median_woreda
	lab var price_median_woreda "Median price per unit for this livestock in the woreda"
	lab var obs_woreda "Number of sales observations for this livestock in the woreda"
	save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_prices_woreda.dta", replace
restore
preserve
	keep if price_per_animal !=.
	gen observation = 1
	bys region zone livestock_code: egen obs_zone = count(observation)
	collapse (median) price_per_animal [aw=weight], by (region zone livestock_code obs_zone)
	rename price_per_animal price_median_zone
	lab var price_median_zone "Median price per unit for this livestock in the zone"
	lab var obs_zone "Number of sales observations for this livestock in the zone"
	save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_prices_zone.dta", replace
restore
preserve
	keep if price_per_animal !=.
	gen observation = 1
	bys region livestock_code: egen obs_region = count(observation)
	collapse (median) price_per_animal [aw=weight], by (region livestock_code obs_region)
	rename price_per_animal price_median_region
	lab var price_median_region "Median price per unit for this livestock in the region"
	lab var obs_region "Number of sales observations for this livestock in the region"
	save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_prices_region.dta", replace
restore
preserve
	keep if price_per_animal !=.
	gen observation = 1
	bys livestock_code: egen obs_country = count(observation)
	collapse (median) price_per_animal [aw=weight], by (livestock_code obs_country)
	rename price_per_animal price_median_country
	lab var price_median_country "Median price per unit for this livestock in the country"
	lab var obs_country "Number of sales observations for this livestock in the country"
	save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_prices_country.dta", replace
restore

merge m:1 region zone woreda kebele livestock_code using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_prices_kebele.dta"
drop _merge
merge m:1 region zone woreda livestock_code using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_prices_woreda.dta"
drop _merge
merge m:1 region zone livestock_code using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_prices_zone.dta"
drop _merge
merge m:1 region livestock_code using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_prices_region.dta"
drop _merge
merge m:1 livestock_code using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_prices_country.dta"
drop _merge /* All have merges */
replace price_per_animal = price_median_kebele if price_per_animal==. & obs_kebele >= 10
replace price_per_animal = price_median_woreda if price_per_animal==. & obs_woreda >= 10
replace price_per_animal = price_median_zone if price_per_animal==. & obs_zone >= 10
replace price_per_animal = price_median_region if price_per_animal==. & obs_region >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_slaughtered = price_per_animal * number_slaughtered
replace value_slaughtered = income_slaughtered if (value_slaughtered < income_slaughtered) & number_slaughtered!=0 & income_slaughtered!=. /* Replace value of slaughtered animals with income from slaughtered-sales if the latter is larger */
egen value_livestock_sales = rowtotal(value_sold value_slaughtered)
gen value_1yearago = number_1yearago * price_per_animal
gen value_today = number_today * price_per_animal

collapse (sum) tlu_1yearago tlu_today value_1yearago value_today value_livestock_sales value_livestock_purchases, by (household_id2)
lab var value_livestock_sales "Value of livestock sold and slaughtered (with slaughtered livestock that weren't sold valued at local median prices for live animal sales)"
lab var value_livestock_purchases "Value of livestock purchases (seems to span only the agricutlural season, not the year)"
lab var tlu_1yearago "Tropical Livestock Units as of 12 months ago"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
lab var value_1yearago "Value of livestock holdings from one year ago"
lab var value_today "Value of livestock holdings today"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_sales", replace



**************
* LIVESTOCK EXPENSES
**************
use "$raw_data/Livestock/sect8_3_ls_w3.dta", clear
append using "$raw_data/Livestock/sect8_4_ls_w3.dta"
append using  "$raw_data/Livestock/sect8_5_ls_w3.dta"
rename ls_sec_8_4q05 cost_water_livestock
rename ls_sec_8_4q08 cost_fodder_livestock
rename ls_sec_8_5q05 cost_vaccines_livestock
rename ls_sec_8_5q07 cost_treatment_livestock
rename ls_sec_8_3q04 cost_breeding_livestock
recode cost_water_livestock cost_fodder_livestock cost_vaccines_livestock cost_treatment_livestock cost_breeding_livestock (.=0)
collapse (sum) cost_water_livestock cost_fodder_livestock cost_vaccines_livestock cost_treatment_livestock cost_breeding_livestock, by (household_id2)
lab var cost_water_livestock "Cost for water for livestock"
lab var cost_fodder_livestock "Cost for fodder for livestock"
lab var cost_vaccines_livestock "Cost for vaccines for livestock"
lab var cost_treatment_livestock "Cost for veterinary treatment for livestock"
lab var cost_breeding_livestock "Cost for breeding (insemination?) for livestock"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_expenses", replace
*Note that costs for hired labor are not captured.




**************
* LIVESTOCK VACCINATION
**************
use "$raw_data/Livestock/sect8_5_ls_w3.dta", clear
gen vac_animal=.
replace vac_animal=1 if ls_sec_8_5q01==1
replace vac_animal=0 if ls_sec_8_5q01==2
collapse (max) vac_animal, by (household_id2)
lab var vac_animal "Household uses vaccines"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_vaccination", replace


**************
* LIVESTOCK EARNINGS AND PRODUCTION
**************
use "$raw_data/Livestock/sect8_6_ls_w3.dta", clear
rename ls_code livestock_code 

rename ls_sec_8_6aq01 animals_milked
rename ls_sec_8_6aq02 months_milked
rename ls_sec_8_6aq04 liters_per_day /* Based on values, I assume this is per cow */
recode animals_milked months_milked liters_per_day (.=0)
gen milk_liters_produced = (animals_milked * (months_milked/12) * 365 * liters_per_day)
rename ls_sec_8_6aq10 earnings_milk_week
rename ls_sec_8_6aq09 liters_sold_week
rename ls_sec_8_6aq12 earnings_milk_products /* Note that we can't value the milk inputs here. They'll get double-counted as income */
gen price_per_liter = earnings_milk_week / liters_sold_week
rename ls_sec_8_6bq16 egg_laying_hens
rename ls_sec_8_6bq14 clutching_periods
rename ls_sec_8_6bq15 eggs_per_clutching_period
recode egg_laying_hens clutching_periods eggs_per_clutching_period (.=0)
gen eggs_produced = (egg_laying_hens * clutching_periods * eggs_per_clutching_period)
rename ls_sec_8_6bq18 eggs_sold
*Where the estimates of # eggs sold exceeds the calculation of what was produced, let's take the lower value.
*replace eggs_produced = eggs_sold if eggs_sold > eggs_produced & eggs_produced != 0 & eggs_sold !=.
rename ls_sec_8_6bq19 earnings_egg_sales
gen price_per_egg = earnings_egg_sales / eggs_sold
merge m:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hhids.dta"
drop if _merge==2
drop _merge
gen price_per_unit = price_per_liter
replace price_per_unit = price_per_egg if price_per_unit==.

*Prices
preserve
	keep if price_per_unit !=.
	gen observation = 1
	bys region zone woreda kebele livestock_code: egen obs_kebele = count(observation)
	collapse (median) price_per_unit [aw=weight], by (region zone woreda kebele livestock_code obs_kebele)
	rename price_per_unit price_median_kebele
	lab var price_median_kebele "Median price per unit for this livestock product in the kebele"
	lab var obs_kebele "Number of sales observations for this livestock product in the kebele"
	save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_products_prices_kebele.dta", replace
restore
preserve
	keep if price_per_unit !=.
	gen observation = 1
	bys region zone woreda livestock_code: egen obs_woreda = count(observation)
	collapse (median) price_per_unit [aw=weight], by (region zone woreda livestock_code obs_woreda)
	rename price_per_unit price_median_woreda
	lab var price_median_woreda "Median price per unit for this livestock product in the woreda"
	lab var obs_woreda "Number of sales observations for this livestock product in the woreda"
	save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_products_prices_woreda.dta", replace
restore
preserve
	keep if price_per_unit !=.
	gen observation = 1
	bys region zone livestock_code: egen obs_zone = count(observation)
	collapse (median) price_per_unit [aw=weight], by (region zone livestock_code obs_zone)
	rename price_per_unit price_median_zone
	lab var price_median_zone "Median price per unit for this livestock product in the zone"
	lab var obs_zone "Number of sales observations for this livestock product in the zone"
	save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_products_prices_zone.dta", replace
restore
preserve
	keep if price_per_unit !=.
	gen observation = 1
	bys region livestock_code: egen obs_region = count(observation)
	collapse (median) price_per_unit [aw=weight], by (region livestock_code obs_region)
	rename price_per_unit price_median_region
	lab var price_median_region "Median price per unit for this livestock product in the region"
	lab var obs_region "Number of sales observations for this livestock product in the region"
	save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_products_prices_region.dta", replace
restore
preserve
	keep if price_per_unit !=.
	gen observation = 1
	bys livestock_code: egen obs_country = count(observation)
	collapse (median) price_per_unit [aw=weight], by (livestock_code obs_country)
	rename price_per_unit price_median_country
	lab var price_median_country "Median price per unit for this livestock product in the country"
	lab var obs_country "Number of sales observations for this livestock product in the country"
	save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_products_prices_country.dta", replace
restore

merge m:1 region zone woreda kebele livestock_code using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_products_prices_kebele.dta"
drop _merge
merge m:1 region zone woreda livestock_code using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_products_prices_woreda.dta"
drop _merge
merge m:1 region zone livestock_code using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_products_prices_zone.dta"
drop _merge
merge m:1 region livestock_code using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_products_prices_region.dta"
drop _merge
merge m:1 livestock_code using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_products_prices_country.dta"
drop _merge /* All have merges */
replace price_per_unit = price_median_kebele if price_per_unit==. & obs_kebele >= 10
replace price_per_unit = price_median_woreda if price_per_unit==. & obs_woreda >= 10
replace price_per_unit = price_median_zone if price_per_unit==. & obs_zone >= 10
replace price_per_unit = price_median_region if price_per_unit==. & obs_region >= 10
replace price_per_unit = price_median_country if price_per_unit==. 
lab var price_per_unit "Price per liter (milk) or per egg, imputed with local median prices if household did not sell"
gen value_milk_produced = milk_liters_produced * price_per_unit 
gen value_eggs_produced = eggs_produced * price_per_unit
recode earnings_milk_products (.=0)
collapse (sum) value_milk_produced value_eggs_produced earnings_milk_products animals_milked milk_liters_produced egg_laying_hens eggs_produced, by (household_id2)
lab var value_milk_produced "Value of milk produced"
lab var value_eggs_produced "Value of eggs produced"
lab var earnings_milk_products "Earnings from milk products sold (gross earnings only)"
lab var animals_milked "Number of animals milked (previous 12 months)"
lab var milk_liters_produced "Liters of milk produced (previous 12 months)"
lab var egg_laying_hens "Number of hens laying eggs (Previous 12 months)"
lab var eggs_produced "Eggs produced (previous 12 months)"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_products", replace


************
*WAGE INCOME
************
use "$raw_data/Household/sect4_hh_w3.dta", clear
rename hh_s4q10_b occupation_code 
rename hh_s4q11_b industry_code 
rename hh_s4q09 mainwage_yesno
rename hh_s4q13 mainwage_number_months
rename hh_s4q14 mainwage_number_weeks
rename hh_s4q15 mainwage_number_hours
gen mainwage_recent_payment = hh_s4q16
replace mainwage_recent_payment = . if occupation_code==6 | industry_code==1 | industry_code==2

rename hh_s4q17 mainwage_payment_period
rename hh_s4q20 secwage_yesno
rename hh_s4q24 secwage_number_months
rename hh_s4q25 secwage_number_weeks
rename hh_s4q26 secwage_number_hours
gen secwage_recent_payment = hh_s4q27
replace secwage_recent_payment = . if occupation_code==6 | industry_code==1 | industry_code==2
rename hh_s4q28 secwage_payment_period

local vars main sec
foreach p of local vars {
	gen `p'wage_salary_cash = `p'wage_recent_payment if `p'wage_payment_period==8
	replace `p'wage_salary_cash = ((`p'wage_number_months/6)*`p'wage_recent_payment) if `p'wage_payment_period==7
	replace `p'wage_salary_cash = ((`p'wage_number_months/4)*`p'wage_recent_payment) if `p'wage_payment_period==6
	replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_recent_payment) if `p'wage_payment_period==5
	replace `p'wage_salary_cash = (`p'wage_number_months*(`p'wage_number_weeks/2)*`p'wage_recent_payment) if `p'wage_payment_period==4
	replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_number_weeks*`p'wage_recent_payment) if `p'wage_payment_period==3
	replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_number_weeks*(`p'wage_number_hours/8)*`p'wage_recent_payment) if `p'wage_payment_period==2
	replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_number_weeks*`p'wage_number_hours*`p'wage_recent_payment) if `p'wage_payment_period==1
	recode `p'wage_salary_cash (.=0)
	gen `p'wage_annual_salary = `p'wage_salary_cash
}
rename hh_s4q33 income_psnp
recode mainwage_annual_salary secwage_annual_salary income_psnp (.=0)
gen annual_salary = mainwage_annual_salary + secwage_annual_salary /*+ othwage_annual_salary*/ + income_psnp

*Now ag wage
replace mainwage_recent_payment = hh_s4q16
replace mainwage_recent_payment = . if occupation_code!=6  & industry_code!=1 & industry_code!=2
replace secwage_recent_payment = hh_s4q27
replace secwage_recent_payment = . if occupation_code!=6  & industry_code!=1 & industry_code!=2

local vars main sec
foreach p of local vars {
	gen `p'wage_salary_cash_ag = `p'wage_recent_payment if `p'wage_payment_period==8
	replace `p'wage_salary_cash_ag = ((`p'wage_number_months/6)*`p'wage_recent_payment) if `p'wage_payment_period==7
	replace `p'wage_salary_cash_ag = ((`p'wage_number_months/4)*`p'wage_recent_payment) if `p'wage_payment_period==6
	replace `p'wage_salary_cash_ag = (`p'wage_number_months*`p'wage_recent_payment) if `p'wage_payment_period==5
	replace `p'wage_salary_cash_ag = (`p'wage_number_months*(`p'wage_number_weeks/2)*`p'wage_recent_payment) if `p'wage_payment_period==4
	replace `p'wage_salary_cash_ag = (`p'wage_number_months*`p'wage_number_weeks*`p'wage_recent_payment) if `p'wage_payment_period==3
	replace `p'wage_salary_cash_ag = (`p'wage_number_months*`p'wage_number_weeks*(`p'wage_number_hours/8)*`p'wage_recent_payment) if `p'wage_payment_period==2
	replace `p'wage_salary_cash_ag = (`p'wage_number_months*`p'wage_number_weeks*`p'wage_number_hours*`p'wage_recent_payment) if `p'wage_payment_period==1
	recode `p'wage_salary_cash_ag (.=0)
	gen `p'wage_annual_salary_ag = `p'wage_salary_cash_ag
}
recode mainwage_annual_salary_ag secwage_annual_salary_ag (.=0)
gen annual_salary_agwage = mainwage_annual_salary_ag + secwage_annual_salary_ag

collapse (sum) annual_salary annual_salary_agwage, by (household_id2)
lab var annual_salary "Estimated annual earnings from non-agricultural wage employment over previous 12 months"
lab var annual_salary_agwage "Estimated annual earnings from agricultural wage employment over previous 12 months"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_wage_income.dta", replace


*************
* DIETARY DIVERSITY
*************
use "$raw_data/Household/sect5a_hh_w3.dta" , clear
count // nb of obs = 272,470

* We recode food items to map HDD food categories
ta item_cd_cf
#delimit ;
recode item_cd_cf 	(1 2 3 4 5 6 60 195 196 197 901 				=1	"CEREALS")  
					(16 17 170 171 172 173 174    					=2	"WHITE ROOTS,TUBERS AND OTHER STARCHES")
					(14 144 145 915 909	910 912 913 143 908			=3	"VEGETABLES")
					(907 15 151 152 906					 			=4	"FRUITS")
					(180 181 182									=5	"MEAT")
					(21												=6	"EGGS")
					(183 											=7  "FISH")
					(7/13  110 111 131 902 903 904 905	  			=8	"LEGUMES, NUTS AND SEEDS")
					(19 20											=9	"MILK AND MILK PRODUCTS")
					(201 202    									=10	"OILS AND FATS")
					(22	204							  				=11	"SWEETS")
					(23/26 141 142	911	198 203 205 206 905 914		=12	"SPICES, CONDIMENTS, BEVERAGES")
					, generate(Diet_ID)
					;
#delimit cr
* generate a dummy variable indicating whether a the respondent or other member of the household have consumerd
* a food items during the past 7 days 			
gen adiet_yes=(hh_s5aq01==1)
ta adiet_yes   
** Now, we collapse to food group level assuming that if an a household consumes at least one food item in a food group,
* then he has consumed that food group. That is equivalent to taking the MAX of adiet_yes
collapse (max) adiet_yes, by(household_id2 Diet_ID) 
count // nb of obs = 54,494 remaining
label define YesNo 1 "Yes" 0 "No"
label val adiet_yes YesNo
* Now, estimate the number of food groups eaten by each individual
collapse (sum) adiet_yes, by(household_id2 )
count  // 4,954 obs remaining
/*
There are no established cut-off points in terms of number of food groups to indicate
adequate or inadequate dietary diversity for the HDDS and WDDS. Because of
this it is recommended to use the mean score or distribution of scores for analytical
purposes and to set programme targets or goals.
*/
* What cut-off point to use?
sum adiet_yes 
gen household_diet=(adiet_yes>=6)
lab var household_diet "Consumption of at least 6 food groups"
lab var adiet_yes "Number of food groups consumed by households"

compress
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_household_diet.dta", replace
 


**************
*USE OF FINANCIAL SERVICES
**************
use "$raw_data/Household/sect11b_hh_w3.dta", clear
merge m:m household_id2 using "$raw_data/Household/sect4b_hh_w3.dta", nogen
gen use_fin_serv=0
replace use_fin_serv=1 if hh_s4bq02==1 |  hh_s4bq09a==1 | hh_s4bq09b==1 | hh_s4bq09c==1 | hh_s4bq09d==1 | hh_s4bq09e==1| hh_s4bq15==1 | hh_s11bq04c==1
replace use_fin_serv=. if hh_s4bq02==. & hh_s4bq09a==. & hh_s4bq09b==. & hh_s4bq09c==. & hh_s4bq09d==. & hh_s4bq15==. & hh_s11bq04c==.
collapse (max) use_fin_serv, by (household_id2)
lab var use_fin_serv "Household uses vaccines"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_fin_serv.dta", replace




**************
*SELF-EMPLOYMENT INCOME
**************
use "$raw_data/Household/sect11b_hh_w3.dta", clear
rename hh_s11bq09 months_activ  
rename hh_s11bq13 avg_monthly_sales
egen monthly_expenses = rowtotal(hh_s11bq14_a- hh_s11bq14_e)
*br months_activ avg_monthly_sales hh_s11bq14_a- hh_s11bq14_e
*2 observations with positive expenses but missing info on business income. These won't be considered at all.
gen monthly_profit = (avg_monthly_sales - monthly_expenses)
gen annual_selfemp_profit = monthly_profit * months_activ
recode annual_selfemp_profit (.=0)
collapse (sum) annual_selfemp_profit, by (household_id2)
lab var annual_selfemp_profit "Estimated annual net profit from self-employment over previous 12 months"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_self_employment_income.dta", replace



**************
*OTHER INCOME
**************
use "$raw_data/Household/sect12_hh_w3.dta", clear
rename hh_s12q02 amount_received
gen transfer_income = amount_received if hh_s12q00==101|hh_s12q00==102|hh_s12q00==103 /* cash, food, other in-kind transfers */
gen investment_income = amount_received if hh_s12q00==104
gen pension_income = amount_received if hh_s12q00==105
gen rental_income = amount_received if hh_s12q00==106|hh_s12q00==107|hh_s12q00==108|hh_s12q00==109
gen sales_income = amount_received if hh_s12q00==110|hh_s12q00==111|hh_s12q00==112
gen inheritance_income = amount_received if hh_s12q00==113
recode transfer_income pension_income investment_income sales_income inheritance_income (.=0)
collapse (sum) transfer_income pension_income investment_income rental_income sales_income inheritance_income, by (household_id2)
lab var transfer_income "Estimated income from cash, food, or other in-kind gifts/transfers over previous 12 months"
lab var pension_income "Estimated income from a pension over previous 12 months"
lab var investment_income "Estimated income from interest or investments over previous 12 months"
lab var sales_income "Estimated income from sales of real estate or other assets over previous 12 months"
lab var rental_income "Estimated income from rentals of buildings, tools, land, transport animals over previous 12 months"
lab var inheritance_income "Estimated income from cinheritance over previous 12 months"
*Note: Make sure we're not double-counting land rental income
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_other_income.dta", replace



**************
*ASSISTANCE INCOME
**************
use "$raw_data/Household/sect13_hh_w3.dta", clear
rename hh_s13q00 assistance_code
rename hh_s13q03 amount_received 
gen psnp_income = amount_received if assistance_code=="A"
gen assistance_income = amount_received if assistance_code=="B"|assistance_code=="C"|assistance_code=="D"|assistance_code=="E"
recode psnp_income assistance_income (.=0)
collapse (sum) psnp_income assistance_income, by (household_id2)
lab var psnp_income "Estimated income from a PSNP over previous 12 months"
lab var assistance_income "Estimated income from a food aid, food-for-work, etc. over previous 12 months"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_assistance_income.dta", replace



************
*WOMEN'S AG DECISION-MAKING
************
*SALES DECISION-MAKERS - INPUT DECISIONS
use "$raw_data/Post-Planting/sect3_pp_w3.dta", clear
*Women's decision-making in ag
local planting_input "pp_saq07 pp_s3q10a pp_s3q10c_a pp_s3q10c_b"
keep household_id2 `planting_input' // keep relevant variables
* Transform the data into long form  
foreach v of local planting_input   {
	preserve
	keep household_id2  `v'
	ren `v'  decision_maker
	drop if decision_maker==. | decision_maker==0 | decision_maker==99
	tempfile `v'
	save ``v''
	restore
}
use `pp_saq07', clear
foreach v of local planting_input   {
	if "`v'"!="`pp_saq07'" {
		append using ``v''
	}
}
** remove duplicates  (if a hhmember appears at least one time, she/he own a livestock)
*duplicates drop 
gen type_decision="planting_input"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_women_planting_input.dta", replace

*SALES DECISION-MAKERS - ANNUAL SALES
use "$raw_data/Post-Harvest/sect11_ph_w3.dta", clear
*First, this is for construction of women's decision-making
local control_annualsales "ph_s11q05_a ph_s11q05_b"
keep household_id2 `control_annualsales' // keep relevant variables
* Transform the data into long form  
foreach v of local control_annualsales   {
	preserve
	keep household_id2  `v'
	ren `v'  controller_income
	drop if controller_income==. | controller_income==0 | controller_income==99
	tempfile `v'
	save ``v''
	restore
}
use `ph_s11q05_a', clear
foreach v of local control_annualsales   {
	if "`v'"!="`ph_s11q05_a'" {
		append using ``v''
	}
}
** Remove duplicates (if a hhmember appears at least one time, she/he own a livestock)
duplicates drop 
gen type_decision="control_annualsales"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_women_control_annualsales.dta", replace

*SALES DECISION-MAKERS - ANNUAL CROP
use "$raw_data/Post-Harvest/sect11_ph_w3.dta", clear
local sales_annualcrop "ph_saq07 ph_s11q01b_1 ph_s11q01b_2 ph_s11q01c_1 ph_s11q01c_2 ph_s11q05_a ph_s11q05_b"
keep household_id2 `sales_annualcrop' // keep relevant variables
* Transform the data into long form  
foreach v of local sales_annualcrop   {
	preserve
	keep household_id2  `v'
	ren `v'  decision_maker
	drop if decision_maker==. | decision_maker==0 | decision_maker==99
	tempfile `v'
	save ``v''
	restore
}
use `ph_saq07', clear
foreach v of local sales_annualcrop   {
	if "`v'"!="`ph_saq07'" {
		append using ``v''
	}
}
** remove duplicates  (if a hhmember appears at least one time, she/he own a livestock)
*duplicates drop 
gen type_decision="sales_annualcrop"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_women_sales_annualcrop.dta", replace

*SALES DECISION-MAKERS - PERM SALES
use "$raw_data/Post-Harvest/sect12_ph_w3.dta", clear
local control_permsales "ph_s12q08a_1 ph_s12q08a_2"
keep household_id2 `control_permsales' // keep relevant variables
* Transform the data into long form  
foreach v of local control_permsales   {	
	preserve
	keep household_id2  `v'
	ren `v'  controller_income
	drop if controller_income==. | controller_income==0 | controller_income==99
	tempfile `v'
	save ``v''
	restore
}
use `ph_s12q08a_1', clear
foreach v of local control_permsales   {
	if "`v'"!="`ph_s12q08a_1'" {
		append using ``v''
	}
}
** remove duplicates  (if a hhmember appears at least one time, she/he own a livestock)
duplicates drop 
gen type_decision="control_permsales"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_women_control_permsales.dta", replace

*SALES DECISION-MAKERS - PERM CROP
use "$raw_data/Post-Harvest/sect12_ph_w3.dta", clear
local sales_permcrop "ph_saq07 ph_s12q08a_1 ph_s12q08a_2"
keep household_id2 `sales_permcrop' // keep relevant variables
* Transform the data into long form  
foreach v of local sales_permcrop   {
	preserve
	keep household_id2  `v'
	ren `v'  decision_maker
	drop if decision_maker==. | decision_maker==0 | decision_maker==99
	tempfile `v'
	save ``v''
	restore
}
use `ph_saq07', clear
foreach v of local sales_permcrop   {
	if "`v'"!="`ph_saq07'" {
		append using ``v''
	}
}
** remove duplicates  (if a hhmember appears at least one time, she/he own a livestock)
*duplicates drop 
gen type_decision="sales_permcrop"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_women_sales_permcrop.dta", replace


*SALES DECISION-MAKERS - HARVEST
use "$raw_data/Post-Harvest/sect9_ph_w3.dta", clear
local harvest "ph_saq07 ph_s9q07a_1 ph_s9q07a_2"
keep household_id2 `harvest' // keep relevant variables
* Transform the data into long form  
foreach v of local harvest   {
	preserve
	keep household_id2  `v'
	ren `v'  decision_maker
	drop if decision_maker==. | decision_maker==0 | decision_maker==99
	tempfile `v'
	save ``v''
	restore
}	
use `ph_saq07', clear
foreach v of local harvest   {
	if "`v'"!="`ph_saq07'" {
		append using ``v''
	}
}
** remove duplicates  (if a hhmember appears at least one time, she/he owns a livestock)
*duplicates drop 
gen type_decision="harvest"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_women_control_harvest.dta", replace


************
*WOMEN'S CONTROL OVER INCOME
************
*SALES DECISION-MAKERS - ANNUAL HARVEST
use "$raw_data/Post-Harvest/sect9_ph_w3.dta", clear
local control_annualharvest "ph_s9q07a_1 ph_s9q07a_2"
keep household_id2 `control_annualharvest' // keep relevant variables
* Transform the data into long form  
foreach v of local control_annualharvest   {
	preserve
	keep household_id2  `v'
	ren `v'  controller_income
	drop if controller_income==. | controller_income==0 | controller_income==99
	tempfile `v'
	save ``v''
	restore
}
use `ph_s9q07a_1', clear
foreach v of local control_annualharvest   {
	if "`v'"!="`ph_s9q07a_1'" {
		append using ``v''
	}
}
** remove duplicates  (if a hhmember appears at least one time, she/he own a livestock)
duplicates drop 
gen type_decision="control_annualharvest"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_women_control_annualharvest.dta", replace

* FEMALE LIVESTOCK DECISION-MAKING - MANAGEMENT
use "$raw_data/Livestock/sect8_1_ls_w3.dta", clear
local livestockowners "pp_saq07  ls_sec_8_1q03_a ls_sec_8_1q03_b"
keep household_id2 `livestockowners' // keep relevant variables
* Transform the data into long form  
foreach v of local livestockowners   {
	preserve
	keep household_id2  `v'
	ren `v'  decision_maker
	drop if decision_maker==. | decision_maker==0 | decision_maker==99
	tempfile `v'
	save ``v''
	restore
}
use `pp_saq07', clear
foreach v of local livestockowners   {
	if "`v'"!="`pp_saq07'" {
		append using ``v''
	}
}
** remove duplicates  (if a hhmember appears at least one time, she/he own a livestock)
*duplicates drop 
gen type_decision="manage_livestock"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_women_manage_livestock.dta", replace


* Constructing decision-making ag variable *
use "$created_data/Ethiopia_ESS_LSMS_ISA_W3_women_planting_input.dta", clear
append using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_women_control_harvest.dta"
append using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_women_sales_annualcrop.dta"
append using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_women_sales_permcrop.dta"
append using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_women_manage_livestock.dta"

bysort household_id2 decision_maker : egen nb_decision_participation=count(decision_maker)
drop if nb_decision_participation==1

*	Create group
gen make_decision_crop=1 if  type_decision=="planting_input" ///
							| type_decision=="harvest" ///
							| type_decision=="sales_annualcrop" ///
							| type_decision=="sales_permcrop" 
recode 	make_decision_crop (.=0)

gen make_decision_livestock=1 if  type_decision=="manage_livestock"
recode 	make_decision_livestock (.=0)

gen make_decision_ag=1 if make_decision_crop==1 | make_decision_livestock==1
recode 	make_decision_ag (.=0)

collapse (max) make_decision_* , by(household_id2 decision_maker )  //any decision
ren decision_maker hh_s1q00 

*	Now merge with member characteristics
merge 1:1 household_id2 hh_s1q00   using   "$raw_data/Household/sect1_hh_w3.dta"
*  107 member ID in decision files not in member list
drop household_id- hh_s1q02 hh_s1q04b- _merge
recode make_decision_* (.=0)
*	Generate women participation in Ag decision
ren hh_s1q03 mem_gender 
ren hh_s1q04a mem_age 
drop if mem_gender==1
drop if mem_age<18 & mem_gender==2

*	Generates women control over income
local allactivity crop  livestock  ag
foreach v of local allactivity {
	gen women_decision_`v'= make_decision_`v'==1 & mem_gender==2
	lab var women_decision_`v' "Women make decision abour `v' activities"
	lab var make_decision_`v' "HH member involed in `v' activities"
} 

collapse (max) women_decision_ag, by(household_id2 hh_s1q00)
gen personid = hh_s1q00
compress
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_ag_decision.dta", replace


* FEMALE LIVESTOCK DECISION-MAKING - SALES
use "$raw_data/Livestock/sect8_1_ls_w3.dta", clear
local control_livestocksales "ls_sec_8_1q03_a ls_sec_8_1q03_b"
keep household_id2 `control_livestocksales' // keep relevant variables
* Transform the data into long form  
foreach v of local control_livestocksales   {
	preserve
	keep household_id2  `v'
	ren `v'  controller_income
	drop if controller_income==. | controller_income==0 | controller_income==99
	tempfile `v'
	save ``v''
	restore
}
use `ls_sec_8_1q03_a', clear
foreach v of local control_livestocksales   {
	if "`v'"!="`ls_sec_8_1q03_a'" {
		append using ``v''
	}
}
** remove duplicates  (if a hhmember appears at least one time, she/he own a livestock)
duplicates drop 
gen type_decision="control_livestocksales"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_women_control_livestocksales.dta", replace

* FEMALE DECISION-MAKING - CONTROL OF BUSINESS INCOME
use "$raw_data/Household/sect11b_hh_w3.dta", clear
local control_businessincome "hh_s11bq03_a hh_s11bq03_b hh_s11bq03d_1 hh_s11bq03d_2"
keep household_id2 `control_businessincome' // keep relevant variables
* Transform the data into long form  
foreach v of local control_businessincome   {
	preserve
	keep household_id2  `v'
	ren `v'  controller_income
	drop if controller_income==. | controller_income==0 | controller_income==99
	tempfile `v'
	save ``v''
	restore
}
use `hh_s11bq03_a', clear
foreach v of local control_businessincome   {
	if "`v'"!="`hh_s11bq03_a'" {
		append using ``v''
	}
}
** remove duplicates  (if a hhmember appears at least one time, she/he own a livestock)
duplicates drop 
gen type_decision="control_businessincome"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_women_control_businessincome.dta", replace

* FEMALE DECISION-MAKING - CONTROL OF OTHER INCOME
use "$raw_data/Household/sect12_hh_w3.dta", clear
local control_otherincome "hh_s12q03_a hh_s12q03_b"
keep household_id2 `control_otherincome' // keep relevant variables
* Transform the data into long form  
foreach v of local control_otherincome   {
	preserve
	keep household_id2  `v'
	ren `v'  controller_income
	drop if controller_income==. | controller_income==0 | controller_income==99
	tempfile `v'
	save ``v''
	restore
}
use `hh_s12q03_a', clear
foreach v of local control_otherincome   {
	if "`v'"!="`hh_s12q03_a'" {
		append using ``v''
	}
}
** remove duplicates  (if a hhmember appears at least one time, she/he own a livestock)
duplicates drop 
gen type_decision="control_otherincome"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_women_control_otherincome.dta", replace


* Constructing decision-making final variable *
use "$created_data/Ethiopia_ESS_LSMS_ISA_W3_women_control_annualharvest.dta", clear
append using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_women_control_annualsales.dta"
append using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_women_control_permsales.dta"
append using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_women_control_livestocksales.dta"
append using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_women_control_businessincome.dta"
*append using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_women_control_wageincome.dta"
append using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_women_control_otherincome.dta"

*	Create group
gen control_cropincome=1 if  type_decision=="control_annualharvest" ///
							| type_decision=="control_annualsales" ///
							| type_decision=="control_permsales" 
recode 	control_cropincome (.=0)		
							
gen control_livestockincome=1 if  type_decision=="control_livestocksales"  
recode 	control_livestockincome (.=0)

gen control_farmincome=1 if  control_cropincome==1 | control_livestockincome==1							
recode 	control_farmincome (.=0)		
							
gen control_businessincome=1 if  type_decision=="control_businessincome" 
recode 	control_businessincome (.=0)
													
**gen control_wageincome=1 if  type_decision=="control_wageincome" 
**recode 	control_wageincome (.=0)
													
gen control_nonfarmincome=1 if  type_decision=="control_otherincome" ///
							  | control_businessincome== 1
recode 	control_nonfarmincome (.=0)															

gen control_all_income=1 if  control_farmincome== 1 | control_nonfarmincome==1
recode 	control_all_income (.=0)															
						
collapse (max) control_* , by(household_id2 controller_income )  //any decision

preserve
	*	We also need a variable that indicates if a source of income is applicable to a household
	*	and use it to condition the statistics on household with the type of income
	collapse (max) control_*, by(household_id2) 
	foreach v of varlist control_cropincome- control_all_income {
		local t`v'=subinstr("`v'",  "control", "hh_has", 1)
		ren `v'   `t`v''
	} 
	tempfile hh_has_income
	save `hh_has_income'
restore
merge m:1 household_id2 using `hh_has_income'
drop _m

ren controller_income hh_s1q00

*	Own any asset
*	Now merge with member characteristics
merge 1:1 household_id2 hh_s1q00   using   "$raw_data/Household/sect1_hh_w3.dta"
*  107 member ID in decision files not in member list
drop household_id- hh_s1q02 hh_s1q04b- _merge

ren hh_s1q03 mem_gender 
ren hh_s1q04a mem_age 

recode control_* (.=0)
drop if   mem_gender==1
drop if mem_age<18 & mem_gender ==2
gen women_control_all_income= control_all_income==1 
gen personid = hh_s1q00
compress
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_control_income.dta", replace


************
*WOMEN'S OWNERSHIP OF ASSETS
************

* FEMALE LAND OWNERSHIP
use "$raw_data/Post-Planting/sect2_pp_w3.dta", clear
*Female asset ownership
local landowners "pp_s2q03c_a pp_s2q03c_b pp_s2q06_a pp_s2q06_b pp_s2q08a_a pp_s2q08a_b"
keep household_id2  `landowners' // keep relevant variables
*	Transform the data into long form // reshap won't work because of duplicates
foreach v of local landowners   {
	preserve
	keep household_id2  `v'
	ren `v'  asset_owner
	drop if asset_owner==. | asset_owner==0
	tempfile `v'
	save ``v''
	restore
}
use `pp_s2q03c_a', clear
foreach v of local landowners   {
	if "`v'"!="`pp_s2q03c_a'" {
		append using ``v''
	}
}
** remove duplicates by collapse (if a hhmember appears at least one time, she/he onw/control a land)
duplicates drop 
gen type_asset="land"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_women_land_owner.dta", replace


*FEMALE LIVESTOCK OWNERSHIP
use "$raw_data/Livestock/sect8_1_ls_w3.dta", clear
*Remove poultry-livestocks
drop if inlist(ls_sec_8_type_code,4,5,6,.)
local livestockowners "ls_sec_8_1q03_a ls_sec_8_1q03_b"
keep household_id2 `livestockowners' // keep relevant variables
*Transform the data into long form  
foreach v of local livestockowners   {
	preserve
	keep household_id2  `v'
	ren `v'  asset_owner
	drop if asset_owner==. | asset_owner==0
	tempfile `v'
	save ``v''
	restore
}
use `ls_sec_8_1q03_a', clear
foreach v of local landowners   {
	if "`v'"!="`ls_sec_8_1q03_a'" {
		append using ``v''
	}
}
*remove duplicates  (if a hhmember appears at least one time, she/he owns a livestock)
duplicates drop 
gen type_asset="livestock"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_women_livestock_owner.dta", replace


* FEMALE OTHER ASSETS
use "$raw_data/Household/sect10_hh_w3.dta", clear
*keep only productive assets
drop if inlist(hh_s10q00, 4,5,6,9, 11, 13, 16, 26, 27)
local otherassetowners "hh_s10q02_a hh_s10q02_b"
keep household_id2  `otherassetowners'
*Transform the data into long form  
foreach v of local otherassetowners   {
	preserve
	keep household_id2  `v'
	ren `v'  asset_owner
	drop if asset_owner==. | asset_owner==0
	tempfile `v'
	save ``v''
	restore
}
use `hh_s10q02_a', clear
foreach v of local landowners   {
	if "`v'"!="`hh_s10q02_a'" {
		append using ``v''
	}
}
*remove duplicates  (if a hhmember appears at least one time, she/he owns a non-agricultural asset)
duplicates drop 
gen type_asset="otherasset"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_women_otherasset_owner.dta", replace

* Construct asset ownership variable  *
use "$created_data/Ethiopia_ESS_LSMS_ISA_W3_women_land_owner.dta", clear
append using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_women_livestock_owner.dta"
append using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_women_otherasset_owner.dta"
gen own_asset=1 

collapse (max) own_asset, by(household_id2 asset_owner)
gen hh_s1q00=asset_owner

*Own any asset
*Now merge with member characteristics
merge 1:1 household_id2 hh_s1q00  using   "$raw_data/Household/sect1_hh_w3.dta"
gen personid = hh_s1q00
drop _m hh_s1q00 individual_id ea_id ea_id2 saq03- hh_s1q02 hh_s1q04b- obs
ren hh_s1q03 mem_gender 
ren hh_s1q04a mem_age 
ren saq01 region
ren saq02 zone
recode own_asset (.=0)
gen women_asset= own_asset==1 & mem_gender==2
lab  var women_asset "Women ownership of asset"
drop if mem_gender==1
drop if mem_age<18 & mem_gender==2
compress
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_women_asset.dta", replace





**************
*CROP YIELDS
**************

use "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_crop_area_land.dta", clear
merge 1:1 household_id2 crop_code using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_sales.dta", nogen
merge 1:1 household_id2 crop_code using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_crop_values_production.dta", nogen
*Merging weights, survey variables, and gender of head
merge m:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_male_head.dta", nogen keep(1 3)

*Keeping only crops of interest
keep if inlist(crop_code,2,5,6,9,10,12,13,18,19)
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_ALL.dta", replace


*Creating a loop in order to create a separate dta file for each crop
foreach crop_name in bean maize rice sorghum cassava{			//cowpea not included in survey

if "`crop_name'"=="bean"{										//includes mung bean, haricot bean, horse bean, soya beans, red kidney beans
	local crop "9,12,13,18,19"
}
if "`crop_name'"=="maize"{
	local crop 2
}
if "`crop_name'"=="rice"{
	local crop 5
}
if "`crop_name'"=="sorghum"{
	local crop 6
}
if "`crop_name'"=="cassava"{
	local crop 10
}

use "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_ALL.dta", clear
keep if inlist(crop_code,`crop')
foreach i of varlist ha_harv* ha_planted*{
	replace `i'=. if `i'==0
}

*code to winsorize top and bottom 1 percent
recode ha_harv (0=.) if ha_planted!=0
foreach i in male female mixed purestand mixedstand male_pure female_pure mixed_pure male_mixed female_mixed mixed_mixed{
	recode ha_harv_`i' (0=.) if ha_planted_`i'!=0
}
_pctile ha_harv, p(1 99)
foreach i of varlist ha_harv*{
	replace `i' = r(r1) if `i' < r(r1)
	replace `i' = r(r2) if (`i' > r(r2) & `i' !=.)
}
	
*Creating yield variables at the household level	
gen kg_yield = kg_harvest/ha_harv
gen kg_yield_male = kg_harvest_male/ha_harv_male if count_male!=0 & ha_planted_male!=.	// if >0, then there is at least one plot in the household that satisfies the criterion
gen kg_yield_female = kg_harvest_female/ha_harv_female if count_female!=0
gen kg_yield_mixed = kg_harvest_mixed/ha_harv_mixed if count_mixed!=0
gen kg_yield_purestand = kg_harvest_purestand/ha_harv_purestand if count_purestand!=0
gen kg_yield_mixedstand = kg_harvest_mixedstand/ha_harv_mixedstand if count_mixedstand!=0
gen kg_yield_male_pure = kg_harvest_male_pure/ha_harv_male_pure if count_male_pure!=0
gen kg_yield_female_pure = kg_harvest_female_pure/ha_harv_female_pure if count_female_pure!=0
gen kg_yield_mixed_pure = kg_harvest_mixed_pure/ha_harv_mixed_pure if count_mixed_pure!=0
gen kg_yield_male_mixed = kg_harvest_male_mixed/ha_harv_male_mixed if count_male_mixed!=0
gen kg_yield_female_mixed = kg_harvest_female_mixed/ha_harv_female_mixed if count_female_mixed!=0
gen kg_yield_mixed_mixed = kg_harvest_mixed_mixed/ha_harv_mixed_mixed if count_mixed_mixed!=0

*constructing area_weights
gen area_weight = pw_w3*ha_harv
gen area_weight_male = pw_w3*ha_harv_male if ha_harv_male!=.
gen area_weight_female = pw_w3*ha_harv_female if ha_harv_female!=.
gen area_weight_mixed = pw_w3*ha_harv_mixed if ha_harv_mixed !=.
gen area_weight_purestand = pw_w3*ha_harv_purestand if ha_harv_purestand !=.  
gen area_weight_mixedstand = pw_w3*ha_harv_mixedstand if ha_harv_mixedstand !=.  
gen area_weight_male_pure = pw_w3*ha_harv_male_pure if ha_harv_male_pure !=.  
gen area_weight_female_pure = pw_w3*ha_harv_female_pure if ha_harv_female_pure !=.  
gen area_weight_mixed_pure = pw_w3*ha_harv_mixed_pure if ha_harv_mixed_pure !=.  
gen area_weight_male_mixed = pw_w3*ha_harv_male_mixed if ha_harv_male_mixed !=. 
gen area_weight_female_mixed = pw_w3*ha_harv_female_mixed if ha_harv_female_mixed !=. 
gen area_weight_mixed_mixed = pw_w3*ha_harv_mixed_mixed if ha_harv_mixed_mixed !=. 


*code to winsorize top 1 percent
_pctile kg_yield, p(1 99)
foreach i of varlist kg_yield*{
	replace `i' = r(r1) if `i'<r(r1)
	replace `i' = r(r2) if (`i' > r(r2) & `i' !=.)
}
lab var kg_yield "Yield kg/ha (household)"
lab var kg_yield_male "Yield kg/ha (male-managed)"
lab var kg_yield_female "Yield kg/ha (female-managed)"
lab var kg_yield_mixed "Yield kg/ha (mixed-managed)"
lab var kg_yield_purestand "Yield kg/ha (pure stands)"
lab var kg_yield_mixedstand "Yield kg/ha (mixed stands)"
lab var kg_yield_male_pure "Yield kg/ha (male-managed pure stands)"
lab var kg_yield_female_pure "Yield kg/ha (female-managed pure stands)"
lab var kg_yield_mixed_pure "Yield kg/ha (mixed-managed pure stands)"
lab var kg_yield_male_mixed "Yield kg/ha (male-managed mixed stands)"
lab var kg_yield_female_mixed "Yield kg/ha (female-managed mixed stands)"
lab var kg_yield_mixed_mixed "Yield kg/ha (mixed-managed mixed stands)"
lab var area_weight "Area weight (household)"
lab var area_weight_male "Area weight (male-managed)"
lab var area_weight_female "Area weight (female-managed)"
lab var area_weight_mixed "Area weight (mixed-managed)"
lab var area_weight_purestand "Area weight (pure stands)"
lab var area_weight_mixedstand "Area weight (mixed stands)"
lab var area_weight_male_pure "Area weight (male-managed pure stands)"
lab var area_weight_female_pure "Area weight (female-managed pure stands)"
lab var area_weight_mixed_pure "Area weight (mixed-managed pure stands)"
lab var area_weight_male_mixed "Area weight (male-managed mixed stands)"
lab var area_weight_female_mixed "Area weight (female-managed mixed stands)"
lab var area_weight_mixed_mixed "Area weight (mixed-managed mixed stands)"

gen crop_name = "`crop_name'"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_`crop_name'.dta", replace
}

use "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_bean.dta", clear
append using  "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_maize.dta"
append using  "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_sorghum.dta"
lab var crop_name "Crop name"
lab var household_id2 "Household ID"
lab var region "Region"
lab var zone "Zone"
lab var woreda "Woreda"
lab var town "Town"
lab var subcity "Subcity"
lab var kebele "Kebele"
lab var ea "Enumeration area"
lab var rural "1= Rural"
lab var pw_w3 "Household weight"
save "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_ALL.dta", replace

global croplist  maize sorghum bean
foreach crop_name of global croplist {
	use "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_`crop_name'.dta",clear
	ren ha_planted ha_planted_all
	ren ha_harv ha_harv_all 
	ren kg_harvest kg_harvest_all 
	ren kg_yield kg_yield_all
	ren area_weight area_weight_all
	
	foreach x of varlist ha_planted_* ha_harv_* kg_harvest_* kg_yield_* area_weight_* {
		ren `x' `x'_`crop_name'
		local templab: var label `x'_`crop_name'
	}
	collapse (sum) ha_planted_* ha_harv_* area_weight_* kg_harvest_* (mean) kg_yield_*, by(household_id2) 
	tempfile `crop_name'
	save ``crop_name''
}

use `maize', clear
merge 1:1 household_id2 using `sorghum', nogen
merge 1:1 household_id2 using `bean', nogen

global croplist maize sorghum bean 
foreach crop of global croplist {
	lab var ha_planted_all_`crop' "Area planted of `crop' (household)"
	lab var ha_planted_female_`crop' "Area planted of `crop' (female-managed plots)"	
	lab var ha_planted_male_`crop' "Area planted of `crop' (male-managed plots)"	
	lab var ha_planted_mixed_`crop' "Area planted of `crop' (mixed-managed plots)"	
	lab var ha_planted_purestand_`crop' "Area planted of `crop' - purestand (household)"
	lab var ha_planted_male_pure_`crop' "Area planted of `crop' - purestand (female-managed plots)"
	lab var ha_planted_female_pure_`crop' "Area planted of `crop' - purestand (male-managed plots)"
	lab var ha_planted_mixed_pure_`crop' "Area planted of `crop' - purestand (mixed-managed plots)"	
	lab var ha_planted_mixedstand_`crop' "Area planted of `crop' - intercrop (household)"
	lab var ha_planted_male_mixed_`crop' "Area planted of `crop' - intercrop (female-managed plots)"
	lab var ha_planted_female_mixed_`crop' "Area planted of `crop' - intercrop (male-managed plots)"
	lab var ha_planted_mixed_mixed_`crop' "Area planted of `crop' - intercrop (mixed-managed plots)"				

	lab var ha_harv_all_`crop' "Area harvested of `crop' (household)"
	lab var ha_harv_female_`crop' "Area harvested of `crop' (female-managed plots)"	
	lab var ha_harv_male_`crop' "Area harvested of `crop' (male-managed plots)"	
	lab var ha_harv_mixed_`crop' "Area harvested of `crop' (mixed-managed plots)"	
	lab var ha_harv_purestand_`crop' "Area harvested of `crop' - purestand (household)"
	lab var ha_harv_male_pure_`crop' "Area harvested of `crop' - purestand (female-managed plots)"
	lab var ha_harv_female_pure_`crop' "Area harvested of `crop' - purestand (male-managed plots)"
	lab var ha_harv_mixed_pure_`crop' "Area harvested of `crop' - purestand (mixed-managed plots)"	
	lab var ha_harv_mixedstand_`crop' "Area harvested of `crop' - intercrop (household)"
	lab var ha_harv_male_mixed_`crop' "Area harvested of `crop' - intercrop (female-managed plots)"
	lab var ha_harv_female_mixed_`crop' "Area harvested of `crop' - intercrop (male-managed plots)"
	lab var ha_harv_mixed_mixed_`crop' "Area harvested of `crop' - intercrop (mixed-managed plots)"				

	lab var kg_harvest_all_`crop' "Quantity harvested of `crop' (household)"
	lab var kg_harvest_female_`crop' "Quantity harvested of `crop' (female-managed plots)"	
	lab var kg_harvest_male_`crop' "Quantity harvested of `crop' (male-managed plots)"	
	lab var kg_harvest_mixed_`crop' "Quantity harvested of `crop' (mixed-managed plots)"	
	lab var kg_harvest_purestand_`crop' "Quantity harvested of `crop' - purestand (household)"
	lab var kg_harvest_male_pure_`crop' "Quantity harvested of `crop' - purestand (female-managed plots)"
	lab var kg_harvest_female_pure_`crop' "Quantity harvested of `crop' - purestand (male-managed plots)"
	lab var kg_harvest_mixed_pure_`crop' "Quantity harvested of `crop' - purestand (mixed-managed plots)"	
	lab var kg_harvest_mixedstand_`crop' "Quantity harvested of `crop' - intercrop (household)"
	lab var kg_harvest_male_mixed_`crop' "Quantity harvested of `crop' - intercrop (female-managed plots)"
	lab var kg_harvest_female_mixed_`crop' "Quantity harvested of `crop' - intercrop (male-managed plots)"
	lab var kg_harvest_mixed_mixed_`crop' "Quantity harvested of `crop' - intercrop (mixed-managed plots)"				
	
	lab var area_weight_all_`crop' "Area-adjusted weight for `crop' (household)"
	lab var area_weight_female_`crop' "Area-adjusted weight for `crop' (female-managed plots)"	
	lab var area_weight_male_`crop' "Area-adjusted weight for `crop' (male-managed plots)"	
	lab var area_weight_mixed_`crop' "Area-adjusted weight for `crop' (mixed-managed plots)"	
	lab var area_weight_purestand_`crop' "Area-adjusted weight for `crop' - purestand (household)"
	lab var area_weight_male_pure_`crop' "Area-adjusted weight for `crop' - purestand (female-managed plots)"
	lab var area_weight_female_pure_`crop' "Area-adjusted weight for `crop' - purestand (male-managed plots)"
	lab var area_weight_mixed_pure_`crop' "Area-adjusted weight for `crop' - purestand (mixed-managed plots)"	
	lab var area_weight_mixedstand_`crop' "Area-adjusted weight for `crop' - intercrop (household)"
	lab var area_weight_male_mixed_`crop' "Area-adjusted weight for `crop' - intercrop (female-managed plots)"
	lab var area_weight_female_mixed_`crop' "Area-adjusted weight for `crop' - intercrop (male-managed plots)"
	lab var area_weight_mixed_mixed_`crop' "Area-adjusted weight for `crop' - intercrop (mixed-managed plots)"				

	lab var kg_yield_all_`crop' "Yield of `crop' (household)"
	lab var kg_yield_female_`crop' "Yield of `crop' (female-managed plots)"	
	lab var kg_yield_male_`crop' "Yield of `crop' (male-managed plots)"	
	lab var kg_yield_mixed_`crop' "Yield of `crop' (mixed-managed plots)"	
	lab var kg_yield_purestand_`crop' "Yield of `crop' - purestand (household)"
	lab var kg_yield_male_pure_`crop' "Yield of `crop' - purestand (female-managed plots)"
	lab var kg_yield_female_pure_`crop' "Yield of `crop' - purestand (male-managed plots)"
	lab var kg_yield_mixed_pure_`crop' "Yield of `crop' - purestand (mixed-managed plots)"	
	lab var kg_yield_mixedstand_`crop' "Yield of `crop' - intercrop (household)"
	lab var kg_yield_male_mixed_`crop' "Yield of `crop' - intercrop (female-managed plots)"
	lab var kg_yield_female_mixed_`crop' "Yield of `crop' - intercrop (male-managed plots)"
	lab var kg_yield_mixed_mixed_`crop' "Yield of `crop' - intercrop (mixed-managed plots)"				
}
save "$created_data\Ethiopia_ESS_LSMS_ISA_W3_yield_hh_crop_level.dta", replace


************************
*HOUSEHOLD VARIABLES
************************
use "$created_data/Ethiopia_ESS_LSMS_ISA_W3_male_head.dta", clear		// this should be most households
merge 1:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hhids.dta", nogen

*Area dta files
merge 1:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_household_area.dta", nogen
merge 1:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_farm_area.dta", nogen
merge 1:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_farmsize_all_agland.dta", nogen
merge 1:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_area_land", nogen
*Rental value, rent paid, and value of owned land
merge 1:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_rental_rate.dta", nogen
merge 1:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_rental_value.dta", nogen
merge 1:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_cost_land.dta", nogen
*yield
*Crop yields 
merge 1:1 household_id2 using "${created_data}/Ethiopia_ESS_LSMS_ISA_W3_yield_hh_crop_level.dta", nogen

*Post-planting inputs
merge 1:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_fert.dta", nogen
merge 1:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_eth_labor_group1", nogen
merge 1:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_pp_inputs_value.dta", nogen

*Post-harvest inputs
merge 1:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_eth_labor_group2", nogen
merge 1:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_cost_harv_labor.dta", nogen

*Other inputs
merge 1:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_cost_seed.dta", nogen

*Crop production and losses
merge 1:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_crop_production.dta", nogen
merge 1:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_losses.dta", nogen

*Use variables
merge 1:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hh_imprv_seed.dta", nogen
merge 1:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_ext_reach.dta", nogen
merge 1:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_vaccination", nogen
merge 1:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_fin_serv.dta", nogen

*Livestock expenses and production
merge 1:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_sales", nogen
merge 1:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_expenses", nogen
merge 1:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_livestock_products", nogen

*Non-agricultural income
merge 1:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_wage_income.dta", nogen
merge 1:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_self_employment_income.dta", nogen
merge 1:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_other_income.dta", nogen
merge 1:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_assistance_income.dta", nogen


* recoding and creating new variables
*Crop income
recode value_crop_production crop_value_lost value_rented_land value_transport_free_seed value_transport_purchased_seed value_purchased_seed value_fert value_hired_harv_labor value_hired_prep_labor value_transport_cropsales (.=0)
egen crop_production_expenses = rowtotal(value_rented_land value_transport_free_seed value_transport_purchased_seed value_purchased_seed value_fert value_hired_harv_labor value_hired_prep_labor value_transport_cropsales)
gen crop_income = value_crop_production - crop_production_expenses - crop_value_lost
lab var crop_production_expenses "Crop production expenditures (explicit)"
lab var crop_income "Net crop revenue (value of production minus crop expenses)"

*Farm size
ren area_meas_hectares_hh land_size
recode land_size (.=0) /* If no farm, then no farm area */

*Livestock income
recode value_livestock_sales value_livestock_purchases value_milk_produced value_eggs_produced earnings_milk_products /*
*/ cost_breeding_livestock cost_fodder_livestock cost_vaccines_livestock cost_treatment_livestock cost_water_livestock tlu_today (.=0)
gen livestock_income = value_livestock_sales - value_livestock_purchases /*
*/ + (value_milk_produced + value_eggs_produced + earnings_milk_products) /*
*/ - (cost_breeding_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_treatment_livestock + cost_water_livestock)
lab var livestock_income "Net livestock income (value of production and consumption minus expenditures)"

*Other income
recode annual_selfemp_profit annual_salary annual_salary_agwage transfer_income pension_income investment_income rental_income sales_income inheritance_income /*
*/ psnp_income assistance_income land_rental_income_upfront (.=0)
rename annual_selfemp_profit self_employment_income 

lab var self_employment_income "Income from self-employment (business)"
rename annual_salary wage_income
rename annual_salary_agwage agwage_income

egen other_income = rowtotal(transfer_income pension_income investment_income rental_income sales_income inheritance_income /*
*/ psnp_income assistance_income land_rental_income_upfront)
lab var other_income "Income from transfers, remittances, other revenue streams not captured elsewhere"

*Labor
egen labor_total = rowtotal(days_hired_pp days_nonhired_pp days_hired_harv days_nonhired_harv)		// JDM: "other" and fam are together in nonhired
egen labor_total_male = rowtotal(days_hired_pp_male days_nonhired_pp_male days_hired_harv_male days_nonhired_harv_male)
egen labor_total_female = rowtotal(days_hired_pp_female days_nonhired_pp_female days_hired_harv_female days_nonhired_harv_female)
egen labor_total_mixed = rowtotal(days_hired_pp_mixed days_nonhired_pp_mixed days_hired_harv_mixed days_nonhired_harv_mixed)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm in the past year"

*Agricultural households
gen ag_hh = (value_crop_production!=0 | livestock_income!=0 | (farm_area!=0 & farm_area!=.) | tlu_today!=0)
count if ag_hh==1 
tab rural
*br rural ag_hh interview_pp interview_postharvest value_crop_production livestock_income farm_area tlu_today
count if value_crop_production==. /* 15 don't have crop production. Were these only interviewed post-planting? */


*Bringing together income
global income_vars crop livestock /*fishing*/ self_employment wage agwage other 
foreach p of global income_vars {
_pctile `p'_income [aw=weight], p(1 99) /* This is for the whole country, not sure whether that's appropriate */
replace `p'_income = r(r1) if `p'_income < r(r1)  & `p'_income!=.
replace `p'_income = r(r2) if `p'_income > r(r2)  & `p'_income!=.
}
*Winsorizing at the low end seems wise because of very large negative values. For most variables, there is a long trail of 0s at the low end.
global wins_vars farm_area // farm_area added Oct. 1
foreach p of global wins_vars {
_pctile `p' [aw=weight], p(1 99) 
*replace `p' = r(r1) if `p' < r(r1) & `p'!=.
replace `p' = r(r2) if `p' > r(r2) & `p'!=. 
}

*Create final income variables
egen total_income = rowtotal(crop_income livestock_income /*fishing_income*/ self_employment_income wage_income agwage_income other_income)
egen nonfarm_income = rowtotal(/*fishing_income*/ self_employment_income wage_income other_income)
egen farm_income = rowtotal(crop_income livestock_income)
gen share_nonfarm = nonfarm_income/total_income
replace share_nonfarm = 0 if nonfarm_income < 0
replace share_nonfarm = . if total_income < 0
gen percapita_income = total_income/hh_members
global exchange_rate 21.2389
global ppp_dollar 8.60
global monetary_vars crop_income livestock_income percapita_income total_income nonfarm_income
foreach p of global monetary_vars {
gen `p'_ppp = `p' / ${ppp_dollar}
}
foreach p of global monetary_vars {
gen `p'_usd = `p' / ${exchange_rate}   
}


gen percapita_perday_income_usd = (total_income/hh_members) / ${exchange_rate} / 365
gen land_productivity = value_crop_production/farm_area
gen land_productivity_male = value_harvest_male/farm_area_male
gen land_productivity_female = value_harvest_female/farm_area_female
gen land_productivity_mixed = value_harvest_mixed/farm_area_mixed
gen labor_productivity = value_crop_production/labor_total
gen labor_productivity_male = value_harvest_male/labor_total_male
gen labor_productivity_female = value_harvest_female/labor_total_female
gen labor_productivity_mixed = value_harvest_mixed/labor_total_mixed
gen land_weight = pw_w3*farm_area
gen land_weight_female = pw_w3*farm_area_female
gen land_weight_male = pw_w3*farm_area_male
gen land_weight_mixed = pw_w3*farm_area_mixed
gen labor_weight = pw_w3*labor_total
gen labor_weight_female = pw_w3*labor_total_female
gen labor_weight_male = pw_w3*labor_total_male
gen labor_weight_mixed = pw_w3*labor_total_mixed
global productivity_vars land_productivity labor_productivity 
foreach p of global productivity_vars {
_pctile `p' [aw=weight], p(1 99) 
replace `p' = r(r1) if `p' < r(r1) & `p' != . 
replace `p' = r(r2) if `p' > r(r2) & `p' != . 
}
gen land_productivity_usd = land_productivity / ${exchange_rate}
gen land_productivity_male_usd = land_productivity_male / ${exchange_rate}
gen land_productivity_female_usd = land_productivity_female / ${exchange_rate}
gen land_productivity_mixed_usd = land_productivity_mixed / ${exchange_rate}
gen labor_productivity_usd = labor_productivity / ${exchange_rate}
gen labor_productivity_male_usd = labor_productivity_male / ${exchange_rate}
gen labor_productivity_female_usd = labor_productivity_female / ${exchange_rate}
gen labor_productivity_mixed_usd = labor_productivity_mixed / ${exchange_rate}


gen land_productivity_ppp = land_productivity / ${ppp_dollar}
gen land_productivity_male_ppp = land_productivity_male / ${ppp_dollar}
gen land_productivity_female_ppp = land_productivity_female / ${ppp_dollar}
gen land_productivity_mixed_ppp = land_productivity_mixed / ${ppp_dollar}
gen labor_productivity_ppp = labor_productivity / ${ppp_dollar}
gen labor_productivity_male_ppp = labor_productivity_male / ${ppp_dollar}
gen labor_productivity_female_ppp = labor_productivity_female / ${ppp_dollar}
gen labor_productivity_mixed_ppp = labor_productivity_mixed / ${ppp_dollar}


*Milk productivity
gen liters_per_cow = milk_liters_produced/animals_milked		// will be missing if animals_milked==0 (or ==.)
*Winsorize top 1 percent
winsor2 liters_per_cow, cuts(0 99) replace
*NOTE: The standard errors should be correct since we didn't do any imputing here
gen cattle_weight = pw_w3*animals_milked		// "Cattle weight"

*Egg productivity
gen eggs_per_hen = eggs_produced/egg_laying_hens		// will be missing if egg_laying_hens==0 (or ==.)
*Winsorize top 1 percent
winsor2 eggs_per_hen, cuts(0 99) replace
*NOTE: The standard errors should be correct since we didn't do any imputing here
gen hen_weight = pw_w3*egg_laying_hens		// "Hen weight"


*Crop production costs
recode ha_planted* (0=.)
*Winsorizing area before constructing
_pctile ha_planted, p(1 99)
foreach i in ha_planted ha_planted_male ha_planted_female ha_planted_mixed{
	replace `i' = r(r1) if `i'<r(r1)
	replace `i' = r(r2) if `i'>r(r2) & `i'!=.
}
*Total costs (implicit + explicit)
egen costs_total_hh = rowtotal(value_owned_land value_rented_land value_hired_prep_labor value_fam_prep_labor value_hired_harv_labor value_fam_harv_labor value_fert value_purchased_seed value_non_purchased_seed value_transport_purchased_seed value_transport_free_seed)
replace costs_total_hh = costs_total_hh/ha_planted
replace costs_total_hh = costs_total_hh/${exchange_rate}
sum costs_total_hh, d
count if costs_total_hh==0					// no zeros if we drop those that do not merge from the "rental rate" data (there should not be any zeros for households that actually cultivated a crop)
*Creating total costs by gender (excludes seeds)
foreach i in male female mixed{
	egen costs_total_hh_`i' = rowtotal(value_owned_land_`i' value_rented_land_`i' value_hired_prep_labor_`i' value_fam_prep_labor_`i' value_hired_harv_labor_`i' value_fam_harv_labor_`i' value_fert_`i')
	replace costs_total_hh_`i' = (costs_total_hh_`i'/ha_planted_`i')/${exchange_rate}
	lab var costs_total_hh_`i' "Crop production costs per hectare, all costs (`i'-managed plots)"
}
*Recoding zeros as missings
recode costs_total_hh* (0=.)		// should be no zeros for implicit costs
*Explicit costs only
egen costs_total_explicit_hh = rowtotal(value_rented_land value_hired_prep_labor value_hired_harv_labor value_fert value_purchased_seed value_transport_purchased_seed value_transport_free_seed)
replace costs_total_explicit_hh = costs_total_explicit_hh/ha_planted
replace costs_total_explicit_hh = costs_total_explicit_hh/${exchange_rate}
lab var costs_total_hh "Crop production costs per hectare, explicit costs"
sum costs_total_explicit_hh, d		// median is less than one-twentieth as large as implicit; mean is less than one-tenth	
count if costs_total_explicit_hh==0			// 761 zeros (but zeros are technically possible here)
*Creating explicit costs by gender (excludes seeds)
foreach i in male female mixed{
	egen costs_total_explicit_hh_`i' = rowtotal(value_rented_land_`i' value_hired_prep_labor_`i' value_hired_harv_labor_`i' value_fert_`i')
	replace costs_total_explicit_hh_`i' = (costs_total_explicit_hh_`i'/ha_planted_`i')/${exchange_rate}
	lab var costs_total_explicit_hh_`i' "Crop production costs per hectare, explicit costs (`i'-managed plots)"
}
lab var costs_total_explicit_hh "Crop production costs per hectare, explicit costs (`i'-managed plots)"
*Winsorizing top
_pctile costs_total_hh, p(99)
foreach i in costs_total_hh costs_total_hh_male costs_total_hh_female costs_total_hh_mixed{
	replace `i' = r(r1) if `i'>r(r1) & `i'!=.
}

_pctile costs_total_explicit_hh, p(99)
foreach i in costs_total_explicit_hh costs_total_explicit_hh_male costs_total_explicit_hh_female costs_total_explicit_hh_mixed{
	replace `i' = r(r1) if `i'>r(r1) & `i'!=.
}


*Creating area weights - note that we already trimmed ha_planted
gen area_weight = pw_w3*ha_planted
gen area_weight_male = pw_w3*ha_planted_male
gen area_weight_female = pw_w3*ha_planted_female
gen area_weight_mixed = pw_w3*ha_planted_mixed


*Fertilizer application rate
gen inorg_fert_rate = fert_inorg_kg/ha_planted
gen inorg_fert_rate_male = fert_inorg_kg_male/ha_planted_male
gen inorg_fert_rate_female = fert_inorg_kg_female/ha_planted_female
gen inorg_fert_rate_mixed = fert_inorg_kg_mixed/ha_planted_mixed
*Winsorizing top 1 percent
_pctile inorg_fert_rate, p(99)
foreach i in inorg_fert_rate inorg_fert_rate_male inorg_fert_rate_female inorg_fert_rate_mixed{
	replace `i' = r(r1) if `i'>r(r1) & `i'!=.
}

gen all_wage_usd = all_wage/${exchange_rate}
gen wage_male_usd = wage_male/${exchange_rate}
gen wage_female_usd = wage_female/${exchange_rate}


***************
*IDENTIFY SMALLHOLDER FARMERS
***************
global small_farmer_vars land_size tlu_today total_income
foreach p of global small_farmer_vars {
gen `p'_aghh = `p' if ag_hh==1
_pctile `p'_aghh [aw=pw_w3], p(40) 
gen small_`p' = (`p' <= r(r1))
replace small_`p' = . if ag_hh!=1
}
gen small_farm_household = (small_land_size==1 & small_tlu_today==1 & small_total_income==1)
replace small_farm_household = . if ag_hh != 1
sum small_farm_household if ag_hh==1 [aw=weight] 
lab var small_farm_household "1= HH is in bottom 40th percentiles of land size, TLU, and total revenue"
*Labeling
lab var total_income "Total household income in local currency"
lab var share_nonfarm "Share of household income derived from nonfarm sources"
lab var percapita_income "Household incom per household member per day, in the local currency"
lab var land_productivity "Gross crop income per hectare cultivated"
lab var land_productivity_male "Gross crop income per hectare cultivated, male plots"
lab var land_productivity_female "Gross crop income per hectare cultivated, female plots"
lab var land_productivity_mixed "Gross crop income per hectare cultivated, mixed plots"
lab var labor_productivity "Gross crop income per labor-day on the farm"
lab var labor_productivity_male "Gross crop income per labor-day on the farm, male plots"
lab var labor_productivity_female "Gross crop income per labor-day on the farm, female plots"
lab var labor_productivity_mixed "Gross crop income per labor-day on the farm, mixed plots"
lab var ag_hh "1= Household has some land cultivated, some livestock, some crop income, or some livestock income"
lab var farm_income "Farm income (2016 USD)"
lab var crop_income_usd "Crop income (2016 USD)"
lab var livestock_income_usd "Livestock income (2016 USD)"
lab var percapita_income_usd "Per capita income (2016 USD)"
lab var total_income_usd "Total household income (2016 USD)"
lab var nonfarm_income_usd "Nonfarm income (excludes agricultural wages)(2016 USD)"
lab var percapita_perday_income_usd "Income per capita per day (2016 USD)"
lab var land_productivity_usd "Land productivity (gross value production per ha cultivated) (2016 USD)"
lab var land_productivity_male_usd "Gross crop income per hectare cultivated, male plots (2016 USD)"
lab var land_productivity_female_usd "Gross crop income per hectare cultivated, female plots (2016 USD)"
lab var land_productivity_mixed_usd "Gross crop income per hectare cultivated, mixed plots (2016 USD)"
lab var labor_productivity_usd "Labor productivity (gross value production per labor day on the farm) (2016 USD)"
lab var labor_productivity_male_usd "Gross crop income per labor-day on the farm, male plots (2016 USD)"
lab var labor_productivity_female_usd "Gross crop income per labor-day on the farm, female plots (2016 USD)"
lab var labor_productivity_mixed_usd "Gross crop income per labor-day on the farm, mixed plots (2016 USD)"
lab var nonfarm_income "Non farm income (local currency)"
lab var inorg_fert_rate "Fertilizer application rate per hectare"
lab var inorg_fert_rate_male "Fertilizer application rate per hectare (male-managed plots)"
lab var inorg_fert_rate_female "Fertilizer application rate per hectare (female-managed plots)"
lab var inorg_fert_rate_mixed "Fertilizer application rate per hectare (mixed-managed plots)"
lab var area_weight "Weight for area-planted indicators"
lab var area_weight_male "Weight for area-planted indicators, male-managed plots"
lab var area_weight_female "Weight for area-planted indicators, female-managed plots"
lab var area_weight_mixed "Weight for area-planted indicators, mixed-managed plots"
lab var liters_per_cow "Milk Productivity"
lab var eggs_per_hen "Egg Productivity"
lab var cattle_weight "Weight for milk productivity"
lab var hen_weight "Weight for egg productivity"
lab var costs_total_hh "Crop production costs per hectare, all costs"
lab var land_weight "Weight for land productivity"
lab var land_weight_female "Weight for land productivity, female-managed plots"
lab var land_weight_male "Weight for land productivity, male-managed plots"
lab var land_weight_mixed "Weight for land productivity, mixed-managed plots"
lab var labor_weight "Weight for labor productivity"
lab var labor_weight_female "Weight for labor productivity, female-managed plots"
lab var labor_weight_male "Weight for labor productivity, male-managed plots"
lab var labor_weight_mixed "Weight for labor productivity, mixed-managed plots"
lab var farm_size_agland "Average household farm size"
lab var all_wage_usd "Daily agricultural wage (2016 USD)"
lab var wage_male_usd "Daily male agricultural wage (2016 USD)"
lab var wage_female_usd "Daily female agricultural wage (2016 USD)"
lab var proportion_cropvalue_sold "Share of production marketed (i.e. sold)"
lab var household_id2 "Household ID"
lab var region "Region"
lab var zone "Zone"
lab var woreda "Woreda"
lab var town "Town"
lab var subcity "Subcity"
lab var kebele "Kebele"
lab var ea "Enumeration area"
lab var nonfarm_income "Nonfarm income (excludes agricultural wages)"
drop labor_group
lab var labor_total_male "Total male labor days (hired +family) allocated to the farm in the past year"
lab var labor_total_female "Total female labor days (hired +family) allocated to the farm in the past year"
lab var labor_total_mixed "Total mixed labor days (hired +family) allocated to the farm in the past year"
lab var crop_income_ppp "Crop income (PPP $)"
lab var livestock_income_ppp "Livestock income (PPP $)"
lab var percapita_income_ppp "Per capita income (PPP $)"
lab var total_income_ppp "Total household income (PPP $)"
lab var nonfarm_income_ppp "Nonfarm income (excludes agricultural wages)(PPP $)"
lab var land_productivity_ppp "Land productivity (gross value production per ha cultivated) (PPP $)"
drop land_size_aghh small_land_size tlu_today_aghh small_tlu_today total_income_aghh small_total_income
lab var land_productivity_ppp "Land productivity (gross value production per ha cultivated) (PPP $)"
lab var land_productivity_female_ppp "Land productivity  (gross value production per ha cultivated), female plots (PPP $)"
lab var land_productivity_male_ppp "Land productivity  (gross value production per ha cultivated), male plots (PPP $)"
lab var land_productivity_mixed_ppp "Land productivity  (gross value production per ha cultivated), mixed plots (PPP $)"
lab var labor_productivity_ppp "Labor productivity (gross value production per labor day on the farm) (PPP $)"
lab var labor_productivity_male_ppp "Gross crop income per labor-day on the farm, male plots (PPP $)"
lab var labor_productivity_female_ppp "Gross crop income per labor-day on the farm, female plots (PPP $)"
lab var labor_productivity_mixed_ppp "Gross crop income per labor-day on the farm, mixed plots (PPP $D)"
save "$final_data/Ethiopia_ESS_LSMS_ISA_W3_household_variables.dta", replace



///////////////////
//               //
//     FIELD     //
//     LEVEL     //
//               //
///////////////////
use "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_production_field.dta", clear
merge 1:1 household_id2 holder_id parcel_id field_id using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_field_area.dta", nogen keep(1 3)
merge 1:1 household_id2 holder_id parcel_id field_id using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_field_gender_dm.dta", nogen keep(1 3)
merge m:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_male_head.dta", nogen keep(1 3)		// weights
merge m:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hhids.dta", nogen

_pctile area_meas_hectares, p(1 99)
replace area_meas_hectares = r(r1) if area_meas_hectares<r(r1)
replace area_meas_hectares = r(r2) if area_meas_hectares>r(r2) & area_meas_hectares!=.

*exchange rate
global exchange_rate 21.2389
gen field_value_harvest_usd = field_value_harvest/$exchange_rate
gen plot_productivity = field_value_harvest_usd / area_meas_hectares

_pctile plot_productivity, p(99)
replace plot_productivity = r(r1) if plot_productivity>r(r1) & plot_productivity!=.

*One negative plot area
replace area_meas_hectares=. if area_meas_hectares<0
* Generate plot level weights
gen area_weight=pw_w3*area_meas_hectares

sum plot_productivity [aweight=area_weight]
sum plot_productivity [aweight=area_weight] if dm_gender==1
sum plot_productivity [aweight=area_weight] if dm_gender==2
sum plot_productivity [aweight=area_weight] if dm_gender==3

*Gender-based productivity gap, method 1 : (Mean_Male-Mean_Female)/Mean_Male
sum plot_productivity  [aw=area_weight]   if dm_gender==1
gen male_productivity1=r(mean)
sum plot_productivity  [aw=area_weight]   if dm_gender==2  
gen female_productivity1=r(mean)
gen gender_prod_gap1=100*(male_productivity1-female_productivity1)/male_productivity1

sum male_productivity1 female_productivity1 gender_prod_gap1

lab var household_id2 "Household ID"
lab var region "Region"
lab var zone "Zone"
lab var woreda "Woreda"
lab var town "Town"
lab var subcity "Subcity"
lab var kebele "Kebele"
lab var ea "Enumeration area"
lab var rural "1= Rural"
lab var pw_w3 "Household weight"
lab var area_weight "Weight for area-planted indicators"
lab var plot_productivity "Value of crop production per hectare (plot-level)"
lab var field_value_harvest_usd "Value of harvest (USD)"
lab var field_value_harvest "Value of harvest (local currency)"
lab var male_productivity1 "Productivity per hectare, male-managed plots"
lab var female_productivity1 "Productivity per hectare, female-managed plots"
lab var gender_prod_gap1 "Gender productivity gap"
save "$final_data/Ethiopia_ESS_LSMS_ISA_W3_field_variables.dta", replace



**************
*INDIVIDUAL-LEVEL VARIABLES
**************
use "$created_data/Ethiopia_ESS_LSMS_ISA_W3_control_income.dta", clear
merge 1:1 household_id2 personid using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_ag_decision.dta", nogen keep(1 3)
merge 1:1 household_id2 personid using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_women_asset.dta", nogen keep(1 3)
merge m:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_male_head.dta", nogen keep(1 3)
merge m:1 household_id2 using "$created_data/Ethiopia_ESS_LSMS_ISA_W3_hhids.dta", nogen
lab var personid "Person ID"
lab var household_id2 "Household ID"
lab var region "Region"
lab var zone "Zone"
lab var woreda "Woreda"
lab var town "Town"
lab var subcity "Subcity"
lab var kebele "Kebele"
lab var ea "Enumeration area"
lab var rural "1= Rural"
lab var pw_w3 "Household weight"
lab var women_control_all_income "Invidual has control over at least one type of income"
lab var women_decision_ag "Invidual makes decision about livestock production activities"
lab var women_asset "Invidual owns an assets (land or livestock)"
save "$final_data/Ethiopia_ESS_LSMS_ISA_W3_individual_variables.dta", replace












*End of dta creation. Below is output of summary statistics



**************
*SUMMARY STATISTICS
************** 
/*
All the pre-processed files include all households, individuals, and plots in the sample. 
The summary statistics are outputted only for the sub_population of households, individuals, and plots in rural areas. 
To consider a different sup_population or the entire sample, you have to modify the condition "if rural==1".
*/ 

use "$created_data/Ethiopia_ESS_LSMS_ISA_W3_household_variables.dta", clear
** Statistics list 1 -   share_nonfarm nonfarm_income_usd total_income_usd all_wage_usd
global household_indicators1 share_nonfarm nonfarm_income_usd total_income_usd   
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

use "$created_data/Ethiopia_ESS_LSMS_ISA_W3_household_variables.dta", clear
** Statistics list 2 - labor_productivity_usd land_productivity_usd
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



*Yield: Bean
use "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_bean.dta", clear
ren kg_yield kg_yield_all
ren area_weight area_weight_all
matrix bean_all=(.,.,.,.,.,.,.,.,.,.)
global bean all female male mixed  
foreach v of global bean  {
	tabstat  kg_yield_`v' [aw=area_weight_`v']  if rural==1  , stat(mean semean sd p25 p50 p75  min max N) col(stat) save
	matrix temp_bean=r(StatTotal)'
	svyset clusterid [pweight=area_weight_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean
	svy, subpop(if rural==1): mean kg_yield_`v'
	matrix temp_bean=temp_bean,el(r(table),2,1)
	matrix bean_all=bean_all\temp_bean
}
*Yield: Bean Pure Stand
ren area_weight_purestand area_weight_all_pure
matrix bean_pure=(.,.,.,.,.,.,.,.,.,.)
global bean_pure all female male mixed  
foreach v of global bean  {
	tabstat  kg_yield_`v' [aw=area_weight_`v'_pure]  if rural==1  , stat(mean semean sd p25 p50 p75  min max N) col(stat) save
	matrix temp_bean=r(StatTotal)'
	svyset clusterid [pweight=area_weight_`v'_pure], strata(strataid) singleunit(centered) // get standard errors of the mean
	svy, subpop(if rural==1): mean kg_yield_`v'
	matrix temp_bean=temp_bean,el(r(table),2,1)
	matrix bean_pure=bean_pure\temp_bean
}
*Yield: Maize
use "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_maize.dta", clear
ren kg_yield kg_yield_all
ren area_weight area_weight_all
matrix maize_all=(.,.,.,.,.,.,.,.,.,.)
global maize all female male mixed  
foreach v of global maize  {
	tabstat  kg_yield_`v' [aw=area_weight_`v']  if rural==1  , stat(mean semean sd p25 p50 p75  min max N) col(stat) save
	matrix temp_maize=r(StatTotal)'
	svyset clusterid [pweight=area_weight_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean
	svy, subpop(if rural==1): mean kg_yield_`v'
	matrix temp_maize=temp_maize,el(r(table),2,1)
	matrix maize_all=maize_all\temp_maize
}
*Yield: maize Pure Stand
ren area_weight_purestand area_weight_all_pure
matrix maize_pure=(.,.,.,.,.,.,.,.,.,.)
global maize_pure all female male mixed  
foreach v of global maize  {
	tabstat  kg_yield_`v' [aw=area_weight_`v'_pure]  if rural==1  , stat(mean semean sd p25 p50 p75  min max N) col(stat) save
	matrix temp_maize=r(StatTotal)'
	svyset clusterid [pweight=area_weight_`v'_pure], strata(strataid) singleunit(centered) // get standard errors of the mean
	svy, subpop(if rural==1): mean kg_yield_`v'
	matrix temp_maize=temp_maize,el(r(table),2,1)
	matrix maize_pure=maize_pure\temp_maize
}
*Yield: Sorghum
use "$created_data/Ethiopia_ESS_LSMS_ISA_W3_crop_sorghum.dta", clear
ren kg_yield kg_yield_all
ren area_weight area_weight_all
matrix sorghum_all=(.,.,.,.,.,.,.,.,.,.)
global sorghum all female male mixed  
foreach v of global sorghum  {
	tabstat  kg_yield_`v' [aw=area_weight_`v']  if rural==1  , stat(mean semean sd p25 p50 p75  min max N) col(stat) save
	matrix temp_sorghum=r(StatTotal)'
	svyset clusterid [pweight=area_weight_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean
	svy, subpop(if rural==1): mean kg_yield_`v'
	matrix temp_sorghum=temp_sorghum,el(r(table),2,1)
	matrix sorghum_all=sorghum_all\temp_sorghum
}
*Yield: sorghum Pure Stand
ren area_weight_purestand area_weight_all_pure
matrix sorghum_pure=(.,.,.,.,.,.,.,.,.,.)
global sorghum_pure all female male mixed  
foreach v of global sorghum  {
	tabstat  kg_yield_`v' [aw=area_weight_`v'_pure]  if rural==1  , stat(mean semean sd p25 p50 p75  min max N) col(stat) save
	matrix temp_sorghum=r(StatTotal)'
	svyset clusterid [pweight=area_weight_`v'_pure], strata(strataid) singleunit(centered) // get standard errors of the mean
	svy, subpop(if rural==1): mean kg_yield_`v'
	matrix temp_sorghum=temp_sorghum,el(r(table),2,1)
	matrix sorghum_pure=sorghum_pure\temp_sorghum
}

matrix final_indicator4=bean_all\bean_pure\maize_all\maize_pure\sorghum_all\sorghum_pure

use "$final_data/Ethiopia_ESS_LSMS_ISA_W3_household_variables.dta", clear
** Statistics list 5  - milk and egg productivities
global household_indicators5 liters_per_cow
global final_indicator5  
foreach v of global household_indicators5 {
	gen `v'_female_hh=`v' if fhh==1
	gen `v'_male_hh=`v' if fhh==0
	global final_indicator5 $final_indicator5 `v'  `v'_female_hh  `v'_male_hh
}

global milkvar liters_per_cow liters_per_cow_female_hh liters_per_cow_male_hh
tabstat $milkvar  [aw=cattle_weight] if rural==1 , stat(mean semean sd p25 p50 p75  min max N) col(stat) save 
matrix final_indicator5=r(StatTotal)' 
qui svyset clusterid [pweight=cattle_weight], strata(strataid) singleunit(centered) // get standard errors of the mean	
matrix semean5=(.)
matrix colnames semean5=semean_wei
foreach v of global milkvar {
	qui svy, subpop(if rural==1): mean `v'
	matrix semean5=semean5\(el(r(table),2,1))
}
matrix final_indicator5=final_indicator5,semean5[2..rowsof(semean5),.]

gen eggs_per_hen_female=eggs_per_hen if fhh==1
gen eggs_per_hen_male=eggs_per_hen if fhh==0

global eggvar eggs_per_hen  eggs_per_hen_female eggs_per_hen_male
tabstat $eggvar [aw=hen_weight] if rural==1, stat(mean semean sd p25 p50 p75  min max N) col(stat) save
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
global household_indicators7  percapita_income_usd  crop_income_usd livestock_income_usd
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
drop area_weight_*
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
ren costs_total_hh  costs_total_hh_all 
*gen area_weight_all=area_weight
global final_indicator12 all female male  mixed
matrix final_indicator12=(.,.,.,.,.,.,.,.,.,.)
foreach v of global final_indicator12 {
	tabstat costs_total_hh_`v'  [aw=area_weight_`v']  if rural==1 & ag_hh==1, stat(mean semean sd p25 p50 p75  min max N) col(stat) save
	matrix temp12=r(StatTotal)'
	qui svyset clusterid [pweight=area_weight_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean	
	capture noisily qui svy, subpop(if rural==1 & ag_hh==1): mean costs_total_hh_`v'
	matrix final_indicator12=final_indicator12\(temp12,el(r(table),2,1))
}
matrix final_indicator12 =final_indicator12[2..rowsof(final_indicator12), .]
matrix list final_indicator12 

 
** Statistics list 13 - costs_total_explicit_hh_usd
ren costs_total_explicit_hh costs_total_explicit_hh_all
global final_indicator13 all female male  mixed
matrix final_indicator13=(.,.,.,.,.,.,.,.,.,.)
foreach v of global final_indicator13 {
	tabstat costs_total_explicit_hh_`v'   [aw=area_weight_`v']   if rural==1 & ag_hh==1, stat(mean semean sd p25 p50 p75  min max N) col(stat) save
	matrix temp13=r(StatTotal)'
	qui svyset clusterid [pweight=area_weight_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean	
	capture noisily qui svy, subpop(if rural==1 & ag_hh==1): mean costs_total_explicit_hh_`v'
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

** Statistics list 3 - plot_productivity
use  "${final_data}\Ethiopia_ESS_LSMS_ISA_W3_field_variables.dta",  clear
*(Mean_Male-Mean_Female)/Mean_Male

qui svyset clusterid [pweight=area_weight], strata(strataid) singleunit(centered) // get standard errors of the mean
tabstat plot_productivity  [aw=area_weight]  if rural==1 & dm_gender!=.    , stat(mean semean sd p25 p50 p75  min max N) col(stat) save
matrix temp_all=r(StatTotal)'
qui svy, subpop(if rural==1 & dm_gender!=. ): mean plot_productivity
matrix plot_productivity_all_usd=temp_all,el(r(table),2,1)
 

tabstat plot_productivity  [aw=area_weight]   if rural==1 & dm_gender==1 , stat(mean semean sd p25 p50 p75  min max N) col(stat) save
matrix temp_female=r(StatTotal)'
qui svy, subpop(if rural==1 & dm_gender==1): mean plot_productivity
matrix plot_productivity_female_usd=temp_female,el(r(table),2,1)
 
tabstat plot_productivity  [aw=area_weight]   if rural==1 & dm_gender==2 , stat(mean semean sd p25 p50 p75  min max N) col(stat) save
matrix temp_male=r(StatTotal)'
qui svy, subpop(if rural==1 & dm_gender==2): mean plot_productivity
matrix plot_productivity_male_usd=temp_male,el(r(table),2,1)
 
tabstat plot_productivity  [aw=area_weight]   if rural==1 & dm_gender==3 , stat(mean semean sd p25 p50 p75  min max N) col(stat) save
matrix temp_mixed=r(StatTotal)'
qui svy, subpop(if rural==1 & dm_gender==3): mean plot_productivity
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
*keep only adult women
use "${final_data}/Ethiopia_ESS_LSMS_ISA_W3_individual_variables.dta", clear
*ren pw_w3 weight
gen  female=mem_gender==2
ren mem_age age
keep if female==1
keep if age>=18
ren women_control_all_income women_control_income
global household_indicators15 women_control_income women_decision_ag women_asset    /*number_foodgroup women_diet*/
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

*all together
matrix final_indicator_all =(.,.,.,.,.,.,.,.,.,.)
forvalue i=1/16 {
	matrix final_indicator_all=final_indicator_all\final_indicator`i'
}
matrix final_indicator_all =final_indicator_all[2..rowsof(final_indicator_all), .] 
matrix list final_indicator_all 
matrix colname final_indicator_all =  mean semean_simple sd p25 p50 p75 min max N semean_strata
* in excel
putexcel set "$final_data\Ethiopia_ESS_LSMS_ISA_W3_summary_stats.xlsx", replace
putexcel A1=matrix(final_indicator_all)  , names 


