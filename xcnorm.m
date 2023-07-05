function cor = xcnorm(signal,bbTemplate)
    %normalized cross-correlation
    
    n = length(bbTemplate)-1; %defines the length of the signal in the template
    steps = length(signal)-n; %defines how many iterations need to be made to scan the complete input
    cor = complex(zeros(steps, 1)); %sets up a zero matrix that will be filled with correlation data
    
    parfor k = 1:steps
        l = length(signal); %establishes "signal" as a broadcast variable to reduce unncecessary overhead communication each iteration
        cor(k) = ((bbTemplate)/norm(bbTemplate))'*(signal(k:k+n)/norm(signal(k:k+n))); %takes the dot product of the normalized template and chunk of signal & stores in cor
        %why is the complex conjugate used? isn't the bb template real?
    end

end