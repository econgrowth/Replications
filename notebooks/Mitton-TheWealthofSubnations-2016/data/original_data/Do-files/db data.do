*This do-file takes the raw doing business data and prepares it for merging with other data.

set more off

use "db.dta", clear

*REMOVE UNUSABLE SCORES



*CLEAN DATA



*AVERAGE DATA
collapse  procstartbus timestartbus coststartbus picstartbus procconst timeconst costconst procregprop timeregprop costregprop procenfcont timeenfcont costenfcont, by(country region)



*STANDARDIZE SCORES
egen Spsb=std(-ln(procstartbus))
egen Stsb=std(-ln(timestartbus))
egen Scsb=std(-ln(coststartbus))
egen Sisb=std(-ln(picstartbus))
egen Spcp=std(-ln(procconst))
egen Stcp=std(-ln(timeconst))
egen Sccp=std(-ln(costconst))
egen Sprp=std(-ln(procregprop))
egen Strp=std(-ln(timeregprop))
egen Scrp=std(-ln(costregprop))
egen Spec=std(-ln(procenfcont))
egen Stec=std(-ln(timeenfcont))
egen Scec=std(-ln(costenfcont))



*CREATE INDICES
egen pr_db=rmean(Sprp Strp Scrp Spec Stec Scec)
egen re_db=rmean(Spsb Stsb Scsb Sisb Spcp Stcp Sccp)
egen prpos_db=rmean(Sprp Strp Scrp Spec Scec)
egen repos_db=rmean(Spsb Stsb Scsb Sccp)
egen comp_db=rmean(pr_db re_db)
egen comp2_db=rmean(Sprp Strp Scrp Spec Stec Scec Spsb Stsb Scsb Sisb Spcp Stcp Sccp)
egen comppos_db=rmean(Sprp Strp Scrp Spec Scec Spsb Stsb Scsb Sccp)
 

  
*INDEX FOR MERGING
keep country region comp_db comp2_db comppos_db pr_db re_db prpos_db repos_db
sort country region
gen index_db=[_n]
order index country region

save "dbdata", replace
