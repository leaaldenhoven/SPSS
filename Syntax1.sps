* Encoding: UTF-8.

*syntax to transform TAP percentiles into z-scores*
    
*before running this copy and paste the TAP percentiles into the columns for the z-scores and then transform them within those columns with the code below*
*also for the SCAN make sure to calculate the tap_pr_scan (using tap_pr_scan1 and 2) and use that for the transformation*


RECODE tap_z_al tap_z_da tap_z_flex tap_z_go tap_z_scan (0=-2.33) (1=-2.33) (2=-2.05) (3=-1.88) 
    (4=-1.75) (5=-1.65) (7=-1.48) (8=-1.41) (10=-1.28) (12=-1.18) (14=-1.08) (16=-0.99) (18=-0.92) (21=-0.81) 
    (24=-0.71) (27=-0.61) (31=-0.5) (34=-0.41) (38=-0.31) (42=-0.20) (46=-0.1) (50=0) (52=0.05) 
    (54=0.1) (58=0.2) (62=0.31) (65=0.39) (66=0.41) (69=0.5) (73=0.61) (76=0.71) (79=0.81) (82=0.92) (84=0.99) 
    (86=1.08) (88=1.175) (90=1.28) (92=1.41) (93=1.48) (95=1.645) (99=2.33).
EXECUTE.

*Calculate total score (Gesamt index) for visual scan
    !probably doesn't work! because this uses T-values and I have PRs*

DATASET ACTIVATE DataSet1.
COMPUTE tap_pr_scan=0.707 * (tap_pr_scan1 + tap_pr_scan2 - 100).
EXECUTE.

*transform self-estimates (grades) into z-scores*
    
*Step 1: get mean & SD for all estimates*

DESCRIPTIVES VARIABLES=se_15pre_al se_15pre_da se_15pre_flex se_15pre_go se_15pre_scan se_15post_al 
    se_15post_da se_15post_flex se_15post_go se_15post_scan
  /STATISTICS=MEAN STDDEV.

*Step 2: use mean & SD to calculate Z scores per estimation per subtest pre & post*

COMPUTE se_Zpre_al=(se_15pre_al - 9.36) / 2.202.
COMPUTE se_Zpre_da=(se_15pre_da - 8.19) / 2.354.
COMPUTE se_Zpre_flex=(se_15pre_flex - 8.68) / 2.548.
COMPUTE se_Zpre_go=(se_15pre_go - 9.58) / 2.46.
COMPUTE se_Zpre_scan=(se_15pre_scan - 9.83) / 2.093.
COMPUTE se_Zpost_al=(se_15post_al - 10.28) / 2.060.
COMPUTE se_Zpost_da=(se_15post_da - 7.23) / 2.994.
COMPUTE se_Zpost_flex=(se_15post_flex - 6.74) / 3.632.
COMPUTE se_Zpost_go=(se_15post_go - 7.85) / 3.15.
COMPUTE se_Zpost_scan=(se_15post_scan - 8) / 2.37.

*check out descriptives for the quantitative demographic variables*

DESCRIPTIVES VARIABLES= age
  /STATISTICS=MEAN STDDEV.

*check out descriptives for the categorical demographic variables*

FREQUENCIES VARIABLES=gender education diagnosis
  /ORDER=ANALYSIS.
OUTPUT MODIFY
  /SELECT TABLES
  /IF COMMANDS=["Frequencies(LAST)"] SUBTYPES="Frequencies"
  /TABLECELLS SELECT=[VALIDPERCENT CUMULATIVEPERCENT] APPLYTO=COLUMN HIDE=YES
  /TABLECELLS SELECT=[TOTAL] SELECTCONDITION=PARENT(VALID MISSING) APPLYTO=ROW HIDE=YES
  /TABLECELLS SELECT=[VALID] APPLYTO=ROWHEADER UNGROUP=YES
  /TABLECELLS SELECT=[PERCENT] SELECTDIMENSION=COLUMNS FORMAT="PCT" APPLYTO=COLUMN
  /TABLECELLS SELECT=[COUNT] APPLYTO=COLUMNHEADER REPLACE="N"
  /TABLECELLS SELECT=[PERCENT] APPLYTO=COLUMNHEADER REPLACE="%".

*check out descriptives for core variables*
    
DESCRIPTIVES VARIABLES=sea_adq tap_z_al tap_z_da tap_z_flex tap_z_go
  /STATISTICS=MEAN STDDEV.
