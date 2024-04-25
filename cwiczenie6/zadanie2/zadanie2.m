function f = f0(x, t, xc, P)
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
        % If the argument of log is non-positive, return Inf
        f = Inf;
    else
        % Calculate the logarithmic term
        log_term = -log(1 - quadratic_form);
        
        % Combine all the terms to get f
        f = t * (term1 + term2) + log_term;
    end
end



function grad_f0 = custom_gradient(x, xc, P)
    % Calculate the components of the gradient
    exp_term_1 = exp(x(1) + 3*x(2) - 0.1);
    exp_term_2 = exp(-x(1) - 0.1);
    grad_exp = [exp_term_1 - exp_term_2; 3*exp_term_1 - exp_term_2];
    
    % Calculate the quadratic form
    x_vector = [x(1); x(2)];
    quad_form = (x_vector - xc).' * P * (x_vector - xc);
    
    % Check for division by zero in the fraction
    denom = 1 - quad_form;
    if denom <= 0
        % In MATLAB, division by zero gives Inf or -Inf depending on the sign.
        % However, to follow the same pattern as for the logarithm,
        % we return a large number to represent infinity.
        grad_fraction = [Inf; Inf];
    else
        % Calculate the gradient of the quadratic form term
        grad_fraction = 2 * P * (x_vector - xc) / denom;
    end
    
    % Combine the components to get the final gradient vector
    grad_f0 = grad_exp + grad_fraction;
end

function hess_f0 = custom_hessian(x, xc, P)
    % Calculate the components of the Hessian
    exp_term_1 = exp(x(1) + 3*x(2) - 0.1);
    exp_term_2 = exp(-x(1) - 0.1);
    hess_exp = [exp_term_1 + exp_term_2, 3*exp_term_1;
                3*exp_term_1, 9*exp_term_1];
    
    % Calculate the quadratic form
    x_vector = [x(1); x(2)];
    quad_form = (x_vector - xc).' * P * (x_vector - xc);
    
    % Check for division by zero in the fraction
    denom = 1 - quad_form;
    if denom <= 0
        hess_fraction = [Inf, Inf; Inf, Inf]; % The entire Hessian becomes infinite
    else
        % Calculate the Hessian of the quadratic form term
        hess_quad = 4 * P * (x_vector - xc) * (x_vector - xc).' * P / denom^2;
        % Calculate the additional 2*P term
        hess_add = 2 * P / denom;
        % Combine the quadratic form Hessian and the additional term
        hess_fraction = hess_quad - hess_add;
    end
    
    % Combine the components to get the final Hessian matrix
    hess_f0 = hess_exp + hess_fraction;
end

xc = [1; 1];
x_0 = xc;
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
t = 10;
while true
    g = grad_f0(x);           % Gradient at current point x
    H = hess_f0(x);           % Hessian at current point x
    v = -H \ g;               % Calculate the Newton direction
    Delta = -g' * v;          % Calculate the Newton decrement
    
    if Delta < epsilon      % Convergence check
        break
    end
    
    % Backtracking line search
    s = 1;                    % Initialize step size
    while f0(x + s*v, t, xc, P) > f0(x, t, xc, P) + alpha*s*g'*v
        s = beta * s;         % Reduce step size
        
    end
    x = x + s*v;              % Update the point x
    x_es{i} = x;
    N = N + 1;
    i = i + 1;
    
    if N > 20
        break
    end
end

x_optimal = x; % Optimal point found by the algorithm
display(x_optimal);
f_to_minimize = @(x) f0(x, t, xc, P);

x_optimal_2 = fminsearch(f_to_minimize, x_0);
display(x_optimal_2);