function r_tag = find_position(t_tag,t_beacon,r_rx)
    c = 299792458.0/1000.0; %meters/ms
    
    N = length(t_tag);
    
    J = zeros(N,3);
    
    x = zeros(3,1); %initial guess
    f = zeros(N,1);
    fnew = zeros(N,1);

    for iter = 1:10
    
        for k = 1:N
            f(k) = norm(x(1:2)-r_rx(1:2,k)) + c*x(3) - c*(t_tag(k)-t_beacon(k)) - norm(r_rx(1:2,k));
            J(k,:) = [(x(1:2) - r_rx(1:2,k))'/norm(x(1:2)-r_rx(1:2,k)) c];
        end
        
        dx = (J'*J + 1e-4*eye(3))\(J'*f);

        a = 1.0;
        fnew = 2*f;
        while norm(fnew) > norm(f)
            xnew = x - a*dx;
            for k = 1:N
                fnew(k) = norm(xnew(1:2)-r_rx(1:2,k)) + c*xnew(3) - c*(t_tag(k)-t_beacon(k)) - norm(r_rx(1:2,k));
            end
            a = 0.5*a;
        end
        
        x = xnew;
    end

    r_tag = x(1:2);

end


