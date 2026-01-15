create or replace package body pck_glascontainer as 
/** 
 * Programmcode zur APEX-Anwendung 2022 "Glascontainer" 
 * 
 * @author Andreas Wismann (WISAND) <wismann@when-others.com> 
 *
 * @date    2025-01-08: Umgang mit Error 409, @ticket FTTH-4314
 * @date    2024-12-03  fixed: TOO_MANY_ROWS, da rtContactDataTicketId und connectivityId in Arrays aufgelistet sind
 *
 */ 


  -- Umlaut/Euro-Test: ÄÖÜäöüß/?

  -- Im Unterschied zu PCK_GLASCONTAINER.version ist die Version im PACKAGE BODY 
  -- meist höher (die informelle APEX-Abfrage auf Seite 2022:10050 ermittelt den  
  -- höheren der beiden Werte über die FUNCTION get_body_version) 
    body_version              constant varchar2(30) := '2025-06-11 1200'; 

  --TESTERROR                    CONSTANT INTEGER := -20999; -- darf bei Auslieferung nicht mehr deklariert sein

    db_name                   constant varchar2(30) := core.pck_env.fv_db_name;

  -- Bei TRUE finden keine echten Webservice-Calls statt, 
  -- sondern sie werden nur geloggt, so dass tatsächlich 
  -- keine Daten angefordert oder geändert werden. 

    -- Abfragen / DML gegen Siebel durchführen? Default: TRUE 
    g_use_siebel              boolean := true; -- @deprecated

    -- Abfragen gegen das STRAV-Schema durchführen? Default: TRUE 
    g_use_strav               boolean := true; 

  -- Befinden wir uns in der Entwicklungs- oder Testumgebung? 
    g_dev_or_test             constant boolean := db_name != 'NMC'; 

  -- /////@todo konsolidieren: Nicht verwendete Konstanten sind auskommentiert und sollten
  -- im Zuge von @ticket FTTH-4314 im Zweifel ins Package POB_REST verlagert werden.
    c_ws_method_get           constant ftth_webservice_aufrufe.method%type := 'GET'; 
  --  c_ws_method_put              CONSTANT ftth_webservice_aufrufe.method%TYPE := 'PUT'; 
  --  c_ws_method_post             CONSTANT ftth_webservice_aufrufe.method%TYPE := 'POST'; 
    c_ws_statuscode_ok        constant ftth_webservice_aufrufe.response_statuscode%type := '200'; -- Alles in Ordnung 
  --  c_ws_statuscode_bad_request  CONSTANT ftth_webservice_aufrufe.response_statuscode%TYPE := '400'; -- syntaktischer Fehler beim Aufruf 
  --  c_ws_statuscode_unauthorized CONSTANT ftth_webservice_aufrufe.response_statuscode%TYPE := '401'; -- 2022-12-12 Erstmals bei den Stornogründen aufgetreten 
    c_ws_statuscode_not_found constant ftth_webservice_aufrufe.response_statuscode%type := '404'; -- tritt sowohl auf, wenn man einen nicht mehr existierenden Auftrag aufruft 
  -- bestehende UUID aktualisiert, 
  -- als auch wenn der WS insgesamt offline ist 
  -- => ///@klären mit AOE, ob Ersteres änderbar ist 
  --  c_ws_statuscode_conflict     CONSTANT ftth_webservice_aufrufe.response_statuscode%TYPE := '409'; -- technisches Problem: Auftrag ist gesperrt (2022-09-14 auf [S]) 
  --  c_ws_statuscode_server_error CONSTANT ftth_webservice_aufrufe.response_statuscode%TYPE := '500'; -- Internal Server Error: nicht näher spezifierter Verarbeitungsfehler (z.B. nicht akzeptierte templateId) 
  --  c_ws_statuscode_bad_gateway  CONSTANT ftth_webservice_aufrufe.response_statuscode%TYPE := '502'; -- Bad Gateway, beispielsweise läuft der Webservice/Liquibase nicht (@Ticket FTTH-1872) 
  --  c_ws_statuscode_unavailable  CONSTANT ftth_webservice_aufrufe.response_statuscode%TYPE := '503'; -- Service Unavailable 

    e_ws_statuscode_not_found exception;
    pragma exception_init ( e_ws_statuscode_not_found, -20404 ); 

  -- Wallet, das bei jedem Webservice-Aufruf verwendet wird 
    c_ws_wallet_path          constant varchar2(100) := 'file:/oracle/app/oracle/wallet/'; 

  -- Wallet-Passwort, das bei jedem Webservice-Aufruf verwendet wird 
    c_ws_wallet_pwd           constant varchar2(100) := 'wbci2015'; 

  -- Zeit in Sekunden, die ein Webservice-Aufruf bereit ist zu warten (Oracle-Default: 180!) 
    c_ws_transfer_timeout     constant naturaln := 10; 

  -- Wird zum Erstellen eines JSON_OBJECT_T gebraucht 
    c_empty_json              constant varchar2(2) := '{}';
    json_true                 constant varchar2(5) := 'true';
    json_false                constant varchar2(5) := 'false'; 

    -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- Zum Einbau in den Quellcode, wenn nicht versäumt werden darf, eine bestimmte Stelle zu implementieren.
    -- Vor dem Ausliefern des Package beide Routinen testweise auskommentieren!
    procedure not_implemented (
        i_text in varchar2 := null
    ) is
    begin
        raise_application_error(-20000,
                                ltrim(i_text || ' nicht implementiert'));
    end;

    function not_implemented (
        i_text in varchar2 := null
    ) return varchar2 is
    begin
        raise_application_error(-20000,
                                ltrim(i_text || '  nicht implementiert'));
        return null;
    end;
    -----------------------------------------------------------------------------------------------------------------------------------------------------------------------

    function fv_http_statusmessage (
        i_statuscode in integer
    ) return varchar2
        deterministic
    is
    begin
        return 
            -- @ticket FTTH-538: 
            case i_statuscode
                when 200 then
                    'OK'
                when 400 then
                    'Kommunikations- oder Datenproblem mit dem Webserver'
                when 404 then
                    'Auftrag oder Service wurde nicht gefunden'
                when 409 then 
                  --  'Der Auftrag ist zur Zeit gesperrt' 
                  -- @ticket FTTH-4314:
                    'Ihr Auftrag wird gerade bearbeitet, wurde kürzlich storniert oder der aktuelle Status passt nicht zur geplanten Aktion. ' || 'Bitte versuchen Sie es später erneut'
                when 415 then
                    'Protokollfehler, z.B. unbekannter Medientyp' -- @ticket FTTH-1698 
                when 500 then
                    'Interner Serverfehler - bitte wenden Sie sich an den Anwendungs-Administrator'
                when 502 then
                    'Bad Gateway - bitte wenden Sie sich an den Anwendungs-Administrator'
                when 503 then
                    'Der Dienst ist momentan nicht verfügbar'
                else 'Webservice-Fehler, bitte wenden Sie sich an den Anwendungs-Administrator'
            end
            ||
            case
                when i_statuscode <> 409 -- Hier wird nie geloggt, demnach braucht auch kein Statuscode-Hinweis zu erfolgen
                 then
                    ' (Statuscode '
                    || i_statuscode
                    || ')'
            end
            || '.';
    end fv_http_statusmessage; 


  /** 
   * Aktiviert oder deaktiviert alle Abfragen gegen Siebel 
   * 
   * @param i_yes_no  Akzeptiert alle üblichen Strings, die "JA" bedeuten, 
   *                  andernfalls wird das Argument als "NEIN" interpretiert 
   * 
   * @usage  Kann bei Bedarf aus APEX heraus gesetzt werden, um beispielsweise 
   *         bei Problemen mit SIEBEL dessen Abfragen zu umgehen 
   */
    procedure use_siebel (
        i_yes_no in varchar2
    ) is
    begin
        g_use_siebel := nvl(
            upper(trim(i_yes_no)),
            'N'
        ) in ( '1', 'TRUE', 'Y', 'YES', 'J',
               'JA' );
    end; 

  /** 
   * Aktiviert oder deaktiviert alle Abfragen gegen das STRAV-Schema 
   * 
   * @param i_yes_no  Akzeptiert alle üblichen Strings, die "JA" bedeuten, 
   *                  andernfalls wird das Argument als "NEIN" interpretiert 
   * 
   * @usage  Kann bei Bedarf aus APEX heraus gesetzt werden, um beispielsweise 
   *         bei Problemen mit der STRAV deren Abfragen zu umgehen    
   */
    procedure use_strav (
        i_yes_no in varchar2
    ) is
    begin
        g_use_strav := nvl(
            upper(trim(i_yes_no)),
            'N'
        ) in ( '1', 'TRUE', 'Y', 'YES', 'J',
               'JA' );
    end;     

  /** 
  * Gibt den Versionsstring des Package Bodies zurück 
  */
    function get_body_version return varchar2
        deterministic
    is
    begin
        return body_version;
    end;     

  /** 
  * Formatiert jeden Routinen-Namen mit dem Prefix des Packages, damit in den LOGS 
  * die Suche nach dem Package-Namen im Fehlerfall einfacher wird 
  * 
  * @example 
  * SELECT * FROM LOGS WHERE ROUTINE_NAME LIKE 'PCK_GLASCONTAINER%' AND ... 
  */
    function qualified_name (
        i_routine_name in varchar2
    ) return varchar2
        deterministic
    is
    begin
        return $$plsql_unit
               || '.'
               || upper(i_routine_name);
    end; 

  /** 
  * Führt die Stornierung eines Auftrags gegen den Webservice aus 
  * 
  * @param piv_uuid        [IN ] ID des zu stornierenden Auftrags 
  * @param piv_stornogrund [IN ] Schlüssel für die fachliche Begründung der Stornierung (ENUM: cancellationReasons) 
  * @param piv_app_user    [IN ] 4- oder 6-stelliges Kürzel des APEX-Applikations-Users 
  * 
  * @raise Werden keine Exceptions geworfen, dann wurde die Stornierung 
  * erfolgreich an den Webservice übermittelt. Im Fehlerfall wird einer 
  * dieser Statuscodes geraised: 
  * -20400: Payload does not match expectations 
  * -20404: Order does not exist 
  * -20500: Something went wrong on the server side 
  * 
  * @usage Unter Umständen ist im Anschluss an diese Stornierung mit einer 
  * gewissen Verarbeitungsdauer zu rechnen (processLock). 
  */
    procedure p_auftrag_stornieren (
        piv_uuid        in ftth_ws_sync_preorders.id%type,
        piv_stornogrund in varchar2,
        piv_app_user    in varchar2
    ) is

        v_check_cancellation_reason enum.key%type;
        vc_body                     clob;
        plausi_msg_suffix           constant varchar2(100) := ' beim Versuch, einen Auftrag zu stornieren';
        v_ws_statuscode             integer;
        v_ws_response               clob;
        v_rest_error_message        varchar2(500 char);
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name             constant logs.routine_name%type := 'p_auftrag_stornieren';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_uuid', piv_uuid);
            pck_format.p_add('piv_stornogrund', piv_stornogrund);
            pck_format.p_add('piv_app_user', piv_app_user);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin 
    -- Validierung der Argumente 
        if piv_uuid is null then
            raise_application_error(c_plausi_error_number, 'Leere Order-ID' || plausi_msg_suffix);
        end if;
        if trim(piv_stornogrund) is null then
            raise_application_error(c_plausi_error_number, 'Fehlende Begründung' || plausi_msg_suffix);
        end if;

        if trim(piv_app_user) is null then
            raise_application_error(c_plausi_error_number, 'Fehlende Angabe des Usernamens' || plausi_msg_suffix);
        end if;

        if length(piv_app_user) > 6 then
            raise_application_error(c_plausi_error_number, 'Unerwartetes Format des Usernamens ("'
                                                           || piv_app_user
                                                           || '")'
                                                           || plausi_msg_suffix);
        end if; 
    -- Stornogrund überprüfen. Stand 2023-06 sind erlaubt: 
    -- CONTRACT_SUMMARY_NOT_APPROVED 
    -- BAD_SALES_INFO 
    -- ORDER_RESUBMITTED 
    -- FINAL_CANCELLATION 
    -- BAD_CREDIT_STANDING 
    -- REVOCATION 
    -- BUILDING_CABLE_SETUP 
    -- NO_REPLY 
    -- CONNECTION_NOT_POSSIBLE 
    -- DURATION_PROCESS 
    -- CONSTRUCTION_NOT_APPROVED 
    -- TEST_CONTRACT 
    -- DUPLICATE 

        select
            max(key)
        into v_check_cancellation_reason 
        -- @ticket FTTH-3840 //////@todo: Konsolidieren: Wird zukünftig ENUM oder FTTH_WS_SYNC_STORNOGRUENDE verwendet?
        from
            ftth_ws_sync_stornogruende -- 2023-06-28 nicht mehr: LOV_STORNOGRUND, also letztlich Tabelle ENUM, 
                                          -- denn der Webservice liefert ja bereits eine deutsche Bezeichnung für den Stornogrund. 
                                          -- Dessen Verfügbarkeit muss also sofort gewährleistet sein, nicht erst nach der erfolgten Übersetzung 
        where
            key = piv_stornogrund;

        if v_check_cancellation_reason is null then
            raise_application_error(c_plausi_error_number, 'Unbekannte Begründung für Storno: "'
                                                           || piv_stornogrund
                                                           || '"'
                                                           || plausi_msg_suffix);
        end if;

        vc_body := fj_preorders_cancel(
            piv_cancellation_reason => piv_stornogrund,
            piv_user                => piv_app_user
        ); 
        -- Webservice zum Stornieren aufrufen: 
        /**
        p_webservice_post( 
            piv_ws_key   => C_WS_KEY_PREORDERS_CANCEL 
          , piv_uuid     => piv_uuid 
          , piv_app_user => piv_app_user 
          , pic_body     => vc_body 
        ); 
        */ -- 2024-12-31 @ticket FTTH-4314 
        pck_pob_rest.p_webservice_post2(
            piv_kontext       => pck_pob_rest.kontext_preorderbuffer,
            piv_ws_key        => c_ws_key_preorders_cancel,
            piv_uuid          => piv_uuid,
            piv_app_user      => piv_app_user,
            pic_body          => vc_body 
          ---       
            ,
            pov_ws_statuscode => v_ws_statuscode,
            pov_ws_response   => v_ws_response
        ); 

        -- 2024-12-31 @ticket FTTH-4314: Status nun hier überprüfen anstatt schon im PCK_POB _REST:
        if v_ws_statuscode <> c_ws_statuscode_ok then -- REST-Antwort liefert Fehler:
            -- FTTH-4993 Statuscode neue Fehlermeldung ermitteln da alte allg. Fehlermeldung nicht ausreichend ist
            v_rest_error_message := pck_pob_rest.fv_get_error_message(piv_json_response => v_ws_response);
            if v_rest_error_message is null then
                v_rest_error_message := fv_http_statusmessage(v_ws_statuscode);
            end if;
            raise_application_error(-20000 - v_ws_statuscode, v_rest_error_message);
        end if;

    exception
        when pck_pob_rest.e_request_auftrag_gesperrt then
            raise; -- ohne Loggen gemäß @ticket FTTH-4314
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end p_auftrag_stornieren; 



  /** 
  * Liefert den für die nächste Synchronisierung gültigen Wert des Parameters 
  * lastModifiedWithinDays zurück 
  * 
  * @usage Üblicherweise wird der Parameter aus dem Wert der Konfigurationsvariablen 
  * LASTMODIFIEDWITHINDAYS (Tabelle PARAMS) ausgelesen, so wie er in der 
  * Glascontainer-App konfiguriert wurde. Jedoch ist es zwingend notwendig, 
  * nach einer Leerung der Synchronisationstabelle eine vollständige 
  * Synchronisierung zu erzwingen. 
  */
    function fn_last_modified_within_days return naturaln is

        v_days          natural;
        v_count_sync    natural; 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'fn_last_modified_within_days';

        function fcl_params return logs.message%type is
        begin
            return null; -- diese function besitzt keine Parameter 
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin 
    -- Wenn diese Funktion unmittelbar nach einer Leerung der Synchronisierungstabelle 
    -- aufgerufen wird, dann müssen als nächstes "sämtliche" Datensätze synchronisiert 
    -- werden. 
        select
            count(*)
        into v_count_sync
        from
            ftth_ws_sync_preorders;

        if v_count_sync = 0 -- man könnte auch < 100 nehmen, denn dann wäre ein 
    -- vollständiger Synchronlauf sowieso nicht langwierig 

         then
            return 20 * 365; -- reicht für 20 Jahre. @klären, was der Maximalwert ist bzw. was bei leerem Wert passiert. 
        end if;
        v_days := coalesce(to_number(pck_glascontainer.fv_konfiguration_lesen('WEBSERVICE', 'LASTMODIFIEDWITHINDAYS')),
                           365);

        return v_days;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end; 

  /** 
  * Nimmt ein JSON-Dokument vom Format des preorders-Webservices entgegen 
  * und liefert den Datensatz vom Zeilenyp FTTH_WS_SYNC_PREORDERS zurück 
  */
    function fr_preorder_from_json (
        piv_json in clob
    ) return ftth_ws_sync_preorders%rowtype is

        v_preorder              ftth_ws_sync_preorders%rowtype;
        v_dummy_providerwechsel varchar2(5); 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name         constant logs.routine_name%type := 'fr_preorder_from_json';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_json',
                             dbms_lob.substr(piv_json, 1000, 1));
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        parse_preorder(
            pic_preorder_json                  => piv_json 
                    ----------------------------------------------
            ,
            pov_uuid                           => v_preorder.id,
            pov_vkz                            => v_preorder.vkz,
            pov_kundennummer                   => v_preorder.customernumber,
            pov_promotion                      => v_preorder.templateid,
            pov_router_auswahl                 => v_preorder.devicecategory,
            pov_router_eigentum                => v_preorder.deviceownership,
            pov_ont_provider                   => v_preorder.ont_provider -- @ticket FTTH-3097 
            ,
            pov_installationsservice           => v_preorder.installationservice,
            pov_haus_anschlusspreis            => v_preorder.houseconnectionprice,
            pov_mandant                        => v_preorder.client,
            pov_firmenname                     => v_preorder.customer_businessname,
            pov_anrede                         => v_preorder.customer_salutation,
            pov_titel                          => v_preorder.customer_title,
            pov_vorname                        => v_preorder.customer_name_first,
            pov_nachname                       => v_preorder.customer_name_last,
            pod_geburtsdatum                   => v_preorder.customer_birthdate,
            pov_email                          => v_preorder.customer_email,
            pov_wohndauer                      => v_preorder.customer_residentstatus,
            pov_laendervorwahl                 => v_preorder.customer_phone_countrycode,
            pov_vorwahl                        => v_preorder.customer_phone_areacode,
            pov_telefon                        => v_preorder.customer_phone_number 
                -- ,pov_passwort                       => v_dummy_password -- entfernt 2025-01-21
            ,
            pov_providerwechsel                => v_dummy_providerwechsel,
            pov_providerw_aktueller_anbieter   => v_preorder.providerchg_current_provider,
            pov_providerw_anmeldung_anrede     => v_preorder.providerchg_owner_salutation,
            pov_providerw_anmeldung_nachname   => v_preorder.providerchg_owner_name_last,
            pov_providerw_anmeldung_vorname    => v_preorder.providerchg_owner_name_first,
            pov_providerw_nummer_behalten      => v_preorder.providerchg_keep_phone_number,
            pov_providerw_laendervorwahl       => v_preorder.providerchg_phone_countrycode,
            pov_providerw_vorwahl              => v_preorder.providerchg_phone_areacode,
            pov_providerw_telefon              => v_preorder.providerchg_phone_number,
            pov_kontoinhaber                   => v_preorder.account_holder,
            pov_sepa                           => v_preorder.account_sepamandate,
            pov_iban                           => v_preorder.account_iban,
            pov_voradresse_strasse             => v_preorder.customer_prev_addr_street,
            pov_voradresse_hausnr              => v_preorder.customer_prev_addr_housenumber,
            pov_voradresse_zusatz              => v_preorder.customer_prev_addr_addition,
            pov_voradresse_plz                 => v_preorder.customer_prev_addr_zipcode,
            pov_voradresse_ort                 => v_preorder.customer_prev_addr_city,
            pov_voradresse_land                => v_preorder.customer_prev_addr_country,
            pov_haus_lfd_nr                    => v_preorder.houseserialnumber,
            pov_gee_rolle                      => v_preorder.prop_owner_role,
            pov_anzahl_we                      => v_preorder.prop_residential_unit,
            pov_vermieter_rechtsform           => v_preorder.landlord_legalform,
            pov_vermieter_firmenname           => v_preorder.landlord_businessorname,
            pov_vermieter_anrede               => v_preorder.landlord_salutation,
            pov_vermieter_titel                => v_preorder.landlord_title,
            pov_vermieter_vorname              => v_preorder.landlord_name_first,
            pov_vermieter_nachname             => v_preorder.landlord_name_last,
            pov_vermieter_strasse              => v_preorder.landlord_addr_street,
            pov_vermieter_hausnr               => v_preorder.landlord_addr_housenumber,
            pov_vermieter_plz                  => v_preorder.landlord_addr_zipcode,
            pov_vermieter_ort                  => v_preorder.landlord_addr_city,
            pov_vermieter_zusatz               => v_preorder.landlord_addr_addition,
            pov_vermieter_land                 => v_preorder.landlord_addr_country,
            pov_vermieter_email                => v_preorder.landlord_email,
            pov_vermieter_laendervorwahl       => v_preorder.landlord_phone_countrycode,
            pov_vermieter_vorwahl              => v_preorder.landlord_phone_areacode,
            pov_vermieter_telefon              => v_preorder.landlord_phone_number,
            pov_vermieter_einverstaendnis      => v_preorder.landlord_agreed,
            pov_bestaetigung_vzf               => v_preorder.summ_precontractinformation,
            pov_zustimmung_agb                 => v_preorder.summ_generaltermsandconditions,
            pov_zustimmung_widerruf            => v_preorder.summ_waiverightofrevocation,
            pov_opt_in_email                   => v_preorder.summ_emailmarketing,
            pov_opt_in_telefon                 => v_preorder.summ_phonemarketing,
            pov_opt_in_sms_mms                 => v_preorder.summ_smsmmsmarketing,
            pov_opt_in_post                    => v_preorder.summ_mailmarketing,
            pov_vertragszusammenfassung        => v_preorder.summ_ordersummaryfileid,
            pov_status                         => v_preorder.state,
            pov_customer_upd_email             => v_preorder.customer_upd_email,
            pov_is_new_customer                => v_preorder.is_new_customer,
            pod_created                        => v_preorder.created,
            pod_last_modified                  => v_preorder.last_modified,
            pov_version                        => v_preorder.version,
            pov_changed_by                     => v_preorder.changed_by,
            pov_process_lock                   => v_preorder.process_lock,
            pod_process_lock_last_modified     => v_preorder.process_lock_last_modified,
            pov_storno_username                => v_preorder.cancelled_by,
            pov_storno_grund                   => v_preorder.cancel_reason,
            pod_storno_datum                   => v_preorder.cancel_date,
            pov_siebel_order_number            => v_preorder.siebel_order_number,
            pov_siebel_order_rowid             => v_preorder.siebel_order_rowid,
            pov_siebel_ready                   => v_preorder.siebel_ready,
            pov_service_plus_email             => v_preorder.service_plus_email -- @FTTH-5002
                   -- neu 2023-11-30: 
            ,
            pov_wholebuy_partner               => v_preorder.wholebuy_partner,
            pov_manual_transfer                => v_preorder.manual_transfer,
            pov_technology                     => v_preorder.technology -- neu 2024-07-09 @ticket FTTH-3747
                    -- neu 2024-08-21 @ticket FTTH-3727
            ,
            pov_connectivity_id                => v_preorder.connectivity_id,
            pov_rt_contact_data_ticket_id      => v_preorder.rt_contact_data_ticket_id,
            pov_landlord_information_required  => v_preorder.landlord_information_required
                   -- neu 2024-08-23 @ticket FTTH-3711:
            ,
            pov_customer_upd_phone_countrycode => v_preorder.customer_upd_phone_countrycode,
            pov_customer_upd_phone_areacode    => v_preorder.customer_upd_phone_areacode,
            pov_customer_upd_phone_number      => v_preorder.customer_upd_phone_number,
            pov_update_customer_in_siebel      => v_preorder.update_customer_in_siebel,
            pov_home_id                        => v_preorder.home_id -- @ticket FTTH-4134
            ,
            pov_account_id                     => v_preorder.account_id -- @ticket FTTH-4470
            ,
            pod_availability_date              => v_preorder.availability_date -- @ticket FTTH-3880
            ,
            pov_customer_status                => v_preorder.customer_status -- @ticket FTTH-5772
            ,
            pov_router_shipping                => v_preorder.router_shipping -- @ticket FTTH-6321
                   -- ... @SYNC#01
        );

        return v_preorder;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end fr_preorder_from_json; 

  /** 
  * Gibt einen JSON Timestamp-String als DATE zurück, indem auf Sekunden gekürzt wird 
  * 
  * @param i_timestamp [IN ] Literaler Timestamp aus JSON, z.B. "2022-09-21T09:41:58.602Z" 
  */
    function fd_json_timestamp (
        i_timestamp in varchar2
    ) return date
        deterministic
    is
    begin
        return
            case
                when i_timestamp is null then
                    to_date ( null )
                else to_date ( substr(i_timestamp, 1, 10)
                               || ' '
                               || substr(i_timestamp, 12, 8), 'YYYY-MM-DD HH24:MI:SS' )
            end;
    end fd_json_timestamp; 


  /** 
  * Liefert zum uebergebenen Teil-PK den fuer die jeweilige Stage gueltigen Wert kompletten Record, 
  * jedoch wird keine Exception zurueckgegeben, falls der gesuchte Teil-PK nicht existiert. 
  * 
  * @param piv_satzart => Teil des PK 
  * @param piv_key1 => Teil des PK 
  * @param piv_key2 => Teil des PK 
  * 
  * @return Zeile mit den gesuchten Schluesseln, oder NULL falls diese nicht existiert. 
  * 
  * @todo/// Umleiten auf Package PARAMS, sobald sich diese Function dort befindet. 
  */
    function fr_params_noexception (
        piv_satzart in params.pv_satzart%type,
        piv_key1    in params.pv_key1%type,
        piv_key2    in params.pv_key2%type
    ) return v_params%rowtype is

        r_retval        v_params%rowtype; 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'fr_params_noexception';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_satzart', piv_satzart);
            pck_format.p_add('piv_key1', piv_key1);
            pck_format.p_add('piv_key2', piv_key2);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        select
            *
        into r_retval
        from
            v_params
        where
                pv_satzart = piv_satzart
            and pv_key1 = piv_key1
            and pv_key2 = piv_key2;

        return r_retval;
    exception
        when no_data_found then 
      -- per Definition ist dies hier kein Fehler 
            return null; 
      -- alle anderen Fehler bleiben selbstverstaendlich bestehen: 
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end fr_params_noexception; 


  /** 
  * Schreibt einen Konfigurationsdatensatz für die jeweils passende Umgebung 
  * in die Tabelle CORE.PARAMS, wobei zuvor geprüft wird, ob die Schlüsselfelder 
  * "pv_satzart" und pv_key2" gefüllt sind (pv_key1 wird fest mit dem Wert 'GLASCONTAINER' belegt). 
  * 
  * @param pir_params  [IN ]  Ausgefüllter Datensatz, dessen Feld PV_ENVIRONMENT jedoch leer sein sollte, 
  *                           da es in jedem Fall mit dem Wert der aktuellen Umgebung (z.B. "NMC" für 
  *                           Produktion) überschrieben wird 
  * 
  * @usage Der Datensatz wird entweder angelegt oder aktualisiert. 
  * 
  * @example 
  * DECLARE 
  * v_params params%rowtype; 
  * BEGIN 
  * v_params.pv_satzart := 'WEBSERVICE'; 
  * v_params.pv_key2 := 'MIN_SYNC_INTERVAL_PREORDERS'; 
  * v_params.n_wert1 := 10; 
  * v_params.v_beschreibung := 'Mindestanzahl Minuten zwischen zwei manuell ausgelösten Webservice-Synchronisierungen'; 
  * PCK_GLASCONTAINER.p_merge_params(v_params); 
  * END; 
  * 
  * @example 
  * DECLARE 
  * v_params params%rowtype; 
  * BEGIN 
  * v_params.pv_satzart := 'WEBSERVICE'; 
  * v_params.pv_key1 := 'PREORDERBUFFER'; 
  * v_params.pv_key2 := 'BASE-URL'; 
  * v_params.v_wert1 := 'https://api-e.dss.svc.netcologne.intern/'; 
  * v_params.v_wert2 := 'agent'; 
  * v_params.v_wert3 := 'bnkRO=62Gs1o'; 
  * v_params.v_beschreibung := 'Webservice Base-URL, mit der sich der Glascontainer in der aktuellen Umgebung verbindet'; 
  * PCK_GLASCONTAINER.p_merge_params(v_params); 
  * END; 
  */
    procedure p_merge_params (
        pir_params in params%rowtype
    ) is

        v_params        params%rowtype;
        v_environment   params.pv_environment%type; 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'p_merge_params';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pir_params.satzart', pir_params.pv_satzart);
            pck_format.p_add('pir_params.pv_key1', pir_params.pv_key1);
            pck_format.p_add('pir_params.pv_key2', pir_params.pv_key2);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        if pir_params.pv_satzart is null then
            raise_application_error(c_plausi_error_number, 'Satzart darf nicht leer sein');
        end if;
        if pir_params.pv_key1 is null then
            raise_application_error(c_plausi_error_number, 'Schlüssel 1 darf nicht leer sein');
        end if;
        if pir_params.pv_key2 is null then
            raise_application_error(c_plausi_error_number, 'Schlüssel 2 darf nicht leer sein');
        end if; 
    -- Werte aus Argument übernehmen 
        v_params := pir_params; 
    -- In jedem Fall die korrekte Umgebung setzen 
        v_params.pv_environment := db_name;
        pck_params_dml.p_merge(v_params);
    exception
        when others then
            if sqlcode <> c_plausi_error_number then
                pck_logs.p_error(
                    pic_message      => fcl_params(),
                    piv_routine_name => qualified_name(cv_routine_name),
                    piv_scope        => g_scope
                );
            end if;

            raise;
    end p_merge_params; 



  /** 
  * Liefert den Wert1 eines Schlüssels aus der Tabelle PARAMS zurück, wobei kein 
  * Fehler bei Nichtvorhandenseit des Schlüssels geworfen wird 
  * 
  * @param piv_satzart [IN ] beispielsweise 'WEBSERVICE' 
  * @param piv_key [IN ] beispielsweise '' 
  * 
  * @usage PARAMS KEY1 ist per Definition 'GLASCONTAINER' 
  * 
  * @return Existierender Wert oder NULL 
  */
    function fv_konfiguration_lesen (
        piv_satzart in params.pv_satzart%type,
        piv_key     in params.pv_key2%type
    ) return varchar2 is
        vr_params v_params%rowtype;
    begin
        vr_params := fr_params_noexception(
            piv_satzart => piv_satzart,
            piv_key1    => glascontainer,
            piv_key2    => piv_key
        );

        return nvl(
            to_char(vr_params.n_wert1),
            vr_params.v_wert1
        );
    end fv_konfiguration_lesen; 



/** 
  * Schreibt einen Konfigurationsparameter in die Tabelle CORE.PARAMS 
  * 
  * @param piv_satzart [IN] beispielsweise 'WEBSERVICE' 
  * @param piv_key [IN] beispielsweise 'BASE-URL' 
  * @param piv_wert1 [IN] (optional) 
  * @param piv_wert2 [IN] (optional) 
  * @param piv_wert3 [IN] (optional) 
  * @param pin_wert1 [IN] (optional) 
  * @param pin_wert2 [IN] (optional) 
  * @param pin_wert3 [IN] (optional) 
  * @param piv_beschreibung [IN] (optional) 
  */
    procedure p_konfiguration_speichern (
        piv_satzart      in params.pv_satzart%type,
        piv_key          in params.pv_key2%type,
        piv_wert1        in params.v_wert1%type default null,
        piv_wert2        in params.v_wert2%type default null,
        piv_wert3        in params.v_wert1%type default null,
        pin_wert1        in params.n_wert1%type default null,
        pin_wert2        in params.n_wert2%type default null,
        pin_wert3        in params.n_wert3%type default null,
        piv_beschreibung in params.v_beschreibung%type default null
    ) is

        vr_params       v_params%rowtype; 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'p_konfiguration_speichern';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_satzart', piv_satzart);
            pck_format.p_add('piv_key', piv_key);
            pck_format.p_add('piv_wert1', piv_wert1);
            pck_format.p_add('piv_wert2', piv_wert2);
            pck_format.p_add('piv_wert3', piv_wert3);
            pck_format.p_add('pin_wert1', pin_wert1);
            pck_format.p_add('pin_wert2', pin_wert2);
            pck_format.p_add('pin_wert3', pin_wert3);
            pck_format.p_add('piv_beschreibung', piv_beschreibung);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin 
    -- Bestehende Werte holen, damit die Beschreibung nicht übergebügelt wird 
        vr_params := fr_params_noexception(
            piv_satzart => piv_satzart,
            piv_key1    => glascontainer,
            piv_key2    => piv_key
        ); 
    -- Diese Konfiguration könnte nun gefunden worden sein - oder auch nicht ... 
    -- Definitionsgemäß haben sämtliche Parameter dieser Anwendung 
    -- den Wert 'GLASCONTAINER' als ersten Schlüssel: 
        vr_params.pv_key1 := glascontainer; 
    -- Die übrigen Werte werden aus den Argumenten gefüllt 
        vr_params.pv_satzart := piv_satzart;
        vr_params.pv_key2 := piv_key;
        vr_params.v_wert1 := piv_wert1;
        vr_params.v_wert2 := piv_wert2;
        vr_params.v_wert3 := piv_wert3;
        vr_params.n_wert1 := pin_wert1;
        vr_params.n_wert2 := pin_wert2;
        vr_params.n_wert3 := pin_wert3; 
    -- Bestehende Parameterbeschreibung nicht tilgen, es sei denn sie 
    -- wurde dieser Prozedur zum Update mitgegeben: 
        vr_params.v_beschreibung := nvl(
            trim(piv_beschreibung),
            vr_params.v_beschreibung
        ); 
    -- Insert oder Update des Parameters: 
        p_merge_params(vr_params);
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end p_konfiguration_speichern; 

  /** 
  * Liefert in der jeweiligen Umgebung die Webservice-Base-URL, deren Benutzernamen 
  * und Passwort. 
  * 
  * @param pov_ws_url [OUT] Basis-URL für den Aufruf, passend zur jeweiligen Umgebung 
  * @param pov_ws_username [OUT] Benutzername für den Aufruf, passend zur jeweiligen Umgebung 
  * @param pov_ws_password [OUT] Passwort für den Aufruf, passend zur jeweiligen Umgebung 
  * 
  * @example 
  * DECLARE 
  * v_ws_base_url VARCHAR2(100); 
  * v_ws_username VARCHAR2(100); 
  * v_ws_password VARCHAR2(100); 
  * BEGIN 
  * pck_glascontainer.get_base_url( 
  * pov_ws_base_url => v_ws_base_url 
  * , pov_ws_username => v_ws_username 
  * , pov_ws_password => v_ws_password 
  * ); 
  * DBMS_OUTPUT.PUT_LINE(v_ws_base_url || ', ' || v_ws_username || ', ' || v_ws_password); 
  * END; 
  */ 
  -------------------------------------------------------------------------------- 

  /** 
  * Liefert in der jeweiligen Umgebung die Webservice-Base-URL, deren Benutzernamen 
  * und Passwort. 
  * 
  * @param pov_ws_url [OUT] Basis-URL für den Aufruf, passend zur jeweiligen Umgebung 
  * @param pov_ws_username [OUT] Benutzername für den Aufruf, passend zur jeweiligen Umgebung 
  * @param pov_ws_password [OUT] Passwort für den Aufruf, passend zur jeweiligen Umgebung 
  * 
  * @example 
  * DECLARE 
  * v_ws_base_url VARCHAR2(100); 
  * v_ws_username VARCHAR2(100); 
  * v_ws_password VARCHAR2(100); 
  * BEGIN 
  * pck_glascontainer.get_base_url( 
  * pov_ws_base_url => v_ws_base_url 
  * , pov_ws_username => v_ws_username 
  * , pov_ws_password => v_ws_password 
  * ); 
  * DBMS_OUTPUT.PUT_LINE(v_ws_base_url || ', ' || v_ws_username || ', ' || v_ws_password); 
  * END; 
  @deprecated, stattdessen PCK_POB_REST.get_base_url verwenden 
    PROCEDURE get_base_url ( 
        pov_ws_base_url OUT VARCHAR2, 
        pov_ws_username OUT VARCHAR2, 
        pov_ws_password OUT VARCHAR2 
    ) IS 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name CONSTANT logs.routine_name%TYPE := 'get_base_url'; 

        FUNCTION fcl_params RETURN logs.message%TYPE IS 
        BEGIN 
      -- (OUT): pov_ws_base_url 
      -- (OUT): pov_ws_username 
      -- (OUT): pov_ws_password 
            RETURN pck_format.fcl_params(cv_routine_name); 
        END fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    BEGIN 
    -- 2023-06-06: Umleiten auf POB_REST. 
      PCK_POB_REST.get_base_url( 
          piv_kontext    => PCK_POB_REST.PREORDERBUFFER 
        , pov_ws_base_url => pov_ws_base_url 
        , pov_ws_username => pov_ws_username 
        , pov_ws_password => pov_ws_password 
      ); 

    @///todo: Direktaufruf aus APEX P1011, anstatt PCK_GLASCONTAINER.base_url 
    -- Die PARAMS-Tabelle liefert je nach Umgebung genau einen Satz zurück: 
        SELECT 
            v_wert1, 
            v_wert2, 
            v_wert3 
        INTO 
            pov_ws_base_url, 
           -- erwartet: @URL 
           -- https://api[-e|-u|-s|-x].dss.svc.netcologne.intern/ 
            pov_ws_username, 
            pov_ws_password 
        FROM 
            v_params -- dahinter liegt CORE.PARAMS und gibt in jeder Umgebung 
    -- die passenden Parameter zurück (ALL|NMC|NMCE|... etc), 
    -- wobei ein spezifischer Umgebungsname, falls vorhanden, 
    -- stets den Eintrag für "ALL" überdeckt 
        WHERE 
                pv_satzart = c_satzart_webservice 
            AND pv_key1 = glascontainer 
            AND pv_key2 = 'BASE_URL'; -- 2023-05-16 war: BASE-URL (Parameter wurde ersetzt) 
    EXCEPTION 
        WHEN OTHERS THEN 
            pck_logs.p_error( 
              pic_message      => fcl_params() 
             ,piv_routine_name => qualified_name(cv_routine_name) 
             ,piv_scope        => G_SCOPE 
            ); 
            RAISE; 
    END get_base_url; 
    */ 

  /** 
  * Gibt die Server-Basis-URL des Webservices zurück, mit der sich die aktuelle 
  * Instanz des Glascontainers verbindet. 
  */
    function base_url return varchar2 is

        v_base_url core.params.v_wert1%type;
        v_wert2    core.params.v_wert2%type;
        v_wert3    core.params.v_wert3%type;
    begin
        pck_pob_rest.get_base_url(
            piv_kontext     => pck_pob_rest.kontext_preorderbuffer -- war: 'GLASCONTAINER' 
            ,
            pov_ws_base_url => v_base_url,
            pov_ws_username => v_wert2,
            pov_ws_password => v_wert3
        );

        return v_base_url;
    end base_url; 



  /** 
  * Ruft den Webservice "/ftth-order/preorders/{id}/history" mit einem GET-Request 
  * für einen bestimmten Auftrag auf und liefert die JSON-Antwort als CLOB zurück 
  * 
  * @param piv_uuid [IN ] Schlüssel des Auftrags 
  * 
  * @ticket FTTH-593 
  * 
  * @return Originale Antwort des Webservice ohne weitere Ergänzung oder Formatierung 
  *
  * @example https://api-e.dss.svc.netcologne.intern/ftth-order/preorders/cJ2hoZBxkLokG8fetW93n9B5JSN8SG/history
  * @example
  * DECLARE
  *   v_json CLOB;
  * BEGIN
  *   v_json := PCK_GLASCONTAINER.fc_history_wsget('cJ2hoZBxkLokG8fetW93n9B5JSN8SG');
  *   DBMS_OUTPUT.PUT_LINE(v_json);
  * END;
  *
  * @todo ///// verschieben in PCK_POB_REST
  */
    function fc_history_wsget (
        piv_uuid in varchar2
    ) return clob is

        v_json                   clob;
        v_ws_url                 varchar2(255);
        v_ws_username            varchar2(255);
        v_ws_password            varchar2(255);
        v_request_url            varchar2(255);
        v_ws_response_statuscode ftth_webservice_aufrufe.response_statuscode%type;
        v_log_id                 ftth_webservice_aufrufe.id%type;
        v_ws_errormsg            ftth_webservice_aufrufe.errormessage%type; 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name          constant logs.routine_name%type := 'fc_history_wsget';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_uuid', piv_uuid);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        if not pck_pob_rest.g_webservices_enabled then
            return empty_clob();
        end if;
        pck_pob_rest.p_init_webservice(
            piv_kontext     => pck_pob_rest.kontext_preorderbuffer,
            piv_ws_key      => pck_pob_rest.c_ws_key_order_history,
            pov_ws_url      => v_ws_url,
            pov_ws_username => v_ws_username,
            pov_ws_password => v_ws_password
        ); 

        -- Falls in der URL '{orderId}' steht, muss dies mit der UUID ersetzt werden 
        v_request_url := replace(v_ws_url,
                                 c_ws_orderid_token,
                                 trim(piv_uuid));
        begin
            v_json := apex_web_service.make_rest_request(
                p_url              => v_request_url,
                p_http_method      => c_ws_method_get,
                p_username         => v_ws_username,
                p_password         => v_ws_password,
                p_transfer_timeout => c_ws_transfer_timeout,
                p_wallet_path      => c_ws_wallet_path,
                p_wallet_pwd       => c_ws_wallet_pwd
            );
        exception
            when others then
                v_ws_errormsg := substr(sqlerrm, 1, 255);
        end; 

        /* nicht übertreiben mit den Logs... 

        pck_pob_rest.p_log_webservice_aufruf( 
            piv_application         => $$plsql_unit 
          , piv_scope               => cv_routine_name 
          , piv_request_url         => v_request_url 
          , piv_method              => c_ws_method_get 
          , piv_parameters          => 'ID' 
          , piv_parameter_values    => piv_uuid 
          , piv_body                => NULL 
          , piv_response_statuscode => apex_web_service.g_status_code 
          , piv_app_user            => NULL 
          , piv_errormessage        => v_ws_errormsg 
        ); 
        */

        v_ws_response_statuscode := apex_web_service.g_status_code;
        if v_ws_errormsg is not null
           or v_ws_response_statuscode <> c_ws_statuscode_ok
        or v_json like '404%' then 
            -- @todo 2023-08-08: Abrufen der History von nicht mehr existierenden Datensätzen erzeugt eine Ugly Exception 
            -- raise_application_error(-20000 - c_ws_statuscode_not_found, 'Webservice "preorders_history" meldet Statuscode ' || v_ws_response_statuscode); 
            return empty_clob(); 
      -- ///... Statuscodes aufdröseln ... 
        end if;

        return v_json;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end fc_history_wsget; 

  /** 
  * Ruft den Webservice "/preorders/{id}" mit einem GET-Request 
  * für einen bestimmten Auftrag auf und liefert die JSON-Antwort als CLOB zurück 
  * 
  * @param piv_uuid [IN ] Schlüssel des Auftrags 
  * 
  * @return Originale Antwort des Webservice ohne weitere Ergänzung oder Formatierung 
  * 
  * @raise ORA-29273: HTTP request failed 
  * @raise ORA-12535: TNS:operation timed out 
  */
    function fc_preorders_wsget (
        piv_uuid in varchar2
    ) return clob is

        v_json                   clob;
        v_ws_url                 varchar2(255);
        v_ws_username            varchar2(255);
        v_ws_password            varchar2(255);
        v_request_url            varchar2(255);
        v_ws_response_statuscode ftth_webservice_aufrufe.response_statuscode%type;
        v_log_id                 ftth_webservice_aufrufe.id%type;
        v_ws_errormsg            ftth_webservice_aufrufe.errormessage%type; 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name          constant logs.routine_name%type := 'fc_preorders_wsget';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_uuid', piv_uuid);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        if not pck_pob_rest.g_webservices_enabled then
            return empty_clob();
        end if;
        pck_pob_rest.p_init_webservice(
            piv_kontext     => pck_pob_rest.kontext_preorderbuffer,
            piv_ws_key      => c_ws_key_preorders_get,
            pov_ws_url      => v_ws_url,
            pov_ws_username => v_ws_username,
            pov_ws_password => v_ws_password
        ); 
    -- @see 
    -- https://api-e.dss.svc.netcologne.intern/ftth-order/swagger-ui/index.html#/order-controller/getOrder 
        --v_request_url := v_ws_url || trim(piv_uuid); 

        -- 2023-05-23: Falls in der URL '{orderId}' steht, muss dies mit der UUID ersetzt werden 
        v_request_url := replace(v_ws_url,
                                 c_ws_orderid_token,
                                 trim(piv_uuid));
        begin
            v_json := apex_web_service.make_rest_request(
                p_url              => v_request_url,
                p_http_method      => c_ws_method_get,
                p_username         => v_ws_username,
                p_password         => v_ws_password,
                p_transfer_timeout => c_ws_transfer_timeout,
                p_wallet_path      => c_ws_wallet_path,
                p_wallet_pwd       => c_ws_wallet_pwd
            );
        exception
            when others then
                v_ws_errormsg := substr(sqlerrm, 1, 255);
        end;

        pck_pob_rest.p_log_webservice_aufruf(
            piv_application         => $$plsql_unit,
            piv_scope               => cv_routine_name,
            piv_request_url         => v_request_url,
            piv_method              => c_ws_method_get,
            piv_parameters          => 'ID' -- /// richtiger Name, oder UUID? neu 2022-08-11 
            ,
            piv_parameter_values    => piv_uuid,
            piv_body                => null,
            piv_response_statuscode => apex_web_service.g_status_code,
            piv_app_user            => null -- Datenabrufe werden nicht persönlich geloggt (nicht angefordert) 
            ,
            piv_errormessage        => v_ws_errormsg
        );

        v_ws_response_statuscode := apex_web_service.g_status_code;
        if v_ws_errormsg is not null
           or v_ws_response_statuscode <> c_ws_statuscode_ok
        or v_json like '404%' then 
      -- /// unsauber, da hier alles auf den 404 gemappt wird: 
            raise_application_error(-20000 - c_ws_statuscode_not_found, 'Webservice "preorders" meldet Statuscode ' || v_ws_response_statuscode
            ); 
      -- ///... Statuscodes aufdröseln ... 
        end if;

        return v_json;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end fc_preorders_wsget; 

/** 
  * Konsolidiert die Eingangsdaten und erstellt daraus den JSON-Body, 
  * der für den Aufruf des POST-Webservices "preorders" 
  * zur Aktualisierung eines Auftrags in der Agent View benötigt wird 
  * 
  * @param piv_promotion            [IN ] Entspricht im JSON dem Feld "templateId" 
  * @param piv_router_auswahl       [IN ] Entspricht im JSON dem Feld "deviceCategory" 
  * @param piv_router_eigentum      [IN ] Entspricht im JSON dem Feld "deviceOwnership" 
  * @param piv_ont_provider         [IN ] Entspricht im JSON dem Feld "ontProvider" 
  * @param piv_installationsservice [IN ] Entspricht im JSON dem Feld "installationService" 
  * @param piv_service_plus_email   [IN ] Entspricht im JSON dem Feld "servicePlusEmail" -- neu 2023-08-23 
  * @param piv_app_user             [IN ] Entspricht im JSON dem Feld "user" 
  */
    function fj_preorders_product_update (
        piv_promotion            in varchar2,
        piv_router_auswahl       in varchar2,
        piv_router_eigentum      in varchar2, -- ///@todo: Prüfen: Ist das nicht etwa das Feld "Router-Auswahl" im Formular? 
        piv_ont_provider         in varchar2, -- @ticket FTTH-3097 
        piv_installationsservice in varchar2, 
        --piv_service_plus_email   IN VARCHAR2, @FTTH-5002: Kann nach der Einführung der Versionierung gelöscht werden
        piv_app_user             in varchar2  -- @ticket FTTH-594 
    ) return clob is

        vj_body           json_object_t := new json_object_t(c_empty_json);
        vj_product        json_object_t := new json_object_t(c_empty_json);
        v_deviceownership ftth_ws_sync_preorders.deviceownership%type; 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name   constant logs.routine_name%type := 'fj_preorders_product_update';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_promotion', piv_promotion);
            pck_format.p_add('piv_router_auswahl', piv_router_auswahl);
            pck_format.p_add('piv_router_eigentum', piv_router_eigentum);
            pck_format.p_add('piv_ont_provider', piv_ont_provider);
            pck_format.p_add('piv_installationsservice', piv_installationsservice); 
            --pck_format.p_add('piv_service_plus_email', piv_service_plus_email); @FTTH-5002: Kann nach der Einführung der Versionierung gelöscht werden
            pck_format.p_add('piv_app_user', piv_app_user);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin 
    -- APEX blendet das Feld "Router-Eigentum" möglicherweise aus, 
    -- so dass es in bestimmten Fällen hier noch einen Wert besitzt, 
    -- wenn es eigentlich leer sein sollte: 
        v_deviceownership :=
            case
                when nvl(piv_router_auswahl, '-') = enum_devicecategory_byod then
                    null
                else piv_router_eigentum
            end;

        vj_product.put('templateId', piv_promotion);
        vj_product.put('deviceCategory', piv_router_auswahl);
        vj_product.put('deviceOwnership', v_deviceownership);
        vj_product.put('ontProvider', piv_ont_provider);
        vj_product.put('installationService', piv_installationsservice); 
        -- Produktänderung zusammengefasst: 
        vj_body.put('product', vj_product); 
        -- 2023-08-23 @ticket FTTH-2411: Die E-Mail-Adresse für das Sicherheitspaket 
        -- steht direkt im Body (Auftragsebene): 
        --vj_body.put('servicePlusEmail', piv_service_plus_email); @FTTH-5002: Kann nach der Einführung der Versionierung gelöscht werden
        -- Metainformationen mitsenden: 
        vj_body.put('changedBy', piv_app_user); -- @ticket FTTH-594 
        return vj_body.to_clob;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end fj_preorders_product_update; 

  /** 
  * Prüft die Eingangsdaten und erstellt daraus den JSON-Body, 
  * der für den Aufruf des POST-Webservices "/preorders/{orderId}/cancel" 
  * zur Stornierung eines Auftrags benötigt wird 
  * 
  * @param piv_cancellation_reason [IN ] Entspricht im JSON dem Feld "cancellationReason" 
  * @param piv_user [IN ] Entspricht im JSON dem Feld "user" 
  */
    function fj_preorders_cancel (
        piv_cancellation_reason in varchar2,
        piv_user                in varchar2
    ) return clob is

        vj_body         json_object_t := new json_object_t(c_empty_json); 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'fj_preorders_cancel';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_cancellation_reason', piv_cancellation_reason);
            pck_format.p_add('piv_user', piv_user);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        if trim(piv_cancellation_reason) is null then
            raise_application_error(c_plausi_error_number, 'Kündigungsgrund ist leer');
        end if;
        if trim(piv_user) is null then
            raise_application_error(c_plausi_error_number, 'User für Kündigungsgrund ist leer');
        end if;
        vj_body.put('cancellationReason', piv_cancellation_reason); 
        -- Metainformationen mitsenden: 
        vj_body.put('user', piv_user); -- @deprecated, kann entfernt werden sobald serverseitig "changedBy" implementiert ist 
        vj_body.put('cancelledBy', piv_user); -- @ticket FTTH-594, FTTH-471 
        return vj_body.to_clob;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end fj_preorders_cancel; 

  /** 
  * Ruft den Webservice "/preorders/" mit einem POST-Request 
  * für einen bestimmten Auftrag auf, um geänderte Daten zu übermitteln 
  * (dies sollte eigentlich über PUT gelöst sein) 
  * 
  * @param piv_ws_key       [IN ] C_WS_KEY_PREORDERS_POST|C_WS_KEY_PREORDERS_CANCEL 
  * @param piv_uuid         [IN ] ID des Auftrags, der geändert werden soll 
  * @param piv_app_user     [IN ] APEX-Anwendungsnutzer zu Logging-Zwecken 
  * @param pic_request_body [IN ] JSON mit den geänderten Daten, beispielsweise beginnend mit "product": {...} 
  * 
  * 
  * @raise Der Body wird nicht geprüft - alle Exceptions werden geworfen. 

    PROCEDURE p_webservice_post ( 
        piv_ws_key     IN VARCHAR2, 
        piv_uuid       IN VARCHAR2, 
        piv_app_user   IN VARCHAR2, 
        pic_body       IN CLOB 
    ) IS 
///@todo umleiten, nach Test hier entfernen 
    -- REQUEST_URL VARCHAR2(4000); 
        v_ws_url          VARCHAR2(255); 
        v_ws_username     VARCHAR2(255); 
        v_ws_password     VARCHAR2(255); 
        v_ws_response     CLOB; 
        v_ws_errormessage ftth_webservice_aufrufe.errormessage%TYPE; 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name   CONSTANT logs.routine_name%TYPE := 'p_webservice_post'; 

        FUNCTION fcl_params RETURN logs.message%TYPE IS 
        BEGIN 
            pck_format.p_add('piv_ws_key', piv_ws_key); 
            pck_format.p_add('piv_uuid', piv_uuid); 
            pck_format.p_add('piv_app_user', piv_app_user); 
            pck_format.p_add('pic_body', DBMS_LOB.SUBSTR(pic_body, 1000, 1)); 
            RETURN pck_format.fcl_params(cv_routine_name); 
        END fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    BEGIN 
    -- Beispiel für den Body: 
    -- { 
    -- "product": { 
    -- "templateId": "FTTH_FACTORY_2022_04_50", 
    -- "deviceCategory": "PREMIUM", 
    -- "deviceOwnership": "BUY", 
    -- "installationService": "NONE" 
    -- } 
    -- } 
    -- laut Aussage AOE werden alle übrigen gesendeten Elemente ignoriert. 

    -- Header clearen: 
        p_init_webservice( 
            piv_ws_key      => piv_ws_key 
          , pov_ws_url      => v_ws_url 
          , pov_ws_username => v_ws_username 
          , pov_ws_password => v_ws_password 
        ); 

        apex_web_service.g_request_headers(1).name := 'Content-Type'; 
        apex_web_service.g_request_headers(1).value := 'application/json'; -- 2023-01-24, fehlte, @Ticket FTTH-1698 

    --  2023-05-23: Alle URL-Muster werden aus PARAMS ermittelt, nicht mehr fallweise hartkodiert: 
        v_ws_url := replace(v_ws_url, C_WS_ORDERID_TOKEN, piv_uuid); 

    -- @see 
    -- https://api-e.dss.svc.netcologne.intern/ftth-order/swagger-ui/index.html#/order-controller/updateOrder 
        IF NOT g_ws_testmodus THEN 
            BEGIN 
                v_ws_response := apex_web_service.make_rest_request( 
                    p_url              => v_ws_url 
                  , p_http_method      => c_ws_method_post 
                  , p_username         => v_ws_username 
                  , p_password         => v_ws_password 
                  , p_transfer_timeout => c_ws_transfer_timeout 
                  , p_wallet_path      => c_ws_wallet_path 
                  , p_wallet_pwd       => c_ws_wallet_pwd 
                  , p_body             => pic_body 
                ); 
            EXCEPTION 
                WHEN OTHERS THEN 
                    v_ws_errormessage := substr(sqlerrm, 1, 255); 
            END; 
        END IF; 

        p_log_webservice_aufruf( 
            piv_application         => $$PLSQL_UNIT 
          , piv_scope               => cv_routine_name 
          , piv_request_url         => v_ws_url 
          , piv_method              => c_ws_method_post 
          , piv_parameters          => 'ID' 
          , piv_parameter_values    => piv_uuid 
          , piv_body                => pic_body 
          , piv_response_statuscode => apex_web_service.g_status_code 
          , piv_app_user            => piv_app_user 
          , piv_errormessage        => v_ws_errormessage 
        ); 
    -- Status überprüfen: 
        IF v_ws_errormessage IS NOT NULL OR apex_web_service.g_status_code <> c_ws_statuscode_ok THEN 
            raise_application_error(-20000 - apex_web_service.g_status_code, 
                                   CASE 
                                       WHEN v_ws_errormessage IS NOT NULL THEN 
                                           v_ws_errormessage 
                                       ELSE 'Statuscode ' -- 
                                            || apex_web_service.g_status_code 
                                            || ' - ' 
                                            || fv_http_status(apex_web_service.g_status_code) 
                                   END 
            ); 
        END IF; 

    EXCEPTION 
        WHEN OTHERS THEN 
      -- nur unerwartete Fehler loggen (fachliche und technische Webservice-Statusfehler 
      -- werden ja bereits oben geloggt) 
            IF v_ws_errormessage IS NOT NULL THEN 
              pck_logs.p_error( 
                pic_message      => fcl_params() 
               ,piv_routine_name => qualified_name(cv_routine_name) 
               ,piv_scope        => G_SCOPE 
              ); 
            END IF; 

            RAISE; 

    BEGIN 
      PCK_POB_REST.p_webservice_post( 
        piv_kontext    => PCK_POB_REST.KONTEXT_PREORDERBUFFER, 
        piv_ws_key     => piv_ws_key, 
        piv_uuid       => piv_uuid, 
        piv_app_user   => piv_app_user, 
        pic_body       => pic_body       
      ); 
    END p_webservice_post; 
   */ -- ////Umleitung: 

  /** 
   * Validiert die übergebenen Daten, führt bei Erfolg ein Update 
   * der Produktmerkmale eines PreOrders gegen den Webservice durch 
   * und liefert gegebenenfalls Informationen zu Validierungsfehlern beziehungsweise 
   * zum Webservice-Statuscode als Exception an APEX zurück 
   * 
   * @param piv_uuid                  [IN ] Auftrags-ID des PreOrders, für den die folgenden 
   *                                        Feldinhalte aktualisiert werden sollen: 
   * @param piv_promotion             [IN ] Entspricht im JSON dem Feld "templateId" 
   * @param piv_router_auswahl        [IN ] Entspricht im JSON dem Feld "deviceCategory" 
   * @param piv_router_eigentum       [IN ] Entspricht im JSON dem Feld "deviceOwnership" 
   * @param piv_ont_provider          [IN ] neu 2024-02-27: Entspricht im JSON dem Feld "ontProvider" 
   * @param piv_installationsservice  [IN ] Entspricht im JSON dem Feld "installationService" 
   * @param piv_app_user              [IN ] 4- oder 6-stelliges Kürzel für den APEX-Anwendungsnutzer 
   * @param service_plus_email        [IN ] E-Mail-Adresse für das optionale Sicherheitspaket ab Produktgeneration 2023-09 
   * 
   * @usage Aufruf durch APEX-Prozess "PRODUKTAENDERUNG_SPEICHERN" (P20) 
   * 
   * @raise Falls nicht erfolreich, wird im SQLCODE eine nummerische Konstante für den Validierungsfehler 
   *            oder der nicht-erfolgreiche Webservice-Statuscode (z.B. -20400 für Bad Request) 
   *            sowie eine sprechende Fehlermeldung in der SQLERRM zurückgegeben 
   * 
   * @usage     Die Prozedur überprüft nicht das processLock! Diese Prüfung sollte zuvor erfolgen. 
   */
    procedure p_produktaenderung_speichern (
        piv_uuid                 in varchar2,
        pin_haus_lfd_nr          in integer,
        piv_promotion            in varchar2,
        piv_router_auswahl       in varchar2,
        piv_router_eigentum      in varchar2,
        piv_ont_provider         in varchar2,
        piv_installationsservice in varchar2,
        piv_app_user             in varchar2 
    --piv_service_plus_email   IN VARCHAR2 DEFAULT NULL  @FTTH-5002: Kann nach der Einführung der Versionierung gelöscht werden
    ) is

        vc_body              clob;
        vc                   vermarktungscluster%rowtype; -- für Validierungen
        v_ws_statuscode      integer;
        v_ws_response        clob;
        v_rest_error_message varchar2(500 char);
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name      constant logs.routine_name%type := 'p_produktaenderung_speichern';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_uuid', piv_uuid);
            pck_format.p_add('piv_promotion', piv_promotion);
            pck_format.p_add('piv_router_auswahl', piv_router_auswahl);
            pck_format.p_add('piv_router_eigentum', piv_router_eigentum);
            pck_format.p_add('piv_ont_provider', piv_ont_provider);
            pck_format.p_add('piv_installationsservice', piv_installationsservice);
            pck_format.p_add('piv_app_user', piv_app_user);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin 
    -- Daten validieren: --- ///@todo Validierungen auslagern, um sie wiederverwenden zu können, z.B. chk_installationsservice aufrufen 
        if piv_uuid is null then
            raise_application_error(c_failed_uuid, 'Die Auftrags-UUID fehlt');
        end if;
        if piv_promotion is null then
            raise_application_error(c_failed_product_specs, 'Die Angabe der Promotion fehlt');
        end if;
        if piv_router_auswahl is null then
            raise_application_error(c_failed_product_specs, 'Die Angabe der Router-Auswahl fehlt');
        end if; 

        -- @ticket FTTH-3957: Prüfung wird ermöglicht durch neuen Parameter pin_haus_lfd_nr
        if piv_ont_provider is null then
            -- @ticket FTTH-4247        
            -- 1. Prüfen, ob im POB die Technologie FTTH existiert, genau dann ist das Glasfaser-Modem Pflicht:
            declare
                v_technology       ftth_ws_sync_preorders.technology%type;
                v_wholebuy_partner ftth_ws_sync_preorders.wholebuy_partner%type;
            begin
                select
                    max(technology),
                    max(wholebuy_partner)
                into
                    v_technology,
                    v_wholebuy_partner
                from
                    ftth_ws_sync_preorders
                where
                    id = piv_uuid;

                if
                    v_technology = c_ftth
                    and v_wholebuy_partner is null
                then
                    raise_application_error(c_failed_product_specs, 'Die Auswahl des ONT-Providers fehlt'); -- @ticket FTTH-4247 @todo //////////
                end if;

            end;  
            /* alte Prüfung schaute auf den Vermarktungscluster, dessen Diensttyp spielt hierbei aber keine Rolle mehr
            DECLARE
            BEGIN
                BEGIN
                  -- Gibt es Daten zum VMC?            
                  vc := PCK_VERMARKTUNGSCLUSTER.fr_vermarktungscluster(pin_haus_lfd_nr => pin_haus_lfd_nr);
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN NULL;
                END;
                IF vc.dnsttp_lfd_nr in (70) -- 'FTTH' -- @ticket FTTH-3957: /// ersetzen durch Aufruf von get_technologie()
                AND vc.wholebuy IS NULL THEN
                    raise_application_error(c_failed_product_specs, 'Die Auswahl des ONT-Providers fehlt'); -- @ticket FTTH-4247 @todo //////////
                END IF;
            END;
            */
        end if;

        if piv_installationsservice is null then
            raise_application_error(c_failed_product_specs, 'Die Auswahl des Einrichtungsservices fehlt');
        end if; 
    -- 2022-08-25 Validierung wieder einkommentiert, da APEX die Umstellung nun selbst übernimmt: 
        if
            piv_router_auswahl = enum_devicecategory_byod
            and piv_router_eigentum is not null
        then
            raise_application_error(c_failed_product_specs, 'Bei Router-Auswahl "Eigenes Gerät" kann nicht "Miete" oder "Kauf" angegeben werden'
            );
        end if;

        if
            piv_router_auswahl in ( enum_devicecategory_premium, enum_devicecategory_basic ) 
            -- @ticket FTTH-3562: Auch bei BASIC wird auf RENT|BUY geprüft 
            and nvl(piv_router_eigentum, '-') not in ( enum_deviceownership_buy, enum_deviceownership_rent )
        then
            raise_application_error(c_failed_product_specs, 'Router-Auswahl erfordert die Angabe von "Miete" oder "Kauf"');
        end if; 

        -- ////@Herbst 2023:  
        -- * Prüfen, ob die optionale E-Mail-Adresse korrekterweise leer order gefüllt ist 
        /*IF piv_service_plus_email IS NULL -- @FTTH-5002
        -- AND ... piv_promotion ... 
        THEN 
          NULL; 
        END IF; 
        */ --@FTTH-5002: Kann nach der Einführung der Versionierung gelöscht werden

        if trim(piv_app_user) is null then
            raise_application_error(c_plausi_error_number, 'Username darf nicht leer sein');
        end if; 

    -- Nach erfolgreicher Validierung Body zusammenstellen: 
        vc_body := fj_preorders_product_update(
            piv_promotion            => piv_promotion,
            piv_router_auswahl       => piv_router_auswahl 
       -- APEX liefert u.U. einen (veralteten, unsichtbaren) Wert für piv_router_eigentum, 
       -- auch wenn in der Maske umgestellt wurde auf "Premium Router" 
            ,
            piv_router_eigentum      =>
                                 case
                                     when piv_router_auswahl = enum_devicecategory_byod then
                                         null
                                     else
                                         piv_router_eigentum
                                 end,
            piv_ont_provider         => piv_ont_provider,
            piv_installationsservice => piv_installationsservice 
          --, piv_service_plus_email   => piv_service_plus_email @FTTH-5002: Kann nach der Einführung der Versionierung gelöscht werden
            ,
            piv_app_user             => piv_app_user
        ); 

    -- Webservice schreibend aufrufen: 
    /*
        pck_pob_rest.p_webservice_post( -- 2023-05-25: auf PCK_POB_REST umgeleitet 
              piv_kontext    => PCK_POB_REST.KONTEXT_PREORDERBUFFER 
            , piv_ws_key     => C_WS_KEY_PREORDERS_POST 
            , piv_uuid       => piv_uuid 
            , piv_app_user   => piv_app_user 
            , pic_body       => vc_body); 
    */        

    -- 2024-12-31 @ticket FTTH-4314 
        pck_pob_rest.p_webservice_post2(
            piv_kontext       => pck_pob_rest.kontext_preorderbuffer,
            piv_ws_key        => c_ws_key_preorders_post,
            piv_uuid          => piv_uuid,
            piv_app_user      => piv_app_user,
            pic_body          => vc_body 
          ---       
            ,
            pov_ws_statuscode => v_ws_statuscode,
            pov_ws_response   => v_ws_response
        );

        if v_ws_statuscode <> c_ws_statuscode_ok then -- REST-Antwort liefert Fehler:
            -- FTTH-4993 Statuscode neue Fehlermeldung ermitteln da alte allg. Fehlermeldung nicht ausreichend ist
            v_rest_error_message := pck_pob_rest.fv_get_error_message(piv_json_response => v_ws_response);
            if v_rest_error_message is null then
                v_rest_error_message := fv_http_statusmessage(v_ws_statuscode);
            end if;
            raise_application_error(-20000 - v_ws_statuscode, v_rest_error_message);
        end if;

    exception
        when e_plausi_error or e_failed_product_specs or pck_pob_rest.e_request_auftrag_gesperrt -- @ticket FTTH-4314
         then
            raise; -- kein Logging
        when others then 
              -- kein bekannter fachlicher Fehler:
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end p_produktaenderung_speichern; 

  /** 
  * Liefert die Template-Zeile zurück, die oberhalb eines Auftrags angezeigt wird 
  * 
  * @param pin_haus_lfd_nr [IN] HAUS_LFD_NR 
  * @param piv_kundennummer [IN] Anzuzeigender Wert für Kundennummer 
  * @param piv_vorname [IN] Anzuzeigender Wert für Vornamen 
  * @param piv_nachname [IN] Anzuzeigender Wert für Nachnamen 
  * @param pid_geburtsdatum [IN] Anzuzeigender Wert für Geburtsdatum des Kunden 
  * @param piv_anschluss_strasse [IN] Anzuzeigender Wert für Straßennamen 
  * @param piv_anschluss_hausnr [IN] Anzuzeigender Wert für Hausnummer (inklusive Zusatz und Gebäudeteil) 
  * @param piv_anschluss_plz [IN] Anzuzeigender Wert für Postleitzahl 
  * @param piv_anschluss_ort [IN] Anzuzeigender Wert für Ort 
  * 
  * @return Zeichenkette, in der jeder unbekannte/leere Wert mit einer 
  * doppelten geschweiften Klammer {{...}} repräsentiert wird 
  * 
  * @date 2022-09-22: HAUS_LFD_NR wird nicht mehr dargestellt, auch nicht der neue Auftragseingang. 
  */
    function fv_kopfdaten (
        pin_haus_lfd_nr             in varchar2,
        piv_kundennummer            in varchar2,
        piv_vorname                 in varchar2,
        piv_nachname                in varchar2,
        pid_geburtsdatum            in date,
        piv_adresse_kompl           in varchar2, -- @ticket FTTH-4641
    /*
    piv_anschluss_strasse        IN VARCHAR2, 
    piv_anschluss_hausnr         IN VARCHAR2, -- @ticket 1757: muss den Zusatz bereits beinhalten 
    piv_anschluss_plz            IN VARCHAR2, 
    piv_anschluss_ort            IN VARCHAR2, 
    */
        piv_auftragseingang         in varchar2,
        piv_iban                    in varchar2 default null,
        pib_link_siebel_kundenmaske in boolean default null, -- @ticket FTTH-4470
        piv_account_id              in varchar2 default null
    ) return varchar2 is 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'fv_kopfdaten';
        trenner         constant varchar2(10) := ' '
                                         || chr(38)
                                         || 'bull; ';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_haus_lfd_nr', pin_haus_lfd_nr);
            pck_format.p_add('piv_kundennummer', piv_kundennummer);
            pck_format.p_add('piv_vorname', piv_vorname);
            pck_format.p_add('piv_nachname', piv_nachname);
            pck_format.p_add('pid_geburtsdatum', pid_geburtsdatum);
            pck_format.p_add('piv_adresse_kompl', piv_adresse_kompl);
            pck_format.p_add('pib_link_siebel_kundenmaske', pib_link_siebel_kundenmaske);
            pck_format.p_add('piv_account_id', piv_account_id);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        return 'KNr: ' 
            -- @ticket FTTH-4470: Link zur Siebel-Kundenmaske auf der Kundennummer
            -- || apex_escape.html(nvl(piv_kundennummer, '-')) 
               ||
            case
                when pib_link_siebel_kundenmaske then
                    fv_link_siebel_kundenmaske(
                        piv_kundennummer => piv_kundennummer,
                        piv_account_id   => piv_account_id,
                        piv_css_class    => 'siebel-kundenmaske',
                        piv_target       => '_blank'
                    )
                else piv_kundennummer
            end
               || trenner
               || apex_escape.html(nullif(piv_vorname, n_a))
               || ' '
               || apex_escape.html(nullif(piv_nachname, n_a))
               || trenner 
               /*
               || apex_escape.html(piv_anschluss_strasse) 
               || ' ' 
               || apex_escape.html(piv_anschluss_hausnr) 
               || trenner 
               || apex_escape.html(piv_anschluss_plz) 
               || ' ' 
               || apex_escape.html(piv_anschluss_ort) 
               */
               ||
            case
                when piv_adresse_kompl is null then
                    '<span class="problem">'
            end
               || coalesce(piv_adresse_kompl, '[ Keine Adressdaten für HausLfdNr '
                                              || pin_haus_lfd_nr
                                              || ' verfügbar ]')
               ||
            case
                when piv_adresse_kompl is null then
                    '</span>'
            end
               || case
            when piv_iban is not null then
                trenner
                || 'IBAN: '
                || apex_escape.html(piv_iban)
        end;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end fv_kopfdaten; 

  /** 
  * Selektiert einen Auftrag anhand der UUID und gibt, sofern dieser Auftrag existiert, 
  * die passenden Kopfdaten zurück 
  * 
  * @param piv_ftth_id ID des gewünschten Datensatzes im Preorderbuffer 
  * 
  * @raise Alle Fehler (außer NO_DATA_FOUND) werden geloggt und geraised 
  */
    function fv_kopfdaten (
        piv_ftth_id in ftth_ws_sync_preorders.id%type
    ) return varchar2 is

        v_haus_lfd_nr     ftth_ws_sync_preorders.houseserialnumber%type;
        v_kundennummer    ftth_ws_sync_preorders.customernumber%type;
        v_vorname         ftth_ws_sync_preorders.customer_name_first%type;
        v_nachname        ftth_ws_sync_preorders.customer_name_last%type;
        v_geburtsdatum    ftth_ws_sync_preorders.customer_birthdate%type;
        v_auftragseingang ftth_ws_sync_preorders.created%type;
        v_iban            ftth_ws_sync_preorders.account_iban%type;
        v_adresse_kompl   pob_adressen.adresse_kompl%type;

    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name   constant logs.routine_name%type := 'fv_kopfdaten';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_ftth_id', piv_ftth_id);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        select
            pob.houseserialnumber,
            pob.customernumber,
            pob.customer_name_first,
            pob.customer_name_last,
            pob.customer_birthdate,
            pob.created,
            pob.account_iban,
            a.adresse_kompl
        into
            v_haus_lfd_nr,
            v_kundennummer,
            v_vorname,
            v_nachname,
            v_geburtsdatum,
            v_auftragseingang,
            v_iban,
            v_adresse_kompl
        from
                 ftth_ws_sync_preorders pob
            join pob_adressen a on ( a.haus_lfd_nr = pob.houseserialnumber )
        where
            pob.id = piv_ftth_id;

        return fv_kopfdaten(
            pin_haus_lfd_nr     => v_haus_lfd_nr,
            piv_kundennummer    => v_kundennummer,
            piv_vorname         => v_vorname,
            piv_nachname        => v_nachname,
            pid_geburtsdatum    => v_geburtsdatum
          /*
          , piv_anschluss_strasse => vr.install_addr_street
          , piv_anschluss_hausnr  => rtrim(vr.install_addr_housenumber 
                                      || ' ' 
                                      || vr.install_addr_addition 
                                      ) -- @ticket 1757 
          , piv_anschluss_plz     => vr.install_addr_zipcode 
          , piv_anschluss_ort     => vr.install_addr_city 
          */,
            piv_adresse_kompl   => v_adresse_kompl,
            piv_auftragseingang => v_auftragseingang,
            piv_iban            => v_iban
        );

    exception
        when no_data_found then
            return null;
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end; 

-- noFormat Start 
  /** 
  * Parst das JSON eines einzelnen Auftrags (vom Webservice preorder/id) 
  * und gibt die einzelnen Felder an die OUT-Parameter zurück 
  * 
  * @param pic_preorder_json [IN ] JSON-Repräsenation eines Auftrags 
  * 
  * @usage Anzeige von Auftragsdaten in APEX. 
  * Die überladene Variante (parse_preorder_synchronized) macht das Gleiche, holt aber die Daten 
  * stattdessen aus den bestehenden Synchronisationsdaten. 
  * Es ist darauf zu achten, dass die OUT-Signaturen der beiden Prozeduren 
  * sowie die geparsten Felder vollständig miteinander übereinstimmen. 
  *
  * @example
  * Seite 901 im Glascontainer (nicht verlinkt) zeigt die Ergebnisse des Parsings
  * @unittest
  * SELECT * FROM TABLE(ut.run('UT_GLASCONTAINER', a_tags => 'parse'));
  */
    procedure parse_preorder (
        pic_preorder_json                  in clob, 
        --------------------------------------
        pov_uuid                           out varchar2,
        pov_vkz                            out varchar2,
        pov_kundennummer                   out varchar2,
        pov_promotion                      out varchar2,
        pov_router_auswahl                 out varchar2,
        pov_router_eigentum                out varchar2,
        pov_ont_provider                   out varchar2, -- @ticket FTTH-3097 
        pov_installationsservice           out varchar2,
        pov_haus_anschlusspreis            out varchar2,
        pov_mandant                        out varchar2,
        pov_firmenname                     out varchar2,
        pov_anrede                         out varchar2,
        pov_titel                          out varchar2,
        pov_vorname                        out varchar2,
        pov_nachname                       out varchar2,
        pod_geburtsdatum                   out date,
        pov_email                          out varchar2,
        pov_wohndauer                      out varchar2,
        pov_laendervorwahl                 out varchar2,
        pov_vorwahl                        out varchar2,
        pov_telefon                        out varchar2, 
    --  pov_passwort                       OUT VARCHAR2, -- entfernt 2025-01-21
    -- neu 2022-06-14: 
        pov_providerwechsel                out varchar2,
        pov_providerw_aktueller_anbieter   out varchar2,
        pov_providerw_anmeldung_anrede     out varchar2,
        pov_providerw_anmeldung_nachname   out varchar2,
        pov_providerw_anmeldung_vorname    out varchar2,
        pov_providerw_nummer_behalten      out varchar2,
        pov_providerw_laendervorwahl       out varchar2,
        pov_providerw_vorwahl              out varchar2,
        pov_providerw_telefon              out varchar2, 
    ------------------------------------------ 
        pov_kontoinhaber                   out varchar2,
        pov_sepa                           out varchar2,
        pov_iban                           out varchar2, 
    --2022-08-17 neu:----------------------- 
        pov_voradresse_strasse             out varchar2,
        pov_voradresse_hausnr              out varchar2,
        pov_voradresse_zusatz              out varchar2,
        pov_voradresse_plz                 out varchar2,
        pov_voradresse_ort                 out varchar2,
        pov_voradresse_land                out varchar2, 
    ---------------------------------------- 
        pov_haus_lfd_nr                    out varchar2,
        pov_gee_rolle                      out varchar2,
        pov_anzahl_we                      out varchar2,
        pov_vermieter_rechtsform           out varchar2,
        pov_vermieter_firmenname           out varchar2,
        pov_vermieter_anrede               out varchar2,
        pov_vermieter_titel                out varchar2,
        pov_vermieter_vorname              out varchar2,
        pov_vermieter_nachname             out varchar2,
        pov_vermieter_strasse              out varchar2,
        pov_vermieter_hausnr               out varchar2,
        pov_vermieter_plz                  out varchar2,
        pov_vermieter_ort                  out varchar2,
        pov_vermieter_zusatz               out varchar2,
        pov_vermieter_land                 out varchar2,
        pov_vermieter_email                out varchar2,
        pov_vermieter_laendervorwahl       out varchar2,
        pov_vermieter_vorwahl              out varchar2,
        pov_vermieter_telefon              out varchar2,
        pov_vermieter_einverstaendnis      out varchar2,
        pov_bestaetigung_vzf               out varchar2,
        pov_zustimmung_agb                 out varchar2,
        pov_zustimmung_widerruf            out varchar2,
        pov_opt_in_email                   out varchar2,
        pov_opt_in_telefon                 out varchar2,
        pov_opt_in_sms_mms                 out varchar2,
        pov_opt_in_post                    out varchar2,
        pov_vertragszusammenfassung        out varchar2,
        pov_status                         out varchar2,
        pov_customer_upd_email             out varchar2,
        pov_is_new_customer                out varchar2,
        pod_created                        out date,
        pod_last_modified                  out date,
        pov_version                        out integer,
        pov_changed_by                     out varchar2, -- neu 2023-06-20 
        pov_process_lock                   out varchar2,
        pod_process_lock_last_modified     out date, 
    ---- 
        pov_storno_username                out varchar2, -- neu 2023-07-05 
        pov_storno_grund                   out varchar2, -- neu 2023-07-05 
        pod_storno_datum                   out date,     -- neu 2023-07-05 
        pov_siebel_order_number            out varchar2, -- neu 2023-07-05 @ticket FTTH-2162 
        pov_siebel_order_rowid             out varchar2, -- neu 2023-07-05 @ticket FTTH-2162  
        pov_siebel_ready                   out varchar2, -- neu 2023-07-18 @ticket FTTH-2521 
        -- neu 2023-08-16: 
        pov_service_plus_email             out varchar2, -- @FTTH-5002
        -- neu 2023-11-30: 
        pov_wholebuy_partner               out varchar2,
        pov_manual_transfer                out varchar2,
        pov_technology                     out varchar2,  -- neu 20244-07-09 @ticket FTTH-3747
        -- neu 2024-08-21 @ticket FTTH-3727
        pov_connectivity_id                out varchar2,
        pov_rt_contact_data_ticket_id      out varchar2,
        pov_landlord_information_required  out varchar2,
        -- neu 2024-08-23 @ticket FTTH-3711:
        pov_customer_upd_phone_countrycode out varchar2,
        pov_customer_upd_phone_areacode    out varchar2,
        pov_customer_upd_phone_number      out varchar2,
        pov_update_customer_in_siebel      out varchar2,
        pov_home_id                        out varchar2,  -- @ticket FTTH-4134   
        pov_account_id                     out varchar2,  -- @ticket FTTH-4470
        pod_availability_date              out date,       -- @ticket FTTH-3880
        pov_customer_status                out varchar2,   -- @ticket FTTH-5772
        pov_router_shipping                out varchar2   -- @ticket FTTH-6231
        -- ... @SYNC#02
    ) is 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'parse_preorder';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pic_preorder_json',
                             dbms_lob.substr(pic_preorder_json, 1000, 1));
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin 
    -- Wenn der Webservice als solcher nicht aufgerufen werden konnte 
    -- oder der konkrete Auftrag nicht existiert, lautet das JSON 
    -- (Stand 2022-06-15): 
    -- '404 page not found' 

        if trim(pic_preorder_json) is null -- /// like %404% ? 

         then
            return;
        end if;
        with preorder as (
            select
                pic_preorder_json as auftrag_json
            from
                dual
        )
        select distinct -- ///// warum DISTINCT? Seit der Verwendung von NESTED PATH '$.externalOrderReferences[*]' 
                        -- kann es vorkommen, dass dort mehrere Einträge stehen, und dann erhält man TOO_MANY_ROWS,
                        -- so geschehen in der Produktion am 2024-11-05, gemeldet von Alexandra Czupkowski <Alexandra.Czupkowski@netcologne.com>
                        -- Abhilfe: DISTINCT und MAX(...) OVER (...), siehe unten, bei den Feldern die in einem Array stehen
            auftrag.id                                            as uuid,
            auftrag.vkz                                           as vkz,
            auftrag.customernumber                                as kundennummer,
            auftrag.product_templateid                            as promotion,
            auftrag.product_devicecategory                        as router_auswahl,
            auftrag.product_deviceownership                       as router_eigentum -- [ BUY, RENT ] 
            ,
            auftrag.product_ont_provider                          as ont_provider -- @ticket FTTH-3097             
            ,
            auftrag.product_installationservice                   as installationsservice -- /// "Zusatzoptionen" - muss aufgelöst werden, siehe PreOrder-Buffer-Liste 
            ,
            auftrag.product_houseconnectionprice                  as haus_anschlusspreis,
            auftrag.product_client                                as mandant 
             ---- 
            ,
            auftrag.customer_businessname                         as firmenname,
            auftrag.customer_salutation                           as anrede,
            auftrag.customer_title                                as titel,
            auftrag.customer_name_first                           as vorname,
            auftrag.customer_name_last                            as nachname,
            to_date(auftrag.customer_birthdate, 'YYYY-MM-DD')     as geburtsdatum,
            auftrag.customer_email                                as email,
            auftrag.customer_residentstatus                       as wohndauer,
            auftrag.customer_phone_countrycode                    as laendervorwahl,
            auftrag.customer_phone_areacode                       as vorwahl,
            auftrag.customer_phone_number                         as telefon 
         --   ,auftrag.customer_password                             AS passwort -- entfernt 2025-01-21
           ---------------------------------------------------- 
           -- "Providerwechsel" ist ein abgeleitetes Feld, daher nehmen wir hier nicht [true|false]: 
            ,
            case
                when providerchg_current_provider is null then
                    0
                else
                    1
            end                                                   as providerwechsel,
            providerchg_current_provider                          as providerw_aktueller_anbieter,
            providerchg_owner_salutation                          as providerw_anmeldung_anrede,
            providerchg_owner_name_last                           as providerw_anmeldung_nachname,
            providerchg_owner_name_first                          as providerw_anmeldung_vorname,
            providerchg_keep_phone_number                         as providerw_nummer_behalten,
            providerchg_phone_countrycode                         as providerw_laendervorwahl,
            providerchg_phone_areacode                            as providerw_vorwahl,
            providerchg_phone_number                              as providerw_telefon 
           ------------------------------------------ 
            ,
            auftrag.account_holder                                as kontoinhaber,
            auftrag.account_sepamandate                           as sepa,
            auftrag.account_iban                                  as iban -- 2023-08-08: HIER keine Maskierung mehr mit fv_iban_maskiert, sondern nur in APEX 
           ------------------------------------------ 
            ,
            auftrag.customer_prev_addr_street                     as kunde_vormals_strasse,
            auftrag.customer_prev_addr_housenumber                as kunde_vormals_hausnr,
            auftrag.customer_prev_addr_addition                   as kunde_vormals_zusatz,
            auftrag.customer_prev_addr_zipcode                    as kunde_vormals_plz,
            auftrag.customer_prev_addr_city                       as kunde_vormals_ort,
            auftrag.customer_prev_addr_country                    as kunde_vormals_land 
            ---- 
            ,
            auftrag.houseserialnumber                             as haus_lfd_nr 
            ---- 
            ,
            auftrag.prop_owner_role                               as gee_rolle,
            auftrag.prop_residential_unit                         as anzahl_we,
            auftrag.landlord_legalform                            as vermieter_rechtsform,
            auftrag.landlord_businessname                         as vermieter_firmenname,
            auftrag.landlord_salutation                           as vermieter_anrede,
            auftrag.landlord_title                                as vermieter_titel,
            auftrag.landlord_name_first                           as vermieter_vorname,
            auftrag.landlord_name_last                            as vermieter_nachname,
            auftrag.landlord_addr_street                          as vermieter_strasse,
            auftrag.landlord_addr_housenumber                     as vermieter_hausnr,
            auftrag.landlord_addr_zipcode                         as vermieter_plz,
            auftrag.landlord_addr_city                            as vermieter_ort,
            auftrag.landlord_addr_addition                        as vermieter_zusatz,
            auftrag.landlord_addr_country                         as vermieter_land,
            auftrag.landlord_email                                as vermieter_email,
            auftrag.landlord_phone_countrycode                    as vermieter_laendervorwahl,
            auftrag.landlord_phone_areacode                       as vermieter_vorwahl,
            auftrag.landlord_phone_number                         as vermieter_telefon,
            auftrag.landlord_agreed                               as vermieter_einverstaendnis 
           ------------------------------------- 
            ,
            auftrag.summ_precontractinformation                   as bestaetigung_vzf,
            auftrag.summ_generaltermsandconditions                as zustimmung_agb,
            auftrag.summ_waiverightofrevocation                   as zustimmung_widerruf,
            auftrag.summ_emailmarketing                           as opt_in_email,
            auftrag.summ_phonemarketing                           as opt_in_telefon,
            auftrag.summ_smsmmsmarketing                          as opt_in_sms_mms,
            auftrag.summ_mailmarketing                            as opt_in_post,
            auftrag.summ_ordersummaryfileid                       as vertragszusammenfassung 
           ---- 
            ,
            auftrag.state                                         as status 
           ---- 
            ,
            auftrag.customer_upd_email                            as customer_upd_email -- neu 2022-09-13 
            ,
            auftrag.is_new_customer                               as is_new_customer -- neu 2022-09-13 
            ,
            fd_json_timestamp(auftrag.created)                    as created -- neu 2022-09-20 
            ,
            fd_json_timestamp(auftrag.last_modified)              as last_modified -- neu 2022-09-20 
            ,
            auftrag.version                                       as version -- neu 2022-09-20 
            ,
            auftrag.changed_by                                    as changed_by -- neu 2023-06-20 
            ,
            auftrag.process_lock                                  as process_lock -- neu 2022-09-20 
            ,
            fd_json_timestamp(auftrag.process_lock_last_modified) as process_lock_last_modified -- neu 2022-09-20 
            ---- neu 2023-06-14: 
            ,
            auftrag.cancelled_by,
            auftrag.cancel_reason,
            fd_json_timestamp(auftrag.cancel_date)                as cancel_date,
            auftrag.siebel_order_number,
            auftrag.siebel_order_rowid,
            auftrag.siebel_ready,
            auftrag.service_plus_email -- @FTTH-5002
            ,
            auftrag.wholebuy_partner,
            auftrag.manual_transfer,
            auftrag.technology -- neu 2024-07-09 @FTTH-3747
             -- neu 2024-08-21:
             -- @ticket FTTH-3727
             -- @bugfix 2024-12-03: trotz DISTINCT hierbei immer noch TOO_MANY_ROWS, 
             -- weil die externalOrderReferences leider in Arrays stehen.
             -- Abhilfe: MAX(...) OVER(...)
            ,
            max(auftrag.connectivity_id)
            over(
                order by
                    auftrag.connectivity_id
            )                                                     as connectivity_id,
            max(auftrag.rt_contact_data_ticket_id)
            over(
                order by
                    auftrag.rt_contact_data_ticket_id
            )                                                     as rt_contact_data_ticket_id,
            auftrag.landlord_information_required  -- @ticket FTTH-3727
            -- neu 2024-08-23 @ticket FTTH-3711:
            ,
            auftrag.customer_upd_phone_countrycode,
            auftrag.customer_upd_phone_areacode,
            auftrag.customer_upd_phone_number,
            auftrag.update_customer_in_siebel,
            auftrag.home_id,
            auftrag.account_id -- @ticket FTTH-4470
            ,
            to_date(auftrag.availability_date, 'YYYY-MM-DD'),
            customer_status -- @ticket FTTH-5772
            ,
            router_shipping -- @ticket FTTH-6231
            -- @SYNC#03 ...
        into
            pov_uuid,
            pov_vkz,
            pov_kundennummer,
            pov_promotion,
            pov_router_auswahl,
            pov_router_eigentum,
            pov_ont_provider,
            pov_installationsservice,
            pov_haus_anschlusspreis,
            pov_mandant,
            pov_firmenname,
            pov_anrede,
            pov_titel,
            pov_vorname,
            pov_nachname,
            pod_geburtsdatum,
            pov_email,
            pov_wohndauer,
            pov_laendervorwahl,
            pov_vorwahl,
            pov_telefon, 
         -- pov_passwort, -- entfernt 2025-01-21
           -- neu 2022-06-14: 
            pov_providerwechsel,
            pov_providerw_aktueller_anbieter,
            pov_providerw_anmeldung_anrede,
            pov_providerw_anmeldung_nachname,
            pov_providerw_anmeldung_vorname,
            pov_providerw_nummer_behalten,
            pov_providerw_laendervorwahl,
            pov_providerw_vorwahl,
            pov_providerw_telefon,
            pov_kontoinhaber,
            pov_sepa,
            pov_iban, 
           --2022-08-17 neu: ------------ 
            pov_voradresse_strasse,
            pov_voradresse_hausnr,
            pov_voradresse_zusatz,
            pov_voradresse_plz,
            pov_voradresse_ort,
            pov_voradresse_land, 
           ------------------------------ 
            pov_haus_lfd_nr,
            pov_gee_rolle,
            pov_anzahl_we,
            pov_vermieter_rechtsform,
            pov_vermieter_firmenname,
            pov_vermieter_anrede,
            pov_vermieter_titel,
            pov_vermieter_vorname,
            pov_vermieter_nachname,
            pov_vermieter_strasse,
            pov_vermieter_hausnr,
            pov_vermieter_plz,
            pov_vermieter_ort,
            pov_vermieter_zusatz,
            pov_vermieter_land,
            pov_vermieter_email,
            pov_vermieter_laendervorwahl,
            pov_vermieter_vorwahl,
            pov_vermieter_telefon,
            pov_vermieter_einverstaendnis,
            pov_bestaetigung_vzf,
            pov_zustimmung_agb,
            pov_zustimmung_widerruf,
            pov_opt_in_email,
            pov_opt_in_telefon,
            pov_opt_in_sms_mms,
            pov_opt_in_post,
            pov_vertragszusammenfassung,
            pov_status,
            pov_customer_upd_email,
            pov_is_new_customer,
            pod_created,
            pod_last_modified,
            pov_version,
            pov_changed_by, -- neu 2023-06-20 
            pov_process_lock,
            pod_process_lock_last_modified, 
            ---- neu 2023-06-14: 
            pov_storno_username,
            pov_storno_grund,
            pod_storno_datum,
            pov_siebel_order_number,
            pov_siebel_order_rowid,
            pov_siebel_ready,
            pov_service_plus_email, -- @FTTH-5002
            pov_wholebuy_partner,
            pov_manual_transfer,
            pov_technology,
            ---- neu 2024-08-21:
            pov_connectivity_id,                -- @ticket FTTH-3727
            pov_rt_contact_data_ticket_id,      -- @ticket FTTH-3727
            pov_landlord_information_required,  -- @ticket FTTH-3727
            -- neu 2024-08-23 @ticket FTTH-3711:
            pov_customer_upd_phone_countrycode,
            pov_customer_upd_phone_areacode,
            pov_customer_upd_phone_number,
            pov_update_customer_in_siebel,
            pov_home_id,
            pov_account_id,
            pod_availability_date, -- @ticket FTTH-3880
            pov_customer_status, -- @ticket FTTH-5772
            pov_router_shipping -- @ticket FTTH-6231
            -- ... @SYNC#04
        from
            preorder,
            json_table ( auftrag_json, '$'
                    columns ( 
                    -- 2023-03: Der Beautifier im SQL Developer hatte die JSON-Pfade auf klein.schreibung.umgestellt,  
                    -- daher benutzen nun alle PATH-Ausdrücke Anführungszeichen 
                        id varchar2 ( 50 ) path "id" -- //// konsolidieren: 50/100? 
                        ,
                        vkz varchar2 ( 50 ) path "vkz",
                        customernumber varchar2 ( 50 ) path "customerNumber" -- 2023-02-28 @ticket FTTH-1836 
                        ,
                        product_templateid varchar2 ( 50 ) path "product"."templateId",
                        product_devicecategory varchar2 ( 50 ) path "product"."deviceCategory",
                        product_deviceownership varchar2 ( 50 ) path "product"."deviceOwnership",
                        product_ont_provider varchar2 ( 30 ) path "product"."ontProvider",
                        product_installationservice varchar2 ( 50 ) path "product"."installationService",
                        product_houseconnectionprice number path "product"."houseConnectionPrice",
                        product_client varchar2 ( 2 ) path "product"."client",
                        customer_businessname varchar2 ( 100 ) path "customer"."businessName",
                        customer_salutation varchar2 ( 100 ) path "customer"."salutation",
                        customer_title varchar2 ( 100 ) path "customer"."title",
                        customer_name_first varchar2 ( 100 ) path "customer"."name"."first",
                        customer_name_last varchar2 ( 100 ) path "customer"."name"."last",
                        customer_birthdate varchar2 ( 100 ) path "customer"."birthDate",
                        customer_email varchar2 ( 100 ) path "customer"."email",
                        customer_residentstatus varchar2 ( 100 ) path "customer"."residentStatus" 
                        ----                                                  
                        ,
                        customer_prev_addr_street varchar2 ( 100 ) path "customer"."previousAddress"."street",
                        customer_prev_addr_housenumber varchar2 ( 100 ) path "customer"."previousAddress"."houseNumber",
                        customer_prev_addr_addition varchar2 ( 100 ) path "customer"."previousAddress"."postalAddition",
                        customer_prev_addr_zipcode varchar2 ( 100 ) path "customer"."previousAddress"."zipCode",
                        customer_prev_addr_city varchar2 ( 100 ) path "customer"."previousAddress"."city",
                        customer_prev_addr_country varchar2 ( 100 ) path "customer"."previousAddress"."country" 
                        ----                                                  
                        ,
                        customer_phone_countrycode varchar2 ( 5 ) path "customer"."phoneNumber"."countryCode",
                        customer_phone_areacode varchar2 ( 10 ) path "customer"."phoneNumber"."areaCode",
                        customer_phone_number varchar2 ( 50 ) path "customer"."phoneNumber"."number",
                        customer_password varchar2 ( 100 ) path "customer"."password" 
                        ----                                                  
                        ,
                        install_addr_street varchar2 ( 100 ) path "installation"."address"."street",
                        install_addr_housenumber varchar2 ( 100 ) path "installation"."address"."houseNumber",
                        install_addr_zipcode varchar2 ( 100 ) path "installation"."address"."zipCode",
                        install_addr_city varchar2 ( 100 ) path "installation"."address"."city",
                        install_addr_addition varchar2 ( 100 ) path "installation"."address.postalAddition",
                        install_addr_country varchar2 ( 100 ) path "installation"."address.country",
                        houseserialnumber varchar2 ( 50 ) path "installation"."houseSerialNumber",
                        providerchg_current_provider varchar2 ( 100 ) path "providerChange"."currentProvider"
                        ----                                                  
                        ,
                        providerchg_owner_name_last varchar2 ( 100 ) path "providerChange"."contractOwnerName"."last",
                        providerchg_owner_name_first varchar2 ( 100 ) path "providerChange"."contractOwnerName"."first",
                        providerchg_phone_number varchar2 ( 100 ) path "providerChange"."landlinePhoneNumber"."number",
                        providerchg_phone_areacode varchar2 ( 100 ) path "providerChange"."landlinePhoneNumber"."areaCode",
                        providerchg_phone_countrycode varchar2 ( 100 ) path "providerChange"."landlinePhoneNumber"."countryCode",
                        providerchg_owner_salutation varchar2 ( 100 ) path "providerChange"."contractOwnerSalutation",
                        providerchg_keep_phone_number varchar2 ( 100 ) path "providerChange"."keepCurrentLandlineNumber" 
                        ----                                                  
                        ,
                        account_holder varchar2 ( 100 ) path "accountDetails"."accountHolder",
                        account_sepamandate varchar2 ( 100 ) path "accountDetails"."sepaMandate",
                        account_iban varchar2 ( 100 ) path "accountDetails"."iban" 
                        ----                                                  
                        ,
                        prop_owner_role varchar2 ( 50 ) path "propertyOwnerDeclaration"."propertyOwnerRole",
                        prop_residential_unit varchar2 ( 50 ) path "propertyOwnerDeclaration"."residentialUnit",
                        landlord_legalform varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlord"."legalForm",
                        landlord_businessname varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlord"."businessOrName",
                        landlord_salutation varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlord"."salutation",
                        landlord_title varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlord"."title",
                        landlord_name_first varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlord"."name"."first",
                        landlord_name_last varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlord"."name"."last",
                        landlord_addr_street varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlord"."address"."street",
                        landlord_addr_housenumber varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlord"."address"."houseNumber",
                        landlord_addr_zipcode varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlord"."address"."zipCode" -- @date 2024-07-17 war falsch: "zipcode"
                        ,
                        landlord_addr_city varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlord"."address"."city",
                        landlord_addr_addition varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlord"."address"."postalAddition",
                        landlord_addr_country varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlord"."address"."country",
                        landlord_email varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlord"."email",
                        landlord_phone_countrycode varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlord"."phoneNumber.countryCode"
                        ,
                        landlord_phone_areacode varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlord"."phoneNumber"."areaCode",
                        landlord_phone_number varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlord"."phoneNumber"."number",
                        landlord_agreed varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlordAgreedToBeContacted" -- ///n/a 
                        ,
                        summ_precontractinformation varchar2 ( 10 ) path "summary"."preContractualInformation",
                        summ_generaltermsandconditions varchar2 ( 10 ) path "summary"."generalTermsAndConditions",
                        summ_waiverightofrevocation varchar2 ( 10 ) path "summary"."waiveRightOfRevocation",
                        summ_emailmarketing varchar2 ( 10 ) path "summary"."emailMarketing",
                        summ_phonemarketing varchar2 ( 10 ) path "summary"."phoneMarketing",
                        summ_smsmmsmarketing varchar2 ( 10 ) path "summary"."smsMmsMarketing",
                        summ_mailmarketing varchar2 ( 10 ) path "summary"."mailMarketing",
                        summ_ordersummaryfileid varchar2 ( 50 ) path "summary"."orderSummaryFileId" 
                        ---- 
                        ,
                        state varchar2 ( 50 ) path "state" 
                         ---- 
                         -- 2023-06-14: Neue Felder im Falle einer Stornierung 
                        ,
                        cancelled_by varchar2 ( 100 ) path "cancellation"."cancelledBy" -- @ticket FTTH-1874 
                        ,
                        cancel_reason varchar2 ( 100 ) path "cancellation"."reason"      -- @ticket FTTH-1874 
                        ,
                        cancel_date varchar2 ( 100 ) path "cancellation"."created"     -- @ticket FTTH-1874 
                         ---- 
                        ,
                        customer_upd_email varchar2 ( 100 ) path "customerUpdate"."email" -- dieses Feld bestimmt den Kundenstatus!  -- ///// VARCHAR2(300)???
                        ,
                        is_new_customer varchar2 ( 5 ) path "isNewCustomer" 
                        ---- 
                        ,
                        created varchar2 ( 100 ) path "created",
                        last_modified varchar2 ( 100 ) path "lastModified",
                        version number path "version",
                        changed_by varchar2 ( 100 ) path "changedBy" -- neu 2023-06-20 
                        ,
                        process_lock varchar2 ( 5 ) path "processLock",
                        process_lock_last_modified varchar2 ( 100 ) path "processLockLastModified" -- z.B. 2022-08-31T13:29:50.869150859 
                        ,
                        siebel_order_number path "siebelOrderNumber"       -- @ticket FTTH-2162 
                        ,
                        siebel_order_rowid path "siebelOrderRowId"        -- @ticket FTTH-2162 
                        ,
                        siebel_ready path "siebelReady"             -- @ticket FTTH-2521 
                        ,
                        service_plus_email varchar2 ( 300 ) path "servicePlusEmail"        -- @FTTH-5002
                        -- neu 2023-11-30:
                        ,
                        wholebuy_partner varchar2 ( 30 ) path "wholebuy"."partner"      -- @ticket FTTH-2901 -- zB. 'TCOM' 
                                                                                -- Änderung der Schnittstelle am 2023-03-28, war: "wholebuyPartner"
                        ,
                        manual_transfer varchar2 ( 5 ) path "manualTransfer"          -- @ticket FTTH-2996 
                        ,
                        technology varchar2 ( 50 ) path "technology"              -- @ticket FTTH-3747
                        -- neu 2024-08-21
                        ,
                        nested path '$.externalOrderReferences[*]' -- @ticket FTTH-4442
                            columns (
                                connectivity_id varchar2 ( 100 ) path '$.connectivityId'        -- @ticket FTTH-3727, @ticket FTH-4403
                                ,
                                rt_contact_data_ticket_id varchar2 ( 100 ) path '$.rtContactDataTicketId' -- @ticket FTTH-3727
                            )
                        -- @ticket FTTH-3727:
                            ,
                        landlord_information_required varchar2 ( 5 ) path "wholebuy"."landlordInformationRequired"
                        -- neu 2024-08-23 @ticket FTTH-3711:
                        ,
                        customer_upd_phone_countrycode varchar2 ( 5 ) path "customerUpdate"."phoneNumber"."countryCode",
                        customer_upd_phone_areacode varchar2 ( 5 ) path "customerUpdate"."phoneNumber"."areaCode",
                        customer_upd_phone_number varchar2 ( 15 ) path "customerUpdate"."phoneNumber"."number",
                        update_customer_in_siebel varchar2 ( 5 ) path "customerUpdate"."updateCustomerInSiebel",
                        home_id varchar2 ( 50 ) path "homeId"                  -- @ticket FTTH-4134
                        ,
                        account_id varchar2 ( 128 ) path "accountId"               -- @ticket FTTH-4470
                        ,
                        availability_date varchar2 ( 100 ) path "availabilityDate"        -- @ticket FTTH-3880
                        ,
                        customer_status varchar2 ( 4000 char ) path "customerStatus"         -- @ticket FTTH-5772
                        ,
                        router_shipping varchar2 ( 4000 char ) path "routerShipping"         -- @ticket FTTH-6231
                        -- ... @SYNC#05
                    )
                )
            as auftrag;

    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end parse_preorder; 
-- noFormat End 

 /** 
  * Strukturell die gleiche Prozedur wie parse_preorder, jedoch wird hier nicht 
  * das JSON-Objekt des "preorders"-Webservices geparst, sondern stattdessen 
  * auf die zuvor gespeicherten Daten in der Synchronisationstabelle  
  * FTTH_WS_SYNC_PREORDERS zugegriffen. 
  * 
  * @param  piv_uuid [IN ]  Primary Key der Tabelle FTTH_WS_SYNC_PREORDERS: 
  *                         Auftrags-ID 
  * 
  * @usage  Diese Prozedur kann aufgerufen werden, während der Webservice 
  *         beispielsweise nicht erreichbar ist. Es ist sicherzustellen, 
  *         dass kein Update der Daten stattfindet, da die Konstistenz nicht 
  *         gewährleistet werden kann (eine Methode zur späteren Übermittlung 
  *         solcher Änderungen existiert folgerichtig NICHT). 
  * 
  *         Die überladene Variante (parse_preorder) macht das Gleiche, parst aber die Daten 
  *         aus einem CLOB-Dokument. 
  *         Es ist darauf zu achten, dass die OUT-Signaturen der beiden Prozeduren 
  *         sowie die geparsten Felder vollständig miteinander übereinstimmen. 
  */
    procedure parse_preorder_synchronized (
        piv_uuid                           in ftth_ws_sync_preorders.id%type,
        pov_uuid                           out varchar2,
        pov_vkz                            out varchar2,
        pov_kundennummer                   out varchar2,
        pov_promotion                      out varchar2,
        pov_router_auswahl                 out varchar2,
        pov_router_eigentum                out varchar2,
        pov_ont_provider                   out varchar2, -- @ticket FTTH-3097 
        pov_installationsservice           out varchar2,
        pov_haus_anschlusspreis            out varchar2, -- /// NUMBER 
        pov_mandant                        out varchar2,
        pov_firmenname                     out varchar2,
        pov_anrede                         out varchar2,
        pov_titel                          out varchar2,
        pov_vorname                        out varchar2,
        pov_nachname                       out varchar2,
        pod_geburtsdatum                   out date,
        pov_email                          out varchar2,
        pov_wohndauer                      out varchar2,
        pov_laendervorwahl                 out varchar2,
        pov_vorwahl                        out varchar2,
        pov_telefon                        out varchar2, 
    --  pov_passwort                       OUT VARCHAR2, -- entfernt 2025-01-21
                                        -- neu 2022-06-14: 
        pov_providerwechsel                out varchar2,
        pov_providerw_aktueller_anbieter   out varchar2,
        pov_providerw_anmeldung_anrede     out varchar2,
        pov_providerw_anmeldung_nachname   out varchar2,
        pov_providerw_anmeldung_vorname    out varchar2,
        pov_providerw_nummer_behalten      out varchar2,
        pov_providerw_laendervorwahl       out varchar2,
        pov_providerw_vorwahl              out varchar2,
        pov_providerw_telefon              out varchar2, 
                                        ------------------------------------------ 
        pov_kontoinhaber                   out varchar2,
        pov_sepa                           out varchar2,
        pov_iban                           out varchar2, 
        --2022-08-17 neu:----------------------- 
        pov_voradresse_strasse             out varchar2,
        pov_voradresse_hausnr              out varchar2,
        pov_voradresse_zusatz              out varchar2,
        pov_voradresse_plz                 out varchar2,
        pov_voradresse_ort                 out varchar2,
        pov_voradresse_land                out varchar2, 
                                        ---------------------------------------- 
        pov_haus_lfd_nr                    out varchar2,
        pov_gee_rolle                      out varchar2,
        pov_anzahl_we                      out varchar2,
        pov_vermieter_rechtsform           out varchar2,
        pov_vermieter_firmenname           out varchar2,
        pov_vermieter_anrede               out varchar2,
        pov_vermieter_titel                out varchar2,
        pov_vermieter_vorname              out varchar2,
        pov_vermieter_nachname             out varchar2,
        pov_vermieter_strasse              out varchar2,
        pov_vermieter_hausnr               out varchar2,
        pov_vermieter_plz                  out varchar2,
        pov_vermieter_ort                  out varchar2,
        pov_vermieter_zusatz               out varchar2,
        pov_vermieter_land                 out varchar2,
        pov_vermieter_email                out varchar2,
        pov_vermieter_laendervorwahl       out varchar2,
        pov_vermieter_vorwahl              out varchar2,
        pov_vermieter_telefon              out varchar2,
        pov_vermieter_einverstaendnis      out varchar2,
        pov_bestaetigung_vzf               out varchar2,
        pov_zustimmung_agb                 out varchar2,
        pov_zustimmung_widerruf            out varchar2,
        pov_opt_in_email                   out varchar2,
        pov_opt_in_telefon                 out varchar2,
        pov_opt_in_sms_mms                 out varchar2,
        pov_opt_in_post                    out varchar2,
        pov_vertragszusammenfassung        out varchar2,
        pov_status                         out varchar2,
        pov_customer_upd_email             out varchar2, -- neu 2022-09-13 
        pov_is_new_customer                out varchar2, -- neu 2022-09-13 
        pod_created                        out date,     -- neu 2022-09-21 
        pod_last_modified                  out date,     -- neu 2022-09-21 
        pov_version                        out integer,  -- neu 2022-09-21 
        pov_changed_by                     out varchar2, -- neu 2023-07-18! 
        pov_process_lock                   out varchar2, -- neu 2022-09-21 
        pod_process_lock_last_modified     out date,     -- neu 2022-09-21 
        ---- 
        pov_storno_username                out varchar2, -- neu 2023-07-05 
        pov_storno_grund                   out varchar2, -- neu 2023-07-05 
        pod_storno_datum                   out date,     -- neu 2023-07-05 
        pov_siebel_order_number            out varchar2, -- neu 2023-07-05 @ticket FTTH-2162 
        pov_siebel_order_rowid             out varchar2, -- neu 2023-07-05 @ticket FTTH-2162  
        pov_siebel_ready                   out varchar2  -- neu 2023-07-18 @ticket FTTH-2521 
        -- neu 2023-08-16: 
        ,
        pov_service_plus_email             out varchar2  -- @FTTH-5002
        ,
        pov_wholebuy_partner               out varchar2  -- neu 2023-11-30 @ticket FTTH-2901 
        ,
        pov_manual_transfer                out varchar2  -- neu 2023-11-30 @ticket FTTH-2996 
        ,
        pov_technology                     out varchar2  -- neu 20244-07-09 @ticket FTTH-3747
       -- neu 2024-08-21 @ticket FTTH-3727
        ,
        pov_connectivity_id                out varchar2,
        pov_rt_contact_data_ticket_id      out varchar2,
        pov_landlord_information_required  out varchar2
       -- neu 2024-08-23 @ticket FTTH-3711:
        ,
        pov_customer_upd_phone_countrycode out varchar2,
        pov_customer_upd_phone_areacode    out varchar2,
        pov_customer_upd_phone_number      out varchar2,
        pov_update_customer_in_siebel      out varchar2,
        pov_home_id                        out varchar2 -- @ticket FTTH-4134
        ,
        pov_account_id                     out varchar2 -- @ticket FTTH-4470
        ,
        pod_availability_date              out date,
        pov_customer_status                out varchar2   -- @ticket FTTH-5772
        ,
        pov_router_shipping                out varchar2   -- @ticket FTTH-6231
       -- ... @SYNC#06
    ) is 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'parse_preorder_synchronized';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_uuid', piv_uuid);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        pov_uuid := piv_uuid;
        select
            id,
            vkz,
            customernumber,
            templateid,
            devicecategory,
            deviceownership,
            ont_provider,
            installationservice,
            houseconnectionprice,
            client,
            customer_businessname,
            customer_salutation,
            customer_title,
            customer_name_first,
            customer_name_last,
            customer_birthdate,
            customer_email,
            customer_residentstatus,
            customer_phone_countrycode,
            customer_phone_areacode,
            customer_phone_number, 
         -- customer_password  -- entfernt 2025-01-21
           -- "Providerwechsel" ist ein abgeleitetes Feld, daher nehmen wir hier nicht [true|false]: 
            case
                when providerchg_current_provider is null then
                    0
                else
                    1
            end as providerwechsel,
            providerchg_current_provider,
            providerchg_owner_salutation,
            providerchg_owner_name_last,
            providerchg_owner_name_first,
            providerchg_keep_phone_number,
            providerchg_phone_countrycode,
            providerchg_phone_areacode,
            providerchg_phone_number,
            account_holder,
            account_sepamandate,
            account_iban, 
         --   install_addr_street, 
         --   install_addr_housenumber, 
         --   install_addr_zipcode, 
         --   install_addr_city, 
         --   install_addr_addition, 
         --   install_addr_country, 
           --2022-08-17 neu: --------------- 
            customer_prev_addr_street,
            customer_prev_addr_housenumber,
            customer_prev_addr_addition,
            customer_prev_addr_zipcode,
            customer_prev_addr_city,
            customer_prev_addr_country, 
           --------------------------------- 
            houseserialnumber,
            prop_owner_role,
            prop_residential_unit,
            landlord_legalform,
            landlord_businessorname,
            landlord_salutation,
            landlord_title,
            landlord_name_first,
            landlord_name_last,
            landlord_addr_street,
            landlord_addr_housenumber,
            landlord_addr_zipcode,
            landlord_addr_city,
            landlord_addr_addition,
            landlord_addr_country,
            landlord_email,
            landlord_phone_countrycode,
            landlord_phone_areacode,
            landlord_phone_number,
            landlord_agreed,
            summ_precontractinformation,
            summ_generaltermsandconditions,
            summ_waiverightofrevocation,
            summ_emailmarketing,
            summ_phonemarketing,
            summ_smsmmsmarketing,
            summ_mailmarketing,
            summ_ordersummaryfileid,
            state,
            customer_upd_email,
            is_new_customer,
            created,
            last_modified,
            version,
            changed_by,
            process_lock,
            process_lock_last_modified, 
            -- neu 2023-07-18: 
            cancelled_by,
            cancel_reason,
            cancel_date,
            siebel_order_number,
            siebel_order_rowid,
            siebel_ready,
            service_plus_email, -- @FTTH-5002
            wholebuy_partner,
            manual_transfer,
            technology,
            -- neu 2024-08-21:
            connectivity_id,              -- @ticket FTTH-3727
            rt_contact_data_ticket_id,    -- @ticket FTTH-3727
            landlord_information_required, -- @ticket FTTH-3727
            -- neu 2024-08-23 @ticket FTTH-3711:
            customer_upd_phone_countrycode, -- /////// war: POV_?
            customer_upd_phone_areacode,
            customer_upd_phone_number,
            update_customer_in_siebel,
            home_id,
            account_id,
            availability_date,
            customer_status,  -- @ticket FTTH-5772
            router_shipping  -- @ticket FTTH-6231
            -- ... @SYNC#07
        into
            pov_uuid,
            pov_vkz,
            pov_kundennummer,
            pov_promotion,
            pov_router_auswahl,
            pov_router_eigentum,
            pov_ont_provider,
            pov_installationsservice,
            pov_haus_anschlusspreis,
            pov_mandant,
            pov_firmenname,
            pov_anrede,
            pov_titel,
            pov_vorname,
            pov_nachname,
            pod_geburtsdatum,
            pov_email,
            pov_wohndauer,
            pov_laendervorwahl,
            pov_vorwahl,
            pov_telefon, 
         --   pov_passwort, 
            pov_providerwechsel,
            pov_providerw_aktueller_anbieter,
            pov_providerw_anmeldung_anrede,
            pov_providerw_anmeldung_nachname,
            pov_providerw_anmeldung_vorname,
            pov_providerw_nummer_behalten,
            pov_providerw_laendervorwahl,
            pov_providerw_vorwahl,
            pov_providerw_telefon,
            pov_kontoinhaber,
            pov_sepa,
            pov_iban, 
         --   pov_anschluss_strasse, 
         --   pov_anschluss_hausnr, 
         --   pov_anschluss_plz, 
         --   pov_anschluss_ort, 
         --   pov_anschluss_zusatz, 
         --   pov_anschluss_land, 
           --2022-08-17 neu:----------------------- 
            pov_voradresse_strasse,
            pov_voradresse_hausnr,
            pov_voradresse_zusatz,
            pov_voradresse_plz,
            pov_voradresse_ort,
            pov_voradresse_land, 
           ---------------------------------------- 
            pov_haus_lfd_nr,
            pov_gee_rolle,
            pov_anzahl_we,
            pov_vermieter_rechtsform,
            pov_vermieter_firmenname,
            pov_vermieter_anrede,
            pov_vermieter_titel,
            pov_vermieter_vorname,
            pov_vermieter_nachname,
            pov_vermieter_strasse,
            pov_vermieter_hausnr,
            pov_vermieter_plz,
            pov_vermieter_ort,
            pov_vermieter_zusatz,
            pov_vermieter_land,
            pov_vermieter_email,
            pov_vermieter_laendervorwahl,
            pov_vermieter_vorwahl,
            pov_vermieter_telefon,
            pov_vermieter_einverstaendnis,
            pov_bestaetigung_vzf,
            pov_zustimmung_agb,
            pov_zustimmung_widerruf,
            pov_opt_in_email,
            pov_opt_in_telefon,
            pov_opt_in_sms_mms,
            pov_opt_in_post,
            pov_vertragszusammenfassung,
            pov_status,
            pov_customer_upd_email,
            pov_is_new_customer,
            pod_created,
            pod_last_modified,
            pov_version,
            pov_changed_by,
            pov_process_lock,
            pod_process_lock_last_modified, 
            -- neue 2023-07-18: 
            pov_storno_username,
            pov_storno_grund,
            pod_storno_datum,
            pov_siebel_order_number,
            pov_siebel_order_rowid,
            pov_siebel_ready,
            pov_service_plus_email, -- @FTTH-5002
            pov_wholebuy_partner,
            pov_manual_transfer,
            pov_technology,
            -- neu 2024-08-21
            pov_connectivity_id,                -- @ticket FTTH-3727
            pov_rt_contact_data_ticket_id,      -- @ticket FTTH-3727
            pov_landlord_information_required,  -- @ticket FTTH-3727
            -- neu 2024-08-23 @ticket FTTH-3711:
            pov_customer_upd_phone_countrycode,
            pov_customer_upd_phone_areacode,
            pov_customer_upd_phone_number,
            pov_update_customer_in_siebel,
            pov_home_id,                        -- @ticket FTTH-4134
            pov_account_id,                      -- @ticket FTTH-4470
            pod_availability_date,          -- @ticket FTTH-3880
            pov_customer_status, -- @ticket FTTH-5772
            pov_router_shipping -- @ticket FTTH-6231
            -- ...  @SYNC#08
        from
            ftth_ws_sync_preorders
        where
            id = piv_uuid;

    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end parse_preorder_synchronized; 



  /** 
  * Liefert für den Fall, dass eine Auftragssperre vorliegt (processLock=true) 
  * das Datum der letzten Änderung dieser Sperre zurück, ansonsten NULL 
  * 
  * @usage Durch Prüfen des zurückgegebenen Datums kann ermittelt werden, 
  * ob und seit eine Sperre auf dem Auftrag besteht. 
  * 
  * @param piv_uuid ID des Auftrags 
  * @param piv_ws_modus ONLINE_AND_OFFLINE: Die Prozedur versucht zunächst, die Lock-Information live vom Webservice 
  * zu holen; wenn dieser nicht verfügbar ist, holt die Prozedur 
  * die Daten ersatzweise aus der Tabelle FTTH_WS_SYNC_PREORDERS. 
  * ONLINE: Wenn der Webservice zur Zeit des Aufrufs nicht verfügbar ist, 
  * dann wirft diese Prozedur eine Exception. 
  * OFFLINE: Die Prozedur greift sofort auf die Tabelle FTTH_WS_SYNC_PREORDERS zu, 
  * ohne den Webservice vorher abzufragen. 
  * 
  * @return Wert des Feldes processLockLastModified, jedoch nur sofern processLock gesetzt ist 
  * 
  * @raise Alle Exceptions (sowohl vom Webservice als auch aufgrund einer Tabellenabfrage) 
  * werden geraised. Geloggt wird nur, wenn ein anderer Fehler als 404 bzw. 
  * NO_DATA_FOUND auftritt. 
  * 
  * @usage Bei der Synchronisierung in die Tabelle FTTH_WS_SYNC_PREORDERS wird offenbar 
  * der Timestamp von processLockLastModified nach der dritten Stelle abgeschnitten, 
  * was nicht dramatisch ist, jedoch einen Vergleich zwischen ONLINE und OFFLINE-Wert 
  * verkomplizieren könnte. 
  */
    function fd_process_lock (
        piv_uuid     in ftth_ws_sync_preorders.id%type,
        piv_ws_modus in varchar2 default c_ws_modus_online_and_offline
    ) return timestamp with local time zone is

        v_preorder_json              clob;
        v_process_lock               ftth_ws_sync_preorders.process_lock%type;
        v_process_lock_last_modified ftth_ws_sync_preorders.process_lock_last_modified%type; 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name              constant logs.routine_name%type := 'fd_process_lock';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_uuid', piv_uuid);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin 
    -- Plausi: Überflüssigen Webservice-Call vermeiden 
        if piv_uuid is null then
            return null;
        end if;
        if piv_ws_modus in ( c_ws_modus_online, c_ws_modus_online_and_offline ) then 
      -- Zuerst beim Webservice anrufen: 
            begin
                v_preorder_json := fc_preorders_wsget(piv_uuid => piv_uuid); 
        -- Auswertung der Webservice-Antwort 
                with preorder_json_table as (
                    select
                        v_preorder_json as preorder_json
                    from
                        dual
                )
                select
                    lock_query.process_lock,
                    lock_query.process_lock_last_modified
                into
                    v_process_lock,
                    v_process_lock_last_modified
                from
                    preorder_json_table,
                    json_table ( preorder_json, '$'
                            columns (
                                process_lock varchar2 ( 5 ) path "processLock", -- /// Achtung: auch in parse_preorder Anführungszeichen setzen, damit Formatierung vom SQL Developer nicht den camelCase zerstören kann 
                                process_lock_last_modified timestamp with local time zone path "processLockLastModified"
                            )
                        )
                    as lock_query;

            exception
                when e_ws_statuscode_not_found then
                    raise; -- aktueller geht es nicht: Der Auftrag wurde "live" nicht mehr gefunden 
                when others then 
          -- sonstige technische Fehler, insbesondere "Webservice nicht erreichbar" 
                    if piv_ws_modus = c_ws_modus_online then
                        raise; -- Offline soll nicht probiert werden 
                    else 
            -- Bei Fehlern das Lock offline lesen 
                        return fd_process_lock(piv_uuid, c_ws_modus_offline); -- Rekursion 
                    end if;
            end; 
      ---------------------------------------- 
        else 
      -- C_WS_MODUS_OFFLINE oder rekursiv 
            select
                process_lock,
                process_lock_last_modified
            into
                v_process_lock,
                v_process_lock_last_modified
            from
                ftth_ws_sync_preorders
            where
                id = piv_uuid; 
      ---------------------------------------- 
        end if;

        return
            case
                when v_process_lock = json_true then
                    v_process_lock_last_modified
                else null
            end;
    exception
        when e_ws_statuscode_not_found then 
      -- online: 
      -- Das aufrufende Programm entscheidet selbst, 
      -- ob dies als Fehler geloggt werden muss 
            raise;
        when no_data_found then 
      -- offline: 
      -- Das aufrufende Programm entscheidet selbst, 
      -- ob dies als Fehler geloggt werden muss 
            raise;
        when others then 
      -- alle anderen Fehler sind unerwartet und werden geloggt: 
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end fd_process_lock; 



  /** @deprecated mit @ticket FTTH-4641

  * Liest die aktuellen Adressendaten aus der STRAV ein. 
  * Für den unwahrscheinlichen Fall, dass die STRAV keine Daten zurückliefern kann, 
  * werden die Eingangswerte der IN OUT-Parameter zurückgegeben (beide Datenquellen werden aber 
  * niemals "gemischt": Es wird beispielsweise nicht geschehen, dass eine Hausnummer aus der STRAV 
  * mit einem Hausnummern-Zusatz aus dem Preorder-Buffer kombiniert wird) 
  * 
  * @param pin_haus_lfd_nr [IN ] ID der Adressen (im Fall des Glascontainers: Installationsadresse) 
  * @param piov_strasse [IN OUT] Straße 
  * @param piov_hausnr [IN OUT] Hausnummer 
  * @param piov_zusatz [IN OUT] Hausnummer-Zusatz (z.B. 'a-f') 
  * @param piov_plz [IN OUT] Postleitzahl 
  * @param piov_ort [IN OUT] Ort 
  * 
  * @ticket FTTH-1246 
  * @usage In der Auftrags-Einzelansicht wird zunächst der komplette Datensatz aus dem Preorderbuffer gelesen. 
  * Anschließend wird die hier ermittelte Adresse aus der STRAV, falls vorhanden, darübergelegt. 
  * Dieses Verfahren wird in der Auftragsliste (für Admins) nicht eingesetzt - dort steht die 
  * Adresse, wie sie im Preorderbuffer gespeichert ist. 
  * @ticket 1757: Es stellt sich heraus, dass im Preorderbuffer die Spalte INSTALL_ADDR_ADDITION 
  * niemals gefüllt ist, sondern der Hausnummerzusatz bereits im Feld Hausnummer erfasst wird. 

  PROCEDURE p_get_strav_adresse 
  ( 
    pin_haus_lfd_nr       IN INTEGER 
   ,piov_str              IN OUT VARCHAR2 
   ,piov_hnr_kompl        IN OUT VARCHAR2 
   ,piov_plz              IN OUT VARCHAR2 
   ,piov_ort_kompl        IN OUT VARCHAR2 
   ,piov_adresse_kompl    IN OUT VARCHAR2 -- @ticket FTTH-4641
  ) IS 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
    cv_routine_name CONSTANT logs.routine_name%TYPE := 'p_strav_adresse_holen'; 
    FUNCTION fcl_params RETURN logs.message%TYPE IS 
    BEGIN 
      pck_format.p_add('pin_haus_lfd_nr' 
                      ,pin_haus_lfd_nr); 
      RETURN pck_format.fcl_params(cv_routine_name); 
    END fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
  BEGIN 
    IF G_USE_STRAV THEN 
      PCK_GLASCONTAINER_EXT.p_get_strav_adresse( 
        pin_haus_lfd_nr    => pin_haus_lfd_nr 
       ,piov_str           => piov_str 
       ,piov_hnr_kompl     => piov_hnr_kompl 
       ,piov_plz           => piov_plz 
       ,piov_ort_kompl     => piov_ort_kompl
       ,piov_adresse_kompl => piov_adresse_kompl
      ); 
    END IF; 
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
      NULL; -- Dann werden sämtliche Felder mit den Input-Werten ausgeliefert. 
    WHEN OTHERS THEN 
      pck_logs.p_error( 
              pic_message      => fcl_params() 
             ,piv_routine_name => qualified_name(cv_routine_name) 
             ,piv_scope        => G_SCOPE 
            ); 
      RAISE; 
  END p_get_strav_adresse; 
  */  

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
  * @param pov_json                  (optional): Das originale JSON des Auftrags kann hier zurückgeliefert werden, 
  *                                  insbesondere nützlich beim Entwickeln und Debuggen 
  * 
  * 
  * @date 2022-11-23: Bei Bestandskunden werden Vorname, Nachname aus Siebel sowie Adresse aus STRAV angereichert 
  */
    procedure p_get_auftragsdaten (
        piv_uuid                           in varchar2,
        piv_ws_modus                       in varchar2 -- ONLINE|ONLINE_AND_OFFLINE|OFFLINE war: pib_read_sync_on_ws_error 
        ,
        pib_synchronize                    in boolean,
        pib_show_json                      in boolean default false 
    --------------------------------------------- 
        ,
        pov_display_kopfdaten              out varchar2,
        pon_sqlcode                        out integer,
        pov_sqlerrm                        out varchar2,
        poc_json_payload                   out clob -- neu 2023-08-24 
    --------------------------------------------- 
        ,
        pov_vkz                            out varchar2,
        pov_kundennummer                   out varchar2,
        pov_promotion                      out varchar2,
        pov_router_auswahl                 out varchar2,
        pov_router_eigentum                out varchar2,
        pov_ont_provider                   out varchar2 -- @ticket FTTH-3097 
        ,
        pov_installationsservice           out varchar2,
        pov_haus_anschlusspreis            out varchar2 -- /// OUT NUMBER?
        ,
        pov_mandant                        out varchar2,
        pov_firmenname                     out varchar2,
        pov_anrede                         out varchar2,
        pov_titel                          out varchar2,
        pov_vorname                        out varchar2,
        pov_nachname                       out varchar2,
        pod_geburtsdatum                   out date,
        pov_email                          out varchar2,
        pov_wohndauer                      out varchar2,
        pov_laendervorwahl                 out varchar2,
        pov_vorwahl                        out varchar2,
        pov_telefon                        out varchar2 
--  pov_passwort             OUT VARCHAR2, -- entfernt 2025-01-21
        , 
    -- neu 2022-06-14: 
        pov_providerwechsel                out varchar2,
        pov_providerw_aktueller_anbieter   out varchar2,
        pov_providerw_anmeldung_anrede     out varchar2,
        pov_providerw_anmeldung_nachname   out varchar2,
        pov_providerw_anmeldung_vorname    out varchar2,
        pov_providerw_nummer_behalten      out varchar2,
        pov_providerw_laendervorwahl       out varchar2,
        pov_providerw_vorwahl              out varchar2,
        pov_providerw_telefon              out varchar2, 
    ------------------------------------------ 
        pov_kontoinhaber                   out varchar2,
        pov_sepa                           out varchar2,
        pov_iban                           out varchar2,
        pov_anschluss_str                  out varchar2 -- @ticket FTTH-4641
        ,
        pov_anschluss_hnr_kompl            out varchar2 -- @ticket FTTH-4641
        ,
        pov_anschluss_gebaeudeteil         out varchar2 -- @ticket FTTH-4641
        ,
        pov_anschluss_plz                  out varchar2 -- @ticket FTTH-4641
        ,
        pov_anschluss_ort_kompl            out varchar2 -- @ticket FTTH-4641
        ,
        pov_anschluss_land                 out varchar2 -- @ticket FTTH-4641 @deprecated ///// existiert nicht in der STRAV
        ,
        pov_anschluss_adresse_kompl        out varchar2 -- @ticket FTTH-4641
    --2022-08-17 neu:----------------------- 
        ,
        pov_voradresse_strasse             out varchar2,
        pov_voradresse_hausnr              out varchar2,
        pov_voradresse_zusatz              out varchar2,
        pov_voradresse_plz                 out varchar2,
        pov_voradresse_ort                 out varchar2,
        pov_voradresse_land                out varchar2, 
    ---------------------------------------- 
        pov_haus_lfd_nr                    out varchar2,
        pov_gee_rolle                      out varchar2,
        pov_anzahl_we                      out varchar2,
        pov_vermieter_rechtsform           out varchar2,
        pov_vermieter_firmenname           out varchar2,
        pov_vermieter_anrede               out varchar2,
        pov_vermieter_titel                out varchar2,
        pov_vermieter_vorname              out varchar2,
        pov_vermieter_nachname             out varchar2,
        pov_vermieter_strasse              out varchar2,
        pov_vermieter_hausnr               out varchar2,
        pov_vermieter_plz                  out varchar2,
        pov_vermieter_ort                  out varchar2,
        pov_vermieter_zusatz               out varchar2,
        pov_vermieter_land                 out varchar2,
        pov_vermieter_email                out varchar2,
        pov_vermieter_laendervorwahl       out varchar2,
        pov_vermieter_vorwahl              out varchar2,
        pov_vermieter_telefon              out varchar2,
        pov_vermieter_einverstaendnis      out varchar2,
        pov_bestaetigung_vzf               out varchar2,
        pov_zustimmung_agb                 out varchar2,
        pov_zustimmung_widerruf            out varchar2,
        pov_opt_in_email                   out varchar2,
        pov_opt_in_telefon                 out varchar2,
        pov_opt_in_sms_mms                 out varchar2,
        pov_opt_in_post                    out varchar2,
        pov_vertragszusammenfassung        out varchar2,
        pov_status                         out varchar2,
        pov_customer_upd_email             out varchar2,
        pov_is_new_customer                out varchar2,
        pod_created                        out date,
        pod_last_modified                  out date,
        pov_version                        out integer,
        pov_changed_by                     out varchar2 -- neu 2023-06-20 
        ,
        pov_process_lock                   out varchar2,
        pod_process_lock_last_modified     out date 
   -- neu 2023-06-14: 
        ,
        pov_storno_username                out varchar2,
        pov_storno_grund                   out varchar2,
        pod_storno_datum                   out date,
        pov_siebel_order_number            out varchar2 -- neu 2023-07-05 
        ,
        pov_siebel_order_rowid             out varchar2 -- neu 2023-07-05 
        ,
        pov_siebel_ready                   out varchar2 -- neu 2023-07-18  
   -- neu 2023-08-16: 
        ,
        pov_service_plus_email             out varchar2 -- @FTTH-5002
   -- neu 2023-11-30 @ticket FTTH-2901: 
        ,
        pov_wholebuy_partner               out varchar2 
   -- neu 2023-11-30 @ticket FTTH-2996: 
        ,
        pov_manual_transfer                out varchar2,
        pov_technology                     out varchar2 -- neu 2024-07-09 @ticket FTTH-3747. 2024-09-10: Das entsprechende Item heißt ab heute P20_TECHNOLOGIE
   -- neu 2024-08-21 @ticket FTTH-3727
        ,
        pov_connectivity_id                out varchar2,
        pov_rt_contact_data_ticket_id      out varchar2,
        pov_rt_contact_data_ticket_link    out varchar2 -- @ticket FTTH-4220
        ,
        pov_landlord_information_required  out varchar2
   -- neu 2024-08-23 @ticket FTTH-3711:
        ,
        pov_customer_upd_phone_countrycode out varchar2,
        pov_customer_upd_phone_areacode    out varchar2,
        pov_customer_upd_phone_number      out varchar2,
        pov_update_customer_in_siebel      out varchar2,
        pov_home_id                        out varchar2 -- @ticket FTTH-4134
        ,
        pov_account_id                     out varchar2 -- @ticket FTTH-4470
        ,
        pod_availability_date              out date     -- @ticket FTTH-3880
        ,
        pov_customer_status                out varchar2 -- @ticket FTTH-5772
        ,
        pov_router_shipping                out varchar2 -- @ticket FTTH-6231
   -- ...  @SYNC#09
    ) is

        v_preorder_json clob;
        v_void_uuid     varchar2(200); 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'p_get_auftragsdaten';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_uuid', piv_uuid);
            pck_format.p_add('piv_ws_modus', piv_ws_modus);
            pck_format.p_add('pib_synchronize', pib_synchronize);
            pck_format.p_add('pib_show_json', pib_show_json);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        << zwei_versuche >> begin
            if piv_ws_modus in ( c_ws_modus_online, c_ws_modus_online_and_offline ) then 
        -- Normalzustand 
                begin
                    v_preorder_json := fc_preorders_wsget(piv_uuid => piv_uuid); 

          -- optional: Anzeigemöglichkeit der JSON-Response in der APEX-Seite 
          -- (nur für Entwickler): 
                    if pib_show_json then
                        poc_json_payload := v_preorder_json;
                    end if;
                exception
                    when others then
                        pon_sqlcode := sqlcode;
                        pov_sqlerrm := sqlerrm;
                end;

                if pon_sqlcode is null then 
          -- Erfolg bei wsget: 
                    parse_preorder(
                        pic_preorder_json                  => v_preorder_json,
                        pov_uuid                           => v_void_uuid,
                        pov_vkz                            => pov_vkz,
                        pov_kundennummer                   => pov_kundennummer,
                        pov_promotion                      => pov_promotion,
                        pov_router_auswahl                 => pov_router_auswahl,
                        pov_router_eigentum                => pov_router_eigentum,
                        pov_ont_provider                   => pov_ont_provider,
                        pov_installationsservice           => pov_installationsservice,
                        pov_haus_anschlusspreis            => pov_haus_anschlusspreis,
                        pov_mandant                        => pov_mandant,
                        pov_firmenname                     => pov_firmenname,
                        pov_anrede                         => pov_anrede,
                        pov_titel                          => pov_titel,
                        pov_vorname                        => pov_vorname,
                        pov_nachname                       => pov_nachname,
                        pod_geburtsdatum                   => pod_geburtsdatum,
                        pov_email                          => pov_email,
                        pov_wohndauer                      => pov_wohndauer,
                        pov_laendervorwahl                 => pov_laendervorwahl,
                        pov_vorwahl                        => pov_vorwahl,
                        pov_telefon                        => pov_telefon 
                     -- ,pov_passwort                       => pov_passwort -- entfernt 2025-01-21
                        ,
                        pov_providerwechsel                => pov_providerwechsel,
                        pov_providerw_aktueller_anbieter   => pov_providerw_aktueller_anbieter,
                        pov_providerw_anmeldung_anrede     => pov_providerw_anmeldung_anrede,
                        pov_providerw_anmeldung_nachname   => pov_providerw_anmeldung_nachname,
                        pov_providerw_anmeldung_vorname    => pov_providerw_anmeldung_vorname,
                        pov_providerw_nummer_behalten      => pov_providerw_nummer_behalten,
                        pov_providerw_laendervorwahl       => pov_providerw_laendervorwahl,
                        pov_providerw_vorwahl              => pov_providerw_vorwahl,
                        pov_providerw_telefon              => pov_providerw_telefon,
                        pov_kontoinhaber                   => pov_kontoinhaber,
                        pov_sepa                           => pov_sepa,
                        pov_iban                           => pov_iban 
                         --2022-08-17 neu:----------------------- 
                        ,
                        pov_voradresse_strasse             => pov_voradresse_strasse,
                        pov_voradresse_hausnr              => pov_voradresse_hausnr,
                        pov_voradresse_zusatz              => pov_voradresse_zusatz,
                        pov_voradresse_plz                 => pov_voradresse_plz,
                        pov_voradresse_ort                 => pov_voradresse_ort,
                        pov_voradresse_land                => pov_voradresse_land, 
                         ---------------------------------------- 
                        pov_haus_lfd_nr                    => pov_haus_lfd_nr,
                        pov_gee_rolle                      => pov_gee_rolle,
                        pov_anzahl_we                      => pov_anzahl_we,
                        pov_vermieter_rechtsform           => pov_vermieter_rechtsform,
                        pov_vermieter_firmenname           => pov_vermieter_firmenname,
                        pov_vermieter_anrede               => pov_vermieter_anrede,
                        pov_vermieter_titel                => pov_vermieter_titel,
                        pov_vermieter_vorname              => pov_vermieter_vorname,
                        pov_vermieter_nachname             => pov_vermieter_nachname,
                        pov_vermieter_strasse              => pov_vermieter_strasse,
                        pov_vermieter_hausnr               => pov_vermieter_hausnr,
                        pov_vermieter_plz                  => pov_vermieter_plz,
                        pov_vermieter_ort                  => pov_vermieter_ort,
                        pov_vermieter_zusatz               => pov_vermieter_zusatz,
                        pov_vermieter_land                 => pov_vermieter_land,
                        pov_vermieter_email                => pov_vermieter_email,
                        pov_vermieter_laendervorwahl       => pov_vermieter_laendervorwahl,
                        pov_vermieter_vorwahl              => pov_vermieter_vorwahl,
                        pov_vermieter_telefon              => pov_vermieter_telefon,
                        pov_vermieter_einverstaendnis      => pov_vermieter_einverstaendnis,
                        pov_bestaetigung_vzf               => pov_bestaetigung_vzf,
                        pov_zustimmung_agb                 => pov_zustimmung_agb,
                        pov_zustimmung_widerruf            => pov_zustimmung_widerruf,
                        pov_opt_in_email                   => pov_opt_in_email,
                        pov_opt_in_telefon                 => pov_opt_in_telefon,
                        pov_opt_in_sms_mms                 => pov_opt_in_sms_mms,
                        pov_opt_in_post                    => pov_opt_in_post,
                        pov_vertragszusammenfassung        => pov_vertragszusammenfassung,
                        pov_status                         => pov_status,
                        pov_customer_upd_email             => pov_customer_upd_email, -- neu 2022-09-13 
                        pov_is_new_customer                => pov_is_new_customer, -- neu 2022-09-13 
                        pod_created                        => pod_created,
                        pod_last_modified                  => pod_last_modified,
                        pov_version                        => pov_version,
                        pov_changed_by                     => pov_changed_by -- neu 2023-06-20 
                        ,
                        pov_process_lock                   => pov_process_lock,
                        pod_process_lock_last_modified     => pod_process_lock_last_modified 
                        ---- neu 2023-06-14: 
                        ,
                        pov_storno_username                => pov_storno_username,
                        pov_storno_grund                   => pov_storno_grund,
                        pod_storno_datum                   => pod_storno_datum,
                        pov_siebel_order_number            => pov_siebel_order_number,
                        pov_siebel_order_rowid             => pov_siebel_order_rowid,
                        pov_siebel_ready                   => pov_siebel_ready 
                        -- neu 2023-08-16: 
                        ,
                        pov_service_plus_email             => pov_service_plus_email -- @FTTH-5002
                        -- neu 2023-11-30: 
                        ,
                        pov_wholebuy_partner               => pov_wholebuy_partner,
                        pov_manual_transfer                => pov_manual_transfer,
                        pov_technology                     => pov_technology
                        -- neu 2024-08-21 @ticket FTTH-3727
                        ,
                        pov_connectivity_id                => pov_connectivity_id,
                        pov_rt_contact_data_ticket_id      => pov_rt_contact_data_ticket_id,
                        pov_landlord_information_required  => pov_landlord_information_required
                        -- neu 2024-08-23 @ticket FTTH-3711:
                        ,
                        pov_customer_upd_phone_countrycode => pov_customer_upd_phone_countrycode,
                        pov_customer_upd_phone_areacode    => pov_customer_upd_phone_areacode,
                        pov_customer_upd_phone_number      => pov_customer_upd_phone_number,
                        pov_update_customer_in_siebel      => pov_update_customer_in_siebel,
                        pov_home_id                        => pov_home_id,
                        pov_account_id                     => pov_account_id,
                        pod_availability_date              => pod_availability_date,
                        pov_customer_status                => pov_customer_status -- @ticket FTTH-5772
                        ,
                        pov_router_shipping                => pov_router_shipping
                        -- ... @SYNC#10
                    );                            

          -- @ticket FTTH-4220:
                    if pov_rt_contact_data_ticket_id is not null then
                        declare
                            link_rt constant varchar2(1000) := -- leider hartkodiert:
                                case db_name
                                    when 'NMC' then
                                        'https://rt.netcologne.de' -- Produktion!
                                   -- in allen anderen Umgebungen möchte Nusret
                                   -- immer in die Development-Umgebung verzweigen:
                                    else 'https://rt-devel.netcologne.de'
                                   -- Testumgebungs-Link wird ignoriert:
                                   -- https://rt-test.netcologne.de
                                end;
                -- die eigentlich korrekte Ermittlung des RT-Links wäre wie folgt, führt hier allerdings wegen
                -- der gewünschten Verzweigungslogik nicht zum Ziel:
                --     SELECT MAX(v_wert1)
                --       INTO LINK_RT
                --       FROM params
                --      WHERE UPPER(pv_key1) = 'RT'
                --        AND pv_key2 = 'RT: URL'
                        begin
                            pov_rt_contact_data_ticket_link := fv_a_href(
                                piv_href   => rtrim(link_rt, '/')
                                            || '/Ticket/Display.html?id='
                                            || pov_rt_contact_data_ticket_id,
                                piv_text   => pov_rt_contact_data_ticket_id,
                                piv_target => '_blank',
                                piv_title  => 'Request Tracker für dieses Ticket in einem neuen Browserfenster öffnen'
                            );

                        end;

                    end if;

          -- 2023-08-24 neu hier: Dies löst den APEX-Prozess "Auftragsdaten synchronisieren" ab, der 
          -- überflüssigerweise als einzelnes Artefakt in Prozessbaum hing und unter unglücklichen Umständen 
          -- auch mal nicht ausgeführt wurde: 
                    if pib_synchronize then
                        p_auftragsdaten_synchronisieren(piv_json => v_preorder_json); 
            -- ///@refactorn: Es ist doch eigentlich doppelt gemoppelt, wenn das JSON hier zum 2. Mal geparst wird. 
            -- Besser wäre es, wenn am Ende des Prozesses, wenn alle Felder geparst sind, genau deren Inhalte 
            -- in die FTTH_WS_SYNC_PREORDERS eingetragen würden. Das würde sämtliche Inkonsistenzen verhindern. 
            -- Dieser Synchronisierungsvorgang aktualisiert auch den Eintrag in POB_ADRESSEN, diehe Trigger FTTH_WS_SYNC_PREORDERS_BIU
            -- @ticket FTTH-4641: Es werden sowohl die Daten im POB als auch in POB_ADRESSEN synchronisiert          
                    end if; 

          -- Adresse vorrangig aus POB_ADRESSEN oder aus STRAV hinzufügen:
                    p_get_adresse(
                        pin_haus_lfd_nr   => pov_haus_lfd_nr,
                        pov_str           => pov_anschluss_str,
                        pov_hnr_kompl     => pov_anschluss_hnr_kompl,
                        pov_gebaeudeteil  => pov_anschluss_gebaeudeteil,
                        pov_plz           => pov_anschluss_plz,
                        pov_ort_kompl     => pov_anschluss_ort_kompl,
                        pov_adresse_kompl => pov_anschluss_adresse_kompl
                    );

                    if pov_process_lock = json_true then
                        pon_sqlcode := c_order_is_locked;
                        pov_sqlerrm := 'Der Auftrag wird gerade verarbeitet und ist seit '
                                       ||
                            case
                                when trunc(pod_process_lock_last_modified) < trunc(sysdate) then
                                    to_char(pod_process_lock_last_modified, 'FMDay')
                                    || ', '
                                    || to_char(pod_process_lock_last_modified, 'DD.MM.')
                                else 'heute'
                            end
                                       || ' ('
                                       || to_char(pod_process_lock_last_modified, 'HH24:MI')
                                       || ' Uhr)'
                                       || ' gesperrt. Änderungen am Auftrag können erst nach Ablauf der Sperre gespeichert werden.';

                    end if; 
          -- Anreichern: 
                    if pov_is_new_customer = 'false' then
                        p_get_siebel_kopfdaten(
                            piv_kundennummer  => pov_kundennummer,
                            piov_vorname      => pov_vorname,
                            piov_nachname     => pov_nachname,
                            piod_geburtsdatum => pod_geburtsdatum,
                            piov_anrede       => pov_anrede,
                            piov_titel        => pov_titel,
                            piov_firmenname   => pov_firmenname
                        );
                    end if; 

          -- zusätzliche Angaben ermitteln: 
                    pov_display_kopfdaten := fv_kopfdaten(
                        pin_haus_lfd_nr             => pov_haus_lfd_nr,
                        piv_kundennummer            => pov_kundennummer,
                        piv_vorname                 => pov_vorname,
                        piv_nachname                => pov_nachname,
                        pid_geburtsdatum            => pod_geburtsdatum 
                                               /*
                                               ,piv_anschluss_strasse => pov_anschluss_strasse 
                                               ,piv_anschluss_hausnr  => rtrim(pov_anschluss_hausnr || ' ' || 
                                                                               pov_anschluss_zusatz) -- @ticket 1757 
                                               ,piv_anschluss_plz     => pov_anschluss_plz 
                                               ,piv_anschluss_ort     => pov_anschluss_ort 
                                               */,
                        piv_adresse_kompl           => pov_anschluss_adresse_kompl,
                        piv_auftragseingang         => to_char(pod_created, 'DD.MM.YYYY HH24:MI'),
                        pib_link_siebel_kundenmaske => true -- @ticket FTTH-4470
                    ); 
          ------- 
                    return; 
          ------- 
                else 
          -- kein Erfolg bei wsget 
                    if piv_ws_modus = c_ws_modus_online -- also OFFLINE ausdrücklich nicht gewünscht 
                     then 
            -- ///@todo Nicht-Verfügbarkeit des Webservices protokollieren 
                        raise_application_error(pon_sqlcode, pov_sqlerrm);
                    end if;
                end if; -- Erfolg oder nicht bei wsget; 
            end if; -- /Normalzustand: kein Mock 

            << synchrondaten_holen >> 
      -- (Hier ist die Prozedur bereits ausgestiegen, wenn der Aufruf erfolgreich war 
      -- oder ein Problem mit dem Webservice bestand und SYNC-lesen abgelehnt wurde) 

             begin 
        -- Stattdessen versuchen, die zuletzt synchronisierten Daten anzuzeigen: 
                parse_preorder_synchronized(
                    piv_uuid                           => piv_uuid,
                    pov_uuid                           => v_void_uuid,
                    pov_vkz                            => pov_vkz,
                    pov_kundennummer                   => pov_kundennummer,
                    pov_promotion                      => pov_promotion,
                    pov_router_auswahl                 => pov_router_auswahl,
                    pov_router_eigentum                => pov_router_eigentum,
                    pov_ont_provider                   => pov_ont_provider,
                    pov_installationsservice           => pov_installationsservice,
                    pov_haus_anschlusspreis            => pov_haus_anschlusspreis,
                    pov_mandant                        => pov_mandant,
                    pov_firmenname                     => pov_firmenname,
                    pov_anrede                         => pov_anrede,
                    pov_titel                          => pov_titel,
                    pov_vorname                        => pov_vorname,
                    pov_nachname                       => pov_nachname,
                    pod_geburtsdatum                   => pod_geburtsdatum,
                    pov_email                          => pov_email,
                    pov_wohndauer                      => pov_wohndauer,
                    pov_laendervorwahl                 => pov_laendervorwahl,
                    pov_vorwahl                        => pov_vorwahl,
                    pov_telefon                        => pov_telefon 
                                 --,pov_passwort                       => pov_passwort -- entfernt 2025-01-21
                    ,
                    pov_providerwechsel                => pov_providerwechsel,
                    pov_providerw_aktueller_anbieter   => pov_providerw_aktueller_anbieter,
                    pov_providerw_anmeldung_anrede     => pov_providerw_anmeldung_anrede,
                    pov_providerw_anmeldung_nachname   => pov_providerw_anmeldung_nachname,
                    pov_providerw_anmeldung_vorname    => pov_providerw_anmeldung_vorname,
                    pov_providerw_nummer_behalten      => pov_providerw_nummer_behalten,
                    pov_providerw_laendervorwahl       => pov_providerw_laendervorwahl,
                    pov_providerw_vorwahl              => pov_providerw_vorwahl,
                    pov_providerw_telefon              => pov_providerw_telefon,
                    pov_kontoinhaber                   => pov_kontoinhaber,
                    pov_sepa                           => pov_sepa,
                    pov_iban                           => pov_iban 
                                    --2022-08-17 neu:----------------------- 
                    ,
                    pov_voradresse_strasse             => pov_voradresse_strasse,
                    pov_voradresse_hausnr              => pov_voradresse_hausnr,
                    pov_voradresse_zusatz              => pov_voradresse_zusatz,
                    pov_voradresse_plz                 => pov_voradresse_plz,
                    pov_voradresse_ort                 => pov_voradresse_ort,
                    pov_voradresse_land                => pov_voradresse_land, 
                                    ---------------------------------------- 
                    pov_haus_lfd_nr                    => pov_haus_lfd_nr,
                    pov_gee_rolle                      => pov_gee_rolle,
                    pov_anzahl_we                      => pov_anzahl_we,
                    pov_vermieter_rechtsform           => pov_vermieter_rechtsform,
                    pov_vermieter_firmenname           => pov_vermieter_firmenname,
                    pov_vermieter_anrede               => pov_vermieter_anrede,
                    pov_vermieter_titel                => pov_vermieter_titel,
                    pov_vermieter_vorname              => pov_vermieter_vorname,
                    pov_vermieter_nachname             => pov_vermieter_nachname,
                    pov_vermieter_strasse              => pov_vermieter_strasse,
                    pov_vermieter_hausnr               => pov_vermieter_hausnr,
                    pov_vermieter_plz                  => pov_vermieter_plz,
                    pov_vermieter_ort                  => pov_vermieter_ort,
                    pov_vermieter_zusatz               => pov_vermieter_zusatz,
                    pov_vermieter_land                 => pov_vermieter_land,
                    pov_vermieter_email                => pov_vermieter_email,
                    pov_vermieter_laendervorwahl       => pov_vermieter_laendervorwahl,
                    pov_vermieter_vorwahl              => pov_vermieter_vorwahl,
                    pov_vermieter_telefon              => pov_vermieter_telefon,
                    pov_vermieter_einverstaendnis      => pov_vermieter_einverstaendnis,
                    pov_bestaetigung_vzf               => pov_bestaetigung_vzf,
                    pov_zustimmung_agb                 => pov_zustimmung_agb,
                    pov_zustimmung_widerruf            => pov_zustimmung_widerruf,
                    pov_opt_in_email                   => pov_opt_in_email,
                    pov_opt_in_telefon                 => pov_opt_in_telefon,
                    pov_opt_in_sms_mms                 => pov_opt_in_sms_mms,
                    pov_opt_in_post                    => pov_opt_in_post,
                    pov_vertragszusammenfassung        => pov_vertragszusammenfassung,
                    pov_status                         => pov_status,
                    pov_customer_upd_email             => pov_customer_upd_email, -- neu 2022-09-13 
                    pov_is_new_customer                => pov_is_new_customer, -- neu 2022-09-13 
                    pod_created                        => pod_created,
                    pod_last_modified                  => pod_last_modified,
                    pov_version                        => pov_version,
                    pov_changed_by                     => pov_changed_by,
                    pov_process_lock                   => pov_process_lock,
                    pod_process_lock_last_modified     => pod_process_lock_last_modified 
                                   ---- 
                    ,
                    pov_storno_username                => pov_storno_username,
                    pov_storno_grund                   => pov_storno_grund,
                    pod_storno_datum                   => pod_storno_datum,
                    pov_siebel_order_number            => pov_siebel_order_number,
                    pov_siebel_order_rowid             => pov_siebel_order_rowid,
                    pov_siebel_ready                   => pov_siebel_ready,
                    pov_service_plus_email             => pov_service_plus_email -- @FTTH-5002
                    ,
                    pov_wholebuy_partner               => pov_wholebuy_partner,
                    pov_manual_transfer                => pov_manual_transfer,
                    pov_technology                     => pov_technology
                                    -- neu 2024-08-21 @ticket FTTH-3727
                    ,
                    pov_connectivity_id                => pov_connectivity_id,
                    pov_rt_contact_data_ticket_id      => pov_rt_contact_data_ticket_id,
                    pov_landlord_information_required  => pov_landlord_information_required 
                                   -- neu 2024-08-23 @ticket FTTH-3711:
                    ,
                    pov_customer_upd_phone_countrycode => pov_customer_upd_phone_countrycode,
                    pov_customer_upd_phone_areacode    => pov_customer_upd_phone_areacode,
                    pov_customer_upd_phone_number      => pov_customer_upd_phone_number,
                    pov_update_customer_in_siebel      => pov_update_customer_in_siebel,
                    pov_home_id                        => pov_home_id,
                    pov_account_id                     => pov_account_id,
                    pod_availability_date              => pod_availability_date -- @ticket FTTH-3880
                    ,
                    pov_customer_status                => pov_customer_status -- @ticket FTTH-5772
                    ,
                    pov_router_shipping                => pov_router_shipping -- @ticket FTTH-6321
                                   -- ...  @SYNC#11
                ); 
        ----------------------------------------------------------------- 
        -- Fehlende oder veraltete Daten aus externen Systemen anreichern 
        ----------------------------------------------------------------- 
        -- Für Bestandskunden holen wir aus Siebel die Kopfdaten, 
        -- die im Preorder-Buffer fehlen: 
                if pov_is_new_customer = 'false' -- ////@todo: @ticket FTTH-1246 verlangt das auch für Neukunden! 
                 then
                    p_get_siebel_kopfdaten(
                        piv_kundennummer  => pov_kundennummer,
                        piov_vorname      => pov_vorname,
                        piov_nachname     => pov_nachname,
                        piod_geburtsdatum => pod_geburtsdatum,
                        piov_anrede       => pov_anrede,
                        piov_titel        => pov_titel,
                        piov_firmenname   => pov_firmenname
                    );

                end if; 
        -- @ticket FTTH-4641:
                p_get_adresse(
                    pin_haus_lfd_nr   => pov_haus_lfd_nr,
                    pov_str           => pov_anschluss_str,
                    pov_hnr_kompl     => pov_anschluss_hnr_kompl,
                    pov_gebaeudeteil  => pov_anschluss_gebaeudeteil,
                    pov_plz           => pov_anschluss_plz,
                    pov_ort_kompl     => pov_anschluss_ort_kompl,
                    pov_adresse_kompl => pov_anschluss_adresse_kompl
                );   

        -- zusätzliche Angaben ermitteln: 
                pov_display_kopfdaten := fv_kopfdaten(
                    pin_haus_lfd_nr     => pov_haus_lfd_nr,
                    piv_kundennummer    => pov_kundennummer,
                    piv_vorname         => pov_vorname,
                    piv_nachname        => pov_nachname,
                    pid_geburtsdatum    => pod_geburtsdatum 
                                             /*
                                             ,piv_anschluss_strasse => pov_anschluss_strasse 
                                             ,piv_anschluss_hausnr  => rtrim(pov_anschluss_hausnr || ' ' || 
                                                                             pov_anschluss_zusatz) -- @ticket 1757 
                                             ,piv_anschluss_plz     => pov_anschluss_plz 
                                             ,piv_anschluss_ort     => pov_anschluss_ort 
                                             */,
                    piv_adresse_kompl   => pov_anschluss_adresse_kompl,
                    piv_auftragseingang => to_char(pod_created, 'DD.MM.YYYY HH24:MI')
                                           --  ,pib_link_siebel_kundenmaske => TRUE ///// wann wird das benutzt? Zunächst hier kein Link
                );

            end synchrondaten_holen;

        end zwei_versuche;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end p_get_auftragsdaten; 

  /** 
  * Nimmt die einzelnen Feldinhalte aus der Glascontainer-App entgegen 
  * und liefert das daraus resultierende JSON-Objekt zurück 
  * 
  * @param pir_auftrag [IN ] Feldinhalte, die zuvor in der APEX-App 
  * aus den Items ausgelesen und einem ROWTYPE 
  * entsprechend zugewiesen wurden 
  * @param pib_all_items [IN ] (optional) auf TRUE setzen, damit die Ausgabe 
  * auch diejenigen nicht-änderbaren Bestandteile 
  * enthält, die für einen PUT-Request (Update) 
  * zum Webservice erlaubt, aber wirkungslos sind; 
  * bei FALSE oder NULL enthält das JSON 
  * nur die editierbaren Attribute 
  * 
  * @usage Wenn pib_all_items auf FALSE steht, dann werden die Inhalte 
  * der nur-Lesen-Felder nicht benötigt und können leer bleiben. Dies 
  * erleichtert die Programmierung, da anfangs (Stand Mai 2022) tatsächlich 
  * nur 3 (drei!) Felder in der Glascontainer-App überhaupt editierbar sind, 
  * der Rest sind reine Anzeige-Items. 
  * 
  * @todo //// @deprecated? 
  */
    function fj_auftrag (
        pir_auftrag   in v_ftth_preorderbuffer%rowtype -- ////// View ausfasen wie folgt:
  --pir_auftrag   IN ftth_ws_sync_preorders%ROWTYPE -- und dann die Felder umbenennen
        ,
        pib_all_items in boolean default null
    ) return json_object_t is

        vj_auftrag      json_object_t := new json_object_t(c_empty_json);
        vj_product      json_object_t := new json_object_t(c_empty_json); 
    -- "All items" means: create the "big" JSON including the non-editable parts 
        all_items       constant boolean := nvl(pib_all_items, false); 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'fj_auftrag';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pir_auftrag.uuid', pir_auftrag.uuid);
            pck_format.p_add('pib_all_items', pib_all_items);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin 
    -- Schlüssel für den Auftrag: 
        vj_auftrag.put('id', pir_auftrag.uuid); 
    -- Kopfdaten: 
        if all_items then
            vj_auftrag.put('vkz', pir_auftrag.vkz);
            vj_auftrag.put('customerNumber', pir_auftrag.kundennummer);
        end if; 
    -- "product" ist änderbar: 
        vj_product.put('templateId', pir_auftrag.promotion);
        vj_product.put('deviceCategory', pir_auftrag.router_auswahl);
        vj_product.put('deviceOwnership', pir_auftrag.router_eigentum);
        vj_product.put('installationService', pir_auftrag.installationsservice);
        vj_product.put('houseConnectionPrice', pir_auftrag.haus_anschlusspreis);
        vj_product.put('client', pir_auftrag.mandant);
        vj_auftrag.put('product', vj_product);
        if all_items then
            << customer >> declare
                vj_customer    json_object_t := new json_object_t(c_empty_json);
                vj_name        json_object_t := new json_object_t(c_empty_json);
                vj_phonenumber json_object_t := new json_object_t(c_empty_json);
            begin
                vj_customer.put('businessName', pir_auftrag.firmenname);
                vj_customer.put('salutation', pir_auftrag.anrede);
                vj_customer.put('title', pir_auftrag.titel);
                vj_name.put('first', pir_auftrag.vorname);
                vj_name.put('last', pir_auftrag.nachname);
                vj_customer.put('name', vj_name);
                vj_customer.put('email', pir_auftrag.email);
                vj_customer.put('birthDate',
                                to_char(pir_auftrag.geburtsdatum, 'YYYY-MM-DD'));
                vj_customer.put('residentStatus', pir_auftrag.wohndauer);
                vj_phonenumber.put('countryCode', pir_auftrag.laendervorwahl);
                vj_phonenumber.put('areaCode', pir_auftrag.vorwahl);
                vj_phonenumber.put('number', pir_auftrag.telefon);
                vj_customer.put('phoneNumber', vj_phonenumber);
                vj_auftrag.put('customer', vj_customer);
            end customer; 
      -- entfernt 2025-01-21:
      --vj_auftrag.put('password' 
      --              ,pir_auftrag.PASSWORT); -- ist verschlüsselt, wird niemals im Klartext übertragen. /// Wozu dient es dann hier? 
            << installation >> declare
                vj_installation json_object_t := new json_object_t(c_empty_json);
                vj_address      json_object_t := new json_object_t(c_empty_json);
            begin
                vj_address.put('street', pir_auftrag.anschluss_strasse);
                vj_address.put('houseNumber', pir_auftrag.anschluss_hausnr);
                vj_address.put('zipCode', pir_auftrag.anschluss_plz);
                vj_address.put('city', pir_auftrag.anschluss_ort);
                vj_address.put('postalAddition', pir_auftrag.anschluss_zusatz);
                vj_address.put('country', pir_auftrag.anschluss_land);
                vj_installation.put('address', vj_address);
                vj_installation.put('houseSerialNumber', pir_auftrag.haus_lfd_nr);
                vj_auftrag.put('installation', vj_installation);
            end installation; 
      --- vj_auftrag.put('providerChange', pir_auftrag.ANBIETERWECHSEL); 
            << account_details >> declare
                vj_account_details json_object_t := new json_object_t(c_empty_json);
            begin
                vj_account_details.put('accountHolder', pir_auftrag.kontoinhaber);
                vj_account_details.put('sepaMandate', pir_auftrag.sepa);
                vj_account_details.put('iban', pir_auftrag.iban);
                vj_auftrag.put('accountDetails', vj_account_details);
            end account_details;

            << property_owner_declaration >> declare
                vj_property_owner_declaration json_object_t := new json_object_t(c_empty_json);
                vj_landlord                   json_object_t := new json_object_t(c_empty_json);
                vj_name                       json_object_t := new json_object_t(c_empty_json);
                vj_address                    json_object_t := new json_object_t(c_empty_json);
                vj_phone_number               json_object_t := new json_object_t(c_empty_json);
            begin
                vj_property_owner_declaration.put('propertyOwnerRole', pir_auftrag.gee_rolle);
                vj_property_owner_declaration.put('residentialUnit', pir_auftrag.anzahl_we);
                vj_landlord.put('legalForm', pir_auftrag.vermieter_rechtsform);
                vj_landlord.put('businessOrName', pir_auftrag.vermieter_firmenname);
                vj_landlord.put('salutation', pir_auftrag.vermieter_anrede);
                vj_landlord.put('title', pir_auftrag.vermieter_titel);
                vj_name.put('first', pir_auftrag.vermieter_vorname);
                vj_name.put('last', pir_auftrag.vermieter_nachname);
                vj_landlord.put('name', vj_name);
                vj_address.put('street', pir_auftrag.vermieter_strasse);
                vj_address.put('houseNumber', pir_auftrag.vermieter_hausnr);
                vj_address.put('zipCode', pir_auftrag.vermieter_plz);
                vj_address.put('city', pir_auftrag.vermieter_ort);
                vj_address.put('postalAddition', pir_auftrag.vermieter_zusatz);
                vj_address.put('country', pir_auftrag.vermieter_land);
                vj_landlord.put('email', pir_auftrag.vermieter_email);
                vj_phone_number.put('countryCode', pir_auftrag.vermieter_laendervorwahl);
                vj_phone_number.put('areaCode', pir_auftrag.vermieter_vorwahl);
                vj_phone_number.put('number', pir_auftrag.vermieter_telefon);
                vj_landlord.put('phoneNumber', vj_phone_number);
                vj_property_owner_declaration.put('landlord', vj_landlord);
                vj_property_owner_declaration.put('landlordAgreedToBeContacted', pir_auftrag.vermieter_einverstaendnis);
                vj_auftrag.put('propertyOwnerDeclaration', vj_property_owner_declaration);
            end property_owner_declaration;

            << summary >> declare
                vj_summary json_object_t := new json_object_t(c_empty_json);
            begin
                vj_summary.put('preContractualInformation', pir_auftrag.bestaetigung_vzf);
                vj_summary.put('generalTermsAndConditions', pir_auftrag.zustimmung_agb);
                vj_summary.put('waiveRightOfRevocation', pir_auftrag.zustimmung_widerruf);
                vj_summary.put('emailMarketing', pir_auftrag.opt_in_email);
                vj_summary.put('phoneMarketing', pir_auftrag.opt_in_telefon);
                vj_summary.put('smsMmsMarketing', pir_auftrag.opt_in_sms_mms);
                vj_summary.put('mailMarketing', pir_auftrag.opt_in_post);
                vj_summary.put('orderSummaryFileId', pir_auftrag.vertragszusammenfassung);
                vj_auftrag.put('summary', vj_summary);
            end summary;

        end if; 
    -- ///@klären: ist STATE immer nötig? 
        vj_auftrag.put('state', pir_auftrag.status); 
    -- vj_auftrag.put('', pir_auftrag.); 
        return vj_auftrag;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end fj_auftrag; 

/** 
 * Generische Prüffunktion, die bei fehlgeschlagener Bedingung einen 
 * Fehlertext zurückgibt 
 * 
 * @param piv_feldname  [IN ] Formularname (Label) des Feldes zur Weitergabe an den Benutzer 
 * @param piv_value     [IN ] Zu prüfender Wert 
 * @param piv_condition [IN ] Ergebnis des durchgeführten Tests als Bool'scher Ausdruck 
 * @param pib_null      [IN ] TRUE: Ein leerer Wert wird als gültig betrachtet 
 *                            FALSE: Ein leerer Wert ist ein Fehler 
 */
    function fv_validierung (
        piv_feldname  in varchar2,
        piv_value     in varchar2,
        pib_condition in boolean,
        pib_null      in boolean
    ) return varchar2
        accessible by ( package ut_glascontainer )
    is
    begin
        if
            not nvl(pib_null, false)
            and piv_value is null
        then
            return 'Der Wert für "'
                   || piv_feldname
                   || ' fehlt.';
        end if;

        if not pib_condition then
            return 'Ungültiger Wert für "'
                   || piv_feldname
                   || '": '
                   || piv_value;
        end if;

        return null;
    end fv_validierung; 

  /** 
  * APEX-Validierung für das Feld "Anrede" 
  * 
  * @param piv_value [IN ] Aktueller Wert des Items 
  * @param pib_null [IN ] (optional) Auf TRUE setzen, wenn ein leerer Wert gültig ist 
  * @param piv_feldname [IN ] Falls diese Prüfung für unterschiedliche Felder herangezogen wird, 
  * sollte hier explizit das Formular-Label angegeben werden 
  * @return Fehlertext wenn die Prüfung fehlschlägt, ansonsten NULL (= Prüfung erfolgreich) 
  */
    function chk_anrede (
        piv_value    in varchar2,
        pib_null     in boolean default false,
        piv_feldname in varchar2 default null
    ) return varchar2 is
    begin
        return fv_validierung(
            piv_feldname  => nvl(piv_feldname, 'Anrede'),
            piv_value     => piv_value,
            pib_condition => piv_value in(enum_anrede_maennlich, enum_anrede_weiblich),
            pib_null      => pib_null
        );
    end chk_anrede; 

  /** 
  * APEX-Validierung für das Feld "Router-Eigentum" (deviceOwnership) 
  * 
  * @param piv_value [IN ] Aktueller Wert des Items 
  * @param pib_null [IN ] (optional) Auf TRUE setzen, wenn ein leerer Wert gültig ist 
  * @param piv_feldname [IN ] Falls diese Prüfung für unterschiedliche Felder herangezogen wird, 
  * sollte hier explizit das Formular-Label angegeben werden 
  * @return Fehlertext wenn die Prüfung fehlschlägt, ansonsten NULL (= Prüfung erfolgreich) 
  */
    function chk_deviceownership (
        piv_value    in varchar2,
        pib_null     in boolean default false,
        piv_feldname in varchar2 default null
    ) return varchar2 is
    begin
        return fv_validierung(
            piv_feldname  => nvl(piv_feldname, 'Router-Auswahl'),
            piv_value     => piv_value,
            pib_condition => piv_value in(enum_deviceownership_buy, -- "Kauf" 
             enum_deviceownership_rent -- "Miete" 
            ),
            pib_null      => pib_null
        );
    end chk_deviceownership; 

  /** 
  * APEX-Validierung für das Feld "Installationsservice" (installationService) 
  * 
  * @param piv_value [IN ] Aktueller Wert des Items 
  * @param pib_null [IN ] (optional) Auf TRUE setzen, wenn ein leerer Wert gültig ist 
  * @param piv_feldname [IN ] Falls diese Prüfung für unterschiedliche Felder herangezogen wird, 
  * sollte hier explizit das Formular-Label angegeben werden 
  * @return Fehlertext wenn die Prüfung fehlschlägt, ansonsten NULL (= Prüfung erfolgreich) 
  */
    function chk_installationsservice (
        piv_value    in varchar2,
        pib_null     in boolean default false,
        piv_feldname in varchar2 default null
    ) return varchar2 is
    begin
        return fv_validierung(
            piv_feldname  => nvl(piv_feldname, 'Installationsservice'),
            piv_value     => piv_value,
            pib_condition => piv_value in(enum_installationsservice_none, enum_installationsservice_netstart, enum_installationsservice_netstart_plus
            ),
            pib_null      => pib_null
        );
    end chk_installationsservice; 

  /** 
  * -- @deprecated
  * 
  * APEX-Validierung für das Feld "Promotion" 
  * 
  * @param piv_value [IN ] Aktueller Wert des Items 
  * @param pib_null [IN ] (optional) Auf TRUE setzen, wenn ein leerer Wert gültig ist 
  * @return Fehlertext wenn die Prüfung fehlschlägt, ansonsten NULL (= Prüfung erfolgreich) 

  FUNCTION chk_promotion  
                         -- Anscheinend werden die chk_...-Funktionen gar nicht mehr verwendet??? 
  ( 
    piv_value IN VARCHAR2 
   ,pib_null  IN BOOLEAN DEFAULT FALSE 
  ) RETURN VARCHAR2 IS 
  BEGIN 
    RETURN fv_validierung(piv_feldname  => 'Promotion' 
                         ,piv_value     => piv_value 
                         ,pib_condition => piv_value IN ( 
                                                         -- 2022-09-27 ////@TODO: alte Promotions entfernen, sobald 
                                                         -- das Gültigkeitsmodell existiert 
                                                         -- @Herbst 2023 ///
                                                         enum_promotion_2022_04_50 
                                                        ,enum_promotion_2022_04_phone_50 
                                                        ,enum_promotion_2022_04_tv_50 
                                                        ,enum_promotion_2022_04_phone_tv_50 
                                                        ,enum_promotion_2022_04_100 
                                                        ,enum_promotion_2022_04_phone_100 
                                                        ,enum_promotion_2022_04_tv_100 
                                                        ,enum_promotion_2022_04_phone_tv_100 
                                                        ,enum_promotion_2022_04_250 
                                                        ,enum_promotion_2022_04_phone_250 
                                                        ,enum_promotion_2022_04_tv_250 
                                                        ,enum_promotion_2022_04_phone_tv_250 
                                                        ,enum_promotion_2022_04_500 
                                                        ,enum_promotion_2022_04_phone_500 
                                                        ,enum_promotion_2022_04_tv_500 
                                                        ,enum_promotion_2022_04_phone_tv_500 
                                                        ,enum_promotion_2022_04_1000 
                                                        ,enum_promotion_2022_04_phone_1000 
                                                        ,enum_promotion_2022_04_tv_1000 
                                                        ,enum_promotion_2022_04_phone_tv_1000 
                                                        , ---------------------------------- 
                                                         enum_promotion_2022_10_50 
                                                        ,enum_promotion_2022_10_phone_50 
                                                        ,enum_promotion_2022_10_tv_50 
                                                        ,enum_promotion_2022_10_phone_tv_50 
                                                        ,enum_promotion_2022_10_100 
                                                        ,enum_promotion_2022_10_phone_100 
                                                        ,enum_promotion_2022_10_tv_100 
                                                        ,enum_promotion_2022_10_phone_tv_100 
                                                        ,enum_promotion_2022_10_250 
                                                        ,enum_promotion_2022_10_phone_250 
                                                        ,enum_promotion_2022_10_tv_250 
                                                        ,enum_promotion_2022_10_phone_tv_250 
                                                        ,enum_promotion_2022_10_500 
                                                        ,enum_promotion_2022_10_phone_500 
                                                        ,enum_promotion_2022_10_tv_500 
                                                        ,enum_promotion_2022_10_phone_tv_500 
                                                        ,enum_promotion_2022_10_1000 
                                                        ,enum_promotion_2022_10_phone_1000 
                                                        ,enum_promotion_2022_10_tv_1000 
                                                        ,enum_promotion_2022_10_phone_tv_1000) 
                         ,pib_null      => pib_null); 
  END chk_promotion; 
  */ 

  /** 
  * APEX-Validierung für das Feld "Wohneinheiten" bzw. "Anzahl WE" (prop_residential_unit) 
  * 
  * @param piv_value [IN ] Aktueller Wert des Items 
  * @param pib_null [IN ] (optional) Auf TRUE setzen, wenn ein leerer Wert gültig ist 
  * @param piv_feldname [IN ] Falls diese Prüfung für unterschiedliche Felder herangezogen wird, 
  * sollte hier explizit das Formular-Label angegeben werden 
  * @return Fehlertext wenn die Prüfung fehlschlägt, ansonsten NULL (= Prüfung erfolgreich) 
  */
    function chk_prop_residential_unit (
        piv_value    in varchar2,
        pib_null     in boolean default false,
        piv_feldname in varchar2 default null
    ) return varchar2 is
    begin
        return fv_validierung(
            piv_feldname  => nvl(piv_feldname, 'Wohneinheiten'),
            piv_value     => piv_value,
            pib_condition => piv_value in(enum_anzahl_we_one, enum_anzahl_we_more_than_one),
            pib_null      => pib_null
        );
    end chk_prop_residential_unit; 

  /** 
  * APEX-Validierung für das Feld "Router-Auswahl" (deviceCategory) 
  * 
  * @param piv_value [IN ] Aktueller Wert des Items 
  * @param pib_null  [IN ] (optional) Auf TRUE setzen, wenn ein leerer Wert gültig ist 
  * @return Fehlertext wenn die Prüfung fehlschlägt, ansonsten NULL (= Prüfung erfolgreich) 
  */
    function chk_router_auswahl (
        piv_value in varchar2,
        pib_null  in boolean default false
    ) return varchar2 is
    begin
        return fv_validierung(
            piv_feldname  => 'Router-Auswahl',
            piv_value     => piv_value,
            pib_condition => piv_value in(enum_devicecategory_byod    -- Eigenes Gerät 
            , enum_devicecategory_premium -- Premium-Router 
            , enum_devicecategory_basic   -- @ticket FTTH-3562: möglich für Wholebuy Telekom
            ),
            pib_null      => pib_null
        );
    end chk_router_auswahl; 

  /** 
  * APEX-Validierung für das Feld "Auftragsstatus" (state) 
  *
  * @todo 2024-03-26: ///// Wo wird diese Funktion inzwischen noch aufgerufen?
  * 
  * @param piv_value [IN ] Aktueller Wert des Items 
  * @param pib_null [IN ] (optional) Auf TRUE setzen, wenn ein leerer Wert gültig ist 
  * @param piv_feldname [IN ] Falls diese Prüfung für unterschiedliche Felder herangezogen wird, 
  * sollte hier explizit das Formular-Label angegeben werden 
  * @return Fehlertext wenn die Prüfung fehlschlägt, ansonsten NULL (= Prüfung erfolgreich) 
  */
    function chk_status (
        piv_value    in varchar2,
        pib_null     in boolean default false,
        piv_feldname in varchar2 default null
    ) return varchar2 is
    begin
        return fv_validierung(
            piv_feldname  => nvl(piv_feldname, 'Auftragsstatus'),
            piv_value     => piv_value,
            pib_condition => piv_value in(status_created, status_in_review, status_cancelled, status_siebel_processed -- 2023-09-12 
            , status_clearing_landlord_data -- 2024-08
            ,
                                          status_clearing_wb_abbm -- 2025-05 @ticket FTTH-4719
                                          ),
            pib_null      => pib_null
        );
    end chk_status; 

  /** 
  * APEX-Validierung für das Feld "Wohndauer" (customer_residentstatus) 
  * 
  * @param piv_value [IN ] Aktueller Wert des Items 
  * @param pib_null [IN ] (optional) Auf TRUE setzen, wenn ein leerer Wert gültig ist 
  * @param piv_feldname [IN ] Falls diese Prüfung für unterschiedliche Felder herangezogen wird, 
  * sollte hier explizit das Formular-Label angegeben werden 
  * @return Fehlertext wenn die Prüfung fehlschlägt, ansonsten NULL (= Prüfung erfolgreich) 
  */
    function chk_wohndauer (
        piv_value    in varchar2,
        pib_null     in boolean default false,
        piv_feldname in varchar2 default null
    ) return varchar2 is
    begin
        return fv_validierung(
            piv_feldname  => nvl(piv_feldname, 'Wohndauer'),
            piv_value     => piv_value,
            pib_condition => piv_value in(enum_wohndauer_no_resident, enum_wohndauer_weniger_als_6m, enum_wohndauer_6m_oder_mehr),
            pib_null      => pib_null
        );
    end chk_wohndauer; 

  /** 
  * Liefert die Anzeige- und Rückgabewerte für eine APEX LOV anhand ihres Namens zurück 
  * 
  * @param piv_name [IN ] Name der LOV, typischerweise entspricht dieser dem 
  * generischen Namen des APEX Items, Beispiel: ROUTER_AUSWAHL 
  * @param piv_parameter1 [IN ] Typischerweise der Wert einer Parent-Selectliste, so dass 
  * die Ausgabe bestimmter Zeilen dynamisch ist 
  * @param piv_parameter2 [IN ] Wurde erstmals erforderlich für die LOV "Promotion", wo 
  * die Mindest- und Maximalbandbreite des Vermarktungscluster 
  * eine Rolle spielt 
  * @param piv_parameter3 [IN ] Wird verwendet, um die richtigen ENUMs für die templateId 
  * auszuwählen: Hier wird NULL, 2022-04 oder 2022-10 erwartet 
  * 
  * @example 
  * SELECT d, r FROM TABLE(PCK_GLASCONTAINER.LOV( 
  *     piv_name       => 'PRODUKT',  
  *     piv_parameter1 => 250, -- min_bandbreite 
  *     piv_parameter2 => 1000, -- max_bandbreite 
  *     piv_parameter3 => :P20_PROMOTION 
  * ))   
  *
  * @example - Neuen Auftragsstatus für den Glascontainer registrieren, @ticket FTTH-4719:
  * MERGE INTO ROMA_MAIN.ENUM T
  * USING (SELECT 'state' AS DOMAIN
  *             , 'FTTH' AS KONTEXT
  *             , '*' AS SPRACHE
  *             , 'CLEARING_WB_ABBM' AS KEY      -- technischer Schlüssel
  *             , 50 AS POS
  *             , 'Clearing Wholebuy ABBM' AS SINGULAR -- angezeigter String
  *          FROM DUAL
  *        ) S
  *     ON (S.DOMAIN = T.DOMAIN AND
  *         S.KONTEXT = T.KONTEXT AND
  *         S.SPRACHE = T.SPRACHE AND
  *         S.KEY = T.KEY
  *         )
  * WHEN MATCHED THEN 
  *     UPDATE
  *        SET T.POS = S.POS
  *          , T.SINGULAR = S.SINGULAR
  * WHEN NOT MATCHED THEN 
  *     INSERT(T.ID, T.DOMAIN, T.KONTEXT, T.SPRACHE, T.KEY, T.POS, T.SINGULAR)
  *     VALUES(NULL, S.DOMAIN, S.KONTEXT, S.SPRACHE, S.KEY, S.POS, S.SINGULAR)
  * ;  
  */
    function lov (
        piv_name       in varchar2,
        piv_parameter1 in varchar2 default null,
        piv_parameter2 in varchar2 default null,
        piv_parameter3 in varchar2 default null -- neu 2022-09-27 
        ,
        piv_parameter4 in varchar2 default null --FTTH-6261 Sonderlogik für 2000er Bandbreiten duerfen kein Basic zur Auswahl haben
    ) return t_lov
        pipelined
    is

        c_domain             constant enum.key%type := upper(substr(piv_name, 1, 255));
        v_eintraege_gefunden boolean := false; 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name      constant logs.routine_name%type := 'lov';
        l_param4             varchar2(5000 char);

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_name', piv_name);
            pck_format.p_add('piv_parameter1', piv_parameter1);
            pck_format.p_add('piv_parameter2', piv_parameter2);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin 
    -- Sonderfälle zuerst, die entweder hartkodiert werden müssen
    -- oder Filter bei der Abfrage der Tabelle ENUM benötigen:

    -- Router-Auswahl: 2024-03-26
        case c_domain
            when 'DEVICECATEGORY' then
        -- piv_parameter1 = Schlüssel des WHOLEBUY_PARTNERs oder NULL
                for v in (
                    select
                        key,
                        singular
                    from
                        v_glascontainer_enum
                    where
                        domain = piv_name
                    order by
                        pos
                ) loop
          -- Sonderlogik
          -- Wenn 2000er Produkte ausgewaehlt sind, dann darf kein Basic Router Auswahl angezeigt werden
                    if (
                        piv_parameter4 not in ( 'ftth-factory-2025-06-2000', 'ftth-factory-2025-06-tv-2000', 'ftth-factory-2025-06-phone-2000'
                        , 'ftth-factory-2025-06-phone-tv-2000' )
                        and v.key = enum_devicecategory_basic
                        and piv_parameter1 is not null
                    ) then
                        pipe row ( new t_lov_entry(v.singular, v.key) );
                    elsif v.key != enum_devicecategory_basic then
                        pipe row ( new t_lov_entry(v.singular, v.key) );
                    end if;
                end loop;
            when 'ROUTER_EIGENTUM' then -- wird nicht in ENUM geführt
                if piv_parameter1 = enum_devicecategory_byod then
                    return; -- bei eigenem Gerät kommt Miete/Kauf nicht in Frage
                else
                    pipe row ( new t_lov_entry('Kauf', enum_deviceownership_buy) );
                    pipe row ( new t_lov_entry('Miete', enum_deviceownership_rent) );
                end if;
    -------------------------------  
            else -- c_domain ist kein Sonderfall:
        -- 2022-09-06 Zunächst erfolgt dier Suche in der Tabelle ROMA_MAIN.ENUM: 
                for v in (
                    select
                        key,
                        singular
                    from
                        v_glascontainer_enum
                    where
                        domain = piv_name
                    order by
                        pos
                ) loop
                    v_eintraege_gefunden := true;
                    pipe row ( new t_lov_entry(v.singular, v.key) );
                end loop;

                if v_eintraege_gefunden then
                    return;
                end if; 

        -- Wenn in der Tabelle ENUM keine Einträge gefunden wurden, 
        -- kommen die folgenden, weiterhin hartkodierten Einträge zum Tragen: 
                case upper(trim(piv_name)) 
        -------------------------- 
                    when 'TARIF' then -- @herbst: //// umbenennen zu "AKTION" oder "PROMOTION" 
            -- Stand 2022-09 wird nur eine einzige Zeile zurückgeliefert, weil die Promotion 
            -- unter dem Label "Aktion" im Glascontainer nur informell angezeigt werden soll. Sobald ein Wechsel des Produkts 
            -- auch außerhalb der aktuellen Promotion möglich sein soll, muss das APEX-Textitem P20_PROMO zu einer Selectlist 
            -- umgebaut werden, und diese LOV muss dann SÄMTLICHE verfügbare Promos zurückliefern. 

            -- Man kann entweder direkt mit dem CODE abfragen (piv_parameter1 => '2023-09') 
            -- oder, wie beim Item "Aktion" auf Seite P20, mit dem Produkt (piv_parameter1 => 'ftth-factory-2023-09-phone-tv-250') 
            -- Solange der Aktionsmonat eindeutig in der templateId enthalten ist, funktionert also diese LIKE-Suche:         
                        for promotion in (
                            select
                                name,
                                code
                            from
                                ftth_glascontainer_aktionen
                            where
                                piv_parameter1 is null
                                or piv_parameter1 like '%'
                                                       || code
                                                       || '%'
                        ) loop
                            pipe row ( new t_lov_entry(promotion.name, promotion.code) );
                        end loop; 
          -------------------------- 
                    when 'PRODUKTAKTION' then -- @ticket FTTH-2411 neue LOV 
          -- Hierbei wird im Unterschied zur LOV 'TARIF' nicht der CODE der Aktion als Returnwert zurückgegeben, 
          -- sondern wieder die gesamte TEMPLATE_ID; dafür aber nicht mit dem Namen des Produkts,  
          -- sondern eben der Aktion. Außerdem wird über die exakte TEMPLATE_ID abgefragt. 
          -- @herbst2024
                        for produktaktion in (
                            select
                                aktion.name as name,
                                produkt.template_id
                            from
                                     ftth_glascontainer_produkte produkt
                                join ftth_glascontainer_aktionen aktion on ( produkt.aktion = aktion.code )
                            where
                                piv_parameter1 is null
                                or piv_parameter1 = produkt.template_id
                        ) loop
                            pipe row ( new t_lov_entry(produktaktion.name, produktaktion.template_id) );
                        end loop; 

          -------------------------- 
                    when 'PROMOTION' then -- @Herbst: /////@deprecated!
                        raise e_not_implemented; 
            /* 
            -- "templateId" 
            DECLARE 
              -- Bandbreiten 
              MINBB CONSTANT NATURALN := nvl(to_number(piv_parameter1) 
                                            ,0); -- keine Vorgabe: Dann ist die untere Grenze immer gegeben. 
              MAXBB CONSTANT NATURALN := nvl(to_number(piv_parameter2) 
                                            ,999999999); -- keine Vorgabe: Dann ist die obere Grenze immer gegeben. 
              -- /// ggf. noch prüfen, ob MINBB <= MAXBB 
            BEGIN 
              IF 50 BETWEEN MINBB AND MAXBB 
              THEN 
                PIPE ROW(NEW T_LOV_ENTRY('2022-04 / 50' 
                                    ,ENUM_PROMOTION_2022_04_50)); 
                PIPE ROW(NEW T_LOV_ENTRY('2022-04 / Phone 50' 
                                    ,ENUM_PROMOTION_2022_04_PHONE_50)); 
                PIPE ROW(NEW T_LOV_ENTRY('2022-04 / TV 50' 
                                    ,ENUM_PROMOTION_2022_04_TV_50)); 
                PIPE ROW(NEW T_LOV_ENTRY('2022-04 / Phone+TV 50' 
                                    ,ENUM_PROMOTION_2022_04_PHONE_TV_50)); 
              END IF; 
              IF 100 BETWEEN MINBB AND MAXBB 
              THEN 
                PIPE ROW(NEW T_LOV_ENTRY('2022-04 / 100' 
                                    ,ENUM_PROMOTION_2022_04_100)); 
                PIPE ROW(NEW T_LOV_ENTRY('2022-04 / Phone 100' 
                                    ,ENUM_PROMOTION_2022_04_PHONE_100)); 
                PIPE ROW(NEW T_LOV_ENTRY('2022-04 / TV 100' 
                                    ,ENUM_PROMOTION_2022_04_TV_100)); 
                PIPE ROW(NEW T_LOV_ENTRY('2022-04 / Phone+TV 100' 
                                    ,ENUM_PROMOTION_2022_04_PHONE_TV_100)); 
              END IF; 
              IF 250 BETWEEN MINBB AND MAXBB 
              THEN 
                PIPE ROW(NEW T_LOV_ENTRY('2022-04 / 250' 
                                    ,ENUM_PROMOTION_2022_04_250)); 
                PIPE ROW(NEW T_LOV_ENTRY('2022-04 / Phone 250' 
                                    ,ENUM_PROMOTION_2022_04_PHONE_250)); 
                PIPE ROW(NEW T_LOV_ENTRY('2022-04 / TV 250' 
                                    ,ENUM_PROMOTION_2022_04_TV_250)); 
                PIPE ROW(NEW T_LOV_ENTRY('2022-04 / Phone+TV 250' 
                                    ,ENUM_PROMOTION_2022_04_PHONE_TV_250)); 
              END IF; 
              IF 500 BETWEEN MINBB AND MAXBB 
              THEN 
                PIPE ROW(NEW T_LOV_ENTRY('2022-04 / 500' 
                                    ,ENUM_PROMOTION_2022_04_500)); 
                PIPE ROW(NEW T_LOV_ENTRY('2022-04 / Phone 500' 
                                    ,ENUM_PROMOTION_2022_04_PHONE_500)); 
                PIPE ROW(NEW T_LOV_ENTRY('2022-04 / TV 500' 
                                    ,ENUM_PROMOTION_2022_04_TV_500)); 
                PIPE ROW(NEW T_LOV_ENTRY('2022-04 / Phone+TV 500' 
                                    ,ENUM_PROMOTION_2022_04_PHONE_TV_500)); 
              END IF; 
              IF 1000 BETWEEN MINBB AND MAXBB 
              THEN 
                PIPE ROW(NEW T_LOV_ENTRY('2022-04 / 1000' 
                                    ,ENUM_PROMOTION_2022_04_1000)); 
                PIPE ROW(NEW T_LOV_ENTRY('2022-04 / Phone 1000' 
                                    ,ENUM_PROMOTION_2022_04_PHONE_1000)); 
                PIPE ROW(NEW T_LOV_ENTRY('2022-04 / TV 1000' 
                                    ,ENUM_PROMOTION_2022_04_TV_1000)); 
                PIPE ROW(NEW T_LOV_ENTRY('2022-04 / Phone+TV 1000' 
                                    ,ENUM_PROMOTION_2022_04_PHONE_TV_1000)); 
              END IF; 
            END; 
            */

                    when 'HTTP_STATUSCODE' then 
            ------------------------------------------------------- -- Beispiel 
                        pipe row ( new t_lov_entry('200 - OK', '200') );
                        pipe row ( new t_lov_entry('400 - Bad Request', '400') );
                        pipe row ( new t_lov_entry('404 - Not found', '404') ); -- Auftrag existiert nicht 
                        pipe row ( new t_lov_entry('500 - Internal Server Error', '500') );
                        pipe row ( new t_lov_entry('502 - Bad Gateway', '502') );
                        pipe row ( new t_lov_entry('503 - Service unavailable', '503') ); 
            -------------------------------------------- 
        -- hier folgen die Kandidaten zum Entfernen: 
        -------------------------------------------- 
        -- (dies liegt inzwischen in der Tabelle ROMA_MAIN.ENUM, 'legalForm') 
                    when 'RECHTSFORM' then
                        pipe row ( new t_lov_entry('Privatperson', 'PRIVATE_CITIZEN') );
                        pipe row ( new t_lov_entry('Firma', 'BUSINESS') );
                        pipe row ( new t_lov_entry('Eigentümergemeinschaft', 'COMMUNITY_OF_OWNERS') );
                        pipe row ( new t_lov_entry('Erbengemeinschaft', 'COMMUNITY_OF_HEIRS') ); 
            -------------------------- 
        -- (dies liegt inzwischen in der Tabelle ROMA_MAIN.ENUM, 'salutation') 
                    when 'ANREDE' then
                        pipe row ( new t_lov_entry('Herr', enum_anrede_maennlich) );
                        pipe row ( new t_lov_entry('Frau', enum_anrede_weiblich) ); 
            -------------------------- 
        -- (dies liegt inzwischen in der Tabelle ROMA_MAIN.ENUM , 'residentialUnit') 
                    when 'ANZAHL_WE' then 
            -- prop_residential_unit 
                        pipe row ( new t_lov_entry('genau eine WE', enum_anzahl_we_one) );
                        pipe row ( new t_lov_entry('mehr als eine WE', enum_anzahl_we_more_than_one) ); 
            -------------------------- 
        -- (dies liegt inzwischen in der Tabelle ROMA_MAIN.ENUM , 'propertyOwnerRole') 
                    when 'GEE_ROLLE' then
                        raise e_not_implemented;
            /*  wird bereits oben aus der Tabelle ENUM geholt
            -- "Wohnverhältnis" 
            PIPE ROW(NEW T_LOV_ENTRY('Mieter', 'TENANT')); 
            PIPE ROW(NEW T_LOV_ENTRY('Teileigentümer', 'PART_OWNER'));
            PIPE ROW(NEW T_LOV_ENTRY('Eigentümer', 'OWNER'));
            */
        -------------------------- 
        -- (dies liegt inzwischen in der Tabelle ROMA_MAIN.ENUM , 'residentStatus') 
                    when 'WOHNDAUER' then
                        pipe row ( new t_lov_entry('wohnt nicht dort', enum_wohndauer_no_resident) );
                        pipe row ( new t_lov_entry('kürzer als 6 Monate', enum_wohndauer_weniger_als_6m) );
                        pipe row ( new t_lov_entry('mehr als 6 Monate', enum_wohndauer_6m_oder_mehr) ); 
            -------------------------- 
                    else
                        return;
                end case; -- Sonderfälle nach ENUM-Abfrage
    ------------------------------- 
        end case; -- /Sonderbehandlung
        return;
    exception
        when no_data_needed then
            return;
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end lov; 



  /** 
   * Liefert die Anzeige- und Rückgabewerte für die APEX LOV "Stornogruende" zurück 
   * 
   * @usage  Die Gründe für die Auftragsstornierung sollen 
   *         gemäß @Ticket FTTH-652 dynamisch vom Webservice geholt werden. 
   *         Da dies ein völlig anderes Konzept darstellt als die Standard-LOV-Funktion, 
   *         wurde der Code hier ausgelagert. 
   * 
   * @ticket FTTH-652 
   * @ticket FTTH-3840: Neuer Parameter "Aktueller Auftragsstatus", der bestimmt,
   *                    welche Stornogründe ausgegeben werden (zunächst nur wegen NO_LANDLORD_DATA)
   */
    function lov_stornogrund (
        piv_aktueller_auftragsstatus in varchar2 default null
    ) return t_lov
        pipelined
    is 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'lov_stornogrund';

        function fcl_params return logs.message%type is
        begin
            return null; -- diese function besitzt keine Parameter 
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin 
    -- 2022-12-14: Nun arbeitet die nächtliche Synchronisierung auch für die Stornogründe 
        for r in (
            select -- S.label AS displayvalue -- alternativ: 
                coalesce(enum.singular, s.label) as displayvalue -- (dort gibt es keine Tippfehler ...) -- 2023-06-28 neu: COALESCE 
                ,
                s.key                            as returnvalue
            from
                ftth_ws_sync_stornogruende s 
              -- ursprünglich war die Tabelle ENUM eine Übergangslösung, solange die Stornogründe 
              -- nicht dynamisch abgeholt werden konnten. Anstatt diese Lösung nun zu eliminieren, 
              -- bleibt sie bestehen und ermöglicht so (alternativlos) eine stabile Sortierung der Einträge, 
              -- so dass die Stornogründe im APEX-Dialogfenster nicht wahllos aufeinander folgen; 
              -- denn der Webservice liefert keine definierte Sortierung mit 
              -- und der nächtliche APEX REST Sync kann auch keine Sortierung "hinzuzaubern". 
              -- Für neu hinzukommende Stornogründe kann jeweils ein neuer Eintrag 
              -- in die Tabelle ENUM eingefügt werden - solange dies nicht erfolgt, werden die 
              -- neuen Einträge unterhalb der bestehenden Liste eingefügt (dort wiederum sortiert nach Alphabet) 
                left join enum on ( enum.key = s.key
                                    and enum.kontext = 'FTTH'
                                    and enum.domain = 'cancellationReasons'
                                    and enum.sprache = '*'
                                    and status is null -- keine deaktivierten, nicht mehr verfügbaren etc. 
                                     )
            order by
                enum.pos 
                        -- nicht in ENUM erfasste (da vom Webservice nach 2022-12-14 gelieferte) Einträge zuletzt, 
                        -- in dieser Gruppe alphabetisch: 
                 nulls last,
                s.label
        ) loop 
      -- in dieser Loop erscheinen prinzipiell alle Stornogründe.
      -- In bestimmten Fällen dürfen aber nicht alle ausgegeben werden.
      -- @ticket FTTH-3840:
      -- Der Stornogrund "Eigentümerdaten nicht ermittelbar/verweigert" ist nur für Aufträge im Status "Clearing Landlord Data" verfügbar:
            if
                r.returnvalue = 'NO_LANDLORD_DATA'
                and nullif(piv_aktueller_auftragsstatus, 'CLEARING_LANDLORD_DATA') is not null
            then
                continue;
            end if;
      -- Ausschlusskriterium erfüllt:
            pipe row ( new t_lov_entry(r.displayvalue, r.returnvalue) );
        end loop;

        return;
    exception
        when no_data_needed then
            return;
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end lov_stornogrund; 

  /** 
  * Ersetzt die mittleren Zeichen der IBAN durch Sternchen 
  * (eine technische Validierung der IBAN erfolgt dabei nicht, 
  * jedoch werden fehlende oder zu viele vorhandene Stellen optisch hervorgehoben) 
  * 
  * @param piv_iban [IN ] Originale IBAN, egal ob mit oder ohne Leerzeichen 
  * @param piv_fuellzeichen [IN ] Wenn gefüllt (Default: Leerzeichen), dann erfolgt 
  * die Ausgabe mit diesem Zeichen zwischen den Viererblöcken. 
  * Das Füllzeichen darf auch leer sein (NULL) - dann 
  * werden keine Viererblöcke gebildet 
  * @param piv_maskierungszeichen [IN ] Bestimmt das Zeichen (genaugenommen: maximal 4 aufeinanderfolgende Zeichen) 
  * zur Übermalung der originalen Stellen 
  * (Default: Sternchen *) 
  * 
  * @usage Anzeige einer IBAN muss maskiert erfolgen (nur die ersten 4 und die letzten 4 Zeichen, der Rest mit * maskiert). 
  * Wenn die IBAN nicht vollständig ist (genau 22 Stellen ohne Leerzeichen), dann werden 
  * die fehlenden Stellen durch '?' am Ende dargestellt: 'DE1' wird zu 'DE1? **** **** **** **?? ??' 
  * Ist die IBAN zu lang, wird dies durch entsprechend viele (maximal 3) '#' am Ende signalisiert. 
  * 
  */
    function fv_iban_maskiert (
        piv_iban               in varchar2,
        piv_fuellzeichen       in varchar2 default ' ',
        piv_maskierungszeichen in varchar2 default '*'
    ) return varchar2 is

        v_iban             varchar2(256) := substr(
            replace(piv_iban, ' '),
            1,
            256
        ); -- 256, damit die Erkennung zu vieler Zeichen 
    -- auch bei erheblich zu langen IBANs funktioniert 
        v_iban_length      natural := length(v_iban);
        v_iban_ueberschuss naturaln := 0; -- so viele Zeichen ist die IBAN zu lang 
        fuellzeichen       constant varchar2(1) := substr(piv_fuellzeichen, 1, 1);
        viererblock        constant varchar2(5) := rpad(
            nvl(piv_maskierungszeichen, '*'),
            4,
            nvl(piv_maskierungszeichen, '*')
        );
        zweierblock        constant varchar2(3) := substr(viererblock, 1, 2); 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name    constant logs.routine_name%type := 'fv_iban_maskiert';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_iban', piv_iban);
            pck_format.p_add('piv_fuellzeichen', piv_fuellzeichen);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        if v_iban is null then
            return null;
        end if; 
    -- Die IBAN ist nicht vollständig oder zu lang: Das wird durch Sonderzeichen angedeutet, 
    -- die hier dem noch zu maskierenden IBAN-String an dessen Ende aufgestempelt werden: 
        case sign(v_iban_length - 22)
            when -1 -- zu wenig Zeichen 
             then
                v_iban := v_iban
                          || rpad('?', 22 - v_iban_length, '?');
            when + 1 -- zu viele Zeichen 
             then
                v_iban_ueberschuss := least(v_iban_length - 22, 16); -- maximal 16 Gatterkreuze sollen angezeigt werden, 
        -- denn dann ist sowieso klar dass es zu viele sind! 
                v_iban := substr(v_iban, 1, 22 - v_iban_ueberschuss) -- v.l.n.r. nur so viele Zeichen, dass noch 
                 -- ausreichend Gatterkreuze ans Ende passen 
                          || rpad('#', v_iban_ueberschuss, '#') -- 1 bis 4 Gatterkreuze 
                          || substr(v_iban, -4) -- (die rechten n Zeichen, damit man im Zweifelsfall erkennt, 
        -- was die letzten tatsächlichen Stellen waren - man weiß ja nicht wo genau der Fehler liegt) 
                          ;

            else 
        -- passt genau: 
                null;
        end case; 
    -- maskieren: 
        return substr(v_iban, 1, 4)
               || fuellzeichen
               ||
            case
                when v_iban_ueberschuss > 0 then
                    '#### #### #### ##' -- '..IBAN zu lang.. ' -- hiermit wird die oben erzeugte "feinere" Darstellung überschrieben, egal. 
                else viererblock
                     || fuellzeichen
                     || viererblock
                     || fuellzeichen
                     || viererblock
                     || fuellzeichen
                     || zweierblock
            end
               || substr(v_iban, -4, 2)
               || fuellzeichen
               || substr(v_iban, -2);

    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end fv_iban_maskiert; 

  /** 
  * Gibt das Datum und die Uhrzeit des letzten (typischerweise nächtlich laufenden) 
  * Synchronisierungs-Jobs des Webservices zurück 
  * 
  * ///@todo: Gilt das Datum auch im Fehlerfall? 
  * 
  * @param pin_app_id [IN ] APEX Application-ID 
  * @param piv_ws_name [IN ] "Rest Source Name" des synchronisierten Web-Service 
  */
    function fd_ws_last_sync_date (
        pin_app_id  in varchar2,
        piv_ws_name in varchar2
    ) return date is

        vd_last_sync_date date; 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name   constant logs.routine_name%type := 'fd_ws_last_sync_date';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_app_id', pin_app_id);
            pck_format.p_add('piv_ws_name', piv_ws_name);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        select
            max(start_timestamp)
        into vd_last_sync_date
        from
            apex_rest_source_sync_log
        where
                application_id = pin_app_id
            and rest_source_name = piv_ws_name;

        return vd_last_sync_date;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end fd_ws_last_sync_date; 

  /** 
  * Gibt das Datum der letzten Synchronisierung eines bestimmten Auftrags zurück 
  * (dieser wurde möglicherweise später als die nächtliche Synchronisierung 
  * einzeln synchronisiert) 
  * 
  * ///@todo: Gilt das Datum auch im Fehlerfall? 
  * 
  * @param i_app_id [IN ] APEX Application-ID 
  * @param i_ws_name [IN ] "Rest Source Name" des synchronisierten Web-Service 
  */
    function fd_ws_last_sync_date (
        piv_uuid in varchar2
    ) return date is

        vd_last_sync_date date; 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name   constant logs.routine_name%type := 'fd_ws_last_sync_date';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_uuid', piv_uuid);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        if piv_uuid is null then
            return null;
        end if;
        select
            max(apex$row_sync_timestamp)
        into vd_last_sync_date
        from
            ftth_ws_sync_preorders
        where
            id = piv_uuid;

        return vd_last_sync_date;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end fd_ws_last_sync_date; 

  /** 
   * Liefert die Daten des Vermarktungsclusters zu einer HAUS_LFD_NR zurück, 
   * oder einen leeren Record, falls das Objekt keinem Cluster zugeordnet ist 
   * 
   * @param pin_haus_lfd_nr [IN ]  PK der Tabelle VERMARKTUNGSCLUSTER_OBJEKT, 
   *                               in der die Zuordnungen der Häuser zu den 
   *                               Vermarktungsclustern gespeichert sind 
   * 
   * @example 
   * DECLARE 
   *   vr_vermarktungscluster vermarktungscluster%rowtype; 
   * BEGIN 
   *   vr_vermarktungscluster := PCK_GLASCONTAINER.fr_vermarktungscluster(pin_haus_lfd_nr => 12345678); 
   *   DBMS_OUTPUT.PUT_LINE('VC_LFD_NR   = ' || vr_vermarktungscluster.vc_lfd_nr); 
   *   DBMS_OUTPUT.PUT_LINE('Bezeichnung = ' || vr_vermarktungscluster.bezeichnung); 
   * END; 
   * 
   * @todo klären: ///// Wo wird das verwendet, sollte diese FUNCTION nicht besser im PCK_VERMARKTUNGSCLUSTER liegen? 
   */
    function fr_vermarktungscluster (
        pin_haus_lfd_nr in vermarktungscluster_objekt.haus_lfd_nr%type
    ) return vermarktungscluster%rowtype is

        vr_vermarktungscluster vermarktungscluster%rowtype; 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name        constant logs.routine_name%type := 'fr_vermarktungscluster';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_haus_lfd_nr', pin_haus_lfd_nr);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        if pin_haus_lfd_nr is null then
            return null;
        end if; 
    -- 2024-02-28: Diese Routine wird verlagert ins PCK_VERMARKTUNGSCLUSTER 
        return pck_vermarktungscluster.fr_vermarktungscluster(pin_haus_lfd_nr);
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end fr_vermarktungscluster; 

/** 
  * @deprecated: ersetzt durch fv_get_bandbreiteninfo
  * Liest die Mindest- und die Maximalbandreite des Vermarktungsclusters aus, 
  * zu dem das Haus mit der HAUS_LFD_NR gehört. 
  * 
  * @param pin_haus_lfd_nr [IN ] ID des betreffenden Gebäudes 
  * 
  * @return Wenn kein Vermarkungscluster gefunden werden konnte, 
  * steht in beiden OUT-Variablen NULL. 
  * 
  * @raise Alle Fehler werden geworfen, jedoch nicht NO_DATA_FOUND. 

  PROCEDURE "P_GET_BANDBREITEN" 
  ( 
    pin_haus_lfd_nr            IN vermarktungscluster_objekt.haus_lfd_nr%TYPE 
   ,pon_mindestbandbreite      OUT vermarktungscluster.mindestbandbreite%TYPE 
   ,pon_zielbandbreite_geplant OUT vermarktungscluster.zielbandbreite_geplant%TYPE 
  ) IS 
    vr_vermarktungscluster vermarktungscluster%ROWTYPE; 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
    cv_routine_name CONSTANT logs.routine_name%TYPE := 'p_get_bandbreiten'; 
    FUNCTION fcl_params RETURN logs.message%TYPE IS 
    BEGIN 
      pck_format.p_add('pin_haus_lfd_nr' 
                      ,pin_haus_lfd_nr); 
      -- (OUT): pon_mindestbandbreite 
      -- (OUT): pon_zielbandbreite_geplant 
      RETURN pck_format.fcl_params(cv_routine_name); 
    END fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
  BEGIN 
    vr_vermarktungscluster     := fr_vermarktungscluster(pin_haus_lfd_nr); 
    pon_mindestbandbreite      := vr_vermarktungscluster.mindestbandbreite; 
    pon_zielbandbreite_geplant := vr_vermarktungscluster.zielbandbreite_geplant; 
  EXCEPTION 
    WHEN no_data_found THEN 
      NULL; -- leer zurück 
    WHEN OTHERS THEN 
      pck_logs.p_error( 
              pic_message      => fcl_params() 
             ,piv_routine_name => qualified_name(cv_routine_name) 
             ,piv_scope        => G_SCOPE 
            ); 
      RAISE; 
  END p_get_bandbreiten; 
  */    

  /** 
  * Liefert den Text für das Display-Item "Verfügbare Bandbreite" (P20) zurück 
  * 
  * @param pin_min_bandbreite [IN] Wert für die kleinste Bandbreite in diesem Tarif 
  * @param pin_max_bandbreite [IN] Wert für die höchste Bandbreite in diesem Tarif 
  */
    function fv_get_bandbreiteninfo (
        pin_min_bandbreite in natural,
        pin_max_bandbreite in natural
    ) return varchar2
        deterministic
    is
    begin 
    -- Da die Bandbreiten Pflichtfelder des Vermarktungsclusters sind, 
    -- dürften die folgenden Zustände _eigentlich_ nicht auftreten, 
    -- aber hey ... 
        if
            pin_min_bandbreite is null
            and pin_max_bandbreite is null
        then
            return 'unbekannt (keinem Vermarktungscluster zugeordnet)';
        end if;
        if pin_min_bandbreite is null then
            return 'bis zu '
                   || to_char(pin_max_bandbreite)
                   || ' Mbit/s';
        end if;

        if pin_max_bandbreite is null then
            return 'mindestens '
                   || to_char(pin_min_bandbreite)
                   || ' Mbit/s';
        end if;

        return to_char(pin_min_bandbreite)
               || '-'
               || to_char(pin_max_bandbreite)
               || ' Mbit/s'; --- ///@weiter: Sonderfälle etc. 
    end fv_get_bandbreiteninfo; 

  /** 
  * Nimmt die APEX-Glascontainer-Felder eines Auftrags entgegen 
  * und liefert die Daten im Zeilenformat der Synchronisationstabelle 
  * ungeprüft zurück 
  * 
  * @param piv_uuid [IN ] PK des Auftrags. 
  * Alle weiteren Felder siehe Webservice-Spezifikation 
  * 
  * @usage ///@klären: wo wird das verwendet? 
  * @raise Keine Prüfung, keine Fehlerbehandlung, alle Exceptions werden geworfen 
  */
    function fr_auftragsdaten (
        piv_uuid                           in varchar2,
        piv_vkz                            in varchar2,
        piv_kundennummer                   in varchar2,
        piv_promotion                      in varchar2,
        piv_router_auswahl                 in varchar2,
        piv_router_eigentum                in varchar2,
        piv_installationsservice           in varchar2,
        piv_haus_anschlusspreis            in varchar2,
        piv_mandant                        in varchar2,
        piv_firmenname                     in varchar2,
        piv_anrede                         in varchar2,
        piv_titel                          in varchar2,
        piv_vorname                        in varchar2,
        piv_nachname                       in varchar2,
        piv_geburtsdatum                   in varchar2,
        piv_email                          in varchar2,
        piv_wohndauer                      in varchar2,
        piv_laendervorwahl                 in varchar2,
        piv_vorwahl                        in varchar2,
        piv_telefon                        in varchar2,
        piv_passwort                       in varchar2, 
    ---- 
        piv_providerwechsel                in varchar2,
        piv_providerw_aktueller_anbieter   in varchar2,
        piv_providerw_anschluss_gekuendigt in varchar2,
        piv_providerw_kuendigungsdatum     in varchar2,
        piv_providerw_anmeldung_anrede     in varchar2,
        piv_providerw_anmeldung_nachname   in varchar2,
        piv_providerw_anmeldung_vorname    in varchar2,
        piv_providerw_nummer_behalten      in varchar2,
        piv_providerw_laendervorwahl       in varchar2,
        piv_providerw_vorwahl              in varchar2,
        piv_providerw_telefon              in varchar2, 
    ---- 
        piv_kontoinhaber                   in varchar2,
        piv_sepa                           in varchar2,
        piv_iban                           in varchar2,
        piv_anschluss_strasse              in varchar2,
        piv_anschluss_hausnr               in varchar2,
        piv_anschluss_plz                  in varchar2,
        piv_anschluss_ort                  in varchar2,
        piv_anschluss_zusatz               in varchar2,
        piv_anschluss_land                 in varchar2,
        piv_haus_lfd_nr                    in varchar2,
        piv_gee_rolle                      in varchar2,
        piv_anzahl_we                      in varchar2,
        piv_vermieter_rechtsform           in varchar2,
        piv_vermieter_firmenname           in varchar2,
        piv_vermieter_anrede               in varchar2,
        piv_vermieter_titel                in varchar2,
        piv_vermieter_vorname              in varchar2,
        piv_vermieter_nachname             in varchar2,
        piv_vermieter_strasse              in varchar2,
        piv_vermieter_hausnr               in varchar2,
        piv_vermieter_plz                  in varchar2,
        piv_vermieter_ort                  in varchar2,
        piv_vermieter_zusatz               in varchar2,
        piv_vermieter_land                 in varchar2,
        piv_vermieter_email                in varchar2,
        piv_vermieter_laendervorwahl       in varchar2,
        piv_vermieter_vorwahl              in varchar2,
        piv_vermieter_telefon              in varchar2,
        piv_vermieter_einverstaendnis      in varchar2,
        piv_bestaetigung_vzf               in varchar2,
        piv_zustimmung_agb                 in varchar2,
        piv_zustimmung_widerruf            in varchar2,
        piv_opt_in_email                   in varchar2,
        piv_opt_in_telefon                 in varchar2,
        piv_opt_in_sms_mms                 in varchar2,
        piv_opt_in_post                    in varchar2,
        piv_vertragszusammenfassung        in varchar2,
        piv_status                         in varchar2 
    --///@weiter mit den neuen Feldern ... 
    -- piv_is_new_customer ,piv_created ... 
    --- ... 
    ) return ftth_ws_sync_preorders%rowtype is

        vr              ftth_ws_sync_preorders%rowtype; 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'fr_auftragsdaten';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_uuid', piv_uuid);
            pck_format.p_add('piv_vkz', piv_vkz);
            pck_format.p_add('piv_kundennummer', piv_kundennummer);
            pck_format.p_add('piv_promotion', piv_promotion);
            pck_format.p_add('piv_router_auswahl', piv_router_auswahl);
            pck_format.p_add('piv_router_eigentum', piv_router_eigentum);
            pck_format.p_add('piv_installationsservice', piv_installationsservice);
            pck_format.p_add('piv_haus_anschlusspreis', piv_haus_anschlusspreis);
            pck_format.p_add('piv_mandant', piv_mandant);
            pck_format.p_add('piv_firmenname', piv_firmenname);
            pck_format.p_add('piv_anrede', piv_anrede);
            pck_format.p_add('piv_titel', piv_titel);
            pck_format.p_add('piv_vorname', piv_vorname);
            pck_format.p_add('piv_nachname', piv_nachname);
            pck_format.p_add('piv_geburtsdatum', piv_geburtsdatum);
            pck_format.p_add('piv_email', piv_email);
            pck_format.p_add('piv_wohndauer', piv_wohndauer);
            pck_format.p_add('piv_laendervorwahl', piv_laendervorwahl);
            pck_format.p_add('piv_vorwahl', piv_vorwahl);
            pck_format.p_add('piv_telefon', piv_telefon);
            pck_format.p_add('piv_passwort', piv_passwort);
            pck_format.p_add('piv_providerw_aktueller_anbieter', piv_providerw_aktueller_anbieter);
            pck_format.p_add('piv_providerw_anschluss_gekuendigt', piv_providerw_anschluss_gekuendigt);
            pck_format.p_add('piv_providerw_kuendigungsdatum', piv_providerw_kuendigungsdatum);
            pck_format.p_add('piv_providerw_anmeldung_anrede', piv_providerw_anmeldung_anrede);
            pck_format.p_add('piv_providerw_anmeldung_nachname', piv_providerw_anmeldung_nachname);
            pck_format.p_add('piv_providerw_anmeldung_vorname', piv_providerw_anmeldung_vorname);
            pck_format.p_add('piv_providerw_nummer_behalten', piv_providerw_nummer_behalten);
            pck_format.p_add('piv_providerw_laendervorwahl', piv_providerw_laendervorwahl);
            pck_format.p_add('piv_providerw_vorwahl', piv_providerw_vorwahl);
            pck_format.p_add('piv_providerw_telefon', piv_providerw_telefon);
            pck_format.p_add('piv_sepa', piv_sepa);
            pck_format.p_add('piv_iban',
                             fv_iban_maskiert(piv_iban));
            pck_format.p_add('piv_anschluss_strasse', piv_anschluss_strasse);
            pck_format.p_add('piv_anschluss_hausnr', piv_anschluss_hausnr);
            pck_format.p_add('piv_anschluss_plz', piv_anschluss_plz);
            pck_format.p_add('piv_anschluss_ort', piv_anschluss_ort);
            pck_format.p_add('piv_anschluss_zusatz', piv_anschluss_zusatz);
            pck_format.p_add('piv_anschluss_land', piv_anschluss_land);
            pck_format.p_add('piv_haus_lfd_nr', piv_haus_lfd_nr);
            pck_format.p_add('piv_gee_rolle', piv_gee_rolle);
            pck_format.p_add('piv_anzahl_we', piv_anzahl_we);
            pck_format.p_add('piv_vermieter_rechtsform', piv_vermieter_rechtsform);
            pck_format.p_add('piv_vermieter_firmenname', piv_vermieter_firmenname);
            pck_format.p_add('piv_vermieter_anrede', piv_vermieter_anrede);
            pck_format.p_add('piv_vermieter_titel', piv_vermieter_titel);
            pck_format.p_add('piv_vermieter_vorname', piv_vermieter_vorname);
            pck_format.p_add('piv_vermieter_nachname', piv_vermieter_nachname);
            pck_format.p_add('piv_vermieter_strasse', piv_vermieter_strasse);
            pck_format.p_add('piv_vermieter_hausnr', piv_vermieter_hausnr);
            pck_format.p_add('piv_vermieter_plz', piv_vermieter_plz);
            pck_format.p_add('piv_vermieter_ort', piv_vermieter_ort);
            pck_format.p_add('piv_vermieter_zusatz', piv_vermieter_zusatz);
            pck_format.p_add('piv_vermieter_land', piv_vermieter_land);
            pck_format.p_add('piv_vermieter_email', piv_vermieter_email);
            pck_format.p_add('piv_vermieter_laendervorwahl', piv_vermieter_laendervorwahl);
            pck_format.p_add('piv_vermieter_vorwahl', piv_vermieter_vorwahl);
            pck_format.p_add('piv_vermieter_telefon', piv_vermieter_telefon);
            pck_format.p_add('piv_vermieter_einverstaendnis', piv_vermieter_einverstaendnis);
            pck_format.p_add('piv_bestaetigung_vzf', piv_bestaetigung_vzf);
            pck_format.p_add('piv_zustimmung_agb', piv_zustimmung_agb);
            pck_format.p_add('piv_zustimmung_widerruf', piv_zustimmung_widerruf);
            pck_format.p_add('piv_opt_in_email', piv_opt_in_email);
            pck_format.p_add('piv_opt_in_telefon', piv_opt_in_telefon);
            pck_format.p_add('piv_opt_in_sms_mms', piv_opt_in_sms_mms);
            pck_format.p_add('piv_opt_in_post', piv_opt_in_post);
            pck_format.p_add('piv_vertragszusammenfassung', piv_vertragszusammenfassung);
            pck_format.p_add('piv_status', piv_status);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        vr.id := piv_uuid;
        vr.vkz := piv_vkz;
        vr.customernumber := piv_kundennummer;
        vr.templateid := piv_promotion;
        vr.devicecategory := piv_router_auswahl;
        vr.deviceownership := piv_router_eigentum;
        vr.installationservice := piv_installationsservice;
        vr.houseconnectionprice := piv_haus_anschlusspreis;
        vr.client := piv_mandant;
        vr.customer_businessname := piv_firmenname;
        vr.customer_salutation := piv_anrede;
        vr.customer_title := piv_titel;
        vr.customer_name_first := piv_vorname;
        vr.customer_name_last := piv_nachname;
        vr.customer_birthdate := piv_geburtsdatum;
        vr.customer_email := piv_email;
        vr.customer_residentstatus := piv_wohndauer;
        vr.customer_phone_countrycode := piv_laendervorwahl;
        vr.customer_phone_areacode := piv_vorwahl;
        vr.customer_phone_number := piv_telefon; 
--    vr.customer_password          := piv_passwort; -- ///@deprecated 
    -- vr. := piv_providerwechsel ; -- dafür existiert kein Feld in der Tabelle 
        vr.providerchg_current_provider := piv_providerw_aktueller_anbieter;
        vr.providerchg_contract_cancelled := piv_providerw_anschluss_gekuendigt;
        vr.providerchg_cancellation_date := piv_providerw_kuendigungsdatum;
        vr.providerchg_owner_salutation := piv_providerw_anmeldung_anrede;
        vr.providerchg_owner_name_first := piv_providerw_anmeldung_vorname;
        vr.providerchg_owner_name_last := piv_providerw_anmeldung_nachname;
        vr.providerchg_keep_phone_number := piv_providerw_nummer_behalten;
        vr.providerchg_phone_countrycode := piv_providerw_laendervorwahl;
        vr.providerchg_phone_areacode := piv_providerw_vorwahl;
        vr.providerchg_phone_number := piv_providerw_telefon;
        vr.account_holder := piv_kontoinhaber;
        vr.account_sepamandate := piv_sepa;
        vr.account_iban := piv_iban;
        vr.install_addr_street := piv_anschluss_strasse;
        vr.install_addr_housenumber := piv_anschluss_hausnr;
        vr.install_addr_zipcode := piv_anschluss_plz;
        vr.install_addr_city := piv_anschluss_ort;
        vr.install_addr_addition := piv_anschluss_zusatz;
        vr.install_addr_country := piv_anschluss_land;
        vr.houseserialnumber := piv_haus_lfd_nr;
        vr.prop_owner_role := piv_gee_rolle;
        vr.prop_residential_unit := piv_anzahl_we;
        vr.landlord_legalform := piv_vermieter_rechtsform;
        vr.landlord_businessorname := piv_vermieter_firmenname;
        vr.landlord_salutation := piv_vermieter_anrede;
        vr.landlord_title := piv_vermieter_titel;
        vr.landlord_name_first := piv_vermieter_vorname;
        vr.landlord_name_last := piv_vermieter_nachname;
        vr.landlord_addr_street := piv_vermieter_strasse;
        vr.landlord_addr_housenumber := piv_vermieter_hausnr;
        vr.landlord_addr_zipcode := piv_vermieter_plz;
        vr.landlord_addr_city := piv_vermieter_ort;
        vr.landlord_addr_addition := piv_vermieter_zusatz;
        vr.landlord_addr_country := piv_vermieter_land;
        vr.landlord_email := piv_vermieter_email;
        vr.landlord_phone_countrycode := piv_vermieter_laendervorwahl;
        vr.landlord_phone_areacode := piv_vermieter_vorwahl;
        vr.landlord_phone_number := piv_vermieter_telefon;
        vr.landlord_agreed := piv_vermieter_einverstaendnis;
        vr.summ_precontractinformation := piv_bestaetigung_vzf;
        vr.summ_generaltermsandconditions := piv_zustimmung_agb;
        vr.summ_waiverightofrevocation := piv_zustimmung_widerruf;
        vr.summ_emailmarketing := piv_opt_in_email;
        vr.summ_phonemarketing := piv_opt_in_telefon;
        vr.summ_smsmmsmarketing := piv_opt_in_sms_mms;
        vr.summ_mailmarketing := piv_opt_in_post;
        vr.summ_ordersummaryfileid := piv_vertragszusammenfassung;
        vr.state := piv_status;
        return vr;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end fr_auftragsdaten; 

  /** 
  * Nimmt einen Auftrag entgegen (alle Felder sollten gefüllt sein!) und schreibt 
  * ihn in die Tabelle FTTH_WS_SYNC_PREORDERS, so dass der zuletzt nächtlich synchronisierte 
  * Datensatz anschließend diesem aktuellen Zustand entspricht 
  * 
  * @param pir_preorder [IN OUT] Auftragsdaten, mit denen die SYNC-Tabelle 
  * aktualisiert werden soll 
  * 
  * @usage Die Prozedur führt keine Validierung durch! 
  * Der Datensatz wird nicht als Update zum Webservice gesendet, denn 
  * der Sinn dieser Synchronisation ist, dass im Fall eines späteren 
  * Ausfalls des Webservices wenigstens die aktuellst möglichen Daten 
  * geholt werden, wenn der Auftrag im Laufe des Tages erneut angezeigt werden soll. 
  * 
  * 
  * @return Im Erfolgsfall steht in pir_preorder.APEX$ROW_SYNC_TIMESTAMP die aktuelle Uhrzeit 
  * 
  * @raise Alle Fehler werden geworfen, kein Logging. 
  */
    procedure p_auftragsdaten_synchronisieren (
        pir_preorder in out ftth_ws_sync_preorders%rowtype
    ) is 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'p_auftragsdaten_synchronisieren';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pir_preorder.id', pir_preorder.id);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        if pir_preorder.id is null then
            raise_application_error(-20000, 'Synchronisierung fehlgeschlagen: UUID fehlt');
        end if; 
    -- ///@weiter: auf Pflichtfelder prüfen, sonstige Validierungen ausführen 
    -- Erkennungsmerkmal, dass diese Zeile zuletzt nicht nächtlich, sondern 
    -- durch den Aufruf im APEX Glascontainer synchronisiert wurde: 
        pir_preorder.apex$sync_step_static_id := $$plsql_unit || ' (MRG)'; -- 'PCK_GLASCONTAINER (MRG)' 
    -- Die Spalte ist typischerweise leer, da in APEX keine "Steps" für die Synchronisierung eingerichtet sind, 
    -- und falls doch, hätten diese positive IDs 
    -- In jedem Fall die Synchronisierungs-Uhrzeit eintragen: 
        pir_preorder.apex$row_sync_timestamp := systimestamp; 
    -- Prüfen, ob es den Auftrag bereits gibt und wenn ja, dann updaten. 
    -- Ansonsten: einen neuen Datensatz einfügen. 
    -- Dieses Skript erzeugt die Felder-Liste: 
    -- SELECT ', dest.' || column_name || ' = pir_preorder.' || column_name 
    -- FROM cols 
    -- WHERE table_name = 'FTTH_WS_SYNC_PREORDERS' 
    -- AND column_name <> 'ID' 
    -- ORDER BY column_id; 
        merge into ftth_ws_sync_preorders dest
        using (
            select
                null
            from
                dual
        ) on ( dest.id = pir_preorder.id )
        when matched then update
        set dest.templateid = pir_preorder.templateid,
            dest.devicecategory = pir_preorder.devicecategory,
            dest.deviceownership = pir_preorder.deviceownership,
            dest.installationservice = pir_preorder.installationservice,
            dest.houseconnectionprice = pir_preorder.houseconnectionprice,
            dest.summ_ordersummaryfileid = pir_preorder.summ_ordersummaryfileid,
            dest.state = pir_preorder.state,
            dest.vkz = pir_preorder.vkz,
            dest.client = pir_preorder.client,
            dest.customernumber = pir_preorder.customernumber,
            dest.customer_businessname = pir_preorder.customer_businessname,
            dest.customer_salutation = pir_preorder.customer_salutation,
            dest.customer_title = pir_preorder.customer_title,
            dest.customer_name_first = pir_preorder.customer_name_first,
            dest.customer_name_last = pir_preorder.customer_name_last,
            dest.customer_birthdate = pir_preorder.customer_birthdate,
            dest.customer_email = pir_preorder.customer_email,
            dest.customer_phone_countrycode = pir_preorder.customer_phone_countrycode,
            dest.customer_phone_areacode = pir_preorder.customer_phone_areacode,
            dest.customer_phone_number = pir_preorder.customer_phone_number,
            dest.houseserialnumber = pir_preorder.houseserialnumber,
            dest.customer_residentstatus = pir_preorder.customer_residentstatus,
            dest.install_addr_country = pir_preorder.install_addr_country,
            dest.install_addr_zipcode = pir_preorder.install_addr_zipcode,
            dest.install_addr_city = pir_preorder.install_addr_city,
            dest.install_addr_street = pir_preorder.install_addr_street,
            dest.install_addr_housenumber = pir_preorder.install_addr_housenumber,
            dest.install_addr_addition = pir_preorder.install_addr_addition,
            dest.providerchg_current_provider = pir_preorder.providerchg_current_provider,
            dest.providerchg_keep_phone_number = pir_preorder.providerchg_keep_phone_number,
            dest.providerchg_phone_countrycode = pir_preorder.providerchg_phone_countrycode,
            dest.providerchg_phone_areacode = pir_preorder.providerchg_phone_areacode,
            dest.providerchg_phone_number = pir_preorder.providerchg_phone_number,
            dest.providerchg_contract_cancelled = pir_preorder.providerchg_contract_cancelled,
            dest.providerchg_cancellation_date = pir_preorder.providerchg_cancellation_date,
            dest.providerchg_owner_salutation = pir_preorder.providerchg_owner_salutation,
            dest.providerchg_owner_name_first = pir_preorder.providerchg_owner_name_first,
            dest.providerchg_owner_name_last = pir_preorder.providerchg_owner_name_last,
            dest.account_sepamandate = pir_preorder.account_sepamandate,
            dest.account_holder = pir_preorder.account_holder,
            dest.landlord_name_last = pir_preorder.landlord_name_last,
            dest.account_iban = pir_preorder.account_iban,
            dest.landlord_name_first = pir_preorder.landlord_name_first,
            dest.landlord_email = pir_preorder.landlord_email,
            dest.landlord_title = pir_preorder.landlord_title,
            dest.landlord_addr_city = pir_preorder.landlord_addr_city,
            dest.landlord_addr_street = pir_preorder.landlord_addr_street,
            dest.landlord_addr_country = pir_preorder.landlord_addr_country,
            dest.landlord_addr_zipcode = pir_preorder.landlord_addr_zipcode,
            dest.landlord_addr_housenumber = pir_preorder.landlord_addr_housenumber,
            dest.landlord_addr_addition = pir_preorder.landlord_addr_addition,
            dest.landlord_legalform = pir_preorder.landlord_legalform,
            dest.landlord_salutation = pir_preorder.landlord_salutation,
            dest.landlord_phone_number = pir_preorder.landlord_phone_number,
            dest.landlord_phone_areacode = pir_preorder.landlord_phone_areacode,
            dest.landlord_phone_countrycode = pir_preorder.landlord_phone_countrycode,
            dest.landlord_businessorname = pir_preorder.landlord_businessorname,
            dest.prop_residential_unit = pir_preorder.prop_residential_unit,
            dest.prop_owner_role = pir_preorder.prop_owner_role,
            dest.landlord_agreed = pir_preorder.landlord_agreed,
            dest.summ_precontractinformation = pir_preorder.summ_precontractinformation,
            dest.summ_generaltermsandconditions = pir_preorder.summ_generaltermsandconditions,
            dest.summ_waiverightofrevocation = pir_preorder.summ_waiverightofrevocation,
            dest.summ_emailmarketing = pir_preorder.summ_emailmarketing,
            dest.summ_phonemarketing = pir_preorder.summ_phonemarketing,
            dest.summ_smsmmsmarketing = pir_preorder.summ_smsmmsmarketing,
            dest.summ_mailmarketing = pir_preorder.summ_mailmarketing,
            dest.customer_prev_addr_street = pir_preorder.customer_prev_addr_street,
            dest.customer_prev_addr_housenumber = pir_preorder.customer_prev_addr_housenumber,
            dest.customer_prev_addr_addition = pir_preorder.customer_prev_addr_addition,
            dest.customer_prev_addr_zipcode = pir_preorder.customer_prev_addr_zipcode,
            dest.customer_prev_addr_city = pir_preorder.customer_prev_addr_city,
            dest.customer_prev_addr_country = pir_preorder.customer_prev_addr_country,
            dest.customer_upd_email = pir_preorder.customer_upd_email,
            dest.customer_upd_phone_countrycode = pir_preorder.customer_upd_phone_countrycode,
            dest.customer_upd_phone_areacode = pir_preorder.customer_upd_phone_areacode,
            dest.customer_upd_phone_number = pir_preorder.customer_upd_phone_number 
         --   ,dest.CUSTOMER_PASSWORD              = pir_preorder.CUSTOMER_PASSWORD 
            ,
            dest.apex$sync_step_static_id = pir_preorder.apex$sync_step_static_id,
            dest.apex$row_sync_timestamp = pir_preorder.apex$row_sync_timestamp,
            dest.is_new_customer = pir_preorder.is_new_customer,
            dest.created = pir_preorder.created,
            dest.last_modified = pir_preorder.last_modified,
            dest.version = pir_preorder.version,
            dest.process_lock = pir_preorder.process_lock,
            dest.process_lock_last_modified = pir_preorder.process_lock_last_modified 
            -- 2023-08-24 neue Spalten: 
            ,
            dest.siebel_order_number = pir_preorder.siebel_order_number,
            dest.siebel_order_rowid = pir_preorder.siebel_order_rowid,
            dest.siebel_ready = pir_preorder.siebel_ready,
            dest.service_plus_email = pir_preorder.service_plus_email -- @FTTH-5002
            -- 2023-12-06 neue Spalten: 
            ,
            dest.manual_transfer = pir_preorder.manual_transfer,
            dest.ont_provider = pir_preorder.ont_provider,
            dest.wholebuy_partner = pir_preorder.wholebuy_partner 
            -- 2024-08-21:
            ,
            dest.connectivity_id = pir_preorder.connectivity_id                 -- @ticket FTTH-3727
            ,
            dest.rt_contact_data_ticket_id = pir_preorder.rt_contact_data_ticket_id       -- @ticket FTTH-3727
            ,
            dest.landlord_information_required = pir_preorder.landlord_information_required   -- @ticket FTTH-3727
            -- neu 2024-08-23 @ticket FTTH-3711:
            ,
            dest.update_customer_in_siebel = pir_preorder.update_customer_in_siebel,
            dest.home_id = pir_preorder.home_id,
            dest.account_id = pir_preorder.account_id,
            dest.availability_date = pir_preorder.availability_date -- @ticket FTTH-3880
            -- ... @SYNC#12
        when not matched then
        insert
        values
            pir_preorder;

    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end p_auftragsdaten_synchronisieren; 

  /** 
  * Schreibt nach der Änderung eines Auftrags im APEX Glascontainer die neuen Daten 
  * (und zwar nur diejenigen, die zur Änderung vorgesehen sind, sowie das Lock) 
  * zurück in die Synchronisationstabelle, um bei Webservice-Ausfällen 
  * die letzten Änderungen aus dem lokalen Puffer lesen zu können. 
  * 
  * @param piv_uuid                 [IN ] PK des Auftrags 
  * @param piv_promotion            [IN ] Änderbares Feld im Glascontainer (kombiniert: Promotion & Produkt - eindeutig anhand der Selectliste) 
  * @param piv_router_auswahl       [IN ] Änderbares Feld im Glascontainer 
  * @param piv_router_eigentum      [IN ] Änderbares Feld im Glascontainer 
  * @param piv_installationsservice [IN ] Änderbares Feld im Glascontainer 
  * 
  * @usage Es werden keine fachlichen Validierungen ausgeführt, allerdings handelt es sich 
  * durchgehend um Pflichtfelder, so dass eine Exception geworfen wird, 
  * sobald eines davon leer ist 
  * 
  * @raise Es erfolgt ein Logging im Fehlerfall. Alle Fehler werden geworfen. 
  */
    procedure p_auftragsdaten_synchronisieren -- ////@todo umbenennen zu p_produktdaten_synchronisieren, sonst Verwechslung mit der Proc hierüber
     (
        piv_uuid                 in varchar2,
        piv_promotion            in varchar2,
        piv_router_auswahl       in varchar2,
        piv_router_eigentum      in varchar2,
        piv_installationsservice in varchar2
    ) is 
    --- v_process_lock_last_modified ftth_ws_sync_preorders.process_lock_last_modified%type; 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'p_auftragsdaten_synchronisieren';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_uuid', piv_uuid);
            pck_format.p_add('piv_promotion', piv_promotion);
            pck_format.p_add('piv_router_auswahl', piv_router_auswahl);
            pck_format.p_add('piv_router_eigentum', piv_router_eigentum);
            pck_format.p_add('piv_installationsservice', piv_installationsservice);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        if piv_uuid is null then
            raise_application_error(-20000, 'UUID fehlt');
        end if; 
    -- ///@todo: auf Funktionen abstützen 
        if piv_promotion is null then
            raise_application_error(-20000, 'Produkt/Promotion fehlt');
        end if;
        if piv_router_auswahl is null then
            raise_application_error(-20000, 'Router-Auswahl fehlt');
        end if;
        if
            piv_router_auswahl <> enum_devicecategory_byod
            and piv_router_eigentum is null
        then
            raise_application_error(-20000, 'Router-Eigentum fehlt');
        end if;

        if piv_installationsservice is null then
            raise_application_error(-20000, 'Installationsservice fehlt');
        end if; 
    -- //// @todo @Herbst-2023-Tarife 
        update ftth_ws_sync_preorders
        set
            templateid = piv_promotion,
            devicecategory = piv_router_auswahl,
            deviceownership = piv_router_eigentum,
            installationservice = piv_installationsservice,
            apex$sync_step_static_id = $$plsql_unit || ' (UPD)' -- Erkennungsmerkmal 
            ,
            apex$row_sync_timestamp = systimestamp -- In jedem Fall die Synchronisierungs-Uhrzeit eintragen 
           -- neu 2022-09-21: 
            ,
            process_lock = 'true',
            process_lock_last_modified = sysdate -- momentan spart das einen WS-Aufruf, aber das Lock gehört eigentlich dem Server! 
        where
            id = piv_uuid;

        if sql%rowcount <> 1 then
            raise_application_error(-20000, 'Lokale Synchronisierung nach Änderung fehlgeschlagen: ' || sqlerrm);
        end if;

    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end p_auftragsdaten_synchronisieren; 

  /** 
  * Nimmt die aktuellen Auftragsdaten in JSON-Form entgegen und aktualisiert 
  * die entsprechende Zeile in der Sync-Tabelle FTTH_WS_SYNC_PREORDERS 
  * 
  * @param piv_json [IN ] Vollständiges, valides JSON-Dokument des Auftrags, 
  * typischerweise frisch erhalten vom Webservice "preoders" 
  * 
  */
    procedure p_auftragsdaten_synchronisieren (
        piv_json in clob
    ) is

        v_preorder      ftth_ws_sync_preorders%rowtype; 
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'p_auftragsdaten_synchronisieren';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_json',
                             dbms_lob.substr(piv_json, 1000, 1));
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
  -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------      
    begin
        v_preorder := fr_preorder_from_json(piv_json);
        if piv_json is null
           or piv_json = c_empty_json then
            return; -- Leere Auftragsdaten entstehen, wenn man im Entwicklermodus die Seite erneut aufruft 
        end if;
        p_auftragsdaten_synchronisieren(pir_preorder => v_preorder);
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end p_auftragsdaten_synchronisieren; 

  /** 
  * Gibt die Anzahl Sekunden zwischen zwei TIMESTAMPs oder zwei DATEs zurück, 
  * inklusive Nachkommastellen. 
  * 
  * @param pit_frueher [IN ] Beginn der Messung 
  * @param pit_spaeter [IN ] Ende der Messung 
  * 
  * @usage Nur wenn die beiden Zeiten völlig identisch sind, 
  * wird eine glatte 0 zurückgegeben. Die Funktion sollte entweder mit 
  * zwei TIMESTAMPS oder mit zwei DATES aufgerufen werden (nicht mit 
  * gemischten Datentypen), ansonsten können unerwartete Differenzen im 
  * Sekundenbereich die Folge sein (Oracle rechnet halt so). 
  * 
  * @example SELECT pck_glascontainer.fn_sekunden_zwischen(SYSTIMESTAMP - INTERVAL '10' SECOND, SYSTIMESTAMP) FROM DUAL; -- 10 
  * @example SELECT pck_glascontainer.fn_sekunden_zwischen(SYSDATE, SYSDATE) FROM DUAL; -- 0 
  * @example SELECT pck_glascontainer.fn_sekunden_zwischen(SYSDATE, SYSDATE - 1) FROM DUAL; -- -86400 = minus 1 Tag: früher/später vertauscht! 
  */
    function fn_sekunden_zwischen (
        pit_frueher in timestamp,
        pit_spaeter in timestamp
    ) return number is
        v_delta interval day ( 9 ) to second ( 0 );  -- war: INTERVAL DAY TO SECOND;   
    -- 2023-11-16 Präzision geändert aufgrund "ORA-01873: the leading precision of the interval is too small" 
    -- @url https://seanstuber.com/2020/12/23/oracle-intervals-day-to-second/ 
    begin
        v_delta := pit_spaeter - pit_frueher;
        return extract(second from v_delta) + extract(minute from v_delta) * 60 + extract(hour from v_delta) * 60 * 60 + extract(day from
        v_delta) * 60 * 60 * 24;

    end fn_sekunden_zwischen; 

 /** 
  * Gibt einen Leerstring zurück, wenn die erneute Synchronisierung eines bestimmten 
  * Webservices zulässig ist, ansonsten den Grund warum nicht 
  * 
  * @param piv_rest_source_static_id    [IN ] ID der REST Source, siehe APEX > Shared Components 
  * @param piv_apex_execution_chain_id  [IN ] (optional) Wenn gesetzt, dann prüft diese Funktion, ob im Hintergrund
  *                                           (per APEX Execution Chain) bereits eine Synchronisierung gestartet wurde,
  *                                           und gibt bis zu deren Fertigstellung eine entsprechende Meldung aus
  * 
  * @usage Die Beschränkung, ob bzw. wie häufig eine Synchronisierung erlaubt 
  * sein soll, wird genau in dieser Funktion festgelegt. Hierdurch wird 
  * übermäßiges und vor allem gleichzeitiges Synchronisieren durch 
  * mehrere Nutzer verhindert (Parameter "Sync-Wartezeit beträgt mindestens ...") 
  * 
  * Der Code ist so formuliert, dass eine 
  * Erweiterung auf unterschiedliche Webservices leicht fallen sollte. 
  */
    function fv_ws_sync_sperre (
        piv_rest_source_static_id   in varchar2,
        piv_apex_ececution_chain_id in varchar2 default null -- neu 2024-10-29
    ) return varchar2 is

        v_begruendung   varchar2(1000); -- bleibt leer wenn alles OK ist 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'fv_ws_sync_sperre';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_rest_source_static_id', piv_rest_source_static_id);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        case piv_rest_source_static_id 
    --------------------------- 
            when c_ws_static_id_preorders 
      --------------------------- 
             then
                declare 
          -- frühestens nach n Minuten ist erneutes Synchronisieren 
          -- der kompletten Auftragsliste zulässig 
                    n_minuten constant number := coalesce(
                        to_char(pck_glascontainer.fv_konfiguration_lesen(c_satzart_webservice, 'MIN_SYNC_INTERVAL_PREORDERS')),
                        10
                    );
                begin 
          -- prüfen ob die Wartezeit bereits verstrichen ist: 
                    if fn_sekunden_zwischen(
                        pit_frueher => apex_rest_source_sync.get_last_sync_timestamp(piv_rest_source_static_id),
                        pit_spaeter => systimestamp
                    ) < n_minuten * 60 then
                        v_begruendung := 'Das Aktualisieren der Auftragsliste ist nur alle '
                                         || n_minuten
                                         || ' Minuten erlaubt';
                    end if;

                end;
        end case;

        return v_begruendung;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            return 'Fehler bei Anfrage der Sync-Sperre für Webservice '
                   || piv_rest_source_static_id
                   || ': '
                   || sqlerrm;
    end fv_ws_sync_sperre; 


  /** 
  * Synchronisiert eine in APEX deklarierte REST Data Source, sofern dies 
  * anhand der in diesem Package gegebenen Geschäftsregeln (Sperrfrist) zulässig ist. 
  * 
  * @param piv_rest_source_static_id      ID der REST Source, siehe APEX > Shared Components. 
  *                                       Momentan einziger definierter Wert: 'preorders_' 
  * @param pib_sync_erzwingen             (optional) wenn TRUE, dann wird die Synchronisation auch dann 
  *                                       durchgeführt, wenn die Wartezeit ("Sync-Sperre") noch nicht abgelaufen ist 
  * 
  * @raise User Defined Exception, wenn die Synchronisierung aufgrund der Sperre 
  * nicht durchgeführt wird 
  * 
  * @usage Diese Prozedur muss im APEX-Kontext aufgerufen werden 
  * 
  * @example Aufruf der Prozedur aus dem Editor: 
  * BEGIN 
  * apex_session.attach(p_app_id => 2022, p_page_id => 10, p_session_id => 32481198917971); 
  * pck_glascontainer.p_webservice_synchronisieren(piv_rest_source_static_id => 'preorders_'); 
  * END; 
  */
    procedure p_webservice_synchronisieren (
        piv_rest_source_static_id in varchar2,
        pib_sync_erzwingen        in boolean default null
    ) is

        v_sync_sperre   varchar2(4000); 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'p_webservice_synchronisieren';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_rest_source_static_id', piv_rest_source_static_id);
            pck_format.p_add('pib_sync_erzwingen', pib_sync_erzwingen);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        v_sync_sperre := fv_ws_sync_sperre(piv_rest_source_static_id); -- "Sync-Wartezeit beträgt mindestens ..." 
        if pib_sync_erzwingen
        or v_sync_sperre is null then 
      -- neue Prüfung 2025-04-23 im Rahmen von @ticket FTTH-4987:
      -- Wenn inzwischen von anderer Seite eine Synchronisation gestartet wurde,
      -- dann muss hier abgeblockt werden:
            if apex_rest_source_sync.is_running(
                p_application_id   => 2022,
                p_module_static_id => piv_rest_source_static_id
            ) then
                raise_application_error(c_plausi_error_number, 'Eine Synchronisierung findet momentan bereits statt');
            end if;

            apex_rest_source_sync.synchronize_data(p_module_static_id => piv_rest_source_static_id); 
      -- Die neue Sperrzeit wird durch Abfrage ermittelt, muss hier nicht gesetzt werden 

      -- ////@todo: Hier prüfen (nur nötig in DEV oder TEST), ob die BASE_URL auf Default steht,
      -- ansonsten eine Fehlermeldung ausgeben:
            if pck_glascontainer_admin.is_base_url_default = 0 then
                raise_application_error(c_plausi_error_number, 'Eine Synchronisierung ist nur möglich, wenn die Datenquelle der REST-Synchronisierung auf dem Defaultwert für diese Umgebung steht.'
                );
            end if;
        else 
      -- 2022-11-23 neu: Fehlermeldung, wenn die Synchronisation aufgrund der Sperre 
      -- nicht ausgeführt werden kann (Anmerkung: In APEX kann pib_sync_erzwingen nicht 
      -- an der Benutzeroberfläche ausgewählt werden! Es könnte aber beispielsweise sein, dass 
      -- ein Benutzer einen inzwischen abgelaufenen Link "Erneut synchronisieren" erst wesentlich später anklickt) 
            raise_application_error(c_plausi_error_number, v_sync_sperre);
        end if;

    exception
        when others then
            if sqlcode <> c_plausi_error_number then
                pck_logs.p_error(
                    pic_message      => fcl_params(),
                    piv_routine_name => qualified_name(cv_routine_name),
                    piv_scope        => g_scope
                );
            end if;

            raise;
    end p_webservice_synchronisieren; 

  /** 
  * Schreibt (autonom) beim Start einer FuzzyDouble-Abfrage eine Log-Zeile mit den 
  * verwendeten Aufrufe-Parametern 
  * 
  * @param i_datum_von [IN] Für den Aufruf verwendeter Parameter DATUM_VON 
  * @param i_datum_bis [IN] Für den Aufruf verwendeter Parameter DATUM_BIS 
  * @param i_nur_neuzugaenge [IN] Für den Aufruf verwendeter Parameter NUR_NEUZUGAENGE 
  * @param i_ftth_id [IN] Für den Aufruf verwendeter Parameter FTTH_ID 
  * @param i_username [IN] APEX-User, der den Aufruf durchführt 
  * 
  * @return ID der erzeugten LOG-Zeile, damit diese nach Abschluss des Aufrufs 
  * vervollständigt werden kann 
  */
    function fn_fuzzy_request_protokollieren (
        i_datum_von       in date,
        i_datum_bis       in date,
        i_nur_neuzugaenge in natural,
        i_ftth_id         in varchar2,
        i_username        in varchar2
    ) return ftth_fuzzy_requests.id%type is

        pragma autonomous_transaction;
        v_fuzzy_request_id ftth_fuzzy_requests.id%type; 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name    constant logs.routine_name%type := 'fn_fuzzy_request_protokollieren';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('i_datum_von', i_datum_von);
            pck_format.p_add('i_datum_bis', i_datum_bis);
            pck_format.p_add('i_nur_neuzugaenge', i_nur_neuzugaenge);
            pck_format.p_add('i_ftth_id', i_ftth_id);
            pck_format.p_add('i_username', i_username);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        insert into ftth_fuzzy_requests (
            request_beginn,
            datum_von,
            datum_bis,
            ftth_id,
            nur_neuzugaenge,
            username
        ) values ( systimestamp,
                   i_datum_von,
                   i_datum_bis,
                   i_ftth_id,
                   nullif(i_nur_neuzugaenge, 0),
                   substr(i_username, 1, 30) ) returning id into v_fuzzy_request_id;

        commit;
        return v_fuzzy_request_id;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            rollback; -- kein RAISE 
    end; 

  /** 
  * Vervollständigt (autonom) nach dem Abschluss einer FuzzyDouble-Abfrage 
  * die entsprechende Log-Zeile mit den ermittelten Werten 
  * 
  * @param i_request_id [IN] ID der zuvor erzeugten LOG-Zeile 
  * @param pin_requests [IN] Aus wie vielen Aufrufen bestand die Abfrage (nur interessant bei Massenabfragen, 
  * um nachhalten zu können, ob die erlaubte maximale Anzahl an Webservice-Aufrufen 
  * im Workspace noch weit genug entfernt ist) 
  * @param piv_errormessage [IN] Im Fehlerfall: Die Fehlermeldung 
  */
    procedure p_fuzzy_protokoll_abschliessen (
        pin_request_id   in ftth_fuzzy_requests.id%type,
        pin_requests     in ftth_fuzzy_requests.requests%type,
        piv_errormessage in ftth_fuzzy_requests.errormessage%type
    ) is

        pragma autonomous_transaction; 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'p_fuzzy_protokoll_abschliessen';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_request_id', pin_request_id);
            pck_format.p_add('pin_requests', pin_requests);
            pck_format.p_add('piv_errormessage', piv_errormessage);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin 
    -- Kann passieren, wenn ein Exception-Handler schon vor dem Start 
    -- des ersten Requests angesprungen wurde: 
        if pin_request_id is null then
            return;
        end if; 
    -- Dann kann auch nichts aktualisiert werden, da gar kein Protokolleintrag existiert. 
        update ftth_fuzzy_requests
        set
            requests = pin_requests,
            request_ende = systimestamp,
            errormessage = piv_errormessage
        where
            id = pin_request_id;

        commit;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            rollback; -- kein RAISE 
    end; 

  /** 
  * Fragt für alle Preorder-Datensätze, deren Erstellungsdatum im angegebenen 
  * Zeitfenster liegt, die aktuellen Fuzzy!Double-Scores ab, und entfernt im Nachgang 
  * alle inzwischen überflüssigen Fuzzy-Einträge 
  * 
  * @param pid_datum_von       [IN ]  Nur Datensätze, deren Erstellungsdatum 
  *                                   ab diesem Tagesdatum beginnt 
  *                                   von diesem Datum oder jünger ist, werden abgefragt 
  * @param pid_datum_bis       [IN ]  Nur Datensätze, deren Erstellungsdatum 
  *                                   bis zu diesem Tagesdatum oder davor liegt, werden abgefragt 
  *                                   (optionale Angabe; wenn NULL dann gilt "bis heute") 
  * @param pib_nur_neuzugaenge [IN ]  (optional) Wenn TRUE, dann werden nur solche Datensätze 
  *                                   abgefragt, die noch keinen Score besitzen 
  * @param piv_ftth_id         [IN ]  (optional) Falls gefüllt, wird nur dieser bestimmte 
  *                                   Preorders-Datensatz geprüft 
  * 
  * @raise User Defined Error (nicht geloggt), wenn sämtliche Eingangsparameter leer sind. 
  * Alle anderen Fehler werden geloggt und geworfen. 
  * 
  * @example "Preorder-Buffer für Aufträge der letzten Woche scoren": 
  * BEGIN 
  *   PCK_GLASCONTAINER.p_fuzzy_auftragsliste_updaten(pid_datum_von => TRUNC(SYSDATE - 7)); 
  * END; 
  */
    procedure p_fuzzy_auftragsliste_updaten (
        pid_datum_von       in date default null,
        pid_datum_bis       in date default null,
        pib_nur_neuzugaenge in boolean default null,
        piv_ftth_id         in varchar2 default null,
        piv_username        in varchar2 default null
    ) is

        c_do_commit            constant boolean := true; -- //// prüfen, ob wir zukünftig ohne auskommen, oder parametrisieren 
        c_nur_neuzugaenge      constant naturaln :=
            case pib_nur_neuzugaenge
                when true then
                    1
                else 0
            end;
        vn_min_score_pho       number;
        vn_min_score_bnk       number;
        v_count_kandidaten     naturaln := 0;
        v_count_abfragen_pho   naturaln := 0;
        v_count_abfragen_bnk   naturaln := 0;
        v_fuzzy_request_id     ftth_fuzzy_requests.id%type;
        c_max_fuzzy_ergebnisse constant naturaln :=
            case
                when g_dev_or_test then
                    10
                else 100000000
            end; 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name        constant logs.routine_name%type := 'p_fuzzy_auftragsliste_updaten';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pid_datum_von', pid_datum_von);
            pck_format.p_add('pid_datum_bis', pid_datum_bis);
            pck_format.p_add('pib_nur_neuzugaenge', pib_nur_neuzugaenge);
            pck_format.p_add('piv_ftth_id', piv_ftth_id);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        if not pck_pob_rest.g_webservices_enabled then
            return;
        end if;
        if
            pid_datum_von is null
            and pid_datum_bis is null
            and pib_nur_neuzugaenge is null
            and piv_ftth_id is null
        then
            raise_application_error(c_plausi_error_number, 'Fuzzydouble für Auftragsliste: Alle Parameter sind leer');
        end if;

        vn_min_score_pho := fv_konfiguration_lesen(c_satzart_fuzzydouble, 'MIN_SCORE_PHO');
        vn_min_score_bnk := fv_konfiguration_lesen(c_satzart_fuzzydouble, 'MIN_SCORE_BNK');
        v_fuzzy_request_id := fn_fuzzy_request_protokollieren(
            i_datum_von       => pid_datum_von,
            i_datum_bis       => pid_datum_bis,
            i_nur_neuzugaenge => c_nur_neuzugaenge,
            i_ftth_id         => piv_ftth_id,
            i_username        => piv_username
        ); 

      -- welche Aufträge sollen auf Dubletten geprüft werden? 
        for auftrag in (
            select
                id as ftth_id,
                kundennummer,
                nachname,
                vorname,
                firmenname,
                strasse,
                hausnummer,
                plz,
                ort,
                iban,
                max_score_datum,
                created
            from
                (
                    select
                        id,
                        customernumber           as kundennummer,
                        customer_name_last       as nachname,
                        customer_name_first      as vorname,
                        customer_businessname    as firmenname,
                        install_addr_street      as strasse,
                        install_addr_housenumber as hausnummer,
                        install_addr_zipcode     as plz,
                        install_addr_city        as ort,
                        account_iban             as iban,
                        (
                            select
                                max(score_datum)
                            from
                                ftth_preorders_fuzzydouble f
                            where
                                f.ftth_id = p.id
                        )                        as max_score_datum,
                        created
                    from
                        ftth_ws_sync_preorders p 
                              --- 2023-02-01: stornierte Aufträge werden komplett ignoriert: 
                    where
                            p.state = status_in_review -- 2023-02-21: war zuvor: <> CANCELLED 
                        and p.customernumber is not null -- Sätze ohne Kundennummer gibt es in der Entwicklung, es folgen hässliche Fehler 
                )
            where
                created between trunc(nvl(pid_datum_von, date '2000-01-01')) and ( trunc(nvl(pid_datum_bis, sysdate)) + 1 ) - 1 / 24 / 60 / 60 -- 23:59:59 
                and ( c_nur_neuzugaenge = 0
                      or max_score_datum is null )
                and ( piv_ftth_id is null
                      or id = piv_ftth_id )
            order by
                id
        ) loop 
        -- Fuzzy abfragen: Pro Anfrage (kundenbasiert) kommen 0..n Ergebnisse zurück. 
            << naechster_auftrag >> v_count_kandidaten := 1 + v_count_kandidaten;
            declare
                v_fuzzy_id              ftth_preorders_fuzzydouble.id%type;
                v_fuzzydouble_status    ftth_preorders_fuzzydouble.status%type;
                v_siebel_kundennummer   ftth_preorders_fuzzydouble.kundennummer%type;
                v_siebel_global_id_self varchar2(255);
                v_anzahl_ergebnisse_pho naturaln := 0;
                v_anzahl_ergebnisse_bnk naturaln := 0;
            begin 
          -- bisherige Einträge löschen: 
          -- Ein MERGE ist hier nicht möglich, da prinzipiell jeden Tag unterschiedlich viele 
          -- Datensätze mit variierenden Scores gefunden werden könnten. 
                delete ftth_preorders_fuzzydouble
                where
                    ftth_id = auftrag.ftth_id 
          -- AND status IS NULL -- 29023-02-14: entfernt - der Status hat keine Bedeutung mehr, 
          -- seit nur noch NA abgespeichert wird und nicht mehr IGN oder S (C_FUZZY_STATUS_SELF << @deprecated)
                    ; 

          -- Aufgrund des Cascading Foreign Keys löscht dies auch den Detaildatensatz 
          -- in der Tabelle FTTH_PREORDERS_FUZZY_DETAILS 
          -- Fuzzy-ROW_ID (= Siebel GLOBAL_ID) mit der Kundennummer des Auftrags matchen, 
          -- damit klar ist, ob ein Ergebnis die identische Kundennummer repräsentiert 
          -- wie im Auftrag - dann wird es weiter unten verworfen 
                select
                    max(global_id)
                into v_siebel_global_id_self
                from
                    v_apx_gc_customerdata@siebp.netcologne.intern@siebel_inf
                where
                        kundennummer = auftrag.kundennummer 
          -- 2023-02-16: @Workaround 
                    and gueltig = 'Y' -- 2023-05: In der Entwicklung existiert dieses Feld leider noch nicht 
                               -- 2024-05-07: Bedingung hinzugefügt, Feld ist inzwischen vorhanden
                    ; 

          -- Mit jedem Datensatz die bisher definierten Fuzzy-Suchen durchführen: 
          -- 1. Name/Adresse 
                << phonetic_search >> begin
                    v_count_abfragen_pho := 1 + v_count_abfragen_pho;
                    for phonetic_search in ( 
                                    -- alle auskommentierten Spalten spielen für die Report-Übersicht 
                                    -- momentan keine Rolle. Eventuell könnte die RULE_NUMBER interessant werden, 
                                    -- oder man speichert auch eine Kurzform der Personen-/Adressdaten mit ab 
                        select
                            row_id,
                            rule_number,
                            score,
                            vorname,
                            nachname,
                            geburtsdatum,
                            firmenname,
                            strasse,
                            hausnummer,
                            plz,
                            ort,
                            iban,
                            kontonummer,
                            bic
                        from
                            table ( pck_fuzzydouble.ft_phonetic_search(
                                piv_nachname   => auftrag.nachname,
                                piv_vorname    => auftrag.vorname,
                                piv_firmenname => auftrag.firmenname,
                                piv_strasse    => auftrag.strasse,
                                piv_hausnummer => auftrag.hausnummer,
                                piv_plz        => auftrag.plz,
                                piv_ort        => auftrag.ort
                            ) )
                        where
                            ( vn_min_score_pho is null
                              or score >= vn_min_score_pho ) 
                                    -- der Minimum-Score kann leider nicht bereits bei der Abfrage als 
                                    -- Parameter mitgegeben werden, daher müssen letztlich die 
                                    -- Ergebnisse gefiltert werden 
                    ) loop
                        exit when v_anzahl_ergebnisse_pho >= c_max_fuzzy_ergebnisse;
                        declare
                            v_siebel_kundennummer_pho ftth_preorders_fuzzydouble.kundennummer%type;
                        begin
                            v_fuzzydouble_status :=
                                case
                                    when phonetic_search.row_id = v_siebel_global_id_self then
                                        c_fuzzy_status_self
                                end;
                            if v_fuzzydouble_status is null then 
                  -- die SELF-Datensätze interessieren nicht 
                                select
                                    max(kundennummer)
                                into v_siebel_kundennummer_pho
                                from
                                    v_apx_gc_customerdata@siebp.netcologne.intern@siebel_inf
                                where
                                        global_id = phonetic_search.row_id 
                  -- 2023-02-16: @Workaround 
                                    and gueltig = 'Y' -- In der Entwicklung existierte dieses Feld zunächst noch nicht, aktiviert am 2023-06-15 
                                    ; 

                  -- Diese Ersatz-Zuweisung kann auf PROD vermutlich wieder entfallen: 
                                if v_siebel_kundennummer_pho is null then
                                    v_siebel_kundennummer_pho := phonetic_search.row_id;
                                end if;
                                if v_siebel_kundennummer_pho is not null then
                                    v_anzahl_ergebnisse_pho := 1 + v_anzahl_ergebnisse_pho;
                                    insert into ftth_preorders_fuzzydouble (
                                        ftth_id,
                                        fuzzy_rowid,
                                        score_datum,
                                        score_typ,
                                        score,
                                        status,
                                        request_id,
                                        kundennummer
                                    ) values ( auftrag.ftth_id,
                                               phonetic_search.row_id,
                                               sysdate,
                                               'PHO',
                                               phonetic_search.score,
                                               v_fuzzydouble_status,
                                               v_fuzzy_request_id,
                                               v_siebel_kundennummer_pho ) returning ftth_preorders_fuzzydouble.id into v_fuzzy_id;

                                    insert into ftth_preorders_fuzzy_details (
                                        fuzzy_id,
                                        rule_number,
                                        vorname,
                                        nachname,
                                        geburtsdatum,
                                        firmenname,
                                        strasse,
                                        hausnummer,
                                        plz,
                                        ort,
                                        iban,
                                        kontonummer,
                                        bic
                                    ) values ( v_fuzzy_id,
                                               phonetic_search.rule_number,
                                               substr(phonetic_search.vorname, 1, 100),
                                               substr(phonetic_search.nachname, 1, 100),
                                               phonetic_search.geburtsdatum,
                                               substr(phonetic_search.firmenname, 1, 100),
                                               substr(phonetic_search.strasse, 1, 100),
                                               substr(phonetic_search.hausnummer, 1, 30),
                                               substr(phonetic_search.plz, 1, 30),
                                               substr(phonetic_search.ort, 1, 100),
                                               substr(phonetic_search.iban, 1, 30),
                                               substr(phonetic_search.kontonummer, 1, 30),
                                               substr(phonetic_search.bic, 1, 30) );

                                end if;

                            end if;

                        end;

                    end loop;

                exception
                    when others then
                        raise_application_error(-20000, sqlerrm
                                                        || '/ auftrag.ftth_id:'
                                                        || auftrag.ftth_id
                                                        || ',piv_nachname => '''
                                                        || auftrag.nachname
                                                        || ''''
                                                        || ',piv_vorname => '''
                                                        || auftrag.vorname
                                                        || ''''
                                                        || ',piv_firmenname => '''
                                                        || auftrag.firmenname
                                                        || ''''
                                                        || ',piv_strasse => '''
                                                        || auftrag.strasse
                                                        || ''''
                                                        || ',piv_hausnummer => '''
                                                        || auftrag.hausnummer
                                                        || ''''
                                                        || ',piv_plz => '''
                                                        || auftrag.plz
                                                        || ''''
                                                        || ',piv_ort => '''
                                                        || auftrag.ort
                                                        || '''');

                        << phonetic_search_error >> declare
                            v_errorcode number := sqlcode;
                            v_errortext varchar2(4000) := sqlerrm;
                        begin
                            insert into ftth_preorders_fuzzydouble (
                                ftth_id,
                                fuzzy_rowid,
                                score_datum,
                                score_typ,
                                score,
                                errorcode,
                                errortext,
                                status,
                                request_id
                            ) values ( auftrag.ftth_id,
                                       - 1,
                                       sysdate,
                                       'PHO',
                                       null,
                                       v_errorcode,
                                       v_errortext,
                                       v_fuzzydouble_status,
                                       v_fuzzy_request_id );

                        end phonetic_search_error;

                end phonetic_search; 
          -- Falls Fuzzy für die Phonetische Suche ein leeres Ergebnis zurückgeliefert hat, 
          -- muss dies ebenfalls als NULL-Datensatz vermerkt werden: 
                if v_anzahl_ergebnisse_pho = 0 then 
            -- Eintragen, dass die Suche ergebnislos war, damit ein vernünftiger Vorschlag 
            -- für das Fuzzy-Suchfenster in den Glascontainer-Einstellungen gemacht wird: 
                    insert into ftth_preorders_fuzzydouble (
                        ftth_id,
                        fuzzy_rowid,
                        score_datum,
                        score_typ,
                        score,
                        errorcode,
                        errortext,
                        status,
                        request_id
                    ) values ( auftrag.ftth_id,
                               null,
                               sysdate,
                               'PHO',
                               null,
                               null,
                               null,
                               c_fuzzy_status_empty,
                               v_fuzzy_request_id );

                end if; 
          -- 2. Bankverbindung vergleichen, wenn eine IBAN bekannt ist: 
                if auftrag.iban is not null then
                    v_count_abfragen_bnk := 1 + v_count_abfragen_bnk;
                    << doublet_check_bank >> begin
                        for doublet_check_bank in (
                            select
                                row_id,
                                score,
                                rule_number,
                                vorname,
                                nachname,
                                geburtsdatum,
                                firmenname,
                                strasse,
                                hausnummer,
                                plz,
                                ort,
                                iban,
                                kontonummer,
                                bic
                            from
                                table ( pck_fuzzydouble.ft_doublet_check_bank(piv_iban => auftrag.iban) )
                            where
                                ( vn_min_score_bnk is null
                                  or score >= vn_min_score_bnk )
                        ) loop
                            declare
                                v_siebel_kundennummer_bnk ftth_preorders_fuzzydouble.kundennummer%type;
                            begin
                                exit when v_anzahl_ergebnisse_bnk >= c_max_fuzzy_ergebnisse;
                                v_fuzzydouble_status :=
                                    case
                                        when doublet_check_bank.row_id = v_siebel_global_id_self then
                                            c_fuzzy_status_self
                                    end; 
                  -- 2023-01-31: SELF-Datensätze nicht mehr speichern 
                                if v_fuzzydouble_status is null then
                                    select
                                        max(kundennummer)
                                    into v_siebel_kundennummer_bnk
                                    from
                                        v_apx_gc_customerdata@siebp.netcologne.intern@siebel_inf
                                    where
                                            global_id = doublet_check_bank.row_id 
                    -- 2023-02-16: @Workaround 
                                        and gueltig = 'Y' -- 2023-05: In der Entwicklung existiert dieses Feld leider noch nicht 
                                         -- 2024-05-07: Bedingung hinzugefügt, Feld ist inzwischen vorhanden
                                        ; 
                    -- Diese Ersatz-Zuweisung kann auf PROD vermutlich entfallen 
                                    if v_siebel_kundennummer_bnk is null then
                                        v_siebel_kundennummer_bnk := doublet_check_bank.row_id;
                                    end if;
                                    if v_siebel_kundennummer_bnk is not null then
                                        v_anzahl_ergebnisse_bnk := 1 + v_anzahl_ergebnisse_bnk;
                                        insert into ftth_preorders_fuzzydouble (
                                            ftth_id,
                                            fuzzy_rowid,
                                            score_datum,
                                            score_typ,
                                            score,
                                            status,
                                            request_id,
                                            kundennummer
                                        ) values ( auftrag.ftth_id,
                                                   doublet_check_bank.row_id,
                                                   sysdate,
                                                   'BNK',
                                                   doublet_check_bank.score,
                                                   v_fuzzydouble_status,
                                                   v_fuzzy_request_id,
                                                   v_siebel_kundennummer_bnk ) returning ftth_preorders_fuzzydouble.id into v_fuzzy_id
                                                   ;

                                        insert into ftth_preorders_fuzzy_details (
                                            fuzzy_id,
                                            rule_number,
                                            vorname,
                                            nachname,
                                            geburtsdatum,
                                            firmenname,
                                            strasse,
                                            hausnummer,
                                            plz,
                                            ort,
                                            iban,
                                            kontonummer,
                                            bic
                                        ) values ( v_fuzzy_id,
                                                   doublet_check_bank.rule_number,
                                                   substr(doublet_check_bank.vorname, 1, 100),
                                                   substr(doublet_check_bank.nachname, 1, 100),
                                                   doublet_check_bank.geburtsdatum,
                                                   substr(doublet_check_bank.firmenname, 1, 100),
                                                   substr(doublet_check_bank.strasse, 1, 100),
                                                   substr(doublet_check_bank.hausnummer, 1, 30),
                                                   substr(doublet_check_bank.plz, 1, 30),
                                                   substr(doublet_check_bank.ort, 1, 100),
                                                   substr(doublet_check_bank.iban, 1, 30),
                                                   substr(doublet_check_bank.kontonummer, 1, 30),
                                                   substr(doublet_check_bank.bic, 1, 30) );

                                    end if;

                                end if;

                            end;
                        end loop;
                    exception
                        when others then
                            << doublet_check_bank_error >> declare
                                v_errorcode number := sqlcode;
                                v_errortext varchar2(4000) := sqlerrm;
                            begin
                                insert into ftth_preorders_fuzzydouble (
                                    ftth_id,
                                    fuzzy_rowid,
                                    score_datum,
                                    score_typ,
                                    score,
                                    errorcode,
                                    errortext,
                                    status,
                                    request_id
                                ) values ( auftrag.ftth_id,
                                           - 1,
                                           sysdate,
                                           'BNK',
                                           null,
                                           v_errorcode,
                                           v_errortext,
                                           v_fuzzydouble_status,
                                           v_fuzzy_request_id );

                            end doublet_check_bank_error;
                    end doublet_check_bank;

                end if; -- IBAN ist nicht leer 
          -- Falls Fuzzy für die Bankverbindungs-Suche ein leeres Ergebnis zurückgeliefert hat, 
          -- muss dies ebenfalls als NULL-Datensatz vermerkt werden: 
                if v_anzahl_ergebnisse_bnk = 0 then 
            -- Eintragen, dass die Suche ergebnislos war, damit ein vernünftiger Vorschlag 
            -- für das Fuzzy-Suchfenster in den Glascontainer-Einstellungen gemacht wird: 
                    insert into ftth_preorders_fuzzydouble (
                        ftth_id,
                        fuzzy_rowid,
                        score_datum,
                        score_typ,
                        score,
                        errorcode,
                        errortext,
                        status,
                        request_id
                    ) values ( auftrag.ftth_id,
                               null,
                               sysdate,
                               'BNK',
                               null,
                               null,
                               null,
                               c_fuzzy_status_empty,
                               v_fuzzy_request_id );

                end if;

                commit; -- Es sollte nach jedem Auftrag commited werden, um bei Fehlern im Ablauf nicht 
          -- die bereits erhaltenen zahlreichen Ergebnisse zu verlieren und 
          -- unnötigerweise teuer neu abfragen zu müssen 
          -- nächster Preorders-Datensatz... 
            end naechster_auftrag;

        end loop; 
      /* @deprecated: Der Status C_FUZZY_STATUS_IGNORIEREN wird nicht mehr vergeben 
      -- Beabsichtigte Dubletten: Deren neu hinzugekommene Datensätze 
      -- müssen im Nachgang wieder entfernt werden: 
      DELETE FTTH_PREORDERS_FUZZYDOUBLE 
      WHERE (FTTH_ID, FUZZY_ROWID, SCORE_TYP) IN 
      -- gewollte Dubletten ermitteln: 
      (SELECT FTTH_ID, FUZZY_ROWID, SCORE_TYP 
      FROM FTTH_PREORDERS_FUZZYDOUBLE 
      WHERE STATUS = C_FUZZY_STATUS_IGNORIEREN) 
      -- deren überflüssige neuen Datensätze löschen: 
      AND STATUS IS NULL; 
      */ 
      -- Fuzzy-Ergebnisse, für die es inzwischen keine Sätze mehr im Preorder-Buffer gibt, 
      -- können gelöscht werden: 
        delete ftth_preorders_fuzzydouble
        where
            ftth_id not in (
                select
                    id
                from
                    ftth_ws_sync_preorders
            );

        p_fuzzy_protokoll_abschliessen(
            pin_request_id   => v_fuzzy_request_id,
            pin_requests     => v_count_abfragen_pho + v_count_abfragen_bnk,
            piv_errormessage => null
        );

    exception
        when others then
            declare
                v_errormessage varchar2(4000);
            begin
                v_errormessage := substr(sqlerrm, 1, 4000);
                if sqlcode <> c_plausi_error_number then
                    pck_logs.p_error(
                        pic_message      => fcl_params(),
                        piv_routine_name => qualified_name(cv_routine_name),
                        piv_scope        => g_scope
                    );

                    p_fuzzy_protokoll_abschliessen(
                        pin_request_id   => v_fuzzy_request_id,
                        pin_requests     => v_count_abfragen_pho + v_count_abfragen_bnk,
                        piv_errormessage => v_errormessage
                    );

                end if;

            end;

            raise;
    end p_fuzzy_auftragsliste_updaten; 

  /** 
  * Wird vom DBMS_SCHEDULER aufgerufen, um die tägliche Abfrage der noch nicht 
  * geprüften neuen Aufträge auf Dubletten durchzuführen. Der Zeitpunkt des Aufrufs 
  * liegt eine halbe Stunde nach der Synchronisierung der Auftragsdaten. 
  * Der Verlauf der Abfragen kann mittels der Tabelle FTTH_FUZZY_REQUESTS 
  * kontrolliert werden, die ermittelten Ergebnisse befinden sich 
  * in der Tabelle FTTH_PREORDERS_FUZZYDOUBLE.
  * 
  * @param piv_username Bleibt beim Aufruf durch den Scheduler leer - nur zum 
  * Testen und manuellen Überprüfen kann hier wahlweise ein 
  * anderer Name mitgegeben werden 
  * @example 
  * BEGIN PCK_GLASCONTAINER.p_program_fuzzy_taeglich('TEST'); END; 
  */
    procedure p_program_fuzzy_taeglich (
        piv_username in varchar2 default null
    ) is
    begin 
    -- Die Dauer der Abarbeitung dieser Fuzzy-Requests liegt üblicherweise 
    -- im Sekundenbereich, typisch 10 Sekunden, wenn für eine Woche nachgefragt wird. 
        pck_glascontainer.p_fuzzy_auftragsliste_updaten(
      -- üblicherweise eine Woche zurückschauen, genau wie im Auftragslisten-Sync: 
            pid_datum_von       => trunc(sysdate - nvl(fn_last_modified_within_days, 7)),
            pib_nur_neuzugaenge => true,
            piv_username        => coalesce(piv_username, 'SCHEDULER')
        );
    end p_program_fuzzy_taeglich; 

  /** 
  * Wird vom DBMS_SCHEDULER einmal pro Woche aufgerufen, um die erneute Abfrage 
  * aller Aufträge auf Dubletten durchzuführen. Der Zeitpunkt des Aufrufs 
  * liegt eine halbe Stunde nach der Synchronisierung der Auftragsdaten. 
  * Der Verlauf der Abfragen kann mittels der Tabelle FTTH_FUZZY_REQUESTS 
  * kontrolliert werden, die ermittelten Ergebnisse befinden sich 
  * in der Tabelle FTTH_PREORDERS_FUZZYDOUBLE.
  * 
  * @param piv_username Bleibt beim Aufruf durch den Scheduler leer - nur zum 
  * Testen und manuellen Überprüfen kann hier wahlweise ein 
  * anderer Name mitgegeben werden 
  * 
  * @example 
  * BEGIN PCK_GLASCONTAINER.p_program_fuzzy_woechentlich('TEST'); END; 
  */
    procedure p_program_fuzzy_woechentlich (
        piv_username in varchar2 default null
    ) is
    begin 
    -- Dies ist die (einzige) Stelle, an der die Fuzzy-Tabellen komplett geleert werden. 
    -- Dadurch wird Tablespace-Wildwuchs verhindert. 
        execute immediate ( 'TRUNCATE TABLE ROMA_MAIN.FTTH_PREORDERS_FUZZY_DETAILS' );
        execute immediate ( 'TRUNCATE TABLE ROMA_MAIN.FTTH_PREORDERS_FUZZYDOUBLE' ); 
    -- Die Dauer der Abarbeitung dieser Fuzzy-Requests liegt üblicherweise 
    -- im Bereich von 10 Minuten, Tendenz steigend da kein rückwärtiges 
    -- Beginndatum vorgesehen ist. 
        pck_glascontainer.p_fuzzy_auftragsliste_updaten(
            pid_datum_von       => null,
            pib_nur_neuzugaenge => false,
            piv_username        => coalesce(piv_username, 'SCHEDULER')
        );

    end p_program_fuzzy_woechentlich; 

  /** 
  * Speichert eine neue Bewertung einer potenziellen Dublette durch einen 
  * Fachbereichsmitarbeiter, setzt dabei das AKTUELL-Flag der zuvor aktuellen Bewertung zurück 
  * 
  * @param piv_knr0 [IN] Ausgehend von dieser Kundennummer im Preorderbuffer 
  * @param piv_knr1 [IN] Die Bewerunt gbezieht sich auf diese potenzielle Dublette 
  * @param piv_bewertung [IN] G= gewollte Dublette, X= kein Zusammenhang, W= Wiedervorlage (klären) 
  * @param piv_kommentar [IN] Optionaler Bearbeitungsvermerk 
  * @param piv_username [IN] APEX-User, der diese Bewertung abgibt 
  * 
  * @usage Aufruf durch APEX Application Process "AP_SUBMIT_DUBLETTEN_BEWERTUNG" 
  * sowie durch Dynamic Actions auf Seite 2022:40 
  */
    procedure ap_submit_dubletten_bewertung (
        piv_knr0      in varchar2,
        piv_knr1      in varchar2,
        piv_bewertung in varchar2,
        piv_kommentar in varchar2,
        piv_username  in varchar2
    ) is 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'ap_submit_dubletten_bewertung';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_knr0', piv_knr0);
            pck_format.p_add('piv_knr1', piv_knr1);
            pck_format.p_add('piv_bewertung', piv_bewertung);
            pck_format.p_add('piv_kommentar', piv_kommentar);
            pck_format.p_add('piv_username', piv_username);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin 
    -- Plausi: 
        if piv_knr0 is null then
            raise_application_error(c_plausi_error_number, 'KNR0 fehlt (Dublettenbewertung)');
        end if;
        if piv_knr1 is null then
            raise_application_error(c_plausi_error_number, 'KNR1 fehlt (Dublettenbewertung)');
        end if;
        if piv_bewertung is null then
            raise_application_error(c_plausi_error_number, 'Bewertung fehlt (Dublettenbewertung)');
        end if;
        update ftth_dubletten_bewertung
        set
            aktuell = null
        where
                knr0 = piv_knr0
            and knr1 = piv_knr1
            and aktuell = 1;

        insert into ftth_dubletten_bewertung (
            knr0,
            knr1,
            bewertung,
            kommentar,
            username,
            datum,
            aktuell
        ) values ( piv_knr0,
                   piv_knr1,
                   piv_bewertung,
                   piv_kommentar,
                   piv_username,
                   sysdate,
                   1 );

    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end; 

  /** 
  * Löscht eine bestimmte Bewertung aus der Tabelle FTTH_DUBLETTEN_BEWERTUNG 
  * und setzt anschließend die nächst-jüngere Bewertung auf AKTUELL 
  * 
  * @param pin_bewertung_id [IN ] Technischer PK 
  */
    procedure ap_delete_dubletten_bewertung (
        pin_bewertung_id ftth_dubletten_bewertung.id%type
    ) is

        v_knr0          ftth_dubletten_bewertung.knr0%type;
        v_knr1          ftth_dubletten_bewertung.knr1%type; 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'ap_delete_dubletten_bewertung';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_bewertung_id', pin_bewertung_id);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin 
    -- die gewünschte Bewertung tatsächlich löschen: 
        delete ftth_dubletten_bewertung
        where
            id = pin_bewertung_id
        returning knr0,
                  knr1 into v_knr0, v_knr1; 
    -- Den früher vorletzten Eintrag zum Aktuellen machen: 
        update ftth_dubletten_bewertung
        set
            aktuell = 1
        where
                knr0 = v_knr0
            and knr1 = v_knr1
            and id = (
                select
                    id
                from
                    (
                        select
                            id
                        from
                            ftth_dubletten_bewertung
                        where
                                knr0 = v_knr0
                            and knr1 = v_knr1
                        order by
                            datum desc
                    )
                where
                    rownum = 1
            ) 
          -- meistenteils werden ja veraltete Bewertungen gelöscht, 
          -- dann mu 
            and aktuell is null;

    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end; 

/** 
 * Liefert eine HTML-Tabelle mit der Übersicht der Glascontainer-relevanten Webservice-URL, 
 *  an den Browser. Diese Tabelle wird auf der Seite "Über diese Anwendung" gezeigt. 
 */
    procedure htp_webservice_urls is

        v_url         varchar2(255);
        v_dummy_wert2 varchar2(255);
        v_dummy_wert3 varchar2(255);

        function tr (
            i_key   in varchar,
            i_value in varchar2
        ) return varchar2 is
        begin
            return '<tr><td class="key">'
                   || i_key
                   || '</td><td class="value">'
                   || i_value
                   || '</td></tr>';
        end;

    begin
        htp.p('<table class="info webservice">'); 
    ------------------------------- 
        pck_pob_rest.p_init_webservice(
            piv_kontext     => pck_pob_rest.kontext_preorderbuffer,
            piv_ws_key      => pck_pob_rest.c_ws_key_preorders_get,
            pov_ws_url      => v_url,
            pov_ws_username => v_dummy_wert2,
            pov_ws_password => v_dummy_wert3
        );

        v_url := rtrim(
            replace(v_url, '{orderId}'),
            '/'
        )
                 || '?lastModifiedWithinDays=7&page=0'; -- ausserdem zu finden in APEX Shared Components 
        htp.p(tr('Auftragsliste synchronisieren:', v_url));     
    ------------------------------- 
        pck_pob_rest.p_init_webservice(
            piv_kontext     => pck_pob_rest.kontext_preorderbuffer,
            piv_ws_key      => pck_pob_rest.c_ws_key_preorders_get,
            pov_ws_url      => v_url,
            pov_ws_username => v_dummy_wert2,
            pov_ws_password => v_dummy_wert3
        );

        htp.p(tr('Auftrag lesen:', v_url)); 
    ------------------------------- 
        pck_pob_rest.p_init_webservice(
            piv_kontext     => pck_pob_rest.kontext_preorderbuffer,
            piv_ws_key      => pck_pob_rest.c_ws_key_preorders_post,
            pov_ws_url      => v_url,
            pov_ws_username => v_dummy_wert2,
            pov_ws_password => v_dummy_wert3
        );

        htp.p(tr('&hellip; ändern:', v_url)); 
    ------------------------------- 
        pck_pob_rest.p_init_webservice(
            piv_kontext     => pck_pob_rest.kontext_preorderbuffer,
            piv_ws_key      => pck_pob_rest.c_ws_key_preorders_cancel,
            pov_ws_url      => v_url,
            pov_ws_username => v_dummy_wert2,
            pov_ws_password => v_dummy_wert3
        );

        htp.p(tr('&hellip; stornieren:', v_url));    
    ------------------------------- 
        pck_pob_rest.p_init_webservice(
            piv_kontext     => pck_pob_rest.kontext_preorderbuffer,
            piv_ws_key      => pck_pob_rest.c_ws_key_siebel_process,
            pov_ws_url      => v_url,
            pov_ws_username => v_dummy_wert2,
            pov_ws_password => v_dummy_wert3
        );

        htp.p(tr('&hellip; abschließen:', v_url));       
    ------------------------------- 
        pck_pob_rest.p_init_webservice(
            piv_kontext     => pck_pob_rest.kontext_preorderbuffer,
            piv_ws_key      => pck_pob_rest.c_ws_key_order_history,
            pov_ws_url      => v_url,
            pov_ws_username => v_dummy_wert2,
            pov_ws_password => v_dummy_wert3
        );

        htp.p(tr('Auftragshistorie:', v_url));        
    ------------------------------- 
        htp.p('</table>');
    end htp_webservice_urls; 


  /** 
  * Gibt die ToDo-Liste für die APEX-App "Glascontainer" aus. 
  */
    function todolist return t_lov
        pipelined
    is

        n naturaln := 0;

        function todo (
            piv_text in varchar2
        ) return t_lov_entry is
        begin
            n := 1 + n;
            return new t_lov_entry(
                substr(piv_text, 1, 255),
                n
            );
        end;

    begin 
    -- D = Text, R = Reihenfolge 1..n 
    -- Es dürfen zwar längere Texte hier notiert werden, 
    -- aber nur die ersten 255 Zeichen werden jeweils ausgegeben. 
    /** Vorlage: 
    PIPE ROW ( todo ('') ); 
    */
        pipe row ( todo('Programmteile aus PCK_GLASCONTAINER, die für die Steuerung der Synchronisierung zuständig sind, ins Package PCK_GLASCONTAINER_ADMIN verlagern'
        ) );
        pipe row ( todo('CORE.AD.FB_IS_MEMBER...: Auf PCK_GLASCONTAINER abstützen anstatt im Authorization Scheme abzufragen') );
        pipe row ( todo('T_POB, Tabellenspalten und Sync: VARCHAR2-Größen angleichen') );
        pipe row ( todo('Alte GLASCONTAINER-Einträge (pv_key1) aus PARAMS löschen') );
        pipe row ( todo('Unit-Tests für den Stornierungsprozess') );
        pipe row ( todo('JSON-Vergleich visualisieren (Ziel: Alternative zu serverseitigem Diff zur Diskussion stellen)') ); 
    -- Tickets: 
    -- Bugs: 
    -- Architektur: 
        pipe row ( todo('Sempahor errichten für die Sync-Vorgänge, da https://community.oracle.com/tech/developers/discussion/4503660 keine Antwort gebracht hat. Darin auch: Wert für Parameter lastModifiedWithinDays loggen.'
        ) );
        pipe row ( todo('Neue View mit den JSON-Namen der Felder über FTTH_WS_SYNC_PREORDERS, technischer Report für Recherchen') );
        pipe row ( todo('testen: Concurrent Updates desselben Auftrags') );
        pipe row ( todo('Testen: Sync-Button gesperrt auch bei mehreren Nutzern?') );
        pipe row ( todo('Gelöschte Aufträge ermitteln') );
        pipe row ( todo('@klären: Welche andere Anforderung findet im selben Formular statt wie https://jira.netcologne.intern/browse/FTTH-160 ?'
        ) );
        pipe row ( todo('Automatisches Ausblenden von Erfolgsmeldungen') ); 
    ------------------------------------------------------------------------ 
        pipe row ( todo(null) ); -- hiernach die rein technischen Aufgaben: 
    ------------------------------------------------------------------------ 
        pipe row ( todo('ENUM-Grid: SQL-Statements im Report generieren') );
        pipe row ( todo('Webservice-Logs/Synchronisierungsvorgänge: User abspeichern') );
        pipe row ( todo('WS-Adresse / Zugangsdaten auf der Einstellungen-Seite einblenden (Achtung: leeres PW nicht speichern)') );
        pipe row ( todo('POST: nur unerwartete Fehler loggen') );
        pipe row ( todo('Transferprogramm JSON-Daten in Sync-Tabelle erstellen, um beliebige Werte (z.B. true anstatt false) testen zu können'
        ) );
        pipe row ( todo('Umbau pov_haus_anschlusspreis zu NUMBER') ); 

    ------------------------------------------------------------------------ 
    -- erledigt: 
    ------------------------------------------------------------------------ 

    exception
        when no_data_needed then
            return;
        when others then
            return;
    end; 

/** 
 * Vergleicht zwei Datensätze der Tabell FTTH_WS_SYNC_PREORDERS miteinander 
 * und liefert die Informationen zu unterschiedlichen Spalten als informelle Zeilen zurück 
 * @ticket FTTH-593 
 * @deprecated, History wird nun clientseitig verglichen 

  FUNCTION DIFF_POB ( 
    pir_a          IN FTTH_WS_SYNC_PREORDERS%ROWTYPE, 
    pir_b          IN FTTH_WS_SYNC_PREORDERS%ROWTYPE, 
    piv_username_b IN VARCHAR2, 
    piv_datum_b    IN DATE 
  ) RETURN t_diff_table 
    PIPELINED 
  IS 
    table_name  CONSTANT VARCHAR2(100) := 'FTTH_WS_SYNC_PREORDERS'; 
    v_column_name_01  VARCHAR2(100); 
    v_column_name_02  VARCHAR2(100); 
    v_column_name_03  VARCHAR2(100); 
    v_column_name_04  VARCHAR2(100); 
    v_column_name_05  VARCHAR2(100); 
    v_column_name_06  VARCHAR2(100); 
    v_column_name_07  VARCHAR2(100); 
    v_column_name_08  VARCHAR2(100); 
    v_column_name_09  VARCHAR2(100); 
    v_column_name_10  VARCHAR2(100); 
    v_column_name_11  VARCHAR2(100); 
    v_column_name_12  VARCHAR2(100); 
    v_column_name_13  VARCHAR2(100); 
    v_column_name_14  VARCHAR2(100); 
    v_column_name_15  VARCHAR2(100); 
    v_column_name_16  VARCHAR2(100); 
    v_column_name_17  VARCHAR2(100); 
    v_column_name_18  VARCHAR2(100); 
    v_column_name_19  VARCHAR2(100); 
    v_column_name_20  VARCHAR2(100); 
    v_column_name_21  VARCHAR2(100); 
    v_column_name_22  VARCHAR2(100); 
    v_column_name_23  VARCHAR2(100); 
    v_column_name_24  VARCHAR2(100); 
    v_column_name_25  VARCHAR2(100); 
    v_column_name_26  VARCHAR2(100); 
    v_column_name_27  VARCHAR2(100); 
    v_column_name_28  VARCHAR2(100); 
    v_column_name_29  VARCHAR2(100); 
    v_column_name_30  VARCHAR2(100); 
    v_column_name_31  VARCHAR2(100); 
    v_column_name_32  VARCHAR2(100); 
    v_column_name_33  VARCHAR2(100); 
    v_column_name_34  VARCHAR2(100); 
    v_column_name_35  VARCHAR2(100); 
    v_column_name_36  VARCHAR2(100); 
    v_column_name_37  VARCHAR2(100); 
    v_column_name_38  VARCHAR2(100); 
    v_column_name_39  VARCHAR2(100); 
    v_column_name_40  VARCHAR2(100); 
    v_column_name_41  VARCHAR2(100); 
    v_column_name_42  VARCHAR2(100); 
    v_column_name_43  VARCHAR2(100); 
    v_column_name_44  VARCHAR2(100); 
    v_column_name_45  VARCHAR2(100); 
    v_column_name_46  VARCHAR2(100); 
    v_column_name_47  VARCHAR2(100); 
    v_column_name_48  VARCHAR2(100); 
    v_column_name_49  VARCHAR2(100); 
    v_column_name_50  VARCHAR2(100);        
    v_vergleich NATURAL; 
  BEGIN 
    -- ID: 
    SELECT DECODE(pir_a.id, pir_b.id, NULL, 'ID') 
      INTO v_column_name_01 FROM dual; 

    RETURN; 
  EXCEPTION 
    WHEN NO_DATA_NEEDED THEN 
      RAISE; 
  END DIFF_POB; 
 */ 



/** 
 * Parst das komplette JSON-Resultset aus dem order-history Webservice ("Auftragshistorie") 
 * und liefert die einzelnen Versionen als T_POB-Records zurück 
 *
 * @param piv_uuid   [IN]  UUID des Auftrags, dessen Historie abgerufenb werden soll
 * @param piv_filter [IN]  (optional) Wenn "R", dann werden nur relevante Historien-Datensätze ausgegeben,
 *                         das beinhaltet alle durch "Menschen" generierte Versionen 
 *                         plus die allererste bzw. allerletze Historienversion.
 *                         Der Wert '-' (Bindestrich) wird wie NULL behandelt.
 *                         'S' würde nur die ausgeblendeten liefern, was für den 
 *                         Glascontainer-User üblicherweise keinen Mehrwert bringt
 * 
 * @ticket FTTH-593, @ticket FTTH-917, @ticket FTTH-2315, @ticket FTTH-3727
 *
 * @example 
 * SELECT * FROM table(PCK_GLASCONTAINER.fp_order_history('ahXPK6RZn19dRUpjGHRtvkkwTNmGR9'))  ORDER BY version DESC; 
 */
    function fp_order_history (
        piv_uuid   in ftth_ws_sync_preorders.id%type,
        piv_filter in varchar2 default null -- @ticket FTTH-4404
    ) return t_pob_table
        pipelined
    is

        v_pob                 t_pob;
        v_webservice_response clob; 
-- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name       constant logs.routine_name%type := 'fp_order_history';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_uuid', piv_uuid);
            pck_format.p_add('piv_filter', piv_filter);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
-- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------      
    begin
        v_webservice_response := fc_history_wsget(piv_uuid => piv_uuid);
        pck_logs.p_error(
            pic_message      => v_webservice_response,
            piv_routine_name => cv_routine_name,
            piv_scope        => g_scope
        ); 

    -- zum Testen: so sieht die "leere Antwort" aus / Server meldet: keine History vorhanden 
    -- v_ws_response := '"data": []';  

        for h in (
            with order_history as (
                select
                    v_webservice_response as json_versionen
                from
                    dual
            )
            select distinct
                history_version,
                id,
                vkz,
                customernumber,
                product_client,
                product_templateid,
                product_devicecategory,
                product_deviceownership,
                product_installationservice,
                product_houseconnectionprice,
                customer_businessname,
                customer_salutation,
                customer_title,
                customer_name_first,
                customer_name_last,
                customer_birthdate,
                customer_email,
                customer_residentstatus 
            ----                                             
                ,
                customer_prev_addr_street,
                customer_prev_addr_housenumber,
                customer_prev_addr_addition,
                customer_prev_addr_zipcode,
                customer_prev_addr_city,
                customer_prev_addr_country 
            ----                                             
                ,
                customer_phone_countrycode,
                customer_phone_areacode,
                customer_phone_number,
                customer_password 
            ----                                             
                ,
                install_addr_street,
                install_addr_housenumber,
                install_addr_zipcode,
                install_addr_city,
                install_addr_addition,
                install_addr_country,
                houseserialnumber,
                providerchg_current_provider,
                providerchg_contract_cancelled,
                providerchg_cancellation_date 
            ----                                             
                ,
                providerchg_owner_name_last,
                providerchg_owner_name_first,
                providerchg_phone_number,
                providerchg_phone_areacode,
                providerchg_phone_countrycode,
                providerchg_owner_salutation,
                providerchg_keep_phone_number 
            ----                                             
                ,
                account_holder,
                account_sepamandate,
                account_iban  
            ----                                             
                ,
                prop_owner_role,
                prop_residential_unit,
                landlord_legalform,
                landlord_businessname,
                landlord_salutation,
                landlord_title,
                landlord_name_first,
                landlord_name_last,
                landlord_addr_street,
                landlord_addr_housenumber,
                landlord_addr_zipcode,
                landlord_addr_city,
                landlord_addr_addition,
                landlord_addr_country,
                landlord_email,
                landlord_phone_countrycode,
                landlord_phone_areacode,
                landlord_phone_number,
                landlord_agreed,
                summ_precontractinformation,
                summ_generaltermsandconditions,
                summ_waiverightofrevocation,
                summ_emailmarketing,
                summ_phonemarketing,
                summ_smsmmsmarketing,
                summ_mailmarketing,
                summ_ordersummaryfileid 
            ---- 
                ,
                state 
             ---- 
                ,
                customer_upd_email,
                is_new_customer 
            ---- 
                ,
                created,
                last_modified    
          --,version -- wird nicht verwendet, wofür steht VERSION überhaupt im Gegensatz zur HISTORY_VERSION?
                     -- (VERSION scheint immer '1' zu sein)
                ,
                process_lock,
                process_lock_last_modified 
            ---- 
                ,
                changed_by -- ist leer, wenn es sich um eine system-generierte Version handelt.
                        -- Wird erst bei der Darstellung in APEX zu "System" geändert
            -----------
            -- 2024-12-17: @ticket FTTH-4404, @ticket FTTH-4562
            -- Leider gibt es momentan einen Bug in einem bestimmten Interactive Grid auf Seite 20,
            -- "IG Auftragshistorie", wodurch es nicht möglich ist, einen neuen Standard Report zu speichern.
            -- Damit entfällt die Möglichkeit, dass der User im IG selber den Filter setzen kann, ob er nur
            -- relevante Daten sehen möchte. Der nicht unelegante Workaraound ist, den optionalen Parameter
            -- piv_filter hierfür zu verwenden und in der App diesen Wert per Switch einzustellen.
            -- Die Relevanz jedes Historien-Datensatzes wird wie folgt berechnet:
                ,
                case
                    when changed_by is not null
                         or -- ein Mensch hat die Änderung veranlasst
                          history_version in ( min(history_version)
                                                 over(partition by id) -- erste oder
                                                 , max(history_version)
                                                                        over(partition by id) -- letzte Version
                                                                         ) then
                        'R' -- relevant
                    else
                        'S' -- SYSTEM, nicht relevant (außer erster/letzter)
                end as filter            
            -----------
                ,
                cancelled_by,
                cancel_reason,
                cancel_date,
                siebel_order_number,
                siebel_order_rowid,
                siebel_ready,
                service_plus_email -- @FTTH-5002
                ,
                wholebuy_partner,
                manual_transfer,
                product_ont_provider,
                technology
             -- @ticket FTTH-3727
             -- @bugfix 2024-12-03: trotz DISTINCT hierbei immer noch TOO_MANY_ROWS, 
             -- weil die Einträge halt in Arrays stehen.
             -- Abhilfe: MAX(...) OVER(...):
                ,
                max(connectivity_id)
                over(
                    order by
                        connectivity_id
                )   as connectivity_id,
                max(rt_contact_data_ticket_id)
                over(
                    order by
                        rt_contact_data_ticket_id
                )   as rt_contact_data_ticket_id,
                landlord_information_required -- @ticket FTTH-3727
            -- neu 2024-08-27 @ticket FTTH-3711:
                ,
                customer_upd_country_code,
                customer_upd_area_code,
                customer_upd_number,
                update_customer_in_siebel,
                home_id,
                account_id,
                availability_date -- @ticket FTTH-3880
            -- ...  @SYNC#13
            from
                order_history,
                json_table ( json_versionen, '$.data[*]'
                        columns (
                            history_version number path "version" 
                  ---- 
                            ,
                            id varchar2 ( 100 ) path "order"."id",
                            vkz varchar2 ( 50 ) path "order"."vkz",
                            customernumber varchar2 ( 50 ) path "order"."customerNumber",
                            product_templateid varchar2 ( 50 ) path "order"."product"."templateId",
                            product_devicecategory varchar2 ( 50 ) path "order"."product"."deviceCategory",
                            product_deviceownership varchar2 ( 50 ) path "order"."product"."deviceOwnership",
                            product_installationservice varchar2 ( 50 ) path "order"."product"."installationService",
                            product_houseconnectionprice number path "order"."product"."houseConnectionPrice",
                            product_client varchar2 ( 2 ) path "order"."product"."client",
                            customer_businessname varchar2 ( 100 ) path "order"."customer"."businessName",
                            customer_salutation varchar2 ( 100 ) path "order"."customer"."salutation",
                            customer_title varchar2 ( 100 ) path "order"."customer"."title",
                            customer_name_first varchar2 ( 100 ) path "order"."customer"."name"."first",
                            customer_name_last varchar2 ( 100 ) path "order"."customer"."name"."last",
                            customer_birthdate varchar2 ( 10 ) path "order"."customer"."birthDate",
                            customer_email varchar2 ( 100 ) path "order"."customer"."email",
                            customer_residentstatus varchar2 ( 100 ) path "order"."customer"."residentStatus" 
                  ----                                                  
                            ,
                            customer_prev_addr_street varchar2 ( 100 ) path "order"."customer"."previousAddress"."street",
                            customer_prev_addr_housenumber varchar2 ( 100 ) path "order"."customer"."previousAddress"."houseNumber",
                            customer_prev_addr_addition varchar2 ( 100 ) path "order"."customer"."previousAddress"."postalAddition",
                            customer_prev_addr_zipcode varchar2 ( 100 ) path "order"."customer"."previousAddress"."zipCode",
                            customer_prev_addr_city varchar2 ( 100 ) path "order"."customer"."previousAddress"."city",
                            customer_prev_addr_country varchar2 ( 100 ) path "order"."customer"."previousAddress"."country" 
                  ----                                                  
                            ,
                            customer_phone_countrycode varchar2 ( 5 ) path "order"."customer"."phoneNumber"."countryCode",
                            customer_phone_areacode varchar2 ( 10 ) path "order"."customer"."phoneNumber"."areaCode",
                            customer_phone_number varchar2 ( 50 ) path "order"."customer"."phoneNumber"."number",
                            customer_password varchar2 ( 100 ) path "order"."customer"."password" 
                  ----                                                  
                            ,
                            install_addr_street varchar2 ( 100 ) path "order"."installation"."address"."street",
                            install_addr_housenumber varchar2 ( 100 ) path "order"."installation"."address"."houseNumber",
                            install_addr_zipcode varchar2 ( 100 ) path "order"."installation"."address"."zipCode",
                            install_addr_city varchar2 ( 100 ) path "order"."installation"."address"."city",
                            install_addr_addition varchar2 ( 100 ) path "order"."installation"."address.postalAddition",
                            install_addr_country varchar2 ( 100 ) path "order"."installation"."address.country",
                            houseserialnumber varchar2 ( 50 ) path "order"."installation"."houseSerialNumber",
                            providerchg_current_provider varchar2 ( 100 ) path "order"."providerChange"."currentProvider",
                            providerchg_contract_cancelled varchar2 ( 100 ) path "order"."providerChange"."currentContractCancelled",
                            providerchg_cancellation_date varchar2 ( 100 ) path "order"."providerChange"."cancellationDate" 
                  ----                                                  
                            ,
                            providerchg_owner_name_last varchar2 ( 100 ) path "order"."providerChange"."contractOwnerName"."last",
                            providerchg_owner_name_first varchar2 ( 100 ) path "order"."providerChange"."contractOwnerName"."first",
                            providerchg_phone_number varchar2 ( 100 ) path "order"."providerChange"."landlinePhoneNumber"."number",
                            providerchg_phone_areacode varchar2 ( 100 ) path "order"."providerChange"."landlinePhoneNumber"."areaCode"
                            ,
                            providerchg_phone_countrycode varchar2 ( 100 ) path "order"."providerChange"."landlinePhoneNumber"."countryCode"
                            ,
                            providerchg_owner_salutation varchar2 ( 100 ) path "order"."providerChange"."contractOwnerSalutation",
                            providerchg_keep_phone_number varchar2 ( 100 ) path "order"."providerChange"."keepCurrentLandlineNumber" 
                  ----                                                  
                            ,
                            account_holder varchar2 ( 100 ) path "order"."accountDetails"."accountHolder",
                            account_sepamandate varchar2 ( 100 ) path "order"."accountDetails"."sepaMandate",
                            account_iban varchar2 ( 100 ) path "order"."accountDetails"."iban" 
                  ----                                                  
                            ,
                            prop_owner_role varchar2 ( 50 ) path "order"."propertyOwnerDeclaration"."propertyOwnerRole",
                            prop_residential_unit varchar2 ( 50 ) path "order"."propertyOwnerDeclaration"."residentialUnit",
                            landlord_legalform varchar2 ( 50 ) path "order"."propertyOwnerDeclaration"."landlord"."legalForm",
                            landlord_businessname varchar2 ( 50 ) path "order"."propertyOwnerDeclaration"."landlord"."businessOrName"
                            ,
                            landlord_salutation varchar2 ( 50 ) path "order"."propertyOwnerDeclaration"."landlord"."salutation",
                            landlord_title varchar2 ( 50 ) path "order"."propertyOwnerDeclaration"."landlord"."title",
                            landlord_name_first varchar2 ( 50 ) path "order"."propertyOwnerDeclaration"."landlord"."name"."first",
                            landlord_name_last varchar2 ( 50 ) path "order"."propertyOwnerDeclaration"."landlord"."name"."last",
                            landlord_addr_street varchar2 ( 50 ) path "order"."propertyOwnerDeclaration"."landlord"."address"."street"
                            ,
                            landlord_addr_housenumber varchar2 ( 50 ) path "order"."propertyOwnerDeclaration"."landlord"."address"."houseNumber"
                            ,
                            landlord_addr_zipcode varchar2 ( 50 ) path "order"."propertyOwnerDeclaration"."landlord"."address"."zipCode" -- @date 2024-07-17 war falsch: "zipcode"
                            ,
                            landlord_addr_city varchar2 ( 50 ) path "order"."propertyOwnerDeclaration"."landlord"."address"."city",
                            landlord_addr_addition varchar2 ( 50 ) path "order"."propertyOwnerDeclaration"."landlord"."address"."postalAddition"
                            ,
                            landlord_addr_country varchar2 ( 50 ) path "order"."propertyOwnerDeclaration"."landlord"."address"."country"
                            ,
                            landlord_email varchar2 ( 50 ) path "order"."propertyOwnerDeclaration"."landlord"."email",
                            landlord_phone_countrycode varchar2 ( 50 ) path "order"."propertyOwnerDeclaration"."landlord"."phoneNumber.countryCode"
                            ,
                            landlord_phone_areacode varchar2 ( 50 ) path "order"."propertyOwnerDeclaration"."landlord"."phoneNumber"."areaCode"
                            ,
                            landlord_phone_number varchar2 ( 50 ) path "order"."propertyOwnerDeclaration"."landlord"."phoneNumber"."number"
                            ,
                            landlord_agreed varchar2 ( 50 ) path "order"."propertyOwnerDeclaration"."landlordAgreedToBeContacted",
                            summ_precontractinformation varchar2 ( 10 ) path "order"."summary"."preContractualInformation",
                            summ_generaltermsandconditions varchar2 ( 10 ) path "order"."summary"."generalTermsAndConditions",
                            summ_waiverightofrevocation varchar2 ( 10 ) path "order"."summary"."waiveRightOfRevocation",
                            summ_emailmarketing varchar2 ( 10 ) path "order"."summary"."emailMarketing",
                            summ_phonemarketing varchar2 ( 10 ) path "order"."summary"."phoneMarketing",
                            summ_smsmmsmarketing varchar2 ( 10 ) path "order"."summary"."smsMmsMarketing",
                            summ_mailmarketing varchar2 ( 10 ) path "order"."summary"."mailMarketing",
                            summ_ordersummaryfileid varchar2 ( 50 ) path "order"."summary"."orderSummaryFileId" 
                  ---- 
                            ,
                            state varchar2 ( 50 ) path "order"."state" 
                   ---- 
                            ,
                            customer_upd_email varchar2 ( 100 ) path "order"."customerUpdate"."email"  -- ///// VARCHAR2(300)???
                  -- /// analog zum Parsen weiter oben: 
                  -- Was ist der Sinn der customerUpdate-Felder??? Warum verzichten wir bisher im Glascontainer auf diesen Abschnitt? 
                            ,
                            is_new_customer varchar2 ( 5 ) path "order"."isNewCustomer" 
               -- das innere "created" im "order" ist stets leer, wir nehmen das äußere: 
               -- ,created VARCHAR2 ( 30 )                                PATH "order"."created"  
                            ,
                            created varchar2 ( 30 ) path "created" 
                  ---- 
                            ,
                            last_modified varchar2 ( 30 ) path "order"."lastModified" 
               -- ,version NUMBER                                         PATH "order"."version" -- immer '1'
                            ,
                            changed_by varchar2 ( 30 ) path "order"."changedBy",
                            process_lock varchar2 ( 5 ) path "order"."processLock",
                            process_lock_last_modified varchar2 ( 30 ) path "order"."processLockLastModified" 
                  ---- 
                  -- neu 2023-07-18: 
                            ,
                            cancelled_by varchar2 ( 30 ) path "order"."cancellation"."cancelledBy",
                            cancel_reason varchar2 ( 30 ) path "order"."cancellation"."reason",
                            cancel_date varchar2 ( 30 ) path "order"."cancellation"."created",
                            siebel_order_number varchar2 ( 100 ) path "order"."siebelOrderNumber",
                            siebel_order_rowid varchar2 ( 100 ) path "order"."siebelOrderRowId",
                            siebel_ready varchar2 ( 5 ) path "order"."siebelReady" 
                  -- neu 2023-08-16 @ticket FTTH-2411: 
                            ,
                            service_plus_email varchar2 ( 300 ) path "order"."servicePlusEmail" -- @FTTH-5002
                            ,
                            wholebuy_partner varchar2 ( 30 ) path "order"."wholebuy"."partner",
                            manual_transfer varchar2 ( 5 ) path "order"."manualTransfer",
                            product_ont_provider varchar2 ( 30 ) path "order"."product"."ontProvider",
                            technology varchar2 ( 50 ) path "order"."technology"
                  -- neu 2024-08-21
                            ,
                            nested path '$.order.externalOrderReferences[*]'
                                columns (
                                    connectivity_id varchar2 ( 100 ) path '$.connectivityId'        -- @ticket FTTH-3727, @ticket FTH-4403
                                    ,
                                    rt_contact_data_ticket_id varchar2 ( 100 ) path '$.rtContactDataTicketId' -- @ticket FTTH-3727
                                ),
                            landlord_information_required varchar2 ( 5 ) path "order"."wholebuy"."landlordInformationRequired"          -- @ticket FTTH-3727
                  -- neu 2024-08-23 @ticket FTTH-3711:
                            ,
                            customer_upd_country_code varchar2 ( 5 ) path "customerUpdate"."phoneNumber"."countryCode",
                            customer_upd_area_code varchar2 ( 5 ) path "customerUpdate"."phoneNumber"."areaCode",
                            customer_upd_number varchar2 ( 15 ) path "customerUpdate"."phoneNumber"."number",
                            update_customer_in_siebel varchar2 ( 5 ) path "customerUpdate"."updateCustomerInSiebel",
                            home_id varchar2 ( 50 ) path "homeId" -- @ticket FTTH-4134
                            ,
                            account_id varchar2 ( 128 ) path "accountId" -- @ticket FTTH-4470, @ticket FTTH-4533
                -- "ERRORSTATUS" kommt nicht vom REST-Service
                            ,
                            availability_date varchar2 ( 10 ) path "order"."availabilityDate"
                  -- ... @SYNC#14
                        )
                    ) 
             -- 2023-06-14: systemgenerierte Versionen ausschließen? 
             -- siehe @ticket FTTH-593, nach Besprechnung mit @steanj: Nein. 
             -- WHERE changed_by IS NOT NULL -- entfällt hier

             -- neuester Datensatz muss oben stehen 
            order by
                history_version asc
        ) loop 
      -- 2024-12-17: Workaround für IG-Bug:
      -- Bei gesetztem Filter-Argument muss dessen Wert in der berechneten Relevanz vorkommen,
      -- ansonsten diesen Datensatz nicht ausgeben:
            if (
                nullif(piv_filter, '-') is not null -- NULL oder Bindestrich heißt: Bitte die komplette Historie zeigen
                and h.filter not like '%'
                                      || piv_filter
                                      || '%' -- typischerweise: Datensatz ist systemgeneriert, 'S'
            ) then
                continue;
            end if;

            pipe row ( new t_pob(h.id -- 01 

            ,
                                 h.product_templateid -- 02 
                                 ,
                                 h.product_devicecategory -- 03 
                                 ,
                                 h.product_deviceownership -- 04 
                                 ,
                                 h.product_installationservice -- 05 
                                 ,
                                 h.product_houseconnectionprice -- 06 
                                 ,
                                 h.summ_ordersummaryfileid -- 07 
                                 ,
                                 h.state -- 08 
                                 ,
                                 h.vkz -- 09 
                                 ,
                                 h.product_client -- 10    
                                 ,
                                 h.customernumber -- 11   
                                 ,
                                 h.customer_businessname -- 12 
                                 ,
                                 h.customer_salutation -- 13          
                                 ,
                                 h.customer_title -- 14 
                                 ,
                                 h.customer_name_first -- 15  
                                 ,
                                 h.customer_name_last -- 16 
                                 ,
                                 to_date(h.customer_birthdate,
                                 'YYYY-MM-DD') -- 17                    
                                 ,
                                 h.customer_email -- 18 
                                 ,
                                 h.customer_phone_countrycode -- 19 
                                 ,
                                 h.customer_phone_areacode -- 20            
                                 ,
                                 h.customer_phone_number -- 21 
                                 ,
                                 h.houseserialnumber -- 22 
                                 ,
                                 h.customer_residentstatus -- 23 
                                 ,
                                 h.install_addr_country -- 24 
                                 ,
                                 h.install_addr_zipcode -- 25 
                                 ,
                                 h.install_addr_city -- 26 
                                 ,
                                 h.install_addr_street -- 27 
                                 ,
                                 h.install_addr_housenumber -- 28 
                                 ,
                                 h.install_addr_addition -- 29 
                                 ,
                                 h.providerchg_current_provider -- 30          
                                 ,
                                 h.providerchg_keep_phone_number -- 31 
                                 ,
                                 h.providerchg_phone_countrycode -- 32 
                                 ,
                                 h.providerchg_phone_areacode -- 33 
                                 ,
                                 h.providerchg_phone_number -- 34 
                                 ,
                                 h.providerchg_contract_cancelled -- 35 
                                 ,
                                 h.providerchg_cancellation_date -- 36 
                                 ,
                                 h.providerchg_owner_salutation -- 37 
                                 ,
                                 h.providerchg_owner_name_first -- 38 
                                 ,
                                 h.providerchg_owner_name_last -- 39 
                                 ,
                                 h.account_sepamandate -- 40 
                                 ,
                                 h.account_holder -- 41 
                                 ,
                                 h.landlord_name_last -- 42 
                                 ,
                                 h.account_iban -- 43 
                                 ,
                                 h.landlord_name_first -- 44 
                                 ,
                                 h.landlord_email -- 45 
                                 ,
                                 h.landlord_title -- 46 
                                 ,
                                 h.landlord_addr_city -- 47 
                                 ,
                                 h.landlord_addr_street -- 48 
                                 ,
                                 h.landlord_addr_country -- 49 
                                 ,
                                 h.landlord_addr_zipcode -- 50 
                                 ,
                                 h.landlord_addr_housenumber -- 51 
                                 ,
                                 h.landlord_addr_addition -- 52 
                                 ,
                                 h.landlord_legalform -- 53 
                                 ,
                                 h.landlord_salutation -- 54 
                                 ,
                                 h.landlord_phone_number -- 55 
                                 ,
                                 h.landlord_phone_areacode -- 56 
                                 ,
                                 h.landlord_phone_countrycode -- 57 
                                 ,
                                 h.landlord_businessname -- 58 
                                 ,
                                 h.prop_residential_unit -- 59 
                                 ,
                                 h.prop_owner_role -- 60 
                                 ,
                                 h.landlord_agreed -- 61 
                                 ,
                                 h.summ_precontractinformation -- 62 
                                 ,
                                 h.summ_generaltermsandconditions -- 63 
                                 ,
                                 h.summ_waiverightofrevocation -- 64 
                                 ,
                                 h.summ_emailmarketing -- 65 
                                 ,
                                 h.summ_phonemarketing -- 66 
                                 ,
                                 h.summ_smsmmsmarketing -- 67 
                                 ,
                                 h.summ_mailmarketing -- 68 
                                 ,
                                 h.customer_prev_addr_street -- 69 
                                 ,
                                 h.customer_prev_addr_housenumber -- 70   
                                 ,
                                 h.customer_prev_addr_addition -- 71 
                                 ,
                                 h.customer_prev_addr_zipcode -- 72 
                                 ,
                                 h.customer_prev_addr_city -- 73 
                                 ,
                                 h.customer_prev_addr_country -- 74 
                                 ,
                                 h.customer_upd_email -- 75 
                                 ,
                                 null -- h.CUSTOMER_UPD_PHONE_COUNTRYCODE -- 76 -- //// 2023-08-08 @todo klären, ob diese 3 Felder obsolet sind 
                                 ,
                                 null -- h.CUSTOMER_UPD_PHONE_AREACODE -- 77 
                                 ,
                                 null -- h.CUSTOMER_UPD_PHONE_NUMBER -- 78 
          -- h.CUSTOMER_PASSWORD -- 79 --  entfernt 2025-01-21
                                 ,
                                 h.is_new_customer -- 80       
                                 ,
                                 fd_json_timestamp(h.created) -- 81 -- zB. "2023-06-06T15:02:59.476678394" 
                                 ,
                                 fd_json_timestamp(h.last_modified) -- 82 
                                 ,
                                 h.history_version,
                                 h.process_lock -- 84 
                                 ,
                                 fd_json_timestamp(h.process_lock_last_modified) -- 85 
                                 ,
                                 h.changed_by,
                                 h.cancelled_by,
                                 h.cancel_reason,
                                 fd_json_timestamp(h.cancel_date),
                                 h.siebel_order_number,
                                 h.siebel_order_rowid,
                                 h.siebel_ready,
                                 h.service_plus_email -- @FTTH-5002
                                 ,
                                 h.wholebuy_partner -- @ticket FTTH-2901, @ticket FTTH-2995 
                                 ,
                                 h.manual_transfer,
                                 h.product_ont_provider -- @ticket FTTH-3097 
                                 ,
                                 h.technology
         -- neu 2024-08-21: @ticket FTTH-3727
                                 ,
                                 h.connectivity_id,
                                 h.rt_contact_data_ticket_id,
                                 h.landlord_information_required
         -- neu 2024-08-23 @ticket FTTH-3711:
                                 ,
                                 h.customer_upd_country_code,
                                 h.customer_upd_area_code,
                                 h.customer_upd_number,
                                 h.update_customer_in_siebel,
                                 h.home_id  -- @ticket FTTH-4134
                                 ,
                                 h.account_id -- @ticket FTTH-4470
                                 ,
                                 '' -- ERRORSTATUS //////////
                                 ,
                                 to_date(h.availability_date,
                                 'YYYY-MM-DD')
         -- ... @SYNC#15
                                 ) );

        end loop;

        return;
    exception
        when no_data_needed then
            return;
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            return; -- das darf kein Showstopper sein - die Historienanzeige bleibt dann eben leer   
    end fp_order_history; 



  /** 
  * Liest die Kopfdaten eines Kunden ein. Wenn diese nicht gefunden werden, 
  * wird entweder der bestehende Wert der IN/OUT-Parameter zurückgegeben 
  * oder der String 'n/a', falls dieser leer ist 
  * 
  * @usage Diese Kopfdaten fehlen im Preorder-Buffer im Fall von Bestandskunden. 
  * Die Prozedur verwendet eine in Siebel zur Verfügung gestellte View. 
  * @todo Die Ausgabe des Geburtsdatums erfolgt hier korrekterweise als DATE, 
  * das aufrufende Programm arbeitet aber weiterhin mit VARCHAR2: Letzteres anpassen! 
  * @ticket FTTH-1246 
  * @AP Thorsten Westenberg 
  */
    procedure p_get_siebel_kopfdaten (
        piv_kundennummer  in varchar2,
        piov_vorname      in out varchar2,
        piov_nachname     in out varchar2,
        piod_geburtsdatum in out date,
        piov_anrede       in out varchar2,
        piov_titel        in out varchar2,
        piov_firmenname   in out varchar2
    ) is
    begin
        if g_use_siebel then
            pck_glascontainer_ext.p_get_siebel_kopfdaten(
                piv_kundennummer  => piv_kundennummer,
                piov_vorname      => piov_vorname,
                piov_nachname     => piov_nachname,
                piod_geburtsdatum => piod_geburtsdatum,
                piov_anrede       => piov_anrede,
                piov_titel        => piov_titel,
                piov_firmenname   => piov_firmenname
            );

        end if;
    end; 



/** 
 * Gibt den anzuzeigenden Status eines Auftrags im Glascontainer zurück 
 * 
 * @param piv_state  [IN ] IN_REVIEW|CREATED|CANCELLED|SIEBEL_PROCESSED|... 
 * 
 * @usage APEX-Item "P20_STATUS_DISPLAY" 
 */
    function fv_auftragsstatus_display (
        piv_state in varchar2
    ) return varchar2 is
    begin
        for s in (
            select
                singular as status_display
            from
                enum
            where
                    kontext = 'FTTH'
                and domain = 'state'
                and key = piv_state
                and status is null
                and sprache in ( 'GC', '*' )
            order by
                sprache desc
        ) loop
            return s.status_display;
        end loop;

        return null;
    end fv_auftragsstatus_display; 

-- @progress 2023-08-16 -------------------------------------------------------- 

/** 
 * Gibt TRUE zurück, wenn für ein bestimmtes Produkt die Angabe einer 
 * Service-Plus-Emailadresse erforderlich ist, ansonsten FALSE 
 * 
 * @param piv_template_id  [IN ]  Die Produktkennung (früher: "Promotion"), z.B. 'ftth-factory-2023-09-phone-tv-250' 
 * 
 * @demand Bei Änderung einer Bestellung von der alten Tarifgeneration zur neuen in einen Tarif =/> 250 Mbit/s  
 *         und bei Wechsel innerhalb der neuen Generation von einem Tarif < 250Mbit/s auf einen Tarif =/> 250 Mbit/s  
 *         muss der Agent eine E-Mail-Adresse für das Sicherheitspaket eingeben  
 *  
 * 
 * @ticket FTTH-2411 
 */
    function fb_service_plus_email_noetig -- @FTTH-5002
     (
        piv_produkt_template_id in varchar2
    ) return boolean is
        v_email_noetig ftth_glascontainer_produkte.email_noetig%type;
    begin
        select
            max(email_noetig)
        into v_email_noetig
        from
            ftth_glascontainer_produkte
        where
            template_id = piv_produkt_template_id;

        return
            case v_email_noetig
                when 1 then
                    true
                else false
            end; -- gibt kein NULL hier 

/*      
    RETURN CASE  
      -- die Produkte könnten alternativ in einer geeigneten Tabelle gespeichert werden, 
      -- zur Zeit geht es noch... 
      WHEN piv_produkt_template_id IN 
      (          
         ENUM_PRODUKT_2023_09_250            
        ,ENUM_PRODUKT_2023_09_500            
        ,ENUM_PRODUKT_2023_09_1000           

        ,ENUM_PRODUKT_2023_09_PHONE_250      
        ,ENUM_PRODUKT_2023_09_PHONE_500      
        ,ENUM_PRODUKT_2023_09_PHONE_1000     

        ,ENUM_PRODUKT_2023_09_PHONE_TV_250   
        ,ENUM_PRODUKT_2023_09_PHONE_TV_500   
        ,ENUM_PRODUKT_2023_09_PHONE_TV_1000  

        ,ENUM_PRODUKT_2023_09_TV_250         
        ,ENUM_PRODUKT_2023_09_TV_500         
        ,ENUM_PRODUKT_2023_09_TV_1000 
      )  THEN TRUE 

      WHEN piv_produkt_template_id IN 
      (          
         ENUM_PRODUKT_2023_09_50             
        ,ENUM_PRODUKT_2023_09_100            

        ,ENUM_PRODUKT_2023_09_PHONE_50       
        ,ENUM_PRODUKT_2023_09_PHONE_100      

        ,ENUM_PRODUKT_2023_09_PHONE_TV_50    
        ,ENUM_PRODUKT_2023_09_PHONE_TV_100   

        ,ENUM_PRODUKT_2023_09_TV_50          
        ,ENUM_PRODUKT_2023_09_TV_100      
      )  THEN FALSE      

      ELSE -- Produkt unbekannt, nicht relevant oder nicht angegeben: 
        NULL 
    END; 
*/
    end fb_service_plus_email_noetig; 

-- @progress 2023-08-17 -------------------------------------------------------- 


/** 
-- @deprecated: Stattdessen fv_folgeprodukt verwenden 
 * 
 * Gibt zu einer Template-ID (Produkt) der alten Tarifgeneration Oktober 2023 
 * die entsprechende Template-ID der neuen Tarifgeneration September 2023 zurück. 
 * Die Produkte heißen zwar ähnlich und haben verwandte Template-IDs, 
 * aber daraus lässt sich kein zwingender Zusammenhang ableiten. 

  FUNCTION get_produkt_2023_09(piv_template_id_2022_10 IN VARCHAR2) 
  RETURN VARCHAR2 DETERMINISTIC 
  IS 
  BEGIN 
    RETURN CASE piv_template_id_2022_10 
      WHEN ENUM_PROMOTION_2022_10_50              THEN ENUM_PRODUKT_2023_09_50             
      WHEN ENUM_PROMOTION_2022_10_100             THEN ENUM_PRODUKT_2023_09_100            
      WHEN ENUM_PROMOTION_2022_10_250             THEN ENUM_PRODUKT_2023_09_250            
      WHEN ENUM_PROMOTION_2022_10_500             THEN ENUM_PRODUKT_2023_09_500            
      WHEN ENUM_PROMOTION_2022_10_1000            THEN ENUM_PRODUKT_2023_09_1000           

      WHEN ENUM_PROMOTION_2022_10_PHONE_50        THEN ENUM_PRODUKT_2023_09_PHONE_50       
      WHEN ENUM_PROMOTION_2022_10_PHONE_100       THEN ENUM_PRODUKT_2023_09_PHONE_100      
      WHEN ENUM_PROMOTION_2022_10_PHONE_250       THEN ENUM_PRODUKT_2023_09_PHONE_250      
      WHEN ENUM_PROMOTION_2022_10_PHONE_500       THEN ENUM_PRODUKT_2023_09_PHONE_500      
      WHEN ENUM_PROMOTION_2022_10_PHONE_1000      THEN ENUM_PRODUKT_2023_09_PHONE_1000     

      WHEN ENUM_PROMOTION_2022_10_TV_50           THEN ENUM_PRODUKT_2023_09_TV_50          
      WHEN ENUM_PROMOTION_2022_10_TV_100          THEN ENUM_PRODUKT_2023_09_TV_100         
      WHEN ENUM_PROMOTION_2022_10_TV_250          THEN ENUM_PRODUKT_2023_09_TV_250         
      WHEN ENUM_PROMOTION_2022_10_TV_500          THEN ENUM_PRODUKT_2023_09_TV_500         
      WHEN ENUM_PROMOTION_2022_10_TV_1000         THEN ENUM_PRODUKT_2023_09_TV_1000        

      WHEN ENUM_PROMOTION_2022_10_PHONE_TV_50     THEN ENUM_PRODUKT_2023_09_PHONE_TV_50    
      WHEN ENUM_PROMOTION_2022_10_PHONE_TV_100    THEN ENUM_PRODUKT_2023_09_PHONE_TV_100   
      WHEN ENUM_PROMOTION_2022_10_PHONE_TV_250    THEN ENUM_PRODUKT_2023_09_PHONE_TV_250   
      WHEN ENUM_PROMOTION_2022_10_PHONE_TV_500    THEN ENUM_PRODUKT_2023_09_PHONE_TV_500   
      WHEN ENUM_PROMOTION_2022_10_PHONE_TV_1000   THEN ENUM_PRODUKT_2023_09_PHONE_TV_1000  

      ELSE NULL 
      END; 

  END get_produkt_2023_09; 
 */ 


-- @progress 2023-08-22 -------------------------------------------------------- 



/** 
 * Liefert zu einer gebuchten templateId diejenige templateId, die dieses Produkt in der 
 * aktuellen Tarifgeneration hat bzw. haben würde 
 * 
 * @param piv_template_id         [IN ]  Vollständige templateId aus dem PreOrderbuffer 
 * @param piv_tarifgeneration_neu [IN ]  Code der Aktion, auf die das Produkt umgestellt werden muss,  
 *                                       aus der Tabelle FTTH_GLASCONTAINER_AKTIONEN, oder NULL, 
 *                                       wenn es sich dabei um die gerade aktuelle Aktion handelt 
 * @example 
 * SELECT PCK_GLASCONTAINER.fv_folgeprodukt('ftth-factory-2022-10-500') from dual; 
 * 
 * @ticket FTTH-2411, @ticket FTTH-4064
 *
 * @usage
 * Beim Wechsel der Produktgeneration muss für die jedes alte Produkt entweder manuell oder per SQL genau ein Folgeprodukt 
 * eingetragen werden, welches dann in der Selectlist P20_RPODUKT automatisch angeboten wird. 
 * Beispiel beim Wechsel im September 2024:
 *
 *   update ftth_glascontainer_produkte p_alt
 *   set folgeprodukt_template_id =
 *         (select template_id
 *            from ftth_glascontainer_produkte p_neu
 *           where aktion = '2024-09'
 *          -- Man könnte über den Namen zuordnen:
 *          -- and p_neu.name = p_alt.name
 *          -- jedoch die Zuordnung über template_id ist besser, solange die Endungen identisch sind,
 *          -- also z.B. ftth-factory-2023-09-"tv-250" => ftth-factory-2024-09-"tv-250"
 *             and replace(p_neu.template_id, 'ftth-factory-2024-09-') = replace(p_alt.template_id, 'ftth-factory-2023-09-')
 *         )
 *   where aktion = '2023-09'
 *     and folgeprodukt_template_id is null;
 *
 */
    function fv_folgeprodukt (
        piv_template_id         in varchar2,
        piv_tarifgeneration_neu in varchar2 default null
    ) return ftth_glascontainer_produkte.template_id%type is

        v_template_id   ftth_glascontainer_produkte.template_id%type; 
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'fv_folgeprodukt';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_template_id', piv_template_id);
            pck_format.p_add('piv_tarifgeneration_neu', piv_tarifgeneration_neu);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
  -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------      
    begin
        select
            template_id
        into v_template_id
        from
                 ftth_glascontainer_produkte produkt
            join ftth_glascontainer_aktionen aktion on ( aktion.code = produkt.aktion )
        where
            ( produkt.aktion = piv_tarifgeneration_neu
              or ( piv_tarifgeneration_neu is null
                   and aktion.aktuell = 1 ) )
        start with
            template_id = piv_template_id
        connect by
            template_id = prior folgeprodukt_template_id;

        return v_template_id;
    exception
        when no_data_found then
            return null;
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end fv_folgeprodukt; 



/** 
 * Liefert zu einer templateId alle anderen verfügbaren Produkte der in Frage kommenden Tarifgeneration, 
 * plus das Produkt selbst (damit es in der List of Values zunächst angezeigt wird) 
 *   
 * @param piv_template_id     [IN]  ID des aktuell im Vertrag bestellten, ggf. veralteten Produkts 
 *                                  (stellt sicher, dass dieser Eintrag in der LOV angezeigt wird) 
 * @param piv_tarifgeneration [IN]  (optional) Wenn gesetzt, dann nur die Tarife dieser Generation anzeigen; 
 *                                  wenn nicht gesetzt, dann wird die aktuelle Tarifgeneration angezeigt; 
 *                                  Beispiel: 2023-09 
 * @param pin_min_bandbreite  [IN]  (optional) Nur Produkte anzeigen, die diese Mindestbandbreite erfüllen 
 * @param pin_max_bandbreite  [IN]  (optional) Nur Produkte anzeigen, die diese Maximalbandbreite nicht überschreiten 
 * 
 * @example 
 * SELECT * FROM PCK_GLASCONTAINER.lov_produkte('ftth-factory-2022-10-phone-500'); 
 * -- gibt zum Zeitpunkt 2023-09 genau 21 Produkte aus: Das "veraltete" plus die 20 "aktuellen" 
 * 
 * @example 
 * SELECT * FROM PCK_GLASCONTAINER.lov_produkte( 
 *   piv_template_id => 'ftth-factory-2023-09-phone-500' 
 *  ,pin_min_bandbreite => 100 
 *  ,pin_max_bandbreite => 1000 
 * ); 
 * 
 * @ticket FTTH-2411 @Herbst-2023-Tarife 
 */
    function lov_produkte (
        piv_template_id     in varchar2 default null,
        piv_tarifgeneration in varchar2 default null,
        pin_min_bandbreite  in number default null,
        pin_max_bandbreite  in number default null
    ) return t_lov
        pipelined
    is 
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'lov_produkte';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_template_id', piv_template_id);
            pck_format.p_add('piv_tarifgeneration', piv_tarifgeneration);
            pck_format.p_add('pin_min_bandbreite', pin_min_bandbreite);
            pck_format.p_add('pin_max_bandbreite', pin_max_bandbreite);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
  -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------  

    begin 
    -- https://jira.netcologne.intern/browse/FTTH-1102 
        declare 
      -- Bandbreiten 
            minbb constant naturaln := nvl(pin_min_bandbreite, 0);         -- keine Vorgabe: Dann ist die Untergrenze immer erfüllbar. 
            maxbb constant naturaln := nvl(pin_max_bandbreite, 999999999); -- keine Vorgabe: Dann ist die Obergrenze immer erfüllbar. 
      -- /// ggf. noch prüfen, ob MINBB <= MAXBB 

        begin
            for p in (
                select
                    name,
                    template_id,
                    aktion,
                    internet,
                    telefon,
                    tv
                from
                    ( 
        -- immer das übergebene (derzeitige) Produkt darstellen, 
        -- damit die Selectliste in APEX vollständig ist: 
                        select
                            name,
                            template_id,
                            aktion,
                            bandbreite,
                            internet,
                            telefon,
                            tv
                        from
                            ftth_glascontainer_produkte 
            -- Es können entweder die Produkte sämtlicher Aktionen abgefragt werden 
            -- (dies ist in der Auftragsliste nötig) 
            -- oder nur für eine bestimmte Aktion (P20, Auftragsmaske, Selectliste P20_PRODUKT) 
                        where
                            piv_template_id is null
                            or template_id = piv_template_id
                        union -- nichts doppelt ausgeben 
        -- alle Produkte des explizit gewünschten oder des aktuellen Tarifs: 
                        select
                            produkt.name,
                            template_id,
                            aktion,
                            bandbreite,
                            internet,
                            telefon,
                            tv
                        from
                                 ftth_glascontainer_produkte produkt
                            join ftth_glascontainer_aktionen aktion on ( aktion.code = produkt.aktion )
                        where -- welcher Tarif? 
                            ( ( piv_tarifgeneration is null
                                and aktion.aktuell = 1 )
                              or ( piv_tarifgeneration is not null
                                   and produkt.aktion = piv_tarifgeneration ) ) 
               -- Welche im Vermarktungscluster verfügbare Geschwindigkeit? 
                            and nvl(produkt.bandbreite, minbb) between minbb and maxbb 
           -- 2023-09-21: Das Produkt selbst hat keine MAX_BANDBREITE 
           -- AND NVL(PRODUKT.MAX_BANDBREITE, MAXBB) BETWEEN MINBB AND MAXBB 
                    )
                order by
                    aktion -- wichtig, damit ein nicht mehr buchbares Produkt 
                         -- als oberstes erscheint 
                  -- danach die aktuell buchbaren Produkte:  
                  -- zunächst alle Produkte einer Bandbreite, 
                  -- darin aufsteigend sortiert nach verfügbaren Optionen 
                    ,
                    bandbreite asc,
                    + 1 * nvl(internet, 0) + 2 * nvl(telefon, 0) + 4 * nvl(tv, 0) asc
            ) loop
                pipe row ( new t_lov_entry(p.name, p.template_id) );
            end loop;
        end; 
    -------------------------- 
        return;
    exception
        when no_data_needed then
            return;
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end lov_produkte; 



/** 
 * Liefert eine vollständige JavaScript-Function zurück, mit der clientseitig ermittelt wird, 
 * ob ein Produkt eine Service-Plus-Emailadresse erfordert. 
 */
    function js_fn_is_service_plus_email_produkt return varchar2 is -- @FTTH-5002
        v_function varchar2(32767);
        v_produkte varchar2(32767);
        trenner    constant varchar2(3) := ',';
        cr         constant varchar2(3) := chr(10);
    begin
        for p in (
            select
                template_id
            from
                ftth_glascontainer_produkte
            where
                email_noetig = 1
            order by
                1
        ) loop
            v_produkte := v_produkte
                          || trenner
                          || '"'
                          || p.template_id
                          || '"';
        end loop;

        v_function := 'function isServicePlusEmailProdukt(templateId){'
                      || cr
                      || 'const produkte = ['
                      || cr
                      || substr(v_produkte,
                                1 + length(trenner))
                      || cr
                      || '];'
                      || cr
                      || 'return produkte.includes(templateId);'
                      || cr
                      || '}'; 
    -- Stand 2023-08: Länge ~500 Zeichen, daher ist VARCHAR2(32k) anstatt CLOB 
    -- auf absehbare Zeit bei weitem ausreichend 

        return v_function;
    end js_fn_is_service_plus_email_produkt; 


-- @progress 2023-08-23 --------------------------------------------------------     



/** 
 * Liefert zu einer Template-ID (Produkttarif) die Kennung der darin enthaltenen 
 * Promotion ("Aktion"), z.B. '2023-09' 
 * 
 * @piv_template_id  [IN ]  Kombinierter Wert aus Promotion und Produkt,  
 *                          beispielsweise 'ftth-factory-2023-09-phone-500' 
 * 
 * @example 
 * SELECT PCK_GLASCONTAINER.fv_promotion('ftth-factory-2023-09-phone-500') FROM DUAL; 
 */
    function fv_promotion (
        piv_template_id in varchar2
    ) return varchar2 is
    begin 
    -- Stand 2023-08: Das funktioniert noch statisch. 
        if piv_template_id like 'ftth-factory-%' then
            return substr(piv_template_id, 14, 7);
        else
            return null;
        end if;
    end fv_promotion; 


/** 
 * Gibt für den Eintrag im Feld "changedBy" für den Glascontainer den 
 * passenden Anzeigestring zurück (bei natürlichen Personen den vollen Namen im AD, 
 * bei Einträgen die mit "mig" beginnen oder leeren Usernamen: den String "SYSTEM" 
 * 
 * @ticket FTTH-2648 
 */
    function fv_user_displayname (
        piv_username in varchar2
    ) return varchar2 is
        durch_system_generiert constant varchar2(30) := 'SYSTEM';
    begin 
    -- möglichst nur dann das Active Directory abfragen, wenn die systemgenerierten 
    -- Fälle bereits ausgeschlossen sind: 
        return
            case
                when piv_username is null then
                    durch_system_generiert
                when regexp_like(piv_username, '^mig[0-9]+$', 'i') then
                    durch_system_generiert -- z.B. mig2461 
                else coalesce(
                    trim(core.ad.get_user_displayname(piv_username)),
                    piv_username
                )
            end;
    end fv_user_displayname; 


-- @progress 2023-08-29 --------------------------------------------------------    

/** 
 * Gibt TRUE zurück, wenn der User im Active Directory (AD) 
 * eine bestimmte Rolle für die APEX App GLASCONTAINER besitzt 
 * 
 * @param piv_app_user   [IN ] 6stelliger Benutzername, entspricht :APP_USER 
 * @param piv_rolle      [IN ] Einer der vier Rollennamen (ohne Postfix ext bitte) 
 * @param piv_umgebung   [IN ] (optional) Kürzel der Umgebung, z.B. 'NMC'.  
 *                             Übergabe verkürzt Antwortzeit und ermöglicht Testen, 
 *                             ohne tatsächlich in der jeweiligen Umgebung zu sein. 
 * 
 * 
 * @usage Stand 2023-09: Es gibt vier Rollen (siehe Specification), die jeweils nochmal 
 *                       für Interne und Externe unterschieden werden. Diese Funktion 
 *                       berücksichtigt das bei der Abfrage im Active Directory, so dass 
 *                       für die jeweilige Umgebung das korrekte Ergebnis ermittelt wird. 
 * 
 * @usage                Da APEX keine kaskadierenden Rollen kennt und Benutzer im Active Directory 
 *                       nur in der jeweils höchsten Berechtigungsstufe eingetragen sein müssen, 
 *                       müsste diese Funktion beim Start der Applikation bis zu 
 *                       zehn Mal aufgerufen werden. Um das zu vermeiden, wurde die Wrapper-Funktion 
 *                       fb_app_user_hat_rolle eingeführt. 
 * 
 * @unittest 
 * SELECT * FROM ut.run('UT_GLASCONTAINER', a_tags => 'fb_hat_rolle_ad');  
 *
 * @example -- siehe Beispiel zur Function FB_HAT_ROLLE, welche diese Funktion aufruft
 */
    function fb_hat_rolle_ad (
        piv_app_user in varchar2,
        piv_rolle    in varchar2,
        piv_umgebung in varchar2 default null
    ) return boolean
        accessible by ( package ut_glascontainer )
    is
        berechtigt boolean;
    begin 
    -- Abfrage der unmittelbaren Berechtigung im Active Directory für Interne: 
        berechtigt := nvl(
            core.ad.fb_is_member(piv_app_user, piv_rolle),
            false
        );

        if not berechtigt then 
      -- Es könnte sich um einen Externen handeln: 
            declare
                in_produktion boolean;
            begin 
        -- Wird für die Produktion abgefragt? 
        -- Falls keine Umgebungsvariable übergeben wurde, wird geprüft wo wir tatsächlich sind: 
                if piv_umgebung is null then
                    in_produktion := coalesce(db_name = 'NMC', false);
                else 
          -- Falls die Umgebung vorgegeben wurde: 
                    in_produktion := piv_umgebung = 'NMC';
                end if; 
        -- In der Produktionsumgebung haben Externe überhaupt keine Rechte. 
                if
                    not in_produktion
                    and  
           -- In den Entwicklungs- und Testumgebungen 
           -- heißt die gesuchte Rolle wie die Originalrolle, nur mit Postfix für Externe: 
                     core.ad.fb_is_member(piv_app_user, piv_rolle || ' ext')
                then
                    berechtigt := true;
                end if;

            end;

        end if;

        return berechtigt;
    end fb_hat_rolle_ad; 


-- @progress 2023-08-30 -------------------------------------------------------- 


/** 
 * Nimmt eine leere oder bereits gefüllte Rollenliste entgegen und fügt ihr 
 * die neue Rolle hinzu, wobei weitere Doppelungen vermieden und leere Listen eliminiert werden 
 * 
 * @param piv_rolle        [IN ]     String für die neue Rolle (siehe C_ROLLE_...)  
 * @param piov_rollenliste [IN OUT]  Bereits existierende, kommasepartierte oder leere Liste mit bestehenden Rollen 
 * 
 * @unittest 
 * SELECT * FROM ut.run('UT_GLASCONTAINER', a_tags => 'p_rolle_hinzufuegen'); 
 */
    procedure p_rolle_hinzufuegen (
        piv_rolle        in varchar2,
        piov_rollenliste in out varchar2
    ) is
        komma constant varchar2(1) := ',';
    begin 
    -- Die neue Rolle darf kein Komma enthalten: 
        if instr(piv_rolle, komma) > 0 then
            raise_application_error(c_plausi_error_number,
                                    substr('Neue Rolle darf nicht aus mehreren Rollen zusammengesetzt sein: "'
                                           || piv_rolle
                                           || '"', 1, 256));
        end if; 

    -- normalisieren: 
        piov_rollenliste := trim(both komma from piov_rollenliste); -- 'Rolle1,Rolle2,Rolle3' oder NULL 

    -- Es kommt keine neue Rolle hinzu, oder die neue Rolle ist bereits enhalten?  
    -- Dann den String 1:1 zurückgeben.  
        if piv_rolle is null
           or instr(komma
                    || piov_rollenliste
                    || komma, komma
                              || piv_rolle
                              || komma) > 0 then
            return;
        end if; 

    -- neue Rolle hinzufügen 
        piov_rollenliste := replace(komma || piov_rollenliste, komma || piv_rolle);
        piov_rollenliste := trim(both komma from ( substr(piov_rollenliste
                                                          || komma
                                                          || piv_rolle,
                                                          1 + length(komma)) ));

    end p_rolle_hinzufuegen; 


-- @progress 2023-09-06 -------------------------------------------------------- 


/**  
 * Liefert TRUE zurück, falls der APEX User im Glascontainer eine bestimmte Rolle besitzt, 
 * anderfalls FALSE. 
 * 
 * @param piv_username    [IN ]  APEX :APP_USER 
 * @param piv_rolle       [IN ]  AD-Name der gesuchten Rolle (siehe PCK_GLASCONTAINER.C_ROLLE_...) 
 * @param piv_rollenliste [IN ]  (optional) Wenn gefüllt, wird NICHT im Active Directory gesucht, 
 *                               sondern die Rollenzugehörigkeit ausschließlich anhand dieser 
 *                               kommaseparierten Liste geprüft (siehe :G_ROLLENLISTE in APEX) 
 * @param piv_umgebung    [IN ]  neu 2024-ß05-15: Optionaler Umgebungs-String (zB. "NMCE")
 *                               der bei der Abfrage der Funktion FB_HAT_ROLLE_AD verwendet wird
 * 
 * @example
 * DECLARE
 *   berechtigt     BOOLEAN;
 *   v_username     VARCHAR2(100) := 'Mein_User';
 *   v_rolle        VARCHAR2(100) := PCK_GLASCONTAINER.C_ROLLE_ADMINISTRATOR; 
 *                                -- PCK_GLASCONTAINER.C_ROLLE_SUPERUSER;
 *                                -- PCK_GLASCONTAINER.C_ROLLE_USER; 
 *                                -- PCK_GLASCONTAINER.C_ROLLE_READONLY; 
 * BEGIN
 *   berechtigt := PCK_GLASCONTAINER.fb_hat_rolle(
 *     piv_username     => v_username
 *    ,piv_rolle        => v_rolle
 *    ,piv_rollenliste  => NULL
 *    ,piv_umgebung     => 'NMCE'
 *   );
 *   IF berechtigt THEN
 *     DBMS_OUTPUT.PUT_LINE(v_username || ' ist berechtigt für ' || v_rolle);
 *   ELSE
 *     DBMS_OUTPUT.PUT_LINE(v_username || ' ist NICHT berechtigt für ' || v_rolle);
 *   END IF;
 * END;
 * 
 * 
 * @unittest 
 * SELECT * FROM ut.run('UT_GLASCONTAINER', a_tags => 'fb_hat_rolle'); 
 */
    function fb_hat_rolle (
        piv_username    in varchar2,
        piv_rolle       in varchar2,
        piv_rollenliste in varchar2 default null,
        piv_umgebung    in varchar2 default null
    ) return boolean is
        hat_rolle boolean;
    begin
        if piv_rollenliste is not null then
            hat_rolle := 
      -- Triviale Abfrage, nachdem APEX erstmalig gegen das AD geprüft hat und 
      -- :G_ROLLEN die vollständige Liste der gefundenen Rollen beinhaltet: 
             instr(piv_rollenliste, piv_rolle) > 0;
        else -- keine Rollenliste wurden übergeben: 
         -- Dann muss anhand der Hierarchie im Active Directory 
         -- "kaskadierend" geantwortet werden. Der User muss sich im AD jeweils 
         -- nur für die mächtigste Rolle eintragen lassen. 
            hat_rolle :=
                case piv_rolle
                    when c_rolle_administrator then
                        fb_hat_rolle_ad(piv_username, c_rolle_administrator, piv_umgebung)
                    when c_rolle_superuser then
                        fb_hat_rolle_ad(piv_username, c_rolle_superuser, piv_umgebung)
                        or fb_hat_rolle_ad(piv_username, c_rolle_administrator, piv_umgebung)
                    when c_rolle_user then
                        fb_hat_rolle_ad(piv_username, c_rolle_user, piv_umgebung)
                        or fb_hat_rolle_ad(piv_username, c_rolle_superuser, piv_umgebung)
                        or fb_hat_rolle_ad(piv_username, c_rolle_administrator, piv_umgebung)
                    when c_rolle_readonly then
                        fb_hat_rolle_ad(piv_username, c_rolle_readonly, piv_umgebung)
                        or fb_hat_rolle_ad(piv_username, c_rolle_user, piv_umgebung)
                        or fb_hat_rolle_ad(piv_username, c_rolle_superuser, piv_umgebung)
                        or fb_hat_rolle_ad(piv_username, c_rolle_administrator, piv_umgebung)
                end;
        end if;

        return coalesce(hat_rolle, false);
    end fb_hat_rolle; 


/**   
 * Gibt den Namen der Rolle zurück, die in DEV + TEST in der Auswahlliste 
 * "Rolle zuweisen" angezeigt wird 
 * 
 * @param piv_rollenbezeichnung [IN ]  ADMINISTRATOR|SUPERUSER|USER|READONLY 
 */
    function fv_rollenname_ad (
        piv_rollenbezeichnung in varchar2
    ) return varchar2
        deterministic
    is
    begin
        return
            case upper(piv_rollenbezeichnung)
                when 'ADMINISTRATOR' then
                    c_rolle_administrator
                when 'SUPERUSER' then
                    c_rolle_superuser
                when 'USER' then
                    c_rolle_user
                when 'READONLY' then
                    c_rolle_readonly
                else null
            end;
    end fv_rollenname_ad; 



/** 
 * Gibt den String zurück, der im APEX Application Item :G_ROLLENLISTE 
 * gespeichert wird, wenn ein AD-Rolle zugewiesen wird 
 * 
 * @param piv_rolle_ad  [IN ]  Exakter Name der Rolle, wie sie im Active Directory 
 *                             gespeichert ist 
 */
    function fv_rollenliste (
        piv_rolle_ad in varchar2
    ) return varchar2
        deterministic
    is
    begin
        return
            case replace(piv_rolle_ad, ' ext') -- alles zurückführen auf die Basisrolle 
                when c_rolle_administrator then
                    c_rollenliste_administrator
                when c_rolle_superuser then
                    c_rollenliste_superuser
                when c_rolle_user then
                    c_rollenliste_user
                when c_rolle_readonly then
                    c_rollenliste_readonly
            end;
    end fv_rollenliste; 



-- @progress 2023-09-27 -------------------------------------------------------- 

/** 
 * Gibt eine List of Values mit allen adresstechnisch verfügbaren Ländernamen zurück 
 * 
 * @usage Als Schlüssel wird unglücklicherweise der Ländername selbst verwendet, 
 *        Display- und Returnvalue sind also identisch. 
 * 
 * @ticket FTTH-2814 
 * @ticket FTTH-848 
 * 
 * @example select d, r from table(pck_glascontainer.lov_land); 
 */
    function lov_land return t_lov
        pipelined
    is

        type t_liste is
            table of varchar2(100 char) index by binary_integer;
        v_liste t_liste;
        ix      binary_integer;
        v_land  varchar2(100 char);
    begin
        v_liste := t_liste( 
    -- Die Indexierung in Zehnerschritten ermöglicht neue Länder einzufügen. 
    -- Die konkrete Zahl spielt keine Rolle - dient nur für die Reihenfolge. 
    -- Stand 2023-09: Die Liste wurde aus der bestehenden Standardbestellstrecke übernommen. 
            0010 => 'Afghanistan',
            0020 => 'Ägypten',
            0030 => 'Albanien',
            0040 => 'Algerien',
            0050 => 'Andorra',
            0060 => 'Angola',
            0070 => 'Antigua und Barbuda',
            0080 => 'Äquatorialguinea',
            0090 => 'Argentinien',
            0100 => 'Armenien',
            0110 => 'Aserbaidschan',
            0120 => 'Äthiopien',
            0130 => 'Australien',
            0140 => 'Bahamas',
            0150 => 'Bahrain',
            0160 => 'Bangladesch',
            0170 => 'Barbados',
            0180 => 'Belarus',
            0190 => 'Belgien',
            0200 => 'Belize',
            0210 => 'Benin',
            0220 => 'Bhutan',
            0230 => 'Bolivien, Plurinationaler Staat',
            0240 => 'Bosnien und Herzegowina',
            0250 => 'Botsuana',
            0260 => 'Brasilien',
            0270 => 'Brunei Darussalam',
            0280 => 'Bulgarien',
            0290 => 'Burkina Faso',
            0300 => 'Burundi',
            0310 => 'Cabo Verde',
            0320 => 'Chile',
            0330 => 'China',
            0340 => 'Cookinseln',
            0350 => 'Costa Rica',
            0360 => 'Côte d''Ivoire',
            0370 => 'Dänemark',
            0380 => 'Deutschland',
            0390 => 'Dominica',
            0400 => 'Dominikanische Republik',
            0410 => 'Dschibuti',
            0420 => 'Ecuador',
            0430 => 'El Salvador',
            0440 => 'Eritrea',
            0450 => 'Estland',
            0460 => 'Eswatini',
            0470 => 'Fidschi',
            0480 => 'Finnland',
            0490 => 'Frankreich',
            0500 => 'Gabun',
            0510 => 'Gambia',
            0520 => 'Georgien',
            0530 => 'Ghana',
            0540 => 'Grenada',
            0550 => 'Griechenland',
            0560 => 'Guatemala',
            0570 => 'Guinea',
            0580 => 'Guinea-Bissau',
            0590 => 'Guyana',
            0600 => 'Haiti',
            0610 => 'Heiliger Stuhl',
            0620 => 'Honduras',
            0630 => 'Indien',
            0640 => 'Indonesien',
            0650 => 'Irak',
            0660 => 'Iran, Islamische Republik',
            0670 => 'Irland',
            0680 => 'Island',
            0690 => 'Israel',
            0700 => 'Italien',
            0710 => 'Jamaika',
            0720 => 'Japan',
            0730 => 'Jemen',
            0740 => 'Jordanien',
            0750 => 'Kambodscha',
            0760 => 'Kamerun',
            0770 => 'Kanada',
            0780 => 'Kasachstan',
            0790 => 'Katar',
            0800 => 'Kenia',
            0810 => 'Kirgisistan',
            0820 => 'Kiribati',
            0830 => 'Kolumbien',
            0840 => 'Komoren',
            0850 => 'Kongo',
            0860 => 'Kongo, Demokratische Republik',
            0870 => 'Korea, Demokratische Volksrepublik',
            0880 => 'Korea, Republik',
            0890 => 'Kosovo',
            0900 => 'Kroatien',
            0910 => 'Kuba',
            0920 => 'Kuwait',
            0930 => 'Laos, Demokratische Volksrepublik',
            0940 => 'Lesotho',
            0950 => 'Lettland',
            0960 => 'Libanon',
            0970 => 'Liberia',
            0980 => 'Libyen',
            0990 => 'Liechtenstein',
            1000 => 'Litauen',
            1010 => 'Luxemburg',
            1020 => 'Madagaskar',
            1030 => 'Malawi',
            1040 => 'Malaysia',
            1050 => 'Malediven',
            1060 => 'Mali',
            1070 => 'Malta',
            1080 => 'Marokko',
            1090 => 'Marshallinseln',
            1100 => 'Mauretanien',
            1110 => 'Mauritius',
            1120 => 'Mexiko',
            1130 => 'Mikronesien, Föderierte Staaten von',
            1140 => 'Moldau, Republik',
            1150 => 'Monaco',
            1160 => 'Mongolei',
            1170 => 'Montenegro',
            1180 => 'Mosambik',
            1190 => 'Myanmar',
            1200 => 'Namibia',
            1210 => 'Nauru',
            1220 => 'Nepal',
            1230 => 'Neuseeland',
            1240 => 'Nicaragua',
            1250 => 'Niederlande',
            1260 => 'Niger',
            1270 => 'Nigeria',
            1280 => 'Niue',
            1290 => 'Nordmazedonien',
            1300 => 'Norwegen',
            1310 => 'Oman',
            1320 => 'Österreich',
            1330 => 'Pakistan',
            1340 => 'Palau',
            1350 => 'Panama',
            1360 => 'Papua-Neuguinea',
            1370 => 'Paraguay',
            1380 => 'Peru',
            1390 => 'Philippinen',
            1400 => 'Polen',
            1410 => 'Portugal',
            1420 => 'Ruanda',
            1430 => 'Rumänien',
            1440 => 'Russische Föderation', -- statt Russland 
            1450 => 'Salomonen',
            1460 => 'Sambia',
            1470 => 'Samoa',
            1480 => 'San Marino',
            1490 => 'São Tomé und Príncipe',
            1500 => 'Saudi-Arabien',
            1510 => 'Schweden',
            1520 => 'Schweiz',
            1530 => 'Senegal',
            1540 => 'Serbien',
            1550 => 'Seychellen',
            1560 => 'Sierra Leone',
            1570 => 'Simbabwe',
            1580 => 'Singapur',
            1590 => 'Slowakei',
            1600 => 'Slowenien',
            1610 => 'Somalia',
            1620 => 'Spanien',
            1630 => 'Sri Lanka',
            1640 => 'St. Kitts und Nevis',
            1650 => 'St. Lucia',
            1660 => 'St. Vincent und die Grenadinen',
            1670 => 'Südafrika',
            1680 => 'Sudan',
            1690 => 'Südsudan',
            1700 => 'Suriname',
            1710 => 'Syrien, Arabische Republik',
            1720 => 'Tadschikistan',
            1730 => 'Tansania, Vereinigte Republik',
            1740 => 'Thailand',
            1750 => 'Timor-Leste',
            1760 => 'Togo',
            1770 => 'Tonga',
            1780 => 'Trinidad und Tobago',
            1790 => 'Tschad',
            1800 => 'Tschechien',
            1810 => 'Tunesien',
            1820 => 'Türkei',
            1830 => 'Turkmenistan',
            1840 => 'Tuvalu',
            1850 => 'Uganda',
            1860 => 'Ukraine',
            1870 => 'Ungarn',
            1880 => 'Uruguay',
            1890 => 'Usbekistan',
            1900 => 'Vanuatu',
            1910 => 'Vatikanstadt',
            1920 => 'Venezuela, Bolivarische Republik',
            1930 => 'Vereinigte Arabische Emirate',
            1940 => 'Vereinigte Staaten',
            1950 => 'Vereinigtes Königreich',
            1960 => 'Vietnam',
            1970 => 'Zentralafrikanische Republik',
            1980 => 'Zypern'
        );

        ix := v_liste.first;
        loop
            exit when ix is null;
            v_land := v_liste(ix); -- je nach Anwendung: Sonderzeichen escapen! Im Glascontainer nicht nötig 
      -- Es ist leider tatsächlich der exakte Ländername als Schlüssel zu übergeben, keine ISO-Abkürzung oder ähnliches: 
            pipe row ( new t_lov_entry(v_land, v_land) );
            ix := v_liste.next(ix);
        end loop;

        return;
    exception
        when no_data_needed then
            return;
    end lov_land; 

-- @progress 2023-11-21 -------------------------------------------------------- 

/** 
 * Gibt alle Kommentare zu einem Auftrag zurück (MANUAL_TRANSFER) 
 * 
 * @param piv_uuid   [IN ]  ID des Auftrags 
 */
    function html_kommentare (
        piv_uuid in varchar2
    ) return clob is

        v_string clob;

        function posting (
            i_username in varchar2,
            i_datum    in date,
            i_text     in varchar2
        ) return clob is
        begin
            return '<tr class="intro"><td>'
                   || i_username
                   || ' &ndash; '
                   || to_char(i_datum, 'DD.MM.YYYY')
                   || ', '
                   || to_char(i_datum, 'HH24:MI')
                   || ' Uhr</td></tr>'
                   || '<tr><td class="text"><pre>'
                   || apex_escape.html(i_text)
                   || '</pre></td></tr>';
        end;

    begin
        v_string := ( '<table class="kommentare">' );
        for c in (
            select
                id,
                created,
                created_by,
                text
            from
                table ( fp_comments(piv_uuid => piv_uuid) )
        ) loop
            v_string := v_string
                        || posting( 
                     -- '<span class="fa fa-number-' || to_char(i) || '-o"></span> ' ||  
                        c.created_by, c.created, c.text);
        end loop;

        v_string := v_string || ( '</table>' );
        return v_string;
    end; 

-- @progress 2023-30-11 -------------------------------------------------------- 


/** 
 * Holt alle Bearbeitungshinweise (Kommentare) zu einem Auftrag vom 
 * Webservice ab und gibt die JSON-Antwort zurück 
 * 
 * @param piv_uuid [IN ]  ID des Auftrags 
 */
    function fc_comments_wsget (
        piv_uuid in varchar2
    ) return clob is

        v_json                   clob;
        v_ws_url                 varchar2(255);
        v_ws_username            varchar2(255);
        v_ws_password            varchar2(255);
        v_request_url            varchar2(255);
        v_ws_response_statuscode ftth_webservice_aufrufe.response_statuscode%type;
        v_log_id                 ftth_webservice_aufrufe.id%type;
        v_ws_errormsg            ftth_webservice_aufrufe.errormessage%type; 
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name          constant logs.routine_name%type := 'fc_comments_wsget';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_uuid', piv_uuid);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
  -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        if not pck_pob_rest.g_webservices_enabled then
            return empty_clob();
        end if;
        pck_pob_rest.p_init_webservice(
            piv_kontext     => pck_pob_rest.kontext_preorderbuffer,
            piv_ws_key      => pck_pob_rest.c_ws_key_comments_get,
            pov_ws_url      => v_ws_url,
            pov_ws_username => v_ws_username,
            pov_ws_password => v_ws_password
        ); 

      -- Falls in der URL '{orderId}' steht, muss dies mit der UUID ersetzt werden 
        v_request_url := replace(v_ws_url,
                                 c_ws_orderid_token,
                                 trim(piv_uuid));
        begin
            v_json := apex_web_service.make_rest_request(
                p_url              => v_request_url,
                p_http_method      => c_ws_method_get,
                p_username         => v_ws_username,
                p_password         => v_ws_password,
                p_transfer_timeout => c_ws_transfer_timeout,
                p_wallet_path      => c_ws_wallet_path,
                p_wallet_pwd       => c_ws_wallet_pwd
            );
        exception
            when others then
                v_ws_errormsg := substr(sqlerrm, 1, 255);
        end;

        v_ws_response_statuscode := apex_web_service.g_status_code;
        if v_ws_errormsg is not null
           or v_ws_response_statuscode <> c_ws_statuscode_ok then -- ///// eigene Function hierfür 
            return empty_clob(); 
    -- ////... Statuscodes aufdröseln ... 
        end if;

        return v_json;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end fc_comments_wsget; 


/** 
 * Table Function, gibt alle Kommentare zu einem Auftrag zurück 
 * 
 * @param piv_uuid   [IN ]  ID des Auftrags 
 */
    function fp_comments (
        piv_uuid in ftth_ws_sync_preorders.id%type
    ) return t_comment_table
        pipelined 
/*     
	{ 
		"data": [ 
			{ 
				"id": 1099, 
				"created": "2023-11-16T16:15:37.968151", 
				"createdBy": "schmat", 
				"text": "Hello world." 
			} 
		] 
	}     
*/
    is

        v_comment       t_comment;
        v_ws_response   clob; 
-- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'fp_comments';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_uuid', piv_uuid);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
-- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------      
    begin
        v_ws_response := fc_comments_wsget(piv_uuid => piv_uuid); 

-- RAISE_APPLICATION_ERROR(-20999, 'v_ws_response:' || v_ws_response);     
        for c in (
            with comments as (
                select
                    v_ws_response as comments_data
                from
                    dual
            )
            select
                id,
                fd_json_timestamp(created)     as created,
                coalesce(created_by, 'SYSTEM') as created_by, -- replace(text, '\r\n', CHR(13) || CHR(10)) 
                replace(
                    replace(text,
                            '\r',
                            chr(13)),
                    '\n',
                    chr(10)
                )                              as text
            from
                comments,
                json_table ( comments_data, '$.data[*]'
                        columns (
                            id varchar2 ( 100 ) path "id",
                            created varchar2 ( 26 ) path "created" -- zB. "2023-11-16T15:01:23.706499" 
                            ,
                            created_by varchar2 ( 6 ) path "createdBy",
                            text varchar2 ( 4000 ) path "text"
                        )
                    ) 
             -- neuester Datensatz muss oben stehen 
            order by
                id desc
        ) loop
            pipe row ( new t_comment(c.id          -- .id 
            , 'POB'         -- .usecase 
            , piv_uuid      -- .ref_id 
            , c.created     -- .created 
            , c.created_by  -- .created_by 
            ,
                                     c.text        -- .text 
                                     ) );
        end loop;

        return;
    exception
        when no_data_needed then
            return;
    end fp_comments; 

--@progress 2023-12-05---------------------------------------------------------- 

    function fv_escape_kommentar (
        piv_kommentar in varchar2
    ) return varchar2 is
        v_kommentar varchar2(32767); -- erlaubt sind 4.000 beim Absenden 
    begin
        v_kommentar := apex_escape.striphtml(trim(trim(both chr(13) from trim(both chr(10) from trim(piv_kommentar)))));

        return v_kommentar;
    end; 

/** 
 * Liefert nach einer Validierung den JSON-Body zurück,  
 * der an den REST-Endpunkt COMMENTS_POST gesendet werden muss 
 */
    function fj_comments_post (
        piv_kommentar in varchar2,
        piv_app_user  in varchar2
    ) return clob is

        vj_body         json_object_t := new json_object_t(c_empty_json);
        v_kommentar     varchar2(32767); -- erlaubt sind 4.000 beim Absenden 
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'fj_comments_post';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_kommentar', piv_kommentar);
            pck_format.p_add('piv_app_user', piv_app_user);
        end fcl_params; 

  -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin 
    /* 
    { 
      "createdBy": "schmat", 
      "text": "Hello world." 
    }  
    */
        v_kommentar := fv_escape_kommentar(piv_kommentar); 

      -- Plausi-Prüfungen: 
        if v_kommentar is null then
            return null;
        end if;
        vj_body.put('createdBy', piv_app_user);
        vj_body.put('text', v_kommentar -- Hochkommata werden hier automatisch escaped 
        );
        return vj_body.to_clob;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end fj_comments_post; 


/** 
 * Ruft den REST-Webservice COMMENTS_POST auf, um einen Auftragskommentar 
 * zu speichern, der im Glascontainer erfasst wurde 
 * 
 * @param piv_uuid      [IN ]  Auftrags-Key 
 * @param piv_kommentar [IN ]  Kommentar, möglichst maximal 4.000 Zeichen  
 *                             (wird truncated und escaped) 
 * @param piv_app_user  [IN ]  User, der den Kommentar verfasst hat 
 */
    procedure p_kommentar_abschicken (
        piv_uuid      in varchar2,
        piv_kommentar in varchar2,
        piv_app_user  in varchar2
    ) is

        vc_body         clob;
        v_ws_statuscode integer;
        v_ws_response   clob;    
-- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'p_kommentar_abschicken';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_uuid', piv_uuid);
            pck_format.p_add('piv_kommentar', piv_kommentar);
            pck_format.p_add('piv_app_user', piv_app_user);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
-- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------      
    begin
        if length(piv_kommentar) > 2000 then
            raise_application_error(c_plausi_error_number, 'Bitte den Kommentar auf 2.000 Zeichen begrenzen');
        end if; 

    -- Der Kommentar wird in diesem Aufruf validiert und zusammengestellt: 
        vc_body := fj_comments_post(
            piv_kommentar => piv_kommentar,
            piv_app_user  => piv_app_user
        ); 

    -- Darf nicht leer sein: 
        if vc_body is null then
            raise_application_error(c_plausi_error_number, 'Kommentar ist leer');
        end if; 

    -- Webservice aufrufen: 
    /*
    PCK_POB_REST.p_webservice_post( 
      piv_kontext    => PCK_POB_REST.KONTEXT_PREORDERBUFFER, 
      piv_ws_key     => PCK_POB_REST.C_WS_KEY_COMMENTS_POST, 
      piv_uuid       => piv_uuid, 
      piv_app_user   => piv_app_user, 
      pic_body       => vc_body       
    );
    */ 
        -- 2024-12-31 @ticket FTTH-4314 
        pck_pob_rest.p_webservice_post2(
            piv_kontext       => pck_pob_rest.kontext_preorderbuffer,
            piv_ws_key        => pck_pob_rest.c_ws_key_comments_post,
            piv_uuid          => piv_uuid,
            piv_app_user      => piv_app_user,
            pic_body          => vc_body 
          ---       
            ,
            pov_ws_statuscode => v_ws_statuscode,
            pov_ws_response   => v_ws_response
        ); 

        -- 2024-12-31 @ticket FTTH-4314: Status nun hier überprüfen anstatt schon im PCK_POB _REST:
        if v_ws_statuscode <> c_ws_statuscode_ok then -- REST-Antwort liefert Fehler:
            case v_ws_statuscode
                when pck_pob_rest.c_ws_statuscode_conflict then -- 409
                    raise_application_error(pck_pob_rest.c_request_auftrag_gesperrt,
                                            fv_http_statusmessage(v_ws_statuscode));
                when pck_pob_rest.c_ws_statuscode_bad_request then -- 400
                    raise_application_error(pck_pob_rest.c_request_not_successful,
                                            fv_http_statusmessage(v_ws_statuscode));
                else
             -- ursprünglich:
                --RAISE PCK_POB_REST.E_REQUEST_NOT_SUCCESSFUL; -- das ist -20042, wo wir leider keine näheren Informationen haben, was falsch gelaufen ist
             -- neu:
                    raise_application_error(pck_pob_rest.c_request_not_successful,
                                            fv_http_statusmessage(v_ws_statuscode));
            end case;
        end if;

    exception
        when pck_pob_rest.e_request_auftrag_gesperrt then
            raise; -- ohne Loggen gemäß @ticket FTTH-4314  
        when e_plausi_error then
            raise; -- ohne Loggen
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end p_kommentar_abschicken; 


/** 
 * Liefert zum Schlüssel eines Wholebuy-Partners (z.B. 'TCOM') den dazugehörigen 
 * Namen ('Telekom') zurück, falls dieser existiert, ansonsten den Key 
 * 
 * @param piv_wholebuy_key  Schlüssel des Wholebuy-Partners 
 * 
 * @usage Anzeige des Partner-Namens, soweit bekannt, oder ersatzweise des Keys 
 */
    function fv_wholebuy_partner_display (
        piv_wholebuy_key in varchar2
    ) return varchar2 is

        v_wholebuy_partner enum.singular%type; 
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name    constant logs.routine_name%type := 'fv_wholebuy_partner_display';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_wholebuy_key', piv_wholebuy_key);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
  -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------      
    begin
        select
            coalesce(
                max(singular),
                piv_wholebuy_key
            )
        into v_wholebuy_partner
        from
            enum
        where
                domain = 'WHOLEBUY_PARTNER'
            and key = piv_wholebuy_key
            and sprache = '*';

        return v_wholebuy_partner;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end fv_wholebuy_partner_display; 

/** 
 @url availability Check: 
 https://wwwdev.netcologne.de/api/availability?zipCode=41539&street=Holbeinweg&houseNumber=1&city=Dormagen 
 "Browserstack" von Philip Kübler 
*/ 

--@progress 2023-12-14---------------------------------------------------------- 

/** 
 * Löscht alle Datensätze aus der Tabelle FTTH_WEBSERVICE_AUFRUFE, die 
 * älter als 90 Tage sind 
 * 
 * @param pin_anzahl_tage  [IN ]  Falls gesetzt, wird anstelle der 90-Tage-Grenze 
 *                                diese Anzahl Tage verwendet 
 */
    procedure p_delete_webservice_logs (
        pin_anzahl_tage in natural default 90
    ) is
    begin
        delete ftth_webservice_aufrufe
        where
            sysdate - cast(uhrzeit as date) > coalesce(pin_anzahl_tage, 90);

    end p_delete_webservice_logs; 


/**   
 * Gibt eine Tabelle mit der Darstellung der Rollen zurück, die 
 * der User hat bzw. nicht hat. 
 * 
 * @param piv_rollenliste [IN ] Siehe Glascontainer: G_ROLLENLISTE 
 */
    function fc_rollen_display (
        piv_rollenliste in varchar2
    ) return varchar2
        deterministic
    is

        v_html varchar2(32767);

        procedure rolle_pruefen (
            i_rollenname   in varchar2,
            i_beschreibung in varchar2
        ) is
            v_hat_rolle_janein varchar2(10);
        begin
            v_hat_rolle_janein :=
                case
                    when instr(
                        upper(piv_rollenliste),
                        upper( 
         -- wegen des Schreibfehlers, der irgendwem beim Einrichten der Rolle im AD passiert ist: 
                                              case i_rollenname
                                                  when 'Administrator' then
                                                      'Adminstrator'
                                                  else i_rollenname
                                              end
                                          )
                    ) > 0 then
                        'ja'
                    else 'nein'
                end;

            v_html := v_html
                      || '<tr><td class="rollenname">'
                      || i_rollenname
                      || '</td>'
                      || '<td class="janein '
                      || v_hat_rolle_janein
                      || '">'
                      ||
                case v_hat_rolle_janein
                    when 'ja' then
                        ' &#10004;'
                    else '&mdash;'
                end
                      || '</td>'
                      || '<td class="rollenbeschreibung">'
                      || i_beschreibung
                      || '</td>'
                      || '</tr>';

        end;

    begin
        v_html := '<table id="rollendisplay">'; 
    -- Alle 4 vorhandenen Rollen überprüfen: 
        rolle_pruefen('Administrator', 'Einstellungen, Logs');
        rolle_pruefen('Superuser', 'Auftragsliste, Storno, Dublettensuche');
        rolle_pruefen('User', 'Ändern und Abschließen von Aufträgen');
        rolle_pruefen('ReadOnly', 'Auftragsansicht aus Siebel');
        v_html := v_html || '</table>';
        return v_html;
    end; 

--@progress 2024-01-16---------------------------------------------------------- 

/** 
 * Liest die Daten eines Kunden aus Siebel anhand der Kundennummer ein. 
 * Im Gegensatz zu get_siebel_kopfdaten sind es mehr Felder, und es gibt auch 
 * keine Ergänzungs-Automatik (alle Ausgabefelder sind OUT anstatt IN OUT). 
 * Die Adresse, die aus Siebel kommt, wird in ein anzeigefreundliches Format umgewandelt 
 * HAUSNR_VON, HAUSNR_BIS, HAUSNR_ZUSATZ_VON und HAUSNR_ZUSATZ_BIS ergeben "STRASSE" (inklusive aller Zusätze), 
 * PLZ und ORT ergeben PLZ_ORT 
 *  
 * @param piv_kundennummer      [IN]   NR. des Kunden, dessen Daten gesucht werden 
 * @param pov_message           [OUT]  Üblicherweise leer.  
 *                                     Im Fehlerfall wird hier eine Benutzermeldung zurückgegeben 
 * @param pov_global_id         [OUT]  GLOBAL_ID aus Siebel 
 * @param pov_vorname           [OUT]  Vorname 
 * @param pov_nachname          [OUT]  Nachname 
 * @param pod_geburtsdatum      [OUT]  Geburtsdatum 
 * @param pov_anrede            [OUT]  Anrede 
 * @param pov_titel             [OUT]  Titel 
 * @param pov_firmenname        [OUT]  Firmenname 
 * @param pov_strasse           [OUT]  Straße (inkl. Hausnummer, Zusatz) 
 * @param pov_plz_ort           [OUT]  Postleitzahl und Ort 
 * @param pov_iban              [OUT]  Bankverbindung: IBAN 
 * @param pov_ap_rufnummer      [OUT]  Mobilrufnummer des primären Ansprechpartners 
 * @param pov_ap_email          [OUT]  E-Mail-Adresses des primären Ansprechpartners 
 *  
 * @throws  Alle Exceptions werden geworden. 
 *          Kein Fehlerlogging: Das aufrufende Programm entscheidet, ob 
 *          es einen Fehler loggen möchte (beispielsweise nicht, wenn  
 *          lediglich ein Tippfehler bei der Eingabe der Kundennummer auftritt) 
 * @usage  Auftragserfassung im Glascontainer: Bestandskunden-Maske 
 * @ticket FTTH-2807 
 * @AP     Thorsten Westenberg 
 */
    procedure p_get_siebel_kundendaten (
        piv_kundennummer     in varchar2 
    -- 
        ,
        pov_message          out varchar2,
        pov_global_id        out varchar2,
        pov_vorname          out varchar2,
        pov_nachname         out varchar2,
        pod_geburtsdatum     out date,
        pov_anrede           out varchar2,
        pov_titel            out varchar2,
        pov_firmenname       out varchar2,
        pov_strasse          out varchar2,
        pov_plz_ort          out varchar2,
        pov_ap_email         out varchar2,
        pov_ap_mobil_country out varchar2,
        pov_ap_mobil_onkz    out varchar2,
        pov_ap_mobil_nr      out varchar2
    ) is 
    -- Diese Felder gibt es in Siebel, aber nicht an der 
    -- Glascontainer-Benutzeroberfläche und auch nicht in der STRAV-Adresse: 
        v_hausnr            varchar2(255);
        v_hausnr_zusatz     varchar2(255);
        v_hausnr_bis        varchar2(255);
        v_hausnr_zusatz_bis varchar2(255);
        v_plz               varchar2(255);
        v_ort               varchar2(255);
        v_iban              varchar2(255); -- wird abgefragt, aber nicht als Ausgabe genutzt 
        v_bu                varchar2(255); -- wird abgefragt, aber nicht als Ausgabe genutzt 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name     constant logs.routine_name%type := 'p_get_siebel_kundendaten';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_kundennummer', piv_kundennummer);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------      
    begin
        if piv_kundennummer is null then
            pov_message := 'Die Kundennummer ist leer';
            return;
        end if;
        pck_glascontainer_ext.p_get_siebel_kundendaten(
            piv_kundennummer      => piv_kundennummer 
        -- 
            ,
            pov_global_id         => pov_global_id,
            pov_vorname           => pov_vorname,
            pov_nachname          => pov_nachname,
            pod_geburtsdatum      => pod_geburtsdatum,
            pov_anrede            => pov_anrede,
            pov_titel             => pov_titel,
            pov_firmenname        => pov_firmenname,
            pov_strasse           => pov_strasse,
            pov_hausnr_von        => v_hausnr,
            pov_hausnr_zusatz_von => v_hausnr_zusatz,
            pov_hausnr_bis        => v_hausnr_bis        -- auffangen und weiterverarbeiten 
            ,
            pov_hausnr_zusatz_bis => v_hausnr_zusatz_bis -- auffangen und weiterverarbeiten 
            ,
            pov_plz               => v_plz,
            pov_ort               => v_ort,
            pov_iban              => v_iban,
            pov_ap_email          => pov_ap_email,
            pov_ap_mobil_country  => pov_ap_mobil_country,
            pov_ap_mobil_onkz     => pov_ap_mobil_onkz,
            pov_ap_mobil_nr       => pov_ap_mobil_nr,
            pov_bu                => v_bu
        );

        pov_strasse := trim(pov_strasse
                            || ' '
                            || v_hausnr
                            || v_hausnr_zusatz
                            ||
            case
                when v_hausnr_bis is not null
                     or v_hausnr_zusatz_bis is not null then
                    '-'
            end
                            || v_hausnr_bis
                            || ' '
                            || v_hausnr_zusatz_bis);

        pov_plz_ort := v_plz
                       || ' '
                       || v_ort;
    exception -- Der Nutzer bekommt alle Fehlermeldungen in der App angezeigt: 
        when no_data_found then
            pov_message := 'Zur Kundennummer '
                           || piv_kundennummer
                           || ' wurden keine Kundendaten gefunden'; -- Agent kann die Kundennummer neu eingeben 
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            pov_message := sqlerrm;
    end p_get_siebel_kundendaten; 

--@progress 2024-05-22---------------------------------------------------------- 

/** 
 * Liest die Daten eines Kunden aus Siebel anhand der Kundennummer ein. 
 * Im Gegensatz zu get_siebel_kopfdaten sind es mehr Felder, und es gibt auch 
 * keine Ergänzungs-Automatik (alle Ausgabefelder sind OUT anstatt IN OUT).
 *
 * @usage  Ersetzt ggf. die gleichnamige Routine mit weniger OUT-Parametern (dirket hierüber)
 *  
 * @param piv_kundennummer      [IN]   NR. des Kunden, dessen Daten gesucht werden 
 * @param pov_message           [OUT]  Üblicherweise leer.  
 *                                     Im Fehlerfall wird hier eine Benutzermeldung zurückgegeben 
 * @param pov_global_id         [OUT]  GLOBAL_ID aus Siebel 
 * @param pov_vorname           [OUT]  Vorname 
 * @param pov_nachname          [OUT]  Nachname 
 * @param pod_geburtsdatum      [OUT]  Geburtsdatum 
 * @param pov_anrede            [OUT]  Anrede 
 * @param pov_titel             [OUT]  Titel 
 * @param pov_firmenname        [OUT]  Firmenname 
 * @param pov_strasse           [OUT]  Straße
 * @param pov_hausnr            [OUT]  Hausnummer
 * @param pov_plz               [OUT]  Postleitzahl
 * @param pov_ort               [OUT]  Ort  
 * @param pov_iban              [OUT]  Bankverbindung: IBAN 
 * @param pov_ap_rufnummer      [OUT]  Mobilrufnummer des primären Ansprechpartners 
 * @param pov_ap_email          [OUT]  E-Mail-Adresses des primären Ansprechpartners 
 * @param pov_iban              [OUT]  Bankverbindung aus Siebel
 *  
 * @throws  Alle Exceptions werden geworden. 
 *          Kein Fehlerlogging: Das aufrufende Programm entscheidet, ob 
 *          es einen Fehler loggen möchte (beispielsweise nicht, wenn  
 *          lediglich ein Tippfehler bei der Eingabe der Kundennummer auftritt) 
 * @usage  Auftragserfassung im Glascontainer: Bestandskunden-Maske 
 * @ticket FTTH-2807 
 * @AP     Thorsten Westenberg 
 */
    procedure p_get_siebel_kundendaten (
        piv_kundennummer     in varchar2 
    -- 
        ,
        pov_message          out varchar2,
        pov_global_id        out varchar2,
        pov_vorname          out varchar2,
        pov_nachname         out varchar2,
        pod_geburtsdatum     out date,
        pov_anrede           out varchar2,
        pov_titel            out varchar2,
        pov_firmenname       out varchar2,
        pov_strasse          out varchar2,
        pov_hausnr           out varchar2,
        pov_plz              out varchar2,
        pov_ort              out varchar2,
        pov_ap_email         out varchar2,
        pov_ap_mobil_country out varchar2,
        pov_ap_mobil_onkz    out varchar2,
        pov_ap_mobil_nr      out varchar2,
        pov_iban             out varchar2
    ) is 
    -- Diese Felder gibt es in Siebel, aber nicht an der 
    -- Glascontainer-Benutzeroberfläche und auch nicht in der STRAV-Adresse:    
        v_hausnr_zusatz     varchar2(255);
        v_hausnr_bis        varchar2(255);
        v_hausnr_zusatz_bis varchar2(255);
        v_iban              varchar2(255); -- wird abgefragt, aber nicht als Ausgabe genutzt 
        v_bu                varchar2(255); -- wird abgefragt, aber nicht als Ausgabe genutzt 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name     constant logs.routine_name%type := 'p_get_siebel_kundendaten';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_kundennummer', piv_kundennummer);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------      
    begin
        if piv_kundennummer is null then
            pov_message := 'Die Kundennummer ist leer';
            return;
        end if;
        pck_glascontainer_ext.p_get_siebel_kundendaten(
            piv_kundennummer      => piv_kundennummer 
        -- 
            ,
            pov_global_id         => pov_global_id,
            pov_vorname           => pov_vorname,
            pov_nachname          => pov_nachname,
            pod_geburtsdatum      => pod_geburtsdatum,
            pov_anrede            => pov_anrede,
            pov_titel             => pov_titel,
            pov_firmenname        => pov_firmenname,
            pov_strasse           => pov_strasse,
            pov_hausnr_von        => pov_hausnr          -- auffangen und weiterverarbeiten 
            ,
            pov_hausnr_zusatz_von => v_hausnr_zusatz     -- auffangen und weiterverarbeiten 
            ,
            pov_hausnr_bis        => v_hausnr_bis        -- auffangen und weiterverarbeiten 
            ,
            pov_hausnr_zusatz_bis => v_hausnr_zusatz_bis -- auffangen und weiterverarbeiten 
            ,
            pov_plz               => pov_plz,
            pov_ort               => pov_ort,
            pov_iban              => pov_iban,
            pov_ap_email          => pov_ap_email,
            pov_ap_mobil_country  => pov_ap_mobil_country,
            pov_ap_mobil_onkz     => pov_ap_mobil_onkz,
            pov_ap_mobil_nr       => pov_ap_mobil_nr,
            pov_bu                => v_bu
        );

        pov_hausnr := trim(pov_hausnr
                           || v_hausnr_zusatz
                           ||
            case
                when v_hausnr_bis is not null
                     or v_hausnr_zusatz_bis is not null then
                    '-'
            end
                           || v_hausnr_bis
                           || ' '
                           || v_hausnr_zusatz_bis);

    exception -- Der Nutzer bekommt alle Fehlermeldungen in der App angezeigt: 
        when no_data_found then
            pov_message := 'Zur Kundennummer '
                           || piv_kundennummer
                           || ' wurden keine Kundendaten gefunden'; -- Agent kann die Kundennummer neu eingeben 
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            pov_message := sqlerrm;
    end p_get_siebel_kundendaten;

-- @progress 2024-06-25  

/** 
 * Liest die Daten eines Kunden aus Siebel anhand der Kundennummer ein. 
 * Im Gegensatz zu get_siebel_kopfdaten sind es mehr Felder, und es gibt auch 
 * keine Ergänzungs-Automatik (alle Ausgabefelder sind OUT anstatt IN OUT).
 *
 * @usage  Ersetzt ggf. die gleichnamige Routine mit weniger OUT-Parametern (dirket hierüber)
 *  
 * @param piv_kundennummer      [IN]   NR. des Kunden, dessen Daten gesucht werden 
 * @param piv_filialnummer      [IN]   UnterkundenNR. des Kunden, dessen Daten gesucht werden 
 * @param pov_message           [OUT]  Üblicherweise leer.  
 *                                     Im Fehlerfall wird hier eine Benutzermeldung zurückgegeben 
 * @param pov_global_id         [OUT]  GLOBAL_ID aus Siebel 
 * @param pov_vorname           [OUT]  Vorname 
 * @param pov_nachname          [OUT]  Nachname 
 * @param pod_geburtsdatum      [OUT]  Geburtsdatum 
 * @param pov_anrede            [OUT]  Anrede 
 * @param pov_titel             [OUT]  Titel 
 * @param pov_firmenname        [OUT]  Firmenname 
 * @param pov_strasse           [OUT]  Straße
 * @param pov_hausnr            [OUT]  Hausnummer
 * @param pov_plz               [OUT]  Postleitzahl
 * @param pov_ort               [OUT]  Ort  
 * @param pov_iban              [OUT]  Bankverbindung: IBAN 
 * @param pov_ap_rufnummer      [OUT]  Mobilrufnummer des primären Ansprechpartners 
 * @param pov_ap_email          [OUT]  E-Mail-Adresses des primären Ansprechpartners 
 * @param pov_iban              [OUT]  Bankverbindung aus Siebel
 * @param pov_bu                [OUT]  Businessunit
 *  
 * @throws  Alle Exceptions werden geworden. 
 *          Kein Fehlerlogging: Das aufrufende Programm entscheidet, ob 
 *          es einen Fehler loggen möchte (beispielsweise nicht, wenn  
 *          lediglich ein Tippfehler bei der Eingabe der Kundennummer auftritt) 
 * @usage  Auftragserfassung im Glascontainer: Bestandskunden-Maske 
 * @ticket FTTH-2807 
 * @AP     Thorsten Westenberg 
 */
    procedure p_get_siebel_kundendaten (
        piv_kundennummer     in varchar2,
        piv_filialnummer     in varchar2 default '0000'
    -- 
        ,
        pov_message          out varchar2,
        pov_global_id        out varchar2,
        pov_vorname          out varchar2,
        pov_nachname         out varchar2,
        pod_geburtsdatum     out date,
        pov_anrede           out varchar2,
        pov_titel            out varchar2,
        pov_firmenname       out varchar2,
        pov_strasse          out varchar2,
        pov_hausnr           out varchar2,
        pov_plz              out varchar2,
        pov_ort              out varchar2,
        pov_ap_email         out varchar2,
        pov_ap_mobil_country out varchar2,
        pov_ap_mobil_onkz    out varchar2,
        pov_ap_mobil_nr      out varchar2,
        pov_iban             out varchar2,
        pov_bu               out varchar2
    ) is 
    -- Diese Felder gibt es in Siebel, aber nicht an der 
    -- Glascontainer-Benutzeroberfläche und auch nicht in der STRAV-Adresse:    
        v_hausnr_zusatz     varchar2(255);
        v_hausnr_bis        varchar2(255);
        v_hausnr_zusatz_bis varchar2(255);
        v_iban              varchar2(255); -- wird abgefragt, aber nicht als Ausgabe genutzt 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name     constant logs.routine_name%type := 'p_get_siebel_kundendaten';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_kundennummer', piv_kundennummer);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------      
    begin
        if piv_kundennummer is null then
            pov_message := 'Die Kundennummer ist leer';
            return;
        end if;
        pck_glascontainer_ext.p_get_siebel_kundendaten(
            piv_kundennummer      => piv_kundennummer,
            piv_filialnummer      => piv_filialnummer 
        -- 
            ,
            pov_global_id         => pov_global_id,
            pov_vorname           => pov_vorname,
            pov_nachname          => pov_nachname,
            pod_geburtsdatum      => pod_geburtsdatum,
            pov_anrede            => pov_anrede,
            pov_titel             => pov_titel,
            pov_firmenname        => pov_firmenname,
            pov_strasse           => pov_strasse,
            pov_hausnr_von        => pov_hausnr          -- auffangen und weiterverarbeiten 
            ,
            pov_hausnr_zusatz_von => v_hausnr_zusatz     -- auffangen und weiterverarbeiten 
            ,
            pov_hausnr_bis        => v_hausnr_bis        -- auffangen und weiterverarbeiten 
            ,
            pov_hausnr_zusatz_bis => v_hausnr_zusatz_bis -- auffangen und weiterverarbeiten 
            ,
            pov_plz               => pov_plz,
            pov_ort               => pov_ort,
            pov_iban              => pov_iban,
            pov_ap_email          => pov_ap_email,
            pov_ap_mobil_country  => pov_ap_mobil_country,
            pov_ap_mobil_onkz     => pov_ap_mobil_onkz,
            pov_ap_mobil_nr       => pov_ap_mobil_nr,
            pov_bu                => pov_bu
        );

        pov_hausnr := trim(pov_hausnr
                           || v_hausnr_zusatz
                           ||
            case
                when v_hausnr_bis is not null
                     or v_hausnr_zusatz_bis is not null then
                    '-'
            end
                           || v_hausnr_bis
                           || ' '
                           || v_hausnr_zusatz_bis);

    exception -- Der Nutzer bekommt alle Fehlermeldungen in der App angezeigt: 
        when no_data_found then
            pov_message := 'Zur Kundennummer '
                           || piv_kundennummer
                           || ' wurden keine Kundendaten gefunden'; -- Agent kann die Kundennummer neu eingeben 
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            pov_message := sqlerrm;
    end p_get_siebel_kundendaten;


/**
 * Schreibt einen Log-Eintrag in die Tabelle FTTH_GLASCONTAINER_LOG (als
 * autonome Transaktion)

 * 
 * @param piv_session_id [IN]  APEX Session-ID (siehe Browser-URL)
 * @param pin_page_id    [IN]  APEX-Seitennummer
 * @param piv_aktion     [IN]  Kurzbeschreibung der Aktion (z.B. "CLICK", "ENTER")
 * @param piv_objekt     [IN]  ID des Items oder Buttons etc.
 */
    procedure p_log_aktion (
        piv_session_id in varchar2,
        pin_page_id    in integer,
        piv_aktion     in varchar2,
        piv_objekt     in varchar2
    ) is
        pragma autonomous_transaction;
    begin
        insert into ftth_glascontainer_log (
            uhrzeit,
            session_id,
            page_id,
            aktion,
            objekt
        ) values ( systimestamp,
                   substr(piv_session_id, 1, 30),
                   pin_page_id,
                   substr(piv_aktion, 1, 100),
                   substr(piv_objekt, 1, 100) );

        commit;
    exception
        when others then
            rollback;
    end p_log_aktion;



/**
 * Gibt die Kurzbezeichnungen (z.B. "FTTH", "G.fast") für die Diensttyp-Nummer zurück, die für den Glascontainer derzeit relevant sind.
 *
 * @param piv_dnsttp_lfd_nr [IN ] Erwartet wird eine Zahl, aber APEX sendet diese Zahl als String, daher sicherheitshalber piv
 *
 * @ticket FTTH-3957: Funktion benötigt einen neuen Namen oder Parameter, sobald die Vermarktungscluster
 *                    die neuen Diensttypen > 70 erhalten - dann wird die Frage, ob ein Wholebuy-Partner
 *                    mit von der Partie ist, durch den Diensttyp beantwortet.
 *
 * @see  neue Funktion fv_technologie_display
 */
    function fv_technologie (
        piv_dnsttp_lfd_nr varchar2
    ) return varchar2
        deterministic
    is
    begin
        if piv_dnsttp_lfd_nr is null then
            return null;
        end if;
    -- Die Bezeichungen sollten mit der Tabelle TAB_DIENST_TYP übereinstimmen.
    -- Es besteht gegebenenfalls die Möglichkeit, bei deutlich mehr als einem halben Dutzend Werten
    -- das Mapping aus ebenjener Tabelle auszulesen.
        return
            case piv_dnsttp_lfd_nr
                when '70' then
                    'FTTH'
                when '71' then
                    'G.fast'
                when '89' then
                    'FTTH BSA L2'
                when '90' then
                    'FTTH BSA L2 DG' -- @krakar @Ticket Ftth-3360: Einfügen der Technologie DG
                --- zusätzliche Werte aus @ticket FTTH-4077:
                when '52' then
                    'FTTB' -- im Original ist das "VDSL2"
                else null
            end;

    end fv_technologie;

-- @progress 2024-07-02

/**
 * Gibt den Anzeigetext für ein Mandantenkürzel zurück, also beispielsweise "NetCologne" für "NC"
 * 
 * @param piv_mandant_kuerzel   Aktuelle Werte: siehe Spalte VERMARKTUNGSCLUSTER.MANDANT
 *
 * @ticket FTTH-3495
 */
    function fv_mandant_display (
        piv_mandant_kuerzel in varchar2
    ) return varchar2
        deterministic
    is
    begin
        return
            case upper(piv_mandant_kuerzel)
                when 'NA' then
                    'NetAachen'
                when 'NC' then
                    'NetCologne'
                else null
            end;
    end fv_mandant_display;

-- @progress 2024-07-10

/** 
  * Prüft die Eingangsdaten und erstellt daraus den JSON-Body, 
  * der für den Aufruf des POST-Webservices "preorders" 
  * zur Aktualisierung der Vermieterdaten benötigt wird
  *
  * @ticket FTTH-3837
  */
    function fj_preorders_landlord_update (
        piv_vermieter_rechtsform     in varchar2,
        piv_vermieter_firmenname     in varchar2,
        piv_vermieter_anrede         in varchar2,
        piv_vermieter_titel          in varchar2,
        piv_vermieter_nachname       in varchar2,
        piv_vermieter_vorname        in varchar2,
        piv_vermieter_strasse        in varchar2,
        piv_vermieter_hausnr         in varchar2,
        piv_vermieter_zusatz         in varchar2,
        piv_vermieter_plz            in varchar2,
        piv_vermieter_ort            in varchar2,
        piv_vermieter_land           in varchar2,
        piv_vermieter_email          in varchar2,
        piv_vermieter_laendervorwahl in varchar2,
        piv_vermieter_vorwahl        in varchar2,
        piv_vermieter_telefon        in varchar2
    ) return clob is 
    /*
    -- Erwartet wird dieses Objekt:

{
  "legalForm": "PRIVATE_CITIZEN",
  "businessOrName": null,
  "salutation": "MISTER",
  "title": null,
  "name": {
    "first": "Dagobert",
    "last": "Duck"
  },
  "address": {
    "street": "Breite Straße",
    "houseNumber": "5",
    "zipCode": "55122",
    "city": "Mainz",
    "postalAddition": "test",
    "country": "Deutschland"
  },
  "email": "test@netcologne.com",
  "phoneNumber": {
    "countryCode": "+49",
    "areaCode": null,
    "number": "1235456"
  }
}    
*/
        vj_landlord     json_object_t := new json_object_t(c_empty_json);
        vj_name         json_object_t := new json_object_t(c_empty_json);
        vj_address      json_object_t := new json_object_t(c_empty_json);
        vj_phone_number json_object_t := new json_object_t(c_empty_json);
    begin
        vj_landlord.put('legalForm', piv_vermieter_rechtsform);
        vj_landlord.put('businessOrName', piv_vermieter_firmenname);
        vj_landlord.put('salutation', piv_vermieter_anrede);
        vj_landlord.put('title', piv_vermieter_titel);
        vj_name.put('first', piv_vermieter_vorname);
        vj_name.put('last', piv_vermieter_nachname);
        -- https://jira.netcologne.intern/browse/FTTH-5593 => nur wenn es eine Privatperson ist, soll Vor- und Nachname mitgeschickt werden  
        vj_landlord.put('name',
                        case
                    when nvl(piv_vermieter_rechtsform, '-') = 'PRIVATE_CITIZEN' then
                        vj_name
                    else null
                end
        );

        vj_address.put('street', piv_vermieter_strasse);
        vj_address.put('houseNumber', piv_vermieter_hausnr);
        vj_address.put('zipCode', piv_vermieter_plz);
        vj_address.put('city', piv_vermieter_ort);
        vj_address.put('postalAddition', piv_vermieter_zusatz);
        vj_address.put('country', piv_vermieter_land);
        vj_landlord.put('address', vj_address);
        vj_landlord.put('email', piv_vermieter_email);
        vj_phone_number.put('countryCode', piv_vermieter_laendervorwahl);
        vj_phone_number.put('areaCode', piv_vermieter_vorwahl);
        vj_phone_number.put('number', piv_vermieter_telefon);
        vj_landlord.put('phoneNumber', vj_phone_number);
        return vj_landlord.to_clob;
    end fj_preorders_landlord_update; 

/**
 * Sendet die von APEX erhaltenen Vermieter-Felder (bei einem Auftrag im Status CLEARING_LANDLORD_DATA) an den Webservice
 *
 * @ticket FTTH-3837
 */
    procedure p_landlord_speichern (
        piv_uuid                      in varchar2,
        piv_app_user                  in varchar2,
        piv_vermieter_rechtsform      in varchar2,
        piv_vermieter_firmenname      in varchar2,
        piv_vermieter_anrede          in varchar2,
        piv_vermieter_titel           in varchar2,
        piv_vermieter_nachname        in varchar2,
        piv_vermieter_vorname         in varchar2,
        piv_vermieter_strasse         in varchar2,
        piv_vermieter_hausnr          in varchar2,
        piv_vermieter_zusatz          in varchar2,
        piv_vermieter_plz             in varchar2,
        piv_vermieter_ort             in varchar2,
        piv_vermieter_land            in varchar2,
        piv_vermieter_email           in varchar2,
        piv_vermieter_laendervorwahl  in varchar2,
        piv_vermieter_vorwahl         in varchar2,
        piv_vermieter_telefon         in varchar2,
        piv_vermieter_einverstaendnis in varchar2
    ) is

        vc_body              clob;
        v_ws_statuscode      integer;
        v_ws_response        clob;
        v_rest_error_message varchar2(500 char);
-- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name      constant logs.routine_name%type := 'p_landlord_speichern';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_uuid', piv_uuid);
            pck_format.p_add('piv_app_user', piv_app_user);
            pck_format.p_add('piv_vermieter_rechtsform', piv_vermieter_rechtsform);
            pck_format.p_add('piv_vermieter_firmenname', piv_vermieter_firmenname);
            pck_format.p_add('piv_vermieter_anrede', piv_vermieter_anrede);
            pck_format.p_add('piv_vermieter_titel', piv_vermieter_titel);
            pck_format.p_add('piv_vermieter_nachname', piv_vermieter_nachname);
            pck_format.p_add('piv_vermieter_vorname', piv_vermieter_vorname);
            pck_format.p_add('piv_vermieter_strasse', piv_vermieter_strasse);
            pck_format.p_add('piv_vermieter_hausnr', piv_vermieter_hausnr);
            pck_format.p_add('piv_vermieter_zusatz', piv_vermieter_zusatz);
            pck_format.p_add('piv_vermieter_plz', piv_vermieter_plz);
            pck_format.p_add('piv_vermieter_ort', piv_vermieter_ort);
            pck_format.p_add('piv_vermieter_land', piv_vermieter_land);
            pck_format.p_add('piv_vermieter_email', piv_vermieter_email);
            pck_format.p_add('piv_vermieter_laendervorwahl', piv_vermieter_laendervorwahl);
            pck_format.p_add('piv_vermieter_vorwahl', piv_vermieter_vorwahl);
            pck_format.p_add('piv_vermieter_telefon', piv_vermieter_telefon);
            pck_format.p_add('piv_vermieter_einverstaendnis', piv_vermieter_einverstaendnis);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
-- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 

    begin

    -- Für Wholebuy-Bestellungen benötigt NetCologne Eigentümerdaten, wenn der Kunde ein Mieter oder Teileigentümer ist. 
    -- Diese Eigentümerdaten können fehlen, denn der Kunde muss bzw. kann sie ggf. nicht angeben.
    -- Der Auftrag landet dann im Status CLEARING_LANDLORD_DATA ("Clearing Eigentümerdaten"). 
    -- Im Glascontainer sollen diese fehlenden Daten eingegeben werden können. Nach der Validierung werden sie 
    -- mit diesem Prozess an den Preorderbuffer gesendet.
    -- Der Server (Preorderbuffer) gewährleistet zusammen mit dem Auftragsstatus, dass in diesen Feldern vorher nichts drinsteht;
    -- dies muss der Glascontainer also nicht extra validieren.


    /*
URL, wie bei "get orders" oder "cancel order" mit folgender Endung:
".../preorders/{orderId}/landlord"        

    */

-- ////@klären: Welche Rolle spielen
-- P20_KONTAKTDATEN_BEKANNT
-- P20_CAN_EDIT

    -- //// Plausi-Checks

    -- //// Erstellen des JSON-Payloads analog zu FJ_PREORDERS_PRODUCT_UPDATE
        vc_body := fj_preorders_landlord_update(
            piv_vermieter_rechtsform     => piv_vermieter_rechtsform,
            piv_vermieter_firmenname     => piv_vermieter_firmenname,
            piv_vermieter_anrede         => piv_vermieter_anrede,
            piv_vermieter_titel          => piv_vermieter_titel,
            piv_vermieter_nachname       => piv_vermieter_nachname,
            piv_vermieter_vorname        => piv_vermieter_vorname,
            piv_vermieter_strasse        => piv_vermieter_strasse,
            piv_vermieter_hausnr         => piv_vermieter_hausnr,
            piv_vermieter_zusatz         => piv_vermieter_zusatz,
            piv_vermieter_plz            => piv_vermieter_plz,
            piv_vermieter_ort            => piv_vermieter_ort,
            piv_vermieter_land           => piv_vermieter_land,
            piv_vermieter_email          => piv_vermieter_email,
            piv_vermieter_laendervorwahl => piv_vermieter_laendervorwahl,
            piv_vermieter_vorwahl        => piv_vermieter_vorwahl,
            piv_vermieter_telefon        => piv_vermieter_telefon
        );

    -- //// Absenden der Änderungen
    /*
    pck_pob_rest.p_webservice_post(
          piv_kontext    => PCK_POB_REST.KONTEXT_PREORDERBUFFER 
        , piv_ws_key     => C_WS_KEY_PREORDERS_LANDLORD_POST 
        , piv_uuid       => piv_uuid 
        , piv_app_user   => piv_app_user 
        , pic_body       => vc_body);     
    */
    -- 2024-12-31 @ticket FTTH-4314 
        pck_pob_rest.p_webservice_post2(
            piv_kontext       => pck_pob_rest.kontext_preorderbuffer,
            piv_ws_key        => c_ws_key_preorders_landlord_post,
            piv_uuid          => piv_uuid,
            piv_app_user      => piv_app_user,
            pic_body          => vc_body 
          ---       
            ,
            pov_ws_statuscode => v_ws_statuscode,
            pov_ws_response   => v_ws_response
        ); 

        -- 2024-12-31 @ticket FTTH-4314: Status nun hier überprüfen anstatt schon im PCK_POB _REST:
        if v_ws_statuscode <> c_ws_statuscode_ok then -- REST-Antwort liefert Fehler:
            -- FTTH-4993 Statuscode neue Fehlermeldung ermitteln da alte allg. Fehlermeldung nicht ausreichend ist
            v_rest_error_message := pck_pob_rest.fv_get_error_message(piv_json_response => v_ws_response);
            if v_rest_error_message is null then
                v_rest_error_message := fv_http_statusmessage(v_ws_statuscode);
            end if;
            raise_application_error(-20000 - v_ws_statuscode, v_rest_error_message);
        end if;

    exception
        when pck_pob_rest.e_request_auftrag_gesperrt then
            raise; -- ohne Loggen gemäß @ticket FTTH-4314
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params() || vc_body,
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end p_landlord_speichern;

--@progress 2024-07-16


/**  
 * Gibt den String für die Technologie zurück, die in der Tabelle STRAV.HAUS_DATEN an einem Objekt hinterlegt ist,
 * oder NULL wenn entweder keine Technologie gespeichert ist, die Technologie im Rahmen der FTTH-Factory
 * keinen definierten Wert besitzt oder keine entsprechende Zeile in HAUS_DATEN existiert
 *
 * @param pin_haus_lfd_nr   Hauslaufende Nummer des Objekts
 * @ticket FTTH-4077
 */
    function fv_ausbau_technologie (
        pin_haus_lfd_nr in varchar2
    ) return varchar2 is
        v_technologie tab_dienst_typ.dnsttp_bez%type;
    begin
        if pin_haus_lfd_nr is null then
            return null;
        end if;
        select
            fv_technologie(hsb_dnsttp_lfd_nr)
        into v_technologie
        from
            strav.haus_daten
        where
            haus_lfd_nr = pin_haus_lfd_nr;
      -- @quelle: OBJEKTINFO Seite 100, siehe Screenshot vom 12. Juli 2024 im @ticket FTTH-4077
        return v_technologie;
    exception
        when no_data_found then
            return null;
    end fv_ausbau_technologie;

/**
 * Refresht alle Materialized Views, die für den Glascontainer relevant sind.
 *
 * @usage Aufruf nächtlich durch Scheduler-Job "JOB_GLASCONTAINER_REFRESH_MV"
 */
    procedure p_refresh_materialized_views is

        logging         constant boolean := true; -- FALSE: Nur die Materialized View wird aktualisiert,
                                      -- TRUE:  Zusätzlich wird ein Info-Eintrag in die Tabelle LOGS geschrieben
        v_time_start    date;
        v_count         natural;
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'p_refresh_materialized_views';

        function fcl_params return logs.message%type is
        begin
            return null; -- diese procedure besitzt keine Parameter
        end fcl_params;
  -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------   
    begin
    -- Stand 2024-07-17: Derzeit ist zunächst nur eine einzige MV für den Glascontainer relevant.
        v_time_start := sysdate; -- sekundengenau reicht
        dbms_mview.refresh('MV_SIEBEL_KUNDENDATEN');
        if logging then
            select
                count(*)
            into v_count
            from
                mv_siebel_kundendaten;

            pck_logs.p_set_log_level_info;
            pck_logs.p_info(
                pic_message      => 'MV_SIEBEL_KUNDENDATEN aktualisiert: '
                               || ceil((sysdate - v_time_start) * 60 * 60 * 24)
                               || ' Sek.'
                               || ' / '
                               || v_count
                               || ' Zeilen',
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

        end if;

    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end p_refresh_materialized_views; 


/** 
 * Liest die Kontaktdaten eines Kunden aus Siebel anhand der Kundennummer ein. 
 *  
 * @param piv_kundennummer      [IN]   NR. des Kunden, dessen Daten gesucht werden 
 * @param pov_ap_rufnummer      [OUT]  Mobilrufnummer des primären Ansprechpartners 
 * @param pov_ap_email          [OUT]  E-Mail-Adresses des primären Ansprechpartners 
 *  
 * @throws  Alle Exceptions werden geworden. 
 *          Kein Fehlerlogging: Das aufrufende Programm entscheidet, ob 
 *          es einen Fehler loggen möchte (beispielsweise nicht, wenn  
 *          lediglich ein Tippfehler bei der Eingabe der Kundennummer auftritt) 
 * @usage  Auftragserfassung im Glascontainer: Persönliche Daten
 * @ticket FTTH-3711
 * @krakar

 * --@defect: Warum wurde das wieder auskommentiert? Durch ist @ticket FTTH-4227 entstanden.

  PROCEDURE "P_GET_SIEBEL_KONTAKTDATEN"
  ( 
    piv_kundennummer  IN VARCHAR2  
   ,pov_ap_email           OUT VARCHAR2 
   ,pov_ap_mobil_country   OUT VARCHAR2 
   ,pov_ap_mobil_onkz      OUT VARCHAR2 
   ,pov_ap_mobil_nr        OUT VARCHAR2 
   ,pov_update_customer_in_siebel       OUT VARCHAR2
  ) 
  IS    
  BEGIN 
    PCK_GLASCONTAINER_EXT.p_get_siebel_kontaktdaten( 
        piv_kundennummer       => piv_kundennummer 
       ,pov_ap_email           => pov_ap_email 
       ,pov_ap_mobil_country   => pov_ap_mobil_country 
       ,pov_ap_mobil_onkz      => pov_ap_mobil_onkz 
       ,pov_ap_mobil_nr        => pov_ap_mobil_nr 
       ,pov_update_customer_in_siebel       => pov_update_customer_in_siebel
    ); 

  END p_get_siebel_kontaktdaten; 
 */   

  -- @progress 2024-09-04

/**
 * Liest die Kontaktdaten eines SIEBEL-Kunden, falls diese gefunden werden konnten, in die Ausgabefelder.
 * Wurde kein entsprechender Datensatz gefunden, werden leere Felder zurückgeliefert
 *
 * @param piv_kundennummer [IN ]  Kundennummer in SIEBEL
 *
 * @ticket FTTH-3711
 * @defect @ticket FTTH-4227 
 */
    procedure p_get_siebel_kontaktdaten (
        piv_kundennummer            in varchar2
       ---
        ,
        pov_ap_email                out varchar2,
        pov_ap_mobil_laendervorwahl out varchar2 -- @todo //////////// im Ggs. zur obigen auskommentieren Function ist das hier NICHT die Vorwahl
        ,
        pov_ap_mobil_onkz           out varchar2,
        pov_ap_mobil_rufnummer      out varchar2
    ) is

        v_fehlertext    varchar2(32767);
        v_anrede        varchar2(255);

        -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'fv_siebel_kundendaten_uebernehmen';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_kundennummer', piv_kundennummer);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
        -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------         
    begin
        if piv_kundennummer is null then
            return;
        end if;
        select
            ap_email,
            ap_mobil_country,
            ap_mobil_onkz,
            ap_x_mobil_nr
        into
            pov_ap_email,
            pov_ap_mobil_laendervorwahl,
            pov_ap_mobil_onkz,
            pov_ap_mobil_rufnummer
        from
            v_siebel_kundendaten -- live-Zugriff erforderlich: nicht die MV verwenden!
        where
                kundennummer = piv_kundennummer
            and gueltig = 'Y'
            and rownum = 1 -- möglich, dass aus irgendeinem Grund mehrere, praktisch identische Datensätze gefunden werden
            ;

    exception
        when no_data_found then
            return;
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end p_get_siebel_kontaktdaten;

-- @progress 2024-09-10 

/**
 * Liefert die Bezeichnung für einen Dienst bzw. Technologie zurück, die für den Glascontainer derzeit relevant sind,
 * so wie der User es in der Maske angezeigt bekommen soll, also beispielsweise 
 * "G.fast" für "G_FAST" oder "FTTH BSA L2" anstatt "FTTH_BSA_L2".
 *
 * @param piv_technology  [IN ]  Typischerweise der Wert aus der Spalte FTTH_WS_SYNC_PREORDERS.technology,
 *                               aber auch bereits umgewandelte Schreibweisen davon werden korrekt erkannt.
 *
 * @example: Welche Technologien kommen im Preorderbuffer vor?
 * with pob_technologien as (
 *   select id, technology, row_number() over (partition by technology order by technology) as rn
 *     from pob
 * )
 * select id, technology
 *   from pob_technologien
 *  where rn = 1; 
 */
    function fv_technologie_display (
        piv_technology in varchar2
    ) return varchar2
        deterministic
    is
    begin
        return
            case upper(replace(
                trim(piv_technology),
                '_',
                ' '
            ))
                when 'FTTH' then
                    'FTTH'
                when 'G.FAST' then
                    'G.fast' -- bereits umgewandelt
                when 'G FAST' then
                    'G.fast' -- G_FAST kommt rein
                when 'FTTH BSA L2' then
                    'FTTH BSA L2'
                when 'FTTH BSA L2 DG' then
                    'FTTH BSA L2 DG'
                when 'VDSL2' then
                    'FTTB' -- eigentlich 'VDSL2'?
                else piv_technology
            end;
    end fv_technologie_display;



/**
 * Speichert einen anonymisierten Tracking-Eintrag im Glascontainer; Zweck ist die Messung der 
 * Aufrufe und Verwendungshäufigkeit bestimmter Optionen
 *
 * @param pin_app_id        [IN ]  :APP_ID im Workspace
 * @param pin_app_page_id   [IN ]  :APP_PAGE_ID der aufgerufenen Seite
 * @param pin_app_session   [IN ]  :APP_SESSION (diese ist anonym - sie wird nicht zur quantitativen Auswertung benötigt,
 *                                 könnte jedoch zukünftige Auswertungen ex post ermöglichen, beispielsweise Klick-Graphen)
 * @param piv_request       [IN ]  Beim Aufruf der Seite verwendeter Wert für :REQUEST 
 * @param piv_task          [IN ]  Üblicherweise nummerische Klammer, die einen bestimmten User-Vorgang kennzeichnet
 *                                 (z.B. einen Auftrag zu erfassen)
 * @param piv_scope         [IN ]  Kurzer String, den die Anwendung vorgibt, um bestimmte Vorgänge
 *                                 zu selektieren oder zu gruppieren. Inhalt ist nicht vorgegeben.
 * @param piv_extra         [IN ]  Beliebiger Payload zum Auswerten: Kommagetrennte Liste Key=Value; zur Vereinfachung
 *                                 darf links/rechts je ein verwaistes Komma stehen: ',HALLO=WELT,'
 *
 * @ticket FTTH-4003
 */
    procedure track_page (
        piv_app_id      in integer,
        piv_app_page_id in integer,
        pin_app_session in integer
    ----    
        ,
        piv_request     in varchar2 default null,
        piv_task        in varchar2 default null,
        piv_scope       in varchar2 default null,
        piv_extra       in varchar2 default null
    ) is

        pragma autonomous_transaction;
        v_tracking_id   pob_tracking.id%type;
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'track_page';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_app_id', piv_app_id);
            pck_format.p_add('piv_app_page_id', piv_app_page_id);
            pck_format.p_add('pin_app_session', pin_app_session);
            pck_format.p_add('piv_request', piv_request);
            pck_format.p_add('piv_scope', piv_scope);
            pck_format.p_add('piv_task', piv_task);
            pck_format.p_add('piv_extra', piv_extra);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
  -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        begin
            insert into pob_tracking (
                app_id,
                app_page_id,
                app_session,
                request,
                scope,
                task,
                extra
            ) values ( piv_app_id,
                       piv_app_page_id,
                       pin_app_session,
                       upper(substr(piv_request, 1, 100)),
                       upper(substr(piv_scope, 1, 100)),
                       to_number(piv_task default null on conversion error),
                       substr(piv_extra, 1, 4000) ) returning id into v_tracking_id;

            if piv_extra is not null then
                declare
                    v_key   varchar2(30);
                    v_val   varchar2(30);
                    v_extra pob_tracking_extra%rowtype;
                    sep     integer;
                begin
                    for s in (
                        select
                            column_value as key_val
                        from
                            table ( apex_string.split(
                                trim(both ',' from piv_extra),
                                ','
                            ) )
                    ) loop
                        sep := instr(s.key_val, '='); -- Trenner suchen (könnte auch ein Doppelpunkt sein, reine Vereinbarungssache)
                        v_key := trim(substr(
                            substr(s.key_val, 1, sep - 1),
                            1,
                            30
                        )); -- links vom Gleichheitszeichen, maximal 30 Zeichen
                        v_val := trim(substr(
                            substr(s.key_val, sep + 1),
                            1,
                            30
                        ));    -- rechts vom Gleichheitszeichen. Der Value hat gefälligst stets die Länge 1
                                                                         -- (z.B. 'N' für Neukunde)                                                               
                        case upper(v_key)
              -- jeder key kommt in EXTRA höchstens 1x vor, so dass diese einfache Zuweisungslogik valide ist:
                            when 'KUNDENSTATUS' then
                                v_extra.kundenstatus := v_val;
                            when 'DUBLETTEN_SIE' then
                                v_extra.dubletten_sie := to_number ( v_val default null on conversion error );
                                       -- falls APEX hier Mist liefert, sieht man das am Inhalt NULL (denn sonst stünde dort 0)
                            when 'DUBLETTEN_POB' then
                                v_extra.dubletten_pob := to_number ( v_val default null on conversion error );
                            when 'KUNDENDATEN' then
                                v_extra.kundendaten := substr(v_val, 1, 3); -- INP|SIE|POB. INP auch für den Fall, 
                                                                                    -- dass zuvor keine Dubletten angeboten wurden.
                            when 'VKZ' then
                                v_extra.vkz := regexp_replace(v_val, '[[:digit:]]'); -- VKZ darf nicht vollständig gespeichert werden: 3 Ziffern abschneiden
                            when 'BU' then
                                v_extra.bu := v_val; -- BU 
                            when 'EIGENTUEMER_DATEN' then
                                v_extra.eigentuemer_daten := v_val; -- BU 
                            else
                                null;
                        end case;

                    end loop;

                    v_extra.id := v_tracking_id; -- Zuordnung zum dazugehörigen Tracking-Eintrag (FK)
                    insert into pob_tracking_extra values v_extra;

                end;

            end if;

            commit;
        exception
            when others then
                pck_logs.p_error(
                    pic_message      => fcl_params(),
                    piv_routine_name => cv_routine_name,
                    piv_scope        => g_scope
                );

                raise; -- dann findet halt kein Tracking statt, die Lücke in der Statistik wird sowieso bemerkt
        end;
    end track_page;  

  -- @progress 2024-10-22

    procedure create_collection (
        piv_collection_name in varchar2,
        piv_app_id          in varchar2,
        piv_app_page_id     in varchar2,
        piv_app_session     in varchar2,
        piv_app_user        in varchar2
    ) is

        v_workspace_id   number;
        v_collection_sql varchar2(32767);
-- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name  constant logs.routine_name%type := 'create_collection';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_collection_name', piv_collection_name);
            pck_format.p_add('piv_app_id', piv_app_id);
            pck_format.p_add('piv_app_page_id', piv_app_page_id);
            pck_format.p_add('piv_app_session', piv_app_session);
            pck_format.p_add('piv_app_user', piv_app_user);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
-- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 

    begin
        v_workspace_id := apex_util.find_security_group_id(p_workspace => c_workspace_glascontainer);
        apex_util.set_security_group_id(p_security_group_id => v_workspace_id);
        apex_session.attach(
            p_app_id     => piv_app_id,
            p_page_id    => piv_app_page_id,
            p_session_id => piv_app_session
        );

        if apex_collection.collection_exists(piv_collection_name) then
            apex_collection.delete_collection(piv_collection_name);
        end if;
        case upper(piv_collection_name)
            when 'FEHLERSTATISTIK' then
                v_collection_sql := ' SELECT log_id, line, error_code, NULL, NULL
           , INSERTED, NULL, NULL, NULL, NULL
           , scope, user_name, module, action, routine_name
           , SUBSTR(error_message, 1, 4000), SUBSTR(message, 1, 4000)
        FROM LOGS
       WHERE (scope IN (''POB'', ''GLASCONTAINER'')
          OR module LIKE ''ROMA_MAIN/APEX:APP 2022%'')
         AND inserted >= ADD_MONTHS(TRUNC(SYSDATE), -1)
         AND ERROR_CODE IS NOT NULL
         AND DEBUG_LEVEL >= 30
       ORDER BY log_id DESC';
            else
                null;
        end case;

        apex_collection.create_collection_from_queryb2(
            p_collection_name => piv_collection_name,
            p_query           => v_collection_sql
        );
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end create_collection;

-- @progress 2024-11-26

/**
 * Liefert eine kommaseparierte Liste mit den Keys der Stornogründe zurück, für die
 * ein Kunde keine Bestätigungsmail erhält.
 *
 * @ticket FTTH-4270
 * @ticket FTTH-4719: Neuer Stornogrund wird automatisch hier berücksichtigt, sobald er nächtlich synchronsiert ist.
 * @example SELECT PCK_GLASCONTAINER.FV_STORNOGRUENDE_OHNE_MAIL FROM DUAL; -- DUPLICATE,ORDER_RESUBMITTED,CLEARING_WB_ABBM 
 */
    function fv_stornogruende_ohne_mail return varchar2 is

        v_liste         varchar2(4000);
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'fv_stornogruende_ohne_mail';

        function fcl_params return logs.message%type is
        begin
            return null; -- diese function besitzt keine Parameter
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 

    begin
    -- Die Liste wird von der Dynamic Action benötigt, welche auf den Change-Event
    -- der Radio Group P20_STORNIERUNGSGRUND reagiert, und wird 1 x pro User-Session
    -- in das Application Item G_STORNOGRUENDE_OHNE_MAIL eingelesen
        select
            listagg(key, ',') within group(
            order by
                key
            )
        into v_liste
        from
            ftth_ws_sync_stornogruende
        where
            notify_customer = 'false';

        return v_liste;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end fv_stornogruende_ohne_mail;

-- @progress 2024-11-27

/**
 * Liest die Account-ID für eine Kundennummer aus der Siebel-View aus.
 * Wenn keine gefunden wird, kommt NULL zurück.
 */
    function fv_siebel_account_id (
        piv_kundennummer in varchar2
    ) return varchar2 is
        v_siebel_account_id varchar2(128); -- Laut Specs genügt Länge 15, das ist aber zu klein! z.B. account-1343941767
                                        -- @ticket FTTH-4533
    begin
  /*  @deprecated vor Inbetriebnahme :-)
    -- vorrangig aus den POB-Synchrondaten auslesen
    SELECT max(account_id)
      INTO v_siebel_account_id
      FROM FTTH_WS_SYNC_PREORDERS
     WHERE customernumber = piv_kundennummer;
  */  
    -- In der Siebel-View nachschauen, die GLOABL_ID dort ist identisch mit der "accountId" im Preorder-Buffer:
        if v_siebel_account_id is null then
            select
                max(global_id)
            into v_siebel_account_id
            from
                v_siebel_kundendaten
            where
                kundennummer = piv_kundennummer;

        end if;

        return v_siebel_account_id;
    end;

/**
 * Gibt das href-Attribut (https://...) für einen Link zur Siebel-Kundenmaske zurück
 * 
 * @param piv_account_id   [IN]  Der Siebel-Link verwendet die Account-ID, nicht die Kundennummer.
 * @param piv_kundennummer [IN]  (optional) Falls die account_id nicht gesetzt werden konnte, weil sie unbekannt ist,
 *                               dann versucht diese Funktion die accountId anhand dieser Kundennummer selbst herauszufinden
 * @param piv_umgebung     [IN]  (optional) Wert für den Datenbanknamen (NMCE|NMCE3|NMCS|NMCU|NMCX|NMC).
 *                               Falls leer, ermittelt die Funktion diesen Wert selbst
 * 
 * @ticket FTTH-4470
 * @unittest SELECT * FROM TABLE(ut.run('UT_GLASCONTAINER', a_tags => 'fv_link_siebel_kundenmaske'));
 *
 * @example
 * SELECT PCK_GLASCONTAINER.fv_href_siebel_kundenmaske(
 *   piv_account_id    => NULL
 * , piv_kundennummer  => 14012883
 * ) FROM DUAL;
 */
    function fv_href_siebel_kundenmaske (
        piv_account_id   in varchar2,
        piv_kundennummer in varchar2 default null,
        piv_umgebung     in varchar2 default null
    ) return varchar2
        deterministic
    is
        v_account_id  varchar2(100);
        l_siebel_link varchar2(5000 char);
    begin
        l_siebel_link := core.pck_params.fv_wert1(
            piv_satzart => 'LINK',
            piv_key1    => 'PREORDERBUFFER',
            piv_key2    => 'BASE_URL_SIEBEL'
        );
    -- Versuchen, eine fehlende Account-ID zu ermitteln:
        v_account_id := coalesce(piv_account_id,
                                 fv_siebel_account_id(piv_kundennummer));

    -- Kein Link ohne Infos:
        if v_account_id is null then
            return null;
        end if;
        return l_siebel_link || v_account_id;
    end fv_href_siebel_kundenmaske;


/**
 * Gibt den vollständigen Link (<a href="https://...">Kundennummer</a>) zur Siebel-Kundenmaske zurück
 * 
 * @param piv_kundennummer [IN]  Im Link dargestellter Text (üblicherweise nur die Kundennummer)
 * @param piv_account_id   [IN]  Der Siebel-Link erwartet die Account-ID, nicht die Kundennummer. Wenn diese nicht gesetzt
 *                               wird, dann versuch diese Funktion selbst, die Account-ID zu ermitteln.
 * @param piv_target       [IN]  (optional) Wenn gesetzt, dann üblicherweise mit dem Wert '_blank', dann wird
 *                                          das Link-Ziel in einem neuen Browser-Tab geöffnet 
 * @param piv_html_id      [IN]  (optional) Gewünschtes Attribut "id=..." für das <a>-Tag
 * @param piv_css_class    [IN]  (optional) Gewünschtes Attribut "class=..." für das <a>-Tag
 * @param piv_title        [IN]  (optional) Gewünschter Text für das title-Attribut im Link (das beim Hovern erscheint)
 * @param piv_aria_label   [IN]  (optional) Gewünschter Text für das aria-label-Attribut im Link (für Barrierefreiheit/Screenreader)
 * @param piv_umgebung     [IN]  (optional) Wert für den Datenbanknamen (NMCE|NMCE3|NMCS|NMCU|NMCX|NMC).
 *                               Falls leer, ermittelt die Funktion diesen Wert selbst
 * 
 * @ticket FTTH-4470
 * @unit_test SELECT * FROM TABLE(ut.run('UT_GLASCONTAINER', a_tags => 'fv_link_siebel_kundenmaske'));
 */
    function fv_link_siebel_kundenmaske (
        piv_kundennummer in varchar2,
        piv_account_id   in varchar2,
        piv_target       in varchar2 default null,
        piv_html_id      in varchar2 default null,
        piv_css_class    in varchar2 default null,
        piv_title        in varchar2 default null,
        piv_aria_label   in varchar2 default null,
        piv_umgebung     in varchar2 default null
    ) return varchar2
        deterministic
    is

        v_account_id    varchar2(100);
        v_href          varchar2(4000);
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'fv_link_siebel_kundenmaske';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_kundennummer', piv_kundennummer);
            pck_format.p_add('piv_account_id', piv_account_id);
            pck_format.p_add('piv_target', piv_target);
            pck_format.p_add('piv_html_id', piv_html_id);
            pck_format.p_add('piv_css_class', piv_css_class);
            pck_format.p_add('piv_title', piv_title);
            pck_format.p_add('piv_aria_label', piv_aria_label);
            pck_format.p_add('piv_umgebung', piv_umgebung);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
      -- Shortcut: Kein Link ohne Angaben
        if piv_kundennummer is null then
            return null;
        end if;

      -- Versuchen, eine fehlende Account-ID zu ermitteln:
        v_account_id := coalesce(piv_account_id,
                                 fv_siebel_account_id(piv_kundennummer));
        if v_account_id is not null then
            v_href := fv_href_siebel_kundenmaske(
                piv_account_id   => v_account_id,
                piv_kundennummer => piv_kundennummer,
                piv_umgebung     => piv_umgebung
            );
        end if;
        -- //// Prüfen, ob irgendwo eine generische Funktion existiert, die das gleiche macht,
        -- ansonsten selber zur Verfügung stellen
        return
            case
                when v_href is null then
                    '<span'
                else '<a href="'
                     || v_href
                     || '"'
            end
            ||
            case
                when piv_target is not null then
                    ' target="'
                    || apex_escape.html_attribute(piv_target)
                    || '"'
            end
            ||
            case
                when piv_html_id is not null then
                    ' id="'
                    || apex_escape.html_attribute(piv_html_id)
                    || '"'
            end
            ||
            case
                when piv_css_class is not null then
                    ' class="'
                    || apex_escape.html_attribute(piv_css_class)
                    || '"'
            end
            ||
            case
                when piv_title is not null then
                    ' title="'
                    || apex_escape.html_attribute(piv_title)
                    || '"'
            end
            ||
            case
                when piv_aria_label is not null then
                    ' aria-label="'
                    || apex_escape.html_attribute(piv_aria_label)
                    || '"'
            end
            || '>'
            || apex_escape.html(piv_kundennummer)
            || case
            when v_href is null then
                '</span>'
            else '</a>'
        end;

    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end fv_link_siebel_kundenmaske;



/**
 * Gibt einen HTML-Hinweistext zurück, wann die Auftragsliste zuletzt synchronisiert wurde,
 * oder NULL wenn dies nicht festgestellt werden konnte (zum Beispiel nach einem
 * Neuaufbau der Datenbank)
 *
 * @usage  Diese Funktion muss aus einem APEX-Kontext aufgerufen werden,
 *         oder man setzt die g_security_group_id.
 */
    function fv_html_pob_zuletzt_synchronisiert return varchar2 is
        v_last_sync timestamp;
    begin
        v_last_sync := apex_rest_source_sync.get_last_sync_timestamp(pck_glascontainer.c_ws_static_id_preorders);
        return
            case
                when v_last_sync is not null then
                    'Die Auftragsliste wurde zuletzt synchronisiert am <br/>'
                    || trim(to_char(v_last_sync, 'Day'))
                    || ', '
                    || to_char(v_last_sync, 'DD.MM.YYYY')
                    || ' um '
                    || to_char(v_last_sync, 'HH24:MI')
                    || ' Uhr.'
            end;

    end fv_html_pob_zuletzt_synchronisiert;

-- @progress 2025-01-15

/**
 * Aktualisiert die STRAV-Adresse zu einer HAUS_LFD_NR in der Puffertabelle POB_ADRESSEN.
 * Wenn keine Adresse gefunden werden konnte, wird ein leerer Eintrag in POB_ADRESSEN erzeugt.
 *
 * @param  pin_haus_lfd_nr  [IN ]  HAUS_LFD_NR der Installationsadresse, die persistiert werden soll. Wenn diese leer ist,
 *                                 bricht die Prozedur ohne Fehlermeldung ab
 * @param  piv_uuid         [IN ]  (optional) Wird nur zum Logging im Fehlerfall verwendet
 *
 * @throws Alle Exceptions werden geworfen, aber nicht geloggt (dies passiert ggf. im aufrufenden Programm/Trigger)
 *
 * @ticket FTTH-4625
 */
    procedure p_adresse_synchronisieren (
        pin_haus_lfd_nr in pob_adressen.haus_lfd_nr%type
    ) is
    begin  
    -- Plausi Shortcut:
        if pin_haus_lfd_nr is null then
            return;
        end if;

  -- Speicherung der Installationsadresse, weil die live-Ermittlung der Adresse aus der View V_ADRESSEN
  -- den Report in der Auftragsliste um den Faktor 50 verlangsamt:
        merge into pob_adressen p
        using (
            select
                haus_lfd_nr,
                str,
                hnr_kompl,
                gebaeudeteil_name,
                cast(plz as varchar2(5)) as plz -- Postleitzahlen sind in V_ADRESSEN leider als NUMBER gespeichert 
                ,
                ort_kompl,
                adresse_kompl
            from
                v_adressen
            where
                haus_lfd_nr = pin_haus_lfd_nr
        ) adr on ( p.haus_lfd_nr = adr.haus_lfd_nr )
        when matched then update
        set p.str = adr.str,
            p.hnr_kompl = adr.hnr_kompl,
            p.gebaeudeteil_name = adr.gebaeudeteil_name,
            p.plz = adr.plz,
            p.ort_kompl = adr.ort_kompl,
            p.adresse_kompl = adr.adresse_kompl,
            p.aktualisiert = sysdate
        when not matched then
        insert (
            p.haus_lfd_nr,
            p.str,
            p.hnr_kompl,
            p.plz,
            p.ort_kompl,
            p.adresse_kompl,
            p.aktualisiert )
        values
            ( adr.haus_lfd_nr,
              adr.str,
              adr.hnr_kompl,
              adr.plz,
              adr.ort_kompl,
              adr.adresse_kompl,
              sysdate );
    -- Prüfen, ob erfolgreich:
        if sql%rowcount = 0 then
      -- Wenn die STRAV hierzu keine Adresse hat (was hoffentlich nur in der Entwicklungsumgebung vorkommt),
      -- dann einen leeren Eintrag in der Puffertabelle erzeugen, damit in der Auftragsübersicht 
      -- kein LEFT JOIN zur Adresse nötig ist:
            merge into pob_adressen
            using (
                select
                    pin_haus_lfd_nr as haus_lfd_nr
                from
                    dual
            ) leer on ( leer.haus_lfd_nr = pob_adressen.haus_lfd_nr )
            when matched then update
            set aktualisiert = sysdate
            when not matched then
            insert (
                haus_lfd_nr,
                aktualisiert )
            values
                ( leer.haus_lfd_nr,
                  sysdate );
      -- @ticket FTTH-4641: Loggen, dass nichts gefunden wurde
            pck_logs.p_error(
                pic_message      => 'Installationsadresse nicht in STRAV gefunden:'
                               || ' SELECT * FROM STRAV.V_ADRESSEN WHERE HAUS_LFD_NR='
                               || pin_haus_lfd_nr,
                piv_routine_name => 'FTTH_WS_SYNC_PREORDERS_BIU',
                piv_scope        => g_scope -- "POB"
            );
       -- Fehlende Adressen können auch hiermit gefunden werden:
       -- SELECT * FROM POB_ADRESSEN WHERE ADRESSE_KOMPL IS NULL

        end if;

    end p_adresse_synchronisieren;


/**
 * Gibt Adressfelder zu einer HAUS_LFD_NR zurück: Vorranging aus der Tabelle POB_ADRESSEN;
 * wenn dort nichts gefunden wird: aus der STRAV.
 *
 * @throws  Bei NO_DATA_FOUND werden leere Felder zurückgegeben. Alle sonstigen Fehler werden geraised, aber nicht geloggt.
 */
    procedure p_get_adresse (
        pin_haus_lfd_nr   in pob_adressen.haus_lfd_nr%type,
        pov_str           out pob_adressen.str%type,
        pov_hnr_kompl     out pob_adressen.hnr_kompl%type,
        pov_gebaeudeteil  out pob_adressen.gebaeudeteil_name%type,
        pov_plz           out pob_adressen.plz%type,
        pov_ort_kompl     out pob_adressen.ort_kompl%type,
        pov_adresse_kompl out pob_adressen.adresse_kompl%type
    ) is
    begin
        << pob_adressen >> begin
            select
                str,
                hnr_kompl,
                gebaeudeteil_name,
                plz,
                ort_kompl,
                adresse_kompl
            into
                pov_str,
                pov_hnr_kompl,
                pov_gebaeudeteil,
                pov_plz,
                pov_ort_kompl,
                pov_adresse_kompl
            from
                pob_adressen
            where
                haus_lfd_nr = pin_haus_lfd_nr;

        exception
            when no_data_found then
                << strav >> begin
                    pck_glascontainer_ext.p_get_strav_adresse(
                        pin_haus_lfd_nr   => pin_haus_lfd_nr,
                        pov_str           => pov_str,
                        pov_hnr_kompl     => pov_hnr_kompl,
                        pov_gebaeudeteil  => pov_gebaeudeteil,
                        pov_plz           => pov_plz,
                        pov_ort_kompl     => pov_ort_kompl,
                        pov_adresse_kompl => pov_adresse_kompl
                    );
                exception
                    when no_data_found then
                        null;
                end strav;
        end pob_adressen;
    end p_get_adresse; 

-- @progress 2025-02-25

/**
 * Gibt einen Fehlertext zurück, wenn die UUID nicht existiert
 * oder aus anderen Gründen nicht abrufbar ist
 *
 * piv_uuid   [IN]  ID des Datensatzes im Preorderbuffer
 *
 * @usage  Glascontainer #P20: Entscheidet darüber, ob bei UUID-Direkteingabe
 *         zur Auftragsansicht gesprungen wird
 *
 * @ut     SELECT * FROM TABLE(ut.run('UT_GLASCONTAINER', a_tags => 'fv_uuid_existiert'));
 */
    function fv_uuid_existiert (
        piv_uuid in varchar2
    ) return varchar2 is
        v_uuid ftth_ws_sync_preorders.id%type;
    begin
        if trim(piv_uuid) is null then
            return 'UUID ist leer';
        end if;
        select
            max(id)
        into v_uuid
        from
            ftth_ws_sync_preorders
        where
            id = piv_uuid;

        if v_uuid is null then
            return 'UUID "'
                   || piv_uuid
                   || '" existiert nicht';
        end if;
        return null;
    end fv_uuid_existiert;   

-- @progress 2025-04-02

/** 
 * APEX-Validierung für das Feld "VKZ" im Rahmen der Vorbestellung
 * 
 * @param piv_value    [IN ] Aktueller Wert des Items 
 * @param pib_null     [IN ] optional - Auf TRUE setzen, wenn ein leerer Wert gültig ist 
 * @param piv_feldname [IN ] optional - Falls diese Prüfung für unterschiedliche Felder herangezogen wird, 
 *                           sollte hier explizit das Formular-Label angegeben werden 
 * @return Fehlertext wenn die Prüfung fehlschlägt, ansonsten NULL (= Prüfung erfolgreich) 
 * @ticket FTTH-5048
 *
 * @unittest
 * SELECT * FROM ROMA_MAIN.UT.RUN('UT_GLASCONTAINER', a_tags => 'CHK_VKZ');  
 */
    function chk_vkz (
        piv_value    in varchar2,
        pib_null     in boolean default false,
        piv_feldname in varchar2 default null
    ) return varchar2 is
        ecowbs constant v_siebel_vkz.vkz%type := 'ECOWBS';
    begin
        if piv_value like ecowbs || '%' then
            return 'VKZ '
                   || ecowbs
                   || '... ist hier nicht erlaubt';
        end if;

        return fv_validierung(
            piv_feldname  => coalesce(piv_feldname, 'VKZ'),
            piv_value     => piv_value,
            pib_condition => fb_is_valid_vkz(piv_value),
            pib_null      => pib_null
        );

    end;

-- @progress 2025-04-02

 /** 
 * Prüft, ob ein Auftrag im Glascontainer stoniert werden darf
 * Die Funktion liefert eine Begründung(v_errorstring), wenn keine Stornierung möglich ist oder null, wen eine Stornierung zulässig ist
 * 
 * @param: piv_uuid(VARCHAR2)
 *
 * @return: v_errorstring(VARCHAR2) 
 *
 * @Entscheidungslogik: 
 * Fall 1: keine connectivity_id zur UUID vorhanden -> null (Storno erlaubt)
 * Fall 2: connectivity_id vorhanden, aber es gibt keine QEB mit Code 0000 -> "keine QEB"
 * Fall 3: connectivity_id und QEB mit Code 0000 vorhanden: null (Storno erlaubt)
 *
 * @ticket FTTH-5163
 */
    function fv_can_cancel (
        piv_uuid in varchar2
    ) return varchar2 is

        v_errorstring   varchar2(4000) := null;
        l_count         number;

-- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := $$plsql_unit
                                                           || '.'
                                                           || 'fv_can_cancel';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_uuid', piv_uuid);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
-- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 

    begin
  -- Shortcut: Kein UUID angegeben
        if piv_uuid is null then
            return null;
        end if;

  -- Prüfe, ob eine CONNECTIVITY_ID vorhanden ist in Synch Tabelle
        select
            count(1)
        into l_count
        from
            ftth_ws_sync_preorders pob
        where
                id = piv_uuid
            and connectivity_id is not null; 

  -- Bedingung 1: connectivity_id ist nicht vorhanden -> Bearbeitung ist erlaubt
        if l_count = 0 then
            return v_errorstring;
        end if;

  -- Bedingung 2: QEB mit Error Code OOOO muss vorliegen
        select
            count(1)
        into l_count
        from
            romaintinf.v_wholebuy_event
        where
                order_id = piv_uuid
            and upper(type) = 'QEB' -- Typ
            and code = '0000'; -- Error Code    

  -- keine QEB vorhanden -> Bearbeitung ist nicht erlaubt
        if l_count = 0 then
            v_errorstring := 'keine QEB vorhanden';
        end if;
        return v_errorstring;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name
            );
            raise;
    end fv_can_cancel;

-- @progress 2025-07-07

 /** 
 * Prüft, ob ein bestimmter Meldungscode vorhanden ist
 * 
 * @param: piv_uuid(FTTH_WS_SYNC_PREORDERS.ID%TYPE)
 * @param: piv_code(VARCHAR2)
 * @param: piv_type(VARCHAR2)
 *
 * @return: boolean 
 *
 * @ticket FTTH-5140
 */
    function fb_has_melde_code (
        piv_uuid in ftth_ws_sync_preorders.id%type,
        piv_code in varchar2,
        piv_type in varchar2
    ) return boolean as

        l_count         number;

-- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := $$plsql_unit
                                                           || '.'
                                                           || 'fb_has_melde_code';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_uuid', piv_uuid);
            pck_format.p_add('piv_code', piv_code);
            pck_format.p_add('piv_type', piv_type);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
-- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 

-- Prüft, ob ein bestimmter Meldungscode vorhanden ist
    begin
        select
            count(1)
        into l_count
        from
            romaintinf.v_wholebuy_event
        where
                order_id = piv_uuid
            and code = piv_code
            and type = piv_type;

        return l_count > 0;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name
            );
            raise;
    end fb_has_melde_code;

 /** 
 * Liefert das VLT des Events zurück
 * 
 * @param: piv_uuid(FTTH_WS_SYNC_PREORDERS.ID%TYPE)
 * @param: piv_code(VARCHAR2)
 * @param: piv_type(VARCHAR2)
 *
 * @return: pod_availability_date(DATE) 
 *
 * @ticket FTTH-5140
 */
    function fd_has_availability_date (
        piv_uuid in ftth_ws_sync_preorders.id%type,
        piv_code in varchar2,
        piv_type in varchar2
    ) return date as

        pod_availability_date date;

-- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name       constant logs.routine_name%type := $$plsql_unit
                                                           || '.'
                                                           || 'fd_has_availability_date';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_uuid', piv_uuid);
            pck_format.p_add('piv_code', piv_code);
            pck_format.p_add('piv_type', piv_type);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
-- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 

-- Liefert das Verfügbarkeitsdatum des gegebenen Events zurück
    begin
        select
            availability_date
        into pod_availability_date
        from
            romaintinf.v_wholebuy_event
        where
                code = piv_code
            and type = piv_type
            and order_id = piv_uuid
            and rownum = 1
        order by
            event_id desc;

        return pod_availability_date;
    exception
        when no_data_found then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            return null;
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name
            );
            raise;
    end fd_has_availability_date;

 /** 
 * Gibt den zur gegebenen Meldung passenden Hinweistext zurück
 * 
 * @param: piv_uuid(FTTH_WS_SYNC_PREORDERS.ID%TYPE)
 * @param: piv_wholebuy_partner(VARCHAR2)
 * @param: pid_availability_date (DATE)
 *
 * @return: VARCHAR2
 *
 * @ticket FTTH-5140
 */
    function fv_stornokosten (
        piv_uuid              in ftth_ws_sync_preorders.id%type,
        piv_wholebuy_partner  in varchar2,
        pid_availability_date in date
    ) return varchar2 is

        cv_routine_name      constant logs.routine_name%type := 'fv_stornokosten';
        lv_ret               varchar2(500 char);
        ld_availability_date date;
        lv_hinweis_mit_vlt   varchar2(500 char) := 'ACHTUNG! Den Kunden bitte über Kostenpflicht informieren (VLT am '
                                                 || pid_availability_date
                                                 || ').';
        lv_hinweis_ohne_vlt  varchar2(500 char) := 'ACHTUNG! Den Kunden bitte über Kostenpflicht informieren.';

    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_uuid', piv_uuid);
            pck_format.p_add('piv_wholebuy_partner', piv_wholebuy_partner);
            pck_format.p_add('pid_availability_date', pid_availability_date);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
-- Hilfsroutine zur Fehlerbehandlung------------------------------------------
    begin
        if piv_wholebuy_partner = enum_wholebuy_key_telekom then
      -- Fall 2: Telekom mit Meldung ABM/0011
            ld_availability_date := fd_has_availability_date(
                piv_uuid => piv_uuid,
                piv_code => '0011',
                piv_type => 'ABM'
            );
        -- Fall 1: Prüfung, ob ein VLT innerhalb der 7 Tagen vorhanden ist
            if
                ld_availability_date - trunc(sysdate) <= 7
                and ld_availability_date is not null
            then
                lv_ret := lv_hinweis_mit_vlt;
            end if;
        -- Fall 2: Telekom mit der Meldung ZWM/1508
            if fb_has_melde_code(
                piv_uuid => piv_uuid,
                piv_code => '1508',
                piv_type => 'ZWM'
            ) then
                lv_ret := lv_hinweis_ohne_vlt;
            end if;

        elsif piv_wholebuy_partner = enum_wholebuy_key_deutsche_glasfaser then
        -- Fall 3: Deutsche Glasfaser mit Meldung TAM/6022
            if fb_has_melde_code(
                piv_uuid => piv_uuid,
                piv_code => '6022',
                piv_type => 'TAM'
            )
            or fb_has_melde_code(
                piv_uuid => piv_uuid,
                piv_code => '1574',
                piv_type => 'VZM'
            ) then
                lv_ret := lv_hinweis_ohne_vlt;
            end if;
        end if;
    -- Immer einen Wert zurueck geben (Default ist null)
        return lv_ret;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end fv_stornokosten;

    function fj_provider_change (
        pi_change_flag          in number    -- 1= Update, 0= Delete 
        ,
        pi_changed_by           in varchar2  --changedBy
        ,
        pi_current_provider     in varchar2  --providerChange.currentProvider
        ,
        pi_keep_cur_line_nr     in varchar2  --providerChange.keepCurrentLandlineNumber
        ,
        pi_phon_country_code    in varchar2  --providerChange.landlinePhoneNumber.countryCode
        ,
        pi_phon_area_code       in varchar2  --providerChange.landlinePhoneNumber.areaCode
        ,
        pi_phon_number          in varchar2  --providerChange.landlinePhoneNumber.number
        ,
        pi_contr_own_salutation in varchar2  --contractOwnerSalutation
        ,
        pi_contr_own_first_name in varchar2  --contractOwnerName.first
        ,
        pi_contr_own_last_name  in varchar2  --contractOwnerName.last
        ,
        pi_abw_anschlussinhaber in varchar2
    ) return clob as

        vj_main                json_object_t := new json_object_t(c_empty_json);
        vj_provider_change     json_object_t := new json_object_t(c_empty_json);
        vj_landline_phone_num  json_object_t := new json_object_t(c_empty_json);
        vj_contract_owner_name json_object_t := new json_object_t(c_empty_json);
        l_null                 varchar2(50 char);

      -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name        constant logs.routine_name%type := 'fj_provider_change';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pi_change_flag', pi_change_flag);
            pck_format.p_add('pi_changed_by', pi_changed_by);
            pck_format.p_add('pi_current_provider', pi_current_provider);
            pck_format.p_add('pi_keep_cur_line_nr', pi_keep_cur_line_nr);
            pck_format.p_add('pi_phon_country_code', pi_phon_country_code);
            pck_format.p_add('pi_phon_area_code', pi_phon_area_code);
            pck_format.p_add('pi_phon_number', pi_phon_number);
            pck_format.p_add('pi_contr_own_salutation', pi_contr_own_salutation);
            pck_format.p_add('pi_contr_own_first_name', pi_contr_own_first_name);
            pck_format.p_add('pi_contr_own_last_name', pi_contr_own_last_name);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;

    begin
        if pi_change_flag = 0 then
            -- Changeflag = , dann Body so bauen, dass geloescht wird
            vj_main.put('changedBy', pi_changed_by);
            vj_main.put('providerChange', l_null);
        else
            if pi_changed_by is not null then
                vj_main.put('changedBy', pi_changed_by);
            end if;
            vj_provider_change.put('currentProvider', pi_current_provider);
            vj_provider_change.put('keepCurrentLandlineNumber', pi_keep_cur_line_nr);

            -- Telefonnummer
            if pi_keep_cur_line_nr = 'true' then
                vj_landline_phone_num.put('countryCode', pi_phon_country_code);
                vj_landline_phone_num.put('areaCode', pi_phon_area_code);
                vj_landline_phone_num.put('number', pi_phon_number);
                vj_provider_change.put('landlinePhoneNumber', vj_landline_phone_num);
            end if;

            if pi_abw_anschlussinhaber = 1 then
                vj_provider_change.put('contractOwnerSalutation', pi_contr_own_salutation);
                vj_contract_owner_name.put('first', pi_contr_own_first_name);
                vj_contract_owner_name.put('last', pi_contr_own_last_name);
                vj_provider_change.put('contractOwnerName', vj_contract_owner_name);
            end if;

            vj_main.put('providerChange', vj_provider_change);
        end if;

        return vj_main.to_clob;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end fj_provider_change;

    procedure p_change_provider (
        pi_uuid_id                      in varchar2,
        pi_providerwechsel              in number,
        pi_app_user                     in varchar2,
        pi_providerw_aktueller_anbieter in varchar2,
        pi_providerw_nummer_behalten    in varchar2,
        pi_providerw_laendervorwahl     in varchar2,
        pi_providerw_vorwahl            in varchar2,
        pi_providerw_telefon            in varchar2,
        pi_providerw_anmeldung_anrede   in varchar2,
        pi_providerw_anmeldung_vorname  in varchar2,
        pi_providerw_anmeldung_nachname in varchar2,
        pi_abw_anschlussinhaber         in varchar2
    ) as

        l_body          clob;
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'p_change_provider';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pi_uuid_id', pi_uuid_id);
            pck_format.p_add('pi_providerwechsel', pi_providerwechsel);
            pck_format.p_add('pi_app_user', pi_app_user);
            pck_format.p_add('pi_providerw_aktueller_anbieter', pi_providerw_aktueller_anbieter);
            pck_format.p_add('pi_providerw_nummer_behalten', pi_providerw_nummer_behalten);
            pck_format.p_add('pi_providerw_laendervorwahl', pi_providerw_laendervorwahl);
            pck_format.p_add('pi_providerw_vorwahl', pi_providerw_vorwahl);
            pck_format.p_add('pi_providerw_telefon', pi_providerw_telefon);
            pck_format.p_add('pi_providerw_anmeldung_anrede', pi_providerw_anmeldung_anrede);
            pck_format.p_add('pi_providerw_anmeldung_vorname', pi_providerw_anmeldung_vorname);
            pck_format.p_add('pi_providerw_anmeldung_nachname', pi_providerw_anmeldung_nachname);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;

    begin
        l_body := fj_provider_change(
            pi_change_flag          => pi_providerwechsel,
            pi_changed_by           => nvl(pi_app_user, user),
            pi_current_provider     => pi_providerw_aktueller_anbieter,
            pi_keep_cur_line_nr     => pi_providerw_nummer_behalten,
            pi_phon_country_code    => pi_providerw_laendervorwahl,
            pi_phon_area_code       => pi_providerw_vorwahl,
            pi_phon_number          => pi_providerw_telefon,
            pi_contr_own_salutation => pi_providerw_anmeldung_anrede,
            pi_contr_own_first_name => pi_providerw_anmeldung_vorname,
            pi_contr_own_last_name  => pi_providerw_anmeldung_nachname,
            pi_abw_anschlussinhaber => pi_abw_anschlussinhaber
        );

        pck_pob_rest.p_provider_change_post(
            pic_body     => l_body,
            piv_username => pi_app_user,
            piv_uuid     => pi_uuid_id
        );
        -- Fehler wird in pck_pob_rest.p_provider_change_post ausgegeben
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end p_change_provider;

    function f_get_vorwahl (
        pi_haus_lfd_nr in number
    ) return varchar2 as

        l_vorwahl       varchar2(50 char);
        -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'f_get_vorwahl';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pi_uuid_id', pi_haus_lfd_nr);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; --

    begin
        select
            '0'
            || ltrim(a.onkz, '0')
        into l_vorwahl
        from
            v_adressen a
        where
            a.haus_lfd_nr = pi_haus_lfd_nr;

        return l_vorwahl;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            return null;
    end f_get_vorwahl;

end pck_glascontainer;
/


-- sqlcl_snapshot {"hash":"657a3cb724f2b774898f30186646735d0dbc901d","type":"PACKAGE_BODY","name":"PCK_GLASCONTAINER","schemaName":"ROMA_MAIN","sxml":""}