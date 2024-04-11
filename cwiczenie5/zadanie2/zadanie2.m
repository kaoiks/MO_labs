% Definicje funkcji
% phi_rys3 = @(s) 40*s.^3 + 20*s.^2 - 44*s + 29;
phi_rys3 = @(s) 20*s.^2 -44*s + 29;
dphi_rys3 = @(s) 40*s - 44; % Pochodna funkcji phi
 
% Parametry początkowe
s = 1;
alpha = 0.3; % Zmieniony parametr alpha
beta = 1;
 
% Pętla backtracking search
% while phi_rys3(s) >= phi_rys3(0) + alpha*dphi_rys3(0)*s
 
steps = [s];
i = 2;
 
while phi_rys3(s) >= 29 - alpha * 44 * s
    s = beta*s;
    steps(i) = s;
    i = i + 1;
 
end
 
% Wygenerowanie wykresu
s_values = linspace(0, 2.5, 100);
plot(s_values, phi_rys3(s_values), 'black', 'LineWidth', 2); hold on;
 
plot(s_values, phi_rys3(0) + dphi_rys3(0)*s_values, 'b', 'LineWidth', 1);
plot(s_values, phi_rys3(0) + alpha*dphi_rys3(0)*s_values, 'b', 'LineWidth', 1);
plot(s_values, phi_rys3(0) + 0*dphi_rys3(0)*s_values, 'b', 'LineWidth', 1);
plot(s_values, phi_rys3(0) + 0.1*dphi_rys3(0)*s_values, 'b', 'LineWidth', 1);
plot(s_values, phi_rys3(0) + 0.2*dphi_rys3(0)*s_values, 'b', 'LineWidth', 1);
plot(s_values, phi_rys3(0) + 0.4*dphi_rys3(0)*s_values, 'b', 'LineWidth', 1);
plot(s_values, phi_rys3(0) + 0.5*dphi_rys3(0)*s_values, 'b', 'LineWidth', 1);
 
points_red = [];
 
for i = 1:length(steps)
    points_red(i) = phi_rys3(steps(i));
end
 
points_black = [];
 
for i = 1:length(steps)
    points_black(i) = 0.3*dphi_rys3(i);
end
 
plot(steps, points_red, 'rs', 'MarkerSize', 10, 'LineWidth', 2);
plot(steps, points_black, 'BlackSquare', 'MarkerSize', 10, 'LineWidth', 2);
 
legend('\phi(s) = 20s^2 -44s + 29',"y(s) = \phi(0) + \alpha\phi'(0)s", 'Location', 'NorthEast');
title('Metoda backtracking search dla \phi(s) = 20s^2 - 44s + 29');
xlabel('s');
ylabel('\phi(s)');
ylim([-30 50])
xlim([0 2.5])
grid on;
hold off;