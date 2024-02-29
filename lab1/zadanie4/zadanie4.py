import numpy as np
import cvxpy as cp
import csv
import matplotlib.pyplot as plt
import os

# Funkcja rysujaca wykres widoczny w instrukcji jako rysunek 2.
def wykres_danych():
    # Pobranie danych
    directory = os.path.dirname(__file__)
    file_path = os.path.join(directory, 'data01.csv')
    data = csv.reader(open(file_path, 'r'), delimiter=',')

    # Przygotowanie danych do narysowania wykresu
    x_values = []
    y_values = []
    for row in data:
        x_values.append(float(row[0]))
        y_values.append(float(row[1]))

    # Rysyowanie wykresu
    plt.scatter(x_values, y_values, color='r')
    plt.xlim(0, 10)
    plt.ylim(-50, 150)
    plt.grid(True)
    plt.yticks(range(-50, 150 + 1, 50))
    plt.xlabel('x_i, i=1,...,N', fontsize=17)
    plt.ylabel('y_i, i=1,...,N', fontsize=17)
    plt.title('Wykres danych', fontsize=20)
    plt.show()

# Funkcja rysujaca wykres widoczny w instrukcji jako rysunek 3.
def rozwiazanie():
    n = 100
    x = cp.Variable(n)
    y = cp.Variable()
    a = cp.Variable()
    b = cp.Variable()
    tau = cp.Variable()

    teta = np.array([a, b])
    bb = np.array([y -y])
    c = np.array([0, 1])
    z = np.vstack((teta, tau))

    fi = np.full((n, 2), [x, 1])

    A = np.array([[fi, -np.eye(n)], [-fi, -np.eye(n)]])

    # LB = np.array([-1.0, -0.5])
    # UB = np.array([1.5, 1.25])
    # AA = np.vstack((A,np.eye(n),-np.eye(n)))
    # bb = np.hstack((b,UB,-LB))
    objective = cp.Minimize(c.T @ z)
    constraints = [ A @ z <= bb ]
    problem = cp.Problem(objective, constraints)
    problem.solve()
    print("\n")
    print("--------------")
    print(x.value)
    print("--------------")


if  __name__ == "__main__":
    wykres_danych()
    rozwiazanie()

