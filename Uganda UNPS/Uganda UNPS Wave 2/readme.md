# Uganda NPS/LSMS-ISA Wave 2 (2010-2011)
CODING STATUS: Fully completed, still under active review and expansion

## Prerequisites
* Download the raw data from [https://microdata.worldbank.org/index.php/catalog/3557](https://microdata.worldbank.org/index.php/catalog/2166)
* Extract the files to the "Raw DTA Files" folder in the cloned directory
* Update the paths on lines 131 and 136-139 with the correct paths to the raw data and output files.

## Table of Contents
### Globals
* This section sets global variables for use later in the script, including:
  * Population
  * Population estimates from: https://databank.worldbank.org/source/world-development-indicators# 
    * UGA_NPS_W2_pop_tot - Total population in 2011 (World Bank)
    * UGA_NPS_W2_pop_rur - Rural population in 2011 (World Bank)
    * UGA_NPS_W2_pop_urb - Urban population in 2011 (World Bank)
  * Species
    * label defines species as large ruminants, small ruminants, pigs, equines and poultry (including rabbits) 
  * Exchange Rates
    * NPS_LSMS_ISA_W2_exchange_rate - USD-Uganda shilling conversion
    * NPS_LSMS_ISA_W2_gdp_ppp_dollar - GDP-based purchasing power parity conversion, World Bank Indicator PA.NUS.PPP
    * NPS_LSMS_ISA_W2_cons_ppp_dollar - Private-consumption-based purchasing power parity conversion, World Bank Indicator PA.NUS.PRVT.P
    * NPS_LSMS_ISA_W2_inflation - inflation for 2.15 2017 baseline  
  * Poverty Thresholds
    * NPS_LSMS_ISA_W2_poverty_nbs - The poverty threshold as determined from the National Statistics Bureau, inflated to 2019 via CPI
    * NPS_LSMS_ISA_W2_poverty_215 - The updated $2.15 2017 PPP poverty line currently used by the world bank, converted to local currency
    * NPS_LSMS_ISA_W2_poverty_190 - Calculation for World Bank's previous $1.90 (PPP) poverty threshold. This controls the indicator poverty_under_1_9; change the 1.9 to get results for a different threshold. This is based on the 2011 PPP conversion!
### Winsorization Thresholds
* We correct outliers by Winsorization - setting values above the 99th and/or below the 1st percentiles to the value of the 99th or 1st percentile. The thresholds can be adjusted here or removed by setting them to 0 and 100
### Globals of Priority Crops
* This section defines the list of crops used to report crop-specific indicators, including indicators for monocropped plots. Adjust this list to change the output.
### Household IDs
* This section simplifies the household roster and drops non-surveyed households
### Weights
* We rescale the weights to match the rural and urban populations for 2019 as reported in the World Bank Data Bank (last accessed 2023)
### Individual IDs
* Simplified household member roster
### Household Size
* Calculating the number of household members and rescaling the weights - the original weights are retained and can be used by switching all instances of weight_pop_rururb to weight
### Plot Areas
* Calculates farmer-estimated plot areas from nonstandard units and GPS-measured plot areas and converts to hectares
* If gps_area is set to something other than 0, non-measured plots are dropped; otherwise, area is determined first from GPS measurements and backfilled from respondent estimates when GPS measurements are unavailable
### Plot Decisionmakers
* Determines gender of person or people who make plot management decisions - 1: male, 2: female, or 3: mixed male and female
* No direct plot decision maker question in this wave so have to infer who the decision maker is from a different question. 
### Area Planted
* Created hectares planted across household, plot, parcel, crop and season.
### All Plots
* Generates plot production statistics, including kilograms harvested, sales prices, imputed values, and cropping style
### Gross Crop Revenue
* Total value of crops sold
* Don't have year or planting dates so can't create time variables in this wave.
### Crop Expenses
* Total expenses divided among implicit/explicit and expense type, attributed at the plot level where possible.
* No quantity for seeds so only able to calculate explicit seed prices.
### Monocropped Plots
* Plot variables and expenses, along with some additional plot attributes as recorded in the plot roster, for only plots with a single reported crop and for only crops specified in the priority crop globals
### Livestock + TLU (Tropical Livestock Units)
* Number of livestock owned the day of the survey and 1 year ago
### Crops Lost Post Harvest
* Total value of kg of crops lost post harvest 
### Livestock Income
* Values of production from reported sales of eggs, milk, and other livestock products
### Livestock Sold (Live)
* Price per live animal sold, purchased and slaughtered
### TLU (Tropical Livestock Units)
* Total number of livestock owned by type and by tropical livestock unit (TLU) coefficient
### Fish Income
* Can't generate this section in this wave
### Self Employment Income
* Estimated annual net profit from self employmnent over the past year
### Income
* Generates ag and non-ag income
### Farm Size/Land Size
Land size in hectares and cultivated parcels
### Off Farm Hours
* Total amount of hours off of the farm per household and number of household members who work off farm hours
### Farm Labor
* Converts labor as recorded in the crop expense section to a wider format to maintain backwards compatibility with the summary statistics file
* Uganda does not have a main season and a short season. For cross country compatibility this section codes the first visit as "the long season" and the second visit as "the short season" as Uganda provides little data beyond those two categories
### Head of Household
* Determines gender of household head
### Vaccine Usage
* Individual-level livestock vaccine use rates
### Animal Health - Diseases
* Can't generate this section in this wave
### Livestock Water, Feeding, and Housing
* Can't generate this section in this wave
### Use of Improved Seeds
*Use of improved and hybrid seed use on hte household and individual level. 
### Plot Managers
* Individual-level use rates of fertilizer, herbicide, pesticide, and improved seeds by plot managers
### Reached by Ag Extension
* Number and purpose of ag extension contacts received by the household
### Household Assets
* Value of household assets
### Use of Formal Financial Services
* Household-level rates of bank services, lending and credit, digitial banking, insurance, and savings accounts
### Milk Productivity
* Rates of milk production by time and number of animals owned
* Questions in wave 2 are limited for this section so can only generate average quantity (liters) of milk per year per household
### Egg Productivity
* Rates of egg production by time and number of animals owned
### Agricultural Wages
* Daily wages in agriculture by household
### Crop Production Costs Per Hectare
* Explicit and total costs per hectare (uses the crop expenses prepared files) by plot and plot manager gender
### Land Rental Input Costs
* Land rental rate per hectare for each gender category of plot manager to get to value of land owned and area planted for each plot manager gender. 
### Input Costs
* Cost of fertilizer inputs 
### Rate of Fertilizer Application
* Application rates (kg/ha of product, rather than nutrient) for fertilizers (organic and inorganic), herbicides, and pesticides.
### Houeshold's Diet Diversity Score
* Can't generate this section in this wave
### Women's Control Over Income
* Women's decisionmaking ability over the proceeds of crop sales, wages, business income, and other income sources.
### Women's Participation in Agricultural Decisionmaking 
* Detailed breakdown of the types of livestock and plot management decisions women were listed as controlling
### Women's Ownership of Assets
* Capital asset ownership rates among women
### Agricultural Wages
* Deprecated, removed (see Farm Labor)
### Crop Yields
* Converts plot variables file to wider format for backwards compatibility - yields are now directly constructable in "all_plots.dta"
### Shannon Diversity Index
* Applies the area-weighted diversity index calculation to crops grown on plots
### Consumption
* Observed values of consumption by category to align with consumption estimates made in previous waves
### Food Security
* Food security by household
### Food Provision
* Not able to follow this section because the raw data doesn't have months of food insecurity. Instrad this is a measure of total number of households with people who reported being food insecure in the past 12 months.
### Household Assets
* Reported value of assets owned (see questionnaire household section 5 for types of assets)
### Distance to Agro Dealers
* Can't generate this section in this wave
## Used to Compute Summary Statistics
### Household Variables
* Collects and winsorizes variables related to household level crop and livestock production
### Individual Level Variables
* Collects and winsorizes variables related to plot and livestock managers and asset ownership
### Plot Variables
* Collects and winsorizes variables related to plot-level crop production
* Calculates gender productivity gap (across plot managers) using regressions
### Summary Statistics
* Computes summary statistics for the variables in the previous 3 sections, reporting mean, standard deviation/standard error, percentiles, and n. See the summary statistics file in the main project folder.

