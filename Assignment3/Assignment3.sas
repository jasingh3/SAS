/*IDS462 HW3*/
/*Madhuvanthi Sreedhar*/
/*Jasbir Singh*/
/*Manan Patel*/

Libname Asgnmet3 "/folders/myfolders/sasuser.v94";
/*Problem 1 Part1*/
data work.admin work.stock work.purchasing;
set Asgnmet3.employee_organization;
select(Department);
	when ('Administration') output work.admin;
	when ('Stock & Shipping') output work.stock;
	when ('Purchasing') output work.purchasing;
	otherwise ;
end;
run;

/*Problem 1 Part2*/
data work.sales(keep=Employee_ID Job_Title Manager_ID) 
     work.exec(keep= Employee_ID Job_Title);
set Asgnmet3.employee_organization;
select(Department);
	when ('Sales') do;
	output work.sales;
	end;
	
	when ('Executives') do;
	output work.exec;
	end;
	
	otherwise ;
end;
run;

proc print data= work.sales (obs=6);
Title 'First six observations of sales data';
run;

proc print data= work.exec (firstobs=2 obs=3);
Title 'Second and third observations of executives data';
run;

/*Problem 2  Part 2*/

data work.typetotals;
set Asgnmet3.order_fact;
where year(order_date) =2009;
if Order_type=1 then
TotalRetail+Quantity;
else if Order_type= 2 then
TotalCatalog+Quantity;
else if order_type = 3 then
TotalInternet+Quantity;
run; 

data testtotals;
set asgnmet3.order_fact (obs=10);
where year(order_date)=2009;
if Order_type=1 then
TotalRetail+Quantity;
else if Order_type= 2 then
TotalCatalog+Quantity;
else if order_type = 3 then
TotalInternet+Quantity;
run;  

proc print data=work.typetotals; 
Title 'List of all observations with totals';
run;

/*Probelm 2 Part2*/
data work.accTotal;
set asgnmet3.order_fact;
where year(order_date)=2011;
retain rmnth 0; 
if month(Order_Date) ne rmnth then do; 
MonthSales=0; 
rmnth=month(Order_Date); 
end; 
MonthSales+Total_Retail_Price; 
keep Order_Date Order_ID Total_Retail_Price MonthSales; 
run;


proc print data=work.accTotal; 
title 'Accumulating Totals by Month in 2011'; 
format Total_Retail_Price MonthSales dollar10.2;
run;

/*Problem 3 a*/
data work.PRINCIPAL;
DO SUBJ = 1 TO 200;
      	X1 = ROUND(RANNOR(123)*50 + 500);
      	X2 = ROUND(RANNOR(123)*50 + 100 + .8*X1);
      	X3 = ROUND(RANNOR(123)*50 + 100 + X1 - .5*X2);
      	X4 = ROUND(RANNOR(123)*50 + .3*X1 + .3*X2 + .3*X3);
      	OUTPUT;
		drop SUBJ;/*variable counter for the loop*/
   	END;
	RUN;

Proc Print data=PRINCIPAL;

run;

/*Problem 3 b*/
ods graphics on;
proc factor data=PRINCIPAL 
plots=scree ; 
run;
ods graphics off;

/*Problem 3 c*/

/*Looking at the scree plot we will maintain first two factors because this the place where the smooth decrease of eigenvalues appears to level off  
And also as per Kaiser criterion, we can retain only factors with eigenvalues greater than 1 which is true for fisrt 2 variables*/

ods graphics on;
proc factor data=PRINCIPAL 
nfactors=2 rotate=varimax reorder
plots=scree;
run;
ods graphics off;
/*With the REORDER option in effect, you can see the variable clusters clearly in the factor pattern. 
The first factor is associated more with the first three variables (first three rows of variables): X1, X2, X4. 
The second factor is associated more with the last two variables (last two rows of variables): X4, X3*/







