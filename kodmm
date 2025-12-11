#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

struct Obraz {
    char P2[3];
    int szerokosc;
    int wysokosc;
    int szarosc;
    int** piksele;
    char nazwa[100];
};

void pomin_komentarze(FILE* plik) {
    int znak;
    while ((znak = fgetc(plik)) != EOF) {
        if (znak == '#') {
            while ((znak = fgetc(plik)) != EOF && znak != '\n');
        }
        else if (znak == ' ' || znak == '\n' || znak == '\t' || znak == '\r') {
            continue;
        }
        else {
            ungetc(znak, plik);
            break;
        }
    }
}

void zwolnij_piksele(struct Obraz* obraz) {
    if (obraz->piksele != NULL) {
        for (int i = 0; i < obraz->wysokosc; i++) {
            free(obraz->piksele[i]);
        }
        free(obraz->piksele);
        obraz->piksele = NULL;
    }
}

void zwolnij_baze(struct Obraz** baza, int* rozmiar) {
    if (*baza != NULL) {
        for (int i = 0; i < *rozmiar; i++) {
            zwolnij_piksele(&(*baza)[i]);
        }
        free(*baza);
        *baza = NULL;
        *rozmiar = 0;
    }
}

int ochrona_menu() {
    int liczba;
    while (1) {
        if (scanf("%d", &liczba) == 1) return liczba;
        else {
            printf("To nie liczba, wpisz jeszcze raz: ");
            while (getchar() != '\n');
        }
    }
}

int wczytaj(char nazwa_pliku[], struct Obraz* obraz) {
    FILE* plik = fopen(nazwa_pliku, "r");
    if (plik == NULL) {
        printf("Nie udalo sie otworzyc pliku: %s\n", nazwa_pliku);
        return 0;
    }

    strcpy(obraz->nazwa, nazwa_pliku);

    pomin_komentarze(plik);
    if (fscanf(plik, "%2s", obraz->P2) != 1 || strcmp(obraz->P2, "P2") != 0) {
        printf("Bledny format pliku.\n");
        fclose(plik);
        return 0;
    }

    pomin_komentarze(plik);
    if (fscanf(plik, "%d", &obraz->szerokosc) != 1) { fclose(plik); return 0; }

    pomin_komentarze(plik);
    if (fscanf(plik, "%d", &obraz->wysokosc) != 1) { fclose(plik); return 0; }

    pomin_komentarze(plik);
    if (fscanf(plik, "%d", &obraz->szarosc) != 1) { fclose(plik); return 0; }

    obraz->piksele = malloc(obraz->wysokosc * sizeof(int*));
    for (int i = 0; i < obraz->wysokosc; i++) {
        obraz->piksele[i] = malloc(obraz->szerokosc * sizeof(int));
        for (int j = 0; j < obraz->szerokosc; j++) {
            pomin_komentarze(plik);
            fscanf(plik, "%d", &obraz->piksele[i][j]);
        }
    }
    printf("Wczytano plik %s (%dx%d)\n", nazwa_pliku, obraz->szerokosc, obraz->wysokosc);
    fclose(plik);
    return 1;
}

void zapisz(char nazwa_pliku[], struct Obraz* obraz) {
    FILE* plik = fopen(nazwa_pliku, "w");
    if (plik == NULL) {
        printf("Nie udalo sie zapisac.\n");
        return;
    }
    fprintf(plik, "%s\n%d %d\n%d\n", obraz->P2, obraz->szerokosc, obraz->wysokosc, obraz->szarosc);
    for (int i = 0; i < obraz->wysokosc; i++) {
        for (int j = 0; j < obraz->szerokosc; j++) {
            fprintf(plik, "%d ", obraz->piksele[i][j]);
        }
        fprintf(plik, "\n");
    }
    fclose(plik);
    printf("Zapisano do pliku: %s\n", nazwa_pliku);
}

void dodaj_obraz(struct Obraz** tablica, int* rozmiar) {
    char nazwa[100];
    printf("Podaj nazwe pliku: ");
    scanf("%s", nazwa);

    (*rozmiar)++;
    struct Obraz* temp = realloc(*tablica, (*rozmiar) * sizeof(struct Obraz));

    if (temp != NULL) {
        *tablica = temp;
        if (wczytaj(nazwa, &((*tablica)[*rozmiar - 1])) == 0) {
            (*rozmiar)--;
        }
    }
    else {
        printf("Blad alokacji pamieci.\n");
        (*rozmiar)--;
    }
}

void usun_obraz(struct Obraz** baza, int* rozmiar, int indeks) {
    if (indeks < 0 || indeks >= *rozmiar) {
        printf("Nieprawidlowy numer obrazu.\n");
        return;
    }

    zwolnij_piksele(&(*baza)[indeks]);

    if (indeks != *rozmiar - 1) {
        (*baza)[indeks] = (*baza)[*rozmiar - 1];
    }

    (*rozmiar)--;

    if (*rozmiar > 0) {
        struct Obraz* temp = realloc(*baza, (*rozmiar) * sizeof(struct Obraz));
        if (temp != NULL) {
            *baza = temp;
        }
    }
    else {
        free(*baza);
        *baza = NULL;
    }
    printf("Obraz usuniety.\n");
}

void wyswietl_baze(struct Obraz* baza, int rozmiar, int aktywny) {
    printf("\n--- BAZA DANYCH ---\n");
    printf("Ilosc obrazow: %d\n", rozmiar);
    if (aktywny >= 0 && aktywny < rozmiar)
        printf("Wybrany obraz: [%d] %s\n", aktywny, baza[aktywny].nazwa);
    else
        printf("Wybrany obraz: BRAK\n");

    printf("\n--- LISTA --- \n");
    if (rozmiar == 0) printf("(pusta)\n");
    for (int i = 0; i < rozmiar; i++) {
        printf("%d. %s [%dx%d]", i, baza[i].nazwa, baza[i].szerokosc, baza[i].wysokosc);
        if (i == aktywny) printf(" <--- WYBRANY");
        printf("\n");
    }
}

void obroc(struct Obraz* obraz) {
    int nowa_szer = obraz->wysokosc;
    int nowa_wys = obraz->szerokosc;
    int** temp = malloc(nowa_wys * sizeof(int*));
    for (int i = 0; i < nowa_wys; i++) temp[i] = malloc(nowa_szer * sizeof(int));

    for (int i = 0; i < obraz->wysokosc; i++) {
        for (int j = 0; j < obraz->szerokosc; j++) {
            temp[j][obraz->wysokosc - 1 - i] = obraz->piksele[i][j];
        }
    }
    zwolnij_piksele(obraz);
    obraz->piksele = temp;
    obraz->szerokosc = nowa_szer;
    obraz->wysokosc = nowa_wys;
    printf("Obraz obrocony.\n");
}

void negatyw(struct Obraz* obraz) {
    for (int i = 0; i < obraz->wysokosc; i++) {
        for (int j = 0; j < obraz->szerokosc; j++) {
            obraz->piksele[i][j] = obraz->szarosc - obraz->piksele[i][j];
        }
    }
    printf("Negatyw zrobiony.\n");
}

void filtr_gaussa(struct Obraz* obraz) {
    int** temp = malloc(obraz->wysokosc * sizeof(int*));
    for (int i = 0; i < obraz->wysokosc; i++) {
        temp[i] = malloc(obraz->szerokosc * sizeof(int));
        for (int j = 0; j < obraz->szerokosc; j++) temp[i][j] = obraz->piksele[i][j];
    }
    int maska[3][3] = { {1, 2, 1}, {2, 4, 2}, {1, 2, 1} };
    int suma_wag = 16;
    for (int i = 1; i < obraz->wysokosc - 1; i++) {
        for (int j = 1; j < obraz->szerokosc - 1; j++) {
            int suma = 0;
            for (int k = -1; k <= 1; k++) {
                for (int l = -1; l <= 1; l++) {
                    suma += temp[i + k][j + l] * maska[k + 1][l + 1];
                }
            }
            obraz->piksele[i][j] = suma / suma_wag;
        }
    }
    for (int i = 0; i < obraz->wysokosc; i++) free(temp[i]);
    free(temp);
    printf("Filtr Gaussa nalozony.\n");
}

void generuj_histogram(struct Obraz* obraz) {
    int* hist = calloc(obraz->szarosc + 1, sizeof(int));
    if (hist == NULL) return;

    for (int i = 0; i < obraz->wysokosc; i++) {
        for (int j = 0; j < obraz->szerokosc; j++) {
            int wartosc = obraz->piksele[i][j];
            if (wartosc <= obraz->szarosc) hist[wartosc]++;
        }
    }

    FILE* plik = fopen("histogram.csv", "w");
    if (plik == NULL) {
        printf("Blad zapisu histogramu.\n");
        free(hist);
        return;
    }
    fprintf(plik, "Wartosc;Liczba\n");
    for (int i = 0; i <= obraz->szarosc; i++) {
        fprintf(plik, "%d;%d\n", i, hist[i]);
    }
    fclose(plik);
    free(hist);
    printf("Histogram zapisano do pliku histogram.csv.\n");
}

void statystyki(struct Obraz* obraz) {
    int min = obraz->szarosc;
    int max = 0;
    long long suma = 0;
    long long liczba_pikseli = (long long)obraz->szerokosc * obraz->wysokosc;

    for (int i = 0; i < obraz->wysokosc; i++) {
        for (int j = 0; j < obraz->szerokosc; j++) {
            int wartosc = obraz->piksele[i][j];
            if (wartosc < min) min = wartosc;
            if (wartosc > max) max = wartosc;
            suma += wartosc;
        }
    }
    float srednia = (float)suma / liczba_pikseli;

    printf("\n--- STATYSTYKI ---\n");
    printf("Jasnosc MIN: %d\n", min);
    printf("Jasnosc MAX: %d\n", max);
    printf("Jasnosc SREDNIA: %.2f\n", srednia);
}

void odbicie_lustrzane(struct Obraz* obraz, int tryb) {
    int temp;
    if (tryb == 1) {
        for (int i = 0; i < obraz->wysokosc; i++) {
            for (int j = 0; j < obraz->szerokosc / 2; j++) {
                temp = obraz->piksele[i][j];
                obraz->piksele[i][j] = obraz->piksele[i][obraz->szerokosc - 1 - j];
                obraz->piksele[i][obraz->szerokosc - 1 - j] = temp;
            }
        }
        printf("Odbito wzgledem osi pionowej.\n");
    }
    else if (tryb == 2) {
        for (int i = 0; i < obraz->wysokosc / 2; i++) {
            int* tempRow = obraz->piksele[i];
            obraz->piksele[i] = obraz->piksele[obraz->wysokosc - 1 - i];
            obraz->piksele[obraz->wysokosc - 1 - i] = tempRow;
        }
        printf("Odbito wzgledem osi poziomej.\n");
    }
}

void szum_pieprz_sol(struct Obraz* obraz, int szansa) {
    for (int i = 0; i < obraz->wysokosc; i++) {
        for (int j = 0; j < obraz->szerokosc; j++) {
            if ((rand() % 100) < szansa) {
                obraz->piksele[i][j] = (rand() % 2 == 0) ? 0 : obraz->szarosc;
            }
        }
    }
    printf("Dodano szum 'Pieprz i Sol' (%d%%).\n", szansa);
}

int main() {
    srand(time(NULL));

    struct Obraz* baza = NULL;
    int rozmiar_bazy = 0;
    int aktywny_indeks = -1;
    int opcja = -1;
    char nazwa[100];

    while (opcja != 0) {
        printf("\n MENU \n");
        printf("1. Dodaj obraz\n");
        printf("2. Pokaz liste\n");
        printf("3. Wybierz obraz\n");
        printf("4. Zapisz plik\n");
        printf("5. Usun obraz\n");
        printf("--- Przetwarzanie ---\n");
        printf("6. Obrot 90\n");
        printf("7. Negatyw\n");
        printf("8. Gauss\n");
        printf("9. Histogram (CSV)\n");
        printf("10. Statystyki\n");
        printf("11. Odbicie lustrzane\n");
        printf("12. Szum Pieprz i Sol\n");
        printf("0. Koniec\n");
        printf("Twoj wybor: ");

        opcja = ochrona_menu();

        switch (opcja) {
        case 1:
            dodaj_obraz(&baza, &rozmiar_bazy);
            if (rozmiar_bazy == 1) aktywny_indeks = 0;
            break;
        case 2:
            wyswietl_baze(baza, rozmiar_bazy, aktywny_indeks);
            break;
        case 3:
            if (rozmiar_bazy > 0) {
                wyswietl_baze(baza, rozmiar_bazy, aktywny_indeks);
                printf("Numer obrazu: ");
                int wybor = ochrona_menu();
                if (wybor >= 0 && wybor < rozmiar_bazy) {
                    aktywny_indeks = wybor;
                    printf("Wybrales: %s\n", baza[aktywny_indeks].nazwa);
                }
                else printf("Zly numer.\n");
            }
            else printf("Baza jest pusta.\n");
            break;
        case 4:
            if (aktywny_indeks != -1) {
                printf("Podaj nazwe zapisu: ");
                scanf("%s", nazwa);
                zapisz(nazwa, &baza[aktywny_indeks]);
            }
            else printf("Najpierw wybierz obraz.\n");
            break;
        case 5:
            if (rozmiar_bazy > 0) {
                wyswietl_baze(baza, rozmiar_bazy, aktywny_indeks);
                printf("Podaj numer obrazu do usuniecia: ");
                int do_usuniecia = ochrona_menu();

                if (do_usuniecia == aktywny_indeks) aktywny_indeks = -1;
                if (aktywny_indeks == rozmiar_bazy - 1 && do_usuniecia != rozmiar_bazy - 1) {
                    aktywny_indeks = do_usuniecia;
                }

                usun_obraz(&baza, &rozmiar_bazy, do_usuniecia);
            }
            else printf("Baza jest pusta.\n");
            break;
        case 6:
            if (aktywny_indeks != -1) obroc(&baza[aktywny_indeks]);
            else printf("Najpierw wybierz obraz.\n");
            break;
        case 7:
            if (aktywny_indeks != -1) negatyw(&baza[aktywny_indeks]);
            else printf("Najpierw wybierz obraz.\n");
            break;
        case 8:
            if (aktywny_indeks != -1) filtr_gaussa(&baza[aktywny_indeks]);
            else printf("Najpierw wybierz obraz.\n");
            break;
        case 9:
            if (aktywny_indeks != -1) generuj_histogram(&baza[aktywny_indeks]);
            else printf("Najpierw wybierz obraz.\n");
            break;
        case 10:
            if (aktywny_indeks != -1) statystyki(&baza[aktywny_indeks]);
            else printf("Najpierw wybierz obraz.\n");
            break;
        case 11:
            if (aktywny_indeks != -1) {
                printf("Os: 1.Pionowa 2.Pozioma: ");
                int os = ochrona_menu();
                if (os == 1 || os == 2) odbicie_lustrzane(&baza[aktywny_indeks], os);
            }
            else printf("Najpierw wybierz obraz.\n");
            break;
        case 12:
            if (aktywny_indeks != -1) {
                printf("Moc szumu (0-100): ");
                int pr = ochrona_menu();
                if (pr >= 0 && pr <= 100) szum_pieprz_sol(&baza[aktywny_indeks], pr);
            }
            else printf("Najpierw wybierz obraz.\n");
            break;
        case 0:
            zwolnij_baze(&baza, &rozmiar_bazy);
            printf("Koniec programu.\n");
            break;
        default:
            printf("Nie ma takiej opcji.\n");
        }
    }
    return 0;
}
