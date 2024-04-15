# README File -  Uganda National Panel Survey 2018-2019, Wave 7

## PREREQUISITES
Download the raw data from the UNPS Wave 7 page: https://microdata.worldbank.org/index.php/catalog/3795
Put the raw DTA files in a single folder (such as the Raw DTA Files folder provided) and adjust the global Uganda_NPS_W7_raw_data in the do-file to the correct path. Adjust the Uganda_NPS_W7_created_data to the created_data folder (this will store intermediate files) and Uganda_NPS_W7_final_data (to store the final dta files).
Additional conversion factor files are provided in the created_data folder for converting nonstandard agricultural units. These files reduce spread across estimates due to differences in the conversion factors provided for the same unit by calculating the national and regional medians across all seven waves.
1. `UG_Conv_fact_sold_table.dta`
2. `UG_Conv_fact_sold_table_national.dta`
3. `UG_Conv_fact_harvest_table.dta`
4. `UG_Conv_fact_harvest_table_national.dta`

## TABLE OF CONTENTS
### GLOBALS
- **DESCRIPTION:** This section sets global variables for use later in the script, including:
  * Population
  * Population estimates from: https://databank.worldbank.org/source/world-development-indicators# 
    * NPS_W7_pop_tot- Total population in 2018 (World Bank)
    * NPS_W7_pop_rur- Rural population in 2018 (World Bank)
    * NPS_W7_pop_urb- Urban population in 2018 (World Bank)
  * Species
    * Livestock species categories: large ruminants (bovids), small ruminants (sheep, goats), pigs, equines (horses, donkeys), and poultry (including rabbits) 
  * Exchange Rates
    * Uganda_NPS_W7_exchange_rate - USD-Uganda shilling conversion Year: 2012 (Last year survey was conducted)
    * Uganda_NPS_W7_gdp_ppp_dollar - GDP-based purchasing power parity conversion, World Bank Indicator PA.NUS.PPP Year: 2017
    * Uganda_NPS_W7_cons_ppp_dollar - Private-consumption-based purchasing power parity conversion, World Bank Indicator PA.NUS.PRVT.P Year: 2017
    * Uganda_NPS_W7_inflation - inflation between 2012-2017 CPI_SURVEY_YEAR/CPI_2017 - > CPI_2012/CPI_2017
  * Poverty Thresholds
    * Uganda_NPS_W7_poverty_nbs- The updated $2.15 2017 PPP poverty line currently used by the world bank, converted to local currency
    * Uganda_NPS_W7_poverty_threshold- Calculation for World Bank's previous $1.90 (PPP) poverty threshold. This controls the indicator poverty_under_1_9; change the 1.9 to get results for a different threshold. This is based on the 2011 PPP conversion.
### Winsorization Thresholds
* We correct outliers by Winsorization - setting values above the 99th and/or below the 1st percentiles to the value of the 99th or 1st percentile. The thresholds can be adjusted here or removed by setting them to 0 and 100
### Globals of Priority Crops
* This section defines the list of crops used to report crop-specific indicators, including indicators for monocropped plots. Adjust this list to change the output.
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.
### HOUSEHOLD IDS
- **DESCRIPTION:** This dataset includes HHID as a household unique identifier, household geographic information at different levels of disaggregation (region, district, county, sub county, ea, etc.), survey weights, and a rural/urban indicator. 
- **OUTPUT:** `Uganda_NPS_W7_hhids.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.
### INDIVIDUAL IDS
- **DESCRIPTION:** This dataset includes PID as an individual unique identifier, along with demographic information for each household member (i.e., age, gender, head of household, etc.). 
- **OUTPUT:** `Uganda_NPS_W7_person_ids.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section. 
### HOUSEHOLD SIZE
- **DESCRIPTION:** This dataset includes number of household members, female-headed household, and adjusted survey weights to match urban/rural and total population. 
- **OUTPUT:** `Uganda_NPS_W7_hhsize.dta`
	      `Uganda_NPS_W7_weights.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section. 
### PLOT-CROP DECISION MAKERS
- **DESCRIPTION:** By using 1st, 2nd, and 3rd Plot Decision-makers (members of the household) we create a plot-season level gender of decision-maker indicator (i.e., male/female/mixed).
- **OUTPUT:** `Uganda_NPS_W7_plot_decision_makers.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section. 
### PLOT AREAS
- **DESCRIPTION:**  We estimate plot area size by using parcel area size and plot area planted as a percentage of total plot area planted within each parcel. Then, we impute plot area size using the following equation: Plot area size = Parcel area size *  (Plot area planted in parcel C / Total Plot area  planted in parcel C). This dataset includes plot area size, parcel size, and plot area planted. 
- **OUTPUT:** `Uganda_NPS_W7_plot_areas.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section. 
### FORMALIZED LAND RIGHTS
- **DESCRIPTION:** Indicates whether at least one household member has official documentation (i.e., certificate of title, certificate of customary ownership, certificate of occupancy) for at least one plot. (Household level unit of analysis).
- **OUTPUT:** `Uganda_NPS_W7_land_rights_hh.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section. 
### MONOCROPPED PLOTS
- **DESCRIPTION:** This section uses the priority crops to generate statistics related to plots where only a single crop was grown. These statistics include expenses, quantity and area harvested, and labor inputs. The intermediate (created_data) file is named using the abbreviations in the priority crops global. 
- **OUTPUT:** `Uganda_NPS_W7_`cn'_monocrop_hh_area.dta`, `cn' represents each priority crop
	      `Uganda_NPS_W7_inputs_`cn'.dta` , `cn' represents each priority crop
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section. 
### TROPICAL LIVESTOCK UNIT (TLU) 
- **DESCRIPTION:** This section generates coefficients to convert different types of farm animals into the standardized "tropical livestock unit," which is usually based around the weight of an animal (kilograms of meat). It also creates variables whether a household owns certain types of farm animals, both currently and over the past 12 months, and how many they own. Separate into pre-specified categories such as cattle, poultry, etc.and then converted into Tropical Livestock Units at the Household-level. 
- **OUTPUT:** `Uganda_NPS_W7_tlu_all_animals.dta`
	      `Uganda_NPS_W7_TLU_Coefficients.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section. 
### ALL PLOTS
- **DESCRIPTION:** This section uses the Price per Kilogram Methodology explained below. 
By converting quantities sold to kilograms, crops are comparable across distinct units, increasing the number of observations to calculate prices per kg for each geographic location. From a methodological standpoint, it may also be a good idea to convert to kilograms first because kilogram conversions are ostensible to kg dried/shelled crop, so we can avoid issues related to the fact that we have condition harvested but not condition sold.
It requires the use of Crop conversion factors sold/harvested indicators which might have measurement errors and uncertainty. These conversion factors are not consistent for the same crop-condition-unit or crop-condition-unit-region. To solve these inconsistencies, we have created a Standard Conversion factor (CF) table that calculated the median CF -for both sold and harvested - for each crop-unit-region using all 7 Uganda -ISA waves available. Below, you can find each step to calculate the final indicators in this section. 
1.	[standard Quantity Sold (kg)]: Convert every crop sold in quantity units into kilograms (Quantity sold kg) using the Standard Sold Conversion factor table   which calculates the median conversion factor sold for at the crop-unit regional level using all Uganda waves available.
2.	 [Standard Price per kg]: Calculate the Standard Price per kg (Sold Value $/Qty Sold (kg)) using the Total value sold ($) divided by the standard quantity sold in kilograms.
3.	[Standard Median Price per kg]: Calculate the standard Price per kg ($/kg) median values at the Crop level   everything has been converted to kilograms so distinct crop units are comparable   at different geographic locations (e.g., national, regional, county, sub-county, etc.)
4.	We assign these standard prices per kg median values to each crop that was harvested but not sold to compute the value of the crop harvested by merging the median price per kg at the crop level with at least 9 observations available for each geographic location using the most disaggregated location possible. 
5.	[Standard Quantity Harvested (kg)]: Convert every crop harvested in quantity units into kilograms (Quantity harvested kg) using the Standard Harvested Conversion factor table   which calculates the median conversion factor sold for at the crop-unit regional level using all Uganda waves available.
6.	[Standard Value Harvested {$)] We calculate the Standard Value Harvested using the standard quantity harvested (kg) and the standard median Price per kg ($/kg) [Value harvested = s.qty.harv*Price Per Kg]
This section also includes crop plantation start date (month-year), crop harvest start and end date (month-year), total time of plantation, pure stand crops (monocropped vs intercropped), and permanent crops. The unit of analysis for this dataset is at the hh-plot-crop-season level. 
- **OUTPUT:** `Uganda_NPS_W7_all_plots.dta`
- **CODING STATUS:** ![INPROGRESS](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** Conversion factors are in progress. 
### GROSS CROP REVENUE
- **DESCRIPTION:** This section uses the same Price per kilogram methodology used in the All Plots section to estimate the "Gross value of crop production, summed over main and short season" and the "Value of crops sold so far, summed over main and short season" both at the household-crop level, and at the household level. It also estimates the value of lost harvested at the household level. 
- **OUTPUT:** `Uganda_NPS_W7_hh_crop_values_production.dta`
	      `Uganda_NPS_W7_hh_crop_production.dta`
	      `Uganda_NPS_W7_crop_losses.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section. 
### CROP EXPENSES
- **DESCRIPTION:** This section includes input costs related to crop production such as labor (hired and family), pesticides, machinery/tools, inorganic/organic fertilizers, land rental, and use of seeds. These indicators are estimated at the hh-plot-season level, and later summarized at the household level for explicit costs. 
- **OUTPUT:** Uganda_NPS__W7_hh_cost_inputs
- **CODING STATUS:** ![INPROGRESS](https://placehold.co/15x15/c5f015/c5f015.png) `INPROGRESS`
- **KNOWN ISSUES:** No issues in this section. 
### LIVESTOCK INCOME
- **DESCRIPTION:** This section estimates household livestock expenses (i.e., fodder, water, vaccines, deworming, ticks, hired labor), livestock income which includes livestock products (milk, eggs, livestock sold live and slaughtered), and the value of livestock ownership. 
- **OUTPUT:** `Uganda_NPS_W7_TLU.dta`
- **CODING STATUS:** ![INPROGRESS](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No livestock income in this wave. 
### SELF-EMPLOYMENT INCOME
- **DESCRIPTION:** This section calculates the "Estimated annual net profit from self-employment over the previous 12 months'' which includes business activities that household members were involved in. The net profit is calculated using monthly revenue, monthly expenses (materials, wages, and operating), and number of months in the year that the business operated. 
- **OUTPUT:** `Uganda_NPS_W7_self_employment_income.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.
### OFF-FARM HOURS
- **DESCRIPTION:** This section estimates the Total household off-farm hours, for the past 7 days by household members. 
- **OUTPUT:** `Uganda_NPS_W7_off_farm_hours.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.
### NON-AG WAGE AND AG WAGE INCOME 
- **DESCRIPTION:** This section estimates "Annual earnings from non-agricultural and agricultural wage (both Main and Secondary Job)".
- **OUTPUT:** `Uganda_NPS_W7_wage_income.dta`
	      `Uganda_NPS_W7_agwage_income.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
### OTHER INCOME
- **DESCRIPTION:** This section estimates Other income (rental, pension, other, and remittance) over the previous 12 months at the household level.
- **OUTPUT:**  `Uganda_NPS_W7_other_income.dta`
- **CODING STATUS:** ![Not Present](https://placehold.co/15x15/c5f015/c5f015.png) `Not Present`
- **KNOWN ISSUES:** No data in this wave.
### LAND RENTAL INCOME 
- **DESCRIPTION:** This section estimates "income from renting out land over the previous 12 months" at the household level. 
- **OUTPUT:** `Uganda_NPS_W7_land_rental_income.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.
### LAND SIZE
- **DESCRIPTION:** This section estimates "Total land size in hectares, including rented in and rented out plots".
- **OUTPUT:** `Uganda_NPS_W7_land_size_total.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.
### FARM LABOR
- **DESCRIPTION:** This section estimates Total labor days (family, hired, or other) allocated to the farm at the household level. Also, this section creates a livestock keeper - at least own one livestock type - indicator at the individual level.
- **OUTPUT:** `Uganda_NPS_W7_family_hired_labor.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section. 
### VACCINE USAGE
- **DESCRIPTION:** This section is not present in the questionnaire. 
### LIVESTOCK WATER, FEEDING, AND HOUSING
- **DESCRIPTION:** This section is not present in the questionnaire
### USE OF INORGANIC FERTILIZER 
- **DESCRIPTION:** This section estimates use of inorganic fertilizer both at the household level and at the individual level -Individual farmer (plot manager) uses inorganic fertilizer.
- **OUTPUT:** `Uganda_NPS_W7_fert_use.dta`
	      `Uganda_NPS_W7_farmer_fert_use.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.
### USE OF IMPROVED SEED
- **DESCRIPTION:** This section estimates use of improved seeds by priority crop at the household level and individual level (distinct datasets). 
- **OUTPUT:** `Uganda_NPS_W7_improvedseed_use.dta`
	      `Uganda_NPS_W7_farmer_improvedseed_use.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.
### REACHED BY AG EXTENSION
- **DESCRIPTION:** This section estimates households reached by agricultural extension services by type of source (all, public, private, unspecified). 
- **OUTPUT:** `Uganda_NPS_W7_any_ext.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.
### PLOT MANAGER
- **DESCRIPTION:** This section combines the use of inorganic fertilizer and improved seeds sections into one. 
- **OUTPUT:** `Uganda_NPS_W7_farmer_fert_use.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.
### MOBILE PHONE OWNERSHIP
- **DESCRIPTION:** This section includes the total number of mobile phones owned by household members today at the household level. 
- **OUTPUT:** `Uganda_NPS_W7_mobile_own.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.
###USE OF FORMAL FINANCIAL SERVICES // needs to be checked again; mixed borrowing with use?
- **OUTPUT:** `Uganda_NPS_W7_fin_serv.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** Needs to be looked at again.
### MILK PRODUCTIVITY
- **DESCRIPTION:** This section estimates total quantity of milk per year, number of large ruminants that were milked, average months milked in the last year, and average milk production (liters) per day per milked animal by type of livestock at the household level. 
- **OUTPUT:** `Uganda_NPS_W7_milk_animals.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** The questions used in this section were framed differently across waves, therefore the indicators found in this section are not comparable across waves. 
### EGG PRODUCTIVITY
- **DESCRIPTION:** 
This section creates the number of poultry that laid eggs in the last 3 months, number of eggs that are produced per month, total number of eggs that were produced in the year, and total number of poultry owned at the household level. 
- **OUTPUT:** `Uganda_NPS_W7_eggs_animals.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** The questions used in this section were framed differently across waves, therefore the indicators found in this section are not comparable across waves. 
### CROP PRODUCTION COSTS PER HECTARE
- **DESCRIPTION:** This section shows explicit cost per hectare of area planted and total cost per hectare of area planted by gender of plot decision-makers at the household level.
- **OUTPUT:** `Uganda_NPS_W7_cropcosts.dta`
- **CODING STATUS:** ![COMPLETE](Uganda_NPS_W7_wage_income.) `COMPLETE`
- **KNOWN ISSUES:** Uganda NPS Wave 7 does not report hectares of area harvested, therefore we cannot compute crop production costs per hectare of area harvested - only area planted available. 
### RATE OF FERTILIZER APPLICATION
- **DESCRIPTION:** This section includes inorganic fertilizer (kgs), organic fertilizer (kgs), and pesticides (kgs) used at the household level by gender of plot decision-maker. 
- **OUTPUT:** `Uganda_NPS_W7_fertilizer_application.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.
### HOUSEHOLD'S DIET DIVERSITY SCORE
- **DESCRIPTION:** This section estimates the number of food groups (i.e., cereal, vegetables, fruits, eggs, fish, etc.,) households consumed in the past week. 
- **OUTPUT:** `Uganda_NPS_W7_household_diet.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.
### WOMEN'S CONTROL OVER INCOME
- **DESCRIPTION:**  This section reports individual control over different types of income (crop, livestock, business, non-farm) at the individual level. Code as 1 if a woman is listed as one of the decision-makers for at least 2 plots, crops, or livestock activities; Can report on % of women who make decisions, taking total number of women HH members as denominator. Indicator may be biased downward if some women would participate in decisions but are not listed among the first two. First append all files related to agricultural activities with income in who participate in the decision making 
- **OUTPUT:** `Uganda_NPS_W7_control_income.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.
### WOMEN'S PARTICIPATION IN AGRICULTURAL DECISION MAKING
- **DESCRIPTION:** This section reports individual participation in different agricultural activities (crop production, livestock production, or both) at the individual level. 
- **OUTPUT:** `Uganda_NPS_W7_make_ag_decision.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.
### WOMEN'S OWNERSHIP OF ASSETS
- **DESCRIPTION:** This section reports individual ownership of assets by type of asset (land, and livestock) at the individual level. 
- **OUTPUT:** Uganda_NPS_W7_ownasset.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.
### AGRICULTURAL WAGES
- **DESCRIPTION:**  This section estimates daily agricultural wage paid for hired labor by gender of worker (local currency), total hired labor (number of person days) by gender of worker at the household level. 
- **OUTPUT:** `Uganda_NPS_W7_ag_wage.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.
### CROP YIELDS
- **DESCRIPTION:** This section estimates quantity harvested, total area planted (summed across both seasons) by gender of plot decision-maker and purestand/intercrop plots for each crop type, and whether the household harvested each specific crop in at least one season. 
- **OUTPUT:** `Uganda_NPS_W7_yield_hh_crop_level.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** We are only able to report total area planted, since as explained earlier Uganda NPS Wave 7 does not report area harvested. 
### SHANNON DIVERSITY INDEX
- **DESCRIPTION:** This section reports the effective number of crop species harvested, number of crops grown by gender of plot decision-maker, and the Shannon diversity index at the household level.
- **OUTPUT:** `Uganda_NPS_W7_shannon_diversity_index.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.
### CONSUMPTION
- **DESCRIPTION:**This section estimates Total household consumption, spatially and temporally adjusted using World Bank regional and temporal deflators (in 2005-06 prices), consumption per adult equivalent, consumption per capita, daily consumption per adult equivalent and per capita spatially and temporally adjusted at the household level.
- **OUTPUT:** `Uganda_NPS_W7_consumption.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.
### FOOD SECURITY
- **DESCRIPTION:** This section estimates daily food consumption per adult equivalent and per capita (purchased consumed at home, purchased consumed away from home, own production, and gifts) at the household level.
- **OUTPUT:** `Uganda_NPS_W7_food_cons.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.
### FOOD PROVISION
- **DESCRIPTION:** This section is not present in the questionnaire.
### HOUSEHOLD ASSETS 
- **DESCRIPTION:** This section reports the total value of current household assets at the household level.
- **OUTPUT:** `Uganda_NPS_W7_hh_assets.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.
### HOUSEHOLD VARIABLES
- **DESCRIPTION:** This section merges every section coded above that has been summarized at the household (HHID) level. It also performs winsorization at different levels (i.e., top 1% level, top and bottom 1% level, top and bottom 5% level) for relevant continuous variables. This section also creates final indicators such as crop yields (value of crop harvested divided by area planted), net crop revenue, net livestock income, total number of livestock lost to disease, total value of farm production, rates of fertilizer application (kgs/area planted), explicit costs per hectare, land productivity (value of production per area cultivated), labor productivity (value of production per labor-day), poverty indicators using $1.90 and the $2.5 poverty lines, among others. 
- **OUTPUT:** `Uganda_NPS_W7_household_variables.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.
### INDIVIDUAL VARIABLES
- **DESCRIPTION:** This section merges every section coded above that has been summarized at the individual (PID) level.
- **OUTPUT:** `Uganda_NPS_W7_individual_variables.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.
### PLOT VARIABLES
- **DESCRIPTION:** This section merges every section coded above that has been summarized at the plot (plot_id) level. It also performs winsorization at different levels (i.e., top 1% level, top and bottom 1% level, top and bottom 5% level) for relevant continuous variables. This section also creates final indicators such as value of crop harvested (at the plot level), plot productivity (value of crop production/plot area planted), plot labor productivity reported in different currencies (2017 $ Private Consumption PPP, 2017 $ GDP Consumption PPP, 2017 $ USD, 2017 $UGX), gender productivity gap, 
- **OUTPUT:** `Uganda_NPS_W7_field_plot_variables.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.
### SUMMARY STATISTICS
- **DESCRIPTION:** This section uses an external Do-file "378_Uganda_Wave3_summarystats.do" available in the created_file folder which creates a final summary statistics excel spreadsheet using the household, individual, and plot datasets. 
- **OUTPUT:** `Uganda_NPS_W7_field_plot_variables.dta`
- **CODING STATUS:** UNSURE? Didn't see in dofile 
- **KNOWN ISSUES:** No issues in this section.
