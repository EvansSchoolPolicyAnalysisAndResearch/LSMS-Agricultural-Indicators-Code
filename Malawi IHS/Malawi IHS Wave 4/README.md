# Malawi_IHS-IHPS Wave 4 (2019-2020)
CODING STATUS: Work in progress
- ![Incomplete](https://placehold.co/15x15/f03c15/f03c15.png) `Incomplete`
- ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
- ![Pending Review](https://placehold.co/15x15/1589F0/1589F0.png) `Pending Review`

## Prerequisites
* Download the raw data from MWI Fifth Integrated Household Survey (IHS) 2019-2020 at https://microdata.worldbank.org/index.php/catalog/3818 and the long panel survey (IHPS) at https://microdata.worldbank.org/index.php/catalog/3819. The long panel survey download contains all four LSMS-ISA waves.
* Extract the files to the "Raw DTA Files" folder in the cloned directory
* Update the paths on lines 176-177 and 180-184 with the correct paths to the raw data and output files. 

## Table of Contents
### Globals
* This dataset sets global variables for use later in the script, including:
  * Population
    * MWI_IHS_IHPS_W4_pop_tot - Total population in 2018 (World Bank)
    * MWI_IHS_IHPS_W4_pop_rur - Rural population in 2018 (World Bank)
    * MWI_IHS_IHPS_W4_pop_urb - Urban population in 2018 (World Bank)
  * Exchange Rates
    * MWI_IHS_IHPS_W4_exchange_rate - USD-Kwacha conversion
    * MWI_IHS_IHPS_W4_gdp_ppp_dollar - GDP-based purchasing power parity conversion, World Bank Indicator PA.NUS.PPP
    * MWI_IHS_IHPS_W4_cons_ppp_dollar - Private-consumption-based purchasing power parity conversion, World Bank Indicator PA.NUS.PRVT.PP
    * MWI_IHS_IHPS_W4_inflation - Ratio of 2015:2016 Malawi Consumer Price Index (CPI) (World Bank), used for calculating poverty thresholds
  * Poverty Thresholds
    * MWI_IHS_IHPS_W4_pov_threshold (1.90*78.7) - The pre-2023 $1.90 2011 PPP poverty line used by the World Bank, converted to local currency
    * MWI_IHS_IHPS_W4_poverty_nbs 7184 *(1.5263367917) - The poverty threshold as determined from the National Statistics Bureau frrom 2015-2016 adjusted to 2018-2019, via CPI
    * MWI_IHS_W4_poverty_215 2.15 - The updated $2.15 2017 PPP poverty line currently used by the world bank, converted to local currency
 
### Winsorization Thresholds
* We correct outliers by Winsorization - setting values above the 99th and/or below the 1st percentiles to the value of the 99th or 1st percentile. The thresholds can be adjusted here or removed by setting them to 0 and 100
     * wins_lower_thres 1-Threshold for winzorization at the bottom of the distribution of continous variables
     * wins_upper_thres 99-Threshold for winzorization at the top of the distribution of continous variables	
					
### Globals of Priority Crops
* This dataset defines the list of crops used to report crop-specific indicators, including indicators for monocropped plots. Adjust this list to change the output.
 * The topcrops for Malawi W4 are "maize groundnut nkhwani mango soyabean pigpea tobacco cassava beans sorghum sweet potato rice"

### Appending Malawi IHPS and IHS Data 
* IHS3 is an expansion of IHS2. A sub-sample of IHS3 EAs were surveyed twice reduce recall associated with different aspects of agricultural data collection (ii) track and resurvey these households in 2013 as part of the Integrated Household Panel Survey 2013 (IHPS; microdata.worldbank.org/index.php/catalog/2248). Therefore, we append the panel and cross-datasetal data to ensure we're working with a complete data from both panel and crosdatasetal surveys.  
* All the modules starting from Plot Areas use appended data. To run the append code for the first time:  
	* Commented out macro which creates "created_data" in the globals directory  
	* Created a new appended paths in the code  
 	* After running the append code, changed created_data file path back to raw/created_data in the globals directory 

### Household IDs
* This dataset includes y4_hhid as a unique identifier, along with its location identifiers (i.e. rural, region, district, ta, ea_id, etc.). This dataset simplifies the household roster and drops non-surveyed households. A new variable "rural" is generated. 
* **Output:** `MWI_IHS_IHPS_W4_hhids.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`  
* **Known Issues:** "hhid" is recasted from strL to str# before saving the created data to ensure smooth merges in the later code. 

### Weights
* This dataset includes y4_hhid as a unique identifier, along with its location identifiers (i.e. rural, region, district, ta, ea_id, etc.) and a weight variable provided by the LSMS-ISA raw data indicating how many households a given household represents. A higher weight indicates undersampling whereas a lower weight indicates oversampling.
* **Output:** `MWI_IHS_IHPS_W4_weights.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`  
* **Known Issues:** "hhid" is recasted from strL to str# before saving the created data to ensure ensure consistent format and smooth merges in the later code. 

### Individual IDs
* This dataset includes indiv and y4_hhid as unique identifiers and contains variables that indicate an individual's age, whether or not they are female, and whether or not they are head of household.
* **Output:** `MWI_IHS_IHPS_W4_person_ids.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`
* **Known Issues:** "hhid" is recasted from strL to str# before saving the created data to ensure consistent format and smooth merges in the later code.  

### Household Size
* This dataset includes y4_hhid as a unique identifiers and contains variables that indicate number of individuals in a household, whether or not the head of household is female, location identifiers (i.e. rural, region, district, ta, ea_id, etc.), household sampling weight, a survey weight adjusted to match total population, and a survey weight adjust to match the rural and urban population.
* **Output:** `MWI_IHS_IHPS_W4_hhsize.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete` 
* **Known Issues:** "hhid" is recasted from strL to str# before merging to ensure consistent "hhid" format after merge.

### Plot Areas  
* This dataset includes y4_hhid, plot_id, and season as unique identifiers and contains variables that indicate estimated plot area (in hectares and acres), measure plot area (in hectares and acres), whether or not the plot area was measured with a GPS, and field size.
* **Output:** `MWI_IHS_IHPS_W4_plot_areas.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`  
* **Known Issues:** "hhid" is recasted from strL to str# before saving the created data to ensure consistent format. If gps_area is set to something other than 0, non-measured plots are dropped; otherwise, area is determined first from GPS measurements and backfilled from respondent estimates when GPS measurements are unavailable. 

### GPS Coordinates
* This dataset includes y4_hhid as a unique identifier and contains variables for household latitude and longitude as measured by a GPS.
* **Output:** `MWI_IHS_IHPS_W4_hh_coords.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`  
* **Known Issues:** "hhid" is recasted from strL to str# before merging to ensure consistent "hhid" format after merge. 

### Plot Decision Makers
* This dataset includes y4_hhid and plot_id as unique identifiers, along with a variable, dm_gender, representing plot decision maker gender (male, female, or mixed).
* **Output:** `MWI_IHS_IHPS_W4_plot_decision_makers.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete` 
* **Known Issues:** None  

### Formalized Land Rights
* This dataset determines whether a plot holder has a formal title and records formal landholder gender.  
* **Output:** Excluded  
* **Coding Status:** Excluded  
* **Known Issues:** Formalized Land Rights question is present in the questionnaire but the data is missing. Unable to complete this dataset due to the lack of data.  

### Crop Unit Conversion Factors
* This dataset generates a nonstandard unit conversion factors table from reported conversions in the agricultural module, filling unknown entries with values from the literature where necessary and noted.  
* **Output:** `MWI_IHS_IHPS_W4_cf.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`   
* **Known Issues:** None  

### All Plots
* This dataset includes y4_hhid, plot_id, garden_id, season, and crop_code as unique identifiers and contains location identifiers (i.e. rural, region, district, ta, ea_id, etc.) and other variables that indicate harvest quantities, hectares planted and harvested, corresponding calories by amount of crop grown, and number of months a crop was grown. This data set generates plot production statistics, including kilograms harvested, sales prices, imputed values, and cropping style.
* **Output:** `MWI_IHS_IHPS_W4_all_plots.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`   
* **Known Issues:** Relies on conversion factor which is in progress 

### TLU (Tropical Livestock Units)
* This dataset includes y4_hhid as a unique identifiers and contains other variables that quantify livestock counts at two time intervals (1 year ago and today) by various livestock types including poultry, chicken specfically, cattle, cows specfically, etc.  
* **Output:** `MWI_IHS_IHPS_W4_TLU_Coefficients.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete` 
* **Known Issues:** Survey question about how many animals owned by household at start of the season are not available. Livestock holidings are valued using observed sales prices.

### Gross Crop Revenue
* This dataset includes hhid as a unique identifier and summarizes crop production value, revenue, and losses for each household and/or household/crop type.  
* **Output:** `MWI_IHS_IHPS_W4_hh_crop_prices.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`   
* **Known Issues:** Relies on conversion unit conversion factor which is in progress  

### Crop Expenses
* This dataset summarizes crop expenses by input type for households in the dataset where most case_ids contain multiple observations of crop expenses such as labor, seed, plot rents, fertilizer, pesticides, herbicides, animal traction rentals, and mechanized tool rentals.  
* **Output:** `MWI_IHS_IHPS_W4_plot_labor_long.dta`, `MWI_IHS_IHPS_W4_plot_labor_days.dta`, `MWI_IHS_IHPS_W4_plot_labor.dta`, `MWI_IHS_IHPS_W4_hh_cost_labor.dta`, `MWI_IHS_IHPS_W4_asset_rental_costs.dta`, `MWI_IHS_IHPS_W4_plot_cost_inputs_long.dta`, `MWI_IHS_IHPS_W4_plot_cost_inputs.dta`, `MWI_IHS_IHPS_W4_input_quantities.dta`, `MWI_IHS_IHPS_W4_hh_cost_inputs_long.dta`, `MWI_IHS_IHPS_W4_hh_cost_inputs_long_complete.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`   
* **Known Issues:** Relies on conversion unit conversion factor which is in progress. Some rainy season data is missing for Land/Plot Rent. The Malawi W4 instrument did not ask survey respondents to report number of laborers per day by laborer type. As such, we cannot say with certainty whether survey respondents reported wages paid as [per SINGLE hired laborer by laborer type (male, female, child) per day] or [per ALL hired laborers by laborer type (male, female, child) per day]. Looking at the collapses and scatterplots, it would seem that survey respondents had mixed interpretations of the question, making the value of hired labor more difficult to interpret. As such, we cannot impute the value of hired labor for observations where this is missing, hence the geographic medians section is commented out. EPAR cannot construct the value of family labor or nonhired (AKA exchange) labor MWI Waves 1, 2, 3, and 4 given issues with how the value of hired labor is constructed (e.g. we do not know how many laborers are hired and if wages are reported as aggregate or singular). Therefore, we cannot use a median value of hired labor to impute the value of family or nonhired (AKA exchange) labor. Labor expense estimates are severely understated for several reasons: 1. the survey instrument did not ask for number of hired labors. Therefore, the constructed value of hired labor for some households could represent all hired labor costs or per laborer hired labor costs. 2. We typically use the value of hired labor to imput the value of family and nonhired (exchange) labor. However, due to issues with how hired labor is contructed, we cannot use these values to impute the value of family or nonhired (exchange) labor.
 

### Monocropped Plots
* This dataset uses y4_hhid, plot_id and garden_id as unique identifiers. This dataset examines plot variables and expenses, along with some additional plot attributes as recorded in the plot roster, for only plots with a single reported crop and for only crops specified in the priority crop globals. For this wave, we also estimate the total nutrition application from fertilizers.  
* **Output:** `MWI_IHS_IHPS_W4_inputs_`cn'.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`   
* **Known Issues:** Relies on Plot Decision Makers which is being updated, there may be updates in coming weeks.  

### Livestock Income
* This dataset includes y4_hhid as a unique identifier and contains variables summarizing livestock revenues and costs.  
* **Output:** `MWI_IHS_IHPS_W4_lrum_expenses.dta`, `MWI_IHS_IHPS_W4_livestock_expenses_animal.dta`, `MWI_IHS_IHPS_W4_livestock_products_milk.dta`, `MWI_IHS_IHPS_W4_livestock_products_other.dta`, `MWI_IHS_IHPS_W4_livestock_products.dta`, `MWI_IHS_IHPS_W4_livestock_products_prices_ea.dta`, `MWI_IHS_IHPS_W4_livestock_products_prices_ta.dta`, `MWI_IHS_IHPS_W4_livestock_products_prices_district.dta`, `MWI_IHS_IHPS_W4_livestock_products_prices_region.dta`, `MWI_IHS_IHPS_W4_livestock_products_prices_country.dta`, `MWI_IHS_IHPS_W4_hh_livestock_products.dta`, `MWI_IHS_IHPS_W4_manure.dta`, `MWI_IHS_IHPS_W4_hh_livestock_sales.dta`, `MWI_IHS_IHPS_W4_livestock_prices_ea.dta`, `MWI_IHS_IHPS_W4_livestock_prices_ta.dta`, `MWI_IHS_IHPS_W4_livestock_prices_district.dta`, `MWI_IHS_IHPS_W4_livestock_prices_region.dta`, `MWI_IHS_IHPS_W4_livestock_prices_country.dta`, `MWI_IHS_IHPS_W4_livestock_sales.dta`, `MWI_IHS_IHPS_W4_herd_characteristics.dta`, `MWI_IHS_IHPS_W4_TLU.dta`, `MWI_IHS_IHPS_W4_livestock_income.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`   
* **Known Issues:** Data on slaughtered livestock or ward information not available for W4. 

### Fish Income
* This dataset includes y4_hhid as a unique identifier and contains variables summarizing value of fish harvest and income from fish sales.    
* **Output:** `MWI_IHS_IHPS_W4_weeks_fishing.dta`, `MWI_IHS_IHPS_W4_fishing_expenses_1.dta`, `MWI_IHS_IHPS_W4_fishing_expenses_2.dta`,   `MWI_IHS_IHPS_W4_fish_prices.dta`, `MWI_IHS_IHPS_W4_fish_income.dta`, `MWI_IHS_IHPS_W4_weeks_fish_trading.dta`, `MWI_IHS_IHPS_W4_fish_trading_revenues.dta`, `MWI_IHS_IHPS_W4_fish_trading_other_costs.dta`, `MWI_IHS_IHPS_W4_fish_trading_income.dta` 
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete` 
* **Known Issues:** Fish price_per_unit is already averge price per unit, no additional calculations are required.  

### Self-Employment Income  
* This data set includes y4_hhid as a unique identifier and value of income from owned businesses and postharvest crop processing.
* **Output:** `MWI_IHS_IHPS_W4_self_employment_income.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete` 
* **Known Issues:** None  

### Wage Income
* This data set includes y4_hhid as a unique identifier and value of income from non agricultural and nonagricultural wages.
* **Output:** `MWI_IHS_IHPS_W4_wage_income.dta`, `MWI_IHS_IHPS_W4_agwage_income.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`  
* **Known Issues:** None
  
### Other Income
* This dataset includes y4_hhid as a unique identifier and estimated income from other sources including value of assistance, rental, pension, investments, and remittances. Broken down into Land Rental Income and Other income.  
* **Output:** `MWI_IHS_IHPS_W4_other_income.dta`, `MWI_IHS_IHPS_W4_land_rental_income.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete` 
* **Known Issues:** Land rental income: MWI W4 has land rents at the GARDEN level. Questionnaire shows AG MOD B2 Q19 asking " how much did you ALREADY receive from renting out this garden in the rainy season", but q19 is omitted from the raw data. We do have Q B217: "How much did you receive from renting out this garden in the rainy season." Cross dataset got q17 whereas panel got q19; for MSAI request, refer only to cross dataset (prefer q17); for general LSMS purposes, need to incorporate the panel data. In kind gift data is not available for MWI W4.  

### Off Farm Hours
* This dataset includes y4_hhid as a unique identifier, estimated hours spent on non-agricultural activities per week, and number of household members working hours off the farm.  
* **Output:** `MWI_IHS_IHPS_W4_off_farm_hours.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete` 
* **Known Issues:** None  

### Farm Size/Land Size
* This dataset includes y4_hhid as a unique identifier and estimated total land size (in hectares) including those rented in and out.
* **Output:** `MWI_IHS_IHPS_W4_crops_grown.dta`, `MWI_IHS_IHPS_W4_ag_mod_k_13_temp.dta`, `MWI_IHS_IHPS_W4_parcels_cultivated.dta`, `MWI_IHS_IHPS_W4_land_size.dta`, `MWI_IHS_IHPS_W4_parcels_agland.dta`, `MWI_IHS_IHPS_W4_parcels_held.dta`, `MWI_IHS_IHPS_W4_land_size_all.dta`, `MWI_IHS_IHPS_W4_land_size_total.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete` 
* **Known Issues:** W4 is missing dry raw data needed for this dataset.  

### Farm Labor
* This dataset includes y4_hhid as a unique identifier, number of labor days for hired laborers, number of labor days for family laborers, and number of labor days total.  
* **Output:** `MWI_IHS_IHPS_W4_plot_farmlabor_rainyseason.dta`, `MWI_IHS_IHPS_W4_plot_farmlabor_dryseason.dta`, `MWI_IHS_IHPS_W4_family_hired_labor.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete` 
* **Known Issues:** None  

### Vaccine Usage
* This dataset includes y4_hhid as a unique identifier and individual-level livestock vaccine use rates.  
* **Output:** `MWI_IHS_IHPS_W4_farmer_vaccine.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`   
* **Known Issues:** Updates pending after plot decision maker update.  

### Animal Health - Diseases
* This dataset includes y4_hhid as a unique identifier and rates of disease incidence for foot and mouth, lumpy skin, black quarter, brucelosis.  
* **Output:** `MWI_IHS_IHPS_W4_livestock_diseases.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`   
* **Known Issues:** Brucelosis and small pox data is missing. 

### Livestock Water, Feeding, and Housing
* Cannot replicate for MWI.  
* **Output:** Excluded  
* **Coding Status:** Excluded  
* **Known Issues:** Data not available for W4.  

### Plot Managers
* This dataset utilizes y4_hhid and indiv as unique identifiers. The dataset combines the use of improved seed and plot decision makers at the manager level.  
* **Output:** `MWI_IHS_IHPS_W4_farmer_improved_hybrid_seed_use.dta`, `MWI_IHS_IHPS_W4_input_use.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete` 
* **Known Issues:** Rainy and dry other inputs are not reported at the plot level, which would be the base of input_quantities. Unable to collapse variables to match other datasets.  

### Reached by Ag Extension
* This dataset unitizes y4_hhid as unique identifiers. The dataset examines the number and purpose of agricultural extension contacts received by the household.  
* **Output:** `MWI_IHS_IHPS_W4_any_ext.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete` 
* **Known Issues:** None  

### Mobile Ownership 
* This dataset uses y4_hhid as a unique identifier. The dataset tracks if households own a mobile phone allowing for the analysis of mobile phone prevalence among households. Missing values for mobile ownership are recoded to zero.  
* **Output:** `MWI_IHS_IHPS_W4_mobile_own.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`   
* **Known Issues:** None  

### Use of Formal Financial Services
* This dataset uses y4_hhid as unique identifiers. The dataset calculates household-level rates of bank services, lending and credit, digitial banking, insurance, and savings accounts.
* **Output:** `MWI_IHS_IHPS_W4_fin_serv.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`   
* **Known Issues:** No digital or insurance in Malawi, unable to compute those variables. W4 does not have questions about credit or MM.

### Milk Productivity
* This dataset uses y4_hhid as unique identifiers. The datset measures of liters of milk produced.  
* **Output:** `MWI_IHS_IHPS_W4_milk_animals.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete` 
* **Known Issues:** Only cow milk in MWI, large ruminants are not included.  

### Egg Productivity
* This dataset includes y4_hhid as a unique identifier, a variable for the number of poultry, and measures for eggs produced per week, month, and per year.  
* **Output:** `MWI_IHS_IHPS_W4_eggs_animals.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`  
* **Known Issues:** Cannot convert ox-cart and liter units for eggs. Currently converting observations in kgs to pieces for eggs.   

### Crop Production Costs Per Hectare
* This dataset uses y4_hhid and plot_id as unique identifiers to sum the total cost of crop production per hectare on the plot level. 
* **Output:** `MWI_IHS_IHPS_W4_cropcosts.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`  
* **Known Issues:** None  

### Rate of Fertilizer Application
* This dataset calculates rates of fertilizer applied by male/female/mix gendered plots.  
* **Output:** `MWI_IHS_IHPS_W4_fertilizer_application.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete` 
* **Known Issues:** None  

### Use of Inorganic Fertilizer
* This dataset tracks the the use of inorganic fertilizer among households.  
* **Output:** `MWI_IHS_IHPS_W4_farmer_fert_use.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete` 
* **Known Issues:** None  

### Use of Improved Seed
* This dataset uses y4_hhid and indiv as unique identifiers. The dataset examines if individuals use any improved seed on any plot.
* **Output:** `MWI_IHS_IHPS_W4_improvedseed_use.dta`
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete` 
* **Known Issues:** None

### Women's Diet Quality
* Cannot compute. 
* **Output:** Excluded 
* **Coding Status:** Excluded 
* **Known Issues:** Information not available 

### Household's Diet Diversity Score
* This dataset includes y4_hhid as a unique identifier, a count of food groups (out of 12) the surveyed individual consumed last week, and whether or not a houseshold consumed at least 6 of the 12 food groups, of 8 of the 12 food groups.  
* **Output:** `MWI_IHS_IHPS_W4_household_diet.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`   
* **Known Issues:** W4 does not report individual consumption but instead household level consumption of various food items. Thus, only the proportion of household eating nutritious food can be estimated.  

### Women's Control Over Income 
* This dataset includes y4_hhid and individual id (indiv) as a unique identifier and a series of binary variables describing individual gender and ownership over different income streams (e.g. salary income).
* **Output:** `MWI_IHS_IHPS_W4_control_income.dta`
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete` 
* **Known Issues:** Missing data on fish production income, control over business income, control of harvest from permanent crops, and dry season controls earning from sale.
  
### Women's Participation in Ag Decision Making 
* This dataset includes y4_hhid and individual id (indiv) as a unique identifier and a series of binary variables describing individual gender and role in decisions related to agriculture (e.g. crops, livestock).
* **Output:** `MWI_IHS_IHPS_W4_make_ag_decision.dta`
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete` 
* **Known Issues:** Missing data on plot ownership and negotiating. In most cases, MWI LSMS 4 lists the first TWO decision makers. Indicator may be biased downward if some women would participate in decisions but are not listed among the first two.
  
### Women's Ownership of Assets
* This dataset includes y4_hhid and individual id (indiv) as a unique identifier and a series of binary variables describing individual gender and ownership of assets.
* **Output:** `MWI_IHS_IHPS_W4_ownasset.dta`
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`  
* **Known Issues:** Missing data on who in HH can decide whether to sell the garden. In most cases, MWI LSMS 4 lists the first TWO decision makers. Indicator may be biased downward if some women would participate in decisions but are not listed among the first two. 

### Agricultural Wages
* This uses y4_hhid as unique identifiers. This dataset computes wages paid in dry and rainy season.
* * **Output:** `MWI_IHS_IHPS_W4_wages_dryseason.dta`
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete` 
* **Known Issues:** EPAR is unable to construct wages per person, due to missing data. We are able to construct wages per person per day. 

### Crop Yields
* This dataset uses y4_hhid as unique identifiers. The dataset converts plot variables file to wider format for backwards compatibility - yields are now directly constructable in "all_plots.dta" 
* **Output:** `MWI_IHS_IHPS_W4_trees.dta`, `MWI_IHS_IHPS_W4_crop_harvest_area_yield.dta`, `MWI_IHS_IHPS_W4_yield_hh_crop_level.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`   
* **Known Issues:** None  

### Shannon Diversity Index
* This dataset uses y4_hhid as unique identifiers. The dataset calculates the shannon diversity index by plots per household, number of crops by gender.  
* **Output:** `MWI_IHS_IHPS_W4_shannon_diversity_index.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete` 
* **Known Issues:** None  

### Consumption
* This dataset includes y4_hhid as a unique identifier and a series of variables describing household consumption (e.g. total, per capita, per adult equivalent, etc.).  
* **Output:** `MWI_IHS_IHPS_W4_consumption.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete` 
* **Known Issues:** None  

### Household Food Provision
* This dataset includes y4_hhid as a unique identifier and a numeric variable describing months that the household experienced food insecurity.  
* **Output:** `MWI_IHS_IHPS_W4_food_insecurity.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`   
* **Known Issues:** None  

### Household Assets
* This dataset includes case_id and HHID as a unique identifier and a single numeric variable descrining the gross value of household assets.  
* **Output:** `MWI_IHS_IHPS_W4_hh_assets.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`   
* **Known Issues:** None  

### Household Variables
* This dataset includes y4_hhid as a unique identifier and compiles all relevant variables from previous intermediate files on the level of an individual household.
* **Output:** `MWI_IHS_IHPS_W4_household_variables.dta`
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete` 
* **Known Issues:** None

### Individual Level Variables  
*  This dataset includes y4_hhid and individual id (indiv) as a unique identifier and compiles all relevant variables that are available on an individual level from previous intermediate files.
* **Output:** `MWI_IHS_IHPS_W4_individual_variables.dta`  
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete` 
* **Known Issues:** None  

### Plot Level Variables  
*  This dataset includes y4_hhid, plot_id, and garden_id as a unique identifier and compiles all relevant variables that are available on a plot level from previous intermediate files.
* **Output:**  `MWI_IHS_IHPS_W4_field_plot_variables.dta`
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`   
* **Known Issues:** None  

### Summary Statistics  
*  This section produces a file in two formats, .dta and .xlsx, that provide descriptive statistics (mean, standard deviation, quartiles, min, max) for each variable produced in the Household Variables, Individual Level Variables, and Plot Level Variables sections.
* **Output:**  `MWI_IHS_IHPS_W4_summary_stats_with_labels.dta`, `MWI_IHS_IHPS_W4_summary_stats.xlsx`
* **Coding Status:** ![Complete](https://placehold.co/15x15/c5f015/c5f015.png) `Complete`   
* **Known Issues:** None  


