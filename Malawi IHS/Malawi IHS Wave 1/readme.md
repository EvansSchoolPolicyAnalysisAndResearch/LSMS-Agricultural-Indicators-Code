# Malawi IHS/LSMS-ISA Wave 1 (2010-2011)
- ![Incomplete](https://placehold.co/15x15/f03c15/f03c15.png) `Incomplete`
- ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- ![Pending Review](https://placehold.co/15x15/1589F0/1589F0.png) `Pending Review`

## Prerequisites
* Download the raw data from [https://microdata.worldbank.org/index.php/catalog/3557](https://microdata.worldbank.org/index.php/catalog/1003)
* Extract the files to the "Raw DTA Files" folder in the cloned directory
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
- **Coding Status:** ![Pending Review](https://placehold.co/15x15/1589F0/1589F0.png) `Pending Review`
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
- **Coding Status:** ![Pending Review](https://placehold.co/15x15/1589F0/1589F0.png) `Pending Review`
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

### Crop Unit Conversion Factors
- **Description:** 
- **Output:** Malawi_IHS_W1_cf.dta
- **Coding Status:** ![Incomplete](https://placehold.co/15x15/f03c15/f03c15.png) `Incomplete`
- **Known Issues:** Tree/permanent crop file not currently being used. Must build out to create more matches between raw data and conversion factors.

### All Plots
- **Description:** This dataset includes case_id, plot_id, season, and crop_code as unique identifiers and contains location identifiers (i.e. rural, region, district, ta, ea_id, etc.) and other variables that indicate harvest quantities, hectares planted and harvested,  corresponding calories by amount of crop grown, and number of months a crop was grown.
- **Output:** Malawi_IHS_W1_all_plots.dta
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Crop_code fixes and calorie conversions are incomplete.

### TLU (Tropical Livestock Units)
- **Description:** This dataset includes case_id as a unique identifier and contains other variables that quantify livestock counts at two time intervals (1 year ago and today) by various livestock types including poultry, chicken specfically, cattle, cows specfically, etc.
- **Output:** Malawi_IHS_W1_TLU_Coefficients.dta
- **Coding Status:** ![Pending Review](https://placehold.co/15x15/1589F0/1589F0.png) `Pending Review`
- **Known Issues:** None

### Crop Expenses
- **Description:** This dataset summarizes crop expenses by input type for households in the dataset where most case_ids contain multiple observations of crop expenses such as labor, seed, plot rents, fertilizer, pesticides, herbicides, animal traction rentals, and mechanized tool rentals.
- **Output:** Malawi_IHS_W1_hh_cost_inputs_long_complete.dta
- **Coding Status:** ![Incomplete](https://placehold.co/15x15/f03c15/f03c15.png) `Incomplete`
- **Known Issues:** **LABOR:** Labor expense estimates are severely understated for several reasons: 1. the survey instrument did not ask for number of hired labors. Therefore, the constructed value of hired labor for some households could represent ***all*** hired labor costs or ***per laborer*** hired labor costs. 2. We typically use the value of hired labor to imput the value of family and nonhired (exchange) labor. However, due to issues with how hired labor is contructed, we cannot use these values to impute the value of family or nonhired (exchange) labor. **PLOT RENTS:** The final output on plot rents has too few of observations as compared to reported plot rents in the raw data. This requires resolution. **TRANSPORTATION COSTS:** The survey instrument collects information on transportation costs associated with bringing crops to market (seperate from transportation costs associated with picking up seed and other inputs which we currently are reporting). We are still in the process of building this smaller module and incorporating into crop expenses. Crop expenses in aggregate will be understated for now because transportation costs for crops are missing. **OTHER ISSUES:** This file is at the household level rather than disaggregated by plot as most crop expenses were not reported at the plot level (with the exception of plot rents). We also aggregate expenses over the course of the year as not all raw data are at the season-level (e.g. animal traction and mechanized tool rentals). 

### Livestock Income
- **Description:** This dataset includes case_id as a unique identifier and contains variables summarizing livestock revenues and costs. 
- **Output:** Malawi_IHS_W1_livestock_income.dta
- **Coding Status:** ![Pending Review](https://placehold.co/15x15/1589F0/1589F0.png) `Pending Review`
- **Known Issues:** None

### Fish Income
- **Description:** This dataset includes case_id as a unique identifier and contains variables summarizing value of fish harvest and income from fish sales.
- **Output:** Malawi_IHS_W1_fish_income.dta
- **Coding Status:** ![Pending Review](https://placehold.co/15x15/1589F0/1589F0.png) `Pending Review`
- **Known Issues:** Small dataset of survey respondents where some may have reported income from fish sales (total) or income from fish sales (per piece).
  
### Self-Employment Income
- **Description:** This dataset includes case_id as a unique identifier and variables that indicate whether or not a household generated income by self-employment and amount of self-employment income in the month prior to the survey.
- **Output:** Malawi_IHS_W1_self_employment.dta
- **Coding Status:** ![Pending Review](https://placehold.co/15x15/1589F0/1589F0.png) `Pending Review`
- **Known Issues:** Our reported measure of self-employment income does not reflect an annual measure of self-employment income and only represent self-employment income earned in the month prior to the survey.

### Fish Trading Income
- **Description:** This dataset includes case_id as a unique identifier and an estimated amount of income generated by fish trading.
- **Output:** Malawi_IHS_W1_fish_trading_income.dta
- **Coding Status:** ![Pending Review](https://placehold.co/15x15/1589F0/1589F0.png) `Pending Review`
- **Known Issues:** None

### Non-Ag Wage Income
- **Description:** This dataset includes case_id as a unique identifier and an estimated annual salary generated by non-agricultural wages.
- **Output:** Malawi_IHS_W1_wage_income.dta
- **Coding Status:** ![Pending Review](https://placehold.co/15x15/1589F0/1589F0.png) `Pending Review`
- **Known Issues:** None
  
### Ag Wage Income
- **Description:** This dataset includes case_id as a unique identifier and an estimated annual salary generated by agricultural wages.
- **Output:** Malawi_IHS_W1_agwage_income.dta
- **Coding Status:** ![Pending Review](https://placehold.co/15x15/1589F0/1589F0.png) `Pending Review`
- **Known Issues:** None

### Other Income
- **Description:** This dataset includes case_id as a unique identifier and estimated income from other sources including remittances, assets, pensions, and assistance.
- **Output:** Malawi_IHS_W1_other_income.dta
- **Coding Status:** ![Pending Review](https://placehold.co/15x15/1589F0/1589F0.png) `Pending Review`
- **Known Issues:** None

### Land Rental Income
- **Description:** This dataset includes case_id as a unique identifier and estimated income from renting out owned land.
- **Output:** Malawi_IHS_W1_land_rental_income.dta
- **Coding Status:** ![Pending Review](https://placehold.co/15x15/1589F0/1589F0.png) `Pending Review`
- **Known Issues:** Very small number of households actually reported this type of income.

### Farm Size / Land Size
- **Description:** This dataset includes case_id as a unique identifier and estimated total land size (in hectares) including those rented in and out.
- **Output:** Malawi_IHS_W1_land_size_total.dta
- **Coding Status:** ![Pending Review](https://placehold.co/15x15/1589F0/1589F0.png) `Pending Review`
- **Known Issues:** None

### Off Farm Hours
- **Description:** This dataset includes case_id as a unique identifier, estimated hours spent on non-agricultural activities per week, and number of household members working hours off the farm.
- **Output:** Malawi_IHS_W1_off_farm_hours.dta
- **Coding Status:** ![Pending Review](https://placehold.co/15x15/1589F0/1589F0.png) `Pending Review`
- **Known Issues:** Currently reporting off farm hours per week - may want to impute for annual values.
  
### Farm Labor
- **Description:** This dataset includes case_id as a unique identifier, number of labor days for hired laborers, number of labor days for family laborers, and number of labor days total.
- **Output:** Malawi_IHS_W1_off_family_hired_labor.dta
- **Coding Status:** ![Pending Review](https://placehold.co/15x15/1589F0/1589F0.png) `Pending Review`
- **Known Issues:** Hired labor days are most likely understated. As mentioend before under Labor of Crop Expenses 1. the survey instrument did not ask for number of hired labors. Therefore, some households may have reported labor days and wages for one laborer or all hired laborers.
  
### Vaccine Usage
- **Description:** This dataset includes case_id and farmerid as a unique identifiers, whether or not the farmer was the livestock keeper, characteristics about the livestock keeper (age, gender, etc.) and whether or not a farmer chose to vaccinate all animals. 
- **Output:** Malawi_IHS_W1_off_farmer_vaccine.dta
- **Coding Status:** ![Pending Review](https://placehold.co/15x15/1589F0/1589F0.png) `Pending Review`
- **Known Issues:** Is farmerid the variable name we want?

### Animal Health (Diseases)
- **Description:** This dataset includes case_id as a unique identifier and a series of binary variables indicating whether a household experienced livestock types having various diseases.
- **Output:** Malawi_IHS_W1_livestock_diseases.dta
- **Coding Status:** ![Pending Review](https://placehold.co/15x15/1589F0/1589F0.png) `Pending Review`
- **Known Issues:** None

### Use of Inorganic Fertilizer
- **Description:** This dataset includes case_id and farmerid as a unique identifiers, whether or not the farmer use inorganic fertilizer, and farmer characteristics (age, gender, etc.) 
- **Output:** Malawi_IHS_W1_off_farmer_fert_use.dta
- **Coding Status:** ![Pending Review](https://placehold.co/15x15/1589F0/1589F0.png) `Pending Review`
- **Known Issues:** Is farmerid the variable name we want?
  
### Reached by Ag Extension
- **Description:** This dataset includes case_id as a unique identifier and a series of binary variables indicating whether a household was reached by particular extension types (public, private, etc.).
- **Output:** Malawi_IHS_W1_any_ext.dta
- **Coding Status:** ![Pending Review](https://placehold.co/15x15/1589F0/1589F0.png) `Pending Review`
- **Known Issues:** None
  
### Use of Formal Financial Services
- **Description:** This dataset includes case_id as a unique identifier and binary variables indicating whether a household consumed credit or other formal financial services.
- **Output:** Malawi_IHS_W1_fin_serv.dta
- **Coding Status:** ![Pending Review](https://placehold.co/15x15/1589F0/1589F0.png) `Pending Review`
- **Known Issues:** Saved dataset contains extraneous variables which should be removed by EPAR.
  
### Milk Productivity
- **Description:** This dataset includes case_id as a unique identifier and a measure of liters of milk produced.
- **Output:** Malawi_IHS_W1_milk_animals.dta
- **Coding Status:** ![Incomplete](https://placehold.co/15x15/f03c15/f03c15.png) `Incomplete`
- **Known Issues:** Incomplete
  
### Egg Productivity
- **Description:** This dataset includes case_id as a unique identifier, a variable for the number of poultry, and measures for eggs produced per week, month, and per year.
- **Output:** Malawi_IHS_W1_eggs_animals.dta
- **Coding Status:** ![Pending Review](https://placehold.co/15x15/1589F0/1589F0.png) `Pending Review`
- **Known Issues:** None
  
### Rate of Fertilizer Application
- **Description:** This dataset includes case_id as a unique identifier...
- **Coding Status:** ![Incomplete](https://placehold.co/15x15/f03c15/f03c15.png) `Incomplete`
- **Known Issues:** Incomplete
  
### Household's Dietary Diversity Score
- **Description:** This dataset includes case_id as a unique identifier, a count of food groups (out of 12) the surveyed individual consumed last week, and whether or not a houseshold consumed at least 6 of the 12 food groups, of 8 of the 12 food groups. 
- **Output:** Malawi_IHS_W1_household_diet.dta
- **Coding Status:** ![Pending Review](https://placehold.co/15x15/1589F0/1589F0.png) `Pending Review`
- **Known Issues:** None

### Women's Control Over Income
- **Description:** This dataset includes case_id as a unique identifier...
- **Coding Status:** ![Incomplete](https://placehold.co/15x15/f03c15/f03c15.png) `Incomplete`
- **Known Issues:** Incomplete






