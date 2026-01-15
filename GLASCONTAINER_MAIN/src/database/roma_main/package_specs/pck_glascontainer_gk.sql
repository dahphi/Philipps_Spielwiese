create or replace package roma_main.pck_glascontainer_gk as
    type t_auftragsdaten_gk is record (
            uuid                           varchar2(4000 char),
            vkz                            varchar2(4000 char),
            kundennummer                   varchar2(4000 char),
            promotion                      varchar2(4000 char),
            router_auswahl                 varchar2(4000 char),
            router_eigentum                varchar2(4000 char),
            ont_provider                   varchar2(4000 char),
            installationsservice           varchar2(4000 char),
            haus_anschlusspreis            varchar2(4000 char),
            mandant                        varchar2(4000 char),
            firmenname                     varchar2(4000 char),
            anrede                         varchar2(4000 char),
            titel                          varchar2(4000 char),
            vorname                        varchar2(4000 char),
            nachname                       varchar2(4000 char),
            geburtsdatum                   date,
            email                          varchar2(4000 char),
            wohndauer                      varchar2(4000 char),
            laendervorwahl                 varchar2(4000 char),
            vorwahl                        varchar2(4000 char),
            telefon                        varchar2(4000 char),
            providerwechsel                varchar2(4000 char),
            providerw_aktueller_anbieter   varchar2(4000 char),
            providerw_anmeldung_anrede     varchar2(4000 char),
            providerw_anmeldung_nachname   varchar2(4000 char),
            providerw_anmeldung_vorname    varchar2(4000 char),
            providerw_nummer_behalten      varchar2(4000 char),
            providerw_laendervorwahl       varchar2(4000 char),
            providerw_vorwahl              varchar2(4000 char),
            providerw_telefon              varchar2(4000 char)  
    ------------------------------------------ 
            ,
            kontoinhaber                   varchar2(4000 char),
            sepa                           varchar2(4000 char),
            iban                           varchar2(4000 char),
            anschluss_str                  varchar2(4000 char),
            anschluss_hnr_kompl            varchar2(4000 char),
            anschluss_gebaeudeteil         varchar2(4000 char),
            anschluss_plz                  varchar2(4000 char),
            anschluss_ort_kompl            varchar2(4000 char),
            anschluss_land                 varchar2(4000 char),
            anschluss_adresse_kompl        varchar2(4000 char),
            voradresse_strasse             varchar2(4000 char),
            voradresse_hausnr              varchar2(4000 char),
            voradresse_zusatz              varchar2(4000 char),
            voradresse_plz                 varchar2(4000 char),
            voradresse_ort                 varchar2(4000 char),
            voradresse_land                varchar2(4000 char)  
    ---------------------------------------- 
            ,
            haus_lfd_nr                    varchar2(4000 char),
            gee_rolle                      varchar2(4000 char),
            anzahl_we                      varchar2(4000 char),
            vermieter_rechtsform           varchar2(4000 char),
            vermieter_firmenname           varchar2(4000 char),
            vermieter_anrede               varchar2(4000 char),
            vermieter_titel                varchar2(4000 char),
            vermieter_vorname              varchar2(4000 char),
            vermieter_nachname             varchar2(4000 char),
            vermieter_strasse              varchar2(4000 char),
            vermieter_hausnr               varchar2(4000 char),
            vermieter_plz                  varchar2(4000 char),
            vermieter_ort                  varchar2(4000 char),
            vermieter_zusatz               varchar2(4000 char),
            vermieter_land                 varchar2(4000 char),
            vermieter_email                varchar2(4000 char),
            vermieter_laendervorwahl       varchar2(4000 char),
            vermieter_vorwahl              varchar2(4000 char),
            vermieter_telefon              varchar2(4000 char),
            vermieter_einverstaendnis      varchar2(4000 char),
            bestaetigung_vzf               varchar2(4000 char),
            zustimmung_agb                 varchar2(4000 char),
            zustimmung_widerruf            varchar2(4000 char),
            opt_in_email                   varchar2(4000 char),
            opt_in_telefon                 varchar2(4000 char),
            opt_in_sms_mms                 varchar2(4000 char),
            opt_in_post                    varchar2(4000 char),
            vertragszusammenfassung        varchar2(4000 char),
            status                         varchar2(4000 char),
            customer_upd_email             varchar2(4000 char),
            is_new_customer                varchar2(4000 char),
            created                        date,
            last_modified                  date,
            version                        integer,
            changed_by                     varchar2(4000 char),
            process_lock                   varchar2(4000 char),
            process_lock_last_modified     date,
            storno_username                varchar2(4000 char),
            storno_grund                   varchar2(4000 char),
            storno_datum                   date,
            siebel_order_number            varchar2(4000 char),
            siebel_order_rowid             varchar2(4000 char),
            siebel_ready                   varchar2(4000 char),
            service_plus_email             varchar2(4000 char),
            wholebuy_partner               varchar2(4000 char),
            manual_transfer                varchar2(4000 char),
            technology                     varchar2(4000 char),
            connectivity_id                varchar2(4000 char),
            storno_kosten                  varchar2(4000 char),
            rt_contact_data_ticket_id      varchar2(4000 char),
            rt_contact_data_ticket_link    varchar2(4000 char),
            landlord_information_required  varchar2(4000 char),
            customer_upd_phone_countrycode varchar2(4000 char),
            customer_upd_phone_areacode    varchar2(4000 char),
            customer_upd_phone_number      varchar2(4000 char),
            update_customer_in_siebel      varchar2(4000 char),
            home_id                        varchar2(4000 char),
            account_id                     varchar2(4000 char),
            availability_date              date,
            customer_status                varchar2(4000 char),
            router_shipping                varchar2(4000 char)    
   -----------------
            ,
            business_unit                  varchar2(4000 char),
            sub_customer_number            varchar2(4000 char),
            created_by                     varchar2(4000 char)
   -----------------
            ,
            cpc_siebel_rowid               varchar2(4000 char),
            cpc_salutation                 varchar2(4000 char),
            cpc_first_name                 varchar2(4000 char),
            cpc_last_name                  varchar2(4000 char),
            cpc_email                      varchar2(4000 char),
            cpc_landline_countrycode       varchar2(4000 char),
            cpc_landline_areacode          varchar2(4000 char),
            cpc_landline_number            varchar2(4000 char),
            cpc_mobile_countrycode         varchar2(4000 char),
            cpc_mobile_areacode            varchar2(4000 char),
            cpc_mobile_number              varchar2(4000 char)
   -----------------
            ,
            tcp_siebel_rowid               varchar2(4000 char),
            tcp_salutation                 varchar2(4000 char),
            tcp_first_name                 varchar2(4000 char),
            tcp_last_name                  varchar2(4000 char),
            tcp_email                      varchar2(4000 char),
            tcp_landline_countrycode       varchar2(4000 char),
            tcp_landline_areacode          varchar2(4000 char),
            tcp_landline_number            varchar2(4000 char),
            tcp_mobile_countrycode         varchar2(4000 char),
            tcp_mobile_areacode            varchar2(4000 char),
            tcp_mobile_number              varchar2(4000 char)
   -----------------
            ,
            cfi_siebel_rowid               varchar2(4000 char),
            cfi_salutation                 varchar2(4000 char),
            cfi_first_name                 varchar2(4000 char),
            cfi_last_name                  varchar2(4000 char),
            cfi_email                      varchar2(4000 char),
            cfi_landline_countrycode       varchar2(4000 char),
            cfi_landline_areacode          varchar2(4000 char),
            cfi_landline_number            varchar2(4000 char),
            cfi_mobile_countrycode         varchar2(4000 char),
            cfi_mobile_areacode            varchar2(4000 char),
            cfi_mobile_number              varchar2(4000 char)
    );
    e_order_is_locked exception;
    c_order_is_locked constant integer := -20003;
    c_ws_modus_online_and_offline constant varchar2(30) := 'ONLINE_AND_OFFLINE';
    c_ws_modus_online constant varchar2(30) := 'ONLINE';
    c_ws_modus_offline constant varchar2(30) := 'OFFLINE'; -- hierbei sind Bearbeitungen im Glascontainer immer unterbunden

    c_ws_key_preorders_get constant core.params.pv_key2%type := 'PREORDERS_GET';
    c_ws_orderid_token constant core.params.v_wert2%type := '{orderId}'; 

  -- Maximale Länge eines ENUM-Auflistungstyps: 
    subtype t_enum is varchar2(50) not null; 
  
  -- Konstanten, die mit den ENUMs des Webservice korrespondieren: 
    enum_anrede_maennlich constant t_enum := 'MISTER';
    enum_anrede_weiblich constant t_enum := 'MISS';
    enum_devicecategory_byod constant t_enum := 'BYOD';
    enum_devicecategory_basic constant t_enum := 'BASIC'; -- neu @ticket FTTH-3546, @ticket FTTH-3562
    enum_devicecategory_premium constant t_enum := 'PREMIUM';
    enum_deviceownership_buy constant t_enum := 'BUY';
    enum_deviceownership_rent constant t_enum := 'RENT';
    enum_installationsservice_none constant t_enum := 'NONE';
    enum_installationsservice_netstart constant t_enum := 'NETSTART';
    enum_installationsservice_netstart_plus constant t_enum := 'NETSTART_PLUS';
    enum_wholebuy_key_telekom constant t_enum := 'TCOM';
    enum_wholebuy_key_deutsche_glasfaser constant t_enum := 'DG';
    enum_wholebuy_key_unbekannt constant t_enum := '?';

  -- Auftragsstatus.
  -- Neue Statuswerte müssen in der Function CHK_STATUS hinzugefügt werden:
    status_created constant t_enum := 'CREATED';
    status_in_review constant t_enum := 'IN_REVIEW';
    status_siebel_processed constant t_enum := 'SIEBEL_PROCESSED';
    status_cancelled constant t_enum := 'CANCELLED';
    status_clearing_landlord_data constant t_enum := 'CLEARING_LANDLORD_DATA'; -- neu 2024-05: Vermieterdaten liegen nicht vor
    status_clearing_wb_abbm constant t_enum := 'CLEARING_WB_ABBM'; -- neu 2025-04-09 @ticket FTTH-4719

    enum_wohndauer_no_resident constant t_enum := 'NO_RESIDENT';
    enum_wohndauer_weniger_als_6m constant t_enum := 'RESIDENT_LESS_THAN_SIX_MONTHS';
    enum_wohndauer_6m_oder_mehr constant t_enum := 'RESIDENT_SIX_OR_MORE_MONTHS';
    enum_anzahl_we_one constant t_enum := 'ONE';
    enum_anzahl_we_more_than_one constant t_enum := 'MORE_THAN_ONE'; 
  -- zur Verwendung mit utPLSQL 

    n_a constant varchar2(3) := 'n/a'; -- Synonym für "es wurde kein Wert geliefert",  
  -- z.B. bei der Anreichung der Auftragsdaten mit Daten aus Siebel. 
  -- Siehe auch Trigger auf Tabelle FTTH_WS_SYNC_PREORDERS (dort wird derselbe 
  -- String verwendet, aber ohne Bezug auf dieses Package, da sonst der 
  -- Trigger überflüssigerweise ein komplettes Package instanziieren müsste 
  

--------------------------------------------------------------------------------

  /** 
  * 
  */
    function f_show_kontakt_tcom (
        pi_wb_partner varchar2
    ) return boolean;

--------------------------------------------------------------------------------

  /** 
  * 
  */
    function f_show_kontakt_dg (
        pi_wb_partner varchar2
    ) return boolean;

--------------------------------------------------------------------------------

  /** 
  * 
  */
    function f_has_contact (
        pi_knd_nr in varchar2
    ) return boolean;

--------------------------------------------------------------------------------

  /** 
  * 
  */
    procedure get_first_contact_details (
        pi_knd_nr                in varchar2,
        po_ap_row_id             out varchar2,
        po_anrede                out varchar2,
        po_titel                 out varchar2,
        po_vorname               out varchar2,
        po_nachname              out varchar2,
        po_phone_number          out varchar2,
        po_mobile_number         out varchar2,
        po_ap_email              out varchar2,
        po_rolle                 out varchar2,
        po_ap_x_fix_phon_country out varchar2,
        po_ap_x_fix_phon_onkz    out varchar2,
        po_ap_x_fix_phon_nr      out varchar2,
        po_ap_mobil_onkz         out varchar2,
        po_ap_mobil_country      out varchar2,
        po_ap_x_mobil_nr         out varchar2
    );

--------------------------------------------------------------------------------

  /** 
  * Liest die aktuellsten Daten eines Auftrags vom Webservice ein und verteilt die 
  * Informationen auf die OUT-Felder. 
  * 
  * @param piv_uuid                  PK des Auftrags 
  * @param piv_ws_modus              ONLINE_AND_OFFLINE: Die Prozedur versucht zunächst, die Daten live vom Webservice 
  *                                  zu holen; wenn dieser nicht verfügbar ist, versucht die Prozedur, 
  *                                  die Daten ersatzweise aus der Tabelle FTTH_WS_SYNC_PREORDERS zu holen. 
  *                                  ONLINE: Wenn der Webservice zur Zeit des Aufrufs nicht verfügbar ist, 
  *                                  dann wirft diese Prozedur eine Exception.  
  *                                  OFFLINE: Die Prozedur greift ausschließlich auf die Tabelle FTTH_WS_SYNC_PREORDERS zu, 
  *                                  ohne den Webservice vorher abzufragen. 
  * @param pib_synchronize           TRUE: Die Prozedur schreibt die gerade empfangenen 
  *                                  Daten in die Tabelle FTTH_WS_SYNC_PREORDERS, damit im Fall 
  *                                  einer späteren Nichtverfügbarkeit dieser Datensatz möglichst 
  *                                  aktuell von dort gelesen werden kann; außerdem wird die aktuelle STRAV-Adresse
  *                                  in die Puffertabelle POB_ADRESSEN geschrieben
  *                                  FALSE: Die Tabellen FTTH_WS_SYNC_PREORDERS und POB_ADRESSEN werden nicht aktualisiert 
  * @param pib_show_json             (optional, Default = FALSE) Wenn auf '1' gesetzt, dann liefert jeder GET-Aufruf  
  *                                  gegen den PreOrder-Buffer außerdem den kompletten JSON-Payload in pov_json_payload zurück.  
  *                                  Nur sinnvoll für Debugging-Zwecke, da ansonsten der zusätzliche Traffic die  
  *                                  Ausführungszeit negativ beeinflusst. 
  * @param pov_display_kopfdaten     Einzeiliger Text mit den bestimmenden Auftragsfeldern in Kurzform 
  * @param poc_json_payload          (optional): Das originale JSON des Auftrags kann hier zurückgeliefert werden, 
  *                                  insbesondere nützlich beim Entwickeln und Debuggen 
  * 
  * @date 2022-11-23: Bei Bestandskunden werden Vorname, Nachname aus Siebel sowie Adresse aus STRAV angereichert 
  */
    procedure p_get_auftragsdaten (
        piv_uuid             in varchar2,
        piv_ws_modus         in varchar2 -- ONLINE|ONLINE_AND_OFFLINE|OFFLINE war: pib_read_sync_on_ws_error 
        ,
        pib_synchronize      in boolean,
        pib_show_json        in boolean default false 
    --------------------------------------------- 
        ,
        pon_sqlcode          out integer,
        pov_sqlerrm          out varchar2,
        poc_json_payload     out clob 
    --------------------------------------------- 
        ,
        pov_auftragsdaten_gk out t_auftragsdaten_gk
    ); 

  /** 
   * Parst das JSON eines einzelnen Auftrags (vom Webservice preorder/id) 
   * und gibt die einzelnen Felder an die OUT-Parameter zurück 
   * 
   * @param pic_preorder_json [IN ]  JSON-Repräsenation eines Auftrags 
   * 
   * @usage Anzeige von Auftragsdaten in APEX 
   */
    procedure parse_preorder (
        pic_preorder_json    in clob,
        pov_auftragsdaten_gk out t_auftragsdaten_gk
    ); 
    
  /** 
   * Gibt einen JSON Timestamp-String als DATE zurück, indem auf Sekunden gekürzt wird 
   * 
   * @param i_timestamp [IN ]  Literaler Timestamp aus JSON, z.B. "2022-09-21T09:41:58.602Z" 
   */
    function fd_json_timestamp (
        i_timestamp in varchar2
    ) return date
        deterministic; 
    
  /** 
   * Gibt einen JSON Timestamp-String als DATE zurück, indem auf Sekunden gekürzt wird 
   * 
   * @param i_timestamp [IN ]  Literaler Timestamp aus JSON, z.B. "2022-09-21T09:41:58.602Z" 
   */
    function fv_auftragsdaten_gk_warning (
        piv_uuid             in varchar2,
        piv_status           in varchar2,
        piv_customer_status  in varchar2,
        piv_ws_errorcode     in varchar2,
        piv_error_message    in varchar2,
        piv_wholebuy_partner in varchar2,
        piv_checks           in varchar2,
        pov_alert_type       out varchar2
    ) return varchar2;

    function fv_new_connectivity_id (
        piv_uuid            in varchar2,
        piv_connectivity_id in varchar2,
        piv_app_user        in varchar2
    ) return varchar2;

end pck_glascontainer_gk;
/


-- sqlcl_snapshot {"hash":"3dc3153601326b6c6ca301284f7024c6abda1630","type":"PACKAGE_SPEC","name":"PCK_GLASCONTAINER_GK","schemaName":"ROMA_MAIN","sxml":""}