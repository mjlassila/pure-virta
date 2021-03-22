
declare variable $path external:="/Users/ccmala/Documents/2021/pure-dataload/";



let $publishers:=
<publishers>{
for $record in /result/items/journal
let $issns:=distinct-values($record/issns/issn)
let $titles:=distinct-values($record/titles/title)
let $publisher:=data($record/publisher/name/text)
where string-length($publisher) > 1
let $records:=for $issn in $issns,$title in $titles
return
<record>
<issn>{$issn}</issn>
<title>{$title}</title>
<publisher>{$publisher}</publisher>
</record>

return $records

}</publishers>

return file:write($path || "publishers.xml",$publishers)