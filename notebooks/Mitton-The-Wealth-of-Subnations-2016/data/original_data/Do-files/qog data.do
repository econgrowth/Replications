*This do-file takes the raw QOG data and prepares it for merging with other data.

set more off

use "qog.dta", clear

*REMOVE UNUSABLE SCORES



*CLEAN DATA
drop if ~(country=="")
drop country
rename var5 country
label define country 1 "Austria" 2 "Belgium" 3 "Bulgaria" 4 "Czech Republic" 5 "Denmark" 6 "Germany" 7 "France" 8 "Greece" 9 "Hungary" 10 "Italy" 11 "Netherlands" 12 "Poland" 13 "Portugal" 14 "Romania" 15 "Slovakia" 16 "Spain" 17 "Sweden" 18 "UK" , replace
label values country country


*AVERAGE DATA



*STANDARDIZE SCORES
*(Already standardized in raw data)



*CREATE INDICES
egen cc_qog=rmean(media election helbribe lawcor edcor helcor)
egen lo_qog=rmean(lawqual lawimpart1 lawimpart2)
egen ccpos_qog=rmean(media election helbribe lawcor edcor helcor)
egen lopos_qog=rmean(lawqual lawimpart1 lawimpart2)
egen comp_qog=rmean(cc_qog lo_qog)
egen comp2_qog=rmean(media election helbribe lawcor edcor helcor lawqual lawimpart1 lawimpart2)
egen comppos_qog=rmean(media election helbribe lawcor edcor helcor lawqual lawimpart1 lawimpart2)
 

  
*INDEX FOR MERGING
keep country region comp_qog comp2_qog comppos_qog cc_qog  lo_qog ccpos_qog lopos_qog 
sort country region
gen index_qog=[_n]
order index country region

save "qogdata", replace






