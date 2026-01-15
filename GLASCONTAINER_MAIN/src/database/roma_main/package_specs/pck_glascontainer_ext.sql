create or replace package pck_glascontainer_ext as 
/**
 * Routinen für die APEX-App 2022 Glascontainer, die in andere Datenbank-Schemata
 * als ROMA_MAIN verzweigen oder hauptsächlich von dort lesen
 *
 * @usage
 * Dieses Package beinhaltet keine eigene Fehlerbehandlung: Alle Exceptions
 * werden standardgemäß an das aufrufende Programm weitergegeben. Die Fehlerbehandlung
 * erfolgt im PCK_GLASCONTAINER
 *
 * @unittest
 * SELECT * FROM TABLE(UT.RUN('UT_GLASCONTAINER', a_tags => 'PCK_GLASCONTAINER_EXT')); 
 */

  -- Umlaut-Test: ÄÖÜäöüß  -- Eurozeichen: ? -- SELECT UNISTR('\20AC') FROM DUAL 

  -- /////@weiter: Fuzzy-Routinen hierhin auslagern  

  -- Wird angezeigt auf der Seite 10050 "Über diese Anwendung".
  -- Der gesamte String sollte als Ganzes aufsteigend sortierbar sein
  -- (an erster Stelle ist also das Datum maßgeblich)
  -- so dass die aktuellere Version stets lexikalisch "später" einsortiert werden kann.
    version constant varchar2(30) := '2025-04-09 1900';
  -- (Änderung G_SCOPE von POB auf GLASCONTAINER)

    c_failed_siebel_specs constant integer := -20011; -- Ein Siebel-Aufruf scheitert an falschen Eingabedaten

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
        piov_firmenname   in out varchar2,
        pib_force_siebel  in boolean default null
    )
        accessible by ( package pck_glascontainer, package pck_glascontainer_gk, package pck_glascontainer_dubletten, package ut_glascontainer
        );

/**
 * Liest die Daten eines Kunden aus Siebel anhand der Kundennummer ein.
 * Im Gegensatz zu get_siebel_kopfdaten sind es mehr Felder, und es gibt auch
 * keine Ergänzungs-Automatik (alle Ausgabefelder sind OUT anstatt IN OUT)
 * 
 * @param piv_kundennummer      [IN]   NR. des Kunden, dessen Daten gesucht werden
 * @param piv_filialnummer      [IN]   Unterkundenr. des Kunden, dessen Daten gesucht werden
 * @param pov_global_id         [OUT]  GLOBAL_ID aus Siebel
 * @param pov_vorname           [OUT]  Vorname
 * @param pov_nachname          [OUT]  Nachname
 * @param pod_geburtsdatum      [OUT]  Geburtsdatum
 * @param pov_anrede            [OUT]  Anrede
 * @param pov_titel             [OUT]  Titel
 * @param pov_firmenname        [OUT]  Firmenname
 * @param pov_strasse           [OUT]  Straße
 * @param pov_hausnr_von        [OUT]  //// Hausnummer von
 * @param pov_hausnr_zusatz_von [OUT]  //// Hausnummer Zusatz von
 * @param pov_hausnr_bis        [OUT]  //// Hausnummer bis
 * @param pov_hausnr_zusatz_bis [OUT]  //// Hausnummer Zusatz bis
 * @param pov_plz               [OUT]  Postleitzahl
 * @param pov_ort               [OUT]  Ort
 * @param pov_iban              [OUT]  Bankverbindung: IBAN
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
        piv_kundennummer      in varchar2,
        piv_filialnummer      in varchar2 default '0000'
    --
        ,
        pov_global_id         out varchar2,
        pov_vorname           out varchar2,
        pov_nachname          out varchar2,
        pod_geburtsdatum      out date,
        pov_anrede            out varchar2,
        pov_titel             out varchar2,
        pov_firmenname        out varchar2,
        pov_strasse           out varchar2,
        pov_hausnr_von        out varchar2,
        pov_hausnr_zusatz_von out varchar2,
        pov_hausnr_bis        out varchar2,
        pov_hausnr_zusatz_bis out varchar2,
        pov_plz               out varchar2,
        pov_ort               out varchar2,
        pov_iban              out varchar2,
        pov_ap_email          out varchar2,
        pov_ap_mobil_country  out varchar2,
        pov_ap_mobil_onkz     out varchar2,
        pov_ap_mobil_nr       out varchar2,
        pov_bu                out varchar2
    )
        accessible by ( package pck_glascontainer, package pck_glascontainer_gk, package ut_glascontainer );  

/**
 * Liest zu einer POB-Auftrags-ID die dazugehörigen Auftrags-Kopfdaten aus Siebel.
 *
 * @ticket FTTH-2246 
 * @ticket FTTH-2162
 * @ticket FTTH-3711
 * @ticket FTTH-4198
 *
 * @usage  Werden keine Daten gefunden, weist das auf eine fehlerhafte Abfragesituation hin
 * (ein POB-Auftrag, für den diese Frage gestellt wird, MUSS in Siebel existieren)
 *
 * @example
 * DECLARE
 *      v_uuid              FTTH_WS_SYNC_PREORDERS.ID%TYPE := 'YgcSMsMj8pZgmFlxaThDQyMgGJLzM8';
 *      v_order_rowid       VARCHAR2(100);
 *      v_order_number      VARCHAR2(100);
 *      v_account_id        VARCHAR2(100);
 *      v_kundennummer      INTEGER;
 *      v_unterkundennummer INTEGER;
 *      v_usermessage       VARCHAR2(4000);
 * BEGIN
 *   PCK_GLASCONTAINER_EXT.p_get_siebel_auftragsdaten(
 *       piv_uuid              => v_uuid
 *       --->
 *      ,pov_order_rowid       => v_order_rowid
 *      ,pov_order_number      => v_order_number
 *      ,pov_account_id        => v_account_id
 *      ,pov_kundennummer      => v_kundennummer
 *      ,pov_unterkundennummer => v_unterkundennummer
 *      ,pov_usermessage       => v_usermessage
 *   );
 *   DBMS_OUTPUT.PUT_LINE('ORDER_ROWID       : ' || v_order_rowid);
 *   DBMS_OUTPUT.PUT_LINE('order_number      : ' || v_order_number);
 *   DBMS_OUTPUT.PUT_LINE('ACCOUNT_ID        : ' || v_account_id);
 *   DBMS_OUTPUT.PUT_LINE('KUNDENNUMMER      : ' || v_kundennummer);
 *   DBMS_OUTPUT.PUT_LINE('UNTERKUNDENNUMMER : ' || v_unterkundennummer);
 *   DBMS_OUTPUT.PUT_LINE('USERMESSAGE       : ' || v_usermessage); 
 * END; 
 */
    procedure p_get_siebel_auftragsdaten (
        piv_uuid              in varchar2
    --->
        ,
        pov_order_rowid       out varchar2,
        pov_order_number      out varchar2,
        pov_account_id        out varchar2,
        pov_kundennummer      out integer,
        pov_unterkundennummer out integer,
        pov_usermessage       out varchar2 -- neu 2024-08-28 @ticket FTTH-4198
    );  

/**  
 * Schickt die Mitteilung an den Backend-Webservice, dass ein bestimmter Auftrag
 * in Siebel abgeschlossen werden soll.
 *
 * @param piv_uuid            [IN] ID des Auftrags im Glascontainer (entspricht in Siebel der "ext. Partner Unterauftrags-ID")
 * @param piv_order_number    [IN] Siebel-Auftragsnummer 
 * @param piv_order_rowid     [IN] Siebel-Zeilen-ID
 * @param piv_username        [IN] Kürzel des APEX-Benutzers, der den Vorgang durchführt
 *
 * @ticket FTTH-2056
  PROCEDURE p_siebel_auftrag_abschliessen(
    piv_uuid         IN FTTH_WS_SYNC_PREORDERS.ID%TYPE
   ,piv_order_number IN VARCHAR2
   ,piv_order_rowid  IN VARCHAR2
   ,piv_username     IN VARCHAR2
  ) 
  ACCESSIBLE BY (
    PACKAGE PCK_GLASCONTAINER
  , PACKAGE UT_GLASCONTAINER
  );  
 */


  /**
  * Liest die aktuellen Adressendaten aus der STRAV ein.
  *
  * @param pin_haus_lfd_nr   [IN ] ID der Adressen (im Fall des Glascontainers: Installationsadresse)
  * @param pov_str           [OUT] Straße
  * @param pov_hnr_kompl     [OUT] Hausnummer, komplett inklusive Zusatzangaben
  * @param pov_gebaeudeteil  [OUT] Optional: Gebäudeteil
  * @param pov_plz           [OUT] Postleitzahl
  * @param pov_ort_kompl     [OUT] Ort, ggf inklusive Ortsteil in Klammern
  * @param pov_adresse_kompl [OUT] Vollständige Adresse zur Darstellung in einer Zeile
  *
  * @ticket FTTH-1246
  * @usage In der Auftrags-Einzelansicht wird zunächst der komplette Datensatz aus dem Preorderbuffer gelesen.
  * Anschließend wird die hier ermittelte Adresse aus der STRAV, falls vorhanden, darübergelegt.
  * Dieses Verfahren wird in der Auftragsliste (für Admins) nicht eingesetzt - dort steht die
  * Adresse, wie sie im Preorderbuffer gespeichert ist.
  * @ticket 1757: Es stellt sich heraus, dass im Preorderbuffer die Spalte INSTALL_ADDR_ADDITION
  * niemals gefüllt ist, sondern der Hausnummerzusatz bereits im Feld Hausnummer erfasst wird.
  */
    procedure p_get_strav_adresse (
        pin_haus_lfd_nr   in integer,
        pov_str           out varchar2,
        pov_hnr_kompl     out varchar2,
        pov_gebaeudeteil  out varchar2,
        pov_plz           out varchar2,
        pov_ort_kompl     out varchar2,
        pov_adresse_kompl out varchar2 -- @ticket FTTH-4641
    )
        accessible by ( package pck_glascontainer, package pck_glascontainer_gk, package ut_glascontainer );

/**
 * @deprecated
 *
 * Liest die Kontaktdaten eines Kunden aus Siebel anhand der Kundennummer ein.
 * 
 * @param piv_kundennummer      [IN]   NR. des Kunden, dessen Daten gesucht werden
 * 
 * @throws  Alle Exceptions werden geworden.
 *          Kein Fehlerlogging: Das aufrufende Programm entscheidet, ob
 *          es einen Fehler loggen möchte (beispielsweise nicht, wenn 
 *          lediglich ein Tippfehler bei der Eingabe der Kundennummer auftritt)
 * @usage  Auftragserfassung im Glascontainer: Persönliche Daten
 * @ticket FTTH-3711
 * @krakar
 */
    procedure p_get_siebel_kontaktdaten (
        piv_kundennummer              in varchar2,
        pov_ap_email                  out varchar2,
        pov_ap_mobil_country          out varchar2,
        pov_ap_mobil_onkz             out varchar2,
        pov_ap_mobil_nr               out varchar2,
        pov_update_customer_in_siebel out varchar2
    );  

/** 
 * Prüft die Eingangsdaten und erstellt daraus den JSON-Body, 
 * der für den Aufruf des POST-Webservices "siebelOrderIds" 
 * zum Abschließen des Auftrags in Siebel benötigt wird 
 * 
 * @param piv_uuid         [IN]  
 * @param piv_order_number [IN]  
 * @param piv_order_rowid  [IN]  
 * @param piv_username     [IN]  
 * @param piv_username     [IN ] Entspricht im JSON dem Feld "changedBy" 
 */
    function fj_siebel_process (
        piv_uuid         in varchar2,
        piv_order_number in varchar2,
        piv_order_rowid  in varchar2,
        piv_username     in varchar2
    ) return clob
        accessible by ( package ut_glascontainer );

/**   
 * Schickt die Mitteilung an den Backend-Webservice, dass ein bestimmter Auftrag 
 * in Siebel abgeschlossen werden soll. 
 * 
 * @param piv_uuid         [IN] ID des Auftrags im Glascontainer (entspricht in Siebel der "ext. Partner Unterauftrags-ID") 
 * @param piv_order_number [IN] Siebel-Auftragsnummer  
 * @param piv_order_rowid  [IN] Siebel-Zeilen-ID 
 * @param piv_app_user     [IN] Kürzel des APEX-Benutzers, der den Vorgang durchführt 
 * 
 * @ticket FTTH-2056, @ticket FTTH-2162 
 * 
 * ////@todo 2023-08-24 Umleiten auf PCK_GLASCONTAINER_EXT.p_siebel_auftrag_abschliessen 
 */
    procedure p_siebel_auftrag_abschliessen (
        piv_uuid         in ftth_ws_sync_preorders.id%type,
        piv_order_number in varchar2,
        piv_order_rowid  in varchar2,
        piv_app_user     in varchar2
    );  

-- @progress 2025-03-19

/**
 * Holt für alle Adressen (oder eine einzige) in der Tabelle POB_ADRESSEN die Auskünfte zu den Ausbaugebieten
 * und aktualisiert sie bei Bedarf
 *
 * @param pin_haus_lfd_nr  [IN ]  (optional): Wenn gesetzt, wird nur diese einzige Adresse aktualisiert
 *
 * @ticket FTTH-4273
 * @usage     Aufruf durch nächtlichen Job, PROGRAM_GLASCONTAINER (über alle HAUS_LFD_NRn im POB)
 * @usage     Aufruf durch Trigger FTTH_WS_SYNC_PREORDERS_BIU (für eine einzelne HAUS_LFD_NR)
 * @example  BEGIN PCK_GLASCONTAINER_EXT.p_ausbaugebiete_aktualisieren(pin_haus_lfd_nr => 1112107); END;
 * @unittest SELECT * FROM TABLE(ut.run('UT_GLASCONTAINER', a_tags => 'P_AUSBAUGEBIETE_AKTUALISIEREN'));  
 */
    procedure p_ausbaugebiete_aktualisieren (
        pin_haus_lfd_nr in v_gc_ausbaugebiete_relevant.haus_lfd_nr%type default null
    );

/**
* Bestimmt für Kudnennummer, ob dieser Kunde geloescht ist
*
* @param piv_kundennummer  [IN ]  Kundennummer aus Siebel
*
* @ticket FTTH-5490
*/

    function fb_is_cust_locked (
        piv_kundennummer varchar2
    ) return boolean;

end pck_glascontainer_ext;
/


-- sqlcl_snapshot {"hash":"46bdf44670a682e147974c6d0af5e507af3401ab","type":"PACKAGE_SPEC","name":"PCK_GLASCONTAINER_EXT","schemaName":"ROMA_MAIN","sxml":""}