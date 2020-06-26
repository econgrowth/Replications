*This do-file takes the raw afrobarometer data and prepares it for merging with other data.

set more off

*COMBINE DATASETS
use "afrobarometer420.dta", replace
keep if country==3
replace country=country+20
keep country region q49d q49g q49h q50c q50d q50e q50g q51a q51b q51c
rename q49d q55d
rename q49g q55h
rename q49h q55i
rename q50c q56c
rename q50d q56e
rename q50e q56f
rename q50g q56h
rename q51a q57a
rename q51b q57c
rename q51c q57e

sort country region
save "Replication/merge.dta", replace

use "afrobarometer318.dta", replace
keep  country region q55d q55h q55i q56c q56e q56f q56h q57a q57b q57c q57d q57e q57f q70a q70b q70c q70d q71a q71b q71c q71d q71e
drop if country==2 | country==3 | country==4 | country==7 | country==8 | country==9 | country==11
sort country region
merge m:m country region using "Replication/merge.dta"



*REMOVE UNUSABLE SCORES
replace q55d=. if q55d<0 | q55d>3
replace q55h=. if q55h<0 | q55h>3
replace q55i=. if q55i<0 | q55i>3
replace q56c=. if q56c<0 | q56c>3
replace q56e=. if q56e<0 | q56e>3
replace q56f=. if q56f<0 | q56f>3
replace q56h=. if q56h<0 | q56h>3
replace q57a=. if q57a<0 | q57a>3
replace q57b=. if q57b<0 | q57b>3
replace q57c=. if q57c<0 | q57c>3
replace q57d=. if q57d<0 | q57d>3
replace q57e=. if q57e<0 | q57e>3
replace q70a=. if q70a<1 | q70a>4
replace q70b=. if q70b<1 | q70b>4
replace q70c=. if q70c<1 | q70c>4
replace q70d=. if q70d<1 | q70d>4
replace q71a=. if q71a<1 | q71a>4
replace q71b=. if q71b<1 | q71b>4
replace q71c=. if q71c<1 | q71c>4
replace q71d=. if q71d<1 | q71d>4
replace q71e=. if q71e<1 | q71e>4



*CLEAN DATA
label define country 1 "benin" 2 "botswana" 3 "cape verde" 4 "ghana" 5 "kenya" 6 "lesotho" 7 "madagascar" 8 "malawi" 9 "mali" 10 "mozambique" 11 "namibia" 12 "nigeria" 13 "senegal" 14 "south africa" 15 "tanzania" 16 "uganda" 17 "zambia" 18 "zimbabwe" 23 "burkina faso", replace
label define region 100 "eastern cape" 101 "free state" 102 "gauteng" 103 "kwazulu natal" 104 "limpopo" 105 "mpumalanga" 106 "north west" 107 "northern cape" 108 "western cape" 120 "alibori" 121 "atacora" 122 "atlnatique" 123 "borgou" 124 "collines" 125 "couffo" 126 "donga" 127 "littoral" 128 "mono" 129 "oueme" 130 "plateau" 131 "zou" 140 "central" 141 "chobe" 142 "francis town" 143 "gaborone" 144 "ghanzi" 145 "jwaneng" 146 "kgalagadi" 147 "kgatleng" 148 "kweneng" 149 "lobatse" 150 "north east" 151 "ngamiland" 153 "selibe phikwe" 154 "south east" 155 "southern" 160 "santo ant„o" 161 "s„o vicente" 162 "santiago-interior" 163 "santiago-praia" 164 "fogo" 180 "boucle de mouhoun" 181 "cascades" 182 "centre" 183 "centre east" 184 "centre north" 185 "centre west" 186 "centre south" 187 "east" 188 "hauts bassins" 189 "north" 200 "nairobi" 201 "central" 202 "eastern" 203 "rift valley" 204 "nyanza" 205 "western" 206 "north eastern" 207 "coast" 220 "maseru" 221 "mafeteng" 222 "mohale'hoek" 223 "quthing" 224 "qacha's nek" 225 "mokhotlong" 226 "butha buthe" 227 "leribe" 228 "berea" 229 "thaba-tseka" 240 "antananarivo" 241 "fianarantsoa" 242 "toamasina" 243 "mahajanga" 244 "toliary" 245 "antsiranana" 260 "south" 261 "central" 262 "north" 280 "bamako" 281 "kayes" 282 "koulikoro" 283 "sikasso" 284 "sÈgou" 285 "mopti" 286 "tombouctou" 287 "gao" 288 "kidal" 300 "maputo province" 301 "maputo city" 302 "gaza" 303 "inhambane" 304 "sofala" 305 "tete" 306 "manica" 307 "zambezia" 308 "nampula" 309 "niassa" 310 "cabo delgado" 320 "caprivi" 321 "erongo" 322 "hardap" 323 "karas" 324 "kavango" 325 "khomas" 326 "kunene" 327 "ohangwena" 328 "omaheke" 329 "omusati" 330 "oshana" 331 "oshikoto" 332 "otjozundjupa" 340 "lagos" 341 "ogun" 342 "oyo" 343 "osun" 344 "ondo" 345 "ekiti" 346 "enugu" 347 "anambra" 348 "imo" 349 "abia" 350 "akwa-ibom" 351 "bayelsa" 352 "cross-river" 353 "delta" 354 "edo" 355 "rivers" 356 "kano" 357 "sokoto" 358 "kaduna" 359 "katsina" 360 "dakar" 361 "diourbel" 362 "fatick" 363 "kaolack" 364 "kolda" 365 "louga" 366 "matam" 367 "saint louis" 368 "tambacounda" 369 "thies" 370 "ziguinchor" 380 "dodoma" 381 "arusha" 382 "kilimanjaro" 383 "tanga" 384 "morogoro" 385 "pwani" 386 "dar es salaam" 387 "lindi" 388 "mtwara" 389 "ruvuma" 390 "iringa" 391 "mbeya" 392 "singida" 393 "tabora" 394 "rukwa" 395 "kigoma" 396 "shinyanga" 397 "kagera" 398 "mwanza" 399 "mara" 400 "central" 401 "east" 402 "north" 404 "west" 420 "lusaka" 421 "central" 422 "copper belt" 423 "eastern" 424 "luapula" 425 "northern" 426 "north western" 427 "southern" 428 "western" 440 "harare" 441 "bulawayo" 442 "midlands" 443 "masvingo" 444 "mashonaland east" 445 "mashonaland west" 446 "mashonaland central" 447 "matebeleland south" 448 "matebeland north" 449 "manicaland" 540 "manyara" 541 "north unguja" 542 "south unguja" 543 "urban west" 544 "north pemba" 545 "south pemba" 550 "zamfara" 551 "bauchi" 552 "borno" 553 "adamawa" 554 "taraba" 555 "plateau" 556 "benue" 557 "kogi" 558 "kwara" 559 "niger" 560 "fct" 190 "plateau central" 191 "sahel" 192 "south west", replace



*AVERAGE DATA
collapse q55d q55h q55i q56c q56e q56f q56h q57a q57b q57c q57d q57e q70a q70b q70c q70d q71a q71b q71c q71d q71e, by(country region)



*STANDARDIZE SCORES
egen S55d=std(q55d) 
egen S55h=std(q55h) 
egen S55i=std(q55i) 
egen S56c=std(-q56c) 
egen S56e=std(-q56e) 
egen S56f=std(-q56f) 
egen S56h=std(-q56h) 
egen S57a=std(-q57a) 
egen S57b=std(-q57b) 
egen S57c=std(-q57c) 
egen S57d=std(-q57d) 
egen S57e=std(-q57e) 
egen S70a=std(q70a) 
egen S70b=std(q70b)
egen S70c=std(q70c) 
egen S70d=std(q70d) 
egen S71a=std(q71a) 
egen S71b=std(q71b) 
egen S71c=std(q71c) 
egen S71d=std(q71d) 
egen S71e=std(q71e) 



*CREATE INDICES
egen pr_afro=rmean(S55i)
egen cc_afro=rmean(S56c S56e S56f S56h S57a S57b S57c S57d S57e)
egen lo_afro=rmean(S55h S70a S70b S70c S70d)
egen re_afro=rmean(S55d S71a S71b S71c S71d S71e)
gen prpos_afro=.
egen ccpos_afro=rmean(S56f S57a S57b S57d S57e)
egen lopos_afro=rmean(S70a S70c )
egen repos_afro=rmean(S71a S71c S71d S71e)
egen comp_afro=rmean(pr_afro cc_afro lo_afro re_afro)
egen comp2_afro=rmean(S55i S56c S56e S56f S56h S57a S57b S57c S57d S57e S55h S70a S70b S70c S70d S55d S71a S71b S71c S71d S71e)
egen comppos_afro=rmean(S56f S57a S57b S57d S57e S70a S70c S71a S71c S71d S71e)



*INDEX FOR MERGING
keep country region comp_afro comp2_afro comppos_afro pr_afro cc_afro lo_afro re_afro prpos_afro ccpos_afro lopos_afro repos_afro 
sort country region
gen index_afro=[_n]
order index country region

save "afrodata",replace

