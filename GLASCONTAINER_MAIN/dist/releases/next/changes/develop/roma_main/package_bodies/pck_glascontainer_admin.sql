-- liquibase formatted sql
-- changeset ROMA_MAIN:1768480983371 stripComments:false logicalFilePath:develop/roma_main/package_bodies/pck_glascontainer_admin.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot GLASCONTAINER_MAIN/src/database/roma_main/package_bodies/pck_glascontainer_admin.sql:null:d0d5202f21e197cdc3b18a7a8412bad19563bfe0:create

create or replace package body roma_main.pck_glascontainer_admin as 

/**
 * Package dient der Durchführung und Aufzeichnung von konfigurativen Aktionen in der APEX-Applikation "Glascontainer",
 * die von Usern mit Administrator-Rollen vorgenommen werden.
 *
 * @creation 2025-04-23
 * @author   WISAND  Andreas Wismann  wismann@when-others.com
 */
 
 
  -- Im Unterschied zu "VERSION" in der Specification ist die Version im PACKAGE BODY 
  -- meist höher (die informelle APEX-Abfrage auf Seite 2022:10050 ermittelt den  
  -- höheren der beiden Werte über die FUNCTION get_body_version) 
    body_version          constant varchar2(30) := '2025-04-30 1147'; -- YYYY-MM-DD HHMM

    g_scope               constant logs.scope%type := 'POB';
    db_name               constant varchar2(30) := core.pck_env.fv_db_name;
    c_plausi_error_number constant integer := -20002;
    e_plausi_error exception;
    pragma exception_init ( e_plausi_error,
    c_plausi_error_number ); 
  
  
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
 * Zeichnet eine Benutzeraktion in der Audit-Tabelle des Glascontainers als autonome Transaktion auf
 * 
 * @param piv_username  [IN]  Benutzername des Users, der die Änderung durchgeführt hat
 * @param piv_aktion    [IN]  Art der Änderung, z.B. "Umstellung Webservice-URL"
 * @param piv_parameter [IN]  Optionale Parameter, z.B. "https://api-e.dss.svc.netcologne.intern" im Falle einer URL-Umstellung
 * @param piv_status    [IN]  Üblicherweise leer. Bei einem Fehler kann hier die ORA-Fehlernummer eingetragen werden.
 */
    procedure log_aktion (
        piv_username  in varchar2,
        piv_aktion    in varchar2,
        piv_parameter in varchar2,
        piv_status    in varchar2 default null
    ) is
        pragma autonomous_transaction;
    begin
        insert into glascontainer_audit (
            datum,
            username,
            aktion,
            parameter,
            status
        ) values ( sysdate,
                   upper(substr(piv_username, 1, 100)),
                   substr(piv_aktion, 1, 100),
                   substr(piv_parameter, 1, 4000),
                   substr(piv_status, 1, 4000) );

        commit;
    exception
        when others then
            rollback;
    end log_aktion;

  /** 
  * Schaltet die nächtliche Synchronisierung mit dem AOE-Webservice 
  * ein oder aus. 
  * 
  * @param pin_application_id [IN] Üblicherweise :APP_ID (2022) 
  * @param piv_module_static_id [IN] Üblicherweise ws_static_id_preorders 
  * @param pib_enable [IN] TRUE: Synchronisierung wird aktiviert, 
  * FALSE: Synchronisierung wird deaktiviert 
  * (gilt solange, bis sie wieder aktiviert wird) 
  *
  * @usage war zuvor: PCK_GLASCONTAINER.p_manage_ws_sync
  */
    procedure p_ws_sync_aktivieren (
        pin_application_id   in number,
        piv_module_static_id in varchar2,
        pib_enable           in boolean
    ) is 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'p_ws_sync_aktivieren';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_application_id', pin_application_id);
            pck_format.p_add('piv_module_static_id', piv_module_static_id);
            pck_format.p_add('pib_enable', pib_enable);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        case pib_enable
            when true then
                apex_rest_source_sync.enable(
                    p_application_id   => pin_application_id,
                    p_module_static_id => piv_module_static_id
                );
            when false then
                apex_rest_source_sync.disable(
                    p_application_id   => pin_application_id,
                    p_module_static_id => piv_module_static_id
                );
            else
                raise_application_error(c_application_error_number, 'Argument "pib_enable" darf nicht leer sein');
        end case;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end p_ws_sync_aktivieren; 
 
 
 
 
/**
 * Setzt die Webservice-Stamm-URL für den Glascontainer auf eine neue Adresse bzw. den Defaultwert, und deaktiviert
 * die Synchronisierung sowie die Einträge in der Auftragsliste (sofern der User nicht die Default-URL ausgewählt hat)
 * 
 * @param piv_username [IN]  Name des APEX-Users, der die Änderung durchführt 
 * @param piv_url      [IN]  Neue URL, beginnend mit "https", abschließender Slash wird ggf. ergänzt.
 *                           Der Wert muss identisch sein mit einer der verfügbaren Auswahlmöglichkeiten (v_wert1) aus
 *                           den Einträgen mit pv_key2 = BASE_URL_OPTION_1|BASE_URL_OPTION_2|BASE_URL_OPTION_3.
 *                           Falls leer, wird die Default-URL gesetzt.
 *
 * @ticket   FTTH-4987
 */
    procedure p_set_base_url (
        piv_username in varchar2,
        piv_url      in varchar2 default null
    ) is

        v_alte_url             params.v_wert1%type;
        v_neue_url             params.v_wert1%type;
        v_neue_url_ist_default params.n_wert1%type;
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name        constant logs.routine_name%type := 'p_set_base_url';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_username', piv_username);
            pck_format.p_add('piv_url', piv_url);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
    -- Die Umstellung der Basis-URL ist nur ein Feature für Entwicklungs- und Testumgebungen
        if db_name = 'NMC' then
            raise_application_error(-20001, 'Die Umstellung der Basis-Webservice-URL ist in dieser Umgebung nicht gestattet');
        end if;

    -- Prüfen, ob die URL zur Liste der verfügbaren BASE_URLs gehört und die Default-Einstellung wäre. 
    -- Wenn kein Eintrag gefunden wird, ist dies ein Fehler,
    -- da eine beliebige Freitext-Eingabe nicht erlaubt ist.
        begin
            select
                v_wert1,
                n_wert1
            into
                v_neue_url,
                v_neue_url_ist_default
            from
                v_params
            where
                    pv_satzart = 'WEBSERVICE'
                and pv_key1 = 'PREORDERBUFFER'
                and pv_key2 like 'BASE_URL_OPTION%' -- BASE_URL_OPTION_1, BASE_URL_OPTION_2, BASE_URL_OPTION_3
                and ( ( v_wert1 = piv_url )               -- entweder der eingegebene Wert
                      or ( piv_url is null
                           and n_wert1 = 1 ) -- oder alternativ der Defaultwert
                            );

        exception
            when no_data_found then
                if piv_url is null then
                    raise_application_error(c_application_error_number, 'Webservice-URL: Kein Defaultwert hinterlegt');
                else
                    raise_application_error(c_application_error_number, 'Webservice-URL "'
                                                                        || piv_url
                                                                        || '" ist nicht verwendbar');
                end if;
        end;
    
    -- Prüfen, ob die aktuelle BASE_URL bereits der neuen URL entspricht.
    -- Falls das so ist, kann hier abgebrochen werden.
        select
            max(v_wert1)
        into v_alte_url
        from
            v_params
        where
                pv_satzart = 'WEBSERVICE'
            and pv_key1 = 'PREORDERBUFFER'
            and pv_key2 = 'BASE_URL';   
    
    -- Shortcut: Es gibt nichts zu tun
        if v_alte_url = v_neue_url then
        -- Dann wird auch nichts geloggt, denn es hat keine Änderung stattgefunden.
        -- Einfach tschüß.
            return;
        end if;

    -- Eintragen der gewählten neuen URL als aktive URL:
        core.pck_params_dml.p_update_v_wert1(
            piv_satzart     => 'WEBSERVICE',
            piv_key1        => 'PREORDERBUFFER',
            piv_key2        => 'BASE_URL',
            piv_environment => db_name -- Achtung: Der Environment-Eintrag 'ALL' ist hier nicht erwünscht!
            ,
            piv_wert1       => v_neue_url
        );    
    
    -- Wenn die neue Webservice-URL nicht die Standard-URL ist, dann muss der nächtliche SYNC deaktiviert werden,
    -- da dessen URL nur manuell konfigurierbar ist (Stand APEX 24.2). Darüber hinaus sollte auch die Auftragsliste
    -- geleert werden, denn sonst bleiben Relikte aus einer anderen Umgebung in der Liste und könnten den Tester
    -- verwirren...
        if nvl(v_neue_url_ist_default, 0) <> 1 then
        -- SYNC Auftragsliste deaktivieren:
            p_ws_sync_aktivieren(
                pin_application_id   => 2022,
                piv_module_static_id => pck_glascontainer.c_ws_static_id_preorders,
                pib_enable           => false
            );
        -- SYNC Stornogründe muss nicht zwingend deaktiviert werden, da sowieso nur alle Jubeljahre eine Änderung auftritt
        -- und diese typscherweise auf allen Umgebungen identisch ausfällt.
        -- Aber falls doch:
        -- p_ws_sync_aktivieren (
        --       pin_application_id   => 2022
        --     , piv_module_static_id => PCK_GLASCONTAINER.C_WS_STATIC_ID_CANCELLATIONREASONS
        --     , pib_enable           => FALSE
        -- );
        
        -- Auftragsliste killen:
            delete ftth_ws_sync_preorders;

        end if;
   
    -- Die gegenteilige Aktion, nämlich das Aktivieren des nächtlichen SYNC im Falle der Default-URL, 
    -- wird hier nicht durchgeführt, da dies nicht immer gewünscht sein muss. Hierfür ist der Entwickler/Tester
    -- im Nachgang zuständig.
    -- Zur Erinnerung: In der Produktion ist das gesamte Szenario der @ticket FTTH-4987 nicht verfügbar.
    
    -- Aktion protokollieren:
        log_aktion(piv_username, aktion_base_url, v_neue_url);
    exception
        when others then
            log_aktion(piv_username, aktion_base_url, piv_url, sqlerrm);
            raise;
    end p_set_base_url;
    
    
-- @progress 2025-05-06

/**
 * Gibt TRUE zurück, wenn die momentan für den Glascontainer eingestellt BASE_URL (siehe @ticket FTTH-4987)
 * der Default-BASE_URL entspricht, andernfalls FALSE
 */
    function is_base_url_default return naturaln is
        v_url_is_default natural;
    begin
        select
            nvl(
                max(1),
                0
            )
        into v_url_is_default
        from
                 v_params p1
            join v_params p2 on ( p2.pv_satzart = p1.pv_satzart
                                  and p2.pv_key1 = p1.pv_key1
                                  and p2.pv_key2 like 'BASE_URL_OPTION%'
                                  and p2.v_wert1 = p1.v_wert1
                                  and p2.n_wert1 = 1 )
        where
                p1.pv_satzart = 'WEBSERVICE'
            and p1.pv_key1 = 'PREORDERBUFFER'
            and p1.pv_key2 = 'BASE_URL';

        return v_url_is_default;
    end;
    

------------------------------------------------------------------------------------------------------------------------    
-- Package-Initialisierung:
------------------------------------------------------------------------------------------------------------------------

end;
/

