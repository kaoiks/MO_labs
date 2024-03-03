import numpy as np
import cvxpy as cp
import csv
import matplotlib.pyplot as plt
import os

def wczytaj_dane():
    # Pobranie danych z pliku
    directory = os.path.dirname(__file__)
    file_path = os.path.join(directory, 'data01.csv')
    data = csv.reader(open(file_path, 'r'), delimiter=',')

    # Skopiowanie danych do dwoch tablic
    x_values = []
    y_values = []
    for row in data:
        x_values.append(float(row[0]))
        y_values.append(float(row[1]))

    # Zwrocenie dwoch tablic zawierajacych kolejnosci wartosci x i y
    return x_values, y_values

def wykres_danych():
    # Wczytanie danych z pliku
    x_values, y_values = wczytaj_dane()

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

def stworz_fi(x):
    # Kolumna zawierajaca jedynki
    ones = np.ones(len(x))
    # Zlaczenie kolumn zawierajacych x i jedynki w macierz
    fi = np.column_stack((x, ones))
    return fi

def rozwiazanie_LS():
    x, y = wczytaj_dane()
    fi = stworz_fi(x)
    # pseodoodwrotność Moore’a-Penrose’a
    teta = np.linalg.pinv(fi) @ y
    return teta[0], teta[1]

def rozwiazanie_LP():
    x, y = wczytaj_dane()

    # Konwertuj dane w postaci listy do macierzy
    x = np.array(x)
    y = np.array(y)

    # Stworz wymagane macierze
    c = np.array([0, 1, 1, 1])
    b = np.hstack((y, y * -1))
    fi = stworz_fi(x)
    I = np.eye(N = len(x), M = 2)

    A_row1 = np.hstack((fi, I * -1))
    A_row2 = np.hstack((fi * -1, I * -1))
    A = np.vstack((A_row1, A_row2))

    # Definicja funkcji i minimalizacja
    z = cp.Variable((4, 1))
    print(b.shape)

    objective = cp.Minimize(c.T @ z)
    # Problem z mnozeniem macierzy, zle rozmiary macierzy
    constraints = [ A @ z <= b]

    problem = cp.Problem(objective, constraints)
    problem.solve()

    return z.value, z.value

# To do
def wykres_rozwiazan():
    pass

if __name__ == "__main__":
    # wykres_danych()

    a_ls, b_ls = rozwiazanie_LS()
    print('[LS] a: {} b: {}'.format(a_ls, b_ls))

    a_lp, b_lp = rozwiazanie_LP()
    print('[LP] a: {} b: {}'.format(a_lp, b_lp))

