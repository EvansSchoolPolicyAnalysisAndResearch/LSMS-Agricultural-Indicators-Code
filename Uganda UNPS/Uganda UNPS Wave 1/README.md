# Uganda NPS/LSMS-ISA Wave 1 (2009-2010)
CODING STATUS: Fully completed, still under active review and expansion

## Prerequisites
* Download the raw data from https://microdata.worldbank.org/index.php/catalog/3557
* Extract the files to the "Raw DTA Files" folder in the cloned directory
DPut the raw DTA files in a single folder (such as the Raw DTA Files folder provided) and adjust the global Uganda_NPS_W1_raw_data in the do-file to the correct path. Adjust the Uganda_NPS_W7_created_data to the created_data folder (this will store intermediate files) and Uganda_NPS_W1_final_data (to store the final dta files).
Additional conversion factor files are provided in the created_data folder for converting nonstandard agricultural units. These files reduce spread across estimates due to differences in the conversion factors provided for the same unit by calculating the national and regional medians across all seven waves.
1. `UG_Conv_fact_sold_table.dta`
2. `UG_Conv_fact_sold_table_national.dta`
3. `UG_Conv_fact_harvest_table.dta`
4. `UG_Conv_fact_harvest_table_national.dta`
* Update the paths on lines 131 and 136-139 with the correct paths to the raw data and output files.

## Table of Contents
### Globals
- **DESCRIPTION:** This section sets global variables for use later in the script, including:
 * Population
  * Population estimates from: https://databank.worldbank.org/source/world-development-indicators# 
    * UGA_W1_pop_tot Total population in 2009 (World Bank)
    * UGA_W1_pop_rur Rural population in 2009 (World Bank)
    * UGA_W1_pop_urb - Urban population in 2009 (World Bank)
* Species
    * Livestock species categories: large ruminants (bovids), small ruminants (sheep, goats), pigs, equines (horses, donkeys), and poultry (including rabbits) 
  * Exchange Rates
global UGA_W1_exchange_rate 3690.85
global UGA_W1_gdp_ppp_dollar 1270.608398
    // https://data.worldbank.org/indicator/PA.NUS.PPP //updated 4.6.23 to 2017 value
global UGA_W1_cons_ppp_dollar 1221.087646
	 // https://data.worldbank.org/indicator/PA.NUS.PRVT.PP //updated 4.6.23 to 2017 value
global UGA_W1_inflation  0.59959668237 // CPI_Survey_Year/CPI_2017 -> CPI_2010/CPI_2017 ->  (100/166.7787747)
//https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2016&locations=UG&start=2010 // The data were collected over the period 2009 - 2010
global UGA_W1_poverty_190 (1.90*944.26)*(116.6/116.6)  //Calculation for WB's previous $1.90 (PPP) poverty threshold, 158 N. This controls the indicator poverty_under_1_9; change the 1.9 to get results for a different threshold. Note this is based on the 2011 PPP conversion!
global UGA_W1_poverty_nbs 3880.75 *(1.108) //2009-2010 poverty line from https://nigerianstat.gov.ng/elibrary/read/544 adjusted to 2011
global UGA_W1_poverty_215 2.15*($NPS_LSMS_ISA_W1_inflation)*$NPS_LSMS_ISA_W1_cons_ppp_dollar  //New 2017 poverty line - 124.68 N

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
* Note: used "Who usually (mainly) works on this parcel?" Different from other waves where we have used "Who managed/controls the output from this parcel?" 

### Plot Areas
* Calculates farmer-estimated plot areas from nonstandard units and GPS-measured plot areas and converts to hectares
* If gps_area is set to something other than 0, non-measured plots are dropped; otherwise, area is determined first from GPS measurements and backfilled from respondent estimates when GPS measurements are unavailable

### Plot Decisionmakers
* Determines gender of person or people who make plot management decisions - 1: male, 2: female, or 3: mixed male and female

### Formalized Land Rights
* Determines whether a plot holder has a formal title and records formal landholder gender

### Crop Unit Conversion Factors
* Generates a nonstandard unit conversion factors table from reported conversions in the agricultural module, filling unknown entries with values from the literature where necessary and noted

### All Plots - 
* Generates plot production statistics, including kilograms harvested, sales prices, imputed values, and cropping style
*Purpose:
*Crop values section is about finding out the value of sold crops. It saves the results in temporary storage that is deleted once the code stops running, so the entire section must be ran at once (conversion factors require output from Crop Values section). Some variables are labelled different in comparison to W3 onwards. 
*Plot variables section is about pretty much everything else you see below in all_plots.dta. It spends a lot of time creating proper variables around intercropped, monocropped, and relay cropped plots, as the actual data collected by the survey seems inconsistent here.
*Many intermediate spreadsheets are generated in the process of creating the final .dta
*Final output is all_plots.dta. This file has regional, hhid, plotid, crop code, fieldsize, monocrop dummy variable, relay cropping variable, quantity of harvest, value of harvest, hectares planted and harvested, number of trees planted, plot manager gender, percent inputs(?), percent field (?), and months grown variables.
*Note: Some outliers identified, still work in progress

### Standard Conversion Factor Table
*This section calculates Price per kg (Sold value ($)/Qty Sold (kgs)) but using Standard Conversion Factor table instead of raw WB Conversion factor w3 -both harvested and sold.
*Standard Conversion Factor Table: By using All 7 Available Uganda waves we calculated the median conversion factors at the crop-unit-regional level for both sold and harvested crops. For  crops-unit-region conversion factors that were missing observations, information we imputed the conversion factors at the crop-unit-national level values. 
*This Standard coversion factor table will be used across all Uganda waves to estimate kilogram harvested, and price per kilogram median values.
*By using the standard conversion factor we calculate -On average - a higher quantity harvested in kg than using the WB conversion factors (though there are many cases that standard qty harvested is smaller than the WB qty harvested) 
*Date variables are not present in W1 so can't find month planted etc

### [Harvest and Sold] Crop Unit Conversion Factors  **
*Notes: This section was used to calculate the median crop unit conversion factors for harvest and sold variables. Now, we will use the raw variable from the World bank. 
**CODING STATUS:** ![INPROGRESS](https://placehold.co/15x15/c5f015/c5f015.png) `INPROGRESS`

### Gross Crop Revenue:  Gross Crop Revenue Update based on Nigeria Wave 3 
* Total value of crops sold
**CODING STATUS:** ![INPROGRESS](https://placehold.co/15x15/c5f015/c5f015.png) `INPROGRESS`

### Crop Expenses
* Total expenses divided among implicit/explicit and expense type, attributed at the plot level where possible.
**CODING STATUS:** ![INPROGRESS](https://placehold.co/15x15/c5f015/c5f015.png) `INPROGRESS`

### Monocropped Plots
* This section uses the priority crops to generate statistics related to plots where only a single crop was grown. These statistics include expenses, quantity and area harvested, and labor inputs. The intermediate (created_data) file is named using the abbreviations in the priority crops global. 
**CODING STATUS:** ![INPROGRESS](https://placehold.co/15x15/c5f015/c5f015.png) `INPROGRESS`

### TLU (Tropical Livestock Units)
* This section generates coefficients to convert different types of farm animals into the standardized "tropical livestock unit," which is usually based around the weight of an animal (kilograms of meat). It also creates variables whether a household owns certain types of farm animals, both currently and over the past 12 months, and how many they own. Separate into pre-specified categories such as cattle, poultry, etc.and then converted into Tropical Livestock Units at the Household-level.

### HOUSEHOLD LIVESTOCK OWNERSHIP
* Generate ownership variables per household

### LIVESTOCK INCOME
* This section estimates household livestock expenses (i.e., fodder, water, vaccines, deworming, ticks, hired labor), livestock income which includes livestock products (milk, eggs, livestock sold live and slaughtered), and the value of livestock ownership. 

### FISH INCOME   
* No Fish Income data collected

### SELF-EMPLOYMENT INCOME
* This section is meant to calculate the value of all activities the household undertakes that would be classified as self-employment. This includes profit from business

### OFF-FARM HOURS
* This section estimates the Total household off-farm hours, for the past 7 days by household members. 

### NON-AG WAGE AND AG WAGE INCOME  
* This section estimates "Annual earnings from non-agricultural and agricultural wage (both Main and Secondary Job)".
* Notes: UGA Wave 1 did not capture number of weeks per month individual worked.  We impute these using median values by industry and type of residence using UGA W2 see imputation below. This follows RIGA methods.
* Issues: The industry variable doesn't completely align with the categories, and this will be addressed in the next update. 

### OTHER INCOME
* This section estimates Other income (rental, pension, other, and remittance) over the previous 12 months at the household level.

### LAND RENTAL INCOME 
*DESCRIPTION: This section estimates "income from renting out land over the previous 12 months" at the household level. 
 
### Labor
* This section will develop indicators around inputs related to crops, such as labor (hired and family), pesticides/herbicides, animal power (not measured for Uganda), machinery/tools, fertilizer, land rent, and seeds.
* Uganda average wage per day is $4/per person...average in dataset is $5.32
* Note: no information on the number of people, only person-days hired and total value (cash and in-kind) of daily wages

### Family Labor
* This section combines both seasons and renames variables to be more useful

### CHEMICALS, FERTILIZER, LAND, ANIMALS (excluded for Uganda), AND MACHINES
* For W1: Barely any information collected on livestock inputs to crop agriculture. There are binary variables as to whether a house used their own livestock on their fields, but no collection of data about renting animal labor for a household. Some information (Section 11 in ag survey, question 5) about income from renting out their own animals is asked, but this is not pertinent to crop expenses. Animal labor can be a big expense, so we are creating explicit and implicit cost variables below but filling them with empty values.
* Machinery Input: Information was collected on machinery inputs for crop expenses in section 10, but was only done at the household level. Other inputs are at the plot level.
* Fertilizer - compared to other countries Uganda doesn't have transportation variables, or regional information. It is something we can append at a later stage. 

### Land Rentals
* Note: Uganda does not ask about rental at a plot level, just a parcel level

### Seeds
* Use of improved and hybrid seed use on hte household and individual level.
* Note: Quantity data does not exist in W1. But it doesn't matter for later stages of analysis. 

### Livestock + TLU (Tropical Livestock Units)
* Number of livestock owned the day of the survey and 1 year ago
* Note: Indigenous/Exotic/Cross not mentioned for sheep/goats and pigs

### Crops Lost Post Harvest
* Total value of kg of crops lost post harvest 

### Livestock Income
* Values of production from reported sales of eggs, milk, and other livestock products

### Livestock Sold (Live)
* Price per live animal sold, purchased and slaughtered
* NOTE: For small animals the amount is for the last 6 months and for Poultry and others the amount is the last 3 months. These are multiplied by 2 and 4 respectively to estimate the number for the last 12 months.

### TLU (Tropical Livestock Units)
* Total number of livestock owned by type and by tropical livestock unit (TLU) coefficient
* Note: Dropping beehive because there is no income

### Self Employment Income
* Estimated annual net profit from self employmnent over the past year
Note: Processed crop and fish trading are not separate sections 

### Fish Income
* Can't generate this section in this wave

### Off Farm Hours
* Total amount of hours off of the farm per household and number of household members who work off farm hours

### Income
* Generates ag and non-ag income
* Note: UGA Wave 1 did not capture number of weeks per month individual worked. We impute these using median values by industry and type of residence using UGA W2 see imputation below. This follows RIGA methods. 

### Other income
* Total amount of hours off of the farm per household and number of household members who work off farm hours
* Note: Excluded royalties since it was already include it in rental income. It includes many sources of income

### Farm Size/Land Size
* Land size in hectares and cultivated parcels

### Farm Labor
* Converts labor as recorded in the crop expense section to a wider format to maintain backwards compatibility with the summary statistics file
* Uganda does not have a main season and a short season. For cross country compatibility this section codes the first visit as "the long season" and the second visit as "the short season" as Uganda provides little data beyond those two categories

### Vaccine Usage
* Individual-level livestock vaccine use rates

### Animal Health - Diseases
* Can't generate this section in this wave

### Livestock Water, Feeding, and Housing
* Can't generate this section in this wave

### Rate of Fertilizer Application
* Application rates (kg/ha of product, rather than nutrient) for fertilizers (organic and inorganic), herbicides, and pesticides.

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

### Women's Diet Diversity Score
* Can't generate this section in this wave

### Houeshold's Diet Diversity Score
* This section estimates the number of food groups (i.e., cereal, vegetables, fruits, eggs, fish, etc.,) households consumed in the past week.

### Women's Control Over Income
* Women's decisionmaking ability over the proceeds of crop sales, wages, business income, and other income sources.

### Women's Participation in Agricultural Decisionmaking 
* Detailed breakdown of the types of livestock and plot management decisions women were listed as controlling

### Women's Ownership of Assets
* Capital asset ownership rates among women

### Agricultural Wages
* This section estimates daily agricultural wage paid for hired labor by gender of worker (local currency), total hired labor (number of person days) by gender of worker at the household level. 

### Crop Yields
* Converts plot variables file to wider format for backwards compatibility - yields are now directly constructable in "all_plots.dta"
* Note: Missing area harvested, number of trees planted

### Shannon Diversity Index
* Applies the area-weighted diversity index calculation to crops grown on plots

### Consumption
* Observed values of consumption by category to align with consumption estimates made in previous waves

### Food Security
* Food security by household

### Food Provision
* This is is a measure of total number of households with people who reported being food insecure in the past 12 months.

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

