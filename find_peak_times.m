function times = find_peak_times(cor,threshold,input_times)
    inds = find(abs(cor) > threshold); %find the group of data points that are above the specified threshold

    %group subsuquent peaks, then discard all but the central one
    k = 1;
    while k < length(inds)
        j = 1; %denotes the subsequent index that k is being compared to
        while length(inds) > k + j - 1 && inds(k + j - 1) + 1 == inds(k + j) %while index of next peak = index of current peak + 1
            j = j + 1;
        end

        %determine the central index in the collected set
        if j == 1 %safety in the case no other peaks are collected
            central_index = 1;
        else
            central_index = floor(j/2) + k; %choose the central index
        end
        if k + j <= length(inds)
            inds = inds([1:(k-1) central_index (k+j):end]); %adjust the peak index set to delete all peaks in the set except the chosen central one
        else
            inds = inds([1:(k-1) central_index]); %for the case that there is no data beyond index k+j
        end
        k = k + 1;
    end

    window = 2; %establish how long the "maximum" occurs for purposes of generating a well-fitting parabola; 2 indicates a 4-index window
    dt = 1/2.8;
    times = zeros(length(inds),1); %establish an array to store the peak times corresponding to the parabolas modeled after the selected indices
    
    for k = 1:length(inds)
        
        base_time = input_times(inds(k)); %retrieves the time of the identified peak
    
        t = dt*(-window:window)'; %creates an array for the possible window of maximum (ie [-2dt;-dt;dt;2dt])
        A = [0.5*t.^2 t ones(length(t),1)]; %creates a matrix storing increments of a 0.5ax^2 + bx + c parabola to fit the points at the maximum and find a more accurate maximum
        [Q,R] = qr(A); %QR decomposition for ease of computation

        y = abs(cor(inds(k)+(-window:window))); %column vector storing values from cor starting at the first point above the threshold
        
        x = R\(Q'*y); %solve for the coefficients of the 0.5ax^2 + bx + c established earlier
        tmax = -x(2)/x(1); %solve for the time of the peak of the parabola by averaging the two roots
    
        times(k) = tmax+base_time; %add the calculated peak to the output matrix
    end
    
end

