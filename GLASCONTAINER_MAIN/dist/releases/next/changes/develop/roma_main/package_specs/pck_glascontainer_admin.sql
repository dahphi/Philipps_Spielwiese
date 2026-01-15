-- liquibase formatted sql
-- changeset ROMA_MAIN:1768480990452 stripComments:false logicalFilePath:develop/roma_main/package_specs/pck_glascontainer_admin.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot GLASCONTAINER_MAIN/src/database/roma_main/package_specs/pck_glascontainer_admin.sql:null:5842a3b0d1e0a5c8e98728d85b4c067b8e5f5010:create

create or replace package roma_main.pck_glascontainer_admin as 

/**
 * Package dient der Durchführung und Aufzeichnung von konfigurativen Aktionen in der APEX-Applikation "Glascontainer",
 * die von Usern mit Administrator-Rollen vorgenommen werden.
 *
 * @creation 2025-04-23
 * @author   WISAND  Andreas Wismann  wismann@when-others.com
 * @ticket   FTTH-4987
 */
 
  -- Wird angezeigt auf der Seite 10050 "Über diese Anwendung". 
  -- Der gesamte String sollte als Ganzes aufsteigend sortierbar sein 
  -- (an erster Stelle ist also das Datum maßgeblich) 
  -- so dass die aktuellere Version stets lexikalisch "später" einsortiert werden kann. 
    version constant varchar2(30) := '2025-04-30 1148';
    c_application_error_number constant integer := -20000;
    aktion_base_url constant glascontainer_audit.aktion%type := 'BASE_URL';
  
  
  /** 
   * Gibt den Versionsstring des Package Bodies zurück 
   */
    function get_body_version return varchar2
        deterministic; 
    
    
    

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
    );
    
    
    
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
    );
    
    
    
  /** 
   * Schaltet die nächtliche Synchronisierung mit dem AOE-Webservice 
   * ein oder aus. 
   * 
   * @param pin_application_id   [IN]  Üblicherweise :APP_ID (2022) 
   * @param piv_module_static_id [IN]  Üblicherweise ws_static_id_preorders 
   * @param pib_enable           [IN]  TRUE: Synchronisierung wird aktiviert, 
   *                                   FALSE: Synchronisierung wird deaktiviert 
   *                                   (gilt solange, bis sie wieder aktiviert wird) 
   */
    procedure p_ws_sync_aktivieren (
        pin_application_id   in number,
        piv_module_static_id in varchar2,
        pib_enable           in boolean
    );
    
    
    
/**
 * Gibt TRUE zurück, wenn die momentan für den Glascontainer eingestellt BASE_URL (siehe @ticket FTTH-4987)
 * der Default-BASE_URL entspricht, andernfalls FALSE
 */
    function is_base_url_default return naturaln;

end;
/

