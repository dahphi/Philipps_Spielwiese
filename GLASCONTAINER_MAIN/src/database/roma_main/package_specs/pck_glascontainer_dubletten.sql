create or replace package roma_main.pck_glascontainer_dubletten as 
/**
 * Funktionen zur Darstellung von Kunden-Dubletten in der APEX-App 2022 "Glascontainer"
 *
 * @date 2023-02
 * @author  Andreas Wismann WISAND <wismann@when-others.com>
 */
 
 
  -- Test auf Umlaute/Euro: ÄÖÜäöüß/?
  
  
  -- Wird angezeigt auf der Seite 10050 "Über diese Anwendung".
  -- Der gesamte String sollte als Ganzes aufsteigend sortierbar sein
  -- (an erster Stelle ist also das Datum maßgeblich)
  -- so dass die aktuellere Version stets lexikalisch "später" einsortiert werden kann: 
    version constant varchar2(30) := '2025-04-15 1345'; -- zuvor: '2024-04-30 0900'
  
  -- @model@fuzzy:
  -- FTTH_FUZZY_REQUESTS          : Log der Aufrufe des Fuzzy-Webservices (sowohl Einzel- als auch Sammelaufrufe per nächtlichem Job)
  -- FTTH_PREORDERS_FUZZYDOUBLE   : Ermittelte Fuzzy-Scores pro Auftrag im Preorderbuffer
  -- FTTH_PREORDERS_FUZZY_DETAILS : Details zu den Fuzzy-Scores (Ergebnisse der phonetischen und der Bank-Suche)
  -- FTTH_DUBLETTEN_BEWERTUNG     : Bewertungen der Mitarbeiter*innen zu den Fuzzy-Scores
  
  
  -- Alle Fehlermeldungen aus diesem Package benutzen diesen Scope:
    g_scope constant logs.scope%type := 'POB';
    function get_body_version return varchar2
        deterministic;
  
  /**
   * Liefert den HTML-Text (zusammen mit einem Icon) für die Selectliste "Bewertung" auf Seite 2022:40 zurück
   *
   * @param piv_bewertung [IN ]  Kürzel für die jeweilige Bewertung
   * @param pin_mit_icon  [IN ]  1= Es wird ein Icon vor den Text gestellt, 0= nur Text
   */
    function bewertungstext (
        piv_bewertung in ftth_dubletten_bewertung.bewertung%type,
        pin_mit_icon  in naturaln default 1
    ) return varchar2
        deterministic;
 
/**    
 * Liefert die tabellarische Ansicht der Kundendaten zurück, 
 * die auf Seite 2022:40 im Fuzzy-Bewertungsdialog angezeigt wird
 * 
 * 
 * @return Zeichenkette, in der jeder unbekannte/leere Wert mit einer
 *         doppelten geschweiften Klammer {{...}} repräsentiert wird
 *
 * @deprecated, @ticket FTTH-5038
  FUNCTION fv_karteikarte (
    pin_haus_lfd_nr       IN VARCHAR2
  , piv_kundennummer      IN VARCHAR2
  , piv_vorname           IN VARCHAR2
  , piv_nachname          IN VARCHAR2
  , piv_geburtsdatum      IN VARCHAR2
  , piv_anschluss_strasse IN VARCHAR2
  , piv_anschluss_hausnr  IN VARCHAR2
  , piv_anschluss_plz     IN VARCHAR2
  , piv_anschluss_ort     IN VARCHAR2
  , piv_iban              IN VARCHAR2
  , piv_html_id           IN VARCHAR2 DEFAULT NULL
  , piv_html_class        IN VARCHAR2 DEFAULT NULL
  ) RETURN VARCHAR2;
 */
 

/**    
 * Liefert die tabellarische Ansicht der Kundendaten zurück, 
 * die auf Seite 2022:40 im Fuzzy-Bewertungsdialog angezeigt wird
 * 
 * 
 * @return Zeichenkette, in der jeder unbekannte/leere Wert mit einer
 *         doppelten geschweiften Klammer {{...}} repräsentiert wird
 *
 * @ticket FTTH-5038, @ticket FTTH-5183: Neues Adressformat
 *
 */
    function fv_karteikarte (
        pin_haus_lfd_nr  in varchar2,
        piv_kundennummer in varchar2,
        piv_vorname      in varchar2,
        piv_nachname     in varchar2,
        piv_geburtsdatum in varchar2,
    /*
    piv_anschluss_strasse IN VARCHAR2,
    piv_anschluss_hausnr  IN VARCHAR2,
    piv_anschluss_plz     IN VARCHAR2,
    piv_anschluss_ort     IN VARCHAR2,
    */
        piv_adresse      in varchar2,
        piv_iban         in varchar2,
        piv_html_id      in varchar2 default null,
        piv_html_class   in varchar2 default null
    ) return varchar2;
  
  
  
/**    
 * Selektiert den Preorders-Datensatz und liefert die tabellarische Ansicht 
 * der Kundendaten zurück, die auf Seite 2022:40 im Fuzzy-Bewertungsdialog 
 * angezeigt wird
 * 
 * @return Zeichenkette, in der jeder unbekannte/leere Wert mit einer
 *         doppelten geschweiften Klammer {{...}} repräsentiert wird
 *
 */
    function fv_karteikarte (
        piv_ftth_id in ftth_ws_sync_preorders.id%type
    ) return varchar2;
  /**   
   * Tabellarische Ausgabe der Dublettenvorschläge auf Seite 2022:40
   *
   * @param piv_ftth_id      UUID des Auftrags, zu dem die Dubletten gesucht werden
   * @param piv_html_id      Optionale HTML-ID, welche die Tabelle mit den Ergebnissen bekommen soll
   * @param piv_html_class   Optionale HTML-Klasse, welche die Tabelle mit den Ergebnissen bekommen soll
   * @param piv_app_session  Hier die APEX Session-ID übergeben, damit gültige APEX-Links gebildet werden können
   * @param piv_apex_user    User können ihre eigenen Bewertungen löschen
   * @param pin_historie     Wenn 1, werden sämtliche Bewertungen aufgelistet,
   *                         andernfalls nur die jeweilige aktuelle (diese dann als Selectliste zur Bearbeitung)
   * @param pin_suchorte     Wenn 1, dann werden Dubletten im Preorderbuffer gesucht (@ticket 1769),
   *                         Wenn 2, dann in Siebel/Fuzzy,
   *                         Wenn 3 (oder NULL), dann sowohl im Preorderbuffer als auch in Siebel/Fuzzy.
   *
   */
    procedure htp_report (
        piv_ftth_id     in ftth_ws_sync_preorders.id%type,
        piv_html_id     in varchar2 default null,
        piv_html_class  in varchar2 default null,
        piv_app_session in varchar2 default null,
        piv_apex_user   in varchar2 default null,
        pin_historie    in natural default null,
        pin_suchorte    in natural default null
    );

end pck_glascontainer_dubletten;
/


-- sqlcl_snapshot {"hash":"628ea20cba4947ee2fd8db412f90c054ece6040b","type":"PACKAGE_SPEC","name":"PCK_GLASCONTAINER_DUBLETTEN","schemaName":"ROMA_MAIN","sxml":""}