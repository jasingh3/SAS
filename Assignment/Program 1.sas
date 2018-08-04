/*HW1 Part 2*/
filename female1 '/folders/myshortcuts/SAS_Lab/Assignment/female.csv';
data female;
	infile female1  dlm=',';   
   	input cust_ID 
   	County: $2.
   	FirstName :$15.
	LastName :$20.
    BirthDate mmddyy10.
	Customer_Type:$40.;
run;


