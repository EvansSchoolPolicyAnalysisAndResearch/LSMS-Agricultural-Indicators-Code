_IMPORTANT NOTE: Prior to the <SHA> update on 9/XX/24, this do file and folder were labeled as Tanzania Wave 5_
# Tanzania National Panel Survey (NPS) 2019-20: Extended Panel with Sex Disaggregated Data
CODING STATUS: Fully completed, still under active review

## Description
The Tanzania NPS SDD was a a suplementary survey of the 2014-15 (Wave 4) "extended panel" that includes additional modules for individual land ownership, financial assets, mobile phone ownership, and water quality testing. The remainder of the questionnaire is similar to the other NPS waves, with some omissions as noted in the code. In contrast with Wave 5 of the LSMS-ISA, the sample here can be used to assemble a panel with the previous survey waves, although the sample here (1,184 households) is smaller than the full sample for Wave 3 (2,165 households) and necessarily smaller thant the Wave 4 sample, which consists of both the "extended panel" and "refresh panel" for a total of 2,172 households. The Wave 5 survey continued with a combination of the refresh panel and an additional sample selected for that survey round.

## Prerequisites
* Download the raw data from https://microdata.worldbank.org/index.php/catalog/3885
* Extract the files to the "Raw DTA Files" folder in the cloned directory
* Update the paths under "Set location of raw data and output" with the correct paths to the raw data and output files, if the desired output is different from your local repository.

## Table of Contents
### Globals
* This section sets global variables for use later in the script. With the exception of top crop choices and Winsorization thresholds, it should not be necessary to change these values. They include:
  * Exchange Rates
    * Tanzania_NPS_SDD_exchange_rate: USD-TSH exchange rate in 2020
    * Tanzania_NPS_SDD_gdp_ppp_dollar: GDP-based purchasing power parity conversion, World Bank Indicator PA.NUS.PPP
    * Tanzania_NPS_sdd_cons_ppp_dollar: Private-consumption-based purchasing power parity conversion, World Bank Indicator PA.NUS.PRVT.P
  * Winsorization Thresholds
    * wins_lower_thres: a number from 0-100 that sets the lower threshold for Winsorization. Variables that are bottom-Winsorized (see Household Variables) will have any values that are below the percentile given set to that percentile, setting the floor of the data to that value. A value of 0 here is the same as not Winsorizing. The default is 1 (first percentile)
    * wins_upper_thres: a number from 0-100 that sets the upper threshold for Winsorization for top-Winsorized variables. A value of 100 is the same as not Winsorizing. The default is 99 (99th percentile)
  * Population  
    * Tanzania_NPS_SDD_pop_tot: total national population in 2020 as reported by the World Bank
    * Tanzania_NPS_pop_rur: total rural population in 2020
    * Tanzania_NPS_pop_urb: total urban population in 2020
  * Globals of Priority Crops
    * This section defines the list of crops used to report crop-specific indicators, including indicators for monocropped plots. Adjust this list to change the output.

 ### Household IDs
 * This section simplifies the household roster and drops non-surveyed households
 
 ### Individual IDs
 * Simplified household member roster and head of household

 ### Household Size
 * Calculates the number of household members and rescales the weights so that the totals match the estimated rural and urban populations (see Globals) - the original weights are retained and can be used by switching all instances of "weight_pop_rururb" to "weight"

 ### Plot Areas
 * Combines GPS-measured plot areas and farmer-estimated areas into a set of variables used for field size in subsequent modules

 ### Plot Decisionmakers
 * Determines gender of person or people who make plot management decisions - 1: male, 2: female, or 3: mixed male and female

 ### All Plots
 * Determines whether a plot holder has a formal title and records formal landholder gender
 * Generates plot production statistics, including kilograms harvested, sales prices, imputed values, and cropping style

 ### Crop Expenses
 * Total expenses divided among implicit/explicit and expense type, attributed at the plot level where possible.
 * Calculates plot rents and imputes implicit value of rent on owned land

 ### Monocropped Plots
 * Plot variables and expenses, along with some additional plot attributes as recorded in the plot roster, for only plots with a single reported crop and for only crops specified in the priority crop globals. Output is a set of files named "<cropname>_monocrop.dta"

 ### TLU (Tropical Livestock Units)
 * Total number of livestock owned by type and by tropical livestock unit (TLU) coefficient

 ### Gross Crop Revenue
 * Total value of crops sold

 ### Livestock Income
 * Values of production from reported sales of eggs, milk, other livestock products, and slaughtered livestock (including disaggregation by improved/local breeds).

 ### Fish Income
 * Cannot be constructed for Tanzania Wave 5

 ### Self-Employment Income
 * Value of income from owned businesses and postharvest crop processing

 ### Wage Income
 * Income from paid employment

 ### Other Income
 * Value of assistance, rental, pension, investments, and remittances

 ### Farm Size
 * Variations on agricultural land utilized by the household including (or excluding) fallowed and rented-out plots and area cultivated

 ### Off-Farm Hours
 * Number of household members engaged in and total time spent in nonfarm activities, including domestic work and waged employment

 ### Farm Labor
 * Calculates family/hired labor days and for productivity estimation

 ### Vaccine Usage
 * Individual-level livestock vaccine use rates

 ### Animal Health - Diseases
 * Rates of disease incidence for foot and mouth, lumpy skin, black quarter, brucelosis

 ### Livestock Water, Feeding, and Housing
 * Food types and housing types for owned and kept livestock

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

 ### Mobile Ownership
 * Rate of mobile phones owned at the household level

 ### Land Rental Rates
 * Processes previously constructed crop expense values into a format that can be read by later code

 ### Agricultural Wages
 * Total value of wages paid to agricultural laborers

 ### Rate of Fertilizer Application
 * Total fertilizer applied by plot

 ### Household's Diet Diversity Score
 * Calculates dietary diversity from reported food consumption

 ### Women's Control Over Income
 * Women's decisionmaking ability over the proceeds of crop sales, wages, business income, and other income sources.

 ### Women's Participation in Agricultural Decisionmaking 
 * Detailed breakdown of the types of livestock and plot management decisions women were listed as controlling

 ### Women's Ownership of Assets
 * Capital asset ownership rates among women

 ### Crop Yields
 * Converts plot variables file to wider format for backwards compatibility - yields are now directly constructable in "all_plots.dta" 

 ### Production by high/low value crops 
 * Aligns previously-constructed production statistics along commodity/food gruop categories and assumed crop value

 ### Shannon Diversity Index
 * Applies the area-weighted diversity index calculation to crops grown on plots

 ### Consumption 
 * Calculates per capita and per adult-equivalent daily consumption values from the consumption statistics

 ### Household Food Provision
 * Calculates number of months of experienced food insufficiency

 ### Household Assets
 * Reported value of assets owned

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
* TBD
