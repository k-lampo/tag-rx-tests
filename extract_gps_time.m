function times = extract_gps_time(timestamps)
    times = zeros(length(timestamps.indices),1);

    for k = 1:length(times)
        times(k) = 1000*mod(timestamps.gps_sec(k), 100) + 1000*timestamps.gps_frac(k);
    end

end
