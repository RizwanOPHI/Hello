//Table 5
gen school_age = (age>6 & age<16) // for Afghanistan
gen school_age = (age>5 & age<15) // for countries except Afghanistan and Pakistan
gen school_age = (age>4 & age<14) // for Pakistan
replace school_age = . if age==.

****total School Age Children in the HH***
bys hh_id: egen tot_sac = sum(school_age)

gen oosc = (attendance==0) if school_age==1
replace oosc = 0 if oosc==.

****total OOS Children in the HH***

bys hh_id: egen tot_oosc = sum(oosc)
 
lab var tot_oosc "Total OOSC living n the HH"   

***There is only one School Age Child who is OOS in the HH***
gen only_sac_oos = (tot_sac ==1 & tot_oosc==1)

lab var only_sac_oos "Only one SAC and OOS in the HH"

***There is only one School Age Child who goes to school in the HH***
gen only_sac_gts = (tot_sac ==1 & tot_oosc==0)

lab var only_sac_gts "Only one SAC and gts in the HH"

***There are more than one School Age Children and all of them are OOS in the HH***
gen all_sac_oos = (tot_sac == tot_oosc) if tot_sac>1

***There more than one School Age Children and all of them go to school in the HH***
gen all_sac_gts = (tot_oosc==0) if tot_sac>1

***There more than one School Age Children and some of them are OOS in the HH***
gen some_sac_oosc_gts = (tot_sac != tot_oosc) if tot_sac>1 & tot_oosc!=0


gen hh_sac_atten_status = 1 if all_sac_oos==1

replace hh_sac_atten_status = 2 if only_sac_oos==1

replace hh_sac_atten_status = 3 if some_sac_oosc_gts==1

replace hh_sac_atten_status = 4 if only_sac_gts==1

replace hh_sac_atten_status = 5 if all_sac_gts==1

replace hh_sac_atten_status = 0 if hh_sac_atten_status==.

label define sac_atten_status 1 "All children OOS" 2 "Only child and OOS" 3 "Soem SAC are OOS" 4 "Only child and GTS" 5 "All SAC are GTS" 
 
label values  hh_sac_atten_status sac_atten_status

lab var hh_sac_atten_status "Attendance status of School going children living with other School going children in the HH "

tab hh_sac_atten_status ps_33 if school_age==1 [aw=wei], cel


 
  
//Table 5 col 1
gen only_sac_oos_np = (  hh_sac_atten_status==2 & ps_33==0) if school_age==1
tab only_sac_oos_np [aw=wei]

gen only_sac_oos_p = (  hh_sac_atten_status==2 & ps_33==1) if school_age==1
tab only_sac_oos_p [aw=wei]

gen all_sac_oos_np = (  hh_sac_atten_status==1 & ps_33==0) if school_age==1
tab all_sac_oos_np [aw=wei]
  
gen all_sac_oos_p = (  hh_sac_atten_status==1 & ps_33==1) if school_age==1
tab all_sac_oos_p [aw=wei]  

gen some_sac_oos_np = (  hh_sac_atten_status==3 & ps_33==0) if school_age==1
tab some_sac_oos_np [aw=wei] 

gen some_sac_oos_p = (  hh_sac_atten_status==3 & ps_33==1) if school_age==1
tab some_sac_oos_p [aw=wei]  
  
gen only_sac_gts_np = (  hh_sac_atten_status==4 & ps_33==0) if school_age==1
tab only_sac_gts_np [aw=wei]

gen only_sac_gts_p = (  hh_sac_atten_status==4 & ps_33==1) if school_age==1
tab only_sac_gts_p [aw=wei]

gen all_sac_gts_np = (  hh_sac_atten_status==5 & ps_33==0) if school_age==1
tab all_sac_gts_np [aw=wei]
  
gen all_sac_gts_p = (  hh_sac_atten_status==5 & ps_33==1) if school_age==1
tab all_sac_gts_p [aw=wei]  

*************
gen chld_u5 = (age<5)

**Total under 5  children in the HH***
bys hh_id: egen tot_chldu5 = sum(chld_u5)

gen chld_d_nut4 = (underweight==1 | stunting == 1) if age<5

**Total under 5 malnourished children in the HH***
bys hh_id: egen tot_chld_mal4 = sum(chld_d_nut4)

***There is only one U5 Child who is malnourished in the HH***
gen only_chld_mnc = (tot_chldu5 ==1 & tot_chld_mal4==1)
lab var only_chld_mnc "Only one u5child and MNC in the HH"

***There is only one U5 Child who is NOT Malnourished in the HH***
gen only_chld_not_mnc = (tot_chldu5 ==1 & tot_chld_mal4==0)

lab var only_chld_not_mnc "Only one u5child and NOT MNC in the HH"

***There are more than one U5 Child who are all Malnourished in the HH***
gen all_chld_mnc = (tot_chldu5 == tot_chld_mal4) if tot_chldu5 >1

***There are more than one U5 Child who are all NOT Malnourished in the HH***
gen all_chld_none_mnc = (tot_chld_mal4==0) if tot_chldu5>1

***There are more than one U5 Child and some of them are Malnourished in the HH***
gen some_chld_mnc = (tot_chld_mal4 != tot_chldu5) if tot_chldu5>1 & tot_chld_mal4!=0

*****Status of malnourished children in the HH according to other U5 Children's nutritional status***
gen hh_u5chld_mn_status = 1 if all_chld_mnc==1

replace hh_u5chld_mn_status = 2 if only_chld_mnc==1

replace hh_u5chld_mn_status = 3 if some_chld_mnc==1

replace hh_u5chld_mn_status = 4 if only_chld_not_mnc==1

replace hh_u5chld_mn_status = 5 if all_chld_none_mnc==1

replace hh_u5chld_mn_status = 0 if hh_u5chld_mn_status==.

label define u5_chld_mn_status 1 "All children MN" 2 "Only child and MN" 3 "Some U5C are MN" 4 "Only child and NOT MN" 5 "All U5C are NOT MN" 
 
label values  hh_u5chld_mn_status u5_chld_mn_status

lab var hh_u5chld_mn_status "Nutritional status of Under 5 children living with other under 5 Children in the HH "

tab hh_u5chld_mn_status if chld_u5==1

tab tot_chldu5 tot_chld_mal4 if chld_u5==1

tab hh_u5chld_mn_status ps_33 if chld_u5==1 [aw=wei], cel


//col 1

gen only_u5_chld_mn_np = (  hh_u5chld_mn_status==2 & ps_33==0) if chld_u5==1
tab only_u5_chld_mn_np [aw=wei]

// col 2
gen only_u5_chld_mn_p = (  hh_u5chld_mn_status==2 & ps_33==1) if chld_u5==1
tab only_u5_chld_mn_p [aw=wei]
  
// col 3
gen all_u5chld_mn_np = (  hh_u5chld_mn_status==1 & ps_33==0) if chld_u5==1
tab all_u5chld_mn_np [aw=wei]
  
 // col 4 
gen all_u5chld_mn_p = (  hh_u5chld_mn_status==1 & ps_33==1) if chld_u5==1
tab all_u5chld_mn_p [aw=wei]  
  
// col 5
  
gen some_u5_chld_mn_np = (  hh_u5chld_mn_status==3 & ps_33==0) if chld_u5==1
tab some_u5_chld_mn_np [aw=wei]
  
 // col 6 
gen some_u5_chld_mn_p = (  hh_u5chld_mn_status==3 & ps_33==1) if chld_u5==1
tab some_u5_chld_mn_p [aw=wei]  
  
 // col 7 
gen only_u5_chld_not_mn_np = (  hh_u5chld_mn_status==4 & ps_33==0) if chld_u5==1
tab only_u5_chld_not_mn_np [aw=wei]

 // col 8
gen only_u5_chld_not_mn_p = (  hh_u5chld_mn_status==4 & ps_33==1) if chld_u5==1
tab only_u5_chld_not_mn_p [aw=wei]

 //col 9
gen all_u5_chld_not_mn_np = (  hh_u5chld_mn_status==5 & ps_33==0) if chld_u5==1
tab all_u5_chld_not_mn_np [aw=wei]
  
  // col 10
gen all_u5_chld_not_mn_p = (  hh_u5chld_mn_status==5 & ps_33==1) if chld_u5==1
tab all_u5_chld_not_mn_p [aw=wei]  
 
  
  svyset psu [pweight=weight ], strata(strata) vce(linearized) singleunit(certainty)


  
svy: mean chld_d_nut4 if some_u5_chld_mn_np==1, over(sex)  
lincom _b[male] - _b[female]

svy: mean chld_d_nut4 if some_u5_chld_mn_p==1, over(sex)  
lincom _b[male] - _b[female]


svy: mean oosc if some_sac_oos_np==1, over(sex)  
lincom _b[male] - _b[female]

svy: mean oosc if some_sac_oos_p==1, over(sex)  
lincom _b[male] - _b[female]
