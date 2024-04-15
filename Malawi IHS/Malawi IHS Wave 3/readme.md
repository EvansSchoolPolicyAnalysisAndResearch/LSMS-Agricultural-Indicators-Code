# Malawi IHS-IHPS Wave 3 (2016-2017)
CODING STATUS:Work in Progress

## Prerequisites
* Download the raw data from https://microdata.worldbank.org/index.php/catalog/3557
* Extract the files to the "Raw DTA Files" folder in the cloned directory
* Update the paths on lines 173-176 with the correct paths to the raw data and output files.

## Table of Contents
### Globals
* This section sets global variables for use later in the script, including:
  * Population
    * Malawi_IHS_LSMS_ISA_W3_pop_tot - Total population in 2017 (World Bank)
    * Malawi_IHS_LSMS_ISA_W3_pop_rur - Rural population in 2017 (World Bank)
    * Malawi_IHS_LSMS_ISA_W3_pop_rur - Urban population in 2017 (World Bank)
  * Non-GPS-Plots
    * drop_unmeas_plots - if not 0, this global will remove any plot that is not measured by GPS from the sample. Used to reduce variability in yields that results from uncertainty around farmer area estimation and nonstandard unit conversion
  * Exchange Rates
    * IHS_LSMS_ISA_W3_exchange_rate - USD-Kwacha conversion
    * IHS_LSMS_ISA_W3_gdp_ppp_dollar - GDP-based purchasing power parity conversion, World Bank Indicator PA.NUS.PPP
    * IHS_LSMS_ISA_W3_cons_ppp_dollar - Private-consumption-based purchasing power parity conversion, World Bank Indicator PA.NUS.PRVT.P
    * IHS_LSMS_ISA_W3_inflation - Ratio of 2017:2016 Malawi consumer price index (World Bank), used for calculating poverty thresholds
 
### Winsorization Thresholds
* We correct outliers by Winsorization - setting values above the 99th and/or below the 1st percentiles to the value of the 99th or 1st percentile. The thresholds can be adjusted here or removed by setting them to 0 and 100
    * wins_lower_thres 1-Threshold for winzorization at the bottom of the distribution of continous variables
    * wins_upper_thres 99-Threshold for winzorization at the top of the distribution of continous variables	
					
### Globals of Priority Crops
* This section defines the list of crops used to report crop-specific indicators, including indicators for monocropped plots. Adjust this list to change the output.

### Appending Malawi IHPS and IHS Data 
* IHS3 is an expansion of IHS2. A sub-sample of IHS3 EAs were surveyed twice reduce recall associated with different aspects of agricultural data collection and track and resurvey these households in 2013 as part of the Integrated Household Panel Survey 2013 (IHPS; microdata.worldbank.org/index.php/catalog/2248). Therefore, we append the panel and cross-sectional data to ensure we're working with a complete data from both panel and crossectional surveys.
* All the modules starting from Plot Areas use appended data. To run the append code for the first time:  
	* Created a "Temp" folder in "Final DTA Files" folders  
	* Commented out macro which creates "created_data" in the globals directory   
	* Created a new appended paths in the code    
 	* After running the append code, changed created_data file path back to raw/created_data in the globals directory   
  
### Household IDs
- This section simplifies the household roster and drops non-surveyed households. A new variable "rural" is generated.   
- **Output:**  
`MWI_IHS_IHPS_W3_hhids.dta`  
- **Coding Status:** 
Complete  
- **Known Issues:**    
"hhid" is recasted from strL to str# before saving the created data to ensure smooth merges in the later code.   

### Weights
- We rescale the weights to match the rural and urban populations for 2017 as reported in the World Bank Data Bank (last accessed 2023)  
- **Output:**    
`MWI_IHS_IHPS_W3_weights.dta`  
- **Coding Status:**    
Complete  
- **Known Issues:**    
"hhid" is recasted from strL to str# before saving the created data to ensure ensure consistent format and smooth merges in the later code.   

### Individual IDs
- Simplified household member roster. It contains variables that indicate an individual's age, whether or not they are female, and whether or not they are head of household.    
- **Output:**    
`MWI_IHS_IHPS_W3_person_ids.dta`  
- **Coding Status:**    
Complete  
- **Known Issues:**    
"hhid" is recasted from strL to str# before saving the created data to ensure consistent format and smooth merges in the later code.   

### Household Size
- Calculates the number of household members and rescaling the weights - the original weights are retained and can be used by switching all instances of weight_pop_rururb to weight. It contains variables number of individuals in a household, whether or not the head of household is female, location identifiers (i.e. rural, region, district, ta, ea_id, etc.), household sampling weight, a survey weight adjusted to match total population, and a survey weight adjust to match the rural and urban population.   
- **Output:**    
`MWI_IHS_IHPS_W3_hhsize.dta`  
- **Coding Status:**    
Complete  
- **Known Issues:**    
"hhid" is recasted from strL to str# before merging to ensure consistent "hhid" format after merge

### GPS Coordinates
- Simplified EA lat/lon measured by a GPS   
- **Output:**    
`MWI_IHS_IHPS_W3_hh_coords.dta`  
- **Coding Status:**    
Complete  
- **Known Issues:**    
"hhid" is recasted from strL to str# before merging to ensure consistent "hhid" format after merge

### Plot Areas  
- Calculates farmer-estimated plot areas from nonstandard units and GPS-measured plot areas and converts to hectares  
- **Output:**  
`MWI_IHS_IHPS_W3_plot_areas.dta`  
- **Coding Status:**   
Complete  
- **Known Issues:**    
"hhid" is recasted from strL to str# before saving the created data to ensure consistent format   

### Plot Decisionmakers    
- Determines gender of person or people who make plot management decisions - 1: male, 2: female, or 3: mixed male and female.         
- **Output:**    
`MWI_IHS_IHPS_W3_plot_decision_makers.dta`  
- **Coding Status:**    
In Progress   
- **Known Issues:**  
Currently revising the code to account for missing values and eliminate unmatched observation

### Formalized Land Rights  
- Determines whether a plot holder has a formal title and records formal landholder gender  
- **Output:**    
`MWI_IHS_IHPS_W3_land_rights_ind.dta`   
`MWI_IHS_IHPS_W3_rights_hh.dta`  
- **Coding Status:**    
Complete 
- **Known Issues:**
Using garden level data instead of plot level data. 

### Crop Unit Conversion Factors
- Generates a nonstandard unit conversion factors table from reported conversions in the agricultural module, filling unknown entries with values from the literature where necessary and noted  
- **Output:**   
`MWI_IHS_IHPS_W3_cf.dta`    
- **Coding Status:**   
In progress  
- **Known Issues:**  
Not all plots culitivating crops reported a plot decision maker. We handle this by backfilling plot decision maker with plot owner is missing, and head of household if missing still. A secondary issue is that the instrument did not collect a plot decision maker for tree and permanent crops. We handle this by assuming that the household in charge of earnings for a specific crop is also the plot decision maker, provided that a household only grows that crop on one plot and not multiple. For households that grow a crop on multiple plots, we assume that the head of household is the plot decision maker for those plots. Currently in progress to account for non-strandard conversion units. 

### All Plots  
- Generates plot production statistics, including kilograms harvested, sales prices, imputed values, and cropping style  
- **Output:**    
`MWI_IHS_IHPS_W3_all_plots.dta`  
- **Coding Status:**    
Complete  
- **Known Issues:**  
Self-employment income does not report crop sales. No "still-to-harvest" value recorded in survey.  
  
### TLU (Tropical Livestock Units)
- Total number of livestock owned by type and by tropical livestock unit (TLU) coefficient    
- **Output:**      
`MWI_IHS_IHPS_W3_TLU_Coefficients.dta`    
- **Coding Status:**     
Complete   
- **Known Issues:**    
None    

### Gross Crop Revenue
- Total value of crops sold  
- **Output:**  
`MWI_IHS_IHPS_W3_crop_losses.dta`  
- **Coding Status:**  
Complete
- **Known Issues:**   
None 

### Crop Expenses
- Total expenses divided among implicit/explicit and expense type, attributed at the plot level where possible.  
- **Output:**  
`MWI_IHS_IHPS_W3_input_quantities.dta`  
`MWI_IHS_IHPS_W3_hh_cost_inputs_long.dta`  
`MWI_IHS_IHPS_W3_hh_cost_inputs_long_complete.dta`  
- **Coding Status:**  
In progress  
- **Known Issues:**
	* LABOR: Labor expense estimates are severely understated for several reasons: 1. the survey instrument did not ask for number of hired labors. Therefore, the constructed value of hired labor for some households could represent all hired labor costs or per laborer hired labor costs. 2. We typically use the value of hired labor to imput the value of family and nonhired (exchange) labor. However, due to issues with how hired labor is contructed, we cannot use these values to impute the value of family or nonhired (exchange) labor.
	* PLOT RENTS: Some rainy season data is missing. The final output on plot rents has too few of observations as compared to reported plot rents in the raw data. Releies on completion of plot decisionmakers

### Monocropped Plots
- Plot variables and expenses, along with some additional plot attributes as recorded in the plot roster, for only plots with a single reported crop and for only crops specified in the priority crop globals. For this wave, we also estimate the total nutrition application from fertilizers.  
- **Output:**  
`MWI_IHS_IHPS_W3_inputs_`cn'.dta`  
- **Coding Status:**  
Complete   
- **Known Issues:**  
Will be reviewed after updating Plot Decisionmakers section. 

### Livestock Income
- Values of production from reported sales of eggs, milk, other livestock products, and slaughtered livestock.  
- **Output:**  
`MWI_IHS_IHPS_W3_inputs_livestock_income`  
- **Coding Status:**  
Complete  
- **Known Issues:**  
None   

### Fish Income  
- Total value of fish caught and time spent fishing  
- **Output:**   
`MWI_IHS_IHPS_W3_inputs_fish_income.dta`  
`MWI_IHS_IHPS_W3_fish_trading_income.dta`  
- **Coding Status:**   
Complete 
- **Known Issues:**  
None  

### Self-Employment Income  
- Value of income from owned businesses and postharvest crop processing  
- **Output:**    
`MWI_IHS_IHPS_W3_self_employment_income.dta`  
- **Coding Status:**   
Complete  
- **Known Issues:**   
Our reported measure of self-employment income does not reflect an annual measure of self-employment income and only represent self-employment income earned in the month prior to the survey.

### Wage Income  
- Income from paid employment  
- **Output:**  
`MWI_IHS_IHPS_W3_wage_income.dta` -Non-Ag Wage Income     
`MWI_IHS_IHPS_W3_agwage_income.dta` -Ag Wage Income    
- **Coding Status:**   
Complete
- **Known Issues:**  
None 

### Other Income
- Value of assistance, rental, pension, investments, and remittances. Broken down into Land Rental Income and Other income   
- **Output:**  
`MWI_IHS_IHPS_W3_other_income.dta`  
`MWI_IHS_IHPS_W3_land_rental_income.dta`  
- **Coding Status:**  
Complete  
- **Known Issues:**  
Land Rents reported in garden level. Very small number of households actually reported land rental income.


### Off Farm Hours
- Estimated hours spent on non-agricultural activities annualized, and number of household members working hours off the farm.
- **Output:**  
`MWI_IHS_IHPS_W3_off_farm_hours.dta`  
- **Coding Status:**   
- Complete  
**Known Issues:**  
Currently reporting off farm hours per week - may want to impute for annual values.

### Farm Size / Land Size
- Estimated total land size (in hectares) including those rented in and out
- **Output:**  
`MWI_IHS_IHPS_W3_land_size_total.dta`  
- **Coding Status:**   
Complete  
- **Known Issues:**  
None 

### Farm Labor
- Estimated number of labor days for hired laborers, number of labor days for family laborers, and number of labor days total.
- **Output:**  
`MWI_IHS_IHPS_W3_family_hired_labor.dta`  
- **Coding Status:**   
Complete  
- **Known Issues:**  
Currently reporting off farm hours per week - may want to impute for annual values.

### Vaccine Usage  
- Individual-level livestock vaccine use rates  
- **Output:**  
`MWI_IHS_IHPS_W3_farmer_vaccine.dta`  
- **Coding Status:**   
Complete 
- **Known Issues:**  
None 

### Animal Health (Diseases)
- Rates of disease incidence for foot and mouth, lumpy skin, black quarter, brucelosis
- **Output:**  
`MWI_IHS_IHPS_W3_livestock_diseases.dta`  
- **Coding Status:**   
Complete 
- **Known Issues:**  
None 

### Plot Managers 
- This section combines the use of improved seed and plot decision makers at the manager level. 
- **Output:**  
`MWI_IHS_IHPS_W3_farmer_improved_hybrid_seed_use.dta`
`MWI_IHS_IHPS_W3_input_use.dta`
- **Coding Status:** 
Complete 
- **Known Issues:**
None 

### Reached by Ag Extension  
- Number and purpose of ag extension contacts received by the household  
- **Output:**  
`MWI_IHS_IHPS_W3_any_ext.dta`  
- **Coding Status:**   
Complete
- **Known Issues:**  
None  

### Mobile Ownership 
- This section tracks if households own a mobile phone allowing for the analysis of mobile phone prevalence among households. Missing values for mobile ownership are recoded to zero  
- **Output:**  
`MWI_IHS_IHPS_W3_fin_mobile_own.dta`  
- **Coding Status:**   
Complete  
- **Known Issues:**  
None

### Use of Formal Financial Services  
- Household-level rates of bank services, lending and credit, digitial banking, insurance, and savings accounts  
- **Output:**  
`MWI_IHS_IHPS_W3_fin_serv.dta`    
- **Coding Status:**   
Complete 
- **Known Issues:**  
None  

### Milk Productivity  
- Rates of milk production by time and number of animals owned  
- **Output:**  
`MWI_IHS_LSMS_ISA_W3_milk_animals.dta`  
- **Coding Status:**   
Complete
- **Known Issues:**  
None  

### Egg Productivity  
- Rates of egg production by time and number of animals owned  
- **Output:**  
 `MWI_IHS_IHPS_W3_eggs_animals.dta`    
- **Coding Status:**   
Complete 
- **Known Issues:**
None 

### Crop Production Costs Per Hectare 
- Calculates cost production costs per hecatre 
- **Output:**    
`MWI_IHS_IHPS_W3_cropcosts.dta`
- **Coding Status:** 
Complete 
- **Known Issues:**
None

### Use of Inorganic Fertilizer
- Rate of inorganic fertilizer among households 
- **Output:**  
`MWI_IHS_IHPS_W3_farmer_fert_use.dta`  
- **Coding Status:**   
Complete 
- **Known Issues:**  
None 

### Use of Improved Seed
- This section examines if individuals use any improved seed on any plot.
- **Output:**    
 `MWI_IHS_IHPS_W3_improvedseed_use.dta`
- **Coding Status:** 
Complete
- **Known Issues:**
None
 
### Rate of Fertilizer Application
- Calculates rates of fertilizer applied by male/female/mix gendered plots.
- **Output:**     
 `MWI_IHS_IHPS_W3_fertilizer_application.dta`
- **Coding Status:** 
Complete 
- **Known Issues:**
None

### Household's Dietary Diversity Score
- Calculates dietary diversity from reported food consumption
- **Output:**     
`MWI_IHS_IHPS_W3_household_diet.dta`
- **Coding Status:** 
Pending Review
- **Known Issues:**
None 

### Women's Control Over Income
- Women's decisionmaking ability over the proceeds of crop sales, wages, business income, and other income sources.
- **Output:**     
`MWI_IHS_IHPS_W3_control_income.dta`
- **Coding Status:** 
Pending Review
- **Known Issues:**
None

### Women's Participation in Agricultural Decision Making 
- Detailed breakdown of the types of livestock and plot management decisions women were listed as controlling
- **Output:**     
`MWI_IHS_IHPS_W3_make_ag_decision.dta`
- **Coding Status:** 
Complete 
- **Known Issues:**
None

### Women's Ownership of Assets
- Capital asset ownership rates among women
- **Output:**     
`MWI_IHS_IHPS_W3_ownasset.dta`
- **Coding Status:**
Complete 
- **Known Issues:**
None

### Crop Yields
- Converts plot variables file to wider format for backwards compatibility
- **Output:**     
`MWI_IHS_IHPS_W3_trees.dta`
`MWI_IHS_IHPS_W3_crop_harvest_area_yield.dta`
`MWI_IHS_IHPS_W3_yield_hh_crop_level.dta`
- **Coding Status:** 
Incomplete 
- **Known Issues:**
None

### Shannon Diversity Index
- Calculates the shannon diversity index by plots per household, number of crops by gender.
- **Output:**      
 `MWI_IHS_IHPS_W3_shannon_diversity_index.dta`
- **Coding Status:** 
Complete
- **Known Issues:**
None

### Consumption
- This dataset includes case_id and hhid as a unique identifier and a series of variables describing household consumption (e.g. total, per capita, per adult equivalent, etc.).
- **Output:**      
`MWI_IHS_IHPS_W3_consumption.dta`
- **Coding Status:** 
Complete
- **Known Issues:** 
None

### Household food provision
- Calculates months that the household experienced food insecurity.
- **Output:**      
`MWI_IHS_IHPS_W3_food_security.dta`
- **Coding Status:** 
Complete 
- **Known Issues:** 
None

### Household Assets
- Reported value of assets owned
- **Output:**    
`MWI_IHS_IHPS_W3_hh_assets.dta`
- **Coding Status:** 
Complete 
- **Known Issues:** 
None

### Food Security
- Calculates household food consumption (e.g. total, per capita, per adult equivalent, etc.).
- **Output:**     
`MWI_IHS_IHPS_W3_food_cons.dta`
- **Coding Status:** 
Complete 
- **Known Issues:** 
None
 

