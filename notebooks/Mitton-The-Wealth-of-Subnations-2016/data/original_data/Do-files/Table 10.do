
use "C:\JDE Replication\dpi2012.dta", clear
replace auton=. if auton==-999
replace state=. if state==-999
replace muni=. if muni==-999
replace author=. if author==-999
replace stconst=. if stconst==-999

keep if year>1979 & year<2006 & ~(year==.)
rename ifs countrycode
collapse (mean) auton muni state author stconst, by(countrycode)
sort countrycode
save "C:\JDE Replication\dpi2005.dta", replace

quietly do "C:\JDE Replication\Table 6-7.do"
sort countrycode
merge countrycode using "C:\JDE Replication\dpi2005.dta"
drop if _merge==2
drop _merge

sort countrycode
merge countrycode using "C:\JDE Replication\Country level data.dta"
drop if _merge==2
drop _merge

gen composite=auton+state+muni+author+stconst


*******STANDARDIZE VARIABLES*******
egen autonz=std(auton)
egen statez=std(state)
egen muniz=std(muni)
egen authorz=std(author)
egen stconstz=std(stconst)
egen compositez=std(composite)


gen instXauton=inst_allz*autonz
xtreg loggdppc_pppz inst_allz instXauton, fe cluster(country)

gen instXstate=inst_allz*statez
xtreg loggdppc_pppz inst_allz instXstate, fe cluster(country)

gen instXmuni=inst_allz*muniz
xtreg loggdppc_pppz inst_allz instXmuni, fe cluster(country)

gen instXauthor=inst_allz*authorz
xtreg loggdppc_pppz inst_allz instXauthor, fe cluster(country)

gen instXstconst=inst_allz*stconstz
xtreg loggdppc_pppz inst_allz instXstconst, fe cluster(country)

gen instXcomposite=inst_allz*compositez
xtreg loggdppc_pppz inst_allz instXcomposite, fe cluster(country)

sort index
merge index using "C:\JDE Replication\autonomy.dta"
gen autoregion=0
replace autoregion=1 if autonwiki==1
replace autoregion=1 if partautonwiki==1


egen autoregionz=std(autoregion)
gen instXauto=inst_allz*autoregionz


xtreg loggdppc_pppz inst_allz instXauto autoregionz, fe cluster(country)


xtreg loggdppc_pppz inst_allz if autoregion==1, fe cluster(country)

