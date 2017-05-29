xquery version "3.1";

let $login := xmldb:login("/db", 'admin', '')

return
    update delete doc("/db/apps/WEBACCOUNTINGXML/index.html")//div[@class="notification"]/child::*,
    response:redirect-to(xs:anyURI("http://localhost:8080/exist/apps/WEBACCOUNTINGXML/index.html"))
