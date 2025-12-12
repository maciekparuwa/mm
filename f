void dodaj_znak_wodny(struct Obraz* obraz) {
    int n, startX, startY;
    
    printf("Podaj n (np. 2 -> kwadrat 3x3, 3 -> kwadrat 5x5): ");
    n = ochrona_menu();

    if (n < 2) {
        printf("n musi byc >= 2, aby byl widoczny efekt.\n");
        return;
    }

    int bok = 2 * n - 1;
    int srodek = n - 1; // indeks srodka wewnatrz kwadratu

    printf("Rozmiar znaku to %dx%d.\n", bok, bok);
    printf("Podaj wspolrzedna X lewego gornego rogu (0 - %d): ", obraz->szerokosc - bok);
    startX = ochrona_menu();
    printf("Podaj wspolrzedna Y lewego gornego rogu (0 - %d): ", obraz->wysokosc - bok);
    startY = ochrona_menu();

    // Obliczamy krok przyciemniania
    // Srodek ma byc bialy (max), brzeg ma byc ciemny.
    // Ilosc warstw to (n-1).
    int krok = 0;
    if (n > 1) {
        krok = obraz->szarosc / (n - 1);
    }

    for (int i = 0; i < bok; i++) {
        for (int j = 0; j < bok; j++) {
            // Wspolrzedne na duzym obrazie
            int imgY = startY + i;
            int imgX = startX + j;

            // Sprawdzenie czy nie wychodzimy poza obraz
            if (imgX >= 0 && imgX < obraz->szerokosc && imgY >= 0 && imgY < obraz->wysokosc) {
                
                // Dystans od srodka znaku (metryka Czebyszewa - 'kwadratowe' warstwy)
                int distY = abs(i - srodek);
                int distX = abs(j - srodek);
                int dystans = (distX > distY) ? distX : distY;

                // Oblicz jasnosc: srodek bialy, im dalej tym ciemniej
                int nowa_wartosc = obraz->szarosc - (dystans * krok);
                if (nowa_wartosc < 0) nowa_wartosc = 0;

                obraz->piksele[imgY][imgX] = nowa_wartosc;
            }
        }
    }
    printf("Znak wodny o wymiarze n=%d dodany na pozycje (%d, %d).\n", n, startX, startY);
}
