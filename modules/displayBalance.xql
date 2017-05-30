xquery version "3.1";

(:~ 
 : This module serves for displaying balance of payments from closing date till specific date.
 : Input = date
 : 
 : If input parameter is succesfully validated, current balance will be refreshed on balance.html 
 : summing amounts of payments with dates between the closing date and the chosen date (input parameter). 
 : If not, user will be informed about wrong format of parameters.
 : 
 : @author Kroomy
 : @version 1.0 
 :)

let $dateString := request:get-parameter('balanceDate','')

let $login := xmldb:login("/db", 'admin', '')

return
    (: input validation :)
    if(fn:matches($dateString,"^(19|20)\d\d-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])$")) then
        (: rewritting balance of payments :)
        (update delete doc("/db/apps/webaccountingxml/templates/balance.html")//p[@class="value"], 
        update insert <p class="value">Aktuální hodnota:
            { 
                fn:sum(
                    let $closingDateString := doc("/db/apps/webaccountingxml/data/closingdate.xml")/closingdates/closingdate/text()
                    let $closingDate := xs:date($closingDateString)
                    let $balanceDate := xs:date($dateString)
                    
                    for $payment in doc("/db/apps/webaccountingxml/data/payments.xml")/payments/payment
                    where xs:date($payment/date) > $closingDate and xs:date($payment/date) < $balanceDate
                    return xs:integer($payment/amount)
                )
        }</p> into doc("/db/apps/webaccountingxml/templates/balance.html")/html/body/div/div,
        response:redirect-to(xs:anyURI("http://localhost:8080/exist/apps/webaccountingxml/templates/balance.html")))
    else
        (: creation of an unsuccessful notification :)
        update insert
            <div class="alert alert-danger">
                <a href="./modules/deleteNotification.xql" class="close">Zrušit</a>
                Neplatné datum - špatně zadaný formát.
            </div> into doc("/db/apps/webaccountingxml/index.html")//div[@class="notification"],
        response:redirect-to(xs:anyURI("http://localhost:8080/exist/apps/webaccountingxml/index.html"))