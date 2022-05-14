poisson numdead i.afe i.yfe i.tfe, exposure(py)
poisson numdead i.afe i.yfe i.tfe, exposure(py) irr

*AFE adjusted for YFE & TFE
quietly{
	poisson numdead i.yfe i.tfe, exposure(py)
	estimates store adjust1
	poisson numdead i.afe i.yfe i.tfe, exposure(py)
}
lrtest(adjust1)

*YFE adjusted for AFE & TFE
quietly{
	poisson numdead i.afe i.tfe, exposure(py)
	estimates store adjust2
	poisson numdead i.afe i.yfe i.tfe, exposure(py)
}
lrtest(adjust2)

*TFE adjusted for AFE and YFE
quietly{
	poisson numdead i.afe i.yfe, exposure(py)
	estimates store adjust3
	poisson numdead i.afe i.yfe i.tfe, exposure(py)
}
lrtest(adjust3)

*Goodness of fit
poisson numdead i.afe i.yfe i.tfe, exposure(py)
estat gof

*PREDICT for all stratum combinations
predict dead

*Plot observed vs. predicted # of cancer deaths
scatter dead numdead

*Testing for interaction
poisson numdead i.afe i.yfe i.tfe, exposure(py)
estimates store main

*AFE x YFE
poisson numdead i.afe##i.yfe i.tfe, exposure(py)
lrtest(main)

*AFE x TFE
poisson numdead i.afe##i.tfe i.yfe, exposure(py)
lrtest(main)

*YFE x TFE:
poisson numdead i.yfe##i.tfe i.afe, exposure(py)
lrtest(main)

*Rate ratios
poisson numdead i.afe i.yfe i.tfe, exposure(py) irr

*Lincom rate ratio + test
lincom 2.afe + 4.yfe + 3.tfe, irr
test 2.afe = 4.yfe = 3.tfe = 1
