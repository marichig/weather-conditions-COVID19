*****Statistical analysis in the manuscript and online supplementary document
sort location_name time

gen abs_humid=6.112*exp(17.67*avgtemp/(243.5+avgtemp))*humid*2.1674/(273.15+avgtemp)

gen diff_temp=maxtemp-mintemp

gen pss_std=pss-1000

gen ln_precip=log(precip+1) 

gen ln_totalsnow=log(totalsnow+1) 

gen ln_windspeed=log(windspeed+1) 

gen ln_so2=log(so+1) 

gen ln_no2=log(no+1) 

gen ln_pm=log(pm+1)

gen ln_ozone=log(ozone+1)

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

foreach var of varlist so no ozone pm visi winddir cloudcover moonillu ln_totalsnow ln_windspeed pss_std ln_precip humid avgtemp sunhour diff_temp{

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

sort location_name time
by location_name: gen uvindex_1 = uvindex[_n-1]
by location_name: gen uvindex_2 = uvindex[_n-2]
by location_name: gen uvindex_3 = uvindex[_n-3]
by location_name: gen uvindex_4 = uvindex[_n-4]
by location_name: gen uvindex_5 = uvindex[_n-5]
by location_name: gen uvindex_6 = uvindex[_n-6]
by location_name: gen uvindex_7 = uvindex[_n-7]
by location_name: gen uvindex_8 = uvindex[_n-8]
by location_name: gen uvindex_9 = uvindex[_n-9]
by location_name: gen uvindex_10 = uvindex[_n-10]
by location_name: gen uvindex_11 = uvindex[_n-11]
by location_name: gen uvindex_12 = uvindex[_n-12]
by location_name: gen uvindex_13 = uvindex[_n-13]
by location_name: gen uvindex_14 = uvindex[_n-14]

egen avg_uvindex=rowmean(uvindex_1-uvindex_13 uvindex)

gen avg_uv_std=avg_uvindex-6.86
gen sq_avg_uv_std=(avg_uv_std)^2

gen uv_std=uvindex-7.13
gen sq_uv_std=(uv_std)^2

gen avgtemp_std=avgtemp_2-12.75
gen sq_avgtemp_std=(avgtemp_std)^2


sort location_name time
by location_name: gen ln_so2_1 = ln_so2[_n-1]
by location_name: gen ln_so2_2 = ln_so2[_n-2]
by location_name: gen ln_so2_3 = ln_so2[_n-3]
by location_name: gen ln_so2_4 = ln_so2[_n-4]
by location_name: gen ln_so2_5 = ln_so2[_n-5]
by location_name: gen ln_so2_6 = ln_so2[_n-6]
by location_name: gen ln_so2_7 = ln_so2[_n-7]

by location_name: gen ln_pm_1 = ln_pm[_n-1]
by location_name: gen ln_pm_2 = ln_pm[_n-2]
by location_name: gen ln_pm_3 = ln_pm[_n-3]
by location_name: gen ln_pm_4 = ln_pm[_n-4]
by location_name: gen ln_pm_5 = ln_pm[_n-5]
by location_name: gen ln_pm_6 = ln_pm[_n-6]
by location_name: gen ln_pm_7 = ln_pm[_n-7]

by location_name: gen ln_ozone_1 = ln_ozone[_n-1]
by location_name: gen ln_ozone_2 = ln_ozone[_n-2]
by location_name: gen ln_ozone_3 = ln_ozone[_n-3]
by location_name: gen ln_ozone_4 = ln_ozone[_n-4]
by location_name: gen ln_ozone_5 = ln_ozone[_n-5]
by location_name: gen ln_ozone_6 = ln_ozone[_n-6]
by location_name: gen ln_ozone_7 = ln_ozone[_n-7]

egen avg_so2=rowmean(ln_so2 ln_so2_1-ln_so2_7)
egen avg_pm=rowmean(ln_pm ln_pm_1-ln_pm_7)
egen avg_ozone=rowmean(ln_ozone ln_ozone_1-ln_ozone_7)


*linear spline

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

mkspline stemp1 -5 stemp2 25 stemp3 = avgtemp_2

mkspline uvspline11 4 uvspline12 12 uvspline13= uvindex


*main effects and various robustness check
reg ln_r0_3 ln_so2 ln_ozone ln_windspeed_2 pss_std_2   ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using main.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3 ln_so2 ln_ozone ln_windspeed_2 pss_std_2   ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using main.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3 ln_so2 ln_ozone ln_windspeed_2 pss_std_2   ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2 i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using main.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3 ln_so2 ln_ozone ln_windspeed_2 pss_std_2   ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2 i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using main.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3 ln_so2 ln_ozone ln_windspeed_2 pss_std_2   ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using main.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)


reg ln_r0_3  ln_so2 ln_ozone  ln_windspeed_2 pss_std_2   ln_precip_2 humid_2 x11 x12 uv_std sq_uv_std  diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using ls1.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3  ln_so2 ln_ozone  ln_windspeed_2 pss_std_2   ln_precip_2 humid_2 x21 x22 uv_std sq_uv_std  diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38  
outreg2 using ls1.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3  ln_so2 ln_ozone  ln_windspeed_2 pss_std_2   ln_precip_2 humid_2 x31 x32 uv_std sq_uv_std  diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using ls1.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3  ln_so2 ln_ozone  ln_windspeed_2 pss_std_2   ln_precip_2 humid_2 x41 x42 uv_std sq_uv_std  diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using ls1.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3  ln_so2 ln_ozone ln_windspeed_2 pss_std_2   ln_precip_2 humid_2 x51 x52 uv_std sq_uv_std  diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using ls1.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)


reg ln_r0_3  ln_so2 ln_ozone  ln_windspeed_2 pss_std_2   ln_precip_2 humid_2 x61 x62 uv_std sq_uv_std  diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using ls2.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3  ln_so2 ln_ozone  ln_windspeed_2 pss_std_2   ln_precip_2 humid_2 x71 x72 uv_std sq_uv_std  diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38  
outreg2 using ls2.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3  ln_so2 ln_ozone  ln_windspeed_2 pss_std_2   ln_precip_2 humid_2 x81 x82 uv_std sq_uv_std  diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using ls2.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3  ln_so2 ln_ozone  ln_windspeed_2 pss_std_2   ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std  diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using ls2.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3  ln_so2 ln_ozone ln_windspeed_2 pss_std_2   ln_precip_2 humid_2 x101 x102 uv_std sq_uv_std  diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using ls2.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)




reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std  diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=38 &time<=100
outreg2 using main-sen1.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std  diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=38 &time<=100
outreg2 using main-sen1.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std  diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 &time<=100
outreg2 using main-sen1.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std  diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=38 &time<=100
outreg2 using main-sen1.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std  diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=38  &time<=100
outreg2 using main-sen1.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)


reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std  diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=38 & r0_3<=6.67
outreg2 using main-sen2.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std  diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=38 & r0_3<=6.67
outreg2 using main-sen2.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std  diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 & r0_3<=6.67
outreg2 using main-sen2.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std  diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=38 & r0_3<=6.67
outreg2 using main-sen2.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std  diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=38  & r0_3<=6.67
outreg2 using main-sen2.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)



reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.locationid##c.sq_time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using sqtrend.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std diff_temp_2  i.locationid##c.time i.locationid##c.sq_time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using sqtrend.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std  diff_temp_2  i.locationid##c.time i.locationid##c.sq_time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using sqtrend.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std diff_temp_2  i.locationid##c.time i.locationid##c.sq_time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using sqtrend.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.locationid##c.sq_time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=38  
outreg2 using sqtrend.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)


reg ln_r0_2  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using timefix.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_2  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std diff_temp_2  i.locationid##c.time  i.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using timefix.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_2  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std  diff_temp_2  i.locationid##c.time  i.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using timefix.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_2  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std diff_temp_2  i.locationid##c.time  i.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using timefix.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_2  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=38  
outreg2 using timefix.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)



reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=38 & Country=="US"
outreg2 using main-US.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=38 & Country=="US"
outreg2 using main-US.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std  diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 & Country=="US"
outreg2 using main-US.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=38 & Country=="US"
outreg2 using main-US.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=38  & Country=="US"
outreg2 using main-US.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)


reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=38 & Country!="US"
outreg2 using main-global.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=38 & Country!="US"
outreg2 using main-global.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std  diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 & Country!="US"
outreg2 using main-global.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=38 & Country!="US"
outreg2 using main-global.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=38  & Country!="US"
outreg2 using main-global.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)




reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 stemp1 stemp2 stemp3 uv_std sq_uv_std diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using 2splinetemp.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 stemp1 stemp2 stemp3 uv_std sq_uv_std diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using 2splinetemp.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 stemp1 stemp2 stemp3 uv_std sq_uv_std  diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using 2splinetemp.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 stemp1 stemp2 stemp3 uv_std sq_uv_std diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using 2splinetemp.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 stemp1 stemp2 stemp3 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=38  
outreg2 using 2splinetemp.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)


reg ln_r0_3  ln_so2 ln_ozone  ln_windspeed_2 pss_std_2 sq_pss_std_2 ln_precip_2 humid_2 uv_std sq_uv_std avgtemp_std sq_avgtemp_std sunhour_2 diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using sqeffect.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3  ln_so2 ln_ozone ln_windspeed_2 pss_std_2 sq_pss_std_2 ln_precip_2 humid_2 uv_std sq_uv_std avgtemp_std sq_avgtemp_std sunhour_2 diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using sqeffect.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3  ln_so2 ln_ozone ln_windspeed_2 pss_std_2 sq_pss_std_2 ln_precip_2 humid_2 uv_std sq_uv_std avgtemp_std sq_avgtemp_std sunhour_2 diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using sqeffect.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3  ln_so2 ln_ozone ln_windspeed_2 pss_std_2 sq_pss_std_2 ln_precip_2 humid_2 uv_std sq_uv_std avgtemp_std sq_avgtemp_std sunhour_2 diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using sqeffect.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3  ln_so2 ln_ozone ln_windspeed_2 pss_std_2 sq_pss_std_2 ln_precip_2 humid_2 uv_std sq_uv_std avgtemp_std sq_avgtemp_std sunhour_2 diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=38  
outreg2 using sqeffect.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)



reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 x91 x92 uvindex   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using linearuv.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 x91 x92 uvindex   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using linearuv.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 x91 x92 uvindex  diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using linearuv.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 x91 x92 uvindex diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using linearuv.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 x91 x92 uvindex diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=38  
outreg2 using linearuv.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)



reg ln_r0_3  avg_so2 avg_ozone  avg_pm  ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 x91 x92 avg_uv_std sq_avg_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using lagpollution.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3  avg_so2 avg_ozone avg_pm   ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 x91 x92 avg_uv_std sq_avg_uv_std diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using lagpollution.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3  avg_so2 avg_ozone avg_pm   ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 x91 x92 avg_uv_std sq_avg_uv_std  diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using lagpollution.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3  avg_so2 avg_ozone avg_pm   ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 x91 x92 avg_uv_std sq_avg_uv_std diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using lagpollution.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3  avg_so2 avg_ozone avg_pm   ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 x91 x92 avg_uv_std sq_avg_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=38  
outreg2 using lagpollution.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)



reg ln_r0_1  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using 15day.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_1  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using 15day.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_1  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std  diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using 15day.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_1  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using 15day.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_1  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=38  
outreg2 using 15day.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)



reg ln_r0_2  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using 25day.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_2  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using 25day.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_2  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std  diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using 25day.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_2  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using 25day.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_2  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=38  
outreg2 using 25day.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)


reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  c.ln_precip_2  humid_2 uv_std sq_uv_std    diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using onlyuv.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  c.ln_precip_2  humid_2  uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using onlyuv.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  c.ln_precip_2 humid_2  uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using onlyuv.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  c.ln_precip_2 humid_2  uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using onlyuv.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2 c.ln_precip_2 humid_2  uv_std sq_uv_std    diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=38  
outreg2 using onlyuv.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)



reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std    diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=38  & uvindex<13.25
outreg2 using uvsen2.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=38 & uvindex<13.25
outreg2 using uvsen2.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 & uvindex<13.25
outreg2 using uvsen2.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=38 & uvindex<13.25
outreg2 using uvsen2.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std    diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=38  & uvindex<13.25
outreg2 using uvsen2.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)


reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std    diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=38  & uvindex<10.66
outreg2 using uvsen3.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=38 & uvindex<10.66
outreg2 using uvsen3.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 & uvindex<10.66
outreg2 using uvsen3.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=38 & uvindex<10.66
outreg2 using uvsen3.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std    diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=38  & uvindex<10.66
outreg2 using uvsen3.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)




reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2  ln_precip_2 humid_2 x91 x92 uvspline11 uvspline12 uvspline13 diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using uvspline.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 x91 x92 uvspline11 uvspline12 uvspline13 diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using uvspline.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 x91 x92 uvspline11 uvspline12 uvspline13  diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using uvspline.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 x91 x92 uvspline11 uvspline12 uvspline13 diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using uvspline.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 x91 x92 uvspline11 uvspline12 uvspline13 diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=38  
outreg2 using uvspline.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)


*interactions


reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2  c.x91##c.humid_2 c.x92##c.humid_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std    diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using int-temp24.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 c.x91##c.humid_2 c.x92##c.humid_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using int-temp24.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 c.x91##c.humid_2 c.x92##c.humid_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using int-temp24.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 c.x91##c.humid_2 c.x92##c.humid_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using int-temp24.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 c.x91##c.humid_2 c.x92##c.humid_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std    diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=38  
outreg2 using int-temp24.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)



reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2   c.x91##c.ln_so2 c.x92##c.ln_so2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std    diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using int-temp27.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  c.x91##c.ln_so2 c.x92##c.ln_so2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using int-temp27.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  c.x91##c.ln_so2 c.x92##c.ln_so2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using int-temp27.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  c.x91##c.ln_so2 c.x92##c.ln_so2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using int-temp27.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  c.x91##c.ln_so2 c.x92##c.ln_so2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std    diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=38  
outreg2 using int-temp27.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)





reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2   c.uv_std##c.ln_precip_2 c.sq_uv_std##c.ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std    diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using int-uv22.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2   c.uv_std##c.ln_precip_2 c.sq_uv_std##c.ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using int-uv22.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  c.uv_std##c.ln_precip_2 c.sq_uv_std##c.ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using int-uv22.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  c.uv_std##c.ln_precip_2 c.sq_uv_std##c.ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using int-uv22.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2 c.uv_std##c.ln_precip_2 c.sq_uv_std##c.ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std    diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=38  
outreg2 using int-uv22.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)


reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  c.ln_pm##c.pss_std_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std    diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using int-pm25.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  c.ln_pm##c.pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using int-pm25.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  c.ln_pm##c.pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using int-pm25.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  c.ln_pm##c.pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using int-pm25.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  c.ln_pm##c.pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=38  
outreg2 using int-pm25.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)


reg ln_r0_3 ln_so2 ln_ozone ln_windspeed_2 pss_std_2   ln_precip_2 abs_humid x91 x92 uv_std sq_uv_std diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using abs_humid.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3 ln_so2 ln_ozone ln_windspeed_2 pss_std_2   ln_precip_2 abs_humid x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using abs_humid.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3 ln_so2 ln_ozone ln_windspeed_2 pss_std_2   ln_precip_2 abs_humid x91 x92 uv_std sq_uv_std   diff_temp_2 i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using abs_humid.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3 ln_so2 ln_ozone ln_windspeed_2 pss_std_2   ln_precip_2 abs_humid x91 x92 uv_std sq_uv_std   diff_temp_2 i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using abs_humid.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3 ln_so2 ln_ozone ln_windspeed_2 pss_std_2   ln_precip_2 abs_humid x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using abs_humid.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)


reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2  c.x91##c.humid_2 c.x92##c.humid_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std    diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=38 & Country=="US"
outreg2 using int-temp24-US.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 c.x91##c.humid_2 c.x92##c.humid_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=38 & Country=="US"
outreg2 using int-temp24-US.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 c.x91##c.humid_2 c.x92##c.humid_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 & Country=="US"
outreg2 using int-temp24-US.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 c.x91##c.humid_2 c.x92##c.humid_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=38 & Country=="US"
outreg2 using int-temp24-US.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3  ln_so2 ln_ozone    ln_windspeed_2 pss_std_2 c.x91##c.humid_2 c.x92##c.humid_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std    diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=38  & Country=="US"
outreg2 using int-temp24-US.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)



reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2   c.x91##c.ln_so2 c.x92##c.ln_so2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std    diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=38 & Country=="US"
outreg2 using int-temp27-US.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  c.x91##c.ln_so2 c.x92##c.ln_so2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=38 & Country=="US"
outreg2 using int-temp27-US.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  c.x91##c.ln_so2 c.x92##c.ln_so2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 & Country=="US"
outreg2 using int-temp27-US.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  c.x91##c.ln_so2 c.x92##c.ln_so2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=38 & Country=="US"
outreg2 using int-temp27-US.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  c.x91##c.ln_so2 c.x92##c.ln_so2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std    diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=38  & Country=="US"
outreg2 using int-temp27-US.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)





reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2   c.uv_std##c.ln_precip_2 c.sq_uv_std##c.ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std    diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=38 & Country=="US"
outreg2 using int-uv22-US.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2   c.uv_std##c.ln_precip_2 c.sq_uv_std##c.ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=38 & Country=="US"
outreg2 using int-uv22-US.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  c.uv_std##c.ln_precip_2 c.sq_uv_std##c.ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 & Country=="US"
outreg2 using int-uv22-US.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  c.uv_std##c.ln_precip_2 c.sq_uv_std##c.ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=38 & Country=="US"
outreg2 using int-uv22-US.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2 c.uv_std##c.ln_precip_2 c.sq_uv_std##c.ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std    diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=38 & Country=="US"  
outreg2 using int-uv22-US.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)


reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  c.ln_pm##c.pss_std_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std    diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=10 & pss_std_2>=-1 & pss_std_2<=38 & Country=="US"
outreg2 using int-pm25-US.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  c.ln_pm##c.pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=15 & pss_std_2>=-1 & pss_std_2<=38 & Country=="US"
outreg2 using int-pm25-US.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  c.ln_pm##c.pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 & Country=="US"
outreg2 using int-pm25-US.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  c.ln_pm##c.pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=25 & pss_std_2>=-1 & pss_std_2<=38 & Country=="US"
outreg2 using int-pm25-US.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3  ln_so2 ln_ozone     ln_windspeed_2 pss_std_2  c.ln_pm##c.pss_std_2  ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=30 & pss_std_2>=-1 & pss_std_2<=38  & Country=="US"
outreg2 using int-pm25-US.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)



reg ln_r0_3 ln_no2 ln_pm ln_so2 ln_ozone ln_windspeed_2 pss_std_2  visi winddir cloudcover ln_totalsnow_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using alternative.doc, alpha(0.001, 0.01, 0.05) replace ctitle(Model 1)
reg ln_r0_3 ln_so2 ln_ozone ln_windspeed_2 pss_std_2   ln_precip_2 abs_humid x91 x92 uv_std sq_uv_std   diff_temp_2  i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using alternative.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 2)
reg ln_r0_3 ln_so2 ln_ozone ln_windspeed_2 pss_std_2 ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2 i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 & r0_3<3.81
outreg2 using alternative.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 3)
reg ln_r0_3 ln_so2 ln_ozone ln_windspeed_2 pss_std_2   ln_precip_2 humid_2 x91 x92 uv_std sq_uv_std   diff_temp_2 trend1-trend3739 i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using alternative.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 4)
reg ln_r0_3 ln_so2 ln_ozone ln_windspeed_2 pss_std_2 ln_precip_2 humid x91 x92 uv_std sq_uv_std diff_temp_2 moonillu i.locationid##c.time i.day_of_week if china_province!=1 & expo>=1  & avgtemp_2>-20 & xxx>=20 & pss_std_2>=-1 & pss_std_2<=38 
outreg2 using alternative.doc, alpha(0.001, 0.01, 0.05) append ctitle(Model 5)




