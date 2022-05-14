*Create survival time variables and stset the data
gen yfestart = agestart-afe
gen yfeend = ageend-afe
gen yfe = dob+afe
stset yfeend, failure (icdcode=160) enter(yfestart)

*Categorize exposure into 5 levels
gen exposgrp = expos
recode exposgrp 0=0 0.1/4.0=1 4.1/8.0=2 8.1/12=3 12.1/22=4

*Categorize AFE and YFE
egen float afegrp = cut(afe), at (0,20,27.5,35,55) icodes
egen float yfegrp = cut(yfe), at (1902,1910,1915,1920,1925) icodes

stcox i.exposgrp
stcox exposgrp

stcox i.afegrp
stcox afegrp

stcox i.yfegrp
stcox yfegrp

*LRT for exposure adjusted for afe and yfe
stcox i.afegrp i.yfegrp
est store lrt1
stcox i.exposgrp i.afegrp i.yfegrp
lrtest lrt1

*LRT for yfe adjusted for afe and exposure
stcox i.afegrp i.exposgrp
est store lrt2
stcox i.exposgrp i.afegrp i.yfegrp
lrtest lrt2

*LRT for afe adjusted for yfe and exposure
stcox i.yfegrp i.exposgrp
est store lrt3
stcox i.exposgrp i.afegrp i.yfegrp
lrtest lrt3

*Test proportional hazards
stcox i.afegrp i.yfegrp i.exposgrp, tvc(i.afegrp i.yfegrp i.exposgrp) texp(_t)

*Full model
stcox i.afegrp i.yfegrp i.exposgrp

*34 years old first employed, year first employed is 1918, 10 years of exposure
*AFE=2, YFE=2, Exposure=3 vs. AFE=2, YFE=2, Exposure=0
stcurve, survival at1(afegrp=2 yfegrp=2 exposgrp=3) at2(afegrp=2 yfegrp=2 exposgrp=0) 

