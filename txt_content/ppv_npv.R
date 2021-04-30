explain_ppv_npv <-
    '<p>When a COVID Antigen test (Rapid test) shows you a positive or negative result, this does not
    mean automatically mean that the patient has a CORONA or not.
    Tests can be wrong in the way that they either show a positive result
    for a healthy patient (False Positive) or a negative result
    for a person who actually has a disease (False Negative). How likely is a
    test to actually show a true result? </p><br>
    <p>Let us define a few terms: <br>
    <ul>
        <li>Prevalence: The probability of having the disease in a given population</li>
        <li>Sensitivity: The probability that an individual who has COVID also has a positive test</li>
        <li>Specifity: The probability That a healthy individual has a negative test</li>
        <li>Positive Predictive Value (PPV): The probability that an individual with a positive test result has COVID</li>
        <li>Negative Predictive Value (NPV): The probability that an individual with a negative test result has COVID</li>
    </ul>
    <br>
    <p>For interpreting a positive or negative COVID-19 test result, the last two terms are crucial to understand. </p>

    '

#   https://math.meta.stackexchange.com/questions/5020/mathjax-basic-tutorial-and-quick-reference/15077#15077
ppv_formula <- withMathJax("$$PPV = \\frac{True Positives}{True Positives + False Positives}$$")
npv_formula <- withMathJax("$$NPV = \\frac{True Negatives}{True Negatives + False Negatives}$$")