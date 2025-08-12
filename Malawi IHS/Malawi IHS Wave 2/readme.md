# Malawi IHPS/LSMS-ISA Wave 2 (2011-2013)
- ![Incomplete](https://placehold.co/15x15/f03c15/f03c15.png) `Incomplete`
- ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- ![Pending Review](https://placehold.co/15x15/1589F0/1589F0.png) `Pending Review`

## Prerequisites
* Download the raw data from [World Bank Microdata](https://microdata.worldbank.org/index.php/catalog/2248).
* Extract the files to the "raw_data" folder in the cloned directory
  * We use the full sample raw data files for the Malawi - Integrated Household Panel Survey 2011-2013 which includes only panel households.
* Update the paths on lines 170-176 to align with your cloned directory.
* Note for the first time running this code: ensure that you run the "Appended Data" section
  * This section is commented out, as it must be run only once.
* Extract the files to the "Raw DTA Files" folder in the cloned directory.
* Update the paths on lines 182-185 with the correct paths to the raw data and output files.

## Table of Contents
### Globals
* This section sets global variables for use later in the script, including:
* **Population
    * MWI_IHPS_W2_pop_tot - Total population in 2013 (World Bank)
    * MWI_IHPS_W2_pop_rur - Rural population in 2013 (World Bank)
    * MWI_IHPS_W2_pop_rur - Urban population in 2013 (World Bank)
* **Non-GPS-Plots
    * drop_unmeas_plots - if not 0, this global will remove any plot that is not measured by GPS from the sample. Used to reduce variability in yields that results from uncertainty around farmer area estimation and nonstandard unit conversion
* **Exchange Rates
    * MWI_IHPS_W2_exchange_rate - USD-Kwacha conversion
    * MWI_IHPS_W2_gdp_ppp_dollar - GDP-based purchasing power parity conversion, World Bank Indicator PA.NUS.PPP
    * MWI_IHPS_W2_cons_ppp_dollar - Private-consumption-based purchasing power parity conversion, World Bank Indicator PA.NUS.PRVT.P
    * MWI_IHPS_W2_inflation - Ratio of 2013:2017 Malawi consumer price index (World Bank), used for calculating poverty thresholds
* **Poverty Thresholds**
    * MWI_IHPS_W2_poverty_under_190 - The pre-2023 $1.90 2011 PPP poverty line used by the World Bank, converted to local currency
    * MWI_IHPS_W2_poverty_under_npl - The poverty threshold as reported by IFPRI, deflated to 2010 via consumer price index (CPI) adjustment
    * MWI_IHPS_W2_poverty_under_215 - The updated $2.15 2017 PPP poverty line currently used by the World Bank, converted to local currency
* **Thresholds for Winsorization:** the smallest (below the 1 percentile) and largest (above the 99 percentile) are replaced with the observations closest to them
* **Priority Crops:** the top 12 crops by area cultivated (determined by ALL PLOTS later in the code)
 
### Appending Malawi IHPS Data 
- **Description:** This section ensures cross-wave compatibility of raw data files by generating a unique HHID identifier for all waves. This code replaces the existing hhid with the newly assigned unique identifier.
- **Output:** All raw data has generated new appended data files. 
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Household IDs
- **Description:** This dataset includes hhid as a unique identifier, along with its location identifiers (i.e. rural, region, district, ta, ea_id, etc.). For households that are surveyed across multiple years (waves), a household's hhid value reflects a different format. In all cases, hhid is an anonymous, unique identifier associated with a single household.
- **Output:** `Malawi_IHPS_W2_hhids.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Weights
- **Description:** This dataset includes hhid as a unique identifier, along with its location identifiers (i.e. rural, region, district, ta, ea_id, etc.) and a weight variable provided by the LSMS-ISA raw data indicating how many households a given household represents. A higher weight indicates undersampling whereas a lower weight indicates oversampling.
- **Output:** `Malawi_IHPS_W2_weights.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Individual IDs
- **Description:** This dataset includes indiv and hhid as unique identifiers and contains variables that indicate an individual's age, whether or not they are female, and whether or not they are head of household.
- **Output:** `Malawi_IHPS_W2_person_ids.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Household Size
- **Description:** This dataset includes hhid as a unique identifier and contains variables that indicate number of individuals in a household, whether or not the head of household is female, location identifiers (i.e. rural, region, district, ta, ea_id, etc.), household sampling weight, a survey weight adjusted to match total population, and a survey weight adjust to match the rural and urban population.
- **Output:** `Malawi_IHPS_W2_hhsize.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Plot Areas
- **Description:** This dataset includes hhid, plot_id, and season as unique identifiers and contains variables that indicate estimated plot area (in hectares and acres), measure plot area (in hectares and acres), whether or not the plot area was measured with a GPS, and field size. 
- **Output:** `Malawi_IHPS_W2_plot_areas.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### GPS Coordinates
- **Description:** This dataset includes hhid as a unique identifier and contains variables for household latitude and longitude as measured by a GPS.
- **Output:** `Malawi_IHPS_W2_hh_coords.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Plot Decision Makers
- **Description:** This dataset includes hhid and plot_id as unique identifiers, along with a variable, dm_gender, representing plot decision maker gender (male, female, or mixed). 
- **Output:** `Malawi_IHPS_W2_plot_decision_makers.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Revision in progress to account for missing values

### Formalized Land Rights
- **Description:** This dataset includes hhid as a unique identifier, along with a variable indicating whether that household owns at least one plot of land.
- **Output:** `Malawi_IHPS_W2_land_rights.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### All Plots
- **Description:** This dataset includes hhid, plot_id, season, and crop_code as unique identifiers and contains location identifiers (i.e. rural, region, district, ta, ea_id, etc.) and other variables that indicate harvest quantities, hectares planted and harvested,  corresponding calories by amount of crop grown, and number of months a crop was grown.
- **Output:** `Malawi_IHPS_W2_all_plots.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Relies on conversion factor which is under review.

### Crop Expenses
- **Description:** This dataset summarizes crop expenses by input type for households in the dataset where most hhids contain multiple observations of crop expenses such as labor, seed, plot rents, fertilizer, pesticides, herbicides, animal traction rentals, and mechanized tool rentals.
- **Output:** `Malawi_IHPS_W2_plot_cost_inputs_long.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Some input categories have missing values.

### Monocropped Plots
- **Description:** This dataset includes hhid and plot_id as a unique identifier and contains variables summarizing plot characteristics for only plots that reported a single crop among priority crops (as designated by user earlier in file). 
- **Output:** Multiple `Malawi_IHPS_W2_inputs_`cn'.dta` files where `cn` refers to various crops.
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### TLU (Tropical Livestock Units)
- **Description:** This dataset includes hhid as a unique identifier and contains other variables that quantify livestock counts at two time intervals (1 year ago and today) by various livestock types including poultry, chicken specfically, cattle, cows specfically, etc.
- **Output:** `Malawi_IHPS_W2_TLU_Coefficients.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Gross Crop Revenue
- **Description:** This dataset summarizes crop production value, revenue, and losses for each household and/or household/crop type.
- **Output:** `Malawi_IHPS_W2_cropsales_value.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Livestock Income
- **Description:** This dataset includes hhid as a unique identifier and contains variables summarizing livestock revenues and costs. 
- **Output:** `Malawi_IHPS_W2_livestock_income.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Fish Income
- **Description:** This dataset includes hhid as a unique identifier and contains variables summarizing value of fish harvest and income from fish sales.
- **Output:** `Malawi_IHPS_W2_fish_income.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Self-Employment Income
- **Description:** This dataset includes hhid as a unique identifier and variables that indicate whether or not a household generated income by self-employment and amount of self-employment income in the month prior to the survey.
- **Output:** `Malawi_IHPS_W2_self_employment_income.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Non-Ag Wage Income
- **Description:** This dataset includes hhid as a unique identifier and an estimated annual salary generated by non-agricultural wages.
- **Output:** `Malawi_IHPS_W2_wage_income.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Ag Wage Income
- **Description:** This dataset includes hhid as a unique identifier and an estimated annual salary generated by agricultural wages.
- **Output:** `Malawi_IHPS_W2_agwage_income.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Other Income
- **Description:** This dataset includes hhid as a unique identifier and estimated income from other sources including remittances, assets, pensions, and assistance.
- **Output:** `Malawi_IHPS_W2_other_income.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Off-Farm Hours
- **Description:** This dataset includes hhid as a unique identifier, estimated hours spent on non-agricultural activities annualized, and number of household members working hours off the farm.
- **Output:** `Malawi_IHPS_W2_off_farm_hours.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Farm / Land Size
- **Description:** This dataset includes hhid as a unique identifier and estimated total land size (in hectares) including those rented in and out.
- **Output:** `Malawi_IHPS_W2_land_size_total.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Farm Labor
- **Description:** This dataset includes hhid as a unique identifier, number of labor days for hired laborers, number of labor days for family laborers, and number of labor days total.
- **Output:** `Malawi_IHPS_W2_family_hired_labor.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Vaccine Usage
- **Description:** This dataset includes hhid and individual id (indiv) as a unique identifier, whether or not the farmer was the livestock keeper, characteristics about the livestock keeper (age, gender, etc.) and whether or not a farmer chose to vaccinate all animals. 
- **Output:** `Malawi_IHPS_W2_vaccine_usage.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Animal Health - Diseases
- **Description:** This dataset includes hhid as a unique identifier and a series of binary variables indicating whether a household experienced livestock types having various diseases.
- **Output:** `Malawi_IHPS_W2_animal_health.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Plot Managers
- **Description:** This dataset includes hhid, plot_id, and plot manager as a unique identifier and a series of variables describing fertilizer and seed type applied.
- **Output:** `Malawi_IHPS_W2_plot_managers.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Input data discrepancies.

### Reached by Ag Extension
- **Description:** This dataset includes hhid as a unique identifier and a series of binary variables indicating whether a household was reached by particular extension types (public, private, etc.).
- **Output:** `Malawi_IHPS_W2_ag_extension.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Mobile Phone Ownership
- **Description:** This dataset includes hhid as a unique identifier and one binary variable indicating whether the household owned a mobile phone.
- **Output:** `Malawi_IHPS_W2_mobile_ownership.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Use of Formal Financial Services
- **Description:** This dataset includes hhid as a unique identifier and binary variables indicating whether a household consumed credit or other formal financial services.
- **Output:** `Malawi_IHPS_W2_financial_services.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Milk Productivity
- **Description:** This dataset includes hhid as a unique identifier and a measure of liters of milk produced and how many months milk was produced.
- **Output:** `Malawi_IHPS_W2_milk_productivity.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Egg Productivity
- **Description:** This dataset includes hhid as a unique identifier, a variable for the number of poultry, and measures for eggs produced per week, month, and per year.
- **Output:** `Malawi_IHPS_W2_egg_productivity.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Crop Production Costs Per Hectare
- **Description:** This dataset includes hhid as a unique identifier and several variables that describe explicit and total costs to by decisionmaker gender.
- **Output:** `Malawi_IHPS_W2_fertilizer_application.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** This is a legacy file kept to ensure consistency with the other LSMS waves. Because nutrient content of fertilizer can vary, the fertilizer nutrient application section is a more accurate way to estimate fertilizer use.

### Rate of Fertilizer Application
- **Description:** This dataset includes hhid as a unique identifier and several variables that describe fertilizer, pesticide, and herbicide application by weight, hectares planted, and head of household gender.
- **Output:** `Malawi_IHPS_W2_cropcosts.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Use of Inorganic Fertilizer
- **Description:** This dataset includes hhid and indiv as a unique identifiers, whether or not the farmer use inorganic fertilizer, and farmer characteristics (age, gender, etc.) 
- **Output:** `Malawi_IHPS_W2_off_farmer_fert_use.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Household's Diet Diversity Score
- **Description:** This dataset includes hhid as a unique identifier, a count of food groups (out of 12) the surveyed individual consumed last week, and whether or not a houseshold consumed at least 6 of the 12 food groups, of 8 of the 12 food groups. The Food Consumption Score (FCS) was calculated by summing the frequency of consumption of different food groups over the past 7 days, each weighted according to its nutritional value. The Reduced Coping Strategies Index (rCSI) was calculated by summing the frequency of five food-related coping behaviors used in the past 7 days, each multiplied by a standardized severity weight.
- **Output:** `Malawi_IHPS_W2_diet_diversity.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** MWI W2 does not report individual consumption but rather household level consumption of various items. Thus, only the proportion of households eating nutritious food can be estimated. 

### Women's Control Over Income
- **Description:** This dataset includes hhid and individual id (indiv) as a unique identifier and a series of binary variables describing individual gender and ownership over different income streams (e.g. salary income).
- **Output:** `Malawi_IHPS_W2_women_income_control.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** MWI W2 does not directly ask who control business income, we make the assumption that whoever owns the business may have some control over the income generated by the business. 

### Women's Participation in Agricultural Decisionmaking
- **Description:**  This dataset includes hhid and individual id (indiv) as a unique identifier and a series of binary variables describing individual gender and role in decisions related to agriculture (e.g. crops, livestock).
- **Output:** `Malawi_IHPS_W2_women_ag_decisions.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Women's Ownership of Assets
- **Description:** This dataset includes hhid and individual id (indiv) as a unique identifier and a series of binary variables describing individual gender and ownership of assets. 
- **Output:** `Malawi_IHPS_W2_women_asset_ownership.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Agricultural Wages
- **Description:** This dataset includes hhid as a unique identifier and variables describing the total wages paid out to each hired agricultural laborer as a household expense. Variables number of hired laborers and total expenses, broken down by the laborer's gender (male/female).
- **Output:** `Malawi_IHPS_W2_ag_wage.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Crop Yields
- **Description:** This dataset includes hhid as a unique identifier and variables describing the crop yield (area planted, area harvested, quantity harvested, value harvested, value sold) by crop, planting strategy, and gender of plot manager.
- **Output:** `Malawi_IHPS_W2_crop_yields.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Shannon Diversity Index
- **Description:**  This dataset includes hhid as a unique identifier and variables describing the household's crop species diversity score, with separate variables indicating SDI by gender of the head of household.
- **Output:** `Malawi_IHPS_W2_shannon_diversity_index.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Consumption
- **Description:** This dataset includes hhid as a unique identifier and a series of variables describing household consumption (e.g. total, per capita, per adult equivalent, etc.).
- **Output:** `Malawi_IHPS_W2_consumption.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** Consumption panel does not include cross section households. We constructed aggregate consumption with the cross section households that produces differences compared to the World Bank consumption method. 

### Household Food Provision
- **Description:** This dataset includes hhid as a unique identifier and a numeric variable describing months that the household experienced food insecurity.
- **Output:** `Malawi_IHPS_W2_food_security.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Household Assets
- **Description:** This dataset includes hhid as a unique identifier and a single numeric variable descrining the gross value of household assets.
- **Output:** `Malawi_IHPS_W2_hh_assets.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Food Security
- **Description:** This dataset includes hhid as a unique identifier and a series of numeric variables describing household food consumption (e.g. total, per capita, per adult equivalent, etc.).
- **Output:** `Malawi_IHPS_W2_food_cons.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Household Variables
- **Description:** This dataset includes hhid as a unique identifier and compiles all relevant variables from previous intermediate files [see sections above] on the level of an individual household.
- **Output:** `Malawi_IHPS_W2_household_variables.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Individual Level Variables
- **Description:** This dataset includes hhid and individual id (indiv) as a unique identifier and compiles all relevant variables that are available on an individual level from previous intermediate files [see sections above].
- **Output:** `Malawi_IHPS_W2_individual_variables.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Plot Level Variables
- **Description:** This dataset includes hhid and plot_id as a unique identifier and compiles all relevant variables that are available on a plot level from previous intermediate files [see sections above].
- **Output:** `Malawi_IHPS_W2_field_plot_variables.dta`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None

### Summary Statistics
- **Description:**  This section produces a file in two formats, .dta and .xlsx, that provide descriptive statistics (mean, standard deviation, quartiles, min, max) for each variable produced in the Household Variables, Individual Level Variables, and Plot Level Variables sections.
- **Output:** `Malawi_IHPS_W2_summary_stats_with_labels.dta`, `Malawi_IHS_W1_summary_stats.xlsx`
- **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- **Known Issues:** None
