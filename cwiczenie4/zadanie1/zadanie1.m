gamma = 1;

cvx_begin
    variable v(N)
    
    minimize(power(, 2) + gamma * norm(x))
cvx_end