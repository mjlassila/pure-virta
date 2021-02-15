import module namespace functx = 'http://www.functx.com';

let $selected:=
<Julkaisut>{
for $record in //records/*
  let $publication_year:=
  if (max($record//publicationDate/year) eq 2021) then
    min($record//publicationDate/year) 
    else (max($record//publicationDate/year))
  
  let $title:=string-join(($record/title,$record/subTitle), " : ")
  
  let $language:=substring-before(substring-after($record/language/@uri,'/dk/atira/pure/core/languages/'),"_")
  
  let $publication_country:=substring-after($record//keywordGroup[@logicalName="CountryOfPublishing"]//structuredKeyword/@uri,"/dk/atira/pure/researchoutput/countryofpublishing/")
  
  let $statgroups:=
  <TieteenalaKoodit>{
    for $uri in $record//keywordGroup[@logicalName="ResearchoutputFieldOfScienceStatisticsFinland"]//structuredKeyword/@uri
      count $c
      let $code:=replace(substring-after($uri,"/dk/atira/pure/keywords/fieldofsciencestatisticsfinland"),"/","")
      return <TieteenalaKoodi JNro="{$c}">{$code}</TieteenalaKoodi>
  }</TieteenalaKoodit>
  
  let $international_pub:=substring-after($record//keywordGroup[@logicalName="InternationalPublication"]//structuredKeyword/@uri,"/dk/atira/pure/researchoutput/internationalpublication/")
  
  let $okm_class:=substring-after($record/assessmentType/@uri,"/dk/atira/pure/assessmenttype/")
  
  let $pages:=
    if ($record/pages) then
    <SivunumeroTeksti>{data($record/pages)}</SivunumeroTeksti>
  
  let $journal_title:=data($record/journalAssociation/title)
  
  let $number:= if($record/journalNumber) then
    <LehdenNumeroTeksti>{data($record/journalNumber)}</LehdenNumeroTeksti>
  
  let $volume:= if ($record/volume) then
    <VolyymiTeksti>{data($record/volume)}</VolyymiTeksti>
  
  let $article_number:= 
    if ($record/articleNumber) then
    <Artikkelinumero>{data($record/articleNumber)}</Artikkelinumero>
  
  let $host_title:=string-join(($record/hostPublicationTitle,$record/hostPublicationSubTitle)," : ")
  
  let $number_of_authors:=data($record/totalNumberOfAuthors)
  
  let $authors:=
    string-join((for $author in $record/personAssociations/personAssociation
      let $fullname:=string-join(($author/name/lastName,$author/name/firstName),", ")
      return $fullname),"; ")
  let $internal_authors:=<internal_authors>{string-join((
    
    for $author in $record/personAssociations/personAssociation/person[@externalIdSource="synchronisedUnifiedPerson" and ../organisationalUnits/organisationalUnit[@externalIdSource="synchronisedUnifiedOrganisation"]/type[./term/text contains text {"Laitos","Hallinto","Sairaalan vastuualue"} any]]/../name
    return <person>{string-join(($author/lastName,$author/firstName),", ")}</person>),";")}</internal_authors>
  
  
  let $internal_organizations:=
  <internal_organizations>{
    for $org in $record/personAssociations/personAssociation/person[@externalIdSource="synchronisedUnifiedPerson"]/../organisationalUnits/organisationalUnit[@externalIdSource="synchronisedUnifiedOrganisation"]/type[./term/text contains text {"Laitos","Hallinto","Sairaalan vastuualue"} any]/../name/text[@locale="fi_FI"]
    return <org>{data($org)}</org>
}</internal_organizations>

  
  let $open_access:= <AvoinSaatavuusKoodi>{
    if ($record//structuredKeyword/@uri="/dk/atira/pure/researchoutput/openaccesspublication/1") then
    '1'
    else if ($record//structuredKeyword/@uri="/dk/atira/pure/researchoutput/openaccesspublication/0") then
    '0'
    else if ($record//structuredKeyword/@uri="/dk/atira/pure/researchoutput/openaccesspublication/0=2") then
    '2'
    else '0'
    }</AvoinSaatavuusKoodi>
    
  
  let $host_editors:=
    if ($record/hostPublicationEditors) then
    <host_publication_editors>{
    string-join(
  (
    for $editor in $record//hostPublicationEditor
      return string-join(($editor/lastName, $editor/firstName),", ")
  ), ";")
}</host_publication_editors>

  let $journal_series_title:=
    if ($record/publicationSeries) then
      <journal_series_title>{data($record/publicationSeries/publicationSerie[1]/name)}</journal_series_title>
    else if ($record/journalAssociation) then
    <journal_series_title>{data($record/journalAssociation/title)}</journal_series_title>
    
  let $issns:=
    if ($record/publicationSeries/publicationSerie/issn or $record/journalAssociation/issn) then
      <ISSN>{data($record/*/issn[1])}</ISSN>
   else if ($record/publicationSeries/publicationSerie/electronicIssn or $record/journalAssociation/electronicIssn) then
      <ISSN>{data($record/*/electronicIssn[1])}</ISSN>
   
  let $internal_identifier:=data($record/@uuid)
  
  let $doi:=if($record//electronicVersion[@type="wsElectronicVersionDoiAssociation"][1]/doi) then
    <DOI>{substring-after($record//electronicVersion[@type="wsElectronicVersionDoiAssociation"][1]/doi[1],(".org/"))}</DOI>
    
  let $self_archived_status:=substring-after($record//keywordGroup[@logicalName="SelfArchivedPublication"]/keywordContainers/keywordContainer[1]/structuredKeyword/@uri,"/dk/atira/pure/researchoutput/selfarchivedpublication/")
  
  let $self_archived_content:= if(contains($self_archived_status,"1")) then
  <RinnakkaisTallennettu>
    <RinnakkaisTallennusOsoiteTeksti>{$record//electronicVersion[accessType/@uri contains text {'/dk/atira/pure/core/openaccesspermission/embargoed','/dk/atira/pure/core/openaccesspermission/open'} any]/link}</RinnakkaisTallennusOsoiteTeksti>
  </RinnakkaisTallennettu>
  
  let $conference:=
    if($record/event[type/@uri="/dk/atira/pure/event/eventtypes/event/conference"]/name/text) then
      <KonferenssinNimi>{data($record/event[type/@uri="/dk/atira/pure/event/eventtypes/event/conference"]/name/text)}</KonferenssinNimi>
  
  let $isbns:=for $isbn in distinct-values(($record/isbns/isbn, $record/electronicIsbns/electronicIsbn))
      return <ISBN>{$isbn}</ISBN> 
  
  let $jufoid:=distinct-values(functx:get-matches(substring-after(lower-case(string-join($record/bibliographicalNote/text,";")),"jufoid="),"\d{1,7}"))[1]
  let $jufo:=if($jufoid) then
  <JufoTunnus>{$jufoid}</JufoTunnus>
  
  let $international_collab:= if ($record//structuredKeyword/@uri="/dk/atira/pure/researchoutput/typeofcopublication/internationalcopublication/1") then
  <YhteisjulkaisuKVKytkin>1</YhteisjulkaisuKVKytkin>
  
  let $company_collab:= 
  if ($record//structuredKeyword/@uri="/dk/atira/pure/researchoutput/copublicationwithacompany/1") then
    <YhteisjulkaisuYritysKytkin>1</YhteisjulkaisuYritysKytkin>
  else if ($record//structuredKeyword/@uri="/dk/atira/pure/researchoutput/copublicationwithacompany/0") then
     <YhteisjulkaisuYritysKytkin>0</YhteisjulkaisuYritysKytkin>
  
  let $publisher_url:=$record//electronicVersion[versionType/@uri="/dk/atira/pure/researchoutput/electronicversion/versiontype/publishersversion"]
  
  let $permanent_url:=if($publisher_url) then
    <PysyvaOsoiteTeksti>{data($publisher_url/doi)}</PysyvaOsoiteTeksti>
  
  let $international_publisher:= 
    if ($record//structuredKeyword/@uri="/dk/atira/pure/researchoutput/internationalpublisher/1") then
     <JulkaisunKansainvalisyysKytkin>1</JulkaisunKansainvalisyysKytkin>
   else if ($record//structuredKeyword/@uri="/dk/atira/pure/researchoutput/internationalpublisher/0") then
      <JulkaisunKansainvalisyysKytkin>0</JulkaisunKansainvalisyysKytkin>
   
    
    

where $publication_year > 2019 and $record/workflow/@workflowStep="validated"

return
<Julkaisu>
  <OrganisaatioTunnus>99999</OrganisaatioTunnus>
  <JulkaisunTilaKoodi>2</JulkaisunTilaKoodi>
  <JulkaisunOrgTunnus>{$internal_identifier}</JulkaisunOrgTunnus>
  <JulkaisunOrgYksikot>
    <YksikkoKoodi>H918</YksikkoKoodi>
    <YksikkoKoodi>H60</YksikkoKoodi>
  </JulkaisunOrgYksikot>
  <JulkaisuVuosi>{$publication_year}</JulkaisuVuosi>
  <JulkaisunNimi>{$title}</JulkaisunNimi>
  <TekijatiedotTeksti>{$authors}</TekijatiedotTeksti>
  <TekijoidenLkm>{$number_of_authors}</TekijoidenLkm>
  {$pages}
  {$isbns[position()<3]}
  {$jufo}
  <JulkaisumaaKoodi>{$publication_country}</JulkaisumaaKoodi>
  <LehdenNimi>{data($journal_series_title)}</LehdenNimi>
  {$issns[position()<3]}
  {$volume}
  {$number}
  {$conference}
  <EmojulkaisunNimi>{$host_title}</EmojulkaisunNimi>
  <JulkaisutyyppiKoodi>{$okm_class}</JulkaisutyyppiKoodi>
  {$statgroups}
  {$international_collab}
  {$international_publisher}
  <JulkaisunKieliKoodi>{$language}</JulkaisunKieliKoodi>
  {$open_access}
  {$company_collab}
  <RinnakkaistallennettuKytkin>{$self_archived_status}</RinnakkaistallennettuKytkin>
  {$self_archived_content}
  {$doi}
  {$permanent_url}
  <LahdetietokannanTunnus>Scopus:85043780753</LahdetietokannanTunnus>
        <Tekijat>
            <Tekija>
                <Sukunimi>Wang</Sukunimi>
                <Etunimet>Yan</Etunimet>
                <ORCID>0000-0002-5075-6039</ORCID>
            </Tekija>
            <Tekija>
                <Sukunimi>Tirri</Sukunimi>
                <Etunimet>Kirsi</Etunimet>
                <ORCID>0000-0001-5847-344X</ORCID>
            </Tekija>
            <Tekija>
                <Sukunimi>Lavonen</Sukunimi>
                <Etunimet>Jari</Etunimet>
                <ORCID>0000-0003-2781-7953</ORCID>
            </Tekija>
        </Tekijat>
    </Julkaisu>
}</Julkaisut>

return $selected


