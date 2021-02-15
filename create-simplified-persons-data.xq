declare option output:method "csv";
declare option output:csv "header=yes, separator=semicolon";
let $persons:=
<persons>{
  for $record in /result/items/person
  let $uuid:=data($record/@uuid)
  let $firstname:=data($record/name/firstName)
  let $lastname:=data($record/name/lastName)
  let $pureid:=data($record//type[@uri="/dk/atira/pure/person/personsources/personid"]/../value)
  let $staffid_tut:=data($record//type[@uri="/dk/atira/pure/person/personsources/staffid_tut"]/../value)
  let $staffid_tuni:=data($record//type[@uri="/dk/atira/pure/person/personsources/staffid_tuni"]/../value)
  let $staffid_pshp:=data($record//type[@uri="/dk/atira/pure/person/personsources/staffid_pshp"]/../value)
  let $organizations:=for $org in $record//staffOrganisationAssociation
    return
    <organization>
    <name>{data($org//organisationalUnit//name/text[@locale="fi_FI"])}</name>
    <type>{data($org//organisationalUnit//type//text[@locale="fi_FI"])}</type>
    <period_start>{data($org//period/startDate)}</period_start>
    <period_end>{data($org//period/endDate)}</period_end>
    <primary>{data($org/isPrimaryAssociation)}</primary>
    </organization>
  
  return
  <person>
  <uuid>{$uuid}</uuid>
  <lastname>{$lastname}</lastname>
  <firstname>{$firstname}</firstname>
  <pureid>{$pureid}</pureid>
  <staffid_tut>{$staffid_tut}</staffid_tut>
  <staffid_tuni>{$staffid_tuni}</staffid_tuni>
  <staffid_pshp>{$staffid_pshp}</staffid_pshp>
  {$organizations}
  </person>

}</persons>

let $csv:=
<csv>{
  for $person in $persons/person
    for $org in $person/organization
    return
    <entry>
    {$person/uuid}
    {$person/lastname}
    {$person/firstname}
    {$person/pureid}
    {$person/staffid_tut}
    {$person/staffid_tuni}
    {$person/staffid_pshp}
    <org_name>{data($org/name)}</org_name>
    <org_type>{data($org/type)}</org_type>
    <period_start>{data($org/period_start)}</period_start>
    <period_end>{data($org/period_end)}</period_end>
    <primary>{data($org/primary)}</primary>
    </entry>
}</csv>

return $csv
  