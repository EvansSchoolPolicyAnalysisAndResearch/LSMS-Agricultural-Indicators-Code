# Ethiopia ERSS/LSMS-ISA Wave 1 (2011-2012)
CODING STATUS: Fully completed, still under active review and expansion.
READ ME STATUS: UNDER CONSTRUCTION
## Prerequisites
* Download the raw data from (https://microdata.worldbank.org/index.php/catalog/2053)
* Extract the files to the "Raw DTA Files" folder in the cloned directory
DPut the raw DTA files in a single folder (such as the Raw DTA Files folder provided) and adjust the global Ethiopia_ESS_W1_raw_data in the do-file to the correct path. Adjust the Ethiopia_ESS_W1_created_data to the created_data folder (this will store intermediate files) and Ethiopia_ESS_W1_created_data (to store the final dta files).
* Update the paths on lines 64 and 69-79 with the correct paths to the raw data and output files.

## Table of Contents
### Globals
* This section sets global variables for use later in the script, including:
  * Population
  * Population estimates from: https://databank.worldbank.org/source/world-development-indicators#
    * Ethiopia_ESS_W1_pop_tot - Total population in 2011 (World Bank)
    * Ethiopia_ESS_W1_pop_rur - Rural population in 2011 (World Bank)
    * Ethiopia_ESS_W1_pop_urb - Urban population in 2011 (World Bank)
  * Exchange Rates
    * Ethiopia_ESS_W1_exchange_rate - USD-Birr conversion
    * Ethiopia_ESS_W1_gdp_ppp_dollar - GDP-based purchasing power parity conversion, World Bank Indicator PA.NUS.PPP
    * Ethiopia_ESS_W1_cons_ppp_dollar - Private-consumption-based purchasing power parity conversion, World Bank Indicator PA.NUS.PRVT.P
    * Ethiopia_ESS_W1_inflation - inflation for 2.15 2017 baseline  
  * Poverty Thresholds
    * Ethiopia_ESS_W1_poverty_190 - The poverty threshold as determined from the National Statistics Bureau, inflated to 2019 via CPI
    * Ethiopia_ESS_W1_poverty_nbs - The updated $2.15 2017 PPP poverty line currently used by the world bank, converted to local currency
    * Ethiopia_ESS_W1_poverty_215 - Calculation for World Bank's previous $1.90 (PPP) poverty threshold. This controls the indicator poverty_under_1_9; change the 1.9 to get results for a different threshold. This is based on the 2011 PPP conversion!
### Winsorization Thresholds
* We correct outliers by Winsorization - setting values above the 99th and/or below the 1st percentiles to the value of the 99th or 1st percentile. The thresholds can be adjusted here or removed by setting them to 0 and 100
### Globals of Priority Crops
* This section defines the list of crops used to report crop-specific indicators, including indicators for monocropped plots. Adjust this list to change the output.
### Uniquely Identifiable Geographies
*This section creates uniquely identifiable variables by creating a temp folder and resaving raw data with changed variables. Collapsing by zone, woreda, kebele, ea alone will inaccurately generate medians due to not being unique identifiers. This problem persists with field_id and plot_id which are unique at the household and holder_id level only.
### Identifying Whether Households Were Interviewed POST-PLANTING and POST-HARVEST
*creating a file for households that were interviewed post planting and post harvest.
### Household IDs
* This section simplifies the household roster and drops non-surveyed householdsand. Also generates a variable that indicates the representativeness of a household by region. 
### Weights
* We rescale the weights to match the rural and urban populations for 2019 as reported in the World Bank Data Bank (last accessed 2023)
### Individual IDs
* Simplified household member roster
### Individual Gender
* Creating a gender merge file that has genders for each individual id.
### Household Size
* Calculating the number of household members 
### Plot Areas
* Calculates farmer-estimated plot areas from nonstandard units and GPS-measured plot areas and converts to hectares
* If gps_area is set to something other than 0, non-measured plots are dropped; otherwise, area is determined first from GPS measurements and backfilled from respondent estimates when GPS measurements are unavailable
### Plot Decisionmakers
* Determines gender of person or people who make plot management decisions - 1: male, 2: female, or 3: mixed male and female.
* No direct plot decision maker question in this wave so have to infer who the decision maker is from a different question. 
### All Area Construction/Field Area
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
### Livestock Income
* Values of production from reported sales of eggs, milk, and other livestock products
### Milk Productivity
* Rates of milk production by time and number of animals owned
* Questions in wave 2 are limited for this section so can only generate average quantity (liters) of milk per year per household
### Egg Productivity
* Rates of egg production by time and number of animals owned
### Livestock Sold (Live)
* Price per live animal sold, purchased and slaughtered. 
* Questionnaire asks about sales of livestock, but doesn't specify whether it's live or slaughtered
* Cannot value purchased animals because the questionnaire doesn't ask anything about the costs spent on purchasing animals, just the number of animals purchased. 
* Slaughtered animals captured in byproducts (instrument asks about sales of beef, mutton/goat, and camel meat sales and consumption)
### TLU (Tropical Livestock Units)
* Total number of livestock owned by type and by tropical livestock unit (TLU) coefficient
### Self Employment Income
* Estimated annual net profit from self employmnent over the past year
### Income
* Generates ag and non-ag income
### Off Farm Hours
* Total amount of hours off of the farm per household and number of household members who work off farm hours
### Farm Labor
* Converts labor as recorded in the crop expense section to a wider format to maintain backwards compatibility with the summary statistics file
### Farm Size
* Land size in hectares and cultivated parcels
### Land Size
* parcels owned, rented and not owned. Summed area in hectares by each household that aren't rented out.
### Vaccine Usage
* Individual-level livestock vaccine use rates
### ANIMAL HEALTH - DISEASES
* Animal disease disaggregated by animal type
### Livestock Water, Feeding, and Housing
* Can't generate this section in this wave
### Plot Managers
* Individual-level use rates of fertilizer, herbicide, pesticide, and improved seeds by plot managers
### Use of Inorganic Fertilizer
* Measures households that use inorganic fertilizer.
### Use of Improved Seeds
*Use of improved and hybrid seed use on the household and individual level. 
### Reached by Ag Extension
* Number and purpose of ag extension contacts received by the household
### Mobile Ownership
* Measure of households that own mobile phones. 
### Use of Formal Financial Services
* Household-level rates of bank services, lending and credit, digitial banking, insurance, and savings accounts
### Crop Production Costs Per Hectare
* Explicit and total costs per hectare (uses the crop expenses prepared files) by plot and plot manager gender
### Rate of Fertilizer Application
* Application rates (kg/ha of product, rather than nutrient) for fertilizers (organic and inorganic), herbicides, and pesticides.
### Women's Diet Quality
* Can't generate this section in this wave
### Agricultural Wages
* Hired labor wages for men, women, and children for post planting and post harvest 
### Diet Diversity 
* Food consumption diversity by household
### Women's Ownership of Assets
* Capital asset ownership rates among women
### Women's Participation in Agricultural Decision-making 
* Detailed breakdown of the types of livestock and plot management decisions women were listed as controlling
* SALES DECISION-MAKERS - PERM SALES - not asked in wave one
* WOMEN'S CONTROL OVER INCOME - not asked in wave one
### Women's Control Over Income
* Women's decisionmaking ability over the proceeds of crop sales, wages, business income, and other income sources.
### Crop Yields
* Converts plot variables file to wider format for backwards compatibility - yields are now directly constructable in "all_plots.dta"
### Shannon Diversity Index
* Applies the area-weighted diversity index calculation to crops grown on plots
### Consumption
* Observed values of consumption by category to align with consumption estimates made in previous waves
### Livestock Productivity
* REPEATED? CANT TELL IF THIS IS OLD? 
### Household Food Provision
* This is is a measure of total number of households with people who reported being food insecure in the past 12 
### Household Assets
* Reported value of assets owned (see questionnaire household section 5 for types of assets)
### Fish Income
* Can't generate this section in this wave
### Distance to Agro Dealers
* Can't generate this section in this wave
### Household Variables
* Collects and winsorizes variables related to household level crop and livestock production
### Individual Level Variables
* Collects and winsorizes variables related to plot and livestock managers and asset ownership
### Plot Variables
* Collects and winsorizes variables related to plot-level crop production
* Calculates gender productivity gap (across plot managers) using regressions
### Summary Statistics
* Computes summary statistics for the variables in the previous 3 sections, reporting mean, standard deviation/standard error, percentiles, and n. See the summary statistics file in the main project folder.