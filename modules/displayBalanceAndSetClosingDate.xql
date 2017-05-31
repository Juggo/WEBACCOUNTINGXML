xquery version "3.1";

(:~ 
 : This module serves for displaying balance and ending and beginning a new accounting year.
 : Input = date
 : 
 : If input parameter is succesfully validated and entered closing date is newer than the one already set, 
 : current balance will be refreshed on balance.html summing amounts of payments with dates between the old 
 : closing date and the new closing date (input parameter) and the new closing date will be set on the homepage 
 : and rewritten into XML file closingdate.xml.
 : If closing date is older than the one already set, user will be informed about the invalid date.
 : If input parameter is not succesfully validated, user will be informed about wrong format of parameters.
 : 
 : @author Kroomy
 : @version 1.0 
 :)

let $dateString := request:get-parameter('balanceDate','')
let $closingDateString := doc("/db/apps/webaccountingxml/data/closingdate.xml")/closingdates/closingdate/text()
let $closingDate := xs:date($closingDateString)
                    
let $login := xmldb:login("/db", 'admin', '')
                    
return
    (: input validation of correct format :)
    if(fn:matches($dateString,"^(19|20)\d\d-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])$")) then
    (
        let $newClosingDate := xs:date(request:get-parameter('balanceDate',''))
        return
        (: input validation of whether new closing date is not older than the closing date already set :)
        if($newClosingDate > $closingDate) then
            (: rewritting balance of payments :)
            (update delete doc("/db/apps/webaccountingxml/templates/balance.html")//p[@class="balanceType"], 
        update delete doc("/db/apps/webaccountingxml/templates/balance.html")//p[@class="totalIncome"],
        update delete doc("/db/apps/webaccountingxml/templates/balance.html")//p[@class="totalExpenses"],
        update delete doc("/db/apps/webaccountingxml/templates/balance.html")//p[@class="totalAmount"],
        update delete doc("/db/apps/webaccountingxml/index.html")//p[@class="closingDate"], 
        
        update insert <p class="balanceType">Typ bilance: Uzavření období </p> into doc("/db/apps/webaccountingxml/templates/balance.html")/html/body/div/div,
        update insert <p class="totalIncome">Celkové příjmy:
        { 
            fn:sum(
                    
                for $payment in doc("/db/apps/webaccountingxml/data/payments.xml")/payments/payment
                where xs:date($payment/date) > $closingDate and xs:date($payment/date) < $newClosingDate and $payment/amount/number() > 0
                return xs:integer($payment/amount)
            )
    }</p> into doc("/db/apps/webaccountingxml/templates/balance.html")/html/body/div/div,
    update insert <p class="totalExpenses">Celkové výdaje:
        { 
            fn:sum(
                    
                for $payment in doc("/db/apps/webaccountingxml/data/payments.xml")/payments/payment
                where xs:date($payment/date) > $closingDate and xs:date($payment/date) < $newClosingDate and $payment/amount/number() < 0
                return xs:integer($payment/amount)
            )
    }</p> into doc("/db/apps/webaccountingxml/templates/balance.html")/html/body/div/div,
    update insert <p class="totalAmount">Celková suma:
        { 
            fn:sum(
                    
                for $payment in doc("/db/apps/webaccountingxml/data/payments.xml")/payments/payment
                where xs:date($payment/date) > $closingDate and xs:date($payment/date) < $newClosingDate
                return xs:integer($payment/amount)
            )
    }</p> into doc("/db/apps/webaccountingxml/templates/balance.html")/html/body/div/div,
    update delete doc("/db/apps/webaccountingxml/data/closingdate.xml")/closingdates/closingdate,
    (: updating closing date :)
    update insert <closingdate>{$dateString}</closingdate> into doc("/db/apps/webaccountingxml/data/closingdate.xml")/closingdates,
    update insert <p class="closingDate">{$dateString}</p> into doc("/db/apps/webaccountingxml/index.html")//div[@class="closingDate"],
    response:redirect-to(xs:anyURI("http://localhost:8080/exist/apps/webaccountingxml/templates/balance.html"))
            )
        else
            (: creation of an unsuccessful notification concerning a closing date older than the one already set :)
            (update insert
                <div class="alert alert-danger">
                    <a href="./modules/deleteNotification.xql" class="close">Zrušit</a>
                    Datum uzavření musí být novější než to stávající.
                </div> into doc("/db/apps/webaccountingxml/index.html")//div[@class="notification"],
            response:redirect-to(xs:anyURI("http://localhost:8080/exist/apps/webaccountingxml/index.html"))
            )
    )
    else
        (: creation of an unsuccessful notification concerning a wrong format of an input parameter :)
        update insert
            <div class="alert alert-danger">
                <a href="./modules/deleteNotification.xql" class="close">Zrušit</a>
                Neplatné datum - špatně zadaný formát.
            </div> into doc("/db/apps/webaccountingxml/index.html")//div[@class="notification"],
        response:redirect-to(xs:anyURI("http://localhost:8080/exist/apps/webaccountingxml/index.html"))