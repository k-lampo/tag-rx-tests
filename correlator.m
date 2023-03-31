function [maxCor, index] = correlator(data,bbTemplate)

n = length(bbTemplate)-1;
steps = length(data)-n;
maxCor = zeros(steps,1);
index = zeros(steps,1);

for k = 1:steps
    pw = conj(bbTemplate).*data(k:k+n);
    ft = fft(pw);
    maxCor(k) = max(abs(ft));
end

end
