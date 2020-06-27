*This do-file takes the raw LAPOP data and prepares it for merging with other data.

set more off

*COMBINE DATASETS
use "lapop2006us.dta", clear
gen country=41

replace state1=state1+100
rename state1 Provincia
rename B1 b1
rename B2 b2
rename B3 b3
rename B10A b10a
rename EXC7 exc7
rename EXC6 exc6
rename VIC1 vic1
rename AOJ11 aoj11

sort country Provincia
save "Replication/merge5.dta", replace

use "lapop2006can.dta", clear
gen country=40

encode province, generate(Provincia)

rename B1 b1
rename B2 b2
rename B3 b3
rename B10A b10a
rename EXC7 exc7
rename EXC6 exc6
rename VIC1 vic1
rename AOJ11 aoj11
sort country Provincia
save "Replication/merge6.dta", replace

use "lapop2006arg.dta", clear
rename pais country
rename prov Provincia
sort country Provincia
save "Replication/merge7.dta", replace

use "lapop2006chl.dta", clear
keep idnum chiregio
sort idnum chiregio
save "Replication/merge8.dta", replace

use "lapop2006.dta", clear
rename pais country
drop if country ==5 | country==6 | country==22 | country==23 | country==24 | country==40 | country==41

sort country Provincia
merge m:m country Provincia using "Replication/merge5.dta", update

drop _merge

sort country Provincia
merge m:m country Provincia using "Replication/merge6.dta", update
drop _merge

sort country Provincia
merge m:m country Provincia using "Replication/merge7.dta", update
drop _merge

sort idnum
merge m:m idnum using "Replication/merge8.dta", update
drop _merge
replace chiregio=chiregio+1300
replace Provincia=chiregio if country==13
drop chiregio

label define Provincia    1 "AB" 2 "BC"  3 "MB" 4 "NB"   5 "NL" 6 "NS" 7 "NT" 8 "ON"  9 "PE" 10 "QC" 11 "SK" 12 "YT" 101 "AL" 102 "AR" 103 "AZ" 104 "CA" 105 "CO" 106 "CT"  107 "DC" 108 "DE" 109 "FL" 110 "GA" 111 "IA" 112 "ID" 113 "IL"  114 "IN" 115 "KS" 116 "KY"  117 "LA"       118 "MA"  119 "MD"  120 "ME"   121 "MI"  122 "MN" 123 "MO"  124 "MS"  125 "MT"   126 "NC"  127 "ND" 128 "NE" 129 "NH"  130 "NJ" 131 "NM" 132 "NV"  133 "NY"  134 "OH" 135 "OK"  136 "OR"  137 "PA"  138 "RI"  139 "SC" 140 "SD" 141 "TN"  142 "TX"  143 "UT"  144 "VA" 145 "VT" 146 "WA" 147 "WI" 148 "WV" 149 "WY"          1701 "Buenos Aires" 1702 "CÛrdova"   1703 "Santa FÈ" 1704 "Entre RÌos" 1705 "Misiones"  1706 "Corrientes"  1707 "Chaco" 1708 "Formosa" 1709 "Salta" 1710 "Santiago del Estero"  1711 "Tucum·n" 1712 "Catamarca"  1713 "Jujuy"  1714 "Mendoza"  1715 "San Juan" 1716 "San Luis" 1717 "La Rioja" 1718 "Chubut" 1719 "NeuquÈn" 1720 "RÌo Negro" 1721 "Tierra del Fuego" 1301 "Tarapaca" 1302 "Antofagasta" 1303 "Atacama" 1304 "Coquimbo" 1305 "Valparaiso" 1306 "O'Higgins" 1307 "Maule" 1308 "Biobio" 1309 "Araucania" 1310 "Los Lagos" 1311 "Aisen" 1312 "Magallanes" 1313 "RM Santiago" 16001 "DC" 16002 "Miranda" 16003 "Vargas" 16004 "Zulia" 16005 "Merida" 16006 "Tachira" 16007 "Trujillo" 16008 "Aragua" 16009 "Carabobo" 16010 "Cojedes" 16011 "Lara" 16012 "Yaracuy" 16013 "Anzoategui" 16014 "Sucre" 16015 "Monagas" 16016 "Bolivar" 16017 "Apure" 16018 "Barinas" 16019 "Portuguesa" 16020 "Guarico", add
label define pais 17 "Argentina", add



*REMOVE UNUSABLE SCORES
replace aoj12=. if aoj12<1 | aoj12>4
replace st2=. if st2<1 | st2>4
replace st3=. if st3<1 | st3>4
replace b1=. if b1<1 | b1>7
replace b3=. if b3<1 | b3>7
replace b10a=. if b10a<1 | b10a>7
replace b16=. if b16<1 | b16>7
replace b17=. if b17<1 | b17>7
replace exc2=. if exc2<0 | exc2>1
replace exc6=. if exc6<0 | exc6>1
replace exc7=. if exc7<1 | exc7>4
replace exc11=. if exc11<0 | exc11>1
replace exc14=. if exc14<0 | exc14>1
replace exc15=. if exc15<0 | exc15>1
replace exc16=. if exc16<0 | exc16>1
replace exc17=. if exc17<0 | exc17>1
replace n9=. if n9<1 | n9>7
replace vic1=. if vic1<1 | vic1>2
replace aoj11=. if aoj11<1 | aoj11>4
replace aoj18=. if aoj18<1 | aoj18>2
replace n11=. if n11<1 | n11>7
replace b32=. if b32<1 | b32>7
replace st4=. if st4<1 | st4>4
replace sgl1=. if sgl1<1 | sgl1>5



*CLEAN DATA
replace Provincia=4009 if Provincia==4014
replace Provincia=4010 if Provincia==4015
replace Provincia=4012 if Provincia==4016
replace Provincia=4013 if Provincia==4017

replace Provincia=21001 if Provincia==21032

replace Provincia=estratopri if country==10
replace Provincia=Provincia+9000 if country==10
label define Provincia 10001 "La Paz" 10002 "Santa Cruz" 10003 "Cochabamba" 10004 "Oruro" 10005 "Chuqisaca" 10006 "Potosi" 10007 "Pando" 10008 "Tarija" 10009 "Beni", add

drop region
rename Provincia region
 
 

*AVERAGE DATA
collapse sgl1   vic1 aoj11 aoj12 aoj18 st2 st3 st4 b1 b3 b10a b32 b16 b17 n3 n9 n11  exc2 exc6 exc11 exc14 exc15 exc16 exc17 exc7, by(country region)



*STANDARDIZE SCORES
egen Ssgl1 = std(-sgl1)
egen Svic1 = std(vic1)
egen Saoj11 = std(-aoj11)
egen Saoj12= std(-aoj12)
egen Saoj18= std(-aoj18)
egen Sst2 = std(-st2)
egen Sst3 = std(-st3)
egen Sst4= std(-st4)
egen Sb1= std(b1)
egen Sb3= std(b3)
egen Sb10a= std(b10a)
egen Sb32 = std(b32)
egen Sb16 = std(b16)
egen Sb17 = std(b17)
egen Sn9 = std(n9)
egen Sn11= std(n11)
egen Sexc2 = std(-exc2)
egen Sexc6= std(-exc6)
egen Sexc11 = std(-exc11)
egen Sexc14 = std(-exc14)
egen Sexc15 = std(-exc15)
egen Sexc16 = std(-exc16)
egen Sexc17 = std(-exc17)
egen Sexc7= std(exc7)



*CREATE INDICES
egen pr_lapop=rmean(Saoj12 Sst2 Sst3 Sb1  Sb3 Sb10a Sb16 Sb17)
egen cc_lapop=rmean(Sexc2 Sexc6 Sexc7 Sexc11 Sexc14 Sexc15 Sexc16 Sexc17 Sn9)
egen lo_lapop=rmean(Svic1 Saoj11 Saoj18 Sn11)
egen re_lapop=rmean(Sb32 Sst4 Ssgl1)
egen prpos_lapop=rmean(Sst2 Sst3 Sb1  Sb3 Sb10a Sb16 Sb17)
egen ccpos_lapop=rmean(Sexc2 Sexc7  Sn9)
egen lopos_lapop=rmean(Saoj11 Sn11)
gen repos_lapop=.
egen comp_lapop=rmean(pr_lapop cc_lapop lo_lapop re_lapop)
egen comp2_lapop=rmean(Saoj12 Sst2 Sst3 Sb1  Sb3 Sb10a Sb16 Sb17 Sexc2 Sexc6 Sexc7 Sexc11 Sexc14 Sexc15 Sexc16 Sexc17 Sn9 Svic1 Saoj11 Saoj18 Sn11 Sb32 Sst4 Ssgl1)
egen comppos_lapop=rmean(Sst2 Sst3 Sb1  Sb3 Sb10a Sb16 Sb17 Sexc2 Sexc7 Sn9 Svic1 Saoj11 Sn11 )
 

 
*INDEX FOR MERGING
keep country region comp_lapop comp2_lapop comppos_lapop pr_lapop cc_lapop lo_lapop re_lapop prpos_lapop ccpos_lapop lopos_lapop repos_lapop
sort country region
gen index_lapop=[_n]
order index country region
 
save "lapopdata", replace
