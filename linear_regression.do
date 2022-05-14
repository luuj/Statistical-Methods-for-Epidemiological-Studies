infix id 1-3 ec_disease 4-5 pg_disease 6-7 hypertension 8-9 obesity 10-11 estrogen 12-13 c_num 58-59 ///
using "\\tsclient\F\School\PM518\HW3\LEISURE.dat"

*Question 1A
mhodds ec_disease obesity id if c_num==0 | c_num==1

*Question 1B
mcci 22 19 9 13

*Question 1C
mhodds ec_disease obesity id if c_num==0 | c_num==1, level(99)

*Question 1D
mhodds ec_disease estrogen id if c_num==0 | c_num==1
mhodds ec_disease estrogen id if c_num==0 | c_num==1, level(99)

mhodds ec_disease pg_disease id

*Question 2A
mhodds ec_disease obesity id
mhodds ec_disease estrogen id

*Testing carryforward
gen expca=obesity if c_num==0
bysort id: carryforward expca, gen(expca2)
drop expca
collapse (mean) expca=expca2 (sum) expco=obesity if c_num>0, by(id)
label var expca "Case with Obesity"
label var expco "# controls with Obesity"
tab expca expco
