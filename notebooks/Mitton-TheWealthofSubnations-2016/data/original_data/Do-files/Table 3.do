use "C:\JDE Replication\GDP Data.dta", clear
sort countrycode
merge countrycode using "C:\JDE Replication\Country level data.dta"
drop if _merge==2
drop _merge

label variable pppfactor "LCU per international $"
gen gdppc_ppp= gdppc2005/ pppfactor
replace gdppc_ppp=gdppc2005 if  gdpcurrency=="PPP"
replace gdppc_ppp=gdppc2005*xrate*(1/.80412)/pppfactor if ~( gdpcurrency== officialcurrency2011)
* .80412 is the EUR/USD xrate in 2005 (all cases where gdpcurrency is not = to official are EUR cases)

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
sort isocode
save "C:\JDE Replication\merge.dta", replace

use "C:\JDE Replication\missingiso.dta", clear
merge latitude longitude using  "C:\JDE Replication\elv.dta"

drop if _merge==2
drop _merge




collapse (mean) elv, by(isocode)

merge isocode using "C:\JDE Replication\merge.dta"
drop _merge
sort isocode
save "C:\JDE Replication\merge.dta", replace
use "C:\JDE Replication\Map Data.dta", clear
merge isocode using "C:\JDE Replication\merge.dta"
drop _merge
sort isocode
save "C:\JDE Replication\merge.dta", replace

use "C:\JDE Replication\Google Earth Data.dta", clear
sort isocode
merge isocode using "C:\JDE Replication\merge.dta"
drop _merge
sort isocode
save "C:\JDE Replication\merge.dta", replace

use "C:\JDE Replication\Tropical Storm Data.dta", clear
collapse (count) stormcount=objectid, by(isocode)
sort isocode
merge isocode using "C:\JDE Replication\merge.dta"
drop _merge
sort isocode
save "C:\JDE Replication\merge.dta", replace

use "C:\JDE Replication\Fault Data.dta", clear
collapse (count) faultcount=fault_leng_km (sum) faultlength=fault_leng_km, by(isocode)
sort isocode
merge isocode using "C:\JDE Replication\merge.dta"
drop _merge
sort isocode
save "C:\JDE Replication\merge.dta", replace



sort isocode
merge isocode using "C:\JDE Replication\Ruggedness Data.dta"
drop _merge
gen cclat=cclatdeg+cclatmin/100+cclatsec/10000

sort isocode
merge isocode using "C:\JDE Replication\malaria data.dta"
drop _merge

sort index
merge index using "C:\JDE Replication\Ocean Access Data.dta"
drop _merge



gen latitude=abs(cclat)
gen loggdppc_rel_wb=log(gdppc_rel_wb)


replace stormcount=0 if stormcount==. & ~(isocode=="PKTA")
replace faultcount=0 if faultcount==. & ~(isocode=="PKTA")
replace faultlength=0 if faultlength==. & ~(isocode=="PKTA")

gen stormcount_sqkm=stormcount/totalarea
gen faultcount_sqkm=faultcount/totalarea
gen faultlength_sqkm=faultlength/totalarea




*this puts tri into tri into hundreds of meters and slope into percent (see Nunn and Puga)
replace tri=tri/100000
replace slope=slope/1000
gen logtri=log(1+tri)
gen logstormcount=log(1+stormcount)
gen logfaultcount=log(1+faultcount)

gen loggdppc_ppp=log(gdppc_ppp)


*******STANDARDIZE VARIABLES*******
quietly summ loggdppc_ppp
gen loggdppc_pppz=(loggdppc_ppp-r(mean))/r(sd)
quietly summ latitude
gen latitudez=(latitude-r(mean))/r(sd)
quietly summ ccelevationft
gen ccelevationftz=(ccelevationft-r(mean))/r(sd)
quietly summ oceanaccess
gen oceanaccessz=(oceanaccess-r(mean))/r(sd)
quietly summ logtri
gen logtriz=(logtri-r(mean))/r(sd)
quietly summ logstormcount
gen logstormcountz=(logstormcount-r(mean))/r(sd)
quietly summ logfaultcount
gen logfaultcountz=(logfaultcount-r(mean))/r(sd)
quietly summ malariarisk /* Hay et al */
gen malariariskz=(malariarisk-r(mean))/r(sd)
quietly summ malariarisk2 /* Kiszewski et al */
gen malariarisk2z=(malariarisk2-r(mean))/r(sd)

encode country, generate(countrynum)
xtset countrynum

xtreg loggdppc_pppz latitudez, fe cluster(country)
xtreg loggdppc_pppz ccelevationftz, fe cluster(country)
xtreg loggdppc_pppz oceanaccessz, fe cluster(country)
xtreg loggdppc_pppz logtriz, fe cluster(country)
xtreg loggdppc_pppz logstormcountz, fe cluster(country)
xtreg loggdppc_pppz logfaultcountz, fe cluster(country)
xtreg loggdppc_pppz malariarisk2z, fe cluster(country)
xtreg loggdppc_pppz latitudez ccelevationftz oceanaccessz logtriz logstormcountz logfaultcountz, fe cluster(country)

* robustness with geographic centroid latitude
egen gclatz=std(gclat)
xtreg loggdppc_pppz gclatz ccelevationftz oceanaccessz logtriz logstormcountz logfaultcountz, fe cluster(country)


* Interactions

egen ruleoflawz=std(ruleoflaw)

gen latitudezXrule=latitudez*ruleoflawz
gen ccelevationftzXrule=ccelevationftz*ruleoflawz
gen oceanaccesszXrule=oceanaccessz*ruleoflawz
gen logtrizXrule=logtriz*ruleoflawz
gen logstormcountzXrule=logstormcountz*ruleoflawz
gen logfaultcountzXrule=logfaultcountz*ruleoflawz 

xtreg loggdppc_pppz latitudezXrule ccelevationftzXrule oceanaccesszXrule logtrizXrule logstormcountzXrule logfaultcountzXrule latitudez ccelevationftz oceanaccessz logtriz logstormcountz logfaultcountz, fe cluster(country)  




