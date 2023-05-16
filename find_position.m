function r_tag = find_position(t_tag,t_beacon,r_rx)
    c = 299792458.0/1000.0; %meters/ms
    
    N = length(t_tag);
    
    J = zeros(N,2);
    
    r_tag = zeros(2,1); %initial guess
    f = zeros(N,1);
    
    for iter = 1:5
    
        for k = 1:N
            f(k) = norm(r_tag-r_rx(1:2,k)) - c*(t_tag(k)-t_beacon(k)) - norm(r_rx(1:2,k));
            J(k,:) = (r_tag - r_rx(1:2,k))'/norm(r_tag-r_rx(1:2,k));
        end
        
        r_tag = r_tag - J\f;
    
    end

end


