	Libname project2 "C:\1_Jasbir\UIC_Local\Spring 2017\SAS\SAS_Lab\Project2";

	data project2.housing;
	set project2.team24;
	run;

	/*Problem 1*/
	%let categorical = House_Style
	Heating_QC
	Central_Air
	Bedroom_AbvGr
	Fireplaces
	Mo_Sold
	Yr_Sold
	Full_Bathroom
	Half_Bathroom
	Total_Bathroom
	Season_Sold
	Garage_Type_2
	Foundation_2
	Masonry_Veneer
	Lot_Shape_2
	House_Style2
	Overall_Qual
	Overall_Qual2
	Overall_Cond
	Overall_Cond2  ;

	%let interval = Lot_Area
		Year_Built
		Gr_Liv_Area
		Garage_Area
		SalePrice
		Basement_Area
		Deck_Porch_Area
		Age_Sold
		Log_Price;
		
	%let interval_new = Lot_Area
		Year_Built
		Gr_Liv_Area
		Garage_Area
		Basement_Area
		Deck_Porch_Area
		Age_Sold;

proc print data = project2.housing;
title 'List of attributes involved in assessing home values';
run;

/*Problem 2*/
proc univariate data=project2.housing;
   var &interval;
   histogram;
   title 'Univariate analysis of continuos variables';
run;

proc freq data = project2.housing;
tables &categorical/plots = freq plot ; 
title 'Frequency measures of categorical variables';
run;

/*Problem 3*/


/*SalesPrice Distribution Analysis*/

ods graphics;
ods select histogram;
proc univariate data=project2.housing noprint;
   var salePrice;
   histogram salePrice / normal kernel;
   inset n mean std / position=ne;
   title "SalesPrice Distribution Analysis";
run;

/* T-Test to check mean of SalePrice is $135,000 in the data set*/
/*We reject the null Hypothesis , Mean is not equal to 135000 at alpha value of 0.05*/

proc ttest data=project2.housing H0=135000 ALPHA=0.05
           plots(only shownull)=interval;
   var salePrice ;
   title 'Testing Whether the Mean Sales Price=135000';
run;
title;

/*Problem 4*/
proc ttest data=project2.housing plots(shownull)=interval;
   class Masonry_Veneer;
   var SalePrice;
   title "Comparing mean Sales Price for homes with and without Masonry Veneer";
run;
/*
 * Null hypothesis: The mean Sale price for homes with and without masonry_veneer is same
 * Alternate hypothesis: The mean Sale price for homes with and without masonry_veneer is not same
 
 * Because the p-value for the Equality of Variances test is greater than the alpha level of 0.05, we would not reject the null hypothesis.
This conclusion supports the assumption of equal variance (the null hypothesis being tested here).
 That is, there is not enough strong evidence to say conclusively that the mean sale price of homes with masonary
 veneer is different from those without */

/*Problem 5*/
/*Scatter Plote between all continous variables and SalePrice*/
proc sgscatter data=project2.housing;
plot salePrice * (&interval);
   title "Scatter Plots &interval vs SalesPrice";
run;

/* Box Plot for All categorocal variables against SalePrice*/
%macro BoxPlot;
%local i next_name;
%do i=1 %to %sysfunc(countw(&categorical));
   %let next_name = %scan(&categorical, &i);
   proc sgplot data=project2.housing;
   vbox SalePrice/ category=&next_name
                    connect=mean;
   title "Box Plot of Sale Price W.R.T &next_name";
run;
%end;
%mend BoxPlot;

/*Run Macro Variable for Box Plot */
%BoxPlot

/*Problem 6*/
proc sgplot data=project2.housing;
    vbox SalePrice / category=Heating_QC connect=mean;
    title "Sale Price Differences across Heating Qualities";
run;


ods graphics;
proc  anova data=project2.housing  ;
   class Heating_QC;
   model SalePrice=Heating_QC;
   means Heating_QC /  hovtest=levene ;
   title "One-Way ANOVA of Sale Price with Heating_QC as Predictor";
run;
/*The overall F value from the analysis of variance table is associated with a p value= <.0001. Presuming that all
assumptions of model are valid, we know that at least one heating Quality is different from other heating types.
The Levene's Test for Homogeneity of Variance shows a p-value lesser than alpha(0.05).
 Therefore, we reject hypothesis of homogenity of variances (equal variances across Heating Quality types) */

/*Problem 7 */
%Let categorical_1 =Heating_QC ;

Proc GLM data=project2.housing ;
class &categorical_1;
model SalePrice=&categorical;
means &categorical_1;
lsmeans &categorical;
 title "Two way Anova Heating_QC as Predictor";
run;

/*Problem 8*/

PROC CORR DATA=project2.housing ;
	var SalePrice;
	WITH &interval;
	RUN;

/*The corr procedure shows the relationship of all the continuous ariables with sale price. The results show that the
relation is  positive for all the variables except for age of the house when sold which has
negative correlation. Keeping 60% as a threshold, it can be observed that lot area, garage area and deck porch area 
have lesser correlation and the rest have stronger correlation  */

/*Problem 9*/

	/*Linear Regression Model*/
/*Model Equations : SalePrice=179946 -904*Age_Sold */

/*Age_sold has highest correlation with SalePrice*/

%Let interval = Age_sold;
 proc reg data=project2.housing ;
      model SalePrice=&interval;
	  title "Linear Regreession SalesPrice & Age_Sold";
   run;

/*Problem 10*/
proc sgplot data=project2.housing;
title 'Plot of SalePrice versus Heating_QC and Season_Sold ';
   vline Season_Sold / group=Heating_QC 
                    stat=mean 
                    response=SalePrice 
                    markers;
                    
run;
/*It appears that heating quality affects the sale price of homes. However the effect is not consistent across
the seasons sold. 
The price of the Fa heating type  gradually increases over seasons , for Ex and TA types gradually decreases
over seasons. The Gd type , the price increases and decreases consistently. */

/* Problem 11*/
/*Two way Anova*/
proc glm data=project2.housing plots(only)=intplot;
   class Heating_qc season_sold;
   model SalePrice=Heating_qc|season_sold;
   lsmeans season_sold*Heating_qc / slice=Heating_qc;
   store team24;
   title "Two way Anova";
run;

proc plm restore= team24 plots=all;
   slice season_sold*Heating_qc / sliceby=Heating_qc adjust=tukey;
   effectplot interaction(sliceby= Heating_qc) / clm;
run;

proc glm data=project2.housing plots(only)=diagnostics;
   class Season_Sold Heating_QC;
   model SalePrice=Season_Sold|Heating_QC;
   run;
quit;
/*Across all sum of squares types, it can be observed that the sale price is significally different 
across all heating_QC types where as among the season sold and heating_QC by season sold are not statistically
significant. */

/*Problem 12*/

proc reg data= project2.housing;
model SalePrice = Lot_Area Basement_Area;
TITLE 'Regression model of Sales Price with Lot Area and Basement Area as predictor variables';
run;
quit;
/*The reg model results show that both lot area and basement area are significant variables.
The equantion for sales price is , SalePrice = 70474 + 0.75182 Lot_Area + 69.20341 Basement_Area */

/*Problem 13*/
%macro GlmSelect(type);
proc glmselect data=project2.housing plots=all;
   model SalePrice= &interval / SELECTION=STEPWISE DETAILS=STEPS
									SELECT=&type
									SLSTAY= 0.05;
	title ''&type' selection';								
run;
quit;
%mend modsel;

 *SL, AIC, BIC, AICC, and SBC ;

%GlmSelect(Sl);
%GlmSelect(AIC);
%GlmSelect(BIC);
%GlmSelect(AICC);
%GlmSelect(SBC);


/*Prroblem 14*/
%let options = rsquare adjrsq cp ;
proc reg data=project2.housing;
   		model SalePrice=&interval_new/ P R 
   		selection = &options;
   		/*plot RESIDUAL. * &interval_new; */
run;
/*6
0.7471
0.7452
6.1101
Lot_Area Gr_Liv_Area Garage_Area Basement_Area Deck_Porch_Area Age_Sold*/

