tol = 1e-4;
x0 = [2; -2];
epsilon = tol;  % Use epsilon as in the provided algorithm

% Define the given constants and initial guess
P = (1/8) * [7, sqrt(3); sqrt(3), 5];
xc = [1; 1];

% Define the function f0
% f0 = @(x) exp(x(1) + 3*x(2) - 0.1) + exp(-x(1) - 0.1) + (x - xc)' * P * (x - xc);
f0 = @(x1, x2, xc, P) exp(x1 + 3*x2 - 0.1) + exp(-x1 - 0.1) + ([x1; x2] - xc)' * P * ([x1; x2] - xc);
% Gradient of f0(x)
grad_f0 = @(x) [exp(x(1) + 3*x(2) - 0.1) - exp(x(1) - x(2) - 0.1);
                3*exp(x(1) + 3*x(2) - 0.1) - exp(x(1) - x(2) - 0.1)] + 2*P*(x - xc);

% Hessian of f0(x)
hess_f0 = @(x) [exp(x(1) + 3*x(2) - 0.1) + exp(x(1) - x(2) - 0.1), 3*exp(x(1) + 3*x(2) - 0.1) - exp(x(1) - x(2) - 0.1);
                3*exp(x(1) + 3*x(2) - 0.1) - exp(x(1) - x(2) - 0.1), 9*exp(x(1) + 3*x(2) - 0.1) + exp(x(1) - x(2) - 0.1)] + 2*P;

% Initialize iteration variables
iter_count = 0;
x = x0;
g = grad_f0(x);
v = -inv(hess_f0(x)) * g;
Delta = -g' * v;

x_es = {};
% Newton's method iteration
% while true
% 
%     % Update iteration variables
%     g = grad_f0(x);
%     v = -inv(hess_f0(x)) * g;
%     Delta = -g' * v;
%     if Delta < epsilon
%         break
%     else
%         x = x + v;
%         x_es{iter_count + 1} = x;
%     end
%     iter_count = iter_count + 1;
% end

for i=1:5
   x = x - inv(hess_f0(x)) * grad_f0(x)
   x_es{i} = x;
end

x1_range = linspace(-3.5, 2.5, 100);
x2_range = linspace(-2.5, 2.5, 100);

% Create a grid of x1 and x2
x1_range = linspace(-3.5, 2.5, 100);
x2_range = linspace(-2.5, 2.5, 100);

% Create a grid of x1 and x2
[X1, X2] = meshgrid(x1_range, x2_range);

% Use arrayfun to apply f0 over the grid
Z = arrayfun(@(x1, x2) f0(x1, x2, xc, P), X1, X2);

% Create the contour plot
% contour(X1, X2, Z, ,'-k');
contour(X1, X2, Z, [2.47, 3.62, 5.34, 7.59, 19.2, 50, 200, 600], 'ShowText','on')
% Optionally, add the center point to the plot
hold on;
plot(xc(1), xc(2), 'ro'); % Red 'o' for the center point
hold off;

