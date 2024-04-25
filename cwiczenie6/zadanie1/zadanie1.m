tol = 1e-4;
x0 = [2; -2];
epsilon = tol;

% Define the given constants and initial guess
P = (1/8) * [7, sqrt(3); sqrt(3), 5];
xc = [1; 1];

% Define the function f0
f0 = @(x1, x2, xc, P) exp(x1 + 3*x2 - 0.1) + exp(-x1 - 0.1) + ([x1; x2] - xc)' * P * ([x1; x2] - xc);

% Gradient of f0(x)
grad_f0 = @(x) [exp(x(1) + 3*x(2) - 0.1) - exp(-x(1) - 0.1);
                3*exp(x(1) + 3*x(2) - 0.1) - exp(-x(1) - 0.1)] + 2*P*(x - xc);

% Hessian of f0(x)
hess_f0 = @(x) [exp(x(1) + 3*x(2) - 0.1) + exp(-x(1) - 0.1), 3*exp(x(1) + 3*x(2) - 0.1);
                3*exp(x(1) + 3*x(2) - 0.1), 9*exp(x(1) + 3*x(2) - 0.1)] + 2*P;

% Initialize iteration variables
x = x0;
x_es = {x0};

% Newton's method iteration
while true
    g = grad_f0(x);
    H = hess_f0(x);
    v = -H \ g;
    Delta = -g' * v;
    
    if Delta < epsilon
        break
    else
        x = x + v;
        x_es{end + 1} = x;
    end
end


x1_range = linspace(-3.5, 2.5, 100);
x2_range = linspace(-2.2, 2.2, 100);


% Create a grid of x1 and x2
[X1, X2] = meshgrid(x1_range, x2_range);

% Use arrayfun to apply f0 over the grid
Z = arrayfun(@(x1, x2) f0(x1, x2, xc, P), X1, X2);

% Create the contour plot
% contour(X1, X2, Z, ,'-k');
contour(X1, X2, Z, [2.47, 3.62, 5.34, 7.59, 19.2, 50, 200, 600], 'LineColor', 'k', 'ShowText','on');
xlabel('x_1');
ylabel('x_2');

% Plot the iterative points on the contour plot
hold on;
plot(x_es{1}(1), x_es{1}(2), 'blacko', 'MarkerFaceColor', 'black'); % Blue 'o' for the iterative points
for i = 2:length(x_es)
    plot(x_es{i}(1), x_es{i}(2), 'bo', 'MarkerFaceColor', 'b'); % Blue 'o' for the iterative points
end
% hold off;


tol = 1e-4;
x0 = [2; -2];
epsilon = tol;

% Define the given constants and initial guess
P = (1/8) * [7, sqrt(3); sqrt(3), 5];
xc = [1; 1];

% Define the function f0
f0 = @(x1, x2) exp(x1 + 3*x2 - 0.1) + exp(-x1 - 0.1) + ([x1; x2] - xc)' * P * ([x1; x2] - xc);

f0_1 = @(x) exp(x(1) + 3*x(2) - 0.1) + exp(-x(1) - 0.1) + (x - xc)' * P * (x - xc);

% Gradient of f0(x)
grad_f0 = @(x) [exp(x(1) + 3*x(2) - 0.1) - exp(-x(1) - 0.1);
                3*exp(x(1) + 3*x(2) - 0.1) - exp(-x(1) - 0.1)] + 2*P*(x - xc);

% Hessian of f0(x)
hess_f0 = @(x) [exp(x(1) + 3*x(2) - 0.1) + exp(-x(1) - 0.1), 3*exp(x(1) + 3*x(2) - 0.1);
                3*exp(x(1) + 3*x(2) - 0.1), 9*exp(x(1) + 3*x(2) - 0.1)] + 2*P;


% Initialize iteration variables
x = x0;
x_es = {x0};

% Newton's method iteration
x = x0; % Starting point

% Parameters for backtracking line search
alpha = 0.5;  % Typically a small number between 0.01 and 0.3
beta = 0.5;   % Typically a number between 0.1 and 0.8

% Newton's method with backtracking line search
i = 2;
N = 0;
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
    while f0_1(x + s*v) > f0_1(x) + alpha*s*g'*v
        s = beta * s;         % Reduce step size
        
    end
    x = x + s*v;              % Update the point x
    x_es{i} = x;
    N = N + 1;
    i = i + 1;
    if N > 5
        break
    end
end

x_newton = x; % Optimal point found by the algorithm

x1_range = linspace(-3.5, 2.5, 100);
x2_range = linspace(-2.2, 2.2, 100);


% Create a grid of x1 and x2
[X1, X2] = meshgrid(x1_range, x2_range);

% Use arrayfun to apply f0 over the grid
Z = arrayfun(@(x1, x2) f0(x1, x2), X1, X2);

% Create the contour plot
% contour(X1, X2, Z, ,'-k');
contour(X1, X2, Z, [2.47, 3.62, 5.34, 7.59, 19.2, 50, 200, 600], 'LineColor', 'k', 'ShowText','on');
xlabel('x_1');
ylabel('x_2');

% Plot the iterative points on the contour plot
hold on;
plot(x_es{1}(1), x_es{1}(2), 'blacko', 'MarkerFaceColor', 'black'); % Blue 'o' for the iterative points
for i = 2:length(x_es)
    plot(x_es{i}(1), x_es{i}(2), 'ro', 'MarkerFaceColor', 'r'); 
end
hold off;

x_optimal = fminsearch(f0_1, x0);

cvx_begin
    variable x_cvx(2)
    minimize(f0_1(x_cvx))
cvx_end

disp('X [Newton]: ');
disp(x_newton);
disp('X [CVX]: ');
disp(x_cvx);
disp('X [fminsearch]: ');
disp(x_optimal);