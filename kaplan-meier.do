*Create yfe variable
gen yfe = dob+afe

*Categorize AFE and YFE
egen float afegrp = cut(afe), at (0,20,27.5,35,55) icodes
egen float yfegrp = cut(yfe), at (1902, 1910, 1915, 1920, 1925) icodes

*Categorize exposure index
gen exposgrp = expos
recode exposgrp 0=0 0.5/8=1 8.1/22=2

*Dichotomized agestart variable
egen float asgrp = cut(agestart), at (0,45,71) icodes

*Create follow-up variable and stset
gen followup = ageend-agestart
stset followup, failure(icdcode=160)

*List survival data by exposure group
sts list, by(exposgrp)

*Test for survival differences among the 3 groups 
sts test exposgrp

*Adjusted log-rank test
sts test exposgrp, strata(asgrp) detail

*Test for trend by exposure group
sts test exposgrp, trend

*Graph the survival curves
sts graph, by(exposgrp)

