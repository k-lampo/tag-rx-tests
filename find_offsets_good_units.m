function offsets = find_offsets_good_units(t_beacon,r_rx,r_beacon)
    c = 299792458.0/1e8; %l = 100m, t = us

    N = length(t_beacon);
    %A = eye(N) + [[0; ones(N-1,1)], zeros(N,N-1)];

    %scale the times down to make handling units easier
    min_time = min(t_beacon);
    t_beacon = t_beacon - min_time;

    %calculate the time of transmission as measured by each reciever
    b = zeros(N,1);
    for k = 1:N
        b(k) = t_beacon(k) - norm(r_rx(:,k)-r_beacon)/c;
    end

    offsets = [0;
               b(2) - b(1);
               b(3) - b(1);
               b(4) - b(1)];

    %times = A\b;

    %offsets = [0; times(2:end)];
end