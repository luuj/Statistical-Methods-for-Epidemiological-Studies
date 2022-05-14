****Question 1****
*Check for missing values + extreme values
codebook

*Assign labels for variables and their values
label variable randid "Subject ID"
label variable sex "Participant sex"
label variable age "Age at baseline examination"
label variable sysbp "Systolic blood pressure"
label variable cursmoke "Current cigarette smoker"
label variable educ "Education"
label variable totchol "Total cholesterol"
label variable bmi "Body mass index"
label variable diabetes "Diabetes"
label variable mi_chd "Hospitalized myocardial infarction or fatal coronary heart disease"
label variable lasttime "Time since baseline exam"

label define s 1 "Male" 2 "Female"
label values sex s
label define c 0 "No" 1 "Yes"
label values cursmok c
label values diabetes c
label values mi_chd c
label define e 1 "0-11 years" 2 "High school graduate" 3 "Some college" 4 "College degree"
label values educ e

*Get descriptive statistics of independent variables by MI/CHD outcome
sort mi_chd
by mi_chd: summarize age sysbp totchol bmi 

*Chi-square test to compare means of categorical variables in MI/CHD vs no MI/CHD
foreach x of varlist sex cursmoke educ diabetes{
	tabulate `x' mi_chd, chi2 column
}

*T-test to compare means of continuous variables in MI/CHD vs no MI/CHD
foreach x of varlist age sysbp totchol bmi{	
	ttest `x', by (mi_chd)
}


****Question 2****
stset lasttime, failure(mi_chd)

*Graph a KM survival curve by diabetes
sts graph, title("Cumulative survival for MI/CHD, by diabetes") by(diabetes) ///
	legend (label(1 "No diabetes") label(2 "Diabetes")) ytitle("Cumulative survival probability") ///
	xtitle("Time since baseline exam (Years)")

*Get estimates of 5, 10, 15, and 20 year cumulative survival by diabetic group
sts list, by(diabetes) at(5,10,15,20)

*Log-rank test to check for differences in survival
sts test diabetes


****Question 3****
*Generate martingale residuals
stcox, estimate
predict mg, mgale

*Lowess plot for each continuous variable
lowess mg age, title("Martingale residuals vs. Age at baseline examination")
lowess mg sysbp, title("Martingale residuals vs. Systolic blood pressure")
lowess mg totchol, title("Martingale residuals vs. Total cholesterol")
lowess mg bmi, title("Martingale residuals vs. Body mass index")

*Generate martingale residuals with categorical variables in the model
stcox i.diabetes i.cursmoke i.sex i.educ, estimate
predict mg2, mgale
lowess mg2 age, title("Martingale residuals vs. Age at baseline examination")
lowess mg2 sysbp, title("Martingale residuals vs. Systolic blood pressure")
lowess mg2 totchol, title("Martingale residuals vs. Total cholesterol")
lowess mg2 bmi, title("Martingale residuals vs. Body mass index")

*Center continuous variables around their mean
summarize age sysbp totchol bmi
gen age_cent = age-49.54582
gen sysbp_cent = sysbp-132.2774
gen totchol_cent = totchol-236.8459
gen bmi_cent = bmi-25.79995

label variable age_cent "Centered age at baseline examination"
label variable sysbp_cent "Centered systolic blood pressur"
label variable totchol_cent "Centered total cholesterol"
label variable bmi_cent "Centered body mass index"

*Univariate association of each modifiable continuous centered variable
foreach x of varlist sysbp_cent totchol_cent bmi_cent age{
	stcox `x'
}

*Univariate association of each modifiable categorical variable
foreach x of varlist cursmoke diabetes educ sex{
	stcox i.`x'
}

*Full multivariate model
stcox sysbp_cent totchol_cent bmi_cent i.cursmoke i.diabetes 
*Age changes smoking HR by 9.6%, diabetes HR by 8%
stcox sysbp_cent totchol_cent bmi_cent i.cursmoke i.diabetes age_cent
*Sex changes smoking HR by 21%
stcox sysbp_cent totchol_cent bmi_cent i.cursmoke i.diabetes i.sex
*Include both sex and age as confounders  -> Changes smoking by 12.56% and diabetes by 9%
stcox sysbp_cent totchol_cent bmi_cent i.cursmoke i.diabetes i.sex age_cent

*Test proportional hazards
estat phtest, detail
stcox sysbp_cent totchol_cent bmi_cent i.cursmoke i.diabetes i.sex age_cent, ///
	tvc(sysbp_cent totchol_cent bmi_cent i.cursmoke i.diabetes i.sex age_cent) texp(_t)

*Stratify by sex to fix proportional hazards issue
stcox sysbp_cent totchol_cent bmi_cent i.cursmoke i.diabetes age_cent, strata(sex)

*Final model diagnostics
*Cox-Snell residuals
predict csr, csnell
stset csr, failure(mi_chd)
sts generate cumhaz = na
line cumhaz csr csr, sort title("Cox Snell residuals")

*Likelihood displacement
stset lasttime, failure(mi_chd)
stcox sysbp_cent totchol_cent bmi_cent i.cursmoke i.diabetes age_cent, strata(sex)
predict ldisp, ldisplace
scatter ldisp _t, yline(0) mlabel(randid) title("Likelihood displacement residuals")

*DBeta - shouldn't be greater than 2/sqrt(n)=0.03 or > 1
predict db*, dfbeta
scatter db1 _t, yline(0) title("DBeta residuals for systolic blood pressure") mlabel(randid)
scatter db2 _t, yline(0) title("DBeta residuals for total cholesterol") mlabel(randid)
scatter db3 _t, yline(0) title("DBeta residuals for body mass index") mlabel(randid)
scatter db5 _t, yline(0) title("DBeta residuals for smoking") mlabel(randid)
scatter db7 _t, yline(0) title("DBeta residuals for diabetes") mlabel(randid)
scatter db8 _t, yline(0) title("DBeta residuals for age at baseline exam") mlabel(randid)


****Question 4****
stcox sysbp_cent totchol_cent bmi_cent i.cursmoke i.diabetes age_cent, strata(sex)
estimates store base
stcox sysbp_cent bmi_cent i.cursmoke c.totchol_cent##i.diabetes age_cent, strata(sex)
lrtest(base)

*Since interaction is significant, lincom for diabetes differing by chol
lincom 1.diabetes
lincom 1.diabetes + 1.diabetes#c.totchol_cent

lincom c.totchol_cent, hr
lincom c.totchol_cent + 1.diabetes#c.totchol_cent, hr

