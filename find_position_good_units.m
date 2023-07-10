function r_tag = find_position_good_units(t_tag,r_rx)
    c = 299792458.0/1e8; %l = 100m, t = us
    tag_elev = 0.0;
    
    N = length(t_tag);
    
    x = [0;0;mean([t_tag(1,:)])]; %initial guess

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
        f(1) = norm([x(1:2);tag_elev]-r_rx(:,1))/c - t_tag(1) + x(3);
        for k = 2:N
            f(k) = norm([x(1:2);tag_elev]-r_rx(:,k))/c - t_tag(k) + x(3);
        end
        J = zeros(N,3);
        for k = 1:N
            J(k,:) = [(x(1:2) - r_rx(1:2,k))'/(c*norm([x(1:2);tag_elev]-r_rx(:,k))), 1];
        end
    end

    options = optimoptions('lsqnonlin','SpecifyObjectiveGradient',true,'Algorithm','levenberg-marquardt','OptimalityTolerance',1e-9,'FunctionTolerance',1e-9,'StepTolerance',1e-10,'Display','iter');
    %options = optimoptions('lsqnonlin','SpecifyObjectiveGradient',true,'OptimalityTolerance',1e-10,'FunctionTolerance',1e-10,'Display','iter');
    xsol = lsqnonlin(@res, x, [], [],options);


    

    % function f = residual(x)
    %     f = zeros(N,1);
    %     f(1) = norm(x(1:2)-r_rx(1:2,1))/c - 1e3*t_tag(1) + x(3);
    %     for k = 2:N
    %         f(k) = norm(x(1:2)-r_rx(1:2,k))/c - 1e3*t_tag(k) + x(3);
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


