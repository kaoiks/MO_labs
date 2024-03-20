%%

% Wczytanie danych
load("Data01.mat")

N = length(y);
D = zeros(N-1, N);
for i=1:(N-1)
    D(i, i) = -1;
    D(i, i+1) = 1;
end
tau=1.6;
size(D)
%%
cvx_begin
    variable v(N)
    
    minimize(norm(y - v, 2) + norm(v(2:end)-v(1:end-1), 1) * tau)
cvx_end
%%

save("zad1_wynik.mat", 'v');

N = length(y);
x_values = linspace(0, 1, N);
figure;
scatter(t, y, "square", "filled", 'MarkerFaceColor', [0.5 0.5 0.5], 'MarkerEdgeColor', [0.5 0.5 0.5], 'LineWidth', 0.1);
hold on;
plot(t, v, 'LineWidth',2, "Color", "red");
hold off;
xlabel('x/a');
ylabel('y(x)');
title('Optimized Variable y(x)');
grid on;
