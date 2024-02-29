import numpy as np
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

def rozwiazanie_LS():
    x, y = wczytaj_dane()
    ones = np.ones(len(x))
    fi = np.column_stack((x, ones))
    teta = np.linalg.pinv(fi) @ y
    return teta[0], teta[1]

def rozwiazanie_LP():
    return None, None

def wykres_rozwiazan():
    pass

if __name__ == "__main__":
    # wykres_danych()

    a_ls, b_ls = rozwiazanie_LS()
    print('[LS] a: {} b: {}'.format(a_ls, b_ls))

    a_lp, b_lp = rozwiazanie_LP()
    print('[LP] a: {} b: {}'.format(a_lp, b_lp))

