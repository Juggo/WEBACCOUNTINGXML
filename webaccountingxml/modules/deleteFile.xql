xquery version "3.1";
declare option exist:serialize "method=xhtml media-type=text/xml indent=yes process-xsl-pi=no";

let $path := request:get-parameter('path', '')
let $filename := request:get-parameter('filename','')

let $login := xmldb:login("/db", 'admin', 'projectadmin')
let $store := if ($filename and $path) then xmldb:remove($path, $filename) else null
    
return <p>Success</p> and response:redirect-to(xs:anyURI("http://localhost:8080/exist/apps/webaccountingxml/deleteFile.html")) 