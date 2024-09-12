
# README File - Uganda NPS Wave 8 (2019-2020)
CODING STATUS: Under active coding and review
- ![INCOMPLETE](https://placehold.co/15x15/f03c15/f03c15.png) `INCOMPLETE`
- ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- ![PENDING REVIEW](https://placehold.co/15x15/1589F0/1589F0.png) `PENDING REVIEW`

## PREREQUESITES
Link to download data from the World Bank: https://microdata.worldbank.org/index.php/catalog/2059 
Dta Files downloaded must be compiled in a raw folder -  global UGS_W8_raw_data in the Master Do-file. Also, you need to create a temporary folder where datasets that have been processed -  cleaned, curated and/or transformed -, and a final folder where final indicators are summarized at different units of analysis (e.g., household, individual, plot level).
Additionally, in the temporary file you need to save the following datasets that can be found in the uganda-standard-conversion-factor-table folder:
1. UG_Conv_fact_sold_table_update.dta
2. UG_Conv_fact_sold_table_national_update.dta
3. UG_Conv_fact_harvest_table_update.dta
4. UG_Conv_fact_harvest_table_national_update.dta

The datasets above include the median conversion factors for both Crop harvested and Sold for each unit code (e.g., Sacks, Tin, Basket, Jerrican, etc.) at the regional and national level calculated using all Uganda NPS Waves available. These Standard Conversion factor tables are used in the All plots and Gross Crop Revenue sections to calculate Kilograms harvested, prices per kilogram, and value of crop harvested.

## Table of Contents
### Globals
* This section sets global variables for use later in the script, including:
  * Population
  * Population estimates from: https://databank.worldbank.org/source/world-development-indicators# 
    * UGA_NPS_W8_pop_tot - Total population in 2019 (World Bank)
    * UGA_NPS_W8_pop_rur - Rural population in 2019 (World Bank)
    * UGA_NPS_W8_pop_urb - Urban population in 2019 (World Bank)
  * Species
    * Livestock species categories: large ruminants (bovids), small ruminants (sheep, goats), pigs, equines (horses, donkeys), and poultry (including rabbits) 
  * Exchange Rates
    * Uganda_NPS_w8_exchange_rate - USD-Uganda shilling conversion
    * Uganda_NPS_w8_gdp_ppp_dollar - GDP-based purchasing power parity conversion, World Bank Indicator PA.NUS.PPP
    * Uganda_NPS_w8_cons_ppp_dollar - Private-consumption-based purchasing power parity conversion, World Bank Indicator PA.NUS.PRVT.P
    * Uganda_NPS_w8_inflation- inflation for 2.15 2017 baseline  
  * Poverty Thresholds
    * Uganda_NPS_w8_poverty_nbs - The poverty threshold as determined from the National Statistics Bureau, inflated to 2019 via CPI
    * Uganda_NPS_w8_poverty_215 - The updated $2.15 2017 PPP poverty line currently used by the world bank, converted to local currency
    * Uganda_NPS_w8_poverty_threshold - Calculation for World Bank's previous $1.90 (PPP) poverty threshold. This controls the indicator poverty_under_1_9; change the 1.9 to get results for a different threshold. This is based on the 2011 PPP conversion!

### Winsorization Thresholds
* We correct outliers by Winsorization - setting values above the 99th and/or below the 1st percentiles to the value of the 99th or 1st percentile. The thresholds can be adjusted here or removed by setting them to 0 and 100

### Globals of Priority Crops
* This section defines the list of crops used to report crop-specific indicators, including indicators for monocropped plots. Adjust this list to change the output.

### HOUSEHOLD IDS
- **DESCRIPTION:** This dataset includes HHID as a household unique identifier, household geographic information at different levels of dissaggregation (region, district, county, subcounty, ea, etc.), survey weights, and a rural/urban indicator. 
- **OUTPUT:** Uganda_NPS_w8_hhids.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.

### INDIVIDUAL IDS
- **DESCRIPTION:** This dataset includes PID as individual unique identifier, along with demographic information for each household member (i.e., age, gender, head of household, etc.). 
- **OUTPUT:** Uganda_NPS_w8_person_ids.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section. 

### HOUSEHOLD SIZE
- **DESCRIPTION:** This dataset includes number of household members, female-headed household, and adjusted survey weights to match urban/rural and total population. 
- **OUTPUT:** Uganda_NPS_w8_hhsize.dta
	      Uganda_NPS_w8_weights.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section. 

### PLOT AREAS
- **DESCRIPTION:**  We estimate plot area size by using parcel area size and plot area planted as a percentage of total plot area planted within each parcel. Then, we impute plot area size using the following equation: Plot area size = Parcel area size *  (Plot area planted in parcel C / Total Plot area  planted in parcel C). This dataset includes plot area size, parcel size, and plot area planted. 
- **OUTPUT:** Uganda_NPS_W8_plot_areas.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section. 

### PLOT-CROP DECISION MAKERS
- **DESCRIPTION:** By using 1st, 2nd, and 3rd Plot Decision-makers (members of the household) we create a plot-season level gender of decision-maker indicator (i.e., male/female/mixed).
- **OUTPUT:** Uganda_NPS_w8_plot_decision_makers.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section. 

### FORMALIZED LAND RIGHTS
- **DESCRIPTION:** Indicates whether at least one household member has official documentation (i.e., certificate of title, certificate of customary ownership, certificate of occupancy) for at least one plot. (Household level unit of analysis).
- **OUTPUT:** Uganda_NPS_w8_land_rights_hh.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section. 

### ALL PLOTS
- **DESCRIPTION:** This section uses the Price per Kilogram Methodology explained below. 
By converting quantities sold to kilograms, crops are comparable across distinct units, increasing the number of observations to calculate prices per kg for each geographic location. From a methodological standpoint, it may also be a good idea to convert to kilograms first because kilogram conversions are ostensible to kg dried/shelled crop, so we can avoid issues related to the fact that we have condition harvested but not condition sold.
It requires the use of Crop conversion factors sold/harvested indicators which might have measurement errors and uncertainty. These conversion factors are not consistent for the same crop-condition-unit or crop-condition-unit-region. To solve these inconsistencies, we have created a Standard Conversion factor (CF) table that calculated the median CF -for both sold and harvested - for each crop-unit-region using all 7 Uganda LSMS-ISA waves available. Below, you can find each step to calculate the final indicators in this section. 
1.	[standard Quantity Sold (kg)]: Convert every crop sold in quantity units into kilograms (Quantity sold kg) using the Standard Sold Conversion factor table – which calculates the median conversion factor sold for at the crop-unit regional level using all Uganda waves available.
2.	 [Standard Price per kg]: Calculate the Standard Price per kg (Sold Value $/Qty Sold (kg)) using the Total value sold ($) divided by the standard quantity sold in kilograms.
3.	[Standard Median Price per kg]: Calculate the standard Price per kg ($/kg) median values at the Crop level – everything has been converted to kilograms so distinct crop units are comparable – at different geographic locations (e.g., national, regional, county, sub-county, etc.)
4.	We assign these standard prices per kg median values to each crop that was harvested but not sold to compute the value of the crop harvested by merging the median price per kg at the crop level with at least 9 observations available for each geographic location using the most disaggregated location possible. 
5.	[Standard Quantity Harvested (kg)]: Convert every crop harvested in quantity units into kilograms (Quantity harvested kg) using the Standard Harvested Conversion factor table – which calculates the median conversion factor sold for at the crop-unit regional level using all Uganda waves available.
6.	[Standard Value Harvested {$)] We calculate the Standard Value Harvested using the standard quantity harvested (kg) and the standard median Price per kg ($/kg) [Value harvested = s.qty.harv*Priceperkg]
This section also includes crop plantation start date (month-year), crop harvest start and end date (month-year), total time of plantation, pure stand crops (monocropped vs intercropped), and permanent crops. The unit of analysis for this dataset is at the hh-plot-crop-season level. 
- **OUTPUT:** Uganda_NPS_LSMS_ISA_W8_all_plots.dta
- **CODING STATUS:** ![PENDING REVIEW](https://placehold.co/15x15/1589F0/1589F0.png) `PENDING REVIEW`
- **KNOWN ISSUES:** No issues in this section. 

### GROSS CROP REVENUE
- **DESCRIPTION:** This section uses the same Price per kilogram methodology used in the All Plots section to estimate the "Gross value of crop production, summed over main and short season" and the "Value of crops sold so far, summed over main and short season" both at the household-crop level, and at the household level. It also estimates the value of lost harvested at the household level. 
- **OUTPUT:** Uganda_NPS_w8_hh_crop_values_production.dta
	      Uganda_NPS_w8_hh_crop_production.dta
	     Uganda_NPS_w8_crop_losses.dta
- **CODING STATUS:** ![INCOMPLETE](https://placehold.co/15x15/f03c15/f03c15.png) `INCOMPLETE`
- **KNOWN ISSUES:** No issues in this section. 

### CROP EXPENSES
- **DESCRIPTION:** This section includes input costs related to crops production such as labor (hired and family), pesticides, machinery/tools, inorganic/organic fertilizers, land rental, and use of seeds. These indicators are estimated at the hh-plot-season level, and later summarized at the household level for explicit costs. 
- **OUTPUT:** UUganda_NPS_w8_hh_cost_inputs.dta
- **CODING STATUS:** ![PENDING REVIEW](https://placehold.co/15x15/1589F0/1589F0.png) `PENDING REVIEW`
- **KNOWN ISSUES:** No issues in this section. 

### MONOCROPPED PLOTS
- **DESCRIPTION:** Generate crop-level .dta files to be able to quickly look up data about households that grow specific, priority crops on monocropped plots. This dataset shows at the crop-level indicators such as quantity harvested (kg), and value of harvest dissagreggated by gender of plot decision-makers, and for each priority crop. It also creates the sum of all cost at the household level for priority crops (pure stand only) dissagregated by gender of plot decision-makers.
- **OUTPUT:** Uganda_NPS_W8_`cn'_monocrop_hh_area.dta, `cn' represents each priority crop
	      Uganda_NPS_W8_inputs_`cn'.dta, `cn' represents each priority crop
- **CODING STATUS:** ![INCOMPLETE](https://placehold.co/15x15/f03c15/f03c15.png) `INCOMPLETE`
- **KNOWN ISSUES:** No issues in this section. 

### TROPICAL LIVESTOCK UNIT (TLU) 
- **DESCRIPTION:** This section generate coefficients to convert different types of farm animals into the standardized "tropical livestock unit," which is usually based around the weight of an animal (kilograms of meat). It also creates variables whether a household owns certain types of farm animals, both currently and over the past 12 months, and how many they own. Separate into pre-specified categories such as cattle, poultry, etc.and then converted into Tropical Livestock Units at the Household-level. 
- **OUTPUT:** 
- **CODING STATUS:** ![INCOMPLETE](https://placehold.co/15x15/f03c15/f03c15.png) `INCOMPLETE`
- **KNOWN ISSUES:** 

### LIVESTOCK INCOME
- **DESCRIPTION:** This section estimates household livestock expenses (i.e., fodder, water, vaccines, deworming, ticks, hired labor), livestock income which includes livestock products (milk, eggs, livestock sold live and slaughtered), and the value of livestock ownership. 
- **OUTPUT:**
- **CODING STATUS:** ![INCOMPLETE](https://placehold.co/15x15/f03c15/f03c15.png) `INCOMPLETE`
- **KNOWN ISSUES:** 

### SELF-EMPLOYMENT INCOME
- **DESCRIPTION:** This section calculates the "Estimated annual net profit from self-employment over previous 12 months" which include business activities that household members were involved. The net profit is calculates using monthly revenue, monthly expenses (materials, wages, and operating), and number of months in the year that the business operated. 
- **OUTPUT:** 
- **CODING STATUS:** ![INCOMPLETE](https://placehold.co/15x15/f03c15/f03c15.png) `INCOMPLETE`
- **KNOWN ISSUES:**

### OFF-FARM HOURS
- **DESCRIPTION:** This section estimates the Total household off-farm hours, for the past 7 days by household members. 
- **OUTPUT:** 
- **CODING STATUS:** ![INCOMPLETE](https://placehold.co/15x15/f03c15/f03c15.png) `INCOMPLETE`
- **KNOWN ISSUES:** 

### NON-AG WAGE AND AG WAGE INCOME 
- **DESCRIPTION:** This section estimates "Annual earnings from non-agricultural and agricultural wage (both Main and Secondary Job)".
- **OUTPUT:** 
- **CODING STATUS:** ![INCOMPLETE](https://placehold.co/15x15/f03c15/f03c15.png) `INCOMPLETE`
- **KNOWN ISSUES:** 

### OTHER INCOME
- **DESCRIPTION:** This section estimates Other income (rental, pension, other, and remittance) over previous 12 months at the household level.
- **OUTPUT:**  
- **CODING STATUS:** ![INCOMPLETE](https://placehold.co/15x15/f03c15/f03c15.png) `INCOMPLETE`
- **KNOWN ISSUES:** 

### LAND RENTAL INCOME 
- **DESCRIPTION:** This section estimates "income from renting out land over previous 12 months" at the household level. 
- **OUTPUT:** 
- **CODING STATUS:** ![INCOMPLETE](https://placehold.co/15x15/f03c15/f03c15.png) `INCOMPLETE`
- **KNOWN ISSUES:**

### LAND SIZE
- **DESCRIPTION:** This section estimates "Total land size in hectares, including rented in and rented out plots".
- **OUTPUT:** 
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** 

### FARM LABOR
- **DESCRIPTION:** This section estimates Total labor days (family, hired, or other) allocated to the farm at the household level. Also, this section creates a livestock keeper - at least own one livestock type - indicator at the individual level.
- **OUTPUT:** 
- **CODING STATUS:** ![INCOMPLETE](https://placehold.co/15x15/f03c15/f03c15.png) `INCOMPLETE`
- **KNOWN ISSUES:** 

### VACCINE USAGE
- **DESCRIPTION:** This section estimates livestock vaccination by type of livestock (i.e., large ruminants, small ruminants, poultry, pigs) at the household level. 
- **OUTPUT:** 
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:**

### LIVESTOCK WATER, FEEDING, AND HOUSING
- **DESCRIPTION:** This section reports water livestock source (natural, constructed, covered) by livestock type at the household level. 
- **OUTPUT:** 
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** 

### USE OF INORGANIC FERTILIZER 
- **DESCRIPTION:** This section estimates use of inorganic fertilizer both at the household level and at the individual level -Individual farmer (plot manager) uses inorganic fertilizer.
- **OUTPUT:** 
- **CODING STATUS:** ![INCOMPLETE](https://placehold.co/15x15/f03c15/f03c15.png) `INCOMPLETE`
- **KNOWN ISSUES:** 

### USE OF IMPROVED SEED
- **DESCRIPTION:** This section estimates use of improved seeds by priority crop at the household level and individual level (distinct datasets). 
- **OUTPUT:** 
- **CODING STATUS:** ![INCOMPLETE](https://placehold.co/15x15/f03c15/f03c15.png) `INCOMPLETE`
- **KNOWN ISSUES:** 

### PLOT MANAGER
- **DESCRIPTION:** This section combines the use of inorganic fertilizer and improved seeds sections into one. 
- **OUTPUT:** 
- **CODING STATUS:** ![INCOMPLETE](https://placehold.co/15x15/f03c15/f03c15.png) `INCOMPLETE`
- **KNOWN ISSUES:** 

### REACHED BY AG EXTENSION
- **DESCRIPTION:** This section estimates households reached by agricultural extension services by type of source (all, public, private, unspecified). 
- **OUTPUT:** 
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** 

### MOBILE PHONE OWNERSHIP
- **DESCRIPTION:** This section includes the total number of mobile phones owned by household members today at the household level. 
- **OUTPUT:** 
- **CODING STATUS:** ![INCOMPLETE](https://placehold.co/15x15/f03c15/f03c15.png) `INCOMPLETE`
- **KNOWN ISSUES:** 

### MILK PRODUCTIVITY
- **DESCRIPTION:** This section estimates total quantity of milk per year, number of large ruminants that were milked, average months milked in last year, and average milk production (liters) per day per milked animal by type of livestock at the household level. 
- **OUTPUT:** 
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** The questions used in this section were framed differently across waves, therefore the indicators found in this section are not comparable across waves. Presence of outliers: Only 98 observations are recorded. 

### EGG PRODUCTIVITY
- **DESCRIPTION:** 
This section creates the number of poultry that laid eggs in the last 3 months, number of eggs that wre produced per month, total number of eggs that were produced in the year, and total number of poultry ownned at the household level. 
- **OUTPUT:** 
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** The questions used in this section were framed differently across waves, therefore the indicators found in this section are not comparable across waves. 

### CROP PRODUCTION COSTS PER HECTARE
- **DESCRIPTION:** This section shows explicit cost per hectare of area planted and total cost per hectare of area planted by gender of plot decision-makers at the household level.
- **OUTPUT:** 
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** 

### RATE OF FERTILIZER APPLICATION
- **DESCRIPTION:** This section includes inorganic fertilizer (kgs), organic fertilizer (kgs), and pesticides (kgs) use at th household level by gender of plot decision-maker. 
- **OUTPUT:** 
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** 

### HOUSEHOLD'S DIET DIVERSITY SCORE
- **DESCRIPTION:** This section estimates the number of food groups (i.e., cereal, vegetables, fruits, eggs, fish, etc.,) households consumed in the past week. 
- **OUTPUT:** 
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** 

### WOMEN'S CONTROL OVER INCOME
- **DESCRIPTION:**  This section reports individual control over different types of income (crop, livestock, business, non-farm) at the individual level. 
- **OUTPUT:** 
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** 

### WOMEN'S PARTICIPATION IN AGRICULTURAL DECISION MAKING
- **DESCRIPTION:** This section reports individual participation in different agricultural activities (crop production, livestock production, or both) at the individual level. 
- **OUTPUT:** 
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** 

### WOMEN'S OWNERSHIP OF ASSETS
- **DESCRIPTION:** This section reports individual ownership of assets by type of asset (land, and livestock) at the individual level. 
- **OUTPUT:** 
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** 

### AGRICULTURAL WAGES
- **DESCRIPTION:**  This section estimates daily agricultural wage paid for hired labor by gender of worker (local currency), total hired labor (number of person days) by gender of worker at the household level. 
- **OUTPUT:** 
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** 

### CROP YIELDS
- **DESCRIPTION:** This section estimates quantity harvested, total area planted (summed accross both seasons) by gender of plot decision-maker and purestand/intercrop plots for each crop type, and whether the household harvested each specific crop in at least one season. 
- **OUTPUT:** 
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** 

### SHANNON DIVERSITY INDEX
- **DESCRIPTION:** This section reports the effective number of crop species harvested, number of crops grown by gender of plot decision-maker, and the Shannon diversity index at the household level.
- **OUTPUT:** 
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** 

### CONSUMPTION
- **DESCRIPTION:**This section estimates Total household consumption, spatially and temporally adjusted using World Bank regional and temporal deflators (in 2005-06 prices), consumption per adult equivalent, consumption per capita, daily consumption per adult equivalent and per capita spatially and temporally adjusted at the household level.
- **OUTPUT:** 
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:**
  
### FOOD SECURITY
- **DESCRIPTION:** This section estimates daily food consumption per adult equivalent and per capita (purchased consumed at home, purchased consumed away from home, own production, and gifts) at the household level.
- **OUTPUT:** 
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:**
  
### FOOD PROVISION
- **DESCRIPTION:** This section reports the number of months where the household experienced any food insecurity in the past 12 months. 
- **OUTPUT:** 
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** 

### HOUSEHOLD ASSETS 
- **DESCRIPTION:** This section reports the total value of current household assets at the household level.
- **OUTPUT:** 
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** 

### HOUSEHOLD VARIABLES
- **DESCRIPTION:** This section merges every section coded above that has been summarized at the household (HHID) level. It also performs winsorization at different levels (i.e., top 1% level, top and bottom 1% level, top and bottom 5% level) for relevant continuous variables. This section also creates final indicators such as crop yields (value of crop harvested divided by area planted), net crop revenue, net livestock income, total number of livestock lost to disease, total value of farm production, rates of fertlizer application (kgs/area planted), explicit costs per hectare, land productivity (value of production per area cultivated), labor productivity (value of production per labor-day), poverty indicators using $1.90 and the $2.5 poverty lines, among others. 
- **OUTPUT:** 
- **CODING STATUS:** ![INCOMPLETE](https://placehold.co/15x15/f03c15/f03c15.png) `INCOMPLETE`
- **KNOWN ISSUES:** 

### INDIVIDUAL VARIABLES
- **DESCRIPTION:** This section merges every section coded above that has been summarized at the individual (PID) level.
- **OUTPUT:** 
- **CODING STATUS:** ![INCOMPLETE](https://placehold.co/15x15/f03c15/f03c15.png) `INCOMPLETE`
- **KNOWN ISSUES:**

### PLOT VARIABLES
- **DESCRIPTION:** his section merges every section coded above that has been summarized at the plot (plot_id) level. It also performs winsorization at different levels (i.e., top 1% level, top and bottom 1% level, top and bottom 5% level) for relevant continuous variables. This section also creates final indicators such as value of crop harvested (at the plot level), plot productivity (value of crop production/plot area planted), plot labor productivity reported in different currencies (2017 $ Private Consumption PPP, 2017 $ GDP Consumption PPP, 2017 $ USD, 2017 $UGX), gender productivity gap, 
- **OUTPUT:** 
- **CODING STATUS:** ![INCOMPLETE](https://placehold.co/15x15/f03c15/f03c15.png) `INCOMPLETE`
- **KNOWN ISSUES:** 

### SUMMARY STATISTICS
- **DESCRIPTION:** This section uses an external Do-file "378_Uganda_Wave3_summarystats2_SAW3.17.23.do" available in the created_file folder which creates a final summary statistics excel spreadsheet using the household, individual, and plot datasets. 
- **OUTPUT:** 
- **CODING STATUS:** ![INCOMPLETE](https://placehold.co/15x15/f03c15/f03c15.png) `INCOMPLETE`
- **KNOWN ISSUES:** 
