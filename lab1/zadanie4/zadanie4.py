import numpy as np
import cvxpy as cp
import csv
import matplotlib.pyplot as plt
import os

# plt.rc('text', usetex=True)


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

    # Macierz c zawiera 0 i tyle jedynek aby dalo sie jej transpozycje mnozyc przez z
    c = np.hstack(([0], np.ones(len(x) + 1)))

    b = np.hstack((y, y * -1))
    fi = stworz_fi(x)

    # Rozmiar macierzy I nalezy dostosowac tak aby dalo sie mnozyc macierz A przez z
    I = np.eye(N = len(x), M = len(x))

    # Definicja macierzy A
    A_row1 = np.hstack((fi, I * -1))
    A_row2 = np.hstack((fi * -1, I * -1))
    A = np.vstack((A_row1, A_row2))

    # Definicja zmiennej z (macierz jednokolumnowa [a, b, ... tau_N])
    z = cp.Variable(len(x) + 2)

    # Definicja funkcji i ograniczen
    objective = cp.Minimize(c.T @ z)
    constraints = [ A @ z <= b]

    # Minimalizacja funkcji
    problem = cp.Problem(objective, constraints)
    problem.solve(solver=cp.ECOS)

    # Pierwsze dwa elementy rozwiazania z sa wspolczynnikami a i b
    return z.value[0], z.value[1]


# TODO
def wykres_rozwiazan(a_ls, b_ls, a_lp, b_lp):
    x_values, y_values = wczytaj_dane()
    x = np.linspace(0, 10, 100)

    y_ls = a_ls * x + b_ls
    y_lp = a_lp * x + b_lp

    plt.plot(x_values, y_values, 'rs', label='(x_i,y_i), i=1,...,N', markersize=3)
    plt.plot(x, y_ls, label='y = ax + b (LS)', color='black')
    plt.plot(x, y_lp, label='y = ax + b (LP)', color='blue')

    plt.xlim(0, 10)
    plt.ylim(2, 10)
    plt.yticks(range(2, 10 + 1, 2))
    plt.ylabel('y', fontsize=17)
    plt.xlabel('x', fontsize=17)
    plt.tick_params(direction='in', which='both')
    plt.grid(True)
    plt.legend(loc='upper left')
    plt.show()


if __name__ == "__main__":
    # wykres_danych()

    a_ls, b_ls = rozwiazanie_LS()
    print('[LS] a: {} b: {}'.format(a_ls, b_ls))

    a_lp, b_lp = rozwiazanie_LP()
    print('[LP] a: {} b: {}'.format(a_lp, b_lp))

    wykres_rozwiazan(a_ls, b_ls, a_lp, b_lp)

