create or replace package body pck_adresse as 
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
 *
 * @version 2024-10-22
 */

    function fb_is_valid_name (
        piv_name in varchar2
    ) return boolean
        deterministic
    is
    begin
        if piv_name is null then
            return null;
        end if;
        if trim(piv_name) <> piv_name then
            return false;
        end if;

      -- Nachnamen zwischen 2 und 30 Zeichen werden akzeptiert.
      -- Nur Buchstaben, Leerzeichen und Bindestriche sind erlaubt.  
      -- (Erweiterung: Dabei darf der Bindestrich nicht ganz links oder ganz rechts stehen)
        return regexp_like(
            trim(both '-' from trim(piv_name)),
            '^[a-zA-Z \-]{2,30}$'
        );
    end;


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
        deterministic
    is
    begin
        if piv_name is null then
            return null;
        end if;
        if trim(piv_name) <> piv_name then
            return false;
        end if;

      -- Firmennamen zwischen 2 und 40 Zeichen werden akzeptiert.
      -- Ansonsten sind derzeit keine Ausschlüsse von Zeichen oder Zustammenstellungen bekannt.
        return length(piv_name) between 2 and 40; -- 2024-04-02 Sprint Review - 80 kommt von GK (@AP Brian Heck)
    end;
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
        deterministic
    is
    begin
        if piv_name is null then
            return null;
        end if;
        if trim(piv_name) <> piv_name then
            return false;
        end if;

      -- Kontoinhaber zwischen 2 und 60 Zeichen werden akzeptiert.
      -- Ansonsten sind derzeit keine Ausschlüsse von Zeichen oder Zustammenstellungen bekannt.
        return length(piv_name) between 2 and 60;
    end;
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
        deterministic
    is

        c_ausland constant varchar2(30) :=
            case
                when piv_ausland is null
                     or upper(piv_ausland) in ( '0', 'N', 'D', 'DE', 'DEU',
                                                'GER' )
                or upper(piv_ausland) like 'DEUTSCH%' -- so erkennen wir auch "Deutsche Inseln" und "Deutschl."
                 then
                    null
                else upper(substr(piv_ausland, 1, 30))
            end;
    begin
      -- leer?
        if piv_plz is null then
            return null;
        end if;

      -- Unerwünschte führende oder abschließende  Leerzeichen?
        if trim(piv_plz) <> piv_plz then
            return false;
        end if;
        if c_ausland is null then -- Deutschland:
      -- alle Anforderungen erfüllt?
            if regexp_like(piv_plz, '^[0-9]{5}$') then
                return true;
            end if;

      -- /Inland

        else -- neu 2024-03-21: Ausland
            declare
          -- RegEx würde auch Umlaute und Sonderzeichen aktzeptieren, aber internationale PLZ haben so etwas nicht
                c_liste_erlaubte_zeichen constant varchar2(100) := '1234567890 -ABCDEFGHIJKLMNOPQRSTUVWXYZ';
                c_maske_erlaubte_zeichen constant varchar2(100) := '**************************************';
            begin
          -- @ticket FTTH-2814:
          -- Ausländische PLZ werden bei Länderauswahl =/= "Deutschland" zugelassen, 
          -- Validierung
          --    drei- bis 8-stellig 
          --    beliebige Kombination aus Ziffern (0-9) und/oder Buchstaben (A-Za-z) 
          --    0-2 Leerzeichen oder exakt ein Bindestrich an beliebiger Stelle
                if
                    length(piv_plz) between 3 and 8
                    and replace(
                        translate(
                            upper(piv_plz),
                            c_liste_erlaubte_zeichen,
                            c_maske_erlaubte_zeichen
                        ),
                        '*'
                    ) is null
                    and regexp_count(piv_plz, ' ') <= 2
                    and regexp_count(piv_plz, '-') <= 1
                then
                    return true;
                end if;

            end;
        end if; -- /Ausland

      -- Tests nicht bestanden:
        return false;
    end fb_is_valid_plz; 
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
        deterministic
    is
    begin
        if piv_name is null then
            return null;
        end if;
        if trim(piv_name) <> piv_name then
            return false;
        end if;

      -- Ortsnamen zwischen 2 und 30 Zeichen werden akzeptiert.
      -- Ansonsten sind derzeit keine Ausschlüsse von Zeichen oder Zustammenstellungen bekannt.
        return length(piv_name) between 2 and 30;
    end; 



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
        deterministic
    is
    begin
        if piv_name is null then
            return null;
        end if;
        if trim(piv_name) <> piv_name then
            return false;
        end if;

      -- Straßennamen zwischen 2 und 200 Zeichen werden akzeptiert.
      -- Ansonsten sind derzeit keine Ausschlüsse von Zeichen oder Zustammenstellungen bekannt.
        return length(piv_name) between 2 and 200;
    end;    


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
        deterministic
    is
    begin
        if piv_hausnummer is null then
            return null;
        end if;
        if length(piv_hausnummer) > 15 -- warum auch immer auf der NetWelt-Seite "15" angenommen wird
        or replace(piv_hausnummer, ' ') <> piv_hausnummer then
            return false;
        end if;

      -- Bindestrich enthalten?
        declare
        -- keine Umlaute oder Sonderzeichen im Hausnummern-Zusatz erlaubt:
            c_buchstaben               constant varchar2(100) := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
            n_pos_bindestrich          naturaln := instr(piv_hausnummer, '-');
            nummer_links               varchar2(15);
            links_enthaelt_nur_ziffern boolean;

            function is_valid (
                str in varchar2,
                pos in varchar2 default null
            ) return boolean is
            begin
                if str is null then
                    return false;
                end if;
                if pos = 'R' then -- Besonderheit: Der rechte Teil kann auch lediglich einen Buchstaben enthalten
              -- Wenn links kein Buchstabe enthalten ist, muss rechts mindestens eine Zahl stehen ('1-2b' = TRUE, '1-b' = FALSE)
                    if
                        links_enthaelt_nur_ziffern
                        and regexp_like(str, '^['
                                             || c_buchstaben
                                             || ']$')
                    then
                        return false;
                    end if;

                    return regexp_like(str, '^[0-9]{0,4}['
                                            || c_buchstaben
                                            || ']{0,1}$');
                else -- Linker Teil
                    nummer_links := regexp_replace(str, '['
                                                        || c_buchstaben
                                                        || ']');
                    if str not like nummer_links || '%' then
                        return false;
                    end if;
                    links_enthaelt_nur_ziffern := regexp_like(str, '^[0-9]+$');
                    return regexp_like(str, '^[0-9]{1,4}['
                                            || c_buchstaben
                                            || ']*$');
                end if;

            end;

        begin
            if n_pos_bindestrich > 0 then
                return coalesce(
                    is_valid(substr(piv_hausnummer, 1, n_pos_bindestrich - 1))
                    and is_valid(
                        substr(piv_hausnummer, n_pos_bindestrich + 1),
                        'R'
                    ),
                    false);

            else
                return is_valid(piv_hausnummer);
            end if;
        end;

    end fb_is_valid_hausnummer;

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
        deterministic
    is
    begin
        if piv_zusatz is null then
            return null;
        end if;
        if trim(piv_zusatz) <> piv_zusatz then
            return false;
        end if;

      -- Postalischer Zusatz zwischen 1 und 30 Zeichen wird akzeptiert.
      -- Ansonsten sind derzeit keine Ausschlüsse von Zeichen oder Zustammenstellungen bekannt.
        return length(piv_zusatz) between 1 and 30;
    end;
/** 
 * Gibt TRUE zurück, wenn es sich bei dem String um eine formal gültige 
 * E-Mail-Adresse handelt, ansonsten FALSE (wenn nicht) oder NULL 
 * 
 * @param piv_adresse          [IN ] zu prüfende E-Mail-Adresse (muss bereits getrimmt sein) 
 * @param pin_max_email_length [IN ] Maximal erlaubte Länge der gesamten E-Mail-Adresse, per default wird nicht geprüft 
 * @param pin_max_tld_length   [IN ] Maximal erlaubte Länge der Top Level Domain.  
 *                                   Per default (NULL) wird diese nicht geprüft, 
 *                                   weil sonst Adressen wie info@stadtmuseum.koeln durchfallen 
 * @krakar @ticket FTTH-5228: Prüfen, wo die Funktion verwendet wird, ggf. löschen falls nicht mehr verwendet
 */
    function fb_is_valid_email (
        piv_adresse          in varchar2,
        pin_max_email_length in natural default null,
        pin_max_tld_length   in natural default null
    ) return boolean
        deterministic
    is
        muster varchar2(512); -- maximale Länge, sonst ORA-12733: regular expression too long 
/*     
    REGEX_ALTERNATIV CONSTANT VARCHAR2(4000) := 
    q'[(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])]'; 

      -- '^[A-Za-z]+[A-Za-z0-9.]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$' -- ChatGPT V0.1 
      -- '^[[:alnum:]_.%+-]+@[[:alnum:].-]+\.[[:alpha:]_-]{2,4}$' -- erkennt nicht, dass der Domainname nicht mit Bindestrich beginnen oder enden darf       
      -- '^[[:alnum:]_.%+-]+@[[:alnum:]]([[:alnum:]-]?[[:alnum:]])*\.([[:alpha:]_-]{2,4})+$' -- ChatGPT V0.3 
*/
    begin 
    -- Adresse zu lang? 
        if
            pin_max_email_length > 0
            and length(piv_adresse) > pin_max_email_length
        then
            return false;
        end if; 

    -- Adresse formell gültig? 
        muster := '^[[:alnum:]_.%+-]+@[[:alnum:]]([[:alnum:]-]*[[:alnum:]])?(\.[[:alpha:]_-]{2,'
                  ||
            case
                when pin_max_tld_length > 0 then
                    to_char(pin_max_tld_length)
            end
                  || '})+$';

        return
            regexp_like(piv_adresse, muster)

       -- 2025-03-20: noch schärfer validieren, nachdem horst.ter.@gmx.de damit durchgekommen ist.
       -- @////// @weiter: Eventuell reicht die erste Zeile bereits und kann die obige ersetzen?
            and regexp_like(piv_adresse, '^[A-Za-z0-9][A-Za-z0-9._%+-]*[A-Za-z0-9]@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
            and not regexp_like(piv_adresse, '\.\.')

       -- möglicherweise kann das Abfangen der Bindestriche etwas generischer erfolgen als mit 3 extra-Mustern:
            and not regexp_like(piv_adresse, '@-')
            and not regexp_like(piv_adresse, '-\.')
            and not regexp_like(piv_adresse, '\.-');

    end fb_is_valid_email;

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
        deterministic
    is

        v_url              constant varchar2(256) := lower(substr(
            rtrim(piv_string),
            1,
            256
        ));
        -- Undokumentiert:
        -- Wenn das Protokoll ueberfluessigerweise mit abschliessendem '://' uebergeben wird, 
        -- soll das nicht stoeren:
        civ_protocol       constant varchar2(30) := substr(
            case
                when piv_protocol like '%://' then
                    replace(piv_protocol, '://')
                else piv_protocol
            end,
            1,
            30);
                                            -- ist leer, wenn in piv_string kein Protokoll mitgeschickt wurde
        regex_for_url      varchar2(100);
        allowed_characters constant varchar2(100) := '[][a-z0-9@.:;+$()/?!*''=,&#%~_-]+$'; -- alles nach dem Protokoll (://) bis zum Ende des Strings
        v_valid            boolean;
    begin
        -- Vorpruefungen / triviale Faelle:
        if v_url is null then
            return null; -- kann nicht entschieden werden
        end if;
        if trim(v_url) is null then -- Es wurden ausschliesslich Leerzeichen uebergeben (aber kein Leerstring)
            return false;
        end if;
        if
            instr(piv_string, '://') = 0
            and ( length(v_url) <= 8 -- so dass 'localhost' aktzeptiert wird
            or (
                v_url <> 'localhost'
                and instr(v_url, '.') + instr(v_url, ':') = 0
            ) )
        then -- faengt Pseudo-Eingaben ab wie '-', 'n.a.', 'keine'
            return false;
        end if;

        if instr(v_url, '..') > 0 then
            return false; -- zwei Punkte hintereinander sind unzulaessig - faengt Eingaben wie 'www...' ab
        end if;
        -- 2025-04-22: Das scharfe s 'ß' wird offenbar aufgrund der Sonderzeichen-Behandlung in der Datenbank
        -- nicht zuverlässig als falsch erkannt. Unittest schlug heute fehl.
        -- @todo: Alle nicht-encodeten Unicode-Zeichen explizit per Regel abfangen, nicht nur "Esszett"
        if instr(v_url,
                 chr(223)) > 0 then
            return false;
        end if;

        if civ_protocol is null then
          -- pruefen ob es sich um einen Tippfehler wie 'https//:' handelt:
            if
                v_url like 'http%'
                and v_url not like 'http%://%'
            then
                return false;
            end if;
          -- weiter mit den Pruefungsvorbereitungen:
            regex_for_url := '^' || allowed_characters; -- pruefen ohne Protokollvorgabe
        elsif instr(civ_protocol, ',') = 0 then -- ein ganz bestimmtes Protokoll wird verlangt, z.B. 'https'
            regex_for_url := '^('
                             || civ_protocol
                             || '://){1}'
                             || allowed_characters;
        else -- mehrere Protokolle sind erlaubt
            regex_for_url := '^(('
                             || replace(
                replace(
                    trim(civ_protocol),
                    ',',
                    '|'
                ),
                ' '
            )
                             || ')://){1}'
                             || allowed_characters;
        end if;
        -- DBMS_OUTPUT.PUT_LINE('TEST: ' || piv_String || ', REGEX:' || REGEX_FOR_URL); -- praktisch beim Testen mit utPLSQL
        -- REGEX-Pruefung nach allen Vorpruefungen:
        v_valid := regexp_like(v_url, regex_for_url, 'i' -- case insensitive
        );
        if not v_valid then
            return false;
        end if;


        -- @ticket FTTH-2837: mehrere Vergleiche sind nun moeglich
        if piv_like is not null then
            v_valid := false; -- nachfolgende Tests versuchen, dies auf TRUE zu aendern
            for muster in (
                select
                    trim(lower(column_value)) as teilstring
                from
                    table ( apex_string.split(piv_like, ',') )
            ) loop
            -- Beim ersten Treffer: Ausgabe erfolgreich.
                if lower(piv_string) like muster.teilstring then
                    v_valid := true;
                    exit;
                end if;
            end loop;

        end if;

        if not v_valid then
            return false;
        end if;
        -- 2023-04-04: Finaler Test auf den neuen Parameter piv_domains
        if piv_domains is not null then
            for allowed in (
                select
                    trim(lower(column_value)) as domain
                from
                    table ( apex_string.split(piv_domains, ',') )
            ) loop
                declare
                    domain_in_piv_string           constant varchar2(255) := lower(apex_string_util.get_domain(piv_string));
              -- @ticket FTTH-1997, @ticket FTTH-2998:
              -- Bug bzw. undokumentiertes Feature: 
              -- Die Funktion APEX_STRING_UTIL liefert fuer "www.xyz.de" und "xyz.de" jeweils "xyz.de" als Ergebnis,
              -- und zwar offenbar nur dann, wenn die Subdomain ausdruecklick "www" heisst.
              -- @url https://forums.oracle.com/ords/apexds/post/apex-string-util-get-domain-inconsistent-handling-of-subdom-9717
              -- "www" ist der einzige bisher bekannte Fehlerfall:
                    allowed_domain_starts_with_www constant boolean := allowed.domain like 'www.%';
                begin
            -- Wenn die Domain identisch endet: bestanden.
                    if
                        not allowed_domain_starts_with_www
                        and domain_in_piv_string like '%' || allowed.domain
            -- zB. 'https://another.domain.netcologne.de' LIKE '%netcologne.de'
              ----------------------------------------------------------------------
                    or (
                        allowed_domain_starts_with_www -- zB. 'www.netcologne.de'
                        and ( piv_string like 'www.%'
                              or piv_string like 'http://www.%'
                        or piv_string like 'https://www.%' )
                        and 'www.' || domain_in_piv_string = allowed.domain
                    )
              ----------------------------------------------------------------------
                     then
                        return true;
                    end if;

                end;
            end loop;
          -- Letzter Vergleich, keine Uebereinstimmung: diese Pruefung schlaegt fehl
            return false;
        end if; -- Test auf piv_domain

        return v_valid;
    end fb_is_valid_url;

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
        deterministic
    is

        v_iban            varchar2(256);
        v_laendercode     varchar2(2);
        v_pruefziffer     varchar2(2);
        v_kontonummer     varchar2(10);
        v_bban            varchar2(30);
        v_iban_nummerisch varchar2(100);
        v_pruefstring     varchar2(100);
        deutsche_iban     boolean;
    begin
      -- Bei Eingabe von NULL erfolgt keine Prüfung
        if piv_iban is null then
            return null;
        end if;

      -- Es dürfen keine Leerzeichen am Beginn oder Ende der Eingabe stehen:
        if trim(both ' ' from piv_iban) <> piv_iban then
            return false;
        end if;    

      -- Entfernen von Leerzeichen und Konvertieren zu Großbuchstaben
        v_iban := substr(
            replace(
                upper(piv_iban),
                ' '
            ),
            1,
            256
        );
      -- Überprüfen, ob die IBAN die richtige Länge hat
        if v_iban is null
           or length(v_iban) not between 15 -- Norwegen
            and 31 -- laut Spezifikation eigentlich 34 (je nach Staat), Beispiele:
                                       -- Griechenland und Italien: 27 Stellen, 
                                       -- Malta: 31
            then
            return false;
        end if;

      -- Sonderfall Deutschland: Immer 22 Stellen
        if
            deutsche_iban
            and length(v_iban) <> 22
        then
            return false;
        end if;

      -- Extrahieren von Ländercode, Prüfziffern und Basiskontonummer
        v_laendercode := substr(v_iban, 1, 2);
        if v_laendercode = 'DE' then
            deutsche_iban := true;
        end if;
        v_pruefziffer := substr(v_iban, 3, 2);
        v_bban := substr(v_iban, 5);

      -- Überprüfen, ob die ersten beiden Zeichen Buchstaben sind
        if not regexp_like(v_laendercode, '^[A-Z]+$') then
            return false;
        end if;  

      -- Überprüfen, ob die beiden Prüfziffern Zahlen sind
        if not regexp_like(v_pruefziffer, '^[[:digit:]]+$') then
            return false;
        end if;
        if deutsche_iban then
            v_iban_nummerisch := v_bban; -- Sonderfall Deutschland: Hier darf es keine Buchstaben in der Kontonummer geben:
        else
        -- in anderen Ländern, beispielsweise der Niederlande oder Schweiz, können Kontonummern durchaus Buchstaben enthalten,
        -- etwa bei dieser gültigen IBAN: CH020023023012625140U
            for i in 1..length(v_bban) loop
                if regexp_like(
                    substr(v_bban, i, 1),
                    '^[A-Z]$'
                ) then
                    v_iban_nummerisch := v_iban_nummerisch
                                         || to_char(ascii(substr(v_bban, i, 1)) - 55);

                else
                    v_iban_nummerisch := v_iban_nummerisch
                                         || substr(v_bban, i, 1);
                end if;
            end loop;
        end if;
      -- Überprüfen, ob die restlichen Zeichen Ziffern sind
        if not regexp_like(v_iban_nummerisch, '^[[:digit:]]+$') then
            return false;
        end if;
      -- Prüfen, ob die Modulo-Berechnung der Prüfsumme mit der Prüfziffer übereinstimmt:
        v_pruefstring := v_iban_nummerisch
                      -- Hinten anhängen: nummerische Länderkennung, ergänzt um '00':
                         || to_char(ascii(substr(v_iban, 1, 1)) - 55) -- A=10, B=11, ...,
                         || to_char(ascii(substr(v_iban, 2, 1)) - 55) -- ..., Y=34, Z=35
                         || '00';
      -- (diesen langen String mit der zweistelligen Prüfziffer abgleichen)         
        if ( 98 - mod(v_pruefstring, 97) ) <> v_pruefziffer then
            return false;
        end if;
      -- Wenn alle Überprüfungen bestanden, ist die IBAN formal gültig
        return true;
    end fb_is_valid_iban;


/**
 * Gibt TRUE zurück, wenn laut Spezifikation (siehe unten) eine Vorwahl plus konkatenierter Rufnummer
 * als syntaktisch gültig betrachtet werden kann.
 *
 * @param piv_rufnummer [IN ] Getrimmte Rufnummer, darf innen einzelne Leerzeichen enthalten,
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
        deterministic
    is
    begin
      -- Achtung: Der Reguläre Ausdruck auf der NetWelt-Seite ist ungültig.
      -- Dort muss zunächst nachgebessert werden...
      -- Hier die Variante mit einer anderen Prüfung:

      -- 2024-10-01: Durch das REPLACE weiter unten, welches innenliegende Leerzeichen eliminieren soll,
      -- muss nun zunächst geprüft werden, ob der eingehende String bereits getrimmt ist und ob er mehr
      -- als ein Leerzeichen am Stück enthält:
        if trim(piv_rufnummer) <> piv_rufnummer then
            return false;
        end if;
        if instr(piv_rufnummer,
                 chr(32)
                 || chr(32)) > 0 then
            return false;
        end if; -- ein Leerzeichen am Stück sei erlaubt, aber nicht deren 2
        if substr(piv_rufnummer, 1, 2) = '00' then
            return false;
        end if;           -- 2024-10-22: keine Doppel-Null am Anfang

        return regexp_like(
            ltrim(
                replace(piv_rufnummer, ' '),
                '0'
            ),
            '^[[:digit:]]{7,15}$'
        ); -- neuer Vorschlag nach PROD-Bug
      -- @ticket FTTH-4332: Dies war die alte Valierung gemäß Netwelt, und führte zu einem Fehler,
      -- weil 1 Zeichen zu lang (die jetzt vorgelagerten REPLACE-Befehle gab es nicht):
  ----RETURN REGEXP_LIKE(piv_rufnummer, '^[[:digit:]]([[:space:]]?[[:digit:]]){4,14}$'); -- alternativer RegEx-Vorschlag, noch nicht abgenommen
    end;

-- @progress 2024-05-15
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
        deterministic
    is
    begin
        return
            case fb_is_valid_rufnummer(piv_rufnummer)
                when true then
                    1
                when false then
                    0
                else null
            end;
    end;

-- @progress 2025-03-27

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
        deterministic
    is

        v_adresse      varchar2(4000);
        c_trennzeichen constant varchar2(30) := coalesce(
            substr(piv_trennzeichen, 1, 30),
            ', '
        );
    begin
        v_adresse := -- Straße:
         trim(piv_strasse
                          || ' '
                          || piv_hausnummer
                          || piv_hausnummer_zusatz
                          || case
            when piv_hausnummer_bis is not null then
                '-'
                || piv_hausnummer_bis
                || piv_hausnummer_zusatz_bis
        end)
                     || c_trennzeichen 
              -- Gebäudeteil:
                     ||
            case
                when piv_gebaeudeteil is not null then
                    trim(piv_gebaeudeteil)
                    || c_trennzeichen
            end
              -- Ort:
                     || trim(piv_plz)
                     || ' '
                     || trim(piv_ort)
                     ||
            case
                when piv_ortsteil is not null then
                    ' ('
                    || trim(piv_ortsteil)
                    || ')'
            end
              -- Land:

                     || case
            when piv_land is not null then
                c_trennzeichen || trim(piv_land)
        end;
    -- Wenn überhaupt keine Adresse gefunden wird, bleiben lediglich Trennzeichen übrig
        return trim(both trim(c_trennzeichen) from trim(v_adresse));
    end adresse_komplett;

-- @progress 2025-04-09

    function adresse_komplett (
        pin_haus_lfd_nr in v_adressen.haus_lfd_nr%type
    ) return varchar2 is
        v_adresse_komplett v_adressen.adresse_kompl%type;
    begin
        select
            max(a.adresse_kompl)
        into v_adresse_komplett
        from
            v_adressen a
        where
            a.haus_lfd_nr = pin_haus_lfd_nr;

        return v_adresse_komplett;
    end;

end pck_adresse;
/


-- sqlcl_snapshot {"hash":"378daa30c6463eed68954485580c1b64c68e10ca","type":"PACKAGE_BODY","name":"PCK_ADRESSE","schemaName":"ROMA_MAIN","sxml":""}