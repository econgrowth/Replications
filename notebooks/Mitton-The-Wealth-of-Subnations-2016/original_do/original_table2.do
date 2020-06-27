use "GDP Data.dta", clear
sort countrycode
merge m:m countrycode using "Country level data.dta"
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
merge m:m countrycode using "Replication/merge.dta"
drop _merge
gen popratio=population2005/popsum
gen popratioXgdpppp=popratio*gdppc_ppp
collapse (sum) gdppc_ppp_wtdavg=popratioXgdpppp, by(countrycode)
sort countrycode
save "Replication/merge.dta", replace
use "Replication/Workspace.dta", clear
sort countrycode
merge m:m countrycode using "Replication/merge.dta"
drop _merge
gen gdppc_ppp_rel=gdppc_ppp/gdppc_ppp_wtdavg
gen gdppc_rel_wb=gdppc_ppp_rel*gdppcppp_wb
sort isocode
save "Replication/merge.dta", replace

use "missingiso.dta", clear
merge m:m latitude longitude using  "elv.dta"
drop if _merge==2
drop _merge
collapse (mean) elv, by(isocode)

merge 1:1 isocode using "Replication/merge.dta"
drop _merge
sort isocode
save "Replication/merge.dta", replace
use "Map Data.dta", clear
merge 1:1 isocode using "Replication/merge.dta"
drop _merge
sort isocode
save "Replication/merge.dta", replace

use "Google Earth Data.dta", clear
sort isocode
merge 1:1 isocode using "Replication/merge.dta"
drop _merge
sort isocode
save "Replication/merge.dta", replace

use "Tropical Storm Data.dta", clear
collapse (count) stormcount=objectid, by(isocode)
sort isocode
merge 1:1 isocode using "Replication/merge.dta"
drop _merge
sort isocode
save "Replication/merge.dta", replace

use "Fault Data.dta", clear
collapse (count) faultcount=fault_leng_km (sum) faultlength=fault_leng_km, by(isocode)
sort isocode
merge 1:1 isocode using "Replication/merge.dta"
drop _merge
sort isocode
save "Replication/merge.dta", replace

sort isocode
merge 1:1 isocode using "Ruggedness Data.dta"
drop _merge
gen cclat=cclatdeg+cclatmin/100+cclatsec/10000

sort isocode
merge 1:1 isocode using "malaria data.dta"
drop _merge

sort index
merge 1:1 index using "Ocean Access Data.dta"
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

keep isocode country countrycode gdppc_ppp loggdppc_ppp loggdppc_rel_wb latitude ccelevationft oceanaccess logtri logstormcount logfaultcount malariarisk2 col
sort isocode
save "Replication/mergeall.dta", replace


use "GDP Data.dta", clear
sort countrycode
merge m:m countrycode using "Country level data.dta"
drop if _merge==2
drop _merge

label variable pppfactor "LCU per international $"
gen gdppc_ppp= gdppc2005/ pppfactor
replace gdppc_ppp=gdppc2005 if  gdpcurrency=="PPP"
replace gdppc_ppp=gdppc2005*xrate*(1/.80412)/pppfactor if ~( gdpcurrency== officialcurrency2011)

save "Replication/Workspace.dta", replace
collapse (sum) popsum=population2005, by(countrycode)
sort countrycode
save "Replication/merge.dta", replace
use "Replication/Workspace.dta", clear
sort countrycode
merge m:m countrycode using "Replication/merge.dta"
drop _merge

gen popratio=population2005/popsum
gen popratioXgdpppp=popratio*gdppc_ppp
collapse (sum) gdppc_ppp_wtdavg=popratioXgdpppp, by(countrycode)
sort countrycode
save "Replication/merge.dta", replace
use "Replication/Workspace.dta", clear
sort countrycode
merge m:m countrycode using "Replication/merge.dta"
drop _merge
gen gdppc_ppp_rel=gdppc_ppp/gdppc_ppp_wtdavg
gen gdppc_rel_wb=gdppc_ppp_rel*gdppcppp_wb
sort isocode
save "Replication/merge.dta", replace

use "missingiso.dta", clear
merge m:m latitude longitude using  "pre.dta"
drop if _merge==2
drop _merge
sort latitude longitude
merge m:m latitude longitude using  "rd.dta"
drop if _merge==2
drop _merge
sort latitude longitude
merge m:m latitude longitude using  "tmp.dta"
drop if _merge==2
drop _merge
sort latitude longitude
merge m:m latitude longitude using  "dtr.dta"
drop if _merge==2
drop _merge
sort latitude longitude
merge m:m latitude longitude using  "reh.dta"
drop if _merge==2
drop _merge
sort latitude longitude
merge m:m latitude longitude using  "sunp.dta"
drop if _merge==2
drop _merge
sort latitude longitude
merge m:m latitude longitude using  "frs.dta"
drop if _merge==2
drop _merge
sort latitude longitude
merge m:m latitude longitude using  "wnd.dta"
drop if _merge==2
drop _merge
sort latitude longitude
merge m:m latitude longitude using  "elv.dta"
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



collapse (mean) pre_avg rd_avg tmp_avg dtr_avg reh_avg sunp_avg frs_avg wnd_avg , by(isocode)
merge 1:1 isocode using "Replication/merge.dta"
drop _merge
sort isocode
save "Replication/merge.dta", replace

use "Biome Data.dta", clear
collapse (sum) trop_area=biome_area if fid_biomes>10 & fid_biomes<15 & ~(fid_biomes==.), by(isocode)
sort isocode
save "biomemerge.dta", replace
use "Biome Data.dta", clear
collapse (sum) all_area=biome_area if ~(fid_biomes==.), by(isocode)
sort isocode
merge 1:1 isocode using "biomemerge.dta"
drop _merge
gen trop_pct=trop_area/all_area
replace trop_pct=0 if trop_pct==.
sort isocode

merge 1:1 isocode using "Replication/merge.dta"
keep isocode pre_avg rd_avg tmp_avg dtr_avg reh_avg sunp_avg frs_avg wnd_avg trop_pct
sort isocode
merge 1:1 isocode using "Replication/mergeall.dta"
drop _merge
sort isocode
save "Replication/mergeall.dta", replace

use "Mineral Data.dta", clear
collapse (sum) gold silver platinum ruthenium rhodium palladium osmium iridium copper lead nickel zinc aluminum bismuth cobalt gallium indium magnesium mercury potassium titanium tin uranium zirconium iron diamond manganese carbon chromium molybdenum vanadium boron cerium niobium tungsten, by(isocode)
sort isocode
save "Replication/merge.dta", replace

use "Oil and Gas Data.dta", clear
collapse (count) objectid, by(isocode)
sort isocode
save "Replication/merge2.dta", replace


use "Soil Quality Data.dta", clear
collapse salinity if salinity>0 & salinity<5, by(isocode)
sort isocode
save "Replication/merge4.dta", replace

use "Soil Quality Data.dta", clear
collapse oxygen if oxygen>0 & oxygen<5, by(isocode) 
sort isocode
merge 1:1 isocode using "Replication/merge4.dta"
drop _merge
sort isocode
save "Replication/merge4.dta", replace

use "Soil Quality Data.dta", clear
collapse tillage if tillage>0 & tillage<5, by(isocode)
sort isocode
merge 1:1 isocode using "Replication/merge4.dta"
drop _merge
sort isocode
save "Replication/merge4.dta", replace

use "Soil Quality Data.dta", clear
collapse rooting if rooting>0 & rooting<5, by(isocode)
sort isocode
merge 1:1 isocode using "Replication/merge4.dta"
drop _merge
sort isocode
save "Replication/merge4.dta", replace

use "Soil Quality Data.dta", clear
collapse pH if pH>0 & pH<5, by(isocode)
sort isocode
merge 1:1 isocode using "Replication/merge4.dta"
drop _merge
sort isocode
save "Replication/merge4.dta", replace

use "Soil Quality Data.dta", clear
collapse nutrient_retention if nutrient_retention>0 & nutrient_retention<5, by(isocode)
sort isocode
merge 1:1 isocode using "Replication/merge4.dta"
drop _merge
sort isocode
save "Replication/merge4.dta", replace

use "Soil Quality Data.dta", clear
collapse nutrient_availability if nutrient_availability>0 & nutrient_availability<5, by(isocode)
sort isocode
merge 1:1 isocode using "Replication/merge4.dta"
drop _merge
sort isocode
save "Replication/merge4.dta", replace

use "Soil Quality Data.dta", clear
collapse (count) workable=salinity if salinity>0 & salinity<5, by(isocode)
sort isocode
merge 1:1 isocode using "Replication/merge4.dta"
drop _merge
sort isocode
save "Replication/merge4.dta", replace


use "Soil Quality Data.dta", clear
collapse (count) nonworkable=salinity if salinity<1 | salinity>4, by(isocode)
sort isocode
merge 1:1 isocode using "Replication/merge4.dta"
drop _merge
sort isocode
save "Replication/merge4.dta", replace

use "GDP Data.dta", clear
sort countrycode
merge m:m countrycode using "Country level data.dta"
drop if _merge==2
drop _merge

label variable pppfactor "LCU per international $"
gen gdppc_ppp= gdppc2005/ pppfactor
replace gdppc_ppp=gdppc2005 if  gdpcurrency=="PPP"
replace gdppc_ppp=gdppc2005*xrate*(1/.80412)/pppfactor if ~( gdpcurrency== officialcurrency2011)

save "Replication/Workspace.dta", replace
collapse (sum) popsum=population2005, by(countrycode)
sort countrycode
save "Replication/merge3.dta", replace
use "Replication/Workspace.dta", clear
sort countrycode
merge m:m countrycode using "Replication/merge3.dta"
drop _merge

gen popratio=population2005/popsum
gen popratioXgdpppp=popratio*gdppc_ppp
collapse (sum) gdppc_ppp_wtdavg=popratioXgdpppp, by(countrycode)
sort countrycode
save "Replication/merge3.dta", replace
use "Replication/Workspace.dta", clear
sort countrycode
merge m:m countrycode using "Replication/merge3.dta"
drop _merge
gen gdppc_ppp_rel=gdppc_ppp/gdppc_ppp_wtdavg
gen gdppc_rel_wb=gdppc_ppp_rel*gdppcppp_wb
sort isocode
merge 1:1 isocode using "Replication/merge.dta"
drop _merge
sort isocode
merge 1:1 isocode using "Replication/merge2.dta"
drop _merge
sort isocode
rename objectid oilandgas
merge 1:1 isocode using "Replication/merge4.dta"
drop _merge
egen soilquality=rmean(salinity tillage rooting pH oxygen nutrient_retention nutrient_availability)
replace soilquality=-soilquality
drop salinity tillage rooting pH oxygen nutrient_retention nutrient_availability
sort isocode
merge 1:1 isocode using "Map Data.dta"
drop _merge

sort isocode
merge 1:1 isocode using "Water Data.dta"
drop _merge

replace gold=0 if gold==. & ~(isocode=="PKTA")
replace silver=0 if silver==. & ~(isocode=="PKTA")
replace platinum=0 if platinum==. & ~(isocode=="PKTA")
replace ruthenium=0 if ruthenium==. & ~(isocode=="PKTA")
replace palladium=0 if palladium==. & ~(isocode=="PKTA")
replace rhodium=0 if rhodium==. & ~(isocode=="PKTA")
replace osmium=0 if osmium==. & ~(isocode=="PKTA")
replace iridium=0 if iridium==. & ~(isocode=="PKTA")
replace copper=0 if copper==. & ~(isocode=="PKTA")
replace lead=0 if lead==. & ~(isocode=="PKTA")
replace nickel=0 if nickel==. & ~(isocode=="PKTA")
replace zinc=0 if zinc==. & ~(isocode=="PKTA")
replace aluminum=0 if aluminum==. & ~(isocode=="PKTA")
replace bismuth=0 if bismuth==. & ~(isocode=="PKTA")
replace cobalt=0 if cobalt==. & ~(isocode=="PKTA")
replace gallium=0 if gallium==. & ~(isocode=="PKTA")
replace indium=0 if indium==. & ~(isocode=="PKTA")
replace magnesium=0 if magnesium==. & ~(isocode=="PKTA")
replace mercury=0 if mercury==. & ~(isocode=="PKTA")
replace potassium=0 if potassium==. & ~(isocode=="PKTA")
replace titanium=0 if titanium==. & ~(isocode=="PKTA")
replace tin=0 if tin==. & ~(isocode=="PKTA")
replace uranium=0 if uranium==. & ~(isocode=="PKTA")
replace zirconium=0 if zirconium==. & ~(isocode=="PKTA")
replace iron=0 if iron==. & ~(isocode=="PKTA")
replace diamond=0 if diamond==. & ~(isocode=="PKTA")
replace carbon=0 if carbon==. & ~(isocode=="PKTA")
replace manganese=0 if manganese==. & ~(isocode=="PKTA")
replace chromium=0 if chromium==. & ~(isocode=="PKTA")
replace molybdenum=0 if molybdenum==. & ~(isocode=="PKTA")
replace vanadium=0 if vanadium==. & ~(isocode=="PKTA")
replace boron=0 if boron==. & ~(isocode=="PKTA")
replace cerium=0 if cerium==. & ~(isocode=="PKTA")
replace niobium=0 if niobium==. & ~(isocode=="PKTA")
replace tungsten=0 if tungsten==. & ~(isocode=="PKTA")
replace oilandgas=0 if oilandgas==. & ~(isocode=="PKTA")

gen preciousmetals=(gold+ silver+ ruthenium +rhodium +palladium +osmium +iridium+ platinum)
* I do not divide preciousmetals and oilandgas by 1,000 just for scaling purposes (but do in regressions)
* replace oilandgas=oilandgas/1000
gen basemetals=copper+ lead+ nickel +zinc +aluminum +bismuth +cobalt +gallium +indium +magnesium +mercury +potassium +titanium +tin +uranium +zirconium
gen alloyants=carbon+manganese+chromium+molybdenum+vanadium+boron+cerium+niobium+tungsten

replace nonworkable=0 if nonworkable==.
replace workable=0 if workable==.
gen workable_pct=workable/(workable+nonworkable) if ~(soilquality==.)

* Making these per 1,000 sq km for presentation purposes
gen preciousmetals_sqkm=preciousmetals/totalarea*1000
gen basemetals_sqkm=basemetals/totalarea*1000
gen iron_sqkm=iron/totalarea*1000
gen alloyants_sqkm=alloyants/totalarea*1000
gen diamond_sqkm=diamond/totalarea*1000
gen oilandgas_sqkm=oilandgas/totalarea*1000
gen lakeriver_sqkm=areaofinlandlakesandmainriverssq/totalarea*100
* Water just putting in whole percents

gen preciousmetals_log=log(1+preciousmetals)/totalarea
gen basemetals_log=log(1+basemetals)/totalarea
gen iron_log=log(1+iron)/totalarea
gen alloyants_log=log(1+alloyants)/totalarea
gen diamond_log=log(1+diamond)/totalarea
gen oilandgas_log=log(1+oilandgas)/totalarea
gen lakeriver_log=log(1+areaofinlandlakesandmainriverssq)/totalarea

keep isocode preciousmetals basemetals_sqkm iron_sqkm alloyants_sqkm diamond oilandgas soilquality lakeriver_sqkm workable_pct
sort isocode
merge isocode using "Replication/mergeall.dta"
drop _merge
sort isocode
save "Replication/mergeall.dta", replace


use "GDP Data.dta", clear
sort countrycode
merge m:m countrycode using "Country level data.dta"
drop if _merge==2
drop _merge

label variable pppfactor "LCU per international $"
gen gdppc_ppp= gdppc2005/ pppfactor
replace gdppc_ppp=gdppc2005 if  gdpcurrency=="PPP"
replace gdppc_ppp=gdppc2005*xrate*(1/.80412)/pppfactor if ~( gdpcurrency== officialcurrency2011)

save "Replication/Workspace.dta", replace
collapse (sum) popsum=population2005, by(countrycode)
sort countrycode
save "Replication/merge.dta", replace
use "Replication/Workspace.dta", clear
sort countrycode
merge m:m countrycode using "Replication/merge.dta"
drop _merge

gen popratio=population2005/popsum
gen popratioXgdpppp=popratio*gdppc_ppp
collapse (sum) gdppc_ppp_wtdavg=popratioXgdpppp, by(countrycode)
sort countrycode
save "Replication/merge.dta", replace
use "Replication/Workspace.dta", clear
sort countrycode
merge m:m countrycode using "Replication/merge.dta"
drop _merge
gen gdppc_ppp_rel=gdppc_ppp/gdppc_ppp_wtdavg
gen gdppc_rel_wb=gdppc_ppp_rel*gdppcppp_wb

sort index
merge 1:1 index using  "institutions concordance.dta"

drop _merge

sort isocode
save "Replication/merge2.dta", replace


do "Do-files/afro data.do"
sort index
save "Replication/merge1.dta", replace

use "Replication/merge2.dta", clear
sort index_afro
merge m:m index_afro using "Replication/merge1.dta", force //
drop if _merge==2
drop _merge
save "Replication/merge2.dta", replace


**
do "Do-files/TAF data.do"
sort index
save "Replication/merge1.dta", replace

use "Replication/merge2.dta", clear
sort index_taf
merge m:m index_taf using "Replication/merge1.dta", force //
drop if _merge==2
drop _merge
save "Replication/merge2.dta", replace



do "Do-files/qog data.do"
sort index
save "Replication/merge1.dta", replace

use "Replication/merge2.dta", clear
sort index_qog
merge m:m index_qog using "Replication/merge1.dta", force //
drop if _merge==2
drop _merge
save "Replication/merge2.dta", replace



do "Do-files/WBES data.do"
sort index
save "Replication/merge1.dta", replace

use "Replication/merge2.dta", clear
sort index_wbes
merge m:m index_wbes using "Replication/merge1.dta", force //
drop if _merge==2
drop _merge
save "Replication/merge2.dta", replace



do "Do-files/db data.do"
sort index
save "Replication/merge1.dta", replace

use "Replication/merge2.dta", clear
sort index_db
merge m:m index_db using "Replication/merge1.dta", force //
drop if _merge==2
drop _merge
save "Replication/merge2.dta", replace



do "Do-files/lapop data.do"
sort index
save "Replication/merge1.dta", replace

use "Replication/merge2.dta", clear
sort index_lapop
merge m:m index_lapop using "Replication/merge1.dta", force //
drop if _merge==2
drop _merge
save "Replication/merge2.dta", replace



do "Do-files/latinobarometro data.do"
sort index
save "Replication/merge1.dta", replace

use "Replication/merge2.dta", clear
sort index_lbo
merge m:m index_lbo using "Replication/merge1.dta", force //
drop if _merge==2
drop _merge
save "Replication/merge2.dta", replace


egen pr_all=rmean(pr_afro pr_taf pr_wbes pr_db pr_lapop pr_lbo)
egen cc_all=rmean(cc_afro cc_taf cc_qog cc_wbes cc_lapop cc_lbo)
egen lo_all=rmean(lo_afro lo_taf lo_wbes lo_lapop lo_lbo lo_qog)
egen re_all=rmean(re_afro re_taf re_wbes re_db re_lapop re_lbo)
egen inst_all=rmean(pr_all cc_all lo_all re_all)
egen comp2_all=rmean(comp2_afro comp2_taf comp2_wbes comp2_db comp2_qog comp2_lbo comp2_lapop)

keep isocode pr_all cc_all lo_all re_all  inst_all  comp2_afro comp2_taf comp2_wbes comp2_db comp2_qog comp2_lbo comp2_lapop comp2_all

sort isocode
merge 1:1 isocode using "Replication/mergeall.dta"
drop _merge
drop if isocode==""


summ gdppc_ppp loggdppc_ppp col latitude ccelevationft oceanaccess logtri logstormcount logfaultcount malariarisk2 trop_pct pre_avg rd_avg tmp_avg dtr_avg reh_avg sunp_avg frs_avg wnd_avg oilandgas diamond preciousmetals basemetals_sqkm iron_sqkm alloyants_sqkm lakeriver_sqkm workable_pct soilquality  comp2_afro comp2_taf comp2_wbes comp2_db comp2_qog comp2_lbo comp2_lapop comp2_all pr_all cc_all lo_all re_all, detail
