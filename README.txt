PhotoArrow v1.0-beta - Strzałki dla kierunku zdjęć
Data publikacji: 29 sierpnia 2016

Nowe funkcje

Użycie
#Uruchomienie aplikacji
mdl load PhotoArrow
PhotoArrow start
#Ustawianie parametrów zdjęć w katalogu
PhotoArrow photo subdir DOKUMENTACJA_FOTOGRAFICZNA
PhotoArrow photo ext *.jpg
#Ustawianie parametrów kierunków strzałek w pliku referencyjnym
PhotoArrow ref startLevel 61
PhotoArrow ref endLevel 60
#Ustawianie parametrów strzałek w pliku głównym
PhotoArrow arrow scale 80
PhotoArrow arrow height 2
PhotoArrow arrow width 2
PhotoArrow arrow font 1
PhotoArrow arrow color 1
PhotoArrow arrow level 7
PhotoArrow arrow minLength 1

** Zmiany (historia)
Do zrobienia
* podręcznik użytkownika
* dwujęzyczna kompilacja (polski i angielski)
* zmiana warstw (7 i 47)
* raport z brakujących zdjęć do pliku
* autoread config file
* reread config file command

2016-08-22 v1.0-beta
* pierwsza wersja programu
* wyszukiwanie numerów zdjęć
* wczytywanie numerów strzałek
* wstawianie strzałek
* wstawianie numeru strzałki pod odpowiednim kątem
* odwracanie numeru strzałki dla kątów od 90 do 270
* wstawianie strzałek tylko z danego katalogu (DOKUMENTACJA_FOTOGRAFICZNA)
