xquery version "3.1";

let $login := xmldb:login("/db", 'admin', '')
                    
return 
    update delete doc("/db/apps/webaccountingxml/templates/balance.html")//p[@class="value"], 
    
    update insert <p class="value">Aktuální hodnota:
        { 
            fn:sum(
                    let $closingDateString := doc("/db/apps/webaccountingxml/data/closingdate.xml")/closingdates/closingdate/text()
                    let $closingDate := xs:date($closingDateString)
                    let $balanceDate := xs:date(request:get-parameter('balanceDate',''))
                    
                for $payment in doc("/db/apps/webaccountingxml/data/payments.xml")/payments/payment
                where xs:date($payment/date) > $closingDate and xs:date($payment/date) < $balanceDate
                return xs:integer($payment/amount)
            )
    }</p> into doc("/db/apps/webaccountingxml/templates/balance.html")/html/body/div/div,
    update delete doc("/db/apps/webaccountingxml/data/closingdate.xml")/closingdates/closingdate,
    update insert <closingdate>{request:get-parameter('balanceDate','')}</closingdate> into doc("/db/apps/webaccountingxml/data/closingdate.xml")/closingdates,
    response:redirect-to(xs:anyURI("http://localhost:8080/exist/apps/webaccountingxml/templates/balance.html"))
    
    
    	
