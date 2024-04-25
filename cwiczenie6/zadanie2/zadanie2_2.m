% f0 = @(x, t, P, xc) ...
%     t * (exp(x(1) + 3 * x(2) - 0.1) + exp(-x(1) - 0.1)) ...
%     - ( (x - xc)' * P * (x - xc) < 1 ) * log(1 - (x - xc)' * P * (x - xc)) ...
%     + ( (x - xc)' * P * (x - xc) >= 1 ) * Inf;
 
grad_f0 = @(x, t, P, xc) t * [exp(x(1) + 3*x(2) - 0.1) - exp(-x(1) - 0.1); 3*exp(x(1) + 3*x(2) - 0.1)] ...
                     + (2 * P * (x - xc)) / (1 - transpose(x - xc) * P * (x - xc));
 
f0_hessian = @(x, t, P, xc) t * [exp(x(1) + 3*x(2) - 0.1), 3*exp(x(1) + 3*x(2) - 0.1); ...
                                  3*exp(x(1) + 3*x(2) - 0.1), 9*exp(x(1) + 3*x(2) - 0.1)] ...
                     + (4 * P * (x - xc) * (x - xc).' * P) ...
                     / (1 - (x - xc).' * P * (x - xc))^2 ...
                     - (2 * P) ...
                     / (1 - (x - xc).' * P * (x - xc));
 
tol = 1e-6;
epsilon = tol;
xc = [1; 1];
x0 = xc;
P = (1/8) * [7, sqrt(3); sqrt(3), 5];
 
x = x0;
x_es = {x0};
 
% Newton's method iteration
x = x0; % Starting point
 
% Parameters for backtracking line search
alpha = 0.3;  
beta = 0.8;
 
i = 2;
N = 0;
t = 1;
while true
    g = grad_f0(x, t, P, xc);           % Gradient at current point x
    H = f0_hessian(x, t, P, xc);           % Hessian at current point x
    v = -H \ g;               % Calculate the Newton direction
    Delta = -g' * v;          % Calculate the Newton decrement
 
    if Delta < epsilon      % Convergence check
        break
    end
 
    % Backtracking line search
    s = 1;                    % Initialize step size
    while f0(x + s*v, t, P, xc)> f0(x, t, P, xc) + alpha*s*g'*v
        s = beta * s;         % Reduce step size
 
    end
    x = x + s*v;              % Update the point x
    x_es{i} = x;
    N = N + 1;
    i = i + 1;
 
 
end
 
 
 
cvx_begin
    variable x_cvx(2)
    minimize(t*(exp(x_cvx(1) + 3*x_cvx(2) - 0.1) + exp(-x_cvx(1) - 0.1)) - log(1 - (x_cvx - xc)' * P * (x_cvx - xc)));
cvx_end
disp(x_cvx);
 
 
x_optimal = x; % Optimal point found by the algorithm
display(x_optimal);
f_to_minimize = @(x) f0(x, t, P, xc);
 
x_optimal_2 = fminsearch(f_to_minimize, x0);
display(x_optimal_2);
 
function f = f0(x, t, P, xc)
    % Ensure that x and xc are column vectors
    x = x(:);
    xc = xc(:);
 
    % Calculate the first exponential term
    term1 = exp(x(1) + 3*x(2) - 0.1);
 
    % Calculate the second exponential term
    term2 = exp(-x(1) - 0.1);
 
    % Calculate the quadratic form (x - xc)'*P*(x - xc)
    quadratic_form = (x - xc)' * P * (x - xc);
 
    % Ensure the argument of the logarithm is positive
    if quadratic_form >= 1
        log_term = Inf;
    else
        % Calculate the logarithmic term
        log_term = -log(1 - quadratic_form);
 
        % Combine all the terms to get f
 
    end
    f = t * (term1 + term2) + log_term;
end