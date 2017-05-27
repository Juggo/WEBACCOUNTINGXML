xquery version "3.1";


let $login := xmldb:login("/db", 'admin', '')


return 
    update delete doc("/db/apps/WEBACCOUNTINGXML/templates/balance.html")//p[@class="value"], 
    update insert <p class="value">Aktuální hodnota: 
        { 
            fn:sum(
                for $payment in doc("/db/apps/WEBACCOUNTINGXML/data/payments.xml")/payments/payment
                return xs:integer($payment/amount)
            )
    }</p> into doc("/db/apps/WEBACCOUNTINGXML/templates/balance.html")/html/body/div/div,
    response:redirect-to(xs:anyURI("http://localhost:8080/exist/apps/WEBACCOUNTINGXML/templates/balance.html"))