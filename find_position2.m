function r_tag = find_position2(t_tag,t_beacon,r_rx,r_b)
    global_constants;
    
    N = length(t_tag);
    
    x = zeros(7,1); %initial guess
    %x = [rx ry t0 b0 d2 d3 d4]

    for iter = 1:5
        f = residual(x);
        J = jacobian(x);
        x = x - J\f;
    end

    function f = residual(x)
        f = zeros(2*N,1);
        f(1) = norm(x(1:2)-r_rx(1:2,1))/c + x(3) - t_tag(1);
        f(2) = norm(x(1:2)-r_rx(1:2,2))/c + x(3) + x(5) - t_tag(2);
        f(3) = norm(x(1:2)-r_rx(1:2,3))/c + x(3) + x(6) - t_tag(3);
        f(4) = norm(x(1:2)-r_rx(1:2,4))/c + x(3) + x(7) - t_tag(4);
        f(5) = norm(r_b(1:2)-r_rx(1:2,1))/c + x(4) - t_beacon(1);
        f(6) = norm(r_b(1:2)-r_rx(1:2,1))/c + x(4) + x(5) - t_beacon(2);
        f(7) = norm(r_b(1:2)-r_rx(1:2,1))/c + x(4) + x(6) - t_beacon(3);
        f(8) = norm(r_b(1:2)-r_rx(1:2,1))/c + x(4) + x(7) - t_beacon(4);
    end

    function J = jacobian(x)
        J = zeros(N,7);
        J(1,:) = [(x(1:2) - r_rx(1:2,1))'/(c*norm(x(1:2)-r_rx(1:2,1))) 1 zeros(1,4)];
        J(2,:) = [(x(1:2) - r_rx(1:2,2))'/(c*norm(x(1:2)-r_rx(1:2,2))) 1 0 1 0 0];
        J(3,:) = [(x(1:2) - r_rx(1:2,3))'/(c*norm(x(1:2)-r_rx(1:2,3))) 1 0 0 1 0];
        J(4,:) = [(x(1:2) - r_rx(1:2,4))'/(c*norm(x(1:2)-r_rx(1:2,4))) 1 0 0 0 1];
        J(5,:) = [zeros(1,3) 1 zeros(1,3)];
        J(6,:) = [zeros(1,3) 1 1 0 0];
        J(7,:) = [zeros(1,3) 1 0 1 0];
        J(8,:) = [zeros(1,3) 1 0 0 1];
    end

    r_tag = x(1:2);
end


