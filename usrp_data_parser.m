
%% A script to parse data files recorded from the USRP with Charles' C++ code
% List the variable lengths in the initial header
function [dat, header, timestamps] = usrp_data_parser(filename)

% Read in the file
fid = fopen(filename, 'rb');

% Read file header
header.mac_addr = fread(fid, 6, 'uint8');
header.rf_freq = fread(fid, 1, 'double');
header.tot_num_samps = fread(fid, 1, 'int64');
header.record_time = fread(fid, 1, 'double');
header.samp_rate = fread(fid, 1, 'double');
header.samps_per_buff = fread(fid, 1, 'int64');
header.gps_lat = fread(fid, 1, 'double');
header.gps_lon = fread(fid, 1, 'double');
header.start_rx_time = fread(fid, 1, 'uint64');
header.samp_type = fread(fid, 1, 'uint8');
header.bandwidth = fread(fid, 1, 'double');
header.gain= fread(fid, 1, 'double');

%% Here, we need to loop until EOF
% Store buffers in a structure of structures?
n = 0; % Counter for the number of buffers

timestamps.indices = [];
timestamps.gps_sec = [];
timestamps.gps_frac = [];

while ~feof(fid)
    n = n+1;
    buffers(n).header.timestamp_sec = fread(fid, 1, 'uint64');
    buffers(n).header.timestamp_frac = fread(fid, 1, 'double');
    buffers(n).header.num_samps = fread(fid, 1, 'uint64');
    buffers(n).header.buff_flag = fread(fid, 1, 'uint8');

    buffers(n).data = fread(fid, [2, buffers(n).header.num_samps], 'float', 'l');
end

fclose(fid);

data = buffers(1).data;
timestamps.indices = [timestamps.indices; 1];
timestamps.gps_sec = [buffers(1).header.timestamp_sec];
timestamps.gps_frac = [buffers(1).header.timestamp_frac];
for i=2:n
    if ~isempty(buffers(i).data)
        timestamps.indices = [timestamps.indices; length(data)+1];
        timestamps.gps_sec = [timestamps.gps_sec; buffers(i).header.timestamp_sec];
        timestamps.gps_frac = [timestamps.gps_frac; buffers(i).header.timestamp_frac];
    
        data = cat(2, data, buffers(i).data);
    end
end

dat = data(1, :) + data(2, :)*1j;
dat = dat';

header.gps_time_sec = buffers(1).header.timestamp_sec;
header.gps_time_frac = buffers(1).header.timestamp_frac;

end


