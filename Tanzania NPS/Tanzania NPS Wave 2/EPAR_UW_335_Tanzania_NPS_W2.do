
/*-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of a set of agricultural development indicators 
				  using the Tanzania National Panel Survey (TNPS) LSMS-ISA Wave 2 (2010-11)
*Author(s)	: Didier Alia, Andrew Tomes, and C. Leigh Anderson 

*Acknowledgments: We acknowledge the helpful contributions of Pierre Biscaye, David Coomes, Jack Knauer, Josh Merfeld,  
				  Isabella Sun, Chelsea Sweeney, Usha Gollapudi, Emma Weaver, Ayala Wineman, Travis Reynolds, members of the World Bank's LSMS-ISA team, the FAO's RuLIS team, IFPRI, IRRI, 
				  and the Bill & Melinda Gates Foundation Agricultural Development Data and Policy team in discussing indicator construction decisions. 
				  All coding errors remain ours alone.
*Date			: This  Version - 18th July 2024
*Dataset Version	: TZA_2010_NPS-R2_v02_M_STATA8
----------------------------------------------------------------------------------------------------------------------------------------------------*/


*Data source
*-----------
*The Tanzania National Panel Survey was collected by the Tanzania National Bureau of Statistics (NBS) 
*and the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture(LSMS - ISA)
*The data were collected over the period October 2010 - September 2011.
*All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
*http://microdata.worldbank.org/index.php/catalog/1050

*Throughout the do-file, we sometimes use the shorthand LSMS to refer to the Tanzania National Panel Survey.


*Summary of Executing the Master do.file
*-----------
*This Master do.file constructs selected indicators using the Tanzania NPS data set.
*Using data files from the "Raw DTA files" folder from within the "Tanzania NPS Wave 2" folder, 
*the do.file first constructs common and intermediate variables, saving dta files when appropriate 
*in the folder "created_data" within the "Final DTA files" folder.
*These variables are then brought together at the household, plot, or individual level, saving dta files at each level when available 
*in the "Final DTA files" folder.

*The processed files include all households, individuals, and plots in the sample.
*Toward the end of the do.file, a block of code estimates summary statistics (mean, standard error of the mean, minimum, first quartile, median, third quartile, maximum) 
*of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager.
*The results are outputted in the excel file "Tanzania_NPS_W2_summary_stats.xlsx" in the "Final DTA files" folder.
*It is possible to modify the condition  "if rural==1" in the portion of code following the heading "SUMMARY STATISTICS" to generate all summary statistics for a different sub_population.

*The following refer to running this Master do.file with EPAR's cleaned data files. Information on EPAR's cleaning and construction decisions is available in the documents
*"EPAR_UW_335_Indicator Construction Summary Tables" and "EPAR_UW_335_General Considerations and Principles for Indicator Construction.docx" within the folder "Supporting documents".

 
/*OUTLINE OF THE DO.FILE
Below are the list of the main files created by running this Master do.file+
 					
*MAIN INTERMEDIATE FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD IDS						Tanzania_NPS_W2_hhids.dta
*INDIVIDUAL IDS						Tanzania_NPS_W2_person_ids.dta
*HOUSEHOLD SIZE						Tanzania_NPS_W2_hhsize.dta
*PLOT AREAS							Tanzania_NPS_W2_plot_areas.dta
*PLOT-CROP DECISION MAKERS			Tanzania_NPS_W2_plot_decision_makers.dta

*MONOCROPPED PLOTS					Tanzania_NPS_W2_[CROP]_monocrop_hh_area.dta

*TLU (Tropical Livestock Units)		Tanzania_NPS_W2_TLU_Coefficients.dta

*GROSS CROP REVENUE					Tanzania_NPS_W2_tempcrop_harvest.dta
									Tanzania_NPS_W2_tempcrop_sales.dta
									Tanzania_NPS_W2_permcrop_harvest.dta
									Tanzania_NPS_W2_permcrop_sales.dta
									Tanzania_NPS_W2_hh_crop_production.dta
									Tanzania_NPS_W2_plot_cropvalue.dta
									Tanzania_NPS_W2_crop_residues.dta
									Tanzania_NPS_W2_hh_crop_prices.dta
									Tanzania_NPS_W2_crop_losses.dta

									
*CROP EXPENSES						Tanzania_NPS_W2_wages_mainseason.dta
									Tanzania_NPS_W2_wages_shortseason.dta
									Tanzania_NPS_W2_fertilizer_costs.dta
									Tanzania_NPS_W2_seed_costs.dta
									Tanzania_NPS_W2_land_rental_costs.dta
									Tanzania_NPS_W2_asset_rental_costs.dta
									Tanzania_NPS_W2_transportation_cropsales.dta
									
*CROP INCOME						Tanzania_NPS_W2_crop_income.dta
									
*LIVESTOCK INCOME					Tanzania_NPS_W2_livestock_expenses.dta
									Tanzania_NPS_W2_livestock_products.dta
									Tanzania_NPS_W2_hh_livestock_products.dta
									Tanzania_NPS_W2_dung.dta
									Tanzania_NPS_W2_livestock_sales.dta
									Tanzania_NPS_W2_TLU.dta
									Tanzania_NPS_W2_livestock_income.dta

*FISH INCOME						Tanzania_NPS_W2_fishing_expenses_1.dta
									Tanzania_NPS_W2_fishing_expenses_2.dta
									Tanzania_NPS_W2_fish_income.dta
																	
*SELF-EMPLOYMENT INCOME				Tanzania_NPS_W2_self_employment_income.dta
									Tanzania_NPS_W2_agproducts_profits.dta
									Tanzania_NPS_W2_fish_trading_revenue.dta
									Tanzania_NPS_W2_fish_trading_other_costs.dta
									Tanzania_NPS_W2_fish_trading_income.dta
									
*WAGE INCOME						Tanzania_NPS_W2_wage_income.dta
									Tanzania_NPS_W2_agwage_income.dta
									
*OTHER INCOME						Tanzania_NPS_W2_other_income.dta
									Tanzania_NPS_W2_land_rental_income.dta
									
*OFF-FARM HOURS						Tanzania_NPS_W2_off_farm_hours.dta

*FARM SIZE / LAND SIZE				Tanzania_NPS_W2_land_size.dta
									Tanzania_NPS_W2_farmsize_all_agland.dta
									Tanzania_NPS_W2_land_size_all.dta
									Tanzania_NPS_W2_land_size_total.dta
									
*FARM LABOR							Tanzania_NPS_W2_farmlabor_mainseason.dta
									Tanzania_NPS_W2_farmlabor_shortseason.dta
									Tanzania_NPS_W2_family_hired_labor.dta
									
*VACCINE USAGE						Tanzania_NPS_W2_vaccine.dta
									Tanzania_NPS_W2_farmer_vaccine.dta
									
*ANIMAL HEALTH						Tanzania_NPS_W2_livestock_diseases.dta
									
*USE OF INORGANIC FERTILIZER		Tanzania_NPS_W2_fert_use.dta
									Tanzania_NPS_W2_farmer_fert_use.dta
									
*USE OF IMPROVED SEED				Tanzania_NPS_W2_improvedseed_use.dta
									Tanzania_NPS_W2_farmer_improvedseed_use.dta

*REACHED BY AG EXTENSION			Tanzania_NPS_W2_any_ext.dta
*USE OF FORMAL FINANACIAL SERVICES	Tanzania_NPS_W2_fin_serv.dta

*MILK PRODUCTIVITY					Tanzania_NPS_W2_milk_animals.dta
*EGG PRODUCTIVITY					Tanzania_NPS_W2_eggs_animals.dta

*CROP PRODUCTION COSTS PER HECTARE	Tanzania_NPS_W2_hh_cost_land.dta
									Tanzania_NPS_W2_hh_cost_inputs_lrs.dta
									Tanzania_NPS_W2_hh_cost_inputs_srs.dta
									Tanzania_NPS_W2_hh_cost_seed_lrs.dta
									Tanzania_NPS_W2_hh_cost_seed_srs.dta		
									Tanzania_NPS_W2_cropcosts_total.dta
									
*AGRICULTURAL WAGES					Tanzania_NPS_W2_ag_wage.dta

*RATE OF FERTILIZER APPLICATION		Tanzania_NPS_W2_fertilizer_application.dta
*HOUSEHOLD'S DIET DIVERSITY SCORE	Tanzania_NPS_W2_household_diet.dta

*WOMEN'S CONTROL OVER INCOME		Tanzania_NPS_W2_control_income.dta
*WOMEN'S AG DECISION-MAKING			Tanzania_NPS_W2_make_ag_decision.dta
*WOMEN'S ASSET OWNERSHIP			Tanzania_NPS_W2_ownasset.dta

*CROP YIELDS						Tanzania_NPS_W2_yield_hh_crop_level.dta
*SHANNON DIVERSITY INDEX			Tanzania_NPS_W2_shannon_diversity_index.dta
*CONSUMPTION						Tanzania_NPS_W2_consumption.dta
*HOUSEHOLD FOOD PROVISION			Tanzania_NPS_W2_food_insecurity.dta


*FINAL FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD VARIABLES				Tanzania_NPS_W2_household_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			Tanzania_NPS_W2_individual_variables.dta	
*PLOT-LEVEL VARIABLES				Tanzania_NPS_W2_field_plot_variables.dta
*SUMMARY STATISTICS					Tanzania_NPS_W2_summary_stats.xlsx
*/


clear
clear matrix	
clear mata			
set more off
set maxvar 8000	

*Set location of raw data and output
global directory	"335_Agricultural-Indicator-Data-Curation" //Update this to match your local folder

//set directories
*These paths correspond to the folders where the raw data files are located and where the created data and final data will be stored.
global Tanzania_NPS_W2_raw_data 	    	"$directory/Tanzania NPS/Tanzania NPS Wave 2/Raw DTA Files"
global Tanzania_NPS_W2_created_data  		"$directory/Tanzania NPS/Tanzania NPS Wave 2/Final DTA Files/created_data"
global Tanzania_NPS_W2_final_data  		"$directory/Tanzania NPS/Tanzania NPS Wave 2/Final DTA Files/final_data"
    

********************************************************************************
*EXCHANGE RATE AND INFLATION FOR CONVERSION IN SUD IDS
********************************************************************************
global Tanzania_NPS_W2_exchange_rate 2158		  // https://www.bloomberg.com/quote/USDETB:CUR
global Tanzania_NPS_W2_gdp_ppp_dollar 719.02      // https://data.worldbank.org/indicator/PA.NUS.PPP
global Tanzania_NPS_W2_cons_ppp_dollar 809.32	  // https://data.worldbank.org/indicator/PA.NUS.PRVT.PP
global Tanzania_NPS_W2_inflation 0.474749536      // inflation rate 2011-2016. Data was collected during October 2010-2011. We have adjusted values to 2016. https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=TZ


********************************************************************************
*THRESHOLDS FOR WINSORIZATION
********************************************************************************
global wins_lower_thres 1    						//  Threshold for winzorization at the bottom of the distribution of continous variables
global wins_upper_thres 99							//  Threshold for winzorization at the top of the distribution of continous variables


********************************************************************************
*GLOBALS OF PRIORITY CROPS //change these globals if you are interested in different crops
********************************************************************************
////Limit crop names in variables to 6 characters or the variable names will be too long! 
global topcropname_area "maize rice wheat sorgum pmill cowpea grdnt beans yam swtptt cassav banana cotton sunflr pigpea"
global topcrop_area "11 12 16 13 14 32 43 31 24 22 21 71 50 41 34"
global comma_topcrop_area "11, 12, 16, 13, 14, 32, 43, 31, 24, 22, 21, 71, 50, 41, 34"
global nb_topcrops : list sizeof global(topcropname_area) // Gets the current length of the global macro list "topcropname_area" 
display "$nb_topcrops"

********************************************************************************
*HOUSEHOLD IDS
********************************************************************************
use "${Tanzania_NPS_W2_raw_data}/HH_SEC_A.dta", clear
gen region_name=region
label define region_name  1 "Dodoma" 2 "Arusha" 3 "Kilimanjaro" 4 "Tanga" 5 "Morogoro" 6 "Pwani" 7 "Dar es Salaam" 8 "Lindi" 9 "Mtwara" 10 "Ruvuma" 11 "Iringa" 12 "Mbeya" 13 "Singida" 14 "Tabora" 15 "Rukwa" 16 "Kigoma" 17 "Shinyanga" 18 "Kagera" 19 "Mwanza" 20 "Mara" 21 "Manyara" 22 "Njombe" 23 "Katavi" 24 "Simiyu" 25 "Geita" 51 "Kaskazini Unguja" 52 "Kusini Unguja" 53 "Minji/Magharibi Unguja" 54 "Kaskazini Pemba" 55 "Kusini Pemba"
label values region_name region_name
gen district_name=.
tostring district_name, replace
ren y2_weight weight
gen hh_split=2 if hh_a11==3 //split-off household
label define hh_split 1 "ORIGINAL HOUSEHOLD" 2 "SPLIT-OFF HOUSEHOLD"
label values hh_split hh_split
lab var hh_split "2=Split-off household" 
gen rural = (y2_rural==1)
keep y2_hhid region district ward region_name district_name ea rural weight strataid clusterid hh_split
lab var rural "1=Household lives in a rural area"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhids.dta", replace 


********************************************************************************
*INDIVIDUAL IDS
********************************************************************************
use "${Tanzania_NPS_W2_raw_data}/HH_SEC_B.dta", clear
keep y2_hhid indidy2 hh_b02 hh_b04 hh_b05
gen female=hh_b02==2 
lab var female "1= indivdual is female"
gen age=hh_b04
lab var age "Indivdual age"
gen hh_head=hh_b05==1 
lab var hh_head "1= individual is household head"
drop hh_b02 hh_b04 hh_b05
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_person_ids.dta", replace
 
 
********************************************************************************
*HOUSEHOLD SIZE
********************************************************************************
use "${Tanzania_NPS_W2_raw_data}/HH_SEC_B.dta", clear
gen hh_members = 1
ren hh_b05 relhead 
ren hh_b02 gender
gen fhh = (relhead==1 & gender==2)
collapse (sum) hh_members (max) fhh, by (y2_hhid)
lab var hh_members "Number of household members"
lab var fhh "1= Female-headed household"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhsize.dta", replace



********************************************************************************
*PLOT AREAS
********************************************************************************
use "${Tanzania_NPS_W2_raw_data}/AG_SEC2A.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC2B.dta", gen(short)
ren plotnum plot_id
gen area_acres_est = ag2a_04
replace area_acres_est = ag2b_15 if area_acres_est==.
gen area_acres_meas = ag2a_09
replace area_acres_meas = ag2b_20 if area_acres_meas==.
keep if area_acres_est !=.
keep y2_hhid plot_id area_acres_est area_acres_meas
lab var area_acres_meas "Plot are in acres (GPSd)"
lab var area_acres_est "Plot area in acres (estimated)"
gen area_est_hectares=area_acres_est* (1/2.47105)  
gen area_meas_hectares= area_acres_meas* (1/2.47105)
lab var area_meas_hectares "Plot are in hectares (GPSd)"
lab var area_est_hectares "Plot area in hectares (estimated)"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_areas.dta", replace

********************************************************************************
*PLOT DECISION MAKERS
********************************************************************************
use "${Tanzania_NPS_W2_raw_data}/HH_SEC_B.dta", clear
ren indidy2 personid
gen female =hh_b02==2
gen age = hh_b04
gen head = hh_b05==1 if hh_b05!=.
lab var female "1=Individual is a female"
lab var age "Individual age"
lab var head "1=Individual is the head of household"
keep personid female age y2_hhid head
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_gender_merge.dta", replace

use "${Tanzania_NPS_W2_raw_data}/AG_SEC3A.dta", clear
drop if plotnum==""
gen cultivated = ag3a_03==1
gen season=1
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC3B.dta"
replace season=2 if season==.
drop if plotnum==""
drop if ag3b_03==. & ag3a_03==.
replace cultivated = 1 if  ag3b_03==1 
*Gender/age variables
gen personid = ag3a_08_1
replace personid =ag3b_08_1 if personid==. &  ag3b_08_1!=.
merge m:1 y2_hhid personid using  "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_gender_merge.dta", gen(dm1_merge) keep(1 3)		// Dropping unmatched from using
*First decision-maker variables
gen dm1_female = female
drop female personid
*Second owner
gen personid = ag3a_08_2
replace personid =ag3b_08_2 if personid==. &  ag3b_08_2!=.
merge m:1 y2_hhid personid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_gender_merge.dta", gen(dm2_merge) keep(1 3)		// Dropping unmatched from using
gen dm2_female = female
drop female personid
*Third
gen personid = ag3a_08_3
replace personid =ag3b_08_3 if personid==. &  ag3b_08_3!=.
merge m:1 y2_hhid personid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_gender_merge.dta", gen(dm3_merge) keep(1 3)		// Dropping unmatched from using
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
merge m:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhsize.dta", nogen 							
replace dm_gender = 1 if fhh==0 & dm_gender==.
replace dm_gender = 2 if fhh==1 & dm_gender==.
ren plotnum plot_id 
drop if  plot_id==""
drop if y2_hhid=="1902025003005901" & season==2
drop if y2_hhid=="1903007058008017" & season==2
drop if y2_hhid=="5301008072017501" & season==2 
keep y2_hhid plot_id plot_id dm_gender  cultivated  
lab var cultivated "1=Plot has been cultivated"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_decision_makers.dta", replace

********************************************************************************
*MONOCROPPED PLOTS
********************************************************************************

forvalues k=1(1)$nb_topcrops  {			
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	use "${Tanzania_NPS_W2_raw_data}/AG_SEC4A.dta", clear
	append using "${Tanzania_NPS_W2_raw_data}/AG_SEC6A.dta"
	append using "${Tanzania_NPS_W2_raw_data}/AG_SEC4B.dta", gen(short)
	append using "${Tanzania_NPS_W2_raw_data}/AG_SEC6B.dta"
	recode short (.=1)		
	drop if plotnum==""
	ren plotnum plot_id
	gen kgs_harv_mono_`cn' = ag4a_15 if zaocode==`c' 
	replace kgs_harv_mono_`cn' = ag4b_15 if zaocode==`c' & short==1
	replace kgs_harv_mono_`cn' = ag6a_08 if zaocode==`c' & kgs_harv_mono==.		
	replace kgs_harv_mono_`cn' = ag6b_08 if zaocode==`c' & kgs_harv_mono==. 	
	*First, get percent of plot planted with crop
	replace ag4a_01 = ag4b_01 if ag4a_01==.
	replace ag4a_02 = ag4b_02 if ag4a_02==.
	replace ag6a_05 = ag6b_05 if ag6a_05==.		
	gen percent_`cn' = 1 if ag4a_01==1 & zaocode==`c'
	replace percent_`cn' = 1 if ag6a_05==1 & zaocode==21 | zaocode==71		//include permanent crop zaocodes that we're interested in here (cassava=21 and banana=71)		
	replace percent_`cn' = 0.25*(ag4a_02==1) + 0.5*(ag4a_02==2) + 0.75*(ag4a_02==3) if percent_`cn'==. & zaocode==`c'
	*qui tab zaocode, gen(crops_dummy)
	xi i.zaocode, noomit
	collapse (sum) kgs_harv_mono_`cn' (max) _Izaocode_* percent_`cn', by(y2_hhid plot_id short)	
	egen crop_count = rowtotal(_Izaocode_*)	
	keep if crop_count==1 & _Izaocode_`c'==1 	
	merge m:1 y2_hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_areas.dta", nogen assert(2 3) keep(3)
	replace area_meas_hectares=. if area_meas_hectares==0 					
	replace area_meas_hectares = area_est_hectares if area_meas_hectares==. 	// Replacing missing with estimated
	gen `cn'_monocrop_ha = area_meas_hectares*percent_`cn'			
	drop if `cn'_monocrop_ha==0 
	save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_`cn'_monocrop.dta", replace
}
forvalues k=1(1)$nb_topcrops  {		
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_`cn'_monocrop.dta", clear
	merge m:1 y2_hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_decision_makers.dta", keep (3) nogen
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

	*And now this code will indicate whether the HOUSEHOLD has at least one of these plots and the total area of monocropped maize plots
	collapse (sum) `cn'_monocrop_ha* kgs_harv_mono_`cn'* (max) `cn'_monocrop_male `cn'_monocrop_female `cn'_monocrop_mixed `cn'_monocrop = _Izaocode_`c', by(y2_hhid) 

	foreach i in male female mixed {
		replace `cn'_monocrop_ha = . if `cn'_monocrop!=1
		replace `cn'_monocrop_ha_`i' =. if  `cn'_monocrop!=1
		replace `cn'_monocrop_ha_`i' =. if `cn'_monocrop_`i'==0
		replace `cn'_monocrop_ha_`i' =. if `cn'_monocrop_ha_`i'==0
		replace kgs_harv_mono_`cn' = . if `cn'_monocrop!=1 
		replace kgs_harv_mono_`cn'_`i' =. if  `cn'_monocrop!=1 
		replace kgs_harv_mono_`cn'_`i' =. if `cn'_monocrop_`i'==0 
		replace kgs_harv_mono_`cn'_`i' =. if `cn'_monocrop_ha_`i'==0 
	}
	save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_`cn'_monocrop_hh_area.dta", replace
}


********************************************************************************
*TLU (Tropical Livestock Units)
********************************************************************************
use "${Tanzania_NPS_W2_raw_data}/AG_SEC10A.dta", clear
ren lvstkcode lvstckid
gen tlu_coefficient=0.5 if (lvstckid==1|lvstckid==2|lvstckid==3|lvstckid==4|lvstckid==5|lvstckid==6)
replace tlu_coefficient=0.1 if (lvstckid==7|lvstckid==8)
replace tlu_coefficient=0.2 if (lvstckid==9)
replace tlu_coefficient=0.01 if (lvstckid==10|lvstckid==11|lvstckid==12|lvstckid==13)
replace tlu_coefficient=0.3 if (lvstckid==14)
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
*Owned
drop if lvstckid==15
gen cattle=inrange(lvstckid,1,6)
gen smallrum=inlist(lvstckid,7,8,9)
gen poultry=inlist(lvstckid,10,11,12,13)
gen other_ls=inlist(lvstckid,14,15,16)
gen cows=inrange(lvstckid,2,2)
gen chickens=inrange(lvstckid,10,10)
ren lvstckid livestock_code
ren ag10a_04 nb_ls_1yearago
gen nb_cattle_1yearago=nb_ls_1yearago if cattle==1 
gen nb_smallrum_1yearago=nb_ls_1yearago if smallrum==1 
gen nb_poultry_1yearago=nb_ls_1yearago if poultry==1 
gen nb_other_ls_1yearago=nb_ls_1yearago if other_ls==1 
gen nb_cows_1yearago=nb_ls_1yearago if cows==1 
gen nb_chickens_1yearago=nb_ls_1yearago if chickens==1 
egen nb_ls_today= rowtotal(ag10a_05_2  ag10a_05_3)
gen nb_cattle_today=nb_ls_today if cattle==1 
gen nb_smallrum_today=nb_ls_today if smallrum==1 
gen nb_poultry_today=nb_ls_today if poultry==1 
gen nb_other_ls_today=nb_ls_today if other_ls==1 
gen nb_cows_today=nb_ls_today if cows==1 
gen nb_chickens_today=nb_ls_today if chickens==1  
gen tlu_1yearago = nb_ls_1yearago * tlu_coefficient
gen tlu_today = nb_ls_today * tlu_coefficient
ren ag10a_21 income_live_sales 
ren ag10a_20 number_sold 
recode tlu_* nb_* (.=0)
collapse (sum) tlu_* nb_*  , by (y2_hhid)
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
drop if y2_hhid==""
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_TLU_Coefficients.dta", replace


********************************************************************************
*GROSS CROP REVENUE
********************************************************************************
*Temporary crops (both seasons)
use "${Tanzania_NPS_W2_raw_data}/AG_SEC4A.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC4B.dta"
drop if plotnum==""
ren zaocode crop_code
ren plotnum plot_id
ren ag4a_06 harvest_yesno
replace harvest_yesno = ag4b_06 if harvest_yesno==.
ren ag4a_15 kgs_harvest
replace kgs_harvest = ag4b_15 if kgs_harvest==.
ren ag4a_16 value_harvest
replace value_harvest = ag4b_16 if value_harvest==.
replace kgs_harvest = 0 if harvest_yesno==2
replace value_harvest = 0 if harvest_yesno==2
collapse (sum) kgs_harvest value_harvest, by (y2_hhid crop_code plot_id)
lab var kgs_harvest "Kgs harvested of this crop, summed over main and short season"
lab var value_harvest "Value harvested of this crop, summed over main and short season"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_tempcrop_harvest.dta", replace

use "${Tanzania_NPS_W2_raw_data}/AG_SEC5A.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC5B.dta"
drop if zaocode==.
ren zaocode crop_code
ren ag5a_01 sell_yesno
replace sell_yesno = ag5b_01 if sell_yesno==.
ren ag5a_02 quantity_sold
replace quantity_sold = ag5b_02 if quantity_sold==.
ren ag5a_03 value_sold
replace value_sold = ag5b_03 if value_sold==.
keep if sell_yesno==1
collapse (sum) quantity_sold value_sold, by (y2_hhid crop_code)
lab var quantity_sold "Kgs sold of this crop, summed over main and short season"
lab var value_sold "Value sold of this crop, summed over main and short season"
gen price_kg = value_sold / quantity_sold
lab var price_kg "Price per kg sold"
drop if y2_hhid=="0402012002040301" & crop_code==71 // crop repeated in permanent crop for this hh
drop if y2_hhid=="0407011002032403" & crop_code==34 // crop repeated in permanent crop for this hh
drop if y2_hhid=="5102022012005901" & crop_code==71 // crop repeated in permanent crop for this hh
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_tempcrop_sales.dta", replace

*Permanent and tree crops
use "${Tanzania_NPS_W2_raw_data}/AG_SEC6A.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC6B.dta"
drop if plotnum==""
ren zaocode crop_code
ren ag6a_08 kgs_harvest
ren plotnum plot_id
replace kgs_harvest = ag6b_08 if kgs_harvest==.
collapse (sum) kgs_harvest, by (y2_hhid crop_code plot_id)
lab var kgs_harvest "Kgs harvested of this crop, summed over main and short season"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_permcrop_harvest.dta", replace

use "${Tanzania_NPS_W2_raw_data}/AG_SEC7A.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC7B.dta"
drop if zaocode==.
ren zaocode crop_code
ren ag7a_02 sell_yesno
replace sell_yesno = ag7b_02 if sell_yesno==.
ren ag7a_03 quantity_sold
replace quantity_sold = ag7b_03 if quantity_sold==.
ren ag7a_04 value_sold
replace value_sold = ag7b_04 if value_sold==.
keep if sell_yesno==1
recode quantity_sold value_sold (.=0)
collapse (sum) quantity_sold value_sold, by (y2_hhid crop_code)
lab var quantity_sold "Kgs sold of this crop, summed over main and short season"
lab var value_sold "Value sold of this crop, summed over main and short season"
gen price_kg = value_sold / quantity_sold
lab var price_kg "Price per kg sold"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_permcrop_sales.dta", replace

*Prices of permanent and tree crops need to be imputed from sales
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_permcrop_sales.dta", clear
append using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_tempcrop_sales.dta"
recode price_kg (0=.) 
merge m:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhids.dta", nogen keep(1 3)
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_sales.dta", replace

use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_sales.dta", clear
gen observation = 1
bys region district ward ea crop_code: egen obs_ea = count(observation)
collapse (median) price_kg [aw=weight], by (region district ward ea crop_code obs_ea)
ren price_kg price_kg_median_ea
lab var price_kg_median_ea "Median price per kg for this crop in the enumeration area"
lab var obs_ea "Number of sales observations for this crop in the enumeration area"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_prices_ea.dta", replace
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_sales.dta", clear
gen observation = 1
bys region district ward crop_code: egen obs_ward = count(observation)
collapse (median) price_kg [aw=weight], by (region district ward crop_code obs_ward)
ren price_kg price_kg_median_ward
lab var price_kg_median_ward "Median price per kg for this crop in the ward"
lab var obs_ward "Number of sales observations for this crop in the ward"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_prices_ward.dta", replace
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_sales.dta", clear
gen observation = 1
bys region district crop_code: egen obs_district = count(observation) 
collapse (median) price_kg [aw=weight], by (region district crop_code obs_district)
ren price_kg price_kg_median_district
lab var price_kg_median_district "Median price per kg for this crop in the district"
lab var obs_district "Number of sales observations for this crop in the district"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_prices_district.dta", replace
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_sales.dta", clear
gen observation = 1
bys region crop_code: egen obs_region = count(observation)
collapse (median) price_kg [aw=weight], by (region crop_code obs_region)
ren price_kg price_kg_median_region
lab var price_kg_median_region "Median price per kg for this crop in the region"
lab var obs_region "Number of sales observations for this crop in the region"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_prices_region.dta", replace
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_sales.dta", clear
gen observation = 1
bys crop_code: egen obs_country = count(observation)
collapse (median) price_kg [aw=weight], by (crop_code obs_country)
ren price_kg price_kg_median_country
lab var price_kg_median_country "Median price per kg for this crop in the country"
lab var obs_country "Number of sales observations for this crop in the country"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_prices_country.dta", replace

*Pull prices into harvest estimates
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_tempcrop_harvest.dta", clear
append using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_permcrop_harvest.dta"
merge m:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhids.dta", nogen keep(1 3)
merge m:1 y2_hhid crop_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_sales.dta", nogen
merge m:1 region district ward ea crop_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_prices_ea.dta", nogen
merge m:1 region district ward crop_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_prices_ward.dta", nogen
merge m:1 region district crop_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_prices_district.dta", nogen
merge m:1 region crop_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_prices_region.dta", nogen
merge m:1 crop_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_prices_country.dta", nogen
gen price_kg_hh = price_kg
replace price_kg = price_kg_median_ea if price_kg==. & obs_ea >= 10 & crop_code!=998 /* Don't impute prices for "other" crops */
replace price_kg = price_kg_median_ward if price_kg==. & obs_ward >= 10 & crop_code!=998
replace price_kg = price_kg_median_district if price_kg==. & obs_district >= 10 & crop_code!=998
replace price_kg = price_kg_median_region if price_kg==. & obs_region >= 10 & crop_code!=998
replace price_kg = price_kg_median_country if price_kg==. & crop_code!=998 
lab var price_kg "Price per kg, with missing values imputed using local median values"
gen value_harvest_imputed = value_harvest
lab var value_harvest_imputed "Imputed value of crop production"
replace value_harvest_imputed = kgs_harvest * price_kg_hh if price_kg_hh!=. /* Use observed hh price if it exists */
replace value_harvest_imputed = kgs_harvest * price_kg if value_harvest_imputed==.
replace value_harvest_imputed = value_harvest if value_harvest_imputed==. & crop_code==998 /* "Other" */
replace value_harvest_imputed = 0 if value_harvest_imputed==.
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_values_tempfile.dta", replace 

preserve
recode  value_harvest_imputed value_sold kgs_harvest quantity_sold (.=0)
collapse (sum) value_harvest_imputed value_sold kgs_harvest quantity_sold , by (y2_hhid crop_code)
ren value_harvest_imputed value_crop_production
lab var value_crop_production "Gross value of crop production, summed over main and short season"
ren value_sold value_crop_sales
lab var value_crop_sales "Value of crops sold so far, summed over main and short season"
lab var kgs_harvest "Kgs harvested of this crop, summed over main and short season"
ren quantity_sold kgs_sold
lab var kgs_sold "Kgs sold of this crop, summed over main and short season"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_crop_values_production.dta", replace
restore

collapse (sum) value_harvest_imputed value_sold, by (y2_hhid)
replace value_harvest_imputed = value_sold if value_sold>value_harvest_imputed & value_sold!=. & value_harvest_imputed!=. /* In a few cases, the kgs sold exceeds the kgs harvested */
ren value_harvest_imputed value_crop_production
lab var value_crop_production "Gross value of crop production for this household"
ren value_sold value_crop_sales
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_crop_production.dta", replace

*Plot value of crop production
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_values_tempfile.dta", clear
collapse (sum) value_harvest_imputed, by (y2_hhid plot_id)
ren value_harvest_imputed plot_value_harvest
lab var plot_value_harvest "Value of crop harvest on this plot"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_cropvalue.dta", replace

*Crop residues (captured only in Tanzania) 
use "${Tanzania_NPS_W2_raw_data}/AG_SEC5A.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC5B.dta"
gen residue_sold_yesno = (ag5a_24==7) 

ren ag5a_26 value_cropresidue_sales
recode value_cropresidue_sales (.=0)
collapse (sum) value_cropresidue_sales, by (y2_hhid)
lab var value_cropresidue_sales "Value of sales of crop residue (considered an agricultural byproduct)"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_residues.dta", replace

*Crop values for inputs in agricultural product processing (self-employment)
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_tempcrop_harvest.dta", clear
append using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_permcrop_harvest.dta"
merge m:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhids.dta", nogen keep(1 3)
merge m:1 y2_hhid crop_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_sales.dta", nogen
merge m:1 region district ward ea crop_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_prices_ea.dta", nogen
merge m:1 region district ward crop_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_prices_ward.dta", nogen
merge m:1 region district crop_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_prices_district.dta", nogen
merge m:1 region crop_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_prices_region.dta", nogen
merge m:1 crop_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_prices_country.dta", nogen
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
keep y2_hhid crop_code price_kg 
duplicates drop
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_crop_prices.dta", replace

*Crops lost post-harvest
use "${Tanzania_NPS_W2_raw_data}/AG_SEC7A.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC7B.dta"
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC5A.dta"
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC5B.dta" 
drop if zaocode==.
ren zaocode crop_code
ren ag7a_09 value_lost
replace value_lost = ag7b_09 if value_lost==.
replace value_lost = ag5a_23 if value_lost==.
replace value_lost = ag5b_23 if value_lost==.
recode value_lost (.=0)
collapse (sum) value_lost, by (y2_hhid crop_code)
merge 1:1 y2_hhid crop_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_crop_values_production.dta"
drop if _merge==2
replace value_lost = value_crop_production if value_lost > value_crop_production
collapse (sum) value_lost, by (y2_hhid)
ren value_lost crop_value_lost
lab var crop_value_lost "Value of crop production that had been lost by the time of survey"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_losses.dta", replace


********************************************************************************
*CROP EXPENSES
********************************************************************************
*Expenses: Hired labor
use "${Tanzania_NPS_W2_raw_data}/AG_SEC3A.dta", clear
ren ag3a_72_3 wages_landprep_planting
ren ag3a_72_6 wages_weeding
ren ag3a_72_64 wages_other_nonharvesting
ren ag3a_72_9 wages_harvesting
recode wages_landprep_planting wages_weeding wages_other_nonharvesting wages_harvesting (.=0)
gen wages_paid_main = wages_landprep_planting + wages_weeding + wages_other_nonharvesting + wages_harvesting 

global topcropname_annual "maize rice wheat sorgum pmill cowpea grdnt beans yam swtptt cotton sunflr pigpea"
foreach cn in $topcropname_annual {		//labor for permanent crops is all recorded in the SRS
	preserve
	gen short = 0
	ren plotnum plot_id
	*disaggregate by gender of plot manager
	merge m:1 y2_hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_decision_makers.dta"
	foreach i in wages_paid_main{
	gen `i'_`cn' = `i'
	gen `i'_`cn'_male = `i' if dm_gender==1 
	gen `i'_`cn'_female = `i' if dm_gender==2 
	gen `i'_`cn'_mixed = `i' if dm_gender==3 
	}
	*Merge in monocropped plots
	merge m:1 y2_hhid plot_id short using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_`cn'_monocrop.dta", nogen /*assert(1 3)*/ keep(3)		
	collapse (sum) wages_paid_main_`cn'*, by(y2_hhid)		
	lab var wages_paid_main_`cn' "Wages paid for hired labor (crops) in main growing season - Monocropped `cn' plots only"
	save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_wages_mainseason_`cn'.dta", replace
	restore
} 
collapse (sum) wages_paid_main, by (y2_hhid)
lab var wages_paid_main  "Wages paid for hired labor (crops) in main growing season"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_wages_mainseason.dta", replace

use "${Tanzania_NPS_W2_raw_data}/AG_SEC3B.dta", clear
ren ag3b_72_3 wages_landprep_planting
ren ag3b_72_6 wages_weeding
ren ag3b_72_64 wages_other_nonharvesting
ren ag3b_72_9 wages_harvesting
recode wages_landprep_planting wages_weeding wages_other_nonharvesting wages_harvesting (.=0)
gen wages_paid_short = wages_landprep_planting + wages_weeding + wages_other_nonharvesting + wages_harvesting 

global topcropname_short "maize rice sorgum pmill cowpea grdnt beans swtptt cassav cotton sunflr pigpea" 
foreach cn in $topcropname_short {		
	preserve
	gen short = 1
	ren plotnum plot_id
	*disaggregate by gender of plot manager
	merge m:1 y2_hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_decision_makers.dta"
	foreach i in wages_paid_short{
		gen `i'_`cn' = `i'
		gen `i'_`cn'_male = `i' if dm_gender==1 
		gen `i'_`cn'_female = `i' if dm_gender==2 
		gen `i'_`cn'_mixed = `i' if dm_gender==3 
	}
	*Merge in monocropped plots
	merge m:1 y2_hhid plot_id short using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_`cn'_monocrop.dta", nogen /*assert(1 3)*/ keep(3)	
	collapse (sum) wages_paid_short_`cn'*, by(y2_hhid)	
	lab var wages_paid_short_`cn' "Wages paid for hired labor (crops) in short growing season - Monocropped `cn' plots only"
	save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_wages_shortseason_`cn'.dta", replace
	restore
} 
collapse (sum) wages_paid_short, by (y2_hhid)
lab var wages_paid_short  "Wages paid for hired labor (crops) in short growing season"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_wages_shortseason.dta", replace

*Expenses: Inputs
use "${Tanzania_NPS_W2_raw_data}/AG_SEC3A.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC3B.dta", gen(short)

*formalized land rights
replace ag3a_27=ag3b_27 if ag3a_27==. 
gen formal_land_rights=ag3a_27==1 //if responded yes to "did anyone in the household have a title for this land?"

*Individual level (for women)
*Assuming ANY listed owners are also listed on the document 
replace ag3a_29_1 = ag3b_29_1 if ag3a_29_1==. 
replace ag3a_29_2 = ag3b_29_2 if ag3a_29_2==.

*Starting with first owner
preserve
ren ag3a_29_1 indidy2
merge m:1 y2_hhid indidy2 using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_person_ids.dta", nogen keep(3)		// keep only matched
keep y2_hhid indidy2 female formal_land_rights
tempfile p1
save `p1', replace
restore

*Now second owner
preserve
ren ag3a_29_2 indidy2		
merge m:1 y2_hhid indidy2 using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_person_ids.dta", nogen keep(3)		// keep only matched 
keep y2_hhid indidy2 female
append using `p1'
gen formal_land_rights_f = formal_land_rights==1 if female==1
collapse (max) formal_land_rights_f, by(y2_hhid indidy2)		
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_land_rights_ind.dta", replace
restore	

preserve
collapse (max) formal_land_rights_hh=formal_land_rights, by(y2_hhid)		// taking max at household level; equals one if they have official documentation for at least one plot
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_land_rights_hh.dta", replace
restore

gen value_fertilizer_1 = ag3a_49
replace value_fertilizer_1 = ag3b_49 if value_fertilizer_1==.
gen value_fertilizer_2 = ag3a_56
replace value_fertilizer_2 = ag3b_56 if value_fertilizer_2==.
recode value_fertilizer_1 value_fertilizer_2 (.=0)
gen value_fertilizer = value_fertilizer_1 + value_fertilizer_2
gen value_herb_pest = ag3a_61
replace value_herb_pest = ag3b_61 if value_herb_pest==.
recode value_herb_pest (.=0)
gen value_manure_purchased = ag3a_43
replace value_manure_purchased = ag3b_43 if value_manure_purchased==.
recode value_manure_purchased (.=0)

foreach cn in $topcropname_area {					
	preserve
	ren plotnum plot_id
	*disaggregate by gender plot manager
	merge m:1 y2_hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_decision_makers.dta"
	*Merge in monocropped plots
	merge m:1 y2_hhid plot_id short using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_`cn'_monocrop.dta", nogen /*assert(1 3)*/ keep(3)		// only in master and matched; keeping only matched, because these are the maize monocropped plots
	foreach i in value_fertilizer value_herb_pest {		
	gen `i'_`cn' = `i'
	gen `i'_`cn'_male = `i' if dm_gender==1
	gen `i'_`cn'_female = `i' if dm_gender==2
	gen `i'_`cn'_mixed = `i' if dm_gender==3
}
	collapse (sum) value_fertilizer_`cn'* value_herb_pest_`cn'*, by(y2_hhid)	
	lab var value_fertilizer_`cn' "Value of fertilizer purchased (not necessarily the same as used) in main and short growing seasons - Monocropped `cn' plots only"
	lab var value_herb_pest_`cn' "Value of herbicide purchased (not necessarily the same as used) in main and short growing seasons - Monocropped `cn' plots only"
	save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fertilizer_costs_`cn'.dta", replace
	restore
}
collapse (sum) value_fertilizer value_herb_pest value_manure_purchased, by (y2_hhid)
lab var value_fertilizer "Value of fertilizer purchased (not necessarily the same as used) in main and short growing seasons"
lab var value_herb_pest "Value of herbicide/pesticide purchased (not necessarily the same as used) in main and short growing seasons"
lab var value_manure_purchased "Value of manure purchased (not what was used) in main and short growing seasons"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fertilizer_costs.dta", replace

*Seed
use "${Tanzania_NPS_W2_raw_data}/AG_SEC4A.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC4B.dta", gen(short)
gen cost_seed = ag4a_21
replace cost_seed = ag4b_21 if cost_seed==.
recode cost_seed (.=0)

foreach cn in $topcropname_annual {		
*seed costs for monocropped plots
	preserve
	ren plotnum plot_id
	*disaggregate by gender of plot manager
	merge m:1 y2_hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_decision_makers.dta"
	gen cost_seed_male=cost_seed if dm_gender==1
	gen cost_seed_female=cost_seed if dm_gender==2
	gen cost_seed_mixed=cost_seed if dm_gender==3
	*Merge in monocropped plots
	merge m:1 y2_hhid plot_id short using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_`cn'_monocrop.dta", nogen /*assert(1 3)*/ keep(3)		// only in master and matched; keeping only matched, because these are the maize monocropped plots
	collapse (sum) cost_seed_`cn' = cost_seed cost_seed_`cn'_male = cost_seed_male cost_seed_`cn'_female = cost_seed_female cost_seed_`cn'_mixed = cost_seed_mixed, by(y2_hhid)		// renaming all to "_`cn'" suffix
	lab var cost_seed_`cn' "Expenditures on seed for temporary crops - Monocropped `cn' plots only"
	save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_seed_costs_`cn'.dta", replace
	restore
}
collapse (sum) cost_seed, by (y2_hhid)
lab var cost_seed "Value of purchased seed for temporary crops"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_seed_costs.dta", replace

*Land rental
use "${Tanzania_NPS_W2_raw_data}/AG_SEC3A.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC3B.dta", gen(short)
gen rental_cost_land = ag3a_32
replace rental_cost_land = ag3b_32 if rental_cost_land==.
recode rental_cost_land (.=0)

foreach cn in $topcropname_area {		
	preserve
	ren plotnum plot_id
	*disaggregate by gender of plot manager
	merge m:1 y2_hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_decision_makers.dta"
	*Merge in monocropped plots
	merge 1:1 y2_hhid plot_id short using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_`cn'_monocrop.dta", nogen /*assert(1 3)*/ keep(3)		// only in master and matched; keeping only matched, because these are the maize monocropped plots	
	gen rental_cost_land_`cn'=rental_cost_land
	gen rental_cost_land_`cn'_male=rental_cost_land if dm_gender==1
	gen rental_cost_land_`cn'_female=rental_cost_land if dm_gender==2
	gen rental_cost_land_`cn'_mixed=rental_cost_land if dm_gender==3
	collapse (sum) rental_cost_land_`cn'* , by(y2_hhid)				// Now, this sum should be only rental costs for parcels that are maize monocrops
	lab var rental_cost_land_`cn' "Rental costs paid for land - Monocropped `cn' plots only"
	save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_land_rental_costs_`cn'.dta", replace
	restore
}		
collapse (sum) rental_cost_land, by (y2_hhid)
lab var rental_cost_land "Rental costs paid for land"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_land_rental_costs.dta", replace

*Rental of agricultural tools, machines, animal traction
use "${Tanzania_NPS_W2_raw_data}/AG_SEC11.dta", clear
ren itemcode itemid
gen animal_traction = (itemid>=3 & itemid<=5)
gen ag_asset = (itemid<3 | itemid>8)
gen tractor = (itemid>=6 & itemid<=8)
ren ag11_09 rental_cost
gen rental_cost_animal_traction = rental_cost if animal_traction==1
gen rental_cost_ag_asset = rental_cost if ag_asset==1
gen rental_cost_tractor = rental_cost if tractor==1
recode rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor (.=0)
collapse (sum) rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor, by (y2_hhid)
lab var rental_cost_animal_traction "Costs for renting animal traction"
lab var rental_cost_ag_asset "Costs for renting other agricultural items"
lab var rental_cost_tractor "Costs for renting a tractor"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_asset_rental_costs.dta", replace

*Transport costs for crop sales
use "${Tanzania_NPS_W2_raw_data}/AG_SEC5A.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC5B.dta"
ren ag5a_19 transport_costs_cropsales
replace transport_costs_cropsales = ag5b_19 if transport_costs_cropsales==.
recode transport_costs_cropsales (.=0)
collapse (sum) transport_costs_cropsales, by (y2_hhid)
lab var transport_costs_cropsales "Expenditures on transportation for crop sales of temporary crops"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_transportation_cropsales.dta", replace

*Crop costs 
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_asset_rental_costs.dta", clear
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_land_rental_costs.dta", nogen
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_seed_costs.dta", nogen
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fertilizer_costs.dta", nogen
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_wages_shortseason.dta", nogen
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_wages_mainseason.dta", nogen
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_transportation_cropsales.dta", nogen
recode rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor rental_cost_land cost_seed value_fertilizer /*
*/ value_herb_pest wages_paid_short wages_paid_main transport_costs_cropsales (.=0)
egen crop_production_expenses = rowtotal(rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor rental_cost_land cost_seed value_fertilizer /*
*/ value_herb_pest wages_paid_short wages_paid_main transport_costs_cropsales)
*save "$created_data/Tanzania_NPS_W2_crop_income.dta", replace

********************************************************************************
*LIVESTOCK INCOME
********************************************************************************
*Expenses
use "${Tanzania_NPS_W2_raw_data}/AG_SEC10A.dta", clear
ren ag10a_36 cost_fodder_livestock
ren ag10a_34 cost_hired_labor_livestock 
recode cost_fodder_livestock cost_hired_labor_livestock (.=0)
collapse (sum) cost_fodder_livestock cost_hired_labor_livestock, by (y2_hhid)
lab var cost_fodder_livestock "Cost for fodder for livestock"
lab var cost_hired_labor_livestock "Cost for hired labor for livestock"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_expenses", replace
*Livestock products
use "${Tanzania_NPS_W2_raw_data}/AG_SEC10B.dta", clear
ren itemcode livestock_code
ren ag10b_02 months_produced
ren ag10b_03_1 quantity_month
ren ag10b_03_2 quantity_month_unit
replace quantity_month_unit = 1 if livestock_code==1 | livestock_code==2
replace quantity_month_unit = 3 if livestock_code==3 | livestock_code==4
replace quantity_month_unit = 1 if livestock_code==5 
replace quantity_month_unit = 1 if livestock_code==6 
replace quantity_month_unit = 1 if livestock_code==7
replace quantity_month_unit = 3 if livestock_code==8
recode months_produced quantity_month (.=0)
gen quantity_produced = months_produced * quantity_month /* Units are pieces for eggs & skin, liters for honey, liters for milk */
lab var quantity_produced "Quantity of this product produed in past year"
ren ag10b_05_1 sales_quantity
ren ag10b_05_2 sales_unit
replace sales_unit = 1 if livestock_code==1 | livestock_code==2
replace sales_unit = 3 if livestock_code==3 | livestock_code==4
replace sales_unit = 1 if livestock_code==5
replace sales_unit = 1 if livestock_code==6 
replace sales_unit = 1 if livestock_code==7
replace sales_unit = 3 if livestock_code==8
replace sales_unit = 3 if livestock_code==10 | livestock_code==11 | livestock_code==12 
ren ag10b_06 earnings_sales
recode sales_quantity months_produced quantity_month earnings_sales (.=0)
gen price_per_unit = earnings_sales / sales_quantity
keep y2_hhid livestock_code quantity_produced price_per_unit earnings_sales
bys livestock_code: sum price_per_unit
gen price_per_unit_hh = price_per_unit
recode price_per_unit price_per_unit_hh (0=.) 
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products_other", replace

use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products_other", clear
merge m:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhids.dta"
drop if _merge==2
drop _merge
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products", replace

use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products", clear
keep if price_per_unit !=. 
gen observation = 1
bys region district ward ea livestock_code: egen obs_ea = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district ward ea livestock_code obs_ea)
ren price_per_unit price_median_ea
lab var price_median_ea "Median price per unit for this livestock product in the ea"
lab var obs_ea "Number of sales observations for this livestock product in the ea"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products_prices_ea.dta", replace
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region district ward livestock_code: egen obs_ward = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district ward livestock_code obs_ward)
ren price_per_unit price_median_ward
lab var price_median_ward "Median price per unit for this livestock product in the ward"
lab var obs_ward "Number of sales observations for this livestock product in the ward"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products_prices_ward.dta", replace
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region district livestock_code: egen obs_district = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district livestock_code obs_district)
ren price_per_unit price_median_district
lab var price_median_district "Median price per unit for this livestock product in the district"
lab var obs_district "Number of sales observations for this livestock product in the district"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products_prices_district.dta", replace
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_unit [aw=weight], by (region livestock_code obs_region)
ren price_per_unit price_median_region
lab var price_median_region "Median price per unit for this livestock product in the region"
lab var obs_region "Number of sales observations for this livestock product in the region"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products_prices_region.dta", replace
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_unit [aw=weight], by (livestock_code obs_country)
ren price_per_unit price_median_country
lab var price_median_country "Median price per unit for this livestock product in the country"
lab var obs_country "Number of sales observations for this livestock product in the country"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products_prices_country.dta", replace

use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products", clear
merge m:1 region district ward ea livestock_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products_prices_ea.dta", nogen
merge m:1 region district ward livestock_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products_prices_ward.dta", nogen
merge m:1 region district livestock_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products_prices_district.dta", nogen
merge m:1 region livestock_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products_prices_region.dta", nogen
merge m:1 livestock_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products_prices_country.dta", nogen
replace price_per_unit = price_median_ea if price_per_unit==. & obs_ea >= 10
replace price_per_unit = price_median_ward if price_per_unit==. & obs_ward >= 10
replace price_per_unit = price_median_district if price_per_unit==. & obs_district >= 10 
replace price_per_unit = price_median_region if price_per_unit==. & obs_region >= 10 
replace price_per_unit = price_median_country if price_per_unit==.
lab var price_per_unit "Price per unit of this livestock product, with missing values imputed using local median values"
gen price_cowmilk_med = price_median_country if livestock_code==1 | livestock_code==2
egen price_cowmilk = max(price_cowmilk_med)
lab var price_per_unit "Price per liter (milk) or per egg/liter/container honey, imputed with local median prices if household did not sell"
gen value_milk_produced = quantity_produced * price_per_unit if livestock_code==1 | livestock_code==2
gen value_eggs_produced = quantity_produced * price_per_unit if livestock_code==3 | livestock_code==4
gen value_other_produced = quantity_produced * price_per_unit if livestock_code!= 1 & livestock_code!=2 & livestock_code!=3 & livestock_code!=4
gen sales_livestock_products = earnings_sales	
collapse (sum) value_milk_produced value_eggs_produced value_other_produced sales_livestock_products, by (y2_hhid)
egen value_livestock_products = rowtotal(value_milk_produced value_eggs_produced value_other_produced)
gen share_livestock_prod_sold = sales_livestock_products/value_livestock_products
replace share_livestock_prod_sold = 1 if share_livestock_prod_sold>1 & share_livestock_prod_sold!=.
lab var share_livestock_prod_sold "Percent of production of livestock products that is sold" 
lab var value_milk_produced "Value of milk produced"
lab var value_eggs_produced "Value of eggs produced"
lab var value_other_produced "Value of butter, cheese, honey and skins produced"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_livestock_products", replace

use "${Tanzania_NPS_W2_raw_data}/AG_SEC10B.dta", clear
gen sales_dung=ag10b_06 if itemcode==9 
recode sales_dung (.=0)
collapse (sum) sales_dung, by (y2_hhid)
lab var sales_dung "Value of dung sold" 
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_dung.dta", replace

*Sales (live animals)
use "${Tanzania_NPS_W2_raw_data}/AG_SEC10A.dta", clear
ren lvstkcode livestock_code
ren ag10a_21 income_live_sales 
ren ag10a_20 number_sold 
ren ag10a_25 number_slaughtered 
ren ag10a_26 number_slaughtered_sold 
replace number_slaughtered = number_slaughtered_sold if number_slaughtered < number_slaughtered_sold 
ren ag10a_27 income_slaughtered
ren ag10a_09 value_livestock_purchases
recode income_live_sales number_sold number_slaughtered number_slaughtered_sold income_slaughtered value_livestock_purchases (.=0)
gen price_per_animal = income_live_sales / number_sold
recode price_per_animal (0=.)
merge m:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhids.dta"
drop if _merge==2
drop _merge
keep y2_hhid weight region district ward ea livestock_code number_sold income_live_sales number_slaughtered number_slaughtered_sold income_slaughtered price_per_animal value_livestock_purchases
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_livestock_sales", replace

*Implicit prices
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district ward ea livestock_code: egen obs_ea = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district ward ea livestock_code obs_ea)
ren price_per_animal price_median_ea
lab var price_median_ea "Median price per unit for this livestock in the ea"
lab var obs_ea "Number of sales observations for this livestock in the ea"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_prices_ea.dta", replace
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district ward livestock_code: egen obs_ward = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district ward livestock_code obs_ward)
ren price_per_animal price_median_ward
lab var price_median_ward "Median price per unit for this livestock in the ward"
lab var obs_ward "Number of sales observations for this livestock in the ward"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_prices_ward.dta", replace
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district livestock_code: egen obs_district = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district livestock_code obs_district)
ren price_per_animal price_median_district
lab var price_median_district "Median price per unit for this livestock in the district"
lab var obs_district "Number of sales observations for this livestock in the district"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_prices_district.dta", replace
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_animal [aw=weight], by (region livestock_code obs_region)
ren price_per_animal price_median_region
lab var price_median_region "Median price per unit for this livestock in the region"
lab var obs_region "Number of sales observations for this livestock in the region"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_prices_region.dta", replace
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_animal [aw=weight], by (livestock_code obs_country)
ren price_per_animal price_median_country
lab var price_median_country "Median price per unit for this livestock in the country"
lab var obs_country "Number of sales observations for this livestock in the country"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_prices_country.dta", replace

use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_livestock_sales", clear
merge m:1 region district ward ea livestock_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_prices_ea.dta", nogen
merge m:1 region district ward livestock_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_prices_ward.dta", nogen
merge m:1 region district livestock_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_prices_district.dta", nogen
merge m:1 region livestock_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_prices_region.dta", nogen
merge m:1 livestock_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_prices_country.dta", nogen
replace price_per_animal = price_median_ea if price_per_animal==. & obs_ea >= 10
replace price_per_animal = price_median_ward if price_per_animal==. & obs_ward >= 10
replace price_per_animal = price_median_district if price_per_animal==. & obs_district >= 10
replace price_per_animal = price_median_region if price_per_animal==. & obs_region >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_lvstck_sold = price_per_animal * number_sold
gen value_slaughtered = price_per_animal * number_slaughtered
gen value_slaughtered_sold = price_per_animal * number_slaughtered_sold 
replace value_slaughtered_sold = income_slaughtered if (value_slaughtered < income_slaughtered) & number_slaughtered!=0 /* Replace value of slaughtered animals with income from slaughtered-sales if the latter is larger */
replace value_slaughtered = value_slaughtered_sold if (value_slaughtered_sold > value_slaughtered) & (number_slaughtered > number_slaughtered_sold) //replace value of slaughtered with value of slaughtered sold if value sold is larger
gen value_livestock_sales = value_lvstck_sold + value_slaughtered_sold
collapse (sum) value_livestock_sales value_livestock_purchases value_lvstck_sold value_slaughtered, by (y2_hhid)
drop if y2_hhid==""
lab var value_livestock_sales "Value of livestock sold (live and slaughtered)"
lab var value_livestock_purchases "Value of livestock purchases (seems to span only the agricutlural season, not the year)"
lab var value_slaughtered "Value of livestock slaughtered (with slaughtered livestock that weren't sold valued at local median prices for live animal sales)"
lab var value_lvstck_sold "Value of livestock sold live" 
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_sales", replace

*TLU (Tropical Livestock Units)
use "${Tanzania_NPS_W2_raw_data}/AG_SEC10A.dta", clear
ren lvstkcode lvstckid
gen tlu_coefficient=0.5 if (lvstckid==1|lvstckid==2|lvstckid==3|lvstckid==4|lvstckid==5|lvstckid==6)
replace tlu_coefficient=0.1 if (lvstckid==7|lvstckid==8)
replace tlu_coefficient=0.2 if (lvstckid==9)
replace tlu_coefficient=0.01 if (lvstckid==10|lvstckid==11|lvstckid==12|lvstckid==13)
replace tlu_coefficient=0.3 if (lvstckid==14)
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
ren lvstckid livestock_code
ren ag10a_04 number_1yearago
ren ag10a_05_1 number_today_indigenous
recode ag10a_05_2 ag10a_05_3 (.=0)
gen number_today_exotic=ag10a_05_2 + ag10a_05_3
gen number_today = number_today_indigenous + number_today_exotic
gen tlu_1yearago = number_1yearago * tlu_coefficient
gen tlu_today = number_today * tlu_coefficient
ren ag10a_21 income_live_sales 
ren ag10a_20 number_sold 
ren ag10a_14 lost_disease
*adding livestock mortality rate and percent of improved licestock breeds
*Going to construct twelve month average livestock ownership as average of number today and number one year ago
egen mean_12months = rowmean(number_today number_1yearago)
gen animals_lost12months = lost_disease // animals lost to disease, NOT including theft or injury
*Generating mortality rate as animals lost divided by mean
gen share_imp_herd_cows = number_today_exotic/(number_today) if livestock_code==2 
gen species=(inlist(livestock_code,1,2,3,4,5,6)) + 2*(inlist(livestock_code,7,8)) + 3*(livestock_code==9) + 4*(livestock_code==13) + 5*(inlist(livestock_code,10,11))
recode species (0=.)
la def species 1 "Large ruminants (cows)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses)" 5 "Poultry"
la val species species
preserve
*household level
*first, generating these values by species
collapse (firstnm) share_imp_herd_cows (sum) number_today number_1yearago animals_lost12months number_today_exotic lost_disease lvstck_holding=number_today, by(y2_hhid species)
egen mean_12months = rowmean(number_today number_1yearago)
gen any_imp_herd=number_today_exotic!=0 if number_today!=. & number_today!=0

* A loop to create species variables
foreach i in animals_lost12months mean_12months any_imp_herd lvstck_holding lost_disease{
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==2
	gen `i'_pigs = `i' if species==3
	gen `i'_equine = `i' if species==4
	gen `i'_poultry = `i' if species==5
}
*Now we can collapse to household (taking firstnm because these variables are only defined once per household)
collapse (sum) number_today number_today_exotic (firstnm) *lrum *srum *pigs *equine *poultry share_imp_herd_cows, by(y2_hhid)
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
lab var animals_lost12months  "Total number of livestock  lost to disease"
lab var  mean_12months  "Average number of livestock  today and 1  year ago"
lab var lost_disease "Total number of livestock lost to disease"
*A loop to label these variables (taking the labels above to construct each of these for each species)
foreach i in any_imp_herd lvstck_holding animals_lost12months mean_12months lost_disease{
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
drop lvstck_holding animals_lost12months mean_12months lost_disease
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_herd_characteristics", replace
restore

gen price_per_animal = income_live_sales / number_sold
recode price_per_animal (0=.) 
merge m:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhids.dta", nogen keep(1 3)
merge m:1 region district ward ea livestock_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_prices_ea.dta", nogen
merge m:1 region district ward livestock_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_prices_ward.dta", nogen
merge m:1 region district livestock_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_prices_district.dta", nogen
merge m:1 region livestock_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_prices_region.dta", nogen
merge m:1 livestock_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_prices_country.dta", nogen
replace price_per_animal = price_median_ea if price_per_animal==. & obs_ea >= 10
replace price_per_animal = price_median_ward if price_per_animal==. & obs_ward >= 10
replace price_per_animal = price_median_district if price_per_animal==. & obs_district >= 10
replace price_per_animal = price_median_region if price_per_animal==. & obs_region >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_1yearago = number_1yearago * price_per_animal
gen value_today = number_today * price_per_animal
collapse (sum) tlu_1yearago tlu_today value_1yearago value_today, by (y2_hhid)
lab var tlu_1yearago "Tropical Livestock Units as of 12 months ago"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
lab var value_1yearago "Value of livestock holdings from one year ago"
gen lvstck_holding_tlu = tlu_today
lab var lvstck_holding_tlu "Total HH livestock holdings, TLU"  
lab var value_today "Value of livestock holdings today"
drop if y2_hhid==""
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_TLU.dta", replace

*Livestock income
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_sales", clear
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_livestock_products", nogen
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_dung.dta", nogen
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_expenses", nogen
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_TLU.dta", nogen
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_TLU_Coefficients.dta", nogen
gen livestock_income = value_livestock_sales - value_livestock_purchases /*
*/ + (value_milk_produced + value_eggs_produced + value_other_produced + sales_dung) /*
*/ - (cost_hired_labor_livestock + cost_fodder_livestock)
lab var livestock_income "Net livestock income"
*save "$created_data/Tanzania_NPS_W2_livestock_income.dta", replace


********************************************************************************
*FISH INCOME
********************************************************************************
*Fishing expenses
use "${Tanzania_NPS_W2_raw_data}/FS_C1.dta", clear
ren fs_c01a weeks_fishing_fulltime_hs 
ren fs_c01b days_per_week_fulltime_hs
ren fs_c02a weeks_fishing_part_hs
ren fs_c02c days_per_week_part_hs
recode weeks_fishing_fulltime_hs days_per_week_fulltime_hs weeks_fishing_part_hs days_per_week_part_hs (.=0)
gen weeks_fishing_hs = weeks_fishing_part_hs + weeks_fishing_fulltime_hs 
gen days_fishing_hs = (weeks_fishing_fulltime_hs * days_per_week_fulltime_hs) + (weeks_fishing_part_hs * days_per_week_part_hs)
collapse days_fishing_hs (max) weeks_fishing_hs, by (y2_hhid) 
keep y2_hhid weeks_fishing_hs days_fishing_hs
lab var weeks_fishing_hs "Weeks spent working fulltime and parttime as a fisherman in the last high season (maximum observed across individuals in household)"
lab var days_fishing_hs "Days spent working fulltime and parttime as a fisherman in the last high season (maximum observed across individuals in household)"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_weeks_fishing_highseason.dta", replace

use "${Tanzania_NPS_W2_raw_data}/FS_I.dta", clear
ren fs_i01a weeks_fishing_fulltime_ls 
ren fs_i01b days_per_week_fulltime_ls
ren fs_i02a weeks_fishing_part_ls
ren fs_i02c days_per_week_part_ls
recode weeks_fishing_fulltime_ls days_per_week_fulltime_ls weeks_fishing_part_ls days_per_week_part_ls (.=0)
gen weeks_fishing_ls = weeks_fishing_part_ls + weeks_fishing_fulltime_ls 
gen days_fishing_ls = (weeks_fishing_fulltime_ls * days_per_week_fulltime_ls) + (weeks_fishing_part_ls * days_per_week_part_ls)
collapse days_fishing_ls (max) weeks_fishing_ls, by (y2_hhid) 
keep y2_hhid weeks_fishing_ls days_fishing_ls
lab var weeks_fishing_ls "Weeks spent working fulltime and parttime as a fisherman in the last low season (maximum observed across individuals in household)"
lab var days_fishing_ls "Days spent working fulltime and parrtime as a fisherman in the last low season (maximum observed across individuals in household)"
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_weeks_fishing_highseason.dta"
drop _merge
gen weeks_fishing = weeks_fishing_hs + weeks_fishing_ls
gen days_fishing = days_fishing_hs + days_fishing_ls
lab var weeks_fishing "Weeks spent working as a fisherman in the last year (maximum observed across individuals in household)"
lab var days_fishing "Days spent working as a fisherman in the last year (maximum observed across individuals in household)" 
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_weeks_fishing.dta", replace

*Hired labor
use "${Tanzania_NPS_W2_raw_data}/FS_D2.dta", clear
ren fs_d06a adults_fishing
ren fs_d06b weeks_per_adult 
ren fs_d06c children_fishing
ren fs_d06d weeks_per_child
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_raw_data}/FS_D3.dta"
ren fs_d08a fixed_wage_adult
ren fs_d08b fixed_wage_child
ren fs_d12a boatrev_wage_adult
ren fs_d12b boatrev_wage_child
ren fs_d13a inkind_wage_adult
ren fs_d13b inkind_wage_child
recode fixed_wage_adult fixed_wage_child boatrev_wage_adult boatrev_wage_child inkind_wage_adult inkind_wage_child (.=0)
gen cost_labor_adult = (fixed_wage_adult + boatrev_wage_adult + inkind_wage_adult) * weeks_per_adult * adults_fishing
gen cost_labor_child = (fixed_wage_child + boatrev_wage_child + inkind_wage_child) * weeks_per_child * children_fishing 
gen cost_total_labor_highseason = cost_labor_child + cost_labor_adult
collapse (sum) cost_total_labor_highseason, by (y2_hhid)
lab var cost_total_labor "Cost for hired labor in the last high season"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fishing_expenses_labor_highseason.dta", replace

use "${Tanzania_NPS_W2_raw_data}/FS_E1.dta", clear
merge 1:1 y2_hhid gearid using "${Tanzania_NPS_W2_raw_data}/FS_K1.dta"
drop _merge
ren fs_e06 rental_costs_fishing_hs
ren fs_k06 rental_costs_fishing_ls
recode rental_costs_fishing_hs rental_costs_fishing_ls (.=0)
gen rental_cost_fishing= rental_costs_fishing_hs + rental_costs_fishing_ls
collapse (sum) rental_cost_fishing, by (y2_hhid)
lab var rental_cost_fishing "cost for other rental fishing expenses over the past year"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fishing_expenses_1-1.dta", replace 

use "${Tanzania_NPS_W2_raw_data}/FS_E2.dta", clear
merge 1:1 boatengine_id y2_hhid using "${Tanzania_NPS_W2_raw_data}/FS_K2.dta"
drop _merge
ren fs_e12a rental_costs_boat_hs
ren fs_e12b rental_costs_boat_unit_hs 
ren fs_k12a rental_costs_boat_ls
ren fs_k12b rental_costs_boat_unit_ls
ren fs_e14a boat_maintenance_hs
ren fs_e14b boat_maintenance_unit_hs
ren fs_k14a boat_maintenance_ls 
ren fs_k14b boat_maintenance_unit_ls
ren fs_e13a fuel_cost_hs
ren fs_e13b fuel_cost_unit_hs
ren fs_k13a fuel_cost_ls
ren fs_k13b fuel_cost_unit_ls
recode rental_costs_boat_hs rental_costs_boat_ls boat_maintenance_hs boat_maintenance_ls fuel_cost_hs fuel_cost_ls (.=0)
merge m:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_weeks_fishing.dta"
replace rental_costs_boat_hs = rental_costs_boat_hs * weeks_fishing_hs if rental_costs_boat_unit_hs == 2
replace rental_costs_boat_hs = rental_costs_boat_hs * days_fishing_hs if rental_costs_boat_unit_hs == 1
replace rental_costs_boat_ls = rental_costs_boat_ls * weeks_fishing_ls if rental_costs_boat_unit_ls == 2
replace rental_costs_boat_ls = rental_costs_boat_ls * days_fishing_ls if rental_costs_boat_unit_ls == 1
gen rental_costs_boat = rental_costs_boat_hs + rental_costs_boat_ls
replace boat_maintenance_hs = boat_maintenance_hs * weeks_fishing_hs if boat_maintenance_unit_hs == 2
replace boat_maintenance_hs = boat_maintenance_hs * days_fishing_hs if boat_maintenance_unit_hs == 1
replace boat_maintenance_ls = boat_maintenance_ls * weeks_fishing_ls if boat_maintenance_unit_ls == 2
replace boat_maintenance_ls = boat_maintenance_ls * days_fishing_ls if boat_maintenance_unit_ls == 1
gen boat_maintenance = boat_maintenance_hs + boat_maintenance_ls 
replace fuel_cost_hs = fuel_cost_hs * weeks_fishing_hs if fuel_cost_unit_hs == 2
replace fuel_cost_hs = fuel_cost_hs * days_fishing_hs if fuel_cost_unit_hs == 1
replace fuel_cost_ls = fuel_cost_ls * weeks_fishing_ls if fuel_cost_unit_ls== 2
replace fuel_cost_ls = fuel_cost_ls * days_fishing_ls if fuel_cost_unit_ls==1 
gen cost_fuel = fuel_cost_hs + fuel_cost_ls + boat_maintenance
collapse (sum) rental_costs_boat cost_fuel, by (y2_hhid) 
la var rental_costs_boat "Costs for boat rental over the past year"
la var cost_fuel "Costs for fuel, oil, and maintenance over the past year" 
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fishing_expenses_1-1.dta"
drop _merge
gen rental_costs_fishing = rental_cost_fishing + rental_costs_boat
lab var rental_costs_fishing "Costs for other fishing expenses over the past year"
keep y2_hhid cost_fuel rental_costs_fishing
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fishing_expenses_1.dta", replace

use "${Tanzania_NPS_W2_raw_data}/FS_E3.dta", clear
merge m:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_weeks_fishing.dta"
gen cost = fs_e16a if inputid!= "A" & inputid!= "B" & inputid!= "C" & inputid!= "D" /* Exclude taxes, per RuLIS guidelines */
ren fs_e16b unit
gen cost_paid_hs = cost if unit==4 | unit==3
replace cost_paid = cost * weeks_fishing if unit==2
replace cost_paid = cost * days_fishing if unit==1
collapse (sum) cost_paid_hs, by (y2_hhid)
lab var cost_paid_hs "Other costs paid for fishing activities in the last high season"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fishing_expenses_2-1.dta", replace

use "${Tanzania_NPS_W2_raw_data}/FS_K3.dta", clear
merge m:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_weeks_fishing.dta"
gen cost = fs_k16a if inputid!= "A" & inputid!= "B" & inputid!= "C" & inputid!= "D" /* Exclude taxes, per RuLIS guidelines */
ren fs_k16b unit
gen cost_paid_ls = cost if unit==4 | unit==3
replace cost_paid = cost * weeks_fishing if unit==2
replace cost_paid = cost * days_fishing if unit==1
collapse (sum) cost_paid_ls, by (y2_hhid)
lab var cost_paid_ls "Other costs paid for fishing activities in the last low season"
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fishing_expenses_2-1.dta"
gen cost_paid = cost_paid_ls + cost_paid_hs
keep y2_hhid cost_paid
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fishing_expenses_2.dta", replace

use "${Tanzania_NPS_W2_raw_data}/FS_F.dta", clear
recode fs_f11d (9999999=.) (9999900=.) ( 9800000=.) (9600000 =.) (9400000=.) (9000000=.)
ren fs_f02b fish_code 
ren fs_f11a fish_quantity
ren fs_f11b unit 
gen price_per_unit=fs_f11d/fish_quantity
append using "${Tanzania_NPS_W2_raw_data}/FS_L.dta"
recode fs_l11d (9999999=.) (9999900=.) ( 9800000=.) (9600000 =.) (9400000=.) (9000000=.)
replace fish_code = fs_l02b if fish_code==.
drop if fish_code==. /* "Other" = 33 */
replace fish_quantity = fs_l11a if fish_quantity==.
replace unit = fs_l11b if unit==.
replace price_per_unit= fs_l11d/fs_l11a if price_per_unit==.
recode price_per_unit (0=.) 
merge m:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhids.dta"
drop if _merge==2
drop _merge
collapse (median) price_per_unit [aw=weight], by (fish_code unit)
ren price_per_unit price_per_unit_median
replace price_per_unit_median = . if fish_code==33
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_prices.dta", replace

use "${Tanzania_NPS_W2_raw_data}/FS_F.dta", clear
recode fs_f11d (9999999=.) (9999900=.) ( 9800000=.) (9600000 =.) (9400000=.) (9000000=.)
ren fs_f02b fish_code 
drop if fish_code==. 
ren fs_f04a fish_quantity_hs
replace fish_quantity_hs = . if fish_quantity_hs==999
ren fs_f04b unit
ren fs_f11a quantity_1
ren fs_f11b unit_1
gen price_unit_1 = fs_f11d/quantity_1
ren fs_f11e quantity_2
ren fs_f11f unit_2
gen price_unit_2 = fs_f11h/quantity_2
recode quantity_1 quantity_2 fish_quantity price_unit_1 price_unit_2 (.=0)
drop if y2_hhid=="1903007058008003" // typo
drop if y2_hhid == "2003024004005901" & unit==9 // dropped because we don't have price and the unit is "other" so we cannot convert 
replace unit = 3 if y2_hhid == "5301019011000901" & fishid == 5 //unit harvested in 25 kg bag. Sold unit in kg
replace fish_quantity = fish_quantity*25 if y2_hhid == "5301019011000901" & fishid == 5 
replace unit = 3 if y2_hhid == "0606007003026001" & fishid == 2 // unit harvested in 10 kg bag. Sold unit in kg
replace fish_quantity = fish_quantity*10 if y2_hhid == "0606007003026001" & fishid == 2
replace unit = 1 if y2_hhid == "1603011001019401" & fishid == 1 //unit harvested reported in dozen/bundle. There are median prices for this species in pieces
replace fish_quantity = fish_quantity*12 if y2_hhid == "1603011001019401" & fishid == 1
replace unit = 3 if y2_hhid == "1502019003084901" & fishid == 1 // unit harvested in 5kg bag. There are median prices for this species in kg. 
replace fish_quantity = fish_quantity*5 if y2_hhid == "1502019003084901" & fishid == 1
merge m:1 fish_code unit using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_prices.dta"
drop if _merge==2
drop _merge
gen income_fish_sales_hs = (quantity_1 * price_unit_1) + (quantity_2 * price_unit_2)
gen value_fish_harvest_hs = (fish_quantity * price_unit_1) if unit==unit_1 /* Use household's price, if it's observed*/
replace value_fish_harvest_hs = (fish_quantity * price_per_unit_median) if value_fish_harvest_hs==.
collapse fish_quantity (sum) value_fish_harvest_hs income_fish_sales_hs, by (y2_hhid)
recode value_fish_harvest_hs income_fish_sales_hs (.=0)
replace income_fish_sales_hs=value_fish_harvest_hs if value_fish_harvest_hs < income_fish_sales_hs
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_income_1.dta", replace

use "${Tanzania_NPS_W2_raw_data}/FS_L.dta", clear
recode fs_l11d (9999999=.) (9999900=.) ( 9800000=.) (9600000 =.) (9400000=.) (9000000=.)
ren fs_l02b fish_code 
drop if fish_code==. 
ren fs_l04a fish_quantity_ls
replace fish_quantity_ls = . if fish_quantity_ls==999
ren fs_l04b unit
ren fs_l11a quantity_1
ren fs_l11b unit_1
gen price_unit_1 = fs_l11d/quantity_1
ren fs_l11e quantity_2
ren fs_l11f unit_2
gen price_unit_2 = fs_l11h/quantity_2
recode quantity_1 quantity_2 fish_quantity price_unit_1 price_unit_2 (.=0) 
merge m:1 fish_code unit using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_prices.dta"
drop if _merge==2
drop _merge
gen income_fish_sales_ls = (quantity_1 * price_unit_1) + (quantity_2 * price_unit_2)
gen value_fish_harvest_ls = (fish_quantity * price_unit_1) if unit==unit_1
replace value_fish_harvest_ls = (fish_quantity * price_per_unit_median) if value_fish_harvest_ls==.
collapse fish_quantity (sum) value_fish_harvest_ls income_fish_sales_ls, by (y2_hhid)
recode value_fish_harvest_ls income_fish_sales_ls (.=0)
merge 1:1 y2_hhid using  "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_income_1.dta"
recode value_fish_harvest_hs income_fish_sales_hs value_fish_harvest_ls income_fish_sales_ls (.=0)
gen value_fish_harvest = value_fish_harvest_hs + value_fish_harvest_ls
gen income_fish_sales = income_fish_sales_hs + income_fish_sales_ls
lab var value_fish_harvest "Value of fish harvest (including what is sold), with values imputed using a national median for fish-unit-prices"
lab var income_fish_sales "Value of fish sales"
keep y2_hhid value_fish_harvest income_fish_sales
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_income.dta", replace

*Fish income
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_income.dta", clear
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fishing_expenses_1.dta"
drop _merge
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fishing_expenses_2.dta"
drop _merge
gen fishing_income = value_fish_harvest - cost_fuel - rental_costs_fishing - cost_paid


********************************************************************************
*SELF-EMPLOYMENT INCOME
********************************************************************************
use "${Tanzania_NPS_W2_raw_data}/HH_SEC_E1.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/HH_SEC_E2.dta"
ren hh_e70 months_activ
ren hh_e71 monthly_profit
recode months_activ monthly_profit (.=0)
gen annual_selfemp_profit = months_activ*monthly_profit 
recode annual_selfemp_profit (.=0)
duplicates drop y2_hhid months_activ annual_selfemp_profit if annual_selfemp_profit!=0, force 
gen alrea_report_annualprofit=monthly_profit==months_activ*hh_e65_2 & hh_e65_1==2
tab alrea_report_annualprofit if  monthly_profit!=0 & monthly_profit!=.
gen alrea_report_annualprofit2=monthly_profit==months_activ*4*hh_e65_2 if  hh_e65_1==1
tab alrea_report_annualprofit2
replace annual_selfemp_profit=months_activ*hh_e65_2 if alrea_report_annualprofit==1 &  hh_e65_1==2
replace annual_selfemp_profit=months_activ*hh_e65_2 if alrea_report_annualprofit2==1 &  hh_e65_1==1
collapse (sum) annual_selfemp_profit, by (y2_hhid)
lab var annual_selfemp_profit "Estimated annual net profit from self-employment over previous 12 months"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_self_employment_income.dta", replace

use "${Tanzania_NPS_W2_raw_data}/AG_SEC09.dta", clear
ren zaocode crop_code
ren ag09_05 byproduct_sold_yesno
ren ag09_06_1 byproduct_quantity
ren ag09_06_2 byproduct_unit
ren ag09_07 kgs_used_in_byproduct 
ren ag09_08 byproduct_price_received
ren ag09_10 other_expenses_yesno
ren ag09_11 byproduct_other_costs
merge m:1 y2_hhid crop_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_crop_prices.dta"
drop _merge
recode byproduct_quantity kgs_used_in_byproduct byproduct_other_costs (.=0)
gen byproduct_sales = byproduct_quantity * byproduct_price_received
gen byproduct_crop_cost = kgs_used_in_byproduct * price_kg
gen byproduct_profits = byproduct_sales - (byproduct_crop_cost + byproduct_other_costs)
collapse (sum) byproduct_profits, by (y2_hhid)
lab var byproduct_profits "Net profit from sales of agricultural processed products or byproducts"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_agproducts_profits.dta", replace

*Fish trading
use "${Tanzania_NPS_W2_raw_data}/FS_C1.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/FS_I.dta"
ren fs_c04a weeks_fish_trading_hs
ren fs_i04a weeks_fish_trading_ls
recode weeks_fish_trading_* (.=0)
gen weeks_fish_trading = weeks_fish_trading_hs + weeks_fish_trading_ls
collapse (max) weeks_fish_trading, by (y2_hhid) 
replace weeks_fish_trading = 52 if weeks_fish_trading > 52
keep y2_hhid weeks_fish_trading
lab var weeks_fish_trading "Weeks spent working as a fish trader(maximum observed across individuals in household)"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_weeks_fish_trading.dta", replace

use "${Tanzania_NPS_W2_raw_data}/FS_H1.dta", clear
ren fs_h03a quant_fish_purchased_1
ren fs_h03d price_fish_purchased_1
ren fs_h03e quant_fish_purchased_2
ren fs_h03h price_fish_purchased_2
ren fs_h04a quant_fish_sold_1
ren fs_h04d price_fish_sold_1
ren fs_h04e quant_fish_sold_2
ren fs_h04h price_fish_sold_2
drop if price_fish_sold_1==6880000 // much higher than other prices
recode quant_fish_purchased_1 price_fish_purchased_1 quant_fish_purchased_2 price_fish_purchased_2 /*
*/ quant_fish_sold_1 price_fish_sold_1 quant_fish_sold_2 price_fish_sold_2 (.=0)
gen weekly_fishtrade_costs = (quant_fish_purchased_1 * price_fish_purchased_1) + (quant_fish_purchased_2 * price_fish_purchased_2)
gen weekly_fishtrade_revenue = (quant_fish_sold_1 * price_fish_sold_1) + (quant_fish_sold_2 * price_fish_sold_2)
gen weekly_fishtrade_profit_hs = weekly_fishtrade_revenue - weekly_fishtrade_costs
collapse (sum) weekly_fishtrade_profit_hs, by (y2_hhid)
keep y2_hhid weekly_fishtrade_profit_hs
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_trading_revenue-1.dta", replace

use "${Tanzania_NPS_W2_raw_data}/FS_N1.dta", clear
ren fs_n03a quant_fish_purchased_1
ren fs_n03d price_fish_purchased_1
ren fs_n03e quant_fish_purchased_2
ren fs_n03h price_fish_purchased_2
ren fs_n04a quant_fish_sold_1
ren fs_n04d price_fish_sold_1
ren fs_n04e quant_fish_sold_2
ren fs_n04h price_fish_sold_2
drop if price_fish_sold_1==99999 
recode quant_fish_purchased_1 price_fish_purchased_1 quant_fish_purchased_2 price_fish_purchased_2 /*
*/ quant_fish_sold_1 price_fish_sold_1 quant_fish_sold_2 price_fish_sold_2 (.=0)
gen weekly_fishtrade_costs = (quant_fish_purchased_1 * price_fish_purchased_1) + (quant_fish_purchased_2 * price_fish_purchased_2)
gen weekly_fishtrade_revenue = (quant_fish_sold_1 * price_fish_sold_1) + (quant_fish_sold_2 * price_fish_sold_2)
gen weekly_fishtrade_profit_ls = weekly_fishtrade_revenue - weekly_fishtrade_costs
collapse (sum) weekly_fishtrade_profit_ls, by (y2_hhid)
keep y2_hhid weekly_fishtrade_profit_ls
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_trading_revenue-1.dta"
drop _merge
gen weekly_fishtrade_profit = weekly_fishtrade_profit_hs + weekly_fishtrade_profit_ls
keep y2_hhid weekly_fishtrade_profit
lab var weekly_fishtrade_profit "Average weekly profits from fish trading (sales minus purchases), summed across individuals"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_trading_revenue.dta", replace

use "${Tanzania_NPS_W2_raw_data}/FS_H2.dta", clear
ren fs_h06 weekly_costs_for_fish_trading_hs
recode weekly_costs_for_fish_trading_hs (.=0)
collapse (sum) weekly_costs_for_fish_trading_hs, by (y2_hhid)
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_trading_other_costs-1.dta", replace
use "${Tanzania_NPS_W2_raw_data}/FS_N2.dta", clear
ren fs_n06 weekly_costs_for_fish_trading_ls
recode weekly_costs_for_fish_trading_ls (.=0)
collapse (sum) weekly_costs_for_fish_trading_ls, by (y2_hhid)
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_trading_other_costs-1.dta"
drop _merge
gen weekly_costs_for_fish_trading = weekly_costs_for_fish_trading_hs + weekly_costs_for_fish_trading_ls
lab var weekly_costs_for_fish_trading "Weekly costs associated with fish trading, in addition to purchase of fish"
keep y2_hhid weekly_costs_for_fish_trading
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_trading_other_costs.dta", replace

use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_weeks_fish_trading.dta", clear
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_trading_revenue.dta" 
drop _merge
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_trading_other_costs.dta"
drop _merge
replace weekly_fishtrade_profit = weekly_fishtrade_profit - weekly_costs_for_fish_trading
gen fish_trading_income = (weeks_fish_trading * weekly_fishtrade_profit)
lab var fish_trading_income "Estimated net household earnings from fish trading over previous 12 months"
keep y2_hhid fish_trading_income
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_trading_income.dta", replace


********************************************************************************
*WAGE INCOME
********************************************************************************
use "${Tanzania_NPS_W2_raw_data}/HH_SEC_E1.dta", clear
ren hh_e04 wage_yesno
ren hh_e26 number_months
ren hh_e27 number_weeks
ren hh_e28 number_hours
ren hh_e22_1 most_recent_payment
replace most_recent_payment = . if (hh_e16_2 == 921 | hh_e16_2==611 | hh_e16_2==612 | hh_e16_2==613 | hh_e16_2==614 | hh_e16_2==621) 
ren hh_e22_2 payment_period
ren hh_e24_1 most_recent_payment_other
replace most_recent_payment_other = . if (hh_e16_2 == 921 | hh_e16_2==611 | hh_e16_2==612 | hh_e16_2==613 | hh_e16_2==614 | hh_e16_2==621) 
ren hh_e24_2 payment_period_other
ren hh_e29 secondary_wage_yesno
ren hh_e37_1 secwage_most_recent_payment
replace secwage_most_recent_payment = . if (hh_e31_2 == 921 | hh_e16_2==611 | hh_e16_2==612 | hh_e16_2==613 | hh_e16_2==614 | hh_e16_2==621) 
ren hh_e37_2 secwage_payment_period
ren hh_e39_1 secwage_recent_payment_other
ren hh_e39_2 secwage_payment_period_other
ren hh_e40 secwage_hours_pastweek
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
collapse (sum) annual_salary, by (y2_hhid)
lab var annual_salary "Annual earnings from non-agricultural wage"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_wage_income.dta", replace

*TASCO codes: 921 is an agricultural laborer.
*Gives slightly different response than hh_e21_2: What kind of trade or business is it connected with?


*Agwage
use "${Tanzania_NPS_W2_raw_data}/HH_SEC_E1.dta", clear
ren hh_e04 wage_yesno
ren hh_e26 number_months
ren hh_e27 number_weeks
ren hh_e28 number_hours
ren hh_e22_1 most_recent_payment
gen agwage = 1 if (hh_e16_2==921 | hh_e16_2==611 | hh_e16_2==612 | hh_e16_2==613 | hh_e16_2==614 | hh_e16_2==621)
replace agwage = 0 if hh_e16_2 != 921 & hh_e16_2 != 611 & hh_e16_2 != 612 & hh_e16_2 != 613 & hh_e16_2 != 614 & hh_e16_2 != 621
gen secagwage = 1 if (hh_e31_2==921 | hh_e31_2==611 | hh_e31_2==612 | hh_e31_2==613 | hh_e31_2==614 | hh_e31_2==621)
replace secagwage = 0 if hh_e16_2 != 921 & hh_e16_2 != 611 & hh_e16_2 != 612 & hh_e16_2 != 613 & hh_e16_2 != 614 & hh_e16_2 != 621
replace most_recent_payment = . if agwage!=1
ren hh_e22_2 payment_period
ren hh_e24_1 most_recent_payment_other
replace most_recent_payment_other = . if agwage!=1
ren hh_e24_2 payment_period_other
ren hh_e29 secondary_wage_yesno
ren hh_e37_1 secwage_most_recent_payment
replace secwage_most_recent_payment = . if secagwage!=1
ren hh_e37_2 secwage_payment_period
ren hh_e39_1 secwage_recent_payment_other
ren hh_e39_2 secwage_payment_period_other
ren hh_e40 secwage_hours_pastweek
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
collapse (sum) annual_salary, by (y2_hhid)
ren annual_salary annual_salary_agwage
lab var annual_salary_agwage "Estimated annual earnings from agricultural wage employment over previous 12 months"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_agwage_income.dta", replace


********************************************************************************
*OTHER INCOME
********************************************************************************
use "${Tanzania_NPS_W2_raw_data}/HH_SEC_Q.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/HH_SEC_O1.dta"
ren hh_q15 rental_income
ren hh_q16 pension_income
ren hh_q17 other_income
ren hh_q10 cash_received
ren hh_q13 inkind_gifts_received
ren hh_o03 assistance_cash
ren hh_o04 assistance_food
ren hh_o05 assistance_inkind
recode rental_income pension_income other_income cash_received inkind_gifts_received assistance_cash assistance_food assistance_inkind (.=0)
gen remittance_income = cash_received + inkind_gifts_received
gen assistance_income = assistance_cash + assistance_food + assistance_inkind 
collapse (sum) rental_income pension_income other_income remittance_income assistance_income, by (y2_hhid)
lab var rental_income "Estimated income from rentals of buildings, tools, land, transport animals over previous 12 months"
lab var pension_income "Estimated income from a pension AND INTEREST over previous 12 months"
lab var other_income "Estimated income from any OTHER source over previous 12 months"
lab var remittance_income "Estimated income from remittances over previous 12 months"
lab var assistance_income "Estimated income from a food aid, food-for-work, etc. over previous 12 months"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_other_income.dta", replace

use "${Tanzania_NPS_W2_raw_data}/AG_SEC3A.dta", clear
ren ag3a_04 land_rental_income_mainseason
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC3B.dta"
ren ag3b_04 land_rental_income_shortseason
recode land_rental_income_mainseason land_rental_income_shortseason (.=0)
gen land_rental_income = land_rental_income_mainseason + land_rental_income_shortseason
collapse (sum) land_rental_income, by (y2_hhid)
lab var land_rental_income "Estimated income from renting out land over previous 12 months"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_land_rental_income.dta", replace

*Other income
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_other_income.dta", clear
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_land_rental_income.dta"
egen other_income_sources = rowtotal (rental_income pension_income other_income remittance_income assistance_income land_rental_income)


********************************************************************************
*FARM SIZE / LAND SIZE
********************************************************************************
*Determining whether crops were grown on a plot
use "${Tanzania_NPS_W2_raw_data}/AG_SEC4A.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC4B.dta"
ren plotnum plot_id
drop if plot_id==""
drop if zaocode==.
gen crop_grown = 1 
collapse (max) crop_grown, by(y2_hhid plot_id)
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crops_grown.dta", replace

use "${Tanzania_NPS_W2_raw_data}/AG_SEC3A.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC3B.dta"
gen cultivated = (ag3a_03==1 | ag3b_03==1)

preserve 
use "${Tanzania_NPS_W2_raw_data}/AG_SEC6A.dta", clear
gen cultivated=1 if (ag6a_08!=. & ag6a_08!=0) | (ag6a_04!=. & ag6a_04!=0) // defining plots with fruit/permanent crops as cultivated if there was any harvest or if any trees were planted in the last 12 months
collapse (max) cultivated, by (y2_hhid plotnum)
drop if plotnum==""
tempfile fruit_tree
save `fruit_tree', replace
restore
append using `fruit_tree'

preserve 
use "${Tanzania_NPS_W2_raw_data}/AG_SEC6b.dta", clear
gen cultivated=1 if (ag6b_09!=. & ag6b_09!=0) | (ag6b_04!=. & ag6b_04!=0) //defining plots with fruit/permanant crops as cultivated if there was any harvest or if any trees were planted in the last 12 months
collapse (max) cultivated, by (y2_hhid plotnum)
drop if plotnum==""
tempfile perm_crop
save `perm_crop', replace
restore
append using `perm_crop'

ren plotnum plot_id
collapse (max) cultivated, by (y2_hhid plot_id)
lab var cultivated "1= Parcel was cultivated in this data set"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_parcels_cultivated.dta", replace

use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_parcels_cultivated.dta", clear
merge 1:1 y2_hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_areas.dta"
drop if _merge==2
keep if cultivated==1
replace area_acres_meas=. if area_acres_meas<0 
replace area_acres_meas = area_acres_est if area_acres_meas==. 
collapse (sum) area_acres_meas, by (y2_hhid)
ren area_acres_meas farm_area
replace farm_area = farm_area * (1/2.47105) /* Convert to hectares */
lab var farm_area "Land size (denominator for land productivitiy), in hectares" 
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_land_size.dta", replace

*All agricultural land
use "${Tanzania_NPS_W2_raw_data}/AG_SEC3A.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC3B.dta"
ren plotnum plot_id
drop if plot_id==""
merge m:1 y2_hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crops_grown.dta", nogen
gen rented_out = (ag3a_03==2 | ag3a_03==3 | ag3b_03==2 | ag3b_03==3)
gen cultivated_short = (ag3b_03==1)
bys y2_hhid plot_id: egen plot_cult_short = max(cultivated_short)
replace rented_out = 0 if plot_cult_short==1 // If cultivated in short season, not considered rented out in long season.
drop if rented_out==1 & crop_grown!=1
*110 obs dropped
gen agland = (ag3a_03==1 | ag3a_03==4 | ag3b_03==1 | ag3b_03==4)

preserve 
use "${Tanzania_NPS_W2_raw_data}/AG_SEC6A.dta", clear
gen cultivated=1 if (ag6a_09!=. & ag6a_09!=0) | (ag6a_04!=. & ag6a_04!=0) // defining plots with fruit/permanent crops as cultivated if there was any harvest or if any trees were planted in the last 12 months
collapse (max) cultivated, by (y2_hhid plotnum)
ren plotnum plot_id
tempfile fruit_tree
save `fruit_tree', replace
restore
append using `fruit_tree'
preserve 
use "${Tanzania_NPS_W2_raw_data}/AG_SEC6B.dta", clear
gen cultivated=1 if (ag6b_09!=. & ag6b_09!=0) | (ag6b_04!=. & ag6b_04!=0) //defining plots with fruit/permanant crops as cultivated if there was any harvest or if any trees were planted in the last 12 months
collapse (max) cultivated, by (y2_hhid plotnum)
ren plotnum plot_id
tempfile perm_crop
save `perm_crop', replace
restore
append using `perm_crop'
replace agland=1 if cultivated==1
drop if agland!=1 & crop_grown==.
collapse (max) agland, by (y2_hhid plot_id)
lab var agland "1= Parcel was used for crop cultivation or left fallow in this past year (forestland and other uses excluded)"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_parcels_agland.dta", replace

use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_parcels_agland.dta", clear
merge 1:1 y2_hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_areas.dta"
drop if _merge==2
replace area_acres_meas=. if area_acres_meas<0
replace area_acres_meas = area_acres_est if area_acres_meas==. 
replace area_acres_meas = area_acres_est if area_acres_meas==0 & (area_acres_est>0 & area_acres_est!=.)		
collapse (sum) area_acres_meas, by (y2_hhid)
ren area_acres_meas farm_size_agland
replace farm_size_agland = farm_size_agland * (1/2.47105) /* Convert to hectares */
lab var farm_size_agland "Land size in hectares, including all plots cultivated or left fallow" 
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_farmsize_all_agland.dta", replace

use "${Tanzania_NPS_W2_raw_data}/AG_SEC3A.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC3B.dta"
ren plotnum plot_id
drop if plot_id==""
gen rented_out = (ag3a_03==2 | ag3a_03==3 | ag3b_03==2 | ag3b_03==3)
gen cultivated_short = (ag3b_03==1)
bys y2_hhid plot_id: egen plot_cult_short = max(cultivated_short)
replace rented_out = 0 if plot_cult_short==1 // If cultivated in short season, not considered rented out in long season.
drop if rented_out==1
gen plot_held = 1
collapse (max) plot_held, by (y2_hhid plot_id)
lab var plot_held "1= Parcel was NOT rented out in the main season"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_parcels_held.dta", replace

use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_parcels_held.dta", clear
merge 1:1 y2_hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_areas.dta"
drop if _merge==2
replace area_acres_meas=. if area_acres_meas<0
replace area_acres_meas = area_acres_est if area_acres_meas==. 
collapse (sum) area_acres_meas, by (y2_hhid)
ren area_acres_meas land_size
replace land_size = land_size * (1/2.47105) /* Convert to hectares */
lab var land_size "Land size in hectares, including all plots listed by the household" 
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_land_size_all.dta", replace

*Total land holding including cultivated and rented out
use "${Tanzania_NPS_W2_raw_data}/AG_SEC3A.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC3B.dta"
ren plotnum plot_id
drop if plot_id==""
merge m:1 y2_hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_areas.dta", nogen keep(1 3)
replace area_acres_meas=. if area_acres_meas<0
replace area_acres_meas = area_acres_est if area_acres_meas==. 
replace area_acres_meas = area_acres_est if area_acres_meas==0 & (area_acres_est>0 & area_acres_est!=.)		
collapse (max) area_acres_meas, by(y2_hhid plot_id)
ren area_acres_meas land_size_total
collapse (sum) land_size_total, by(y2_hhid)
replace land_size_total = land_size_total * (1/2.47105) /* Convert to hectares */
lab var land_size_total "Total land size in hectares, including rented in and rented out plots"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_land_size_total.dta", replace


********************************************************************************
*OFF-FARM HOURS
********************************************************************************
use "${Tanzania_NPS_W2_raw_data}/HH_SEC_E1.dta", clear
*Start with first wage job; no agriculture (which also includes mining/livestock)
gen primary_hours = hh_e25 if hh_e17_2>9 & hh_e17_2!=.		// hh_e17_2<9 is ag/mining
gen secondary_hours = hh_e40 if hh_e31_2>9 & hh_e31_2!=.
gen ownbiz_hours =  hh_e75
egen off_farm_hours = rowtotal(primary_hours secondary_hours ownbiz_hours)
gen off_farm_any_count = off_farm_hours!=0
gen member_count = 1

collapse (sum) off_farm_hours off_farm_any_count member_count, by(y2_hhid)
la var member_count "Number of HH members age 5 or above"
la var off_farm_any_count "Number of HH members with positive off-farm hours"
la var off_farm_hours "Total household off-farm hours"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_off_farm_hours.dta", replace


********************************************************************************
*FARM LABOR
********************************************************************************
*Farm labor
use "${Tanzania_NPS_W2_raw_data}/AG_SEC3A.dta", clear
ren ag3a_72_1 landprep_women 
ren ag3a_72_2 landprep_men 
ren ag3a_72_21 landprep_child 
ren ag3a_72_4 weeding_women 
ren ag3a_72_5 weeding_men 
ren ag3a_72_51 weeding_child 
ren ag3a_72_61 nonharvest_men
ren ag3a_72_62 nonharvest_women
ren ag3a_72_63 nonharvest_child
ren ag3a_72_7 harvest_women 
ren ag3a_72_8 harvest_men 
ren ag3a_72_81 harvest_child
recode landprep_women landprep_men landprep_child weeding_men weeding_women weeding_child nonharvest_men nonharvest_women nonharvest_child harvest_men harvest_women harvest_child (.=0)
egen days_hired_mainseason = rowtotal(landprep_women landprep_men landprep_child weeding_men weeding_women weeding_child nonharvest_men nonharvest_women nonharvest_child harvest_men harvest_women harvest_child) 
recode ag3a_70_1 ag3a_70_2 ag3a_70_3 ag3a_70_4 ag3a_70_5 ag3a_70_6 (.=0)
egen days_flab_landprep = rowtotal(ag3a_70_1 ag3a_70_2 ag3a_70_3 ag3a_70_4 ag3a_70_5 ag3a_70_6)
recode  ag3a_70_13 ag3a_70_14 ag3a_70_15 ag3a_70_16 ag3a_70_17 ag3a_70_18 (.=0)
egen days_flab_weeding = rowtotal( ag3a_70_13 ag3a_70_14 ag3a_70_15 ag3a_70_16 ag3a_70_17 ag3a_70_18)
recode ag3a_70_37 ag3a_70_38 ag3a_70_39 ag3a_70_40 ag3a_70_41 ag3a_70_42 (.=0)
egen days_flab_nonharvest = rowtotal (ag3a_70_37 ag3a_70_38 ag3a_70_39 ag3a_70_40 ag3a_70_41 ag3a_70_42)
recode ag3a_70_25 ag3a_70_26 ag3a_70_27 ag3a_70_28 ag3a_70_29 ag3a_70_30 (.=0)
egen days_flab_harvest = rowtotal(ag3a_70_25 ag3a_70_26 ag3a_70_27 ag3a_70_28 ag3a_70_29 ag3a_70_30)
gen days_famlabor_mainseason = days_flab_landprep + days_flab_weeding + days_flab_harvest
*labor productivity at the plot level
ren plotnum plot_id
collapse (sum) days_hired_mainseason days_famlabor_mainseason, by (y2_hhid plot_id)
lab var days_hired_mainseason  "Workdays for hired labor (crops) in main growing season"
lab var days_famlabor_mainseason  "Workdays for family labor (crops) in main growing season"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_farmlabor_mainseason.dta", replace

use "${Tanzania_NPS_W2_raw_data}/AG_SEC3B.dta", clear
ren ag3b_72_1 landprep_women 
ren ag3b_72_2 landprep_men 
ren ag3b_72_21 landprep_child 
ren ag3b_72_4 weeding_women 
ren ag3b_72_5 weeding_men 
ren ag3b_72_51 weeding_child 
ren ag3b_72_61 nonharvest_men
ren ag3b_72_62 nonharvest_women
ren ag3b_72_63 nonharvest_child
ren ag3b_72_8 harvest_men 
ren ag3b_72_7 harvest_women 
ren ag3b_72_81 harvest_child
recode landprep_women landprep_men landprep_child weeding_men weeding_women weeding_child nonharvest_men nonharvest_women nonharvest_child harvest_men harvest_women harvest_child (.=0)
egen days_hired_shortseason = rowtotal(landprep_women landprep_men landprep_child weeding_men weeding_women weeding_child nonharvest_men nonharvest_women nonharvest_child harvest_men harvest_women harvest_child) 
recode ag3b_70_1 ag3b_70_2 ag3b_70_3 ag3b_70_4 ag3b_70_5 ag3b_70_6 (.=0)
egen days_flab_landprep = rowtotal(ag3b_70_1 ag3b_70_2 ag3b_70_3 ag3b_70_4 ag3b_70_5 ag3b_70_6)
recode ag3b_70_13 ag3b_70_14 ag3b_70_15 ag3b_70_16 ag3b_70_17 ag3b_70_18 (.=0)
egen days_flab_weeding = rowtotal(ag3b_70_13 ag3b_70_14 ag3b_70_15 ag3b_70_16 ag3b_70_17 ag3b_70_18)
recode ag3b_70_37 ag3b_70_38 ag3b_70_39 ag3b_70_40 ag3b_70_41 ag3b_70_42 (.=0)
egen days_flab_nonharvest = rowtotal(ag3b_70_37 ag3b_70_38 ag3b_70_39 ag3b_70_40 ag3b_70_41 ag3b_70_42)
recode ag3b_70_25 ag3b_70_26 ag3b_70_27 ag3b_70_28 ag3b_70_29 ag3b_70_30 (.=0)
egen days_flab_harvest = rowtotal(ag3b_70_25 ag3b_70_26 ag3b_70_27 ag3b_70_28 ag3b_70_29 ag3b_70_30)
gen days_famlabor_shortseason = days_flab_landprep + days_flab_weeding + days_flab_harvest
*labor productivity at the plot level
ren plotnum plot_id
collapse (sum) days_hired_shortseason days_famlabor_shortseason, by (y2_hhid plot_id)
lab var days_hired_shortseason  "Workdays for hired labor (crops) in short growing season"
lab var days_famlabor_shortseason  "Workdays for family labor (crops) in short growing season"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_farmlabor_shortseason.dta", replace

*Labor
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_farmlabor_mainseason.dta", clear
merge 1:1 y2_hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_farmlabor_shortseason.dta"
drop _merge
recode days*  (.=0)
collapse (sum) days*, by(y2_hhid plot_id)
egen labor_hired =rowtotal(days_hired_mainseason days_hired_shortseason)
egen labor_family=rowtotal(days_famlabor_mainseason  days_famlabor_shortseason)
egen labor_total = rowtotal(days_hired_mainseason days_famlabor_mainseason days_hired_shortseason days_famlabor_shortseason)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm"
lab var labor_hired "Total labor days (hired) allocated to the farm"
lab var labor_family "Total labor days (family) allocated to the farm"
lab var labor_total "Total labor days allocated to the farm"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_family_hired_labor.dta", replace

collapse (sum) labor_*, by(y2_hhid)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm"
lab var labor_hired "Total labor days (hired) allocated to the farm"
lab var labor_family "Total labor days (family) allocated to the farm"
lab var labor_total "Total labor days allocated to the farm" 
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_family_hired_labor.dta", replace

********************************************************************************
*VACCINE USAGE
********************************************************************************
use "${Tanzania_NPS_W2_raw_data}/AG_SEC10A.dta", clear
gen vac_animal=.
replace vac_animal=1 if ag10a_38==1 | ag10a_38==2
replace vac_animal=0 if ag10a_38==3
replace vac_animal=. if ag10a_38==.
replace vac_animal=. if lvstkcode==14 //dogs aren't counted as TLUs
replace vac_animal = . if ag10a_02==2 | ag10a_02==. // missing if the household did now own any of these types of animals 
*Disagregating vaccine usage by animal type 
ren lvstkcode livestock_code
gen species = (inlist(livestock_code,1,2,3,4,5,6)) + 2*(inlist(livestock_code,7,8)) + 3*(livestock_code==9) + 4*(livestock_code==13) + 5*(inlist(livestock_code,10,11))
recode species (0=.)
la def species 1 "Large ruminants (cows, buffalos)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses)" 5 "Poultry"
la val species species
*A loop to create species variables
foreach i in vac_animal {
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==2
	gen `i'_pigs = `i' if species==3
	gen `i'_equine = `i' if species==4
	gen `i'_poultry = `i' if species==5
}
collapse (max) vac_animal*, by (y2_hhid)
lab var vac_animal "1= Household has an animal vaccinated"
foreach i in vac_animal {
	local l`i' : var lab `i'
	lab var `i'_lrum "`l`i'' - large ruminants"
	lab var `i'_srum "`l`i'' - small ruminants"
	lab var `i'_pigs "`l`i'' - pigs"
	lab var `i'_equine "`l`i'' - equine"
	lab var `i'_poultry "`l`i'' - poultry"
}
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_vaccine.dta", replace
 
use "${Tanzania_NPS_W2_raw_data}/AG_SEC10A.dta", clear
gen all_vac_animal=.
replace all_vac_animal=1 if ag10a_38==1 | ag10a_38==2
replace all_vac_animal=0 if ag10a_38==3
replace all_vac_animal=. if ag10a_38==.
replace all_vac_animal=. if lvstkcode==14 //dogs aren't counted as TLUs
replace all_vac_animal = . if ag10a_02==2 | ag10a_02==. // missing if the household did now own any of these types of animals 
preserve
keep y2_hhid ag10a_29_1 all_vac_animal 
ren ag10a_29_1 farmerid
tempfile farmer1
save `farmer1'
restore
preserve
keep y2_hhid  ag10a_29_2  all_vac_animal 
ren ag10a_29_2 farmerid
tempfile farmer2
save `farmer2'
restore
use   `farmer1', replace
append using  `farmer2'
collapse (max) all_vac_animal , by(y2_hhid farmerid)
gen personid=farmerid
drop if personid==.
merge 1:1 y2_hhid personid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_gender_merge.dta", nogen
lab var all_vac_animal "1 = Individual farmer (livestock keeper) uses vaccines"
ren personid indidy2
gen livestock_keeper=1 if farmerid!=.
recode livestock_keeper (.=0)
lab var livestock_keeper "1=Indvidual is listed as a livestock keeper (at least one type of livestock)" 
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_farmer_vaccine.dta", replace


********************************************************************************
*ANIMAL HEALTH - DISEASES
********************************************************************************
use "${Tanzania_NPS_W2_raw_data}/AG_SEC10A.dta", clear
gen disease_animal = 1 if (ag10a_37_1!=23 | ag10a_37_2!=23 |  ag10a_37_3!=23 |  ag10a_37_4!=23 ) 
replace disease_animal = 0 if (ag10a_37_1==23)
replace disease_animal = . if (ag10a_37_1==. & ag10a_37_2==. & ag10a_37_3==. & ag10a_37_4==.) 
gen disease_fmd = (ag10a_37_1==7 | ag10a_37_2==7 | ag10a_37_3==7 | ag10a_37_4==7 )
gen disease_lump = (ag10a_37_1==3 | ag10a_37_2==3 | ag10a_37_3==3 | ag10a_37_4==3 )
gen disease_bruc = (ag10a_37_1==1 | ag10a_37_2==1 | ag10a_37_3==1 | ag10a_37_4==1 )
gen disease_cbpp = (ag10a_37_1==2 | ag10a_37_2==2 | ag10a_37_3==2 | ag10a_37_4==2 )
gen disease_bq = (ag10a_37_1==9 | ag10a_37_2==9 | ag10a_37_3==9 | ag10a_37_4==9 )
ren lvstkcode livestock_code
gen species = (inlist(livestock_code,1)) + 2*(inlist(livestock_code,2)) + 3*(livestock_code==3) + 4*(livestock_code==5) + 5*(inlist(livestock_code,4))
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
collapse (max) disease_*, by (y2_hhid)
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
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_diseases.dta", replace

********************************************************************************
*LIVESTOCK WATER, FEEDING, AND HOUSING
********************************************************************************
**cannot construct

********************************************************************************
*USE OF INORGANIC FERTILIZER
********************************************************************************
use "${Tanzania_NPS_W2_raw_data}/AG_SEC3A.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC3B.dta" 
gen use_inorg_fert=.
replace use_inorg_fert=0 if ag3a_45==2 | ag3b_45==2 | ag3a_52==2 | ag3b_52==2
replace use_inorg_fert=1 if ag3a_45==1 | ag3b_45==1 | ag3a_52==1 | ag3b_52==1
recode use_inorg_fert (.=0)
collapse (max) use_inorg_fert, by (y2_hhid)
lab var use_inorg_fert "1 = Household uses inorganic fertilizer"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fert_use.dta", replace

use "${Tanzania_NPS_W2_raw_data}/AG_SEC3A.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC3B.dta" 
gen all_use_inorg_fert=(ag3a_45==1 | ag3b_45==1 | ag3a_52==1 | ag3b_52==1 )
preserve
keep y2_hhid ag3a_08_1 ag3b_08_1 all_use_inorg_fert 
ren ag3a_08_1 farmerid
replace farmerid= ag3b_08_1 if farmerid==.
tempfile farmer1
save `farmer1'
restore
preserve
keep y2_hhid ag3a_08_2 ag3b_08_2  all_use_inorg_fert 
ren ag3a_08_2 farmerid
replace farmerid= ag3b_08_2 if farmerid==.
tempfile farmer2
save `farmer2'
restore
preserve
keep y2_hhid ag3a_08_3 ag3b_08_3 all_use_inorg_fert 
ren ag3a_08_3 farmerid
replace farmerid= ag3b_08_3 if farmerid==.		
tempfile farmer3
save `farmer3'
restore

use   `farmer1', replace
append using  `farmer2'
append using  `farmer3'
collapse (max) all_use_inorg_fert , by(y2_hhid farmerid)
gen personid=farmerid
drop if personid==.
merge 1:1 y2_hhid personid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_gender_merge.dta", nogen

lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
ren personid indidy2
gen farm_manager=1 if farmerid!=.
recode farm_manager (.=0)
lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_farmer_fert_use.dta", replace 
  
 
********************************************************************************
*USE OF IMPROVED SEED
********************************************************************************
use "${Tanzania_NPS_W2_raw_data}/AG_SEC4A.dta", clear 
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC4B.dta" 
gen imprv_seed_use =. 
replace imprv_seed_use = 0 if ag4a_23 == 1 | ag4b_23 == 1
replace imprv_seed_use = 1 if ag4a_23 == 2 | ag4b_23 == 2
recode imprv_seed_use (.=0)
forvalues k=1/$nb_topcrops {
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	gen imprv_seed_`cn'=imprv_seed_use if zaocode==`c'
	gen hybrid_seed_`cn'=.
}
collapse (max) imprv_seed_* hybrid_seed_*, by(y2_hhid)
lab var imprv_seed_use "1 = Household uses improved seed"
foreach v in $topcropname_area {
	lab var imprv_seed_`v' "1= Household uses improved `v' seed"
	lab var hybrid_seed_`v' "1= Household uses improved `v' seed"
}
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_improvedseed_use.dta", replace

*Seed adoption by farmers ( a farmer is an individual listed as plot manager)
use "${Tanzania_NPS_W2_raw_data}/AG_SEC4A.dta", clear 
merge m:1 y2_hhid plotnum using  "${Tanzania_NPS_W2_raw_data}/AG_SEC3A.dta", nogen keep(1 3)
preserve
use "${Tanzania_NPS_W2_raw_data}/AG_SEC4B.dta"  , clear
merge m:1 y2_hhid plotnum using  "${Tanzania_NPS_W2_raw_data}/AG_SEC3B.dta", nogen keep(1 3)
tempfile seedb
save `seedb'
restore
append using `seedb' 
gen imprv_seed_use=.
replace imprv_seed_use=1 if ag4a_23 == 2 | ag4b_23 == 2
replace imprv_seed_use=0 if ag4a_23 == 1 | ag4b_23 == 1
recode imprv_seed_use (.=0)
ren imprv_seed_use all_imprv_seed_use
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_farmer_improvedseed_use_temp.dta", replace

*adding other crops 
forvalues k=1/$nb_topcrops {
	use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_farmer_improvedseed_use_temp.dta", clear
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	*Adding adoption of improved maize seeds
	gen all_imprv_seed_`cn'=all_imprv_seed_use if zaocode==`c'  
	gen all_hybrid_seed_`cn' =. 
	*We also need a variable that indicates if farmer (plot manager) grows maize
	gen `cn'_farmer= zaocode==`c' 
	preserve
	keep y2_hhid ag3a_08_1 ag3b_08_1 all_imprv_seed_use all_imprv_seed_`cn' all_hybrid_seed_`cn' `cn'_farmer  
	ren ag3a_08_1 farmerid
	replace farmerid= ag3b_08_1 if farmerid==.
	tempfile farmer1
	save `farmer1'
	restore
	preserve
	keep y2_hhid ag3a_08_2 ag3b_08_2 all_imprv_seed_use all_imprv_seed_`cn' all_hybrid_seed_`cn' `cn'_farmer  
	ren ag3a_08_2 farmerid
	replace farmerid= ag3b_08_2 if farmerid==.
	tempfile farmer2
	save `farmer2'
	restore
	preserve
	keep y2_hhid ag3a_08_3 ag3b_08_3 all_imprv_seed_use all_imprv_seed_`cn' all_hybrid_seed_`cn' `cn'_farmer  
	ren ag3a_08_3 farmerid
	replace farmerid= ag3b_08_3 if farmerid==.		 
	tempfile farmer3
	save `farmer3'
	restore
	
	use   `farmer1', replace
	append using  `farmer2'
	append using  `farmer3'
	collapse (max) all_imprv_seed_use  all_imprv_seed_`cn' all_hybrid_seed_`cn'  `cn'_farmer, by (y2_hhid farmerid)
	save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_farmer_improvedseed_use_temp_`cn'.dta", replace
}

*Combining all together
foreach v in $topcropname_area {
	merge 1:1 y2_hhid farmerid all_imprv_seed_use using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_farmer_improvedseed_use_temp_`v'.dta", nogen
}
	
//collapse (max) all_imprv_seed_use all_imprv_seed_maize all_hybrid_seed_maize  maize_farmer, by (y2_hhid farmerid)
gen personid=farmerid
drop if personid==.
merge 1:1 y2_hhid personid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_gender_merge.dta", nogen
lab var all_imprv_seed_use "1 = Individual farmer (plot manager) uses improved seeds"
foreach v in $topcropname_area {
	lab var all_imprv_seed_`v' "1 = Individual farmer (plot manager) uses improved seeds - `v'"
	lab var all_hybrid_seed_`v' "1 = Individual farmer (plot manager) uses hybrid seeds - `v'"
	lab var `v'_farmer "1 = Individual farmer (plot manager) grows `v'"
}
ren personid indidy2
gen farm_manager=1 if farmerid!=.
recode farm_manager (.=0)
lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_farmer_improvedseed_use.dta", replace

********************************************************************************
*REACHED BY AG EXTENSION
********************************************************************************
*public: government
use "${Tanzania_NPS_W2_raw_data}/AG_SEC12B.dta", clear
ren ag12b_07 receive_advice
ren ag12b_0a sourceid
preserve
use "${Tanzania_NPS_W2_raw_data}/AG_SEC12A.dta", clear
ren ag12a_01 receive_advice
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
collapse (max) ext_reach_* , by (y2_hhid)
lab var ext_reach_all "1 = Household reached by extensition services - all sources"
lab var ext_reach_public "1 = Household reached by extensition services - public sources"
lab var ext_reach_private "1 = Household reached by extensition services - private sources"
lab var ext_reach_unspecified "1 = Household reached by extensition services - unspecified sources"
lab var ext_reach_ict "1 = Household reached by extensition services through ICT"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_any_ext.dta", replace
 
 
********************************************************************************
*USE OF FORMAL FINANACIAL SERVICES
********************************************************************************
use "${Tanzania_NPS_W2_raw_data}/HH_SEC_P.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/HH_SEC_Q.dta" 
gen borrow_bank= hh_p03==1
gen borrow_micro=hh_p03==2
gen borrow_mortgage=hh_p03==3
gen borrow_insurance=hh_p03==4
gen borrow_other_fin=hh_p03==5
gen borrow_neigh=hh_p03==6
gen borrow_employer=hh_p03==9
gen borrow_ngo=hh_p03==11
gen use_bank_acount=hh_q18==1
gen use_MM=hh_q01_1==1 | hh_q01_2==1 | hh_q01_3==1 //use any MM services
gen use_fin_serv_bank= use_bank_acount==1
gen use_fin_serv_credit= borrow_mortgage==1 | borrow_bank==1  | borrow_other_fin==1
gen use_fin_serv_insur= borrow_insurance==1
gen use_fin_serv_digital=use_MM==1
gen use_fin_serv_others= borrow_other_fin==1
gen use_fin_serv_all=use_fin_serv_bank==1 | use_fin_serv_credit==1 | use_fin_serv_insur==1 | use_fin_serv_digital==1 |  borrow_other_fin==1
recode use_fin_serv* (.=0)
collapse (max) use_fin_serv_*, by (y2_hhid)
lab var use_fin_serv_all "1= Household uses formal financial services - all types"
lab var use_fin_serv_bank "1= Household uses formal financial services - bank accout"
lab var use_fin_serv_credit "1= Household uses formal financial services - credit"
lab var use_fin_serv_insur "1= Household uses formal financial services - insurance"
lab var use_fin_serv_digital "1= Household uses formal financial services - digital"
lab var use_fin_serv_others "1= Household uses formal financial services - others"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fin_serv.dta", replace
 
********************************************************************************
*MILK PRODUCTIVITY
********************************************************************************
*Total production
use "${Tanzania_NPS_W2_raw_data}/AG_SEC10B.dta", clear
keep if itemcode == 1 | itemcode == 2		// keeping milk only
gen months_milked = ag10b_02			// average months milked in last year (by holder)
gen liters_month = ag10b_03_1			// average quantity (liters) per day (questionnaire sounds like this question is TOTAL, not per head)
gen liters_milk_produced=months_milked*liters_month 
collapse (sum) liters_milk_produced, by (y2_hhid)
lab var liters_milk_produced "Total quantity (liters) of milk per year (household)"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_milk_animals.dta", replace

********************************************************************************
*EGG PRODUCTIVITY
********************************************************************************
*Have to get total owned poultry and then number of eggs
use "${Tanzania_NPS_W2_raw_data}/AG_SEC10B.dta", clear
keep if itemcode == 3 | itemcode == 4		// keeping eggs only
drop if ag10b_01 == 2
gen eggs_months = ag10b_02	// number of months eggs were produced
gen eggs_per_month = ag10b_03_1 			
gen eggs_total_year = eggs_month*eggs_per_month			// eggs per month times number of months produced in last 12 months
collapse (sum) eggs_total_year, by (y2_hhid) 
lab var eggs_total_year "Total number of eggs that was produced (household)"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_eggs_animals.dta", replace


********************************************************************************
*CROP PRODUCTION COSTS PER HECTARE
********************************************************************************
*Constructed using both implicit and explicit costs and only main rainy season (meher)
*NOTE: There's some overlap with crop production expenses above, but this is because the variables were created separately.

*Land rental rates*
*  LRS  *
use "${Tanzania_NPS_W2_raw_data}/AG_SEC2A.dta", clear
drop if plotnum==""
gen plot_ha = ag2a_09/2.47105							// ag2a_09 is GPS-measured area in acres
replace plot_ha = ag2a_04/2.47105 if plot_ha==.			// replace with farmer-reported if missing (also in acres)
keep plot_ha plotnum y2_hhid
ren plotnum plot_id
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_area_lrs.dta", replace
*Getting plot rental rate
use "${Tanzania_NPS_W2_raw_data}/AG_SEC3A.dta", clear
ren plotnum plot_id
merge 1:1 plot_id y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_area_lrs.dta" , nogen		
drop if plot_id==""
gen cultivated = ag3a_03==1
merge m:1 y2_hhid plot_id using  "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_decision_makers.dta", nogen keep (1 3)
*Total rent - rescaling to a YEARLY value
tab ag3a_33_1 ag3a_33_2, nol
gen plot_rental_rate = ag3a_32*(12/ag3a_33_1) if ag3a_33_2==1			// if monthly (scaling up by number of months; all observations are <=12)
replace plot_rental_rate = ag3a_32*(1/ag3a_33_1) if ag3a_33_2==2		// if yearly (scaling down by number of years; all observations are >=1)
recode plot_rental_rate (0=.) 
keep y2_hhid plot_id cultivated dm_gender plot_ha plot_rental_rate ag3a_32
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_rent_nomiss_lrs.dta", replace					

preserve
gen value_rented_land_male = plot_rental_rate if dm_gender==1
gen value_rented_land_female = plot_rental_rate if dm_gender==2
gen value_rented_land_mixed = plot_rental_rate if dm_gender==3
collapse (sum) value_rented_land_* value_rented_land = plot_rental_rate, by(y2_hhid)
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_rental_rate_lrs.dta", replace
restore

gen ha_rental_rate_hh = plot_rental_rate/plot_ha
recode ha_rental_rate_hh (0=.) 
preserve
keep if plot_rental_rate!=. & plot_rental_rate!=0			// keeping only plots that were rented (not zero and not missing)
collapse (sum) plot_rental_rate plot_ha, by(y2_hhid)		// summing to household level (only plots that were rented)
gen ha_rental_hh_lrs = plot_rental_rate/plot_ha				// household specific rental rate
keep ha_rental_hh_lrs y2_hhid
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_rental_rate_hhid_lrs.dta", replace
restore

*Merging in geographic variables
merge m:1 y2_hhid using "${Tanzania_NPS_W2_raw_data}/HH_SEC_A.dta", nogen assert(2 3) keep(3)		// some not matched from USING; dropping these
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
collapse (firstnm) ha_rental_rate, by(region district ward ea)
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_rental_rate_lrs.dta", replace

*  SRS  *
use "${Tanzania_NPS_W2_raw_data}/AG_SEC2B.dta", clear
drop if plotnum==""
gen plot_ha = ag2b_20/2.47105						// ag2a_09 is GPS-measured area in acres
replace plot_ha = ag2b_15/2.47105 if plot_ha==.		// replacing with farmer-reported if missing
keep plot_ha plotnum y2_hhid
ren plotnum plot_id
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_area_srs.dta", replace
*Getting plot rental rate
use "${Tanzania_NPS_W2_raw_data}/AG_SEC3B.dta", clear
drop if plotnum==""
gen cultivated = ag3b_03==1
ren  plotnum plot_id
merge m:1 y2_hhid plot_id using  "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_decision_makers.dta", nogen 
merge 1:1 plot_id y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_area_lrs.dta", nogen					
merge 1:1 plot_id y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_area_srs.dta", nogen update replace		
*Total rent - rescaling to a YEARLY value
tab ag3b_33_1 ag3b_33_2, nol					
gen plot_rental_rate = ag3b_32*(12/ag3b_33_1) if ag3b_33_2==1			// if monthly (scaling up by number of months)
replace plot_rental_rate = ag3b_32*(1/ag3b_33_1) if ag3b_33_2==2		// if yearly (scaling down by number of years)
recode plot_rental_rate (0=.) 
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_rent_nomiss_srs.dta", replace
preserve
gen value_rented_land_male = plot_rental_rate if dm_gender==1
gen value_rented_land_female = plot_rental_rate if dm_gender==2
gen value_rented_land_mixed = plot_rental_rate if dm_gender==3
collapse (sum) value_rented_land_* value_rented_land = plot_rental_rate, by(y2_hhid)
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_rental_rate_srs.dta", replace
restore
gen ha_rental_rate_hh = plot_rental_rate/plot_ha
recode ha_rental_rate_hh (0=.) 

preserve
keep if plot_rental_rate!=. & plot_rental_rate!=0			// keeping only plots that were rented (not zero and not missing)
collapse (sum) plot_rental_rate plot_ha, by(y2_hhid)		// summing to household level (only plots that were rented)
gen ha_rental_hh_srs = plot_rental_rate/plot_ha				// household specific rental rate
keep ha_rental_hh_srs y2_hhid
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_rental_rate_hhid_srs.dta", replace
restore
*Merging in geographic variables
merge m:1 y2_hhid using "${Tanzania_NPS_W2_raw_data}/HH_SEC_A.dta", nogen assert(2 3) keep(3)	
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
collapse (firstnm) ha_rental_rate_srs = ha_rental_rate, by(region district ward ea)
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_rental_rate_srs.dta", replace

*Now getting total ha of all plots that were cultivated at least once
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_rent_nomiss_lrs.dta", clear
append using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_rent_nomiss_srs.dta"
collapse (max) cultivated plot_ha, by(y2_hhid plot_id)		// collapsing down to household-plot level
gen ha_cultivated_plots = plot_ha if cultivate==1			// non-missing only if plot was cultivated in at least one season
collapse (sum) ha_cultivated_plots, by(y2_hhid)				// total ha of all plots that were cultivated in at least one season
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_cultivated_plots_ha.dta", replace

use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_rental_rate_lrs.dta", clear
append using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_rental_rate_srs.dta"
collapse (sum) value_rented_land*, by(y2_hhid)		// total over BOTH seasons (total spent on rent over course of entire year)
lab var value_rented_land "Value of rented land (household expenditures)"
lab var value_rented_land_male "Value of rented land (household expenditures - male-managed plots)"
lab var value_rented_land_female "Value of rented land (household expenditures - female-managed plots)"
lab var value_rented_land_mixed "Value of rented land (household expenditures - mixed-managed plots)"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_rental_rate.dta", replace

*Now getting area planted
*  LRS  *
use "${Tanzania_NPS_W2_raw_data}/AG_SEC4A.dta", clear
drop if plotnum==""
ren  plotnum plot_id
merge m:1 y2_hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_rent_nomiss_lrs.dta", nogen keep(1 3)
*First rescaling
gen percent_plot = 0.25*(ag4a_02==1) + 0.5*(ag4a_02==2) + 0.75*(ag4a_02==3)
replace percent_plot = 1 if ag4a_01==1
bys y2_hhid plot_id: egen total_percent_plot = total(percent_plot)		// total "percent" of plot planted
replace percent_plot = percent_plot*(1/total_percent_plot) if total_percent_plot>1 & total_percent_plot!=.	// rescaling (down) if total percent is larger than 1
*Merging in total plot area from previous module
merge m:1 plot_id y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_area_lrs", nogen assert(2 3) keep(3)	
gen ha_planted = percent_plot*plot_ha
gen ha_planted_male = ha_planted if dm_gender==1
gen ha_planted_female = ha_planted if dm_gender==2
gen ha_planted_mixed = ha_planted if dm_gender==3
*Merging in geographic variables
merge m:1 y2_hhid using "${Tanzania_NPS_W2_raw_data}/HH_SEC_A.dta", nogen assert(2 3) keep(3)	
*Now merging in aggregate rental costs
merge m:1 region district ward ea using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_rental_rate_lrs", nogen assert(2 3) keep(3)		
*Now merging in rental costs of individual plots
merge m:1 y2_hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_rent_nomiss_lrs.dta", nogen keep(1 3)
*Now merging in household rental rate
merge m:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_rental_rate_hhid_lrs.dta", nogen keep(1 3)
gen value_owned_land = ha_planted*ha_rental_rate if ag3a_32==0 | ag3a_32==.		
replace value_owned_land = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (ag3a_32==0 | ag3a_32==.)		
*Now creating gender value
gen value_owned_land_male = ha_planted*ha_rental_rate if (ag3a_32==0 | ag3a_32==.) & dm_gender==1
replace value_owned_land_male = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (ag3a_32==0 | ag3a_32==.) & dm_gender==1
*Female
gen value_owned_land_female = ha_planted*ha_rental_rate if (ag3a_32==0 | ag3a_32==.) & dm_gender==2
replace value_owned_land_female = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (ag3a_32==0 | ag3a_32==.) & dm_gender==2
*Mixed
gen value_owned_land_mixed = ha_planted*ha_rental_rate if (ag3a_32==0 | ag3a_32==.) & dm_gender==3
replace value_owned_land_mixed = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (ag3a_32==0 | ag3a_32==.) & dm_gender==3
collapse (sum) value_owned_land* ha_planted*, by(y2_hhid plot_id)			// summing ha_planted across crops on same plot
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_cost_land_lrs.dta", replace

*  SRS  *
*Now getting area planted
use "${Tanzania_NPS_W2_raw_data}/AG_SEC4B.dta", clear
drop if plotnum==""
ren plotnum plot_id 
merge m:1 y2_hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_rent_nomiss_lrs.dta", nogen keep(1 3) keepusing(dm_gender)
merge m:1 y2_hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_rent_nomiss_srs.dta", nogen keep(1 3) keepusing(dm_gender) update
*First rescaling
gen percent_plot = 0.25*(ag4b_02==1) + 0.5*(ag4b_02==2) + 0.75*(ag4b_02==3)
replace percent_plot = 1 if ag4b_01==1
bys y2_hhid plot_id: egen total_percent_plot = total(percent_plot)
replace percent_plot = percent_plot*(1/total_percent_plot) if total_percent_plot>1 & total_percent_plot!=.	// rescaling if total percent is larger than 1
*Merging in total plot area
merge m:1 plot_id y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_area_lrs", nogen keep(1 3) keepusing(plot_ha)	
merge m:1 plot_id y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_area_srs", nogen keepusing(plot_ha) update	
gen ha_planted = percent_plot*plot_ha
gen ha_planted_male = ha_planted if dm_gender==1
gen ha_planted_female = ha_planted if dm_gender==2
gen ha_planted_mixed = ha_planted if dm_gender==3
*Merging in geographic variables
merge m:1 y2_hhid using "${Tanzania_NPS_W2_raw_data}/HH_SEC_A.dta", nogen assert(2 3) keep(3)	
*Now merging in rental costs
merge m:1 region district ward ea using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_rental_rate_lrs", nogen assert(2 3) keep(3)			
*Now merging in rental costs actually incurred by household
merge m:1 y2_hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_rent_nomiss_lrs.dta", nogen keep(1 3)
*Now merging in household rental rate
merge m:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_rental_rate_hhid_lrs.dta", nogen keep(1 3)		
merge m:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_rental_rate_hhid_srs.dta", nogen	update			
gen value_owned_land = ha_planted*ha_rental_rate if ag3a_32==0 | ag3a_32==.	
replace value_owned_land = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (ag3a_32==0 | ag3a_32==.)		
*Now creating gender value
gen value_owned_land_male = ha_planted*ha_rental_rate if (ag3a_32==0 | ag3a_32==.) & dm_gender==1
replace value_owned_land_male = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (ag3a_32==0 | ag3a_32==.) & dm_gender==1
*Female
gen value_owned_land_female = ha_planted*ha_rental_rate if (ag3a_32==0 | ag3a_32==.) & dm_gender==2
replace value_owned_land_female = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (ag3a_32==0 | ag3a_32==.) & dm_gender==2
*Mixed
gen value_owned_land_mixed = ha_planted*ha_rental_rate if (ag3a_32==0 | ag3a_32==.) & dm_gender==3
replace value_owned_land_mixed = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (ag3a_32==0 | ag3a_32==.) & dm_gender==3

collapse (sum) value_owned_land* ha_planted*, by(y2_hhid plot_id)			// summing ha_planted across crops on same plot
append using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_cost_land_lrs.dta"						// appending LRS data

preserve
*We also want to create a total area planted variable, double counting plots, for fertilizer application rate
collapse (sum) ha_planted*, by(y2_hhid)
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_ha_planted_total.dta", replace
restore
collapse (sum) ha_planted* value_owned_land*, by(y2_hhid plot_id)			
collapse (sum) ha_planted* value_owned_land*, by(y2_hhid)					// now summing to household

lab var value_owned_land "Value of owned land that was cultivated (household)"
lab var value_owned_land_male "Value of owned land (male-managed plots)"
lab var value_owned_land_female "Value of owned land (female-managed plots)"
lab var value_owned_land_mixed "Value of owned land (mixed-managed plots)"
lab var ha_planted "Area planted (household)"
lab var ha_planted_male "Area planted (male-managed plots)"
lab var ha_planted_female "Area planted (female-managed plots)"
lab var ha_planted_mixed "Area planted (mixed-managed plots)"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_cost_land.dta", replace


*Now input costs*
*  LRS  *
*In section 3 are fertilizer, hired labor, and family labor
use "${Tanzania_NPS_W2_raw_data}/AG_SEC3A.dta", clear
drop if plotnum==""			
*Merging in geographic variables first (for constructing prices)
merge m:1 y2_hhid using "${Tanzania_NPS_W2_raw_data}/HH_SEC_A.dta", nogen assert(2 3) keep(3)	
*Gender variables
ren  plotnum plot_id
merge m:1 y2_hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_rent_nomiss_lrs.dta", nogen keep(1 3) keepusing(dm_gender)
*Starting with fertilizer
egen value_inorg_fert_lrs = rowtotal(ag3a_49 ag3a_56)			// inorganic fertilizer (all purchased)
gen value_herb_pest_lrs = ag3a_61 						// her/pesticide (all purchased)
gen value_org_purchased_lrs = ag3a_43					// PURCHASED organic fertilizer
preserve
gen fert_org_kg = ag3a_40		// quantity of organic fertilizer (kg)
egen fert_inorg_kg = rowtotal(ag3a_47 ag3a_54)		// quantity of inorganic fertilizer (kg)
gen fert_inorg_kg_male = fert_inorg_kg if dm_gender==1
gen fert_inorg_kg_female = fert_inorg_kg if dm_gender==2
gen fert_inorg_kg_mixed = fert_inorg_kg if dm_gender==3
collapse (sum) fert_org_kg fert_inorg_kg*, by(y2_hhid)
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_fert_lrs.dta", replace
restore
*For organic fertilizer value, we need to construct prices (note that there are relatively few prices, so many will be at higher levels of aggregation)
recode ag3a_40 ag3a_42 (.=0)						
gen org_fert_notpurchased = ag3a_40-ag3a_42			
replace org_fert_notpurchased = 0 if org_fert_notpurchased<0			
gen org_fert_purchased = ag3a_42					
gen org_fert_price = ag3a_43/org_fert_purchased		
recode org_fert_price (0=.) 
*Household-specific value
preserve
keep if org_fert_purchased!=0 & org_fert_purchased!=.		// keeping only plots that had purchased organic fertilizer
collapse (sum) org_fert_purchased ag3a_43, by(y2_hhid)		// total kg purchased and total paid
gen org_fert_price_hh = ag3a_43/org_fert_purchased
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_org_fert_lrs.dta", replace
restore
merge m:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_org_fert_lrs.dta", nogen
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
replace org_fert_price = org_fert_price_hh if org_fert_price_hh!=. & org_fert_price_hh!=0		
gen value_org_notpurchased_lrs = org_fert_price*org_fert_notpurchased						// total value not purchased
*Hired labor
egen prep_labor = rowtotal(ag3a_72_1 ag3a_72_2 ag3a_72_21)		// we have to include male, female, and child labor together (cannot disaggregate wages)
egen weed_labor = rowtotal(ag3a_72_4 ag3a_72_5 ag3a_72_51)		// we have to include male, female, and child labor together (cannot disaggregate wages)
egen nonharv_labor = rowtotal(ag3a_72_61 ag3a_72_62 ag3a_72_63) 
egen harv_labor = rowtotal(ag3a_72_7 ag3a_72_8 ag3a_72_81)	// we have to include male, female, and child labor together (cannot disaggregate wages)
*Hired wages:
gen prep_wage = ag3a_72_3/prep_labor
gen weed_wage = ag3a_72_6/weed_labor
gen nonharv_wage = ag3a_72_64/nonharv_labor
gen harv_wage = ag3a_72_9/harv_labor
*Hired costs
gen prep_labor_costs = ag3a_72_3
gen weed_labor_costs = ag3a_72_6
gen nonharv_labor_costs = ag3a_72_64
gen harv_labor_costs = ag3a_72_9
egen value_hired_labor_prep_lrs = rowtotal(*_labor_costs)
*Constructing a household-specific wage
preserve
collapse (sum) prep_labor weed_labor nonharv_labor harv_labor *labor_costs, by(y2_hhid)		// summing total amount of labor and total wages paid to the household level
gen prep_wage_hh = prep_labor_costs/prep_labor									// total costs divided by total labor at the household level
gen weed_wage_hh = weed_labor_costs/weed_labor
gen nonharv_wage_hh = nonharv_labor_costs/nonharv_labor
gen harv_wage_hh = harv_labor_costs/harv_labor
recode *wage* (0=.)			// missing if zero
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_wages_hh_lrs.dta", replace
restore
merge m:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_wages_hh_lrs.dta", nogen
*Going to construct wages separately for each type
*Constructing for each labor type
foreach i in prep weed nonharv harv{
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
sum *wage_rate, d	
*Since we have to construct a single wage variable, we do not need to disaggregate family labor by gender (or age)
*prep
egen prep_fam_labor_tot = rowtotal(ag3a_70_1 ag3a_70_2 ag3a_70_3 ag3a_70_4 ag3a_70_5 ag3a_70_6)
*weed
egen weed_fam_labor_tot = rowtotal(ag3a_70_13 ag3a_70_14 ag3a_70_15 ag3a_70_16 ag3a_70_17 ag3a_70_18)
*nonharv
egen nonharv_fam_labor_tot = rowtotal(ag3a_70_37 ag3a_70_38 ag3a_70_39 ag3a_70_40 ag3a_70_41 ag3a_70_42)
*prep
egen harv_fam_labor_tot = rowtotal(ag3a_70_25 ag3a_70_26 ag3a_70_27 ag3a_70_28 ag3a_70_29 ag3a_70_30)
*Generating family values for each activity
gen fam_prep_val = prep_fam_labor_tot*prep_wage_rate											// using aggregate wage
replace fam_prep_val = prep_fam_labor_tot*prep_wage_hh if prep_wage_hh!=0 & prep_wage_hh!=.		// using actual household wage rate if available
gen fam_weed_val = weed_fam_labor_tot*weed_wage_rate
replace fam_weed_val = weed_fam_labor_tot*weed_wage_hh if weed_wage_hh!=0 & weed_wage_hh!=.
gen fam_nonharv_val = nonharv_fam_labor_tot*nonharv_wage_rate
replace fam_nonharv_val = nonharv_fam_labor_tot*nonharv_wage_hh if nonharv_wage_hh!=0 & nonharv_wage_hh!=.
gen fam_harv_val = harv_fam_labor_tot*harv_wage_rate
replace fam_harv_val = harv_fam_labor_tot*harv_wage_hh if harv_wage_hh!=0 & harv_wage_hh!=.
*Summing at the plot level
egen value_fam_labor_lrs = rowtotal(fam_prep_val fam_weed_val fam_nonharv_val fam_harv_val)
*Renaming (dropping lrs)
ren *_lrs *
foreach i in value_inorg_fert value_herb_pest value_org_purchased value_org_notpurchased value_hired_labor_prep value_fam_labor{
	gen `i'_male = `i' if dm_gender==1
	gen `i'_female = `i' if dm_gender==2
	gen `i'_mixed = `i' if dm_gender==3
}
collapse (sum) value_*, by(y2_hhid)
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_cost_inputs_lrs.dta", replace

*  SRS  *
*In section 3 are fertilizer, hired labor, and family labor
use "${Tanzania_NPS_W2_raw_data}/AG_SEC3B.dta", clear
drop if plotnum==""			
*Merging in geographic variables first (for constructing prices)
merge m:1 y2_hhid using "${Tanzania_NPS_W2_raw_data}/HH_SEC_A.dta", nogen assert(2 3) keep(3)			
*Gender variables
ren plotnum plot_id
merge m:1 y2_hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_rent_nomiss_lrs.dta", nogen keep(1 3) keepusing(dm_gender)
*Starting with fertilizer
egen value_inorg_fert_srs = rowtotal(ag3b_49 ag3b_56)
gen value_herb_pest_srs = ag3b_61
gen value_org_purchased_srs = ag3b_43
preserve
gen fert_org_kg = ag3b_40
egen fert_inorg_kg = rowtotal(ag3b_47 ag3b_54)
gen fert_inorg_kg_male = fert_inorg_kg if dm_gender==1
gen fert_inorg_kg_female = fert_inorg_kg if dm_gender==2
gen fert_inorg_kg_mixed = fert_inorg_kg if dm_gender==3
collapse (sum) fert_org_kg fert_inorg_kg*, by(y2_hhid)
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_fert_srs.dta", replace
restore
*For organic fertilizer value, we need to construct prices (note that there are relatively few prices, so many will be at higher levels of aggregation)
recode ag3b_40 ag3b_42 (.=0)
gen org_fert_notpurchased = ag3b_40-ag3b_42			
replace org_fert_notpurchased = 0 if org_fert_notpurchased<0			
gen org_fert_purchased = ag3b_42					
gen org_fert_price = ag3b_43/org_fert_purchased		
recode org_fert_price (0=.)

*Household-specific value
preserve
keep if org_fert_purchased!=0 & org_fert_purchased!=.		// keeping only plots that had purchased organic fertilizer
collapse (sum) org_fert_purchased ag3b_43, by(y2_hhid)		// total kg purchased and total paid
gen org_fert_price_hh = ag3b_43/org_fert_purchased
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_org_fert_srs.dta", replace
restore
merge m:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_org_fert_srs.dta", nogen

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
gen value_org_notpurchased_srs = org_fert_price*org_fert_notpurchased						// total value not purchased
*Hired labor
egen prep_labor = rowtotal(ag3b_72_1 ag3b_72_2 ag3b_72_21)		// we have to include male, female, and child labor together (cannot disaggregate wages)
egen weed_labor = rowtotal(ag3b_72_4 ag3b_72_5 ag3b_72_51)		// we have to include male, female, and child labor together (cannot disaggregate wages)
egen nonharv_labor = rowtotal(ag3b_72_61 ag3b_72_62 ag3b_72_63)
egen harv_labor = rowtotal(ag3b_72_7 ag3b_72_8 ag3b_72_81)	// we have to include male, female, and child labor together (cannot disaggregate wages)
*Hired wages:
gen prep_wage = ag3b_72_3/prep_labor
gen weed_wage = ag3b_72_6/weed_labor
gen nonharv_wage = ag3b_72_64/nonharv_labor
gen harv_wage = ag3b_72_9/harv_labor
*Hired costs
gen prep_labor_costs = prep_labor*prep_wage
gen weed_labor_costs = weed_labor*weed_wage
gen nonharv_labor_costs = nonharv_labor*nonharv_wage
gen harv_labor_costs = harv_labor*harv_wage
egen value_hired_labor_prep_srs = rowtotal(*_labor_costs)
*Constructing a household-specific wage
preserve
collapse (sum) prep_labor weed_labor nonharv_labor harv_labor *labor_costs, by(y2_hhid)
gen prep_wage_hh = prep_labor_costs/prep_labor			
gen weed_wage_hh = weed_labor_costs/weed_labor
gen nonharv_wage_hh = nonharv_labor_costs/nonharv_labor
gen harv_wage_hh = harv_labor_costs/harv_labor
recode *wage* (0=.)
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_wages_hh_srs.dta", replace
restore
*Merging right back in
merge m:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_wages_hh_srs.dta", nogen

*Going to construct wages separately for each type
*Constructing for each labor type
foreach i in prep weed nonharv harv{
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
sum *wage_rate, d	
*Since we have to construct a single wage variable, we do not need to disaggregate family labor by gender
*prep
egen prep_fam_labor_tot = rowtotal(ag3b_70_1 ag3b_70_2 ag3b_70_3 ag3b_70_4 ag3b_70_5 ag3b_70_6)
*weed
egen weed_fam_labor_tot = rowtotal(ag3b_70_13 ag3b_70_14 ag3b_70_15 ag3b_70_16 ag3b_70_17 ag3b_70_18)
*nonharv
egen nonharv_fam_labor_tot = rowtotal(ag3b_70_37 ag3b_70_38 ag3b_70_39 ag3b_70_40 ag3b_70_41 ag3b_70_42)
*harv
egen harv_fam_labor_tot = rowtotal(ag3b_70_25 ag3b_70_26 ag3b_70_27 ag3b_70_28 ag3b_70_29 ag3b_70_30)
*Generating family values for each activity
gen fam_prep_val = prep_fam_labor_tot*prep_wage_rate										
replace fam_prep_val = prep_fam_labor_tot*prep_wage_hh if prep_wage_hh!=0 & prep_wage_hh!=.		// using actual household wage rate if valid
gen fam_weed_val = weed_fam_labor_tot*weed_wage_rate
replace fam_weed_val = weed_fam_labor_tot*weed_wage_hh if weed_wage_hh!=0 & weed_wage_hh!=.
gen fam_nonharv_val=nonharv_fam_labor_tot*nonharv_wage_rate
replace fam_nonharv_val = nonharv_fam_labor_tot*nonharv_wage_hh if nonharv_wage_hh!=0 & nonharv_wage_hh!=.
gen fam_harv_val = harv_fam_labor_tot*harv_wage_rate
replace fam_harv_val = harv_fam_labor_tot*harv_wage_hh if harv_wage_hh!=0 & harv_wage_hh!=.
egen value_fam_labor_srs = rowtotal(fam_prep_val fam_weed_val fam_nonharv_val fam_harv_val)
ren *_srs *
foreach i in value_inorg_fert value_herb_pest value_org_purchased value_org_notpurchased value_hired_labor_prep value_fam_labor{
	gen `i'_male = `i' if dm_gender==1
	gen `i'_female = `i' if dm_gender==2
	gen `i'_mixed = `i' if dm_gender==3
}
collapse (sum) value_*, by(y2_hhid)
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_cost_inputs_srs.dta", replace

use  "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_cost_inputs_lrs.dta", clear
append using  "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_cost_inputs_srs.dta"
collapse (sum) value_*, by(y2_hhid)
foreach v of varlist *prep*  {
	local l`v' = subinstr("`v'","_prep","",1)
	ren `v' `l`v''
}

* Seed *
*  LRS  *
use "${Tanzania_NPS_W2_raw_data}/AG_SEC4A.dta", clear
drop if plotnum==""
ren plotnum plot_id
merge m:1 y2_hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_rent_nomiss_lrs.dta", nogen keep(1 3) keepusing(dm_gender)
*Household-specific values
preserve
drop if ag4a_21==0 | ag4a_21==.				
collapse (sum) ag4a_21 , by(y2_hhid zaocode)
gen seed_price_hh_crop = ag4a_21
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_seeds_hh_lrs.dta", replace
restore
merge m:1 y2_hhid zaocode using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_seeds_hh_lrs.dta", nogen
gen value_seeds_purchased = ag4a_21
foreach i in value_seeds_purchased{
	gen `i'_male = `i' if dm_gender==1
	gen `i'_female = `i' if dm_gender==2
	gen `i'_mixed = `i' if dm_gender==3
}
collapse (sum) value_* , by(y2_hhid)
sum value_seeds_purchased, d
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_cost_seed_lrs.dta", replace

*  SRS  *
use "${Tanzania_NPS_W2_raw_data}/AG_SEC4B.dta", clear
drop if plotnum==""
ren plotnum plot_id
merge m:1 y2_hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_rent_nomiss_lrs.dta", nogen keep(1 3) keepusing(dm_gender)
*Household-specific values
preserve
drop if ag4b_21==0 | ag4b_21==.				
collapse (sum) ag4b_21, by(y2_hhid zaocode)
gen seed_price_hh_crop = ag4b_21
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_seeds_hh_srs.dta", replace
restore
merge m:1 y2_hhid zaocode using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_seeds_hh_srs.dta", nogen
gen value_seeds_purchased = ag4b_21
foreach i in value_seeds_purchased{
	gen `i'_male = `i' if dm_gender==1
	gen `i'_female = `i' if dm_gender==2
	gen `i'_mixed = `i' if dm_gender==3
}
collapse (sum) value_* , by(y2_hhid)
sum value_seeds_purchased*, d
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_cost_seed_srs.dta", replace

*Rental of agricultural tools, machines, animal traction
use "${Tanzania_NPS_W2_raw_data}/AG_SEC11.dta", clear
ren itemcode itemid
gen animal_traction = (itemid>=3 & itemid<=5)
gen ag_asset = (itemid<3 | itemid>8)
gen tractor = (itemid>=6 & itemid<=8)
ren ag11_09 rental_cost
gen rental_cost_animal_traction = rental_cost if animal_traction==1
gen rental_cost_ag_asset = rental_cost if ag_asset==1
gen rental_cost_tractor = rental_cost if tractor==1
recode rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor (.=0)
collapse (sum) rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor, by (y2_hhid)
lab var rental_cost_animal_traction "Costs for renting animal traction"
lab var rental_cost_ag_asset "Costs for renting other agricultural items"
lab var rental_cost_tractor "Costs for renting a tractor"
egen value_ag_rentals = rowtotal(rental_cost_*)
lab var value_ag_rentals "Value of rented equipment (household level"
 save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_asset_rental_costs.dta", replace

* merging cost variable together
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_cost_land.dta", clear
append using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_rental_rate.dta"
append using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_cost_inputs_lrs.dta"
append using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_cost_inputs_srs.dta"
append using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_cost_seed_lrs.dta"
append using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_cost_seed_srs.dta"
append using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_asset_rental_costs.dta"
collapse (sum) value_* ha_planted*, by(y2_hhid)

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
egen cost_total=rowtotal (value_owned_land value_rented_land value_inorg_fert value_herb_pest value_org_purchased value_org_notpurchased value_hired_labor value_fam_labor value_seeds_purchased)
lab var cost_total "Explicit + implicit costs of crop production (plot level)"
foreach i in male female mixed{ 
	egen cost_total_`i' = rowtotal(value_owned_land_`i' value_rented_land_`i' value_inorg_fert_`i' value_herb_pest_`i' value_org_purchased_`i' value_org_notpurchased_`i' value_hired_labor_`i' value_fam_labor_`i' value_seeds_purchased_`i')
}
lab var cost_total_male "Explicit + implicit costs of crop production (male-managed plots)" 
lab var cost_total_female "Explicit + implicit costs of crop production (female-managed plots)"
lab var cost_total_mixed "Explicit + implicit costs of crop production (mixed-managed plots)"
*Explicit costs at the plot level 
egen cost_expli =rowtotal(value_rented_land value_inorg_fert value_herb_pest value_org_purchased value_hired_labor value_seeds_purchased)
lab var cost_expli "Explicit costs of crop production (plot level)" 
*Creating explicit costs by gender
foreach i in male female mixed{
	egen cost_expli_`i' = rowtotal( value_rented_land_`i' value_inorg_fert_`i' value_herb_pest_`i' value_org_purchased_`i' value_hired_labor_`i' value_seeds_purchased_`i')
}
lab var cost_expli_male "Explicit costs of crop production (male-managed plots)" 
lab var cost_expli_female "Explicit costs of crop production (female-managed plots)" 
lab var cost_expli_mixed "Explicit costs of crop production (mixed-managed plots)" 
*Explicit costs at the household level
egen cost_expli_hh = rowtotal(value_ag_rentals value_rented_land value_inorg_fert value_herb_pest value_org_purchased value_hired_labor value_seeds_purchased)
lab var cost_expli_hh "Total explicit crop production (household level)" 
count if cost_expli_hh==0
*Recoding zeros as missings
recode cost_total* (0=.)
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_cropcosts_total.dta", replace


********************************************************************************
*AGRICULTURAL WAGES
********************************************************************************
*Only long rainy season as the number of valid observation for SRS is too small (only 16 plots cultivated)
use "${Tanzania_NPS_W2_raw_data}/AG_SEC3A.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC3B.dta"
* The survey reports total wage paid and amount of hired labor: wage=total paid/ amount of labor
* set wage paid to . if zero or negative
recode ag3a_72_* ag3b_72_* (0=.)
* Sample size for children too small and interviewer manure seemed to have suggested that children are not paid. Thus focus on men and women.
ren ag3a_72_2 hired_male_lanprep
replace hired_male_lanprep = ag3b_72_2 if hired_male_lanprep==.
ren ag3a_72_1 hired_female_lanprep
replace hired_female_lanprep = ag3b_72_1 if hired_female_lanprep==.
ren ag3a_72_3 hlabor_paid_lanprep
replace hlabor_paid_lanprep = ag3b_72_3 if hlabor_paid_lanprep==.
ren ag3a_72_5 hired_male_weeding
replace hired_male_weeding = ag3b_72_5 if hired_male_weeding==.
ren ag3a_72_4 hired_female_weeding
replace hired_female_weeding = ag3b_72_4 if hired_female_weeding==.
ren ag3a_72_6 hlabor_paid_weeding
replace hlabor_paid_weeding = ag3b_72_6 if hlabor_paid_weeding==.
ren ag3a_72_61 hired_male_nonharv
replace hired_male_nonharv = ag3b_72_61 if hired_male_nonharv==.
ren ag3a_72_62 hired_female_nonharv
replace hired_female_nonharv = ag3b_72_62 if hired_female_nonharv==.
ren ag3a_72_64 hlabor_paid_nonharv
replace hlabor_paid_nonharv = ag3b_72_64 if hlabor_paid_nonharv==.
ren ag3a_72_8 hired_male_harvest
replace hired_male_harvest = ag3b_72_8 if hired_male_harvest==.
ren ag3a_72_7 hired_female_harvest
replace hired_female_harvest = ag3b_72_7 if hired_female_harvest==.
ren ag3a_72_9 hlabor_paid_harvest
replace hlabor_paid_harvest = ag3b_72_9 if hlabor_paid_harvest==.
*grouping of activities
recode hired* hlabor* (.=0)
collapse (sum) hired* hlabor*, by(y2_hhid)
gen hirelabor_lanprep=(hired_male_lanprep+hired_female_lanprep)
gen wage_lanprep=hlabor_paid_lanprep/hirelabor_lanprep
gen hirelabor_weeding=(hired_male_weeding+hired_female_weeding)
gen wage_weedingothers=hlabor_paid_weeding/hirelabor_weeding
gen hirelabor_nonharv=(hired_male_nonharv+hired_female_nonharv)
gen wage_nonharv=hlabor_paid_nonharv/hirelabor_nonharv
gen hirelabor_harvest=(hired_male_harvest+hired_female_harvest)
gen wage_harvest=hlabor_paid_harvest/hirelabor_harvest
*get weighted average average across group of activities to get paid wage at household level
recode wage_lanprep hirelabor_lanprep wage_weeding hirelabor_weeding wage_nonharv hirelabor_nonharv wage_harvest hirelabor_harvest (.=0)
gen wage_paid_aglabor=(wage_lanprep*hirelabor_lanprep+wage_weeding*hirelabor_weeding+wage_nonharv*hirelabor_nonharv+wage_harvest*hirelabor_harvest)/(hirelabor_lanprep+hirelabor_weeding+hirelabor_nonharv+hirelabor_harvest)
keep y2_hhid wage_paid_aglabor 
lab var wage_paid_aglabor "Daily agricultural wage paid for hired labor (local currency)"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_ag_wage.dta", replace


********************************************************************************
*RATE OF FERTILIZER APPLICATION -Long Rainy Season
********************************************************************************
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_cost_land.dta", clear
append using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_fert_lrs.dta"
append using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_fert_srs.dta"
collapse (sum) ha_planted* fert_org_kg* fert_inorg_kg*, by(y2_hhid)
merge m:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhids.dta", keep (1 3) nogen
drop ha_planted*
lab var fert_inorg_kg "Quantity of fertilizer applied (kgs) (household level)"
lab var fert_inorg_kg_male "Quantity of fertilizer applied (kgs) (male-managed plots)"
lab var fert_inorg_kg_female "Quantity of fertilizer applied (kgs) (female-managed plots)"
lab var fert_inorg_kg_mixed "Quantity of fertilizer applied (kgs) (mixed-managed plots)"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fertilizer_application.dta", replace


********************************************************************************
*WOMEN'S DIET QUALITY
********************************************************************************
*Women's diet quality: proportion of women consuming nutrient-rich foods (%)
*Information not available



********************************************************************************
*HOUSEHOLD'S DIET DIVERSITY SCORE
********************************************************************************
* TZA LSMS does not report individual consumption but instead household level consumption of various food items.
* Thus, only the proportion of householdd eating nutritious food can be estimated
use "${Tanzania_NPS_W2_raw_data}/HH_SEC_K1.dta" , clear
* recode food items to map HDDS food categories
recode itemcode 	(101/112 		  				=1	"CEREALS" )  //// 
					(201/207    					=2	"WHITE ROOTS,TUBERS AND OTHER STARCHES"	)  ////
					(601/603		 				=3	"VEGETABLES"	)  ////	
					(701/703						=4	"FRUITS"	)  ////	
					(801/806 						=5	"MEAT"	)  ////					
					(807							=6	"EGGS"	)  ////
					(808/810 						=7  "FISH") ///
					(401  501/504					=8	"LEGUMES, NUTS AND SEEDS") ///
					(901/903						=9	"MILK AND MILK PRODUCTS")  ////
					(1001 1002   					=10	"OILS AND FATS"	)  ////
					(301/303 704 1104 				=11	"SWEETS"	)  //// 
					(1003 1004 1101/1103 1105/1108 	=14 "SPICES, CONDIMENTS, BEVERAGES"	)  ////
					,generate(Diet_ID)			
gen adiet_yes=(hh_k01_2==1)
ta Diet_ID   
** Now, collapse to food group level; household consumes a food group if it consumes at least one item
collapse (max) adiet_yes, by(y2_hhid   Diet_ID) 
label define YesNo 1 "Yes" 0 "No"
label val adiet_yes YesNo
* Now, estimate the number of food groups eaten by each individual
collapse (sum) adiet_yes, by(y2_hhid )
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
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_household_diet.dta", replace
 
 
********************************************************************************
*WOMEN'S CONTROL OVER INCOME
********************************************************************************
*Code as 1 if a woman is listed as one of the decision-makers for at least 1 income-related area; 
*can report on % of women who make decisions, taking total number of women HH members as denominator
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
use "${Tanzania_NPS_W2_raw_data}/AG_SEC4A", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC5A"
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC5B"
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC09"
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC10A.dta"
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC10B.dta"
append using "${Tanzania_NPS_W2_raw_data}/HH_SEC_E1.dta"
gen type_decision="" 
gen controller_income1=.
gen controller_income2=.
* control_annualsales
replace type_decision="control_annualsales" if  !inlist( ag5a_09_1, .,0,99) |  !inlist( ag5a_09_2, .,0,99) 
replace controller_income1=ag5a_09_1 if !inlist( ag5a_09_1, .,0,99)  
replace controller_income2=ag5a_09_2 if !inlist( ag5a_09_2, .,0,99)
replace type_decision="control_annualsales" if  !inlist( ag5b_09_1, .,0,99) |  !inlist( ag5b_09_2, .,0,99) 
replace controller_income1=ag5b_09_1 if !inlist( ag5b_09_1, .,0,99)  
replace controller_income2=ag5b_09_2 if !inlist( ag5b_09_2, .,0,99)
* append who controle earning from sale to customer 2
preserve
replace type_decision="control_annualsales" if  !inlist( ag5a_14_1, .,0,99) |  !inlist( ag5a_14_2, .,0,99) 
replace controller_income1=ag5a_14_1 if !inlist( ag5a_14_1, .,0,99)  
replace controller_income2=ag5a_14_2 if !inlist( ag5a_14_2, .,0,99)
replace type_decision="control_annualsales" if  !inlist( ag5b_14_1, .,0,99) |  !inlist( ag5b_14_2, .,0,99) 
replace controller_income1=ag5b_14_1 if !inlist( ag5b_14_1, .,0,99)  
replace controller_income2=ag5b_14_2 if !inlist( ag5b_14_2, .,0,99)
keep if !inlist( ag5a_14_1, .,0,99) |  !inlist( ag5a_14_2, .,0,99)  | !inlist( ag5b_14_1, .,0,99) |  !inlist( ag5b_14_2, .,0,99) 
keep y2_hhid type_decision controller_income1 controller_income2
tempfile saletocustomer2
save `saletocustomer2'
restore
append using `saletocustomer2'  
* livestock_sales (live)
replace type_decision="control_livestocksales" if  !inlist( ag10a_22_1, .,0,99) |  !inlist( ag10a_22_2, .,0,99) 
replace controller_income1=ag10a_22_1 if !inlist( ag10a_22_1, .,0,99)  
replace controller_income2=ag10a_22_2 if !inlist( ag10a_22_2, .,0,99)
* append who controle earning from livestock_sales (slaughtered)
preserve
replace type_decision="control_livestocksales" if  !inlist( ag10a_28_1, .,0,99) |  !inlist( ag10a_28_2, .,0,99) 
replace controller_income1=ag10a_28_1 if !inlist( ag10a_28_1, .,0,99)  
replace controller_income2=ag10a_28_2 if !inlist( ag10a_28_2, .,0,99)
keep if  !inlist( ag10a_28_1, .,0,99) |  !inlist( ag10a_28_2, .,0,99) 
keep y2_hhid type_decision controller_income1 controller_income2
tempfile control_livestocksales2
save `control_livestocksales2'
restore
append using `control_livestocksales2' 
* control control_otherlivestock_sales
replace type_decision="control_otherlivestock_sales" if  !inlist( ag10b_08_1, .,0,99) |  !inlist( ag10b_08_2, .,0,99) 
replace controller_income1=ag10b_08_1 if !inlist( ag10b_08_1, .,0,99)  
replace controller_income2=ag10b_08_2 if !inlist( ag10b_08_2, .,0,99)
* Fish production income 
*No information available
replace type_decision="control_businessincome" if  !inlist( hh_e54_1, .,0,99) |  !inlist( hh_e54_2, .,0,99) 
replace controller_income1=hh_e54_1 if !inlist( hh_e54_1, .,0,99)  
replace controller_income2=hh_e54_2 if !inlist( hh_e54_2, .,0,99)

** --- Wage income --- *
* There is no question in Tanzania LSMS on who control wage earnings
* and we can't assume that the wage earner always controle the wage income
keep y2_hhid type_decision controller_income1 controller_income2
preserve
keep y2_hhid type_decision controller_income2
drop if controller_income2==.
ren controller_income2 controller_income
tempfile controller_income2
save `controller_income2'
restore
keep y2_hhid type_decision controller_income1
drop if controller_income1==.
ren controller_income1 controller_income
append using `controller_income2'
 
* create group
gen control_cropincome = 1 if type_decision == "control_annualsales"
recode 	control_cropincome (.=0)									
gen control_livestockincome = 1 if  type_decision == "control_livestocksales" | type_decision=="control_otherlivestock_sales"							
recode 	control_livestockincome (.=0)
gen control_farmincome=1 if  control_cropincome==1 | control_livestockincome==1							
recode control_farmincome (.=0)								
gen control_businessincome=1 if  type_decision=="control_businessincome" 
recode 	control_businessincome (.=0)																					
gen control_nonfarmincome=1 if control_businessincome== 1 
recode 	control_nonfarmincome (.=0)																		
collapse (max) control_* , by(y2_hhid controller_income )  //any decision
gen control_all_income=1 if  control_farmincome== 1 | control_nonfarmincome==1
recode 	control_all_income (.=0)															
ren controller_income indidy2
*Now merge with member characteristics
merge 1:1 y2_hhid indidy2  using  "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_person_ids.dta", nogen 
recode control_* (.=0)
lab var control_cropincome "1=invidual has control over crop income"
lab var control_livestockincome "1=invidual has control over livestock income"
lab var control_farmincome "1=invidual has control over farm (crop or livestock) income"
lab var control_businessincome "1=invidual has control over business income"
lab var control_nonfarmincome "1=invidual has control over non-farm (business or remittances) income"
lab var control_all_income "1=invidual has control over at least one type of income"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_control_income.dta", replace

********************************************************************************
*WOMEN'S PARTICIPATION IN AGRICULTURAL DECISION MAKING
********************************************************************************
*Code as 1 if a woman is listed as one of the decision-makers for at least 2 plots, crops, or livestock activities; 
*can report on % of women who make decisions, taking total number of women HH members as denominator
*Indicator may be biased downward if some women would participate in decisions but are not listed among the first two
*first append all files related to agricultural activities with income in who participate in the decision making
use "${Tanzania_NPS_W2_raw_data}/AG_SEC3A", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC3B"
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC10A.dta"
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC10B.dta"
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
* keep/manage livesock
replace type_decision="manage_livestock" if  !inlist( ag10a_29_1, .,0,99) |  !inlist( ag10a_29_2, .,0,99)  
replace decision_maker1=ag10a_29_1 if !inlist( ag10a_29_1, .,0,99)  
replace decision_maker2=ag10a_29_2 if !inlist( ag10a_29_2, .,0,99)
keep y2_hhid type_decision decision_maker1 decision_maker2 decision_maker3
preserve
keep y2_hhid type_decision decision_maker2
drop if decision_maker2==.
ren decision_maker2 decision_maker
tempfile decision_maker2
save `decision_maker2'
restore

preserve
keep y2_hhid type_decision decision_maker3
drop if decision_maker3==.
ren decision_maker3 decision_maker
tempfile decision_maker3
save `decision_maker3'
restore
keep y2_hhid type_decision decision_maker1
drop if decision_maker1==.
ren decision_maker1 decision_maker
append using `decision_maker2'
append using `decision_maker3'
  
* number of time appears as decision maker
bysort y2_hhid decision_maker : egen nb_decision_participation=count(decision_maker)
drop if nb_decision_participation==1
gen make_decision_crop=1 if  type_decision=="planting_input"
recode 	make_decision_crop (.=0)
gen make_decision_livestock=1 if  type_decision=="livestockowners" 
recode 	make_decision_livestock (.=0)
gen make_decision_ag=1 if make_decision_crop==1 | make_decision_livestock==1
recode 	make_decision_ag (.=0)
collapse (max) make_decision_* , by(y2_hhid decision_maker )  //any decision
ren decision_maker indidy2 
* Now merge with member characteristics
merge 1:1 y2_hhid indidy2  using  "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_person_ids.dta", nogen 
* 1 member ID in decision files not in member list
recode make_decision_* (.=0)
lab var make_decision_crop "1=invidual makes decision about crop production activities"
lab var make_decision_livestock "1=invidual makes decision about livestock production activities"
lab var make_decision_ag "1=invidual makes decision about agricultural (crop or livestock) production activities"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_make_ag_decision.dta", replace

 
********************************************************************************
*WOMEN'S OWNERSHIP OF ASSETS
********************************************************************************
* Code as 1 if a woman is sole or joint owner of any specified productive asset; 
* can report on % of women who own, taking total number of women HH members as denominator
* Indicator may be biased downward if some women would have been not listed among the two the first 2 asset-owners can also claim ownership of some assets
*First, append all files with information on asset ownership
use "${Tanzania_NPS_W2_raw_data}/AG_SEC3A.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC3B.dta" 
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC10A.dta"
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
*livestock (keeps/manages)
replace type_asset="livestockowners" if  !inlist( ag10a_29_1, .,0,99) |  !inlist( ag10a_29_2, .,0,99)  
replace asset_owner1=ag10a_29_1 if !inlist( ag10a_29_1, .,0,99)  
replace asset_owner2=ag10a_29_2 if !inlist( ag10a_29_2, .,0,99)
keep y2_hhid type_asset asset_owner1 asset_owner2  

preserve
keep y2_hhid type_asset asset_owner2
drop if asset_owner2==.
ren asset_owner2 asset_owner
tempfile asset_owner2
save `asset_owner2'
restore

keep y2_hhid type_asset asset_owner1
drop if asset_owner1==.
ren asset_owner1 asset_owner
append using `asset_owner2'
gen own_asset=1 
collapse (max) own_asset, by(y2_hhid asset_owner)
ren asset_owner indidy2
* Now merge with member characteristics
merge 1:1 y2_hhid indidy2  using  "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_person_ids.dta", nogen 
* 3 member ID in assed files not is member list
recode own_asset (.=0)
lab var own_asset "1=invidual owns an assets (land or livestock)"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_ownasset.dta", replace

                                         
********************************************************************************
*CROP YIELDS
********************************************************************************
* crops
use "${Tanzania_NPS_W2_raw_data}/AG_SEC4A.dta", clear
* Percent of area
gen pure_stand = ag4a_04==2
gen any_pure = pure_stand==1
gen any_mixed = pure_stand==0
gen percent_field = 0.25 if ag4a_02==1
replace percent_field = 0.50 if ag4a_02==2
replace percent_field = 0.75 if ag4a_02==3
replace percent_field = 1 if ag4a_01==1
duplicates report y2_hhid plotnum zaocode		
duplicates drop y2_hhid plotnum zaocode, force	
drop if plotnum==""
ren plotnum plot_id 
*Merging in variables from tzn4_field
merge m:1 y2_hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_areas.dta" , nogen keep(1 3)    // dropping those only in using
merge m:1 y2_hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_decision_makers" , nogen keep(1 3)
gen field_area =  area_meas_hectares
replace field_area= area_est_hectares if field_area==.
gen intercropped_yn = 1 if ~missing(ag4a_04) 
replace intercropped_yn =0 if ag4a_04 == 2 //Not Intercropped
gen mono_field = percent_field if intercropped_yn==0 //not intercropped 
gen int_field = percent_field if intercropped_yn==1  
*Generating total percent of purestand and monocropped on a field
bys y2_hhid plot_id: egen total_percent_int_sum = total(int_field)
bys y2_hhid plot_id: egen total_percent_mono = total(mono_field)
//Dealing with crops which have monocropping larger than plot size or monocropping that fills plot size and still has intercropping to add
gen oversize_plot = (total_percent_mono >1)
replace oversize_plot = 1 if total_percent_mono >=1 & total_percent_int_sum >0 
bys y2_hhid plot_id: egen total_percent_field = total(percent_field)			            
replace percent_field = percent_field/total_percent_field if total_percent_field>1 & oversize_plot ==1
replace total_percent_mono = 1 if total_percent_mono>1 
gen total_percent_inter = 1-total_percent_mono 
bys y2_hhid plot_id: egen inter_crop_number = total(intercropped_yn) 
gen percent_inter = (int_field/total_percent_int_sum)*total_percent_inter if total_percent_field >1 
replace percent_inter = int_field if total_percent_field<=1	
replace percent_inter = percent_field if oversize_plot ==1 & intercropped_yn==1
ren cultivated field_cultivated  
gen field_area_cultivated = field_area if field_cultivated==1
//gen crop_area_planted = percent_field*field_area_cultivated 
gen crop_area_planted = percent_field*field_area_cultivated  if intercropped_yn == 0 
replace crop_area_planted = percent_inter*field_area_cultivated  if intercropped_yn == 1 
gen us_total_area_planted = total_percent_field*field_area_cultivated 
gen us_inter_area_planted = total_percent_int_sum*field_area_cultivated 
keep crop_area_planted* y2_hhid plot_id zaocode dm_* any_* pure_stand dm_gender  field_area us_* area_meas_hectares area_est_hectares 
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_crop_area.dta", replace

*Now to harvest
use "${Tanzania_NPS_W2_raw_data}/AG_SEC4A.dta", clear
gen kg_harvest = ag4a_15
ren ag4a_09 harv_less_plant			//yes if they harvested less than they planted
ren ag4a_06 no_harv
replace kg_harvest = 0 if ag4a_07==3
replace kg_harvest =. if ag4a_07==1 | ag4a_07==2 | ag4a_07==4		
drop if kg_harvest==.							// dropping those with missing kg (to prevent collapsing problems below with zeros instead of missings)
gen area_harv_ha= ag4a_08*0.404686						
keep y2_hhid plotnum zaocode kg_harvest area_harv_ha harv_less_plant no_harv
ren plotnum plot_id 
*Merging decision maker and intercropping variables
merge m:1 y2_hhid plot_id zaocode using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_crop_area.dta", nogen 
preserve 
use "${Tanzania_NPS_W2_raw_data}/AG_SEC6A.dta", clear
ren plotnum plot_id
merge m:1 y2_hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_decision_makers" , nogen keep(1 3) 
ren ag6a_02 number_trees_planted
keep y2_hhid plot_id zaocode dm_gender number_trees_planted
tempfile banana
save `banana', replace
restore
append using `banana'

//Add production of permanent crops (cassava)
preserve
use "${Tanzania_NPS_W2_raw_data}/AG_SEC6B.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC6A.dta"		
gen kg_harvest = ag6b_08
replace kg_harvest = ag6a_09 if kg_harvest==.					
gen pure_stand = ag6b_05==2
replace pure_stand = ag6a_05==2 if pure_stand==. 				
gen any_pure = pure_stand==1
gen any_mixed = pure_stand==0
ren plotnum plot_id
merge m:1 y2_hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_areas.dta", nogen keep(1 3)	                // dropping those only in using
merge m:1 y2_hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_decision_makers" , nogen keep(1 3) 
gen field_area =  area_meas_hectares
replace field_area= area_est_hectares if field_area==.
ren ag6b_02 number_trees_planted
keep y2_hhid plot_id zaocode kg_harvest number_trees_planted pure_stand any_pure any_mixed field_area dm_gender 
tempfile  cassava
save `cassava', replace
restore 
append using `cassava'

ren crop_area_planted area_plan

//Capping Code:
gen over_harvest = area_harv_ha>field_area & area_harv_ha!=. & area_meas_hectares!=.	
gen over_harvest_scaling = field_area/area_harv_ha if over_harvest == 1
bys y2_hhid plot_id: egen mean_harvest_scaling = mean(over_harvest_scaling)
replace mean_harvest_scaling =1 if missing(mean_harvest_scaling)
replace area_harv_ha = field_area if over_harvest == 1
replace area_harv_ha = area_harv_ha*mean_harvest_scaling if over_harvest == 0 
//Intercropping Scaling Code (Method 4):
bys y2_hhid plot_id: egen over_harv_plot = max(over_harvest)
gen intercropped_yn = pure_stand !=1 
gen int_f_harv = area_harv_ha if intercropped_yn==1
bys y2_hhid plot_id: egen total_area_int_sum_hv = total(int_f_harv)
bys y2_hhid plot_id: egen total_area_hv = total(area_harv_ha)
replace us_total_area_planted = total_area_hv if over_harv_plot ==1
replace us_inter_area_planted = total_area_int_sum_hv if over_harv_plot ==1
drop intercropped_yn int_f_harv total_area_int_sum_hv total_area_hv
//  Adding Method 4 to Area Harvested
gen intercropped_yn = pure_stand !=1 
gen mono_f_harv = area_harv_ha if intercropped_yn==0
gen int_f_harv = area_harv_ha if intercropped_yn==1
bys y2_hhid plot_id: egen total_area_int_sum_hv = total(int_f_harv)
bys y2_hhid plot_id: egen total_area_mono_hv = total(mono_f_harv)
//Oversize Plots
gen oversize_plot = total_area_mono_hv > field_area
replace oversize_plot = 1 if total_area_mono_hv >=1 & total_area_int_sum_hv >0 
bys y2_hhid plot_id: egen total_area_harv = total(area_harv_ha)	
replace area_harv_ha = (area_harv_ha/us_total_area_planted)*field_area if oversize_plot ==1 
gen total_area_int_hv = field_area - total_area_mono_hv
replace area_harv_ha = (int_f_harv/us_inter_area_planted)*total_area_int_hv if intercropped_yn==1 & oversize_plot !=1 
replace area_harv_ha=. if area_harv_ha==0 //5 to missing
replace area_plan=area_harv_ha if area_plan==. & area_harv_ha!=.
*capping area harvested at area planted
count if area_harv_ha>area_plan & area_harv_ha!=.  //1053 observations where area harvested is greater than area planted 
replace area_harv_ha = area_plan if area_harv_ha>area_plan & area_harv_ha!=. 


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
collapse (sum) area_harv* harvest* area_plan* number_trees_planted , by (y2_hhid zaocode)
*merging survey weights
merge m:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhids.dta", nogen keep(1 3)
*Saving area planted for Shannon diversity index
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_crop_area_plan_LRS.dta", replace

*Adding here total planted and harvested area all plots, crops, and seasons
preserve
collapse (sum) all_area_harvested=area_harv all_area_planted=area_plan, by(y2_hhid)
replace all_area_harvested=all_area_planted if all_area_harvested>all_area_planted & all_area_harvested!=.
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_area_planted_harvested_allcrops_LRS.dta", replace
restore
keep if inlist( zaocode, $comma_topcrop_area)
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_harvest_area_yield_LRS.dta", replace

**In Tanzania, we add area_harvested and area_planted in SRS
** kgs_harvest, value_harvest, and value_sold are alread summed accross seasons

//////Generating yield variables for short rainy season/////
* crops
use "${Tanzania_NPS_W2_raw_data}/AG_SEC4B.dta", clear
* Percent of area
gen pure_stand = ag4b_04==2
gen any_pure = pure_stand==1
gen any_mixed = pure_stand==0
gen percent_field = 0.25 if ag4b_02==1
replace percent_field = 0.50 if ag4b_02==2
replace percent_field = 0.75 if ag4b_02==3
replace percent_field = 1 if ag4b_01==1
duplicates report y2_hhid plotnum zaocode		
duplicates drop y2_hhid plotnum zaocode, force	
drop if plotnum==""
ren plotnum plot_id 
*Merging in variables from tzn4_field
merge m:1 y2_hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_areas.dta" , nogen keep(1 3)    // dropping those only in using
merge m:1 y2_hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_decision_makers" , nogen keep(1 3)
gen field_area =  area_meas_hectares
replace field_area= area_est_hectares if field_area==.
gen intercropped_yn = 1 if ~missing(ag4b_04) 
replace intercropped_yn =0 if ag4b_04 == 2 //Not Intercropped
gen mono_field = percent_field if intercropped_yn==0 //not intercropped
gen int_field = percent_field if intercropped_yn==1 
bys y2_hhid plot_id: egen total_percent_mono = total(mono_field) 
bys y2_hhid plot_id: egen total_percent_int_sum = total(int_field) 
 //Dealing with crops which have monocropping larger than plot size or monocropping that fills plot size and till has intercropping to add
gen oversize_plot = (total_percent_mono >1)
replace oversize_plot = 1 if total_percent_mono >=1 & total_percent_int_sum >0 
bys y2_hhid plot_id: egen total_percent_field = total(percent_field)			            
replace percent_field = percent_field/total_percent_field if total_percent_field>1 & oversize_plot ==1		//17 changes made
replace total_percent_mono = 1 if total_percent_mono>1
gen total_percent_inter = 1-total_percent_mono 
bys y2_hhid plot_id: egen inter_crop_number = total(intercropped_yn) 
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
keep crop_area_planted* y2_hhid plot_id zaocode dm_* any_* pure_stand dm_gender  field_area us_* area_meas_hectares area_est_hectares	
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_crop_area_SRS.dta", replace

*Now to harvest
use "${Tanzania_NPS_W2_raw_data}/AG_SEC4B.dta", clear
gen kg_harvest = ag4b_15
ren ag4b_09 harv_less_plant			//yes if they harvested less than they planted
ren ag4b_06 no_harv
replace kg_harvest = 0 if ag4b_07==3
drop if kg_harvest==.							// dropping those with missing kg (to prevent collapsing problems below with zeros instead of missings)
gen area_harv_ha= ag4b_08*0.404686						
keep y2_hhid plotnum zaocode kg_harvest area_harv_ha harv_less_plant no_harv
ren plotnum plot_id 
*Merging decision maker and intercropping variables
merge m:1 y2_hhid plot_id zaocode using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_crop_area_SRS.dta", nogen 			
//Capping Code:
gen over_harvest = area_harv_ha>field_area & area_harv_ha!=. & area_meas_hectares!=.	
gen over_harvest_scaling = field_area/area_harv_ha if over_harvest == 1
bys y2_hhid plot_id: egen mean_harvest_scaling = mean(over_harvest_scaling)
replace mean_harvest_scaling =1 if missing(mean_harvest_scaling)
replace area_harv_ha = field_area if over_harvest == 1
replace area_harv_ha = area_harv_ha*mean_harvest_scaling if over_harvest == 0 
//Intercropping Scaling Code (Method 4):
bys y2_hhid plot_id: egen over_harv_plot = max(over_harvest)
gen intercropped_yn = pure_stand !=1 
gen int_f_harv = area_harv_ha if intercropped_yn==1
bys y2_hhid plot_id: egen total_area_int_sum_hv = total(int_f_harv)
bys y2_hhid plot_id: egen total_area_hv = total(area_harv_ha)
replace us_total_area_planted = total_area_hv if over_harv_plot ==1
replace us_inter_area_planted = total_area_int_sum_hv if over_harv_plot ==1
drop intercropped_yn int_f_harv total_area_int_sum_hv total_area_hv
gen intercropped_yn = pure_stand !=1 
gen mono_f_harv = area_harv_ha if intercropped_yn==0
gen int_f_harv = area_harv_ha if intercropped_yn==1
bys y2_hhid plot_id: egen total_area_int_sum_hv = total(int_f_harv)
bys y2_hhid plot_id: egen total_area_mono_hv = total(mono_f_harv)
//Oversize Plots
gen oversize_plot = total_area_mono_hv > field_area
replace oversize_plot = 1 if total_area_mono_hv >=1 & total_area_int_sum_hv >0 
bys y2_hhid plot_id: egen total_area_harv = total(area_harv_ha)	
replace area_harv_ha = (area_harv_ha/us_total_area_planted)*field_area if oversize_plot ==1 
//
gen total_area_int_hv = field_area - total_area_mono_hv
replace area_harv_ha = (int_f_harv/us_inter_area_planted)*total_area_int_hv if intercropped_yn==1 & oversize_plot !=1 
*rescaling area harvested to area planted if area harvested > area planted
ren crop_area_planted area_plan
replace area_harv_ha=. if area_harv_ha==0 //11 to missing
replace area_plan=area_harv_ha if area_plan==. & area_harv_ha!=.
*capping area harvested at area planted
count if area_harv_ha>area_plan & area_harv_ha!=. //263 observations where area harvested is greater than area planted 
replace area_harv_ha = area_plan if area_harv_ha>area_plan & area_harv_ha!=. 

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
collapse (sum) area_harv* harvest* area_plan*, by (y2_hhid zaocode)
*Saving area planted for Shannon diversity index
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_crop_area_plan_SRS.dta", replace

*Adding here total planted and harvested area summed across all plots, crops, and seasons.
preserve
collapse (sum) all_area_harvested=area_harv all_area_planted=area_plan, by(y2_hhid)
replace all_area_harvested=all_area_planted if all_area_harvested>all_area_planted & all_area_harvested!=.
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_area_planted_harvested_allcrops_SRS.dta", replace
*Append LRS
append using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_area_planted_harvested_allcrops_LRS.dta"
recode all_area_harvested all_area_planted (.=0)
collapse (sum) all_area_harvested all_area_planted, by(y2_hhid)
lab var all_area_planted "Total area planted, summed accross all plots, crops, and seasons"
lab var all_area_harvested "Total area harvested, summed accross all plots, crops, and seasons"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_area_planted_harvested_allcrops.dta", replace
restore

*merging survey weights 
merge m:1 y2_hhid using  "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhids.dta", nogen keep(1 3)
keep if inlist( zaocode, $comma_topcrop_area)
gen season="SRS"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_harvest_area_yield_SRS.dta", replace
 
*Yield at the household level
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_harvest_area_yield_LRS.dta", clear
preserve
gen season="LRS"
append using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_harvest_area_yield_SRS.dta"
recode area_plan area_harv (.=0)
collapse (sum)area_plan area_harv,by(y2_hhid zaocode)
ren area_plan total_planted_area
ren area_harv total_harv_area
tempfile area_allseasons
save `area_allseasons'
restore
merge 1:1 y2_hhid zaocode using `area_allseasons', nogen
ren  zaocode crop_code
*Adding value of crop production
merge 1:1 y2_hhid crop_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_crop_values_production.dta", nogen keep(1 3)
ren value_crop_production value_harv
ren value_crop_sales value_sold
local ncrop : word count $topcropname_area
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
collapse (firstnm) harvest* area_harv*  area_plan* total_planted_area* total_harv_area* kgs_harvest*  kgs_sold*  value_harv* value_sold* (sum) number_trees_planted_cassava number_trees_planted_banana, by(y2_hhid)
recode harvest*   area_harv* area_plan* kgs_harvest* total_planted_area* total_harv_area* kgs_sold*  value_harv* value_sold* (0=.)

*ren variable
foreach p of global topcropname_area {		
	lab var value_harv_`p' "Value harvested of `p' (household)" 
	lab var value_sold_`p' "Value sold of `p' (household)" 
	lab var kgs_harvest_`p'  "Quantity harvested of `p' (kgs) (household) (all seasons)" 
	lab var kgs_sold_`p'  "Quantity sold of `p' (kgs) (household) (all seasons)" 
	lab var total_harv_area_`p'  "Total area harvested of `p' (ha) (household) (all seasons)" 
	lab var total_planted_area_`p'  "Total area planted of `p' (ha) (household) (all seasons)" 
	lab var harvest_`p' "Quantity harvested of `p' (kgs) (household) - LRS" 
	lab var harvest_male_`p' "Quantity harvested of `p' (kgs) (male-managed plots) - LRS" 
	lab var harvest_female_`p' "Quantity harvested of `p' (kgs) (female-managed plots) - LRS" 
	lab var harvest_mixed_`p' "Quantity harvested of `p' (kgs) (mixed-managed plots) - LRS"
	lab var harvest_pure_`p' "Quantity harvested of `p' (kgs) - purestand (household - LRS)"
	lab var harvest_pure_male_`p'  "Quantity harvested of `p' (kgs) - purestand (male-managed plots) - LRS"
	lab var harvest_pure_female_`p'  "Quantity harvested of `p' (kgs) - purestand (female-managed plots) - LRS"
	lab var harvest_pure_mixed_`p'  "Quantity harvested of `p' (kgs) - purestand (mixed-managed plots) - LRS"
	lab var harvest_inter_`p' "Quantity harvested of `p' (kgs) - intercrop (household) - LRS"
	lab var harvest_inter_male_`p' "Quantity harvested of `p' (kgs) - intercrop (male-managed plots) - LRS" 
	lab var harvest_inter_female_`p' "Quantity harvested of `p' (kgs) - intercrop (female-managed plots) - LRS"
	lab var harvest_inter_mixed_`p' "Quantity harvested  of `p' (kgs) - intercrop (mixed-managed plots) - LRS"
	lab var area_harv_`p' "Area harvested of `p' (ha) (household) - LRS" 
	lab var area_harv_male_`p' "Area harvested of `p' (ha) (male-managed plots) - LRS" 
	lab var area_harv_female_`p' "Area harvested of `p' (ha) (female-managed plots) - LRS" 
	lab var area_harv_mixed_`p' "Area harvested of `p' (ha) (mixed-managed plots)"
	lab var area_harv_pure_`p' "Area harvested of `p' (ha) - purestand (household) - LRS"
	lab var area_harv_pure_male_`p'  "Area harvested of `p' (ha) - purestand (male-managed plots) - LRS"
	lab var area_harv_pure_female_`p'  "Area harvested of `p' (ha) - purestand (female-managed plots) - LRS"
	lab var area_harv_pure_mixed_`p'  "Area harvested of `p' (ha) - purestand (mixed-managed plots) - LRS"
	lab var area_harv_inter_`p' "Area harvested of `p' (ha) - intercrop (household) - LRS"
	lab var area_harv_inter_male_`p' "Area harvested of `p' (ha) - intercrop (male-managed plots) - LRS" 
	lab var area_harv_inter_female_`p' "Area harvested of `p' (ha) - intercrop (female-managed plots) - LRS"
	lab var area_harv_inter_mixed_`p' "Area harvested  of `p' (ha) - intercrop (mixed-managed plots) - LRS"
	lab var area_plan_`p' "Area planted of `p' (ha) (household) - LRS" 
	lab var area_plan_male_`p' "Area planted of `p' (ha) (male-managed plots) - LRS" 
	lab var area_plan_female_`p' "Area planted of `p' (ha) (female-managed plots) - LRS" 
	lab var area_plan_mixed_`p' "Area planted of `p' (ha) (mixed-managed plots)"
	lab var area_plan_pure_`p' "Area planted of `p' (ha) - purestand (household) - LRS"
	lab var area_plan_pure_male_`p'  "Area planted of `p' (ha) - purestand (male-managed plots) - LRS"
	lab var area_plan_pure_female_`p'  "Area planted of `p' (ha) - purestand (female-managed plots) - LRS"
	lab var area_plan_pure_mixed_`p'  "Area planted of `p' (ha) - purestand (mixed-managed plots) - LRS"
	lab var area_plan_inter_`p' "Area planted of `p' (ha) - intercrop (household) - LRS"
	lab var area_plan_inter_male_`p' "Area planted of `p' (ha) - intercrop (male-managed plots) - LRS" 
	lab var area_plan_inter_female_`p' "Area planted of `p' (ha) - intercrop (female-managed plots) - LRS"
	lab var area_plan_inter_mixed_`p' "Area planted  of `p' (ha) - intercrop (mixed-managed plots) - LRS"
}
*Household grew crop
foreach p of global topcropname_area {
	gen grew_`p'=(total_harv_area_`p'!=. & total_harv_area_`p'!=.0 ) | (total_planted_area_`p'!=. & total_planted_area_`p'!=.0)
	lab var grew_`p' "1=Household grew `p'" 
	gen harvested_`p'= (total_harv_area_`p'!=. & total_harv_area_`p'!=.0 )
	lab var harvested_`p' "1= Household harvested `p'"
}
foreach p in cassav banana { //tree/permanent crops have no area in this instrument 
	replace grew_`p' = 1 if number_trees_planted_`p'!=0 & number_trees_planted_`p'!=.
}

*Household grew crop in the LRS
foreach p of global topcropname_area {
	gen grew_`p'_lrs=(area_harv_`p'!=. & area_harv_`p'!=.0 ) | (area_plan_`p'!=. & area_plan_`p'!=.0)
	lab var grew_`p'_lrs "1=Household grew `p' in the long rainy season"
	gen harvested_`p'_lrs= (area_harv_`p'!=. & area_harv_`p'!=.0 )
	lab var harvested_`p'_lrs "1= Household harvested `p'"
}

foreach p of global topcropname_area {
	recode kgs_harvest_`p' (.=0) if grew_`p'==1 
	recode value_sold_`p' (.=0) if grew_`p'==1 
	recode value_harv_`p' (.=0) if grew_`p'==1 
}

drop harvest- harvest_pure_mixed area_harv- area_harv_pure_mixed area_plan- area_plan_pure_mixed value_harv value_sold total_planted_area total_harv_area number_trees_planted_*
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_yield_hh_crop_level.dta", replace


********************************************************************************
*SHANNON DIVERSITY INDEX
********************************************************************************
*Area planted
*Bringing in area planted for LRS
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_crop_area_plan_LRS.dta", clear
append using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_crop_area_plan_SRS.dta"
collapse (sum) area_plan*, by(y2_hhid zaocode)
*Some households have crop observations, but the area planted=0. This will give them an encs of 1 even though they report no crops. Dropping these observations
*drop if area_plan==0
drop if zaocode==.
*generating area planted of each crop as a proportion of the total area
preserve 
collapse (sum) area_plan_hh=area_plan area_plan_female_hh=area_plan_female area_plan_male_hh=area_plan_male area_plan_mixed_hh=area_plan_mixed, by(y2_hhid)
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_crop_area_plan_shannon.dta", replace
restore
merge m:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_crop_area_plan_shannon.dta", nogen		//all matched
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
bysort y2_hhid (sdi_crop_female) : gen allmissing_female = mi(sdi_crop_female[1])
bysort y2_hhid (sdi_crop_male) : gen allmissing_male = mi(sdi_crop_male[1])
bysort y2_hhid (sdi_crop_mixed) : gen allmissing_mixed = mi(sdi_crop_mixed[1])
*Generating number of crops per household
bysort y2_hhid zaocode : gen nvals_tot = _n==1
gen nvals_female = nvals_tot if area_plan_female!=0 & area_plan_female!=.
gen nvals_male = nvals_tot if area_plan_male!=0 & area_plan_male!=. 
gen nvals_mixed = nvals_tot if area_plan_mixed!=0 & area_plan_mixed!=.
collapse (sum) sdi=sdi_crop sdi_female=sdi_crop_female sdi_male=sdi_crop_male sdi_mixed=sdi_crop_mixed num_crops_hh=nvals_tot num_crops_female=nvals_female ///
num_crops_male=nvals_male num_crops_mixed=nvals_mixed (max) allmissing_female allmissing_male allmissing_mixed, by(y2_hhid)
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
gen multiple_crops = (num_crops_hh>1 & num_crops_hh!=.)
la var multiple_crops "Household grows more than one crop"

save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_shannon_diversity_index.dta", replace


********************************************************************************
*CONSUMPTION
******************************************************************************** 
use "${Tanzania_NPS_W2_raw_data}/TZY2.HH.Consumption.dta", clear
ren expmR total_cons // using real consumption-adjusted for region price disparities
gen peraeq_cons = (total_cons / adulteq)
gen daily_peraeq_cons = peraeq_cons/365
gen percapita_cons = (total_cons / hhsize)
gen daily_percap_cons = percapita_cons/365
keep y2_hhid total_cons peraeq_cons daily_peraeq_cons percapita_cons daily_percap_cons adulteq
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_consumption.dta", replace


********************************************************************************
*HOUSEHOLD FOOD PROVISION*
********************************************************************************
use "${Tanzania_NPS_W2_raw_data}/HH_SEC_I2.dta", clear
forvalues j=1/3 {
	gen food_insecurity_`j'_1 = (hh_i09_`j'_01=="X")
	gen food_insecurity_`j'_2 = (hh_i09_`j'_02=="X")
	gen food_insecurity_`j'_3 = (hh_i09_`j'_03=="X")
	gen food_insecurity_`j'_4 = (hh_i09_`j'_04=="X")
	gen food_insecurity_`j'_5 = (hh_i09_`j'_05=="X")
	gen food_insecurity_`j'_6 = (hh_i09_`j'_06=="X")
	gen food_insecurity_`j'_7 = (hh_i09_`j'_07=="X")
	gen food_insecurity_`j'_8 = (hh_i09_`j'_08=="X")
	gen food_insecurity_`j'_9 = (hh_i09_`j'_09=="X")
	gen food_insecurity_`j'_10 = (hh_i09_`j'_10=="X")
	gen food_insecurity_`j'_11 = (hh_i09_`j'_11=="X")
	gen food_insecurity_`j'_12 = (hh_i09_`j'_12=="X")
}
egen months_food_insec = rowtotal(food_insecurity_*) 
replace months_food_insec = 12 if months_food_insec>12
la var months_food_insec "Number of months in the past year when the HH has experienced food insecurity"
keep months_food_insec y2_hhid
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_food_insecurity.dta", replace



********************************************************************************
*HOUSEHOLD ASSETS*
********************************************************************************
//Cannot be calculated for W2


********************************************************************************
*HOUSEHOLD VARIABLES
********************************************************************************
global empty_vars "" 
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhids.dta", clear

*Gross crop income 
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_crop_production.dta", nogen keep (1 3)
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_losses.dta", nogen keep (1 3)
recode value_crop_production crop_value_lost (.=0)

*Crop costs
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_asset_rental_costs.dta", nogen keep (1 3)
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_land_rental_costs.dta", nogen keep (1 3)
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_seed_costs.dta", nogen keep (1 3)
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fertilizer_costs.dta", nogen keep (1 3)
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_wages_shortseason.dta", nogen keep (1 3)
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_wages_mainseason.dta", nogen keep (1 3)
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_transportation_cropsales.dta", nogen keep (1 3)
recode rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor rental_cost_land cost_seed value_fertilizer /*
*/ value_herb_pest wages_paid_short wages_paid_main transport_costs_cropsales (.=0)
egen crop_production_expenses = rowtotal(rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor rental_cost_land cost_seed value_fertilizer /*
*/ value_herb_pest wages_paid_short wages_paid_main transport_costs_cropsales)
gen crop_income = value_crop_production - crop_production_expenses - crop_value_lost
lab var crop_production_expenses "Crop production expenditures (explicit)"
lab var crop_income "Net crop revenue"
drop rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor value_herb_pest wages_paid_short wages_paid_main transport_costs_cropsales rental_cost_land value_fertilizer value_manure_purchased

*top crop costs by area planted
foreach c in $topcropname_area {
	merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_land_rental_costs_`c'.dta", nogen keep (1 3)
	merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fertilizer_costs_`c'.dta", nogen keep (1 3)
	merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_`c'_monocrop_hh_area.dta", nogen keep (1 3)
}

foreach c in $topcropname_short{
	merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_wages_shortseason_`c'.dta", nogen keep (1 3)
}

foreach c in $topcropname_annual{
	merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_seed_costs_`c'.dta", nogen keep (1 3)
	merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_wages_mainseason_`c'.dta", nogen keep (1 3)
}
*generate missing vars
gen wages_paid_short_banana = .		
gen wages_paid_short_yam = .
gen wages_paid_short_wheat = . 		
gen cost_seed_cassav = .
gen cost_seed_banana = .
gen wages_paid_main_cassav = .
gen wages_paid_main_banana = .

foreach i in male female mixed{
	gen wages_paid_short_banana_`i'=.
	gen wages_paid_short_yam_`i'=.
	gen wages_paid_short_wheat_`i'=.
	gen wages_paid_main_cassav_`i'=.
	gen wages_paid_main_banana_`i'=.
	gen cost_seed_cassav_`i'=.
	gen cost_seed_banana_`i'=.
}

foreach c in $topcropname_area {
	recode `c'_monocrop (.=0)	
	egen `c'_exp = rowtotal(rental_cost_land_`c' cost_seed_`c' value_fertilizer_`c' value_herb_pest_`c' wages_paid_short_`c' wages_paid_main_`c')
	lab var `c'_exp "Crop production expenditures (explicit) - Monocropped `c' plots only"
	la var `c'_monocrop_ha "Total `c' monocrop hectares planted - Household"		

	*disaggregate by gender of plot manager
	foreach i in male female mixed{
		egen `c'_exp_`i' = rowtotal(rental_cost_land_`c'_`i' cost_seed_`c'_`i' value_fertilizer_`c'_`i' value_herb_pest_`c'_`i' wages_paid_short_`c'_`i' wages_paid_main_`c'_`i')
		local l`c'_exp_`i' : var lab `c'_exp
		la var `c'_exp_`i' "`lcrop_exp_`c'_`i'' - `i' managed plots"
	}

	replace `c'_exp = . if `c'_monocrop_ha==.			// set to missing if the household does not have any monocropped plots
	foreach i in male female mixed{
		replace `c'_exp_`i' = . if `c'_monocrop_ha_`i'==.
	}
}

drop rental_cost_land_* value_herb_pest_* wages_paid_short_* wages_paid_main_* cost_seed_* value_fertilizer_*

*land rights
merge 1:1 y2_hhid using  "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_land_rights_hh.dta", nogen keep (1 3)
la var formal_land_rights_hh "Household has documentation of land rights (at least one plot)"

*Livestock income
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_sales", nogen keep (1 3)
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_livestock_products", nogen keep (1 3)
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_dung.dta", nogen keep (1 3)
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_expenses", nogen keep (1 3)
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_TLU.dta", nogen keep (1 3)
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_herd_characteristics", nogen keep (1 3)
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_TLU_Coefficients.dta", nogen keep (1 3)
gen livestock_income = value_slaughtered + value_lvstck_sold - value_livestock_purchases /*
*/ + (value_milk_produced + value_eggs_produced + value_other_produced + sales_dung) /*
*/ - (cost_hired_labor_livestock + cost_fodder_livestock)
lab var livestock_income "Net livestock income"
gen livestock_expenses = cost_hired_labor_livestock + cost_fodder_livestock
gen ls_exp_vac = . 
foreach i in lrum srum poultry {
	gen ls_exp_vac_`i' = .
}
lab var livestock_expenses "Livestock Production expenditures (explicit)"
drop value_livestock_purchases value_other_produced sales_dung cost_hired_labor_livestock cost_fodder_livestock
lab var sales_livestock_products "Value of sales of livestock products"
lab var value_livestock_products "Value of livestock products"
global empty_vars $empty_vars *ls_exp_vac* 

*Fish income
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_income.dta", nogen keep (1 3)
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fishing_expenses_1.dta", nogen keep (1 3)
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fishing_expenses_2.dta", nogen keep (1 3)
gen fishing_income = value_fish_harvest - cost_fuel - rental_costs_fishing - cost_paid
lab var fishing_income "Net fish income"
drop cost_fuel rental_costs_fishing cost_paid

*Self-employment income
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_self_employment_income.dta", nogen keep (1 3)
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_trading_income.dta", nogen keep (1 3)
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_agproducts_profits.dta", nogen keep (1 3)
egen self_employment_income = rowtotal(annual_selfemp_profit fish_trading_income byproduct_profits)
lab var self_employment_income "Income from self-employment"
drop annual_selfemp_profit fish_trading_income byproduct_profits 

*Wage income
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_wage_income.dta", nogen keep (1 3)
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_agwage_income.dta", nogen keep (1 3)
recode annual_salary annual_salary_agwage (.=0)
ren annual_salary nonagwage_income
ren annual_salary_agwage agwage_income

*off-farm hours
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_off_farm_hours.dta", nogen keep (1 3)

*Other income
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_other_income.dta", nogen keep (1 3)
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_land_rental_income.dta", nogen keep (1 3)
egen transfers_income = rowtotal (pension_income remittance_income assistance_income)
lab var transfers_income "Income from transfers including pension, remittances, and assisances)"
egen all_other_income = rowtotal (rental_income other_income  land_rental_income)
lab var all_other_income "Income from other revenue"
drop pension_income remittance_income assistance_income rental_income other_income land_rental_income

*Farm size
merge 1:1 y2_hhid using  "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_land_size.dta", nogen keep (1 3)
merge 1:1 y2_hhid using  "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_land_size_all.dta", nogen keep (1 3)
merge 1:1 y2_hhid using  "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_farmsize_all_agland.dta", nogen keep (1 3)
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_land_size_total.dta", nogen
recode land_size (.=0)

*farm size categories
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
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_family_hired_labor.dta", nogen keep (1 3)
recode labor_hired labor_family (.=0) 
 
*Household size
merge 1:1 y2_hhid using  "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhsize.dta", nogen keep (1 3)
 
*Rates of vaccine usage, improved seeds, etc.
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_vaccine.dta", nogen keep (1 3)
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fert_use.dta", nogen keep (1 3)
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_improvedseed_use.dta", nogen keep (1 3)
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_any_ext.dta", nogen keep (1 3)
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fin_serv.dta", nogen keep (1 3)

*Variables: use_fin_serv ext_reach use_inorg_fert vac_animal
recode use_fin_serv* ext_reach* use_inorg_fert imprv_seed_use vac_animal (.=0)
replace vac_animal=. if tlu_today==0 
replace use_inorg_fert=. if farm_area==0 | farm_area==. // Area cultivated this year
recode ext_reach* (0 1=.) if (value_crop_production==0 & livestock_income==0 & farm_area==0 & tlu_today==0)
recode ext_reach* (0 1=.) if farm_area==.
replace imprv_seed_use=. if farm_area==.
global empty_vars $empty_vars imprv_seed_cassav imprv_seed_banana hybrid_seed_*

*Milk productivity
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_milk_animals.dta", nogen  keep (1 3)
gen costs_dairy = .
gen costs_dairy_percow = .
gen share_imp_dairy = . 
gen liters_per_cow = . 
gen liters_per_buffalo = . 
lab var costs_dairy "Livestock expense for large ruminants producing dairy"
global empty_vars $empty_vars *costs_dairy* *costs_dairy_percow* share_imp_dairy *liters_per_cow *liters_per_buffalo

*Egg productivity
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_eggs_animals.dta", nogen keep (1 3)
gen egg_poultry_year = . 
global empty_vars $empty_vars *egg_poultry_year

*Costs of crop production per hectare
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_cropcosts_total.dta", nogen keep (1 3)

*Rate of fertilizer application 
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fertilizer_application.dta", nogen keep (1 3)

*Agricultural wage rate
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_ag_wage.dta", nogen keep (1 3)

*Crop yields 
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_yield_hh_crop_level.dta", nogen keep (1 3)

*total area planted and harvested accross all crops, plots, and seasons
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_area_planted_harvested_allcrops.dta", nogen keep (1 3)

*household diet
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_household_diet.dta", nogen keep (1 3)

*Consumption
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_consumption.dta", nogen keep (1 3)

*Household assets
gen value_assets=. 
global empty_vars $empty_vars value_assets* 
 
*Household food provision
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_food_insecurity.dta", nogen keep (1 3)
gen hhs_little = . 
gen hhs_moderate = . 
gen hhs_severe = . 
gen hhs_total = . 
global empty_vars $empty_vars hhs_* 

*Distance to agrodealer // cannot construct 
 gen dist_agrodealer = . 
 global empty_vars $empty_vars *dist_agrodealer

*Livestock health
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_diseases.dta", nogen

*livestock feeding, water, and housing
*cannot construct generate missing
gen feed_grazing = .
gen water_source_nat = .
gen water_source_const = .
gen water_source_cover = .
gen lvstck_housed = .
foreach v in feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed{
	foreach i in lrum srum poultry {
		gen `v'_`i' = . 
	}
}
global empty_vars $empty_vars feed_grazing* water_source* lvstck_housed*

*Shannon diversity index
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_shannon_diversity_index.dta", nogen

*Farm Production 
gen value_farm_production = value_crop_production + value_livestock_products + value_slaughtered + value_lvstck_sold
lab var value_farm_production "Total value of farm production (crops + livestock products)"
gen value_farm_prod_sold = value_crop_sales + sales_livestock_products + value_livestock_sales 
lab var value_farm_prod_sold "Total value of farm production that is sold" 
replace value_farm_prod_sold = 0 if value_farm_prod_sold==. & value_farm_production!=.

*Agricultural households
recode value_crop_production livestock_income farm_area tlu_today (.=0)
gen ag_hh = (value_crop_production!=0 | crop_income!=0 | livestock_income!=0 | farm_area!=0 | tlu_today!=0)
lab var ag_hh "1= Household has some land cultivated, some livestock, some crop income, or some livestock income"

*households engaged in egg production
gen egg_hh = (value_eggs_produced>0 & value_eggs_produced!=.)
lab var egg_hh "1=Household engaged in egg production"
*household engaged in dairy production
gen dairy_hh = (value_milk_produced>0 & value_milk_produced!=.)
lab var dairy_hh "1= Household engaged in dairy production" 

*Households engaged in ag activities including working in paid ag jobs
gen agactivities_hh =ag_hh==1 | (agwage_income!=0 & agwage_income!=.)
lab var agactivities_hh "1=Household has some land cultivated, livestock, crop income, livestock income, or ag wage income"

*creating crop household and livestock household
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
foreach cn in $topcropname_area{
	recode value_harv_`cn' value_sold_`cn' kgs_harvest_`cn' total_planted_area_`cn' total_harv_area_`cn' `cn'_exp (.=0) if grew_`cn'==1
	recode value_harv_`cn' value_sold_`cn' kgs_harvest_`cn' total_planted_area_`cn' total_harv_area_`cn' `cn'_exp (nonmissing=.) if grew_`cn'==0
}

*households engaged in monocropped production of specific crops
 foreach cn in $topcropname_area {
	recode `cn'_monocrop (.=0)
	foreach g in male female mixed {
		recode `cn'_monocrop_`g' (.=0)
	}
}
foreach cn in $topcropname_area {
	recode `cn'_exp `cn'_monocrop_ha (.=0) if `cn'_monocrop==1
	recode `cn'_exp `cn'_monocrop_ha (nonmissing=.) if `cn'_monocrop==0
	foreach g in male female mixed {
			recode `cn'_exp_`g' `cn'_monocrop_ha_`g' (.=0) if `cn'_monocrop_`g'==1
			recode `cn'_exp_`g' `cn'_monocrop_ha_`g' (nonmissing=.) if `cn'_monocrop_`g'==0
	}
}

*all rural households engaged in livestcok production of a given species
foreach i in lrum srum poultry{
	recode lost_disease_`i' ls_exp_vac_`i' disease_animal_`i' feed_grazing_`i' water_source_nat_`i' water_source_const_`i' water_source_cover_`i' lvstck_housed_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode lost_disease_`i' ls_exp_vac_`i' disease_animal_`i' feed_grazing_`i' water_source_nat_`i' water_source_const_`i' water_source_cover_`i' lvstck_housed_`i'(.=0) if lvstck_holding_`i'==1	
}
*households engaged in crop production
recode cost_expli_hh value_crop_production value_crop_sales labor_hired labor_family farm_size_agland all_area_harvested all_area_planted (.=0) if crop_hh==1
recode cost_expli_hh value_crop_production value_crop_sales labor_hired labor_family farm_size_agland all_area_harvested all_area_planted (nonmissing=.) if crop_hh==0
*all rural households engaged in livestock production 
recode animals_lost12months* mean_12months* livestock_expenses disease_animal feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed (.=0) if livestock_hh==1
recode animals_lost12months* mean_12months* livestock_expenses disease_animal feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed (nonmissing=.) if livestock_hh==0
*all rural households 
recode off_farm_hours crop_income livestock_income self_employment_income nonagwage_income agwage_income fishing_income transfers_income all_other_income /*value_assets*/ (.=0)
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
*/ animals_lost12months* mean_12months* lost_disease* /*
*/ liters_milk_produced costs_dairy /*
*/ eggs_total_year value_eggs_produced value_milk_produced egg_poultry_year /*
*/ off_farm_hours crop_production_expenses value_assets cost_expli_hh /*
*/ livestock_expenses ls_exp_vac* sales_livestock_products value_livestock_products value_livestock_sales /*
*/ value_farm_production value_farm_prod_sold 

foreach v of varlist $wins_var_top1 {
	_pctile `v' [aw=weight] , p($wins_upper_thres) 
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
global wins_var_top1_gender $wins_var_top1_gender cost_total cost_expli fert_inorg_kg wage_paid_aglabor
gen wage_paid_aglabor_female=. 
gen wage_paid_aglabor_male=.
gen wage_paid_aglabor_mixed=. 
lab var wage_paid_aglabor_female "Daily wage in agricuture - female workers"
lab var wage_paid_aglabor_male "Daily wage in agricuture - male workers"
global empty_vars $empty_vars *wage_paid_aglabor_female* *wage_paid_aglabor_male* 

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
egen w_labor_total=rowtotal(w_labor_hired w_labor_family)
local llabor_total : var lab labor_total 
lab var w_labor_total "`llabor_total' - Winzorized top 1%"

*Variables winsorized both at the top 1% and bottom 1% 
global wins_var_top1_bott1  /* 
*/ farm_area farm_size_agland all_area_harvested all_area_planted ha_planted /*
*/ crop_income livestock_income fishing_income self_employment_income nonagwage_income agwage_income transfers_income all_other_income total_cons percapita_cons daily_percap_cons peraeq_cons daily_peraeq_cons /*
*/ *_monocrop_ha* dist_agrodealer land_size_total

foreach v of varlist $wins_var_top1_bott1 {
	_pctile `v' [aw=weight] , p($wins_lower_thres $wins_upper_thres) 
	gen w_`v'=`v'
	replace w_`v'= r(r1) if w_`v' < r(r1) & w_`v'!=. & w_`v'!=0  
	replace w_`v'= r(r2) if  w_`v' > r(r2)  & w_`v'!=.		
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top and bottom 1%"
	*some vriables  are disaggreated by gender of plot manager. For these variables, we use the top and bottom 1% percentile to winsorize gender-disagregated variables
	if "`v'"=="ha_planted" {
		foreach g of global gender {
			gen w_`v'_`g'=`v'_`g'
			replace w_`v'_`g'= r(r1) if w_`v'_`g' < r(r1) & w_`v'_`g'!=. & w_`v'_`g'!=0  
			replace w_`v'_`g'= r(r2) if  w_`v'_`g' > r(r2)  & w_`v'_`g'!=.		
			local l`v'_`g' : var lab `v'_`g'
			lab var  w_`v'_`g'  "`l`v'_`g'' - Winzorized top and bottom 1%"		
		}		
	}
}

*area_harv  and area_plan are also winsorized both at the top 1% and bottom 1% because we need to treat at the crop level
global allyield male female mixed inter inter_male inter_female inter_mixed pure  pure_male pure_female pure_mixed
global wins_var_top1_bott1_2 area_harv  area_plan harvest 
foreach v of global wins_var_top1_bott1_2 {
	foreach c of global topcropname_area {	
		_pctile `v'_`c'  [aw=weight] , p($wins_lower_thres $wins_upper_thres)
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
lab var cost_total_ha "Explicit + implicit costs (per ha) of crop production (household level)"
lab var cost_total_ha_male "Explicit + implicit costs (per ha) of crop production (male-managed plots)"
lab var cost_total_ha_female "Explicit + implicit costs (per ha) of crop production (female-managed plots)"
lab var cost_total_ha_mixed "Explicit + implicit costs (per ha) of crop production (mixed-managed plots)"
lab var cost_expli_ha "Explicit costs (per ha) of crop production (household level)"
lab var cost_expli_ha_male "Explicit costs (per ha) of crop production (male-managed plots)"
lab var cost_expli_ha_female "Explicit costs (per ha) of crop production (female-managed plots)"
lab var cost_expli_ha_mixed "Explicit costs (per ha) of crop production (mixed-managed plots)"

*mortality rate
global animal_species lrum srum pigs equine  poultry 
foreach s of global animal_species {
	gen mortality_rate_`s' = animals_lost12months_`s'/mean_12months_`s'
	lab var mortality_rate_`s' "Mortality rate - `s'"
}

*generating top crop expenses using winsorized values (monocropped)
foreach c in $topcropname_area{		
	gen `c'_exp_ha =w_`c'_exp/w_`c'_monocrop_ha
	la var `c'_exp_ha "Costs per hectare - Monocropped `c' plots"
	foreach  g of global gender{
		local l`c'_exp_ha : var lab `c'_exp_ha
		gen `c'_exp_ha_`g' =w_`c'_exp_`g'/w_`c'_monocrop_ha_`g'
		lab var `c'_exp_ha_`g' "l`c'_exp_ha' - `g' managed plots"
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

*milk productivity 
gen liters_per_largeruminant=.
lab var liters_per_largeruminant "Average quantity (liters) per year (household)"
global empty_vars $empty_vars *liters_per_largeruminant
*unit cost of production
*all top crops
foreach c in $topcropname_area{
	gen `c'_exp_kg = w_`c'_exp/w_kgs_harv_mono_`c' 
	la var `c'_exp_kg "Costs per kg - Monocropped `c' plots"
	foreach g of global gender {
		gen `c'_exp_kg_`g'=w_`c'_exp_`g'/ w_kgs_harv_mono_`c'_`g'
		lab var `c'_exp_kg_`g' "l`c'_exp_kg' - `g' managed plots"
}
}

*dairy
gen cost_per_lit_milk = w_costs_dairy/w_liters_milk_produced  
lab var cost_per_lit_milk "Cost per liter of milk"
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
recode off_farm_hours_pc_all (.=0)
*households engaged in monocropped production of specific crops
forvalues k=1/$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode `cn'_exp `cn'_exp_ha `cn'_exp_kg (.=0) if `cn'_monocrop==1
	recode `cn'_exp `cn'_exp_ha `cn'_exp_kg (nonmissing=.) if `cn'_monocrop==0
}
*all rural households growing specific crops (in the long rainy season) 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_pl_`cn' (.=0) if grew_`cn'_lrs==1 //only reporting LRS yield so only replace if grew in LRS
	recode yield_pl_`cn' (nonmissing=.) if grew_`cn'_lrs==0 //only reporting LRS yield so only replace if grew in LRS
}
*all rural households harvesting specific crops (in the long rainy season)
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_hv_`cn' (.=0) if harvested_`cn'_lrs==1 //only reporting LRS yield so only replace if grew in LRS
	recode yield_hv_`cn' (nonmissing=.) if harvested_`cn'_lrs==0 //only reporting LRS yield so only replace if grew in LRS
}

*households growing specific crops that have also purestand plots of that crop 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_pl_pure_`cn' (.=0) if grew_`cn'_lrs==1 & w_area_plan_pure_`cn'!=. //only reporting LRS yield so only replace if grew in LRS
	recode yield_pl_pure_`cn' (nonmissing=.) if grew_`cn'_lrs==0 | w_area_plan_pure_`cn'==.  //only reporting LRS yield so only replace if grew in LRS
}
*all rural households harvesting specific crops (in the long rainy season) that also have purestand plots 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_hv_pure_`cn' (.=0) if harvested_`cn'_lrs==1 & w_area_plan_pure_`cn'!=. //only reporting LRS yield so only replace if grew in LRS
	recode yield_hv_pure_`cn' (nonmissing=.) if harvested_`cn'_lrs==0 | w_area_plan_pure_`cn'==.  //only reporting LRS yield so only replace if grew in LRS
}
*households engaged in dairy production 
recode costs_dairy_percow cost_per_lit_milk (.=0) if dairy_hh==1
recode costs_dairy_percow cost_per_lit_milk (nonmissing=.) if dairy_hh==0


*now winsorize ratios only at top 1% 
global wins_var_ratios_top1 inorg_fert_rate cost_total_ha cost_expli_ha cost_expli_hh_ha /* 
*/ land_productivity labor_productivity /*
*/ mortality_rate* liters_per_largeruminant costs_dairy_percow liters_per_cow liters_per_buffalo /*
*/ off_farm_hours_pc_all off_farm_hours_pc_any cost_per_lit_milk 

foreach v of varlist $wins_var_ratios_top1 {
	_pctile `v' [aw=weight] , p($wins_upper_thres) 
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top 1%"

	*some variables  are disaggreated by gender of plot manager. For these variables, we use the top 1% percentile to winsorize gender-disagregated variables
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
foreach c of global topcropname_area {  //ERE adding topcropname_area global here
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
*/ formal_land_rights_hh w_off_farm_hours_pc_all months_food_insec /*
*/ lvstck_holding_tlu lvstck_holding_all lvstck_holding_lrum lvstck_holding_srum lvstck_holding_poultry (.=0) if rural==1 
 
*all rural households engaged in livestock production
recode vac_animal w_share_livestock_prod_sold livestock_expenses w_livestock_expenses w_ls_exp_vac any_imp_herd_all (. = 0) if livestock_hh==1 
recode vac_animal w_share_livestock_prod_sold livestock_expenses w_livestock_expenses w_ls_exp_vac any_imp_herd_all (nonmissing = .) if livestock_hh==0 

*all rural households engaged in livestcok production of a given species
foreach i in lrum srum poultry{
	recode vac_animal_`i' any_imp_herd_`i' w_lost_disease_`i' w_ls_exp_vac_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode vac_animal_`i' any_imp_herd_`i' w_lost_disease_`i' w_ls_exp_vac_`i' (.=0) if lvstck_holding_`i'==1	
}

*households engaged in crop production
recode w_proportion_cropvalue_sold w_farm_size_agland w_labor_family w_labor_hired /*
*/ imprv_seed_use use_inorg_fert w_labor_productivity w_land_productivity /*
*/ w_inorg_fert_rate* w_cost_expli* w_cost_total* /*
*/ w_value_crop_production w_value_crop_sales w_all_area_planted w_all_area_harvested /*
*/ encs* num_crops* multiple_crops (.=0) if crop_hh==1
recode w_proportion_cropvalue_sold w_farm_size_agland w_labor_family w_labor_hired /*
*/ imprv_seed_use use_inorg_fert w_labor_productivity w_land_productivity /*
*/ w_inorg_fert_rate* w_cost_expli* w_cost_total* /*
*/ w_value_crop_production w_value_crop_sales w_all_area_planted w_all_area_harvested /*
*/ encs* num_crops* multiple_crops (nonmissing= . ) if crop_hh==0
		
*hh engaged in crop or livestock production
recode ext_reach* (.=0) if (crop_hh==1 | livestock_hh==1)
recode ext_reach* (nonmissing=.) if crop_hh==0 & livestock_hh==0

*all rural households growing specific crops 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode imprv_seed_`cn' hybrid_seed_`cn' /*
	*/ w_value_harv_`cn' w_value_sold_`cn' w_kgs_harvest_`cn' w_total_planted_area_`cn' w_total_harv_area_`cn' (.=0) if grew_`cn'==1
	recode imprv_seed_`cn' hybrid_seed_`cn' /*
	*/ w_value_harv_`cn' w_value_sold_`cn' w_kgs_harvest_`cn' w_total_planted_area_`cn' w_total_harv_area_`cn' (nonmissing=.) if grew_`cn'==0
}
	
*all rural households growing specific crops (in the long rainy season)
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode w_yield_pl_`cn' (.=0) if grew_`cn'_lrs==1
	recode w_yield_pl_`cn' (nonmissing=.) if grew_`cn'_lrs==0
}
*all rural households that harvested specific crops (in the long rainy season)
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode w_yield_hv_`cn' (.=0) if harvested_`cn'_lrs==1
	recode w_yield_hv_`cn' (nonmissing=.) if harvested_`cn'_lrs==0
}

*households engaged in monocropped production of specific crops
forvalues k=1/$nb_topcrops {
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

*Convert monetary values to 2016 Purchasing Power Parity international dollars
global topcrop_monetary=""
foreach v in $topcropname_area {
	global topcrop_monetary $topcrop_monetary `v'_exp `v'_exp_ha `v'_exp_kg
	
	foreach g in $gender{
	global topcrop_monetary $topcrop_monetary `v'_exp_`g' `v'_exp_ha_`g' `v'_exp_kg_`g'
	}
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
gen weight_milk= . // cannot create in this instrument  
gen weight_egg= . // cannot create in this instrument
gen milk_animals=.	//cannot create in this instrument  
gen poultry_owned=.	//cannot create in this instrument  
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

*Rural poverty headcount ratio
*First, we convert $1.90/day to local currency in 2011 using https://data.worldbank.org/indicator/PA.NUS.PRVT.PP?end=2011&locations=TZ&start=1990
	// 1.90 * 585.52 = 1112.488  
*NOTE: this is using the "Private Consumption, PPP" conversion factor because that's what we have been using. 
* This can be changed this to the "GDP, PPP" if we change the rest of the conversion factors.
*The global poverty line of $1.90/day is set by the World Bank
*http://www.worldbank.org/en/topic/poverty/brief/global-poverty-line-faq
*Second, we inflate the local currency to the year that this survey was carried out using the CPI inflation rate using https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2017&locations=TZ&start=2003
	// 1+(112.691 - 112.691)/ 112.691 = 1	
	// 1112.488* 1 = 1112.488 TSH
*NOTE: if the survey was carried out over multiple years we use the last year
*This is the poverty line at the local currency in the year the survey was carried out

gen poverty_under_1_9 = (daily_percap_cons<1112.488)
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
gen ccf_loc = (1+$Tanzania_NPS_W2_inflation) 
lab var ccf_loc "currency conversion factor - 2016 $TSH"
gen ccf_usd = (1+$Tanzania_NPS_W2_inflation) / $Tanzania_NPS_W2_exchange_rate 
lab var ccf_usd "currency conversion factor - 2016 $USD"
gen ccf_1ppp = (1+$Tanzania_NPS_W2_inflation) / $Tanzania_NPS_W2_cons_ppp_dollar 
lab var ccf_1ppp "currency conversion factor - 2016 $Private Consumption PPP"
gen ccf_2ppp = (1+$Tanzania_NPS_W2_inflation) / $Tanzania_NPS_W2_gdp_ppp_dollar
lab var ccf_2ppp "currency conversion factor - 2016 $GDP PPP"


*Cleaning up output to get below 5,000 variables
*dropping unnecessary variables and recoding to missing any variables that cannot be created in this instrument
drop *_inter_* harvest_* w_harvest_*

*Removing intermediate variables to get below 5,000 vars
keep y2_hhid fhh clusterid strataid *weight* *wgt* region district ward ea rural farm_size* *total_income* /*
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

*replace vars that cannot be created with .
*empty crop vars (cassava and banana - no area information for permanent crops) 
global empty_vars $empty_vars *yield_*_cassav *yield_*_banana *total_planted_area_cassav *total_harv_area_cassav *total_planted_area_banana *total_harv_area_banana *cassav_exp_ha* *banana_exp_ha*

*replace empty vars with missing 
foreach v of varlist $empty_vars { 
	replace `v' = .
}
	
//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
ren y2_hhid hhid
gen hhid_panel=hhid
lab var hhid_panel "panel HH identifier" 
gen geography = "Tanzania"
gen survey = "LSMS-ISA"
gen year = "2010-11" 
gen instrument = 12
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
saveold "${Tanzania_NPS_W2_final_data}/Tanzania_NPS_W2_household_variables.dta", replace


********************************************************************************
*INDIVIDUAL-LEVEL VARIABLES
********************************************************************************
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_person_ids.dta", clear
merge m:1 y2_hhid   using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_household_diet.dta", nogen
merge 1:1 y2_hhid indidy2 using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_control_income.dta", nogen  keep(1 3)
merge 1:1 y2_hhid indidy2 using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_make_ag_decision.dta", nogen  keep(1 3)
merge 1:1 y2_hhid indidy2 using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_ownasset.dta", nogen  keep(1 3)
merge m:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhsize.dta", nogen keep (1 3)
merge 1:1 y2_hhid indidy2 using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_farmer_fert_use.dta", nogen  keep(1 3)
merge 1:1 y2_hhid indidy2 using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_farmer_improvedseed_use.dta", nogen  keep(1 3)
merge 1:1 y2_hhid indidy2 using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_farmer_vaccine.dta", nogen  keep(1 3)
merge m:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhids.dta", nogen keep (1 3)
*Adding land rights
merge 1:1 y2_hhid indidy2 using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_land_rights_ind.dta", nogen
recode formal_land_rights_f (.=0) if female==1	
la var formal_land_rights_f "Individual has documentation of land rights (at least one plot) - Women only"
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

*getting correct subpopulations (women aged 18 or above in rural households) 
recode control_all_income make_decision_ag own_asset formal_land_rights_f (.=0) if female==1 
recode control_all_income make_decision_ag own_asset formal_land_rights_f (nonmissing=.) if female==0

* NA in TZA NPS_LSMS-ISA
gen women_diet=.
replace number_foodgroup=.
foreach v of varlist *hybrid_seed*{
	replace `v' = .
}

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
ren y2_hhid hhid
gen hhid_panel=hhid
ren indidy2 indid
gen geography = "Tanzania"
gen survey = "LSMS-ISA"
gen year = "2010-11" 
gen instrument = 12
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
preserve
	use "${Tanzania_NPS_W2_final_data}/Tanzania_NPS_W2_household_variables.dta", clear
	keep hhid ag_hh
	tempfile ag_hh
	save `ag_hh'
restore
merge m:1 hhid using `ag_hh', nogen keep (1 3)
replace   make_decision_ag =. if ag_hh==0
saveold "${Tanzania_NPS_W2_final_data}/Tanzania_NPS_W2_individual_variables.dta", replace
 
 

********************************************************************************
*PLOT -LEVEL VARIABLES
********************************************************************************
*GENDER PRODUCTIVITY GAP (PLOT LEVEL)
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_cropvalue.dta", clear
merge 1:1 y2_hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_areas.dta", keep (1 3) nogen
merge 1:1 y2_hhid plot_id  using  "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_decision_makers.dta", keep (1 3) nogen
merge m:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhids.dta", keep (1 3) nogen
merge 1:1 y2_hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_family_hired_labor.dta", keep (1 3) nogen
replace area_meas_hectares=area_est_hectares if area_meas_hectares==.

*winsorize area_meas_hectares and labor_total at top and bottom 1%
keep if cultivated==1
global winsorize_vars area_meas_hectares  labor_total  
foreach p of global winsorize_vars { 
	gen w_`p' =`p'
	local l`p' : var lab `p'
	_pctile w_`p'   [aw=weight] if w_`p'!=0 , p($wins_lower_thres $wins_upper_thres)    
	replace w_`p' = r(r1) if w_`p' < r(r1)  & w_`p'!=. & w_`p'!=0
	replace w_`p' = r(r2) if w_`p' > r(r2)  & w_`p'!=.
	lab var w_`p' "`l`p'' - Winsorized top and bottom 1%"
}
 
*winsorize plot_value_harvest at top  1% only 
_pctile plot_value_harvest  [aw=weight] , p($wins_upper_thres) 
gen w_plot_value_harvest=plot_value_harvest
replace w_plot_value_harvest = r(r1) if w_plot_value_harvest > r(r1) & w_plot_value_harvest != . 
lab var w_plot_value_harvest "Value of crop harvest on this plot - Winsorized top 1%"
*generate land and labor productivity using winsorized values
gen plot_productivity = w_plot_value_harvest/ w_area_meas_hectares
lab var plot_productivity "Plot productivity Value production/hectare"
*now same for  productivity at the plot level
gen plot_labor_prod = w_plot_value_harvest/w_labor_total  	
lab var plot_labor_prod "Plot labor productivity (value production/labor-day)"
*winsorize both land and labor productivity at top 1% only
gen plot_weight=w_area_meas_hectares*weight //generate plot weights using winsorized values for area_meas_hectares
lab var plot_weight "Weight for plots (weighted by plot area)"
foreach v of varlist  plot_productivity  plot_labor_prod {
	_pctile `v' [aw=plot_weight] , p($wins_upper_thres) 
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top 1%"
}	

*convert monetary values to USD and PPP
global monetary_val plot_value_harvest plot_productivity  plot_labor_prod 
foreach p of global monetary_val {
	gen `p'_usd=(1+$Tanzania_NPS_W2_inflation) * `p' / $Tanzania_NPS_W2_exchange_rate
	gen `p'_1ppp=(1+$Tanzania_NPS_W2_inflation) * `p' / $Tanzania_NPS_W2_cons_ppp_dollar
	gen `p'_2ppp=(1+$Tanzania_NPS_W2_inflation) * `p' / $Tanzania_NPS_W2_gdp_ppp_dollar
	gen `p'_loc = (1+$Tanzania_NPS_W2_inflation) * `p' 
	local l`p' : var lab `p' 
	lab var `p'_1ppp "`l`p'' (2016 $ Private Consumption PPP)"
	lab var `p'_2ppp "`l`p'' (2016 $ GDP PPP)"
	lab var `p'_usd "`l`p'' (2016 $ USD)"
	lab var `p'_loc "`l`p'' (2016 TSH)"  
	lab var `p' "`l`p'' (TSH)" 
	gen w_`p'_usd=(1+$Tanzania_NPS_W2_inflation) * w_`p' / $Tanzania_NPS_W2_exchange_rate
	gen w_`p'_1ppp=(1+$Tanzania_NPS_W2_inflation) * w_`p' / $Tanzania_NPS_W2_cons_ppp_dollar
	gen w_`p'_2ppp=(1+$Tanzania_NPS_W2_inflation) * `p' / $Tanzania_NPS_W2_gdp_ppp_dollar
	gen w_`p'_loc = (1+$Tanzania_NPS_W2_inflation) * w_`p'
	local lw_`p' : var lab w_`p' 
	lab var w_`p'_1ppp "`lw_`p'' (2016 $ Private Consumption  PPP)"
	lab var w_`p'_2ppp "`l`p'' (2016 $ GDP PPP)"
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

foreach i in 1ppp 2ppp loc {
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

gen plot_labor_weight= w_labor_total*weight

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
ren y2_hhid hhid
gen hhid_panel=hhid
gen geography = "Tanzania"
gen survey = "LSMS-ISA" 
gen year = "2010-11" 
gen instrument = 12
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
saveold "${Tanzania_NPS_W2_final_data}/Tanzania_NPS_W2_field_plot_variables.dta", replace

********************************************************************************
*SUMMARY STATISTICS
******************************************************************************** 
/*
All the pre-processed files include all households, individuals, and plots in the sample. 
The summary statistics are outputted only for the sub_population of households, individuals, and plots in rural areas. 
The code for outputting the summary statistics is in a separare dofile that is called here
*/ 
*Parameters
global list_instruments  "Tanzania_NPS_W3"

do "${directory}/_Summary_Statistics/EPAR_UW_335_SUMMARY_STATISTICS.do"
