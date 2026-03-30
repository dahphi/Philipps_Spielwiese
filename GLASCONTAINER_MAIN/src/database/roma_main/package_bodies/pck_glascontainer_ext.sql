create or replace 
PACKAGE BODY             "PCK_GLASCONTAINER_EXT" AS 
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

  -- Umlaut-Test: ÄÖÜäöüß
    body_version CONSTANT VARCHAR2(30) := '2025-04-09 1900';
    -- (Änderung G_SCOPE von POB auf GLASCONTAINER)

    -- Abfragen / DML gegen Siebel durchführen? Default: TRUE 
    g_use_siebel                 BOOLEAN := TRUE;     

  -- Alle Fehlermeldungen aus diesem Package benutzen diesen Scope:
  G_SCOPE CONSTANT logs.scope%type := 'GLASCONTAINER';      

  c_empty_json                 CONSTANT VARCHAR2(2) := '{}';     


  /** 
  * Formatiert jeden Routinen-Namen mit dem Prefix des Packages, damit in den LOGS 
  * die Suche nach dem Package-Namen im Fehlerfall einfacher wird 
  * 
  * @example 
  * SELECT * FROM LOGS WHERE ROUTINE_NAME LIKE 'PCK_GLASCONTAINER%' AND ... 
  */ 
    FUNCTION qualified_name ( 
        i_routine_name IN VARCHAR2 
    ) RETURN VARCHAR2 
        DETERMINISTIC 
    IS 
    BEGIN 
        RETURN $$plsql_unit 
               || '.' 
               || upper(i_routine_name); 
    END;   

  /**
  * Gibt den Versionsstring des Package Bodies zurück
  */
    FUNCTION get_body_version RETURN VARCHAR2
        DETERMINISTIC
    IS
    BEGIN
        RETURN body_version;
    END;   



  /**
  * //////// Liest die Kopfdaten eines Kunden ein. Wenn diese nicht gefunden werden,
  * wird entweder der bestehende Wert der IN/OUT-Parameter zurückgegeben
  * oder der String 'n/a', falls dieser leer ist
  *
  * @param //////////
  *
  * @usage Diese Kopfdaten fehlen im Preorder-Buffer im Fall von Bestandskunden.
  * Die Prozedur verwendet eine in Siebel zur Verfügung gestellte View.
  * @todo Die Ausgabe des Geburtsdatums erfolgt hier korrekterweise als DATE,
  * das aufrufende Programm arbeitet aber weiterhin mit VARCHAR2: Letzteres anpassen!
  * @ticket FTTH-1246
  * @AP Thorsten Westenberg
  * @refactored 2025-04-09: Es ist effizienter, zunächst zu prüfen ob die IN-Parameter leer sind, erst dann Siebel fragen.
  *             Die bisherige Funktionalität ergibt sich mit pib_force_siebel => true
  */
  PROCEDURE p_get_siebel_kopfdaten
  (
    piv_kundennummer  IN VARCHAR2
   ,piov_vorname      IN OUT VARCHAR2
   ,piov_nachname     IN OUT VARCHAR2
   ,piod_geburtsdatum IN OUT DATE
   ,piov_anrede       IN OUT VARCHAR2
   ,piov_titel        IN OUT VARCHAR2
   ,piov_firmenname   IN OUT VARCHAR2
   ,pib_force_siebel  IN BOOLEAN DEFAULT NULL -- neu 2025-04-09
  )
  ACCESSIBLE BY (
    PACKAGE PCK_GLASCONTAINER
  , PACKAGE PCK_GLASCONTAINER_GK
  , PACKAGE PCK_GLASCONTAINER_DUBLETTEN
  , PACKAGE UT_GLASCONTAINER
  )  
  IS
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
    cv_routine_name CONSTANT logs.routine_name%TYPE := 'p_get_siebel_kopfdaten';
    FUNCTION fcl_params RETURN logs.message%TYPE IS
    BEGIN
      pck_format.p_add('piv_kundennummer',  piv_kundennummer);
      pck_format.p_add('piov_vorname',      piov_vorname);
      pck_format.p_add('piov_nachname',     piov_nachname);
      pck_format.p_add('piod_geburtsdatum', piod_geburtsdatum);
      pck_format.p_add('piov_anrede',       piov_anrede);
      pck_format.p_add('piov_titel',        piov_titel);
      pck_format.p_add('piov_firmenname',   piov_firmenname);
      pck_format.p_add('pib_force_siebel',  pib_force_siebel);
      RETURN pck_format.fcl_params(cv_routine_name);
    END fcl_params;
  -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------   
  BEGIN
    IF piv_kundennummer IS NOT NULL -- nur dann ergibt die Nachfrage bei Siebel überhaupt Sinn
    AND (pib_force_siebel OR (piov_vorname IS NULL AND piov_nachname IS NULL)) THEN
    -- nur nachfragen, wenn es nicht bereits Daten gibt oder dies ausdrücklich gefordert ist:
        BEGIN
            -- 2022-11-23: für Bestandskunden Vor- und Nachnamen aus Siebel ergänzen:        
            SELECT vorname, nachname, geburtsdatum, anrede, titel, firmenname
              INTO piov_vorname, piov_nachname, piod_geburtsdatum, piov_anrede, piov_titel, piov_firmenname
              FROM v_siebel_kundendaten
             WHERE kundennummer = piv_kundennummer -- die Kundennummer ist in Siebel nicht zwingend numerisch, z.B. "1-60601804691"
               -- 2023-02-16: Workaround für die Situation, wenn die View für einen Kunden mehrere Datensätze zurückliefert:
               AND GUELTIG = 'Y' -- In der Entwicklung existierte dieses Feld bis April 2023 noch nicht, jetzt am 2023-06-15 aktiviert
               FETCH FIRST ROW ONLY -- neu 2025-04-09
            ;
        EXCEPTION
          WHEN no_data_found THEN
            piov_vorname  := nvl(piov_vorname, n_a);
            piov_nachname := nvl(piov_nachname, n_a);
            -- Die anderen Felder bleiben wie sie sind
         END;
   END IF;
  EXCEPTION
    WHEN OTHERS THEN
      pck_logs.p_error(
         pic_message      => fcl_params()
        ,piv_routine_name => cv_routine_name
        ,piv_scope        => G_SCOPE
      );
      RAISE;      
  END p_get_siebel_kopfdaten;




/**
 * Liest zu einer POB-Auftrags-ID die dazugehörigen Auftrags-Kopfdaten aus Siebel.
 *
 * @ticket FTTH-2246 
 * @ticket FTTH-2162
 * @ticket FTTH-3711
 * @ticket FTTH-4198
 *
 * @date 2024-08-28
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
  PROCEDURE p_get_siebel_auftragsdaten (
    piv_uuid  IN VARCHAR2
    --->
     ,pov_order_rowid       OUT VARCHAR2
     ,pov_order_number      OUT VARCHAR2
     ,pov_account_id        OUT VARCHAR2
     ,pov_kundennummer      OUT INTEGER
     ,pov_unterkundennummer OUT INTEGER
     ,pov_usermessage       OUT VARCHAR2 -- neu 2024-08-28 @ticket FTTH-4198
  )
  IS
    v_auftragsliste VARCHAR2(4000);
    v_pob_auftrag_duplikat  ftth_ws_sync_preorders.id%type;
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
    cv_routine_name CONSTANT logs.routine_name%TYPE := 'p_get_siebel_auftragsdaten';
    FUNCTION fcl_params RETURN logs.message%TYPE IS
    BEGIN
      pck_format.p_add('piv_uuid', piv_uuid);
      RETURN pck_format.fcl_params(cv_routine_name);
    END fcl_params;
  -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
  BEGIN
    SELECT order_row_id,
           order_num,
           account_id,
           kundennummer,
           unterkundennummer
      INTO pov_order_rowid
         , pov_order_number
         , pov_account_id
         , pov_kundennummer
         , pov_unterkundennummer
      FROM v_siebel_auftragsdaten -- 2024-11-12: Neues Synonym für V_APX_GC_ORDERDATA@siebp.netcologne.intern@siebel_inf
     WHERE uuid = piv_uuid
     ;

     IF pov_order_number IS NOT NULL THEN
       -- 2024-11-12 @ticket FTTH-4021:
       -- Prüfen, ob noch ein anderer Auftrag im POB 
       -- mit denselben Siebel-View-Daten existiert:
       SELECT max(id)
         INTO v_pob_auftrag_duplikat
         FROM ftth_ws_sync_preorders p
        WHERE UPPER(SIEBEL_ORDER_NUMBER) = UPPER(pov_order_number) -- Function Based Index!
          AND UPPER(SIEBEL_ORDER_ROWID)  = UPPER(pov_order_rowid)  -- dafür kein Index mehr nötig
          AND p.id <> piv_uuid
           ;

       IF v_pob_auftrag_duplikat IS NOT NULL THEN
         -- Dialog in diesem Fall NICHT vorbelegen:
         pov_order_number := NULL;
         pov_order_rowid  := NULL;
         pov_usermessage  := NULL; -- NICHT: "Diese Siebel-Auftragsinformationen werden bereits in einem anderen Auftrag verwendet."
                                   -- (das ist nur für den 412-er Service-Error)
       END IF;

     END IF;

  EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        <<TOO_MANY_ROWS_EXCEPTION_HANDLER>>
        BEGIN
        -- @date 2023-08-23: TOO_MANY_ROWS mit uuid=N52BsVOS8wemwxAMA7TYutMWXp3Apj   
        -- RAISE_APPLICATION_ERROR(-20000, 'Fehler bei der Siebel-Abfrage: Der Auftrag liegt in mehreren Versionen vor.');
          SELECT LISTAGG(order_num, ', ') WITHIN GROUP (ORDER BY ORDER_NUM) 
            INTO v_auftragsliste
            FROM v_siebel_auftragsdaten -- V_APX_GC_ORDERDATA@siebp.netcologne.intern@siebel_inf
           WHERE uuid = piv_uuid;
          pov_usermessage := 'Zur UUID ' || piv_uuid 
                          || ' wurden in Siebel mehrere Aufträge gefunden: ' || v_auftragsliste;
          -- gibt ansonsten leere Ausgabefelder zurück
        EXCEPTION -- Sollte auch bei der Ermittlung der mehrfach gefundenen Aufträge etwas schiefgehen, 
                  -- können wir auch nicht mehr helfen:
          WHEN OTHERS THEN
            pck_logs.p_error(
               pic_message      => 'Fehler bei der Ermittlung der SIEBEL-Aufträge. ' || fcl_params()
              ,piv_routine_name => cv_routine_name
              ,piv_scope        => G_SCOPE
            );
            pov_usermessage := 'SIEBEL-Aufträge zu UUID ' || piv_uuid || ' konnten nicht ermittelt werden.';
        END TOO_MANY_ROWS_EXCEPTION_HANDLER;
    WHEN NO_DATA_FOUND THEN
        -- Stand 2023-07 liefert diese View keine Daten, wenn der Auftrag bereits abgeschlossen ist.     
        pov_usermessage := 'Zur UUID ' || piv_uuid 
                        || ' wurde in Siebel kein Auftrag gefunden.';
        -- gibt ansonsten leere Ausgabefelder zurück
    WHEN OTHERS THEN
      pck_logs.p_error(
         pic_message      => fcl_params()
        ,piv_routine_name => cv_routine_name
        ,piv_scope        => G_SCOPE
      );
      RAISE;       
  END p_get_siebel_auftragsdaten;  




/**  
 * Schickt die Mitteilung an den Backend-Webservice, dass ein bestimmter Auftrag
 * in Siebel abgeschlossen werden soll.
 *
 * @param piv_uuid         [IN] ID des Auftrags im Glascontainer (entspricht in Siebel der "ext. Partner Unterauftrags-ID")
 * @param piv_order_number [IN] Siebel-Auftragsnummer aus V_APX_GC_ORDERDATA
 * @param piv_order_rowid  [IN] Siebel-Zeilen-ID aus V_APX_GC_ORDERDATA
 * @param piv_username     [IN] Kürzel des APEX-Benutzers, der den Vorgang durchführt
 *
 * @ticket FTTH-2056
 * @ticket FTTH-2162

  PROCEDURE p_siebel_auftrag_abschliessen(
    piv_uuid         IN FTTH_WS_SYNC_PREORDERS.ID%TYPE
   ,piv_order_number IN VARCHAR2
   ,piv_order_rowid  IN VARCHAR2
   ,piv_username     IN VARCHAR2
  ) 
  ACCESSIBLE BY (
    PACKAGE PCK_GLASCONTAINER
  , PACKAGE UT_GLASCONTAINER
  )
  IS
  BEGIN
*/ 

/* nur ein BEISPIEL  :  


        vc_body := fj_preorders_product_update(
            piv_promotion           => piv_promotion
          , piv_router_auswahl      => piv_router_auswahl
       -- APEX liefert u.U. einen (veralteten, unsichtbaren) Wert für piv_router_eigentum,
       -- auch wenn in der Maske umgestellt wurde auf "Premium Router"
          , piv_router_eigentum => CASE
                                     WHEN piv_router_auswahl = enum_devicecategory_byod THEN NULL 
                                     ELSE piv_router_eigentum
                                   END
          , piv_installationsservice => piv_installationsservice
          , piv_app_user             => piv_app_user
        );

    -- Webservice schreibend aufrufen:
        pck_pob_rest.p_webservice_post( -- 2023-05-25: auf PCK_POB_REST umgeleitet
              piv_kontext    => PCK_POB_REST.PREORDERBUFFER
            , piv_ws_key     => C_WS_KEY_PREORDERS_POST
            , piv_uuid       => piv_uuid
            , piv_app_user   => piv_app_user
            , pic_body       => vc_body);    

*/      
 /* 

    NULL; -- ////@weiter: Umleiten von PCK_GLASCONTAINER.p_siebel_auftrag_abschliessen
  END;
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
  PROCEDURE p_get_strav_adresse
  (
    pin_haus_lfd_nr      IN  INTEGER 
   ,pov_str              OUT VARCHAR2 
   ,pov_hnr_kompl        OUT VARCHAR2 
   ,pov_gebaeudeteil     OUT VARCHAR2
   ,pov_plz              OUT VARCHAR2 
   ,pov_ort_kompl        OUT VARCHAR2 
   ,pov_adresse_kompl    OUT VARCHAR2 -- @ticket FTTH-4641
  )
  ACCESSIBLE BY (
    PACKAGE PCK_GLASCONTAINER
    , PACKAGE PCK_GLASCONTAINER_GK
    , PACKAGE UT_GLASCONTAINER
  )
  IS
  BEGIN

    SELECT str, hnr_kompl, gebaeudeteil_name, plz, ort_kompl, adresse_kompl
      INTO pov_str, pov_hnr_kompl, pov_gebaeudeteil, pov_plz, pov_ort_kompl, pov_adresse_kompl
      FROM strav.v_adressen
     WHERE haus_lfd_nr = pin_haus_lfd_nr;

  --   WHEN NO_DATA_FOUND wird im aufrufenden Programm abgefangen
  END p_get_strav_adresse;


--@progress 2024-01-16----------------------------------------------------------

/**
 * Liest die Daten eines Kunden aus Siebel anhand der Kundennummer ein.
 * Im Gegensatz zu get_siebel_kopfdaten sind es mehr Felder, und es gibt auch
 * keine Ergänzungs-Automatik (alle Ausgabefelder sind OUT anstatt IN OUT)
 * 
 * @param piv_kundennummer      [IN]   NR. des Kunden, dessen Daten gesucht werden
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
 * @param pov_ap_email          [OUT]  Primärer Ansprechpartner: E-Mail-Adresse
 * @param pov_ap_mobil_country  [OUT]  Primärer Ansprechpartner: Ländervorwahl mobil
 * @param pov_ap_mobil_onkz     [OUT]  Primärer Ansprechpartner: Netzvorwahl mobil
 * @param pov_ap_mobil_nr       [OUT]  Primärer Ansprechpartner: Rufnummer mobil
 * 
 * @throws  Alle Exceptions werden geworden.
 *          Kein Fehlerlogging: Das aufrufende Programm entscheidet, ob
 *          es einen Fehler loggen möchte (beispielsweise nicht, wenn 
 *          lediglich ein Tippfehler bei der Eingabe der Kundennummer auftritt)
 * @usage  Auftragserfassung im Glascontainer: Bestandskunden-Maske
 * @ticket FTTH-2807
 * @AP     Thorsten Westenberg
 */  
  PROCEDURE p_get_siebel_kundendaten
  (
    piv_kundennummer  IN VARCHAR2
   ,piv_filialnummer  IN VARCHAR2 DEFAULT '0000'
    --
   ,pov_global_id          OUT VARCHAR2
   ,pov_vorname            OUT VARCHAR2
   ,pov_nachname           OUT VARCHAR2
   ,pod_geburtsdatum       OUT DATE
   ,pov_anrede             OUT VARCHAR2
   ,pov_titel              OUT VARCHAR2
   ,pov_firmenname         OUT VARCHAR2
   ,pov_strasse            OUT VARCHAR2
   ,pov_hausnr_von         OUT VARCHAR2
   ,pov_hausnr_zusatz_von  OUT VARCHAR2
   ,pov_hausnr_bis         OUT VARCHAR2
   ,pov_hausnr_zusatz_bis  OUT VARCHAR2
   ,pov_plz                OUT VARCHAR2
   ,pov_ort                OUT VARCHAR2
   ,pov_iban               OUT VARCHAR2
   ,pov_ap_email           OUT VARCHAR2
   ,pov_ap_mobil_country   OUT VARCHAR2
   ,pov_ap_mobil_onkz      OUT VARCHAR2
   ,pov_ap_mobil_nr        OUT VARCHAR2
   ,pov_bu                 OUT VARCHAR2
  )
  ACCESSIBLE BY (
    PACKAGE PCK_GLASCONTAINER
  , PACKAGE PCK_GLASCONTAINER_GK
  , PACKAGE UT_GLASCONTAINER
  )  
  IS
  BEGIN
    -- 2022-11-23: für Bestandskunden Vor- und Nachnamen aus Siebel ergänzen:
    SELECT global_id, vorname, nachname, geburtsdatum, anrede, titel, firmenname
         , strasse, hausnr_von, hausnr_zusatz_von, hausnr_bis, hausnr_zusatz_bis, plz, ort
         , iban
         , ap_email, ap_mobil_country, ap_mobil_onkz, ap_x_mobil_nr
         , businessunit
      INTO pov_global_id, pov_vorname, pov_nachname, pod_geburtsdatum, pov_anrede, pov_titel, pov_firmenname
         , pov_strasse, pov_hausnr_von, pov_hausnr_zusatz_von, pov_hausnr_bis, pov_hausnr_zusatz_bis, pov_plz, pov_ort
         , pov_iban
         , pov_ap_email, pov_ap_mobil_country, pov_ap_mobil_onkz, pov_ap_mobil_nr
         , pov_bu
      FROM v_siebel_kundendaten -- v_apx_gc_customerdata@siebp.netcologne.intern@siebel_inf
     WHERE kundennummer = piv_kundennummer -- die Kundennummer ist in Siebel nicht zwingend numerisch, z.B. "1-60601804691"
     AND   filialnummer = piv_filialnummer 
    -- 2023-02-16: Workaround für die Situation, wenn die View für einen Kunden mehrere Datensätze zurückliefert:
       AND GUELTIG = 'Y' -- In der Entwicklung existierte dieses Feld bis April 2023 noch nicht, jetzt am 2023-06-15 aktiviert
    ;
  END p_get_siebel_kundendaten;  

  --@progress 2024-08-23----------------------------------------------------------

/**
 * @deprecated
 *
 * Liest die Kontaktdaten eines Kunden aus Siebel anhand der Kundennummer ein.
 * 
 * @param piv_kundennummer      [IN]   NR. des Kunden, dessen Daten gesucht werden
 * @param pov_ap_email          [OUT]  Primärer Ansprechpartner: E-Mail-Adresse
 * @param pov_ap_mobil_country  [OUT]  Primärer Ansprechpartner: Ländervorwahl mobil
 * @param pov_ap_mobil_onkz     [OUT]  Primärer Ansprechpartner: Netzvorwahl mobil
 * @param pov_ap_mobil_nr       [OUT]  Primärer Ansprechpartner: Rufnummer mobil
 * 
 * @throws  Alle Exceptions werden geworden.
 *          Kein Fehlerlogging: Das aufrufende Programm entscheidet, ob
 *          es einen Fehler loggen möchte (beispielsweise nicht, wenn 
 *          lediglich ein Tippfehler bei der Eingabe der Kundennummer auftritt)
 * @usage  Auftragserfassung im Glascontainer: Persönliche Daten
 * @ticket FTTH-3711
 * @krakar
 */  
  PROCEDURE p_get_siebel_kontaktdaten
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
    SELECT ap_email, ap_mobil_country, ap_mobil_onkz, ap_x_mobil_nr
    INTO pov_ap_email, pov_ap_mobil_country, pov_ap_mobil_onkz, pov_ap_mobil_nr
      FROM v_siebel_kundendaten
     WHERE kundennummer = piv_kundennummer
       AND GUELTIG = 'Y'
    ;
  END p_get_siebel_kontaktdaten;  


  -- @progress 2024-11-12  


  /** 
   * Aktiviert oder deaktiviert alle Abfragen gegen Siebel 
   * 
   * @param i_yes_no  Akzeptiert alle üblichen Strings, die "JA" bedeuten, 
   *                  andernfalls wird das Argument als "NEIN" interpretiert 
   * 
   * @usage  Kann bei Bedarf aus APEX heraus gesetzt werden, um beispielsweise 
   *         bei Problemen mit SIEBEL dessen Abfragen zu umgehen 
   */ 
    PROCEDURE USE_SIEBEL (i_yes_no IN VARCHAR2) 
    IS 
    BEGIN 
      G_USE_SIEBEL := NVL(UPPER(TRIM(i_yes_no)), 'N') IN ('1', 'TRUE', 'Y', 'YES', 'J', 'JA'); 
    END;   

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
  FUNCTION fj_siebel_process ( 
    piv_uuid            IN VARCHAR2 
   ,piv_order_number    IN VARCHAR2 
   ,piv_order_rowid     IN VARCHAR2 
   ,piv_username        IN VARCHAR2 
  ) RETURN CLOB  
  ACCESSIBLE BY (PACKAGE UT_GLASCONTAINER) 
  IS 
  vj_body           json_object_t := NEW json_object_t(c_empty_json); 
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
    cv_routine_name   CONSTANT logs.routine_name%TYPE := 'fj_siebel_process'; 
    FUNCTION fcl_params RETURN logs.message%TYPE IS 
    BEGIN 
        pck_format.p_add('piv_uuid', piv_uuid); 
        pck_format.p_add('piv_order_number', piv_order_number); 
        pck_format.p_add('piv_order_rowid', piv_order_rowid); 
        pck_format.p_add('piv_username', piv_username); 
        RETURN pck_format.fcl_params(cv_routine_name); 
    END fcl_params; 
  -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
  BEGIN 
      -- Daten zusammenfassen: 
      vj_body.put('id', piv_uuid); 
      vj_body.put('siebelOrderNumber', piv_order_number); 
      vj_body.put('siebelOrderRowId', piv_order_rowid); 
      vj_body.put('changedBy', piv_username); 
      RETURN vj_body.to_clob; 
  EXCEPTION 
      WHEN OTHERS THEN 
          pck_logs.p_error( 
            pic_message      => fcl_params() 
           ,piv_routine_name => qualified_name(cv_routine_name) 
           ,piv_scope        => G_SCOPE 
          ); 
          RAISE; 
  END fj_siebel_process;     



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
  PROCEDURE p_siebel_auftrag_abschliessen( 
    piv_uuid         IN FTTH_WS_SYNC_PREORDERS.ID%TYPE 
   ,piv_order_number IN VARCHAR2 
   ,piv_order_rowid  IN VARCHAR2 
   ,piv_app_user     IN VARCHAR2 
  ) 
  IS 
     vc_body CLOB; 
     v_ws_statuscode INTEGER;
     v_ws_response   CLOB;
     v_rest_error_message VARCHAR2(500 CHAR);
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
    cv_routine_name CONSTANT logs.routine_name%TYPE := 'p_siebel_auftrag_abschliessen'; 
    FUNCTION fcl_params RETURN logs.message%TYPE IS 
    BEGIN 
      pck_format.p_add('piv_uuid',         piv_uuid); 
      pck_format.p_add('piv_order_number', piv_order_number); 
      pck_format.p_add('piv_order_rowid',  piv_order_rowid); 
      pck_format.p_add('piv_app_user',     piv_app_user); 
      RETURN pck_format.fcl_params(cv_routine_name); 
    END fcl_params; 
  -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------       
  BEGIN 
    IF piv_uuid IS NULL THEN 
      raise_application_error(C_FAILED_SIEBEL_SPECS, 'Die Auftrags-ID aus dem Preorderbuffer fehlt'); 
    END IF; 

    IF piv_order_number IS NULL THEN 
      raise_application_error(C_FAILED_SIEBEL_SPECS, 'Die Siebel-Auftragsnummer fehlt'); 
    END IF; 

    IF piv_order_rowid IS NULL THEN 
      raise_application_error(C_FAILED_SIEBEL_SPECS, 'Die Siebel-ROWID fehlt'); 
    END IF; 

    IF piv_app_user IS NULL THEN 
      raise_application_error(C_FAILED_SIEBEL_SPECS, 'Der Username aus dem Glascontainer fehlt'); 
    END IF; 

    vc_body := fj_siebel_process ( 
      piv_uuid            => piv_uuid 
     ,piv_order_number    => piv_order_number 
     ,piv_order_rowid     => piv_order_rowid 
     ,piv_username        => piv_app_user 
    );  

    IF G_USE_SIEBEL THEN 
      -- Nach erfolgreicher Validierung den Webservice aufrufen: 
      -- Webservice zum Stornieren aufrufen: 
      pck_pob_rest.p_webservice_post2( 
          piv_kontext           => PCK_POB_REST.KONTEXT_PREORDERBUFFER 
        , piv_ws_key            => PCK_POB_REST.C_WS_KEY_SIEBEL_PROCESS 
        , piv_uuid              => piv_uuid 
        , piv_app_user          => piv_app_user 
        , pic_body              => vc_body 
        , pov_ws_statuscode     => v_ws_statuscode
        , pov_ws_response       => v_ws_response  
      );

      -- FTTH-4993 Zentrale Fehlermeldung angebunden
      -- Spezialfaelle wie vorher abgedeckt und falls Responsecode nicht von Sonderfall abgedackt wird, dann eine allg. Fehlermeldung ausgeben
      IF v_ws_statuscode != PCK_POB_REST.C_WS_STATUSCODE_OK
        THEN
          -- @ticket FTTH-4021: Der Webservice liefert als Fehlermeldung eine 412
          -- für Aufträge, die mit bereits verwendeten Siebel-Order-IDs abgeschlossen werden sollen
          IF v_ws_statuscode = PCK_POB_REST.C_WS_STATUSCODE_PRECONDITION
            THEN
              DECLARE
                v_uuid_duplikat FTTH_WS_SYNC_PREORDERS.ID%TYPE;
              BEGIN
                -- quick % dirty geparst, ohne JSON:
                v_uuid_duplikat := trim (both '"' from rtrim(substr(v_ws_response, instr(v_ws_response, '"', -3)), '}'));
                RAISE_APPLICATION_ERROR(C_FAILED_SIEBEL_SPECS, 
                     'Diese Siebel-Auftragsinformationen werden bereits in einem anderen Auftrag verwendet: ' 
                     || v_uuid_duplikat);
                     -- Im Fehlerfall lautet die Server Response z.B.: {"orderId":"PgxamsRkPxfnTOL50rlR1bPuzKEB6T"}
                     -- Der Text "Der Auftrag konnte nicht abgeschlossen werden:" wird in der Error Message
                     -- im Glascontainer Seite 20 vorangestellt
              END;
          ELSIF v_ws_statuscode = PCK_POB_REST.C_WS_STATUSCODE_CONFLICT
            THEN
              RAISE_APPLICATION_ERROR(-20409, 'Statuscode 409: Konflikt mit dem aktuellen Zustand der Zielressource');
          ELSE
          v_rest_error_message := PCK_POB_REST.fv_get_error_message(piv_json_response => v_ws_response);
          IF v_rest_error_message is null
            THEN
              v_rest_error_message := 'Statuscode ' || v_ws_statuscode;
              RAISE_APPLICATION_ERROR(-20000, v_rest_error_message);
            ELSE
              -- Anderfals zentrale Fehlermeldung ausgeben
              RAISE_APPLICATION_ERROR(-20000 - v_ws_statuscode, v_rest_error_message);
          END IF;
        END IF;
      END IF;
    END IF;
  EXCEPTION 
    WHEN OTHERS THEN 
      IF SQLCODE <> C_FAILED_SIEBEL_SPECS THEN 
        pck_logs.p_error( 
           pic_message      => fcl_params() 
          ,piv_routine_name => cv_routine_name 
          ,piv_scope        => G_SCOPE 
        ); 
      END IF; 
      RAISE;     
  END p_siebel_auftrag_abschliessen;   


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
 * @example   BEGIN PCK_GLASCONTAINER_EXT.p_ausbaugebiete_aktualisieren(pin_haus_lfd_nr => 1112107); END;
 * @unittest  SELECT * FROM TABLE(ut.run('UT_GLASCONTAINER', a_tags => 'P_AUSBAUGEBIETE_AKTUALISIEREN')); 
 */
  PROCEDURE "P_AUSBAUGEBIETE_AKTUALISIEREN" (pin_haus_lfd_nr IN V_GC_AUSBAUGEBIETE_RELEVANT.HAUS_LFD_NR%TYPE DEFAULT NULL)
  IS
    C_LISTAGG_TRENNZEICHEN CONSTANT VARCHAR2(1CHAR) := '|'; -- Wird im APEX Report "Auftragsliste" wieder in HTML Line Breaks umgewandelt.
    C_NULL                 CONSTANT VARCHAR2(1CHAR) := '-'; -- Wird bei fehlenden Spaltendaten angezeigt. Darf NULL sein.
    v_adresse_gefunden     NATURALN := 0;
    v_anzahl_fehler        NATURALN := 0;
  BEGIN
    FOR LOOP_ADRESSE IN (
      SELECT HAUS_LFD_NR
        FROM POB_ADRESSEN
       WHERE (pin_haus_lfd_nr IS NULL OR HAUS_LFD_NR = pin_haus_lfd_nr)
       ORDER BY 1
    )
    LOOP 
        v_adresse_gefunden := 1 + v_adresse_gefunden;
        -- ohne FORALL dauert das Aktualisieren sämtlicher Adressen 1-2 Minuten,
        -- aber dafür kann dediziert auf einzelne Fehler eingegangen werden,
        -- und das Subselect wäre selbst mit FORALL eine echte Spaßbremse
        <<DML>>
        BEGIN
        -- Update, wenn mindestens ein Ausbaugebiet existiert:
        UPDATE pob_adressen
           SET (AUSBAUGEBIETE, AUSBAUGEBIETSTYPEN, ERSCHLIESSUNGEN, STATUS_AUSBAUGEBIET, PROJEKTE, PROJEKTNAMEN) 
             = 
                (SELECT DISTINCT -- DISTINCT: Einer HAUS_LFD_NR können 1..n Ausbaugebiete zugeordnet sein,
                                -- dann entsteht eine einzige Ergebniszeile mit den nachfolgenden LISTAGGS.
                    (SELECT LISTAGG(NVL(AUSBAUGEBIET        , C_NULL) , C_LISTAGG_TRENNZEICHEN)  WITHIN GROUP (ORDER BY 2,3,4,5,6) FROM V_GC_AUSBAUGEBIETE_RELEVANT AG1 WHERE AG1.haus_lfd_nr = AG.HAUS_LFD_NR) AS AUSBAUGEBIETE
                  , (SELECT LISTAGG(NVL(AUSBAUGEBIETSTYP    , C_NULL) , C_LISTAGG_TRENNZEICHEN)  WITHIN GROUP (ORDER BY 2,3,4,5,6) FROM V_GC_AUSBAUGEBIETE_RELEVANT AG2 WHERE AG2.haus_lfd_nr = AG.HAUS_LFD_NR) AS AUSBAUGEBIETSTYPEN
                  , (SELECT LISTAGG(NVL(ERSCHLIESSUNG       , C_NULL) , C_LISTAGG_TRENNZEICHEN)  WITHIN GROUP (ORDER BY 2,3,4,5,6) FROM V_GC_AUSBAUGEBIETE_RELEVANT AG3 WHERE AG3.haus_lfd_nr = AG.HAUS_LFD_NR) AS ERSCHLIESSUNGEN
                  , (SELECT LISTAGG(NVL(STATUS_AUSBAUGEBIET , C_NULL) , C_LISTAGG_TRENNZEICHEN)  WITHIN GROUP (ORDER BY 2,3,4,5,6) FROM V_GC_AUSBAUGEBIETE_RELEVANT AG4 WHERE AG4.haus_lfd_nr = AG.HAUS_LFD_NR) AS STATUS_AUSBAUGEBIET
                  , (SELECT LISTAGG(NVL(PROJEKT             , C_NULL) , C_LISTAGG_TRENNZEICHEN)  WITHIN GROUP (ORDER BY 2,3,4,5,6) FROM V_GC_AUSBAUGEBIETE_RELEVANT AG5 WHERE AG5.haus_lfd_nr = AG.HAUS_LFD_NR) AS PROJEKTE
                  , (SELECT LISTAGG(NVL(PROJEKTNAME         , C_NULL) , C_LISTAGG_TRENNZEICHEN)  WITHIN GROUP (ORDER BY 2,3,4,5,6) FROM V_GC_AUSBAUGEBIETE_RELEVANT AG6 WHERE AG6.haus_lfd_nr = AG.HAUS_LFD_NR) AS PROJEKTNAMEN
                  FROM V_GC_AUSBAUGEBIETE_RELEVANT AG 
                 WHERE haus_lfd_nr = LOOP_ADRESSE.HAUS_LFD_NR

/*
select status_ausbaugebiet, count(*) from v_gc_ausbaugebiete group by status_ausbaugebiet;

STATUS_AUSBAUGEBIET         COUNT(*)
------------------------------------
Abgeschlossen                 168179
im Bau                         69858
Vorbewertung                   30477
in Planung                     13711
Abbruch                        12581
Beauftragt                     10829
Tiefbau fertig (LWL Montage)    5209
Pause                           1573
*/                   
                     -- Bedingungen exakt wie weiter unten: Sind nun in der View V_GC_AUSBAUGEBIETE_RELEVANT deklariert.
                     -- 2025-03-25: Diese können ignoriert werden laut Flo und Sebastian Tretter:
                     -- AND nvl(status_ausbaugebiet, '-') NOT IN (ABBRUCH, ABGESCHLOSSEN)
                     -- 2025-04-02 Dies kommt nur in der Entwicklung vor, nichtsdestotrotz ist es eine valide Bedingung:
                     -- AND status_ausbaugebiet IS NOT NULL -- neu 2025-04-01
               )
         WHERE HAUS_LFD_NR = LOOP_ADRESSE.HAUS_LFD_NR
           AND EXISTS (
            SELECT 1
              FROM V_GC_AUSBAUGEBIETE_RELEVANT
             WHERE HAUS_LFD_NR = LOOP_ADRESSE.HAUS_LFD_NR
               -- Bedingungen exakt wie oben! Nun in ..._RELEVANT abgebildet
               -- AND nvl(status_ausbaugebiet, '-') NOT IN (ABBRUCH, ABGESCHLOSSEN) 
               -- AND status_ausbaugebiet IS NOT NULL
               );

          -- Bestehende, aber nicht mehr aktuelle Einträge entfernen:
          IF SQL%ROWCOUNT = 0 THEN
              UPDATE pob_adressen
                 SET ausbaugebiete = NULL
                    ,ausbaugebietstypen = NULL
                    ,erschliessungen = NULL
                    ,status_ausbaugebiet = NULL                    
                    ,projekte  = NULL
                    ,projektnamen = NULL
               WHERE haus_lfd_nr = LOOP_ADRESSE.HAUS_LFD_NR
                 AND NOT EXISTS(
                SELECT 1
                  FROM V_GC_AUSBAUGEBIETE_RELEVANT
                 WHERE HAUS_LFD_NR = LOOP_ADRESSE.HAUS_LFD_NR           
               )
               ;
           END IF;
        EXCEPTION
          WHEN OTHERS THEN
          v_anzahl_fehler := 1 + v_anzahl_fehler;
        END DML;
    END LOOP;

    -- Neuen Datensatz anlegen, wenn es sich um einen Einzel-Aufruf handelt und noch keine Adresse persistiert ist:
    IF pin_haus_lfd_nr IS NOT NULL AND v_adresse_gefunden = 0
    THEN
       INSERT INTO POB_ADRESSEN (HAUS_LFD_NR, AUSBAUGEBIETE, AUSBAUGEBIETSTYPEN, ERSCHLIESSUNGEN, STATUS_AUSBAUGEBIET, PROJEKTE, PROJEKTNAMEN)
       SELECT DISTINCT HAUS_LFD_NR
              , (SELECT LISTAGG(NVL(AUSBAUGEBIET        , C_NULL) , C_LISTAGG_TRENNZEICHEN)  WITHIN GROUP (ORDER BY 2,3,4,5,6) FROM V_GC_AUSBAUGEBIETE_RELEVANT AG1 WHERE AG1.haus_lfd_nr = AG.HAUS_LFD_NR) AS AUSBAUGEBIETE
              , (SELECT LISTAGG(NVL(AUSBAUGEBIETSTYP    , C_NULL) , C_LISTAGG_TRENNZEICHEN)  WITHIN GROUP (ORDER BY 2,3,4,5,6) FROM V_GC_AUSBAUGEBIETE_RELEVANT AG2 WHERE AG2.haus_lfd_nr = AG.HAUS_LFD_NR) AS AUSBAUGEBIETSTYPEN
              , (SELECT LISTAGG(NVL(ERSCHLIESSUNG       , C_NULL) , C_LISTAGG_TRENNZEICHEN)  WITHIN GROUP (ORDER BY 2,3,4,5,6) FROM V_GC_AUSBAUGEBIETE_RELEVANT AG3 WHERE AG3.haus_lfd_nr = AG.HAUS_LFD_NR) AS ERSCHLIESSUNGEN
              , (SELECT LISTAGG(NVL(STATUS_AUSBAUGEBIET , C_NULL) , C_LISTAGG_TRENNZEICHEN)  WITHIN GROUP (ORDER BY 2,3,4,5,6) FROM V_GC_AUSBAUGEBIETE_RELEVANT AG4 WHERE AG4.haus_lfd_nr = AG.HAUS_LFD_NR) AS STATUS_AUSBAUGEBIET
              , (SELECT LISTAGG(NVL(PROJEKT             , C_NULL) , C_LISTAGG_TRENNZEICHEN)  WITHIN GROUP (ORDER BY 2,3,4,5,6) FROM V_GC_AUSBAUGEBIETE_RELEVANT AG5 WHERE AG5.haus_lfd_nr = AG.HAUS_LFD_NR) AS PROJEKTE
              , (SELECT LISTAGG(NVL(PROJEKTNAME         , C_NULL) , C_LISTAGG_TRENNZEICHEN)  WITHIN GROUP (ORDER BY 2,3,4,5,6) FROM V_GC_AUSBAUGEBIETE_RELEVANT AG6 WHERE AG6.haus_lfd_nr = AG.HAUS_LFD_NR) AS PROJEKTNAMEN
              FROM V_GC_AUSBAUGEBIETE_RELEVANT AG 
             WHERE haus_lfd_nr = pin_haus_lfd_nr;
    END IF;
  END;

    /**
    * Bestimmt für Kudnennummer, ob dieser Kunde geloescht ist
    *
    * @param piv_kundennummer  [IN ]  Kundennummer aus Siebel
    *
    * @ticket FTTH-5490
    */  

    FUNCTION fb_is_cust_locked (
    piv_kundennummer VARCHAR2
    ) return boolean as
      l_count number;

      -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
      cv_routine_name CONSTANT logs.routine_name%TYPE := 'fb_is_cust_locked'; 
      FUNCTION fcl_params RETURN logs.message%TYPE IS 
      BEGIN 
        pck_format.p_add('piv_kundennummer', piv_kundennummer); 
        RETURN pck_format.fcl_params(cv_routine_name); 
      END fcl_params; 

    BEGIN
      select count(1)
      into l_count 
      from v_ist_kunde_geloescht
      where kundennummer = PIV_KUNDENNUMMER
      and x_dsgvo_cust_locked = 'Y';

      if l_count > 0
        then
          return true;
        else 
          return false;
      end if;

    EXCEPTION
      WHEN OTHERS THEN
        pck_logs.p_error( 
           pic_message      => fcl_params() 
          ,piv_routine_name => cv_routine_name 
          ,piv_scope        => G_SCOPE 
        ); 
      raise;
    END fb_is_cust_locked;
END pck_glascontainer_ext;

/



-- sqlcl_snapshot {"hash":"59d5f91bfb478e8d6242669063460599f277ce81","type":"PACKAGE_BODY","name":"PCK_GLASCONTAINER_EXT","schemaName":"ROMA_MAIN","sxml":""}