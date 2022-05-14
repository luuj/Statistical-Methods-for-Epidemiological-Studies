*Import data and assign variable names
infix agegrp 1-2 alcohol 3-4 tobacco 5-6 disease 7-8 numsub 9-11 using "\\tsclient\F\School\PM518\tuyns2.dat"

*Dichotomize alcohol 0: 0-79 gm/day; 1: 80+ gm/day;
gen alcohol_cat = alcohol
recode alcohol_cat 1/2=0 3/4=1

*Dichotomize tobacco 0: 0-19 gm/day; 1: 20+ gm/day;
gen tobacco_cat = tobacco
recode tobacco_cat 1/2=0 3/4=1

*Save file as a permanent STATA dataset
save "\\tsclient\F\School\PM518\tunys2.dta"

*Calculate appropriate statistics for each 2x2 table
cc disease alcohol_cat [weight=numsub], exact
cc disease alcohol_cat [weight=numsub], tb
cc disease alcohol_cat [weight=numsub],w 
cc disease alcohol_cat [weight=numsub], cor

cc disease tobacco_cat [weight=numsub], exact
cc disease tobacco_cat [weight=numsub], tb
cc disease tobacco_cat [weight=numsub],w 
cc disease tobacco_cat [weight=numsub], cor

*Analyzing alcohol consumption at the four exposure levels
tabodds disease alcohol [weight=numsub], or base(1)

*Dichotomize age 0: 25-54 yrs; 1: 55+ years;
gen agegrp_cat = agegrp
recode agegrp_cat 1/3=0 4/6=1

*Test both criteria for confounding
cc agegrp_cat alcohol_cat [weight=numsub] if disease==0, cornfield
cc agegrp_cat disease [weight=numsub] if alcohol_cat==0, cornfield

*Evaluate relationship by adjusting for age
cc disease alcohol_cat [weight=numsub], by(agegrp_cat) cornfield
cc disease alcohol_cat [weight=numsub] if agegrp_cat==0, cornfield
cc disease alcohol_cat [weight=numsub] if agegrp_cat==1, cornfield

