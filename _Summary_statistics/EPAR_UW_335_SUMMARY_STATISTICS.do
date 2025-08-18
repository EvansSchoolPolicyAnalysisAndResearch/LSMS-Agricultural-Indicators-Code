clear
clear matrix 
clear mata	 
set more off
set maxvar 32767	 
set matsize 10000	 

* Set directories 
global directory "../../_Summary_statistics"

**************
*SUMMARY STATISTICS
************** 
global topcropname_area_yield maize rice wheat sorgum millet /*mill*/ pmill beanc cowpea grdnt beans yam swtptt cassav banana teff barley coffee sesame hsbean nueg cotton sunflr pigpea cocoa soy mangos mungbn avocad potato cashew jute	/* Eventually beanc will replace cowpea
*/ maize_k rice_k wheat_k jute_k maize_r rice_r wheat_r jute_r

global topcropname_area maize rice wheat sorgum millet pmill beanc cowpea grdnt beans yam swtptt cassav banana teff barley coffee sesame hsbean nueg cotton sunflr pigpea cocoa soy mangos mungbn avocad potato cashew jute
 
global gender male female mixed
/*
All the pre-processed files include all households, individuals, and plots in the sample. 
The summary statistics are outputted only for the sub_population of households, individuals, and plots in rural areas. 
To consider a different sub_population or the entire sample, you have to modify the condition "if rural==1".
*/ 

 
foreach instrument of global list_instruments {
	* List of final files to use in the reporting and output file of summary statistics
	global final_data_household  "${`instrument'_final_data}/`instrument'_household_variables.dta"  
	global final_data_individual "${`instrument'_final_data}/`instrument'_individual_variables.dta"
	global final_data_plot       "${`instrument'_final_data}/`instrument'_field_plot_variables.dta"
	*global final_outputfile      "$`instrument'_final_data/`instrument'_summary_stats_`c(current_date)'.xlsx" 
	global final_outputfile      "$`instrument'_final_data/`instrument'_summary_stats.xlsx" 
	
	di "================ PROCESSING `instrument' ================"
	
	*Summary statistics from household-level file
	use "$final_data_household", clear
	//drop *wheat* *beans*
	di "---------------- Summary statistics group 1 ----------------"	
	*Group 1 : All variables that use household weights
	*Convert monetary values to 2016 Purchasing Power Parity international dollars

	global topcrop_monetary=""
	foreach v in $topcropname_area {
		global topcrop_monetary $topcrop_monetary `v'_exp `v'_exp_ha `v'_exp_kg
		
		foreach g in $gender{
			global topcrop_monetary $topcrop_monetary `v'_exp_`g' `v'_exp_ha_`g' `v'_exp_kg_`g'
		}
	}

	global value_harv_vars =""
	foreach v of varlist value_harv* {
		global value_harv_vars $value_harv_vars `v'
	}
	global value_sold_vars =""
	foreach v of varlist value_sold* {
		global value_sold_vars $value_sold_vars `v'
	}

	global monetary_vars crop_income livestock_income nonagwage_income agwage_income self_employment_income transfers_income all_other_income  /*
	*/ percapita_income total_income nonfarm_income farm_income land_productivity labor_productivity /*
	*/ total_cons percapita_cons daily_percap_cons peraeq_cons daily_peraeq_cons /* 
	*/ wage_paid_aglabor wage_paid_aglabor_female wage_paid_aglabor_male fishing_income value_assets /*
	*/ cost_total_ha cost_total_ha_female cost_total_ha_male cost_total_ha_mixed /*
	*/ cost_expli_ha cost_expli_ha_female cost_expli_ha_male cost_expli_ha_mixed /*
	*/ cost_expli_hh cost_expli_hh_ha  /*
	*/ value_crop_production $value_harv_vars $value_sold_vars value_crop_sales value_milk_produced  value_eggs_produced livestock_expenses ls_exp_vac ls_exp_vac_lrum ls_exp_vac_srum ls_exp_vac_poultry /*
	*/ costs_dairy costs_dairy_percow cost_per_lit_milk sales_livestock_products value_livestock_products value_livestock_sales /*
	*/ $topcrop_monetary 

	foreach p of global monetary_vars {
		*Check if the variable exists and if not generate it with values equal to 0  (in the spreadsheet we will remove all rows for whichl all stats are zero
		foreach v in `p' w_`p' {
			capture confirm variable `v' 
			if _rc {
				qui gen `v'=0		
			}
		}
		/* ALT 03.17.23
		qui gen `p'_1ppp = (1+${`instrument'_inflation}) * `p' / ${`instrument'_cons_ppp_dollar} 
		qui gen `p'_2ppp = (1+${`instrument'_inflation}) * `p' / ${`instrument'_gdp_ppp_dollar}
		qui gen `p'_usd = (1+${`instrument'_inflation})  * `p' / ${`instrument'_exchange_rate} 
		qui gen `p'_loc = (1+${`instrument'_inflation})  * `p' 
		qui local l`p' : var lab `p' 
		qui lab var `p'_1ppp "`l`p'' (2016 $ Private Consumption PPP)"
		qui lab var `p'_2ppp "`l`p'' (2016 $ GDP PPP)"
		qui lab var `p'_usd "`l`p'' (2016 $ USD)"
		qui lab var `p'_loc "`l`p'' (2016 LCU)"
		qui lab var `p' "`l`p'' (LCU)"  
		qui gen w_`p'_1ppp = (1+${`instrument'_inflation}) * w_`p' / ${`instrument'_cons_ppp_dollar} 
		qui gen w_`p'_2ppp = (1+${`instrument'_inflation}) * w_`p' / ${`instrument'_gdp_ppp_dollar}
		qui gen w_`p'_usd = (1+${`instrument'_inflation})  * w_`p' / ${`instrument'_exchange_rate} 
		qui gen w_`p'_loc = (1+${`instrument'_inflation})  * w_`p' 
		local lw_`p' : var lab w_`p'
		qui lab var w_`p'_1ppp "`lw_`p'' (2016 $ Private Consumption PPP)"
		qui lab var w_`p'_2ppp "`lw_`p'' (2016 $ GDP PPP)"
		qui lab var w_`p'_usd "`lw_`p'' (2016 $ USD)"
		qui lab var w_`p'_loc "`lw_`p'' (2016 LCU)"
		qui lab var w_`p' "`lw_`p'' (LCU)"
		*/
		qui gen `p'_1ppp = `p' * ccf_1ppp
		qui gen `p'_2ppp =  `p' * ccf_2ppp
		qui gen `p'_usd = `p' * ccf_usd
		qui gen `p'_loc = `p' * ccf_loc
		qui local l`p' : var lab `p' 
		qui lab var `p'_1ppp "`l`p'' (2021 $ Private Consumption PPP)"
		qui lab var `p'_2ppp "`l`p'' (2021 $ GDP PPP)"
		qui lab var `p'_usd "`l`p'' (2021 $ USD)"
		qui lab var `p'_loc "`l`p'' (2021 LCU)"
		qui lab var `p' "`l`p'' (LCU)"  
		qui gen w_`p'_1ppp =  w_`p' * ccf_1ppp 
		qui gen w_`p'_2ppp =  w_`p' * ccf_1ppp 
		qui gen w_`p'_usd =  w_`p' * ccf_usd
		qui gen w_`p'_loc = w_`p' * ccf_loc 
		local lw_`p' : var lab w_`p'
		qui lab var w_`p'_1ppp "`lw_`p'' (2021 $ Private Consumption PPP)"
		qui lab var w_`p'_2ppp "`lw_`p'' (2021 $ GDP PPP)"
		qui lab var w_`p'_usd "`lw_`p'' (2021 $ USD)"
		qui lab var w_`p'_loc "`lw_`p'' (2021 LCU)"
		qui lab var w_`p' "`lw_`p'' (LCU)"
	}

	*Disagregate total income and per_capita income by farm type
	global vars_by_farmtype  /*
	*/ w_share_crop w_total_income_1ppp w_percapita_income_1ppp w_crop_income_1ppp w_cost_expli_hh_1ppp  w_daily_percap_cons_1ppp w_daily_peraeq_cons_1ppp /*
	*/ w_total_income_2ppp w_percapita_income_2ppp w_crop_income_2ppp w_cost_expli_hh_2ppp  w_daily_percap_cons_2ppp w_daily_peraeq_cons_2ppp /*
	*/ w_total_income_loc w_percapita_income_loc w_crop_income_loc w_cost_expli_hh_loc w_daily_percap_cons_loc w_daily_peraeq_cons_loc /*
	*/ encs num_crops_hh multiple_crops 
	
	foreach v of global vars_by_farmtype {
		*Check if the variable exists and if not generate it with values equal to 0
		capture confirm variable `v' 
		if _rc {
			qui gen `v'=0
		}
		qui gen `v'0Ha=`v' if farm_size_0_0==1
		qui gen `v'01Ha=`v' if farm_size_0_1==1
		qui gen `v'12Ha=`v' if farm_size_1_2==1
		qui gen `v'24Ha=`v' if farm_size_2_4==1
		qui gen `v'4Ha_=`v' if farm_size_4_more==1
		local l`v' : var lab `v'
		qui lab var `v'0Ha "`l`v'' - HH with no farm"
		qui lab var `v'01Ha "`l`v'' - HH with farm size [0-1 Ha]"
		qui lab var `v'12Ha "`l`v'' - HH with farm size [1-2 Ha]"
		qui lab var `v'24Ha "`l`v'' - HH with farm size ]2-h Ha]"
		qui lab var `v'4Ha_ "`l`v'' - HH with farm size ]4 ha and more"
		
		*DYA 12.19.19  adding income per-capita for household with 0-4ha
		gen `v'04Ha=`v' if farm_size_0_1==1 | farm_size_1_2==1 | farm_size_2_4==1
		gen `v'02Ha=`v' if farm_size_0_1==1 | farm_size_1_2==1 
	}
	
	*Generating farm size variables by crop
	foreach v in $topcropname_area {
		capture confirm variable grew_`v'
		if _rc {
			qui gen grew_`v'=0
		}
		qui gen grew_`v'00Ha=grew_`v' if farm_size_0_0==1
		qui gen grew_`v'01Ha=grew_`v' if farm_size_0_1==1
		qui gen grew_`v'12Ha=grew_`v' if farm_size_1_2==1
		qui gen grew_`v'24Ha=grew_`v' if farm_size_2_4==1
		qui gen grew_`v'4Ha=grew_`v' if farm_size_4_more==1
		
		qui gen grew_`v'04Ha=grew_`v' if farm_size_0_1==1 | farm_size_1_2==1 | farm_size_2_4==1
		qui gen grew_`v'02Ha=grew_`v' if farm_size_0_1==1 | farm_size_1_2==1
		
	}

	*renaming variables with names that are too long
	foreach i in 1ppp 2ppp loc {
		capture confirm variable w_fishing_income_`i'
		if _rc {
			qui gen w_fishing_income_`i'=0
		}	
		rename w_livestock_income_`i' w_lvstck_income_`i'
		rename w_fishing_income_`i' w_fish_income_`i'
		rename w_self_employment_income_`i' w_self_emp_income_`i'
	}

	*Crop income, livestock income, fishing income, livestock_holding, are reported for 2 different subpopulation : all rural HH and rural HH engaged in the specific activities
	foreach v of varlist w_crop_income*ppp* w_crop_income*loc* w_share_crop* {
		capture confirm variable `v'
		if _rc {
			qui gen `v'=0
		}	
		local l`v' : var lab `v' 
		qui gen `v'4crop1=`v' if crop_hh==1
		qui lab var `v'4crop1 "`l`v'' - only for crop producing household"
	}
	foreach v of varlist w_lvstck_income_1ppp w_lvstck_income_2ppp w_lvstck_income_loc w_share_livestock lvstck_holding* {
		capture confirm variable `v'
		if _rc {
			qui gen `v'=0
		}		
		local l`v' : var lab `v' 
		qui gen `v'4ls_hh=`v' if livestock_hh==1
		qui lab var `v'4ls_hh "`l`v'' - only for livestock producing household"
	}
	foreach v in  w_fish_income_1ppp w_fish_income_2ppp w_fish_income_loc w_share_fishing {
		capture confirm variable `v'
		if _rc {
			qui gen `v'=0
		}	
		local l`v' : var lab `v' 
		qui gen `v'4fish_hh=`v' if fishing_hh==1
		qui lab var `v'4fish_hh "`l`v'' - only for household with fishing income"
	}

	
	global household_vars1 /*
	*/ w_total_income_1ppp w_total_income_1ppp0Ha w_total_income_1ppp01Ha w_total_income_1ppp12Ha w_total_income_1ppp24Ha w_total_income_1ppp4Ha_ w_total_income_1ppp02Ha w_total_income_1ppp04Ha  /*
	*/ w_total_income_2ppp w_total_income_2ppp0Ha w_total_income_2ppp01Ha w_total_income_2ppp12Ha w_total_income_2ppp24Ha w_total_income_2ppp4Ha_ w_total_income_2ppp02Ha w_total_income_2ppp04Ha   /*
	*/ w_total_income_loc w_total_income_loc0Ha w_total_income_loc01Ha w_total_income_loc12Ha w_total_income_loc24Ha w_total_income_loc4Ha_  w_total_income_loc02Ha w_total_income_loc04Ha  /*
	*/ w_percapita_income_1ppp w_percapita_income_1ppp0Ha w_percapita_income_1ppp01Ha w_percapita_income_1ppp12Ha w_percapita_income_1ppp24Ha w_percapita_income_1ppp4Ha_ w_percapita_income_1ppp02Ha w_percapita_income_1ppp04Ha /*
	*/ w_percapita_income_2ppp w_percapita_income_2ppp0Ha w_percapita_income_2ppp01Ha w_percapita_income_2ppp12Ha w_percapita_income_2ppp24Ha w_percapita_income_2ppp4Ha_ w_percapita_income_2ppp02Ha w_percapita_income_2ppp04Ha  /*
	*/ w_percapita_income_loc w_percapita_income_loc0Ha w_percapita_income_loc01Ha w_percapita_income_loc12Ha w_percapita_income_loc24Ha w_percapita_income_loc4Ha_  w_percapita_income_loc02Ha w_percapita_income_loc04Ha  /*
	*/ w_percapita_cons_1ppp w_percapita_cons_2ppp w_percapita_cons_loc /* 
	*/ w_daily_percap_cons_1ppp w_daily_percap_cons_1ppp0Ha w_daily_percap_cons_1ppp01Ha w_daily_percap_cons_1ppp12Ha w_daily_percap_cons_1ppp24Ha w_daily_percap_cons_1ppp4Ha_ w_daily_percap_cons_1ppp02Ha w_daily_percap_cons_1ppp04Ha /*
	*/ w_daily_percap_cons_2ppp w_daily_percap_cons_2ppp0Ha w_daily_percap_cons_2ppp01Ha w_daily_percap_cons_2ppp12Ha w_daily_percap_cons_2ppp24Ha w_daily_percap_cons_2ppp4Ha_  w_daily_percap_cons_2ppp02Ha w_daily_percap_cons_2ppp04Ha  /*
	*/ w_daily_percap_cons_loc w_daily_percap_cons_loc0Ha w_daily_percap_cons_loc01Ha w_daily_percap_cons_loc12Ha w_daily_percap_cons_loc24Ha w_daily_percap_cons_loc4Ha_  w_daily_percap_cons_loc02Ha w_daily_percap_cons_loc04Ha  /*
	*/ w_peraeq_cons_1ppp w_peraeq_cons_2ppp w_peraeq_cons_loc /*
	*/ w_daily_peraeq_cons_1ppp w_daily_peraeq_cons_1ppp0Ha w_daily_peraeq_cons_1ppp01Ha w_daily_peraeq_cons_1ppp12Ha w_daily_peraeq_cons_1ppp24Ha w_daily_peraeq_cons_1ppp4Ha_ w_daily_peraeq_cons_1ppp02Ha w_daily_peraeq_cons_1ppp04Ha /*
	*/ w_daily_peraeq_cons_2ppp w_daily_peraeq_cons_2ppp0Ha w_daily_peraeq_cons_2ppp01Ha w_daily_peraeq_cons_2ppp12Ha w_daily_peraeq_cons_2ppp24Ha w_daily_peraeq_cons_2ppp4Ha_ w_daily_peraeq_cons_2ppp02Ha w_daily_peraeq_cons_2ppp04Ha /*
	*/ w_daily_peraeq_cons_loc w_daily_peraeq_cons_loc0Ha w_daily_peraeq_cons_loc01Ha w_daily_peraeq_cons_loc12Ha w_daily_peraeq_cons_loc24Ha w_daily_peraeq_cons_loc4Ha_ w_daily_peraeq_cons_loc02Ha w_daily_peraeq_cons_loc04Ha /*
	*/ w_crop_income_1ppp w_crop_income_1ppp01Ha w_crop_income_1ppp12Ha w_crop_income_1ppp24Ha w_crop_income_1ppp4Ha_ w_crop_income_1ppp02Ha w_crop_income_1ppp04Ha /*
	*/ w_crop_income_1ppp4crop1 w_crop_income_1ppp01Ha4crop1 w_crop_income_1ppp12Ha4crop1 w_crop_income_1ppp24Ha4crop1 w_crop_income_1ppp4Ha_4crop1 w_crop_income_1ppp02Ha4crop1 w_crop_income_1ppp04Ha4crop1 /*
	*/ w_crop_income_2ppp w_crop_income_2ppp01Ha w_crop_income_2ppp12Ha w_crop_income_2ppp24Ha w_crop_income_2ppp4Ha_  w_crop_income_2ppp02Ha w_crop_income_2ppp04Ha   /*
	*/ w_crop_income_2ppp4crop1 w_crop_income_2ppp01Ha4crop1 w_crop_income_2ppp12Ha4crop1 w_crop_income_2ppp24Ha4crop1 w_crop_income_2ppp4Ha_4crop1  w_crop_income_2ppp02Ha4crop1 w_crop_income_2ppp04Ha4crop1  /*
	*/ w_crop_income_loc w_crop_income_loc01Ha w_crop_income_loc12Ha w_crop_income_loc24Ha w_crop_income_loc4Ha_  w_crop_income_loc02Ha w_crop_income_loc04Ha  /*
	*/ w_crop_income_loc4crop1 w_crop_income_loc01Ha4crop1 w_crop_income_loc12Ha4crop1 w_crop_income_loc24Ha4crop1 w_crop_income_loc4Ha_4crop1   w_crop_income_loc02Ha4crop1 w_crop_income_loc04Ha4crop1 /*
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
	/*adding farm income */ 	*/ w_farm_income_1ppp w_farm_income_2ppp w_farm_income_loc/*
	*/ w_share_crop w_share_crop01Ha w_share_crop12Ha w_share_crop24Ha w_share_crop4Ha_ w_share_crop02Ha w_share_crop04Ha /*
	*/ w_share_crop4crop1 w_share_crop01Ha4crop1 w_share_crop12Ha4crop1 w_share_crop24Ha4crop1 w_share_crop4Ha_4crop1 w_share_crop02Ha4crop1 w_share_crop04Ha4crop1 /*
	*/ w_share_livestock w_share_livestock4ls_hh w_share_fishing w_share_fishing4fish_hh w_share_nonagwage w_share_agwage w_share_self_employment w_share_transfers w_share_all_other w_share_nonfarm /*
	*/ w_proportion_cropvalue_sold w_farm_size_agland hh_members adulteq w_labor_family w_labor_hired /*
	*/ use_inorg_fert vac_animal vac_animal_lrum vac_animal_srum vac_animal_poultry /*
	*/ feed_grazing feed_grazing_lrum feed_grazing_srum feed_grazing_poultry /*
	*/ water_source_nat water_source_const water_source_cover /*
	*/ water_source_nat_lrum water_source_const_lrum water_source_cover_lrum /*
	*/ water_source_nat_srum water_source_const_srum water_source_cover_srum /*
	*/ water_source_nat_poultry water_source_const_poultry water_source_cover_poultry /*
	*/ lvstck_housed lvstck_housed_lrum lvstck_housed_srum lvstck_housed_poultry /*
	*/ ext_reach_all ext_reach_public ext_reach_private ext_reach_unspecified ext_reach_ict /*
	*/ use_fin_serv_bank use_fin_serv_credit use_fin_serv_insur use_fin_serv_digital use_fin_serv_others use_fin_serv_all /* 
	*/ lvstck_holding_tlu lvstck_holding_tlu4ls_hh lvstck_holding_all lvstck_holding_all4ls_hh   /*
	*/ lvstck_holding_lrum lvstck_holding_lrum4ls_hh lvstck_holding_srum lvstck_holding_srum4ls_hh  lvstck_holding_poultry lvstck_holding_poultry4ls_hh /*
	*/ w_mortality_rate_lrum w_mortality_rate_srum w_mortality_rate_poultry /*
	*/ w_lost_disease_lrum w_lost_disease_srum w_lost_disease_poultry /* 
	*/ disease_animal disease_animal_lrum disease_animal_srum disease_animal_poultry /*
	*/ any_imp_herd_all any_imp_herd_lrum any_imp_herd_srum any_imp_herd_poultry share_imp_dairy /*
	*/ w_share_livestock_prod_sold formal_land_rights_hh w_livestock_expenses_1ppp w_livestock_expenses_2ppp w_livestock_expenses_loc /*
	*/ w_ls_exp_vac_1ppp w_ls_exp_vac_2ppp w_ls_exp_vac_loc /*
	*/ w_ls_exp_vac_lrum_1ppp w_ls_exp_vac_lrum_2ppp w_ls_exp_vac_lrum_loc /*
	*/ w_ls_exp_vac_srum_1ppp w_ls_exp_vac_srum_2ppp w_ls_exp_vac_srum_loc /* 
	*/ w_ls_exp_vac_poultry_1ppp w_ls_exp_vac_poultry_2ppp w_ls_exp_vac_poultry_loc/*
	*/ w_prop_farm_prod_sold /*
	*/ w_off_farm_hours_pc_all w_off_farm_hours_pc_any /*
	*/ months_food_insec w_value_assets_1ppp w_value_assets_2ppp w_value_assets_loc /*
	*/ hhs_little hhs_moderate hhs_severe hhs_total w_dist_agrodealer /*
	*/ encs encs0Ha encs01Ha encs12Ha encs24Ha encs4Ha_ num_crops_hh num_crops_hh0Ha num_crops_hh01Ha num_crops_hh12Ha num_crops_hh24Ha num_crops_hh4Ha_ num_crops_hh02Ha num_crops_hh04Ha/*
	*/ multiple_crops multiple_crops0Ha multiple_crops01Ha multiple_crops12Ha multiple_crops24Ha multiple_crops4Ha_ multiple_crops02Ha multiple_crops04Ha/*
	*/ imprv_seed_use

	foreach cn in $topcropname_area {
		*Check if the variable exists and if not generate it with values equal to 0
		foreach v in imprv_seed hybrid_seed {
			capture confirm variable `v'_`cn'
			if _rc {
				qui gen `v'_`cn'=0
			}
		}
		global household_vars1 $household_vars1 imprv_seed_`cn' hybrid_seed_`cn' 
	}

	global final_indicator1 ""
	foreach v of global household_vars1 {
		capture confirm variable `v'
		if _rc {
			qui gen `v'=0
		}
		local l`v' : var lab `v' 
		qui gen `v'_fhh=`v' if fhh==1
		qui lab var `v'_fhh "`l`v'' - FHH"
		qui gen `v'_mhh=`v' if fhh==0
		qui lab var `v'_mhh "`l`v'' - MHH"
		global final_indicator1 $final_indicator1 `v'  `v'_fhh  `v'_mhh
	}

	qui tabstat ${final_indicator1} [aw=weight] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
	matrix final_indicator1=r(StatTotal)'

	qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered) // get standard errors of the mean
	matrix semean1=(.)
	matrix colnames semean1=semean_wei
	foreach v of global final_indicator1 {
		local missing_var ""
		qui findname `v' if rural==1,  all(@==.) local (missing_var)
		if "`missing_var'"!="" { 
			qui replace `v'=0
		}	
		qui svy, subpop(if rural==1): mean `v'
		matrix semean1=semean1\(el(r(table),2,1))
	}
	matrix final_indicator1=final_indicator1,semean1[2..rowsof(semean1),.]
	matrix list final_indicator1

	di "---------------- Summary statistics group 2 ----------------"
	*Group 2: labor_productivity_ppp and land_productivity_ppp at the household level
	matrix final_indicator2=(.,.,.,.,.,.,.,.,.)
	matrix final_indicator2a=(.,.,.,.,.,.,.,.,.)
	global household_indicators2a  w_labor_productivity_1ppp w_labor_productivity_2ppp w_labor_productivity_loc

	foreach v of global household_indicators2a {
		capture confirm variable `v'
		if _rc {
			qui gen `v'=0
		}
		global final_indicator2a ""	
		local l`v' : var lab `v' 
		qui gen `v'_fhh=`v' if fhh==1
		qui lab var `v'_fhh "`l`v'' - FHH"
		qui gen `v'_mhh= `v' if fhh==0
		qui lab var `v'_mhh "`l`v'' - MHH"
		global final_indicator2a $final_indicator2a `v' `v'_fhh  `v'_mhh
		qui tabstat $final_indicator2a [aw=w_labor_weight] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
		matrix temp2=r(StatTotal)'	
		qui svyset clusterid [pweight=w_labor_weight], strata(strataid) singleunit(centered) // get standard errors of the mean
		matrix semean2=(.)
		matrix colnames semean2=semean_wei
		foreach v of global final_indicator2a {
			local missing_var ""
			qui findname `v',  all(@==.) local (missing_var)
			if "`missing_var'"!="" { 
				qui replace `v'=0
			}	
			qui svy, subpop(if rural==1): mean `v' 
			matrix semean2=semean2\(el(r(table),2,1))
		}
		matrix temp2=temp2,semean2[2..rowsof(semean2),.]
		matrix final_indicator2a=final_indicator2a\temp2
	}	

	matrix final_indicator2b=(.,.,.,.,.,.,.,.,.)
	global household_indicators2b w_land_productivity_1ppp w_land_productivity_2ppp w_land_productivity_loc
	foreach v of global household_indicators2b {
		capture confirm variable `v'
		if _rc {
			qui gen `v'=.
		}
		global final_indicator2b ""	
		local l`v' : var lab `v' 
		qui gen `v'_fhh=`v' if fhh==1
		qui lab var `v'_fhh "`l`v'' - FHH"
		qui gen `v'_mhh= `v' if fhh==0
		qui lab var `v'_mhh "`l`v'' - MHH"
		global final_indicator2b $final_indicator2b `v' `v'_fhh  `v'_mhh
		qui tabstat $final_indicator2b [aw=w_land_weight] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
		matrix temp2=r(StatTotal)'	
		qui svyset clusterid [pweight=w_land_weight], strata(strataid) singleunit(centered) // get standard errors of the mean
		matrix semean2=(.)
		matrix colnames semean2=semean_wei
		foreach v of global final_indicator2b {
			local missing_var ""
			qui findname `v' if rural==1,  all(@==.) local (missing_var)
			if "`missing_var'"!="" { 
			qui replace `v'=0
		}	
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

	di "---------------- Summary statistics group 3 ----------------"
	*Group 3 : daily wage in  agriculture
	capture confirm var wage_paid_aglabor 
	if _rc {
		gen wage_paid_aglabor=0
		gen w_wage_paid_aglabor=0
	}
	capture confirm var wage_paid_aglabor_all 
	if _rc {
		gen wage_paid_aglabor_all = wage_paid_aglabor
		gen w_wage_paid_aglabor_all = w_wage_paid_aglabor
	}
	foreach v in 1ppp 2ppp loc {
		capture confirm variable w_wage_paid_aglabor_`v'
		if _rc {
			capture confirm variable w_wage_paid_aglabor
			if !_rc {
				qui gen w_wage_paid_aglabor_`v' = w_wage_paid_aglabor * ccf_`v'
			} 
			else {
				qui gen w_wage_paid_aglabor_`v'=0
			}
		}
	} 
	/*
	foreach v in w_wage_paid_aglabor_1ppp w_wage_paid_aglabor_2ppp w_wage_paid_aglabor_loc {
		capture confirm variable `v'
		if _rc {
			qui gen `v'=0
		}	
	}
	*/
	ren w_wage_paid_aglabor_1ppp w_wage_paid_aglabor_all_1ppp
	ren w_wage_paid_aglabor_2ppp w_wage_paid_aglabor_all_2ppp
	ren w_wage_paid_aglabor_loc w_wage_paid_aglabor_all_loc

	foreach g in all female male {
		capture confirm variable w_aglabor_weight_`g'
		if _rc {
			qui gen w_aglabor_weight_`g'=1
		}		
		local missing_var ""
		qui findname w_aglabor_weight_`g',  all(@==.) local (missing_var)
		if "`missing_var'"!="" { 
			qui replace w_aglabor_weight_`g'=1
		}
	}
	

	global final_indicator3a "all female male"
	matrix final_indicator3a=(.,.,.,.,.,.,.,.,.)
	foreach i in 1ppp 2ppp loc {
		foreach v of global final_indicator3a {
			capture confirm variable w_wage_paid_aglabor_`v'_`i'
			if _rc {
				capture confirm variable w_wage_paid_aglabor_`v'
				if !_rc {
					qui gen w_wage_paid_aglabor_`v'_`i' = w_wage_paid_aglabor_`v' * ccf_`i'
				}
				else {
				qui gen w_wage_paid_aglabor_`v'_`i'=0
				}
			}	
			local missing_var "" 
			qui findname w_wage_paid_aglabor_`v'_`i', all (@==.) local (missing_var)
			if "`missing_var'"!="" { 
				qui replace w_wage_paid_aglabor_`v'_`i'=0
			}
			qui tabstat w_wage_paid_aglabor_`v'_`i' [aw=w_aglabor_weight_`v'] if rural==1, stat(mean  sd p25 p50 p75  min max N) col(stat) save
			matrix temp4=r(StatTotal)'
			qui svyset clusterid [pweight=w_aglabor_weight_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean	
			qui svy, subpop(if rural==1): mean w_wage_paid_aglabor_`v'_`i'
			matrix final_indicator3a=final_indicator3a\(temp4,el(r(table),2,1))
		}
	}
	matrix final_indicator3 =final_indicator3a[2..rowsof(final_indicator3a), .]
	matrix list final_indicator3
	di "---------------- Summary statistics group 4 ----------------"
	** Group 4  - yields 
	global final_indicator4=""
	foreach v in $topcropname_area_yield {
		global final_indicator4 $final_indicator4 `v' female_`v' male_`v' mixed_`v'
	}
	foreach v in $topcropname_area_yield {
		global final_indicator4 $final_indicator4 pure_`v' pure_female_`v' pure_male_`v' pure_mixed_`v' 
	}

	matrix final_indicator4a=(.,.,.,.,.,.,.,.,.)
	foreach v of global final_indicator4 {
		capture confirm variable ar_h_wgt_`v'
		if _rc {
			qui gen ar_h_wgt_`v'=1
		}
		capture confirm variable w_yield_hv_`v'
		if _rc {
			qui gen w_yield_hv_`v'=0
		}
		local missing_var ""
		qui recode ar_h_wgt_* (0=.)
		qui findname ar_h_wgt_`v' if rural==1,  all(@==.) local (missing_var)
		if "`missing_var'"!="" { 
			qui replace ar_h_wgt_`v'=1
		}
		qui tabstat w_yield_hv_`v' [aw=ar_h_wgt_`v'] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
		matrix temp4=r(StatTotal)'
		local missing_var ""
		qui findname w_yield_hv_`v' if rural==1,  all(@==.) local (missing_var)
		if "`missing_var'"!="" { 
			qui replace w_yield_hv_`v'=0		
		}
		qui svyset clusterid [pweight=ar_h_wgt_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean	
		capture qui svy, subpop(if rural==1): mean w_yield_hv_`v'
		if !_rc {
		matrix final_indicator4a=final_indicator4a\(temp4,el(r(table),2,1))	
		}
		else {
			matrix final_indicator4a=final_indicator4a\(temp4,(.))
		}
	}
 
	matrix final_indicator4b=(.,.,.,.,.,.,.,.,.)
	foreach v of global final_indicator4 {
		capture confirm variable ar_pl_wgt_`v'
		if _rc {
			qui gen ar_pl_wgt_`v'=1
		}
		capture confirm variable w_yield_pl_`v'
		if _rc {
			qui gen w_yield_pl_`v'=.
		}
		local missing_var ""
		qui findname ar_pl_wgt_`v' if rural==1,  all(@==.) local (missing_var)
		if "`missing_var'"!="" { 
			qui replace ar_pl_wgt_`v'=1
		}
		qui tabstat w_yield_pl_`v' [aw=ar_pl_wgt_`v'] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
		matrix temp4=r(StatTotal)'
		local missing_var ""
		qui findname w_yield_pl_`v' if rural==1,  all(@==.) local (missing_var)
		if "`missing_var'"!="" { 
			qui replace w_yield_pl_`v'=0
		}
		qui svyset clusterid [pweight=ar_pl_wgt_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean	
		qui svy, subpop(if rural==1): mean w_yield_pl_`v'
		matrix final_indicator4b=final_indicator4b\(temp4,el(r(table),2,1))	
	}
	matrix final_indicator4a =final_indicator4a[2..rowsof(final_indicator4a), .]
	matrix final_indicator4b =final_indicator4b[2..rowsof(final_indicator4b), .]

	matrix final_indicator4  = final_indicator4a\final_indicator4b 
	matrix list final_indicator4
	
	
	//no livestock households in Burkina Faso 
	di "---------------- Summary statistics group 5 ----------------"
	* Group 5  - milk and egg productivity
	foreach v in w_liters_per_largeruminant  w_liters_milk_produced w_egg_poultry_year weight_milk  weight_egg {
		capture confirm variable `v'
		if _rc {
			qui gen `v'=.
		}
	}

	ren w_liters_per_largeruminant w_liters_per_all
	replace w_liters_per_all=. if weight_milk==0  | weight_milk==.
	replace w_liters_milk_produced=. if weight_milk==0 | weight_milk==.
	replace w_egg_poultry_year=. if weight_egg==0  |  weight_egg==.
	replace w_eggs_total_year=. if weight_egg==0  |  weight_egg==.

	foreach v in 1ppp 2ppp loc {
		foreach var in w_value_milk_produced w_value_eggs_produced {
		capture confirm variable `var'_`v'
		if _rc {
			capture confirm var `var' 
				if !_rc {
					qui gen `var'_`v'=`var' * ccf_`v'
				}
				else {
					qui gen `var'_`v'=.
				}
		}
		}
		replace w_value_milk_produced_`v'=. if weight_milk==0  | weight_milk==. 
		replace w_value_eggs_produced_`v'=. if weight_egg==0  |  weight_egg==.
	}

	global household_indicators5 liters_per_all liters_per_cow liters_per_buffalo costs_dairy_1ppp costs_dairy_2ppp costs_dairy_loc /*
	*/ cost_per_lit_milk_1ppp cost_per_lit_milk_2ppp cost_per_lit_milk_loc /*
	*/ costs_dairy_percow_1ppp  costs_dairy_percow_2ppp  costs_dairy_percow_loc  egg_poultry_year
	global final_indicator5  
	foreach v of global household_indicators5 {
		capture confirm variable w_`v'
		if _rc {
			qui gen w_`v'=0
		}
		local l`v' : var lab w_`v' 
		qui gen w_`v'_fhh=w_`v' if fhh==1
		qui lab var w_`v'_fhh "`l`v'' - FHH"
		qui gen w_`v'_mhh=w_`v' if fhh==0
		qui lab var w_`v'_mhh "`l`v'' - MHH"
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

	*recode weights that could not be created to 1
	foreach v in weight_milk weight_egg {
		local missing_var ""
		qui findname `v',  all(@==.) local (missing_var)
		if "`missing_var'"!="" { 
			qui replace `v'=1
		}
	}
	if "`instrument'"=="BurkinaF_EMC_W1" {
		drop livestock_hh
		gen livestock_hh=1  // for Burkina Faso only
	}
	qui tabstat $milkvar  [aw=weight_milk] if rural==1 & livestock_hh==1 , stat(mean sd p25 p50 p75  min max N) col(stat) save 
	matrix final_indicator5=r(StatTotal)' 
	qui svyset clusterid [pweight=weight_milk], strata(strataid) singleunit(centered) // get standard errors of the mean	
	matrix semean5=(.)
	matrix colnames semean5=semean_wei
	foreach v of global milkvar {
		local missing_var ""
		qui findname `v' if rural==1 & livestock_hh==1,  all(@==.) local (missing_var)
		if "`missing_var'"!="" { 
			qui replace `v'=0
		}	
		qui svy, subpop(if rural==1  & livestock_hh==1 ): mean `v'
		matrix semean5=semean5\(el(r(table),2,1))
	}
	matrix final_indicator5=final_indicator5,semean5[2..rowsof(semean5),.]

	global eggvar w_egg_poultry_year w_egg_poultry_year_fhh w_egg_poultry_year_mhh
	qui tabstat $eggvar [aw=weight_egg] if rural==1  & livestock_hh==1 , stat(mean sd p25 p50 p75  min max N) col(stat) save  //Add condition that HH must be engaged in livestock production
	matrix temp5=r(StatTotal)' 
	matrix semean5=(.)
	matrix colnames semean5=semean_wei
	foreach v of global eggvar {
		local missing_var ""
		qui findname `v' if rural==1 & livestock_hh==1,  all(@==.) local (missing_var)
		if "`missing_var'"!="" { 
			qui replace `v'=0
		}	
		qui svy, subpop(if rural==1 & livestock_hh==1 ): mean `v'  
		matrix semean5=semean5\(el(r(table),2,1))
	}
	matrix temp5=temp5,semean5[2..rowsof(semean5),.]
	matrix final_indicator5=final_indicator5\temp5
	matrix list final_indicator5 
	
	
	di "---------------- Summary statistics group 6 ----------------"
	* Group 6  - agrochemical applications
	local chem_inputs herb pest pestherb n p k urea npk inorg_fert org_fert
	global final_indicator6 all female male mixed
	matrix final_indicator6=(.,.,.,.,.,.,.,.,.)
	capture confirm var ha_planted
	if _rc {
		qui gen ha_planted=.
	}
	capture confirm variable w_ha_planted_all
		if _rc {
			ren ha_planted w_ha_planted_all
		}
	foreach chem in `chem_inputs' {
		foreach v in w_`chem'_rate   {
			capture qui confirm variable `v'
			if _rc {
				qui gen `v'=.
			}
		}
		capture qui confirm var w_`chem'_rate_all 
		if _rc {
			qui gen w_`chem'_rate_all = w_`chem'_rate
		}

		qui recode w_`chem'_rate* (.=0) if crop_hh==1

		foreach  v of global final_indicator6 {
			capture qui confirm variable w_`chem'_rate_`v' 
			if _rc {
				qui gen w_`chem'_rate_`v' = .
			}
			local l`v' : var lab w_`chem'_rate_`v' 
			qui gen w_`chem'_rate_`v'users=w_`chem'_rate_`v'  if  (w_`chem'_rate_`v'!=0 & w_`chem'_rate_`v'!=.)
			qui lab var w_`chem'_rate_`v'users "`l`v'' - only household using `chem'"

			//di "`chem'_`v'"
			qui capture confirm variable area_weight_`v'
			if _rc {
				qui gen area_weight_`v'=1
			}	
			local missing_var ""
			qui findname area_weight_`v',  all(@==.) local (missing_var)
			if "`missing_var'"!="" { 
				qui replace area_weight_`v'=1
			}
			
			local missing_var ""
			qui findname w_`chem'_rate_`v',  all(@==.) local (missing_var)
			if "`missing_var'"!="" { 
				qui replace w_`chem'_rate_`v'=0
			} 
			capture qui tabstat w_`chem'_rate_`v' [aw=area_weight_`v'] if rural==1,  stat(mean sd p25 p50 p75  min max N) col(stat) save
			matrix temp6=r(StatTotal)'
			if el(temp6,1,1)!=. {
			*Standard error 
			qui svyset clusterid [pweight=area_weight_`v'], strata(strataid) singleunit(centered) 
			qui svy, subpop(if rural==1): mean w_`chem'_rate_`v'
			matrix final_indicator6=final_indicator6\(temp6,el(r(table),2,1))
			}
			else {
				matrix final_indicator6=final_indicator6\(.,.,.,.,.,.,.,.,.)
			}
			
			local missing_var ""
			qui findname area_weight_`v',  all(@==.) local (missing_var)
			if "`missing_var'"!="" { 
				qui replace area_weight_`v'=1
			}
			local missing_var ""
			qui findname w_`chem'_rate_`v'users,  all(@==.) local (missing_var)
			if "`missing_var'"!="" { 
				qui replace w_`chem'_rate_`v'users=0
				qui replace w_`chem'_rate_`v'=0.000001
				//di "w_`chem'_rate_`v'users"
				qui ta w_`chem'_rate_`v'users
			} 
		
			capture qui tabstat  w_`chem'_rate_`v'users [aw=area_weight_`v'] if rural==1  & ag_hh==1  & w_`chem'_rate_`v'!=. & w_`chem'_rate_`v'!=0,  stat(mean sd p25 p50 p75  min max N) col(stat) save
			matrix temp6=r(StatTotal)'
			if el(temp6,1,1)!=. {
			*Standard error
			qui svyset clusterid [pweight=area_weight_`v'], strata(strataid) singleunit(centered) 
			local missing_var ""
			qui svy, subpop(if rural==1): mean  w_`chem'_rate_`v'users
			matrix final_indicator6=final_indicator6\(temp6,el(r(table),2,1))
			}
			else {
				matrix final_indicator6=final_indicator6\(.,.,.,.,.,.,.,.,.)
			}
		}
	}
	matrix final_indicator6 =final_indicator6[2..rowsof(final_indicator6), .]
	matrix list final_indicator6 
	

	di "---------------- Summary statistics group 7 ----------------"
	* Group 7  - total explicit cost at the household level, also by farm type and gender of HoH
	global household_indicators7a cost_expli_hh_1ppp cost_expli_hh_1ppp01Ha cost_expli_hh_1ppp12Ha cost_expli_hh_1ppp24Ha cost_expli_hh_1ppp4Ha_ cost_expli_hh_1ppp02Ha cost_expli_hh_1ppp04Ha /*
	*/ cost_expli_hh_2ppp cost_expli_hh_2ppp01Ha cost_expli_hh_2ppp12Ha cost_expli_hh_2ppp24Ha cost_expli_hh_2ppp4Ha_  cost_expli_hh_2ppp02Ha cost_expli_hh_2ppp04Ha  /*
	*/ cost_expli_hh_loc cost_expli_hh_loc01Ha cost_expli_hh_loc12Ha cost_expli_hh_loc24Ha cost_expli_hh_loc4Ha_   cost_expli_hh_loc02Ha cost_expli_hh_loc04Ha 

	matrix final_indicator7a=(.,.,.,.,.,.,.,.,.)
	foreach v of global household_indicators7a {
		capture confirm variable w_`v'
		if _rc {
			qui gen w_`v'=0
		}
		global final_indicator7a ""	
		local l`v' : var lab w_`v' 
		qui gen w_`v'_fhh=w_`v' if fhh==1
		qui lab var w_`v'_fhh "`l`v'' - FHH"
		qui gen w_`v'_mhh=w_`v' if fhh==0
		qui lab var w_`v'_mhh "`l`v'' - MHH"
		global final_indicator7a $final_indicator7a w_`v'  w_`v'_fhh  w_`v'_mhh
		qui tabstat $final_indicator7a [aw=weight] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
		matrix temp7a=r(StatTotal)'	
		qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered)
		matrix semean7a=(.)
		matrix colnames semean7a=semean_wei
		
		local x = 1
		foreach v of global final_indicator7a {
			local missing_var ""
			qui findname `v',  all(@==.) local (missing_var)
			if "`missing_var'"!="" { 
			qui replace `v'=0
			}	
			if el(temp7a,`x',1)!=. {
			qui svy, subpop(if rural==1): mean `v' 
			matrix semean7a=semean7a\(el(r(table),2,1))
			}
			else {
				matrix semean7a=semean7a\(.)
			}
			local ++x
		}
		matrix temp7a=temp7a,semean7a[2..rowsof(semean7a),.]
		matrix final_indicator7a=final_indicator7a\temp7a
	}	
	matrix final_indicator7a =final_indicator7a[2..rowsof(final_indicator7a), .]

	global household_indicators7b cost_expli_hh_ha_1ppp cost_expli_hh_ha_2ppp cost_expli_hh_ha_loc
	matrix final_indicator7b=(.,.,.,.,.,.,.,.,.)
	foreach v of global household_indicators7b {
		capture confirm variable w_`v'
		if _rc {
			qui gen w_`v'=.
		}
		global final_indicator7b ""	
		local l`v' : var lab w_`v' 
		qui gen w_`v'_fhh=w_`v' if fhh==1
		qui lab var w_`v'_fhh "`l`v'' - FHH"
		qui gen w_`v'_mhh=w_`v' if fhh==0
		qui lab var w_`v'_mhh "`l`v'' - MHH"
		global final_indicator7b $final_indicator7b w_`v'  w_`v'_fhh  w_`v'_mhh
		qui tabstat $final_indicator7b [aw=w_ha_planted_weight] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
		matrix temp7b=r(StatTotal)'	
		qui svyset clusterid [pweight=w_ha_planted_weight], strata(strataid) singleunit(centered) // get standard errors of the mean
		matrix semean7b=(.)
		matrix colnames semean7b=semean_wei
		foreach v of global final_indicator7b {
			local missing_var ""
			qui findname `v',  all(@==.) local (missing_var)
			if "`missing_var'"!="" { 
			qui replace `v'=0
			}	
			qui svy, subpop(if rural==1): mean `v' 
			matrix semean7b=semean7b\(el(r(table),2,1))
		}
		matrix temp7b=temp7b,semean7b[2..rowsof(semean7b),.]
		matrix final_indicator7b=final_indicator7b\temp7b
	}	

	matrix final_indicator7b =final_indicator7b[2..rowsof(final_indicator7b), .]
	matrix final_indicator7 =final_indicator7a\final_indicator7b
	matrix list final_indicator7

	di "---------------- Summary statistics group 8 ----------------"
	* Group 8  - total explicit cost per ha by gender of plot manager, also by farm type
	*Explicit cost by farm type
	foreach v in w_cost_expli_ha_1ppp w_cost_expli_ha_2ppp w_cost_expli_ha_loc {
		capture confirm variable `v'
		if _rc {
			qui gen `v'=.
		}
	}
	ren w_cost_expli_ha_1ppp w_cost_expli_ha_all_1ppp
	ren w_cost_expli_ha_2ppp w_cost_expli_ha_all_2ppp
	ren w_cost_expli_ha_loc w_cost_expli_ha_all_loc

	global final_indicator8 all female male  mixed
	foreach v of global final_indicator8 {
		foreach i in 1ppp 2ppp loc {
			capture confirm variable w_cost_expli_ha_`v'_`i'
			if _rc {
				qui gen w_cost_expli_ha_`v'_`i'=.
			}
			qui gen w_cost_expli_ha_`v'01Ha_`i'=w_cost_expli_ha_`v'_`i' if farm_size_0_1==1
			qui gen w_cost_expli_ha_`v'12Ha_`i'=w_cost_expli_ha_`v'_`i' if farm_size_1_2==1
			qui gen w_cost_expli_ha_`v'24Ha_`i'=w_cost_expli_ha_`v'_`i' if farm_size_2_4==1
			qui gen w_cost_expli_ha_`v'4Ha_`i'=w_cost_expli_ha_`v'_`i' if farm_size_4_more==1	
			
			qui gen w_cost_expli_ha_`v'04Ha_`i'=w_cost_expli_ha_`v'_`i' if farm_size_0_1==1 | farm_size_1_2==1 | farm_size_2_4==1
			qui gen w_cost_expli_ha_`v'02Ha_`i'=w_cost_expli_ha_`v'_`i' if farm_size_0_1==1 | farm_size_1_2==1
	
			local l`v' : var label w_cost_expli_ha_`v'_`i'
			qui lab var w_cost_expli_ha_`v'01Ha_`i' "`l`v'' - farm size [0-1 Ha]"
			qui lab var w_cost_expli_ha_`v'12Ha_`i' "`l`v'' - farm size [1-2 Ha]"
			qui lab var w_cost_expli_ha_`v'24Ha_`i' "`l`v'' - farm size ]2-h Ha]"
			qui lab var w_cost_expli_ha_`v'4Ha_`i' "`l`v'' - farm size ]4 ha and more"
		}
	}

	foreach v of global final_indicator8 {
		foreach i in 1ppp 2ppp loc {  
			global final_indicator8a $final_indicator8a w_cost_expli_ha_`v'_`i' w_cost_expli_ha_`v'01Ha_`i' w_cost_expli_ha_`v'12Ha_`i' w_cost_expli_ha_`v'24Ha_`i' w_cost_expli_ha_`v'4Ha_`i' w_cost_expli_ha_`v'02Ha_`i' w_cost_expli_ha_`v'04Ha_`i'
		}
	}

	matrix final_indicator8=(.,.,.,.,.,.,.,.,.)
	foreach v of global final_indicator8 {
		foreach i in 1ppp 2ppp loc {
			qui tabstat w_cost_expli_ha_`v'_`i' w_cost_expli_ha_`v'01Ha_`i' w_cost_expli_ha_`v'12Ha_`i' w_cost_expli_ha_`v'24Ha_`i' w_cost_expli_ha_`v'4Ha_`i'  w_cost_expli_ha_`v'02Ha_`i' w_cost_expli_ha_`v'04Ha_`i' [aw=w_ha_planted_weight]   if rural==1 & ag_hh==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
			matrix temp8=r(StatTotal)'
			qui svyset clusterid [pweight=w_ha_planted_weight], strata(strataid) singleunit(centered) // get standard errors of the mean
			foreach x of global final_indicator8a{
				local missing_var ""
				qui findname `x',  all(@==.) local (missing_var)
				if "`missing_var'"!="" { 
					qui replace `x'=0
				}	
			}
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
		
			qui svy, subpop(if rural==1 & ag_hh==1): mean w_cost_expli_ha_`v'02Ha_`i' 
			scalar se`v'02Ha= el(r(table),2,1)	

			qui svy, subpop(if rural==1 & ag_hh==1): mean w_cost_expli_ha_`v'04Ha_`i' 
			scalar se`v'04Ha= el(r(table),2,1)	

			matrix temp8=temp8,(se`v'\se`v'01Ha\se`v'12Ha\se`v'24Ha\se`v'4Ha_\se`v'02Ha\se`v'04Ha)
			matrix final_indicator8=final_indicator8\temp8	
		}
	}
	matrix final_indicator8 =final_indicator8[2..rowsof(final_indicator8), .]
	matrix list final_indicator8 
 


	di "---------------- Summary statistics group 9 ----------------"
	** Group 9 - costs_total_hh_ppp  (explicit and implicit)
	*generate area weights for monocropped plots
	foreach i in 1ppp 2ppp loc {
		//di "`i'"
		capture qui confirm variable w_cost_total_ha_`i'
		if _rc {
			qui gen w_cost_total_ha_`i'=.
		}
		ren w_cost_total_ha_`i' w_cost_total_ha_all_`i'
		foreach v in $topcropname_area {
			capture qui confirm variable w_`v'_exp_`i'
			if _rc {
				qui gen w_`v'_exp_`i'=. 
			}
			capture qui confirm variable w_`v'_exp_ha_`i'
			if _rc {
				qui gen w_`v'_exp_ha_`i'=. 
			}
			capture qui confirm variable w_`v'_exp_kg_`i'
			if _rc {
				qui gen w_`v'_exp_kg_`i'=. 
			}
			ren w_`v'_exp_`i' w_`v'_exp_all_`i' 
			ren w_`v'_exp_ha_`i' w_`v'_exp_ha_all_`i'
			ren w_`v'_exp_kg_`i' w_`v'_exp_kg_all_`i'
		}
	}

	global final_indicator9 all female male mixed
	matrix final_indicator9=(.,.,.,.,.,.,.,.,.)
	
	foreach i in 1ppp 2ppp loc {
		foreach v of global final_indicator9 {
			//di "area_weight_`v'"
			capture qui confirm variable area_weight_`v'
			if _rc {
				qui gen area_weight_`v'=1
			}
			local missing_var ""
			qui findname area_weight_`v',  all(@==.) local (missing_var)
			if "`missing_var'"!="" { 
				qui replace area_weight_`v'=1
			}
			capture qui confirm variable w_cost_total_ha_`v'_`i'
			if _rc {
				qui gen w_cost_total_ha_`v'_`i'=0 
			}
			qui findname  w_cost_total_ha_`v'_`i',  all(@==.) local (missing_var)
			if "`missing_var'"!="" { 
				qui replace  w_cost_total_ha_`v'_`i'=0
			}
			qui tabstat w_cost_total_ha_`v'_`i'  [aw=area_weight_`v']  if rural==1 & ag_hh==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
			matrix temp9=r(StatTotal)'
			local missing_var ""	
			qui svyset clusterid [pweight=area_weight_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean	
			qui svy, subpop(if rural==1 & ag_hh==1): mean w_cost_total_ha_`v'_`i'
			matrix final_indicator9=final_indicator9\(temp9,el(r(table),2,1))
		}
	}
	matrix final_indicator9 =final_indicator9[2..rowsof(final_indicator9), .]

	matrix temp9b = (.,.,.,.,.,.,.,.,.)
	foreach i in 1ppp 2ppp loc {
		foreach v of global final_indicator9 {
			foreach x in $topcropname_area {
				//di "w_`x'_exp_`v'_`i'"
				capture qui confirm variable  w_`x'_exp_`v'_`i'
				if _rc {
					qui gen  w_`x'_exp_`v'_`i'=0 
				}
				qui tabstat w_`x'_exp_`v'_`i'  [aw=weight]  if rural==1 & ag_hh==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
				matrix temp9c=r(StatTotal)'
				local missing_var ""
				qui findname w_`x'_exp_`v'_`i' if rural==1 & ag_hh==1,  all(@==.) local (missing_var)
				if "`missing_var'"!="" { 		
					qui replace w_`x'_exp_`v'_`i'=0
				}
				qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered) // get standard errors of the mean	
				qui svy, subpop(if rural==1 & ag_hh==1): mean w_`x'_exp_`v'_`i'
				matrix temp9b=temp9b\(temp9c,el(r(table),2,1))
			}
		}
	}
	matrix temp9b =temp9b[2..rowsof(temp9b), .]

	matrix temp9d = (.,.,.,.,.,.,.,.,.)
	foreach i in 1ppp 2ppp loc {
		foreach v of global final_indicator9 {
			foreach x in $topcropname_area {
				//di "`x'"
				//di "ar_pl_mono_wgt_`x'_`v''"
				capture qui confirm variable  ar_pl_mono_wgt_`x'_`v'
				if _rc {
					qui gen  ar_pl_mono_wgt_`x'_`v'=1
				}
				if sum(ar_pl_mono_wgt_`x'_`v')==0 {
					qui replace ar_pl_mono_wgt_`x'_`v'=1
				}
				//local allzeros ""
				//qui findname ar_pl_mono_wgt_`x'_`v' if rural==1 & ag_hh==1,  all(@==0 | @==.) local (allzeros)
				//if "`allzeros'"!="" { 
				//	qui replace ar_pl_mono_wgt_`x'_`v'=1
				//}				
				capture qui confirm variable  w_`x'_exp_ha_`v'_`i'
				if _rc {
					qui gen w_`x'_exp_ha_`v'_`i'=0
				}				
				local missing_var ""			
				qui findname w_`x'_exp_ha_`v'_`i' if rural==1 & ag_hh==1,  all(@==.) local (missing_var)
				if "`missing_var'"!="" { 
					qui replace w_`x'_exp_ha_`v'_`i'=0
				}
				qui  tabstat w_`x'_exp_ha_`v'_`i' [aw=ar_pl_mono_wgt_`x'_`v']  if rural==1 & ag_hh==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
				matrix temp9e=r(StatTotal)'
				qui svyset clusterid [pw=ar_pl_mono_wgt_`x'_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean	
				qui  svy, subpop(if rural==1 & ag_hh==1): mean w_`x'_exp_ha_`v'_`i'
				matrix temp9d=temp9d\(temp9e,el(r(table),2,1))
			}
		}
	}
	matrix temp9d =temp9d[2..rowsof(temp9d), .]

	matrix temp9f = (.,.,.,.,.,.,.,.,.)
	foreach i in 1ppp 2ppp loc {
		foreach v of global final_indicator9 {
			foreach x in $topcropname_area {
				capture qui confirm variable  kgs_harv_wgt_`x'_`v'
				if _rc {
					qui gen kgs_harv_wgt_`x'_`v'=1
				}
				local missing_var ""
				qui findname kgs_harv_wgt_`x'_`v' if (rural==1 & ag_hh==1),  all(@==.) local (missing_var)
				if "`missing_var'"!="" { 
					qui replace kgs_harv_wgt_`x'_`v'=1
				}
				capture qui confirm variable  w_`x'_exp_kg_`v'_`i'
				if _rc {
					qui gen w_`x'_exp_kg_`v'_`i'=0	
				}
				local missing_var ""
				qui findname  w_`x'_exp_kg_`v'_`i' if rural==1 & ag_hh==1,  all(@==.) local (missing_var)
				if "`missing_var'"!="" { 
					qui replace  w_`x'_exp_kg_`v'_`i'=0
				}
				local missing_var ""			
				qui findname w_`x'_exp_kg_`v'_`i' if rural==1 & ag_hh==1,  all(@==.) local (missing_var)
				if "`missing_var'"!="" { 
					qui replace w_`x'_exp_kg_`v'_`i'=0
				}
				local missing_var ""	
				qui recode kgs_harv_wgt_`x'_`v' (.=0)
				qui findname kgs_harv_wgt_`x'_`v' if rural==1 & ag_hh==1,  all(@==. | @==0) local (missing_var)
				if "`missing_var'"!="" { 
					qui replace kgs_harv_wgt_`x'_`v'=1
				}
				*di "w_`x'_exp_kg_`v'_`i'"
				qui tabstat w_`x'_exp_kg_`v'_`i' [aw=kgs_harv_wgt_`x'_`v'] if rural==1 & ag_hh==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
				matrix temp9g=r(StatTotal)'
	
				qui svyset clusterid [pw=kgs_harv_wgt_`x'_`v'], strata(strataid) singleunit(centered) // get standard errors of the mean	
				qui svy, subpop(if rural==1 & ag_hh==1): mean w_`x'_exp_kg_`v'_`i'
				matrix temp9f=temp9f\(temp9g,el(r(table),2,1))
			}
		}
	}
	matrix temp9f =temp9f[2..rowsof(temp9f), .]

	matrix final_indicator9 =final_indicator9\temp9b\temp9d\temp9f
	matrix list final_indicator9

	di "---------------- Summary statistics group 10 ----------------"
	** Group 10 - per_capita income and poverty headcount using individual weight
	global final_indicator10a ""
	foreach i in 1ppp 2ppp loc {
		foreach  v of varlist w_percapita_income_`i' w_daily_percap_cons_`i' {
			capture confirm variable  `v'
			if _rc {
				qui gen  `v'=.
			}
			local l`v' : var lab `v' 
			qui gen `v'_nat= `v'  
			qui lab var `v'_nat "`l`v'' - using individual weight"
			qui gen `v'_nat_fhh=`v' if fhh==1	
			qui lab var `v'_nat_fhh "`l`v'' - FHH- using individual weight"
			qui gen `v'_nat_mhh=`v' if fhh==0	
			qui lab var `v'_nat_mhh "`l`v'' - MHH- using individual weight"
			global final_indicator10a $final_indicator10a `v'_nat  `v'_nat_fhh `v'_nat_mhh
		}
	}
	
	global final_indicator10b ""
	foreach i in 1ppp 2ppp loc {
		foreach  v of varlist w_daily_peraeq_cons_`i' {
			capture confirm variable  `v'
			if _rc {
				qui gen  `v'=. 
			}
			local l`v' : var lab `v' 
			qui gen `v'_nat= `v'  
			qui lab var `v'_nat "`l`v'' - using adult equivalent weight"
			qui gen `v'_nat_fhh=`v' if fhh==1	
			qui lab var `v'_nat_fhh "`l`v'' - FHH- using adult equivalent weight"
			qui gen `v'_nat_mhh=`v' if fhh==0	
			qui lab var `v'_nat_mhh "`l`v'' - MHH- using adult equivalent weight"
			global final_indicator10b $final_indicator10b `v'_nat  `v'_nat_fhh `v'_nat_mhh
		}
	}
	
	*Adult Equivalent Weight
	local missing_weight ""			
		qui findname adulteq_weight,  all(@==.) local (missing_weight)
		if "`missing_var'"!="" { 
			qui replace `v'=1
		}
		
	*percapita consumption
	global final_indicator10c ""
	foreach i in 1ppp 2ppp loc {
		foreach v of varlist w_daily_percap_cons_`i' {
			capture confirm variable  `v'
			if _rc {
				qui gen  `v'=. 	
			}
			local l`v' : var lab `v' 
			qui gen `v'_b40= `v' if bottom_40_percap==1  
			qui lab var `v'_b40 "`l`v'' - limited to bottom 40% of consumption for rural population"
			qui gen `v'_b40_fhh=`v' if fhh==1	
			qui lab var `v'_b40_fhh "`l`v'' - limited to bottom 40% of consumption for rural population - FHH"
			qui gen `v'_b40_mhh=`v' if fhh==0	
			qui lab var `v'_b40_mhh "`l`v'' - limited to bottom 40% of consumption for rural population - MHH"
			global final_indicator10c $final_indicator10c `v'_b40 `v'_b40_fhh `v'_b40_mhh
		}
	}

	*adult equivalent consumption
	global final_indicator10d ""
	foreach i in 1ppp 2ppp loc {
		foreach v of varlist w_daily_peraeq_cons_`i' {
			capture confirm variable  `v'
			if _rc {
				qui gen  `v'=. 	
			}
			local l`v' : var lab `v' 
			qui gen `v'_b40= `v' if bottom_40_peraeq==1  
			qui lab var `v'_b40 "`l`v'' - limited to bottom 40% of consumption for rural population - using adult equivalent weight"
			qui gen `v'_b40_fhh=`v' if fhh==1	
			qui lab var `v'_b40_fhh "`l`v'' - limited to bottom 40% of consumption for rural population - FHH - using adult equivalent weight"
			qui gen `v'_b40_mhh=`v' if fhh==0	
			qui lab var `v'_b40_mhh "`l`v'' - limited to bottom 40% of consumption for rural population - MHH - using adult equivalent weight"
			global final_indicator10d $final_indicator10d `v'_b40 `v'_b40_fhh `v'_b40_mhh
		}
	}

	* Rural poverty headcount
	global final_indicator10e ""
	local missing_var ""			
	//ALT 03.21.23
	capture confirm variable poverty_under_190
	if _rc {
		qui gen  poverty_under_190=. 
	}
	capture confirm var poverty_under_215 
	if _rc {
		qui gen poverty_under_215 = .
	}
	capture confirm var poverty_under_npl 
	if _rc {
		qui gen poverty_under_npl = . 
	}
	capture confirm var poverty_under_300
	if _rc {
		qui gen poverty_under_300=.
	}
	/* DMC - not sure about this - we want them to be missing if it's not there, right?
	i DYA - I think we need these because in the code below, the condition 'if bottom_40_peraeq==1" is used
	in the spreadhseet we will remove all rows with 0 for for all summary stats*/
	qui findname poverty_under_190 poverty_under_215 poverty_under_300 poverty_under_npl,  all(@==.) local (missing_var)
	if "`missing_var'"!="" { 
		foreach var in `missing_var' {
			qui replace `var'=0
		}	
	}	
	local missing_var ""			
	qui findname bottom_40_peraeq,  all(@==.) local (missing_var)
	if "`missing_var'"!="" { 
		qui replace bottom_40_peraeq=1
	}	
//IHS START also need for bottom_40_percap
*tz tbs and india rms generate bottom_40_peraeq=1 in the instrument do files but we should go back and make that missing so that the .dta files (if we ever were to share those). will go back and fix
	local missing_var ""			
	qui findname bottom_40_percap,  all(@==.) local (missing_var)
	if "`missing_var'"!="" { 
		qui replace bottom_40_percap=1
	}		
	
	foreach v in poverty_under_190 /*ALT 03.21.23*/ poverty_under_npl poverty_under_215 poverty_under_300 {
	
		local l`v' : var lab `v' 
		qui gen `v'_fhh=`v' if fhh==1	
		qui lab var `v'_fhh "`l`v'' - FHH"
		qui gen `v'_mhh=`v' if fhh==0	
		qui lab var `v'_mhh "`l`v'' - MHH"
		global final_indicator10e $final_indicator10e `v'  `v'_fhh `v'_mhh
		
	}	

	capture confirm variable individual_weight
	if _rc {
		qui gen individual_weight=1
	}
	capture confirm variable adulteq_weight
	if _rc {
		qui gen adulteq_weight=1
	}
	matrix final_indicator10a=(.,.,.,.,.,.,.,.,.)
	foreach v of global final_indicator10a {
		capture confirm variable  `v'
		if _rc {
			qui gen  `v'=. 
		}
		qui tabstat `v' [aw=individual_weight] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
		matrix temp10=r(StatTotal)'
		local missing_var ""			
		qui findname `v',  all(@==.) local (missing_var)
		if "`missing_var'"!="" { 
			qui replace `v'=0
		}	
		qui svyset clusterid [pweight=individual_weight], strata(strataid) singleunit(centered) // get standard errors of the mean	
		qui svy, subpop(if rural==1): mean  `v'
		matrix final_indicator10a=final_indicator10a\(temp10,el(r(table),2,1))	
	}
	matrix final_indicator10a =final_indicator10a[2..rowsof(final_indicator10a), .]

	matrix final_indicator10b=(.,.,.,.,.,.,.,.,.)
	foreach v of global final_indicator10b {
		capture confirm variable  `v'
		if _rc {
			qui gen  `v'=. 	
		}
		qui tabstat `v' [aw=adulteq_weight] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
		matrix temp10=r(StatTotal)'
		local missing_var ""			
		qui findname `v',  all(@==.) local (missing_var)
		if "`missing_var'"!="" { 
			qui replace `v'=0
		}	
		qui svyset clusterid [pweight=adulteq_weight], strata(strataid) singleunit(centered) // get standard errors of the mean	
		qui svy, subpop(if rural==1): mean  `v'
		matrix final_indicator10b=final_indicator10b\(temp10,el(r(table),2,1))	
	}

	matrix final_indicator10b =final_indicator10b[2..rowsof(final_indicator10b), .]

	matrix final_indicator10c=(.,.,.,.,.,.,.,.,.)
	foreach v of global final_indicator10c {
		capture confirm variable  `v'
		if _rc {
			qui gen  `v'=. 	
		}
		qui tabstat `v' [aw=individual_weight] if rural==1 & bottom_40_percap==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
		matrix temp10=r(StatTotal)'
		local missing_var ""			
		qui findname `v',  all(@==.) local (missing_var)
		if "`missing_var'"!="" { 
			qui replace `v'=0
		}	
		qui svyset clusterid [pweight=individual_weight], strata(strataid) singleunit(centered) // get standard errors of the mean	
		qui svy, subpop(if rural==1 & bottom_40_percap==1): mean  `v'
		matrix final_indicator10c=final_indicator10c\(temp10,el(r(table),2,1))	
	}

	matrix final_indicator10c =final_indicator10c[2..rowsof(final_indicator10c), .]

	matrix final_indicator10d=(.,.,.,.,.,.,.,.,.)
	foreach v of global final_indicator10d {
		local missing_var ""		
		qui findname `v',  all(@==.) local (missing_var)
		if "`missing_var'"!="" { 
			qui replace `v'=0
		}
		capture confirm variable  `v'
		if _rc {
			qui gen  `v'=. 	
		}
		qui tabstat `v' [aw=adulteq_weight] if rural==1 & bottom_40_peraeq==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
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
		capture confirm variable  `v'
		if _rc {
			qui gen  `v'=. //IHS 9.23.19 why was this one 0 instead of missing? If gen = . instead of 0, the N in the outputs are also missing so we won't need to delete that later in the spreadsheet. 
		}
		local missing_var ""		
		qui findname `v',  all(@==.) local (missing_var)
		if "`missing_var'"!="" { 
			qui replace `v'=0
		}
		qui gen tot_`v'=`v'
		local l`v' : var lab `v' 
		qui lab var tot_`v' " Total : `l`v''"

		qui svy, subpop(if rural==1): total  `v'
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
		capture confirm variable  `v'
		if _rc {
			qui gen  `v'=. 	
		}
		qui tabstat `v' [aw=individual_weight] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
		matrix temp10=r(StatTotal)'
		local missing_var ""		
		qui findname `v',  all(@==.) local (missing_var)
		if "`missing_var'"!="" { 
			qui replace `v'=0
		}	
		qui svyset clusterid [pweight=individual_weight], strata(strataid) singleunit(centered) // get standard errors of the mean	
		qui svy, subpop(if rural==1): mean  `v'
		matrix final_indicator10f=final_indicator10f\(temp10,el(r(table),2,1))	
	}
	matrix final_indicator10f =final_indicator10f[2..rowsof(final_indicator10f), .]

	*DYA 12.10.19 - including poverty count and ration for all (rural and urban)
	*POVERTY ESTIMATE ALL
	global final_indicator10e_all ""
	//ALT 03.23.23
	gen  poverty_under_190_all= poverty_under_190
	gen poverty_under_215_all = poverty_under_215
	gen poverty_under_npl_all = poverty_under_npl
	gen poverty_under_300_all = poverty_under_300
	foreach v in poverty_under_190_all poverty_under_215_all poverty_under_npl_all poverty_under_300_all {	
		local l`v' : var lab `v' 
		qui gen `v'_fhh=`v' if fhh==1	
		qui lab var `v'_fhh "`l`v'' -ds FHH"
		qui gen `v'_mhh=`v' if fhh==0	
		qui lab var `v'_mhh "`l`v'' - MHH"
		global final_indicator10e_all $final_indicator10e_all `v'  `v'_fhh `v'_mhh
		
	}	
	matrix final_indicator10e_all=(.,.,.,.,.,.,.,.,.)
	global poverty_count ""
	qui svyset clusterid [pweight=individual_weight], strata(strataid) singleunit(centered) // get standard errors of the mean
	foreach v of global final_indicator10e_all {
		capture confirm variable  `v'
		if _rc {
			qui gen  `v'=. //IHS 9.23.19 why was this one 0 instead of missing? If gen = . instead of 0, the N in the outputs are also missing so we won't need to delete that later in the spreadsheet. 
		}
		local missing_var ""		
		qui findname `v',  all(@==.) local (missing_var)
		if "`missing_var'"!="" { 
			qui replace `v'=0
		}
		qui gen tot_`v'=`v'
		local l`v' : var lab `v' 
		qui lab var tot_`v' " Total : `l`v''"

		qui svy: total  `v'
		matrix b=e(b)
		matrix V=e(V)
		matrix N=e(N)
		matrix final_indicator10e_all=final_indicator10e_all\(el(b,1,1),. ,. ,. ,. ,. ,. ,el(N,1,1),sqrt(el(V,1,1)))
		global poverty_count $poverty_count "tot_`v'"
	}
	matrix final_indicator10e_all = final_indicator10e_all[2..rowsof(final_indicator10e_all),.]
	matrix rownames final_indicator10e_all = $poverty_count

	// POVERTY RATIO
	matrix final_indicator10f_all=(.,.,.,.,.,.,.,.,.)
	foreach v of global final_indicator10e_all {
		capture confirm variable  `v'
		if _rc {
			qui gen  `v'=. 	
		}
		qui tabstat `v' [aw=individual_weight], stat(mean sd p25 p50 p75  min max N) col(stat) save
		matrix temp10=r(StatTotal)'
		local missing_var ""		
		qui findname `v',  all(@==.) local (missing_var)
		if "`missing_var'"!="" { 
			qui replace `v'=0
		}	
		qui svyset clusterid [pweight=individual_weight], strata(strataid) singleunit(centered) // get standard errors of the mean	
		qui svy: mean  `v'
		matrix final_indicator10f_all=final_indicator10f_all\(temp10,el(r(table),2,1))	
	}
	matrix final_indicator10f_all =final_indicator10f_all[2..rowsof(final_indicator10f_all), .]

	matrix final_indicator10 =final_indicator10a\final_indicator10b\final_indicator10c\final_indicator10d\final_indicator10e\final_indicator10f\final_indicator10e_all\final_indicator10f_all
	matrix list final_indicator10  
******************
	

	di "---------------- Summary statistics group 11 ----------------"
	* Group 11: Variables that are reported as both as average and also as total at the country level
	*starting with value of crop production
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
		global final_indicator11 $final_indicator11 grew_`v' grew_`v'01Ha grew_`v'12Ha grew_`v'24Ha grew_`v'4Ha	grew_`v'02Ha grew_`v'04Ha	
	}
	*Adding in final (non-crop) variables
	global final_indicator11 ""
	global final_indicator11 $final_indicator11 /*
	*/ agactivities_hh ag_hh crop_hh livestock_hh fishing_hh /*
	*/ w_liters_milk_produced w_value_milk_produced_1ppp w_value_milk_produced_2ppp w_value_milk_produced_loc /*
	*/ w_eggs_total_year w_value_eggs_produced_1ppp w_value_eggs_produced_2ppp w_value_eggs_produced_loc

	use "$final_data_household", clear
	* first report summary statistitc
	matrix final_indicator11=(.,.,.,.,.,.,.,.,.)
	global final_indicator11bis ""
	foreach v of global final_indicator11 {
		capture confirm variable  `v'
		if _rc {
			qui gen  `v'=.
		}	
		local l`v' : var lab `v' 
		qui gen `v'_fhh=`v' if fhh==1	
		qui lab var `v'_fhh "`l`v'' - FHH- using individual weight"
		qui gen `v'_mhh=`v' if fhh==0	
		qui lab var `v'_mhh "`l`v'' - MHH- using individual weight"
		di "`v'_fhh"
		global final_indicator11bis $final_indicator11bis `v'  `v'_fhh `v'_mhh
	}

	foreach v of global final_indicator11bis {
		capture confirm variable  `v'
		if _rc {
			qui gen  `v'=. 
		}
		qui tabstat `v' [aw=weight] if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
		matrix temp11=r(StatTotal)'
		local missing_var ""
		qui findname `v',  all(@==.) local (missing_var)
		if "`missing_var'"!="" { 
			qui replace `v'=0
		}
		qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered) // get standard errors of the mean	
		qui svy, subpop(if rural==1): mean  `v'
		matrix final_indicator11=final_indicator11\(temp11,el(r(table),2,1))	
	}	
	matrix final_indicator11 =final_indicator11[2..rowsof(final_indicator11), .]
	matrix list final_indicator11 

 
	di "---------------- Summary statistics group 12 ----------------"
	* Group 12
	*Now get rural total at the country level
	*since these are total, we are just keeping the estimated total and its standard errors
	*there are no other meanigful statisitics
	matrix final_indicator12a=J(1,9,.)
	global total_vars ""
	qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered) // get standard errors of the mean
	foreach v of global final_indicator11 {
		capture confirm variable  `v'
		if _rc {
			qui gen  `v'=. 
		}	
		qui gen rur_`v'=`v'			
		qui recode rur_`v' (.=0)	
		local l`v' : var lab `v' 
		qui lab var rur_`v' " Total : `l`v''"		
		qui svy, subpop(if rural==1): total rur_`v'		
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

	*getting the total at the country level including rural and urban
	matrix final_indicator12b=J(1,9,.)
	global total_vars ""
	qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered) // get standard errors of the mean
	foreach v of global final_indicator11 {
		capture confirm variable  `v'
		if _rc {
			qui gen  `v'=. 	
		}	
		qui gen tot_`v'=`v'
		qui recode tot_`v' (.=0)	
		local l`v' : var lab `v' 
		qui lab var tot_`v' " Total : `l`v''"
		qui svy : total  tot_`v'	
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

	matrix final_indicator12 =final_indicator12a\final_indicator12b		//ERE adding
	matrix list final_indicator12

	 if "`instrument'"!="India_AgDev_S1" & "`instrument'"!="India_AgDev_S2"  & "`instrument'"!="India_AgDev_S3" & "`instrument'"!="India_AgDev_S4"   {
	di "---------------- Summary statistics group 13 ----------------"
	*Group 13 :  plot level indicators : labor productivity, plot productivity, gender-base productivity gap
	use  "$final_data_plot",  clear
	capture confirm variable  dm_gender
	if _rc {
		qui gen  dm_gender=0
	}

	foreach i in 1ppp 2ppp loc{
		capture confirm variable  plot_weight
		if _rc {
			qui gen  plot_weight=1
		}
		foreach v in  w_plot_productivity_`i' w_plot_productivity_female_`i' w_plot_productivity_male_`i' w_plot_productivity_mixed_`i' {
			capture confirm variable  `v'
			if _rc {
				qui gen  `v'=. 	
			}
			local missing_var ""
			qui findname `v',  all(@==.) local (missing_var)
			if "`missing_var'"!="" { 
				qui replace `v'=0
			}
		}
		qui svyset clusterid [pweight=plot_weight], strata(strataid) singleunit(centered) // get standard errors of the mean
		qui tabstat w_plot_productivity_`i'  [aw=plot_weight]  if rural==1 & dm_gender!=.    , stat(mean sd p25 p50 p75  min max N) col(stat) save
		matrix temp_all=r(StatTotal)'
		qui svy, subpop(if rural==1 & dm_gender!=. ): mean w_plot_productivity_`i'
		matrix w_plot_productivity_all_`i'=temp_all,el(r(table),2,1)
		 
		qui tabstat w_plot_productivity_female_`i'  [aw=plot_weight]   if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
		matrix temp_female=r(StatTotal)'
		qui svy, subpop(if rural==1): mean w_plot_productivity_female_`i'
		matrix w_plot_productivity_female_`i'=temp_female,el(r(table),2,1)
	 
		qui tabstat w_plot_productivity_male_`i'  [aw=plot_weight]   if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
		matrix temp_male=r(StatTotal)'
		qui svy, subpop(if rural==1): mean w_plot_productivity_male_`i'
		matrix w_plot_productivity_male_`i'=temp_male,el(r(table),2,1)
		 
		qui tabstat w_plot_productivity_mixed_`i'  [aw=plot_weight]   if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
		matrix temp_mixed=r(StatTotal)'
		qui svy, subpop(if rural==1): mean w_plot_productivity_mixed_`i'
		matrix w_plot_productivity_mixed_`i'=temp_mixed,el(r(table),2,1)
	}
	 
	matrix final_indicator13=(w_plot_productivity_all_1ppp\w_plot_productivity_female_1ppp\w_plot_productivity_male_1ppp\w_plot_productivity_mixed_1ppp\ /*
	*/w_plot_productivity_all_2ppp\w_plot_productivity_female_2ppp\w_plot_productivity_male_2ppp\w_plot_productivity_mixed_2ppp\ /*
	*/w_plot_productivity_all_loc\w_plot_productivity_female_loc\w_plot_productivity_male_loc\w_plot_productivity_mixed_loc)

	foreach i in 1ppp 2ppp loc{
		capture confirm variable  plot_labor_weight
		if _rc {
			qui gen  plot_labor_weight=1
		}
		foreach v in  w_plot_labor_prod_all_`i' w_plot_labor_prod_female_`i' w_plot_labor_prod_male_`i' w_plot_labor_prod_mixed_`i' {
			capture confirm variable  `v'
			if _rc {
				qui gen  `v'=. 	
			}
			local missing_var ""
			qui findname `v',  all(@==.) local (missing_var)
			if "`missing_var'"!="" { 
				qui replace `v'=0
			}
		}
		
		qui svyset clusterid [pweight=plot_labor_weight], strata(strataid) singleunit(centered) // get standard errors of the mean
		qui tabstat w_plot_labor_prod_all_`i'  [aw=plot_labor_weight]   if rural==1  & dm_gender!=. , stat(mean sd p25 p50 p75  min max N) col(stat) save
		matrix temp_all=r(StatTotal)'
		qui svy, subpop(if rural==1): mean w_plot_labor_prod_all_`i'
		matrix w_plot_labor_prod_all_`i'=temp_all,el(r(table),2,1)
		 
		qui tabstat w_plot_labor_prod_male_`i'  [aw=plot_labor_weight]   if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
		matrix temp_male=r(StatTotal)'
		qui svy, subpop(if rural==1): mean w_plot_labor_prod_male_`i'
		matrix w_plot_labor_prod_male_`i'=temp_male,el(r(table),2,1)

		qui tabstat w_plot_labor_prod_female_`i'  [aw=plot_labor_weight]   if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
		matrix temp_female=r(StatTotal)'
		qui svy, subpop(if rural==1): mean w_plot_labor_prod_female_`i'
		matrix w_plot_labor_prod_female_`i'=temp_female,el(r(table),2,1)

		qui tabstat w_plot_labor_prod_mixed_`i'  [aw=plot_labor_weight]   if rural==1, stat(mean sd p25 p50 p75  min max N) col(stat) save
		matrix temp_mixed=r(StatTotal)'
		qui svy, subpop(if rural==1): mean w_plot_labor_prod_mixed_`i'
		matrix w_plot_labor_prod_mixed_`i'=temp_mixed,el(r(table),2,1)
	}

	matrix final_indicator13=final_indicator13\(w_plot_labor_prod_all_1ppp\w_plot_labor_prod_female_1ppp\w_plot_labor_prod_male_1ppp\w_plot_labor_prod_mixed_1ppp\ /*
	*/ w_plot_labor_prod_all_2ppp\w_plot_labor_prod_female_2ppp\w_plot_labor_prod_male_2ppp\w_plot_labor_prod_mixed_2ppp\ /*
	*/w_plot_labor_prod_all_loc\w_plot_labor_prod_female_loc\w_plot_labor_prod_male_loc\w_plot_labor_prod_mixed_loc)


	** gender_prod_gap
	foreach v in  gender_prod_gap1a gender_prod_gap1b {
		capture confirm variable  `v'
		if _rc {
			qui gen  `v'=. 
		}
	}
	qui tabstat gender_prod_gap1a gender_prod_gap1b, save
	matrix temp13= r(StatTotal)', J(2,7,.)
	qui tabstat segender_prod_gap1a segender_prod_gap1b, save
	matrix final_indicator13=final_indicator13\(temp13, r(StatTotal)')
	matrix list final_indicator13 
	}
	else {
		matrix final_indicator13=J(26,9,.)
	}

	di "---------------- Summary statistics group 14 ----------------"
	*Group 14 : individual level variables - women controle over income, asset, and participation in ag
	* Keep only adult women
	use "$final_data_individual", clear
	keep if female==1
	keep if age>=18
	*count the number of female adult per household to be used in the weight
	qui bysort hhid : egen number_female_hhmember =count (female==1 & age>=18)
	global household_indicators14 control_all_income make_decision_ag own_asset formal_land_rights_f 
	global final_indicator14 ""
	foreach v of global household_indicators14 {
		capture confirm variable  `v'
		if _rc {
			qui gen  `v'=. //IHS 9.23.19 why was this one 0 instead of missing? If gen = . instead of 0, the N in the outputs are also missing so we won't need to delete that later in the spreadsheet. 
		}
		qui gen `v'_female_hh=`v' if  fhh==1
		qui gen `v'_male_hh=`v' if fhh==0
		global final_indicator14 $final_indicator14 `v'  `v'_female_hh  `v'_male_hh 
	}

	qui tabstat ${final_indicator14} [aw=weight] if rural==1 , stat(mean sd  p25 p50 p75  min max N) col(stat) save
	matrix final_indicator14=r(StatTotal)'
	qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered) // get standard errors of the mean
	foreach v in $final_indicator14 {
		local missing_var ""
		qui findname `v' if rural==1, all(@==.) local (missing_var) //IHS 9.23.19
		if "`missing_var'"!="" { 
			qui replace `v'=0
		}	
	}

	matrix semean14=(.)
	matrix colnames semean14=semean_wei
	foreach v of global final_indicator14 {
		qui svy, subpop(if rural==1): mean `v'
		matrix semean14=semean14\(el(r(table),2,1))
	}
	matrix final_indicator14=final_indicator14,semean14[2..rowsof(semean14),.]
	matrix list final_indicator14 
		
	di "---------------- Summary statistics group 15 ----------------"
	*Group 15 : individual level variables - women diet
	* only women in reproductive age
	use "$final_data_individual", clear
	keep if female==1
	drop if age>49
	drop if age<15

	*Also general femal_weigh
	*count the number of female adult per household to be used in the weight
	qui bysort hhid : egen number_female_hhmember =count (female==1 & age<15 & age>49)

	global household_indicators15  number_foodgroup women_diet
	global final_indicator15""
	foreach v of global household_indicators15 {
		capture confirm variable  `v'
		if _rc {
			qui gen  `v'=. 	
		}
		qui gen `v'_female_hh=`v' if  fhh==1
		qui gen `v'_male_hh=`v' if fhh==0
		global final_indicator15 $final_indicator15 `v'  `v'_female_hh  `v'_male_hh 
	}

	qui tabstat ${final_indicator15} [aw=weight], stat(mean sd min p25 p50 p75 max N) col(stat) save
	matrix final_indicator15=r(StatTotal)'
	qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered) // get standard errors of the mean
	foreach v in $final_indicator15 {
			local missing_var ""
			qui findname `v' if rural==1,  all(@==.) local (missing_var) //IHS 9.23.19
			if "`missing_var'"!="" { 
			qui replace `v'=0
			}	
	}
	matrix semean15=(.)
	matrix colnames semean15=semean_wei
	foreach v of global final_indicator15 {
		qui svy, subpop(if rural==1): mean `v'
		matrix semean15=semean15\(el(r(table),2,1))
	}

	matrix final_indicator15=final_indicator15,semean15[2..rowsof(semean15),.]
	matrix list final_indicator15
	
	di "---------------- Summary statistics group 16 ----------------"
	** Group 16 - Use of fertilizer, improved seeds, and vaccing by individual farmers (plot managers or livestock keepers)
	use "$final_data_individual", clear
	global household_indicators16 all_use_inorg_fert female_use_inorg_fert male_use_inorg_fert all_imprv_seed_use female_imprv_seed_use male_imprv_seed_use
	foreach v in $topcropname_area {
		global household_indicators16 $household_indicators16 all_imprv_seed_`v' female_imprv_seed_`v' male_imprv_seed_`v' all_hybrid_seed_`v' female_hybrid_seed_`v' male_hybrid_seed_`v'
	}
	global household_indicators16 $household_indicators16 all_vac_animal female_vac_animal male_vac_animal
	foreach v of global household_indicators16 {
		capture confirm variable  `v'
		if _rc {
			qui gen  `v'=. 	
		}
	}
	qui tabstat ${household_indicators16} [aw=weight] if rural==1 , stat(mean sd  p25 p50 p75  min max N) col(stat) save		
	matrix final_indicator16=r(StatTotal)'
	qui svyset clusterid [pweight=weight], strata(strataid) singleunit(centered) // get standard errors of the mean
	matrix semean16=(.)
	matrix colnames semean16=semean_wei
	foreach v of global household_indicators16 {
		capture confirm variable  `v'
		if _rc {
			qui gen  `v'=. 
		}
		local missing_var ""
		qui findname `v' if rural==1,  all(@==.) local (missing_var) //IHS 9.23.19
		if "`missing_var'"!="" { 
			qui replace `v'=0
		}	
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
	putexcel A1=matrix(final_indicator_exported), names	
}

/**************************************************************
**************SUMMARY STATISTICS WITH LABELS*******************
**************************************************************/
foreach instrument of global list_instruments {
	* List of final files to use in the reporting and output file of summary statistics
	global final_outputfile      "$`instrument'_final_data/`instrument'_summary_stats.xlsx" 
	*** Adding other meta-data
	display "`instrument'"
	import excel "$directory/EPAR_UW_335_master_list_indicators.xlsx", sheet("MASTER_LIST_INDICATORS") firstrow clear 
	tempfile master_list 
	save `master_list'
	
	import excel "$final_outputfile", sheet("Sheet1") firstrow clear
	ren A variableName
	merge 1:1 variableName using `master_list', nogen keep(1 3)
	
  if "`instrument'"=="BurkinaF_EMC_W1" { 
		gen Geography="Burkina Faso" 
		gen Survey="LSMS-ISA"	
		gen Instrument="Burkina Faso EMC Wave 1"
		gen Year="2014"
	}
  
		if "`instrument'"=="Ethiopia_ESS_W5" { 
		gen Geography="Ethiopia" 
		gen Survey="LSMS-ISA"
		gen Instrument="Ethiopia ESS Wave 5"	
		gen Year="2021-22"
	}
	if "`instrument'"=="Ethiopia_ESS_W4" { 
		gen Geography="Ethiopia" 
		gen Survey="LSMS-ISA"
		gen Instrument="Ethiopia ESS Wave 4"	
		gen Year="2018-19"
	}
	if "`instrument'"=="Ethiopia_ESS_W3" { 
		gen Geography="Ethiopia" 
		gen Survey="LSMS-ISA"
		gen Instrument="Ethiopia ESS Wave 3"	
		gen Year="2015-16"
	}
	if "`instrument'"=="Ethiopia_ESS_W2" { 
		gen Geography="Ethiopia" 
		gen Survey="LSMS-ISA"
		gen Instrument="Ethiopia ESS Wave 2"	
		gen Year="2013-14"
	}
	if "`instrument'"=="Ethiopia_ESS_W1" { 
		gen Geography="Ethiopia" 
		gen Survey="LSMS-ISA"
		gen Instrument="Ethiopia ESS Wave 1"	
		gen Year="2011-12"
	}
	
	  if "`instrument'"=="Nigeria_GHS_W5" { 
		gen Geography="Nigeria" 
		gen Survey="LSMS-ISA"
		gen Instrument="Nigeria GHS Wave 5"	
		gen Year="2022-23"
	}
	
  if "`instrument'"=="Nigeria_GHS_W4" { 
		gen Geography="Nigeria" 
		gen Survey="LSMS-ISA"
		gen Instrument="Nigeria GHS Wave 4"	
		gen Year="2018-19"
	}
	if "`instrument'"=="Nigeria_GHS_W3" { 
		gen Geography="Nigeria" 
		gen Survey="LSMS-ISA"
		gen Instrument="Nigeria GHS Wave 3"	
		gen Year="2015-16"
	}
	if "`instrument'"=="Nigeria_GHS_W2" { 
		gen Geography="Nigeria" 
		gen Survey="LSMS-ISA"
		gen Instrument="Nigeria GHS Wave 2"	
		gen Year="2012-13"
	}
	if "`instrument'"=="Nigeria_GHS_W1" { 
		gen Geography="Nigeria" 
		gen Survey="LSMS-ISA"
		gen Instrument="Nigeria GHS Wave 1"	
		gen Year="2010-11"
	}
  
    if "`instrument'"=="Tanzania_NPS_W5" {
    gen Geography="Tanzania"
    gen Survey="LSMS-ISA"
    gen Instrument="Tanzania NPS Wave 5"
    gen Year="2020-21"
  }
  
  if "`instrument'"=="Tanzania_NPS_SDD" {
    gen Geography="Tanzania"
    gen Survey="LSMS-ISA"
    gen Instrument="Tanzania NPS SDD"
    gen Year="2019-20"
  }
	if "`instrument'"=="Tanzania_NPS_W4" { 
		gen Geography="Tanzania" 
		gen Survey="LSMS-ISA"
		gen Instrument="Tanzania NPS Wave 4"	
		gen Year="2014-15"
	}
	if "`instrument'"=="Tanzania_NPS_W3" { 
		gen Geography="Tanzania" 
		gen Survey="LSMS-ISA"
		gen Instrument="Tanzania NPS Wave 3"	
		gen Year="2012-13"
	}
	if "`instrument'"=="Tanzania_NPS_W2" { 
		gen Geography="Tanzania" 
		gen Survey="LSMS-ISA"
		gen Instrument="Tanzania NPS Wave 2"	
		gen Year="2010-11"
	}
	if "`instrument'"=="Tanzania_NPS_W1" { 
		gen Geography="Tanzania" 
		gen Survey="LSMS-ISA"
		gen Instrument="Tanzania NPS Wave 1"	
		gen Year="2008-09"
	}
  
	if "`instrument'"=="Uganda_NPS_W8" {
		gen Geography="Uganda"
		gen Survey="LSMS-ISA"
		gen Instrument="Uganda UNPS Wave 8"
		gen Year="2019-20"
	}
  
  if "`instrument'"=="Uganda_NPS_W7" {
  	gen Geography="Uganda"
		gen Survey="LSMS-ISA"
		gen Instrument="Uganda UNPS Wave 7"
		gen Year = "2018-19"
  }
  
	if "`instrument'"=="Uganda_NPS_W5" {
		gen Geography="Uganda"
		gen Survey="LSMS-ISA"
		gen Instrument="Uganda UNPS Wave 5"
		gen Year = "2015-16"
	}

  if "`instrument'"=="Uganda_NPS_W4" {
		gen Geography="Uganda"
		gen Survey="LSMS-ISA"
		gen Instrument="Uganda NPS Wave 4"
		gen Year="2013-14"
	}
  
	if "`instrument'"=="Uganda_NPS_W3" {
		gen Geography="Uganda"
		gen Survey="LSMS-ISA"
		gen Instrument="Uganda UNPS Wave 3"
		gen Year="2011-12"
	}
	
  if "`instrument'"=="Uganda_NPS_W2" {
		gen Geography="Uganda"
		gen Survey="LSMS-ISA"
		gen Instrument="Uganda UNPS Wave 2"
		gen Year="2010-11"
	}

  
  if "`instrument'"=="Uganda_NPS_W1" {
		gen Geography="Uganda"
		gen Survey="LSMS-ISA"
		gen Instrument="Uganda UNPS Wave 1"
		gen Year="2009-10"
	}
  
  if "`instrument'"=="MWI_IHS_IHPS_W4" {
    gen Geography="Malawi"
    gen Survey="LSMS-ISA"
    gen Instrument="Malawi IHS/IHPS Wave 4"
    gen Year="2019-20"
  }
  
	if "`instrument'"=="MWI_IHS_IHPS_W3" {
		gen Geography="Malawi"
		gen Survey="LSMS-ISA"
		gen Instrument="Malawi IHS/IHPS Wave 3"
		gen Year="2016-17"
	}

if "`instrument'"=="MWI_IHPS_W2" {
	gen Geography="Malawi"
	gen Survey="LSMS-ISA"
	gen Instrument="Malawi IHS/IHPS Wave 2"
	gen Year="2012-13"
}

if "`instrument'"=="MWI_IHS_W1" {
  gen Geography="Malawi"
  gen Survey="LSMS-ISA"
  gen Instrument="Malawi IHS/IHPS Wave 1"
  gen Year="2010-11"
}

	order Geography Survey Instrument Year indicatorcategory indicatorname units commoditydisaggregation genderdisaggregation hhfarmsizedisaggregation ruraltotalpopulation subpopulationforestimate currencyconversion levelofindicator weight variableName mean semean_strata sd p25 p50 p75 min max N 
	gen N_less_30=N<30
	qui recode semean_strata (.=0)
	gen all_zero_2_missing= (mean==0 & semean_strata==0  &  sd==0  &  p25==0  &  p50==0  &  p75==0  &  min==0  & max==0) 
	recode mean semean_strata sd p25 p50 p75 min max N N_less_30 (0=.) if all_zero_2_missing==1
	drop all_zero_2_missing
	save "$`instrument'_final_data/`instrument'_summary_stats_with_labels.dta", replace
}

