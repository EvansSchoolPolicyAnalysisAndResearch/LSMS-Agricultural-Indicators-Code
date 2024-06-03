

global directory	"\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda"

global Malawi_IHS_W1_raw_data 	"${directory}/malawi-wave1-2010-11\Raw DTA Files"
global Malawi_IHS_W2_raw_data 	"${directory}/malawi-wave2-2013\Raw DTA Files"
global Malawi_IHS_W3_raw_data 	"${directory}/malawi-wave3-2016\Raw DTA Files/raw_data_07212023"
global Malawi_IHS_W4_raw_data 	"${directory}/malawi-wave4-2019\Raw DTA Files/raw_data"

global Malawi_IHPS_raw_data		"${directory}/malawi-ihps-all-datasets"

global Malawi_IHS_W1_created_data "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave1-2010-11\Final DTA Files\created_data"
global Malawi_IHS_W2_created_data "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave2-2013\Final DTA files\created_data"
global Malawi_IHS_W3_created_data "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave3-2016\Final DTA Files\created_data"
global Malawi_IHS_W4_created_data "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave4-2019\Final DTA Files\created_data"


use "${Malawi_IHS_W1_raw_data}/Household/hh_mod_a_filt.dta", clear
gen wave = 1
encode qx_type, g(qx_type2)
drop qx_type
ren qx_type2 qx_type
gen y1_hhid = case_id
append using "${Malawi_IHS_W2_raw_data}/Household/HH_MOD_A_FILT_13.dta" 
replace wave = 2 if wave == . 
drop hh_*
duplicates report y1_hhid
append using "${Malawi_IHS_W3_raw_data}/Household/hh_mod_a_filt.dta"
append using "${Malawi_IHPS_raw_data}/hh_mod_a_filt_16.dta"
replace wave = 3 if wave ==.
//replace y2_hhid = "" if wave == 3
drop hh_* 
replace hhid = y3_hhid if hhid=="" & wave == 3
replace y3_hhid = hhid if y3_hhid=="" & wave == 3
tostring HHID, replace
preserve 
use "${Malawi_IHS_W4_raw_data}/hh_mod_a_filt.dta", clear
gen y4_hhid=case_id 
tempfile w4_cx 
save `w4_cx'
restore
//append using "${Malawi_IHS_W4_raw_data}/hh_mod_a_filt.dta"
append using `w4_cx'
drop HHID
append using "${Malawi_IHPS_raw_data}/hh_mod_a_filt_19.dta"
replace wave = 4 if wave ==. 
//replace hhid = case_id if hhid=="" & wave == 4
//replace y4_hhid=hhid if y4_hhid=="" & wave == 4
replace hhid=y4_hhid if hhid=="" & wave == 4
replace case_id = hhid if case_id==""

forvalues k=1/4{
	duplicates report y`k'_hhid
}

order wave, before(qx_type)
sort case_id   y4_hhid y3_hhid y2_hhid
//gen y1_hhid = case_id if wave<=2
gen y1_pid = "01"
order y1_hhid y1_pid, after(case_id)
gen y1_sum = 1 if wave==1 
order y1_sum , after(y1_hhid)

forvalues k=2/4{
	preserve
	keep if wave==`k'
	capture drop y`k'_pid
	capture drop y`k'_sum 
	capture drop y`k'_index 
	local j = `k'-1
	sort case_id y4_hhid y3_hhid y2_hhid
	gen y`k'_pid = substr(y`k'_hhid,length(y`k'_hhid)-1,length(y`k'_hhid))
	capture drop aux 
	gen aux = (y`k'_hhid!="" & wave==`k')
	sort case_id y`k'_hhid y`j'_hhid
	egen y`k'_sum = sum(aux) if wave==`k', by(y`j'_hhid wave)
	//sort case_id y`j'_hhid y`k'_hhid
	bysort y`j'_hhid (y`k'_hhid): gen y`k'_index = _n //if wave==`k'
	order y`k'_pid y`k'_index y`k'_sum , after(y`k'_hhid)
	tempfile wid`k'
	save `wid`k'', replace
	restore 
}

sort case_id   y4_hhid y3_hhid y2_hhid

sort y3_hhid (y4_hhid)

keep if wave==1
append using `wid2'
append using `wid3'
append using `wid4'
order y1_hhid y2_hhid y2_index y2_sum y3_hhid y3_index y3_sum y4_hhid y4_index y4_sum, after(case_id) 
gen rownum = _n
* Wave 1 hhid 
sort case_id y4_hhid y3_hhid y2_hhid
gen case_id_aux=case_id+"-10001" if wave==1
order case_id_aux, after(case_id)

preserve 
	keep if wave==1
	tempfile caseidw1
	save `caseidw1', replace 		
restore 
forvalues k=2/4 {
	preserve 
		local j = `k'-1
		keep if wave==`k'
		append using `caseidw`j''
		sort y`j'_hhid y`k'_hhid  
		order y`k'_pid, after(y`k'_hhid)
		replace case_id_aux=case_id_aux[_n-1] if y`k'_index==1 & wave==`k' & wave[_n-1]==`j'
		replace case_id_aux=case_id+"-`k'"+substr(y`j'_hhid,length(y`j'_hhid)-1,length(y`j'_hhid))+y`k'_pid if missing(case_id_aux) & wave==`k' 
		keep if wave==`k'
		tempfile caseidw`k'
		save `caseidw`k'', replace 	
	restore 
}
use `caseidw1', clear 
append using `caseidw2'
append using `caseidw3'
append using `caseidw4'

sort case_id  y2_hhid y3_hhid y4_hhid 
drop hhid
//rename case_id_aux hhid 
keep case_id_aux y1_hhid y2_hhid y3_hhid y4_hhid
save "${directory}/MWI_panel_ids.dta", replace
