filename proj 'C:\1_Jasbir\UIC_Local\Spring 2017\SAS\SAS_Lab\Project\project1_data_10.csv';

libname mylib 'C:\1_Jasbir\UIC_Local\Spring 2017\SAS\SAS_Lab\Project';

data mylib.project; 
infile proj dlm=',' missover dsd FIRSTOBS=9;
input POILAPSP_index  POLVOIL_USD  PORANG_USD  PPOIL_USD  PPORK_USD  PPOULT_USD  PRICENPQ_USD  PRUBB_USD  PSALM_USD 
PSAWMAL_USD   PSAWORE_USD   PSHRI_USD   PSMEA_USD   PSOIL_USD   PSOYB_USD   PSUGAEEC_USD   PSUGAISA_USD   PSUGAUSA_USD   PSUNO_USD  
 PTEA_USD  PTIN_USD  PURAN_USD   PWHEAMT_USD   PWOOLC_USD   PWOOLF_USD   PZINC_USD  ;

IF PSUGAEEC_USD="n.a." then PSUGAEEC_USD=.; /*Replacing n.a with . SAS understand missing vallues*/
run;


PROC CONTENTS data= mylib.project;
run;

  title 'Schematic Box Plot POILAPSP_index';
  proc univariate data=mylib.project robustscale plot; /*Checking for Outliers*/
var  POILAPSP_index;
run; 

ods graphics on;
  title 'Schematic Box Plot';
  proc univariate data=mylib.project ; /*Checking for Outliers*/
hist  POILAPSP_index;
run; 
ods graphics off;

/*Checking for distribution of the values , to replace with mean or median*/
title Å'Analyse PSUGAEEC_USD Distribution';
ods graphics off;
proc capability data=mylib.project noprint;
spec lsl=25 llsl=5 usl=35 lusl=3;
histogram PSUGAEEC_USD / normal( noprint )
midpoints = 20 to 35 by 5
vscale = Count
cfill = yellow
nospeclegend ;
inset lsl usl / cfill=blank;
inset n mean (25.2) cpk (25.2) / cfill=blank;
run;

title Å'Statistical Analysis';
 PROC MEANS MEAN STD mode MEDIAN KURTOSIS SKEWNESS MEDIAN Q1 Q3 data= mylib.project ;
 RUN;

 /*Replace all missing values with median and drop variable POILAPSP_Index8u*/
 title Å'Dealing with Missing ValuesÅ';
 data mylib.project_final;
 set mylib.project;
IF PSUGAEEC_USD=. then PSUGAEEC_USD=26.83;
drop POILAPSP_Index;
run;

title Å'Data SummaryÅ';
PROC CONTENTS data= mylib.project;
run;

/*Correlation of all the variables in the dataset , to check if eny varaible is highly correlated */
title Å'Variables Correlation Matrix';
Proc CORR data=mylib.project Rank out=mylib.Project_corr ;
run;

title Å'Standardized data for Factor analysisÅ';
proc standard data=mylib.project_final mean=0 std=1
              out=mylib.project_Std;
run; 

title Å'Factor analysisÅ';
ods graphics on;
proc factor data=mylib.project_final 
plots=scree;
var POLVOIL_USD  PORANG_USD  PPOIL_USD  PPORK_USD  PPOULT_USD  PRICENPQ_USD  PRUBB_USD  PSALM_USD 
PSAWMAL_USD   PSAWORE_USD   PSHRI_USD   PSMEA_USD   PSOIL_USD   PSOYB_USD   PSUGAEEC_USD   PSUGAISA_USD   PSUGAUSA_USD   PSUNO_USD  
 PTEA_USD  PTIN_USD  PURAN_USD   PWHEAMT_USD   PWOOLC_USD   PWOOLF_USD   PZINC_USD  ;
run;
ods graphics off;

title Å'Factor analysis with plotsÅ';
ods graphics on;
proc factor data=mylib.project_final 
plots=(scree initloadings pathdiagram);
var  POLVOIL_USD  PORANG_USD  PPOIL_USD  PPORK_USD  PPOULT_USD  PRICENPQ_USD  PRUBB_USD  PSALM_USD 
PSAWMAL_USD   PSAWORE_USD   PSHRI_USD   PSMEA_USD   PSOIL_USD   PSOYB_USD   PSUGAEEC_USD   PSUGAISA_USD   PSUGAUSA_USD   PSUNO_USD  
 PTEA_USD  PTIN_USD  PURAN_USD   PWHEAMT_USD   PWOOLC_USD   PWOOLF_USD   PZINC_USD  ;
run;

ods graphics off;

ods graphics on;
proc factor  data=mylib.project_final 
plots=all;
run;
ods graphics off;


title Å'Varimax RotationÅ';
ods graphics on;
proc factor nfactor=3 data=mylib.project_final out=mylib.project_Factored rotate=varimax reorder
plots=(scree pathdiagram initloadings preloadings loadings);
run;
var  POLVOIL_USD  PORANG_USD  PPOIL_USD  PPORK_USD  PPOULT_USD  PRICENPQ_USD  PRUBB_USD  PSALM_USD 
PSAWMAL_USD   PSAWORE_USD   PSHRI_USD   PSMEA_USD   PSOIL_USD   PSOYB_USD   PSUGAEEC_USD   PSUGAISA_USD   PSUGAUSA_USD   PSUNO_USD  
 PTEA_USD  PTIN_USD  PURAN_USD   PWHEAMT_USD   PWOOLC_USD   PWOOLF_USD   PZINC_USD  ;
ods graphics off;


title Å'Check for Corelation between FactorsÅ';
ods graphics on;
proc corr data=mylib.project_Factored;
var Factor1 Factor2 Factor3 ;
run;
ods graphics off;

title Å'Promax RotationÅ';
ods graphics on;
proc factor nfactor=3 data=mylib.project_final out=mylib.project_Factored rotate=promax
plots=(scree pathdiagram initloadings preloadings loadings);
var  POLVOIL_USD  PORANG_USD  PPOIL_USD  PPORK_USD  PPOULT_USD  PRICENPQ_USD  PRUBB_USD  PSALM_USD 
PSAWMAL_USD   PSAWORE_USD   PSHRI_USD   PSMEA_USD   PSOIL_USD   PSOYB_USD   PSUGAEEC_USD   PSUGAISA_USD   PSUGAUSA_USD   PSUNO_USD  
 PTEA_USD  PTIN_USD  PURAN_USD   PWHEAMT_USD   PWOOLC_USD   PWOOLF_USD   PZINC_USD  ;
run;
ods graphics off;

title Å'Equamax Rotation';
ods graphics on;
proc factor nfactor=3 data=mylib.project_final out=mylib.project_Factored rotate=equamax
plots=(scree pathdiagram initloadings preloadings loadings);
var  POLVOIL_USD  PORANG_USD  PPOIL_USD  PPORK_USD  PPOULT_USD  PRICENPQ_USD  PRUBB_USD  PSALM_USD 
PSAWMAL_USD   PSAWORE_USD   PSHRI_USD   PSMEA_USD   PSOIL_USD   PSOYB_USD   PSUGAEEC_USD   PSUGAISA_USD   PSUGAUSA_USD   PSUNO_USD  
 PTEA_USD  PTIN_USD  PURAN_USD   PWHEAMT_USD   PWOOLC_USD   PWOOLF_USD   PZINC_USD  ;
run;
ods graphics off;

title Å'Correlation between Factors After equamaxÅ';
ods graphics on;
proc corr data=mylib.project_Factored;
var Factor1 Factor2 Factor3 ;
run;
ods graphics off;

title Å'Equamax PlotsÅ';
proc factor data=mylib.project_final 
   priors=smc msa residual
   rotate=equamax
   outstat=fact_all 
   plots=(scree initloadings preloadings loadings);
var  POLVOIL_USD  PORANG_USD  PPOIL_USD  PPORK_USD  PPOULT_USD  PRICENPQ_USD  PRUBB_USD  PSALM_USD 
PSAWMAL_USD   PSAWORE_USD   PSHRI_USD   PSMEA_USD   PSOIL_USD   PSOYB_USD   PSUGAEEC_USD   PSUGAISA_USD   PSUGAUSA_USD   PSUNO_USD  
 PTEA_USD  PTIN_USD  PURAN_USD   PWHEAMT_USD   PWOOLC_USD   PWOOLF_USD   PZINC_USD  ;
run;
ods graphics off;


ods graphics on;

title Å'Promax and all plots with reorderÅ';
proc factor nfactors=3  data=mylib.project_final 
   priors=smc msa residual 
   rotate=promax reorder
   outstat=fact_all 
   plots=(scree initloadings preloadings loadings);
   var  POLVOIL_USD  PORANG_USD  PPOIL_USD  PPORK_USD  PPOULT_USD  PRICENPQ_USD  PRUBB_USD  PSALM_USD 
PSAWMAL_USD   PSAWORE_USD   PSHRI_USD   PSMEA_USD   PSOIL_USD   PSOYB_USD   PSUGAEEC_USD   PSUGAISA_USD   PSUGAUSA_USD   PSUNO_USD  
 PTEA_USD  PTIN_USD  PURAN_USD   PWHEAMT_USD   PWOOLC_USD   PWOOLF_USD   PZINC_USD  ;

run;
ods graphics off;

ods graphics on;

title Å'Varimax and all plots with reorderÅ';
proc factor  nfactors=3 data=mylib.project_final 
   priors=smc msa residual 
   rotate=varimax reorder
   outstat=fact_all 
   plots=(scree initloadings preloadings loadings preloadings(vector));
   var  POLVOIL_USD  PORANG_USD  PPOIL_USD  PPORK_USD  PPOULT_USD  PRICENPQ_USD  PRUBB_USD  PSALM_USD 
PSAWMAL_USD   PSAWORE_USD   PSHRI_USD   PSMEA_USD   PSOIL_USD   PSOYB_USD   PSUGAEEC_USD   PSUGAISA_USD   PSUGAUSA_USD   PSUNO_USD  
 PTEA_USD  PTIN_USD  PURAN_USD   PWHEAMT_USD   PWOOLC_USD   PWOOLF_USD   PZINC_USD  ;
run;
ods graphics off;

ods graphics on;
proc factor data=mylib.project_final 
   priors=smc msa residual 
   outstat=fact_all 
   plots=all;
run;
ods graphics off;


%Let rotation=Promax; %Let nfactors=3; %let a=POLVOIL_USD; %Let b=PORANG_USD ; %Let c=PPOIL_USD;
%Let d=PPORK_USD;%Let e=PPOULT_USD ;%Let f=PRICENPQ_USD;%Let g=PRUBB_USD;%Let h=PSALM_USD; %Let i=PSAWMAL_USD ;
%Let j=PSAWORE_USD;%Let k=PSHRI_USD;%Let l=PSMEA_USD;%Let m=PSOIL_USD;%Let n=PSOYB_USD;%Let o=PSUGAEEC_USD;%Let p=PSUGAISA_USD;
%Let q=PSUGAUSA_USD;%Let r=PSUNO_USD;%Let s=PTEA_USD;%Let t=PTIN_USD;%Let u=PURAN_USD;%Let v=PWHEAMT_USD;
%Let x=PWOOLC_USD;   %Let y=PWOOLF_USD;   %Let z=PZINC_USD  ;

title Å&rotation 'and all plots with reorderÅ';
proc factor nfactors=&nfactors data=mylib.project_final 
   priors=smc msa residual 
   rotate=&rotation reorder
   outstat=fact_all 
   plots=(scree initloadings preloadings loadings);
   var  &a &b &c &d &e &f &g &h &i &j &k &l &m &n &o &p &q &r
   &s &t &u &v &x &y &z;
run;
ods graphics off;

/*Creating Macro for Factor_Analysis*/
%macro factor_Analysis(rotation=Promax, nfactors=3, a=POLVOIL_USD, b=PORANG_USD , c=PPOIL_USD,
d=PPORK_USD,e=PPOULT_USD ,f=PRICENPQ_USD,g=PRUBB_USD,h=PSALM_USD, i=PSAWMAL_USD ,
j=PSAWORE_USD,k=PSHRI_USD,l=PSMEA_USD,m=PSOIL_USD,n=PSOYB_USD,o=PSUGAEEC_USD,p=PSUGAISA_USD,
q=PSUGAUSA_USD,r=PSUNO_USD,s=PTEA_USD,t=PTIN_USD,u=PURAN_USD,v=PWHEAMT_USD,
x=PWOOLC_USD,   y=PWOOLF_USD,   z=PZINC_USD );

proc factor nfactors=&nfactors data=mylib.project_final 
   priors=smc msa residual 
   rotate=&rotation reorder
   outstat=fact_all 
   plots=(scree initloadings preloadings loadings);
   var  &a &b &c &d &e &f &g &h &i &j &k &l &m &n &o &p &q &r
   &s &t &u &v &x &y &z;
run;
%mend factor_Analysis;

%factor_Analysis;
