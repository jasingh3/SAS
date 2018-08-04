/*IDS462 HW6*/
/*Madhuvanthi Sreedhar*/
/*Jasbir Singh*/
/*Manan patel*/

/*libname Asgnmet6 "/folders/myfolders/sasuser.v94";*/

libname Asgnmet6 "C:\1_Jasbir\UIC_Local\Spring 2017\SAS\SAS_Lab\Assignment6";

/*Problem 1 part a*/
data fsp;
set Asgnmet6.orders_midyear;
keep Customer_ID Months_Ordered Total_Order_Amount;
array Mon{*} month:;
if dim(Mon) < 3 then do;
put 'insufficient data for FSP';
stop;
end;
Total_Order_Amount=0;
Months_Ordered=0;
do i=1 to dim(Mon);
if Mon{i} ne . then Months_Ordered+1;
Total_Order_Amount+Mon{i};
end;
if Total_Order_Amount>1000 and Months_Ordered >= (dim(Mon))/2;
run;


/*Problem 1 part b*/
proc print data=fsp;
title 'List of frequent shoppers ';
format Total_Order_Amount dollar10.2;
run;

/*Problem 2 part a*/


data passed failed; 
set Asgnmet6.testanswers; 
drop i; 
array Answer{10} Q1-Q10; 
array Key{10} $1 
_temporary_ ( 'A' , 'C' , 'C' , 'B' , 'E' , 'E' , 'D' , 'B' , 'B' , 'A'); 
Score=0; 
do i= 1 to 10 ; 
if Key{i}=Answer{i} then Score + 1 ; 
end ; 
if Score >= 7 then output passed; 
else output failed; 
run; 

/*Problem 2 part b*/

proc print data =passed; 
title 'Employees who passed' ; 
run; 


/* Problem 3 */

data chData;    
DO TREAT = 'STATIN A','STATIN B', 'PLACEBO ';          
DO SUBJ = 1 TO 10;             
INPUT CHOLESTEROL @;             
OUTPUT;           
END;    
END; 
DATALINES; 
220  190  180  185  210  170  178  200  177  189  
160  168  178  200  172  155  159  167  185  199  
240  220  246  244  198  238  277  255  190  188
; 
run; 
 
proc print data = chData; 
title 'Cholesterol readings'; 
run; 

/*One way Anova*/
PROC ANOVA data = chData;
CLASS TREAT; 
MODEL CHOLESTEROL = TREAT;
TITLE "Analysis of Variance in Cholesterol Treatment One Way Anova "; 
RUN; 

PROC ANOVA DATA=chData;   
CLASS TREAT; 
MODEL CHOLESTEROL = TREAT;    
MEANS TREAT / SNK;    
TITLE "Analysis of Variance in Cholesterol Treatment Student-Newman-Keuls "; 
RUN;

