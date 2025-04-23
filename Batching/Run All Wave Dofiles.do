//Note - this will take a while to run everything sequentially; it can be done in parallel by running each block in a separate window or getting some friends to help out.
cd ".."
global maindir "`c(pwd)'"
global subdirs "final_data created_data temp_data"
global mwi_subdlist "Agriculture Community Fisheries Geovariables Household"

//Nigeria
forvalues k = 1/5 {
	local folder "$maindir/Nigeria GHS/Nigeria GHS Wave `k'"
	cd "`folder'"
	foreach subdir in $subdirs {
	//di "`folder'/Final DTA Files/`subdir'"
	capture local files : dir "`folder'/Final DTA Files/`subdir'" files "*.dta"
	if !_rc {
	foreach file in `files' {
		erase "`folder'/Final DTA Files/`subdir'/`file'"
	}
	} 
	else {
	di "Folder `subdir' not found, code may produce an error"
	}
}
	do "`folder'\EPAR_UW_Nigeria_GHS_W`k'.do"

}

//Ethiopia

forvalues k = 1/5 {
	local folder "$maindir/Ethiopia ESS/Ethiopia ESS Wave `k'"
	cd "`folder'"
	foreach subdir in $subdirs {
	//di "`folder'/Final DTA Files/`subdir'"
	capture local files : dir "`folder'/Final DTA Files/`subdir'" files "*.dta"
	if !_rc {
	foreach file in `files' {
		erase "`folder'/Final DTA Files/`subdir'/`file'"
	}
	} 
	else {
	di "Folder `subdir' not found, code may produce an error"
	}
	}
	do "`folder'\EPAR_UW_Ethiopia_ESS_W`k'.do"
}


//Tanzania
forvalues k = 1/6 {
	if `k'==6 {
		local folder "$maindir/Tanzania NPS/Tanzania NPS SDD"
		local wname "SDD"
	} 
	else {
		local folder "$maindir/Tanzania NPS/Tanzania NPS Wave `k'"
		local wname "W`k'"
	}
	cd "`folder'"
	foreach subdir in $subdirs {
	//di "`folder'/Final DTA Files/`subdir'"
	capture local files : dir "`folder'/Final DTA Files/`subdir'" files "*.dta"
	if !_rc {
	foreach file in `files' {
		erase "`folder'/Final DTA Files/`subdir'/`file'"
	}
	} 
	else {
	di "Folder `subdir' not found, code may produce an error"
	}
	
}
do "`folder'\EPAR_UW_Tanzania_NPS_`wname'.do"
}
	

//Malawi
forvalues k = 1/4 {
	local folder "$maindir/Malawi IHS/Malawi IHS Wave `k'"
	cd "`folder'"
	foreach subdir in $subdirs {
	capture local files : dir "`folder'/Final DTA Files/`subdir'" files "*.dta"
	if !_rc {
	foreach file in `files' {
		erase "`folder'/Final DTA Files/`subdir'/`file'"
	}
	if `k'==1 {
		foreach subsubdir in $mwi_subdlist {
			capture local files : dir "`folder'/Final DTA Files/`subdir'/`subsubdir'" files "*.dta"
			if !_rc {
				foreach file in `files' {
		erase "`folder'/Final DTA Files/`subdir'/`subsubdir'/`file'"
	}
		}
	}
	} 
	}
	else {
	di "Folder `subdir' not found, code may produce an error"
	}
	
}
do "`folder'\EPAR_UW_Malawi_IHS_W`k'.do"
}

//Uganda
forvalues k = 1/8 {
if `k'!=6 {
	local folder "$maindir/Uganda UNPS/Uganda UNPS Wave `k'"
	cd "`folder'"
	foreach subdir in $subdirs {
	//di "`folder'/Final DTA Files/`subdir'"
	capture local files : dir "`folder'/Final DTA Files/`subdir'" files "*.dta"
	if !_rc {
	foreach file in `files' {
		erase "`folder'/Final DTA Files/`subdir'/`file'"
	}
	} 
	else {
	di "Folder `subdir' not found, code may produce an error"
	}
	
}
do "`folder'\EPAR_UW_Uganda_UNPS_W`k'.do"
}
}