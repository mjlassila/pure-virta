let $selected:=
<records>{
for $record in //records/*
  let $publication_year:=
  if (max($record//publicationDate/year) eq 2021) then
    min($record//publicationDate/year) 
    else (max($record//publicationDate/year))
  let $title:=string-join(($record/title,$record/subTitle), " : ")
  let $language:=substring-after($record/language/@uri,'/dk/atira/pure/core/languages/')
  let $publication_country:=substring-after($record//keywordGroup[@logicalName="CountryOfPublishing"]//structuredKeyword/@uri,"/dk/atira/pure/researchoutput/countryofpublishing/")
  let $statgroups:=string-join($record//keywordGroup[@logicalName="ResearchoutputFieldOfScienceStatisticsFinland"]//structuredKeyword/@uri,";")
  let $international_pub:=substring-after($record//keywordGroup[@logicalName="InternationalPublication"]//structuredKeyword/@uri,"/dk/atira/pure/researchoutput/internationalpublication/")
  let $okm_class:=substring-after($record/assessmentType/@uri,"/dk/atira/pure/assessmenttype/")
  let $pages:=data($record/pages)
  let $journal_title:=data($record/journalAssociation/title)
  let $number:=data($record/journalNumber)
  let $volume:=data($record/volume)
  let $article_number:=data($record/articleNumber)
  let $host_title:=string-join(($record/hostPublicationTitle,$record/hostPublicationSubTitle)," : ")
  let $number_of_authors:=data($record/totalNumberOfAuthors)
  let $authors:=
    string-join((for $author in $record/personAssociations/personAssociation
      let $fullname:=string-join(($author/name/lastName,$author/name/firstName),", ")
      return $fullname),"; ")
  let $internal_authors:=<internal_authors>{string-join((
    
    for $author in $record/personAssociations/personAssociation/person[@externalIdSource="synchronisedUnifiedPerson" and not(../externalOrganisations)]/../name
    return <person>{string-join(($author/lastName,$author/firstName),", ")}</person>),";")}</internal_authors>
  
  
  let $internal_organizations:=
  <internal_organizations>{
    for $org in $record/personAssociations/personAssociation/person[@externalIdSource="synchronisedUnifiedPerson"]/../organisationalUnits/organisationalUnit[@externalIdSource="synchronisedUnifiedOrganisation"]/type[./term/text contains text {"Laitos","Hallinto","Sairaalan vastuualue"} any]/../name/text[@locale="fi_FI"]
    return <org>{data($org)}</org>
}</internal_organizations>
  let $open_access:=data($record//keywordGroup[@logicalName="OpenAccessPublication"]//structuredKeyword[1]/@uri)

where $publication_year > 2019

return
<record>
<title>{$title}</title>
<authors>{$authors}</authors>
{$internal_authors}
{$internal_organizations}
<number_of_authors>{$number_of_authors}</number_of_authors>
<publication_year>{$publication_year}</publication_year>
<language>{$language}</language>
<publication_country>{$publication_country}</publication_country>
<statgroups>{$statgroups}</statgroups>
<international_pub>{$international_pub}</international_pub>
<okm_class>{$okm_class}</okm_class>
<pages>{$pages}</pages>
<host_publication_title>{$host_title}</host_publication_title>
<open_access>{$open_access}</open_access>
</record>
}</records>

return $selected