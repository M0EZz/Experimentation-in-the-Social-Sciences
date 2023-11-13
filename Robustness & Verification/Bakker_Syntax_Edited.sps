* Encoding: UTF-8.

*create new variable for treatment indicator*
 
COMPUTE treatment=1.
IF (NFC_ReplicationKam_DO_T_Control = 2) treatment=1.
IF (NFC_ReplicationKam_DO_T_DemProp_RepOp = 2) treatment=2.
IF (NFC_ReplicationKam_DO_T_RepProp_DemOp = 2) treatment=3.
EXECUTE.

*Partisanship*

COMPUTE partisanship=99.
IF (pid2 = 1) partisanship=1. 
IF (pid2 = 2) partisanship=2.
IF (pid4 = 2) partisanship=3.
IF (pid4 = 3) partisanship=4.
IF (pid4 = 1) partisanship=5.
IF (pid3 = 2) partisanship=6.
IF (pid3 = 1) partisanship=7.
EXECUTE.

missing values partisanship (99).

*Inparty dummy

COMPUTE inparty=99.
IF ((partisanship<4 & treatment=2) | (partisanship>4 & treatment=3)) inparty=1.
IF ((partisanship<4 & treatment=3) | (partisanship>4 & treatment=2) | (treatment=1)) inparty=0.
EXECUTE.

*Outparty dummy

COMPUTE outparty=99.
IF ((partisanship<4 & treatment=3) | (partisanship>4 & treatment=2)) outparty=1.
IF ((partisanship<4 & treatment=2) | (partisanship>4 & treatment=3) | (treatment=1)) outparty=0.
EXECUTE.

missing values inparty outparty (99).

*Variables. 

DATASET ACTIVATE DataSet1.
RECODE SupportIrradiation (5=0) (4=0.25) (3=0.5) (2=0.75) (1=1) INTO Dependant_Variable_SofB.
VARIABLE LABELS  Dependant_Variable_SofB 'Supportoftheban'.
EXECUTE.

RECODE NfC_3 (5=1) (4=2) (3=3) (2=4) (1=5) INTO NfC3_Reversed.
EXECUTE.

RECODE NfC_4 (5=1) (4=2) (3=3) (2=4) (1=5) INTO NfC4_Reversed.
EXECUTE.

RECODE NfC_5 (5=1) (4=2) (3=3) (2=4) (1=5) INTO NfC5_Reversed.
EXECUTE.

RECODE NfC_7 (5=1) (4=2) (3=3) (2=4) (1=5) INTO NfC7_Reversed.
EXECUTE.

RECODE NfC_8 (5=1) (4=2) (3=3) (2=4) (1=5) INTO NfC8_Reversed.
EXECUTE.

RECODE NfC_9 (5=1) (4=2) (3=3) (2=4) (1=5) INTO NfC9_Reversed.
EXECUTE.

RECODE NfC_12 (5=1) (4=2) (3=3) (2=4) (1=5) INTO NfC12_Reversed.
EXECUTE.

RECODE NfC_16 (5=1) (4=2) (3=3) (2=4) (1=5) INTO NfC16_Reversed.
EXECUTE.

RECODE NfC_17 (5=1) (4=2) (3=3) (2=4) (1=5) INTO NfC17_Reversed.
EXECUTE.

COMPUTE scaleNfC=(NfC3_Reversed + NfC4_Reversed + NfC9_Reversed + NfC12_Reversed + NfC16_Reversed + 
    NfC17_Reversed + NfC5_Reversed + NfC7_Reversed + NfC8_Reversed + NfC_1 + NfC_2 + NfC_6 + NfC_10 + 
    NfC_11 + NfC_13 + NfC_14 + NfC_15 + NfC_18) / 18.
EXECUTE.

COMPUTE scaleNfC_Analysis=(scaleNfC-1)/4.
EXECUTE.

FREQUENCIES VARIABLES=scaleNfC_Analysis
  /ORDER=ANALYSIS.

COMPUTE InParty_NfC=scaleNfC_Analysis * inparty.
EXECUTE.

COMPUTE OutParty_NfC=scaleNfC_Analysis * outparty.
EXECUTE.

*Statistical Tests. 

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT Dependant_Variable_SotB
  /METHOD=ENTER inparty outparty scaleNfC_Analysis
  /SCATTERPLOT=(*ZRESID ,*ZPRED)
  /RESIDUALS HISTOGRAM(ZRESID).

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT Dependant_Variable_SotB
  /METHOD=ENTER inparty outparty scaleNfC_Analysis InParty_NfC OutParty_NfC
  /SCATTERPLOT=(*ZRESID ,*ZPRED)
  /RESIDUALS HISTOGRAM(ZRESID).

*Excercise 2. 

FREQUENCIES VARIABLES=scaleNfC
  /ORDER=ANALYSIS.
