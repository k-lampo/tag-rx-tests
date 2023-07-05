function times = extract_gps_time(timestamps)
    times = zeros(length(timestamps.indices),1); %creates a zero array with a spot for each of the (40) indexed readings

    %for each of the 40 timestamps
    for k = 1:length(times)
        times(k) = 1000*mod(timestamps.gps_sec(k), 1000) + 1000*timestamps.gps_frac(k); %truncates the unix time to the final three digits, adds the fractional time, and converts to miliseconds
    end

end
