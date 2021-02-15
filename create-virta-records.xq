let $selected:=
<Julkaisut>{
for $record in //records/*
  
  let $publication_year:=
  if (max($record//publicationDate/year) eq 2021) then
    min($record//publicationDate/year) 
    else (max($record//publicationDate/year))
  
  let $title:=string-join(($record/title,$record/subTitle), " : ")
  
  let $language:=substring-after(substring-before($record/language/@uri,'/dk/atira/pure/core/languages/'),"_")
  
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
  
  let $number:=data($record/journalNumber)
  
  let $volume:=data($record/volume)
  
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

  let $open_access:=data(substring-after($record//keywordGroup[@logicalName="OpenAccessPublication"]/structuredKeywords[1]/structuredKeyword[1]/@uri,"/dk/atira/pure/researchoutput/openaccesspublication/"))
  
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
      data($record/*/issn[1])
   else if ($record/publicationSeries/publicationSerie/electronicIssn or $record/journalAssociation/electronicIssn) then
      data($record/*/electronicIssn[1])
   
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
  <JufoTunnus>78248</JufoTunnus>
  <JulkaisumaaKoodi>{$publication_country}</JulkaisumaaKoodi>
  <LehdenNimi>{data($journal_series_title)}</LehdenNimi>
  <ISSN>{$issns}</ISSN>
  <VolyymiTeksti>{$volume}</VolyymiTeksti>
  <LehdenNumeroTeksti>{$number}</LehdenNumeroTeksti>
  {$conference}
  <EmojulkaisunNimi>{$host_title}</EmojulkaisunNimi>
  <JulkaisutyyppiKoodi>{$okm_class}</JulkaisutyyppiKoodi>
  {$statgroups}
  <YhteisjulkaisuKVKytkin>1</YhteisjulkaisuKVKytkin>
  <JulkaisunKansainvalisyysKytkin>1</JulkaisunKansainvalisyysKytkin>
  <JulkaisunKieliKoodi>{$language}</JulkaisunKieliKoodi>
  <AvoinSaatavuusKoodi>{$open_access}</AvoinSaatavuusKoodi>
  <YhteisjulkaisuYritysKytkin>0</YhteisjulkaisuYritysKytkin>
  <RinnakkaistallennettuKytkin>{$self_archived_status}</RinnakkaistallennettuKytkin>
  {$self_archived_content}
  {$doi}
  <PysyvaOsoiteTeksti>http://dx.doi.org/10.29333/ejmste/86363</PysyvaOsoiteTeksti>
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


