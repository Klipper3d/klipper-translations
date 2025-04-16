# Poziomowanie stołu

Poziomowanie stołu jest kluczowe w otrzymywaniu dobrej jakości wydruków. Jeżeli stół jest nieprawidłowo "wypoziomowany" prowadzi to do słabej adhezji filamentu, podwijania krawędzi obiektów i drobnych problemów przez cały wydruk .Ten dokument pokazuje jak wykonać poziomowanie stołu w systemie Klipper.

Bardzo ważne jest zrozumienie celu poziomowania stołu. Jeśli drukarka otrzyma komendę `X0 Y0 Z10` podczas wydruku , wtedy celem dla drukarki jest utrzymanie dyszy dokładnie 10mm nad stołem. Dając kolejną komendę `X50 Z10` celem jest utrzymanie stałej wysokości 10mm między stołem a głowicą podczas wykonywania ruchu.

W celu uzyskania dobrej jakości wydruków drukarka powinna być skalibrowana tak, aby odległości Z były dokładne z dokładnością do około 25 mikronów (.025mm). Jest to niewielka odległość - znacznie mniejsza niż szerokość typowego ludzkiego włosa. Skala ta nie może być mierzona "na oko". Subtelne efekty (takie jak rozszerzalność cieplna) wpływają na pomiary w tej skali. Sekretem uzyskania wysokiej dokładności jest zastosowanie powtarzalnego procesu oraz metody poziomowania, która wykorzystuje wysoką dokładność własnego systemu ruchu drukarki.

## Wybierz odpowiedni mechanizm kalibracji

Różne typy drukarek stosują różne metody poziomowania stołu. Wszystkie ostatecznie zależą od „testu papierowego” (opisanego poniżej). Jednak faktyczny proces dla określonego typu drukarki jest opisany w innych dokumentach.

Przed uruchomieniem któregokolwiek z tych narzędzi kalibracyjnych, należy wykonać kontrole opisane w [dokumencie sprawdzania konfiguracji](Config_checks.md). Przed wykonaniem poziomowania stołu konieczne jest sprawdzenie podstawowych ruchów drukarki.

W przypadku drukarek z "automatyczną sondą Z" należy skalibrować sondę zgodnie z instrukcjami w dokumencie [Probe Calibrate](Probe_Calibrate.md). W przypadku drukarek delta należy zapoznać się z dokumentem [Delta Calibrate](Delta_Calibrate.md). W przypadku drukarek ze śrubami stołu i tradycyjnymi krańcówkami Z należy zapoznać się z dokumentem [Manual Level](Manual_Level.md).

Podczas kalibracji może być konieczne ustawienie `position_min` osi Z drukarki na liczbę ujemną (np. `position_min = -2`). Drukarka wymusza sprawdzanie granic nawet podczas procedur kalibracji. Ustawienie liczby ujemnej pozwala drukarce na opuszczenie się poniżej nominalnej pozycji stołu, co może być pomocne podczas próby określenia rzeczywistej pozycji stołu.

## "Test papieru"

Podstawowym mechanizmem kalibracji łoża jest "test papieru". Polega on na umieszczeniu kartki papieru między stołem drukarki a dyszą, a następnie na ustawieniu dyszy na różnych wysokościach, aż poczuje się niewielki opór podczas przesuwania papieru tam i z powrotem.

Ważne jest zrozumienie "testu papieru", nawet jeśli ktoś ma "automatyczną sondę osi Z". Sama sonda często musi zostać skalibrowana, aby uzyskać dobre wyniki. Kalibracja sondy odbywa się za pomocą tego właśnie "testu papieru".

Aby wykonać test papieru, wytnij nożyczkami mały prostokątny kawałek papieru (np. 5x3 cm). Papier ma zazwyczaj grubość około 100 mikronów (0,100 mm). (Dokładna grubość papieru nie jest kluczowa.)

Pierwszym krokiem testu papieru jest inspekcja dyszy i stołu drukarki. Upewnij się, że na dyszy lub stole nie ma plastiku (ani innych zanieczyszczeń).

**Sprawdź dyszę i stół, aby upewnić się, że nie ma tam plastiku!**

Jeśli ktoś zawsze drukuje na konkretnej taśmie lub powierzchni do drukowania, może wykonać test papieru z tą taśmą/powierzchnią na miejscu. Należy jednak pamiętać, że sama taśma ma grubość, a różne taśmy (lub jakakolwiek inna powierzchnia do drukowania) będą miały wpływ na pomiary Z. Należy ponownie wykonać test papieru, aby zmierzyć każdy rodzaj używanej powierzchni.

Jeśli na dyszy znajduje się plastik, podgrzej głowicę i usuń plastik metalową pęsetą. Poczekaj, aż głowica całkowicie ostygnie do temperatury pokojowej, zanim przejdziesz do testu papieru. Podczas chłodzenia dyszy usuń plastik, który mógł wycieknąć, metalową pęsetą.

**Zawsze wykonuj test papieru, gdy dysza i stół mają temperaturę pokojową!**

Gdy dysza jest podgrzewana, jej położenie (względem stołu) zmienia się z powodu rozszerzalności cieplnej. Ta rozszerzalność cieplna wynosi zazwyczaj około 100 mikronów, co odpowiada grubości typowego kawałka papieru do drukarki. Dokładna wartość rozszerzalności cieplnej nie jest kluczowa, tak jak dokładna grubość papieru nie jest kluczowa. Zacznij od założenia, że te dwie wartości są równe (patrz poniżej, aby poznać metodę określania różnicy między tymi dwiema odległościami).

Może wydawać się dziwne kalibrowanie odległości w temperaturze pokojowej, gdy celem jest uzyskanie stałej odległości po podgrzaniu. Jednak jeśli kalibruje się, gdy dysza jest podgrzana, ma ona tendencję do wyciekania niewielkich ilości stopionego plastiku na papier, co zmienia ilość odczuwanego tarcia. Utrudnia to uzyskanie dobrej kalibracji. Kalibrowanie, gdy stół/dysza są gorące, również znacznie zwiększa ryzyko poparzenia. Ilość rozszerzalności cieplnej jest jednolita, więc można ją łatwo uwzględnić później w procesie kalibracji.

**Użyj zautomatyzowanego narzędzia do określenia dokładnych wysokości Z!**

Klipper ma kilka skryptów pomocniczych (np. MANUAL_PROBE, Z_ENDSTOP_CALIBRATE, PROBE_CALIBRATE, DELTA_CALIBRATE). Zobacz dokumenty [opisane powyżej](#choose-the-appropriate-calibration-mechanism), aby wybrać jeden z nich.

Uruchom odpowiednie polecenie w oknie terminala OctoPrint. Skrypt poprosi o interakcję użytkownika w wyjściu terminala OctoPrint. Będzie wyglądać mniej więcej tak:

```
Recv: // Starting manual Z probe. Use TESTZ to adjust position.
Recv: // Finish with ACCEPT or ABORT command.
Recv: // Z position: ?????? --> 5.000 <-- ??????
```

Aktualna wysokość dyszy (tak jak drukarka ją obecnie rozumie) jest wyświetlana pomiędzy "--> <--". Liczba po prawej stronie to wysokość ostatniej próby pomiaru, nieznacznie większa od bieżącej wysokości, a po lewej stronie to ostatnia próba pomiaru mniejsza od bieżącej wysokości (lub ?????? jeśli nie podjęto żadnej próby).

Umieść papier między dyszą a stołem. Może być przydatne zgięcie rogu kartki, aby łatwiej ją było chwycić. (Staraj się nie naciskać na łóżko, przesuwając papier tam i z powrotem.)

![paper-test](img/paper-test.jpg)

Użyj polecenia TESTZ, aby zażądać zbliżenie się dyszy bliżej do papieru. Na przykład:

```
TESTZ Z=-.1
```

Polecenie TESTZ przesunie dyszę o względną odległość od bieżącej pozycji dyszy. (Tak więc `Z=-.1` żąda, aby dysza przesunęła się bliżej do stołu o .1 mm.) Po zatrzymaniu się dyszy, przesuwaj papier tam i z powrotem, aby sprawdzić, czy dysza styka się z papierem i aby poczuć tarcie. Kontynuuj wydawanie poleceń TESTZ, aż poczujesz niewielkie tarcie podczas testowania z papierem.

Jeśli tarcie jest zbyt duże, można użyć dodatniej wartości Z, aby przesunąć dyszę w górę. Można również użyć `TESTZ Z=+` lub `TESTZ Z=-`, aby "przeciąć" ostatnią pozycję - to znaczy przesunąć się do pozycji w połowie drogi między dwiema pozycjami. Na przykład, jeśli ktoś otrzymał następujący monit od polecenia TESTZ:

```
Recv: // Z position: 0.130 --> 0.230 <-- 0.280
```

Wtedy `TESTZ Z=-` przesunęłoby dyszę do pozycji Z wynoszącej 0,180 (w połowie drogi między 0,130 a 0,230). Można użyć tej funkcji, aby szybko zawęzić do spójnego tarcia. Można również użyć `Z=++` i `Z=--`, aby powrócić bezpośrednio do poprzedniego pomiaru - na przykład po powyższym monicie polecenie `TESTZ Z=--` przesunęłoby dyszę do pozycji Z wynoszącej 0,130.

Po znalezieniu niewielkiego tarcia uruchom polecenie ACCEPT:

```
ACCEPT
```

Spowoduje to zaakceptowanie podanej wysokości Z i przejście do podanego narzędzia kalibracyjnego.

Dokładna ilość odczuwanego tarcia nie jest kluczowa, tak samo jak ilość rozszerzalności cieplnej i dokładna szerokość papieru nie są kluczowe. Po prostu staraj się uzyskać taką samą ilość tarcia za każdym razem, gdy przeprowadzasz test.

Jeżeli w trakcie testu coś pójdzie nie tak, można użyć polecenia `ABORT`, aby opuścić narzędzie kalibracji.

## Określanie rozszerzalności cieplnej

Po pomyślnym przeprowadzeniu poziomowania stołu można przystąpić do obliczenia dokładniejszej wartości łącznego wpływu "rozszerzalności cieplnej", "grubości papieru" i "ilości tarcia odczuwalnego podczas testu papieru".

Ten typ obliczeń nie jest zazwyczaj potrzebny, gdyż większość użytkowników uważa, że prosty "test papieru" daje dobre wyniki.

Najprostszym sposobem wykonania tego obliczenia jest wydrukowanie obiektu testowego, który ma proste ściany ze wszystkich stron. Można do tego celu użyć dużego pustego kwadratu znalezionego w [docs/prints/square.stl](prints/square.stl). Podczas slicowania obiektu upewnij się, że slicer używa tej samej wysokości warstwy i szerokości linii dla pierwszej warstwy, co dla wszystkich kolejnych warstw. Użyj grubej wysokości warstwy (wysokość warstwy powinna wynosić około 75% średnicy dyszy) i nie używaj brimu ani raftu.

Wydrukuj obiekt testowy, poczekaj, aż ostygnie, i zdejmij go ze stołu. Sprawdź najniższą warstwę obiektu. (Może być również przydatne przesunięcie palcem lub paznokciem wzdłuż dolnej krawędzi.) Jeśli zauważysz, że dolna warstwa lekko wybrzusza się wzdłuż wszystkich boków obiektu, oznacza to, że dysza była nieco za blisko stołu. Możesz wydać polecenie `SET_GCODE_OFFSET Z=+.010`, aby zwiększyć wysokość. W kolejnych wydrukach możesz sprawdzić to zachowanie i dokonać dalszych korekt w razie potrzeby. Korekty tego typu są zazwyczaj w dziesiątkach mikronów (.010 mm).

Jeśli dolna warstwa stale wydaje się grubsza niż kolejne warstwy, można użyć polecenia SET_GCODE_OFFSET, aby dokonać ujemnej korekty Z. Jeśli nie jest się pewnym, można zmniejszyć wartość korekty Z, aż dolna warstwa wydruków wykaże niewielkie wybrzuszenie, a następnie cofnąć się, aż zniknie.

Najprostszym sposobem zastosowania pożądanej korekty Z jest utworzenie makra g-code START_PRINT, skonfigurowanie wywołania tego makra przez slicer podczas rozpoczęcia każdego wydruku i dodanie polecenia SET_GCODE_OFFSET do tego makra. Więcej szczegółów można znaleźć w dokumencie [slicers](Slicers.md).
