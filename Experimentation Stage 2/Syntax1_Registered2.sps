* Encoding: UTF-8.
* Encoding: .
* Encoding: .
* Encoding: .
* Encoding: .

DATASET ACTIVATE DataSet1.

*Exploratory analysis*

*Congruence variable*

IF ((Goalprimingpromotion=1 & Rolemodelpositive=3) | (Goalprimingprevention=2 & Rolemodelnegative=4)) Congruence = 1.
IF ((Goalprimingpromotion=1 & Rolemodelnegative=4) | (Goalprimingprevention=2 & Rolemodelpositive=3)) Congruence = 2.
IF ((Goalprimingpromotion=1 & Rolemodelnone=5) | (Goalprimingprevention=2 & Rolemodelnone=5)) Congruence = 3.
EXECUTE. 

T-TEST GROUPS=Congruence(1 2)
  /MISSING=ANALYSIS
  /VARIABLES=Average_Motivation
  /CRITERIA=CI(.95).

*Preregistered*

*Filter*

USE ALL.
COMPUTE filter_$=(Finished = 1 & major = 1 & age >= 18 ).
VARIABLE LABELS filter_$ 'Finished = 1 & major = 1 & age >= 18 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.


*Randomization check*

CROSSTABS
  /TABLES=cultural_background sex BY Goalpriming Rolemodel
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ CORR 
  /CELLS=COUNT EXPECTED ROW COLUMN 
  /COUNT ROUND CELL.

*Averages*

COMPUTE Average_Adjustment=MEAN(adjustment_1,adjustment_2,adjustment_3,adjustment_4,adjustment_5).
EXECUTE.

COMPUTE Average_Motivation=MEAN(motivation_1,motivation_2,motivation_3,motivation_4,motivation_5,
    motivation_6,motivation_7,motivation_8,motivation_9,motivation_10,motivation_11,motivation_12,
    motivation_13,motivation_14).
EXECUTE.

*Manipulation check*

DATASET ACTIVATE DataSet1.
T-TEST GROUPS=Rolemodel2(3 4)
  /MISSING=ANALYSIS
  /VARIABLES=Average_Adjustment
  /CRITERIA=CI(.95).

*Regression analysis*

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT age
  /METHOD=ENTER academic_year.

*Reliability test*

RELIABILITY
  /VARIABLES=motivation_1 motivation_2 motivation_3 motivation_4 motivation_5 motivation_6 
    motivation_7 motivation_8 motivation_9 motivation_10 motivation_11 motivation_12 motivation_13 
    motivation_14
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /SUMMARY=TOTAL.

RELIABILITY
  /VARIABLES=adjustment_1 adjustment_2 adjustment_3 adjustment_4 adjustment_5
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /SUMMARY=TOTAL.

*Factor Analysis*
  
FACTOR
  /VARIABLES adjustment_1 adjustment_2 adjustment_3 adjustment_4 adjustment_5 motivation_1 
    motivation_2 motivation_3 motivation_4 motivation_5 motivation_6 motivation_7 motivation_8 
    motivation_9 motivation_10 motivation_11 motivation_12 motivation_13 motivation_14
  /MISSING LISTWISE 
  /ANALYSIS adjustment_1 adjustment_2 adjustment_3 adjustment_4 adjustment_5 motivation_1 
    motivation_2 motivation_3 motivation_4 motivation_5 motivation_6 motivation_7 motivation_8 
    motivation_9 motivation_10 motivation_11 motivation_12 motivation_13 motivation_14
  /PRINT UNIVARIATE INITIAL CORRELATION SIG KMO EXTRACTION ROTATION
  /FORMAT SORT BLANK(.60)
  /PLOT EIGEN
  /CRITERIA MINEIGEN(1) ITERATE(25)
  /EXTRACTION PAF
  /CRITERIA ITERATE(25)
  /ROTATION VARIMAX
  /METHOD=CORRELATION.

*Believability*

FREQUENCIES VARIABLES=believability
  /STATISTICS=STDDEV MINIMUM MAXIMUM MEAN
  /BARCHART FREQ
  /ORDER=ANALYSIS.

*Post Hoc*

*H1 / H2*

UNIANOVA Average_Motivation BY Goalpriming Rolemodel
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /POSTHOC=Goalpriming Rolemodel(BONFERRONI) 
  /EMMEANS=TABLES(OVERALL) 
  /EMMEANS=TABLES(Goalpriming) COMPARE ADJ(BONFERRONI)
  /EMMEANS=TABLES(Rolemodel) COMPARE ADJ(BONFERRONI)
  /EMMEANS=TABLES(Goalpriming*Rolemodel) COMPARE(Goalpriming) ADJ(BONFERRONI)
  /CRITERIA=ALPHA(0.05)
  /DESIGN=Goalpriming Rolemodel Goalpriming*Rolemodel.


*H3 / H4*

UNIANOVA Average_Motivation BY Congruence
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /POSTHOC=Congruence(BONFERRONI) 
  /CRITERIA=ALPHA(0.05)
  /DESIGN=Congruence.

*Extension*

*H5*

T-TEST GROUPS=Cultural_Background_Recoded(1 2)
  /MISSING=ANALYSIS
  /VARIABLES=Average_Motivation
  /CRITERIA=CI(.95).



