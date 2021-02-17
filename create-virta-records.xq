xquery version "1.0";
declare namespace julkaisut = "urn:mace:funet.fi:julkaisut/2015/03/01";
import module namespace functx = 'http://www.functx.com';

(: Map structure is substantially faster for looking up organisation codes
   compared to database lookup :)
let $organisations:=map:merge((
map:entry("AKU_hospitaldivision_1994-01-01","K"),
map:entry("AKUH_hospitaldepartment_2009-01-01",46),
map:entry("APSY_hospitaldepartment_1997-01-01","JV32"),
map:entry("ÄS_hospital_2008-01-01","JS3"),
map:entry("ÄS01_hospitaldepartment_2008-01-01","JV63"),
map:entry("ASER_hospitaldepartment_1997-01-01","novalue"),
map:entry("COXA_hospitaldivision_2014-01-01","JT113"),
map:entry("COXA01_hospitaldepartment_2014-01-01","JV113"),
map:entry("EAPU_hospitaldepartment_2009-01-01",35),
map:entry("EKA_hospitaldepartment_2005-01-01",31),
map:entry("ENSI_hospitaldistrict_2005-01-01","JV51"),
map:entry("EPSH01_hospitaldepartment_2008-01-01","JV64"),
map:entry("EPSH02_hospitaldepartment_2008-01-01","JV65"),
map:entry("EPSH03_hospitaldepartment_2008-01-01","JV66"),
map:entry("EPSH04_hospitaldepartment_2008-01-01","JV67"),
map:entry("EPSH05_hospitaldepartment_2008-01-01","JV68"),
map:entry("EPSH06_hospitaldepartment_2008-01-01","JV131"),
map:entry("EPSH07_hospitaldepartment_2008-01-01","JV70"),
map:entry("EPSHP_hospitaldistrict_2008-01-01","EPSHP"),
map:entry("ERHA_hospitaldepartment_2016-01-01","V3"),
map:entry("FLAB_hospitaldivision_2004-01-01","JT20"),
map:entry("FYSI_hospitaldepartment_1997-01-01","JV25"),
map:entry("FYY_hospitaldepartment_2005-01-01",58),
map:entry("GAST_hospitaldepartment_2005-01-01",19),
map:entry("HASA01_hospitaldepartment_1994-01-01","JV98"),
map:entry("HEPA_hospitaldepartment_2016-01-01",93),
map:entry("HOIV_hospitaldepartment_2014-01-01","novalue"),
map:entry("KFI_hospitaldepartment_2005-01-01",44),
map:entry("KHKS_hospital_2008-01-01","JS4"),
map:entry("KHKS01_hospitaldepartment_2008-01-01","JV71"),
map:entry("KHKS02_hospitaldepartment_2008-01-01","JV72"),
map:entry("KHKS04_hospitaldepartment_2008-01-01","JV76"),
map:entry("KHKS05_hospitaldepartment_2008-01-01","JV77"),
map:entry("KHKS06_hospitaldepartment_2008-01-01","JV118"),
map:entry("KHSH01_hospitaldepartment_2009-01-01","novalue"),
map:entry("KHSH02_hospitaldepartment_2009-01-01","novalue"),
map:entry("KHSH04_hospitaldepartment_2009-01-01","novalue"),
map:entry("KHSH05_hospitaldepartment_2008-01-01","novalue"),
map:entry("KHSH06_hospitaldepartment_2008-01-01","novalue"),
map:entry("KHSHP_hospitaldistrict_2008-01-01","KHSHP"),
map:entry("KIHA_hospitaldepartment_2009-01-01",24),
map:entry("KIR_hospitaldepartment_2005-01-01",10),
map:entry("KKEM_hospitaldepartment_2004-01-01","JV19"),
map:entry("KMIK_hospitaldepartment_2004-01-01","JV20"),
map:entry("KNEF_hospitaldepartment_2005-01-01",45),
map:entry("KORT_hospitaldepartment_1997-01-01","JV7"),
map:entry("KOU_2341_2016-08-01",2341),
map:entry("KOU_2341_2017-08-01",2341),
map:entry("KOU_2341_2019-01-01",2341),
map:entry("KOU_2343_2013-01-01",2343),
map:entry("KOU_2343_2019-01-01",2343),
map:entry("KOU_2344_2013-01-01",2344),
map:entry("KOU_2344_2019-01-01",2344),
map:entry("KOU_2345_2013-01-01",2345),
map:entry("KOU_2345_2019-01-01",2345),
map:entry("KOU_2347_2019-01-01",2347),
map:entry("KOU_2348_2013-01-01",2348),
map:entry("KOU_2348_2019-01-01",2348),
map:entry("KOU_2349_2013-01-01",2349),
map:entry("KOU_2349_2019-01-01",2349),
map:entry("KOU_2350_2013-01-01",2350),
map:entry("KOU_2351_2013-01-01",2351),
map:entry("KOU_2351_2019-01-01",2351),
map:entry("KOU_2352_2013-01-01",2352),
map:entry("KOU_2352_2019-01-01",2352),
map:entry("KOU_2353_2013-01-01",2353),
map:entry("KOU_2353_2019-01-01",2353),
map:entry("KOU_2354_2016-08-01",2354),
map:entry("KOU_2354_2017-08-01",2354),
map:entry("KOU_2354_2019-01-01",2354),
map:entry("KOU_DPAWE_2019-01-01","DPAWE"),
map:entry("KOU_DPCMT_2019-01-01","DPCMT"),
map:entry("KOU_DPEDU_2019-01-01","DPEDU"),
map:entry("KOU_DPEPH_2019-01-01","DPEPH"),
map:entry("KOU_DPGEDU_2020-01-01","DPGEDU"),
map:entry("KOU_DPGMAB_2020-01-01","DPGMAB"),
map:entry("KOU_DPGSOC_2020-01-01","DPGSOC"),
map:entry("KOU_DPHI_2019-01-01","DPHI"),
map:entry("KOU_DPHKP_2019-01-01","DPHKP"),
map:entry("KOU_DPHM_2019-01-01","DPHM"),
map:entry("KOU_DPHS_2019-01-01","DPHS"),
map:entry("KOU_DPII_2019-01-01","DPII"),
map:entry("KOU_DPIS_2019-01-01","DPIS"),
map:entry("KOU_DPIT_2019-01-01","DPIT"),
map:entry("KOU_DPLA_2019-01-01","DPLA"),
map:entry("KOU_DPLS_2019-01-01","DPLS"),
map:entry("KOU_DPMBBE_2020-01-01","DPMBBE"),
map:entry("KOU_DPMLS_2019-01-01","DPMLS"),
map:entry("KOU_DPPH_2019-01-01","DPPH"),
map:entry("KOU_DPPL_2019-01-01","DPPL"),
map:entry("KOU_DPYT_2019-01-01","DPYT"),
map:entry("LAI_101_2008-01-01",101),
map:entry("LAI_101_2013-01-01",101),
map:entry("LAI_101020_2019-01-01",101020),
map:entry("LAI_101020_2019-01-30",101020),
map:entry("LAI_101030_2019-01-01",101030),
map:entry("LAI_101030_2019-01-30",101030),
map:entry("LAI_101040_2019-01-01",101040),
map:entry("LAI_101040_2019-01-30",101040),
map:entry("LAI_101050_2019-01-01",101050),
map:entry("LAI_101050_2019-01-30",101050),
map:entry("LAI_102_2008-01-01",102),
map:entry("LAI_102_2013-01-01",102),
map:entry("LAI_102020_2019-01-01",102020),
map:entry("LAI_102030_2019-01-01",102030),
map:entry("LAI_102040_2019-01-01",102040),
map:entry("LAI_102050_2019-01-01",102050),
map:entry("LAI_102060_2019-01-01",102060),
map:entry("LAI_103020_2018-10-01",103020),
map:entry("LAI_103030_2019-01-01",103030),
map:entry("LAI_104020_2019-01-01",104020),
map:entry("LAI_104030_2019-01-01",104030),
map:entry("LAI_105020_2019-01-01",105020),
map:entry("LAI_105020_2019-01-22",105020),
map:entry("LAI_105030_2019-01-01",105030),
map:entry("LAI_105030_2019-01-22",105030),
map:entry("LAI_10529_2005-08-01",10529),
map:entry("LAI_10559_2005-08-01",10559),
map:entry("LAI_106020_2019-01-01",106020),
map:entry("LAI_106030_2019-01-01",106030),
map:entry("LAI_106040_2019-01-01",106040),
map:entry("LAI_107020_2019-01-01",107020),
map:entry("LAI_107030_2019-01-01",107030),
map:entry("LAI_107040_2019-01-01",107040),
map:entry("LAI_107050_2019-01-01",107050),
map:entry("LAI_108_2010-01-01",108),
map:entry("LAI_108_2013-01-01",108),
map:entry("LAI_109_2008-01-01",109),
map:entry("LAI_109_2013-01-01",109),
map:entry("LAI_11379_2005-08-01",11379),
map:entry("LAI_201_2008-01-01",201),
map:entry("LAI_202_2008-01-01",202),
map:entry("LAI_203_2008-01-01",203),
map:entry("LAI_220_2015-01-01",220),
map:entry("LAI_221_2015-01-01",221),
map:entry("LAI_223_2015-01-01",223),
map:entry("LAI_224_2015-01-01",224),
map:entry("LAI_225_2015-01-01",225),
map:entry("LAI_226_2015-01-01",226),
map:entry("LAI_227_2015-01-01",227),
map:entry("LAI_228_2015-01-01",228),
map:entry("LAI_231_2015-01-01",231),
map:entry("LAI_232_2015-01-01",232),
map:entry("LAI_233_2015-01-01",233),
map:entry("LAI_234_2017-01-01",234),
map:entry("LAI_241_2015-01-01",241),
map:entry("LAI_242_2015-01-01",242),
map:entry("LAI_243_2015-01-01",243),
map:entry("LAI_244_2015-01-01",244),
map:entry("LAI_251_2016-08-01",251),
map:entry("LAI_300_2008-01-01",300),
map:entry("LAI_301_2008-01-01",301),
map:entry("LAI_302_2008-01-01",302),
map:entry("LAI_303_2008-01-01",303),
map:entry("LAI_304_2008-01-01",304),
map:entry("LAI_305_2008-01-01",305),
map:entry("LAI_400_1980-01-01",400),
map:entry("LAI_401_1980-01-01",401),
map:entry("LAI_402_1980-01-01",402),
map:entry("LAI_403_1980-01-01",403),
map:entry("LAI_405_1980-01-01",405),
map:entry("LAI_406_1980-01-01",406),
map:entry("LAI_408_1980-01-01",408),
map:entry("LAI_409_1980-01-01",409),
map:entry("LAI_410_1980-01-01",410),
map:entry("LAI_4110_1980-01-01",4110),
map:entry("LAI_4111_1980-01-01",4111),
map:entry("LAI_412_1980-01-01",412),
map:entry("LAI_413_1980-01-01",413),
map:entry("LAI_414_1980-01-01",414),
map:entry("LAI_420_1980-01-01",420),
map:entry("LAI_422_1980-01-01",422),
map:entry("LAI_423_1980-01-01",423),
map:entry("LAI_424_1980-01-01",424),
map:entry("LAI_425_1980-01-01",425),
map:entry("LAI_426_1980-01-01",426),
map:entry("LAI_427_1980-01-01",427),
map:entry("LAI_428_1980-01-01",428),
map:entry("LAI_429_1980-01-01",429),
map:entry("LAI_430_1980-01-01",430),
map:entry("LAI_4300_1980-01-01",4300),
map:entry("LAI_431_1980-01-01",431),
map:entry("LAI_433_1980-01-01",433),
map:entry("LAI_435_1980-01-01",435),
map:entry("LAI_437_1980-01-01",437),
map:entry("LAI_440_1980-01-01",440),
map:entry("LAI_450_1980-01-01",450),
map:entry("LAI_451_1980-01-01",451),
map:entry("LAI_4511_2006-01-01",4511),
map:entry("LAI_4512_2006-01-01",4512),
map:entry("LAI_4513_2006-01-01",4513),
map:entry("LAI_456_1980-01-01",456),
map:entry("LAI_457_1980-01-01",457),
map:entry("LAI_459_1980-01-01",459),
map:entry("LAI_460_1980-01-01",460),
map:entry("LAI_470_1980-01-01",470),
map:entry("LAI_471_1980-01-01",471),
map:entry("LAI_472_1980-01-01",472),
map:entry("LAI_473_1980-01-01",473),
map:entry("LAI_474_1980-01-01",474),
map:entry("LAI_475_1980-01-01",475),
map:entry("LAI_476_1980-01-01",476),
map:entry("LAI_477_1980-01-01",477),
map:entry("LAI_478_1980-01-01",478),
map:entry("LAI_479_1980-01-01",479),
map:entry("LAI_480_1980-01-01",480),
map:entry("LAI_4800_1980-01-01",4800),
map:entry("LAI_481_1980-01-01",481),
map:entry("LAI_482_1980-01-01",482),
map:entry("LAI_48201_1980-01-01",48201),
map:entry("LAI_48202_1980-01-01",48202),
map:entry("LAI_48203_1980-01-01",48203),
map:entry("LAI_48204_1980-01-01",48204),
map:entry("LAI_48205_1980-01-01",48205),
map:entry("LAI_48206_1980-01-01",48206),
map:entry("LAI_48207_1980-01-01",48207),
map:entry("LAI_48208_1980-01-01",48208),
map:entry("LAI_48209_1980-01-01",48209),
map:entry("LAI_48210_1980-01-01",48210),
map:entry("LAI_48211_1980-01-01",48211),
map:entry("LAI_48212_1980-01-01",48212),
map:entry("LAI_48213_1980-01-01",48213),
map:entry("LAI_48214_1980-01-01",48214),
map:entry("LAI_4829_2005-01-01",4829),
map:entry("LAI_483_1980-01-01",483),
map:entry("LAI_484_1980-01-01",484),
map:entry("LAI_485_2006-01-01",485),
map:entry("LAI_489_2007-01-01",489),
map:entry("LAI_490_1980-01-01",490),
map:entry("LAI_495_1980-01-01",495),
map:entry("LAI_500_1980-01-01",500),
map:entry("LAI_510_2017-01-01",510),
map:entry("LAI_600_2008-01-01",600),
map:entry("LAI_601_2008-01-01",601),
map:entry("LAI_602_2008-01-01",602),
map:entry("LAI_603_2008-01-01",603),
map:entry("LAI_604_2008-01-01",604),
map:entry("LAI_605_2008-01-01",605),
map:entry("LAI_606_2008-01-01",606),
map:entry("LAI_610_2013-01-01",610),
map:entry("LAI_610_2017-01-01",610),
map:entry("LAI_611_2013-01-01",611),
map:entry("LAI_611_2017-01-01",611),
map:entry("LAI_612_2013-01-01",612),
map:entry("LAI_612_2017-01-01",612),
map:entry("LAI_613_2013-01-01",613),
map:entry("LAI_613_2017-01-01",613),
map:entry("LAI_614_2013-01-01",614),
map:entry("LAI_615_2017-01-01",615),
map:entry("LAI_700_2008-01-01",700),
map:entry("LAI_701_2008-01-01",701),
map:entry("LAI_702_2008-01-01",702),
map:entry("LAI_710_2013-01-01",710),
map:entry("LAI_711_2013-01-01",711),
map:entry("LAI_712_2013-01-01",712),
map:entry("LAI_712_2017-01-01",712),
map:entry("LAI_713_2013-01-01",713),
map:entry("LAI_714_2013-01-01",714),
map:entry("LAI_715_2014-01-01",715),
map:entry("LAI_715_2017-01-01",715),
map:entry("LAI_716_2017-01-01",716),
map:entry("LAI_800_2008-01-01",800),
map:entry("LAI_801_2008-01-01",801),
map:entry("LAI_802_2008-01-01",802),
map:entry("LAI_803_2008-01-01",803),
map:entry("LAI_804_2011-01-01",804),
map:entry("LAI_810_2013-01-01",810),
map:entry("LAI_811_2013-01-01",811),
map:entry("LAI_811_2017-01-01",811),
map:entry("LAI_812_2013-01-01",812),
map:entry("LAI_812_2017-01-01",812),
map:entry("LAI_813_2013-01-01",813),
map:entry("LAI_813_2017-01-01",813),
map:entry("LAI_814_2013-01-01",814),
map:entry("LAI_814_2017-01-01",814),
map:entry("LAI_900_2008-01-01",900),
map:entry("LAI_901_2008-01-01",901),
map:entry("LAI_902_2008-01-01",902),
map:entry("LAI_903_2008-01-01",903),
map:entry("LAI_904_2008-01-01",904),
map:entry("LAI_905_2008-01-01",905),
map:entry("LAI_906_2008-01-01",906),
map:entry("LAI_910_2013-01-01",910),
map:entry("LAI_910_2014-01-01",910),
map:entry("LAI_911_2013-01-01",911),
map:entry("LAI_911_2017-01-01",911),
map:entry("LAI_912_2013-01-01",912),
map:entry("LAI_912_2017-01-01",912),
map:entry("LAI_913_2013-01-01",913),
map:entry("LAI_913_2017-01-01",913),
map:entry("LAI_914_2013-01-01",914),
map:entry("LAI_914_2017-01-01",914),
map:entry("LAI_915_2013-01-01",915),
map:entry("LAI_916_2013-01-01",916),
map:entry("LAI_917_2013-01-01",917),
map:entry("LAI_918_2013-01-01",918),
map:entry("LAI_919_2017-01-01",919),
map:entry("LAI_FSD_2011-01-01",2571),
map:entry("LAI_FSD_2017-01-01",2571),
map:entry("LAI_LANCE_2011-01-01",2572),
map:entry("LAI_LANCE_2017-01-01",2572),
map:entry("LAI_LAS_2011-01-01",2580),
map:entry("LAI_LAS_2017-01-01",2580),
map:entry("LAI_TAYK_2011-01-01",2573),
map:entry("LAI_TAYK_2017-01-01",2573),
map:entry("LAI_YOP_2011-01-01",2592),
map:entry("LAI_YOP_2017-01-01",2592),
map:entry("LAPS_hospitaldepartment_2005-01-01",36),
map:entry("LAST_hospitaldepartment_2005-01-01",21),
map:entry("MSTH_hospital_2005-01-01","JV59"),
map:entry("MUUT_hospitaldistrict_2008-01-01","MUUT"),
map:entry("NASY_hospitaldepartment_2005-01-01",12),
map:entry("NIKU_hospitaldepartment_2005-01-01",11),
map:entry("NKIR_hospitaldepartment_1997-01-01","JV5"),
map:entry("NOTK01_hospitaldepartment_2010-01-01","JV88"),
map:entry("NOTKS_hospital_2010-01-01","JS6"),
map:entry("NUPS_hospitaldepartment_2005-01-01",33),
map:entry("OPSY_hospitaldepartment_2000-01-01","JV34"),
map:entry("ORS_hospital_2009-01-01","JS7"),
map:entry("ORS01_hospitaldepartment_2009-01-01","JV89"),
map:entry("OSKE_hospitaldepartment_2014-01-01","novalue"),
map:entry("otm-045535c9-b290-4fe2-a82d-c8f1948d3663",2353),
map:entry("otm-04cee8ad-9cac-4d13-8946-47f0f0abe62f","DPGSOC"),
map:entry("otm-09d9556e-9144-4373-85b2-86f504f896d7",2352),
map:entry("otm-18939d1f-dc26-4854-bf0d-ca4fd2ca75bc",2343),
map:entry("otm-265f0c13-82ad-4764-a7fe-1283c1a4837a",2349),
map:entry("otm-2f972d40-32eb-4fc1-8d8b-72c760b8ea49",2348),
map:entry("otm-6da2a45a-f43a-4360-a681-ca7bbf0df32f","DPGMAB"),
map:entry("otm-74fa7011-4584-4403-87d9-5f27df1314a2","DPHKP"),
map:entry("otm-89c48ef2-1fd8-4ce7-a0b2-5688c0b12e50",2351),
map:entry("otm-923749b6-94be-41e9-a321-d1b372c1e2fb","DPGEDU"),
map:entry("otm-92b34765-46c1-4025-bab6-556282009c58",2354),
map:entry("otm-9f3d803c-a7f8-4f20-a240-ebb360d11dac","DPLA"),
map:entry("otm-a4c836eb-a3fa-46ac-86da-8b6aabf86a15",2344),
map:entry("otm-a9ac5369-0f17-4435-a416-9184ef020412","DPIS"),
map:entry("otm-b500e8d3-8f2e-4eb5-8232-1fcb47a385de","DPMLS"),
map:entry("otm-beab710e-c160-4fd8-a662-266c7d780a69",2345),
map:entry("otm-d713f234-c3cd-4d12-aafe-c28c8da0240b","DPAWE"),
map:entry("otm-f02bed81-02b0-4575-9329-65e0b53c572d","DPMBBE"),
map:entry("otm-f8182cab-5c38-4b93-8359-48bd95032b80",2341),
map:entry("PAKE_hospitaldivision_1994-01-01",5),
map:entry("PAL_2010_2018-10-01",2010),
map:entry("PAL_2110_2020-06-01",2110),
map:entry("PAL_3010_2018-10-01",3010),
map:entry("PAL_4010_2018-10-01",4010),
map:entry("PAL_5010_2018-10-01",5010),
map:entry("PAL_5020_2018-10-01",5020),
map:entry("PAL_5030_2018-10-01",5030),
map:entry("PAL_6010_2018-10-01",6010),
map:entry("PAL_6020_2018-10-01",6020),
map:entry("PAL_6030_2018-10-01",6030),
map:entry("PAL_6180_2019-01-07",6180),
map:entry("PAL_6190_2019-01-07",6190),
map:entry("PAL_8010_2018-10-01",8010),
map:entry("PAL_8020_2018-10-01",8020),
map:entry("PAL_8030_2018-10-01",8030),
map:entry("PALL_hospitaldepartment_2000-01-01","JV38"),
map:entry("PATO_hospitaldepartment_2004-01-01","JV24"),
map:entry("PHKS_hospitaldepartment_2015-01-01","JS5"),
map:entry("PHKS01_hospitaldepartment_2015-01-01","JV78"),
map:entry("PHKS02_hospital_2015-01-01","JV79"),
map:entry("PHSO01_hospitaldepartment_2009-01-01","novalue"),
map:entry("PPSHP_hospital_2015-01-01","PPSHP"),
map:entry("PSGY_hospitaldepartment_1997-01-01","JV35"),
map:entry("PSHP_hospitaldistrict_1994-01-01","PSHP"),
map:entry("PSHP01_hospitaldepartment_2008-01-01","JV80"),
map:entry("PSHP02_hospitaldepartment_2008-01-01","JV81"),
map:entry("PSHP03_hospitaldepartment_2016-01-01","JV82"),
map:entry("PSHP04_hospitaldepartment_2008-01-01","JV83"),
map:entry("PSHP05_hospitaldepartment_2008-01-01","JV84"),
map:entry("PSHP06_hospitaldepartment_2008-01-01","JV85"),
map:entry("PSHP07_hospitaldepartment_2008-01-01","JV86"),
map:entry("PSHP09_hospitaldepartment_2008-01-01","JV90"),
map:entry("PSHP10_hospitaldepartment_2011-01-01","JV91"),
map:entry("PSHP11_hospitaldepartment_2010-01-01","JV92"),
map:entry("PSHP12_hospitaldepartment_2011-01-01","JV93"),
map:entry("PSHP13_hospitaldepartment_2008-01-01","JV94"),
map:entry("PSHP14_hospitaldepartment_2008-01-01","JV95"),
map:entry("PSHP15_hospitaldepartment_2011-01-01","JV96"),
map:entry("PSHP16_hospitaldepartment_2010-01-01","JV97"),
map:entry("PSHP17_hospitaldepartment_2009-01-01","novalue"),
map:entry("PSHP18_hospitaldepartment_2011-01-01","JV115"),
map:entry("PSHP20_hospitaldepartment_2013-01-01","JV133"),
map:entry("PSHP21_hospitaldepartment_2013-01-01","JV134"),
map:entry("pshp22_hospitaldepartment_2014-01-01","JV137"),
map:entry("PSHP23_hospitaldepartment_2008-01-01","JV138"),
map:entry("PSKA_hospitaldepartment_2000-01-01","JV37"),
map:entry("PSSP_hospitaldepartment_2000-01-01","JV36"),
map:entry("PSYK_hospitaldepartment_2005-01-01",30),
map:entry("PSYN_hospitaldepartment_2005-01-01",50),
map:entry("RSS_hospital_2008-01-01","JS11"),
map:entry("RSS01_hospitaldepartment_2008-01-01","JV112"),
map:entry("SAPT_hospitaldepartment_1994-01-01","novalue"),
map:entry("SDIA_hospitaldepartment_2009-01-01",43),
map:entry("SEKS_hospital_2008-01-01","JS2"),
map:entry("SEKS01_hospitaldepartment_2008-01-01","JV62"),
map:entry("SIKS_hospitaldepartment_2011-01-01",23),
map:entry("SILT_hospitaldepartment_1997-01-01","JV8"),
map:entry("SIST_hospitaldepartment_2005-01-01",20),
map:entry("SKS_hospitaldepartment_2005-01-01",13),
map:entry("SYD_hospitaldivision_2005-01-01","JT40"),
map:entry("SYK_hospitaldepartment_2005-01-01","JV40"),
map:entry("SYÖP_hospitaldepartment_2019-01-01",952),
map:entry("SYÖT_hospitaldepartment_2005-01-01",25),
map:entry("TA1_hospitaldivision_1994-01-01","S"),
map:entry("TA2_hospitaldivision_1994-01-01","G"),
map:entry("TA2K_hospitaldepartment_2005-01-01",29),
map:entry("TA3_hospitaldivision_1994-01-01","N"),
map:entry("TA4_hospitaldivision_1994-01-01","C"),
map:entry("TA5_hospitaldivision_1994-01-01","P"),
map:entry("TA6_hospitaldivision_1994-01-01","V"),
map:entry("TA7_hospitaldivision_1994-01-01","E"),
map:entry("TA8_hospitaldivision_1994-01-01","JT98"),
map:entry("TAYS_hospital_1994-01-01","S1"),
map:entry("TAYServa_catchmentarea_1994-01-01",8265978),
map:entry("TEHO_hospitaldepartment_2005-01-01",38),
map:entry("TEK_hospitaldepartment_1997-01-01","novalue"),
map:entry("TKA_1_2008-01-01",1),
map:entry("TKA_10_2013-01-01",10),
map:entry("TKA_1010_2018-10-01",1010),
map:entry("TKA_1020_2018-10-01",1020),
map:entry("TKA_1030_2018-10-01",1030),
map:entry("TKA_1040_2018-10-01",1040),
map:entry("TKA_1050_2018-10-01",1050),
map:entry("TKA_1060_2018-10-01",1060),
map:entry("TKA_1070_2018-10-01",1070),
map:entry("TKA_2_2008-01-01",2),
map:entry("TKA_20_2013-01-01",20),
map:entry("TKA_22_2015-01-01",22),
map:entry("TKA_23_2015-01-01",23),
map:entry("TKA_24_2015-01-01",24),
map:entry("TKA_25_2016-08-01",25),
map:entry("TKA_3_2008-01-01",3),
map:entry("TKA_40_1980-01-01",40),
map:entry("TKA_41_1980-01-01",41),
map:entry("TKA_42_1980-01-01",42),
map:entry("TKA_43_1980-01-01",43),
map:entry("TKA_44_1980-01-01",44),
map:entry("TKA_45_1980-01-01",45),
map:entry("TKA_46_1980-01-01",46),
map:entry("TKA_47_1980-01-01",47),
map:entry("TKA_48_1980-01-01",48),
map:entry("TKA_49_1980-01-01",49),
map:entry("TKA_51_1980-01-01",51),
map:entry("TKA_51_2017-01-01",51),
map:entry("TKA_6_2008-01-01",6),
map:entry("TKA_61_2013-01-01",61),
map:entry("TKA_61_2017-01-01",61),
map:entry("TKA_7_2008-01-01",7),
map:entry("TKA_71_2013-01-01",71),
map:entry("TKA_8_2008-01-01",8),
map:entry("TKA_81_2013-01-01",81),
map:entry("TKA_9_2008-01-01",9),
map:entry("TKA_91_2013-01-01",91),
map:entry("TKA_91_2014-01-01",91),
map:entry("TKA_99_1980-01-01",99),
map:entry("TKA_CMT_2011-01-01",2507),
map:entry("TKA_COMS_2017-01-01",2502),
map:entry("TKA_EDU_2011-01-01",2504),
map:entry("TKA_EDU_2017-01-01",2504),
map:entry("TKA_ERIL_2019-01-01","ERIL"),
map:entry("TKA_HES_2011-01-01",2508),
map:entry("TKA_IBT_2011-01-01",2501),
map:entry("TKA_JKK_2011-01-01",2503),
map:entry("TKA_JKK_2017-01-01",2503),
map:entry("TKA_LTL_2011-01-01",2505),
map:entry("TKA_LUO_2017-01-01",2522),
map:entry("TKA_MED_2011-01-01",2506),
map:entry("TKA_MED_2017-01-01",2501),
map:entry("TKA_SIS_2011-01-01",2502),
map:entry("TKA_SOC_2017-01-01",2509),
map:entry("TKA_YKY_2011-01-01",2509),
map:entry("TKI_hospitaldepartment_1994-01-01",96),
map:entry("TR_10_2013-01-01",10),
map:entry("TR_100_2014-12-11",100),
map:entry("TR_101_2014-12-12",101),
map:entry("TR_102_2014-12-12",102),
map:entry("TR_103_2014-12-12",103),
map:entry("TR_104_2014-12-12",104),
map:entry("TR_105_2014-12-12",105),
map:entry("TR_106_2013-01-01",106),
map:entry("TR_107_2013-01-01",107),
map:entry("TR_108_2013-01-01",108),
map:entry("TR_11_2013-01-01",11),
map:entry("TR_112_2014-01-01",112),
map:entry("TR_113_2014-01-01",113),
map:entry("TR_114_2014-01-01",114),
map:entry("TR_115_2014-01-01",115),
map:entry("TR_116_2014-01-01",116),
map:entry("TR_117_2014-01-01",117),
map:entry("TR_118_2014-01-01",118),
map:entry("TR_119_2014-01-01",119),
map:entry("TR_120_2014-01-01",120),
map:entry("TR_121_2014-01-01",121),
map:entry("TR_122_2014-01-01",122),
map:entry("TR_123_2014-01-01",123),
map:entry("TR_124_2014-01-01",124),
map:entry("TR_125_2014-01-01",125),
map:entry("TR_126_2014-01-01",126),
map:entry("TR_127_2014-01-01",127),
map:entry("TR_128_2014-01-01",128),
map:entry("TR_129_2014-01-01",129),
map:entry("TR_130_2013-01-01",130),
map:entry("TR_131_2013-01-01",131),
map:entry("TR_132_2015-01-01",132),
map:entry("TR_133_2015-01-01",133),
map:entry("TR_134_2015-01-01",134),
map:entry("TR_135_2015-01-01",135),
map:entry("TR_136_2015-01-01",136),
map:entry("TR_137_2015-01-01",137),
map:entry("TR_138_2015-01-01",138),
map:entry("TR_139_2015-01-01",139),
map:entry("TR_140_2013-01-01",140),
map:entry("TR_141_2013-01-01",141),
map:entry("TR_142_2013-01-01",142),
map:entry("TR_143_2013-01-01",143),
map:entry("TR_144_2013-01-01",144),
map:entry("TR_145_2013-01-01",145),
map:entry("TR_146_2013-01-01",146),
map:entry("TR_147_2013-01-01",147),
map:entry("TR_148_2013-01-01",148),
map:entry("TR_149_2013-01-01",149),
map:entry("TR_150_2013-01-01",150),
map:entry("TR_152_2015-01-01",152),
map:entry("TR_153_2015-01-01",153),
map:entry("TR_156_2015-01-01",156),
map:entry("TR_157_2015-01-01",157),
map:entry("TR_159_2014-01-01",159),
map:entry("TR_160_2014-01-01",160),
map:entry("TR_161_2014-01-01",161),
map:entry("TR_162_2014-01-01",162),
map:entry("TR_163_2014-01-01",163),
map:entry("TR_164_2015-01-01",164),
map:entry("TR_164_2018-09-18",164),
map:entry("TR_165_2015-01-01",165),
map:entry("TR_165_2018-09-18",165),
map:entry("TR_166_2015-01-01",166),
map:entry("TR_166_2018-09-18",166),
map:entry("TR_167_2015-01-01",167),
map:entry("TR_168_2015-01-01",168),
map:entry("TR_169_2015-01-01",169),
map:entry("TR_17_2013-02-18",17),
map:entry("TR_170_2015-01-01",170),
map:entry("TR_171_2015-01-01",171),
map:entry("TR_172_2015-01-01",172),
map:entry("TR_173_2015-01-01",173),
map:entry("TR_174_2015-01-01",174),
map:entry("TR_175_2015-01-01",175),
map:entry("TR_176_2015-08-01",176),
map:entry("TR_177_2016-01-01",177),
map:entry("TR_178_2013-01-01",178),
map:entry("TR_179_2016-08-01",179),
map:entry("TR_180_2016-08-01",180),
map:entry("TR_181_2016-09-01",181),
map:entry("TR_181_2017-01-01",181),
map:entry("TR_181_2018-09-18",181),
map:entry("TR_182_2014-01-01",182),
map:entry("TR_183_2016-01-01",183),
map:entry("TR_184_2017-01-01",184),
map:entry("TR_185_2017-01-01",185),
map:entry("TR_186_2017-01-01",186),
map:entry("TR_187_2017-01-01",187),
map:entry("TR_188_2017-01-01",188),
map:entry("TR_189_2017-01-01",189),
map:entry("TR_19_2013-01-01",19),
map:entry("TR_190_2017-01-01",190),
map:entry("TR_191_2017-01-01",191),
map:entry("TR_192_2017-01-01",192),
map:entry("TR_193_2017-01-01",193),
map:entry("TR_194_2017-01-01",194),
map:entry("TR_195_2017-01-01",195),
map:entry("TR_196_2017-01-01",196),
map:entry("TR_197_2017-01-01",197),
map:entry("TR_198_2017-01-01",198),
map:entry("TR_199_2017-01-01",199),
map:entry("TR_20_2013-01-01",20),
map:entry("TR_200_2017-01-01",200),
map:entry("TR_201_2017-01-01",201),
map:entry("TR_202_2017-01-01",202),
map:entry("TR_203_2017-01-01",203),
map:entry("TR_204_2017-01-01",204),
map:entry("TR_205_2017-01-01",205),
map:entry("TR_206_2017-01-01",206),
map:entry("TR_207_2017-01-01",207),
map:entry("TR_208_2017-01-01",208),
map:entry("TR_209_2017-01-01",209),
map:entry("TR_21_2013-01-01",21),
map:entry("TR_210_2017-01-01",210),
map:entry("TR_211_2017-01-01",211),
map:entry("TR_212_2017-01-01",212),
map:entry("TR_213_2017-01-01",213),
map:entry("TR_214_2017-01-01",214),
map:entry("TR_215_2017-01-01",215),
map:entry("TR_216_2017-01-01",216),
map:entry("TR_217_2017-01-01",217),
map:entry("TR_218_2017-01-01",218),
map:entry("TR_219_2017-01-01",219),
map:entry("TR_22_2013-01-01",22),
map:entry("TR_220_2017-01-01",220),
map:entry("TR_221_2017-01-01",221),
map:entry("TR_222_2017-01-01",222),
map:entry("TR_223_2017-01-01",223),
map:entry("TR_224_2017-01-01",224),
map:entry("TR_225_2017-01-01",225),
map:entry("TR_226_2017-01-01",226),
map:entry("TR_227_2017-01-01",227),
map:entry("TR_228_2017-01-01",228),
map:entry("TR_229_2017-01-01",229),
map:entry("TR_23_2012-10-01",23),
map:entry("TR_230_2017-01-01",230),
map:entry("TR_231_2017-01-01",231),
map:entry("TR_232_2017-01-01",232),
map:entry("TR_233_2017-01-01",233),
map:entry("TR_234_2017-01-01",234),
map:entry("TR_235_2017-01-01",235),
map:entry("TR_236_2017-01-01",236),
map:entry("TR_237_2017-01-01",237),
map:entry("TR_238_2017-01-01",238),
map:entry("TR_239_2017-01-01",239),
map:entry("TR_24_2012-01-01",24),
map:entry("TR_240_2017-01-01",240),
map:entry("TR_241_2017-01-01",241),
map:entry("TR_242_2017-01-01",242),
map:entry("TR_243_2017-01-01",243),
map:entry("TR_244_2017-01-01",244),
map:entry("TR_245_2017-01-01",245),
map:entry("TR_246_2017-01-01",246),
map:entry("TR_247_2017-01-01",247),
map:entry("TR_248_2017-01-01",248),
map:entry("TR_249_2017-01-01",249),
map:entry("TR_25_2013-01-01",25),
map:entry("TR_250_2017-01-01",250),
map:entry("TR_251_2017-01-01",251),
map:entry("TR_252_2017-01-01",252),
map:entry("TR_253_2017-01-01",253),
map:entry("TR_254_2017-01-01",254),
map:entry("TR_255_2017-01-01",255),
map:entry("TR_256_2017-01-01",256),
map:entry("TR_257_2017-01-01",257),
map:entry("TR_258_2017-01-01",258),
map:entry("TR_259_2017-01-01",259),
map:entry("TR_26_2013-01-01",26),
map:entry("TR_260_2017-01-01",260),
map:entry("TR_261_2017-01-01",261),
map:entry("TR_262_2017-01-01",262),
map:entry("TR_263_2017-01-01",263),
map:entry("TR_264_2017-01-01",264),
map:entry("TR_265_2017-01-01",265),
map:entry("TR_266_2017-01-01",266),
map:entry("TR_267_2017-01-01",267),
map:entry("TR_268_2017-01-01",268),
map:entry("TR_269_2017-01-01",269),
map:entry("TR_27_2013-01-01",27),
map:entry("TR_270_2017-01-01",270),
map:entry("TR_271_2017-01-01",271),
map:entry("TR_272_2017-01-01",272),
map:entry("TR_273_2017-01-01",273),
map:entry("TR_274_2017-01-01",274),
map:entry("TR_275_2017-01-01",275),
map:entry("TR_276_2017-01-01",276),
map:entry("TR_277_2017-01-01",277),
map:entry("TR_278_2017-01-01",278),
map:entry("TR_279_2017-01-01",279),
map:entry("TR_28_2013-01-01",28),
map:entry("TR_280_2017-01-01",280),
map:entry("TR_281_2017-01-01",281),
map:entry("TR_282_2017-01-01",282),
map:entry("TR_283_2017-01-01",283),
map:entry("TR_284_2017-01-01",284),
map:entry("TR_285_2017-01-01",285),
map:entry("TR_287_2017-06-01",287),
map:entry("TR_288_2017-06-01",288),
map:entry("TR_289_2017-01-01",289),
map:entry("TR_29_2013-01-01",29),
map:entry("TR_290_2017-01-01",290),
map:entry("TR_291_2017-10-01",291),
map:entry("TR_292_2017-10-01",292),
map:entry("TR_293_2017-10-01",293),
map:entry("TR_294_2017-10-01",294),
map:entry("TR_295_2017-11-01",295),
map:entry("TR_296_2017-11-01",296),
map:entry("TR_30_2013-01-01",30),
map:entry("TR_31_2013-01-01",31),
map:entry("TR_32_2013-01-01",32),
map:entry("TR_34_2013-04-01",34),
map:entry("TR_35_2013-04-01",35),
map:entry("TR_36_2013-04-01",36),
map:entry("TR_37_2013-04-01",37),
map:entry("TR_38_2013-04-01",38),
map:entry("TR_39_2013-04-01",39),
map:entry("TR_4_2013-01-01",4),
map:entry("TR_40_2013-04-01",40),
map:entry("TR_41_2013-04-01",41),
map:entry("TR_42_2013-04-01",42),
map:entry("TR_43_2013-01-01",43),
map:entry("TR_45_2013-03-01",45),
map:entry("TR_46_2013-01-01",46),
map:entry("TR_49_2013-05-22",49),
map:entry("TR_5_2013-01-01",5),
map:entry("TR_50_2013-01-01",50),
map:entry("TR_51_2013-01-01",51),
map:entry("TR_52_2014-01-01",52),
map:entry("TR_53_2014-01-01",53),
map:entry("TR_54_2014-01-01",54),
map:entry("TR_55_2013-09-01",55),
map:entry("TR_56_2013-09-01",56),
map:entry("TR_58_2013-01-01",58),
map:entry("TR_6_2013-01-01",6),
map:entry("TR_60_2013-01-01",60),
map:entry("TR_62_2014-01-01",62),
map:entry("TR_62_2018-09-18",62),
map:entry("TR_63_2014-04-01",63),
map:entry("TR_63_2018-09-18",63),
map:entry("TR_64_2014-01-01",64),
map:entry("TR_64_2018-09-18",64),
map:entry("TR_65_2014-01-01",65),
map:entry("TR_65_2018-09-18",65),
map:entry("TR_66_2014-01-01",66),
map:entry("TR_66_2018-09-18",66),
map:entry("TR_67_2014-01-01",67),
map:entry("TR_67_2018-09-18",67),
map:entry("TR_68_2014-01-01",68),
map:entry("TR_68_2018-09-18",68),
map:entry("TR_69_2014-01-01",69),
map:entry("TR_69_2018-09-18",69),
map:entry("TR_7_2013-01-01",7),
map:entry("TR_70_2014-01-01",70),
map:entry("TR_70_2018-09-18",70),
map:entry("TR_71_2014-01-01",71),
map:entry("TR_71_2018-09-18",71),
map:entry("TR_72_2014-01-01",72),
map:entry("TR_72_2018-09-18",72),
map:entry("TR_73_2014-01-01",73),
map:entry("TR_73_2018-09-18",73),
map:entry("TR_74_2014-01-01",74),
map:entry("TR_74_2018-09-18",74),
map:entry("TR_75_2014-01-01",75),
map:entry("TR_75_2018-09-18",75),
map:entry("TR_77_2014-01-01",77),
map:entry("TR_78_2014-01-01",78),
map:entry("TR_8_2013-01-01",8),
map:entry("TR_80_2014-01-01",80),
map:entry("TR_81_2014-01-01",81),
map:entry("TR_82_2014-01-01",82),
map:entry("TR_83_2014-01-01",83),
map:entry("TR_84_2014-08-01",84),
map:entry("TR_85_2014-01-01",85),
map:entry("TR_86_2014-12-01",86),
map:entry("TR_87_2014-12-01",87),
map:entry("TR_88_2015-01-01",88),
map:entry("TR_89_2015-01-01",89),
map:entry("TR_9_2013-01-01",9),
map:entry("TR_90_2015-01-01",90),
map:entry("TR_91_2015-01-01",91),
map:entry("TR_92_2015-01-01",92),
map:entry("TR_93_2015-01-01",93),
map:entry("TR_94_2015-01-01",94),
map:entry("TR_95_2015-01-01",95),
map:entry("TR_96_2014-12-11",96),
map:entry("TR_97_2014-12-11",97),
map:entry("TR_98_2014-12-11",98),
map:entry("TR_99_2014-12-11",99),
map:entry("TR_99_2015-08-01",99),
map:entry("TUKI_hospitaldepartment_2016-01-01","V2"),
map:entry("TULE_hospitaldepartment_2005-01-01",17),
map:entry("TUTK_hospitaldepartment_1997-01-01","JV2"),
map:entry("UNI_1_2018-10-01",1),
map:entry("UNI_T1_2019-01-01","T1"),
map:entry("uta-tohjelma-1703","DPEDU"),
map:entry("uta-tohjelma-1712","DPII"),
map:entry("uta-tohjelma-1714","DPIT"),
map:entry("uta-tohjelma-1743","DPLS"),
map:entry("uta-tohjelma-1756","DPCMT"),
map:entry("uta-tohjelma-1762","DPHS"),
map:entry("uta-tohjelma-1763","DPHM"),
map:entry("uta-tohjelma-1765","DPEPH"),
map:entry("uta-tohjelma-1781","DPHI"),
map:entry("uta-tohjelma-1782","DPPL"),
map:entry("uta-tohjelma-1783","DPYT"),
map:entry("uta-tohjelma-1788","DPPH"),
map:entry("VALS_hospitaldivision_1994-01-01",8),
map:entry("VAS_hospitaldivision_1994-01-01",7),
map:entry("VETO_hospitaldepartment_2019-01-01",47),
map:entry("VKS_hospital_2009-01-01","JS9"),
map:entry("VKS01_hospitaldepartment_2009-01-01","JV100"),
map:entry("VPSY_hospitaldepartment_2003-01-01","JV39"),
map:entry("VSHP_hospitaldistrict_2009-01-01","VSHP"),
map:entry("VSHP01_hospitaldepartment_2009-01-01","JV101"),
map:entry("VSHP02_hospitaldepartment_2009-01-01","JV102"),
map:entry("VSHP03_hospitaldepartment_2009-01-01","JV103"),
map:entry("VSHP04_hospitaldepartment_2009-01-01","JV104"),
map:entry("VSHP05_hospitaldepartment_2009-01-01","JV105"),
map:entry("VSHP06_hospitaldepartment_2009-01-01","JV106"),
map:entry("VSHP07_hospitaldepartment_2009-01-01","JV107"),
map:entry("VSHP08_hospitaldepartment_2009-01-01","JV108"),
map:entry("VSHP09_hospitaldepartment_2009-01-01","JV109"),
map:entry("VSHP10_hospitaldepartment_2009-01-01","JV110"),
map:entry("VSHP11_hospitaldepartment_2009-01-01","JV130"),
map:entry("VVS_hospital_2008-01-01","JS10"),
map:entry("VVS01_hospitaldepartment_2008-01-01","JV111"),
map:entry("YHTH_hospitaldivision_1994-01-01",9),
map:entry("YLHV_hospitaldepartment_2005-01-01","9B"),
map:entry("YLLA_hospitaldepartment_2009-01-01",99),
map:entry("YPTH01_hospitaldepartment_2009-01-01","novalue")
))

let $selected:=
<Julkaisut>{
for $record in //records/*
  let $publication_year:=
  if (max($record//publicationDate/year) eq 2021) then
    min($record//publicationDate/year) 
    else (max($record//publicationDate/year))
  
  let $title:=string-join(($record/title,$record/subTitle), " : ")
  
  let $language_code:=substring-before(substring-after($record/language/@uri,'/dk/atira/pure/core/languages/'),"_")
  
  let $language:=
    if(string-length($language_code) eq 2) then
    <JulkaisunKieliKoodi> {
    substring-before(substring-after($record/language/@uri,'/dk/atira/pure/core/languages/'),"_")
    }</JulkaisunKieliKoodi>
  
  let $publication_country:=
    if ($record//keywordGroup[@logicalName="CountryOfPublishing"]) then
    <JulkaisumaaKoodi>{substring-after($record//keywordGroup[@logicalName="CountryOfPublishing"]//structuredKeyword/@uri,"/dk/atira/pure/researchoutput/countryofpublishing/")}</JulkaisumaaKoodi>
 
  
  let $statgroups:=
  <TieteenalaKoodit>{
    for $uri in $record//keywordGroup[@logicalName="ResearchoutputFieldOfScienceStatisticsFinland"]//structuredKeyword/@uri
      count $c
      let $code:=replace(replace(substring-after($uri,"/dk/atira/pure/keywords/fieldofsciencestatisticsfinland"),"fieldofsciencestatisticsfinland",""),"/","")
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
    for $org in distinct-values($record/personAssociations/personAssociation/person[@externalIdSource="synchronisedUnifiedPerson"]/../organisationalUnits/organisationalUnit[@externalIdSource="synchronisedUnifiedOrganisation" and type[term/text contains text {"Laitos","Hallinto","Sairaalan vastuualue"} any]]/@externalId)
    
    return if ($organisations($org)) then 
    <YksikkoKoodi>{$organisations($org)}</YksikkoKoodi>
    else(
       <YksikkoKoodi>{$org || "-missing-org-number"}</YksikkoKoodi>
    )
}</JulkaisunOrgYksikot>

  
  let $open_access:= <AvoinSaatavuusKoodi>{
    if ($record//structuredKeyword/@uri="/dk/atira/pure/researchoutput/openaccesspublication/1") then
    '1'
    else if ($record//structuredKeyword/@uri="/dk/atira/pure/researchoutput/openaccesspublication/0") then
    '0'
    else if ($record//structuredKeyword/@uri="/dk/atira/pure/researchoutput/openaccesspublication/2") then
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
     if (string-length($record/publicationSeries/publicationSerie[last()]/name) > 1) then
      <LehdenNimi>{data($record/publicationSeries/publicationSerie[last()]/name)}</LehdenNimi>
    else if (string-length($record/journalAssociation)>1) then
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
    
  let $self_archived_status:= substring-after($record//keywordGroup[@logicalName="SelfArchivedPublication"]/keywordContainers/keywordContainer[1]/structuredKeyword/@uri,"/dk/atira/pure/researchoutput/selfarchivedpublication/")
  
  let $self_archived_switch:=
    if($self_archived_status contains text {"0","1"} any ) then
  <RinnakkaistallennettuKytkin>{substring-after($record//keywordGroup[@logicalName="SelfArchivedPublication"]/keywordContainers/keywordContainer[1]/structuredKeyword/@uri,"/dk/atira/pure/researchoutput/selfarchivedpublication/")}</RinnakkaistallennettuKytkin>
  
  let $self_archived_content:= if(contains($self_archived_status,"1")) then
  <Rinnakkaistallennettu>
    <RinnakkaistallennusOsoiteTeksti>{data($record//electronicVersion[accessType/@uri contains text {'/dk/atira/pure/core/openaccesspermission/embargoed','/dk/atira/pure/core/openaccesspermission/open'} any]/link)}</RinnakkaistallennusOsoiteTeksti>
  </Rinnakkaistallennettu>
  
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
    
   
    
    

where $publication_year > 2019 and $record/workflow/@workflowStep="validated" and $okm_class contains text {'A1', 'A2', 'A3', 'A4', 'B1', 'B2', 'B3', 'C1', 'C2', 'D1', 'D2', 'D3', 'D4', 'D5', 'D6', 'E1', 'E2', 'E3', 'F1', 'F2', 'F3', 'G4', 'G5'} any
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
  {$language}
  {$open_access}
  {$company_collab}
  {$self_archived_switch}
  {$self_archived_content}
  {$doi}
  {$permanent_url}
  <LahdetietokannanTunnus>Scopus:85043780753</LahdetietokannanTunnus>
  {$internal_authors}
  </Julkaisu>
}</Julkaisut>

return file:write("/Users/ccmala/Documents/2021/pure-dataload/tunicris-to-virta.xml",$selected)