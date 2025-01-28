# Batch Do File Execution

This file makes it possible to run multiple do files without having to open each one individually. Executing the full code will run all do files available.

_**Important Notes**_
* The do files are run sequentially, so this will take several hours to complete. Breaking each loop into its own do file and running them in separate Stata windows will decrease the time to completion 
* If the wave summary stats are not needed, the runtime can be reduced by commenting out the call to the Summary Statistics do file at the bottom of each wave file.
* Some countries borrow data from earlier waves to fill gaps in the survey instrument. Running the waves in order reduces your likelihood of getting an error.
* The script will remove all created data from the folders before executing the do file to ensure that there aren't errors in versioning. Archive any data you want to save before running this script.