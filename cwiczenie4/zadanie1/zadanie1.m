%% Wyznaczenie położenia źródła 
y = [1.8, 2.5;
     2.0, 1.7;
     1.5, 1.5;
     1.5, 2.0;
     2.5, 1.5];

d = [2.00; 1.24; 0.59; 1.31; 1.44];


cvx_begin sdp
    variable x(2) 
    variable t(1)
    minimize(sum_square(t - 2*y*x + sum(y.^2, 2) - d.^2))
    subject to
        [t, x'; x, eye(2)] == semidefinite(3)
cvx_end

disp(['The optimal x is: ', mat2str(x)]);
%%
x1 = linspace(0, 3, 100);
x2 = linspace(0, 3, 100);
[X1, X2] = meshgrid(x1, x2);
F0 = zeros(size(X1));
for k = 1:length(d)
    F0 = F0 + ((X1 - y(k, 1)).^2 + (X2 - y(k, 2)).^2 - d(k)^2).^2;
end

contour(X1, X2, F0, 35);
hold on;

plot(y(:,1), y(:,2), 'r.', 'MarkerSize', 20);
plot(x(1), x(2), 'black*', 'MarkerSize', 7, 'LineWidth', 1);
xlabel('x_1');
ylabel('x_2');
title('Localization of sensors and source signal');
grid on;

% Set grid spacing
set(gca, 'XTick', 0:0.5:3);
set(gca, 'YTick', 0:0.5:3);

% Optionally set aspect ratio to be equal
axis equal;

% Turn off the hold
hold off;
