# Malawi IHPS/LSMS-ISA Wave 2 (2011-2013)
CODING STATUS:Work in Progress


## Prerequisites
* Download the raw data from https://microdata.worldbank.org/index.php/catalog/2248
* Extract the files to the "Raw DTA Files" folder in the cloned directory
* Update the paths on lines 182-185 with the correct paths to the raw data and output files.

## Table of Contents
### Globals
* This section sets global variables for use later in the script, including:
  * Population
    * Malawi_IHPS_W2_pop_tot - Total population in 2013 (World Bank)
    * Malawi_IHPS_W2_pop_rur - Rural population in 2013 (World Bank)
    * Malawi_IHPS_W2_pop_urb - Urban population in 2013 (World Bank)
  * Non-GPS-Plots
    * drop_unmeas_plots - if not 0, this global will remove any plot that is not measured by GPS from the sample. Used to reduce variability in yields that results from uncertainty around farmer area estimation and nonstandard unit conversion
  * Exchange Rates
    * Malawi_IHPS_W2_exchange_rate - USD-Kwacha conversion
    * Malawi_IHPS_W2_gdp_ppp_dollar - GDP-based purchasing power parity conversion, World Bank Indicator PA.NUS.PPP
    * Malawi_IHPS_W2_cons_ppp_dollar - Private-consumption-based purchasing power parity conversion, World Bank Indicator PA.NUS.PRVT.P
    * Malawi_IHPS_W2_inflation - Ratio of 2013:2017 Malawi consumer price index (World Bank), used for calculating poverty thresholds

  * Poverty Thresholds
    * Malawi_IHPS_W2_poverty_threshold - The pre-2023 $1.90 2011 PPP poverty line used by the World Bank, converted to local currency
    * Malawi_IHPS_W2_poverty_ifpri - The poverty threshold as determined from the IFPRI, inflated to 2013 via CPI
    * Malawi_IHPS_W2_poverty_215 - The updated $2.15 2017 PPP poverty line currently used by the world bank, converted to local currency
### Winsorization Thresholds
* We correct outliers by Winsorization - setting values above the 99th and/or below the 1st percentiles to the value of the 99th or 1st percentile. The thresholds can be adjusted here or removed by setting them to 0 and 100
    * wins_lower_thres 1-Threshold for winzorization at the bottom of the distribution of continous variables
    * wins_upper_thres 99-Threshold for winzorization at the top of the distribution of continous variables	
    
### Globals of Priority Crops
* This section defines the list of crops used to report crop-specific indicators, including indicators for monocropped plots. Adjust this list to change the output.
### Household IDs
* This section simplifies the household roster and drops non-surveyed households.It processes household-level data, renaming and labeling variables for clarity, and generating a new variable to indicate rural households. y2_hhid is the unique identifier at the household level. 

**Output:**  
`Malawi_IHPS_W2_hhids.dta`

**Coding Status:**  
Complete

**Known Issues:**  
None

### Individual IDs
* Simplified household member roster

**Output:**  
`Malawi_IHPS_W2_person_ids.dta`

**Coding Status:**  
Complete

**Known Issues:** 
### Weights
* We rescale the weights to match the rural and urban populations for 2013 as reported in the World Bank Data Bank (last accessed 2023)

**Output:**  
`Malawi_IHPS_W2_weights.dta`

**Coding Status:**  
Complete

**Known Issues:**  
None

### Household Size
* Calculating the number of household members and rescaling the weights - the original weights are retained and can be used by switching all instances of weight_pop_rururb to weight

**Output:**  
`Malawi_IHPS_W2_hhsize.dta`

**Coding Status:**  
Complete

**Known Issues:**  
None

### Head of Household
* Determines gender of household head
### GPS Coordinates
* Simplified EA lat/lon. It merges household IDs with GPS coordinates and labels the GPS data level pertaining to the household identifier

**Output:**  
`Malawi_IHPS_W2_hh_coords.dta`

**Coding Status:**  
Complete

**Known Issues:**  
None
### Plot Areas
* Calculates farmer-estimated plot areas from nonstandard units and GPS-measured plot areas and converts to hectares
* If gps_area is set to something other than 0, non-measured plots are dropped; otherwise, area is determined first from GPS measurements and backfilled from respondent estimates when GPS measurements are unavailable

**Output:**  
`Malawi_IHPS_W2_plot_areas.dta`

**Coding Status:**  
Complete

**Known Issues:**
None

### Plot Decisionmakers
* Determines gender of person or people who make plot management decisions - 1: male, 2: female, or 3: mixed male and female

**Output:**  
`Malawi_IHPS_W2_plot_decision_makers.dta`

**Coding Status:**  
Incomplete

**Known Issues:**
Revision in progress to account for missing values

### Formalized Land Rights
* Determines whether a plot holder has a formal title and records formal landholder gender

**Output:**  
  * `Malawi_IHPS_W2_land_rights_ind.dta` 
  * `Malawi_IHPS_W2_land_rights_hh.dta`

**Coding Status:**  
Complete

**Known Issues:**  
None

### Crop Unit Conversion Factors
* Generates a nonstandard unit conversion factors table from reported conversions in the agricultural module, filling unknown entries with values from the literature where necessary and noted

**Output:**  

* `Malawi_IHPS_W2_cf.dta`

-**Coding Status:**  
Incomplete

-**Known Issues:**  
Working in prgress to fill in missing values

### All Plots
* Generates plot production statistics, including kilograms harvested, sales prices, imputed values, and cropping style

- **Output:**
 `Malawi_IHPS_W2_all_plots.dta`

- **Coding Status:**
Incomplete
- **Known Issues:** 
Relies on calorie conversions which is incomplete.


### TLU (Tropical Livestock Units)
* Total number of livestock owned by type and by tropical livestock unit (TLU) coefficient
 **Output:** `Malawi_IHPS_W2_TLU_Coefficients.dta`
- **Coding Status:** 
*Pending Review
- **Known Issues:**
*None

### Gross Crop Revenue
* Total value of crops sold

- **Output:**
 `Malawi_IHPS_W2_cropsales_value.dta`

- **Coding Status:**
Incomplete - under construction
- **Known Issues:** 

### Crop Expenses
* Total expenses divided among implicit/explicit and expense type, attributed at the plot level where possible.
- **Output:**

* `Malawi_IHPS_W2_plot_cost_inputs_long.dta`
* `Malawi_IHPS_W2_input_quantities.dta`
* `Malawi_IHPS_W2_hh_cost_inputs_long_complete.dta`

- **Coding Status:**
Incomplete
- **Known Issues:**
*The dataset for wave 2 has missing values for inputs tagged as "Other Specify". 
*Some observations for Pesticides/Herbicides cannot be distinguished. 
*Labor expenses section does not report the number of hired labor

### Monocropped Plots 
* Plot variables and expenses, along with some additional plot attributes as recorded in the plot roster, for only plots with a single reported crop and for only crops specified in the priority crop globals. 

- **Output:**
* Multiple ```Malawi_IHPS_W2_inputs_`cn'.dta``` files where cn refers to various crops of interest. 
- **Coding Status:**
Incomplete 
- **Known Issues:**
Relies on Plot-decision makers that is currently under review

### Livestock Income
* Values of production from reported sales of eggs, milk, other livestock products, and slaughtered livestock.
 **Output:** `Malawi_IHPS_W2_livestock_income.dta`
- **Coding Status:** 
*Pending Review
- **Known Issues:**
*None

### Fish Income
* Total value of fish caught and time spent fishing
**Output:** `Malawi_IHPS_W2_fish_income.dta`
- **Coding Status:** 
*Pending Review
- **Known Issues:**
*None
### Self-Employment Income
* Value of income from owned businesses and postharvest crop processing
**Output:** `Malawi_IHPS_W2_self_employment_income.dta`
- **Coding Status:** 
*Pending Review
- **Known Issues:**
*None

### Non-Ag Wage Income
* Value of income from non agriculatural sources
**Output:** `Malawi_IHPS_W2_wage_income.dta`
- **Coding Status:** 
*Pending Review
- **Known Issues:**
*None

### Non-Ag Wage Income
* Annual earnings from agricultural wage
**Output:** `Malawi_IHPS_W2_agwage_income.dta`
- **Coding Status:** 
*Pending Review
- **Known Issues:**
*None
### Off-Farm Hours
* Number of household members engaged in and total time spent in nonfarm activities, including waged employment
**Output:** `Malawi_IHPS_W2_off_farm_hours.dta`
- **Coding Status:** 
*Pending Review
- **Known Issues:**
*None
### Wage Income
* Income from paid employment
**Output:** `Malawi_IHPS_W2_agwage_income.dta`
- **Coding Status:** 
*Pending Review
- **Known Issues:**
*None
### Other Income
* Value of assistance, rental, pension, investments, and remittances
**Output:** `Malawi_IHPS_W2_land_rental_income.dta`
- **Coding Status:** 
*Pending Review
- **Known Issues:**
*None
### Farm Size
* Total area owned and worked
**Output:** `Malawi_IHPS_W2_land_size_total.dta`
- **Coding Status:** 
*Pending Review
- **Known Issues:**
*None
### Farm Labor
* Converts labor as recorded in the crop expense section to a wider format to maintain backwards compatibility with the summary statistics file
**Output:** `Malawi_IHPS_W2_family_hired_labor.dta`
- **Coding Status:** 
*Pending Review
- **Known Issues:**
*None
### Vaccine Usage
* Individual-level livestock vaccine use rates
**Output:** `Malawi_IHPS_W2_farmer_vaccine.dta`
- **Coding Status:** 
*Pending Review
- **Known Issues:**
*None
### Animal Health - Diseases
* Rates of disease incidence for foot and mouth, lumpy skin, black quarter, brucelosis
**Output:** `Malawi_IHPS_W2_livestock_diseases.dta`
- **Coding Status:** 
*Pending Review
- **Known Issues:**
*None

### Reached by Ag Extension
* Number and purpose of ag extension contacts received by the household
**Output:** `Malawi_IHPS_W2_any_ext.dta`
- **Coding Status:** 
*Pending Review
- **Known Issues:**
*None

### Mobile Ownership 
* This section  tracks if households own a mobile phone allowing for the analysis of mobile phone prevalence among households. Missing values for mobile ownership are recoded to zero
**Output:** `Malawi_IHPS_W2_mobile_own.dta`
- **Coding Status:** 
*Pending Review
- **Known Issues:**
*None

### Use of Formal Financial Services
* Household-level rates of bank services, lending and credit, digitial banking, insurance, and savings accounts
**Output:** `Malawi_IHPS_W2_fin_serv.dta`
- **Coding Status:** 
*Pending Review
- **Known Issues:**
*None
### Milk Productivity
* Rates of milk production by time and number of animals owned
**Output:** `Malawi_IHPS_W2_milk_animals.dta`
- **Coding Status:** 
*Pending Review
- **Known Issues:**
*None

### Use of Inorganic Fertilizers
* This section tracks the the use of inorganic fertilizer among households
**Output:** `Malawi_IHPS_W2_farmer_fert_use.dta`
- **Coding Status:** 
*Pending Review
- **Known Issues:**
*None

### Egg Productivity
* Rates of egg production by time and number of animals owned
**Output:** `Malawi_IHPS_W2_eggs_animals.dta`
- **Coding Status:** 
*Pending Review
- **Known Issues:**

### Land Rental Rates
This section computes the rental rates and areas of agricultural land during the rainy and dry seasons. It includes calculations of the area in acres and hectares, both estimated and measured, and derives the rental rates paid in cash or kind. The data is further analyzed by the gender of the decision-maker and then aggregated to various geographic levels
**Output:** `Malawi_IHPS_W2_hh_rental_rate.dta`
- **Coding Status:** 
*Pending Review
- **Known Issues:**
*None

### Agricultural Wages
* to be deprecated, (see Farm Labor)
**Output:** `Malawi_IHPS_W2_ag_wage.dta`
- **Coding Status:**
* Incomplete
- **Known Issues:**
 None

### Women's Diet Quality proportion of women consuming nutrient-rich foods (%)
* **Not constructedas information is not available**

### Household's Diet Diversity Score
* Calculates dietary diversity from reported food consumption
**Output:** `Malawi_IHPS_W2_household_diet.dta`
- **Coding Status:** 
*Pending Review
- **Known Issues:**
*None
### Women's Control Over Income
* Women's decisionmaking ability over the proceeds of crop sales, wages, business income, and other income sources.
**Output:** `Malawi_IHPS_W2_control_income.dta`
- **Coding Status:** 
*Pending Review
- **Known Issues:**
*None
### Women's Participation in Agricultural Decisionmaking 
* Detailed breakdown of the types of livestock and plot management decisions women were listed as controlling
**Output:** 
- **Coding Status:** 
*Incomplete
- **Known Issues:**
*None
### Women's Ownership of Assets
* Capital asset ownership rates among women
**Output:** `Malawi_IHPS_W2_ownasset.dta`
- **Coding Status:**
*Pending Review
- **Known Issues:**
 None

### Crop Yields
* Converts plot variables file to wider format for backwards compatibility
**Output:**
- **Coding Status:** 
Not implemented
- **Known Issues:**
*None

### Consumption
* Observed values of consumption by category to align with consumption estimates made in previous waves
**Output:** `Malawi_IHPS_W2_consumption.dta`
- **Coding Status:** 
*Pending Review
- **Known Issues:**
*None

### Household Food Provision
* Computes the number of months of inadequate food provision
**Output:** `Malawi_IHPS_W2_food_insecurity.dta`
- **Coding Status:** 
*Pending Review
- **Known Issues:**
*None

### Household Assets
* Reported value of assets owned (see questionnaire household section 5 for types of assets)
**Output:** `Malawi_IHPS_W2_hh_assets.dta`
- **Coding Status:** 
*Pending Review
- **Known Issues:**
*None
