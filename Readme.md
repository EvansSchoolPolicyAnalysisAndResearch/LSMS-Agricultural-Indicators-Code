# Uganda NPS/LSMS-ISA Wave 1 (2009-2010)
CODING STATUS: Fully completed, still under active review and expansion

## Prerequisites
* Download the raw data from https://microdata.worldbank.org/index.php/catalog/3557
* Extract the files to the "Raw DTA Files" folder in the cloned directory
* Update the paths on lines 131 and 136-139 with the correct paths to the raw data and output files.

## Table of Contents
### Globals
* This section sets global variables for use later in the script, including:
  * Population
  * Non-GPS-Plots
  * Exchange Rates
    * NPS_LSMS_ISA_W1_exchange_rate - USD-Shilling conversion
    * NPS_LSMS_ISA_W1_gdp_ppp_dollar - GDP-based purchasing power parity conversion, World Bank Indicator PA.NUS.PPP
    * NPS_LSMS_ISA_W1_cons_ppp_dollar - Private-consumption-based purchasing power parity conversion, World Bank Indicator PA.NUS.PRVT.P
    * NPS_LSMS_ISA_W1_inflation - Ratio of 2019:2010 CPI 
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
### Standard Conversion Factor Table
*This section calculates Price per kg (Sold value ($)/Qty Sold (kgs)) but using Standard Conversion Factor table instead of raw WB Conversion factor w3 -both harvested and sold.
*Standard Conversion Factor Table: By using All 7 Available Uganda waves we calculated the median conversion factors at the crop-unit-regional level for both sold and harvested crops. For  crops-unit-region conversion factors that were missing observations, information we imputed the conversion factors at the crop-unit-national level values. 
*This Standard coversion factor table will be used across all Uganda waves to estimate kilogram harvested, and price per kilogram median values.
*By using the standard conversion factor we calculate -On average - a higher quantity harvested in kg than using the WB conversion factors (though there are many cases that standard qty harvested is smaller than the WB qty harvested) 
*Date variables are not present in W1 so can't find month planted etc
### [Harvest and Sold] Crop Unit Conversion Factors  **
*Notes: This section was used to calculate the median crop unit conversion factors for harvest and sold variables. Now, we will use the raw variable from the World bank. 
### TLU (Tropical Livestock Units)
* Total number of livestock owned by type and by tropical livestock unit (TLU) coefficient
### Gross Crop Revenue:  Gross Crop Revenue Update based on Nigeria Wave 3 
* Total value of crops sold
### Crop Expenses
* Total expenses divided among implicit/explicit and expense type, attributed at the plot level where possible.
### Monocropped Plots
* Plot variables and expenses, along with some additional plot attributes as recorded in the plot roster, for only plots with a single reported crop and for only crops specified in the priority crop globals. For this wave, we also estimate the total nutrition application from fertilizers.
###Labor
* This section will develop indicators around inputs related to crops, such as labor (hired and family), pesticides/herbicides, animal power (not measured for Uganda), machinery/tools, fertilizer, land rent, and seeds.
* Uganda average wage per day is $4/per person...average in dataset is $5.32
* Note: no information on the number of people, only person-days hired and total value (cash and in-kind) of daily wages
### Family Labor
* This section combines both seasons and renames variables to be more useful
###CHEMICALS, FERTILIZER, LAND, ANIMALS (excluded for Uganda), AND MACHINES
* For W1: Barely any information collected on livestock inputs to crop agriculture. There are binary variables as to whether a house used their own livestock on their fields, but no collection of data about renting animal labor for a household. Some information (Section 11 in ag survey, question 5) about income from renting out their own animals is asked, but this is not pertinent to crop expenses. Animal labor can be a big expense, so we are creating explicit and implicit cost variables below but filling them with empty values.
* Machinery Input: Information was collected on machinery inputs for crop expenses in section 10, but was only done at the household level. Other inputs are at the plot level.
* Fertilizer - compared to other countries Uganda doesn't have transportation variables, or regional information. It is something we can append at a later stage. 
### Land Rentals
* Note: Uganda does not ask about rental at a plot level, just a parcel level
### Seeds
* Note: Quantity data does not exist in W1. But it doesn't matter for later stages of analysis. 


