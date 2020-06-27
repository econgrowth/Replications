use "GDP Data.dta", clear
sort countrycode
merge countrycode using "Country level data.dta"
drop if _merge==2
drop _merge

label variable pppfactor "LCU per international $"
gen gdppc_ppp= gdppc2005/ pppfactor
replace gdppc_ppp=gdppc2005 if  gdpcurrency=="PPP"
replace gdppc_ppp=gdppc2005*xrate*(1/.80412)/pppfactor if ~( gdpcurrency== officialcurrency2011)
* .80412 is the EUR/USD xrate in 2005 (all cases where gdpcurrency is not = to official are EUR cases)

save "Replication/Workspace.dta", replace
collapse (sum) popsum=population2005, by(countrycode)
sort countrycode
save "Replication/merge.dta", replace
use "Replication/Workspace.dta", clear
sort countrycode
merge countrycode using "Replication/merge.dta"
drop _merge

gen popratio=population2005/popsum
gen popratioXgdpppp=popratio*gdppc_ppp
collapse (sum) gdppc_ppp_wtdavg=popratioXgdpppp, by(countrycode)
sort countrycode
save "Replication/merge.dta", replace
use "Replication/Workspace.dta", clear
sort countrycode
merge countrycode using "Replication/merge.dta"
drop _merge
gen gdppc_ppp_rel=gdppc_ppp/gdppc_ppp_wtdavg
gen gdppc_rel_wb=gdppc_ppp_rel*gdppcppp_wb
sort isocode
save "Replication/merge.dta", replace

use "missingiso.dta", clear
merge latitude longitude using  "pre.dta"
drop if _merge==2
drop _merge
sort latitude longitude
merge latitude longitude using  "rd.dta"
drop if _merge==2
drop _merge
sort latitude longitude
merge latitude longitude using  "tmp.dta"
drop if _merge==2
drop _merge
sort latitude longitude
merge latitude longitude using  "dtr.dta"
drop if _merge==2
drop _merge
sort latitude longitude
merge latitude longitude using  "reh.dta"
drop if _merge==2
drop _merge
sort latitude longitude
merge latitude longitude using  "sunp.dta"
drop if _merge==2
drop _merge
sort latitude longitude
merge latitude longitude using  "frs.dta"
drop if _merge==2
drop _merge
sort latitude longitude
merge latitude longitude using  "wnd.dta"
drop if _merge==2
drop _merge
sort latitude longitude
merge latitude longitude using  "elv.dta"
drop if _merge==2
drop _merge


egen pre_avg=rmean( pre1 pre2 pre3 pre4 pre5 pre6 pre7 pre8 pre9 pre10 pre11 pre12)
egen rd_avg=rmean( rd1 rd2 rd3 rd4 rd5 rd6 rd7 rd8 rd9 rd10 rd11 rd12)
egen tmp_avg=rmean(tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 tmp7 tmp8 tmp9 tmp10 tmp11 tmp12)
egen dtr_avg=rmean(dtr1 dtr2 dtr3 dtr4 dtr5 dtr6 dtr7 dtr8 dtr9 dtr10 dtr11 dtr12)
egen reh_avg=rmean(reh1 reh2 reh3 reh4 reh5 reh6 reh7 reh8 reh9 reh10 reh11 reh12)
egen sunp_avg=rmean(sunp1 sunp2 sunp3 sunp4 sunp5 sunp6 sunp7 sunp8 sunp9 sunp10 sunp11 sunp12)
egen frs_avg=rmean(frs1 frs2 frs3 frs4 frs5 frs6 frs7 frs8 frs9 frs10 frs11 frs12)
egen wnd_avg=rmean(wind1 wind2 wind3 wind4 wind5 wind6 wind7 wind8 wind9 wind10 wind11 wind12)

replace frs1=. if latitude<0
replace frs2=. if latitude<0
replace frs3=. if latitude<0
replace frs4=. if latitude<0
replace frs5=. if latitude<0
replace frs6=. if latitude<0
replace frs10=. if latitude<0
replace frs11=. if latitude<0
replace frs12=. if latitude<0

replace frs4=. if latitude>0
replace frs5=. if latitude>0
replace frs6=. if latitude>0
replace frs7=. if latitude>0
replace frs8=. if latitude>0
replace frs9=. if latitude>0
replace frs10=. if latitude>0
replace frs11=. if latitude>0
replace frs12=. if latitude>0

egen frsw_avg=rmean(frs1 frs2 frs3 frs4 frs5 frs6 frs7 frs8 frs9 frs10 frs11 frs12)

egen pre_var=rowsd( pre1 pre2 pre3 pre4 pre5 pre6 pre7 pre8 pre9 pre10 pre11 pre12)
egen rd_var=rowsd( rd1 rd2 rd3 rd4 rd5 rd6 rd7 rd8 rd9 rd10 rd11 rd12)
egen tmp_var=rowsd(tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 tmp7 tmp8 tmp9 tmp10 tmp11 tmp12)
egen dtr_var=rowsd(dtr1 dtr2 dtr3 dtr4 dtr5 dtr6 dtr7 dtr8 dtr9 dtr10 dtr11 dtr12)
egen reh_var=rowsd(reh1 reh2 reh3 reh4 reh5 reh6 reh7 reh8 reh9 reh10 reh11 reh12)
egen sunp_var=rowsd(sunp1 sunp2 sunp3 sunp4 sunp5 sunp6 sunp7 sunp8 sunp9 sunp10 sunp11 sunp12)
egen frs_var=rowsd(frs1 frs2 frs3 frs4 frs5 frs6 frs7 frs8 frs9 frs10 frs11 frs12)
egen wnd_var=rowsd(wind1 wind2 wind3 wind4 wind5 wind6 wind7 wind8 wind9 wind10 wind11 wind12)


collapse (mean) pre_avg rd_avg tmp_avg dtr_avg reh_avg sunp_avg frs_avg frsw_avg wnd_avg pre_var rd_var tmp_var dtr_var reh_var sunp_var frs_var wnd_var, by(isocode)
merge isocode using "Replication/merge.dta"
drop _merge
sort isocode
save "Replication/merge.dta", replace

use "Biome Data.dta", clear
collapse (sum) trop_area=biome_area if fid_biomes>10 & fid_biomes<15 & ~(fid_biomes==.), by(isocode)
sort isocode
save "Replication/biomemerge.dta", replace
use "Biome Data.dta", clear
collapse (sum) all_area=biome_area if ~(fid_biomes==.), by(isocode)
sort isocode
merge isocode using "Replication/biomemerge.dta"
drop _merge
gen trop_pct=trop_area/all_area
replace trop_pct=0 if trop_pct==.
sort isocode

merge isocode using "Replication/merge.dta"

gen loggdppc_ppp=log(gdppc_ppp)



*******STANDARDIZE VARIABLES*******
quietly summ loggdppc_ppp
gen loggdppc_pppz=(loggdppc_ppp-r(mean))/r(sd)
quietly summ pre_avg
gen pre_avgz=(pre_avg-r(mean))/r(sd)
quietly summ rd_avg
gen rd_avgz=(rd_avg-r(mean))/r(sd)
quietly summ tmp_avg
gen tmp_avgz=(tmp_avg-r(mean))/r(sd)
quietly summ dtr_avg
gen dtr_avgz=(dtr_avg-r(mean))/r(sd)
quietly summ reh_avg
gen reh_avgz=(reh_avg-r(mean))/r(sd)
quietly summ sunp_avg
gen sunp_avgz=(sunp_avg-r(mean))/r(sd)
quietly summ frs_avg
gen frs_avgz=(frs_avg-r(mean))/r(sd)
quietly summ wnd_avg
gen wnd_avgz=(wnd_avg-r(mean))/r(sd)
quietly summ trop_pct
gen trop_pctz=(trop_pct-r(mean))/r(sd)
encode country, generate(countrynum)
xtset countrynum

xtreg loggdppc_pppz trop_pctz, fe cluster(country)
xtreg loggdppc_pppz pre_avgz, fe cluster(country)
xtreg loggdppc_pppz rd_avgz, fe cluster(country)
xtreg loggdppc_pppz tmp_avgz, fe cluster(country)
xtreg loggdppc_pppz dtr_avgz, fe cluster(country)
xtreg loggdppc_pppz reh_avgz, fe cluster(country)
xtreg loggdppc_pppz sunp_avgz, fe cluster(country)
xtreg loggdppc_pppz frs_avgz, fe cluster(country)
xtreg loggdppc_pppz wnd_avgz, fe cluster(country)
xtreg loggdppc_pppz trop_pctz pre_avgz rd_avgz tmp_avgz dtr_avgz reh_avgz sunp_avgz frs_avgz wnd_avgz, fe cluster(country)

* Interactions

gen ruleoflawz=(ruleoflaw-r(mean))/r(sd)

gen trop_pctzXrule=trop_pctz*ruleoflaw
gen pre_avgzXrule=pre_avgz*ruleoflaw
gen rd_avgzXrule=rd_avgz*ruleoflaw
gen tmp_avgzXrule=tmp_avgz*ruleoflaw
gen dtr_avgzXrule=dtr_avgz*ruleoflaw
gen reh_avgzXrule=reh_avgz*ruleoflaw
gen sunp_avgzXrule=sunp_avgz*ruleoflaw
gen frs_avgzXrule=frs_avgz*ruleoflaw
gen wnd_avgzXrule=wnd_avgz*ruleoflaw

xtreg loggdppc_pppz trop_pctzXrule pre_avgzXrule rd_avgzXrule tmp_avgzXrule dtr_avgzXrule reh_avgzXrule sunp_avgzXrule frs_avgzXrule wnd_avgzXrule trop_pctz pre_avgz rd_avgz tmp_avgz dtr_avgz reh_avgz sunp_avgz frs_avgz wnd_avgz, fe cluster(country) 


