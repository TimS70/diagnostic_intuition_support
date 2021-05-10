explain_ppv_npv <-
    '<p>Wenn ein COVID-19 Antigen Test (Schnelltest) ein positives oder negatives Ergebnis zeigt,
     bedeutet dies nicht automatisch, dass sich der Person mit COVID-19 infiziert hat oder gesund ist.
     Tests k\u00f6nnen insofern falsch liegen, dass sie entweder ein positives Ergebnis f\u00fcr einen gesunden
     Personen zeigen (Falsch Positiv) oder ein negatives Ergebnis f\u00fcr eine infizierte Person (Falsch Negativ).
     Wie wahrscheinlich ist es, dass ein Test ein wahres positives Ergebnis oder wahres negatives Ergebnis zeigt? </p><br>
    <p>Lassen Sie uns zu einige wichtige Begriffe unterscheiden: <br>
    <ul>
        <li><b>Pr\u00e4valenz bzw. Infektionsrisiko:</b> Die Wahrscheinlichkeit, mit der eine Erkrankung in einer bestimmten Bev\u00f6lkerungsgruppe auftritt.
            Je nach definierter Personengruppe, also ob die gesamte Bev\u00f6lkerung oder eine bestimmte Risikogruppe (z.B. Pendler*innen)
            gemeint ist, kann das Infektionsrisiko variieren. </li>
        <li><b>Sensitivit\u00e4t:</b> Die Wahrscheinlichkeit, mit der eine mit COVID-19 infizierte Person ein positives Testergebnis hat. </li>
        <li><b>Spezifit\u00e4t:</b> Die Wahrscheinlichkeit, mit der eine gesunde Person ein negatives Testergebnis hat. </li>
        <li><b>Positiver Pr\u00e4diktiver Wert (PPW):</b> Die Wahrscheinlichkeit, mit der eine Person mit einem <u>positiven</u> Testergebnis auch
            tats\u00e4chlich COVID-19 hat.</li>
        <li><b>Negativer Pr\u00e4diktiver Wert (NPW):</b> Die Wahrscheinlichkeit, mit der eine Person mit einem <u>negativen</u> Testergebnis auch
            tats\u00e4chlich gesund ist.</li>
    </ul>
    <br>
    <p>Zur Interpretation eines positiven oder negativen Testergebnisses spielen die letzten beiden Begriffe eine gro\u00dfe Rolle. </p>
    '

#   https://math.meta.stackexchange.com/questions/5020/mathjax-basic-tutorial-and-quick-reference/15077#15077
ppv_formula <- withMathJax("$$PPW = \\frac{Wahr Positive}{Wahr Positive + Falsch Positive}$$")
npv_formula <- withMathJax("$$NPW = \\frac{Wahr Negative}{Wahr Negative + Falsch Negative}$$")

plot_legend <- '
    <p>
    <h3>Beispielhafter H\u00e4ufigkeitenbaum:</h3>
    True Pos. = Wahr Positive <br>
    False Pos. = Falsch Positive <br>
    True Neg. = Wahr Negative <br>
    False Neg. = Falsch Negative
    </p>
'