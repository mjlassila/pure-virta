declare option output:method "csv";
declare option output:csv "header=yes, separator=semicolon";

declare variable $params:=map {
    'method': 'csv',
    'csv': map { 'header': 'yes', 'separator': ';' }
  };

declare variable $organisation external:="PSHP";
declare variable $path external:="/Users/ccmala/Documents/2021/pure-dataload/";

declare function local:check-publisher($record) {
  if($record[JulkaisutyyppiKoodi contains text {'A3', 'B2', 'C1',  'D2', 'D4', 'D5', 'D6', 'E2','C2','E3'} any and empty($record/KustantajanNimi)]) then
  <publisher_missing>true</publisher_missing>
};

declare function local:check-conference($record) {
  if($record[JulkaisutyyppiKoodi contains text {'A4','B3','D3'} any] and empty($record/KonferenssinNimi) ) then
  <conference_missing>true</conference_missing>
};

declare function local:check-popular-mag($record) {
  if($record[JulkaisutyyppiKoodi contains text {'D1'} any and empty($record/LehdenNimi)]) then
  <d1_mag_missing>true</d1_mag_missing>
};

declare function local:check-parent-pub($record) {
  if($record[JulkaisutyyppiKoodi contains text {'E1'} any and empty($record/EmojulkaisunNimi|$record/LehdenNimi)]) then
  <parent_missing>true</parent_missing>
};

declare function local:check-internal-authors($record) {
  if(count($record/Tekijat/Tekija)<1) then
  <internal_authors_missing>true</internal_authors_missing>
};

declare function local:check-authors($record) {
  if(empty($record/TekijatiedotTeksti)) then
  <authors_missing>true</authors_missing>
};

declare function local:check-title($record) {
  if(empty($record/JulkaisunNimi)) then
  <title_missing>true</title_missing>
};

declare function local:check-year($record) {
  if(empty($record/JulkaisuVuosi)) then
  <year_missing>true</year_missing>
};

declare function local:check-issn($record) {
  if($record[JulkaisutyyppiKoodi contains text {'A1','A2','B1'} any and count($record/ISSN) = 0]) then
  <issn_missing>true</issn_missing>
};

declare function local:check-isbn($record) {
  if($record[JulkaisutyyppiKoodi contains text {'C1','E2'} any and (count($record/ISBN) = 0 or $record/ISBN contains text 'ERROR' using fuzzy)]) then
  <isbn_missing>true</isbn_missing>
};

declare function local:check-isbn-issn($record) {
  if($record[JulkaisutyyppiKoodi contains text {'B2','A3','A4',"B3",'C2'} any and count($record/ISBN) = 0 and count($record/ISSN) = 0]) then
  <isbn_or_issn_missing>true</isbn_or_issn_missing>
};

declare function local:check-stat-codes($record) {
  
  let $stat_code_errors:=
    for $code in $record//TieteenalaKoodi
    where $code contains text "STAT CODE ERROR" using fuzzy
    return '1'
  return if (not(empty($stat_code_errors))) then
   <stat_code_errors>true</stat_code_errors>
};

declare function local:check-archived($record) {
  if($record/RinnakkaistallennettuKytkin != "0" and string-length($record/Rinnakkaistallennettu/RinnakkaistallennusOsoiteTeksti) < 1) then
  <oa_file_missing>true</oa_file_missing>
};



let $intermediate_csv:=<csv>{
for $record in /Julkaisut/Julkaisu
return 

<record>
<uuid>{data($record/JulkaisunOrgTunnus)}</uuid>
<okm_class>{data($record/JulkaisutyyppiKoodi)}</okm_class>
<publisher_missing>{data(local:check-publisher($record))}</publisher_missing>
<conference_missing>{data(local:check-conference($record))}</conference_missing>
<d1_mag_missing>{data(local:check-popular-mag($record))}</d1_mag_missing>
<parent_pub_missing>{data(local:check-parent-pub($record))}</parent_pub_missing>
<internal_authors_missing>{data(local:check-internal-authors($record))}</internal_authors_missing>
<authors_missing>{data(local:check-authors($record))}</authors_missing>
<title_missing>{data(local:check-title($record))}</title_missing>
<year_missing>{data(local:check-year($record))}</year_missing>
<issn_missing>{data(local:check-issn($record))}</issn_missing>
<isbn_missing>{data(local:check-isbn($record))}</isbn_missing>
<isbn_or_issn_missing>{data(local:check-isbn-issn($record))}</isbn_or_issn_missing>
<stat_code_errors>{data(local:check-stat-codes($record))}</stat_code_errors>
<oa_file_missing>{data(local:check-archived($record))}</oa_file_missing>
</record>

}</csv>


let $csv:=<csv>{
  for $record in $intermediate_csv/record
    let $errors:= 
      for $value in $record/(publisher_missing | conference_missing | d1_mag_missing | parent_pub_missing | internal_authors_missing | authors_missing | title_missing | year_missing | issn_missing | isbn_missing | isbn_or_issn_missing | stat_code_errors | oa_file_missing)
        where $value eq 'true'
        return 1
  where not(empty($errors))
  return $record
}</csv>

return file:write($path || lower-case($organisation) || "-" || "missing-fields.csv",$csv,$params)



