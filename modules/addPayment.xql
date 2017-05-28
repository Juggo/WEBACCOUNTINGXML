xquery version "3.1";

let $path := "/db/apps/webaccountingxml/data/payments.xml"
let $date := request:get-parameter('date','')
let $amount := request:get-parameter('amount','')

let $login := xmldb:login("/db", 'admin', '')
let $doc := doc($path)
return
    if(fn:matches($date,"\d{4}-\d{2}-\d{2}")) then
        update insert
        <payment>
        <date>{$date}</date>
        <amount>{$amount}</amount>
        </payment> into $doc/payments
        (: ToDo: Sem taky nějak nacpat přesměrování na index.html :) 
    else
    response:redirect-to(xs:anyURI("http://localhost:8080/exist/apps/webaccountingxml/index.html"))