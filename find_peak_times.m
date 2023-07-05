function times = find_peak_times(cor,threshold,time_ints,time_inds)
    inds = find(abs(cor) > threshold); %why do we use absolute value here? wouldn't that be completely opposite?
    
    %remove subsequent adjacent samples above threshold so we just get the
    %first point above threshold
    %k = 1;
    %while k < length(inds)
    %   if (length(inds) > k) && (inds(k)+1) == inds(k+1) %if there's two subsuquent indicies over the threshold
    %       if (length(inds) > (k+1)) && (inds(k)+2) == inds(k+2) %same but three
    %            if (length(inds) > (k+2)) && (inds(k)+3) == inds(k+3) %same but four
    %                inds = inds([1:k (k+4):end]); %cut out all the subsequent samples, preserve only the first index
    %            end
    %            inds = inds([1:k (k+3):end]);
    %       end
    %       inds = inds([1:k (k+2):end]);
    %   end
    %   k = k+1;
    %end

    k = 1;
    while k < length(inds)
        j = 1; %denotes the subsequent index that k is being compared to
        while length(inds) > k + j - 1 && inds(k + j - 1) + 1 == inds(k + j)
            j = j + 1;
        end
        if k + j <= length(inds)
            inds = inds([1:k (k+j):end]);
        else
            inds = inds(1:k);
        end
        k = k + 1;
    end

    window = 2; %establish how long the "maximum" occurs for purposes of generating a well-fitting parabola; 2 indicates a 4-index window

    times = zeros(length(inds),1); %establish an array to store the peak times corresponding to the parabolas modeled after the selected indices

    %dt = 0.357142855867863; %%sets the change in time between each sample (in microseconds)
    
    for k = 1:length(inds)
        %%calculate the index of the base time that this selection of points belongs to
        if inds(k) > time_inds(length(time_inds))
            base_time_ind = length(time_inds);
        else
            i = 0;
            while inds(k) > time_inds(i+1)
                i = i + 1;
            end
            base_time_ind = i;
        end
        
        base_time = time_ints(base_time_ind); %%sets the base time based on the section of time data the index falls in
        if base_time_ind == length(time_inds)
            dt = ( time_ints(base_time_ind) - time_ints(base_time_ind -  1) ) / ( time_inds(base_time_ind) - time_inds(base_time_ind - 1) );
        else
            dt = ( time_ints(base_time_ind + 1) - time_ints(base_time_ind) ) / ( time_inds(base_time_ind + 1) - time_inds(base_time_ind) );
        end

        %disp("index of maximum: " + inds(k)); %%
        %disp("base time: " + base_time); %%
        %disp("dt: " + dt); %%

        t = dt*(-window:window)'; %creates an array for the possible window of maximum (ie [-2dt;-dt;dt;2dt])
        A = [0.5*t.^2 t ones(length(t),1)]; %creates a matrix storing increments of a 0.5ax^2 + bx + c parabola to fit the points at the maximum and find a more accurate maximum
        [Q,R] = qr(A); %QR decomposition for ease of computation

        y = abs(cor(inds(k)+(-window:window))); %column vector storing values from cor starting at the first point above the threshold

        t_ind = dt*(inds(k)-250000*(base_time_ind-1)); %%calculate the amount of time above the base time that the first point above the threshold lies
        
        x = R\(Q'*y); %solve for the coefficients of the 0.5ax^2 + bx + c established earlier
        tmax = -x(2)/x(1); %solve for the time of the peak of the parabola by averaging the two roots
    
        times(k) = t_ind+tmax+base_time;
    end
    
end


%astro_file_time = 1000*mod(header_astro.gps_time_sec,100) + 1000*header_astro.gps_time_frac;
%inds = peak_detect(cor_beacon_astro,threshold);
%peak_times_beacon_astro = peak_time(cor_beacon_astro,inds,2,1000/2.8e6,astro_file_time);
%inds = peak_detect(cor_tag_astro,threshold);
%peak_times_tag_astro = peak_time(cor_tag_astro,inds,2,1000/2.8e6,astro_file_time);
