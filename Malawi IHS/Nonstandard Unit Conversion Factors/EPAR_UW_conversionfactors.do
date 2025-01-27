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

********************************************************************************
* CROP UNIT CONVERSION FACTORS *
********************************************************************************
	*********************************
	* FOOD UNIT CONVERSION FACTORS  *
	*********************************
//Malawi_IHS3_Food_Item_Conversion_Factors.pdf
//These are food unit measurement so assuming shelled is the default unless a crop where shell_unshelled not applicable (e.g. cabbage))
clear
input crop_code str40 item_name unit str20 unit_name condition cf1 cf2 cf3  
1 "Maize grain (not as ufa)" 4 "Pail small" 1 4.38 4.47 4.26 //these seem to be shelled based on the small and large pails being close to the shelled values from the other cf factor file
1 "Maize grain (not as ufa)" 14 "Pail medium" 1 9.19 8.41 6.77 
1 "Maize grain (not as ufa)" 5 "Pail large" 1 18.49 16.46 17.6 
1 "Maize grain (not as ufa)" 6 "No.10 Plate" 1 0.2 0.2 0.2
1 "Maize grain (not as ufa)" 7 "No.12 Plate" 1 0.33 0.26 0.37
1 "Maize grain (not as ufa)" 16 "Cup" 1 0.3 0.3 0.3
1 "Maize grain (not as ufa)" 21 "Basin" 1 4.05 4.65 3.67
105 "Green maize" 90 "Piece small" 1 0.24 0.19 0.24  
105 "Green maize" 9 "Piece medium" 1 0.38 0.33 0.34
105 "Green maize" 91 "Piece large" 1 0.53 0.42 0.39
26 "Rice" 4 "Pail small" 1 2.48 2.48 2.48  
26 "Rice" 14 "Pail medium" 1 5.88 5.88 5.88
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
33 "Pearl millet (mchewere)" 4 "Pail small" 1 3.87 3.87 3.87  
33 "Pearl millet (mchewere)" 14 "Pail medium" 1 10.27 10.27 10.27
49 "Cassava tubers" 90 "Piece small" 3 0.13 0.18 0.21  
49 "Cassava tubers" 9 "Piece medium" 3 0.3 0.32 0.36
49 "Cassava tubers" 91 "Piece medium" 3 0.46 0.56 0.68 
49 "Cassava tubers" 15 "Heap" 3 0.98 1.2 1.12
28 "White sweet potato" 4 "Pail small" 3 4.79 4.79 4.79 
28 "White sweet potato" 14 "Pail medium" 3 11.55 11.55 11.55
28 "White sweet potato" 90 "Piece small" 3 0.07 0.03 0.1 
28 "White sweet potato" 9 "Piece medium" 3 0.15 0.1 0.19
28 "White sweet potato" 91 "Piece medium" 3 0.34 0.3 0.39
28 "White sweet potato" 150 "Heap small" 3 0.7 1.18 0.73
28 "White sweet potato" 15 "Heap" 3 1.11 1.82 1.26  
28 "White sweet potato" 151 "Heap medium" 3 2.04 2.86 1.71
28 "Orange sweet potato" 90 "Piece small" 3 0.04 0.02 0.1 
28 "Orange sweet potato" 9 "Piece medium" 3 0.1 0.07 0.21 
28 "Orange sweet potato" 91 "Piece medium" 3 0.24 0.19 0.41
28 "Orange sweet potato" 150 "Heap small" 3 0.73 1.16 0.83
28 "Orange sweet potato" 15 "Heap" 3 1.16 1.99 1.11
28 "Orange sweet potato" 151 "Heap medium" 3 1.98 3.21 1.72
29 "Irish potato" 4 "Pail small" 3 3.01 3.23 4.49 
29 "Irish potato" 14 "Pail medium" 3 9.31 8.24 6.71  
29 "Irish potato" 5 "Pail medium" 3 18.02 19.62 17.36 
29 "Irish potato" 15 "Heap" 3 1.01 0.97 0.87
29 "Irish potato" 21 "Basin" 3 6.65 6.97 5.36
207 "Plantain, cooking banana" 80 "Bunch small" 3 1.68 1.55 1.36  
207 "Plantain, cooking banana" 81 "Bunch medium" 3 9.42 9.42 9.42
207 "Plantain, cooking banana" 9 "Piece" 3 0.12 0.12 0.12
208 "Cocoyam (masimbi)" 9 "Piece" 3 0.74 0.61 0.99
208 "Cocoyam (masimbi)" 15 "Heap" 3 1.25 1.25 1.25
34 "Bean, white" 6 "No.10 Plate" 1 0.13 0.12 0.16 
34 "Bean, white" 7 "No.12 Plate" 1 0.27 0.23 0.3
34 "Bean, white" 16 "Cup" 1 0.48 0.48 0.48
34 "Bean, brown" 6 "No.10 Plate" 1 0.15 0.15 0.15 
34 "Bean, brown" 7 "No.12 Plate" 1 0.24 0.23 0.23
34 "Bean, brown" 16 "Cup" 1 0.31 0.32 0.41
34 "Bean, brown" 21 "Basin" 1 4.09 4.09 4.09
36 "Pigeonpea (nandolo)" 6 "No.10 Plate" 1 0.13 0.13 0.13 
36 "Pigeonpea (nandolo)" 7 "No.12 Plate" 1 0.32 0.32 0.32  
36 "Pigeonpea (nandolo)" 16 "Cup" 1 0.42 0.42 0.42
36 "Pigeonpea (nandolo)" 21 "Basin" 1 7.11 7.11 7.11
16 "Groundnut (shelled)" 4 "Pail small" 1 4.08 4.08 4.08 
16 "Groundnut (shelled)" 6 "No.10 Plate" 1 0.11 0.11 0.11
16 "Groundnut (shelled)" 7 "No.12 Plate" 1 0.25 0.17 0.22
16 "Groundnut (shelled)" 15 "Heap" 1 0.05 0.05 0.05
16 "Groundnut (shelled)" 16 "Cup" 1 0.31 0.36 0.32
16 "Groundnut (shelled)" 21 "Basin" 1 0.93 0.93 0.93
27 "Ground bean (nzama)" 6 "No.10 Plate" 1 0.14 0.1 0.15  
27 "Ground bean (nzama)" 7 "No.12 Plate" 1 0.24 0.2 0.18
27 "Ground bean (nzama)" 16 "Cup" 1 0.48 0.48 0.48
308 "Cowpea (khobwe)" 6 "No.10 Plate" 1 0.14 0.12 0.15
308 "Cowpea (khobwe)" 7 "No.12 Plate" 1 0.24 0.24 0.27 
308 "Cowpea (khobwe)" 15 "Heap" 1 0.17 0.17 0.17
308 "Cowpea (khobwe)" 16 "Cup" 1 0.41 0.42 0.39
45 "Onion" 80 "Bunch small" 3 0.1 0.14 0.13 
45 "Onion" 8 "Bunch" 3 0.25 0.31 0.29  
45 "Onion" 81 "Bunch medium" 3 0.46 0.55 0.55
45 "Onion" 90 "Piece small" 3 0.04 0.05 0.03
45 "Onion" 9 "Piece" 3 0.06 0.08 0.09 
45 "Onion" 91 "Piece medium" 3 0.14 0.13 0.14  
45 "Onion" 15 "Heap" 3 0.8 0.8 0.8
40 "Cabbage" 90 "Piece small" 3 0.8 1.09 0.86  
40 "Cabbage" 9 "Piece" 3 1.19 1.79 1.22
40 "Cabbage" 91 "Piece medium" 3 1.95 2.48 1.75
41 "Tanaposi" 80 "Bunch small" 3 0.11 0.17 0.16  //mustard greens
41 "Tanaposi" 8 "Bunch" 3 0.35 0.42 0.28  
41 "Tanaposi" 81 "Bunch medium" 3 0.54 0.55 0.48 
41 "Tanaposi" 15 "Heap" 3 0.35 0.44 0.17
42 "Nkhwani" 8 "Bunch" 3 0.16 0.25 0.27  //pumpkin leaves
42 "Nkhwani" 9 "Piece" 3 0.03 0.03 0.03   
42 "Nkhwani" 150 "Heap small" 3 0.14 0.11 0.09
42 "Nkhwani" 15 "Heap" 3 0.4 0.28 0.28 
42 "Nkhwani" 151 "Heap medium" 3 0.69 0.52 0.66
405 "Chinese cabbage" 8 "Bunch" 3 0.12 0.27 0.25 
405 "Chinese cabbage" 15 "Heap" 3 0.26 0.26 0.27
44 "Tomato" 90 "Piece small" 3 0.09 0.08 0.08 
44 "Tomato" 9 "Piece" 3 0.12 0.11 0.12  
44 "Tomato" 91 "Piece medium" 3 0.17 0.18 0.18
44 "Tomato" 150 "Heap small" 3 0.22 0.28 0.28 
44 "Tomato" 15 "Heap" 3 0.44 0.44 0.49  
44 "Tomato" 151 "Heap medium" 3 0.72 0.68 0.66
44 "Tomato" 21 "Basin" 3 6.16 6.16 6.16
409 "Cucumber" 9 "Piece" 3 0.77 0.47 0.56 
409 "Cucumber" 21 "Basin" 3 0.75 1.22 0.59
410 "Pumpkin" 90 "Piece small" 3 1.51 0.96 1.2  
410 "Pumpkin" 9 "Piece" 3 1.94 1.43 1.63
410 "Pumpkin" 91 "Piece medium" 3 2.57 2.39 2.45
43 "Okra" 90 "Piece small" 3 0.04 0.04 0.04 
43 "Okra" 9 "Piece" 3 0.08 0.08 0.08
43 "Okra" 150 "Heap small" 3 0.09 0.14 0.13  
43 "Okra" 15 "Heap" 3 0.11 0.21 0.2
43 "Okra" 151 "Heap medium" 3 0.26 0.25 0.32
43 "Okra" 16 "Cup" 3 0.38 0.38 0.38
52 "Mango" 4 "Pail small" 3 3.78 3.78 3.78 
52 "Mango" 8 "Bunch" 3 1.08 1.08 1.08  
52 "Mango" 90 "Piece small" 3 0.13 0.11 0.22
//ALT: Adding additional tobacco varieties for the fillin later: they seem to be missing from the IHS 2020 conversions, so we have to assume that they're the same.
6 "TOBACCO FLUE CURED" 2 "50 kg Bag" 3 20 20 20 //Based on burley tobacco
7 "TOBACCO NNDF" 2 "50 kg Bag" 3 20 20 20 
8 "TOBACCO SDF" 2 "50 kg Bag" 3 20 20 20 
9 "TOBACCO ORIENTAL" 2 "50 kg Bag" 3 20 20 20 
10 "OTHER TOBACCO (SPECIFY)" 2 "50 kg Bag" 3 20 20 20 
end
reshape long cf, i(crop_code unit unit_name item_name condition) j(region)
replace unit_name = strupper(unit_name)
replace item_name = strupper(item_name)
//collapse (mean) cf, by(crop_code unit unit_name item_name condition region) //No real way to distinguish between white and brown beans or white and orange sweet potatoes

*Unit Labels
label define unit_label 1 "Kilogram" 2 "50 kg Bag" 3 "90 kg Bag" 4 "Pail small" 5 "Pail medium" 6 "No. 10 Plate" 7 "No. 12 Plate" 8 "Bunch" 9 "Piece" 10 "Bale" 11 "Basket" 12 "Ox-Cart" 13 "Other (specify)" 14 "Pail medium" 15 "Heap" 16 "Cup" 21 "Basin" 80 "Bunch small" 81 "Bunch medium" 90 "Piece small" 91 "Piece medium" 150 "Heap small" 151 "Heap medium", modify
label val unit unit_label

*Crop Code Labels
label define L0C /*these exist already*/ 1 "MAIZE LOCAL" 2 "MAIZE COMPOSITE/OPV" 3 "MAIZE HYBRID" 4 "MAIZE HYBRID RECYCLED" 5 "TOBACCO BURLEY" 6 "TOBACCO FLUE CURED" 7 "TOBACCO NNDF" 8 "TOBACCO SDF" 9 "TOBACCO ORIENTAL" 10 "OTHER TOBACCO (SPECIFY)" 11 "GROUNDNUT CHALIMBANA" 12 "GROUNDNUT CG7" 13 "GROUNDNUT MANIPINTA" 14 "GROUNDNUT MAWANGA" 15 "GROUNDNUT JL24" 16 "OTHER GROUNDNUT(SPECIFY)" 17 "RISE LOCAL" 18 "RISE FAYA" 19 "RISE PUSSA" 20 "RISE TCG10" 21 "RISE IET4094 (SENGA)" 22 "RISE WAMBONE" 23 "RISE KILOMBERO" 24 "RISE ITA" 25 "RISE MTUPATUPA" 26 "OTHER RICE(SPECIFY)"  28 "SWEET POTATO" 29 "IRISH [MALAWI] POTATO" 30 "WHEAT" 34 "BEANS" 35 "SOYABEAN" 36 "PIGEONPEA(NANDOLO" 37 "COTTON" 38 "SUNFLOWER" 39 "SUGAR CANE" 40 "CABBAGE" 41 "TANAPOSI" 42 "NKHWANI" 43 "THERERE/OKRA" 44 "TOMATO" 45 "ONION" 46 "PEA" 47 "PAPRIKA" 48 "OTHER (SPECIFY)" /*cleaning up these existing labels*/ 27 "GROUND BEAN (NZAMA)" 31 "FINGER MILLET (MAWERE)" 32 "SORGHUM" 33 "PEARL MILLET (MCHEWERE)" /*now creating unique codes for tree crops*/ 49 "CASSAVA" 50 "TEA" 51 "COFFEE" 52 "MANGO" 53 "ORANGE" 54 "PAWPAW/PAPAYA" 55 "BANANA" 56 "AVOCADO" 57 "GUAVA" 58 "LEMON" 59 "NAARTJE (TANGERINE)" 60 "PEACH" 61 "POZA (CUSTADE APPLE)" 62 "MASUKU (MEXICAN APPLE)" 63 "MASAU" 64 "PINEAPPLE" 65 "MACADEMIA" /*adding other specified crop codes*/ 105 "MAIZE GREEN" 203 "SWEET POTATO WHITE" 204 "SWEET POTATO ORANGE" 207 "PLANTAIN" 208 "COCOYAM (MASIMBI)" 301 "BEAN, WHITE" 302 "BEAN, BROWN" 308 "COWPEA (KHOBWE)" 405 "CHINESE CABBAGE" 409 "CUCUMBER" 410 "PUMPKIN" 1800 "FODDER TREES" 1900 "FERTILIZER TREES" 2000 "FUEL WOOD TREES", modify
label val crop_code L0C

tempfile w3food_cf
save `w3food_cf'

keep crop_code item_name 
duplicates drop
tempfile crops
save `crops' //For labelling the W4 food conversions.

use "ihs_foodconversion_factor_2020.dta", clear
ren factor conversion
drop if conversion==0
replace unit_name = "5L BUCKET" if strpos(unit_name, "CHIGOBA") | strpos(unit_name, "Chigoba") | strpos(Otherunit, "5L")
replace unit_code = "26" if strpos(Otherunit, "5L")
replace unit_name = "BASIN SMALL" if strpos(unit_name, "BASIN (SMALL)")
replace unit_name = "PIECE" if unit_name=="PIECE " | strpos(Otherunit, "PIECE")
replace unit_code = "9" if Otherunit=="PIECE"
replace unit_name = "BASIN" if strpos(Otherunit, "BASIN")
replace unit_name = "PAIL SMALL" if Otherunit=="PAIL (SMALL)"
replace unit_name = "PAIL MEDIUM" if Otherunit=="PAIL (MEDIUM)"
replace unit_name = "PAIL LARGE" if Otherunit=="PAIL (LARGE)"
replace item_name = "GROUNDNUT (SHELLED)" if item_name=="GROUND NUT (NUTS)"
replace item_name = "ONION" if item_name=="ONION)"
replace item_name = "PIGEONPEA (NANDOLO)" if item_name=="PIGEONPEA (NANDOLO), FRESH" | item_name=="PIGEON PEA (NANDOLO)"
replace item_name = "TANAPOSI" if strpos(item_name, "TANAPOSI")
replace unit_name = "NO.12 PLATE" if unit_name=="NO. 12 PLATE "
replace unit_name = "NO.12 PLATE" if unit_name=="No 12 PLATE"
replace unit_name = "NO.10 PLATE" if unit_name=="No 10 PLATE"
replace unit_name = "NO.10 PLATE" if unit_name=="NO. 10 PLATE "
replace unit_name = "HEAP" if unit_name=="HEAP "
replace unit_name = "BUNCH LARGE" if unit_name=="CLUSTER LARGE"
replace unit_name = "BUNCH MEDIUM" if unit_name=="CLUSTER MEDIUM"
replace unit_name = "BUNCH SMALL" if unit_name=="CLUSTER SMALL"
replace unit_name = "BASIN  SMALL" if unit_name=="BASIN SMALL"
replace unit_name = "TINA" if unit_name=="TINA "

merge m:1 item_name using `crops', nogen keep(1 3)
//replace unit_code = "15" if unit_code=="151"
//missing crop codes
replace crop_code=57 if item_name=="GUAVA"
replace crop_code=55 if item_name=="BANANA"
replace crop_code=59 if strpos(item_name, "CITRUS")
replace crop_code=54 if item_name=="PAPAYA"
replace crop_code=26 if item_name=="RICE UNSPECIFIED"
replace crop_code=64 if item_name=="PINEAPPLE"
//Remaining units are ambiguous 
drop if unit_code=="23" | crop_code==. //Anything remaining isn't relevant.
//only interested in things that can be compared to crops 
//keep if inlist(item_code, 104, 105, 106, 107, 108, 109, 201, 203, 204, 205,207-304,307,309,3011,313,401-405,408-411,601-609)
duplicates tag region item_name unit_name, g(dups)
drop if dups > 0 & Otherunit=="" //some conflicts based on "other" category, non-"other" units mention low observations so abitrarily keeping them. 
merge 1:m region unit_name item_name using `w3food_cf'
tostring(unit), g(unit2)
replace unit_code = unit2 if unit_code==""
replace unit_code = "15B" if unit_name=="HEAP MEDIUM"
replace unit_code = "15" if unit_name=="HEAP" //For conformity with the w3 units
replace unit_code = "15C" if unit_name=="HEAP LARGE"
replace unit_code = "15A" if unit_name=="HEAP SMALL"
replace unit_code = "4A" if unit_name=="PAIL SMALL"
replace unit_code = "4B" if unit_name=="PAIL MEDIUM"
replace unit_code = "4C" if unit_name=="PAIL LARGE"
replace unit_code = "27" if unit_name== "BASIN"
replace unit_code = "16" if unit_name=="CUP"
replace unit_code = "6" if unit_name=="NO.10 PLATE"
replace unit_code = "7" if unit_name=="NO.12 PLATE"
replace unit_code = "8B" if unit_name=="BUNCH MEDIUM"
replace unit_code = "8A" if unit_name=="BUNCH SMALL"

replace conversion=cf if (conversion==. | cf<conversion) & _merge==3 //18 real changes - taking the more conservative conversion factor between files
replace conversion=cf if conversion==. & cf!=. & _merge==2 //323 real changes - creates additional cf observations to match on
drop cf _merge
replace condition = 3 if inlist(item_code, 602, 402, 208, 302, 203, 408, 602,207, 401, 402,409,601,405,404,411,204,105,606,603,605,410, 205,403) 
replace condition = 1 if inlist(item_code, 104, 301, 106, 108, 301, 308, 307, 311,304,106,109, 107) | inlist(crop_code, 36)
replace condition = 2 if inlist(item_code, 201)

//Note on heaped/flat plates - conversion values are much lower than the observations of plates both within the conversion factors sheet as well as the wave 3 observations - I don't think they're reliable.
drop if strpos(unit_name, "PLATE") & (strpos(unit_name, "HEAPED") | strpos(unit_name, "FLAT"))
/* Original item codes - note that there are more in o/s for W3 and W4. 
           1   Kilogram
           2   50 kg bag
           3   90 kg bag
           4   Pail (small)
           5   Pail (large)
           6   No 10 plate
           7   No 12 plate
           8   Bunch
           9   Piece
          10   Bale
          11   Basket (dengu)
          12   Ox-cart
          13   Other (specify)
		  ------ //Adding
		  25  Tina 
		  26  Chigoba (5 L bucket)
		  45  Pail (size n/s)
		  15A/B/C Heaps 
		  16 Cup
		  27/A/B/C Basins
		  8/A/B/C Bunches 
		  --------- //Coming in on the w4 conversion file. 
		  31 A/B/C bundle 
		  14 Medium pail
		  98 heap
		  
*/

//replace unit_code = "45" if unit_code=="4" | unit_code=="4B" //Adding medium pails here.
replace unit_code = "14" if unit_code=="4" | unit_code=="4B"
replace unit_code = "4" if unit_code=="4A"
replace unit_code = "5" if unit_code=="4C"
replace unit_code = "9" if unit_code=="9B"
//replace unit_code = "8" if unit_code=="8B"


//labmask unit_code, values(unit)
collapse (mean) conversion, by(region crop_code unit_code condition)
gen source = "food_cf"
tempfile food_cf
save `food_cf'

	*********************************
	*      TREE/PERMANENT CROPS     *
	*********************************
use "ihs_treeconversion_factor_2020.dta", clear
recode crop_code (1=49)(2=50)(3=51)(4=52)(5=53)(6=54)(7=55)(8=56)(9=57)(10=58)(11=59)(12=60)(13=61)(14=62)(15=63)(16=64)(17=65)(18=48) //For W3 and W4 (18=1800)(19=1900)(20=2000)(21=48) //creating unique crop codes for tree and perm crops so that they do not overlap with seasonal crop codes; see value labels added after the append (below)
	label val crop_code crop_code
	//ren unit_code unit
	/*
	replace unit="80" if strmatch(unit, "8A")
	replace unit="81" if strmatch(unit, "8C")
	replace unit="8" if strmatch(unit, "8B") //Notably, only "bunch" is reported in tree crops, no size. 
	*/
replace unit_code = "14" if unit_code=="4B"
	//replace unit_code="8" if unit_code=="8B"
	//destring unit, replace
	//la var unit "Unit of Measurement" //see value labels added after the append (below)
	drop collectionround unit_name
	gen condition=3 //note that raw data for tree/perm NEED to replace condition = N/A in order to match because this variable does not exist in the tree/perm data
	//gen crop_type="permanent/tree"
	tempfile tree_perm_cf
	save `tree_perm_cf'

	*********************************
	*       TEMPORARY CROPS         *
	*********************************
use "ihs_seasonalcropconversion_factor_2020.dta", clear
append using `tree_perm_cf'
 //Generic levels because we don't have variety
gen source = "IHS 2020"

**ADD VALUE LABELS TO VARIABLES**
	*Region Labels
	label define region_label 1 "North" 2 "Central" 3 "South"
	label val region region_label
	
	/*Unit Labels
	label define unit_label 1 "Kilogram" 2 "50 kg Bag" 3 "90 kg Bag" 4 "Pail small" 5 "Pail medium" 6 "No. 10 Plate" 7 "No. 12 Plate" 8 "Bunch" 9 "Piece" 10 "Bale" 11 "Basket" 12 "Ox-Cart" 13 "Other (specify)" 14 "Pail medium" 15 "Heap" 16 "Cup" 21 "Basin" 80 "Bunch small" 81 "Bunch medium" 90 "Piece small" 91 "Piece medium" 150 "Heap small" 151 "Heap medium", modify*/
	//label val unit unit_label
	
	replace unit_code = "15" if unit_code=="98"
	*Condition
	lab define condition_label 1 "S: SHELLED" 2 "U: UNSHELLED" 3 "N/A" //CONDITION IS NOT IN THE RAW DATA!!!
	lab val condition condition_label
	
	*Create additional variable to indicate crops where shell_unshelled is not relevant (e.g. cabbage)
	//gen shunsh_na = .

	//replace shunsh_na = 0 if inlist(crop_code, 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,30,31,32,33,34,35,36,37,38,105,301,302,308)

	
	//replace shunsh_na = 1 if inlist(crop_code, 28,29,39,40,41,42,43,44,45,46,47,49,50,52,53,54,55,56,57,58,59,60,61,62,63,203,204,207,208,405,409,410)
	append using `food_cf'
	ren crop_code crop_code_long
		gen crop_code=crop_code_long
		recode crop_code (1 2 3 4=1)(5 6 7 8 9 10=5)(11 12 13 14 15 16=11)(17 18 19 20 21 22 23 24 25 26=17)
	duplicates drop region crop_code_long unit_code condition conversion, force
	//Conflicts between food and ag conversion factors get resolved in favor of the latter.
	duplicates tag region crop_code_long unit_code condition, g(dups)
	drop if dups > 0 & source=="food_cf"
	drop dups
preserve
	drop collectionround unit_name source
	reshape wide conversion, i(region crop_code crop_code_long unit_code) j(condition)
	gen shunsh_ratio = conversion1/conversion2 
	keep if shunsh_ratio != . 
	tempfile ratiosunits
	keep region crop_code crop_code_long unit_code shunsh_ratio
	save `ratiosunits'
	collapse (mean) shunsh_ratio, by(region crop_code unit_code)
	tempfile ratiosshort
	save `ratiosshort'
	collapse (mean) shunsh_ratio, by(crop_code)
	tempfile ratios
	save `ratios'
restore 

fillin region crop_code_long unit_code condition
replace crop_code = crop_code_long if crop_code==.
recode crop_code (1 2 3 4=1)(5 6 7 8 9 10=5)(11 12 13 14 15 16=11)(17 18 19 20 21 22 23 24 25 26=17)
recode _fillin (0=1)(1=0)
ren _fillin original
replace conversion=1 if unit_code=="1" & (condition==1 | condition==3) & conversion==. //Everything 1 here because we want to convert to shelled kilos. 
drop collectionround unit_name
reshape wide conversion source original, i(region crop_code crop_code_long unit_code) j(condition)
merge m:1 region crop_code crop_code_long unit_code using `ratiosunits', nogen 
ren shunsh_ratio shunsh_ratio1
merge m:1 region crop_code unit_code using `ratiosshort', nogen
ren shunsh_ratio shunsh_ratio2
merge m:1 crop_code using `ratios', nogen
ren shunsh_ratio shunsh_ratio3

gen shell_unshelled = shunsh_ratio1 
replace shell_unshelled = shunsh_ratio2 if shell_unshelled==.
replace shell_unshelled = shunsh_ratio3 if shell_unshelled==.
preserve 
keep crop_code unit_code shell_unshelled 
duplicates drop
drop if shell_unshelled==.
//These ratios are similar but not identical, so we'll average them
collapse (mean) shell_unshelled, by(crop_code)
replace shell_unshelled = 1/shell_unshelled //kludge, more intuitive this way: how much shelled crop does the unshelled weight represent?
save "MWI_IHS_shell_unshelled.dta", replace
restore



forvalues k=1/3 { 
bys region crop_code unit_code : egen mean_conv`k' = mean(conversion`k')
bys crop_code unit_code : egen nat_conv`k' = mean(conversion`k')
gen miss_conv`k' = conversion`k'==.
}
replace conversion2 = conversion1/shell_unshelled if conversion2==.
replace source2 = "Shelled/unshelled ratio" if conversion2!=. & miss_conv2==1

replace conversion1 = conversion2*shell_unshelled if conversion1==.
replace source1 = "Shelled/unshelled ratio" if conversion1!=. & miss_conv1==1

replace miss_conv1 = conversion1==.
replace miss_conv2 = conversion2==.
replace conversion1=mean_conv1 if conversion1==.
replace conversion2=mean_conv2 if conversion2==.
replace conversion3=mean_conv3 if conversion3==.
forvalues k=1/3 {
replace source`k' = "Regional mean" if (conversion`k'!=. & miss_conv`k'==1)
}

replace miss_conv1 = conversion1==.
replace miss_conv2 = conversion2==.
replace miss_conv3 = conversion3==.
replace conversion1=nat_conv1 if conversion1==.
replace conversion2=nat_conv2 if conversion2==.
replace conversion3=nat_conv3 if conversion3==.
forvalues k=1/3 {
replace source`k' = "National mean" if (conversion`k'!=. & miss_conv`k'==1)
}
replace conversion2 = conversion1/shell_unshelled if conversion2==.

replace source2 = "Shelled/unshelled ratio" if conversion2!=. & miss_conv2==1

replace conversion1 = conversion2*shell_unshelled if conversion1==.
replace source1 = "Shelled/unshelled ratio" if conversion1!=. & miss_conv1==1


drop shunsh_ratio1-nat_conv3 miss_conv*
reshape long conversion source original, i(region crop_code crop_code_long unit_code) j(condition)

	gen shunsh_na = .
	replace shunsh_na = 1 if inlist(crop_code, 5, 28, 29, 30,31,32,33,38,49,50,52,53,54,55,56,57,58,59,60,61,62,63)
	replace shunsh_na = 0 if inlist(crop_code, 1, 11,17,27,34,35,36,37, 39,41,42,43,44,45,46,47)
	replace shunsh_na = 2 if inlist(crop_code, 48) //All three apply to this crop. 
	
	//replace shunsh_na = 0 if inlist(crop_code, 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,30,31,32,33,34,35,36,37,38,105,301,302,308)
	//replace shunsh_na = 1 if inlist(crop_code, 28,29,39,40,41,42,43,44,45,46,47,49,50,52,53,54,55,56,57,58,59,60,61,62,63,203,204,207,208,405,409,410)
	drop if shunsh_na == 1 & condition != 3
	drop if shunsh_na == 0 & condition == 3 

	bys crop_code unit_code condition : egen conversion_mean = mean(conversion)
	label define shunsh_na_lab 0 "shell_unshelled is applicable" 1 "shell_unshelled not applicable" 2 "shell_unshelled and NA both present"
	label values shunsh_na shunsh_na_lab
	label var shunsh_na "Shell_unshelled not applicable"
	

	*Similar crops - borrowing conversion factors from similar crops
	*Tubers
	gen tuber = crop_code_long==28 | crop_code_long==29 | crop_code_long==49
	preserve
	keep if tuber
		collapse (mean) mean_tuber_cf = conversion (sd) sd_tuber_cf=conversion, by(region unit_code)
		bys unit_code : egen nat_tuber_cf = mean(mean_tuber_cf)
		tempfile tubers
		save `tubers'
	restore

	preserve
	keep if crop_code_long==36
	replace crop_code_long = 46
	keep region unit_code condition crop_code_long conversion
	ren conversion conversion_cowpea
	tempfile cowpeas
	save `cowpeas'
	replace crop_code_long = 35
	tempfile cowpeas_2
	save `cowpeas_2'
	restore
	
	
	
	//drop if (crop_code_long==28 | crop_code_long==29 | crop_code_long==49) & conversion==.
	merge m:1 region unit_code using `tubers', nogen
	gen miss_conv = conversion == .
	replace conversion = mean_tuber_cf if conversion==. & tuber //57 changes
	replace conversion = nat_tuber_cf if conversion ==. & tuber //no changes
	replace source = "mean of tuber crops" if source=="" & conversion!=. & miss_conv
	merge 1:1 region unit_code condition crop_code_long using `cowpeas', nogen
	merge 1:1 region unit_code condition crop_code_long using `cowpeas_2', nogen
	replace conversion = conversion_cowpea if miss_conv & conversion_cowpea!=.
	replace source = "cowpea conversions" if miss_conv & conversion_cowpea!=.
	

	ren unit_code unit
	keep region crop_code_long unit condition conversion source
	drop if conversion==.
	la var source "Source of nonstandard unit conversion factor"
	save "Malawi_IHS_cf.dta", replace
