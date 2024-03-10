%%
load("isoPerimData.mat")
whos
% disp(C)
h = a / N;
% plot(y_fixed)
%%
cvx_begin
    variable y(N)

    total_norm = 0; % initialize the expression
    for i = 1:N-1
        total_norm = total_norm + norm( [h ;(y(i+1) - y(i))] );
    end
    % Objective function
    maximize( h * sum(y) )
    
    % Constraints
    subject to
        % Constraint 16b
        total_norm <= L;

        % Constraint 16c
        for i = 1:N-2 % Adjusted loop bounds
            abs((y(i+2) - 2*y(i+1) + y(i)) / h^2) <= C;
        end

        % Constraint 16d
        y(1) == 0;

        % Constraint 16e
        y(N) == 0;

        % Constraint 16f
        % Assuming y_fixed is a vector and F is a set of indices into y
        for j = F
            y(j) == y_fixed(j);
        end
cvx_end
%%
N = length(y);

% Define the interval [0, 1]
x_values = linspace(0, 1, N);

% Plotting y(n)
figure;
plot(x_values, y, 'b.-', 'LineWidth', 1.5);
xlabel('n');
ylabel('y(n)');
title('Optimized Variable y(n)');
grid on;
