function times = find_peak_times(cor,threshold,t0,dt)
    inds = find(abs(cor) > threshold);
    
    %Remove subsequent adjacent samples above threshold so we just get the
    %first point above threshold
    k = 1;
    while k < length(inds)
       if (length(inds) > k) && (inds(k)+1) == inds(k+1)
           if (length(inds) > (k+1)) && (inds(k)+2) == inds(k+2)
                if (length(inds) > (k+2)) && (inds(k)+3) == inds(k+3)
                    inds = inds([1:k (k+4):end]);
                end
                inds = inds([1:k (k+3):end]);
           end
           inds = inds([1:k (k+2):end]);
       end
       k = k+1;
    end

    window = 2;

    times = zeros(length(inds),1);
    
    t = dt*(-window:window)';
    A = [0.5*t.^2 t ones(length(t),1)];
    [Q,R] = qr(A);
    
    for k = 1:length(inds)
        y = abs(cor(inds(k)+(-window:window)));
        t_ind = dt*(inds(k)-1);
        
        x = R\(Q'*y);
        tmax = -x(2)/x(1);
    
        times(k) = t_ind+tmax;
    end
    
    times = times+t0;
end


%astro_file_time = 1000*mod(header_astro.gps_time_sec,100) + 1000*header_astro.gps_time_frac;
%inds = peak_detect(cor_beacon_astro,threshold);
%peak_times_beacon_astro = peak_time(cor_beacon_astro,inds,2,1000/2.8e6,astro_file_time);
%inds = peak_detect(cor_tag_astro,threshold);
%peak_times_tag_astro = peak_time(cor_tag_astro,inds,2,1000/2.8e6,astro_file_time);
