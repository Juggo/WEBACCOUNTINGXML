xquery version "3.1";
declare option exist:serialize "method=xhtml media-type=text/xml indent=yes process-xsl-pi=no";

let $path := request:get-parameter('path', '')
let $filename := request:get-parameter('filename','')
let $append := request:get-parameter('append', '')
let $parameters := request:get-parameter('parameters','')
let $contents := request:get-parameter('contents','')

let $login := xmldb:login("/db", 'admin', 'projectadmin')
let $source-doc := doc(concat($path,$filename))
let $old-cont := concat(concat("<",concat(node-name($source-doc/*[1]),">")),concat(concat($source-doc,"</"),concat(node-name($source-doc/*[1]),">")))
let $new-cont := concat($old-cont,$contents)
let $rem := xmldb:remove($path, $filename)
let $store := xmldb:store($path,$filename,$new-cont)

return <p>Success</p> and response:redirect-to(xs:anyURI("http://localhost:8080/exist/apps/webaccountingxml/updateFile.html"))