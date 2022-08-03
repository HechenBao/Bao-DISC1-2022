The files with similar names are used for different ROIs, eg: CA, DGCA3, MDIC. The main body of the scripts are the same, except the ROI names. 

filter_2sIIR.m – (function) Used to remove artifacts from the raw data

Rep_threshold_homecage_XXX.m – (function) Core script to apply multiple thresholds to the data, and get calcium events associated with homecage behavior.

Pool_output_XXX.m – (function) Used to combine the output of individual animals.

execute_homecage_XXX.m – (function) Master script to run analysis and export data. 

hc_raw_corr_XXX.m – (function) Used to measure the correlation of two ROIs.  

