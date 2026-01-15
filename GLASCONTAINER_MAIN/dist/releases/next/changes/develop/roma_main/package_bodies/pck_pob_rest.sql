-- liquibase formatted sql
-- changeset ROMA_MAIN:1768480989188 stripComments:false logicalFilePath:develop/roma_main/package_bodies/pck_pob_rest.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot GLASCONTAINER_MAIN/src/database/roma_main/package_bodies/pck_pob_rest.sql:null:6a0c64ad2989e3e34b5bbb7ea2f824d9b334be73:create

create or replace package body roma_main.pck_pob_rest as

    body_version constant varchar2(30) := '2025-04-29 0900';

  -- Umlaut-Test: ÄÖÜäöüß
  -- Eurozeichen: ? -- SELECT UNISTR('\20AC') FROM DUAL

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
  * SELECT * FROM LOGS WHERE ROUTINE_NAME LIKE 'PCK_POB_REST%' AND ...
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

    function fv_http_status (
        i_statuscode in integer
    ) return varchar2
        deterministic
    is
    begin
        return
            case i_statuscode -- /// Funktion schreiben
                when 200 then
                    'OK'
                when 400 then
                    'Webservice weist die Änderung zurück'
                when 404 then
                    'Der Auftrag wurde nicht gefunden'
                when 409 then
                    'Der Auftrag ist zur Zeit gesperrt'
                when 415 then
                    'Protokollfehler (unbekannter Medientyp)' -- @ticket FTTH-1698
                when 500 then
                    'Interner Serverfehler - bitte wenden Sie sich an den Anwendungs-Administrator'
                when 502 then
                    'Bad Gateway - bitte wenden Sie sich an den Anwendungs-Administrator'
                when 503 then
                    'Der Dienst momentan nicht verfügbar'
    ----
                else 'Bitte wenden Sie sich an den Anwendungs-Administrator'
            end;
    end fv_http_status;
--    
--    
--    
--    
 /**
 * Protokolliert einen Webservice-Call und gibt die ID der Protokollzeile zurück,
 * damit das aufrufende Programm in Fehlerfall (und nur dann!) ein Update
 * mit Informationen zum Fehler durchführen kann
 *
 * @param piv_application         [IN]  Landet in  FTTH_WEBSERVICE_AUFRUFE.APPLICATION,         z.B. "PCK_GLASCONTAINER"
 * @param piv_scope               [IN]  Landet in  FTTH_WEBSERVICE_AUFRUFE.SCOPE,               z.B. "p_webservice_post"
 * @param piv_request_url         [IN]  Landet in  FTTH_WEBSERVICE_AUFRUFE.REQUEST_URL          (aufgerufener Endpunkt inkl. Parametern)
 * @param piv_method              [IN]  Landet in  FTTH_WEBSERVICE_AUFRUFE.METHOD,              typischerweise "POST"
 * @param piv_parameters          [IN]  (optional) FTTH_WEBSERVICE_AUFRUFE.PARAMETERS,          z.B. "ID"
 * @param piv_parameter_values    [IN]  (optional) FTTH_WEBSERVICE_AUFRUFE.PARAMETER_VALUES,    z.B. "LvOYUMhIyoVYddNvNrPILMOvz2Lfpu"
 * @param piv_body                [IN]  (optional) FTTH_WEBSERVICE_AUFRUFE.BODY                 der JSON-Body des Service Requests
 * @param piv_response_statuscode [IN]  (optional) FTTH_WEBSERVICE_AUFRUFE.RESPONSE_STATUSCODE, idealerweise 200 für Erfolg
 * @param piv_app_user            [IN]  (optional) FTTH_WEBSERVICE_AUFRUFE.APP_USER,            aus APEX
 * @param piv_errormessage        [IN]  (optional) FTTH_WEBSERVICE_AUFRUFE.ERRORMESSAGE,        falls das aufrufende Programm eine solche generiert hat         
 * @param piv_response_body       [IN]  (optional) FTTH_WEBSERVICE_AUFRUFE.RESPONSE_BODY,       für den Fall das der Service Request
 *                                                                                              einen auszuwertenden Body zurückgibt, der beispielsweise
 *                                                                                              den codierten Fehlergrund beinhaltet
 */
    function fn_log_webservice_aufruf (
        piv_application         in varchar2,
        piv_scope               in varchar2,
        piv_request_url         in varchar2,
        piv_method              in varchar2,
        piv_parameters          in varchar2 default null,
        piv_parameter_values    in varchar2 default null,
        piv_body                in varchar2 default null,
        piv_response_statuscode in varchar2 default null,
        piv_app_user            in varchar2 default null,
        piv_errormessage        in varchar2 default null,
        piv_response_body       in varchar2 default null
    ) return ftth_webservice_aufrufe.id%type
        accessible by ( ut_glascontainer )
    is

        pragma autonomous_transaction;
        v_id            ftth_webservice_aufrufe.id%type;
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'fn_log_webservice_aufruf';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_application', piv_application);
            pck_format.p_add('piv_scope', piv_scope);
            pck_format.p_add('piv_request_url', piv_request_url);
            pck_format.p_add('piv_method', piv_method);
            pck_format.p_add('piv_parameters', piv_parameters);
            pck_format.p_add('piv_parameter_values', piv_parameter_values);
            pck_format.p_add('piv_body', piv_body);
            pck_format.p_add('piv_response_statuscode', piv_response_statuscode);
            pck_format.p_add('piv_app_user', piv_app_user);
            pck_format.p_add('piv_errormessage', piv_errormessage);
            pck_format.p_add('piv_response_body', piv_response_body);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        -- @ticket FTTH-5025: Im Rahmen der Datensparsamkeit wird für einen GET-Aufruf
        -- zukünftig überhaupt kein Log mehr geschrieben:
        if piv_method = c_ws_method_get then
            return null;
        end if;

        -- @ticket FTTH-5025: Anstatt sie "sofort zu löschen", werden Protokolle
        -- von erfolgreichen Aufrufen zukünftig erst gar nicht erzeugt:
        if piv_response_statuscode = c_ws_statuscode_ok then
            return null;
        end if;
        insert into ftth_webservice_aufrufe (
            uhrzeit,
            application,
            scope,
            request_url,
            method,
            parameters,
            parameter_values,
            body,
            response_statuscode,
            app_user,
            errormessage,
            response_body
        ) values ( systimestamp,
                   substr(piv_application, 1, 30),
                   substr(piv_scope, 1, 100),
                   substr(piv_request_url, 1, 1000),
                   substr(piv_method, 1, 6),
                   substr(piv_parameters, 1, 4000),
                   substr(piv_parameter_values, 1, 4000),
                   substr(piv_body, 1, 4000),
                   substr(piv_response_statuscode, 1, 6),
                   substr(piv_app_user, 1, 30), -- 2024-08-06: Spaltenbreite geändert auf 30 (sollte erstmal reichen), weil der Username ERIK.VOIGT 
                                         -- in der Produktion zu einem Fehler geführt hat (Vorbestellung konnte deshalb nicht abschickt werden!),
                                         -- vorgesehen waren "eigentlich" nur Nutzernamen mit entweder 6 oder 8 Zeichen.
                   substr(piv_errormessage, 1, 255),
                   substr(piv_response_body, 1, 4000) -- @ticket FTTH-3815 neue Spalte
                    ) returning id into v_id;

        commit;
        return v_id;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            rollback;
            raise;
    end fn_log_webservice_aufruf;

/**
 * Protokolliert einen Webservice-Call in der Tabelle FTTH_WEBSERVICE_AUFRUFE
 * 
 * @param piv_application         [IN]  Landet in  FTTH_WEBSERVICE_AUFRUFE.APPLICATION,         z.B. "PCK_GLASCONTAINER"
 * @param piv_scope               [IN]  Landet in  FTTH_WEBSERVICE_AUFRUFE.SCOPE,               z.B. "p_webservice_post"
 * @param piv_request_url         [IN]  Landet in  FTTH_WEBSERVICE_AUFRUFE.REQUEST_URL          (aufgerufener Endpunkt inkl. Parametern)
 * @param piv_method              [IN]  Landet in  FTTH_WEBSERVICE_AUFRUFE.METHOD,              typischerweise "POST"
 * @param piv_parameters          [IN]  (optional) FTTH_WEBSERVICE_AUFRUFE.PARAMETERS,          z.B. "ID"
 * @param piv_parameter_values    [IN]  (optional) FTTH_WEBSERVICE_AUFRUFE.PARAMETER_VALUES,    z.B. "LvOYUMhIyoVYddNvNrPILMOvz2Lfpu"
 * @param piv_body                [IN]  (optional) FTTH_WEBSERVICE_AUFRUFE.BODY                 der JSON-Body des Service Requests
 * @param piv_response_statuscode [IN]  (optional) FTTH_WEBSERVICE_AUFRUFE.RESPONSE_STATUSCODE, idealerweise 200 für Erfolg
 * @param piv_app_user            [IN]  (optional) FTTH_WEBSERVICE_AUFRUFE.APP_USER,            aus APEX
 * @param piv_errormessage        [IN]  (optional) FTTH_WEBSERVICE_AUFRUFE.ERRORMESSAGE,        falls das aufrufende Programm eine solche generiert hat       
 * @param piv_response_body       [IN]  (optional) FTTH_WEBSERVICE_AUFRUFE.RESPONSE_BODY,       für den Fall das der Service Request
 *                                                                                              einen auszuwertenden Body zurückgibt, der beispielsweise
 *                                                                                              den codierten Fehlergrund beinhaltet 
 */
    procedure p_log_webservice_aufruf (
        piv_application         in varchar2,
        piv_scope               in varchar2,
        piv_request_url         in varchar2,
        piv_method              in varchar2,
        piv_parameters          in varchar2 default null,
        piv_parameter_values    in varchar2 default null,
        piv_body                in varchar2 default null,
        piv_response_statuscode in varchar2 default null,
        piv_app_user            in varchar2 default null,
        piv_errormessage        in varchar2 default null,
        piv_response_body       in varchar2 default null
    ) is

        v_void_id       ftth_webservice_aufrufe.id%type;
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'p_log_webservice_aufruf';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_application', piv_application);
            pck_format.p_add('piv_scope', piv_scope);
            pck_format.p_add('piv_request_url', piv_request_url);
            pck_format.p_add('piv_method', piv_method);
            pck_format.p_add('piv_parameters', piv_parameters);
            pck_format.p_add('piv_parameter_values', piv_parameter_values);
            pck_format.p_add('piv_body', piv_body);
            pck_format.p_add('piv_response_statuscode', piv_response_statuscode);
            pck_format.p_add('piv_app_user', piv_app_user);
            pck_format.p_add('piv_errormessage', piv_errormessage);
            pck_format.p_add('piv_response_body', piv_response_body);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 

    begin
    -- 2025-01-14: Es besteht keine Notwendigkeit mehr, die lesenden Aufrufe zu protokollieren:
        if piv_method = c_ws_method_get then
            return; -- (bei Bedarf kann stattdessen die Funktion aufgerufen werden, auf die sich diese Prozedur abstützt)
        end if;
        v_void_id := fn_log_webservice_aufruf(
            piv_application         => piv_application,
            piv_scope               => piv_scope,
            piv_request_url         => piv_request_url,
            piv_method              => piv_method,
            piv_parameters          => piv_parameters,
            piv_parameter_values    => piv_parameter_values,
            piv_body                => piv_body,
            piv_response_statuscode => piv_response_statuscode,
            piv_app_user            => piv_app_user,
            piv_errormessage        => piv_errormessage,
            piv_response_body       => piv_response_body -- neu 2025-03-12
        );

    exception
        when others then
            pck_logs.p_error(
                pic_message      => 'Webservice-Logging fehlgeschlagen: ' || fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );
      -- kein RAISE, denn ein fehlerhaftes Logging darf nicht den Eindruck erwecken,
      -- als habe der Webservice-Aufruf keinen Erfolg gehabt.
    end p_log_webservice_aufruf;


  /**
  * Liefert in der jeweiligen Umgebung die Webservice-Base-URL, deren Benutzernamen
  * und Passwort.
  *
  * @param piv_kontext     [IN ] Aufrufendes System (derzeit nur: PREORDERBUFFER)
  * @param pov_ws_url      [OUT] Basis-URL für den Aufruf, passend zur jeweiligen Umgebung
  * @param pov_ws_username [OUT] Benutzername für den Aufruf, passend zur jeweiligen Umgebung
  * @param pov_ws_password [OUT] Passwort für den Aufruf, passend zur jeweiligen Umgebung
  *
  * @example
  * DECLARE
  * v_ws_base_url VARCHAR2(100);
  * v_ws_username VARCHAR2(100);
  * v_ws_password VARCHAR2(100);
  * BEGIN
  * pck_pob_rest.get_base_url(
  *   piv_kontext     => 'PREORDERBUFFER'
  * , pov_ws_base_url => v_ws_base_url
  * , pov_ws_username => v_ws_username
  * , pov_ws_password => v_ws_password
  * );
  * DBMS_OUTPUT.PUT_LINE(v_ws_base_url || ', ' || v_ws_username || ', ' || v_ws_password);
  * END;
  */
    procedure get_base_url (
        piv_kontext     in varchar2,
        pov_ws_base_url out varchar2,
        pov_ws_username out varchar2,
        pov_ws_password out varchar2
    ) is
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'get_base_url';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_kontext', piv_kontext);
        -- (OUT): pov_ws_base_url
        -- (OUT): pov_ws_username
        -- (OUT): pov_ws_password
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
    -- @ticket FTTH-4987:
    -- Alle Programme fragen hier nach der URL für die Verbindung mit den AOE-Webservices

        if not g_webservices_enabled then
            return;
        end if;

    -- Die PARAMS-Tabelle gibt in jeder Umgebung
    -- die passenden Parameter zurück (ALL|NMC|NMCE|... etc),
    -- wobei ein spezifischer Umgebungsname, falls vorhanden,
    -- stets den Eintrag für "ALL" überdeckt    
        select
            v_wert1,
            v_wert2,
            v_wert3
        into
            pov_ws_base_url, -- erwartet: @URL https://api[-e|-u|-s|-x].dss.svc.netcologne.intern/
            pov_ws_username,
            pov_ws_password
        from
            v_params -- die View liefert umgebungsabhängig genau einen Datensatz zurück (mittels POLICY)
        where
                pv_satzart = c_satzart_webservice
            and pv_key1 = piv_kontext
            and pv_key2 = 'BASE_URL';

    exception
        when no_data_found then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise_application_error(-20000, 'Basis-Zugangsdaten zum Webservice wurden nicht gefunden');
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end get_base_url;


  /**
  * Gibt die Server-Basis-URL des Webservices "PreOrderBuffer" zurück
  *
  * @param piv_kontext     [IN ] Aufrufendes System (derzeit nur: PREORDERBUFFER)
  */
    function base_url (
        piv_kontext in varchar2 default kontext_preorderbuffer
    ) return varchar2 is

        v_base_url core.params.v_wert1%type;
        v_wert2    core.params.v_wert2%type;
        v_wert3    core.params.v_wert3%type;
    begin
        if not g_webservices_enabled then
            return null;
        end if;
        get_base_url(
            piv_kontext     => piv_kontext,
            pov_ws_base_url => v_base_url,
            pov_ws_username => v_wert2,
            pov_ws_password => v_wert3
        );

        return v_base_url;
    end base_url;

  /**
  * Liest die Zugangsdaten für den preorders-Webservice ein (falls nicht bereits geschehen)
  * und löscht alle Request Headers, so dass anschließend ein GET oder POST gegen diesen
  * Webservice durchgeführt werden kann
  *
  * @param piv_kontext     [IN ] Aufrufendes System (derzeit nur: PREORDERBUFFER)  
  * @param piv_ws_key      [IN ] Schlüssel für die Art des Webservices: PREORDERS GET|PREORDERS POST|PREORDERS_CANCEL|
  *                              INTERNAL_ORDER_POST|CONNECTIVITY_ID_INCREMENT
  *
  * @param pov_ws_url      [OUT] Basis-URL für den Aufruf, passend zur jeweiligen Umgebung
  * @param pov_ws_username [OUT] Benutzername für den Aufruf, passend zur jeweiligen Umgebung
  * @param pov_ws_password [OUT] Passwort für den Aufruf, passend zur jeweiligen Umgebung
  *
  * @date 2023-01-25
  *
  * @usage Die Zugangsdaten befinden sich in der Tabelle CORE.PARAMS
  *        Wenn sich die URL für einen Webservice ändern sollte (permanent oder meistens tempörär, z.B. in der Entwicklung),
  *        dann kann das analog zum folgenden Beispiel-Statement durchgeführt werden:
  *
  * @example
  *  BEGIN
  *      CORE.PCK_PARAMS_DML.p_update_v_wert1(
  *          piv_satzart => 'WEBSERVICE'
  *        , piv_key1    => 'PREORDERBUFFER'
  *        , piv_key2    => 'PREORDERS_POST'
  *        , piv_environment => 'ALL'
  *        , piv_wert1       => 'api/ftth/order/{orderId}' -- nur diese URL wird aktualisiert
  *      );
  *  END; 
  */
    procedure p_init_webservice (
        piv_kontext     in varchar2,
        piv_ws_key      in varchar2,
        pov_ws_url      out varchar2,
        pov_ws_username out varchar2,
        pov_ws_password out varchar2
    ) 
  --  ACCESSIBLE BY (
  --     PACKAGE PCK_GLASCONTAINER, 
  --     PACKAGE PCK_VERMARKTUNGSCLUSTER
  --  )
     is

        v_base_url      core.params.v_wert1%type;
        vr_url_appendix params%rowtype;        
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'p_init_webservice';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_kontext', piv_kontext);
            pck_format.p_add('piv_ws_key', piv_ws_key);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------
    begin
        if not g_webservices_enabled then
            return;
        end if;

    -- Basis-URL für diese Umgebung ermitteln:
        get_base_url(
            piv_kontext     => piv_kontext,
            pov_ws_base_url => v_base_url,
            pov_ws_username => pov_ws_username,
            pov_ws_password => pov_ws_password
        );

    -- URL je nach Anwendungsfall ergänzen:
        vr_url_appendix := pck_params.fr_params(
            piv_satzart => c_satzart_webservice,
            piv_key1    => piv_kontext,
            piv_key2    => piv_ws_key
        ); 

    -- URL zusammenbauen:
        pov_ws_url := rtrim(v_base_url, '/')
                      || '/'

        --        || CASE piv_ws_key
        --            WHEN c_ws_key_preorders_post THEN
        --                'api/ftth/order/' -- weicht leider vom Schema etwas ab
        --            WHEN c_ws_key_preorders_get THEN
        --                'ftth-order/preorders/'
        --            WHEN c_ws_key_storno_post THEN
        --                'ftth-order/preorders/'
        --           END
                      || vr_url_appendix.v_wert1;

    -- Hier werden eventuell noch bestehende Header gelöscht;
        apex_web_service.g_request_headers.delete();

    -- Das aufrufende Programm muss keine eigenen Header mehr setzen, 
    -- es sei denn sie weichen von diesen ab, wofür es keinen Grund gibt:
        apex_web_service.g_request_headers(1).name := 'Content-Type';
        apex_web_service.g_request_headers(1).value := 'application/json';
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end p_init_webservice;


/**
  * Ruft den Webservice "/preorders/" mit einem POST-Request
  * für einen bestimmten Auftrag auf, um geänderte Daten zu übermitteln
  * (dies sollte eigentlich über PUT gelöst sein)
  *
  * @param piv_kontext      [IN ] Aufrufendes System (derzeit nur: "PREORDERBUFFER")
  * @param piv_ws_key       [IN ] C_WS_KEY_PREORDERS_POST|C_WS_KEY_PREORDERS_CANCEL
  * @param piv_uuid         [IN ] ID des Auftrags, der geändert werden soll
  * @param piv_app_user     [IN ] APEX-Anwendungsnutzer zu Logging-Zwecken
  * @param pic_request_body [IN ] JSON mit den geänderten Daten, beispielsweise beginnend mit "product": {...}
  *
  *
  * @exception Alle Exceptions werden geworfen.

    PROCEDURE "P_WEBSERVICE_POST" (
        piv_kontext    IN VARCHAR2,
        piv_ws_key     IN VARCHAR2,
        piv_uuid       IN VARCHAR2,
        piv_app_user   IN VARCHAR2,
        pic_body       IN CLOB
    ) IS
        v_ws_url          VARCHAR2(255);
        v_ws_username     VARCHAR2(255);
        v_ws_password     VARCHAR2(255);
        v_ws_response     CLOB;
        v_ws_statuscode   INTEGER;
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
      IF NOT g_webservices_enabled THEN RETURN; END IF;
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
            piv_kontext     => piv_kontext
          , piv_ws_key      => piv_ws_key
          , pov_ws_url      => v_ws_url
          , pov_ws_username => v_ws_username
          , pov_ws_password => v_ws_password
        );

        -- 2023-07-11: Header werden nun zentral in p_init_webservice gesetzt:
        --apex_web_service.g_request_headers(1).name := 'Content-Type';
        --apex_web_service.g_request_headers(1).value := 'application/json'; -- 2023-01-24, fehlte, @Ticket FTTH-1698
    --  2023-05-23: Alle URL-Muster werden aus PARAMS ermittelt, nicht mehr fallweise hartkodiert:
        v_ws_url := replace(v_ws_url, C_WS_ORDERID_TOKEN, piv_uuid);

    -- @see
    -- https://api-e.dss.svc.netcologne.intern/ftth-order/swagger-ui/index.html#/order-controller/updateOrder
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

        v_ws_statuscode := apex_web_service.g_status_code;

        -- :: Dieses Theme wird stattdessen in p_webservice_post2 behandelt

        -- 2024-11-12 @ticket FTTH-4021 neu: Auswertung der Response für "Auftrag in Siebel abschließen"
        --CASE piv_ws_key
        --  WHEN PCK_POB_REST.C_WS_KEY_SIEBEL_PROCESS THEN
        --    IF v_ws_statuscode = PCK_POB_REST.C_WS_STATUSCODE_PRECONDITION -- 412
        --      THEN
        --         RAISE_APPLICATION_ERROR(-20000, v_ws_response); -- Response wird im aufrufenden Programm geparst
        --    END IF;
        --  ELSE
        --    NULL;
        --END CASE;  

        p_log_webservice_aufruf(
            piv_application         => piv_kontext
          , piv_scope               => cv_routine_name
          , piv_request_url         => v_ws_url
          , piv_method              => c_ws_method_post
          , piv_parameters          => 'ID'
          , piv_parameter_values    => piv_uuid
          , piv_body                => pic_body
          , piv_response_statuscode => v_ws_statuscode
          , piv_app_user            => piv_app_user
          , piv_errormessage        => v_ws_errormessage
        );

    -- Status überprüfen:
        IF v_ws_errormessage IS NOT NULL OR v_ws_statuscode <> C_WS_STATUSCODE_OK THEN
           CASE v_ws_statuscode
             WHEN C_REQUEST_AUFTRAG_GESPERRT THEN RAISE E_REQUEST_AUFTRAG_GESPERRT; -- @ticket FTTH-4314. ///// Bei Erfolg die weiteren Statusfehler ebenfalls als dedizierte Exceptions ausgeben
             ELSE RAISE E_REQUEST_NOT_SUCCESSFUL; -- das ist -20042, wo wir leider keine näheren Informationen haben, was falsch gelaufen ist
           END CASE;
        END IF;    
    EXCEPTION
    -- die fachlichen Fehler sind bereits geloggt, daher nur Application Errors ausgeben:
      -- Diese Meldungen werde hier an der falschen Stelle generiert. Das Wording sollte das aufrufende Programm definieren (Suche nach PCK_POB_REST.p_webservice_post).
      -- Stattdessen /////// einfach nur die Exception 1:1 RAISEn!
      WHEN E_REQUEST_AUFTRAG_GESPERRT THEN -- @ticket FTTH-4314
        RAISE_APPLICATION_ERROR(C_REQUEST_AUFTRAG_GESPERRT, 'Auftrag wird gerade bearbeitet, wurde kürzlich storniert oder der aktuelle Status passt nicht zur geplanten Aktion. Bitte versuchen Sie es später erneut.');
      WHEN E_REQUEST_NOT_SUCCESSFUL THEN
        RAISE_APPLICATION_ERROR(C_REQUEST_NOT_SUCCESSFUL, 'Webservice-Aufruf nicht erfolgreich, Webservice-Statuscode=' || v_ws_statuscode);
      WHEN OTHERS THEN
    -- nur unerwartete Fehler loggen (fachliche und technische Webservice-Statusfehler
    -- werden ja bereits oben geloggt)
        IF SQLCODE <> -20000 THEN -- 2023-09-19: Das aufrufende Programm soll selbst entscheiden,
        -- ob ein Fehler-Statuscode vom Server zu einem Fehler-Log führen muss.
        -- Hier werden nur technische Fehler geloggt, keine Statuscodes:
            pck_logs.p_error(
              pic_message      => fcl_params()
             ,piv_routine_name => qualified_name(cv_routine_name)
             ,piv_scope        => G_SCOPE
            );
        END IF;
        RAISE;
    END p_webservice_post;
  */    


/**
 * Nimmt den vorbereiteten JSON-Body entgegen und sendet die Änderungsbenachrichtigung
 * an den Webservice MarketingStatusUpdate
 *
 * @param pic_body        [IN ] Vorbereiteter JSON-Body,
 *                        z.B. {"status":"UNDER_CONSTRUCTION","availabilityDate":"2023-12-31","houseSerialNumberList":[1132466,1133709,1133715]}
 * @param piv_username    [IN ] APEX-Benutzer, der den Vorgang durchführt 
 *                        (zu Protokollierungszwecken, darf auch leer bleiben)
 * @param piv_application [IN ] Optionale Kennzeichnung, aus welcher App der Webservice aufgerufen wurde
 *                        (wird zur Protokollierung des Aufrufs und zum Loggen eines Fehlers verwendet)
 */
    procedure p_vermarktungscluster_objektmeldung_post (
        pic_body        in clob,
        piv_username    in varchar2,
        piv_application in varchar2 default null
    )
        accessible by ( package pck_vermarktungscluster )
    is

        v_ws_url        varchar2(255);
        v_ws_username   varchar2(255);
        v_ws_password   varchar2(255);
        v_ws_response   clob;
        v_ws_statuscode integer;
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'p_vermarktungscluster_objektmeldung_post';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pic_body',
                             dbms_lob.substr(pic_body, 1000, 1));
            pck_format.p_add('piv_username', piv_username);
            pck_format.p_add('piv_application', piv_application);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
  -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------     
    begin
        if not g_webservices_enabled then
            return;
        end if;

    -- Header clearen:
        p_init_webservice(
            piv_kontext     => kontext_preorderbuffer,
            piv_ws_key      => 'MARKETING_STATUS',
            pov_ws_url      => v_ws_url,
            pov_ws_username => v_ws_username,
            pov_ws_password => v_ws_password
        );

        v_ws_response := apex_web_service.make_rest_request(
            p_url              => v_ws_url,
            p_http_method      => c_ws_method_post,
            p_username         => v_ws_username,
            p_password         => v_ws_password,
            p_transfer_timeout => c_ws_transfer_timeout,
            p_wallet_path      => c_ws_wallet_path,
            p_wallet_pwd       => c_ws_wallet_pwd,
            p_body             => pic_body
        );

        v_ws_statuscode := apex_web_service.g_status_code;
        p_log_webservice_aufruf(
            piv_application         => coalesce(piv_application, 1210),
            piv_scope               => cv_routine_name,
            piv_request_url         => v_ws_url,
            piv_method              => c_ws_method_post,
            piv_parameters          => null,
            piv_parameter_values    => null,
            piv_body                => dbms_lob.substr(pic_body, 4000, 1),
            piv_response_statuscode => v_ws_statuscode,
            piv_app_user            => piv_username,
            piv_errormessage        => v_ws_response
        );

        if v_ws_statuscode <> c_ws_statuscode_ok then
            raise e_request_not_successful;
        end if;
    exception
        when e_request_not_successful then
      -- geloggt ist er ja bereits
            raise_application_error(c_request_not_successful, 'Statusupdate nicht erfolgreich, Webservice-Statuscode=' || v_ws_statuscode
            );
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope -- COALESCE(piv_application, G_SCOPE)
            );

            raise;
    end p_vermarktungscluster_objektmeldung_post;

  /**
  * Erlaubt es, Webservices komplett zu ein- oder auszuschalten.
  */
    procedure p_enable_webservices (
        pib_enabled in boolean default true
    ) is
    begin
        g_webservices_enabled := pib_enabled;
    end;


--@progress 2023-11-14 ---------------------------------------------------------


/**
 * @deprecated: @ticket FTTH-3329, @ticket FTTH-3730
 * Nimmt den vorbereiteten JSON-Body entgegen und sendet die Änderungsbenachrichtigung
 * an den Webservice https://api-e.dss.svc.netcologne.intern/ftth-order/wholebuy
 *
 * @param pic_body        [IN ] Vorbereiteter JSON-Body,
 *                        z.B. [{"partner":"DGF","hausLfdnrList":[1053306]},{"partner":"TCOM","hausLfdnrList":[982750]}]
 * @param piv_application [IN ] Optionale Kennzeichnung, aus welcher App der Webservice aufgerufen wurde
 *                        (wird zur Protokollierung des Aufrufs und zum Loggen eines Fehlers verwendet)
 *
 * @ticket FTTH-2907
 *
 * @example select * from params where pv_satzart = 'WEBSERVICE' and pv_key2 = 'WHOLEBUY_OBJEKTMELDUNG_POST';
 * @deprecated @ticket FTTH-4390: Dieser Job läuft in der Produktion seit Monaten auf einen Fehler und wird daher
 *                                hier abgefangen
 */
    procedure p_wholebuy_post_objektmeldung (
        pic_body        in clob,
        piv_application in varchar2 default null
    ) is

        v_ws_url        varchar2(255);
        v_ws_username   varchar2(255);
        v_ws_password   varchar2(255);
        v_ws_response   clob;
        v_ws_statuscode integer;
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'p_post_wholebuy_objektmeldung';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pic_body',
                             dbms_lob.substr(pic_body, 1000, 1));
            pck_format.p_add('piv_application', piv_application);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
  -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------     
    begin
        return; -- /////////// stattdessen den Job in der Datenbank löschen, der dies aufruft

        if not g_webservices_enabled then
            return;
        end if;

    -- Header clearen:
        p_init_webservice(
            piv_kontext     => kontext_preorderbuffer,
            piv_ws_key      => c_ws_key_wholebuy_objektmeldung_post,
            pov_ws_url      => v_ws_url,
            pov_ws_username => v_ws_username,
            pov_ws_password => v_ws_password
        );

        v_ws_response := apex_web_service.make_rest_request(
            p_url              => v_ws_url,
            p_http_method      => c_ws_method_post,
            p_username         => v_ws_username,
            p_password         => v_ws_password,
            p_transfer_timeout => c_ws_transfer_timeout,
            p_wallet_path      => c_ws_wallet_path,
            p_wallet_pwd       => c_ws_wallet_pwd,
            p_body             => pic_body
        );

        v_ws_statuscode := apex_web_service.g_status_code;
        p_log_webservice_aufruf(
            piv_application         => piv_application,
            piv_scope               => cv_routine_name,
            piv_request_url         => v_ws_url,
            piv_method              => c_ws_method_post,
            piv_parameters          => null,
            piv_parameter_values    => null,
            piv_body                => dbms_lob.substr(pic_body, 32000, 1),
            piv_response_statuscode => v_ws_statuscode,
            piv_app_user            => 'JOB',
            piv_errormessage        => v_ws_response
        );

        if v_ws_statuscode <> c_ws_statuscode_ok then
            raise e_request_not_successful;
        end if;
    exception
        when e_request_not_successful then
      -- geloggt ist er ja bereits
            raise_application_error(c_request_not_successful, 'Statusupdate nicht erfolgreich, Webservice-Statuscode=' || v_ws_statuscode
            );
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope -- COALESCE(piv_application, G_SCOPE)
            );

            raise;
    end p_wholebuy_post_objektmeldung;

-- @progress 2024-04-11

/**
  * Ruft den Webservice https://api-[].dss.svc.netcologne.intern/api/ftth/internal/order
  * mit einem POST-Request auf, um eine Vorbestellung im Glascontainer abzuschließen
  *
  * @param piv_kontext      [IN ] Aufrufendes System (derzeit nur: "PREORDERBUFFER")
  * @param piv_app_user     [IN ] APEX-Anwendungsnutzer zu Logging-Zwecken
  * @param pic_request_body [IN ] JSON mit den Daten verVorbestellung
  *
  *
  * @exception Der Body wird nicht geprüft - alle Exceptions werden geworfen.
  */
    procedure p_internal_order_post (
        piv_kontext  in varchar2,
        piv_app_user in varchar2,
        pic_body     in clob
    )
        accessible by ( package pck_glascontainer_order, package ut_glascontainer )
    is

        v_ws_url             varchar2(255);
        v_ws_username        varchar2(255);
        v_ws_password        varchar2(255);
        v_ws_response        clob;
        v_ws_statuscode      integer;
        v_webservice_log_id  ftth_webservice_aufrufe.id%type; -- für den Fall, dass der Auftrag nicht erfolgreich vom Webserver
                                                         -- verarbeitet wird, können mit dieser ID die gesendeten Daten
                                                         -- ausgelesen werden
        v_rest_error_message varchar2(5000 char);
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name      constant logs.routine_name%type := 'p_internal_order_post';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_kontext', piv_kontext);
            pck_format.p_add('piv_app_user', piv_app_user);
            pck_format.p_add('pic_body', pic_body);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------     
    begin
        if not g_webservices_enabled then
            return;
        end if;

        -- Header clearen:
        p_init_webservice(
            piv_kontext     => kontext_preorderbuffer,
            piv_ws_key      => c_ws_key_internal_order_post,
            pov_ws_url      => v_ws_url,
            pov_ws_username => v_ws_username,
            pov_ws_password => v_ws_password
        );

        v_ws_response := apex_web_service.make_rest_request(
            p_url              => v_ws_url,
            p_http_method      => c_ws_method_post,
            p_username         => v_ws_username,
            p_password         => v_ws_password,
            p_transfer_timeout => c_ws_transfer_timeout,
            p_wallet_path      => c_ws_wallet_path,
            p_wallet_pwd       => c_ws_wallet_pwd,
            p_body             => pic_body
        );

        v_ws_statuscode := apex_web_service.g_status_code;
        begin
            v_webservice_log_id := fn_log_webservice_aufruf(
                piv_application         => piv_kontext,
                piv_scope               => cv_routine_name,
                piv_request_url         => v_ws_url,
                piv_method              => c_ws_method_post,
                piv_parameters          => null,
                piv_parameter_values    => null,
                piv_body                => dbms_lob.substr(pic_body, 4000, 1),
                piv_response_statuscode => v_ws_statuscode,
                piv_app_user            => piv_app_user,
                piv_errormessage        => substr(v_ws_response, 1, 255) -- v_ws_response vom vorigen Aufruf
            ); 
        -- Abfangen, falls nur der Log nicht stattgefunden hat:
        exception
            when others then
                pck_logs.p_error(
                    pic_message      => 'Webservice-Aufruf (Vorbestellung) durchgeführt, konnte aber nicht geloggt werden: '
                                   || chr(10)
                                   || fcl_params(),
                    piv_routine_name => qualified_name(cv_routine_name),
                    piv_scope        => g_scope -- COALESCE(piv_kontext, G_SCOPE)
                );
              -- kein RAISE
        end;

        if v_ws_statuscode <> c_ws_statuscode_ok then
            v_rest_error_message := pck_pob_rest.fv_get_error_message(piv_json_response => v_ws_response);
            raise e_request_not_successful;
        end if;

    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            if v_rest_error_message is null then
                v_rest_error_message := 'Der Auftrag konnte nicht erfolgreich verarbeitet werden.';
            end if;
            raise_application_error(-20000, v_rest_error_message
                                            || ' '
                                            || 'Info für Admin: LOG_ID=['
                                            || v_webservice_log_id
                                            || ']'
        -- das Log des fehlerhaften Vorbestellungsdatensatzes befindet sich hier:
        --     SELECT * -- insbesondere BODY, dort liegt das vollständige, gesendete JSON mit allen erfassten Daten
        --       FROM FTTH_WEBSERVICE_AUFRUFE
        --      WHERE ID = [WEBSERVICE_LOG_ID]
                                            || case
                when sqlcode <> -20042 then -- Dieser Fehlercode kommt immer, wenn der Server mit einer nichtssagenden
                                            -- Unzufriedenheitsmeldung quittiert, ohne  SQLERRM, das kann man sich also sparen.
                                            -- Grund ist überlicherweise eine fehlgeschlagene Validierung der Daten,
                                            -- jedoch wird die Ursache nicht zurückgemeldet. 
                                            -- Die originale Fehlermeldung des Systems ("BFF", Backend for Frontend) findet sich stattdessen hier:
                                            -- @url (Entwicklung)
                                            --  https://testdock01dmz.netcologne.intern:9000/grafana/explore?left=%7B"datasource":"JJ_ifyhMz","queries":%5B%7B"datasource":%7B"type":"loki","uid":"JJ_ifyhMz"%7D,"editorMode":"code","expr":"%7Bswarm_stack%3D%5C"dss-pk-e%5C", swarm_service%3D~%60.%2A%28business-ftth-bff%29$%60%7D","queryType":"range","refId":"A"%7D%5D,"range":%7B"from":"now-3h","to":"now"%7D%7D&orgId=1
                                            -- @url (Produktion)
                                            --  https://proddock01dmz.netcologne.intern:9000/grafana/explore?left=%7B%22datasource%22:%22gTwldlhMz%22,%22queries%22:%5B%7B%22refId%22:%22A%22,%22datasource%22:%7B%22type%22:%22loki%22,%22uid%22:%22gTwldlhMz%22%7D,%22editorMode%22:%22builder%22,%22expr%22:%22%7Bswarm_service%3D%5C%22dss-pk_dss-business-ftth-bff%5C%22%7D%20%7C%3D%20%60%60%22,%22queryType%22:%22range%22%7D%5D,%22range%22:%7B%22from%22:%22now-3h%22,%22to%22:%22now%22%7D%7D&orgId=1
                    ', Original-Fehlercode: '
                    || sqlcode
                    || ', Original-Fehlermeldung: '
                    || sqlerrm
            end);

    end p_internal_order_post;

-- @progress 2024-10-01

/**
 * Ruft den Webservice auf, der eine neue Connectivity-ID für einen Auftrag generiert,
 * und gibt den zurückerhaltenen Body, der diese enthält, im Erfolgsfall zurück.
 *
 * @param piv_kontext  [IN] Immer 'PREORDERBUFFER'
 * @param piv_app_user [IN] Der APEX-Benutzer, der diesen Service durch Interaktion aufruft
 * @param piv_uuid     [IN] ORDER_ID des Auftrags
 * @param pic_body     [IN] JSON-Payload, beinhaltet die alte Connectivity-ID und den App-User
 *
 * @ticket FTTH-3815
 *
 * @exception Im Fehlerfall wird eine Exception geworfen: 
 *            E_REQUEST_SERVER_ERROR, E_REQUEST_ARGUMENT_FEHLERHAFT, E_REQUEST_NICHT_VERARBEITBAR
 */
    function fv_connectivity_id_increment (
        piv_kontext  in varchar2,
        piv_app_user in varchar2,
        piv_uuid     in varchar2,
        pic_body     in clob
    ) return varchar2
        accessible by ( package pck_glascontainer_order, package ut_glascontainer )
    is

        v_ws_url              varchar2(255);
        v_ws_username         varchar2(255);
        v_ws_password         varchar2(255);
        v_ws_response         clob;
        n_ws_statuscode       integer;
        v_webservice_log_id   ftth_webservice_aufrufe.id%type;
        v_connectivity_id_inc ftth_ws_sync_preorders.connectivity_id%type;
        v_rest_error_message  varchar2(500 char);
        v_connectivity_id     varchar2(500 char);
        fehlermeldung_prefix  constant varchar2(100) := 'Es konnte keine neue Auftragsnummer generiert werden. Die Fehlermeldung lautet: '
        ;
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name       constant logs.routine_name%type := 'fv_connectivity_id_increment';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_kontext', piv_kontext);
            pck_format.p_add('piv_app_user', piv_app_user);
            pck_format.p_add('piv_app_uuid', piv_uuid);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
  -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------       
    begin
        if not g_webservices_enabled then
            raise e_request_not_successful;
        end if;

        -- Header clearen:
        p_init_webservice(
            piv_kontext     => kontext_preorderbuffer,
            piv_ws_key      => c_ws_key_connectivity_id_increment,
            pov_ws_url      => v_ws_url,
            pov_ws_username => v_ws_username,
            pov_ws_password => v_ws_password
        );

        -- Da die orderId in der URL vorkommt, diese ersetzen:
        v_ws_url := replace(v_ws_url, c_ws_orderid_token, piv_uuid);
        v_ws_response := apex_web_service.make_rest_request(
            p_url              => v_ws_url,
            p_http_method      => c_ws_method_post,
            p_username         => v_ws_username,
            p_password         => v_ws_password,
            p_transfer_timeout => c_ws_transfer_timeout,
            p_wallet_path      => c_ws_wallet_path,
            p_wallet_pwd       => c_ws_wallet_pwd,
            p_body             => pic_body
        );

        n_ws_statuscode := apex_web_service.g_status_code;
        begin
            v_webservice_log_id := fn_log_webservice_aufruf(
                piv_application         => piv_kontext,
                piv_scope               => cv_routine_name,
                piv_request_url         => v_ws_url,
                piv_method              => c_ws_method_post,
                piv_parameters          => null,
                piv_parameter_values    => null,
                piv_body                => dbms_lob.substr(pic_body, 4000, 1),
                piv_response_statuscode => n_ws_statuscode,
                piv_app_user            => piv_app_user,
                piv_errormessage        => -- Da dieser Service IMMER eine Respone zurückgibt, muss explizit
                                           -- auf einen Fehlerfall geprüft werden. Typische Antwort ist:
                                           -- {"timestamp":"2024-10-16T11:38:08.286+00:00","status":500,"error":"Internal Server Error","path":"/...
                                  case
                                      when n_ws_statuscode <> c_ws_statuscode_ok then
                                          substr(v_ws_response, 1, 255)
                                  end -- v_ws_response vom vorigen Aufruf
                                  ,
                piv_response_body       =>
                                   case
                                       when n_ws_statuscode = c_ws_statuscode_ok then
                                           substr(v_ws_response, 1, 4000)
                                   end
            ); 
        -- Abfangen, falls nur der Log nicht stattgefunden hat:
        exception
            when others then
                pck_logs.p_error(
                    pic_message      => 'Webservice-Aufruf (Vorbestellung) durchgeführt, konnte aber nicht geloggt werden: '
                                   || chr(10)
                                   || fcl_params(),
                    piv_routine_name => qualified_name(cv_routine_name),
                    piv_scope        => g_scope -- COALESCE(piv_kontext, G_SCOPE)
                );
              -- kein RAISE
        end;

        if n_ws_statuscode != c_ws_statuscode_ok then
            -- Fehlermeldung bestimmen
            v_rest_error_message := pck_pob_rest.fv_get_error_message(piv_json_response => v_ws_response);
            select
                connectivityid
            into v_connectivity_id
            from
                json_table ( pic_body, '$'
                    columns (
                        connectivityid varchar2 ( 500 char ) path '$.connectivityId'
                    )
                );
            -- Fallback fuer die Fehlermeldung
            if v_rest_error_message is null then
                v_rest_error_message := fehlermeldung_prefix;
                if n_ws_statuscode = c_ws_statuscode_bad_request then
                    v_rest_error_message := v_rest_error_message || 'Service konnte nicht aufgerufen werden';
                elsif n_ws_statuscode = c_ws_statuscode_server_error then
                    v_rest_error_message := v_rest_error_message || 'Server-Prozessfehler: Connectivity-ID konnte nicht generiert werden'
                    ;
                elsif n_ws_statuscode = c_ws_statuscode_precondition then
                    v_rest_error_message := v_rest_error_message
                                            || 'Connectivity-ID "'
                                            || v_connectivity_id
                                            || '" existiert nicht';
                elsif n_ws_statuscode = c_ws_statuscode_unprocessable then
                    v_rest_error_message := v_rest_error_message
                                            || 'Connectivity-ID "'
                                            || v_connectivity_id
                                            || '" kann nicht erhöht werden';
                end if;

            end if;

            raise e_request_not_successful;
        end if;

        return v_connectivity_id_inc;
    exception
        when e_request_not_successful then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise_application_error(-20000 - n_ws_statuscode, v_rest_error_message);
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end fv_connectivity_id_increment;

-- @progress 2024-11-12

/**
  * Ruft einen POB-Webservice auf und gibt die Response zurück
  *
  * @param piv_kontext      [IN ] Aufrufendes System (derzeit nur: "PREORDERBUFFER")
  * @param piv_ws_key       [IN ] C_WS_KEY_PREORDERS_POST|C_WS_KEY_PREORDERS_CANCEL
  * @param piv_uuid         [IN ] ID des Auftrags, der geändert werden soll
  * @param piv_app_user     [IN ] APEX-Anwendungsnutzer zu Logging-Zwecken
  * @param pic_request_body [IN ] JSON mit den geänderten Daten, beispielsweise beginnend mit "product": {...}
  *
  *
  * @exception Alle Exceptions werden geworfen.
  *
  * @usage Funktioniert zunächst wie P_WEBSERVICE_POST, jedoch mit Rückgabe der Antwort vom Webservice, 
  *        damit diese ausgewertet werden kann
  * @ticket FTTH-4021, @ticket FTTH-4314
  */
    procedure p_webservice_post2 (
        piv_kontext       in varchar2,
        piv_ws_key        in varchar2,
        piv_uuid          in varchar2,
        piv_app_user      in varchar2,
        pic_body          in clob,
        ---
        pov_ws_statuscode out integer,
        pov_ws_response   out clob
    ) is

        v_ws_url         varchar2(255);
        v_ws_username    varchar2(255);
        v_ws_password    varchar2(255);
        v_request_errmsg varchar2(255);
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name  constant logs.routine_name%type := 'p_webservice_post2';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_kontext', piv_kontext);
            pck_format.p_add('piv_ws_key', piv_ws_key);
            pck_format.p_add('piv_uuid', piv_uuid);
            pck_format.p_add('piv_app_user', piv_app_user);
            pck_format.p_add('pic_body',
                             dbms_lob.substr(pic_body, 1000, 1));
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------
    begin
        if not g_webservices_enabled then
            return;
        end if;
        p_init_webservice(
            piv_kontext     => piv_kontext,
            piv_ws_key      => piv_ws_key,
            pov_ws_url      => v_ws_url,
            pov_ws_username => v_ws_username,
            pov_ws_password => v_ws_password
        );

    -- @ticket FTTH-4021: Zum Testen der Service-Antwort gibt es diesen Dummy-Service:   
    -- v_ws_url := replace(v_ws_url, 'siebelOrderIds', 'dummySiebelOrderIds'); -- rauswerfen nach dem Testen

        v_ws_url := replace(v_ws_url, c_ws_orderid_token, piv_uuid);

    -- @see
    -- https://api-e.dss.svc.netcologne.intern/ftth-order/swagger-ui/index.html#/order-controller/updateOrder
        begin
            pov_ws_response := apex_web_service.make_rest_request(
                p_url              => v_ws_url,
                p_http_method      => c_ws_method_post,
                p_username         => v_ws_username,
                p_password         => v_ws_password,
                p_transfer_timeout => c_ws_transfer_timeout,
                p_wallet_path      => c_ws_wallet_path,
                p_wallet_pwd       => c_ws_wallet_pwd,
                p_body             => pic_body
            );
        exception
            when others then
                v_request_errmsg := sqlerrm; -- wird hier persistiert und nach dem Logging geraised.
        end;

        pov_ws_statuscode := apex_web_service.g_status_code;

        -- zunächst den Aufruf loggen, egal ob erfolgreich oder nicht:
        p_log_webservice_aufruf(
            piv_application         => piv_kontext,
            piv_scope               => cv_routine_name,
            piv_request_url         => v_ws_url,
            piv_method              => c_ws_method_post,
            piv_parameters          => 'ID',
            piv_parameter_values    => piv_uuid,
            piv_body                => dbms_lob.substr(pic_body, 4000, 1),
            piv_response_statuscode => pov_ws_statuscode,
            piv_app_user            => piv_app_user,
            piv_errormessage        => trim(v_request_errmsg
                                     || ' | '
                                     || pov_ws_response)
        );

        -- danach prüfen, ob es schon beim Aufruf ein technisches Problem gab:
        if v_request_errmsg is not null then
            raise_application_error(c_request_not_successful,
                                    'Webservice-Aufruf nicht erfolgreich: '
                                    || substr(v_request_errmsg, 1, 218)); -- Länge zusammen 255
        end if;

        -- @ticket FTTH-4314:
        -- Die fachliche Überprüfung der Webservice-Antwort, zum Beispiel "Auftrag gesperrt" mit Statuscode 409,
        -- findet nun im aufrufenden Programm anhand der pov-Argumente statt.
        -- Hier erfolgt kein fachliches RAISE und kein Logging mehr.

    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end p_webservice_post2;

-- @progress 2025-01-21

/**
  * Ruft den Webservice https://api-[].dss.svc.netcologne.intern/api/ftth/internal/order
  * mit einem POST-Request auf, um eine Vorbestellung im Glascontainer abzuschließen
  *
  * @param piv_kontext      [IN ] Aufrufendes System (derzeit nur: "PREORDERBUFFER")
  * @param piv_app_user     [IN ] APEX-Anwendungsnutzer zu Logging-Zwecken
  * @param pic_request_body [IN ] JSON mit den Daten verVorbestellung
  *
  *
  * @exception Der Body wird nicht geprüft - alle Exceptions werden geworfen.
  *
  * @ticket FTTH-4464: Liefert die orderId des neuen Auftrags im Preorderbuffer zurück
  */
    function fn_internal_order_post (
        piv_kontext  in varchar2,
        piv_app_user in varchar2,
        pic_body     in clob
    ) return ftth_ws_sync_preorders.id%type is

        v_ws_url             varchar2(255);
        v_ws_username        varchar2(255);
        v_ws_password        varchar2(255);
        v_ws_response        clob;
        v_ws_statuscode      integer;
        v_webservice_log_id  ftth_webservice_aufrufe.id%type; -- für den Fall, dass der Auftrag nicht erfolgreich vom Webserver
                                                         -- verarbeitet wird, können mit dieser ID die gesendeten Daten
                                                         -- ausgelesen werden
        v_uuid               ftth_ws_sync_preorders.id%type;
        v_rest_error_message varchar2(5000 char);
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name      constant logs.routine_name%type := 'fn_internal_order_post';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_kontext', piv_kontext);
            pck_format.p_add('piv_app_user', piv_app_user);
            pck_format.p_add('pic_body', pic_body);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------     
    begin
        if not g_webservices_enabled then
            return null;
        end if;

        -- Header clearen:
        p_init_webservice(
            piv_kontext     => kontext_preorderbuffer,
            piv_ws_key      => c_ws_key_internal_order_post,
            pov_ws_url      => v_ws_url,
            pov_ws_username => v_ws_username,
            pov_ws_password => v_ws_password
        );

        v_ws_response := apex_web_service.make_rest_request(
            p_url              => v_ws_url,
            p_http_method      => c_ws_method_post,
            p_username         => v_ws_username,
            p_password         => v_ws_password,
            p_transfer_timeout => c_ws_transfer_timeout,
            p_wallet_path      => c_ws_wallet_path,
            p_wallet_pwd       => c_ws_wallet_pwd,
            p_body             => pic_body
        );

        v_ws_statuscode := apex_web_service.g_status_code;
        begin
        -- @ticket FTTH-5025: Bei erfolgreicher Bestellung werden von Beginn an
        -- keine personenbezogenen Daten protokolliert:        
            if v_ws_statuscode = c_ws_statuscode_ok -- 200
             then -- Erfolgreich:
             -- (es gäbe auch die Option, diese erfolgreiche Bestellung erst gar nicht zu loggen)
                v_webservice_log_id := fn_log_webservice_aufruf(
                    piv_application         => piv_kontext,
                    piv_scope               => cv_routine_name,
                    piv_request_url         => c_loeschmarkierung,
                    piv_method              => c_ws_method_post,
                    piv_parameters          => null,
                    piv_parameter_values    => null,
                    piv_body                => c_loeschhinweis
                                || ' AM '
                                || to_char(sysdate, 'DD.MM.YYYY'),
                    piv_response_statuscode => v_ws_statuscode,
                    piv_app_user            => c_loeschmarkierung,
                    piv_errormessage        => substr(v_ws_response, 1, 255) -- v_ws_response vom vorigen Aufruf
                );

            else -- Nicht erfolgreich (HTTP-Response Statuscode ungleich 200):
             -- nur dann darf ein Log mit personenbezogenen Daten geschrieben werden. 
             -- Dieses wird nach einer vorgegeben Zeit gelöscht (siehe PCK_GLASCONTAINER.P_WEBSERVICE_LOGS_LOESCHEN)
                v_webservice_log_id := fn_log_webservice_aufruf(
                    piv_application         => piv_kontext,
                    piv_scope               => cv_routine_name,
                    piv_request_url         => v_ws_url,
                    piv_method              => c_ws_method_post,
                    piv_parameters          => null,
                    piv_parameter_values    => null,
                    piv_body                => dbms_lob.substr(pic_body, 4000, 1),
                    piv_response_statuscode => v_ws_statuscode,
                    piv_app_user            => piv_app_user,
                    piv_errormessage        => substr(v_ws_response, 1, 255) -- v_ws_response vom vorigen Aufruf
                );
            end if;
        -- Abfangen, falls nur der Log nicht stattgefunden hat:
        exception
            when others then
                pck_logs.p_error(
                    pic_message      => 'Webservice-Aufruf (Vorbestellung) durchgeführt, konnte aber nicht geloggt werden: '
                                   || chr(10)
                                   || fcl_params(),
                    piv_routine_name => qualified_name(cv_routine_name),
                    piv_scope        => g_scope -- COALESCE(piv_kontext, G_SCOPE)
                );
              -- kein RAISE
        end;

        if v_ws_statuscode <> c_ws_statuscode_ok then
            v_rest_error_message := pck_pob_rest.fv_get_error_message(piv_json_response => v_ws_response);
            raise e_request_not_successful;
        end if;    

        -- die Response kommt mit diesem Muster:
        -- {"orderId":"ulejmxVVGtUuPhiIMu4wooHFLWE0VN"}

        v_uuid := json_value(v_ws_response, '$.orderId' returning varchar2 error on error);
        if v_uuid is null then
            raise no_data_found;
        end if;
        return v_uuid;
    exception
        when no_data_found then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise_application_error(-20000, 'Der Bestell-Service lieferte keine Auftrags-ID zurück. Die Bestellung wurde möglicherweise nicht angelegt. '
                                            || 'Info für Admin: LOG_ID=['
                                            || v_webservice_log_id
                                            || ']');
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            if v_rest_error_message is null then
                v_rest_error_message := 'Der Auftrag konnte nicht erfolgreich verarbeitet werden.';
            end if;
            raise_application_error(-20000, v_rest_error_message
                                            || ' '
                                            || 'Info für Admin: LOG_ID=['
                                            || v_webservice_log_id
                                            || ']'
        -- das Log des fehlerhaften Vorbestellungsdatensatzes befindet sich hier:
        --     SELECT * -- insbesondere BODY, dort liegt das vollständige, gesendete JSON mit allen erfassten Daten
        --       FROM FTTH_WEBSERVICE_AUFRUFE
        --      WHERE ID = [WEBSERVICE_LOG_ID]
                                            || case
                when sqlcode <> -20042 then -- Dieser Fehlercode kommt immer, wenn der Server mit einer nichtssagenden
                                            -- Unzufriedenheitsmeldung quittiert, ohne SQLERRM, das kann man sich also sparen.
                                            -- Grund ist überlicherweise eine fehlgeschlagene Validierung der Daten,
                                            -- jedoch wird die Ursache nicht zurückgemeldet. 
                                            -- Die originale Fehlermeldung des Systems ("BFF", Backend for Frontend) findet sich stattdessen hier:
                                            -- @url (Entwicklung)
                                            --  https://testdock01dmz.netcologne.intern:9000/grafana/explore?left=%7B"datasource":"JJ_ifyhMz","queries":%5B%7B"datasource":%7B"type":"loki","uid":"JJ_ifyhMz"%7D,"editorMode":"code","expr":"%7Bswarm_stack%3D%5C"dss-pk-e%5C", swarm_service%3D~%60.%2A%28business-ftth-bff%29$%60%7D","queryType":"range","refId":"A"%7D%5D,"range":%7B"from":"now-3h","to":"now"%7D%7D&orgId=1
                                            -- @url (Produktion)
                                            --  https://proddock01dmz.netcologne.intern:9000/grafana/explore?left=%7B%22datasource%22:%22gTwldlhMz%22,%22queries%22:%5B%7B%22refId%22:%22A%22,%22datasource%22:%7B%22type%22:%22loki%22,%22uid%22:%22gTwldlhMz%22%7D,%22editorMode%22:%22builder%22,%22expr%22:%22%7Bswarm_service%3D%5C%22dss-pk_dss-business-ftth-bff%5C%22%7D%20%7C%3D%20%60%60%22,%22queryType%22:%22range%22%7D%5D,%22range%22:%7B%22from%22:%22now-3h%22,%22to%22:%22now%22%7D%7D&orgId=1
                    ', Original-Fehlercode: '
                    || sqlcode
                    || ', Original-Fehlermeldung: '
                    || sqlerrm
            end);

    end fn_internal_order_post;

/**
  * Ruft den Webservice https://api-[].dss.svc.netcologne.intern/api/ftth/internal/order/gk
  * mit einem POST-Request auf, um eine Vorbestellung im Glascontainer abzuschließen
  *
  * @param piv_kontext      [IN ] Aufrufendes System (derzeit nur: "PREORDERBUFFER")
  * @param piv_app_user     [IN ] APEX-Anwendungsnutzer zu Logging-Zwecken
  * @param pic_request_body [IN ] JSON mit den Daten verVorbestellung
  *
  *
  * @exception Der Body wird nicht geprüft - alle Exceptions werden geworfen.
  *
  */
    function fn_internal_order_gk_post (
        piv_kontext  in varchar2,
        piv_app_user in varchar2,
        pic_body     in clob
    ) return ftth_ws_sync_preorders.id%type is

        v_ws_url             varchar2(255);
        v_ws_username        varchar2(255);
        v_ws_password        varchar2(255);
        v_ws_response        clob;
        v_ws_statuscode      integer;
        v_webservice_log_id  ftth_webservice_aufrufe.id%type; -- für den Fall, dass der Auftrag nicht erfolgreich vom Webserver
                                                         -- verarbeitet wird, können mit dieser ID die gesendeten Daten
                                                         -- ausgelesen werden
        v_uuid               ftth_ws_sync_preorders.id%type;
        v_rest_error_message varchar2(5000 char);
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name      constant logs.routine_name%type := 'fn_internal_order_gk_post';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_kontext', piv_kontext);
            pck_format.p_add('piv_app_user', piv_app_user);
            pck_format.p_add('pic_body', pic_body);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------     
    begin
        if not g_webservices_enabled then
            return null;
        end if;

        -- Header clearen:
        p_init_webservice(
            piv_kontext     => kontext_preorderbuffer,
            piv_ws_key      => c_ws_key_internal_order_gk_post,
            pov_ws_url      => v_ws_url,
            pov_ws_username => v_ws_username,
            pov_ws_password => v_ws_password
        );

        v_ws_response := apex_web_service.make_rest_request(
            p_url              => v_ws_url,
            p_http_method      => c_ws_method_post,
            p_username         => v_ws_username,
            p_password         => v_ws_password,
            p_transfer_timeout => c_ws_transfer_timeout,
            p_wallet_path      => c_ws_wallet_path,
            p_wallet_pwd       => c_ws_wallet_pwd,
            p_body             => pic_body
        );

        v_ws_statuscode := apex_web_service.g_status_code;
        begin
        -- @ticket FTTH-5025: Bei erfolgreicher Bestellung werden von Beginn an
        -- keine personenbezogenen Daten protokolliert:        
            if v_ws_statuscode = c_ws_statuscode_ok -- 200
             then -- Erfolgreich:
             -- (es gäbe auch die Option, diese erfolgreiche Bestellung erst gar nicht zu loggen)
                v_webservice_log_id := fn_log_webservice_aufruf(
                    piv_application         => piv_kontext,
                    piv_scope               => cv_routine_name,
                    piv_request_url         => c_loeschmarkierung,
                    piv_method              => c_ws_method_post,
                    piv_parameters          => null,
                    piv_parameter_values    => null,
                    piv_body                => c_loeschhinweis
                                || ' AM '
                                || to_char(sysdate, 'DD.MM.YYYY'),
                    piv_response_statuscode => v_ws_statuscode,
                    piv_app_user            => c_loeschmarkierung,
                    piv_errormessage        => substr(v_ws_response, 1, 255) -- v_ws_response vom vorigen Aufruf
                );

            else -- Nicht erfolgreich (HTTP-Response Statuscode ungleich 200):
             -- nur dann darf ein Log mit personenbezogenen Daten geschrieben werden. 
             -- Dieses wird nach einer vorgegeben Zeit gelöscht (siehe PCK_GLASCONTAINER.P_WEBSERVICE_LOGS_LOESCHEN)
                v_webservice_log_id := fn_log_webservice_aufruf(
                    piv_application         => piv_kontext,
                    piv_scope               => cv_routine_name,
                    piv_request_url         => v_ws_url,
                    piv_method              => c_ws_method_post,
                    piv_parameters          => null,
                    piv_parameter_values    => null,
                    piv_body                => dbms_lob.substr(pic_body, 4000, 1),
                    piv_response_statuscode => v_ws_statuscode,
                    piv_app_user            => piv_app_user,
                    piv_errormessage        => substr(v_ws_response, 1, 255) -- v_ws_response vom vorigen Aufruf
                );
            end if;
        -- Abfangen, falls nur der Log nicht stattgefunden hat:
        exception
            when others then
                pck_logs.p_error(
                    pic_message      => 'Webservice-Aufruf (Vorbestellung GK) durchgeführt, konnte aber nicht geloggt werden: '
                                   || chr(10)
                                   || fcl_params(),
                    piv_routine_name => qualified_name(cv_routine_name),
                    piv_scope        => g_scope -- COALESCE(piv_kontext, G_SCOPE)
                );
              -- kein RAISE
        end;

        if v_ws_statuscode <> c_ws_statuscode_ok then
            v_rest_error_message := pck_pob_rest.fv_get_error_message(piv_json_response => v_ws_response);
            raise e_request_not_successful;
        end if;    

        -- die Response kommt mit diesem Muster:
        -- {"orderId":"ulejmxVVGtUuPhiIMu4wooHFLWE0VN"}

        v_uuid := json_value(v_ws_response, '$.orderId' returning varchar2 error on error);
        if v_uuid is null then
            raise no_data_found;
        end if;
        return v_uuid;
    exception
        when no_data_found then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise_application_error(-20000, 'Der GK Bestell-Service lieferte keine Auftrags-ID zurück. Die Bestellung wurde möglicherweise nicht angelegt. '
                                            || 'Info für Admin: LOG_ID=['
                                            || v_webservice_log_id
                                            || ']');
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            if v_rest_error_message is null then
                v_rest_error_message := 'Der Auftrag konnte nicht erfolgreich verarbeitet werden.';
            end if;
            raise_application_error(-20000, v_rest_error_message
                                            || ' '
                                            || 'Info für Admin: LOG_ID=['
                                            || v_webservice_log_id
                                            || ']'
        -- das Log des fehlerhaften Vorbestellungsdatensatzes befindet sich hier:
        --     SELECT * -- insbesondere BODY, dort liegt das vollständige, gesendete JSON mit allen erfassten Daten
        --       FROM FTTH_WEBSERVICE_AUFRUFE
        --      WHERE ID = [WEBSERVICE_LOG_ID]
                                            || case
                when sqlcode <> -20042 then -- Dieser Fehlercode kommt immer, wenn der Server mit einer nichtssagenden
                                            -- Unzufriedenheitsmeldung quittiert, ohne SQLERRM, das kann man sich also sparen.
                                            -- Grund ist überlicherweise eine fehlgeschlagene Validierung der Daten,
                                            -- jedoch wird die Ursache nicht zurückgemeldet. 
                                            -- Die originale Fehlermeldung des Systems ("BFF", Backend for Frontend) findet sich stattdessen hier:
                                            -- @url (Entwicklung)
                                            --  https://testdock01dmz.netcologne.intern:9000/grafana/explore?left=%7B"datasource":"JJ_ifyhMz","queries":%5B%7B"datasource":%7B"type":"loki","uid":"JJ_ifyhMz"%7D,"editorMode":"code","expr":"%7Bswarm_stack%3D%5C"dss-pk-e%5C", swarm_service%3D~%60.%2A%28business-ftth-bff%29$%60%7D","queryType":"range","refId":"A"%7D%5D,"range":%7B"from":"now-3h","to":"now"%7D%7D&orgId=1
                                            -- @url (Produktion)
                                            --  https://proddock01dmz.netcologne.intern:9000/grafana/explore?left=%7B%22datasource%22:%22gTwldlhMz%22,%22queries%22:%5B%7B%22refId%22:%22A%22,%22datasource%22:%7B%22type%22:%22loki%22,%22uid%22:%22gTwldlhMz%22%7D,%22editorMode%22:%22builder%22,%22expr%22:%22%7Bswarm_service%3D%5C%22dss-pk_dss-business-ftth-bff%5C%22%7D%20%7C%3D%20%60%60%22,%22queryType%22:%22range%22%7D%5D,%22range%22:%7B%22from%22:%22now-3h%22,%22to%22:%22now%22%7D%7D&orgId=1
                    ', Original-Fehlercode: '
                    || sqlcode
                    || ', Original-Fehlermeldung: '
                    || sqlerrm
            end);

    end fn_internal_order_gk_post;

-- @progress 2025-02-25

/**
 * Ruft den Webservice auf, der die Verfügbarkeit von Technologien an einer HAUS_LFD_NR zurückliefert,
 * und gibt den zurückerhaltenen Body, der diese Informationen enthält, im Erfolgsfall ungeparst zurück.
 *
 * @param pin_haus_lfd_nr  [IN] Laufende Nummer der Adresse, deren Technologie-Verfügbarkeit geprüft werden soll
 * @param piv_username     [IN] Der APEX-Benutzer, der diesen Service durch Interaktion aufruft
 *
 * @ticket FTTH-4456
 *
 * @exception Falls der Server nicht mit Statuscode 200 antwortet, wird eine Exception geworfen.
 *
 * @example  -- nachdem ACCESSIBLE BY (...) vorübergehend auskommentiert wird: 
 *          SELECT PCK_POB_REST.fv_availability(12345678, 'TEST12') from dual;
 *
 * @example -- Test-Aufruf im Browser (NMCE):
 * https://api-e.ncs.svc.netcologne.intern/availability?enableCaching=false&hausLfdNr=2280201 
 */
    function fv_availability (
        pin_haus_lfd_nr in integer,
        piv_username    in varchar2
    ) return varchar2
--    ACCESSIBLE BY(
--        PACKAGE PCK_GLASCONTAINER_ORDER
--       ,PACKAGE UT_GLASCONTAINER
--    )  
     is

        v_ws_url            varchar2(255);
        v_ws_response       clob;
        n_ws_statuscode     integer;
        v_webservice_log_id ftth_webservice_aufrufe.id%type;
        v_ws_username       varchar2(255);
        v_ws_password       varchar2(255);
        c_kontext           constant params.pv_key1%type := kontext_ncs_svc; 
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name     constant logs.routine_name%type := 'fv_availability';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_haus_lfd_nr', pin_haus_lfd_nr);
            pck_format.p_add('piv_username', piv_username);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
  -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------       
    begin
        if not g_webservices_enabled then
            raise e_request_not_successful;
        end if;

        -- Header clearen:
        p_init_webservice(
            piv_kontext     => c_kontext,
            piv_ws_key      => c_ws_key_availability,
            pov_ws_url      => v_ws_url,
            pov_ws_username => v_ws_username -- wird nicht weiterverwendet
            ,
            pov_ws_password => v_ws_password -- wird nicht weiterverwendet
        );

        -- Da die HAUS_LFD_NR in der URL vorkommt, diese ersetzen:
        v_ws_url := replace(v_ws_url, c_ws_hauslfdnr_token, pin_haus_lfd_nr);   

-- Beispiel-URL in NMCE:
-- v_ws_url := 'https://api-e.ncs.svc.netcologne.intern/availability?enableCaching=false&hausLfdNr=' || pin_haus_lfd_nr;

        v_ws_response := apex_web_service.make_rest_request(
            p_url              => v_ws_url,
            p_http_method      => c_ws_method_get
        --, p_username         => v_ws_username
        --, p_password         => v_ws_password
            ,
            p_transfer_timeout => c_ws_transfer_timeout,
            p_wallet_path      => c_ws_wallet_path,
            p_wallet_pwd       => c_ws_wallet_pwd,
            p_body             => null
        );

        n_ws_statuscode := apex_web_service.g_status_code;
        begin
            v_webservice_log_id := fn_log_webservice_aufruf(
                piv_application         => c_kontext,
                piv_scope               => cv_routine_name,
                piv_request_url         => v_ws_url,
                piv_method              => c_ws_method_get,
                piv_parameters          => 'hausLfdnr',
                piv_parameter_values    => pin_haus_lfd_nr,
                piv_body                => null,
                piv_response_statuscode => n_ws_statuscode,
                piv_app_user            => piv_username,
                piv_errormessage        =>
                                  case
                                      when n_ws_statuscode <> c_ws_statuscode_ok then
                                          substr(v_ws_response, 1, 255)
                                  end,
                piv_response_body       =>
                                   case
                                       when n_ws_statuscode = c_ws_statuscode_ok then
                                           substr(v_ws_response, 1, 4000)
                                   end
            ); 
        -- Abfangen, falls nur der Log nicht stattgefunden hat:
        exception
            when others then
                pck_logs.p_error(
                    pic_message      => 'Webservice-Aufruf (Availability Check) durchgeführt, konnte aber nicht geloggt werden: '
                                   || chr(10)
                                   || fcl_params(),
                    piv_routine_name => qualified_name(cv_routine_name),
                    piv_scope        => g_scope
                );
              -- kein RAISE
        end;

        case n_ws_statuscode
            when c_ws_statuscode_ok then
                return v_ws_response; -- aufrufendes Programm parst.

            when c_ws_statuscode_bad_request then
                raise e_request_not_successful;       -- unbekannter Fehler
            when c_ws_statuscode_server_error then
                raise e_request_server_error;         -- technischer Fehler
            when c_ws_statuscode_precondition then
                raise e_request_argument_fehlerhaft;  -- fachlicher Fehler: Muss vom Aufrufer behandelt werden
            when c_ws_statuscode_unprocessable then
                raise e_request_nicht_verarbeitbar;   -- Status 422: "Diese Seite funktioniert im Moment nicht" => üblicherweise eine unbekannte HAUS_LFD_NR
            else
                raise_application_error(-20000 - abs(n_ws_statuscode),
                                        'Unbekannter Fehler, Statuscode ' || n_ws_statuscode);
        end case;

    exception
        when e_request_nicht_verarbeitbar then -- unbekannte HAUS_LFD_NR
            raise_application_error(pck_pob_rest.c_request_nicht_verarbeitbar, 'Ungültige HAUS_LFD_NR '
                                                                               || pin_haus_lfd_nr
                                                                               || ' für den Anschlusscheck');
        -- Loggen muss ggf. der Aufrufer
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end fv_availability;

-- @progress 2025-03-04

/**
 * Überschreibt alle personenbezogenen Daten in der Tabelle FTTH_WEBSERVICE_AUFRUFE,
 * die älter als 90 Tage sind (bzw. kürzeres Zeitfenster durch optionalen Parameter pin_anzahl_tage),
 * und löscht die ältesten Einträge (älter als 1 Jahr, nicht änderbar) vollständig aus der Tabelle
 *
 * pin_anzahl_tage  [IN]  Nur nötig zu setzen, falls das vorgegebene Zeitfenster
 *                        von 90 Tagen verringert werden soll. Werte > 90 führen zu
 *                        keiner Verlängerung des Lösch-Zeitfensters, damit die Vorgaben der 
 *                        Datenhaltung nicht untergraben werden können.
 *
 * @ticket FTTH-5025
 * @throws Fehler werden geloggt und geworfen
 * @usage  Nächtlicher Aufruf durch Job "JOB_GLASCONTAINER_BEREINIGEN" über PCK_GLASCONTAINER_JOBS
 *
 * @example BEGIN PCK_POB_REST.p_webservice_logs_loeschen(pin_anzahl_tage => 30); END;
 * @unittest  SELECT * FROM TABLE(ut.run('UT_GLASCONTAINER', a_tags => 'p_webservice_logs_loeschen')); 
 */
    procedure p_webservice_logs_loeschen (
        pin_anzahl_tage in natural default null
    )
        accessible by ( pck_glascontainer_jobs, ut_glascontainer )
    is

        c_anzahl_tage   constant naturaln := least(90,
                                                 coalesce(
                                                       abs(pin_anzahl_tage),
                                                       90
                                                   )); -- üblicherweise = 90
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'p_webservice_logs_loeschen';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_anzahl_tage', pin_anzahl_tage);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------     
    begin

    -- Die folgenden Logs stammen von fehlerhaften Webservice-Aufrufen.
    -- Nach 90 Tagen werden deren personenbezogene Daten überschrieben.
    -- (siehe unten: Nach spätestens 365 Tagen werden auch diese Einträge endgültig gelöscht)
        update ftth_webservice_aufrufe                                    
           -- Kundendaten:
        set
            body = c_loeschhinweis
                   || ' AM '
                   || to_char(sysdate, 'DD.MM.YYYY'),
            parameter_values = null,
            request_url = c_loeschmarkierung
           -- Mitarbeiterdaten:
            ,
            app_user = c_loeschmarkierung -- Kennzeichen, dass hier bereits die erforderlichen Daten gelöscht wurden
         -- indem man die Löschmarkierung nur dann setzt, wenn es eine Errormessage gab,
         -- kann man auch später noch erkennen _ob_ es eine Errormessage gab oder nicht.
            ,
            errormessage =
                case
                    when errormessage is not null then
                        c_loeschmarkierung
                end
        where
                trunc(uhrzeit) < trunc(sysdate) - c_anzahl_tage
            and method = c_ws_method_post
     --  AND NVL(app_user, '-') <> C_LOESCHMARKIERUNG -- damit nicht ewig weiter upgedatet wird...
            ;

    -- Alle Logs werden nach spätestens einem Jahr gelöscht:
        delete ftth_webservice_aufrufe
        where
            trunc(uhrzeit) < trunc(sysdate) - 365;

    -- Bestehende GET-Aufrufe interessieren überhaupt nicht mehr und neue werden nicht mehr erstellt,
    -- das gleiche gilt für Aufrufe mit Statuscode 200 (Erfolg):
        delete ftth_webservice_aufrufe
        where
            ( method = c_ws_method_get
              or response_statuscode = '200' );

    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end p_webservice_logs_loeschen;

    -- @progress 2025-07-18

    /**
     * Function um Fehlernachricht über den Error Code zu ermitteln
     *
     * pin_error_code  [IN]   Error Code
     *
     * @ticket FTTH-4993
     * @throws Fehler werden geloggt und geworfen
     * @usage  Helper Function
     */
    function fv_get_error_message (
        piv_error_code in varchar2
    ) return varchar2 as

        cv_routine_name constant logs.routine_name%type := 'fv_get_error_message';
        lv_return       varchar2(5000 char);

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_error_code', piv_error_code);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;

    begin
        if piv_error_code is not null then
            select
                display
            into lv_return
            from
                v_ftth_rest_error_codes
            where
                return = piv_error_code;

        else
            lv_return := null;
        end if;

        return lv_return;
    exception
        when no_data_found then
            return null;
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end fv_get_error_message;

    /**
     * Function um Fehlernachricht über den JSON Reposne Code zu ermitteln
     *
     * piv_json_response  [IN]   JSON Response Body
     *
     * @ticket FTTH-4993
     * @throws Fehler werden geloggt und geworfen
     * @usage  Helper Function
     */
    function fv_get_error_message (
        piv_json_response in varchar2
    ) return varchar2 as

        cv_routine_name constant logs.routine_name%type := 'fv_get_error_message';
        lv_return       varchar2(5000 char);
        lv_error_code   varchar2(100 char);

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_json_response', piv_json_response);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;

    begin
        if piv_json_response is null then
            return null;
        end if;
        select
            error_code
        into lv_error_code
        from
            json_table ( piv_json_response, '$'
                columns (
                    error_code varchar2 ( 4000 char ) path '$.code'
                )
            );

        lv_return := fv_get_error_message(piv_error_code => lv_error_code);
        return lv_return;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end fv_get_error_message;

/**
 * FTTH-869
 * Nimmt den vorbereiteten JSON-Body entgegen und sendet die Änderungsbenachrichtigung
 * an den Webservice Provider-Change
 *
 * @param pic_body        [IN ] Vorbereiteter JSON-Body,
 *                        z.B. {"status":"UNDER_CONSTRUCTION","availabilityDate":"2023-12-31","houseSerialNumberList":[1132466,1133709,1133715]}
 * @param piv_username    [IN ] APEX-Benutzer, der den Vorgang durchführt 
 *                        (zu Protokollierungszwecken, darf auch leer bleiben)
 */
    procedure p_provider_change_post (
        pic_body     in clob,
        piv_username in varchar2,
        piv_uuid     in varchar2
    ) is

        v_ws_url             varchar2(255);
        v_ws_username        varchar2(255);
        v_ws_password        varchar2(255);
        v_ws_response        clob;
        v_ws_statuscode      integer;
        v_rest_error_message varchar2(5000 char);
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name      constant logs.routine_name%type := 'p_provider_change_post';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pic_body',
                             dbms_lob.substr(pic_body, 1000, 1));
            pck_format.p_add('piv_username', piv_username);
            pck_format.p_add('piv_uuid', piv_uuid);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
  -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------     
    begin
        if not g_webservices_enabled then
            return;
        end if;

    -- Header clearen:
        p_init_webservice(
            piv_kontext     => kontext_preorderbuffer,
            piv_ws_key      => 'PROVIDER_CHANGE',
            pov_ws_url      => v_ws_url,
            pov_ws_username => v_ws_username,
            pov_ws_password => v_ws_password
        );

        v_ws_url := replace(v_ws_url, c_ws_orderid_token, piv_uuid);
        v_ws_response := apex_web_service.make_rest_request(
            p_url              => v_ws_url,
            p_http_method      => c_ws_method_post,
            p_username         => v_ws_username,
            p_password         => v_ws_password,
            p_transfer_timeout => c_ws_transfer_timeout,
            p_wallet_path      => c_ws_wallet_path,
            p_wallet_pwd       => c_ws_wallet_pwd,
            p_body             => pic_body
        );

        v_ws_statuscode := apex_web_service.g_status_code;
        p_log_webservice_aufruf(
            piv_application         => g_app_id_glascontainer,
            piv_scope               => cv_routine_name,
            piv_request_url         => v_ws_url,
            piv_method              => c_ws_method_post,
            piv_parameters          => 'ID',
            piv_parameter_values    => piv_uuid,
            piv_body                => dbms_lob.substr(pic_body, 4000, 1),
            piv_response_statuscode => v_ws_statuscode,
            piv_app_user            => piv_username,
            piv_errormessage        => v_ws_response
        );

        if v_ws_statuscode <> c_ws_statuscode_ok then
            v_rest_error_message := pck_pob_rest.fv_get_error_message(piv_json_response => v_ws_response);
            if v_rest_error_message is null then
                if v_ws_statuscode is not null then
                    v_rest_error_message := pck_glascontainer.fv_http_statusmessage(v_ws_statuscode);
                else
                    v_rest_error_message := 'Es ist ein unerwarteter Fehler aufgetreten!';
                end if;

            end if;

            raise e_request_not_successful;
        end if;

    exception
        when e_request_not_successful then
            raise_application_error(-20000 - v_ws_statuscode, v_rest_error_message);
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end p_provider_change_post;

--------------------------------------------------------------------------------  
-- Package-Initialisierung                                                    --
--------------------------------------------------------------------------------

begin
    if core.pck_env.fv_db_name in ( 'NMCX3' ) then
        g_webservices_enabled := false;
    end if;
end;
/

