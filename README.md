PhotoArrow v1.3-beta, 19 września 2016
---
Generowanie strzałek dla kierunków zdjęć

# Pomoc

1. Sprawdź aktualizacje w [katalogu zdalnym](z:/Profile/damian/Microstation/PhotoArrow/)
2. Zainstaluj program w [katalogu mdlapps]($MSDIR/mdlapps)
3. Konfiguruj program w [pliku config](PhotoArrow.config)
4. Uruchom program za pomocą wpisania keyin: `mdl load PhotoArrow`
5. Podłącz strzałki referencyjnie i wybierz ogrodzenie
6. Wygeneruj strzałki za pomocą wpisania keyin:  
    PhotoArrow start

# Historia

Do zrobienia:

- [ ] podręcznik użytkownika
- [x] domyślny styl 0
- [x] domyślna grubość 1
- [x] popraw rozpoznawanie nazwy zdjęcia

2016-09-19 v1.3-beta

* popraw rozpoznawanie nazwy zdjęcia: `[a-z0-9]*-[a-z0-9]*`
* nowe polecenie do ustawiania domyślnego stylu: `PhotoArrow arrow style 0`
* nowe polecenie do ustawiania domyślnej grubości: `PhotoArrow arrow weight 1`

2016-08-31 v1.2-beta

* nowe polecenie do ustawiania maksymalnej długości strzałki (photoarrow arrow maxLength)

2016-08-30 v1.1-beta

* wybór obszaru ogrodzenia przez użytkownika
* zmiana domyślnych warstw kierunku zdjęć na 7 i 47
* nowe polecenie do ustawiania warstwy punktu początkowego (photoarrow ref startLevel)
* nowe polecenie do ustawiania warstwy punktu końcowego (photoarrow ref endLevel)
* nowe polecenie do odczytywania konfiguracji z pliku PhotoArrow.config (automatycznie wykonywane podczas startu)
* nowe polecenie do ustawiania podkatalogu zdjęć (photoarrow photo subdir)
* nowe polecenie do ustawiania typu zdjęć (photoarrow photo ext)
* nowe polecenie do ustawiania warstwy strzałki (photoarrow arrow level)
* nowe polecenie do ustawiania czcionki numeru strzałki (photo arrow font)
* nowe polecenie do ustawiania koloru strzałki (photo arrow color)
* nowe polecenie do ustawiania rozmiaru numeru strzałki (photo arrow textSize)
* wykrywanie brakujących strzałek
* wykrywanie brakujących plików zdjęć
* wykrywanie duplikatów strzałek

2016-08-22 v1.0-beta

* pierwsza wersja programu
* wyszukiwanie numerów zdjęć
* wczytywanie numerów strzałek
* wstawianie strzałek
* wstawianie numeru strzałki pod odpowiednim kątem
* odwracanie numeru strzałki dla kątów od 90 do 270
* wstawianie strzałek tylko z danego katalogu (DOKUMENTACJA_FOTOGRAFICZNA)
