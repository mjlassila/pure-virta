(: Creates the subset of the dataset fetched from Pure :)
(: Selects only records relevant to current reporting year :)

let $selected:=
<records>{
for $record in //items/*
  (:let $publication_year:=max($record//publicationDate/year):)
  let $statistical_year:=substring-after($record//keywordGroup[@logicalName="StatisticalYearPSHP"]/keywordContainers/keywordContainer[1]/structuredKeyword/@uri,"/dk/atira/pure/researchoutput/statisticalyear_pshp/")
  where $statistical_year eq "2020"
  return $record
}</records>

return file:write('/Users/ccmala/Documents/2021/pure-dataload/pshp-okm-publications.xml',$selected)