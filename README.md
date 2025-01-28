# EPAR LSMS Agricultural Indicator Data Curation

This repository includes Stata do.files developed by the Evans School Policy Analysis & Research Group (EPAR) for the construction of a set of agricultural development indicators using data from the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture (LSMS-ISA) surveys and produced in partnership with the host countries' national statistics bureaus. These files were developed as part of the [EPAR Agricultural Development Indicator Curation project](https://epar.evans.uw.edu/agricultural-development-data-curation/)
		
Code is currently available for five countries:

* Ethiopia Socioeconomic Survey (ESS):
  * Wave 5 (2021-22)
  * Wave 4 (2018/19)
  * Wave 3 (2015/16)
  * Wave 2 (2013/14)
  * Wave 1 (2011/12)

* Malawi Integrated Household Survey (IHS) and Integrated Household Panel Survey
  * Wave 4 (2018/19) (panel and cross-section)
  * Wave 3 (2016) (panel and cross-section)
  * Wave 2 (2013) (panel only)
  * Wave 1 (2010/11) (original panel and cross-section)

* Nigeria General Household Survey-Panel (GHS)
  * Wave 4 (2018/19)
  * Wave 3 (2015/16)
  * Wave 2 (2012/13)
  * Wave 1 (2010/11)
  * Wave 5 is under development

* Tanzania National Panel Survey (NPS)
  * Wave 5 (2020/21)
  * SDD Extended Panel (2019/20)
  * Wave 4 (2014/15)
  * Wave 3 (2012/13)
  * Wave 2 (2010/11)
  * Wave 1 (2008/09)

* Uganda National Panel Survey (UNPS)
  * Wave 8 (2019/20)
  * Wave 7 (2018/19)
  * Wave 5 (2015/16)
  * Wave 4 (2013/14)
  * Wave 3 (2011/12)
  * Wave 2 (2010/11)
  * Wave 1 (2009/10)
	
Refer to each wave's subfolder for documentation on the status of the code and any known issues with the raw data. 
		
If you use or modify our code, please cite us using the provided citation in the header of the do file.
		
This repository includes a separate folder for each country. Each of these folders includes master Stata .do files with all of the code used to generate the final set of indicators from the raw survey data for a given survey wave. See the USER GUIDE file in this repository for guidance on how to download the files in this repository and raw data available from the World Bank in order to run the .do files. 

Each .do file takes as inputs the raw data files organized according to how the data from the World Bank LSMS-ISA team are organized. The .do files process the raw data and store created data sets in the folder "Final DTA files". Three final data sets are created at the household, individual, and plot levels with labeled variables, which can be used to estimate sumary statistics for the indicators and for a variety of intermediate variables. At the end of the .do file, a set of commands outputs summary statistics restricted to rural households only to an excel file also in the folder "Final DTA files". The code for generating summary statistics may be modified as needed, or users may conduct analyses directly from the final created datasets. We include the three final datasets and spreadsheet of gender-disaggregated summary statistics in the repository, under the "Final DTA files" folder.	
		
We also have prepared a document outlining the general construction decisions for each indicator across survey instruments, which are reflected in the coding of the .do files. We have attempted to follow the same construction approach across instruments, but note any situations where differences in the instruments made this impossible. The document includes coding decisions for all included waves in Ethiopia ESS, Malawi IHS, Nigeria GHS, Tanzania NPS, and Uganda NPS. We have compiled a set of summary statistics for the final indicators restricted to rural households only in an Excel spreadsheet for these five instruments, available on the [EPAR website](https://epar.evans.uw.edu/agricultural-development-data-curation/) and [Data Dissemination repository](https://github.com/EvansSchoolPolicyAnalysisAndResearch/LSMS-Data-Dissemination). The do files available in this repository may not reflect the estimates published in the excel spreadsheet as the latter is updated less frequently. The reference commit for the data is given in the data repository.
