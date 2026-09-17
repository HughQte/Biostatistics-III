*bui-5503-mlbook-data.sas
	author: Hieu Bui
	date: 2026-09-13
	purpose: modify the mlbook dataset
	license: public domain;
	
libname stat "/home/u64368263/medb5503/data";

proc import datafile="/home/u64368263/medb5503/data/mlbook_red.csv"
    out=stat.ml
    dbms=csv
    replace;
    getnames=yes;
    datarow=2;
run;

proc print data = stat.ml (obs=10);
run;

*random-intercept model with random effect for schoolnr;
proc mixed data = stat.ml;
class schoolnr; *categorical;
model langPOST= /solution; *no predictors and /solution asks for the fixed-effects table;
random schoolnr; *allows each school to have its own random intercept;
run;

*Covariance Parameter Estimates output:
- schoolnr = 18.24 -> How much schools differ in their average langPOST.
- Residual = 62.85 -> How much students vary within a school.
- Intraclass correlation (ICC) = 18.24 / (18.24+62.85) ≈ 0.225
- Interpretation: About 22.5% of the variation in langPOST is between schools,
77.5% is within schools;
* Solution for Fixed Effects:
- Est = 41 -> overall mean of langPOST across all students and schools.
- Because there are no predictors in the model. The "solution" table only 
shows the intercept because there's nothing else to solve for;

*langPOST is predicted by IQ_verb (level 1);
proc mixed data = stat.ml;
class schoolnr; 
model langPOST= IQ_verb/solution; 
random intercept/sub=schoolnr;
run;
*after including fixed effect such IQ, it reduced variances comparing from previous model.
For every 1-unit increase in IQ_verb, langPOST increases by 2.51 points on average;

*langPOST is predicted by IQ_verb (lv1) + sch_iqv (lv2);
proc mixed data = stat.ml;
class schoolnr; 
model langPOST= IQ_verb sch_iqv/solution; 
random intercept/sub=schoolnr;
run;
