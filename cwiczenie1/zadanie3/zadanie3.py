import numpy as np
import cvxpy as cp


s1 = cp.Variable()
s2 = cp.Variable()
s3 = cp.Variable()
l1 = cp.Variable()
l2 = cp.Variable()

objective = cp.Minimize(100 * s1 + 199.90 * s2 + 700 * l1 + 800 * l2 - 6500 * l1 - 7100 * l2)
constraints = [
    0.01 * s1 + 0.02 * s2 - 0.5 * l1 - 0.6 * l2 >= 0,
    s1 + s2 <= 1000,
    90 * l1 + 100 * l2 <= 2000,
    40 * l1 + 50 * l2 <= 800,
    100 * s1 + 199.90 * s2 + 700 * l1 + 800 * l2 <= 100000,
    s1 >= 0,
    s2 >= 0,
    l1 >= 0,
    l2 >= 0,
]
p1 = cp.Problem(objective, constraints)
p1.solve()
print("--------------")
print(round(float(s1.value), 3))
print(round(float(s2.value), 3))
print(round(float(l1.value), 3))
print(round(float(l2.value), 3))
print("--------------")

