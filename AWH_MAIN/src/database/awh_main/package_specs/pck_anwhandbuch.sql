create or replace package awh_main.pck_anwhandbuch as 

  -------------------------------------------------------------------------------------------------------------------------------   
  --
  -- Types
  --
  -------------------------------------------------------------------------------------------------------------------------------   
  /** */
    type tpersonrecord is record (
            adshort   varchar2(50),
            name      varchar2(1000),
            email     varchar2(255),
            telefon   varchar2(100),
            bereich   varchar2(1000),
            gruppe    varchar2(1000),
            buero     varchar2(1000),
            abteilung varchar2(1000)
    );
  /** */
    type terhebungsbogenrecord is record (
            asy_lfd_nr  number,
            erh_lfd_nr  number,
            erh_datum   date,
            ausf_person varchar2(36)
    );
  /** */
    type terhebungsbogen1record is record (
            asy_lfd_nr          number,
            eb1_lfd_nr          number,
            eb1_inakt_persdata  number,
            eb1_verarb_persdata number,
            eb1_name_anschrift  varchar2(4000),
            link_zum_anhang     varchar2(400),
            eb1_loeschkonzept   number
    );
  /** */
    type terhebungsbogen2record is record (
            asy_lfd_nr                number,
            eb2_lfd_nr                number,
            eb2_zweck_persdaten       varchar2(4000),
            eb2_spezialgesetz_regel   varchar2(4000),
            eb2_einwilligung          varchar2(4000),
            eb2_kollektivvereinbarung varchar2(4000),
            eb2_beschaeftigung        varchar2(4000),
            eb2_vertragsanbahnung     varchar2(4000),
            eb2_interessenabwaegung   varchar2(4000)
    );
  /** */
    type terhebungsbogen5record is record (
            asy_lfd_nr            number,
            eb5_lfd_nr            number,
            eb5_internestelle_dwi varchar2(1000),
            eb5_artdaten_dwi      varchar2(1000),
            eb5_zweck_dwi         varchar2(1000),
            eb5_externestelle_dwe varchar2(1000),
            eb5_artdaten_dwe      varchar2(1000),
            eb5_zweck_dwe         varchar2(1000),
            eb5_staat_dws         varchar2(1000),
            eb5_artdaten_dws      varchar2(1000),
            eb5_zweck_dws         varchar2(1000),
            eb5_user              varchar2(100)
    );

  /** */
    type terhebungsbogen6record is record (
            asy_lfd_nr            number,
            eb6_lfd_nr            number,
            eb6_aufbewloeschfrist varchar2(4000),
            eb6_loeschregeln      varchar2(4000),
            eb6_user              varchar2(100)
    );

  /** */
    type terhebungsbogen8_1record is record (
            asy_lfd_nr          number,
            eb8_1_lfd_nr        number,
            eb8_1_prozerlangung varchar2(4000),
            eb8_1_user          varchar2(100)
    );

  /** */
    type terhebungsbogen9record is record (
            asy_lfd_nr                     number,
            eb9_lfd_nr                     number,
            eb9_ds_itsicherheit_grund      varchar2(4000 byte),
            eb9_risikoanalyse_erfolgt      number,
            eb9_massnahmen_sicherheitskonz number,
            eb9_anonym_pseudonym           varchar2(4000 byte),
            eb9_verschluesselung           varchar2(4000 byte),
            eb9_backup                     varchar2(4000 byte),
            eb9_redundantedaten            varchar2(4000 byte),
            eb9_verfuegbarkeit             varchar2(4000 byte),
            eb9_integritaet                varchar2(4000 byte),
            eb9_vertraulichkeit            varchar2(4000 byte),
            eb9_schutzderrechte            varchar2(4000 byte),
            eb9_protokollierung            varchar2(4000 byte),
            eb9_pruefung_abstaende         varchar2(4000 byte),
            eb9_user                       varchar2(100)
    );

  /** */
    type terhebungsbogen10record is record (
            asy_lfd_nr              number,
            eb10_lfd_nr             number,
            eb10_export_stand_form  number,
            eb10_exp_stand_format   varchar2(4000 byte),
            eb10_exp_stand_zeitraum varchar2(4000 byte),
            eb10_user               varchar2(100 byte)
    );

  /** */
    type terhebungsbogen11record is record (
            asy_lfd_nr                 number,
            eb11_lfd_nr                number,
            eb11_satz_pers_daten       clob,
            eb11_nakodv_form           varchar2(2000 byte),
            eb11_nakodv_zeitpunkt      varchar2(1000 byte),
            eb11_kodsb_form            varchar2(2000 byte),
            eb11_kodsb_zeitpunkt       varchar2(1000 byte),
            eb11_zweckrecht_form       varchar2(2000 byte),
            eb11_zweckrecht_zeitpunkt  varchar2(1000 byte),
            eb11_empfkat_form          varchar2(2000 byte),
            eb11_empfkat_zeitpunkt     varchar2(1000 byte),
            eb11_dauerpers_form        varchar2(2000 byte),
            eb11_dauerpers_zeitpunkt   varchar2(1000 byte),
            eb11_widerspruch_form      varchar2(2000 byte),
            eb11_widerspruch_zeitpunkt varchar2(1000 byte),
            eb11_einrueck_form         varchar2(2000 byte),
            eb11_einrueck_zeitpunkt    varchar2(1000 byte),
            eb11_beschrecht_form       varchar2(2000 byte),
            eb11_beschrecht_zeitpunkt  varchar2(1000 byte),
            eb11_infobereit_form       varchar2(2000 byte),
            eb11_infobereit_zeitpunkt  varchar2(1000 byte),
            eb11_wwkomplsatz           varchar2(4000 byte),
            eb11_user                  varchar2(100 byte)
    );

  /** */
    type terhebungsbogen12record is record (
            asy_lfd_nr                 number,
            eb12_lfd_nr                number,
            eb12_voreinstellungen_auto number,
            eb12_ve_auto_erlaeuterung  varchar2(4000 byte),
            eb12_user                  varchar2(100 byte)
    );

  /** */
    type tbefuellungsgradrecord is record (
            bef_lfd_nr    number,
            beg_lfd_nr    number,
            asy_lfd_nr    number,
            bef_kommentar varchar2(4000 byte)
    );

  /** */
    type terhbeurteilungrecord is record (
            ekb_lfd_nr         number,
            asy_lfd_nr         number,
            ebu_lfd_nr_kap_sys number,
            ebu_lfd_nr_kap_1   number,
            ebu_lfd_nr_kap_2   number,
            ebu_lfd_nr_kap_3   number,
            ebu_lfd_nr_kap_4   number,
            ebu_lfd_nr_kap_5   number,
            ebu_lfd_nr_kap_6   number,
            ebu_lfd_nr_kap_7   number,
            ebu_lfd_nr_kap_8   number,
            ebu_lfd_nr_kap_9   number,
            ebu_lfd_nr_kap_10  number,
            ebu_lfd_nr_kap_11  number,
            ebu_lfd_nr_kap_12  number
    );

  /** */
    type tinsbeurteilungrecord is record (
            isb_lfd_nr     number,
            asy_lfd_nr     number,
            ebu_lfd_nr_eck number,
            ebu_lfd_nr_kri number,
            ebu_lfd_nr_zus number,
            ebu_lfd_nr_shz number,
            ebu_lfd_nr_ris number,
            ebu_lfd_nr_tas number,
            ebu_lfd_nr_zul number,
            ebu_lfd_nr_rev number
    );

  /** */
    type tstatusrecord is record (
            ebu_lfd_nr number,
            ebu_name   varchar2(200)
    );

  /** */
    type tprozbefuellungsgradrecord is record (
            pbf_lfd_nr    number,
            pro_lfd_nr    number,
            beg_lfd_nr    number,
            pbf_kommentar varchar2(4000 byte)
    );

  /** */
    type tprozerhbeurteilungrecord is record (
            pkb_lfd_nr         number,
            pro_lfd_nr         number,
            ebu_lfd_nr_kap_alg number,
            ebu_lfd_nr_kap_1   number,
            ebu_lfd_nr_kap_2   number,
            ebu_lfd_nr_kap_3   number,
            ebu_lfd_nr_kap_4   number,
            ebu_lfd_nr_kap_5   number,
            ebu_lfd_nr_kap_6   number,
            ebu_lfd_nr_kap_7   number,
            ebu_lfd_nr_kap_8   number,
            ebu_lfd_nr_kap_9   number,
            ebu_lfd_nr_kap_10  number,
            ebu_lfd_nr_kap_11  number
    );

  /** */
    type tprozerhebungsbogenrecord is record (
            ape_lfd_nr    number,
            pro_lfd_nr    number,
            pro_name      varchar2(100),
            ape_timestamp timestamp
    );

  /** */
    type tprozerheb1record is record (
            pro_lfd_nr         number,
            ap1_verant_stelle  varchar2(500),
            per_lfd_nr_ges_ver varchar2(36),
            per_lfd_nr_vertr   varchar2(36),
            per_lfd_nr_ds      varchar2(36)
    );

  /** */
    type tprozerheb2record is record (
            pro_lfd_nr              number,
            ap2_verarb_taet         varchar2(4000),
            ap2_proz_ebene          varchar2(4000),
            ap2_dat_einf            date,
            ap2_ueber_gp            varchar2(4000),
            per_lfd_nr_verant_ap    varchar2(36),
            per_lfd_nr_verant_fuehr varchar2(36)
    );  

  /** */
    type tprozerheb3record is record (
            pro_lfd_nr                 number,
            ap3_zweckbestimmung        varchar2(4000 byte),
            ap3_vertrag_erbringung     number,
            ap3_besch_verh             number,
            ap3_einkaufsvertrag        number,
            ap3_beratervertrag         number,
            ap3_sonstiges              varchar2(4000 byte),
            ap3_verarb_vorvertrag_mass varchar2(4000 byte),
            ap3_verarb_recht_ver       varchar2(4000 byte),
            ap3_verarb_wahrn_auf       varchar2(4000 byte),
            ap3_verarb_berech_int      varchar2(4000 byte),
            ap3_einwill_verarb         varchar2(4000 byte),
            ap3_einwill_nachweise      number,
            ap3_sonstige               varchar2(4000 byte),
            ap3_risiko                 number
    );  

  /** */
    type tprozerheb8record is record (
            pro_lfd_nr       number,
            ap8_aufbewahrung varchar2(4000 byte),
            ap8_lf_95        number,
            ap8_lf_loeschkon number,
            ap8_lf_sonst     varchar2(4000 byte)
    );  

  /** */
    type tprozerheb10record is record (
            pro_lfd_nr          number,
            ap10_verw_tom       number,
            ap10_verf_reg_ueb   number,
            ap10_datenschutzanw number,
            ap10_sonst          varchar2(4000 byte)
    );  

  /** */
    type tpperson is
        table of tpersonrecord;
    type tperhebungsbogen is
        table of terhebungsbogenrecord;
    type tperhebungsbogen1 is
        table of terhebungsbogen1record;
    type tperhebungsbogen2 is
        table of terhebungsbogen2record;
    type tperhebungsbogen5 is
        table of terhebungsbogen5record;
    type tperhebungsbogen6 is
        table of terhebungsbogen6record;
    type tperhebungsbogen8_1 is
        table of terhebungsbogen8_1record;
    type tperhebungsbogen9 is
        table of terhebungsbogen9record;
    type tperhebungsbogen10 is
        table of terhebungsbogen10record;
    type tperhebungsbogen11 is
        table of terhebungsbogen11record;
    type tperhebungsbogen12 is
        table of terhebungsbogen12record;
    type tpbefuellungsgrad is
        table of tbefuellungsgradrecord;
    type tperhebungsbogenbeurteilung is
        table of terhbeurteilungrecord;
    type tpinfosecbeurteilung is
        table of tinsbeurteilungrecord;
    type tpstatus is
        table of tstatusrecord;
    type tpprozerhebungbeurteilung is
        table of tprozerhbeurteilungrecord;
    type tpprozbefuellungsgrad is
        table of tprozbefuellungsgradrecord;
    type tpprozerhebungsbogen is
        table of tprozerhebungsbogenrecord;
    type tpprozerheb1 is
        table of tprozerheb1record;
    type tpprozerheb2 is
        table of tprozerheb2record;
    type tpprozerheb3 is
        table of tprozerheb3record;
    type tpprozerheb8 is
        table of tprozerheb8record;
    type tpprozerheb10 is
        table of tprozerheb10record;  

  -------------------------------------------------------------------------------------------------------------------------------   
  --
  -- Basistabellen
  --
  -------------------------------------------------------------------------------------------------------------------------------   

  /** Ersetzt durch CORE.members
  PROCEDURE PRC_FILL_TAB_PERSON_SHORT; 
  PROCEDURE PRC_UPDATE_TAB_PERSON;

  FUNCTION FKT_PERSON_BY_AD(PI_VC_ADSHORT VARCHAR2) RETURN tpPerson PIPELINED;*/

  -------------------------------------------------------------------------------------------------------------------------------   
  --
  -- Systeme
  --
  -------------------------------------------------------------------------------------------------------------------------------   

  /**   Diese Prozedur aktualisiert die Daten NUMBER:ASY_AKTIV und DATE:ASY_EINFUEHRUNG 
        in der Tabelle AWH_SYSTEM für eine spezifische Systemnummer NUMBER(PK):ASY_LFD_NR.*/
    procedure prc_update_system_aktiv_eingef (
        pi_n_asy_lfd_nr   number,
        pi_dt_eingefuehrt date
    );

  /**   Diese Funktion soll die ASY_LFD_NR, ERH_LFD_NR,PER_LFD_NR_AUSF_PER,ERH_DATUM aus 
        der Tabelle AWH_ERHEBUNGSBOGEN für eine bestimmte ASY_LFD_NR abrufen und als Tabelle wiedergeben. */
    function fkt_get_erhebungsbogen (
        pi_n_asy_lfd_nr number
    ) return tperhebungsbogen
        pipelined;

  /**   Diese Prozedur aktualisiert die Daten NUMBER:ASY_AKTIV und DATE:ASY_EINFUEHRUNG 
        in der Tabelle AWH_SYSTEM für eine spezifische Systemnummer NUMBER(PK):ASY_LFD_NR.*/
    procedure prc_set_erhebungsbogen (
        pi_n_asy_lfd_nr   number,
        pi_n_erh_lfd_nr   number,
        pi_vc_ausf_person varchar2,
        pi_dt_erh_datum   date,
        pi_vc_erh_user    varchar2
    );

  /** */
    function fkt_get_erhebungsbogen_1 (
        pi_n_asy_lfd_nr number
    ) return tperhebungsbogen1
        pipelined;

  /** */
    procedure prc_set_erhebungsbogen_1 (
        pi_n_asy_lfd_nr          number,
        pi_n_eb1_lfd_nr          number,
        pi_n_eb1_inakt_persdata  number,
        pi_n_eb1_verarb_persdata number,
        pi_vc_eb1_name_anschrift varchar2,
        pi_vc_link_zum_anhang    varchar2,
        pi_n_eb1_loeschkonzept   number,
        pi_vc_eb1_user           varchar2
    );

  /** */
    function fkt_get_erhebungsbogen_2 (
        pi_n_asy_lfd_nr number
    ) return tperhebungsbogen2
        pipelined;

  /** */
    procedure prc_set_erhebungsbogen_2 (
        pi_n_asy_lfd_nr               number,
        pi_n_eb2_lfd_nr               number,
        pi_vc_eb2_zweck_persdaten     varchar2,
        pi_vc_eb2_spezialgesetz_regel varchar2,
        pi_vc_eb2_einwilligung        varchar2,
        pi_vc_eb2_kollektivverei      varchar2,
        pi_vc_eb2_beschaeftigung      varchar2,
        pi_vc_eb2_vertragsanbahnung   varchar2,
        pi_vc_eb2_interessenabwaegung varchar2,
        pi_vc_eb2_user                varchar2
    );

  /** */
    function fkt_get_erhebungsbogen_5 (
        pi_n_asy_lfd_nr number
    ) return tperhebungsbogen5
        pipelined;

  /** */
    procedure prc_set_erhebungsbogen_5 (
        pi_n_asy_lfd_nr             number,
        pi_n_eb5_lfd_nr             number,
        pi_vc_eb5_internestelle_dwi varchar2,
        pi_vc_eb5_artdaten_dwi      varchar2,
        pi_vc_eb5_zweck_dwi         varchar2,
        pi_vc_eb5_externestelle_dwe varchar2,
        pi_vc_eb5_artdaten_dwe      varchar2,
        pi_vc_eb5_zweck_dwe         varchar2,
        pi_vc_eb5_staat_dws         varchar2,
        pi_vc_eb5_artdaten_dws      varchar2,
        pi_vc_eb5_zweck_dws         varchar2,
        pi_vc_eb5_user              varchar2
    );

  /** */
    function fkt_get_erhebungsbogen_6 (
        pi_n_asy_lfd_nr number
    ) return tperhebungsbogen6
        pipelined;

  /** */
    procedure prc_set_erhebungsbogen_6 (
        pi_n_asy_lfd_nr             number,
        pi_n_eb6_lfd_nr             number,
        pi_vc_eb6_aufbewloeschfrist varchar2,
        pi_vc_eb6_loeschregeln      varchar2,
        pi_vc_eb6_user              varchar2
    );

  /** */
    function fkt_get_erhebungsbogen_9 (
        pi_n_asy_lfd_nr number
    ) return tperhebungsbogen9
        pipelined;

  /** */
    procedure prc_set_erhebungsbogen_9 (
        pi_n_asy_lfd_nr                number,
        pi_n_eb9_lfd_nr                number,
        pi_vc_eb9_ds_itsicherheit_grun varchar2,
        pi_vc_eb9_risikoanalyse_erfolg varchar2,
        pi_vc_eb9_massnahmen_sichkonz  varchar2,
        pi_vc_eb9_anonym_pseudonym     varchar2,
        pi_vc_eb9_backup               varchar2,
        pi_vc_eb9_redundantedaten      varchar2,
        pi_vc_eb9_schutzderrechte      varchar2,
        pi_vc_eb9_protokollierung      varchar2,
        pi_vc_eb9_pruefung_abstaende   varchar2,
        pi_vc_eb9_user                 varchar2
    );                                    

  /** Abspeichern der Informationen über die Datenfolgeabschätzung für ein bestimmtes System AWH_SYSTEM.ASY_LFD_NR*/
    procedure prc_set_erhebungsbogen_9_dfa (
        pi_n_asy_lfd_nr         number,
        pi_vc_e9d_link_schw_dfa varchar2,
        pi_vc_e9d_link_dfa      varchar2,
        pi_vc_e9d_schw          varchar2,
        pi_vc_e9d_user          varchar2
    );  

  /** */
    function fkt_get_erhebungsbogen_11 (
        pi_n_asy_lfd_nr number
    ) return tperhebungsbogen11
        pipelined;

  /** */
    procedure prc_set_erhebungsbogen_11 (
        pi_n_asy_lfd_nr                number,
        pi_n_eb11_lfd_nr               number,
        pi_cl_eb11_satz_pers_daten     clob,
        pi_vc_eb11_nakodv_form         varchar2,
        pi_vc_eb11_nakodv_zeitpunkt    varchar2,
        pi_vc_eb11_kodsb_form          varchar2,
        pi_vc_eb11_kodsb_zeitpunkt     varchar2,
        pi_vc_eb11_zweckrecht_form     varchar2,
        pi_vc_eb11_zweckrecht_zp       varchar2,
        pi_vc_eb11_empfkat_form        varchar2,
        pi_vc_eb11_empfkat_zeitpunkt   varchar2,
        pi_vc_eb11_dauerpers_form      varchar2,
        pi_vc_eb11_dauerpers_zeitpunkt varchar2,
        pi_vc_eb11_widerspruch_form    varchar2,
        pi_vc_eb11_widerspruch_zp      varchar2,
        pi_vc_eb11_einrueck_form       varchar2,
        pi_vc_eb11_einrueck_zeitpunkt  varchar2,
        pi_vc_eb11_beschrecht_form     varchar2,
        pi_vc_eb11_beschrecht_zp       varchar2,
        pi_vc_eb11_infobereit_form     varchar2,
        pi_vc_eb11_infobereit_zp       varchar2,
        pi_vc_eb11_wwkomplsatz         varchar2,
        pi_vc_eb11_user                varchar2
    );

  /** */
    function fkt_get_erhebungsbogen_12 (
        pi_n_asy_lfd_nr number
    ) return tperhebungsbogen12
        pipelined;

  /** */
    procedure prc_set_erhebungsbogen_12 (
        pi_n_asy_lfd_nr        number,
        pi_n_eb12_lfd_nr       number,
        pi_n_eb12_ve_auto      number,
        pi_vc_eb12_ve_auto_erl varchar2,
        pi_vc_eb12_user        varchar2
    );

  /** */
    function fkt_get_befuellungsgrad (
        pi_n_asy_lfd_nr number
    ) return tpbefuellungsgrad
        pipelined;

  /** */
    procedure prc_set_befuellungsgrad (
        pi_n_asy_lfd_nr number,
        pi_n_beg_lfd_nr number
    );


  /** Diese Funktion so anhand des Wertes PI_VC_ANK_FUNK und PI_N_ASY_LFD_NR erkennen ob min. eine
        Funktionsklasse eines bestimmten Systems (anhand der ASY_LFD_NR) Kritis-relevant ist 
        und diese Info weitergeben. Aktuell muss nur ausgegeben werden ob ein System Kritis-relvant ist
        und nicht welches jeweils relevant ist. Leider bekomme ich die Funktion nicht richtig hin, 
        mir fehlt wohl etwas am Ende. Wurde temporär gelöst über den Abruf auf Seite 50 Tabelle 
        Systeme / Inventare Source für ANLAGENKATEGORIE und FUNKTIONSKLASSE.*/
  /*FUNCTION FKT_GET_ANLAGENKAT_TEXT(PI_N_ASY_LFD_NR                         NUMBER,
                                   PI_VC_ANK_FUNK                          VARCHAR2) RETURN VARCHAR2;--*/
  /** */
    procedure prc_set_infosec_anlagenkat (
        pi_n_asy_lfd_nr number,
        pi_vc_ank_kat3  varchar2,
        pi_vc_ank_funk  varchar2,
        pi_vc_app_user  varchar2
    );

  /** */
    procedure prc_set_hosts_und_cluster (
        pi_n_asy_lfd_nr  number,
        pi_vc_vvg_gvb    varchar2,
        pi_vc_vvg_vms    varchar2,
        pi_vc_vvg_geraet varchar2,
        pi_vc_vvg_elgrt  varchar2,
        pi_vc_vvg_infclu varchar2,
        pi_vc_vvg_was    varchar2,
        pi_vc_app_user   varchar2
    );       

  /** */
    procedure prc_set_awh_system (
        pi_n_asy_lfd_nr      number,
        pi_vc_asy_name       varchar2,
        pi_vc_asy_funktion   varchar2,
        pi_vc_asy_abgrenzung varchar2,
        pi_vc_asy_kommentar  varchar2,
        pi_vc_asy_aufrufpfad varchar2,
        pi_d_asy_einfuehrung date,
        pi_vc_asy_user       varchar2,
        pi_n_asy_aktiv       number,
        pi_fbz_uid           number,
        pi_fbk_uid           number,
        pi_fie_uid           number,
        pi_akt_uid           number
    );

  /** Aktualisierung des Feld AWH_SYSTEM."ASY_FUNKTION" mit den Daten aus PI_VC_ASY_FUNKTION
  wo die ASY_LFD_NR mit der von der Funktion übergebenen PI_N_ASY_LFD_NR übereinstimmt.*/
    procedure prc_set_awh_system_only_funk (
        pi_n_asy_lfd_nr    number,
        pi_vc_asy_funktion varchar2,
        pi_vc_asy_user     varchar2
    );

  /** */
    procedure prc_set_infosec_zul_nutzung (
        pi_n_asy_lfd_nr          number,
        pi_n_zdf_lfd_nr          number,
        pi_vc_zul_referenz_regel varchar2,
        pi_n_zul_kennzeichnung   number,
        pi_vc_zul_user           varchar2
    );

  /** */
    procedure prc_set_infosec_eb7_hersteller (
        pi_n_asy_lfd_nr      number,
        pi_vc_eb7_hersteller varchar2,
        pi_vc_eb7_user       varchar2
    );

  /** */
    procedure prc_set_infosec_tom_vt (
        pi_n_asy_lfd_nr    number,
        pi_n_trv_lfd_nr    number,
        pi_n_sov_lfd_nr    number,
        pi_vc_tvt_zugsteu  varchar2,
        pi_n_tvt_berechtko number,
        pi_n_tvt_rollen    number,
        pi_n_tvt_einerolle number,
        pi_vc_tvt_zugverw  number,
        pi_n_ere_lfd_nr    number,
        pi_vc_tvt_user     varchar2
    );

  /** */
    procedure prc_set_infosec_tom_in (
        pi_n_asy_lfd_nr     number,
        pi_vc_tin_kontrolle number,
        pi_n_adt_lfd_nr     number,
        pi_n_chm_lfd_nr     number,
        pi_vc_tin_user      varchar2
    );

  /** */
    procedure prc_set_infosec_tom_vf (
        pi_n_asy_lfd_nr number,
        pi_n_zet_lfd_nr number,
        pi_n_ueb_lfd_nr number,
        pi_n_asf_lfd_nr number,
        pi_vc_tvf_user  varchar2
    );

  /** */
    procedure prc_set_infosec_tom_at (
        pi_n_asy_lfd_nr number,
        pi_n_mfa_lfd_nr number,
        pi_vc_tat_user  varchar2
    );



  /** */
    procedure prc_set_infosec_comp (
        pi_n_asy_lfd_nr      number,
        pi_n_cop_dsgvo       number,
        pi_n_cop_betrvg      number,
        pi_n_cop_kritisv     number,
        pi_vc_cop_elem_infra varchar2,
        pi_vc_cop_user       varchar2
    );

  /** */
    procedure prc_set_infosec_geschaeftskritisch (
        pi_n_asy_lfd_nr number,
        pi_n_gek_lfd_nr number,
        pi_vc_gks_user  varchar2
    );

  /** */
    procedure prc_set_infosec_tom_handbuch (
        pi_n_asy_lfd_nr        number,
        pi_vc_hnb_patch_chng   varchar2,
        pi_vc_hnb_zugangsverw  varchar2,
        pi_vc_hnb_wiederanlauf varchar2,
        pi_vc_hnb_buch1        varchar2,
        pi_vc_hnb_buch2        varchar2,
        pi_vc_hnb_buch3        varchar2,
        pi_vc_hnb_buch4        varchar2,
        pi_vc_hnb_buch5        varchar2
    );                                          
  -------------------------------------------------------------------------------------------------------------------------------   
  --
  -- Prozesse
  --
  -------------------------------------------------------------------------------------------------------------------------------   

  /** */
    function fkt_get_proz_befuellungsgrad (
        pi_n_pro_lfd_nr number
    ) return tpprozbefuellungsgrad
        pipelined;

  /** */
    procedure prc_set_proz_befuellungsgrad (
        pi_n_pro_lfd_nr     number,
        pi_n_beg_lfd_nr     number,
        pi_vc_pbf_kommentar varchar2
    );

  /** */
    function fkt_get_proz_befuellungsbeu (
        pi_n_pro_lfd_nr number
    ) return tpprozerhebungbeurteilung
        pipelined;

  /** */
    procedure prc_set_proz_bef_beu (
        pi_n_pro_lfd_nr number,
        pi_n_kapitel    number,
        pi_n_ebu_lfd_nr number
    );

  /** */
    function fkt_get_proz_erhebungsbogen (
        pi_n_pro_lfd_nr number
    ) return tpprozerhebungsbogen
        pipelined;

  /** */
    procedure prc_set_proz_erhebungsbogen (
        pi_n_pro_lfd_nr number,
        pi_vc_ape_user  varchar2
    );

  /** */
    function fkt_get_proz_erheb_1 (
        pi_n_pro_lfd_nr number
    ) return tpprozerheb1
        pipelined;

  /** */
    procedure prc_set_proz_erheb_1 (
        pi_n_pro_lfd_nr         number,
        pi_vc_ap1_verant_stelle varchar2,
        pi_n_per_lfd_nr_ges_ver varchar2,
        pi_n_per_lfd_nr_vertr   varchar2,
        pi_n_per_lfd_nr_ds      varchar2,
        pi_vc_ap1_user          varchar2
    );

  /** */
    function fkt_get_proz_erheb_2 (
        pi_n_pro_lfd_nr number
    ) return tpprozerheb2
        pipelined;

  /** */
    procedure prc_set_proz_erheb_2 (
        pi_n_pro_lfd_nr              number,
        pi_vc_ap2_verarb_taet        varchar2,
        pi_vc_ap2_proz_ebene         varchar2,
        pi_dt_ap2_dat_einf           date,
        pi_vc_ap2_ueber_gp           varchar2,
        pi_n_per_lfd_nr_verant_ap    varchar2,
        pi_n_per_lfd_nr_verant_fuehr varchar2,
        pi_vc_ap2_user               varchar2
    );

  /** */
    function fkt_get_proz_erheb_3 (
        pi_n_pro_lfd_nr number
    ) return tpprozerheb3
        pipelined;

  /** */
    procedure prc_set_proz_erheb_3 (
        pi_n_pro_lfd_nr               number,
        pi_vc_ap3_zweckbestimmung     varchar2,
        pi_n_ap3_vertrag_erbringung   number,
        pi_n_ap3_besch_verh           number,
        pi_n_ap3_einkaufsvertrag      number,
        pi_n_ap3_beratervertrag       number,
        pi_vc_ap3_sonstiges           varchar2,
        pi_vc_ap3_verarb_vorvert_mass varchar2,
        pi_vc_ap3_verarb_recht_ver    varchar2,
        pi_vc_ap3_verarb_wahrn_auf    varchar2,
        pi_vc_ap3_verarb_berech_int   varchar2,
        pi_vc_ap3_einwill_verarb      varchar2,
        pi_n_ap3_einwill_nachweise    number,
        pi_vc_ap3_sonstige            varchar2,
        pi_n_ap3_risiko               number,
        pi_vc_ap3_user                varchar2
    );                                 

  /** */
    function fkt_get_proz_erheb_8 (
        pi_n_pro_lfd_nr number
    ) return tpprozerheb8
        pipelined;

  /** */
    procedure prc_set_proz_erheb_8 (
        pi_n_pro_lfd_nr        number,
        pi_vc_ap8_aufbewahrung varchar2,
        pi_n_ap8_lf_95         number,
        pi_n_ap8_lf_loeschkon  number,
        pi_vc_ap8_lf_sonst     varchar2,
        pi_vc_ap8_user         varchar2
    );    

  /** */
    function fkt_get_proz_erheb_10 (
        pi_n_pro_lfd_nr number
    ) return tpprozerheb10
        pipelined;

  /** */
    procedure prc_set_proz_erheb_10 (
        pi_n_pro_lfd_nr          number,
        pi_n_ap10_verw_tom       number,
        pi_n_ap10_verf_reg_ueb   number,
        pi_n_ap10_datenschutzanw number,
        pi_vc_ap10_sonst         varchar2,
        pi_vc_ap10_user          varchar2
    ); 

  /** */
    function fkt_save_allowed (
        pi_n_asy_lfd_nr number,
        pi_vc_user      varchar2
    ) return number;       

  /** */
    function fkt_lock_allowed (
        pi_n_asy_lfd_nr number
    ) return number;       

  /** */
    procedure prc_set_lock (
        pi_n_asy_lfd_nr number,
        pi_vc_user      varchar2
    );

  /** */
    procedure prc_reset_lock (
        pi_n_asy_lfd_nr number,
        pi_vc_user      varchar2
    );

  /** */
    function fkt_proz_save_allowed (
        pi_n_pro_lfd_nr number,
        pi_vc_user      varchar2
    ) return number;       

  /** */
    function fkt_proz_lock_allowed (
        pi_n_pro_lfd_nr number
    ) return number;       

  /** */
    procedure prc_proz_set_lock (
        pi_n_pro_lfd_nr number,
        pi_vc_user      varchar2
    );

  /** */
    procedure prc_proz_reset_lock (
        pi_n_pro_lfd_nr number,
        pi_vc_user      varchar2
    );

  /** */
    procedure prc_copy_system (
        pi_n_src_asy_lfd_nr  number,
        pi_n_dest_asy_lfd_nr number
    );

  /** Diese Funktion benötigt das Kürzel eines Users (wie "concar") als Wert pi_vc_user und pi_vc_role benötigt den Wert Namen (cn)  einer AD-Gruppe. Beispiel: 
select 'ja' FROM DUAL WHERE 1 = PCK_AD_TOOLS.IS_USER_IN_ROLE_NESTED(PI_VC_USER => 'concar',PI_VC_ROLE => 
'ACO TEC ISMS'); erkennt, 
dass das Kürzel in der Gruppe ACO TEC ISMS ist, da der Nutzer über die Gruppe ACO TEC ISMS AL 
in der Gruppe hinterlegt wurde. Dementsprechend wird das Kürzel einmal gefunden und gibt die 1 aus. 
!!! Wird mit CORE.AD.IS_USER_IN_ROLE_NESTED ersetzt, wird aber temporär benötigt.!!!*/
    function is_user_in_role_nested (
        pi_vc_user varchar2,
        pi_vc_role varchar2
    ) return number;

        /**   Diese Prozedur fuegt einen neuen Datensatz in AWH_MTN_SYS_VM hinzu.
        die Prozedur wird in der ZAMPANO welt ausgeführt.*/
    procedure prc_insert_in_awh_mtn_sys_vm (
        pi_asy_lfd_nr   number,
        pi_vm_uid       number,
        pi_sv_user      varchar2,
        sv_sv_timestamp date
    );

    procedure prc_delete_in_awh_mtn_sys_vm (
        pi_vm_uid number
    );

    procedure prc_set_system_attribute (
        pi_asy_lfd_nr     number,
        pi_dat_bea_uid_fk number,
        pi_dat_kor_uid_fk number,
        pi_ges_uid_fk     number
    );

    procedure merge_awh_system_attribute (
        p_asy_lfd_nr        in number,
        p_dat_bea_uid_fk    in number default null,
        p_dat_kor_uid_fk    in number default null,
        p_ges_uid_fk        in number default null,
        p_avv_abgeschlossen in number default null
    );

end pck_anwhandbuch;
/


-- sqlcl_snapshot {"hash":"711d6894b9a66675ec71ddc64e6f2cf94ed0200d","type":"PACKAGE_SPEC","name":"PCK_ANWHANDBUCH","schemaName":"AWH_MAIN","sxml":""}