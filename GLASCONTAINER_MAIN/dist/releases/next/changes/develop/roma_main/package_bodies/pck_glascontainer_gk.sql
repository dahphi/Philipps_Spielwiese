-- liquibase formatted sql
-- changeset ROMA_MAIN:1768480985650 stripComments:false logicalFilePath:develop/roma_main/package_bodies/pck_glascontainer_gk.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot GLASCONTAINER_MAIN/src/database/roma_main/package_bodies/pck_glascontainer_gk.sql:null:43250a82ed3a2bce5ad83ddc8b273a33d13d4559:create

create or replace package body roma_main.pck_glascontainer_gk as

    g_scope                   constant varchar2(400 char) := 'Glascontainer GK Bestellstrecke';
    cv_wb_partner_tcom        constant varchar2(40 char) := 'TCOM';
    cv_wb_partner_dg          constant varchar2(40 char) := 'DG';

  -- /////@todo konsolidieren: Nicht verwendete Konstanten sind auskommentiert und sollten
  -- im Zuge von @ticket FTTH-4314 im Zweifel ins Package POB_REST verlagert werden.
    c_ws_method_get           constant ftth_webservice_aufrufe.method%type := 'GET'; 
  --  c_ws_method_put              CONSTANT ftth_webservice_aufrufe.method%TYPE := 'PUT'; 
  --  c_ws_method_post             CONSTANT ftth_webservice_aufrufe.method%TYPE := 'POST'; 
    c_ws_statuscode_ok        constant ftth_webservice_aufrufe.response_statuscode%type := '200'; -- Alles in Ordnung 
  --  c_ws_statuscode_bad_request  CONSTANT ftth_webservice_aufrufe.response_statuscode%TYPE := '400'; -- syntaktischer Fehler beim Aufruf 
  --  c_ws_statuscode_unauthorized CONSTANT ftth_webservice_aufrufe.response_statuscode%TYPE := '401'; -- 2022-12-12 Erstmals bei den Stornogründen aufgetreten 
    c_ws_statuscode_not_found constant ftth_webservice_aufrufe.response_statuscode%type := '404'; -- tritt sowohl auf, wenn man einen nicht mehr existierenden Auftrag aufruft 
  -- bestehende UUID aktualisiert, 
  -- als auch wenn der WS insgesamt offline ist 
  -- => ///@klären mit AOE, ob Ersteres änderbar ist 
  --  c_ws_statuscode_conflict     CONSTANT ftth_webservice_aufrufe.response_statuscode%TYPE := '409'; -- technisches Problem: Auftrag ist gesperrt (2022-09-14 auf [S]) 
  --  c_ws_statuscode_server_error CONSTANT ftth_webservice_aufrufe.response_statuscode%TYPE := '500'; -- Internal Server Error: nicht näher spezifierter Verarbeitungsfehler (z.B. nicht akzeptierte templateId) 
  --  c_ws_statuscode_bad_gateway  CONSTANT ftth_webservice_aufrufe.response_statuscode%TYPE := '502'; -- Bad Gateway, beispielsweise läuft der Webservice/Liquibase nicht (@Ticket FTTH-1872) 
  --  c_ws_statuscode_unavailable  CONSTANT ftth_webservice_aufrufe.response_statuscode%TYPE := '503'; -- Service Unavailable 

    -- Abfragen / DML gegen Siebel durchführen? Default: TRUE 
    g_use_siebel              boolean := true; -- @deprecated

    e_ws_statuscode_not_found exception;
    pragma exception_init ( e_ws_statuscode_not_found, -20404 ); 

  -- Wallet, das bei jedem Webservice-Aufruf verwendet wird 
    c_ws_wallet_path          constant varchar2(100) := 'file:/oracle/app/oracle/wallet/'; 

  -- Wallet-Passwort, das bei jedem Webservice-Aufruf verwendet wird 
    c_ws_wallet_pwd           constant varchar2(100) := 'wbci2015'; 

  -- Zeit in Sekunden, die ein Webservice-Aufruf bereit ist zu warten (Oracle-Default: 180!) 
    c_ws_transfer_timeout     constant naturaln := 10; 

  -- Wird zum Erstellen eines JSON_OBJECT_T gebraucht 
    c_empty_json              constant varchar2(2) := '{}';
    json_true                 constant varchar2(5) := 'true';
    json_false                constant varchar2(5) := 'false';
    db_name                   constant varchar2(30) := core.pck_env.fv_db_name;
    
--------------------------------------------------------------------------------

    function f_show_kontakt_tcom (
        pi_wb_partner in varchar2
    ) return boolean as
          -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'f_show_kontakt_tcom';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pi_wb_partner', pi_wb_partner);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;

    begin
        if pi_wb_partner = cv_wb_partner_tcom then
            return true;
        else
            return false;
        end if;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end f_show_kontakt_tcom;
  
--------------------------------------------------------------------------------

    function f_show_kontakt_dg (
        pi_wb_partner in varchar2
    ) return boolean as
      -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'f_show_kontakt_dg';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pi_wb_partner', pi_wb_partner);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;

    begin
        if pi_wb_partner = cv_wb_partner_dg then
            return true;
        else
            return false;
        end if;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end f_show_kontakt_dg;
  
--------------------------------------------------------------------------------

    function f_has_contact (
        pi_knd_nr in varchar2
    ) return boolean as

        l_count         number;
        cv_routine_name constant logs.routine_name%type := 'get_first_contact_details';

        function fcl_params return logs.message%type is
        begin
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;

    begin
        select
            count(1)
        into l_count
        from
            v_siebel_ansprechpartner
        where
            kundennummer = pi_knd_nr;

        if l_count > 0 then
            return true;
        else
            return false;
        end if;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            return true;
    end f_has_contact;

--------------------------------------------------------------------------------

    procedure get_first_contact_details (
        pi_knd_nr                in varchar2,
        po_ap_row_id             out varchar2,
        po_anrede                out varchar2,
        po_titel                 out varchar2,
        po_vorname               out varchar2,
        po_nachname              out varchar2,
        po_phone_number          out varchar2,
        po_mobile_number         out varchar2,
        po_ap_email              out varchar2,
        po_rolle                 out varchar2,
        po_ap_x_fix_phon_country out varchar2,
        po_ap_x_fix_phon_onkz    out varchar2,
        po_ap_x_fix_phon_nr      out varchar2,
        po_ap_mobil_onkz         out varchar2,
        po_ap_mobil_country      out varchar2,
        po_ap_x_mobil_nr         out varchar2
    ) as

        cv_routine_name constant logs.routine_name%type := 'get_first_contact_details';

        function fcl_params return logs.message%type is
        begin
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;

    begin
        begin
            select
                anrede,
                titel,
                vorname,
                nachname,
                '+'
                || ap_x_fix_phon_country
                || ap_x_fix_phon_onkz
                || ap_x_fix_phon_nr as phone_number,
                '+'
                || ap_mobil_country
                || ap_mobil_onkz
                || ap_x_mobil_nr    as mobile_number,
                ap_email,
                rolle,
                ap_x_fix_phon_country,
                ap_x_fix_phon_onkz,
                ap_x_fix_phon_nr,
                ap_mobil_onkz,
                ap_mobil_country,
                ap_x_mobil_nr,
                ap_row_id
            into
                po_anrede,
                po_titel,
                po_vorname,
                po_nachname,
                po_phone_number,
                po_mobile_number,
                po_ap_email,
                po_rolle,
                po_ap_x_fix_phon_country,
                po_ap_x_fix_phon_onkz,
                po_ap_x_fix_phon_nr,
                po_ap_mobil_onkz,
                po_ap_mobil_country,
                po_ap_x_mobil_nr,
                po_ap_row_id
            from
                v_siebel_ansprechpartner
            where
                    kundennummer = pi_knd_nr
                and rownum = 1
            order by
                nachname,
                vorname asc nulls last;

        exception
            when no_data_found then
                po_anrede := null;
                po_titel := null;
                po_vorname := null;
                po_nachname := null;
                po_phone_number := null;
                po_mobile_number := null;
                po_ap_email := null;
                po_rolle := null;
                po_ap_x_fix_phon_country := null;
                po_ap_x_fix_phon_onkz := null;
                po_ap_x_fix_phon_nr := null;
                po_ap_mobil_onkz := null;
                po_ap_mobil_country := null;
                po_ap_x_mobil_nr := null;
                po_ap_row_id := null;
        end;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );
    end get_first_contact_details;

--------------------------------------------------------------------------------

/**
 * Liest die Account-ID für eine Kundennummer aus der Siebel-View aus.
 * Wenn keine gefunden wird, kommt NULL zurück.
 */
    function fv_siebel_account_id (
        piv_kundennummer in varchar2
    ) return varchar2 is
        v_siebel_account_id varchar2(128); -- Laut Specs genügt Länge 15, das ist aber zu klein! z.B. account-1343941767
                                        -- @ticket FTTH-4533
    begin
  /*  @deprecated vor Inbetriebnahme :-)
    -- vorrangig aus den POB-Synchrondaten auslesen
    SELECT max(account_id)
      INTO v_siebel_account_id
      FROM FTTH_WS_SYNC_PREORDERS
     WHERE customernumber = piv_kundennummer;
  */  
    -- In der Siebel-View nachschauen, die GLOABL_ID dort ist identisch mit der "accountId" im Preorder-Buffer:
        if v_siebel_account_id is null then
            select
                max(global_id)
            into v_siebel_account_id
            from
                v_siebel_kundendaten
            where
                kundennummer = piv_kundennummer;

        end if;

        return v_siebel_account_id;
    end;

-------------------------------------------------------------------------------

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
    ) is
    begin
        g_use_siebel := nvl(
            upper(trim(i_yes_no)),
            'N'
        ) in ( '1', 'TRUE', 'Y', 'YES', 'J',
               'JA' );
    end; 
    
-------------------------------------------------------------------------------

  /** 
  * Gibt einen JSON Timestamp-String als DATE zurück, indem auf Sekunden gekürzt wird 
  * 
  * @param i_timestamp [IN ] Literaler Timestamp aus JSON, z.B. "2022-09-21T09:41:58.602Z" 
  */
    function fd_json_timestamp (
        i_timestamp in varchar2
    ) return date
        deterministic
    is
    begin
        return
            case
                when i_timestamp is null then
                    to_date ( null )
                else to_date ( substr(i_timestamp, 1, 10)
                               || ' '
                               || substr(i_timestamp, 12, 8), 'YYYY-MM-DD HH24:MI:SS' )
            end;
    end fd_json_timestamp; 
    
--------------------------------------------------------------------------------

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
  
--------------------------------------------------------------------------------

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
 * @unittest SELECT * FROM TABLE(ut.run('UT_GLASCONTAINER', a_tags => 'fv_link_siebel_kundenmaske'));
 *
 * @example
 * SELECT PCK_GLASCONTAINER.fv_href_siebel_kundenmaske(
 *   piv_account_id    => NULL
 * , piv_kundennummer  => 14012883
 * ) FROM DUAL;
 */
    function fv_href_siebel_kundenmaske (
        piv_account_id   in varchar2,
        piv_kundennummer in varchar2 default null,
        piv_umgebung     in varchar2 default null
    ) return varchar2
        deterministic
    is
        v_account_id  varchar2(100);
        l_siebel_link varchar2(5000 char);
    begin
        l_siebel_link := core.pck_params.fv_wert1(
            piv_satzart => 'LINK',
            piv_key1    => 'PREORDERBUFFER',
            piv_key2    => 'BASE_URL_SIEBEL'
        );
    -- Versuchen, eine fehlende Account-ID zu ermitteln:
        v_account_id := coalesce(piv_account_id,
                                 fv_siebel_account_id(piv_kundennummer));

    -- Kein Link ohne Infos:
        if v_account_id is null then
            return null;
        end if;
        return l_siebel_link || v_account_id;
    end fv_href_siebel_kundenmaske;

  
--------------------------------------------------------------------------------

/**
 * Gibt den vollständigen Link (<a href="https://...">Kundennummer</a>) zur Siebel-Kundenmaske zurück
 * 
 * @param piv_kundennummer [IN]  Im Link dargestellter Text (üblicherweise nur die Kundennummer)
 * @param piv_account_id   [IN]  Der Siebel-Link erwartet die Account-ID, nicht die Kundennummer. Wenn diese nicht gesetzt
 *                               wird, dann versuch diese Funktion selbst, die Account-ID zu ermitteln.
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
        deterministic
    is

        v_account_id    varchar2(100);
        v_href          varchar2(4000);
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'fv_link_siebel_kundenmaske';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_kundennummer', piv_kundennummer);
            pck_format.p_add('piv_account_id', piv_account_id);
            pck_format.p_add('piv_target', piv_target);
            pck_format.p_add('piv_html_id', piv_html_id);
            pck_format.p_add('piv_css_class', piv_css_class);
            pck_format.p_add('piv_title', piv_title);
            pck_format.p_add('piv_aria_label', piv_aria_label);
            pck_format.p_add('piv_umgebung', piv_umgebung);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
      -- Shortcut: Kein Link ohne Angaben
        if piv_kundennummer is null then
            return null;
        end if;

      -- Versuchen, eine fehlende Account-ID zu ermitteln:
        v_account_id := coalesce(piv_account_id,
                                 fv_siebel_account_id(piv_kundennummer));
        if v_account_id is not null then
            v_href := fv_href_siebel_kundenmaske(
                piv_account_id   => v_account_id,
                piv_kundennummer => piv_kundennummer,
                piv_umgebung     => piv_umgebung
            );
        end if;
        -- //// Prüfen, ob irgendwo eine generische Funktion existiert, die das gleiche macht,
        -- ansonsten selber zur Verfügung stellen
        return
            case
                when v_href is null then
                    '<span'
                else '<a href="'
                     || v_href
                     || '"'
            end
            ||
            case
                when piv_target is not null then
                    ' target="'
                    || apex_escape.html_attribute(piv_target)
                    || '"'
            end
            ||
            case
                when piv_html_id is not null then
                    ' id="'
                    || apex_escape.html_attribute(piv_html_id)
                    || '"'
            end
            ||
            case
                when piv_css_class is not null then
                    ' class="'
                    || apex_escape.html_attribute(piv_css_class)
                    || '"'
            end
            ||
            case
                when piv_title is not null then
                    ' title="'
                    || apex_escape.html_attribute(piv_title)
                    || '"'
            end
            ||
            case
                when piv_aria_label is not null then
                    ' aria-label="'
                    || apex_escape.html_attribute(piv_aria_label)
                    || '"'
            end
            || '>'
            || apex_escape.html(piv_kundennummer)
            || case
            when v_href is null then
                '</span>'
            else '</a>'
        end;

    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end fv_link_siebel_kundenmaske;

--------------------------------------------------------------------------------

  /** 
  * Liefert die Template-Zeile zurück, die oberhalb eines Auftrags angezeigt wird 
  * 
  * @param pin_haus_lfd_nr [IN] HAUS_LFD_NR 
  * @param piv_kundennummer [IN] Anzuzeigender Wert für Kundennummer 
  * @param piv_vorname [IN] Anzuzeigender Wert für Vornamen 
  * @param piv_nachname [IN] Anzuzeigender Wert für Nachnamen 
  * @param pid_geburtsdatum [IN] Anzuzeigender Wert für Geburtsdatum des Kunden 
  * @param piv_anschluss_strasse [IN] Anzuzeigender Wert für Straßennamen 
  * @param piv_anschluss_hausnr [IN] Anzuzeigender Wert für Hausnummer (inklusive Zusatz und Gebäudeteil) 
  * @param piv_anschluss_plz [IN] Anzuzeigender Wert für Postleitzahl 
  * @param piv_anschluss_ort [IN] Anzuzeigender Wert für Ort 
  * 
  * @return Zeichenkette, in der jeder unbekannte/leere Wert mit einer 
  * doppelten geschweiften Klammer {{...}} repräsentiert wird 
  * 
  * @date 2022-09-22: HAUS_LFD_NR wird nicht mehr dargestellt, auch nicht der neue Auftragseingang. 
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
    ) return varchar2 is 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'fv_kopfdaten';
        trenner         constant varchar2(10) := ' '
                                         || chr(38)
                                         || 'bull; ';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_haus_lfd_nr', pin_haus_lfd_nr);
            pck_format.p_add('piv_kundennummer', piv_kundennummer);
            pck_format.p_add('piv_vorname', piv_vorname);
            pck_format.p_add('piv_nachname', piv_nachname);
            pck_format.p_add('pid_geburtsdatum', pid_geburtsdatum);
            pck_format.p_add('piv_adresse_kompl', piv_adresse_kompl);
            pck_format.p_add('pib_link_siebel_kundenmaske', pib_link_siebel_kundenmaske);
            pck_format.p_add('piv_account_id', piv_account_id);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        return 'KNr: ' 
            -- @ticket FTTH-4470: Link zur Siebel-Kundenmaske auf der Kundennummer
            -- || apex_escape.html(nvl(piv_kundennummer, '-')) 
               ||
            case
                when pib_link_siebel_kundenmaske then
                    fv_link_siebel_kundenmaske(
                        piv_kundennummer => piv_kundennummer,
                        piv_account_id   => piv_account_id,
                        piv_css_class    => 'siebel-kundenmaske',
                        piv_target       => '_blank'
                    )
                else piv_kundennummer
            end
               || trenner
               || apex_escape.html(nullif(piv_vorname, n_a))
               || ' '
               || apex_escape.html(nullif(piv_nachname, n_a))
               || trenner 
               /*
               || apex_escape.html(piv_anschluss_strasse) 
               || ' ' 
               || apex_escape.html(piv_anschluss_hausnr) 
               || trenner 
               || apex_escape.html(piv_anschluss_plz) 
               || ' ' 
               || apex_escape.html(piv_anschluss_ort) 
               */
               ||
            case
                when piv_adresse_kompl is null then
                    '<span class="problem">'
            end
               || coalesce(piv_adresse_kompl, '[ Keine Adressdaten für HausLfdNr '
                                              || pin_haus_lfd_nr
                                              || ' verfügbar ]')
               ||
            case
                when piv_adresse_kompl is null then
                    '</span>'
            end
               || case
            when piv_iban is not null then
                trenner
                || 'IBAN: '
                || apex_escape.html(piv_iban)
        end;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end fv_kopfdaten; 

  /** 
  * Selektiert einen Auftrag anhand der UUID und gibt, sofern dieser Auftrag existiert, 
  * die passenden Kopfdaten zurück 
  * 
  * @param piv_ftth_id ID des gewünschten Datensatzes im Preorderbuffer 
  * 
  * @raise Alle Fehler (außer NO_DATA_FOUND) werden geloggt und geraised 
  */
    function fv_kopfdaten (
        piv_ftth_id in ftth_ws_sync_preorders.id%type
    ) return varchar2 is

        v_haus_lfd_nr     ftth_ws_sync_preorders.houseserialnumber%type;
        v_kundennummer    ftth_ws_sync_preorders.customernumber%type;
        v_vorname         ftth_ws_sync_preorders.customer_name_first%type;
        v_nachname        ftth_ws_sync_preorders.customer_name_last%type;
        v_geburtsdatum    ftth_ws_sync_preorders.customer_birthdate%type;
        v_auftragseingang ftth_ws_sync_preorders.created%type;
        v_iban            ftth_ws_sync_preorders.account_iban%type;
        v_adresse_kompl   pob_adressen.adresse_kompl%type;

    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name   constant logs.routine_name%type := 'fv_kopfdaten';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_ftth_id', piv_ftth_id);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        select
            pob.houseserialnumber,
            pob.customernumber,
            pob.customer_name_first,
            pob.customer_name_last,
            pob.customer_birthdate,
            pob.created,
            pob.account_iban,
            a.adresse_kompl
        into
            v_haus_lfd_nr,
            v_kundennummer,
            v_vorname,
            v_nachname,
            v_geburtsdatum,
            v_auftragseingang,
            v_iban,
            v_adresse_kompl
        from
                 ftth_ws_sync_preorders pob
            join pob_adressen a on ( a.haus_lfd_nr = pob.houseserialnumber )
        where
            pob.id = piv_ftth_id;

        return fv_kopfdaten(
            pin_haus_lfd_nr     => v_haus_lfd_nr,
            piv_kundennummer    => v_kundennummer,
            piv_vorname         => v_vorname,
            piv_nachname        => v_nachname,
            pid_geburtsdatum    => v_geburtsdatum
          /*
          , piv_anschluss_strasse => vr.install_addr_street
          , piv_anschluss_hausnr  => rtrim(vr.install_addr_housenumber 
                                      || ' ' 
                                      || vr.install_addr_addition 
                                      ) -- @ticket 1757 
          , piv_anschluss_plz     => vr.install_addr_zipcode 
          , piv_anschluss_ort     => vr.install_addr_city 
          */,
            piv_adresse_kompl   => v_adresse_kompl,
            piv_auftragseingang => v_auftragseingang,
            piv_iban            => v_iban
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
    end; 

--------------------------------------------------------------------------------

  /** 
  * Parst das JSON eines einzelnen Auftrags (vom Webservice preorder/id) 
  * und gibt die einzelnen Felder an die OUT-Parameter zurück 
  * 
  * @param pic_preorder_json [IN ] JSON-Repräsenation eines Auftrags 
  * 
  * @usage Anzeige von Auftragsdaten in APEX. 
  * Die überladene Variante (parse_preorder_synchronized) macht das Gleiche, holt aber die Daten 
  * stattdessen aus den bestehenden Synchronisationsdaten. 
  * Es ist darauf zu achten, dass die OUT-Signaturen der beiden Prozeduren 
  * sowie die geparsten Felder vollständig miteinander übereinstimmen. 
  *
  * @example
  * Seite 901 im Glascontainer (nicht verlinkt) zeigt die Ergebnisse des Parsings
  * @unittest
  * SELECT * FROM TABLE(ut.run('UT_GLASCONTAINER', a_tags => 'parse'));
  */
    procedure parse_preorder (
        pic_preorder_json    in clob,
        pov_auftragsdaten_gk out t_auftragsdaten_gk
    ) is 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'parse_preorder';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pic_preorder_json',
                             dbms_lob.substr(pic_preorder_json, 1000, 1));
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin 
    -- Wenn der Webservice als solcher nicht aufgerufen werden konnte 
    -- oder der konkrete Auftrag nicht existiert, lautet das JSON 
    -- (Stand 2022-06-15): 
    -- '404 page not found' 

        if trim(pic_preorder_json) is null -- /// like %404% ? 

         then
            return;
        end if;
        with preorder as (
            select
                pic_preorder_json as auftrag_json
            from
                dual
        )
        select distinct -- ///// warum DISTINCT? Seit der Verwendung von NESTED PATH '$.externalOrderReferences[*]' 
                        -- kann es vorkommen, dass dort mehrere Einträge stehen, und dann erhält man TOO_MANY_ROWS,
                        -- so geschehen in der Produktion am 2024-11-05, gemeldet von Alexandra Czupkowski <Alexandra.Czupkowski@netcologne.com>
                        -- Abhilfe: DISTINCT und MAX(...) OVER (...), siehe unten, bei den Feldern die in einem Array stehen
            auftrag.id                                            as uuid,
            auftrag.vkz                                           as vkz,
            auftrag.customernumber                                as kundennummer,
            auftrag.product_templateid                            as promotion,
            auftrag.product_devicecategory                        as router_auswahl,
            auftrag.product_deviceownership                       as router_eigentum -- [ BUY, RENT ] 
            ,
            auftrag.product_ont_provider                          as ont_provider,
            auftrag.product_installationservice                   as installationsservice -- /// "Zusatzoptionen" - muss aufgelöst werden, siehe PreOrder-Buffer-Liste 
            ,
            auftrag.product_houseconnectionprice                  as haus_anschlusspreis,
            auftrag.product_client                                as mandant 
             ---- 
            ,
            auftrag.customer_businessname                         as firmenname,
            auftrag.customer_salutation                           as anrede,
            auftrag.customer_title                                as titel,
            auftrag.customer_name_first                           as vorname,
            auftrag.customer_name_last                            as nachname,
            to_date(auftrag.customer_birthdate, 'YYYY-MM-DD')     as geburtsdatum,
            auftrag.customer_email                                as email,
            auftrag.customer_residentstatus                       as wohndauer,
            auftrag.customer_phone_countrycode                    as laendervorwahl,
            auftrag.customer_phone_areacode                       as vorwahl,
            auftrag.customer_phone_number                         as telefon 
           ---------------------------------------------------- 
           -- "Providerwechsel" ist ein abgeleitetes Feld, daher nehmen wir hier nicht [true|false]: 
            ,
            case
                when providerchg_current_provider is null then
                    0
                else
                    1
            end                                                   as providerwechsel,
            providerchg_current_provider                          as providerw_aktueller_anbieter,
            providerchg_owner_salutation                          as providerw_anmeldung_anrede,
            providerchg_owner_name_last                           as providerw_anmeldung_nachname,
            providerchg_owner_name_first                          as providerw_anmeldung_vorname,
            providerchg_keep_phone_number                         as providerw_nummer_behalten,
            providerchg_phone_countrycode                         as providerw_laendervorwahl,
            providerchg_phone_areacode                            as providerw_vorwahl,
            providerchg_phone_number                              as providerw_telefon 
           ------------------------------------------ 
            ,
            auftrag.account_holder                                as kontoinhaber,
            auftrag.account_sepamandate                           as sepa,
            auftrag.account_iban                                  as iban -- 2023-08-08: HIER keine Maskierung mehr mit fv_iban_maskiert, sondern nur in APEX 
           ------------------------------------------ 
            ,
            auftrag.customer_prev_addr_street                     as kunde_vormals_strasse,
            auftrag.customer_prev_addr_housenumber                as kunde_vormals_hausnr,
            auftrag.customer_prev_addr_addition                   as kunde_vormals_zusatz,
            auftrag.customer_prev_addr_zipcode                    as kunde_vormals_plz,
            auftrag.customer_prev_addr_city                       as kunde_vormals_ort,
            auftrag.customer_prev_addr_country                    as kunde_vormals_land 
            ---- 
            ,
            auftrag.houseserialnumber                             as haus_lfd_nr 
            ---- 
            ,
            auftrag.prop_owner_role                               as gee_rolle,
            auftrag.prop_residential_unit                         as anzahl_we,
            auftrag.landlord_legalform                            as vermieter_rechtsform,
            auftrag.landlord_businessname                         as vermieter_firmenname,
            auftrag.landlord_salutation                           as vermieter_anrede,
            auftrag.landlord_title                                as vermieter_titel,
            auftrag.landlord_name_first                           as vermieter_vorname,
            auftrag.landlord_name_last                            as vermieter_nachname,
            auftrag.landlord_addr_street                          as vermieter_strasse,
            auftrag.landlord_addr_housenumber                     as vermieter_hausnr,
            auftrag.landlord_addr_zipcode                         as vermieter_plz,
            auftrag.landlord_addr_city                            as vermieter_ort,
            auftrag.landlord_addr_addition                        as vermieter_zusatz,
            auftrag.landlord_addr_country                         as vermieter_land,
            auftrag.landlord_email                                as vermieter_email,
            auftrag.landlord_phone_countrycode                    as vermieter_laendervorwahl,
            auftrag.landlord_phone_areacode                       as vermieter_vorwahl,
            auftrag.landlord_phone_number                         as vermieter_telefon,
            auftrag.landlord_agreed                               as vermieter_einverstaendnis 
           ------------------------------------- 
            ,
            auftrag.summ_precontractinformation                   as bestaetigung_vzf,
            auftrag.summ_generaltermsandconditions                as zustimmung_agb,
            auftrag.summ_waiverightofrevocation                   as zustimmung_widerruf,
            auftrag.summ_emailmarketing                           as opt_in_email,
            auftrag.summ_phonemarketing                           as opt_in_telefon,
            auftrag.summ_smsmmsmarketing                          as opt_in_sms_mms,
            auftrag.summ_mailmarketing                            as opt_in_post,
            auftrag.summ_ordersummaryfileid                       as vertragszusammenfassung 
           ---- 
            ,
            auftrag.state                                         as status 
           ---- 
            ,
            auftrag.customer_upd_email                            as customer_upd_email,
            auftrag.is_new_customer                               as is_new_customer,
            fd_json_timestamp(auftrag.created)                    as created,
            fd_json_timestamp(auftrag.last_modified)              as last_modified,
            auftrag.version                                       as version,
            auftrag.changed_by                                    as changed_by,
            auftrag.process_lock                                  as process_lock,
            fd_json_timestamp(auftrag.process_lock_last_modified) as process_lock_last_modified 
            ---- neu 2023-06-14: 
            ,
            auftrag.cancelled_by,
            auftrag.cancel_reason,
            fd_json_timestamp(auftrag.cancel_date)                as cancel_date,
            auftrag.siebel_order_number,
            auftrag.siebel_order_rowid,
            auftrag.siebel_ready,
            auftrag.service_plus_email,
            auftrag.wholebuy_partner,
            auftrag.manual_transfer,
            auftrag.technology 
             -- neu 2024-08-21:
             -- @ticket FTTH-3727
             -- @bugfix 2024-12-03: trotz DISTINCT hierbei immer noch TOO_MANY_ROWS, 
             -- weil die externalOrderReferences leider in Arrays stehen.
             -- Abhilfe: MAX(...) OVER(...)
            ,
            max(auftrag.connectivity_id)
            over(
                order by
                    auftrag.connectivity_id
            )                                                     as connectivity_id,
            max(auftrag.rt_contact_data_ticket_id)
            over(
                order by
                    auftrag.rt_contact_data_ticket_id
            )                                                     as rt_contact_data_ticket_id,
            auftrag.landlord_information_required,
            auftrag.customer_upd_phone_countrycode,
            auftrag.customer_upd_phone_areacode,
            auftrag.customer_upd_phone_number,
            auftrag.update_customer_in_siebel,
            auftrag.home_id,
            auftrag.account_id,
            to_date(auftrag.availability_date, 'YYYY-MM-DD'),
            customer_status,
            router_shipping 
            ---------------------
            ,
            business_unit,
            sub_customer_number,
            created_by
            ---------------------
            ,
            cpc_siebel_rowid,
            cpc_salutation,
            cpc_first_name,
            cpc_last_name,
            cpc_email,
            cpc_landline_countrycode,
            cpc_landline_areacode,
            cpc_landline_number,
            cpc_mobile_countrycode,
            cpc_mobile_areacode,
            cpc_mobile_number
            ---------------------
            ,
            tcp_siebel_rowid,
            tcp_salutation,
            tcp_first_name,
            tcp_last_name,
            tcp_email,
            tcp_landline_countrycode,
            tcp_landline_areacode,
            tcp_landline_number,
            tcp_mobile_countrycode,
            tcp_mobile_areacode,
            tcp_mobile_number
            ---------------------
            ,
            cfi_siebel_rowid,
            cfi_salutation,
            cfi_first_name,
            cfi_last_name,
            cfi_email,
            cfi_landline_countrycode,
            cfi_landline_areacode,
            cfi_landline_number,
            cfi_mobile_countrycode,
            cfi_mobile_areacode,
            cfi_mobile_number
        into
            pov_auftragsdaten_gk.uuid,
            pov_auftragsdaten_gk.vkz,
            pov_auftragsdaten_gk.kundennummer,
            pov_auftragsdaten_gk.promotion,
            pov_auftragsdaten_gk.router_auswahl,
            pov_auftragsdaten_gk.router_eigentum,
            pov_auftragsdaten_gk.ont_provider,
            pov_auftragsdaten_gk.installationsservice,
            pov_auftragsdaten_gk.haus_anschlusspreis,
            pov_auftragsdaten_gk.mandant,
            pov_auftragsdaten_gk.firmenname,
            pov_auftragsdaten_gk.anrede,
            pov_auftragsdaten_gk.titel,
            pov_auftragsdaten_gk.vorname,
            pov_auftragsdaten_gk.nachname,
            pov_auftragsdaten_gk.geburtsdatum,
            pov_auftragsdaten_gk.email,
            pov_auftragsdaten_gk.wohndauer,
            pov_auftragsdaten_gk.laendervorwahl,
            pov_auftragsdaten_gk.vorwahl,
            pov_auftragsdaten_gk.telefon,
            pov_auftragsdaten_gk.providerwechsel,
            pov_auftragsdaten_gk.providerw_aktueller_anbieter,
            pov_auftragsdaten_gk.providerw_anmeldung_anrede,
            pov_auftragsdaten_gk.providerw_anmeldung_nachname,
            pov_auftragsdaten_gk.providerw_anmeldung_vorname,
            pov_auftragsdaten_gk.providerw_nummer_behalten,
            pov_auftragsdaten_gk.providerw_laendervorwahl,
            pov_auftragsdaten_gk.providerw_vorwahl,
            pov_auftragsdaten_gk.providerw_telefon,
            pov_auftragsdaten_gk.kontoinhaber,
            pov_auftragsdaten_gk.sepa,
            pov_auftragsdaten_gk.iban,
            pov_auftragsdaten_gk.voradresse_strasse,
            pov_auftragsdaten_gk.voradresse_hausnr,
            pov_auftragsdaten_gk.voradresse_zusatz,
            pov_auftragsdaten_gk.voradresse_plz,
            pov_auftragsdaten_gk.voradresse_ort,
            pov_auftragsdaten_gk.voradresse_land,
            pov_auftragsdaten_gk.haus_lfd_nr,
            pov_auftragsdaten_gk.gee_rolle,
            pov_auftragsdaten_gk.anzahl_we,
            pov_auftragsdaten_gk.vermieter_rechtsform,
            pov_auftragsdaten_gk.vermieter_firmenname,
            pov_auftragsdaten_gk.vermieter_anrede,
            pov_auftragsdaten_gk.vermieter_titel,
            pov_auftragsdaten_gk.vermieter_vorname,
            pov_auftragsdaten_gk.vermieter_nachname,
            pov_auftragsdaten_gk.vermieter_strasse,
            pov_auftragsdaten_gk.vermieter_hausnr,
            pov_auftragsdaten_gk.vermieter_plz,
            pov_auftragsdaten_gk.vermieter_ort,
            pov_auftragsdaten_gk.vermieter_zusatz,
            pov_auftragsdaten_gk.vermieter_land,
            pov_auftragsdaten_gk.vermieter_email,
            pov_auftragsdaten_gk.vermieter_laendervorwahl,
            pov_auftragsdaten_gk.vermieter_vorwahl,
            pov_auftragsdaten_gk.vermieter_telefon,
            pov_auftragsdaten_gk.vermieter_einverstaendnis,
            pov_auftragsdaten_gk.bestaetigung_vzf,
            pov_auftragsdaten_gk.zustimmung_agb,
            pov_auftragsdaten_gk.zustimmung_widerruf,
            pov_auftragsdaten_gk.opt_in_email,
            pov_auftragsdaten_gk.opt_in_telefon,
            pov_auftragsdaten_gk.opt_in_sms_mms,
            pov_auftragsdaten_gk.opt_in_post,
            pov_auftragsdaten_gk.vertragszusammenfassung,
            pov_auftragsdaten_gk.status,
            pov_auftragsdaten_gk.customer_upd_email,
            pov_auftragsdaten_gk.is_new_customer,
            pov_auftragsdaten_gk.created,
            pov_auftragsdaten_gk.last_modified,
            pov_auftragsdaten_gk.version,
            pov_auftragsdaten_gk.changed_by,
            pov_auftragsdaten_gk.process_lock,
            pov_auftragsdaten_gk.process_lock_last_modified,
            pov_auftragsdaten_gk.storno_username,
            pov_auftragsdaten_gk.storno_grund,
            pov_auftragsdaten_gk.storno_datum,
            pov_auftragsdaten_gk.siebel_order_number,
            pov_auftragsdaten_gk.siebel_order_rowid,
            pov_auftragsdaten_gk.siebel_ready,
            pov_auftragsdaten_gk.service_plus_email,
            pov_auftragsdaten_gk.wholebuy_partner,
            pov_auftragsdaten_gk.manual_transfer,
            pov_auftragsdaten_gk.technology,
            pov_auftragsdaten_gk.connectivity_id,
            pov_auftragsdaten_gk.rt_contact_data_ticket_id,
            pov_auftragsdaten_gk.landlord_information_required,
            pov_auftragsdaten_gk.customer_upd_phone_countrycode,
            pov_auftragsdaten_gk.customer_upd_phone_areacode,
            pov_auftragsdaten_gk.customer_upd_phone_number,
            pov_auftragsdaten_gk.update_customer_in_siebel,
            pov_auftragsdaten_gk.home_id,
            pov_auftragsdaten_gk.account_id,
            pov_auftragsdaten_gk.availability_date,
            pov_auftragsdaten_gk.customer_status,
            pov_auftragsdaten_gk.router_shipping,
            --------------
            pov_auftragsdaten_gk.business_unit,
            pov_auftragsdaten_gk.sub_customer_number,
            pov_auftragsdaten_gk.created_by,
            --------------
            pov_auftragsdaten_gk.cpc_siebel_rowid,
            pov_auftragsdaten_gk.cpc_salutation,
            --------------
            pov_auftragsdaten_gk.cpc_first_name,
            pov_auftragsdaten_gk.cpc_last_name,
            pov_auftragsdaten_gk.cpc_email,
            pov_auftragsdaten_gk.cpc_landline_countrycode,
            pov_auftragsdaten_gk.cpc_landline_areacode,
            pov_auftragsdaten_gk.cpc_landline_number,
            pov_auftragsdaten_gk.cpc_mobile_countrycode,
            pov_auftragsdaten_gk.cpc_mobile_areacode,
            pov_auftragsdaten_gk.cpc_mobile_number,
            --------------
            pov_auftragsdaten_gk.tcp_siebel_rowid,
            pov_auftragsdaten_gk.tcp_salutation,
            pov_auftragsdaten_gk.tcp_first_name,
            pov_auftragsdaten_gk.tcp_last_name,
            pov_auftragsdaten_gk.tcp_email,
            pov_auftragsdaten_gk.tcp_landline_countrycode,
            pov_auftragsdaten_gk.tcp_landline_areacode,
            pov_auftragsdaten_gk.tcp_landline_number,
            pov_auftragsdaten_gk.tcp_mobile_countrycode,
            pov_auftragsdaten_gk.tcp_mobile_areacode,
            pov_auftragsdaten_gk.tcp_mobile_number,
            --------------
            pov_auftragsdaten_gk.cfi_siebel_rowid,
            pov_auftragsdaten_gk.cfi_salutation,
            pov_auftragsdaten_gk.cfi_first_name,
            pov_auftragsdaten_gk.cfi_last_name,
            pov_auftragsdaten_gk.cfi_email,
            pov_auftragsdaten_gk.cfi_landline_countrycode,
            pov_auftragsdaten_gk.cfi_landline_areacode,
            pov_auftragsdaten_gk.cfi_landline_number,
            pov_auftragsdaten_gk.cfi_mobile_countrycode,
            pov_auftragsdaten_gk.cfi_mobile_areacode,
            pov_auftragsdaten_gk.cfi_mobile_number
        from
            preorder,
            json_table ( auftrag_json, '$'
                    columns ( 
                    -- 2023-03: Der Beautifier im SQL Developer hatte die JSON-Pfade auf klein.schreibung.umgestellt,  
                    -- daher benutzen nun alle PATH-Ausdrücke Anführungszeichen 
                        id varchar2 ( 50 ) path "id" -- //// konsolidieren: 50/100? 
                        ,
                        vkz varchar2 ( 50 ) path "vkz",
                        customernumber varchar2 ( 50 ) path "customerNumber" -- 2023-02-28 @ticket FTTH-1836 
                        ,
                        product_templateid varchar2 ( 50 ) path "product"."templateId",
                        product_devicecategory varchar2 ( 50 ) path "product"."deviceCategory",
                        product_deviceownership varchar2 ( 50 ) path "product"."deviceOwnership",
                        product_ont_provider varchar2 ( 30 ) path "product"."ontProvider",
                        product_installationservice varchar2 ( 50 ) path "product"."installationService",
                        product_houseconnectionprice number path "product"."houseConnectionPrice",
                        product_client varchar2 ( 2 ) path "product"."client",
                        customer_businessname varchar2 ( 100 ) path "customer"."businessName",
                        customer_salutation varchar2 ( 100 ) path "customer"."salutation",
                        customer_title varchar2 ( 100 ) path "customer"."title",
                        customer_name_first varchar2 ( 100 ) path "customer"."name"."first",
                        customer_name_last varchar2 ( 100 ) path "customer"."name"."last",
                        customer_birthdate varchar2 ( 100 ) path "customer"."birthDate",
                        customer_email varchar2 ( 100 ) path "customer"."email",
                        customer_residentstatus varchar2 ( 100 ) path "customer"."residentStatus" 
                        ----                                                  
                        ,
                        customer_prev_addr_street varchar2 ( 100 ) path "customer"."previousAddress"."street",
                        customer_prev_addr_housenumber varchar2 ( 100 ) path "customer"."previousAddress"."houseNumber",
                        customer_prev_addr_addition varchar2 ( 100 ) path "customer"."previousAddress"."postalAddition",
                        customer_prev_addr_zipcode varchar2 ( 100 ) path "customer"."previousAddress"."zipCode",
                        customer_prev_addr_city varchar2 ( 100 ) path "customer"."previousAddress"."city",
                        customer_prev_addr_country varchar2 ( 100 ) path "customer"."previousAddress"."country" 
                        ----                                                  
                        ,
                        customer_phone_countrycode varchar2 ( 5 ) path "customer"."phoneNumber"."countryCode",
                        customer_phone_areacode varchar2 ( 10 ) path "customer"."phoneNumber"."areaCode",
                        customer_phone_number varchar2 ( 50 ) path "customer"."phoneNumber"."number",
                        customer_password varchar2 ( 100 ) path "customer"."password" 
                        ----                                                  
                        ,
                        install_addr_street varchar2 ( 100 ) path "installation"."address"."street",
                        install_addr_housenumber varchar2 ( 100 ) path "installation"."address"."houseNumber",
                        install_addr_zipcode varchar2 ( 100 ) path "installation"."address"."zipCode",
                        install_addr_city varchar2 ( 100 ) path "installation"."address"."city",
                        install_addr_addition varchar2 ( 100 ) path "installation"."address.postalAddition",
                        install_addr_country varchar2 ( 100 ) path "installation"."address.country",
                        houseserialnumber varchar2 ( 50 ) path "installation"."houseSerialNumber",
                        providerchg_current_provider varchar2 ( 100 ) path "providerChange"."currentProvider"
                        ----                                                  
                        ,
                        providerchg_owner_name_last varchar2 ( 100 ) path "providerChange"."contractOwnerName"."last",
                        providerchg_owner_name_first varchar2 ( 100 ) path "providerChange"."contractOwnerName"."first",
                        providerchg_phone_number varchar2 ( 100 ) path "providerChange"."landlinePhoneNumber"."number",
                        providerchg_phone_areacode varchar2 ( 100 ) path "providerChange"."landlinePhoneNumber"."areaCode",
                        providerchg_phone_countrycode varchar2 ( 100 ) path "providerChange"."landlinePhoneNumber"."countryCode",
                        providerchg_owner_salutation varchar2 ( 100 ) path "providerChange"."contractOwnerSalutation",
                        providerchg_keep_phone_number varchar2 ( 100 ) path "providerChange"."keepCurrentLandlineNumber" 
                        ----                                                  
                        ,
                        account_holder varchar2 ( 100 ) path "accountDetails"."accountHolder",
                        account_sepamandate varchar2 ( 100 ) path "accountDetails"."sepaMandate",
                        account_iban varchar2 ( 100 ) path "accountDetails"."iban" 
                        ----                                                  
                        ,
                        prop_owner_role varchar2 ( 50 ) path "propertyOwnerDeclaration"."propertyOwnerRole",
                        prop_residential_unit varchar2 ( 50 ) path "propertyOwnerDeclaration"."residentialUnit",
                        landlord_legalform varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlord"."legalForm",
                        landlord_businessname varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlord"."businessOrName",
                        landlord_salutation varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlord"."salutation",
                        landlord_title varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlord"."title",
                        landlord_name_first varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlord"."name"."first",
                        landlord_name_last varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlord"."name"."last",
                        landlord_addr_street varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlord"."address"."street",
                        landlord_addr_housenumber varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlord"."address"."houseNumber",
                        landlord_addr_zipcode varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlord"."address"."zipCode" -- @date 2024-07-17 war falsch: "zipcode"
                        ,
                        landlord_addr_city varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlord"."address"."city",
                        landlord_addr_addition varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlord"."address"."postalAddition",
                        landlord_addr_country varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlord"."address"."country",
                        landlord_email varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlord"."email",
                        landlord_phone_countrycode varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlord"."phoneNumber.countryCode"
                        ,
                        landlord_phone_areacode varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlord"."phoneNumber"."areaCode",
                        landlord_phone_number varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlord"."phoneNumber"."number",
                        landlord_agreed varchar2 ( 50 ) path "propertyOwnerDeclaration"."landlordAgreedToBeContacted" -- ///n/a 
                        ,
                        summ_precontractinformation varchar2 ( 10 ) path "summary"."preContractualInformation",
                        summ_generaltermsandconditions varchar2 ( 10 ) path "summary"."generalTermsAndConditions",
                        summ_waiverightofrevocation varchar2 ( 10 ) path "summary"."waiveRightOfRevocation",
                        summ_emailmarketing varchar2 ( 10 ) path "summary"."emailMarketing",
                        summ_phonemarketing varchar2 ( 10 ) path "summary"."phoneMarketing",
                        summ_smsmmsmarketing varchar2 ( 10 ) path "summary"."smsMmsMarketing",
                        summ_mailmarketing varchar2 ( 10 ) path "summary"."mailMarketing",
                        summ_ordersummaryfileid varchar2 ( 50 ) path "summary"."orderSummaryFileId" 
                        ---- 
                        ,
                        state varchar2 ( 50 ) path "state" 
                         ---- 
                         -- 2023-06-14: Neue Felder im Falle einer Stornierung 
                        ,
                        cancelled_by varchar2 ( 100 ) path "cancellation"."cancelledBy" -- @ticket FTTH-1874 
                        ,
                        cancel_reason varchar2 ( 100 ) path "cancellation"."reason"      -- @ticket FTTH-1874 
                        ,
                        cancel_date varchar2 ( 100 ) path "cancellation"."created"     -- @ticket FTTH-1874 
                         ---- 
                        ,
                        customer_upd_email varchar2 ( 100 ) path "customerUpdate"."email" -- dieses Feld bestimmt den Kundenstatus!  -- ///// VARCHAR2(300)???
                        ,
                        is_new_customer varchar2 ( 5 ) path "isNewCustomer" 
                        ---- 
                        ,
                        created varchar2 ( 100 ) path "created",
                        last_modified varchar2 ( 100 ) path "lastModified",
                        version number path "version",
                        changed_by varchar2 ( 100 ) path "changedBy" -- neu 2023-06-20 
                        ,
                        process_lock varchar2 ( 5 ) path "processLock",
                        process_lock_last_modified varchar2 ( 100 ) path "processLockLastModified" -- z.B. 2022-08-31T13:29:50.869150859 
                        ,
                        siebel_order_number path "siebelOrderNumber"       -- @ticket FTTH-2162 
                        ,
                        siebel_order_rowid path "siebelOrderRowId"        -- @ticket FTTH-2162 
                        ,
                        siebel_ready path "siebelReady"             -- @ticket FTTH-2521 
                        ,
                        service_plus_email varchar2 ( 300 ) path "servicePlusEmail"        -- @FTTH-5002
                        -- neu 2023-11-30:
                        ,
                        wholebuy_partner varchar2 ( 30 ) path "wholebuy"."partner"      -- @ticket FTTH-2901 -- zB. 'TCOM' 
                                                                                -- Änderung der Schnittstelle am 2023-03-28, war: "wholebuyPartner"
                        ,
                        manual_transfer varchar2 ( 5 ) path "manualTransfer"          -- @ticket FTTH-2996 
                        ,
                        technology varchar2 ( 50 ) path "technology"              -- @ticket FTTH-3747
                        -- neu 2024-08-21
                        ,
                        nested path '$.externalOrderReferences[*]' -- @ticket FTTH-4442
                            columns (
                                connectivity_id varchar2 ( 100 ) path '$.connectivityId'        -- @ticket FTTH-3727, @ticket FTH-4403
                                ,
                                rt_contact_data_ticket_id varchar2 ( 100 ) path '$.rtContactDataTicketId' -- @ticket FTTH-3727
                            )
                        -- @ticket FTTH-3727:
                            ,
                        landlord_information_required varchar2 ( 5 ) path "wholebuy"."landlordInformationRequired"
                        -- neu 2024-08-23 @ticket FTTH-3711:
                        ,
                        customer_upd_phone_countrycode varchar2 ( 5 ) path "customerUpdate"."phoneNumber"."countryCode",
                        customer_upd_phone_areacode varchar2 ( 5 ) path "customerUpdate"."phoneNumber"."areaCode",
                        customer_upd_phone_number varchar2 ( 15 ) path "customerUpdate"."phoneNumber"."number",
                        update_customer_in_siebel varchar2 ( 5 ) path "customerUpdate"."updateCustomerInSiebel",
                        home_id varchar2 ( 50 ) path "homeId"                  -- @ticket FTTH-4134
                        ,
                        account_id varchar2 ( 128 ) path "accountId"               -- @ticket FTTH-4470
                        ,
                        availability_date varchar2 ( 100 ) path "availabilityDate"        -- @ticket FTTH-3880
                        ,
                        customer_status varchar2 ( 4000 char ) path "customerStatus"         -- @ticket FTTH-5772
                        ,
                        router_shipping varchar2 ( 4000 char ) path "routerShipping"         -- @ticket FTTH-6231
                        ---------------
                        ,
                        business_unit varchar2 ( 4000 char ) path "businessUnit",
                        sub_customer_number varchar2 ( 4000 char ) path "subCustomerNumber",
                        created_by varchar2 ( 4000 char ) path "createdBy"                
                        ---------------
                        ,
                        cpc_siebel_rowid varchar2 ( 4000 char ) path '$.contactPersons[*]?(@.type=="CONTACT_PERSON_CUSTOMER").siebelRowId'
                        ,
                        cpc_salutation varchar2 ( 4000 char ) path '$.contactPersons[*]?(@.type=="CONTACT_PERSON_CUSTOMER").salutation'
                        ,
                        cpc_first_name varchar2 ( 4000 char ) path '$.contactPersons[*]?(@.type=="CONTACT_PERSON_CUSTOMER").name.first'
                        ,
                        cpc_last_name varchar2 ( 4000 char ) path '$.contactPersons[*]?(@.type=="CONTACT_PERSON_CUSTOMER").name.last'
                        ,
                        cpc_email varchar2 ( 4000 char ) path '$.contactPersons[*]?(@.type=="CONTACT_PERSON_CUSTOMER").email',
                        cpc_landline_countrycode varchar2 ( 4000 char ) path '$.contactPersons[*]?(@.type=="CONTACT_PERSON_CUSTOMER").landlinePhoneNumber.countryCode'
                        ,
                        cpc_landline_areacode varchar2 ( 4000 char ) path '$.contactPersons[*]?(@.type=="CONTACT_PERSON_CUSTOMER").landlinePhoneNumber.areaCode'
                        ,
                        cpc_landline_number varchar2 ( 4000 char ) path '$.contactPersons[*]?(@.type=="CONTACT_PERSON_CUSTOMER").landlinePhoneNumber.number'
                        ,
                        cpc_mobile_countrycode varchar2 ( 4000 char ) path '$.contactPersons[*]?(@.type=="CONTACT_PERSON_CUSTOMER").mobilePhoneNumber.countryCode'
                        ,
                        cpc_mobile_areacode varchar2 ( 4000 char ) path '$.contactPersons[*]?(@.type=="CONTACT_PERSON_CUSTOMER").mobilePhoneNumber.areaCode'
                        ,
                        cpc_mobile_number varchar2 ( 4000 char ) path '$.contactPersons[*]?(@.type=="CONTACT_PERSON_CUSTOMER").mobilePhoneNumber.number'
                        ---------------
                        ,
                        tcp_siebel_rowid varchar2 ( 4000 char ) path '$.contactPersons[*]?(@.type=="TECHNICAL_CONTACT_PERSON").siebelRowId'
                        ,
                        tcp_salutation varchar2 ( 4000 char ) path '$.contactPersons[*]?(@.type=="TECHNICAL_CONTACT_PERSON").salutation'
                        ,
                        tcp_first_name varchar2 ( 4000 char ) path '$.contactPersons[*]?(@.type=="TECHNICAL_CONTACT_PERSON").name.first'
                        ,
                        tcp_last_name varchar2 ( 4000 char ) path '$.contactPersons[*]?(@.type=="TECHNICAL_CONTACT_PERSON").name.last'
                        ,
                        tcp_email varchar2 ( 4000 char ) path '$.contactPersons[*]?(@.type=="TECHNICAL_CONTACT_PERSON").email',
                        tcp_landline_countrycode varchar2 ( 4000 char ) path '$.contactPersons[*]?(@.type=="TECHNICAL_CONTACT_PERSON").landlinePhoneNumber.countryCode'
                        ,
                        tcp_landline_areacode varchar2 ( 4000 char ) path '$.contactPersons[*]?(@.type=="TECHNICAL_CONTACT_PERSON").landlinePhoneNumber.areaCode'
                        ,
                        tcp_landline_number varchar2 ( 4000 char ) path '$.contactPersons[*]?(@.type=="TECHNICAL_CONTACT_PERSON").landlinePhoneNumber.number'
                        ,
                        tcp_mobile_countrycode varchar2 ( 4000 char ) path '$.contactPersons[*]?(@.type=="TECHNICAL_CONTACT_PERSON").mobilePhoneNumber.countryCode'
                        ,
                        tcp_mobile_areacode varchar2 ( 4000 char ) path '$.contactPersons[*]?(@.type=="TECHNICAL_CONTACT_PERSON").mobilePhoneNumber.areaCode'
                        ,
                        tcp_mobile_number varchar2 ( 4000 char ) path '$.contactPersons[*]?(@.type=="TECHNICAL_CONTACT_PERSON").mobilePhoneNumber.number'
                        ---------------
                        ,
                        cfi_siebel_rowid varchar2 ( 4000 char ) path '$.contactPersons[*]?(@.type=="CONTACT_FOR_INSTALLATION").siebelRowId'
                        ,
                        cfi_salutation varchar2 ( 4000 char ) path '$.contactPersons[*]?(@.type=="CONTACT_FOR_INSTALLATION").salutation'
                        ,
                        cfi_first_name varchar2 ( 4000 char ) path '$.contactPersons[*]?(@.type=="CONTACT_FOR_INSTALLATION").name.first'
                        ,
                        cfi_last_name varchar2 ( 4000 char ) path '$.contactPersons[*]?(@.type=="CONTACT_FOR_INSTALLATION").name.last'
                        ,
                        cfi_email varchar2 ( 4000 char ) path '$.contactPersons[*]?(@.type=="CONTACT_FOR_INSTALLATION").email',
                        cfi_landline_countrycode varchar2 ( 4000 char ) path '$.contactPersons[*]?(@.type=="CONTACT_FOR_INSTALLATION").landlinePhoneNumber.countryCode'
                        ,
                        cfi_landline_areacode varchar2 ( 4000 char ) path '$.contactPersons[*]?(@.type=="CONTACT_FOR_INSTALLATION").landlinePhoneNumber.areaCode'
                        ,
                        cfi_landline_number varchar2 ( 4000 char ) path '$.contactPersons[*]?(@.type=="CONTACT_FOR_INSTALLATION").landlinePhoneNumber.number'
                        ,
                        cfi_mobile_countrycode varchar2 ( 4000 char ) path '$.contactPersons[*]?(@.type=="CONTACT_FOR_INSTALLATION").mobilePhoneNumber.countryCode'
                        ,
                        cfi_mobile_areacode varchar2 ( 4000 char ) path '$.contactPersons[*]?(@.type=="CONTACT_FOR_INSTALLATION").mobilePhoneNumber.areaCode'
                        ,
                        cfi_mobile_number varchar2 ( 4000 char ) path '$.contactPersons[*]?(@.type=="CONTACT_FOR_INSTALLATION").mobilePhoneNumber.number'
                    )
                )
            as auftrag;

    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end parse_preorder; 

  /** 
  * Nimmt einen Auftrag entgegen (alle Felder sollten gefüllt sein!) und schreibt 
  * ihn in die Tabelle FTTH_WS_SYNC_PREORDERS, so dass der zuletzt nächtlich synchronisierte 
  * Datensatz anschließend diesem aktuellen Zustand entspricht 
  * 
  * @param pir_preorder [IN OUT] Auftragsdaten, mit denen die SYNC-Tabelle 
  * aktualisiert werden soll 
  * 
  * @usage Die Prozedur führt keine Validierung durch! 
  * Der Datensatz wird nicht als Update zum Webservice gesendet, denn 
  * der Sinn dieser Synchronisation ist, dass im Fall eines späteren 
  * Ausfalls des Webservices wenigstens die aktuellst möglichen Daten 
  * geholt werden, wenn der Auftrag im Laufe des Tages erneut angezeigt werden soll. 
  * 
  * 
  * @return Im Erfolgsfall steht in pir_preorder.APEX$ROW_SYNC_TIMESTAMP die aktuelle Uhrzeit 
  * 
  * @raise Alle Fehler werden geworfen, kein Logging. 
  */
    procedure p_auftragsdaten_synchronisieren (
        pir_preorder in out ftth_ws_sync_preorders%rowtype
    ) is 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'p_auftragsdaten_synchronisieren';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pir_preorder.id', pir_preorder.id);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        if pir_preorder.id is null then
            raise_application_error(-20000, 'Synchronisierung fehlgeschlagen: UUID fehlt');
        end if; 
    -- ///@weiter: auf Pflichtfelder prüfen, sonstige Validierungen ausführen 
    -- Erkennungsmerkmal, dass diese Zeile zuletzt nicht nächtlich, sondern 
    -- durch den Aufruf im APEX Glascontainer synchronisiert wurde: 
        pir_preorder.apex$sync_step_static_id := $$plsql_unit || ' (MRG)'; -- 'PCK_GLASCONTAINER (MRG)' 
    -- Die Spalte ist typischerweise leer, da in APEX keine "Steps" für die Synchronisierung eingerichtet sind, 
    -- und falls doch, hätten diese positive IDs 
    -- In jedem Fall die Synchronisierungs-Uhrzeit eintragen: 
        pir_preorder.apex$row_sync_timestamp := systimestamp; 
    -- Prüfen, ob es den Auftrag bereits gibt und wenn ja, dann updaten. 
    -- Ansonsten: einen neuen Datensatz einfügen. 
    -- Dieses Skript erzeugt die Felder-Liste: 
    -- SELECT ', dest.' || column_name || ' = pir_preorder.' || column_name 
    -- FROM cols 
    -- WHERE table_name = 'FTTH_WS_SYNC_PREORDERS' 
    -- AND column_name <> 'ID' 
    -- ORDER BY column_id; 
        merge into ftth_ws_sync_preorders dest
        using (
            select
                null
            from
                dual
        ) on ( dest.id = pir_preorder.id )
        when matched then update
        set dest.templateid = pir_preorder.templateid,
            dest.devicecategory = pir_preorder.devicecategory,
            dest.deviceownership = pir_preorder.deviceownership,
            dest.installationservice = pir_preorder.installationservice,
            dest.houseconnectionprice = pir_preorder.houseconnectionprice,
            dest.summ_ordersummaryfileid = pir_preorder.summ_ordersummaryfileid,
            dest.state = pir_preorder.state,
            dest.vkz = pir_preorder.vkz,
            dest.client = pir_preorder.client,
            dest.customernumber = pir_preorder.customernumber,
            dest.customer_businessname = pir_preorder.customer_businessname,
            dest.customer_salutation = pir_preorder.customer_salutation,
            dest.customer_title = pir_preorder.customer_title,
            dest.customer_name_first = pir_preorder.customer_name_first,
            dest.customer_name_last = pir_preorder.customer_name_last,
            dest.customer_birthdate = pir_preorder.customer_birthdate,
            dest.customer_email = pir_preorder.customer_email,
            dest.customer_phone_countrycode = pir_preorder.customer_phone_countrycode,
            dest.customer_phone_areacode = pir_preorder.customer_phone_areacode,
            dest.customer_phone_number = pir_preorder.customer_phone_number,
            dest.houseserialnumber = pir_preorder.houseserialnumber,
            dest.customer_residentstatus = pir_preorder.customer_residentstatus,
            dest.install_addr_country = pir_preorder.install_addr_country,
            dest.install_addr_zipcode = pir_preorder.install_addr_zipcode,
            dest.install_addr_city = pir_preorder.install_addr_city,
            dest.install_addr_street = pir_preorder.install_addr_street,
            dest.install_addr_housenumber = pir_preorder.install_addr_housenumber,
            dest.install_addr_addition = pir_preorder.install_addr_addition,
            dest.providerchg_current_provider = pir_preorder.providerchg_current_provider,
            dest.providerchg_keep_phone_number = pir_preorder.providerchg_keep_phone_number,
            dest.providerchg_phone_countrycode = pir_preorder.providerchg_phone_countrycode,
            dest.providerchg_phone_areacode = pir_preorder.providerchg_phone_areacode,
            dest.providerchg_phone_number = pir_preorder.providerchg_phone_number,
            dest.providerchg_contract_cancelled = pir_preorder.providerchg_contract_cancelled,
            dest.providerchg_cancellation_date = pir_preorder.providerchg_cancellation_date,
            dest.providerchg_owner_salutation = pir_preorder.providerchg_owner_salutation,
            dest.providerchg_owner_name_first = pir_preorder.providerchg_owner_name_first,
            dest.providerchg_owner_name_last = pir_preorder.providerchg_owner_name_last,
            dest.account_sepamandate = pir_preorder.account_sepamandate,
            dest.account_holder = pir_preorder.account_holder,
            dest.landlord_name_last = pir_preorder.landlord_name_last,
            dest.account_iban = pir_preorder.account_iban,
            dest.landlord_name_first = pir_preorder.landlord_name_first,
            dest.landlord_email = pir_preorder.landlord_email,
            dest.landlord_title = pir_preorder.landlord_title,
            dest.landlord_addr_city = pir_preorder.landlord_addr_city,
            dest.landlord_addr_street = pir_preorder.landlord_addr_street,
            dest.landlord_addr_country = pir_preorder.landlord_addr_country,
            dest.landlord_addr_zipcode = pir_preorder.landlord_addr_zipcode,
            dest.landlord_addr_housenumber = pir_preorder.landlord_addr_housenumber,
            dest.landlord_addr_addition = pir_preorder.landlord_addr_addition,
            dest.landlord_legalform = pir_preorder.landlord_legalform,
            dest.landlord_salutation = pir_preorder.landlord_salutation,
            dest.landlord_phone_number = pir_preorder.landlord_phone_number,
            dest.landlord_phone_areacode = pir_preorder.landlord_phone_areacode,
            dest.landlord_phone_countrycode = pir_preorder.landlord_phone_countrycode,
            dest.landlord_businessorname = pir_preorder.landlord_businessorname,
            dest.prop_residential_unit = pir_preorder.prop_residential_unit,
            dest.prop_owner_role = pir_preorder.prop_owner_role,
            dest.landlord_agreed = pir_preorder.landlord_agreed,
            dest.summ_precontractinformation = pir_preorder.summ_precontractinformation,
            dest.summ_generaltermsandconditions = pir_preorder.summ_generaltermsandconditions,
            dest.summ_waiverightofrevocation = pir_preorder.summ_waiverightofrevocation,
            dest.summ_emailmarketing = pir_preorder.summ_emailmarketing,
            dest.summ_phonemarketing = pir_preorder.summ_phonemarketing,
            dest.summ_smsmmsmarketing = pir_preorder.summ_smsmmsmarketing,
            dest.summ_mailmarketing = pir_preorder.summ_mailmarketing,
            dest.customer_prev_addr_street = pir_preorder.customer_prev_addr_street,
            dest.customer_prev_addr_housenumber = pir_preorder.customer_prev_addr_housenumber,
            dest.customer_prev_addr_addition = pir_preorder.customer_prev_addr_addition,
            dest.customer_prev_addr_zipcode = pir_preorder.customer_prev_addr_zipcode,
            dest.customer_prev_addr_city = pir_preorder.customer_prev_addr_city,
            dest.customer_prev_addr_country = pir_preorder.customer_prev_addr_country,
            dest.customer_upd_email = pir_preorder.customer_upd_email,
            dest.customer_upd_phone_countrycode = pir_preorder.customer_upd_phone_countrycode,
            dest.customer_upd_phone_areacode = pir_preorder.customer_upd_phone_areacode,
            dest.customer_upd_phone_number = pir_preorder.customer_upd_phone_number 
         --   ,dest.CUSTOMER_PASSWORD              = pir_preorder.CUSTOMER_PASSWORD 
            ,
            dest.apex$sync_step_static_id = pir_preorder.apex$sync_step_static_id,
            dest.apex$row_sync_timestamp = pir_preorder.apex$row_sync_timestamp,
            dest.is_new_customer = pir_preorder.is_new_customer,
            dest.created = pir_preorder.created,
            dest.last_modified = pir_preorder.last_modified,
            dest.version = pir_preorder.version,
            dest.process_lock = pir_preorder.process_lock,
            dest.process_lock_last_modified = pir_preorder.process_lock_last_modified 
            -- 2023-08-24 neue Spalten: 
            ,
            dest.siebel_order_number = pir_preorder.siebel_order_number,
            dest.siebel_order_rowid = pir_preorder.siebel_order_rowid,
            dest.siebel_ready = pir_preorder.siebel_ready,
            dest.service_plus_email = pir_preorder.service_plus_email -- @FTTH-5002
            -- 2023-12-06 neue Spalten: 
            ,
            dest.manual_transfer = pir_preorder.manual_transfer,
            dest.ont_provider = pir_preorder.ont_provider,
            dest.wholebuy_partner = pir_preorder.wholebuy_partner 
            -- 2024-08-21:
            ,
            dest.connectivity_id = pir_preorder.connectivity_id                 -- @ticket FTTH-3727
            ,
            dest.rt_contact_data_ticket_id = pir_preorder.rt_contact_data_ticket_id       -- @ticket FTTH-3727
            ,
            dest.landlord_information_required = pir_preorder.landlord_information_required   -- @ticket FTTH-3727
            -- neu 2024-08-23 @ticket FTTH-3711:
            ,
            dest.update_customer_in_siebel = pir_preorder.update_customer_in_siebel,
            dest.home_id = pir_preorder.home_id,
            dest.account_id = pir_preorder.account_id,
            dest.availability_date = pir_preorder.availability_date -- @ticket FTTH-3880
            -- ... @SYNC#12
        when not matched then
        insert
        values
            pir_preorder;

    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end p_auftragsdaten_synchronisieren; 
  
--------------------------------------------------------------------------------

/**
 * Gibt Adressfelder zu einer HAUS_LFD_NR zurück: Vorranging aus der Tabelle POB_ADRESSEN;
 * wenn dort nichts gefunden wird: aus der STRAV.
 *
 * @throws  Bei NO_DATA_FOUND werden leere Felder zurückgegeben. Alle sonstigen Fehler werden geraised, aber nicht geloggt.
 */
    procedure p_get_adresse (
        pin_haus_lfd_nr   in pob_adressen.haus_lfd_nr%type,
        pov_str           out pob_adressen.str%type,
        pov_hnr_kompl     out pob_adressen.hnr_kompl%type,
        pov_gebaeudeteil  out pob_adressen.gebaeudeteil_name%type,
        pov_plz           out pob_adressen.plz%type,
        pov_ort_kompl     out pob_adressen.ort_kompl%type,
        pov_adresse_kompl out pob_adressen.adresse_kompl%type
    ) is
    begin
        << pob_adressen >> begin
            select
                str,
                hnr_kompl,
                gebaeudeteil_name,
                plz,
                ort_kompl,
                adresse_kompl
            into
                pov_str,
                pov_hnr_kompl,
                pov_gebaeudeteil,
                pov_plz,
                pov_ort_kompl,
                pov_adresse_kompl
            from
                pob_adressen
            where
                haus_lfd_nr = pin_haus_lfd_nr;

        exception
            when no_data_found then
                << strav >> begin
                    pck_glascontainer_ext.p_get_strav_adresse(
                        pin_haus_lfd_nr   => pin_haus_lfd_nr,
                        pov_str           => pov_str,
                        pov_hnr_kompl     => pov_hnr_kompl,
                        pov_gebaeudeteil  => pov_gebaeudeteil,
                        pov_plz           => pov_plz,
                        pov_ort_kompl     => pov_ort_kompl,
                        pov_adresse_kompl => pov_adresse_kompl
                    );
                exception
                    when no_data_found then
                        null;
                end strav;
        end pob_adressen;
    end p_get_adresse; 
  
--------------------------------------------------------------------------------

  /** 
  * Nimmt ein JSON-Dokument vom Format des preorders-Webservices entgegen 
  * und liefert den Datensatz vom Zeilenyp FTTH_WS_SYNC_PREORDERS zurück 
  */
    function fr_preorder_from_json (
        piv_json in clob
    ) return ftth_ws_sync_preorders%rowtype is

        tauftragsdaten_gk       t_auftragsdaten_gk := t_auftragsdaten_gk();
        v_preorder              ftth_ws_sync_preorders%rowtype;
        v_dummy_providerwechsel varchar2(5); 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name         constant logs.routine_name%type := 'fr_preorder_from_json';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_json',
                             dbms_lob.substr(piv_json, 1000, 1));
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        parse_preorder(
            pic_preorder_json    => piv_json,
            pov_auftragsdaten_gk => tauftragsdaten_gk
        );
        v_preorder.id := tauftragsdaten_gk.uuid;
        v_preorder.vkz := tauftragsdaten_gk.vkz;
        v_preorder.customernumber := tauftragsdaten_gk.kundennummer;
        v_preorder.templateid := tauftragsdaten_gk.promotion;
        v_preorder.devicecategory := tauftragsdaten_gk.router_auswahl;
        v_preorder.deviceownership := tauftragsdaten_gk.router_eigentum;
        v_preorder.ont_provider := tauftragsdaten_gk.ont_provider;
        v_preorder.installationservice := tauftragsdaten_gk.installationsservice;
        v_preorder.houseconnectionprice := tauftragsdaten_gk.haus_anschlusspreis;
        v_preorder.client := tauftragsdaten_gk.mandant;
        v_preorder.customer_businessname := tauftragsdaten_gk.firmenname;
        v_preorder.customer_salutation := tauftragsdaten_gk.anrede;
        v_preorder.customer_title := tauftragsdaten_gk.titel;
        v_preorder.customer_name_first := tauftragsdaten_gk.vorname;
        v_preorder.customer_name_last := tauftragsdaten_gk.nachname;
        v_preorder.customer_birthdate := tauftragsdaten_gk.geburtsdatum;
        v_preorder.customer_email := tauftragsdaten_gk.email;
        v_preorder.customer_residentstatus := tauftragsdaten_gk.wohndauer;
        v_preorder.customer_phone_countrycode := tauftragsdaten_gk.laendervorwahl;
        v_preorder.customer_phone_areacode := tauftragsdaten_gk.vorwahl;
        v_preorder.customer_phone_number := tauftragsdaten_gk.telefon;
        v_dummy_providerwechsel := tauftragsdaten_gk.providerwechsel;
        v_preorder.providerchg_current_provider := tauftragsdaten_gk.providerw_aktueller_anbieter;
        v_preorder.providerchg_owner_salutation := tauftragsdaten_gk.providerw_anmeldung_anrede;
        v_preorder.providerchg_owner_name_last := tauftragsdaten_gk.providerw_anmeldung_nachname;
        v_preorder.providerchg_owner_name_first := tauftragsdaten_gk.providerw_anmeldung_vorname;
        v_preorder.providerchg_keep_phone_number := tauftragsdaten_gk.providerw_nummer_behalten;
        v_preorder.providerchg_phone_countrycode := tauftragsdaten_gk.providerw_laendervorwahl;
        v_preorder.providerchg_phone_areacode := tauftragsdaten_gk.providerw_vorwahl;
        v_preorder.providerchg_phone_number := tauftragsdaten_gk.providerw_telefon;
        v_preorder.account_holder := tauftragsdaten_gk.kontoinhaber;
        v_preorder.account_sepamandate := tauftragsdaten_gk.sepa;
        v_preorder.account_iban := tauftragsdaten_gk.iban;
        v_preorder.customer_prev_addr_street := tauftragsdaten_gk.voradresse_strasse;
        v_preorder.customer_prev_addr_housenumber := tauftragsdaten_gk.voradresse_hausnr;
        v_preorder.customer_prev_addr_addition := tauftragsdaten_gk.voradresse_zusatz;
        v_preorder.customer_prev_addr_zipcode := tauftragsdaten_gk.voradresse_plz;
        v_preorder.customer_prev_addr_city := tauftragsdaten_gk.voradresse_ort;
        v_preorder.customer_prev_addr_country := tauftragsdaten_gk.voradresse_land;
        v_preorder.houseserialnumber := tauftragsdaten_gk.haus_lfd_nr;
        v_preorder.prop_owner_role := tauftragsdaten_gk.gee_rolle;
        v_preorder.prop_residential_unit := tauftragsdaten_gk.anzahl_we;
        v_preorder.landlord_legalform := tauftragsdaten_gk.vermieter_rechtsform;
        v_preorder.landlord_businessorname := tauftragsdaten_gk.vermieter_firmenname;
        v_preorder.landlord_salutation := tauftragsdaten_gk.vermieter_anrede;
        v_preorder.landlord_title := tauftragsdaten_gk.vermieter_titel;
        v_preorder.landlord_name_first := tauftragsdaten_gk.vermieter_vorname;
        v_preorder.landlord_name_last := tauftragsdaten_gk.vermieter_nachname;
        v_preorder.landlord_addr_street := tauftragsdaten_gk.vermieter_strasse;
        v_preorder.landlord_addr_housenumber := tauftragsdaten_gk.vermieter_hausnr;
        v_preorder.landlord_addr_zipcode := tauftragsdaten_gk.vermieter_plz;
        v_preorder.landlord_addr_city := tauftragsdaten_gk.vermieter_ort;
        v_preorder.landlord_addr_addition := tauftragsdaten_gk.vermieter_zusatz;
        v_preorder.landlord_addr_country := tauftragsdaten_gk.vermieter_land;
        v_preorder.landlord_email := tauftragsdaten_gk.vermieter_email;
        v_preorder.landlord_phone_countrycode := tauftragsdaten_gk.vermieter_laendervorwahl;
        v_preorder.landlord_phone_areacode := tauftragsdaten_gk.vermieter_vorwahl;
        v_preorder.landlord_phone_number := tauftragsdaten_gk.vermieter_telefon;
        v_preorder.landlord_agreed := tauftragsdaten_gk.vermieter_einverstaendnis;
        v_preorder.summ_precontractinformation := tauftragsdaten_gk.bestaetigung_vzf;
        v_preorder.summ_generaltermsandconditions := tauftragsdaten_gk.zustimmung_agb;
        v_preorder.summ_waiverightofrevocation := tauftragsdaten_gk.zustimmung_widerruf;
        v_preorder.summ_emailmarketing := tauftragsdaten_gk.opt_in_email;
        v_preorder.summ_phonemarketing := tauftragsdaten_gk.opt_in_telefon;
        v_preorder.summ_smsmmsmarketing := tauftragsdaten_gk.opt_in_sms_mms;
        v_preorder.summ_mailmarketing := tauftragsdaten_gk.opt_in_post;
        v_preorder.summ_ordersummaryfileid := tauftragsdaten_gk.vertragszusammenfassung;
        v_preorder.state := tauftragsdaten_gk.status;
        v_preorder.customer_upd_email := tauftragsdaten_gk.customer_upd_email;
        v_preorder.is_new_customer := tauftragsdaten_gk.is_new_customer;
        v_preorder.created := tauftragsdaten_gk.created;
        v_preorder.last_modified := tauftragsdaten_gk.last_modified;
        v_preorder.version := tauftragsdaten_gk.version;
        v_preorder.changed_by := tauftragsdaten_gk.changed_by;
        v_preorder.process_lock := tauftragsdaten_gk.process_lock;
        v_preorder.process_lock_last_modified := tauftragsdaten_gk.process_lock_last_modified;
        v_preorder.cancelled_by := tauftragsdaten_gk.storno_username;
        v_preorder.cancel_reason := tauftragsdaten_gk.storno_grund;
        v_preorder.cancel_date := tauftragsdaten_gk.storno_datum;
        v_preorder.siebel_order_number := tauftragsdaten_gk.siebel_order_number;
        v_preorder.siebel_order_rowid := tauftragsdaten_gk.siebel_order_rowid;
        v_preorder.siebel_ready := tauftragsdaten_gk.siebel_ready;
        v_preorder.service_plus_email := tauftragsdaten_gk.service_plus_email;
        v_preorder.wholebuy_partner := tauftragsdaten_gk.wholebuy_partner;
        v_preorder.manual_transfer := tauftragsdaten_gk.manual_transfer;
        v_preorder.technology := tauftragsdaten_gk.technology;
        v_preorder.connectivity_id := tauftragsdaten_gk.connectivity_id;
        v_preorder.rt_contact_data_ticket_id := tauftragsdaten_gk.rt_contact_data_ticket_id;
        v_preorder.landlord_information_required := tauftragsdaten_gk.landlord_information_required;
        v_preorder.customer_upd_phone_countrycode := tauftragsdaten_gk.customer_upd_phone_countrycode;
        v_preorder.customer_upd_phone_areacode := tauftragsdaten_gk.customer_upd_phone_areacode;
        v_preorder.customer_upd_phone_number := tauftragsdaten_gk.customer_upd_phone_number;
        v_preorder.update_customer_in_siebel := tauftragsdaten_gk.update_customer_in_siebel;
        v_preorder.home_id := tauftragsdaten_gk.home_id;
        v_preorder.account_id := tauftragsdaten_gk.account_id;
        v_preorder.availability_date := tauftragsdaten_gk.availability_date;
        v_preorder.customer_status := tauftragsdaten_gk.customer_status;
        v_preorder.router_shipping := tauftragsdaten_gk.router_shipping;
        return v_preorder;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end fr_preorder_from_json; 

 

    
--------------------------------------------------------------------------------

  /** 
  * Schreibt nach der Änderung eines Auftrags im APEX Glascontainer die neuen Daten 
  * (und zwar nur diejenigen, die zur Änderung vorgesehen sind, sowie das Lock) 
  * zurück in die Synchronisationstabelle, um bei Webservice-Ausfällen 
  * die letzten Änderungen aus dem lokalen Puffer lesen zu können. 
  * 
  * @param piv_uuid                 [IN ] PK des Auftrags 
  * @param piv_promotion            [IN ] Änderbares Feld im Glascontainer (kombiniert: Promotion & Produkt - eindeutig anhand der Selectliste) 
  * @param piv_router_auswahl       [IN ] Änderbares Feld im Glascontainer 
  * @param piv_router_eigentum      [IN ] Änderbares Feld im Glascontainer 
  * @param piv_installationsservice [IN ] Änderbares Feld im Glascontainer 
  * 
  * @usage Es werden keine fachlichen Validierungen ausgeführt, allerdings handelt es sich 
  * durchgehend um Pflichtfelder, so dass eine Exception geworfen wird, 
  * sobald eines davon leer ist 
  * 
  * @raise Es erfolgt ein Logging im Fehlerfall. Alle Fehler werden geworfen. 
  */
    procedure p_auftragsdaten_synchronisieren -- ////@todo umbenennen zu p_produktdaten_synchronisieren, sonst Verwechslung mit der Proc hierüber
     (
        piv_uuid                 in varchar2,
        piv_promotion            in varchar2,
        piv_router_auswahl       in varchar2,
        piv_router_eigentum      in varchar2,
        piv_installationsservice in varchar2
    ) is 
    --- v_process_lock_last_modified ftth_ws_sync_preorders.process_lock_last_modified%type; 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'p_auftragsdaten_synchronisieren';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_uuid', piv_uuid);
            pck_format.p_add('piv_promotion', piv_promotion);
            pck_format.p_add('piv_router_auswahl', piv_router_auswahl);
            pck_format.p_add('piv_router_eigentum', piv_router_eigentum);
            pck_format.p_add('piv_installationsservice', piv_installationsservice);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        if piv_uuid is null then
            raise_application_error(-20000, 'UUID fehlt');
        end if; 
    -- ///@todo: auf Funktionen abstützen 
        if piv_promotion is null then
            raise_application_error(-20000, 'Produkt/Promotion fehlt');
        end if;
        if piv_router_auswahl is null then
            raise_application_error(-20000, 'Router-Auswahl fehlt');
        end if;
        if
            piv_router_auswahl <> enum_devicecategory_byod
            and piv_router_eigentum is null
        then
            raise_application_error(-20000, 'Router-Eigentum fehlt');
        end if;

        if piv_installationsservice is null then
            raise_application_error(-20000, 'Installationsservice fehlt');
        end if; 
    -- //// @todo @Herbst-2023-Tarife 
        update ftth_ws_sync_preorders
        set
            templateid = piv_promotion,
            devicecategory = piv_router_auswahl,
            deviceownership = piv_router_eigentum,
            installationservice = piv_installationsservice,
            apex$sync_step_static_id = $$plsql_unit || ' (UPD)' -- Erkennungsmerkmal 
            ,
            apex$row_sync_timestamp = systimestamp -- In jedem Fall die Synchronisierungs-Uhrzeit eintragen 
           -- neu 2022-09-21: 
            ,
            process_lock = 'true',
            process_lock_last_modified = sysdate -- momentan spart das einen WS-Aufruf, aber das Lock gehört eigentlich dem Server! 
        where
            id = piv_uuid;

        if sql%rowcount <> 1 then
            raise_application_error(-20000, 'Lokale Synchronisierung nach Änderung fehlgeschlagen: ' || sqlerrm);
        end if;

    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end p_auftragsdaten_synchronisieren; 

--------------------------------------------------------------------------------

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
        piv_uuid             in ftth_ws_sync_preorders.id%type,
        pov_uuid             out varchar2,
        pov_auftragsdaten_gk out t_auftragsdaten_gk
    ) is 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'parse_preorder_synchronized';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_uuid', piv_uuid);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        pov_uuid := piv_uuid;
        select
            id,
            vkz,
            customernumber,
            templateid,
            devicecategory,
            deviceownership,
            ont_provider,
            installationservice,
            houseconnectionprice,
            client,
            customer_businessname,
            customer_salutation,
            customer_title,
            customer_name_first,
            customer_name_last,
            customer_birthdate,
            customer_email,
            customer_residentstatus,
            customer_phone_countrycode,
            customer_phone_areacode,
            customer_phone_number, 
           -- "Providerwechsel" ist ein abgeleitetes Feld, daher nehmen wir hier nicht [true|false]: 
            case
                when providerchg_current_provider is null then
                    0
                else
                    1
            end as providerwechsel,
            providerchg_current_provider,
            providerchg_owner_salutation,
            providerchg_owner_name_last,
            providerchg_owner_name_first,
            providerchg_keep_phone_number,
            providerchg_phone_countrycode,
            providerchg_phone_areacode,
            providerchg_phone_number,
            account_holder,
            account_sepamandate,
            account_iban,
            customer_prev_addr_street,
            customer_prev_addr_housenumber,
            customer_prev_addr_addition,
            customer_prev_addr_zipcode,
            customer_prev_addr_city,
            customer_prev_addr_country, 
           --------------------------------- 
            houseserialnumber,
            prop_owner_role,
            prop_residential_unit,
            landlord_legalform,
            landlord_businessorname,
            landlord_salutation,
            landlord_title,
            landlord_name_first,
            landlord_name_last,
            landlord_addr_street,
            landlord_addr_housenumber,
            landlord_addr_zipcode,
            landlord_addr_city,
            landlord_addr_addition,
            landlord_addr_country,
            landlord_email,
            landlord_phone_countrycode,
            landlord_phone_areacode,
            landlord_phone_number,
            landlord_agreed,
            summ_precontractinformation,
            summ_generaltermsandconditions,
            summ_waiverightofrevocation,
            summ_emailmarketing,
            summ_phonemarketing,
            summ_smsmmsmarketing,
            summ_mailmarketing,
            summ_ordersummaryfileid,
            state,
            customer_upd_email,
            is_new_customer,
            created,
            last_modified,
            version,
            changed_by,
            process_lock,
            process_lock_last_modified,
            cancelled_by,
            cancel_reason,
            cancel_date,
            siebel_order_number,
            siebel_order_rowid,
            siebel_ready,
            service_plus_email,
            wholebuy_partner,
            manual_transfer,
            technology,
            connectivity_id,
            rt_contact_data_ticket_id,
            landlord_information_required,
            customer_upd_phone_countrycode,
            customer_upd_phone_areacode,
            customer_upd_phone_number,
            update_customer_in_siebel,
            home_id,
            account_id,
            availability_date,
            customer_status,
            router_shipping
        into
            pov_auftragsdaten_gk.uuid,
            pov_auftragsdaten_gk.vkz,
            pov_auftragsdaten_gk.kundennummer,
            pov_auftragsdaten_gk.promotion,
            pov_auftragsdaten_gk.router_auswahl,
            pov_auftragsdaten_gk.router_eigentum,
            pov_auftragsdaten_gk.ont_provider,
            pov_auftragsdaten_gk.installationsservice,
            pov_auftragsdaten_gk.haus_anschlusspreis,
            pov_auftragsdaten_gk.mandant,
            pov_auftragsdaten_gk.firmenname,
            pov_auftragsdaten_gk.anrede,
            pov_auftragsdaten_gk.titel,
            pov_auftragsdaten_gk.vorname,
            pov_auftragsdaten_gk.nachname,
            pov_auftragsdaten_gk.geburtsdatum,
            pov_auftragsdaten_gk.email,
            pov_auftragsdaten_gk.wohndauer,
            pov_auftragsdaten_gk.laendervorwahl,
            pov_auftragsdaten_gk.vorwahl,
            pov_auftragsdaten_gk.telefon,
            pov_auftragsdaten_gk.providerwechsel,
            pov_auftragsdaten_gk.providerw_aktueller_anbieter,
            pov_auftragsdaten_gk.providerw_anmeldung_anrede,
            pov_auftragsdaten_gk.providerw_anmeldung_nachname,
            pov_auftragsdaten_gk.providerw_anmeldung_vorname,
            pov_auftragsdaten_gk.providerw_nummer_behalten,
            pov_auftragsdaten_gk.providerw_laendervorwahl,
            pov_auftragsdaten_gk.providerw_vorwahl,
            pov_auftragsdaten_gk.providerw_telefon,
            pov_auftragsdaten_gk.kontoinhaber,
            pov_auftragsdaten_gk.sepa,
            pov_auftragsdaten_gk.iban,
            pov_auftragsdaten_gk.voradresse_strasse,
            pov_auftragsdaten_gk.voradresse_hausnr,
            pov_auftragsdaten_gk.voradresse_zusatz,
            pov_auftragsdaten_gk.voradresse_plz,
            pov_auftragsdaten_gk.voradresse_ort,
            pov_auftragsdaten_gk.voradresse_land,
            pov_auftragsdaten_gk.haus_lfd_nr,
            pov_auftragsdaten_gk.gee_rolle,
            pov_auftragsdaten_gk.anzahl_we,
            pov_auftragsdaten_gk.vermieter_rechtsform,
            pov_auftragsdaten_gk.vermieter_firmenname,
            pov_auftragsdaten_gk.vermieter_anrede,
            pov_auftragsdaten_gk.vermieter_titel,
            pov_auftragsdaten_gk.vermieter_vorname,
            pov_auftragsdaten_gk.vermieter_nachname,
            pov_auftragsdaten_gk.vermieter_strasse,
            pov_auftragsdaten_gk.vermieter_hausnr,
            pov_auftragsdaten_gk.vermieter_plz,
            pov_auftragsdaten_gk.vermieter_ort,
            pov_auftragsdaten_gk.vermieter_zusatz,
            pov_auftragsdaten_gk.vermieter_land,
            pov_auftragsdaten_gk.vermieter_email,
            pov_auftragsdaten_gk.vermieter_laendervorwahl,
            pov_auftragsdaten_gk.vermieter_vorwahl,
            pov_auftragsdaten_gk.vermieter_telefon,
            pov_auftragsdaten_gk.vermieter_einverstaendnis,
            pov_auftragsdaten_gk.bestaetigung_vzf,
            pov_auftragsdaten_gk.zustimmung_agb,
            pov_auftragsdaten_gk.zustimmung_widerruf,
            pov_auftragsdaten_gk.opt_in_email,
            pov_auftragsdaten_gk.opt_in_telefon,
            pov_auftragsdaten_gk.opt_in_sms_mms,
            pov_auftragsdaten_gk.opt_in_post,
            pov_auftragsdaten_gk.vertragszusammenfassung,
            pov_auftragsdaten_gk.status,
            pov_auftragsdaten_gk.customer_upd_email,
            pov_auftragsdaten_gk.is_new_customer,
            pov_auftragsdaten_gk.created,
            pov_auftragsdaten_gk.last_modified,
            pov_auftragsdaten_gk.version,
            pov_auftragsdaten_gk.changed_by,
            pov_auftragsdaten_gk.process_lock,
            pov_auftragsdaten_gk.process_lock_last_modified,
            pov_auftragsdaten_gk.storno_username,
            pov_auftragsdaten_gk.storno_grund,
            pov_auftragsdaten_gk.storno_datum,
            pov_auftragsdaten_gk.siebel_order_number,
            pov_auftragsdaten_gk.siebel_order_rowid,
            pov_auftragsdaten_gk.siebel_ready,
            pov_auftragsdaten_gk.service_plus_email,
            pov_auftragsdaten_gk.wholebuy_partner,
            pov_auftragsdaten_gk.manual_transfer,
            pov_auftragsdaten_gk.technology,
            pov_auftragsdaten_gk.connectivity_id,
            pov_auftragsdaten_gk.rt_contact_data_ticket_id,
            pov_auftragsdaten_gk.landlord_information_required,
            pov_auftragsdaten_gk.customer_upd_phone_countrycode,
            pov_auftragsdaten_gk.customer_upd_phone_areacode,
            pov_auftragsdaten_gk.customer_upd_phone_number,
            pov_auftragsdaten_gk.update_customer_in_siebel,
            pov_auftragsdaten_gk.home_id,
            pov_auftragsdaten_gk.account_id,
            pov_auftragsdaten_gk.availability_date,
            pov_auftragsdaten_gk.customer_status,
            pov_auftragsdaten_gk.router_shipping
        from
            v_ftth_ws_sync_preorders_gk
        where
            id = piv_uuid;

    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end parse_preorder_synchronized; 

--------------------------------------------------------------------------------

  /** 
  * Nimmt die aktuellen Auftragsdaten in JSON-Form entgegen und aktualisiert 
  * die entsprechende Zeile in der Sync-Tabelle FTTH_WS_SYNC_PREORDERS 
  * 
  * @param piv_json [IN ] Vollständiges, valides JSON-Dokument des Auftrags, 
  * typischerweise frisch erhalten vom Webservice "preoders" 
  * 
  */
    procedure p_auftragsdaten_synchronisieren (
        piv_json in clob
    ) is

        v_preorder      ftth_ws_sync_preorders%rowtype; 
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'p_auftragsdaten_synchronisieren';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_json',
                             dbms_lob.substr(piv_json, 1000, 1));
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
  -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------      
    begin
        v_preorder := fr_preorder_from_json(piv_json);
        if piv_json is null
           or piv_json = c_empty_json then
            return; -- Leere Auftragsdaten entstehen, wenn man im Entwicklermodus die Seite erneut aufruft 
        end if;
        p_auftragsdaten_synchronisieren(pir_preorder => v_preorder);
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end p_auftragsdaten_synchronisieren; 

--------------------------------------------------------------------------------

  /** 
  * Ruft den Webservice "/preorders/{id}" mit einem GET-Request 
  * für einen bestimmten Auftrag auf und liefert die JSON-Antwort als CLOB zurück 
  * 
  * @param piv_uuid [IN ] Schlüssel des Auftrags 
  * 
  * @return Originale Antwort des Webservice ohne weitere Ergänzung oder Formatierung 
  * 
  * @raise ORA-29273: HTTP request failed 
  * @raise ORA-12535: TNS:operation timed out 
  */
    function fc_preorders_wsget (
        piv_uuid in varchar2
    ) return clob is

        v_json                   clob;
        v_ws_url                 varchar2(255);
        v_ws_username            varchar2(255);
        v_ws_password            varchar2(255);
        v_request_url            varchar2(255);
        v_ws_response_statuscode ftth_webservice_aufrufe.response_statuscode%type;
        v_log_id                 ftth_webservice_aufrufe.id%type;
        v_ws_errormsg            ftth_webservice_aufrufe.errormessage%type; 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name          constant logs.routine_name%type := 'fc_preorders_wsget';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_uuid', piv_uuid);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        if not pck_pob_rest.g_webservices_enabled then
            return empty_clob();
        end if;
        pck_pob_rest.p_init_webservice(
            piv_kontext     => pck_pob_rest.kontext_preorderbuffer,
            piv_ws_key      => c_ws_key_preorders_get,
            pov_ws_url      => v_ws_url,
            pov_ws_username => v_ws_username,
            pov_ws_password => v_ws_password
        ); 
    -- @see 
    -- https://api-e.dss.svc.netcologne.intern/ftth-order/swagger-ui/index.html#/order-controller/getOrder 
        --v_request_url := v_ws_url || trim(piv_uuid); 

        -- 2023-05-23: Falls in der URL '{orderId}' steht, muss dies mit der UUID ersetzt werden 
        v_request_url := replace(v_ws_url,
                                 c_ws_orderid_token,
                                 trim(piv_uuid));
        begin
            v_json := apex_web_service.make_rest_request(
                p_url              => v_request_url,
                p_http_method      => c_ws_method_get,
                p_username         => v_ws_username,
                p_password         => v_ws_password,
                p_transfer_timeout => c_ws_transfer_timeout,
                p_wallet_path      => c_ws_wallet_path,
                p_wallet_pwd       => c_ws_wallet_pwd
            );
        exception
            when others then
                v_ws_errormsg := substr(sqlerrm, 1, 255);
        end;

        pck_pob_rest.p_log_webservice_aufruf(
            piv_application         => $$plsql_unit,
            piv_scope               => cv_routine_name,
            piv_request_url         => v_request_url,
            piv_method              => c_ws_method_get,
            piv_parameters          => 'ID' -- /// richtiger Name, oder UUID? neu 2022-08-11 
            ,
            piv_parameter_values    => piv_uuid,
            piv_body                => null,
            piv_response_statuscode => apex_web_service.g_status_code,
            piv_app_user            => null -- Datenabrufe werden nicht persönlich geloggt (nicht angefordert) 
            ,
            piv_errormessage        => v_ws_errormsg
        );

        v_ws_response_statuscode := apex_web_service.g_status_code;
        if v_ws_errormsg is not null
           or v_ws_response_statuscode <> c_ws_statuscode_ok
        or v_json like '404%' then 
      -- /// unsauber, da hier alles auf den 404 gemappt wird: 
            raise_application_error(-20000 - c_ws_statuscode_not_found, 'Webservice "preorders" meldet Statuscode ' || v_ws_response_statuscode
            ); 
      -- ///... Statuscodes aufdröseln ... 
        end if;

        return v_json;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end fc_preorders_wsget; 
    
--------------------------------------------------------------------------------

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
    ) is
    begin
        if g_use_siebel then
            pck_glascontainer_ext.p_get_siebel_kopfdaten(
                piv_kundennummer  => piv_kundennummer,
                piov_vorname      => piov_vorname,
                piov_nachname     => piov_nachname,
                piod_geburtsdatum => piod_geburtsdatum,
                piov_anrede       => piov_anrede,
                piov_titel        => piov_titel,
                piov_firmenname   => piov_firmenname
            );

        end if;
    end; 

--------------------------------------------------------------------------------

    procedure p_get_auftragsdaten (
        piv_uuid             in varchar2,
        piv_ws_modus         in varchar2 -- ONLINE|ONLINE_AND_OFFLINE|OFFLINE war: pib_read_sync_on_ws_error 
        ,
        pib_synchronize      in boolean,
        pib_show_json        in boolean default false 
      --------------------------------------------- 
        ,
        pon_sqlcode          out integer,
        pov_sqlerrm          out varchar2,
        poc_json_payload     out clob 
      --------------------------------------------- 
        ,
        pov_auftragsdaten_gk out t_auftragsdaten_gk
    ) is

        v_preorder_json clob;
        v_void_uuid     varchar2(200);
        l_stornokosten  varchar2(4000 char);
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'p_get_auftragsdaten';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_uuid', piv_uuid);
            pck_format.p_add('piv_ws_modus', piv_ws_modus);
            pck_format.p_add('pib_synchronize', pib_synchronize);
            pck_format.p_add('pib_show_json', pib_show_json);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params; 
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        << zwei_versuche >> begin
            if piv_ws_modus in ( c_ws_modus_online, c_ws_modus_online_and_offline ) then 
        -- Normalzustand 
                begin
                    v_preorder_json := fc_preorders_wsget(piv_uuid => piv_uuid); 

          -- optional: Anzeigemöglichkeit der JSON-Response in der APEX-Seite 
          -- (nur für Entwickler): 
                    if pib_show_json then
                        poc_json_payload := v_preorder_json;
                    end if;
                exception
                    when others then
                        pon_sqlcode := sqlcode;
                        pov_sqlerrm := sqlerrm;
                end;

                if pon_sqlcode is null then 
          -- Erfolg bei wsget: 
                    parse_preorder(
                        pic_preorder_json    => v_preorder_json,
                        pov_auftragsdaten_gk => pov_auftragsdaten_gk
                    );                            

          -- @ticket FTTH-4220:
                    if pov_auftragsdaten_gk.rt_contact_data_ticket_id is not null then
                        declare
                            link_rt constant varchar2(1000) := -- leider hartkodiert:
                                case db_name
                                    when 'NMC' then
                                        'https://rt.netcologne.de' -- Produktion!
                                   -- in allen anderen Umgebungen möchte Nusret
                                   -- immer in die Development-Umgebung verzweigen:
                                    else 'https://rt-devel.netcologne.de'
                                   -- Testumgebungs-Link wird ignoriert:
                                   -- https://rt-test.netcologne.de
                                end;
                -- die eigentlich korrekte Ermittlung des RT-Links wäre wie folgt, führt hier allerdings wegen
                -- der gewünschten Verzweigungslogik nicht zum Ziel:
                --     SELECT MAX(v_wert1)
                --       INTO LINK_RT
                --       FROM params
                --      WHERE UPPER(pv_key1) = 'RT'
                --        AND pv_key2 = 'RT: URL'
                        begin
                            pov_auftragsdaten_gk.rt_contact_data_ticket_link := fv_a_href(
                                piv_href   => rtrim(link_rt, '/')
                                            || '/Ticket/Display.html?id='
                                            || pov_auftragsdaten_gk.rt_contact_data_ticket_id,
                                piv_text   => pov_auftragsdaten_gk.rt_contact_data_ticket_id,
                                piv_target => '_blank',
                                piv_title  => 'Request Tracker für dieses Ticket in einem neuen Browserfenster öffnen'
                            );

                        end;

                    end if;

          -- 2023-08-24 neu hier: Dies löst den APEX-Prozess "Auftragsdaten synchronisieren" ab, der 
          -- überflüssigerweise als einzelnes Artefakt in Prozessbaum hing und unter unglücklichen Umständen 
          -- auch mal nicht ausgeführt wurde: 
                    if pib_synchronize then
                        p_auftragsdaten_synchronisieren(piv_json => v_preorder_json); 
            -- ///@refactorn: Es ist doch eigentlich doppelt gemoppelt, wenn das JSON hier zum 2. Mal geparst wird. 
            -- Besser wäre es, wenn am Ende des Prozesses, wenn alle Felder geparst sind, genau deren Inhalte 
            -- in die FTTH_WS_SYNC_PREORDERS eingetragen würden. Das würde sämtliche Inkonsistenzen verhindern. 
            -- Dieser Synchronisierungsvorgang aktualisiert auch den Eintrag in POB_ADRESSEN, diehe Trigger FTTH_WS_SYNC_PREORDERS_BIU
            -- @ticket FTTH-4641: Es werden sowohl die Daten im POB als auch in POB_ADRESSEN synchronisiert          
                    end if; 

          -- Adresse vorrangig aus POB_ADRESSEN oder aus STRAV hinzufügen:
                    p_get_adresse(
                        pin_haus_lfd_nr   => pov_auftragsdaten_gk.haus_lfd_nr,
                        pov_str           => pov_auftragsdaten_gk.anschluss_str,
                        pov_hnr_kompl     => pov_auftragsdaten_gk.anschluss_hnr_kompl,
                        pov_gebaeudeteil  => pov_auftragsdaten_gk.anschluss_gebaeudeteil,
                        pov_plz           => pov_auftragsdaten_gk.anschluss_plz,
                        pov_ort_kompl     => pov_auftragsdaten_gk.anschluss_ort_kompl,
                        pov_adresse_kompl => pov_auftragsdaten_gk.anschluss_adresse_kompl
                    );

                    if pov_auftragsdaten_gk.process_lock = json_true then
                        pon_sqlcode := c_order_is_locked;
                        pov_sqlerrm := 'Der Auftrag wird gerade verarbeitet und ist seit '
                                       ||
                            case
                                when trunc(pov_auftragsdaten_gk.process_lock_last_modified) < trunc(sysdate) then
                                    to_char(pov_auftragsdaten_gk.process_lock_last_modified, 'FMDay')
                                    || ', '
                                    || to_char(pov_auftragsdaten_gk.process_lock_last_modified, 'DD.MM.')
                                else 'heute'
                            end
                                       || ' ('
                                       || to_char(pov_auftragsdaten_gk.process_lock_last_modified, 'HH24:MI')
                                       || ' Uhr)'
                                       || ' gesperrt. Änderungen am Auftrag können erst nach Ablauf der Sperre gespeichert werden.';

                    end if;
          
            -- Auftragsdaten fuer externe Auftragsdaten Seite 32/34 ermitteln
                    l_stornokosten := pck_glascontainer.fv_stornokosten(
                        piv_uuid              => pov_auftragsdaten_gk.uuid,
                        piv_wholebuy_partner  => pov_auftragsdaten_gk.wholebuy_partner,
                        pid_availability_date => pov_auftragsdaten_gk.availability_date
                    );

                    if l_stornokosten is not null then
                        pov_auftragsdaten_gk.storno_kosten := 'Ja';
                    else
                        pov_auftragsdaten_gk.storno_kosten := 'Nein';
                    end if;

          ------- 
                    return; 
          ------- 
                else 
          -- kein Erfolg bei wsget 
                    if piv_ws_modus = c_ws_modus_online -- also OFFLINE ausdrücklich nicht gewünscht 
                     then 
            -- ///@todo Nicht-Verfügbarkeit des Webservices protokollieren 
                        raise_application_error(pon_sqlcode, pov_sqlerrm);
                    end if;
                end if; -- Erfolg oder nicht bei wsget; 
            end if; -- /Normalzustand: kein Mock 

            << synchrondaten_holen >> 
      -- (Hier ist die Prozedur bereits ausgestiegen, wenn der Aufruf erfolgreich war 
      -- oder ein Problem mit dem Webservice bestand und SYNC-lesen abgelehnt wurde) 

             begin 
        -- Stattdessen versuchen, die zuletzt synchronisierten Daten anzuzeigen: 
                parse_preorder_synchronized(
                    piv_uuid             => piv_uuid,
                    pov_uuid             => v_void_uuid,
                    pov_auftragsdaten_gk => pov_auftragsdaten_gk
                ); 
        ----------------------------------------------------------------- 
        -- Fehlende oder veraltete Daten aus externen Systemen anreichern 
        ----------------------------------------------------------------- 
        -- Für Bestandskunden holen wir aus Siebel die Kopfdaten, 
        -- die im Preorder-Buffer fehlen: 
                if pov_auftragsdaten_gk.is_new_customer = 'false' -- ////@todo: @ticket FTTH-1246 verlangt das auch für Neukunden! 
                 then
                    p_get_siebel_kopfdaten(
                        piv_kundennummer  => pov_auftragsdaten_gk.kundennummer,
                        piov_vorname      => pov_auftragsdaten_gk.vorname,
                        piov_nachname     => pov_auftragsdaten_gk.nachname,
                        piod_geburtsdatum => pov_auftragsdaten_gk.geburtsdatum,
                        piov_anrede       => pov_auftragsdaten_gk.anrede,
                        piov_titel        => pov_auftragsdaten_gk.titel,
                        piov_firmenname   => pov_auftragsdaten_gk.firmenname
                    );

                end if; 
        -- @ticket FTTH-4641:
                p_get_adresse(
                    pin_haus_lfd_nr   => pov_auftragsdaten_gk.haus_lfd_nr,
                    pov_str           => pov_auftragsdaten_gk.anschluss_str,
                    pov_hnr_kompl     => pov_auftragsdaten_gk.anschluss_hnr_kompl,
                    pov_gebaeudeteil  => pov_auftragsdaten_gk.anschluss_gebaeudeteil,
                    pov_plz           => pov_auftragsdaten_gk.anschluss_plz,
                    pov_ort_kompl     => pov_auftragsdaten_gk.anschluss_ort_kompl,
                    pov_adresse_kompl => pov_auftragsdaten_gk.anschluss_adresse_kompl
                );
        
        -- Auftragsdaten fuer externe Auftragsdaten Seite 32/34 ermitteln
                l_stornokosten := pck_glascontainer.fv_stornokosten(
                    piv_uuid              => pov_auftragsdaten_gk.uuid,
                    piv_wholebuy_partner  => pov_auftragsdaten_gk.wholebuy_partner,
                    pid_availability_date => pov_auftragsdaten_gk.availability_date
                );

                if l_stornokosten is not null then
                    pov_auftragsdaten_gk.storno_kosten := 'Ja';
                else
                    pov_auftragsdaten_gk.storno_kosten := 'Nein';
                end if;

            end synchrondaten_holen;

        end zwei_versuche;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end p_get_auftragsdaten;

    function fv_auftragsdaten_gk_warning (
        piv_uuid             in varchar2,
        piv_status           in varchar2,
        piv_customer_status  in varchar2,
        piv_ws_errorcode     in varchar2,
        piv_error_message    in varchar2,
        piv_wholebuy_partner in varchar2,
        piv_checks           in varchar2,
        pov_alert_type       out varchar2
    ) return varchar2 is
        v_return_warning varchar2(4000);
        v_can_cancel     varchar2(4000);
        d_last_sync      date;
    begin
  
    -- CAN_CANCEL ermittteln        
        if ( piv_wholebuy_partner is not null ) then
            v_can_cancel := pck_glascontainer.fv_can_cancel(piv_uuid);
        else
            v_can_cancel := null;
        end if;

        if ( instr(piv_checks, 'SYNC') > 0 ) then
            if (
                piv_uuid is not null
                and piv_ws_errorcode <> pck_glascontainer.c_order_is_locked
            ) then
                d_last_sync := pck_glascontainer.fd_ws_last_sync_date(piv_uuid => piv_uuid);
                if ( nvl(piv_ws_errorcode, '-') = '-20404' ) then
                    v_return_warning := 'Der Auftrag kann momentan nicht abgerufen werden. Sie sehen die zuletzt synchronisierten Daten'
                    ;
                else
                    v_return_warning := 'Der Webservice, der die aktuellen Auftragsdaten liefert, ist nicht erreichbar ('
                                        || piv_error_message
                                        || ').'
                                        || '<br/>Stattdessen sehen Sie hier die Daten aus der letzten Synchronisierung ';
                    if ( trunc(d_last_sync) = trunc(sysdate) ) then
                        v_return_warning := v_return_warning
                                            || 'von heute, '
                                            || to_char(d_last_sync, 'HH24:MI')
                                            || ' Uhr';
              --WHEN d_last_sync IS NULL 
              --  THEN NULL;
                    else
                        v_return_warning := v_return_warning
                                            || 'vom '
                                            || to_char(d_last_sync, 'DD.MM.YYYY')
                                            || ' um '
                                            || to_char(d_last_sync, 'HH24:MI')
                                            || ' Uhr';
                    end if;

                end if;

                v_return_warning := v_return_warning || ' - die Bearbeitung ist deaktiviert.';
                pov_alert_type := 't-Alert--danger';
                return v_return_warning;
            end if;

        end if;

        if ( instr(piv_checks, 'LOESCHUNG') > 0 ) then
            if ( nvl(piv_customer_status, '-') = pck_glascontainer.status_scheduled_for_deletion ) then
                v_return_warning := 'Achtung, dieser Auftrag ist zur Löschung in der Goodbye-DB vorgesehen!';
                pov_alert_type := 't-Alert--danger';
                return v_return_warning;
            end if;
        end if;

        if ( instr(piv_checks, 'AUFTRAG_ABGESCHLOSSEN') > 0 ) then
            if ( nvl(piv_status, '-') = pck_glascontainer.status_siebel_processed ) then
                v_return_warning := 'Der Auftrag wurde nach Siebel übertragen und kann nicht mehr bearbeitet werden.';
                pov_alert_type := 't-Alert--danger';
                return v_return_warning;
            end if;
        end if;

        if ( instr(piv_checks, 'AUFTRAG_STORNIERT') > 0 ) then
            if ( nvl(piv_status, '-') = pck_glascontainer.status_cancelled ) then
                v_return_warning := 'Der Auftrag wurde storniert und kann nicht mehr bearbeitet werden.';
                pov_alert_type := 't-Alert--danger';
                return v_return_warning;
            end if;
        end if;

        if ( instr(piv_checks, 'AUFTRAG_IN_BEARBEITUNG') > 0 ) then
            if (
                nvl(v_can_cancel, null) is null
                and piv_status in ( pck_glascontainer.status_created, pck_glascontainer.status_in_review, pck_glascontainer.status_clearing_landlord_data
                )
                and piv_ws_errorcode = pck_glascontainer.c_order_is_locked
            ) then
                v_return_warning := piv_error_message;
                pov_alert_type := 't-Alert--warning';
                return v_return_warning;
            end if;
        end if;

        if ( v_can_cancel is not null ) then
            v_return_warning := 'Eine Bearbeitung ist erst nach Eingangsbestätigung durch den Wholebuy-Partner möglich.';
            pov_alert_type := 't-Alert--warning';
            return v_return_warning;
        end if;  

  
    -- Last Exit
        pov_alert_type := 't-Alert--info';
        return null;
    end;

    function fv_new_connectivity_id (
        piv_uuid            in varchar2,
        piv_connectivity_id in varchar2,
        piv_app_user        in varchar2
    ) return varchar2 as

        l_ret           varchar2(4000 char);
    
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------ 
        cv_routine_name constant logs.routine_name%type := 'fv_new_connectivity_id';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_uuid', piv_uuid);
            pck_format.p_add('piv_connectivity_id', piv_connectivity_id);
            pck_format.p_add('piv_app_user', piv_app_user);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;

    begin
        l_ret := pck_glascontainer_order.fv_neue_externe_auftragsnummer(
            piv_uuid            => piv_uuid,
            piv_connectivity_id => piv_connectivity_id,
            piv_app_user        => piv_app_user
        );

        return l_ret;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            rollback;
            raise;
    end fv_new_connectivity_id;

end pck_glascontainer_gk;
/

