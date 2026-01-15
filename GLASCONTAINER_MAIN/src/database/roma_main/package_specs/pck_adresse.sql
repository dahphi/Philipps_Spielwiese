create or replace package roma_main.pck_adresse as
    version constant varchar2(30) := '2025-03-27 1200';



/**
 * Erstellt aus einzelnen Adressbestandteilen einen Gesamtstring, analog zur View STRAV.V_ADRESSEN ("ADRESSE_KOMPL"),
 * wobei diese Function präziser mit ungetrimmten Adress-Bestandteilen umgeht
 * 
 * @param piv_strasse               [IN] Straße
 * @param piv_hausnummer            [IN] Hausnummer, zB. '36'
 * @param piv_hausnummer_zusatz     [IN] Hausnummerzusatz, z.B. 'a'
 * @param piv_hausnummer_bis        [IN] Falls die Hausnummer aus zwei Teilen besteht, ist dies der Teil nach dem Trennstrich, z.B. '37'
 * @param piv_hausnummer_zusatz_bis [IN] Falls der Hausnummern-Zusatz aus zwei Teilen besteht, ist dies der 2. Teil, z.B. 'f'
 * @param piv_gebaeudeteil          [IN] Gebäudeteil
 * @param piv_plz                   [IN] Postleitzahl
 * @param piv_ort                   [IN] Ort
 * @param piv_ortsteil              [IN] optionaler Ortsteil, überlicherweis ohne Klammern oder sonstige Verbindungszeichen
 * @param piv_land                  [IN] Länderkennung (z.B. NL; DE nicht notwendig)
 * @param piv_trennzeichen          [IN] (optional) Ersetzt die Default-Kommaseparierung (', ') durch eine andere Zeichenfolge,
 *                                       z.B. '<br/>' oder CHR(10) || CHR(13)
 * 
 * @return Adressen-String, auch wenn nicht alle Felder gefüllt sind, ggf. Leerstring
 *
 * @ticket FTTH-5183
 */
    function adresse_komplett (
        piv_strasse               in varchar2,
        piv_hausnummer            in varchar2,
        piv_hausnummer_zusatz     in varchar2,
        piv_hausnummer_bis        in varchar2,
        piv_hausnummer_zusatz_bis in varchar2,
        piv_gebaeudeteil          in varchar2,
        piv_plz                   in varchar2,
        piv_ort                   in varchar2,
        piv_ortsteil              in varchar2,
        piv_land                  in varchar2 default null,
        piv_trennzeichen          in varchar2 default null
    ) return varchar2
        deterministic;  



/**  
 * Liest die Spalte ADRESSE_KOMPL aus der View V_ADRESSEN für eine bestimmte HAUS_LFD_NR
 * und gibt diese kommasepariert zurück, oder NULL falls die Adresse nicht gefunden wird.
 *
 * @param pin_haus_lfd_nr    [IN ]  Schlüssel für die Adresse
 * @param piv_trennzeichen   [n/a]  //// Geht derzeit (noch) nicht, da in den Straßen und Gebäudeteilen Kommata enthalten sind
 *
 * @ticket FTTH-5038
 */
    function adresse_komplett (
        pin_haus_lfd_nr in v_adressen.haus_lfd_nr%type
    ) return varchar2;    



/**
 * Gibt TRUE zurück, wenn in einer Kundenadresse der Vorname bzw. Nachname
 * als gültig betrachtet wird,
 * FALSE wenn nicht,
 * NULL wenn leer
 *
 * @param piv_name  [IN ] Getrimmter Name
 *
 * @see         https://netwelt.netcologne.intern/display/OP/03+-+Adressdaten
 *
 * @author  WISAND  Andreas Wismann  <wismann@when-others.com>
 * @creation    2024-03
 * @date        2024-07-17: Neue Funktion fb_is_valid_zusatz
 * @date        2024-10-01: Verschärfte Validierung der Rufnummer
 * @date        2024-10-22: Keine Doppel-Null am Anfang
 */
    function fb_is_valid_name (
        piv_name in varchar2
    ) return boolean
        deterministic;



/**
 * Gibt TRUE zurück, wenn in einer Adresse der Firmenname
 * als gültig betrachtet wird,
 * FALSE wenn nicht,
 * NULL wenn leer
 *
 * @param piv_name  [IN ] Getrimmter Name
 *
 * @see         https://netwelt.netcologne.intern/display/OP/03+-+Adressdaten
 *
 * @author  WISAND  Andreas Wismann  <wismann@when-others.com>
 * @date    2024-03-27
 */
    function fb_is_valid_firma (
        piv_name in varchar2
    ) return boolean
        deterministic;



/**
 * Gibt TRUE zurück, wenn in einer Bankverbindung die Angaben des Kontoinhabers
 * als gültig betrachtet wird,
 * FALSE wenn nicht,
 * NULL wenn leer
 *
 * @param piv_name  [IN ] Getrimmter Kontoinhaber
 *
 * @see         https://netwelt.netcologne.intern/display/OP/03+-+Adressdaten
 *
 * @author  WISAND  Andreas Wismann  <wismann@when-others.com>
 * @date    2024-03-27
 */
    function fb_is_valid_kontoinhaber (
        piv_name in varchar2
    ) return boolean
        deterministic;



/**
 * Gibt TRUE zurück, wenn es sich bei der Eingabe formell um eine
 * gültige Postleitzahl handelt,
 * FALSE wenn nicht,
 * NULL wenn die Eingabe NULL ist.
 *
 * @param piv_plz      [IN ] Getrimmte Benutzereingabe in einem Feld namens "Postleitzahl", "PLZ", "ZIP", "ZipCode" etc.
 * @param piv_ausland  [IN ] Optionale Angabe, ob es sich um eine ausländische PLZ handelt.
 *                           Falls nicht gesetzt, werden die Regeln für deutsche Postleitzahlen angewendet.
 *                           Für Ausland entweder "1", ,"J", "Y", das dreistellige Länderkürzel oder
 *                           notfalls auch den gesamten Ländernamen übergeben; 
 *                           dies ermöglicht zukünftige, länderspezifische Erweiterungen.
 *                           Ausnahme: Wenn hier jedoch einer der Werte "0", "N", "D", "DE", "DEU", "GER" oder "Deutschland" übergeben wird, 
 *                           dann verhält sich die Funktion genauso wie bei einem nicht gesetzten Parameter, 
 *                           da Deutschland (Inland) die Default-Überprüfung ist.
 *
 * @date 2024-03-27
 *
 * @usage Es wird nicht geprüft, ob die Postleitzahl existiert.
 *
 * @unittest
 * SELECT * FROM TABLE(UT.RUN('UT_ADRESSE', a_tags => 'fb_is_valid_plz'));
 */
    function fb_is_valid_plz (
        piv_plz     in varchar2,
        piv_ausland in varchar2 default null
    ) return boolean
        deterministic;



/**
 * Gibt TRUE zurück, wenn in einer Adresse der Städtename
 * als gültig betrachtet wird,
 * FALSE wenn nicht,
 * NULL wenn leer
 *
 * @param piv_name  [IN ] Getrimmter Name
 *
 * @see         https://netwelt.netcologne.intern/display/OP/03+-+Adressdaten
 *
 * @author  WISAND  Andreas Wismann  <wismann@when-others.com>
 * @date    2024-03-27
 */
    function fb_is_valid_ort (
        piv_name in varchar2
    ) return boolean
        deterministic;  



/**
 * Gibt TRUE zurück, wenn in einer Adresse der Straßenname
 * als gültig betrachtet wird,
 * FALSE wenn nicht,
 * NULL wenn leer
 *
 * @param piv_name  [IN ] Getrimmter Name
 *
 * @see         https://netwelt.netcologne.intern/display/OP/03+-+Adressdaten
 *
 * @author  WISAND  Andreas Wismann  <wismann@when-others.com>
 * @date    2024-03-27
 */
    function fb_is_valid_strasse (
        piv_name in varchar2
    ) return boolean
        deterministic;    



/**
 * Gibt TRUE zurück, wenn die Hausnummer gemäß NetCologne-Validierungsregeln gültig ist,
 * wenn sie nicht gültig ist dann FALSE,
 * wenn sie leer ist dann NULL
 *
 * @param piv_hausnummer  [IN ]  Hausnummer (ohne Leerzeichen, nur Zahlen, Buchstaben,
 *                               sowie ein Bindestrich zwischen zwei Hausnummer-Nennungen sind erlaubt,
 *                               jede der beiden Hausnummern darf maximal 4-stellig sein,
 *                               Länge der gesamten Angabe maximal 15 Zeichen.
 *
 * @see         https://netwelt.netcologne.intern/display/OP/03+-+Adressdaten
 *
 * @attention   Die NetWelt-Spezifikation entspricht nicht der DIN 5008
 *              (Leerzeichen zwischen Zahlen und Bindestrich sind dort erforderlich, 
 *              Schrägstrich anstatt Bindestrich ist erlaubt)
 *
 * @author  WISAND  Andreas Wismann  <wismann@when-others.com>
 */
    function fb_is_valid_hausnummer (
        piv_hausnummer in varchar2
    ) return boolean
        deterministic;



/**
 * Gibt TRUE zurück, wenn in einer Adresse der postalische Zusatzals gültig betrachtet wird,
 * FALSE wenn nicht,
 * NULL wenn leer
 *
 * @param piv_zusatz  [IN ] Getrimmter postalischer Zusatz
 *
 * @see         https://netwelt.netcologne.intern/display/OP/03+-+Adressdaten
 *
 * @author  WISAND  Andreas Wismann  <wismann@when-others.com>
 * @date    2024-03-27
 */
    function fb_is_valid_zusatz (
        piv_zusatz in varchar2
    ) return boolean
        deterministic;



/** 
 * Gibt TRUE zurück, wenn es sich bei dem String um eine formal gültige 
 * E-Mail-Adresse handelt, ansonsten FALSE (wenn nicht) oder NULL (wenn leer)
 * 
 * @param piv_adresse          [IN ] zu prüfende E-Mail-Adresse (muss bereits getrimmt sein) 
 * @param pin_max_email_length [IN ] Maximal erlaubte Länge der gesamten E-Mail-Adresse, per default wird nicht geprüft 
 * @param pin_max_tld_length   [IN ] Maximal erlaubte Länge der Top Level Domain.  
 *                                   Per default (NULL) wird diese nicht geprüft, 
 *                                   weil sonst Adressen wie info@stadtmuseum.koeln durchfallen 
 */
    function fb_is_valid_email (
        piv_adresse          in varchar2,
        pin_max_email_length in natural default null,
        pin_max_tld_length   in natural default null
    ) return boolean
        deterministic;



/**
 * Gibt TRUE zurueck, wenn die ersten 256 Zeichen von piv_string eine gueltige URL sein koennten,
 * FALSE wenn nicht oder NULL wenn piv_string leer ist.
 * Es wird nur auf das Protokoll und erlaubte/unerlaubte Zeichen geprueft,
 * jedoch nicht ob die URL einen semantischen Sinn ergibt oder gar existiert.
 *
 * @param piv_string      [IN ] Zu pruefende URL, z.B. eine Benutzereingabe
 * @param piv_protocol    [IN ] Kommaseparierte Liste mit Protokollen, mit denen
 *                              die URL beginnen muss (z.B. 'https' oder 'http,https'),
 *                              wenn NULL darf die Protokollangabe fehlen
 *                              ('netcologne.de' waere dann gueltig, das ist auch der Default)
 * @param piv_like        [IN ] (optional) Kommaseparierte Liste mit Teilstrings,
 *                              falls gefuellt ,muss die zu pruefende URL mindestens einen davon enhalten
 *                              (Oracle-typische LIKE-Platzhalter % verwenden, kommaseparierte Liste,
 *                              weswegen die Teilstrings selbst keine Kommas enthalten duerfen;
 *                              die Vergleiche sind nicht case-sensitiv!
 * @param piv_domains     [IN ] (optional) Kommaseparierte Liste mit Domains, auf eine von denen die piv_string
 *                              zeigen muss, z.B. diese Liste: "netaachen.de, www.netcologne.de, wwwdev.netcologne.de";
 *                              die Domains koennen Subdomains enthalten;
 *                              jedoch nicht http:// oder https:// etc. (dies ist Aufgabe von piv_protocol).
 *                              Oracle-typische LIKE-Platzhalter % verwenden
 *
 * @date 2023-09-27, @ticket FTTH-2837: Parameter piv_like kann nun kommasepariert uebergeben werden
 * @date 2023-04-04, @ticket FTTH-1997: Neuer Parameter piv_domain wegen dieses Bugs:
 *                   @url https://forums.oracle.com/ords/apexds/post/apex-string-util-get-domain-inconsistent-handling-of-subdom-9717
 * 
 * @author Andreas Wismann <wismann@when-others.com>
 * @date   2023-10-19
 *
 * @usage  Validierung von APEX-Benutzereingaben, wenn es um URLs geht. Es ist
 *         ratsam, immer das Protokoll mit anzugeben, wenn vom Benutzer
 *         erwartet wird, dass er dies ebenfalls tun muss
 *         (z.B. Eingabe beginnt zwingend mit 'https://')
 *
 * @usage  Gemaess der Spezifikation muessen Sonderzeichen in der URL kodiert werden,
 *         deshalb ist beispielsweise ein Leerzeichen nur dann gueltig, wenn es als '%20' oder '+' kodiert wird
 *
 * @utplsql
 * SELECT * FROM roma_main.ut.run('UT_IS_VALID_URL'); -- nur in der Entwicklungsumgebung
 *
 *
 * @example
 * BEGIN
 *  DBMS_OUTPUT.PUT_LINE(
 *    CASE WHEN FB_IS_VALID_URL(
 *      piv_string   => 'https://www.net.de/privatkunden/'
 *    , piv_protocol => 'https'
 *     , piv_like     => '%/privatkunden%,%/geschaeftskunden%'
 *     , piv_domains  => 'netcologne.de,netaachen.de'
 *     ) THEN
 *       'gueltig' ELSE 'ungueltig'
 *     END
 *   ); -- ungueltig, weil domain "net.de" nicht passt
 * END;
 *
 * @workaround erforderlich wegen 
 * @url https://forums.oracle.com/ords/apexds/post/apex-string-util-get-domain-inconsistent-handling-of-subdom-9717
 *
 */
    function fb_is_valid_url (
        piv_string   in varchar2,
        piv_protocol in varchar2 default null,
        piv_like     in varchar2 default null,
        piv_domains  in varchar2 default null
    ) return boolean
        deterministic;  



/**
 * Gibt TRUE zurück, wenn die eingebene IBAN formal gültig ist
 *
 * @param piv_iban  Zu prüfende IBAN, mit oder ohne Leerzeichen formatiert
 *
 * @example
 * DECLARE
 * v_iban     VARCHAR2(34);
 * v_is_valid BOOLEAN;
 * BEGIN
 *   v_iban := 'DE11370501980002462950';
 *   v_is_valid := FB_IS_VALID_IBAN(v_iban);
 *   DBMS_OUTPUT.PUT_LINE('IBAN ' || v_iban || ' ist ' || CASE v_is_valid WHEN TRUE THEN 'gültig' WHEN FALSE THEN 'ungültig' ELSE 'NULL' END); 
 * END;
 *
 * @see https://netwelt.netcologne.intern/display/OP/04+-+Bankdaten
 * @see https://www.iban.com/structure 
 * @see https://de.wikipedia.org/wiki/Internationale_Bankkontonummer
 * @see https://www.hettwer-beratung.de/sepa-spezialwissen/sepa-kontoverbindungsdaten/iban-pr%C3%BCfziffer-berechnung/
 * @see https://ibanvalidieren.de/verifikation.html
 *
 * @unittest
 * SELECT * FROM TABLE(ut.run('UT_IBAN', a_tags => 'fb_is_valid_iban'));
 *
 * @date 2024-03-05
 * @author  WISAND  Andreas Wismann  <wismann@when-others.com>
 */
    function fb_is_valid_iban (
        piv_iban varchar2
    ) return boolean
        deterministic;



/**
 * Gibt TRUE zurück, wenn laut Spezifikation (siehe unten) eine Vorwahl plus konkatenierter Rufnummer
 * als syntaktisch gültig betrachtet werden kann.
 *
 * @param piv_rufnummer [IN ] Getrimmte Rufnummer, darf innen Leerzeichen enthalten,
 *                            bestehend aus Vorwahl und Anschlussnummer - keine führende Ländervorwahl!
 *
 * @doc https://netwelt.netcologne.intern/pages/viewpage.action?pageId=149937565
 * @author: WISAND  Andreas Wismann  <wismann@when-others.com>
 *
 * @usage: Im Feld "Vorwahl & Rufnummer" müssen (ohne Berücksichtigung einer führenden "0"!) 
 *         mindestens 7, maximal 11 Zeichen (mit oder ohne Leerzeichen) stehen. 
 *         Andere Zeichen sind nicht erlaubt.
 *
 * @unittest: 
 * SELECT * FROM roma_main.ut.run('UT_RUFNUMMER', a_tags => 'FB_IS_VALID_RUFNUMMER');
 */
    function fb_is_valid_rufnummer (
        piv_rufnummer in varchar2
    ) return boolean
        deterministic;    



/**
 * Gibt 1 zurück, wenn laut Spezifikation (siehe unten) eine Vorwahl & Rufnummer
 * als syntaktisch gültig betrachtet werden kann, wenn nicht dann 0 und bei 
 * leerer Rufnummer NULL.
 *
 * @usage: Siehe Dokumentation zu FB_IS_VALID_RUFNUMMER: Gleiche fachliche Logik,
 *         lediglich 1|0|NULL anstatt TRUE|FALSE|NULL als Returnwert
 *
 * @example 
 * SELECT PCK_ADRESSE.FN_IS_VALID_RUFNUMMER('177363232454') FROM DUAL;
 * -- (Beispiel für eine Telefonnummer, die hier korrekt validiert, jedoch in der
 * -- online-Bestellstrecke zurückgewiesen wird)
 */
    function fn_is_valid_rufnummer (
        piv_rufnummer in varchar2
    ) return natural
        deterministic;

end pck_adresse;
/


-- sqlcl_snapshot {"hash":"07e02175d771b97b7d0016fa59704a38943c0cc9","type":"PACKAGE_SPEC","name":"PCK_ADRESSE","schemaName":"ROMA_MAIN","sxml":""}