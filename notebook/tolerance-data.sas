*bui-5503-tolerance-data.sas
	author: Hieu Bui
	date: 2026-09-09
	purpose: modify the tolerance dataset
	license: public domain;
	
libname stat "/home/u64368263/medb5503/data";

data tol; set stat.tolerance;
run;

proc print;
run;

*Perform correlation for Tol value for tol data;
proc corr data=tol;
var TOL11 TOL12 TOL13 TOL14 TOL15;
run;

*Using transpose;
proc transpose data=tol out=tol2;
by ID;
var TOL11 TOL12 TOL13 TOL14 TOL15;
run;

proc transpose data=tol out=tol2 (rename=
	(Col1=TOL _LABEL_=time) drop=_NAME_);
by ID;
var TOL11 TOL12 TOL13 TOL14 TOL15;
run;

proc print data=tol2;
run;

*Merging tol2 to tol1 in tol3 table;
data tol3; merge tol2 tol (keep=ID MALE EXPOSURE ); *note: merge must be followed in order;
by ID;
run;

proc print data=tol3;
run;

*use substr to extract text in the column time column; 
data tol3; set tol3;
time = substr(time, 4,2); *SUBSTR(string, start_position, <length>);
run;

proc print data=tol3;
run;

*use input to convert C to N;
data tol3; set tol3;
year=input(time, 2.0); *INPUT(column, digit_number);
drop time; *Drop time column;
run;

proc means data=tol3; var year;
run;

data tol_pp; 
	set tol;
	array Atol [11:15] tol11-tol15;
	do age=11 to 15;
		tol = Atol[age];
		time = age - 11;
		output;
	end;
	keep id age time tol male exposure;
run;

proc print data=tol_pp;
run;
