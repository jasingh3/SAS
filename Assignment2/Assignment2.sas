Libname Asgnmet2 'C:\1_Jasbir\UIC_Local\Spring 2017\SAS\SAS_Lab\Assignment2';
data work.allemployees;
set Asgnmet2.sales Asgnmet2.nonsales(rename=(First=First_Name 
Last=Last_Name ));
Keep Employee_ID First_Name  Last_Name  Job_Title Salary;
run;
Proc Print data=allemployees(obs=10);
run;

/*Input attributes gt assigned from Charities data set
It is evident from the output of Proc Content , Variable attributes are taken from Charities */
data contacts;
set Asgnmet2.charities Asgnmet2.us_suppliers;
run;
Proc contents data=contacts;
run;

/*Input attributes gt assigned from Charities data set
It is evident from the output of Proc Content , Length of Content Type is assigned to 1 as in us_suppliers dataset */
data contacts2;
set  Asgnmet2.us_suppliers Asgnmet2.charities;
run;
Proc contents data=contacts2;
run;

data work.allorders;
merge Asgnmet2.orders Asgnmet2.order_item;
by Order_iD;
run;

Proc Print data=allorders;
run;

data work.allorders2;
set allorders;
keep Order_ID Order_Item_Num Order_Type Order_Date Quantity Total_Retail_Price;
run;
Proc Print data=allorders2;
run;


Proc sort data=Asgnmet2.product_list;
by Product_Level;
run;

data work.listlevel;
merge Asgnmet2.product_list Asgnmet2.product_level;
by Product_Level;
Keep Product_ID Product_Name Product_Level Product_Level_Name
run;

Proc Print data=listlevel;
where Product_Level=3;
run;

Proc sort data=Asgnmet2.product_list;
by Supplier_ID;
run;

Proc sort data=Asgnmet2.supplier;
by Supplier_ID;
run;

data work.prodsup;
merge Asgnmet2.product_list(in=products) Asgnmet2.supplier (in=supploer);
by Supplier_ID; 
if products=1 and supploer=0;
run;

filename rates 'C:\1_Jasbir\UIC_Local\Spring 2017\SAS\SAS_Lab\Assignment2\rates.dat';
data Asgnmet2.fares;
infile rates;
input Origination $1-3 
Destination $6-8
Range $12-17 
CargoRate 20-23
PassengerFare 28-34 
Category 38-40 ;
run;
