function [data,times,inds] = file_concat(filenames)

data = [];
times = [];
inds = [];

[dat, header, timestamps] = usrp_data_parser(filenames{1});
data = [dat];
times = [extract_gps_time(timestamps)];
inds = [timestamps.indices];

for k = 2:length(filenames)
    [dat, header, timestamps] = usrp_data_parser(filenames{k});
    inds = [inds; length(data)+timestamps.indices];
    times = [times; extract_gps_time(timestamps)];
    data = [data; dat];
end

end

