-- liquibase formatted sql
-- changeset ROMA_MAIN:1768480984420 stripComments:false logicalFilePath:develop/roma_main/package_bodies/pck_glascontainer_dubletten.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot GLASCONTAINER_MAIN/src/database/roma_main/package_bodies/pck_glascontainer_dubletten.sql:null:f8bd3cdfc8c745ae357b24a6a1377549dc421801:create

create or replace package body roma_main.pck_glascontainer_dubletten as 
  /**
   * Funktionen zur Darstellung von Kunden-Dubletten in der APEX-App 2022 "Glascontainer"
   *
   * @date 2023-04: Neuer Bewertungsoption "Fehlbearbeitung", #@ticket FTTH-1989
   * @author  Andreas Wismann WISAND <wismann@when-others.com>
   */
   
  -- Test auf Umlaute/Euro: ÄÖÜäöüß/?
  -- Im Unterschied zu PCK_GLASCONTAINER_DUBLETTEN.version ist die Version im PACKAGE BODY
  -- typischerweise höher (die informelle APEX-Abfrage auf 2022:10050 ermittelt den höheren der beiden Werte)
    body_version           constant varchar2(30) := '2024-04-30 0900'; -- zuvor: '2023-07-04 / 1.0.12';

    kein_auftrag_vorhanden constant varchar2(100) := '-';
  
  -- @ticket FTTH-5038: Aufgrund der Adressen-Konsolidierung (STR+HNR | PLZ+ORT) auf eine gemeinsame Spalte
  --                    (Adresse) haben alle Reports eine Spalte weniger
  --C_NUM_REPORT_COLS    CONSTANT NATURALN      := 12; 
    c_num_report_cols      constant naturaln := 11; 

  
  /**
   * Getter für die Package-Body-Variable body_version
   */
    function get_body_version return varchar2
        deterministic
    is
    begin
        return body_version;
    end;

  
  /**
   * Formatiert jeden Routinen-Namen mit dem Prefix des Packages, damit in den LOGS
   * die Suche nach dem Package-Namen im Fehlerfall einfacher wird
   *
   * @example
   * SELECT * FROM LOGS WHERE ROUTINE_NAME LIKE 'PCK_GLASCONTAINER%' AND ...
   */
    function qualified_name (
        i_routine_name in varchar2
    ) return varchar2
        deterministic
    is
    begin
        return $$plsql_unit
               || '.'
               || upper(i_routine_name);
    end;

  
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
        deterministic
    is
        c_icon constant boolean := nvl(pin_mit_icon, 0) = 1;
    begin
        return
            case piv_bewertung
                when 'F' then -- #@ticket FTTH-1989
                    case
                        when c_icon then
                            '&nbsp;&#10006;&nbsp;&nbsp;'
                    end
                    || 'Fehlbearbeitung' -- &#10006; &#128281;  &#128296;  &#128374;  &#128701;
                when 'K' then
                    case
                        when c_icon then
                            '&#128172; '
                    end
                    || 'Kommentar'
                when 'G' then
                    case
                        when c_icon then
                            '&#9989; '
                    end
                    || 'gewollte Dublette (kein Clearing)'
                when 'W' then
                    case
                        when c_icon then
                            '&#128161;&nbsp;&nbsp;'
                    end
                    || 'klären (Wiedervorlage)'
                when 'X' then
                    case
                        when c_icon then
                            '&#9940 '
                    end
                    || 'keine Dublette'
                else null
            end;
    end;

  
/**    
 * Liefert die tabellarische Ansicht der Kundendaten zurück, 
 * die auf Seite 2022:40 im Fuzzy-Bewertungsdialog angezeigt wird
 * 
 * 
 * @return Zeichenkette, in der jeder unbekannte/leere Wert mit einer
 *         doppelten geschweiften Klammer {{...}} repräsentiert wird
 *

 -- @deprecated ////////// altes Adressformat
  FUNCTION fv_karteikarte(
    pin_haus_lfd_nr       IN VARCHAR2,
    piv_kundennummer      IN VARCHAR2,
    piv_vorname           IN VARCHAR2,
    piv_nachname          IN VARCHAR2,
    piv_geburtsdatum      IN VARCHAR2,
    piv_anschluss_strasse IN VARCHAR2,
    piv_anschluss_hausnr  IN VARCHAR2,
    piv_anschluss_plz     IN VARCHAR2,
    piv_anschluss_ort     IN VARCHAR2,
    piv_iban              IN VARCHAR2,
    piv_html_id           IN VARCHAR2 DEFAULT NULL,
    piv_html_class        IN VARCHAR2 DEFAULT NULL
  ) RETURN VARCHAR2
  IS
    trenner         CONSTANT VARCHAR2(30)           := '</td></tr><tr><td>';
    nbsp            CONSTANT VARCHAR2(10)           := '&nbsp;';
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
    cv_routine_name CONSTANT logs.routine_name%TYPE := 'fv_karteikarte';
    FUNCTION fcl_params RETURN logs.message%TYPE IS
    BEGIN
      pck_format.p_add('pin_haus_lfd_nr', pin_haus_lfd_nr);
      pck_format.p_add('piv_kundennummer', piv_kundennummer);
      pck_format.p_add('piv_vorname', piv_vorname);
      pck_format.p_add('piv_nachname', piv_nachname);
      pck_format.p_add('piv_geburtsdatum', piv_geburtsdatum);
      pck_format.p_add('piv_anschluss_strasse', piv_anschluss_strasse);
      pck_format.p_add('piv_anschluss_hausnr', piv_anschluss_hausnr);
      pck_format.p_add('piv_anschluss_plz', piv_anschluss_plz);
      pck_format.p_add('piv_anschluss_ort', piv_anschluss_ort);
      pck_format.p_add('piv_iban', piv_iban);
      pck_format.p_add('piv_html_id', piv_html_id);
      pck_format.p_add('piv_html_class', piv_html_class);
      RETURN pck_format.fcl_params(cv_routine_name);
    END fcl_params;
  -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------       
  BEGIN
  
    RETURN '<table'
      || CASE
           WHEN piv_html_id IS NOT NULL THEN
             ' id="'
             || piv_html_id
             || '"'
         END
      || CASE
           WHEN piv_html_class IS NOT NULL THEN
             ' class="'
             || piv_html_class
             || '"'
         END
      || '><tr><td>'
      ||  piv_kundennummer
        || trenner
        || apex_escape.html(piv_vorname)
        || ' '
        || piv_nachname
        || trenner
        || nvl(piv_geburtsdatum, nbsp)
        || trenner
        || piv_anschluss_strasse
        || ' '
        || piv_anschluss_hausnr
        || trenner
        || piv_anschluss_plz
        || ' '
        || piv_anschluss_ort
        || trenner
        || nvl(piv_iban, nbsp)
      || '</td></tr></table>';
  EXCEPTION
    WHEN OTHERS THEN
      pck_logs.p_error(
        pic_message      => fcl_params()
       ,piv_routine_name => qualified_name(cv_routine_name)
       ,piv_scope        => G_SCOPE
      );
      RAISE;
  END fv_karteikarte;
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
    ) return varchar2 is

        trenner         constant varchar2(30) := '</td></tr><tr><td>';
        nbsp            constant varchar2(10) := '&nbsp;';
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'fv_karteikarte';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_haus_lfd_nr', pin_haus_lfd_nr);
            pck_format.p_add('piv_kundennummer', piv_kundennummer);
            pck_format.p_add('piv_vorname', piv_vorname);
            pck_format.p_add('piv_nachname', piv_nachname);
            pck_format.p_add('piv_geburtsdatum', piv_geburtsdatum);
            pck_format.p_add('piv_adresse', piv_adresse);
            pck_format.p_add('piv_iban', piv_iban);
            pck_format.p_add('piv_html_id', piv_html_id);
            pck_format.p_add('piv_html_class', piv_html_class);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
  -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------       
    begin
        return '<table'
               ||
            case
                when piv_html_id is not null then
                    ' id="'
                    || piv_html_id
                    || '"'
            end
               ||
            case
                when piv_html_class is not null then
                    ' class="'
                    || piv_html_class
                    || '"'
            end
               || '><tr><td>'
               || piv_kundennummer
               || trenner
               || apex_escape.html(piv_vorname)
               || ' '
               || piv_nachname
               || trenner
               || nvl(piv_geburtsdatum, nbsp)
               || trenner
        /*
        || piv_anschluss_strasse
        || ' '
        || piv_anschluss_hausnr
        || trenner
        || piv_anschluss_plz
        || ' '
        || piv_anschluss_ort
        */
               || piv_adresse -- kein Trenner anstatt einem
               || trenner
               || nvl(piv_iban, nbsp)
               || '</td></tr></table>';
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end fv_karteikarte;
 
 
    
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
    ) return varchar2 is

        vr              ftth_ws_sync_preorders%rowtype;
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'fv_karteikarte';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_ftth_id', piv_ftth_id);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
  -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------       
    begin
        select
            *
        into vr
        from
            ftth_ws_sync_preorders
        where
            id = piv_ftth_id;

        return fv_karteikarte(
            pin_haus_lfd_nr  => vr.houseserialnumber,
            piv_kundennummer => vr.customernumber,
            piv_vorname      => vr.customer_name_first,
            piv_nachname     => vr.customer_name_last,
            piv_geburtsdatum => vr.customer_birthdate
        /* @ticket FTTH-5038
        piv_anschluss_strasse => vr.install_addr_street,
        piv_anschluss_hausnr  => vr.install_addr_housenumber,
        piv_anschluss_plz     => vr.install_addr_zipcode,
        piv_anschluss_ort     => vr.install_addr_city,
        */
        -- @ticket FTTH-5038: Neue überladene Funktion, die nur die 
            ,
            piv_adresse      => pck_adresse.adresse_komplett(pin_haus_lfd_nr => vr.houseserialnumber),
            piv_iban         => vr.account_iban,
            piv_html_id      => null,
            piv_html_class   => null
        );

    exception
        when no_data_found then
            return null;
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end fv_karteikarte;
  

  
  
/**
 * Liefert eine HTML-Zeile für die Dubletten-Tabelle zurück (altes Adressformat)

  FUNCTION tr(
    pib_header       IN BOOLEAN,
    piv_kundennummer IN VARCHAR2,
    piv_uuid         IN VARCHAR2
  --, piv_auftragsstatus IN VARCHAR2 -- 2023-02-21: Als Status wird nur noch IN_REVIEW berücksichtigt
  ,
    piv_anrede       IN VARCHAR2,
    piv_titel        IN VARCHAR2,
    piv_vorname      IN VARCHAR2,
    piv_nachname     IN VARCHAR2,
    piv_firmenname   IN VARCHAR2,
    piv_geburtsdatum IN VARCHAR2,
    piv_haus_lfd_nr  IN VARCHAR2,
    piv_strasse      IN VARCHAR2,
    piv_hausnummer   IN VARCHAR2,
    piv_plz          IN VARCHAR2,
    piv_ort          IN VARCHAR2,
    piv_iban         IN VARCHAR2,
    piv_vkz          IN VARCHAR2,
    piv_score        IN VARCHAR2,
    piv_app_session  IN VARCHAR2 -- DEFAULT NULL
  ,
    pin_historie     IN VARCHAR2 -- DEFAULT NULL
  ,
    piv_bewertung    IN VARCHAR2 DEFAULT NULL,
    piv_kommentar    IN VARCHAR2 DEFAULT NULL,
    piv_html_class   IN VARCHAR2 DEFAULT NULL
  ) RETURN VARCHAR2 IS
    --inline----------------------------------
    FUNCTION td(
      i_text       IN VARCHAR2,
      i_attributes IN VARCHAR2 DEFAULT NULL,
      i_href       IN VARCHAR2 DEFAULT NULL,
      i_escape     IN BOOLEAN DEFAULT TRUE
    ) RETURN VARCHAR2 IS
      c_td CONSTANT VARCHAR2(2) := CASE
                                     WHEN pib_header THEN
                                       'th'
                                     ELSE
                                       'td'
                                   END;
    BEGIN
      RETURN CASE
               WHEN i_href IS NOT NULL THEN
                 '<a href="'
                 || i_href
                 || '">'
             END
        || '<'
        || c_td
        || CASE
             WHEN i_attributes IS NOT NULL THEN
               ' '
               || i_attributes
           END
        || '>'
        || CASE WHEN i_escape THEN apex_escape.html(i_text) ELSE i_text END
        || '</'
        || c_td
        || '>'
        || CASE
             WHEN i_href IS NOT NULL THEN
               '</a>'
           END;
    END td;
  --/inline----------------------------------
  BEGIN
    RETURN '<tr class="'
      || piv_html_class
      || CASE
           WHEN (NOT pib_header) AND piv_uuid <> KEIN_AUFTRAG_VORHANDEN THEN
             ' has-link'
             || '"'
             || ' data-url="'
             || apex_page.get_url(
               p_application => 2022  -- ggf. parametrisieren
             , p_page        => 20    -- ggf. parametrisieren
             , p_session     => piv_app_session,
               p_items       => 'P20_UUID' -- ggf. parametrisieren
             , p_values      => piv_uuid
             )
         END
      || '">'
      || td(piv_kundennummer, 'headers="kundennummer" style="text-align:center"'
      || CASE WHEN piv_uuid <> KEIN_AUFTRAG_VORHANDEN THEN ' title="UUID: ' || piv_uuid || '"' END)
    --|| td(piv_uuid) -- wird nicht mehr als Spalte angezeigt
    --|| td(piv_auftragsstatus)
      || td(piv_anrede)
      || td(piv_titel)
      || td(piv_vorname)
      || td(piv_nachname)
      --|| td(piv_firmenname) -- nicht genug Platz
      || td(piv_geburtsdatum, 'style="text-align:center"')
      || td(piv_haus_lfd_nr)
      || td(rtrim(piv_strasse
          || ' '
          || piv_hausnummer))
      || td(rtrim(piv_plz
          || ' '
          || piv_ort))
      || td(piv_iban)
      || td(piv_vkz)
      -- Selectliste: ---------------------------
      || td(CASE
              WHEN pib_header THEN
                piv_score
              ELSE
                CASE
                  WHEN piv_score IS NOT NULL THEN 
                    CASE
                      WHEN nvl(pin_historie, 0) = 0 THEN
                        '<select'
                        || ' class="score" id="bw_'
                        || dbms_random.string('X', 32)
                        || '" data-kundennummer="'
                        || piv_kundennummer
                        || '"'
                        || ' data-beschreibung="'
                        || replace(replace(fv_karteikarte(
                              pin_haus_lfd_nr       => piv_haus_lfd_nr,
                              piv_kundennummer      => piv_kundennummer,
                              piv_vorname           => piv_vorname,
                              piv_nachname          => piv_nachname,
                              piv_geburtsdatum      => piv_geburtsdatum,
                              piv_anschluss_strasse => piv_strasse,
                              piv_anschluss_hausnr  => piv_hausnummer,
                              piv_anschluss_plz     => piv_plz,
                              piv_anschluss_ort     => piv_ort,
                              piv_iban              => piv_iban,
                              piv_html_id           => NULL,
                              piv_html_class        => NULL
                            ), '<', '['),
                                   '>', ']')
                        || '"'
                        --|| ' data-score="' || piv_score || '"' -- wird nirgends verwendet
                        || ' data-bewertung="'
                        || piv_bewertung
                        || '"'
                        || ' data-kommentar="'
                        || apex_escape.html(piv_kommentar)
                        || '"'
                        || '>'
                        --
                        || '<option value=""'
                        || CASE
                             WHEN piv_bewertung IS NULL THEN
                               ' selected'
                           END
                        || '>'
                        || TRIM('&mdash; unbewertet &mdash; ' 
                          --|| CASE WHEN piv_score > '0' THEN ' Score: ' || piv_score END
                          || piv_score)
                        || '</option>'
                        --
                        || '<optgroup label ="Bewertung:">'
                        -- Liste der möglichen Bewertungen. Bestehende Bewertungen werden vorausgewählt:
                        ||
                        '<option value="K"'
                        || CASE
                             WHEN piv_bewertung = 'K' THEN
                               ' selected'
                           END
                        || '>&#128172; Kommentar ...</option>'
                        --
                        || '<option value="G"'
                        || CASE
                             WHEN piv_bewertung = 'G' THEN
                               ' selected'
                           END
                        || '>' || bewertungstext('G') || '</option>'
                        --
                        || '<option value="W"'
                        || CASE
                             WHEN piv_bewertung = 'W' THEN
                               ' selected'
                           END
                        || '>' || bewertungstext('W') || '</option>'
                        --
                        || '<option value="F"'
                        || CASE
                             WHEN piv_bewertung = 'F' THEN
                               ' selected'
                           END
                        || '>' || bewertungstext('F') || '</option>'
                        --
                        || '<option value="X"' -- Glühhbirne: &#128161; Kaffeetasse: &#9749; Sanduhr: &#9203;
                        || CASE
                             WHEN piv_bewertung = 'X' THEN
                               ' selected'
                           END
                        || '>' || bewertungstext('X') || '</option>'
                        --
                        || '</optgroup>'
                        || '</select>'
                    END
                END
            END,
            'headers="bewertung" style="text-align:center"', 
            -- die Selectliste nicht escapen:
            i_escape => FALSE)
      -------------------------------------------            
      || '</tr>';
  END tr;
*/  
 
  
/**
 * Liefert eine HTML-Zeile für die Dubletten-Tabelle zurück (neues Adressformat)
 */
    function tr (
        pib_header       in boolean,
        piv_kundennummer in varchar2,
        piv_uuid         in varchar2,
        piv_anrede       in varchar2,
        piv_titel        in varchar2,
        piv_vorname      in varchar2,
        piv_nachname     in varchar2,
        piv_firmenname   in varchar2,
        piv_geburtsdatum in varchar2,
        piv_haus_lfd_nr  in varchar2,
 -- piv_strasse      IN VARCHAR2,
 -- piv_hausnummer   IN VARCHAR2,
 -- piv_plz          IN VARCHAR2,
 -- piv_ort          IN VARCHAR2,
        piv_adresse      in varchar2,
        piv_iban         in varchar2,
        piv_vkz          in varchar2,
        piv_score        in varchar2,
        piv_app_session  in varchar2,
        pin_historie     in varchar2,
        piv_bewertung    in varchar2 default null,
        piv_kommentar    in varchar2 default null,
        piv_html_class   in varchar2 default null
    ) return varchar2 is
    --inline----------------------------------
        function td (
            i_text       in varchar2,
            i_attributes in varchar2 default null,
            i_href       in varchar2 default null,
            i_escape     in boolean default true
        ) return varchar2 is
            c_td constant varchar2(2) :=
                case
                    when pib_header then
                        'th'
                    else 'td'
                end;
        begin
            return
                case
                    when i_href is not null then
                        '<a href="'
                        || i_href
                        || '">'
                end
                || '<'
                || c_td
                ||
                case
                    when i_attributes is not null then
                        ' ' || i_attributes
                end
                || '>'
                ||
                case
                    when i_escape then
                        apex_escape.html(i_text)
                    else i_text
                end
                || '</'
                || c_td
                || '>'
                || case
                when i_href is not null then
                    '</a>'
            end;
        end td;
  --/inline----------------------------------
    begin
        return '<tr class="'
               || piv_html_class
               ||
            case
                when
                    ( not pib_header )
                    and piv_uuid <> kein_auftrag_vorhanden
                then
                    ' has-link'
                    || '"'
                    || ' data-url="'
                    || apex_page.get_url(
                        p_application => 2022  -- ggf. parametrisieren
                        ,
                        p_page        => 20    -- ggf. parametrisieren
                        ,
                        p_session     => piv_app_session,
                        p_items       => 'P20_UUID' -- ggf. parametrisieren
                        ,
                        p_values      => piv_uuid
                    )
            end
               || '">'
               || td(piv_kundennummer, 'headers="kundennummer" style="text-align:center"'
                                       || case
            when piv_uuid <> kein_auftrag_vorhanden then
                ' title="UUID: '
                || piv_uuid
                || '"'
        end)
    --|| td(piv_uuid) -- wird nicht mehr als Spalte angezeigt
    --|| td(piv_auftragsstatus)
               || td(piv_anrede)
               || td(piv_titel)
               || td(piv_vorname)
               || td(piv_nachname)
      --|| td(piv_firmenname) -- nicht genug Platz
               || td(piv_geburtsdatum, 'style="text-align:center"')
               || td(piv_haus_lfd_nr)
      /*
      || td(rtrim(piv_strasse
          || ' '
          || piv_hausnummer))
      || td(rtrim(piv_plz
          || ' '
          || piv_ort))
      */
               || td(piv_adresse) -- eine Spalte anstatt zuvor 2
               || td(piv_iban)
               || td(piv_vkz)
      -- Selectliste: ---------------------------
               || td(
            case
                when pib_header then
                    piv_score
                else
                    case
                        when piv_score is not null then
                            case
                                when nvl(pin_historie, 0) = 0 then
                                    '<select'
                                    || ' class="score" id="bw_'
                                    || dbms_random.string('X', 32)
                                    || '" data-kundennummer="'
                                    || piv_kundennummer
                                    || '"'
                                    || ' data-beschreibung="'
                                    || replace(
                                        replace(
                                            fv_karteikarte(
                                                pin_haus_lfd_nr  => piv_haus_lfd_nr,
                                                piv_kundennummer => piv_kundennummer,
                                                piv_vorname      => piv_vorname,
                                                piv_nachname     => piv_nachname,
                                                piv_geburtsdatum => piv_geburtsdatum,
                              /*
                              piv_anschluss_strasse => piv_strasse,
                              piv_anschluss_hausnr  => piv_hausnummer,
                              piv_anschluss_plz     => piv_plz,
                              piv_anschluss_ort     => piv_ort,
                              */
                                                piv_adresse      => piv_adresse,
                                                piv_iban         => piv_iban,
                                                piv_html_id      => null,
                                                piv_html_class   => null
                                            ),
                                            '<',
                                            '['
                                        ),
                                        '>',
                                        ']'
                                    )
                                    || '"'
                        --|| ' data-score="' || piv_score || '"' -- wird nirgends verwendet
                                    || ' data-bewertung="'
                                    || piv_bewertung
                                    || '"'
                                    || ' data-kommentar="'
                                    || apex_escape.html(piv_kommentar)
                                    || '"'
                                    || '>'
                        --
                                    || '<option value=""'
                                    ||
                                        case
                                            when piv_bewertung is null then
                                                ' selected'
                                        end
                                    || '>'
                                    || trim('&mdash; unbewertet &mdash; ' 
                          --|| CASE WHEN piv_score > '0' THEN ' Score: ' || piv_score END
                                     || piv_score)
                                    || '</option>'
                        --
                                    || '<optgroup label ="Bewertung:">'
                        -- Liste der möglichen Bewertungen. Bestehende Bewertungen werden vorausgewählt:
                                    || '<option value="K"'
                                    ||
                                        case
                                            when piv_bewertung = 'K' then
                                                ' selected'
                                        end
                                    || '>&#128172; Kommentar ...</option>'
                        --
                                    || '<option value="G"'
                                    ||
                                        case
                                            when piv_bewertung = 'G' then
                                                ' selected'
                                        end
                                    || '>'
                                    || bewertungstext('G')
                                    || '</option>'
                        --
                                    || '<option value="W"'
                                    ||
                                        case
                                            when piv_bewertung = 'W' then
                                                ' selected'
                                        end
                                    || '>'
                                    || bewertungstext('W')
                                    || '</option>'
                        --
                                    || '<option value="F"'
                                    ||
                                        case
                                            when piv_bewertung = 'F' then
                                                ' selected'
                                        end
                                    || '>'
                                    || bewertungstext('F')
                                    || '</option>'
                        --
                                    || '<option value="X"' -- Glühhbirne: &#128161; Kaffeetasse: &#9749; Sanduhr: &#9203;
                                    ||
                                        case
                                            when piv_bewertung = 'X' then
                                                ' selected'
                                        end
                                    || '>'
                                    || bewertungstext('X')
                                    || '</option>'
                        --
                                    || '</optgroup>'
                                    || '</select>'
                            end
                    end
            end,
            'headers="bewertung" style="text-align:center"', 
            -- die Selectliste nicht escapen:
            i_escape => false)
      -------------------------------------------            
               || '</tr>';
    end tr;
   
  
  
/**
 * Liefert eine HTML-Zeile für die Historien-Tabelle zurück
 */
    function tr_historie (
        pib_header       in boolean,
        pin_bewertung_id in ftth_dubletten_bewertung.id%type,
        pin_aktuell      in ftth_dubletten_bewertung.aktuell%type,
        pid_datum        in ftth_dubletten_bewertung.datum%type,
        piv_username     in ftth_dubletten_bewertung.username%type,
        piv_apex_user    in varchar2,
        piv_bewertung    in ftth_dubletten_bewertung.bewertung%type,
        piv_kommentar    in ftth_dubletten_bewertung.kommentar%type,
        piv_html_class   in varchar2 default null
    ) return varchar2 is
        c_erstellungsdatum constant varchar2(50) := to_char(pid_datum, 'Dy DD.MM.YYYY, HH24:MI')
                                                    || ' Uhr';
    begin
        if pib_header then
            return '<tr class="historie'
                   ||
                case
                    when piv_html_class is not null then
                        ' ' || piv_html_class
                end
                   || '">'
                   || '<td></td>' -- leer (Einrückung)
                   || '<th>bewertet am</th>' -- Datum
                   || '<th colspan="4">von</th>' -- Username              
                   || '<th style="text-align:center" colspan="2">Bewertung</th>' -- Bewertung
                   || '<th colspan="'
                   || ( c_num_report_cols - 9 )
                   || '">Kommentar</th>'
                   || '<th style="text-align:center">Aktion</th>'
                   || '</tr>';

        else
            return '<tr class="historie'
                   ||
                case
                    when pin_aktuell = 0 then
                        ' alt'
                end
                   ||
                case
                    when piv_html_class is not null then
                        ' ' || piv_html_class
                end
                   || '">'
                   || '<td></td>'
                   || '<td>'
                   || c_erstellungsdatum
                   || '</td>'
                   || '<td class="historie" colspan="4">'
                   || piv_username
                   || '</td>'
                   || '<td class="historie" colspan="2" style="white-space:nowrap">'
                   || bewertungstext(piv_bewertung)
                   || '</td>'
                   || '<td class="historie kommentar" colspan="'
                   || ( c_num_report_cols - 9 )
                   || '">'
                   || replace(piv_kommentar,
                              chr(10),
                              '<br/>')
                   || '</td>'
                   || '<td class="historie" style="text-align:center">'
                   ||
                case
                    when piv_username = piv_apex_user then
                        '<button type="button" class="bewertungLoeschen" data-bwid="'
                        || pin_bewertung_id
                        || '">Bewertung löschen</button>' 
               -- /// hier könnte besser eine Selectliste für "Bewertung ändern" stehen
                    else '&ndash;'
                end
                   || '</td>'
                   || '</tr>';
        end if;
    end tr_historie;    

    
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
    ) is

        v_original_counter            naturaln := 0;
        v_siebel_counter              naturaln := 0;
        v_pob_counter                 naturaln := 0;
        v_preorderbuffer_kundennummer ftth_ws_sync_preorders.customernumber%type;
        v_preorderbuffer_nachname     ftth_ws_sync_preorders.customer_name_last%type;
        v_preorderbuffer_vorname      ftth_ws_sync_preorders.customer_name_first%type;
        v_preorderbuffer_iban         ftth_ws_sync_preorders.account_iban%type;
        v_count_siebel_historie       naturaln := 0;
        v_count_pob_historie          naturaln := 0;
        c_suche_im_pob                constant boolean := nvl(pin_suchorte, 1) in ( 1, 3 );
        c_suche_in_siebel             constant boolean := nvl(pin_suchorte, 2) in ( 2, 3 );
        c_score_typ_name_und_iban     constant varchar2(30) := 'Name & IBAN';
        c_score_typ_name              constant varchar2(30) := 'Name';
        c_score_typ_iban              constant varchar2(30) := 'IBAN';
---gaensefuesschen  CONSTANT VARCHAR2(1) := '"';
        type kundennummern_array_t is
            table of varchar2(100);
        v_kundennummern_array         kundennummern_array_t := kundennummern_array_t();
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name               constant logs.routine_name%type := 'htp_report';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_ftth_id', piv_ftth_id);
            pck_format.p_add('piv_html_id', piv_html_id);
            pck_format.p_add('piv_html_class', piv_html_class);
            pck_format.p_add('piv_app_session', piv_app_session);
            pck_format.p_add('piv_apex_user', piv_apex_user);
            pck_format.p_add('pin_historie', pin_historie);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------     
        function headerzeile (
            i_score      in varchar2 default null,
            i_html_class in varchar2 default null
        ) return varchar2 is
        begin
            return tr(
                pib_header       => true,
                piv_kundennummer => 'Kundennummer',
                piv_uuid         => 'Auftrags-ID' -- wird jedoch nicht angezeigt, denn auf diese Spalte wird seit 23. Februar 2024 verzichtet
                ,
                piv_anrede       => 'Anrede',
                piv_titel        => 'Titel',
                piv_vorname      => 'Vorname',
                piv_nachname     => 'Nachname',
                piv_firmenname   => 'Firma',
                piv_geburtsdatum => 'Geburtsdatum',
                piv_haus_lfd_nr  => 'HAUS_LFD_NR'
                /* @ticket FTTH-5183
                piv_strasse => 'Straße, Hausnr.'                
                piv_hausnummer => NULL,
                piv_plz => 'PLZ, Ort',
                piv_ort => NULL,
                */,
                piv_adresse      => 'Adresse',
                piv_iban         => 'IBAN',
                piv_vkz          => 'VKZ',
                piv_app_session  => piv_app_session,
                pin_historie     => pin_historie,
                piv_score        => i_score,
                piv_html_class   => i_html_class
            );
        end;

        procedure push_kundennummer (
            knr in varchar2
        ) is
        begin
            v_kundennummern_array.extend();
            v_kundennummern_array(v_kundennummern_array.count) := knr;
        end;

        function kundennummer_bereits_gezeigt (
            knr in varchar2
        ) return boolean is
        begin
            return knr member of v_kundennummern_array;
        end;
    
  --/inline ---------------------------
    begin
        htp.p('<table'
              ||
            case
                when piv_html_id is not null then
                    ' id="'
                    || piv_html_id
                    || '"'
            end
              ||
            case
                when piv_html_class is not null then
                    ' class="'
                    || piv_html_class
                    || '"'
            end
              || '>');
    ----------------------------------------------------------------------------
    -- /1./
    -- Original-Datensatz:
        htp.p('<tr class="dubletten-header original"><th colspan="'
              || to_char(c_num_report_cols)
              || '">Original-Datensatz im PreOrder-Buffer</th></tr>');
      
    -- Alle Datensätze in PreOrder-Buffer suchen, die entweder mit der FTTH-ID Übereinstimmen oder 
    -- die identische Kundennummer besitzen.
    -- Welcher mit der FTTH-ID übereinstimmt, wird zuoberst gelistet.
        for p in (
            select
                id                                                            as ftth_id,
                customernumber                                                as kundennummer,
                state                                                         as auftragsstatus,
                decode(customer_salutation, 'MISTER', 'Herr', 'MISS', 'Frau') as anrede,
                customer_title                                                as titel,
                customer_name_first                                           as vorname,
                customer_name_last                                            as nachname,
                customer_businessname                                         as firmenname,
                customer_birthdate                                            as geburtsdatum,
           --  install_addr_street      AS strasse,
           --  install_addr_housenumber AS hausnummer,
           --  install_addr_zipcode     AS plz,
           --  install_addr_city        AS ort,
                account_iban                                                  as iban,
                vkz,
                houseserialnumber                                             as haus_lfd_nr
            from
                ftth_ws_sync_preorders
            where
                ( id = piv_ftth_id
          -- zusätzliche Aufträge desselben Kunden:
                  or ( customernumber = (
                    select
                        customernumber
                    from
                        ftth_ws_sync_preorders
                    where
                        id = piv_ftth_id
                ) ) )
                and state = pck_glascontainer.status_in_review -- neu 2023-02-22
       -- die Sortierung ist wichtig für den Algorithmus:
       -- der eigene Eintrag zuerst          
            order by
                    case
                        when id <> piv_ftth_id then
                            customernumber
                    end
                nulls first
        ) loop
            declare
        -- ////////////////@todo 2025-04-09: Die folgenden Variablen füllen mit PCK_GLASCONTAINER_EXT.p_get_siebel_kopfdaten, 
        -- im Aufruf tr() verwenden, da ca. 15 % der Einträge im POB keine persönlichen Daten eingetragen haben.
                v_anrede       varchar2(30);
                v_titel        varchar2(100);
                v_vorname      varchar2(100);
                v_nachname     varchar2(100);
                v_geburtsdatum date;
                v_firmenname   varchar2(200);
            begin
      -- alle Preorderbuffer-Datensätze desselben Kunden:
                v_original_counter := 1 + v_original_counter;
      
      -- neu 2025-04-09: Für den häufigen Fall der unvollständigen Daten im POB werden nun die Kopfdaten aus Siebel geholt:
                v_anrede := p.anrede;
                v_titel := p.titel;
                v_vorname := p.vorname;
                v_nachname := p.nachname;
                v_geburtsdatum := p.geburtsdatum;
                v_firmenname := p.firmenname;
                if p.kundennummer is not null then --  nur dann ergibt die Nachfrage bei Siebel Sinn:
                    pck_glascontainer_ext.p_get_siebel_kopfdaten(
                        piv_kundennummer  => p.kundennummer,
                        piov_vorname      => v_vorname,
                        piov_nachname     => v_nachname,
                        piod_geburtsdatum => v_geburtsdatum,
                        piov_anrede       => v_anrede,
                        piov_titel        => v_titel,
                        piov_firmenname   => v_firmenname
                    );
                end if;

                case v_original_counter
                    when 1 then
          -- ////// erläutern: warum?
                        v_preorderbuffer_kundennummer := p.kundennummer;
                        v_preorderbuffer_nachname := v_nachname;
                        v_preorderbuffer_vorname := v_vorname;
                        v_preorderbuffer_iban := p.iban;
                        htp.p(headerzeile);
                    when 2 then
          --------------------------------------------------------------------------
          -- /2./
          -- ab hier folgen "weitere Aufträge" desselben Kunden im Preorderbuffer:
                        htp.p('<tr class="dubletten-header weitere-auftraege"><th colspan="'
                              || to_char(c_num_report_cols)
                              || '">Weitere Aufträge mit derselben Kundennummer im PreOrder-Buffer</th></tr>');
                        htp.p(headerzeile);
                    else
                        null; -- keine Überschrift mehr ausgeben
                end case;
      -- den Folgeauftrag ausgeben:
                htp.p(tr(
                    pib_header       => false,
                    piv_kundennummer => p.kundennummer, -- war: case v_original_counter when 1 then p.kundennummer else gaensefuesschen end,
                    piv_uuid         => p.ftth_id,
                    piv_anrede       => p.anrede,
                    piv_titel        => p.titel,
                    piv_vorname      => v_vorname, -- p.vorname, 
                    piv_nachname     => v_nachname, -- p.nachname,
                    piv_firmenname   => v_firmenname, -- p.firmenname, 
                    piv_geburtsdatum => to_char(v_geburtsdatum, 'DD.MM.YYYY'), -- to_char(p.geburtsdatum, 'DD.MM.YYYY'), 
                    piv_haus_lfd_nr  => p.haus_lfd_nr,
               /* @ticket FTTH-5038
               piv_strasse => p.strasse,
               piv_hausnummer => p.hausnummer,
               piv_plz => p.plz,
               piv_ort => p.ort,
               */
                    piv_adresse      => pck_adresse.adresse_komplett(pin_haus_lfd_nr => p.haus_lfd_nr),
                    piv_iban         => p.iban,
                    piv_vkz          => p.vkz,
                    piv_app_session  => piv_app_session,
                    pin_historie     => pin_historie,
                    piv_score        => null
                ));

            end;

            push_kundennummer(p.kundennummer);
        end loop;
    ----------------------------------------------------------------------------
    -- Shortcut für Entwicklung:
        if v_preorderbuffer_kundennummer is null then
            htp.p('</tr></table><h3>Dieser Datensatz besitzt keine Kundennummer, ein Dublettenabgleich mit Bewertung ist nicht möglich.</h3>'
            );
            return; -- Abbruch
        end if;
    ----------------------------------------------------------------------------
        if c_suche_in_siebel then
      -- /3./
      -- Mögliche Kunden-Dubletten in SIEBEL:
            htp.p('<tr class="dubletten-header dubletten"><th colspan="'
                  || to_char(c_num_report_cols)
                  || '">Fuzzy!Double-Suche: Mögliche Kunden-Dubletten in Siebel (ggf. mit weiteren Aufträgen im PreOrder-Buffer)</th></tr>'
                  );
            htp.p(headerzeile(i_score =>
                                       case
                                           when pin_historie = 0 then
                                               'Bewertung'
                                       end
            ));    
      -- Alle Fuzzy-Ergebnisse auflisten:
      -- Siebel Workaround Start
            << siebel_suche >> for fuzzy_details in (
                select
                    fuz.fuzzy_rowid,
                    to_char(fuz.score)
                    || ' ('
                    ||
                    case fuz.score_typ
                            when 'BNK' then
                                'IBAN'
                            when 'PHO' then
                                'Name'
                    end
                    || ')' as score -- @@next: score_typ
                    ,
                    det.vorname,
                    det.nachname,
                    det.firmenname,
                    det.geburtsdatum,
                    det.strasse,
                    det.hausnummer,
                    det.plz,
                    det.ort,
                    det.iban
                from
                         ftth_preorders_fuzzydouble fuz
          -- in der Entwicklungsumgebung haben wir überhaupt keine Übereinstimmungen
          -- zwischen Siebel und Fuzzy, daher nehmen wir hier einen JOIN mit den 
          -- Fuzzy_Details (die es immer gibt), 
          -- damit überhaupt etwas angezeigt wird.
                    join ftth_preorders_fuzzy_details det on ( det.fuzzy_id = fuz.id )
                where
                        fuz.ftth_id = piv_ftth_id
                    and fuz.status is null -- nicht die Eigentreffer
                order by
                    fuz.score desc,
                    case
                        when det.iban is not null then
                                1
                    end
                    nulls last,
                    fuz.fuzzy_rowid
            ) loop
        -- Die Performance war unerträglich schlecht (bis hin zum Internal Server Error),
        -- wenn die Siebel-View direkt im obigen SQL als JOIN verwendet wurde. 
        -- Also wird nun jeder SIEBEL-Datensatz per Direktabfrage hinzugefügt:
                declare
                    v_siebel_kundennummer    varchar2(100);
                    v_siebel_anrede          varchar2(100);
                    v_siebel_titel           varchar2(100);
                    v_siebel_vorname         varchar2(100);
                    v_siebel_nachname        varchar2(100);
                    v_siebel_geburtsdatum    date;
                    v_siebel_firmenname      varchar2(100);
                    v_siebel_strasse         varchar2(100);
                    v_siebel_hausnummer      varchar2(100);
                    v_siebel_plz             varchar2(100);
                    v_siebel_ort             varchar2(100);
                    v_siebel_iban            varchar2(100);
                    v_count_siebel_auftraege naturaln := 0;
                    v_siebel_bewertung       ftth_dubletten_bewertung.bewertung%type;
                    v_siebel_kommentar       ftth_dubletten_bewertung.kommentar%type;
                begin         
          -- Direktabfrage der Kundendaten aus SIEBEL, da der JOIN mit dieser
          -- View zu immens langen Ausführungszeiten geführt hat
          -- 2023-03-02 Ohne Loop, da wir nun die Zusage haben, dass nur der GULETIG-Datensatz geliefert wird:
                    begin
                        select
                            kundennummer,
                            anrede,
                            titel,
                            vorname,
                            nachname,
                            strasse,
                            trim(hausnr_von
                                 || ' '
                                 || hausnr_zusatz_von),
                            plz,
                            ort,
                            iban
                        into
                            v_siebel_kundennummer,
                            v_siebel_anrede,
                            v_siebel_titel,
                            v_siebel_vorname,
                            v_siebel_nachname,
                            v_siebel_strasse,
                            v_siebel_hausnummer,
                            v_siebel_plz,
                            v_siebel_ort,
                            v_siebel_iban
                        from
                            v_apx_gc_customerdata@siebp.netcologne.intern@siebel_inf -- Synonym in DEV: siebelinf
                        where
                                global_id = fuzzy_details.fuzzy_rowid
          -- 2023-02-16: @Workaround
                            and gueltig = 'Y';

                    exception
                        when too_many_rows then
                            null; -- ////
                        when no_data_found then
                            null; -- ////
                    end;

                    if kundennummer_bereits_gezeigt(v_siebel_kundennummer) then
                        continue siebel_suche;
                    end if;
                    push_kundennummer(v_siebel_kundennummer);
                    v_siebel_counter := 1 + v_siebel_counter;
                    if v_siebel_kundennummer is null then
            -- sollte die Ausnahme sein, aber veraltete Fuzzy-Daten könnten auf nicht mehr
            -- existierende Kundendaten verweisen
            -- siehe auch DSGVO-Problem , @ticket 1769
                        v_siebel_kundennummer := fuzzy_details.fuzzy_rowid; 
            -- (die fuzzy_details-Zeile bekommt weiter unten einen enstsprechenden Hinweis,
            -- die übrigen fehlenden Felder werden mit COALESCE ersetzt)
                    end if;
          
          -- Zunächst die ggf. bestehende aktuelle Bewertung lesen:
                    for bw in (-- maximal eine Zeile möglich
                        select
                            bewertung,
                            kommentar,
                            aktuell
                        from
                            ftth_dubletten_bewertung
                        where
                                knr0 = v_preorderbuffer_kundennummer
                            and knr1 = v_siebel_kundennummer
                            and aktuell = 1
                    ) loop
                        v_siebel_bewertung := bw.bewertung;
                        v_siebel_kommentar := bw.kommentar;
                    end loop;  
  
          -- Falls vom letzten Siebel-Kunden Historien angezeigt wurden,
          -- dann soll der Übersichtlichkeit halber eine weitere
          -- Überschrift für die nachfolgenden Kunden eingeblendet werden:
                    if v_count_siebel_historie > 0 then
                        htp.p(headerzeile(i_html_class => 'padding-top'));
                        v_count_siebel_historie := 0;
                    end if; 
            
          -- Für jeden Siebel-Kunden:
          -- In der Bearbeitungs-Sicht nur die unbewerteten oder die noch zu klärenden anzeigen,
          -- in der Historischen Sicht alles:
                    if pin_historie = 1
                    or v_siebel_bewertung is null
                    or v_siebel_bewertung = 'W' -- "klären (Wiedervorlage)"
                     then
    
            -- Nun für jede hier ermittelte Siebel-Kundennummer prüfen, ob zu dieser 
            -- ein oder mehrere Aufträge im Preorderbuffer existieren 
            -- (im ersten Siebel-Datensatz sollte der erste Auftrag bereits eingeschoben werden)
                        for a in (
                            select
                                id                       as id,
                                customer_salutation      as anrede,
                                customer_businessname    as firmenname,
                                customer_title           as titel,
                                customer_name_first      as vorname,
                                customer_name_last       as nachname,
                                customer_birthdate       as geburtsdatum,
                                state                    as status,
                                houseserialnumber        as haus_lfd_nr,
                                install_addr_street      as strasse,
                                install_addr_housenumber as hausnummer,
                                install_addr_zipcode     as plz,
                                install_addr_city        as ort,
                                account_iban             as iban,
                                vkz                      as vkz
                            from
                                ftth_ws_sync_preorders
                            where
                                    customernumber = v_siebel_kundennummer
                                and state = pck_glascontainer.status_in_review
                            order by
                                1
                        ) loop
              -- Der Haupt-Anzeigebereich des Siebel-Dubletten-Reports:
                            v_count_siebel_auftraege := 1 + v_count_siebel_auftraege;
              -- Wenn mindestens ein Auftrag gefunden wurde, dann den ersten
              -- Siebel-Datensatz bereits mit dem ersten Auftrag verweben:
                            if v_count_siebel_auftraege = 1 then
                  
                -- Siebel-Kundendaten, Kopfzeile falls ein Auftrag existiert:
                                htp.p(tr(
                                    pib_header       => false,
                                    piv_kundennummer => coalesce(v_siebel_kundennummer, fuzzy_details.fuzzy_rowid) -- ///// Diejenigen nicht anzeigen, die nur eine fuzzy_rowid haben!!! DSGVO
                                    ,
                                    piv_uuid         => null -- die Verlinkung zu einem Auftrag erfolgt nun unterhalb der Siebel-Kopfzeile
                                    ,
                                    piv_anrede       => v_siebel_anrede,
                                    piv_titel        => v_siebel_titel,
                                    piv_vorname      => coalesce(v_siebel_vorname, fuzzy_details.vorname),
                                    piv_nachname     => coalesce(v_siebel_nachname, fuzzy_details.nachname),
                                    piv_firmenname   => coalesce(v_siebel_firmenname, fuzzy_details.firmenname),
                                    piv_geburtsdatum => to_char(v_siebel_geburtsdatum, 'DD.MM.YYYY'),
                                    piv_haus_lfd_nr  => null,
                         /* @ticket FTTH-5038
                         piv_strasse      => COALESCE(v_siebel_strasse, fuzzy_details.strasse),
                         piv_hausnummer   => COALESCE(v_siebel_hausnummer, fuzzy_details.hausnummer),
                         piv_plz          => COALESCE(v_siebel_plz, fuzzy_details.plz),
                         piv_ort          => COALESCE(v_siebel_ort, fuzzy_details.ort),
                         */
                                    piv_adresse      => pck_adresse.adresse_komplett(
                                                                         piv_strasse               => coalesce(v_siebel_strasse, fuzzy_details.strasse
                                                                         ),
                                                                         piv_hausnummer            => coalesce(v_siebel_hausnummer, fuzzy_details.hausnummer
                                                                         ),
                                                                         piv_hausnummer_zusatz     => null,
                                                                         piv_hausnummer_bis        => null,
                                                                         piv_hausnummer_zusatz_bis => null,
                                                                         piv_gebaeudeteil          => null,
                                                                         piv_plz                   => coalesce(v_siebel_plz, fuzzy_details.plz
                                                                         ),
                                                                         piv_ort                   => coalesce(v_siebel_ort, fuzzy_details.ort
                                                                         ),
                                                                         piv_ortsteil              => null
                                                                     ),
                                    piv_iban         => fuzzy_details.iban,
                                    piv_vkz          => null,
                                    piv_app_session  => piv_app_session,
                                    pin_historie     => pin_historie,
                                    piv_score        => 'Score: ' || fuzzy_details.score,
                                    piv_bewertung    => v_siebel_bewertung,
                                    piv_kommentar    => v_siebel_kommentar
                                ));

                            end if;
              ---ELSE -- (ab Auftrag 2 aufwärts)
                -- Alle weiteren Aufträge unterhalb der Siebel-Kopfzeile anzeigen;
                -- (dies dürfte sehr selten auftreten)
                            htp.p(tr(
                                pib_header       => false,
                                piv_kundennummer => v_siebel_kundennummer, -- gaensefuesschen, -- v_siebel_kundennummer, diese irritiert, da sie ja nur wiederholt wird
                                piv_uuid         => a.id
                  --, piv_auftragsstatus => a.status
                                ,
                                piv_anrede       => a.anrede,
                                piv_titel        => a.titel,
                                piv_vorname      => a.vorname,
                                piv_nachname     => a.nachname,
                                piv_firmenname   => a.firmenname,
                                piv_geburtsdatum => to_char(a.geburtsdatum, 'DD.MM.YYYY'),
                                piv_haus_lfd_nr  => a.haus_lfd_nr,
                         /* @ticket FTTH-5038
                         piv_strasse      => a.strasse,
                         piv_hausnummer   => a.hausnummer,
                         piv_plz          => a.plz,
                         piv_ort          => a.ort,
                         */
                                piv_adresse      => pck_adresse.adresse_komplett(
                                                                 piv_strasse               => a.strasse,
                                                                 piv_hausnummer            => a.hausnummer,
                                                                 piv_hausnummer_zusatz     => null,
                                                                 piv_hausnummer_bis        => null,
                                                                 piv_hausnummer_zusatz_bis => null,
                                                                 piv_gebaeudeteil          => null,
                                                                 piv_plz                   => a.plz,
                                                                 piv_ort                   => a.ort,
                                                                 piv_ortsteil              => null
                                                             ),
                                piv_iban         => a.iban,
                                piv_vkz          => a.vkz,
                                piv_app_session  => piv_app_session,
                                pin_historie     => pin_historie,
                                piv_score        => null,
                                piv_bewertung    => v_siebel_bewertung,
                                piv_kommentar    => v_siebel_kommentar
                            ));
              ---END IF;
                        end loop; -- /Siebel-Aufträge im POB
            -- Es wurden keine Aufträge im Preorderbuffer für diesen SIEBEL-Kunden gefunden:
                        if v_count_siebel_auftraege = 0 then
              -- Erste Zeile.
              -- Siebel-Kundendaten, Kopfzeile falls KEIN Auftrag existiert:
                            htp.p(tr(
                                pib_header       => false,
                                piv_kundennummer => coalesce(v_siebel_kundennummer, fuzzy_details.fuzzy_rowid),
                                piv_uuid         => kein_auftrag_vorhanden
                --, piv_auftragsstatus => NULL
                                ,
                                piv_anrede       => v_siebel_anrede,
                                piv_titel        => v_siebel_titel,
                                piv_vorname      => coalesce(v_siebel_vorname, fuzzy_details.vorname),
                                piv_nachname     => coalesce(v_siebel_nachname, fuzzy_details.nachname),
                                piv_firmenname   => coalesce(v_siebel_firmenname, fuzzy_details.firmenname),
                                piv_geburtsdatum => to_char(v_siebel_geburtsdatum, 'DD.MM.YYYY'),
                                piv_haus_lfd_nr  => null,
                       /* @ticket FTTH-5038
                       piv_strasse      => COALESCE(v_siebel_strasse, fuzzy_details.strasse),
                       piv_hausnummer   => COALESCE(v_siebel_hausnummer, fuzzy_details.hausnummer),
                       piv_plz          => COALESCE(v_siebel_plz, fuzzy_details.plz),
                       piv_ort          => COALESCE(v_siebel_ort, fuzzy_details.ort),
                       */
                                piv_adresse      => pck_adresse.adresse_komplett(
                                                                 piv_strasse               => coalesce(v_siebel_strasse, fuzzy_details.strasse
                                                                 ),
                                                                 piv_hausnummer            => coalesce(v_siebel_hausnummer, fuzzy_details.hausnummer
                                                                 ),
                                                                 piv_hausnummer_zusatz     => null,
                                                                 piv_hausnummer_bis        => null,
                                                                 piv_hausnummer_zusatz_bis => null,
                                                                 piv_gebaeudeteil          => null,
                                                                 piv_plz                   => coalesce(v_siebel_plz, fuzzy_details.plz
                                                                 ),
                                                                 piv_ort                   => coalesce(v_siebel_ort, fuzzy_details.ort
                                                                 ),
                                                                 piv_ortsteil              => null
                                                             ),
                                piv_iban         => coalesce(v_siebel_iban, fuzzy_details.iban),
                                piv_vkz          => null,
                                piv_app_session  => piv_app_session,
                                pin_historie     => pin_historie,
                                piv_score        => 'Score: ' || fuzzy_details.score,
                                piv_bewertung    => v_siebel_bewertung,
                                piv_kommentar    => v_siebel_kommentar
                            ));

                        end if; -- Siebel im POB
                    end if; -- nur unbewertete oder Historie
            
          -- In der Historischen Sicht folgt nun unter jeder Siebel-Kundennummer
          -- die Abfolge der jemals erteilten Bewertungen
                    if pin_historie = 1 then -- historischer Anzeigemodus        
                        begin
              -- Alle Bewertungen lesen:
                            for bw in (-- maximal eine Zeile möglich
                                select
                                    id,
                                    bewertung,
                                    datum,
                                    kommentar,
                                    username,
                                    aktuell
                                from
                                    ftth_dubletten_bewertung
                                where
                                        knr0 = v_preorderbuffer_kundennummer
                                    and knr1 = v_siebel_kundennummer
                                order by
                                    aktuell desc nulls last,
                                    datum desc,
                                    id desc
                            ) loop
                                v_count_siebel_historie := 1 + v_count_siebel_historie;
                                if v_count_siebel_historie = 1 then
                                    htp.p(tr_historie(
                                        pib_header       => true,
                                        pin_bewertung_id => null,
                                        pin_aktuell      => null,
                                        pid_datum        => null,
                                        piv_username     => null,
                                        piv_apex_user    => null,
                                        piv_bewertung    => null,
                                        piv_kommentar    => null
                                    ));

                                end if;

                                htp.p(tr_historie(
                                    pib_header       => false,
                                    pin_bewertung_id => bw.id,
                                    pin_aktuell      => nvl(bw.aktuell, 0),
                                    pid_datum        => bw.datum,
                                    piv_username     => bw.username,
                                    piv_apex_user    => upper(piv_apex_user),
                                    piv_bewertung    => bw.bewertung,
                                    piv_kommentar    => bw.kommentar
                                ));

                            end loop;

                        end;
                    end if;

                end;
            end loop;
      -- /Siebel Workaround End
            if v_siebel_counter = 0 then
                htp.p('<tr><td colspan="'
                      || c_num_report_cols
                      || '">(keine Übereinstimmungen)</td></tr>');
            end if;

        end if;

        if c_suche_im_pob then
      -- /4./
      -- @ticket 1769
            htp.p('<tr class="dubletten-header dubletten"><th colspan="'
                  || to_char(c_num_report_cols)
                  || '">Weitere mögliche Kunden-Dubletten im PreOrder-Buffer (ggf. mit weiteren Aufträgen)</th></tr>');
            htp.p(headerzeile(i_score =>
                                       case
                                           when pin_historie = 0 then
                                               'Bewertung'
                                       end
            ));  
      
      -- Alle "gleich klingenden" Kunden im Preorderbuffer:
            for pob in (
                select
                    pob.customernumber           as kundennummer,
                    pob.customer_name_first      as vorname,
                    pob.customer_name_last       as nachname,
                    pob.customer_birthdate       as geburtsdatum,
                    pob.install_addr_street      as strasse,
                    pob.install_addr_housenumber as hausnummer,
                    pob.install_addr_zipcode     as plz,
                    pob.install_addr_city        as ort,
                    pob.account_iban             as iban,
                    case
                        when upper(pob.customer_name_last) = upper(v_preorderbuffer_nachname)
                             and upper(pob.customer_name_first) = upper(v_preorderbuffer_vorname)
                             and pob.account_iban = v_preorderbuffer_iban then
                            c_score_typ_name_und_iban
                        when pob.account_iban = v_preorderbuffer_iban then
                            c_score_typ_iban
                        else
                            c_score_typ_name
                    end                          as score_typ
                from
                    ftth_ws_sync_preorders pob
                where
                        pob.id != piv_ftth_id
                    and pob.customernumber != v_preorderbuffer_kundennummer -- sondern die Dubletten! -- 2023-02-23 /////
                    and ( pob.account_iban = v_preorderbuffer_iban
                          or ( upper(pob.customer_name_last) = upper(v_preorderbuffer_nachname)
                               and upper(pob.customer_name_first) = upper(v_preorderbuffer_vorname) ) )
                    and state = pck_glascontainer.status_in_review
                order by
                    length(score_typ) desc -- "Name & IBAN" zuerst, da beste Trefferquote
                    ,
                    pob.customer_name_last,
                    pob.customer_name_first,
                    pob.id desc
            ) loop
                if kundennummer_bereits_gezeigt(pob.kundennummer) then
                    continue;
                end if;
                push_kundennummer(pob.kundennummer);
                declare
                    v_pob_bewertung       ftth_dubletten_bewertung.bewertung%type;
                    v_pob_kommentar       ftth_dubletten_bewertung.kommentar%type;
                    v_count_pob_auftraege naturaln := 0;
                begin
                    v_pob_counter := 1 + v_pob_counter;
          -- @next
          -- Aktuelle Bewertung der POB-Dublette lesen:
                    for bw in (-- maximal eine Zeile möglich
                        select
                            bewertung,
                            kommentar,
                            aktuell
                        from
                            ftth_dubletten_bewertung
                        where
                                knr0 = v_preorderbuffer_kundennummer
                            and knr1 = pob.kundennummer
                            and aktuell = 1
                    ) loop
                        v_pob_bewertung := bw.bewertung;
                        v_pob_kommentar := bw.kommentar;
                    end loop;
          -- ggf. Überschrift für die nachfolgenden Kunden einblenden:
                    if v_count_pob_historie > 0 then
                        htp.p(headerzeile(i_html_class => 'padding-top'));
                        v_count_pob_historie := 0;
                    end if;   
          -- Für jeden dieser gleich klindenden POB-Kunden:
          -- In der Bearbeitungs-Sicht nur unbewertete oder noch zu klärende Dubletten anzeigen,
          -- in der Historischen Sicht alles:
                    if pin_historie = 1
                    or v_pob_bewertung is null
                    or v_pob_bewertung = 'W' -- "klären (Wiedervorlage)"
                     then
            -- Nun für jede hier ermittelte POB-Kundennummer prüfen, ob zu dieser 
            -- wiederum weitere Aufträge im Preorderbuffer existieren 
            -- (im ersten POB-Datensatz sollte der erste Auftrag bereits eingeschoben werden)
                        for pob_auftrag in (
                            select
                                id                       as uuid,
                                customer_salutation      as anrede,
                                customer_businessname    as firmenname,
                                customer_title           as titel,
                                customer_name_first      as vorname,
                                customer_name_last       as nachname,
                                customer_birthdate       as geburtsdatum,
                                state                    as status,
                                houseserialnumber        as haus_lfd_nr,
                                install_addr_street      as strasse,
                                install_addr_housenumber as hausnummer,
                                install_addr_zipcode     as plz,
                                install_addr_city        as ort,
                                account_iban             as iban,
                                vkz                      as vkz
                            from
                                ftth_ws_sync_preorders
                            where
                                    customernumber = pob.kundennummer
                                and state = pck_glascontainer.status_in_review
                            order by
                                1
                        ) loop
              -- Haupt-Anzeigebereich des POB-Dublettenreports:
                            v_count_pob_auftraege := 1 + v_count_pob_auftraege;
                            htp.p(tr(
                                pib_header       => false,
                                piv_kundennummer => pob.kundennummer,
                                piv_uuid         => pob_auftrag.uuid,
                                piv_anrede       => pob_auftrag.anrede,
                                piv_titel        => pob_auftrag.titel,
                                piv_vorname      => pob_auftrag.vorname,
                                piv_nachname     => pob_auftrag.nachname,
                                piv_firmenname   => pob_auftrag.firmenname,
                                piv_geburtsdatum => to_char(pob_auftrag.geburtsdatum, 'DD.MM.YYYY'),
                                piv_haus_lfd_nr  => pob_auftrag.haus_lfd_nr,
                       /* @ticket FTTH-5038
                       piv_strasse      => pob_auftrag.strasse,
                       piv_hausnummer   => pob_auftrag.hausnummer,
                       piv_plz          => pob_auftrag.plz,
                       piv_ort          => pob_auftrag.ort,
                       */
                                piv_adresse      => pck_adresse.adresse_komplett(
                                                                 piv_strasse               => pob_auftrag.strasse,
                                                                 piv_hausnummer            => pob_auftrag.hausnummer,
                                                                 piv_hausnummer_zusatz     => null,
                                                                 piv_hausnummer_bis        => null,
                                                                 piv_hausnummer_zusatz_bis => null,
                                                                 piv_gebaeudeteil          => null,
                                                                 piv_plz                   => pob_auftrag.plz,
                                                                 piv_ort                   => pob_auftrag.ort,
                                                                 piv_ortsteil              => null
                                                             ),
                                piv_iban         => pob_auftrag.iban,
                                piv_vkz          => pob_auftrag.vkz,
                                piv_app_session  => piv_app_session,
                                pin_historie     => pin_historie,
                                piv_score        => pob.score_typ,
                                piv_bewertung    => v_pob_bewertung,
                                piv_kommentar    => v_pob_kommentar
                            ));

                        end loop;
                    end if;    
            
          -- @next
                end; -- ein POB-Datensatz
        -- In der Historischen Sicht folgt nun unter jeder POB-Kundennummer
        -- die Abfolge der jemals erteilten Bewertungen
                if pin_historie = 1 then -- historischer Anzeigemodus        
                    begin
            -- Alle Bewertungen lesen:
                        for pob_bw in (-- maximal eine Zeile möglich
                            select
                                id,
                                bewertung,
                                datum,
                                kommentar,
                                username,
                                aktuell
                            from
                                ftth_dubletten_bewertung
                            where
                                    knr0 = v_preorderbuffer_kundennummer
                                and knr1 = pob.kundennummer
                            order by
                                aktuell desc nulls last,
                                datum desc,
                                id desc
                        ) loop
                            v_count_pob_historie := 1 + v_count_pob_historie;
                            if v_count_pob_historie = 1 then
                                htp.p(tr_historie(
                                    pib_header       => true,
                                    pin_bewertung_id => null,
                                    pin_aktuell      => null,
                                    pid_datum        => null,
                                    piv_username     => null,
                                    piv_apex_user    => null,
                                    piv_bewertung    => null,
                                    piv_kommentar    => null
                                ));

                            end if;

                            htp.p(tr_historie(
                                pib_header       => false,
                                pin_bewertung_id => pob_bw.id,
                                pin_aktuell      => nvl(pob_bw.aktuell, 0),
                                pid_datum        => pob_bw.datum,
                                piv_username     => pob_bw.username,
                                piv_apex_user    => upper(piv_apex_user),
                                piv_bewertung    => pob_bw.bewertung,
                                piv_kommentar    => pob_bw.kommentar
                            ));

                        end loop;

                    end;
                end if;

            end loop;

            if v_pob_counter = 0 then
                htp.p('<tr><td colspan="'
                      || c_num_report_cols
                      || '">(keine Übereinstimmungen)</td></tr>');
            end if;

        end if; -- c_suche_im_pob
        htp.p('</table>');
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end htp_report;

end pck_glascontainer_dubletten;
/

