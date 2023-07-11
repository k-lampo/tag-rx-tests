# tag-rx-tests
general file structure (in order of execution):
data_cor_ae  &   data_cor_jj: Correlates all .dat files and saves off one correlated data file for each inputted .dat file. Can be run at the same time to pseudo-parallelize the process.
	file_concat: Passes a given .dat file to usrp_data_parser to be read and returns clean data
	    usrp_data_parser: Reads the custom .dat file structure to extract signal and time data
	    extract_gps_time: Turns the timestamps from usrp_data_parser into something readable/useful
	prngen: Generates the pseudo-random number code produced by the beacon and tag
	    prnresample: Resamples the PRN codes to match the sampling rates of the receivers
    xcnorm: Correlates the receiver data with the PRN codes, can be turned into a .mex file for efficiency

collect_peaks: Takes in the correlated data and converts it into files with peak values
	find_peak_times: Determines peak times by fitting a parabola to clusters of peaks above a given threshold

collect_positions: Turns the peaks into position values in the local frame of reference
	test_coordinates: Returns the locations of the beacon/receivers in a frame of reference centered on the beacon
    beacon_sorter: Aligns a set of beacon peaks in one coherent array so that each row represents one beacon pulse across all four receivers
    tag_sorter: Same as beacon_sorter, just for tag peaks
	find_offsets_good_units: Calculates the offset values for a set of four beacon peaks all representing the same pulse
	find_position_good_units: Runs the lsq-regression method to determine the position of the tag at a given time

data_analysis: Calculates residuals and produces plots with the outputted data
