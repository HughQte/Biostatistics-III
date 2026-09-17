*bui-5503-college-student-data.sas
	author: Hieu Bui
	date: 2026-08-29
	purpose: modify the college student dataset
	license: public domain;

libname perm "/home/u64368263/medb5503/data";

proc import datafile="/home/u64368263/medb5503/data/college student data.sav"
    out=perm.college_data
    dbms=sav
    replace;
run;

proc print data=perm.college_data (obs=10);
run;

proc contents data=perm.college_data;
run;

proc sort data=perm.college_data;
	by gender;
run;

* desciptive analysis by gender;
proc means data=perm.college_data;
	by gender;
	var height hrstv hrsstudy;
run;

* proc reg with ods predict height with pheight;
proc reg data=perm.college_data;
	by gender;
	model height=pheight;
	ods output ANOVA=anovatable;
run;

proc print data=anovatable;
run;

* Run a logistic regression in SAS with “television shows-sitcoms” 
as outcome variable and use age and gender to predict the outcome variable;
proc logistic data=perm.college_data;
	ods output Parameterestimates = coeff;
	ods output Oddsratios = odds_ratios;
	model tvsitcom=age gender;
run;

proc print data= coeff;
run;

proc print data=odds_ratios;
run;

* Is there a difference in GPA between male and female students?;
proc ttest data=perm.college_data;
    class gender;
    var currgpa;
run;
