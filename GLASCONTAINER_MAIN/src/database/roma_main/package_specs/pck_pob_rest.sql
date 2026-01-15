create or replace package pck_pob_rest as 
/**
 * Routinen, die von anderen Packages für die Aussendung
 * von REST Web Service Calls im Zusammenhang mit dem FTTH Preorderbuffer (POB)
 * genutzt werden
 *
 *
 * @author   Andreas Wismann  <wismann@when-others.com>
 * @creation 2023-04
 *
 * @status: in Arbeit.
 *          1. Alle bisherigen Routinen aus dem PCK_GLASCONTAINER und PCK_FUZZYDOUBLE nach hier kopieren (nicht verschieben!)
 *          2. prüfen, ob p_preorders_post funktioniert, anstatt des Originals im PCK_GLASCONTAINER
 *          3. Erste echte Implementierung: PCK_VERMARKTUNGSCLUSTER, @ticket FTTH-1787
 *          3. Methodenaufrufe sukzessive umstellen und testen
 *          4. Package nach PROD deployen
 *
 * @example: Neuen Webservice einrichten
 * DECLARE
 *   v_params  CORE.PARAMS%ROWTYPE;
 * BEGIN
 *   -- Eintrag definieren:
 *   v_params.pv_environment  := 'ALL';
 *   v_params.pv_satzart      := 'WEBSERVICE';
 *   v_params.pv_key1         := 'PREORDERBUFFER';
 *   v_params.pv_key2         := 'CONNECTIVITY_ID_INCREMENT';
 *   v_params.v_wert1         := 'preorder/{orderId}/connectivity-id/{connectivityId}/increment';
 *   v_params.v_beschreibung  := '@ticket FTTH-3815: API zur Erzeugen einer neuen Externen Auftragsnummer. Liefert die neue ID im Response Body zurück.';
 *   
 *   CORE.PCK_PARAMS_DML.p_merge(v_params); -- Eintrag anlegen oder aktualisieren
 * END; 
 */

  -- Umlaut-Test: ÄÖÜäöüß
  -- Eurozeichen: ? -- SELECT UNISTR('\20AC') FROM DUAL

    version constant varchar2(30) := '2025-04-23 1530';
    g_webservices_enabled boolean := true;  -- @odo Überbleibsel aus den ersten Tagen des Glascontainers, man kann entscheiden
                                          -- ob Web Services überhaupt verwendet werden sollen.
                                          -- Dieses Feature unktioniert weiterhin, ist aber inzwischen nicht mehr notwendig

    kontext_preorderbuffer constant params.pv_key1%type := 'PREORDERBUFFER';
    kontext_ncs_svc constant params.pv_key1%type := 'NCS.SVC'; -- @ticket FTTH-4456, FTTH-4814
                                                                         -- "NetCologne Sites, Service Cluster"

  -- KONTEXT_GLASCONTAINER       CONSTANT params.pv_key1%TYPE := 'GLASCONTAINER';  -- //// wo verwendet?
  -- KONTEXT_VERMARKTUNGSCLUSTER CONSTANT params.pv_key1%TYPE := 'VERMARKTUNGSCLUSTER';  -- //// wo zu verwenden?

  -- Fehlermeldungen aus diesem Package benutzen diesen Scope:
    g_scope constant logs.scope%type := 'POB';
    g_app_id_glascontainer number := 2022;
    c_ws_method_get constant ftth_webservice_aufrufe.method%type := 'GET';
    c_ws_method_put constant ftth_webservice_aufrufe.method%type := 'PUT';
    c_ws_method_post constant ftth_webservice_aufrufe.method%type := 'POST';  

  -- Diese Schlüssel in der Tabelle PARAMS werden abgefragt:
  -- SELECT * FROM PARAMS WHERE PV_SATZART = 'WEBSERVICE' AND PV_KEY1 = 'PREODERBUFFER' AND PV_KEY2 = ...
    c_ws_key_preorders_get constant core.params.pv_key2%type := 'PREORDERS_GET';
    c_ws_key_preorders_post constant core.params.pv_key2%type := 'PREORDERS_POST'; -- ///@todo: umbenennen zu irgendwas mit "Produktänderung"
    c_ws_key_preorders_cancel constant core.params.pv_key2%type := 'PREORDERS_CANCEL';
    c_ws_key_order_history constant core.params.pv_key2%type := 'ORDER_HISTORY';
    c_ws_key_siebel_process constant core.params.pv_key2%type := 'SIEBEL_PROCESS';
    c_ws_key_wholebuy_objektmeldung_post constant core.params.pv_key2%type := 'WHOLEBUY_OBJEKTMELDUNG_POST';
    c_ws_key_comments_get constant core.params.pv_key2%type := 'COMMENTS_GET';
    c_ws_key_comments_post constant core.params.pv_key2%type := 'COMMENTS_POST';
    c_ws_key_internal_order_post constant core.params.pv_key2%type := 'INTERNAL_ORDER_POST';
    c_ws_key_internal_order_gk_post constant core.params.pv_key2%type := 'INTERNAL_ORDER_GK_POST';
    c_ws_key_connectivity_id_increment constant core.params.pv_key2%type := 'CONNECTIVITY_ID_INCREMENT';
    c_ws_key_availability constant core.params.pv_key2%type := 'AVAILABILITY';

  -- Dieser Bestandteil muss durch die tatsächliche orderId (=UUID) ersetzt werden,
  -- wenn er in der URL (PARAMS.v_wert1) vorkommt:
    c_ws_orderid_token constant core.params.v_wert2%type := '{orderId}';
  -- Das Gesagte gilt ebenso für die HAUS_LFD_NR:
    c_ws_hauslfdnr_token constant core.params.v_wert2%type := '{HAUS_LFD_NR}';

  -- Wallet, das bei jedem Webservice-Aufruf verwendet wird
    c_ws_wallet_path constant varchar2(100) := 'file:/oracle/app/oracle/wallet/';

  -- Wallet-Passwort, das bei jedem Webservice-Aufruf verwendet wird
    c_ws_wallet_pwd constant varchar2(100) := 'wbci2015';

  -- Zeit in Sekunden, die ein Webservice-Aufruf bereit ist zu warten (Oracle-Default: 180!)
    c_ws_transfer_timeout constant naturaln := 10;
    c_ws_statuscode_ok constant ftth_webservice_aufrufe.response_statuscode%type := '200';
    c_ws_statuscode_bad_request constant ftth_webservice_aufrufe.response_statuscode%type := '400'; -- Üblicherweise: nicht konformer Body oder URL seitens des Aufrufers
    c_ws_statuscode_unauthorized constant ftth_webservice_aufrufe.response_statuscode%type := '401'; -- 2022-12-12 Erstmals bei den Stornogründen aufgetreten
    c_ws_statuscode_not_found constant ftth_webservice_aufrufe.response_statuscode%type := '404'; -- tritt sowohl auf, wenn man eine nicht mehr
                                                                                                    -- bestehende UUID aktualisiert,
                                                                                                    -- als auch wenn der WS insgesamt offline ist
    c_ws_statuscode_conflict constant ftth_webservice_aufrufe.response_statuscode%type := '409'; -- Technisches Problem: Auftrag ist gesperrt (2022-09-14 auf [S]) z.B. durch POST aus zwei offenen Tabs
    c_ws_statuscode_precondition constant ftth_webservice_aufrufe.response_statuscode%type := '412'; -- Fachliches Problem, z.B. eine zu ändernde ConnectivityID existiert nicht (@ticket FTTH-3815)
    c_ws_statuscode_unprocessable constant ftth_webservice_aufrufe.response_statuscode%type := '422'; -- Fachliches Problem, z.B. eine ConnectivityID kann nicht weiter inkrementiert werden,
                                                                                                    -- oder der Anschlusscheck meldet "Diese Seite funktioniert im Moment nicht"
    c_ws_statuscode_server_error constant ftth_webservice_aufrufe.response_statuscode%type := '500'; -- Internal Server Error, 2022-08-31 als Antwort auf das Speichern: Kunden waren gelockt
    c_ws_statuscode_bad_gateway constant ftth_webservice_aufrufe.response_statuscode%type := '502'; -- Bad Gateway, beispielsweise läuft der Webservice/Liquibase nicht (@Ticket FTTH-1872)
    c_ws_statuscode_unavailable constant ftth_webservice_aufrufe.response_statuscode%type := '503'; -- Service Unavailable

  -- Wenn nicht im Detail klar ist, warum ein Webservice-Aufruf gescheitert ist, geben wir diesen allgemeinen Fehler zurück.
  -- Leider lässt sich oft anhand des HTTP-Status, den der Webservice zurückgibt (400, 404) nicht erkennen was genau schiefgelaufen ist,
  -- da keine Fehlerbeschreibung im Body mitgesendet wird. Schade.
    e_request_not_successful exception;
    c_request_not_successful constant integer := -20042; -- 42 kann alles Mögliche sein... wir wissen es nicht
    pragma exception_init ( e_request_not_successful,
    c_request_not_successful );  

  -- Ab 2024-10 versuchen wir, die Schnittstellen schlauer zu machen, indem in bestimmten Fällen (@ticket FTTH-3815, @ticket FTTH-4314)
  -- ein vereinbarter HTTP Statuscode einen fachlichen Fehler kennzeichnet:

    e_request_auftrag_gesperrt exception;
    c_request_auftrag_gesperrt constant integer := -20409; -- entspricht HTTP Statuscode 409 "Conflict", @ticket FTTH-4314: //// konsoliudieren
    pragma exception_init ( e_request_auftrag_gesperrt,
    c_request_auftrag_gesperrt );
    e_request_argument_fehlerhaft exception;  -- entspricht C_WS_STATUSCODE_PRECONDITION, siehe @ticket FTTH-3815
    c_request_argument_fehlerhaft constant integer := -20412; -- entspricht HTTP Statuscode 412 "Precondition Failed"
    pragma exception_init ( e_request_argument_fehlerhaft,
    c_request_argument_fehlerhaft );
    e_request_nicht_verarbeitbar exception;  -- entspricht C_WS_STATUSCODE_UNPROCESSABLE, siehe @ticket FTTH-3815
    c_request_nicht_verarbeitbar constant integer := -20422; -- entspricht HTTP Statuscode 422 "Unprocessable Entity"
    pragma exception_init ( e_request_nicht_verarbeitbar,
    c_request_nicht_verarbeitbar );
    e_request_server_error exception;
    c_request_server_error constant integer := -20500; -- entspricht HTTP Statuscode 500 "Internal Server Error"
    pragma exception_init ( e_request_server_error,
    c_request_server_error );
    c_satzart_webservice constant core.params.pv_satzart%type := 'WEBSERVICE';
    c_satzart_fuzzydouble constant core.params.pv_satzart%type := 'FUZZYDOUBLE';
    c_empty_json constant varchar2(2) := '{}';
    json_true constant varchar2(5) := 'true';
    json_false constant varchar2(5) := 'false';
    c_loeschmarkierung constant varchar2(1) := '*'; -- @ticket FTTH-5025: Markiert einen gelöschten APP-Usernamen
    c_loeschhinweis constant varchar2(100) := 'DATEN ENTFERNT';

  /**
  * Gibt den Versionsstring des Package Bodies zurück
  */
    function get_body_version return varchar2
        deterministic;  

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
        accessible by ( package pck_vermarktungscluster );



  /**
  * Liest die Zugangsdaten für den preorders-Webservice ein (falls nicht bereits geschehen)
  * und löscht alle Request Headers, so dass anschließend ein GET oder POST gegen diesen
  * Webservice durchgeführt werden kann
  *
  * @param piv_kontext     [IN ] Aufrufendes System (derzeit nur: PREORDERBUFFER)  
  * @param piv_ws_key      [IN ] Schlüssel für die Art des Webservices: PREORDERS GET|PREORDERS POST|AUFTRAG_STORNIEREN
  *
  * @param pov_ws_url      [OUT] Basis-URL für den Aufruf, passend zur jeweiligen Umgebung
  * @param pov_ws_username [OUT] Benutzername für den Aufruf, passend zur jeweiligen Umgebung
  * @param pov_ws_password [OUT] Passwort für den Aufruf, passend zur jeweiligen Umgebung
  *
  * @date 2023-01-25
  *
  * @usage Die Zugangsdaten befinden sich in der Tabelle CORE.PARAMS
  *
  * @example
  * DECLARE
  *   v_ws_url       VARCHAR2(1000);
  *   v_ws_username  VARCHAR2(1000);
  *   v_ws_password  VARCHAR2(1000);
  * BEGIN
  *   PCK_POB_REST.P_INIT_WEBSERVICE (
  *         piv_kontext     => 'PREORDERBUFFER',
  *         piv_ws_key      => 'WHOLEBUY',
  *         pov_ws_url      => v_ws_url,
  *         pov_ws_username => v_ws_username,
  *         pov_ws_password => v_ws_password
  *         );
  *   DBMS_OUTPUT.PUT_LINE(
  *         'v_ws_url = '      || v_ws_url || CHR(10) ||
  *         'v_ws_username = ' || v_ws_username
  *   );        
  * END;  
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
    ;



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
    );



  /**
  * Gibt die Server-Basis-URL des Webservices "PreOrderBuffer" zurück
  *
  * @param piv_kontext     [IN ] Aufrufendes System (derzeit nur: PREORDERBUFFER)
  */
    function base_url (
        piv_kontext in varchar2 default kontext_preorderbuffer
    ) return varchar2; 



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
  * @exception Der Body wird nicht geprüft - alle Exceptions werden geworfen.

  PROCEDURE p_webservice_post (
      piv_kontext    IN VARCHAR2,
      piv_ws_key     IN VARCHAR2,
      piv_uuid       IN VARCHAR2,
      piv_app_user   IN VARCHAR2,
      pic_body       IN CLOB
  );
  */ -- @ticket FTTH-4314: Diese Prozedur ist @deprectated und wurde überall ersetzt durch p_webservice_post2

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
        accessible by ( ut_glascontainer );

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
    );    



  /**
  * Erlaubt es, den Webservice-Testmodus auf TRUE zu setzen
  */
    procedure p_enable_webservices (
        pib_enabled in boolean default true
    );  



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
 * @deprecated @ticket FTTH-4390 Dieser Job läuft in der Produktion seit Monaten auf einen Fehler 
 */
    procedure p_wholebuy_post_objektmeldung (
        pic_body        in clob,
        piv_application in varchar2 default null
    );



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
        accessible by ( package pck_glascontainer_order, package ut_glascontainer );

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
        accessible by ( package pck_glascontainer_order, package ut_glascontainer );

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
  * @usage Funktioniert zunächst wie P_WEBSERVICE_POST, jedoch mit Rückgabe des Bodys, damit dieser ausgewertet werden kann
  * @ticket FTTH-4021
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
    );

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
    ) return ftth_ws_sync_preorders.id%type;

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
  * @ticket FTTH-4464: Liefert die orderId des neuen Auftrags im Preorderbuffer zurück 
  */
    function fn_internal_order_gk_post (
        piv_kontext  in varchar2,
        piv_app_user in varchar2,
        pic_body     in clob
    ) return ftth_ws_sync_preorders.id%type;

-- @progress 2025-02-05

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
    ;

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
 * @example    BEGIN PCK_POB_REST.p_webservice_logs_loeschen(pin_anzahl_tage => 30); END;
 * @unit_test  SELECT * FROM TABLE(ut.run('UT_GLASCONTAINER', a_tags => 'p_webservice_logs_loeschen'));
 */
    procedure p_webservice_logs_loeschen (
        pin_anzahl_tage in natural default null
    )
        accessible by ( pck_glascontainer_jobs, ut_glascontainer );

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
    ) return varchar2;

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
    ) return varchar2;

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
    );

end pck_pob_rest;
/


-- sqlcl_snapshot {"hash":"2fe7b89e352f145ab4cf20c78bb20ae0ac42902c","type":"PACKAGE_SPEC","name":"PCK_POB_REST","schemaName":"ROMA_MAIN","sxml":""}