for $record in //items/*[position()<100]
  let $publication_year:=max($record//publicationDate/year)
  let $title:=data($record/title)
  let $language:=substring-after($record/language/@uri,'/dk/atira/pure/core/languages/')
  let $publication_country:=substring-after($record//keywordGroup[@logicalName="CountryOfPublishing"]//structuredKeyword/@uri,"/dk/atira/pure/researchoutput/countryofpublishing/")
  let $statgroups:=string-join($record//keywordGroup[@logicalName="ResearchoutputFieldOfScienceStatisticsFinland"]//structuredKeyword/@uri,";")
  let $international_pub:=substring-after($record//keywordGroup[@logicalName="InternationalPublication"]//structuredKeyword/@uri,"/dk/atira/pure/researchoutput/internationalpublication/")
  let $okm_class:=substring-after($record/assessmentType/@uri,"/dk/atira/pure/assessmenttype/")
  let $pages:=data($record/pages)
  let $journal_title:=data($record/journalAssociation/title)
  let $number:=$record/journalNumber
  let $host_title:=data($record/hostPublicationTitle)
  let $number_of_authors:=data($record/totalNumberOfAuthors)
  let $authors:=
    string-join((for $author in $record/personAssociations/personAssociation
      let $fullname:=string-join(($author/name/lastName,$author/name/firstName),", ")
      return $fullname),"; ")
  let $internal_authors:=
    <internal_authors>{
    for $author in $record/personAssociations/personAssociation/person[@externalIdSource="synchronisedUnifiedPerson"]/@uuid
    return <person>{/csv/record[uuid eq $author and primary="true"]/*}</person>
    }</internal_authors>
  let $open_access:=data($record//keywordGroup[@logicalName="OpenAccessPublication"]//structuredKeyword[1]/@uri)

(:where $publication_year > 2019:)

return
<record>
<title>{$title}</title>
<authors>{$authors}</authors>
{$internal_authors}
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
