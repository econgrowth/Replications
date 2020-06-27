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
merge isocode using "Replication/merge4.dta"
drop _merge
sort isocode
save "Replication/merge4.dta", replace

use "Soil Quality Data.dta", clear
collapse tillage if tillage>0 & tillage<5, by(isocode)
sort isocode
merge isocode using "Replication/merge4.dta"
drop _merge
sort isocode
save "Replication/merge4.dta", replace

use "Soil Quality Data.dta", clear
collapse rooting if rooting>0 & rooting<5, by(isocode)
sort isocode
merge isocode using "Replication/merge4.dta"
drop _merge
sort isocode
save "Replication/merge4.dta", replace

use "Soil Quality Data.dta", clear
collapse pH if pH>0 & pH<5, by(isocode)
sort isocode
merge isocode using "Replication/merge4.dta"
drop _merge
sort isocode
save "Replication/merge4.dta", replace

use "Soil Quality Data.dta", clear
collapse nutrient_retention if nutrient_retention>0 & nutrient_retention<5, by(isocode)
sort isocode
merge isocode using "Replication/merge4.dta"
drop _merge
sort isocode
save "Replication/merge4.dta", replace

use "Soil Quality Data.dta", clear
collapse nutrient_availability if nutrient_availability>0 & nutrient_availability<5, by(isocode)
sort isocode
merge isocode using "Replication/merge4.dta"
drop _merge
sort isocode
save "Replication/merge4.dta", replace

use "Soil Quality Data.dta", clear
collapse (count) workable=salinity if salinity>0 & salinity<5, by(isocode)
sort isocode
merge isocode using "Replication/merge4.dta"
drop _merge
sort isocode
save "Replication/merge4.dta", replace

use "Soil Quality Data.dta", clear
collapse (count) nonworkable=salinity if salinity<1 | salinity>4, by(isocode)
sort isocode
merge isocode using "Replication/merge4.dta"
drop _merge
sort isocode
save "Replication/merge4.dta", replace

use "GDP Data.dta", clear
sort countrycode
merge countrycode using "Country level data.dta"
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
merge countrycode using "Replication/merge3.dta"
drop _merge

gen popratio=population2005/popsum
gen popratioXgdpppp=popratio*gdppc_ppp
collapse (sum) gdppc_ppp_wtdavg=popratioXgdpppp, by(countrycode)
sort countrycode
save "Replication/merge3.dta", replace
use "Replication/Workspace.dta", clear
sort countrycode
merge countrycode using "Replication/merge3.dta"
drop _merge
gen gdppc_ppp_rel=gdppc_ppp/gdppc_ppp_wtdavg
gen gdppc_rel_wb=gdppc_ppp_rel*gdppcppp_wb
sort isocode
merge isocode using "Replication/merge.dta"
drop _merge
sort isocode
merge isocode using "Replication/merge2.dta"
drop _merge
sort isocode
rename objectid oilandgas
merge isocode using "Replication/merge4.dta"
drop _merge
egen soilquality=rmean(salinity tillage rooting pH oxygen nutrient_retention nutrient_availability)
replace soilquality=-soilquality
drop salinity tillage rooting pH oxygen nutrient_retention nutrient_availability
sort isocode
merge isocode using "Map Data.dta"
drop _merge

sort isocode
merge isocode using "Water Data.dta"
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
* divide preciousmetals and oilandgas by 1,000 just for scaling purposes
replace oilandgas=oilandgas/1000
replace diamond=diamond/1000
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

gen preciousmetals_log=log(1+preciousmetals)
gen basemetals_log=log(1+basemetals)
gen iron_log=log(1+iron)
gen alloyants_log=log(1+alloyants)
gen diamond_log=log(1+diamond)
gen oilandgas_log=log(1+oilandgas)
gen lakeriver_log=log(1+areaofinlandlakesandmainriverssq)

gen loggdppc_ppp=log(gdppc_ppp)
gen loggdppc_rel_wb=log(gdppc_rel_wb)


*******STANDARDIZE VARIABLES*******
quietly summ loggdppc_ppp
gen loggdppc_pppz=(loggdppc_ppp-r(mean))/r(sd)
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

encode country, generate (countrynum)
xtset countrynum
xtreg loggdppc_pppz oilandgasz, fe cluster(country)
xtreg loggdppc_pppz diamondz, fe cluster(country)
xtreg loggdppc_pppz preciousmetalsz, fe cluster(country)
xtreg loggdppc_pppz basemetals_sqkmz, fe cluster(country)
xtreg loggdppc_pppz iron_sqkmz, fe cluster(country)
xtreg loggdppc_pppz alloyants_sqkmz, fe cluster(country)
xtreg loggdppc_pppz lakeriver_sqkmz, fe cluster(country)
xtreg loggdppc_pppz workable_pctz, fe cluster(country)
xtreg loggdppc_pppz soilqualityz, fe cluster(country)
xtreg loggdppc_pppz oilandgasz diamondz preciousmetalsz basemetals_sqkmz iron_sqkmz alloyants_sqkmz lakeriver_sqkmz workable_pctz soilqualityz, fe cluster(country)


* Interactions

gen ruleoflawz=(ruleoflaw-r(mean))/r(sd)

gen oilandgaszXrule=oilandgasz*ruleoflaw
gen diamondzXrule=diamondz*ruleoflaw
gen preciousmetalszXrule=preciousmetalsz*ruleoflaw
gen basemetals_sqkmzXrule=basemetals_sqkmz*ruleoflaw
gen iron_sqkmzXrule=iron_sqkmz*ruleoflaw
gen alloyants_sqkmzXrule=alloyants_sqkmz*ruleoflaw
gen lakeriver_sqkmzXrule=lakeriver_sqkmz*ruleoflaw
gen workable_pctzXrule=workable_pctz*ruleoflaw
gen soilqualityzXrule=soilqualityz*ruleoflaw

xtreg loggdppc_pppz oilandgaszXrule diamondzXrule preciousmetalszXrule basemetals_sqkmzXrule iron_sqkmzXrule alloyants_sqkmzXrule lakeriver_sqkmzXrule workable_pctzXrule soilqualityzXrule oilandgasz diamondz preciousmetalsz basemetals_sqkmz iron_sqkmz alloyants_sqkmz lakeriver_sqkmz workable_pctz soilqualityz, fe cluster(country) 


