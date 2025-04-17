
/*-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: Agricultural Development Indicators for the LSMS-ISA, Ethiopia Socioeconomic Survey (ESS) LSMS-ISA Wave 1 (2011-12)

*Author(s)		: Didier Alia & C. Leigh Anderson; uw.eparx@uw.edu
				  
*Date			: March 31st, 2025
*Dataset version: ETH_2011_ERSS_v02_M_Stata8
----------------------------------------------------------------------------------------------------------------------------------------------------*/

*Data source
*The Ethiopia Socioeconomic Survey was collected by the Ethiopia Central Statistical Agency (CSA) 
*and the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture(LSMS - ISA)
*The data were collected over the period September - November 2011, and February - April 2012.
*All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
*https://microdata.worldbank.org/index.php/catalog/2053

*Summary of Executing the Master do.file
*-----------
*This Master do.file constructs selected indicators using the Ethiopia ESS data set.
*Using data files from within the "Raw DTA files" folder within the "Ethiopia ESS Wave 1" folder, 
*the do.file first constructs common and intermediate variables, saving dta files when appropriate 
*in the folder "created_data" within the "Final DTA files" folder.
*These variables are then brought together at the household, plot, or individual level, saving dta files at each level when available 
*in the "Final DTA files" folder.

*The processed files include all households, individuals, and plots in the sample.
*Toward the end of the do.file, a block of code estimates summary statistics (mean, standard error of the mean, minimum, first quartile, median, third quartile, maximum) 
*of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager.
*The results are outputted in the excel file "Ethiopia_ESS_W1_summary_stats.rtf" in the "Final DTA files" folder.
*It is possible to modify the condition  "if rural==1" in the portion of code following the heading "SUMMARY STATISTICS" to generate all summary statistics for a different sub_population.

/*
	
*FINAL FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD-LEVEL VARIABLES			Ethiopia_ESS_W1_household_variables.dta
*plot-LEVEL VARIABLES				Ethiopia_ESS_W1_plot_plot_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			Ethiopia_ESS_W1_individual_variables.dta	
*SUMMARY STATISTICS					Ethiopia_ESS_W1_summary_stats.xlsx

*/


clear
clear matrix
clear mata
set more off
set maxvar 8000	
ssc install findname  // need this user-written ado file for some commands to work	

*Set location of raw data and output
 global directory 					"../.."  //Path to the github main folder


* Set directories
// These paths indicate where the raw data files are located and where the created data and final data will be stored.
global Ethiopia_ESS_W1_raw_data 				"$directory/Ethiopia ESS/Ethiopia ESS Wave 1/Raw DTA Files" //Path to the raw data files, downloaded from the world bank website.
global Ethiopia_ESS_W1_temp_data				"$directory/Ethiopia ESS/Ethiopia ESS Wave 1/Final DTA Files/temp_data" // we make small modifications all raw data files and use this version of the data moving forward
global Ethiopia_ESS_W1_created_data				"$directory/Ethiopia ESS/Ethiopia ESS Wave 1/Final DTA Files/created_data"
global Ethiopia_ESS_W1_final_data				"$directory/Ethiopia ESS/Ethiopia ESS Wave 1/Final DTA Files/final_data"
global summary_stats 							"$directory/_Summary_statistics/EPAR_UW_335_SUMMARY_STATISTICS.do" //reminder to update

global Ethiopia_ESS_W1_pop_tot 90139927
global Ethiopia_ESS_W1_pop_rur 74153611
global Ethiopia_ESS_W1_pop_urb 15986316


********************************************************************************
*EXCHANGE RATE AND INFLATION FOR CONVERSION IN SUD IDS
********************************************************************************
* Household survey was administered in 2012
global Ethiopia_ESS_W1_exchange_rate 23.8661	// https://www.bloomberg.com/quote/USDETB:CUR //2017
global Ethiopia_ESS_W1_gdp_ppp_dollar 8.34		// https://data.worldbank.org/indicator/PA.NUS.PPP //2017
global Ethiopia_ESS_W1_cons_ppp_dollar 8.21   // https://data.worldbank.org/indicator/PA.NUS.PPP //2017
global Ethiopia_ESS_W1_inflation 0.673199  	// 2012 value divided by 2017 value. inflation rate 2012-2017. We want to adjust value to 2017. CPI_2012 = 164.7 / CPI_2017 = 244.65 https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=ET

global Ethiopia_ESS_W1_poverty_190 (1.90*5.574746609*(164.697507/133.2499599)) //Calculation for WB's previous $1.90 (PPP) poverty threshold, 158 N. This controls the indicator poverty_under_1_9; change the 1.9 to get results for a different threshold. Note this is based on the 2011 con PPP conversion! Equation -> 1.90*PPP_conv_2011*Inf where Infl=(CPI_2012/CPI_2011)
global Ethiopia_ESS_W1_poverty_npl (7184*164.697507/221.028/365) //see calculation and sources below
* 7184 Birr is the Ethiopian National Poverty Line in 2015/2016
		* Mekasha, T. J., & Tarp, F. (2021). Understanding poverty dynamics in Ethiopia: Implications for the likely impact of 	COVID-19. Review of Development Economics, 25(4), 1838–1868. https://doi.org/10.1111/rode.12841
* Multiplied by 164.697507 - 2011 Consumer price index (2010 = 100)
		* https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2022&locations=ET&start=2011
* Divided by 221.028 - 2016 Consumer price index (2010 = 100)
	* https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2022&locations=ET&start=2011
* Divided  by # of days in year (365) to get daily amount
global Ethiopia_ESS_W1_poverty_215 2.15 * $Ethiopia_ESS_W1_inflation * $Ethiopia_ESS_W1_cons_ppp_dollar  //New 2017 poverty line - 124.68 N


********************************************************************************
*THRESHOLDS FOR WINSORIZATION
********************************************************************************
global wins_lower_thres 1    						//  Threshold for winzorization at the bottom of the distribution of continous variables
global wins_upper_thres 99							//  Threshold for winzorization at the top of the distribution of continous variables


********************************************************************************
*GLOBALS OF PRIORITY CROPS //change these globals if you are interested in different crops
********************************************************************************
////Limit crop names in variables to 6 characters or the variable names will be too long! 
clear
global topcropname_area "maize rice wheat sorgum millet grdnt beans swtptt cassav banana teff barley coffee sesame hsbean nueg tomato onion mango avocad"		
global topcrop_area "2 5 8 6 3 24 12 62 10 42 7 1 72 27 13 25 63 58 46 84"
global comma_topcrop_area "2, 5, 8, 6, 3, 24, 12, 62, 10, 42, 7, 1, 72, 27, 13, 25, 63, 58, 46, 84"
global topcropname_full "maize rice wheat sorghum millet groundnut beans sweetpotato cassava banana teff barley coffee sesame horsebean nueg tomato onion mango avocado"
global nb_topcrops : word count $topcrop_area

set obs $nb_topcrops 
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
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_cropname_table.dta", replace 


********************************************************************************
* UNIQUELY IDENTIFIABLE GEOGRAPHIES AND PLOTS - note that without this code, collapsing by [zone, woreda, kebele, ea] using raw data (as we do to get median prices) will result in inaccurate medians. We need to create unique identifiers to collapse on!
* UNIQUELY IDENTIFIABLE PARCELS AND plotS AT THE HOUSEHOLD LEVEL (for AqQuery+)

* STEPS:
* Create a "temp_data" folder in the "Final DTA Files" folder, similar to "created_data" and "final_data"
* Create a Global for temp_data (e.g. global Ethiopia_ESS_W5_temp_data		"$directory/Ethiopia ESS/Ethiopia ESS Wave 1/Final DTA Files/temp_data")
* Insert hhid_panel_key.dta in the "temp_data" folder
********************************************************************************
capture confirm file "$Ethiopia_ESS_W1_temp_data/sect1_pp_w1.dta" //Simple check for an output file; this block only needed one time, so code will only run the code if it's missing from the temp_data folder. Delete it to make the code re-run.
if(_rc){
* POST-PLANTING, POST-HARVEST, LIVESTOCK - kebele, ea have different names in these files than HOUSEHOLD so handling separately
local directory_raw "$Ethiopia_ESS_W1_raw_data"
local directory_temp "$Ethiopia_ESS_W1_temp_data"
local raw_pp : dir "`directory_raw'" files "*pp*.dta", respectcase
local raw_ph : dir "`directory_raw'" files "*ph*.dta", respectcase
local raw_ls : dir "`directory_raw'" files "*ls*.dta", respectcase
local raw_files "`raw_pp' `raw_ph' `raw_ls'"

foreach file of local raw_files {
       use "`directory_raw'/`file'", clear 
		
		// HOUSEHOLD
		capture confirm variable saq06
		if(!_rc) {
		tostring saq06, replace
		replace saq06 = "0" + saq06 if length(saq06) == 2
		replace saq06 = "00" + saq06 if length(saq06) == 1
		ren saq06 saq08 // aligning with hh number in hh files
        }
  
		// REGION
		capture confirm variable saq01
		if(!_rc) {
		tostring saq01, gen(region)
		replace region = "0" + region if length(region) == 1
		}
		
		// ZONE
		capture confirm variable saq02 
		if(!_rc) {
		tostring saq02, replace
		replace saq02 = "0" + saq02 if length(saq02) == 1
        egen zone = concat(region saq02)
		drop region // We just used this variable to create a unique string for zone - now we prefer saq01 (region in byte form)
		assert zone != "" if saq02 != ""
        drop saq02
        rename zone saq02
		lab var saq02 "Zone"
		order saq01 saq02
        }
		
		// WOREDA
		capture confirm variable saq03
		if(!_rc) {
		tostring saq03, replace
		replace saq03 = "0" + saq03 if length(saq03) == 1
        egen woreda = concat(saq02 saq03) // Just need saq02 and 03 because 02 was already concat. with saq01
		*assert woreda != "" if saq03 != ""
        drop saq03
        rename woreda saq03
		lab var saq03 "Woreda"
		order saq01 saq02 saq03
        }
		
		// KEBELE
		capture confirm variable saq04
		if(!_rc) {
		tostring saq04, replace
		replace saq04 = "0" + saq04 if length(saq04) == 1
        egen kebele = concat(saq03 saq04)
		*assert kebele != "" if saq06 != ""
        drop saq04
        rename kebele saq06 // needs to match hh files
		lab var saq06 "Kebele"
		order saq01 saq02 saq03 saq06
        }
    
        // EA
		capture confirm variable saq05
		if(!_rc) {
		tostring saq05, replace
		replace saq05 = "0" + saq05 if length(saq05) == 1
        egen ea = concat(saq06 saq05) // note that we just changed kebele to saq06
		*assert ea != "" if saq07 != ""
        drop saq05
        rename ea saq07
		lab var saq07 "Enumeration Area"
		order saq01 saq02 saq03 saq06 saq07
        }
	
		// HHID - using household_id2 from W2 - note that these are more data rich as they contain city and subcity codes and this allows us to track panel households over the first three waves
		capture confirm variable household_id
		if(!_rc) {
		merge m:1 household_id using "$directory/Ethiopia ESS/Panel Key/hhid_panel_key.dta", keep(1 3) nogen // Note that this file does not exist in the WB W1 download. EPAR created it to track panel households in the first three waves. After downloading from GitHub, add to the temp folder.(see directory globals above)
		ren household_id2 hhid
		replace hhid = household_id if hhid == "" // These would have been households that did not carry over to W2 due to panel attrition
        }
	
		// PARCEL_ID - creating a unique parcel identifier
		capture confirm variable holder_id
			if(!_rc) {
			capture confirm variable parcel_id
				if(!_rc) {
				tostring holder_id, replace
				tostring parcel_id, replace
				egen parcel_id_2 = concat(holder_id parcel_id)
				*assert parcel_id_2 != "" if parcel_id != ""
				drop parcel_id
				rename parcel_id_2 parcel_id
				lab var parcel_id "Unique Parcel ID"
				order hhid holder_id parcel_id
				}
			}
		
		// plot_ID - creating a unique plot identifier
capture confirm variable parcel_id
			if(!_rc) {
			capture confirm variable field_id
				if(!_rc) {
				tostring field_id, replace
				egen plot_id = concat(parcel_id field_id)
				drop field_id
				lab var plot_id "Unique Field ID"
				order hhid holder_id parcel_id plot_id
				}
			}
			
		
	save "`directory_temp'/`file'", replace

}		
 
* HOUSEHOLD - kebele, ea have different names in these files than PP, PH, and LS so handling separately
local directory_raw "$Ethiopia_ESS_W1_raw_data"
local directory_temp "$Ethiopia_ESS_W1_temp_data"
local raw_hh : dir "`directory_raw'" files "*hh*.dta", respectcase
local raw_files "`raw_hh'"

foreach file of local raw_hh {
    use "`directory_raw'/`file'", clear 
		// HOUSEHOLD
		capture confirm variable saq08
		if(!_rc) {
		tostring saq08, replace
		replace saq08 = "0" + saq08 if length(saq08) == 2
		replace saq08 = "00" + saq08 if length(saq08) == 1
        }
		
		// ZONE
		capture confirm variable saq02 
		if(!_rc) {
		tostring saq01, gen(region)
		replace region = "0" + region if length(region) == 1
		tostring saq02, replace
		replace saq02 = "0" + saq02 if length(saq02) == 1
        egen zone = concat(region saq02)
		assert zone != "" if saq02 != ""
        drop saq02 region
        rename zone saq02
		lab var saq02 "Zone"
		order saq01 saq02
        }
		
		// WOREDA
		capture confirm variable saq03
		if(!_rc) {
		tostring saq03, replace
		replace saq03 = "0" + saq03 if length(saq03) == 1
        egen woreda = concat(saq02 saq03) // Just need saq02 and 03 because 02 was already concat. with saq01
		assert woreda != "" if saq03 != ""
        drop saq03
        rename woreda saq03
		lab var saq03 "Woreda"
		order saq01 saq02 saq03
        }
		
		// KEBELE
		capture confirm variable saq06
		if(!_rc) {
		tostring saq06, replace
		replace saq06 = "0" + saq06 if length(saq06) == 1
        egen kebele = concat(saq03 saq06)
		assert kebele != "" if saq06 != ""
        drop saq06
        rename kebele saq06
		lab var saq06 "Kebele"
		order saq01 saq02 saq03 saq06
        }
    
        // EA
		capture confirm variable saq07
		if(!_rc) {
		tostring saq07, replace
		replace saq07 = "0" + saq07 if length(saq07) == 1
        egen ea = concat(saq06 saq07)
		assert ea != "" if saq07 != ""
        drop saq07
        rename ea saq07
		lab var saq07 "Enumeration Area"
		// destring saq01 saq02 saq03 saq04 saq05 saq06 saq07, replace
		order saq01 saq02 saq03 saq06 saq07
        }
	
		// HHID - using household_id2 from W2 - note that these are more data rich as they contain city and subcity codes and this allows us to track panel households over the first three waves
		capture confirm variable household_id
		if(!_rc) {
		merge m:1 household_id using "$directory/Ethiopia ESS/Panel Key/hhid_panel_key.dta", keep(1 3) nogen // Note that this file does not exist in the WB W1 download. EPAR created it to track panel households in the first three waves. After downloading from GitHub, add to the temp folder.(see directory globals above)
		ren household_id2 hhid
		replace hhid = household_id if hhid == "" // These would have been households that did not carry over to W2 due to panel attrition
        }
		
		// PARCEL_ID - creating a unique parcel identifier
		capture confirm variable saq09
			if(!_rc) {
			capture confirm variable parcel_id
				if(!_rc) {
				tostring saq09, replace
				tostring parcel_id, replace
				egen parcel_id_2 = concat(saq09 parcel_id)
				assert parcel_id_2 != "" if parcel_id != ""
				drop parcel_id
				rename parcel_id_2 parcel_id
				lab var parcel_id "Unique Parcel ID"
				order hhid holder_id parcel_id 
				}
			}
		
		// plot_ID - creating a unique plot identifier
capture confirm variable parcel_id
			if(!_rc) {
			capture confirm variable field_id
				if(!_rc) {
				tostring field_id, replace
				egen plot_id = concat(parcel_id field_id)
				drop field_id
				lab var plot_id_id "Unique Field ID"
				order hhid holder_id parcel_id plot_id
				}
			}
	save "`directory_temp'/`file'", replace
}

* COMMUNITY - also need to handle separately because variables are called sa1q* instead of saq* 
local directory_raw "$Ethiopia_ESS_W1_raw_data"
local directory_temp "$Ethiopia_ESS_W1_temp_data"
local raw_com : dir "`directory_raw'" files "*com*.dta", respectcase
local raw_files "`raw_com'"

foreach file of local raw_files {
    use "`directory_raw'/`file'", clear 
		// HOUSEHOLD
		capture confirm variable sa1q08
		if(!_rc) {
		tostring sa1q08, replace
		replace sa1q08 = "0" + sa1q08 if length(sa1q08) == 2
		replace sa1q08 = "00" + sa1q08 if length(sa1q08) == 1
		ren sa1q08 saq08
        }
		
		// ZONE
		capture confirm variable sa1q02 
		if(!_rc) {
		tostring sa1q01, gen(region)
		replace region = "0" + region if length(region) == 1
		tostring sa1q02, replace
		replace sa1q02 = "0" + sa1q02 if length(sa1q02) == 1
        egen zone = concat(region sa1q02)
		assert zone != "" if sa1q02 != ""
        drop sa1q02 region
		ren sa1q01 saq01
        rename zone saq02
		lab var saq02 "Zone"
		order saq01 saq02
        }
		
		// WOREDA
		capture confirm variable sa1q03
		if(!_rc) {
		tostring sa1q03, replace
		replace sa1q03 = "0" + sa1q03 if length(sa1q03) == 1
        egen woreda = concat(saq02 sa1q03) // Just need sa1q02 and 03 because 02 was already concat. with sa1q01
		assert woreda != "" if sa1q03 != ""
        drop sa1q03
        rename woreda saq03
		lab var saq03 "Woreda"
		order saq01 saq02 saq03
        }
		
		// KEBELE
		capture confirm variable sa1q06
		if(!_rc) {
		tostring sa1q06, replace
		replace sa1q06 = "0" + sa1q06 if length(sa1q06) == 1
        egen kebele = concat(saq03 sa1q06)
		assert kebele != "" if sa1q06 != ""
        drop sa1q06
        rename kebele saq06
		lab var saq06 "Kebele"
		order saq01 saq02 saq03 saq06
        }
    
        // EA
		capture confirm variable sa1q07
		if(!_rc) {
		tostring sa1q07, replace
		replace sa1q07 = "0" + sa1q07 if length(sa1q07) == 1
        egen ea = concat(saq06 sa1q07)
		assert ea != "" if sa1q07 != ""
        drop sa1q07
        rename ea saq07
		lab var saq07 "Enumeration Area"
		// destring sa1q01 sa1q02 sa1q03 sa1q04 sa1q05 sa1q06 sa1q07, replace
		order saq01 saq02 saq03 saq06 saq07
        }
	
		// HHID - using household_id2 from W2 - note that these are more data rich as they contain city and subcity codes and this allows us to track panel households over the first three waves
		capture confirm variable household_id
		if(!_rc) {
		merge m:1 household_id using "$directory/Ethiopia ESS/Panel Key/hhid_panel_key.dta", keep(1 3) nogen // Note that this file does not exist in the WB W1 download. EPAR created it to track panel households in the first three waves. After downloading from GitHub, add to the temp folder.(see directory globals above)
		ren household_id2 hhid
		replace hhid = household_id if hhid == "" // These would have been households that did not carry over to W2 due to panel attrition
        }
		
		// FIELD_ID - creating a unique field identifier
		capture confirm variable parcel_id
			if(!_rc) {
			capture confirm variable field_id
				if(!_rc) {
				tostring field_id, replace
				egen plot_id = concat(parcel_id field_id)
				drop field_id
				lab var plot_id_id "Unique Field ID"
				order hhid holder_id parcel_id plot_id
				}
			}

		* PARCEL and plot_IDs not in COMM files
	save "`directory_temp'/`file'", replace
}

* LOCAL AREA UNIT CONVERSION
use "${Ethiopia_ESS_W1_raw_data}\ET_local_area_unit_conversion.dta", clear		
		 // ZONE
		capture confirm variable zone 
		if(!_rc) {
		tostring region, gen(saq01)
		replace saq01 = "0" + saq01 if length(saq01) == 1
		tostring zone, replace
		replace zone = "0" + zone if length(zone) == 1
        egen saq02 = concat(saq01 zone)
		*assert zone != "" if saq02 != ""
        drop zone saq01
		rename saq02 zone
		order region zone
        }
		
		// WOREDA
		capture confirm variable woreda
		if(!_rc) {
		tostring woreda, replace
		replace woreda = "0" + woreda if length(woreda) == 1
        egen saq03 = concat(zone woreda) // Just need saq02 and 03 because 02 was already concat. with saq01
		*assert woreda != "" if saq03 != ""
        drop woreda
        rename saq03 woreda
		lab var woreda "Woreda"
		order region zone woreda
        }
save "${Ethiopia_ESS_W1_temp_data}/ET_local_area_unit_conversion", replace

* MISCELLANEOUS: CFs, Geovars, Etc.
local directory_raw "$Ethiopia_ESS_W1_raw_data"
local directory_temp "$Ethiopia_ESS_W1_temp_data"
local raw_cf : dir "`directory_raw'" files "*CF*.dta", respectcase
local raw_geo : dir "`directory_raw'" files "*Geovar*.dta", respectcase
local raw_misc : dir "`directory_raw'" files "*cons_agg*.dta", respectcase
local raw_files "`raw_cf' `raw_geo' `raw_misc'"

foreach file of local raw_files {
use "`directory_raw'/`file'", clear 

		// HHID - using household_id2 from W2 - note that these are more data rich as they contain city and subcity codes and this allows us to track panel households over the first three waves
		capture confirm variable household_id
		if(!_rc) {
		merge m:1 household_id using "$directory/Ethiopia ESS/Panel Key/hhid_panel_key.dta", keep(1 3) nogen // Note that this file does not exist in the WB W1 download. EPAR created it to track panel households in the first three waves. After downloading from GitHub, add to the temp folder.(see directory globals above)
		*ren household_id2 hhid
		capture confirm var hhid 
		if(_rc){
			gen hhid = household_id
		}
		replace hhid = household_id if hhid == "" // These would have been households that did not carry over to W2 due to panel attrition
        }
		
save "`directory_temp'/`file'", replace

}

}

********************************************************************************
*IDENTIFYING WHETHER HOUSEHOLDS WERE INTERVIEWED POST-PLANTING AND POST-HARVEST
********************************************************************************
*Interviewed post-planting
use "${Ethiopia_ESS_W1_temp_data}/sect_cover_pp_w1.dta", clear
keep hhid
duplicates drop
gen interview_pping = 1
lab var interview_pping "1= HH was interviewed post-planting"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_pp_interview.dta", replace

*Interviewed post-harvest
use "${Ethiopia_ESS_W1_temp_data}/sect_cover_ph_w1.dta", clear
keep hhid
duplicates drop
gen interview_postharvest = 1
lab var interview_postharvest "1= HH was interviewed post-harvest"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_ph_interview.dta", replace


********************************************************************************
*HOUSEHOLD IDS
********************************************************************************
use "${Ethiopia_ESS_W1_temp_data}/sect_cover_hh_w1.dta", clear
ren saq01 region 
ren saq02 zone 
ren saq03 woreda 
ren saq04 town 
ren saq05 subcity 
ren saq06 kebele 
ren saq07 ea
ren pw weight
ren rural rural2
gen rural = (rural2==1)
lab var rural "1=Rural"		// NOTE: There are no large urban areas in wave one
keep region zone woreda town subcity kebele ea hhid rural hhid weight

*Generating the variable that indicate the level of representativness of the survey (to use for reporting summary stats) // FT
gen level_representativness=.
replace level_representativness=1 if region==1
replace level_representativness=2 if region==3 
replace level_representativness=3 if region==4 
replace level_representativness=4 if region==7 
replace level_representativness=5 if region==2
replace level_representativness=5 if region==5 
replace level_representativness=5 if region==6 
replace level_representativness=5 if region==12 
replace level_representativness=5 if region==13
replace level_representativness=5 if region==15 
replace level_representativness=6 if region==14 

lab define lrep 1 "Tigray"  ///
                2 "Amhara"  ///
                3 "Oromia"  ///
                4 "SNNP"    ///
                5 "Other regions" ///
                6 "Addis Ababa"
				
lab value level_representativness lrep

save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hhids.dta", replace

********************************************************************************
*WEIGHTS 
********************************************************************************
/*
use "${Ethiopia_ESS_W1_temp_data}/sect1_hh_w1.dta", clear
gen rural1 = (rural==1)
drop rural 
rename rural1 rural 
label var rural "1= Rural"
keep hhid pw
codebook hhid
collapse (first) pw, by(hhid)
rename pw weight
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_weights.dta", replace 
*/

********************************************************************************
*WEIGHTS AND GENDER OF HEAD
********************************************************************************
use "${Ethiopia_ESS_W1_temp_data}/sect1_hh_w1.dta", clear
gen fhh = hh_s1q03==2 if hh_s1q02==1

*Unlike W3 we do not need to change the strata significantly. Similar to W5, all regions and urban/rural stratification are representative in W5 (see BID for more information). Remember, W5 is an entirely new sample. 
gen clusterid = ea_id
gen personid = individual_id
ren rural old_rural
gen rural = 1 if old_rural == 1
recode rural (.=0) 
lab var rural "1=Rural"		// NOTE: There are no large urban areas in wave one 

gen strataid=saq01 if rural==1 //assign region as strataid to rural respondents; regions from 1 to 7 and then 12 to 15
gen stratum_id=.
replace stratum_id=16 if rural==0 & saq01==1 	//Tigray, urban //
replace stratum_id=17 if rural==0 & saq01==2	//Afar, urban
replace stratum_id=18 if rural==0 & saq01==3	//Amhara, urban
replace stratum_id=19 if rural==0 & saq01==4 	//Oromiya, urban
replace stratum_id=20 if rural==0 & saq01==5	//Somali, urban
replace stratum_id=21 if rural==0 & saq01==6	//Benishangul Gumuz, urban
replace stratum_id=22 if rural==0 & saq01==7 	//SNNP, urban
replace stratum_id=23 if rural==0 & saq01==12	//Gambela, urban
replace stratum_id=24 if rural==0 & saq01==13 	//Harar, urban
replace stratum_id=25 if rural==0 & saq01==14 	//Addis Ababa, urban MGM 8.14.2024: Addis Ababa is only urban, no rural respondents
replace stratum_id=26 if rural==0 & saq01==15 	//Dire Dawa, urban
replace strataid=stratum_id if rural==0 		//assign new strata IDs to urban respondents, stratified by region and urban

gen hh_members = 1 
gen hh_women = hh_s1q03==2
gen hh_adult_women = (hh_women==1 & hh_s1q04_a>=15 & hh_s1q04_a<65)			//Adult women from 15-64 (inclusive)
gen hh_youngadult_women = (hh_women==1 & hh_s1q04_a>=15 & hh_s1q04_a<25) 		//Adult women from 15-24 (inclusive) 
gen hh_work_age = (hh_s1q04_a>=15 & hh_s1q04_a<65) // Adults 15-64
ren pw pw_w1
collapse (max) fhh (firstnm) pw_w1 clusterid strataid (sum) hh_members hh_work_age hh_women hh_adult_women, by(hhid)	//removes duplicate values
lab var hh_members "Number of household members"
lab var hh_work_age "Number of household members of working age"
lab var hh_women "Number of women in household"
lab var hh_adult_women "Number of women in household of working age"
lab var fhh "1=Female-headed household"
lab var strataid "Strata ID (updated) for svyset"
lab var clusterid "Cluster ID for svyset"
lab var pw_w1 "Household weight"
*Re-scaling survey weights to match population estimates
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hhids.dta", nogen 
*Adjust to match total population
total hh_members [pweight=weight]
matrix temp =e(b)
gen weight_pop_tot=weight*${Ethiopia_ESS_W1_pop_tot}/el(temp,1,1)
total hh_members [pweight=weight_pop_tot]
lab var weight_pop_tot "Survey weight - adjusted to match total population"
*Adjust to match total population but also rural and urban
total hh_members [pweight=weight] if rural==1
matrix temp =e(b)
gen weight_pop_rur=weight*${Ethiopia_ESS_W1_pop_rur}/el(temp,1,1) if rural==1
total hh_members [pweight=weight_pop_tot]  if rural==1

total hh_members [pweight=weight] if rural==0
matrix temp =e(b)
gen weight_pop_urb=weight*${Ethiopia_ESS_W1_pop_urb}/el(temp,1,1) if rural==0
total hh_members [pweight=weight_pop_urb]  if rural==0

egen weight_pop_rururb=rowtotal(weight_pop_rur weight_pop_urb)
total hh_members [pweight=weight_pop_rururb]  
lab var weight_pop_rururb "Survey weight - adjusted to match rural and urban population"
* drop weight_pop_rur weight_pop_urb

save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_weights.dta", replace

********************************************************************************
* INDIVIDUAL IDS *
********************************************************************************
*KEF Added this section per Andrew's guidance. Needed to make a person_id file that was comparable to NGA and TZA. 1/11/22
//ALT: I'm a little worried about the discrepencies in some of the entries; there's some examples of two people with the same individual IDs but different holder IDs
* post planting 
use "${Ethiopia_ESS_W1_temp_data}/sect1_pp_w1.dta", clear
keep hhid individual_id pp_s1q00 pp_s1q02 pp_s1q03
gen female = pp_s1q03 == 2 
replace female = . if pp_s1q03 == .
replace female = . if pp_s1q03 == 3
lab var female "1 = individual is female"
rename pp_s1q00 indiv
rename pp_s1q02 age
rename pp_s1q03 sex
duplicates drop hhid individual_id, force //554 obs dropped
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_person_ids.dta", replace

* post harvesting // new 
use "${Ethiopia_ESS_W1_temp_data}/sect1_ph_w1.dta", clear
keep hhid individual_id ph_s1q00 ph_s1q02 ph_s1q03
codebook ph_s1q03
gen female = ph_s1q03 == 2 
replace female = . if ph_s1q03 == .
replace female = . if ph_s1q03 == 3
lab var female "1 = individual is female"
rename ph_s1q00 indiv
rename ph_s1q02 age
rename ph_s1q03 sex
duplicates drop hhid individual_id, force //685 obs dropped

merge 1:1 hhid individual_id using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_person_ids.dta" 		// keeping all individuals in any roster
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_person_ids_merge_both.dta", replace


********************************************************************************
*INDIVIDUAL GENDER
********************************************************************************
*Using gender from planting and harvesting
use "${Ethiopia_ESS_W1_temp_data}/sect1_ph_w1.dta", clear
gen personid = ph_s1q00
gen female = ph_s1q03==2	// NOTE: Assuming missings are male
*duplicates tag hhid personid, gen(dupes)
*dropping duplicates (data is at holder level so some individuals are listed multiple times, we only need one record for each) 
duplicates drop hhid personid, force //685 obs deleted
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_gender_merge_ph.dta", replace		// only post-harvest

*Planting
use "${Ethiopia_ESS_W1_temp_data}/sect1_pp_w1.dta", clear
gen personid = pp_s1q00 
gen female = pp_s1q03==2	// NOTE: Assuming missings are male
duplicates drop hhid personid, force //554 obs deleted
merge 1:1 hhid personid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_gender_merge_ph.dta", nogen 		// keeping all individuals in any roster
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_gender_merge_both.dta", replace

*Using household roster for missing gender 
use "${Ethiopia_ESS_W1_temp_data}/sect1_hh_w1.dta", clear
keep hhid individual_id hh_s1q00 hh_s1q03
rename hh_s1q00 personid
merge 1:1 hhid personid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_gender_merge_both.dta"	// 2,915 were in roster but not planting/harvesting modules
duplicates drop hhid personid, force			//no duplicates
replace female = hh_s1q03==2 if female==.
*Assuming missings are male
recode female (.=0)		// no changes
duplicates drop individual_id, force
keep female personid hhid holder_id individual_id ph_s1q03 pp_s1q03
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_gender_merge_both.dta", replace

********************************************************************************
* HOUSEHOLD SIZE *
********************************************************************************
use "${Ethiopia_ESS_W1_temp_data}/sect1_hh_w1.dta", clear
gen fhh = hh_s1q03==2 if hh_s1q02==1		// NOTE: assuming missing is male
*We need to change the strata based on sampling methodology (see BID for more information)
gen clusterid = ea_id
gen strataid=saq01 if rural==1 //assign region as strataid to rural respondents; regions from from 16 to 20
gen stratum_id=.
replace stratum_id=16 if rural==0 & saq01==1 //Tigray, small town
replace stratum_id=17 if rural==0 & saq01==3 //Amhara, small town
replace stratum_id=18 if rural==0 & saq01==4 //Oromiya, small town
replace stratum_id=19 if rural==0 & saq01==7 //SNNP, small town
replace stratum_id=20 if rural==0 & (saq01==2 | saq01==5 | saq01==6 | saq01==12 | saq01==13 | saq01==15) //Other regions, small town
replace stratum_id=21 if rural==3 & saq01==1 //Tigray, large town
replace stratum_id=22 if rural==3 & saq01==3 //Amhara, large town
replace stratum_id=23 if rural==3 & saq01==4 //Oromiya, large town
replace stratum_id=24 if rural==3 & saq01==7 //SNNP, large town
replace stratum_id=25 if rural==3 & saq01==14 //Addis Ababa, large town
replace stratum_id=26 if rural==3 & (saq01==2 | saq01==5 | saq01==6 | saq01==12 | saq01==13 | saq01==15) //Other regions, large town
replace strataid=stratum_id if rural!=1 //assign new strata IDs to urban respondents, stratified by region and small towns
gen hh_members = 1
gen hh_work_age = (hh_s1q04_a>14 & hh_s1q04_a<65) // Adults 15-64
gen hh_women = hh_s1q03==2
gen hh_adult_women = (hh_women==1 & hh_s1q04_a>14 & hh_s1q04_a<65)			//Adult women from 15-64 (inclusive)
gen hh_youngadult_women = (hh_women==1 & hh_s1q04_a>14 & hh_s1q04_a<25) 		//Adult women from 15-24 (inclusive) 
collapse (max) fhh (firstnm) pw clusterid strataid (sum) hh_members hh_work_age hh_women hh_adult_women, by(hhid)
lab var hh_members "Number of household members"
lab var hh_work_age "Number of household members of working age"
lab var hh_women "Number of women in household"
lab var hh_adult_women "Number of women in household of working age"
lab var fhh "1=Female-headed household"
lab var strataid "Strata ID (updated) for svyset"
lab var clusterid "Cluster ID for svyset"
lab var pw "Household weight"

*NOT FEASIBLE BECAUSE SURVEY IS NOT NATIONAL Adjust to match total population
*DYA.11.1.2020 Re-scaling survey weights to match population estimates
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hhids.dta", nogen
total hh_members [pweight=weight]
matrix temp =e(b)
gen weight_pop_tot=weight*${Ethiopia_ESS_W1_pop_tot}/el(temp,1,1)
total hh_members [pweight=weight_pop_tot]
lab var weight_pop_tot "Survey weight - adjusted to match total population"
*Adjust to match total population but also rural and urban
total hh_members [pweight=weight] if rural==1
matrix temp =e(b)
gen weight_pop_rur=weight*${Ethiopia_ESS_W1_pop_rur}/el(temp,1,1) if rural==1
total hh_members [pweight=weight_pop_tot]  if rural==1

total hh_members [pweight=weight] if rural==0
matrix temp =e(b)
gen weight_pop_urb=weight*${Ethiopia_ESS_W1_pop_urb}/el(temp,1,1) if rural==0
total hh_members [pweight=weight_pop_urb]  if rural==0

egen weight_pop_rururb=rowtotal(weight_pop_rur weight_pop_urb)
total hh_members [pweight=weight_pop_rururb]  
lab var weight_pop_rururb "Survey weight - adjusted to match rural and urban population"
drop weight_pop_rur weight_pop_urb
*/
*gen weight_pop_tot=. 
*gen weight_pop_rururb=.
lab var weight_pop_tot "Survey weight - adjusted to match total population" // var has missing obs 
lab var weight_pop_rururb "Survey weight - adjusted to match rural and urban population" // var has missing obs 
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hhsize.dta", replace

********************************************************************************
*PLOT DECISION-MAKERS
********************************************************************************
*using a question about who controls revenue from crops to get at control of plot
use "${Ethiopia_ESS_W1_temp_data}/sect11_ph_w1.dta", clear
rename ph_s11q05_a personid2
rename ph_s11q05_b personid3 
keep personid* hhid crop_code holder_id
//reshape long personid, i(crop_code hhid holder_id) j(person_id)

*merging into a file with crop code, plot and parcel information
merge 1:m hhid holder_id crop_code using "${Ethiopia_ESS_W1_temp_data}/sect4_pp_w1.dta", nogen keep(2 3)
gen holderid=substr(holder_id, -2, .)
destring holderid, replace
gen personid1=holderid
replace personid1=personid2 if personid1==.
*ren field_id plot_id
keep hhid parcel_id holder_id plot_id personid1 personid2 personid3
recode personid1 personid2 personid3 (999=.)
duplicates drop
*Lots of 999 observations / 83 observations
drop if parcel_id=="" | plot_id==""
gen dummy = _n
reshape long personid, i(parcel_id plot_id hhid holder_id dummy) j(pidno)
*Then merge in gender on household and person id keep (1 3) and drop if person id is empty. 
merge m:1 hhid personid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_gender_merge_both.dta", gen(gender_merge) keep (1 3) 
drop if personid ==. 
preserve
drop pidno dummy
restore
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_plot_decision_makers_indids", replace 
gen dm1_gender = female+1 if pidno==1
collapse (mean) female (firstnm) dm1_gender, by (hhid parcel_id plot_id holder_id)
drop if parcel_id == "" //47 observations deleted
gen dm_gender = 2 if female == 1
replace dm_gender = 1 if female == 0 
replace dm_gender = 3 if (female != 1 & female != 0 & female != .)
//replace dm_gender = pp_s1q03 if dm_gender ==. 
//replace dm_gender = ph_s1q03 if dm_gender ==.
drop if parcel_id == ""
la var dm_gender "Gender category of plot decisionmaker(s)"
la var dm1_gender "Gender of plot holder"
keep plot_id parcel_id dm* hhid holder_id
 
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_plot_decision_makers", replace //39 obs still unknown for dm_gender

********************************************************************************
* ALL AREA CONSTRUCTION
*********************************************************************************
use "$Ethiopia_ESS_W1_temp_data/sect2_pp_w1.dta", clear
merge 1:m household_id holder_id parcel_id using "${Ethiopia_ESS_W1_temp_data}/sect3_pp_w1.dta", nogen
//drop if s2q01c == 2 //Parcel no longer owned or rented in. // not asked in W1
gen rented_in = pp_s2q03==3
gen plot_not_owned = ( pp_s2q03==3 | pp_s2q03==4 | pp_s2q03==10 ) // rent, borrowed free, squat
gen plot_owned = (pp_s2q03==1 | pp_s2q03==2 | pp_s2q03==7 ) // granted, inherited, purchased // no values for "purchased" (see other waves)
gen rented_out= (pp_s2q10==1) // MGM 5.20.2024 - questionaire changed a bit from W3 to W5
//Rented out parcels are not measured

ren saq01 region
ren saq02 zone
ren saq03 woreda
gen cultivated = pp_s3q03==1 | 	pp_s3q03==2 //purestand or mixed crop to mean plot was cultivated
 
gen agland = (pp_s3q03==1 | pp_s3q03==2 | pp_s3q03==3 | pp_s3q03==4  | pp_s3q03==6 ) // Cultivated, prepared for Belg season, pasture, or fallow. Excludes forest, homestead, and "other" (which seems to include rented-out)
replace agland=1 if cultivated==1 //59 changes

*In the coming lines, we construct ratios of sq m to local units (which we will use when conversion factors are missing)
gen area = pp_s3q02_d // area of plot reported by holders - 326 missing 
gen local_unit = pp_s3q02_c //note: no "other specify" variable to further detail "Other response for units"
gen area_sqmeters_gps = pp_s3q05_c //plots measured precisely with GPS
replace area_sqmeters_gps = . if area_sqmeters_gps<10
replace area=. if area <=0


*Constructing geographic medians for local unit per square meter ratios
preserve
keep hhid parcel_id plot_id area local_unit area_sqmeters_gps
merge m:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_weights.dta", keep(1 3) nogen
gen sqmeters_per_unit = area_sqmeters_gps/area
gen observations = 1
collapse (median) sqmeters_per_unit (count) observations [aw=weight_pop_rururb], by (region zone local_unit)
ren sqmeters_per_unit sqmeters_per_unit_zone 
ren observations obs_zone
lab var sqmeters_per_unit_zone "Square meters per local unit (median value for this region and zone)"
drop if local_unit==.
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_area_lookup_zone.dta", replace
restore

preserve
replace area_sqmeters_gps=. if area_sqmeters_gps<0
keep hhid parcel_id plot_id area local_unit area_sqmeters_gps
merge m:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_weights.dta", nogen keep(1 3)
gen sqmeters_per_unit = area_sqmeters_gps/area
gen observations = 1
collapse (median) sqmeters_per_unit (count) observations [aw=weight_pop_rururb], by (region local_unit)
ren sqmeters_per_unit sqmeters_per_unit_region
ren observations obs_region
lab var sqmeters_per_unit_region "Square meters per local unit (median value for this region)"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_area_lookup_region.dta", replace
restore

preserve
replace area_sqmeters_gps=. if area_sqmeters_gps<0
keep hhid parcel_id plot_id area local_unit area_sqmeters_gps
merge m:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_weights.dta", nogen keep(1 3)
gen sqmeters_per_unit = area_sqmeters_gps/area
gen observations = 1
collapse (median) sqmeters_per_unit (count) observations [aw=weight_pop_rururb], by (local_unit)
ren sqmeters_per_unit sqmeters_per_unit_country
ren observations obs_country
lab var sqmeters_per_unit_country "Square meters per local unit (median value for the country)"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_area_lookup_country.dta", replace
restore

*Area Measured Hectares - restricted to that which was collected by a GPS measurement
gen area_meas_hectares = area_sqmeters_gps/10000
gen field_size=area_meas_hectares 
merge m:1 region zone woreda local_unit using "${Ethiopia_ESS_W1_temp_data}/ET_local_area_unit_conversion.dta", gen(conversion_merge) keep(1 3)
replace field_size = area if field_size==. & local_unit==1 
replace field_size = area/10000 if field_size==. & local_unit==2
replace field_size = area*conversion/10000 if field_size==.

*Using our own created conversion factors for still missings observations -- 1122 missing
merge m:1 region zone local_unit using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_area_lookup_zone.dta", nogen
replace field_size = (area*(sqmeters_per_unit_zone/10000)) if local_unit!=7 & field_size==. & obs_zone>=10
merge m:1 region local_unit using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_area_lookup_region.dta", nogen
replace field_size = (area*(sqmeters_per_unit_region/10000)) if local_unit!=7 & area_meas_hectares==.|area_meas_hectares==0 & obs_region>=10
merge m:1 local_unit using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_area_lookup_country.dta", nogen
replace field_size = (area*(sqmeters_per_unit_country/10000)) if local_unit!=7 & area_meas_hectares==.|area_meas_hectares==0
count if area!=. & field_size==.
lab var area_meas_hectares "plot area measured in hectares with GPS"
lab var field_size "plot area measured in hectares, with missing replaced with farmer reported area, some imputed using local median per-unit values"
drop if hhid==""
merge 1:1 hhid parcel_id plot_id using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_plot_decision_makers.dta", nogen
gen field_size_male = field_size if dm_gender==1
gen field_size_female = field_size if dm_gender==2
gen field_size_mixed = field_size if dm_gender==3


preserve
bysort holder_id hhid parcel_id plot_id: gen dup = cond(_N==1,0,_n)
tab dup 
keep hhid holder_id parcel_id plot_id agland cultivated area_meas_hectares field_size field_size* /*gps_meas*/ pp_s3q04
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_plot_area.dta", replace
restore

/* Land Size Denominators: Several in use depending on measurement 
parcel_area.dta:	Total area @ parcel level  //Not used, but left in for reference.
farm_area: 			Sum of all cultivated parcels 
land_size:		Sum of all cultivated parcels (the same as farm_area, dropped)
plots_agland: 		Cultivated, prepared for Belg, pasture, or fallow; 
					NOT forest, homestead, and other/rented out (plot level)  //Not used, dropped
farmsize_all_agland: As above, household level
land_size_total:	All land owned or used, including rented in/out parcels (household level)
*/

*Parcel Area
preserve
keep cultivated field_size hhid holder_id parcel_id plot_id //we should be at unique plots at this point, but if not. 
keep if cultivated==1
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_field_sizes.dta", replace
lab var cultivated "1= plot was cultivated in this data set"
collapse (sum) parcel_size = field_size, by(hhid holder_id parcel_id)
lab var parcel_size "Parcel area measured in hectares with GPS, with missing replaced with farmer reported area"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_parcel_area.dta", replace //This is never used for anything but we have it if we want it
restore 

gen farm_area = field_size * cultivated 
gen farm_size_agland = field_size*agland
collapse (sum) farm_area farm_size_agland land_size_total = field_size, by(hhid)
lab var farm_size_agland "Land size in hectares, including all plots cultivated, fallow, or pastureland"
lab var farm_area "Land size (denominator for land productivitiy), in hectares" 
lab var land_size_total "Total land size in hectares, including forests, pastures, and homesteads" //Notably, this should include rented out plots but because we don't have measurements, they're not included. 
//assert farm_size_agland==land_size_total  //Mainly greater due to counting homesteads in the latter 
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_land_size.dta", replace

//Files farmsize_all_agland, land_size_total, and land_size_all are no longer needed 

*****************************************
*CROP UNIT CONVERSION FACTORS
*****************************************
capture confirm file "$Ethiopia_ESS_W1_temp_data/Crop_CF_Wave1.dta"
	if !_rc {
	use "$Ethiopia_ESS_W1_temp_data/Crop_CF_Wave1.dta", clear
	ren unit_cd unit
	ren mean_cf_nat nat_cf
	gen mean_cf5 = mean_cf99
	la var mean_cf5 "CONVERSION FACTOR - SOMALIE"
	gen mean_cf13 = mean_cf99
	la var mean_cf5 "CONVERSION FACTOR - HARARI"
	gen mean_cf15 = mean_cf99
	la var mean_cf5 "CONVERSION FACTOR - DIRE DAWA"
	drop mean_cf99
	
	reshape long mean_cf, i(crop_code unit note nat_cf) j(region)
	ren mean_cf conversion
	preserve 
	keep if unit==51 | unit==53 
	collapse (mean) conversion nat_cf, by(crop_code region)
	gen unit=52
	tempfile med_chinet
	save `med_chinet'
	restore
	
	append using `med_chinet'
	
	preserve
	collapse (mean) gen_conversion=conversion, by(unit region) //this isn't perfect but it's a rough estimate of the capacity of the unit when the crop code is unknown
	tempfile generic_units
	save `generic_units'
	restore
	
	fillin crop_code unit region
	ren _fillin est_cf //Use this to control whehter you use unit conversions from estimated unit averages (may not be accurate)
	merge m:1 unit region using `generic_units', nogen
	replace conversion = gen_conversion if conversion==.
	drop gen_conversion
	

	order region crop_code unit nat_cf conversion note
	duplicates tag region crop_code unit, gen(dups)
	drop if crop_code==74 & unit==62 & conversion>5 //8 observations deleted
	save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_cf.dta" , replace
	}
	
	else {
	di as error "Crop conversion factor file not present; retrieve from WB download or use a crop conversion factor file from another ESS survey wave."
	}

*****************************************
*ALL PLOTS
*****************************************
***************************
*Crop Values 
***************************
use "$Ethiopia_ESS_W1_temp_data/sect12_ph_w1.dta", clear
ren saq01 region
ren saq02 zone
ren saq03 woreda
ren saq06 kebele
ren saq07 ea
drop if ph_s12q02_c < 2004 //take only the last year 
gen permcrop=1
tempfile treecrops
save `treecrops'
	

use "${Ethiopia_ESS_W1_temp_data}/sect11_ph_w1.dta", clear
ren saq01 region
ren saq02 zone
ren saq03 woreda
ren saq06 kebele
ren saq07 ea
append using `treecrops'

//Because not all the plots had crop cut data, we can try to fill the gaps with the postharvest disposition data 
keep if ph_s11q01==1 | ph_s12q06 // did you sell any of crop?
recode ph_s11q03_a ph_s11q03_b (.=0) if permcrop != 1
gen qty_sold = ph_s11q03_a + ph_s11q03_b/1000
replace qty_sold = ph_s12q07 if qty_sold == . & ph_s12q07 != . // tree/perm
recode ph_s11q04_a ph_s11q04_b (.=0) if permcrop != 1
gen val_sold = ph_s11q04_a+ph_s11q04_b/100
replace val_sold = ph_s12q08 if val_sold == . & ph_s12q08 != . // tree/perm
ren ph_s11q22_c percent_sold
replace percent_sold = ph_s12q19_c if percent_sold == . & ph_s12q19_c != . // tree/perm
gen percent_lost = ph_s12q12/10
replace percent_lost = ph_s11q15_c/100 if percent_lost==.
//Alternative sources of yield, currently not incorporated
recode ph_s11q12_* ph_s11q13_* ph_s11q14_* ph_s11q15_* (.=0)
gen qty_feed = ph_s11q12_a+ph_s11q12_b/1000
gen qty_saved = ph_s11q14_a+ph_s11q14_b/1000
gen qty_lost=ph_s11q15_a+ph_s11q15_b/1000
drop if val_sold==0 | val_sold==. // 13,379 observations dropped 
keep hhid region zone woreda kebele ea rural crop_code qty_sold val_sold /*qty_harv*/

//Only unit is kg, no need for nonstandard unit conversions.
merge m:1 ea hhid kebele woreda rural zone region using"${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_weights.dta", nogen keepusing(weight*) keep(1 3) 
// a few entries for multiple crops
collapse (sum) val_sold qty_sold /*qty_harv*/, by(hhid region zone woreda kebele ea crop_code weight*)
gen price_kg = val_sold/qty_sold //Some of these appear to be per-unit prices rather than total value sold. 
drop if price_kg==.
gen obs=1
foreach i in region zone woreda kebele ea hhid {
	preserve
	
	collapse (median) price_kg_`i'=price_kg (rawsum) obs_`i'_pkg=obs [aw=weight_pop_rururb], by (`i' crop_code)
	tempfile price_kg_`i'_median
	save `price_kg_`i'_median'
	restore
}

preserve
collapse (median) price_kg_country = price_kg (rawsum) obs_country_pkg=obs [aw=weight_pop_rururb], by(crop_code)
tempfile price_kg_country_median
save `price_kg_country_median'
restore

collapse (sum) /*qty_harv*/ qty_sold val_sold, by(hhid crop_code)
//la var qty_harv "Quantity Harvested" 
la var qty_sold "Quantity Sold" 
la var val_sold "Value of Quantity Sold"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_crop_vals_hhids.dta" , replace

***************************
*Plot variables
***************************	
use "${Ethiopia_ESS_W1_temp_data}/sect4_pp_w1.dta", clear
ren saq01 region
ren saq02 zone
ren saq03 woreda
ren saq06 kebele
ren saq07 ea
gen crop_id = crop_code
gen season_ph=1
tempfile sect9_ph_w1
save `sect9_ph_w1'

use "${Ethiopia_ESS_W1_temp_data}/sect9_ph_w1" , clear
ren saq01 region
ren saq02 zone
ren saq03 woreda
ren saq06 kebele
ren saq07 ea
gen crop_id = crop_code
ren crop_name crop_name1
ren crop_code crop_code1
gen season_pp=1

merge 1:1 hhid holder_id parcel_id plot_id crop_id using `sect9_ph_w1', nogen keep(3)

//Reconciling a few cases where crop_codes are not consistent across pp and ph data
gen mismatch = crop_code!=crop_code1
replace crop_code=crop_code1 if crop_code==. & mismatch==1 //630 changes
replace crop_code1=crop_code if crop_code1==. & mismatch==1 //163 changes
gen crop_code_r=. //crop_code fix
replace crop_code_r = min(crop_code1, crop_code) if (crop_code1 > 97 | crop_code > 97) & mismatch==1 //52 occurences where "OTHER CROP" was listed in either ph or pp but not the other
replace crop_code=crop_code_r if crop_code>97 & crop_code_r!=. //8 changes
replace crop_code1=crop_code_r if crop_code1>97 & crop_code_r!=. //19 changes
*Kariya is a jalapeno
replace crop_code1=59 if strpos(crop_name1, "ariya") & mismatch==1 //4 changes
replace crop_code=59 if strpos(crop_name, "ariya") & mismatch==1 //0 changes
*Buna is coffee
replace crop_code1=72 if strmatch(crop_name1, "buna") & mismatch==1 //3 changes
replace crop_code=72 if strmatch(crop_name, "buna") & mismatch==1 //0 changes
*Muz is banana
replace crop_code1=42 if strmatch(crop_name1, "muz") & mismatch==1 //1 change
replace crop_code=42 if strmatch(crop_name, "muz") & mismatch==1 //0 change
replace mismatch=0 if crop_code==crop_code1 //826 real changes
drop if mismatch==1 //58 observations deleted - WB needs to fix cases where crop_name and crop_code are mislabeled or crop_ids swap between pp and ph (MAIZE CHAT) (HORSEBEANS PUMPKINS) (RED PEPPER GREEN PEPPER) (PAPAYA MANGO)
drop crop_code1

*Fix crop_code labels
la def crop_code_lab 1 "barley" 2 "maize" 3 "millet" 4 "oats" 5 "rice" 6 "sorghum" 7 "teff" 8 "wheat" 9 "mung bean" 10 "cassava" 11 "chick peas" 12 "haricot beans" 13 "horse beans" /*=fava bean*/ 14 "lentils" 15 "plot peas" 16 "vetch" /*ALT: not a food crop*/ 17 "gibto" /*ALT: White lupin*/ 18 "soybeans" 19 "kidney beans" 20 "fennel" 21 "castor beans" 22 "cottonseed" 23 "flaxseed" 24 "groundnuts" 25 "nueg" /*Nyjerseed, feed crop*/ 26 "rapeseed" /*i.e. canola*/ 27 "sesame" 28 "sunflower" 29 "mego" 30 "savory" 31 "black cumin" /*Nigella*/ 32 "black pepper" 33 "cardamom" 34 "chili pepper" 35 "cinnamon" 36 "fenugreek" 37 "ginger" 38 "red pepper" 39 "tumeric" 40 "white cumin"  41 "apples" 42 "bananas" 43 "grapes" 44 "lemons" 45 "mandarins" 46 "mangos" 47 "oranges" 48 "papaya" 49 "pineapple" 50 "citron" 51 "beer root" /*I cannot find any English-language references to this outside of LSMS - is it supposed to be beetroot? */ 52 "cabbage" 53 "carrot" 54 "cauliflower" 55 "garlic" 56 "kale" 57 "lettuce" 58 "onion" 59 "green pepper" 60 "potatoes" 61 "pumpkin" 62 "sweet potato" 63 "tomatoes" 64 "godere" /*ALT: Likely taro, should update crop codes to reduce regional variants like this one */ 65 "guava" 66 "peach" 67 "mustard" 68 "feto" /*garden cress?*/ 69 "spinach" 70 "green beans" 71 "chat" 72 "coffee" 73 "cotton" 74 "enset" 75 "gesho" /*buckthorn*/ 76 "sugarcane" 77 "tea" 78 "tobacco" 79 "coriander" 80 "sacred basil" /* tulsi */ 81 "rue" 82 "gishita" /*soursop*/ 83 "watermelon" 84 "avocado" 85 "forage" /*clarifying this from "Grazing land" */ 86 "temporary gr" /*Temporary forage? Not clear what this is*/ 97 "pijapin" /*Doesn't appear outside of LSMS, no obs */ 98 "other root crop" /*Cut off by char limit?*/ 99 "other land" 108 "amboshika" /*skipping 100-112, no obs, no idea what some of these are. Couldn't find any database entries with NL20F. */ 112 "kazmir" /*white sapote*/ 113 "strawberry" 114 "shiferaw" /*moringa*/ 115 "other fruit" 116 "timez kimem" /*Spice?*/ 117 "other spices" 118 "other pulses" 119 "other oilseed" 120 "other cereal" 121 "other case crop" /*=cover crop?*/ 123 "other vegetable"
la val crop_code crop_code_lab

* GENERATE PURESTAND, RELAY (plot-LEVEL)
ren pp_s4q02 crop_stand_pp
gen crop_stand_ph = .
gen perm_tree = inlist(crop_code, 10, 35, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 65, 66, 72, 74, 75, 76, 82, 84, 112, 115) 
lab var perm_tree "1 = Tree or permanent crop"

gen month_planted = pp_s4q12_a // 1,578 missing values
gen year_planted = pp_s4q12_b // 1,579 missing values 
replace month_planted = month_planted + 13 if year_planted == 2004 //13 months in Ethiopia 
gen month_harvest = ph_s9q13_b + 13 // all harvest occured in 2006
recode month_planted (.=0)
recode month_harvest (.=999)
*recode month_planted month_harvest (0 999 = .)
gen months_grown = month_harvest - month_planted if perm_tree == 0
replace months_grown = . if months_grown < 1 | month_planted == . | month_harvest == .

gen lost_drought = ph_s9q10==2 //too little rain
replace lost_drought = 1 if lost_drought == 0 & pp_s4q09 == 2 //too little rain
gen lost_flood = ph_s9q10==1 | ph_s9q10==7 //too much rain, floods
replace lost_flood = 1 if lost_flood == 0 & (pp_s4q09 == 1 | pp_s4q09 == 8) //too much rain, floods
gen lost_crop = ph_s9q11==100 | pp_s4q15 == 100
bys hhid holder_id plot_id : gen crops_plot=_N

gen purestand = crops_plot==1
lab var purestand "1 = monocropped, 0 = intercropped"

ren pp_s4q03 perc_planted_pp
recode perc_planted_pp (0=.)

	ren ph_s9q07 less_than_plant // was area harvested less than area planted?
	rename pp_s4q14 number_trees_planted 
	merge m:1 hhid holder_id parcel_id plot_id using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_plot_area.dta", nogen keep(1 3) keepusing(field_size cultivated) 

gen percent_field=perc_planted_pp/100
replace percent_field = 1 if percent_field==. & purestand==1
replace percent_field = 1 if percent_field > 1 & purestand == 1 
bys hhid holder_id parcel_id plot_id : egen total_percent = total(percent_field)
replace percent_field = percent_field/total_percent if total_percent > 1 & purestand == 0
gen pct_harvest = 1 //No question asking what percentage of the plot was harvested

//Some crops appear to have been lost and reported as not harvested 
replace pct_harvest=0 if ph_s9q08_a != 7 & ph_s9q08_b!=7  & (ph_s9q12_a==0) & (ph_s9q12_b==0)
replace pct_harvest=. if ph_s9q12_a==. & ph_s9q12_b==. & ph_s9q03_a==. & ph_s9q02_b==.
gen ha_planted=field_size*percent_field 
gen ha_harvest= ha_planted*pct_harvest

	* GENERATE QUANT_HARV_KG, VALUE_HARVEST (PER CROP PER plot)
	// W1 not like other waves. harvest quantities reported in kilos and grams; other waves use multiple units
	recode ph_s9q05_a ph_s9q05_b (.=0)
	gen quant_harv_kg=(ph_s9q05_a/0.0004*ha_planted*pct_harvest) + (ph_s9q05_b/1000/0.0004*ha_planted*pct_harvest) if (ph_s9q05_a!=0 & ph_s9q05_b!=0) //using crop cut data 
	
	gen qty_harv_kg = ph_s9q12_a //kilos
	gen qty_harv_g = ph_s9q12_a/1000 //grams
	egen qty_harv= rowtotal(qty_harv_kg qty_harv_g)
	replace qty_harv=. if qty_harv_kg==. & qty_harv_g==.
	replace quant_harv_kg = qty_harv if quant_harv_kg==.

* Merge in price per unit and price per kg - generated from S11
	foreach i in region zone woreda kebele ea hhid {
		merge m:1 `i' crop_code using `price_kg_`i'_median', nogen keep(1 3)
	}
	merge m:1 crop_code using `price_kg_country_median', nogen keep(1 3)

	gen price_kg = .
	
	foreach i in country region zone woreda kebele ea {  
		replace price_kg = price_kg_`i' if obs_`i'_pkg>9 & obs_`i'_pkg!=.	
	}

	* Household price/unit is preferred
	replace price_kg = price_kg_hhid if price_kg_hhid != . //comment out this line if you would prefer to use the area medians for all observations

	
	* VALUE HARVEST
	gen value_harvest = quant_harv_kg*price_kg
	

	
	*AgQuery
	bys hhid holder_id parcel_id plot_id : egen area_plan = sum(ha_planted)
	gen percent_inputs = ha_planted / area_plan
	drop if parcel_id == ""
	keep region zone woreda kebele ea hhid holder_id parcel_id plot_id purestand /*crops_plot*/ crop_code val* quant* cultivated ha_planted ha_harvest number_trees_planted percent_inputs months_grown /*reason_loss*/ field_size /*gps_meas*/ lost*
	merge m:1 hhid holder_id parcel_id plot_id using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm*) // 105 not matched

	order region zone woreda kebele ea hhid holder_id parcel_id plot_id crop_code
	save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_all_plots.dta", replace

	//AT: moving this up here and making it its own file because we use it often below
	collapse (sum) ha_planted, by(hhid holder_id parcel_id plot_id) //Use planted area for hh-level expenses 
	save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_planted_area.dta", replace
	
/*
*CODE USED TO DETERMINE THE TOP CROPS
use "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_all_plots.dta", clear
	merge m:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hhids.dta", keep(1 3) // 75 HHs not matched
	gen area= ha_planted*weight_pop_rururb 
	collapse (sum) area, by (crop_code)
*/

********************************************************************************
*GROSS CROP REVENUE 
********************************************************************************
use "${Ethiopia_ESS_W1_temp_data}/sect12_ph_w1.dta", clear
ren saq01 region 
ren ph_s12q08 sales_value 
ren ph_s12q07 quantity_sold 
gen unit = 1 // all in kgs
gen permcrop=1
tempfile treecrops
save `treecrops'

use "${Ethiopia_ESS_W1_temp_data}/sect11_ph_w1.dta", clear
//ren cropcode crop_code 
ren saq01 region 
recode ph_s11q04_a (.=0)
recode ph_s11q04_b (.=0)
tostring ph_s11q04_a, gen(value)
tostring ph_s11q04_b, gen(value_d)
replace value = value + "." + value_d
destring value, gen(sales_value)
drop value
recode sales_value (.=0)
ren ph_s11q03_a quantity_sold
replace quantity_sold = (ph_s11q03_b/1000) if quantity_sold == . & ph_s11q03_b !=. // converting grams to kilos
gen unit = 1 // all kilograms
*merging in conversion factors
gen permcrop=0
append using `treecrops'
*  commenting out because everything is already in kgs
/*merge m:1 crop_code unit region using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_cf.dta", gen(cf_merge)
gen kgs_sold= quantity_sold*conversion*/ 
ren quantity_sold kgs_sold
collapse (sum) sales_value kgs_sold, by (hhid crop_code)
lab var sales_value "Value of sales of this crop"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_cropsales_value.dta", replace 

use "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_all_plots.dta", clear
//ren crop_code_master crop_code
//ren val_harv value_harvest 
collapse (sum) value_harvest , by (hhid crop_code) 
merge 1:1 hhid crop_code using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_cropsales_value.dta"
recode  value_harvest sales_value  (.=0) // go back and just call this value_cropsales from the start
replace value_harvest = sales_value if sales_value>value_harvest & sales_value!=. /* In a few cases, sales value reported exceeds the estimated value of crop harvest */
ren sales_value value_crop_sales 
collapse (sum) value_harvest value_crop_sales, by (hhid crop_code)
ren value_harvest value_crop_production
lab var value_crop_production "Gross value of crop production, summed over main and short season"
lab var value_crop_sales "Value of crops sold so far, summed over main and short season"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hh_crop_values_production.dta", replace 

collapse (sum) value_crop_production value_crop_sales, by (hhid)
lab var value_crop_production "Gross value of crop production for this household"
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hh_crop_production.dta", replace

*Crops lost post-harvest
use "${Ethiopia_ESS_W1_temp_data}/sect11_ph_w1.dta", clear
merge m:1 hhid crop_code using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hh_crop_values_production.dta", nogen keep(1 3)
foreach var in ph_s11q15_c {
	summ `var',d 
}

ren ph_s11q15_c share_lost
recode share_lost (.=0)
gen crop_value_lost = value_crop_production * (share_lost/100)
ren ph_s11q09 value_transport_cropsales
recode value_transport_cropsales (.=0)
collapse (sum) crop_value_lost value_transport_cropsales, by (hhid)
lab var crop_value_lost "Value of crops lost between harvest and survey time"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_crop_losses.dta", replace

********************************************************************************
* CROP EXPENSES *
********************************************************************************

	*********************************
	* 			LABOR
	*********************************
use "$Ethiopia_ESS_W1_temp_data/sect3_pp_w1.dta", clear // hired labor post planting 
	ren pp_s3q28_a numberhiredmale
	ren pp_s3q28_d numberhiredfemale
	ren pp_s3q28_g numberhiredchild
	ren pp_s3q28_b dayshiredmale
	ren pp_s3q28_e dayshiredfemale
	ren pp_s3q28_h dayshiredchild
	ren pp_s3q28_c wagehiredmale
	ren pp_s3q28_f wagehiredfemale
	ren pp_s3q28_i wagehiredchild 
	ren pp_s3q29_a numbernonhiredmale
	ren pp_s3q29_c numbernonhiredfemale
	ren pp_s3q29_e numbernonhiredchild
	ren pp_s3q29_b daysnonhiredmale
	ren pp_s3q29_d daysnonhiredfemale
	ren pp_s3q29_f daysnonhiredchild
	ren saq01 region 
	ren saq02 zone 
	ren saq03 woreda 
	ren saq06 kebele 
	ren saq07 ea 
	keep hhid holder_id parcel_id plot_id *hired* 
	gen season="pp"
tempfile postplanting_hired
save `postplanting_hired'

use "${Ethiopia_ESS_W1_temp_data}/sect10_ph_w1.dta" , clear // hired labor post harvest 
	ren ph_s10q01_a numberhiredmale 
	ren ph_s10q01_b dayshiredmale
	ren ph_s10q01_c wagehiredmale //Wage per person/per day
	ren ph_s10q01_d numberhiredfemale
	ren ph_s10q01_e dayshiredfemale
	ren ph_s10q01_f wagehiredfemale
	ren ph_s10q01_g numberhiredchild
	ren ph_s10q01_h dayshiredchild
	ren ph_s10q01_i wagehiredchild
	ren ph_s10q03_a numbernonhiredmale
	ren ph_s10q03_b daysnonhiredmale
	ren ph_s10q03_c numbernonhiredfemale
	ren ph_s10q03_d daysnonhiredfemale
	ren ph_s10q03_e numbernonhiredchild
	ren ph_s10q03_f daysnonhiredchild
	ren saq01 region 
	ren saq02 zone 
	ren saq03 woreda 
	ren saq06 kebele 
	ren saq07 ea 
	keep region zone woreda kebele ea hhid holder_id parcel_id plot_id *hired* 
	collapse (sum) *hired*, by(region zone woreda kebele ea hhid holder_id parcel_id plot_id)
	gen season="ph"
	tempfile postharvesting_hired
	preserve 	
		sort region zone woreda kebele ea hhid holder_id parcel_id plot_id season
		quietly by region zone woreda kebele ea hhid holder_id parcel_id plot_id season:  gen dup = cond(_N==1,0,_n)
		tab dup 
	restore 
save `postharvesting_hired'
	
append using `postplanting_hired' // at plot level 

unab vars : *female
local stubs : subinstr local vars "female" "", all
display "`stubs'"

reshape long `stubs', i(region zone woreda kebele ea hhid holder_id parcel_id plot_id season) j(gender) string
	sort region zone woreda kebele ea hhid holder_id parcel_id plot_id season
reshape long number days wage, i(hhid holder_id parcel_id plot_id gender season) j(labor_type) string 
	gen val = days*number*wage

//Generate "median wages": `wage_`i'_median', `wage_country_median', `all_hired'
merge m:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_weights.dta", nogen keep(1 3) keepusing(weight) //all matched 
merge m:1 hhid holder_id parcel_id plot_id using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_plot_area.dta", nogen keep(1 3) keepusing(area_meas_hectares) // 1,500 not matched from master
gen plotweight = weight*area_meas_hectares //1,500 missing values
recode wage (0=.) 
gen obs=wage!=.

*Median wages 
foreach i in region zone woreda kebele ea hhid {
preserve
	bys `i' season gender : egen obs_`i' = sum(obs)
	collapse (median) wage_`i'=wage [aw=plotweight], by (`i' season gender obs_`i')
	tempfile wage_`i'_median
	save `wage_`i'_median'
restore
}
preserve
collapse (median) wage_country = wage (sum) obs_country=obs [aw=plotweight], by(season gender)
tempfile wage_country_median
save `wage_country_median'
restore

drop obs plotweight wage 
tempfile all_hired
save `all_hired'

*Family labor 
use "$Ethiopia_ESS_W1_temp_data/sect3_pp_w1.dta", clear 
	ren pp_s3q27_a pid1
	ren pp_s3q27_e pid2 
	ren pp_s3q27_i pid3 
	ren pp_s3q27_m pid4
	ren pp_s3q27_q pid5
	ren pp_s3q27_u pid6
	ren pp_s3q27_b weeks_worked1 
	ren pp_s3q27_f weeks_worked2 
	ren pp_s3q27_j weeks_worked3 
	ren pp_s3q27_n weeks_worked4
	ren pp_s3q27_r weeks_worked5
	ren pp_s3q27_v weeks_worked6
	ren pp_s3q27_c days_week1
	ren pp_s3q27_g days_week2 
	ren pp_s3q27_k days_week3 
	ren pp_s3q27_o days_week4
	ren pp_s3q27_s days_week5
	ren pp_s3q27_w days_week6
keep hhid holder_id parcel_id plot_id pid* weeks_worked* days_week*

preserve
	bysort hhid holder_id parcel_id plot_id: gen dup = cond(_N==1,0,_n)
	tab dup 
restore 
gen season="pp"
tempfile postplanting_family
save `postplanting_family'

use "${Ethiopia_ESS_W1_temp_data}/sect10_ph_w1.dta" , clear   
	ren ph_s10q02_a pid1
	ren ph_s10q02_e pid2 
	ren ph_s10q02_i pid3 
	ren ph_s10q02_m pid4
	ren ph_s10q02_q pid5
	ren ph_s10q02_u pid6
	ren ph_s10q02_y pid7
	ren ph_s10q02_ma pid8
	ren ph_s10q02_b weeks_worked1 
	ren ph_s10q02_f weeks_worked2 
	ren ph_s10q02_j weeks_worked3 
	ren ph_s10q02_n weeks_worked4
	ren ph_s10q02_r weeks_worked5
	ren ph_s10q02_v weeks_worked6
	ren ph_s10q02_z weeks_worked7
	ren ph_s10q02_na weeks_worked8
	ren ph_s10q02_c days_week1
	ren ph_s10q02_g days_week2 
	ren ph_s10q02_k days_week3 
	ren ph_s10q02_o days_week4
	ren ph_s10q02_s days_week5
	ren ph_s10q02_w days_week6
	ren ph_s10q02_ka days_week7
	ren ph_s10q02_oa days_week8
keep hhid holder_id parcel_id plot_id pid* weeks_worked* days_week*
preserve
	bysort hhid holder_id parcel_id plot_id: gen dup = cond(_N==1,0,_n)
	tab dup 
restore 
collapse pid* weeks_worked* days_week*, by(hhid holder_id parcel_id plot_id)
gen season="ph"
tempfile postharvesting_family
save `postharvesting_family'

*Other labor 
use "$Ethiopia_ESS_W1_temp_data/sect3_pp_w1.dta", clear 
	ren pp_s3q29_a numberothermale
	ren pp_s3q29_b daysothermale
	ren pp_s3q29_c numberotherfemale
	ren pp_s3q29_d daysotherfemale
	ren pp_s3q29_e numberotherchild
	ren pp_s3q29_f daysotherchild
keep hhid holder_id parcel_id plot_id number* days* 
gen season = "pp"
tempfile postplanting_other 
preserve
	bysort hhid holder_id parcel_id plot_id: gen dup = cond(_N==1,0,_n)
	tab dup 
restore 
save `postplanting_other'

use "${Ethiopia_ESS_W1_temp_data}/sect10_ph_w1.dta" , clear
	ren ph_s10q03_a numberothermale
	ren ph_s10q03_b daysothermale
	ren ph_s10q03_c numberotherfemale
	ren ph_s10q03_d daysotherfemale
	ren ph_s10q03_e numberotherchild
	ren ph_s10q03_f daysotherchild
keep hhid holder_id parcel_id plot_id number* days* 
collapse number* days*, by(hhid holder_id parcel_id plot_id)
preserve
	bysort hhid holder_id parcel_id plot_id: gen dup = cond(_N==1,0,_n)
	tab dup 
restore 
gen season = "ph"
tempfile postharvesting_other 
save `postharvesting_other'

*Members
use "$Ethiopia_ESS_W1_temp_data/sect1_pp_w1.dta", clear
	ren pp_s1q00 pid
	drop if pid==.
	preserve 
		bysort hhid pid: gen dup=cond(_N==1,0,_n)
		tab dup 
		bysort hhid pid: egen obs_num = sum(1) 
		tab obs_num 
		tab obs_num dup //Every duplicate is associated with only one person
	restore
	ren pp_s1q02 age
	gen male = pp_s1q03==1
	rename saq01 region 
	rename saq02 zone
	rename saq03 woreda
	rename saq06 kebele
	rename saq07 ea
	keep region zone woreda kebele ea hhid pid age male
	collapse (first) age male, by(region zone woreda kebele ea hhid pid)
	codebook male 
tempfile members
save `members', replace

*Use all above labor tempfiles to generate:  plot_labor_long.dta, plot_labor.dta, hh_cost_labor.dta
use `postplanting_family', clear 
append using `postharvesting_family'
preserve 
	bysort hhid holder_id parcel_id plot_id season: gen dup = cond(_N==1,0,_n)
	tab dup 
restore 
reshape long pid weeks_worked days_week, i(hhid holder_id parcel_id plot_id season) j(colid) string 
gen days=weeks_worked*days_week
drop if days==. //319,615 obs deleted 
merge m:1 hhid pid using `members', nogen keep(1 3)
gen gender="child" if age<16
replace gender="male" if strmatch(gender,"") & male==1
replace gender="female" if strmatch(gender,"") & male==0
gen labor_type="family"
keep region zone woreda kebele ea hhid holder_id parcel_id plot_id season gender days labor_type
foreach i in region zone woreda kebele ea hhid {
	merge m:1 `i' gender season using `wage_`i'_median', nogen keep(1 3) 
}
	merge m:1 gender season using `wage_country_median', nogen keep(1 3) // 
	gen wage=wage_hhid
foreach i in region zone woreda kebele ea {
	replace wage = wage_`i' if obs_`i' > 9
}

gen val = wage*days
append using `all_hired'
keep hhid holder_id parcel_id plot_id season days val labor_type gender number
drop if val==.&days==.
merge m:1 hhid /*holder_id*/ parcel_id plot_id using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_plot_decision_makers", nogen keep(1 3) keepusing(dm_gender) // 
**# Check dm_gender missings. 
codebook dm_gender // 1,863 missing values for dm_gender. This is absurd. 
replace dm_gender = 1 if dm_gender==.

collapse (sum) number val days, by(hhid holder_id parcel_id plot_id season labor_type gender dm_gender) 
	la var gender "Gender of worker"
	la var dm_gender "Plot manager gender"
	la var labor_type "Hired, exchange, or family labor"
	la var days "Number of person-days per plot"
	la var val "Total value of hired labor (Naira)"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_plot_labor_long.dta",replace

preserve
	collapse (sum) labor_=days, by (hhid holder_id parcel_id plot_id labor_type  )
	reshape wide labor_, i(hhid holder_id parcel_id plot_id  ) j(labor_type) string
		la var labor_family "Number of family person-days spent on plot, all seasons"
		la var labor_nonhired "Number of exchange (free) person-days spent on plot, all seasons"
		la var labor_hired "Number of hired labor person-days spent on plot, all seasons"
	save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_plot_labor_days.dta",replace //AgQuery
restore

preserve
	gen exp="exp" if strmatch(labor_type,"hired")
	replace exp="imp" if strmatch(exp,"")
	//append using `inkind_payments'
	collapse (sum) val, by(hhid holder_id parcel_id plot_id exp dm_gender)
	gen input="labor"
	save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_plot_labor.dta", replace //this gets used below.
restore	


//And now we go back to wide
collapse (sum) val, by(hhid holder_id parcel_id plot_id season labor_type dm_gender)
ren val val_ 
reshape wide val_, i(hhid holder_id parcel_id plot_id season dm_gender) j(labor_type) string
ren val* val*_
reshape wide val*, i(hhid holder_id parcel_id plot_id dm_gender) j(season) string
gen dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
drop dm_gender 
ren val* val*_
reshape wide val*, i(hhid holder_id parcel_id plot_id) j(dm_gender2) string
collapse (sum) val*, by(hhid)
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hh_cost_labor.dta", replace

*********************************************************************************
* CHEMICALS, FERTILIZER, LAND, ANIMALS, AND MACHINES * 
*********************************************************************************
//commented out section not relevant (copied from Wave 5) due to missing survey questions/variables in W1
/*
use "$Ethiopia_ESS_W1_temp_data/sect7_pp_W1.dta", clear 
gen valmechrent = s7q13b if s7q13==7 
gen valhoerent = s7q13b if s7q13==5
gen valanmlrent = s7q13b if !inlist(s7q13, 5,7,8)
gen valmechmaint= s7q35
ren s7q33 valirrigexp //irrigation cost
//ren household_id hhid 
keep hhid holder_id valmechmaint valmechrent valanmlrent valirrigexp valhoerent
tempfile rental_costs
save `rental_costs'
*/

**# Plot inputs 
	*** Pesticides/Herbicides/Animals/Machines
use "${Ethiopia_ESS_W1_temp_data}/sect4_pp_w1.dta", clear // Joaquin 04.06.23: This module contains pesticide, herbicide, fungicide info. For these inputs, we only have dummy information, while Nigeria W3 has value and quantity info.
	rename saq01 region 
	rename saq02 zone
	rename saq03 woreda
	rename saq06 kebele
	rename saq07 ea

	rename	pp_s4q05 usepestexp // Pesticide dummy 
	rename	pp_s4q07 usefungexp // Fungicide dummy 
	rename	pp_s4q06 useherbexp  // Herbicide dummy 

	keep crop_code region zone woreda kebele ea hhid holder_id parcel_id plot_id *exp /*qty* unit* */
	//ALT: This is, a little unusually, asked per crop. Because (definitionally) both crops are treated the same if the pesticide is applied to the whole plot, we see some responses that look like duplicates. I assume that duplicate values are repeated answers. No product ids are given, unfortunately.
	
	unab vars : *exp
	local stubs : subinstr local vars "exp" "", all
	display "`stubs'"
	gen dummya = 1
	gen dummyb = sum(dummya)
	drop dummya
	reshape long `stubs', i(hhid holder_id parcel_id plot_id crop_code dummyb) j(exp) string
	gen dummyc = sum(dummyb)
	drop dummyb 
	reshape long use, i(hhid holder_id parcel_id plot_id crop_code dummyc) j(input) string
	recode use (2=.)
	collapse (sum) use, by(hhid holder_id parcel_id plot_id input exp)
	replace use = 1 if use>=2 
	//gen itemcode = 1 // Dummy variable 
	gen qty = .  // JM 09.11.23: The module does not have information on quantity used 
	gen unit = . // JM 09.11.23: The module does not have information on quantity used 
	tempfile plot_inputs
	save `plot_inputs'
	
	***Fertilizer
	
	use "${Ethiopia_ESS_W1_temp_data}/sect3_pp_w1.dta", clear  

	// NGA and ETH both have info at plot level. 

	// Joaquin 04.26: List of relevant variables 
		// Urea:  pp_s3q15 pp_s3q16 pp_s3q16b pp_s3q16c pp_s3q16d pp_s3q17_a pp_s3q17_b
		// DAP:  pp_s3q18 pp_s3q19 pp_s3q19b pp_s3q19c pp_s3q19d pp_s3q20_a pp_s3q20_b
		// NPS:  pp_s3q20a_1 pp_s3q20a_2 pp_s3q20a_3 pp_s3q20a_4 pp_s3q20a_5 pp_s3q20a_6_a pp_s3q20a_6_b
		// Other:  pp_s3q20a pp_s3q20a_7 pp_s3q20b pp_s3q20b_1 pp_s3q20c pp_s3q20d_a pp_s3q20d_b
		// Manure:  pp_s3q21 pp_s3q22_a pp_s3q22_b
		// Compost:  pp_s3q23 pp_s3q24_a pp_s3q24_b
		// Other organic:  pp_s3q25 pp_s3q26_a pp_s3q26_b

	// Joaquin 04.26: Nigeria uses postharvest module. 
	// Joaquin 04.26: Nigeria Item codes: 1 NPK, 2 Urea, 4 Other. 
	// Joaquin 04.26: No quantity information for manure, compost, other inorganic 
	// Joaquin 04.26: There are no transportation costs 
	// Joaquin 04.26: No variables on use of left-over fertilizer, so no "imp" variables and no "exp" reshape. 
	
	preserve
	// Urea
	gen usefertexp1 = 1 if pp_s3q15==1 
	gen qtyfertexp1 = pp_s3q16_a
	gen unitfertexp1 = 1 if pp_s3q15==1 // Qty is in kilos 
	gen valfertexp1 = . if pp_s3q15==1 // CPK: No values in W1

	// DAP 
	gen usefertexp2 = 1 if pp_s3q18==1 
	gen qtyfertexp2 = pp_s3q19_a
	gen unitfertexp2 = 1 if pp_s3q18==1 // Qty is in kilos 
	gen valfertexp2 = . if pp_s3q18==1 // CPK: No values in W1 

	// NPS - CPK: No NPS in W1
	/*gen usefertexp3 = 1 if pp_s3q20a_1==1 
	gen qtyfertexp3 = pp_s3q20a_2
	gen unitfertexp3 = 1 if pp_s3q20a_1==1 // Qty is in kilos 
	gen valfertexp3 = pp_s3q20a_5 if pp_s3q20a_1==1 
	*/
	
	// Use of fertilizer  - CPK: no information aside from if it is being used
	gen usefertexp4 = 1 if pp_s3q14==1 // No qty. Just dummy 

	// Manure
	gen usefertexp5 = 1 if pp_s3q21==1 // No qty. Just dummy 

	// Compost
	gen usefertexp6 = 1 if pp_s3q23==1 

	// Other organic 
	gen usefertexp7 = 1 if pp_s3q25==1 

	/*
	label var itemcodefertexp1 "Urea"
	label var itemcodefertexp2 "DAP"
	label var itemcodefertexp3 "NPS"
	label var itemcodefertexp4 "Other inorganic"
	label var itemcodefertexp5 "Manure"
	label var itemcodefertexp6 "Compost"
	label var itemcodefertexp7 "Other organic"
	*/ 
	
	keep use* qty* val* hhid holder_id parcel_id plot_id
	unab vars : *1
	local stubs : subinstr local vars "1" "", all
	display "`stubs'"
	reshape long `stubs', i(hhid holder_id parcel_id plot_id) j(itemcode)
	unab vars2 : *exp
	local stubs2 : subinstr local vars2 "exp" "", all
	display "`stubs2'"
	reshape long `stubs2', i(hhid holder_id parcel_id plot_id itemcode) j(exp) string 	
	reshape long use qty unit val, i(hhid holder_id parcel_id plot_id itemcode exp) j(input) string
	//collapse (sum) qty* val*, by(hhid holder_id parcel_id plot_id itemcode use)
	label define itemcodefert 1 "Urea" 2 "DAP" 3 "NPS" 4 "Other inorganic" 5 "Manure" 6 "Compost" 7 "Other organic"
	label values itemcode itermcodefert 
	replace input = "inorg" if itemcode>=1 & itemcode<=4 
	replace input = "orgfert" if itemcode>=5 & itemcode<=7 
	tempfile phys_inputs
	save `phys_inputs'
	restore

	
	*Irrigation and Tractor 
	//the following section is mostlycommented out, as W1 does not ask questions related to plot-planting preparation (section 3 post planting w5) and irrigation is handled in "plot managers"
	/*
	//merge m:1 hhid holder_id using `rental_costs', nogen keep(1 3)
	//gen use_irrigation = pp_s3q12==1 //irrigation dummy
	gen use_mech_own  = s3q36==1
	gen use_mech_rent = s3q36==2
	gen use_hoe = s3q36==5
	gen use_anml_own  = inlist(s3q35, 1,8,9) //Counting own and borrowed livestock together for the purpose of explicit expenses. 
	gen use_anml_rent = s3q35==4
	merge 1:1 hhid holder_id parcel_id plot_id using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_planted_area.dta", nogen keep(1 3)
	//Values will be in rent/machine/hectare so we generate quantity = area
	gen qtymechexp = ha_planted if use_mech_rent ==1
	gen qtymechimp = ha_planted if use_mech_own  ==1
	gen qtyanmlimp = ha_planted if use_anml_own  ==1
	gen qtyanmlexp = ha_planted if use_anml_rent ==1
	gen qtyhoeexp = ha_planted if use_hoe == 1 
	//recode valirrigexp=0 if valirrigexp==.
	
	
	//gen qtyirrigexp = ha_planted if use_irrigation==1 & valirrigexp != 0 //"qty" for irrigation is planted area irrigated. 
	//gen qtyirrigimp = ha_planted if use_irrigation==1 & valirrigexp==0
	//Several instances of households reporting irrigation expenses but not reporting any plots under irrigation, about 291 plots that were irrigated without reported irrigation expenses. 
	gen qtyhoeimp = ha_planted if use_hoe == 1 & (valhoerent==0 | valhoerent==.) //difficult to fully impute here because we don't have any info on the relative proportion of owned/rented hoes. 

	foreach i in anml mech hoe /*irrig*/ {
		bys hhid : gen total_area_plan_`i' = sum(qty`i'exp)
			gen prop_`i'=qty`i'exp/total_area_plan_`i'
		}
		gen valanmlexp = prop_anml * valanmlrent 
		gen valmechexp = prop_mech * valmechrent 
		//gen valmechmaintexp = prop_mech * valmechmaint	
		gen valhoeexp = prop_hoe * valhoerent  
	
	drop valanmlrent valmechrent valmechmaint valhoerent 
	reshape long valmech valanml valhoe qtyanml qtymech qtyhoe, i(hhid holder_id parcel_id plot_id) j(exp) string
	reshape long val qty, i(hhid holder_id parcel_id plot_id exp) j(input) string
	gen itemcode=1 //irrelevant here.
	gen unit=1
	tempfile mech_inputs
	save `mech_inputs'
	*/
	
	** plotrents 
	use "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_all_plots.dta", clear 	
	//sort hhid holder_id parcel_id plot_id 	
	//bysort hhid holder_id parcel_id plot_id: gen dup = cond(_N==1,0,_n)
	collapse (first) field_size (sum) ha_planted value_harvest, by(hhid holder_id parcel_id plot_id)
	//merge 1:1 hhid holder_id parcel_id plot_id  using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_plot_area.dta", keep(1 3) keepusing(cultivated) nogen 
	*ren field_size area_meas_hectares

	preserve 
		use "${Ethiopia_ESS_W1_temp_data}/sect2_pp_w1.dta", clear
		// Joaquin 04.26: NGA at plot level, ETH is parcel level. We need plot-level data. 
		// Joaquin 04.26: Perhaps distribute price evenly across plots? Ask what to do about this.
		// Andrew 5/3/2023 : Imputations  
		egen valparrentexp = rowtotal(pp_s2q07_a pp_s2q07_b)
		// Joaquin 05.24.23: Need to add the share of payments 
		keep hhid holder_id parcel_id valparrentexp
		tempfile parcelrents 
		save `parcelrents', replace 
		gen rental_cost_land = valparrentexp
		drop valparrentexp 
		save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hh_rental_parcel.dta", replace 
	restore 

	merge m:1 hhid holder_id parcel_id using `parcelrents', nogen 
	bysort hhid holder_id parcel_id: egen area_meas_hectares_parcel = sum(field_size)
	gen qtyplotrentexp= field_size if (valparrentexp>0 & valparrentexp!=.) //| (pp_s2q07_c>0 & pp_s2q07_c!=.)
	gen valplotrentexp = (field_size/area_meas_hectares_parcel)*valparrentexp if valparrentexp>0 & valparrentexp!=. 
	//replace valplotrentexp = valplotrentexp + (pp_s2q07_c/100)*val_harv if valplotrentexp!=. & pp_s2q07_c!=. & val_harv!=. 
	//replace valplotrentexp = (pp_s2q07_c/100)*value_harvest if valplotrentexp==. & pp_s2q07_c!=. & value_harvest!=. 
	
	gen qtyplotrentimp = field_size if qtyplotrentexp==.
	replace qtyplotrentimp = ha_planted if qtyplotrentimp==. & qtyplotrentexp==.

	//keep if cultivate==1 //No need for uncultivated plots
	keep hhid holder_id parcel_id plot_id qtyplotrentexp* valplotrentexp*
	
	gen useplotrentexp = (qtyplotrentexp>0 & qtyplotrentexp!=.)
	
	reshape long useplotrent valplotrent qtyplotrent, i(hhid holder_id parcel_id plot_id) j(exp) string
	reshape long use val qty, i(hhid holder_id parcel_id plot_id exp) j(input) string
	
	gen unit=(qty!=. & val!=.) 
	gen itemcode=1 //dummy var
	tempfile plotrents
	save `plotrents'
	
		** seeds // JM 06.04.23: We will just generate the necessary variables with missing values. We will use "${Ethiopia_ESS_W3_temp_data}/Post-Planting/sect4_pp_w3.dta" to get use_imprv_seed for person_ids. 

	use "${Ethiopia_ESS_W1_temp_data}/sect4_pp_w1.dta", clear // Joaquin 04.06.23: This module contains seed info. Seed use at plot level. Only seed use. 
	*CPK: had to merge in another section with information on price and value
	merge 1:1 hhid holder_id parcel_id plot_id crop_code  using "${Ethiopia_ESS_W1_temp_data}/sect5_pp_w1.dta",  keep(1 3) nogen 
	// Andrew 5/3/2023: AgQuery+ does not track seed expenses 
	// Generate varaibles with missing for where infromation is missing 
	// We care about improved seed 
	gen itemcode = pp_s4q11 // traditional==1, improved==2
	drop if pp_s4q11 ==3 // need to drop trees from this
	gen exp = "exp" if itemcode==2 
	replace exp = "imp" if itemcode==1
	gen use = (itemcode!=.)
	gen qty = pp_s5q19_a if pp_s5q19_a!=. & pp_s5q19_b==. 
	replace qty = pp_s5q19_b/1000 if pp_s5q19_a==. & pp_s5q19_b!=. 
	replace qty = pp_s5q19_a + pp_s5q19_b/1000 if pp_s5q19_a!=. & pp_s5q19_b!=. 
	gen unit = 1 if qty!=. // 1 == kg 
	gen val = pp_s5q08 // What was the value of all the [Seed] that you purchased on credit? (BIRR)
	gen input = "seeds" if use==1 
	collapse (sum) use val qty, by(hhid holder_id parcel_id plot_id exp input itemcode unit)
	replace qty = . if qty==0 & use==1 
	replace val = . if exp!="exp" // JM 09.11.23: Value is available ONLY for improved seeds 
	drop if itemcode ==. 
	//recode val (.=0) // Joaquin 6.12.23: Added this line-faq
	
	* Append // Joaquin 6.12.23: Added this sub-subsection
	
	append using `plotrents'
	gen source_file = "plotrents"
	append using `plot_inputs'
	replace source_file = "plot_inputs" if source_file == ""
	append using `phys_inputs'
	replace source_file = "phys_inputs" if source_file == ""
	//append using `mech_inputs'
	//replace source_file = "mech_inputs" if source_file == ""

*Merging plot inputs 
	
	merge m:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_weights.dta",nogen keep(1 3) keepusing(weight_pop_rururb)
	merge m:1 hhid holder_id parcel_id plot_id using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_plot_area.dta", nogen keep(1 3) keepusing(area_meas_hectares)
	merge m:1 hhid parcel_id plot_id using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_plot_decision_makers",nogen keep(1 3) keepusing(dm_gender)
	replace dm_gender = 1 if dm_gender == . // Joaquin 7.7.23: Obs are not presenst in plot_decision_maker
	merge m:1  hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hhsize.dta", nogen keep(1 3) keepusing(region zone woreda kebele ea) 
	
	preserve
		//Need this for quantities and not sure where it should go.
		keep if strmatch(input,"orgfert") | strmatch(input,"inorg") | strmatch(input,"herb") | strmatch(input,"pest") | strmatch(input,"fung") 
		 
		//label define itemcodefert 1 "Urea" 2 "DAP" 3 "NPS" 4 "Other inorganic" 5 "Manure" 6 "Compost" 7 "Other organic"
		gen urea_kg =qty*itemcode==1
		gen dap_kg = qty*itemcode==2
		gen nps_kg = qty*itemcode==3
		gen n_kg = urea_kg * 0.46 + dap_kg * 0.18 + nps_kg * 0.19
		gen p_kg = dap_kg * 0.46 + nps_kg * 0.38
		gen k_kg = 0 
		gen herb_kg = qty*strmatch(input, "herb")
		gen pest_kg = qty*strmatch(input, "pest")
		gen fung_kg = qty*strmatch(input, "fung")
		gen inorg_fert_kg = qty*strmatch(input, "inorg")
		gen org_fert_kg = qty if itemcode >=5 & itemcode!=.
		collapse (sum) *kg, by(hhid holder_id parcel_id plot_id)
		 //collapse (max) use_irrigation (sum) *kg, by(hhid holder_id parcel_id plot_id)
		la var inorg_fert_kg "Kg inorganic fertilizer used"
		la var org_fert_kg "Kg organic fertilizer used"
		la var herb_kg "Kg of herbicide used"
		la var pest_kg "Kg of pesticide used"
		la var fung_kg "Kg of fungicide used"
		la var urea_kg "Kg of urea applied"
		la var dap_kg "Kg of DAP applied"
		la var nps_kg "Kg of NPS applied"
		la var n_kg "Kg of nitrogen applied"
		la var p_kg "Kg of phosphorus applied"
		la var k_kg "Kg of potassium applied"
		save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_input_quantities.dta", replace
		/*
		use "${Ethiopia_ESS_W5_created_data}/Ethiopia_ESS_W5_input_quantities.dta", clear
		JM 09.11.23: Need to create "use_input" variables as dummies. qty_input does not account for bin ary information. 
		*/
	restore

	tempfile all_plot_inputs 
	save `all_plot_inputs' 

	keep if strmatch(exp,"exp") // & qty!=. //Now for geographic medians
	gen plotweight = weight*area_meas_hectares // Joaquin 6.12.23: Q for Andrew: use weight or weight_pop_rururb?
	//recode val (0=.) // JM 09.11.23: Most of our use variables are binary. doing the recode would erase most of them.  
	//drop if unit==0 //Remove things with unknown units.
	gen price = val/qty if val!=. & qty!=. & qty>0 
	drop if price==.
	gen obs=1
	
	foreach i in region zone woreda kebele ea hhid {
	preserve
		bys `i' input unit itemcode : egen obs_`i' = sum(obs)
		collapse (median) price_`i'=price [aw=plotweight], by (`i' input unit itemcode obs_`i')
		tempfile price_`i'_median
		save `price_`i'_median'
	restore
	}

	preserve
		bys input unit itemcode : egen obs_country = sum(obs)
		collapse (median) price_country = price [aw=plotweight], by(input unit itemcode obs_country)
		tempfile price_country_median
		save `price_country_median'
	restore

	use `all_plot_inputs',clear
	foreach i in region zone woreda kebele ea hhid {
		merge m:1 `i' input unit itemcode using `price_`i'_median', nogen keep(1 3) 
	}
		merge m:1 input unit itemcode using `price_country_median', nogen keep(1 3)
		recode price_hhid (.=0)
		gen price=price_hhid
	foreach i in country region zone woreda kebele ea hhid {
		replace price = price_`i' if obs_`i' > 9 & obs_`i'!=. 
	}
	//Default to household prices when available
	replace price = price_hhid if price_hhid>0
	//replace qty = 0 if qty <0 //4 households reporting negative quantities of fertilizer.
	//recode val qty (.=0)
	//drop if val==0 & qty==0 //Dropping unnecessary observations.
	replace val=qty*price if val==0 & qty!=. & qty>0 
	//replace input = "orgfert" if input=="" itemcode>=5 & itemcode<=7 // JM 7.6.23: Look for itemcode for organic fertilizer
	//replace input = "inorg" if strmatch(input,"fert")
	tab input
	drop if exp == ""
		
	append using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_plot_labor.dta"
	collapse (sum) val, by (hhid holder_id parcel_id plot_id exp input dm_gender)
	save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_plot_cost_inputs_long.dta",replace 
	
	preserve
		collapse (sum) val, by(hhid exp input) 
		save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hh_cost_inputs_long.dta", replace //ALT 02.07.2022: Holdover from W4.
	restore

	preserve
		collapse (sum) val_=val, by(hhid holder_id parcel_id plot_id exp dm_gender)
		reshape wide val_, i(hhid holder_id parcel_id plot_id dm_gender) j(exp) string
		save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_plot_cost_inputs.dta", replace //This gets used below.
restore		
		
	//This version of the code retains identities for all inputs; not strictly necessary for later analyses.
	ren val val_ 
	reshape wide val_, i(hhid holder_id parcel_id plot_id exp dm_gender) j(input) string
	ren val* val*_
	reshape wide val*, i(hhid holder_id parcel_id plot_id dm_gender) j(exp) string
	gen dm_gender2 = "male" if dm_gender==1
	replace dm_gender2 = "female" if dm_gender==2
	replace dm_gender2 = "mixed" if dm_gender==3
	drop dm_gender
	ren val* val*_
	reshape wide val*, i(hhid holder_id parcel_id plot_id) j(dm_gender2) string
	save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_plot_cost_inputs_wide.dta", replace //Used for monocrop plots
	collapse (sum) val*, by(hhid)

	unab vars3 : *_exp_male //just get stubs from one
	local stubs3 : subinstr local vars3 "_exp_male" "", all
	foreach i in `stubs3' {
		egen `i'_exp_hh = rowtotal(`i'_exp_male `i'_exp_female `i'_exp_mixed)
		egen `i'_imp_hh=rowtotal(`i'_exp_hh `i'_imp_male `i'_imp_female `i'_imp_mixed)
	}
	egen val_exp_hh=rowtotal(*_exp_hh)
	egen val_imp_hh=rowtotal(*_imp_hh)
	//drop /*val_mech_imp**/ val_seedtrans_imp* val_transfert_imp* val_feedanml_imp* //Not going to have any data
	save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hh_cost_inputs_verbose.dta", replace
*/

	//We can do this more simply by:
	use "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_plot_cost_inputs_long.dta", clear
	//back to wide
	drop input
	*codebook dm_gender
	collapse (sum) val, by(hhid holder_id parcel_id plot_id exp dm_gender)
	gen dm_gender2 = "male" if dm_gender==1
	replace dm_gender2 = "female" if dm_gender==2
	replace dm_gender2 = "mixed" if dm_gender==3
	drop dm_gender
	codebook dm_gender2 
	
	ren val* val*_
	drop if exp== "" // 4500 obs dropped
	reshape wide val*, i(hhid holder_id parcel_id plot_id dm_gender) j(exp) string
	ren val* val*_
	
	preserve // Get planted area 
		use "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_all_plots.dta",clear
		collapse (sum) ha_planted, by(hhid holder_id parcel_id plot_id)
		tempfile planted_area
		save `planted_area' 
	restore 
	
	merge 1:1 hhid holder_id parcel_id plot_id using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_plot_area.dta", nogen keep(1 3) keepusing(area_meas_hectares) //do per-ha expenses at the same time
	merge 1:1 hhid holder_id parcel_id plot_id using `planted_area', nogen keep(1 3)
reshape wide val*, i(hhid holder_id parcel_id plot_id) j(dm_gender2) string
	collapse (sum) val* area_meas_hectares ha_planted*, by(hhid)
	//Renaming variables to plug into later steps
	foreach i in male female mixed {
	gen cost_expli_`i' = val_exp_`i'
	egen cost_total_`i' = rowtotal(val_exp_`i' val_imp_`i')
	}
	egen cost_expli_hh = rowtotal(val_exp*)
	egen cost_total_hh = rowtotal(val*)
	drop val*
	save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hh_cost_inputs.dta", replace

********************************************************************************
*MONOCROPPED PLOTS*
********************************************************************************
use "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_all_plots.dta", clear
	keep if purestand==1
	merge 1:1 hhid parcel_id plot_id using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
	ren ha_planted monocrop_ha
	ren quant_harv_kg kgs_harv_mono
	ren value_harvest val_harv_mono

forvalues k=1(1)$nb_topcrops  {		
preserve	
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	local cn_full : word `k' of $topcropname_area_full
	keep if crop_code==`c'			
	ren monocrop_ha `cn'_monocrop_ha
	drop if `cn'_monocrop_ha==0 		
	ren kgs_harv_mono kgs_harv_mono_`cn'
	ren val_harv_mono val_harv_mono_`cn'
	gen `cn'_monocrop=1
	la var `cn'_monocrop "HH grows `cn_full' on a monocropped plot"
	save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_`cn'_monocrop.dta", replace
	
	foreach i in `cn'_monocrop_ha kgs_harv_mono_`cn' val_harv_mono_`cn' { 
		gen `i'_male = `i' if dm_gender==1
		gen `i'_female = `i' if dm_gender==2
		gen `i'_mixed = `i' if dm_gender==3
	}
	
	la var `cn'_monocrop_ha "Total `cn' monocrop hectares - Household"
	la var `cn'_monocrop "Household has at least one `cn' monocrop"
	la var kgs_harv_mono_`cn' "Total kilograms of `cn' harvested - Household"
	la var val_harv_mono_`cn' "Value of harvested `cn' (Naira)"
	foreach g in male female mixed {		
		la var `cn'_monocrop_ha_`g' "Total `cn' monocrop hectares on `g' managed plots - Household"
		la var kgs_harv_mono_`cn'_`g' "Total kilograms of `cn' harvested on `g' managed plots - Household"
		la var val_harv_mono_`cn'_`g' "Total value of `cn' harvested on `g' managed plots - Household"
	}
	collapse (sum) *monocrop* kgs_harv* val_harv*, by(hhid)
	save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_`cn'_monocrop_hh_area.dta", replace
restore
}	

use "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_plot_cost_inputs_long.dta", clear
foreach cn in $topcropname_area {
preserve
	keep if strmatch(exp, "exp")
	drop exp
	levelsof input, clean l(input_names)
	ren val val_
	reshape wide val_, i(hhid holder_id parcel_id plot_id dm_gender) j(input) string
	ren val* val*_`cn'_
	gen dm_gender2 = "male" if dm_gender==1
	replace dm_gender2 = "female" if dm_gender==2
	replace dm_gender2 = "mixed" if dm_gender==3
	drop dm_gender
	reshape wide val*, i(hhid holder_id parcel_id plot_id) j(dm_gender2) string
	merge 1:1 hhid holder_id parcel_id plot_id using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_`cn'_monocrop.dta", nogen keep(3)
	collapse (sum) val*, by(hhid)
	foreach i in `input_names' {
		egen val_`i'_`cn'_hh = rowtotal(val_`i'_`cn'_male val_`i'_`cn'_female val_`i'_`cn'_mixed)
	}
	//To do: labels
	save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_inputs_`cn'.dta", replace
restore
}

********************************************************************************
*FARM SIZE *
********************************************************************************
//ALT: 10.29.24: Moved up to plot areas and simplified.

********************************************************************************
*LAND SIZE *
********************************************************************************
//ALT: As above

********************************************************************************
*LIVESTOCK INCOME
********************************************************************************
*Expenses
use "${Ethiopia_ESS_W1_temp_data}/sect8a_ls_w1.dta", clear
ren ls_s8aq62 cost_labor_livestock
ren ls_s8aq64_1 cost_expenses_livestock
recode cost_labor_livestock cost_expenses_livestock (.=0)
gen milk_animals = ls_s8aq20a

preserve
keep if ls_s8aq00==1
collapse (sum) cost_labor_livestock cost_expenses_livestock, by(hhid)
egen cost_lrum = rowtotal(cost_labor_livestock cost_expenses_livestock)
keep hhid cost_lrum
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_lrum_expenses", replace
restore

collapse (sum) cost_labor_livestock cost_expenses_livestock milk_animals, by(hhid)
lab var cost_labor_livestock "Cost for hired labor for livestock"
lab var cost_expenses_livestock "Cost for other expenses for livestock"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_livestock_expenses", replace

//ALT: relocated from below because we need these files in the next section 
********************************************************************************
* MILK PRODUCTIVITY *
********************************************************************************
use "${Ethiopia_ESS_W1_temp_data}/sect8a_ls_w1.dta", clear
gen cows = ls_s8aq00 ==1
keep if cows
gen milk_animals = ls_s8aq21a				// number of livestock milked (by holder)
ren ls_s8aq30 months_milked
ren ls_s8aq32_1 liters_day
gen liters_per_cow = liters_day*365*(months_milked/12)
lab var milk_animals "Number of large ruminants that was milked (household)"
lab var months_milked "Average months milked in last year (household)"
lab var liters_per_cow "average quantity (liters) per year (household)"
collapse (sum) milk_animals liters_per_cow, by(hhid)
keep if milk_animals!=0
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_milk_animals.dta", replace


********************************************************************************
* EGG PRODUCTIVITY *
********************************************************************************
use "${Ethiopia_ESS_W1_temp_data}/sect8a_ls_w1.dta", clear
gen clutching_periods_local = ls_s8aq39			// number of clutching periods per hen in last 12 months (local)
gen clutching_periods_hybrid = ls_s8aq40		// number of clutching periods per hen in last 12 months (hybrid)
gen eggs_clutch_local = ls_s8aq33				// number of eggs per clutch (local)
gen eggs_clutch_hybrid = ls_s8aq34				// number of eggs per clutch (hybrid)
gen laying_hens_local= ls_s8aq14a if ls_s8aq00==8
gen laying_hens_hybrid= ls_s8aq16a if ls_s8aq00==8
egen laying_hens = rowtotal(laying_hens_local laying_hens_hybrid)
gen eggs_per_hen_local = eggs_clutch_local*clutching_periods_local
gen eggs_per_hen_hybrid = eggs_clutch_hybrid*clutching_periods_hybrid
egen eggs_per_hen = rowtotal(eggs_per_hen_local eggs_per_hen_hybrid)
keep if eggs_per_hen!=0
collapse (mean) eggs_per_hen (sum) laying_hens, by(hhid)
ren eggs_per_hen egg_poultry_year
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_eggs_animals.dta", replace


********************************************************************************
* LIVESTOCK PRODUCTS *
********************************************************************************
use "${Ethiopia_ESS_W1_temp_data}/sect8c_ls_w1", clear
ren ls_s8cq06a quant_produced
gen quant_produced_decimal = ls_s8cq06b/1000
egen byproduct_amount = rowtotal(quant_produced quant_produced_decimal)
ren ls_s8cq06c byproduct_unit
ren ls_s8cq00 livestock_product_code
ren ls_s8cq07a quant_sold
gen quant_sold_decimal = ls_s8cq07b/1000
egen product_sold_amount = rowtotal(quant_sold quant_sold_decimal)
ren ls_s8cq07c product_sold_unit
ren ls_s8cq08a product_earnings
ren saq01 region
ren saq02 zone
ren saq03 woreda
ren saq06 kebele
gen price_per_unit = product_earnings/product_sold_amount
gen costs_dairy_birr = ls_s8cq04a if livestock_product_code==1 & ls_s8cq01==1 
gen costs_dairy_cents = ls_s8cq04b if livestock_product_code==1 & ls_s8cq01==1 
egen costs_dairy = rowtotal(costs_dairy_birr costs_dairy_cents)
*gen produce_dairy = (livestock_product_code==1 & ls_s8cq01==1)
recode price_per_unit (0=.)
*CPK- need to destring region to be able to merge with HHID file
destring region, replace force
merge m:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_weights.dta", nogen keep(1 3)
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hh_livestock_products", replace

*Constructing median prices for livestock products
use "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hh_livestock_products", clear
gen country = "ETH" // makes the loop work better
keep if price_per_unit !=.
gen observation = 1
foreach i in kebele woreda zone region country {
	preserve
	collapse (median) price_median_`i'=price_per_unit (rawsum) obs_`i'=obs [aw=weight], by(livestock_product_code `i')
	la var price_median_`i' "Median price per unit for this livestock product in the `i'"
	la var obs_`i' "Number of sales observations for this livestock product in the`i'"
	save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_livestock_products_prices_`i'.dta", replace
	restore
}
gen price_missing=price_per_unit==.
foreach i in country region zone woreda kebele { 
merge m:1 `i' livestock_product_code using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_livestock_products_prices_`i'.dta", nogen
replace price_per_unit = price_median_`i' if obs_`i' > 9 & price_missing==1
} //This runs in descending order of adm_level size, so it'll naturally end up on the smallest one with observations.

lab var price_per_unit "Price per unit of byproduct, imputed with local median prices if household did not sell"
gen value_milk_produced = byproduct_amount*price_per_unit if livestock_product_code==1
gen value_eggs_produced = byproduct_amount*price_per_unit if livestock_product_code==6
gen value_byproduct = byproduct_amount * price_per_unit
recode value_byproduct (.=0)
gen sales_livestock_products = product_earnings

//There are observations where the hh reported having milked cows and the quantity of milk produced per cow but does not report amount of milk produced
//Calculating the value of milk produced reported in livestock section 8.1 but not reported in question ls_s8cq06a
merge m:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_milk_animals", nogen 
gen liters_milk_produced = milk_animals*liters_per_cow if livestock_product_code==1
replace value_milk_produced = liters_milk_produced*price_per_unit if value_milk_produced==0
drop milk_animals liters_per_cow liters_milk_produced
//Calculating the value of eggs produced reported in livestock section 8.1 but not reported in question ls_s8cq06a
merge m:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_eggs_animals.dta"
gen num_eggs_produced = egg_poultry_year*laying_hens if livestock_product_code==6
replace value_eggs_produced = num_eggs_produced*price_per_unit if value_eggs_produced==0 
collapse (sum) value_byproduct value_milk_produced value_eggs_produced sales_livestock_products costs_dairy, by(hhid)
*Share of livestock products sold
*First, constructing total value
gen value_livestock_products = value_byproduct
*Now, the share
gen share_livestock_prod_sold = sales_livestock_products/value_livestock_products
*NOTE: there are quite a few that seem to have higher sales than production; going to cap these at one
replace share_livestock_prod_sold = 1 if share_livestock_prod_sold>1 & share_livestock_prod_sold!=.
lab var share_livestock_prod_sold "Percent of production of livestock products that is sold" 
lab var value_byproduct "Value of animal byproducts produced"
lab var value_milk_produced "Value of milk produced"
lab var value_eggs_produced "Value of eggs produced"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_livestock_products", replace

*Sales (live animals)
*Questionnaire asks about sales of livestock, but doesn't specify whether it's live or slaughtered
*Cannot value purchased animals because the questionnaire doesn't ask anything about the costs spent on purchasing animals, just the number of animals purchased. I don't think that animals would be purchased at the price they are sold at.
*slaughtered animals captured in byproducts (instrument asks about sales of beef, mutton/goat, and camel meat sales and consumption)
use "${Ethiopia_ESS_W1_temp_data}/sect8a_ls_w1.dta", clear
ren ls_s8aq00 livestock_code
ren ls_s8aq44a number_purchased
ren ls_s8aq46a number_sold
ren ls_s8aq47a number_slaughtered
ren ls_s8aq60 value_livestock_sales
recode number_sold number_slaughtered value_livestock_sales (.=0)
gen price_per_animal = value_livestock_sales/number_sold
*generating empty variables because the instrument doesn't have these details
gen income_live_sales =.
gen value_livestock_purchases=.
recode price_per_animal (0=.)
merge m:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hhsize.dta", nogen keep(1 3)
keep hhid weight* region zone woreda kebele ea livestock_code number_sold number_slaughtered price_per_animal value_livestock_sales income_live_sales value_livestock_purchases
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hh_livestock_sales", replace

*Implicit prices (to value livestock owned)
gen obs=1
gen country = "ETH" //makes the loop simpler
foreach i in kebele woreda zone region country {
preserve
	collapse (median) price_median_`i'=price_per_animal (rawsum) obs_`i'=obs [aw=weight_pop_rururb], by(livestock_code `i')
	la var price_median_`i' "Median price per unit for this animal in the `i'"
	la var obs_`i' "Number of sales observations for this animal in the`i'"
	save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_livestock_prices_`i'.dta", replace
restore
}

gen price_missing = price_per_animal==.

foreach i in country region zone woreda kebele { 
merge m:1 `i' livestock_code using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_livestock_prices_`i'.dta", nogen
replace price_per_animal = price_median_`i' if obs_`i' > 9 & price_missing==1
} //This runs in descending order of adm_level size, so it'll naturally end up on the smallest one with observations.
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_lvstck_sold = price_per_animal * number_sold
gen value_slaughtered = price_per_animal * number_slaughtered
collapse (sum) value_livestock_sales value_lvstck_sold value_slaughtered, by (hhid)
lab var value_livestock_sales "Value of livestock sold and slaughtered (with slaughtered livestock that weren't sold valued at local median prices for live animal sales)"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_livestock_sales", replace

********************************************************************************
* TLU (Tropical Livestock Units) *
********************************************************************************
use "${Ethiopia_ESS_W1_temp_data}/sect8a_ls_w1.dta", clear
ren ls_s8aq00 ls_code
gen tlu_coefficient = 0.5 if (ls_code==1 | ls_code==4)
replace tlu_coefficient = 0.1 if (ls_code==2 | ls_code==3)
replace tlu_coefficient = 0.3 if ls_code==5
replace tlu_coefficient = 0.6 if ls_code==6
replace tlu_coefficient = 0.7 if ls_code==7
replace tlu_coefficient = 0.01 if (ls_code==8 | ls_code==9 | ls_code==10 | ls_code==11 | ls_code==12 | ls_code==13)
lab var tlu_coefficient "Tropical Livestock Unit coefficient"

*Owned
gen lvstckid=ls_code 
gen cattle=inrange(lvstckid,1,1)
gen largerum=inrange(lvstckid,1,1) // MGM 8.14.2024: In Ethiopia, number of cattle is number of large rum.
gen smallrum=inrange(lvstckid,2, 3)
gen poultry=inrange(lvstckid,8,13)
gen other_ls=inlist(lvstckid,4, 5, 6,7,14)
gen chickens=inrange(lvstckid,8,13)
ren ls_s8aq13a nb_ls_today 
gen nb_cattle_today=nb_ls_today if cattle==1 
gen nb_largerum_today=nb_ls_today if largerum==1 
gen nb_smallrum_today=nb_ls_today if smallrum==1 
gen nb_poultry_today=nb_ls_today if poultry==1 
gen nb_other_ls_today=nb_ls_today if other_ls==1
gen nb_chickens_today=nb_ls_today if chickens==1
gen nb_cows_today=ls_s8aq20a  if cattle==1  // How many for milk that is cattle
gen tlu_today = nb_ls_today * tlu_coefficient
ren ls_s8aq60 value_livestock_sales
*Bee colonies not captured in TLU.
recode  tlu_* nb_* (.=0)
collapse (sum) tlu_* nb_*  , by (hhid)
lab var nb_cattle_today "Number of cattle owned as of the time of survey"
lab var nb_largerum_today "Number of large ruminant owned as of the time of survey"
lab var nb_smallrum_today "Number of small ruminant owned as of the time of survey"
lab var nb_poultry_today "Number of poultry as of the time of survey"
lab var nb_other_ls_today "Number of other livestock (dog, donkey, and other) owned as of the time of survey"
lab var nb_cows_today "Number of cows owned as of the time of survey"
lab var nb_chickens_today "Number of chickens owned as of the time of survey"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
lab var nb_ls_today "Number of livestock owned as of today"
drop tlu_coefficient
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_TLU_Coefficients.dta", replace 

*TLU (Tropical Livestock Units)
use "${Ethiopia_ESS_W1_temp_data}/sect8a_ls_w1.dta", clear
ren ls_s8aq00 ls_code
gen tlu_coefficient = 0.5 if (ls_code==1 | ls_code==4)
replace tlu_coefficient = 0.1 if (ls_code==2 | ls_code==3)
replace tlu_coefficient = 0.3 if ls_code==5
replace tlu_coefficient = 0.6 if ls_code==6
replace tlu_coefficient = 0.7 if ls_code==7
replace tlu_coefficient = 0.01 if (ls_code==8 | ls_code==9 | ls_code==10 | ls_code==11 | ls_code==12 | ls_code==13)
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
ren ls_code livestock_code
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
collapse (firstnm) share_imp_herd_cows (sum) number_today number_1yearago animals_lost12months number_today_exotic lost_disease lvstck_holding=number_today, by(hhid species)
egen mean_12months = rowmean(number_today number_1yearago)
*And an indicator variable
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
collapse (sum) number_today number_today_exotic (firstnm) *lrum *srum *camel *equine *poultry share_imp_herd_cows, by(hhid)
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
drop lvstck_holding /*animals_lost12months*/ mean_12months
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_herd_characteristics", replace
restore

*Bee colonies not captured in TLU.
gen price_per_animal = value_livestock_sales/number_sold
recode price_per_animal (0=.)
*Merge in prices
merge m:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hhids.dta", keep(1 3) nogen
gen country="ETH"
foreach i in kebele woreda zone region country {
	merge m:1 `i' livestock_code using  "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_livestock_prices_`i'.dta", nogen
	replace price_per_animal = price_median_`i' if obs_`i' > 9 & price_per_animal==.
}
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_today = number_today * price_per_animal
collapse (sum) tlu_today value_today, by (hhid)
lab var tlu_today "Tropical Livestock Units as of the time of survey"
lab var value_today "Value of livestock holdings today"
gen lvstck_holding_tlu = tlu_today
lab var lvstck_holding_tlu "Total HH livestock holdings, TLU"  
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_TLU.dta", replace


********************************************************************************
*SELF-EMPLOYMENT INCOME
********************************************************************************
use "${Ethiopia_ESS_W1_temp_data}/sect11b_hh_w1.dta", clear
ren hh_s11bq09 months_activ  
ren hh_s11bq13 avg_monthly_sales
ren hh_s11bq14 monthly_expenses
*3 observations with positive expenses but missing info on business income. These won't be considered at all.
drop if (monthly_expenses>0 & monthly_expenses!=.) & avg_monthly_sales ==.
recode avg_monthly_sales monthly_expenses (.=0)
gen monthly_profit = (avg_monthly_sales - monthly_expenses)
gen annual_selfemp_profit = monthly_profit * months_activ
recode annual_selfemp_profit (.=0)
collapse (sum) annual_selfemp_profit, by (hhid)
lab var annual_selfemp_profit "Estimated annual net profit from self-employment over previous 12 months"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_self_employment_income.dta", replace

*Female non-farm business owners
use "${Ethiopia_ESS_W1_temp_data}/sect11b_hh_w1.dta", clear
ren hh_s11bq09 months_activ  
ren hh_s11bq13 avg_monthly_sales
ren hh_s11bq14 monthly_expenses
*2 observations with positive expenses but missing info on business income. These won't be considered at all.		
recode avg_monthly_sales monthly_expenses (.=0)
gen monthly_profit = (avg_monthly_sales - monthly_expenses)
gen annual_selfemp_profit = monthly_profit * months_activ
recode annual_selfemp_profit (.=0)
local busowners "hh_s11bq03_a hh_s11bq03_b"
foreach v of local busowners {
	preserve
	keep hhid `v'
	ren `v' bus_owner
	drop if bus_owner==. | bus_owner==0
	tempfile `v'
	save ``v''
	restore
}
use `hh_s11bq03_a', clear
foreach v of local busowners {
	if "`v'"!="`hh_s11bq03_a'" {
		append using ``v''
	}
}
duplicates drop
gen business_owner=1 if bus_owner!=.
ren bus_owner personid
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_business_owners_ind.dta", replace

********************************************************************************
*WAGE INCOME
********************************************************************************
**NON-AG WAGE INCOME
use "${Ethiopia_ESS_W1_temp_data}/sect4_hh_w1.dta", clear
ren hh_s4q10_b occupation_code 
ren hh_s4q11_b industry_code 
ren hh_s4q09 mainwage_yesno
ren hh_s4q13 mainwage_number_months
ren hh_s4q14 mainwage_number_weeks
ren hh_s4q15 mainwage_number_hours
ren hh_s4q16 mainwage_recent_payment
replace mainwage_recent_payment = . if occupation_code==1 | industry_code==1 | industry_code==2
ren hh_s4q17 mainwage_payment_period
ren hh_s4q20 secwage_yesno
ren hh_s4q24 secwage_number_months
ren hh_s4q25 secwage_number_weeks
ren hh_s4q26 secwage_number_hours
ren hh_s4q27 secwage_recent_payment
replace secwage_recent_payment = . if occupation_code==1 | industry_code==1 | industry_code==2
ren hh_s4q28 secwage_payment_period
local vars main sec
*Transforming wage observations into annual values
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
collapse (sum) annual_salary, by (hhid)
lab var annual_salary "Estimated annual earnings from non-agricultural wage employment over previous 12 months"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_wage_income.dta", replace

*AG WAGE INCOME
use "${Ethiopia_ESS_W1_temp_data}/sect4_hh_w1.dta", clear
ren hh_s4q10_b occupation_code 
ren hh_s4q11_b industry_code 
ren hh_s4q09 mainwage_yesno
ren hh_s4q13 mainwage_number_months
ren hh_s4q14 mainwage_number_weeks
ren hh_s4q15 mainwage_number_hours
ren hh_s4q16 mainwage_recent_payment
replace mainwage_recent_payment = . if occupation_code!=1  & industry_code!=1 & industry_code!=2
ren hh_s4q17 mainwage_payment_period
ren hh_s4q20 secwage_yesno
ren hh_s4q24 secwage_number_months
ren hh_s4q25 secwage_number_weeks
ren hh_s4q26 secwage_number_hours
ren hh_s4q27 secwage_recent_payment
replace secwage_recent_payment = . if occupation_code!=1  & industry_code!=1 & industry_code!=2
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
collapse (sum) annual_salary_agwage, by (hhid)
lab var annual_salary_agwage "Estimated annual earnings from agricultural wage employment over previous 12 months"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_agwage_income.dta", replace


********************************************************************************
*OTHER INCOME
********************************************************************************
use "${Ethiopia_ESS_W1_temp_data}/sect12_hh_w1.dta", clear
ren hh_s12q02 amount_received
gen transfer_income = amount_received if hh_s12q00==101|hh_s12q00==102|hh_s12q00==103 /* cash, food, other in-kind transfers */
gen investment_income = amount_received if hh_s12q00==104
gen pension_income = amount_received if hh_s12q00==105
gen rental_income = amount_received if hh_s12q00==106|hh_s12q00==107|hh_s12q00==108|hh_s12q00==109
gen sales_income = amount_received if hh_s12q00==110|hh_s12q00==111|hh_s12q00==112
gen inheritance_income = amount_received if hh_s12q00==113
recode transfer_income pension_income investment_income sales_income inheritance_income (.=0)
collapse (sum) transfer_income pension_income investment_income rental_income sales_income inheritance_income, by (hhid)
lab var transfer_income "Estimated income from cash, food, or other in-kind gifts/transfers over previous 12 months"
lab var pension_income "Estimated income from a pension over previous 12 months"
lab var investment_income "Estimated income from interest or investments over previous 12 months"
lab var sales_income "Estimated income from sales of real estate or other assets over previous 12 months"
lab var rental_income "Estimated income from rentals of buildings, tools, land, transport animals over previous 12 months"
lab var inheritance_income "Estimated income from cinheritance over previous 12 months"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_other_income.dta", replace

use "${Ethiopia_ESS_W1_temp_data}/sect13_hh_w1.dta", clear
ren hh_s13q00 assistance_code
ren hh_s13q03 amount_received 
gen psnp_income = amount_received if assistance_code==1
gen assistance_income = amount_received if assistance_code==2|assistance_code==3|assistance_code==4|assistance_code==5
recode psnp_income assistance_income (.=0)
collapse (sum) psnp_income assistance_income, by (hhid)
lab var psnp_income "Estimated income from a PSNP over previous 12 months"
lab var assistance_income "Estimated income from a food aid, food-for-work, etc. over previous 12 months"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_assistance_income.dta", replace

use "${Ethiopia_ESS_W1_temp_data}/sect2_pp_w1.dta", clear
ren pp_s2q13_a land_rental_income_cash
ren pp_s2q13_b land_rental_income_inkind
recode land_rental_income_cash land_rental_income_inkind (.=0)
gen land_rental_income_upfront = land_rental_income_cash + land_rental_income_inkind
collapse (sum) land_rental_income_upfront, by (hhid)
lab var land_rental_income_upfront "Estimated income from renting out land over previous 12 months (upfront payments only)"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_land_rental_income.dta", replace
*Land rental is also captured in section 12; we refer only to that.
*Valuing sharecropping is otherwise very difficult.
*Income from renting out animals is also captured in the livestock module, but we may be double-counting if that is summed here.


********************************************************************************
*OFF-FARM HOURS
********************************************************************************
use "${Ethiopia_ESS_W1_temp_data}/sect4_hh_w1.dta", clear
gen  hrs_main_wage_off_farm=hh_s4q15 if (hh_s4q11_b>2 & hh_s4q11_b!=.)		// hh_s4q11_b 1 to 2 is agriculture  (exclude mining)  //DYA.10.26.2020  I think this is limited to only 
gen  hrs_sec_wage_off_farm= hh_s4q26 if (hh_s4q21_b>2 & hh_s4q21_b!=.)		// hh_e21_2 1 to 2 is agriculture  
egen hrs_wage_off_farm= rowtotal(hrs_main_wage_off_farm hrs_sec_wage_off_farm) 
gen  hrs_main_wage_on_farm=hh_s4q15 if (hh_s4q11_b<=2 & hh_s4q11_b!=.)		 
gen  hrs_sec_wage_on_farm= hh_s4q26 if (hh_s4q21_b<=2 & hh_s4q21_b!=.)	 
egen hrs_wage_on_farm= rowtotal(hrs_main_wage_on_farm hrs_sec_wage_on_farm) 
drop *main* *sec*
ren hh_s4q08 hrs_unpaid_off_farm
recode  hh_s4q02 hh_s4q03 (.=0)
gen hrs_domest_fire_fuel=(hh_s4q02+ hh_s4q03)*7  // hours worked just yesterday
ren  hh_s4q04 hrs_ag_activ
ren  hh_s4q05 hrs_self_off_farm
egen hrs_off_farm=rowtotal(hrs_wage_off_farm)
egen hrs_on_farm=rowtotal(hrs_ag_activ hrs_wage_on_farm)
egen hrs_domest_all=rowtotal(hrs_domest_fire_fuel)
egen hrs_other_all=rowtotal(hrs_unpaid_off_farm)

foreach v of varlist hrs_* {
	local l`v'=subinstr("`v'", "hrs", "nworker",.)
	gen  `l`v''=`v'!=0
} 
gen member_count = 1
collapse (sum) nworker_* hrs_*  member_count, by(hhid)
la var member_count "Number of HH members age 5 or above"
la var hrs_unpaid_off_farm  "Total household hours - unpaid activities"
la var hrs_ag_activ "Total household hours - agricultural activities"
la var hrs_wage_off_farm "Total household hours - wage off-farm"
la var hrs_wage_on_farm  "Total household hours - wage on-farm"
la var hrs_domest_fire_fuel  "Total household hours - collecting fuel and making fire"
la var hrs_off_farm  "Total household hours - work off-farm"
la var hrs_on_farm  "Total household hours - work on-farm"
la var hrs_domest_all  "Total household hours - domestic activities"
la var hrs_other_all "Total household hours - other activities"
la var nworker_unpaid_off_farm  "Number of HH members with positve hours - unpaid activities"
la var nworker_ag_activ "Number of HH members with positve hours - agricultural activities"
la var nworker_wage_off_farm "Number of HH members with positve hours - wage off-farm"
la var nworker_wage_on_farm  "Number of HH members with positve hours - wage on-farm"
la var nworker_domest_fire_fuel  "Number of HH members with positve hours - collecting fuel and making fire"
la var nworker_off_farm  "Number of HH members with positve hours - work off-farm"
la var nworker_on_farm  "Number of HH members with positve hours - work on-farm"
la var nworker_domest_all  "Number of HH members with positve hours - domestic activities"
la var nworker_other_all "Number of HH members with positve hours - other activities"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_off_farm_hours.dta", replace


********************************************************************************
*FARM LABOR
********************************************************************************
*Farm labor
use "${Ethiopia_ESS_W1_temp_data}/sect3_pp_w1.dta", clear
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
recode weeks_1 days_week_1 weeks_2 days_week_2 weeks_3 days_week_3 weeks_4 days_week_4 weeks_5 days_week_5 weeks_6 days_week_6 (.=0)
gen days_famlabor_postplant = (weeks_1 * days_week_1) + (weeks_2 * days_week_2) + (weeks_3 * days_week_3) + (weeks_4 * days_week_4) + (weeks_5 * days_week_5) + (weeks_6 * days_week_6)
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

*Labor productivity at the plot level
collapse (sum) days_hired_postplant days_famlabor_postplant days_otherlabor_postplant days_hired_postplant_female days_hired_postplant_male days_hired_postplant_child, by (holder_id hhid parcel_id plot_id)
lab var days_famlabor_postplant "Workdays for family labor (crops), as captured in post-planting survey"
lab var days_hired_postplant "Workdays for hired labor (crops), as captured in post-planting survey"
lab var days_hired_postplant_female "Workdays for hired female labor (crops), as captured in post-planting survey"
lab var days_hired_postplant_male "Workdays for hired male labor (crops), as captured in post-planting survey"
lab var days_hired_postplant_child "Workdays for hired child labor (crops), as captured in post-planting survey"
lab var days_otherlabor_postplant "Workdays for other labor (crops), as captured in post-planting survey"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_plot_farmlabor_postplanting.dta", replace

collapse (sum) days_hired_postplant days_famlabor_postplant days_otherlabor_postplant days_hired_postplant_female days_hired_postplant_male days_hired_postplant_child, by (hhid)
lab var days_famlabor_postplant "Workdays for family labor (crops), as captured in post-planting survey"
lab var days_hired_postplant "Workdays for hired labor (crops), as captured in post-planting survey"
lab var days_hired_postplant_female "Workdays for hired female labor (crops), as captured in post-planting survey"
lab var days_hired_postplant_male "Workdays for hired male labor (crops), as captured in post-planting survey"
lab var days_hired_postplant_child "Workdays for hired child labor (crops), as captured in post-planting survey"
lab var days_otherlabor_postplant "Workdays for other labor (crops), as captured in post-planting survey"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_farmlabor_postplanting.dta", replace
*Large outliers with hired labor. These might be larger commercial farms

use "${Ethiopia_ESS_W1_temp_data}/sect10_ph_w1.dta", clear
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
recode weeks_1 days_week_1 weeks_2 days_week_2 weeks_3 days_week_3 weeks_4 days_week_4 weeks_5 days_week_5 weeks_6 days_week_6 weeks_7 days_week_7 (.=0)
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

*Labor productivity at the plot level 
collapse (sum) days_hired_postharvest days_famlabor_postharvest days_otherlabor_postharvest days_hired_postharvest_female days_hired_postharvest_male days_hired_postharvest_child, by (holder_id hhid  parcel_id plot_id)
lab var days_hired_postharvest "Workdays for hired labor (crops), as captured in post-harvest survey"
lab var days_hired_postharvest_female "Workdays for hired female labor (crops), as captured in post-harvest survey"
lab var days_hired_postharvest_male "Workdays for hired male labor (crops), as captured in post-harvest survey"
lab var days_hired_postharvest_child "Workdays for hired child labor (crops), as captured in post-harvest survey"
lab var days_famlabor_postharvest "Workdays for family labor (crops), as captured in post-harvest survey"
lab var days_otherlabor_postharvest "Workdays for other labor (crops), as captured in post-harvest survey"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_plot_farmlabor_postharvest.dta", replace

collapse (sum) days_hired_postharvest days_famlabor_postharvest days_otherlabor_postharvest days_hired_postharvest_female days_hired_postharvest_male days_hired_postharvest_child, by (hhid)
lab var days_hired_postharvest "Workdays for hired labor (crops), as captured in post-harvest survey"
lab var days_hired_postharvest_female "Workdays for hired female labor (crops), as captured in post-harvest survey"
lab var days_hired_postharvest_male "Workdays for hired male labor (crops), as captured in post-harvest survey"
lab var days_hired_postharvest_child "Workdays for hired child labor (crops), as captured in post-harvest survey"
lab var days_famlabor_postharvest "Workdays for family labor (crops), as captured in post-harvest survey"
lab var days_otherlabor_postharvest "Workdays for other labor (crops), as captured in post-harvest survey"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_farmlabor_postharvest.dta", replace
*Captures family labor input up to 8 individuals, but no household reports more than 7, so we shouldn't be missing any labor.

*CPK - added this to follow W3 which used this file in summary stats but not really sure if this section should replace the above code? Different outputs here.
use "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_plot_labor_long.dta", clear
drop if strmatch(gender,"all")
rename labor_type type
replace type="family" if type=="nonhired"
ren days labor_
collapse (sum) labor_, by(hhid type gender)
reshape wide labor_, i(hhid gender) j(type) string
drop if strmatch(gender,"")
ren labor* labor*_
reshape wide labor*, i(hhid) j(gender) string
egen labor_total=rowtotal(labor*)
egen labor_hired = rowtotal(labor_hired*)
egen labor_family = rowtotal(labor_family*)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm in the past year"
lab var labor_hired "Total labor days (hired) allocated to the farm in the past year"
lab var labor_family "Total labor days (family) allocated to the farm in the past year"
lab var labor_hired_male "Workdays for male hired labor allocated to the farm in the past year"		
lab var labor_hired_female "Workdays for female hired labor allocated to the farm in the past year"		
keep hhid labor_total labor_hired labor_family labor_hired_male labor_hired_female
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_family_hired_labor.dta", replace

********************************************************************************
* VACCINE USAGE *
********************************************************************************
use "${Ethiopia_ESS_W1_temp_data}/sect8a_ls_w1.dta", clear
ren ls_s8aq13a number_livestock_owned
ren ls_s8aq51a number_livestock_vaccinated
gen vac_animal=0
replace vac_animal=1 if number_livestock_vaccinated >0 & number_livestock_vaccinated !=.
replace vac_animal=0 if number_livestock_vaccinated==0
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

collapse (max) vac_animal*, by (hhid)
lab var vac_animal "1= Household has an animal vaccinated"
foreach i in vac_animal {
	local l`i' : var lab `i'
	lab var `i'_lrum "`l`i'' - large ruminants"
	lab var `i'_srum "`l`i'' - small ruminants"
	lab var `i'_camels "`l`i'' - camels"
	lab var `i'_equine "`l`i'' - equine"
	lab var `i'_poultry "`l`i'' - poultry"
}
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_vaccine.dta", replace

*Vaccine use livestock keeper (holder)
use "${Ethiopia_ESS_W1_temp_data}/sect8a_ls_w1.dta", clear
ren holder_id farmerid 
rename ls_saq07 personid
gen all_vac_animal=.
replace all_vac_animal=1 if (ls_s8aq51a > 0 & ls_s8aq51a !=.)
replace all_vac_animal=0 if ls_s8aq51a==0
replace all_vac_animal=. if ls_s8aq51a==.
collapse (max) all_vac_animal , by(hhid personid)
drop if personid==.
merge m:1 hhid personid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_gender_merge_both.dta", gen(f_merge)   keep(1 3)			
drop f_merge
gen female_vac_animal=all_vac_animal if female==1
gen male_vac_animal=all_vac_animal if female==0
lab var all_vac_animal "1 = Individual farmer (livestock keeper) uses vaccines"
lab var male_vac_animal "1 = Individual male farmers (livestock keeper) uses vaccines"
lab var female_vac_animal "1 = Individual female farmers (livestock keeper) uses vaccines"
gen livestock_keeper=1 if personid!=.
recode livestock_keeper (.=0)
lab var livestock_keeper "1=Indvidual is listed as a livestock keeper (at least one type of livestock)" 
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_farmer_vaccine.dta", replace

********************************************************************************
* PLOT MANAGERS *
********************************************************************************
use "${Ethiopia_ESS_W1_temp_data}/sect4_pp_w1.dta", clear
gen use_imprv_seed = (pp_s4q11 == 2)
*CPK - come back to this. Not sure what should happen here these are all over the place
recode crop_code (19=12)
recode crop_code (1053=1050) (1061 1062 = 1060) (1081 1082=1080) (1091 1092 1093 = 1090) (1111=1110) (2191 2192 2193=2190) /*Counting this generically as pumpkin, but it is different commodities
	*/				 (3181 3182 3183 3184 = 3180) (2170=2030) (3113 3112 3111 = 3110) (3022=3020) (2142 2141 = 2140) (1121 1122 1123 1124=1120) // JM 091123: Added 
collapse (max) use_imprv_seed, by(hhid holder_id parcel_id plot_id crop_code)
tempfile imprv_seed
save `imprv_seed'

use "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_plot_area.dta", clear 
*CPK - don't have questions about HH decision maker. Instead renamed holder id individual_id and merged on that. Need someone to weigh in on that marginal decision.
*ren pp_s3q10a pid1
*ren  pp_s3q10c_a pid2 
keep hhid holder_id parcel_id plot_id /*pid*/
*reshape long pid, i( hhid holder_id parcel_id plot_id) j(pidno)
*drop pidno
*drop if pid==.
*ren pid personid 
ren holder_id individual_id
merge m:1 hhid individual_id using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_gender_merge_both.dta", nogen keep(1 3)
tempfile personids
save `personids'

use "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_input_quantities.dta", clear
merge 1:1 holder_id hhid parcel_id plot_id using "${Ethiopia_ESS_W1_temp_data}/sect3_pp_w1.dta", nogen keepusing(pp_s3q12)
merge 1:m hhid holder_id parcel_id plot_id using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_all_plots.dta", nogen keepusing(crop_code) 
gen use_irr = pp_s3q12==1
foreach i in inorg_fert org_fert pest herb fung {
	recode `i'_kg (.=0)
	gen use_`i'= `i'_kg > 0
}

collapse (max) use*, by(hhid holder_id parcel_id plot_id crop_code)
merge 1:1 hhid holder_id parcel_id plot_id crop_code using `imprv_seed', nogen 
recode use* (.=0)

preserve 
keep hhid holder_id parcel_id plot_id crop_code use_imprv_seed
ren use_imprv_seed imprv_seed_
gen hybrid_seed_ = .
collapse (max) imprv_seed_ hybrid_seed_, by(hhid crop_code)
merge m:1 crop_code using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_cropname_table.dta", nogen keep(3)
drop crop_code
reshape wide imprv_seed_ hybrid_seed_, i(hhid) j(crop_name) string
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_imprvseed_crop.dta",replace //ALT: this is slowly devolving into a kludgy mess as I try to keep continuity up in the hh_vars section.
restore 


merge m:m hhid holder_id parcel_id plot_id using `personids', nogen keep(1 3)
drop if personid == .
preserve
ren use_imprv_seed all_imprv_seed_
gen all_hybrid_seed_ =.
collapse (max) all*, by(hhid personid female crop_code)
merge m:1 crop_code using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_cropname_table.dta", nogen keep(3)
drop crop_code
gen farmer_=1
/*
bysort hhid holder_id parcel_id plot_id individual_id2 female crop_name: gen dup = cond(_N==1,0,_n)
tab dup 
*/
reshape wide all_imprv_seed_ all_hybrid_seed_ farmer_, i(hhid personid female) j(crop_name) string
recode farmer_* (.=0)
ren farmer_* *_farmer
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_farmer_improvedseed_use.dta", replace
restore

collapse (max) use_*, by(hhid personid female holder_id)
gen all_imprv_seed_use = use_imprv_seed //Legacy

preserve
	collapse (max) use_inorg_fert use_imprv_seed use_org_fert use_pest use_herb use_fung use_irr, by (hhid)
	la var use_inorg_fert "1= Household uses inorganic fertilizer"
	la var use_pest "1 = household uses pesticide"
	la var use_herb "1 = household uses herbicide"
	la var use_fung "1 = household uses fungicide" 
	la var use_org_fert "1= household uses organic fertilizer"
	la var use_imprv_seed "1=household uses improved or hybrid seeds for at least one crop"
	la var use_irr "1=household uses irrigation"
	gen use_hybrid_seed = .
	la var use_hybrid_seed "1=household uses hybrid seeds (not in this wave - see imprv_seed)"
	save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_input_use.dta", replace 
restore

preserve
	ren use_inorg_fert all_use_inorg_fert
	lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
	gen farm_manager=1
	recode farm_manager (.=0)
	lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
	save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_farmer_fert_use.dta", replace //This is currently used for AgQuery.
restore

********************************************************************************
*ANIMAL HEALTH - DISEASES
********************************************************************************
use "${Ethiopia_ESS_W1_temp_data}/sect8a_ls_w1.dta", clear
gen disease_animal = (ls_s8aq41a>0) 
replace disease_animal = . if ls_s8aq41a==.
*no specific disease information
*Disagregating by animal type
ren ls_s8aq00 livestock_code
gen species = (inlist(livestock_code,1)) + 2*(inlist(livestock_code,2,3)) + 3*(inlist(livestock_code,7)) + 4*(inlist(livestock_code,4,5,6)) + 5*(inlist(livestock_code,8,9,10,11,12,13))
recode species (0=.)
la def species 1 "Large ruminants (cows)" 2 "Small ruminants (sheep, goats)" 3 "Camels" 4 "Equine (horses, donkies, mules)" 5 "Poultry"
la val species species
*Using a loop to create species variables
foreach i in disease_animal {
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==2
	gen `i'_camels = `i' if species==3
	gen `i'_equine = `i' if species==4
	gen `i'_poultry = `i' if species==5
}
collapse (max) disease_animal*, by (hhid)
lab var disease_animal "1= Household has an animal vaccinated"
foreach i in disease_animal {
	local l`i' : var lab `i'
	lab var `i'_lrum "`l`i'' - large ruminants"
	lab var `i'_srum "`l`i'' - small ruminants"
	lab var `i'_camels "`l`i'' - camels"
	lab var `i'_equine "`l`i'' - equine"
	lab var `i'_poultry "`l`i'' - poultry"
}
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_livestock_diseases.dta", replace

********************************************************************************
*LIVESTOCK WATER, FEEDING, AND HOUSING
********************************************************************************
*no information 



********************************************************************************
* USE OF INORGANIC FERTILIZER *
********************************************************************************
use "${Ethiopia_ESS_W1_temp_data}/sect3_pp_w1.dta", clear
gen use_inorg_fert=.
replace use_inorg_fert=1 if pp_s3q15==1 | pp_s3q18==1 
collapse (max) use_inorg_fert, by (hhid)
lab var use_inorg_fert "1= Household uses inorganic fertilizer"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_fert_use.dta", replace


********************************************************************************
* USE OF IMPROVED SEED *
********************************************************************************

use "${Ethiopia_ESS_W1_temp_data}/sect4_pp_w1.dta", clear
gen imprv_seed_use=.
replace imprv_seed_use=1 if pp_s4q11==2
replace imprv_seed_use=0 if pp_s4q11==1
replace imprv_seed_use=. if pp_s4q11==.
forvalues k=1(1)$nb_topcrops {
	local c: word `k' of $topcrop_area	
	local cn: word `k' of $topcropname_area
	gen imprv_seed_`cn'=imprv_seed_use if crop_code==`c'
	gen hybrid_seed_`cn'=.		//instrument doesn't ask about hybrid seeds
}
collapse (max) imprv_seed_* hybrid_seed_*, by(hhid)
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	local cnfull: word `k' of $topcropname_full
	lab var imprv_seed_`cn' "1= Household uses improved `cnfull' seed"
}
lab var imprv_seed_use "1= Household uses improved seed"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_improvedseed_use.dta", replace


********************************************************************************
* REACHED BY AG EXTENSION *
********************************************************************************
use "${Ethiopia_ESS_W1_temp_data}/sect3_pp_w1.dta", clear
merge m:m hhid using "${Ethiopia_ESS_W1_temp_data}/sect5_pp_w1.dta", nogen
merge m:m hhid using "${Ethiopia_ESS_W1_temp_data}/sect7_pp_w1.dta", nogen
gen ext_reach_all=0 //misnomer, really "any" i.e. ext_reach_any (note for future)
replace ext_reach_all=1 if (pp_s3q11==1 | pp_s7q04==1 | pp_s5q02==4 | pp_s5q02==5 | pp_s5q02==6)
// 4 = "advice from extension officer"; 5 = "advice from input supplier"; 6 = "advice from fellow farmer"

gen advice_gov = .
gen advice_ngo = .
gen advice_coop = .
// note: not including "advice from extension officer" in above vars bc survey does not specify officer employment (NGO, coop, gov)
gen advice_farmer = .
replace advice_farmer = 1 if pp_s5q02 == 6 // "advice from fellow farmer" re: seed choice
gen advice_radio = .
gen advice_pub = .
gen advice_neigh = .
gen advice_other = . 
gen ext_reach_public = .
replace ext_reach_public = 1 if pp_s5q02 == 4 // assuming that extension officer counts as "public" 
gen ext_reach_private = .
replace ext_reach_private = 1 if pp_s5q02 == 5 // assuming that input supplier counts as "private" 
gen ext_reach_ict = .

collapse (max) ext*, by (hhid)
lab var ext_reach_all "1 = Household reached by extensition services - all sources"
lab var ext_reach_public "1 = Household reached by extensition services - public sources"
lab var ext_reach_private "1 = Household reached by extensition services - private sources" 
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_any_ext.dta", replace

********************************************************************************
* MOBILE OWNERSHIP*
********************************************************************************
use "${Ethiopia_ESS_W1_temp_data}/sect10_hh_w1.dta", clear
//DYA.11.13.2020 recode missing to 0 in hh_s10q01 (0 mobile owned if missing)
recode hh_s10q01 (.=0)
gen  hh_number_mobile_owned=hh_s10q01 if hh_s10q00==8
recode hh_number_mobile_owned (.=0) //DYA.11.13.2020 recode missing to 0
gen mobile_owned= hh_number_mobile_owned>0 //DYA.11.13.2020 
collapse (max) mobile_owned, by(hhid)
keep hhid mobile_owned
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_2012_mobile_own", replace

********************************************************************************
* IRRIGATION *
********************************************************************************
//ALT: Moved to plot inputs


********************************************************************************
* USE OF FORMAL FINANCIAL SERVICES *
********************************************************************************
use "${Ethiopia_ESS_W1_temp_data}/sect14a_hh_w1.dta", clear
merge m:m hhid using "${Ethiopia_ESS_W1_temp_data}/sect11b_hh_w1.dta", nogen
*Questionnaire only asks about credit services; Creating all as missing
gen borrow_relative= .
gen borrow_neigbor= .
gen borrow_localmerchant= .
gen borrow_moneylender= .
gen borrow_employer= .
gen borrow_religiousinstitution= .
gen borrow_micro= .
gen borrow_bank= .
gen borrow_ngo= .
gen borrow_other= .
gen use_fin_serv=0
replace use_fin_serv=1 if hh_s14q02==7 |  hh_s14q02==8 | hh_s11bq04_a==6 | hh_s11bq04_a==9 | hh_s11bq04_b==6 | hh_s11bq04_b==9
ren use_fin_serv use_fin_serv_credit
collapse (max) use_fin_serv_credit, by (hhid)
recode use_fin_serv_credit (.=0)
lab var use_fin_serv_credit "1= Household uses formal financial services
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_fin_serv.dta", replace 

*************************************
* CROP PRODUCTION COSTS PER HECTARE *
*************************************
use "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_all_plots.dta", clear
collapse (sum) ha_planted ha_harvest, by(hhid holder_id parcel_id plot_id purestand field_size)
reshape long ha_, i(hhid holder_id parcel_id plot_id purestand field_size) j(area_type) string
tempfile plot_areas
save `plot_areas'

use "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_plot_cost_inputs_long.dta", clear
collapse (sum) cost_=val, by(hhid holder_id parcel_id plot_id dm_gender exp)
reshape wide cost_, i(hhid holder_id parcel_id plot_id dm_gender) j(exp) string
recode cost_exp cost_imp (.=0)
gen cost_total=cost_imp+cost_exp
drop cost_imp
merge 1:m hhid holder_id parcel_id plot_id using `plot_areas', nogen keep(3)
//reshape long cost_, i(hhid plot_id dm_gender) j(exp) string
//replace cost_ = cost_/ha_
gen cost_exp_ha_ = cost_exp/ha_ 
gen cost_total_ha_ = cost_total/ha_
collapse (mean) cost*ha_ [aw=field_size], by(hhid dm_gender area_type)
gen dm_gender2 = "male"
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
drop dm_gender
replace area_type = "harvested" if strmatch(area_type,"harvest")
reshape wide cost*_, i(hhid dm_gender2) j(area_type) string
ren cost* cost*_
reshape wide cost*, i(hhid) j(dm_gender2) string

foreach i in male female mixed {
	foreach j in planted harvested {
		la var cost_exp_ha_`j'_`i' "Explicit cost per hectare by area `j', `i'-managed plots"
		la var cost_total_ha_`j'_`i' "Total cost per hectare by area `j', `i'-managed plots"
	}
}
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_cropcosts.dta", replace

********************************************************************************
* RATE OF FERTILIZER APPLICATION * SRK: Combining with irrigation (per ALT W5 commit)
********************************************************************************
// note that application rates get calculated during winsorization; this is just predefinition work.

* AREA PLANTED IRRIGATED
use "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_planted_area.dta", clear
merge 1:1 hhid holder_id parcel_id plot_id using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_plot_decision_makers.dta", nogen keep(1 3)
merge 1:1 hhid holder_id parcel_id plot_id using "${Ethiopia_ESS_W1_temp_data}/sect3_pp_w1.dta", nogen keepusing(pp_s3q12)
merge 1:1 hhid holder_id parcel_id plot_id using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_input_quantities.dta", nogen keep(1 3) 
drop if ha_planted==0
ren pp_s3q12 plot_irr
recode plot_irr (2=0) // 2 is "No"
gen ha_irr_ = plot_irr * ha_planted
unab vars : *kg 
local vars `vars' ha_irr ha_planted
recode *kg (.=0)
gen dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
replace dm_gender2 = "other" if dm_gender==. 
drop dm_gender
ren *kg *kg_ 
ren ha_planted ha_planted_
//ren qty_dung dung_kg_
//ren qty_herb herb_kg_
//ren qty_pest pest_kg_
//ren ha_planted ha_planted_

reshape wide *_, i(hhid holder_id parcel_id plot_id) j(dm_gender2) string
collapse (sum) ha_planted_* *kg* ha_irr_*, by(hhid)

foreach i in `vars' {
	egen `i' = rowtotal(`i'_*)
}


drop *other* //Need this for household totals but otherwise we don't track plots with unknown management
//Some high inorg fert rates as a result of large tonnages on small plots. 
lab var inorg_fert_kg "Inorganic fertilizer (kgs) for household"
lab var org_fert_kg "Organic fertilizer (kgs) for household" 
lab var pest_kg "Pesticide (kgs) for household"
lab var herb_kg "Herbicide (kgs) for household"
lab var fung_kg "Fungicide (kgs) for household"
lab var dap_kg "DAP (kgs) for household"
lab var urea_kg "Urea (kgs) for household"
la var nps_kg "NPS fertilizer (kgs) for household"
la var n_kg "Nitrogen from inorganic fertilizers (kg) for hh"
la var p_kg "Phosphorus from inorganic fertilizers (kg) for hh"
la var k_kg "Potassium from inorganic fertilizers (kg) for hh"
la var ha_irr "Planted area under irrigation (ha) for hh"
lab var ha_planted "Area planted (ha), all crops, for household"

foreach i in male female mixed {
lab var inorg_fert_kg_`i' "Inorganic fertilizer (kgs) for `i'-managed plots"
lab var org_fert_kg_`i' "Organic fertilizer (kgs) for `i'-managed plots" 
lab var pest_kg_`i' "Pesticide (kgs) for `i'-managed plots"
lab var herb_kg_`i' "Herbicide (kgs) for `i'-managed plots"
lab var fung_kg_`i' "Fungicide (kgs) for `i'-managed plots"
lab var ha_planted_`i' "Area planted (ha), all crops, `i'-managed plots"
lab var dap_kg_`i' "DAP (kgs) for `i'-managed plots"
lab var urea_kg_`i' "Urea (kgs) for `i'-managed plots"
la var nps_kg_`i' "NPS fertilizer (kgs) for `i'-managed plots"
la var n_kg_`i' "Inorganic N (kg) for `i'-managed plots"
la var p_kg_`i' "Inorganic P (kg) for `i'-managed plots"
la var k_kg_`i' "Inorganic K (kg) for `i'-managed plots"
la var ha_irr_`i' "Planted hectares under irrigation for `i'-managed plots"
lab var ha_planted_`i' "Area planted (ha), all crops, for `i'-managed plots"
}
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_fertilizer_application.dta", replace

********************************************************************************
* WOMEN'S DIET QUALITY
********************************************************************************
*Women's diet quality: proportion of women consuming nutrient-rich foods (%)
*Information not available


********************************************************************************
* DIETARY DIVERSITY
********************************************************************************
**# Bookmark #1


use "${Ethiopia_ESS_W1_temp_data}/sect5a_hh_w1.dta" , clear
* We recode food items to map HDD food categories
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
					(23 24 25 										=12	"SPICES, CONDIMENTS, BEVERAGES")
					, generate(Diet_ID)
					;
#delimit cr
* generate a dummy variable indicating whether the respondent or other member of the household have consumed a food items during the past 7 days 			
gen adiet_yes=(hh_s5aq01==1)
ta adiet_yes   
** Now, we collapse to food group level assuming that if an a household consumes at least one food item in a food group,
* then he has consumed that food group. That is equivalent to taking the MAX of adiet_yes
collapse (max) adiet_yes, by(hhid Diet_ID) 
ren adiet_yes hdds 
collapse (sum) hdds, by(hhid)
*label define YesNo 1 "Yes" 0 "No"
*label val adiet_yes YesNo

* Now, estimate the number of food groups eaten by each household (individual)
local cut_off1=6
local cut_off2=round(r(mean))
gen household_diet_cut_off1=(hdds>=`cut_off1')
gen household_diet_cut_off2=(hdds>=`cut_off2')
lab var household_diet_cut_off1 "1= houseold consumed at least `cut_off1' of the 12 food groups last week" 
lab var household_diet_cut_off2 "1= houseold consumed at least `cut_off2' of the 12 food groups last week" 
label var hdds "Number of food groups individual consumed last week HDDS"
 
// rename to hdds - same as that! 
preserve 
use "${Ethiopia_ESS_W1_temp_data}/sect5b_hh_w1.dta" , clear
ren hh_s5bq02 days 
ren hh_s5bq00 item_id
drop hh_s5bq0a hh_s5bq01

reshape wide days, i(hhid) j(item_id) 

gen max_127 = max(days1, days2, days4)
gen min_127 = min(days1, days2, days4)
egen sum_127 = rowtotal(days1 days2 days4)
gen fcs_A= 7 if  max_127==7 
replace fcs_A = sum_127 if min_127 ==0
replace fcs_A = (max_127+min((sum_127), 7))/2

gen max_36 = max(days3, days16)
gen min_36 = min(days3, days16)
egen sum_36 = rowtotal(days3 days16)
gen fcs_B= 7 if  max_36==7 
replace fcs_B = sum_36 if min_36 ==0
replace fcs_B = (max_36+min((sum_36), 7))/2

gen max_910 = max(days9, days10, days11, days12)
gen min_910 = min(days9, days10, days11, days12)
egen sum_910 = rowtotal(days9 days10 days11 days12)
gen fcs_C= 7 if  max_910==7 
replace fcs_C = sum_910 if min_910 ==0
replace fcs_C = (max_910+min((sum_910), 7))/2

drop days1 days2 days4 days3 days16 days9 days10 days11 days12 max_* min_* sum_* 
ren fcs_A days1
ren fcs_B days2
ren fcs_C days3 

reshape long days, i(hhid) j (item_id)
#delimit ;
recode item_id 	(1 2 4								=1	"CEREALS")  
					(3 16						  		=2	"WHITE ROOTS,TUBERS AND OTHER STARCHES")
					(6 									=3	"NUTS, BEANS AND LENTILS")
					(7								 	=4	"VEGETABLES")
					(9 10 11 12							=5	"MEAT, FISH, ANIMAL PRODUCTS")
					(8									=6	"FRUITS")
					(14									=7  "MILK AND MILK PRODUCTS")
					(13  								=8	"OIL AND FAT")
					(5									=9	"SUGAR AND SUGAR PRODUCTS")
					(15    								=10	"SPICES")
					, generate(item)
					;
#delimit cr

gen weight=.
replace weight = 2 if item == 1  // A
replace weight = 3 if item == 3  // C
replace weight = 1 if item == 4  // D
replace weight = 4 if item == 5  // E
replace weight = 1 if item == 6  // F
replace weight = 4 if item == 7  // G
replace weight = 0.5 if item == 8  // H
replace weight = 0.5 if item == 9  // I

gen fcs=days*weight
collapse (sum) fcs, by(hhid) 
label var fcs "Food Consumption Score"
gen fcs_poor = (fcs <= 21)
gen fcs_borderline = (fcs > 21 & fcs <= 35)
gen fcs_acceptable = (fcs > 35)
label var fcs_poor "1 = Household has poor Food Consumption Score (0-21)"
label var fcs_borderline "1 = Household has borderline Food Consumption Score (21.5 - 35)"
label var fcs_acceptable "1 = Household has acceptable Food Consumption Score (> 35)"
tempfile fcs_hhid
save `fcs_hhid'
restore


preserve 
use "${Ethiopia_ESS_W1_temp_data}/sect7_hh_w1.dta" , clear
keep hh_s7q02_* hhid  
gen rcsi=hh_s7q02_a + hh_s7q02_b + hh_s7q02_c + hh_s7q02_d + 4*hh_s7q02_e + hh_s7q02_f*2+hh_s7q02_h
label var rcsi "Reducing Coping Strategies Index, weighted total of the types of strategies a household uses to avoid insufficient food"
keep hhid rcsi 

gen rcsi_phase1 = (rcsi <= 3)
gen rcsi_phase2 = (rcsi > 3 & rcsi <= 18)
gen rcsi_phase3 = (rcsi > 19 & rcsi <= 42)
gen rcsi_phase4 = (rcsi > 42)
label var rcsi_phase1 "1 = Household rCSI score belongs to IPC Phase 1, minimal food insecurity (0-3)"
label var rcsi_phase2 "1 = Household rCSI score belongs to IPC Phase 2, stressed food insecurity (4 - 18)"
label var rcsi_phase3 "1 = Household rCSI score belongs to IPC Phase 3, crisis food insecurity (19 - 42)"
label var rcsi_phase4 "1 = Household rCSI score belongs to IPC Phase 4, emergency food insecurity (> 42)"
tempfile rcsi_hhid
save `rcsi_hhid' 
restore

merge 1:1 hhid using `rcsi_hhid', nogen 
merge 1:1 hhid using `fcs_hhid', nogen 
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_household_diet.dta", replace

********************************************************************************
*WOMEN'S OWNERSHIP OF ASSETS
********************************************************************************
* FEMALE LAND OWNERSHIP
use "${Ethiopia_ESS_W1_temp_data}/sect2_pp_w1.dta", clear
*Female asset ownership
local landowners "pp_s2q06_a pp_s2q06_b"
keep hhid `landowners' // keep relevant variables
*Transform the data into long form - reshape won't work because of duplicates
*Instead, we will save datasets individually and then append them to one another
foreach v of local landowners   {
	preserve
	keep hhid  `v'
	ren `v'  asset_owner
	drop if asset_owner==. | asset_owner==0
	tempfile `v'
	save ``v''
	restore
}
use `pp_s2q06_a', clear
foreach v of local landowners   {
	if "`v'"!="`pp_s2q06_a'" {
		append using ``v''
	}
}
** remove duplicates by collapse (if a hh member appears at least one time, she/he own/controls land)
duplicates drop 
gen type_asset="land"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_women_land_owner.dta", replace

*FEMALE LIVESTOCK OWNERSHIP
use "${Ethiopia_ESS_W1_temp_data}/sect8a_ls_w1.dta", clear
*Remove poultry-livestocks and beehives
drop if inlist(ls_s8aq00,8,9,10,11,12,13,14.)
local livestockowners "ls_saq07"
keep hhid `livestockowners' 	// keep relevant variables
*Transform the data into long form
foreach v of local livestockowners   {
	preserve
	keep hhid  `v'
	ren `v'  asset_owner
	drop if asset_owner==. | asset_owner==0
	tempfile `v'
	save ``v''
	restore
}
use `ls_saq07', clear
foreach v of local landowners   {
	if "`v'"!="`ls_saq07'" {
		append using ``v''
	}
}
*remove duplicates  
duplicates drop 
gen type_asset="livestock"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_women_livestock_owner.dta", replace

* FEMALE OTHER ASSETS
use "${Ethiopia_ESS_W1_temp_data}/sect10_hh_w1.dta", clear
*keep only productive assets
drop if inlist(hh_s10q00, 4,5,6,9, 11, 13, 16, 26, 27)
local otherassetowners "hh_s10q02_a hh_s10q02_b"
keep hhid  `otherassetowners'
*Transform the data into long form  
foreach v of local otherassetowners   {
	preserve
	keep hhid  `v'
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
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_women_otherasset_owner.dta", replace

* Construct asset ownership variable  *
use "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_women_land_owner.dta", clear
append using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_women_otherasset_owner.dta"
gen own_asset=1 
collapse (max) own_asset, by(hhid asset_owner)
gen hh_s1q00=asset_owner

*Own any asset
*Now merge with member characteristics
merge 1:1 hhid hh_s1q00  using   "${Ethiopia_ESS_W1_temp_data}/sect1_hh_w1.dta"
gen personid = hh_s1q00
drop _m hh_s1q00 individual_id ea_id saq03- hh_s1q02 hh_s1q04_b- hh_s1q21
ren hh_s1q03 mem_gender 
ren hh_s1q04_a mem_age 
ren saq01 region
ren saq02 zone
recode own_asset (.=0)
gen women_asset= own_asset==1 & mem_gender==2
lab  var women_asset "Women ownership of asset"
compress
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_women_asset.dta", replace


********************************************************************************
*WOMEN'S AG DECISION-MAKING
********************************************************************************
*SALES DECISION-MAKERS - INPUT DECISIONS
use "${Ethiopia_ESS_W1_temp_data}/sect3_pp_w1.dta", clear
*Women's decision-making in ag
local planting_input "pp_saq07"
keep hhid `planting_input'	 // keep relevant variables
* Transform the data into long form  
foreach v of local planting_input   {
	preserve
	keep hhid  `v'
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
*Not dropping duplicates because of how we need to construct index for three decision-making vars
gen type_decision="planting_input"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_women_planting_input.dta", replace

*SALES DECISION-MAKERS - ANNUAL SALES
use "${Ethiopia_ESS_W1_temp_data}/sect11_ph_w1.dta", clear
*First, this is for construction of women's decision-making
local control_annualsales "ph_s11q05_a ph_s11q05_b"
keep hhid `control_annualsales' 	// keep relevant variables
* Transform the data into long form  
foreach v of local control_annualsales   {
	preserve
	keep hhid  `v'
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
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_women_control_annualsales.dta", replace

*SALES DECISION-MAKERS - ANNUAL CROP
use "${Ethiopia_ESS_W1_temp_data}/sect11_ph_w1.dta", clear
capture confirm fieldid
if !_rc{
ren fieldid plot_id
}
local sales_annualcrop "ph_saq07 ph_s11q05_a ph_s11q05_b"
keep hhid `sales_annualcrop' 	// keep relevant variables
* Transform the data into long form  
foreach v of local sales_annualcrop   {
	preserve
	keep hhid  `v'
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
*Not dropping duplicates
gen type_decision="sales_annualcrop"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_women_sales_annualcrop.dta", replace

*SALES DECISION-MAKERS - PERM SALES - not asked in wave one

*WOMEN'S CONTROL OVER INCOME - not asked in wave one

*FEMALE LIVESTOCK DECISION-MAKING - MANAGEMENT
use "${Ethiopia_ESS_W1_temp_data}/sect8a_ls_w1.dta", clear
local livestockowners "ls_saq07"
keep hhid `livestockowners' 	// keep relevant variables
* Transform the data into long form  
foreach v of local livestockowners   {
	preserve
	keep hhid  `v'
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
*Not dropping
gen type_decision="manage_livestock"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_women_manage_livestock.dta", replace

*Constructing decision-making ag variable *
use "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_women_planting_input.dta", clear
append using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_women_sales_annualcrop.dta"
append using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_women_manage_livestock.dta"

*Here is why we didn't drop duplicates for these three decisions
bysort hhid decision_maker : egen nb_decision_participation=count(decision_maker)
drop if nb_decision_participation==1	// requires two decisions

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

collapse (max) make_decision_* , by(hhid decision_maker )  //any decision
ren decision_maker hh_s1q00 

*Now merge with member characteristics
merge 1:1 hhid hh_s1q00   using   "${Ethiopia_ESS_W1_temp_data}/sect1_hh_w1.dta"
drop individual_id- hh_s1q02 hh_s1q04_b- _merge
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

collapse (max) women_decision_ag make_decision_ag, by(hhid hh_s1q00)
gen personid = hh_s1q00
compress
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_ag_decision.dta", replace


********************************************************************************
*WOMEN'S CONTROL OVER INCOME
********************************************************************************
* FEMALE LIVESTOCK DECISION-MAKING - SALES
use "${Ethiopia_ESS_W1_temp_data}/sect8a_ls_w1.dta", clear
local control_livestocksales "ls_saq07"
keep hhid `control_livestocksales'	 // keep relevant variables
* Transform the data into long form  
foreach v of local control_livestocksales   {
	preserve
	keep hhid  `v'
	ren `v'  controller_income
	drop if controller_income==. | controller_income==0 | controller_income==99
	tempfile `v'
	save ``v''
	restore
}
use `ls_saq07', clear
foreach v of local control_livestocksales   {
	if "`v'"!="`ls_saq07'" {
		append using ``v''
	}
}
** remove duplicates 
duplicates drop 
gen type_decision="control_livestocksales"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_women_control_livestocksales.dta", replace

* FEMALE DECISION-MAKING - CONTROL OF BUSINESS INCOME
use "${Ethiopia_ESS_W1_temp_data}/sect11b_hh_w1.dta", clear
local control_businessincome "hh_s11bq03_a hh_s11bq03_b"
keep hhid `control_businessincome' 	// keep relevant variables
* Transform the data into long form  
foreach v of local control_businessincome   {
	preserve
	keep hhid  `v'
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
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_women_control_businessincome.dta", replace

* FEMALE DECISION-MAKING - CONTROL OF OTHER INCOME
use "${Ethiopia_ESS_W1_temp_data}/sect12_hh_w1.dta", clear
local control_otherincome "hh_s12q03_a hh_s12q03_b"
keep hhid `control_otherincome' 	// keep relevant variables
* Transform the data into long form  
foreach v of local control_otherincome   {
	preserve
	keep hhid  `v'
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
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_women_control_otherincome.dta", replace

*Constructing decision-making final variable 
use "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_women_control_annualsales.dta",clear
append using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_women_control_livestocksales.dta"
append using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_women_control_businessincome.dta"
append using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_women_control_otherincome.dta"

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
collapse (max) control_* , by(hhid controller_income )  //any decision
preserve
	*	We also need a variable that indicates if a source of income is applicable to a household
	*	and use it to condition the statistics on household with the type of income
	collapse (max) control_*, by(hhid) 
	foreach v of varlist control_cropincome- control_all_income {
		local t`v'=subinstr("`v'",  "control", "hh_has", 1)
		ren `v'   `t`v''
	} 
	tempfile hh_has_income
	save `hh_has_income'
restore
merge m:1 hhid using `hh_has_income'
drop _m
ren controller_income hh_s1q00
*Own any asset
*Now merge with member characteristics
merge 1:1 hhid hh_s1q00   using   "${Ethiopia_ESS_W1_temp_data}/sect1_hh_w1.dta"
drop ea_id- hh_s1q02 hh_s1q04_b- _merge
ren hh_s1q03 mem_gender 
ren hh_s1q04_a mem_age 
recode control_* (.=0)
gen women_control_all_income= control_all_income==1 
gen personid = hh_s1q00
compress
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_control_income.dta", replace

********************************************************************************
*AGRICULTURAL WAGES
********************************************************************************
use "${Ethiopia_ESS_W1_temp_data}/sect3_pp_w1.dta", clear
append using "${Ethiopia_ESS_W1_temp_data}/sect10_ph_w1.dta"
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
collapse (sum) wage* number*, by(hhid)
gen wage_male_pp = wage_perday_men_pp/number_men_pp				// wage per day for a single man
gen wage_female_pp = wage_perday_women_pp/number_women_pp		// wage per day for a single woman
gen wage_child_pp = wage_perday_child_pp/number_child_pp		// wage per day for a single child
recode wage_male_pp wage_female_pp wage_child_pp number* (.=0)			// if they are "hired" but don't get paid, we don't want to consider that a wage observation below
gen wage_male_ph = wage_perday_men_ph/number_men_ph						// wage per day for a single man
gen wage_female_ph = wage_perday_women_ph/number_women_ph				// wage per day for a single woman
gen wage_child_ph = wage_perday_child_ph/number_child_ph				// wage per day for a single child
recode wage_male_ph wage_female_ph wage_child_ph number* (.=0)			// if they are "hired" but don't get paid, we don't want to consider that a wage observation below
*getting weighted average across group of activities to get wage paid at HH level
gen wage_paid_aglabor = (wage_male_pp*number_men_pp+wage_female_pp*number_women_pp+wage_child_pp*number_child_pp+wage_male_ph*number_men_ph+wage_female_ph*number_women_ph+wage_child_ph*number_child_ph)/(number_men_pp+number_women_pp+number_child_pp+number_men_ph+number_women_ph+number_child_ph)
gen wage_paid_aglabor_male = (wage_male_pp*number_men_pp+wage_male_ph*number_men_ph)/(number_men_pp+number_men_ph)
gen wage_paid_aglabor_female = (wage_female_pp*number_women_pp+wage_female_ph*number_women_ph)/(number_women_pp+number_women_ph)
gen wage_paid_aglabor_child = (wage_child_pp*number_child_pp+wage_child_ph*number_child_ph)/(number_child_pp+number_child_ph)
keep hhid wage_paid_aglabor*
lab var wage_paid_aglabor "Daily agricultural wage paid for hired labor (local currency)"
lab var wage_paid_aglabor_female "Daily agricultural wage paid for female hired labor (local currency)"
lab var wage_paid_aglabor_child "Daily agricultural wage paid for child hired labor (local currency)"
lab var wage_paid_aglabor_male "Daily agricultural wage paid for male hired labor (local currency)"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_ag_wage.dta", replace 

********************************************************************************
*CROP YIELDS
********************************************************************************
*Starting with crops
use "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_all_plots.dta", clear // JM 10.19.23: Need to add trees information for all_plots. 
gen number_trees_planted_banana = number_trees_planted if crop_code==2030 
gen number_trees_planted_cassava = number_trees_planted if crop_code==1020 
gen number_trees_planted_cocoa = number_trees_planted if crop_code==3040
recode number_trees_planted_banana number_trees_planted_cassava number_trees_planted_cocoa (.=0) 
collapse (sum) number_trees_planted*, by(hhid)
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_trees.dta", replace
**************** JM 10.19.23: End of new code based on Nigeria

use "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_all_plots.dta", clear
//Legacy stuff- agquery gets handled above.
gen no_harvest=ha_harvest==.
ren quant_harv_kg harvest 
ren ha_planted area_plan
ren ha_harvest area_harv 
gen mixed = "inter"  //Note to adjust this for lost crops 
replace mixed="pure" if purestand==1
gen dm_gender2="unknown"
replace dm_gender2="male" if dm_gender==1
replace dm_gender2="female" if dm_gender==2
replace dm_gender2="mixed" if dm_gender==3

foreach i in harvest area_plan area_harv {	
	foreach j in inter pure {
		gen `i'_`j'=`i' if mixed == "`j'"
		foreach k in male female mixed {
			gen `i'_`j'_`k' = `i' if mixed=="`j'" & dm_gender2=="`k'"
			capture confirm var `i'_`k'
			if _rc {
				gen `i'_`k'=`i' if dm_gender2=="`k'"
			}
		}
	}
}

collapse (sum) harvest* area* (max) no_harvest, by(hhid crop_code)
unab vars : harvest* area*
foreach var in `vars' {
	replace `var' = . if `var'==0 & no_harvest==1
}

replace area_plan = . if area_plan==0
replace area_harv = . if area_plan==. | (area_harv==0 & no_harvest==1)
unab vars2 : area_plan_*
local suffix : subinstr local vars2 "area_plan_" "", all
foreach var in `suffix' {
	replace area_plan_`var' = . if area_plan_`var'==0
	replace harvest_`var'=. if area_plan_`var'==. | (harvest_`var'==0 & no_harvest==1)
	replace area_harv_`var'=. if area_plan_`var'==. | (area_harv_`var'==0 & no_harvest==1)
}
drop no_harvest
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hh_crop_area_plan.dta", replace

*Total planted and harvested area summed accross all plots, crops, and seasons.
preserve
	collapse (sum) all_area_harvested=area_harv all_area_planted=area_plan, by(hhid)
	replace all_area_harvested=all_area_planted if all_area_harvested>all_area_planted & all_area_harvested!=.
	save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hh_area_planted_harvested_allcrops.dta", replace
restore
keep if inlist(crop_code, $comma_topcrop_area)
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_crop_harvest_area_yield.dta", replace

use "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_crop_harvest_area_yield.dta", clear
*Value of crop production
merge m:1 crop_code using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_cropname_table.dta", nogen keep(1 3)
merge 1:1 hhid crop_code using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hh_crop_values_production.dta", nogen keep(1 3)
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
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_trees.dta"
collapse (sum) harvest* area_harv*  area_plan* total_planted_area* total_harv_area* kgs_harvest*   value_harv* value_sold* number_trees_planted*  , by(hhid) 
recode harvest*   area_harv* area_plan* kgs_harvest* total_planted_area* total_harv_area*    value_harv* value_sold* (0=.)
egen kgs_harvest = rowtotal(kgs_harvest_*)
la var kgs_harvest "Quantity harvested of all crops (kgs) (household) (summed accross all seasons)" 

*label variables
foreach p of global topcropname_area {
	lab var value_harv_`p' "Value harvested of `p' (ETB) (household)" 
	lab var value_sold_`p' "Value sold of `p' (ETB) (household)" 
	lab var kgs_harvest_`p'  "Quantity harvested of `p' (kgs) (household)" 
	//lab var kgs_sold_`p'  "Quantity sold of `p' (kgs) (household)" 
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

*Indicator variable for whether a household grew each crop
foreach p of global topcropname_area {
	gen grew_`p'=(total_harv_area_`p'!=. & total_harv_area_`p'!=0 ) | (total_planted_area_`p'!=. & total_planted_area_`p'!=0)
	lab var grew_`p' "1=Household grew `p'"
	gen harvested_`p'= (total_harv_area_`p'!=. & total_harv_area_`p'!=.0 )
	lab var harvested_`p' "1= Household harvested `p'"
}

replace grew_banana =1 if  number_trees_planted_banana!=0 & number_trees_planted_banana!=. 
foreach p of global cropname {
	recode kgs_harvest_`p' (.=0) if grew_`p'==1 
	recode value_sold_`p' (.=0) if grew_`p'==1 
	recode value_harv_`p' (.=0) if grew_`p'==1 
}	
//drop harvest-harvest_pure_mixed area_harv- area_harv_pure_mixed area_plan- area_plan_inter_mixed value_harv kgs_harvest kgs_sold value_sold total_planted_area total_harv_area number_trees_planted_* 
//drop ha_planted // AYW 12.10.19
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_yield_hh_crop_level.dta", replace


* VALUE OF CROP PRODUCTION  // using 335 output
//ALT: This part stays in.
use "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hh_crop_values_production.dta", clear
*Check these - not sure if these are accruate for wave 1 - taken from W3.
*Grouping following IMPACT categories but also mindful of the consumption categories. 
gen crop_group=""
replace crop_group=	"Barley"	if crop_code==	1
replace crop_group=	"Maize"	if crop_code==	2
replace crop_group=	"Millet"	if crop_code==	3
replace crop_group=	"Other cereals"	if crop_code==	4
replace crop_group=	"Other cereals"	if crop_code==	5
replace crop_group=	"Sorghum"	if crop_code==	6
replace crop_group=	"Teff"	if crop_code==	7
replace crop_group=	"Wheat"	if crop_code==	8
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	9
replace crop_group=	"Cassava"	if crop_code==	10
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	11
replace crop_group=	"Beans"	if crop_code==	12
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	13
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	14
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	15
replace crop_group=	"Other other"	if crop_code==	16
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	17
replace crop_group=	"Soyabeans"	if crop_code==	18
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	19
replace crop_group=	"Spices"	if crop_code==	20
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	21
replace crop_group=	"Cotton"	if crop_code==	22
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	23
replace crop_group=	"Groundnuts"	if crop_code==	24
replace crop_group=	"Spices"	if crop_code==	25
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	26
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	27
replace crop_group=	"Oils and fats"	if crop_code==	28
replace crop_group=	"Spices"	if crop_code==	29
replace crop_group=	"Spices"	if crop_code==	30
replace crop_group=	"Spices"	if crop_code==	31
replace crop_group=	"Spices"	if crop_code==	32
replace crop_group=	"Spices"	if crop_code==	33
replace crop_group=	"Spices"	if crop_code==	34
replace crop_group=	"Spices"	if crop_code==	35
replace crop_group=	"Spices"	if crop_code==	36
replace crop_group=	"Spices"	if crop_code==	37
replace crop_group=	"Spices"	if crop_code==	38
replace crop_group=	"Spices"	if crop_code==	39
replace crop_group=	"Spices"	if crop_code==	40
replace crop_group=	"Fruits"	if crop_code==	41
replace crop_group=	"Bananas and plantains"	if crop_code==	42
replace crop_group=	"Fruits"	if crop_code==	43
replace crop_group=	"Fruits"	if crop_code==	44
replace crop_group=	"Fruits"	if crop_code==	45
replace crop_group=	"Fruits"	if crop_code==	46
replace crop_group=	"Fruits"	if crop_code==	47
replace crop_group=	"Fruits"	if crop_code==	48
replace crop_group=	"Fruits"	if crop_code==	49
replace crop_group=	"Fruits"	if crop_code==	50
replace crop_group=	"Vegetables"	if crop_code==	51
replace crop_group=	"Vegetables"	if crop_code==	52
replace crop_group=	"Vegetables"	if crop_code==	53
replace crop_group=	"Vegetables"	if crop_code==	54
replace crop_group=	"Vegetables"	if crop_code==	55
replace crop_group=	"Vegetables"	if crop_code==	56
replace crop_group=	"Vegetables"	if crop_code==	57
replace crop_group=	"Onion"	if crop_code==	58
replace crop_group=	"Vegetables"	if crop_code==	59
replace crop_group=	"Potato"	if crop_code==	60
replace crop_group=	"Vegetables"	if crop_code==	61
replace crop_group=	"Sweet potato"	if crop_code==	62
replace crop_group=	"Vegetables"	if crop_code==	63
replace crop_group=	"Other roots and tubers"	if crop_code==	64
replace crop_group=	"Fruits"	if crop_code==	65
replace crop_group=	"Fruits"	if crop_code==	66
replace crop_group=	"Vegetables"	if crop_code==	67
replace crop_group=	"Vegetables"	if crop_code==	68
replace crop_group=	"Vegetables"	if crop_code==	69
replace crop_group=	"Vegetables"	if crop_code==	70
replace crop_group=	"Other other"	if crop_code==	71
replace crop_group=	"Coffee"	if crop_code==	72
replace crop_group=	"Cotton"	if crop_code==	73
replace crop_group=	"Other other"	if crop_code==	74
replace crop_group=	"Other other"	if crop_code==	75
replace crop_group=	"Sugar"	if crop_code==	76
replace crop_group=	"Tea"	if crop_code==	77
replace crop_group=	"Other other"	if crop_code==	78
replace crop_group=	"Spices"	if crop_code==	79
replace crop_group=	"Spices"	if crop_code==	80
replace crop_group=	"Spices"	if crop_code==	81
replace crop_group=	"Spices"	if crop_code==	82
replace crop_group=	"Fruits"	if crop_code==	83
replace crop_group=	"Fruits"	if crop_code==	84
replace crop_group=	"Other other"	if crop_code==	85
replace crop_group=	"Other other"	if crop_code==	86
replace crop_group=	"Other other"	if crop_code==	97
replace crop_group=	"Yam"	if crop_code==	98
replace crop_group=	"Other other"	if crop_code==	99
replace crop_group=	"Other other"	if crop_code==	100
replace crop_group=	"Other other"	if crop_code==	104
replace crop_group=	"Other other"	if crop_code==	108
replace crop_group=	"Other other"	if crop_code==	110
replace crop_group=	"Other other"	if crop_code==	112
replace crop_group=	"Fruits"	if crop_code==	113
replace crop_group=	"Other other"	if crop_code==	114
replace crop_group=	"Fruits"	if crop_code==	115
replace crop_group=	"Other other"	if crop_code==	116
replace crop_group=	"Spices"	if crop_code==	117
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	118
replace crop_group=	"Oils and fats"	if crop_code==	119
replace crop_group=	"Other cereals"	if crop_code==	120
replace crop_group=	"Other other"	if crop_code==	121
replace crop_group=	"Other other"	if crop_code==	122
replace crop_group=	"Vegetables"	if crop_code==	123
ren  crop_group commodity
gen type_commodity=""
* CJS 10.21 revising commodity high/low classification
replace type_commodity=	"Low"	if crop_code==	1
replace type_commodity=	"Low"	if crop_code==	2
replace type_commodity=	"Low"	if crop_code==	3
replace type_commodity=	"Low"	if crop_code==	4
replace type_commodity=	"High"	if crop_code==	5
replace type_commodity=	"Low"	if crop_code==	6
replace type_commodity=	"Low"	if crop_code==	7
replace type_commodity=	"Low"	if crop_code==	8
replace type_commodity=	"High"	if crop_code==	9
replace type_commodity=	"Low"	if crop_code==	10
replace type_commodity=	"High"	if crop_code==	11
replace type_commodity=	"High"	if crop_code==	12
replace type_commodity=	"High"	if crop_code==	13
replace type_commodity=	"High"	if crop_code==	14
replace type_commodity=	"High"	if crop_code==	15
replace type_commodity=	"High"	if crop_code==	16
replace type_commodity=	"High"	if crop_code==	17
replace type_commodity=	"High"	if crop_code==	18
replace type_commodity=	"High"	if crop_code==	19
replace type_commodity=	"High"	if crop_code==	20
replace type_commodity=	"High"	if crop_code==	21
replace type_commodity=	"Out"	if crop_code==	22
replace type_commodity=	"High"	if crop_code==	23
replace type_commodity=	"High"	if crop_code==	24
replace type_commodity=	"High"	if crop_code==	25
replace type_commodity=	"High"	if crop_code==	26
replace type_commodity=	"High"	if crop_code==	27
replace type_commodity=	"High"	if crop_code==	28
replace type_commodity=	"High"	if crop_code==	29
replace type_commodity=	"High"	if crop_code==	30
replace type_commodity=	"High"	if crop_code==	31
replace type_commodity=	"High"	if crop_code==	32
replace type_commodity=	"High"	if crop_code==	33
replace type_commodity=	"High"	if crop_code==	34
replace type_commodity=	"High"	if crop_code==	35
replace type_commodity=	"High"	if crop_code==	36
replace type_commodity=	"High"	if crop_code==	37
replace type_commodity=	"High"	if crop_code==	38
replace type_commodity=	"High"	if crop_code==	39
replace type_commodity=	"High"	if crop_code==	40
replace type_commodity=	"High"	if crop_code==	41
replace type_commodity=	"Low"	if crop_code==	42
replace type_commodity=	"High"	if crop_code==	43
replace type_commodity=	"High"	if crop_code==	44
replace type_commodity=	"High"	if crop_code==	45
replace type_commodity=	"High"	if crop_code==	46
replace type_commodity=	"High"	if crop_code==	47
replace type_commodity=	"High"	if crop_code==	48
replace type_commodity=	"High"	if crop_code==	49
replace type_commodity=	"High"	if crop_code==	50
replace type_commodity=	"High"	if crop_code==	51
replace type_commodity=	"High"	if crop_code==	52
replace type_commodity=	"High"	if crop_code==	53
replace type_commodity=	"High"	if crop_code==	54
replace type_commodity=	"High"	if crop_code==	55
replace type_commodity=	"High"	if crop_code==	56
replace type_commodity=	"High"	if crop_code==	57
replace type_commodity=	"High"	if crop_code==	58
replace type_commodity=	"High"	if crop_code==	59
replace type_commodity=	"Low"	if crop_code==	60
replace type_commodity=	"High"	if crop_code==	61
replace type_commodity=	"Low"	if crop_code==	62
replace type_commodity=	"High"	if crop_code==	63
replace type_commodity=	"Low"	if crop_code==	64
replace type_commodity=	"High"	if crop_code==	65
replace type_commodity=	"High"	if crop_code==	66
replace type_commodity=	"High"	if crop_code==	67
replace type_commodity=	"High"	if crop_code==	68
replace type_commodity=	"High"	if crop_code==	69
replace type_commodity=	"High"	if crop_code==	70
replace type_commodity=	"Out"	if crop_code==	71
replace type_commodity=	"High"	if crop_code==	72
replace type_commodity=	"Out"	if crop_code==	73
replace type_commodity=	"Out"	if crop_code==	74
replace type_commodity=	"High"	if crop_code==	75
replace type_commodity=	"Out"	if crop_code==	76
replace type_commodity=	"Out"	if crop_code==	77
replace type_commodity=	"Out"	if crop_code==	78
replace type_commodity=	"High"	if crop_code==	79
replace type_commodity=	"High"	if crop_code==	80
replace type_commodity=	"High"	if crop_code==	81
replace type_commodity=	"High"	if crop_code==	82
replace type_commodity=	"High"	if crop_code==	83
replace type_commodity=	"High"	if crop_code==	84
replace type_commodity=	"Out"	if crop_code==	85
replace type_commodity=	"Out"	if crop_code==	86
replace type_commodity=	"Out"	if crop_code==	97
replace type_commodity=	"Low"	if crop_code==	98
replace type_commodity=	"Out"	if crop_code==	99
replace type_commodity=	"Out"	if crop_code==	100
replace type_commodity=	"Out"	if crop_code==	104
replace type_commodity=	"Out"	if crop_code==	108
replace type_commodity=	"Out"	if crop_code==	110
replace type_commodity=	"Out"	if crop_code==	112
replace type_commodity=	"High"	if crop_code==	113
replace type_commodity=	"Out"	if crop_code==	114
replace type_commodity=	"High"	if crop_code==	115
replace type_commodity=	"Out"	if crop_code==	116
replace type_commodity=	"High"	if crop_code==	117
replace type_commodity=	"High"	if crop_code==	118
replace type_commodity=	"High"	if crop_code==	119
replace type_commodity=	"Low"	if crop_code==	120
replace type_commodity=	"Out"	if crop_code==	121
replace type_commodity=	"Out"	if crop_code==	122
replace type_commodity=	"High"	if crop_code==	123
	
preserve
collapse (sum) value_crop_production value_crop_sales, by(hhid commodity) 
ren value_crop_production value_pro
ren value_crop_sales value_sal
separate value_pro, by(commodity)
separate value_sal, by(commodity)
foreach s in pro sal {
	ren value_`s'1 value_`s'_bana
	ren value_`s'2 value_`s'_barl
	ren value_`s'3 value_`s'_bean 
	ren value_`s'4 value_`s'_casav
	ren value_`s'5 value_`s'_coff
	ren value_`s'6 value_`s'_coton 
	ren value_`s'7 value_`s'_fruit 
	ren value_`s'8 value_`s'_gdnut
	ren value_`s'9 value_`s'_maize
	ren value_`s'10 value_`s'_mill
	ren value_`s'11 value_`s'_oilc
	ren value_`s'12 value_`s'_onio
	ren value_`s'13 value_`s'_ocer
	ren value_`s'14 value_`s'_onuts
	ren value_`s'15 value_`s'_oths
	ren value_`s'16 value_`s'_ortub
	ren value_`s'17 value_`s'_pota 
	ren value_`s'18 value_`s'_sorg 
	ren value_`s'19 value_`s'_sybea 
	ren value_`s'20 value_`s'_spice 
	ren value_`s'21 value_`s'_suga 
	ren value_`s'22 value_`s'_spota 
	ren value_`s'23 value_`s'_teff
	ren value_`s'24 value_`s'_vegs
	ren value_`s'25 value_`s'_whea
	ren value_`s'26 value_`s'_yam
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
collapse (sum) value_*, by(hhid)
foreach x of varlist value_* {
	lab var `x' "`l`x''"
}

drop value_pro value_sal
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hh_crop_values_production_grouped.dta", replace
restore

*type of commodity
collapse (sum) value_crop_production value_crop_sales, by( hhid type_commodity) 
ren value_crop_production value_pro
ren value_crop_sales value_sal
separate value_pro, by(type_commodity)
separate value_sal, by(type_commodity)
foreach s in pro sal {
	ren value_`s'1 value_`s'_high
	ren value_`s'2 value_`s'_low
	/*DYA.10.30.2020*/ ren value_`s'3 value_`s'_other
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
collapse (sum) value_*, by(hhid)
foreach x of varlist value_* {
	lab var `x' "`l`x''"
}
drop value_pro value_sal
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hh_crop_values_production_type_crop.dta", replace


********************************************************************************
*SHANNON DIVERSITY INDEX
********************************************************************************
*Bring in area planted
use "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hh_crop_area_plan.dta", clear
*generating area planted of each crop as a proportion of the total area
preserve 
collapse (sum) area_plan_hh=area_plan area_plan_female_hh=area_plan_female area_plan_male_hh=area_plan_male area_plan_mixed_hh=area_plan_mixed, by(hhid)
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hh_crop_area_plan_shannon.dta", replace
restore
merge m:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hh_crop_area_plan_shannon.dta", nogen
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
bysort hhid (sdi_crop_female) : gen allmissing_female = mi(sdi_crop_female[1])
bysort hhid (sdi_crop_male) : gen allmissing_male = mi(sdi_crop_male[1])
bysort hhid (sdi_crop_mixed) : gen allmissing_mixed = mi(sdi_crop_mixed[1])
*Generating number of crops per household
bysort hhid crop_code : gen nvals_tot = _n==1
gen nvals_female = nvals_tot if area_plan_female!=0 & area_plan_female!=.
gen nvals_male = nvals_tot if area_plan_male!=0 & area_plan_male!=. 
gen nvals_mixed = nvals_tot if area_plan_mixed!=0 & area_plan_mixed!=.
collapse (sum) sdi=sdi_crop sdi_female=sdi_crop_female sdi_male=sdi_crop_male sdi_mixed=sdi_crop_mixed num_crops_hh=nvals_tot num_crops_female=nvals_female ///
num_crops_male=nvals_male num_crops_mixed=nvals_mixed (max) allmissing_female allmissing_male allmissing_mixed, by(hhid)
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
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_shannon_diversity_index.dta", replace
*CPK: old code 
/*
*Bring in area planted
use "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hh_crop_area_plan_SDI.dta", clear
*generating area planted of each crop as a proportion of the total area
preserve 
	collapse (sum) area_plan_hh=area_plan, by(hhid)
	save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hh_crop_area_plan_shannon.dta", replace
restore
merge m:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hh_crop_area_plan_shannon.dta", nogen
gen prop_plan = area_plan/area_plan_hh
gen sdi_crop = prop_plan*ln(prop_plan)
*Generating number of crops per household
bysort hhid crop_code : gen nvals_tot = _n==1
collapse (sum) sdi=sdi_crop num_crops_hh=nvals_tot, by(hhid)
la var sdi "Shannon diversity index"
gen encs = exp(-sdi)
la var encs "Effective number of crop species per household"
la var num_crops_hh "Number of crops grown by the household"
gen multiple_crops = (num_crops_hh>1 & num_crops_hh!=.)
la var multiple_crops "Household grows more than one crop"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_shannon_diversity_index.dta", replace
*/

**# Bookmark #3

********************************************************************************
*CONSUMPTION
******************************************************************************** 
use "${Ethiopia_ESS_W1_temp_data}/cons_agg_w1.dta", clear
ren total_cons_ann total_cons
gen peraeq_cons = nom_totcons_aeq
replace total_cons = total_cons * price_index_hce 	// Adjusting for price index 
replace peraeq_cons = peraeq_cons * price_index_hce // Adjusting for price index 
la var peraeq_cons "Household consumption per adult equivalent per year"
gen daily_peraeq_cons = peraeq_cons/365
la var daily_peraeq_cons "Household consumption per adult equivalent per day"
gen percapita_cons = (total_cons / hh_size)
la var percapita_cons "Household consumption per adult equivalent per year"
gen daily_percap_cons = percapita_cons/365
la var daily_percap_cons "Household consumption per adult equivalent per day"
keep hhid total_cons peraeq_cons adulteq daily_peraeq_cons percapita_cons daily_percap_cons 
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_consumption.dta", replace



********************************************************************************
*HOUSEHOLD FOOD PROVISION*
********************************************************************************
use "${Ethiopia_ESS_W1_temp_data}/sect7_hh_w1.dta", clear
numlist "1/11"
forval k=1/11{
	local num: word `k' of `r(numlist)'
	local alph: word `k' of `c(alpha)'
	ren hh_s7q07_`alph' hh_s7q07_`num'
}
ren hh_s7q07_m hh_s7q07_12
forval k=1/12 {
	gen food_insecurity_`k' = (hh_s7q07_`k'=="X")
}
egen months_food_insec = rowtotal(food_insecurity_*) 
replace months_food_insec = 12 if months_food_insec>12
keep hhid months_food_insec 
lab var months_food_insec "Number of months of inadequate food provision" 
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_food_insecurity.dta", replace

********************************************************************************
*HOUSEHOLD ASSETS*
********************************************************************************
*Cannot calculate in this instrument - questionnaire doesn't ask value of HH assets

********************************************************************************
*DISTANCE TO AGRO DEALERS*
********************************************************************************
*Cannot create in this instrument

********************************************************************************
* CROP ROTATION *
********************************************************************************
use "${Ethiopia_ESS_W1_temp_data}/sect7_pp_w1.dta", clear
// ren hhid hhid
ren pp_s7q01 crop_rotation
drop if crop_rotation == 3 // Listed as not-applicable
recode crop_rotation (2=0)

drop if crop_rotation == .

* By HH
collapse (max) crop_rotation, by(hhid)
lab def cr 0 "NO" 1 "YES"
lab val crop_rotation cr
lab var crop_rotation "1=hh has at least one holder that rotates crops on land holdings"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_household_crop_rotation.dta", replace

**# Bookmark #1

********************************************************************************
*POVERTY INDICES
********************************************************************************
/*
This section implements the multidimensional poverty index (MPI) and Alkire & Ul Haq's extension to individual indicators of deprivation (as well as their individual subcomponents) for implementation in AgQuery+
Additional work is needed to integrate this into the standard sumremmary statistics
*/


	******************************
	*WATER, SANITATION & HOUSING *
	******************************
//General idea: Workflow for this section is to get amount paid for sachet/bottled water and amount of time spent collecting water.
//How water-gathering time should be costed is up to some debate, but there seems to be broad agreement around 1/2x the unskilled wage for the given class of worker.
//Disaggregate by man, woman, child and use agricultural as a proxy to get water-gathering costs. Then we can do cost per day per capita as well as estimate the cost tradeoff between sachet and well water

//Water expenses appear in multiple areas: s11q69: how much did you pay for water in the last 30 days, including delivery costs?
//Section 7b/10b: How much did you pay for bottled/sachet water? (150/151)
//Section 8/11: Non food water expenditure (30 days): 312
//Making comparisons:

**# Bookmark #2

//2 and 3 get handled in consumption.
/*Purchases doesn't have water in the raw data 
Data around number of hours spent in the past week to collect water also not present, so can't calculute labor costs. 
*/

**# Bookmark #1

use "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_plot_labor_long.dta", clear
keep if strmatch(season, "pp")
collapse (sum) val days, by(hhid gender)
gen rate = val/days
gen hh_rate = rate
gen obs=1
merge m:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hhsize.dta", nogen keep(1 3) keepusing(weight_pop_rururb region zone woreda kebele ea) //state

foreach i in ea zone {
	preserve
	bys `i' : egen `i'_obs = total(obs)
	collapse (median) `i'_rate = rate [aw=weight_pop_rururb], by(`i' gender `i'_obs)
	tempfile `i'_labor
	save ``i'_labor'
	restore
	merge m:1 `i' gender using ``i'_labor', nogen keep(1 3)
}
preserve
collapse (median) country_rate=rate (sum) country_obs=obs [aw=weight_pop_rururb], by(gender)
tempfile country_labor
save `country_labor'
restore
merge m:1 gender using `country_labor', nogen

foreach i in country zone ea {
	replace rate = `i'_rate if `i'_obs > 9
}
replace rate = hh_rate if hh_rate != . //I think medians should be used for everyone, but this is current practice
foreach i in child male female {
	preserve
	keep if strmatch(gender, "`i'")
	_pctile rate
	scalar wins_thresh=r(p95)
	replace rate = wins_thresh if rate > wins_thresh
	tempfile `i'_rates
	save ``i'_rates'
	restore
}

use `male_rates', clear
append using `female_rates'
append using `child_rates'
replace rate = rate*0.5
keep hhid gender rate
tempfile water_wage_rates
save `water_wage_rates'

use "${Ethiopia_ESS_W1_temp_data}/sect4_hh_w1.dta", clear
merge 1:1 hhid indiv using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_person_ids.dta", nogen keep(1 3)
recode hh_s4q02 (.=0)
gen hrs_water_perday = hh_s4q02 // already for a day 
gen gender = "child" if age<=15
replace gender = "male" if age > 15 & female==0
replace gender = "female" if age > 15 & female==1
collapse (sum) hrs*, by(ea hhid gender)
merge 1:1 hhid gender using `water_wage_rates', nogen keep(3)
gen water_cost_labor = rate * hrs_water_perday/6 //The wage here is the day rate; assuming a workday is 6 hours.
la var water_cost_labor "Daily cost of water-collecting labor hours by gender of hh members"
la var rate "Estimated value of unskilled labor by gender (based value of 0.5 farm labor hours)"
la var hrs_water_perday "Total household hours per day spent collecting water"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_water_labor.dta", replace
collapse (sum) hrs_water_perday water_cost, by(hhid ea)
*merge 1:1 hhid using "${{Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_total_water_costs.dta", nogen
*egen hh_water_labor = rowtotal(water_cost_labor val_water_own)
*egen hh_water_purch = rowtotal(val_water_purch water_mo val_water_services)
*egen hh_water_all = rowtotal(hh_water*)
keep ea hhid hrs* //hh_water_labor hh_water_purch hh_water_all
*la var hh_water_labor "Cost for collected water and value of self-produced bottled/sachet water"
*la var hh_water_purch "Cost of purchased sachet/bottled water and other water services"
*la var hh_water_all "Total hh cost of water"
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_water_costs_hh.dta", replace
			
use "${Ethiopia_ESS_W1_temp_data}/sect9_hh_w1.dta", clear
/*
ren s11q57a travel_time_wet
replace travel_time_wet=travel_time_wet*60 if s11q57b==2
replace travel_time_wet = 0 if travel_time_wet < 1 & s11q57b==1

ren s11q63a travel_time_dry
replace travel_time_dry = travel_time_dry*60 if s11q63b==2
replace travel_time_dry = 0 if travel_time_dry < 1 & s11q63b==1 //Likely wrong units in these instances
recode travel_time* (.=0)
egen travel_time_max = rowmax(travel_time_wet travel_time_dry)

gen water_insecure=s11q65==1
*/
gen has_filter=hh_s9q16==1

//WHO defines safely managed drinking-water as located on premises (q 56/62), available when needed (q65), and free from contamination
//World Bank describes an improved water source as piped, standpipe, tube well, protected well or spring, or rainwater. Alkire and Foster define "available" as <30 min walk away.
replace hh_s9q14 = hh_s9q13 if hh_s9q14==.
*gen dep_water = travel_time_max > 30 | /*(s11q65==1)*/ (!inlist(hh_s9q13, 1, 2, 3, 4, 5, 6, 10, 11, 12, 14, 15, 16) | !inlist(hh_s9q14, 1, 2, 3, 4, 5, 6, 10, 11, 12, 14, 15, 16))
//gen improved_toilet=inrange(s11q36,1,6)
*gen daily_water_bill = s11q69/30 
gen dep_housing = inlist(hh_s9q05, 1, 8, 9) 
//Alkire and Foster say wood, charcoal, or dung. Also including sawdust, crop residue; some 67% of hh's use wood as their primary or secondary source, though.
gen dep_fuel = inlist(hh_s9q21, 3, 4, 6, 7, 8, 9, 11) 
gen dep_elec = hh_s9q19 == 2
//Toilet unimproved or shared. W/B considers a pit latrine with slab as improved, assuming pit latrine w/o slab and hanging toilet are not improved.
gen dep_sanit =  inlist(hh_s9q10, 8, 11, 12)

keep hhid   has_*  dep* //travel_* water_* daily*
//merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_water_costs_hh.dta", nogen
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_mpi_housing.dta", replace

//Household assets in MPI: radio, TV, telephone, computer, animal cart, bike, motorbike, refrigerator, does not own car or truck.
use "${Ethiopia_ESS_W1_temp_data}/sect10_hh_w1.dta", clear
rename hh_s10q00 item_cd
keep if inlist(item_cd, 16, 17) // only cart is there 
recode hh_s10q01 (2=0)
ren hh_s10q01 has_item
keep hhid item_cd has_item
tempfile ag_assets
save `ag_assets'

use "${Ethiopia_ESS_W1_temp_data}/sect10_hh_w1.dta", clear
rename hh_s10q00 item_cd
keep if inlist(item_cd, 22, 14, 15, 23, 9, 10, 7) //no computer, plastic chair 
recode hh_s10q01 (2=0)
ren hh_s10q01 has_item
append using `ag_assets'
gen has_car = (item_cd==23) & has_item==1
drop if item_cd==319
collapse (max) has_car (sum) num_assets=has_item, by(hhid)
gen dep_asset = has_car==0 & num_assets <= 1

save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_mpi_assets.dta", replace

	********************************
	*INDIVIDUAL ACCESS TO EDUCATION*
	********************************
//They also introduce the concept of a pioneer child, which is one that has had at least 6 years of schooling but lives in a household where the parents do not.
use "${Ethiopia_ESS_W1_temp_data}/sect2_hh_w1.dta", clear
drop if hh_s2q01=="" | hh_s2q04==14 //Remove from dataset if the respondent is too young to attend school.
merge 1:1 hhid individual_id using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_person_ids.dta", nogen keep(1 3)
gen years_school = 1*(hh_s2q05==1)+2*(hh_s2q05==2)+3*(hh_s2q05==3)+4*(hh_s2q05==4)+5*(hh_s2q05==5)+6*(hh_s2q05==6) + 7*(hh_s2q05==7) + 8*(hh_s2q05==8) + 9* (hh_s2q05==9) + 10*(hh_s2q05==10)+11*(hh_s2q05==11)+12*inrange(hh_s2q05, 12, 34) //It appears OND/HND are roughly equivalent to the GED. Modern school is a high school. Non-university nursing school appears to be roughly equivalent to a Bachelors in terms of years of education.
//Quranic education is controversial in Nigeria - traditional quranic schools do not provide instruction in typical academic subjects like math, science, etc. (something the Nigerian government has deemed unacceptable), so I consider this to be equivalent to no school.
//replace years_school = . if s2aq9==. & s2aq6!=2 //No one has reported attending school but not provided info

gen in_school = age>=5 & age<=14 & hh_s2q06==1
gen school_eligible = age>=5 & age<=14

gen adult_ed = years_school*(age>=15)
gen child_ed = years_school*(age<15)
gen missing_data = adult_ed==. | child_ed==.
gen hh_mmbrs = 1
collapse (sum) tot_missing=missing_data hh_mmbrs in_school school_eligible (max) adult_ed child_ed, by(hhid)
gen prop_missing = tot_missing/hh_mmbrs 
gen pioneer_child = adult_ed < 6 & child_ed >= 6
gen dep_att = in_school < school_eligible //Households that have no children are considered not deprived in attendance. 
gen dep_edyr = adult_ed < 6 & child_ed < 6
replace dep_edyr = . if tot_missing > 0.33 //No missing values.
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_mpi_edu.dta", replace
/*
**# To Do
*********************************
	*		FOOD SECURITY			*
	*********************************
	//UN SDG 2 defines eliminating hunger as inadequate access to "safe, nutritious, and sufficient food year round"
	//8b: about healthy and nutritious/preferred foods (60% of sample)
	//8c: inadequate dietary diversity (57% of sample)
	//8d: skipped meals (41% of sample)
	//8e: insufficient quantity (49%)
	//8f: ran out of food? (38%)
	//8g: were hungry but did not eat (34%)
	//8h: went without eating for the whole day (13%)
	//8i: reduced own food consumption so kids had enough to eat (28%)
	//8j: had to borrow or rely on help from a friend or relative (18%)
	//5: Did you not have enough to feed hh at some point in last 12 months? (43%)
	//I omit 8a ("Has anyone hh worried about not having enough") in favor of concrete indicators - even so, about 70% of the sample - and this does not change much with weight - has experienced at least one of these, much higher than 'typical' hunger estimates. We can restrict to Q5 as a "narrowly construed" indicator, or we can construct a composite score and choose a cutoff. Hard to see a way to do that that isn't arbitrary, though. Cumulative frequency is essentially linear until you hit 0. (roughly 7-8% of pop in each bin)
use "${Ethiopia_ESS_W1_temp_data}/cons_agg_w1.dta", clear
drop total_cons_ann
ren household_id hhid 
egen food_cons_ann = rowtotal(food*)
keep hhid food*
ren food* fd*_ph

merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hh_adulteq.dta", nogen keep(1 3)
merge 1:1 hhid using  "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hhsize.dta", nogen keep(1 3)
drop if adulteq==.
recode  fdconstot_ph (0=.)
reshape long fdconstot_, i(hhid) j(season) string
ren fdconstot_ fdconstot
gen daily_peraeq_fdcons = fdconstot/adulteq 
gen daily_percap_fdcons = fdconstot/hh_members
save "${Ethiopia_ESS_W1_temp_data}/Ethiopia_ESS_W1_food_cons.dta", replace
keep hhid daily* season
ren daily* daily*_ 
reshape wide daily*_, i(hhid) j(season) string
drop if daily_peraeq_fdcons_ph > 7000 | daily_peraeq_fdcons_pp > 7000 //Outliers.
tempfile fdcons
save `fdcons'
	
use "${Ethiopia_ESS_W1_temp_data}/sect7_hh_w1.dta", clear
//drop s9q8a
recode s9q8* s9q5 (.=0) (2=0) 
egen dep_food = rowmax(s9q8* s9q5) 
egen total_dep_food = rowtotal(s9q8* s9q5)
gen calor_insuf = s9q8d==1 | s9q8e == 1 | s9q8f == 1 | s9q8g == 1 | s9q8h == 1 | s9q8i == 1 | s9q5==1
gen nutr_insuf = calor_insuf==0 & (s9q8b==1 | s9q8c==1)
gen precarious = nutr_insuf == 0 & calor_insuf==0 & (s9q8a==1 | s9q8j==1)
gen secure=precarious==0 & calor_insuf==0 & nutr_insuf==0
/*Cumulative percentages:
10 - 5.8
9 -  13.0
8 -  21.4
7 -  29.5
6 -  36.0
5 -  42.3
4 -  47.7
3 -  54.3
2 -  62.2
1 -  70.2
*/	
keep hhid dep_food total_dep_food calor_insuf nutr_insuf precarious secure
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_food_insecurity.dta", nogen
merge 1:1 hhid using `fdcons', nogen
drop if daily_peraeq_fdcons_pp==. //Not sure what the missing values here signify.
egen min_fdcons = rowmin(daily_peraeq_fdcons_*) //Get lowest
egen max_fdcons = rowmax(daily_peraeq_fdcons_*) 
gen avg_fdcons = (daily_peraeq_fdcons_ph + daily_peraeq_fdcons_pp)/2
gen blw_coca_min = min_fdcons < $Nigeria_GHS_W4_CoCA_diet
gen blw_coca_max = max_fdcons < $Nigeria_GHS_W4_CoCA_diet
gen blw_cona_min = min_fdcons < $Nigeria_GHS_W4_CoNA_diet
gen blw_cona_max = max_fdcons < $Nigeria_GHS_W4_CoNA_diet
gen blw_coca_avg = avg_fdcons < $Nigeria_GHS_W4_CoCA_diet
gen blw_cona_avg = avg_fdcons < $Nigeria_GHS_W4_CoNA_diet

gen blw_cona_pp = daily_peraeq_fdcons_pp < $Nigeria_GHS_W4_CoNA_diet
gen blw_coca_pp = daily_peraeq_fdcons_pp < $Nigeria_GHS_W4_CoCA_diet
gen blw_cona_ph = daily_peraeq_fdcons_ph < $Nigeria_GHS_W4_CoNA_diet
gen blw_coca_ph = daily_peraeq_fdcons_ph < $Nigeria_GHS_W4_CoCA_diet
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_food_dep.dta", replace

***rCSI
*Alternative food consumption measure using the reduced coping strategies index. Weights are from the WFP guidance document Kenya Pilot Study (see https://documents.wfp.org/stellent/groups/public/documents/manual_guide_proced/wfp211058.pdf)
	//Question																	Severity Score
	//8b: about healthy and nutritious/preferred foods 							1	
	//8c: inadequate dietary diversity 											1
	//8d: skipped meals															1
	//8e: insufficient quantity 												1
	//8f: ran out of food? 														3
	//8g: were hungry but did not eat 											4
	//8h: went without eating for the whole day									4
	//8i: reduced own food consumption so kids had enough to eat 				3
	//8j: had to borrow or rely on help from a friend or relative				2

use "${Nigeria_GHS_W4_raw_data}/sect9_plantingw4.dta", clear
recode s9q8* (2=0)
gen rCSI = s9q8b + s9q8c + s9q8d + s9q8e + s9q8f*3 + s9q8g * 4 + s9q8h*4 + s9q8i * 3 + s9q8j*2	
//Max score is 20, 50th percentile among scores > 0 is 9
gen nofoodinsec = rCSI <= 3
gen highfoodinsec = rCSI >= 12
keep state hhid rCSI nofoodinsec highfoodinsec
tempfile rCSI
save `rCSI'
use "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_food_dep.dta", clear
merge 1:1 hhid using `rCSI', nogen
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hhsize.dta", nogen keepusing(hh_members weight_pop_rururb)
//collapse (mean) dep_food total_dep_food calor_insuf nutr_insuf precarious secure months* min_fdcons max_fdcons avg_fdcons rCSI nofoodinsec highfoodinsec hh_members [aw=weight_pop_rururb], by(state)
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_food_dep_ext.dta", replace

	*********************************
	*	WHO CHILD MALNUTRITION		*
	*********************************
/* This section uses a stata module developed by the WHO to compare child anthropometry to a reference population to determine stunting/malnourishment. The module must be downloaded from https://www.who.int/toolkits/child-growth-standards/software
for this section to run. Be sure to update the paths to the ado and data files. The code automatically checks to see if there's a file at the specified location before continuing and will not construct the final poverty index if the data are not present; you can still refer to the final output file for the other subscores. */

capture confirm file "${dofilefold}/igrowup_restricted.ado"
if !_rc {
	adopath + "$dofilefold"
	//Need to add file references, then we're good to go.
	use "${Nigeria_GHS_W4_raw_data}/sect1_harvestw4.dta", clear
	merge 1:1 hhid indiv using "${Nigeria_GHS_W4_raw_data}/sect4a_harvestw4.dta", nogen keep(3)
	merge 1:1 hhid indiv using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_person_ids.dta", nogen keep(3)
	merge m:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hhsize.dta", nogen keep(1 3) keepusing(weight_pop_rururb)
	ren weight sw
	gen sex =female + 1 //1 for males and 2 for females
	egen weight = rowtotal(s4aq52_1 s4aq52_2 s4aq52_3)
	replace weight=weight/3 if s4aq52_3 != . & s4aq52_3 != 0
	replace weight=weight/2 if s4aq52_3 == . | s4aq52_3 ==0
	recode weight (.=0)
	drop if weight==0
	merge m:1 hhid using "${Nigeria_GHS_W4_raw_data}/secta_harvestw4.dta", nogen keep(3)
	gen int_date = dofc(InterviewStart)
	recode s1q6_day (99=1) //assuming day is 1 if day is unknown
	tostring s1q6_day, gen(birth_day)
	replace birth_day = "0" + birth_day if s1q6_day < 10
	tostring s1q6_month, gen(birth_month)
	replace birth_month = "0" + birth_month if s1q6_month < 10
	tostring s1q6_year, gen(birth_year)
	gen birthday = date(birth_day+birth_month+birth_year, "DMY")
	gen agedays = int_date - birthday
	gen str6 ageunit="days"
	gen measure = "l" if s4aq53b==2
	replace measure = "h" if s4aq53b==1
	egen lenhei = rowtotal(s4aq53_1 s4aq53_2 s4aq53_3)
	replace lenhei = lenhei / 3 if s4aq53_3 != . & s4aq53_3!=0
	replace lenhei = lenhei / 2 if s4aq53_3 ==. | s4aq53_3==0
	
	gen str1 oedema="n"
	save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_anthro.dta", replace
	gen reflib = "$dofilefold"
	gen datalib = "$Nigeria_GHS_W4_created_data"
	gen str30 datalab = "Nigeria_GHS_W4_anthro"
	igrowup_restricted reflib datalib datalab sex agedays ageunit weight lenhei measure oedema sw
	use "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_anthro_z_rc.dta", clear //Update to corect file name
	replace _zwei = . if _fwei==1
	gen low_weight = _zwei < -2 & _zwei!=.
	merge 1:1 hhid indiv using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_person_ids.dta", nogen
	gen under_5 = age <5
	collapse (max) low_weight under_5 (min) age, by(hhid)
	recode low_weight (.=2) //HH does not have any eligible members
	merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hhsize.dta", nogen
	//merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_food_dep.dta", nogen
	la var under_5 "1 = household is eligible for anthropometry measurements"
	gen dep_nutr = low_weight == 1
	save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_mpi_nutr.dta", replace
}

use "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hhsize.dta", clear
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_food_dep.dta", nogen keep(3)

merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_mpi_edu.dta", nogen keep(3)
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_mpi_assets.dta", nogen keep(3)
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_mpi_housing.dta", nogen keep(3)
capture confirm file  "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_mpi_nutr.dta"
if !_rc {
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_mpi_nutr.dta", nogen keep(3)
} 
else {
	gen dep_nutr=0
	gen low_weight=0
}
gen popweight = hh_members*weight_pop_rururb
gen mpi_tot = (1/6)*(dep_nutr + dep_edyr + dep_att) + (1/18) * (dep_fuel + dep_sanit + dep_water + dep_elec + dep_housing + dep_asset)
gen mpi_coca = (1/6)*(blw_coca_min + dep_edyr + dep_att) + (1/18) * (dep_fuel + dep_sanit + dep_water + dep_elec + dep_housing + dep_asset)
gen mpi_cona = (1/6)*(blw_cona_min + dep_edyr + dep_att) + (1/18) * (dep_fuel + dep_sanit + dep_water + dep_elec + dep_housing + dep_asset)

gen dep_nutr2 = (low_weight==1)/9 + 2*(calor_insuf==1)/18 + nutr_insuf/18 + 2*(blw_coca_min==1)/18 + blw_cona_min/18
gen mpi_testindic = dep_nutr2 + (1/6)*(dep_edyr + dep_att) + (1/18) * (dep_fuel + dep_sanit + dep_water + dep_elec + dep_housing + dep_asset)
gen dist_foodline = 153-min_fdcons
replace dist_foodline = 0 if dist_foodline < 0
gen mpi_base = (1/6)*(dep_edyr + dep_att) + (1/18) * (dep_fuel + dep_sanit + dep_water + dep_elec + dep_housing + dep_asset) //all non-health indicators.
gen dep_nutr3 = (low_weight==1)/9 + (1-(dist_foodline/153))/9 + 2*(calor_insuf==1)/18 + nutr_insuf/18
gen dep_nutr4 = (months_food_insec2/12)/9 + (dist_foodline/153)/9 + 2*(calor_insuf==1)/18 + nutr_insuf/18
gen mpi_test4 = mpi_base + dep_nutr4
gen mpi_poor4 = mpi_test4 > 0.33
//Because child mortality is missing, we adjust the total mpi score lower to ~0.84. One third of this is 0.275
gen mpi_poor = mpi_tot <= 0.275
gen coca_poor = mpi_coca <= 0.275
gen cona_poor = mpi_coca <= 0.275
save "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_mpi_indicators.dta", replace
*/
********************************************************************************
*FISH INCOME*
********************************************************************************
*Cannot create in this instrument

********************************************************************************
*HOUSEHOLD VARIABLES
********************************************************************************
global empty_vars ""
use "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_weights.dta", clear	
//drop pw_W5	
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hhids.dta", nogen // all matched
//merge 1:1 hhid using "${Ethiopia_ESS_W5_created_data}/Ethiopia_ESS_hh_adulteq.dta", nogen keep(1 3)

*Gross crop income (NGA)
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hh_crop_production.dta", nogen keep(1 3)
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_crop_losses.dta", nogen keep(1 3)
recode value_crop_production crop_value_lost (.=0)

* Production by group and type of crops (NGA)
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hh_crop_values_production_grouped.dta", nogen
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hh_crop_values_production_type_crop.dta", nogen
recode value_pro* value_sal* (.=0)
*End DYA 9.13.2020 
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hh_cost_inputs.dta", nogen

*Crop costs (NGA)
//Merge in summarized crop costs:
gen crop_production_expenses = cost_expli_hh
gen crop_income = value_crop_production - crop_production_expenses - crop_value_lost
lab var crop_production_expenses "Crop production expenditures (explicit)"
lab var crop_income "Net crop revenue (value of production minus crop expenses)"

*top crop costs by area planted (NGA)
foreach c in $topcropname_area {
	merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_inputs_`c'.dta", nogen
	merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_`c'_monocrop_hh_area.dta",nogen
}

foreach c in $topcropname_area {
	recode `c'_monocrop (.=0) 
	//egen `c'_exp = rowtotal(val_anml_`c' val_mech_`c' val_labor_`c' val_herb_`c' val_inorg_`c' val_orgfert_`c' val_plotrent_`c' val_seeds_`c' val_transfert_`c' val_seedtrans_`c') //Need to be careful to avoid including val_harv
	//lab var `c'_exp "Crop production expenditures (explicit) - Monocropped `c' plots only"
	//la var `c'_monocrop_ha "Total `c' monocrop hectares planted - Household" 

*disaggregate by gender of plot manager (NGA)
foreach i in male female mixed hh {
	egen `c'_exp_`i' = rowtotal(/*val_anml_`c'_`i' val_mech_`c'_`i'*/ val_labor_`c'_`i' /*val_herb_`c'_`i'*/ val_inorg_`c'_`i' /*val_orgfert_`c'_`i'*/ val_plotrent_`c'_`i' val_seeds_`c'_`i' /*val_transfert_`c'_`i' val_seedtrans_`c'_`i'*/) //These are already narrowed to explicit costs
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
// drop /*val_anml* val_mech*/ val_labor* /*val_herb*/ val_inorg* /*val_orgfert*/ val_plotrent* val_seeds* /*val_transfert* val_seedtrans*/ //

*Land rights (NGA)
//merge 1:1 hhid using  "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_land_rights_hh.dta", nogen keep(1 3) //ALT 03.07.24: Module missing, for follow up
//la var formal_land_rights_hh "Household has documentation of land rights (at least one plot)

* Fish income (ETH)
gen fishing_income = . 
gen w_share_fishing = .
global empty_vars $empty_vars *fishing_income* w_share_fishing fishing_hh

*Livestock income (ETH)
**# Bookmark #1 -- check these sections out - this seems like a lot that is missing
gen value_livestock_purchases = .
gen earnings_milk_products = .
gen cost_breeding_livestock = .
gen cost_fodder_livestock = .
gen cost_vaccines_livestock = .
gen cost_treatment_livestock = .
gen cost_water_livestock = .

global empty_vars $empty_vars value_livestock_purchases earnings_milk_products cost_breeding_livestock cost_fodder_livestock cost_vaccines_livestock cost_treatment_livestock cost_water_livestock
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_livestock_sales.dta", nogen keep(1 3)
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_livestock_expenses.dta", nogen keep(1 3)
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_livestock_products.dta", nogen keep(1 3)
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_TLU.dta", nogen keep(1 3)
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_herd_characteristics.dta", nogen keep(1 3)
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_TLU_Coefficients.dta", nogen keep(1 3)
lab var sales_livestock_products "Value of sales of livestock products"
lab var value_livestock_products "Value of livestock products"
recode value_livestock_sales value_livestock_purchases value_milk_produced value_eggs_produced earnings_milk_products /*
*/ cost_breeding_livestock cost_fodder_livestock cost_vaccines_livestock cost_treatment_livestock cost_water_livestock tlu_today (.=0)
gen livestock_income = value_slaughtered + value_lvstck_sold - value_livestock_purchases /*
*/ + (value_milk_produced + value_eggs_produced + earnings_milk_products) /*
*/ - (cost_breeding_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_treatment_livestock + cost_water_livestock)
recode value_milk_produced value_eggs_produced (0=.)
lab var livestock_income "Net livestock income (value of production and consumption minus expenditures)"
gen livestock_expenses = cost_breeding_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_treatment_livestock + cost_water_livestock
gen ls_exp_vac = cost_vaccines_livestock + cost_treatment_livestock
lab var sales_livestock_products "Value of sales of livestock products"
lab var value_livestock_products "Value of livestock products"
lab var livestock_expenses "Total livestock expenses"
drop value_livestock_purchases earnings_milk_products cost_breeding_livestock cost_fodder_livestock cost_vaccines_livestock cost_treatment_livestock cost_water_livestock
//gen animals_lost12months =0 
gen mean_12months=0
la var animals_lost12months "Total number of livestock  lost to disease"
la var mean_12months "Average number of livestock  today and 1  year ago"
//gen any_imp_herd_all = . 
foreach v in ls_exp_vac /*any_imp_herd*/ {
foreach i in lrum srum poultry {
	gen `v'_`i' = .
	}
}

//adding - starting list of missing variables - recode all of these to missing at end of HH level file
global empty_vars $empty_vars animals_lost12months mean_12months *ls_exp_vac_lrum* *ls_exp_vac_srum* *ls_exp_vac_poultry* /*any_imp_herd_*/

* Self employment income (NGA)
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_self_employment_income.dta", nogen keep(1 3)
egen self_employment_income = rowtotal(/*profit_processed_crop_sold*/ annual_selfemp_profit)
recode self_employment_income (.=0)
lab var self_employment_income "Income from self-employment (business)"

* Wage income (NGA)
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_wage_income.dta", nogen keep(1 3)
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_agwage_income.dta", nogen keep(1 3)
recode annual_salary annual_salary_agwage (.=0)
ren annual_salary nonagwage_income
ren annual_salary_agwage agwage_income

*Off-farm hours (ETH)
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_off_farm_hours.dta", nogen keep(1 3)

*Other income (ETH)
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_other_income.dta", nogen keep(1 3)
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_assistance_income.dta", nogen keep(1 3)
// JM 10.30.23: Add remmittances income 
egen transfers_income = rowtotal (/*remittance_income*/ assistance_income) // JM 10.30.23: Do we need to create remmittance_income? 
lab var transfers_income "Income from transfers including pension, remittances, and assisances)"
egen all_other_income = rowtotal (investment_income /*rental_income_buildings*/ /*other_income*/  /*rental_income_assets*/) // JM 10.30.23: Do we need to create the commented-out variables? 
lab var all_other_income "Income from other revenue streams not captured elsewhere"

* Farm size (NGA)
merge 1:1 hhid using  "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_land_size.dta", nogen keep(1 3)
//merge 1:1 hhid using  "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_land_size_all.dta", nogen keep(1 3)
//merge 1:1 hhid using  "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_farmsize_all_agland.dta", nogen keep(1 3)
//merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_land_size_total.dta", nogen
//ren area_meas_hectares land_size
recode farm_area (.=0) /* If no farm, then no farm area */
recode farm_area (.=0)
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

*Labor (NGA)
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_family_hired_labor.dta", nogen keep(1 3)
recode labor_hired labor_family (.=0) 

* Household size (NGA)
merge 1:1 hhid using  "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hhsize.dta", nogen keep(1 3)

*Rates of vaccine usage, improved seeds, etc. (NGA)
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_vaccine.dta", nogen keep(1 3)
//merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_fert_use.dta", nogen keep(1 3)
//merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_improvedseed_use.dta", nogen keep(1 3)
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_input_use.dta", nogen keep(1 3)
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_imprvseed_crop.dta", nogen keep(1 3)
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_any_ext.dta", nogen keep(1 3)
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_household_crop_rotation.dta", nogen keep(1 3) // MGM 8.2.2024: added for ATA indicators
// merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_irrigation.dta", nogen keep(1 3) keepusing(*irr*) // MGM 9.18.2024: added for ATA indicators //ALT: moved to input use
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_fin_serv.dta", nogen keep(1 3)
ren use_imprv_seed imprv_seed_use //ALT 02.03.22: Should probably fix code to align this with other inputs.
ren use_hybrid_seed hybrid_seed_use
recode use_fin_serv* ext_reach* use_* imprv_seed_use vac_animal (.=0) // ALT: use_inorg_fert -> use*
replace vac_animal=. if tlu_today==0 
foreach var in use_inorg_fert use_org_fert use_pest use_herb use_fung use_irr {	
	replace `var' =. if farm_area==0 | farm_area==. // Area cultivated this year
}
recode ext_reach* (0 1=.) if (value_crop_production==0 & livestock_income==0 & farm_area==0 & farm_area==. &  tlu_today==0)
replace imprv_seed_use=. if farm_area==.  
global empty_vars $empty_vars hybrid_seed*

* Milk productivity (ETH)
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_milk_animals.dta", nogen keep(1 3) 
gen liters_milk_produced= liters_per_cow*milk_animals
lab var liters_milk_produced "Total quantity (liters) of milk per year" 
drop liters_per_cow
gen liters_per_largeruminant = .
gen liters_per_buffalo = .
global empty_vars $empty_vars *liters_per_largeruminant *liters_per_buffalo

* Dairy costs (ETH)
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_lrum_expenses", nogen keep (1 3)
gen avg_cost_lrum = cost_lrum/mean_12months_lrum 
*gen costs_dairy = avg_cost_lrum*milk_animals 
lab var avg_cost_lrum "Average cost per large ruminant"
lab var milk_animals "Number of large ruminants that were milked (household)"
lab var costs_dairy "Dairy production cost (explicit)"
gen costs_dairy_percow = .
lab var costs_dairy_percow "Dairy production cost (explicit) per cow"
drop avg_cost_lrum cost_lrum
gen share_imp_dairy = . 
global empty_vars $empty_vars share_imp_dairy *costs_dairy_percow*

* Egg productivity (NGA)
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_eggs_animals.dta", nogen keep(1 3)
*gen egg_poultry_year = eggs_total_year/hen_total
ren laying_hens poultry_owned
lab var egg_poultry_year "average number of eggs per year per hen"

*Costs of crop production per hectare (new)
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_cropcosts.dta", nogen keep(1 3)
 
*Rate of fertilizer application (new)
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_fertilizer_application.dta", nogen keep(1 3)

*Agricultural wage rate (new)
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_ag_wage.dta", nogen keep(1 3)

*Crop yields 
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_yield_hh_crop_level.dta", nogen keep(1 3)

*Total area planted and harvested accross all crops, plots, and seasons (new)
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hh_area_planted_harvested_allcrops.dta", nogen keep(1 3)

*Household diet (ETH)
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_household_diet.dta", nogen keep(1 3)
 
* Consumption (NGA)
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_consumption.dta", nogen keep(1 3)

*Household assets (Title from NGA, content from ETH)
gen value_assets = .
global empty_vars $empty_vars *value_assets*

* Food insecurity (NGA)
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_food_insecurity.dta", nogen keep(1 3)
gen hhs_little = . 
gen hhs_moderate = . 
gen hhs_severe = . 
gen hhs_total = . 
global empty_vars $empty_vars hhs_* 

*Distance to agrodealer // cannot construct (NGA)
gen dist_agrodealer = . 
global empty_vars $empty_vars *dist_agrodealer

*Livestock health (Title from NGA, content from ETH)
gen disease_animal = . // JM 11.1.23: Added this line for *correct subpopulations*
*gen lost_disease = . 
foreach i in lrum srum poultry{
	gen disease_animal_`i' = . // JM 11.1.23: Added this line for *correct subpopulations* 
	/*gen lost_disease_`i' = .*/
}
global empty_vars $empty_vars lost_disease*

* ETH W1 doesn't have this file.
*livestock feeding, water, and housing (Title from NGA)
*merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_livestock_feed_water_house.dta", nogen keep(1 3) 

*Shannon Diversity index (NGA)
merge 1:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_shannon_diversity_index.dta", nogen keep(1 3)

*Farm Production (NGA)
recode value_crop_production  value_livestock_products value_slaughtered  value_lvstck_sold (.=0)
gen value_farm_production = value_crop_production + value_livestock_products + value_slaughtered + value_lvstck_sold
lab var value_farm_production "Total value of farm production (crops + livestock products)"
gen value_farm_prod_sold = value_crop_sales + sales_livestock_products + value_livestock_sales 
lab var value_farm_prod_sold "Total value of farm production that is sold" 
replace value_farm_prod_sold = 0 if value_farm_prod_sold==. & value_farm_production!=.

* Agricultural households (NGA)
recode value_crop_production livestock_income farm_area tlu_today (.=0)
gen ag_hh = (value_crop_production!=0 | livestock_income!=0 | farm_area!=0 | tlu_today!=0)
lab var ag_hh "1= Household has some land cultivated, some livestock, some crop income, or some livestock income"

*household with egg-producing animals (NGA)
gen egg_hh = (value_eggs_produced>0 & value_eggs_produced!=.)
lab var egg_hh "1=Household engaged in egg production"
*household engaged in dairy production (NGA)
gen dairy_hh = (value_milk_produced>0 & value_milk_produced!=.)
lab var dairy_hh "1= Household engaged in dairy production" 

*Households engaged in ag activities including working in paid ag jobs (NGA)
gen agactivities_hh =ag_hh==1 | (agwage_income!=0 & agwage_income!=.)
lab var agactivities_hh "1=Household has some land cultivated, livestock, crop income, livestock income, or ag wage income"

*Creating crop households and livestock households
gen crop_hh = (value_crop_production!=0  | farm_area!=0)
lab var crop_hh "1= Household has some land cultivated or some crop income"
gen livestock_hh = (livestock_income!=0 | tlu_today!=0)
lab  var livestock_hh "1= Household has some livestock or some livestock income"
recode fishing_income (.=0)
gen fishing_hh = (fishing_income!=0)
lab  var fishing_hh "1= Household has some fishing income"

/*
recode annual_selfemp_profit wage_income agwage_income transfer_income pension_income investment_income rental_income sales_income inheritance_income /*
*/ psnp_income assistance_income land_rental_income_upfront (.=0)
gen fish_trading_income = .
egen self_employment_income = rowtotal(annual_selfemp_profit fish_trading_income)
ren wage_income nonagwage_income
lab var self_employment_income "Income from self-employment (business)"
egen transfers_income = rowtotal (transfer_income pension_income assistance_income psnp_income) 
lab var transfers_income "Income from transfers including pension, remittances, and assisances)"
egen all_other_income = rowtotal (investment_income rental_income sales_income land_rental_income_upfront inheritance_income )
lab var all_other_income "Income from other revenue streams not captured elsewhere"
drop annual_selfemp_profit fish_trading_income transfer_income pension_income assistance_income psnp_income investment_income rental_income sales_income land_rental_income_upfront inheritance_income 
*/

****getting correct subpopulations*****  (ETH)
*Recoding missings to 0 for households growing crops
recode grew* (.=0)
*all rural households growing specific crops 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode value_harv_`cn' value_sold_`cn' kgs_harvest_`cn' total_planted_area_`cn' total_harv_area_`cn' `cn'_exp (.=0) if grew_`cn'==1
	recode value_harv_`cn' value_sold_`cn' kgs_harvest_`cn' total_planted_area_`cn' total_harv_area_`cn' `cn'_exp (nonmissing=.) if grew_`cn'==0
}

*Again, none of these in W1.
*all rural households engaged in livestock production of a given species
foreach i in lrum srum poultry {
    gen feed_grazing_`i' = . 
    gen water_source_nat_`i' = . 
    gen water_source_const_`i' = . 
    gen water_source_cover_`i' = . 
    gen lvstck_housed_`i' = .  
	}

*all rural households engaged in livestcok production of a given species
foreach i in lrum srum poultry{
	recode ls_exp_vac_`i' disease_animal_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode ls_exp_vac_`i' disease_animal_`i' (.=0) if lvstck_holding_`i'==1	
}
*households engaged in crop production
gen eggs_total_year=.
global empty_vars $empty_vars eggs_total_year
recode cost_expli* value_crop_production value_crop_sales labor_hired labor_family farm_size_agland all_area_harvested all_area_planted encs num_crops_hh multiple_crops (.=0) if crop_hh==1
recode cost_expli* value_crop_production value_crop_sales labor_hired labor_family farm_size_agland all_area_harvested all_area_planted encs num_crops_hh multiple_crops (nonmissing=.) if crop_hh==0
*all rural households engaged in livestock production 
recode animals_lost12months* mean_12months* livestock_expenses disease_animal /*feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed*/ (.=0) if livestock_hh==1
recode animals_lost12months* mean_12months* livestock_expenses disease_animal /*feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed*/ (nonmissing=.) if livestock_hh==0
*all rural households 
recode /*DYA.10.26.2020*/ hrs_ag_activ hrs_wage_off_farm hrs_wage_on_farm hrs_unpaid_off_farm hrs_domest_fire_fuel hrs_off_farm hrs_on_farm hrs_domest_all hrs_other_all hrs_self_off_farm crop_income livestock_income self_employment_income nonagwage_income agwage_income transfers_income all_other_income (.=0)
*all rural households engaged in dairy production
recode costs_dairy liters_milk_produced value_milk_produced (.=0) if dairy_hh==1 
recode costs_dairy liters_milk_produced value_milk_produced (nonmissing=.) if dairy_hh==0
*all rural households eith egg-producing animals
recode eggs_total_year value_eggs_produced (.=0) if egg_hh==1
recode eggs_total_year value_eggs_produced (nonmissing=.) if egg_hh==0
//drop value_harv*

global gender "female male mixed" // (ETH)
global wins_var_top1 /*
*/ value_crop_production value_crop_sales value_harv* value_sold* kgs_harv* /*kgs_harv_mono*/ total_planted_area* total_harv_area* /*
*/ labor_hired labor_family /* //JM 11.1.23: Removed "w_labor_other" for consistency with NGA W3
*/ animals_lost12months mean_12months lost_disease* /*			
*/ liters_milk_produced costs_dairy /*	
*/ eggs_total_year value_eggs_produced value_milk_produced /*
*/ /*DYA.10.26.2020*/ hrs_ag_activ hrs_wage_off_farm hrs_wage_on_farm hrs_unpaid_off_farm hrs_domest_fire_fuel hrs_off_farm hrs_on_farm hrs_domest_all hrs_other_all hrs_self_off_farm  crop_production_expenses value_assets cost_expli_hh /*
*/ livestock_expenses ls_exp_vac* sales_livestock_products value_livestock_products value_livestock_sales /*
*/ value_farm_production value_farm_prod_sold  value_pro* value_sal*



*** Begin addressing outliers  and estimating indicators that are ratios using winsorized values ***
global gender "female male mixed"
global wins_var_top1 /*
*/ cost_total_hh cost_expli_hh /*
*/ value_crop_production value_crop_sales value_harv* value_sold* kgs_harvest* total_planted_area* total_harv_area* /*
*/ labor_hired labor_family /*labor_other*/ /* 
*/ animals_lost12months* mean_12months* lost_disease* /*
*/ liters_milk_produced costs_dairy eggs_total_year value_eggs_produced value_milk_produced /*
*/ /*DYA.10.26.2020*/ hrs_ag_activ hrs_wage_off_farm hrs_wage_on_farm hrs_unpaid_off_farm hrs_domest_fire_fuel hrs_off_farm hrs_on_farm hrs_domest_all hrs_other_all hrs_self_off_farm  livestock_expenses ls_exp_vac* crop_production_expenses value_assets kgs_harv_mono* sales_livestock_products value_livestock_products value_livestock_sales /*
*/ value_farm_production value_farm_prod_sold value_pro* value_sal* 


gen wage_paid_aglabor_mixed=. //create this just to make the loop work and delete after (ETH)
foreach v of varlist $wins_var_top1 {
	_pctile `v' [aw=weight_pop_rururb] , p($wins_upper_thres)  
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top 1%"
}

global wins_var_top1_gender=""
foreach v in $topcropname_area {
	global wins_var_top1_gender $wins_var_top1_gender `v'_exp  
}
gen cost_total = cost_total_hh //JM 11.1.23: Added this line for consistency with NGA W3
gen cost_expli = cost_expli_hh //JM 11.1.23: Added this line for consistency with NGA W3
global wins_var_top1_gender $wins_var_top1_gender cost_total cost_expli wage_paid_aglabor inorg_fert_kg org_fert_kg n_kg p_kg k_kg urea_kg dap_kg nps_kg herb_kg pest_kg fung_kg ha_irr //winsorizing area irrigated
foreach v of varlist $wins_var_top1_gender {
	_pctile `v' [aw=weight_pop_rururb] , p($wins_upper_thres)  
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
global empty_vars $empty_vars w_lost_disease w_lost_disease_lrum w_lost_disease_srum w_lost_disease_poultry
drop *wage_paid_aglabor_mixed
*Generating labor_total as sum of winsorized labor_hired and labor_family
egen w_labor_total=rowtotal(w_labor_hired w_labor_family) //JM 11.1.23: Removed "w_labor_other" for consistency with NGA W3
local llabor_total : var lab labor_total 
lab var w_labor_total "`labor_total' - Winzorized top 1%" 

*Variables winsorized both at the top 1% and bottom 1% (ETH)
global wins_var_top1_bott1  /* 
*/ farm_area farm_size_agland all_area_harvested all_area_planted ha_planted /*
*/ crop_income livestock_income fishing_income self_employment_income nonagwage_income agwage_income transfers_income all_other_income /*
*/ total_cons percapita_cons daily_percap_cons peraeq_cons daily_peraeq_cons /* 
*/ *_monocrop_ha* dist_agrodealer

foreach v of varlist $wins_var_top1_bott1 {
	_pctile `v' [aw=weight_pop_rururb] , p($wins_lower_thres $wins_upper_thres)  
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

*area_harv and area_plan are also winsorized both at the top 1% and bottom 1% because we need to analyze at the crop level (ETH)
global allyield male female mixed inter inter_male inter_female inter_mixed pure pure_male pure_female pure_mixed
global wins_var_top1_bott1_2 area_harv  area_plan harvest 	
foreach v of global wins_var_top1_bott1_2 {
	foreach c of global topcropname_area {
		_pctile `v'_`c'  [aw=weight_pop_rururb] , p($wins_lower_thres $wins_upper_thres) 
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
*generate yield and weights for yields using winsorized values (ETH)
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
	foreach g of global allyield  {
		gen yield_hv_`g'_`c'=w_harvest_`g'_`c'/w_area_harv_`g'_`c'
		lab var  yield_hv_`g'_`c'  "Yield by area harvested of `c' -  (kgs/ha) (`g')" 
		gen ar_h_wgt_`g'_`c' =  weight*w_area_harv_`g'_`c'
		lab var ar_h_wgt_`g'_`c' "Harvested area-adjusted weight for `c' (`g')"
	}
}

*generate inorg_fert_rate, costs_total_ha, and costs_expli_ha using winsorized values
//gen inorg_fert_rate=w_fert_inorg_kg/w_ha_planted
foreach v in inorg_fert org_fert n p k herb pest fung urea nps dap {
	gen `v'_rate=w_`v'_kg/w_ha_planted
	foreach g of global gender {
		gen `v'_rate_`g'=w_`v'_kg_`g'/ w_ha_planted_`g'
					
}
}

gen cost_total_ha=w_cost_total/w_ha_planted  // JM 11.1.23: Changed cost_total to cost_total_hh
gen cost_expli_ha=w_cost_expli/w_ha_planted				
gen cost_explicit_hh_ha=w_cost_expli_hh/w_ha_planted
gen irr_rate = w_ha_irr / w_ha_planted
foreach g of global gender {
	//gen inorg_fert_rate_`g'=w_ionrg_fert_kg_`g'/ w_ha_planted_`g'
	gen cost_total_ha_`g'=w_cost_total_`g'/ w_ha_planted_`g' 
	gen cost_expli_ha_`g'=w_cost_expli_`g'/ w_ha_planted_`g'
	gen irr_rate_`g' = ha_irr_`g' / ha_planted_`g'
}
//ALT: need to update documentation to note that this is winsorized.

lab var inorg_fert_rate "Rate of fertilizer application (kgs/ha) (household)"
lab var org_fert_rate "Rate of organic fertilizer application (kgs/ha) (household)"
lab var n_rate "Rate of nitrogen application (kgs/ha) (household)"
lab var k_rate "Rate of postassium application (kgs/ha) (household)"
lab var p_rate "Rate of phosphorus appliction (kgs/ha) (household)"
lab var pest_rate "Rate of pesticide application (kgs/ha) (household)"
lab var herb_rate "Rate of herbicide application (kgs/ha) (household)"
lab var urea_rate "Rate of urea application (kgs/ha) (household)"
lab var nps_rate "Rate of NPS fertilizer application (kgs/ha) (household)" 
lab var dap_rate "Rate of DAP fertilizer application (kgs/ha) (household)"
la var irr_rate "Proportion of planted area irrigated (household)"

lab var cost_total_ha "Explicit + implicit costs (per ha) of crop production (household level)"		
lab var cost_total_ha_male "Explicit + implicit costs (per ha) of crop production (male-managed plots)"
lab var cost_total_ha_female "Explicit + implicit costs (per ha) of crop production (female-managed plots)"
lab var cost_total_ha_mixed "Explicit + implicit costs (per ha) of crop production (mixed-managed plots)"
lab var cost_expli_ha "Explicit costs (per ha) of crop production (household level)"
lab var cost_expli_ha_male "Explicit costs (per ha) of crop production (male-managed plots)"
lab var cost_expli_ha_female "Explicit costs (per ha) of crop production (female-managed plots)"
lab var cost_expli_ha_mixed "Explicit costs (per ha) of crop production (mixed-managed plots)"
lab var cost_explicit_hh_ha "Explicit costs (per ha) of crop production (household level)"

*mortality rate (ETH)
global animal_species lrum srum camel equine  poultry 
foreach s of global animal_species {
	gen mortality_rate_`s' = animals_lost12months_`s'/mean_12months_`s'
	lab var mortality_rate_`s' "Mortality rate - `s'"
}

*Generating crop expenses by hectare for top crops (ETH)
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

*Hours per capita using winsorized version off_farm_hours (ETH)
foreach x in ag_activ wage_off_farm wage_on_farm unpaid_off_farm domest_fire_fuel off_farm on_farm domest_all other_all {
	local l`v':var label hrs_`x'
	gen hrs_`x'_pc_all = hrs_`x'/member_count
	lab var hrs_`x'_pc_all "Per capital (all) `l`v''"
	gen hrs_`x'_pc_any = hrs_`x'/nworker_`x'
    lab var hrs_`x'_pc_any "Per capital (only worker) `l`v''"
}

*generating total crop production costs per hectare (ETH)
gen cost_expli_hh_ha = w_cost_expli_hh/w_ha_planted		
lab var cost_expli_hh_ha "Explicit costs (per ha) of crop production (household level)"

*land and labor productivity (ETH)
gen land_productivity = w_value_crop_production/w_farm_area
gen labor_productivity = w_value_crop_production/w_labor_total 
lab var land_productivity "Land productivity (value production per ha cultivated)"
lab var labor_productivity "Labor productivity (value production per labor-day)"   

*Milk productivity (ETH)
gen liters_per_cow = w_liters_milk_produced/milk_animals		
lab var liters_per_cow "average quantity (liters) per day (household) - cow"
la var liters_per_largeruminant "Average quantity (liters) per year (household)" // JM 11.1.23: Added for consistency with NGA W3 code. 
global empty_vars $empty_vars liters_per_largeruminant	 // JM 11.1.23: Added for consistency with NGA W3 code. 

*Calculate proportion of crop value sold using winsorized values of value_crop_sales and value_crop_production (ETH)
gen w_proportion_cropvalue_sold = w_value_crop_sales /  w_value_crop_production
replace w_proportion_cropvalue_sold = 1 if w_proportion_cropvalue_sold>1 & w_proportion_cropvalue_sold!=.
lab var w_proportion_cropvalue_sold "Proportion of crop value produced (winsorized) that has been sold"

*livestock value sold  (ETH)
gen w_share_livestock_prod_sold = w_sales_livestock_products / w_value_livestock_products
replace w_share_livestock_prod_sold = 1 if w_share_livestock_prod_sold>1 & w_share_livestock_prod_sold!=.
lab var w_share_livestock_prod_sold "Percent of production of livestock products (winsorized) that is sold"

*Propotion of farm production sold (ETH)
gen w_prop_farm_prod_sold = w_value_farm_prod_sold / w_value_farm_production
replace w_prop_farm_prod_sold = 1 if w_prop_farm_prod_sold>1 & w_prop_farm_prod_sold!=.
lab var w_prop_farm_prod_sold "Proportion of farm production (winsorized) that has been sold"

*Unit cost of production (ETH)
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

*dairy (NGA)
gen cost_per_lit_milk = w_costs_dairy/w_liters_milk_produced  
lab var cost_per_lit_milk "dairy production cost per liter"
global empty_vars $empty_vars cost_per_lit_milk

*****getting correct subpopulations*** (ETH)
*all rural housseholds engaged in crop production (ETH)
recode *inorg_fert_rate* *irr_rate* *n_rate* *p_rate* *k_rate* *urea_rate* *dap_rate* *nps_rate* /*org_fert_rate not calculable for W5*/ *pest_rate* *herb_rate* *fung_rate* cost_total_ha* cost_expli_ha* cost_expli_hh_ha land_productivity labor_productivity /*
*/ encs* num_crops* multiple_crops (.=0) if crop_hh==1
recode *inorg_fert_rate* *irr_rate* *n_rate* *p_rate* *k_rate* *urea_rate* *dap_rate* *nps_rate*  /*org_fert_rate not calculable for W5*/ *pest_rate* *herb_rate* *fung_rate* cost_total_ha* cost_expli_ha* cost_expli_hh_ha land_productivity labor_productivity /*
*/ encs* num_crops* multiple_crops (nonmissing=.) if crop_hh==0

*all rural households engaged in livestcok production of a given species (ETH)
foreach i in lrum srum poultry{
	recode mortality_rate_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode mortality_rate_`i' (.=0) if lvstck_holding_`i'==1	
}
*all rural households (ETH)
recode /*DYA.10.26.2020*/ hrs_*_pc_all (.=0)  
*households engaged in monocropped production of specific crops
forvalues k=1/$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode `cn'_exp `cn'_exp_ha `cn'_exp_kg (.=0) if `cn'_monocrop==1
	recode `cn'_exp `cn'_exp_ha `cn'_exp_kg (nonmissing=.) if `cn'_monocrop==0
}
*all rural households growing specific crops (ETH)
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_pl_`cn' (.=0) if grew_`cn'==1 
	recode yield_pl_`cn' (nonmissing=.) if grew_`cn'==0 
}
*all rural households harvesting specific crops (ETH)
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_hv_`cn' (.=0) if harvested_`cn'==1 
	recode yield_hv_`cn' (nonmissing=.) if harvested_`cn'==0 
}

*households growing specific crops that have also purestand plots of that crop (ETH)
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_pl_pure_`cn' (.=0) if grew_`cn'==1 & w_area_plan_pure_`cn'!=. 
	recode yield_pl_pure_`cn' (nonmissing=.) if grew_`cn'==0 | w_area_plan_pure_`cn'==.  
}
*all rural households harvesting specific crops (in the long rainy season) that also have purestand plots (ETH)
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_hv_pure_`cn' (.=0) if harvested_`cn'==1 & w_area_plan_pure_`cn'!=. 
	recode yield_hv_pure_`cn' (nonmissing=.) if harvested_`cn'==0 | w_area_plan_pure_`cn'==.  
}

*households engaged in dairy production (ETH)
recode cost_per_lit_milk liters_per_cow (.=0) if dairy_hh==1
recode cost_per_lit_milk liters_per_cow (nonmissing=.) if dairy_hh==0
*households with egg-producing animals (ETH)
recode egg_poultry_year (.=0) if egg_hh==1 
recode egg_poultry_year (nonmissing=.) if egg_hh==0

*now winsorize ratios only at top 1% (ETH)
global wins_var_ratios_top1 cost_total_ha cost_expli_ha cost_expli_hh_ha /*		
*/ land_productivity labor_productivity /*
*/ inorg_fert_rate n_rate p_rate k_rate urea_rate dap_rate nps_rate irr_rate fung_rate pest_rate herb_rate /*
*/ mortality_rate* liters_per_largeruminant liters_per_cow liters_per_buffalo egg_poultry_year costs_dairy_percow /*
*/ /*DYA.10.26.2020*/  hrs_*_pc_all hrs_*_pc_any cost_per_lit_milk 


foreach v of varlist $wins_var_ratios_top1 {
	_pctile `v' [aw=weight_pop_rururb] , p($wins_upper_thres)  
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

*Winsorizing top crop ratios (ETH)
foreach v of global topcropname_area {
	*first winsorizing costs per hectare
	_pctile `v'_exp_ha [aw=weight_pop_rururb] , p($wins_upper_thres)  		
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
	_pctile `v'_exp_kg [aw=weight_pop_rururb] , p($wins_upper_thres)  
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


*now winsorize ratio only at top 1% - yield (ETH)
//ALT 03.27.25: Changing to p95
foreach c of global topcropname_area {
	foreach i in yield_pl yield_hv{
		_pctile `i'_`c' [aw=weight_pop_rururb] , p(95)  
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

*Create final income variables using un_winzorized and winzorized values (ETH)
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
*all rural households (ETH not in NGA)
//note that consumption indicators are not included because there is missing consumption data and we do not consider 0 values for consumption to be valid
recode w_total_income w_percapita_income w_crop_income w_livestock_income /*w_fishing_income*/ w_nonagwage_income w_agwage_income w_self_employment_income w_transfers_income w_all_other_income /*
*/ w_share_crop w_share_livestock w_share_nonagwage w_share_agwage w_share_self_employment w_share_transfers w_share_all_other w_share_nonfarm /*
*/ use_fin_serv* use_inorg_fert imprv_seed_use /*
*/ /*formal_land_rights_hh*/  /*DYA.10.26.2020*/ *_hrs_*_pc_all  months_food_insec /*
*/ lvstck_holding_tlu lvstck_holding_all lvstck_holding_lrum lvstck_holding_srum lvstck_holding_poultry (.=0) if rural==1 

*all rural households engaged in livestock production (ETH)
recode vac_animal w_share_livestock_prod_sold livestock_expenses w_ls_exp_vac any_imp_herd_all (. = 0) if livestock_hh==1 
recode vac_animal w_share_livestock_prod_sold livestock_expenses w_ls_exp_vac any_imp_herd_all (nonmissing = .) if livestock_hh==0 

*all rural households engaged in livestcok production of a given species
foreach i in lrum srum poultry{
	recode vac_animal_`i' any_imp_herd_`i' w_ls_exp_vac_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode vac_animal_`i' any_imp_herd_`i' w_ls_exp_vac_`i' (.=0) if lvstck_holding_`i'==1	
}

*households engaged in crop production
recode *inorg_fert_rate* /*org_fert_rate *pest_rate* *herb_rate* *fung_rate*  not calculable for W1*/ w_proportion_cropvalue_sold w_farm_size_agland w_labor_family w_labor_hired /*
*/ imprv_seed_use use_inorg_fert /*w_dist_agrodealer*/ w_labor_productivity w_land_productivity /*
*/  w_cost_expli_hh w_cost_expli_hh_ha w_cost_expli_ha w_cost_total_ha /*
*/ w_value_crop_production w_value_crop_sales w_all_area_planted w_all_area_harvested (.=0) if crop_hh==1
recode *_rate* /*org_fert_rate not calculable for W1 */ w_proportion_cropvalue_sold w_farm_size_agland w_labor_family w_labor_hired /*
*/ imprv_seed_use use_inorg_fert /*w_dist_agrodealer*/ w_labor_productivity w_land_productivity /*
*/ w_inorg_fert_rate w_cost_expli_hh w_cost_expli_hh_ha w_cost_expli_ha w_cost_total_ha /*
*/ w_value_crop_production w_value_crop_sales w_all_area_planted w_all_area_harvested (nonmissing= . ) if crop_hh==0

*hh engaged in crop or livestock production (ETH)
gen ext_reach_unspecified=0 // JM 11.1.23: This is not in NGA
recode ext_reach* (.=0) if (crop_hh==1 | livestock_hh==1)
recode ext_reach* (nonmissing=.) if crop_hh==0 & livestock_hh==0
lab var ext_reach_unspecified "1 = Household reached by extensition services - unspecified sources"

*all rural households growing specific crops 
forvalues k=1(1)$nb_topcrops {
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
forvalues k=1/$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode w_`cn'_exp w_`cn'_exp_ha w_`cn'_exp_kg (.=0) if `cn'_monocrop==1
	recode w_`cn'_exp w_`cn'_exp_ha w_`cn'_exp_kg (nonmissing=.) if `cn'_monocrop==0
}

*all rural households engaged in dairy production (ETH)
recode costs_dairy liters_milk_produced w_value_milk_produced (.=0) if dairy_hh==1 
recode costs_dairy liters_milk_produced w_value_milk_produced (nonmissing=.) if dairy_hh==0
*all rural households eith egg-producing animals (ETH)
recode w_eggs_total_year w_value_eggs_produced (.=0) if egg_hh==1
recode w_eggs_total_year w_value_eggs_produced (nonmissing=.) if egg_hh==0

*Identify smallholder farmers (RULIS definition) (NGA)
global small_farmer_vars farm_area tlu_today total_income 
foreach p of global small_farmer_vars {
	gen `p'_aghh = `p' if ag_hh==1
	_pctile `p'_aghh  [aw=weight_pop_rururb] , p(40) 
	gen small_`p' = (`p' <= r(r1))
	replace small_`p' = . if ag_hh!=1
}
gen small_farm_household = (small_farm_area==1 & small_tlu_today==1 & small_total_income==1)
replace small_farm_household = . if ag_hh != 1
sum small_farm_household if ag_hh==1 
drop farm_area_aghh small_farm_area tlu_today_aghh small_tlu_today total_income_aghh small_total_income   
lab var small_farm_household "1= HH is in bottom 40th percentiles of land size, TLU, and total revenue"

*create different weights (ETH)
gen w_labor_weight=weight*w_labor_total
lab var w_labor_weight "labor-adjusted household weights"
gen w_land_weight=weight*w_farm_area
lab var w_land_weight "land-adjusted household weights"
gen w_aglabor_weight_all=w_labor_hired*weight_pop_rururb
lab var w_aglabor_weight_all "Hired labor-adjusted household weights"
gen w_aglabor_weight_female=. // cannot create in this instrument  
lab var w_aglabor_weight_female "Hired labor-adjusted household weights -female workers"
gen w_aglabor_weight_male=. // cannot create in this instrument 
lab var w_aglabor_weight_male "Hired labor-adjusted household weights -male workers"
gen weight_milk=milk_animals*weight_pop_rururb
gen weight_egg=poultry_owned*weight_pop_rururb
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
gen w_ha_planted_weight=w_ha_planted_all*weight_pop_rururb
drop w_ha_planted_all
gen individual_weight=hh_members*weight_pop_rururb
gen adulteq_weight=adulteq*weight_pop_rururb


*Rural poverty headcount ratio (ETH)
*First, we convert $1.90/day to local currency in 2011 using https://data.worldbank.org/indicator/PA.NUS.PRVT.PP?end=2011&locations=TZ&start=1990
	// 1.90 * 5.439 = 10.3341  
*NOTE: this is using the "Private Consumption, PPP" conversion factor because that's what we have been using. 
* This can be changed this to the "GDP, PPP" if we change the rest of the conversion factors.
*The global poverty line of $1.90/day is set by the World Bank
*http://www.worldbank.org/en/topic/poverty/brief/global-poverty-line-faq
*Second, we inflate the local currency to the year that this survey was carried out using the CPI inflation rate using https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2017&locations=TZ&start=2003
	// 1+(226.759 - 133.25)/ 133.25 = 1.7017561	
	// 10.3341* 1.7017561 = 17.586118 ETB
*NOTE: if the survey was carried out over multiple years we use the last year
*This is the poverty line at the local currency in the year the survey was carried out

/*
gen poverty_under_1_9 = (daily_percap_cons<17.586118)
la var poverty_under_1_9 "Household has a percapita conumption of under $1.90 in 2011 $ PPP)"
*/

*average consumption expenditure of the bottom 40% of the rural consumption expenditure distribution
*By per capita consumption (ETH)
_pctile w_daily_percap_cons [aw=individual_weight] if rural==1, p(40)
gen bottom_40_percap = 0
replace bottom_40_percap = 1 if r(r1) > w_daily_percap_cons & rural==1

*By peraeq consumption (ETH)
_pctile w_daily_peraeq_cons [aw=adulteq_weight] if rural==1, p(40)
gen bottom_40_peraeq = 0
replace bottom_40_peraeq = 1 if r(r1) > w_daily_peraeq_cons & rural==1

****Currency Conversion Factors*** (ETH)
gen ccf_loc = 1 / $Ethiopia_ESS_W1_inflation
lab var ccf_loc "currency conversion factor - 2017 $ETB"
gen ccf_usd = ccf_loc / $Ethiopia_ESS_W1_exchange_rate 
lab var ccf_usd "currency conversion factor - 2017 $USD"
gen ccf_1ppp = ccf_loc / $Ethiopia_ESS_W1_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2017 $Private Consumption PPP"
gen ccf_2ppp = ccf_loc / $Ethiopia_ESS_W1_gdp_ppp_dollar
lab var ccf_2ppp "currency conversion factor - 2017 $GDP PPP"

gen poverty_under_190 = (daily_percap_cons < $Ethiopia_ESS_W1_poverty_190)
la var poverty_under_190 "Household per-capita consumption is below $1.90 in 2011 $ PPP"
gen poverty_under_215 = daily_percap_cons < $Ethiopia_ESS_W1_poverty_215
la var poverty_under_215 "Household per-capita consumption is below $2.15 in 2017 $ PPP"
gen poverty_under_npl = daily_percap_cons < $Ethiopia_ESS_W1_poverty_npl

*Cleaning up output to get below 5,000 variables
*dropping unnecessary variables and recoding to missing any variables that cannot be created in this instrument
drop *_inter_* harvest_* w_harvest_*

*Removing intermediate variables to get below 5,000 vars (ETH)
keep hhid fhh clusterid strataid *weight* *wgt* region zone woreda town subcity kebele ea /*household*/ rural farm_size* *total_income* /*
*/ *percapita_income* *percapita_cons* *daily_percap_cons* *peraeq_cons* *daily_peraeq_cons* /*
*/ *income* *share* *proportion_cropvalue_sold *farm_size_agland hh_members adulteq *labor_family *labor_hired use_inorg_fert vac_* /*
*/ feed* water* lvstck_housed* ext_* use_fin_* lvstck_holding* *mortality_rate* *lost_disease* disease* any_imp* /*formal_land_rights_hh ALT:MISSING*/ /*
*/ *livestock_expenses* *ls_exp_vac* *prop_farm_prod_sold /*DYA.10.26.2020*/ *hrs_*   months_food_insec *value_assets* hhs_* *dist_agrodealer /*
*/ encs* num_crops_* multiple_crops* imprv_seed_* hybrid_seed_* *labor_total *farm_area *labor_productivity* *land_productivity* /*
*/ *wage_paid_aglabor* *labor_hired ar_h_wgt_* *yield_hv_* ar_pl_wgt_* *yield_pl_* *liters_per_* milk_animals poultry_owned *costs_dairy* *cost_per_lit* /*
*/ *egg_poultry_year* *ha_planted* *cost_expli_hh* *cost_expli_ha* *monocrop_ha* *kgs_harv_mono* *cost_total_ha* /*
*/ *_exp* poverty* *value_crop_production* *value_harv* *value_crop_sales* *value_sold* *kgs_harvest* *total_planted_area* *total_harv_area* /*
*/ *all_area_* grew_* agactivities_hh ag_hh crop_hh livestock_hh fishing_hh *_milk_produced* *eggs_total_year *value_eggs_produced* /*
*/ *value_livestock_products* *value_livestock_sales* *total_cons* nb_cattle_today nb_largerum_today nb_poultry_today bottom_40_percap bottom_40_peraeq /*
*/ ccf_loc ccf_usd ccf_1ppp ccf_2ppp *sales_livestock_products nb_cows_today lvstck_holding_srum  nb_smallrum_today nb_chickens_today  *value_pro* *value_sal* /*
*/ /*DYA 10.6.2020*/ *value_livestock_sales*  *w_value_farm_production* *value_slaughtered* *value_lvstck_sold* *value_crop_sales* *sales_livestock_products* *value_livestock_sales* animals_lost12months /*MGM 8.29.2024: adding in additional indicators for ATA estimates*/ hh_work_age hh_women hh_adult_women tlu_today use_* crop_rotation *rate* *ha_* fcs* rcsi* 

gen ssp = (farm_size_agland <= 2 & farm_size_agland != 0) & (nb_cows_today <= 10 & nb_smallrum_today <= 10 & nb_chickens_today <= 50) // This line is for HH vars only; rest for all three
ren weight weight_sample
ren weight_pop_rururb weight
la var weight_sample "Original survey weight"
la var weight "Weight adjusted to match rural/urban populations"

/*
foreach v of varlist $empty_vars { 
	replace `v' = .
}
*/

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
// gen hhid = hhid 
gen hhid_panel = hhid
lab var hhid_panel "Panel HH identifier" 
gen geography = "Ethiopia"
gen survey = "LSMS-ISA" 
gen year = "2010-11" 
gen instrument = 21
//Only runs if label isn't already defined.
capture label define instrument 11 "Tanzania NPS Wave 1" 12 "Tanzania NPS Wave 2" 13 "Tanzania NPS Wave 3" 14 "Tanzania NPS Wave 4" 15 "Tanzania NPS SDD" 16 "Tanzania NPS W5" /*
	*/ 21 "Ethiopia ESS Wave 1" 22 "Ethiopia ESS Wave 2" 23 "Ethiopia ESS Wave 3" 24 "Ethiopia ESS Wave 4" 25 "Ethiopia ESS Wave 5" /*
	*/ 31 "Nigeria GHS Wave 1" 32 "Nigeria GHS Wave 2" 33 "Nigeria GHS Wave 3" 34 "Nigeria GHS Wave 4" 35 "Nigeria GHS Wave 5"/*
	*/ 41 "Malawi IHS/IHPS Wave 1" 42 "Malawi IHS/IHPS Wave 2" 43 "Malawi IHS/IHPS Wave 3" 44 "Malawi IHS/IHPS Wave 4" /*
    */ 51 "Uganda NPS Wave 1" 52 "Uganda NPS Wave 2" 53 "Uganda NPS Wave 3" 54 "Uganda NPS Wave 4" 55 "Uganda NPS Wave 5" /*W6 does not exist*/ 56 "Uganda NPS Wave 7" 57 "Uganda NPS Wave 8" /* 
*/ 61 "Burkina Faso EMC Wave 1" /* 
*/ 71 "Mali EACI Wave 1" 72 "Mali EACI Wave 2" /*
*/ 81 "Niger ECVMA Wave 1" 82 "Niger ECVMA Wave 2"
la val instrument instrument
saveold "${Ethiopia_ESS_W1_final_data}/Ethiopia_ESS_W1_household_variables.dta", replace

********************************************************************************
*INDIVIDUAL-LEVEL VARIABLES
********************************************************************************
use "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_person_ids.dta", clear
rename indiv personid
//bysort hhid personid: gen dup = cond(_N==1,0,_n)
//tab dup 
//edit if dup>=1
merge 1:1 hhid personid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_control_income.dta", nogen keep(1 3)
merge 1:1 hhid personid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_ag_decision.dta", nogen keep(1 3)
merge 1:1 hhid personid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_women_asset.dta", nogen keep(1 3)
tostring zone, replace
merge m:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hhsize.dta", nogen keep(1 3)
*renaming holder_id in farmer fert use individual_id so that we are merging across the long form of individual id not the short form personid. 
preserve 
use "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_farmer_fert_use.dta",  clear
rename holder_id individual_id
duplicates drop individual_id hhid, force
tempfile farmer_fert_use 
save `farmer_fert_use', replace 
restore 
merge 1:1 hhid individual_id using `farmer_fert_use', nogen  keep(1 3)
//merge 1:1 hhid personid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_farmer_fert_use.dta", nogen  keep(1 3)
merge 1:1 hhid personid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_farmer_improvedseed_use.dta", nogen  keep(1 3) //SRK
merge 1:1 hhid personid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_farmer_vaccine.dta", nogen  keep(1 3)
merge m:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hhsize.dta", nogen

* Land rights  ALT: Missing
//merge 1:1 hhid personid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_land_rights_ind.dta", nogen
//recode formal_land_rights_f (.=0) if female==1				// this line will set to zero for all women for whom it is missing (i.e. regardless of ownerhsip status)
//la var formal_land_rights_f "Individual has documentation of land rights (at least one plot) - Women only"
gen formal_land_rights_f=.

*getting correct subpopulations (women aged 18 or above in rural households)
recode control_all_income make_decision_ag own_asset formal_land_rights_f (.=0) if female==1 
recode control_all_income make_decision_ag own_asset formal_land_rights_f (nonmissing=.) if female==0

*merge in hh variable to determine ag household
preserve
use "${Ethiopia_ESS_W1_final_data}/Ethiopia_ESS_W1_household_variables.dta", clear
keep hhid ag_hh
tempfile ag_hh
save `ag_hh'
restore
merge m:1 hhid using `ag_hh', nogen keep (1 3)

replace   make_decision_ag =. if ag_hh==0

* NA in NG_LSMS-ISA
gen women_diet=.
gen  number_foodgroup=.

/*
foreach c in wheat beans {
	gen all_imprv_seed_`c' = .
	gen all_hybrid_seed_`c' = .
	gen `c'_farmer = .
}
*/

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

lab var male_vac_animal "1 = Individual male farmers (livestock keeper) uses vaccines"
lab var female_vac_animal "1 = Individual female farmers (livestock keeper) uses vaccines"

*replace empty vars with missing 
global empty_vars *hybrid_seed* women_diet number_foodgroup
foreach v of varlist $empty_vars { 
	replace `v' = .
}

ren weight weight_sample
ren weight_pop_rururb weight
la var weight_sample "Original survey weight"
la var weight "Weight adjusted to match rural/urban populations"

//////////Identifier Variables ////////
gen hhid_panel = hhid
lab var hhid_panel "panel hh identifier" 
ren indiv indid
gen geography = "Ethiopia"
gen survey = "LSMS-ISA" 
gen year = "2010-11" 
gen instrument = 21
//Only runs if label isn't already defined.
capture label define instrument 11 "Tanzania NPS Wave 1" 12 "Tanzania NPS Wave 2" 13 "Tanzania NPS Wave 3" 14 "Tanzania NPS Wave 4" 15 "Tanzania NPS SDD" 16 "Tanzania NPS W5" /*
	*/ 21 "Ethiopia ESS Wave 1" 22 "Ethiopia ESS Wave 2" 23 "Ethiopia ESS Wave 3" 24 "Ethiopia ESS Wave 4" 25 "Ethiopia ESS Wave 5" /*
	*/ 31 "Nigeria GHS Wave 1" 32 "Nigeria GHS Wave 2" 33 "Nigeria GHS Wave 3" 34 "Nigeria GHS Wave 4" 35 "Nigeria GHS Wave 5"/*
	*/ 41 "Malawi IHS/IHPS Wave 1" 42 "Malawi IHS/IHPS Wave 2" 43 "Malawi IHS/IHPS Wave 3" 44 "Malawi IHS/IHPS Wave 4" /*
    */ 51 "Uganda NPS Wave 1" 52 "Uganda NPS Wave 2" 53 "Uganda NPS Wave 3" 54 "Uganda NPS Wave 4" 55 "Uganda NPS Wave 5" /*W6 does not exist*/ 56 "Uganda NPS Wave 7" 57 "Uganda NPS Wave 8" /* 
*/ 61 "Burkina Faso EMC Wave 1" /* 
*/ 71 "Mali EACI Wave 1" 72 "Mali EACI Wave 2" /*
*/ 81 "Niger ECVMA Wave 1" 82 "Niger ECVMA Wave 2"
label values instrument instrument	
//gen strataid=state
//gen clusterid=ea
saveold "${Ethiopia_ESS_W1_final_data}/Ethiopia_ESS_W1_individual_variables.dta", replace

********************************************************************************
*plot-LEVEL VARIABLES
********************************************************************************
*GENDER PRODUCTIVITY GAP
use "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_all_plots.dta", clear
collapse (sum) plot_value_harvest = value_harvest (max) cultivate lost*, by(hhid holder_id parcel_id plot_id )
tempfile crop_values 
save `crop_values'

use "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_plot_area.dta", clear
merge m:1 hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_hhsize.dta", keep (1 3) nogen
merge 1:1 hhid holder_id parcel_id plot_id  using `crop_values', nogen keep(1 3)
merge 1:1 hhid holder_id parcel_id plot_id  using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_plot_decision_makers", keep (1 3) nogen // Bring in the gender file
//merge 1:1 holder_id parcel_id plot_id  hhid using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_plot_farmlabor_postharvest.dta", keep (1 3) nogen
//Replaced by below.
merge 1:1 hhid holder_id parcel_id plot_id  using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_plot_labor_days.dta", keep (1 3) nogen

merge m:1 hhid using "${Ethiopia_ESS_W1_final_data}/Ethiopia_ESS_W1_household_variables.dta", nogen keep (1 3) keepusing(region strataid clusterid hhid ag_hh fhh farm_size_agland rural)
/*DYA.12.2.2020*/ recode farm_size_agland (.=0) 
/*DYA.12.2.2020*/ gen rural_ssp=(farm_size_agland<=4 & farm_size_agland!=0) & rural==1 

keep if cultivate==1
//ren field_size  area_meas_hectares
egen labor_total = rowtotal(labor_family labor_hired labor_nonhired) 
global winsorize_vars area_meas_hectares  labor_total  
foreach p of global winsorize_vars { 
	gen w_`p' =`p'
	local l`p' : var lab `p'
	_pctile w_`p'   [aw=weight_pop_rururb] if w_`p'!=0 , p($wins_lower_thres $wins_upper_thres)    
	replace w_`p' = r(r1) if w_`p' < r(r1)  & w_`p'!=. & w_`p'!=0
	replace w_`p' = r(r2) if w_`p' > r(r2)  & w_`p'!=.
	lab var w_`p' "`l`p'' - Winsorized top and bottom 1%"
}

_pctile plot_value_harvest  [aw=weight_pop_rururb] , p($wins_upper_thres)  
gen w_plot_value_harvest=plot_value_harvest
replace w_plot_value_harvest = r(r1) if w_plot_value_harvest > r(r1) & w_plot_value_harvest != . 
lab var w_plot_value_harvest "Value of crop harvest on this plot - Winsorized top 1%"

*Generate land and labor productivity using winsorized values
gen plot_productivity = w_plot_value_harvest/ w_area_meas_hectares
lab var plot_productivity "Plot productivity Value production/hectare"

*Productivity at the plot level
gen plot_labor_prod = w_plot_value_harvest/w_labor_total  	
lab var plot_labor_prod "Plot labor productivity (value production/labor-day)"

*Winsorize both land and labor productivity at top 1% only
gen plot_weight=w_area_meas_hectares*weight_pop_rururb 
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
	gen `p'_1ppp = (1) * `p' / $Ethiopia_ESS_W1_cons_ppp_dollar
	gen `p'_2ppp = (1) * `p' / $Ethiopia_ESS_W1_gdp_ppp_dollar
	gen `p'_usd = (1) * `p' / $Ethiopia_ESS_W1_exchange_rate 
	gen `p'_loc = (1) * `p' 
	local l`p' : var lab `p' 
	lab var `p'_1ppp "`l`p'' (2017 $ Private Consumption PPP)"
	lab var `p'_2ppp "`l`p'' (2017 $ GDP PPP)"
	lab var `p'_usd "`l`p'' (2017 $ USD)"
	lab var `p'_loc "`l`p'' 2017 (ETB)"  
	lab var `p' "`l`p'' (ETB)"  
	gen w_`p'_1ppp = (1) * w_`p' / $Ethiopia_ESS_W1_cons_ppp_dollar
	gen w_`p'_2ppp = (1) * w_`p' / $Ethiopia_ESS_W1_gdp_ppp_dollar
	gen w_`p'_usd = (1) * w_`p' / $Ethiopia_ESS_W1_exchange_rate
	gen w_`p'_loc = (1) * w_`p' 
	local lw_`p' : var lab w_`p'
	lab var w_`p'_1ppp "`lw_`p'' (2017 $ Private Consumption PPP)"
	lab var w_`p'_2ppp "`lw_`p'' (2017 $ GDP PPP)"
	lab var w_`p'_usd "`lw_`p'' (2017 $ USD)"
	lab var w_`p'_loc "`lw_`p'' 2017 (ETB)"
	lab var w_`p' "`lw_`p'' (ETB)" 
}

**************************************
* GENDER GAPS *
**************************************

*We are reporting two variants of gender-gap
* mean difference in log productivitity without and with controls (plot size and region/state)
* both can be obtained using a simple regression.
* use clustered standards errors
qui svyset clusterid [pweight=plot_weight], strata(strataid) singleunit(centered) 		// get standard errors of the mean

*SIMPLE MEAN DIFFERENCE
gen male_dummy=dm_gender==1  if  dm_gender!=3 & dm_gender!=. //generate dummy equals to 1 if plot managed by male only and 0 if managed by female only

*Gender-gap 1a 
gen lplot_productivity_usd=ln(w_plot_productivity_usd) //use winsorize value for to report gender gap
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



/*BET.12.3.2020 - Begin*/ 
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
lab var gender_prod_gap1b_lsp "Gender productivity gap (%) - regression in logs with controls - LSP"
matrix V1b=e(V)
gen segender_prod_gap1b_lsp= 100*sqrt(el(V1b,1,1)) 
sum segender_prod_gap1b_lsp
lab var segender_prod_gap1b_lsp "SE Gender productivity gap (%) - regression in logs with controls - LSP"


/// *BT 12.3.2020

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

rename v1 ETH_wave3

save   "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_gendergap.dta", replace
restore

/*BET.12.3.2020 - END*/ 

foreach i in 1ppp 2ppp loc{
	gen w_plot_productivity_all_`i'=w_plot_productivity_`i'
	gen w_plot_productivity_female_`i'=w_plot_productivity_`i' if dm_gender==2
	gen w_plot_productivity_male_`i'=w_plot_productivity_`i' if dm_gender==1
	gen w_plot_productivity_mixed_`i'=w_plot_productivity_`i' if dm_gender==3
}

*Create weight 
gen plot_labor_weight= w_labor_total*weight_pop_rururb
 
ren weight weight_sample
ren weight_pop_rururb weight
la var weight_sample "Original survey weight"
la var weight "Weight adjusted to match rural/urban populations"

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
*ren hhid hhid
gen hhid_panel = hhid
lab var hhid_panel "Panel HH identifier" 
ren plot_id plot_id
gen geography = "Ethiopia"
gen survey = "LSMS-ISA" 
gen year = "2010-11" 
gen instrument = 21
//Only runs if label isn't already defined.
capture label define instrument 11 "Tanzania NPS Wave 1" 12 "Tanzania NPS Wave 2" 13 "Tanzania NPS Wave 3" 14 "Tanzania NPS Wave 4" 15 "Tanzania NPS SDD" 16 "Tanzania NPS W5" /*
	*/ 21 "Ethiopia ESS Wave 1" 22 "Ethiopia ESS Wave 2" 23 "Ethiopia ESS Wave 3" 24 "Ethiopia ESS Wave 4" 25 "Ethiopia ESS Wave 5" /*
	*/ 31 "Nigeria GHS Wave 1" 32 "Nigeria GHS Wave 2" 33 "Nigeria GHS Wave 3" 34 "Nigeria GHS Wave 4" 35 "Nigeria GHS Wave 5"/*
	*/ 41 "Malawi IHS/IHPS Wave 1" 42 "Malawi IHS/IHPS Wave 2" 43 "Malawi IHS/IHPS Wave 3" 44 "Malawi IHS/IHPS Wave 4" /*
    */ 51 "Uganda NPS Wave 1" 52 "Uganda NPS Wave 2" 53 "Uganda NPS Wave 3" 54 "Uganda NPS Wave 4" 55 "Uganda NPS Wave 5" /*W6 does not exist*/ 56 "Uganda NPS Wave 7" 57 "Uganda NPS Wave 8" /* 
*/ 61 "Burkina Faso EMC Wave 1" /* 
*/ 71 "Mali EACI Wave 1" 72 "Mali EACI Wave 2" /*
*/ 81 "Niger ECVMA Wave 1" 82 "Niger ECVMA Wave 2"
label values instrument instrument

saveold "${Ethiopia_ESS_W1_final_data}/Ethiopia_ESS_W1_field_plot_variables.dta", replace

********************************************************************************
*SUMMARY STATISTICS
******************************************************************************** 
/*
All the pre-processed files include all households, individuals, and plots in the sample. 
The summary statistics are outputted only for the sub_population of households, individuals, and plots in rural areas. 
The code for outputting the summary statistics is in a separare dofile that is called here
*/ 
*Parameters
global list_instruments  "Ethiopia_ESS_W1"
do "$summary_stats"
