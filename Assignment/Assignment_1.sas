libname myLib "/folders/myshortcuts/SAS_Lab/Assignment";
filename psales "/folders/myshortcuts/SAS_Lab/Assignment/Sales_Pharm.csv";

/*HW1 Part1*/
/*Madhuvanthi Sreedhar*/
/*Jasbir*/
/*Manan*/

data psales;
length prodid $ 10 category $ 20 ;
infile psales dlm=',' ;
input prodid $ category $ date mmddyy10. sales;
adjSales = 1.25*sales + 10*rand('UNIFORM');
run;

/*HW1 Part1*/
/*Madhuvanthi Sreedhar*/
/*Jasbir Singh
/*Manan Patel*/
proc sort out = myLib.newsales;
by category;
format date mmddyy10.;
run;

/*HW1 Part1*/
/*Madhuvanthi Sreedhar*/
/*Jasbir*/
/*Manan*/
proc means data = mylib.newsales noprint ;
class category;
var adjSales;
output out = aveSales mean = adjSales_mean;
run;

/*HW1 Part1*/
/*Madhuvanthi Sreedhar*/
/*Jasbir*/
/*Manan*/
proc print data = aveSales;
run;

/*HW1 Part1*/
/*Madhuvanthi Sreedhar*/
/*Jasbir*/
/*Manan*/
proc freq data =mylib.newsales;
tables category;
run;

/*HW1 Part1*/
/*Madhuvanthi Sreedhar*/
/*Jasbir*/
/*Manan*/
data hrtrel;
set myLib.psales;
where category = 'Heart related';
run;

/*HW1 Part1*/
/*Madhuvanthi Sreedhar*/
/*Jasbir*/
/*Manan*/
proc print data = hrtrel;
format date mmddyy10.;
run;

/*HW1 Part1*/
/*Madhuvanthi Sreedhar*/
/*Jasbir*/
/*Manan*/
title 'Heart Related - 5 observations';
proc print data = hrtrel(obs = 5);
format date mmddyy10.;
run;
 
/*HW1 Part2*/
filename male "/folders/myshortcuts/SAS_Lab/Assignment/male.txt";
filename female "/folders/myshortcuts/SAS_Lab/Assignment/female.csv";

data female;
infile female dlm=',';
input Cust_ID Country :$2. First_Name :$15. Last_Name :$20. Birth_Date :mmddyy10. Customer_Type :$40. ;
format Birth_Date mmddyy10.;
run;


proc freq data=female;
tables Country* Customer_Type;
run;


data male;
infile male dlm='09'x;
input Cust_ID Country :$2. First_Name :$15. Last_Name :$20. Birth_Date :mmddyy10. Customer_Type :$40. ;
format Birth_Date mmddyy10.;
run;

proc freq data=male;
tables Country*Customer_Type;
run;

/*HW1 Part3*/
data clinic;
input ID $ 1-3 Gender $ 4
Race $ 5 HR 6-8 SBP 9-11 DBP 12-14 N_proc 15-16;
ave_bp = DBP + ((1/3) * (SBP - DBP));
datalines;
001MW08013008010
002FW08811007205
003MB05018810002
004FB   10806801
005MW06812208204
006FB101   07404
007FW07810406603
008MW04811207006
009FB07719011009
010FB06616410610
;
proc means=clinic N MEAN STD CLM; 
run;
proc means data = clinic N MEAN STD CLM median;
var SBP DBP ave_bp;
run;