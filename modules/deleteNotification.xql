xquery version "3.1";

(:~ 
 : This module serves for deleting notifications.
 : 
 : All notifications (succesful and unsuccessful) are deleted from index.html and 
 : user is redirected to the homepage (to refresh the page).
 : 
 : @author Juggo
 : @version 1.0 
 :)

let $login := xmldb:login("/db", 'admin', '')

return
    update delete doc("/db/apps/webaccountingxml/index.html")//div[@class="notification"]/child::*,
    response:redirect-to(xs:anyURI("http://localhost:8080/exist/apps/webaccountingxml/index.html"))