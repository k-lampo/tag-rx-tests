function r_tag = find_position3(t_tag,t_offset,r_rx)
    c = 299792458.0/1000.0; %meters/ms
    
    N = length(t_tag);
    
    x = zeros(3,1); %initial guess

    for iter = 1:5
        f = residual(x);
        J = jacobian(x);
        x = x - J\f;
    end

    function f = residual(x)
        f = zeros(N,1);
        f(1) = norm(x(1:2)-r_rx(1:2,1))/c - t_tag(1) + x(3);
        for k = 2:N
            f(k) = norm(x(1:2)-r_rx(1:2,k))/c - t_tag(k) + x(3) + t_offset(k-1);
        end
    end

    function J = jacobian(x)
        J = zeros(N,3);
        for k = 1:N
            J(k,:) = [(x(1:2) - r_rx(1:2,k))'/(c*norm(x(1:2)-r_rx(1:2,k))), 1];
        end
    end

    r_tag = x(1:2);
end


