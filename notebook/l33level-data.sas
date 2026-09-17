*bui-5503-l33level-data.sas
	author: Hieu Bui
	date: 2026-09-13
	purpose: modify the l33level dataset
	license: public domain;
	
libname stat "/home/u64368263/medb5503/data";

proc import datafile="/home/u64368263/medb5503/data/L33level.csv"
    out=stat.lv
    dbms=csv
    replace;
run;

proc print data=stat.lv (obs=10);
run;

*null model-no predictor;
*level 2 = cid, level 3 = school;
proc mixed data=stat.lv plots(maxpoints=none);
class cid school;
model math = /solution;
random int / subject=school;
random int / subject=cid;
run;
*total variance = 0.3243 + 0.5705 + 1.5239 = 2.4187
ICC (L3) = 0.3243/2.4187=0.134 -> 13.4% of the variance in math is between schools.
ICC (L2) = 0.5705/2.4187=0.236 -> 23.6% of variance in math is between students within schools.
ICC (L1) = 1.5239/2.4187=0.630 -> 63% of variance in math is within students overtime;

proc mixed data=stat.lv plots(maxpoints=none);
class cid school;
model math = year/solution;
random int / subject=school;
random int / subject=cid;
run;
*total variance = 0.1869 + 0.6699 + 0.3470 = 1.2038
ICClv3 = 0.1869 / 1.2038 = 0.155 (15.5%)
ICClv2 = 0.6699 / 1.2038 = 0.557 (55.7%)
ICClv1 = 0.3470 / 1.2038 = 0.288 (28.8%)
For each 1-year increase, math rises by 0.75 points on average;

* Predictor level1 (year) doesn't directly explain between-school differences (0.134 → 0.155).
Once we control for year, most of the leftover variation is now between students (0.236 → 0.557);
