*Model 1 base model
logistic disease i.age [weight=numsub]
estimates store model1base

*Model 1 full model
logistic disease i.alcohol i.age [weight=numsub]
lrtest(model1base)

*Model 1 base model with beta coef
logistic disease i.age [weight=numsub], coef
estimates store model1base

*Model 1 full model  with beta coef
logistic disease i.alcohol i.age [weight=numsub], coef
lrtest(model1base)

*Plotting beta vs midpoint of alcohol 
gen midA=0
replace midA=20 if alcohol==1
replace midA=60 if alcohol==2
replace midA=100 if alcohol==3
replace midA=140 if alcohol==4

gen beta=0
replace beta=0 if alcohol==1
replace beta=1.43 if alcohol==2
replace beta=2.01 if alcohol==3
replace beta=3.68 if alcohol==4

twoway(line beta midA, sort)

*Model 2 base model
logistic disease i.age [weight=numsub]
estimates store model2base

*Model 2 full model
logistic disease i.tobacco i.age [weight=numsub]
lrtest(model2base)

*Model 3 base model (adjusting for age and alcohol)
logistic disease i.age i.alcohol [weight=numsub]
estimates store model3abase

*Model 3 full model
logistic disease i.tobacco i.age i.alcohol [weight=numsub]
lrtest(model3abase)

*Model 3 base model (adjusting for age and tobacco)
logistic disease i.age i.tobacco [weight=numsub]
estimates store model3bbase

*Model 3 full model
logistic disease i.alcohol i.age i.tobacco [weight=numsub]
lrtest(model3bbase)

*Model 4 base model (adjusting for age and tobacco)
logistic disease i.age i.tobacco [weight=numsub]
estimates store model4base

*Model 4 full model
logistic disease alcohol i.age i.tobacco [weight=numsub]
lrtest(model4base)

*Generate alc2
gen alc2 = alcohol*alcohol

*Model 5 base model (adjusting for age, tobacco, and alcohol)
logistic disease alcohol i.age i.tobacco [weight=numsub]
estimates store model5base

*Model 5 full model
logistic disease alc2 alcohol i.age i.tobacco [weight=numsub]
lrtest(model5base)

*Generate alctob
gen alctob = alcohol*tobacco

*Model 6 base model (adjusting for age, alcohol, and tobacco)
logistic disease alcohol i.age tobacco [weight=numsub]
estimates store model6base

*Model 6 full model
logistic disease alctob alcohol i.age tobacco [weight=numsub]
lrtest(model6base)

