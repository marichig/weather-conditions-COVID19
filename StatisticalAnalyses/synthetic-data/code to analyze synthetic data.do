*create R0 measures and other relevant variables
sort location time

by location: gen expo_1 = expo[_n-1]
by location: gen expo_2 = expo[_n-2]
by location: gen expo_3 = expo[_n-3]
by location: gen expo_4 = expo[_n-4]
by location: gen expo_5 = expo[_n-5]
by location: gen expo_6 = expo[_n-6]
by location: gen expo_7 = expo[_n-7]
by location: gen expo_8 = expo[_n-8]
by location: gen expo_9 = expo[_n-9]
by location: gen expo_10 = expo[_n-10]
by location: gen expo_11 = expo[_n-11]
by location: gen expo_12 = expo[_n-12]
by location: gen expo_13 = expo[_n-13]
by location: gen expo_14 = expo[_n-14]
by location: gen expo_15 = expo[_n-15]
by location: gen expo_16 = expo[_n-16]
by location: gen expo_17 = expo[_n-17]
by location: gen expo_18 = expo[_n-18]
by location: gen expo_19 = expo[_n-19]
by location: gen expo_20 = expo[_n-20]

egen sumexpo=rowtotal( expo_1-expo_14 )
replace sumexpo=. if expo_14==.

gen r0=14*expo/sumexpo

gen ln_r0=log(r0)

gen sq_t=t^2

sort location_name time
gen first_expo=.
by location_name: replace first_expo=cond(expo>=1 & expo<. & first_expo[_n-1]==.,_n,first_expo[_n-1])
by location_name: gen xxx=_n if first_expo!=.
replace xxx=xxx-first_expo+1

egen locationid=group(location_name) 

forval i = 1/100 {
  	gen trend`i'=xxx if locationid==`i'
	replace trend`i'=0 if trend`i'==.
 }
 
*statistical analysis

reg ln_r0 t Populationdensity trend1-trend100 if expo>=1 & xxx>=20
outreg2 using S1.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0 t sq_t Populationdensity trend1-trend100 if expo>=1 & xxx>=20
outreg2 using S1.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0 t i.locationid##c.time if expo>=1 & xxx>=20
outreg2 using S1.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0 t sq_t i.locationid##c.time if expo>=1 & xxx>=20
outreg2 using S1.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)

reg ln_r0 t Populationdensity trend1-trend100 if expo>=1 & xxx>=20
outreg2 using S2.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0 t sq_t Populationdensity trend1-trend100 if expo>=1 & xxx>=20
outreg2 using S2.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0 t i.locationid##c.time if expo>=1 & xxx>=20
outreg2 using S2.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0 t sq_t i.locationid##c.time if expo>=1 & xxx>=20
outreg2 using S2.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)


reg ln_r0 t Populationdensity trend1-trend100 if expo>=1 & xxx>=20
outreg2 using S3.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0 t sq_t Populationdensity trend1-trend100 if expo>=1 & xxx>=20
outreg2 using S3.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0 t i.locationid##c.time if expo>=1 & xxx>=20
outreg2 using S3.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0 t sq_t i.locationid##c.time if expo>=1 & xxx>=20
outreg2 using S3.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)