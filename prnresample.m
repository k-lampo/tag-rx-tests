function prnresamp = prnresample(prn,up,dn)
%PRNRESAMPLE interpolate then decimate to reach a desired sample rate

prnup = kron(prn, ones(up,1));

prnresamp = decimate(prnup, dn);

end

