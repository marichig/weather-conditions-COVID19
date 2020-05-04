
*generate R0, weather, trend all the variables needed
sort location_name time

gen diff_temp=maxtemp-mintemp

gen pss_std=pss-1000

gen ln_precip=log(precip+1) 

gen ln_totalsnow=log(totalsnow+1) 

gen ln_windspeed=log(windspeed+1) 

gen ln_popdensity=log(Density_persqkm)

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
by location: gen expo_21 = expo[_n-21]
by location: gen expo_22 = expo[_n-22]
by location: gen expo_23 = expo[_n-23]
by location: gen expo_24 = expo[_n-24]
by location: gen expo_25 = expo[_n-25]


egen sumexpo=rowtotal( expo_1-expo_15 )
replace sumexpo=. if expo_15==.

gen r0_1=15*expo/sumexpo

gen ln_r0_1=log(r0_1)

egen sumexpo1=rowtotal( expo_1-expo_25 )
replace sumexpo1=. if expo_25==.

gen r0_2=25*expo/sumexpo1

gen ln_r0_2=log(r0_2)

egen sumexpo2=rowtotal( expo_1-expo_20 )
replace sumexpo2=. if expo_20==.

gen r0_3=20*expo/sumexpo2

gen ln_r0_3=log(r0_3)

foreach var of varlist  moonillu ln_totalsnow ln_windspeed pss_std ln_precip humid avgtemp sunhour diff_temp{

by location_name:  generate `var'_2 = `var'
gen sq_`var'_2=`var'_2^2
  
}


gen day_of_week = mod(time,7)

gen sq_time=time^2

egen locationid=group(location_name) 

gen china_province=1 if Country=="China" & Province_State!=""

sort location_name time
gen first_expo=.
by location_name: replace first_expo=cond(expo>=1 & expo<. & first_expo[_n-1]==.,_n,first_expo[_n-1])
by location_name: gen xxx=_n if first_expo!=.
replace xxx=xxx-first_expo+1

forval i = 1/3739 {
  	gen trend`i'=xxx if locationid==`i'
	replace trend`i'=0 if trend`i'==.
 }
 
mkspline x11 -15 x12 = avgtemp_2 
mkspline x21 -10 x22 = avgtemp_2 
mkspline x31 -5 x32 = avgtemp_2 
mkspline x41 0 x42 = avgtemp_2 
mkspline x51 5 x52 = avgtemp_2 
mkspline x61 10 x62 = avgtemp_2 
mkspline x71 15 x72 = avgtemp_2 
mkspline x81 20 x82 = avgtemp_2 
mkspline x91 25 x92 = avgtemp_2 
mkspline x101 30 x102 = avgtemp_2 

*****ANALYSIS

*using fixed effects and quadratic effect of temperature
reg ln_r0_3 ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 avgtemp_2 sq_avgtemp_2 sunhour_2 diff_temp_2 humid_2    i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-fixed.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3 ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 avgtemp_2 sq_avgtemp_2 sunhour_2 diff_temp_2 humid_2    i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-fixed.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3 ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 avgtemp_2 sq_avgtemp_2 sunhour_2 diff_temp_2 humid_2    i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-fixed.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3 ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 avgtemp_2 sq_avgtemp_2 sunhour_2 diff_temp_2 humid_2    i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-fixed.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3 ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 avgtemp_2 sq_avgtemp_2 sunhour_2 diff_temp_2 humid_2    i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-fixed.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)
 
*only include trends and quadratic effect of temperature 
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 avgtemp_2 sq_avgtemp_2 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-nofixed.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 avgtemp_2 sq_avgtemp_2 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-nofixed.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 avgtemp_2 sq_avgtemp_2 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-nofixed.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 avgtemp_2 sq_avgtemp_2 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-nofixed.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 avgtemp_2 sq_avgtemp_2 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-nofixed.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)



*linear spline effect of temperature, testing different knots

reg ln_r0_3 ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x11 x12  sunhour_2 diff_temp_2 humid_2   ln_popdensity trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using ls1.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3 ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x21 x22  sunhour_2 diff_temp_2 humid_2   ln_popdensity trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using ls1.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3 ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x31 x32  sunhour_2 diff_temp_2 humid_2   ln_popdensity trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using ls1.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3 ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x41 x42  sunhour_2 diff_temp_2 humid_2   ln_popdensity trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using ls1.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3 ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x51 x52  sunhour_2 diff_temp_2 humid_2   ln_popdensity trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using ls1.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)

reg ln_r0_3 ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x61 x62  sunhour_2 diff_temp_2 humid_2   ln_popdensity trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using ls2.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3 ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x71 x72  sunhour_2 diff_temp_2 humid_2   ln_popdensity trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using ls2.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3 ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x81 x82  sunhour_2 diff_temp_2 humid_2   ln_popdensity trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using ls2.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3 ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x91 x92  sunhour_2 diff_temp_2 humid_2   ln_popdensity trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using ls2.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3 ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x101 x102  sunhour_2 diff_temp_2 humid_2   ln_popdensity trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using ls2.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)

* main specification with knot at 25 for temperature
reg ln_r0_3 ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x91 x92  sunhour_2 diff_temp_2 humid_2   ln_popdensity trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using ls3.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3 ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x91 x92  sunhour_2 diff_temp_2 humid_2   ln_popdensity trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using ls3.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3 ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x91 x92  sunhour_2 diff_temp_2 humid_2   ln_popdensity trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using ls3.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3 ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x91 x92  sunhour_2 diff_temp_2 humid_2   ln_popdensity trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using ls3.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3 ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x91 x92  sunhour_2 diff_temp_2 humid_2   ln_popdensity trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using ls3.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)

*sensitivity to exclusion of last 4 days of data
reg ln_r0_3 ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x91 x92  sunhour_2 diff_temp_2 humid_2   ln_popdensity trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=35 &time<=100
outreg2 using ls4.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3 ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x91 x92  sunhour_2 diff_temp_2 humid_2   ln_popdensity trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=35 &time<=100
outreg2 using ls4.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3 ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x91 x92  sunhour_2 diff_temp_2 humid_2   ln_popdensity trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=35 &time<=100
outreg2 using ls4.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3 ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x91 x92  sunhour_2 diff_temp_2 humid_2   ln_popdensity trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=35 &time<=100
outreg2 using ls4.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3 ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x91 x92  sunhour_2 diff_temp_2 humid_2   ln_popdensity trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=35 &time<=100
outreg2 using ls4.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)

*sensitivity to inclusin of fixed effects

reg ln_r0_3 ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x91 x92  sunhour_2 diff_temp_2 humid_2   i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using ls5.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3 ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x91 x92  sunhour_2 diff_temp_2 humid_2   i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using ls5.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3 ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x91 x92  sunhour_2 diff_temp_2 humid_2   i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using ls5.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3 ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x91 x92  sunhour_2 diff_temp_2 humid_2   i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using ls5.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3 ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x91 x92  sunhour_2 diff_temp_2 humid_2   i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using ls5.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)


*sensitivity to exclusion of large R0
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x91 x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=35  &r0_3<6.63
outreg2 using myreg-lsextreme.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x91 x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=35 &r0_3<6.63
outreg2 using myreg-lsextreme.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x91 x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=35 &r0_3<6.63
outreg2 using myreg-lsextreme.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x91 x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=35 &r0_3<6.63
outreg2 using myreg-lsextreme.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x91 x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=35 &r0_3<6.63
outreg2 using myreg-lsextreme.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)

*testing various interaction effects
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.diff_temp_2##c.x91 c.diff_temp_2##c.x92 sunhour_2          diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int1.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.diff_temp_2##c.x91 c.diff_temp_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int1.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.diff_temp_2##c.x91 c.diff_temp_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int1.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.diff_temp_2##c.x91 c.diff_temp_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int1.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.diff_temp_2##c.x91 c.diff_temp_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int1.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)

reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.x91 c.humid_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int2.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.x91 c.humid_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int2.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.x91 c.humid_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int2.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.x91 c.humid_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int2.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.x91 c.humid_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int2.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)

reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.x91 c.humid_2##c.x92 sunhour_2          diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=35  & r0_3<=6.63
outreg2 using myreg-int2extreme.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.x91 c.humid_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=35 & r0_3<=6.63
outreg2 using myreg-int2extreme.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.x91 c.humid_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=35 & r0_3<=6.63
outreg2 using myreg-int2extreme.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.x91 c.humid_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=35 & r0_3<=6.63
outreg2 using myreg-int2extreme.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.x91 c.humid_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=35  & r0_3<=6.63
outreg2 using myreg-int2extreme.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)

reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.x91 c.humid_2##c.x92 sunhour_2          diff_temp_2 humid_2    i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int2fixed.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.x91 c.humid_2##c.x92 sunhour_2 diff_temp_2 humid_2    i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int2fixed.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.x91 c.humid_2##c.x92 sunhour_2 diff_temp_2 humid_2    i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int2fixed.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.x91 c.humid_2##c.x92 sunhour_2 diff_temp_2 humid_2    i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int2fixed.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.x91 c.humid_2##c.x92 sunhour_2 diff_temp_2 humid_2    i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=35
outreg2 using myreg-int2fixed.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)

reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.pss_std_2##c.x91 c.pss_std_2##c.x92 c.sq_pss_std_2##c.x91 c.sq_pss_std_2##c.x92  sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int3.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.pss_std_2##c.x91 c.pss_std_2##c.x92 c.sq_pss_std_2##c.x91 c.sq_pss_std_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int3.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.pss_std_2##c.x91 c.pss_std_2##c.x92 c.sq_pss_std_2##c.x91 c.sq_pss_std_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int3.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.pss_std_2##c.x91 c.pss_std_2##c.x92 c.sq_pss_std_2##c.x91 c.sq_pss_std_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int3.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.pss_std_2##c.x91 c.pss_std_2##c.x92 c.sq_pss_std_2##c.x91 c.sq_pss_std_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int3.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)

reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.sunhour_2##c.x91 c.sunhour_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int4.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.sunhour_2##c.x91 c.sunhour_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int4.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.sunhour_2##c.x91 c.sunhour_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int4.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.sunhour_2##c.x91 c.sunhour_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int4.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.sunhour_2##c.x91 c.sunhour_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int4.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)

reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.ln_windspeed_2##c.x91 c.ln_windspeed_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int5.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.ln_windspeed_2##c.x91 c.ln_windspeed_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int5.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.ln_windspeed_2##c.x91 c.ln_windspeed_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int5.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.ln_windspeed_2##c.x91 c.ln_windspeed_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int5.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.ln_windspeed_2##c.x91 c.ln_windspeed_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int5.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)

reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.diff_temp_2 x91 x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int6.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.diff_temp_2 x91 x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int6.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.diff_temp_2 x91 x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int6.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.diff_temp_2 x91 x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int6.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.diff_temp_2 x91 x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int6.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)

reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.ln_precip_2##c.x91 c.ln_precip_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int8.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.ln_precip_2##c.x91 c.ln_precip_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int8.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.ln_precip_2##c.x91 c.ln_precip_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int8.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.ln_precip_2##c.x91 c.ln_precip_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int8.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.ln_precip_2##c.x91 c.ln_precip_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int8.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)

reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  c.humid_2##c.pss_std_2 c.humid_2##c.sq_pss_std_2 diff_temp_2 x91 x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int9.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  c.humid_2##c.pss_std_2 c.humid_2##c.sq_pss_std_2 diff_temp_2 x91 x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int9.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  c.humid_2##c.pss_std_2 c.humid_2##c.sq_pss_std_2 diff_temp_2 x91 x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int9.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  c.humid_2##c.pss_std_2 c.humid_2##c.sq_pss_std_2 diff_temp_2 x91 x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int9.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  c.humid_2##c.pss_std_2 c.humid_2##c.sq_pss_std_2 diff_temp_2 x91 x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int9.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)

reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.avgtemp_2 c.humid_2##c.sq_avgtemp_2 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=35
outreg2 using myreg-int2sqtemp.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.avgtemp_2 c.humid_2##c.sq_avgtemp_2 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int2sqtemp.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.avgtemp_2 c.humid_2##c.sq_avgtemp_2 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int2sqtemp.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.avgtemp_2 c.humid_2##c.sq_avgtemp_2 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using myreg-int2sqtemp.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.avgtemp_2 c.humid_2##c.sq_avgtemp_2 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=35  
outreg2 using myreg-int2sqtemp.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)

* testing sensitivity to different duration to create R0
reg ln_r0_2 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x91 x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using 25daysr0.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_2 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x91 x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using 25daysr0.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_2 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x91 x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using 25daysr0.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_2 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x91 x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using 25daysr0.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_2 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x91 x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using 25daysr0.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)

reg ln_r0_2 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.x91 c.humid_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using 25daysr0int.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_2 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.x91 c.humid_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using 25daysr0int.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_2 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.x91 c.humid_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using 25daysr0int.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_2 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.x91 c.humid_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using 25daysr0int.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_2 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.x91 c.humid_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using 25daysr0int.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)

reg ln_r0_1 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x91 x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using 15daysr0.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_1 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x91 x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using 15daysr0.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_1 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x91 x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using 15daysr0.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_1 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x91 x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using 15daysr0.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_1 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 x91 x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using 15daysr0.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)

reg ln_r0_1 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.x91 c.humid_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using 15daysr0int.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_1 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.x91 c.humid_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using 15daysr0int.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_1 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.x91 c.humid_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using 15daysr0int.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_1 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.x91 c.humid_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using 15daysr0int.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_1 ln_popdensity ln_windspeed_2 ln_totalsnow_2 ln_precip_2  pss_std_2 sq_pss_std_2 c.humid_2##c.x91 c.humid_2##c.x92 sunhour_2 diff_temp_2 humid_2    trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=35 
outreg2 using 15daysr0int.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)
