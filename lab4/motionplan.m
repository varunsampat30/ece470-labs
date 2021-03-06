% runs gradient descent while end-effector reaches goal within a tolerance
function qref = motionplan( ...
    qs, qdes, t1, t2, ...
    myrobot, obs, tol, eta, N, ...
    alpha_att, alpha_rep ...
    )

% define hyperparameters
% alpha_att = 0.013; % ~ step size along attractive potential gradient
% alpha_rep = 0.01;  % ~ step size along repulsive potential gradient

% perform gradient descent over environment with obstacles
q       = zeros(1,6);
q(1, :) = qs;
iter    = 0;
while norm(wrapTo2Pi(q(end, 1:5)) - wrapTo2Pi(qdes(1:5))) > tol ...
      && iter < N  % stop condition
    
    % get total repulsion effect from all obstacles
    tau = zeros(1, 6);
    for i = 1:size(obs, 2)
        tau = tau + rep(q(end, 1:6), myrobot, obs{i});
    end
    
    % add attraction effect of the goal pose
    tau = eta*alpha_rep*tau + alpha_att*att(q(end, 1:6), qdes, myrobot);
    
    qprime = q(end, 1:6) + tau; % apply gradient step
    q      = [q; qprime];
    
    iter = iter + 1;
end

% interpolate joint trajectory for q6
t  = linspace(t1, t2, size(q,1)); % time steps
q6 = linspace(qs(6),qdes(6),size(q,1));
q(:,6) = q6';

% apply spline interpolation over all joint angle steps
qref = spline(t, q');

end