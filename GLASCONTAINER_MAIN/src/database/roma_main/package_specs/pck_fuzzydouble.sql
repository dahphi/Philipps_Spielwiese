create or replace package roma_main.pck_fuzzydouble as
/**
 * Hilfsroutinen zum Abfragen und Auswerten der Fuzzy Double Dublettensuche
 * sowie der Dublettensuche im Glascontainer
 *
 * @ticket FTTH-531
 * @url    https://jira.netcologne.intern/browse/FTTH-531
 * @author WISAND  Andreas Wismann <wismann@when-others.com>
 * @AP     Thorsten Westenberg (Fuzzy-Suche in Siebel)
 * @AP     Tino Götting, Andreas Kunze (Betrieb Fuzzy-Server) 
 *
 * @creation 2022-12
 * @ticket https://jira.netcologne.intern/browse/SKV-147476
 */
 
------------------------------------------------------------------------------------------------------------------------ 
-- Haupt-Funktionen sind FT_PHONETIC_SEARCH und FT_DOUBLET_CHECK_BANK: Diese Table-Functions liefern live die
-- Ergebnisse der Fuzzy!Double-Suche unter Verwendung bestimmter Abfrageparameter zurück. 
-- Sie stützen sich auf die Abfrage des FuzzyDouble-Webservice in den Funktionen FX_PHONETIC_SEARCH 
-- und FX_DOUBLET_CHECK_BANK ab, indem sie deren XML-Ausgabe parsen und in eine SQL-Ergebnismenge umwandeln.
------------------------------------------------------------------------------------------------------------------------
    version constant varchar2(30) := '2024-06-26 0830';
    src_pho constant varchar2(3) := 'PHO';
    src_bnk constant varchar2(3) := 'BNK';
    src_pob constant varchar2(3) := 'POB';
  
  -- Alle Fehlermeldungen aus diesem Package benutzen diesen Scope:
    g_scope constant logs.scope%type := 'POB';
    subtype t_url is varchar2(1000);
    subtype t_xpath is varchar2(4000); -- sollte reichen für XPATH-Ausdrücke
    subtype t_request is varchar2(32767);
  
  
  
-- @deprecated
    c_xpath_errors_bankresponse constant t_xpath := '//ns2:FDDoubletCheckBankResponseWrapper/FDSearchResponse/FDResult';
    type t_fuzzy_person is record (
            src          varchar2(3) -- BNK|PHO|POB, neu 2024-05-21
            ,
            row_id       varchar2(100),
            kundennummer varchar2(100)  -- neu 2024-05-22
            ,
            rule_number  integer,
            score        number,
            vorname      varchar2(100),
            nachname     varchar2(100),
            geburtsdatum date,
            firmenname   varchar2(100),
            strasse      varchar2(100),
            hausnummer   varchar2(30),
            plz          varchar2(10),
            ort          varchar2(100),
            iban         varchar2(100),
            kontonummer  varchar2(100),
            bic          varchar2(30)
    );
    type t_fuzzy_persons is
        table of t_fuzzy_person;
    c_plausi_error_number constant integer := -20001;
 /**
  * Setzt den Wert für die Package-Variable G_IGNORE_SERVICE_ERRORS.
  *
  * @param pib_setting  [IN ]  TRUE|FALSE. Wenn TRUE, führen Netzwerk-Exceptions an der Fuzzy-Serviceschnittstelle
  *                            zu keiner Exception, sondern verhalten sich wie eine leere Ergebismenge.
  *                            (kann beispielsweise in DEV sinnvoll sein, um im Grid weiter entwickeln zu können)
  */
    procedure ignore_service_errors (
        pib_setting in boolean
    );
  
/**
 * Gibt den Versionsstring des Package Bodies zurück
 */
    function get_body_version return varchar2
        deterministic;  
/**
 * Gibt den kompletten ungeparsten XML-Antwortbaum 'doubletCheckBank' zurück
 * (Dublettensuche in Siebel über Kontoverbindung)
 *
 * @param piv_iban        IBAN der Kontoverbindung, zu der Übereinstimmungen gesucht werden
 * @param piv_kontonummer (optional) Kontonummer nach altem Muster, bevor es IBAN gab
 * @param piv_bic         (optional) Bank Identifier Code (BIC)
 *
 * @usage    Es dürfen nicht alle drei Parameter zugleich leer sein
 * @throws   User Defined Exception: wenn alle drei Parameter leer sind.
 *           Alle anderen Exceptions werden geloggt und geworfen.
 *
 * @example
 * select pck_fuzzydouble.fx_doublet_check_bank(piv_iban => 'DE77301602130000827010') from dual; -- keine Dublette
 * select pck_fuzzydouble.fx_doublet_check_bank(piv_iban => 'DE02370501980001802057') from dual; -- viele Dubletten
 *
 */
    function fx_doublet_check_bank (
        piv_iban        in varchar2,
        piv_kontonummer in varchar2 default null,
        piv_bic         in varchar2 default null
    ) return xmltype;
/**
 * @deprecated - stattdessen FT_DOUBLET_CHECK_BANK benutzen. /// Ab 02.01.2023: FUNCTION löschen
 */
    function bank_liste (
        piv_iban        in varchar2,
        piv_kontonummer in varchar2 default null,
        piv_bic         in varchar2 default null
    ) return t_fuzzy_persons
        pipelined;
/**
 * Table Function: 
 * Gibt die geparste Antwort der Dublettensuche zur Kontoverbindung
 * ("DoubletCheckBank") als SQL-Tabelle zurück
 *
 * @param piv_iban                   IBAN der Kontoverbindung, zu der Übereinstimmungen gesucht werden,
 *                                   darf keine Kleinbuchstaben oder Leerzeichen enthalten
 * @param piv_kontonummer            (optional) Kontonummer nach altem Muster, bevor es IBAN gab
 * @param piv_bic                    (optional) Bank Identifier Code (BIC)
 * @param pin_ignore_service_errors  (optional 0|1) wenn 1, werden Netzwerk-Fehler wie "leere Ergebnismenge" behandelt
 *
 * @usage    Es dürfen nicht alle Parameter zugleich leer sein
 * @throws   User Defined Exception: wenn alle Parameter leer sind.
 *           Alle anderen Exceptions werden geloggt und geworfen.
 *
 * @example
 * select * from table(pck_fuzzydouble.ft_doublet_check_bank('DE77301602130000827010')); -- keine Dublette
 *
 * @example
 * select * from table(pck_fuzzydouble.ft_doublet_check_bank('DE02370501980001802057')); -- viele Dubletten
 *
 * @example
 * -- vollständige Spaltenliste:
 * SELECT ROW_ID, RULE_NUMBER, SCORE, VORNAME, NACHNAME, GEBURTSDATUM, FIRMENNAME, STRASSE, HAUSNUMMER, PLZ, ORT, IBAN, KONTONUMMER, BIC
 *   FROM TABLE(PCK_FUZZYDOUBLE.ft_doublet_check_bank('DE02370501980001802057'));
 *
 * @throws
 * Insbesondere in der Entwicklungsumgebung tritt teilweise der Fehler auf, dass die Fuzzy-Suche nicht erreichbar ist:
 * ORA-10702 Cannot reach ncvservicet:40003 
 */
    function ft_doublet_check_bank (
        piv_iban                  in varchar2,
        piv_kontonummer           in varchar2 default null,
        piv_bic                   in varchar2 default null,
        pin_ignore_service_errors in natural default null
    ) return t_fuzzy_persons
        pipelined;
    
/**
 * Gibt den kompletten ungeparsten XML-Antwortbaum 'PhoneticSearch' zurück
 * (Änlichkeitssuche in Siebel über Namen und Adressen)
 *
 * @param piv_nachname   [IN]  Nachname
 * @param piv_vorname    [IN]  Vorname
 * @param piv_firmenname [IN]  Firmennname
 * @param piv_strasse    [IN]  Straße
 * @param piv_hausnummer [IN]  Hausnummer
 * @param piv_plz        [IN]  Postleitzahl
 * @param piv_ort        [IN]  Ort
 *
 * @usage    Es dürfen nicht alle Parameter zugleich leer sein
 * @throws   User Defined Exception: wenn alle Parameter leer sind.
 *           Alle anderen Exceptions werden geloggt und geworfen.
 *
 * @example
 * select pck_fuzzydouble.fx_phonetic_search(piv_nachname => 'Müller-Lüdenscheid') from dual;
 *
 */
    function fx_phonetic_search (
        piv_nachname   in varchar2,
        piv_vorname    in varchar2,
        piv_firmenname in varchar2 default null,
        piv_strasse    in varchar2 default null,
        piv_hausnummer in varchar2 default null,
        piv_plz        in varchar2 default null,
        piv_ort        in varchar2 default null
    ) return xmltype;
/**
 * Table Function: 
 * Gibt die geparste Antwort der Phonetischen Personen-Suche
 * ("Phonetic Search") als SQL-Tabelle zurück
 *
 * @param piv_nachname              [IN] Nachname
 * @param piv_vorname               [IN] Vorname
 * @param piv_firmenname            [IN] Firmenname
 * @param piv_strasse               [IN] Straße
 * @param piv_hausnummer            [IN] Hausnummer
 * @param piv_plz                   [IN] Postleitzahl
 * @param piv_ort                   [IN] Ort
 * @param pin_ignore_service_errors [IN] (optional 0|1) wenn 1, werden Netzwerk-Fehler wie "leere Ergebnismenge" behandelt 
 * 
 *
 * @usage    Es dürfen nicht alle Parameter zugleich leer sein
 *
 * @throws   User Defined Exception: wenn alle Parameter leer sind.
 *           Alle anderen Exceptions werden geloggt und geworfen.
 *
 * @example
 * -- vollständige Spaltenliste:
 * SELECT ROW_ID, RULE_NUMBER, SCORE, VORNAME, NACHNAME, GEBURTSDATUM, FIRMENNAME, STRASSE, HAUSNUMMER, PLZ, ORT, IBAN, KONTONUMMER, BIC
 *   FROM TABLE(pck_fuzzydouble.ft_phonetic_search(
 *     piv_nachname => 'Mustermann'
 *   , piv_vorname  => 'Erika'
 *   , piv_firmenname => NULL
 *   , piv_strasse    => NULL
 *   , piv_hausnummer => NULL
 *   , piv_plz        => NULL
 *   , piv_ort        => NULL
 * ));
 *
 * @throws
 * Insbesondere in der Entwicklungsumgebung tritt teilweise der Fehler auf, dass die Fuzzy-Suche nicht erreichbar ist:
 * ORA-10702 Cannot reach ncvservicet:40003
 */
    function ft_phonetic_search (
        piv_nachname              in varchar2,
        piv_vorname               in varchar2,
        piv_firmenname            in varchar2 default null,
        piv_strasse               in varchar2 default null,
        piv_hausnummer            in varchar2 default null,
        piv_plz                   in varchar2 default null,
        piv_ort                   in varchar2 default null,
        pin_ignore_service_errors in natural default null
    ) return t_fuzzy_persons
        pipelined;
/**
 * Ermittelt im Fehlerfall den Error-Code sowie den Fehlerstring
 * in der Antwort des Fuzzydouble-Servers; bei Erfolg bleiben die OUT-Parameter leer
 *
 * @param pix_response    [IN ] Vollständige Response des Servers
 * @param piv_xpath       [IN ] Falls bekannt, kann hier der XPath-Ausdruck bis
 *                              zur Fehlerliste angegeben werden,
 *                              dies macht die Suche performanter
 * @param pov_errorcode   [OUT] Leer, wenn der originale Errorcode = 200 ist (dies bedeutet Erfolg),
 *                              ansonsten der Inhalt des Tags <InternalErrorCode>
 * @param pov_errortext   [OUT] Leer, wenn der Errorcode = 200 ist und der Fehlertext = 'OK' w?,
 *                              ansonsten der Inhalt des Tags <InternalErrorText>
 */
    procedure p_parse_response_errors (
        pix_response  in xmltype,
        piv_xpath     in varchar2 default null,
        pov_errorcode out varchar2,
        pov_errortext out varchar2
    );
  
/**  
 * Wirft eine Exception, wenn in der Fuzzydouble-Antwort ein anderer
 * Errorcode als 200 vorkommt
 *
 * @param pix_response  Ungeparste Antwort vom FuzzyDouble-Server
 * @param piv_xpath     Falls bekannt, kann hier der XPath-Ausdruck bis
 *                      zur Fehlerliste angegeben werden, dies macht die Suche performanter
 * @usage   Nach dem Erhalt einer Serverantwort diese Prodzedur aufrufen: 
 *          Sofern der Returncode = 200 ist passiert nichts, ansonsten wird eine Exception
 *          an die aufrufende Prozedur hochgereicht
 * @throws  User Defined Exception, wenn der returnierte Errorcode einen anderen Wert als 200 hat
 *          (der SQLCODE liegt dann zwischen -20001 und -20999: Returncode 500 ergibt beispielsweise -20500)
 *          Alle anderen Exceptions werden geloggt und geworfen.
 */
    procedure p_check_response_errors (
        pix_response in xmltype,
        piv_xpath    in varchar2 default null
    );  
  
/**  
 * Liefert die Ergebnisse der Dublettenprüfung für die Glascontainer-Bestellstrecke
 *
 * @param piv_nachname              [IN]  Nachname des Bestellers (nicht case-sensitiv)
 * @param piv_vorname               [IN]  Vorname des Bestellers (nicht case-sensitiv)
 * @param pid_geburtsdatum          [IN]  Geburtstag des Bestellers
 * @param piv_firmenname            [IN]  ggf. Firmenname des Bestellers (nicht case-sensitiv)
 * @param piv_strasse               [IN]  Installationsadresse: Straße  (nicht case-sensitiv)
 * @param piv_hausnummer            [IN]  Installationsadresse: Haunr. inkl. Zusatz  (nicht case-sensitiv)
 * @param piv_plz                   [IN]  Installationsadresse: Postleitzahl
 * @param piv_ort                   [IN]  Installationsadresse: Ort  (nicht case-sensitiv)
 * @param piv_iban                  [IN]  Bankverbindung: IBAN (nicht case-sensitiv)
 * @param pin_ignore_service_errors [IN]  (optional, default: 0) Wenn 1, dann werden keine Fehler geworfen, wenn
 *                                        Fuzzy nicht erreichbar ist (typischerweise ist das so in der Entwicklungsumgebung)
 * @param pin_find_1_only           [IN]  (optional, default: 0) Wenn 1, dann kehrt die Funktion bereits mit der
 *                                        ersten gefundenen Dublette zurück (hilfreich, wenn APEX lediglich wissen möchte,
 *                                        ob mindestens eine Dublette existiert)
 * @piv_suchbereich                 [IN]  (optional) NULL  : Sämtliche Quellen durchsuchen
 *                                                   SIE   : Siebel durchsuchen (nicht den Glascontainer)
 *                                                   PHO   : Siebel durchsuchen, aber nur phonetisch
 *                                                   BNK   : Siebel durchsuchen, aber nur IBAN-Suche
 *                                                   POB   : Preorderbuffer durchsuchen (nicht Siebel)
 *                                                   POB-N : Preorderbuffer durchsuchen, aber nur Neukundenaufträge
 *                                                   POB-B : Preorderbuffer durchsuchen, aber nur Bestandskundenaufträge
 * 
 * @return T_FUZZY_PERSONS PIPELINED 
 *
 * @ticket FTTH-2804
 *
-- @deprecated, ersetzt durch PCK_GLASCONTAINER_ORDER.ft_vorbestellung_dublettencheck
--              aufgrund der extrem schlechten Performance der Fuzzy-Einzelvergleiche in der Produktion
  FUNCTION ft_vorbestellung_dublettencheck (
      piv_nachname          IN VARCHAR2
     ,piv_vorname           IN VARCHAR2
     ,pid_geburtsdatum      IN DATE
     ,piv_firmenname        IN VARCHAR2
     ,piv_strasse           IN VARCHAR2
     ,piv_hausnummer        IN VARCHAR2
     ,piv_plz               IN VARCHAR2
     ,piv_ort               IN VARCHAR2
     ,piv_iban              IN VARCHAR2
     ,pin_ignore_service_errors IN NATURAL DEFAULT 0
     ,pin_find_1_only       IN NATURAL DEFAULT 0
     ,piv_suchbereich       IN VARCHAR2 DEFAULT NULL
  )
  RETURN t_fuzzy_persons PIPELINED;
 */
end pck_fuzzydouble;
/


-- sqlcl_snapshot {"hash":"d9629d8a44c2b46c1fc923e6fe78d5dbe274f965","type":"PACKAGE_SPEC","name":"PCK_FUZZYDOUBLE","schemaName":"ROMA_MAIN","sxml":""}