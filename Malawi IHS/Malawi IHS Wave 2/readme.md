# Malawi IHPS/LSMS-ISA Wave 2 (2011-2013)

**Coding Status:** Work in Progress

## Prerequisites
- Download the raw data from [World Bank Microdata](https://microdata.worldbank.org/index.php/catalog/2248).
- Extract the files to the "Raw DTA Files" folder in the cloned directory.
- Update the paths on lines 182-185 with the correct paths to the raw data and output files.

### Globals
* This section sets global variables for use later in the script, including:
  * Population
    * Malawi_IHPS_W2_pop_tot - Total population in 2013 (World Bank)
    * Malawi_IHPS_W2_pop_rur - Rural population in 2013 (World Bank)
    * Malawi_IHPS_W2_pop_rur - Urban population in 2013 (World Bank)
  * Non-GPS-Plots
    * drop_unmeas_plots - if not 0, this global will remove any plot that is not measured by GPS from the sample. Used to reduce variability in yields that results from uncertainty around farmer area estimation and nonstandard unit conversion
  * Exchange Rates
    * Malawi_IHPS_W2_exchange_rate - USD-Kwacha conversion
    * Malawi_IHPS_W2_gdp_ppp_dollar - GDP-based purchasing power parity conversion, World Bank Indicator PA.NUS.PPP
    * Malawi_IHPS_W2_cons_ppp_dollar - Private-consumption-based purchasing power parity conversion, World Bank Indicator PA.NUS.PRVT.P
    * Malawi_IHPS_W2_inflation - Ratio of 2013:2017 Malawi consumer price index (World Bank), used for calculating poverty thresholds
 
### Winsorization Thresholds
* We correct outliers by Winsorization - setting values above the 99th and/or below the 1st percentiles to the value of the 99th or 1st percentile. The thresholds can be adjusted here or removed by setting them to 0 and 100
    * wins_lower_thres 1-Threshold for winzorization at the bottom of the distribution of continous variables
    * wins_upper_thres 99-Threshold for winzorization at the top of the distribution of continous variables	  
- Output:    
  `Malawi_IHPS_W2_winsorization.dta`
- Coding Status: Complete
- Known Issues: None
					
### Globals of Priority Crops
* This section defines the list of crops used to report crop-specific indicators, including indicators for monocropped plots. Adjust this list to change the output.

### Household IDs
Simplifies household identification across data.
- Output:  
  `Malawi_IHPS_W2_hhids.dta`
- Coding Status: Complete
- Known Issues: None

### Weights
Weights data to adjust for sampling variability.
- Output:  
  `Malawi_IHPS_W2_weights.dta`
- Coding Status: Complete
- Known Issues: None

### Individual IDs
Assigns unique IDs to each individual in the dataset.
- Output:  
  `Malawi_IHPS_W2_person_ids.dta`
- Coding Status: Complete
- Known Issues: None

### Household Size
Calculates the size of each household.
- Output:  
  `Malawi_IHPS_W2_hhsize.dta`
- Coding Status: Complete
- Known Issues: None

### Plot Areas
Calculates areas of agricultural plots.
- Output:  
  `Malawi_IHPS_W2_plot_areas.dta`
- Coding Status: Complete
- Known Issues: None

### GPS Coordinates
Stores GPS coordinates for household locations.
- Output:  
  `Malawi_IHPS_W2_hh_coords.dta`
- Coding Status: Complete
- Known Issues: None

### Plot Decision Makers
Identifies decision makers for each plot.
- Output:  
  `Malawi_IHPS_W2_plot_decision_makers.dta`
- Coding Status: Incomplete
- Known Issues: Revision in progress to account for missing values

### Formalized Land Rights
Tracks formal land rights and titles.
- Output:  
  `Malawi_IHPS_W2_land_rights.dta`
- Coding Status: Complete
- Known Issues: None

### Crop Unit Conversion Factors
Provides conversion factors for nonstandard crop units.
- Output:  
  `Malawi_IHPS_W2_cf.dta`
- Coding Status: Pending Review
- Known Issues: Working in progress to fill in missing values

### All Plots
Compiles data across all agricultural plots.
- Output:  
  `Malawi_IHPS_W2_all_plots.dta`
- Coding Status: Pending Review
- Known Issues: Relies on conversion factor which is under review.

### Crop Expenses
Details expenses related to crop production.
- Output:  
  `Malawi_IHPS_W2_plot_cost_inputs_long.dta`
- Coding Status: Incomplete
- Known Issues: Some input categories have missing values.

### Monocropped Plots
Focuses on monocropped plot data.
- Output:  
  Multiple `Malawi_IHPS_W2_inputs_`cn'.dta` files where `cn` refers to various crops.
- Coding Status: Incomplete
- Known Issues: Relies on Plot-decision makers that is currently under review.

### TLU (Tropical Livestock Units)
Converts all livestock counts to standard TLU.
- Output:  
  `Malawi_IHPS_W2_TLU_Coefficients.dta`
- Coding Status: Pending Review
- Known Issues: None

### Gross Crop Revenue
Calculates the total revenue from crop sales.
- Output:  
  `Malawi_IHPS_W2_cropsales_value.dta`
- Coding Status: Pending Review
- Known Issues: None

### Livestock Income
Quantifies income from livestock sales.
- Output:  
  `Malawi_IHPS_W2_livestock_income.dta`
- Coding Status: Pending Review
- Known Issues: None

### Fish Income
Accounts for income from fishing activities.
- Output:  
  `Malawi_IHPS_W2_fish_income.dta`
- Coding Status: Pending Review
- Known Issues: None

### Self-Employment Income
Tracks income from self-employed businesses.
- Output:  
  `Malawi_IHPS_W2_self_employment_income.dta`
- Coding Status: Pending Review
- Known Issues: None

### Non-Ag Wage Income
Records wage income from non-agricultural jobs.
- Output:  
  `Malawi_IHPS_W2_wage_income.dta`
- Coding Status: Pending Review
- Known Issues: None

### Ag Wage Income
Details income from agricultural labor.
- Output:  
  `Malawi_IHPS_W2_agwage_income.dta`
- Coding Status: Pending Review
- Known Issues: None

### Other Income
Includes other forms of income like rent and pensions.
- Output:  
  `Malawi_IHPS_W2_other_income.dta`
- Coding Status: Pending Review
- Known Issues: None

### Off-Farm Hours
Records time spent on non-farm income-generating activities.
- Output:  
  `Malawi_IHPS_W2_off_farm_hours.dta`
- Coding Status: Pending Review
- Known Issues: None

### Farm / Land Size
Measures total land owned and cultivated.
- Output:  
  `Malawi_IHPS_W2_land_size_total.dta`
- Coding Status: Pending Review
- Known Issues: None

### Farm Labor
Documents labor used on farms, distinguishing between family and hired labor.
- Output:  
  `Malawi_IHPS_W2_family_hired_labor.dta`
- Coding Status: Pending Review
- Known Issues: None

### Vaccine Usage
Tracks vaccination rates among livestock.
- Output:  
  `Malawi_IHPS_W2_vaccine_usage.dta`
- Coding Status: Pending Review
- Known Issues: None

### Animal Health - Diseases
Reports incidence of major livestock diseases.
- Output:  
  `Malawi_IHPS_W2_animal_health.dta`
- Coding Status: Pending Review
- Known Issues: None

### Plot Managers
Identifies individuals managing agricultural plots.
- Output:  
  `Malawi_IHPS_W2_plot_managers.dta`
- Coding Status: Pending Review
- Known Issues: Input data discrepancies.

### Reached by Ag Extension
Details agricultural extension services received.
- Output:  
  `Malawi_IHPS_W2_ag_extension.dta`
- Coding Status: Pending Review
- Known Issues: None

### Mobile Phone Ownership
Surveys mobile phone ownership among households.
- Output:  
  `Malawi_IHPS_W2_mobile_ownership.dta`
- Coding Status: Pending Review
- Known Issues: None

### Use of Formal Financial Services
Evaluates engagement with formal financial services.
- Output:  
  `Malawi_IHPS_W2_financial_services.dta`
- Coding Status: Pending Review
- Known Issues: None

### Milk Productivity
Assesses milk production levels.
- Output:  
  `Malawi_IHPS_W2_milk_productivity.dta`
- Coding Status: Pending Review
- Known Issues: None

### Egg Productivity
Measures egg production.
- Output:  
  `Malawi_IHPS_W2_egg_productivity.dta`
- Coding Status: Pending Review
- Known Issues: None

### Household's Diet Diversity Score
Calculates diversity of food items consumed by households.
- Output:  
  `Malawi_IHPS_W2_diet_diversity.dta`
- Coding Status: Pending Review
- Known Issues: None

### Women's Control Over Income
Assesses women's control over household income and financial decisions.
- Output:  
  `Malawi_IHPS_W2_women_income_control.dta`
- Coding Status: Pending Review
- Known Issues: None

### Women's Participation in Agricultural Decisionmaking
Documents the extent of women's involvement in agricultural decision-making.
- Output:  
  `Malawi_IHPS_W2_women_ag_decisions.dta`
- Coding Status: Incomplete
- Known Issues: None

### Women's Ownership of Assets
Tracks asset ownership among women.
- Output:  
  `Malawi_IHPS_W2_women_asset_ownership.dta`
- Coding Status: Complete
- Known Issues: None

### Agricultural Wages
See Farm Labor
- Output:  
  `Malawi_IHPS_W2_ag_wage.dta`
- Coding Status: Pending Review
- Known Issues: None

### Crop Yields
Analyzes yield data across different crops.
- Output:  
  `Malawi_IHPS_W2_crop_yields.dta`
- Coding Status: Incomplete
- Known Issues: None

### Consumption
Monitors household consumption patterns.
- Output:  
  `Malawi_IHPS_W2_consumption.dta`
- Coding Status: Complete
- Known Issues: None

### Household Food Provision
Calculates months that the household experienced food insecurity.
- Output:  
  `Malawi_IHPS_W2_food_security.dta`
- Coding Status: Complete
- Known Issues: None

### Household Assets
Reports the value of assets owned by households.
- Output:  
  `Malawi_IHPS_W2_hh_assets.dta`
- Coding Status: Complete
- Known Issues: None

