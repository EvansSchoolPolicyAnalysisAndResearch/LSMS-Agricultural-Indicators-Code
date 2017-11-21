# 335_Agricultural-Indicator-Curation

This repository includes Stata do.files developed by the Evans School Policy Analysis & Research Group (EPAR) for the construction of a set of agricultural development indicators using data from the Living Standards Measurement Study - Integrated Surveys on Agriculture (LSMS-ISA) surveys.		
		
Code is currently available for three survey instruments:

-Ethiopia Socioeconomic Survey (ESS) Wave 3, 2015/16 (LSMS-ISA)

-Nigeria General Household Survey-Panel (GHSP) Wave 3, 2015/16 (LSMS-ISA)

-Tanzania National Panel Survey (TNPS) Wave 4, 2014/15 (LSMS-ISA)		
		
Code for additional waves of survey data from each of these three countries will be added to this repository as it is available.		
		
This repository includes a separate folder for each country. Each of these folders includes master Stata .do files with all of the code used to generate the final set of indicators from the raw survey data for a given survey wave. The raw survey data files are available for download free of charge from the World Bank LSMS-ISA website from the following links:

-Ethiopia: http://econ.worldbank.org/WBSITE/EXTERNAL/EXTDEC/EXTRESEARCH/EXTLSMS/0,,contentMDK:23635542~pagePK:64168445~piPK:64168309~theSitePK:3358997,00.html

-Nigeria: http://econ.worldbank.org/WBSITE/EXTERNAL/EXTDEC/EXTRESEARCH/EXTLSMS/0,,contentMDK:23635560~pagePK:64168445~piPK:64168309~theSitePK:3358997,00.html

-Tanzania: http://econ.worldbank.org/WBSITE/EXTERNAL/EXTDEC/EXTRESEARCH/EXTLSMS/0,,contentMDK:23635561~pagePK:64168445~piPK:64168309~theSitePK:3358997,00.html

Each .do file takes as inputs the raw data files organized according to how the data from the World Bank LSMS-ISA team are organized. The unzipped raw data files from the World Bank for a given instrument should be saved in the appropriate sub-folder for that instrument under "RAW DTA files" before running the .do file.	
		
The .do file processes the data and stores created data sets in the folder "Final DTA files". Three final data sets are created at the household, individual, and plot levels with labelled variables, which can be used to estimate sumary statistics for the indicators and for a variety of intermediate variables. At the end of the .do file, a set of commands outputs summary statistics restricted to rural households only to an excel file also in the folder "Final DTA files". The code for generating summary statistics may be modified as needed, or users may conduct analyses directly from the final created datasets.		
		
We also have prepared a document outlining the general construction decisions for each indicator across survey instruments, which are reflected in the coding of the .do files. We have attempted to follow the same construction approach across instruments, but note any situations where differences in the instruments made this impossible. A final document outlines general principles and considerations for contructing these indicators.		
