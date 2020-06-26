*This do-file takes the raw TAF data and prepares it for merging with other data.

set more off

*****FILE 1: Bangladesh
use "TAF BGD.dta", clear

*REMOVE UNUSABLE SCORES



*CLEAN DATA



*AVERAGE DATA
collapse  entry land time informal law dispute, by(division)



*STANDARDIZE SCORES
egen Sentry=std(entry)
egen Sland=std(land)
egen Stime=std(time)
egen Sinformal=std(informal)
egen Slaw=std(law)
egen Sdispute=std(dispute)



*CREATE INDICES
egen pr_taf=rmean(Sdispute Sland)
gen cc_taf=Sinformal
gen lo_taf=Slaw
egen re_taf=rmean(Sentry Stime)
egen prpos_taf=rmean(Sdispute Sland)
gen ccpos_taf=Sinformal
gen lopos_taf=Slaw
egen repos_taf=rmean(Sentry Stime)
egen comp_taf=rmean(pr_taf cc_taf lo_taf re_taf)
egen comp2_taf=rmean(Sdispute Sland Sinformal Slaw Sentry Stime)
egen comppos_taf=rmean(Sdispute Sland Sinformal Slaw Sentry Stime)



*PREPARE FOR MERGING
rename division region
gen country="BGD"
 
keep country region comp_taf comp2_taf comppos_taf pr_taf cc_taf lo_taf re_taf prpos_taf ccpos_taf lopos_taf repos_taf 
order country region
sort country region

save "Replication/merge1.dta", replace





*****FILE 2: Indonesia
use "TAF IDN.dta", clear

*REMOVE UNUSABLE SCORES



*CLEAN DATA



*AVERAGE DATA
collapse  land security licensing regulation, by(province)



*STANDARDIZE SCORES
egen Sland=std(land)
egen Ssecurity=std(security)
egen Slicensing=std(licensing)
egen Sregulation=std(regulation)



*CREATE INDICES
gen pr_taf=Sland
gen lo_taf=Ssecurity
egen re_taf=rmean(Slicensing Sregulation)
egen comp_taf=rmean(pr_taf lo_taf re_taf)
egen comp2_taf=rmean(Sland Ssecurity Slicensing Sregulation)

 
 
 
*PREPARE FOR MERGING
rename province region
gen country="IDN"
 
keep country region comp_taf comp2_taf pr_taf lo_taf re_taf 
order country region
sort country region

merge m:m country region using "Replication/merge1.dta"
drop _merge
sort country region
save "Replication/merge1.dta", replace





*****FILE 3: Sri Lanka
use "TAF LKA.dta", clear

*REMOVE UNUSABLE SCORES



*CLEAN DATA



*AVERAGE DATA
collapse legal land informal security registration regulation, by(province)



*STANDARDIZE SCORES
egen Slegal=std(legal)
egen Sland=std(land)
egen Sinformal=std(informal)
egen Ssecurity=std(security)
egen Sregistration=std(registration)
egen Sregulation=std(regulation)



*CREATE INDICES
egen pr_taf=rmean(Slegal Sland)
gen cc_taf=Sinformal
gen lo_taf=Ssecurity
egen re_taf=rmean(Sregistration Sregulation)
egen comp_taf=rmean(pr_taf cc_taf lo_taf re_taf)
egen comp2_taf=rmean(Slegal Sland Sinformal Ssecurity Sregistration Sregulation)



*PREPARE FOR MERGING
rename province region
gen country="LKA"
 
keep country region comp_taf comp2_taf pr_taf cc_taf lo_taf re_taf 
order country region
sort country region

merge m:m country region using "Replication/merge1.dta"
drop _merge
sort country region
save "Replication/merge1.dta", replace





*FILE 4: Malaysia
use "TAF MYS.dta", clear

*REMOVE UNUSABLE SCORES



*CLEAN DATA



*AVERAGE DATA
collapse entry regulatory informal crime land property, by(state)



*STANDARDIZE SCORES
egen Sentry=std(entry)
egen Sregulatory=std(regulatory)
egen Sinformal=std(informal)
egen Scrime=std(crime)
egen Sland=std(land)
egen Sproperty=std(property)



*CREATE INDICES
egen pr_taf=rmean(Sproperty Sland)
gen cc_taf=Sinformal
gen lo_taf=Scrime
egen re_taf=rmean(Sentry Sregulatory)
egen comp_taf=rmean(pr_taf cc_taf lo_taf re_taf)
egen comp2_taf=rmean(Sproperty Sland Sinformal Sentry Sregulatory)
 
 
 
*PREPARE FOR MERGING
rename state region
gen country="MYS"
 
keep country region comp_taf comp2_taf pr_taf cc_taf lo_taf re_taf 
order country region
sort country region

merge country region using "Replication/merge1.dta"
drop _merge
sort country region
save "Replication/merge1.dta", replace





*****FILE 5: Vietnam
use "TAF VNM.dta", clear

*REMOVE UNUSABLE SCORES



*CLEAN DATA



*AVERAGE DATA
collapse entry land time informal legal, by(province)



*STANDARDIZE SCORES
egen Sentry=std(entry)
egen Sinformal=std(informal)
egen Stime=std(time)
egen Sland=std(land)
egen Slegal=std(legal)



*CREATE INDICES
egen pr_taf=rmean(Slegal Sland)
gen cc_taf=Sinformal
egen re_taf=rmean(Sentry Stime)
egen comp_taf=rmean(pr_taf cc_taf re_taf)
egen comp2_taf=rmean(Slegal Sland Sinformal Sentry Stime)




*PREPARE FOR MERGING
rename province region
gen country="VNM"
 
keep country region comp_taf comp2_taf pr_taf cc_taf re_taf 
order country region
sort country region

merge m:m country region using "Replication/merge1.dta"
drop _merge
sort country region
save "Replication/merge1.dta", replace





*****FILE 6: Nepal
use "TAF NPL raw.dta", clear

*REMOVE UNUSABLE SCORES
replace c4iii_4=. if c4iii_4<1
replace d6=. if d6<1 | d6>5
replace d7=. if d7<1 | d7>5
replace e2=. if e2<1 | e2>5
replace h1=. if h1<1 | h1>2
replace h5=. if h5<1 | h5>5
replace h11a=. if h11a<1 | h11a>5
replace j1=. if j1<1 | j1>2
replace j3a_1=. if j3a_1<1 | j3a_1>2
replace n1=. if n1<1 | n1>365



*CLEAN DATA
gen region="western" if district==1 | district==3
replace region="eastern" if district==4
replace region="midwestern" if district==5



*AVERAGE DATA
collapse c4iii_4 d6 d7 e2 h1 h5 h11a j1 j3a_1 n1 , by(region)

/*collapse c4iii_4 d6 d7 e2 h1 h5 h11a j1 j3a_1 n1 (semean)  ec4iii_4=c4iii_4 ed6=d6 ed7=d7 ee2=e2 eh1=h1 eh5=h5 eh11a=h11a ej1=j1 ej3a_1=j3a_1 en1=n1, by(region)
gen cv_max=.25
replace c4iii_4=. if ec4iii_4/c4iii_4>cv_max
replace d6=. if ed6/d6>cv_max
replace d7=. if ed7/d7>cv_max
replace e2=. if ee2/e2>cv_max
replace h1=. if eh1/h1>cv_max
replace h5=. if eh5/h5>cv_max
replace h11a=. if eh11a/h11a>cv_max
replace j1=. if ej1/j1>cv_max
replace j3a_1=. if ej3a_1/j3a_1>cv_max
replace n1=. if en1/n1>cv_max */


*STANDARDIZE SCORES
egen Sdoc=std(-ln(c4iii_4))
egen Srent=std(d6)
egen Sevict=std(d7)
egen Scontract=std(e2)
egen Sbribe=std(h1)
egen Sinformal=std(h5)
egen Sprocurement=std(h11a)
egen Scrime=std(j1)
egen Spolice=std(j3a_1)
egen Stime=std(-ln(n1))


*CREATE INDICES
egen pr_taf=rmean(Srent Sevict Scontract)
egen cc_taf=rmean(Sinformal Sbribe Sprocurement)
egen lo_taf=rmean(Scrime Spolice)
egen re_taf=rmean(Sdoc Stime)
egen comp_taf=rmean(pr_taf cc_taf lo_taf re_taf)
egen comp2_taf=rmean(Srent Sevict Scontract Sinformal Sbribe Sprocurement Scrime Spolice Sdoc Stime)
 
 
 
*PREPARE FOR MERGING
gen country="NPL"
 
keep country region comp_taf comp2_taf pr_taf cc_taf lo_taf re_taf
order country region
sort country region

merge m:m country region using "Replication/merge1.dta"
drop _merge
sort country region
save "Replication/merge1.dta", replace





*****FILE 7: Thailand
use "TAF THA raw.dta", clear

*REMOVE UNUSABLE SCORES
replace q42=. if q42<1 | q42>5
replace q43=. if q43<1 | q43>5
replace q51=. if q51<1 | q51>3
replace q54=. if q54<1 | q54>3
replace q57=. if q57<1 | q57>4
replace q57=5-q57
replace q67=. if q67<1 | q67>4
replace q69=. if q69<1 | q69>4
replace q69=5-q69
replace q77=. if q77<1 | q77>3


*CLEAN DATA
decode povince, gen(province)



*AVERAGE DATA
collapse q42 q43 q51 q54 q57 q67 q69 q77, by(province)

/*collapse q42 q43 q51 q54 q57 q67 q69 q77 (semean) eq42=q42 eq43=q43 eq51=q51 eq54=q54 eq57=q57 eq67=q67 eq69=q69 eq77=q77, by(province)
gen cv_max=.25
replace q42=. if eq42/q42>cv_max
replace q43=. if eq43/q43>cv_max
replace q51=. if eq51/q51>cv_max
replace q54=. if eq54/q54>cv_max
replace q57=. if eq57/q57>cv_max
replace q67=. if eq67/q67>cv_max
replace q69=. if eq69/q69>cv_max
replace q77=. if eq77/q77>cv_max */


*STANDARDIZE SCORES
*(note that direction of 57 and 69 was reversed above to make categories directionally consistent)
egen Spolint=std(-q42)
egen Scourtint=std(-q43)
egen Spolbias=std(-q51)
egen Scourtbias=std(-q54)
egen Scourtdouble=std(-q57)
egen Ssecurity=std(-q67)
egen Ssafety=std(-q69)
egen Spolfear=std(-q77)



*CREATE INDICES
egen pr_taf=rmean(Scourtint Scourtbias Scourtdouble)
egen lo_taf=rmean(Spolint Spolbias Ssecurity Ssafety Spolfear)
egen comp_taf=rmean(pr_taf lo_taf)
egen comp2_taf=rmean(Scourtint Scourtbias Scourtdouble Spolint Spolbias Ssecurity Ssafety Spolfear)


 

*PREPARE FOR MERGING
gen country="THA"
rename province region
keep country region comp_taf comp2_taf pr_taf  lo_taf 
order country region
sort country region

merge m:m country region using "Replication/merge1.dta"
drop _merge
sort country region
save "Replication/merge1.dta", replace


*****FILE 8: Philippines
use "taf phl raw.dta", clear

*REMOVE UNUSABLE SCORES
replace q8=. if q8<1 | q8>5
replace q19=. if q19<1 | q19>5
replace q21=. if q21<1 | q21>5
replace q24=. if q24<1 | q24>5
replace q33=. if q33<1 | q33>5
replace q34=. if q34<1 | q34>5
replace q39=. if q39<1 | q39>5
replace q40=. if q40<1 | q40>5
replace q41=. if q41<1 | q41>5
replace q42=. if q42<1 | q42>5
replace q47=. if q47<1 | q47>5
replace q54=. if q54<1 | q54>4
replace q56=. if q56<1 | q56>4
replace q63=. if q63<1 | q63>5
replace q66=. if q66<1 | q66>2



*CLEAN DATA
rename region regioncode
decode regioncode, gen(region)



*AVERAGE DATA
collapse q8 q19 q21 q24 q33 q34 q39 q40 q41 q42 q47 q54 q56 q63 q66, by(region)



*STANDARDIZE SCORES
*(note that direction of 57 and 69 was reversed above to make categories directionally consistent)
egen Sq8=std(q8)
egen Sq19=std(q19)
egen Sq21=std(q21)
egen Sq24=std(q24)
egen Sq33=std(q33)
egen Sq34=std(q34)
egen Sq39=std(q39)
egen Sq40=std(q40)
egen Sq41=std(q41)
egen Sq42=std(q42)
egen Sq54=std(-q54)
egen Sq56=std(-q56)
egen Sq63=std(q63)
egen Sq66=std(q66)





*CREATE INDICES
egen pr_taf=rmean(Sq33)
egen cc_taf=rmean(Sq24 Sq54 Sq56 Sq63 Sq66)
egen lo_taf=rmean(Sq21 Sq39)
egen re_taf=rmean(Sq8 Sq19 Sq34 Sq40 Sq41 Sq42)
egen comp_taf=rmean(pr_taf cc_taf lo_taf re_taf)
egen comp2_taf=rmean(Sq8 Sq19 Sq21 Sq24 Sq33 Sq34 Sq39 Sq40 Sq41 Sq42 Sq54 Sq56 Sq63 Sq66)


 

*PREPARE FOR MERGING
gen country="PHL"

keep country region comp_taf comp2_taf pr_taf cc_taf  lo_taf re_taf
order country region
sort country region

merge m:m country region using "Replication/merge1.dta"
drop _merge





*INDEX FOR MERGING
*(All countries combined)
keep country region comp_taf comp2_taf pr_taf cc_taf lo_taf re_taf
sort country region
gen index_taf=[_n]
order index country region

save "TAFdata", replace
