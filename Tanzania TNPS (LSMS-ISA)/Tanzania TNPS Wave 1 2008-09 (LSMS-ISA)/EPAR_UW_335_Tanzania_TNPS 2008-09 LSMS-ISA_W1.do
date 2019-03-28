
/*-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of a set of agricultural development indicators 
				  using the Tanzania National Panel Survey (TNPS) LSMS-ISA Wave 1 (2008-09)
*Author(s)		: Didier Alia, Pierre Biscaye, David Coomes, Jack Knauer, Josh Merfeld,  
				  Isabella Sun, Chelsea Sweeney, Emma Weaver, Ayala Wineman, 
				  C. Leigh Anderson, &  Travis Reynolds

*Acknowledgments: We acknowledge the helpful contributions of members of the World Bank's LSMS-ISA team, the FAO's RuLIS team, IFPRI, IRRI, 
				  and the Bill & Melinda Gates Foundation Agricultural Development Data and Policy team in discussing indicator construction decisions. 
				  All coding errors remain ours alone.
*Date			: 19 February 2019

----------------------------------------------------------------------------------------------------------------------------------------------------*/


*Data source
*-----------
*The Tanzania National Panel Survey was collected by the Tanzania National Bureau of Statistics (NBS) 
*and the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture(LSMS - ISA)
*The data were collected over the period October 2008 - September 2009.
*All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
*http://microdata.worldbank.org/index.php/catalog/76

*Throughout the do-file, we sometimes use the shorthand LSMS to refer to the Tanzania National Panel Survey.


*Summary of Executing the Master do.file
*-----------
*This Master do.file constructs selected indicators using the Tanzania TNPS (TZA LSMS) data set.
*Using data files from within the "Tanzania TNPS - LSMS-ISA - Wave 1 (2008-09)" folder within the "Raw DTA files" folder, 
*the do.file first constructs common and intermediate variables, saving dta files when appropriate 
*in the folder "\Tanzania TNPS - LSMS-ISA - Wave 1 (2008-09)\created_data" within the "Final DTA files" folder.
*These variables are then brought together at the household, plot, or individual level, saving dta files at each level when available 
*in the folder "Tanzania TNPS - LSMS-ISA - Wave 1 (2008-09)" within the "Final DTA files" folder.

*The processed files include all households, individuals, and plots in the sample.
*Toward the end of the do.file, a block of code estimates summary statistics (mean, standard error of the mean, minimum, first quartile, median, third quartile, maximum) 
*of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager.
*The results are outputted in the excel file "Tanzania_NPS_LSMS_ISA_W1_summary_stats.xlsx" in the "Tanzania TNPS - LSMS-ISA - Wave 1 (2008-09)" within the "Final DTA files" folder.
*It is possible to modify the condition  "if rural==1" in the portion of code following the heading "SUMMARY STATISTICS" to generate all summary statistics for a different sub_population.

*The following refer to running this Master do.file with EPAR's cleaned data files. Information on EPAR's cleaning and construction decisions is available in the documents
*"EPAR_UW_335_Indicator Construction Summary Tables" and "EPAR_UW_335_General Considerations and Principles for Indicator Construction.docx" within the folder "Supporting documents".

 
/*OUTLINE OF THE DO.FILE
Below are the list of the main files created by running this Master do.file
 					
*INTERMEDIATE FILES					MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD IDS						Tanzania_NPS_LSMS_ISA_W1_hhids.dta
*INDIVIDUAL IDS						Tanzania_NPS_LSMS_ISA_W1_person_ids.dta
*HOUSEHOLD SIZE						Tanzania_NPS_LSMS_ISA_W1_hhsize.dta
*PARCEL AREAS						Tanzania_NPS_LSMS_ISA_W1_plot_areas.dta
*PLOT-CROP DECISION MAKERS			Tanzania_NPS_LSMS_ISA_W1_plot_decision_makers.dta
*TLU (Tropical Livestock Units)		Tanzania_NPS_LSMS_ISA_W1_TLU_Coefficients.dta

*GROSS CROP REVENUE					Tanzania_NPS_LSMS_ISA_W1_tempcrop_harvest.dta
									Tanzania_NPS_LSMS_ISA_W1_tempcrop_sales.dta
									Tanzania_NPS_LSMS_ISA_W1_permcrop_harvest.dta
									Tanzania_NPS_LSMS_ISA_W1_permcrop_sales.dta
									Tanzania_NPS_LSMS_ISA_W1_hh_crop_production.dta
									Tanzania_NPS_LSMS_ISA_W1_plot_cropvalue.dta
									Tanzania_NPS_LSMS_ISA_W1_parcel_cropvalue.dta
									Tanzania_NPS_LSMS_ISA_W1_crop_residues.dta
									Tanzania_NPS_LSMS_ISA_W1_hh_crop_prices.dta
									Tanzania_NPS_LSMS_ISA_W1_crop_losses.dta
*CROP EXPENSES						Tanzania_NPS_LSMS_ISA_W1_wages_mainseason.dta
									Tanzania_NPS_LSMS_ISA_W1_wages_shortseason.dta
									
									Tanzania_NPS_LSMS_ISA_W1_fertilizer_costs.dta
									Tanzania_NPS_LSMS_ISA_W1_seed_costs.dta
									Tanzania_NPS_LSMS_ISA_W1_land_rental_costs.dta
									Tanzania_NPS_LSMS_ISA_W1_asset_rental_costs.dta
									Tanzania_NPS_LSMS_ISA_W1_transportation_cropsales.dta
									
*CROP INCOME						Tanzania_NPS_LSMS_ISA_W1_crop_income.dta
									
*LIVESTOCK INCOME					Tanzania_NPS_LSMS_ISA_W1_livestock_products.dta
									Tanzania_NPS_LSMS_ISA_W1_livestock_expenses.dta
									Tanzania_NPS_LSMS_ISA_W1_hh_livestock_products.dta
									Tanzania_NPS_LSMS_ISA_W1_livestock_sales.dta
									Tanzania_NPS_LSMS_ISA_W1_TLU.dta
									Tanzania_NPS_LSMS_ISA_W1_livestock_income.dta

*FISH INCOME						Tanzania_NPS_LSMS_ISA_W1_fishing_expenses_1.dta
									Tanzania_NPS_LSMS_ISA_W1_fishing_expenses_2.dta
									Tanzania_NPS_LSMS_ISA_W1_fish_income.dta
																
*SELF-EMPLOYMENT INCOME				Tanzania_NPS_LSMS_ISA_W1_self_employment_income.dta
									Tanzania_NPS_LSMS_ISA_W1_agproducts_profits.dta
									Tanzania_NPS_LSMS_ISA_W1_fish_trading_revenue.dta
									Tanzania_NPS_LSMS_ISA_W1_fish_trading_other_costs.dta
									Tanzania_NPS_LSMS_ISA_W1_fish_trading_income.dta
									
*WAGE INCOME						Tanzania_NPS_LSMS_ISA_W1_wage_income.dta
									Tanzania_NPS_LSMS_ISA_W1_agwage_income.dta
*OTHER INCOME						Tanzania_NPS_LSMS_ISA_W1_other_income.dta
									Tanzania_NPS_LSMS_ISA_W1_land_rental_income.dta

*FARM SIZE / LAND SIZE				Tanzania_NPS_LSMS_ISA_W1_land_size.dta
									Tanzania_NPS_LSMS_ISA_W1_farmsize_all_agland.dta
									Tanzania_NPS_LSMS_ISA_W1_land_size_all.dta
*FARM LABOR							Tanzania_NPS_LSMS_ISA_W1_farmlabor_mainseason.dta
									Tanzania_NPS_LSMS_ISA_W1_farmlabor_shortseason.dta
									Tanzania_NPS_LSMS_ISA_W1_family_hired_labor.dta
*VACCINE USAGE						Tanzania_NPS_LSMS_ISA_W1_vaccine.dta
*USE OF INORGANIC FERTILIZER		Tanzania_NPS_LSMS_ISA_W1_fert_use.dta
*USE OF IMPROVED SEED				Tanzania_NPS_LSMS_ISA_W1_improvedseed_use.dta

*REACHED BY AG EXTENSION			Tanzania_NPS_LSMS_ISA_W1_any_ext.dta
*USE OF FORMAL FINANACIAL SERVICES	Tanzania_NPS_LSMS_ISA_W1_fin_serv.dta
*GENDER PRODUCTIVITY GAP 			Tanzania_NPS_LSMS_ISA_W1_gender_productivity_gap.dta
*MILK PRODUCTIVITY					Tanzania_NPS_LSMS_ISA_W1_milk_animals.dta
*EGG PRODUCTIVITY					Tanzania_NPS_LSMS_ISA_W1_eggs_animals.dta

*CROP PRODUCTION COSTS PER HECTARE	Tanzania_NPS_LSMS_ISA_W1_hh_cost_land.dta
									Tanzania_NPS_LSMS_ISA_W1_hh_cost_inputs_lrs.dta
									Tanzania_NPS_LSMS_ISA_W1_hh_cost_inputs_srs.dta
									Tanzania_NPS_LSMS_ISA_W1_hh_cost_seed_lrs.dta
									Tanzania_NPS_LSMS_ISA_W1_hh_cost_seed_srs.dta		
									Tanzania_NPS_LSMS_ISA_W1_cropcosts_perha.dta

*RATE OF FERTILIZER APPLICATION		Tanzania_NPS_LSMS_ISA_W1_fertilizer_application.dta
*HOUSEHOLD'S DIET DIVERSITY SCORE	Tanzania_NPS_LSMS_ISA_W1_household_diet.dta
*WOMEN'S CONTROL OVER INCOME		Tanzania_NPS_LSMS_ISA_W1_control_income.dta
*WOMEN'S AG DECISION-MAKING			Tanzania_NPS_LSMS_ISA_W1_make_ag_decision.dta
*WOMEN'S ASSET OWNERSHIP			Tanzania_NPS_LSMS_ISA_W1_ownasset.dta
*AGRICULTURAL WAGES					Tanzania_NPS_LSMS_ISA_W1_ag_wage.dta
*CROP YIELDS						Tanzania_NPS_LSMS_ISA_W1_yield_hh_crop_level.dta

*FINAL FILES						MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD VARIABLES				Tanzania_NPS_LSMS_ISA_W1_household_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			Tanzania_NPS_LSMS_ISA_W1_individual_variables.dta	
*PLOT-LEVEL VARIABLES				Tanzania_NPS_LSMS_ISA_W1_gender_productivity_gap.dta
*SUMMARY STATISTICS					Tanzania_NPS_LSMS_ISA_W1_summary_stats.xlsx
*/


clear
clear matrix 
clear mata 
set more off
set maxvar 8000

//set directories
*These paths correspond to the folders where the raw data files are located and where the created data and final data will be stored.
global TZA_W1_raw_data 	"\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\335 - Ag Team Data Support\Waves\Tanzania\Tanzania TNPS Wave 1 2012-13 (LSMS-ISA)\Raw DTA Files"
global TZA_W1_created_data "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\335 - Ag Team Data Support\Waves\Tanzania\Tanzania TNPS Wave 1 2012-13 (LSMS-ISA)\Final DTA Files\created_data"
global TZA_W1_final_data  	"\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\335 - Ag Team Data Support\Waves\Tanzania\Tanzania TNPS Wave 1 2012-13 (LSMS-ISA)\Final DTA Files\"


************************
*EXCHANGE RATE AND INFLATION FOR CONVERSION IN SUD IDS
************************
global NPS_LSMS_ISA_W1_exchange_rate 2158
global NPS_LSMS_ISA_W1_gdp_ppp_dollar 686.367     // https://data.worldbank.org/indicator/PA.NUS.PPP
global NPS_LSMS_ISA_W1_cons_ppp_dollar 809.32	 // https://data.worldbank.org/indicator/PA.NUS.PRVT.PP
global NPS_LSMS_ISA_W1_inflation 0.76433121  // inflation rate 2009-2016. Data was collected during Oct 2008- Sep 2009. We want to adjust value to 2016

************************
*HOUSEHOLD IDS 
************************
use "${TZA_W1_raw_data}\Household\SEC_A_T.dta", clear
rename hh_weight_trimmed weight
ren rural oldrural
gen rural=oldrural=="Rural"
keep hhid region district ward ea rural weight strataid clusterid
lab var rural "1=Household lives in a rural area"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hhids.dta", replace


************************
*INDIVIDUAL IDS
************************
use "${TZA_W1_raw_data}\Household\SEC_B_C_D_E1_F_G1_U.dta", clear
keep hhid sbmemno sbq2 sbq4 sbq5
gen female=sbq2==2 
lab var female "1= indivdual is female"
gen age=sbq4
lab var age "Indivdual age"
gen hh_head=sbq5==1 
lab var hh_head "1= individual is household head"
drop sbq2 sbq4 sbq5
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_person_ids.dta", replace
 
 
 
************************
*HOUSEHOLD SIZE
************************
use "${TZA_W1_raw_data}\Household\SEC_B_C_D_E1_F_G1_U.dta", clear
gen hh_members = 1
rename sbq5 relhead 
rename sbq2 gender
gen fhh = (relhead==1 & gender==2)
collapse (sum) hh_members (max) fhh, by (hhid)
lab var hh_members "Number of household members"
lab var fhh "1= Female-headed household"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hhsize.dta", replace



************************
*PLOT AREAS
************************
use "${TZA_W1_raw_data}\Agriculture\SEC_2A.dta", clear
append using "${TZA_W1_raw_data}\Agriculture\SEC_2B.dta"
rename plotnum plot_id
gen area_acres_est = s2aq4
replace area_acres_est = s2bq9 if area_acres_est==.
gen area_acres_meas = area
keep if area_acres_est !=.
keep hhid plot_id area_acres_est area_acres_meas
lab var area_acres_meas "Plot are in acres (GPSd)"
lab var area_acres_est "Plot area in acres (estimated)"
gen area_est_hectares=area_acres_est* (1/2.47105)  
gen area_meas_hectares= area_acres_meas* (1/2.47105)
lab var area_meas_hectares "Plot are in hectares (GPSd)"
lab var area_est_hectares "Plot area in hectares (estimated)"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_plot_areas.dta", replace



************************
*PLOT DECISION MAKERS
************************
use "${TZA_W1_raw_data}/Household/SEC_B_C_D_E1_F_G1_U.dta", clear
ren sbmemno personid			// personid is the roster number, combination of household_id2 and personid are unique id for this wave
gen female =sbq2==2
gen age = sbq4
gen head = sbq5==1 if sbq5!=.
keep personid female age hhid head
lab var female "1=Individual is a female"
lab var age "Individual age"
lab var head "1=Individual is the head of household"
save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_gender_merge.dta", replace

use "${TZA_W1_raw_data}/Agriculture/SEC_3A.dta", clear
drop if plotnum==""
gen cultivated = s3aq3==1
gen season=1
append using "${TZA_W1_raw_data}/Agriculture/SEC_3B.dta"
replace season=2 if season==.
drop if plotnum==""
drop if s3bq3==. & s3aq3==.
drop if hhid == "51020010120086" & plotnum == "M1" & season == 2 //duplicate plots in 3A and 3B 
drop if hhid == "51020010120089" & plotnum == "M1" & season == 2 //duplicate plots in 3A and 3B 
replace cultivated = 1 if  s3bq3==1 
*Gender/age variables
gen personid = s3aq6_1
replace personid = s3bq6_1 if personid==. &  s3bq6_1!=.
merge m:1 hhid personid using  "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_gender_merge.dta", gen(dm1_merge) keep(1 3)		// Dropping unmatched from using

*First decision-maker variables
gen dm1_female = female
drop female personid
*Second owner
gen personid = s3aq6_2
replace personid = s3bq6_2 if personid==. &  s3bq6_2!=.
merge m:1 hhid personid using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_gender_merge.dta", gen(dm2_merge) keep(1 3)		// Dropping unmatched from using
gen dm2_female = female
drop female personid
*Third
gen personid = s3aq6_3
replace personid =s3bq6_3 if personid==. &  s3bq6_3!=.
merge m:1 hhid personid using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_gender_merge.dta", gen(dm3_merge) keep(1 3)		// Dropping unmatched from using
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
merge m:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hhsize.dta", nogen 								// all matched
replace dm_gender = 1 if fhh==0 & dm_gender==.
replace dm_gender = 2 if fhh==1 & dm_gender==.
ren plotnum plot_id 
drop if  plot_id==""
keep hhid plot_id dm_gender cultivated  
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_plot_decision_makers.dta", replace

************************
*MONOCROPPED PLOTS
************************
global topcropname_area "maize rice wheat sorgum pmill cowpea grdnt beans yam swtptt cassav banana cotton sunflr pigpea"
global topcrop_area "11 12 16 13 14 32 43 31 24 22 21 71 50 41 34"
global comma_topcrop_area "11, 12, 16, 13, 14, 32, 43, 31, 24, 22, 21, 71, 50, 41, 34"

// Loop through each of the crops above (change '15' to the number of 
// crops in this wave) 
forvalues k=1(1)15 {
	// Load the data on crops
	use "${TZA_W1_raw_data}/Agriculture/SEC_4A.dta", clear
	append using "${TZA_W1_raw_data}/Agriculture/SEC_6A.dta"
	append using "${TZA_W1_raw_data}/Agriculture/SEC_4B.dta", gen(short)
	append using "${TZA_W1_raw_data}/Agriculture/SEC_6B.dta"
	recode short (.=1)
	drop if plotnum==""
	// Standardize plotnum to plot_id to match with other countries
	ren plotnum plot_id

	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	//Create KGs Harvested for the current crop
	gen kgs_harv_mono_`cn' = s4aq15 if zaocode==`c'
	replace kgs_harv_mono_`cn' = s4bq15 if zaocode==`c' & short==1
	// Needed to capture kgs_harvested for bananas
	replace kgs_harv_mono_`cn' = s6aq8 if zaocode==`c' & kgs_harv_mono==.
	// Needed to capture kgs_harvested for cassava
	replace kgs_harv_mono_`cn' = s6bq8 if zaocode==`c' & kgs_harv_mono==.

	// to a single variable across different dta files
	replace s4aq3 = s4bq3 if s4aq3==.
	replace s4aq4 = s4bq4 if s4aq3==.
	replace s6aq5 = s6bq5 if s6aq5==.

	// Set the percent of plot planted with crop cn for standard crops
	gen percent_`cn' = 1 if s4aq3==1
	// and now for cassava and banana (permanent crops) replace with 
	// zaocodes for permanent crops
	replace percent_`cn' = 1 if s6aq5==1 & (zaocode==21 | zaocode==71)

	// - Including permanent crops (cassava and banana) here we just want to keep the observations if they are the only crop planted on the plot - we
	// we don't actually care about the percent planted because this instrument doesn't report percent planted. Only report yield for annual crops!
	replace percent_`cn' = 0.25*(s4aq4==1) + 0.5*(s4aq4==2) + /*
	*/ 0.75*(s4aq4==3) if percent_`cn'==. & zaocode==`c'
	
	//- Create dummy variables for each of the different zaocodes. 
	xi i.zaocode, noomit
	
	collapse (sum) kgs_harv_mono_`cn' (max) _Izaocode_* percent_`cn', by(hhid /*
	*/ plot_id short)
	egen crop_count = rowtotal(_Izaocode_*)
	keep if crop_count==1 & _Izaocode_`c'==1

	//  Merge in the information about plot areas constructed earlier in the
	// do file
	merge m:1 hhid plot_id using /*
	*/"${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_plot_areas.dta", nogen /* 
	*/assert (2 3) keep(3)
	replace area_meas_hectares=. if area_meas_hectares==0
	// Use area estimated if there is no value for area measured. 
	replace area_meas_hectares = area_est_hectares if area_meas_hectares==.

	// Create a new measurement which is the hectares of the crop in question
	// planted on each plot
	gen `cn'_monocrop_ha = area_meas_hectares * percent_`cn'
	// Get rid of any plots which do not involve this particular monocrop
	drop if `cn'_monocrop_ha == 0

	save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_`cn'_monocrop.dta", /*
	*/replace
}

// This section disaggregates based on Gender of the head of household. 
// Change the value of 15 based on the number of crops in your list
forvalues k=1(1)15 {
	local c : word `k' of $topcrop_area
	local cn: word `k' of $topcropname_area
	use "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_`cn'_monocrop.dta", clear
	merge m:1 hhid plot_id using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_plot_decision_makers.dta"

	// This loop creates 6 variables for each monocropped plot which are 
	// the number of hectares for of the crop disaggregated by the gender of the
	// plot manager and the number of kilograms harvested by gender of the plot 
	// manager. 
	foreach i in `cn'_monocrop_ha kgs_harv_mono_`cn' { 
		gen `i'_male = `i' if dm_gender==1
		gen `i'_female = `i' if dm_gender==2
		gen `i'_mixed = `i' if dm_gender==3
		replace `i'_male = . if dm_gender!=1
		replace `i'_female = . if dm_gender!=2
		replace `i'_mixed = . if dm_gender!=3
	}

	gen `cn'_monocrop_male = 0 
	replace `cn'_monocrop_male=1 if dm_gender==1
	gen `cn'_monocrop_female = 0 
	replace `cn'_monocrop_female=1 if dm_gender==2
	gen `cn'_monocrop_mixed = 0 
	replace `cn'_monocrop_mixed=1 if dm_gender==3

	// This collapse will indicate whether the HOUSEHOLD has at least one of 
	// these plots and the total area of the monocropped plots for each top crop
	collapse (sum) `cn'_monocrop_ha* kgs_harv_mono_`cn'* (max) `cn'_monocrop_male `cn'_monocrop_female `cn'_monocrop_mixed `cn'_monocrop = _Izaocode_`c', by (hhid)

	foreach i in male female mixed {
		replace `cn'_monocrop_ha = . if `cn'_monocrop != 1
		replace `cn'_monocrop_ha_`i' = . if `cn'_monocrop != 1
		replace `cn'_monocrop_ha_`i' = . if `cn'_monocrop_`i' == 0
		replace `cn'_monocrop_ha_`i' = . if `cn'_monocrop_ha_`i' == 0
		replace kgs_harv_mono_`cn' = . if `cn'_monocrop != 1
		replace kgs_harv_mono_`cn'_`i' = . if `cn'_monocrop != 1
		replace kgs_harv_mono_`cn'_`i' = . if `cn'_monocrop_`i' == 0
		replace kgs_harv_mono_`cn'_`i' = . if `cn'_monocrop_ha_`i' == 0
	}
	save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_`cn'_monocrop_hh_area.dta", replace

}

************************
*TLU (Tropical Livestock Units)
************************
use "${TZA_W1_raw_data}\Agriculture\SEC_10A.dta", clear
*Rename animal livestock_code_tanz_lsms
gen tlu_coefficient=0.5 if (animal==1|animal==2|animal==3|animal==4|animal==5|animal==6|animal==13)
replace tlu_coefficient=0.1 if (animal==7|animal==8)
replace tlu_coefficient=0.2 if (animal==9)
replace tlu_coefficient=0.01 if (animal==10|animal==11|animal==12)
replace tlu_coefficient=0.3 if (animal==14)
lab var tlu_coefficient "Tropical Livestock Unit coefficient"

*Owned
drop if animal==15
rename animal livestock_code
gen cattle=inlist(livestock_code,1,2,3,4,5,6)
gen smallrum=inlist(livestock_code,7,8,9)
gen poultry=inlist(livestock_code,10,11,12,13)
gen other_ls=inlist(livestock_code,14,15,16)

ren s10aq3 nb_ls_1yearago
gen nb_cattle_1yearago=nb_ls_1yearago if cattle==1 
gen nb_smallrum_1yearago=nb_ls_1yearago if smallrum==1 
gen nb_poultry_1yearago=nb_ls_1yearago if poultry==1 
gen nb_other_ls_1yearago=nb_ls_1yearago if other_ls==1 
egen nb_ls_today= rowtotal(s10aq4_1 s10aq4_2 s10aq4_3)
gen nb_cattle_today=nb_ls_today if cattle==1 
gen nb_smallrum_today=nb_ls_today if smallrum==1 
gen nb_poultry_today=nb_ls_today if poultry==1 
gen nb_other_ls_today=nb_ls_today if other_ls==1  
gen tlu_1yearago = nb_ls_1yearago * tlu_coefficient
gen tlu_today = nb_ls_today * tlu_coefficient
rename s10aq9 income_live_sales 
rename s10aq8 number_sold 

recode  tlu_* nb_* (.=0)
collapse (sum) tlu_* nb_*  , by (hhid)
lab var nb_cattle_1yearago "Number of cattle owned as of 12 months ago"
lab var nb_smallrum_1yearago "Number of small ruminant owned as of 12 months ago"
lab var nb_poultry_1yearago "Number of cattle poultry as of 12 months ago"
lab var nb_other_ls_1yearago "Number of other livestock (dog, donkey, and other) owned as of 12 months ago"
lab var nb_cattle_today "Number of cattle owned as of the time of survey"
lab var nb_smallrum_today "Number of small ruminant owned as of the time of survey"
lab var nb_poultry_today "Number of cattle poultry as of the time of survey"
lab var nb_other_ls_today "Number of other livestock (dog, donkey, and other) owned as of the time of survey"
lab var tlu_1yearago "Tropical Livestock Units as of 12 months ago"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
lab var nb_ls_1yearago  "Number of livestock owned as of 12 months ago"
lab var nb_ls_1yearago  "Number of livestock owned as of 12 months ago"
lab var nb_ls_today "Number of livestock owned as of today"
drop tlu_coefficient
drop if hhid==""
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_TLU_Coefficients.dta", replace

************************
*GROSS CROP REVENUE
************************
*Temporary crops (both seasons)
use "${TZA_W1_raw_data}\Agriculture\SEC_4A.dta", clear
append using "${TZA_W1_raw_data}\Agriculture\SEC_4B.dta"
drop if plotnum==""
rename zaocode crop_code 
rename plotnum plot_id
rename s4aq1 harvest_yesno
replace harvest_yesno = s4bq1 if harvest_yesno==.		
rename s4aq15 kgs_harvest
replace kgs_harvest = s4bq15 if kgs_harvest==.
rename s4aq16 value_harvest
replace value_harvest = s4bq16 if value_harvest==.
replace kgs_harvest = 0 if harvest_yesno==2
replace value_harvest = 0 if harvest_yesno==2
collapse (sum) kgs_harvest value_harvest, by (hhid crop_code plot_id)
lab var kgs_harvest "Kgs harvested of this crop, summed over main and short season"				
lab var value_harvest "Value harvested of this crop, summed over main and short season"			
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_tempcrop_harvest.dta", replace

use "${TZA_W1_raw_data}\Agriculture\SEC_5A.dta", clear
append using "${TZA_W1_raw_data}\Agriculture\SEC_5B.dta"
drop if zaocode==.
rename zaocode crop_code
rename s5aq1 sell_yesno
replace sell_yesno = s5bq1 if sell_yesno==.
rename s5aq2 quantity_sold
replace quantity_sold = s5bq2 if quantity_sold==.
rename s5aq3 value_sold
replace value_sold = s5bq3 if value_sold==.
keep if sell_yesno==1
drop if hhid == "20030030020400" & crop_code == 21 // Cassava belongs in permanent crops
drop if hhid == "08020190010349" & crop_code == 21 // Cassava belongs in permanent crops
drop if hhid == "08010060090297" & crop_code == 21 // Cassava belongs in permanent crops
drop if hhid == "04030090030399" & crop_code == 21 // Cassava belongs in permanent crops
drop if hhid == "08060120010003" & crop_code == 45 // Coconut belongs in permanent crops
drop if hhid == "10010030040181" & crop_code == 46 // Cashewnut belongs in permanent crops
drop if hhid == "08050060020136" & crop_code == 46 // Cashewnut belongs in permanent crops
drop if hhid == "08010160070015" & crop_code == 46 // Cashewnut belongs in permanent crops
drop if hhid == "04030090030399" & crop_code == 71 // Banana belongs in permanent crops
drop if hhid == "03010060030193" & crop_code == 71 // Banana belongs in permanent crops
drop if hhid == "03010060030044" & crop_code == 71 // Banana belongs in permanent crops
collapse (sum) quantity_sold value_sold, by (hhid crop_code)
lab var quantity_sold "Kgs sold of this crop, summed over main and short season"		
lab var value_sold "Value sold of this crop, summed over main and short season"			
gen price_kg = value_sold / quantity_sold
lab var price_kg "Price per kg sold"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_tempcrop_sales.dta", replace

*Permanent and tree crops
use "${TZA_W1_raw_data}\Agriculture\SEC_6A.dta", clear
append using "${TZA_W1_raw_data}\Agriculture\SEC_6B.dta"
drop if plotnum==""
rename zaocode crop_code
rename s6aq8 kgs_harvest
rename plotnum plot_id
replace kgs_harvest = s6bq8 if kgs_harvest==.
collapse (sum) kgs_harvest, by (hhid crop_code plot_id)								
lab var kgs_harvest "Kgs harvested of this crop, summed over main and short season"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_permcrop_harvest.dta", replace

use "${TZA_W1_raw_data}\Agriculture\SEC_7A.dta", clear
append using "${TZA_W1_raw_data}\Agriculture\SEC_7B.dta"
drop if zaocode==.
rename zaocode crop_code
rename s7aq2 sell_yesno
replace sell_yesno = s7bq2 if sell_yesno==.
rename s7aq3 quantity_sold
replace quantity_sold = s7bq3 if quantity_sold==.
rename s7aq4 value_sold
replace value_sold = s7bq4 if value_sold==.
keep if sell_yesno==1
recode quantity_sold value_sold (.=0)
collapse (sum) quantity_sold value_sold, by (hhid crop_code)
lab var quantity_sold "Kgs sold of this crop, summed over main and short season"
lab var value_sold "Value sold of this crop, summed over main and short season"
gen price_kg = value_sold / quantity_sold
lab var price_kg "Price per kg sold"				
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_permcrop_sales.dta", replace

*Prices of permanent and tree crops need to be imputed from sales.				
use "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_permcrop_sales.dta", clear
append using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_tempcrop_sales.dta"
recode price_kg (0=.)
merge m:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hhids.dta"
drop if _merge==2
drop _merge
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_crop_sales.dta", replace

use "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_crop_sales.dta", clear
gen observation = 1
bys region district ward ea crop_code: egen obs_ea = count(observation)
collapse (median) price_kg [aw=weight], by (region district ward ea crop_code obs_ea)
rename price_kg price_kg_median_ea
lab var price_kg_median_ea "Median price per kg for this crop in the enumeration area"
lab var obs_ea "Number of sales observations for this crop in the enumeration area"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_crop_prices_ea.dta", replace
use "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_crop_sales.dta", clear
gen observation = 1
bys region district ward crop_code: egen obs_ward = count(observation)
collapse (median) price_kg [aw=weight], by (region district ward crop_code obs_ward)
rename price_kg price_kg_median_ward
lab var price_kg_median_ward "Median price per kg for this crop in the ward"
lab var obs_ward "Number of sales observations for this crop in the ward"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_crop_prices_ward.dta", replace
use "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_crop_sales.dta", clear
gen observation = 1
bys region district crop_code: egen obs_district = count(observation) 
collapse (median) price_kg [aw=weight], by (region district crop_code obs_district)
rename price_kg price_kg_median_district
lab var price_kg_median_district "Median price per kg for this crop in the district"
lab var obs_district "Number of sales observations for this crop in the district"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_crop_prices_district.dta", replace
use "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_crop_sales.dta", clear
gen observation = 1
bys region crop_code: egen obs_region = count(observation)
collapse (median) price_kg [aw=weight], by (region crop_code obs_region)
rename price_kg price_kg_median_region
lab var price_kg_median_region "Median price per kg for this crop in the region"
lab var obs_region "Number of sales observations for this crop in the region"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_crop_prices_region.dta", replace
use "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_crop_sales.dta", clear
gen observation = 1
bys crop_code: egen obs_country = count(observation)
collapse (median) price_kg [aw=weight], by (crop_code obs_country)
rename price_kg price_kg_median_country
lab var price_kg_median_country "Median price per kg for this crop in the country"
lab var obs_country "Number of sales observations for this crop in the country"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_crop_prices_country.dta", replace

*Pull prices into harvest estimates
use "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_tempcrop_harvest.dta", clear
append using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_permcrop_harvest.dta"
merge m:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hhids.dta"
drop if _merge==2
drop _merge
merge m:1 hhid crop_code using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_crop_sales.dta"
drop _merge
merge m:1 region district ward ea crop_code using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_crop_prices_ea.dta"
drop _merge
merge m:1 region district ward crop_code using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_crop_prices_ward.dta"
drop _merge
merge m:1 region district crop_code using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_crop_prices_district.dta"
drop _merge
merge m:1 region crop_code using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_crop_prices_region.dta"
drop _merge
merge m:1 crop_code using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_crop_prices_country.dta"
drop _merge
gen price_kg_hh = price_kg
replace price_kg = price_kg_median_ea if price_kg==. & obs_ea >= 10 & crop_code!=998 & crop_code!=999 /* Don't impute prices for "other" crops */		
replace price_kg = price_kg_median_ward if price_kg==. & obs_ward >= 10 & crop_code!=998 & crop_code!=999
replace price_kg = price_kg_median_district if price_kg==. & obs_district >= 10 & crop_code!=998 & crop_code!=999
replace price_kg = price_kg_median_region if price_kg==. & obs_region >= 10 & crop_code!=998 & crop_code!=999
replace price_kg = price_kg_median_country if price_kg==. & crop_code!=998 & crop_code!=999
lab var price_kg "Price per kg, with missing values imputed using local median values"
gen value_harvest_imputed = value_harvest
replace value_harvest_imputed = kgs_harvest * price_kg_hh if price_kg_hh!=. /* Use observed hh price if it exists */
replace value_harvest_imputed = kgs_harvest * price_kg if value_harvest_imputed==.
replace value_harvest_imputed = value_harvest if value_harvest_imputed==. & crop_code==998 /* "Other" */
replace value_harvest_imputed = 0 if value_harvest_imputed==.
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_crop_values_tempfile.dta", replace 

*adding kgs_harvest , quantity_sold to used in the estimation of harvest and sales disaggregated by crop
preserve
recode  value_harvest_imputed value_sold kgs_harvest quantity_sold (.=0)
collapse (sum) value_harvest_imputed value_sold kgs_harvest quantity_sold , by (hhid crop_code)
ren value_harvest_imputed value_crop_production
lab var value_crop_production "Gross value of crop production, summed over main and short season"
rename value_sold value_crop_sales
lab var value_crop_sales "Value of crops sold so far, summed over main and short season"
lab var kgs_harvest "Kgs harvested of this crop, summed over main and short season"
ren quantity_sold kgs_sold
lab var kgs_sold "Kgs sold of this crop, summed over main and short season"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hh_crop_values_production.dta", replace
restore


collapse (sum) value_harvest_imputed value_sold, by (hhid)
replace value_harvest_imputed = value_sold if value_sold>value_harvest_imputed & value_sold!=. & value_harvest_imputed!=. /* In a few cases, the kgs sold exceeds the kgs harvested */
rename value_harvest_imputed value_crop_production
lab var value_crop_production "Gross value of crop production for this household"
*This is estimated using household value estimated for temporary crop production plus observed sales prices for permanent/tree crops.
*Prices are imputed using local median values when there are no sales.
rename value_sold value_crop_sales
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hh_crop_production.dta", replace				

*Plot value of crop production
use "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_crop_values_tempfile.dta", clear
collapse (sum) value_harvest_imputed, by (hhid plot_id)
rename value_harvest_imputed plot_value_harvest
lab var plot_value_harvest "Value of crop harvest on this plot"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_plot_cropvalue.dta", replace	


*Crop values for inputs in agricultural product processing (self-employment)
use "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_tempcrop_harvest.dta", clear
append using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_permcrop_harvest.dta"
merge m:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hhids.dta"
drop if _merge==2
drop _merge
merge m:1 hhid crop_code using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_crop_sales.dta"
drop _merge
merge m:1 region district ward ea crop_code using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_crop_prices_ea.dta"
drop _merge 
merge m:1 region district ward crop_code using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_crop_prices_ward.dta"
drop _merge
merge m:1 region district crop_code using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_crop_prices_district.dta"
drop _merge
merge m:1 region crop_code using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_crop_prices_region.dta"
drop _merge
merge m:1 crop_code using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_crop_prices_country.dta"
drop _merge
replace price_kg = price_kg_median_ea if price_kg==. & obs_ea >= 10 & crop_code!=998 & crop_code!=999 /* Don't impute prices for "other" crops */ 
replace price_kg = price_kg_median_ward if price_kg==. & obs_ward >= 10 & crop_code!=998 & crop_code!=999
replace price_kg = price_kg_median_district if price_kg==. & obs_district >= 10 & crop_code!=998 & crop_code!=999
replace price_kg = price_kg_median_region if price_kg==. & obs_region >= 10 & crop_code!=998 & crop_code!=999
replace price_kg = price_kg_median_country if price_kg==. & crop_code!=998 & crop_code!=999
lab var price_kg "Price per kg, with missing values imputed using local median values"
gen value_harvest_imputed = value_harvest
replace value_harvest_imputed = kgs_harvest * price_kg if value_harvest_imputed==.
replace value_harvest_imputed = value_harvest if value_harvest_imputed==. & crop_code==998 /* "Other" */
replace value_harvest_imputed = 0 if value_harvest_imputed==.
keep hhid crop_code price_kg 
duplicates drop
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hh_crop_prices.dta", replace

*Crops lost post-harvest
use "${TZA_W1_raw_data}\Agriculture\SEC_7A.dta", clear
append using "${TZA_W1_raw_data}\Agriculture\SEC_7B.dta"
append using "${TZA_W1_raw_data}\Agriculture\SEC_5A.dta"
append using "${TZA_W1_raw_data}\Agriculture\SEC_5B.dta" 
drop if zaocode==.
rename zaocode crop_code
rename s7aq9 value_lost
replace value_lost = s7bq9 if value_lost==.
replace value_lost = s5aq17 if value_lost==.
replace value_lost = s5bq17 if value_lost==.
recode value_lost (.=0)
collapse (sum) value_lost, by (hhid crop_code)
merge 1:1 hhid crop_code using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hh_crop_values_production.dta"
drop if _merge==2
replace value_lost = value_crop_production if value_lost > value_crop_production
collapse (sum) value_lost, by (hhid)
rename value_lost crop_value_lost
lab var crop_value_lost "Value of crop production that had been lost by the time of survey"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_crop_losses.dta", replace

************************
*CROP EXPENSES
************************
*Expenses: Hired labor
use "${TZA_W1_raw_data}\Agriculture\SEC_3A.dta", clear
rename s3aq63_3 wages_landprep_planting
rename s3aq63_6 wages_weeding
rename s3aq63_9 wages_harvesting
recode wages_landprep_planting wages_weeding wages_harvesting (.=0)
gen wages_paid_main = wages_landprep_planting + wages_weeding + wages_harvesting 
// Rename list of topcrops for hired labor. Permanent crops are not listed
// in the short rainy season - cassava and banana
global topcropname_annual "maize rice wheat sorgum pmill cowpea grdnt beans yam swtptt cotton sunflr pigpea"


foreach cn in $topcropname_annual {
	preserve
		gen short = 0
		ren plotnum plot_id
		*disaggregate by gender plot manager
		merge m:1 hhid plot_id using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_plot_decision_makers.dta"
		foreach i in wages_paid_main{
			gen `i'_`cn' = `i'
			gen `i'_`cn'_male = `i' if dm_gender==1 
			gen `i'_`cn'_female = `i' if dm_gender==2 
			gen `i'_`cn'_mixed = `i' if dm_gender==3 
		}
		
		*Merge in monocropped plots
		merge m:1 hhid plot_id short using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_`cn'_monocrop.dta", nogen assert(1 3) keep(3)		// only in master and matched; keeping only matched, because these are the maize monocropped plots
		collapse (sum) wages_paid_main_`cn'*, by(hhid)	

		// Label the newly created variables
		lab var wages_paid_main_`cn' "Wages paid for hired labor (crops) in main growing season - Monocropped `cn' plots only"
		lab var wages_paid_main_`cn'_male "Wages paid for hired labor (crops) in main growing season (male managed plots) - Monocropped `cn' plots only"
		lab var wages_paid_main_`cn'_female "Wages paid for hired labor (crops) in main growing season (female managed plots) - Monocropped `cn' plots only"
		lab var wages_paid_main_`cn'_mixed "Wages paid for hired labor (crops) in main growing season (mixed managed plots) - Monocropped `cn' plots only"

		// Save the Data
		save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_wages_mainseason_`cn'.dta", replace
	restore
}


collapse (sum) wages_paid_main, by (hhid)
lab var wages_paid_main  "Wages paid for hired labor (crops) in main growing season"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_wages_mainseason.dta", replace

use "${TZA_W1_raw_data}\Agriculture\SEC_3B.dta", clear
rename s3bq63_3 wages_landprep_planting
rename s3bq63_6 wages_weeding
rename s3bq63_9 wages_harvesting
recode wages_landprep_planting wages_weeding wages_harvesting (.=0)
gen wages_paid_short = wages_landprep_planting + wages_weeding + wages_harvesting 

// List of crops with observations in the short season
global topcropname_short "maize rice sorgum cowpea grdnt beans yam swtptt cassav banana cotton"
foreach cn in $topcropname_short {
	preserve
		gen short = 1
		ren plotnum plot_id
		merge m:1 hhid plot_id using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_plot_decision_makers.dta"
		foreach i in wages_paid_short{
			gen `i'_`cn' = `i'
			gen `i'_`cn'_male = `i' if dm_gender==1 
			gen `i'_`cn'_female = `i' if dm_gender==2 
			gen `i'_`cn'_mixed = `i' if dm_gender==3 
		}
		*Merge in monocropped plots
		merge m:1 hhid plot_id short using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_`cn'_monocrop.dta", nogen assert(1 3) keep(3)		
		// only in master and matched; keeping only matched, because these are the maize monocropped plots

		collapse (sum) wages_paid_short_`cn'*, by(hhid)		// renaming all to current crop name suffix

		// Label all of the newly created variables
		lab var wages_paid_short_`cn' "Wages paid for hired labor (crops) in the short growing season - Monocropped `cn' plots only"
		lab var wages_paid_short_`cn'_male "Wages paid for hired labor (crops) in the short growing season (male managed plots) - Monocropped `cn' plots only"
		lab var wages_paid_short_`cn'_female "Wages paid for hired labor (crops) in the short growing season (female managed plots) - Monocropped `cn' plots only"
		lab var wages_paid_short_`cn'_mixed "Wages paid for hired labor (crops) in the short growing season (mixed managed plots) - Monocropped `cn' plots only"
		save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_wages_shortseason_`cn'.dta", replace
	restore
}

collapse (sum) wages_paid_short, by (hhid)
lab var wages_paid_short  "Wages paid for hired labor (crops) in short growing season"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_wages_shortseason.dta", replace

*Expenses: Inputs
use "${TZA_W1_raw_data}\Agriculture\SEC_3A.dta", clear
append using "${TZA_W1_raw_data}\Agriculture\SEC_3B.dta", gen(short)


*formalized land rights
replace s3aq25 = s3bq25 if s3aq25==.		// replacing with values in short season for short season observations
gen formal_land_rights = s3aq25==1										// Note: Including anything other than "no documents" as formal

*Individual level (for women)
*NOTE: Assuming ANY listed owners are also listed on the document (if they have a document, that is)
replace s3aq27_1 = s3bq27_1 if s3aq27_1==.
replace s3aq27_2 = s3bq27_2 if s3aq27_2==.
*Starting with first owner
preserve
	ren s3aq27_1 sbmemno
	merge m:1 hhid sbmemno using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_person_ids.dta", nogen keep(3)		
	keep hhid sbmemno female formal_land_rights
	tempfile p1
	save `p1', replace
restore
*Now second owner
preserve
	ren s3aq27_2 sbmemno		
	merge m:1 hhid sbmemno using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_person_ids.dta", nogen keep(3)		
	keep hhid sbmemno female
	append using `p1'
	gen formal_land_rights_f = formal_land_rights==1 if female==1
	collapse (max) formal_land_rights_f, by(hhid sbmemno)		
	save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_land_rights_ind.dta", replace
restore	
	
preserve
	collapse (max) formal_land_rights_hh=formal_land_rights, by(hhid)		// taking max at household level; equals one if they have official documentation for at least one plot
	save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_land_rights_hh.dta", replace
restore

gen value_fertilizer = s3aq41
replace value_fertilizer = s3bq41 if value_fertilizer ==.
recode value_fertilizer (.=0)
gen value_herb_pest = s3aq52
replace value_herb_pest = s3bq52 if value_herb_pest==.
recode value_herb_pest (.=0)
gen value_manure_purchased = s3aq41
replace value_manure_purchased = s3bq41 if value_manure_purchased==.
recode value_manure_purchased (.=0)

// Fertilizer and Herbicide/Pesticide Costs for top crops
foreach cn in $topcropname_area {
	preserve
		ren plotnum plot_id
		*disaggregate by gender plot manager
		merge m:1 hhid plot_id using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_plot_decision_makers.dta"
		merge m:1 hhid plot_id short using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_`cn'_monocrop.dta", nogen assert(1 3) keep(3)		// only in master and matched; keeping only matched, because these are the top crop monocropped plots

		foreach i in value_fertilizer value_herb_pest{
			gen `i'_`cn' = `i'
			gen `i'_`cn'_male = `i' if dm_gender==1
			gen `i'_`cn'_female = `i' if dm_gender==2
			gen `i'_`cn'_mixed = `i' if dm_gender==3
		}

		collapse (sum) value_fertilizer_`cn'* value_herb_pest_`cn'*, by(hhid)
		*Merge in monocropped plots
	
		lab var value_fertilizer_`cn' "Value of fertilizer purchased (not necessarily the same as used) in main and short growing seasons - Monocropped cn' plots only"
		lab var value_herb_pest_`cn' "Value of herbicide/Pesticide purchased (not necessarily the same as used) in main and short growing seasons - Monocropped `cn' plots only"
		save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_fertilizer_costs_`cn'.dta", replace
	restore
}

collapse (sum) value_fertilizer value_herb_pest, by (hhid)
lab var value_fertilizer "Value of fertilizer purchased (not necessarily the same as used) in main and short growing seasons"
lab var value_herb_pest "Value of herbicide and pesticide purchased (not necessarily the same as used) in main and short growing seasons"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_fertilizer_costs.dta", replace

*Seed
use "${TZA_W1_raw_data}\Agriculture\SEC_4A.dta", clear
append using "${TZA_W1_raw_data}\Agriculture\SEC_4B.dta", gen(short)
gen cost_seed = s4aq20
replace cost_seed = s4bq20 if cost_seed==.
recode cost_seed (.=0)

*seed costs for top crops on monocropped plots - except for annual crops
//Can't have seed costs for permanent crops
foreach cn in $topcropname_annual {
	preserve
		ren plotnum plot_id
		*disaggregate by gender plot manager
		merge m:1 hhid plot_id using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_plot_decision_makers.dta"
		foreach i in cost_seed{
			gen `i'_`cn' = `i'
			gen `i'_`cn'_male = `i' if dm_gender==1
			gen `i'_`cn'_female = `i' if dm_gender==2
			gen `i'_`cn'_mixed = `i' if dm_gender==3
		}
		*Merge in monocropped plots
		merge m:1 hhid plot_id short using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_`cn'_monocrop.dta", nogen assert(1 3) keep(3)		// only in master and matched; keeping only matched, because these are the top crop monocropped plots
		collapse (sum) cost_seed_`cn'*, by(hhid)	
		lab var cost_seed_`cn' "Expenditures on seed for temporary crops - Monocropped `cn' plots only"
		save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_seed_costs_`cn'.dta", replace
	restore
}

collapse (sum) cost_seed, by (hhid)
lab var cost_seed "Expenditures on seed for temporary crops"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_seed_costs.dta", replace

*Land rental
use "${TZA_W1_raw_data}\Agriculture\SEC_3A.dta", clear
append using "${TZA_W1_raw_data}\Agriculture\SEC_3B.dta", gen(short)
gen rental_cost_land = s3aq30
replace rental_cost_land = s3bq30 if rental_cost_land==.
recode rental_cost_land (.=0)

*land rental costs for top crop  plots
foreach cn in $topcropname_area {
	preserve
		ren plotnum plot_id
		*disaggregate by gender plot manager
		merge m:1 hhid plot_id using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_plot_decision_makers.dta"
		*Merge in monocropped plots
		merge 1:1 hhid plot_id short using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_`cn'_monocrop.dta", nogen assert(1 3) keep(3)		// only in master and matched; keeping only matched, because these are the top crop monocropped plots
		foreach i in rental_cost_land{
			gen `i'_`cn' = `i'
			gen `i'_`cn'_male = `i' if dm_gender==1
			gen `i'_`cn'_female = `i' if dm_gender==2
			gen `i'_`cn'_mixed = `i' if dm_gender==3
		}
	
		collapse (sum) rental_cost_land_`cn'*, by(hhid)			
		lab var rental_cost_land_`cn' "Rental costs paid for land - Monocropped `cn' plots only"
		save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_land_rental_costs_`cn'.dta", replace
	restore
}
collapse (sum) rental_cost_land, by (hhid)
lab var rental_cost_land "Rental costs paid for land"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_land_rental_costs.dta", replace

*Rental of agricultural tools, machines, animal traction
use "${TZA_W1_raw_data}\Agriculture\SEC_11_ALL.dta", clear
gen animal_traction = (impcode>=3 & impcode<=6) 		
gen ag_asset = (impcode<3 | impcode>9)
gen tractor = (impcode>=7 & impcode<=9)
rename s11q9 rental_cost
gen rental_cost_animal_traction = rental_cost if animal_traction==1
gen rental_cost_ag_asset = rental_cost if ag_asset==1
gen rental_cost_tractor = rental_cost if tractor==1
recode rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor (.=0)
collapse (sum) rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor, by (hhid)
lab var rental_cost_animal_traction "Costs for renting animal traction"
lab var rental_cost_ag_asset "Costs for renting other agricultural items"
lab var rental_cost_tractor "Costs for renting a tractor"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_asset_rental_costs.dta", replace

*Transport costs for crop sales			
use "${TZA_W1_raw_data}\Agriculture\SEC_5A.dta", clear
append using "${TZA_W1_raw_data}\Agriculture\SEC_5B.dta"
rename s5aq13 transport_costs_cropsales
replace transport_costs_cropsales = s5bq13 if transport_costs_cropsales==.
recode transport_costs_cropsales (.=0)
collapse (sum) transport_costs_cropsales, by (hhid)
lab var transport_costs_cropsales "Expenditures on transportation for crop sales of temporary crops"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_transportation_cropsales.dta", replace


*Crop costs 
use "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_asset_rental_costs.dta", clear
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_land_rental_costs.dta"
drop _merge 
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_seed_costs.dta"
drop _merge
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_fertilizer_costs.dta"
drop _merge 
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_wages_shortseason.dta"
drop _merge 
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_wages_mainseason.dta"
drop _merge
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_transportation_cropsales.dta"
drop _merge
recode rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor rental_cost_land cost_seed value_fertilizer /*
*/ value_herb_pest wages_paid_short wages_paid_main transport_costs_cropsales (.=0)
egen crop_production_expenses = rowtotal(rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor rental_cost_land cost_seed value_fertilizer /*
*/ value_herb_pest wages_paid_short wages_paid_main transport_costs_cropsales)
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_crop_income.dta", replace




************
*LIVESTOCK INCOME
************

*Expenses		
use "${TZA_W1_raw_data}\Agriculture\SEC_10A.dta", clear
rename s10aq18 cost_fodder_livestock
rename s10aq16 cost_hired_labor_livestock 
recode cost_fodder_livestock cost_hired_labor_livestock (.=0)
collapse (sum) cost_fodder_livestock cost_hired_labor_livestock, by (hhid)
lab var cost_fodder_livestock "Cost for fodder for livestock"
lab var cost_hired_labor_livestock "Cost for hired labor for livestock"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_expenses", replace

*Livestock products 		
use "${TZA_W1_raw_data}\Agriculture\SEC_10B.dta", clear
rename lvstkprod livestock_code
rename s10bq2 months_produced
rename s10bq3_meas quantity_month
rename s10bq3_meat quantity_month_unit
replace quantity_month_unit = 1 if livestock_code==1 | livestock_code==2 
replace quantity_month_unit = 3 if livestock_code==3 | livestock_code==4 
replace quantity_month_unit = 1 if livestock_code==5
replace quantity_month_unit = 3 if livestock_code==6
recode months_produced quantity_month (.=0)
gen quantity_produced = months_produced * quantity_month /* Units are pieces for eggs & skin, liters for honey */
lab var quantity_produced "Quantity of this product produed in past year"
rename s10bq5_1 sales_quantity
rename s10bq5_2 sales_unit
replace sales_unit = 1 if livestock_code==1 | livestock_code==2 
replace sales_unit = 3 if livestock_code==3 | livestock_code==4 
replace sales_unit = 1 if livestock_code==5
replace sales_unit = 3 if livestock_code==6
rename s10bq6 earnings_sales
recode sales_quantity months_produced quantity_month earnings_sales (.=0)
gen price_per_unit = earnings_sales / sales_quantity
keep hhid livestock_code quantity_produced price_per_unit earnings_sales
replace livestock_code = 21 if livestock_code==3 | livestock_code ==4
replace livestock_code = 22 if livestock_code==5
replace livestock_code = 23 if livestock_code==6
label define livestock_code_label 21 "Eggs" 22 "Honey" 23 "Skins"
label values livestock_code livestock_code_label
bys livestock_code: sum price_per_unit
gen price_per_unit_hh = price_per_unit
recode price_per_unit price_per_unit_hh (0=.)
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_products_other", replace

use "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_products_other"
merge m:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hhids.dta"
drop if _merge==2
drop _merge
replace price_per_unit = . if price_per_unit == 0 
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_products", replace

use "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_products", clear
keep if price_per_unit !=. 
gen observation = 1
bys region district ward ea livestock_code: egen obs_ea = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district ward ea livestock_code obs_ea)
rename price_per_unit price_median_ea
lab var price_median_ea "Median price per unit for this livestock product in the ea"
lab var obs_ea "Number of sales observations for this livestock product in the ea"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_products_prices_ea.dta", replace
use "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region district ward livestock_code: egen obs_ward = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district ward livestock_code obs_ward)
rename price_per_unit price_median_ward
lab var price_median_ward "Median price per unit for this livestock product in the ward"
lab var obs_ward "Number of sales observations for this livestock product in the ward"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_products_prices_ward.dta", replace
use "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region district livestock_code: egen obs_district = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district livestock_code obs_district)
rename price_per_unit price_median_district
lab var price_median_district "Median price per unit for this livestock product in the district"
lab var obs_district "Number of sales observations for this livestock product in the district"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_products_prices_district.dta", replace
use "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_unit [aw=weight], by (region livestock_code obs_region)
rename price_per_unit price_median_region
lab var price_median_region "Median price per unit for this livestock product in the region"
lab var obs_region "Number of sales observations for this livestock product in the region"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_products_prices_region.dta", replace
use "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_unit [aw=weight], by (livestock_code obs_country)
rename price_per_unit price_median_country
lab var price_median_country "Median price per unit for this livestock product in the country"
lab var obs_country "Number of sales observations for this livestock product in the country"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_products_prices_country.dta", replace

use "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_products", clear
merge m:1 region district ward ea livestock_code using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_products_prices_ea.dta"
drop _merge
merge m:1 region district ward livestock_code using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_products_prices_ward.dta"
drop _merge
merge m:1 region district livestock_code using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_products_prices_district.dta"
drop _merge
merge m:1 region livestock_code using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_products_prices_region.dta"
drop _merge
merge m:1 livestock_code using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_products_prices_country.dta"
drop _merge
replace price_per_unit = price_median_ea if price_per_unit==. & obs_ea >= 10
replace price_per_unit = price_median_ward if price_per_unit==. & obs_ward >= 10
replace price_per_unit = price_median_district if price_per_unit==. & obs_district >= 10 
replace price_per_unit = price_median_region if price_per_unit==. & obs_region >= 10 
replace price_per_unit = price_median_country if price_per_unit==.
lab var price_per_unit "Price per unit of this livestock product, with missing values imputed using local median values"
gen price_cowmilk_med = price_median_country if livestock_code==1 | livestock_code == 2
egen price_cowmilk = max(price_cowmilk_med)
lab var price_per_unit "Price per liter (milk) or per egg/liter/container honey, imputed with local median prices if household did not sell"
gen value_milk_produced = quantity_produced * price_per_unit if livestock_code == 1 | livestock_code == 2 
gen value_eggs_produced = quantity_produced * price_per_unit if livestock_code==21
gen value_other_produced = quantity_produced * price_per_unit if livestock_code !=1 & livestock_code !=2 & livestock_code != 21 & livestock_code != 7 //7 is other, shouldn't be included


*share of total production sold
egen sales_livestock_products = rowtotal(earnings_sales)		// this will be for all livestock products ("other" and milk/cheese)

collapse (sum) value_milk_produced value_eggs_produced value_other_produced sales_livestock_products, by (hhid)

egen value_livestock_products = rowtotal(value_milk_produced value_eggs_produced value_other_produced)
gen share_livestock_prod_sold = sales_livestock_products/value_livestock_products
replace share_livestock_prod_sold = 1 if share_livestock_prod_sold>1 & share_livestock_prod_sold!=.
lab var share_livestock_prod_sold "Percent of production of livestock products that is sold" 

lab var value_milk_produced "Value of milk produced"
lab var value_eggs_produced "Value of eggs produced"
lab var value_other_produced "Value of honey and skins and hides produced"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hh_livestock_products", replace 		

*Sales (live animals)
use "${TZA_W1_raw_data}\Agriculture\SEC_10A.dta", clear
rename animal livestock_code
rename s10aq9 income_live_sales 
rename s10aq8 number_sold 
rename s10aq12 number_slaughtered 
rename s10aq13 number_slaughtered_sold 
rename s10aq14 income_slaughtered
recode income_live_sales number_sold number_slaughtered number_slaughtered_sold income_slaughtered (.=0)
gen price_per_animal = income_live_sales / number_sold
recode price_per_animal (0=.) 
merge m:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hhids.dta"
drop if _merge==2
drop _merge
keep hhid weight region district ward ea livestock_code number_sold income_live_sales number_slaughtered income_slaughtered price_per_animal 
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hh_livestock_sales", replace

*Implicit prices
use "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district ward ea livestock_code: egen obs_ea = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district ward ea livestock_code obs_ea)
rename price_per_animal price_median_ea
lab var price_median_ea "Median price per unit for this livestock in the ea"
lab var obs_ea "Number of sales observations for this livestock in the ea"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_prices_ea.dta", replace
use "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district ward livestock_code: egen obs_ward = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district ward livestock_code obs_ward)
rename price_per_animal price_median_ward
lab var price_median_ward "Median price per unit for this livestock in the ward"
lab var obs_ward "Number of sales observations for this livestock in the ward"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_prices_ward.dta", replace
use "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district livestock_code: egen obs_district = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district livestock_code obs_district)
rename price_per_animal price_median_district
lab var price_median_district "Median price per unit for this livestock in the district"
lab var obs_district "Number of sales observations for this livestock in the district"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_prices_district.dta", replace
use "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_animal [aw=weight], by (region livestock_code obs_region)
rename price_per_animal price_median_region
lab var price_median_region "Median price per unit for this livestock in the region"
lab var obs_region "Number of sales observations for this livestock in the region"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_prices_region.dta", replace
use "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_animal [aw=weight], by (livestock_code obs_country)
rename price_per_animal price_median_country
lab var price_median_country "Median price per unit for this livestock in the country"
lab var obs_country "Number of sales observations for this livestock in the country"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_prices_country.dta", replace

use "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hh_livestock_sales", clear
merge m:1 region district ward ea livestock_code using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_prices_ea.dta"
drop _merge
merge m:1 region district ward livestock_code using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_prices_ward.dta"
drop _merge
merge m:1 region district livestock_code using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_prices_district.dta"
drop _merge
merge m:1 region livestock_code using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_prices_region.dta"
drop _merge
merge m:1 livestock_code using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_prices_country.dta"
drop _merge
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
collapse (sum) value_livestock_sales, by (hhid) 
drop if hhid==""
lab var value_livestock_sales "Value of livestock sold and slaughtered (with slaughtered livestock that weren't sold valued at local median prices for live animal sales)"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_sales", replace


*TLU (Tropical Livestock Units)
use "${TZA_W1_raw_data}\Agriculture\SEC_10A.dta", clear
rename animal lvstckid
gen tlu_coefficient=0.5 if (lvstckid==1|lvstckid==2|lvstckid==3|lvstckid==4|lvstckid==5|lvstckid==6)		//
replace tlu_coefficient=0.1 if (lvstckid==7|lvstckid==8)
replace tlu_coefficient=0.2 if (lvstckid==9)
replace tlu_coefficient=0.01 if (lvstckid==10|lvstckid==11|lvstckid==12)
replace tlu_coefficient=0.5 if (lvstckid==13)
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
rename s10aq4_1 number_today_indigenous
recode s10aq4_2 s10aq4_3 number_today_indigenous (.=0)
gen number_today_exotic = s10aq4_2 + s10aq4_3 
gen number_today = number_today_indigenous + number_today_exotic
gen tlu_today = number_today * tlu_coefficient
rename s10aq9 income_live_sales 
rename s10aq8 number_sold
ren lvstckid livestock_code

egen mean_12months = rowmean(number_today)
gen animals_lost12months = s10aq20	// only includes lost to disease

gen share_imp_herd_cows = number_today_exotic/(number_today) if livestock_code==2

gen species = (inlist(livestock_code,1,2,3,4,5,6)) + 2*(inlist(livestock_code,7,8)) + 3*(livestock_code==9) + 4*(inlist(livestock_code==13,14)) + 5*(inlist(livestock_code,10,11)) 
recode species (0=.)
la def species 1 "Large ruminants (cows, buffalos)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses, donkeys)" 5 "Poultry"
la val species species

preserve
	*Now to household level
	*First, generating these values by species
	collapse (firstnm) share_imp_herd_cows (sum) number_today animals_lost12months number_today_exotic lvstck_holding=number_today, by(hhid species)
	egen mean_12months = rowmean(number_today)
	gen any_imp_herd = number_today_exotic!=0 if number_today!=. & number_today!=0

	*A loop to create species variables
	foreach i in animals_lost12months mean_12months any_imp_herd lvstck_holding{
		gen `i'_lrum = `i' if species==1
		gen `i'_srum = `i' if species==2
		gen `i'_pigs = `i' if species==3
		gen `i'_equine = `i' if species==4
		gen `i'_poultry = `i' if species==5
	}
	
	collapse (sum) number_today number_today_exotic (firstnm) *lrum *srum *pigs *equine *poultry share_imp_herd_cows, by(hhid)
	*Overall any improved herd
	gen any_imp_herd = number_today_exotic!=0 if number_today!=0
	drop number_today_exotic number_today
	*Generating missing variables in order to construct labels (just for the labeling loop below)
	foreach i in lvstck_holding animals_lost12months mean_12months {
		gen `i' = .
	}
	la var lvstck_holding "Total number of livestock holdings (# of animals)"
	la var any_imp_herd "At least one improved animal in herd"
	la var share_imp_herd_cows "Share of improved animals in total herd - Cows only"
	lab var animals_lost12months  "Total number of livestock  lost to disease"
	lab var  mean_12months  "Average number of livestock  today and 1  year ago"
	*A loop to label these variables (taking the labels above to construct each of these for each species)
	foreach i in any_imp_herd lvstck_holding animals_lost12months mean_12months {
		local l`i' : var lab `i'
		lab var `i'_lrum "`l`i'' - large ruminants"
		lab var `i'_srum "`l`i'' - small ruminants"
		lab var `i'_pigs "`l`i'' - pigs"
		lab var `i'_equine "`l`i'' - equine"
		lab var `i'_poultry "`l`i'' - poultry"
	}
	la var any_imp_herd "At least one improved animal in herd - all animals"
	
	*Total livestock holding for large ruminants, small ruminants, and poultry
	gen lvstck_holding_all = lvstck_holding_lrum + lvstck_holding_srum + lvstck_holding_poultry
	la var lvstck_holding_all "Total number of livestock holdings (# of animals) - large ruminants, small ruminants, poultry"
	
	*any improved large ruminants, small ruminants, or poultry
	gen any_imp_herd_all = 0 if any_imp_herd_lrum==0 | any_imp_herd_srum==0 | any_imp_herd_poultry==0
	replace any_imp_herd_all = 1 if  any_imp_herd_lrum==1 | any_imp_herd_srum==1 | any_imp_herd_poultry==1
	
	recode lvstck_holding* (.=0)
	
	drop lvstck_holding animals_lost12months mean_12months
	save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_herd_characteristics", replace
restore

gen price_per_animal = income_live_sales / number_sold
recode price_per_animal (0=.)
merge m:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hhids.dta"
drop if _merge==2
drop _merge
merge m:1 region district ward ea livestock_code using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_prices_ea.dta"
drop _merge
merge m:1 region district ward livestock_code using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_prices_ward.dta"
drop _merge
merge m:1 region district livestock_code using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_prices_district.dta"
drop _merge
merge m:1 region livestock_code using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_prices_region.dta"
drop _merge
merge m:1 livestock_code using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_prices_country.dta"
drop _merge 
replace price_per_animal = price_median_ea if price_per_animal==. & obs_ea >= 10
replace price_per_animal = price_median_ward if price_per_animal==. & obs_ward >= 10
replace price_per_animal = price_median_district if price_per_animal==. & obs_district >= 10
replace price_per_animal = price_median_region if price_per_animal==. & obs_region >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_today = number_today * price_per_animal
collapse (sum) tlu_today value_today, by (hhid) 

gen lvstck_holding_tlu = tlu_today
lab var lvstck_holding_tlu "Total HH livestock holdings, TLU"  
lab var tlu_today "Tropical Livestock Units as of the time of survey"

lab var value_today "Value of livestock holdings today"
drop if hhid==""
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_TLU.dta", replace


*Livestock income
use "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_sales", clear
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hh_livestock_products"
drop _merge
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_expenses"
drop _merge
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_TLU.dta"
drop _merge
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_TLU_Coefficients.dta"
drop _merge

gen livestock_income = value_livestock_sales + (value_milk_produced + value_eggs_produced + value_other_produced) /*
*/ - (cost_hired_labor_livestock + cost_fodder_livestock) //

lab var livestock_income "Net livestock income"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_income", replace


************
*FISH INCOME
************
*Fishing expenses

use "${TZA_W1_raw_data}\Agriculture\SEC_12A.dta", clear
rename s12q9 equipment_repair_cost
collapse (sum) equipment_repair_cost, by (hhid)
save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_fishing_expenses_1.dta", replace

use "${TZA_W1_raw_data}\Agriculture\SEC_12D.dta", clear
rename s12q24_q27 months
gen fuel_costs_month = s12q25_q28 if itemcode == 10 
gen cost = s12q25_q28 if itemcode !=4 & itemcode !=6 & itemcode !=5 & itemcode != 10 // Exclude taxes, per RuLIS guidelines
recode months fuel_costs_month cost(.=0) 
gen cost_fuel = fuel_costs_month * months
gen cost_paid = cost * months
collapse (sum) cost_fuel cost_paid, by (hhid) 
lab var cost_fuel "Costs for fuel over the past year"
lab var cost_paid "Other costs paid for fishing activities"
save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_fishing_expenses_2.dta", replace

use "${TZA_W1_raw_data}\Agriculture\SEC_12B.dta", clear
rename s12q10 fishing_yesno
keep if fishing_yesno == 1
rename s12q14 kgs_sold_perday
rename s12q15 earnings_perday
merge m:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hhids.dta"
drop if _merge==2
drop _merge
gen price_per_kg = earnings_perday/kgs_sold_perday
recode price_per_kg (0=.) 
collapse (median) price_per_kg [aw = weight], by (itemcode)
rename price_per_kg price_per_kg_median
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_fish_prices.dta", replace

use "${TZA_W1_raw_data}\Agriculture\SEC_12B.dta", clear
rename s12q10 fishing_yesno
keep if fishing_yesno == 1
rename s12q11 months
rename s12q12 days_perweek
rename s12q13 kgs_caught_perday
rename s12q14 kgs_sold_perday
replace kgs_caught_perday = max((kgs_caught_perday/100),kgs_sold_perday) if (((kgs_caught_perday/kgs_sold_perday) >= 10) & kgs_caught_perday > 100)  
replace kgs_sold_perday = kgs_caught_perday if kgs_sold_perday > kgs_caught_perday  
rename s12q15 earnings_perday
merge m:1 itemcode using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_fish_prices.dta"
drop if _merge==2
drop _merge
gen price_per_kg = earnings_perday/kgs_sold_perday
recode price_per_kg (0=.) 
replace price_per_kg = price_per_kg_median if (price_per_kg == . | price_per_kg == 0) & kgs_caught !=. & kgs_caught != 0
gen income_fish_sales = price_per_kg * kgs_sold_perday * days_perweek * 4 * months 
gen value_fish_harvest = price_per_kg * kgs_caught_perday * days_perweek * 4 * months 
collapse (sum) value_fish_harvest income_fish_sales, by (hhid)
recode value_fish_harvest income_fish_sales (.=0)
lab var value_fish_harvest "Value of fish harvest (including what is sold), with values imputed using a national median for fish-unit-prices"
lab var income_fish_sales "Value of fish sales"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_fish_income.dta", replace


************
*SELF-EMPLOYMENT INCOME
************
use "${TZA_W1_raw_data}\Household\SEC_E2.dta", clear
append using "${TZA_W1_raw_data}\Household\SEC_B_C_D_E1_F_G1_U.dta"
rename seq41o months_activ
rename seq42o monthly_profit
replace months_activ= seq41 if months_activ==.
replace monthly_profit= seq42 if monthly_profit==.
gen annual_selfemp_profit = months_activ*monthly_profit
recode annual_selfemp_profit (.=0)
duplicates drop hhid months_activ annual_selfemp_profit if annual_selfemp_profit!=0, force

replace seq36_1=seq36_1o if seq36_1==.
replace seq36_2=seq36_2o if seq36_2==.
gen alrea_report_annualprofit=monthly_profit==months_activ*seq36_2 if seq36_1==2
tab alrea_report_annualprofit if  monthly_profit!=0 & monthly_profit!=.
gen alrea_report_annualprofit2=monthly_profit==months_activ*4*seq36_2 if seq36_1==1
tab alrea_report_annualprofit2

replace annual_selfemp_profit=months_activ*seq36_2 if alrea_report_annualprofit==1 &  seq36_1==2
replace annual_selfemp_profit=months_activ*seq36_2 if alrea_report_annualprofit2==1 &  seq36_1==1
collapse (sum) annual_selfemp_profit, by (hhid)

collapse (sum) annual_selfemp_profit, by (hhid)
lab var annual_selfemp_profit "Estimated annual net profit from self-employment over previous 12 months"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_self_employment_income.dta", replace				

*Processed crops
use "${TZA_W1_raw_data}\Agriculture\SEC_9_ALL.dta", clear
rename zaocode crop_code
rename s9q2name crop_name 
rename s9q5 byproduct_sold_yesno
rename s9q4_1 byproduct_quantity
rename s9q4_2 byproduct_unit
rename s9q7 kgs_used_in_byproduct 
rename s9q8 byproduct_price_received
rename s9q10 other_expenses_yesno
rename s9q11 byproduct_other_costs
merge m:1 hhid crop_code using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hh_crop_prices.dta"
drop _merge
recode byproduct_quantity kgs_used_in_byproduct byproduct_other_costs (.=0)
gen byproduct_sales = byproduct_quantity * byproduct_price_received
gen byproduct_crop_cost = kgs_used_in_byproduct * price_kg
gen byproduct_profits = byproduct_sales - (byproduct_crop_cost + byproduct_other_costs)
collapse (sum) byproduct_profits, by (hhid)
lab var byproduct_profits "Net profit from sales of agricultural processed products or byproducts"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_agproducts_profits.dta", replace

***************
*OFF-FARM HOURS
***************
use "${TZA_W1_raw_data}/Household/SEC_B_C_D_E1_F_G1_U.dta", clear
gen primary_hours = seq19 if seq13>9 & seq13!=.		// hh_e21_2<9 is ag/mining
egen off_farm_hours = rowtotal(primary_hours)
gen off_farm_any_count = off_farm_hours!=0
gen member_count = 1

collapse (sum) off_farm_hours off_farm_any_count member_count, by(hhid)
la var member_count "Number of HH members age 5 or above"
la var off_farm_any_count "Number of HH members with positive off-farm hours"
la var off_farm_hours "Total household off-farm hours"
save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_off_farm_hours.dta", replace


************
*WAGE INCOME
************
/*
This Cannot be calculated for Wave 1
See imputation below

*/


************
*OTHER INCOME
************
use "${TZA_W1_raw_data}\Household\SEC_G2.dta", clear 
append using "${TZA_W1_raw_data}\Household\SEC_O1.dta" 
rename sgq11 cash_inkind_gifts_received 
rename soq3 assistance_cash
rename soq4 assistance_food
rename soq5 assistance_inkind
recode cash_inkind_gifts_received assistance_cash assistance_food assistance_inkind (.=0)
rename cash_inkind_gifts_received remittance_income 
gen assistance_income = assistance_cash + assistance_food + assistance_inkind
collapse (sum) remittance_income assistance_income, by (hhid)

lab var remittance_income "Estimated income from remittances over previous 12 months"
lab var assistance_income "Estimated income from a food aid, food-for-work, etc. over previous 12 months"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_other_income.dta", replace

use "${TZA_W1_raw_data}\Agriculture\SEC_3A.dta", clear
rename s3aq4 land_rental_income_mainseason
append using "${TZA_W1_raw_data}\Agriculture\SEC_3B.dta"
rename s3bq4 land_rental_income_shortseason
recode land_rental_income_mainseason land_rental_income_shortseason (.=0)
gen land_rental_income = land_rental_income_mainseason + land_rental_income_shortseason
collapse (sum) land_rental_income, by (hhid)
lab var land_rental_income "Estimated income from renting out land over previous 12 months"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_land_rental_income.dta", replace

*Other income
use "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_other_income.dta", clear
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_land_rental_income.dta"
egen other_income_sources = rowtotal (remittance_income assistance_income land_rental_income)

************
*FARM SIZE / LAND SIZE
************

use "${TZA_W1_raw_data}\Agriculture\SEC_3A.dta", clear
append using "${TZA_W1_raw_data}\Agriculture\SEC_3B.dta"
gen cultivated = (s3aq3==1 | s3bq3==1)

preserve 
	use "${TZA_W1_raw_data}\Agriculture\SEC_6A.dta", clear
	gen cultivated=1 if (s6aq8!=. & s6aq8!=0) | (s6aq4!=. & s6aq4!=0) // defining plots with fruit/permanent crops as cultivated if there was any harvest or if any trees were planted in the last 12 months
	collapse (max) cultivated, by (hhid plotnum)
	drop if plotnum==""
	tempfile fruit_tree
	save `fruit_tree', replace
restore
append using `fruit_tree'

preserve 
	use "${TZA_W1_raw_data}\Agriculture\SEC_6B.dta", clear
	gen cultivated=1 if (s6bq8!=. & s6bq8!=0) | (s6bq4!=. & s6bq4!=0) //defining plots with fruit/permanant crops as cultivated if there was any harvest or if any trees were planted in the last 12 months
	collapse (max) cultivated, by (hhid plotnum)
	drop if plotnum==""
	tempfile perm_crop
	save `perm_crop', replace
restore
append using `perm_crop'

rename plotnum plot_id
collapse (max) cultivated, by (hhid plot_id)
lab var cultivated "1= Parcel was cultivated in this data set"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_parcels_cultivated.dta", replace

use "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_parcels_cultivated.dta", clear
merge 1:1 hhid plot_id using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_plot_areas.dta"
drop if _merge==2
keep if cultivated==1
replace area_acres_meas=. if area_acres_meas<0 
replace area_acres_meas = area_acres_est if area_acres_meas==. 
collapse (sum) area_acres_meas, by (hhid)
rename area_acres_meas farm_area
replace farm_area = farm_area * (1/2.47105) /* Convert to hectares */
lab var farm_area "Land size (denominator for land productivitiy), in hectares" 
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_land_size.dta", replace


*All agricultural land
use "${TZA_W1_raw_data}\Agriculture\SEC_3A.dta", clear
append using "${TZA_W1_raw_data}\Agriculture\SEC_3B.dta"
rename plotnum plot_id
drop if plot_id==""
gen rented_out = (s3aq3==2 | s3aq3==3 | s3bq3==2 | s3bq3==3)
gen cultivated_short = (s3bq3==1)
bys hhid plot_id: egen plot_cult_short = max(cultivated_short)
replace rented_out = 0 if plot_cult_short==1 // If cultivated in short season, not considered rented out in long season.
drop if rented_out==1
gen agland = (s3aq3==1 | s3aq3==4 | s3bq3==1 | s3bq3==4) // All cultivated AND fallow plots

preserve 
	use "${TZA_W1_raw_data}\Agriculture\SEC_6A.dta", clear
	gen cultivated=1 if (s6aq8!=. & s6aq8!=0) | (s6aq4!=. & s6aq4!=0) // defining plots with fruit/permanent crops as cultivated if there was any harvest or if any trees were planted in the last 12 months
	collapse (max) cultivated, by (hhid plotnum)
	drop if plotnum==""
	rename plotnum plot_id
	tempfile fruit_tree
	save `fruit_tree', replace
restore
append using `fruit_tree'

preserve 
	use "${TZA_W1_raw_data}\Agriculture\SEC_6B.dta", clear
	gen cultivated=1 if (s6bq8!=. & s6bq8!=0) | (s6bq4!=. & s6bq4!=0) //defining plots with fruit/permanant crops as cultivated if there was any harvest or if any trees were planted in the last 12 months
	collapse (max) cultivated, by (hhid plotnum)
	drop if plotnum==""
	rename plotnum plot_id
	tempfile perm_crop
	save `perm_crop', replace
restore
append using `perm_crop'
replace agland=1 if cultivated==1


keep if agland==1 
collapse (max) agland, by (hhid plot_id)
lab var agland "1= Parcel was used for crop cultivation or left fallow in this past year (forestland and other uses excluded)"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_parcels_agland.dta", replace

use "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_parcels_agland.dta", clear
merge 1:1 hhid plot_id using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_plot_areas.dta"
drop if _merge == 2
replace area_acres_meas=. if area_acres_meas<0
replace area_acres_meas = area_acres_est if area_acres_meas==. 
collapse (sum) area_acres_meas, by (hhid)
rename area_acres_meas farm_size_agland
replace farm_size_agland = farm_size_agland * (1/2.47105) /* Convert to hectares */
lab var farm_size_agland "Land size in hectares, including all plots cultivated or left fallow" 
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_farmsize_all_agland.dta", replace

use "${TZA_W1_raw_data}\Agriculture\SEC_3A.dta", clear
append using "${TZA_W1_raw_data}\Agriculture\SEC_3B.dta"
rename plotnum plot_id
drop if plot_id==""
gen rented_out = (s3aq3==2 | s3aq3==3 | s3bq3==2 | s3bq3==3)
gen cultivated_short = (s3bq3==1)
bys hhid plot_id: egen plot_cult_short = max(cultivated_short)
replace rented_out = 0 if plot_cult_short==1 // If cultivated in short season, not considered rented out in long season.
drop if rented_out==1
gen plot_held = 1
collapse (max) plot_held, by (hhid plot_id)
lab var plot_held "1= Parcel was NOT rented out in the main season"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_parcels_held.dta", replace

use "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_parcels_held.dta", clear
merge 1:1 hhid plot_id using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_plot_areas.dta"
drop if _merge==2
replace area_acres_meas=. if area_acres_meas<0
replace area_acres_meas = area_acres_est if area_acres_meas==. 
collapse (sum) area_acres_meas, by (hhid)
rename area_acres_meas land_size
replace land_size = land_size * (1/2.47105) /* Convert to hectares */
lab var land_size "Land size in hectares, including all plots listed by the household" 
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_land_size_all.dta", replace


************
*FARM LABOR
************

*Farm labor
use "${TZA_W1_raw_data}\Agriculture\SEC_3A.dta", clear  
rename s3aq63_2 landprep_women 
rename s3aq63_1 landprep_men 
rename s3aq63_4 weeding_men 
rename s3aq63_5 weeding_women 
rename s3aq63_7 harvest_men 
rename s3aq63_8 harvest_women 
recode landprep_women landprep_men weeding_men weeding_women harvest_men harvest_women (.=0)
egen days_hired_mainseason = rowtotal(landprep_women landprep_men weeding_men weeding_women harvest_men harvest_women) 
recode s3aq61_1 s3aq61_2 s3aq61_3 s3aq61_4 s3aq61_5 s3aq61_6 s3aq61_7 s3aq61_8 s3aq61_9 s3aq61_10 s3aq61_11 s3aq61_12 (.=0)
egen days_flab_landprep = rowtotal(s3aq61_1 s3aq61_2 s3aq61_3 s3aq61_4 s3aq61_5 s3aq61_6 s3aq61_7 s3aq61_8 s3aq61_9 s3aq61_10 s3aq61_11 s3aq61_12)
recode s3aq61_13 s3aq61_14 s3aq61_15 s3aq61_16 s3aq61_17 s3aq61_18 s3aq61_19 s3aq61_20 s3aq61_21 s3aq61_22 s3aq61_23 s3aq61_24 (.=0)
egen days_flab_weeding = rowtotal(s3aq61_13 s3aq61_14 s3aq61_15 s3aq61_16 s3aq61_17 s3aq61_18 s3aq61_19 s3aq61_20 s3aq61_21 s3aq61_22 s3aq61_23 s3aq61_24)
recode s3aq61_25 s3aq61_26 s3aq61_27 s3aq61_28 s3aq61_29 s3aq61_30 s3aq61_31 s3aq61_32 s3aq61_33 s3aq61_34 s3aq61_35 s3aq61_36 (.=0)
egen days_flab_harvest = rowtotal(s3aq61_25 s3aq61_26 s3aq61_27 s3aq61_28 s3aq61_29 s3aq61_30 s3aq61_31 s3aq61_32 s3aq61_33 s3aq61_34 s3aq61_35 s3aq61_36)
gen days_famlabor_mainseason = days_flab_landprep + days_flab_weeding + days_flab_harvest
ren plotnum plot_id
collapse (sum) days_hired_mainseason days_famlabor_mainseason, by (hhid plot_id)
lab var days_hired_mainseason  "Workdays for hired labor (crops) in main growing season"
lab var days_famlabor_mainseason  "Workdays for family labor (crops) in main growing season"
save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_plot_farmlabor_mainseason.dta", replace

 
use "${TZA_W1_raw_data}\Agriculture\SEC_3B.dta", clear 
rename s3bq63_2 landprep_women 
rename s3bq63_1 landprep_men 
rename s3bq63_4 weeding_men 
rename s3bq63_5 weeding_women 
rename s3bq63_7 harvest_men 
rename s3bq63_8 harvest_women 
recode landprep_women landprep_men weeding_men weeding_women harvest_men harvest_women(.=0)
egen days_hired_shortseason = rowtotal(landprep_women landprep_men weeding_men weeding_women harvest_men harvest_women) 
recode s3bq61_1 s3bq61_2 s3bq61_3 s3bq61_4 s3bq61_5 s3bq61_6 s3bq61_7 s3bq61_8 s3bq61_9 s3bq61_10 s3bq61_11 s3bq61_12 (.=0)
egen days_flab_landprep = rowtotal(s3bq61_1 s3bq61_2 s3bq61_3 s3bq61_4 s3bq61_5 s3bq61_6 s3bq61_7 s3bq61_8 s3bq61_9 s3bq61_10 s3bq61_11 s3bq61_12)
recode s3bq61_13 s3bq61_14 s3bq61_15 s3bq61_16 s3bq61_17 s3bq61_18 s3bq61_19 s3bq61_20 s3bq61_21 s3bq61_22 s3bq61_23 s3bq61_24  (.=0)
egen days_flab_weeding = rowtotal(s3bq61_13 s3bq61_14 s3bq61_15 s3bq61_16 s3bq61_17 s3bq61_18 s3bq61_19 s3bq61_20 s3bq61_21 s3bq61_22 s3bq61_23 s3bq61_24)
recode s3bq61_25 s3bq61_26 s3bq61_27 s3bq61_28 s3bq61_29 s3bq61_30 s3bq61_31 s3bq61_32 s3bq61_33 s3bq61_34 s3bq61_35 s3bq61_36 (.=0)
egen days_flab_harvest = rowtotal(s3bq61_25 s3bq61_26 s3bq61_27 s3bq61_28 s3bq61_29 s3bq61_30 s3bq61_31 s3bq61_32 s3bq61_33 s3bq61_34 s3bq61_35 s3bq61_36)
gen days_famlabor_shortseason = days_flab_landprep + days_flab_weeding + days_flab_harvest
ren plotnum plot_id
collapse (sum) days_hired_shortseason days_famlabor_shortseason, by (hhid plot_id)
lab var days_hired_shortseason  "Workdays for hired labor (crops) in short growing season"
lab var days_famlabor_shortseason  "Workdays for family labor (crops) in short growing season"
save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_plot_farmlabor_shortseason.dta", replace


*Labor
use "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_plot_farmlabor_mainseason.dta", clear
merge 1:1 hhid plot_id using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_plot_farmlabor_shortseason.dta"
drop _merge
recode days*  (.=0)
collapse (sum) days*, by(hhid plot_id)
egen labor_hired =rowtotal(days_hired_mainseason days_hired_shortseason)
egen labor_family=rowtotal(days_famlabor_mainseason  days_famlabor_shortseason)
egen labor_total = rowtotal(days_hired_mainseason days_famlabor_mainseason days_hired_shortseason days_famlabor_shortseason)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm"
lab var labor_hired "Total labor days (hired) allocated to the farm"
lab var labor_family "Total labor days (family) allocated to the farm"
lab var labor_total "Total labor days (hired +family) allocated to the farm"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_plot_family_hired_labor.dta", replace
collapse (sum) labor_*, by(hhid)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm"
lab var labor_hired "Total labor days (hired) allocated to the farm"
lab var labor_family "Total labor days (family) allocated to the farm"
lab var labor_total "Total labor days (hired +family) allocated to the farm" 
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_family_hired_labor.dta", replace
 
***************
*VACCINE USAGE
***************
use "${TZA_W1_raw_data}\Agriculture/SEC_10A.dta", clear
gen vac_animal=.
replace vac_animal=1 if s10aq26==1 | s10aq26==2 
replace vac_animal=0 if s10aq26==3
replace vac_animal=. if s10aq26==.
replace vac_animal=. if animal == 15 //remove vaccinated dogs
replace vac_animal = . if s10aq2 ==2 | s10aq2==. //missing if the household did now own any of these types of animals 

*Disagregating vaccine usage by animal type 
rename animal livestock_code
gen species = (inlist(livestock_code,1,2,3,4,5,6)) + 2*(inlist(livestock_code,7,8)) + 3*(livestock_code==9) + 4*(inlist(livestock_code,13,14)) + 5*(inlist(livestock_code,10,11))
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

save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_vaccine.dta", replace
 

use "${TZA_W1_raw_data}\Agriculture/SEC_10A.dta", clear
gen all_vac_animal=.
replace all_vac_animal=1 if s10aq26==1 | s10aq26==2  
replace all_vac_animal=0 if s10aq26==3
replace all_vac_animal=. if s10aq26==.
replace all_vac_animal=. if s10aq2 ==2 | s10aq2==. //missing if the household did now own any of these types of animals 
replace all_vac_animal=. if animal == 15 //remove vaccinated dogs
   
preserve
keep hhid s10aq5_1 all_vac_animal 
ren s10aq5_1 farmerid
tempfile farmer1
save `farmer1'
restore
preserve
keep hhid  s10aq5_2  all_vac_animal 
ren s10aq5_2 farmerid
tempfile farmer2
save `farmer2'
restore

use   `farmer1', replace
append using  `farmer2'

collapse (max) all_vac_animal , by(hhid farmerid)
gen personid=farmerid
drop if personid==.
merge 1:1 hhid personid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_gender_merge.dta", nogen
lab var all_vac_animal "1 = Individual farmer (livestock keeper) uses vaccines"
ren personid sbmemno
gen livestock_keeper=1 if farmerid!=.
recode livestock_keeper (.=0)
lab var livestock_keeper "1=Indvidual is listed as a livestock keeper (at least one type of livestock)" 
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_farmer_vaccine.dta", replace

 
***************
*USE OF INORGANIC FERTILIZER
***************
use "${TZA_W1_raw_data}/Agriculture/SEC_3A.dta", clear
append using "${TZA_W1_raw_data}/Agriculture/SEC_3B.dta" 
gen use_inorg_fert=.
replace use_inorg_fert=0 if s3aq43==2 | s3bq43==2

replace use_inorg_fert=1 if s3aq43==1 | s3bq43==1  
recode use_inorg_fert (.=0)
collapse (max) use_inorg_fert, by (hhid)
lab var use_inorg_fert "1 = Household uses inorganic fertilizer"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_fert_use.dta", replace
  
use "${TZA_W1_raw_data}/Agriculture/SEC_3A.dta", clear
append using "${TZA_W1_raw_data}/Agriculture/SEC_3B.dta" 
gen all_use_inorg_fert=.
replace all_use_inorg_fert=0 if s3aq43==2 | s3bq43==2

replace all_use_inorg_fert=1 if s3aq43==1 | s3bq43==1  
recode all_use_inorg_fert (.=0)
 
preserve
keep hhid s3aq6_1 s3bq6_1 all_use_inorg_fert 
ren s3aq6_1 farmerid
replace farmerid= s3bq6_1 if farmerid==.
tempfile farmer1
save `farmer1'
restore
preserve
keep hhid s3aq6_2 s3bq6_2 all_use_inorg_fert 
ren s3aq6_2 farmerid
replace farmerid= s3bq6_2 if farmerid==.
tempfile farmer2
save `farmer2'
restore
preserve
keep hhid s3aq6_3 s3bq6_3 all_use_inorg_fert 
ren s3aq6_3 farmerid
replace farmerid= s3bq6_3 if farmerid==.
tempfile farmer3
save `farmer3'
restore
use   `farmer1', replace
append using  `farmer2'
append using  `farmer3'
collapse (max) all_use_inorg_fert , by(hhid farmerid)
gen personid=farmerid
drop if personid==.
merge 1:1 hhid personid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_gender_merge.dta", nogen
lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
ren personid sbmemno  
gen farm_manager=1 if farmerid!=.
recode farm_manager (.=0)
lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_farmer_fert_use.dta", replace
 
*********************
*USE OF IMPROVED SEED
*********************
use "${TZA_W1_raw_data}/Agriculture/SEC_4A.dta", clear 
append using "${TZA_W1_raw_data}/Agriculture/SEC_4B.dta" 

gen imprv_seed_use=.
replace imprv_seed_use = 0 if s4aq22 == 1 | s4bq22 == 1 
replace imprv_seed_use = 1 if s4aq22 == 2 | s4bq22 == 2 
recode imprv_seed_use (.=0)

 * Adoption of improved seeds for top crops
 forvalues k=1/15 {
 	local c : word `k' of $topcrop_area
 	local cn : word `k' of $topcropname_area
 	gen imprv_seed_`cn' = imprv_seed_use if zaocode== `c'
 	gen hybrid_seed_`cn'=. // This instrument does not record hybrid seed use
 }
 collapse (max) imprv_seed_* hybrid_seed_*, by(hhid)
 lab var imprv_seed_use "1 = Household uses improved seed"
 foreach cn in $topcropname_area {
 	lab var imprv_seed_`cn' "1 = Household uses improved `cn' seed"
 	lab var hybrid_seed_`cn' "1 = Household uses hybrid `cn' seed"
 }
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_improvedseed_use.dta", replace
  
use "${TZA_W1_raw_data}/Agriculture/SEC_4A.dta", clear 
merge m:1 hhid plotnum using  "${TZA_W1_raw_data}/Agriculture/SEC_3A.dta", nogen keep(1 3)
preserve
	use "${TZA_W1_raw_data}/Agriculture/SEC_4B.dta", clear
	merge m:1 hhid plotnum using  "${TZA_W1_raw_data}/Agriculture/SEC_3B.dta", nogen keep(1 3)
	tempfile seedb
	save `seedb'
restore
append using `seedb' 
 
gen all_imprv_seed_use=.
replace all_imprv_seed_use = 0 if s4aq22 == 1 | s4bq22 == 1 
replace all_imprv_seed_use = 1 if s4aq22 == 2 | s4bq22 == 2 
recode all_imprv_seed_use (.=0)


save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_farmer_improvedseed_use_temp.dta", replace
*adoption of improved top crop seeds
forvalues k=1/15 {
	use "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_farmer_improvedseed_use_temp.dta", clear
	// Pull out this loops crop and crop code 
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area

	gen all_imprv_seed_`cn'=all_imprv_seed_use if zaocode==`c' 
	gen all_hybrid_seed_`cn' =. // no hybrid seed
	gen `cn'_farmer= zaocode==`c'  

	preserve
	keep hhid s3aq6_1 s3bq6_1 all_imprv_seed_use all_imprv_seed_`cn' all_hybrid_seed_`cn' `cn'_farmer 
	ren s3aq6_1 farmerid
	replace farmerid= s3bq6_1 if farmerid==.
	tempfile farmer1
	save `farmer1'
	restore
	preserve
	keep hhid s3aq6_2 s3bq6_2 all_imprv_seed_use all_imprv_seed_`cn' all_hybrid_seed_`cn' `cn'_farmer 
	ren s3aq6_2 farmerid
	replace farmerid= s3bq6_2 if farmerid==.
	tempfile farmer2
	save `farmer2'
	restore
	preserve
	keep hhid s3aq6_3 s3bq6_3 all_imprv_seed_use all_imprv_seed_`cn' all_hybrid_seed_`cn' `cn'_farmer 
	ren s3aq6_3 farmerid
	replace farmerid= s3bq6_3 if farmerid==.
	tempfile farmer3
	save `farmer3'
	restore

	use   `farmer1', replace
	append using  `farmer2'
	append using  `farmer3' 

	collapse (max) all_imprv_seed_use all_imprv_seed_`cn' all_hybrid_seed_`cn'  `cn'_farmer, by (hhid farmerid)
	save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_farmer_improvedseed_use_temp_`cn'.dta", replace
}

// Combining all crip disaggregated files together.
foreach v in $topcropname_area {
	merge 1:1 hhid farmerid all_imprv_seed_use using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_farmer_improvedseed_use_temp_`v'.dta", nogen
}

gen personid=farmerid
drop if personid==.
merge 1:1 hhid personid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_gender_merge.dta", nogen
lab var all_imprv_seed_use "1 = Individual farmer (plot manager) uses improved seeds"

foreach v in $topcropname_area {
	lab var all_imprv_seed_`v' "1 = Individual farmer (plot manager) uses improved seeds - `v'"
	lab var all_hybrid_seed_`v' "1 = Individual farmer (plot manager) uses hybrid seeds - `v'"
	lab var `v'_farmer "1 = Individual farmer (plot manager) grows `v'"
}
ren personid sbmemno
gen farm_manager=1 if farmerid!=.
recode farm_manager (.=0)
lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_farmer_improvedseed_use.dta", replace



*********************
*REACHED BY AG EXTENSION
*********************
*disaggregate by public and private source
* public : Government
use "${TZA_W1_raw_data}/Agriculture/SEC_13B.dta", clear
ren s13q7 receive_advice
ren itemcode sourceid
preserve
use "${TZA_W1_raw_data}/Agriculture/SEC_13A.dta", clear
ren s13q1 receive_advice
ren source sourceid
replace sourceid=8 if sourceid==5
tempfile TZ_advice2
save `TZ_advice2'
restore
append using  `TZ_advice2'


**Government Extension
gen advice_gov = (sourceid==1 & receive_advice==1)
**NGO
gen advice_ngo = (sourceid==2 & receive_advice==1)
**Cooperative/ Farmer Association
gen advice_coop = (sourceid==3 & receive_advice==1)
**Large Scale Farmer
gen advice_farmer =(sourceid==4 & receive_advice==1)
**Radio
gen advice_radio = (sourceid==5 & receive_advice==1)
**Publication
gen advice_pub = (sourceid==6 & receive_advice==1)
**Neighbor
gen advice_neigh = (sourceid==7 & receive_advice==1)
**Other
gen advice_other = (sourceid==8 & receive_advice==1)
**advice on prices from extension
gen ext_reach_public=(advice_gov==1)
gen ext_reach_private=(advice_ngo==1 | advice_coop==1)
gen ext_reach_unspecified=(advice_radio==1 | advice_pub==1 | advice_other==1)
gen ext_reach_ict=(advice_radio==1)
gen ext_reach_all=(ext_reach_public==1 | ext_reach_private==1 | ext_reach_unspecified==1 | ext_reach_ict==1 )


collapse (max) ext_reach_* , by (hhid)
lab var ext_reach_all "1 = Household reached by extensition services - all sources"
lab var ext_reach_public "1 = Household reached by extensition services - public sources"
lab var ext_reach_private "1 = Household reached by extensition services - private sources"
lab var ext_reach_unspecified "1 = Household reached by extensition services - unspecified sources"
lab var ext_reach_ict "1 = Household reached by extensition services through ICT"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_any_ext.dta", replace
 
*********************
*USE OF FORMAL FINANACIAL SERVICES
*********************
use "${TZA_W1_raw_data}/Household/SEC_P2.dta", clear
gen borrow_bank = spq3==1
gen borrow_micro = spq3==2
gen borrow_mortgage = spq3==3
gen borrow_insurance = spq3==4
gen borrow_other_fin= spq3==5
gen borrow_neigh= spq3==6
gen borrow_employer=spq3==9
gen borrow_ngo= spq3==11

* Credit, Insurance, others 
gen use_fin_serv_credit= borrow_mortgage==1 | borrow_bank==1  | borrow_other_fin==1
gen use_fin_serv_insur= borrow_insurance==1
gen use_fin_serv_others= borrow_other_fin==1
gen use_fin_serv_all= use_fin_serv_credit==1 | use_fin_serv_insur==1 | use_fin_serv_others==1
recode use_fin_serv* (.=0)
collapse (max) use_fin_serv_*, by (hhid)
lab var use_fin_serv_all "1= Household uses formal financial services - all types"
lab var use_fin_serv_credit "1= Household uses formal financial services - credit"
lab var use_fin_serv_insur "1= Household uses formal financial services - insurance"
lab var use_fin_serv_others "1= Household uses formal financial services - others"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_fin_serv.dta", replace


************
*MILK PRODUCTIVITY
************
*Total production
use "${TZA_W1_raw_data}\Agriculture\SEC_10B.dta", clear
keep if lvstkprod == 1 | lvstkprod == 2		
gen months_milked = s10bq2			// average months milked in last year (by holder)
gen liters_month = s10bq3_meas			// average quantity (liters) per day (questionnaire sounds like this question is TOTAL, not per head)

gen liters_milk_produced=months_milked*liters_month 
collapse (sum) liters_milk_produced, by (hhid)
lab var liters_milk_produced "Total quantity (liters) of milk per year (household)"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_milk_animals.dta", replace


************
*EGG PRODUCTIVITY
************
use "${TZA_W1_raw_data}\Agriculture\SEC_10B.dta", clear
keep if lvstkprod == 3 | lvstkprod == 4		// keeping eggs only
drop if s10bq1 == 2
gen eggs_months = s10bq2	// number of months eggs were produced
gen eggs_per_month = s10bq3_meas 			
gen eggs_total_year = eggs_month*eggs_per_month			// eggs per month times number of months produced in last 12 months
collapse (sum) eggs_total_year, by (hhid) 

lab var eggs_total_year "Total number of eggs that was produced (household)"
save "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_eggs_animals.dta", replace



************
*CROP PRODUCTION COSTS PER HECTARE
************
*Constructed using both implicit and explicit costs and only main rainy season (meher)
*NOTE: There's some overlap with crop production expenses above, but this is because the variables were created separately.

 
*Land rental rates*
*********
*  LRS  *
*********
use "${TZA_W1_raw_data}/Agriculture/SEC_2A.dta", clear
drop if plotnum==""
gen plot_ha = area/2.47105							// ag2a_09 is GPS-measured area in acres
replace plot_ha = s2aq4/2.47105 if plot_ha==.			// replace with farmer-reported if missing (also in acres)
keep plot_ha plotnum hhid
ren plotnum plot_id
save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_plot_area_lrs.dta", replace
*Getting plot rental rate
use "${TZA_W1_raw_data}/Agriculture/SEC_3A.dta", clear
ren plotnum plot_id
merge 1:1 plot_id hhid using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_plot_area_lrs.dta" , nogen		
drop if plot_id==""
gen cultivated = s3aq3==1
merge m:1 hhid plot_id using  "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_plot_decision_makers.dta", nogen keep (1 3)
*Total rent - rescaling to a YEARLY value
*NOTE: Although this is yearly, we shouldn't be double counting plots. We merge LRS into SRS first, then only match SRS to SRS if missing.
tab s3aq31_idadi s3aq31_meas, nol
gen plot_rental_rate = s3aq30*(12/s3aq31_idadi) if s3aq31_meas==1			// if monthly (scaling up by number of months; all observations are <=12)
replace plot_rental_rate = s3aq30*(1/s3aq31_idadi) if s3aq31_meas==2		// if yearly (scaling down by number of years; all observations are >=1)
recode plot_rental_rate (0=.) 
save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_rent_nomiss_lrs.dta", replace				

preserve
	gen value_rented_land_male = plot_rental_rate if dm_gender==1
	gen value_rented_land_female = plot_rental_rate if dm_gender==2
	gen value_rented_land_mixed = plot_rental_rate if dm_gender==3
	collapse (sum) value_rented_land_* value_rented_land = plot_rental_rate, by(hhid)
	save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_rental_rate_lrs.dta", replace
restore

gen ha_rental_rate_hh = plot_rental_rate/plot_ha
recode ha_rental_rate_hh (0=.) 

preserve
	keep if plot_rental_rate!=. & plot_rental_rate!=0			// keeping only plots that were rented (not zero and not missing)
	collapse (sum) plot_rental_rate plot_ha, by(hhid)		// summing to household level (only plots that were rented)
	gen ha_rental_hh_lrs = plot_rental_rate/plot_ha				// household specific rental rate
	keep ha_rental_hh_lrs hhid
	save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_rental_rate_hhid_lrs.dta", replace
restore

*Merging in geographic variables
merge m:1 hhid using "${TZA_W1_raw_data}/Household/SEC_A_T.dta", nogen assert(2 3) keep(3)	
*Geographic medians
bys region district ward ea: egen ha_rental_count_vil = count(ha_rental_rate_hh)
bys region district ward ea: egen ha_rental_rate_vil = median(ha_rental_rate_hh)
bys region district ward: egen ha_rental_count_ward = count(ha_rental_rate_hh)
bys region district ward: egen ha_rental_rate_ward = median(ha_rental_rate_hh)
bys region district: egen ha_rental_count_dist = count(ha_rental_rate_hh)
bys region district: egen ha_rental_rate_dist = median(ha_rental_rate_hh)
bys region: egen ha_rental_count_reg = count(ha_rental_rate_hh)
bys region: egen ha_rental_rate_reg = median(ha_rental_rate_hh)
egen ha_rental_rate_nat = median(ha_rental_rate_hh)
*Now, getting median rental rate at the lowest level of aggregation with at least ten observations
gen ha_rental_rate = ha_rental_rate_vil if ha_rental_count_vil>=10		
replace ha_rental_rate = ha_rental_rate_ward if ha_rental_count_ward>=10 & ha_rental_rate==.	
replace ha_rental_rate = ha_rental_rate_dist if ha_rental_count_dist>=10 & ha_rental_rate==.	
replace ha_rental_rate = ha_rental_rate_reg if ha_rental_count_reg>=10 & ha_rental_rate==.		
replace ha_rental_rate = ha_rental_rate_nat if ha_rental_rate==.				
collapse (firstnm) ha_rental_rate, by(region district ward) 
save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_rental_rate_lrs.dta", replace

*  SRS  *
use "${TZA_W1_raw_data}/Agriculture/SEC_2B.dta", clear
drop if plotnum==""
gen plot_ha = area/2.47105						// ag2a_09 is GPS-measured area in acres
replace plot_ha = s2bq9/2.47105 if plot_ha==.		// replacing with farmer-reported if missing
keep plot_ha plotnum hhid
ren plotnum plot_id
save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_plot_area_srs.dta", replace
*Getting plot rental rate
use "${TZA_W1_raw_data}/Agriculture/SEC_3B.dta", clear
drop if plotnum==""
gen cultivated = s3bq3==1
ren  plotnum plot_id
merge m:1 hhid plot_id using  "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_plot_decision_makers.dta", nogen 
merge 1:1 plot_id hhid using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_plot_area_lrs.dta", nogen					
merge 1:1 plot_id hhid using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_plot_area_srs.dta", nogen update replace		
*Total rent - rescaling to a YEARLY value
tab s3bq31_idadi s3bq31_meas, nol					// Questions ONLY for new plots
gen plot_rental_rate = s3bq30*(12/s3bq31_idadi) if s3bq31_meas==1			// if monthly (scaling up by number of months)
replace plot_rental_rate = s3bq30*(1/s3bq31_idadi) if s3bq31_meas==2		// if yearly (scaling down by number of years)
recode plot_rental_rate (0=.)
save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_rent_nomiss_srs.dta", replace
preserve
	gen value_rented_land_male = plot_rental_rate if dm_gender==1
	gen value_rented_land_female = plot_rental_rate if dm_gender==2
	gen value_rented_land_mixed = plot_rental_rate if dm_gender==3
	collapse (sum) value_rented_land_* value_rented_land = plot_rental_rate, by(hhid)
	save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_rental_rate_srs.dta", replace
restore
gen ha_rental_rate_hh = plot_rental_rate/plot_ha
recode ha_rental_rate_hh (0=.) 
preserve
	keep if plot_rental_rate!=. & plot_rental_rate!=0			// keeping only plots that were rented (not zero and not missing)
	collapse (sum) plot_rental_rate plot_ha, by(hhid)		// summing to household level (only plots that were rented)
	gen ha_rental_hh_srs = plot_rental_rate/plot_ha				// household specific rental rate
	keep ha_rental_hh_srs hhid
	save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_rental_rate_hhid_srs.dta", replace
restore
*Merging in geographic variables
merge m:1 hhid using "${TZA_W1_raw_data}/Household/SEC_A_T.dta", nogen assert(2 3) keep(3)	
*Geographic medians
bys region district ward ea: egen ha_rental_count_vil = count(ha_rental_rate_hh)
bys region district ward ea: egen ha_rental_rate_vil = median(ha_rental_rate_hh)
bys region district ward: egen ha_rental_count_ward = count(ha_rental_rate_hh)
bys region district ward: egen ha_rental_rate_ward = median(ha_rental_rate_hh)
bys region district: egen ha_rental_count_dist = count(ha_rental_rate_hh)
bys region district: egen ha_rental_rate_dist = median(ha_rental_rate_hh)
bys region: egen ha_rental_count_reg = count(ha_rental_rate_hh)
bys region: egen ha_rental_rate_reg = median(ha_rental_rate_hh)
egen ha_rental_rate_nat = median(ha_rental_rate_hh)
*Now, getting median rental rate at the lowest level of aggregation with at least ten observations
gen ha_rental_rate = ha_rental_rate_vil if ha_rental_count_vil>=10		
replace ha_rental_rate = ha_rental_rate_ward if ha_rental_count_ward>=10 & ha_rental_rate==.	
replace ha_rental_rate = ha_rental_rate_dist if ha_rental_count_dist>=10 & ha_rental_rate==.	
replace ha_rental_rate = ha_rental_rate_reg if ha_rental_count_reg>=10 & ha_rental_rate==.		
replace ha_rental_rate = ha_rental_rate_nat if ha_rental_rate==.				
collapse (firstnm) ha_rental_rate_srs = ha_rental_rate, by(region district ward) 
save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_rental_rate_srs.dta", replace


*Now getting total ha of all plots that were cultivated at least once
use "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_rent_nomiss_lrs.dta", clear
append using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_rent_nomiss_srs.dta"
collapse (max) cultivated plot_ha, by(hhid plot_id)		// collapsing down to household-plot level
gen ha_cultivated_plots = plot_ha if cultivate==1			// non-missing only if plot was cultivated in at least one season
collapse (sum) ha_cultivated_plots, by(hhid)				// total ha of all plots that were cultivated in at least one season
save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_cultivated_plots_ha.dta", replace

use "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_rental_rate_lrs.dta", clear
append using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_rental_rate_srs.dta"
collapse (sum) value_rented_land*, by(hhid)		// total over BOTH seasons (total spent on rent over course of entire year)
lab var value_rented_land "Value of rented land (household expenditures)"
lab var value_rented_land_male "Value of rented land (household expenditures - male-managed plots)"
lab var value_rented_land_female "Value of rented land (household expenditures - female-managed plots)"
lab var value_rented_land_mixed "Value of rented land (household expenditures - mixed-managed plots)"
save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_rental_rate.dta", replace


*Now getting area planted
*  LRS  *
use "${TZA_W1_raw_data}/Agriculture/SEC_4A.dta", clear
drop if plotnum==""
ren  plotnum plot_id
merge m:1 hhid plot_id using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_rent_nomiss_lrs.dta", nogen keep(1 3)
*First rescaling
gen percent_plot = 0.25*(s4aq4==.25) + 0.25*(s4aq4==1) + 0.5*(s4aq4==2) + 0.75*(s4aq4==3)
replace percent_plot = 1 if s4aq3==1
bys hhid plot_id: egen total_percent_plot = total(percent_plot)		// total "percent" of plot planted
replace percent_plot = percent_plot*(1/total_percent_plot) if total_percent_plot>1 & total_percent_plot!=.	// rescaling (down) if total percent is larger than 1
*Merging in total plot area from previous module
merge m:1 plot_id hhid using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_plot_area_lrs", nogen assert(2 3) keep(3)		
gen ha_planted = percent_plot*plot_ha
gen ha_planted_male = ha_planted if dm_gender==1
gen ha_planted_female = ha_planted if dm_gender==2
gen ha_planted_mixed = ha_planted if dm_gender==3
*Merging in geographic variables
merge m:1 hhid using "${TZA_W1_raw_data}/Household/SEC_A_T.dta", nogen assert(2 3) keep(3)		
*Now merging in aggregate rental costs
merge m:1 region district ward using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_rental_rate_lrs", nogen keep(3)	
*Now merging in rental costs of individual plots
merge m:1 hhid plot_id using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_rent_nomiss_lrs.dta", nogen keep(1 3)
*Now merging in household rental rate
merge m:1 hhid using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_rental_rate_hhid_lrs.dta", nogen keep(1 3)
gen value_owned_land = ha_planted*ha_rental_rate if s3aq30==0 | s3aq30==.		
replace value_owned_land = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (s3aq30==0 | s3aq30==.)	
*Now creating gender value
gen value_owned_land_male = ha_planted*ha_rental_rate if (s3aq30==0 | s3aq30==.) & dm_gender==1
replace value_owned_land_male = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (s3aq30==0 | s3aq30==.) & dm_gender==1
*Female
gen value_owned_land_female = ha_planted*ha_rental_rate if (s3aq30==0 | s3aq30==.) & dm_gender==2
replace value_owned_land_female = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (s3aq30==0 | s3aq30==.) & dm_gender==2
*Mixed
gen value_owned_land_mixed = ha_planted*ha_rental_rate if (s3aq30==0 | s3aq30==.) & dm_gender==3
replace value_owned_land_mixed = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (s3aq30==0 | s3aq30==.) & dm_gender==3
collapse (sum) value_owned_land* ha_planted*, by(hhid plot_id)			
save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_cost_land_lrs.dta", replace


*  SRS  *
*Now getting area planted
use "${TZA_W1_raw_data}/Agriculture/SEC_4B.dta", clear
drop if plotnum==""
ren plotnum plot_id 
merge m:1 hhid plot_id using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_rent_nomiss_lrs.dta", nogen keep(1 3) keepusing(dm_gender)
merge m:1 hhid plot_id using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_rent_nomiss_srs.dta", nogen keep(1 3) keepusing(dm_gender) update
*First rescaling
gen percent_plot = 0.25*(s4bq4==1) + 0.5*(s4bq4==2) + 0.75*(s4bq4==3)
replace percent_plot = 1 if s4bq3==1
bys hhid plot_id: egen total_percent_plot = total(percent_plot)
replace percent_plot = percent_plot*(1/total_percent_plot) if total_percent_plot>1 & total_percent_plot!=.	// rescaling if total percent is larger than 1
*Merging in total plot area
merge m:1 plot_id hhid using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_plot_area_lrs", nogen keep(1 3) keepusing(plot_ha)						
merge m:1 plot_id hhid using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_plot_area_srs", nogen keepusing(plot_ha) update							
gen ha_planted = percent_plot*plot_ha
gen ha_planted_male = ha_planted if dm_gender==1
gen ha_planted_female = ha_planted if dm_gender==2
gen ha_planted_mixed = ha_planted if dm_gender==3
*Merging in geographic variables
merge m:1 hhid using "${TZA_W1_raw_data}/Household/SEC_A_T.dta", nogen assert(2 3) keep(3)		
*Now merging in rental costs
merge m:1 region district ward using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_rental_rate_lrs", nogen keep(3)			
*Now merging in rental costs actually incurred by household
merge m:1 hhid plot_id using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_rent_nomiss_lrs.dta", nogen keep(1 3)
*Now merging in household rental rate
merge m:1 hhid using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_rental_rate_hhid_lrs.dta", nogen keep(1 3)		
merge m:1 hhid using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_rental_rate_hhid_srs.dta", nogen	update			
gen value_owned_land = ha_planted*ha_rental_rate if s3aq30==0 | s3aq30==.		
replace value_owned_land = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (s3aq30==0 | s3aq30==.)		
*Now creating gender value
gen value_owned_land_male = ha_planted*ha_rental_rate if (s3aq30==0 | s3aq30==.) & dm_gender==1
replace value_owned_land_male = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (s3aq30==0 | s3aq30==.) & dm_gender==1
*Female
gen value_owned_land_female = ha_planted*ha_rental_rate if (s3aq30==0 | s3aq30==.) & dm_gender==2
replace value_owned_land_female = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (s3aq30==0 | s3aq30==.) & dm_gender==2
*Mixed
gen value_owned_land_mixed = ha_planted*ha_rental_rate if (s3aq30==0 | s3aq30==.) & dm_gender==3
replace value_owned_land_mixed = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (s3aq30==0 | s3aq30==.) & dm_gender==3

collapse (sum) value_owned_land* ha_planted*, by(hhid plot_id)			
append using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_cost_land_lrs.dta"					

preserve
	*We also want to create a total area planted variable, double counting plots, for fertilizer application rate
	collapse (sum) ha_planted*, by(hhid)
	save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_ha_planted_total.dta", replace
restore
collapse (sum) ha_planted* value_owned_land*, by(hhid plot_id)			// taking max area planted (and value owned) by plot so as to not double count plots that were planted in both seasons
collapse (sum) ha_planted* value_owned_land*, by(hhid)					// now summing to household

lab var value_owned_land "Value of owned land that was cultivated (household)"
lab var value_owned_land_male "Value of owned land (male-managed plots)"
lab var value_owned_land_female "Value of owned land (female-managed plots)"
lab var value_owned_land_mixed "Value of owned land (mixed-managed plots)"
lab var ha_planted "Area planted (household)"
lab var ha_planted_male "Area planted (male-managed plots)"
lab var ha_planted_female "Area planted (female-managed plots)"
lab var ha_planted_mixed "Area planted (mixed-managed plots)"
save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_cost_land.dta", replace



*****************
*Now input costs*
*****************
*********
*  LRS  *
*********
use "${TZA_W1_raw_data}/Agriculture/SEC_3A.dta", clear
drop if plotnum==""			
*Merging in geographic variables first (for constructing prices)
merge m:1 hhid using "${TZA_W1_raw_data}/Household/SEC_A_T.dta", nogen assert(2 3) keep(3)		
*Gender variables
ren  plotnum plot_id
merge m:1 hhid plot_id using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_rent_nomiss_lrs.dta", nogen keep(1 3) keepusing(dm_gender)

*Starting with fertilizer
gen value_inorg_fert_lrs = s3aq46	
gen value_herb_pest_lrs = s3aq52			
gen value_org_purchased_lrs = s3aq41						

preserve
	gen fert_org_kg = s3aq38		
	gen fert_inorg_kg = s3aq45		
	gen fert_inorg_kg_male = fert_inorg_kg if dm_gender==1
	gen fert_inorg_kg_female = fert_inorg_kg if dm_gender==2
	gen fert_inorg_kg_mixed = fert_inorg_kg if dm_gender==3
	collapse (sum) fert_org_kg fert_inorg_kg*, by(hhid)
	save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_fert_lrs.dta", replace
restore

*For organic fertilizer value, we need to construct prices (note that there are relatively few prices, so many will be at higher levels of aggregation)
recode s3aq38 s3aq40 (.=0)						
gen org_fert_notpurchased = s3aq38-s3aq40			
replace org_fert_notpurchased = 0 if org_fert_notpurchased<0			
gen org_fert_purchased = s3aq40					
gen org_fert_price = s3aq41/org_fert_purchased
recode org_fert_price (0=.)
		

*Household-specific value
preserve
	keep if org_fert_purchased!=0 & org_fert_purchased!=.		// keeping only plots that had purchased organic fertilizer
	collapse (sum) org_fert_purchased s3aq41, by(hhid)		// total kg purchased and total paid
	gen org_fert_price_hh = s3aq41/org_fert_purchased
	save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_org_fert_lrs.dta", replace
restore
merge m:1 hhid using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_org_fert_lrs.dta", nogen

*Geographic medians
bys region district ward ea: egen org_price_count_vil = count(org_fert_price)
bys region district ward ea: egen org_price_vil = median(org_fert_price) 
bys region district ward: egen org_price_count_ward = count(org_fert_price)
bys region district ward: egen org_price_ward = median(org_fert_price) 
bys region district: egen org_price_count_dist = count(org_fert_price)
bys region district: egen org_price_dist = median(org_fert_price) 
bys region: egen org_price_count_reg = count(org_fert_price)
bys region: egen org_price_reg = median(org_fert_price)
egen org_price_nat = median(org_fert_price)
drop org_fert_price
gen org_fert_price = org_price_vil if org_price_count_vil>=10
replace org_fert_price = org_price_ward if org_price_count_ward>=10 & org_fert_price==.
replace org_fert_price = org_price_dist if org_price_count_dist>=10 & org_fert_price==.
replace org_fert_price = org_price_reg if org_price_count_reg>=10 & org_fert_price==.
replace org_fert_price = org_price_nat if org_fert_price==.			
replace org_fert_price = org_fert_price_hh if org_fert_price_hh!=. & org_fert_price_hh!=0		// replace with household-level price when available

gen value_org_notpurchased_lrs = org_fert_price*org_fert_notpurchased						// total value not purchased

*Hired labor // No Child Labor captured
egen prep_labor = rowtotal(s3aq63_1 s3aq63_2)		// we have to include male, female, labor together (cannot disaggregate wages)
egen weed_labor = rowtotal(s3aq63_4 s3aq63_5)		// we have to include male, female,  labor together (cannot disaggregate wages)
egen harv_labor = rowtotal(s3aq63_7 s3aq63_8)	// we have to include male, female, labor together (cannot disaggregate wages)

*Hired wages:
gen prep_wage = s3aq63_3/prep_labor
gen weed_wage = s3aq63_6/weed_labor
gen harv_wage = s3aq63_9/harv_labor

*Hired costs
gen prep_labor_costs = s3aq63_3
gen weed_labor_costs = s3aq63_6
gen harv_labor_costs = s3aq63_9

egen value_hired_labor_prep_lrs = rowtotal(*_labor_costs)

*Constructing a household-specific wage
preserve
	collapse (sum) prep_labor weed_labor harv_labor *labor_costs, by(hhid)	
	gen prep_wage_hh = prep_labor_costs/prep_labor								
	gen weed_wage_hh = weed_labor_costs/weed_labor
	gen harv_wage_hh = harv_labor_costs/harv_labor
	recode *wage* (0=.)		
	save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_wages_hh_lrs.dta", replace
restore

merge m:1 hhid using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_wages_hh_lrs.dta", nogen

*Going to construct wages separately for each type
*Constructing for each labor type
foreach i in prep weed harv{
	recode `i'_wage (0=.) 
	bys region district ward ea: egen `i'_wage_count_vil = count(`i'_wage)
	bys region district ward ea: egen `i'_wage_price_vil = median(`i'_wage)
	bys region district ward: egen `i'_wage_count_ward = count(`i'_wage)
	bys region district ward: egen `i'_wage_price_ward = median(`i'_wage)
	bys region district: egen `i'_wage_count_dist = count(`i'_wage)
	bys region district: egen `i'_wage_price_dist = median(`i'_wage)
	bys region: egen `i'_wage_count_reg = count(`i'_wage)
	bys region: egen `i'_wage_price_reg = median(`i'_wage)
	egen `i'_wage_price_nat = median(`i'_wage)
	
	*Creating wage rate
	gen `i'_wage_rate = `i'_wage_price_vil if `i'_wage_count_vil>=10
	replace `i'_wage_rate = `i'_wage_price_ward if `i'_wage_count_ward>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_wage_price_dist if `i'_wage_count_dist>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_wage_price_reg if `i'_wage_count_reg>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_wage_price_nat if `i'_wage_rate==.
}

*Since we have to construct a single wage variable, we do not need to disaggregate family labor by gender (or age)
*prep
egen prep_fam_labor_tot = rowtotal(s3aq61_1 s3aq61_2 s3aq61_3 s3aq61_4 s3aq61_5 s3aq61_6 s3aq61_7 s3aq61_8 s3aq61_9 s3aq61_10 s3aq61_11 s3aq61_12)
*weed
egen weed_fam_labor_tot = rowtotal(s3aq61_13 s3aq61_14 s3aq61_15 s3aq61_16 s3aq61_17 s3aq61_18 s3aq61_19 s3aq61_20 s3aq61_21 s3aq61_22 s3aq61_23 s3aq61_24)
*prep
egen harv_fam_labor_tot = rowtotal(s3aq61_25 s3aq61_26 s3aq61_27 s3aq61_28 s3aq61_29 s3aq61_30 s3aq61_31 s3aq61_32 s3aq61_33 s3aq61_34 s3aq61_35 s3aq61_36)

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

collapse (sum) value_*, by(hhid)
save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_cost_inputs_lrs.dta", replace


*********
*  SRS  *
*********
use "${TZA_W1_raw_data}/Agriculture/SEC_3B.dta", clear
drop if plotnum==""
*Merging in geographic variables first (for constructing prices)
merge m:1 hhid using "${TZA_W1_raw_data}/Household/SEC_A_T.dta", nogen assert(2 3) keep(3)			
*Gender variables
ren plotnum plot_id
merge m:1 hhid plot_id using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_rent_nomiss_lrs.dta", nogen keep(1 3) keepusing(dm_gender)

*Starting with fertilizer
gen value_inorg_fert_srs = s3bq46
gen value_herb_pest_srs = s3bq52
gen value_org_purchased_srs = s3bq41

preserve
	gen fert_org_kg = s3bq38
	gen fert_inorg_kg = s3bq45
	gen fert_inorg_kg_male = fert_inorg_kg if dm_gender==1
	gen fert_inorg_kg_female = fert_inorg_kg if dm_gender==2
	gen fert_inorg_kg_mixed = fert_inorg_kg if dm_gender==3
	collapse (sum) fert_org_kg fert_inorg_kg*, by(hhid)
	save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_fert_srs.dta", replace
restore

*For organic fertilizer value, we need to construct prices
recode s3bq38 s3bq40 (.=0)
gen org_fert_notpurchased = s3bq38-s3bq40			
replace org_fert_notpurchased = 0 if org_fert_notpurchased<0		
gen org_fert_purchased = s3bq40					
gen org_fert_price = s3bq41/org_fert_purchased		
recode org_fert_price (0=.) 

*Household-specific value
preserve
	keep if org_fert_purchased!=0 & org_fert_purchased!=.		// keeping only plots that had purchased organic fertilizer
	collapse (sum) org_fert_purchased s3bq41, by(hhid)		// total kg purchased and total paid
	gen org_fert_price_hh = s3bq41/org_fert_purchased
	save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_org_fert_srs.dta", replace
restore
merge m:1 hhid using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_org_fert_srs.dta", nogen

*Geographic medians
bys region district ward ea: egen org_price_count_vil = count(org_fert_price)
bys region district ward ea: egen org_price_vil = median(org_fert_price) 
bys region district ward: egen org_price_count_ward = count(org_fert_price)
bys region district ward: egen org_price_ward = median(org_fert_price) 
bys region district: egen org_price_count_dist = count(org_fert_price)
bys region district: egen org_price_dist = median(org_fert_price) 
bys region: egen org_price_count_reg = count(org_fert_price)
bys region: egen org_price_reg = median(org_fert_price)
egen org_price_nat = median(org_fert_price)
drop org_fert_price
gen org_fert_price = org_price_vil if org_price_count_vil>=10
replace  org_fert_price = org_price_ward if org_price_count_ward>=10 & org_fert_price==.
replace org_fert_price = org_price_dist if org_price_count_dist>=10 & org_fert_price==.
replace org_fert_price = org_price_reg if org_price_count_reg>=10 & org_fert_price==.
replace org_fert_price = org_price_nat if org_fert_price==.		
replace org_fert_price = org_fert_price_hh if org_fert_price_hh!=. & org_fert_price_hh!=0		// replace with household-level price when available

gen value_org_notpurchased_srs = org_fert_price*org_fert_notpurchased						// total value not purchased

*Hired labor // no child labor
egen prep_labor = rowtotal(s3bq63_1 s3bq63_2)		// we have to include male, female, and child labor together (cannot disaggregate wages)
egen weed_labor = rowtotal(s3bq63_4 s3bq63_5)		// we have to include male, female, and child labor together (cannot disaggregate wages)
egen harv_labor = rowtotal(s3bq63_7 s3bq63_8)	// we have to include male, female, and child labor together (cannot disaggregate wages)

*Hired wages:
gen prep_wage = s3bq63_3/prep_labor
gen weed_wage = s3bq63_6/weed_labor
gen harv_wage = s3bq63_9/harv_labor

*Hired costs
gen prep_labor_costs = prep_labor*prep_wage
gen weed_labor_costs = weed_labor*weed_wage
gen harv_labor_costs = harv_labor*harv_wage

egen value_hired_labor_prep_srs = rowtotal(*_labor_costs)

*Constructing a household-specific wage
preserve
	collapse (sum) prep_labor weed_labor harv_labor *labor_costs, by(hhid)
	gen prep_wage_hh = prep_labor_costs/prep_labor			
	gen weed_wage_hh = weed_labor_costs/weed_labor
	gen harv_wage_hh = harv_labor_costs/harv_labor
	recode *wage* (0=.)
	save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_wages_hh_srs.dta", replace
restore

merge m:1 hhid using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_wages_hh_srs.dta", nogen

*Going to construct wages separately for each type
*Constructing for each labor type
foreach i in prep weed harv{
	recode `i'_wage (0=.) 
	bys region district ward ea: egen `i'_wage_count_vil = count(`i'_wage)
	bys region district ward ea: egen `i'_wage_price_vil = median(`i'_wage)
	bys region district ward: egen `i'_wage_count_ward = count(`i'_wage)
	bys region district ward: egen `i'_wage_price_ward = median(`i'_wage)
	bys region district: egen `i'_wage_count_dist = count(`i'_wage)
	bys region district: egen `i'_wage_price_dist = median(`i'_wage)
	bys region: egen `i'_wage_count_reg = count(`i'_wage)
	bys region: egen `i'_wage_price_reg = median(`i'_wage)
	egen `i'_wage_price_nat = median(`i'_wage)
	
	*Creating wage rate
	gen `i'_wage_rate = `i'_wage_price_vil if `i'_wage_count_vil>=10
	replace `i'_wage_rate = `i'_wage_price_ward if `i'_wage_count_ward>=10 
	replace `i'_wage_rate = `i'_wage_price_dist if `i'_wage_count_dist>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_wage_price_reg if `i'_wage_count_reg>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_wage_price_nat if `i'_wage_rate==.
}


*Since we have to construct a single wage variable, we do not need to disaggregate family labor by gender
*prep
egen prep_fam_labor_tot = rowtotal(s3bq61_1 s3bq61_2 s3bq61_3 s3bq61_4 s3bq61_5 s3bq61_6 s3bq61_7 s3bq61_8 s3bq61_9 s3bq61_10 s3bq61_11 s3bq61_12)
*weed
egen weed_fam_labor_tot = rowtotal(s3bq61_13 s3bq61_14 s3bq61_15 s3bq61_16 s3bq61_17 s3bq61_18 s3bq61_19 s3bq61_20 s3bq61_21 s3bq61_22 s3bq61_23 s3bq61_24)
*prep
egen harv_fam_labor_tot = rowtotal(s3bq61_25 s3bq61_26 s3bq61_27 s3bq61_28 s3bq61_29 s3bq61_30 s3bq61_31 s3bq61_32 s3bq61_33 s3bq61_34 s3bq61_35 s3bq61_36)
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

collapse (sum) value_*, by(hhid)
save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_cost_inputs_srs.dta", replace

use  "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_cost_inputs_lrs.dta", clear
append using  "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_cost_inputs_srs.dta"
collapse (sum) value_*, by(hhid)

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
use "${TZA_W1_raw_data}/Agriculture/SEC_4A.dta", clear
drop if plotnum==""
ren plotnum plot_id
merge m:1 hhid plot_id using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_rent_nomiss_lrs.dta", nogen keep(1 3) keepusing(dm_gender)

*Household-specific values
preserve
	drop if s4aq20==0 | s4aq20==.				
	collapse (sum) s4aq20, by(hhid zaocode)
	save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_seeds_hh_lrs.dta", replace
restore
merge m:1 hhid zaocode using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_seeds_hh_lrs.dta", nogen

gen value_seeds_purchased_lrs = s4aq20
rename *_lrs *

foreach i in value_seeds_purchased {   
	gen `i'_male = `i' if dm_gender==1
	gen `i'_female = `i' if dm_gender==2
	gen `i'_mixed = `i' if dm_gender==3
}

collapse (sum) value_* , by(hhid)

save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_cost_seed_lrs.dta", replace

*********
*  SRS  *
*********
use "${TZA_W1_raw_data}/Agriculture/SEC_4B.dta", clear
drop if plotnum==""
ren plotnum plot_id
merge m:1 hhid plot_id using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_rent_nomiss_lrs.dta", nogen keep(1 3) keepusing(dm_gender)

*Household-specific values
preserve
	drop if s4bq20==0 | s4bq20==.				
	collapse (sum) s4bq20, by(hhid zaocode)   
	save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_seeds_hh_srs.dta", replace
restore
merge m:1 hhid zaocode using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_seeds_hh_srs.dta", nogen

gen value_seeds_purchased_srs = s4bq20
rename *_srs *

foreach i in value_seeds_purchased { 
	gen `i'_male = `i' if dm_gender==1
	gen `i'_female = `i' if dm_gender==2
	gen `i'_mixed = `i' if dm_gender==3
}

collapse (sum) value_* , by(hhid)

save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_cost_seed_srs.dta", replace


*Rental of agricultural tools, machines, animal traction
use "${TZA_W1_raw_data}\Agriculture\SEC_11_ALL.dta", clear
gen animal_traction = (impcode>=3 & impcode<=6)
gen ag_asset = (impcode<3 | impcode>9)
gen tractor = (impcode>=7 & impcode<=9)
rename s11q9 rental_cost
gen rental_cost_animal_traction = rental_cost if animal_traction==1
gen rental_cost_ag_asset = rental_cost if ag_asset==1
gen rental_cost_tractor = rental_cost if tractor==1
recode rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor (.=0)
collapse (sum) rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor, by (hhid)
lab var rental_cost_animal_traction "Costs for renting animal traction"
lab var rental_cost_ag_asset "Costs for renting other agricultural items"
lab var rental_cost_tractor "Costs for renting a tractor"
egen value_ag_rentals = rowtotal(rental_cost_*)
lab var value_ag_rentals "Value of rented equipment (household level"
save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_asset_rental_costs.dta", replace

* merging cost variable together
use "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_cost_land.dta", clear
append using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_rental_rate.dta"
append using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_cost_inputs_lrs.dta"
append using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_cost_inputs_srs.dta"
append using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_cost_seed_lrs.dta"
append using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_cost_seed_srs.dta"
append using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_asset_rental_costs.dta"
collapse (sum) value_* ha_planted*, by(hhid)

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


*Creating total costs by gender (NOTE: excludes ag_rentals because those are at the household level)
egen cost_total=rowtotal(value_owned_land value_rented_land value_inorg_fert value_herb_pest value_org_purchased ///
	value_org_notpurchased value_hired_labor value_fam_labor value_seeds_purchased)
lab var cost_total "Explicit + implicit costs of crop production (plot level)"

foreach i in male female mixed{
	egen cost_total_`i' = rowtotal(value_owned_land_`i' value_rented_land_`i' value_inorg_fert_`i' value_herb_pest_`i' value_org_purchased_`i' /// 
	value_org_notpurchased_`i' value_hired_labor_`i' value_fam_labor_`i' value_seeds_purchased_`i')
	lab var cost_total_`i' "Explicit + implicit costs of crop production (`i'-managed plots)"
}

*Explicit costs at the plot level 
egen cost_expli =rowtotal(value_rented_land value_inorg_fert value_herb_pest value_org_purchased value_hired_labor value_seeds_purchased)
lab var cost_expli "Explicit costs of crop production (plot level)" 

*Creating explicit costs by gender
foreach i in male female mixed{
	egen cost_expli_`i' = rowtotal( value_rented_land_`i' value_inorg_fert_`i' value_herb_pest_`i' value_org_purchased_`i' value_hired_labor_`i' value_seeds_purchased_`i')
	lab var cost_expli_`i' "Explicit costs of crop production (`i'-managed plots)"
}


// Explicit costs at the household level
egen cost_expli_hh = rowtotal(value_ag_rentals value_rented_land value_inorg_fert value_herb_pest value_org_purchased value_hired_labor value_seeds_purchased)
lab var cost_expli_hh "Total explicit crop production (household level)" 
count if cost_expli_hh==0		

// Recoding zeros as missings
recode cost_total* cost_expli* cost_expli_hh* (0=.)

keep hhid cost_total cost_total_* cost_expli cost_expli_* cost_expli_hh ha_planted ha_planted_*

save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_cropcosts_perha.dta", replace


************
*RATE OF FERTILIZER APPLICATION
************
use "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_cost_land_lrs.dta", clear
append using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_fert_lrs.dta"
append using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_fert_srs.dta"
collapse (sum) ha_planted* fert_org_kg* fert_inorg_kg*, by(hhid)
merge m:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hhids.dta", keep (1 3) nogen
drop ha_planted*
lab var fert_inorg_kg "Quantity of fertilizer applied (kgs) (household level)"
lab var fert_inorg_kg_male "Quantity of fertilizer applied (kgs) (male-managed plots)"
lab var fert_inorg_kg_female "Quantity of fertilizer applied (kgs) (female-managed plots)"
lab var fert_inorg_kg_mixed "Quantity of fertilizer applied (kgs) (mixed-managed plots)"
save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_fertilizer_application.dta", replace


************
*WOMEN'S DIET QUALITY
************
*Women's diet quality: proportion of women consuming nutrient-rich foods (%)
*Information not available


************
*HOUSEHOLD'S DIET DIVERSITY SCORE
************
* TZA LSMS does not report individual consumption but instead household level consumption of various food items.
* Thus, only the proportion of householdd eating nutritious food can be estimated
use "${TZA_W1_raw_data}\Household\SEC_K1.dta" , clear
* recode food items to map HDDS food categories
recode skcode    	(101/112 108 				    =1	"CEREALS" )  //// 
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
				
gen adiet_yes=(skq1==1)
ta Diet_ID   
** Now, collapse to food group level; household consumes a food group if it consumes at least one item
collapse (max) adiet_yes, by(hhid   Diet_ID) 
label define YesNo 1 "Yes" 0 "No"
label val adiet_yes YesNo
* Now, estimate the number of food groups eaten by each individual
collapse (sum) adiet_yes, by(hhid )
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
save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_household_diet.dta", replace
 
 
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
use "${TZA_W1_raw_data}\Agriculture\SEC_4A", clear
append using "${TZA_W1_raw_data}\Agriculture\SEC_4B"
append using "${TZA_W1_raw_data}\Agriculture\SEC_5A"
append using "${TZA_W1_raw_data}\Agriculture\SEC_5B"
append using "${TZA_W1_raw_data}\Agriculture\SEC_6A"
append using "${TZA_W1_raw_data}\Agriculture\SEC_6B"
append using "${TZA_W1_raw_data}\Agriculture\SEC_7A"
append using "${TZA_W1_raw_data}\Agriculture\SEC_7B"
append using "${TZA_W1_raw_data}\Agriculture\SEC_9_ALL"
append using "${TZA_W1_raw_data}\Agriculture\SEC_10A.dta"
append using "${TZA_W1_raw_data}\Agriculture\SEC_10B.dta"
append using "${TZA_W1_raw_data}\Household\SEC_E2.dta"
append using "${TZA_W1_raw_data}\Household\SEC_G2.dta"
append using "${TZA_W1_raw_data}\Household\SEC_O1.dta"

gen type_decision="" 
gen controller_income1=.
gen controller_income2=.


* Business income 
* We are making the assumption that whoever owns the business might have some sort of control over the income generated by the business.
* We don't think that the business manager have control of the business income. If she does, she is probaly listed as owner
* control_businessincome
replace type_decision="control_businessincome" if  !inlist( seq25_1o, .,0,99) |  !inlist( seq25_2o, .,0,99) 
replace controller_income1=seq25_1o if !inlist( seq25_1o, .,0,99)  
replace controller_income2=seq25_2o if !inlist( seq25_2o, .,0,99)

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
							
gen control_businessincome=1 if  type_decision=="control_businessincome" 
recode 	control_businessincome (.=0)
																
collapse (max) control_* , by (hhid controller_income )  //any decision
															
ren controller_income sbmemno
*	Now merge with member characteristics
merge 1:1 hhid sbmemno  using  "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_person_ids.dta", nogen 
recode control_* (.=0)
lab var control_businessincome "1=invidual has control over business income"
save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_control_income.dta", replace

************
*WOMEN'S PARTICIPATION IN AGRICULTURAL DECISION MAKING	
************
*	Code as 1 if a woman is listed as one of the decision-makers for at least 2 plots, crops, or livestock activities; 
*	can report on % of women who make decisions, taking total number of women HH members as denominator
*	Indicator may be biased downward if some women would participate in decisions but are not listed among the first two
* first append all files related to agricultural activities with income in who participate in the decision making
use "${TZA_W1_raw_data}\Agriculture\SEC_3A", clear
append using "${TZA_W1_raw_data}\Agriculture\SEC_3B"
append using "${TZA_W1_raw_data}\Agriculture\SEC_10A.dta"

gen type_decision="" 
gen decision_maker1=.
gen decision_maker2=.
gen decision_maker3=.
* planting_input
replace type_decision="planting_input" if  !inlist( s3aq6_1, .,0,99) |  !inlist( s3aq6_2, .,0,99) |  !inlist( s3aq6_3, .,0,99) 
replace decision_maker1=s3aq6_1 if !inlist( s3aq6_1, .,0,99)  
replace decision_maker2=s3aq6_2 if !inlist( s3aq6_2, .,0,99)
replace decision_maker3=s3aq6_3 if !inlist( s3aq6_3, .,0,99)
replace type_decision="planting_input" if  !inlist( s3bq6_1, .,0,99) |  !inlist( s3bq6_2, .,0,99) |  !inlist( s3bq6_3, .,0,99) 
replace decision_maker2=s3bq6_1 if !inlist( s3bq6_1, .,0,99)  
replace decision_maker2=s3bq6_2 if !inlist( s3bq6_2, .,0,99)
replace decision_maker3=s3bq6_3 if !inlist( s3bq6_3, .,0,99)
  

* keep/manage livesock
replace type_decision="livestockowners" if  !inlist( s10aq5_1, .,0,99) |  !inlist( s10aq5_2, .,0,99)  
replace decision_maker1=s10aq5_1 if !inlist( s10aq5_1, .,0,99)  
replace decision_maker2=s10aq5_2 if !inlist( s10aq5_2, .,0,99)
    
keep hhid type_decision decision_maker1 decision_maker2 decision_maker3
 
preserve
keep hhid type_decision decision_maker2
drop if decision_maker2==.
ren decision_maker2 decision_maker
tempfile decision_maker2
save `decision_maker2'
restore

preserve
keep hhid type_decision decision_maker3
drop if decision_maker3==.
ren decision_maker3 decision_maker
tempfile decision_maker3
save `decision_maker3'
restore


keep hhid type_decision decision_maker1
drop if decision_maker1==.
ren decision_maker1 decision_maker
append using `decision_maker2'
append using `decision_maker3'
  

* number of time appears as decision maker
bysort hhid decision_maker : egen nb_decision_participation=count(decision_maker)
drop if nb_decision_participation==1


gen make_decision_crop=1 if  type_decision=="planting_input" ///
						
recode 	make_decision_crop (.=0)

gen make_decision_livestock=1 if  type_decision=="livestockowners"  
recode 	make_decision_livestock (.=0)

gen make_decision_ag=1 if make_decision_crop==1 | make_decision_livestock==1
recode 	make_decision_ag (.=0)

collapse (max) make_decision_* , by(hhid decision_maker )  


ren decision_maker sbmemno

* Now merge with member characteristics
merge 1:1 hhid sbmemno  using  "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_person_ids.dta", nogen 
 
recode make_decision_* (.=0)

lab var make_decision_crop "1=invidual makes decision about crop production activities"
lab var make_decision_livestock "1=invidual makes decision about livestock production activities"
lab var make_decision_ag "1=invidual makes decision about agricultural (crop or livestock) production activities"
save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_make_ag_decision.dta", replace

 
************
*WOMEN'S OWNERSHIP OF ASSETS		
************
* Code as 1 if a woman is sole or joint owner of any specified productive asset; 
* can report on % of women who own, taking total number of women HH members as denominator
* Indicator may be biased downward if some women would have been not listed among the two the first 2 asset-owners can also claim ownership of some assets

*First, append all files with information on asset ownership
use "${TZA_W1_raw_data}\Agriculture\SEC_3A.dta", clear
append using "${TZA_W1_raw_data}\Agriculture\SEC_3B.dta" 
append using "${TZA_W1_raw_data}\Agriculture\SEC_10A.dta"

gen type_asset=""
gen asset_owner1=.
gen asset_owner2=.

* Ownership of land.
replace type_asset="landowners" if  !inlist( s3aq27_1, .,0,99) |  !inlist( s3aq27_2, .,0,99) 
replace asset_owner1=s3aq27_1 if !inlist( s3aq27_1, .,0,99)  
replace asset_owner2=s3aq27_1 if !inlist( s3aq27_2, .,0,99)
replace type_asset="landowners" if  !inlist( s3bq27_1, .,0,99) |  !inlist( s3bq27_2, .,0,99) 
replace asset_owner1=s3bq27_1 if !inlist( s3bq27_1, .,0,99)  
replace asset_owner2=s3bq27_1 if !inlist( s3bq27_2, .,0,99)

*non-poultry livestock (keeps/manages)
replace type_asset="livestockowners" if  !inlist( s10aq5_1, .,0,99) |  !inlist( s10aq5_2, .,0,99)  
replace asset_owner1=s10aq5_1 if !inlist( s10aq5_1, .,0,99)  
replace asset_owner2=s10aq5_2 if !inlist( s10aq5_2, .,0,99)
    
keep hhid type_asset asset_owner1 asset_owner2  
 
preserve
keep hhid type_asset asset_owner2
drop if asset_owner2==.
ren asset_owner2 asset_owner
tempfile asset_owner2
save `asset_owner2'
restore
 

keep hhid type_asset asset_owner1
drop if asset_owner1==.
ren asset_owner1 asset_owner
append using `asset_owner2'
 

gen own_asset=1 

collapse (max) own_asset, by(hhid asset_owner)
ren asset_owner sbmemno
 
* Now merge with member characteristics
merge 1:1 hhid sbmemno  using  "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_person_ids.dta", nogen 
 
recode own_asset (.=0)
 
lab var own_asset "1=invidual owns an assets (land or livestock)"
save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_ownasset.dta", replace
 


**************
*AGRICULTURAL WAGES
**************
use "${TZA_W1_raw_data}/Agriculture/SEC_3A.dta", clear
append using "${TZA_W1_raw_data}/Agriculture/SEC_3B.dta"
* The survey reports total wage paid and amount of hired labor: wage=total paid/ amount of labor
* set wage paid to . if zero or negative
recode s3aq63_*(0=.)
ren s3aq63_1 hired_male_lanprep
replace hired_male_lanprep = s3bq63_1 if hired_male_lanprep==.
ren s3aq63_2 hired_female_lanprep
replace hired_female_lanprep = s3bq63_2 if hired_female_lanprep==.
ren s3aq63_3 hlabor_paid_lanprep
replace hlabor_paid_lanprep = s3bq63_3 if hlabor_paid_lanprep==.
ren s3aq63_4 hired_male_weedingothers
replace hired_male_weedingothers = s3bq63_4 if hired_male_weedingothers==.
ren s3aq63_5 hired_female_weedingothers
replace hired_female_weedingothers = s3bq63_5 if hired_female_weedingothers==.
ren s3aq63_6 hlabor_paid_weedingothers
replace hlabor_paid_weedingothers = s3bq63_6 if hlabor_paid_weedingothers==.
ren s3aq63_7 hired_male_harvest
replace hired_male_harvest = s3bq63_7 if hired_male_harvest==.
ren s3aq63_8 hired_female_harvest
replace hired_female_harvest = s3bq63_8 if hired_female_harvest==.
ren s3aq63_9 hlabor_paid_harvest
replace hlabor_paid_harvest = s3bq63_9 if hlabor_paid_harvest==.
recode hired* hlabor* (.=0)
*first collapse accross plot  to houshold level
collapse (sum) hired* hlabor*, by(hhid)
gen hirelabor_lanprep=(hired_male_lanprep+hired_female_lanprep)
gen wage_lanprep=hlabor_paid_lanprep/hirelabor_lanprep

gen hirelabor_weedingothers=(hired_male_weedingothers+hired_female_weedingothers)
gen wage_weedingothers=hlabor_paid_weedingothers/hirelabor_weedingothers

gen hirelabor_harvest=(hired_male_harvest+hired_female_harvest)
gen wage_harvest=hlabor_paid_harvest/hirelabor_harvest

* get weighted average average accross group of activities to get paid wage at household level
recode wage_lanprep hirelabor_lanprep wage_weedingothers hirelabor_weedingothers  wage_harvest hirelabor_harvest (.=0)
gen wage_paid_aglabor=(wage_lanprep*hirelabor_lanprep+wage_weedingothers*hirelabor_weedingothers+wage_harvest*hirelabor_harvest)/ (hirelabor_lanprep+hirelabor_harvest+hirelabor_harvest)
keep hhid wage_paid_aglabor 
lab var wage_paid_aglabor "Daily agricultural wage paid for hired labor (local currency)"
save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_ag_wage.dta", replace


                                             
**************
*CROP YIELDS
**************

* crops
use "${TZA_W1_raw_data}/Agriculture/SEC_4A.dta", clear
* Percent of area
gen pure_stand = s4aq6==2
gen any_pure = pure_stand==1
gen any_mixed = pure_stand==0
gen percent_field = 0.25 if s4aq4==1 | s4aq4==.25
replace percent_field = 0.50 if s4aq4==2
replace percent_field = 0.75 if s4aq4==3
replace percent_field = 1 if s4aq3==1
duplicates report hhid plotnum zaocode		
duplicates drop hhid plotnum zaocode, force	

*Total area on field
//bys hhid plotnum: egen total_percent_field = total(percent_field)			            
//replace percent_field = percent_field/total_percent_field if total_percent_field>1			
drop if plotnum==""
ren plotnum plot_id 
*Merging in variables from tzn4_field
merge m:1 hhid plot_id using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_plot_areas.dta" , nogen keep(1 3)   
merge m:1 hhid plot_id using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_plot_decision_makers" , nogen keep(1 3)
gen field_area =  area_meas_hectares
replace field_area= area_est_hectares if field_area==.

gen intercropped_yn = 1 if ~missing(s4aq6) 
replace intercropped_yn =0 if s4aq6 == 2  //Not Intercropped
gen mono_field = percent_field if intercropped_yn==0 //not intercropped
gen int_field = percent_field if intercropped_yn==1 

*Generating total percent of purestand and monocropped on a field
bys hhid plot_id: egen total_percent_int_sum = total(int_field) 
bys hhid plot_id: egen total_percent_mono = total(mono_field)

////Dealing with crops which have monocropping larger than plot size or monocropping that fills plot size and still has intercropping to add
generate oversize_plot = (total_percent_mono >1)
replace oversize_plot = 1 if total_percent_mono >=1 & total_percent_int_sum >0 
bys hhid plot_id: egen total_percent_field = total(percent_field)			            
replace percent_field = percent_field/total_percent_field if total_percent_field>1 & oversize_plot ==1

replace total_percent_mono = 1 if total_percent_mono>1 
gen total_percent_inter = 1-total_percent_mono 
bys hhid plot_id: egen inter_crop_number = total(intercropped_yn) 
gen percent_inter = (int_field/total_percent_int_sum)*total_percent_inter if total_percent_field >1 
replace percent_inter = int_field if total_percent_field<=1		//the above code will scale the intercropped area up if the total area planted is less than the total area. I believe that we don't want to do this.
replace percent_inter = percent_field if oversize_plot ==1 & intercropped_yn==1 


ren cultivated field_cultivated  
gen field_area_cultivated = field_area if field_cultivated==1

//gen crop_area_planted = percent_field*field_area_cultivated 
gen crop_area_planted = percent_field*field_area_cultivated  if intercropped_yn == 0 
replace crop_area_planted = percent_inter*field_area_cultivated  if intercropped_yn == 1 
gen us_total_area_planted = total_percent_field*field_area_cultivated 
gen us_inter_area_planted = total_percent_int_sum*field_area_cultivated 

keep crop_area_planted* hhid plot_id zaocode dm_* any_* pure_stand dm_gender  field_area us_* area_meas_hectares area_est_hectares	

save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_plot_crop_area.dta", replace


*Now to harvest
use "${TZA_W1_raw_data}/Agriculture/SEC_4A.dta", clear
gen kg_harvest = s4aq15

rename s4aq9 harv_less_plant		//yes if they harvested less than they planted
rename s4aq1 no_harv
replace kg_harvest = 0 if s4aq2==3
replace kg_harvest = . if s4aq2==1 | s4aq2==2 | s4aq4==4
drop if kg_harvest==.						
gen area_harv_ha= s4aq8*0.404686						
keep hhid plotnum zaocode kg_harvest area_harv_ha harv_less_plant no_harv

ren plotnum plot_id 
*Merging decision maker and intercropping variables
merge m:1 hhid plot_id zaocode using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_plot_crop_area.dta", nogen keep(1 3)			


//Add production of fruit crops to get bananas
preserve 
	use "${TZA_W1_raw_data}/Agriculture/SEC_6A.dta", clear
	rename plotnum plot_id
	merge m:1 hhid plot_id using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_plot_decision_makers" , nogen keep(1 3) 
	ren s6aq2 number_trees_planted
	keep hhid plot_id zaocode dm_gender number_trees_planted
	tempfile banana
	save `banana', replace
restore
append using `banana'

//Add production of permanent crops (cassava!)
preserve
	use "${TZA_W1_raw_data}/Agriculture/SEC_6B.dta", clear 
	*keep if zaocode==21 //cassava 
	gen kg_harvest = s6bq8
	gen pure_stand = s6bq5==2
	gen any_pure = pure_stand==1
	gen any_mixed = pure_stand==0
	ren plotnum plot_id
	merge m:1 hhid plot_id using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_plot_areas.dta", nogen keep(1 3)	               
	merge m:1 hhid plot_id using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_plot_decision_makers" , nogen keep(1 3) 
	gen field_area =  area_meas_hectares
	replace field_area= area_est_hectares if field_area==.
	ren s6bq2 number_trees_planted
	keep hhid plot_id zaocode kg_harvest number_trees_planted pure_stand any_pure any_mixed field_area dm_gender 
	tempfile  cassava
	save `cassava', replace
restore 
append using `cassava'

*rescaling area harvested to area planted if area harvested > area planted - no longer doing this for this method 
ren crop_area_planted area_plan

//Capping Code:
gen over_harvest = area_harv_ha>field_area & area_harv_ha!=. & area_meas_hectares!=.	
gen over_harvest_scaling = field_area/area_harv_ha if over_harvest == 1
bys hhid plot_id: egen mean_harvest_scaling = mean(over_harvest_scaling)
replace mean_harvest_scaling =1 if missing(mean_harvest_scaling)

replace area_harv_ha = field_area if over_harvest == 1
replace area_harv_ha = area_harv_ha*mean_harvest_scaling if over_harvest == 0 

//Intercropping Scaling Code (Method 4):
bys hhid plot_id: egen over_harv_plot = max(over_harvest)
gen intercropped_yn = pure_stand !=1 
gen int_f_harv = area_harv_ha if intercropped_yn==1
bys hhid plot_id: egen total_area_int_sum_hv = total(int_f_harv)
bys hhid plot_id: egen total_area_hv = total(area_harv_ha)

replace us_total_area_planted = total_area_hv if over_harv_plot ==1
replace us_inter_area_planted = total_area_int_sum_hv if over_harv_plot ==1
drop intercropped_yn int_f_harv total_area_int_sum_hv total_area_hv


// Adding Method 4 to Area Harvested
gen intercropped_yn = pure_stand !=1
gen mono_f_harv = area_harv_ha if intercropped_yn==0
gen int_f_harv = area_harv_ha if intercropped_yn==1
bys hhid plot_id: egen total_area_int_sum_hv = total(int_f_harv)
bys hhid plot_id: egen total_area_mono_hv = total(mono_f_harv)
//Oversize Plots
generate oversize_plot = total_area_mono_hv > field_area
replace oversize_plot = 1 if total_area_mono_hv >=1 & total_area_int_sum_hv >0 
bys hhid plot_id: egen total_area_harv = total(area_harv_ha)	
replace area_harv_ha = (area_harv_ha/us_total_area_planted)*field_area if oversize_plot ==1 
//
generate total_area_int_hv = field_area - total_area_mono_hv
replace area_harv_ha = (int_f_harv/us_inter_area_planted)*total_area_int_hv if intercropped_yn==1 & oversize_plot !=1 

/*
//rescaling area harvested down to fit on field
*Total area on field
bys hhid plot_id: egen total_area_harv = total(area_harv_ha)			            
replace area_harv_ha = (area_harv_ha/total_area_harv)*field_area if total_area_harv>field_area & total_area_harv!=.		
*/

replace area_harv_ha=. if area_harv_ha==0 //11 to missing
replace area_plan=area_harv_ha if area_plan==. & area_harv_ha!=.

// replacing area planted with area harvested if farmer reports that they are the same
//replace area_plan=area_harv_ha if harv_less_plant==2 & area_harv_ha!=.
//

//replacing area planted with area harvested if farmer reports that the area harvested was less than the area planted and area harvested is greater than area planted
//replace area_plan=area_harv_ha if harv_less_plant==1 & area_harv_ha>area_plan


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


gen area_plan_male = area_plan if dm_gender==1
gen area_plan_female = area_plan if dm_gender==2
gen area_plan_mixed = area_plan if dm_gender==3
gen area_plan_inter= area_plan if inter==1
gen area_plan_pure= area_plan if inter==0
gen area_plan_inter_male= area_plan if dm_gender==1 & inter==1
gen area_plan_pure_male= area_plan if dm_gender==1 & inter==0
gen area_plan_inter_female= area_plan if dm_gender==2 & inter==1
gen area_plan_pure_female= area_plan if dm_gender==2 & inter==0
gen area_plan_inter_mixed= area_plan if dm_gender==3 & inter==1
gen area_plan_pure_mixed= area_plan if dm_gender==3 & inter==0

recode number_trees_planted (.=0)
collapse (sum) area_harv* harvest* area_plan* number_trees_planted , by (hhid zaocode)
*merging survey weights
merge m:1 hhid using  "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hhids.dta", nogen keep(1 3)

*total planted and harvested area summed accross all plots, crops, and seasons.
preserve
	collapse (sum) all_area_harvested=area_harv all_area_planted=area_plan, by(hhid)
	replace all_area_harvested=all_area_planted if all_area_harvested>all_area_planted & all_area_harvested!=.
	save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_area_planted_harvested_allcrops_LRS.dta", replace
restore


keep if inlist( zaocode, $comma_topcrop_area)

save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_crop_harvest_area_yield_LRS.dta", replace
 
 
 
//////Generating yield variables for short rainy season/////

* crops
use "${TZA_W1_raw_data}/Agriculture/SEC_4B.dta", clear
* Percent of area
gen pure_stand = s4bq6==2
gen any_pure = pure_stand==1
gen any_mixed = pure_stand==0
gen percent_field = 0.25 if s4bq4==1
replace percent_field = 0.50 if s4bq4==2
replace percent_field = 0.75 if s4bq4==3
replace percent_field = 1 if s4bq3==1
duplicates report hhid plotnum zaocode		
duplicates drop hhid plotnum zaocode, force	

*Total area on field
//bys hhid plotnum: egen total_percent_field = total(percent_field)			            // total on plot across ALL crops
//replace percent_field = percent_field/total_percent_field if total_percent_field>1			// Rescaling
drop if plotnum==""
ren plotnum plot_id 
*Merging in variables from tzn4_field
merge m:1 hhid plot_id using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_plot_areas.dta" , nogen keep(1 3)    
merge m:1 hhid plot_id using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_plot_decision_makers" , nogen keep(1 3)
gen field_area =  area_meas_hectares
replace field_area= area_est_hectares if field_area==.

gen intercropped_yn = 1 if ~missing(s4bq6) 
replace intercropped_yn =0 if s4bq6 == 2 
gen mono_field = percent_field if intercropped_yn==0
gen int_field = percent_field if intercropped_yn==1  

bys hhid plot_id: egen total_percent_mono = total(mono_field) 
bys hhid plot_id: egen total_percent_int_sum = total(int_field) 

////Dealing with crops which have monocropping larger than plot size or monocropping that fills plot size and till has intercropping to add
generate oversize_plot = (total_percent_mono >1)
replace oversize_plot = 1 if total_percent_mono >=1 & total_percent_int_sum >0 
bys hhid plot_id: egen total_percent_field = total(percent_field)			            
replace percent_field = percent_field/total_percent_field if total_percent_field>1 & oversize_plot ==1		//17 changes made

replace total_percent_mono = 1 if total_percent_mono>1 
gen total_percent_inter = 1-total_percent_mono 
bys hhid plot_id: egen inter_crop_number = total(intercropped_yn) 
//gen percent_inter = total_percent_inter/inter_crop_number 
//gen percent_inter = total_percent_inter*int_field 

gen percent_inter = (int_field/total_percent_int_sum)*total_percent_inter if total_percent_field >1 
replace percent_inter=int_field if total_percent_field<=1
replace percent_inter = percent_field if oversize_plot ==1 & intercropped_yn==1

ren cultivated field_cultivated  
gen field_area_cultivated = field_area if field_cultivated==1

//gen crop_area_planted = percent_field*field_area_cultivated 
gen crop_area_planted = percent_field*field_area_cultivated  if intercropped_yn == 0 
replace crop_area_planted = percent_inter*field_area_cultivated  if intercropped_yn == 1 
gen us_total_area_planted = total_percent_field*field_area_cultivated 
gen us_inter_area_planted = total_percent_int_sum*field_area_cultivated 

keep crop_area_planted* hhid plot_id zaocode dm_* any_* pure_stand dm_gender  field_area us_* area_meas_hectares area_est_hectares 	
save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_plot_crop_area_SRS.dta", replace


*Now to harvest
use "${TZA_W1_raw_data}/Agriculture/SEC_4B.dta", clear
gen kg_harvest = s4bq15
rename s4bq9 harv_less_plant		//yes if they harvested less than they planted
rename s4bq1 no_harv
replace kg_harvest = 0 if s4bq2==3
replace kg_harvest = . if s4bq2 == 1 | s4bq2 == 2 | s4bq2 == 4
drop if kg_harvest==.							
gen area_harv_ha= s4bq8*0.404686						
keep hhid plotnum zaocode kg_harvest area_harv_ha harv_less_plant no_harv
ren plotnum plot_id 
*Merging decision maker and intercropping variables
merge m:1 hhid plot_id zaocode using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_plot_crop_area_SRS.dta", nogen keep(1 3)			

//Capping Code:
gen over_harvest = area_harv_ha>field_area & area_harv_ha!=. & area_meas_hectares!=.
gen over_harvest_scaling = field_area/area_harv_ha if over_harvest == 1
bys hhid plot_id: egen mean_harvest_scaling = mean(over_harvest_scaling)
replace mean_harvest_scaling =1 if missing(mean_harvest_scaling)

replace area_harv_ha = field_area if over_harvest == 1
replace area_harv_ha = area_harv_ha*mean_harvest_scaling if over_harvest == 0 

//Intercropping Scaling Code (Method 4):
bys hhid plot_id: egen over_harv_plot = max(over_harvest)
gen intercropped_yn = pure_stand !=1 
gen int_f_harv = area_harv_ha if intercropped_yn==1
bys hhid plot_id: egen total_area_int_sum_hv = total(int_f_harv)
bys hhid plot_id: egen total_area_hv = total(area_harv_ha)

replace us_total_area_planted = total_area_hv if over_harv_plot ==1
replace us_inter_area_planted = total_area_int_sum_hv if over_harv_plot ==1
drop intercropped_yn int_f_harv total_area_int_sum_hv total_area_hv


// Adding Method 4 to Area Harvested
gen intercropped_yn = pure_stand !=1 
gen mono_f_harv = area_harv_ha if intercropped_yn==0
gen int_f_harv = area_harv_ha if intercropped_yn==1
bys hhid plot_id: egen total_area_int_sum_hv = total(int_f_harv)
bys hhid plot_id: egen total_area_mono_hv = total(mono_f_harv)
//Oversize Plots
generate oversize_plot = total_area_mono_hv > field_area
replace oversize_plot = 1 if total_area_mono_hv >=1 & total_area_int_sum_hv >0 
bys hhid plot_id: egen total_area_harv = total(area_harv_ha)	
replace area_harv_ha = (area_harv_ha/us_total_area_planted)*field_area if oversize_plot ==1 
//
generate total_area_int_hv = field_area - total_area_mono_hv
replace area_harv_ha = (int_f_harv/us_inter_area_planted)*total_area_int_hv if intercropped_yn==1 & oversize_plot !=1 

*rescaling area harvested to area planted if area harvested > area planted
ren crop_area_planted area_plan

/* No longer rescaling this way
//rescaling area harvested down to fit on field
*Total area on field
bys hhid plot_id: egen total_area_harv = total(area_harv_ha)			            
replace area_harv_ha = (area_harv_ha/total_area_harv)*field_area if total_area_harv>field_area & total_area_harv!=.		
*/
replace area_harv_ha=. if area_harv_ha==0 
replace area_plan=area_harv_ha if area_plan==. & area_harv_ha!=.

//replace area_plan=area_harv_ha if harv_less_plant==2 & area_harv_ha!=.

//replacing area planted with area harvested if farmer reports that the area harvested was less than the area planted and area harvested is greater than area planted
//replace area_plan=area_harv_ha if harv_less_plant==1 & area_harv_ha>area_plan


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

gen area_plan_male = area_plan if dm_gender==1
gen area_plan_female = area_plan if dm_gender==2
gen area_plan_mixed = area_plan if dm_gender==3
gen area_plan_inter= area_plan if inter==1
gen area_plan_pure= area_plan if inter==0
gen area_plan_inter_male= area_plan if dm_gender==1 & inter==1
gen area_plan_pure_male= area_plan if dm_gender==1 & inter==0
gen area_plan_inter_female= area_plan if dm_gender==2 & inter==1
gen area_plan_pure_female= area_plan if dm_gender==2 & inter==0
gen area_plan_inter_mixed= area_plan if dm_gender==3 & inter==1
gen area_plan_pure_mixed= area_plan if dm_gender==3 & inter==0

//don't include soyabeans (47) in common beans
*recode zaocode (31 47=31)

collapse (sum) area_harv* harvest* area_plan*, by (hhid zaocode)
*total planted and harvested area summed accross all plots, crops, and seasons.
preserve
collapse (sum) all_area_harvested=area_harv all_area_planted=area_plan, by(hhid)
replace all_area_harvested=all_area_planted if all_area_harvested>all_area_planted & all_area_harvested!=.
save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_area_planted_harvested_allcrops_SRS.dta", replace
append using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_area_planted_harvested_allcrops_LRS.dta"
recode all_area_harvested all_area_planted (.=0)
collapse (sum) all_area_harvested all_area_planted, by(hhid)
lab var all_area_planted "Total area planted, summed accross all plots, crops, and seasons"
lab var all_area_harvested "Total area harvested, summed accross all plots, crops, and seasons"

save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_area_planted_harvested_allcrops.dta", replace
restore

*merging survey weights
merge m:1 hhid using  "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hhids.dta", nogen keep(1 3)
keep if inlist( zaocode, $comma_topcrop_area)
//global croplist = subinstr("$croplist",","," ",.) //removing commas from the list above

gen season="SRS"
save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_crop_harvest_area_yield_SRS.dta", replace
  
 
*Yield at the household level
use "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_crop_harvest_area_yield_LRS.dta", clear
preserve
gen season="LRS"
append using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_crop_harvest_area_yield_SRS.dta"

recode area_plan area_harv (.=0)
collapse (sum)area_plan area_harv,by(hhid zaocode)
ren area_plan total_planted_area
ren area_harv total_harv_area
tempfile area_allseasons
save `area_allseasons'
restore
merge 1:1 hhid zaocode using `area_allseasons', nogen
ren  zaocode crop_code
*Adding value of crop production
merge 1:1 hhid crop_code using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hh_crop_values_production.dta", nogen keep(1 3)
ren value_crop_production value_harv
ren value_crop_sales value_sold

local ncrop : word count $comma_topcrop_area 
foreach v of varlist  harvest*  area_harv* area_plan* total_planted_area total_harv_area kgs_harvest* kgs_sold* value_harv value_sold {
	separate `v', by(crop_code)
	forvalues i=1(1)`ncrop' {
		local p : word `i' of  $topcrop_area
		local np : word `i' of  $topcropname_area 
		local `v'`p' = subinstr("`v'`p'","`p'","_`np'",1)	
		ren `v'`p'  ``v'`p''
	}	
}

gen number_trees_planted_cassava=number_trees_planted if crop_code==21
gen number_trees_planted_banana=number_trees_planted if crop_code==71
recode number_trees_planted_cassava number_trees_planted_banana (.=0)

collapse (firstnm) harvest* area_harv*  area_plan* total_planted_area* total_harv_area* kgs_harvest*  kgs_sold*  value_harv* value_sold* (sum) number_trees_planted_cassava number_trees_planted_banana, by(hhid)
recode harvest*   area_harv* area_plan* kgs_harvest* total_planted_area* total_harv_area* kgs_sold*  value_harv* value_sold* (0=.)

foreach p of global topcropname_area {
	lab var value_harv_`p' "Value harvested of `p' (household)" 
	lab var value_sold_`p' "Value sold of `p' (household)" 
	lab var kgs_harvest_`p'  "Harvest of `p' (kgs) (household) (all seasons)" 
	lab var kgs_sold_`p'  "Quantity sold of `p' (kgs) (household) (all seasons)" 
	lab var total_harv_area_`p'  "Total area harvested of `p' (ha) (household) (all seasons)" 
	lab var total_planted_area_`p'  "Total area planted of `p' (ha) (household) (all seasons)" 

	lab var harvest_`p' "Harvest of `p' (kgs) (household) - LRS" 
	lab var harvest_male_`p' "Harvest of `p' (kgs) (male-managed plots) - LRS" 
	lab var harvest_female_`p' "Harvest of `p' (kgs) (female-managed plots) - LRS" 
	lab var harvest_mixed_`p' "Harvest of `p' (kgs) (mixed-managed plots) - LRS"
	lab var harvest_pure_`p' "Harvest of `p' (kgs) - purestand (household) - LRS"
	lab var harvest_pure_male_`p'  "Harvest of `p' (kgs) - purestand (male-managed plots) - LRS"
	lab var harvest_pure_female_`p'  "Harvest of `p' (kgs) - purestand (female-managed plots) - LRS"
	lab var harvest_pure_mixed_`p'  "Harvest of `p' (kgs) - purestand (mixed-managed plots) - LRS"
	lab var harvest_inter_`p' "Harvest of `p' (kgs) - intercrop (household) - LRS"
	lab var harvest_inter_male_`p' "Harvest of `p' (kgs) - intercrop (male-managed plots) - LRS" 
	lab var harvest_inter_female_`p' "Harvest of `p' (kgs) - intercrop (female-managed plots) - LRS"
	lab var harvest_inter_mixed_`p' "Harvest  of `p' (kgs) - intercrop (mixed-managed plots) - LRS"

	lab var area_harv_`p' "Area harvested of `p' (ha) (household) - LRS" 
	lab var area_harv_male_`p' "Area harvested of `p' (ha) (male-managed plots) - LRS" 
	lab var area_harv_female_`p' "Area harvested of `p' (ha) (female-managed plots) - LRS" 
	lab var area_harv_mixed_`p' "Area harvested of `p' (ha) (mixed-managed plots) - LRS"
	lab var area_harv_pure_`p' "Area harvested of `p' (ha) - purestand (household) - LRS"
	lab var area_harv_pure_male_`p'  "Area harvested of `p' (ha) - purestand (male-managed plots) - LRS"
	lab var area_harv_pure_female_`p'  "Area harvested of `p' (ha) - purestand (female-managed plots) - LRS"
	lab var area_harv_pure_mixed_`p'  "Area harvested of `p' (ha) - purestand (mixed-managed plots) - LRS"
	lab var area_harv_inter_`p' "Area harvested of `p' (ha) - intercrop (household) - LRS"
	lab var area_harv_inter_male_`p' "Area harvested of `p' (ha) - intercrop (male-managed plots) - LRS" 
	lab var area_harv_inter_female_`p' "Area harvested of `p' (ha) - intercrop (female-managed plots) - LRS"
	lab var area_harv_inter_mixed_`p' "Area harvested  of `p' (ha) - intercrop (mixed-managed plots - LRS)"

	lab var area_plan_`p' "Area planted of `p' (ha) (household) - LRS" 
	lab var area_plan_male_`p' "Area planted of `p' (ha) (male-managed plots) - LRS" 
	lab var area_plan_female_`p' "Area planted of `p' (ha) (female-managed plots) - LRS" 
	lab var area_plan_mixed_`p' "Area planted of `p' (ha) (mixed-managed plots) - LRS"
	lab var area_plan_pure_`p' "Area planted of `p' (ha) - purestand (household) - LRS"
	lab var area_plan_pure_male_`p'  "Area planted of `p' (ha) - purestand (male-managed plots) - LRS"
	lab var area_plan_pure_female_`p'  "Area planted of `p' (ha) - purestand (female-managed plots) - LRS"
	lab var area_plan_pure_mixed_`p'  "Area planted of `p' (ha) - purestand (mixed-managed plots) - LRS"
	lab var area_plan_inter_`p' "Area planted of `p' (ha) - intercrop (household) - LRS"
	lab var area_plan_inter_male_`p' "Area planted of `p' (ha) - intercrop (male-managed plots) - LRS" 
	lab var area_plan_inter_female_`p' "Area planted of `p' (ha) - intercrop (female-managed plots) - LRS"
	lab var area_plan_inter_mixed_`p' "Area planted  of `p' (ha) - intercrop (mixed-managed plots) - LRS"
}

drop if hhid=="11040120030322" //Household indicated that it did not cultivate plots yet there is still area planted and harvested

foreach p of global topcropname_area {
	gen grew_`p'=(total_harv_area_`p'!=. & total_harv_area_`p'!=.0 ) | (total_planted_area_`p'!=. & total_planted_area_`p'!=.0)
	lab var grew_`p' "1=Household grew `p'" 
}
replace grew_cassav =1 if  number_trees_planted_cassava!=0 & number_trees_planted_cassava!=.
replace grew_banana =1 if  number_trees_planted_banana!=0 & number_trees_planted_banana!=. 

foreach p of global topcropname_area {
	recode kgs_harvest_`p' (.=0) if grew_`p'==1 
	recode value_sold_`p' (.=0) if grew_`p'==1 
	recode value_harv_`p' (.=0) if grew_`p'==1 
}

drop harvest- harvest_pure_mixed area_harv- area_harv_pure_mixed area_plan- area_plan_pure_mixed value_harv value_sold total_planted_area total_harv_area number_trees_planted_cassava number_trees_planted_banana

save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_yield_hh_crop_level.dta", replace
 
 
**************
*CONSUMPTION
************** 

use "${TZA_W1_raw_data}/Data - Geovariables/TZY1.HH.Consumption.dta", clear

rename expm total_cons
gen peraeq_cons = (total_cons / adulteq)
gen daily_peraeq_cons = peraeq_cons/365
gen percapita_cons = (total_cons / hhsize)
gen daily_percap_cons = percapita_cons/365

lab var total_cons "Total HH consumption"
lab var peraeq_cons "Consumption per adult equivalent in the HH"
lab var daily_peraeq_cons "Daily consumption per adult equivalent"
lab var percapita_cons "Consumption per HH member"
lab var daily_percap_cons "Daily consumption per capita"

keep hhid total_cons peraeq_cons daily_peraeq_cons percapita_cons daily_percap_cons adulteq

save "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_consumption.dta", replace

 
**************************
*HOUSEHOLD FOOD PROVISION*
**************************
// Wave 1 did not report household food insecurity.

******************
*HOUSEHOLD ASSETS*
******************
// Wave 1 only reported the number of assets and not value.

**************************
*DISTANCE TO AGRO DEALERS*
**************************
*Cannot create in this instrument


************************
*HOUSEHOLD VARIABLES
************************

use "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hhids.dta", clear

*Gross crop income 
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hh_crop_production.dta"
drop if _merge==2 
drop _merge
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_crop_losses.dta"
drop if _merge==2 
drop _merge
recode value_crop_production crop_value_lost (.=0)

*Crop costs
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_asset_rental_costs.dta", nogen
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_land_rental_costs.dta", nogen
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_seed_costs.dta", nogen
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_fertilizer_costs.dta", nogen
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_wages_shortseason.dta", nogen
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_wages_mainseason.dta", nogen
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_transportation_cropsales.dta", nogen
recode rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor rental_cost_land cost_seed value_fertilizer /*
*/ value_herb_pest wages_paid_short wages_paid_main transport_costs_cropsales (.=0)
egen crop_production_expenses = rowtotal(rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor rental_cost_land cost_seed value_fertilizer /*
*/ value_herb_pest wages_paid_short wages_paid_main transport_costs_cropsales)
gen crop_income = value_crop_production - crop_production_expenses - crop_value_lost
lab var crop_production_expenses "Crop production expenditures (explicit)"
lab var crop_income "Net crop revenue"
drop rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor transport_costs_cropsales rental_cost_land wages_paid_short wages_paid_main

*Top Crop costs by area planted
foreach cn in $topcropname_area {
	merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_land_rental_costs_`cn'.dta", nogen
	merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_fertilizer_costs_`cn'.dta", nogen
	merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_`cn'_monocrop_hh_area.dta", nogen
}

// Separate loop for the short seasons as not all crops are planted in the
// short season
foreach cn in $topcropname_short {
	merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_wages_shortseason_`cn'.dta", nogen
}

// Separate loop for annual crops as permanent crops versions of these dta
// files do not exist
foreach cn in $topcropname_annual {
	merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_seed_costs_`cn'.dta", nogen
	merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_wages_mainseason_`cn'.dta", nogen
	
}

// Generate missing variables to rund code that collapses all costs
gen wages_paid_short_sunflr = .
gen wages_paid_short_pigpea = .
gen wages_paid_short_wheat = .
gen wages_paid_short_pmill = .
gen cost_seed_cassav = .
gen cost_seed_banana = .
gen wages_paid_main_cassav = .
gen wages_paid_main_banana = .

// Generate missing variables disaggregated by gender
foreach i in male female mixed{
	gen wages_paid_short_sunflr_`i'=.
	gen wages_paid_short_pigpea_`i'=.
	gen wages_paid_short_wheat_`i'=.
	gen wages_paid_short_pmill_`i'=.
	gen wages_paid_main_cassav_`i'=.
	gen wages_paid_main_banana_`i'=.
	gen cost_seed_cassav_`i'=.
	gen cost_seed_banana_`i'=.
}

foreach cn in $topcropname_area {
	recode `cn'_monocrop (.=0) 
	egen `cn'_exp = rowtotal(rental_cost_land_`cn' cost_seed_`cn' value_fertilizer_`cn' value_herb_pest wages_paid_short_`cn' wages_paid_main_`cn')

	lab var `cn'_exp "Crop production expenditures (explicit) - Monocropped `cn' plots only"
	lab var `cn'_monocrop_ha "Total `cn' monocrop hectares planted - Household"

	*disaggregate by gender of plot manager
	foreach i in male female mixed{
		egen `cn'_exp_`i' = rowtotal(rental_cost_land_`cn'_`i' cost_seed_`cn'_`i' value_fertilizer_`cn'_`i' value_herb_pest_`cn'_`i'  wages_paid_short_`cn'_`i' wages_paid_main_`cn'_`i')
		local l`cn'_exp_`i' : var lab `cn'_exp
		la var `cn'_exp_`i' "`l`cn''_exp_`i'' - `i' managed plots"
	}

	replace `cn'_exp = . if `cn'_monocrop_ha==.			// set to missing if the household does not have any monocropped `cn' plots
	foreach i in male female mixed{
		replace `cn'_exp_`i' = . if `cn'_monocrop_ha_`i'==.
	}
}
drop rental_cost_land_* cost_seed_* value_herb_pest_* wages_paid_short_* wages_paid_main_* value_fertilizer_*

*land rights
merge 1:1 hhid using  "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_land_rights_hh.dta", nogen
la var formal_land_rights_hh "Household has documentation of land rights (at least one plot)"

*Livestock income
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_sales", nogen
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hh_livestock_products", nogen
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_livestock_expenses", nogen
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_TLU.dta", nogen
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_herd_characteristics", nogen
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_TLU_Coefficients.dta", nogen
 
gen livestock_income = value_livestock_sales /*   
*/ + (value_milk_produced + value_eggs_produced + value_other_produced) /* 
*/ - (cost_hired_labor_livestock + cost_fodder_livestock) // 
gen livestock_expenses = cost_hired_labor_livestock + cost_fodder_livestock 
drop value_other_produced cost_hired_labor_livestock cost_fodder_livestock
lab var livestock_income "Net livestock income"
lab var sales_livestock_products "Value of sales of livestock products"
lab var value_livestock_products "Value of livestock products"
*Fish income
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_fish_income.dta", nogen
merge 1:1 hhid using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_fishing_expenses_1.dta", nogen
merge 1:1 hhid using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_fishing_expenses_2.dta", nogen
gen fishing_income = value_fish_harvest - cost_fuel - cost_paid - equipment_repair_cost
drop cost_fuel cost_paid equipment_repair_cost 
lab var fishing_income "Net fish income"

*Self-employment income
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_self_employment_income.dta", nogen
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_agproducts_profits.dta", nogen
egen self_employment_income = rowtotal(annual_selfemp_profit byproduct_profits) 
drop annual_selfemp_profit byproduct_profits
lab var self_employment_income "Income from self-employment"

*Off-farm hours
merge 1:1 hhid using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_off_farm_hours.dta", nogen

*Other income
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_other_income.dta", nogen
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_land_rental_income.dta", nogen
egen transfers_income = rowtotal (remittance_income assistance_income)
lab var transfers_income "Income from transfers including remittances and assistances)"
egen all_other_income = rowtotal (land_rental_income)
lab var all_other_income "Income from all other revenue"
drop remittance_income assistance_income land_rental_income

*Farm size
merge 1:1 hhid using  "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_land_size.dta", nogen
merge 1:1 hhid using  "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_land_size_all.dta", nogen
merge 1:1 hhid using  "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_farmsize_all_agland.dta", nogen
recode land_size (.=0)
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
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_family_hired_labor.dta", nogen
recode   labor_hired labor_family (.=0)
 
*Household size
merge 1:1 hhid using  "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hhsize.dta", nogen


*Rates of vaccine usage, improved seeds, etc.
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_vaccine.dta", nogen
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_fert_use.dta", nogen
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_improvedseed_use.dta", nogen
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_any_ext.dta", nogen
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_fin_serv.dta", nogen
recode use_fin_serv* ext_reach* use_inorg_fert imprv_seed_use vac_animal (.=0)
replace vac_animal=. if tlu_today==0 
replace use_inorg_fert=. if farm_area==0 | farm_area==. 
recode ext_reach* (0 1=.) if (value_crop_production==0 & livestock_income==0 & farm_area==0 & tlu_today==0)
recode ext_reach* (0 1=.) if farm_area==.
replace imprv_seed_use=. if farm_area==.

*Milk productivity
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_milk_animals.dta", nogen
gen costs_dairy= .
gen costs_dairy_percow= .


*Egg productivity
merge 1:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_eggs_animals.dta", nogen


*Costs of crop production per hectare
merge 1:1 hhid using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_cropcosts_perha.dta", nogen

*Rate of fertilizer application 
merge 1:1 hhid using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_fertilizer_application.dta", nogen

*Agricultural wage rate
merge 1:1 hhid using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_ag_wage.dta", nogen

*Crop yields 
merge 1:1 hhid using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_yield_hh_crop_level.dta", nogen

*Total area planted and harvested accross all crops, plots, and seasons
merge 1:1 hhid using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_hh_area_planted_harvested_allcrops.dta", nogen

*Household diet
merge 1:1 hhid using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_household_diet.dta", nogen

*Consumption
merge 1:1 hhid using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_consumption.dta", nogen

*Household Assets
// Data not reported for wave 1
gen value_assets = .
lab var value_assets "Value of household assets"

*Food insecurity
gen months_food_insec = .

*Agricultural households
recode value_crop_production livestock_income farm_area tlu_today (.=0)
gen ag_hh = (value_crop_production!=0 | crop_income!=0 |livestock_income!=0 | farm_area!=0 | tlu_today!=0)
lab var ag_hh "1= Household has some land cultivated, some livestock, some crop income, or some livestock income"

*household with milk-producing animals 
//gen milk_hh = (milk_animals>0 & milk_animals!=.) 	//don't have milk animals in this wave
*gen milk_hh = ((value_milk_produced>0 & value_milk_produced!=.) | (liters_milk_produced>0 & liters_milk_produced!=.))
*lab var milk_hh "1=Household has some milk-producing animals"
*household with egg-producing animals 
//gen egg_hh = (poultry_owned>0 & poultry_owned!=.)		//don't have number of poultry in this wave
gen egg_hh = ((value_eggs_produced>0 & value_eggs_produced!=.) | (eggs_total_year>0 & eggs_total_year!=.))
lab var egg_hh "1=Household has some egg-producing animals"
*household engaged in dairy production
gen dairy_hh = (value_milk_produced>0 & value_milk_produced!=.)
lab var dairy_hh "1= Household engaged in dairy production" 


*Crop households and livestock households
gen crop_hh = (value_crop_production!=0  | farm_area!=0)
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
forvalues k=1(1)15 {
	local cn: word `k' of $topcropname_area
	recode value_harv_`cn' value_sold_`cn' kgs_harvest_`cn' total_planted_area_`cn' total_harv_area_`cn' `cn'_exp (.=0) if grew_`cn'==1
	recode value_harv_`cn' value_sold_`cn' kgs_harvest_`cn' total_planted_area_`cn' total_harv_area_`cn' `cn'_exp (nonmissing=.) if grew_`cn'==0
}
*households engaged in crop production
recode cost_expli_hh value_crop_production value_crop_sales labor_hired labor_family farm_size_agland all_area_harvested all_area_planted (.=0) if crop_hh==1
recode cost_expli_hh value_crop_production value_crop_sales labor_hired labor_family farm_size_agland all_area_harvested all_area_planted (nonmissing=.) if crop_hh==0
*all rural households engaged in livestock production 
recode animals_lost12months* mean_12months* livestock_expenses (.=0) if livestock_hh==1
recode animals_lost12months* mean_12months* livestock_expenses (nonmissing=.) if livestock_hh==0
*all rural households 
recode off_farm_hours crop_income livestock_income self_employment_income /*nonagwage_income agwage_income*/ fishing_income transfers_income all_other_income /*value_assets*/ (.=0)
*all rural households with milk-producing animals
recode liters_milk_produced value_milk_produced (.=0) if dairy_hh==1 
recode liters_milk_produced value_milk_produced (nonmissing=.) if dairy_hh==0
*all rural households engaged in dairy production
recode costs_dairy (.=0) if dairy_hh==1 
recode costs_dairy (nonmissing=.) if dairy_hh==0
*all rural households eith egg-producing animals
recode eggs_total_year value_eggs_produced (.=0) if egg_hh==1
recode eggs_total_year value_eggs_produced (nonmissing=.) if egg_hh==0


global gender "female male mixed"


*Variables winsorized at the top 1% only 

global wins_var_top1 /*
*/ value_crop_production value_crop_sales value_harv* value_sold* /*
*/ kgs_harvest* kgs_harv_mono* total_planted_area* total_harv_area* /*
*/ labor_hired labor_family /*
*/ animals_lost12months* mean_12months*  /*
*/ liters_milk_produced costs_dairy /*
*/ eggs_total_year value_eggs_produced value_milk_produced /* 
*/  off_farm_hours livestock_expenses crop_production_expenses /*
*/ value_assets cost_expli_hh   sales_livestock_products value_livestock_products value_livestock_sales
foreach v of varlist $wins_var_top1 {
	_pctile `v' [aw=weight] , p(99) 
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top 1%"
}

* Variables winsorized at the top 1% only - for variables disaggregated by the 
* gender of the plot manager
global wins_var_top1_gender=""
foreach v in $topcropname_area {
	global wins_var_top1_gender $wins_var_top1_gender `v'_exp
}
global wins_var_top1_gender $wins_var_top1_gender cost_total cost_expli /*
*/ fert_inorg_kg wage_paid_aglabor

gen wage_paid_aglabor_female=. 
gen wage_paid_aglabor_male=.
gen wage_paid_aglabor_mixed=. 
lab var wage_paid_aglabor_female "Daily wage in agricuture - female workers"
lab var wage_paid_aglabor_male "Daily wage in agricuture - male workers"

foreach v of varlist $wins_var_top1_gender {
	_pctile `v' [aw=weight] , p(99) 
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
lab var w_labor_total "`llabor_total' - Winzorized top 1%"

*Variables winsorized both at the top 1% and bottom 1% 
global wins_var_top1_bott1  /* 
*/ farm_area farm_size_agland all_area_harvested all_area_planted ha_planted /*
*/ crop_income livestock_income fishing_income self_employment_income transfers_income all_other_income total_cons percapita_cons daily_percap_cons peraeq_cons daily_peraeq_cons /* 
*/ *_monocrop_ha* 


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

 
global allyield male female mixed inter inter_male inter_female inter_mixed pure  pure_male pure_female pure_mixed
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
		lab var  yield_pl_`g'_`c'  "Yield by area planted of `c' -  (kgs/ha) (`g')" 
		gen ar_pl_wgt_`g'_`c' =  weight*w_area_plan_`g'_`c'
		lab var ar_pl_wgt_`g'_`c' "Planted area-adjusted weight for `c' (`g')"
	}
}


*Yield by Area Harvested
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
}
 
*generate inorg_fert_rate, costs_total_ha, and costs_expli_ha using winsorized values
gen inorg_fert_rate=w_fert_inorg_kg/w_ha_planted
gen cost_total_ha=w_cost_total/w_ha_planted 
gen cost_expli_ha=w_cost_expli/w_ha_planted

foreach g of global gender {
	gen inorg_fert_rate_`g'=w_fert_inorg_kg_`g'/ w_ha_planted_`g'
	gen cost_total_ha_`g'=w_cost_total_`g'/ w_ha_planted_`g'
	gen cost_expli_ha_`g'=w_cost_expli_`g'/ w_ha_planted_`g'			
}

lab var inorg_fert_rate "Rate of fertilizer application (kgs/ha) (household level)"
lab var inorg_fert_rate_male "Rate of fertilizer application (kgs/ha) (male-managed crops)"
lab var inorg_fert_rate_female "Rate of fertilizer application (kgs/ha) (female-managed crops)"
lab var inorg_fert_rate_mixed "Rate of fertilizer application (kgs/ha) (mixed-managed crops)"
lab var cost_total_ha "Explicit + implicit costs (per ha) of crop production costs that can be disaggregated at the plot manager level (household level)"
lab var cost_total_ha_male "Explicit + implicit costs (per ha) of crop production (male-managed plots)"
lab var cost_total_ha_female "Explicit + implicit costs (per ha) of crop production (female-managed plots)"
lab var cost_total_ha_mixed "Explicit + implicit costs (per ha) of crop production (mixed-managed plots)"
lab var cost_expli_ha "Explicit costs (per ha) of crop production costs that can be disaggregated at the plot manager level (household level)"
lab var cost_expli_ha_male "Explicit costs (per ha) of crop production (male-managed plots)"
lab var cost_expli_ha_female "Explicit costs (per ha) of crop production (female-managed plots)"
lab var cost_expli_ha_mixed "Explicit costs (per ha) of crop production (mixed-managed plots)"

*mortality rate
global animal_species lrum srum poultry 
foreach s of global animal_species {
	gen mortality_rate_`s' = animals_lost12months_`s'/mean_12months_`s'
	lab var mortality_rate_`s' "Mortality rate - `s'"
}

*generating top crop expense ha using winsorized values
foreach c in $topcropname_area {		
	gen `c'_exp_ha =w_`c'_exp/w_`c'_monocrop_ha
	la var `c'_exp_ha "Costs per hectare - Monocropped `c' plots"
	foreach  g of global gender{
		gen `c'_exp_ha_`g' = w_`c'_exp_`g'/w_`c'_monocrop_ha
	}
}

*Off farm hours per capita using winsorized version off_farm_hours 
gen off_farm_hours_pc_all = w_off_farm_hours/member_count					
gen off_farm_hours_pc_any = w_off_farm_hours/off_farm_any_count			
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
gen liters_per_largeruminant=.

*crop value sold
gen w_proportion_cropvalue_sold = w_value_crop_sales /  w_value_crop_production
replace w_proportion_cropvalue_sold = 1 if w_proportion_cropvalue_sold > 1 & w_proportion_cropvalue_sold != .
lab var w_proportion_cropvalue_sold "Proportion of crop value produced (winsorized) that has been sold"

*unit cost of production 
*for all top crops
foreach c in $topcropname_area{
	gen `c'_exp_kg = w_`c'_exp/w_kgs_harv_mono_`c' 
	la var `c'_exp_kg "Costs per kg - Monocropped `c' plots"
	foreach g of global gender {
		gen `c'_exp_kg_`g'=w_`c'_exp_`g'/ w_kgs_harv_mono_`c'_`g' 
	}
}

*dairy
gen cost_per_lit_milk = w_costs_dairy/w_liters_milk_produced  

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
forvalues k=1/15 {
	local cn: word `k' of $topcropname_area
	recode `cn'_exp `cn'_exp_ha `cn'_exp_kg (.=0) if `cn'_monocrop==1
	recode `cn'_exp `cn'_exp_ha `cn'_exp_kg (nonmissing=.) if `cn'_monocrop==0
}
*all rural households growing specific crops 
forvalues k=1(1)15 {
	local cn: word `k' of $topcropname_area
	recode yield_pl_`cn' yield_hv_`cn' (.=0) if grew_`cn'==1
	recode yield_pl_`cn' yield_hv_`cn' (nonmissing=.) if grew_`cn'==0
}
*households growing specific crops that have also purestand plots of that crop 
forvalues k=1(1)15 {
	local cn: word `k' of $topcropname_area
	recode yield_pl_pure_`cn' yield_hv_pure_`cn' (.=0) if grew_`cn'==1 & w_area_plan_pure_`cn'!=.
	recode yield_pl_pure_`cn' yield_hv_pure_`cn' (nonmissing=.) if grew_`cn'==0 | w_area_plan_pure_`cn'==. 
}
*households with milk-producing animals
*recode liters_per_cow (.=0) if milk_hh==1
*recode liters_per_cow (nonmissing=.) if milk_hh==0
*households engaged in dairy production 
recode costs_dairy_percow cost_per_lit_milk (.=0) if dairy_hh==1
recode costs_dairy_percow cost_per_lit_milk (nonmissing=.) if dairy_hh==0
*households with egg-producing animals
*recode egg_poultry_year (.=0) if egg_hh==1 
*recode egg_poultry_year (nonmissing=.) if egg_hh==0

*now winsorize ratios only at top 1% 
global wins_var_ratios_top1 inorg_fert_rate cost_total_ha cost_expli_ha /*
*/ cost_expli_hh_ha /*
*/ land_productivity labor_productivity /*
*/ mortality_rate* liters_per_largeruminant costs_dairy_percow /*
*/  off_farm_hours_pc_all off_farm_hours_pc_any cost_per_lit_milk


foreach v of varlist $wins_var_ratios_top1 {
	_pctile `v' [aw=weight] , p(99) 
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top 1%"

	*some variables  are disaggreated by gender of plot manager. For these variables, we use the top 1% percentile to winsorize gender-disagregated variables
	if "`v'" =="inorg_fert_rate" | "`v'" =="cost_total_ha"  | "`v'" =="cost_expli_ha"   {
		foreach g of global gender {
			gen w_`v'_`g'=`v'_`g'
			replace  w_`v'_`g' = r(r1) if w_`v'_`g' > r(r1) & w_`v'_`g'!=.
			local l`v'_`g' : var lab `v'_`g'
			lab var  w_`v'_`g'  "`l`v'_`g'' - Winzorized top 1%"
		}	
	}
}

// names for crop expenses in this version
*Winzorizing top crop ratios
foreach v of global topcropname_area {
	*first winsorizing costs per hectare
	_pctile `v'_exp_ha [aw=weight] , p(99) 
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
	_pctile `v'_exp_kg [aw=weight] , p(99) 
	gen w_`v'_exp_kg=`v'_exp_kg
	replace  w_`v'_exp_kg = r(r1) if  w_`v'_exp_kg > r(r1) &  w_`v'_exp_kg!=.
	local l`v'_exp_kg : var lab `v'_exp_kg
	lab var  w_`v'_exp_kg  "`l`v'_exp_kg' - Winzorized top 1%"
		*now by gender using the same method as above
		foreach g of global gender {
		gen w_`v'_exp_kg_`g'= `v'_exp_kg_`g'
		replace w_`v'_exp_kg_`g' = r(r1) if w_`v'_exp_kg_`g' > r(r1) & w_`v'_exp_kg_`g'!=.
		local l`v'_exp_kg_`g' : var lab `v'_exp_kg_`g'
		lab var w_`v'_exp_kg_`g' "`l`v''_exp_kg_`g' - winsorized top 1%"
	}
}

*now winsorize ratio only at top 1% - yield 
foreach c of global topcropname_area {
	foreach i in yield_pl yield_hv{
		_pctile `i'_`c' [aw=weight] , p(99) 
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

*Create final income variables using un_winzorized and un_winzorized values
egen total_income = rowtotal(crop_income livestock_income fishing_income self_employment_income transfers_income all_other_income)
egen nonfarm_income = rowtotal(fishing_income self_employment_income transfers_income all_other_income)
egen farm_income = rowtotal(crop_income livestock_income)
lab var  nonfarm_income "Nonfarm income (excludes ag wages)"
gen percapita_income = total_income/hh_members
lab var total_income "Total household income"
lab var percapita_income "Household incom per hh member per year"
lab var farm_income "Farm income"

egen w_total_income = rowtotal(w_crop_income w_livestock_income w_fishing_income w_self_employment_income w_transfers_income w_all_other_income)
egen w_nonfarm_income = rowtotal(w_fishing_income w_self_employment_income w_transfers_income w_all_other_income)
egen w_farm_income = rowtotal(w_crop_income w_livestock_income)
lab var  w_nonfarm_income "Nonfarm income (excludes ag wages) - Winzorized top 1%"
lab var w_farm_income "Farm income - Winzorized top 1%"
gen w_percapita_income = w_total_income/hh_members
lab var w_total_income "Total household income - Winzorized top 1%"
lab var w_percapita_income "Household income per hh member per year - Winzorized top 1%"

global income_vars crop livestock fishing self_employment transfers all_other
foreach p of global income_vars {
gen `p'_income_s = `p'_income
replace `p'_income_s = 0 if `p'_income_s < 0

gen w_`p'_income_s = w_`p'_income
replace w_`p'_income_s = 0 if w_`p'_income_s < 0 
}
egen w_total_income_s = rowtotal(w_crop_income_s w_livestock_income_s w_fishing_income_s w_self_employment_income_s w_transfers_income_s w_all_other_income_s)
foreach p of global income_vars {
gen w_share_`p' = w_`p'_income_s / w_total_income_s
lab var w_share_`p' "Share of household (winsorized) income from `p'_income"
}

egen w_nonfarm_income_s = rowtotal(w_fishing_income_s w_self_employment_income_s w_transfers_income_s w_all_other_income_s)
gen w_share_nonfarm = w_nonfarm_income_s / w_total_income_s
lab var w_share_nonfarm "Share of household income (winsorized) from nonfarm sources"
foreach p of global income_vars {
drop `p'_income_s  w_`p'_income_s 
}
drop w_total_income_s w_nonfarm_income_s

***getting correct subpopulations 
*all rural households 
//note that consumption indicators are not included because there is missing consumption data and we do not consider 0 values for consumption to be valid
recode w_total_income w_percapita_income w_crop_income w_livestock_income w_fishing_income /*w_nonagwage_income w_agwage_income*/ w_self_employment_income w_transfers_income w_all_other_income /*
*/ w_share_crop w_share_livestock w_share_fishing /*w_share_nonagwage w_share_agwage*/ w_share_self_employment w_share_transfers w_share_all_other w_share_nonfarm /*
*/ use_fin_serv* use_inorg_fert imprv_seed_use /*
*/ formal_land_rights_hh w_off_farm_hours_pc_all months_food_insec /*w_value_assets  hhs_little hhs_moderate hhs_severe hhs_total*/ /*
*/ lvstck_holding_tlu lvstck_holding_all lvstck_holding_lrum lvstck_holding_srum lvstck_holding_poultry (.=0) if rural==1 
 
 
*all rural households engaged in livestock production
recode vac_animal share_livestock_prod_sold livestock_expenses any_imp_herd_all (. = 0) if livestock_hh==1 
recode vac_animal share_livestock_prod_sold livestock_expenses any_imp_herd_all (nonmissing = .) if livestock_hh==0 

*all rural households engaged in livestcok production of a given species
foreach i in lrum srum poultry{
	recode vac_animal_`i' any_imp_herd_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode vac_animal_`i' any_imp_herd_`i' (.=0) if lvstck_holding_`i'==1	
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
forvalues k=1(1)15 {
	local cn: word `k' of $topcropname_area
	recode imprv_seed_`cn' hybrid_seed_`cn' w_yield_hv_`cn' w_yield_pl_`cn' /*
	*/ w_value_harv_`cn' w_value_sold_`cn' w_kgs_harvest_`cn' w_total_planted_area_`cn' w_total_harv_area_`cn' (.=0) if grew_`cn'==1
	recode imprv_seed_`cn' hybrid_seed_`cn' w_yield_hv_`cn' w_yield_pl_`cn' /*
	*/ w_value_harv_`cn' w_value_sold_`cn' w_kgs_harvest_`cn' w_total_planted_area_`cn' w_total_harv_area_`cn' (nonmissing=.) if grew_`cn'==0
}

*households engaged in monocropped production of specific crops
forvalues k=1/15 {
	local cn: word `k' of $topcropname_area
	recode w_`cn'_exp w_`cn'_exp_ha w_`cn'_exp_kg (.=0) if `cn'_monocrop==1
	recode w_`cn'_exp w_`cn'_exp_ha w_`cn'_exp_kg (nonmissing=.) if `cn'_monocrop==0
}
*all rural households with milk-producing animals
recode liters_milk_produced value_milk_produced (.=0) if dairy_hh==1 
recode liters_milk_produced value_milk_produced (nonmissing=.) if dairy_hh==0
*all rural households engaged in dairy production
recode costs_dairy (.=0) if dairy_hh==1 
recode costs_dairy (nonmissing=.) if dairy_hh==0
*all rural households eith egg-producing animals
recode w_eggs_total_year value_eggs_produced (.=0) if egg_hh==1
recode w_eggs_total_year value_eggs_produced (nonmissing=.) if egg_hh==0

*Convert monetary values to 2016 Purchasing Power Parity international dollars
global topcrop_monetary=""
foreach v in $topcropname_area {
	global topcrop_monetary $topcrop_monetary `v'_exp `v'_exp_ha `v'_exp_kg
	foreach g in $gender {
		global topcrop_monetary $topcrop_monetary `v'_exp_`g' `v'_exp_ha_`g' /*
		*/ `v'_exp_kg_`g'
	}
}
global monetary_vars crop_income livestock_income fishing_income /*
*/ self_employment_income transfers_income /*
*/ all_other_income percapita_income total_income nonfarm_income farm_income /*
*/ land_productivity labor_productivity total_cons percapita_cons /*
*/ daily_percap_cons peraeq_cons daily_peraeq_cons wage_paid_aglabor* /*
*/ cost_total_ha cost_total_ha_female cost_total_ha_male cost_total_ha_mixed /*
*/ cost_expli_ha cost_expli_ha_female cost_expli_ha_male cost_expli_ha_mixed /*
*/ cost_expli_hh cost_expli_hh_ha value_crop_production value_harv* /*
*/ value_sold_* value_crop_sales value_milk_produced  value_eggs_produced /*
*/ livestock_expenses costs_dairy costs_dairy_percow cost_per_lit_milk* /*
*/ value_assets sales_livestock_products value_livestock_products value_livestock_sales $topcrop_monetary 


foreach p of varlist $monetary_vars {
	gen `p'_1ppp = (1+$NPS_LSMS_ISA_W1_inflation) * `p' / $NPS_LSMS_ISA_W1_cons_ppp_dollar 
	gen `p'_2ppp = (1+$NPS_LSMS_ISA_W1_inflation) * `p' / $NPS_LSMS_ISA_W1_gdp_ppp_dollar
	gen `p'_loc = (1+$NPS_LSMS_ISA_W1_inflation) * `p' 
	gen `p'_usd = (1+$NPS_LSMS_ISA_W1_inflation) * `p' / $NPS_LSMS_ISA_W1_exchange_rate 
	local l`p' : var lab `p' 
	lab var `p'_1ppp "`l`p'' (2016 $ Private Consumption PPP)"
	lab var `p'_2ppp "`l`p'' (2016 $ GDP PPP)"
	lab var `p'_usd "`l`p'' (2016 $ USD)"
	lab var `p' "`l`p'' (TSH)"  
	gen w_`p'_1ppp = (1+$NPS_LSMS_ISA_W1_inflation) * w_`p' / $NPS_LSMS_ISA_W1_cons_ppp_dollar 
	gen w_`p'_2ppp = (1+$NPS_LSMS_ISA_W1_inflation) * w_`p' / $NPS_LSMS_ISA_W1_gdp_ppp_dollar 
	gen w_`p'_usd = (1+$NPS_LSMS_ISA_W1_inflation) * w_`p' / $NPS_LSMS_ISA_W1_exchange_rate
	gen w_`p'_loc = (1+$NPS_LSMS_ISA_W1_inflation) * w_`p'  
	local lw_`p' : var lab w_`p'
	lab var w_`p'_1ppp "`lw_`p'' (2016 $ Private Consumption PPP)"
	lab var w_`p'_2ppp "`lw_`p'' (2016 $ GDP PPP)"
	lab var w_`p'_usd "`lw_`p'' (2016 $ USD)"
	lab var w_`p' "`lw_`p'' (TSH)"  
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
drop land_size_aghh small_land_size tlu_today_aghh small_tlu_today total_income_aghh small_total_income
lab var small_farm_household "1= HH is in bottom 40th percentiles of land size, TLU, and total revenue"


*Rural poverty headcount ratio
*First, we convert $1.91 USD to local currency using https://data.worldbank.org/indicator/PA.NUS.PPP?locations=TZ
	// 1.91 * 585.52 = 1,118.3432
*NOTE: this is using the "GDP, PPP" conversion factor because that's what we have been using. We need to change this to the "Private Consumption, PPP" if we change the rest of the conversion factors.
*Second, we inflate the local currency to the year that this survey was carried out using the CPI inflation rate using https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2017&locations=TZ&start=2003	
	// ((141.01 - 112.69)/112.69) + 1 = 1.2513
	// 1,118.3432 * 1.2513 = 1,399.383 TZS
*NOTE: if the survey was carried out over multiple years we use the last year
*This is the poverty line at the local currency in the year the survey was carried out

gen poverty_under_1_9 = (daily_percap_cons<1399.383)
la var poverty_under_1_9 "Household has a percapita conumption of under $1.90 in 2011 $ PPP)"

*drop unnecessary variables and replace variables that cannot be calculated with missing
drop *_inter_*
recode *costs_dairy* months_food_insec (0=.)

//////////Identifier Variables ////////
*Add variables and rename household id so dta file can be appended with dta files from other instruments
gen geography = "Tanzania"
gen survey = "LSMS-ISA"
gen year = "2008-09"
gen instrument = 1
label define instrument 1 "TZA NPS Wave 1" 2 "TZA NPS Wave 2" 3 "TZA NPS Wave 3" 4 "TZA NPS Wave 4" /*
	*/ 5 "ETH ESS Wave 1" 6 "ETH ESS Wave 2" 7 "ETH ESS Wave 3" /*
	*/ 8 "NGA GHSP Wave 1" 9 "NGA GHSP Wave 2" 10 "NGA GHSP Wave 3" /*
	*/ 11 "Tanzania TBS AgDev (Lake Zone)" 12 "Tanzania TBS AgDev (Northern Zone)" 13 "Tanzania TBS AgDev (Southern Zone)" /*
	*/ 14 "ETH ACC Baseline" /*
	*/ 15 "India RMS Baseline (Bihar)" 16 "India RMS Baseline (Odisha)" 17 "India RMS Baseline (Uttar Pradesh)" 18 "India RMS Baseline (West Bengal)" /*
	*/ 19 "Nigeria NIBAS AgDev (Nassarawa)" 20 "Nigeria NIBAS AgDev (Benue)" 21 "Nigeria NIBAS AgDev (Kaduna)" /*
	*/ 22 "Nigeria NIBAS AgDev (Niger)" 23 "Nigeria NIBAS AgDev (Kano)" 24 "Nigeria NIBAS AgDev (Katsina)" 
label values instrument instrument	 

save "${TZA_W1_final_data}/Tanzania_NPS_LSMS_ISA_W1_household_variables.dta", replace
XXX
                                                             
**************
*INDIVIDUAL-LEVEL VARIABLES
**************
use "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_person_ids.dta", clear
merge 1:1 hhid sbmemno using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_control_income.dta", nogen  keep(1 3)
merge 1:1 hhid sbmemno using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_make_ag_decision.dta", nogen  keep(1 3)
merge 1:1 hhid sbmemno using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_ownasset.dta", nogen  keep(1 3)
merge m:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hhsize.dta", nogen keep (1 3)
merge 1:1 hhid sbmemno using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_farmer_fert_use.dta", nogen  keep(1 3)
merge 1:1 hhid sbmemno using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_farmer_improvedseed_use.dta", nogen  keep(1 3)
merge 1:1 hhid sbmemno using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_farmer_vaccine.dta", nogen  keep(1 3)
merge m:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hhids.dta", nogen keep (1 3)

*land rights
merge 1:1 hhid sbmemno using "${TZA_W1_created_data}/Tanzania_NPS_LSMS_ISA_W1_land_rights_ind.dta", nogen
recode formal_land_rights_f (.=0) if female==1	
la var formal_land_rights_f "Individual has documentation of land rights (at least one plot) - Women only"

*getting correct subpopulations (women aged 18 or above in rural households) 
recode /*control_all_income*/ make_decision_ag own_asset formal_land_rights_f (.=0) if female==1 
recode /*control_all_income*/ make_decision_ag own_asset formal_land_rights_f (nonmissing=.) if female==0

preserve
use "${TZA_W1_final_data}/Tanzania_NPS_LSMS_ISA_W1_household_variables.dta", clear
keep hhid ag_hh
tempfile ag_hh
save `ag_hh'
restore
merge m:1 hhid using `ag_hh', nogen keep (1 3)
replace   make_decision_ag =. if ag_hh==0

//////////Identifier Variables ////////
*Add variables and rename household id so dta file can be appended with dta files from other instruments
rename sbmemno indid
gen geography = "Tanzania"
gen survey = "LSMS-ISA"
gen year = "2008-09"
gen instrument = 1
label define instrument 1 "TZA NPS Wave 1" 2 "TZA NPS Wave 2" 3 "TZA NPS Wave 3" 4 "TZA NPS Wave 4" /*
	*/ 5 "ETH ESS Wave 1" 6 "ETH ESS Wave 2" 7 "ETH ESS Wave 3" /*
	*/ 8 "NGA GHSP Wave 1" 9 "NGA GHSP Wave 2" 10 "NGA GHSP Wave 3" /*
	*/ 11 "Tanzania TBS AgDev (Lake Zone)" 12 "Tanzania TBS AgDev (Northern Zone)" 13 "Tanzania TBS AgDev (Southern Zone)" /*
	*/ 14 "ETH ACC Baseline" /*
	*/ 15 "India RMS Baseline (Bihar)" 16 "India RMS Baseline (Odisha)" 17 "India RMS Baseline (Uttar Pradesh)" 18 "India RMS Baseline (West Bengal)" /*
	*/ 19 "Nigeria NIBAS AgDev (Nassarawa)" 20 "Nigeria NIBAS AgDev (Benue)" 21 "Nigeria NIBAS AgDev (Kaduna)" /*
	*/ 22 "Nigeria NIBAS AgDev (Niger)" 23 "Nigeria NIBAS AgDev (Kano)" 24 "Nigeria NIBAS AgDev (Katsina)" 
label values instrument instrument	 

save "${TZA_W1_final_data}/Tanzania_NPS_LSMS_ISA_W1_individual_variables.dta", replace
 
****************************
*PLOT -LEVEL VARIABLES
****************************

*GENDER PRODUCTIVITY GAP (PLOT LEVEL)

use "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_plot_cropvalue.dta", clear
merge 1:1 hhid plot_id using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_plot_areas.dta", keep (1 3) nogen
merge 1:1 hhid plot_id  using  "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_plot_decision_makers.dta", keep (1 3) nogen
merge m:1 hhid using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_hhids.dta", keep (1 3) nogen
merge 1:1 hhid plot_id using "${TZA_W1_created_data}\Tanzania_NPS_LSMS_ISA_W1_plot_family_hired_labor.dta", keep (1 3) nogen
replace area_meas_hectares=area_est_hectares if area_meas_hectares==.

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
 
_pctile plot_value_harvest  [aw=weight] , p(99) 
gen w_plot_value_harvest=plot_value_harvest
replace w_plot_value_harvest = r(r1) if w_plot_value_harvest > r(r1) & w_plot_value_harvest != . 
lab var w_plot_value_harvest "Value of crop harvest on this plot - Winsorized top 1%"

*generate land and labor productivity using winsorized values
gen plot_productivity = w_plot_value_harvest/ w_area_meas_hectares
lab var plot_productivity "Plot productivity Value production/hectare"

*productivity at the plot level
gen plot_labor_prod = w_plot_value_harvest/w_labor_total  	
lab var plot_labor_prod "Plot labor productivity (value production/labor-day)"

*winsorize both land and labor productivity at top 1% only
gen plot_weight=w_area_meas_hectares*weight 
lab var plot_weight "Weight for plots (weighted by plot area)"
foreach v of varlist  plot_productivity  plot_labor_prod {
	_pctile `v' [aw=plot_weight] , p(99) 
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top 1%"
}	
	
*Convert monetary values to USD and PPP
global monetary_val plot_value_harvest plot_productivity plot_labor_prod 

foreach p of global monetary_val {
	gen `p'_1ppp = (1+$NPS_LSMS_ISA_W1_inflation) * `p' / $NPS_LSMS_ISA_W1_cons_ppp_dollar 
	gen `p'_2ppp = (1+$NPS_LSMS_ISA_W1_inflation) * `p' / $NPS_LSMS_ISA_W1_gdp_ppp_dollar 
	gen `p'_usd = (1+$NPS_LSMS_ISA_W1_inflation) * `p' / $NPS_LSMS_ISA_W1_exchange_rate 
	gen `p'_loc = (1+$NPS_LSMS_ISA_W1_inflation) * `p'
	local l`p' : var lab `p' 
	lab var `p'_1ppp "`l`p'' (2016 $ Private Consumption PPP)"
	lab var `p'_2ppp "`l`p'' (2016 $ GDP PPP)"
	lab var `p'_usd "`l`p'' (2016 $ USD)"
	lab var `p'_loc "`l`p'' (2016 TSH)"
	lab var `p' "`l`p'' (TSH)"  
	gen w_`p'_1ppp = (1+$NPS_LSMS_ISA_W1_inflation) * w_`p' / $NPS_LSMS_ISA_W1_cons_ppp_dollar 
	gen w_`p'_2ppp = (1+$NPS_LSMS_ISA_W1_inflation) * w_`p' / $NPS_LSMS_ISA_W1_gdp_ppp_dollar 
	gen w_`p'_usd = (1+$NPS_LSMS_ISA_W1_inflation) * w_`p' / $NPS_LSMS_ISA_W1_exchange_rate 
	gen w_`p'_loc = (1+$NPS_LSMS_ISA_W1_inflation) * w_`p' 
	local lw_`p' : var lab w_`p'
	lab var w_`p'_1ppp "`lw_`p'' (2016 $ Private Consumption PPP)"
	lab var w_`p'_2ppp "`lw_`p'' (2016 $ GDP PPP)"
	lab var w_`p'_usd "`lw_`p'' (2016 $ USD)"
	lab var w_`p'_loc "`lw_`p'' (2016 TSH)"
	lab var w_`p' "`lw_`p'' (TSH)"  
}
 
   
*We are reporting two variants of gender-gap
* mean difference in log productivitity without and with controls (plot size and region/state)
* both can be obtained using a simple regression.
* use clustered standards errors
qui svyset clusterid [pweight=plot_weight], strata(strataid) singleunit(centered) // get standard errors of the mean
* SIMPLE MEAN DIFFERENCE
gen male_dummy=dm_gender==1  if  dm_gender!=3 & dm_gender!=. //generate dummy equals to 1 if plot managed by male only and 0 if managed by female only


*Gender-gap 1a 
gen lplot_productivity_usd=ln(w_plot_productivity_usd)
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

//////////Identifier Variables ////////
*Add variables and rename household id so dta file can be appended with dta files from other instruments
gen geography = "Tanzania"
gen survey = "LSMS-ISA"
gen year = "2008-09"
gen instrument = 1
label define instrument 1 "TZA NPS Wave 1" 2 "TZA NPS Wave 2" 3 "TZA NPS Wave 3" 4 "TZA NPS Wave 4" /*
	*/ 5 "ETH ESS Wave 1" 6 "ETH ESS Wave 2" 7 "ETH ESS Wave 3" /*
	*/ 8 "NGA GHSP Wave 1" 9 "NGA GHSP Wave 2" 10 "NGA GHSP Wave 3" /*
	*/ 11 "Tanzania TBS AgDev (Lake Zone)" 12 "Tanzania TBS AgDev (Northern Zone)" 13 "Tanzania TBS AgDev (Southern Zone)" /*
	*/ 14 "ETH ACC Baseline" /*
	*/ 15 "India RMS Baseline (Bihar)" 16 "India RMS Baseline (Odisha)" 17 "India RMS Baseline (Uttar Pradesh)" 18 "India RMS Baseline (West Bengal)" /*
	*/ 19 "Nigeria NIBAS AgDev (Nassarawa)" 20 "Nigeria NIBAS AgDev (Benue)" 21 "Nigeria NIBAS AgDev (Kaduna)" /*
	*/ 22 "Nigeria NIBAS AgDev (Niger)" 23 "Nigeria NIBAS AgDev (Kano)" 24 "Nigeria NIBAS AgDev (Katsina)" 
label values instrument instrument	 


save "${TZA_W1_final_data}\Tanzania_NPS_LSMS_ISA_W1_gender_productivity_gap.dta", replace

**************
*SUMMARY STATISTICS
************** 
/*
All the pre-processed files include all households, individuals, and plots in the sample. 
The summary statistics are outputted only for the sub_population of households, individuals, and plots in rural areas. 
To consider a different sup_population or the entire sample, you have to modify the condition "if rural==1".
*/ 

set  matsize 10000

//Change this for each instrument
global final_data_household  "${TZA_W1_final_data}/Tanzania_NPS_LSMS_ISA_W1_household_variables.dta"  
global final_data_individual "${TZA_W1_final_data}/Tanzania_NPS_LSMS_ISA_W1_individual_variables.dta"
global final_data_plot       "${TZA_W1_final_data}\Tanzania_NPS_LSMS_ISA_W1_gender_productivity_gap.dta"
global final_outputfile      "$TZA_W1_final_data\Tanzania_NPS_LSMS_ISA_W1_summary_stats_100818.xlsx"
 

use "$final_data_household", replace
*Group 1 : All variables that uses household weights
*Disagregate total income and per_capita income by farm type
foreach v of varlist /*
*/ w_share_crop w_total_income_1ppp w_percapita_income_1ppp /*
*/ w_crop_income_1ppp w_cost_expli_hh_1ppp  w_daily_percap_cons_1ppp /*
*/ w_daily_peraeq_cons_1ppp w_total_income_2ppp w_percapita_income_2ppp /*
*/ w_crop_income_2ppp w_cost_expli_hh_2ppp w_daily_percap_cons_2ppp /*
*/w_daily_peraeq_cons_2ppp w_total_income_loc w_percapita_income_loc /*
*/ w_crop_income_loc w_cost_expli_hh_loc w_daily_percap_cons_loc /*
*/ w_daily_peraeq_cons_loc { 
	gen `v'0Ha=`v' if farm_size_0_0==1
	gen `v'01Ha=`v' if farm_size_0_1==1
	gen `v'12Ha=`v' if farm_size_1_2==1
	gen `v'24Ha=`v' if farm_size_2_4==1
	gen `v'4Ha_=`v' if farm_size_4_more==1
	local l`v' : var lab `v'
	lab var `v'0Ha "`l`v'' - HH with no farm"
	lab var `v'01Ha "`l`v'' - HH with farm size [0-1 Ha]"
	lab var `v'12Ha "`l`v'' - HH with farm size [1-2 Ha]"
	lab var `v'24Ha "`l`v'' - HH with farm size ]2-h Ha]"
	lab var `v'4Ha_ "`l`v'' - HH with farm size ]4 ha and more"
}
*Generating farm size variables by crop
foreach v in $topcropname_area {
	gen grew_`v'01Ha=grew_`v' if farm_size_0_1==1
	gen grew_`v'12Ha=grew_`v' if farm_size_1_2==1
	gen grew_`v'24Ha=grew_`v' if farm_size_2_4==1
	gen grew_`v'4Ha=grew_`v' if farm_size_4_more==1
}

*renaming variables with names that are too long
foreach i in 1ppp 2ppp loc{
	rename w_livestock_income_`i' w_lvstck_income_`i'
	rename w_fishing_income_`i' w_fish_income_`i'
	rename w_self_employment_income_`i' w_self_emp_income_`i'
}

*Crop income, livestock income, fishing income, livestock_holding, are reported for 2 different subpopulation : all rural HH and rural HH engaged in the specific activities
foreach v of varlist  w_crop_income*ppp* w_crop_income*loc* w_share_crop* {
	local l`v' : var lab `v' 
	gen `v'4crop1=`v' if crop_hh==1
	lab var `v'4crop1 "`l`v'' - only for crop producing household"
}
foreach v of varlist w_lvstck_income_1ppp w_lvstck_income_2ppp w_lvstck_income_loc w_share_livestock lvstck_holding* {
	local l`v' : var lab `v' 
	gen `v'4ls_hh=`v' if livestock_hh==1
	lab var `v'4ls_hh "`l`v'' - only for livestock producing household"
}
foreach v of varlist  w_fish_income_1ppp w_fish_income_2ppp w_fish_income_loc w_share_fishing  {
	local l`v' : var lab `v' 
	gen `v'4fish_hh=`v' if fishing_hh==1
	lab var `v'4fish_hh "`l`v'' - only for household with fishing income"
}

*Variables that are not in Wave 1
gen w_nonagwage_income_1ppp = 0
gen w_agwage_income_1ppp =0
gen w_nonagwage_income_2ppp = 0
gen w_agwage_income_loc =0
gen w_nonagwage_income_loc = 0
gen w_agwage_income_2ppp =0
gen use_fin_serv_bank = 0
gen use_fin_serv_digital = 0 
gen w_share_nonagwage = 0
gen w_share_agwage = 0
gen share_imp_dairy=0
*Set maize improved seed adoption to missing if household is not growing crop
foreach cn in $topcropname_area {
	replace imprv_seed_`cn' =. if grew_`cn'==0 | grew_`cn'==.
	recode imprv_seed_`cn' (.=0) if grew_`cn'==1
	replace hybrid_seed_`cn' =. if grew_`cn'==0 | grew_`cn'==.
	recode hybrid_seed_`cn' (.=0) if grew_`cn'==1
}

// HHS and dist_agrodealer are not calculable in this data set
gen hhs_little = 0 
gen hhs_moderate = 0 
gen hhs_severe = 0
gen hhs_total = 0 
gen w_dist_agrodealer = 0


// This section was brought in line with the updated version.
global household_vars1 /*
*/ w_total_income_1ppp w_total_income_1ppp0Ha w_total_income_1ppp01Ha w_total_income_1ppp12Ha w_total_income_1ppp24Ha w_total_income_1ppp4Ha_  /*
*/ w_total_income_2ppp w_total_income_2ppp0Ha w_total_income_2ppp01Ha w_total_income_2ppp12Ha w_total_income_2ppp24Ha w_total_income_2ppp4Ha_  /*
*/ w_total_income_loc w_total_income_loc0Ha w_total_income_loc01Ha w_total_income_loc12Ha w_total_income_loc24Ha w_total_income_loc4Ha_  /*
*/ w_percapita_income_1ppp w_percapita_income_1ppp0Ha w_percapita_income_1ppp01Ha w_percapita_income_1ppp12Ha w_percapita_income_1ppp24Ha w_percapita_income_1ppp4Ha_ /*
*/ w_percapita_income_2ppp w_percapita_income_2ppp0Ha w_percapita_income_2ppp01Ha w_percapita_income_2ppp12Ha w_percapita_income_2ppp24Ha w_percapita_income_2ppp4Ha_ /*
*/ w_percapita_income_loc w_percapita_income_loc0Ha w_percapita_income_loc01Ha w_percapita_income_loc12Ha w_percapita_income_loc24Ha w_percapita_income_loc4Ha_ /*
*/ w_percapita_cons_1ppp w_percapita_cons_2ppp w_percapita_cons_loc /* 
*/ w_daily_percap_cons_1ppp w_daily_percap_cons_1ppp0Ha w_daily_percap_cons_1ppp01Ha w_daily_percap_cons_1ppp12Ha w_daily_percap_cons_1ppp24Ha w_daily_percap_cons_1ppp4Ha_ /*
*/ w_daily_percap_cons_2ppp w_daily_percap_cons_2ppp0Ha w_daily_percap_cons_2ppp01Ha w_daily_percap_cons_2ppp12Ha w_daily_percap_cons_2ppp24Ha w_daily_percap_cons_2ppp4Ha_ /*
*/ w_daily_percap_cons_loc w_daily_percap_cons_loc0Ha w_daily_percap_cons_loc01Ha w_daily_percap_cons_loc12Ha w_daily_percap_cons_loc24Ha w_daily_percap_cons_loc4Ha_ /*
*/ w_peraeq_cons_1ppp w_peraeq_cons_2ppp w_peraeq_cons_loc /*
*/ w_daily_peraeq_cons_1ppp w_daily_peraeq_cons_1ppp0Ha w_daily_peraeq_cons_1ppp01Ha w_daily_peraeq_cons_1ppp12Ha w_daily_peraeq_cons_1ppp24Ha w_daily_peraeq_cons_1ppp4Ha_ /*
*/ w_daily_peraeq_cons_2ppp w_daily_peraeq_cons_2ppp0Ha w_daily_peraeq_cons_2ppp01Ha w_daily_peraeq_cons_2ppp12Ha w_daily_peraeq_cons_2ppp24Ha w_daily_peraeq_cons_2ppp4Ha_ /*
*/ w_daily_peraeq_cons_loc w_daily_peraeq_cons_loc0Ha w_daily_peraeq_cons_loc01Ha w_daily_peraeq_cons_loc12Ha w_daily_peraeq_cons_loc24Ha w_daily_peraeq_cons_loc4Ha_ /*
*/ w_crop_income_1ppp w_crop_income_1ppp01Ha w_crop_income_1ppp12Ha w_crop_income_1ppp24Ha w_crop_income_1ppp4Ha_ /*
*/ w_crop_income_1ppp4crop1 w_crop_income_1ppp01Ha4crop1 w_crop_income_1ppp12Ha4crop1 w_crop_income_1ppp24Ha4crop1 w_crop_income_1ppp4Ha_4crop1 /*
*/ w_crop_income_2ppp w_crop_income_2ppp01Ha w_crop_income_2ppp12Ha w_crop_income_2ppp24Ha w_crop_income_2ppp4Ha_ /*
*/ w_crop_income_2ppp4crop1 w_crop_income_2ppp01Ha4crop1 w_crop_income_2ppp12Ha4crop1 w_crop_income_2ppp24Ha4crop1 w_crop_income_2ppp4Ha_4crop1 /*
*/ w_crop_income_loc w_crop_income_loc01Ha w_crop_income_loc12Ha w_crop_income_loc24Ha w_crop_income_loc4Ha_ /*
*/ w_crop_income_loc4crop1 w_crop_income_loc01Ha4crop1 w_crop_income_loc12Ha4crop1 w_crop_income_loc24Ha4crop1 w_crop_income_loc4Ha_4crop1 /*
*/ w_lvstck_income_1ppp w_lvstck_income_1ppp4ls_hh /*
*/ w_lvstck_income_2ppp w_lvstck_income_2ppp4ls_hh /*
*/ w_lvstck_income_loc w_lvstck_income_loc4ls_hh /*
*/ w_fish_income_1ppp w_fish_income_1ppp4fish_hh /*
*/ w_fish_income_2ppp w_fish_income_2ppp4fish_hh /*
*/ w_fish_income_loc w_fish_income_loc4fish_hh /*
*/ w_nonagwage_income_1ppp w_nonagwage_income_2ppp w_nonagwage_income_loc w_agwage_income_1ppp w_agwage_income_2ppp w_agwage_income_loc /*
*/ w_self_emp_income_1ppp w_self_emp_income_2ppp w_self_emp_income_loc/*
*/ w_transfers_income_1ppp w_transfers_income_2ppp w_transfers_income_loc /*
*/ w_all_other_income_1ppp  w_all_other_income_2ppp w_all_other_income_loc /*
*/ w_nonfarm_income_1ppp w_nonfarm_income_2ppp w_nonfarm_income_loc/*
*/ w_share_crop w_share_crop01Ha w_share_crop12Ha w_share_crop24Ha w_share_crop4Ha_ /*
*/ w_share_crop4crop1 w_share_crop01Ha4crop1 w_share_crop12Ha4crop1 w_share_crop24Ha4crop1 w_share_crop4Ha_4crop1 /*
*/ w_share_livestock w_share_livestock4ls_hh w_share_fishing w_share_fishing4fish_hh w_share_nonagwage w_share_agwage w_share_self_employment w_share_transfers w_share_all_other w_share_nonfarm /*
*/ w_proportion_cropvalue_sold w_farm_size_agland hh_members adulteq w_labor_family w_labor_hired /*
*/ use_inorg_fert vac_animal vac_animal_lrum vac_animal_srum vac_animal_poultry /*
*/ ext_reach_all ext_reach_public ext_reach_private ext_reach_unspecified ext_reach_ict /*
*/ use_fin_serv_bank use_fin_serv_credit use_fin_serv_insur use_fin_serv_digital use_fin_serv_others use_fin_serv_all /* 
*/ lvstck_holding_tlu lvstck_holding_tlu4ls_hh lvstck_holding_all lvstck_holding_all4ls_hh   /*
*/ lvstck_holding_lrum lvstck_holding_lrum4ls_hh lvstck_holding_srum lvstck_holding_srum4ls_hh  lvstck_holding_poultry lvstck_holding_poultry4ls_hh /*
*/ w_mortality_rate_lrum w_mortality_rate_srum w_mortality_rate_poultry /*
*/ any_imp_herd_all any_imp_herd_lrum any_imp_herd_srum any_imp_herd_poultry share_imp_dairy /*
*/ share_livestock_prod_sold formal_land_rights_hh w_livestock_expenses_1ppp w_livestock_expenses_2ppp w_livestock_expenses_loc w_off_farm_hours_pc_all w_off_farm_hours_pc_any /*
*/ months_food_insec value_assets_1ppp value_assets_2ppp value_assets_loc /*
*/ hhs_little hhs_moderate hhs_severe hhs_total w_dist_agrodealer imprv_seed_use

foreach cn in $topcropname_area {
	global household_vars1 $household_vars1 imprv_seed_`cn' hybrid_seed_`cn' 
}


global final_indicator1 ""
foreach v of global household_vars1 {
	*first disaggregate by gender of the head of household
	local l`v' : var lab `v' 
	gen `v'_fhh=`v' if fhh==1
	lab var `v'_fhh "`l`v'' - FHH"
	gen `v'_mhh=`v' if fhh==0
	lab var `v'_mhh "`l`v'' - MHH"
	global final_indicator1 $final_indicator1 `v'  `v'_fhh  `v'_mhh
}
 

 
tabstat ${final_indicator1} [aw=weight] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save

matrix final_indicator1=r(StatTotal)'
qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered) // get standard errors of the mean
matrix semean1=(.)
matrix colnames semean1=semean_wei
foreach v of global final_indicator1 {
local missing_var ""
	findname `v',  all(@==.) local (missing_var)
	if "`missing_var'"!="" { 
		qui replace `v'=0
	}	
	qui svy, subpop(if rural==1): mean `v'
	matrix semean1=semean1\(el(r(table),2,1))
}
matrix final_indicator1=final_indicator1,semean1[2..rowsof(semean1),.]
matrix list final_indicator1


*Group 2: labor_productivity_ppp and land_productivity_ppp at the household level 
gen w_labor_weight=weight*w_labor_total
gen w_land_weight=weight*w_farm_area

matrix final_indicator2=(.,.,.,.,.,.,.,.,.)
matrix final_indicator2a=(.,.,.,.,.,.,.,.,.)
global household_indicators2a  w_labor_productivity_1ppp w_labor_productivity_2ppp w_labor_productivity_loc

foreach v of global household_indicators2a {
	global final_indicator2a ""	
	local l`v' : var lab `v' 
	gen `v'_fhh=`v' if fhh==1
	lab var `v'_fhh "`l`v'' - FHH"
	gen `v'_mhh= `v' if fhh==0
	lab var `v'_mhh "`l`v'' - MHH"
	global final_indicator2a $final_indicator2a `v' `v'_fhh  `v'_mhh
	tabstat $final_indicator2a [aw=w_labor_weight] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp2=r(StatTotal)'	
	qui svyset clusterid [pweight=w_labor_weight], strata(strataid) singleunit(centered) // get standard errors of the mean
	matrix semean2=(.)
	matrix colnames semean2=semean_wei
	foreach v of global final_indicator2a {
		qui svy, subpop(if rural==1): mean `v' 
		matrix semean2=semean2\(el(r(table),2,1))
	}
	matrix temp2=temp2,semean2[2..rowsof(semean2),.]
	matrix final_indicator2a=final_indicator2a\temp2
}	

matrix final_indicator2b=(.,.,.,.,.,.,.,.,.)
global household_indicators2b w_land_productivity_1ppp w_land_productivity_2ppp w_land_productivity_loc
foreach v of global household_indicators2b {
	global final_indicator2b ""	
	local l`v' : var lab `v' 
	gen `v'_fhh=`v' if fhh==1
	lab var `v'_fhh "`l`v'' - FHH"
	gen `v'_mhh= `v' if fhh==0
	lab var `v'_mhh "`l`v'' - MHH"
	global final_indicator2b $final_indicator2b `v' `v'_fhh  `v'_mhh
	tabstat $final_indicator2b [aw=w_land_weight] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp2=r(StatTotal)'	
	qui svyset clusterid [pweight=w_land_weight], strata(strataid) singleunit(centered) // get standard errors of the mean
	matrix semean2=(.)
	matrix colnames semean2=semean_wei
	foreach v of global final_indicator2b {
		qui svy, subpop(if rural==1): mean `v' 
		matrix semean2=semean2\(el(r(table),2,1))
	}
	matrix temp2=temp2,semean2[2..rowsof(semean2),.]
	matrix final_indicator2b=final_indicator2b\temp2
}	


matrix final_indicator2a =final_indicator2a[2..rowsof(final_indicator2a), .]
matrix final_indicator2b =final_indicator2b[2..rowsof(final_indicator2b), .]
matrix final_indicator2  = final_indicator2a\final_indicator2b 

matrix list final_indicator2 


*Group 3 : daily wage in  agriculture
*first generage missing value of wage paid to female and to male in Tanzania as were not able to disagregated by gender

ren w_wage_paid_aglabor_1ppp w_wage_paid_aglabor_all_1ppp
ren w_wage_paid_aglabor_2ppp w_wage_paid_aglabor_all_2ppp
ren w_wage_paid_aglabor_loc w_wage_paid_aglabor_all_loc

recode w_wage_paid_aglabor_male_1ppp w_wage_paid_aglabor_female_1ppp w_wage_paid_aglabor_male_2ppp w_wage_paid_aglabor_female_2ppp w_wage_paid_aglabor_male_loc w_wage_paid_aglabor_female_loc(.=0) 
gen w_aglabor_weight_all=w_labor_hired*weight
lab var w_aglabor_weight_all "Hired labor-adjusted household weights"
gen w_aglabor_weight_female=1  
lab var w_aglabor_weight_female "Hired labor-adjusted household weights -female workers"
gen w_aglabor_weight_male=1 
lab var w_aglabor_weight_male "Hired labor-adjusted household weights -male workers"

global final_indicator3a "all female male"
matrix final_indicator3a=(.,.,.,.,.,.,.,.,.)
foreach v of global final_indicator3a {
	tabstat w_wage_paid_aglabor_`v'_1ppp [aw=w_aglabor_weight_`v'] if rural==1, stat(mean  sd p25 p50 p75  min max N) col(stat) save
	matrix temp4=r(StatTotal)'
	svyset clusterid [pweight=w_aglabor_weight_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean	
	capture noisily qui svy, subpop(if rural==1): mean w_wage_paid_aglabor_`v'_1ppp
	matrix final_indicator3a=final_indicator3a\(temp4,el(r(table),2,1))
}
matrix final_indicator3a =final_indicator3a[2..rowsof(final_indicator3a), .]


global final_indicator3a "all female male"
matrix final_indicator3b=(.,.,.,.,.,.,.,.,.)
foreach v of global final_indicator3a {
	tabstat w_wage_paid_aglabor_`v'_2ppp [aw=w_aglabor_weight_`v'] if rural==1, stat(mean  sd p25 p50 p75  min max N) col(stat) save
	matrix temp4=r(StatTotal)'
	svyset clusterid [pweight=w_aglabor_weight_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean	
	capture noisily qui svy, subpop(if rural==1): mean w_wage_paid_aglabor_`v'_2ppp
	matrix final_indicator3b=final_indicator3b\(temp4,el(r(table),2,1))
}
matrix final_indicator3b =final_indicator3b[2..rowsof(final_indicator3b), .]

global final_indicator3a "all female male"
matrix final_indicator3c=(.,.,.,.,.,.,.,.,.)
foreach v of global final_indicator3a {
	tabstat w_wage_paid_aglabor_`v'_loc [aw=w_aglabor_weight_`v'] if rural==1, stat(mean  sd p25 p50 p75  min max N) col(stat) save
	matrix temp4=r(StatTotal)'
	svyset clusterid [pweight=w_aglabor_weight_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean	
	capture noisily qui svy, subpop(if rural==1): mean w_wage_paid_aglabor_`v'_loc
	matrix final_indicator3c=final_indicator3c\(temp4,el(r(table),2,1))
}
matrix final_indicator3c =final_indicator3c[2..rowsof(final_indicator3c), .]

matrix final_indicator3 = final_indicator3a\final_indicator3b\final_indicator3c
matrix list final_indicator3 


** Group 4  - yields 

global final_indicator4=""
foreach v in $topcropname_area {
	global final_indicator4 $final_indicator4 `v' female_`v' male_`v' mixed_`v'
}

foreach v in $topcropname_area {
	global final_indicator4 $final_indicator4 pure_`v' pure_female_`v' pure_male_`v' pure_mixed_`v' 
}

*No cassava or banana yield in this instrument (no area planted or harvested) - add in any other permanent crops here
foreach v in cassav banana {
	replace w_yield_hv_`v' = 0
	replace w_yield_pl_`v' = 0
	recode ar_h_wgt_`v' (.=1)
	recode ar_pl_wgt_`v' (.=1)
	foreach i in female male mixed pure pure_female pure_male pure_mixed {
		replace w_yield_hv_`i'_`v' = 0
		replace w_yield_pl_`i'_`v' = 0
		recode ar_h_wgt_`i'_`v' (.=1)
		recode ar_pl_wgt_`i'_`v' (.=1)
	}
}

// recoding variables with 0 observations
foreach v in pure_female_yam {
	recode w_yield_pl_`v' (.=0)
	recode ar_pl_wgt_`v' (.=1)
	recode w_yield_hv_`v' (.=0)
	recode ar_h_wgt_`v' (.=1)

}
matrix final_indicator4a=(.,.,.,.,.,.,.,.,.)
foreach v of global final_indicator4 {
	tabstat w_yield_hv_`v' [aw=ar_h_wgt_`v'] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp4=r(StatTotal)'
	qui svyset clusterid [pweight=ar_h_wgt_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean	
	qui svy, subpop(if rural==1): mean w_yield_hv_`v'
	matrix final_indicator4a=final_indicator4a\(temp4,el(r(table),2,1))	
}

matrix final_indicator4b=(.,.,.,.,.,.,.,.,.)
foreach v of global final_indicator4 {
	tabstat w_yield_pl_`v' [aw=ar_pl_wgt_`v'] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp4=r(StatTotal)'
	qui svyset clusterid [pweight=ar_pl_wgt_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean	
	qui svy, subpop(if rural==1): mean w_yield_pl_`v'
	matrix final_indicator4b=final_indicator4b\(temp4,el(r(table),2,1))	
}


matrix final_indicator4a =final_indicator4a[2..rowsof(final_indicator4a), .]
matrix final_indicator4b =final_indicator4b[2..rowsof(final_indicator4b), .]

matrix final_indicator4  = final_indicator4a\final_indicator4b 
matrix list final_indicator4

* Group 5  - milk and egg productivity
ren w_liters_per_largeruminant w_liters_per_all
replace w_liters_per_all=0 
gen w_egg_poultry_year=0 
gen w_liters_per_cow=0 
gen w_liters_per_buffalo=0 
gen milk_animals = 0
gen poultry_owned = 0


lab var w_liters_per_cow "average quantity (liters) per day (household) - cow"
lab var w_liters_per_buffalo "average quantity (liters) per day (household) - buffalo"
gen weight_milk=milk_animals*weight
gen weight_egg=poultry_owned*weight


recode weight_milk (0=1)
recode weight_egg (0=1) 


replace w_liters_milk_produced=. if w_liters_milk_produced == 0 
 // no data on  milking animal reported, so we set zero values to missing if no milk is produced
replace w_eggs_total_year=. if w_eggs_total_year==0


foreach v in 1ppp 2ppp loc {
	replace w_value_milk_produced_`v'=. if w_liters_milk_produced == 0 | w_liters_milk_produced == .
	replace w_value_eggs_produced_`v'=. if w_eggs_total_year==0 | w_eggs_total_year == .
}

global household_indicators5 liters_per_all liters_per_cow liters_per_buffalo costs_dairy_1ppp costs_dairy_2ppp costs_dairy_loc /*
*/ cost_per_lit_milk_1ppp cost_per_lit_milk_2ppp cost_per_lit_milk_loc /*
*/ costs_dairy_percow_1ppp  costs_dairy_percow_2ppp  costs_dairy_percow_loc  egg_poultry_year

global final_indicator5  
foreach v of global household_indicators5 {
	local l`v' : var lab w_`v' 
	gen w_`v'_fhh=w_`v' if fhh==1
	lab var w_`v'_fhh "`l`v'' - FHH"
	gen w_`v'_mhh=w_`v' if fhh==0
	lab var w_`v'_mhh "`l`v'' - MHH"
}



*Add condition that household must be engaged in livestock production
global milkvar w_liters_per_all w_liters_per_all_fhh w_liters_per_all_mhh w_liters_per_cow w_liters_per_cow_fhh w_liters_per_cow_mhh /*
*/ w_liters_per_buffalo w_liters_per_buffalo_fhh w_liters_per_buffalo_mhh /*
*/ w_costs_dairy_1ppp w_costs_dairy_1ppp_fhh w_costs_dairy_1ppp_mhh /*
*/ w_costs_dairy_2ppp w_costs_dairy_2ppp_fhh w_costs_dairy_2ppp_mhh /*
*/ w_costs_dairy_loc w_costs_dairy_loc_fhh w_costs_dairy_loc_mhh /*
*/ w_costs_dairy_percow_1ppp w_costs_dairy_percow_1ppp_fhh w_costs_dairy_percow_1ppp_mhh /*
*/ w_costs_dairy_percow_2ppp w_costs_dairy_percow_2ppp_fhh w_costs_dairy_percow_2ppp_mhh /*
*/ w_costs_dairy_percow_loc w_costs_dairy_percow_loc_fhh w_costs_dairy_percow_loc_mhh /*
*/ w_cost_per_lit_milk_1ppp w_cost_per_lit_milk_1ppp_fhh w_cost_per_lit_milk_1ppp_mhh /*
*/ w_cost_per_lit_milk_2ppp w_cost_per_lit_milk_2ppp_fhh w_cost_per_lit_milk_2ppp_mhh /*
*/ w_cost_per_lit_milk_loc w_cost_per_lit_milk_loc_fhh w_cost_per_lit_milk_loc_mhh


tabstat $milkvar  [aw=weight_milk] if rural==1 & livestock_hh==1 , stat(mean sd p25 p50 p75  min max N) col(stat) save 
matrix final_indicator5=r(StatTotal)' 
qui svyset clusterid [pweight=weight_milk], strata(strataid) singleunit(centered) // get standard errors of the mean	
matrix semean5=(.)
matrix colnames semean5=semean_wei
foreach v of global milkvar {
local missing_var ""
	findname `v',  all(@==.) local (missing_var)
	if "`missing_var'"!="" { 
		qui replace `v'=0
	}
	qui svy, subpop(if rural==1  & livestock_hh==1 ): mean `v'
	matrix semean5=semean5\(el(r(table),2,1))
}
matrix final_indicator5=final_indicator5,semean5[2..rowsof(semean5),.]

global eggvar w_egg_poultry_year w_egg_poultry_year_fhh w_egg_poultry_year_mhh
tabstat $eggvar [aw=weight_egg] if rural==1  & livestock_hh==1 , stat(mean sd p25 p50 p75  min max N) col(stat) save  //Add condition that HH must be engaged in livestock production
matrix temp5=r(StatTotal)' 
matrix semean5=(.)
matrix colnames semean5=semean_wei
foreach v of global eggvar {
	qui svy, subpop(if rural==1 & livestock_hh==1 ): mean `v'  
	matrix semean5=semean5\(el(r(table),2,1))
}
matrix temp5=temp5,semean5[2..rowsof(semean5),.]
matrix final_indicator5=final_indicator5\temp5
matrix list final_indicator5 


* Group 6  - inorg_fert_rate_all
ren w_inorg_fert_rate w_inorg_fert_rate_all
ren ha_planted w_ha_planted_all
*We are report inorg_fert_rate for 2 sub-population
*All rural housholds engaged in crop production
*All rural households engaged in crop production using inorganic fertilizer
recode w_inorg_fert_rate* (.=0) if crop_hh==1
global final_indicator6 ""
global fert_vars all female male  mixed
foreach  v of global fert_vars {
	gen  area_weight_`v'=weight*w_ha_planted_`v'
	local l`v' : var lab w_inorg_fert_rate_`v' 
	gen w_inorg_fert_rate_`v'use_fert=w_inorg_fert_rate_`v'  if  w_inorg_fert_rate_`v'!=0
	lab var w_inorg_fert_rate_`v'use_fert "`l`v'' - only household using ferttilizer"
}
*all hh engaged in crop production
global final_indicator6 all female male mixed
matrix final_indicator6=(.,.,.,.,.,.,.,.,.)
foreach v of global final_indicator6 {
	tabstat w_inorg_fert_rate_`v' [aw=area_weight_`v'] if rural==1,  stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp6=r(StatTotal)'
	qui svyset clusterid [pweight=area_weight_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean	
	capture noisily qui svy, subpop(if rural==1): mean w_inorg_fert_rate_`v'
	matrix final_indicator6=final_indicator6\(temp6,el(r(table),2,1))
}
*only hh engaged in crop production and using fertilizer
foreach v of global final_indicator6 {
	tabstat  w_inorg_fert_rate_`v'use_fert [aw=area_weight_`v'] if rural==1  & ag_hh==1  & w_inorg_fert_rate_`v'!=. & w_inorg_fert_rate_`v'!=0,  stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp6=r(StatTotal)'
	qui svyset clusterid [pweight=area_weight_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean	
	capture noisily qui svy, subpop(if rural==1): mean  w_inorg_fert_rate_`v'use_fert
	matrix final_indicator6=final_indicator6\(temp6,el(r(table),2,1))
}

matrix final_indicator6 =final_indicator6[2..rowsof(final_indicator6), .]
matrix list final_indicator6 
 

* Group 7  - total explicit cost at the household level, also by farm type and gender of HoH

global household_indicators7a cost_expli_hh_1ppp cost_expli_hh_1ppp01Ha /*
*/ cost_expli_hh_1ppp12Ha cost_expli_hh_1ppp24Ha cost_expli_hh_1ppp4Ha_  /*
*/ cost_expli_hh_2ppp cost_expli_hh_2ppp01Ha cost_expli_hh_2ppp12Ha /*
*/ cost_expli_hh_2ppp24Ha cost_expli_hh_2ppp4Ha_  /*
*/ cost_expli_hh_loc cost_expli_hh_loc01Ha cost_expli_hh_loc12Ha /*
*/ cost_expli_hh_loc24Ha cost_expli_hh_loc4Ha_ 

matrix final_indicator7a=(.,.,.,.,.,.,.,.,.)
foreach v of global household_indicators7a {
	global final_indicator7a ""	
	local l`v' : var lab w_`v' 
	gen w_`v'_fhh=w_`v' if fhh==1
	lab var w_`v'_fhh "`l`v'' - FHH"
	gen w_`v'_mhh=w_`v' if fhh==0
	lab var w_`v'_mhh "`l`v'' - MHH"
	global final_indicator7a $final_indicator7a w_`v'  w_`v'_fhh  w_`v'_mhh
	tabstat $final_indicator7a [aw=weight] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp7a=r(StatTotal)'	
	qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered) // get standard errors of the mean
	matrix semean7a=(.)
	matrix colnames semean7a=semean_wei
	foreach v of global final_indicator7a {
		qui svy, subpop(if rural==1): mean `v' 
		matrix semean7a=semean7a\(el(r(table),2,1))
	}
	matrix temp7a=temp7a,semean7a[2..rowsof(semean7a),.]
	matrix final_indicator7a=final_indicator7a\temp7a
}	
matrix final_indicator7a =final_indicator7a[2..rowsof(final_indicator7a), .]

global household_indicators7b cost_expli_hh_ha_1ppp cost_expli_hh_ha_2ppp cost_expli_hh_ha_loc

gen w_ha_planted_weight=w_ha_planted_all*weight
matrix final_indicator7b=(.,.,.,.,.,.,.,.,.)
foreach v of global household_indicators7b {
	global final_indicator7b ""	
	local l`v' : var lab w_`v' 
	gen w_`v'_fhh=w_`v' if fhh==1
	lab var w_`v'_fhh "`l`v'' - FHH"
	gen w_`v'_mhh=w_`v' if fhh==0
	lab var w_`v'_mhh "`l`v'' - MHH"
	global final_indicator7b $final_indicator7b w_`v'  w_`v'_fhh  w_`v'_mhh
	tabstat $final_indicator7b [aw=w_ha_planted_weight] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp7b=r(StatTotal)'	
	qui svyset clusterid [pweight=w_ha_planted_weight], strata(strataid) singleunit(centered) // get standard errors of the mean
	matrix semean7b=(.)
	matrix colnames semean7b=semean_wei
	foreach v of global final_indicator7b {
		qui svy, subpop(if rural==1): mean `v' 
		matrix semean7b=semean7b\(el(r(table),2,1))
	}
	matrix temp7b=temp7b,semean7b[2..rowsof(semean7b),.]
	matrix final_indicator7b=final_indicator7b\temp7b
}	

matrix final_indicator7b =final_indicator7b[2..rowsof(final_indicator7b), .]

matrix final_indicator7 =final_indicator7a\final_indicator7b
matrix list final_indicator7

* Group 8  - total explicit cost per ha by gender of plot manager, also by farm type
*Explicit cost by farm type
ren w_cost_expli_ha_1ppp w_cost_expli_ha_all_1ppp
ren w_cost_expli_ha_2ppp w_cost_expli_ha_all_2ppp
ren w_cost_expli_ha_loc w_cost_expli_ha_all_loc

global final_indicator8 all female male mixed
foreach v of global final_indicator8 {
	foreach i in 1ppp 2ppp loc {
		gen w_cost_expli_ha_`v'01Ha_`i'=w_cost_expli_ha_`v'_`i' if farm_size_0_1==1
		gen w_cost_expli_ha_`v'12Ha_`i'=w_cost_expli_ha_`v'_`i' if farm_size_1_2==1
		gen w_cost_expli_ha_`v'24Ha_`i'=w_cost_expli_ha_`v'_`i' if farm_size_2_4==1
		gen w_cost_expli_ha_`v'4Ha_`i'=w_cost_expli_ha_`v'_`i' if farm_size_4_more==1	
		local l`v' : var label w_cost_expli_ha_`v'_`i'
		lab var w_cost_expli_ha_`v'01Ha_`i' "`l`v'' - farm size [0-1 Ha]"
		lab var w_cost_expli_ha_`v'12Ha_`i' "`l`v'' - farm size [1-2 Ha]"
		lab var w_cost_expli_ha_`v'24Ha_`i' "`l`v'' - farm size ]2-h Ha]"
		lab var w_cost_expli_ha_`v'4Ha_`i' "`l`v'' - farm size ]4 ha and more"
	}
}


matrix final_indicator8=(.,.,.,.,.,.,.,.,.)
foreach v of global final_indicator8 {
	foreach i in 1ppp 2ppp loc {
		tabstat w_cost_expli_ha_`v'_`i' w_cost_expli_ha_`v'01Ha_`i' /*
		*/ w_cost_expli_ha_`v'12Ha_`i' w_cost_expli_ha_`v'24Ha_`i' /*
		*/ w_cost_expli_ha_`v'4Ha_`i'  [aw=w_ha_planted_weight]   if rural==1 & ag_hh==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
		matrix temp8=r(StatTotal)'
		qui svyset clusterid [pweight=w_ha_planted_weight], strata(strataid) singleunit(centered) // get standard errors of the mean	
		qui svy, subpop(if rural==1 & ag_hh==1): mean w_cost_expli_ha_`v'_`i'
		scalar se`v'= el(r(table),2,1)
		qui svy, subpop(if rural==1 & ag_hh==1): mean w_cost_expli_ha_`v'01Ha_`i' 
		scalar se`v'01Ha= el(r(table),2,1)
		qui svy, subpop(if rural==1 & ag_hh==1): mean w_cost_expli_ha_`v'12Ha_`i' 
		scalar se`v'12Ha= el(r(table),2,1)		
		qui svy, subpop(if rural==1 & ag_hh==1): mean w_cost_expli_ha_`v'24Ha_`i' 
		scalar se`v'24Ha= el(r(table),2,1)	
		qui svy, subpop(if rural==1 & ag_hh==1): mean w_cost_expli_ha_`v'4Ha_`i' 
		scalar se`v'4Ha_= el(r(table),2,1)	
		
		matrix temp8=temp8,(se`v'\se`v'01Ha\se`v'12Ha\se`v'24Ha\se`v'4Ha_)
		matrix final_indicator8=final_indicator8\temp8
	}	
}
matrix final_indicator8 =final_indicator8[2..rowsof(final_indicator8), .]
matrix list final_indicator8 


** Group 9 - costs_total_hh_ppp  (explicit and implicit)
foreach cn in $topcropname_area {
	gen ar_pl_mono_wgt_`cn'_all = weight*`cn'_monocrop_ha
	gen kgs_harv_wgt_`cn'_all = weight*kgs_harv_mono_`cn'

	foreach g in male female mixed{
		gen ar_pl_mono_wgt_`cn'_`g' = weight*`cn'_monocrop_ha_`g'
		gen kgs_harv_wgt_`cn'_`g' = weight*kgs_harv_mono_`cn'_`g'
	}
}

foreach i in 1ppp 2ppp loc {
	
	ren w_cost_total_ha_`i' w_cost_total_ha_all_`i'

	foreach v in $topcropname_area {
		ren w_`v'_exp_`i' w_`v'_exp_all_`i' 
		ren w_`v'_exp_ha_`i' w_`v'_exp_ha_all_`i'
		ren w_`v'_exp_kg_`i' w_`v'_exp_kg_all_`i'
	}
}

global final_indicator9 all female male mixed
matrix final_indicator9=(.,.,.,.,.,.,.,.,.)
foreach i in 1ppp 2ppp loc {
	foreach v of global final_indicator9 {
		tabstat w_cost_total_ha_`v'_`i'  [aw=area_weight_`v']  if rural==1 & ag_hh==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
		matrix temp9=r(StatTotal)'
		qui svyset clusterid [pweight=area_weight_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean	
		capture noisily qui svy, subpop(if rural==1 & ag_hh==1): mean w_cost_total_ha_`v'_`i'
		matrix final_indicator9=final_indicator9\(temp9,el(r(table),2,1))
	}
}

matrix final_indicator9 =final_indicator9[2..rowsof(final_indicator9), .]


// Changing variables with all missing obs
foreach i in 1ppp 2ppp loc {
	foreach x in yam {
		recode w_`x'_exp_female_`i' (.=0)
		recode w_`x'_exp_ha_female_`i' (.=0)
		recode w_`x'_exp_kg_female_`i' (.=0)
		recode ar_pl_mono_wgt_`x'_female (.=1)
		recode kgs_harv_wgt_`x'_female (.=1)
	}
}


matrix temp9b = (.,.,.,.,.,.,.,.,.)
foreach i in 1ppp 2ppp loc {
	foreach v of global final_indicator9 {
		foreach x in $topcropname_area {
			tabstat w_`x'_exp_`v'_`i'  [aw=weight]  if rural==1 & ag_hh==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
			matrix temp9c=r(StatTotal)'
			qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered) // get standard errors of the mean	
			capture noisily qui svy, subpop(if rural==1 & ag_hh==1): mean w_`x'_exp_`v'_`i'
			matrix temp9b=temp9b\(temp9c,el(r(table),2,1))
		}
	}
}
matrix temp9b =temp9b[2..rowsof(temp9b), .]



matrix temp9d = (.,.,.,.,.,.,.,.,.)
foreach i in 1ppp 2ppp loc {
	foreach v of global final_indicator9 {
		foreach x in $topcropname_area {
			tabstat w_`x'_exp_ha_`v'_`i'  [aw=ar_pl_mono_wgt_`x'_`v']  if rural==1 & ag_hh==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
			matrix temp9e=r(StatTotal)'
			qui svyset clusterid [pweight=ar_pl_mono_wgt_`x'_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean	
			capture noisily qui svy, subpop(if rural==1 & ag_hh==1): mean w_`x'_exp_`v'_`i'
			matrix temp9d=temp9d\(temp9e,el(r(table),2,1))
		}
	}
}
matrix temp9d =temp9d[2..rowsof(temp9d), .]

matrix temp9f = (.,.,.,.,.,.,.,.,.)

foreach i in 1ppp 2ppp loc {
	foreach v of global final_indicator9 {
		foreach x in $topcropname_area {
			tabstat w_`x'_exp_kg_`v'_`i'  [aw=kgs_harv_wgt_`x'_`v']  if rural==1 & ag_hh==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
			matrix temp9g=r(StatTotal)'
			qui svyset clusterid [pweight=kgs_harv_wgt_`x'_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean	
			capture noisily qui svy, subpop(if rural==1 & ag_hh==1): mean w_`x'_exp_`v'_`i'
			matrix temp9f=temp9f\(temp9g,el(r(table),2,1))
		}
	}
}

matrix temp9f =temp9f[2..rowsof(temp9f), .]

matrix final_indicator9 =final_indicator9\temp9b\temp9d\temp9f
matrix list final_indicator9

** Group 10 - per_capita income using individual weight
global final_indicator10a ""


foreach  v of varlist w_percapita_income_1ppp w_percapita_income_2ppp w_percapita_income_loc w_daily_percap_cons_1ppp w_daily_percap_cons_2ppp w_daily_percap_cons_loc {
	local l`v' : var lab `v' 
	gen `v'_nat= `v'  
	lab var `v'_nat "`l`v'' - using individual weight"
	gen `v'_nat_fhh=`v' if fhh==1	
	lab var `v'_nat_fhh "`l`v'' - FHH- using individual weight"
	gen `v'_nat_mhh=`v' if fhh==0	
	lab var `v'_nat_mhh "`l`v'' - MHH- using individual weight"
	global final_indicator10a $final_indicator10a `v'_nat  `v'_nat_fhh `v'_nat_mhh
}

global final_indicator10b ""
foreach i in 1ppp 2ppp loc {
	foreach  v of varlist w_daily_peraeq_cons_`i' {
		local l`v' : var lab `v' 
		gen `v'_nat= `v'  
		lab var `v'_nat "`l`v'' - using adult equivalent weight"
		gen `v'_nat_fhh=`v' if fhh==1	
		lab var `v'_nat_fhh "`l`v'' - FHH- using adult equivalent weight"
		gen `v'_nat_mhh=`v' if fhh==0	
		lab var `v'_nat_mhh "`l`v'' - MHH- using adult equivalent weight"
		global final_indicator10b $final_indicator10b `v'_nat  `v'_nat_fhh `v'_nat_mhh
	}
}
gen individual_weight=hh_members*weight
gen adulteq_weight=adulteq*weight

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

*percapita consumption
global final_indicator10c ""
foreach i in 1ppp 2ppp loc {
	foreach v of varlist w_daily_percap_cons_`i' {
		local l`v' : var lab `v' 
		gen `v'_b40= `v' if bottom_40_percap==1  
		lab var `v'_b40 "`l`v'' - limited to bottom 40% of consumption for rural population"
		gen `v'_b40_fhh=`v' if fhh==1	
		lab var `v'_b40_fhh "`l`v'' - limited to bottom 40% of consumption for rural population - FHH"
		gen `v'_b40_mhh=`v' if fhh==0	
		lab var `v'_b40_mhh "`l`v'' - limited to bottom 40% of consumption for rural population - MHH"
		global final_indicator10c $final_indicator10c `v'_b40 `v'_b40_fhh `v'_b40_mhh
		}
}

*adult equivalent consumption
global final_indicator10d ""
foreach i in 1ppp 2ppp loc {
	foreach v of varlist w_daily_peraeq_cons_`i' {
		local l`v' : var lab `v' 
		gen `v'_b40= `v' if bottom_40_peraeq==1  
		lab var `v'_b40 "`l`v'' - limited to bottom 40% of consumption for rural population - using adult equivalent weight"
		gen `v'_b40_fhh=`v' if fhh==1	
		lab var `v'_b40_fhh "`l`v'' - limited to bottom 40% of consumption for rural population - FHH - using adult equivalent weight"
		gen `v'_b40_mhh=`v' if fhh==0	
		lab var `v'_b40_mhh "`l`v'' - limited to bottom 40% of consumption for rural population - MHH - using adult equivalent weight"
		global final_indicator10d $final_indicator10d `v'_b40 `v'_b40_fhh `v'_b40_mhh
	}
}

* Rural poverty headcount
global final_indicator10e ""
foreach v of varlist poverty_under_1_9 {
	local l`v' : var lab `v' 
	gen `v'_fhh=`v' if fhh==1	
	lab var `v'_fhh "`l`v'' - FHH"
	gen `v'_mhh=`v' if fhh==0	
	lab var `v'_mhh "`l`v'' - MHH"
	global final_indicator10e $final_indicator10e `v'  `v'_fhh `v'_mhh
}	


matrix final_indicator10a=(.,.,.,.,.,.,.,.,.)
foreach v of global final_indicator10a {
	tabstat `v' [aw=individual_weight] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp10=r(StatTotal)'
	qui svyset clusterid [pweight=individual_weight], strata(strataid) singleunit(centered) // get standard errors of the mean	
	qui svy, subpop(if rural==1): mean  `v'
	matrix final_indicator10a=final_indicator10a\(temp10,el(r(table),2,1))	
}
matrix final_indicator10a =final_indicator10a[2..rowsof(final_indicator10a), .]

matrix final_indicator10b=(.,.,.,.,.,.,.,.,.)
foreach v of global final_indicator10b {
	tabstat `v' [aw=adulteq_weight] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp10=r(StatTotal)'
	qui svyset clusterid [pweight=adulteq_weight], strata(strataid) singleunit(centered) // get standard errors of the mean	
	qui svy, subpop(if rural==1): mean  `v'
	matrix final_indicator10b=final_indicator10b\(temp10,el(r(table),2,1))	
}

matrix final_indicator10b =final_indicator10b[2..rowsof(final_indicator10b), .]

matrix final_indicator10c=(.,.,.,.,.,.,.,.,.)
foreach v of global final_indicator10c {
	tabstat `v' [aw=individual_weight] if rural==1 & bottom_40_percap==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp10=r(StatTotal)'
	qui svyset clusterid [pweight=individual_weight], strata(strataid) singleunit(centered) // get standard errors of the mean	
	qui svy, subpop(if rural==1 & bottom_40_percap==1): mean  `v'
	matrix final_indicator10c=final_indicator10c\(temp10,el(r(table),2,1))	
}

matrix final_indicator10c =final_indicator10c[2..rowsof(final_indicator10c), .]

matrix final_indicator10d=(.,.,.,.,.,.,.,.,.)
foreach v of global final_indicator10d {
	tabstat `v' [aw=adulteq_weight] if rural==1 & bottom_40_peraeq==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp10=r(StatTotal)'
	qui svyset clusterid [pweight=adulteq_weight], strata(strataid) singleunit(centered) // get standard errors of the mean	
	qui svy, subpop(if rural==1 & bottom_40_peraeq==1): mean  `v'
	matrix final_indicator10d=final_indicator10d\(temp10,el(r(table),2,1))	
}

matrix final_indicator10d =final_indicator10d[2..rowsof(final_indicator10d), .]

matrix final_indicator10e=(.,.,.,.,.,.,.,.,.)
global poverty_count ""
qui svyset clusterid [pweight=individual_weight], strata(strataid) singleunit(centered) // get standard errors of the mean
foreach v of global final_indicator10e {
    gen tot_`v'=`v'
	local l`v' : var lab `v' 
	lab var tot_`v' " Total : `l`v''"
	svy, subpop(if rural==1): total  `v'
	matrix b=e(b)
	matrix V=e(V)
	matrix N=e(N)
	matrix final_indicator10e=final_indicator10e\(el(b,1,1),. ,. ,. ,. ,. ,. ,el(N,1,1),sqrt(el(V,1,1)))
	global poverty_count $poverty_count "tot_`v'"
}
matrix final_indicator10e = final_indicator10e[2..rowsof(final_indicator10e),.]
matrix rownames final_indicator10e = $poverty_count


// POVERTY RATIO
matrix final_indicator10f=(.,.,.,.,.,.,.,.,.)
foreach v of global final_indicator10e {
	tabstat `v' [aw=individual_weight] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp10=r(StatTotal)'
	qui svyset clusterid [pweight=individual_weight], strata(strataid) singleunit(centered) // get standard errors of the mean	
	qui svy, subpop(if rural==1): mean  `v'
	matrix final_indicator10f=final_indicator10f\(temp10,el(r(table),2,1))	
}
matrix final_indicator10f =final_indicator10f[2..rowsof(final_indicator10f), .]

matrix final_indicator10 =final_indicator10a\final_indicator10b\final_indicator10c\final_indicator10d\final_indicator10e\final_indicator10f
matrix list final_indicator10 

* Group 11: Variables that are reported as both as average and also as total at the country level

*variables that need to be disaggregated by farm size
global final_indicator11 "w_value_crop_production_1ppp w_value_crop_production_2ppp w_value_crop_production_loc"
foreach v in $topcropname_area {
	foreach x in 1ppp 2ppp loc {
		global final_indicator11 $final_indicator11 w_value_harv_`v'_`x'
	}
}
*adding in value of crop sales
global final_indicator11 $final_indicator11 w_value_crop_sales_1ppp w_value_crop_sales_2ppp w_value_crop_sales_loc
foreach v in $topcropname_area {
	foreach x in 1ppp 2ppp loc {
		global final_indicator11 $final_indicator11 w_value_sold_`v'_`x'
	}
}
*adding in other non-monetary variables by crop
foreach v in $topcropname_area {
	global final_indicator11 $final_indicator11 w_kgs_harvest_`v' 
}
foreach v in $topcropname_area {
	global final_indicator11 $final_indicator11 w_total_planted_area_`v' 
}
foreach v in $topcropname_area {
	global final_indicator11 $final_indicator11 w_total_harv_area_`v' 
}
global final_indicator11 $final_indicator11 w_all_area_planted w_all_area_harvested
foreach v in $topcropname_area {
	global final_indicator11 $final_indicator11 grew_`v' grew_`v'01Ha grew_`v'12Ha grew_`v'24Ha grew_`v'4Ha	
}

*variables not in Wave 1
gen agactivities_hh = 0
replace w_liters_milk_produced =0

// Adding in the non-crop variables
global final_indicator11 $final_indicator11 /*
*/ agactivities_hh ag_hh crop_hh livestock_hh fishing_hh /*
*/ w_liters_milk_produced w_value_milk_produced_1ppp /*
*/ w_value_milk_produced_2ppp w_value_milk_produced_loc w_eggs_total_year /*
*/ w_value_eggs_produced_1ppp w_value_eggs_produced_2ppp /*
*/ w_value_eggs_produced_loc

recode total_*_area_cassav (.=0)
replace w_total_planted_area_cassav=0 
replace w_total_harv_area_cassav=0
recode total_*_area_banana (.=0)
replace w_total_planted_area_banana=0 
replace w_total_harv_area_banana=0

* first report summary statistitc
matrix final_indicator11=(.,.,.,.,.,.,.,.,.)
global final_indicator11bis ""
foreach v of global final_indicator11 {
	local l`v' : var lab `v' 
	gen `v'_fhh=`v' if fhh==1	
	lab var `v'_fhh "`l`v'' - FHH- using individual weight"
	gen `v'_mhh=`v' if fhh==0	
	lab var `v'_mhh "`l`v'' - MHH- using individual weight"
	global final_indicator11bis $final_indicator11bis `v'  `v'_fhh `v'_mhh
}
foreach v of global final_indicator11bis {
	tabstat `v' [aw=weight] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp11=r(StatTotal)'
	qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered) // get standard errors of the mean	
	qui svy, subpop(if rural==1): mean  `v'
	matrix final_indicator11=final_indicator11\(temp11,el(r(table),2,1))	
}	
matrix final_indicator11 =final_indicator11[2..rowsof(final_indicator11), .]
matrix list final_indicator11 

*Group 12
*Now get rural total at the country level 
*since these are total, we are just keeping the estimated total and its standard errors
*there are no other meanigful statisitics
matrix final_indicator12a=J(1,9,.)
global total_vars ""
qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered) // get standard errors of the mean
foreach v of global final_indicator11 {
    gen rur_`v'=`v'			
	recode rur_`v' (.=0)		
	local l`v' : var lab `v' 
	lab var rur_`v' " Total : `l`v''"		
	svy, subpop(if rural==1): total  rur_`v'		
	matrix b=e(b)
	matrix V=e(V)
	matrix N=e(N)
	matrix final_indicator12a=final_indicator12a\(el(b,1,1),. ,. ,. ,. ,. ,. ,el(N,1,1),sqrt(el(V,1,1)))
	global total_vars $total_vars "rur_`v'"		
}

matrix final_indicator12a=final_indicator12a[2..rowsof(final_indicator12a),.]		
matrix rownames final_indicator12a =$total_vars
matrix colnames final_indicator12a =total semean c3 c4 c5 c6 c7 c8 c9
matrix list final_indicator12a 


*ERE adding - getting the total at the country level including rural and urban
matrix final_indicator12b=J(1,9,.)
global total_vars ""
qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered) // get standard errors of the mean
foreach v of global final_indicator11 {
    gen tot_`v'=`v'
	recode tot_`v' (.=0)		
	local l`v' : var lab `v' 
	lab var tot_`v' " Total : `l`v''"
	svy : total  tot_`v'		
	matrix b=e(b)
	matrix V=e(V)
	matrix N=e(N)
	matrix final_indicator12b=final_indicator12b\(el(b,1,1),. ,. ,. ,. ,. ,. ,el(N,1,1),sqrt(el(V,1,1)))
	global total_vars $total_vars "tot_`v'"
}

matrix final_indicator12b=final_indicator12b[2..rowsof(final_indicator12b),.]
matrix rownames final_indicator12b =$total_vars
matrix colnames final_indicator12b =total semean c3 c4 c5 c6 c7 c8 c9
matrix list final_indicator12b

matrix final_indicator12 =final_indicator12a\final_indicator12b
matrix list final_indicator12

 
*Group 13 :  plot level indicators : labor productivity, plot productivity, gender-base productivity gap
use  "$final_data_plot",  clear
foreach i in 1ppp 2ppp loc{
	gen w_plot_productivity_all_`i'=w_plot_productivity_`i'
	gen w_plot_productivity_female_`i'=w_plot_productivity_`i' if dm_gender==2
	gen w_plot_productivity_male_`i'=w_plot_productivity_`i' if dm_gender==1
	gen w_plot_productivity_mixed_`i'=w_plot_productivity_`i' if dm_gender==3
}

foreach i in 1ppp 2ppp loc{
	qui svyset clusterid [pweight=plot_weight], strata(strataid) singleunit(centered) // get standard errors of the mean
	tabstat w_plot_productivity_`i'  [aw=plot_weight]  if rural==1 & dm_gender!=.    , stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp_all=r(StatTotal)'
	qui svy, subpop(if rural==1 & dm_gender!=. ): mean w_plot_productivity_`i'
	matrix w_plot_productivity_all_`i'=temp_all,el(r(table),2,1)
	 
	tabstat w_plot_productivity_female_`i'  [aw=plot_weight]   if rural==1 & dm_gender==2 , stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp_female=r(StatTotal)'
	qui svy, subpop(if rural==1 & dm_gender==2): mean w_plot_productivity_female_`i'
	matrix w_plot_productivity_female_`i'=temp_female,el(r(table),2,1)
	 
	tabstat w_plot_productivity_male_`i'  [aw=plot_weight]   if rural==1 & dm_gender==1 , stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp_male=r(StatTotal)'
	qui svy, subpop(if rural==1 & dm_gender==1): mean w_plot_productivity_male_`i'
	matrix w_plot_productivity_male_`i'=temp_male,el(r(table),2,1)
	 
	tabstat w_plot_productivity_mixed_`i'  [aw=plot_weight]   if rural==1 & dm_gender==3 , stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp_mixed=r(StatTotal)'
	qui svy, subpop(if rural==1 & dm_gender==3): mean w_plot_productivity_mixed_`i'
	matrix w_plot_productivity_mixed_`i'=temp_mixed,el(r(table),2,1)
 }
 
matrix final_indicator13=(w_plot_productivity_all_1ppp\w_plot_productivity_female_1ppp\w_plot_productivity_male_1ppp\w_plot_productivity_mixed_1ppp\ /*
*/w_plot_productivity_all_2ppp\w_plot_productivity_female_2ppp\w_plot_productivity_male_2ppp\w_plot_productivity_mixed_2ppp\ /*
*/w_plot_productivity_all_loc\w_plot_productivity_female_loc\w_plot_productivity_male_loc\w_plot_productivity_mixed_loc)


gen plot_labor_weight= w_labor_total*weight
foreach i in 1ppp 2ppp loc{
	gen w_plot_labor_prod_all_`i'=w_plot_labor_prod_`i'
	gen w_plot_labor_prod_female_`i'=w_plot_labor_prod_`i' if dm_gender==2
	gen w_plot_labor_prod_male_`i'=w_plot_labor_prod_`i' if dm_gender==1
	gen w_plot_labor_prod_mixed_`i'=w_plot_labor_prod_`i' if dm_gender==3
}

foreach i in 1ppp 2ppp loc{
	qui svyset clusterid [pweight=plot_labor_weight], strata(strataid) singleunit(centered) // get standard errors of the mean
	tabstat w_plot_labor_prod_all_`i'  [aw=plot_labor_weight]   if rural==1  & dm_gender!=. , stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp_all=r(StatTotal)'
	qui svy, subpop(if rural==1): mean w_plot_labor_prod_all_`i'
	matrix w_plot_labor_prod_all_`i'=temp_all,el(r(table),2,1)
	 
	tabstat w_plot_labor_prod_male_`i'  [aw=plot_labor_weight]   if rural==1  & dm_gender==1  , stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp_male=r(StatTotal)'
	qui svy, subpop(if rural==1 & dm_gender==1): mean w_plot_labor_prod_male_`i'
	matrix w_plot_labor_prod_male_`i'=temp_male,el(r(table),2,1)

	tabstat w_plot_labor_prod_female_`i'  [aw=plot_labor_weight]   if rural==1 & dm_gender==2   , stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp_female=r(StatTotal)'
	qui svy, subpop(if rural==1 & dm_gender==2): mean w_plot_labor_prod_female_`i'
	matrix w_plot_labor_prod_female_`i'=temp_female,el(r(table),2,1)

	tabstat w_plot_labor_prod_mixed_`i'  [aw=plot_labor_weight]   if rural==1 & dm_gender==3   , stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix temp_mixed=r(StatTotal)'
	qui svy, subpop(if rural==1 & dm_gender==3): mean w_plot_labor_prod_mixed_`i'
	matrix w_plot_labor_prod_mixed_`i'=temp_mixed,el(r(table),2,1)
}

matrix final_indicator13=final_indicator13\(w_plot_labor_prod_all_1ppp\w_plot_labor_prod_female_1ppp\w_plot_labor_prod_male_1ppp\w_plot_labor_prod_mixed_1ppp\ /*
*/ w_plot_labor_prod_all_2ppp\w_plot_labor_prod_female_2ppp\w_plot_labor_prod_male_2ppp\w_plot_labor_prod_mixed_2ppp\ /*
*/w_plot_labor_prod_all_loc\w_plot_labor_prod_female_loc\w_plot_labor_prod_male_loc\w_plot_labor_prod_mixed_loc)


** gender_prod_gap
tabstat gender_prod_gap1a gender_prod_gap1b, save
matrix temp13= r(StatTotal)', J(2,7,.)
tabstat segender_prod_gap1a segender_prod_gap1b, save
matrix final_indicator13=final_indicator13\(temp13, r(StatTotal)')
matrix list final_indicator13 


*Group 14 : individual level variables - women controle over income, asset, and participation in ag
* Keep only adult women
use "$final_data_individual", clear
keep if female==1
keep if age>=18
*count the number of female adult per household to be used in the weight
bysort hhid : egen number_female_hhmember =count (female==1 & age>=18)
gen control_all_income = 0
global household_indicators14 control_all_income make_decision_ag own_asset formal_land_rights_f 
global final_indicator14 ""
foreach v of global household_indicators14 {
	gen `v'_female_hh=`v' if  fhh==1
	gen `v'_male_hh=`v' if fhh==0
	global final_indicator14 $final_indicator14 `v'  `v'_female_hh  `v'_male_hh 
}
tabstat ${final_indicator14} [aw=weight] if rural==1 , stat(mean sd  p25 p50 p75  min max N) col(stat) save
matrix final_indicator14=r(StatTotal)'
qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered) // get standard errors of the mean
matrix semean14=(.)
matrix colnames semean14=semean_wei
foreach v of global final_indicator14 {
	svy, subpop(if rural==1): mean `v'
	matrix semean14=semean14\(el(r(table),2,1))
}
matrix final_indicator14=final_indicator14,semean14[2..rowsof(semean14),.]
matrix list final_indicator14 

*Group 15 : individual level variables - women diet
* only women in reproductive age
use "$final_data_individual", clear
keep if female==1
drop if age>49
drop if age<15
* NA in TZA NPS_LSMS-ISA
gen women_diet=0
gen number_foodgroup=0
*Also general femal_weigh
*count the number of female adult per household to be used in the weight
bysort hhid : egen number_female_hhmember =count (female==1 & age<15 & age>49)

global household_indicators15  number_foodgroup women_diet
global final_indicator15""
foreach v of global household_indicators15 {
	gen `v'_female_hh=`v' if  fhh==1
	gen `v'_male_hh=`v' if fhh==0
	global final_indicator15 $final_indicator15 `v'  `v'_female_hh  `v'_male_hh 
}
tabstat ${final_indicator15} [aw=weight], stat(mean sd min p25 p50 p75 max N) col(stat) save
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

** Group 16 - Use of fertilizer, imporved seeds, and vaccing by individual farmers (plot managers or livestock keepers)
use "$final_data_individual", clear


// Set improved seed adoption to missing if household is not growing crop
// And disaggregate by gender
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


global household_indicators16 all_use_inorg_fert female_use_inorg_fert male_use_inorg_fert all_imprv_seed_use female_imprv_seed_use male_imprv_seed_use
// Add improved seed and hybrid seed indicators for all top crops 
foreach v in $topcropname_area {
	global household_indicators16 $household_indicators16 all_imprv_seed_`v' female_imprv_seed_`v' male_imprv_seed_`v' all_hybrid_seed_`v' female_hybrid_seed_`v' male_hybrid_seed_`v'
}
global household_indicators16 $household_indicators16 all_vac_animal female_vac_animal male_vac_animal


tabstat ${household_indicators16} [aw=weight] if rural==1 , stat(mean sd  p25 p50 p75  min max N) col(stat) save		
matrix final_indicator16=r(StatTotal)'
qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered) // get standard errors of the mean
matrix semean16=(.)
matrix colnames semean16=semean_wei
foreach v of global household_indicators16 {
	qui svy, subpop(if rural==1): mean `v'
	matrix semean16=semean16\(el(r(table),2,1))
}
matrix final_indicator16=final_indicator16,semean16[2..rowsof(semean16),.]
matrix list final_indicator16 

* All together
matrix final_indicator_all =(.,.,.,.,.,.,.,.,.)
forvalue i=1/16 {
	matrix final_indicator_all=final_indicator_all\final_indicator`i'
}
matrix final_indicator_all =final_indicator_all[2..rowsof(final_indicator_all), .] 
matrix list final_indicator_all 
matrix colname final_indicator_all =  mean sd p25 p50 p75 min max N semean_strata
*reordering columns to put semean first
matrix final_indicator_exported=final_indicator_all[.,1..1],final_indicator_all[.,9..9],final_indicator_all[.,2..8]
* Export to Excel
putexcel set "$final_outputfile", replace
putexcel A1=matrix(final_indicator_exported)  , names
