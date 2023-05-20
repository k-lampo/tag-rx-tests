function offsets = find_offsets(t_beacon,r_rx,r_beacon)
    global_constants;

    N = length(t_beacon);
    A = eye(N) + [[0; ones(N-1,1)], zeros(N,N-1)];

    b = zeros(N,1);
    for k = 1:N
        b(k) = t_beacon(k) - norm(r_rx(:,k)-r_beacon)/c;
    end

    times = A\b;

    offsets = times(2:end);
end