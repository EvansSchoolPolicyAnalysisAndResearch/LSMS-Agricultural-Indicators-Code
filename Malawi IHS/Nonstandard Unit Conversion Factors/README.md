## Nonstandard Unit Conversion Factors

This folder contains a master nonstandard unit conversion factor file constructed from several sources, including the conversion factor files released with the IHPS long panel 2019 dataset (included here) and data in the IHS 3 

	*********************************
	* 		   DATA SOURCES         *
	*********************************
*The IHS Agricultural Conversion Factor Database.dta files originates from the Malawi Fifth Integrated Household Survey 2019-2020 available at https://microdata.worldbank.org/index.php/catalog/3818 where the version 04 data release included the supplementation of TWO (for temporary and permanent/tree crops respectively) raw data files that convert non-standard units (Pails, Ox Carts, etc.) to kilograms of unshelled crop. We borrow this survey's conversion factor files for the remaining Waves in the absence of having similar files for earlier versions of the survey.
*We scrape additional conversion factor data from a Food Unit Conversion factor pdf for the Malawi Third Integrated Household Survey 2010-2011 available at https://microdata.worldbank.org/index.php/catalog/1003/download/40802
*The raw conversion factor files disaggregate conversions by crop condition where applicable or available (e.g. the conversion to kgs of shelled groundnuts is different than unshelled groundnuts).
	
	*********************************
	*   PROCESS AND INTERPOLATION   *
	*********************************
*We start by creating unique crop codes across permanent and temporary crop conversion factor datasets (where there is overlap between the two) and appending temporary and permament/tree conversion factors together to form a single conversion factor file for use.
*We interpolate missing conversion factors using shell_unshelled ratios where we have a conversion factor for shelled but not unshelled and vice versa for a specific region/crop/unit. Next, we interpolate more missing conversion facotrs with with available conversion factors for the same crop/condition from other regions.
*We "build-out" this conversion factor file to assist with matching harvest observations to conversion factors later in the code. These additions include:
	*1. Creating additional observations where condition equals "N/A", borrowing the corresponding unshelled conversion factor for that crop
	*2. Creating additonal observations where condition equals "Not applicable", borrowing the corresponding unshelled conversion factor for that crop 
	*3. Many more - see documentation below

	*********************************
	*         HOW TO USE            *
	*********************************
* FOLLOW THESE THREE STEPS EVERY TIME YOU MERGE IN THE CONVERSION FACTOR FILE THROUGHOUT THE MAIN DO-FILE
* 1. PREPARE RAW DATA
	* Use tree/perm crop file and align crop_code so that it is consistent to what is in the conversion factor file and across all other waves:
		*Waves 1 and 2: recode crop_code (1=49)(2=50)(3=51)(4=52)(5=53)(6=54)(7=55)(8=56)(9=57)(10=58)(11=59)(12=60)(13=61)(14=62)(15=63)(16=64)(17=65)(18=48)
		*Waves 3 and 4: recode crop_code (1=49)(2=50)(3=51)(4=52)(5=53)(6=54)(7=55)(8=56)(9=57)(10=58)(11=59)(12=60)(13=61)(14=62)(15=63)(16=64)(17=65)(18=1800)(19=1900)(20=2000)(21=48)
	* There is a chance that your unit variable in the tree/permanent crop file is in string format because some farmers report small bunches (8A) or large bunches (8C), etc. Check to see what is in here. If any units are numbers and letters together (e.g. 8A), recode to a numeric unit code (see unit_labels for codes). Then, convert the variable to numeric.
	* Append tree/perm crop file to rainy and dry files, if applicable
	* If crop_code is o/s for any crop (code is 48), try to sort into existing crop codes - see value labels L0C
	* If unit is o/s (code is 13), try to sort into existing unit codes
	* Drop if crop_code==. | unit==. //cannot impute yield or calories without either of these
	* Rename crop_code crop_code_long
	* Create a new variable called crop_code which is the condensed version of the crop_code_long (1 2 3 4=1)(5 6 7 8 9 10=5)(11 12 13 14 15 16=11)(17 18 19 20 21 22 23 24 25 26=17) - keep crop_code_long
	* Replace condition==3 if condition==. & crop_code_long!=. & unit!=. //or should we make a fourth category called not specified?

*2. MERGE IN CONVERSION FACTOR FILE
	*merge m:1 region crop_code_long unit condition using "${Malawi_IHS_W#_created_data}\Malawi_IHS_W#_cf.dta" //NOTE THAT WE MERGE ON CROP_CODE_LONG INTENTIONALLY

*3. POST-MERGE
	* replace conversion=1 if conversion==. & unit==1 & condition==1 (shelled)
	* Multiply quantity by conversion factor
	