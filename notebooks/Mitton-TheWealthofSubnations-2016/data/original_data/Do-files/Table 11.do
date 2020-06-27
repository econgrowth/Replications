set more off

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



keep index isocode country countrycode loggdppc_ppp loggdppc_rel_wb latitude elv oceanaccess logtri logstormcount logfaultcount malariarisk2 col ccelevationft
sort isocode
save "C:\JDE Replication\mergeall.dta", replace


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
sort isocode
save "C:\JDE Replication\merge.dta", replace

use "C:\JDE Replication\missingiso.dta", clear
merge latitude longitude using  "C:\JDE Replication\pre.dta"
drop if _merge==2
drop _merge
sort latitude longitude
merge latitude longitude using  "C:\JDE Replication\rd.dta"
drop if _merge==2
drop _merge
sort latitude longitude
merge latitude longitude using  "C:\JDE Replication\tmp.dta"
drop if _merge==2
drop _merge
sort latitude longitude
merge latitude longitude using  "C:\JDE Replication\dtr.dta"
drop if _merge==2
drop _merge
sort latitude longitude
merge latitude longitude using  "C:\JDE Replication\reh.dta"
drop if _merge==2
drop _merge
sort latitude longitude
merge latitude longitude using  "C:\JDE Replication\sunp.dta"
drop if _merge==2
drop _merge
sort latitude longitude
merge latitude longitude using  "C:\JDE Replication\frs.dta"
drop if _merge==2
drop _merge
sort latitude longitude
merge latitude longitude using  "C:\JDE Replication\wnd.dta"
drop if _merge==2
drop _merge
sort latitude longitude
merge latitude longitude using  "C:\JDE Replication\elv.dta"
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
merge isocode using "C:\JDE Replication\merge.dta"
drop _merge
sort isocode
save "C:\JDE Replication\merge.dta", replace

use "C:\JDE Replication\Biome Data.dta", clear
collapse (sum) trop_area=biome_area if fid_biomes>10 & fid_biomes<15 & ~(fid_biomes==.), by(isocode)
sort isocode
save "C:\JDE Replication\biomemerge.dta", replace
use "C:\JDE Replication\Biome Data.dta", clear
collapse (sum) all_area=biome_area if ~(fid_biomes==.), by(isocode)
sort isocode
merge isocode using "C:\JDE Replication\biomemerge.dta"
drop _merge
gen trop_pct=trop_area/all_area
replace trop_pct=0 if trop_pct==.
sort isocode

merge isocode using "C:\JDE Replication\merge.dta"
keep isocode pre_avg rd_avg tmp_avg dtr_avg reh_avg sunp_avg frs_avg wnd_avg trop_pct
sort isocode
merge isocode using "C:\JDE Replication\mergeall.dta"
drop _merge
sort isocode
save "C:\JDE Replication\mergeall.dta", replace

use "C:\JDE Replication\Mineral Data.dta", clear
collapse (sum) gold silver platinum ruthenium rhodium palladium osmium iridium copper lead nickel zinc aluminum bismuth cobalt gallium indium magnesium mercury potassium titanium tin uranium zirconium iron diamond manganese carbon chromium molybdenum vanadium boron cerium niobium tungsten, by(isocode)
sort isocode
save "C:\JDE Replication\merge.dta", replace

use "C:\JDE Replication\Oil and Gas Data.dta", clear
collapse (count) objectid, by(isocode)
sort isocode
save "C:\JDE Replication\merge2.dta", replace


use "C:\JDE Replication\Soil Quality Data.dta", clear
collapse salinity if salinity>0 & salinity<5, by(isocode)
sort isocode
save "C:\JDE Replication\merge4.dta", replace

use "C:\JDE Replication\Soil Quality Data.dta", clear
collapse oxygen if oxygen>0 & oxygen<5, by(isocode) 
sort isocode
merge isocode using "C:\JDE Replication\merge4.dta"
drop _merge
sort isocode
save "C:\JDE Replication\merge4.dta", replace

use "C:\JDE Replication\Soil Quality Data.dta", clear
collapse tillage if tillage>0 & tillage<5, by(isocode)
sort isocode
merge isocode using "C:\JDE Replication\merge4.dta"
drop _merge
sort isocode
save "C:\JDE Replication\merge4.dta", replace

use "C:\JDE Replication\Soil Quality Data.dta", clear
collapse rooting if rooting>0 & rooting<5, by(isocode)
sort isocode
merge isocode using "C:\JDE Replication\merge4.dta"
drop _merge
sort isocode
save "C:\JDE Replication\merge4.dta", replace

use "C:\JDE Replication\Soil Quality Data.dta", clear
collapse pH if pH>0 & pH<5, by(isocode)
sort isocode
merge isocode using "C:\JDE Replication\merge4.dta"
drop _merge
sort isocode
save "C:\JDE Replication\merge4.dta", replace

use "C:\JDE Replication\Soil Quality Data.dta", clear
collapse nutrient_retention if nutrient_retention>0 & nutrient_retention<5, by(isocode)
sort isocode
merge isocode using "C:\JDE Replication\merge4.dta"
drop _merge
sort isocode
save "C:\JDE Replication\merge4.dta", replace

use "C:\JDE Replication\Soil Quality Data.dta", clear
collapse nutrient_availability if nutrient_availability>0 & nutrient_availability<5, by(isocode)
sort isocode
merge isocode using "C:\JDE Replication\merge4.dta"
drop _merge
sort isocode
save "C:\JDE Replication\merge4.dta", replace

use "C:\JDE Replication\Soil Quality Data.dta", clear
collapse (count) workable=salinity if salinity>0 & salinity<5, by(isocode)
sort isocode
merge isocode using "C:\JDE Replication\merge4.dta"
drop _merge
sort isocode
save "C:\JDE Replication\merge4.dta", replace

use "C:\JDE Replication\Soil Quality Data.dta", clear
collapse (count) nonworkable=salinity if salinity<1 | salinity>4, by(isocode)
sort isocode
merge isocode using "C:\JDE Replication\merge4.dta"
drop _merge
sort isocode
save "C:\JDE Replication\merge4.dta", replace

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
save "C:\JDE Replication\merge3.dta", replace
use "C:\JDE Replication\Workspace.dta", clear
sort countrycode
merge countrycode using "C:\JDE Replication\merge3.dta"
drop _merge

gen popratio=population2005/popsum
gen popratioXgdpppp=popratio*gdppc_ppp
collapse (sum) gdppc_ppp_wtdavg=popratioXgdpppp, by(countrycode)
sort countrycode
save "C:\JDE Replication\merge3.dta", replace
use "C:\JDE Replication\Workspace.dta", clear
sort countrycode
merge countrycode using "C:\JDE Replication\merge3.dta"
drop _merge
gen gdppc_ppp_rel=gdppc_ppp/gdppc_ppp_wtdavg
gen gdppc_rel_wb=gdppc_ppp_rel*gdppcppp_wb
sort isocode
merge isocode using "C:\JDE Replication\merge.dta"
drop _merge
sort isocode
merge isocode using "C:\JDE Replication\merge2.dta"
drop _merge
sort isocode
rename objectid oilandgas
merge isocode using "C:\JDE Replication\merge4.dta"
drop _merge
egen soilquality=rmean(salinity tillage rooting pH oxygen nutrient_retention nutrient_availability)
replace soilquality=-soilquality
drop salinity tillage rooting pH oxygen nutrient_retention nutrient_availability
sort isocode
merge isocode using "C:\JDE Replication\Map Data.dta"
drop _merge

sort isocode
merge isocode using "C:\JDE Replication\Water Data.dta"
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

gen preciousmetals=(gold+ silver+ ruthenium +rhodium +palladium +osmium +iridium+ platinum)/1000
* divide preciousmetals and oilandgas by 1,000 for scaling purposes
replace oilandgas=oilandgas/1000
gen basemetals=copper+ lead+ nickel +zinc +aluminum +bismuth +cobalt +gallium +indium +magnesium +mercury +potassium +titanium +tin +uranium +zirconium
gen alloyants=carbon+manganese+chromium+molybdenum+vanadium+boron+cerium+niobium+tungsten

replace nonworkable=0 if nonworkable==.
replace workable=0 if workable==.
gen workable_pct=workable/(workable+nonworkable) if ~(soilquality==.)

gen preciousmetals_sqkm=preciousmetals/totalarea
gen basemetals_sqkm=basemetals/totalarea
gen iron_sqkm=iron/totalarea
gen alloyants_sqkm=alloyants/totalarea
gen diamond_sqkm=diamond/totalarea
gen oilandgas_sqkm=oilandgas/totalarea
gen lakeriver_sqkm=areaofinlandlakesandmainriverssq/totalarea


keep isocode preciousmetals basemetals_sqkm iron_sqkm alloyants_sqkm diamond oilandgas soilquality workable_pct lakeriver_sqkm
sort isocode
merge isocode using "C:\JDE Replication\mergeall.dta"
drop _merge
sort isocode
save "C:\JDE Replication\mergeall.dta", replace


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

keep isocode pr_all cc_all lo_all re_all  inst_all 

sort isocode
merge isocode using "C:\JDE Replication\mergeall.dta"
drop _merge
sort isocode
save "C:\JDE Replication\mergeall.dta", replace
/* Can't do this without language data (proprietary)
use "C:\JDE Replication\languages.dta", clear
collapse (sum) sum_area=shape_area, by(isocode)
sort isocode
save "C:\JDE Replication\merge.dta", replace

use "C:\JDE Replication\languages.dta", clear
encode familyprop, gen(langcode)
collapse (sum) shape_area, by(isocode langcode)
sort isocode
merge isocode using "C:\JDE Replication\merge.dta"
drop _merge
gen areashare=shape_area/sum_area

forvalues i=1(1)107 {
 gen lang`i'=0
 replace lang`i'=areashare if langcode==`i'
 quietly summ lang`i'
 gen uselang`i'=r(mean)
 replace lang`i'=. if uselang`i'<.001
}

collapse (sum) lang*, by(isocode)

sort isocode
save "C:\JDE Replication\merge.dta", replace


use "C:\JDE Replication\languages.dta", clear
collapse (sum) sum_area=shape_area, by(isocode)
sort isocode
save "C:\JDE Replication\merge2.dta", replace

use "C:\JDE Replication\languages.dta", clear
encode familyprop, gen(langcode)
collapse (sum) shape_area, by(isocode langcode)
sort isocode
merge isocode using "C:\JDE Replication\merge2.dta"
drop _merge
gen areashare=shape_area/sum_area
gen areashare_sq=areashare^2
collapse (sum) herf=areashare_sq, by(isocode)
gen elf=1-herf
sort isocode
merge isocode using "C:\JDE Replication\merge.dta"
drop _merge
sort isocode
save "C:\JDE Replication\merge.dta", replace 

merge isocode using "C:\JDE Replication\mergeall.dta"
drop _merge langcode
sort isocode
save "C:\JDE Replication\mergeall.dta", replace
*/
use "C:\JDE Replication\ethnicities.dta", clear
collapse (sum) sum_area=shape_area, by(isocode)
sort isocode
save "C:\JDE Replication\merge.dta", replace

use "C:\JDE Replication\ethnicities.dta", clear
rename g1id ethcode
collapse (sum) shape_area, by(isocode ethcode)
sort isocode
merge isocode using "C:\JDE Replication\merge.dta"
drop _merge
gen areashare=shape_area/sum_area

forvalues i=1(1)1268 {
 gen eth`i'=0
 replace eth`i'=areashare if ethcode==`i'
 quietly summ eth`i'
 gen useeth`i'=r(mean)
 replace eth`i'=. if useeth`i'<.001
}

collapse (sum) eth*, by(isocode)

sort isocode
merge isocode using "C:\JDE Replication\mergeall.dta"
drop _merge ethcode


set matsize 1400


sort index
merge index using  "C:\JDE Replication\national capitals.dta"
drop _merge
gen nlargestcity=0
replace nlargestcity=1 if ~(nationallargestcity=="")

sort index
merge index using "C:\JDE Replication\education from glls.dta"
drop _merge

sort index
merge index using "C:\JDE Replication\autonomy.dta"
gen autoregion=0
replace autoregion=1 if autonwiki==1
replace autoregion=1 if partautonwiki==1

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
quietly summ oilandgas
gen oilandgasz=(oilandgas-r(mean))/r(sd)
quietly summ diamond
gen diamondz=(diamond-r(mean))/r(sd)
quietly summ preciousmetals
gen preciousmetalsz=(preciousmetals-r(mean))/r(sd)
quietly summ basemetals_sqkm
gen basemetals_sqkmz=(basemetals_sqkm-r(mean))/r(sd)
quietly summ iron_sqkm
gen iron_sqkmz=(iron_sqkm-r(mean))/r(sd)
quietly summ alloyants_sqkm
gen alloyants_sqkmz=(alloyants_sqkm-r(mean))/r(sd)
quietly summ lakeriver_sqkm
gen lakeriver_sqkmz=(lakeriver_sqkm-r(mean))/r(sd)
quietly summ workable_pct
gen workable_pctz=(workable_pct-r(mean))/r(sd)
quietly summ soilquality
gen soilqualityz=(soilquality-r(mean))/r(sd)
quietly summ autoregion
gen autoregionz=(autoregion-r(mean))/r(sd)
quietly summ inst_all
gen inst_allz=(inst_all-r(mean))/r(sd)
quietly summ yearsed
gen yearsedz=(yearsed-r(mean))/r(sd)

gen instXauto=inst_allz*autoregionz

encode country, generate(countrynum)
xtset countrynum

xtreg loggdppc_pppz oceanaccessz logtriz logstormcountz  trop_pctz dtr_avgz oilandgasz diamondz   iron_sqkmz alloyants_sqkmz  soilqualityz , fe cluster(country)
xtreg loggdppc_pppz instXauto oceanaccessz logtriz logstormcountz  trop_pctz dtr_avgz oilandgasz diamondz   iron_sqkmz alloyants_sqkmz  soilqualityz inst_allz autoregionz, fe cluster(country)

xtreg loggdppc_pppz oceanaccessz logtriz logstormcountz  trop_pctz dtr_avgz oilandgasz diamondz   iron_sqkmz alloyants_sqkmz  soilqualityz if nlargestcity==0, fe cluster(country)
xtreg loggdppc_pppz instXauto oceanaccessz logtriz logstormcountz  trop_pctz dtr_avgz oilandgasz diamondz   iron_sqkmz alloyants_sqkmz  soilqualityz  inst_allz autoregionz if nlargestcity==0 , fe cluster(country)

xtreg loggdppc_pppz oceanaccessz logtriz logstormcountz  trop_pctz dtr_avgz oilandgasz diamondz   iron_sqkmz alloyants_sqkmz  soilqualityz  if ~(countrycode=="ALB") & ~(countrycode=="BEN") & ~(countrycode=="BIH") & ~(countrycode=="BFA") & ~(countrycode=="ZAR") & ~(countrycode=="DOM") & ~(countrycode=="EGY") & ~(countrycode=="SLV") & ~(countrycode=="GMB") & ~(countrycode=="GTM") & ~(countrycode=="HND") & ~(countrycode=="JOR") & ~(countrycode=="KEN") & ~(countrycode=="KSV") & ~(countrycode=="LAO") & ~(countrycode=="LBN") & ~(countrycode=="LSO") & ~(countrycode=="MNE") & ~(countrycode=="NPL") & ~(countrycode=="NER") & ~(countrycode=="PRY") & ~(countrycode=="SEN") & ~(countrycode=="SWZ") & ~(countrycode=="SYR") & ~(countrycode=="UGA") & ~(countrycode=="URY") & ~(countrycode=="UZB") & ~(countrycode=="VEN") & ~(countrycode=="ZMB") & ~(countrycode=="ZWE"), fe cluster(country)
xtreg loggdppc_pppz instXauto oceanaccessz logtriz logstormcountz  trop_pctz dtr_avgz oilandgasz diamondz   iron_sqkmz alloyants_sqkmz  soilqualityz inst_allz  autoregionz if ~(countrycode=="ALB") & ~(countrycode=="BEN") & ~(countrycode=="BIH") & ~(countrycode=="BFA") & ~(countrycode=="ZAR") & ~(countrycode=="DOM") & ~(countrycode=="EGY") & ~(countrycode=="SLV") & ~(countrycode=="GMB") & ~(countrycode=="GTM") & ~(countrycode=="HND") & ~(countrycode=="JOR") & ~(countrycode=="KEN") & ~(countrycode=="KSV") & ~(countrycode=="LAO") & ~(countrycode=="LBN") & ~(countrycode=="LSO") & ~(countrycode=="MNE") & ~(countrycode=="NPL") & ~(countrycode=="NER") & ~(countrycode=="PRY") & ~(countrycode=="SEN") & ~(countrycode=="SWZ") & ~(countrycode=="SYR") & ~(countrycode=="UGA") & ~(countrycode=="URY") & ~(countrycode=="UZB") & ~(countrycode=="VEN") & ~(countrycode=="ZMB") & ~(countrycode=="ZWE"), fe cluster(country)

*xtreg loggdppc_pppz oceanaccessz logtriz logstormcountz  trop_pctz dtr_avgz oilandgasz diamondz   iron_sqkmz alloyants_sqkmz  soilqualityz  lang*, fe cluster(country)
*xtreg loggdppc_pppz instXauto oceanaccessz logtriz logstormcountz  trop_pctz dtr_avgz oilandgasz diamondz   iron_sqkmz alloyants_sqkmz  soilqualityz inst_allz autoregionz lang* , fe cluster(country)

xtreg loggdppc_pppz oceanaccessz logtriz logstormcountz  trop_pctz dtr_avgz oilandgasz diamondz   iron_sqkmz alloyants_sqkmz  soilqualityz  eth*, fe cluster(country)
xtreg loggdppc_pppz instXauto oceanaccessz logtriz logstormcountz  trop_pctz dtr_avgz oilandgasz diamondz   iron_sqkmz alloyants_sqkmz  soilqualityz  inst_allz autoregionz eth* , fe cluster(country)

xtreg loggdppc_pppz oceanaccessz logtriz logstormcountz  trop_pctz dtr_avgz oilandgasz diamondz   iron_sqkmz alloyants_sqkmz  soilqualityz yearsedz, fe cluster(country)
xtreg loggdppc_pppz instXauto oceanaccessz logtriz logstormcountz  trop_pctz dtr_avgz oilandgasz diamondz   iron_sqkmz alloyants_sqkmz  soilqualityz yearsedz inst_allz autoregionz , fe cluster(country)

drop _merge
sort isocode
save "C:\JDE Replication\merge2.dta", replace

use "C:\JDE Replication\ethnicities.dta", clear
encode g1shortnam, gen(ethcode)
collapse (sum) shape_area, by(isocode ethcode)
collapse (count) ethcount=ethcode, by(isocode)
sort isocode
merge isocode using "C:\JDE Replication\merge2.dta"
drop _merge


quietly summ ethcount
gen ethcountz=(ethcount-r(mean))/r(sd)
gen ethcountXauto=ethcountz*autoregionz

xtivreg loggdppc_pppz (instXauto=ethcountXauto ethcountz) oceanaccessz logtriz logstormcountz trop_pctz dtr_avgz oilandgasz diamondz iron_sqkmz alloyants_sqkmz  soilqualityz  inst_allz autoregionz , fe first
