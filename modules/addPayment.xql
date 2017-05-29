xquery version "3.1";

let $date := request:get-parameter('date','')
let $amount := request:get-parameter('amount','')

let $login := xmldb:login("/db", 'admin', '')

return
    if(fn:matches($date,"\d{4}-\d{2}-\d{2}")) then
        (update insert
            <payment>
                <date>{$date}</date>
                <amount>{$amount}</amount>
            </payment> into doc("/db/apps/WEBACCOUNTINGXML/data/payments.xml")/payments,
        update insert
            <div class="alert alert-success">
                <a href="./modules/deleteNotification.xql" class="close">Zrušit</a>
                Platba (Částka v Kč: {$amount}, Datum: {$date}) byla úspěšně uložena.
            </div> into doc("/db/apps/WEBACCOUNTINGXML/index.html")//div[@class="notification"],
        response:redirect-to(xs:anyURI("http://localhost:8080/exist/apps/WEBACCOUNTINGXML/index.html")))
    else
        update insert
            <div class="alert alert-danger">
                <a href="./modules/deleteNotification.xql" class="close">Zrušit</a>
                Platba nebyla uložena. Zadejte prosím platné parametry.
            </div> into doc("/db/apps/WEBACCOUNTINGXML/index.html")//div[@class="notification"],
        response:redirect-to(xs:anyURI("http://localhost:8080/exist/apps/WEBACCOUNTINGXML/index.html"))
