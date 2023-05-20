function r_tag = find_position(t_tag,t_offset,r_rx)
    global_constants;
    
    N = length(t_tag);
    
    x = zeros(3,1); %initial guess

    % for iter = 1:5
    %     f = residual(x);
    %     J = jacobian(x);
    %     %step = -J\f;
    %     step = -(J'*J + 1e-6*eye(3))\(J'*f);
    %     xnew = x + step;
    %     fnew = residual(xnew);
    %     alpha = 1.0;
    %     while norm(fnew) > norm(f)
    %         alpha = 0.5*alpha;
    %         xnew = x + alpha*step;
    %         fnew = residual(xnew);
    %     end
    %     x = xnew;
    % end

    function [f,J] = res(x)
        f = zeros(N,1);
        f(1) = norm(x(1:2)-r_rx(1:2,1))/c - 1e3*t_tag(1) + x(3);
        for k = 2:N
            f(k) = norm(x(1:2)-r_rx(1:2,k))/c - 1e3*t_tag(k) + x(3) + 1e3*t_offset(k-1);
        end
        J = zeros(N,3);
        for k = 1:N
            J(k,:) = [(x(1:2) - r_rx(1:2,k))'/(c*norm(x(1:2)-r_rx(1:2,k))), 1];
        end
    end

    options = optimoptions('lsqnonlin','SpecifyObjectiveGradient',true,'Algorithm','levenberg-marquardt','Display','iter');
    xsol = lsqnonlin(@res, x, [], [],options);


    

    % function f = residual(x)
    %     f = zeros(N,1);
    %     f(1) = norm(x(1:2)-r_rx(1:2,1))/c - 1e3*t_tag(1) + x(3);
    %     for k = 2:N
    %         f(k) = norm(x(1:2)-r_rx(1:2,k))/c - 1e3*t_tag(k) + x(3) + 1e3*t_offset(k-1);
    %     end
    % end
    % 
    % function J = jacobian(x)
    %     J = zeros(N,3);
    %     for k = 1:N
    %         J(k,:) = [(x(1:2) - r_rx(1:2,k))'/(c*norm(x(1:2)-r_rx(1:2,k))), 1];
    %     end
    % end

    r_tag = xsol(1:2);
end


