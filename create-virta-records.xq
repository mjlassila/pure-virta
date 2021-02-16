xquery version "1.0";
declare namespace julkaisut = "urn:mace:funet.fi:julkaisut/2015/03/01";
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
  
  let $publication_country:=
    if ($record//keywordGroup[@logicalName="CountryOfPublishing"]) then
    <JulkaisumaaKoodi>{substring-after($record//keywordGroup[@logicalName="CountryOfPublishing"]//structuredKeyword/@uri,"/dk/atira/pure/researchoutput/countryofpublishing/")}</JulkaisumaaKoodi>
 
  
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
  
  let $host_title:=
    if ($record/hostPublicationTitle) then
      <EmojulkaisunNimi>{string-join(($record/hostPublicationTitle,$record/hostPublicationSubTitle)," : ")}</EmojulkaisunNimi>
   
  let $number_of_authors:=
    if ($record/totalNumberOfAuthors) then
    <TekijoidenLkm>{data($record/totalNumberOfAuthors)}</TekijoidenLkm>
  
  let $authors:=
    string-join((for $author in $record/personAssociations/personAssociation
      let $fullname:=string-join(($author/name/lastName,$author/name/firstName),", ")
      return $fullname),"; ")
  let $internal_authors:=
    <Tekijat>{
    
    for $author in $record/personAssociations/personAssociation/person[@externalIdSource="synchronisedUnifiedPerson" and ../organisationalUnits/organisationalUnit[@externalIdSource="synchronisedUnifiedOrganisation"]/type[./term/text contains text {"Laitos","Hallinto","Sairaalan vastuualue"} any]]/../name
    return 
    <Tekija>
      <Sukunimi>{data($author/lastName)}</Sukunimi>
      <Etunimet>{data($author/firstName)}</Etunimet>
    </Tekija>
    }</Tekijat>
  
  (: requires mapping from internal values to external organization codes, currently uses manipulated internal values :)
  let $internal_organizations:=
  <JulkaisunOrgYksikot>{
    for $org in distinct-values($record/personAssociations/personAssociation/person[@externalIdSource="synchronisedUnifiedPerson"]/../organisationalUnits/organisationalUnit[@externalIdSource="synchronisedUnifiedOrganisation"]/type[./term/text contains text {"Laitos","Hallinto","Sairaalan vastuualue"} any]/../../organisationalUnit/@externalId)
    return <YksikkoKoodi>{substring-before(substring-after($org,"_"),"_")}</YksikkoKoodi>
}</JulkaisunOrgYksikot>

  
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
    <EmojulkaisunToimittajatTeksti>{
    string-join(
  (
    for $editor in $record//hostPublicationEditor
      return string-join(($editor/lastName, $editor/firstName),", ")
  ), ";")
}</EmojulkaisunToimittajatTeksti>

  let $journal_series_title:=
     if ($record/publicationSeries) then
      <LehdenNimi>{data($record/publicationSeries/publicationSerie[1]/name)}</LehdenNimi>
    else if ($record/journalAssociation) then
    <LehdenNimi>{data($record/journalAssociation/title)}</LehdenNimi>
    
  let $issns:=
    if ($record/publicationSeries/publicationSerie/issn) then
      <ISSN>{data($record/publicationSeries/publicationSerie/issn)}</ISSN>
    else if  ($record/journalAssociation/issn) then
      <ISSN>{data($record/journalAssociation/issn)}</ISSN>
    else if ($record/publicationSeries/publicationSerie/electronicIssn) then
      <ISSN>{data($record/publicationSeries/publicationSerie/electronicIssn)}</ISSN>
    else if  ($record/journalAssociation/electronicIssn) then
      <ISSN>{data($record/journalAssociation/electronicIssn)}</ISSN>
   
  let $internal_identifier:=data($record/@uuid)
  
  let $doi:=if($record//electronicVersion[@type="wsElectronicVersionDoiAssociation"][1]/doi) then
    <DOI>{substring-after($record//electronicVersion[@type="wsElectronicVersionDoiAssociation"][1]/doi[1],(".org/"))}</DOI>
    
  let $self_archived_status:=
  if	($record//keywordGroup[@logicalName="SelfArchivedPublication"]) then
  <RinnakkaistallennettuKytkin>{substring-after($record//keywordGroup[@logicalName="SelfArchivedPublication"]/keywordContainers/keywordContainer[1]/structuredKeyword/@uri,"/dk/atira/pure/researchoutput/selfarchivedpublication/")}</RinnakkaistallennettuKytkin>
  
  let $self_archived_content:= if(contains($self_archived_status,"1")) then
  <RinnakkaisTallennettu>
    <RinnakkaisTallennusOsoiteTeksti>{data($record//electronicVersion[accessType/@uri contains text {'/dk/atira/pure/core/openaccesspermission/embargoed','/dk/atira/pure/core/openaccesspermission/open'} any]/link)}</RinnakkaisTallennusOsoiteTeksti>
  </RinnakkaisTallennettu>
  
  let $conference:=
    if($record/event[type/@uri="/dk/atira/pure/event/eventtypes/event/conference"]/name/text) then
      <KonferenssinNimi>{data($record/event[type/@uri="/dk/atira/pure/event/eventtypes/event/conference"]/name/text)}</KonferenssinNimi>
  
  let $isbns:=for $isbn in distinct-values(($record/isbns/isbn, $record/electronicIsbns/electronicIsbn))
      return <ISBN>{$isbn}</ISBN> 
  
  let $jufoid:=distinct-values(functx:get-matches(substring-after(lower-case(string-join($record/bibliographicalNote/text,";")),"jufoid="),"\d{1,7}"))[1]
  let $jufo:= if($jufoid) then
    <JufoTunnus>{$jufoid}</JufoTunnus>
  
  let $international_collab:= 
    if ($record//structuredKeyword/@uri="/dk/atira/pure/researchoutput/typeofcopublication/internationalcopublication/1") then
      <YhteisjulkaisuKVKytkin>1</YhteisjulkaisuKVKytkin>
    else if($record//structuredKeyword/@uri="/dk/atira/pure/researchoutput/typeofcopublication/internationalcopublication/0") then
      <YhteisjulkaisuKVKytkin>0</YhteisjulkaisuKVKytkin>
  
  let $company_collab:= 
  if ($record//structuredKeyword/@uri="/dk/atira/pure/researchoutput/copublicationwithacompany/1") then
    <YhteisjulkaisuYritysKytkin>1</YhteisjulkaisuYritysKytkin>
  else if ($record//structuredKeyword/@uri="/dk/atira/pure/researchoutput/copublicationwithacompany/0") then
     <YhteisjulkaisuYritysKytkin>0</YhteisjulkaisuYritysKytkin>
  
  let $publisher_url:=$record//electronicVersion[versionType/@uri="/dk/atira/pure/researchoutput/electronicversion/versiontype/publishersversion"]
  
  let $permanent_url:=if($publisher_url) then
    <PysyvaOsoiteTeksti>{data($publisher_url/doi)}</PysyvaOsoiteTeksti>
    else if ($self_archived_content) then
    <PysyvaOsoiteTeksti>{data($self_archived_content)}</PysyvaOsoiteTeksti>
  
  let $international_publisher:= 
    if ($record//structuredKeyword/@uri="/dk/atira/pure/researchoutput/internationalpublisher/1") then
     <JulkaisunKansainvalisyysKytkin>1</JulkaisunKansainvalisyysKytkin>
   else if ($record//structuredKeyword/@uri="/dk/atira/pure/researchoutput/internationalpublisher/0") then
      <JulkaisunKansainvalisyysKytkin>0</JulkaisunKansainvalisyysKytkin>
  
  let $publisher:=if($record/publisher[1]/name/text) then
    <KustantajanNimi>{data($record/publisher[1]/name/text)}</KustantajanNimi>
    
   
    
    

where $publication_year > 2019 and $record/workflow/@workflowStep="validated" and $okm_class != "noteligible"
(:PSHP organization code 08265978:)
return
<Julkaisu>
  <OrganisaatioTunnus>10122</OrganisaatioTunnus>
  <JulkaisunTilaKoodi>2</JulkaisunTilaKoodi>
  <JulkaisunOrgTunnus>{$internal_identifier}</JulkaisunOrgTunnus>
  {$internal_organizations}
  <JulkaisuVuosi>{$publication_year}</JulkaisuVuosi>
  <JulkaisunNimi>{$title}</JulkaisunNimi>
  <TekijatiedotTeksti>{$authors}</TekijatiedotTeksti>
  {$number_of_authors}
  {$pages}
  {$isbns[position()<3]}
  {$jufo}
  {$publication_country}
  {$journal_series_title}
  {$issns[position()<3]}
  {$volume}
  {$number}
  {$conference}
  {$publisher}
  {$host_title}
  {$host_editors}
  <JulkaisutyyppiKoodi>{$okm_class}</JulkaisutyyppiKoodi>
  {$statgroups}
  {$international_collab}
  {$international_publisher}
  <JulkaisunKieliKoodi>{$language}</JulkaisunKieliKoodi>
  {$open_access}
  {$company_collab}
  {$self_archived_status}
  {$self_archived_content}
  {$doi}
  {$permanent_url}
  <LahdetietokannanTunnus>Scopus:85043780753</LahdetietokannanTunnus>
  {$internal_authors}
  </Julkaisu>
}</Julkaisut>

return file:write("/Users/ccmala/Documents/2021/pure-dataload/tunicris-to-virta.xml",$selected)





