function inds = peak_detect(cor, threshold)

inds = find(abs(cor) > threshold);

%Remove subsequent adjacent samples above threshold so we just get the
%first point above threshold
k = 1;
while k < length(inds)
   if (inds(k)+1) == inds(k+1)
       inds = inds([1:k (k+2):end]);
   end
   k = k+1;
end

end

