# 335_Agricultural-Indicator-Curation

This repository includes Stata do.files developed by the Evans School Policy Analysis & Research Group (EPAR) for the construction of a set of agricultural development indicators using data from the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture (LSMS-ISA) surveys. These files were developed as part of the EPAR Agricultural Development Indicator Curation project: https://evans.uw.edu/policy-impact/epar/research/agricultural-development-indicator-curation
		
Code is currently available for three survey instruments:

	-Ethiopia Socioeconomic Survey (ESS) Wave 3 (2015/16), Wave 2 (2013/14), and Wave 1 (2011/12) (LSMS-ISA)

	-Malawi Integrated Household Survey (IHS) Wave 3 (2016/2017) (LSMS-ISA)

	-Nigeria General Household Survey-Panel (GHS) Wave 4 (2018/19), Wave 3 (2015/16), Wave 2 (2012/13), and Wave 1 (2010/11) (LSMS-ISA)

	-Tanzania National Panel Survey (NPS) Wave 4 (2014/15), Wave 3 (2012/13), Wave 2 (2010/11), and Wave 1 (2008/09) (LSMS-ISA)	
	
	-Uganda National Panel Survey (UNPS) Wave 8 (2019/2020), Wave 5 (2015/16), and Wave 3 (2011/12) (LSMS-ISA)
		
If you use or modify our code, please cite us using the provided citation.
		
This repository includes a separate folder for each country. Each of these folders includes master Stata .do files with all of the code used to generate the final set of indicators from the raw survey data for a given survey wave. See the USER GUIDE file in this repository for guidance on how to download the files in this repository and raw data available from the World Bank in order to run the .do files. 

Each .do file takes as inputs the raw data files organized according to how the data from the World Bank LSMS-ISA team are organized. The .do files process the raw data and store created data sets in the folder "Final DTA files". Three final data sets are created at the household, individual, and plot levels with labelled variables, which can be used to estimate sumary statistics for the indicators and for a variety of intermediate variables. At the end of the .do file, a set of commands outputs summary statistics restricted to rural households only to an excel file also in the folder "Final DTA files". The code for generating summary statistics may be modified as needed, or users may conduct analyses directly from the final created datasets. We include the three final datasets and spreadsheet of gender-disaggregated summary statistics in the repository, under the "Final DTA files" folders. 		
		
We also have prepared a document outlining the general construction decisions for each indicator across survey instruments, which are reflected in the coding of the .do files. We have attempted to follow the same construction approach across instruments, but note any situations where differences in the instruments made this impossible. The document includes coding decisions for all included waves in Ethiopia ESS, Nigeria GHS, and Tanzania NPS, as well as for four surveys that are not yet publicly available: the Ethiopia Agricultural Commercialization Cluster (ACC) Survey (2016), the India Rice Monitoring Survey (RMS) (2016), the Tanzania Baseline Survey (TBS) (2016), and the Nigeria Baseline and Varietal Monitoring (NIBAS) Survey (2017). We have compiled a set of summary statistics for the final indicators restricted to rural households only in an excel spreadsheet for these five instruments, available on the EPAR website: https://evans.uw.edu/policy-impact/epar/research/agricultural-development-indicator-curation. The do files available in this repository may not reflect the estimates published in the excel spreadsheet as they may be updated at different times. 

A final document outlines general principles and considerations for contructing agricultural development indicators.
