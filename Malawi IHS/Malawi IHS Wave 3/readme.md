# Malawi IHS-IHPS Wave 3 (2016-2017)

## Prerequisites
* Download the raw data from https://microdata.worldbank.org/index.php/catalog/2936 (IHS) and https://microdata.worldbank.org/index.php/catalog/2939 (IHPS)
* Extract the files to their respective "Raw DTA Files" folders in the cloned directory
* Update the paths on lines 173-176 with the correct paths to the raw data and output files if desired. The files will run without modification if the original folder structure of the repository is maintained.

## Table of Contents
### Globals
* This section sets global variables for use later in the script, including:
* **Population
    * MWI_IHS_IHPS_W3_pop_tot - Total population in 2017 (World Bank)
    * MWI_IHS_IHPS_W3_pop_rur - Rural population in 2017 (World Bank)
    * MWI_IHS_IHPS_W3_pop_rur - Urban population in 2017 (World Bank)
* **Exchange Rates
    * MWI_W3_exchange_rate - USD-Kwacha conversion
    * MWI_W3_gdp_ppp_dollar - GDP-based purchasing power parity conversion, World Bank Indicator PA.NUS.PPP
    * MWI_W3_cons_ppp_dollar - Private-consumption-based purchasing power parity conversion, World Bank Indicator PA.NUS.PRVT.P
    * MWI_W3_infl_adj - Ratio of 2021:2017 Malawi consumer price index (World Bank), used for calculating poverty thresholds
* **Poverty Thresholds**
    * MWI_W3_poverty_under_190 - The pre-2023 $1.90 2011 PPP poverty line previously used by the World Bank, converted to local currency
    * MWI_W3_poverty_under_npl - The poverty threshold as reported by IFPRI, deflated to 2010 via consumer price index (CPI) adjustment
    * MWI_W3_poverty_under_215 - The updated $2.15 2017 PPP poverty line previously used by the World Bank, converted to local currency
    * MWI_W3_poverty_under_300 - The updated $3.00 2021 PPP poverty line currently used by the World Bank, converted to 2017 MWK
* **Thresholds for Winsorization:** the smallest (below the 1 percentile) and largest (above the 99 percentile) are replaced with the observations closest to them
* **Priority Crops:** the top 12 crops by area cultivated

### Appending Malawi IHPS and IHS Data 
- **Description:** This section appends Malawi IHPS and IHS data with a consistent unique identifier for cross-wave compatibility. IHS3 is an expansion of IHS2. A sub-sample of IHS3 EAs were surveyed twice reduce recall associated with different aspects of agricultural data collection and track and resurvey these households in 2013 as part of the Integrated Household Panel Survey 2013 (IHPS; microdata.worldbank.org/index.php/catalog/2248). Therefore, we append the panel and cross-sectional data to ensure we're working with a complete data from both panel and crossectional surveys.
* All the modules use appended data. To run the append code for the first time:  
	* Created a "Temp" folder in "Final DTA Files" folders  
	* Commented out macro which creates "created_data" in the globals directory   
	* Created a new appended paths in the code    
 	* After running the append code, changed created_data file path back to raw/created_data in the globals directory   
- **Output:** All raw data has generated new appended data files. 
- **Known Issues:** None
  
### Household IDs
- **Description:** This dataset includes hhid as a unique identifier, along with its location identifiers (i.e. rural, region, district, ta, ea_id, etc.). For households that are surveyed across multiple years (waves), a household's hhid value reflects a different format. In all cases, hhid is an anonymous, unique identifier associated with a single household.
- **Output:** `MWI_IHS_IHPS_W3_hhids.dta`  
- **Known Issues:** None

### Weights
- Survey weight adjustment. The combined first wave of the LSMS-ISA and second wave of the IHS (Wave 1) had a nationally representative panel subsample drawn from it that was surveyed in wave 2 without a cross-section. In wave 3, the panel and cross-sectional datasets were split, and the weights were recalculated so that both samples were nationally representative, although total population estimates produced from both sets of weights differ. To align them, we first rescale the weights for each sample to the national rural and urban population estimates. Weights are then combined by adjusting them by the proportional sizes of the sample. We therefore report **five** weight variables:
  - weight: The rescaled and combined panel and sample weight, used by default.
  - weight_sample: The original cross-sectional sample weight
  - weight_panel: The original panel sample weight
  - xs_weight: The rescaled cross-sectional sample weight
  - p_weight: The rescaled panel sample weight
Calculations can be modified by replacing the "weight" variable with the weight of your preference. Using the cross-sectional or panel sample-only weights will produce estimates for the combined sample, but summary statistics will be computed only for the selected panel or cross-sectional sample. Combining the panel and sample weights without rescaling is not recommended because the panel sample will be overweighted and national totals will be wrong.
- **Output:** `MWI_IHS_IHPS_W3_weights.dta`  

- **Known Issues:** None

### Individual IDs
- **Description:** This dataset includes indiv and hhid as unique identifiers and contains variables that indicate an individual's age, whether or not they are female, and whether or not they are head of household.
- **Output:** `MWI_IHS_IHPS_W3_person_ids.dta`  
 
- **Known Issues:** None   

### GPS Coordinates
- **Description:** This dataset includes hhid as a unique identifier and contains variables for household latitude and longitude as measured by a GPS.
- **Output:** `MWI_IHS_IHPS_W3_hh_coords.dta`  

- **Known Issues:** None

### Plot Areas  
- **Description:** This dataset includes hhid, plot_id, and season as unique identifiers and contains variables that indicate estimated plot area (in hectares and acres), measure plot area (in hectares and acres), whether or not the plot area was measured with a GPS, and field size. 
- **Output:** `MWI_IHS_IHPS_W3_plot_areas.dta`  

- **Known Issues:**  None   

### Plot Decisionmakers    
- **Description:** This dataset includes hhid and plot_id as unique identifiers, along with a variable, dm_gender, representing plot decision maker gender (male, female, or mixed). 
- **Output:** `MWI_IHS_IHPS_W3_plot_decision_makers.dta`  
- **Known Issues:** MWI Wave 3 has three decisionmakers and two owners. All the decisionmakers are accounted for. The decisionmakers are only replaced with owners when the decisionmakers are absent. This is incosistent with W1 which only has one decisionmaker and one owner. 

### Formalized Land Rights  
- **Description:** This dataset includes hhid as a unique identifier, along with a variable indicating whether that household owns at least one plot of land.
- **Output:** `MWI_IHS_IHPS_W3_land_rights_ind.dta`, `MWI_IHS_IHPS_W3_rights_hh.dta`  

- **Known Issues:** Using garden level data instead of plot level data. 

### All Plots  
- **Description:** This dataset includes hhid, plot_id, season, and crop_code as unique identifiers and contains location identifiers (i.e. rural, region, district, ta, ea_id, etc.) and other variables that indicate harvest quantities, hectares planted and harvested,  corresponding calories by amount of crop grown, and number of months a crop was grown.
- **Output:** `MWI_IHS_IHPS_W3_all_plots.dta`  

- **Known Issues:** Self-employment income does not report crop sales. No "still-to-harvest" value recorded in survey.  
  
### TLU (Tropical Livestock Units)
- **Description:** This dataset includes hhid as a unique identifier and contains other variables that quantify livestock counts at two time intervals (1 year ago and today) by various livestock types including poultry, chicken specfically, cattle, cows specfically, etc.
- **Output:** `MWI_IHS_IHPS_W3_TLU_Coefficients.dta`    

- **Known Issues:** Survey question on how many animals owned by household at start of the season are not available. Livestock holidings are valued using observed sales prices.   

### Gross Crop Revenue
- **Description:** This dataset summarizes crop production value, revenue, and losses for each household and/or household/crop type.
- **Output:** `MWI_IHS_IHPS_W3_hh_crop_production.dta`, `MWI_IHS_IHPS_W3_hh_crop_values_production.dta`, `MWI_IHS_IHPS_W3_crop_losses.dta`      

- **Known Issues:** None 

### Crop Expenses
- **Description:** This dataset summarizes crop expenses by input type for households in the dataset where most hhids contain multiple observations of crop expenses such as labor, seed, plot rents, fertilizer, pesticides, herbicides, animal traction rentals, and mechanized tool rentals.
- **Output:** `MWI_IHS_IHPS_W3_hh_cost_labor.dta`, `MWI_IHS_IHPS_W3_input_quantities.dta`, `MWI_IHS_IHPS_W3_hh_cost_inputs_long.dta`, `MWI_IHS_IHPS_W3_hh_cost_inputs_long_complete.dta`, `MWI_IHS_IHPS_W3_hh_cost_inputs.dta`       

- **Known Issues:**
	* LABOR: Labor expense estimates are severely understated for several reasons: 1. the survey instrument did not ask for number of hired labors. Therefore, the constructed value of hired labor for some households could represent all hired labor costs or per laborer hired labor costs. 2. We typically use the value of hired labor to imput the value of family and nonhired (exchange) labor. However, due to issues with how hired labor is contructed, we cannot use these values to impute the value of family or nonhired (exchange) labor.
	* PLOT RENTS: Some rainy season data is missing. The final output on plot rents has too few of observations as compared to reported plot rents in the raw data. 

### Monocropped Plots
- **Description:** This dataset includes hhid and plot_id as a unique identifier and contains variables summarizing plot characteristics for only plots that reported a single crop among priority crops (as designated by user earlier in file). 
- **Output:** `MWI_IHS_IHPS_W3_inputs_`cn'.dta`  
  
- **Known Issues:** None 

### Livestock Income
- **Description:** This dataset includes hhid as a unique identifier and contains variables summarizing livestock revenues and costs. 
- **Output:** `MWI_IHS_IHPS_W3_inputs_livestock_income`  

- **Known Issues:** Data on slaughtered livestock or ward information not available for W3. 

### Fish Income  
- **Description:** This dataset includes hhid as a unique identifier and contains variables summarizing value of fish harvest and income from fish sales.
- **Output:** `MWI_IHS_IHPS_W3_inputs_fish_income.dta`, `MWI_IHS_IHPS_W3_fish_trading_income.dta`      

- **Known Issues:** Fish price_per_unit is already averge price per unit, no additional calculations are required. 

### Self-Employment Income  
- **Description:** This dataset includes hhid as a unique identifier and variables that indicate whether or not a household generated income by self-employment and amount of self-employment income in the month prior to the survey.
- **Output:** `MWI_IHS_IHPS_W3_self_employment_income.dta`  

- **Known Issues:** Our reported measure of self-employment income does not reflect an annual measure of self-employment income and only represent self-employment income earned in the month prior to the survey.

### Non-Ag Wage Income
- **Description:** This dataset includes hhid as a unique identifier and an estimated annual salary generated by non-agricultural wages.
- **Output:** `Malawi_IHS_IHPS_W3_wage_income.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Ag Wage Income
- **Description:** This dataset includes hhid as a unique identifier and an estimated annual salary generated by agricultural wages.
- **Output:** `Malawi_IHS_IHPS_W3_agwage_income.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Other Income
- **Description:** This dataset includes hhid as a unique identifier and estimated income from other sources including remittances, assets, pensions, and assistance.
- **Output:** `MWI_IHS_IHPS_W3_other_income.dta`, `MWI_IHS_IHPS_W3_land_rental_income.dta`  

- **Known Issues:** Land Rents reported in garden level. Very small number of households actually reported land rental income.

### Off Farm Hours
- **Description:** This dataset includes hhid as a unique identifier, estimated hours spent on non-agricultural activities annualized, and number of household members working hours off the farm.
- **Output:** `MWI_IHS_IHPS_W3_off_farm_hours.dta`  

**Known Issues:** Currently reporting off farm hours per week - may want to impute for annual values.

### Farm Size / Land Size
- **Description:** This dataset includes hhid as a unique identifier and estimated total land size (in hectares) including those rented in and out.
- **Output:** `MWI_IHS_IHPS_W3_land_size_total.dta`  

- **Known Issues:** None 

### Farm Labor
- **Description:** This dataset includes hhid as a unique identifier, number of labor days for hired laborers, number of labor days for family laborers, and number of labor days total.
- **Output:** `MWI_IHS_IHPS_W3_family_hired_labor.dta`  

- **Known Issues:** Currently reporting off farm hours per week - may want to impute for annual values.

### Vaccine Usage  
- **Description:** This dataset includes hhid and individual id (indiv) as a unique identifier, whether or not the farmer was the livestock keeper, characteristics about the livestock keeper (age, gender, etc.) and whether or not a farmer chose to vaccinate all animals. 
- **Output:** `MWI_IHS_IHPS_W3_farmer_vaccine.dta`  

- **Known Issues:**   None

### Animal Health - Diseases
- **Description:** This dataset includes hhid as a unique identifier and a series of binary variables indicating whether a household experienced livestock types having various diseases.
- **Output:** `MWI_IHS_IHPS_W3_livestock_diseases.dta`  

- **Known Issues:** Disease code different than that from questionnaire. Brucelosis and small pox data is missing. 

### Plot Managers 
- **Description:** This dataset includes hhid, plot_id, and plot manager as a unique identifier and a series of variables describing fertilizer and seed type applied.
- **Output:** `MWI_IHS_IHPS_W3_farmer_improved_hybrid_seed_use.dta`, `MWI_IHS_IHPS_W3_input_use.dta`    

- **Known Issues:** None 

### Reached by Ag Extension  
- **Description:** This dataset includes hhid as a unique identifier and a series of binary variables indicating whether a household was reached by particular extension types (public, private, etc.).
- **Output:** `MWI_IHS_IHPS_W3_any_ext.dta`  

- **Known Issues:** None  

### Mobile Phone Ownership 
- **Description:** This dataset includes hhid as a unique identifier and one binary variable indicating whether the household owned a mobile phone.
- **Output:** `MWI_IHS_IHPS_W3_fin_mobile_own.dta`  

- **Known Issues:** None

### Use of Formal Financial Services  
- **Description:** This dataset includes hhid as a unique identifier and binary variables indicating whether a household consumed credit or other formal financial services.
- **Output:** `MWI_IHS_IHPS_W3_fin_serv.dta`    

- **Known Issues:** No digital or insurance in Malawi, unable to compute those variables. W4 does not have questions about credit or MM.  

### Milk Productivity  
- **Description:** This dataset includes hhid as a unique identifier and a measure of liters of milk produced and how many months milk was produced.
- **Output:** `MWI_IHS_LSMS_ISA_W3_milk_animals.dta`  

- **Known Issues:**  Only cow milk in MWI, large ruminants are not included.   

### Egg Productivity  
- **Description:** This dataset includes hhid as a unique identifier, a variable for the number of poultry, and measures for eggs produced per week, month, and per year.
- **Output:** `MWI_IHS_IHPS_W3_eggs_animals.dta`    

- **Known Issues:** None 

### Crop Production Costs Per Hectare 
- **Description:** This dataset includes hhid as a unique identifier and several variables that describe explicit and total costs to by decisionmaker gender.
- **Output:** `MWI_IHS_IHPS_W3_cropcosts.dta`

- **Known Issues:** None

### Use of Inorganic Fertilizer
- **Description:** This dataset includes hhid and indiv as a unique identifiers, whether or not the farmer use inorganic fertilizer, and farmer characteristics (age, gender, etc.) 
- **Output:** `MWI_IHS_IHPS_W3_farmer_fert_use.dta`  
 
- **Known Issues:** None 

### Use of Improved Seed
- **Description:** This dataset examines if individuals use any improved seed on any plot.
- **Output:** `MWI_IHS_IHPS_W3_improvedseed_use.dta`

- **Known Issues:** None
 
### Rate of Fertilizer Application
- **Description:** This dataset includes hhid as a unique identifier and several variables that describe fertilizer, pesticide, and herbicide application by weight, hectares planted, and head of household gender.
- **Output:** `MWI_IHS_IHPS_W3_fertilizer_application.dta`

- **Known Issues:** None

### Household's Dietary Diversity Score
- **Description:** This dataset includes hhid as a unique identifier, a count of food groups (out of 12) the surveyed individual consumed last week, and whether or not a houseshold consumed at least 6 of the 12 food groups, of 8 of the 12 food groups. The Food Consumption Score (FCS) was calculated by summing the frequency of consumption of different food groups over the past 7 days, each weighted according to its nutritional value. The Reduced Coping Strategies Index (rCSI) was calculated by summing the frequency of five food-related coping behaviors used in the past 7 days, each multiplied by a standardized severity weight.
- **Output:** `MWI_IHS_IHPS_W3_household_diet.dta`

- **Known Issues:** No individual consumption but instead household level consumption of various food items. Thus, only the proportion of household eating nutritious food can be estimated.  

### Women's Control Over Income
- **Description:** This dataset includes hhid and individual id (indiv) as a unique identifier and a series of binary variables describing individual gender and ownership over different income streams (e.g. salary income).
- **Output:** `MWI_IHS_IHPS_W3_control_income.dta`

- **Known Issues:** None

### Women's Participation in Agricultural Decision Making 
- **Description:**  This dataset includes hhid and individual id (indiv) as a unique identifier and a series of binary variables describing individual gender and role in decisions related to agriculture (e.g. crops, livestock).
- **Output:** `MWI_IHS_IHPS_W3_make_ag_decision.dta`

- **Known Issues:** Missing data on plot ownership and negotiating. In most cases, MWI LSMS 3 lists the first three decision makers. Indicator may be biased downward if some women would participate in decisions but are not listed among the first two.

### Women's Ownership of Assets
- **Description:** This dataset includes hhid and individual id (indiv) as a unique identifier and a series of binary variables describing individual gender and ownership of assets. 
- **Output:** `MWI_IHS_IHPS_W3_ownasset.dta`

- **Known Issues:** Missing data on plot ownership and negotiating. In most cases, MWI LSMS 3 lists the first three decision makers. Indicator may be biased downward if some women would participate in decisions but are not listed among the first two.

### Crop Yields
- **Description:** This dataset includes hhid as a unique identifier and variables describing the crop yield (area planted, area harvested, quantity harvested, value harvested, value sold) by crop, planting strategy, and gender of plot manager.
- **Output:** `MWI_IHS_IHPS_W3_trees.dta`, `MWI_IHS_IHPS_W3_crop_harvest_area_yield.dta`, `MWI_IHS_IHPS_W3_yield_hh_crop_level.dta`, `MWI_IHS_IHPS_W3_hh_crop_values_production_type_crop.dta`      

- **Known Issues:** None

### Shannon Diversity Index
- **Description:**  This dataset includes hhid as a unique identifier and variables describing the household's crop species diversity score, with separate variables indicating SDI by gender of the head of household.
- **Output:** `MWI_IHS_IHPS_W3_shannon_diversity_index.dta`
- **Known Issues:** None

### Consumption
- **Description:** This dataset includes hhid as a unique identifier and a series of variables describing household consumption (e.g. total, per capita, per adult equivalent, etc.).
- **Output:** `MWI_IHS_IHPS_W3_consumption.dta`
- **Known Issues:** Aggregate consumption estimates are typically reported by the data preparers in the raw data. These values are spatiotemporally deflated to account for subnational price differences and variations in survey timing. Currently, aggregate consumption is calculated for the cross-section but not the panel, so it is not possible to estimate poverty rates on a panel basis without constructing them. We approximate the World Bank's methodology to incorporate the full sample, but this is still a work in progress, and the computed estimates do not fully align with the reported estimates within the cross section. Due to these issues, we use the cross-sectional weights when calculating the poverty estimates rather than the combined sample weights. At the household level, because food consumption varies substantially seasonally and because the food consumption module was only administered once, survey timing has a significant impact on the annualized estimate of household consumption and consequently poverty status.

### Household Food Provision
- **Description:** This dataset includes hhid as a unique identifier and a numeric variable describing months that the household experienced food insecurity.
- **Output:** `MWI_IHS_IHPS_W3_food_security.dta`
- **Known Issues:** Data entry for the panel sample is not consistent with the cross-sectional sample and so the estimates from the panel sample are excluded.

### Household Assets
- **Description:** This dataset includes hhid as a unique identifier and a single numeric variable describing the gross value of household assets.
- **Output:** `MWI_IHS_IHPS_W3_hh_assets.dta`
- **Known Issues:** None

### Food Security
- **Description:** This dataset includes hhid as a unique identifier and a series of numeric variables describing household food consumption (e.g. total, per capita, per adult equivalent, etc.).
- **Output:** `MWI_IHS_IHPS_W3_food_cons.dta`
- **Known Issues:** None
 
### Household Variables
- **Description:** This dataset includes hhid as a unique identifier and compiles all relevant variables from previous intermediate files [see sections above] on the level of an individual household.
- **Output:** `MWI_IHS_IHPS_W3_household_variables.dta`    
- **Known Issues:** None

### Individual Level Variables  
- **Description:** This dataset includes hhid and individual id (indiv) as a unique identifier and compiles all relevant variables that are available on an individual level from previous intermediate files [see sections above].
- **Output:** `MWI_IHS_IHPS_W3_individual_variables.dta`    

- **Known Issues:** None

### Plot Level Variables  
- **Description:** This dataset includes hhid and plot_id as a unique identifier and compiles all relevant variables that are available on a plot level from previous intermediate files [see sections above].
- **Output:** `MWI_IHS_IHPS_W3_field_plot_variables.dta`   

- **Known Issues:** None 

### Summary Statistics  
- **Description:**  This section produces a file in two formats, .dta and .xlsx, that provide descriptive statistics (mean, standard deviation, quartiles, min, max) for each variable produced in the Household Variables, Individual Level Variables, and Plot Level Variables sections.
- **Output:** `MWI_IHS_IHPS_W3_summary_stats_with_labels.dta`, `MWI_IHS_IHPS_W3_summary_stats.xlsx`    

- **Known Issues:** None 
