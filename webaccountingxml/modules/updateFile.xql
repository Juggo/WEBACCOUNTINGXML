xquery version "3.1";

let $path := request:get-parameter('path', '')
let $append := request:get-parameter('append', '')
let $parameters := request:get-parameter('parameters','')
let $contents := request:get-parameter('contents','')

let $source-doc := if ($path) then doc($path) else return

return
    if ($contents) then
    xmldb:login("/db", 'admin', 'projectadmin') and
    file:serialize(fn:parse-xml($contents), $source-doc,$parameters, xs:boolean($append)) and
    response:redirect-to(xs:anyURI("http://localhost:8080/exist/apps/webaccountingxml/updateFile.html"))
    else <p>Error</p>