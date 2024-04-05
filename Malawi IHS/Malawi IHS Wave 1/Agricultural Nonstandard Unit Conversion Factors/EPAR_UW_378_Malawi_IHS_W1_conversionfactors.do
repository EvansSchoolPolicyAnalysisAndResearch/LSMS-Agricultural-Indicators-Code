/*
-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of a set of agricultural development indicators 
				  using the Malawi National Panel Survey (IHS3) LSMS-ISA Wave 1 (2010-2011)
*Author(s)		: Didier Alia, C. Leigh Anderson, Micah McFeely, Andrew Tomes

*Acknowledgments: We acknowledge the helpful contributions of members of the World Bank's LSMS-ISA team, the FAO's RuLIS team, IFPRI, IRRI, 
				  and the Bill & Melinda Gates Foundation Agricultural Development Data and Policy team in discussing indicator construction decisions. 
				  All coding errors remain ours alone.
*Date			: November 1, 2023

----------------------------------------------------------------------------------------------------------------------------------------------------*/

clear
set more off

clear matrix	
clear mata	
set maxvar 8000		

//set directories
*These paths correspond to the folders where the raw data files are located and where the created data and final data will be stored.
global Malawi_IHS_W1_raw_data "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave1-2010-11\raw_data"
global Malawi_IHS_W1_created_data "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave1-2010-11\created_data"

********************************************************************************
* PROCESS AND DOCUMENTATION - READ THESE
********************************************************************************
	*********************************
	* 		   DATA SOURCES         *
	*********************************
*The IHS Agricultural Conversion Factor Database.dta files originates from the Malawi Fifth Integrated Household Survey 2019-2020 available at https://microdata.worldbank.org/index.php/catalog/3818 where the version 04 data release included the supplementation of TWO (for temporary and permanent/tree crops respectively) raw data files that convert non-standard units (Pails, Ox Carts, etc.) to kilograms. We borrow this survey's conversion factor files for the remaining Waves in the absence of having similar files for earlier versions of the survey.
* We scrape additional conversion factor data from a Food Unit Conversion factor pdf for the Malawi Third Integrated Household Survey 2010-2011 available at https://microdata.worldbank.org/index.php/catalog/1003/download/40802
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
	
********************************************************************************
* CROP UNIT CONVERSION FACTORS *
********************************************************************************
	*********************************
	* FOOD UNIT CONVERSION FACTORS  *
	*********************************
//file:///C:/Users/micahmcf/Downloads/Malawi_IHS3_Food_Item_Conversion_Factors.pdf
//These are food unit measurement so assuming shelled is the default unless a crop where shell_unshelled not applicable (e.g. cabbage))
clear
input crop_code str40 item_name unit str20 unit_desc condition cf1 cf2 cf3  
1 "Maize grain (not as ufa)" 4 "Pail (small)" 1 4.38 4.47 4.26 //these seem to be shelled based on the small and large pails being close to the shelled values from the other cf factor file
1 "Maize grain (not as ufa)" 14 "Pail (medium)" 1 9.19 8.41 6.77 
1 "Maize grain (not as ufa)" 5 "Pail (large)" 1 18.49 16.46 17.6 
1 "Maize grain (not as ufa)" 6 "No.10 Plate" 1 0.2 0.2 0.2
1 "Maize grain (not as ufa)" 7 "No.12 Plate" 1 0.33 0.26 0.37
1 "Maize grain (not as ufa)" 16 "Cup" 1 0.3 0.3 0.3
1 "Maize grain (not as ufa)" 21 "Basin" 1 4.05 4.65 3.67
105 "Green maize" 90 "Piece (small)" 1 0.24 0.19 0.24  
105 "Green maize" 9 "Piece (medium)" 1 0.38 0.33 0.34
105 "Green maize" 91 "Piece (large)" 1 0.53 0.42 0.39
26 "Rice" 4 "Pail (small)" 1 2.48 2.48 2.48  
26 "Rice" 14 "Pail (medium)" 1 5.88 5.88 5.88
26 "Rice" 6 "No.10 Plate" 1 0.13 0.19 0.2
26 "Rice" 7 "No.12 Plate" 1 0.34 0.32 0.25
26 "Rice" 16 "Cup" 1 0.62 0.52 0.42
26 "Rice" 21 "Basin" 1 4.2 0.96 1.78
31 "Finger millet (mawere)" 6 "No.10 Plate" 1 0.2 0.09 0.11 
31 "Finger millet (mawere)" 7 "No.12 Plate" 1 0.35 0.21 0.12  
31 "Finger millet (mawere)" 16 "Cup" 1 0.25 0.25 0.25
31 "Finger millet (mawere)" 21 "Basin" 1 4.58 3.54 2.5
32 "Sorghum (mapira)" 6 "No.10 Plate" 1 0.16 0.11 0.17 
32 "Sorghum (mapira)" 7 "No.12 Plate" 1 0.21 0.11 0.25 
32 "Sorghum (mapira)" 21 "Basin" 1 2.17 2.17 2.17
33 "Pearl millet (mchewere)" 4 "Pail (small)" 1 3.87 3.87 3.87  
33 "Pearl millet (mchewere)" 14 "Pail (medium)" 1 10.27 10.27 10.27
49 "Cassava tubers" 90 "Piece (small)" 3 0.13 0.18 0.21  
49 "Cassava tubers" 9 "Piece (medium)" 3 0.3 0.32 0.36
49 "Cassava tubers" 91 "Piece (large)" 3 0.46 0.56 0.68 
49 "Cassava tubers" 15 "Heap" 3 0.98 1.2 1.12
203 "White sweet potato" 4 "Pail (small)" 3 4.79 4.79 4.79 
203 "White sweet potato" 14 "Pail (medium)" 3 11.55 11.55 11.55
203 "White sweet potato" 90 "Piece (small)" 3 0.07 0.03 0.1 
203 "White sweet potato" 9 "Piece (medium)" 3 0.15 0.1 0.19
203 "White sweet potato" 91 "Piece (large)" 3 0.34 0.3 0.39
203 "White sweet potato" 150 "Heap (small)" 3 0.7 1.18 0.73
203 "White sweet potato" 15 "Heap" 3 1.11 1.82 1.26  
203 "White sweet potato" 151 "Heap (large)" 3 2.04 2.86 1.71
204 "Orange sweet potato" 90 "Piece (small)" 3 0.04 0.02 0.1 
204 "Orange sweet potato" 9 "Piece (medium)" 3 0.1 0.07 0.21 
204 "Orange sweet potato" 91 "Piece (large)" 3 0.24 0.19 0.41
204 "Orange sweet potato" 150 "Heap (small)" 3 0.73 1.16 0.83
204 "Orange sweet potato" 15 "Heap" 3 1.16 1.99 1.11
204 "Orange sweet potato" 151 "Heap (large)" 3 1.98 3.21 1.72
29 "Irish potato" 4 "Pail (small)" 3 3.01 3.23 4.49 
29 "Irish potato" 14 "Pail (medium)" 3 9.31 8.24 6.71  
29 "Irish potato" 5 "Pail (large)" 3 18.02 19.62 17.36 
20 "Irish potato" 15 "Heap" 3 1.01 0.97 0.87
29 "Irish potato" 21 "Basin" 3 6.65 6.97 5.36
207 "Plantain, cooking banana" 80 "Bunch (small)" 3 1.68 1.55 1.36  
207 "Plantain, cooking banana" 81 "Bunch (large)" 3 9.42 9.42 9.42
207 "Plantain, cooking banana" 9 "Piece" 3 0.12 0.12 0.12
208 "Cocoyam (masimbi)" 9 "Piece" 3 0.74 0.61 0.99
208 "Cocoyam (masimbi)" 15 "Heap" 3 1.25 1.25 1.25
301 "Bean, white" 6 "No.10 Plate" 1 0.13 0.12 0.16 
301 "Bean, white" 7 "No.12 Plate" 1 0.27 0.23 0.3
301 "Bean, white" 16 "Cup" 1 0.48 0.48 0.48
302 "Bean, brown" 6 "No.10 Plate" 1 0.15 0.15 0.15 
302 "Bean, brown" 7 "No.12 Plate" 1 0.24 0.23 0.23
302 "Bean, brown" 16 "Cup" 1 0.31 0.32 0.41
302 "Bean, brown" 21 "Basin" 1 4.09 4.09 4.09
36 "Pigeonpea (nandolo)" 6 "No.10 Plate" 1 0.13 0.13 0.13 
36 "Pigeonpea (nandolo)" 7 "No.12 Plate" 1 0.32 0.32 0.32  
36 "Pigeonpea (nandolo)" 16 "Cup" 1 0.42 0.42 0.42
36 "Pigeonpea (nandolo)" 21 "Basin" 1 7.11 7.11 7.11
16 "Groundnut" 4 "Pail (small)" 1 4.08 4.08 4.08 
16 "Groundnut" 6 "No.10 Plate" 1 0.11 0.11 0.11
16 "Groundnut" 7 "No.12 Plate" 1 0.25 0.17 0.22
16 "Groundnut" 15 "Heap" 1 0.05 0.05 0.05
16 "Groundnut" 16 "Cup" 1 0.31 0.36 0.32
16 "Groundnut" 21 "Basin" 1 0.93 0.93 0.93
27 "Ground bean (nzama)" 6 "No.10 Plate" 1 0.14 0.1 0.15  
27 "Ground bean (nzama)" 7 "No.12 Plate" 1 0.24 0.2 0.18
27 "Ground bean (nzama)" 16 "Cup" 1 0.48 0.48 0.48
308 "Cowpea (khobwe)" 6 "No.10 Plate" 1 0.14 0.12 0.15
308 "Cowpea (khobwe)" 7 "No.12 Plate" 1 0.24 0.24 0.27 
308 "Cowpea (khobwe)" 15 "Heap" 1 0.17 0.17 0.17
308 "Cowpea (khobwe)" 16 "Cup" 1 0.41 0.42 0.39
45 "Onion" 80 "Bunch (small)" 3 0.1 0.14 0.13 
45 "Onion" 8 "Bunch" 3 0.25 0.31 0.29  
45 "Onion" 81 "Bunch (large)" 3 0.46 0.55 0.55
45 "Onion" 90 "Piece (small)" 3 0.04 0.05 0.03
45 "Onion" 9 "Piece" 3 0.06 0.08 0.09 
45 "Onion" 91 "Piece (large)" 3 0.14 0.13 0.14  
45 "Onion" 15 "Heap" 3 0.8 0.8 0.8
40 "Cabbage" 90 "Piece (small)" 3 0.8 1.09 0.86  
40 "Cabbage" 9 "Piece" 3 1.19 1.79 1.22
40 "Cabbage" 91 "Piece (large)" 3 1.95 2.48 1.75
41 "Tanaposi" 80 "Bunch (small)" 3 0.11 0.17 0.16 
41 "Tanaposi" 8 "Bunch" 3 0.35 0.42 0.28  
41 "Tanaposi" 81 "Bunch (large)" 3 0.54 0.55 0.48 
41 "Tanaposi" 15 "Heap" 3 0.35 0.44 0.17
42 "Nkhwani" 8 "Bunch" 3 0.16 0.25 0.27 
42 "Nkhwani" 9 "Piece" 3 0.03 0.03 0.03   
42 "Nkhwani" 150 "Heap (small)" 3 0.14 0.11 0.09
42 "Nkhwani" 15 "Heap" 3 0.4 0.28 0.28 
42 "Nkhwani" 151 "Heap (large)" 3 0.69 0.52 0.66
405 "Chinese cabbage" 8 "Bunch" 3 0.12 0.27 0.25 
405 "Chinese cabbage" 15 "Heap" 3 0.26 0.26 0.27
44 "Tomato" 90 "Piece (small)" 3 0.09 0.08 0.08 
44 "Tomato" 9 "Piece" 3 0.12 0.11 0.12  
44 "Tomato" 91 "Piece (large)" 3 0.17 0.18 0.18
44 "Tomato" 150 "Heap (small)" 3 0.22 0.28 0.28 
44 "Tomato" 15 "Heap" 3 0.44 0.44 0.49  
44 "Tomato" 151 "Heap (large)" 3 0.72 0.68 0.66
44 "Tomato" 21 "Basin" 3 6.16 6.16 6.16
409 "Cucumber" 9 "Piece" 3 0.77 0.47 0.56 
409 "Cucumber" 21 "Basin" 3 0.75 1.22 0.59
410 "Pumpkin" 90 "Piece (small)" 3 1.51 0.96 1.2  
410 "Pumpkin" 9 "Piece" 3 1.94 1.43 1.63
410 "Pumpkin" 91 "Piece (large)" 3 2.57 2.39 2.45
43 "Okra / Therere" 90 "Piece (small)" 3 0.04 0.04 0.04 
43 "Okra / Therere" 9 "Piece" 3 0.08 0.08 0.08
43 "Okra / Therere" 150 "Heap (small)" 3 0.09 0.14 0.13  
43 "Okra / Therere" 15 "Heap" 3 0.11 0.21 0.2
43 "Okra / Therere" 151 "Heap (large)" 3 0.26 0.25 0.32
43 "Okra / Therere" 16 "Cup" 3 0.38 0.38 0.38
52 "Mango" 4 "Pail (small)" 3 3.78 3.78 3.78 
52 "Mango" 8 "Bunch" 3 1.08 1.08 1.08  
52 "Mango" 90 "Piece (small)" 3 0.13 0.11 0.22
end
reshape long cf, i(crop_code unit unit_desc) j(region)
drop unit_desc
drop item_name

*Unit Labels
label define unit_label 1 "Kilogram" 2 "50 kg Bag" 3 "90 kg Bag" 4 "Pail (small)" 5 "Pail (large)" 6 "No. 10 Plate" 7 "No. 12 Plate" 8 "Bunch" 9 "Piece" 10 "Bale" 11 "Basket" 12 "Ox-Cart" 13 "Other (specify)" 14 "Pail (medium)" 15 "Heap" 16 "Cup" 21 "Basin" 80 "Bunch (small)" 81 "Bunch (large)" 90 "Piece (small)" 91 "Piece (large)" 150 "Heap (small)" 151 "Heap (large)", modify
label val unit unit_label

*Crop Code Labels
label define L0C /*these exist already*/ 1 "MAIZE LOCAL" 2 "MAIZE COMPOSITE/OPV" 3 "MAIZE HYBRID" 4 "MAIZE HYBRID RECYCLED" 5 "TOBACCO BURLEY" 6 "TOBACCO FLUE CURED" 7 "TOBACCO NNDF" 8 "TOBACCOSDF" 9 "TOBACCO ORIENTAL" 10 "OTHER TOBACCO (SPECIFY)" 11 "GROUNDNUT CHALIMBANA" 12 "GROUNDNUT CG7" 13 "GROUNDNUT MANIPINTA" 14 "GROUNDNUT MAWANGA" 15 "GROUNDNUT JL24" 16 "OTHER GROUNDNUT(SPECIFY)" 17 "RISE LOCAL" 18 "RISE FAYA" 19 "RISE PUSSA" 20 "RISE TCG10" 21 "RISE IET4094 (SENGA)" 22 "RISE WAMBONE" 23 "RISE KILOMBERO" 24 "RISE ITA" 25 "RISE MTUPATUPA" 26 "OTHER RICE(SPECIFY)"  28 "SWEET POTATO" 29 "IRISH [MALAWI] POTATO" 30 "WHEAT" 34 "BEANS" 35 "SOYABEAN" 36 "PIGEONPEA(NANDOLO" 37 "COTTON" 38 "SUNFLOWER" 39 "SUGAR CANE" 40 "CABBAGE" 41 "TANAPOSI" 42 "NKHWANI" 43 "THERERE/OKRA" 44 "TOMATO" 45 "ONION" 46 "PEA" 47 "PAPRIKA" 48 "OTHER (SPECIFY)" /*cleaning up these existing labels*/ 27 "GROUND BEAN (NZAMA)" 31 "FINGER MILLET (MAWERE)" 32 "SORGHUM" 33 "PEARL MILLET (MCHEWERE)" /*now creating unique codes for tree crops*/ 49 "CASSAVA" 50 "TEA" 51 "COFFEE" 52 "MANGO" 53 "ORANGE" 54 "PAWPAW/PAPAYA" 55 "BANANA" 56 "AVOCADO" 57 "GUAVA" 58 "LEMON" 59 "NAARTJE (TANGERINE)" 60 "PEACH" 61 "POZA (CUSTADE APPLE)" 62 "MASUKU (MEXICAN APPLE)" 63 "MASAU" 64 "PINEAPPLE" 65 "MACADEMIA" /*adding other specified crop codes*/ 105 "MAIZE GREEN" 203 "SWEET POTATO WHITE" 204 "SWEET POTATO ORANGE" 207 "PLANTAIN" 208 "COCOYAM (MASIMBI)" 301 "BEAN, WHITE" 302 "BEAN, BROWN" 308 "COWPEA (KHOBWE)" 405 "CHINESE CABBAGE" 409 "CUCUMBER" 410 "PUMPKIN" 1800 "FODDER TREES" 1900 "FERTILIZER TREES" 2000 "FUEL WOOD TREES", modify
label val crop_code L0C

tempfile food_cf
save `food_cf'

	*********************************
	*      TREE/PERMANENT CROPS     *
	*********************************
use "${Malawi_IHS_W1_raw_data}\ihs_treeconversion_factor_2020.dta", replace
recode crop_code (1=49)(2=50)(3=51)(4=52)(5=53)(6=54)(7=55)(8=56)(9=57)(10=58)(11=59)(12=60)(13=61)(14=62)(15=63)(16=64)(17=65)(18=48) //For W3 and W4 (18=1800)(19=1900)(20=2000)(21=48) //creating unique crop codes for tree and perm crops so that they do not overlap with seasonal crop codes; see value labels added after the append (below)
	label val crop_code crop_code
	ren unit_code unit
	replace unit="80" if strmatch(unit, "8A")
	replace unit="81" if strmatch(unit, "8C")
	replace unit="8" if strmatch(unit, "8B")
	destring unit, replace
	la var unit "Unit of Measurement" //see value labels added after the append (below)
	drop collectionround unit_name
	gen condition=3 //note that raw data for tree/perm NEED to replace condition = N/A in order to match because this variable does not exist in the tree/perm data
	//gen crop_type="permanent/tree"
	tempfile tree_perm_cf
	save `tree_perm_cf'

	*********************************
	*       TEMPORARY CROPS         *
	*********************************
use "${Malawi_IHS_W1_raw_data}/IHS Agricultural Conversion Factor Database.dta", clear
append using `tree_perm_cf'
merge 1:m region crop_code unit condition using `food_cf'
replace conversion=cf if (conversion==. | cf<conversion) & _merge==3 //18 real changes - taking the more conservative conversion factor between files
replace conversion=cf if conversion==. & cf!=. & _merge==2 //323 real changes - creates additional cf observations to match on
drop cf _merge
**ADD VALUE LABELS TO VARIABLES**
	*Region Labels
	label define region_label 1 "North" 2 "Central" 3 "South"
	label val region region_label
	
	*Unit Labels
	label define unit_label 1 "Kilogram" 2 "50 kg Bag" 3 "90 kg Bag" 4 "Pail (small)" 5 "Pail (large)" 6 "No. 10 Plate" 7 "No. 12 Plate" 8 "Bunch" 9 "Piece" 10 "Bale" 11 "Basket" 12 "Ox-Cart" 13 "Other (specify)" 14 "Pail (medium)" 15 "Heap" 16 "Cup" 21 "Basin" 80 "Bunch (small)" 81 "Bunch (large)" 90 "Piece (small)" 91 "Piece (large)" 150 "Heap (small)" 151 "Heap (large)", modify
	label val unit unit_label

	*Crop Code Labels
label define L0C /*these exist already*/ 1 "MAIZE LOCAL" 2 "MAIZE COMPOSITE/OPV" 3 "MAIZE HYBRID" 4 "MAIZE HYBRID RECYCLED" 5 "TOBACCO BURLEY" 6 "TOBACCO FLUE CURED" 7 "TOBACCO NNDF" 8 "TOBACCOSDF" 9 "TOBACCO ORIENTAL" 10 "OTHER TOBACCO (SPECIFY)" 11 "GROUNDNUT CHALIMBANA" 12 "GROUNDNUT CG7" 13 "GROUNDNUT MANIPINTA" 14 "GROUNDNUT MAWANGA" 15 "GROUNDNUT JL24" 16 "OTHER GROUNDNUT(SPECIFY)" 17 "RISE LOCAL" 18 "RISE FAYA" 19 "RISE PUSSA" 20 "RISE TCG10" 21 "RISE IET4094 (SENGA)" 22 "RISE WAMBONE" 23 "RISE KILOMBERO" 24 "RISE ITA" 25 "RISE MTUPATUPA" 26 "OTHER RICE(SPECIFY)"  28 "SWEET POTATO" 29 "IRISH [MALAWI] POTATO" 30 "WHEAT" 34 "BEANS" 35 "SOYABEAN" 36 "PIGEONPEA(NANDOLO" 37 "COTTON" 38 "SUNFLOWER" 39 "SUGAR CANE" 40 "CABBAGE" 41 "TANAPOSI" 42 "NKHWANI" 43 "THERERE/OKRA" 44 "TOMATO" 45 "ONION" 46 "PEA" 47 "PAPRIKA"/*cleaning up these existing labels*/ 27 "GROUND BEAN (NZAMA)" 31 "FINGER MILLET (MAWERE)" 32 "SORGHUM" 33 "PEARL MILLET (MCHEWERE)" /*now creating unique codes for tree crops*/ 49 "CASSAVA" 50 "TEA" 51 "COFFEE" 52 "MANGO" 53 "ORANGE" 54 "PAWPAW/PAPAYA" 55 "BANANA" 56 "AVOCADO" 57 "GUAVA" 58 "LEMON" 59 "NAARTJE (TANGERINE)" 60 "PEACH" 61 "POZA (CUSTADE APPLE)" 62 "MASUKU (MEXICAN APPLE)" 63 "MASAU" 64 "PINEAPPLE" 65 "MACADEMIA" 66 "OTHER (SPECIFY)" /*adding other specified crop codes*/ 105 "MAIZE GREEN" 203 "SWEET POTATO WHITE" 204 "SWEET POTATO ORANGE" 207 "PLANTAIN" 208 "COCOYAM (MASIMBI)" 301 "BEAN, WHITE" 302 "BEAN, BROWN" 308 "COWPEA (KHOBWE)" 405 "CHINESE CABBAGE" 409 "CUCUMBER" 410 "PUMPKIN" 1800 "FODDER TREES" 1900 "FERTILIZER TREES" 2000 "FUEL WOOD TREES", modify 

	*Condition
	lab define condition_label 1 "S: SHELLED" 2 "U: UNSHELLED" 3 "N/A" //CONDITION IS NOT IN THE RAW DATA!!!
	lab val condition condition_label
	
	*Create additional variable to indicate crops where shell_unshelled is not relevant (e.g. cabbage)
	gen shunsh_na = .

	replace shunsh_na = 0 if inlist(crop_code, 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,30,31,32,33,34,35,36,37,38,105,301,302,308)

	replace shunsh_na = 1 if inlist(crop_code, 28,29,39,40,41,42,43,44,45,46,47,49,50,52,53,54,55,56,57,58,59,60,61,62,63,203,204,207,208,405,409,410)

	label define shunsh_na_lab 0 "shell_unshelled is applicable" 1 "shell_unshelled not applicable"
	label values shunsh_na shunsh_na_lab
	label var shunsh_na "Shell_unshelled not applicable"

**BACKFILL MISSING CONVERSION FACTORS**
fillin region crop_code unit condition
recode _fillin (0=1)(1=0)
ren _fillin original

	* Create Generic Crop Code - we do this to help backfill missing data with cfs from other varieties of the same crop
		ren crop_code crop_code_long
		gen crop_code=crop_code_long
		recode crop_code (1 2 3 4=1)(5 6 7 8 9 10=5)(11 12 13 14 15 16=11)(17 18 19 20 21 22 23 24 25 26=17)
		la var crop_code "Generic level crop code"
		label copy L0C L0C_mod //copies the crop_code_long labels for use with crop_code
		label define L0C_mod 1 "MAIZE" 5 "TOBACCO" 11 "GROUNDNUT" 17 "RICE", modify //just need to modify these ones, the others hold
		label val crop_code L0C_mod
		
	* Start with backfilling shell_unshelled - this ratio should be the same regardless of unit, hence the average across crop_code_long
		bysort crop_code_long: egen shell_unshelled_backfill = mean(shell_unshelled)
		replace shell_unshelled=shell_unshelled_backfill if shell_unshelled==. & shunsh_na==0
		//4,437 changes
		drop shell_unshelled_backfill
		
	* Next, we use what we have for shelled to replace unshelled if missing and vice versa
		preserve
		keep if condition==1 & conversion!=. & shunsh_na==0
		replace conversion=conversion*shell_unshelled
		replace condition=2
		ren conversion conversion_shunsh_1
		drop flag original shunsh_na
		tempfile condition_shunsh_1
		save `condition_shunsh_1'
		restore
		
		merge 1:1 region crop_code_long crop_code unit condition shell_unshelled using `condition_shunsh_1', nogen keep(1 3)
		replace conversion=conversion_shunsh_1 if condition==2 & conversion==. & conversion_shunsh_1!=. //114 real changes
		// replace original=0 if condition==2 & conversion==. & conversion_shunsh_1!=. // 0 changes - all are already 0
		drop conversion_shunsh_1
		
		preserve
		keep if condition==2 & conversion!=. & shunsh_na==0
		replace conversion=conversion/shell_unshelled
		replace condition=1
		ren conversion conversion_shunsh_2
		drop flag original shunsh_na
		tempfile condition_shunsh_2
		save `condition_shunsh_2'
		restore
		
		merge 1:1 region crop_code_long crop_code unit condition shell_unshelled using `condition_shunsh_2', nogen keep(1 3)
		replace conversion=conversion_shunsh_2 if condition==1 & conversion==. & conversion_shunsh_2!=. //41 real changes
		//replace original=0 if condition==1 & conversion==. & conversion_shunsh_2!=. // 0 changes - all are already 0
		drop conversion_shunsh_2
		
	*Regions - borrowing conversion factors from other regions
		bysort crop_code_long unit condition: egen region_avg = mean(conversion) 
		replace conversion=region_avg if conversion==. //creates 149 additional observations to merge on
		drop region_avg
		
	*Condition - replaces missing N/A values with unshelled values
		bysort region crop_code_long unit: egen conv_min = min(conversion)
		replace conversion=conv_min if conversion==. & condition==3 //1,026 real changes
		
	*Kilograms
		replace conversion=1 if conversion==. & unit==1 & condition==1 //108 real changes
		replace conversion=1 if conversion==. & unit==1 & condition==3 & shunsh_na==1  //0 real changes

	*Other varieties - borrowing conversion factors from other varieties
		bysort region crop_code unit condition: egen conv_avg_oth_variety = mean(conversion) //note that generic crop code is intentionally used here rather than crop_code_long - looking to take the average cf across varities within the same region unit condition
		replace conversion=conv_avg_oth_variety if conversion==. //135 real changes
		
	*Similar crops - borrowing conversion factors from similar crops
	*Tubers
	preserve
	keep if crop_code_long==28 | crop_code_long==29 | crop_code_long==49
		gen dummy=1 if conversion!=.
		bysort region unit condition: egen count=sum(dummy)
		keep if count==1 | count==2 //keeping only observations for which we have some data to borrow to backfill the others
		bysort region unit condition: egen min_tuber_cf=min(conversion)
		keep if conversion==.
		replace conversion=min_tuber_cf
		tempfile tubers
		save `tubers'
	restore

	drop if (crop_code_long==28 | crop_code_long==29 | crop_code_long==49) & conversion==.
	append using `tubers'

	*Shelled wheat should have a similar bulk density as shelled corn (can also apply to N/A)
	preserve
	keep if crop_code==1 & condition==1 & conversion!=. //intentionally crop_code short to get an average across all maize varieties
		collapse (mean) conversion, by(region crop_code condition unit)
		replace crop_code=30
		gen crop_code_long=30
		gen original=0
		tempfile shelled_wheat
		save `shelled_wheat'
	restore
	
	drop if crop_code_long==30
	append using `shelled_wheat'
	
	* Using the ratio between large pails of tomatos and baskets of tomatos to impute the conversion factor of other crops where we have a conversion factor for large pail in the same region but not baskets.
	preserve
	gen tom_lg_pail=21.65 if region==1
	replace tom_lg_pail=16.41667 if region==2
	replace tom_lg_pail=14.95625 if region==3

	gen tom_basket=11.44333 if region==1
	replace tom_basket=7.831 if region==2
	replace tom_basket=10.552 if region==3

	keep if condition==3 & unit==5 & conversion!=. & original==1 & inlist(crop_code_long, 52, 53, 52, 56, 57, 59, 61, 62) //mango* orange papaya* avocado guava* tangerine custard apple mexican apple
	replace conversion=conversion*tom_basket/tom_lg_pail
	recode unit (5=11)
	recode original (1=0)
	tempfile tom_cf_ratios
	save `tom_cf_ratios'
	restore

	drop if condition==3 & unit==11 & original==0 & conversion==. & inlist(crop_code_long, 52, 53, 52, 56, 57, 59, 61, 62)
	append using `tom_cf_ratios'

	/*
	*Cotton
	/*Assuming 1 bale of cotton lint (shelled) = 800 kgs raw cotton (unshelled) based on a 2003 report from the Regional Agricultural Trade Expansion Support Program available at https://pdf.usaid.gov/pdf_docs/Pnadn345.pdf*/
	replace conversion=800 if crop_code_long==37 & unit==10 & condition==1
	*/

	label val region region_label

	lab define original_lab 0 "Imputed Conversion Factor Using Assumptions" 1 "Original Conversion Factor from the World Bank"
	lab val original original_lab
	lab var original "Meta-deta on conversion factor origin"
	replace original=0 if original==.
	drop if conversion==.
	drop shell_unshelled shunsh_na conv_* dummy count min_tuber_cf tom_*
	order region crop_code_long crop_code unit condition conversion flag original
	save "${Malawi_IHS_W1_created_data}\Malawi_IHS_W1_cf.dta", replace

/* OUTSTANDING NOTES:
- ALT recommended looking at this paper: https://onlinelibrary.wiley.com/doi/10.1002/jid.3054 . After looking, it seems like the author did not do anything to build out conversion factors but rather employed an error components two-stage least squares (EC2SLS) to account for measurment error in their estimation of poverty's effect on maize prices. Not sure this application is relevant here.
- ALT said that "Not Specified" verbiage is preferred and to change this verbiage in the raw conversion factor file. Instead, I would opt for creating a fourth condition to differentiate crops where shell_unshelled is truly not applicable versus not reported.
- Do we want to do something about the fact that conversion factors might be diff for caloric conversion vs. seeds - e.g. conversion factors are only relevent to crops planted-as-harvested. Maybe make an additional variable for this?
- Not sure that I agree that we can use shelled maize conversion factor for na wheat - so I didn't include this.
- Can replace shelled millet cf with what we have for n/a millet?
*/