*This do-file takes the raw latinobarometro data and prepares it for merging with other data.

set more off

use "latinobarometro2005.dta", clear

*REMOVE UNUSABLE SCORES
replace p40stb=. if p40stb<1 | p40stb>4
replace p42std=. if p42std<1 | p42std>4
replace p82stb=. if p82stb<1 | p82stb>2
replace p84st=. if p84st<0 | p84st>100
replace p42stf=. if p42stf<1 | p42stf>4
replace p76st=. if p76st<1 | p76st>10
replace p82sta=. if p82sta<1 | p82sta>2
replace p30st=. if p30st<1 | p30st>5
replace p40std=. if p40std<1 | p40std>4
replace p42ste=. if p42ste<1 | p42ste>4



*CLEAN DATA
rename idenpa country

replace reg = ciudad if country==4

label define REG 4005001	"antioquia" 4005347	"antioquia" 4008001	"atlantico" 4008685	"atlantico" 4011001	"bogota" 4013188	"bolivar" 4013244	"bolivar" 4015238	"boyaca" 4015673	"boyaca"   4017174	"caldas" 4019100	"bolivar" 4019513	"cauca" 4023417	"cordoba" 4025596	"cundinamarca" 4025754	"cundinamarca" 4041791	"huila" 4044098	"guajira" 4047189	"magdalena" 4050006	"meta" 4050245	"santander" 4052210	"narino" 4052356	"narino" 4063130	"quindio" 4066170	"risaralda" 4066400	"risaralda" 4068001	"santander" 4070713	"sucre" 4073270	"tolima" 4076001	"valle" 4076109	"valle" 4076616	"sucre" 4076622	"valle" 4091001	"amazonas", add
replace reg=4005001 if reg==4005347
replace reg=4008001 if reg==4008685
replace reg=4013188 if reg==4013244 | reg==4019100
replace reg=4015238 if reg==4015673
replace reg=4025596 if reg==4025754
replace reg=4050245 if reg==4068001
replace reg=4052210 if reg==4052356
replace reg=4066170 if reg==4066400
replace reg=4070713 if reg==4076616
replace reg=4076001 if reg==4076109 | reg==4076622

sort ciudad
merge m:m ciudad using "brazil city to state merge.dta"
encode brazil_state, gen(brazilstate)
replace reg=brazilstate if country==3

label define REG 1 "Alagoas" 2 "Amazonas" 3 "Bahia" 4 "Cear·" 5 "EspÌrito Santo" 6 "Federal District" 7 "Goi·s" 8 "Maranh„o" 9 "Mato Grosso" 10 "Mato Grosso do Sul" 11 "Minas Gerais" 12 "Paran·" 13 "ParaÌba" 14 "Par·" 15 "Pernambuco" 16 "PiauÌ" 17 "Rio De Janeiro" 18 "Rio Grande do Norte" 19 "Rio Grande do Sul" 20  "RondÙnia" 21 "Santa Catarina" 22 "Sergipe" 23 "S„o Paulo" 24 "Tocantins", add

rename reg region



*AVERAGE DATA
collapse p40stb p42std p82stb p84st p42stf p76st p82sta p30st p40std p42ste, by(country region)


*STANDARDIZE SCORES
egen Sp40stb=std(-p40stb)
egen Sp42std=std(-p42std)
egen Sp82stb=std(p82stb)
egen Sp84st=std(-p84st)
egen Sp42stf=std(-p42stf)
egen Sp76st=std(p76st)
egen Sp82sta=std(p82sta)
egen Sp30st=std(-p30st)
egen Sp40std=std(-p40std)
egen Sp42ste=std(-p42ste)



*CREATE INDICES
egen pr_lbo=rmean(Sp40stb Sp42std)
egen cc_lbo=rmean(Sp82stb Sp84st)
egen lo_lbo=rmean(Sp42stf Sp76st Sp82sta )
egen re_lbo=rmean(Sp30st Sp40std Sp42ste)
egen prpos_lbo=rmean(Sp40stb Sp42std)
egen ccpos_lbo=rmean(Sp84st)
egen lopos_lbo=rmean(Sp42stf Sp76st )
egen repos_lbo=rmean(Sp30st Sp40std Sp42ste)
egen comp_lbo=rmean(pr_lbo cc_lbo lo_lbo re_lbo)
egen comp2_lbo=rmean(Sp40stb Sp42std Sp82stb Sp84st Sp42stf Sp76st Sp82sta Sp30st Sp40std Sp42ste)
egen comppos_lbo=rmean(Sp40stb Sp42std  Sp84st Sp42stf Sp76st  Sp30st Sp40std Sp42ste)
 

  
*INDEX FOR MERGING
keep country region comp_lbo comp2_lbo comppos_lbo pr_lbo cc_lbo lo_lbo re_lbo prpos_lbo ccpos_lbo lopos_lbo repos_lbo 
sort country region
gen index_lbo=[_n]
order index country region

save "latinobarometro", replace
