function times = extract_gps_time(timestamps)
    times = zeros(length(timestamps.indices),1); %creates a zero array with a spot for each of the (40) indexed readings

    %for each of the 40 timestamps
    for k = 1:length(times)
        times(k) = mod(timestamps.gps_sec(k), 100000)*1000000 + timestamps.gps_frac(k)*1000000; %truncates the time (removing the leading 16842),combines whole and fractional time & converts to microseconds
    end

end
