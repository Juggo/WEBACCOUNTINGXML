xquery version "3.1";

let $path := request:get-parameter('path', '')
let $filename := request:get-parameter('filename','')

return
    if ($filename and $path) then 
        xmldb:remove($path, $filename) and
        response:redirect-to(xs:anyURI("http://localhost:8080/exist/apps/webaccountingxml/deleteFile.html"))
    else <message>Error</message>