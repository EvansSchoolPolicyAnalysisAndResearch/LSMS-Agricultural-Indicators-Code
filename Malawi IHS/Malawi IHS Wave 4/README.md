# Malawi_IHS-IHPS Wave 4 (2019-2020)
CODING STATUS: Work in progress

## Prerequisites
* Download the raw data from https://microdata.worldbank.org/index.php/catalog/3818
* Extract the files to the "Raw DTA Files" folder in the cloned directory
* Update the paths on lines 131 and 136-139 with the correct paths to the raw data and output files. (is this still true) 

## Table of Contents
### Globals
* This section sets global variables for use later in the script, including:
  * Population
    * MWI_IHS_IHPS_W4_pop_tot - Total population in 2018 (World Bank)
    * MWI_IHS_IHPS_W4_pop_rur - Rural population in 2018 (World Bank)
    * MWI_IHS_IHPS_W4_pop_urb - Urban population in 2018 (World Bank)
  * Non-GPS-Plots
    * drop_unmeas_plots - if not 0, this global will remove any plot that is not measured by GPS from the sample. Used to reduce variability in yields that results from uncertainty around farmer area estimation and nonstandard unit conversion
  * Exchange Rates
    * MWI_IHS_IHPS_W4_exchange_rate - USD-Kwacha conversion
    * MWI_IHS_IHPS_W4_gdp_ppp_dollar - GDP-based purchasing power parity conversion, World Bank Indicator PA.NUS.PPP
    * MWI_IHS_IHPS_W4_cons_ppp_dollar - Private-consumption-based purchasing power parity conversion, World Bank Indicator PA.NUS.PRVT.PP
    * MWI_IHS_IHPS_W4_inflation - Ratio of 2015:2016 Malawi consumer price index (World Bank), used for calculating poverty thresholds
  * Poverty Thresholds
    * MWI_IHS_IHPS_W4_pov_threshold (1.90*78.7) - The pre-2023 $1.90 2011 PPP poverty line used by the World Bank, converted to local currency
    * MWI_IHS_IHPS_W4_poverty_nbs 7184 *(1.5263367917) - The poverty threshold as determined from the National Statistics Bureau frrom 2015-2016 adjusted to 2018-2019, via CPI
    * MWI_IHS_W4_poverty_215 2.15 - The updated $2.15 2017 PPP poverty line currently used by the world bank, converted to local currency
 
### Winsorization Thresholds
* We correct outliers by Winsorization - setting values above the 99th and/or below the 1st percentiles to the value of the 99th or 1st percentile. The thresholds can be adjusted here or removed by setting them to 0 and 100
    * wins_lower_thres 1-Threshold for winzorization at the bottom of the distribution of continous variables
    * wins_upper_thres 99-Threshold for winzorization at the top of the distribution of continous variables	
					
### Globals of Priority Crops
*This section defines the list of crops used to report crop-specific indicators, including indicators for monocropped plots. Adjust this list to change the output.
 *The topcrops for Malawi W4 are "maize rice wheat sorgum pmill cowpea grdnt beans yam swtptt cassav banana cotton sunflr pigpea"

###Appending Malawi IHPS and IHS Data 
*IHS3 is an expansion of IHS2. A sub-sample of IHS3 EAs were surveyed twice reduce recall associated with different aspects of agricultural data collection (ii) track and resurvey these households in 2013 as part of the Integrated Household Panel Survey 2013 (IHPS; microdata.worldbank.org/index.php/catalog/2248). Therefore, we append the panel and cross-sectional data to ensure we're working with a complete data from both panel and crossectional surveys.
*All the modules starting from Plot Areas use appended data. To run the append code for the first time:
	*Created a "Temp" folder in "Final DTA Files" folders
	*Commented out macro which creates "created_data" in the globals directory 
	*Created a new appended paths in the code  
 	*After running the append code, changed created_data file path back to raw/created_data in the globals directory 

### Household IDs
* This section simplifies the household roster and drops non-surveyed households. A new variable "rural" is generated. 
**Output:**  
`MWI_IHS_IHPS_W4_hhids.dta`
**Coding Status:**  
Complete
**Known Issues:**  
"hhid" is recasted from strL to str# before saving the created data to ensure smooth merges in the later code. 

### Weights
* We rescale the weights to match the rural and urban populations for 2017 as reported in the World Bank Data Bank (last accessed 2023)
**Output:**  
`MWI_IHS_IHPS_W4_weights.dta`
**Coding Status:**  
Complete
**Known Issues:**  
"hhid" is recasted from strL to str# before saving the created data to ensure ensure consistent format and smooth merges in the later code. 

### Individual IDs
* Simplified household member roster
**Output:**  
`MWI_IHS_IHPS_W4_person_ids.dta`
**Coding Status:**  
Complete
**Known Issues:**  
"hhid" is recasted from strL to str# before saving the created data to ensure consistent format and smooth merges in the later code. 

### Household Size
* Calculating the number of household members and rescaling the weights - the original weights are retained and can be used by switching all instances of weight_pop_rururb to weight
**Output:**  
`MWI_IHS_IHPS_W4_hhsize.dta`
**Coding Status:**  
Complete
**Known Issues:**  
"hhid" is recasted from strL to str# before merging to ensure consistent "hhid" format after merge

### GPS Coordinates
* Simplified EA lat/lon
**Output:**  
`MWI_IHS_IHPS_W4_hh_coords.dta`
**Coding Status:**  
Complete
**Known Issues:**  
"hhid" is recasted from strL to str# before merging to ensure consistent "hhid" format after merge

### Plot Areas
* Calculates farmer-estimated plot areas from nonstandard units and GPS-measured plot areas and converts to hectares
* If gps_area is set to something other than 0, non-measured plots are dropped; otherwise, area is determined first from GPS measurements and backfilled from respondent estimates when GPS measurements are unavailable
**Output:**  
`MWI_IHS_IHPS_W4_plot_areas.dta`
**Coding Status:**  
Complete
**Known Issues:**  
"hhid" is recasted from strL to str# before saving the created data to ensure consistent format 

### Plot Decisionmakers
* Determines gender of person or people who make plot management decisions - 1: male, 2: female, or 3: mixed male and female
**Output:**  
`MWI_IHS_IHPS_W4_plot_decision_makers.dta`
**Coding Status:**  
In Progress 
**Known Issues:**
*Currently revising the code to account for missing values
*No plot or garden id in hh_mod_b, appended ag_mod_o2 does have plot and garden id

### Formalized Land Rights
* Determines whether a plot holder has a formal title and records formal landholder gender
**Coding Status:**  
In Complete 
**Known Issues:**  
  *Formalized Land Rights data is unavailable for W4	

### Crop Unit Conversion Factors
* Generates a nonstandard unit conversion factors table from reported conversions in the agricultural module, filling unknown entries with values from the literature where necessary and noted
**Output:** 
`MWI_IHS_IHPS_W4_cf.dta`
-**Coding Status:**  
In progress
-**Known Issues:**  
Currently filling out the missing values 

### All Plots
* Generates plot production statistics, including kilograms harvested, sales prices, imputed values, and cropping style
- **Output:** 
**Output:**  
`MWI_IHS_IHPS_W4_all_plots.dta`
**Coding Status:**  
In progress
**Known Issues:**  
Relies on conversion factor which is in progress 

### TLU (Tropical Livestock Units)
* Total number of livestock owned by type and by tropical livestock unit (TLU) coefficient
 **Output:** 
 `MWI_IHS_IHPS_W4_TLU_Coefficients.dta`
- **Coding Status:** 
Incomplete 
- **Known Issues:**
*None

### Gross Crop Revenue
* Total value of crops sold
- **Output:**
`MWI_IHS_IHPS_W4_hh_crop_prices.dta`
- **Coding Status:**
In progress (Incomplete) 
- **Known Issues:** 
Relies on conversion unit conversion factor which is in progress 

### Crop Expenses
* Total expenses divided among implicit/explicit and expense type, attributed at the plot level where possible.
- **Output:**
* `MWI_IHS_IHPS_W4_input_quantities.dta`
* `MWI_IHS_IHPS_W4_hh_cost_inputs_long.dta`
* `MWI_IHS_IHPS_W4_hh_cost_inputs_long_complete.dta`
- **Coding Status:**
In progress (Incomplete)
- **Known Issues:**
*Some rainy season data is missing for Land/Plot Rent 

### Monocropped Plots
* Plot variables and expenses, along with some additional plot attributes as recorded in the plot roster, for only plots with a single reported crop and for only crops specified in the priority crop globals. For this wave, we also estimate the total nutrition application from fertilizers.
- **Output:**
 `MWI_IHS_IHPS_W4_inputs_`cn'.dta`
- **Coding Status:**
Pending Review 
- **Known Issues:**
Relies on plot decisionmakers module which is in progress 

### Livestock Income
* Values of production from reported sales of eggs, milk, other livestock products, and slaughtered livestock.
- **Output:**
 `MWI_IHS_IHPS_W4_livestock_income.dta`
- **Coding Status:**
Incomplete (Pending Review) 
- **Known Issues:**
None 

### Fish Income
* Total value of fish caught and time spent fishing
**Output:** 
*`MWI_IHS_IHPS_W4_weeks_fish_trading.dta'
*`MWI_IHS_IHPS_W4_fish_trading_income.dta'
- **Coding Status:** 
Incomplete
- **Known Issues:**
*None

### Other Income
* Value of assistance, rental, pension, investments, and remittances. Broken down into Land Rental Income and Other income 
- **Output:**
 *`MWI_IHS_IHPS_W4_other_income.dta`
 *`MWI_IHS_IHPS_W4_land_rental_income.dta'
- **Coding Status:**
Incomplete (Pending Review) 
- **Known Issues:**
* MWI W4 has land rents at the GARDEN level.
* Questionnaire shows AG MOD B2 Q19 asking " how much did you ALREADY receive from renting out this garden in the rainy season", but q19 is omitted from the raw data
* We do have Q B217: "How much did you receive from renting out this garden in the rainy season"
* Cross section got q17 whereas panel got q19;
* for MSAI request, refer only to cross section (prefer q17); for general LSMS purposes, need to incorporate the panel data

### Crop Income
* Value of income from owned businesses and postharvest crop processing
**Output:**
 `MWI_IHS_IHPS_W4_crop_income.dta`
- **Coding Status:** 
Incomplete (Needs revision)
- **Known Issues:**
*None

### Self-Employment Income
* Value of income from owned businesses and postharvest crop processing
**Output:**
 `MWI_IHS_IHPS_W4_self_employment_income.dta`
- **Coding Status:** 
Incomplete (Needs revision)
- **Known Issues:**
*None

### Non-Ag Wage Income
* Value of income from non agricultural wages
**Output:**
 `MWI_IHS_IHPS_W4_wage_income.dta`
- **Coding Status:** 
Incomplete (Needs revision)
- **Known Issues:**
*None

### Ag Wage Income
* Value of income from agricultural wages
**Output:**
 `MWI_IHS_IHPS_W4_agwage_income.dta`
- **Coding Status:** 
Incomplete (Needs revision)
- **Known Issues:**
*None

### Vaccine Usage
* Individual-level livestock vaccine use rates
**Output:**
 `MWI_IHS_IHPS_W4_farmer_vaccine.dta`
- **Coding Status:** 
Incomplete (Needs revision)
- **Known Issues:**
*None

### Animal Health
* Rates of disease incidence for foot and mouth, lumpy skin, black quarter, brucelosis 
**Output:**
- **Coding Status:** 
Incomplete (missing)
- **Known Issues:**
*None

### Livestock Water, Feeding, and Housing
* Cannot replicate for MWI
**Output:**
- **Coding Status:** 
Incomplete (missing)
- **Known Issues:**
*

### Use of Inorganic Fertilizer
* This section tracks the the use of inorganic fertilizer among households
**Output:**
 `MWI_IHS_IHPS_W4_farmer_fert_use.dta`
- **Coding Status:** 
Incomplete
- **Known Issues:**
*Cannot replicated for MWI

### Use of Improved Seed
* 
**Output:**
- **Coding Status:** 
Incomplete (missing)
- **Known Issues:**
*Cannot replicated for MWI

### Reached by Ag Extension
* Number and purpose of ag extension contacts received by the household
**Output:**
 `MWI_IHS_IHPS_W4_any_ext.dta`
- **Coding Status:** 
Incomplete (Needs revision)
- **Known Issues:**
*None

### Mobile Ownership 
* This section  tracks if households own a mobile phone allowing for the analysis of mobile phone prevalence among households. Missing values for mobile ownership are recoded to zero
**Output:**
 `MWI_IHS_IHPS_W4_mobile_own.dta
- **Coding Status:** 
Incomplete (Needs revision)
- **Known Issues:**
*None

### Use of Formal Financial Services
* Household-level rates of bank services, lending and credit, digitial banking, insurance, and savings accounts
**Output:**
 `MWI_IHS_IHPS_W4_fin_serv.dta`
- **Coding Status:** 
Incomplete (Needs revision)
- **Known Issues:**
*None

### Milk Productivity
* Rates of milk production by time and number of animals owned
**Output:**
 `MWI_IHS_IHPS_W4_milk_animals.dta`
- **Coding Status:** 
Incomplete (Needs revision)
- **Known Issues:**
*None

### Egg Productivity
* Rates of egg production by time and number of animals owned
**Output:**
 `MWI_IHS_IHPS_W4_eggs_animals.dta`
- **Coding Status:** 
Incomplete (Needs revision)
- **Known Issues:**
*None

### Consumption
* Rates of consumption per capita and adult equivalent
**Output:**
 `MWI_IHS_IHPS_W4_consumption.dta`
- **Coding Status:** 
Incomplete (Needs revision)
- **Known Issues:**
*None

### Household Food Provision
* Computes the number of months of inadequate food provision
**Output:**
 `MWI_IHS_IHPS_W4_food_insecurity.dta`
- **Coding Status:** 
Incomplete (Needs revision)
- **Known Issues:**
*None

### Household Assets
* Reported value of assets owned (see questionnaire household module L for types of assets)
**Output:**
 `MWI_IHS_IHPS_W4_hh_assets.dta`
- **Coding Status:** 
Incomplete (Needs revision)
- **Known Issues:**
*None

### Shannon Diversity Index
* Calculates the shannon diversity index by plots per household, number of crops by gender
**Output:**
 `MWI_IHS_IHPS_W4_shannon_diversity_index.dta`
- **Coding Status:** 
Incomplete (Needs revision)
- **Known Issues:**
*None

### Agricultural Wages
* Computes wages paid in dry and rainy season
**Output:**
 `MWI_IHS_IHPS_W4_wages_dryseason.dta`
- **Coding Status:** 
Incomplete (Needs revision)
- **Known Issues:**
*None

### Rate of Fertilizer Application
* Calculates rates of fertilizer applied by male/female/mix gendered plots
**Output:**
 `MWI_IHS_IHPS_W4_fertilizer_application.dta`
- **Coding Status:** 
Incomplete (Needs revision)
- **Known Issues:**
*None

### Household's Diet Diversity Score
* * Calculates dietary diversity from reported food consumption
**Output:**
 `MWI_IHS_IHPS_W4_household_diet.dta`
- **Coding Status:** 
Incomplete (Needs revision)
- **Known Issues:**
*W4 does not report individual consumption but instead household level consumption of various food items. Thus, only the proportion of household eating nutritious food can be estimated

