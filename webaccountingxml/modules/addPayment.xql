xquery version "3.1";

let $path := "/db/apps/webaccountingxml/data/payments.xml"
let $date := request:get-parameter('date','')
let $amount := request:get-parameter('amount','')

let $doc := doc($path)
return update insert 
    <payment>
        <date>{$date}</date>
        <amount>{$amount}</amount>
    </payment> into $doc/payments