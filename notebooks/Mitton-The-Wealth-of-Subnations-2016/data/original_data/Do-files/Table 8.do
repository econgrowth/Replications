use "C:\JDE Replication\GDP Data.dta", clear
sort countrycode
merge countrycode using "C:\JDE Replication\Country level data.dta"
drop if _merge==2
drop _merge

label variable pppfactor "LCU per international $"
gen gdppc_ppp= gdppc2005/ pppfactor
replace gdppc_ppp=gdppc2005 if  gdpcurrency=="PPP"
replace gdppc_ppp=gdppc2005*xrate*(1/.80412)/pppfactor if ~( gdpcurrency== officialcurrency2011)

save "C:\JDE Replication\Workspace.dta", replace
collapse (sum) popsum=population2005, by(countrycode)
sort countrycode
save "C:\JDE Replication\merge.dta", replace
use "C:\JDE Replication\Workspace.dta", clear
sort countrycode
merge countrycode using "C:\JDE Replication\merge.dta"
drop _merge

gen popratio=population2005/popsum
gen popratioXgdpppp=popratio*gdppc_ppp
collapse (sum) gdppc_ppp_wtdavg=popratioXgdpppp, by(countrycode)
sort countrycode
save "C:\JDE Replication\merge.dta", replace
use "C:\JDE Replication\Workspace.dta", clear
sort countrycode
merge countrycode using "C:\JDE Replication\merge.dta"
drop _merge
gen gdppc_ppp_rel=gdppc_ppp/gdppc_ppp_wtdavg
gen gdppc_rel_wb=gdppc_ppp_rel*gdppcppp_wb

sort index
merge index using  "C:\JDE Replication\institutions concordance.dta"

drop _merge

sort isocode
save "C:\JDE Replication\merge2.dta", replace


do "C:\JDE Replication\afro data.do"
sort index
save "C:\JDE Replication\merge1.dta", replace

use "C:\JDE Replication\merge2.dta", clear
sort index_afro
merge index_afro using "C:\JDE Replication\merge1.dta"
drop if _merge==2
drop _merge
save "C:\JDE Replication\merge2.dta", replace



do "C:\JDE Replication\taf data.do"
sort index
save "C:\JDE Replication\merge1.dta", replace

use "C:\JDE Replication\merge2.dta", clear
sort index_taf
merge index_taf using "C:\JDE Replication\merge1.dta"
drop if _merge==2
drop _merge
save "C:\JDE Replication\merge2.dta", replace



do "C:\JDE Replication\qog data.do"
sort index
save "C:\JDE Replication\merge1.dta", replace

use "C:\JDE Replication\merge2.dta", clear
sort index_qog
merge index_qog using "C:\JDE Replication\merge1.dta"
drop if _merge==2
drop _merge
save "C:\JDE Replication\merge2.dta", replace



do "C:\JDE Replication\wbes data.do"
sort index
save "C:\JDE Replication\merge1.dta", replace

use "C:\JDE Replication\merge2.dta", clear
sort index_wbes
merge index_wbes using "C:\JDE Replication\merge1.dta"
drop if _merge==2
drop _merge
save "C:\JDE Replication\merge2.dta", replace



do "C:\JDE Replication\db data.do"
sort index
save "C:\JDE Replication\merge1.dta", replace

use "C:\JDE Replication\merge2.dta", clear
sort index_db
merge index_db using "C:\JDE Replication\merge1.dta"
drop if _merge==2
drop _merge
save "C:\JDE Replication\merge2.dta", replace



do "C:\JDE Replication\lapop data.do"
sort index
save "C:\JDE Replication\merge1.dta", replace

use "C:\JDE Replication\merge2.dta", clear
sort index_lapop
merge index_lapop using "C:\JDE Replication\merge1.dta"
drop if _merge==2
drop _merge
save "C:\JDE Replication\merge2.dta", replace



do "C:\JDE Replication\latinobarometro data.do"
sort index
save "C:\JDE Replication\merge1.dta", replace

use "C:\JDE Replication\merge2.dta", clear
sort index_lbo
merge index_lbo using "C:\JDE Replication\merge1.dta"
drop if _merge==2
drop _merge
save "C:\JDE Replication\merge2.dta", replace



egen pr_all=rmean(pr_afro pr_taf pr_wbes pr_db pr_lapop pr_lbo)
egen cc_all=rmean(cc_afro cc_taf cc_qog cc_wbes cc_lapop cc_lbo)
egen lo_all=rmean(lo_afro lo_taf lo_wbes lo_lapop lo_lbo lo_qog)
egen re_all=rmean(re_afro re_taf re_wbes re_db re_lapop re_lbo)
egen inst_all=rmean(pr_all cc_all lo_all re_all)
egen prpos_all=rmean(prpos_afro prpos_wbes prpos_db prpos_lapop prpos_lbo)
egen ccpos_all=rmean(ccpos_afro ccpos_qog ccpos_wbes ccpos_lapop ccpos_lbo)
egen lopos_all=rmean(lopos_afro lopos_wbes lopos_lapop lopos_lbo lopos_qog)
egen repos_all=rmean(repos_afro repos_wbes repos_db repos_lapop repos_lbo)
egen instpos_all=rmean(prpos_all ccpos_all lopos_all repos_all)



gen loggdppc_ppp=log(gdppc_ppp)
gen loggdppc_rel_wb=log(gdppc_rel_wb)
gen loggdppc_wb=log(gdppcppp_wb)

*******STANDARDIZE VARIABLES*******
egen loggdppc_pppz=std(loggdppc_ppp)
egen pr_allz=std(pr_all)
egen cc_allz=std(cc_all)
egen lo_allz=std(lo_all)
egen re_allz=std(re_all)
egen inst_allz=std(inst_all)
egen prpos_allz=std(prpos_all)
egen ccpos_allz=std(ccpos_all)
egen lopos_allz=std(lopos_all)
egen repos_allz=std(repos_all)
egen instpos_allz=std(instpos_all)

encode country, generate(countrynum)
xtset countrynum

xtreg loggdppc_pppz pr_allz, be 
xtreg loggdppc_pppz cc_allz, be
xtreg loggdppc_pppz lo_allz, be
xtreg loggdppc_pppz re_allz, be
xtreg loggdppc_pppz inst_allz, be

xtreg loggdppc_pppz prpos_allz, be 
xtreg loggdppc_pppz ccpos_allz, be
xtreg loggdppc_pppz lopos_allz, be
xtreg loggdppc_pppz repos_allz, be
xtreg loggdppc_pppz instpos_allz, be

xtreg loggdppc_pppz prpos_allz, fe cluster(country)
xtreg loggdppc_pppz ccpos_allz, fe cluster(country)
xtreg loggdppc_pppz lopos_allz, fe cluster(country)
xtreg loggdppc_pppz repos_allz, fe cluster(country)
xtreg loggdppc_pppz inst_allz, fe cluster(country)


