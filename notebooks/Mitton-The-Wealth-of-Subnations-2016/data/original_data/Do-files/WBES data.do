*This do-file takes the raw WBES data and prepares it for merging with other data.

set more off

use "world bank enterprise survey.dta", clear
sort idstd
merge m:m idstd using "wbes cityregions.dta"
drop _merge
replace a2x=cityregion if ~(cityregion=="")


*REMOVE UNUSABLE SCORES
replace c4=. if c4<0
replace c5 =. if c5<1 | c5>2
replace c13 =. if c13<0
replace c14 =. if c14<1 | c14>2
replace c20 =. if c20<0
replace c21 =. if c21<1 | c21>2
replace d30b =. if d30b<0 | d30b>4
replace g3 =. if g3<0
replace g4 =. if g4<1 | g4>2
replace h3 =. if h3<1 | h3>2
replace h4 =. if h4<0
replace h5 =. if h5<1 | h5>2
replace h6 =. if h6<0
replace h7a =. if h7a<1 | h7a>4
replace h7b =. if h7b<1 | h7b>4
replace h7c =. if h7c<1 | h7c>4
replace h7d =. if h7d<1 | h7d>4
replace h30 =. if h30<0 | h30>4
replace i1 =. if i1<1 | i1>2
replace i2a =. if i2a<0
replace i4a =. if i4a<0
replace i30 =. if i30<0 | i30>4
replace j1b =. if j1b<1 | j1b>4
replace j2 =. if j2<0 | j2>100
replace j5 =. if j5<1 | j5>2
replace j6 =. if j6<0
replace j7a =. if j7a<0
replace j11 =. if j11<0
replace j12 =. if j12<1 | j12>2
replace j14 =. if j14<0
replace j15 =. if j15<1 | j15>2
replace j30c =. if j30c<0 | j30c>4
replace j30e =. if j30e<0 | j30e>4
replace j30f=. if j30f<0 | j30f>4



*DATA CLEANUP
replace a2x="Cordoba" if a2x=="CÛRdoba"
replace a2x="Bogota" if a2x=="Bogot·"
replace a2x="Antofagasta" if a2x=="Ii RegiÛN (Antofasgstata)"
replace a2x="Santiago" if a2x=="Rm (Santiago)"
replace a2x="Valparaiso" if a2x=="V RegiÛN (ValparaÌSo)"
replace a2x="Valparaiso" if a2x=="ValparaÌSo"
replace a2x="Los Lagos" if a2x=="X RegiÛN (Los Lagos)"
replace a2x="Medellin" if a2x=="MedellÌN"
replace a2x="Rest of the country" if a2x=="Resto Del Pais"
replace a2x="Rest of the country" if a2x=="Rest of The Country"
replace a2x="Rest of the country" if a2x=="Rest Of The Country"
replace a2x="Asuncion" if a2x=="AsunciÛN"
replace a2x="Mogilev" if a2x=="Mogilevskaya"
replace a2x="Sarajevo" if a2x=="Sarajevo Region"
replace a2x="Kosovska Mitrovica" if a2x=="Mitrovice"
replace a2x="Jalal-Abad" if a2x=="Jalalabat"
replace a2x="Ysyk-Kˆl" if a2x=="Issik Kul Oblast"
replace a2x="Vilnius County" if a2x=="Vilniaus"
replace a2x="Samarkand" if a2x=="Samarkandskaya"



rename country countryyear
gen year=real(substr(countryyear,length(countryyear)-3,4))
gen country=substr(countryyear,1,length(countryyear)-4)

replace country="ElSalvador" if country=="Elsalvador"

* Drop countries not included in my dataset
drop if country=="Afghanistan" | country=="Angola" | country=="Antiguaandbarbuda" | country=="Armenia" | country=="Azerbaijan" | country=="Bahamas" | country=="Barbados" | country=="Belize" | country=="Bhutan" | country=="Botswana" | country=="Burundi" | country=="Cameroon" | country=="CapeVerde" | country=="Centralafricanrepublic" | country=="Chad" | country=="Congo" | country=="Costarica" | country=="Dominica" | country=="Eritrea" | country=="Fiji" | country=="Gabon" | country=="Ghana" | country=="Grenada" | country=="Guinea" | country=="GuineaBissau" | country=="Guyana" | country=="Iraq" | country=="Ivory Coast" | country=="Jamaica" | country=="Liberia" | country=="Madagascar" | country=="Malawi" | country=="Mali" | country=="Mauritania" | country=="Mauritius" | country=="Moldova" | country=="Namibia" | country=="Nicaragua" | country=="Rwanda" | country=="Samoa" |  country=="Sierra Leone" | country=="StKittsandNevis" | country=="StLucia" | country=="StVincentandGrenadines" | country=="Suriname" | country=="Tajikistan" | country=="Timor Leste" | country=="Togo" | country=="Tonga" | country=="TrinidadandTobago" | country=="Yemen" | country=="Vanuatu" | country=="Lesotho" | country=="Micronesia"
* Drop later countryyears if earlier year available
drop if countryyear=="Argentina2010" | countryyear=="Bolivia2010" | countryyear=="Chile2010" | countryyear=="Colombia2010" | countryyear=="DRC2010" | countryyear=="Ecuador2010" | countryyear=="Guatemala2010" | countryyear=="Mexico2010" | countryyear=="Paraguay2010" | countryyear=="Peru2010" | countryyear=="Uruguay2010" | countryyear=="Venezuela2010" | countryyear=="ElSalvador2010" | countryyear=="Honduras2010"

*(This makes the WBES data average across regions that are treated as one in the main data.)
replace a2x="Shida Kartli" if a2x=="Mmtskheta-Mtianeti"
replace a2x="punjab" if a2x=="Faisalabad" | a2x=="Gujranwala" | a2x=="Lahore" | a2x=="Sheikhupura" | a2x=="Sialkot" | a2x=="Wazirabad"
replace a2x="balochistan" if a2x=="Hub" | a2x=="Quetta"
replace a2x="sindh" if a2x=="Hyderabad" | a2x=="Karachi" | a2x=="Sukkur"
replace a2x="Panama" if a2x=="Ciudad De Panam·"
replace a2x="Manila" if a2x=="National Capital Region (Excl: Manila)"
replace a2x="Sumadija and Western Serbia" if a2x=="Central Sebia" | a2x=="West Serbia"
replace a2x="Southern and Eastern Serbia" if a2x=="East Serbia" | a2x=="South Serbia"
replace a2x="Eastern" if a2x=="Jinja" | a2x=="Mbale"
replace a2x="Copperbelt" if a2x=="Kitwe" | a2x=="Ndola"
replace a2x="Manzini" if a2x=="Matsapha"

drop region
rename a2x region
* Drop regions that cannot be placed in defined subnational regions
drop if region=="Bosnia Region" | region=="Yugozapaden" | region=="Yuzhen Tsentralen" | (region=="North-West" & country=="Czech Republic") | (region=="South-East" & country=="Czech Republic") | region=="Eastern Macedonia Region" | region=="East Hungary" | (region=="East" & country=="Kazakhstan") | (region=="North" & country=="Kazakhstan") | (region=="South" & country=="Kazakhstan") | (region=="West" & country=="Kazakhstan") | (region=="Coast And West" & country=="Lithuania") | (region=="North East" & country=="Lithuania") | (region=="South West" & country=="Lithuania") | (region=="Central Region" & country=="Poland") | (region=="Eastern Region" & country=="Poland") | (region=="North-Western Region" & country=="Poland") | (region=="Northern Region" & country=="Poland") | (region=="South-Western Region" & country=="Poland") | (region=="North-East" & country=="Romania") | (region=="North-West" & country=="Romania") | (region=="South-East" & country=="Romania") | region=="South Muntenia" | region=="South-West Oltenia"  | (region=="West" & country=="Romania") | (region=="Central" & country=="Russia")  | (region=="Far East" & country=="Russia")  | (region=="South" & country=="Russia") | region=="Vzhodna Slovenija" | region=="Zahodna Slovenija" | region=="Black Sea - Eastern" | region=="Marmara" | (region=="South" & country=="Turkey") | (region=="East" & country=="Turkey") | (region=="North" & country=="Ukraine") | (region=="South" & country=="Ukraine") | (region=="West" & country=="Ukraine") | (region=="East" & country=="Ukraine") 


*AVERAGE DATA
collapse c4 c5 c13 c14 c20 c21 d30b g3 g4 h3 h4 h5 h6 h7a h7b h7c h7d h30 i1 i2a i4a i30 j1b j2 j5 j6 j7a j11 j12 j14 j15 j30c j30e j30f, by(country region)



*STANDARDIZE SCORES
egen Sc4=std(-ln(c4)) 
egen Sc5 =std( c5 ) 
egen Sc13 =std(-ln(c13)) 
egen Sc14 =std(c14  ) 
egen Sc20 =std(-ln(c20)) 
egen Sc21 =std( c21 ) 
egen Sd30b =std( -d30b ) 
egen Sg3 =std(-ln(g3)) 
egen Sg4 =std( g4 ) 
egen Sh3 =std( -h3 ) 
egen Sh4 =std(-ln(h4)) 
egen Sh5 =std( -h5 ) 
egen Sh6 =std(-ln(h6)) 
egen Sh7a =std( h7a ) 
egen Sh7b =std( h7b ) 
egen Sh7c =std( h7c ) 
egen Sh7d =std( h7d ) 
egen Sh30 =std( -h30 ) 
egen Si1 =std( i1 ) 
egen Si2a =std( -ln(i2a) ) 
egen Si4a =std( -ln(i4a) ) 
egen Si30 =std( -i30 ) 
egen Sj1b =std( -j1b ) 
egen Sj2 =std( -j2 ) 
egen Sj5 =std( j5 ) 
egen Sj6 =std( -ln(j6) ) 
egen Sj7a =std( -ln(j7a) ) 
egen Sj11 =std(-ln(j11)) 
egen Sj12 =std( j12 ) 
egen Sj14 =std(-ln(j14)) 
egen Sj15 =std( j15 ) 
egen Sj30c =std( -j30c ) 
egen Sj30e =std( -j30e )
egen Sj30f=std( -j30f ) 




*CREATE INDICES
egen pr_wbes=rmean(Sh3 Sh4 Sh5 Sh6 Sh7a Sh7b Sh7c Sh7d Sh30)
egen cc_wbes=rmean(Sc5 Sc14 Sc21 Sg4 Sj1b Sj5 Sj6 Sj7a Sj12 Sj15 Sj30f)
egen lo_wbes=rmean(Si1 Si2a Si4a Si30 Sj30e)
egen re_wbes=rmean(Sc4 Sc13 Sc20 Sd30b Sg3 Sj2 Sj11 Sj14 Sj30c)
egen prpos_wbes=rmean(Sh5 Sh7a )
egen ccpos_wbes=rmean(Sc5 Sc14 Sc21 Sg4 Sj1b Sj5 Sj6 Sj12 Sj15 )
egen lopos_wbes=rmean(Si2a Si4a )
egen repos_wbes=rmean(Sd30b )
egen comp_wbes=rmean(pr_wbes cc_wbes lo_wbes re_wbes)
egen comp2_wbes=rmean(Sh3 Sh4 Sh5 Sh6 Sh7a Sh7b Sh7c Sh7d Sh30 Sc5 Sc14 Sc21 Sg4 Sj1b Sj5 Sj6 Sj7a Sj12 Sj15 Sj30f Si1 Si2a Si4a Si30 Sj30e Sc4 Sc13 Sc20 Sd30b Sg3 Sj2 Sj11 Sj14 Sj30c)
egen comppos_wbes=rmean(Sh5 Sh7a Sc5 Sc14 Sc21 Sg4 Sj1b Sj5 Sj6  Sj12 Sj15 Si2a Si4a Sd30b)





*INDEX FOR MERGING
keep country region comp_wbes comp2_wbes comppos_wbes pr_wbes cc_wbes lo_wbes re_wbes prpos_wbes ccpos_wbes lopos_wbes repos_wbes 
sort country region
gen index_wbes=[_n]
order index country region

save "WBESdata", replace



