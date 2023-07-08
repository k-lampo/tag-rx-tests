function [loc_pre] = assemble_data()
%import all data from handpicked samples
astro_beacon_data = importdata("C:\Users\kathr\Documents\git\tag-rx-tests\good_section\1684275016_astro_beacon.mat");
astro_beacon = astro_beacon_data.corr();
astro_tag_data = importdata("C:\Users\kathr\Documents\git\tag-rx-tests\good_section\1684275016_astro_tag.mat");
astro_tag = astro_tag_data.corr();
astro_start_time = astro_beacon_data.time();
clear astro_beacon_data;
clear astro_tag_data;

elroy_beacon_data = importdata("C:\Users\kathr\Documents\git\tag-rx-tests\good_section\1684275016_elroy_beacon.mat");
elroy_beacon = elroy_beacon_data.corr();
elroy_tag_data = importdata("C:\Users\kathr\Documents\git\tag-rx-tests\good_section\1684275016_elroy_tag.mat");
elroy_tag = elroy_tag_data.corr();
elroy_start_time = elroy_beacon_data.time();
clear elroy_beacon_data;
clear elroy_tag_data;

jane_beacon_data = importdata("C:\Users\kathr\Documents\git\tag-rx-tests\good_section\1684275017_jane_beacon.mat");
jane_beacon = jane_beacon_data.corr();
jane_tag_data = importdata("C:\Users\kathr\Documents\git\tag-rx-tests\good_section\1684275017_jane_tag.mat");
jane_tag = jane_tag_data.corr();
jane_start_time = jane_beacon_data.time();
clear jane_beacon_data;
clear jane_tag_data;

judy_beacon_data = importdata("C:\Users\kathr\Documents\git\tag-rx-tests\good_section\1684275017_judy_beacon.mat");
judy_beacon = judy_beacon_data.corr();
judy_tag_data = importdata("C:\Users\kathr\Documents\git\tag-rx-tests\good_section\1684275017_judy_tag.mat");
judy_tag = judy_tag_data.corr();
judy_start_time = judy_beacon_data.time();
clear judy_beacon_data;
clear judy_tag_data;

%create time matrices
dt = 1/2.8; %in us; 2.8 MHz

astro_times = zeros(length(astro_beacon),1);
for i=1:length(astro_times)
    astro_times(i) = astro_start_time + (i-1)*dt;
end

elroy_times = zeros(length(elroy_beacon),1);
for i=1:length(elroy_times)
    elroy_times(i) = elroy_start_time + (i-1)*dt;
end

jane_times = zeros(length(jane_beacon),1);
for i=1:length(jane_times)
    jane_times(i) = jane_start_time + (i-1)*dt;
end

judy_times = zeros(length(judy_beacon),1);
for i=1:length(judy_times)
    judy_times(i) = judy_start_time + (i-1)*dt;
end


%find the peak times for each reciever set
astro_beacon_peaks = find_peak_times(astro_beacon,0.2,astro_times);
astro_tag_peaks = find_peak_times(astro_tag,0.12,astro_times);

elroy_beacon_peaks = find_peak_times(elroy_beacon,0.2,elroy_times);
elroy_tag_peaks = find_peak_times(elroy_tag,0.12,elroy_times);

jane_beacon_peaks = find_peak_times(jane_beacon,0.2,jane_times);
jane_tag_peaks = find_peak_times(jane_tag,0.12,jane_times);

judy_beacon_peaks = find_peak_times(judy_beacon,0.2,judy_times);
judy_tag_peaks = find_peak_times(judy_tag,0.12,judy_times);

%determine the position for the peak set
loc_pre = clean_peaks(astro_beacon_peaks,elroy_beacon_peaks,jane_beacon_peaks,judy_beacon_peaks,...
            astro_tag_peaks,elroy_tag_peaks,jane_tag_peaks,judy_tag_peaks);
end
