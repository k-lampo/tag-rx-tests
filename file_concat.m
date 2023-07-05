function [data,times,inds] = file_concat(filenames)

%initializes the results arrays
data = [];
times = [];
inds = [];

%pulls data for the first file & appends it to the beginning of each array
[dat, header, timestamps] = usrp_data_parser(filenames{1});
%data: 10 000 000 x 1 complex double array with signal readings
%header: 1x1 structure with metadata about this dataset
%timestamps: 3x1 structure with 40x1 double arrays containing indicies, the
%unix seconds of 40 evenly-spaced samples, and the fractional times of
%those same samples
data = dat;
times = [extract_gps_time(timestamps)]; %returns timestamps in milisecond format, including fractional second data
inds = [timestamps.indices]; %pulls the indicies, which start at 1 and count up by 250 000

%appends data for the rest of the files iteratively
for k = 2:length(filenames)
    [dat, header, timestamps] = usrp_data_parser(filenames{k});
    inds = [inds; length(data)+timestamps.indices]; %adds the current length of the dataset to the indicies, thus creating a consistent index system for all 25 files together
    times = [times; extract_gps_time(timestamps)];
    data = [data; dat];
end

end