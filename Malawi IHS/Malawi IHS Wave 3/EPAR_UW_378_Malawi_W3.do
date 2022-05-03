/*
-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of a set of agricultural development indicators 
				  using the Malawi National Panel Survey (TNPS) LSMS-ISA Wave 4 (2014-15)
				  
*Author(s)		: Didier Alia, C. Leigh Anderson, Andrew Tomes, Rebecca Hsu, and Fairooz Newaz

*Acknowledgments: We acknowledge the helpful contributions of members of the World Bank's LSMS-ISA team, the FAO's RuLIS team, IFPRI, IRRI, 
				  and the Bill & Melinda Gates Foundation Agricultural Development Data and Policy team in discussing indicator construction decisions. 
				  We also acknowledge the contributions of former EPAR members Anu Sidhu and Travis Reynolds.
				  All coding errors remain ours alone.
				  
*Date			: 29 April 2022

----------------------------------------------------------------------------------------------------------------------------------------------------*/


*Data source
*-----------
*The Malawi National Panel Survey was collected by the National Statistical Office in Zomba 
*and the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture(LSMS - ISA)
*The data were collected over the period April 2016 - April 2017.
*All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
*http://microdata.worldbank.org/index.php/catalog/2936

*Throughout the do-file, we sometimes use the shorthand LSMS to refer to the Malawi National Panel Survey.

*Summary of Executing the Master do.file
*-----------
*This Master do.file constructs selected indicators using the Malawi LSMS data set.
*Using data files from within the "378 - LSMS Burkina Faso, Malawi, Uganda" folder within the "raw_data" folder, 
*the do.file first constructs common and intermediate variables, saving dta files when appropriate 
*in R:\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave3-2016\code 
*These variables are then brought together at the household, plot, or individual level, saving dta files at each level when available 

 
/*
OUTLINE OF THE DO.FILE
Below are the list of the main files created by running this Master do.file

*INTERMEDIATE FILES					MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD IDS						Malawi_IHS_LSMS_ISA_W3_hhids.dta
*INDIVIDUAL IDS						Malawi_IHS_LSMS_ISA_W3_person_ids.dta
*WEIGHTS  							Malawi_IHS_LSMS_ISA_W3_weights.dta
*HOUSEHOLD SIZE						Malawi_IHS_LSMS_ISA_W3_hhsize.dta

*REACHED BY AG EXTENSION			Malawi_IHS_LSMS_ISA_W3_any_ext.dta
*MOBILE OWNERSHIP                   Malawi_IHS_LSMS_ISA_W2_mobile_own.dta
*USE OF FORMAL FINANACIAL SERVICES	Malawi_IHS_LSMS_ISA_W3_fin_serv.dta

*MILK PRODUCTIVITY					Malawi_IHS_LSMS_ISA_W3_milk_animals.dta

*HOUSEHOLD ASSETS					Malawi_IHS_LSMS_ISA_W3_hh_assets.dta
*/


clear
set more off

clear matrix	
clear mata	
set maxvar 8000		
ssc install findname      //need this user-written ado file for some commands to work_TH
//set directories
*These paths correspond to the folders where the raw data files are located and where the created data and final data will be stored.
global MLW_W3_raw_data 			"\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave3-2016\raw_data"
global MLW_W3_created_data 		"\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave3-2016\temp"
global MLW_W3_final_data  		"\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave3-2016\outputs"


***************************************************************************
*EXCHANGE RATE AND INFLATION FOR CONVERSION IN SUD IDS*
***************************************************************************
global IHS_LSMS_ISA_W3_exchange_rate 2158
global IHS_LSMS_ISA_W3_gdp_ppp_dollar 205.61    // https://data.worldbank.org/indicator/PA.NUS.PPP -2017
global IHS_LSMS_ISA_W3_cons_ppp_dollar 207.24	 // https://data.worldbank.org/indicator/PA.NUS.PRVT.PP - Only 2016 data available 
//global IHS_LSMS_ISA_W3_inflation  // inflation rate 2015-2016. Data was collected during oct2014-2015. We want to adjust the monetary values to 2016

********************************************************************************
*THRESHOLDS FOR WINSORIZATION*
********************************************************************************
global wins_lower_thres 1    						//  Threshold for winzorization at the bottom of the distribution of continous variables
global wins_upper_thres 99							//  Threshold for winzorization at the top of the distribution of continous variables

********************************************************************************
*GLOBALS OF PRIORITY CROPS*
********************************************************************************
*Enter the 12 priority crops here (maize, rice, wheat, sorghum, pearl millet (or just millet if not disaggregated), cowpea, groundnut, common bean, yam, sweet potato, cassava, banana)
*plus any crop in the top ten crops by area planted that is not already included in the priority crops - limit to 6 letters or they will be too long!
*For consistency, add the 12 priority crops in order first, then the additional top ten crops
global topcropname_area "maize rice wheat sorgum pmill cowpea grdnt beans yam swtptt cassav banana cotton sunflr pigpea"
global topcrop_area "11 12 16 13 14 32 43 31 24 22 21 71 50 41 34"
global comma_topcrop_area "11, 12, 16, 13, 14, 32, 43, 31, 24, 22, 21, 71, 50, 41, 34"
global nb_topcrops : list sizeof global(topcropname_area) // Gets the current length of the global macro list "topcropname_area" 
display "$nb_topcrops"

***************************************************************************
*HOUSEHOLD IDS*
***************************************************************************
use "${MLW_W3_raw_data}\hh_mod_a_filt.dta", clear
ren hh_a02a TA // RH added 7/29
rename ea_id ea
rename hh_wgt weight
rename region region
lab var region "1=North, 2=Central, 3=South"
gen rural = (reside==2)
lab var rural "1=Household lives in a rural area"
keep HHID region district TA ea rural weight //RH added TA, removed second "region", stratum not available in w3
save "${MLW_W3_created_data}\Malawi_IHS_LSMS_ISA_W3_hhids.dta", replace

***************************************************************************
*INDIVIDUAL IDS*
***************************************************************************
use "${MLW_W3_raw_data}\hh_mod_b", clear
ren PID personid			//At the individual-level, the IHPS data from 2010, 2013, and 2016 can be merged using the variable PID - will be used later in data
keep HHID personid hh_b03 hh_b05a hh_b04
gen female=hh_b03==2 
lab var female "1= indivdual is female"
gen age=hh_b05a
lab var age "Indivdual age"
gen hh_head=hh_b04 if hh_b04==1
lab var hh_head "1= individual is household head"
drop hh_b03 hh_b05 hh_b04
save "${MLW_W3_created_data}\Malawi_IHS_LSMS_ISA_W3_person_ids.dta", replace

********************************************************************************
*WEIGHTS* 
********************************************************************************
use "${MLW_W3_raw_data}\hh_mod_a_filt.dta", clear
rename hh_a02a TA
rename ea_id ea
rename hh_wgt weight
rename region region
lab var region "1=North, 2=Central, 3=South"
gen rural = (reside==2)
lab var rural "1=Household lives in a rural area"
keep HHID region district TA ea rural weight  
save "${MLW_W3_created_data}\Malawi_IHS_LSMS_ISA_W3_weights.dta", replace

***************************************************************************
*HOUSEHOLD SIZE*
***************************************************************************
//To know the number of hh members and the number of females heads of household
use "${MLW_W3_raw_data}\hh_mod_b", clear
gen hh_members = 1					//Generate this so we can sum later and identify the # of hh members (each memeber gets a HHID so summing will help collapse this to see hh #)
rename hh_b04 relhead 
rename hh_b03 gender
gen fhh = (relhead==1 & gender==2)	//Female heads of households

collapse (sum) hh_members (max) fhh, by (HHID)
lab var hh_members "Number of household members"
lab var fhh "1= Female-headed household"
save "${MLW_W3_created_data}\Malawi_IHS_LSMS_ISA_W3_hhsize.dta", replace

***************************************************************************
*REACHED BY AG EXTENSION*
***************************************************************************
use "${MLW_W3_raw_data}/AG_MOD_T1.dta", clear
ren ag_t01 receive_advice
ren ag_t02 sourceids

**Government Extension
gen advice_gov = (sourceid==1|sourceid==3 & receive_advice==1) // govt ag extension & govt. fishery extension. 
**NGO
gen advice_ngo = (sourceid==4 & receive_advice==1)
**Cooperative/ Farmer Association
gen advice_coop = (sourceid==5 & receive_advice==1) // ag coop/farmers association
**Large Scale Farmer
gen advice_farmer =(sourceid== 10 & receive_advice==1) // lead farmers
**Radio/TV
gen advice_electronicmedia = (sourceid==12 & receive_advice==1) // electronic media:TV/Radio
**Publication
gen advice_pub = (sourceid==13 & receive_advice==1) // handouts, flyers
**Neighbor
gen advice_neigh = (sourceid==11 & receive_advice==1) // Other farmers: neighbors, relatives
** Farmer Field Days
gen advice_ffd = (sourceid==7 & receive_advice==1)
** Village Ag Extension Meeting
gen advice_village = (sourceid==8 & receive_advice==1)
** Ag Ext. Course
gen advice_course= (sourceid==9 & receive_advice==1)
** Private Ag. Extension 
gen advice_pvt= (sourceid==2 & receive_advice==1)
**Other
gen advice_other = (sourceid== 14 & receive_advice==1)

**advice on prices from extension
*Five new variables  ext_reach_all, ext_reach_public, ext_reach_private, ext_reach_unspecified, ext_reach_ict  // QUESTION - ffd and course in unspecified?
gen ext_reach_public=(advice_gov==1)
gen ext_reach_private=(advice_ngo==1 | advice_coop==1 | advice_pvt) //advice_pvt new addition
gen ext_reach_unspecified=(advice_neigh==1 | advice_pub==1 | advice_other==1 | advice_farmer==1 | advice_ffd==1 | advice_course==1 | advice_village==1) 
gen ext_reach_ict=(advice_electronicmedia==1)
gen ext_reach_all=(ext_reach_public==1 | ext_reach_private==1 | ext_reach_unspecified==1 | ext_reach_ict==1)

collapse (max) ext_reach_* , by (HHID)
lab var ext_reach_all "1 = Household reached by extension services - all sources"
lab var ext_reach_public "1 = Household reached by extension services - public sources"
lab var ext_reach_private "1 = Household reached by extension services - private sources"
lab var ext_reach_unspecified "1 = Household reached by extension services - unspecified sources"
lab var ext_reach_ict "1 = Household reached by extension services through ICT"
save "${MLW_W3_created_data}\Malawi_IHS_LSMS_ISA_W3_any_ext.dta", replace

********************************************************************************
*MOBILE OWNERSHIP* 
********************************************************************************
//Added based on TZA w5 code

use "${MLW_W3_raw_data}\HH_MOD_F.dta", clear
//recode missing to 0 in hh_g301 (0 mobile owned if missing)
recode hh_f34 (.=0)
ren hh_f34 hh_number_mobile_owned
*recode hh_number_mobile_owned (.=0) 
gen mobile_owned = 1 if hh_number_mobile_owned>0 
recode mobile_owned (.=0) // recode missing to 0
collapse (max) mobile_owned, by(HHID)
save "${MLW_W3_created_data}\Malawi_IHS_LSMS_ISA_W3_mobile_own.dta", replace
 
***************************************************************************
*USE OF FORMAL FINANCIAL SERVICES* 
***************************************************************************
use "${MLW_W3_raw_data}\HH_MOD_F.dta", clear
append using "${MLW_W3_raw_data}\HH_MOD_S1.dta"
gen borrow_bank= hh_s04==10 // VAP: Code source of loan. No microfinance or mortgage loan in Malawi W2 unlike TZ. 
gen borrow_relative=hh_s04==1|hh_s04==12 //RH Check request: w3 has village bank [12]. Confirm including under "Borrow_bank"?
gen borrow_moneylender=hh_s04==4 // NA in TZ
gen borrow_grocer=hh_s04==3 // local grocery/merchant
gen borrow_relig=hh_s04==6 // religious institution
gen borrow_other_fin=hh_s04==7|hh_s04==8|hh_s04==9 // VAP: MARDEF, MRFC, SACCO
gen borrow_neigh=hh_s04==2
gen borrow_employer=hh_s04==5
gen borrow_ngo=hh_s04==11
gen borrow_other=hh_s04==13

gen use_bank_acount=hh_f52==1
// VAP: No MM for MW2.  
// gen use_MM=hh_q01_1==1 | hh_q01_2==1 | hh_q01_3==1 | hh_q01_4==1 // use any MM services - MPESA ZPESA AIRTEL TIGO PESA. 
gen use_fin_serv_bank = use_bank_acount==1
gen use_fin_serv_credit= borrow_bank==1  | borrow_other_fin==1 // VAP: Include religious institution in this definition? No mortgage.  
// VAP: No digital and insurance in MW2
// gen use_fin_serv_insur= borrow_insurance==1
// gen use_fin_serv_digital=use_MM==1
gen use_fin_serv_others= borrow_other_fin==1
gen use_fin_serv_all=use_fin_serv_bank==1 | use_fin_serv_credit==1 |  use_fin_serv_others==1 /*use_fin_serv_insur==1 | use_fin_serv_digital==1 */ 
recode use_fin_serv* (.=0)

collapse (max) use_fin_serv_*, by (HHID)
lab var use_fin_serv_all "1= Household uses formal financial services - all types"
lab var use_fin_serv_bank "1= Household uses formal financial services - bank account"
lab var use_fin_serv_credit "1= Household uses formal financial services - credit"
// lab var use_fin_serv_insur "1= Household uses formal financial services - insurance"
// lab var use_fin_serv_digital "1= Household uses formal financial services - digital"
lab var use_fin_serv_others "1= Household uses formal financial services - others"
save "${MLW_W3_created_data}\Malawi_IHS_LSMS_ISA_W3_fin_serv.dta", replace	

***************************************************************************
*MILK PRODUCTIVITY*
***************************************************************************
//RH: only cow milk in MWI, not including large ruminant variables

*Total production
use "${MLW_W3_raw_data}\AG_MOD_S.dta", clear
rename ag_s0a product_code
keep if product_code==401
rename ag_s02 months_milked // VAP: During the last 12 months, for how many months did your household produce any [PRODUCT]? (rh edited)
rename ag_s03a liters_month // VAP: During these months, what was the average quantity of [PRODUCT] produced PER MONTH?. (RH renamed to be more consistent with TZA (from qty_milk_per_month to liters_month))
gen milk_liters_produced = months_milked * liters_month if ag_s03b==1 // VAP: Only including liters, not including 2 obsns in "buckets". 
lab var milk_liters_produced "Liters of milk produced in past 12 months"

* lab var milk_animals "Number of large ruminants that was milk (household)": Not available in MW2 (only cow milk) 
lab var months_milked "Average months milked in last year (household)"
drop if milk_liters_produced==.
keep HHID product_code months_milked liters_month milk_liters_produced
save "${MLW_W3_created_data}\Malawi_IHS_LSMS_ISA_W3_milk_animals.dta", replace

***************************************************************************
*HOUSEHOLD ASSETS* 
***************************************************************************
use "${MLW_W3_raw_data}\HH_MOD_L.dta", clear
*ren hh_m03 price_purch  // RH: No price purchased, only total spent on item
ren hh_l05 value_today
ren hh_l04 age_item
ren hh_l03 num_items

collapse (sum) value_assets=value_today, by(HHID)
la var value_assets "Value of household assets"
save "${MLW_W3_created_data}\Malawi_IHS_LSMS_ISA_W3_hh_assets.dta", replace 
