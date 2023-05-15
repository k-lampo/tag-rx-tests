function times = peak_time(cor, inds, window, dt)

times = zeros(length(inds),1);

t = dt*(-window:window)';
A = [0.5*t.^2 t ones(length(t),1)];
[Q,R] = qr(A);

for k = 1:length(inds)
    y = abs(cor(inds(k)+(-window:window)));
    t0 = dt*(inds(k)-1);
    
    x = R\(Q'*y);
    tmax = -x(2)/x(1);

    times(k) = t0+tmax;
end

end

