load("Data01.mat")

N = length(y);
M = N;

D = zeros(M, N);
for i=1:(N-1)
    D(i, i) = -1;
    D(i, i+1) = 1;
end

zeros_n = zeros(N, 1);
ones_n = ones(N, 1);
zeros_m = zeros(M, 1);
ones_m = ones(M, 1);

c = vertcat(zeros_n, ones_n, zeros_m);
b = vertcat(y, y * -1, q, zeros_m, zeros_m);

zeros_n_m = zeros(N, M);
zeros_m_n = zeros(M, N);

zeros_1_n = zeros(1, N);

I_n = eye(N);
I_m = eye(M);

A_row1 = horzcat(I_n, I_n * -1, zeros_n_m);
A_row2 = horzcat(I_n * -1, I_n * -1, zeros_n_m);
A_row3 = horzcat(zeros_1_n, zeros_1_n, ones_m.');
A_row4 = horzcat(D * -1, zeros_m_n, I_m * -1);
A_row5 = horzcat(D, zeros_m_n, I_m * -1);

A = vertcat(A_row1, A_row2, A_row3, A_row4, A_row5);

xOpt = linprog(c, A, b);
load("zad1_wynik.mat");

x_values = linspace(0, 1, N);
figure;
scatter(t, y, "square", "filled", 'MarkerFaceColor', [0.5 0.5 0.5], 'MarkerEdgeColor', [0.5 0.5 0.5], 'LineWidth', 0.1);
hold on;
plot(t, xOpt(1:N), 'LineWidth',2, "Color", "blue");
plot(t, v, 'LineWidth',2, "Color", "red");
hold off;
xlabel('x/a');
ylabel('y(x)');
title('Optimized Variable y(x)');
grid on;
