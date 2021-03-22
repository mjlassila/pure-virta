(: Count number of publications by OKM publication class :)
(: Useful for cross-checking with listing created using Pure reporting tools:)

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
let $okm_class:=$record/JulkaisutyyppiKoodi
group by $okm_class

return

<record>
<okm_class>{$okm_class}</okm_class>
<count>{count($record)}</count>
</record>
}</csv>

return file:write($path || lower-case($organisation) || "-" || "pubs-in-okm-class.csv",$csv,$params)