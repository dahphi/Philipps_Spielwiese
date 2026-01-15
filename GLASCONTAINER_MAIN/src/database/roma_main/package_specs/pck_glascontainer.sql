create or replace package roma_main.pck_glascontainer as 
/** 
 * Programmcode zur APEX-Anwendung 2022 "Glascontainer" 
 * 
 * @author Andreas Wismann (WISAND) <wismann@when-others.com> 
 * 
 * @unittest
 * SELECT * FROM ROMA_MAIN.UT.RUN('UT_GLASCONTAINER'); 
 * 
 */ 

  -- Test auf Umlaute/Euro: ÄÖÜäöüß/? 

  -- Wird angezeigt auf der Seite 10050 "Über diese Anwendung". 
  -- Der gesamte String sollte als Ganzes aufsteigend sortierbar sein 
  -- (an erster Stelle ist also das Datum maßgeblich) 
  -- so dass die aktuellere Version stets lexikalisch "später" einsortiert werden kann. 
    version constant varchar2(30) := '2025-06-11 1100'; 
  -- (Ändderung G_SCOPE von POB zu GLASCONTAINER)

    c_workspace_glascontainer constant varchar2(100) := 'ROMA'; -- der APEX-Workspace, in dem der Glascontainer ausgeführt wird

  -- Schlüsselwert (key1) für alle Einträge in der Tabelle CORE.PARAMS aus dieser Applikation 
    glascontainer constant params.pv_key1%type := 'GLASCONTAINER';   

  -- Alle Fehlermeldungen aus diesem Package benutzen diesen Scope: 
    g_scope constant logs.scope%type := 'GLASCONTAINER'; -- 2025-03-04: ersetzt 'POB', damit doppeltes Logging besser unterschieden werden kann  

  -- Diese Exception wird von allen Methoden geworfen, die zwar bereits 
  -- über eine Spezifikation verfügen, jedoch noch auf ihre Implementierung warten 
    e_not_implemented exception;
    e_offlinemodus exception;
    c_offlinemodus constant integer := -20100; -- siehe APEX (P20) Region "OFFLINE-Modus", P20_WS_ERRORCODE. war: -20002 (Konflikt) 
    pragma exception_init ( e_offlinemodus,
    c_offlinemodus );
    e_order_is_locked exception;
    c_order_is_locked constant integer := -20003;
    pragma exception_init ( e_order_is_locked,
    c_order_is_locked );
    c_satzart_webservice constant core.params.pv_satzart%type := 'WEBSERVICE';
    c_satzart_fuzzydouble constant core.params.pv_satzart%type := 'FUZZYDOUBLE';
    c_ws_key_preorders_get constant core.params.pv_key2%type := 'PREORDERS_GET';
    c_ws_key_preorders_post constant core.params.pv_key2%type := 'PREORDERS_POST'; -- ///@todo: umbenennen zu irgendwas mit "Produktänderung" 
    c_ws_key_preorders_landlord_post constant core.params.pv_key2%type := 'PREORDERS_LANDLORD_POST';
    c_ws_key_preorders_cancel constant core.params.pv_key2%type := 'PREORDERS_CANCEL';
    c_ws_key_preorders_history_get constant core.params.pv_key2%type := 'PREORDERS_HISTORY_GET';
    c_ws_orderid_token constant core.params.v_wert2%type := '{orderId}';
    c_ws_static_id_preorders constant varchar2(100) := 'preorders_';                -- siehe APEX > Shared Components > REST Data Sources 
    c_ws_static_id_cancellationreasons constant varchar2(100) := 'cancellationReasons_';
    c_ws_modus_online_and_offline constant varchar2(30) := 'ONLINE_AND_OFFLINE';
    c_ws_modus_online constant varchar2(30) := 'ONLINE';
    c_ws_modus_offline constant varchar2(30) := 'OFFLINE'; -- hierbei sind Bearbeitungen im Glascontainer immer unterbunden

    c_plausi_error_number constant integer := -20002;
    e_plausi_error exception;
    pragma exception_init ( e_plausi_error,
    c_plausi_error_number );
    c_application_error_number constant integer := -20000;
    c_failed_uuid constant integer := -20001;
    e_failed_product_specs exception;
    c_failed_product_specs constant integer := -20010;
    pragma exception_init ( e_failed_product_specs,
    c_failed_product_specs );
    c_failed_siebel_specs constant integer := -20011; -- @deprecated: jetzt im PCK_GLASCONTAINER_EXT / Löschen im Dezember 2024
    c_http_request_failed constant integer := -29273; -- neu 2022-10-05: "ORA-29273: HTTP-Anforderung nicht erfolgreich" 
  -- Falls der Webservice gar nicht mehr erreichbar ist, 
  -- z.B. während eines Deployments der Umgebung 

    c_fuzzy_status_self constant ftth_preorders_fuzzydouble.status%type := 'S';    -- @deprecated, ////@todo bitte entfernen - war: Die eigene Kundennummer wurde gefunden -- wird nicht abgespeichert 
    c_fuzzy_status_empty constant ftth_preorders_fuzzydouble.status%type := 'NA';  -- Es wurde kein Ergebnis gefunden 

    c_ftth constant varchar2(10) := 'FTTH';

  -- Festlegung, wie lang eine UUID sein darf 
    subtype t_uuid is varchar2(100);
    type t_lov_entry is record (
            d varchar2(255), -- Display Value 
            r varchar2(100) -- Return Value 
    );
    type t_lov is
        table of t_lov_entry; 

  -- Maximale Länge eines ENUM-Auflistungstyps: 
    subtype t_enum is varchar2(50) not null; 

  -- @ticket FTTH-2722: Rollenkonzept wurde erweitert 
    c_rolle_readonly constant varchar2(100) := 'AccApp FTTHAgentView - ReadOnly';
    c_rolle_user constant varchar2(100) := 'AccApp FTTHAgentView - User';
    c_rolle_superuser constant varchar2(100) := 'AccApp FTTHAgentView - Superuser';
    c_rolle_administrator constant varchar2(100) := 'AccApp FTTHAgentView - Adminstrator'; -- der Tippfehler hat sich dauerhaft im Active Directory eingeschlichen 

    c_rollenliste_administrator constant varchar2(4000) := c_rolle_administrator
                                                           || ','
                                                           || c_rolle_superuser
                                                           || ','
                                                           || c_rolle_user
                                                           || ','
                                                           || c_rolle_readonly;
    c_rollenliste_superuser constant varchar2(4000) := c_rolle_superuser
                                                       || ','
                                                       || c_rolle_user
                                                       || ','
                                                       || c_rolle_readonly;
    c_rollenliste_user constant varchar2(4000) := c_rolle_user
                                                  || ','
                                                  || c_rolle_readonly;
    c_rollenliste_readonly constant varchar2(4000) := c_rolle_readonly;     

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
    status_scheduled_for_deletion constant t_enum := 'SCHEDULED_FOR_DELETION';
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

  /** 
   * Gibt den Versionsstring des Package Bodies zurück 
   */
    function get_body_version return varchar2
        deterministic; 

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
    ); 

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
    ); 

  /** 
   * Liest die aktuellen Adressendaten aus der STRAV ein. 
   * Für den unwahrscheinlichen Fall, dass die STRAV keine Daten zurückliefern kann,  
   * werden die Eingangswerte der IN OUT-Parameter zurückgegeben (beide Datenquellen werden aber 
   * niemals "gemischt": Es wird beispielsweise nicht geschehen, dass eine Hausnummer aus der STRAV 
   * mit einem Hausnummern-Zusatz aus dem Preorder-Buffer kombiniert wird) 
   * 
   * @param pin_haus_lfd_nr  [IN ]    ID der Adressen (im Fall des Glascontainers: Installationsadresse) 
   * @param piov_strasse     [IN OUT] Straße 
   * @param piov_hausnr      [IN OUT] Hausnummer 
   * @param piov_zusatz      [IN OUT] Hausnummer-Zusatz (z.B. 'a-f') 
   * @param piov_plz         [IN OUT] Postleitzahl 
   * @param piov_ort         [IN OUT] Ort 
   * 
   * @ticket FTTH-1246 

    PROCEDURE p_strav_adresse_holen ( 
      pin_haus_lfd_nr IN INTEGER 
    , piov_strasse    IN OUT VARCHAR2 
    , piov_hausnr     IN OUT VARCHAR2 
    , piov_zusatz     IN OUT VARCHAR2 
    , piov_plz        IN OUT VARCHAR2 
    , piov_ort        IN OUT VARCHAR2 
    ); 
   */ 

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
    );    
  */     

  /** 
   * Führt die Stornierung eines Auftrags gegen den Webservice aus 
   * 
   * @param piv_uuid        [IN ] ID des zu stornierenden Auftrags 
   * @param piv_stornogrund [IN ] Schlüssel für die fachliche Begründung der Stornierung (ENUM: cancellationReasons) 
   * @param piv_app_user    [IN ] 4- oder 6-stelliges Kürzel des APEX-Applikations-Users 
   * 
   * @raise  Werden keine Exceptions geworfen, dann wurde die Stornierung 
   *             erfolgreich an den Webservice übermittelt. Im Fehlerfall wird einer 
   *             dieser Statuscodes geraised: 
   *             -20400: Payload does not match expectations 
   *             -20404: Order does not exist 
   *             -20500: Something went wrong on the server side 
   * 
   * @usage      Unter Umständen ist im Anschluss an diese Stornierung mit einer  
   *             gewissen Verarbeitungsdauer zu rechnen (processLock). 
   * 
   * @example 
   * BEGIN pck_glascontainer.p_auftrag_stornieren(piv_uuid => '4711', piv_stornogrund => 'TEST_CONTRACT', piv_app_user => 'TEST'); END; 
   */
    procedure p_auftrag_stornieren (
        piv_uuid        in ftth_ws_sync_preorders.id%type,
        piv_stornogrund in varchar2,
        piv_app_user    in varchar2
    ); 

  /** 
   * Liefert den für die nächste Synchronisierung gültigen Wert des Parameters 
   * lastModifiedWithinDays zurück 
   * 
   * @usage  Üblicherweise wird der Parameter aus dem Wert der Konfigurationsvariablen 
   *         LASTMODIFIEDWITHINDAYS (Tabelle PARAMS) ausgelesen, so wie er in der 
   *         Glascontainer-App konfiguriert wurde. Jedoch ist es zwingend notwendig, 
   *         nach einer Leerung der Synchronisationstabelle eine vollständige 
   *         Synchronisierung zu erzwingen; in diesem Fall beträgt der Wert 
   */
    function fn_last_modified_within_days return naturaln;   

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
   * Liefert für den Fall, dass eine Auftragssperre vorliegt (processLock=true) 
   * das Datum der letzten Änderung dieser Sperre zurück, ansonsten NULL 
   * 
   * @usage Durch Prüfen des zurückgegebenen Datums kann ermittelt werden, 
   *        ob und seit eine Sperre auf dem Auftrag besteht. 
   * 
   * @param piv_uuid                  ID des Auftrags 
   * @param piv_ws_modus              ONLINE_AND_OFFLINE: Die Prozedur versucht zunächst, die Lock-Information live vom Webservice 
   *                                  zu holen; wenn dieser nicht verfügbar ist, holt die Prozedur 
   *                                  die Daten ersatzweise aus der Tabelle FTTH_WS_SYNC_PREORDERS. 
   *                                  ONLINE: Wenn der Webservice zur Zeit des Aufrufs nicht verfügbar ist, 
   *                                  dann wirft diese Prozedur eine Exception.  
   *                                  OFFLINE: Die Prozedur greift sofort auf die Tabelle FTTH_WS_SYNC_PREORDERS zu, 
   *                                  ohne den Webservice vorher abzufragen.  
   * 
   * @return Wert des Feldes processLockLastModified, jedoch nur sofern processLock gesetzt ist 
   * 
   * @raise  Alle Exceptions (sowohl vom Webservice als auch aufgrund einer Tabellenabfrage) 
   *             werden geraised. Geloggt wird nur, wenn ein anderer Fehler als 404 bzw. 
   *             NO_DATA_FOUND auftritt. 
   */
    function fd_process_lock (
        piv_uuid     in ftth_ws_sync_preorders.id%type,
        piv_ws_modus in varchar2 default c_ws_modus_online_and_offline
    ) return timestamp with local time zone;   

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
   *   v_params params%rowtype; 
   * BEGIN 
   *   v_params.pv_satzart     := 'WEBSERVICE'; 
   *   v_params.pv_key2        := 'MIN_SYNC_INTERVAL_PREORDERS'; 
   *   v_params.n_wert1        := 10; 
   *   v_params.v_beschreibung := 'Mindestanzahl Minuten zwischen zwei manuell ausgelösten Webservice-Synchronisierungen'; 
   *   PCK_GLASCONTAINER.p_merge_params(v_params); 
   * END; 
   * 
   * @example 
   * DECLARE 
   *   v_params params%rowtype; 
   * BEGIN 
   *   v_params.pv_satzart     := 'WEBSERVICE'; 
   *   v_params.pv_key1        := 'PREORDERBUFFER'; 
   *   v_params.pv_key2        := 'BASE-URL'; 
   *   v_params.v_wert1        := 'https://api-e.dss.svc.netcologne.intern/'; 
   *   v_params.v_wert2        := 'agent'; 
   *   v_params.v_wert3        := 'bnkRO=62Gs1o'; 
   *   v_params.v_beschreibung := 'Webservice Base-URL, mit der sich der Glascontainer in der aktuellen Umgebung verbindet'; 
   *   PCK_GLASCONTAINER.p_merge_params(v_params); 
   * END; 
   */
    procedure p_merge_params (
        pir_params in params%rowtype
    ); 



/** 
 * Schreibt einen Konfigurationsparameter in die Tabelle CORE.PARAMS, wobei eine bestehende Beschreibung nicht
 * gelöscht wird, falls hier keine neue mitgegeben wird.
 * 
 * @param piv_satzart      [IN] beispielsweise 'WEBSERVICE' 
 * @param piv_key          [IN] beispielsweise 'BASE-URL' 
 * @param piv_wert1        [IN]  (optional) 
 * @param piv_wert2        [IN]  (optional) 
 * @param piv_wert3        [IN]  (optional) 
 * @param pin_wert1        [IN]  (optional) 
 * @param pin_wert2        [IN]  (optional) 
 * @param pin_wert3        [IN]  (optional) 
 * @param piv_beschreibung [IN]  (optional)  
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
    );     

  /** 
   * Liefert den Wert1 eines Schlüssels aus der Tabelle PARAMS zurück, wobei kein 
   * Fehler bei Nichtvorhandenseit des Schlüssels geworfen wird   
   *  
   * @param piv_satzart [IN ] beispielsweise 'WEBSERVICE' 
   * @param piv_key     [IN ] beispielsweise '' 
   * 
   * @usage PARAMS KEY1 ist per Definition 'GLASCONTAINER' 
   *  
   * @return Existierender Wert oder NULL 
   */
    function fv_konfiguration_lesen (
        piv_satzart in params.pv_satzart%type,
        piv_key     in params.pv_key2%type
    ) return varchar2;     

  /** 
   * Liefert zum uebergebenen Teil-PK den fuer die jeweilige Stage gueltigen Wert kompletten Record, 
   * jedoch wird keine Exception zurueckgegeben, falls der gesuchte Teil-PK nicht existiert. 
   * 
   * @param       piv_satzart   => Teil des PK 
   * @param       piv_key1      => Teil des PK 
   * @param       piv_key2      => Teil des PK 
   * 
   * @return  Zeile mit den gesuchten Schluesseln, oder NULL falls diese nicht existiert. 
   */
    function fr_params_noexception (
        piv_satzart in params.pv_satzart%type,
        piv_key1    in params.pv_key1%type,
        piv_key2    in params.pv_key2%type
    ) return v_params%rowtype;   

  --- @deprecated FUNCTION GET_WS_URL(PIV_METHOD IN VARCHAR2) RETURN VARCHAR2 DETERMINISTIC; 

  -- ///@weiter: select distinct landlord_legalform from FTTH_WS_SYNC_PREORDERS order by 1; 

  /** 
   * Gibt die Server-Basis-URL des Webservices zurück, mit der sich die aktuelle 
   * Instanz des Glascontainers verbindet. 
   */
    function base_url return varchar2; 

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
  */
    function fc_history_wsget (
        piv_uuid in varchar2
    ) return clob;   

  /** 
   * Ruft den Webservice "/preorders/{id}" mit einem GET-Request 
   * für einen bestimmten Auftrag auf und liefert die JSON-Antwort als CLOB zurück 
   * 
   * @param piv_uuid [IN ]  Schlüssel des Auftrags 
   * 
   * @return Originale Antwort des Webservice ohne weitere Ergänzung oder Formatierung 
   * 
   * @raise ORA-29273: HTTP request failed 
   * @raise ORA-12535: TNS:operation timed out 
   * 
   * @example 
   * DECLARE 
   *     v_webservice_antwort CLOB; 
   * BEGIN 
   *     v_webservice_antwort := pck_glascontainer.fc_preorders_wsget(pck_glascontainer.demo_uuid); 
   *     dbms_output.put_line(v_webservice_antwort); 
   * END; 
   */
    function fc_preorders_wsget (
        piv_uuid in varchar2
    ) return clob; 



/** 
  * Konsolidiert die Eingangsdaten und erstellt daraus den JSON-Body, 
  * der für den Aufruf des POST-Webservices "preorders" 
  * zur Aktualisierung eines Auftrags in der Agent View benötigt wird 
  * 
  * @param piv_promotion            [IN ] Entspricht im JSON dem Feld "templateId" 
  * @param piv_router_auswahl       [IN ] Entspricht im JSON dem Feld "deviceCategory" 
  * @param piv_router_eigentum      [IN ] Entspricht im JSON dem Feld "deviceOwnership" 
  * @param piv_installationsservice [IN ] Entspricht im JSON dem Feld "installationService" 
  * @param piv_service_plus_email   [IN ] Entspricht im JSON dem Feld "servicePlusEmail" 
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
    ) return clob; 

  /** 
   * Prüft die Eingangsdaten und erstellt daraus den JSON-Body, 
   * der für den Aufruf des POST-Webservices "/preorders/{orderId}/cancel" 
   * zur Stornierung eines Auftrags benötigt wird 
   * 
   * @param piv_cancellation_reason  [IN ] Entspricht im JSON dem Feld "cancellationReason" 
   * @param piv_user                 [IN ] Entspricht im JSON dem Feld "user" 
   */
    function fj_preorders_cancel (
        piv_cancellation_reason in varchar2,
        piv_user                in varchar2
    ) return clob;     

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
   *
   * @date 2024-06-25  Zusätzlicher Parameter pin_haus_lfd_nr, damit der ONT Provider validiert werden kann
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
    --piv_service_plus_email   IN VARCHAR2 DEFAULT NULL @FTTH-5002: Kann nach der Einführung der Versionierung gelöscht werden
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
        pic_preorder_json                  in clob,
        pov_uuid                           out varchar2,
        pov_vkz                            out varchar2,
        pov_kundennummer                   out varchar2,
        pov_promotion                      out varchar2,
        pov_router_auswahl                 out varchar2,
        pov_router_eigentum                out varchar2,
        pov_ont_provider                   out varchar2,
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
        pov_siebel_ready                   out varchar2,  -- neu 2023-07-18 @ticket FTTH-1521 
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
        pov_home_id                        out varchar2,  -- @ticket FTTH-4143
        pov_account_id                     out varchar2,  -- @ticket FTTH-4470
        pod_availability_date              out date,       -- @ticket FTTH-3880
        pov_customer_status                out varchar2,   -- @ticket FTTH-5772
        pov_router_shipping                out varchar2  -- @ticket FTTH-6231
        -- ... @SYNC#16
    ); 

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
        pov_siebel_ready                   out varchar2  -- neu 2023-07-18 @ticket FTTH-1521 
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
        pov_router_shipping                out varchar2  -- @ticket FTTH-6231       -- ... @SYNC#17
    ); 

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
        pov_ont_provider                   out varchar2,
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
        pov_telefon                        out varchar2 
--  pov_passwort             OUT VARCHAR2, -- entfernt 2025-01-21
    -- neu 2022-06-14: 
        ,
        pov_providerwechsel                out varchar2,
        pov_providerw_aktueller_anbieter   out varchar2,
        pov_providerw_anmeldung_anrede     out varchar2,
        pov_providerw_anmeldung_nachname   out varchar2,
        pov_providerw_anmeldung_vorname    out varchar2,
        pov_providerw_nummer_behalten      out varchar2,
        pov_providerw_laendervorwahl       out varchar2,
        pov_providerw_vorwahl              out varchar2,
        pov_providerw_telefon              out varchar2  
    ------------------------------------------ 
        ,
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
        pov_voradresse_land                out varchar2  
    ---------------------------------------- 
        ,
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
        pod_storno_datum                   out date -- ////// wieso VARCHAR2 und nicht DATE?
        ,
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
        pov_technology                     out varchar2 -- neu 2024-07-09 @ticket FTTH-3747: Hätte man besser DIENSTTYP nennen sollen
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
        pov_home_id                        out varchar2,
        pov_account_id                     out varchar2 -- @ticket FTTH-4470
        ,
        pod_availability_date              out date     -- @ticket FTTH-3880
        ,
        pov_customer_status                out varchar2 -- @ticket FTTH-5772
        ,
        pov_router_shipping                out varchar2  -- @ticket FTTH-6231
   -- ... @SYNC#18
    ); 

  /** 
   * Nimmt die einzelnen Feldinhalte aus der Glascontainer-App entgegen 
   * und liefert das daraus resultierende JSON-Objekt zurück 
   * 
   * @param pir_auftrag   [IN ]  Feldinhalte, die zuvor in der APEX-App 
   *                             aus den Items ausgelesen und einem ROWTYPE 
   *                             entsprechend zugewiesen wurden 
   * @param pib_all_items [IN ] (optional) auf TRUE setzen, damit die Ausgabe 
   *                             auch diejenigen nicht-änderbaren Bestandteile 
   *                             enthält, die für einen PUT-Request (Update) 
   *                             zum Webservice erlaubt, aber wirkungslos sind; 
   *                             bei FALSE oder NULL enthält das JSON 
   *                             nur die editierbaren Attribute 
   * 
   * @usage  Wenn pib_skip_readonly_items auf TRUE steht, dann werden die Inhalte 
   *         der nur-Lesen-Felder nicht benötigt und können leer bleiben. Dies 
   *         erleichtert die Programmierung, da anfangs (Stand Mai 2022) tatsächlich 
   *         nur 3 (drei!) Felder in der Glascontainer-App überhaupt editierbar sind, 
   *         der Rest sind reine Anzeige-Items. 
   */
    function fj_auftrag (
        pir_auftrag   in v_ftth_preorderbuffer%rowtype,
        pib_all_items in boolean default null
    ) return json_object_t; 

  /** 
   * APEX-Validierung für das Feld "Anrede" 
   * 
   * @param piv_value    [IN ] Aktueller Wert des Items 
   * @param pib_null     [IN ] (optional) Auf TRUE setzen, wenn ein leerer Wert gültig ist 
   * @param piv_feldname [IN ] Da diese Prüfung für unterschiedliche Felder herangezogen wird, 
   *                           sollte hier explizit das Formular-Label angegeben werden 
   * @return  Fehlertext wenn die Prüfung fehlschlägt, ansonsten NULL (= Prüfung erfolgreich) 
   */
    function chk_anrede (
        piv_value    in varchar2,
        pib_null     in boolean default false,
        piv_feldname in varchar2 default null
    ) return varchar2; 

  /** 
   * APEX-Validierung für das Feld "Router-Eigentum" (deviceOwnership) 
   * 
   * @param piv_value    [IN ] Aktueller Wert des Items 
   * @param pib_null     [IN ] (optional) Auf TRUE setzen, wenn ein leerer Wert gültig ist 
   * @param piv_feldname [IN ] Falls diese Prüfung für unterschiedliche Felder herangezogen wird, 
   *                           sollte hier explizit das Formular-Label angegeben werden 
   * @return  Fehlertext wenn die Prüfung fehlschlägt, ansonsten NULL (= Prüfung erfolgreich) 
   */
    function chk_deviceownership (
        piv_value    in varchar2,
        pib_null     in boolean default false,
        piv_feldname in varchar2 default null
    ) return varchar2;     

  /** 
   * APEX-Validierung für das Feld "Installationsservice" (installationService) 
   * 
   * @param piv_value    [IN ] Aktueller Wert des Items 
   * @param pib_null     [IN ] (optional) Auf TRUE setzen, wenn ein leerer Wert gültig ist 
   * @param piv_feldname [IN ] Falls diese Prüfung für unterschiedliche Felder herangezogen wird, 
   *                           sollte hier explizit das Formular-Label angegeben werden 
   * @return  Fehlertext wenn die Prüfung fehlschlägt, ansonsten NULL (= Prüfung erfolgreich) 
   */
    function chk_installationsservice (
        piv_value    in varchar2,
        pib_null     in boolean default false,
        piv_feldname in varchar2 default null
    ) return varchar2; 

  /** 
   * APEX-Validierung für das Feld "Promotion" 
   * 
   * @param piv_value [IN ] Aktueller Wert des Items 
   * @param pib_null  [IN ] (optional) Auf TRUE setzen, wenn ein leerer Wert gültig ist 
   * @return  Fehlertext wenn die Prüfung fehlschlägt, ansonsten NULL (= Prüfung erfolgreich) 

  FUNCTION chk_promotion( 
    piv_value IN VARCHAR2, 
    pib_null  IN BOOLEAN DEFAULT false 
  ) RETURN VARCHAR2; 
   */ -- ////@todo wo in APEX verwendet?   

  /** 
   * APEX-Validierung für das Feld "Wohneinheiten" bzw. "Anzahl WE" (prop_residential_unit) 
   * 
   * @param piv_value    [IN ] Aktueller Wert des Items 
   * @param pib_null     [IN ] (optional) Auf TRUE setzen, wenn ein leerer Wert gültig ist 
   * @param piv_feldname [IN ] Falls diese Prüfung für unterschiedliche Felder herangezogen wird, 
   *                           sollte hier explizit das Formular-Label angegeben werden 
   * @return  Fehlertext wenn die Prüfung fehlschlägt, ansonsten NULL (= Prüfung erfolgreich) 
   */
    function chk_prop_residential_unit (
        piv_value    in varchar2,
        pib_null     in boolean default false,
        piv_feldname in varchar2 default null
    ) return varchar2; 

  /** 
   * APEX-Validierung für das Feld "Router-Auswahl" (deviceCategory) 
   * 
   * @param piv_value [IN ] Aktueller Wert des Items 
   * @param pib_null  [IN ] (optional) Auf TRUE setzen, wenn ein leerer Wert gültig ist 
   * @return  Fehlertext wenn die Prüfung fehlschlägt, ansonsten NULL (= Prüfung erfolgreich) 
   */
    function chk_router_auswahl (
        piv_value in varchar2,
        pib_null  in boolean default false
    ) return varchar2; 

  /** 
   * APEX-Validierung für das Feld "Status" (state) 
   * 
   * @param piv_value    [IN ] Aktueller Wert des Items 
   * @param pib_null     [IN ] (optional) Auf TRUE setzen, wenn ein leerer Wert gültig ist 
   * @param piv_feldname [IN ] Falls diese Prüfung für unterschiedliche Felder herangezogen wird, 
   *                           sollte hier explizit das Formular-Label angegeben werden 
   * @return  Fehlertext wenn die Prüfung fehlschlägt, ansonsten NULL (= Prüfung erfolgreich) 
   */
    function chk_status (
        piv_value    in varchar2,
        pib_null     in boolean default false,
        piv_feldname in varchar2 default null
    ) return varchar2;     

  /** 
   * APEX-Validierung für das Feld "Wohndauer" (customer_residentstatus) 
   * 
   * @param piv_value    [IN ] Aktueller Wert des Items 
   * @param pib_null     [IN ] (optional) Auf TRUE setzen, wenn ein leerer Wert gültig ist 
   * @param piv_feldname [IN ] Falls diese Prüfung für unterschiedliche Felder herangezogen wird, 
   *                           sollte hier explizit das Formular-Label angegeben werden 
   * @return  Fehlertext wenn die Prüfung fehlschlägt, ansonsten NULL (= Prüfung erfolgreich) 
   */
    function chk_wohndauer (
        piv_value    in varchar2,
        pib_null     in boolean default false,
        piv_feldname in varchar2 default null
    ) return varchar2;   



/** 
 * APEX-Validierung für das Feld "VKZ" 
 * 
 * @param piv_value    [IN ] Aktueller Wert des Items 
 * @param pib_null     [IN ] optional - Auf TRUE setzen, wenn ein leerer Wert gültig ist 
 * @param piv_feldname [IN ] optional - Falls diese Prüfung für unterschiedliche Felder herangezogen wird, 
 *                           sollte hier explizit das Formular-Label angegeben werden 
 * @return Fehlertext wenn die Prüfung fehlschlägt, ansonsten NULL (= Prüfung erfolgreich) 
 * @ticket FTTH-5048
 * @unittest
 * SELECT * FROM ROMA_MAIN.UT.RUN('UT_GLASCONTAINER', a_tags => 'CHK_VKZ');  
 */
    function chk_vkz (
        piv_value    in varchar2,
        pib_null     in boolean default false,
        piv_feldname in varchar2 default null
    ) return varchar2;



  /** 
   * Liefert die Anzeige- und Rückgabewerte für eine APEX LOV anhand ihres Namens zurück 
   * 
   * @param piv_name       [IN ] Name der LOV, typischerweise entspricht dieser dem 
   *                             generischen Namen des APEX Items, Beispiel: ROUTER_AUSWAHL 
   * @param piv_parameter1 [IN ] Typischerweise der Wert einer Parent-Selectliste, so dass 
   *                             die Ausgabe bestimmter Zeilen dynamisch ist 
   * @param piv_parameter2 [IN ] Wurde erstmals erforderlich für die LOV "Promotion", wo 
   *                             die Mindest- und Maximalbandbreite des Vermarktungscluster 
   *                             eine Rolle spielt 
   * @param piv_parameter3 [IN ] Wird verwendet, um die richtigen ENUMs für die templateId  
   *                             auszuwählen 
   */
    function lov (
        piv_name       in varchar2,
        piv_parameter1 in varchar2 default null,
        piv_parameter2 in varchar2 default null,
        piv_parameter3 in varchar2 default null, -- neu 2022-09-27 
        piv_parameter4 in varchar2 default null --FTTH-6261 Sonderlogik für 2000er Bandbreiten duerfen kein Basic zur Auswahl haben
    ) return t_lov
        pipelined; 

  /** 
   * Ersetzt die mittleren Zeichen der IBAN durch Sternchen 
   * (eine technische Validierung der IBAN erfolgt dabei nicht, 
   * jedoch werden fehlende oder zu viele vorhandene Stellen optisch hervorgehoben) 
   * 
   * @param piv_iban               [IN ] Originale IBAN, egal ob mit oder ohne Leerzeichen 
   * @param piv_fuellzeichen       [IN ] Wenn gefüllt (Default: Leerzeichen), dann erfolgt 
   *                                     die Ausgabe mit diesem Zeichen zwischen den Viererblöcken. 
   *                                     Das Füllzeichen darf auch leer sein (NULL) - dann 
   *                                     werden keine Viererblöcke gebildet 
   * @param piv_maskierungszeichen [IN ] Bestimmt das Zeichen, das die originalen Stellen überdeckt 
   *                                     (Default: Sternchen *) 
   * 
   * @usage Anzeige einer IBAN muss maskiert erfolgen (nur die ersten 4 und die letzten 4 Zeichen, der Rest mit * maskiert). 
   *        Wenn die IBAN nicht vollständig ist (genau 22 Stellen ohne Leerzeichen), dann werden 
   *        die fehlenden Stellen durch '?' am Ende dargestellt: 'DE1' wird zu 'DE1? **** **** **** **?? ??' 
   */
    function fv_iban_maskiert (
        piv_iban               in varchar2,
        piv_fuellzeichen       in varchar2 default ' ',
        piv_maskierungszeichen in varchar2 default '*'
    ) return varchar2; 

  /** 
   * Liefert die Template-Zeile zurück, die oberhalb eines Auftrags angezeigt wird 
   *  
   * @param pin_haus_lfd_nr       [IN] HAUS_LFD_NR 
   * @param piv_kundennummer      [IN] Anzuzeigender Wert für Kundennummer 
   * @param piv_vorname           [IN] Anzuzeigender Wert für Vornamen 
   * @param piv_nachname          [IN] Anzuzeigender Wert für Nachnamen 
   * @param pid_geburtsdatum      [IN] Anzuzeigender Wert für Geburtsdatum des Kunden 
   * @param piv_anschluss_strasse [IN] Anzuzeigender Wert für Straßennamen 
   * @param piv_anschluss_hausnr  [IN] Anzuzeigender Wert für Hausnummer (inklusive Zusatz) 
   * @param piv_anschluss_plz     [IN] Anzuzeigender Wert für Postleitzahl 
   * @param piv_anschluss_ort     [IN] Anzuzeigender Wert für Ort 
   *  
   * @return Zeichenkette, in der jeder unbekannte/leere Wert mit einer 
   *         doppelten geschweiften Klammer {{...}} repräsentiert wird 
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
    ) return varchar2;   

  /**     
   * Selektiert einen Auftrag anhand der UUID und gibt, sofern dieser Auftrag existiert, 
   * die passenden Kopfdaten zurück 
   * 
   * @param piv_ftth_id  ID des gewünschten Datensatzes im Preorderbuffer 
   * 
   * @raise  Alle Fehler (außer NO_DATA_FOUND) werden geloggt und geraised 
   */
    function fv_kopfdaten (
        piv_ftth_id in ftth_ws_sync_preorders.id%type
    ) return varchar2;     

  /** 
   * Gibt das Datum und die Uhrzeit des letzten (typischerweise nächtlich laufenden) 
   * Synchronisierungs-Jobs des Webservices zurück 
   * 
   * ////@todo: Gilt das Datum auch im Fehlerfall? 
   * 
   * @param pin_app_id    [IN ]  APEX Application-ID 
   * @param piv_ws_name   [IN ]  "Rest Source Name" des synchronisierten Web-Service 
   */
    function fd_ws_last_sync_date (
        pin_app_id  in varchar2,
        piv_ws_name in varchar2
    ) return date; 

  /** 
   * Gibt das Datum der letzten Synchronisierung eines bestimmten Auftrags zurück 
   * (dieser wurde möglicherweise später als die nächtliche Synchronisierung 
   * einzeln synchronisiert - siehe p_auftragsdaten_synchronisieren) 
   * 
   * ////@todo: Gilt das Datum auch im Fehlerfall? 
   * 
   * @param i_app_id    [IN ]  APEX Application-ID 
   * @param i_ws_name   [IN ]  "Rest Source Name" des synchronisierten Web-Service 
   */
    function fd_ws_last_sync_date (
        piv_uuid in varchar2
    ) return date; 

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
   *   vr_vermarktungscluster := PCK_GLASCONTAINER.fr_vermarktungscluster(pin_haus_lfd_nr => 4711); 
   *   DBMS_OUTPUT.PUT_LINE('VC_LFD_NR   = ' || vr_vermarktungscluster.vc_lfd_nr); 
   *   DBMS_OUTPUT.PUT_LINE('Bezeichnung = ' || vr_vermarktungscluster.bezeichnung); 
   * END; 
   * 
   * @deprecated: Wurde ins PCK_VERMARKTUNGSCLUSTER verlegt 
   */
    function fr_vermarktungscluster (
        pin_haus_lfd_nr in vermarktungscluster_objekt.haus_lfd_nr%type
    ) return vermarktungscluster%rowtype; 


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
        deterministic; 

  /** 
   * Nimmt einen Auftrag entgegen (alle Felder sollten gefüllt sein!) und schreibt 
   * ihn in die Tabelle FTTH_WS_SYNC_PREORDERS, so dass der zuletzt nächtlich synchronisierte 
   * Datensatz anschließend diesem aktuellen Zustand entspricht 
   * 
   * @param pir_preorder [IN OUT]  Auftragsdaten, mit denen die SYNC-Tabelle 
   *                               aktualisiert werden soll 
   * 
   * @usage  Die Prozedur führt keine Validierung durch! 
   *         Der Datensatz wird nicht als Update zum Webservice gesendet, denn 
   *         der Sinn dieser Synchronisation ist, dass im Fall eines späteren 
   *         Ausfalls des Webservices wenigstens die aktuellst möglichen Daten 
   *         geholt werden, wenn der Auftrag im Laufe des Tages erneut angezeigt werden soll. 
   * 
   * @return Im Erfolgsfall steht in pir_preorder.APEX$ROW_SYNC_TIMESTAMP die aktuelle Uhrzeit 
   * 
   * @raise  Alle Fehler werden geworfen, kein Logging. 

  PROCEDURE p_auftragsdaten_synchronisieren( 
    pir_preorder IN OUT FTTH_WS_SYNC_PREORDERS%rowtype 
  ); 
   */ 

  /** 
   * Schreibt nach der Änderung eines Auftrags im APEX Glascontainer die neuen Daten 
   * (und zwar nur diejenigen, die zur Änderung vorgesehen sind!) 
   * zurück in die Synchronisationstabelle, um bei Webservice-Ausfällen 
   * die letzten Änderungen aus dem lokalen Puffer lesen zu können. 
   * 
   * @param piv_uuid                  [IN ]  PK des Auftrags 
   * @param piv_promotion             [IN ]  Änderbares Feld im Glascontainer (kombiniert: Promotion & Produkt - eindeutig anhand der Selectliste) 
   * @param piv_router_auswahl        [IN ]  Änderbares Feld im Glascontainer 
   * @param piv_router_eigentum       [IN ]  Änderbares Feld im Glascontainer 
   * @param piv_installationsservice  [IN ]  Änderbares Feld im Glascontainer 
   * 
   * @usage  Es werden keine fachlichen Validierungen ausgeführt, allerdings handelt es sich 
   *         durchgehend um Pflichtfelder, so dass eine Exception geworfen sird, 
   *         sobald eines davon leer ist 
   * 
   * @raise  Es erfolt ein Logging im Fehlerfall. Alle Fehler werden geworfen. 
   */
    procedure p_auftragsdaten_synchronisieren (
        piv_uuid                 in varchar2,
        piv_promotion            in varchar2,
        piv_router_auswahl       in varchar2,
        piv_router_eigentum      in varchar2,
        piv_installationsservice in varchar2
    ); 

  /** 
   * Nimmt die aktuellen Auftragsdaten in JSON-Form entgegen und aktualisiert 
   * die entsprechende Zeile in der Sync-Tabelle FTTH_WS_SYNC_PREORDERS 
   * 
   * @param piv_json  [IN ] Vollständiges, valides JSON-Dokument des Auftrags, 
   *                  typischerweise frisch erhalten vom Webservice "preoders" 
   */
    procedure p_auftragsdaten_synchronisieren (
        piv_json in clob
    );     

  /** 
   * Nimmt die APEX-Glascontainer-Felder eines Auftrags entgegen 
   * und liefert die Daten im Zeilenformat der Synchronisationstabelle 
   * ungeprüft zurück 
   * 
   * @param  piv_uuid  [IN ]  PK des Auftrags. 
   *                          Alle weiteren Felder siehe Webservice-Spezifikation 
   * 
   * @raise  Keine Prüfung, keine Fehlerbehandlung, alle Exceptions werden geworfen 
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
    ) return ftth_ws_sync_preorders%rowtype; 

  /** 
   * Synchronisiert eine in APEX deklarierte REST Data Source, sofern dies 
   * anhand der in diesem Package gegebenen Geschäftsregeln (Sperrfrist) zulässig ist. 
   * 
   * @param piv_rest_source_static_id   ID der REST Source, siehe APEX > Shared Components. 
   *                                    Momentan einziger definierter Wert: 'preorders_' 
   * @param pib_sync_erzwingen          (optional) wenn TRUE, dann wird die Synchronisation auch dann 
   *                                    durchgeführt, wenn die Wartezeit ("Sync-Sperre") noch nicht abgelaufen ist 
   * 
   * @raise  User Defined Exception, wenn die Synchronisierung aufgrund der Sperre 
   *         nicht durchgeführt wird 
   * 
   * @usage  Diese Prozedur muss im APEX-Kontext aufgerufen werden 
   * 
   * @example  Aufruf der Prozedur aus dem Editor: 
   * BEGIN 
   *   apex_session.attach(p_app_id => 2022, p_page_id => 10, p_session_id => 32481198917971); 
   *   pck_glascontainer.p_webservice_synchronisieren(piv_rest_source_static_id => 'preorders_'); 
   * END; 
   */
    procedure p_webservice_synchronisieren (
        piv_rest_source_static_id in varchar2,
        pib_sync_erzwingen        in boolean default null
    ); 

  /** 
   * Gibt die Anzahl Sekunden zwischen zwei TIMESTAMPs oder zwei DATEs zurück, 
   * inklusive Nachkommastellen. 
   * 
   * @param pit_frueher  [IN ]  Beginn der Messung 
   * @param pit_spaeter  [IN ]  Ende der Messung 
   * 
   * @usage  Nur wenn die beiden Zeiten völlig identisch sind, 
   *         wird eine glatte 0 zurückgegeben. Die Funktion sollte entweder mit 
   *         zwei TIMESTAMPS oder mit zwei DATES aufgerufen werden (nicht mit 
   *         gemischten Datentypen), ansonsten können unerwartete Differenzen im 
   *         Sekundenbereich die Folge sein (Oracle rechnet halt so). 
   * 
   * @example  SELECT pck_glascontainer.fn_sekunden_zwischen(SYSTIMESTAMP - INTERVAL '10' SECOND, SYSTIMESTAMP) FROM DUAL; -- 10 
   * @example  SELECT pck_glascontainer.fn_sekunden_zwischen(SYSDATE, SYSDATE) FROM DUAL; -- 0 
   * @example  SELECT pck_glascontainer.fn_sekunden_zwischen(SYSDATE, SYSDATE - 1) FROM DUAL; --  -86400 = minus 1 Tag: früher/später vertauscht! 
   */
    function fn_sekunden_zwischen (
        pit_frueher in timestamp,
        pit_spaeter in timestamp
    ) return number; 


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
    ) return varchar2; 

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
  * @raise  User Defined Error (nicht geloggt), wenn sämtliche Eingangsparameter leer sind. 
  *             Alle anderen Fehler werden geloggt und geworfen. 
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
    ); 

  /** 
   * Wird vom DBMS_SCHEDULER aufgerufen, um die tägliche Abfrage der noch nicht 
   * geprüften neuen Aufträge auf Dubletten durchzuführen. Der Zeitpunkt des Aufrufs 
   * liegt eine halbe Stunde nach der Synchronisierung der Auftragsdaten. 
   * Der Verlauf der Abfragen kann mittels der Tabelle FTTH_FUZZY_REQUESTS 
   * kontrolliert werden, die ermittelten Ergebnisse befinden sich 
   * in der Tabelle FTTH_PREORDERS_FUZZYDOUBLE.
   * 
   * @param piv_username  Bleibt beim Aufruf durch den Scheduler leer - nur zum  
   *                      Testen und manuellen Überprüfen kann hier wahlweise ein  
   *                      anderer Name mitgegeben werden  
   * @example 
   * BEGIN PCK_GLASCONTAINER.p_program_fuzzy_taeglich('TEST'); END; 
   */
    procedure p_program_fuzzy_taeglich (
        piv_username in varchar2 default null
    );   

  /** 
   * Wird vom DBMS_SCHEDULER einmal pro Woche aufgerufen, um die erneute Abfrage 
   * aller Aufträge auf Dubletten durchzuführen. Der Zeitpunkt des Aufrufs 
   * liegt eine halbe Stunde nach der Synchronisierung der Auftragsdaten. 
   * Der Verlauf der Abfragen kann mittels der Tabelle FTTH_FUZZY_REQUESTS kontrolliert werden. 
   * 
   * @param piv_username  Bleibt beim Aufruf durch den Scheduler leer - nur zum  
   *                      Testen und manuellen Überprüfen kann hier wahlweise ein  
   *                      anderer Name mitgegeben werden 
   * 
   * @example 
   * BEGIN PCK_GLASCONTAINER.p_program_fuzzy_woechentlich('TEST'); END; 
   */
    procedure p_program_fuzzy_woechentlich (
        piv_username in varchar2 default null
    );   

  /** 
   * Gibt die ToDo-Liste für die APEX-App "Glascontainer" aus. 
   * 
   * @usage  Wird auf der Seite "Über diese Anwendung" angezeigt 
   * 
   * @example 
   * SELECT D AS TEXT, R AS PRIO FROM TABLE(PCK_GLASCONTAINER.TODOLIST) 
   */
    function todolist return t_lov
        pipelined; 

  /** 
   * Speichert eine neue Bewertung einer potenziellen Dublette durch einen 
   * Fachbereichsmitarbeiter, setzt dabei das AKTUELL-Flag der zuvor aktuellen Bewertung zurück 
   * 
   * @param piv_knr0      [IN] Ausgehend von dieser Kundennummer im Preorderbuffer 
   * @param piv_knr1      [IN] Die Bewerunt gbezieht sich auf diese potenzielle Dublette 
   * @param piv_bewertung [IN] G= gewollte Dublette, X= kein Zusammenhang, W= Wiedervorlage (klären) 
   * @param piv_kommentar [IN] Optionaler Bearbeitungsvermerk 
   * @param piv_username  [IN] APEX-User, der diese Bewertung abgibt 
   * 
   * @usage    Aufruf durch APEX Application Process "AP_SUBMIT_DUBLETTEN_BEWERTUNG"  
   *           sowie durch Dynamic Actions auf Seite 2022:40 
   */
    procedure ap_submit_dubletten_bewertung (
        piv_knr0      in varchar2,
        piv_knr1      in varchar2,
        piv_bewertung in varchar2,
        piv_kommentar in varchar2,
        piv_username  in varchar2
    ); 

  /** 
   * Löscht eine bestimmte Bewertung aus der Tabelle FTTH_DUBLETTEN_BEWERTUNG 
   * und setzt anschließend die nächst-jüngere Bewertung auf AKTUELL 
   * 
   * @param pin_bewertung_id [IN ] Technischer PK 
   */
    procedure ap_delete_dubletten_bewertung (
        pin_bewertung_id ftth_dubletten_bewertung.id%type
    );

    procedure htp_webservice_urls; 

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
    PIPELINED;   
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
        piv_filter in varchar2 default null
    ) return t_pob_table
        pipelined; 



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
    ); 

/**   
 * @deprecated - jetzt im PCK_GLASCONTAINER_EXT

 * Schickt die Mitteilung an den Backend-Webservice, dass ein bestimmter Auftrag 
 * in Siebel abgeschlossen werden soll. 
 * 
 * @param piv_uuid         [IN] ID des Auftrags im Glascontainer (entspricht in Siebel der "ext. Partner Unterauftrags-ID") 
 * @param piv_order_number [IN] Siebel-Auftragsnummer  
 * @param piv_order_rowid  [IN] Siebel-Zeilen-ID 
 * @param piv_app_user     [IN] Kürzel des APEX-Benutzers, der den Vorgang durchführt 
 * 
 * @ticket FTTH-2056 

  PROCEDURE p_siebel_auftrag_abschliessen( 
    piv_uuid         IN FTTH_WS_SYNC_PREORDERS.ID%TYPE 
   ,piv_order_number IN VARCHAR2 
   ,piv_order_rowid  IN VARCHAR2 
   ,piv_app_user     IN VARCHAR2 
  );   
   */   

/** 
 * Gibt den anzuzeigenden Status eines Auftrags im Glascontainer zurück 
 * 
 * @param piv_state  [IN ] IN_REVIEW|CREATED|CANCELLED|SIEBEL_PROCESSED|... 
 * 
 * @usage APEX-Item "P20_STATUS_DISPLAY"  
 */
    function fv_auftragsstatus_display (
        piv_state in varchar2
    ) return varchar2; 

/** 
 * Gibt TRUE zurück, wenn für ein bestimmtes Produkt die Angabe einer 
 * Service-Plus-Emailadresse erforderlich ist 
 * 
 * @ticket FTTH-2411 
 */
    function fb_service_plus_email_noetig -- @FTTH-5002
     (
        piv_produkt_template_id in varchar2
    ) return boolean; 


/** 
 * Gibt zu einer Template-ID (Produkt) der alten Tarifgeneration Oktober 2023 
 * die entsprechende Template-ID der neuen Tarifgeneration September 2023 zurück. 
 * Die Produkte heißen zwar ähnlich und haben verwandte Template-IDs, 
 * aber daraus lässt sich kein zwingender Zusammenhang ableiten. 

  FUNCTION get_produkt_2023_09(piv_template_id_2022_10 IN VARCHAR2) 
  RETURN VARCHAR2 DETERMINISTIC;   
 */   

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
        pipelined;   
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
 * @ticket FTTH-2411 
 */
    function fv_folgeprodukt (
        piv_template_id         in varchar2,
        piv_tarifgeneration_neu in varchar2 default null
    ) return ftth_glascontainer_produkte.template_id%type;   

/** 
 * Liefert eine vollständige JavaScript-Function zurück, mit der clientseitig ermittelt wird, 
 * ob ein Produkt eine Service-Plus-Emailadresse erfordert. 
 */
    function js_fn_is_service_plus_email_produkt return varchar2;  -- @FTTH-5002

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
    ) return varchar2;   

/** 
 * Gibt für den Eintrag im Feld "changedBy" für den Glascontainer den 
 * passenden Anzeigestring zurück (bei natürlichen Personen den vollen Namen im AD, 
 * bei Einträgen die mit "mig" beginnen oder leeren Usernamen: den String "SYSTEM" 
 * 
 * @ticket FTTH-2648 
 */
    function fv_user_displayname (
        piv_username in varchar2
    ) return varchar2; 



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
 *                       fb_hat_rolle eingeführt. 
 * 
 * @unittest 
 * SELECT * FROM ut.run('UT_GLASCONTAINER', a_tags => 'fb_hat_rolle_ad'); 
 *
 */
    function fb_hat_rolle_ad (
        piv_app_user in varchar2,
        piv_rolle    in varchar2,
        piv_umgebung in varchar2 default null
    ) return boolean
        accessible by ( package ut_glascontainer ); 

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
    );   

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
        piv_umgebung    in varchar2 default null -- neu 2025-05-15
    ) return boolean;   

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
        accessible by ( package ut_glascontainer );   


/**   
 * Gibt den Namen der Rolle zurück, die in DEV + TEST in der Auswahlliste 
 * "Rolle zuweisen" angezeigt wird 
 * 
 * @param piv_rollenbezeichnung [IN ]  ADMINISTRATOR|SUPERUSER|USER|READONLY 
 */
    function fv_rollenname_ad (
        piv_rollenbezeichnung in varchar2
    ) return varchar2
        deterministic; 



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
        deterministic; 


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
        pipelined;   


--@progress 2023-11-21---------------------------------------------------------- 

/** @deprecated 
TYPE T_KOMMENTAR IS RECORD( 
  ID       VARCHAR2(100)   -- ID des Kommentars selbst 
 ,REF_ID   VARCHAR2(100)   -- auf welche ID bezieht sich das, 
 ,USECASE  VARCHAR2(100)   -- z.B. in welcher Tabelle? 
 ,DATUM    DATE            -- Erstellungsdatum 
 ,STATUS   VARCHAR2(3)     -- beim Anlegen leer 
 ,USERNAME VARCHAR2(6)     -- Kürzel 
 ,TEXT     VARCHAR2(32767) 
); 
TYPE T_KOMMENTARE IS TABLE OF T_KOMMENTAR; 
*/ 

/* @deprecated 
  FUNCTION "HTML_KOMMENTARE" ( 
    piv_uuid IN VARCHAR2 
  ) RETURN CLOB 
  ; 
 */     


/** 
 * Table Function, gibt alle Kommentare zu einem Auftrag zurück 
 * 
 * @param piv_uuid   [IN ]  ID des Auftrags 
 */
    function fp_comments (
        piv_uuid in ftth_ws_sync_preorders.id%type
    ) return t_comment_table
        pipelined;

    function fv_escape_kommentar (
        piv_kommentar in varchar2
    ) return varchar2; 

/** 
 * Liefert nach einer Validierung den JSON-Body zurück,  
 * der an den REST-Endpunkt COMMENTS_POST gesendet werden muss 
 */
    function fj_comments_post (
        piv_kommentar in varchar2,
        piv_app_user  in varchar2
    ) return clob; 

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
    ); 

/** 
 * Liefert zum Schlüssel eines Wholebuy-Partners (z.B. 'TCOM') den dazugehörigen 
 * Namen ('Telekom') 
 * 
 * @param piv_wholebuy_key  Schlüssel des Wholebuy-Partners 
 */
    function fv_wholebuy_partner_display (
        piv_wholebuy_key in varchar2
    ) return varchar2;   

/** 
 * Löscht alle Datensätze aus der Tabelle FTTH_WEBSERVICE_AUFRUFE, die 
 * älter als 90 Tage sind 
 * 
 * @param pin_anzahl_tage  [IN ]  Falls gesetzt, wird anstelle der 90-Tage-Grenze 
 *                                diese Anzahl Tage verwendet 

  PROCEDURE p_delete_webservice_logs(pin_anzahl_tage IN NATURAL DEFAULT 90);   
 */   

/**   
 * Gibt eine Tabelle mit der Darstellung der Rollen zurück, die 
 * der User hat bzw. nicht hat. 
 * 
 * @param piv_rollenliste [IN ] Siehe Glascontainer: G_ROLLENLISTE 
 */
    function fc_rollen_display (
        piv_rollenliste in varchar2
    ) return varchar2
        deterministic;   



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
    );   

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
    );

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
    );

/**
 * Schreibt einen Log-Eintrag in die Tabelle FTTH_GLASCONTAINER_LOG (als
 * autonome Transaktion)

 * 
 * @param piv_session_id [IN]  APEX Session-ID (siehe Browser-URL)
 * @param pin_page_id    [IN]  APEX-Seitennummer
 * @param piv_aktion     [IN]  Kurzbeschreibung der Aktion (z.B. "CLICK", "ENTER")
 * @param piv_objekt     [IN]  ID des Items oder Buttons etc.
 *
 * @usage
 * Stand 2024-06: Das APEX Activity Log ist in der Produktion aktiviert.
 * Von daher sollten hier nur solche Aktionen zusätzlich protokolliert werden, 
 * die vom Log nicht erfasst werden.
 */
    procedure p_log_aktion (
        piv_session_id in varchar2,
        pin_page_id    in integer,
        piv_aktion     in varchar2,
        piv_objekt     in varchar2
    );



/**
 * Gibt die Kurzbezeichnungen (z.B. "FTTH", "G.fast") für die Diensttyp-Nummer zurück, die für den Glascontainer derzeit relevant sind.
 *
 * @param piv_dnsttp_lfd_nr [IN ] Erwartet wird eine Zahl, aber APEX sendet diese Zahl als String, daher sicherheitshalber piv
 *
 * @ticket FTTH-3957: Funktion benötigt einen neuen Namen oder Parameter, sobald die Vermarktungscluster
 *                    die neuen Diensttypen > 70 erhalten - dann wird die Frage, ob ein Wholebuy-Partner
 *                    mit von der Partie ist, durch den Diensttyp beantwortet.
 */
    function fv_technologie (
        piv_dnsttp_lfd_nr varchar2
    ) return varchar2
        deterministic;

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
        deterministic;

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
        pipelined;


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
    ) return clob;


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
    );



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
    ) return varchar2;  

/**
 * Refresht alle Materialized Views, die für den Glascontainer relevant sind.
 *
 * @usage Aufruf nächtlich durch Scheduler-Job "JOB_GLASCONTAINER_REFRESH_MV"
 */
    procedure p_refresh_materialized_views;  


/**
 * Liest die Kontaktdaten eines SIEBEL-Kunden in die Ausgabefelder, falls diese gefunden werden konnten.
 * Wurde kein entsprechender Datensatz gefunden, werden leere Felder zurückgeliefert
 *
 * @param piv_kundennummer [IN ]  Kundennummer in SIEBEL
 *
 * @ticket FTTH-3711
 * @defect @ticket FTTH-4227 
 *
 * @example
 * DECLARE
 *   c_kundennummer   CONSTANT VARCHAR2(100) := '13009180';
 *   v_email          VARCHAR2(100);
 *   v_laendervorwahl VARCHAR2(100);
 *   v_onkz           VARCHAR2(100);
 *   v_rufnummer      VARCHAR2(100);
 * BEGIN
 *   pck_glascontainer.P_GET_SIEBEL_KONTAKTDATEN (
 *         piv_kundennummer => c_kundennummer
 *        ---
 *        ,pov_ap_email                     => v_email
 *        ,pov_ap_mobil_laendervorwahl      => v_laendervorwahl
 *        ,pov_ap_mobil_onkz                => v_onkz
 *        ,pov_ap_mobil_rufnummer           => v_rufnummer
 *   );
 *   DBMS_OUTPUT.PUT_LINE('Kundennummer:  ' || c_kundennummer);
 *   DBMS_OUTPUT.PUT_LINE('E-Mail:        ' || v_email);
 *   DBMS_OUTPUT.PUT_LINE('Ländervorwahl: ' || v_laendervorwahl);
 *   DBMS_OUTPUT.PUT_LINE('Ortnetz:       ' || v_onkz);
 *   DBMS_OUTPUT.PUT_LINE('Rufnummer:     ' || v_rufnummer);
 * END; 
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
    );

/**
 * Liefert die Bezeichnung für einen Dienst bzw. Technologie zurück, die für den Glascontainer derzeit relevant sind,
 * so wie der User es in der Maske angezeigt bekommen soll, also beispielsweise 
 * "G.fast" für "G_FAST" oder "FTTH BSA L2" anstatt "FTTH_BSA_L2".
 *
 * @param piv_technology  [IN ]  Typischerweise der Wert aus der Spalte FTTH_WS_SYNC_PREORDERS.technology,
 *                               aber auch bereits umgewandelte Schreibweisen davon werden korrekt erkannt.
 */
    function fv_technologie_display (
        piv_technology in varchar2
    ) return varchar2
        deterministic;    


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
    );

    procedure create_collection (
        piv_collection_name in varchar2,
        piv_app_id          in varchar2,
        piv_app_page_id     in varchar2,
        piv_app_session     in varchar2,
        piv_app_user        in varchar2
    );  


/**
 * Liefert eine kommaseparierte Liste mit den Keys der Stornogründe zurück, für die
 * ein Kunde keine Bestätigungsmail erhält.
 *
 * @ticket FTTH-4270
 * @example SELECT PCK_GLASCONTAINER.FV_STORNOGRUENDE_OHNE_MAIL FROM DUAL; -- DUPLICATE,ORDER_RESUBMITTED
 */
    function fv_stornogruende_ohne_mail return varchar2; 

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
 * @unit_test SELECT * FROM TABLE(ut.run('UT_GLASCONTAINER', a_tags => 'fv_link_siebel_kundenmaske'));
 */
    function fv_href_siebel_kundenmaske (
        piv_account_id   in varchar2,
        piv_kundennummer in varchar2 default null,
        piv_umgebung     in varchar2 default null
    ) return varchar2
        deterministic;

/**
 * Gibt den vollständigen Link (<a href="https://...">Kundennummer</a>) zur Siebel-Kundenmaske zurück
 * 
 * @param piv_kundennummer [IN]  Im Link dargestellter Text (üblicherweise nur die Kundennummer)
 * @param piv_account_id   [IN]  Der Siebel-Link erwartet die Account-ID, nicht die Kundennummer
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
        deterministic;  



/**
 * Gibt einen HTML-Hinweistext zurück, wann die Auftragsliste zuletzt synchronisiert wurde,
 * oder NULL wenn dies nicht festgestellt werden konnte (zum Beispiel nach einem
 * Neuaufbau der Datenbank)
 *
 * @usage  Diese Funktion muss aus einem APEX-Kontext aufgerufen werden,
 *         oder man setzt die g_security_group_id.
 */
    function fv_html_pob_zuletzt_synchronisiert return varchar2;

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
 * @usage  Aufruf durch Trigger FTTH_WS_SYNC_PREORDERS_BIU
 *
 * @ticket FTTH-4625
 * @ticket FTTH-5020: Zusätzliche Informationen zum Ausbausgebiet und -status werden persistiert
 */
    procedure p_adresse_synchronisieren (
        pin_haus_lfd_nr in pob_adressen.haus_lfd_nr%type
    );


/**
 * Gibt Adressfelder zu einer HAUS_LFD_NR zurück: Vorranging aus der Tabelle POB_ADRESSEN;
 * wenn dort nichts gefunden wird: aus der STRAV.
 */
    procedure p_get_adresse (
        pin_haus_lfd_nr   in pob_adressen.haus_lfd_nr%type,
        pov_str           out pob_adressen.str%type,
        pov_hnr_kompl     out pob_adressen.hnr_kompl%type,
        pov_gebaeudeteil  out pob_adressen.gebaeudeteil_name%type,
        pov_plz           out pob_adressen.plz%type,
        pov_ort_kompl     out pob_adressen.ort_kompl%type,
        pov_adresse_kompl out pob_adressen.adresse_kompl%type
    );   

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
    ) return varchar2; 


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
    ) return varchar2;

-- @progress 2025-07-07

/** 
 * Gibt den zur gegebenen Meldung passenden Hinweistext zurück
 * 
 * @param: piv_uuid(VARCHAR2)
 * @param: piv_wholebuy_partner(VARCHAR2)
 * @param: pid_availability_date(DATE)
 *
 * @return: VARCHAR2
 *
 * @ticket FTTH-3880, FTTH-5140
 */
    function fv_stornokosten (
        piv_uuid              in ftth_ws_sync_preorders.id%type,
        piv_wholebuy_partner  in varchar2,
        pid_availability_date in date
    ) return varchar2;

    function fv_http_statusmessage (
        i_statuscode in integer
    ) return varchar2
        deterministic;

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
    ) return clob;

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
    );

    function f_get_vorwahl (
        pi_haus_lfd_nr in number
    ) return varchar2;

end pck_glascontainer;
/


-- sqlcl_snapshot {"hash":"2324f5a51624d1dd0be75dfbb0a9eed7b603bab7","type":"PACKAGE_SPEC","name":"PCK_GLASCONTAINER","schemaName":"ROMA_MAIN","sxml":""}