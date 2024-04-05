# Malawi IHS/LSMS-ISA Wave 1 (2010-2011)
- ![Incomplete](https://placehold.co/15x15/f03c15/f03c15.png) `Incomplete`
- ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- ![Pending Review](https://placehold.co/15x15/1589F0/1589F0.png) `Pending Review`

## Prerequisites
* Download the raw data from [https://microdata.worldbank.org/index.php/catalog/3557](https://microdata.worldbank.org/index.php/catalog/1003)
* Extract the files to the "Raw DTA Files" folder in the cloned directory
  * We use the full sample raw data files for the Malawi - Third Integrated Household Survey 2010-2011 including both panel (Panel A and Panel B) and cross-sectional households.
* Update the paths on lines 148-150 with the correct paths to the raw data and output files.

## Table of Contents
### Globals
* This section sets global variables for use later in the script, including:
  * **Population:** LSMS-ISA survey design oversamples rural households compared to urban. We reference true rural and urban population estimates to re-weight households.
    * Malawi_IHS_W1_pop_tot - Total population in 2010 (World Bank)
    * Malawi_IHS_W1_pop_rur - Rural population in 2010 (World Bank)
    * Malawi_IHS_W1_pop_urb - Urban population in 2010 (World Bank)
  * **Exchange Rates**
    * Malawi_IHS_W1_exchange_rate - USD-MWK conversion in 2017 (World Bank)
    * Malawi_IHS_W1_gdp_ppp_dollar - GDP-based purchasing power parity conversion in 2017 (World Bank-Indicator PA.NUS.PPP)
    * Malawi_IHS_W1_cons_ppp_dollar - Private-consumption-based purchasing power parity conversion in 2017 (World Bank-Indicator PA.NUS.PRVT.P)
    * Malawi_IHS_W1_inflation - Ratio of 2010:2017 Malawi consumer price index (World Bank), used for calculating poverty thresholds
  * **Poverty Thresholds**
    * Malawi_IHS_W1_poverty_threshold - The pre-2023 $1.90 2011 PPP poverty line used by the World Bank, converted to local currency
    * Malawi_IHS_W1_poverty_ifpri - The poverty threshold as reported by IFPRI, deflated to 2010 via CPI
    * Malawi_IHS_W1_poverty_215 - The updated $2.15 2017 PPP poverty line currently used by the World Bank, converted to local currency
  * **Thresholds for Winsorization:** the smallest (below the 1 percentile) and largest (above the 99 percentile) are replaced with the observations closest to them
  * **Priority Crops:** the top 12 crops by area cultivated (determined by ALL PLOTS later in the code)
    
### Household IDs
- **Description:** This dataset includes case_id as a unique identifier, along with its location identifiers (i.e. rural, region, district, ta, ea_id, etc.).
- **Output:** Malawi_IHS_W1_hhids.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Wave 1 uses case_id (not hhid) because it is the first wave in a series of surveys administered to both panel and cross-sectional households. In subsequent waves, hhid becomes the unique identifier at the household level as hhid branches from case_id (e.g. multiple households emerge from an original case_id). Panel datasets use y3_hhid as their unique identifier.

### Weights
- **Description:** This dataset includes case_id as a unique identifier, along with its location identifiers (i.e. rural, region, district, ta, ea_id, etc.) and a weight variable provided by the LSMS-ISA raw data indicating how many households a given household represents. A higher weight indicates undersampling whereas a lower weight indicates oversampling.
- **Output:** Malawi_IHS_W1_weights.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Individual IDs
- **Description:** This dataset includes indiv and hhid as unique identifiers and contains variables that indicate an individual's age, whether or not they are female, and whether or not they are head of household.
- **Output:** Malawi_IHS_W1_person_ids.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None
  
### Household Size
- **Description:** This dataset includes case_id as a unique identifier and contains variables that indicate number of individuals in a household, whether or not the head of household is female, location identifiers (i.e. rural, region, district, ta, ea_id, etc.), household sampling weight, a survey weight adjusted to match total population, and a survey weight adjust to match the rural and urban population.
- **Output:** Malawi_IHS_W1_hhsize.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Household Size
- **Description:** This dataset includes case_id as a unique identifier and contains variables that indicate number of individuals in a household, whether or not the head of household is female, location identifiers (i.e. rural, region, district, ta, ea_id, etc.), household sampling weight, a survey weight adjusted to match total population, and a survey weight adjust to match the rural and urban population.
- **Output:** Malawi_IHS_W1_hhsize.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### GPS Coordinates
- **Description:** This dataset includes case_id as a unique identifier and contains variables for household latitude and longitude as measured by a GPS.
- **Output:** Malawi_IHS_W1_hh_coords.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None
  
### Plot Areas
- **Description:** This dataset includes case_id, plot_id, and season as unique identifiers and contains variables that indicate estimated plot area (in hectares and acres), measure plot area (in hectares and acres), whether or not the plot area was measured with a GPS, and field size. 
- **Output:** Malawi_IHS_W1_plot_areas.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** The instrument did not collect area data (whether estimated or measured) for T-plots. T-plots are defined as plots that were not previously reported during both the rainy and dry seasons, and are exclusively used for growing trees or permanent crops, identified by prefixes like T1, T2, etc. In cases where the estimated or measured plot area for T-plots is unknown, we rely on the reported 'plantation size' where a T-plot may contain multiple 'plantations' within it. When there are multiple reported 'plantations' of the same crop on a single T-plot, we consider the maximum plantation size to avoid double-counting the area. However, when a T-plot has multiple reported 'plantations' of different crops, we sum the plantation sizes for each unique crop to determine the total plot area.
  
### Plot Decision Makers
- **Description:** This dataset includes case_id and plot_id as unique identifiers, along with a variable, dm_gender, representing plot decision maker gender (male, female, or mixed). 
- **Output:** Malawi_IHS_W1_plot_decision_makers.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Not all plots culitivating crops reported a plot decision maker. We handle this by backfilling plot decision maker with plot owner is missing, and head of household if missing still. A secondary issue is that the instrument did not collect a plot decision maker for tree and permanent crops. We handle this by assuming that the household in charge of earnings for a specific crop is also the plot decision maker, provided that a household only grows that crop on one plot and not multiple. For households that grow a crop on multiple plots, we assume that the head of household is the plot decision maker for those plots.

### Formalized Land Rights
- **Description:** This dataset includes case_id as a unique identifier, along with a variable indicating whether that household owns at least one plot of land.
- **Output:** Malawi_IHS_W1_land_rights_hh.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### All Plots
- **Description:** This dataset includes case_id, plot_id, season, and crop_code as unique identifiers and contains location identifiers (i.e. rural, region, district, ta, ea_id, etc.) and other variables that indicate harvest quantities, hectares planted and harvested,  corresponding calories by amount of crop grown, and number of months a crop was grown.
- **Output:** Malawi_IHS_W1_all_plots.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Self-employment income does not report crop sales. No "still-to-harvest" value recorded in survey.

### TLU (Tropical Livestock Units)
- **Description:** This dataset includes case_id as a unique identifier and contains other variables that quantify livestock counts at two time intervals (1 year ago and today) by various livestock types including poultry, chicken specfically, cattle, cows specfically, etc.
- **Output:** Malawi_IHS_W1_TLU_Coefficients.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

## Gross Crop Revenue
- **Description:** This dataset summarizes crop production value, revenue, and losses for each household and/or household/crop type.
- **Output:** Malawi_IHS_W1_cropsales_value.dta ; Malawi_IHS_W1_crop_values_production.dta ; Malawi_IHS_W1_hh_crop_production.dta ; Malawi_IHS_W1_crop_losses.dta
- **Coding Status:** ![Pending Review](https://placehold.co/15x15/1589F0/1589F0.png) `Pending Review`
- **Known Issues:** None

### Crop Expenses
- **Description:** This dataset summarizes crop expenses by input type for households in the dataset where most case_ids contain multiple observations of crop expenses such as labor, seed, plot rents, fertilizer, pesticides, herbicides, animal traction rentals, and mechanized tool rentals.
- **Output:** Malawi_IHS_W1_hh_cost_inputs_long_complete.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** **LABOR:** The constructed value of hired labor for some households likely represent ***per laborer*** hired labor costs, however several outlier values imply that some households reported ***all*** hired labor costs. We use the value of hired labor to impute the value of family and nonhired (exchange) labor. For both hired labor and imputed non-hired labor costs, the some observations may reflect this discrepancy in survey response. 

### Monocropped Plots
- **Description:** This dataset includes case_id and plot_id as a unique identifier and contains variables summarizing plot characteristics for only plots that reported a single crop among priority crops (as designated by user earlier in file). 
- **Output:** multiple: Malawi_IHS_W1_inputs_`cn'.dta where cn refers to various priority crops (as designated by user earlier in file).
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Livestock Income
- **Description:** This dataset includes case_id as a unique identifier and contains variables summarizing livestock revenues and costs. 
- **Output:** Malawi_IHS_W1_livestock_income.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Fish Income
- **Description:** This dataset includes case_id as a unique identifier and contains variables summarizing value of fish harvest and income from fish sales.
- **Output:** Malawi_IHS_W1_fish_income.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Small dataset of survey respondents where some may have reported income from fish sales (total) or income from fish sales (per piece).
  
### Self-Employment Income
- **Description:** This dataset includes case_id as a unique identifier and variables that indicate whether or not a household generated income by self-employment and amount of self-employment income in the month prior to the survey.
- **Output:** Malawi_IHS_W1_self_employment.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Our reported measure of self-employment income does not reflect an annual measure of self-employment income and only represent self-employment income earned in the month prior to the survey.

### Fish Trading Income
- **Description:** This dataset includes case_id as a unique identifier and an estimated amount of income generated by fish trading.
- **Output:** Malawi_IHS_W1_fish_trading_income.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Non-Ag Wage Income
- **Description:** This dataset includes case_id as a unique identifier and an estimated annual salary generated by non-agricultural wages.
- **Output:** Malawi_IHS_W1_wage_income.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None
  
### Ag Wage Income
- **Description:** This dataset includes case_id as a unique identifier and an estimated annual salary generated by agricultural wages.
- **Output:** Malawi_IHS_W1_agwage_income.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Other Income
- **Description:** This dataset includes case_id as a unique identifier and estimated income from other sources including remittances, assets, pensions, and assistance.
- **Output:** Malawi_IHS_W1_other_income.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Land Rental Income
- **Description:** This dataset includes case_id as a unique identifier and estimated income from renting out owned land.
- **Output:** Malawi_IHS_W1_land_rental_income.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Very small number of households actually reported this type of income.

### Farm Size / Land Size
- **Description:** This dataset includes case_id as a unique identifier and estimated total land size (in hectares) including those rented in and out.
- **Output:** Malawi_IHS_W1_land_size_total.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Off Farm Hours
- **Description:** This dataset includes case_id as a unique identifier, estimated hours spent on non-agricultural activities annualized, and number of household members working hours off the farm.
- **Output:** Malawi_IHS_W1_off_farm_hours.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Currently reporting off farm hours per week - may want to impute for annual values.
  
### Farm Labor
- **Description:** This dataset includes case_id as a unique identifier, number of labor days for hired laborers, number of labor days for family laborers, and number of labor days total.
- **Output:** Malawi_IHS_W1_off_family_hired_labor.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Hired labor days are most likely understated. As mentioend before under Labor of Crop Expenses 1. the survey instrument did not ask for number of hired labors. Therefore, some households may have reported labor days and wages for one laborer or all hired laborers.
  
### Vaccine Usage
- **Description:** This dataset includes case_id and farmerid as a unique identifiers, whether or not the farmer was the livestock keeper, characteristics about the livestock keeper (age, gender, etc.) and whether or not a farmer chose to vaccinate all animals. 
- **Output:** Malawi_IHS_W1_off_farmer_vaccine.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Is farmerid the variable name we want?

### Animal Health (Diseases)
- **Description:** This dataset includes case_id as a unique identifier and a series of binary variables indicating whether a household experienced livestock types having various diseases.
- **Output:** Malawi_IHS_W1_livestock_diseases.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Use of Inorganic Fertilizer
- **Description:** This dataset includes case_id and farmerid as a unique identifiers, whether or not the farmer use inorganic fertilizer, and farmer characteristics (age, gender, etc.) 
- **Output:** Malawi_IHS_W1_off_farmer_fert_use.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Is farmerid the variable name we want?

### Fertilizer Application Rate
- **Description:** This dataset includes case_id as a unique identifier and a series of variables describing volume and rate of fertilizer applied (e.g. nitrogen, phosphate, potassium)
- **Output:** Malawi_IHS_W1_fertilizer_application.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Plot Managers
- **Description:** This dataset includes case_id, plot_id, and plot manager as a unique identifier and a series of variables describing fertilizer and seed type applied.
- **Output:** Malawi_IHS_W1_farmer_improved_hybrid_seed_use.dta ; Malawi_IHS_W1_input_use.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None
  
### Reached by Ag Extension
- **Description:** This dataset includes case_id as a unique identifier and a series of binary variables indicating whether a household was reached by particular extension types (public, private, etc.).
- **Output:** Malawi_IHS_W1_any_ext.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Mobile Phone Ownership
- **Description:** This dataset includes case_id as a unique identifier and one binary variable indicating whether the household owned a mobile phone.
- **Output:** Malawi_IHS_W1_mobile_own.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None
 
### Use of Formal Financial Services
- **Description:** This dataset includes case_id as a unique identifier and binary variables indicating whether a household consumed credit or other formal financial services.
- **Output:** Malawi_IHS_W1_fin_serv.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None
  
### Milk Productivity
- **Description:** This dataset includes case_id as a unique identifier and a measure of liters of milk produced and how many months milk was produced.
- **Output:** Malawi_IHS_W1_milk_animals.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None
  
### Egg Productivity
- **Description:** This dataset includes case_id as a unique identifier, a variable for the number of poultry, and measures for eggs produced per week, month, and per year.
- **Output:** Malawi_IHS_W1_eggs_animals.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None
  
### Rate of Fertilizer Application
- **Description:** This dataset includes case_id as a unique identifier and several variables that describe fertilizer, pesticide, and herbicide application by weight, hectares planted, and head of household gender.
- **Output:** Malawi_IHS_W1_fertilizer_application.dta 
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Partially redundant with the "Fertilizer Application Rate" section, which isolates agronomically relevant fertilizer components (N, K, etc.). This section will be kept to ensure consistency across countries and waves of LSMS data.

### Household's Dietary Diversity Score
- **Description:** This dataset includes case_id as a unique identifier, a count of food groups (out of 12) the surveyed individual consumed last week, and whether or not a houseshold consumed at least 6 of the 12 food groups, of 8 of the 12 food groups. 
- **Output:** Malawi_IHS_W1_household_diet.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Women's Control Over Income
- **Description:** This dataset includes case_id and individual id (indiv) as a unique identifier and a series of binary variables describing individual gender and ownership over different income streams (e.g. salary income).
- **Output:** Malawi_IHS_W1_control_income.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Women's Participation in Agricultural Decision Making 
- **Description:**  This dataset includes case_id and individual id (indiv) as a unique identifier and a series of binary variables describing individual gender and role in decisions related to agriculture (e.g. crops, livestock).
- **Output:** Malawi_IHS_W1_control_income.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Women's Ownership of Assets
- **Description:** This dataset includes case_id and individual id (indiv) as a unique identifier and a series of binary variables describing individual gender and ownership of assets. 
- **Output:** Malawi_IHS_W1_ownasset.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Crop Yields
- **Description:**  
- **Output:** 
- **Coding Status:** ![Incomplete](https://placehold.co/15x15/f03c15/f03c15.png) `Incomplete`
- **Known Issues:** 

### Shannon Diversity Index
- **Description:**  
- **Output:** 
- **Coding Status:** ![Incomplete](https://placehold.co/15x15/f03c15/f03c15.png) `Incomplete`
- **Known Issues:** 

### Consumption
- **Description:** This dataset includes case_id as a unique identifier and a series of variables describing household consumption (e.g. total, per capita, per adult equivalent, etc.).
- **Output:** Malawi_IHS_W1_consumption.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Household food provision
- **Description:** This dataset includes case_id as a unique identifier and a numeric variable describing months that the household experienced food insecurity.
- **Output:** Malawi_IHS_W1_food_security.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** 

### Food Security
- **Description:** This dataset includes case_id as a unique identifier and a series of numeric variables describing household food consumption (e.g. total, per capita, per adult equivalent, etc.).
- **Output:** Malawi_IHS_W1_food_cons.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Household Assets
- **Description:** This dataset includes case_id as a unique identifier and a single numeric variable descrining the gross value of household assets.
- **Output:** Malawi_IHS_W1_hh_assets.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Household Variables
- **Description:**  
- **Output:** 
- **Coding Status:** ![Incomplete](https://placehold.co/15x15/f03c15/f03c15.png) `Incomplete`
- **Known Issues:** 

### Individual Level Variables
- **Description:**  
- **Output:** 
- **Coding Status:** ![Incomplete](https://placehold.co/15x15/f03c15/f03c15.png) `Incomplete`
- **Known Issues:** 

### Plot Level Variables
- **Description:**  
- **Output:** 
- **Coding Status:** ![Incomplete](https://placehold.co/15x15/f03c15/f03c15.png) `Incomplete`
- **Known Issues:** 

### Summary Statistics
- **Description:**  
- **Output:** 
- **Coding Status:** ![Incomplete](https://placehold.co/15x15/f03c15/f03c15.png) `Incomplete`
- **Known Issues:** 
