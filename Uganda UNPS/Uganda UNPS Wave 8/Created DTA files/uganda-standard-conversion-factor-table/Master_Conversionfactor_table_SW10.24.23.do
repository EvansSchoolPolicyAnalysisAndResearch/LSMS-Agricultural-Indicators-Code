/*
-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of a Master Crop Conversion Factor Harvest List (Standard Unit to Kgs) in Uganda 
				  using the Uganda National Panel Survey (UNPS) LSMS-ISA Wave 1-7
*Author(s)		: Sebastian Wood 

*Date			: This Version - 7 July 2023

----------------------------------------------------------------------------------------------------------------------------------------------------*/


*I. Create Panel Dataset with All 7 Uganda Waves
*I.1 Uganda Wave 1
*Crop Harvest
use  "R:\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\uganda-wave1-2009-10\raw_data\2009_AGSEC5a.dta" , replace
gen season=1
append using "R:\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\uganda-wave1-2009-10\raw_data\2009_AGSEC5B.dta"
replace season=2 if season==1
rename Hhid HHID
rename A5aq4 crop_name
rename A5aq5 crop_code
gen condition_harv=A5aq6b
replace condition_harv=A5bq6b if condition_harv==.
gen unit_code = A5aq6c
replace unit_code = A5bq6c if unit_code==.
gen conv_fact_harv =A5aq6d
replace conv_fact_harv=A5bq6d if conv_fact_harv==.
*Crop Sold (Missing Conversion factor sold)
gen condition_sold =A5aq7b 
replace condition_sold=A5bq7a if condition_sold==.
gen sold_unit_code=A5aq7c
replace sold_unit_code=A5bq7c if sold_unit_code==.
merge m:1 HHID using "R:\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\uganda-wave1-2009-10\temp\Uganda_NPS_LSMS_ISA_W1_hhids.dta", nogen keepusing (region district county subcounty parish ea weight)
keep HHID crop_name crop_code condition_harv unit_code conv_fact_harv condition_sold sold_unit_code region weight /*district county subcounty parish ea*/
keep if crop_name!=""
gen wave="wave 1" 
*I.2. Uganda Wave 2
*Crop Harvest
preserve 
use "R:/Project/EPAR/Working Files/378 - LSMS Burkina Faso, Malawi, Uganda/uganda-wave2-2010-11/raw_data/AGSEC5A.dta", clear
gen season=1
append using "R:/Project/EPAR/Working Files/378 - LSMS Burkina Faso, Malawi, Uganda/uganda-wave2-2010-11/raw_data/AGSEC5B.dta"
replace season=2 if season==.
rename cropID crop_code
* Unit of Crop Harvested 
clonevar condition_harv = a5aq6b
replace condition_harv = a5bq6b if season==2
clonevar unit_code=a5aq6c
replace unit_code=a5bq6c if unit_code==.
clonevar conv_fact_harv = a5aq6d 
replace conv_fact_harv = a5bq6d if season==2
replace conv_fact_harv = 1 if unit_code==1
gen condition_sold=a5aq7b
replace condition_sold=a5bq7b if condition_sold==.
clonevar sold_unit_code =a5aq7c
replace sold_unit_code=a5bq7c if sold_unit_code==.
tostring HHID, format(%18.0f) replace
merge m:1 HHID using "R:/Project/EPAR/Working Files/378 - LSMS Burkina Faso, Malawi, Uganda/uganda-wave2-2010-11/temp/Uganda_NPS_W2_hhids.dta", nogen keepusing(region district county subcounty parish ea weight) keep(1 3)
keep HHID /*crop_name*/ crop_code condition_harv unit_code conv_fact_harv condition_sold sold_unit_code region weight /*district county subcounty parish ea*/
gen wave="wave 2" 
keep if crop_code!=.
tempfile wave2 
save `wave2'
restore

/* OLD preserve 
use "R:/Project/EPAR/Working Files/378 - LSMS Burkina Faso, Malawi, Uganda/uganda-wave2-2010-11/temp/Uganda_NPS_W2_crop_value.dta", replace 
clonevar condition_harv=a5aq6b
replace condition_harv=a5bq6b if condition==.
clonevar conv_fact_harv= a5aq6d
replace conv_fact_harv=a5bq6d if conv_fact_harv==.
gen condition_sold=a5aq7b
replace condition_sold=a5bq7b if condition_sold==.
keep HHID /*crop_name*/ crop_code condition_harv unit_code conv_fact_harv condition_sold sold_unit_code region weight /*district county subcounty parish ea*/
gen wave="wave 2" 
keep if crop_code!=.
tempfile wave2 
save `wave2'
restore */

*I.3. Uganda Wave 3 
preserve
use "R:\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\uganda-wave3-2011-12\raw_data\AGSEC5A.dta", clear
gen season=1
append using "R:\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\uganda-wave3-2011-12\raw_data\AGSEC5B.dta"
replace season=2 if season==.
rename cropID crop_code
* Unit of Crop Harvested 
clonevar condition_harv = a5aq6b
replace condition_harv = a5bq6b if season==2
clonevar unit_code=a5aq6c
replace unit_code=a5bq6c if unit_code==.
clonevar conv_fact_harv = a5aq6d 
replace conv_fact_harv = a5bq6d if season==2
replace conv_fact_harv = 1 if unit_code==1
*Unit of Crop Sold
clonevar sold_unit_code =a5aq7c
replace sold_unit_code=a5bq7c if sold_unit_code==.
clonevar conv_fact_sold = A5AQ7D 
replace conv_fact_sold = A5BQ7D if season==2
replace conv_fact_sold = 1 if sold_unit_code==1
tostring HHID, format(%18.0f) replace
merge m:1 HHID using "R:\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\uganda-wave3-2011-12\temp\Uganda_NPS_LSMS_ISA_W3_hhids.dta", nogen keepusing(region district county subcounty parish ea weight) keep(1 3)
keep HHID /*crop_name*/ crop_code condition_harv unit_code conv_fact_harv /*condition_sold*/ sold_unit_code conv_fact_sold region weight /*district county subcounty parish ea*/
gen wave="wave 3" 
tempfile wave3
save `wave3'
restore

/*I.3. Uganda Wave 3 (r])
preserve
use "R:/Project/EPAR/Working Files/378 - LSMS Burkina Faso, Malawi, Uganda/uganda-wave3-2011-12/temp/Uganda_NPS_LSMS_ISA_W3_crop_value2.dta", replace 
clonevar condition_harv=a5aq6b
replace condition_harv=a5bq6b if condition==.
clonevar conv_fact_harv= a5aq6d
replace conv_fact_harv=a5bq6d if conv_fact_harv==.
gen conv_fact_sold=A5AQ7D
replace conv_fact_sold=A5BQ7D if conv_fact_sold==.
keep HHID /*crop_name*/ crop_code condition_harv unit_code conv_fact_harv /*condition_sold*/ sold_unit_code conv_fact_sold region weight /*district county subcounty parish ea*/
gen wave="wave 3" 
tempfile wave3
save `wave3'
restore */

*I.4. Uganda Wave 4
preserve
use "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\uganda-wave4-2013-14\raw_data\Agric\AGSEC5A.dta", clear
gen season = 1
append using "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\uganda-wave4-2013-14\raw_data\Agric\AGSEC5B.dta"
replace season = 2 if season == .
*Crop Harvest
rename a5aq6b condition_harv
replace condition_harv=a5bq6b if condition_harv==.
rename  a5aq6c unit_code
replace unit_code =a5bq6c if unit_code==.
rename a5aq6d conv_fact_harv
replace conv_fact_harv=a5bq6d if conv_fact_harv==.
*Crop Sold
rename a5aq7b condition_sold
replace condition_sold = a5bq7b if condition_sold==.
rename a5aq7c sold_unit_code
replace sold_unit_code=a5bq7c if sold_unit_code==.
rename a5aq7d conv_fact_sold
replace conv_fact_sold = a5bq7d if conv_fact_sold==.
ren HHID hhid
ren hh HHID 
rename cropID crop_code
keep if condition_harv!=.
merge m:1 HHID using "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\uganda-wave4-2013-14\temp\Uganda_NPS_W4_hhids.dta", nogen keepusing(region weight) keep(1 3)
keep HHID /*crop_name*/ crop_code condition_harv unit_code conv_fact_harv condition_sold sold_unit_code conv_fact_sold region weight /*district county subcounty parish ea*/
gen wave="wave 4" 
tempfile wave4
save `wave4'
restore

*I.5. Uganda Wave 5
preserve
use "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\uganda-wave5-2015-16\raw_data\AGSEC5A.dta", clear
gen season = 1
append using "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\uganda-wave5-2015-16\raw_data\AGSEC5B.dta"
*Crop Harvest
rename a5aq6b condition_harv
replace condition_harv =a5bq6b if condition_harv==.
rename a5aq6c unit_code
replace unit_code=a5bq6c if unit_code==.
rename a5aq6d conv_fact_harv
replace conv_fact_harv = a5bq6d if conv_fact_harv==.
*Crop Sold
rename a5aq7b condition_sold
replace condition_sold = a5bq7b if condition_sold==.
rename a5aq7c sold_unit_code
replace sold_unit_code = a5bq7c if sold_unit_code==.
rename A5AQ7D conv_fact_sold 
replace conv_fact_sold = a5bq7d if conv_fact_sold==.
rename HHID hhid
merge m:1 hhid using "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\uganda-wave5-2015-16\temp\Uganda_NPS_W5_hhids.dta", nogen keepusing(/*district scounty_code parish_code*/ region pweight) keep(1 3)
rename hhid HHID
rename cropID crop_code
rename pweight weight
keep HHID /*crop_name*/ crop_code condition_harv unit_code conv_fact_harv condition_sold sold_unit_code conv_fact_sold region weight /*district county subcounty parish ea*/
gen wave="wave 5" 
tempfile wave5
save `wave5'
restore

*I.6 Uganda Wave 7 (UG Wave 6 missing)
preserve
use "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda/uganda-wave7-2018-19\raw_data\Agric\AGSEC5A.dta", clear
gen season = 1
append using "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda/uganda-wave7-2018-19/raw_data/Agric/AGSEC5B.dta"
replace season = 2 if season == .
rename a5aq6b condition_harv 
replace condition_harv = a5bq6c if condition_harv==.
rename a5aq6c unit_code
replace unit_code =a5bq6b  if unit_code==. // Not sure here since the numbers don't match correctly Ask Peter
rename a5aq6d conv_fact_harv
replace conv_fact_harv = a5bq6d if conv_fact_harv==.
*Crop Sold
rename s5aq07b_1 condition_sold
replace condition_sold=s5bq07b_1 if condition_sold==.
rename s5aq07c_1 sold_unit_code
replace sold_unit_code=s5bq07c_1 if sold_unit_code==.
*TALK WITH PETER: conversionfactor_sales_2_5b saleskg_2_5b 
merge m:1 hhid using "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\uganda-wave7-2018-19\created_data\Uganda_NPS_W7_hhids.dta", nogen keepusing(/*district subcounty_code parish_code*/ region weight) keep(1 3)
rename hhid HHID
rename cropID crop_code
keep HHID /*crop_name*/ crop_code condition_harv unit_code conv_fact_harv condition_sold sold_unit_code /*conv_fact_sold*/ region weight /*district county subcounty parish ea*/
gen wave="wave 6" 
tempfile wave6
save `wave6'
restore


*I.7 Uganda Wave 8 
preserve
use "R:\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\uganda-wave8-2019-20\raw_data\UGA_2019_UNPS_v01_M_STATA14\Agric\agsec5a.dta", clear
gen season=1
append using "R:\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\uganda-wave8-2019-20\raw_data\UGA_2019_UNPS_v01_M_STATA14\Agric\agsec5b.dta"
replace season = 2 if season ==.
recast str32 hhid
rename cropID crop_code 
*1a. Condition Harvest
rename s5aq06c_1 condition_harv1 // Fully Harvest
replace condition_harv1 = s5bq06c_1 if condition_harv1==.
rename s5aq06c_2 condition_harv2 // Fully Harvest
replace condition_harv2 = s5bq06c_2 if condition_harv2==.
*1b. Unit of Crop Harvest
rename s5aq06b_1 unit_code1
replace unit_code1 = s5bq06b_1 if unit_code1==.
rename s5aq06b_2 unit_code2
replace unit_code2 = s5bq06b_2 if unit_code2==.
*1c. Conversion Factor
rename s5aq06d_1 conv_fact_harv1
replace conv_fact_harv1 =s5bq06d_1 if conv_fact_harv1==.
rename s5aq06d_2 conv_fact_harv2
replace conv_fact_harv2 =s5bq06d_2 if conv_fact_harv2==.
*2a.Condition Sold
rename s5aq07b_1 condition_sold1
replace condition_sold1 = s5bq07b_1 if condition_sold1==.
rename s5aq07b_2 condition_sold2 
replace condition_sold2 =s5bq07b_2 if condition_sold2==.
*2b. Unit of Crop Sold
rename s5aq07c_1 sold_unit_code1
replace sold_unit_code1=s5bq07c_1 if sold_unit_code1==.
rename s5aq07c_2 sold_unit_code2
replace sold_unit_code2=s5bq07c_2 if sold_unit_code2==. 
*2c. Conversion Factor Sold (No Conversion factor sold)
keep hhid parcelID pltid season /*crop_name*/ crop_code condition_harv* unit_code* conv_fact_harv* condition_sold* sold_unit_code* /*conv_fact_sold region weight district county subcounty parish ea*/
reshape long /*qty_harvest*/  condition_harv unit_code conv_fact_harv condition_sold sold_unit_code , i(hhid parcelID pltid /*crop_name*/ crop_code season) j(cond_no) string 
merge m:1 hhid using "R:\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\uganda-wave8-2019-20\temp\Uganda_NPS_w8_hhids.dta", nogen /*keepusing(weight)*/ keep(1 3)
gen wave ="wave 8"
rename hhid HHID
keep wave HHID /*crop_name*/ crop_code condition_harv* unit_code* conv_fact_harv* condition_sold* sold_unit_code* /*conv_fact_sold*/ region weight /*district county subcounty parish ea*/
keep if unit_code!=.
tempfile wave7
save `wave7'
restore

*II. Creating Panel dataset
forvalues i=2/7 {
append using `wave`i''
}

*Creating Conversion Factor Table For each Crop - Unit - Condition - Region
gen nobs=1
rename conv_fact_harv s_conv_factor_harv
rename conv_fact_sold s_conv_factor_sold
*7/25/23 SA Update: We need this, otherwise it will not merge CF for bananas.
/* 10.24.23 SA Update: We will conduct analysis for each crop, and we will group bananas at the very end
recode crop_code  (741 742 744 = 740)  //  Same for bananas (740)
label define cropID 740 "Bananas", modify //need to add new codes to the value label, cropID
label values crop_code cropID //apply crop labels to crop_code_master */

preserve 
collapse (median) s_conv_factor_harv (sum) nobs [weight=weight], by(crop_code /*condition_harv*/ unit_code region)
label value crop_code cropID
label value unit_code a5aq6c
*label value condition_harv a5aq6b
label value region region
drop if unit_code==. 
save "R:\Project\EPAR\Working Files\RA Working Folders\Sebastian\Uganda Conversion Factor\UG_Conv_fact_harvest_table_update.dta", replace
save "R:\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\uganda-standard-conversion-factor-table\UG_Conv_fact_harvest_table_update.dta", replace
restore

*SW 10.24.23 National Level Conversion factor Harvest - We need this for HHIDs with missiong regional information
preserve
collapse (median) sn_conv_factor_harv = s_conv_factor_harv (sum) nobs [weight=weight], by(crop_code /*condition_harv*/ unit_code)
label value crop_code cropID
label value unit_code a5aq6c
*label value condition_harv a5aq6b
drop if unit_code==. 
save "R:\Project\EPAR\Working Files\RA Working Folders\Sebastian\Uganda Conversion Factor\UG_Conv_fact_harvest_table_national_update.dta", replace
save "R:\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\uganda-standard-conversion-factor-table\UG_Conv_fact_harvest_table_national_update.dta", replace

restore

preserve
keep if wave=="wave 3" | wave=="wave 4" | wave=="wave 5"
collapse (median) s_conv_factor_sold (sum) nobs [weight=weight], by(crop_code /*condition_sold*/ sold_unit_code region) 
label value crop_code cropID
*label value condition_sold a5aq7b
label value sold_unit_code a5aq7c
label value region region
replace s_conv_factor_sold=1 if sold_unit_code==1
drop if sold_unit_code==.
save "R:\Project\EPAR\Working Files\RA Working Folders\Sebastian\Uganda Conversion Factor\UG_Conv_fact_sold_table_update.dta", replace 
save "R:\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\uganda-standard-conversion-factor-table\UG_Conv_fact_sold_table_update.dta", replace

restore

*SW 10.24.23 National Level Conversion factor SOLD - We need this for HHIDs with missiong regional information
preserve
keep if wave=="wave 3" | wave=="wave 4" | wave=="wave 5"
collapse (median) sn_conv_factor_sold = s_conv_factor_sold (sum) nobs [weight=weight], by(crop_code /*condition_sold*/ sold_unit_code) 
label value crop_code cropID
*label value condition_sold a5aq7b
label value sold_unit_code a5aq7c
replace sn_conv_factor_sold=1 if sold_unit_code==1
drop if sold_unit_code==.
save "R:\Project\EPAR\Working Files\RA Working Folders\Sebastian\Uganda Conversion Factor\UG_Conv_fact_sold_table_national_update.dta", replace 
save "R:\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\uganda-standard-conversion-factor-table\UG_Conv_fact_sold_table_national_update.dta", replace

********************************* STOP ****************************************


