
/*-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of a set of agricultural development indicators 
				  using the Ethiopia Socioeconomic Survey (ESS) LSMS-ISA Wave 2 (2013-14)
*Author(s)		: Jack Knauer, David Coomes, Didier Alia, Ayala Wineman, Josh Merfeld, Pierre Biscaye, C. Leigh Anderson, &  Travis Reynolds

*Acknowledgments: We acknowledge the helpful contributions of members of the World Bank's LSMS-ISA team, the FAO's RuLIS team, IFPRI, IRRI, 
				  and the Bill & Melinda Gates Foundation Agricultural Development Data and Policy team in discussing indicator construction decisions. 
				  All coding errors remain ours alone.
*Date			: This  Version - 24 July 2019
----------------------------------------------------------------------------------------------------------------------------------------------------*/

*Data source
*-----------
*The Ethiopia Socioeconomic Survey was collected by the Ethiopia Central Statistical Agency (CSA) 
*and the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture(LSMS - ISA)
*The data were collected over the period September - November 2013, and February - April 2014.
*All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
*http://microdata.worldbank.org/index.php/catalog/2783

*Throughout the do-file, we sometimes use the shorthand LSMS to refer to the Ethiopia Socioeconomic Survey.gr

*Summary of Executing the Master do.file
*-----------
*This Master do.file constructs selected indicators using the Ethiopia ESS data set.
*Using data files from within the "Raw DTA files" folder within the "Ethiopia ESS Wave 2" folder, 
*the do.file first constructs common and intermediate variables, saving dta files when appropriate 
*in the folder "created_data" within the "Final DTA files" folder.
*These variables are then brought together at the household, plot, or individual level, saving dta files at each level when available 
*in the "Final DTA files" folder.

*The processed files include all households, individuals, and plots in the sample.
*Toward the end of the do.file, a block of code estimates summary statistics (mean, standard error of the mean, minimum, first quartile, median, third quartile, maximum) 
*of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager.
*The results are outputted in the excel file "Ethiopia_ESS_W2_summary_stats.rtf" in the "Final DTA files" folder.
*It is possible to modify the condition  "if rural==1" in the portion of code following the heading "SUMMARY STATISTICS" to generate all summary statistics for a different sub_population.

*The following refer to running this Master do.file with EPAR's cleaned data files. Information on EPAR's cleaning and construction decisions is available in the documents
*"EPAR_UW_335_Indicator Construction Summary Tables" and "EPAR_UW_335_General Considerations and Principles for Indicator Construction.docx" within the folder "Supporting documents".

 
/*OUTLINE OF THE DO.FILE
Below are the list of the main files created by running this Master do.file

*MAIN INTERMEDIATE FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD IDS						Ethiopia_ESS_W2_hhids.dta
*WEIGHTS AND GENDER OF HEAD			Ethiopia_ESS_W2_male_head
*INDIVIDUAL GENDER					Ethiopia_ESS_W2_gender_merge_both.dta
*PLOT-CROP DECISION MAKERS			Ethiopia_ESS_W2_field_gender_dm.dta

*PLOT AREA							Ethiopia_ESS_W2_field_area.dta
*AGRICULTURAL LAND DUMMY AND AREA 	Ethiopia_ESS_W2_fields_agland.dta
*AG LAND AREA HOUSEHOLD				Ethiopia_ESS_W2_farmsize_all_agland.dta

*MONOCROPPED CROPS					Ethiopia_ESS_W2_[CROP]_monocrop_hh_area.dta

*GROSS CROP PRODUCTION				Ethiopia_ESS_W2_crop_production_household.dta
	PARCEL							Ethiopia_ESS_W2_crop_production_parcel.dta
	PLOT							Ethiopia_ESS_W2_crop_production_field.dta
	CROP LOSSES						Ethiopia_ESS_W2_crop_losses.dta

*CROP EXPENSES
	PLANTING LABOR					Ethiopia_ESS_W2_wages_postplanting.dta
	HARVEST LABOR					Ethiopia_ESS_W2_wages_postharvest.dta
	FERTILIZER						Ethiopia_ESS_W2_fertilizer_costs.dta
	SEEDS							Ethiopia_ESS_W2_seed_costs.dta
	LAND RENTAL						Ethiopia_ESS_W2_land_rental_costs.dta
	CROP TRANSPORT					Ethiopia_ESS_W2_transportation_cropsales.dta
	
*LIVESTOCK EXPENSES					Ethiopia_ESS_W2_livestock_expenses.dta
*LIVESTOCK PRODUCTS					Ethiopia_ESS_W2_livestock_products.dta
*LIVESTOCK SALES					Ethiopia_ESS_W2_livestock_sales.dta
*TROPICAL LIVESTOCK UNIT			Ethiopia_ESS_W2_TLU.dta
									Ethiopia_ESS_W2_TLU_Coefficients.dta

*SELF EMPLOYMENT INCOME				Ethiopia_ESS_W2_self_employment_income.dta
*WAGE INCOME						Ethiopia_ESS_W2_wage_income.dta
*AG WAGE INCOME						Ethiopia_ESS_W2_agwage_income.dta
*OTHER INCOME						Ethiopia_ESS_W2_other_income.dta
*ASSISTANCE INCOME					Ethiopia_ESS_W2_assistance_income.dta
*RENTAL INCOME						Ethiopia_ESS_W2_land_rental_income.dta

*OFF-FARM HOURS						Ethiopia_ESS_W2_off_farm_hours.dta

*FARM LABOR							Ethiopia_ESS_W2_farmlabor_postplanting.dta 
									Ethiopia_ESS_W2_farmlabor_postharvest.dta

*FARM SIZE							Ethiopia_ESS_W2_land_size.dta
*LAND SIZE							Ethiopia_ESS_W2_land_size_all.dta

*VACCINE USE						Ethiopia_ESS_W2_vaccine.dta
									Ethiopia_ESS_W2_farmer_vaccine.dta
									
*ANIMAL HEALTH						Ethiopia_ESS_W2_livestock_diseases.dta
									
*INORGANIC FERTILIZER USE			Ethiopia_ESS_W2_fert_use.dta
									Ethiopia_ESS_W2_farmer_fert_use.dta
									
*IMPROVED SEED USE					Ethiopia_ESS_W2_improvedseed_use
									Ethiopia_ESS_W2_farmer_improvedseed_use_[CROP].dta
									
*AG EXTENSION USE					Ethiopia_ESS_W2_any_ext.dta
*FINANCIAL SERVICES USE				Ethiopia_ESS_W2_fin_serv.dta

*MILK PRODUCTIVITY					Ethiopia_ESS_W2_milk_animals.dta
*EGG PRODUCTIVITY					Ethiopia_ESS_W2_eggs_animals.dta

*CROP PRODUCTION COSTS PER HECTARE
	LAND RENTAL VALUE				Ethiopia_ESS_W2_hh_rental_value.dta
	VALUE OF OWNED LAND				Ethiopia_ESS_W2_hh_cost_land.dta
	PLANTING INPUT COST				Ethiopia_ESS_W2_hh_pp_inputs_value.dta
	HARVEST LABOR COST				Ethiopia_ESS_W2_hh_cost_harv_labor.dta
	SEED COST						Ethiopia_ESS_W2_hh_cost_seed.dta

*AGRICULTURAL WAGES					Ethiopia_ESS_W2_ag_wage.dta

*FERTILIZER APPLICATION RATE		Ethiopia_ESS_W2_fertilizer_application.dta
*DIETARY DIVERSITY					Ethiopia_ESS_W2_household_diet.dta

*WOMEN'S OWNERSHIP OF ASSETS		Ethiopia_ESS_W2_women_asset.dta
*WOMNE'S CONTROL OF AG DECISION		Ethiopia_ESS_W2_ag_decision.dta
*WOMEN'S CONTROL OF INCOME			Ethiopia_ESS_W2_control_income.dta

*CROP YIELDS						Ethiopia_ESS_W2_yield_hh_level.dta
*SHANNON DIVERSITY INDEX			Ethiopia_ESS_W2_shannon_diversity_index.dta
*CONSUMPTION						Ethiopia_ESS_W2_consumption.dta
*HOUSEHOLD FOOD PROVISION			Ethiopia_ESS_LSMS_W2_food_insecurity.dta
	
*FINAL FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD-LEVEL VARIABLES			Ethiopia_ESS_W2_household_variables.dta
*FIELD-LEVEL VARIABLES				Ethiopia_ESS_W2_field_plot_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			Ethiopia_ESS_W2_individual_variables.dta	
*SUMMARY STATISTICS					Ethiopia_ESS_W2_summary_stats.xlsx

*/
	
	
clear
clear matrix
clear mata
set more off
set maxvar 10000		
ssc install findname	// need this user-written ado file for some commands to work	

*Set location of raw data and output
global directory					"\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\335 - Ag Team Data Support\Waves"

//Set directories
*These paths indicate where the raw data files are located and where the created data and final data will be stored.
global Ethiopia_ESS_W2_raw_data 				"$directory\Ethiopia ESS\Ethiopia ESS Wave 2\Raw DTA Files\ETH_2013_ESS_v02_M_Stata8"
global Ethiopia_ESS_W2_created_data			"$directory\Ethiopia ESS\Ethiopia ESS Wave 2\Final DTA Files\created_data"
global Ethiopia_ESS_W2_final_data			"$directory\Ethiopia ESS\Ethiopia ESS Wave 2\Final DTA Files\final_data"
 
 
********************************************************************************
*THRESHOLDS FOR WINSORIZATION
********************************************************************************
global wins_lower_thres 1   						//  Threshold for winzorization at the bottom of the distribution of continous variables
global wins_upper_thres 99							//  Threshold for winzorization at the top of the distribution of continous variables

********************************************************************************
*GLOBALS OF PRIORITY CROPS //change these globals if you are interested in different crops
********************************************************************************
////Limit crop names in variables to 6 characters or the variable names will be too long! 
global topcropname_area "maize rice wheat sorgum millet grdnt beans yam swtptt cassav banana teff barley coffee sesame hsbean nueg"		
global topcrop_area "2 5 8 6 3 24 12 95 62 10 42 7 1 72 27 13 25"
global comma_topcrop_area "2, 5, 8, 6, 3, 24, 12, 95, 62, 10, 42, 7, 1, 72, 27, 13, 25"
global topcropname_full "maize rice wheat sorghum millet groundnut beans yam sweetpotato cassava banana teff barley coffee sesame horsebean nueg"
global nb_topcrops : word count $topcrop_area

********************************************************************************
*EXCHANGE RATE AND INFLATION FOR CONVERSION IN SUD IDS
************************
global Ethiopia_ESS_W2_exchange_rate 21.2389	//https://www.bloomberg.com/quote/USDETB:CUR
global Ethiopia_ESS_W2_gdp_ppp_dollar 8.668		// https://data.worldbank.org/indicator/PA.NUS.PPP
global Ethiopia_ESS_W2_cons_ppp_dollar 8.674	// https://data.worldbank.org/indicator/PA.NUS.PPP
global Ethiopia_ESS_W2_inflation 0.181363  		// inflation rate 2014-2016. Data was collectedduring 2013-2013. We want to ajhust value to 2016


********************************************************************************
*HOUSEHOLD IDS
********************************************************************************
use "${Ethiopia_ESS_W2_raw_data}/sect_cover_hh_w2.dta", clear
ren saq01 region
ren saq02 zone
ren saq03 woreda
ren saq04 town
ren saq05 subcity
ren saq06 kebele
ren saq07 ea
ren saq08 household
ren pw2 weight
ren rural rural2
gen rural = (rural2==1)
lab var rural "1=Rural"
keep region zone woreda town subcity kebele ea household rural household_id2 weight
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hhids.dta", replace


********************************************************************************
*WEIGHTS AND GENDER OF HEAD
********************************************************************************
use "${Ethiopia_ESS_W2_raw_data}/sect1_hh_w2.dta", clear
gen fhh = hh_s1q03==2 if hh_s1q02==1		// assuming missing is male 
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
collapse (max) fhh (firstnm) pw2 clusterid strataid (sum) hh_members, by(household_id2)
lab var hh_members "Number of household members"
lab var fhh "1=Female-headed household"
lab var strataid "Strata ID (updated) for svyset"
lab var clusterid "Cluster ID for svyset"
lab var pw2 "Household weight"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_male_head.dta", replace


********************************************************************************
*INDIVIDUAL GENDER
********************************************************************************
*Using gender from planting and harvesting
use "${Ethiopia_ESS_W2_raw_data}/sect1_ph_w2.dta", clear
gen personid = ph_s1q00
gen female = ph_s1q03==2	// NOTE: Assuming missings are MALE
*dropping duplicates (data is at holder level so some individuals are listed multiple times, we only need one record for each)
duplicates drop household_id2 personid, force
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_gender_merge_ph.dta", replace		// only post-harvest
*Harvest
use "${Ethiopia_ESS_W2_raw_data}/sect1_pp_w2.dta", clear
ren pp_s1q00 personid
gen female =pp_s1q03==2	// NOTE: Assuming missings are MALE
duplicates drop household_id2 personid, force
merge 1:1 household_id2 personid using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_gender_merge_ph.dta", nogen // keeping ALL; this should be a list of every individual in any roster file
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_gender_merge_both.dta", replace


********************************************************************************
*PLOT DECISION-MAKERS
********************************************************************************
*Gender/age variables
use "${Ethiopia_ESS_W2_raw_data}/sect3_pp_w2.dta", clear
gen cultivated = pp_s3q03==1			// if plot was cultivated
*First owner/decision maker
gen personid = pp_s3q10a
merge m:1 household_id2 personid using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_gender_merge_both.dta", gen(dm1_merge) keep(1 3)			// Dropping unmatched from using
tab dm1_merge cultivate		// Almost all unmatched observations are due to field not being cultivated
gen dm1_female = female
drop female personid
*Second owner/dec
gen personid = pp_s3q10c_a
merge m:1 household_id2 personid using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_gender_merge_both.dta", gen(dm2_merge) keep(1 3)			// Dropping unmatched from using
gen dm2_female = female
drop female personid
*Third
gen personid = pp_s3q10c_b
merge m:1 household_id2 personid using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_gender_merge_both.dta", gen(dm3_merge) keep(1 3)			// Dropping unmatched from using
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
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_field_gender_dm.dta", replace


********************************************************************************
* ALL AREA CONSTRUCTION
********************************************************************************
use "${Ethiopia_ESS_W2_raw_data}/sect3_pp_w2.dta", clear
gen cultivated = pp_s3q03==1			// if plot was cultivated
*Generating some conversion factors
gen area = pp_s3q02_a 
gen local_unit = pp_s3q02_c
gen area_sqmeters_gps = pp_s3q05_a
replace area_sqmeters_gps = . if area_sqmeters_gps<0
*Will now create ratios of sq m to local units in order to replace missing sq m values
preserve
keep household_id2 parcel_id field_id area local_unit area_sqmeters_gps
merge m:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hhids.dta"
drop if _merge==2
drop _merge
gen sqmeters_per_unit = area_sqmeters_gps/area
gen observations = 1
collapse (median) sqmeters_per_unit (count) observations [aw=weight], by (region zone local_unit)
ren sqmeters_per_unit sqmeters_per_unit_zone 
ren observations obs_zone
lab var sqmeters_per_unit_zone "Square meters per local unit (median value for this region and zone)"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_area_lookup_zone.dta", replace
restore
preserve
replace area_sqmeters_gps=. if area_sqmeters_gps<0
keep household_id2 parcel_id field_id area local_unit area_sqmeters_gps
merge m:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hhids.dta"
drop if _merge==2
drop _merge
gen sqmeters_per_unit = area_sqmeters_gps/area
gen observations = 1
collapse (median) sqmeters_per_unit (count) observations [aw=weight], by (region local_unit)
ren sqmeters_per_unit sqmeters_per_unit_region
ren observations obs_region
lab var sqmeters_per_unit_region "Square meters per local unit (median value for this region)"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_area_lookup_region.dta", replace
restore
preserve
replace area_sqmeters_gps=. if area_sqmeters_gps<0
keep household_id2 parcel_id field_id area local_unit area_sqmeters_gps
merge m:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hhids.dta"
drop if _merge==2
drop _merge
gen sqmeters_per_unit = area_sqmeters_gps/area
gen observations = 1
collapse (median) sqmeters_per_unit (count) observations [aw=weight], by (local_unit)
ren sqmeters_per_unit sqmeters_per_unit_country
ren observations obs_country
lab var sqmeters_per_unit_country "Square meters per local unit (median value for the country)"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_area_lookup_country.dta", replace
restore

*Now creating area - starting with sq meters
gen area_meas_hectares = pp_s3q02_a*10000 if pp_s3q02_c==1			// hectares to sq m
replace area_meas_hectares = pp_s3q02_a if pp_s3q02_c==2			// already in sq m
*For rest of units, we need to use the conversion factors
gen region = saq01
gen zone = saq02
gen woreda = saq03
merge m:1 region zone woreda local_unit using "${Ethiopia_ESS_W2_raw_data}/ET_local_area_unit_conversion.dta", gen(conversion_merge) keep(1 3)
replace area_meas_hectares = pp_s3q02_a*conversion if !inlist(pp_s3q02_c,1,2) & pp_s3q02_c!=.			// non-traditional units
*Field area is currently farmer reported - replacing with GPS area when available
replace area_meas_hectares = pp_s3q05_a if pp_s3q05_a!=. & pp_s3q05_a>0			
replace area_meas_hectares = area_meas_hectares*0.0001							// Changing back into hectares
*Using our own created conversion factors for still missings observations
merge m:1 region zone local_unit using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_area_lookup_zone.dta", nogen
replace area_meas_hectares = (area*(sqmeters_per_unit_zone/10000)) if local_unit!=11 & area_meas_hectares==. & obs_zone>=10
merge m:1 region local_unit using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_area_lookup_region.dta", nogen
replace area_meas_hectares = (area*(sqmeters_per_unit_region/10000)) if local_unit!=11 & area_meas_hectares==. & obs_region>=10
merge m:1 local_unit using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_area_lookup_country.dta", nogen
replace area_meas_hectares = (area*(sqmeters_per_unit_country/10000)) if local_unit!=11 & area_meas_hectares==.
count if area!=. & area_meas_hectares==.
*All plots have been converted to hectares
replace area_meas_hectares = 0 if area_meas_hectares == .
lab var area_meas_hectares "Field area measured in hectares, with missing obs imputed using local median per-unit values"
merge 1:1 holder_id parcel_id field_id using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_field_gender_dm.dta", nogen
gen area_meas_hectares_male = area_meas_hectares if dm_gender==1
gen area_meas_hectares_female = area_meas_hectares if dm_gender==2
gen area_meas_hectares_mixed = area_meas_hectares if dm_gender==3
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_field_area.dta", replace 
*Parcel Area
collapse (sum) land_size = area_meas_hectares, by(household_id2 holder_id parcel_id)
lab var land_size "Parcel area measured in hectares, with missing obs imputed using local median per-unit values"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_parcel_area.dta", replace

*Household Area
collapse (sum) area_meas_hectares_hh = land_size, by(household_id2)
lab var area_meas_hectares_hh "Total area measured in hectares, with missing obs imputed using local median per-unit values"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_household_area.dta", replace

*Cultivated (HH) area
use "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_field_area.dta", clear
keep if cultivated==1
collapse (sum) farm_area = area_meas_hectares, by (household_id2)
lab var farm_area "Land size, all cultivated plots (denominator for land productivitiy), in hectares"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_farm_area.dta", replace

*Agricultural land summary and area
use "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_field_area.dta", clear
gen agland = (pp_s3q03==1 | pp_s3q03==2 | pp_s3q03==3 | pp_s3q03==5) // Cultivated, prepared for Belg season, pasture, or fallow. Excludes forest and "other" (which seems to include rented-out)
keep if agland==1
keep household_id2 parcel_id field_id holder_id agland area_meas_hectares
ren area_meas_hectares farm_size_agland_field
lab var farm_size_agland "Field size in hectares, including all plots cultivated, fallow, or pastureland"
lab var agland "1= Plot was used for cultivated, pasture, or fallow"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_fields_agland.dta", replace

*Agricultural land area household
collapse (sum) farm_size_agland = farm_size_agland_field, by (household_id2)
lab var farm_size_agland "Total land size in hectares, including all plots cultivated, fallow, or pastureland"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_farmsize_all_agland.dta", replace


********************************************************************************
*MONOCROPPED CROPS*
********************************************************************************

forvalues k=1(1)$nb_topcrops {
	local c: word `k' of $topcrop_area
	local cn: word `k' of $topcropname_area
	local cnfull: word `k' of $topcropname_full
	use "${Ethiopia_ESS_W2_raw_data}/sect4_pp_w2.dta", clear
	xi i.crop_code, noomit
	egen crop_count = rowtotal(_Icrop_code_*)
	gen percent_`cn'=1 if pp_s4q02==1 & crop_code==`c'
	replace percent_`cn' = pp_s4q03/100 if pp_s4q02==2 & pp_s4q03!=. & crop_code==`c'		
	collapse (max) percent_`cn' _Icrop_code_*, by(household_id2 parcel_id field_id holder_id)
	egen crop_count = rowtotal(_Icrop_code_*)
	keep if _Icrop_code_`c'==1 & crop_count==1
	*merging in plot areas
	merge m:1 field_id parcel_id household_id2 holder_id using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_field_area.dta", nogen keep(1 3)
	gen `cn'_monocrop_ha= area_meas_hectares*percent_`cn'
	gen `cn'_monocrop_ha_female = area_meas_hectares*percent_`cn' if dm_gender==2
	gen `cn'_monocrop_ha_male = area_meas_hectares*percent_`cn' if dm_gender==1
	gen `cn'_monocrop_ha_mixed = area_meas_hectares*percent_`cn' if dm_gender==3
	save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_`cn'_monocrop.dta", replace
	collapse (sum) `cn'_monocrop_ha*, by(household_id2)
	gen `cn'_monocrop=1 
	lab var `cn'_monocrop "1=hh has monocropped `cn' plots"
	recode `cn'_monocrop_ha* (0=.)
	la var `cn'_monocrop_ha "Total `cnfull' monocrop hectares - Household"
	foreach i in male female mixed {
		local l`cn'_monocrop_ha : var lab `cn'_monocrop_ha
		la var `cn'_monocrop_ha_`i' "`l`cn'_monocrop_ha' - `i' managed plots"
	}
	save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_`cn'_monocrop_hh_area.dta", replace
}


********************************************************************************
*GROSS CROP REVENUE
********************************************************************************
*Crops excluding tree crops, vegetables, root crops
use "${Ethiopia_ESS_W2_raw_data}/sect11_ph_w2.dta", clear
ren saq01 region
ren saq02 zone
ren saq03 woreda
ren saq04 kebele
ren saq05 ea
ren saq06 household
ren ph_s11q01 sell_yesno
ren ph_s11q03_a quantity_sold_kg
ren ph_s11q03_b g_sold
gen kgs_sold = quantity_sold_kg + (g_sold/1000)
ren ph_s11q04 sales_value
drop if sales_value==0
ren ph_s11q22_e percent_sold
keep if sell_yesno==1 
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_sales_1.dta", replace

*Tree crops, vegetables, root crops
use "${Ethiopia_ESS_W2_raw_data}/sect12_ph_w2.dta", clear
ren saq01 region
ren saq02 zone
ren saq03 woreda
ren saq04 kebele
ren saq05 ea
ren saq06 household
ren ph_s12q06 sell_yesno
ren ph_s12q07 kgs_sold
ren ph_s12q08 sales_value
ren ph_s12q19_f percent_sold
keep if sell_yesno==1 
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_sales_2.dta", replace

*Appending all sales into a single file
use "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_sales_1.dta", clear
append using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_sales_2.dta"
collapse (sum) kgs_sold sales_value (max) percent_sold, by (household_id2 crop_code) // For duplicated obs, we'll take the maximum reported % sold
gen price_kg = sales_value / kgs_sold
lab var price_kg "Price received per kgs sold"
drop if price_kg==. | price_kg==0
keep household_id2 crop_code price_kg sales_value percent_sold kgs_sold
merge m:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hhids.dta", nogen keep(1 3)
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_sales.dta", replace 

*Generating median prices
use "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_sales.dta", clear
gen observation = 1
bys region zone woreda kebele ea crop_code: egen obs_ea = count(observation)
collapse (median) price_kg [aw=weight], by (region zone woreda kebele ea crop_code obs_ea)
	ren price_kg price_kg_median_ea
lab var price_kg_median_ea "Median price per kg for this crop in the enumeration area"
lab var obs_ea "Number of sales observations for this crop in the enumeration area"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_LSMS_ISA_2_crop_prices_ea.dta", replace
use "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_sales.dta", clear
gen observation = 1
bys region zone woreda kebele crop_code: egen obs_kebele = count(observation)
collapse (median) price_kg [aw=weight], by (region zone woreda kebele crop_code obs_kebele)
ren price_kg price_kg_median_kebele
lab var price_kg_median_kebele "Median price per kg for this crop in the kebele"
lab var obs_kebele "Number of sales observations for this crop in the kebele"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_prices_kebele.dta", replace
use "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_sales.dta", clear
gen observation = 1
bys region zone woreda crop_code: egen obs_woreda = count(observation)
collapse (median) price_kg [aw=weight], by (region zone woreda crop_code obs_woreda)
ren price_kg price_kg_median_woreda
lab var price_kg_median_woreda "Median price per kg for this crop in the woreda"
lab var obs_woreda "Number of sales observations for this crop in the woreda"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_prices_woreda.dta", replace
use "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_sales.dta", clear
gen observation = 1
bys region zone crop_code: egen obs_zone = count(observation)
collapse (median) price_kg [aw=weight], by (region zone crop_code obs_zone)
ren price_kg price_kg_median_zone
lab var price_kg_median_zone "Median price per kg for this crop in the zone"
lab var obs_zone "Number of sales observations for this crop in the zone"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_prices_zone.dta", replace
use "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_sales.dta", clear
gen observation = 1
bys region crop_code: egen obs_region = count(observation)
collapse (median) price_kg [aw=weight], by (region crop_code obs_region)
ren price_kg price_kg_median_region
lab var price_kg_median_region "Median price per kg for this crop in the region"
lab var obs_region "Number of sales observations for this crop in the region"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_prices_region.dta", replace
use "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_sales.dta", clear
gen observation = 1
bys crop_code: egen obs_country = count(observation)
collapse (median) price_kg [aw=weight], by (crop_code obs_country)
ren price_kg price_kg_median_country
lab var price_kg_median_country "Median price per kg for this crop in the country"
lab var obs_country "Number of sales observations for this crop in the country"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_prices_country.dta", replace

use "${Ethiopia_ESS_W2_raw_data}/sect9_ph_w2.dta", clear // This includes all crop harvest
ren ph_s9q05 kgs_harvest
keep household_id2 crop_code kgs_harvest
*Merging hhid file to get geographic variable (region, district, etc.)
merge m:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hhids.dta", nogen keep(1 3)
*Here we have quantity harvested for all crops.
collapse (sum) kgs_harvest, by (household_id2 region zone woreda kebele ea crop_code)	// Collapse to crop
merge 1:1 household_id2 crop_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_sales.dta", nogen
*Kebele and ea are the same thing.
merge m:1 region zone woreda kebele crop_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_prices_kebele.dta", nogen
merge m:1 region zone woreda crop_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_prices_woreda.dta", nogen
merge m:1 region zone crop_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_prices_zone.dta", nogen
merge m:1 region crop_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_prices_region.dta", nogen
merge m:1 crop_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_prices_country.dta", nogen
ren price_kg price_kg_hh
gen price_kg = price_kg_hh	// use household price where available
*Require at least ten price observations to impute prices (except at country level)
replace price_kg = price_kg_median_kebele if price_kg==. & obs_kebele >= 10
replace price_kg = price_kg_median_woreda if price_kg==. & obs_woreda >= 10
replace price_kg = price_kg_median_zone if price_kg==. & obs_zone >= 10
replace price_kg = price_kg_median_region if price_kg==. & obs_region >= 10
replace price_kg = price_kg_median_country if price_kg==. 
lab var price_kg "Price per kg, with all values imputed using local median values of observed sales"
gen value_harvest = kgs_harvest * price_kg
lab var value_harvest "Value of harvest"
*For Ethiopia LSMS, "other" crops are categorized as being legumes, cereals, etc. 
*So we will take the median per-kg price to value these crops.
count if value_harvest==. // 17 household-crop observations can't be valued. Assume value is zero
replace value_harvest = sales_value if percent_sold==100 /* If the household sold 100% of this crop, then that is the value of production, even if odd units had been reported. */
replace value_harvest = sales_value if kgs_harvest==0 & sales_value>0 & sales_value!=.
replace value_harvest = sales_value if sales_value>value_harvest & sales_value!=. & value_harvest!=. /* In a few cases, the kgs sold exceeds the kgs harvested */
replace value_harvest=0 if value_harvest==.
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_values_tempfile.dta", replace 

*Adding here kgs_harvest and quantity_sold to be used in the estimation of harvest and sales disaggregated by crop
preserve
ren sales_value value_sold
recode value_harvest value_sold kgs_harvest kgs_sold (.=0)
collapse (sum) value_harvest value_sold kgs_harvest kgs_sold, by(household_id crop_code)
ren value_harvest value_crop_production
lab var value_crop_production "Gross value of crop production for the year"
ren value_sold value_crop_sales
lab var value_crop_sales "Value of crops sold so far"
lab var kgs_harvest "Kgs harvested of this crop"
lab var kgs_sold "Kgs sold of this crop, summed over main and short season"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_crop_values_production.dta", replace
restore

collapse (sum) value_harvest sales_value, by (household_id2)
ren value_harvest value_crop_production
lab var value_crop_production "Gross value of crop production for this household"
*This is estimated using local median values of observed sales in which the sales unit is also found in the conversion table.
*For "Other" crops,these are valued as though "other spice", "other cereal" is its own crop code.
*If a crop is never sold it receives a value of zero using this method.
ren sales_value value_crop_sales
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
drop if household_id2==""
save  "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_crop_production.dta", replace   

*Value crop production by parcel
use "${Ethiopia_ESS_W2_raw_data}/sect9_ph_w2.dta", clear
ren ph_s9q05 kgs_harvest
keep household_id2 crop_code kgs_harvest parcel_id field_id holder_id
merge m:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hhids.dta", nogen keep(1 3)
bysort household_id2 parcel_id field_id holder_id (kgs_harvest): gen allmissing = mi(kgs_harvest[1])
collapse (sum) kgs_harvest (min) allmissing, by (household_id2 region zone woreda kebele ea crop_code parcel_id field_id holder_id)
replace kgs_harvest=. if allmissing
*Merging price data
merge m:1 household_id2 crop_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_sales.dta", nogen
merge m:1 region zone woreda kebele crop_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_prices_kebele.dta", nogen
merge m:1 region zone woreda crop_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_prices_woreda.dta", nogen
merge m:1 region zone crop_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_prices_zone.dta", nogen
merge m:1 region crop_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_prices_region.dta", nogen
merge m:1 crop_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_prices_country.dta", nogen
ren price_kg price_kg_hh
gen price_kg = price_kg_hh	// use household-level price where avialable
*Require at least ten price observations (except at country level)
replace price_kg = price_kg_median_kebele if price_kg==. & obs_kebele >= 10
replace price_kg = price_kg_median_woreda if price_kg==. & obs_woreda >= 10
replace price_kg = price_kg_median_zone if price_kg==. & obs_zone >= 10
replace price_kg = price_kg_median_region if price_kg==. & obs_region >= 10
replace price_kg = price_kg_median_country if price_kg==. 
lab var price_kg "Price per kg, with all values imputed using local median values of observed sales"
gen value_harvest = kgs_harvest * price_kg
lab var value_harvest "Value of harvest"
*For Ethiopia LSMS, "other" crops are at least categorized as being legumes, cereals, etc. 
*So we will take the median per-kg price to value these crops.
count if value_harvest==. & kgs_harvest!=./* 18 household-crop observations can't be valued. Assume value is zero for now. */
replace value_harvest=0 if value_harvest==. & kgs_harvest!=.
preserve
collapse (sum) value_harvest, by (household_id2 holder_id parcel_id)
ren value_harvest value_crop_production_parcel
lab var value_crop_production_parcel "Gross value of crop production for this parcel"
drop if household_id2==""
save  "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_production_parcel.dta", replace
*9,653 parcels cultivated
restore
collapse (sum) value_harvest, by (household_id2 holder_id parcel_id field_id)
ren value_harvest value_crop_production_field
lab var value_crop_production_field "Gross value of crop production for this field"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_production_field.dta", replace

merge 1:1 household_id2 holder_id parcel_id field_id using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_field_gender_dm.dta", nogen keep(1 3)
gen value_harvest_male = value_crop_production_field if dm_gender==1
gen value_harvest_female = value_crop_production_field if dm_gender==2
gen value_harvest_mixed = value_crop_production_field if dm_gender==3
collapse (sum) value_harvest* value_crop_production_field, by (household_id2)
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_production_household.dta", replace

*Crop losses and value of consumption
use "${Ethiopia_ESS_W2_raw_data}/sect11_ph_w2.dta", clear
ren ph_s11q15_3 kgs_lost
ren ph_s11q15_4 percent_lost
append using "${Ethiopia_ESS_W2_raw_data}/sect12_ph_w2.dta"
ren ph_s12q12 share_lost
ren ph_s12q13 value_lost 
replace percent_lost = share_lost if percent_lost==.
merge m:1 household_id2 crop_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_crop_values_production.dta", nogen keep(1 3)
sum kgs_lost if percent_lost==0 // If both a quantity and share lost were given, we'll take the share to be consistent with section 12.
lab var kgs_lost "Estimated number of kgs of this crop that were lost post-harvest"
*Merging prices
merge m:1 household_id2 crop_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_sales.dta", nogen
merge m:1 region zone woreda kebele crop_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_prices_kebele.dta", nogen
merge m:1 region zone woreda crop_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_prices_woreda.dta", nogen
merge m:1 region zone crop_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_prices_zone.dta", nogen
merge m:1 region crop_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_prices_region.dta", nogen
merge m:1 crop_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_prices_country.dta", nogen
ren price_kg price_kg_hh
gen price_kg = price_kg_hh	// Use household-level price where available
recode price_kg (0=.)
*Require at least ten price observations (except at country level)
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
/*If the estimated value lost (just 4 obs) exceeds the value produced (We're relying on kg-estimates to value harvest, 
and the units reported can also differ across files), then we'll cap the losses at the value of production */
replace value_quantity_lost = value_crop_production if value_quantity_lost > value_crop_production & value_quantity_lost!=.
gen crop_value_lost = (value_crop_production * (percent_lost/100)) + value_quantity_lost
recode crop_value_lost (.=0)
*Also doing transport costs for crop sales here
ren ph_s11q09 value_transport_cropsales
recode value_transport_cropsales (.=0)
collapse (sum) crop_value_lost value_transport_cropsales, by (household_id2)
lab var crop_value_lost "Value of crop losses"
lab var value_transport_cropsales "Expenditures on transportation for crop sales of temporary crops"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_losses.dta", replace


********************************************************************************
*CROP EXPENSES
********************************************************************************
*Expenses: Hired labor
use "${Ethiopia_ESS_W2_raw_data}/sect3_pp_w2.dta", clear
ren pp_s3q28_a number_men
ren pp_s3q28_b number_days_men
ren pp_s3q28_c wage_perday_men
ren pp_s3q28_d number_women
ren pp_s3q28_e number_days_women
ren pp_s3q28_f wage_perday_women
ren pp_s3q28_g number_children
ren pp_s3q28_h number_days_children
ren pp_s3q28_i wage_perday_children
gen wages_paid_men = number_days_men * wage_perday_men
gen wages_paid_women = number_days_women * wage_perday_women 
gen wages_paid_children = number_days_children * wage_perday_children
recode wages_paid_men wages_paid_women wages_paid_children (.=0)
gen wages_paid_aglabor_postplant =  wages_paid_men + wages_paid_women + wages_paid_children

*Monocropped plots
foreach cn in $topcropname_area {
	preserve
	merge 1:1 household_id2 parcel_id field_id holder_id using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_`cn'_monocrop.dta", nogen /*assert(1 3)*/ keep(3)	// only in master and matched; keeping only matched, because these are the monocropped plots
	collapse (sum) wg_paid_aglabor_postplant_`cn' = wages_paid_aglabor_postplant, by(household_id2)		//renaming all to crop suffix
	lab var wg_paid_aglabor_postplant_`cn' "Wages paid for hired labor (crops) - Monocropped `cn' plots only, as captured in post-planting survey"
	save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_wages_postplanting_`cn'.dta", replace
	restore
}
collapse (sum) wages_paid_aglabor_postplant, by (household_id2)
lab var wages_paid_aglabor_postplant "Wages paid for hired labor (crops), as captured in post-planting survey"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_wages_postplanting.dta", replace

use "${Ethiopia_ESS_W2_raw_data}/sect10_ph_w2.dta", clear
ren ph_s10q01_a number_men
ren ph_s10q01_b number_days_men
ren ph_s10q01_c wage_perday_men
ren ph_s10q01_d number_women
ren ph_s10q01_e number_days_women
ren ph_s10q01_f wage_perday_women
ren ph_s10q01_g number_children
ren ph_s10q01_h number_days_children
ren ph_s10q01_i wage_perday_children
gen wages_paid_men = number_days_men * wage_perday_men
gen wages_paid_women = number_days_women * wage_perday_women 
gen wages_paid_children = number_days_children * wage_perday_children
recode wages_paid_men wages_paid_women wages_paid_children (.=0)
gen wages_paid_aglabor_postharvest =  wages_paid_men + wages_paid_women + wages_paid_children

*Monocropped plots
*Top crops
foreach cn in $topcropname_area {
	preserve 
	merge m:1 household_id2 parcel_id field_id holder_id using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_`cn'_monocrop.dta", nogen /*assert(1 3)*/ keep(3)	// only in master and matched; keeping only matched, because these are the monocropped plots
	collapse wg_paid_aglabor_postharv_`cn' = wages_paid_aglabor_postharvest, by(household_id2)
	lab var wg_paid_aglabor_postharv_`cn' "Wages paid for hired labor (crops) - Monocropped `cn' plots only, as captured in post-harvest survey"
	save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_wages_postharvest_`cn'.dta", replace
	restore
}
collapse (sum) wages_paid_aglabor_postharvest, by (household_id2)
lab var wages_paid_aglabor_postharvest "Wages paid for hired labor (crops), as captured in post-harvest survey"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_wages_postharvest.dta", replace

*Expenses: Inputs
use "${Ethiopia_ESS_W2_raw_data}/sect3_pp_w2.dta", clear
ren pp_s3q16d value_urea
ren pp_s3q19d value_DAP
ren pp_s3q20c value_other_chemicals
recode value_urea value_DAP value_other_chemicals (.=0)
*Monocropped plots
foreach cn in $topcropname_area {
	preserve
	merge m:1 household_id2 parcel_id field_id holder_id using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_`cn'_monocrop.dta", nogen /*assert(1 3)*/ keep(3)
	gen value_urea_`cn' = value_urea
	gen value_DAP_`cn' = value_DAP 
	gen value_other_chem_`cn' = value_other_chemicals
	lab var value_urea_`cn' "Value of urea used on the farm - Monocropped `cn' plots"
	lab var value_DAP_`cn' "Value of DAP used on the farm - Monocropped `cn' plots"
	lab var value_other_chem_`cn' "Value of any other chemicals used on the farm - Monocropped `cn' plots"
	egen value_fertilizer_`cn' = rowtotal(value_urea_`cn' value_DAP_`cn' value_other_chem_`cn')
	la var value_fertilizer_`cn' "Value of all fertilizer on `cn' monocropped plots"
	merge 1:1 household_id2 holder_id parcel_id field_id using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_field_gender_dm.dta", nogen keep(3)
	gen value_fertilizer_`cn'_male = value_fertilizer_`cn' if dm_gender==1
	gen value_fertilizer_`cn'_female = value_fertilizer_`cn' if dm_gender==2
	gen value_fertilizer_`cn'_mixed = value_fertilizer_`cn' if dm_gender==3
	collapse (sum) value_fertilizer_`cn'*, by(household_id2)
	save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_fertilizer_costs_`cn'.dta", replace
	restore
}
collapse (sum) value_urea value_DAP value_other_chemicals, by (household_id2)
lab var value_urea "Value of urea used on the farm"
lab var value_DAP "Value of DAP used on the farm"
lab var value_other_chemicals "Value of any other chemicals used on the farm"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_fertilizer_costs.dta", replace

*Other chemicals, manure not captured in ESS
use "${Ethiopia_ESS_W2_raw_data}/sect5_pp_w2.dta", clear
ren pp_s5q07 cost_transport_purchased_seed
ren pp_s5q08 value_purchased_seed
ren pp_s5q16 cost_transport_free_seed
recode value_purchased_seed cost_transport_purchased_seed cost_transport_free_seed (.=0)
collapse (sum) value_purchased_seed cost_transport_purchased_seed cost_transport_free_seed , by (household_id2)
lab var value_purchased_seed "Value of purchased seed"
lab var cost_transport_purchased_seed "Cost of transport for purchased seed"
lab var cost_transport_free_seed "Cost of transport for free seed"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_seed_costs.dta", replace
*Value of seed purchased (not just improved seed) is also captured here.

*Land rental
use "${Ethiopia_ESS_W2_raw_data}/sect2_pp_w2.dta", clear
gen rented_plot = (pp_s2q03==3)
ren pp_s2q07_a rental_cost_cash
ren pp_s2q07_b rental_cost_inkind
*Formalized land rights
gen formal_land_rights = pp_s2q04==1
*Individual level (for women)
*starting with first owner
preserve
ren pp_s2q06_a personid
merge m:1 household_id2 personid using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_gender_merge_both.dta", nogen keep(3)		//keep only matched
keep household_id2 personid female formal_land_rights
tempfile p1
save `p1', replace
restore
*Now second owner
preserve
ren pp_s2q06_b personid
merge m:1 household_id2 personid using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_gender_merge_both.dta", nogen keep(3)		//keep only matched
keep household_id2 personid female formal_land_rights
append using `p1'
gen formal_land_rights_f = formal_land_rights==1 if female==1
collapse (max) formal_land_rights_f, by(household_id2 personid)
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_land_rights_ind.dta", replace
restore
preserve
collapse (max) formal_land_rights_hh= formal_land_rights, by(household_id2)		// taking max at household level; equals one if they have official documentation for at least one plot
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_land_rights_hh.dta", replace
restore
merge 1:1 household_id2 holder_id parcel_id using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_production_parcel.dta", nogen keep(1 3)
recode rental_cost_cash rental_cost_inkind (.=0)
gen rental_cost_land = rental_cost_cash + rental_cost_inkind
collapse (sum) rental_cost_land, by (household_id2)
lab var rental_cost_land "Rental costs for land(paid in cash and in kind)"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_land_rental_costs.dta", replace

*Rental of agricultural tools, machines are not captured.
*Transport costs for crop sales
use "${Ethiopia_ESS_W2_raw_data}/sect11_ph_w2.dta", clear
ren ph_s11q09 transport_costs_cropsales
recode transport_costs_cropsales (.=0)
collapse (sum) transport_costs_cropsales, by (household_id2)
lab var transport_costs_cropsales "Expenditures on transportation for crop sales of temporary crops"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_transportation_cropsales.dta", replace


********************************************************************************
*LIVESTOCK INCOME
********************************************************************************
*Expenses
use "${Ethiopia_ESS_W2_raw_data}/sect8a_ls_w2.dta", clear
ren ls_s8aq62 cost_labor_livestock
ren ls_s8aq64 cost_expenses_livestock
recode cost_labor_livestock cost_expenses_livestock (.=0)
gen milk_animals_total = ls_s8aq20a
*Dairy costs
preserve
keep if ls_s8aq00 == 1
collapse (sum) cost_labor_livestock cost_expenses_livestock, by (household_id2)
egen cost_lrum = rowtotal (cost_labor_livestock cost_expenses_livestock)
keep household_id2 cost_lrum
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_lrum_expenses", replace
restore 
collapse (sum) cost_labor_livestock cost_expenses_livestock milk_animals_total, by(household_id2)
lab var cost_labor_livestock "Cost for hired labor for livestock"
lab var cost_expenses_livestock "Cost for other expenses for livestock"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_expenses", replace

*Livestock products
use "${Ethiopia_ESS_W2_raw_data}/sect8c_ls_w2", clear
ren ls_s8cq06b byproduct_amount
ren ls_s8cq06a byproduct_unit
ren ls_s8cq00 livestock_product_code
ren ls_s8cq07b product_sold_amount
ren ls_s8cq07a product_sold_unit
ren ls_s8cq08a product_earnings
ren saq01 region
ren saq02 zone
ren saq03 woreda
ren saq04 kebele
gen price_per_unit = product_earnings/product_sold_amount
recode price_per_unit (0=.) 
gen costs_dairy = ls_s8cq04 if livestock_product_code==1 & ls_s8cq01==1 
merge m:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hhids.dta", nogen keep(1 3)
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_livestock_products", replace

*Creating aggregate prices for livestock
use "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region zone woreda kebele livestock_product_code: egen obs_kebele = count(observation)
collapse (median) price_per_unit [aw=weight], by (region zone woreda kebele livestock_product_code obs_kebele)
ren price_per_unit price_median_kebele
lab var price_median_kebele "Median price per unit for this livestock product in the kebele"
lab var obs_kebele "Number of sales observations for this livestock product in the kebele"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_products_prices_kebele.dta", replace
use "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region zone woreda livestock_product_code: egen obs_woreda = count(observation)
collapse (median) price_per_unit [aw=weight], by (region zone woreda livestock_product_code obs_woreda)
ren price_per_unit price_median_woreda
lab var price_median_woreda "Median price per unit for this livestock product in the woreda"
lab var obs_woreda "Number of sales observations for this livestock product in the woreda"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_products_prices_woreda.dta", replace
use "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region zone livestock_product_code: egen obs_zone = count(observation)
collapse (median) price_per_unit [aw=weight], by (region zone livestock_product_code obs_zone)
ren price_per_unit price_median_zone
lab var price_median_zone "Median price per unit for this livestock product in the zone"
lab var obs_zone "Number of sales observations for this livestock product in the zone"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_products_prices_zone.dta", replace
use "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region livestock_product_code: egen obs_region = count(observation)
collapse (median) price_per_unit [aw=weight], by (region livestock_product_code obs_region)
ren price_per_unit price_median_region
lab var price_median_region "Median price per unit for this livestock product in the region"
lab var obs_region "Number of sales observations for this livestock product in the region"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_products_prices_region.dta", replace
use "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys livestock_product_code: egen obs_country = count(observation)
collapse (median) price_per_unit [aw=weight], by (livestock_product_code obs_country)
ren price_per_unit price_median_country
lab var price_median_country "Median price per unit for this livestock product in the country"
lab var obs_country "Number of sales observations for this livestock product in the country"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_products_prices_country.dta", replace

*Livestock products
use "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_livestock_products", clear
*Merge in aggregate prices
merge m:1 region zone woreda kebele livestock_product_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_products_prices_kebele.dta", nogen
merge m:1 region zone woreda livestock_product_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_products_prices_woreda.dta", nogen
merge m:1 region zone livestock_product_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_products_prices_zone.dta", nogen
merge m:1 region livestock_product_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_products_prices_region.dta", nogen
merge m:1 livestock_product_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_products_prices_country.dta", nogen
*Require at least ten observations (except at country level)
replace price_per_unit = price_median_kebele if price_per_unit==. & obs_kebele >= 10
replace price_per_unit = price_median_woreda if price_per_unit==. & obs_woreda >= 10
replace price_per_unit = price_median_zone if price_per_unit==. & obs_zone >= 10
replace price_per_unit = price_median_region if price_per_unit==. & obs_region >= 10
replace price_per_unit = price_median_country if price_per_unit==. 
lab var price_per_unit "Price per unit of byproduct, imputed with local median prices if household did not sell"
gen value_milk_produced = byproduct_amount*price_per_unit if livestock_product_code==1
gen value_eggs_produced = byproduct_amount*price_per_unit if livestock_product_code==6
gen value_byproduct = byproduct_amount * price_per_unit
recode value_byproduct (.=0)
gen sales_livestock_products = product_earnings
collapse (sum) value_byproduct value_milk_produced value_eggs_produced sales_livestock_products costs_dairy, by(household_id2)
*Share of livestock products sold
*First, constructing total value
gen value_livestock_products = value_byproduct
*Now, the share
gen share_livestock_prod_sold = sales_livestock_products/value_livestock_products
*NOTE: there are quite a few that seem to have higher sales than production - capping these at one
replace share_livestock_prod_sold = 1 if share_livestock_prod_sold>1 & share_livestock_prod_sold!=.
lab var share_livestock_prod_sold "Percent of production of livestock products that is sold" 
lab var value_byproduct "Value of animal byproducts produced"
lab var value_milk_produced "Value of milk produced"
lab var value_eggs_produced "Value of eggs produced"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_products", replace

*Sales (live animals)
*Questionnaire asks about sales of livestock, but doesn't specify whether it's live or slaughtered
*Cannot value purchased animals because the questionnaire doesn't ask anything about the costs spent on purchasing animals, just the number of animals purchased. We don't think that animals would be purchased at the price they are sold at.
*Slaughtered animals captured in byproducts (instrument asks about sales of beef, mutton/goat, and camel meat sales and consumption)
use "${Ethiopia_ESS_W2_raw_data}/sect8a_ls_w2.dta", clear
ren ls_s8aq00 livestock_code
ren ls_s8aq44a number_purchased
ren ls_s8aq46a number_sold
ren ls_s8aq47a number_slaughtered
ren ls_s8aq60 value_livestock_sales
recode number_sold number_slaughtered value_livestock_sales (.=0)
gen price_per_animal = value_livestock_sales/number_sold
recode price_per_animal (0=.)
merge m:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hhids.dta", nogen keep(1 3)
keep household_id2 weight region zone woreda kebele ea livestock_code number_sold number_slaughtered price_per_animal
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_sales", replace

*Implicit prices
use "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region zone woreda kebele livestock_code: egen obs_kebele = count(observation)
collapse (median) price_per_animal [aw=weight], by (region zone woreda kebele livestock_code obs_kebele)
ren price_per_animal price_median_kebele
lab var price_median_kebele "Median price per unit for this livestock in the kebele"
lab var obs_kebele "Number of sales observations for this livestock in the kebele"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_prices_kebele.dta", replace
use "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region zone woreda livestock_code: egen obs_woreda = count(observation)
collapse (median) price_per_animal [aw=weight], by (region zone woreda livestock_code obs_woreda)
ren price_per_animal price_median_woreda
lab var price_median_woreda "Median price per unit for this livestock in the woreda"
lab var obs_woreda "Number of sales observations for this livestock in the woreda"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_prices_woreda.dta", replace
use "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region zone livestock_code: egen obs_zone = count(observation)
collapse (median) price_per_animal [aw=weight], by (region zone livestock_code obs_zone)
ren price_per_animal price_median_zone
lab var price_median_zone "Median price per unit for this livestock in the zone"
lab var obs_zone "Number of sales observations for this livestock in the zone"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_prices_zone.dta", replace
use "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_animal [aw=weight], by (region livestock_code obs_region)
ren price_per_animal price_median_region
lab var price_median_region "Median price per unit for this livestock in the region"
lab var obs_region "Number of sales observations for this livestock in the region"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_prices_region.dta", replace
use "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_animal [aw=weight], by (livestock_code obs_country)
ren price_per_animal price_median_country
lab var price_median_country "Median price per unit for this livestock in the country"
lab var obs_country "Number of sales observations for this livestock in the country"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_prices_country.dta", replace

*Livestock
use "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_sales", clear
*Merging in prices
merge m:1 region zone woreda kebele livestock_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_prices_kebele.dta", nogen
merge m:1 region zone woreda livestock_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_prices_woreda.dta", nogen
merge m:1 region zone livestock_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_prices_zone.dta", nogen
merge m:1 region livestock_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_prices_region.dta", nogen
merge m:1 livestock_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_prices_country.dta", nogen
*Require at least ten price observations (except at country level)
replace price_per_animal = price_median_kebele if price_per_animal==. & obs_kebele >= 10
replace price_per_animal = price_median_woreda if price_per_animal==. & obs_woreda >= 10
replace price_per_animal = price_median_zone if price_per_animal==. & obs_zone >= 10
replace price_per_animal = price_median_region if price_per_animal==. & obs_region >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_lvstck_sold = price_per_animal * number_sold
gen value_slaughtered = price_per_animal * number_slaughtered
gen value_livestock_sales = value_lvstck_sold
collapse (sum) value_livestock_sales value_lvstck_sold, by (household_id2)
lab var value_livestock_sales "Value of livestock sold and slaughtered (with slaughtered livestock that weren't sold valued at local median prices for live animal sales)"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_sales", replace

*TLU (Tropical Livestock Units)
use "${Ethiopia_ESS_W2_raw_data}/sect8a_ls_w2.dta", clear
ren ls_s8aq00 ls_code
gen tlu=0.5 if (ls_code==1|ls_code==4)
replace tlu=0.1 if (ls_code==2|ls_code==3)
replace tlu=0.3 if ls_code==5
replace tlu=0.6 if ls_code==6
replace tlu=0.7 if ls_code==7
replace tlu=0.01 if (ls_code==8|ls_code==9|ls_code==10|ls_code==11|ls_code==12|ls_code==13)
lab var tlu "Tropical Livestock Unit coefficient"
ren tlu tlu_coefficient
*Owned
gen lvstckid=ls_code
gen cattle=inrange(lvstckid,1,1)
gen smallrum=inrange(lvstckid,2, 3)
gen poultry=inrange(lvstckid,8,13)
gen other_ls=inlist(lvstckid,4, 5, 6,7,14)
gen chickens=inrange(lvstckid,8,13)
ren ls_s8aq13a nb_ls_today 
gen nb_cattle_today=nb_ls_today if cattle==1 
gen nb_smallrum_today=nb_ls_today if smallrum==1 
gen nb_poultry_today=nb_ls_today if poultry==1 
gen nb_other_ls_today=nb_ls_today if other_ls==1
gen nb_chickens_today=nb_ls_today if chickens==1
gen nb_cows_today=ls_s8aq20a  if cattle==1  // How many for milk that is cattle
gen tlu_today = nb_ls_today * tlu_coefficient
ren ls_s8aq60 value_livestock_sales
*Bee colonies not captured in TLU.
recode tlu_* nb_* (.=0)
collapse (sum) tlu_* nb_*  , by (household_id2)
lab var nb_cattle_today "Number of cattle owned as of the time of survey"
lab var nb_smallrum_today "Number of small ruminant owned as of the time of survey"
lab var nb_poultry_today "Number of cattle poultry as of the time of survey"
lab var nb_other_ls_today "Number of other livestock (dog, donkey, and other) owned as of the time of survey"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
lab var nb_ls_today "Number of livestock owned as of today"
drop tlu_coefficient
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_TLU_Coefficients.dta", replace 

*TLU (Tropical Livestock Units)
use "${Ethiopia_ESS_W2_raw_data}/sect8a_ls_w2.dta", clear
ren ls_s8aq00 ls_code
gen tlu=0.5 if (ls_code==1|ls_code==4)
replace tlu=0.1 if (ls_code==2|ls_code==3)
replace tlu=0.3 if ls_code==5
replace tlu=0.6 if ls_code==6
replace tlu=0.7 if ls_code==7
replace tlu=0.01 if (ls_code==8|ls_code==9|ls_code==10|ls_code==11|ls_code==12|ls_code==13)
lab var tlu "Tropical Livestock Unit coefficient"
ren ls_code livestock_code
ren tlu tlu_coefficient
ren ls_s8aq13a number_today 
ren ls_s8aq46a number_sold
ren ls_s8aq60 value_livestock_sales
gen tlu_today = number_today * tlu_coefficient
*Livestock mortality rate
ren ls_s8aq43a number_births
ren ls_s8aq44a number_purchased
ren ls_s8aq45a number_aquired
ren ls_s8aq47a number_slaughtered
ren ls_s8aq48a number_offered
ren ls_s8aq49a number_died_disease
ren ls_s8aq50a number_died_other
egen animals_lost12months = rowtotal(number_died_disease number_died_other)
egen total_gained = rowtotal(number_births number_purchased number_aquired)
egen total_lost = rowtotal(number_slaughtered number_offered number_died_disease number_died_other)
gen number_change = total_gained - total_lost
gen number_1yearago = number_today + number_change
replace number_1yearago=0 if number_1yearago<0
egen mean_12months = rowmean(number_today number_1yearago)
ren number_died_disease lost_disease
ren ls_s8aq15a number_exotic
ren ls_s8aq16a number_hybrid
egen number_today_exotic = rowtotal(number_exotic number_hybrid)
gen share_imp_herd_cows = number_today_exotic/number_today if livestock_code==1
gen species = (inlist(livestock_code,1)) + 2*(inlist(livestock_code,2,3)) + 3*(inlist(livestock_code,7)) + 4*(inlist(livestock_code,4,5,6)) + 5*(inlist(livestock_code,8,9,10,11,12,13))
recode species (0=.)
la def species 1 "Large ruminants (cows)" 2 "Small ruminants (sheep, goats)" 3 "Camels" 4 "Equine (horses, donkies, mules)" 5 "Poultry"
la val species species
preserve
*Now to household level
*First, generating these values by species
collapse (firstnm) share_imp_herd_cows (sum) number_today number_1yearago animals_lost12months number_today_exotic lost_disease lvstck_holding=number_today, by(household_id2 species)
egen mean_12months = rowmean(number_today number_1yearago)
gen any_imp_herd = number_today_exotic!=0 if number_today!=. & number_today!=0
*A loop to create species variables
foreach i in animals_lost12months mean_12months any_imp_herd lvstck_holding lost_disease{
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==2
	gen `i'_camel = `i' if species==3
	gen `i'_equine = `i' if species==4
	gen `i'_poultry = `i' if species==5
}
*Now we can collapse to household (taking firstnm because these variables are only defined once per household)
collapse (sum) number_today number_today_exotic (firstnm) *lrum *srum *camel *equine *poultry share_imp_herd_cows, by(household_id2)
*Overall any improved herd
gen any_imp_herd = number_today_exotic!=0 if number_today!=0
drop number_today_exotic number_today
*Generating missing variables in order to construct labels (just for the labeling loop below)
foreach i in lvstck_holding animals_lost12months mean_12months lost_disease{
	gen `i' = .
}
la var lvstck_holding "Total number of livestock holdings (# of animals)"
la var any_imp_herd "At least one improved animal in herd"
la var share_imp_herd_cows "Share of improved animals in total herd - Cows only"
lab var animals_lost12months  "Total number of livestock  lost to disease and other causes"
lab var  mean_12months  "Average number of livestock  today and 1  year ago"
lab var lost_disease "Total number of livestock lost to disease" 

*A loop to label these variables (taking the labels above to construct each of these for each species)
foreach i in any_imp_herd lvstck_holding animals_lost12months mean_12months lost_disease{
	local l`i' : var lab `i'
	lab var `i'_lrum "`l`i'' - large ruminants"
	lab var `i'_srum "`l`i'' - small ruminants"
	lab var `i'_camel "`l`i'' - camels"
	lab var `i'_equine "`l`i'' - equine"
	lab var `i'_poultry "`l`i'' - poultry"
}
la var any_imp_herd "At least one improved animal in herd - all animals"
gen lvstck_holding_all = lvstck_holding_lrum + lvstck_holding_srum + lvstck_holding_poultry
la var lvstck_holding_all "Total number of livestock holdings (# of animals) - large ruminants, small ruminants, poultry"
*any improved large ruminants, small ruminants, or poultry
gen any_imp_herd_all = 0 if any_imp_herd_lrum==0 | any_imp_herd_srum==0 | any_imp_herd_poultry==0
replace any_imp_herd_all = 1 if  any_imp_herd_lrum==1 | any_imp_herd_srum==1 | any_imp_herd_poultry==1
recode lvstck_holding* (.=0)
*Now dropping these missing variables, which I only used to construct the labels above
drop lvstck_holding animals_lost12months mean_12months lost_disease
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_herd_characteristics", replace
restore

*Generating imputed values for animals
*NOTE: Bee colonies not captured in TLU.
gen price_per_animal = value_livestock_sales/number_sold
recode price_per_animal (0=.)
merge m:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hhids.dta", nogen keep(1 3)
merge m:1 region zone woreda kebele livestock_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_prices_kebele.dta", nogen
merge m:1 region zone woreda livestock_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_prices_woreda.dta", nogen
merge m:1 region zone livestock_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_prices_zone.dta", nogen
merge m:1 region livestock_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_prices_region.dta", nogen
merge m:1 livestock_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_prices_country.dta", nogen
replace price_per_animal = price_median_kebele if price_per_animal==. & obs_kebele >= 10
replace price_per_animal = price_median_woreda if price_per_animal==. & obs_woreda >= 10
replace price_per_animal = price_median_zone if price_per_animal==. & obs_zone >= 10
replace price_per_animal = price_median_region if price_per_animal==. & obs_region >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_today = number_today * price_per_animal
collapse (sum) tlu_today value_today, by (household_id2)
lab var tlu_today "Tropical Livestock Units as of the time of survey"
lab var value_today "Value of livestock holdings today"
gen lvstck_holding_tlu = tlu_today
lab var lvstck_holding_tlu "Total HH livestock holdings, TLU"  
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_TLU.dta", replace


********************************************************************************
*SELF-EMPLOYMENT INCOME
********************************************************************************
use "${Ethiopia_ESS_W2_raw_data}/sect11b_hh_w2.dta", clear
ren hh_s11bq09 months_activ  
ren hh_s11bq13 avg_monthly_sales
egen monthly_expenses = rowtotal(hh_s11bq14_a- hh_s11bq14_e)
*7 observations with positive expenses but missing info on business income. These won't be considered at all.
drop if (monthly_expenses>0 & monthly_expenses!=.) & avg_monthly_sales ==.
gen monthly_profit = (avg_monthly_sales - monthly_expenses)
gen annual_selfemp_profit = monthly_profit * months_activ
recode annual_selfemp_profit (.=0)
collapse (sum) annual_selfemp_profit, by (household_id2)
lab var annual_selfemp_profit "Estimated annual net profit from self-employment over previous 12 months"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_self_employment_income.dta", replace


********************************************************************************
*WAGE INCOME
********************************************************************************
*Non agricultural wage income
use "${Ethiopia_ESS_W2_raw_data}/sect4_hh_w2.dta", clear
ren hh_s4q10_b occupation_code 
ren hh_s4q11_b industry_code 
ren hh_s4q09 mainwage_yesno
ren hh_s4q13 mainwage_number_months
ren hh_s4q14 mainwage_number_weeks
ren hh_s4q15 mainwage_number_hours
ren hh_s4q16 mainwage_recent_payment
replace mainwage_recent_payment = . if occupation_code==6 | industry_code==1 | industry_code==2
ren hh_s4q17 mainwage_payment_period
ren hh_s4q20 secwage_yesno
ren hh_s4q24 secwage_number_months
ren hh_s4q25 secwage_number_weeks
ren hh_s4q26 secwage_number_hours
ren hh_s4q27 secwage_recent_payment
replace secwage_recent_payment = . if occupation_code==6 | industry_code==1 | industry_code==2
ren hh_s4q28 secwage_payment_period
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
ren hh_s4q33 income_psnp
recode mainwage_annual_salary secwage_annual_salary income_psnp (.=0)
gen annual_salary = mainwage_annual_salary + secwage_annual_salary + income_psnp
collapse (sum) annual_salary, by (household_id2)
lab var annual_salary "Estimated annual earnings from non-agricultural wage employment over previous 12 months"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_wage_income.dta", replace

*Agwage
use "${Ethiopia_ESS_W2_raw_data}/sect4_hh_w2.dta", clear
ren hh_s4q10_b occupation_code 
ren hh_s4q11_b industry_code 
ren hh_s4q09 mainwage_yesno
ren hh_s4q13 mainwage_number_months
ren hh_s4q14 mainwage_number_weeks
ren hh_s4q15 mainwage_number_hours
ren hh_s4q16 mainwage_recent_payment
replace mainwage_recent_payment = . if occupation_code!=6  & industry_code!=1 & industry_code!=2
ren hh_s4q17 mainwage_payment_period
ren hh_s4q20 secwage_yesno
ren hh_s4q24 secwage_number_months
ren hh_s4q25 secwage_number_weeks
ren hh_s4q26 secwage_number_hours
ren hh_s4q27 secwage_recent_payment
replace secwage_recent_payment = . if occupation_code!=6  & industry_code!=1 & industry_code!=2
ren hh_s4q28 secwage_payment_period
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
recode mainwage_annual_salary secwage_annual_salary (.=0)
gen annual_salary_agwage = mainwage_annual_salary + secwage_annual_salary
collapse (sum) annual_salary_agwage, by (household_id2)
lab var annual_salary_agwage "Estimated annual earnings from agricultural wage employment over previous 12 months"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_agwage_income.dta", replace


********************************************************************************
*OTHER INCOME
********************************************************************************
use "${Ethiopia_ESS_W2_raw_data}/sect12_hh_w2.dta", clear
ren hh_s12q02 amount_received
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
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_other_income.dta", replace

use "${Ethiopia_ESS_W2_raw_data}/sect13_hh_w2.dta", clear
ren hh_s13q00 assistance_code
ren hh_s13q03 amount_received 
gen psnp_income = amount_received if assistance_code=="A"
gen assistance_income = amount_received if assistance_code=="B"|assistance_code=="C"|assistance_code=="D"|assistance_code=="E"
recode psnp_income assistance_income (.=0)
collapse (sum) psnp_income assistance_income, by (household_id2)
lab var psnp_income "Estimated income from a PSNP over previous 12 months"
lab var assistance_income "Estimated income from a food aid, food-for-work, etc. over previous 12 months"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_assistance_income.dta", replace

use "${Ethiopia_ESS_W2_raw_data}/sect2_pp_w2.dta", clear
ren pp_s2q13_a land_rental_income_cash
ren pp_s2q13_b land_rental_income_inkind
recode land_rental_income_cash land_rental_income_inkind (.=0)
gen land_rental_income_upfront = land_rental_income_cash + land_rental_income_inkind
collapse (sum) land_rental_income_upfront, by (household_id2)
lab var land_rental_income_upfront "Estimated income from renting out land over previous 12 months (upfront payments only)"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_land_rental_income.dta", replace


********************************************************************************
*OFF-FARM HOURS
********************************************************************************
use "${Ethiopia_ESS_W2_raw_data}/sect4_hh_w2.dta", clear
ren hh_s4q10_b occupation_code 
ren hh_s4q11_b industry_code 
gen primary_hours = hh_s4q15 if occupation_code!=6 | industry_code!=1 | industry_code!=2
gen secondary_hours = hh_s4q26 if occupation_code!=6 | industry_code!=1 | industry_code!=2
*Instrument doesn't ask about the number of hours worked for own business or PSNP
egen off_farm_hours = rowtotal(primary_hours secondary_hours)
gen off_farm_any_count = off_farm_hours!=0
gen member_count = 1
collapse (sum) off_farm_hours off_farm_any_count member_count, by(household_id2)
la var member_count "Number of HH members age 5 or above"
la var off_farm_any_count "Number of HH members with positive off-farm hours"
la var off_farm_hours "Total household off-farm hours"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_off_farm_hours.dta", replace


********************************************************************************
*FARM LABOR
********************************************************************************
*Farm labor
use "${Ethiopia_ESS_W2_raw_data}/sect3_pp_w2.dta", clear
ren pp_s3q28_a number_men
ren pp_s3q28_b number_days_men
ren pp_s3q28_d number_women
ren pp_s3q28_e number_days_women
ren pp_s3q28_g number_children
ren pp_s3q28_h number_days_children
gen days_men = number_men * number_days_men 
gen days_women = number_women * number_days_women  
gen days_children = number_children * number_days_children 
recode days_men days_women days_children (.=0)
gen days_hired_postplant =  days_men + days_women + days_children
ren pp_s3q27_b weeks_1 
ren pp_s3q27_c days_week_1 
ren pp_s3q27_f weeks_2
ren pp_s3q27_g days_week_2
ren pp_s3q27_j weeks_3
ren pp_s3q27_k days_week_3
ren pp_s3q27_n weeks_4
ren pp_s3q27_o days_week_4
ren pp_s3q27_r weeks_5
ren pp_s3q27_s days_week_5
ren pp_s3q27_v weeks_6
ren pp_s3q27_w days_week_6
ren pp_s3q27_z weeks_7
ren pp_s3q27_ca days_week_7
recode weeks_1 days_week_1 weeks_2 days_week_2 weeks_3 days_week_3 weeks_4 days_week_4 weeks_5 days_week_5 weeks_6 days_week_6 weeks_7 days_week_7(.=0)
gen days_famlabor_postplant = (weeks_1 * days_week_1) + (weeks_2 * days_week_2) + (weeks_3 * days_week_3) + (weeks_4 * days_week_4) + (weeks_5 * days_week_5) + (weeks_6 * days_week_6) + (weeks_7 * days_week_7)
ren pp_s3q29_a number_men_other
ren pp_s3q29_b days_men_other
ren pp_s3q29_c number_women_other
ren pp_s3q29_d days_women_other
ren pp_s3q29_e number_child_other
ren pp_s3q29_f days_child_other
recode number_men_other days_men_other number_women_other days_women_other number_child_other days_child_other (.=0)
gen days_otherlabor_postplant = (number_men_other * days_men_other) + (number_women_other * days_women_other) + (number_child_other * days_child_other)
ren days_women days_hired_postplant_female
ren days_men days_hired_postplant_male
ren days_children days_hired_postplant_child
collapse (sum) days_hired_postplant days_famlabor_postplant days_otherlabor_postplant days_hired_postplant_female days_hired_postplant_male days_hired_postplant_child, by (holder_id household_id2 parcel_id field_id)
lab var days_famlabor_postplant "Workdays for family labor (crops), as captured in post-planting survey"
lab var days_hired_postplant "Workdays for hired labor (crops), as captured in post-planting survey"
lab var days_hired_postplant_female "Workdays for hired female labor (crops), as captured in post-planting survey"
lab var days_hired_postplant_male "Workdays for hired male labor (crops), as captured in post-planting survey"
lab var days_hired_postplant_child "Workdays for hired child labor (crops), as captured in post-planting survey"
lab var days_otherlabor_postplant "Workdays for other labor (crops), as captured in post-planting survey"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_plot_farmlabor_postplanting.dta", replace
collapse (sum) days_hired_postplant days_famlabor_postplant days_otherlabor_postplant days_hired_postplant_female days_hired_postplant_male days_hired_postplant_child, by (household_id2)
lab var days_famlabor_postplant "Workdays for family labor (crops), as captured in post-planting survey"
lab var days_hired_postplant "Workdays for hired labor (crops), as captured in post-planting survey"
lab var days_hired_postplant_female "Workdays for hired female labor (crops), as captured in post-planting survey"
lab var days_hired_postplant_male "Workdays for hired male labor (crops), as captured in post-planting survey"
lab var days_hired_postplant_child "Workdays for hired child labor (crops), as captured in post-planting survey"
lab var days_otherlabor_postplant "Workdays for other labor (crops), as captured in post-planting survey"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_farmlabor_postplanting.dta", replace
*Large outliers with hired labor. These might be larger commercial farms?

use "${Ethiopia_ESS_W2_raw_data}/sect10_ph_w2.dta", clear
ren ph_s10q01_a number_men
ren ph_s10q01_b number_days_men
ren ph_s10q01_d number_women
ren ph_s10q01_e number_days_women
ren ph_s10q01_g number_children
ren ph_s10q01_h number_days_children
gen days_men = number_men * number_days_men 
gen days_women = number_women * number_days_women  
gen days_children = number_children * number_days_children 
recode days_men days_women days_children (.=0)
gen days_hired_postharvest =  days_men + days_women + days_children
ren ph_s10q02_b weeks_1 
ren ph_s10q02_c days_week_1 
ren ph_s10q02_f weeks_2
ren ph_s10q02_g days_week_2
ren ph_s10q02_j weeks_3
ren ph_s10q02_k days_week_3
ren ph_s10q02_n weeks_4
ren ph_s10q02_o days_week_4
ren ph_s10q02_r weeks_5
ren ph_s10q02_s days_week_5
ren ph_s10q02_v weeks_6
ren ph_s10q02_w days_week_6
ren ph_s10q02_z weeks_7
ren ph_s10q02_ka days_week_7
recode weeks_1 days_week_1 weeks_2 days_week_2 weeks_3 days_week_3 weeks_4 days_week_4 weeks_5 days_week_5 weeks_6 days_week_6 weeks_7 days_week_7(.=0)
gen days_famlabor_postharvest = (weeks_1 * days_week_1) + (weeks_2 * days_week_2) + (weeks_3 * days_week_3) + (weeks_4 * days_week_4) + (weeks_5 * days_week_5) + (weeks_6 * days_week_6) + (weeks_7 * days_week_7)
ren ph_s10q03_a number_men_other
ren ph_s10q03_b days_men_other
ren ph_s10q03_c number_women_other
ren ph_s10q03_d days_women_other
ren ph_s10q03_e number_child_other
ren ph_s10q03_f days_child_other
recode number_men_other days_men_other number_women_other days_women_other number_child_other days_child_other (.=0)
gen days_otherlabor_postharvest = (number_men_other * days_men_other) + (number_women_other * days_women_other) + (number_child_other * days_child_other)
ren days_women days_hired_postharvest_female
ren days_men days_hired_postharvest_male
ren days_children days_hired_postharvest_child
collapse (sum) days_hired_postharvest days_famlabor_postharvest days_otherlabor_postharvest days_hired_postharvest_female days_hired_postharvest_male days_hired_postharvest_child, by (holder_id household_id2 parcel_id field_id)
lab var days_hired_postharvest "Workdays for hired labor (crops), as captured in post-harvest survey"
lab var days_hired_postharvest_female "Workdays for hired female labor (crops), as captured in post-harvest survey"
lab var days_hired_postharvest_male "Workdays for hired male labor (crops), as captured in post-harvest survey"
lab var days_hired_postharvest_child "Workdays for hired child labor (crops), as captured in post-harvest survey"
lab var days_famlabor_postharvest "Workdays for family labor (crops), as captured in post-harvest survey"
lab var days_otherlabor_postharvest "Workdays for other labor (crops), as captured in post-harvest survey"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_plot_farmlabor_postharvest.dta", replace
collapse (sum) days_hired_postharvest days_famlabor_postharvest days_otherlabor_postharvest days_hired_postharvest_female days_hired_postharvest_male days_hired_postharvest_child, by (household_id2)
lab var days_hired_postharvest "Workdays for hired labor (crops), as captured in post-harvest survey"
lab var days_hired_postharvest_female "Workdays for hired female labor (crops), as captured in post-harvest survey"
lab var days_hired_postharvest_male "Workdays for hired male labor (crops), as captured in post-harvest survey"
lab var days_hired_postharvest_child "Workdays for hired child labor (crops), as captured in post-harvest survey"
lab var days_famlabor_postharvest "Workdays for family labor (crops), as captured in post-harvest survey"
lab var days_otherlabor_postharvest "Workdays for other labor (crops), as captured in post-harvest survey"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_farmlabor_postharvest.dta", replace


********************************************************************************
*FARM SIZE
********************************************************************************
use "${Ethiopia_ESS_W2_raw_data}/sect9_ph_w2.dta", clear
*All parcels here (which are subdivided into fields) were cultivated, whether in the belg or meher season.
gen cultivated=1
collapse (max) cultivated, by (household_id2 parcel_id field_id)
lab var cultivated "1= Field was cultivated in this data set"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_parcels_cultivated.dta", replace

use "${Ethiopia_ESS_W2_raw_data}/sect3_pp_w2.dta", clear
ren pp_s3q02_a area 
ren pp_s3q02_c local_unit 
ren pp_s3q05_a area_sqmeters_gps 
replace area_sqmeters_gps=. if area_sqmeters_gps<0
keep household_id2 parcel_id field_id area local_unit area_sqmeters_gps
merge m:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hhids.dta", nogen keep(1 3)
gen sqmeters_per_unit = area_sqmeters_gps/area
gen observations = 1
collapse (median) sqmeters_per_unit (count) observations [aw=weight], by (region zone local_unit)
ren sqmeters_per_unit sqmeters_per_unit_zone 
ren observations obs_zone
lab var sqmeters_per_unit_zone "Square meters per local unit (median value for this region and zone)"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_area_lookup_zone.dta", replace

use "${Ethiopia_ESS_W2_raw_data}/sect3_pp_w2.dta", clear
ren pp_s3q02_a area 
ren pp_s3q02_c local_unit 
ren pp_s3q05_a area_sqmeters_gps 
replace area_sqmeters_gps=. if area_sqmeters_gps<0
replace area_sqmeters_gps=. if area_sqmeters_gps==0  		
keep household_id2 parcel_id field_id area local_unit area_sqmeters_gps
merge m:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hhids.dta", nogen keep(1 3)
gen sqmeters_per_unit = area_sqmeters_gps/area
gen observations = 1
collapse (median) sqmeters_per_unit (count) observations [aw=weight], by (region local_unit)
ren sqmeters_per_unit sqmeters_per_unit_region
ren observations obs_region
lab var sqmeters_per_unit_region "Square meters per local unit (median value for this region)"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_area_lookup_region.dta", replace

use "${Ethiopia_ESS_W2_raw_data}/sect3_pp_w2.dta", clear
ren pp_s3q02_a area 
ren pp_s3q02_c local_unit 
ren pp_s3q05_a area_sqmeters_gps 
replace area_sqmeters_gps=. if area_sqmeters_gps<0
keep household_id2 parcel_id field_id area local_unit area_sqmeters_gps
merge m:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hhids.dta", nogen keep(1 3)
gen sqmeters_per_unit = area_sqmeters_gps/area
gen observations = 1
collapse (median) sqmeters_per_unit (count) observations [aw=weight], by (local_unit)
ren sqmeters_per_unit sqmeters_per_unit_country
ren observations obs_country
lab var sqmeters_per_unit_country "Square meters per local unit (median value for the country)"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_area_lookup_country.dta", replace

use "${Ethiopia_ESS_W2_raw_data}/sect3_pp_w2.dta", clear
ren pp_s3q02_a area 
ren pp_s3q02_c local_unit 
ren pp_s3q05_a area_sqmeters_gps 
replace area_sqmeters_gps=. if area_sqmeters_gps<0
replace area_sqmeters_gps=. if area_sqmeters_gps==0  		
keep household_id2 parcel_id holder_id field_id area local_unit area_sqmeters_gps
merge m:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hhids.dta", nogen keep(1 3)
merge m:1 region zone woreda local_unit using "${Ethiopia_ESS_W2_raw_data}/ET_local_area_unit_conversion.dta", nogen keep(1 3)
gen area_est_hectares = area if local_unit==1
replace area_est_hectares = (area/10000) if local_unit==2
replace area_est_hectares = (area*conversion/10000) if (local_unit!=1 & local_unit!=2 & local_unit!=11)
merge m:1 region zone local_unit using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_area_lookup_zone.dta", nogen
replace area_est_hectares = (area*(sqmeters_per_unit_zone/10000)) if local_unit!=11 & area_est_hectares==. & obs_zone>=10
merge m:1 region local_unit using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_area_lookup_region.dta", nogen
replace area_est_hectares = (area*(sqmeters_per_unit_region/10000)) if local_unit!=11 & area_est_hectares==. & obs_region>=10
merge m:1 local_unit using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_area_lookup_country.dta", nogen
replace area_est_hectares = (area*(sqmeters_per_unit_country/10000)) if local_unit!=11 & area_est_hectares==.
gen area_meas_hectares = (area_sqmeters_gps/10000)
replace area_meas_hectares = area_est_hectares if area_meas_hectares==.
count if area!=. & area_meas_hectares==.
*All areas are converted to hectares
replace area_meas_hectares = 0 if area_meas_hectares == .
lab var area_meas_hectares "Area measured in hectares, with missing obs imputed using local median per-unit values"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_plot_sizes.dta", replace
merge m:1 household_id2 parcel_id field_id using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_parcels_cultivated.dta"
keep if cultivated==1
collapse (sum) area_meas_hectares, by (household_id2)
ren area_meas_hectares farm_area
lab var farm_area "Land size (denominator for land productivitiy), in hectares" 
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_land_size.dta", replace

*All Agricultural Land
use "${Ethiopia_ESS_W2_raw_data}/sect3_pp_w2.dta", clear
gen agland = (pp_s3q03==1 | pp_s3q03==2 | pp_s3q03==3 | pp_s3q03==5) // Cultivated, prepared for Belg season, pasture, or fallow. Excludes forest, rented out, and "other"
merge m:1 household_id2 parcel_id field_id using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_parcels_cultivated.dta", nogen keep(1 3)
replace agland=1 if cultivated==1
keep if agland==1
keep household_id2 parcel_id field_id holder_id agland
lab var agland "1= Plot was used for cultivated, pasture, or fallow"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_parcels_agland.dta", replace

use "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_plot_sizes.dta", clear
merge 1:1 household_id2 parcel_id holder_id field_id using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_parcels_agland.dta", nogen
collapse (sum) area_meas_hectares, by (household_id2)
ren area_meas_hectares farm_size_agland
lab var farm_size_agland "Land size in hectares, including all plots cultivated, fallow, or pastureland"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_farmsize_all_agland.dta", replace


********************************************************************************
*LAND SIZE
********************************************************************************
use "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_plot_sizes.dta", clear
collapse (sum) area_meas_hectares, by (household_id2)
ren area_meas_hectares land_size
lab var land_size "Land size in hectares, including all plots listed by the household (and not rented out)" /* Uses measures */
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_land_size_all.dta", replace

*Rent-out status comes at the parcel level, but area is at field level. Some parcels are mixed (held and rented out).
*So we might accidentally be including rented-out fields in the land size.
*Land size in Ethiopia LSMS also includes the homestead, which differs from other surveys.

********************************************************************************
* VACCINE USAGE *
********************************************************************************
use "${Ethiopia_ESS_W2_raw_data}/sect8a_ls_w2.dta", clear
ren ls_s8aq13a number_livestock_owned
ren ls_s8aq51a number_livestock_vaccinated
gen vac_animal=0
replace vac_animal=1 if number_livestock_vaccinated >0 & number_livestock_vaccinated !=.
replace vac_animal=. if number_livestock_owned==0
*Disagregating vaccine use by animal type
ren ls_s8aq00 livestock_code
gen species = (inlist(livestock_code,1)) + 2*(inlist(livestock_code,2,3)) + 3*(inlist(livestock_code,7)) + 4*(inlist(livestock_code,4,5,6)) + 5*(inlist(livestock_code,8,9,10,11,12,13))
recode species (0=.)
la def species 1 "Large ruminants (cows)" 2 "Small ruminants (sheep, goats)" 3 "Camels" 4 "Equine (horses, donkies, mules)" 5 "Poultry"
la val species species
*Using a loop to create species variables
foreach i in vac_animal {
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==2
	gen `i'_camels = `i' if species==3
	gen `i'_equine = `i' if species==4
	gen `i'_poultry = `i' if species==5
}
collapse (max) vac_animal*, by (household_id2)
lab var vac_animal "1= Household has an animal vaccinated"
foreach i in vac_animal {
	local l`i' : var lab `i'
	lab var `i'_lrum "`l`i'' - large ruminants"
	lab var `i'_srum "`l`i'' - small ruminants"
	lab var `i'_camels "`l`i'' - camels"
	lab var `i'_equine "`l`i'' - equine"
	lab var `i'_poultry "`l`i'' - poultry"
}
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_vaccine.dta", replace

*Vaccine use livestock keeper (holder)
use "$Ethiopia_ESS_W2_raw_data/sect8a_ls_w2.dta", clear
ren ls_s8aq13a number_livestock_owned
ren ls_s8aq51a number_livestock_vaccinated
gen all_vac_animal=0
replace all_vac_animal=1 if number_livestock_vaccinated >0 & number_livestock_vaccinated !=.
replace all_vac_animal=. if number_livestock_owned==0
ren ls_saq07 farmerid
collapse (max) all_vac_animal , by(household_id2 farmerid)
gen personid=farmerid
drop if personid==.
keep all_vac_animal personid household_id2 farmerid
merge m:1 household_id2 personid using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_gender_merge_both.dta", gen(f_merge)   keep(1 3)
keep all_vac_animal personid household_id2 female farmerid
gen female_vac_animal=all_vac_animal if female==1
gen male_vac_animal=all_vac_animal if female==0
lab var all_vac_animal "1 = Individual farmer (livestock keeper) uses vaccines"
lab var male_vac_animal "1 = Individual male farmers (livestock keeper) uses vaccines"
lab var female_vac_animal "1 = Individual female farmers (livestock keeper) uses vaccines"
gen livestock_keeper=1 if farmerid!=.
recode livestock_keeper (.=0)
lab var livestock_keeper "1=Indvidual is listed as a livestock keeper (at least one type of livestock)" 
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_farmer_vaccine.dta", replace


********************************************************************************
*ANIMAL HEALTH - DISEASES
********************************************************************************
use "$Ethiopia_ESS_W2_raw_data/sect8a_ls_w2.dta", clear
gen disease_animal = (ls_s8aq41a>0) 
replace disease_animal = . if ls_s8aq41a==.
*no specific disease information
ren ls_s8aq00 livestock_code
gen species = (inlist(livestock_code,1)) + 2*(inlist(livestock_code,2,3)) + 3*(inlist(livestock_code,7)) + 4*(inlist(livestock_code,4,5,6)) + 5*(inlist(livestock_code,8,9,10,11,12,13))
recode species (0=.)
la def species 1 "Large ruminants (cows)" 2 "Small ruminants (sheep, goats)" 3 "Camels" 4 "Equine (horses, donkies, mules)" 5 "Poultry"
la val species species
*A loop to create species variables
foreach i in disease_animal{
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==2
	gen `i'_pigs = `i' if species==3
	gen `i'_equine = `i' if species==4
	gen `i'_poultry = `i' if species==5
}
collapse (max) disease_*, by (household_id2)
lab var disease_animal "1= Household has animal that suffered from disease"
foreach i in disease_animal{
	local l`i' : var lab `i'
	lab var `i'_lrum "`l`i'' - large ruminants"
	lab var `i'_srum "`l`i'' - small ruminants"
	lab var `i'_pigs "`l`i'' - pigs"
	lab var `i'_equine "`l`i'' - equine"
	lab var `i'_poultry "`l`i'' - poultry"
}
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_diseases.dta", replace


********************************************************************************
*LIVESTOCK WATER, FEEDING, AND HOUSING
********************************************************************************
*no information 


********************************************************************************
* USE OF INORGANIC FERTILIZER *
********************************************************************************
use "${Ethiopia_ESS_W2_raw_data}/sect3_pp_w2.dta", clear
gen use_inorg_fert=0
replace use_inorg_fert=1 if pp_s3q15==1 | pp_s3q18==1 | pp_s3q20a==1
collapse (max) use_inorg_fert, by (household_id2)
lab var use_inorg_fert "1= Household uses inorganic fertilizer"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_fert_use.dta", replace

*Fertilizer use by farmers (a farmer is an individual listed as plot manager)
use "$Ethiopia_ESS_W2_raw_data/sect3_pp_w2.dta", clear
gen all_use_inorg_fert=0
replace all_use_inorg_fert=1 if pp_s3q15==1 | pp_s3q18==1 | pp_s3q20a==1
ren pp_saq07 farmerid 
collapse (max) all_use_inorg_fert , by(household_id2 farmerid)
gen personid=farmerid
drop if personid==.
merge m:1 household_id2 personid using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_gender_merge_both.dta", gen(f_merge)   keep(1 3)			// Dropping unmatched from using
keep all_use_inorg_fert personid household_id2 female farmerid
gen female_use_inorg_fert=all_use_inorg_fert if female==1
gen male_use_inorg_fert=all_use_inorg_fert if female==0
lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
lab var male_use_inorg_fert "1 = Individual male farmers (plot manager) uses inorganic fertilizer"
lab var female_use_inorg_fert "1 = Individual female farmers (plot manager) uses inorganic fertilizer"
gen farm_manager=1 if farmerid!=.
recode farm_manager (.=0)
lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_farmer_fert_use.dta", replace


********************************************************************************
* USE OF IMPROVED SEED *
********************************************************************************
use "${Ethiopia_ESS_W2_raw_data}/sect4_pp_w2.dta", clear
gen imprv_seed_use=0
replace imprv_seed_use=1 if pp_s4q11==2
forvalues k=1(1)$nb_topcrops {
	local c: word `k' of $topcrop_area	
	local cn: word `k' of $topcropname_area
	gen imprv_seed_`cn'=imprv_seed_use if crop_code==`c'
	gen hybrid_seed_`cn'=.		//instrument doesn't ask about hybrid seeds
}
collapse (max) imprv_seed_* hybrid_seed_*, by(household_id2)
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	local cnfull: word `k' of $topcropname_full
	lab var imprv_seed_`cn' "1= Household uses improved `cnfull' seed"
	lab var imprv_seed_`cn' "1= Household uses hybrid `cnfull' seed"

}
lab var imprv_seed_use "1= Household uses improved seed"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_improvedseed_use.dta", replace

*Seed adoption by farmers (a farmer is an individual listed as plot manager)
use "$Ethiopia_ESS_W2_raw_data/sect4_pp_w2.dta", clear
gen all_imprv_seed_use=.
replace all_imprv_seed_use= (pp_s4q11==2)
ren pp_saq07 farmerid 
collapse (max) all_imprv_seed_use, by(household_id2 farmerid)
gen personid=farmerid
drop if personid==.
merge m:1 household_id2 personid using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_gender_merge_both.dta", gen(f_merge)   keep(1 3)			// Dropping unmatched from using
drop household_id- pp_s1q05 ph_saq07- f_merge
gen female_imprv_seed_use=all_imprv_seed_use if female==1
gen male_imprv_seed_use=all_imprv_seed_use if female==0
lab var all_imprv_seed_use "1 = Individual farmer (plot manager) uses improved seeds"
lab var male_imprv_seed_use "1 = Individual male farmers (plot manager) uses improved seeds"
lab var female_imprv_seed_use "1 = Individual female farmers (plot manager) uses improved seeds"
gen farm_manager=1 if farmerid!=.
recode farm_manager (.=0)
lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_farmer_improvedseed_use.dta", replace

*Seed adoption by farmers (a farmer is an individual listed as plot manager) for monocropped plots
use "$Ethiopia_ESS_W2_raw_data/sect4_pp_w2.dta", clear
gen all_imprv_seed_use=.
replace all_imprv_seed_use= (pp_s4q11==2)
forvalues k=1(1)$nb_topcrops {
	local c: word `k' of $topcrop_area
	local cn: word `k' of $topcropname_area
	local cnfull: word `k' of $topcropname_full
	preserve
		gen all_imprv_seed_`cn'=all_imprv_seed_use if crop_code==`c'
		gen all_hybrid_seed_`cn'=.		//Doesn't ask about hybrid seeds
		ren pp_saq07 farmerid 
		gen `cn'_farmer= crop_code==`c'
		collapse (max) all_imprv_seed_`cn' all_hybrid_seed_`cn' `cn'_farmer, by(household_id2 farmerid)
		gen personid=farmerid
		drop if personid==.
		merge m:1 household_id2 personid using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_gender_merge_both.dta", gen(f_merge)   keep(1 3)			// Dropping unmatched from using
		drop household_id- pp_s1q05 ph_saq07- f_merge
		gen female_imprv_seed_`cn'=all_imprv_seed_`cn' if female==1
		gen male_imprv_seed_`cn'=all_imprv_seed_`cn' if female==0
		lab var all_imprv_seed_`cn' "1 = Individual farmer (plot manager) uses improved `cnfull' seeds"
		lab var male_imprv_seed_`cn' "1 = Individual male farmers (plot manager) uses improved `cnfull' seeds"
		lab var female_imprv_seed_`cn' "1 = Individual female farmers (plot manager) uses improved `cnfull' seeds"
		gen farm_manager=1 if farmerid!=.
		recode farm_manager (.=0)
		lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
		save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_farmer_improvedseed_use_`cn'.dta", replace
	restore
}


********************************************************************************
* REACHED BY AG EXTENSION *
********************************************************************************
use "${Ethiopia_ESS_W2_raw_data}/sect3_pp_w2.dta", clear
merge m:m household_id using "${Ethiopia_ESS_W2_raw_data}/sect5_pp_w2.dta", nogen
merge m:m household_id using "${Ethiopia_ESS_W2_raw_data}/sect7_pp_w2.dta", nogen
gen ext_reach_all=0
replace ext_reach_all=1 if pp_s3q11==1 | pp_s7q04==1 | pp_s5q02==4
collapse (max) ext_reach_all, by (household_id2)
lab var ext_reach "1= Household reached by extention services"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_any_ext.dta", replace


********************************************************************************
* USE OF FORMAL FINANCIAL SERVICES *
********************************************************************************
use "${Ethiopia_ESS_W2_raw_data}/sect14b_hh_w2.dta", clear
merge m:m household_id2 using "${Ethiopia_ESS_W2_raw_data}/sect11b_hh_w2.dta", nogen
gen use_fin_serv=0
replace use_fin_serv=1 if hh_s14q02_b==7 |  hh_s14q02_b==8 | hh_s11bq04c==1
ren use_fin_serv use_fin_serv_credit
collapse (max) use_fin_serv_credit, by (household_id2)
recode use_fin_serv_credit (.=0)
lab var use_fin_serv_credit "1= Household uses formal financial services"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_fin_serv.dta", replace


********************************************************************************
* MILK PRODUCTIVITY *
********************************************************************************
use "${Ethiopia_ESS_W2_raw_data}/sect8a_ls_w2.dta", clear
gen cows = ls_s8aq00 ==1
keep if cows
gen milk_animals = ls_8aq29_b				// number of livestock milked (by holder)
gen months_milked = ls_s8aq30				// average months milked in last year (by holder)
gen liters_day = ls_s8aq32_1				// average quantity (liters) per day
gen liters_per_cow = (liters_day*365*(months_milked/12))	
lab var milk_animals "Number of large ruminants that was milked (household)"
lab var months_milked "Average months milked in last year (household)"
lab var liters_per_cow "average quantity (liters) per year (household)"
collapse (sum) milk_animals liters_per_cow, by(household_id2)
keep if milk_animals!=0
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_milk_animals.dta", replace


********************************************************************************
* EGG PRODUCTIVITY *
********************************************************************************
use "${Ethiopia_ESS_W2_raw_data}/sect8a_ls_w2.dta", clear
gen clutching_periods_local = ls_s8aq39			// number of clutching periods per hen in last 12 months (local)
gen clutching_periods_hybrid = ls_s8aq40		// number of clutching periods per hen in last 12 months (hybrid)
gen eggs_clutch_local = ls_s8aq33				// number of eggs per clutch (local)
gen eggs_clutch_hybrid = ls_s8aq34				// number of eggs per clutch (hybrid)
gen laying_hens_local= ls_s8aq14a if ls_s8aq00==8
gen laying_hens_hybrid= ls_s8aq16a if ls_s8aq00==8
gen laying_hens = laying_hens_local + laying_hens_hybrid
gen eggs_per_hen_local = eggs_clutch_local*clutching_periods_local
gen eggs_per_hen_hybrid = eggs_clutch_hybrid*clutching_periods_hybrid
egen eggs_per_hen = rowtotal(eggs_per_hen_local eggs_per_hen_hybrid)
keep if eggs_per_hen!=0
collapse (mean) eggs_per_hen (sum) laying_hens, by(household_id2)
ren eggs_per_hen egg_poultry_year
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_eggs_animals.dta", replace


********************************************************************************
* CROP PRODUCTION COSTS PER HECTARE *
********************************************************************************
*Land rental rates
use "${Ethiopia_ESS_W2_raw_data}/sect2_pp_w2.dta", clear
drop if pp_s2q01b==2				// parcel no longer owned or rented
*Renaming 
ren pp_s2q13_a land_rental_income_cash
ren pp_s2q13_b land_rental_income_inkind
ren pp_s2q07_a rental_cost_cash
ren pp_s2q07_b rental_cost_inkind
recode land_rental_income_cash land_rental_income_inkind (.=0)
gen land_rental_income_upfront = land_rental_income_cash + land_rental_income_inkind
gen rented_plot = (pp_s2q03==3)
*Need to merge in value harvested here
merge 1:1 household_id2 holder_id parcel_id using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_production_parcel.dta", nogen keep(1 3) 
*Now merging in area of PARCEL (the area this dataset is at) - "land_size" is area variable
merge 1:1 holder_id parcel_id using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_parcel_area.dta", nogen keep(1 3)
recode rental_cost_cash rental_cost_inkind (.=0)
gen rental_cost_land = rental_cost_cash + rental_cost_inkind
*Saving at parcel level with rental costs
preserve
keep rental_cost_land holder_id parcel_id 
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_rental_parcel.dta", replace
restore
gen any_rent = rented_plot!=0 & rented_plot!=.
gen plot_rental_rate = rental_cost_land/land_size							// at the parcel level; rent divided by rented acres (birr per ha)
recode plot_rental_rate (0=.)												// we don't want to count zeros as valid observations
gen area_meas_hectares_parcel_rental = land_size if rented_plot==1
*Getting a household-level "average" rental rate
bys household_id2: egen plot_rental_total = total(rental_cost_land)
bys household_id2: egen plot_rental_total_area = total(area_meas_hectares_parcel_rental)
gen hh_rental_rate = plot_rental_total/plot_rental_total_area			// total divided by area for birr per ha for households that paid any
recode hh_rental_rate (0=.)				
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
*Generating rental rate per hectare (use household reported price where available; otherwise require 10 price observations)
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
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_rental_rate.dta", replace

*Land value - rented land
*Starting at field area
use "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_field_area", clear
*Merging in gender
merge 1:1 holder_id parcel_id field_id using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_field_gender_dm.dta", nogen
*Merging in rental costs paid
merge m:1 holder_id parcel_id using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_rental_parcel.dta", nogen
*Merging in parcel area ("land_size")
merge m:1 household_id2 holder_id parcel_id using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_parcel_area.dta", nogen
gen percent_field = area_meas_hectares/land_size			// field area divided by land size
gen value_rented_land = rental_cost_land					// value paid in rent, including share crop
*Note that rent is at the parcel level, but decision-maker is at the field level (below parcel)
*Allocating rental costs based on percent of parcel taken up by field
gen value_rented_land_male = value_rented_land*percent_field if dm_gender==1			// male rental rate is percent of parcel times rental cost of parcel
gen value_rented_land_female = value_rented_land*percent_field if dm_gender==2			// same for female rental rate
gen value_rented_land_mixed = value_rented_land*percent_field if dm_gender==3			// same for mixed rental rate
*Value of rented land for monocropped top crop plots
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	local cnfull: word `k' of $topcropname_full
	preserve
	merge 1:1 household_id2 parcel_id field_id holder_id using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_`cn'_monocrop.dta", nogen /*assert(1 3)*/ keep(3)	
	gen value_rented_land_`cn' = value_rented_land
	gen value_rented_land_`cn'_male = value_rented_land_male
	gen value_rented_land_`cn'_female = value_rented_land_female
	gen value_rented_land_`cn'_mixed = value_rented_land_mixed
	collapse (sum) value_rented_land_`cn'*, by(household_id2)
	lab var value_rented_land_`cn' "Value of rented land (household expenditures) - `cnfull' monocropped plots only"
	lab var value_rented_land_`cn'_male "Value of rented land (household expenditures) for male-managed plots - `cnfull' monocropped plots only"
	lab var value_rented_land_`cn'_female "Value of rented land (household expenditures) for female-managed plots - `cnfull' monocropped plots only"
	lab var value_rented_land_`cn'_mixed "Value of rented land (household expenditures) for mixed-managed plots - `cnfull' monocropped plots only"
	save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_rental_value_`cn'.dta", replace
	restore
}
collapse (sum) value_rented_*, by(household_id2)				// total rental costs at the household level
lab var value_rented_land "Value of rented land (household expenditures)"
lab var value_rented_land_male "Value of rented land (household expenditures) for male-managed plots"
lab var value_rented_land_female "Value of rented land (household expenditures) for female-managed plots"
lab var value_rented_land_mixed "Value of rented land (household expenditures) for mixed-managed plots"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_rental_value.dta", replace

*Value of area planted
use "${Ethiopia_ESS_W2_raw_data}/sect4_pp_w2.dta", clear
*Percent of area
gen pure_stand = pp_s4q02==1
gen any_pure = pure_stand==1
gen any_mixed = pure_stand==0
gen percent_field = pp_s4q03/100
replace percent_field = 1 if pure_stand==1
*Merging in area
merge m:1 holder_id parcel_id field_id using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_field_area", nogen keep(1 3)	// dropping those only in using
*Merging in gender
merge m:1 holder_id parcel_id field_id using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_field_gender_dm.dta", nogen
*Construct area_planted and value separately
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
merge m:1 holder_id parcel_id using "${Ethiopia_ESS_W2_raw_data}/sect2_pp_w2.dta", gen(sect2_merge) keep(1 3)
*Merging in rental rate
merge m:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_rental_rate.dta", nogen keep(1 3) keepusing(ha_rental_rate)
*Value of all OWNED (that is, not rented) land
gen value_owned_land = ha_rental_rate*ha_planted if (pp_s2q07_a==. | pp_s2q07_a==0) & (pp_s2q07_b==. | pp_s2q07_b==0)	// cash AND in kind must be zero or missing
gen value_owned_land_male = ha_rental_rate*ha_planted_male if (pp_s2q07_a==. | pp_s2q07_a==0) & (pp_s2q07_b==. | pp_s2q07_b==0)
gen value_owned_land_female = ha_rental_rate*ha_planted_female if (pp_s2q07_a==. | pp_s2q07_a==0) & (pp_s2q07_b==. | pp_s2q07_b==0)
gen value_owned_land_mixed = ha_rental_rate*ha_planted_mixed if (pp_s2q07_a==. | pp_s2q07_a==0) & (pp_s2q07_b==. | pp_s2q07_b==0) 
drop crop_code
ren pp_s4q01_b crop_code
collapse (sum) value_owned_land* ha_planted*, by(household_id2)
lab var value_owned_land "Value of owned land that was cultivated (household)"
lab var value_owned_land_male "Value of owned land that was cultivated (male-managed)"
lab var value_owned_land_female "Value of owned land that was cultivated (female-managed)"
lab var value_owned_land_mixed "Value of owned land that was cultivated (mixed-managed)"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_cost_land.dta", replace

*Post planting expenses - implicit and explicit
use "${Ethiopia_ESS_W2_raw_data}/sect3_pp_w2.dta", clear
*Fertilizer expenses (EXPLICIT)
ren pp_s3q16d value_urea
ren pp_s3q19d value_DAP
ren pp_s3q20c value_other_chemicals
egen value_fert = rowtotal(value_urea value_DAP value_other_chemicals)
*Hired Labor
ren pp_s3q28_a number_men
ren pp_s3q28_b number_days_men
ren pp_s3q28_c wage_perday_men
ren pp_s3q28_d number_women
ren pp_s3q28_e number_days_women
ren pp_s3q28_f wage_perday_women
ren pp_s3q28_g number_children
ren pp_s3q28_h number_days_children
ren pp_s3q28_i wage_perday_children
gen wage_male = wage_perday_men/number_men				// wage per day for a single man
gen wage_female = wage_perday_women/number_women		// wage per day for a single woman
gen wage_child = wage_perday_child/number_children		// wage per day for a single child
recode wage_male wage_female wage_child (0=.)			// if they are "hired" but don't get paid, we don't want to consider that a wage observation below
*Getting household-level wage rate by taking a simple mean across crops and activities
preserve
recode wage_male number_days_men wage_female number_days_women (.=0) 	// set missing to zero to count observation with no male hired labor or with no female hired labor
gen all_wage = (wage_male*number_days_men + wage_female*number_days_women)/(number_days_men + number_days_women)	// weighted average at the HOUSEHOLD level
* re-set 0 to missing
recode wage_male number_days_men wage_female number_days_women all_wage (0=.) 
* get average wage accross all plots and crops to obtain wage at household level by  activities
collapse (mean) wage_male wage_female all_wage,by(rural saq01 saq02 saq03 saq04 saq05 household_id2)
** group activities
lab var all_wage "Daily agricultural wage (local currency)"
lab var wage_male "Daily male agricultural wage (local currency)"
lab var wage_female "Daily female agricultural wage (local currency)"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_eth_labor_group1", replace
restore
*Geographic medians of wages
foreach i in male female child{			// constructing for male, female, and child separately
	recode wage_`i' (0=.)
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
use "${Ethiopia_ESS_W2_raw_data}/sect1_pp_w2.dta", clear
ren pp_s1q00 pid
drop if pid==.
isid holder_id pid			
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
count if fam_merge1==1 & pp_s3q27_c!=. & pp_s3q27_c!=0
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
*Now "member 5"
gen pid = pp_s3q27_q				// PID for member 5
merge m:1 holder_id pid using `members', gen(fam_merge5) keep(1 3)		// many not matched from master 
ren male male5		// renaming in order to merge again
ren pid pid15
ren age age5
*Now "member 6"
gen pid = pp_s3q27_u				// PID for member 6
merge m:1 holder_id pid using `members', gen(fam_merge6) keep(1 3)		// many not matched from master 
ren male male6		// renaming in order to merge again
ren pid pid16
ren age age6
*Now "member 7"
gen pid = pp_s3q27_y				// PID for member 7
merge m:1 holder_id pid using `members', gen(fam_merge7) keep(1 3)		// many not matched from master 
ren male male7		// renaming in order to merge again
ren pid pid17
ren age age7
recode male1 male2 male3 male4 male5 male6 male7(.=1)				// NOTE: Assuming male if missing (there are a couple dozen)
gen male_fam_days1 = pp_s3q27_b*pp_s3q27_c if male1 & age1>=15		// NOTE: Assuming missing ages are adults
gen male_fam_days2 = pp_s3q27_f*pp_s3q27_g if male2 & age2>=15
gen male_fam_days3 = pp_s3q27_j*pp_s3q27_k if male3 & age3>=15
gen male_fam_days4 = pp_s3q27_n*pp_s3q27_o if male4 & age4>=15
gen male_fam_days5 = pp_s3q27_r*pp_s3q27_s if male5 & age5>=15
gen male_fam_days6 = pp_s3q27_v*pp_s3q27_w if male6 & age6>=15
gen male_fam_days7 = pp_s3q27_z*pp_s3q27_ca if male7 & age7>=15
gen female_fam_days1 = pp_s3q27_b*pp_s3q27_c if !male1 & age1>=15	//  NOTE: Assuming missing ages are adults
gen female_fam_days2 = pp_s3q27_f*pp_s3q27_g if !male2 & age2>=15
gen female_fam_days3 = pp_s3q27_j*pp_s3q27_k if !male3 & age3>=15
gen female_fam_days4 = pp_s3q27_n*pp_s3q27_o if !male4 & age4>=15
gen female_fam_days5 = pp_s3q27_r*pp_s3q27_s if !male5 & age5>=15
gen female_fam_days6 = pp_s3q27_v*pp_s3q27_w if !male6 & age6>=15
gen female_fam_days7 = pp_s3q27_z*pp_s3q27_ca if !male7 & age7>=15
gen child_fam_days1 = pp_s3q27_b*pp_s3q27_c if age1<15
gen child_fam_days2 = pp_s3q27_f*pp_s3q27_g if age2<15
gen child_fam_days3 = pp_s3q27_j*pp_s3q27_k if age3<15
gen child_fam_days4 = pp_s3q27_n*pp_s3q27_o if age4<15
gen child_fam_days5 = pp_s3q27_r*pp_s3q27_s if age5<15
gen child_fam_days6 = pp_s3q27_v*pp_s3q27_w if age6<15
gen child_fam_days7 = pp_s3q27_z*pp_s3q27_ca if age7<15
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
bys household_id2: egen male_wage_tot = total(value_male_hired)			// total paid to all male workers at the household level (original question at the holder/field level)
bys household_id2: egen male_days_tot = total(number_days_men)			// total DAYS of male workers
bys household_id2: egen female_wage_tot = total(value_female_hired)		// total paid to all female workers
bys household_id2: egen female_days_tot = total(number_days_women)		// total DAYS of female workers
bys household_id2: egen child_wage_tot = total(value_child_hired)		// total paid to all child workers
bys household_id2: egen child_days_tot = total(number_days_children)	// total DAYS of child workers
gen wage_male_hh = male_wage_tot/male_days_tot					// total paid divided by total days at the household level
gen wage_female_hh = female_wage_tot/female_days_tot			// total paid divided by total days
gen wage_child_hh = child_wage_tot/child_days_tot				// total paid divided by total days
recode wage_*_hh (0=.)											
sum wage_*_hh			// no zeros
*Now, replacing when household-level wage not missing
replace value_male_nonhired = total_male_nonhired_days*wage_male_hh if wage_male_hh!=.
replace value_female_nonhired = total_female_nonhired_days*wage_female_hh if wage_female_hh!=.
replace value_child_nonhired = total_child_nonhired_days*wage_child_hh if wage_child_hh!=.
egen value_hired_prep_labor = rowtotal(value_male_hired value_female_hired value_child_hired)
egen value_fam_prep_labor = rowtotal(value_male_nonhired value_female_nonhired value_child_nonhired)
*Generating gender variables 
*Merging in gender
merge m:1 holder_id parcel_id field_id using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_field_gender_dm.dta", nogen
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
*Hired labor expenses for top crops
foreach cn in $topcropname_area {
	preserve
	merge 1:1 household_id2 parcel_id field_id holder_id using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_`cn'_monocrop.dta", nogen /*assert(1 3)*/ keep(3)	
	gen val_hire_prep_`cn' = value_hired_prep_labor
	gen val_hire_prep_`cn'_male = value_hired_prep_labor_male
	gen val_hire_prep_`cn'_female = value_hired_prep_labor_female
	gen val_hire_prep_`cn'_mixed = value_hired_prep_labor_mixed
	collapse (sum) val_hire_prep_`cn'*, by(household_id2)
	save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_pp_inputs_value_`cn'.dta", replace
	restore
}
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
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_pp_inputs_value.dta", replace


*Harvest labor costs
use "${Ethiopia_ESS_W2_raw_data}/sect10_ph_w2.dta", clear		
*Hired labor (EXPLICIT)
ren ph_s10q01_a number_men
ren ph_s10q01_b number_days_men
ren ph_s10q01_c wage_perday_men
ren ph_s10q01_d number_women
ren ph_s10q01_e number_days_women
ren ph_s10q01_f wage_perday_women
ren ph_s10q01_g number_children
ren ph_s10q01_h number_days_children
ren ph_s10q01_i wage_perday_children
gen wage_male = wage_perday_men/number_men				// wage per day for a single man
gen wage_female = wage_perday_women/number_women		// wage per day for a single woman
gen wage_child = wage_perday_child/number_children		// wage per day for a single child
recode wage_male wage_female wage_child (0=.)			// if they are "hired" but don't get paid, we don't want to consider that a wage observation below
preserve
recode wage_male number_days_men wage_female number_days_women (.=0) 	// set missing to zero to count observations with no male hired labor or with no female hired labor
gen all_wage=(wage_male*number_days_men + wage_female*number_days_women)/(number_days_men + number_days_women)
* re-set 0 to missing
recode wage_male number_days_men wage_female number_days_women (0=.) 
* get average wage accross all plots and crops to obtain wage at household level by  activities
collapse (mean) wage_male wage_female all_wage, by(rural saq01 saq02 saq03 saq04 saq05 household_id2)
** group activities
lab var all_wage "Daily agricultural wage (local currency)"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_eth_labor_group2", replace
restore
gen value_male_hired = number_days_men * wage_perday_men
gen value_female_hired = number_days_women * wage_perday_women 
gen value_child_hired = number_days_children * wage_perday_children
gen days_men = number_men * number_days_men 
gen days_women = number_women * number_days_women  
gen days_children = number_children * number_days_children 
egen days_hired_harv =  rowtotal(days_men days_women days_children)
*Geographic medians
foreach i in male female child{
	recode wage_`i' (0=.)
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
use "${Ethiopia_ESS_W2_raw_data}/sect1_ph_w2.dta", clear
ren ph_s1q00 pid
drop if pid==.
isid holder_id pid			
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
count if fam_merge==1 & ph_s10q02_c!=0 & ph_s10q02_c!=.
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
*Now "member 5"
gen pid = ph_s10q02_q
merge m:1 holder_id pid using `members', gen(fam_merge5) keep(1 3)		// many not matched from master 
ren male male5
ren pid pid15
ren age age5
*Now "member 6"
gen pid = ph_s10q02_u
merge m:1 holder_id pid using `members', gen(fam_merge6) keep(1 3)		// many not matched from master 
ren male male6
ren pid pid16
ren age age6
*Now "member 7"
gen pid = ph_s10q02_y
merge m:1 holder_id pid using `members', gen(fam_merge7) keep(1 3)		// many not matched from master 
ren male male7
ren pid pid17
ren age age7
*Now "member 8"
gen pid = ph_s10q02_ma
merge m:1 holder_id pid using `members', gen(fam_merge8) keep(1 3)		// many not matched from master 
ren male male8
ren pid pid18
ren age age8

*Family labor (IMPLICIT)
recode male1 male2 male3 male4 male5 male6 male7 male8(.=1)				// NOTE: Assuming male if missing (there are only a couple in post-harvest)
gen male_fam_days1 = ph_s10q02_b*ph_s10q02_c if male1 & age1>=15		// NOTE: Assuming missing ages are adults
gen male_fam_days2 = ph_s10q02_f*ph_s10q02_g if male2 & age2>=15
gen male_fam_days3 = ph_s10q02_j*ph_s10q02_k if male3 & age3>=15
gen male_fam_days4 = ph_s10q02_n*ph_s10q02_o if male4 & age4>=15
gen male_fam_days5 = ph_s10q02_r*ph_s10q02_s if male5 & age5>=15
gen male_fam_days6 = ph_s10q02_v*ph_s10q02_w if male6 & age6>=15
gen male_fam_days7 = ph_s10q02_z*ph_s10q02_ka if male7 & age7>=15
gen male_fam_days8 = ph_s10q02_na*ph_s10q02_oa if male8 & age8>=15
gen female_fam_days1 = ph_s10q02_b*ph_s10q02_c if !male1 & age1>=15
gen female_fam_days2 = ph_s10q02_f*ph_s10q02_g if !male2 & age2>=15
gen female_fam_days3 = ph_s10q02_j*ph_s10q02_k if !male3 & age3>=15
gen female_fam_days4 = ph_s10q02_n*ph_s10q02_o if !male4 & age4>=15
gen female_fam_days5 = ph_s10q02_r*ph_s10q02_s if !male5 & age5>=15
gen female_fam_days6 = ph_s10q02_v*ph_s10q02_w if !male6 & age6>=15
gen female_fam_days7 = ph_s10q02_z*ph_s10q02_ka if !male7 & age7>=15
gen female_fam_days8 = ph_s10q02_na*ph_s10q02_oa if !male8 & age8>=15
gen child_fam_days1 = ph_s10q02_b*ph_s10q02_c if age1<15
gen child_fam_days2 = ph_s10q02_f*ph_s10q02_g if age2<15
gen child_fam_days3 = ph_s10q02_j*ph_s10q02_k if age3<15
gen child_fam_days4 = ph_s10q02_n*ph_s10q02_o if age4<15
gen child_fam_days5 = ph_s10q02_r*ph_s10q02_s if age5<15
gen child_fam_days6 = ph_s10q02_v*ph_s10q02_w if age6<15
gen child_fam_days7 = ph_s10q02_z*ph_s10q02_ka if age7<15
gen child_fam_days8 = ph_s10q02_na*ph_s10q02_oa if age8<15
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
bys household_id2: egen male_wage_tot = total(value_male_hired)			// total paid to all male workers at the household level (original question at the holder/field level)
bys household_id2: egen male_days_tot = total(number_days_men)			// total DAYS of male workers
bys household_id2: egen female_wage_tot = total(value_female_hired)		// total paid to all female workers
bys household_id2: egen female_days_tot = total(number_days_women)		// total DAYS of female workers
bys household_id2: egen child_wage_tot = total(value_child_hired)		// total paid to all child workers
bys household_id2: egen child_days_tot = total(number_days_children)	// total DAYS of child workers
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
*Generating gender variables 
*Merging in gender
merge m:1 holder_id parcel_id field_id using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_field_gender_dm.dta", nogen
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
*Harvest labor costs for top crops
foreach cn in $topcropname_area {
	preserve
	collapse (sum) value_hired_harv_labor*, by(household_id2 parcel_id field_id holder_id)
	merge 1:1 household_id2 parcel_id field_id holder_id using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_`cn'_monocrop.dta", nogen /*assert(1 3)*/ keep(3)	
	gen val_hire_harv_`cn' = value_hired_harv_labor
	gen val_hire_harv_`cn'_male = value_hired_harv_labor_male
	gen val_hire_harv_`cn'_female = value_hired_harv_labor_female
	gen val_hire_harv_`cn'_mixed = value_hired_harv_labor_mixed
	collapse (sum) val_hire_harv_`cn'*, by(household_id2)
	save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_cost_harv_labor_`cn'.dta", replace
	restore
}
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
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_cost_harv_labor.dta", replace

*Cost of seeds
*Purchased, free, and left-over seeds are all seeds used (see question 19 in section 5)
use "${Ethiopia_ESS_W2_raw_data}/sect5_pp_w2.dta", clear
recode pp_s5q05_a pp_s5q05_b pp_s5q14_a pp_s5q14_b pp_s5q18_a pp_s5q18_b (.=0)
gen kg_seed_purchased = pp_s5q05_a + pp_s5q05_b/1000		// kg + g/1000
gen seed_value = pp_s5q08
ren pp_s5q07 value_transport_purchased_seed
ren pp_s5q16 value_transport_free_seed
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
gen seed_price = seed_price_ea if seed_count_ea>=10
replace seed_price = seed_price_keb if seed_count_keb>=10 & seed_price==.
replace seed_price = seed_price_wor if seed_count_wor>=10 & seed_price==.
replace seed_price = seed_price_zone if seed_count_zone>=10 & seed_price==.
replace seed_price = seed_price_reg if seed_count_reg>=10 & seed_price==.
replace seed_price = seed_price_nat if seed_price==.
gen value_purchased_seed = seed_value
gen value_non_purchased_seed = seed_price*kg_seed_not_purchased
*Now, replacing with household price when available
*First, constructing "price" at the household level
bys household_id2 crop_code: egen seed_value_hh = total(seed_value)						// summing total value of seed to household
bys household_id2 crop_code: egen kg_seed_purchased_hh = total(kg_seed_purchased)		// summing total value of seed purchased to HH
gen seed_price_hh_non = seed_value_hh/kg_seed_purchased_hh
*Now, replacing when household price is not missing
replace value_non_purchased_seed = (seed_price_hh_non)*kg_seed_not_purchased if seed_price_hh_non!=. & seed_price_hh_non!=0
*NOTE: We cannot appropriately value seeds by gender because seed module is at the holder-crop level, not field level
collapse (sum) value_purchased_seed value_non_purchased_seed value_transport*, by(household_id2)			// collapsing to HOUSEHOLD, not holder
lab var value_purchased_seed "Value of purchased seed"
lab var value_transport_purchased_seed "Cost of transport for purchased seed"
lab var value_transport_free_seed "Cost of transport for free seed"
lab var value_purchased_seed "Value of seed purchased (household)"
lab var value_non_purchased_seed "Value of seed not purchased (household)"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_cost_seed.dta", replace


********************************************************************************
*AGRICULTURAL WAGES
********************************************************************************
use "${Ethiopia_ESS_W2_raw_data}/sect3_pp_w2.dta", clear
append using "${Ethiopia_ESS_W2_raw_data}/sect10_ph_w2.dta"
*Hired Labor post-planting
ren pp_s3q28_a number_men_pp
ren pp_s3q28_b number_days_men_pp
ren pp_s3q28_c wage_perday_men_pp
ren pp_s3q28_d number_women_pp
ren pp_s3q28_e number_days_women_pp
ren pp_s3q28_f wage_perday_women_pp
ren pp_s3q28_g number_child_pp
ren pp_s3q28_h number_days_child_pp
ren pp_s3q28_i wage_perday_child_pp
*Hired labor post-harvest
ren ph_s10q01_a number_men_ph
ren ph_s10q01_b number_days_men_ph
ren ph_s10q01_c wage_perday_men_ph
ren ph_s10q01_d number_women_ph
ren ph_s10q01_e number_days_women_ph
ren ph_s10q01_f wage_perday_women_ph
ren ph_s10q01_g number_child_ph
ren ph_s10q01_h number_days_child_ph
ren ph_s10q01_i wage_perday_child_ph
collapse (sum) wage* number*, by(household_id2)
gen wage_male_pp = wage_perday_men_pp/number_men_pp						// wage per day for a single man
gen wage_female_pp = wage_perday_women_pp/number_women_pp				// wage per day for a single woman
gen wage_child_pp = wage_perday_child_pp/number_child_pp				// wage per day for a single child
recode wage_male_pp wage_female_pp wage_child_pp number* (.=0)			// if they are "hired" but don't get paid, we don't want to consider that a wage observation below
gen wage_male_ph = wage_perday_men_ph/number_men_ph						// wage per day for a single man
gen wage_female_ph = wage_perday_women_ph/number_women_ph				// wage per day for a single woman
gen wage_child_ph = wage_perday_child_ph/number_child_ph				// wage per day for a single child
recode wage_male_ph wage_female_ph wage_child_ph number* (.=0)			// if they are "hired" but don't get paid, we don't want to consider that a wage observation below
*getting weighted average across group of activities to get wage paid at HH level
gen wage_paid_aglabor = (wage_male_pp*number_men_pp+wage_female_pp*number_women_pp+wage_child_pp*number_child_pp+wage_male_ph*number_men_ph+wage_female_ph*number_women_ph+wage_child_ph*number_child_ph)/(number_men_pp+number_women_pp+number_child_pp+number_men_ph+number_women_ph+number_child_ph)
gen wage_paid_aglabor_male = (wage_male_pp*number_men_pp+wage_male_ph*number_men_ph)/(number_men_pp+number_men_ph)
gen wage_paid_aglabor_female = (wage_female_pp*number_women_pp+wage_female_ph*number_women_ph)/(number_women_pp+number_women_ph)
*gen wage_paid_aglabor_child = (wage_child_pp*number_child_pp+wage_child_ph*number_child_ph)/(number_child_pp+number_child_ph)
keep household_id wage_paid_aglabor*
lab var wage_paid_aglabor "Daily agricultural wage paid for hired labor (local currency)"
lab var wage_paid_aglabor_female "Daily agricultural wage paid for female hired labor (local currency)"
*lab var wage_paid_aglabor_child "Daily agricultural wage paid for child hired labor (local currency)"
lab var wage_paid_aglabor_male "Daily agricultural wage paid for male hired labor (local currency)"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_ag_wage.dta", replace 


********************************************************************************
* FERTILIZER APPLICATION (KG)
********************************************************************************
use "${Ethiopia_ESS_W2_raw_data}/sect3_pp_w2.dta", clear
*Merging in gender
merge m:1 holder_id parcel_id field_id using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_field_gender_dm.dta", nogen
*For fertilizer 
egen fert_inorg_kg = rowtotal(pp_s3q16_a pp_s3q19_a)		// all are already in kg (Urea & DAP), questionnaire doesn't ask how much other inorg fert was used on the field, but only 30 plots used other fert (3,771 used Urea and 5,047 used DAP) 
gen fert_inorg_kg_male = fert_inorg_kg if dm_gender==1
gen fert_inorg_kg_female = fert_inorg_kg if dm_gender==2
gen fert_inorg_kg_mixed = fert_inorg_kg if dm_gender==3
recode fert_inorg_kg* (.=0)
collapse (sum) fert_inorg_kg*, by(household_id2)
lab var fert_inorg_kg "Inorganic fertilizer (kgs) for all plots"
lab var fert_inorg_kg_male "Inorganic fertilizer (kgs) for male-managed plots"
lab var fert_inorg_kg_female "Inorganic fertilizer (kgs) for female-managed plots"
lab var fert_inorg_kg_mixed "Inorganic fertilizer (kgs) for mixed-managed plots"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_fertilizer_application.dta", replace


********************************************************************************
*WOMEN'S DIET QUALITY
********************************************************************************
*Women's diet quality: proportion of women consuming nutrient-rich foods (%)
*Information not available


********************************************************************************
* DIETARY DIVERSITY
********************************************************************************
use "${Ethiopia_ESS_W2_raw_data}/sect5a_hh_w2.dta" , clear
* We recode food items to map HDD food categories
ta hh_s5aq00
#delimit ;
recode hh_s5aq00 	(1 2 3 4 5 6 									=1	"CEREALS")  
					(16 17 						  					=2	"WHITE ROOTS,TUBERS AND OTHER STARCHES")
					(14 											=3	"VEGETABLES")
					(15 								 			=4	"FRUITS")
					(18												=5	"MEAT")
					(21												=6	"EGGS")
					(183 											=7  "FISH")
					(7/13  								  			=8	"LEGUMES, NUTS AND SEEDS")
					(19 20											=9	"MILK AND MILK PRODUCTS")
					(201 202    									=10	"OILS AND FATS")
					(22								  				=11	"SWEETS")
					(23 24 25 26 									=12	"SPICES, CONDIMENTS, BEVERAGES")
					, generate(Diet_ID)
					;
#delimit cr
* generate a dummy variable indicating whether a the respondent or other member of the household have consumed a food item during the past 7 days 			
gen adiet_yes=(hh_s5aq01==1)
ta adiet_yes   
** Now, we collapse to food group level assuming that if a person consumes at least one food item in a food group,
* then he/she has consumed that food group. That is equivalent to taking the MAX of adiet_yes
collapse (max) adiet_yes, by(household_id2 Diet_ID) 
count // nb of obs = 52,620 remaining
label define YesNo 1 "Yes" 0 "No"
label val adiet_yes YesNo
* Now, estimate the number of food groups eaten by each individual
collapse (sum) adiet_yes, by(household_id2 )
count
/*
There are no established cut-off points in terms of number of food groups to indicate
adequate or inadequate dietary diversity for the HDDS and WDDS. Because of
this it is recommended to use the mean score or distribution of scores for analytical
purposes and to set programme targets or goals.
*/
*We will use a cutoff of six and the mean
ren adiet_yes number_foodgroup 
sum number_foodgroup 
local cut_off1=6
local cut_off2=round(r(mean))
gen household_diet_cut_off1=(number_foodgroup>=`cut_off1')
gen household_diet_cut_off2=(number_foodgroup>=`cut_off2')
lab var household_diet_cut_off1 "1= houseold consumed at least `cut_off1' of the 12 food groups last week" 
lab var household_diet_cut_off2 "1= houseold consumed at least `cut_off2' of the 12 food groups last week" 
label var number_foodgroup "Number of food groups individual consumed last week HDDS"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_household_diet.dta", replace


********************************************************************************
*WOMEN'S OWNERSHIP OF ASSETS
********************************************************************************
* FEMALE LAND OWNERSHIP
use "${Ethiopia_ESS_W2_raw_data}/sect2_pp_w2.dta", clear
*Female asset ownership
local landowners "pp_s2q03c_a pp_s2q03c_b pp_s2q06_a pp_s2q06_b pp_s2q08a_a pp_s2q08a_b"
keep household_id2  `landowners' 	// keep relevant variables
*Transform the data into long form - reshape will not work because of duplicates
*We will "reshape" by keeping one thing at a time and then appending at the end
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
**remove duplicates by collapse (if a hh member appears at least one time, she/he owns/controls a land)
duplicates drop 
gen type_asset="land"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_women_land_owner.dta", replace

*FEMALE LIVESTOCK OWNERSHIP
use "${Ethiopia_ESS_W2_raw_data}/sect8a_ls_w2.dta", clear
*Remove poultry-livestocks and beehives
drop if inlist(ls_s8aq00,8,9,10,11,12,13,14.)
local livestockowners "ls_s8q60b1 ls_s8q60b2"
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
use `ls_s8q60b1', clear
foreach v of local landowners   {
	if "`v'"!="`ls_s8q60b1'" {
		append using ``v''
	}
}
*remove duplicates
duplicates drop 
gen type_asset="livestock"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_women_livestock_owner.dta", replace

* FEMALE OTHER ASSETS
use "${Ethiopia_ESS_W2_raw_data}/sect10_hh_w2.dta", clear
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
*remove duplicates
duplicates drop 
gen type_asset="otherasset"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_women_otherasset_owner.dta", replace

*Construct asset ownership variable 
use "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_women_land_owner.dta", clear
append using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_women_livestock_owner.dta"
append using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_women_otherasset_owner.dta"
gen own_asset=1 

collapse (max) own_asset, by(household_id2 asset_owner)
gen hh_s1q00=asset_owner

*Now merge with member characteristics
merge 1:1 household_id2 hh_s1q00  using   "${Ethiopia_ESS_W2_raw_data}/sect1_hh_w2.dta"
gen personid = hh_s1q00
drop _m hh_s1q00 individual_id ea_id ea_id2 saq03- hh_s1q02 hh_s1q04b- hh_s1q37
ren hh_s1q03 mem_gender 
ren hh_s1q04_a mem_age 
ren saq01 region
ren saq02 zone
recode own_asset (.=0)
gen women_asset= own_asset==1 & mem_gender==2
lab  var women_asset "Women ownership of asset"
compress
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_women_asset.dta", replace


********************************************************************************
*WOMEN'S AG DECISION-MAKING
********************************************************************************
*SALES DECISION-MAKERS - INPUT DECISIONS
use "${Ethiopia_ESS_W2_raw_data}/sect3_pp_w2.dta", clear
*Women's decision-making in ag
local planting_input "pp_saq07 pp_s3q10a pp_s3q10c_a pp_s3q10c_b"
keep household_id2 `planting_input' 	// keep relevant variables
*Transform the data into long form  
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
*Not dropping duplicates here due to how we construct the index below
gen type_decision="planting_input"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_women_planting_input.dta", replace

*SALES DECISION-MAKERS - ANNUAL SALES
use "${Ethiopia_ESS_W2_raw_data}/sect11_ph_w2.dta", clear
*First, this is for construction of women's decision-making
local control_annualsales "ph_s11q05_a ph_s11q05_b"
keep household_id2 `control_annualsales' 	// keep relevant variables
*Transform the data into long form  
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
** Remove duplicates 
duplicates drop 
gen type_decision="control_annualsales"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_women_control_annualsales.dta", replace

*SALES DECISION-MAKERS - ANNUAL CROP
use "${Ethiopia_ESS_W2_raw_data}/sect11_ph_w2.dta", clear
local sales_annualcrop "ph_saq07 ph_s11q01b_1 ph_s11q01b_2 ph_s11q01c_1 ph_s11q01c_2 ph_s11q05_a ph_s11q05_b"
keep household_id2 `sales_annualcrop'	 // keep relevant variables
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
*Not dropping duplicates here due to how we construct the index below
gen type_decision="sales_annualcrop"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_women_sales_annualcrop.dta", replace

*SALES DECISION-MAKERS - PERM SALES
use "${Ethiopia_ESS_W2_raw_data}/sect12_ph_w2.dta", clear
local control_permsales "ph_s12q08a_1 ph_s12q08a_2"
keep household_id2 `control_permsales'	 // keep relevant variables
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
** remove duplicates 
duplicates drop 
gen type_decision="control_permsales"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_women_control_permsales.dta", replace

*SALES DECISION-MAKERS - PERM CROP
use "${Ethiopia_ESS_W2_raw_data}/sect12_ph_w2.dta", clear
local sales_permcrop "ph_saq07 ph_s12q08a_1 ph_s12q08a_2"
keep household_id2 `sales_permcrop' 	// keep relevant variables
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
*Not dropping duplicates here due to how we construct the index below
gen type_decision="sales_permcrop"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_women_sales_permcrop.dta", replace

*SALES DECISION-MAKERS - HARVEST
use "${Ethiopia_ESS_W2_raw_data}/sect9_ph_w2.dta", clear
local harvest "ph_saq07 ph_s9q07a_1 ph_s9q07a_2"
keep household_id2 `harvest' 	// keep relevant variables
*Transform the data into long form  
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
*Not dropping duplicates here due to how we construct the index below
gen type_decision="harvest"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_women_control_harvest.dta", replace


********************************************************************************
*WOMEN'S CONTROL OVER INCOME
********************************************************************************
*SALES DECISION-MAKERS - ANNUAL HARVEST
use "${Ethiopia_ESS_W2_raw_data}/sect9_ph_w2.dta", clear
local control_annualharvest "ph_s9q07a_1 ph_s9q07a_2"
keep household_id2 `control_annualharvest' 	// keep relevant variables
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
** remove duplicates  
duplicates drop 
gen type_decision="control_annualharvest"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_women_control_annualharvest.dta", replace

* FEMALE LIVESTOCK DECISION-MAKING - MANAGEMENT
use "${Ethiopia_ESS_W2_raw_data}/sect8a_ls_w2.dta", clear
local livestockowners "ls_saq07 ls_s8q60d1 ls_s8q60d2"
keep household_id2 `livestockowners' 	// keep relevant variables
*Transform the data into long form  
foreach v of local livestockowners   {
	preserve
	keep household_id2  `v'
	ren `v'  decision_maker
	drop if decision_maker==. | decision_maker==0 | decision_maker==99
	tempfile `v'
	save ``v''
	restore
}
use `ls_saq07', clear
foreach v of local livestockowners   {
	if "`v'"!="`ls_saq07'" {
		append using ``v''
	}
}
*Not dropping duplicates here due to how we construct the index below
gen type_decision="manage_livestock"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_women_manage_livestock.dta", replace

* Constructing decision-making ag variable *
use "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_women_planting_input.dta", clear
append using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_women_control_harvest.dta"
append using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_women_sales_annualcrop.dta"
append using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_women_sales_permcrop.dta"
append using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_women_manage_livestock.dta"
*For this index, individual must have decision power over at least two decisions
bysort household_id2 decision_maker : egen nb_decision_participation=count(decision_maker)
drop if nb_decision_participation==1
*Create group
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
*Now merge with member characteristics
merge 1:1 household_id2 hh_s1q00 using "${Ethiopia_ESS_W2_raw_data}/sect1_hh_w2.dta"
drop household_id- hh_s1q02 hh_s1q04b- _merge
recode make_decision_* (.=0)
*Generate women participation in Ag decision
ren hh_s1q03 mem_gender 
ren hh_s1q04_a mem_age
*Generate women control over income
local allactivity crop  livestock  ag
foreach v of local allactivity {
	gen women_decision_`v'= make_decision_`v'==1 & mem_gender==2
	lab var women_decision_`v' "Women make decision abour `v' activities"
	lab var make_decision_`v' "HH member involed in `v' activities"
} 
collapse (max) women_decision_ag make_decision_ag, by(household_id2 hh_s1q00)
gen personid = hh_s1q00
compress
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_ag_decision.dta", replace

* FEMALE LIVESTOCK DECISION-MAKING - SALES
use "${Ethiopia_ESS_W2_raw_data}/sect8a_ls_w2.dta", clear
local control_livestocksales "ls_s8q60b1 ls_s8q60b2"
keep household_id2 `control_livestocksales' 	// keep relevant variables
*Transform the data into long form  
foreach v of local control_livestocksales   {
	preserve
	keep household_id2  `v'
	ren `v'  controller_income
	drop if controller_income==. | controller_income==0 | controller_income==99
	tempfile `v'
	save ``v''
	restore
}
use `ls_s8q60b1', clear
foreach v of local control_livestocksales   {
	if "`v'"!="`ls_sec_8_1q03_a'" {
		append using ``v''
	}
}
** remove duplicates 
duplicates drop 
gen type_decision="control_livestocksales"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_women_control_livestocksales.dta", replace

* FEMALE DECISION-MAKING - CONTROL OF BUSINESS INCOME
use "${Ethiopia_ESS_W2_raw_data}/sect11b_hh_w2.dta", clear
local control_businessincome "hh_s11bq03_a hh_s11bq03_b hh_s11bq03d_1 hh_s11bq03d_2"
keep household_id2 `control_businessincome' 	// keep relevant variables
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
** remove duplicates  
duplicates drop 
gen type_decision="control_businessincome"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_women_control_businessincome.dta", replace

* FEMALE DECISION-MAKING - CONTROL OF OTHER INCOME
use "${Ethiopia_ESS_W2_raw_data}/sect12_hh_w2.dta", clear
local control_otherincome "hh_s12q03_a hh_s12q03_b"
keep household_id2 `control_otherincome' 	// keep relevant variables
*Transform the data into long form  
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
** remove duplicates
duplicates drop 
gen type_decision="control_otherincome"
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_women_control_otherincome.dta", replace

* Constructing decision-making final variable *
use "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_women_control_annualharvest.dta", clear
append using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_women_control_annualsales.dta"
append using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_women_control_permsales.dta"
append using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_women_control_livestocksales.dta"
append using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_women_control_businessincome.dta"
append using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_women_control_otherincome.dta"

*Create group
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
gen control_nonfarmincome=1 if  type_decision=="control_otherincome" ///
							  | control_businessincome== 1
recode 	control_nonfarmincome (.=0)															
gen control_all_income=1 if  control_farmincome== 1 | control_nonfarmincome==1
recode 	control_all_income (.=0)																					
collapse (max) control_* , by(household_id2 controller_income )  //any decision
preserve
	*We also need a variable that indicates if a source of income is applicable to a household
	*and use it to condition the statistics on household with the type of income
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
*Now merge with member characteristics
merge 1:1 household_id2 hh_s1q00   using   "${Ethiopia_ESS_W2_raw_data}/sect1_hh_w2.dta"
drop household_id- hh_s1q02 hh_s1q04b- _merge
ren hh_s1q03 mem_gender 
ren hh_s1q04_a mem_age 
recode control_* (.=0)
gen women_control_all_income= control_all_income==1 
gen personid = hh_s1q00
compress
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_control_income.dta", replace


********************************************************************************
*CROP YIELDS
********************************************************************************
*Starting with crops
use "${Ethiopia_ESS_W2_raw_data}/sect4_pp_w2.dta", clear
*Percent of area
gen pure_stand = pp_s4q02==1
gen any_pure = pure_stand==1
gen any_mixed = pure_stand==0
gen percent_field = pp_s4q03/100
replace percent_field = 1 if pure_stand==1

*Merging in area
merge m:1 holder_id parcel_id field_id using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_field_area.dta", nogen keep(1 3)	// dropping those only in using
gen dm_male= dm_gender==1
gen dm_female= dm_gender==2
gen dm_mixed= dm_gender==3
// adding for method 4 intercropping
gen intercropped_yn = 1 if ~missing(pp_s4q02)
replace intercropped_yn = 0 if pp_s4q02 == 1
gen mono_field = percent_field if intercropped_yn==0 //not intercropped 
gen int_field = percent_field if intercropped_yn==1 //not intercropped 
bys household_id2 holder_id parcel_id field_id: egen total_percent_int_sum = total(int_field)	
bys household_id2 holder_id parcel_id field_id: egen total_percent_mono = total(mono_field)		
replace total_percent_mono = 1 if total_percent_mono>1 
//4 changes made
//Dealing with crops which have monocropping larger than plot size or monocropping that fills plot size and still has intercropping to add
gen oversize_plot = (total_percent_mono >1)
replace oversize_plot = 1 if total_percent_mono >=1 & total_percent_int_sum >0 		
//2 oversize plots in total
bys household_id2 holder_id parcel_id field_id: egen total_percent_field = total(percent_field)				            
replace percent_field = percent_field/total_percent_field if total_percent_field>1 & oversize_plot ==1
gen total_percent_inter = 1-total_percent_mono 
bys household_id2 holder_id parcel_id field_id: egen inter_crop_number = total(intercropped_yn) 
gen percent_inter = (int_field/total_percent_int_sum)*total_percent_inter if total_percent_field >1 
replace percent_inter=int_field if total_percent_field<=1
replace percent_inter = percent_field if oversize_plot ==1
gen ha_planted = percent_field*area_meas_hectares  if intercropped_yn == 0 
replace ha_planted = percent_inter*area_meas_hectares  if intercropped_yn == 1 
gen ha_planted_male = ha_planted if dm_gender==1
gen ha_planted_female = ha_planted if dm_gender==2
gen ha_planted_mixed = ha_planted if dm_gender==3
gen ha_planted_purestand = ha_planted if any_pure==1
gen ha_planted_mixedstand = ha_planted if any_pure==0
gen ha_planted_male_pure = ha_planted if dm_gender==1 & any_pure==1
gen ha_planted_female_pure = ha_planted if dm_gender==2 & any_pure==1
gen ha_planted_mixed_pure = ha_planted if dm_gender==3 & any_pure==1
gen ha_planted_male_mixed = ha_planted if dm_gender==1 & any_mixed==1
gen ha_planted_female_mixed = ha_planted if dm_gender==2 & any_mixed==1
gen ha_planted_mixed_mixed = ha_planted if dm_gender==3 & any_mixed==1
ren pp_s4q14 number_trees_planted
keep ha_planted* holder_id parcel_id field_id household_id2 crop_code dm_* any_* number_trees_planted
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_area_planted.dta", replace

*Before harvest, need to prepare the conversion factors
use "${Ethiopia_ESS_W2_raw_data}/Crop_CF_Wave2.dta", clear
ren mean_cf_nat mean_cf100
sort crop_code unit_cd mean_cf100
duplicates drop crop_code unit_cd, force
reshape long mean_cf, i(crop_code unit_cd) j(region)
recode region (99=5)
ren mean_cf conversion
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_cf.dta", replace

*Now to harvest
use "${Ethiopia_ESS_W2_raw_data}/sect9_ph_w2.dta", clear
ren saq01 region
ren ph_s9q04_b unit_cd		// for merge
merge m:1 crop_code unit_cd region using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_cf.dta", gen(cf_merge) 
bys crop_code unit_cd: egen national_conv = median(conversion)
replace conversion = national_conv if conversion==.			// replacing with median if missing -- 1,517
*There is some variation in conversion across crops, but they seem to correlate well enough to use units
bys unit_cd region: egen national_conv_unit = median(conversion)
replace conversion = national_conv_unit if conversion==. & unit_cd!=900		// Not for "other" ones -- 2,105 changes
tab unit_cd			// 14 percent of field-crop observations are reported with "other" units
tab crop_code ph_s9q04_b_other if unit_cd==900
*None of the "other" units are for cereal crops so will skip adding in those food conversion factors
gen kg_harvest = ph_s9q04_a*conversion
replace kg_harvest = ph_s9q05 if kg_harvest==.
drop if kg_harvest==.							// dropping those with missing kg
*adding in kgs harvest by crop for monocropped plots
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	preserve
	merge m:1 household_id2 parcel_id field_id holder_id using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_`cn'_monocrop.dta", nogen keep(3)
	gen kgs_harv_mono_`cn' = kg_harvest 
	merge m:1 household_id2 parcel_id field_id holder_id using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_field_gender_dm.dta", nogen keep(3)
	gen kgs_harv_mono_`cn'_male= kgs_harv_mono_`cn' if dm_gender==1
	gen kgs_harv_mono_`cn'_female= kgs_harv_mono_`cn' if dm_gender==2
	gen kgs_harv_mono_`cn'_mixed= kgs_harv_mono_`cn' if dm_gender==3
	collapse (sum) kgs_harv_mono_`cn'*, by(household_id2)
	lab var kgs_harv_mono_`cn' "monocropped `cn' harvested(kg)"
	foreach i in male female mixed {
		local lkgs_harv_mono_`cn' : var lab kgs_harv_mono_`cn'
		la var kgs_harv_mono_`cn'_`i' "`lkgs_harv_mono_`cn'' - `i' managed plots"
		}
	save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_`cn'_harvest_monocrop", replace
	restore
}
keep crop_code holder_id parcel_id field_id kg_harvest ph_s9q08 ph_s9q09 ph_s9q04_a ph_s9q03
*Merging area
merge m:1 holder_id parcel_id field_id crop_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_area_planted" , nogen 
*renaming area planted variables to keep for analysis
gen area_plan = ha_planted
gen area_plan_male = ha_planted_male 
gen area_plan_female = ha_planted_female 
gen area_plan_mixed = ha_planted_mixed 
gen area_plan_pure = ha_planted_purestand 
gen area_plan_inter = ha_planted_mixedstand 
gen area_plan_pure_male = ha_planted_male_pure 
gen area_plan_pure_female = ha_planted_female_pure 
gen area_plan_pure_mixed = ha_planted_mixed_pure
gen area_plan_inter_male = ha_planted_male_mixed 
gen area_plan_inter_female = ha_planted_female_mixed 
gen area_plan_inter_mixed = ha_planted_mixed_mixed 
*Creating area harvested variables from area planted
drop if ph_s9q09 >100 & ph_s9q09!=.		//dropping one observation where proportion of area harvested is 801%
foreach x of varlist ha_planted*{
	replace `x' = `x'* (ph_s9q09/100) if ph_s9q08==1
}
ren ha_planted area_harv

replace area_harv=. if area_harv==0 //118
replace area_plan=area_harv if area_plan==. & area_harv!=.
replace area_harv = area_plan if area_harv>area_plan & area_harv!=.

*Creating area and quantity variables by decision-maker and type of planting
ren kg_harvest harvest  
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
*Saving area planted for Shannon diversity index
save "$Ethiopia_ESS_W2_created_data\Ethiopia_ESS_W2_hh_crop_area_plan_SDI.dta", replace
	
keep if inlist(crop_code, $comma_topcrop_area)	

*Collapsing to household level
collapse (sum) harvest* area_harv* area_plan* number_trees_planted (max) dm_*  any_*, by(household_id2 crop_code)		// collapsing by hhid-crop
*Adding here total planted and harvested area summed accross all plots, crops, and seasons.
preserve
collapse (sum) all_area_harvested=area_harv all_area_planted=area_plan, by(household_id2)
replace all_area_harvested=all_area_planted if all_area_harvested>all_area_planted & all_area_harvested!=.
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_area_planted_harvested_allcrops.dta", replace
restore
*Merging weights and survey variables
merge m:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_male_head.dta", nogen //keep(1 3)
ren pw2 weight
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_harvest_area_yield.dta", replace

*Yield at the household level
use "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_harvest_area_yield.dta", clear
preserve 
recode area_harv (.=0)
collapse (sum) area_harv area_plan, by(household_id2 crop_code)
ren area_harv total_harv_area
ren area_plan total_planted_area
tempfile area
save `area'
restore
merge 1:1 household_id2 crop_code using `area', nogen
*Adding value of crop_production
merge 1:1 household_id2 crop_code using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_crop_values_production.dta", nogen keep(1 3)
ren value_crop_production value_harv
ren value_crop_sales value_sold

*local ncrop: word count $croplist
local ncrop : word count $topcrop_area
foreach v of varlist  harvest*  area_harv* area_plan* total_planted_area total_harv_area kgs_harvest* kgs_sold* value_harv value_sold {
	separate `v', by(crop_code)
	forvalues i=1(1)`ncrop' {
		local p : word `i' of  $topcrop_area
		local np : word `i' of  $topcropname_area
		local `v'`p' = subinstr("`v'`p'","`p'","_`np'",1)	
		ren `v'`p'  ``v'`p''
	}
}
gen number_trees_planted_banana = number_trees_planted if crop_code==42 
recode number_trees_planted_banana (.=0)
collapse (firstnm) harvest* area_harv*  area_plan*  total_planted_area* total_harv_area* kgs_harvest*  kgs_sold*  value_harv* value_sold* (sum) number_trees_planted_*, by(household_id2)
recode area_harv* area_plan* kgs_harvest* total_planted_area* total_harv_area* kgs_sold*  value_harv* value_sold (0=.)
local vars $topcropname_area
	foreach p of local vars {
	lab var value_harv_`p' "Value harvested of `p' (ETB) (household)" 
	lab var value_sold_`p' "Value sold of `p' (ETB) (household)" 
	lab var kgs_harvest_`p'  "Quantity harvested of `p' (kgs) (household)" 
	lab var kgs_sold_`p'  "Quantity sold of `p' (kgs) (household)" 
	lab var total_harv_area_`p'  "Total area harvested of `p' (ha) (household)" 	
	lab var total_planted_area_`p'  "Total area planted of `p' (ha) (household)" 
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
	lab var area_harv_`p' "Area harvested of `p' (kgs) (household)" 
	lab var area_harv_male_`p' "Area harvested of `p' (kgs) (male-managed plots)" 
	lab var area_harv_female_`p' "Area harvested of `p' (kgs) (female-managed plots)" 
	lab var area_harv_mixed_`p' "Area harvested of `p' (kgs) (mixed-managed plots)"
	lab var area_harv_pure_`p' "Area harvested of `p' (kgs) - purestand (household)"
	lab var area_harv_pure_male_`p'  "Area harvested of `p' (kgs) - purestand (male-managed plots)"
	lab var area_harv_pure_female_`p'  "Area harvested of `p' (kgs) - purestand (female-managed plots)"
	lab var area_harv_pure_mixed_`p'  "Area harvested of `p' (kgs) - purestand (mixed-managed plots)"
	lab var area_harv_inter_`p' "Area harvested of `p' (kgs) - intercrop (household)"
	lab var area_harv_inter_male_`p' "Area harvested of `p' (kgs) - intercrop (male-managed plots)" 
	lab var area_harv_inter_female_`p' "Area harvested of `p' (kgs) - intercrop (female-managed plots)"
	lab var area_harv_inter_mixed_`p' "Area harvested  of `p' (kgs) - intercrop (mixed-managed plots)"
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

*Indicator variable for whether a household grew each crop

foreach p of global topcropname_area {
	gen grew_`p'=(total_harv_area_`p'!=. & total_harv_area_`p'!=.0 ) | (total_planted_area_`p'!=. & total_planted_area_`p'!=.0)
	lab var grew_`p' "1=Household grew `p'" 
	gen harvested_`p'= (total_harv_area_`p'!=. & total_harv_area_`p'!=.0 )
	lab var harvested_`p' "1= Household harvested `p'"
}
replace grew_banana =1 if  number_trees_planted_banana!=0 & number_trees_planted_banana!=. 
foreach p of global topcropname_area {
	recode kgs_harvest_`p' (.=0) if grew_`p'==1 
	recode value_sold_`p' (.=0) if grew_`p'==1 
	recode value_harv_`p' (.=0) if grew_`p'==1 
}	
drop harvest-harvest_pure_mixed area_harv- area_harv_pure_mixed area_plan- area_plan_inter_mixed value_harv kgs_harvest kgs_sold value_sold total_planted_area total_harv_area number_trees_planted_*
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_yield_hh_level.dta", replace


********************************************************************************
*SHANNON DIVERSITY INDEX
********************************************************************************
*Bring in area planted
use "$Ethiopia_ESS_W2_created_data\Ethiopia_ESS_W2_hh_crop_area_plan_SDI.dta", clear
*generating area planted of each crop as a proportion of the total area
preserve 
collapse (sum) area_plan_hh=area_plan area_plan_female_hh=area_plan_female area_plan_male_hh=area_plan_male area_plan_mixed_hh=area_plan_mixed, by(household_id2)
save "$Ethiopia_ESS_W2_created_data\Ethiopia_ESS_W2_hh_crop_area_plan_shannon.dta", replace
restore
merge m:1 household_id2 using "$Ethiopia_ESS_W2_created_data\Ethiopia_ESS_W2_hh_crop_area_plan_shannon.dta", nogen
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
bysort household_id2 (sdi_crop_female) : gen allmissing_female = mi(sdi_crop_female[1])
bysort household_id2 (sdi_crop_male) : gen allmissing_male = mi(sdi_crop_male[1])
bysort household_id2 (sdi_crop_mixed) : gen allmissing_mixed = mi(sdi_crop_mixed[1])
*Generating number of crops per household
bysort household_id2 crop_code : gen nvals_tot = _n==1
gen nvals_female = nvals_tot if area_plan_female!=0 & area_plan_female!=.
gen nvals_male = nvals_tot if area_plan_male!=0 & area_plan_male!=. 
gen nvals_mixed = nvals_tot if area_plan_mixed!=0 & area_plan_mixed!=.
collapse (sum) sdi=sdi_crop sdi_female=sdi_crop_female sdi_male=sdi_crop_male sdi_mixed=sdi_crop_mixed num_crops_hh=nvals_tot num_crops_female=nvals_female ///
num_crops_male=nvals_male num_crops_mixed=nvals_mixed (max) allmissing_female allmissing_male allmissing_mixed, by(household_id2)
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
save "$Ethiopia_ESS_W2_created_data\Ethiopia_ESS_W2_shannon_diversity_index.dta", replace


********************************************************************************
*CONSUMPTION
******************************************************************************** 
use "${Ethiopia_ESS_W2_raw_data}/cons_agg_w2.dta", clear
ren total_cons_ann total_cons
gen peraeq_cons = nom_totcons_aeq
replace total_cons = total_cons * price_index_hce 	// Adjusting for price index 
replace peraeq_cons = peraeq_cons * price_index_hce // Adjusting for price index 
la var peraeq_cons "Household consumption per adult equivalent per year"
gen daily_peraeq_cons = peraeq_cons/365
la var daily_peraeq_cons "Household consumption per adult equivalent per day"
gen percapita_cons = (total_cons / hh_size) 
la var percapita_cons "Household consumption per household member per year"
gen daily_percap_cons = percapita_cons/365
la var daily_percap_cons "Household consumption per household member per day"
keep household_id2 total_cons peraeq_cons daily_peraeq_cons percapita_cons daily_percap_cons adulteq
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_consumption.dta", replace


********************************************************************************
*HOUSEHOLD FOOD PROVISION*
********************************************************************************
use "${Ethiopia_ESS_W2_raw_data}/sect7_hh_w2.dta", clear
numlist "1/12"
forval k=1/12{
	local num: word `k' of `r(numlist)'
	local alph: word `k' of `c(alpha)'
	ren hh_s7q07_`alph' hh_s7q07_`num'
}
forval k=1/12 {
	gen food_insecurity_`k' = (hh_s7q07_`k'=="X")
}
egen months_food_insec = rowtotal(food_insecurity_*) 
*replacing those that report over 12 months
replace months_food_insec = 12 if months_food_insec>12
keep months_food_insec household_id2
save "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_LSMS_W2_food_insecurity.dta", replace


********************************************************************************
*HOUSEHOLD ASSETS*
********************************************************************************
*Cannot calculate in this instrument - questionnaire doesn't ask value of HH assets


********************************************************************************
*DISTANCE TO AGRO DEALERS*
********************************************************************************
*Cannot create in this instrument


********************************************************************************
*HOUSEHOLD VARIABLES
********************************************************************************
global empty_vars ""
use "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_male_head.dta", clear		
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hhids.dta", nogen keep (1 3)

*Area files
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_household_area.dta", nogen keep (1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_farm_area.dta", nogen keep (1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_farmsize_all_agland.dta", nogen keep (1 3)
*Rental value, rent paid, and value of owned land
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_rental_rate.dta", nogen keep (1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_rental_value.dta", nogen keep (1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_cost_land.dta", nogen keep (1 3)
foreach cn in $topcropname_area {
	merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_`cn'_monocrop_hh_area.dta", nogen keep (1 3)
	merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_`cn'_harvest_monocrop", nogen keep (1 3)
	merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_fertilizer_costs_`cn'.dta", nogen keep (1 3)	
	merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_rental_value_`cn'.dta", nogen keep (1 3)
	merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_pp_inputs_value_`cn'.dta", nogen keep (1 3)		
	merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_cost_harv_labor_`cn'.dta", nogen keep (1 3)	
}

*Generating crop expenses for top crops
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	local cnfull: word `k' of $topcropname_full
	recode `cn'_monocrop (.=0) 
	egen `cn'_exp = rowtotal(value_rented_land_`cn' value_fertilizer_`cn' val_hire_harv_`cn' val_hire_prep_`cn')
	replace `cn'_exp =. if `cn'_monocrop_ha==.
	la var `cn'_exp "Crop production expenditures (explicit) - Monocropped `cnfull' plots only"
	*disaggregate by gender of plot manager
	foreach i in male female mixed {
		egen `cn'_exp_`i' = rowtotal(value_rented_land_`cn'_`i' value_fertilizer_`cn'_`i' val_hire_harv_`cn'_`i' val_hire_prep_`cn'_`i')
		replace `cn'_exp_`i' =. if `cn'_monocrop_ha_`i'==.
		local l`cn': var lab `cn'_exp
		la var `cn'_exp_`i' "`l`cn'' - `i' managed plots"
	}
}

*Land rights
merge 1:1 household_id2 using  "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_land_rights_hh.dta", nogen keep (1 3)
la var formal_land_rights_hh "Household has documentation of land rights (at least one plot)"

*Crop yields 
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_yield_hh_level.dta", nogen keep (1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_area_planted_harvested_allcrops.dta", nogen keep (1 3)
drop ha_planted_purestand - ha_planted_mixed_mixed 

*Household diet
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_household_diet.dta", nogen keep (1 3)

*Post-planting inputs
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_pp_inputs_value.dta", nogen keep (1 3)

*Post-harvest inputs
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_cost_harv_labor.dta", nogen keep (1 3)

*Other inputs
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_cost_seed.dta", nogen keep (1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_fertilizer_application.dta", nogen keep (1 3)

*Crop production and losses
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hh_crop_production.dta", nogen keep (1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_losses.dta", nogen keep (1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_production_household.dta", nogen keep (1 3)

*Use variables
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_improvedseed_use.dta", nogen keep (1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_any_ext.dta", nogen keep (1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_vaccine.dta", nogen keep (1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_fin_serv.dta", nogen keep (1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_fert_use.dta", nogen keep (1 3)
recode ext_reach_all (.=0)
gen use_fin_serv_others = .
gen use_fin_serv_bank =.
gen use_fin_serv_insur =.
gen use_fin_serv_digital =.
gen use_fin_serv_savings =. 
gen ext_reach_public =.
gen ext_reach_private =.
gen ext_reach_unspecified =.
gen ext_reach_ict =.
global empty_vars $empty_vars use_fin_serv_others use_fin_serv_bank use_fin_serv_insur use_fin_serv_digital use_fin_serv_savings ext_reach_public ext_reach_private ext_reach_unspecified ext_reach_ict hybrid_seed*

*Livestock expenses and production
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_sales.dta", nogen keep (1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_expenses.dta", nogen keep (1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_products.dta", nogen keep (1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_TLU.dta", nogen keep (1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_milk_animals.dta", nogen keep (1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_eggs_animals.dta", nogen keep (1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_herd_characteristics", nogen keep (1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_TLU_Coefficients", nogen keep (1 3)
gen ls_exp_vac = .
gen lost_disease = .  
foreach i in lrum srum poultry{
	gen ls_exp_vac_`i'=.
}
global empty_vars $empty_vars lost_disease *ls_exp_vac*

*Non-agricultural income (plus agwages)
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_wage_income.dta", nogen keep (1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_self_employment_income.dta", nogen keep (1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_other_income.dta", nogen keep (1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_assistance_income.dta", nogen keep (1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_agwage_income.dta", nogen keep (1 3)

*fish income
gen fishing_income = . 
gen w_share_fishing = .
gen fishing_hh = .
global empty_vars $empty_vars *fishing_income* w_share_fishing fishing_hh

*Labor
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_farmlabor_postplanting.dta", nogen keep (1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_farmlabor_postharvest.dta", nogen keep (1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_ag_wage.dta", nogen keep (1 3)

*Off-farm hours
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_off_farm_hours.dta", nogen keep (1 3)

*Consumption
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_consumption.dta", nogen keep (1 3)

*Household assets
gen value_assets = .
global empty_vars $empty_vars *value_assets*

*Food security
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_LSMS_W2_food_insecurity.dta", nogen keep (1 3)
gen hhs_little = . 
gen hhs_moderate = . 
gen hhs_severe = . 
gen hhs_total = . 
global empty_vars $empty_vars hhs_* 

*Distance to agrodealer // cannot construct 
gen dist_agrodealer = . 
global empty_vars $empty_vars *dist_agrodealer
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_shannon_diversity_index.dta", nogen keep(1 3)

*Livestock health
merge 1:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_livestock_diseases.dta", nogen keep (1 3)

*livestock feeding, water, and housing
foreach v in feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed {
	gen `v' = . 
	foreach i in lrum srum poultry {
		gen `v'_`i' = . 
		}
	}
global empty_vars $empty_vars feed_grazing* water_source_nat* water_source_const* water_source_cover* lvstck_housed* 
	
*Recoding and creating new variables

*Generating labor variables
egen labor_family=rowtotal(days_famlabor_postplant days_famlabor_postharvest days_otherlabor_postplant days_otherlabor_postharvest)
egen labor_hired= rowtotal(days_hired_postplant days_hired_postharvest)
egen labor_other = rowtotal (days_otherlabor_postplant days_otherlabor_postharvest)
egen labor_total= rowtotal(days_famlabor_postplant days_famlabor_postharvest days_otherlabor_postplant days_otherlabor_postharvest days_hired_postplant days_hired_postharvest)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm in the past year"
drop days_hired* days_otherlabor_* days_nonhired_* days_famlabor_*

*Crop income
replace crop_value_lost = 0 if crop_value_lost==. & value_crop_production!=.
replace value_crop_production = 0 if value_crop_production==. & crop_value_lost!=.
egen crop_production_expenses = rowtotal(value_rented_land value_transport_free_seed value_transport_purchased_seed value_purchased_seed value_fert value_hired_harv_labor value_hired_prep_labor value_transport_cropsales)
gen crop_income = value_crop_production - crop_production_expenses - crop_value_lost
recode crop_income crop_production_expenses (.=0)
lab var crop_production_expenses "Crop production expenditures (explicit)"
lab var crop_income "Net crop revenue (value of production minus crop expenses)"

*Farm size
ren area_meas_hectares_hh land_size
recode land_size (.=0)

*Livestock income
recode value_livestock_sales value_byproduct cost_expenses_livestock cost_labor_livestock tlu_today (.=0)
gen livestock_income = value_livestock_sales + value_byproduct - (cost_expenses_livestock + cost_labor_livestock)
recode value_milk_produced value_eggs_produced (0=.)
lab var livestock_income "Net livestock income (value of production and consumption minus expenditures)"
gen livestock_expenses = cost_expenses_livestock + cost_labor_livestock
lab var sales_livestock_products "Value of sales of livestock products"
lab var value_livestock_products "Value of livestock products"
*Other income
recode annual_selfemp_profit annual_salary annual_salary_agwage transfer_income pension_income investment_income rental_income sales_income inheritance_income /*
*/ psnp_income assistance_income land_rental_income_upfront (.=0)
ren annual_selfemp_profit self_employment_income 
lab var self_employment_income "Income from self-employment (business)"
ren annual_salary nonagwage_income
ren annual_salary_agwage agwage_income
egen transfers_income = rowtotal(transfer_income pension_income psnp_income assistance_income)
la var transfers_income "Income from transfers including pension, remittances, and assisances)"
egen all_other_income = rowtotal(investment_income rental_income sales_income inheritance_income land_rental_income_upfront)
lab var all_other_income "Income from transfers, remittances, other revenue streams not captured elsewhere"
drop transfer_income pension_income psnp_income assistance_income investment_income rental_income sales_income inheritance_income land_rental_income_upfront /*
*/ value_byproduct cost_expenses_livestock cost_labor_livestock 

*Farm Production 
gen value_farm_production = value_crop_production + value_livestock_products + value_lvstck_sold
lab var value_farm_production "Total value of farm production (crops + livestock products)"
gen value_farm_prod_sold = value_crop_sales + sales_livestock_products + value_lvstck_sold //there is no value for livestock slaughtered sold 
lab var value_farm_prod_sold "Total value of farm production that is sold" 
replace value_farm_prod_sold = 0 if value_farm_prod_sold==. & value_farm_production!=.

*Agricultural households
recode value_crop_production livestock_income farm_area tlu_today (.=0)
gen ag_hh = (value_crop_production!=0 | livestock_income!=0 | farm_area!=0 | tlu_today!=0)

*Household engages in ag activities including working in paid ag jobs
gen agactivities_hh =ag_hh==1 | (agwage_income!=0 & agwage_income!=.)
lab var agactivities_hh "1=Household has some land cultivated, livestock, crop income, livestock income, or ag wage income"

*Creating crop household and livestock household
gen crop_hh = (value_crop_production!=0  | farm_area!=0)
count if crop_hh==1 
gen livestock_hh = (livestock_income!=0 | tlu_today!=0)
count if livestock_hh==1 
count if value_crop_production==.

*households engaged in egg production 
gen egg_hh = (value_eggs_produced>0 & value_eggs_produced!=.)
lab var egg_hh "1=Household engaged in egg production"
*household engaged in dairy production
gen dairy_hh = (value_milk_produced>0 & value_milk_produced!=.)
lab var dairy_hh "1= Household engaged in dairy production" 

*Farm size categories
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

*Total costs (implicit + explicit)
egen cost_total_hh = rowtotal(value_owned_land value_rented_land value_hired_prep_labor value_fam_prep_labor value_hired_harv_labor value_fam_harv_labor value_fert value_purchased_seed value_non_purchased_seed value_transport_purchased_seed value_transport_free_seed)
lab var cost_total_hh "Explicit + implicit costs of crop production (household level)"

*Total costs that can be disaggregated by gender of plot manager
egen cost_total = rowtotal(value_owned_land value_rented_land value_hired_prep_labor value_fam_prep_labor value_hired_harv_labor value_fam_harv_labor value_fert)
lab var cost_total "Explicit + implicit costs of crop production that can be disaggregated at the plot manager level"
*Creating total costs by gender (excludes seeds)
foreach i in male female mixed{
	egen cost_total_`i' = rowtotal(value_owned_land_`i' value_rented_land_`i' value_hired_prep_labor_`i' value_fam_prep_labor_`i' value_hired_harv_labor_`i' value_fam_harv_labor_`i' value_fert_`i')
	lab var cost_total_`i' "Explicit + implicit costs of crop production (`i'-managed plots)"
}
*Recoding zeros as missings
recode cost_total* (0=.)		// should be no zeros for implicit costs

*Explicit costs only
egen cost_expli_hh = rowtotal(value_rented_land value_hired_prep_labor value_hired_harv_labor value_fert value_purchased_seed value_transport_purchased_seed value_transport_free_seed)
lab var cost_expli_hh "Total explicit crop production (household level)" 

*Creating explicit costs by gender (excludes seeds)
egen cost_expli = rowtotal(value_rented_land value_hired_prep_labor value_hired_harv_labor value_fert)
lab var cost_expli "Explicit costs of crop production that can be disaggregated at the plot manager level"
foreach i in male female mixed{
	egen cost_expli_`i' = rowtotal(value_rented_land_`i' value_hired_prep_labor_`i' value_hired_harv_labor_`i' value_fert_`i')
	lab var cost_expli_`i'  "Crop production costs per hectare, explicit costs (`i'-managed plots)"
}
drop value_owned_land* value_rented_land* value_hired_prep_labor* value_fam_prep_labor* value_hired_harv_labor* value_fam_harv_labor* *value_fert* value_purchased_seed* value_non_purchased_seed* /*
*/ value_transport_purchased_seed* value_transport_free_seed* value_rented_land_* value_fertilizer_* val_hire_harv_* val_hire_prep_*

*Milk productivity
gen liters_milk_produced= liters_per_cow*milk_animals
lab var liters_milk_produced "Total quantity (liters) of milk per year" 
drop liters_per_cow
gen liters_per_buffalo=.
gen liters_per_largeruminant = .
global empty_vars $empty_vars *liters_per_largeruminant *liters_per_buffalo

*Dairy costs 
merge 1:1 household_id2 using "$Ethiopia_ESS_W2_created_data\Ethiopia_ESS_W2_lrum_expenses", nogen keep (1 3)
gen avg_cost_lrum = cost_lrum/mean_12months_lrum 
drop cost_lrum avg_cost_lrum 
gen share_imp_dairy=.
global empty_vars $empty_vars share_imp_dairy *costs_dairy_percow*

****getting correct subpopulations*****
*Recoding missings to 0 for households growing crops
recode grew* (.=0)
*all rural households growing specific crops 
forvalues k=1(1)16 {
	local cn: word `k' of $topcropname_area
	recode value_harv_`cn' value_sold_`cn' kgs_harvest_`cn' total_planted_area_`cn' total_harv_area_`cn' `cn'_exp (.=0) if grew_`cn'==1
	recode value_harv_`cn' value_sold_`cn' kgs_harvest_`cn' total_planted_area_`cn' total_harv_area_`cn' `cn'_exp (nonmissing=.) if grew_`cn'==0
}
*all rural households engaged in livestcok production of a given species
foreach i in lrum srum poultry{
	recode lost_disease_`i' ls_exp_vac_`i' disease_animal_`i' feed_grazing_`i' water_source_nat_`i' water_source_const_`i' water_source_cover_`i' lvstck_housed_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode lost_disease_`i' ls_exp_vac_`i' disease_animal_`i' feed_grazing_`i' water_source_nat_`i' water_source_const_`i' water_source_cover_`i' lvstck_housed_`i'(.=0) if lvstck_holding_`i'==1	
}
*households engaged in crop production
recode cost_expli* value_crop_production value_crop_sales labor_hired labor_family farm_size_agland all_area_harvested all_area_planted encs num_crops_hh multiple_crops (.=0) if crop_hh==1
recode cost_expli* value_crop_production value_crop_sales labor_hired labor_family farm_size_agland all_area_harvested all_area_planted encs num_crops_hh multiple_crops (nonmissing=.) if crop_hh==0
*all rural households engaged in livestock production 
recode animals_lost12months* mean_12months* livestock_expenses disease_animal feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed (.=0) if livestock_hh==1
recode animals_lost12months* mean_12months* livestock_expenses disease_animal feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed (nonmissing=.) if livestock_hh==0
*all rural households 
recode off_farm_hours crop_income livestock_income self_employment_income nonagwage_income agwage_income transfers_income all_other_income (.=0)
*all rural households engaged in dairy production
recode costs_dairy liters_milk_produced value_milk_produced (.=0) if dairy_hh==1 
recode costs_dairy liters_milk_produced value_milk_produced (nonmissing=.) if dairy_hh==0
*all rural households eith egg-producing animals
recode egg_poultry_year value_eggs_produced (.=0) if egg_hh==1
recode egg_poultry_year value_eggs_produced (nonmissing=.) if egg_hh==0
drop value_harvest*

*** Begin addressing outliers  and estimating indicators that are ratios using winsorized values ***
global gender "female male mixed"
global wins_var_top1 /*
*/ cost_total_hh cost_expli_hh value_assets /*
*/ value_crop_production value_crop_sales value_harv* value_sold* kgs_harvest* total_planted_area* total_harv_area* /*
*/ labor_hired labor_family labor_other/*
*/ animals_lost12months* mean_12months* lost_disease* costs_dairy /*
*/ liters_milk_produced value_eggs_produced value_milk_produced egg_poultry_year /*
*/ off_farm_hours livestock_expenses ls_exp_vac* crop_production_expenses kgs_harv_mono* sales_livestock_products value_livestock_products value_livestock_sales  /*
*/ value_farm_production value_farm_prod_sold 

gen wage_paid_aglabor_mixed=. //create this just to make the loop work and delete after
foreach v of varlist $wins_var_top1 {
	_pctile `v' [aw=weight] , p($wins_upper_thres)  
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top 1%"
}
global wins_var_top1_gender=""
foreach v in $topcropname_area {
	global wins_var_top1_gender $wins_var_top1_gender `v'_exp
}
global wins_var_top1_gender $wins_var_top1_gender cost_total cost_expli fert_inorg_kg wage_paid_aglabor
foreach v of varlist $wins_var_top1_gender {
	_pctile `v' [aw=weight] , p($wins_upper_thres)  
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
*Generating labor_total  as sum of winsorized labor_hired and labor_family
egen w_labor_total=rowtotal(w_labor_hired w_labor_family w_labor_other)
local llabor_total : var lab labor_total 
lab var w_labor_total "`labor_total' - Winzorized top 1%"

*Variables winsorized both at the top 1% and bottom 1% 
global wins_var_top1_bott1  /* 
*/ farm_area farm_size_agland all_area_harvested all_area_planted ha_planted /*
*/ crop_income livestock_income self_employment_income nonagwage_income agwage_income transfers_income all_other_income fishing_income  /*
*/ *_monocrop_ha* total_cons percapita_cons daily_percap_cons peraeq_cons daily_peraeq_cons dist_agrodealer

foreach v of varlist $wins_var_top1_bott1 {
	_pctile `v' [aw=weight] , p(1 99) 
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

*area_harv  and area_plan are also winsorized both at the top 1% and bottom 1% because we need to treat at the crop level
global allyield male female mixed inter inter_male inter_female inter_mixed pure pure_male pure_female pure_mixed
global wins_var_top1_bott1_2 area_harv  area_plan harvest 
foreach v of global wins_var_top1_bott1_2 {
	foreach c of global topcropname_area {
		_pctile `v'_`c'  [aw=weight] , p(1 99)
		gen w_`v'_`c'=`v'_`c'
		replace w_`v'_`c' = r(r1) if w_`v'_`c' < r(r1)   &  w_`v'_`c'!=0 
		replace w_`v'_`c' = r(r2) if (w_`v'_`c' > r(r2) & w_`v'_`c' !=.)  		
		local l`v'_`c'  : var lab `v'_`c'
		lab var  w_`v'_`c' "`l`v'_`c'' - Winzorized top and bottom 1%"
		* now use pctile from area for all to trim gender/inter/pure area
		foreach g of global allyield {
			gen w_`v'_`g'_`c'=`v'_`g'_`c'
			replace w_`v'_`g'_`c' = r(r1) if w_`v'_`g'_`c' < r(r1) &  w_`v'_`g'_`c'!=0 
			replace w_`v'_`g'_`c' = r(r2) if (w_`v'_`g'_`c' > r(r2) & w_`v'_`g'_`c' !=.)  	
			local l`v'_`g'_`c'  : var lab `v'_`g'_`c'
			lab var  w_`v'_`g'_`c' "`l`v'_`g'_`c'' - Winzorized top and bottom 1%"
			
		}
	}
}

*Estimate variables that are ratios then winsorize top 1% and bottom 1% of the ratios (do not replace 0 by the percentiles)

*generate yield and weights for yields  using winsorized values 
*Yield by Area Planted
foreach c of global topcropname_area {
	gen yield_pl_`c'=w_harvest_`c'/w_area_plan_`c'
	lab var  yield_pl_`c' "Yield by area planted of `c' (kgs/ha) (household)" 
	gen ar_pl_wgt_`c' =  weight*w_area_plan_`c'
	lab var ar_pl_wgt_`c' "Planted area-adjusted weight for `c' (household)"
	foreach g of global allyield  {
		gen yield_pl_`g'_`c'=w_harvest_`g'_`c'/w_area_plan_`g'_`c'
		lab var  yield_pl_`g'_`c'  "Yield by area planted of `c' -  (kgs/ha) (`g')" 
		gen ar_pl_wgt_`g'_`c' =  weight*w_area_plan_`g'_`c'
		lab var ar_pl_wgt_`g'_`c' "Planted area-adjusted weight for `c' (`g')"
	}
}

*generate yield and weights for yields using winsorized values 
*Yield by area harvested
foreach c of global topcropname_area {
	gen yield_hv_`c'=w_harvest_`c'/w_area_harv_`c'
	lab var  yield_hv_`c' "Yield by area harvested of `c' (kgs/ha) (household)" 
	gen ar_h_wgt_`c' =  weight*w_area_harv_`c'
	lab var ar_h_wgt_`c' "Harvested area-adjusted weight for `c' (household)"
	recode yield_hv_`c' (0=.)														//some HH report an area harvested but no amount harvested -- cannot have a 0 yield by area harvested
	foreach g of global allyield  {
		gen yield_hv_`g'_`c'=w_harvest_`g'_`c'/w_area_harv_`g'_`c'
		lab var  yield_hv_`g'_`c'  "Yield by area harvested of `c' -  (kgs/ha) (`g')" 
		gen ar_h_wgt_`g'_`c' =  weight*w_area_harv_`g'_`c'
		lab var ar_h_wgt_`g'_`c' "Harvested area-adjusted weight for `c' (`g')"
		recode yield_hv_`g'_`c' (0=.)												//some HH report an area harvested but no amount harvested -- cannot have a 0 yield by area harvested
	}
}
 
*generate inorg_fert_rate, costs_total_ha, and costs_expli_ha using winsorized values
gen inorg_fert_rate=w_fert_inorg_kg/w_ha_planted
gen cost_total_ha=w_cost_total_hh/w_ha_planted
gen cost_expli_ha=cost_expli_hh/w_ha_planted
gen cost_explicit_hh_ha=w_cost_expli_hh/w_ha_planted
foreach g of global gender {
	gen inorg_fert_rate_`g'=w_fert_inorg_kg_`g'/ w_ha_planted_`g'
	gen cost_total_ha_`g'=w_cost_total_`g'/ w_ha_planted_`g'
	gen cost_expli_ha_`g'=w_cost_expli_`g'/ w_ha_planted_`g'			
}
lab var inorg_fert_rate "Rate of fertilizer application (kgs/ha) (household level)"
lab var inorg_fert_rate_male "Rate of fertilizer application (kgs/ha) (male-managed crops)"
lab var inorg_fert_rate_female "Rate of fertilizer application (kgs/ha) (female-managed crops)"
lab var inorg_fert_rate_mixed "Rate of fertilizer application (kgs/ha) (mixed-managed crops)"
lab var cost_total_ha "Explicit + implicit costs (per ha) of crop production (household level)"
lab var cost_total_ha_male "Explicit + implicit costs (per ha) of crop production (male-managed plots)"
lab var cost_total_ha_female "Explicit + implicit costs (per ha) of crop production (female-managed plots)"
lab var cost_total_ha_mixed "Explicit + implicit costs (per ha) of crop production (mixed-managed plots)"
lab var cost_expli_ha "Explicit costs (per ha) of crop production (household level)"
lab var cost_expli_ha_male "Explicit costs (per ha) of crop production (male-managed plots)"
lab var cost_expli_ha_female "Explicit costs (per ha) of crop production (female-managed plots)"
lab var cost_expli_ha_mixed "Explicit costs (per ha) of crop production (mixed-managed plots)"
lab var cost_explicit_hh_ha "Explicit costs (per ha) of crop production (household level)"

*mortality rate
global animal_species lrum srum camel equine  poultry 
foreach s of global animal_species {
	gen mortality_rate_`s' = animals_lost12months_`s'/mean_12months_`s'
	lab var mortality_rate_`s' "Mortality rate - `s'"
}

*Generating crop expenses by hectare for top crops
forvalues k=1/$nb_topcrops {
	local cn: word `k' of $topcropname_area
	local cnfull: word `k' of $topcropname_full
	gen `cn'_exp_ha = w_`cn'_exp / w_`cn'_monocrop_ha		
	la var `cn'_exp_ha "Costs per hectare - Monocropped `cnfull' plots"
	foreach g of global gender {
		gen `cn'_exp_ha_`g' = w_`cn'_exp_`g'/w_`cn'_monocrop_ha_`g'
		local l`cn': var lab `cn'_exp_ha
		la var `cn'_exp_ha_`g' "`l`cn'' - `g' managed plots"
	}
}

*Off farm hours per capita using winsorized version off_farm_hours 
gen off_farm_hours_pc_all = w_off_farm_hours/member_count					// this is pc hours, counting all members in the module (supposed to be five years or older)
gen off_farm_hours_pc_any = w_off_farm_hours/off_farm_any_count				// this is pc hours, counting only members with positive hours
la var off_farm_hours_pc_all "Off-farm hours per capita, all members>5 years"
la var off_farm_hours_pc_any "Off-farm hours per capita, only members>5 years workings"

*generating total crop production costs per hectare
gen cost_expli_hh_ha = w_cost_expli_hh/w_ha_planted
lab var cost_expli_hh_ha "Explicit costs (per ha) of crop production (household level)"

*land and labor productivity
gen land_productivity = w_value_crop_production/w_farm_area
gen labor_productivity = w_value_crop_production/w_labor_total 
lab var land_productivity "Land productivity (value production per ha cultivated)"
lab var labor_productivity "Labor productivity (value production per labor-day)"   

*milk productivity
gen liters_per_cow= w_liters_milk_produced/milk_animals // generate milk productivity using winsorized version of liters_milk_produced
lab var liters_per_cow "Average quantity (liters) per year (household)"
gen costs_dairy_percow = w_costs_dairy/milk_animals_total
lab var milk_animals_total "total number of milk animals owned by the hh" 

*Egg productivity
gen w_eggs_total_year = w_egg_poultry_year*laying_hens
lab var w_eggs_total_year "Total number of eggs that was produced (household)"
recode w_eggs_total_year (0=.)
ren laying_hens poultry_owned 

*Proportion of crop value sold
gen w_proportion_cropvalue_sold = w_value_crop_sales /  w_value_crop_production
replace w_proportion_cropvalue_sold = 1 if w_proportion_cropvalue_sold>1 & w_proportion_cropvalue_sold!=.
lab var w_proportion_cropvalue_sold "Proportion of crop value produced (winsorized) that has been sold"

*livestock value sold 
gen w_share_livestock_prod_sold = w_sales_livestock_products / w_value_livestock_products
replace w_share_livestock_prod_sold = 1 if w_share_livestock_prod_sold>1 & w_share_livestock_prod_sold!=.
lab var w_share_livestock_prod_sold "Percent of production of livestock products (winsorized) that is sold"

*Propotion of farm production sold
gen w_prop_farm_prod_sold = w_value_farm_prod_sold / w_value_farm_production
replace w_prop_farm_prod_sold = 1 if w_prop_farm_prod_sold>1 & w_prop_farm_prod_sold!=.
lab var w_prop_farm_prod_sold "Proportion of farm production (winsorized) that has been sold"

*replacing zeros with missing for non-crop_hh
recode use_fin_serv* ext_reach* use_inorg_fert imprv_seed_use vac_animal (.=0)		
replace vac_animal=. if tlu_today==0 
replace use_inorg_fert=. if farm_area==0 | farm_area==. 
recode ext_reach* (0 1=.) if (value_crop_production==0 & livestock_income==0 & farm_area==0 & tlu_today==0)
recode ext_reach* (0 1=.) if farm_area==.
replace imprv_seed_use=. if farm_area==.

*Unit cost of production
*top crops
forvalues k=1/$nb_topcrops {
	local cn: word `k' of $topcropname_area
	local cnfull: word `k' of $topcropname_full
	gen `cn'_exp_kg = w_`cn'_exp / w_kgs_harv_mono_`cn'	
	la var `cn'_exp_kg "Costs per kilogram produced - `cnfull' monocropped plots"
	foreach g of global gender {
		gen `cn'_exp_kg_`g'= w_`cn'_exp_`g'/w_kgs_harv_mono_`cn'_`g'
		local l`cn': var lab `cn'_exp_kg
		la var `cn'_exp_kg_`g' "`l`cn'' - `g' mananged plots"
	}
}

*dairy
gen cost_per_lit_milk =w_costs_dairy/w_liters_milk_produced  

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
recode off_farm_hours_pc_all (.=0)
*households engaged in monocropped production of specific crops
forvalues k=1/16 {
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
recode costs_dairy_percow cost_per_lit_milk liters_per_cow (.=0) if dairy_hh==1
recode costs_dairy_percow cost_per_lit_milk liters_per_cow (nonmissing=.) if dairy_hh==0
*households with egg-producing animals
recode egg_poultry_year (.=0) if egg_hh==1 
recode egg_poultry_year (nonmissing=.) if egg_hh==0

*now winsorize ratios only at top 1% 
global wins_var_ratios_top1 inorg_fert_rate cost_total_ha cost_expli_ha cost_expli_hh_ha /*
*/ land_productivity labor_productivity /*
*/ mortality_rate* liters_per_largeruminant liters_per_cow liters_per_buffalo /*
*/ off_farm_hours_pc_all off_farm_hours_pc_any costs_dairy_percow cost_per_lit_milk  

foreach v of varlist $wins_var_ratios_top1 {
	_pctile `v' [aw=weight] , p($wins_upper_thres)  
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top 1%"

	*some variables are disaggreated by gender of plot manager. For these variables, we use the top 1% percentile to winsorize gender-disagregated variables
	if "`v'" =="inorg_fert_rate" | "`v'" =="cost_total_ha"  | "`v'" =="cost_expli_ha" {
		foreach g of global gender {
			gen w_`v'_`g'=`v'_`g'
			replace  w_`v'_`g' = r(r1) if w_`v'_`g' > r(r1) & w_`v'_`g'!=.
			local l`v'_`g' : var lab `v'_`g'
			lab var  w_`v'_`g'  "`l`v'_`g'' - Winzorized top 1%"
		}	
	}
}

*winsorizing top crop ratios
foreach v of global topcropname_area {
	*first winsorizing costs per hectare
	_pctile `v'_exp_ha [aw=weight] , p($wins_upper_thres)  
	gen w_`v'_exp_ha = `v'_exp_ha
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
	_pctile `v'_exp_kg [aw=weight] , p($wins_upper_thres)  
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

*now winsorize ratio only at top 1% - yield 
foreach c of global topcropname_area {
	foreach i in yield_pl yield_hv{
		_pctile `i'_`c' [aw=weight] , p($wins_upper_thres)  
		gen w_`i'_`c'=`i'_`c'
		replace  w_`i'_`c' = r(r1) if  w_`i'_`c' > r(r1) &  w_`i'_`c'!=.
		local w_`i'_`c' : var lab `i'_`c'
		lab var  w_`i'_`c'  "`w_`i'_`c'' - Winzorized top 1%"
		foreach g of global allyield  {
			gen w_`i'_`g'_`c'= `i'_`g'_`c'
			replace  w_`i'_`g'_`c' = r(r1) if  w_`i'_`g'_`c' > r(r1) &  w_`i'_`g'_`c'!=.
			local w_`i'_`g'_`c' : var lab `i'_`g'_`c'
			lab var  w_`i'_`g'_`c'  "`w_`i'_`g'_`c'' - Winzorized top 1%"
		}
	}
}
 
*Create final income variables using un_winzorized and winzorized values
egen total_income = rowtotal(crop_income livestock_income self_employment_income nonagwage_income agwage_income transfers_income all_other_income)
egen nonfarm_income = rowtotal(self_employment_income nonagwage_income transfers_income all_other_income)
egen farm_income = rowtotal(crop_income livestock_income agwage_income)
lab var  nonfarm_income "Nonfarm income (excludes ag wages)"
gen percapita_income = total_income/hh_members
lab var total_income "Total household income"
lab var percapita_income "Household incom per hh member per year"
lab var farm_income "Farm income"
egen w_total_income = rowtotal(w_crop_income w_livestock_income w_self_employment_income w_nonagwage_income w_agwage_income w_transfers_income w_all_other_income)
egen w_nonfarm_income = rowtotal(w_self_employment_income w_nonagwage_income w_transfers_income w_all_other_income)
egen w_farm_income = rowtotal(w_crop_income w_livestock_income w_agwage_income)
lab var  w_nonfarm_income "Nonfarm income (excludes ag wages) - Winzorized top 1%"
lab var w_farm_income "Farm income - Winzorized top 1%"
gen w_percapita_income = w_total_income/hh_members
lab var w_total_income "Total household income - Winzorized top 1%"
lab var w_percapita_income "Household income per hh member per year - Winzorized top 1%"
global income_vars crop livestock self_employment nonagwage agwage transfers all_other
foreach p of global income_vars {
	gen `p'_income_s = `p'_income
	replace `p'_income_s = 0 if `p'_income_s < 0
	gen w_`p'_income_s = w_`p'_income
	replace w_`p'_income_s = 0 if w_`p'_income_s < 0 
}
egen w_total_income_s = rowtotal(w_crop_income_s w_livestock_income_s w_self_employment_income_s w_nonagwage_income_s w_agwage_income_s  w_transfers_income_s w_all_other_income_s)
foreach p of global income_vars {
	gen w_share_`p' = w_`p'_income_s / w_total_income_s
	lab var w_share_`p' "Share of household (winsorized) income from `p'_income"
}

egen w_nonfarm_income_s = rowtotal(w_self_employment_income_s w_nonagwage_income_s w_transfers_income_s w_all_other_income_s)
gen w_share_nonfarm = w_nonfarm_income_s / w_total_income_s
lab var w_share_nonfarm "Share of household income (winsorized) from nonfarm sources"
foreach p of global income_vars {
	drop `p'_income_s  w_`p'_income_s 
}
drop w_total_income_s w_nonfarm_income_s

***getting correct subpopulations 
*all rural households 
//note that consumption indicators are not included because there is missing consumption data and we do not consider 0 values for consumption to be valid
recode w_total_income w_percapita_income w_crop_income w_livestock_income /*w_fishing_income*/ w_nonagwage_income w_agwage_income w_self_employment_income w_transfers_income w_all_other_income /*
*/ w_share_crop w_share_livestock w_share_nonagwage w_share_agwage w_share_self_employment w_share_transfers w_share_all_other w_share_nonfarm /*
*/ use_fin_serv* use_inorg_fert imprv_seed_use /*
*/ formal_land_rights_hh w_off_farm_hours_pc_all months_food_insec /*
*/ lvstck_holding_tlu lvstck_holding_all lvstck_holding_lrum lvstck_holding_srum lvstck_holding_poultry (.=0) if rural==1 
 
 
*all rural households engaged in livestock production
recode vac_animal w_share_livestock_prod_sold w_livestock_expenses w_ls_exp_vac any_imp_herd_all (. = 0) if livestock_hh==1 
recode vac_animal w_share_livestock_prod_sold w_livestock_expenses w_ls_exp_vac any_imp_herd_all (nonmissing = .) if livestock_hh==0 

*all rural households engaged in livestcok production of a given species
foreach i in lrum srum poultry{
	recode vac_animal_`i' any_imp_herd_`i' w_lost_disease_`i' w_ls_exp_vac_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode vac_animal_`i' any_imp_herd_`i' w_lost_disease_`i' w_ls_exp_vac_`i' (.=0) if lvstck_holding_`i'==1	
}

*households engaged in crop production
recode w_proportion_cropvalue_sold w_farm_size_agland w_labor_family w_labor_hired /*
*/ imprv_seed_use use_inorg_fert w_labor_productivity w_land_productivity /*
*/ w_inorg_fert_rate w_cost_expli_hh w_cost_expli_hh_ha w_cost_expli_ha w_cost_total_ha /*
*/ w_value_crop_production w_value_crop_sales w_all_area_planted w_all_area_harvested (.=0) if crop_hh==1
recode w_proportion_cropvalue_sold w_farm_size_agland w_labor_family w_labor_hired /*
*/ imprv_seed_use use_inorg_fert w_labor_productivity w_land_productivity /*
*/ w_inorg_fert_rate w_cost_expli_hh w_cost_expli_hh_ha w_cost_expli_ha w_cost_total_ha /*
*/ w_value_crop_production w_value_crop_sales w_all_area_planted w_all_area_harvested (nonmissing= . ) if crop_hh==0
		
*hh engaged in crop or livestock production
recode ext_reach* (.=0) if (crop_hh==1 | livestock_hh==1)
recode ext_reach* (nonmissing=.) if crop_hh==0 & livestock_hh==0

*all rural households growing specific crops 
forvalues k=1(1)16 {
	local cn: word `k' of $topcropname_area
	recode imprv_seed_`cn' hybrid_seed_`cn' w_yield_pl_`cn' /*				
	*/ w_value_harv_`cn' w_value_sold_`cn' w_kgs_harvest_`cn' w_total_planted_area_`cn' w_total_harv_area_`cn' (.=0) if grew_`cn'==1
	recode imprv_seed_`cn' hybrid_seed_`cn' w_yield_pl_`cn' /*				
	*/ w_value_harv_`cn' w_value_sold_`cn' w_kgs_harvest_`cn' w_total_planted_area_`cn' w_total_harv_area_`cn' (nonmissing=.) if grew_`cn'==0
}

*all rural households that harvested specific crops
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode w_yield_hv_`cn' (.=0) if harvested_`cn'==1
	recode w_yield_hv_`cn' (nonmissing=.) if harvested_`cn'==0
}

*households engaged in monocropped production of specific crops
forvalues k=1/16 {
	local cn: word `k' of $topcropname_area
	recode w_`cn'_exp w_`cn'_exp_ha w_`cn'_exp_kg (.=0) if `cn'_monocrop==1
	recode w_`cn'_exp w_`cn'_exp_ha w_`cn'_exp_kg (nonmissing=.) if `cn'_monocrop==0
}

*all rural households engaged in dairy production
recode costs_dairy liters_milk_produced w_value_milk_produced (.=0) if dairy_hh==1 
recode costs_dairy liters_milk_produced w_value_milk_produced (nonmissing=.) if dairy_hh==0
*all rural households eith egg-producing animals
recode w_eggs_total_year w_value_eggs_produced (.=0) if egg_hh==1
recode w_eggs_total_year w_value_eggs_produced (nonmissing=.) if egg_hh==0

*** End outliers *** 


gen use_fin_serv_all=use_fin_serv_credit		//The only financial services in the questionnaire are for credit, so these are the same
*recoding households that don't report using financial services from missing to 0
recode use_fin_serv_all use_fin_serv_credit (.=0)

*create different weights 
gen w_labor_weight=weight*w_labor_total
gen w_land_weight=weight*w_farm_area
gen w_aglabor_weight_all=w_labor_hired*weight
lab var w_aglabor_weight_all "Hired labor-adjusted household weights"
gen w_aglabor_weight_female=1  
lab var w_aglabor_weight_female "Hired labor-adjusted household weights -female workers"
gen w_aglabor_weight_male=1 
lab var w_aglabor_weight_male "Hired labor-adjusted household weights -male workers"
gen weight_milk=milk_animals*weight
gen weight_egg=poultry_owned*weight
global fert_vars all female male mixed
gen w_ha_planted_all = ha_planted 
foreach  v of global fert_vars {
	gen area_weight_`v'=weight*w_ha_planted_`v'
}
drop w_ha_planted_all
gen w_ha_planted_weight=w_ha_planted*weight
*generate area weights for monocropped plots
foreach cn in $topcropname_area {
	gen ar_pl_mono_wgt_`cn'_all = weight*`cn'_monocrop_ha
	gen kgs_harv_wgt_`cn'_all = weight*kgs_harv_mono_`cn'
	foreach g in male female mixed {
		gen ar_pl_mono_wgt_`cn'_`g' = weight*`cn'_monocrop_ha_`g'
		gen kgs_harv_wgt_`cn'_`g' = weight*kgs_harv_mono_`cn'_`g'
	}
}
gen individual_weight=hh_members*weight
gen adulteq_weight=adulteq*weight

*Rural poverty headcount ratio
*First, we convert $1.90/day to local currency in 2011 using https://data.worldbank.org/indicator/PA.NUS.PRVT.PP?end=2011&locations=TZ&start=1990
	// 1.90 * 5.439 = 10.3341  
*NOTE: this is using the "Private Consumption, PPP" conversion factor because that's what we have been using. 
* This can be changed this to the "GDP, PPP" if we change the rest of the conversion factors.
*The global poverty line of $1.90/day is set by the World Bank
*http://www.worldbank.org/en/topic/poverty/brief/global-poverty-line-faq
*Second, we inflate the local currency to the year that this survey was carried out using the CPI inflation rate using https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2017&locations=TZ&start=2003
	// 1+(191.991 - 133.25)/ 133.25 = 1.440833	
	// 10.3341* 1.440833 = 14.889712 ETB
*NOTE: if the survey was carried out over multiple years we use the last year
*This is the poverty line at the local currency in the year the survey was carried out

gen poverty_under_1_9 = (daily_percap_cons<14.889712)
la var poverty_under_1_9 "Household has a percapita conumption of under $1.90 in 2011 $ PPP)"

*average consumption expenditure of the bottom 40% of the rural consumption expenditure distribution
*By per capita consumption
_pctile w_daily_percap_cons [aw=individual_weight] if rural==1, p(40)
gen bottom_40_percap = 0
replace bottom_40_percap = 1 if r(r1) > w_daily_percap_cons & rural==1

*By peraeq consumption
_pctile w_daily_peraeq_cons [aw=adulteq_weight] if rural==1, p(40)
gen bottom_40_peraeq = 0
replace bottom_40_peraeq = 1 if r(r1) > w_daily_peraeq_cons & rural==1

****Currency Conversion Factors*** 
gen ccf_loc = (1+$Ethiopia_ESS_W2_inflation) 
lab var ccf_loc "currency conversion factor - 2016 $ETB"
gen ccf_usd = (1+$Ethiopia_ESS_W2_inflation) / $Ethiopia_ESS_W2_exchange_rate 
lab var ccf_usd "currency conversion factor - 2016 $USD"
gen ccf_1ppp = (1+$Ethiopia_ESS_W2_inflation) / $Ethiopia_ESS_W2_cons_ppp_dollar 
lab var ccf_1ppp "currency conversion factor - 2016 $Private Consumption PPP"
gen ccf_2ppp = (1+$Ethiopia_ESS_W2_inflation) / $Ethiopia_ESS_W2_gdp_ppp_dollar 
lab var ccf_2ppp "currency conversion factor - 2016 $GDP PPP"

*Cleaning up output to get below 5,000 variables
*dropping unnecessary variables and recoding to missing any variables that cannot be created in this instrument
drop *_inter_* harvest_* w_harvest_*

*Removing intermediate variables to get below 5,000 vars
keep household_id2 fhh clusterid strataid *weight* *wgt* region zone woreda town subcity kebele ea household rural farm_size* *total_income* /*
*/ *percapita_income* *percapita_cons* *daily_percap_cons* *peraeq_cons* *daily_peraeq_cons* /*
*/ *income* *share* *proportion_cropvalue_sold *farm_size_agland hh_members adulteq *labor_family *labor_hired use_inorg_fert vac_* /*
*/ feed* water* lvstck_housed* ext_* use_fin_* lvstck_holding* *mortality_rate* *lost_disease* disease* any_imp* formal_land_rights_hh /*
*/ *livestock_expenses* *ls_exp_vac* *prop_farm_prod_sold *off_farm_hours_pc* months_food_insec *value_assets* hhs_* *dist_agrodealer /*
*/ encs* num_crops_* multiple_crops* imprv_seed_* hybrid_seed_* *labor_total *farm_area *labor_productivity* *land_productivity* /*
*/ *wage_paid_aglabor* *labor_hired ar_h_wgt_* *yield_hv_* ar_pl_wgt_* *yield_pl_* *liters_per_* milk_animals poultry_owned *costs_dairy* *cost_per_lit* /*
*/ *egg_poultry_year* *inorg_fert_rate* *ha_planted* *cost_expli_hh* *cost_expli_ha* *monocrop_ha* *kgs_harv_mono* *cost_total_ha* /*
*/ *_exp* poverty_under_1_9 *value_crop_production* *value_harv* *value_crop_sales* *value_sold* *kgs_harvest* *total_planted_area* *total_harv_area* /*
*/ *all_area_* grew_* agactivities_hh ag_hh crop_hh livestock_hh fishing_hh *_milk_produced* *eggs_total_year *value_eggs_produced* /*
*/ *value_livestock_products* *value_livestock_sales* *total_cons* nb_cattle_today nb_poultry_today bottom_40_percap bottom_40_peraeq /*
*/ ccf_loc ccf_usd ccf_1ppp ccf_2ppp *sales_livestock_products

*create missing crop variables (no cowpea or yam)
foreach x of varlist *maize* {
	foreach c in cowpea {
		gen `x'_xx = .
		ren *maize*_xx *`c'*
	}
}
global empty_vars $empty_vars *cowpea*


foreach v of varlist $empty_vars{
	replace `v'=.
}

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
ren household_id2 hhid 
gen hhid_panel = hhid
lab var hhid_panel "Panel HH identifier" 
gen geography = "Ethiopia"
gen survey = "LSMS-ISA" 
gen year = "2013-14"
gen instrument = 22
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
saveold "${Ethiopia_ESS_W2_final_data}/Ethiopia_ESS_W2_household_variables.dta", replace




********************************************************************************
*INDIVIDUAL-LEVEL VARIABLES
********************************************************************************
use "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_control_income.dta", clear
merge 1:1 household_id2 personid using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_ag_decision.dta", nogen keep(1 3)
merge 1:1 household_id2 personid using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_women_asset.dta", nogen keep(1 3)
merge m:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_male_head.dta", nogen keep(1 3)
merge 1:1 household_id2 personid using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_farmer_fert_use.dta", nogen  keep(1 3)
merge 1:1 household_id2 personid using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_farmer_improvedseed_use.dta", nogen  keep(1 3)
merge 1:1 household_id2 personid using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_farmer_vaccine.dta", nogen  keep(1 3)
merge m:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hhids.dta", nogen
merge 1:1 household_id2 personid using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_land_rights_ind.dta", nogen
recode formal_land_rights_f (.=0) if female==1		// this line will set to zero for all women for whom it is missing (i.e. regardless of ownerhsip status)
la var formal_land_rights_f "Individual has documentation of land rights (at least one plot) - Women only"

*Adding improved seed use by crop 
foreach cn in $topcropname_area {
	merge 1:1 household_id2 personid using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_farmer_improvedseed_use_`cn'.dta", nogen
}

ren mem_age age
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
lab var pw2 "Household weight"
lab var women_control_all_income "Invidual has control over at least one type of income"
lab var women_decision_ag "Invidual makes decision about livestock production activities"
lab var women_asset "Invidual owns an assets (land or livestock)"

*Generate individual adoption indicators
replace all_imprv_seed_use=0 if all_imprv_seed_use==. & farm_manager==1
replace female_imprv_seed_use=0 if female_imprv_seed_use==. & farm_manager==1 & mem_gender==2
replace male_imprv_seed_use=0 if male_imprv_seed_use==. & farm_manager==1 & mem_gender==1
replace all_use_inorg_fert=0 if all_use_inorg_fert==. & farm_manager==1
replace female_use_inorg_fert=0 if female_use_inorg_fert==. & farm_manager==1 & mem_gender==2
replace male_use_inorg_fert=0 if male_use_inorg_fert==. & farm_manager==1 & mem_gender==1
replace all_vac_animal=0 if all_vac_animal==. & livestock_keeper==1
replace female_vac_animal=0 if female_vac_animal==. & livestock_keeper==1 & mem_gender==2
replace male_vac_animal=0 if male_vac_animal==. & livestock_keeper==1 & mem_gender==1
recode control_all_income (.=0)
recode make_decision_ag (.=0)
recode own_asset (.=0)
replace female=1 if mem_gender==2 & female==.
replace female=0 if mem_gender==1 & female==.

*Generating rural codes for individuals
bysort household_id2: egen rural_temp= mean(rural)
replace rural= rural_temp if rural==.
drop rural_temp

*merge in hh variable to determine agricultural household
ren household_id2 hhid
preserve
use "${Ethiopia_ESS_W2_final_data}/Ethiopia_ESS_W2_household_variables.dta", replace
keep hhid ag_hh
tempfile ag_hh
save `ag_hh'
restore
merge m:1 hhid using `ag_hh', nogen keep (1 3)
replace   make_decision_ag =. if ag_hh==0

*getting correct subpopulations (women aged 18 or above in rural households)
recode control_all_income make_decision_ag own_asset formal_land_rights_f (.=0) if female==1 
recode control_all_income make_decision_ag own_asset formal_land_rights_f (nonmissing=.) if female==0
gen women_diet=.
gen  number_foodgroup=.

*Set improved seed adoption to missing if household is not growing crop 
foreach v in $topcropname_area {
	gen female_hybrid_seed_`v' = .
	gen male_hybrid_seed_`v' = .

	foreach g in all male female {
		replace `g'_imprv_seed_`v' =. if `v'_farmer==0 | `v'_farmer==.
		recode `g'_imprv_seed_`v' (.=0) if `v'_farmer==1
		*replace `g'_hybrid_seed_`v' =. if  `v'_farmer==0 | `v'_farmer==.
		*recode `g'_hybrid_seed_`v' (.=0) if `v'_farmer==1
	}		
	replace female_imprv_seed_`v'=. if female==0
	replace male_imprv_seed_`v'=. if female==1
	replace female_hybrid_seed_`v'=. if female==0
	replace male_hybrid_seed_`v'=. if female==1
	replace female_imprv_seed_use=. if female==0
	replace male_imprv_seed_use=. if female==1
	replace female_use_inorg_fert=. if female==0
	replace male_use_inorg_fert=. if female==1
}
	
*create missing crop variables (no cowpea or yam)
foreach x of varlist *maize* {
	foreach c in cowpea {
		gen `x'_xx = .
		ren *maize*_xx *`c'*
	}
}
global empty_vars ""
global empty_vars women_diet number_foodgroup *hybrid_seed* *cowpea*
foreach v of varlist $empty_vars{
	replace `v'=.
}

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
ren personid indid 
gen hhid_panel = hhid
lab var hhid_panel "Panel HH identifier" 
gen geography = "Ethiopia"
gen survey = "LSMS-ISA" 
gen year = "2013-14"
gen instrument = 22
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
save "${Ethiopia_ESS_W2_final_data}/Ethiopia_ESS_W2_individual_variables.dta", replace



********************************************************************************
//     FIELD LEVEL     //
********************************************************************************
use "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_crop_production_field.dta", clear
merge 1:1 household_id2 holder_id parcel_id field_id using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_field_area.dta", nogen keep(1 3)
merge 1:1 household_id2 holder_id parcel_id field_id using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_field_gender_dm.dta", nogen keep(1 3)
merge m:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_male_head.dta", nogen keep(1 3)		// weights
merge m:1 household_id2 using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_hhids.dta", nogen
merge 1:1 household_id2 holder_id parcel_id field_id using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_plot_farmlabor_postplanting.dta", keep (1 3) nogen
merge 1:1 household_id2 holder_id parcel_id field_id using "${Ethiopia_ESS_W2_created_data}/Ethiopia_ESS_W2_plot_farmlabor_postharvest.dta", keep (1 3) nogen
egen  labor_total =rowtotal(days_hired_postplant days_famlabor_postplant days_otherlabor_postplant days_hired_postharvest days_famlabor_postharvest days_otherlabor_postharvest)
keep holder_id- pw2 cultivated region zone woreda zonename woredaname dm_gender fhh clusterid- household area_meas_hectares days_hired_postplant days_famlabor_postplant days_otherlabor_postplant days_hired_postharvest days_famlabor_postharvest days_otherlabor_postharvest labor_total
drop  if area_meas_hectares==0 | area_meas_hectares==. | value_crop_production_field==0
ren value_crop_production_field plot_value_harvest

*Winsorize area_meas_hectares and labor_total at top and bottom 1%
keep if cultivated==1
global winsorize_vars area_meas_hectares  labor_total  
foreach p of global winsorize_vars { 
	gen w_`p' =`p'
	local l`p' : var lab `p'
	_pctile w_`p'   [aw=weight] if w_`p'!=0 , p(1 99)    
	replace w_`p' = r(r1) if w_`p' < r(r1)  & w_`p'!=. & w_`p'!=0
	replace w_`p' = r(r2) if w_`p' > r(r2)  & w_`p'!=.
	lab var w_`p' "`l`p'' - Winsorized top and bottom 1%"
}
 
*Winsorize plot_value_harvest at top  1% only 
_pctile plot_value_harvest  [aw=weight] , p($wins_upper_thres)  
gen w_plot_value_harvest=plot_value_harvest
replace w_plot_value_harvest = r(r1) if w_plot_value_harvest > r(r1) & w_plot_value_harvest != . 
lab var w_plot_value_harvest "Value of crop harvest on this plot - Winsorized top 1%"

*Generate land and labor productivity using winsorized values
gen plot_productivity = w_plot_value_harvest/ w_area_meas_hectares
lab var plot_productivity "Plot productivity Value production/hectare"
gen plot_labor_prod = w_plot_value_harvest/w_labor_total  	
lab var plot_labor_prod "Plot labor productivity (value production/labor-day)"

*Winsorize both land and labor productivity at top 1% only
gen plot_weight=w_area_meas_hectares*weight 	//generate plot weights using winsorized values for area_meas_hectares
lab var plot_weight "Weight for plots (weighted by plot area)"
foreach v of varlist  plot_productivity  plot_labor_prod {
	_pctile `v' [aw=plot_weight] , p($wins_upper_thres)  
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top 1%"
}	
	
*Convert monetary values to USD and PPP
global monetary_val plot_value_harvest plot_productivity  plot_labor_prod 
foreach p of global monetary_val {
	gen `p'_usd=(1+$Ethiopia_ESS_W2_inflation) * `p' / $Ethiopia_ESS_W2_exchange_rate
	gen `p'_1ppp=(1+$Ethiopia_ESS_W2_inflation) * `p' / $Ethiopia_ESS_W2_cons_ppp_dollar
	gen `p'_2ppp=(1+$Ethiopia_ESS_W2_inflation) * `p' / $Ethiopia_ESS_W2_gdp_ppp_dollar
	gen `p'_loc = (1+$Ethiopia_ESS_W2_inflation) * `p' 
	local l`p' : var lab `p' 
	lab var `p'_1ppp "`l`p'' (2016 $ Private Consumption PPP)"
	lab var `p'_2ppp "`l`p'' (2016 $ GDP PPP)"
	lab var `p'_usd "`l`p'' (2016 $ USD)"
	lab var `p'_loc "`l`p'' (2016 ETB)"
	lab var `p' "`l`p'' (ETB)" 
	
	gen w_`p'_usd=(1+$Ethiopia_ESS_W2_inflation) * w_`p' / $Ethiopia_ESS_W2_exchange_rate
	gen w_`p'_1ppp=(1+$Ethiopia_ESS_W2_inflation) * w_`p' / $Ethiopia_ESS_W2_cons_ppp_dollar
	gen w_`p'_2ppp=(1+$Ethiopia_ESS_W2_inflation) * `p' / $Ethiopia_ESS_W2_gdp_ppp_dollar
	gen w_`p'_loc = (1+$Ethiopia_ESS_W2_inflation) * w_`p' 
	local lw_`p' : var lab w_`p' 
	lab var w_`p'_1ppp "`lw_`p'' (2016 $ Private Consumption  PPP)"
	lab var w_`p'_2ppp "`l`p'' (2016 $ GDP PPP)"
	lab var w_`p'_usd "`lw_`p'' (2016 $ USD)"
	lab var w_`p'_loc "`lw_`p'' (2016 ETB)"
	lab var w_`p' "`lw_`p'' (ETB)" 
}

*We are reporting two variants of gender-gap
* mean difference in log productivitity without and with controls (plot size and region/state)
* both can be obtained using a simple regression.
* use clustered standards errors
qui svyset clusterid [pweight=plot_weight], strata(strataid) singleunit(centered) 	// get standard errors of the mean
* SIMPLE MEAN DIFFERENCE
gen male_dummy=dm_gender==1  if  dm_gender!=3 & dm_gender!=.	//generate dummy equals to 1 if plot managed by male only and 0 if managed by female only


*Gender-gap 1a 
gen lplot_productivity_usd=ln(w_plot_productivity_usd) //use winsorized values to report gender gap
gen larea_meas_hectares=ln(w_area_meas_hectares)
svy, subpop(  if rural==1 ): reg  lplot_productivity_usd male_dummy 
matrix b1a=e(b)
gen gender_prod_gap1a=100*el(b1a,1,1)
sum gender_prod_gap1a
lab var gender_prod_gap1a "Gender productivity gap (%) - regression in logs with no controls"
matrix V1a=e(V)
gen segender_prod_gap1a= 100*sqrt(el(V1a,1,1)) 
sum segender_prod_gap1a
lab var segender_prod_gap1a "SE Gender productivity gap (%) - regression in logs with no controls"

*Gender-gap 1b
svy, subpop(  if rural==1 ): reg  lplot_productivity_usd male_dummy larea_meas_hectares i.region
matrix b1b=e(b)
gen gender_prod_gap1b=100*el(b1b,1,1)
sum gender_prod_gap1b
lab var gender_prod_gap1b "Gender productivity gap (%) - regression in logs with controls"
matrix V1b=e(V)
gen segender_prod_gap1b= 100*sqrt(el(V1b,1,1)) 
sum segender_prod_gap1b
lab var segender_prod_gap1b "SE Gender productivity gap (%) - regression in logs with controls"
lab var lplot_productivity_usd "Log Value of crop production per hectare"
foreach i in 1ppp 2ppp loc{
	gen w_plot_productivity_all_`i'=w_plot_productivity_`i'
	gen w_plot_productivity_female_`i'=w_plot_productivity_`i' if dm_gender==2
	gen w_plot_productivity_male_`i'=w_plot_productivity_`i' if dm_gender==1
	gen w_plot_productivity_mixed_`i'=w_plot_productivity_`i' if dm_gender==3
}
gen plot_labor_weight= w_labor_total*weight
foreach i in 1ppp 2ppp loc{
	gen w_plot_labor_prod_all_`i'=w_plot_labor_prod_`i'
	gen w_plot_labor_prod_female_`i'=w_plot_labor_prod_`i' if dm_gender==2
	gen w_plot_labor_prod_male_`i'=w_plot_labor_prod_`i' if dm_gender==1
	gen w_plot_labor_prod_mixed_`i'=w_plot_labor_prod_`i' if dm_gender==3
}

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
ren household_id2 hhid 
gen hhid_panel = hhid
ren field_id plot_id
lab var hhid_panel "panel hh identifier" 
gen geography = "Ethiopia"
gen survey = "LSMS-ISA" 
gen year = "2013-14"
gen instrument = 22
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
saveold "${Ethiopia_ESS_W2_final_data}/Ethiopia_ESS_W2_field_plot_variables.dta", replace


********************************************************************************
*SUMMARY STATISTICS
******************************************************************************** 
/*
All the pre-processed files include all households, individuals, and plots in the sample. 
The summary statistics are outputted only for the sub_population of households, individuals, and plots in rural areas. 
The code for outputting the summary statistics is in a separare dofile that is called here
*/ 
*Parameters
global list_instruments  "Ethiopia_ESS_W2"
do "${directory}/_Summary_statistics/EPAR_UW_335_SUMMARY_STATISTICS_02.08.24.do" 
