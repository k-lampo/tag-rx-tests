function prnresamp = prnresample(prn,up,dn)
%PRNRESAMPLE interpolate then decimate to reach a desired sample rate

%outputs prn (a column vector), but each entry is repeated "up" (14) times
%before moving on to the next number
%ie [1;-1] -->
%[1;1;1;1;1;1;1;1;1;1;1;1;1;1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1]
prnup = kron(prn, ones(up,1));

%changes the sampling rate by resampling every "dn" (5) seconds - creates a
%bit of imperfection in 1/-2 values as the method estimates the square
%curve
prnresamp = decimate(prnup, dn);

end

