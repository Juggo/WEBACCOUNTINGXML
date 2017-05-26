xquery version "3.1";

let $path := request:get-parameter('path', '')
let $filename := request:get-parameter('filename','')
let $contents := request:get-parameter('contents','')

return
    if($path and $filename and $contents) then
        xmldb:login("/db", 'admin', 'projectadmin') and
        xmldb:store($path,$filename,$contents) and
        <message>Success</message> and
        response:redirect-to(xs:anyURI("http://localhost:8080/exist/apps/webaccountingxml/createFile.html"))
    else <p>Error</p>