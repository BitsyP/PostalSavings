drop var11 _merge
rename  people1919 people_1919
rename  people1920 people_1920
rename  people1921 people_1921
rename  depo1919 depo_1919
rename  depo1920 depo_1920
rename  depo1921 depo_1921

reshape long people_ depo_, i(var1 var15) j(year)

*deposit info if from June 30 of each year. 

*MS: Compulsary until May 15, 1915
gen insurance = 0
replace insurance = 1 if var15=="MS" & year>1914
replace insurance = 1 if var15=="ND" & year>1916
replace insurance = 1 if var15=="SD" & year>1914

replace  depo_=0 if missing(depo_)
gen log_depo= log(depo_+1)
*excluding WA from the analysis (though the results do not depend on this)
reg log_depo st1-st30 i.year insurance, cluster(var15)
*post-office fixed effects
areg log_depo st1-st30 insurance, absorb(var1) cluster(var15)
