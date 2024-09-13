# Nigeria GHS/LSMS-ISA Wave 4 (2018-2019)
CODING STATUS: Fully completed, still under active review and expansion

## Prerequisites
* Download the raw data from https://microdata.worldbank.org/index.php/catalog/3557
* Extract the files to the "Raw DTA Files" folder in the cloned directory
* Update the paths on lines 131 and 136-139 with the correct paths to the raw data and output files.
* This file also calculates child anthropometry Z-scores using the WHO iGrowUp module, which can be found here: https://www.who.int/tools/child-growth-standards/software. Download the file and update the path on line 141 if you want this information; otherwise, the do file will skip the anthropometry section.  

## Table of Contents
### Globals
* This section sets global variables for use later in the script, including:
  * Population
    * Nigeria_GHS_W4_pop_tot - Total population in 2019 (World Bank)
    * Nigeria_GHS_W4_pop_rur - Rural population in 2019 (World Bank)
    * Nigeria_GHS_W4_pop_urb - Urban population in 2019 (World Bank)
  * Non-GPS-Plots
    * drop_unmeas_plots - if not 0, this global will remove any plot that is not measured by GPS from the sample. Used to reduce variability in yields that results from uncertainty around farmer area estimation and nonstandard unit conversion
  * Exchange Rates
    * Nigeria_GHS_W4_exchange_rate - USD-Naira conversion
    * Nigeria_GHS_W4_gdp_ppp_dollar - GDP-based purchasing power parity conversion, World Bank Indicator PA.NUS.PPP
    * Nigeria_GHS_W4_cons_ppp_dollar - Private-consumption-based purchasing power parity conversion, World Bank Indicator PA.NUS.PRVT.P
    * Nigeria_GHS_W4_infl_adj - Ratio of 2019:2017 Nigeria consumer price index (World Bank), used for calculating poverty thresholds
    * Nigeria_GHS_W4_pound_exchange - Pound exchange rate for 2019, used for remittances
    * Nigeria_GHS_W4_euro_exchange - Euro exchange rate for 2019, used for remittances
  * Poverty Thresholds
    * Nigeria_GHS_W4_poverty_threshold - The pre-2023 $1.90 2011 PPP poverty line used by the World Bank, converted to local currency
    * Nigeria_GHS_W4_poverty_nbs - The poverty threshold as determined from the National Statistics Bureau, inflated to 2019 via CPI
    * Nigeria_GHS_W4_poverty_215 - The updated $2.15 2017 PPP poverty line currently used by the world bank, converted to local currency
  * Cost of a Nutritious Diet
    * Nigeria_GHS_W4_CoCA_diet - Cost of a calorically adequate diet, Naira per adult equivalent, as calculated from Bai et al. (2021)
    * Nigeria_GHS_W4_CoNA_diet - Cost of a nutritionally adequate diet, as above  
### Winsorization Thresholds
* We correct outliers by Winsorization - setting values above the 99th and/or below the 1st percentiles to the value of the 99th or 1st percentile. The thresholds can be adjusted here or removed by setting them to 0 and 100
### Globals of Priority Crops
* This section defines the list of crops used to report crop-specific indicators, including indicators for monocropped plots. Adjust this list to change the output.
### Weights
* We rescale the weights to match the rural and urban populations for 2019 as reported in the World Bank Data Bank (last accessed 2023)
### Household IDs
* This section simplifies the household roster and drops non-surveyed households
### Individual IDs
* Simplified household member roster
### Household Size
* Calculating the number of household members and rescaling the weights - the original weights are retained and can be used by switching all instances of weight_pop_rururb to weight
### Head of Household
* Determines gender of household head
### GPS Coordinates
* Simplified EA lat/lon
### Plot Areas
* Calculates farmer-estimated plot areas from nonstandard units and GPS-measured plot areas and converts to hectares
* If gps_area is set to something other than 0, non-measured plots are dropped; otherwise, area is determined first from GPS measurements and backfilled from respondent estimates when GPS measurements are unavailable
### Plot Decisionmakers
* Determines gender of person or people who make plot management decisions - 1: male, 2: female, or 3: mixed male and female
### Formalized Land Rights
* Determines whether a plot holder has a formal title and records formal landholder gender
### Crop Unit Conversion Factors
* Generates a nonstandard unit conversion factors table from reported conversions in the agricultural module, filling unknown entries with values from the literature where necessary and noted
### All Plots
* Generates plot production statistics, including kilograms harvested, sales prices, imputed values, and cropping style
### TLU (Tropical Livestock Units)
* Total number of livestock owned by type and by tropical livestock unit (TLU) coefficient
### Gross Crop Revenue
* Total value of crops sold
### Crop Expenses
* Total expenses divided among implicit/explicit and expense type, attributed at the plot level where possible.
### Monocropped Plots
* Plot variables and expenses, along with some additional plot attributes as recorded in the plot roster, for only plots with a single reported crop and for only crops specified in the priority crop globals. For this wave, we also estimate the total nutrition application from fertilizers.
### Livestock Income
* Values of production from reported sales of eggs, milk, other livestock products, and slaughtered livestock.
### Fish Income
* Total value of fish caught and time spent fishing
### Self-Employment Income
* Value of income from owned businesses and postharvest crop processing
### Off-Farm Hours
* Number of household members engaged in and total time spent in nonfarm activities, including waged employment
### Wage Income
* Income from paid employment
### Other Income
* Value of assistance, rental, pension, investments, and remittances
### Farm Size
* Total area owned and worked
### Farm Labor
* Converts labor as recorded in the crop expense section to a wider format to maintain backwards compatibility with the summary statistics file
### Vaccine Usage
* Individual-level livestock vaccine use rates
### Animal Health - Diseases
* Rates of disease incidence for foot and mouth, lumpy skin, black quarter, brucelosis
### Livestock Water, Feeding, and Housing
* Food types and housing types for owned and kept livestock (water sources unavailable for Nigeria(
### Plot Managers
* Individual-level use rates of fertilizer, herbicide, pesticide, and improved seeds by plot managers
### Reached by Ag Extension
* Number and purpose of ag extension contacts received by the household
### Use of Formal Financial Services
* Household-level rates of bank services, lending and credit, digitial banking, insurance, and savings accounts
### Milk Productivity
* Rates of milk production by time and number of animals owned
### Egg Productivity
* Rates of egg production by time and number of animals owned
### Crop Production Costs Per Hectare
* Explicit and total costs per hectare (uses the crop expenses prepared files) by plot and plot manager gender
### Rate of Fertilizer Application
* Application rates (kg/ha of product, rather than nutrient) for fertilizers (organic and inorganic), herbicides, and pesticides.
### (To Update) Land Rental Rates
### Seed Costs (_Commented Out_)
* Attempts to estimate value of seed planted at the plot level from observations of purchases at the household level. Disagreement between application units and purchase units make this section's estimates highly variable and therefore less reliable.
### Rate of Fertilizer Application (second part, to move)
* Winsorizes fertilizer application rates
### Women's Diet Quality
* **Not constructed, unavailable for wave 4**
### Household's Diet Diversity Score
* Calculates dietary diversity from reported food consumption
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
### Household Assets
* Reported value of assets owned (see questionnaire household section 5 for types of assets)
### Poverty Indices
* New addition for wave 4, attempts to map LSMS responses to the MPI poverty index. Mortality rate of children under 5 is not included in the LSMS questionnaire, causing some deviation from the reported MPI values
* Constructs food consumption value relative to the cost of nutritionally/calorically adequate diet estimates.  
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
 
## Known Issues and Changes from Previous Surveys
* Previous waves of Nigeria consider yams under a single crop code (1120). In Wave 4, the category was broken out into four subcategories: white yam, yellow yam, water yam, and three-leaved yam. These crops were reunited under the 1120 umbrella, but have (sometimes significantly) different planting and harvest dates, so there's some loss of information occurring. In the October 2024 update, the decision was made to drop three-leaved yam from the combined category under the assumption that its cultivation and uses differ substantially from the other three.
* The questions around family labor days worked have changed, resulting in underreporting compared to previous waves. Labor productivity statistics are not comparable to waves 1-3.
* Fishing-related expenses are no longer included because the relevant questions were removed
* Prior to version 3 of the dataset, the aggregate consumption files were unavailable, so a similar version was constructed _without_ using the regional and temporal deflation factors applied in consumption aggregate files. This code is left in for validation purposes but not currently used to construct estimates.
