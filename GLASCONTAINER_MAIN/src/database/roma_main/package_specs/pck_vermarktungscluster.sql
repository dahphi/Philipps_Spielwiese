create or replace package roma_main.pck_vermarktungscluster as
/**
 * Geschäftslogik für den Umgang mit Vermarktungsclustern
 * (APEX App 1210 "Vermarktungscluster")
 *
 * @author WISAND  <wismann@when-others.com>
 *
 * @date 2024-02-28 Neue Routine fr_vermarktungscluster (verschoben hierher aus PCK_GLASCONTAINER)
 * @date 2023-09-12 @ticket FTTH-2698 Löschen von Siebel-Ready-Objekten aus VMC
 * @date 2023-05-16 @ticket FTTH-1972 Änderung des Statuswertes
 * @date 2023-04-04 p_objekt_zuordnen: Parameter pin_modus ist nicht mehr optional 
 * @date 2023-03-30 @ticket FTTH-1787: Definierter Statusübergang VMC
 * @date 2022-10-27 Umstellung auf offizielles DML-Package
 * @date 2022-10-20 Listenimport 
 * @date 2022-10-11 Zuordnen eines Objekts zu einem Vermarktungscluster
 * 
 * @author Andreas Wismann <wismann@when-others.com>
 *
 * @usage In der Entwicklungsumgebung existiert hierzu eine utPLSQL-Testsuite: Package UT_VERMARKTUNGSCLUSTER.
 *        Vor jeglichen Änderungen an diesem Package unbedingt prüfen, ob alle
 *        Unit-Tests im Vorhinein erfolgreich sind:
 *        SELECT * FROM TABLE(ut.run('UT_VERMARKTUNGSCLUSTER'));
 */

-- Umlaute/Euro-Zeichen: ÄÖÜäöü?
    version constant varchar2(30) := '2025-04-15 1845';
    vc_status_areaplanned constant vermarktungscluster.status%type := 'AREAPLANNED';
    vc_status_premarketing constant vermarktungscluster.status%type := 'PREMARKETING';
    vc_status_underconstruction constant vermarktungscluster.status%type := 'UNDERCONSTRUCTION';
    collection_p4_checkbox constant apex_collections.collection_name%type := 'P4_CHECKBOX';  -- Speichert die Checkboxen auf Seite 1210:4
    collection_p4_adressen constant apex_collections.collection_name%type := 'P4_A_'; -- danach folgt der Parameter-Hash

    c_plausi_error_number constant integer := -20001;
    c_ws_error_number constant integer := -20002;
    e_plausi exception;
    pragma exception_init ( e_plausi, -20001 );
  -- Alle Fehlermeldungen aus diesem Package benutzen diesen Scope:
    g_scope constant logs.scope%type := 'VMC';
    type t_lov_entry is record (
            d varchar2(255) -- Display Value
            ,
            r varchar2(100) -- Return Value
    );
    type t_lov is
        table of t_lov_entry;  

    -- Liste mit beliebig vielen HAUS_LFD_NRn, wird zur Parameterübergabe verwendet:
    type t_objektliste is
        table of number;

  -- e_not_implemented exception; -- Alle noch nicht ausprogrammierten Routinen werfen diese Exception

    subtype t_config_smallint is smallint;
  -- Mit welcher Geschäftslogik wird ein Objekt einem Vermarktungscluster zugeordnet:
    c_modus_wiedereinsetzen constant t_config_smallint := -9; -- Eine gelöschte Zuordnung wird wiederhergestellt (siehe FTTH_LOG_SIEBEL_READY_VCO) 
    c_modus_aufheben constant t_config_smallint := -1; -- Eine bestehende Zuordnung wird gelöscht, keine neue angelegt
    c_modus_einfach constant t_config_smallint := 0; -- Objekt kann nur frisch zugeordnet werden: Fehler bei bestehender Zuordnung
    c_modus_alternativ constant t_config_smallint := 1; -- Objekt wird umgehängt (Standard, @see FTTH-561)
    c_modus_mehrfach constant t_config_smallint := 2; -- Es erfolgen ggf. weitere Zuordnungen (das Datenmodell erlaubt dies derzeit)

    c_plausi_adresse constant t_config_smallint := 1;
    c_plausi_zuordnung constant t_config_smallint := 2;
    c_plausi_objekt constant t_config_smallint := -4;
    c_aktion_wurde_ausgeschlossen constant varchar2(100) := 'Aktion wurde ausgeschlossen';

  /**
   * Gibt den Versionsstring des Package Bodies zurück
   */
    function get_body_version return varchar2
        deterministic;  

        -- SELECT SEQ_ID
        -- notwendige Daten ----------- 
        --      , N001 AS ZEILENNUMMER_CSV
        --      , N002 AS GEPLANTE_AKTION
        --      , N003 AS STATUS (AKTION)
        --      , N004 AS FEHLERCODE (nach Ausführung der Aktion) -- 2023-12-21 war: AS VCO_LFD_NR (nach Ausführung der Aktion)
        --      , N005 AS PROBLEMKATEGORIE (vor Ausführung der Aktion)
        --      , C001 AS HAUS_LFD_NUMMER
        --      , C002 AS VMC_ALT (VC_LFD_NR)
        --      , C003 AS VMC_NEU (VC_LFD_NR)
        --     -- C004 AS FEHLERMELDUNG (SQLERRM nach Ausführung der Aktion)
        --      , C005 AS VALIDIERUNG (vor Ausführung der Aktion)
        ------------------------------
        -- angereicherte Daten:
        --      , C006 AS HAUS_ADRESSE
        --      , C007 AS VMC_ALT_BEZEICHNUNG
        --      , C008 AS VMC_NEU_BEZEICHNUNG
        --      ,
        --      , C011 AS STR
        --      , C012 AS NR
        --      , C013 AS ZUS
        --      , C014 AS PLZ
        --      , C015 AS ORT
        --   FROM APEX_COLLECTIONS 
        --  WHERE COLLECTION_NAME = PCK_VERMARKTUNGSCLUSTER.COLLECTION_NAME_AKTIONSLISTE  
    function collection_name_aktionsliste return varchar2
        deterministic;  

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
   */
    function fr_vermarktungscluster (
        pin_haus_lfd_nr in vermarktungscluster_objekt.haus_lfd_nr%type
    ) return vermarktungscluster%rowtype;  
/**
 * Fügt den gesamten Inhalt des Reports, der durch die Items 
 * "Ausbaugebiet", "Ausbaugebiet Typ" bzw. "Adresse" gefunden wurde, zur Auswahl hinzu.
 * Im Unterschied zur Header-Checkbox umfasst das auch diejenigen Zeilen, 
 * die in der aktuellen Pagination nicht zu sehen sind.
 *
 * @disabled  Eigentlich eine schöne Funktion, die aber voraussetzt, dass der Benutzer
 *            entweder keine individuellen Filter verwendet, oder dass man an diese
 *            Filterkriterien im IR herankommt - dafür gibt es aber in APEX 22.1 
 *            nur eine @deprecated API (APEX_IR.get_report)
  PROCEDURE p_alle_ergebnisse_auswaehlen (
    pin_ausbaugebiet     IN VARCHAR2
  , piv_ausbaugebiet_typ IN VARCHAR2
  , piv_adresse          IN VARCHAR2
  ) ;

 */  

/**
 * Löscht alle Collections, deren Namen mit dem übergebenen LIKE-Muster übereinstimmen
 *
 * @param piv_collection_name_like   Suchmuster für den Collection-Namen, beispielsweise 'P4%'
 */
    procedure p_reset_alle_collections (
        piv_collection_name_like in varchar2
    );

/**
 * Ordnet alle in der Collection P4_CHECKBOX angehakten HAUS_LFD_NRn 
 * dem Vermarktungscluster zu
 *
 * @param pin_vc_lfd_nr  ID des Vermarktungsclusters, dem die Objekte zugeordnet werden sollen
 *
 * @usage APEX 1210:4
 *
 * @deprecated: Stattdessen nach Fertigstellung PROCEDURE p_objektauswahl_vc_zuordnen verwenden. 
 *              Löschen, wenn App 1210 Version 2023-04-26 online ist.
 */
    procedure auswahl_zuordnen (
        pin_vc_lfd_nr in vermarktungscluster.vc_lfd_nr%type
    );

/**
 * Ordnet einem Vermarktungscluster alle Objekte des ausgewählten Gebiets zu
 *
 * @param pin_vc_lfd_nr  ID des Vermarktungsclusters, dem die Objekte zugeordnet werden sollen
 * @param piv_gebiet     Auswahl in der Selectliste "Ausbaugebiet"
 * @param piv_typ        Auswahl in der Selectliste "Ausbaugebiet Typ"
 *
 * @return  Im Modus "ZAEHLEN" wird die Anzahl der zuordenbaren Objekte zurückgegeben,
 *          ansonsten
 * @usage Benutzer klickt in 1210:4 auf den Button "Komplettes Gebiet zuordnen"
 */
    function komplettes_gebiet_zuordnen (
        pin_vc_lfd_nr in vermarktungscluster.vc_lfd_nr%type,
        piv_gebiet    in strav.gebiet.gebiet%type,
        piv_typ       in strav.gebiet.typ%type
    ) return natural;

/**
 * Gibt einen Hashwert aus bis zu 5 Parametern zurück, Länge maximal 200 Bytes
 */
    function fv_parameter_hash (
        piv_1 in varchar2 default null,
        piv_2 in varchar2 default null,
        piv_3 in varchar2 default null,
        piv_4 in varchar2 default null,
        piv_5 in varchar2 default null
    ) return varchar2;
/**
 * Trägt den aktuellen Zustand einer Checkbox auf der Seite "OBJEKTE-HINZUFUEGEN"
 * in die APEX Collection ein.
 *
 * @param piv_collection_name  Name der Collection, die die Checkbox-Zustände speichert
 * @param pin_checked          Gewünschter Zustand der Checkbox nach dem Klicken (1= angehakt, 0= nicht angehakt, entspricht N002),
 *                             gefüllt durch apex_application.g_x01  
 * @param pin_key              Fachlicher Schlüssel zur ausgewählten Zeile (entspricht N001),
 *                             gefüllt durch apex_application.g_x02
 *
 * @usage Unmittelbar nach jedem Klick einer Checkbox wird diese Prozedur als Application Process aufgerufen.
 *        Das visuelle Setzen ("Häkchen") der Checkbox wird ebenfalls erst durch den Callback
 *        des Application Processes bewirkt, somit ist dieser Mechanismus weitestgehend
 *        robust gegen Verbindungs-Abbrüche
 */
    procedure asp_set_checkbox (
        piv_collection_name in apex_collections.collection_name%type,
        pin_checked         in apex_collections.n002%type,
        pin_key             in apex_collections.n001%type
    );

/**
 * Trägt den aktuellen Zustand einer Checkbox für alle in pin_keys gelisteten
 * Zeilen in die APEX Collection ein
 *
 * @param piv_collection_name  Name der Collection, die die Checkbox-Zustände speichert
 * @param pin_checked          Gewünschter Zustand der Checkboxen nach dem Klicken (1= angehakt, 0= nicht angehakt, entspricht N002),
 *                             gefüllt durch apex_application.g_x01
 * @param pin_keys             Kommaseparierte Liste mit fachlichen Schlüsseln (entspricht N001),
 *                             gefüllt durch apex_application.g_x02
 *
 * @usage Wird aufgerufen, wenn im Report die Header-Checkbox angeklickt wird ("alle setzen", "alle löschen")
 */
    procedure asp_set_checkboxes (
        piv_collection_name in apex_collections.collection_name%type,
        pin_checked         in apex_collections.n002%type,
        pin_keys            in varchar2
    );

    procedure asp_header_checked (
        piv_collection_name in apex_collections.collection_name%type,
        pin_keys_1          in varchar2,
        pin_keys_2          in varchar2,
        pin_keys_3          in varchar2,
        pin_keys_4          in varchar2,
        pin_keys_5          in varchar2,
        pin_keys_6          in varchar2,
        pin_keys_7          in varchar2,
        pin_keys_8          in varchar2,
        pin_keys_9          in varchar2,
        pin_keys_10         in varchar2
    );

/**
 * Entfernt alle Auswahl-Häkchen für die in den _keys_-Parametern aufgelisteten Schlüssel
 *
 * @param piv_collection_name  Name der APEX-Collection, in der die Häkchen gespeichert werden
 * @param pin_keys_1           Erste,   kommaseparierte Liste mit numerischen Schlüsseln
 * @param pin_keys_2           Zweite,  kommaseparierte Liste mit numerischen Schlüsseln
 * @param pin_keys_3           Dritte,  kommaseparierte Liste mit numerischen Schlüsseln
 * @param pin_keys_4           Vierte,  kommaseparierte Liste mit numerischen Schlüsseln
 * @param pin_keys_5           Fünfte,  kommaseparierte Liste mit numerischen Schlüsseln
 * @param pin_keys_6           Sechste, kommaseparierte Liste mit numerischen Schlüsseln
 * @param pin_keys_7           Siebte,  kommaseparierte Liste mit numerischen Schlüsseln
 * @param pin_keys_8           Achte,   kommaseparierte Liste mit numerischen Schlüsseln
 * @param pin_keys_9           Neunte,  kommaseparierte Liste mit numerischen Schlüsseln
 * @param pin_keys_10          Zehnte,  kommaseparierte Liste mit numerischen Schlüsseln
 */
    procedure asp_header_not_checked (
        piv_collection_name in apex_collections.collection_name%type,
        pin_keys_1          in varchar2,
        pin_keys_2          in varchar2,
        pin_keys_3          in varchar2,
        pin_keys_4          in varchar2,
        pin_keys_5          in varchar2,
        pin_keys_6          in varchar2,
        pin_keys_7          in varchar2,
        pin_keys_8          in varchar2,
        pin_keys_9          in varchar2,
        pin_keys_10         in varchar2
    );    

/**
 * Gibt die Anzahl der Zeilen in einer APEX Collection zurück, deren Spalte N001
 * den Wert 1 besitzt (i.e. Checkboxen, die angehakt sind)
 *
 * @param piv_collection_name  Name der Collection, die die Checkboxen speichert
 */
    function fn_count_checked_members (
        piv_collection_name in apex_collections.collection_name%type
    ) return naturaln;    
/**    
 * Liefert den SQL-Abfragestring für den Report auf Seite 4 zurück
 *
 * @param pin_ausbaugebiet       ID des Gebiets, falls ausgewählt (zu befüllen mit P4_SEARCH_GEBIET) 
 * @param piv_ausbaugebiet_typ   Name des Ausbaugebiet-Typs (nicht weiter dokumentiert, zu befüllen mit P4_SEARCH_TYP) 
 * @param piv_adresse            Inhalt des Eingabefeldes "Adresssuche" (zu befüllen mit P4_SEARCH_ALL)
 * @param piv_do_Search          (nicht dokumentiert, zu befüllen mit P4_DO_SEARCH)
 * @param pin_vc_lfd_nr          (optional) ID des Vermarktungsclusters, dem die Adressen zugeordnet werden sollen 
 * @param pib_auswahl_bearbeiten (optional) wenn TRUE, zeigt der Report nur die bereits ausgewählten Adressen an
 *                               und ignoriert die übergebenen Filter-Parameter (piv_search_all etc.)
 *
 * @usage Der String war bisher in APEX hinterlegt, nicht dokumentiert.
 */
    function fv_query_p4 (
        pin_ausbaugebiet     in varchar2,
        piv_ausbaugebiet_typ in varchar2,
        piv_adresse          in varchar2,        
    --    piv_do_search          IN VARCHAR2,
        pin_vc_lfd_nr        in vermarktungscluster.vc_lfd_nr%type default null,
        pib_skip_checkboxes  in boolean default null
    ) return varchar2;

/**
 * Erzeugt eine Collection auf der Basis von fv_query_p4 und gibt anstatt der
 * Original-Abfrage die Abfrage auf ebendiese Collection zurück
 */
    function fv_query_p4_collection (
        pin_ausbaugebiet       in varchar2,
        piv_ausbaugebiet_typ   in varchar2,
        piv_adresse            in varchar2,        
    --    piv_do_search          IN VARCHAR2,
        pin_vc_lfd_nr          in vermarktungscluster.vc_lfd_nr%type default null,
        pib_auswahl_bearbeiten in boolean default null
    ) return varchar2;    
/**
 * Setzt alle Zeilen der Aktionsliste auf "nicht ausführen",
 * die in irgendeine Problemkategorie fallen (gelb und rot markierte)
 */
    procedure p_alle_auffaelligen_deaktivieren;

/**
 * Setzt alle Zeilen der Aktionsliste auf "nicht ausführen",
 * die in eine schwerwiegende Problemkategorie fallen und so die Ausführung
 * der gesamten Liste verhindern würden (rot markierte)
 */
    procedure p_showstopper_deaktivieren;  

/**
 * Liest die APEX Collection namens AKTIONSLISTE und führt alle Aktionen durch,
 * die dort auf "ausführen = ja" eingestellt sind. 
 * Es gilt das "Alles oder Nichts"-Prinzip: Sämtliche Aktionen werden zurückgerollt, 
 * wenn eine einzige fehlschlägt.
 *
 * @param piv_aktion  IN  Derzeit nur implementiert: 'AKTIONSLISTE'
 *
 * @usage Getestet wurde mit etwa 5000 Datensätzen: Diese Menge ist klein genug,
 *        um den Prozess synchron aus APEX heraus aufzurufen. für eine erheblich
 *        größere Anzahl von Aktionen sollte geprüft werden, ob ein asynchroner
 *        Prozessaufruf der bessere Weg ist.
 *
 * @return  Anzahl der kritischen Fehler (0..n), die bei der Ausführung aufgetreten sind.
 *          Wenn dies > 0 ist, dann wurden alle Aktionen zurückgerollt.
 */
    function p_listenaktionen_ausfuehren (
        piv_aktion in varchar2
    ) return naturaln;  

/**
 * Reagiert per AJAX auf das Umschalten des Schalters "Ausführen" im STEP-3
 * des Listenimport-Wizards (APEX 1210:11)
 *
 * @param pin_seq_id            Primärschlüssel der entsprechenden APEX_COLLECTION:
 *                              Collection-Zeile (nicht CSV-Zeile!), deren Zustand
 *                              geändert werden soll
 * @param pin_schalterstellung  0=nicht ausführen, 1=ausführen
 */
    procedure p_aktion_umschalten (
        pin_seq_id           in apex_collections.seq_id%type,
        pin_schalterstellung in naturaln
    );
/**   
 * Gibt den Inhalt einer in APEX_APPLICATION_TEMP_FILES hochgeladenenen Datei zurück
 *
 * @param pin_file_id  Identifier der Datei (Spalte APEX_APPLICATION_TEMP_FILES.ID)
 *
 * @exception  Alle Exceptions werden geworfen. Kein Logging.
 */
    function f_blob_content_temp_files (
        pin_file_id in apex_application_temp_files.id%type
    ) return blob;

/**
 * Liest die Importliste (APEX 1210:11), erzeugt die Collection AKTIONSLISTE dynamisch 
 * und befüllt sie mit den vom Wizard (STEP-2) erzeugten Aktionsdaten, die dann
 * in STEP-3 vom Benutzer editiert oder bestägt werden
 *
 */
    procedure p_create_aktionsliste (
        pib_blob_content       in blob,
        piv_dateiname          in varchar2,
        pin_start_zeilennummer in positiven,
        pin_spaltennummer_haus in positiven,
        pin_aktion             in integer,
        piv_vmc_neu            in varchar2,
        -----------------------
        piv_spaltentrenner     in varchar2 default ';',
        piv_zeilentrenner      in varchar2 default chr(10)
    );

/**
 * Gibt den Inhalt jeder Spalte einer bestimmten Zeile einer CSV-Datei zurück,
 * und deren Spaltennummer.
 *
 * @param pib_blob_content  Zu durchsuchende Datei
 * @param piv_dateiname       Name der Datei, aus der ihr Typ (CSV, XLSX) abgeleitet werden kann
 * @param pin_zeilennummer  Nummer der Zeile (mit 0 beginnend), deren Spalten
 *                          analyisiert werden
 * @param piv_spaltentrenner  Zeichen, das die Spalten voneinander trennt (default: Semikolon)
 * @param piv_zeilentrenner   Zeichen oder Zeichenfolge, die die Zeilen voneinander trennt (default: LINE FEED [10])
 */
    function get_header_columns (
        pib_blob_content   in blob,
        piv_dateiname      in varchar2,
        pin_zeilennummer   in positiven,
        piv_spaltentrenner in varchar2 default ';',
        piv_zeilentrenner  in varchar2 default chr(10)
    ) return t_lov
        pipelined;
/**
 * Liest eine CSV- oder Excel-Datei ein und prüft, ob eine Header-Spalte andhand
 * des Suchmusters innerhalb der ersten 50 Spalten gefunden wird. 
 * In diesem Fall werden die Informationen über den ersten passenden Fundort
 * an die OUT-Parameter übergeben, die ansonsten leer bleiben.
 *
 * @param pib_blob_content    Inhalt der zu durchsuchenden Datei
 * @param piv_dateiname       Name der Datei, aus der ihr Typ (CSV, XLSX) abgeleitet werden kann
 * @param piv_suchmuster      LIKE-Suchmusterstring, Beispiel: %HAUS_LFD_NR% (nicht case-sensitiv)
 * @param pin_zeilennummer    Wenn gefüllt, dann wird nur in dieser Zeile (1..n) gesucht
 * @param piv_spaltentrenner  Zeichen, das die Spalten voneinander trennt (default: Semikolon)
 * @param piv_zeilentrenner   Zeichen oder Zeichenfolge, die die Zeilen voneinander trennt (default: LINE FEED [10])
 * @param pin_scan_zeile      (optional) Anzahl Zeilen, die nach pin_skip_zeilen analysiert werden sollen (default: 1)
 * @param pon_zeilennummer    Falls gefüllt, ist dies die Nummer der Zeile, in der die gesuchte Üerschrift gefunden wurde
 * @param pon_spaltennummer   Falls gefüllt, ist dies die Nummer der Spalte, in der die gesuchte Üerschrift gefunden wurde
 * @param pov_spaltenname     Falls gefüllt, ist dies der originale Wortlaut der gefundenen Spalte
 *
 * @usage    APEX 1210:11
 * @example  In einer Datei, die einen Spalten-Header namens HAUS_LFD_NR enthält,
 *           wird mit dem Suchmuster '%haus%lfd%nr%' die Fundstelle ermittelt.
 */
    procedure p_finde_spalte_in_csv_header (
        pib_blob_content   in blob,
        piv_dateiname      in varchar2,
        piv_suchmuster     in varchar2,
        pin_zeilennummer   in natural default null,
        piv_spaltentrenner in varchar2 default ';',
        piv_zeilentrenner  in varchar2 default chr(10),
        pin_scan_zeilen    in naturaln default 1,
        pon_zeilennummer   out natural,
        pon_spaltennummer  out natural,
        pov_spaltenname    out varchar2
    );

/**
 * Ordnet ein Objekt einem Vermarktungscluster zu, wobei per Modus bestimmt werden kann,
 * ob bei bereits bestehender Zuordnung diese aufgehoben wird (default),
 * eine weitere Verknüpfung hinzugefügt wird, oder die Prozedur eine Exception wirft. 
 * Die Funktion liefert die ID der Verknüpfung aus der Tabelle VERMARKTUNGSCLUSTER_OBJEKT zurück.
 * Besteht die gewünschte Zuordnung bereits, wird keine DML-Aktion ausgeführt (da überflüssig),
 * stattdessen wird nur die existierende ID zurückgegeben. 
 *
 * @param pin_haus_lfd_nr  ID des Objekts, das zugeordnet werden soll
 * @param pin_vc_lfd_nr    ID des Vermarktungsclusters, mit dem das Objekt nun verknüpft werden soll
 * @param pin_modus        Angewendete Geschäftslogik, siehe: C_MODUS_INITIAL|C_MODUS_ALTERNATIV|C_MODUS_MEHRFACH
 *
 * @exception  NO_DATA_FOUND: Objekt (Tabelle HAUS) konnte nicht gefunden werden
 * @exception  USER DEFINED: Verstoß gegen Geschäftsregel
 */
    function fn_objekt_zuordnen (
        pin_haus_lfd_nr in vermarktungscluster_objekt.haus_lfd_nr%type,
        pin_vc_lfd_nr   in vermarktungscluster_objekt.vc_lfd_nr%type,
        pin_modus       in t_config_smallint
    ) return vermarktungscluster_objekt.vco_lfd_nr%type;

/**
 * Ordnet ein Objekt einem Vermarktungscluster zu oder löscht die Zuordnung.
 *
 * Diese Prodezur stützt sich auf die Funktion FN_OBJEKT_ZUORDNEN ab,
 * führt also dieselben DML-Aktionen aus, nur liefert sie nicht die 
 * Verknüpfungs-ID zurück.
 *
 * @param pin_haus_lfd_nr  ID des Objekts, das zugeordnet werden soll
 * @param pin_vc_lfd_nr    ID des Vermarktungsclusters, mit dem das Objekt nun verknüpft werden soll.
 *                         Falls NULL und pin_modus = AUFHEBEN, wird eine bestehende Verknüpfung gelöscht,
 *                         für jeden anderen Modus darf diese ID nicht NULL sein
 * @param pin_modus        Angewendete Geschäftslogik, siehe: C_MODUS_AUFHEBEN|C_MODUS_INITIAL|C_MODUS_ALTERNATIV|C_MODUS_MEHRFACH,
 *                         der Standard ist C_MODUS_ALTERNATIV (bestehende Verknüpfungen werden zunächst aufgehoben)
 *
 */
    procedure p_objekt_zuordnen (
        pin_haus_lfd_nr in vermarktungscluster_objekt.haus_lfd_nr%type,
        pin_vc_lfd_nr   in vermarktungscluster_objekt.vc_lfd_nr%type,
        pin_modus       in t_config_smallint
    );

/**
 * @ticket FTTH-1787: Gibt eine kommaseparierte Liste aller Statuswerte zurück,
 * in die ein Vermarktungscluster wechseln darf (der eingegebene, aktuelle Status 
 * ist ebenfalls in diesem String enthalten, damit die Werteliste als
 * APEX LOV verwendbar ist)
 *
 * @param piv_aktueller_status [IN ] Momentaner Zustand eines beliebigen Vermarktungsclusters,
 *                                   typischerweise UPPERCASE, aber nicht case-sensitiv
 *
 * @return  Sofern der eingegebene Status NULL oder ein gültiger Status ist,
 *          wird die Liste der folgenden Status geliefert. Existiert
 *          der Status nicht, erfolgt ein Application Error. Alle Status werden
 *          UPPERCASE ausgegeben, weil dies der Schreibweise in der Spalte
 *          VERMARKTUNGSCLUSTER.STATUS entspricht.
 *
 * @exception  Application Error, wenn der eingegebene aktuelle Status einen
 *             Wert besitzt, der nicht in der Tabelle VERMARKTUNGSCLUSTER
 *             vorkommen kann. Kein Logging des Fehlers - dies muss gegebenenfalls 
 *             vom aufrufenden Programm durchgeführt werden.
 *
 * @example
 * SELECT COLUMN_VALUE AS FOLGESTATUS
 *   FROM TABLE (APEX_STRING.SPLIT(
 *     PCK_VERMARKTUNGSCLUSTER.fv_vc_folgestatus(
 *       piv_aktueller_status => 'AreaPlanned')
 *       , ','
 *     )
 * );
 */
    function fv_vc_folgestatus (
        piv_aktueller_status in varchar2
    ) return varchar2
        deterministic;

/**
 * Gibt den Display-Wert für einen Vermarktungscluster-Status zurück.
 * 
 * @param piv_status [IN ] Statuswert, der in der Tabelle VERMARKTUNGSCLUSTER verwendet wird
 *
 * @return
 * Jeder unbekannte Wert wird 1:1 zurückgegeben.
 * Status NULL ergibt Statusdisplay NULL.
 */
    function fv_vc_status_display (
        piv_status vermarktungscluster.status%type
    ) return varchar2
        deterministic;

/**
 * Gibt den vom Webservice erwarteten Statuswert zurück, siehe @ticket FTTH-1972
 * 
 * @param piv_status [IN ] Statuswert, der in der Tabelle VERMARKTUNGSCLUSTER verwendet wird
 *
 * @return
 * Jeder unbekannte Wert wird 1:1 zurückgegeben.
 * Status NULL ergibt Statusdisplay NULL.
 */
    function fv_vc_status_webservice (
        piv_status vermarktungscluster.status%type
    ) return varchar2
        deterministic;  

/**  
 * Ändert den Status eines Vermarktungsclusters
 *
 * @param pin_vc_lfd_nr  [IN ] PK des Vermarktungsclusters
 * @param piv_status_alt [IN ] Bestehender Status in der exakten Schreibweise von VERMARKTUNGSCLUSTER.STATUS.
 *                             Dient zur Überprüfung, ob bei Verwendung des DML-Packages die unvermeidliche
 *                             Verzögerung zwischen Aufruf dieser Prozeder, SELECT und nachfolgendem UPDATE
 *                             dazu geführt hat, dass Concurrent Updates stattgefunden haben 
 *                             (unwahrscheinlich, aber möglich). Ist diese Prüfung nicht nötig, darf
 *                             piv_status_alt mit NULL übergeben werden.
 * @param piv_status_neu [IN ] Neuer Status in der exakten Schreibweise von VERMARKTUNGSCLUSTER.STATUS
 * @param piv_username   [IN ] Name des App-Users, der die Änderung durchführt
 *
 * @usage
 * Update erfolgt unter Zuhilfenahme des DML-Packages für die Tabelle VERMARKTUNGSCLUSTER
 */
    procedure p_update_status (
        pin_vc_lfd_nr  in vermarktungscluster.vc_lfd_nr%type,
        piv_status_alt in vermarktungscluster.status%type,
        piv_status_neu in vermarktungscluster.status%type,
        piv_username   in varchar2 default null
    );  


/**
 * Nimmt die LFD_NR eines Vermarktungsclusters entgegen sowie eine optionale Liste mit
 * HAUS_LFD_NRn, die diesem VC gerade neu zugeordnet wurden,
 * prueft den Status des Vermarktungsclusters, und sendet die Zuordnungen
 * per REST an den Webservice, sofern die Geschaeftsregeln dies erfordern.
 *
 * @param pin_vc_lfd_nr    [IN ] PK des Vermarktungsclusters
 * @param pit_objektliste  [IN ] PL/SQL-Table mit den Objektnummern, die dem VC
 *                               zugeordnet werden sollen; wenn dieser Parameter NULL ist,
 *                               werden alle Objekte im Vermarktungscluster ermittelt
 * @param piv_username     [IN ] Kuerzel des Benutzers, der die Aenderung durchfuehrt
 * @param pin_force_update [IN ] (optinal) Wird hier ein Wert größer als 0 übergeben, 
 *                               so wird der REST-Aufruf in jedem Fall durchgeführt,
 *                               unabhängig vom Status des Vermarktungsclusters
 * @ticket FTTH-1787
 *
 * @usage
 * Wenn einem bestehenden Vermarktungscluster im Status "Under Construction" neue Objekte hinzugefügt werden, 
 * muss eine Mitteilung mit der Liste der betroffenen HAUD_LFD_NRn an den Preorder-Buffer gesendet werden.
 * Das aufrufende Programm muss sich nicht um die Geschaeftsregeln kuemmern,
 * sondern lediglich diese Funktion auf den Returnwert FALSE abfragen
 * (NULL bzw. TRUE bedeuten: alles wie erwartet)
 *
 * @return  TRUE:  Der Webservice wurde aufgerufen und lieferte "Erfolg" zurueck
 *          FALSE: Der Webservice wurde aufgerufen und antwortete mit einem Fehlerstatus
 *          NULL:  Der Webservice wurde aufgrund der Geschaeftsregeln nicht aufgerufen
 *                 (dies stellt keinen Fehler dar, sollte aber dediziert auswertbar sein,
 *                 daher NULL anstatt TRUE)
 *
 * @throws  EXCEPTION (wird nicht geloggt), wenn Eingangsparameter unvollstaendig sind
 *          oder der Vermarktungscluster nicht existiert
 * @throws  EXCEPTION (wird geloggt), wenn der faellige WS-Aufruf aus technischen Gruenden
 *          nicht durchgefuehrt werden konnte (nicht erreichbar, Timeout etc.),
 *          so dass keine verwertbare Serverantwort vorliegt
 *
 * @example
 * BEGIN
 *   IF NOT PCK_VERMARKTUNGSCLUSTER.fb_ws_vermarktungscluster_objektmeldung(
 *        pin_vc_lfd_nr   => 4711
 *      , pit_objektliste => PCK_VERMARKTUNGSCLUSTER.T_OBJEKTLISTE(NEW PCK_VERMARKTUNGSCLUSTER.T_OBJEKT(999))
 *      , piv_username    => 'FOOBAR'
 *   ) THEN
 *      RAISE_APPLICATION_ERROR(-20001, 'REST Webservice-Aufruf liefert Fehler zurueck');
 *   END IF; 
 * END;
 *
 * @date 2023-04-06
 *          
 */
    function fb_ws_vermarktungscluster_objektmeldung (
        pin_vc_lfd_nr    in vermarktungscluster.vc_lfd_nr%type,
        pit_objektliste  in t_objektliste,
        piv_username     in varchar2,
        pin_force_update in natural default null
    ) return boolean;

/**
 * Ordnet alle in der Collection P4_CHECKBOX angehakten HAUS_LFD_NRn 
 * dem Vermarktungscluster zu
 *
 * @todo: @ticket FTTH-1787: Wenn der Vermarktungscluster UNDERCONSTRUCTION ist, 
 * müssen die HAUS_LFD_NRn zuvor an den Webservice geschickt werden @ticket FTTH-1891, @ticket FTTH-1972
 *
 * @exception  Wenn die Auswahl leer ist und folglich keine Zuordnung stattfindet,
 *             wird eine User Defined Exception ausgegeben, damit APEX dies
 *             als Benutzerhinweis darstellen kann.
 *
 * @param pin_vc_lfd_nr  ID des Vermarktungsclusters, dem die Objekte zugeordnet werden sollen
 * @param piv_username   Kürzel des APEX-Users, der den Vorgang ausführt
 *
 * @usage APEX 1210:4 
 *
 */
-- ///// ersetzt PROCEDURE auswahl_zuordnen
    procedure p_objektauswahl_vc_zuordnen (
        pin_vc_lfd_nr in vermarktungscluster.vc_lfd_nr%type,
        piv_username  in varchar2
    );

    function print (
        pit_objektliste t_objektliste
    ) return varchar2
  --  ACCESSIBLE BY ( PACKAGE UT_VERMARKTUNGSCLUSTER )
    ;

  ---PROCEDURE APEX_UNIT_TEST_FTTH_2162 (piv_username IN VARCHAR2);

    procedure sanitize (
        pin_vc_lfd_nr in vermarktungscluster_objekt.vc_lfd_nr%type default null
    );
/**
 * Refresht die Materialized View MV_VERMARKTUNGSCLUSTER_STATISTIK
 *
 * @usage Aufruf nächtlich durch Scheduler-Job "JOB_VERMARKTCLUSTER_STAT"
 */
    procedure p_statistik_aktualisieren;  

/**
 * Führt ein Update einer Vermarktungscluster-Zeile durch und ruft anschließend
 * (falls nötig, dies wird geprüft) einen Aufruf des Preorderbuffer Webservices auf. 
 * Wenn dieser fehlschlägt, wird das Update zurückgerollt und eine Exception geworfen.

 -- @date 2023-11-09: Wird in der Spec nicht mehr zur Verfügung gestellt.
 -- Stattdessen fn_merge_cluster verwenden.

  procedure p_update_mit_meldung_pob (
    pir_vermarktungscluster    IN  vermarktungscluster%ROWTYPE
  );
 */  

/**
 * Löscht einen Vermarktungsluster mit der Möglichkeit, 
 * auch die Objektzuordnungen zu löschen
 *
 * @param pin_vc_lfd_nr    [IN ] ID des Clusters, der gelöscht werden soll
 * @param pib_delete_vco   [IN ] Wenn TRUE (default), werden zuvor alle Objektzuordnungen gelöscht.
 *
 * @usage Es wird das offizielle DML-Package aufgerufen
 * @ticket FTTH-2636
 * @date 2023-08-15
 */
    procedure p_delete_vermarktungscluster (
        pin_vc_lfd_nr  in vermarktungscluster_objekt.haus_lfd_nr%type,
        pib_delete_vco in boolean default true
    );  

/**
 * Entfernt für alle Objekte, die inzwischen "Siebel-Ready" sind,
 * ihre Zuordnung zum Vermarktungscluster
 *
 * @param pin_vc_lfd_nr [IN ] (optional) Falls gesetzt, werden nur Objekte dieses
 *                            bestimmten Vermarktungsclusters berücksichtigt
 *
 * @ticket FTTH-2698
 *
 * @usage
 * Stand 2023-10: Aufruf nächtlich durch Scheduler-Job "JOB_SIEBELREADY_VCO_DEL" 
 *
 * @example
 * BEGIN PCK_VERMARKTUNGSCLUSTER.siebel_ready_objekte_entfernen; END;
 * SELECT * FROM FTTH_LOG_SIEBEL_READY_VCO;
 */
    procedure siebel_ready_objekte_entfernen (
        pin_vc_lfd_nr in vermarktungscluster_objekt.vc_lfd_nr%type default null
    );
/**
 * Macht die automatische Entfernung von SIEBEL-ready-Objekten aus
 * Vermarktungsclustern wieder rückgängig, indem alle Einträge eines 
 * bestimmten Tages aus dem Lösch-Log gelesen und die Objekte wieder dem
 * ursprünglichen Vermarktungscluster zugewiesen werden,
 * und gibt die entweder bei Erfolg die Anzahl der wiederhergestellten Objekte 
 * (0 oder positive Zahl)
 * bzw. - sofern auch nur ein einziger Fehler aufgetreten ist - die Anzahl der 
 * dabei aufgetretenen Fehler zurück (negative Zahl)
 *
 * @param pid_datum      [IN ]  Nur an diesem Tage gelöschte Objekte werden zurückgeholt
 * @param pin_vc_lfd_nr  [IN ]  Optional: Nur Objekte dieses Vermarktungsclusters
 *                              werden zurückgeholt
 * @param piv_action     [IN ]  Optionaler Vermerk, der abschließend im Log-Eintrag der Tabelle CORE.LOGS
 *                              hinzugefügt wird (z.B. 'wegen Datenfehler wiederhergestellt' oder änliches)
 *
 * @usage
 * Da die Prozedur nicht selbst committet, kann man nach dem Aufruf zunächst
 * den Rückgabewert analysieren.
 *
 * @example  Prüfen, welche Löschungen rückgängig gemacht werden können, die gestern
 *           (typischerweise im letzten nächtlichen Lauf) stattgefunden haben,
 *           und anschließend ein Rollback, weil zunächst nur die Info geholt werden soll:
 *
 * SELECT PCK_VERMARKTUNGSCLUSTER.undo_siebel_ready_objekte_entf (
 *     pid_datum => SYSDATE - 1
 *   , piv_action => 'nur ein Test'
 * ) FROM DUAL;
 * ROLLBACK; -- Der CORE.LOGS-Eintrag wird trotzdem geschrieben, unabhängig von COMMIT oder ROLLBACK.
 *
 */
    function undo_siebel_ready_objekte_entf (
        pid_datum     in ftth_log_siebel_ready_vco.datum%type,
        pin_vc_lfd_nr in ftth_log_siebel_ready_vco.vc_lfd_nr%type default null,
        piv_action    in logs.action%type default null
    ) return naturaln;
/**
 * Erzeugt oder aktualisiert einen Vermarktungscluster und gibt dessen VC_LFD_NR zurück;
 * im Fall einer Aktualisierung wird unmittelbar anschließend, falls erforderlich,
 * der Preorderbuffer Webservice aufgerufen, der die zugeordneten Objekte meldet.
 * 
 * @param pin_vc_lfd_nr                  [IN] Bisherige Laufende Nummer des Clusters,
 *                                            wenn leer wird ein neuer Cluster angelegt, 
 *                                            ansonsten erfolgt ein Update
 * @param piv_mandant                    [IN] NA|NC für NetAachen oder NetCologne
 * @param piv_bezeichnung                [IN] Name des Vermarktungsclusters
 * @param pid_ausbau_plan_termin         [IN] Voraussichtliche Fertigstellung
 * @param pin_dnsttp_lfd_nr              [IN] Diensttyp
 * @param piv_url                        [IN] URL der Landing-Page für Privatkunden
 * @param piv_url_gk                     [IN] URL der Landing-Page für Geschäftskunden
 * @param piv_status                     [IN] Status (UNDERCONSTRUCTION|AREAPLANNED|PREMARKETING)
 * @param piv_aktiv                      [IN] 1=aktiv, 0=nicht aktiv
 * @param pin_mindestbandbreite          [IN] Mindestbandbreite, Wert in Mbit/s
 * @param pin_zielbandbreite_geplant     [IN] Geplante Zielbandbreite, Wert in Mbit/s
 * @param pin_kosten_hausanschluss       [IN] Kosten für den Hausanschluss, Wert in Euro ggf. inkl Nachkommastellen
 * @param pin_kundenauftrag_erforderlich [IN] 1=Kundenauftrag erforderlich, 0=nicht erforderlich
 * @param piv_netwissen_seite            [IN] URL der Netwissen-Seite für diesen Vermarktungscluster
 * @param piv_wholebuy                   [IN] Kürzel des Wholebuy-Partners (TCOM=Telekom)
 * 
 * @usage  APEX-Seite 1210:1 und 1210:3: Dialog zum Anlegen und Ändern von Vermarktungscluster-Stammdaten
 *
 * @return VERMARKTUNGSCLUSTER.VC_LFD_NR%TYPE
 */
    function fn_merge_cluster (
        pin_vc_lfd_nr                  in integer,
        piv_mandant                    in varchar2,
        piv_bezeichnung                in varchar2,
        pid_ausbau_plan_termin         in date,
        pin_dnsttp_lfd_nr              in integer,
        piv_url                        in varchar2,
        piv_url_gk                     in varchar2, -- 2023-07-12 @ticket FTTH-2190
        piv_status                     in varchar2,
        piv_aktiv                      in integer,
        pin_mindestbandbreite          in number,
        pin_kosten_hausanschluss       in number,
        pin_kundenauftrag_erforderlich in integer,
        piv_netwissen_seite            in varchar2,
        piv_wholebuy                   in varchar2,
        piv_anlage_typ                 in varchar2 default 'MANUELL'
    ) return vermarktungscluster.vc_lfd_nr%type;

/**
 * Sendet eine Zusammenfassung aller WHOLEBUY-Vermarktungscluster an den Preorder-Buffer
 *
 * @ticket FTTH-2907, @ticket FTTH-2901
 * @usage Wird durch JOB_VMC_WHOLEBUY_POB nächtlich aufgerufen 
 *
 * @example
 * BEGIN PCK_VERMARKTUNGSCLUSTER.p_wholebuy_objektmeldung; END;
 */
    procedure p_wholebuy_objektmeldung;  

-- @progress 2024-06-26

/**
 * Aktualisiert die Spalte VERMARKTUNGSCLUSTER_OBJEKT.EIGENTUEMERDATEN_NOTWENDIG
 *  aus der gleichnamigen Spalte der Tabelle(n)
 *  - TCOM_ADR_BSA (Stand 2024-06)
 *
 * @param pin_vc_lfd_nr  [IN]  Falls gesetzt, werden nur Objekte aktualisiert,
 *                             die sich im entsprechenden Vermarktungscluster befinden
 *
 * @usage  Wird aufgerufen durch nächtlichen Aktualisierungprozess namens ////
 * @ticket FTTH-3169: Datenquelle TCOM_ADR_BSA aktualisiert VERMARKTUNGSCLUSTER_OBJEKT
 */
    procedure p_update_eigentuemerdaten_notwendig (
        pin_vc_lfd_nr vermarktungscluster_objekt.vc_lfd_nr%type default null
    );

end pck_vermarktungscluster;
/


-- sqlcl_snapshot {"hash":"3067eea96c8109705b34e6a8f1d8d86dac3a6688","type":"PACKAGE_SPEC","name":"PCK_VERMARKTUNGSCLUSTER","schemaName":"ROMA_MAIN","sxml":""}