# Ethiopia ESS/LSMS-ISA Wave 5 (2021-2022)
- ![Incomplete](https://placehold.co/15x15/f03c15/f03c15.png) `Incomplete`
- ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- ![Pending Review](https://placehold.co/15x15/1589F0/1589F0.png) `Pending Review`

## Prerequisites
* Download the raw data from [https://microdata.worldbank.org/index.php/catalog/3557](https://microdata.worldbank.org/index.php/catalog/6161)
* Extract the files to the "Raw DTA Files" folder in the cloned directory
* Create sub-folders in the 'Raw DTA Files" (if desired) to align with current referenced file paths throughout the code (e.g. Household vs. Post Planting, etc.)
* Update the paths on lines 61-69 with the correct paths to the raw data and output files

## Table of Contents
### Globals 
* This section sets global variables for use later in the script, including
  * **Population:** We reference true rural and urban population estimates to re-weight households.
    * Ethiopia_ESS_W5_pop_tot - Total population in 2010 (World Bank)
    * Ethiopia_ESS_W5_pop_rur - Rural population in 2010 (World Bank)
    * Ethiopia_ESS_W5_pop_urb - Urban population in 2010 (World Bank)
  * **Exchange Rates**
    * Ethiopia_ESS_W5_exchange_rate - Ethiopia 2017 Exchange Rate (World Bank)
    * Ethiopia_ESS_W5_gdp_ppp_dollar - Ethiopia 2022 PPP (World Bank)
    * Ethiopia_ESS_W5_cons_ppp_dollar - Ethiopia 2022 Cons PPP (World Bank)
    * Ethiopia_ESS_W5_inflation - Ethiopia 2022 CPI / Ethiopia 2017 CPI (World Bank)
  * **Poverty Thresholds**
    * Ethiopia_ESS_W5_poverty_thres (World Bank)
    * Ethiopia_ESS_W5_poverty_ifpri - Ethiopia National Poverty Line in $2017 * inflation / days in the year (World Bank and IFPRI)
    * Ethiopia_ESS_W5_poverty_215
  * **Thresholds for Winsorization:** the smallest (below the 1 percentile) and largest (above the 99 percentile) are replaced with the observations closest to them
  * **Priority Crops:** the top 12 crops by area cultivated (determined by ALL PLOTS later in the code) plus additional crops that are reported on in the ATA report.
  * ![Pending Review](https://placehold.co/15x15/1589F0/1589F0.png) `Pending Review` - I need to verify whether we should be using 2021 or 2022 values for exchange rates and poverty thresholds!

### Uniquely Identifiable Geographies
- **Description:** This code creates unique identifiers for zone, woreda, kebele, etc. Note that within regions 1 and 2, for example, there could be a zone 1 in both in the raw data. We want them to be unique so we can collapse on specific zones without always including higher geographic identifiers in the code below. We also need to do this within households. In one household, two different holders and have field 1 for example, but these are different fields. We need all fields and plots within a household to be uniquely identifiable for AgQuery+.
- **Output:** all raw data will get slightly modified and moved to a folder called temp_data. We use temp_data for the rest of the do-file to always distinguish these slightly modified data from the raw data provided by the WB.
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None - this file only needs to get run once at the beginning. Then, you can comment out and just ensure you are using the "raw data" from the temp_data folder and not from the raw_data folder.

### Household IDs
- **Description:** This dataset includes hhid as a unique identifier, along with its location identifiers (i.e. rural, region, zone, woreda, city, subcity, kebele, ea)
- **Output:** Ethiopia_ESS_W5_hhids.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Urban households are oversampled so it is imperative we use weights! Based on the BID, there are 40 households that got surveyed in PP and Livestock, but not PH, Household, etc. We supplement the household roster with these households in the post-planting survey.

### Weights
- **Description:** This dataset includes hhid as a unique identifier and household weight based on survey sample weights. So, if a household has a weight of 40.53772, their household represents about 40 other similar households in Ethiopia.
- **Output:** Ethiopia_ESS_W5_weights.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Urban households are oversampled so it is imperative we use weights! Why not just use the hhids file we create above? This is currently missing those 40 households that were surveyed in PP and Livestock but not PH, Household, etc.

### Weights and Gender of Head
- **Description:** This dataset includes hhid as a unique identifier, along with its location identifiers (i.e. rural, region, zone, woreda, city, subcity, kebele, ea). The variable strataid refers to ![Improve Documentation](https://placehold.co/15x15/f03c15/f03c15.png) `Improve Documentation` The dataset also includes a binary variable (fhh) indicating if a household head is female or not. Weight refers to the original household sample weight. The variable weight_pop_tot refers to survey weights that have been rescaled to match total population. The variable weight_pop_rururb refers to to survey weights that have been rescaled to match rural and urban population. 
- **Output:** Ethiopia_ESS_W5_male_head.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** At the end, we drop weight_pop_rururb and end up just using original survey weights. We still need to figure out how to properly adjust weights. Since no households were interviewed in Tigray, we need to adjust the population globals to NOT include Tigray population total or in rural and urban areas. Have not been able to find reliable data to do this. The last census with such information was from 2007.

### Individual IDs
- **Description:** This dataset includes personid and hhid as unique identifiers and contains variables that indicate an individual's age, sex, and whether or not they are female, and whether or not they are head of household.
- **Output:** Ethiopia_ESS_W5_person_ids.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Based on the BID, there are 40 households (and 277 individuals) that got surveyed in PP and Livestock, but not PH, Household, etc. We supplemented the household roster with these individuals in the post-planting survey.
  
### Individual Gender
- **Description:** This dataset includes individual_id as a unique identifier.
- **Output:** Ethiopia_ESS_W5_gender_merge_both.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Revisit this when reach individual variables - see if this or the Individual IDs file is extraneous.

### Household Size
- **Description:** This dataset includes hhid as a unique identifier. hh_members summarizes the number of household members.
- **Output:** Ethiopia_ESS_W5_hhsize.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:**
- We are not currently merging in 40 households not surveyed in hh, but surveyed in pp. Do we want to supplement?
- At the end, we drop weight_pop_rururb and end up just using original survey weights. We still need to figure out how to properly adjust weights. Since no households were interviewed in Tigray, we need to adjust the population globals to NOT include Tigray population total or in rural and urban areas. Have not been able to find reliable data to do this. The last census with such information was from 2007.
- Also, double check whether we want to do re-weights here - pretty sure we do.
- We don't currently keep the variables for the number of women and adult women in the house. Do we want to keep these?
  
### Plot Decision Makers
- **Description:** This dataset includes hhid, parcel_id, and field_id as unique identifiers, along with a variable, dm_gender, representing plot decision maker gender (male, female, or mixed). 
- **Output:** Ethiopia_ESS_W5_field_decision_makers.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### All Area Construction
- **Output:**
- Ethiopia_ESS_W5_field_area.dta
      - This dataset includes hhid, parcel_id, and field_id as unique identifiers. The variable area_meas_hectares is field area measured in hectares with missing observations imputed by local medians by region/zone/woreda where possible. **Known Issues:** May require clean-up as we currently have many variables that we likely do not need. Also, one observation is 80 hectares which seems like a mistake. Need to decide whether to drop or winsorize that value. We also may want to go back and see if we can't make more matched with the conversion factor file. Right now, we only have cfs for land size units 3-6 (timad, boy, senga, and kert). We make very few matches with the conversion factor file so we may want to discuss borrowing conversion from other region/zone/woreda combinations where appropriate.
- Ethiopia_ESS_W5_parcel_area.dta
      - This dataset includes hhid, holder_id, and parcel_id as unique identifiers. The variable land_size is the area of each parcel measured in hectares with missing observations imputed by local medians by region/zone/woreda where possible.
- Ethiopia_ESS_W5_household_area.dta
      - This dataset includes hhid as a unique identifier. The variable area_meas_hectares_hh represents total area of all parcels by hhid in hectares with missing observations imputed by local medians by region/zone/woreda where possible.
- Ethiopia_ESS_W5_farm_area.dta
      - This dataset includes hhid as a unique identifier. The variable farm area represents total area of all cultivated by fields by hhid with missing observations imputed by local medians by region/zone/woreda where possible.
- Ethiopia_ESS_W5_fields_agland.dta
      - This dataset includes hhid, holder_id, parcel_id, and field_id as unique identifiers. Agland is a binary variable to indicate whether a field was cultivated, pasture, or fallow. farm_size_agland_field represents field size in hectares for all plots cultivated, fallow, or used for pastureland.
  - Ethiopia_ESS_W5_farmsize_all_agland.dta
      - This dataset includes hhid as a unique identifier. farm_size_agland represents total area of a farm in hectares for all plots cultivated, fallow, or used for pastureland by hhid.
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Note that area variables look bigger in W4 and W5 compared to W1-W3. Trying to figure out why this jump is occuring. Also, note that previous waves of Ethiopia does not construct field_size (which is gps meas and replaced wtih self reported data if gps measurements are not available). Other waves in ETH need to go back to this and use W5 as a model.

### Crop Unit Conversion Factors
- **Description:** This dataset includes region, crop_code, and unit as unique identifiers. nat_cf refers to the national conversion factor (to kilograms) for that crop_code/unit and conversion refers to the conversion factor (to kilograms) for that region/crop_code/conversion.
- **Output:** Ethiopia_ESS_W5_cf.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** ENSET ESIR MEDIUM (crop/unit combo) has duplicate observations with different values. W4 uses the 4.34 conversion factor rather than 6.125 - going with the 4.34 since W4 uses that one!

### All Plots
- **Description:** This dataset includes hhid, parcel_id, and field_id, and crop_code_master as unique identifiers. purestand indicaters whether a crop was monocropped or intercropped/relayed. quant_harv_kg is the quantity harvested of that crop in kilograms. value_harvest is the value of the quantity harvested in Birr. ha_planted is hectares planted of that crop.
- **Output:** Ethiopia_ESS_W5_all_fields.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Need to revisit months_grown - looks weird with some negative values. Do we need reason_loss and crops_plot for eth? I took these out but I can add back in if needed.

### Crop Expenses
- **Description:** This dataset includes hhid holder_id parcel_id field_id as a unique identifiers. 
- **Output:**
- Ethiopia_ESS_W5_field_labor_days.dta
- Ethiopia_ESS_W5_field_labor.dta
- Ethiopia_ESS_W5_hh_cost_labor.dta
- Ethiopia_ESS_W5_hh_rental_parcel.dta
- Ethiopia_ESS_W5_input_use_dummies.dta
- Ethiopia_ESS_W5_input_quantities.dta
- Ethiopia_ESS_W5_field_cost_inputs_long.dta
- Ethiopia_ESS_W5_field_cost_inputs.dta
- Ethiopia_ESS_W5_field_cost_inputs_wide.dta
- Ethiopia_ESS_W5_hh_cost_inputs_verbose.dta
- Ethiopia_ESS_W5_hh_cost_inputs.dta
- Ethiopia_ESS_W5_monocrop_plots.dta
- Ethiopia_ESS_W5_`cn'_monocrop_hh_area.dta
- Ethiopia_ESS_W5_inputs_`cn'.dta
- **Coding Status:** ![Incomplete](https://placehold.co/15x15/f03c15/f03c15.png) `Incomplete`
- **Known Issues:** None

### Livestock Income
- **Description:** lrum_expenses.dta includes hhid as unique identifier and lrun which represents the total expenses associated with large ruminants (dairy cows) which includes fodder, water, vaccines, curative treatment, and breeding costs. | 
- **Output:** Ethiopia_ESS_W5_self_lrum_expenses.dta ; 
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** W4 (model) code did not include column f. We need to go back to W4 and add that because it is currently understating self-employment expenses by a little bit.

### Self-Employment Income
- **Description:** self_employment_income.dta includes hhid as a unique identifier. annual_selfemp_profit is the household's annual profit from self-employment income, including cases where households have negative profits. business_owners_ind.dta includes hhid and personid as unique identifiers. business_owner is a binary variable that refers to whether or not that person is a business owner.
- **Output:** Ethiopia_ESS_W5_self_employment_income.dta ; Ethiopia_ESS_W5_business_owners_ind.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** W4 (model) code did not include column f. We need to go back to W4 and add that because it is currently understating self-employment expenses by a little bit.

### Wage Income
- **Description:** wage_worker.dta includes hhid and personid as unique identifiers. wage_worker is a binary variable indicating whether or not that household member earned non ag-wage income over that past year. | wage_income.dta includes hhid as a unique identifier. annual_salary is the household's annual income from non-ag wage income. | agworker.dta includes hhid and personid as unique identifiers. agworker is a binary variable indicating whether that household member was an agworker in the past year. | ag_wage_income.dta includes hhid as a unique identifer. annual_salary_agwage is the household's annual income from ag-wage income.
- **Output:** Ethiopia_ESS_W5_wage_worker.dta ; Ethiopia_ESS_W5_wage_income.dta ; Ethiopia_ESS_W5_agworker.dta ; Ethiopia_ESS_W5_ag_wage_income.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** wage_worker.dta and agworker.dta need clean-up - what variables do we want from this? Just want to keep the ones we want.

### Other Income
- **Description:** other_income.dta includes hhid as a unique identifer. transfer_ pension_ investment_ rental_ sales_ and inheritance_income sum the total number of other types of income a household earned in the past year. | assistance_income.dta includes hhid as a unique identifier. psnp_income is income from PSNP over the last year. assistance_income is other income assistance received by a hh over the last year. |land_rental_income.dta includes hhid as a unique identifier. land_rental_income_upfront is an estimate of annual value of hh income from cash and in-kind payments combined paid from other's renting out land - this includes upfront payments only.
- **Output:** Ethiopia_ESS_W5_other_income.dta ; Ethiopia_ESS_W5_assistance_income.dta ; Ethiopia_ESS_W5_land_rental_income.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Off-Farm Hours
- **Description:** This dataset includes hhid as a unique identifiers. 
- **Output:** Ethiopia_ESS_W5_off_farm_hours.dta, Ethiopia_ESS_W5_field_labor.dta, 
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Vaccine Usage
- **Description:** vaccine.dta includes hhid and personid as unique identifiers. Constructs indicators relating to livestock vaccination. vac_animal is a binary variable indicating whether the household has an animal vaccinated. vac_animal_lrum is a binary variable indicating whether the household has vaccinated large ruminants. vac_animal_srum is a binary variable indicating whether the household has vaccinated small ruminants. vac_animal_camels is a binary variable indicating whether the household has vaccinated camels. vac_animal_equine is a binary variable indicating whether the household has vaccinated equines. vac_animal_poultry is a binary variable indicating whether the household has vaccinated poultry. farmer_vaccine.dta includes hhid and personid as unique identifiers. all_vac_animal a binary variable indicating whether Individual farmer (livestock keeper) uses vaccines. female_vac_animal a binary variable indicating whether Individual female farmers (livestock keeper) uses vaccines. male_vac_animal a binary variable indicating whether Individual male farmers (livestock keeper) uses vaccines. livestock_keeper is a binary variable indicating whether the individual is listed as a livestock keeper (at least one type of livestock).
- **Output:** Ethiopia_ESS_W5_vaccine, Ethiopia_ESS_farmer_vaccine
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Livestock Water, Feeding, and Housing
- **Description:** This dataset includes hhid as a unique identifier. feed_grazing_dry is a binary variable indicating whether the household feeds livestock only or mainly by grazing in the dry season. feed_grazing_rainy is a binary variable indicating whether the household feeds livestock only or mainly by grazing in the rainy season. feed_grazing is a binary variable indicating whether the household feeds livestock only or mainly by grazing. feed_grazing_lrum is a binary variable indicating whether the household feeds large ruminants only or mainly by grazing. feed_grazing_srum is a binary variable indicating whether the household feeds small ruminants only or mainly by grazing. feed_grazing_camels is a binary variable indicating whether the household feeds camels only or mainly by grazing. feed_grazing_equine is a binary variable indicating whether the household feeds equine only or mainly by grazing. feed_grazing_poultry is a binary variable indicating whether the household feeds poultry only or mainly by grazing.  
- water_source_nat is a binary variable indicating whether the household water livestock using a natural source. water_source_const is a binary variable indicating whether the household water livestock using a constructed source. water_source_cover is a binary variable indicating whether the household water livestock using a covered source. water_source_nat_dry is a binary variable indicating whether the household water livestock using a natural source during the dry season. water_source_nat_rainy is a binary variable indicating whether the household water livestock using a natural source during the rainy season. water_source_const_dry is a binary variable indicating whether the household water livestock using a constructed source during the dry season. water_source_const_rainy is a binary variable indicating whether the household water livestock using a constructed source during the rainy season. water_source_cover_dry is a binary variable indicating whether the household water livestock using a covered source during the dry season. water_source_cover_rainy is a binary variable indicating whether the household water livestock using a covered source during the rainy season. water_source_nat_lrum is a binary variable indicating whether the household water large ruminants using a natural source. water_source_nat_srum is a binary variable indicating whether the household water small ruminants using a natural source. water_source_nat_camels is a binary variable indicating whether the household water camels using a natural source. water_source_nat_equine is a binary variable indicating whether the household water equine using a natural source. water_source_nat_poultry is a binary variable indicating whether the household water poultry using a natural source. water_source_const_lrum is a binary variable indicating whether the household water large ruminants using a constructed source. water_source_const_srum is a binary variable indicating whether the household water small ruminants using a constructed source. water_source_const_camels is a binary variable indicating whether the household water camels using a constructed source. water_source_const_equine is a binary variable indicating whether the household water equine using a constructed source. water_source_const_poultry is a binary variable indicating whether the household water poultry using a constructed source. water_source_cover_lrum is a binary variable indicating whether the household water large ruminants using a covered source. water_source_cover_srum is a binary variable indicating whether the household water small ruminants using a covered source. water_source_cover_camels is a binary variable indicating whether the household water camels using a covered source. water_source_cover_equine is a binary variable indicating whether the household water equine using a covered source. water_source_cover_poultry is a binary variable indicating whether the household water poultry using a covered source.
- lvstck_housed is a binary variable indicating whether the household used enclosed housing system for livestock. lvstck_housed_lrum is a binary variable indicating whether the household used enclosed housing system for large ruminants. is a binary variable indicating whether the household used small ruminants. lvstck_housed_camels is a binary variable indicating whether the household used enclosed housing system for camels. lvstck_housed_equine is a binary variable indicating whether the household used enclosed housing system for equines. lvstck_housed_poultry is a binary variable indicating whether the household used enclosed housing system for poultry.
- **Output:** Ethiopia_ESS_W5_livestock_feed_water_house.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Inorganic Fertilizer Use
- **Description:** This dataset includes hhid and personid as unique identifiers. all_use_inorg_fert is a binary variable indicating whether the individual farmer (plot manager) uses inorganic fertilizer. use_inorgfert_urea is a binary variable indicating whether the individual farmer (plot manager) uses inorganic fertilizer - Urea. use_inorgfert_DAP is a binary variable indicating whether the individual farmer (plot manager) uses inorganic fertilizer - DAP. use_inorgfert_NPS is a binary variable indicating whether the individual farmer (plot manager) uses inorganic fertilizer - NPS. use_inorgfert_others is a binary variable indicating whether the individual farmer (plot manager) uses inorganic fertilizer - others. male_use_inorg_fert is a binary variable indicating whether the individual male farmer (plot manager) uses inorganic fertilizer. female_use_inorg_fert is a binary variable indicating whether the individual female farmer (plot manager) uses inorganic fertilizer. 
- **Output:** Ethiopia_ESS_W5_farmer_fert_use.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Improved Seed Use
- **Description:** - improvedseed_use.dta includes hhid as a unique identifier. imprv_seed_use is a binary variable to indicate whether the household uses improved seeds. imprv_seed_maize is a binary variable to indicate whether the household uses improved maize seeds. imprv_seed_wheat is a binary variable to indicate whether the household uses improved wheat seeds. imprv_seed_sorgum is a binary variable to indicate whether the household uses improved sorgum seeds. imprv_seed_millet is a binary variable to indicate whether the household uses improved millet seeds. imprv_seed_grdnt is a binary variable to indicate whether the household uses improved groundnut seeds. imprv_seed_beans is a binary variable to indicate whether the household uses improved beans seeds. imprv_seed_swtptt imprv_seed_use is a binary variable to indicate whether the household uses improved sweet potato seeds. imprv_seed_cassav is a binary variable to indicate whether the household uses improved cassava seeds. imprv_seed_banana is a binary variable to indicate whether the household uses improved banana seeds. imprv_seed_teff is a binary variable to indicate whether the household uses improved teff seeds. imprv_seed_barley is a binary variable to indicate whether the household uses improved barley seeds. imprv_seed_coffee is a binary variable to indicate whether the household uses improved coffee seeds. imprv_seed_sesame is a binary variable to indicate whether the household uses improved sesame seeds. imprv_seed_hsbean is a binary variable to indicate whether the household uses improved horsebean seeds. imprv_seed_nueg is a binary variable to indicate whether the household uses improved niger seeds.
- farmer_improvedseed_use_`cn'.dta are a series of data files for each priorty crop. They include hhid parcel_id field_id holder_id crop_id as unique identifiers. all_imprv_seed_use is a binary variable to indicate whether the individual farmer (plot manager) uses improved seeds. male_imprv_seed_use is a binary variable to indicate whether the individual male farmer (plot manager) uses improved seeds. female_imprv_seed_use is a binary variable to indicate whether the individual female farmer (plot manager) uses improved seeds.
- **Output:** Ethiopia_ESS_W5_improvedseed_use.dta, Ethiopia_ESS_W5_farmer_improvedseed_use_`cn'.dta for all global priority crops
- **Coding Status:** ![Incomplete](https://placehold.co/15x15/f03c15/f03c15.png) `Incomplete`
- **Known Issues:** 

### Reached by Ag Extension
- **Description:** This dataset includes hhid a as unique identifier. ext_reach_all is a binary variable indicating whether or not the household was reached by extension services - all sources. qtypesticide is the quantity of pesticide used by the household. qtyherbicide is the quantity of herbicide used by the household. qtyfungicide is the quantity of fungicide used by the household. usetractor is a binary variable indicating whether or not the household used a tractor. useirrigation is a binary variable indicating whether or not the household used a irrigation. cost_irrig is the household cost of irrigation related activities. cost_tractor_rent is the househod cost of renting a tractor. cost_tractor_main is the household cost of maintaining a tractor.
- **Output:** Ethiopia_ESS_W5_any_ext.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Source of extension is not asked! We cannot generate variables indicating the different sources of extension.

### Plot Managers
- **Description:** imprvseed_crop.dta includes hhid and personid as U.I.s. farmer_improvedseed_use.dta includes hhid and personid as U.I.s. The data describe whether a farmer grows a particular crop and whether they used all improved or hybrid seeds for those crops. input_use.dta includes hhid as a unique identifier with binary indicators for whether that household uses particular inputs on any field. farmer_fert_use includes hhid and personid as unique identifiers and binary variables for whether that farmer uses particular inputs on any field.
- **Output:** Ethiopia_ESS_W5_imprvseed_crop.dta; Ethiopia_ESS_W5_farmer_improvedseed_use.dta; Ethiopia_ESS_W5_input_use.dta ; Ethiopia_ESS_W5_farmer_fert_use
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Note that NGA W4 uses "indiv" rather than personid - consider aligning.

### Mobile Ownership
- **Description:** This dataset includes hhid as a unique identifier. mobile_owned is an indicator if the hh owns at least one mobile phone.
- **Output:** Ethiopia_2022_mobile_own.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Dataset naming convention is weird - should we align naming with other created datasets?

### Milk Productivity
- **Description:** This dataset includes hhid as a unique identifier. milk_animals is the total number of cows milked per household. liter_per_cow is the average quantity (liters) of milk produced per cow per year.
- **Output:** Ethiopia_ESS_W5_milk_animals.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Do we want a total number of liters produced per year per household? Or per cow per household per year?

### Egg Productivity
- **Description:** This dataset includes hhid as a unique identifier. hen_total is the total number of laying hens per household. eggs_total_year is the total number of eggs that were produced by the household over the year.
- **Output:** Ethiopia_ESS_W5_eggs_animals.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Do we want a total number of eggs produced per year per household? Or per hen per household per year?

### Fertilizer Application
- **Description:** This dataset includes hhid as a unique identifiers. fert_inorg_kg is the quantity of inorganic fertilizer used for all plots in kgs. fert_inorg_kg_male is the quantity of inorganic fertilizer used for male-managed plots in kgs. fert_inorg_kg_female is the quantity of inorganic fertilizer used for female-managed plots in kgs. fert_inorg_kg_mixed is the quantity of inorganic fertilizer used for mixed-managed plots in kgs. use_inorg_fert is a binary variable indicating whether or not the household uses any inorganic fertilizer.
- **Output:** Ethiopia_ESS_W5_fertilizer_application.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Is this still relevant? Can delete if not.

### Rate of Fertilizer Application
- **Description:** This dataset includes hhid as a unique identifiers and goegraphic variables as supplementary. fert_inorg refers to inorganic fertilizer, fert_org refers to organic fertilizer, herb refers to herbicide, fung refers to fungicide. So, fung_kg is the total amount of fungicide (in kgs) applied by a hh. _female, _male, and _mixed reports kgs of fert/herb/fung used on female/male/mixed plots within a household. Gender signifiers the gender of the decision maker.
- **Output:** Ethiopia_ESS_W5_fertilizer_application.dta
- **Coding Status:** ![Incomplete](https://placehold.co/15x15/f03c15/f03c15.png) `Incomplete`
- **Known Issues:** This section is technically complete based on our current standard and construction of rate of fert application - but we can revisit this to make it more accurate based on bulk densities of ferts.

### Dietary Diversity
- **Description:** This dataset includes hhid as a unique identifiers. number_foodgroup is number of food groups household consumed last week (household dietary diversity). household_diet_cut_off1 is a binary variable indicating whether or not the household consumed at least 6 of the 12 food groups in the last week. household_diet_cut_off2 is a binary variable indicating whether or not the household at least 8 of the 12 food groups in the last week.
- **Output:** Ethiopia_ESS_W5_household_diet.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Women's Ownership of Assets
- **Description:** This dataset includes hhid as a unique identifer. women_asset is a binary variable indicating whether or not that female household member owns productive asset.
- **Output:** Ethiopia_ESS_W5_women_asset.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Women's Agricultural Decision-Making
- **Description:** This dataset includes hhid as a unique identifier. women_decision_crop is a binary variable indicating whether or not that female household member makes decisions about crop activities. women_decision_livestock is a binary variable indicating whether or not that female household member makes decisions about livestock activities. women_decision_ag is a binary variable indicating whether or not that female household member makes decisions about agricultural (both crop and livestock) activities. 
- **Output:** Ethiopia_ESS_W5_ag_decision.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Informtion on women's control over livestock and permanent crop sales is not available.

### Women's Control Over Income
- **Description:** This dataset includes hhid as a unique identifier. control_cropincome is a binary variable indicating whether or not that female household member control over crop income. control_livestockincome is a binary variable indicating whether not or that female household member has control over livestock income. control_farmincome is a binary variable indicating whether or not that female household member has control over farm (crop or livestock) income. control_businessincome is a binary variable indicating whether or not that female household member has control over business income. control_nonfarmincome is a binary variable indicating whether or not that female household member has control over non-farm (business or remittances) income. control_all_income is a binary variable indicating whether or that female household member has control over at least one type of income.
- **Output:** Ethiopia_ESS_W5_control_income.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Informtion on women's control over livestock sales is not available.

### Consumption
- **Description:** This dataset includes hhid as a unique identifier. peraeq_cons is the household consumption per adult equivalent per year. daily_peraeq_cons is the household consumption per adult equivalent per day. percapita_cons is the household consumption per household member per year and daily_percap_cons is the household consumption per household member per day
- **Output:** Ethiopia_ESS_W5_consumption.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** There is no price index in wave 5 so can't adjust food consumption. 

### Agricultural Wages
- **Description:** This dataset includes hhid as a unique identifiers. wage_paid_aglabor is the daily agricultural wage paid for hired labor in the local currency. wage_paid_aglabor_female is the daily agricultural wage paid for hired female labor in the local currency. wage_paid_aglabor_male is the daily agricultural wage paid for hired male labor in the local currency.
- **Output:** Ethiopia_ESS_W5_ag_wage.dta 
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Crop Production Costs Per Hectare
- **Description:** This dataset includes hhid as a unique identifier. the file delineates explicit and total costs by area planted and area harvested, separating costs by plots that were cultivated by female, male, or mixed decision makers.
- **Output:** Ethiopia_ESS_W5_cropcosts.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:**

### Rate of Fertilizer Application
- **Description:**  This dataset includes case_id as a unique identifier and several variables that describe fertilizer, pesticide, and herbicide application by weight, hectares planted, and head of household gender.
separating costs by plots that were cultivated by female, male, or mixed decision makers.
- **Output:**  Ethiopia_ESS_W5_fertilizer_application.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:**

