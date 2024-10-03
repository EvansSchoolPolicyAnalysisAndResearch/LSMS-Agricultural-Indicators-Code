# Ethiopia ESS/LSMS-ISA Wave 3 (2015-2016)
- ![Incomplete](https://placehold.co/15x15/f03c15/f03c15.png) `Incomplete`
- ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- ![Pending Review](https://placehold.co/15x15/1589F0/1589F0.png) `Pending Review`

## Prerequisites
* Download the raw data from https://microdata.worldbank.org/index.php/catalog/2783
* Extract the files to the "Raw DTA Files" folder in the cloned directory
* Move all the files out of the subfolders into the Raw DTA Files main folder
* Update the paths on lines 62-72 with the correct paths to the raw data and output files if necessary (try running the file first)

## Table of Contents
### Globals 
* This section sets global variables for use later in the script, including
  * **Population:** 
    * Ethiopia_ESS_W3_pop_tot - Total population 
    * Ethiopia_ESS_W3_pop_rur - Rural population (2016 estimate)
    * Ethiopia_ESS_W3_pop_urb - Urban population (2016 estimate)
  * **Exchange Rates**
    * Ethiopia_ESS_W3_exchange_rate - Ethiopia 2017 Exchange Rate (World Bank)
    * Ethiopia_ESS_W3_gdp_ppp_dollar - Ethiopia 2016 PPP (World Bank)
    * Ethiopia_ESS_W3_cons_ppp_dollar - Ethiopia 2016 Cons PPP (World Bank)
    * Ethiopia_ESS_W3_inflation - Ethiopia 2016 CPI / Ethiopia 2017 CPI (World Bank)
  * **Poverty Thresholds**
    * Ethiopia_ESS_W3_poverty_thres (World Bank)
    * Ethiopia_ESS_W3_poverty_ifpri - Ethiopia National Poverty Line in $2017 * inflation / days in the year (World Bank and IFPRI)
    * Ethiopia_ESS_W3_poverty_215
  * **Thresholds for Winsorization:** the smallest (below the 1 percentile) and largest (above the 99 percentile) are replaced with the observations closest to them
  * **Priority Crops:** the top 12 crops by area cultivated (determined by ALL PLOTS later in the code) plus additional crops that are reported on in the ATA report.

### Uniquely Identifiable Geographies
- **Description:** This code creates unique identifiers for zone, woreda, kebele, etc. Note that within regions 1 and 2, for example, there could be a zone 1 in both in the raw data. We want them to be unique so we can collapse on specific zones without always including higher geographic identifiers in the code below. We also need to do this within households. In one household, two different holders and have field 1 for example, but these are different fields. We need all fields and plots within a household to be uniquely identifiable for AgQuery+.
- **Output:** all raw data will get slightly modified and moved to a folder called temp_data. We use temp_data for the rest of the do-file to always distinguish these slightly modified data from the raw data provided by the WB.
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None - this file only needs to get run once at the beginning. Then, you can comment out and just ensure you are using the "raw data" from the temp_data folder and not from the raw_data folder.

### Household IDs
- **Description:** This dataset includes hhid as a unique identifier, along with its location identifiers (i.e. rural, region, zone, woreda, city, subcity, kebele, ea)
- **Output:** Ethiopia_ESS_W3_hhids.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Weights
- **Description:** This dataset includes hhid as a unique identifier and household weight based on survey sample weights. So, if a household has a weight of 40.53772, their household represents about 40 other similar households in Ethiopia.
- **Output:** Ethiopia_ESS_W3_weights.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Individual IDs
- **Description:** This dataset includes personid and hhid as unique identifiers and contains variables that indicate an individual's age, sex, and whether or not they are female, and whether or not they are head of household.
- **Output:** Ethiopia_ESS_W3_person_ids.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None
  
### Individual Gender
- **Description:** This dataset includes individual_id as a unique identifier.
- **Output:** Ethiopia_ESS_W3_gender_merge_both.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Household Size
- **Description:** This dataset includes hhid as a unique identifier, along with its location identifiers (i.e. rural, region, zone, woreda, city, subcity, kebele, ea). The variable strataid generally applies the same strataid to people in the same rural area.The dataset also includes a binary variable (fhh) indicating if a household head is female or not. Weight refers to the original household sample weight. The variable weight_pop_tot refers to survey weights that have been rescaled to match total population. The variable weight_pop_rururb refers to to survey weights that have been rescaled to match rural and urban population. 
- **Output:** Ethiopia_ESS_W3_hhsize.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Strata ID are not consistent across waves due to sampling. Strata ID cannot be used as a way to identify the same geographic location across waves. Also, in other waves, these variables are constructed in section called WEIGHTS AND GENDER OF HEAD. We need to make this consistent across all 5 waves.
  
### Plot Decision Makers
- **Description:** This dataset includes hhid, parcel_id, and field_id as unique identifiers, along with a variable, dm_gender, representing plot decision maker gender (male, female, or mixed). 
- **Output:** Ethiopia_ESS_W3_field_decision_makers.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Individual Engagement in Economic Activities
- **Description:** 
- **Output:** Ethiopia_ESS_W3_plotmanager.dta
- **Coding Status:** ![Incomplete](https://placehold.co/15x15/f03c15/f03c15.png) `Incomplete`
- **Known Issues:** This has not yet been constructed for W3

### All Area Construction
- **Output:**
- Ethiopia_ESS_W3_field_area.dta
      - This dataset includes hhid, parcel_id, and field_id as unique identifiers. The variable area_meas_hectares is field area measured in hectares with missing observations imputed by local medians by region/zone/woreda where possible.
- Ethiopia_ESS_W3_parcel_area.dta
      - This dataset includes hhid, holder_id, and parcel_id as unique identifiers. The variable land_size is the area of each parcel measured in hectares with missing observations imputed by local medians by region/zone/woreda where possible.
- Ethiopia_ESS_W3_household_area.dta
      - This dataset includes hhid as a unique identifier. The variable area_meas_hectares_hh represents total area of all parcels by hhid in hectares with missing observations imputed by local medians by region/zone/woreda where possible.
- Ethiopia_ESS_W3_farm_area.dta
      - This dataset includes hhid as a unique identifier. The variable farm area represents total area of all cultivated by fields by hhid with missing observations imputed by local medians by region/zone/woreda where possible.
- Ethiopia_ESS_W3_fields_agland.dta
      - This dataset includes hhid, holder_id, parcel_id, and field_id as unique identifiers. Agland is a binary variable to indicate whether a field was cultivated, pasture, or fallow. farm_size_agland_field represents field size in hectares for all plots cultivated, fallow, or used for pastureland.
  - Ethiopia_ESS_W3_farmsize_all_agland.dta
      - This dataset includes hhid as a unique identifier. farm_size_agland represents total area of a farm in hectares for all plots cultivated, fallow, or used for pastureland by hhid.
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Crop Unit Conversion Factors
- **Description:** 
- **Output:** 
- **Coding Status:** ![Incomplete](https://placehold.co/15x15/f03c15/f03c15.png) `Incomplete`
- **Known Issues:** This has not yet been constructed for W3.

### All Plots
- **Description:** This dataset includes hhid, parcel_id, and field_id, and crop_code_master as unique identifiers. purestand indicaters whether a crop was monocropped or intercropped/relayed. quant_harv_kg is the quantity harvested of that crop in kilograms. value_harvest is the value of the quantity harvested in Birr. ha_planted is hectares planted of that crop.
- **Output:** Ethiopia_ESS_W3_all_fields.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Gross Crop Revenue
- **Description:** All datasets produced in this section include hhid as a unique identifier. hh_crop_values_production.dta summarizes the value of crop production and sales at the household level. crop_loss.dta summarizes the value of crops lost and the value of crop transportation costs.
- **Output:** 
- Ethiopia_ESS_W3_hh_crop_production.dta
- Ethiopia_ESS_W3_crop_losses.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Crop Expenses
- **Description:** This dataset includes hhid holder_id parcel_id field_id as a unique identifiers. 
- **Output:**
- Ethiopia_ESS_W3_field_labor_days.dta
- Ethiopia_ESS_W3_field_labor.dta
- Ethiopia_ESS_W3_hh_cost_labor.dta
- Ethiopia_ESS_W3_hh_rental_parcel.dta
- Ethiopia_ESS_W3_input_use_dummies.dta
- Ethiopia_ESS_W3_input_quantities.dta
- Ethiopia_ESS_W3_field_cost_inputs_long.dta
- Ethiopia_ESS_W3_field_cost_inputs.dta
- Ethiopia_ESS_W3_field_cost_inputs_wide.dta
- Ethiopia_ESS_W3_hh_cost_inputs_verbose.dta
- Ethiopia_ESS_W3_hh_cost_inputs.dta
- Ethiopia_ESS_W3_monocrop_plots.dta
- Ethiopia_ESS_W3_`cn'_monocrop_hh_area.dta
- Ethiopia_ESS_W3_inputs_`cn'.dta
- **Coding Status:** ![Incomplete](https://placehold.co/15x15/f03c15/f03c15.png) `Incomplete`
- **Known Issues:** Animal, animal feed, mechanization, and irrigation expenses are not currently included in this - need to update to include. Other countries/waves cannot construct irrigation expenses but we can in W3.

### Livestock Income
- **Description:** lrum_expenses.dta includes hhid as unique identifier and lrun which represents the total expenses associated with large ruminants (dairy cows) which includes fodder, water, vaccines, curative treatment, and breeding costs. | 
- **Output:** Ethiopia_ESS_W3_self_lrum_expenses.dta ; 
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Self-Employment Income
- **Description:** self_employment_income.dta includes hhid as a unique identifier. annual_selfemp_profit is the household's annual profit from self-employment income, including cases where households have negative profits. business_owners_ind.dta includes hhid and personid as unique identifiers. business_owner is a binary variable that refers to whether or not that person is a business owner.
- **Output:** Ethiopia_ESS_W3_self_employment_income.dta ; Ethiopia_ESS_W3_business_owners_ind.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Wage Income
- **Description:** wage_worker.dta includes hhid and personid as unique identifiers. wage_worker is a binary variable indicating whether or not that household member earned non ag-wage income over that past year. | wage_income.dta includes hhid as a unique identifier. annual_salary is the household's annual income from non-ag wage income. | agworker.dta includes hhid and personid as unique identifiers. agworker is a binary variable indicating whether that household member was an agworker in the past year. | ag_wage_income.dta includes hhid as a unique identifer. annual_salary_agwage is the household's annual income from ag-wage income.
- **Output:** Ethiopia_ESS_W3_wage_worker.dta ; Ethiopia_ESS_W3_wage_income.dta ; Ethiopia_ESS_W3_agworker.dta ; Ethiopia_ESS_W3_ag_wage_income.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** 

### Other Income
- **Description:** other_income.dta includes hhid as a unique identifer. transfer_ pension_ investment_ rental_ sales_ and inheritance_income sum the total number of other types of income a household earned in the past year. | assistance_income.dta includes hhid as a unique identifier. psnp_income is income from PSNP over the last year. assistance_income is other income assistance received by a hh over the last year. |land_rental_income.dta includes hhid as a unique identifier. land_rental_income_upfront is an estimate of annual value of hh income from cash and in-kind payments combined paid from other's renting out land - this includes upfront payments only.
- **Output:** Ethiopia_ESS_W3_other_income.dta ; Ethiopia_ESS_W3_assistance_income.dta ; Ethiopia_ESS_W3_land_rental_income.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Off-Farm Hours
- **Description:** This dataset includes hhid as a unique identifiers. 
- **Output:** Ethiopia_ESS_W3_off_farm_hours.dta, Ethiopia_ESS_W3_field_labor.dta, 
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Farm Labor
- **Description:** This dataset includes hhid as a unique identifier and summarizes the number of labor days disaggregated by type of laborer (hired, family [includes family and nonhired], total) and gender of hired labor.
- **Output:** Ethiopia_ESS_W3_off_farm_hours.dta, Ethiopia_ESS_W3_field_labor.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None
- 
### Vaccine Usage
- **Description:** vaccine.dta includes hhid and personid as unique identifiers. Constructs indicators relating to livestock vaccination. vac_animal is a binary variable indicating whether the household has an animal vaccinated. vac_animal_lrum is a binary variable indicating whether the household has vaccinated large ruminants. vac_animal_srum is a binary variable indicating whether the household has vaccinated small ruminants. vac_animal_camels is a binary variable indicating whether the household has vaccinated camels. vac_animal_equine is a binary variable indicating whether the household has vaccinated equines. vac_animal_poultry is a binary variable indicating whether the household has vaccinated poultry. farmer_vaccine.dta includes hhid and personid as unique identifiers. all_vac_animal a binary variable indicating whether Individual farmer (livestock keeper) uses vaccines. female_vac_animal a binary variable indicating whether Individual female farmers (livestock keeper) uses vaccines. male_vac_animal a binary variable indicating whether Individual male farmers (livestock keeper) uses vaccines. livestock_keeper is a binary variable indicating whether the individual is listed as a livestock keeper (at least one type of livestock).
- **Output:** Ethiopia_ESS_W3_vaccine, Ethiopia_ESS_farmer_vaccine
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Animal Health
- **Description:** 
- **Output:**
- **Coding Status:** ![Incomplete](https://placehold.co/15x15/f03c15/f03c15.png) `Incomplete`
- **Known Issues:** Cannot be constructed in Ethiopia W3

### Livestock Water, Feeding, and Housing
- **Description:** This dataset includes hhid as a unique identifier and a series of binary variables indicating how households fed held livestock whether by grazing, feed, or both. It also includes variables for how household housed different livestock.
- **Output:** Ethiopia_ESS_W3_livestock_feed_water_house.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Plot Managers
- **Description:** imprvseed_crop.dta includes hhid and personid as U.I.s. farmer_improvedseed_use.dta includes hhid and personid as U.I.s. The data describe whether a farmer grows a particular crop and whether they used all improved or hybrid seeds for those crops. input_use.dta includes hhid as a unique identifier with binary indicators for whether that household uses particular inputs on any field. farmer_fert_use includes hhid and personid as unique identifiers and binary variables for whether that farmer uses particular inputs on any field.
- **Output:** Ethiopia_ESS_W3_imprvseed_crop.dta; Ethiopia_ESS_W3_farmer_improvedseed_use.dta; Ethiopia_ESS_W3_input_use.dta ; Ethiopia_ESS_W3_farmer_fert_use
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** 

### Reached by Ag Extension
- **Description:** This dataset includes hhid a as unique identifier. ext_reach_all is a binary variable indicating whether or not the household was reached by extension services - all sources.
- **Output:** Ethiopia_ESS_W3_any_ext.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Source of extension is not asked. We cannot generate variables indicating the different sources of extension.

### Mobile Ownership
- **Description:** This dataset includes hhid as a unique identifier and summarizes whether at least one person in the household owns a mobile phone and the number of mobiles owned per household.
- **Output:** Ethiopia_2016_mobile_own.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Irrigation
- **Description:** This dataset includes hhid as a unique identifier and provides a binary indicator for whether a household uses irrigation for at least one purpose, the nubmer of hectares irrigated by a household, and the share of area planted irrigated by a household. We also disaggregate these estimates by gender of decision makers of fields. We construct Winsorized variables in this section (rather than Household Variables) because we need to winsorize the denominator (hectares planted), not the proportion of area planted irrigated by household.
- **Output:** Ethiopia_ESS_W3_irrigation.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Formal Financial Services Use
- **Description:** This dataset includes hhid as a unique identifier and series of binary variables indicating whether a household accesses different types of financial services (e.g. bank, credit, insurance, digital financial services, savings, or all of the above).
- **Output:** Ethiopia_ESS_W3_fin_serv.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Milk Productivity
- **Description:** This dataset includes hhid as a unique identifier. milk_animals is the total number of cows milked per household. liter_per_cow is the average quantity (liters) of milk produced per cow per year.
- **Output:** Ethiopia_ESS_W3_milk_animals.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Egg Productivity
- **Description:** This dataset includes hhid as a unique identifier. hen_total is the total number of laying hens per household. eggs_total_year is the total number of eggs that were produced by the household over the year.
- **Output:** Ethiopia_ESS_W3_eggs_animals.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Crop Production Costs Per Hectare
- **Description:** This dataset includes hhid as a unique identifier. the file delineates explicit and total costs by area planted and area harvested, separating costs by plots that were cultivated by female, male, or mixed decision makers.
- **Output:** Ethiopia_ESS_W3_cropcosts.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Rate of Fertilizer Application
- **Description:** This dataset includes case_id as a unique identifier and several variables that describe fertilizer, pesticide, and herbicide application by weight, hectares planted, and head of household gender.
separating costs by plots that were cultivated by female, male, or mixed decision makers. We construct winsorized variables in this section (rather than Household Variables) because we need to winsorize the denominator (hectares planted), not the rate of fert/pest/herb/fung application per hectared planted.
- **Output:** Ethiopia_ESS_W3_fertilizer_application.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** This section is technically complete based on our current standard and construction of rate of fert application - but we can revisit this to make it more accurate based on bulk densities of ferts.

### Women's Diet Quality
- **Description:** 
- **Output:**
- **Coding Status:** ![Incomplete](https://placehold.co/15x15/f03c15/f03c15.png) `Incomplete`
- **Known Issues:** Cannot be constructed in Ethiopia W3

### Dietary Diversity
- **Description:** This dataset includes hhid as a unique identifiers. number_foodgroup is number of food groups household consumed last week (household dietary diversity). household_diet_cut_off1 is a binary variable indicating whether or not the household consumed at least 6 of the 12 food groups in the last week. household_diet_cut_off2 is a binary variable indicating whether or not the household at least 8 of the 12 food groups in the last week.
- **Output:** Ethiopia_ESS_W3_household_diet.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Women's Ownership of Assets
- **Description:** This dataset includes hhid and individual_id as unique identifiers and includes indicators to the individuals gender and whether they own any asset.
- **Output:** Ethiopia_ESS_W3_own_asset.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Women's Agricultural Decision-Making
- **Description:** This dataset includes hhid as a unique identifier. women_decision_crop is a binary variable indicating whether or not that female household member makes decisions about crop activities. women_decision_livestock is a binary variable indicating whether or not that female household member makes decisions about livestock activities. women_decision_ag is a binary variable indicating whether or not that female household member makes decisions about agricultural (both crop and livestock) activities. 
- **Output:** Ethiopia_ESS_W3_ag_decision.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Informtion on women's control over livestock and permanent crop sales is not available.
  
### Women's Control Over Income
- **Description:** This dataset includes hhid as a unique identifier. control_cropincome is a binary variable indicating whether or not that female household member control over crop income. control_livestockincome is a binary variable indicating whether not or that female household member has control over livestock income. control_farmincome is a binary variable indicating whether or not that female household member has control over farm (crop or livestock) income. control_businessincome is a binary variable indicating whether or not that female household member has control over business income. control_nonfarmincome is a binary variable indicating whether or not that female household member has control over non-farm (business or remittances) income. control_all_income is a binary variable indicating whether or that female household member has control over at least one type of income.
- **Output:** Ethiopia_ESS_W3_control_income.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Informtion on women's control over livestock sales is not available.

### Agricultural Wages
- **Description:** This dataset includes hhid as a unique identifiers. wage_paid_aglabor is the daily agricultural wage paid for hired labor in the local currency. wage_paid_aglabor_female is the daily agricultural wage paid for hired female labor in the local currency. wage_paid_aglabor_male is the daily agricultural wage paid for hired male labor in the local currency.
- **Output:** Ethiopia_ESS_W3_ag_wage.dta 
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Crop Yields
- **Description:** This dataset summarizes the area planted (in hectares) and amount harvested (in kilograms) by crop by household. We further disaggregate these figures by gender of decision makers and whether a crop came from purestand or intercropped (mixed) fields.
- **Output:** Ethiopia_ESS_W3_hh_crop_values_production_type_crop.dta 
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Shannon Diversity Index
- **Description:** Taking into account crops grown, this dataset produces an indicator on how diverse a household's crop production is using the Shannon Diversity Index (number of crop species per household). We further disaggregate these estimates by gender of decision maker.
- **Output:** Ethiopia_ESS_W3_shannon_diversity_index.dta 
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Consumption
- **Description:** This dataset includes hhid as a unique identifier. peraeq_cons is the household consumption per adult equivalent per year. daily_peraeq_cons is the household consumption per adult equivalent per day. percapita_cons is the household consumption per household member per year and daily_percap_cons is the household consumption per household member per day
- **Output:** Ethiopia_ESS_W3_consumption.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** 

### Household Food Provision
- **Description:** This dataset inclues hhid as a unique identifier and contains indicators on the number of months a family was food insecure over the past year.
- **Output:** Ethiopia_ESS_W3_food_insecurity.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Household Assets
- **Description:** 
- **Output:**
- **Coding Status:** ![Incomplete](https://placehold.co/15x15/f03c15/f03c15.png) `Incomplete`
- **Known Issues:** Cannot be constructed in Ethiopia W3

### Distance to Agro Dealers
- **Description:** 
- **Output:** 
- **Coding Status:** ![Incomplete](https://placehold.co/15x15/f03c15/f03c15.png) `Incomplete`
- **Known Issues:** Cannot be constructed in Ethiopia W3

### Crop Rotation
- **Description:** This dataset includes hhid as a unique indentifier and constructs an indicator for whether at least one holder in the household rotates crops on a land holding.
- **Output:** Ethiopia_ESS_W1_household_crop_rotation.dta
- **Coding Status:** ![Incomplete](https://placehold.co/15x15/f03c15/f03c15.png) `Incomplete`
- **Known Issues:** Needs to get constructed for W1

### Household Variables
- **Description:** This dataset compresses all variables at the household-level into one dataset, winsorize indicators that have not yet been winsorized.
- **Output:** Ethiopia_ESS_W3_household_variables.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Users can adjust the kept variables at the end to keep other variables of interest.

### Individual Variables
- **Description:** This dataset compresses all variables at the individual-level into one dataset, winsorize indicators that have not yet been winsorized.
- **Output:** Ethiopia_ESS_W3_individual_variables.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** This dataset is not as comprehensive as household variables. EPAR intends to make these indicators more comprehensive in the future.

### Field Level Variables
- **Description:** This dataset compresses all variables at the field-level into one dataset, winsorize indicators that have not yet been winsorized.
- **Output:** Ethiopia_ESS_W3_field_plot_variables.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Summary Statistics
- **Description:** This dataset compresses all the pre-processed files for households, individuals, and plots in the sample. The summary statistics are outputted only for the sub_population of households, individuals, and plots in rural areas.
- **Output:** None
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None
