# Uganda National Panel Survey (2015-2016) Wave 5 
CODING STATUS: Fully completed, still under active review and expansion

## PREREQUESITES
* Download the raw data from https://microdata.worldbank.org/index.php/catalog/3557
* Extract the files to the "Raw DTA Files" folder in the cloned directory
* The do file is structured to use the repository's directory structure and should not need to be changed if the raw data files are placed in the Raw DTA Files folder. If the desired raw data directories and output folders are located somewhere else, update the globals in the file header to reference those locations.

## TABLE OF CONTENTS
### GLOBALS
- **DESCRIPTION:** This section sets global variables for use later in the script, including:
  * Population
  * Population estimates from: https://databank.worldbank.org/source/world-development-indicators# 
    * Uganda_NPS_W5_pop_tot - Total population in 2015 (World Bank)
    * Uganda_NPS_W5_pop_rur - Rural population in 2015 (World Bank)
    * Uganda_NPS_W5_pop_urb - Urban population in 2015 (World Bank)
  * Species
    * Livestock species categories: large ruminants (bovids), small ruminants (sheep, goats), pigs, equines (horses, donkeys), and poultry (including rabbits) 
  * Exchange Rates
Uganda_NPS_W5_exchange_rate: Exchange rate to USD from the second survey year.
Uganda_NPS_W5_gdp_ppp_dollar: Puchasing power parity conversion using GDP, from https://data.worldbank.org/indicator/PA.NUS.PPP
Uganda_NPS_W5_cons_ppp_dollar: Purchasing power parity conversion using private consumption, from https://data.worldbank.org/indicator/PA.NUS.PRVT.PP
Uganda_NPS_W5_inflation: Inflation conversion factor taken as the ratio of the CPI from the second survey year to the CPI from 2017, the current base year, from https://data.worldbank.org/indicator/FP.CPI.TOTL
Uganda_NPS_W5_poverty_190: The poverty threshold in local currency using the old World Bank $1.90 in 2011 PPP threshold.
Uganda_NPS_W5_poverty_npl: The poverty threshold in local currency using the national poverty line, literature citation to source in do file.
Uganda_NPS_W5_poverty_215: The poverty threshold in local currency using the new World Bank $2.15 in 2017 PPP threshold

### Winsorization Thresholds
* We correct outliers by Winsorization - setting values above the 99th and/or below the 1st percentiles to the value of the 99th or 1st percentile. The thresholds can be adjusted here or removed by setting them to 0 and 100

### Globals of Priority Crops
* This section defines the list of crops used to report crop-specific indicators, including indicators for monocropped plots. Adjust this list to change the output.
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.

### HOUSEHOLD IDS
- **DESCRIPTION:** This dataset includes HHID as a household unique identifier, household geographic information at different levels of dissaggregation (region, district, county, subcounty, ea, etc.), survey weights, and a rural/urban indicator. 
- **OUTPUT:** Uganda_NPS_W5_hhids.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** This section uses the panel weight rather than the crossectional weight which is only in gsec1. Accordingly the variable is named 'pweight'

### INDIVIDUAL IDS
- **DESCRIPTION:** This dataset includes indiv as individual unique identifier, along with demographic information for each household member (i.e., age, gender, head of household, etc.). 
- **OUTPUT:** Uganda_NPS_W5_person_ids.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section. 

### HOUSEHOLD SIZE
- **DESCRIPTION:** This dataset includes number of household members, female-headed households, and adjusted survey weights to match urban/rural and total population. This section also re-scales weights to match population estimates above and resaves Uganda_NPS_W5_weights.dta. 
- **OUTPUT:** Uganda_NPS_W5_hhsize.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section. 

### PLOT AREAS
- **DESCRIPTION:**  We estimate plot area size by using parcel area size and plot area planted as a percentage of total plot area planted within each parcel. Then, we impute plot area size using the following equation: Plot area size = Parcel area size *  (Plot area planted in parcel C / Total Plot area  planted in parcel C). This dataset includes plot area size, parcel size, and plot area planted. 
- **OUTPUT:** Uganda_NPS_W5_plot_areas.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section. 

### PLOT-CROP DECISION MAKERS
- **DESCRIPTION:** By using 1st, 2nd, and 3rd Plot Decision-makers (members of the household) we create a plot-season level gender of decision-maker indicator (i.e., male/female/mixed).
- **OUTPUT:** Uganda_NPS_W5_plot_decision_makers.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.

### FORMALIZED LAND RIGHTS
- **DESCRIPTION:** Indicates whether at least one household member has official documentation (i.e., certificate of title, certificate of customary ownership, certificate of occupancy) for at least one plot. (Household level unit of analysis).
- **OUTPUT:**  /Uganda_NPS_W5_land_rights_hh.dta
	       /Uganda_NPS_W5_land_rights_ind.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.  

### ALL PLOTS
- **DESCRIPTION:** This section uses the Price per Kilogram Methodology explained below. 
By converting quantities sold to kilograms, crops are comparable across distinct units, increasing the number of observations to calculate prices per kg for each geographic location. From a methodological standpoint, it may also be a good idea to convert to kilograms first because kilogram conversions are ostensible to kg dried/shelled crop, so we can avoid issues related to the fact that we have condition harvested but not condition sold.
Although conversion factors are provided within the raw dta files themselves, the factors are not the same crop-condition-unit or crop-condition-unit-region both within and across waves. To reduce these inconsistencies, we have created a Standard Conversion factor (CF) table that calculated the median CF - for both sold and harvested - for each crop-unit-region using all 7 Uganda LSMS-ISA waves available. The exact methodology is included in Uganda UNPS/Master_Conversionfactor_table.do and the output files are listed below:
1. `UG_Conv_fact_sold_table.dta`: Regional-level table for conversion factors derived from crops sold
2. `UG_Conv_fact_sold_table_national.dta`: National-level table for conversion factors derived from crops sold
3. `UG_Conv_fact_harvest_table.dta`: Regional-level table for conversion factors derived from crops harvested
4. `UG_Conv_fact_harvest_table_national.dta`: National-level table for conversion factors derived from crops harvested.
The steps to calculate the final indicators in this section are as follows: 
1.	[standard Quantity Sold (kg)]: Convert every crop sold in quantity units into kilograms (Quantity sold kg) using the Standard Sold Conversion factor table – which calculates the median conversion factor sold for at the crop-unit regional level using all Uganda waves available.
2.	[Standard Price per kg]: Calculate the Standard Price per kg (Sold Value $/Qty Sold (kg)) using the Total value sold ($) divided by the standard quantity sold in kilograms.
3.	[Standard Median Price per kg]: Calculate the standard Price per kg ($/kg) median values at the Crop level – everything has been converted to kilograms so distinct crop units are comparable – at different geographic locations (e.g., national, regional, county, sub-county, etc.)
4.	We assign these standard prices per kg median values to each crop that was harvested but not sold to compute the value of the crop harvested by merging the median price per kg at the crop level with at least 9 observations available for each geographic location using the most disaggregated location possible. 
5.	[Standard Quantity Harvested (kg)]: Convert every crop harvested in quantity units into kilograms (Quantity harvested kg) using the Standard Harvested Conversion factor table – which calculates the median conversion factor sold for at the crop-unit regional level using all Uganda waves available.
6.	[Standard Value Harvested ($)] We calculate the Standard Value Harvested using the standard quantity harvested (kg) and the standard median Price per kg ($/kg) [Value harvested = s.qty.harv*Price Per Kg]
This section also includes crop plantation start date (month-year), crop harvest start and end date (month-year), total time of plantation, pure stand crops (monocropped vs intercropped), and permanent crops. The unit of analysis for this dataset is at the hh-plot-crop-season level.
7. 	[Area Planted (ha)]: Derived from proportion of plot area planted and rescaled so that the total planted area does not exceed the estimated plot area.
8. 	[Area Harvested (ha)]: Equivalent to area planted because the questionnaire does not include questions regarding the area harvested; included here for compatibility with indicators from other countries.
- **OUTPUT:** 	/Uganda_NPS_W5_all_plots.dta
		/Uganda_NPS_W5_crop_value.dta
		/Uganda_NPS_W5_plot_areas.dta
		/Uganda_NPS_W5_crop_prices_for_wages.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** Sold values are inaccurate in W5, on average much lower than they should be for the country. Because of this, sold values are added to empty variables and generated as missing.

### GROSS CROP REVENUE
- **DESCRIPTION:** This section uses the same price per kilogram methodology used in the All Plots section to estimate the "Gross value of crop production, summed over main and short season" and the "Value of crops sold so far, summed over main and short season" both at the household-crop level, and at the household level. It also estimates the value of lost harvested at the household level. 
- **OUTPUT:** /Uganda_NPS_W5_cropsales_value.dta
	      /Uganda_NPS_W5_hh_crop_values_production.dta
	      /Uganda_NPS_W5_hh_crop_production.dta
              /Uganda_NPS_W5_crop_losses.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section. 

### CROP EXPENSES
- **DESCRIPTION:** This section includes input costs related to crops production such as labor (hired and family), pesticides, machinery/tools, inorganic/organic fertilizers, land rental, and use of seeds. These indicators are estimated at the hh-plot-season level, and later summarized at the household level for explicit costs. 
- **OUTPUT:**	/Uganda_NPS_W5_plot_labor_days.dta
		/Uganda_NPS_W5_plot_labor.dta
		/Uganda_NPS_W5_hh_cost_labor.dta
		/Uganda_NPS_W5_plot_rental.dta
		/Uganda_NPS_W5_input_quantities.dta
		/Uganda_NPS_W5_plot_cost_inputs.dta
		/Uganda_NPS_W5_plot_cost_inputs_wide.dta
		/Uganda_NPS_W5_hh_cost_inputs_verbose.dta
		/Uganda_NPS_W5_hh_cost_inputs.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.
### MONOCROPPED PLOTS
- **DESCRIPTION:** Generate crop-level .dta files to be able to quickly look up data about households that grow specific, priority crops on monocropped plots. This dataset shows at the crop-level indicators such as quantity harvested (kg), and value of harvest dissagreggated by gender of plot decision-makers, and for each priority crop. It also creates the sum of all cost at the household level for priority crops (pure stand only) dissagregated by gender of plot decision-makers.
- **OUTPUT:** Uganda_NPS_W5_`cn'_monocrop_hh_area.dta, `cn' represents each priority crop
	      Uganda_NPS_W5_inputs_`cn'.dta, `cn' represents each priority crop
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.  

### TROPICAL LIVESTOCK UNIT (TLU) 
- **DESCRIPTION:** This section generate coefficients to convert different types of farm animals into the standardized "tropical livestock unit," which is usually based around the weight of an animal (kilograms of meat). It also creates variables whether a household owns certain types of farm animals, both currently and over the past 12 months, and how many they own. Separate into pre-specified categories such as cattle, poultry, etc.and then converted into Tropical Livestock Units at the Household-level. 
- **OUTPUT:**	/tlu_livestock.dta
		/tlu_small_animals.dta
		/Uganda_NPS_W5_tlu_all_animals.dta
		/Uganda_NPS_W5_TLU_Coefficients.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section. 

### LIVESTOCK INCOME
- **DESCRIPTION:** This section estimates household livestock expenses (i.e., fodder, water, vaccines, deworming, ticks, hired labor), livestock income which includes livestock products (milk, eggs, livestock sold live and slaughtered), and the value of livestock ownership. 
- **OUTPUT:**   /Uganda_NPS_W5_livestock_expenses_long.dta
                /Uganda_NPS_W5_livestock_products_milk.dta
                /Uganda_NPS_W5_livestock_products_other.dta
		/Uganda_NPS_W5_livestock_products_prices_country.dta  		
		/Uganda_NPS_W5_livestock_products.dta
  		/Uganda_NPS_W5_hh_livestock_sales.dta
  		/Uganda_NPS_W5_livestock_sales.dta
  		/Uganda_NPS_W5_TLU.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.

### FISH INCOME
- **KNOWN ISSUES:** No fish income data in this wave so nothing generated.

### SELF-EMPLOYMENT INCOME
- **DESCRIPTION:** This section calculates the "Estimated annual net profit from self-employment over previous 12 months" which include business activities that household members were involved. The net profit is calculates using monthly revenue, monthly expenses (materials, wages, and operating), and number of months in the year that the business operated. 
- **OUTPUT:** Uganda_NPS_W5_self_employment_income.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.

### OFF-FARM HOURS
- **DESCRIPTION:** This section estimates the Total household off-farm hours, for the past 7 days by household members. 
- **OUTPUT:** /Uganda_NPS_W5_off_farm_hours.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.

### NON-AG WAGE AND AG WAGE INCOME 
- **DESCRIPTION:** This section estimates "Annual earnings from non-agricultural and agricultural wage (both Main and Secondary Job)".
- **OUTPUT:** /Uganda_NPS_W5_wage_income.dta
	      /Uganda_NPS_W5_agwage_income.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section. 

### OTHER INCOME
- **DESCRIPTION:** This section estimates Other income (rental, pension, other, and remittance) over previous 12 months at the household level.
- **OUTPUT:**  /Uganda_NPS_W5_other_income.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.

### LAND RENTAL INCOME 
- **DESCRIPTION:** This section estimates "income from renting out land over previous 12 months" at the household level. 
- **OUTPUT:** /Uganda_NPS_W5_land_rental_income.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.

### LAND SIZE
- **DESCRIPTION:** This section estimates "Total land size in hectares, including rented in and rented out plots".
- **OUTPUT:**	/Uganda_NPS_W5_land_size_total.dta
		/Uganda_NPS_W5_parcels_cultivated.dta
		/Uganda_NPS_W5_land_size.dta
		/Uganda_NPS_W5_parcels_agland.dta
		/Uganda_NPS_W5_farmsize_all_agland.dta
		/Uganda_NPS_W5_parcels_held.dta
		/Uganda_NPS_W5_land_size_all.dta
		/Uganda_NPS_W5_land_size_total.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.

### FARM LABOR
- **DESCRIPTION:** This section estimates Total labor days (family, hired, or other) allocated to the farm at the household level. Also, this section creates a livestock keeper - at least own one livestock type - indicator at the individual level.
- **OUTPUT:**	/Uganda_NPS_W5_family_hired_labor.dta
		/Uganda_NPS_W5_plot_family_hired_labor.dta
		/Uganda_NPS_W5_plot_farmlabor_shortseason.dta
		/Uganda_NPS_W5_plot_farmlabor_mainseason.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section. 

### VACCINE USAGE
- **DESCRIPTION:** This section estimates livestock vaccination by type of livestock (i.e., large ruminants, small ruminants, poultry, pigs) at the household level. 
- **OUTPUT:** /Uganda_NPS_W5_vaccine.dta
	      /Uganda_NPS_W5_farmer_vaccine.dta

### ANIMAL HEALTH - DISEASES  
- **KNOWN ISSUES:** No animal health data in this wave so nothing generated.
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.

### LIVESTOCK WATER, FEEDING, AND HOUSING
- **DESCRIPTION:** This section reports water livestock source (natural, constructed, covered) by livestock type at the household level. 
- **OUTPUT:** /Uganda_NPS_W5_livestock_feed_water_house.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.

### USE OF INORGANIC FERTILIZER 
- **DESCRIPTION:** This section estimates use of inorganic fertilizer both at the household level and at the individual level -Individual farmer (plot manager) uses inorganic fertilizer. In the Uganda LSMS waves, fertilizer use is recorded as separate categories for Nitrate (N), Phosphate (P), Potash (K), and Mixed fertilizers, without further details on specific fertilizer types or nutrient content. Unlike other LSMS surveys, where specific fertilizers such as DAP or Urea are reported, the Uganda dataset only provides total quantities (kg or liters) under these broad categories. Because the raw data does not include guaranteed analysis or brand-specific information, we are unable to adjust for nutrient content as done in other LSMS waves. For units, since no additional details are available on density or concentration, liter-based entries are treated as kg on a one-to-one basis in the calculations. As a result, this section constructs n_kg, p_kg, and k_kg based on the reported quantities without additional conversion factors. Users who have external knowledge of the specific fertilizer composition in use may apply their own adjustments as needed.
- **OUTPUT:** /Uganda_NPS_W5_fert_use.dta
	      /Uganda_NPS_W5_farmer_fert_use.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.

### USE OF IMPROVED SEED
- **DESCRIPTION:** This section estimates use of improved seeds by priority crop at the household level and individual level (distinct datasets). 
- **OUTPUT:**	/Uganda_NPS_W5_farmer_improvedseed_use_temp.dta
		/Uganda_NPS_W5_improvedseed_use.dta
		/Uganda_NPS_W5_farmer_improvedseed_use.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.

### PLOT MANAGER
- **DESCRIPTION:** This section combines the use of inorganic fertilizer and improved seeds sections into one. 
- **OUTPUT:**	/Uganda_NPS_W5_farmer_fert_use.dta
		/Uganda_NPS_W5_imprvseed_crop.dta
		/Uganda_NPS_W5_farmer_improvedseed_use.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.

### REACHED BY AG EXTENSION
- **DESCRIPTION:** This section estimates households reached by agricultural extension services by type of source (all, public, private, unspecified). 
- **OUTPUT:** /Uganda_NPS_W5_any_ext.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.

### MOBILE PHONE OWNERSHIP
- **DESCRIPTION:** This section includes the total number of mobile phones owned by household members today at the household level. 
- **OUTPUT:** /Uganda_NPS_W5_mobile_own.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.

### MILK PRODUCTIVITY
- **DESCRIPTION:** This section estimates total quantity of milk per year, number of large ruminants that were milked, average months milked in last year, and average milk production (liters) per day per milked animal by type of livestock at the household level. 
- **OUTPUT:** /Uganda_NPS_W5_milk_animals.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** The questions used in this section were framed differently across waves, therefore the indicators found in this section are not comparable across waves. 

### EGG PRODUCTIVITY
- **DESCRIPTION:** This section creates the number of poultry that laid eggs in the last 3 months, number of eggs that wre produced per month, total number of eggs that were produced in the year, and total number of poultry ownned at the household level. 
- **OUTPUT:** /Uganda_NPS_W5_eggs_animals.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** The questions used in this section were framed differently across waves, therefore the indicators found in this section are not comparable across waves. 

### CROP PRODUCTION COSTS PER HECTARE
- **DESCRIPTION:** This section shows explicit cost per hectare of area planted and total cost per hectare of area planted by gender of plot decision-makers at the household level.
- **OUTPUT:** /Uganda_NPS_W5_cropcosts.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** Uganda NPS Wave 5 does not report hectares of area harvested, therefore we cannot compute crop production costs per hectare of area harvested - only area planted available. 

### RATE OF FERTILIZER APPLICATION
- **DESCRIPTION:** This section includes inorganic fertilizer (kgs), organic fertilizer (kgs), and pesticides (kgs) use at the household level by gender of plot decision-maker. 
- **OUTPUT:** /Uganda_NPS_W5_fertilizer_application.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.

### WOMEN'S DIET QUALITY
- **KNOWN ISSUES:** No women's diet data in this wave so nothing generated.

### HOUSEHOLD'S DIET DIVERSITY SCORE
- **DESCRIPTION:** This section reports a count of food groups (out of 12) the surveyed individual consumed last week, and whether or not a household consumed at least 6 of the 12 food groups, or 8 of the 12 food groups. The Food Consumption Score (FCS) was calculated by summing the frequency of consumption of different food groups over the past 7 days, each weighted according to its nutritional value. The Reduced Coping Strategies Index (rCSI) was not calculated for the Uganda field survey, as the available data did not allow for a consistent construction of the indicator. 
- **OUTPUT:** /Uganda_NPS_W5_household_diet.dta
			 /Uganda_NPS_W5_fcs.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.

### WOMEN'S CONTROL OVER INCOME
- **DESCRIPTION:**  This section reports individual control over different types of income (crop, livestock, business, non-farm) at the individual level. 
- **OUTPUT:** /Uganda_NPS_W5_control_income.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.

### WOMEN'S PARTICIPATION IN AGRICULTURAL DECISION MAKING
- **DESCRIPTION:** This section reports individual participation in different agricultural activities (crop production, livestock production, or both) at the individual level. 
- **OUTPUT:** /Uganda_NPS_W5_make_ag_decision.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.

### WOMEN'S OWNERSHIP OF ASSETS
- **DESCRIPTION:** This section reports individual ownership of assets by type of asset (land, and livestock) at the individual level. 
- **OUTPUT:** /Uganda_NPS_W5_ownasset.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.

### AGRICULTURAL WAGES
- **DESCRIPTION:**  This section estimates daily agricultural wage paid for hired labor by gender of worker (local currency), total hired labor (number of person days) by gender of worker at the household level. 
- **OUTPUT:** /Uganda_NPS_W5_ag_wage.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.

### CROP YIELDS
- **DESCRIPTION:** This section estimates quantity harvested, total area planted (summed accross both seasons) by gender of plot decision-maker and purestand/intercrop plots for each crop type, and whether the household harvested each specific crop in at least one season. 
- **OUTPUT:**	/Uganda_NPS_W5_yield_hh_crop_level.dta
		/Uganda_NPS_W5_hh_crop_values_production_grouped.dta
		/Uganda_NPS_W5_hh_crop_values_production_type_crop.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** We are only able to report total area planted, since as explained earlier Uganda NPS Wave 5 does not report area harvested. 

### SHANNON DIVERSITY INDEX
- **DESCRIPTION:** This section reports the effective number of crop species harvested, number of crops grown by gender of plot decision-maker, and the Shannon diversity index at the household level.
- **OUTPUT:**	/Uganda_NPS_W5_hh_crop_area_plan_shannon.dta
		/Uganda_NPS_W5_shannon_diversity_index.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.

### CONSUMPTION
- **DESCRIPTION:** This section uses estimated total household consumption and household food consumption, both of which are spatially and temporally adjusted to 2005-06 prices in the raw data to estimate daily consumption per adult equivalent and per capita in 2010 values. We then calculate three poverty headcount estimates based on daily per capita consumption and using the $1.90, national poverty line, and $2.15 thresholds. Because we calculate poverty rate estimates using the daily per capita estimate, as opposed to monthly per-household as provided in the raw data, our poverty line calculations will differ from the estimate provided in the raw data.
- **OUTPUT:**	/Uganda_NPS_W5_consumption.dta
		/Uganda_NPS_W5_hh_adulteq.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.

### FOOD SECURITY
- **DESCRIPTION:** This section estimates daily food consumption per adult equivalent and per capita (purchased consumed at home, purchased consumed away from home, own production, and gifts) at the household level.
- **OUTPUT:** /Uganda_NPS_W5_food_cons.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.

### FOOD PROVISION
- **DESCRIPTION:** This section reports the number of months where the household experienced any food insecurity in the past 12 months. 
- **OUTPUT:** /Uganda_NPS_W5_food_insecurity.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.

### HOUSEHOLD ASSETS 
- **DESCRIPTION:** This section reports the total value of current household assets at the household level.
- **OUTPUT:** /Uganda_NPS_W5_hh_assets.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.

### DISTANCE TO AGRO DEALERS
 - **KNOWN ISSUES:** No distance to agro dealers data in this wave so nothing generated.

### HOUSEHOLD VARIABLES
- **DESCRIPTION:** This section merges every section coded above that has been summarized at the household (HHID) level. It also performs winsorization at different levels (i.e., top 1% level, top and bottom 1% level, top and bottom 5% level) for relevant continuous variables. This section also creates final indicators such as crop yields (value of crop harvested divided by area planted), net crop revenue, net livestock income, total number of livestock lost to disease, total value of farm production, rates of fertlizer application (kgs/area planted), explicit costs per hectare, land productivity (value of production per area cultivated), labor productivity (value of production per labor-day), poverty indicators using $1.90 and the $2.5 poverty lines, among others. 
- **OUTPUT:** /Uganda_NPS_W5_household_variables.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.

### INDIVIDUAL VARIABLES
- **DESCRIPTION:** This section merges every section coded above that has been summarized at the individual (PID) level.
- **OUTPUT:** /Uganda_NPS_W5_individual_variables.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.

### PLOT VARIABLES
- **DESCRIPTION:** his section merges every section coded above that has been summarized at the plot (plot_id) level. It also performs winsorization at different levels (i.e., top 1% level, top and bottom 1% level, top and bottom 5% level) for relevant continuous variables. This section also creates final indicators such as value of crop harvested (at the plot level), plot productivity (value of crop production/plot area planted), plot labor productivity reported in different currencies (2017 $ Private Consumption PPP, 2017 $ GDP Consumption PPP, 2017 $ USD, 2017 $UGX), gender productivity gap, 
- **OUTPUT:** /Uganda_NPS_W5_field_plot_variables.dta
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.

### SUMMARY STATISTICS
- **DESCRIPTION:** This section uses an second do-file located in the "_Summary Statistics" folder to create a final summary statistics excel spreadsheet using the household, individual, and plot datasets. The estimates here should be the same as those presented in the data dissemination repository, https://github.com/EvansSchoolPolicyAnalysisAndResearch/LSMS-Data-Dissemination/, for the benchmark commit listed. 
- **OUTPUT:** `Uganda_NPS_W5_summary_stats.xlsx`, `Uganda_NPS_W5_summary_stats_with_labels.dta`
- **CODING STATUS:** ![COMPLETE](https://placehold.co/15x15/c5f015/c5f015.png) `COMPLETE`
- **KNOWN ISSUES:** No issues in this section.

