(: Creates a checking list grouped by OKM publication class :)

declare option output:method "csv";
declare option output:csv "header=yes, separator=semicolon";


declare variable $organisation external:="PSHP";
declare variable $path external:="/Users/ccmala/Documents/2021/pure-dataload/";

declare variable $params:=map {
    'method': 'csv',
    'csv': map { 'header': 'yes', 'separator': ';' }
  };

let $csv:=
<csv>{
for $record in /Julkaisut/Julkaisu
  let $okm_class:=data($record/JulkaisutyyppiKoodi)
  let $uuid:=data($record/JulkaisunOrgTunnus)
  order by $okm_class

return 
<record>
<okm_class>{data($okm_class)}</okm_class>
<uuid>{data($uuid)}</uuid>
</record>

}</csv>


return file:write($path || lower-case($organisation) || "-" || "pubs-in-uuid.csv",$csv,$params)