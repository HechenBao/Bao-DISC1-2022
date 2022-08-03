The files with similar names are used for different ROIs, eg: CA, DGCA3, MDIC. The main body of the scripts are the same, except the ROI names. 

# **Cross Correlation analysis**

random_xcorr_XXX.m – Used to randomly shuffle and select NPR event related trials of two ROIs, and apply cross correlation analysis to study their lag and probability of distribution.  

# **General Ca2+ activity**

Rep_threshold_NP_XXX.m – (function) Core script to apply multiple thresholds to the data, and get calcium events associated with NPR behavior.

execute_NP_XXX.m – Master script to run analysis and export data.

# **Perievent Analysis**

np_XXX_event_extract.m – Used to extract trials based on the timestamp of the behavior events. 

np_XXX_stackTrials.m – Used to stack all trials based within the same group. 

XXX_zscore_diff_output11.m – Used to convert trials to zscore and measure the perievent dynamics. 

# **Reliability**

batch_random_XXX_noevent.m – Used to extract random trials that wasn’t relevant to behavior events. 

combine_randTrials_XXX.m – Used to stack all random trials within the same group.

reorganize_XXX.m – Used to combine trials from both objects.

batch_reliability.m – Core script to batch perform reliability analysis and output results. 

batch_reliability_PreEventPost.m – Core script to batch perform temporal segmented reliability analysis and output results.

disc1_reliability_plot.R – Used to generate heatmaps for temporal segmented reliability results. 
