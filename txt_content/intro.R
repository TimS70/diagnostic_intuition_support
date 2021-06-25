source(file.path('utils', 'incidence.R'))
data_region <- region_incidence_data()
incidence <- data_region %>%
    filter(region == "Deutschland") %>%
    dplyr::pull(incidence) %>%
    round()

prevalence <- estimate_prevalence(incidence=incidence,
                                  fraction_cases = 0.33)


intro_txt_1 <- "<h4>Willkommen</h4>
    <p>Verwenden Sie dieses Tool zum ersten Mal?</p>
    <p><b>Lesen Sie bitte die Schritte des folgenden Tutorials!</b></p>"

intro_txt_2 <- "
    <p>
        <b>Willkommen zum Diagnostik-Tool 'Diagnostic Intuition Support'
        (DIS) von Simply Rational</b>. 
    </p>
    <p>
        Dieses Tool wurde f\u00fcr <b>medizinisches Personal</b> entwickelt, um bei der 
        Interpretation von SARS-CoV-2 Schnelltests zu unterst\u00fctzen. 
        Das Tool soll Ihnen bei der Einsch\u00e4tzung helfen, 
        wie wahrscheinlich es ist, dass bei einem positiven oder
        negativen Testergebnis auch wirklich eine bzw. keine SARS-CoV-2 Infektion
        vorliegt. 
    </p>
    <p>
        Dieses Tutorial wird Sie durch die korrekte Anwendung des Tools
        f\u00fchren. Fangen wir an!
    </p>
"

intro_txt_3 <- "
    <p>
        <b>W\u00e4hlen Sie zuerst den Testhersteller und dann den spezifischen
        Test aus.</b> Alle Tests haben <u>Sensitivit\u00e4t</u> und 
        <u>Spezifit\u00e4t</u> (aktuelle Herstellerangaben). Das sind 
        Ma\u00dfeinheiten, die Auskunft dar\u00fcber geben, wie
        genau der Test ist. Diese Angaben k\u00fcnnen von Test zu Test stark variieren. 
        <ul>
            <li>Die Sensitivit\u00e4t ist die Wahrscheinlichkeit, dass eine
            Person, die sich mit SARS-CoV-2 infiziert hat, von dem Test korrekt als 
            solche erkannt wird und
            ein <u>positives</u> Testergebnis erh\u00e4lt (Richtig-Positiv-Rate). </li>
            <li>Die Spezifizit\u00e4t ist die
            Wahrscheinlichkeit, dass eine gesunde Person vom Test korrekt als solche
            erkannt wird und ein <u>negatives</u> Testergebnis erh\u00e4lt 
            (Richtig-Negativ-Rate). </li>
        </ul>
    </p>
"

intro_txt_4 <- "
    <p>
        Dieses Diagramm zeigt den <b>positiven pr\u00e4diktiven Wert
        (PPW, blaue Kurve)</b> und den <b>negativen pr\u00e4diktiven Wert 
        (NPW, rote Kurve)</b>   des ausgew\u00e4hlten Tests gegeben der Verbreitung 
        der Infektion in der Bev\u00f6lkerungsgruppe 
        (Infektionsrisiko von 0.01% (10 in 100.000) bis 100% (100.000 von 100.000)).
    </p>
    <p>
        Der PPW ist die Wahrscheinlichkeit, dass die Person bei einem
        positiven Testergebnis sich <u>tats\u00e4chlich mit SARS-CoV-2 infiziert 
        hat</u>. Der NPW ist die
        Wahrscheinlichkeit, dass die Person bei einem negativen Testergebnis
        <u>tats\u00e4chlich nicht infiziert ist</u>. 
        (F\u00fcr eine genauere Erkl\u00e4rung, siehe Reiter Erkl\u00e4rung)
    </p>
"

intro_txt_5 <- "
    <p>
        Die Interpretation des Testergebnisses h\u00e4ngt stark davon ab,
        wie wahrscheinlich der Krankheitszustand war, bevor der Test durchgef\u00fchrt
        wurde. Das Problem: Dies auf der individuellen Ebene anhand bestehender,
        publizierter Evidenz zu bestimmen ist oft unm\u00f6glich.
        <b>Ihre Intuition ist gefragt</b>!
    </p>
"

# Wie viel höher/niedriger könnte das Risiko durch das Verhalten des Individuums sein?
intro_txt_6 <- "
    <p>
        <b>\u00dcberlegen Sie sich: Von 100.000 Menschen mit dem Risikoprofil der
        Person, an der Sie den Test durchf\u00fchren bzw. durchf\u00fchren m\u00f6chten,
        wie viele k\u00f6nnten sich mit SARS-CoV-2 infiziert haben?</b>
        Hat die Person sich in den letzten zwei Wochen sozial total
        isoliert und ist auch sonst keine Risiken eingegangen? Oder hatte sie 
        vielleicht Kontakt mit einer best\u00e4tigt SARS-CoV-2-positiven Person und 
        zeigt COVID-19 Symptome?
    </p>
    <p>
        Beispielsweise geht der physisch nahe Kontakt zu anderen Personen (<1 Meter) mit einem 
        ca. 10% h\u00f6heren Risiko und der Kontakt ohne Gesichtsmaske mit 
        einem ca. 14% h\u00f6heren Risiko der \u00dcbertragung von SARS-CoV-2 einher 
        (Chu et al., 2020, <i>Lancet</i>).   
    </p>
    <p>
        Es gibt bzgl. der Einsch\u00e4tzung des Infektionsrisikos
        keine 100%ig richtige oder falsche Antwort, Sie m\u00fcssen es
        einfach sch\u00e4tzen.
    </p>
"

intro_txt_7 <- paste("
    <p>
        Hilfreich ist bei dieser Einsch\u00e4tzung jedoch, das
        derzeitige Infektionsgeschehen zu betrachten. Derzeit liegt die
        <b>7-Tage-Inzidenz</b> (eine zeitlich begrenzte Sch\u00e4tzung f\u00fcr das 
        Infektionsrisiko) in Deutschland bei ca.",
        incidence, 
        "pro 100.000 Einwohner.", "
    </p>
    <p>",
        "Die Inzidenz wird mithilfe einer Faustformel (siehe Reiter Erkl\u00e4rung) 
        in eine <b>Pr\u00e4valenz</b> umgerechnet.
        Diese betr\u00e4gt ungef\u00e4hr",
        round(prevalence),
        "pro 100.000 Einwohner (siehe gestrichelte Linie).
    </p>
")

intro_txt_8 <- HTML('
    <p>
        <b>Hinweis:</b> Das lokale Infektionsgeschehen kann von dem bundesweiten
        Infektionsgeschehen jedoch stark abweichen. Das aktuelle Infektionsgeschehen
        in ihrem Landkreis k\u00f6nnen sie
        <a href="https://www.rki.de/DE/Content/InfAZ/N/Neuartiges_Coronavirus/Fallzahlen.html"
        target="_blank" rel="noopener noreferrer">hier</a>
        auf der Website des Robert-Koch-Institutes einsehen.
    </p>
')

intro_txt_9 <- "
    <p>
        Geben Sie nun Ihre Einsch\u00e4tzung der
        Krankheitswahrscheinlichkeit hier ein. Das Tool zeigt Ihnen darauf
        basierend den PPW (wie verl\u00e4sslich ein positives Testergebnis wirklich ist)
        und den NPW (wie verl\u00e4sslich ein negatives Testergebnis wirklich ist).
    </p>
"

