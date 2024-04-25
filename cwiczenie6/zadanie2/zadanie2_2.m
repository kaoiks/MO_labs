grad_f0 = @(x, t, P, xc) t * [exp(x(1) + 3*x(2) - 0.1) - exp(-x(1) - 0.1); 3*exp(x(1) + 3*x(2) - 0.1)] ...
                     + (2 * P * (x - xc)) / (1 - transpose(x - xc) * P * (x - xc));

f0_hessian = @(x, t, P, xc) t * [exp(x(1) + 3*x(2) - 0.1), 3*exp(x(1) + 3*x(2) - 0.1); ...
                                  3*exp(x(1) + 3*x(2) - 0.1), 9*exp(x(1) + 3*x(2) - 0.1)] ...
                     + (4 * P * (x - xc) * (x - xc).' * P) ...
                     / (1 - (x - xc).' * P * (x - xc))^2 ...
                     - (2 * P) ...
                     / (1 - (x - xc).' * P * (x - xc));