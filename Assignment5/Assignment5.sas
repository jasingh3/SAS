/*IDS462 HW5*/
/*Madhuvanthi Sreedhar*/
/*Jasbir Singh*/
/*Manan patel*/

Libname Asgnmet5 "C:\1_Jasbir\UIC_Local\Spring 2017\SAS\SAS_Lab\Assignment5";

filename datacar "C:\1_Jasbir\UIC_Local\Spring 2017\SAS\SAS_Lab\Assignment5\Cardata.csv";

/*Prob 1 - Part1*/
data Asgnmet5.cardata;
infile datacar dlm=',' firstobs=2;
input cyl disp HP wt accel MPG;
run;

/*Prob 1 -part 2*/
/*Equation for MPG , MPG = 45.64021 -0.04730HP -0.00579wt  */
%let predictors = cyl disp HP wt accel;
proc reg data=Asgnmet5.cardata;
	model MPG= &predictors / selection=forward slentry=0.05 P R ;
	
run;

/*Prob1-Part3*/
/*Considering a p value threshold of 0.05, the insignificant variables are
cyl disp and accel because their p value is much higher than 0.05*/

/*Prob1-part4*/

%let predictors1 = wt HP;
proc reg data=Asgnmet5.cardata;
	model MPG= &predictors1; 
run;

/*Prob1-part4 a*/
/*Equation for MPG , MPG = 45.64021 -0.04730HP -0.00579wt  */

/*Prob1 - part4 b*/

/*The actual information in a data is the total variation it contains. 
What R-Squared tells us is the proportion of variation in the dependent (response) variable that has been explained by this model.

So Accuracy will be = R-Square value i.e How much varaibility is decribed by the independent variable 
wt describe 69% variation in dependent variable 
Similary Variable HP describe 70% variation in dependent variable .*/

/*Prob1 - part4 c*/

%let predictors1 = wt HP;
proc reg data=Asgnmet5.cardata  ;
	model MPG= &predictors1 ;
Output 	Out=Asgnmet5.cardata_Resid RESIDUAL=Resid; 
	
run;

Proc print data=Asgnmet5.cardata_Resid;
run;

%let predictor1 = wt;
%let predictor2=HP;
proc  gplot data=Asgnmet5.cardata_Resid;
	plot Resid * &predictor1 ; 
	plot Resid * &predictor2 ; 
run;

/* Yes Residual is  randomly distributed */

/*Prob 2*/

data Asgnmet5.gpadta;
input GPA HS_GPA BOARD IQ;
datalines;
3.9   3.8   680   130
3.9   3.9   720   110
3.8   3.8   650   120
3.1   3.5   620   125
2.9   2.7   480   110
2.7   2.5   440   100
2.2   2.5   500   115
2.1   1.9   380   105
1.9   2.2   380   110
1.4   2.4   400   110
;

%let indepVar = HS_GPA BOARD IQ;
%let mselect = MAXR;
%let threshold = 0.05;


%macro regGPA(var, selmod , ent);
proc reg data=Asgnmet5.gpadta;
   		model GPA=&var / P R 
   		selection = &selmod
		slentry= &ent;
run;
%mend regGPA;

%regGPA(&indepVar,&mselect,&threshold)

/*Prediction equation:
GPA = 1.11962+ 0.36602 HS_GPA +0.00504 BOARD -0.01802 IQ */



