# Malawi_IHS-IHPS Wave 4 (2019-2020)
CODING STATUS: Complete

## Prerequisites
* Download the raw data from MWI Fifth Integrated Household Survey (IHS) 2019-2020 at https://microdata.worldbank.org/index.php/catalog/3818 and the long panel survey (IHPS) at https://microdata.worldbank.org/index.php/catalog/3819. The long panel survey download contains all four LSMS-ISA waves.
* Extract the files to the "Raw DTA Files" folder in the cloned directory
* Update the paths on lines 176-177 and 180-184 with the correct paths to the raw data and output files.  The files will run without modification if the original folder structure of the repository is maintained.

## Table of Contents
### Globals
* This dataset sets global variables for use later in the script, including:
- **Population
    * MWI_IHS_IHPS_W4_pop_tot - Total population in 2019 (World Bank)
    * MWI_IHS_IHPS_W4_pop_rur - Rural population in 2019 (World Bank)
    * MWI_IHS_IHPS_W4_pop_urb - Urban population in 2019 (World Bank)
- **Exchange Rates
    * MWI_W4_exchange_rate - USD-Kwacha conversion
    * MWI_W4_gdp_ppp_dollar - GDP-based purchasing power parity conversion, World Bank Indicator PA.NUS.PPP
    * MWI_W4_cons_ppp_dollar - Private-consumption-based purchasing power parity conversion, World Bank Indicator PA.NUS.PRVT.PP
    * MWI_W4_inflation - Ratio of 2019:2021 Malawi Consumer Price Index (CPI) (World Bank), used for calculating poverty thresholds
- **Poverty Thresholds
    * MWI_W4_poverty_under_190: The pre-2023 $1.90 2011 PPP poverty line used prior to 2023 by the World Bank, converted to local currency
    * MWI_W4_poverty_under_nbl: The poverty threshold as determined from the National Statistics Bureau from 2015-2016 adjusted to 2018-2019, via CPI
    * MWI_W4_poverty_under_215: The updated $2.15 2017 PPP poverty line used prior to 2025 by the World Bank, converted to local currency
    * MWI_W4_poverty_under_300 - The updated $3.00 2021 PPP poverty line currently used by the World Bank, converted to 2019 MWK
- **Thresholds for Winsorization:** the smallest (below the 1 percentile) and largest (above the 99 percentile) are replaced with the observations closest to them
- **Priority Crops:** the top 12 crops by area cultivated (determined by ALL PLOTS later in the code)
 
### Appending Malawi IHPS and IHS Data 
- **Description:** IHS3 is an expansion of IHS2. A sub-sample of IHS3 EAs were surveyed twice reduce recall associated with different aspects of agricultural data collection (ii) track and resurvey these households in 2013 as part of the Integrated Household Panel Survey 2013 (IHPS; microdata.worldbank.org/index.php/catalog/2248). Therefore, we append the panel and cross-datasetal data to ensure we're working with a complete data from both panel and crosdatasetal surveys.  
* All the modules starting from Plot Areas use appended data. To run the append code for the first time:  
	* Commented out macro which creates "created_data" in the globals directory  
	* Created a new appended paths in the code  
 	* After running the append code, changed created_data file path back to raw/created_data in the globals directory 
- **Output:** All raw data has generated new appended data files. 
- **Known Issues:** None
  
### Household IDs
- **Description:** This dataset includes hhid as a unique identifier, along with its location identifiers (i.e. rural, region, district, ta, ea_id, etc.). This dataset simplifies the household roster and drops non-surveyed households. A new variable "rural" is generated. 
- **Output:** `MWI_IHS_IHPS_W4_hhids.dta`  
- **Known Issues:** "hhid" is recasted from strL to str# before saving the created data to ensure smooth merges in the later code. 

### Weights
- **Description:** Survey weight adjustment. The combined first wave of the LSMS-ISA and second wave of the IHS (Wave 1) had a nationally representative panel subsample drawn from it that was surveyed in wave 2 without a cross-section. In wave 3, the panel and cross-sectional datasets were split, and the weights were recalculated so that both samples were nationally representative, although total population estimates produced from both sets of weights differ. To align them, we first rescale the weights for each sample to the national rural and urban population estimates. Weights are then combined by adjusting them by the proportional sizes of the sample. We therefore report **five** weight variables:
  - weight: The rescaled and combined panel and sample weight, used by default.
  - weight_sample: The original cross-sectional sample weight
  - weight_panel: The original panel sample weight
  - xs_weight: The rescaled cross-sectional sample weight
  - p_weight: The rescaled panel sample weight
  Calculations can be modified by replacing the "weight" variable with the weight of your preference. Using the cross-sectional or panel sample-only weights will produce estimates for the combined sample, but summary statistics will be computed only for the selected panel or cross-sectional sample. Combining the panel and sample weights without rescaling is not recommended because the panel sample will be overweighted and national totals will be wrong.
  - **Output:** `MWI_IHS_IHPS_W4_weights.dta`  
  
- **Known Issues:** "hhid" is recasted from strL to str# before saving the created data to ensure ensure consistent format and smooth merges in the later code. 

### Individual IDs
- **Description:** This dataset includes indiv and hhid as unique identifiers and contains variables that indicate an individual's age, whether or not they are female, and whether or not they are head of household.
- **Output:** `MWI_IHS_IHPS_W4_person_ids.dta`  

- **Known Issues:** "hhid" is recasted from strL to str# before saving the created data to ensure consistent format and smooth merges in the later code.  

### Plot Areas  
- **Description:** This dataset includes hhid, plot_id, and season as unique identifiers and contains variables that indicate estimated plot area (in hectares and acres), measure plot area (in hectares and acres), whether or not the plot area was measured with a GPS, and field size.
- **Output:** `MWI_IHS_IHPS_W4_plot_areas.dta`  
  
- **Known Issues:** "hhid" is recasted from strL to str# before saving the created data to ensure consistent format. If gps_area is set to something other than 0, non-measured plots are dropped; otherwise, area is determined first from GPS measurements and backfilled from respondent estimates when GPS measurements are unavailable. 

### GPS Coordinates
- **Description:** This dataset includes hhid as a unique identifier and contains variables for household latitude and longitude as measured by a GPS.
- **Output:** `MWI_IHS_IHPS_W4_hh_coords.dta`  
  
- **Known Issues:** "hhid" is recasted from strL to str# before merging to ensure consistent "hhid" format after merge. 

### Plot Decision Makers
- **Description:** This dataset includes hhid and plot_id as unique identifiers, along with a variable, dm_gender, representing plot decision maker gender (male, female, or mixed).
- **Output:** `MWI_IHS_IHPS_W4_plot_decision_makers.dta`  
 
- **Known Issues:** None  

### Formalized Land Rights
- **Description:** This dataset determines whether a plot holder has a formal title and records formal landholder gender.  
- **Output:** Excluded  
- **Coding Status:** Excluded  
- **Known Issues:** Formalized Land Rights question is present in the questionnaire but the data is missing. Unable to complete this dataset due to the lack of data.  

### Crop Unit Conversion Factors
- **Description:** This dataset generates a nonstandard unit conversion factors table from reported conversions in the agricultural module, filling unknown entries with values from the literature where necessary and noted.  
- **Output:** `MWI_IHS_IHPS_W4_cf.dta`  
- **Known Issues:** None  

### All Plots
- **Description:** This dataset includes hhid, plot_id, garden_id, season, and crop_code as unique identifiers and contains location identifiers (i.e. rural, region, district, ta, ea_id, etc.) and other variables that indicate harvest quantities, hectares planted and harvested, corresponding calories by amount of crop grown, and number of months a crop was grown. This data set generates plot production statistics, including kilograms harvested, sales prices, imputed values, and cropping style.
- **Output:** `MWI_IHS_IHPS_W4_all_plots.dta`  
- **Known Issues:** None

### TLU (Tropical Livestock Units)
- **Description:** This dataset includes hhid as a unique identifiers and contains other variables that quantify livestock counts at two time intervals (1 year ago and today) by various livestock types including poultry, chicken specfically, cattle, cows specfically, etc.  
- **Output:** `MWI_IHS_IHPS_W4_TLU_Coefficients.dta`  
- **Known Issues:** Survey question about how many animals owned by household at start of the season are not available. Livestock holidings are valued using observed sales prices.

### Gross Crop Revenue
- **Description:** This dataset includes hhid as a unique identifier and summarizes crop production value, revenue, and losses for each household and/or household/crop type.  
- **Output:** `MWI_IHS_IHPS_W4_hh_crop_prices.dta`  
- **Known Issues:** 

### Crop Expenses
- **Description:** This dataset summarizes crop expenses by input type for households in the dataset where most case_ids contain multiple observations of crop expenses such as labor, seed, plot rents, fertilizer, pesticides, herbicides, animal traction rentals, and mechanized tool rentals.  
- **Output:** `MWI_IHS_IHPS_W4_plot_labor_long.dta`, `MWI_IHS_IHPS_W4_plot_labor_days.dta`, `MWI_IHS_IHPS_W4_plot_labor.dta`, `MWI_IHS_IHPS_W4_hh_cost_labor.dta`, `MWI_IHS_IHPS_W4_asset_rental_costs.dta`, `MWI_IHS_IHPS_W4_plot_cost_inputs_long.dta`, `MWI_IHS_IHPS_W4_plot_cost_inputs.dta`, `MWI_IHS_IHPS_W4_input_quantities.dta`, `MWI_IHS_IHPS_W4_hh_cost_inputs_long.dta`, `MWI_IHS_IHPS_W4_hh_cost_inputs_long_complete.dta`  
- **Known Issues:** Some rainy season data are missing for Land/Plot Rent. The Malawi W4 instrument did not ask survey respondents to report number of laborers per day by laborer type. As such, we cannot say with certainty whether survey respondents reported wages paid as [per SINGLE hired laborer by laborer type (male, female, child) per day] or [per ALL hired laborers by laborer type (male, female, child) per day]. Looking at the collapses and scatterplots, it would seem that survey respondents had mixed interpretations of the question, making the value of hired labor more difficult to interpret. As such, we cannot impute the value of hired labor for observations where this is missing, hence the geographic medians section is commented out. EPAR cannot construct the value of family labor or nonhired (AKA exchange) labor MWI Waves 1, 2, 3, and 4 given issues with how the value of hired labor is constructed (e.g. we do not know how many laborers are hired and if wages are reported as aggregate or singular). Therefore, we cannot use a median value of hired labor to impute the value of family or nonhired (AKA exchange) labor. Labor expense estimates are severely understated for several reasons: 1. the survey instrument did not ask for number of hired labors. Therefore, the constructed value of hired labor for some households could represent all hired labor costs or per laborer hired labor costs. 2. We typically use the value of hired labor to imput the value of family and nonhired (exchange) labor. However, due to issues with how hired labor is contructed, we cannot use these values to impute the value of family or nonhired (exchange) labor.
 
### Monocropped Plots
- **Description:** This dataset uses hhid, plot_id and garden_id as unique identifiers. This dataset examines plot variables and expenses, along with some additional plot attributes as recorded in the plot roster, for only plots with a single reported crop and for only crops specified in the priority crop globals. For this wave, we also estimate the total nutrition application from fertilizers.  
- **Output:** `MWI_IHS_IHPS_W4_inputs_`cn'.dta`  
   
- **Known Issues:** Relies on Plot Decision Makers which is being updated, there may be updates in coming weeks.  

### Livestock Income
- **Description:** This dataset includes hhid as a unique identifier and contains variables summarizing livestock revenues and costs.  
- **Output:** `MWI_IHS_IHPS_W4_lrum_expenses.dta`, `MWI_IHS_IHPS_W4_livestock_expenses_animal.dta`, `MWI_IHS_IHPS_W4_livestock_products_milk.dta`, `MWI_IHS_IHPS_W4_livestock_products_other.dta`, `MWI_IHS_IHPS_W4_livestock_products.dta`, `MWI_IHS_IHPS_W4_livestock_products_prices_ea.dta`, `MWI_IHS_IHPS_W4_livestock_products_prices_ta.dta`, `MWI_IHS_IHPS_W4_livestock_products_prices_district.dta`, `MWI_IHS_IHPS_W4_livestock_products_prices_region.dta`, `MWI_IHS_IHPS_W4_livestock_products_prices_country.dta`, `MWI_IHS_IHPS_W4_hh_livestock_products.dta`, `MWI_IHS_IHPS_W4_manure.dta`, `MWI_IHS_IHPS_W4_hh_livestock_sales.dta`, `MWI_IHS_IHPS_W4_livestock_prices_ea.dta`, `MWI_IHS_IHPS_W4_livestock_prices_ta.dta`, `MWI_IHS_IHPS_W4_livestock_prices_district.dta`, `MWI_IHS_IHPS_W4_livestock_prices_region.dta`, `MWI_IHS_IHPS_W4_livestock_prices_country.dta`, `MWI_IHS_IHPS_W4_livestock_sales.dta`, `MWI_IHS_IHPS_W4_herd_characteristics.dta`, `MWI_IHS_IHPS_W4_TLU.dta`, `MWI_IHS_IHPS_W4_livestock_income.dta`  
   
- **Known Issues:** Data on slaughtered livestock or ward information not available for W4. 

### Fish Income
- **Description:** This dataset includes hhid as a unique identifier and contains variables summarizing value of fish harvest and income from fish sales.    
- **Output:** `MWI_IHS_IHPS_W4_weeks_fishing.dta`, `MWI_IHS_IHPS_W4_fishing_expenses_1.dta`, `MWI_IHS_IHPS_W4_fishing_expenses_2.dta`,   `MWI_IHS_IHPS_W4_fish_prices.dta`, `MWI_IHS_IHPS_W4_fish_income.dta`, `MWI_IHS_IHPS_W4_weeks_fish_trading.dta`, `MWI_IHS_IHPS_W4_fish_trading_revenues.dta`, `MWI_IHS_IHPS_W4_fish_trading_other_costs.dta`, `MWI_IHS_IHPS_W4_fish_trading_income.dta` 
- **Known Issues:** Fish price_per_unit is already average price per unit, no additional calculations are required.  

### Self-Employment Income  
- **Description:** This data set includes hhid as a unique identifier and value of income from owned businesses and postharvest crop processing.
- **Output:** `MWI_IHS_IHPS_W4_self_employment_income.dta`  
- **Known Issues:** None  

### Wage Income
- **Description:** This dataset includes hhid as a unique identifier and value of income from non agricultural and nonagricultural wages.
- **Output:** `MWI_IHS_IHPS_W4_wage_income.dta`, `MWI_IHS_IHPS_W4_agwage_income.dta`  
- **Known Issues:** None
  
### Other Income
- **Description:** This dataset includes hhid as a unique identifier and estimated income from other sources including value of assistance, rental, pension, investments, and remittances. Broken down into Land Rental Income and Other income.  
- **Output:** `MWI_IHS_IHPS_W4_other_income.dta`, `MWI_IHS_IHPS_W4_land_rental_income.dta`  
- **Known Issues:** Land rental income: MWI W4 has land rents at the GARDEN level. Questionnaire shows AG MOD B2 Q19 asking " how much did you ALREADY receive from renting out this garden in the rainy season", but q19 is omitted from the raw data. We do have Q B217: "How much did you receive from renting out this garden in the rainy season." Cross dataset got q17 whereas panel got q19; for MSAI request, refer only to cross dataset (prefer q17); for general LSMS purposes, need to incorporate the panel data. In kind gift data is not available for MWI W4.  

### Off Farm Hours
- **Description:** This dataset includes hhid as a unique identifier, estimated hours spent on non-agricultural activities per week, and number of household members working hours off the farm.  
- **Output:** `MWI_IHS_IHPS_W4_off_farm_hours.dta`  
- **Known Issues:** None  

### Farm Size/Land Size
- **Description:** This dataset includes hhid as a unique identifier and estimated total land size (in hectares) including those rented in and out.
- **Output:** `MWI_IHS_IHPS_W4_crops_grown.dta`, `MWI_IHS_IHPS_W4_ag_mod_k_13_temp.dta`, `MWI_IHS_IHPS_W4_parcels_cultivated.dta`, `MWI_IHS_IHPS_W4_land_size.dta`, `MWI_IHS_IHPS_W4_parcels_agland.dta`, `MWI_IHS_IHPS_W4_parcels_held.dta`, `MWI_IHS_IHPS_W4_land_size_all.dta`, `MWI_IHS_IHPS_W4_land_size_total.dta`  
- **Known Issues:** W4 is missing dry raw data needed for this dataset.  

### Farm Labor
- **Description:** This dataset includes hhid as a unique identifier, number of labor days for hired laborers, number of labor days for family laborers, and number of labor days total.  
- **Output:** `MWI_IHS_IHPS_W4_plot_farmlabor_rainyseason.dta`, `MWI_IHS_IHPS_W4_plot_farmlabor_dryseason.dta`, `MWI_IHS_IHPS_W4_family_hired_labor.dta`  
 
- **Known Issues:** None  

### Vaccine Usage
- **Description:** This dataset includes hhid as a unique identifier and individual-level livestock vaccine use rates.  
- **Output:** `MWI_IHS_IHPS_W4_farmer_vaccine.dta`  
- **Known Issues:** None

### Animal Health - Diseases
- **Description:** This dataset includes hhid as a unique identifier and rates of disease incidence for foot and mouth, lumpy skin, black quarter, brucelosis.  
- **Output:** `MWI_IHS_IHPS_W4_livestock_diseases.dta`  
- **Known Issues:** Brucelosis and small pox data is missing. 

### Livestock Water, Feeding, and Housing
- **Description:** Cannot replicate for MWI.  
- **Output:** Excluded  
- **Coding Status:** Excluded  
- **Known Issues:** Data not available for W4.  

### Plot Managers
- **Description:** This dataset utilizes hhid and indiv as unique identifiers. The dataset combines the use of improved seed and plot decision makers at the manager level.  
- **Output:** `MWI_IHS_IHPS_W4_farmer_improved_hybrid_seed_use.dta`, `MWI_IHS_IHPS_W4_input_use.dta`  
- **Known Issues:** Rainy and dry other inputs are not reported at the plot level, which would be the base of input_quantities. Unable to collapse variables to match other datasets.  

### Reached by Ag Extension
- **Description:** This dataset unitizes hhid as unique identifiers. The dataset examines the number and purpose of agricultural extension contacts received by the household.  
- **Output:** `MWI_IHS_IHPS_W4_any_ext.dta`  
 
- **Known Issues:** None  

### Mobile Ownership 
- **Description:** This dataset uses hhid as a unique identifier. The dataset tracks if households own a mobile phone allowing for the analysis of mobile phone prevalence among households. Missing values for mobile ownership are recoded to zero.  
- **Output:** `MWI_IHS_IHPS_W4_mobile_own.dta`  
   
- **Known Issues:** None  

### Use of Formal Financial Services
- **Description:** This dataset uses hhid as unique identifiers. The dataset calculates household-level rates of bank services, lending and credit, digitial banking, insurance, and savings accounts.
- **Output:** `MWI_IHS_IHPS_W4_fin_serv.dta`  
   
- **Known Issues:** No digital or insurance in Malawi, unable to compute those variables. W4 does not have questions about credit or MM.

### Milk Productivity
- **Description:** This dataset uses hhid as unique identifiers. The datset measures of liters of milk produced.  
- **Output:** `MWI_IHS_IHPS_W4_milk_animals.dta`  
 
- **Known Issues:** Only cow milk in MWI, large ruminants are not included.  

### Egg Productivity
- **Description:** This dataset includes hhid as a unique identifier, a variable for the number of poultry, and measures for eggs produced per week, month, and per year.  
- **Output:** `MWI_IHS_IHPS_W4_eggs_animals.dta`  
  
- **Known Issues:** Cannot convert ox-cart and liter units for eggs. Currently converting observations in kgs to pieces for eggs.   

### Crop Production Costs Per Hectare
- **Description:** This dataset uses hhid and plot_id as unique identifiers to sum the total cost of crop production per hectare on the plot level. 
- **Output:** `MWI_IHS_IHPS_W4_cropcosts.dta`  
  
- **Known Issues:** None  

### Rate of Fertilizer Application
- **Description:** This dataset calculates rates of fertilizer applied by male/female/mix gendered plots.  
- **Output:** `MWI_IHS_IHPS_W4_fertilizer_application.dta`  
 
- **Known Issues:** None  

### Use of Inorganic Fertilizer
- **Description:** This dataset tracks the the use of inorganic fertilizer among households.  
- **Output:** `MWI_IHS_IHPS_W4_farmer_fert_use.dta`  
 
- **Known Issues:** None  

### Use of Improved Seed
- **Description:** This dataset uses hhid and indiv as unique identifiers. The dataset examines if individuals use any improved seed on any plot.
- **Output:** `MWI_IHS_IHPS_W4_improvedseed_use.dta`
 
- **Known Issues:** None

### Women's Diet Quality
- **Description:** Cannot compute. 
- **Output:** Excluded 
- **Coding Status:** Excluded 
- **Known Issues:** Information not available 

### Household's Diet Diversity Score
- **Description:** This dataset includes hhid as a unique identifier, a count of food groups (out of 12) the surveyed individual consumed last week, and whether or not a houseshold consumed at least 6 of the 12 food groups, of 8 of the 12 food groups. The Food Consumption Score (FCS) was calculated by summing the frequency of consumption of different food groups over the past 7 days, each weighted according to its nutritional value. The Reduced Coping Strategies Index (rCSI) was calculated by summing the frequency of five food-related coping behaviors used in the past 7 days, each multiplied by a standardized severity weight.
- **Output:** `MWI_IHS_IHPS_W4_household_diet.dta`  
   
- **Known Issues:** W4 does not report individual consumption but instead household level consumption of various food items. Thus, only the proportion of household eating nutritious food can be estimated.  

### Women's Control Over Income 
- **Description:** This dataset includes hhid and individual id (indiv) as a unique identifier and a series of binary variables describing individual gender and ownership over different income streams (e.g. salary income).
- **Output:** `MWI_IHS_IHPS_W4_control_income.dta`
 
- **Known Issues:** Missing data on fish production income, control over business income, control of harvest from permanent crops, and dry season controls earning from sale.
  
### Women's Participation in Ag Decision Making 
- **Description:** This dataset includes hhid and individual id (indiv) as a unique identifier and a series of binary variables describing individual gender and role in decisions related to agriculture (e.g. crops, livestock).
- **Output:** `MWI_IHS_IHPS_W4_make_ag_decision.dta`
 
- **Known Issues:** Missing data on plot ownership and negotiating. In most cases, MWI LSMS 4 lists the first TWO decision makers. Indicator may be biased downward if some women would participate in decisions but are not listed among the first two.
  
### Women's Ownership of Assets
- **Description:** This dataset includes hhid and individual id (indiv) as a unique identifier and a series of binary variables describing individual gender and ownership of assets.
- **Output:** `MWI_IHS_IHPS_W4_ownasset.dta`
  
- **Known Issues:** Missing data on who in HH can decide whether to sell the garden. In most cases, MWI LSMS 4 lists the first TWO decision makers. Indicator may be biased downward if some women would participate in decisions but are not listed among the first two. 

### Agricultural Wages
- **Description:** This uses hhid as unique identifiers. This dataset computes wages paid in dry and rainy season.
- **Output:** `MWI_IHS_IHPS_W4_wages_dryseason.dta`
 
- **Known Issues:** EPAR is unable to construct wages per person, due to missing data. We are able to construct wages per person per day. 

### Crop Yields
- **Description:** This dataset uses hhid as unique identifiers. The dataset converts plot variables file to wider format for backwards compatibility - yields are now directly constructable in "all_plots.dta" 
- **Output:** `MWI_IHS_IHPS_W4_trees.dta`, `MWI_IHS_IHPS_W4_crop_harvest_area_yield.dta`, `MWI_IHS_IHPS_W4_yield_hh_crop_level.dta`  
   
- **Known Issues:** None  

### Shannon Diversity Index
- **Description:** This dataset uses hhid as unique identifiers. The dataset calculates the Shannon diversity index by plots per household, number of crops by gender.  
- **Output:** `MWI_IHS_IHPS_W4_shannon_diversity_index.dta`  
 
- **Known Issues:** None  

### Consumption
- **Description:** This dataset includes hhid as a unique identifier and a series of variables describing household consumption (e.g. total, per capita, per adult equivalent, etc.).  
- **Output:** `MWI_IHS_IHPS_W4_consumption.dta`  
 
- **Known Issues:** Aggregate consumption estimates are typically reported by the data preparers in the raw data. These values are spatiotemporally deflated to account for subnational price differences and variations in survey timing. Currently, aggregate consumption is calculated for the cross-section but not the panel, so it is not possible to estimate poverty rates on a panel basis without constructing them. We approximate the World Bank's methodology to incorporate the full sample, but this is still a work in progress, and the computed estimates do not fully align with the reported estimates within the cross section. Due to these issues, we use the cross-sectional weights when calculating the poverty estimates rather than the combined sample weights. At the household level, because food consumption varies substantially seasonally and because the food consumption module was only administered once, survey timing has a significant impact on the annualized estimate of household consumption and consequently poverty status.
 

### Household Food Provision
- **Description:** This dataset includes hhid as a unique identifier and a numeric variable describing months that the household experienced food insecurity.  
- **Output:** `MWI_IHS_IHPS_W4_food_insecurity.dta`  
   
- **Known Issues:** Data entry for the panel sample is not consistent with the cross-sectional sample and so the estimates from the panel sample are excluded.   

### Household Assets
- **Description:** This dataset includes case_id and HHID as a unique identifier and a single numeric variable descrining the gross value of household assets.  
- **Output:** `MWI_IHS_IHPS_W4_hh_assets.dta`  
   
- **Known Issues:** None  

### Household Variables
- **Description:** This dataset includes hhid as a unique identifier and compiles all relevant variables from previous intermediate files on the level of an individual household.
- **Output:** `MWI_IHS_IHPS_W4_household_variables.dta`
 
- **Known Issues:** None

### Individual Level Variables  
- **Description:** This dataset includes hhid and individual id (indiv) as a unique identifier and compiles all relevant variables that are available on an individual level from previous intermediate files.
- **Output:** `MWI_IHS_IHPS_W4_individual_variables.dta`  
 
- **Known Issues:** None  

### Plot Level Variables  
- **Description:** This dataset includes hhid, plot_id, and garden_id as a unique identifier and compiles all relevant variables that are available on a plot level from previous intermediate files.
- **Output:**  `MWI_IHS_IHPS_W4_field_plot_variables.dta`
   
- **Known Issues:** None  

### Summary Statistics  
- **Description:** This section produces a file in two formats, .dta and .xlsx, that provide descriptive statistics (mean, standard deviation, quartiles, min, max) for each variable produced in the Household Variables, Individual Level Variables, and Plot Level Variables sections.
- **Output:**  `MWI_IHS_IHPS_W4_summary_stats_with_labels.dta`, `MWI_IHS_IHPS_W4_summary_stats.xlsx`
   
- **Known Issues:** None  


