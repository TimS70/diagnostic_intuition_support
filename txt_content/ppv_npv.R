sensitivity_gap <- '
    <div style=" border: 10px solid black;">
    Beachten Sie: Antigen-Schnelltests weisen eine Sensitivit\u00e4tsl\u00fccke bei
    asymptomatischen Personen und pr\u00e4symptomatischen Personen
    mit einer SARS-CoV-2 Infektion auf. Dies bedeutet, dass
    diese Tests Personen mit einer Infektion aber ohne Symptome
    nur sehr schlecht identifizieren k\u00f6nnen. Somit besteht das
    erh\u00f6hte Risiko eines falsch-negativen Testergebnisses.
    </div>
    <br>
'

explain_ppv_npv <-
    '<p>Wenn ein COVID-19 Antigen Test (Schnelltest) ein positives oder negatives Ergebnis zeigt,
     bedeutet dies nicht automatisch, dass sich der Person mit SARS-CoV-2 infiziert hat oder gesund ist.
     Tests k\u00f6nnen insofern falsch liegen, dass sie entweder ein positives Ergebnis f\u00fcr einen gesunden
     Personen zeigen (Falsch Positiv) oder ein negatives Ergebnis f\u00fcr eine infizierte Person (Falsch Negativ).
     Wie wahrscheinlich ist es, dass ein Test ein wahres positives Ergebnis oder wahres negatives Ergebnis zeigt? </p><br>
    <p>Lassen Sie uns zu einige wichtige Begriffe unterscheiden: <br>
    <ul>
        <li><b>Pr\u00e4valenz:</b> Die Wahrscheinlichkeit, mit der eine Erkrankung in einer bestimmten Bev\u00f6lkerungsgruppe auftritt.
            Je nach definierter Personengruppe, also ob die gesamte Bev\u00f6lkerung oder eine bestimmte Risikogruppe (z.B. Pendler*innen)
            gemeint ist, kann das Infektionsrisiko variieren.
        </li>
        <li><b>Sensitivit\u00e4t:</b> Die Wahrscheinlichkeit, mit der eine mit SARS-CoV-2 infizierte Person ein positives Testergebnis hat. </li>
        <li><b>Spezifit\u00e4t:</b> Die Wahrscheinlichkeit, mit der eine gesunde Person ein negatives Testergebnis hat. </li>
        <li><b>Positiver Pr\u00e4diktiver Wert (PPW):</b> Die Wahrscheinlichkeit, mit der eine Person mit einem <u>positiven</u> Testergebnis sich
            tats\u00e4chlich mit SARS-CoV-2 infiziert hat.</li>
        <li><b>Negativer Pr\u00e4diktiver Wert (NPW):</b> Die Wahrscheinlichkeit, mit der eine Person mit einem <u>negativen</u> Testergebnis
            tats\u00e4chlich gesund ist.</li>
    </ul>
    <p>Zur Interpretation eines positiven oder negativen Testergebnisses spielen die letzten beiden Begriffe eine gro\u00dfe Rolle. </p>

    <p><b>Beachten Sie zudem, dass Pr\u00e4valenz und Inzidenz nicht gleichzusetzen sind.</b> W\u00e4rend die Inzidenz die neu 
    dazugekommenen Infektionen beschreibt, geht es bei der Pr\u00e4valenz darum, wie viele Personen 
    infiziert sind, egal wann sie sich infiziert haben. Die Pr\u00e4valenz wird aus einer Faustformel 
    mithilfe der aktuellen Inzidenz und einem angenommenen Anteil der aufgedeckten F\u00e4lle von
    ca. 56% (ca. 44% Anteil der Dunkelziffer) gesch\u00e4tzt (siehe Formel unten). </p>
    <br>
    <h3>Formeln</h3>
    '

#   https://math.meta.stackexchange.com/questions/5020/mathjax-basic-tutorial-and-quick-reference/15077#15077
ppv_formula <- withMathJax("$$PPW = \\frac{Wahr Positive}{Wahr Positive + Falsch Positive}$$")
npv_formula <- withMathJax("$$NPW = \\frac{Wahr Negative}{Wahr Negative + Falsch Negative}$$")
prevalence_estimation_formula <- withMathJax("$$Pr\u00e4valenz Sch\u00e4tzung = \\frac{2 * Inzidenz}{Anteil Aufgedeckt}$$")

plot_legend <- '
    <p>
    <h3>Beispielhafter H\u00e4ufigkeitsbaum:</h3>
    True Pos. = Wahr Positive <br>
    False Pos. = Falsch Positive <br>
    True Neg. = Wahr Negative <br>
    False Neg. = Falsch Negative
    </p>
'