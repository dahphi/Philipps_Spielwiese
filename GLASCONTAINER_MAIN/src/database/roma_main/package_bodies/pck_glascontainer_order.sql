create or replace package body pck_glascontainer_order as

/**
 * Hilfsroutinen für die Applikation 2022 "Glascontainer" zur Durchführung von
 * internen Vorbestellungen (Seiten 100, 110)
 */

  -- Umlaut-Test: ÄÖÜäöüß?

  -- Im Unterschied zu PCK_GLASCONTAINER_ORDER.version ist die Version im PACKAGE BODY 
  -- meist höher (die informelle APEX-Abfrage auf Seite 2022:10050 ermittelt den  
  -- höheren der beiden Werte über die FUNCTION get_body_version) 
    body_version constant varchar2(30) := '2025-05-21 0900';

  -- Wird zum Erstellen eines JSON_OBJECT_T gebraucht 
    c_empty_json constant varchar2(2) := '{}';
    json_true    constant varchar2(5) := 'true';
    json_false   constant varchar2(5) := 'false'; 

    -- zum schnelleren Auffinden von Flags 0|1 im Quellcode:
    c_nein       constant varchar2(1) := '0';
    c_ja         constant varchar2(1) := '1';




  /** 
  * Gibt den Versionsstring des Package Bodies zurück 
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

    function date2json (
        pid in date
    ) return varchar2
        deterministic
    is
    begin
        return to_char(pid, 'YYYY-MM-DD');
    end;  

  /**
   * Vorab-Implementierung von TO_BOOLEAN, welches erst mit der Datenbank-Version 23c erscheint
   */
    function to_boolean (
        piv in varchar2
    ) return boolean
        deterministic
    is

        c_string constant varchar2(5) := substr(
            trim(upper(piv)),
            1,
            5
        );
    begin
        return
            case
                when c_string in ( '1', 'Y', 'TRUE', 'YES', 'ON',
                                   'T' ) then
                    true
                when c_string in ( '0', 'N', 'FALSE', 'NO', 'OFF',
                                   'F' ) then
                    false
                -- //// fehlt noch: nummerische Werte <> 0 werden als TRUE ausgegeben
                else null
            end;
    end;

/**  
 * Fügt einer Variablen vom Typ JSON_OBJECT_T per PUT ein Ssimples tring-Element hinzu, 
 * jedoch nur wenn dessen Wert nicht NULL ist
 *
 * @param pio_json   [IN OUT]  Zu ergänzendes Konstrukt vom Typ JSON_OBJECT_T
 * @param piv_key    [IN ]     Name des Attributs
 * @param piv_value  [IN ]     Wert des Attributs (wird geprüft, ob leer)
 */
    procedure put_if_value (
        pio_json  in out json_object_t,
        piv_key   in varchar2,
        piv_value in varchar2
    ) is
    begin
        if piv_value is null then
            return;
        end if;
        pio_json.put(piv_key, piv_value);
    end put_if_value;

/**  
 * Fügt einer Variablen vom Typ JSON_OBJECT_T per PUT ein Ssimples tring-Element hinzu, 
 * jedoch nur wenn dessen Wert nicht NULL ist
 *
 * @param pio_json   [IN OUT]  Zu ergänzendes Konstrukt vom Typ JSON_OBJECT_T
 * @param piv_key    [IN ]     Name des Attributs
 * @param piv_value  [IN ]     Wert des Attributs (wird geprüft, ob leer)
 */
    procedure put_if_value (
        pio_json  in out json_object_t,
        piv_key   in varchar2,
        piv_value in json_object_t
    ) is
    begin
        if piv_value is null then
            return;
        end if;
        pio_json.put(piv_key, piv_value);
    end put_if_value;  



/**
 * Liefert den vom POB-Backend-Webservice erwarteten Statuswert, siehe @ticket FTTH-1972
 * 
 * @param piv_status [IN ] Statuswert, der in der Tabelle VERMARKTUNGSCLUSTER verwendet wird:
 *                         ZUSAMMENGROSSGESCHRIEBEN; 
 *                         es darf aber auch ein bereits normalisierter Wert sein
 *
 * @return
 * Status NULL ergibt Statusdisplay NULL.
 *
 * @usage Durch die Verwendung NORMALISIERTER Statuswerte werden die üblichen Fehlerquellen
 *        aufgrund der unterschiedlichen Schreibweisen vermieden.
 *
 * @todo //// konsolidieren mit gleichnamiger FUNCTION im PCK_VERMARKTUNGSCLUSTER
 * @todo //// String-Konstanten, zB. AUSBAUSTATUS_HOMES_CONNECTED verwenden
 */
    function fv_vc_status_webservice (
        piv_status vermarktungscluster.status%type
    ) return varchar2
        deterministic
    is
    begin
        return
            case upper(trim(replace(piv_status, '_')))
                when 'AREAPLANNED' then
                    'AREA_PLANNED'
                when 'PREMARKETING' then
                    'PRE_MARKETING'
                when 'UNDERCONSTRUCTION' then
                    'UNDER_CONSTRUCTION'
           ---- ungebräuchlich im Glascontainer:
                when 'NOTPLANNED' then
                    'NOT_PLANNED'
                when 'HOMESPASSED' then
                    'HOMES_PASSED'
                when 'HOMESPREPARED' then
                    'HOMES_PREPARED'
                when 'HOMESREADY' then
                    'HOMES_READY'
                when 'HOMESCONNECTED' then
                    'HOMES_CONNECTED'
                else piv_status
            end;
    end;     

/** 
 * Nur für die Entwicklung: Ermöglicht den direkten Sprung zu einer anderen Maske.
 * 
 * @param siehe APEX App 2022 P100
 * @param pib_ausfuellen  Wenn TRUE,  dann werden die Ausgangswerte des Steps mit Dummy-Werten befüllt,
 *                        wenn FALSE, dann werden sie mit NULL initialisiert,
 *                        bei NULL passiert nichts (piov_ = piov_)
 *
 * @usage Diese Prozedur kann nach Ausbau bzw. Deaktivierung der Test-Buttons entfernt werden
 */
    procedure goto_step (
        pin_step                       in integer,
        pib_ausfuellen                 in boolean 
    -- Adresssuche: 
        ,
        piov_haus_lfd_nr               in out integer,
        piov_kundenstatus              in out varchar2 -- "N"eukunde, "B"estandskunde 
        ,
        piov_strav_strasse             in out varchar2,
        piov_strav_hausnr              in out varchar2,
        piov_strav_hausnr_zusatz       in out varchar2,
        piov_strav_plz                 in out varchar2,
        piov_strav_ort                 in out varchar2,
        piov_strav_adresse_komplett    in out varchar2 -- @krakar @ticket FTTH-4622
    -- Step 1: 
        ,
        piov_aktion                    in out varchar2,
        piov_vkz                       in out varchar2,
        piov_mandant                   in out varchar2 -- 
        ,
        piov_vc_min_bandbreite         in out varchar2,
        piov_vc_max_bandbreite         in out varchar2,
        piov_produkt                   in out varchar2,
        piov_router_auswahl            in out varchar2,
        piov_router_eigentum           in out varchar2,
        piov_ont_provider              in out varchar2 --@ticket @ticket FTTH-5008 nach Versionierung bereit zur Entfernung
        ,
        piov_einrichtungsservice       in out varchar2,
        piov_rolle                     in out varchar2,
        piov_anzahl_we                 in out varchar2,
        piov_anschluss_kostenpflichtig in out varchar2,
        piov_kosten_hausanschluss      in out varchar2 
    -- Step 2: 
        ,
        piov_neukunde_anrede           in out varchar2,
        piov_neukunde_titel            in out varchar2,
        piov_neukunde_vorname          in out varchar2,
        piov_neukunde_nachname         in out varchar2,
        piod_neukunde_geburtsdatum     in out date,
        piov_neukunde_soho             in out varchar2,
        piov_neukunde_firmenname       in out varchar2,
        piov_neukunde_email            in out varchar2,
        piov_neukunde_vorwahl          in out varchar2,
        piov_neukunde_rufnummer        in out varchar2,
        piov_neukunde_iban             in out varchar2,
        piov_neukunde_abw_kontoinhaber in out varchar2,
        piov_neukunde_kontoinhaber     in out varchar2,
        piov_neukunde_sepamandat       in out varchar2 
    -- Step 3: 
        ,
        piov_siebel_kundennummer       in out varchar2,
        piov_siebel_message            in out varchar2 -- hiermit kann eine Fehlermeldung sumliert werden
        ,
        piov_siebel_global_id          in out varchar2,
        piov_siebel_anrede             in out varchar2,
        piov_siebel_titel              in out varchar2,
        piov_siebel_vorname            in out varchar2,
        piov_siebel_nachname           in out varchar2,
        piod_siebel_geburtsdatum       in out date,
        piov_siebel_firmenname         in out varchar2,
        piov_siebel_strasse            in out varchar2,
        piov_siebel_plz_ort            in out varchar2,
        piov_siebel_ap_email           in out varchar2,
        piov_siebel_ap_mobil_vorwahl   in out varchar2,
        piov_siebel_ap_mobil_rufnummer in out varchar2 
    -- Step 4: 
    -- Step 5: 
        ,
        pon_wohnt_dort                 in out integer,
        piov_wohndauer                 in out varchar2,
        pon_abw                        in out integer,
        piov_bisheriger_anbieter       in out varchar2,
        pon_rufnummernmitnahme         in out integer,
        piov_abw_vorwahl               in out varchar2,
        piov_abw_rufnummer             in out varchar2,
        piov_abw_anschlussinhaber      in out varchar2,
        piov_abw_anrede                in out varchar2,
        piov_abw_vorname               in out varchar2,
        piov_abw_nachname              in out varchar2,
        piov_voradresse_plz            in out varchar2,
        piov_voradresse_ort            in out varchar2,
        piov_voradresse_strasse        in out varchar2,
        piov_voradresse_hausnr         in out varchar2 
    -- Step 6:
        ,
        piov_gee_kontaktdaten_bekannt  in out varchar2,
        piov_gee_rechtsform            in out varchar2,
        piov_gee_firma                 in out varchar2,
        piov_gee_anrede                in out varchar2,
        piov_gee_titel                 in out varchar2,
        piov_gee_vorname               in out varchar2,
        piov_gee_nachname              in out varchar2,
        piov_gee_land                  in out varchar2,
        piov_gee_plz                   in out varchar2,
        piov_gee_ort                   in out varchar2,
        piov_gee_strasse               in out varchar2,
        piov_gee_hausnr                in out varchar2,
        piov_gee_hausnr_zusatz         in out varchar2,
        piov_gee_email                 in out varchar2,
        piov_gee_vorwahl               in out varchar2,
        piov_gee_rufnummer             in out varchar2,
        piov_gee_informationspflicht   in out varchar2
    ) is
    begin 
    -- Müssen bereits beim Aufruf von Formular 1/7 bekannt sein:
        piov_haus_lfd_nr := coalesce(piov_haus_lfd_nr, '1054728'); -- (1054728)muss immer gesetzt sein, sonst erfolgt Rücksprung zur Adresssuche 

        piov_strav_strasse := coalesce(piov_strav_strasse, 'Marconistr.');
        piov_strav_hausnr := coalesce(piov_strav_hausnr, '16');
        piov_strav_hausnr_zusatz := coalesce(piov_strav_hausnr_zusatz, 'Z');
        piov_strav_plz := coalesce(piov_strav_plz, '50769');
        piov_strav_ort := coalesce(piov_strav_ort, 'Köln');

    --@krakar @ticket FTTH-4622
        piov_strav_adresse_komplett := coalesce(piov_strav_adresse_komplett, 'Marconistr. 16Z, 50769 Köln (Worringen)');
        piov_kundenstatus := coalesce(piov_kundenstatus, neukunde); 

    ------------------------------------- 
    -- Step 1: 
    ------------------------------------- 

        if pin_step in ( 1, 7 ) then
            if pib_ausfuellen then
                piov_aktion := coalesce(piov_aktion, '2024-09'); -- Rabattaktion 20204, war: NetSpeed Glasfaser 2023 
        --  piov_vkz                        := COALESCE(piov_vkz, 'ECOWBS036'); -- ^[A-Z]{6}[0-9A-Z]{3}$
                                                                                -- Verfügbar auf NMCE: von ECOWBS034 bis ECOWBS044
        -- @ticket FTTH-5048: Das bisher verwendete VKZ ist nunmehr ungültig, nimm irgendein anderes aus V_SIEBEL_VKZ:
                piov_vkz := 'CCNESUD10';
                piov_mandant := coalesce(piov_mandant, 'NC');
                piov_vc_min_bandbreite := coalesce(piov_vc_min_bandbreite, '100');
                piov_vc_max_bandbreite := coalesce(piov_vc_max_bandbreite, '1000');
                piov_produkt := coalesce(piov_produkt, 'ftth-factory-'
                                                       || piov_aktion
                                                       || '-phone-tv-1000'); -- GF Kombipaket Internet+Telefon+IPTV 1000M 
                piov_router_auswahl := coalesce(piov_router_auswahl, 'PREMIUM'); -- PREMIUM, BYOD 
                piov_router_eigentum :=
                    case piov_router_auswahl
                        when 'PREMIUM' then
                            'BUY'
                        else null
                    end; -- BUY, RENT 
                piov_ont_provider := coalesce(piov_ont_provider, 'NONE'); --@ticket @ticket FTTH-5008 nach Versionierung bereit zur  -- vorher Netcologne
                piov_einrichtungsservice := coalesce(piov_einrichtungsservice, 'NETSTART'); -- NETSTART, NONE 
                piov_rolle := coalesce(piov_rolle, 'TENANT'); -- TENANT, OWNER, PART_OWNER 
                piov_anzahl_we := coalesce(piov_anzahl_we, 'ONE');    -- ONE, MORE_THAN_ONE 
                piov_anschluss_kostenpflichtig := coalesce(piov_anschluss_kostenpflichtig, 'nein');   -- ja, nein 
                piov_kosten_hausanschluss := coalesce(piov_kosten_hausanschluss, '0');
            elsif not pib_ausfuellen then
                piov_aktion := null;
                piov_vkz := null;
                piov_mandant := null;
                piov_vc_min_bandbreite := null;
                piov_vc_max_bandbreite := null;
                piov_produkt := null;
                piov_router_auswahl := null;
                piov_router_eigentum := null;
                piov_einrichtungsservice := null;
                piov_rolle := null;
                piov_anzahl_we := null;
                piov_anschluss_kostenpflichtig := null;
                piov_kosten_hausanschluss := null;
            end if;
        end if; 

    ------------------------------------- 
    -- Step 2: 
    ------------------------------------- 

        if pin_step in ( 2, 7 ) then
            if pib_ausfuellen then
                if piov_kundenstatus = neukunde then
                    piov_neukunde_anrede := coalesce(piov_neukunde_anrede, 'MISTER');
                    piov_neukunde_titel := coalesce(piov_neukunde_titel, '');                 -- Dr., Prof., Dr.med. ... 
                    piov_neukunde_vorname := coalesce(piov_neukunde_vorname, 'Philipp');
                    piov_neukunde_nachname := coalesce(piov_neukunde_nachname, 'Dahlem');
                    piod_neukunde_geburtsdatum := coalesce(piod_neukunde_geburtsdatum, date '2000-01-01');
                    piov_neukunde_soho := coalesce(piov_neukunde_soho, 'true'); -- true, false 
                    piov_neukunde_firmenname := coalesce(piov_neukunde_firmenname, 'WHEN OTHERS');
                    piov_neukunde_email := coalesce(piov_neukunde_email, 'philipp.dahlem@netcologne.com');
                    piov_neukunde_vorwahl := coalesce(piov_neukunde_vorwahl, '49');
                    piov_neukunde_rufnummer := coalesce(piov_neukunde_rufnummer, '123 456789');
                    piov_neukunde_iban := coalesce(piov_neukunde_iban, 'DE02600501010002034304'); -- siehe Package Body UT_IBAN
                                                -- COALESCE(piov_neukunde_iban, 'DE11370501980002462950'); -- aus dem NetCologne Impressum 
                    piov_neukunde_abw_kontoinhaber := coalesce(piov_neukunde_abw_kontoinhaber, 'J'); -- J, N 
                    piov_neukunde_kontoinhaber := coalesce(piov_neukunde_kontoinhaber, 'Herbert Feuerstein');
                    piov_neukunde_sepamandat :=
                        case piov_neukunde_abw_kontoinhaber
                            when 'N' then
                                'J'
                            when 'J' then
                                'N'
                            else 'J'
                        end;
                    piov_neukunde_abw_kontoinhaber := '1';
                    piov_neukunde_kontoinhaber := 'Hans im Glück';
                end if;

            elsif not pib_ausfuellen then
                piov_neukunde_anrede := null;
                piov_neukunde_titel := null;
                piov_neukunde_vorname := null;
                piov_neukunde_nachname := null;
                piod_neukunde_geburtsdatum := null;
                piov_neukunde_soho := null;
                piov_neukunde_firmenname := null;
                piov_neukunde_email := null;
                piov_neukunde_vorwahl := null;
                piov_neukunde_rufnummer := null;
                piov_neukunde_iban := null;
                piov_neukunde_abw_kontoinhaber := null;
                piov_neukunde_kontoinhaber := null;
                piov_neukunde_sepamandat := null;
            end if;
        end if; 

    ------------------------------------- 
    -- Step 3: 
    ------------------------------------- 

        if pin_step in ( 3, 7 ) then
            if pib_ausfuellen then
                if piov_kundenstatus = bestandskunde then
                    piov_siebel_kundennummer := coalesce(piov_siebel_kundennummer, '10960618'); -- 13009180 
                    piov_siebel_message := coalesce(piov_siebel_message, '');
                    piov_siebel_global_id := coalesce(piov_siebel_global_id, 'account-269433460');
                    piov_siebel_anrede := coalesce(piov_siebel_anrede, 'Frau');
                    piov_siebel_titel := coalesce(piov_siebel_titel, 'Prof.');
                    piov_siebel_vorname := coalesce(piov_siebel_vorname, 'Susanne');
                    piov_siebel_nachname := coalesce(piov_siebel_nachname, 'Wilhelm');
                    piod_siebel_geburtsdatum := coalesce(piod_siebel_geburtsdatum, date '1969-11-26');
                    piov_siebel_firmenname := coalesce(piov_siebel_firmenname, 'ACME GmbH');
                    piov_siebel_strasse := coalesce(piov_siebel_strasse, 'Eschweilerstr. 17');
                    piov_siebel_plz_ort := coalesce(piov_siebel_plz_ort, '50933 Köln');
                    piov_siebel_ap_email := 'test@netcologne.de'; -- COALESCE(piov_siebel_ap_email, 'test@netcologne.de'); 
                    piov_siebel_ap_mobil_vorwahl := '49'; -- COALESCE(piov_siebel_ap_mobil_vorwahl, '49'); 
                    piov_siebel_ap_mobil_rufnummer := coalesce(piov_siebel_ap_mobil_rufnummer, '1577 99999');
                end if;

            elsif not pib_ausfuellen then
                piov_siebel_kundennummer := null;
                piov_siebel_message := null;
                piov_siebel_global_id := null;
                piov_siebel_anrede := null;
                piov_siebel_titel := null;
                piov_siebel_vorname := null;
                piov_siebel_nachname := null;
                piod_siebel_geburtsdatum := null;
                piov_siebel_firmenname := null;
                piov_siebel_strasse := null;
                piov_siebel_plz_ort := null;
                piov_siebel_ap_email := null;
                piov_siebel_ap_mobil_vorwahl := null;
                piov_siebel_ap_mobil_rufnummer := null;
            end if;
        end if; 


    ------------------------------------- 
    -- Step 4: 
    ------------------------------------- 


    ------------------------------------- 
    -- Step 5: 
    ------------------------------------- 

        if pin_step in ( 5, 7 ) then
            case pib_ausfuellen
                when true then -- nur für 'Neukunden auszufüllen!
                    pon_wohnt_dort := coalesce(pon_wohnt_dort, 1); -- 0|1, beeinflusst die Anzeige der Wohndauer: 
                    piov_wohndauer := coalesce(piov_wohndauer, 'RESIDENT_LESS_THAN_SIX_MONTHS'); -- NO_RESIDENT, RESIDENT_LESS_THAN_SIX_MONTHS, RESIDENT_SIX_OR_MORE_MONTHS 
                    piov_voradresse_plz := coalesce(piov_voradresse_plz, '41539');
                    piov_voradresse_ort := coalesce(piov_voradresse_ort, 'Dormagen');
                    piov_voradresse_strasse := coalesce(piov_voradresse_strasse, 'Adolf-Kolping-Str.');
                    piov_voradresse_hausnr := coalesce(piov_voradresse_hausnr, '1');
                    pon_abw := coalesce(pon_abw, 1);
                    piov_bisheriger_anbieter := coalesce(piov_bisheriger_anbieter, 'TELEKOM');
                    pon_rufnummernmitnahme := coalesce(pon_rufnummernmitnahme, 1);
                    piov_abw_vorwahl := coalesce(piov_abw_vorwahl, '0123');
                    piov_abw_rufnummer := coalesce(piov_abw_rufnummer, '456789');
                    piov_abw_anschlussinhaber := coalesce(piov_abw_anschlussinhaber, 1);
                    piov_abw_anrede := coalesce(piov_abw_anrede, 'MISTER');
                    piov_abw_vorname := coalesce(piov_abw_vorname, 'Max');
                    piov_abw_nachname := coalesce(piov_abw_nachname, 'Mustermann');
                when false then
                    pon_wohnt_dort := null;
                    piov_wohndauer := null;
                    piov_voradresse_plz := '';
                    piov_voradresse_ort := '';
                    piov_voradresse_strasse := '';
                    piov_voradresse_hausnr := '';
                    pon_abw := null;
                    piov_bisheriger_anbieter := null;
                    pon_rufnummernmitnahme := null;
                    piov_abw_vorwahl := null;
                    piov_abw_rufnummer := null;
                    piov_abw_anschlussinhaber := null;
                    piov_abw_anrede := null;
                    piov_abw_vorname := null;
                    piov_abw_nachname := null;
                else
                    null; -- IN := OUT 
            end case;
        end if; 

    ------------------------------------- 
    -- Step 6: 
    ------------------------------------- 
        if pin_step in ( 6, 7 ) then
            if pib_ausfuellen then
                piov_rolle := coalesce(piov_rolle, 'TENANT'); -- sonst würde überhaupt keine Region angezeigt
                piov_gee_kontaktdaten_bekannt := coalesce(piov_gee_kontaktdaten_bekannt, c_ja);
                piov_gee_rechtsform := coalesce(piov_gee_rechtsform, 'COMMUNITY_OF_HEIRS'); -- BUSINESS|COMMUNITY_OF_OWNERS|COMMUNITY_OF_HEIRS|PRIVATE_CITIZEN
                piov_gee_firma := coalesce(piov_gee_firma, 'ACME Erbengemeinschaft');
                piov_gee_anrede := coalesce(piov_gee_anrede, 'MISTER');
                piov_gee_titel := coalesce(piov_gee_titel, 'Dr.');
                piov_gee_vorname := coalesce(piov_gee_vorname, 'John');
                piov_gee_nachname := coalesce(piov_gee_nachname, 'Doe');
                piov_gee_land := coalesce(piov_gee_land, 'Deutschland');
                piov_gee_plz := coalesce(piov_gee_plz, '12345');
                piov_gee_ort := coalesce(piov_gee_ort, 'Testdorf');
                piov_gee_strasse := coalesce(piov_gee_strasse, 'Beispielstraße');
                piov_gee_hausnr := coalesce(piov_gee_hausnr, '42');
                piov_gee_hausnr_zusatz := coalesce(piov_gee_hausnr_zusatz, 'a-o');
                piov_gee_email := coalesce(piov_gee_email, 'test@test.de');
                piov_gee_vorwahl := coalesce(piov_gee_vorwahl, '49');
                piov_gee_rufnummer := coalesce(piov_gee_rufnummer, '0123 456789');
                piov_gee_informationspflicht := coalesce(piov_gee_informationspflicht, c_ja);
            elsif not pib_ausfuellen then
                piov_gee_kontaktdaten_bekannt := '';
                piov_gee_rechtsform := '';
                piov_gee_firma := '';
                piov_gee_anrede := '';
                piov_gee_titel := '';
                piov_gee_vorname := '';
                piov_gee_nachname := '';
                piov_gee_land := '';
                piov_gee_plz := '';
                piov_gee_ort := '';
                piov_gee_strasse := '';
                piov_gee_hausnr := '';
                piov_gee_hausnr_zusatz := '';
                piov_gee_email := '';
                piov_gee_vorwahl := '';
                piov_gee_rufnummer := '';
                piov_gee_informationspflicht := '';
            end if;
        end if;

    ------------------------------------- 
    -- Step 7: Ausfüllen der Übersicht, so dass beliebige Auftragsdaten getestet werden können
    ------------------------------------- 
        if pin_step = 7 then
            null;
        end if;
    end goto_step; 

/**
 * Ermöglicht es (per Button-Klick), auf der Übersichtsseite die Items, die noch keinen Wert haben,
 * mit Testwerten auszufüllen.
 */
    procedure step_7_ausfuellen (
        piv_profilname                     in varchar2
    ----------------------------------------------------------------  
        ,
        piov_haus_lfd_nr                   in out integer,
        piov_kundenstatus                  in out varchar2 -- "N"eukunde, "B"estandskunde 
 --   , piov_installationsadresse_strasse              IN OUT VARCHAR2
 --   , piov_installationsadresse_hausnr               IN OUT VARCHAR2
 --   , piov_installationsadresse_hausnr_zusatz        IN OUT VARCHAR2
 --   , piov_installationsadresse_plz                  IN OUT VARCHAR2
 --   , piov_installationsadresse_ort                  IN OUT VARCHAR2
        ,
        piov_installationsadresse_komplett in out varchar2 -- @krakar @ticket FTTH-4622
        ,
        piov_vc_status                     in out varchar2,
        piod_vc_ausbau_plan_termin         in out date   
    -- Step 1: 
        ,
        piov_aktion                        in out varchar2,
        piov_vkz                           in out varchar2,
        piov_mandant                       in out varchar2,
        piov_produkt                       in out varchar2,
        piov_router_auswahl                in out varchar2,
        piov_router_eigentum               in out varchar2,
        piov_ont_provider                  in out varchar2 --@ticket @ticket FTTH-5008 nach Versionierung bereit zur Entfernung
        ,
        piov_einrichtungsservice           in out varchar2,
        piov_gee_rolle                     in out varchar2,
        piov_gee_anzahl_we                 in out varchar2 
    -- Step 2, 3: 
        ,
        piov_kunde_anrede                  in out varchar2,
        piov_kunde_titel                   in out varchar2,
        piov_kunde_vorname                 in out varchar2,
        piov_kunde_nachname                in out varchar2,
        piod_kunde_geburtsdatum            in out date,
        piov_kunde_soho                    in out varchar2,
        piov_kunde_firmenname              in out varchar2,
        piov_kunde_email                   in out varchar2,
        piov_kunde_vorwahl                 in out varchar2,
        piov_kunde_rufnummer               in out varchar2,
        piov_kunde_iban                    in out varchar2,
        piov_kunde_kontoinhaber            in out varchar2,
        piov_kunde_sepamandat              in out varchar2,
        piov_kundennummer                  in out varchar2 
    -- Step 5: 
        ,
        piov_wohnt_dort                    in out varchar2,
        piov_wohndauer                     in out varchar2,
        pion_abw                           in out integer,
        piov_abw_bisheriger_anbieter       in out varchar2,
        pion_abw_rufnummernmitnahme        in out integer,
        piov_abw_vorwahl                   in out varchar2,
        piov_abw_rufnummer                 in out varchar2,
        piov_abw_anschlussinhaber          in out varchar2,
        piov_abw_anrede                    in out varchar2,
        piov_abw_vorname                   in out varchar2,
        piov_abw_nachname                  in out varchar2,
        piov_voradresse_plz                in out varchar2,
        piov_voradresse_ort                in out varchar2,
        piov_voradresse_strasse            in out varchar2,
        piov_voradresse_hausnr             in out varchar2 
    -- Step 6:
        ,
        piov_gee_kontaktdaten_bekannt      in out varchar2,
        piov_gee_rechtsform                in out varchar2,
        piov_gee_firma                     in out varchar2,
        piov_gee_anrede                    in out varchar2,
        piov_gee_titel                     in out varchar2,
        piov_gee_vorname                   in out varchar2,
        piov_gee_nachname                  in out varchar2,
        piov_gee_land                      in out varchar2,
        piov_gee_plz                       in out varchar2,
        piov_gee_ort                       in out varchar2,
        piov_gee_strasse                   in out varchar2,
        piov_gee_hausnr                    in out varchar2,
        piov_gee_hausnr_zusatz             in out varchar2,
        piov_gee_email                     in out varchar2,
        piov_gee_vorwahl                   in out varchar2,
        piov_gee_rufnummer                 in out varchar2,
        piov_gee_informationspflicht       in out varchar2
    ) is
    begin
        case piv_profilname
            when 'BLANK' then
                piov_haus_lfd_nr := null;
                piov_kundenstatus := null;
    --  piov_installationsadresse_strasse        := NULL;
    --  piov_installationsadresse_hausnr         := NULL;
    --  piov_installationsadresse_hausnr_zusatz  := NULL;
    --  piov_installationsadresse_plz            := NULL;
    --  piov_installationsadresse_ort            := NULL;
                piov_installationsadresse_komplett := null; -- @krakar @ticket FTTH-4622
                piov_vc_status := null;
                piod_vc_ausbau_plan_termin := null;
      -- Daten aus Step 1:
                piov_aktion := null;
                piov_vkz := null;
                piov_mandant := null;
                piov_produkt := null;
                piov_router_auswahl := null;
                piov_router_eigentum := null;
                piov_ont_provider := null; --@ticket @ticket FTTH-5008 nach Versionierung bereit zur Entfernung
                piov_einrichtungsservice := null;
                piov_gee_rolle := null;
                piov_gee_anzahl_we := null;
      -- Daten aus Step 2:
                piov_kunde_anrede := null;
                piov_kunde_titel := null;
                piov_kunde_vorname := null;
                piov_kunde_nachname := null;
                piod_kunde_geburtsdatum := null;
                piov_kunde_soho := null;
                piov_kunde_firmenname := null;
                piov_kunde_email := null;
                piov_kunde_vorwahl := null;
                piov_kunde_rufnummer := null;
                piov_kunde_iban := null;
                piov_kunde_kontoinhaber := null;
                piov_kunde_sepamandat := null;
      -- Daten aus Step 3:
                piov_kundennummer := null;
      -- Daten aus Step 5:
                piov_wohnt_dort := null;
                piov_wohndauer := null;
                pion_abw := null;
                piov_abw_bisheriger_anbieter := null;
                pion_abw_rufnummernmitnahme := null;
                piov_abw_vorwahl := null;
                piov_abw_rufnummer := null;
                piov_abw_anschlussinhaber := null;
                piov_abw_anrede := null;
                piov_abw_vorname := null;
                piov_abw_nachname := null;
                piov_voradresse_plz := null;
                piov_voradresse_ort := null;
                piov_voradresse_strasse := null;
                piov_voradresse_hausnr := null;
      -- Daten aus Step 6:
                piov_gee_kontaktdaten_bekannt := null;
                piov_gee_rechtsform := null;
                piov_gee_firma := null;
                piov_gee_anrede := null;
                piov_gee_titel := null;
                piov_gee_vorname := null;
                piov_gee_nachname := null;
                piov_gee_land := null;
                piov_gee_plz := null;
                piov_gee_ort := null;
                piov_gee_strasse := null;
                piov_gee_hausnr := null;
                piov_gee_hausnr_zusatz := null;
                piov_gee_email := null;
                piov_gee_vorwahl := null;
                piov_gee_rufnummer := null;
                piov_gee_informationspflicht := null;
            else -- anderer Profilname oder leer

                piov_haus_lfd_nr := coalesce(piov_haus_lfd_nr, '2280201'); -- darf keine Fantasie-Nummer sein
                piov_kundenstatus := coalesce(piov_kundenstatus, bestandskunde);
    --  piov_installationsadresse_strasse        := COALESCE(piov_installationsadresse_strasse, 'Am Coloneum');
    --  piov_installationsadresse_hausnr         := COALESCE(piov_installationsadresse_hausnr, '9');
    --  piov_installationsadresse_hausnr_zusatz  := COALESCE(piov_installationsadresse_hausnr_zusatz, '(Kantineneingang)');
    --  piov_installationsadresse_plz            := COALESCE(piov_installationsadresse_plz, '50829');
    --  piov_installationsadresse_ort            := COALESCE(piov_installationsadresse_ort, 'Köln-Ossendorf');
                piov_installationsadresse_komplett := coalesce(piov_installationsadresse_komplett, 'Am Coloneum 9, 50829 Köln (Ossendorf)'
                ); --@krakar @ticket FTTH-4622
                piov_vc_status := coalesce(piov_vc_status, 'UNDERCONSTRUCTION');
                piod_vc_ausbau_plan_termin := coalesce(piod_vc_ausbau_plan_termin, date '2024-12-31');
      -- Daten aus Step 1:
                piov_aktion := coalesce(piov_aktion, '2023-09'); -- NetSpeed Glasfaser 2023
                piov_vkz := coalesce(piov_vkz, 'TESTXY123');
                piov_mandant := coalesce(piov_mandant, 'NC');
                piov_produkt := coalesce(piov_produkt, 'ftth-factory-2023-09-phone-tv-1000');
                piov_router_auswahl := coalesce(piov_router_auswahl, 'PREMIUM');
                piov_router_eigentum := coalesce(piov_router_eigentum, 'RENT');
                piov_ont_provider := coalesce(piov_ont_provider, 'BYOD'); -- NONE|NETCOLOGNE|BYOD --@ticket @ticket FTTH-5008 nach Versionierung bereit zur Entfernung
                piov_einrichtungsservice := coalesce(piov_einrichtungsservice, 'NETSTART'); -- wieso ist //// NETSTART_PLUS (nicht verfügbar!)?
                piov_gee_rolle := coalesce(piov_gee_rolle, 'TENANT');
                piov_gee_anzahl_we := coalesce(piov_gee_anzahl_we, 'ONE');
      -- Daten aus Step 2:
                piov_kunde_anrede := coalesce(piov_kunde_anrede, 'MISTER');
                piov_kunde_titel := coalesce(piov_kunde_titel, 'Dr.');
                piov_kunde_vorname := coalesce(piov_kunde_vorname, 'Willy B.');
                piov_kunde_nachname := coalesce(piov_kunde_nachname, 'Winzig');
                piod_kunde_geburtsdatum := coalesce(piod_kunde_geburtsdatum, date '1980-01-01');
                piov_kunde_soho := coalesce(piov_kunde_soho, ''); -- //// wofür?
                piov_kunde_firmenname := coalesce(piov_kunde_firmenname, 'Ich AG GmbH');
                piov_kunde_email := coalesce(piov_kunde_email, 'willy.b.winzig@netcologne.de');
                piov_kunde_vorwahl := coalesce(piov_kunde_vorwahl, '49');
                piov_kunde_rufnummer := coalesce(piov_kunde_rufnummer, '02131 669952');
                piov_kunde_iban := coalesce(piov_kunde_iban, 'DE89 3704 0044 0532 0130 00'); -- //// was passiert bei Leerstellen?
                piov_kunde_kontoinhaber := coalesce(piov_kunde_kontoinhaber, 'Karl Krummgeschäft');
                piov_kunde_sepamandat := coalesce(piov_kunde_sepamandat, '1');
      -- Daten aus Step 3:
                piov_kundennummer := coalesce(piov_kundennummer, '123456789');
      -- SIEBEL-AP-Kontaktdaten werden zu Kunden-Kontaktdaten, korrekt? ////
      -- Daten aus Step 5:
                piov_wohnt_dort := coalesce(piov_wohnt_dort, '0'); -- 1|0
                piov_wohndauer := coalesce(piov_wohndauer, 'NO_RESIDENT');  -- NO_RESIDENT|RESIDENT_LESS_THAN_SIX_MONTHS|RESIDENT_SIX_OR_MORE_MONTHS
                pion_abw := coalesce(pion_abw, '1'); -- 1|0, Anbieterwechsel
                piov_abw_bisheriger_anbieter := coalesce(piov_abw_bisheriger_anbieter, 'Schützenverein Köln-Nippes "Die Strippenzieher"'
                );
                pion_abw_rufnummernmitnahme := coalesce(pion_abw_rufnummernmitnahme, '1');
                piov_abw_vorwahl := coalesce(piov_abw_vorwahl, '49');
                piov_abw_rufnummer := coalesce(piov_abw_rufnummer, '0123');
                piov_abw_anschlussinhaber := coalesce(piov_abw_anschlussinhaber, '1');
                piov_abw_anrede := coalesce(piov_abw_anrede, 'MISS');
                piov_abw_vorname := coalesce(piov_abw_vorname, 'Antonia');
                piov_abw_nachname := coalesce(piov_abw_nachname, 'Hofreiter');
                piov_voradresse_plz := coalesce(piov_voradresse_plz, '12345');
                piov_voradresse_ort := coalesce(piov_voradresse_ort, 'Pusemuckel');
                piov_voradresse_strasse := coalesce(piov_voradresse_strasse, 'Erfolgsweg');
                piov_voradresse_hausnr := coalesce(piov_voradresse_hausnr, '1');
      -- Daten aus Step 6:
                piov_gee_kontaktdaten_bekannt := coalesce(piov_gee_kontaktdaten_bekannt, '1');
                piov_gee_rechtsform := coalesce(piov_gee_rechtsform, 'COMMUNITY_OF_OWNERS'); -- PRIVATE_CITIZEN|BUSINESS|COMMUNITY_OF_OWNERS|COMMUNITY_OF_HEIRS
                piov_gee_firma := coalesce(piov_gee_firma,
                                           'Vielzulangerfirmenname Reibach GmbH '
                                           || chr(38)
                                           || ' Co. KG');

                piov_gee_anrede := coalesce(piov_gee_anrede, 'MISS');
                piov_gee_titel := coalesce(piov_gee_titel, 'Prof.');
                piov_gee_vorname := coalesce(piov_gee_vorname, 'Karla');
                piov_gee_nachname := coalesce(piov_gee_nachname, 'Konfetti');
                piov_gee_land := coalesce(piov_gee_land, 'Deutschland');
                piov_gee_plz := coalesce(piov_gee_plz, '41564');
                piov_gee_ort := coalesce(piov_gee_ort, 'Kaarst');
                piov_gee_strasse := coalesce(piov_gee_strasse, 'Hirschstraße');
                piov_gee_hausnr := coalesce(piov_gee_hausnr, '10');
                piov_gee_hausnr_zusatz := coalesce(piov_gee_hausnr_zusatz, 'Ergeschoss');
                piov_gee_email := coalesce(piov_gee_email, 'karla.konfetti.test@netcologne.de');
                piov_gee_vorwahl := coalesce(piov_gee_vorwahl, '49'); -- //// durch Benennung in der App klarstellen, dass Ländervorwahl gemeint ist
                piov_gee_rufnummer := coalesce(piov_gee_rufnummer, '0221 1234567');
                piov_gee_informationspflicht := coalesce(piov_gee_informationspflicht, '1');
        end case;
    end step_7_ausfuellen;



-- @progress 2024-04-11

 -- @ticket FTTH-2829

 /**
  * Nimmt die für eine Glascontainer-Vorbestellung erforderlichen,
  * bereits validierten Angaben und gibt diese als JSON-Body 
  * für den Webservice-Aufruf zurück
  *
  */
    function fj_internal_order ( 
     --- "Determinanten": von diesen Argumenten hängen diverse Ausprägungen des JSON-Bodies ab:
        piv_app_user                                                  in varchar2 -- @todo 2024-08-06: Der Username wird im JSON nicht benötigt => Parameter entfernen
        ,
        piv_vkz                                                       in varchar2,
        piv_kundenstatus                                              in varchar2,
        piv_gee_kontaktdaten_bekannt                                  in varchar2 -- 1|0
        ,
        piv_propertyownerdeclaration_propertyownerrole                in varchar2 -- 'TENANT|OWNER|PART_OWNER'
        ,
        piv_abw_anschlussinhaber                                      in varchar2 -- 1|0
     --- Gesammelte Daten, können je nach Determinanten leer sein:
        ,
        piv_customernumber                                            in varchar2,
        piv_customer_businessname                                     in varchar2,
        piv_customer_salutation                                       in varchar2,
        piv_customer_name_first                                       in varchar2,
        piv_customer_name_last                                        in varchar2,
        pid_customer_birthdate                                        in date,
        piv_customer_email                                            in varchar2,
        piv_customer_residentstatus                                   in varchar2,
        piv_customer_phonenumber_countrycode                          in varchar2,
        piv_customer_phonenumber_number                               in varchar2,
        piv_customer_title                                            in varchar2,
        piv_customer_previousaddress_zipcode                          in varchar2,
        piv_customer_previousaddress_city                             in varchar2,
        piv_customer_previousaddress_street                           in varchar2,
        piv_customer_previousaddress_housenumber                      in varchar2
     -- @ticket FTTH-4158: Für diese Hausnummer gibt es keinen postalischen Zusatz, 
     -- sondern der muss in diesem Fall ins Hausnummernfeld eingetragen werden
        ,
        piv_client                                                    in varchar2,
        piv_installation_address_zipcode                              in varchar2,
        piv_installation_address_city                                 in varchar2,
        piv_installation_address_street                               in varchar2,
        piv_installation_address_housenumber                          in varchar2 -- @ticket FTTH-4158: Parameter hinzugefügt
        ,
        piv_installation_address_postal_addition                      in varchar2,
        piv_houseserialnumber                                         in varchar2,
        piv_providerchange_currentprovider                            in varchar2,
        pib_providerchange_keepcurrentlandlinenumber                  in boolean,
        piv_providerchange_landlinephonenumber_countrycode            in varchar2,
        piv_providerchange_landlinephonenumber_areacode               in varchar2,
        piv_providerchange_landlinephonenumber_number                 in varchar2,
        piv_providerchange_contractownersalutation                    in varchar2,
        piv_providerchange_contractownername_first                    in varchar2,
        piv_providerchange_contractownername_last                     in varchar2
     ---
        ,
        piv_accountdetails_accountholder                              in varchar2,
        piv_accountdetails_iban                                       in varchar2
     ---
        ,
        piv_propertyownerdeclaration_residentialunit                  in varchar2,
        piv_propertyownerdeclaration_landlord_legalform               in varchar2,
        piv_propertyownerdeclaration_landlord_businessorname          in varchar2,
        piv_propertyownerdeclaration_landlord_address_zipcode         in varchar2,
        piv_propertyownerdeclaration_landlord_address_city            in varchar2,
        piv_propertyownerdeclaration_landlord_address_street          in varchar2,
        piv_propertyownerdeclaration_landlord_address_housenumber     in varchar2,
        piv_propertyownerdeclaration_landlord_address_postaladdition  in varchar2,
        piv_propertyownerdeclaration_landlord_address_country         in varchar2,
        piv_propertyownerdeclaration_landlord_email                   in varchar2,
        piv_propertyownerdeclaration_landlord_phonenumber_countrycode in varchar2,
        piv_propertyownerdeclaration_landlord_phonenumber_number      in varchar2,
        piv_propertyownerdeclaration_landlord_salutation              in varchar2,
        piv_propertyownerdeclaration_landlord_title                   in varchar2,
        piv_propertyownerdeclaration_landlord_name_first              in varchar2,
        piv_propertyownerdeclaration_landlord_name_last               in varchar2,
        pib_propertyownerdeclaration_landlordagreedtobecontacted      in boolean
     ---
        ,
        piv_productrequest_templateid                                 in varchar2,
        piv_productrequest_devicecategory                             in varchar2,
        piv_productrequest_deviceownership                            in varchar2,
        piv_productrequest_installationservice                        in varchar2,
        piv_productrequest_ontprovider                                in varchar2 --@ticket @ticket FTTH-5008 nach Versionierung bereit zur Entfernung
     ---
        ,
        pib_summary_generaltermsandconditions                         in boolean,
        pib_summary_waiverightofrevocation                            in boolean
     ---
        ,
        piv_expansionstatus                                           in varchar2,
        pid_availabilitydate                                          in date,
        piv_createdby                                                 in varchar2,
        pib_isduplicate                                               in boolean,
        piv_update_cus_in_siebel                                      in varchar2  --@ticket: FTTH-5228
    ) return clob is
/* Stand 2024-08-05:
{
  "vkz": "string",
  "customerNumber": "string",
  "customer": {
    "businessName": "string",
    "salutation": "MISS",
    "title": "string",
    "name": {
      "first": "string",
      "last": "string"
    },
    "birthDate": "2024-08-06",
    "email": "string",
    "residentStatus": "NO_RESIDENT",
    "previousAddress": {
      "street": "string",
      "houseNumber": "string",
      "zipCode": "string",
      "city": "string",
      "postalAddition": "string",
      "country": "string"
    },
    "phoneNumber": {
      "countryCode": "string",
      "areaCode": "strin",
      "number": "string"
    },
    "password": "string"
  },
  "client": "NC",
  "customerUpdate": {
    "email": "string",
    "phoneNumber": {
      "countryCode": "string",
      "areaCode": "strin",
      "number": "string"
    },
    "updateCustomerInSiebel": true
  },
  "installation": {
    "address": {
      "street": "string",
      "houseNumber": "string",
      "zipCode": "string",
      "city": "string",
      "postalAddition": "string",
      "country": "string"
    },
    "houseSerialNumber": 0
  },
  "providerChange": {
    "currentProvider": "string",
    "keepCurrentLandlineNumber": true,
    "landlinePhoneNumber": {
      "countryCode": "string",
      "areaCode": "strin",
      "number": "string"
    },
    "currentContractCancelled": true,
    "cancellationDate": "2024-08-06",
    "contractOwnerSalutation": "MISS",
    "contractOwnerName": {
      "first": "string",
      "last": "string"
    }
  },
  "accountDetails": {
    "accountHolder": "string",
    "iban": "string"
  },
  "propertyOwnerDeclaration": {
    "propertyOwnerRole": "TENANT",
    "residentialUnit": "ONE",
    "landlord": {
      "legalForm": "PRIVATE_CITIZEN",
      "businessOrName": "string",
      "salutation": "MISS",
      "title": "string",
      "name": {
        "first": "string",
        "last": "string"
      },
      "address": {
        "street": "string",
        "houseNumber": "string",
        "zipCode": "string",
        "city": "string",
        "postalAddition": "string",
        "country": "string"
      },
      "email": "string",
      "phoneNumber": {
        "countryCode": "string",
        "areaCode": "strin",
        "number": "string"
      }
    }
  },
  "summary": {
    "generalTermsAndConditions": true,
    "waiveRightOfRevocation": true
  },
  "expansionStatus": "AREA_PLANNED",
  "availabilityDate": "2024-08-06",
  "productRequest": {
    "templateId": "string",
    "deviceCategory": "PREMIUM",
    "deviceOwnership": "BUY",
    "installationService": "NONE",
    "download": 0,
    "upload": 0,
    "name": "string",
    "siebelPriceListName": "string",
    "ontProvider": "NETCOLOGNE"
  },
  "createdBy": "string",
  "isDuplicate": true
}
*/

        vj_body                       json_object_t := new json_object_t(c_empty_json);
        v_keep_cur_line_nr            varchar2(10 char);
        c_is_neukunde                 constant boolean := piv_kundenstatus = neukunde;
        c_is_bestandskunde            constant boolean := not c_is_neukunde;
        c_installationsadresse_senden constant boolean := false; -- @ticket FTTH-4622, FTTH-4888, CR-3030: 
                                                                -- -- /////@todo Nach Implementierung entfernen!
                                                                -- Stand 2025-02-18: FALSE läuft im Backend auf einen Fehler,
                                                                -- FALSE wird erst mit Release 85 (März 2025) funktionieren.
                                                                -- @date 2025-04-01: Auf FALSE gesetzt. Ein paar Wochen lang produktiv überwachen,
                                                                -- bei Erfolg den entsprechenden Code entfernen.
    begin
        vj_body.put('vkz', piv_vkz);

    -- nur Bestandskunden haben eine Kundennummer:
        if c_is_bestandskunde then
            vj_body.put('customerNumber', piv_customernumber);
        end if;
        vj_body.put('client', piv_client);
        if c_is_neukunde then
            << customer >> -- Neukunde
             declare
                vj_customer             json_object_t := new json_object_t(c_empty_json);
                vj_customer_name        json_object_t := new json_object_t(c_empty_json);
                vj_customer_phonenumber json_object_t := new json_object_t(c_empty_json);
                vj_previousaddress      json_object_t := new json_object_t(c_empty_json);
            begin
                vj_customer.put('businessName', piv_customer_businessname);
                vj_customer.put('salutation', piv_customer_salutation);
                vj_customer_name.put('first', piv_customer_name_first);
                vj_customer_name.put('last', piv_customer_name_last);
                vj_customer.put('name', vj_customer_name);
                vj_customer.put('birthDate',
                                date2json(pid_customer_birthdate));
                vj_customer.put('email', piv_customer_email);
                vj_customer.put('residentStatus', piv_customer_residentstatus);
                vj_customer_phonenumber.put('countryCode', piv_customer_phonenumber_countrycode);
                vj_customer_phonenumber.put('number', piv_customer_phonenumber_number);
                vj_customer.put('phoneNumber', vj_customer_phonenumber);
                vj_customer.put('title', piv_customer_title);
        -- previousAddress nicht ausspielen, wenn in der Maske "Anbieterwechsel" 
        -- P100_WOHNT_DORT = 1 ist und P100_WOHNDAUER = RESIDENT_SIX_OR_MORE_MONTHS.
        -- Dann ist P100_WOHNDAUER entweder NULL (wenn P100_WOHNT_DORT = 0) oder RESIDENT_SIX_OR_MORE_MONTHS
                if piv_customer_residentstatus in ( 'NO_RESIDENT', 'RESIDENT_LESS_THAN_SIX_MONTHS' ) then
                    vj_previousaddress.put('zipCode', piv_customer_previousaddress_zipcode);
                    vj_previousaddress.put('city', piv_customer_previousaddress_city);
                    vj_previousaddress.put('street', piv_customer_previousaddress_street);
                    vj_previousaddress.put('houseNumber', piv_customer_previousaddress_housenumber);
                    vj_customer.put('previousAddress', vj_previousaddress);
                end if;

                vj_body.put('customer', vj_customer);
            end customer;
        elsif c_is_bestandskunde then
            << customerupdate >> -- Bestandskunde
             declare
                vj_customerupdate             json_object_t := new json_object_t(c_empty_json);
                vj_customerupdate_phonenumber json_object_t := new json_object_t(c_empty_json);
            begin
                vj_customerupdate.put('email', piv_customer_email);
                vj_customerupdate.put('residentStatus', piv_customer_residentstatus);
                vj_customerupdate.put('updateCustomerInSiebel', piv_update_cus_in_siebel);  --@ticket: FTTH-5228
                vj_customerupdate_phonenumber.put('countryCode', piv_customer_phonenumber_countrycode);
                vj_customerupdate_phonenumber.put('number', piv_customer_phonenumber_number);
                vj_customerupdate.put('phoneNumber', vj_customerupdate_phonenumber);
                vj_body.put('customerUpdate', vj_customerupdate);
            end customerupdate;
        end if;

    --- vj_body.put('client', piv_client); steht jetzt weiter oben

        << installation >> declare
            vj_installation         json_object_t := new json_object_t(c_empty_json);
            vj_installation_address json_object_t := new json_object_t(c_empty_json); -- @ticket FTTH-4888: entfernen
        begin
            if c_installationsadresse_senden then -- @ticket FTTH-4888 FTTH-4622: Diesen Block nach Implementierung entfernen
                vj_installation_address.put('zipCode', piv_installation_address_zipcode);
                vj_installation_address.put('city', piv_installation_address_city);
                vj_installation_address.put('street', piv_installation_address_street);
                vj_installation_address.put('houseNumber', piv_installation_address_housenumber); 
            -- @ticket FTTH-4158: Inzwischen gibt es diesen Parameter in der Schnittstelle
                if piv_installation_address_postal_addition is not null then
                    vj_installation_address.put('postalAddition', piv_installation_address_postal_addition);
                end if;
            -- country entfällt bei der Installationsadresse
                vj_installation.put('address', vj_installation_address);
            end if;

            vj_installation.put('houseSerialNumber', piv_houseserialnumber);
            vj_body.put('installation', vj_installation);
        end installation;

        if c_is_neukunde then
            << providerchange >>  -- Neukunde
             declare
                vc_providerchange      clob;
                vj_landlinephonenumber json_object_t := new json_object_t(c_empty_json);
            begin
        -- Bei leerem Provider ==> das gesamte Kontrukt nicht liefern!
                if piv_providerchange_currentprovider is not null then
                    if pib_providerchange_keepcurrentlandlinenumber then
                        v_keep_cur_line_nr := 'true';
                    else
                        v_keep_cur_line_nr := 'false';
                    end if;
                    vc_providerchange := pck_glascontainer.fj_provider_change(
                        pi_change_flag          => 1  -- 1= Update, 0= Delete 
                        ,
                        pi_changed_by           => null--changedBy
                        ,
                        pi_current_provider     => piv_providerchange_currentprovider --providerChange.currentProvider
                        ,
                        pi_keep_cur_line_nr     => v_keep_cur_line_nr --providerChange.keepCurrentLandlineNumber
                        ,
                        pi_phon_country_code    => piv_providerchange_landlinephonenumber_countrycode --providerChange.landlinePhoneNumber.countryCode
                        ,
                        pi_phon_area_code       => piv_providerchange_landlinephonenumber_areacode --providerChange.landlinePhoneNumber.areaCode
                        ,
                        pi_phon_number          => piv_providerchange_landlinephonenumber_number --providerChange.landlinePhoneNumber.number
                        ,
                        pi_contr_own_salutation => piv_providerchange_contractownersalutation --contractOwnerSalutation
                        ,
                        pi_contr_own_first_name => piv_providerchange_contractownername_first --contractOwnerName.first
                        ,
                        pi_contr_own_last_name  => piv_providerchange_contractownername_last --contractOwnerName.last
                        ,
                        pi_abw_anschlussinhaber => piv_abw_anschlussinhaber
                    );
                  --@ticket: FTTH-5875  Hier muessen wir leider den Wert extrahieren weil man ohne JSON_ARRAY_T gearbeitet hat
                  -- ansonsten wuerde da doppelt Providerchange drin stehen
                    select
                        json_query(vc_providerchange, '$.providerChange' returning clob without array wrapper)
                    into vc_providerchange
                    from
                        dual;

                    vj_body.put('providerChange',
                                json_object_t.parse(vc_providerchange));
                end if;
            end providerchange;
        end if;

        if piv_kundenstatus = neukunde then
            << accountdetails >> declare
                vj_accountdetails json_object_t := new json_object_t(c_empty_json);
            begin
                if piv_accountdetails_accountholder is not null then
                    vj_accountdetails.put('accountHolder', piv_accountdetails_iban);
                end if;
                vj_accountdetails.put('iban', piv_accountdetails_iban);
                vj_body.put('accountDetails', vj_accountdetails); -- //// "only set if the SEPA mandate has been given by the customer"
                                                              -- => kann ein Auftrag überhaupt ohne SEPA abgeschickt werden?
            end accountdetails;
        end if;

        << propertyownerdeclaration >> declare
            vj_propertyownerdeclaration json_object_t := new json_object_t(c_empty_json);
        begin
            vj_propertyownerdeclaration.put('propertyOwnerRole', piv_propertyownerdeclaration_propertyownerrole);
            vj_propertyownerdeclaration.put('residentialUnit', piv_propertyownerdeclaration_residentialunit);
            if piv_propertyownerdeclaration_propertyownerrole <> 'OWNER' then
                declare
                    vj_landlord             json_object_t := new json_object_t(c_empty_json);
                    vj_landlord_address     json_object_t := new json_object_t(c_empty_json);
                    vj_landlord_phonenumber json_object_t := new json_object_t(c_empty_json);
                    vj_landlord_name        json_object_t := new json_object_t(c_empty_json);
                begin
                    if piv_gee_kontaktdaten_bekannt = 1 then
                        vj_landlord.put('legalForm', piv_propertyownerdeclaration_landlord_legalform);
                        if piv_propertyownerdeclaration_landlord_legalform <> 'PRIVATE_CITIZEN' then
                            vj_landlord.put('businessOrName', piv_propertyownerdeclaration_landlord_businessorname);
                        end if;
                -- Die Felder zu den Persönlichen Daten zum Vermieter nur mitsenden, wenn dieser eine Privatperson ist
                -- (ansonsten wären diese Werte null):
                        if piv_propertyownerdeclaration_landlord_legalform = 'PRIVATE_CITIZEN' then
                            vj_landlord.put('salutation', piv_propertyownerdeclaration_landlord_salutation);
                            vj_landlord.put('title', piv_propertyownerdeclaration_landlord_title);
                            vj_landlord_name.put('first', piv_propertyownerdeclaration_landlord_name_first);
                            vj_landlord_name.put('last', piv_propertyownerdeclaration_landlord_name_last);
                            vj_landlord.put('name', vj_landlord_name);
                        end if;

                        vj_landlord_address.put('street', piv_propertyownerdeclaration_landlord_address_street);
                        vj_landlord_address.put('houseNumber', piv_propertyownerdeclaration_landlord_address_housenumber);
                        vj_landlord_address.put('zipCode', piv_propertyownerdeclaration_landlord_address_zipcode);
                        vj_landlord_address.put('city', piv_propertyownerdeclaration_landlord_address_city);
                        vj_landlord_address.put('postalAddition', piv_propertyownerdeclaration_landlord_address_postaladdition);
                        vj_landlord_address.put('country', piv_propertyownerdeclaration_landlord_address_country);
                        vj_landlord.put('address', vj_landlord_address);
                        vj_landlord.put('email', piv_propertyownerdeclaration_landlord_email);
                        vj_landlord_phonenumber.put('countryCode', piv_propertyownerdeclaration_landlord_phonenumber_countrycode);
         --     vj_landlord_phonenumber.put('areaCode', ); -- //// wird im GC nicht abgefragt: kommt zusammen mit "number"
                        vj_landlord_phonenumber.put('number', piv_propertyownerdeclaration_landlord_phonenumber_number);
                        vj_landlord.put('phoneNumber', vj_landlord_phonenumber);
                        vj_propertyownerdeclaration.put('landlord', vj_landlord);
                        vj_propertyownerdeclaration.put('landlordAgreedToBeContacted', pib_propertyownerdeclaration_landlordagreedtobecontacted
                        );
                    end if;

                end;
            end if; -- /!OWNER
            vj_body.put('propertyOwnerDeclaration', vj_propertyownerdeclaration);
        end propertyownerdeclaration;

        << productrequest >> declare
            vj_productrequest json_object_t := new json_object_t(c_empty_json);
        begin
            vj_productrequest.put('templateId', piv_productrequest_templateid);
            vj_productrequest.put('deviceCategory', piv_productrequest_devicecategory);
        -- Router-Eigentum nicht mitsenden, wenn der Router ein eigenes Gerät ist:
            if piv_productrequest_devicecategory <> 'BYOD' then
                vj_productrequest.put('deviceOwnership', piv_productrequest_deviceownership);
            end if;
            vj_productrequest.put('installationService', piv_productrequest_installationservice);
            vj_productrequest.put('ontProvider', piv_productrequest_ontprovider); --@ticket @ticket FTTH-5008 nach Versionierung bereit zur Entfernung
            vj_body.put('productRequest', vj_productrequest);
        end productrequest;

        << summary >> -- Neukunde

         declare
            vj_summary json_object_t := new json_object_t(c_empty_json);
        begin
            vj_summary.put('generalTermsAndConditions', pib_summary_generaltermsandconditions);
            vj_summary.put('waiveRightOfRevocation', pib_summary_waiverightofrevocation);
            vj_body.put('summary', vj_summary);
        end summary;

        vj_body.put('expansionStatus', piv_expansionstatus);
    -- AREA_PLANNED|PRE_MARKETING|UNDER_CONSTRUCTION|NOT_PLANNED|HOMES_PASSED|HOMES_PASSED_PLUS|HOMES_PREPARED|HOMES_READY|HOMES_CONNECTED
        vj_body.put('availabilityDate',
                    date2json(pid_availabilitydate));
        vj_body.put('createdBy',
                    substr(piv_createdby, 1, 8)); -- 2024-08-06: @prüfen //// Wegen ERIK.VOIGT: Übergangsweise den mitgesendeten Usernamen truncaten,
                                                           -- da das Backend maximal 8 Zeichen verarbeiten kann
        vj_body.put('isDuplicate',
                    coalesce(pib_isduplicate, false)); -- //// FuzzyDouble-Ergebnisse?

        return vj_body.to_clob();
    end;


/**
 * Nimmt von APEX die vor-validierten Daten der Seite "Vorbestellung erfassen" entgegen,
 * validiert noch einmal kontextsensitiv und schickt den Auftrag an den Preorderbuffer.
 *
 * @ticket FTTH-2829
 *
 * @exception   Fachliche Exceptions werden als Benutzer-lesbare Validierungen formuliert
 *              (C_PLAUSI_ERROR_NUMBER = -20002)
 * @exception   Alle technischen Exceptions werden geraised.
 *
 * @usage  Es ist davon auszugehen, dass die eingehenden Daten weitestgehend korrekt sind,
 *         daher wird beim ersten Datenfehler sofort eine Exception mit dem
 *         betreffenden Fehlertext gesendet (anstatt die gesamte Struktur
 *         komplett weiter zu prüfen und Fehlermeldungen zu sammeln)
 */
    procedure p_vorbestellung_erfassen (
        piv_app_user                           in varchar2 -- OK
        ,
        piv_vkz                                in varchar2 -- OK
        ,
        piv_kundenstatus                       in varchar2 -- N = Neukunde, B = Bestandskunde
        ,
        piv_abw                                in varchar2,
        piv_abw_anrede                         in varchar2,
        piv_abw_anschlussinhaber               in varchar2,
        piv_abw_nachname                       in varchar2,
        piv_abw_rufnummer                      in varchar2,
        piv_abw_vorname                        in varchar2,
        piv_abw_vorwahl                        in varchar2,
        piv_aktion                             in varchar2,
        piv_bisheriger_anbieter                in varchar2,
        piv_gee_eigentuemer_einverstanden      in varchar2,
        piv_gee_firma                          in varchar2,
        piv_gee_kontaktdaten_bekannt           in varchar2,
        piv_gee_titel                          in varchar2,
        piv_haus_lfd_nr                        in varchar2,
        piv_kosten_hausanschluss               in varchar2,
        piv_kunde_anrede                       in varchar2,
        piv_kunde_email                        in varchar2,
        piv_kunde_firmenname                   in varchar2,
        pid_kunde_geburtsdatum                 in date,
        piv_kunde_iban                         in varchar2,
        piv_kunde_kontoinhaber                 in varchar2,
        piv_kunde_nachname                     in varchar2,
        piv_kundennummer                       in varchar2,
        piv_kunde_rufnummer                    in varchar2,
        piv_kunde_sepamandat                   in varchar2,
        piv_kunde_soho                         in varchar2,
        piv_kunde_titel                        in varchar2,
        piv_kunde_vorname                      in varchar2,
        piv_kunde_vorwahl                      in varchar2,
        piv_mandant                            in varchar2,
        piv_mandant_display                    in varchar2
    -- neu in die Parameter aufgenommen:
        ,
        piv_wohndauer                          in varchar2,
        piv_voradresse_plz                     in varchar2,
        piv_voradresse_ort                     in varchar2,
        piv_voradresse_strasse                 in varchar2,
        piv_voradresse_hausnr                  in varchar2,
        piv_installationsadresse_plz           in varchar2,
        piv_installationsadresse_ort           in varchar2,
        piv_installationsadresse_strasse       in varchar2,
        piv_installationsadresse_hausnr        in varchar2,
        piv_installationsadresse_hausnr_zusatz in varchar2 -- @ticket FTTH-4158, neuer Parameter
    -- Anbieterwechsel:
        ,
        piv_abw_bisheriger_anbieter            in varchar2 -- OK
        ,
        piv_abw_rufnummernmitnahme             in varchar2 -- OK
        ,
        piv_abw_rufnummernmitnahme_vorwahl     in varchar2,
        piv_abw_rufnummernmitnahme_rufnummer   in varchar2
    ---
        ,
        piv_gee_rolle                          in varchar2 -- OK
        ,
        piv_gee_anzahl_we                      in varchar2,
        piv_gee_rechtsform                     in varchar2,
        piv_gee_plz                            in varchar2,
        piv_gee_ort                            in varchar2,
        piv_gee_strasse                        in varchar2,
        piv_gee_hausnr                         in varchar2,
        piv_gee_hausnr_zusatz                  in varchar2,
        piv_gee_land                           in varchar2,
        piv_gee_email                          in varchar2,
        piv_gee_vorwahl                        in varchar2,
        piv_gee_rufnummer                      in varchar2,
        piv_gee_anrede                         in varchar2,
        piv_gee_vorname                        in varchar2,
        piv_gee_nachname                       in varchar2,
        pib_gee_informationspflicht            in boolean  
    -- productRequest:
        ,
        piv_produkt                            in varchar2,
        piv_router_auswahl                     in varchar2,
        piv_router_eigentum                    in varchar2,
        piv_einrichtungsservice                in varchar2,
        piv_ont_provider                       in varchar2 --@ticket @ticket FTTH-5008 nach Versionierung bereit zur Entfernung
    --
        ,
        pib_check_agb                          in boolean,
        pib_check_widerruf                     in boolean
    --
        ,
        piv_ausbaustatus                       in varchar2,
        pid_ausbau_plan_termin                 in date
    --
        ,
        pib_is_duplicate                       in boolean default null,
        piv_update_cus_in_siebel               in varchar2 default 'FALSE' --@ticket: FTTH-5228
    ) is

        vj_internal_order   clob;
        v_webservice_log_id ftth_webservice_aufrufe.id%type; -- für den Fall, dass der Auftrag nicht erfolgreich vom Webserver
                                                         -- verarbeitet wird, können mit dieser ID die gesendeten Daten
                                                         -- ausgelesen werden
-- Hilfsroutine zur Fehlerbehandlung------------------------------------------
  -- Parameterliste aktualisiert am 2024-12-31 0930
        cv_routine_name     constant logs.routine_name%type := 'p_vorbestellung_erfassen';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_app_user', piv_app_user);
            pck_format.p_add('piv_vkz', piv_vkz);
            pck_format.p_add('piv_kundenstatus', piv_kundenstatus);
            pck_format.p_add('piv_abw', piv_abw);
            pck_format.p_add('piv_abw_anrede', piv_abw_anrede);
            pck_format.p_add('piv_abw_anschlussinhaber', piv_abw_anschlussinhaber);
            pck_format.p_add('piv_abw_nachname', piv_abw_nachname);
            pck_format.p_add('piv_abw_rufnummer', piv_abw_rufnummer);
            pck_format.p_add('piv_abw_vorname', piv_abw_vorname);
            pck_format.p_add('piv_abw_vorwahl', piv_abw_vorwahl);
            pck_format.p_add('piv_aktion', piv_aktion);
            pck_format.p_add('piv_bisheriger_anbieter', piv_bisheriger_anbieter);
            pck_format.p_add('piv_gee_eigentuemer_einverstanden', piv_gee_eigentuemer_einverstanden);
            pck_format.p_add('piv_gee_firma', piv_gee_firma);
            pck_format.p_add('piv_gee_kontaktdaten_bekannt', piv_gee_kontaktdaten_bekannt);
            pck_format.p_add('piv_gee_titel', piv_gee_titel);
            pck_format.p_add('piv_haus_lfd_nr', piv_haus_lfd_nr);
            pck_format.p_add('piv_kosten_hausanschluss', piv_kosten_hausanschluss);
            pck_format.p_add('piv_kunde_anrede', piv_kunde_anrede);
            pck_format.p_add('piv_kunde_email', piv_kunde_email);
            pck_format.p_add('piv_kunde_firmenname', piv_kunde_firmenname);
            pck_format.p_add('pid_kunde_geburtsdatum', pid_kunde_geburtsdatum);
            pck_format.p_add('piv_kunde_iban', piv_kunde_iban);
            pck_format.p_add('piv_kunde_kontoinhaber', piv_kunde_kontoinhaber);
            pck_format.p_add('piv_kunde_nachname', piv_kunde_nachname);
            pck_format.p_add('piv_kundennummer', piv_kundennummer);
            pck_format.p_add('piv_kunde_rufnummer', piv_kunde_rufnummer);
            pck_format.p_add('piv_kunde_sepamandat', piv_kunde_sepamandat);
            pck_format.p_add('piv_kunde_soho', piv_kunde_soho);
            pck_format.p_add('piv_kunde_titel', piv_kunde_titel);
            pck_format.p_add('piv_kunde_vorname', piv_kunde_vorname);
            pck_format.p_add('piv_kunde_vorwahl', piv_kunde_vorwahl);
            pck_format.p_add('piv_mandant', piv_mandant);
            pck_format.p_add('piv_mandant_display', piv_mandant_display);
            pck_format.p_add('piv_wohndauer', piv_wohndauer);
            pck_format.p_add('piv_voradresse_plz', piv_voradresse_plz);
            pck_format.p_add('piv_voradresse_ort', piv_voradresse_ort);
            pck_format.p_add('piv_voradresse_strasse', piv_voradresse_strasse);
            pck_format.p_add('piv_voradresse_hausnr', piv_voradresse_hausnr);
            pck_format.p_add('piv_installationsadresse_plz', piv_installationsadresse_plz);
            pck_format.p_add('piv_installationsadresse_ort', piv_installationsadresse_ort);
            pck_format.p_add('piv_installationsadresse_strasse', piv_installationsadresse_strasse);
            pck_format.p_add('piv_installationsadresse_hausnr', piv_installationsadresse_hausnr);
            pck_format.p_add('piv_installationsadresse_hausnr_zusatz', piv_installationsadresse_hausnr_zusatz);
            pck_format.p_add('piv_abw_bisheriger_anbieter', piv_abw_bisheriger_anbieter);
            pck_format.p_add('piv_abw_rufnummernmitnahme', piv_abw_rufnummernmitnahme);
            pck_format.p_add('piv_abw_rufnummernmitnahme_vorwahl', piv_abw_rufnummernmitnahme_vorwahl);
            pck_format.p_add('piv_abw_rufnummernmitnahme_rufnummer', piv_abw_rufnummernmitnahme_rufnummer);
            pck_format.p_add('piv_gee_rolle', piv_gee_rolle);
            pck_format.p_add('piv_gee_anzahl_we', piv_gee_anzahl_we);
            pck_format.p_add('piv_gee_rechtsform', piv_gee_rechtsform);
            pck_format.p_add('piv_gee_plz', piv_gee_plz);
            pck_format.p_add('piv_gee_ort', piv_gee_ort);
            pck_format.p_add('piv_gee_strasse', piv_gee_strasse);
            pck_format.p_add('piv_gee_hausnr', piv_gee_hausnr);
            pck_format.p_add('piv_gee_hausnr_zusatz', piv_gee_hausnr_zusatz);
            pck_format.p_add('piv_gee_land', piv_gee_land);
            pck_format.p_add('piv_gee_email', piv_gee_email);
            pck_format.p_add('piv_gee_vorwahl', piv_gee_vorwahl);
            pck_format.p_add('piv_gee_rufnummer', piv_gee_rufnummer);
            pck_format.p_add('piv_gee_anrede', piv_gee_anrede);
            pck_format.p_add('piv_gee_vorname', piv_gee_vorname);
            pck_format.p_add('piv_gee_nachname', piv_gee_nachname);
            pck_format.p_add('pib_gee_informationspflicht', pib_gee_informationspflicht);
            pck_format.p_add('piv_produkt', piv_produkt);
            pck_format.p_add('piv_router_auswahl', piv_router_auswahl);
            pck_format.p_add('piv_router_eigentum', piv_router_eigentum);
            pck_format.p_add('piv_einrichtungsservice', piv_einrichtungsservice);
            pck_format.p_add('piv_ont_provider', piv_ont_provider); --@ticket @ticket FTTH-5008 nach Versionierung bereit zur Entfernung
            pck_format.p_add('pib_check_agb', pib_check_agb);
            pck_format.p_add('pib_check_widerruf', pib_check_widerruf);
            pck_format.p_add('piv_ausbaustatus', piv_ausbaustatus);
            pck_format.p_add('pid_ausbau_plan_termin', pid_ausbau_plan_termin);
            pck_format.p_add('pib_is_duplicate', pib_is_duplicate);
            pck_format.p_add('piv_update_cus_in_siebel', piv_update_cus_in_siebel); --@ticket: FTTH-5228
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
-- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 

    -- inline:
        procedure validieren (
            pib_bedingung    in boolean,
            piv_errormessage in varchar2
        ) is
        begin
            if not coalesce(pib_bedingung, false) then
                raise_application_error(c_plausi_error_number, piv_errormessage);
            end if;
        end;

    begin


    -- nochmalige Prüfungen der wichtigsten Daten:
        validieren(piv_app_user is not null, 'Username fehlt');
        validieren(piv_vkz is not null, 'VKZ fehlt');
            -- piv_kunde_anrede (darf leer sein)
        validieren(piv_kunde_vorname is not null, 'Kunde: Vorname fehlt');
        validieren(piv_kunde_nachname is not null, 'Kunde: Nachname fehlt');
        validieren(pid_kunde_geburtsdatum is not null, 'Kunde: Geburtsdatum fehlt');
        validieren(piv_kunde_email is not null, 'Kunde: Email fehlt');
        validieren(piv_mandant is not null, 'Mandant fehlt');
        validieren(piv_installationsadresse_plz is not null, 'Installationsadresse: PLZ fehlt');
        validieren(piv_installationsadresse_ort is not null, 'Installationsadresse: Ort fehlt');
        validieren(piv_installationsadresse_strasse is not null, 'Installationsadresse: Straße fehlt');
        validieren(piv_installationsadresse_hausnr is not null, 'Installationsadresse: Hausnr. fehlt');
        validieren(piv_haus_lfd_nr is not null, 'Installationsadresse: HAUS_LFD_NR fehlt');    

    -- @ticket FTTH-4084:
    -- validieren(piv_vc_status IS NOT NULL, 'Ausbaustatus liegt nicht vor'); -- //// zunächst prüfen, ob das Feld wirklich IMMER gefüllt sein muss

    -- nur bei Neukunden:
    -- @ticket FTTH-4282: Prüfung nicht mehr aussetzen, denn zuvor wird nun eine leere Wohndauer auf NO_RESIDENT gemappt
        if piv_kundenstatus = neukunde then
            validieren(piv_wohndauer is not null, 'Kunde: Wohndauer fehlt');
        end if;
        validieren(piv_kunde_vorwahl is not null, 'Kunde: Ländervorwahl fehlt');
        validieren(piv_kunde_rufnummer is not null, 'Kunde: Rufnummer fehlt');
            -- piv_kunde_titel (darf leer sein)

    -- Zuordnung zum Datensatz:
        vj_internal_order := fj_internal_order(
            piv_app_user                                                  => piv_app_user,
            piv_vkz                                                       => piv_vkz,
            piv_kundenstatus                                              => piv_kundenstatus,
            piv_gee_kontaktdaten_bekannt                                  => piv_gee_kontaktdaten_bekannt,
            piv_propertyownerdeclaration_propertyownerrole                => piv_gee_rolle,
            piv_abw_anschlussinhaber                                      => piv_abw_anschlussinhaber
       --
            ,
            piv_customernumber                                            => piv_kundennummer,
            piv_customer_businessname                                     => piv_kunde_firmenname,
            piv_customer_salutation                                       => piv_kunde_anrede,
            piv_customer_name_first                                       => piv_kunde_vorname,
            piv_customer_name_last                                        => piv_kunde_nachname,
            pid_customer_birthdate                                        => pid_kunde_geburtsdatum,
            piv_customer_email                                            => piv_kunde_email,
            piv_customer_residentstatus                                   => piv_wohndauer,
            piv_customer_phonenumber_countrycode                          => piv_kunde_vorwahl
       -- hier kein areaCode? im Gegensatz zu providerchange... s.u.
            ,
            piv_customer_phonenumber_number                               => piv_kunde_rufnummer,
            piv_customer_title                                            => piv_kunde_titel,
            piv_customer_previousaddress_zipcode                          => piv_voradresse_plz,
            piv_customer_previousaddress_city                             => piv_voradresse_ort,
            piv_customer_previousaddress_street                           => piv_voradresse_strasse,
            piv_customer_previousaddress_housenumber                      => piv_voradresse_hausnr -- keine postaladdition im Ggs. zu landlord etc.?
            ,
            piv_client                                                    => piv_mandant,
            piv_installation_address_zipcode                              => piv_installationsadresse_plz,
            piv_installation_address_city                                 => piv_installationsadresse_ort,
            piv_installation_address_street                               => piv_installationsadresse_strasse,
            piv_installation_address_housenumber                          => piv_installationsadresse_hausnr,
            piv_installation_address_postal_addition                      => piv_installationsadresse_hausnr_zusatz,
            piv_houseserialnumber                                         => piv_haus_lfd_nr
       -- Anbieterwechsel:
            ,
            piv_providerchange_currentprovider                            => piv_abw_bisheriger_anbieter,
            pib_providerchange_keepcurrentlandlinenumber                  => to_boolean(piv_abw_rufnummernmitnahme),
            piv_providerchange_landlinephonenumber_countrycode            => '49' -- /// +49? piv_abw_rufnummernmitnahme_laendervorwahl wird ja nicht erfasst
            ,
            piv_providerchange_landlinephonenumber_areacode               => piv_abw_rufnummernmitnahme_vorwahl,
            piv_providerchange_landlinephonenumber_number                 => piv_abw_rufnummernmitnahme_rufnummer,
            piv_providerchange_contractownersalutation                    => piv_abw_anrede,
            piv_providerchange_contractownername_first                    => piv_abw_vorname,
            piv_providerchange_contractownername_last                     => piv_abw_nachname,
            piv_accountdetails_accountholder                              => piv_kunde_kontoinhaber,
            piv_accountdetails_iban                                       => piv_kunde_iban
       ---
            ,
            piv_propertyownerdeclaration_residentialunit                  => piv_gee_anzahl_we,
            piv_propertyownerdeclaration_landlord_legalform               => piv_gee_rechtsform,
            piv_propertyownerdeclaration_landlord_businessorname          => piv_gee_firma,
            piv_propertyownerdeclaration_landlord_address_zipcode         => piv_gee_plz,
            piv_propertyownerdeclaration_landlord_address_city            => piv_gee_ort,
            piv_propertyownerdeclaration_landlord_address_street          => piv_gee_strasse,
            piv_propertyownerdeclaration_landlord_address_housenumber     => piv_gee_hausnr,
            piv_propertyownerdeclaration_landlord_address_postaladdition  => piv_gee_hausnr_zusatz,
            piv_propertyownerdeclaration_landlord_address_country         => piv_gee_land,
            piv_propertyownerdeclaration_landlord_email                   => piv_gee_email,
            piv_propertyownerdeclaration_landlord_phonenumber_countrycode => piv_gee_vorwahl -- /// Achtung: Ländervorwahl *+*49, nicht Ortsnetz!
            ,
            piv_propertyownerdeclaration_landlord_phonenumber_number      => piv_gee_rufnummer,
            piv_propertyownerdeclaration_landlord_salutation              => piv_gee_anrede,
            piv_propertyownerdeclaration_landlord_title                   => piv_gee_titel,
            piv_propertyownerdeclaration_landlord_name_first              => piv_gee_vorname,
            piv_propertyownerdeclaration_landlord_name_last               => piv_gee_nachname,
            pib_propertyownerdeclaration_landlordagreedtobecontacted      => pib_gee_informationspflicht 
       ---
            ,
            piv_productrequest_templateid                                 => piv_produkt,
            piv_productrequest_devicecategory                             => piv_router_auswahl,
            piv_productrequest_deviceownership                            => piv_router_eigentum,
            piv_productrequest_installationservice                        => piv_einrichtungsservice,
            piv_productrequest_ontprovider                                => piv_ont_provider --@ticket @ticket FTTH-5008 nach Versionierung bereit zur Entfernung
       ---
            ,
            pib_summary_generaltermsandconditions                         => pib_check_agb,
            pib_summary_waiverightofrevocation                            => pib_check_widerruf
       ---
            ,
            piv_expansionstatus                                           => fv_vc_status_webservice(piv_ausbaustatus),
            pid_availabilitydate                                          => pid_ausbau_plan_termin,
            piv_createdby                                                 => piv_app_user,
            pib_isduplicate                                               => pib_is_duplicate,
            piv_update_cus_in_siebel                                      => piv_update_cus_in_siebel --@ticket: FTTH-5228
        );

    -- Auftrag zum Webservice senden:
        pck_pob_rest.p_internal_order_post(
            piv_kontext  => pck_pob_rest.kontext_preorderbuffer,
            piv_app_user => piv_app_user,
            pic_body     => vj_internal_order
        );

    exception
        when e_plausi_error then
            raise;
        when others then
        -- nur unerwartete Fehler loggen:
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise; -- (hier sollte bereits eine benutzer-geeignete Fehlermeldung aus dem PCK_POB_REST vorliegen)
    end p_vorbestellung_erfassen;



-- @progress 2024-04-18

    procedure p_transformation_vorbestellung (
        piov_vkz                              in out varchar2,
        piov_kundenstatus                     in out varchar2,
        piov_abw                              in out varchar2,
        piov_abw_anrede                       in out varchar2,
        piov_abw_anschlussinhaber             in out varchar2,
        piov_abw_nachname                     in out varchar2,
        piov_abw_rufnummer                    in out varchar2,
        piov_abw_vorname                      in out varchar2,
        piov_abw_vorwahl                      in out varchar2,
        piov_aktion                           in out varchar2,
        piov_bisheriger_anbieter              in out varchar2,
        piov_gee_eigentuemer_einverstanden    in out varchar2,
        piov_gee_firma                        in out varchar2,
        piov_gee_kontaktdaten_bekannt         in out varchar2,
        piov_gee_titel                        in out varchar2,
        piov_haus_lfd_nr                      in out varchar2,
        piov_kosten_hausanschluss             in out varchar2,
        piov_kunde_anrede                     in out varchar2,
        piov_kunde_email                      in out varchar2,
        piov_kunde_firmenname                 in out varchar2,
        piod_kunde_geburtsdatum               in out date,
        piov_kunde_iban                       in out varchar2,
        piov_kunde_kontoinhaber               in out varchar2,
        piov_kunde_nachname                   in out varchar2,
        piov_kundennummer                     in out varchar2,
        piov_kunde_rufnummer                  in out varchar2,
        piov_kunde_sepamandat                 in out varchar2,
        piov_kunde_soho                       in out varchar2,
        piov_kunde_titel                      in out varchar2,
        piov_kunde_vorname                    in out varchar2,
        piov_kunde_vorwahl                    in out varchar2,
        piov_mandant                          in out varchar2,
        piov_mandant_display                  in out varchar2,
        piov_wohnt_dort                       in out varchar2,
        piov_wohndauer                        in out varchar2,
        piov_voradresse_plz                   in out varchar2,
        piov_voradresse_ort                   in out varchar2,
        piov_voradresse_strasse               in out varchar2,
        piov_voradresse_hausnr                in out varchar2,
        piov_installationsadresse_plz         in out varchar2,
        piov_installationsadresse_ort         in out varchar2,
        piov_installationsadresse_strasse     in out varchar2,
        piov_installationsadresse_hausnr      in out varchar2,
        piov_installationsadresse_komplett    in out varchar2 --@krakar @FTTH-4622
        ,
        piov_abw_bisheriger_anbieter          in out varchar2,
        piov_abw_rufnummernmitnahme           in out varchar2 
--  ,piov_abw_rufnummernmitnahme_laendervorwahl IN OUT VARCHAR2 /// die gibt es nicht im Formular!
        ,
        piov_abw_rufnummernmitnahme_vorwahl   in out varchar2,
        piov_abw_rufnummernmitnahme_rufnummer in out varchar2,
        piov_gee_rolle                        in out varchar2,
        piov_gee_anzahl_we                    in out varchar2,
        piov_gee_rechtsform                   in out varchar2,
        piov_gee_plz                          in out varchar2,
        piov_gee_ort                          in out varchar2,
        piov_gee_strasse                      in out varchar2,
        piov_gee_hausnr                       in out varchar2,
        piov_gee_hausnr_zusatz                in out varchar2,
        piov_gee_land                         in out varchar2,
        piov_gee_email                        in out varchar2,
        piov_gee_vorwahl                      in out varchar2,
        piov_gee_rufnummer                    in out varchar2,
        piov_gee_anrede                       in out varchar2,
        piov_gee_vorname                      in out varchar2,
        piov_gee_nachname                     in out varchar2,
        piov_gee_informationspflicht          in out varchar2,
        piov_produkt                          in out varchar2,
        piov_router_auswahl                   in out varchar2,
        piov_router_eigentum                  in out varchar2,
        piov_einrichtungsservice              in out varchar2,
        piov_ont_provider                     in out varchar2  --@ticket @ticket FTTH-5008 nach Versionierung bereit zur Entfernung                                 
        ,
        piov_check_agb                        in out varchar2,
        piov_check_widerruf                   in out varchar2,
        piov_vc_status                        in out varchar2,
        piod_vc_ausbau_plan_termin            in out date,
        piov_is_duplicate                     in out varchar2
    ) is
    begin

    -- Bestandskunden: alle bereits bekannten Felder löschen
    -- Neukunde oder Bestandskunde:
        case piov_kundenstatus
            when neukunde then
                piov_kundennummer := null;
            when bestandskunde then
                piov_kunde_iban := null; -- ////@klären: tatsächlich keine alternative IBAN für Bestandskunden möglich?
                piov_kunde_kontoinhaber := null; -- ////@klären: tatsächlich keine alternative IBAN für Bestandskunden möglich?

         ---piov_wohndauer                       := NULL; -- @ticket FTTH-4282: Zuweisung ausgesetzt: Wohndauer darf bei Neukunden nicht leer sein
                piov_voradresse_plz := null;
                piov_voradresse_plz := null;
                piov_voradresse_ort := null;
                piov_voradresse_strasse := null;
                piov_voradresse_hausnr := null;
                piov_bisheriger_anbieter := null;
                piov_abw_rufnummernmitnahme := null;
                piov_abw_rufnummernmitnahme_vorwahl := null;
                piov_abw_vorwahl := null;
                piov_abw_rufnummer := null;
                piov_abw_anschlussinhaber := null;
                piov_abw_anrede := null;
                piov_abw_vorname := null;
                piov_abw_nachname := null;
            else
                raise_application_error(-20999, 'Kundenstatus '
                                                || piov_kundenstatus
                                                || ' nicht zulässig');
        end case;

    -- 6/7: Gesamte Seite löschen, wenn die Kontaktdaten des Vermieters nicht bekannt sind
    -- (Rechtsform, Name, Adresse, ... Informationspflicht)
    -- außer diesen:
    -- piov_gee_rolle, die bleibt als Determinante weiter bestehen)
    -- piov_gee_anzahl_we
        if piov_gee_kontaktdaten_bekannt = 0 then
            piov_gee_titel := null;
            piov_gee_eigentuemer_einverstanden := null;
            piov_gee_firma := null;
            piov_gee_rechtsform := null;
            piov_gee_plz := null;
            piov_gee_ort := null;
            piov_gee_strasse := null;
            piov_gee_hausnr := null;
            piov_gee_hausnr_zusatz := null;
            piov_gee_land := null;
            piov_gee_email := null;
            piov_gee_vorwahl := null;
            piov_gee_rufnummer := null;
            piov_gee_anrede := null;
            piov_gee_vorname := null;
            piov_gee_nachname := null;
            piov_gee_informationspflicht := null;
        end if;

    -- Wenn bei der Neukunden-Abfrage WOHNT_DORT = 0 ist, 
    -- dann gibt es keine Wohndauer und auch die Frage nach der Wohndauer wird im Formular nicht eingeblendet.
    -- @ticket FTTH-4282: Deshalb kommt die Wohndauer in diesem Fall als NULL rein, 
    -- was das Backend wiederum nicht akzeptiert. Also ersatzweise "wohnt nicht dort" übermitteln:
        if
            piov_kundenstatus = neukunde
            and piov_wohnt_dort = 0
        then
            piov_wohndauer := 'NO_RESIDENT'; -- war vorher: NULL
        end if;

    -- Wenn der Anschluss auf den Kunden angemeldet ist, dann
    -- lösche die Anrede, Vorname und Nachname des abweichenden Anschlussinhabers:
        if nvl(piov_abw_anschlussinhaber, 0) = 0 then
            piov_abw_anrede := null;
            piov_abw_vorname := null;
            piov_abw_nachname := null;
        end if;

    end p_transformation_vorbestellung;

-- @progress 2024-05-15

/**
 * Nimmt von APEX den fertigen JSON-Body für eine "Vorbestellung erfassen" entgegen
 * und schickt den Auftrag an den Preorderbuffer.
 *
 * @ticket FTTH-2829
 *
 *
 * @usage  Typischerweise für Unit Tests, als Test-Bestellung oder als Wiederholung eines gescheiterten Aufrufs
 *
 * @example
 * -- Nachstellen einer gescheiterten Bestellung mit den exakten geloggten Daten (außer: anderer User)
 * DECLARE
 *   v_body CLOB;
 * BEGIN
 *   SELECT body
 *     INTO v_body
 *     FROM ROMA_MAIN.ftth_webservice_aufrufe -- Synonym in NMCE: WSPOST_DEV
 *    WHERE ID = 1426 -- geloggte Fehler-ID verwenden
 *   ;
 *   PCK_GLASCONTAINER_ORDER.P_VORBESTELLUNG_ERFASSEN (
 *       piv_app_user => 'TESTER'
 *     , pic_body => v_body
 *   );
 * END;
 */
    procedure p_vorbestellung_erfassen (
        piv_app_user in varchar2,
        pic_body     in clob
    ) is

        v_webservice_log_id ftth_webservice_aufrufe.id%type; -- für den Fall, dass der Auftrag nicht erfolgreich vom Webserver
                                                         -- verarbeitet wird, können mit dieser ID die gesendeten Daten
                                                         -- ausgelesen werden
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name     constant logs.routine_name%type := 'p_vorbestellung_erfassen';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_app_user', piv_app_user);
            pck_format.p_add('pic_body', pic_body);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin

    -- Auftrag zum Webservice senden:
        pck_pob_rest.p_internal_order_post(
            piv_kontext  => pck_pob_rest.kontext_preorderbuffer,
            piv_app_user => piv_app_user,
            pic_body     => pic_body
        );
    exception
        when e_plausi_error then
            raise;
        when others then
        -- nur unerwartete Fehler loggen:
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise; -- (hier sollte bereits eine benutzer-geeignete Fehlermeldung aus dem PCK_POB_REST vorliegen)
    end p_vorbestellung_erfassen;

-- @weiter////: In APEX "JSON:-"... ergänzen für alle Eingabefelder auf Seite 110

/**
 * Gibt einen String zurück, der das Verfügbarkeitsdatum eines Vermarktungsclusters in Halbjahren beschreibt
 *
 * @ticket FTTH-2829
 */
    function fv_verfuegbarkeit_halbjahr (
        pid_plan_termin in date
    ) -- @todo Namen ändern: //// "vc" raus, denn das gilt auch für fiktive Daten gemäß @ticket FTTH-4084
     return varchar2 is
        v_string varchar2(100);
    begin
        if pid_plan_termin < current_date then
            v_string := 'in Planung';
        elsif extract(month from pid_plan_termin) between 1 and 6 then
            v_string := '1. Halbjahr ' || to_char(pid_plan_termin, 'YYYY');
        elsif extract(month from pid_plan_termin) between 7 and 12 then
            v_string := '2. Halbjahr ' || to_char(pid_plan_termin, 'YYYY');
        else
            v_string := to_char(pid_plan_termin, 'MM/YYYY'); -- äußerst unwahrscheinlich, dass dies auftritt
        end if;

        return v_string;
    end fv_verfuegbarkeit_halbjahr;

-- @progress 2024-06-06  

  /**
   * Prüft, ob die von Siebel erhaltenen Kundendaten für eine Bestellung im Glascontainer
   * valide zu verwenden sind, und gibt entweder die Werte an die Ausgabe-Items zurück
   * oder erzeugt einen Application Error mit Nutzer-lesbarem Fehlertext, falls der Datensatz
   * nicht genügt.
   *
   * @param  piv_kundennummer [IN]
   *
   * @usage Prozess Seite 100: "[4] Dublette ist ausgewählt"
   */
    procedure fv_siebel_kundendaten_uebernehmen (
        piv_global_id          in varchar2,
        piv_kundennummer       in varchar2
       ---
        ,
        pov_anrede             out varchar2,
        pov_titel              out varchar2,
        pov_vorname            out varchar2,
        pov_nachname           out varchar2,
        pod_geburtsdatum       out date,
        pov_firmenname         out varchar2,
        pov_ap_email           out varchar2,
        pov_ap_mobil_vorwahl   out varchar2,
        pov_ap_mobil_rufnummer out varchar2,
        pov_iban               out varchar2
    ) is

        v_fehlertext    varchar2(32767);
        v_anrede        varchar2(255);

        -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'fv_siebel_kundendaten_uebernehmen';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_global_id', piv_global_id);
            pck_format.p_add('piv_kundennummer', piv_kundennummer);
            -- (OUT): pov_anrede
            -- (OUT): pov_titel
            -- (OUT): pov_vorname
            -- (OUT): pov_nachname
            -- (OUT): pod_geburtsdatum
            -- (OUT): pov_firmenname
            -- (OUT): pov_ap_email
            -- (OUT): pov_ap_mobil_vorwahl
            -- (OUT): pov_ap_mobil_rufnummer
            -- (OUT): pov_iban
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
        -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------         

        procedure add_fehler (
            i_fehlertext in varchar2
        ) is
        begin
            v_fehlertext := ltrim(v_fehlertext
                                  || ', '
                                  || i_fehlertext, ', ');
        end;

    begin
        if piv_kundennummer is null then
            add_fehler('Bitte treffen Sie eine Auswahl');
        end if;
        select
            anrede,
            case upper(anrede)
                when 'HERR' then
                    'MISTER'
                when 'FRAU' then
                    'MISS'
            end,
            titel -- /// prüfen: kommen da nur erlaubte Werte?
            ,
            vorname,
            nachname,
            geburtsdatum,
            firmenname,
            ap_email,
            ap_mobil_country,
            ap_mobil_onkz || ap_x_mobil_nr,
            iban
        into
            v_anrede,
            pov_anrede,
            pov_titel,
            pov_vorname,
            pov_nachname,
            pod_geburtsdatum,
            pov_firmenname,
            pov_ap_email,
            pov_ap_mobil_vorwahl,
            pov_ap_mobil_rufnummer,
            pov_iban
        from
            v_siebel_kundendaten -- live-Zugriff erforderlich: nicht die MV verwenden!
        where
                global_id = piv_global_id
            and kundennummer = piv_kundennummer
            and gueltig = 'Y';
         -- Validierungen für den Glascontainer:
         -- @ticket FTTH-3943
         -- Anrede, Vorname, Nachname, Geburtsdatum, Mailadresse, Rufnummer, IBAN
        if pov_anrede is null then
            add_fehler(
                case
                    when v_anrede is null then
                        'Fehlende Anrede'
                    else 'Ungültige Anrede: "'
                         || v_anrede
                         || '"'
                end
            );
        end if;
         -- Titel wird derzeit nicht validiert
        if pov_vorname is null then
            add_fehler('Vorname fehlt');
        end if;
        if pov_nachname is null then
            add_fehler('Nachname fehlt');
        end if;
        if pod_geburtsdatum is null then
            add_fehler('Geburtsdatum fehlt');
        end if;
        if pov_ap_email is null then
            add_fehler('E-Mail-Adresse fehlt');
        end if;
        if pov_ap_mobil_vorwahl is null then
            add_fehler('Ländervorwahl der Mobil-Rufnummer des Ansprechpartners fehlt');
        end if;
        if pov_ap_mobil_rufnummer is null then
            add_fehler('Mobil-Rufnummer des Ansprechpartners fehlt');
        end if;
        if pov_iban is null then
            add_fehler('IBAN fehlt');
        end if;

         -- Prüfungen auf valide Werte:
        if not pck_adresse.fb_is_valid_name(pov_vorname) then
            add_fehler('Ungültiger Vorname: "'
                       || pov_vorname
                       || '"');
        end if;

        if not pck_adresse.fb_is_valid_name(pov_nachname) then
            add_fehler('Ungültiger Nachname: "'
                       || pov_nachname
                       || '"');
        end if;

        if not pck_adresse.fb_is_valid_firma(pov_firmenname) then
            add_fehler('Ungültiger Firmenname: "'
                       || pov_firmenname
                       || '"');
        end if;

        if not pck_adresse.fb_is_valid_email(pov_ap_email) then
            add_fehler('Ungültige E-Mail-Adresse: "'
                       || pov_ap_email
                       || '"');
        end if;

        if not pck_adresse.fb_is_valid_iban(pov_iban) then
            add_fehler('Ungültige IBAN: "'
                       || pov_iban
                       || '"');
        end if;

        if v_fehlertext is not null then
            raise_application_error(-20000, '');
        end if;
    exception
        when no_data_found then
            raise_application_error(-20999, 'Siebel-Kundendaten konnten nicht abgerufen werden');
        when too_many_rows then
            raise_application_error(-20999, 'Siebel-Kundendaten konnten nicht eindeutig zugeordnet werden');
        when others then
            if v_fehlertext is not null then
                raise_application_error(-20000, 'Siebel-Kundennummer '
                                                || piv_kundennummer
                                                || ': '
                                                || v_fehlertext);
            else
                pck_logs.p_error(
                    pic_message      => fcl_params(),
                    piv_routine_name => cv_routine_name,
                    piv_scope        => g_scope
                );

                raise;
            end if;
    end fv_siebel_kundendaten_uebernehmen;  



/**  
 * Liefert die Ergebnisse der Dublettenprüfung für die Glascontainer-Bestellstrecke.
 * Achtung: Dies ist der Prototyp einer Dublettensuche, der die Fuzzy-Suche zumindest verübergehend ablöst
 * (Ersatz für PCK_FUZZYDOUBLE.ft_vorbestellung_dublettencheck)
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
 * @piv_suchbereich                 [IN]  (optional) (NULL): Sämtliche Quellen durchsuchen
 *                                                   SIE   : Siebel durchsuchen (nicht den Glascontainer)
 *                                                   PHO   : Siebel durchsuchen, aber nur phonetisch
 *                                                   BNK   : Siebel durchsuchen, aber nur IBAN-Suche
 *                                                   POB   : Preorderbuffer durchsuchen (nicht Siebel)
 *                                                   POB-N : Preorderbuffer durchsuchen, aber nur Neukundenaufträge
 *                                                   POB-B : Preorderbuffer durchsuchen, aber nur Bestandskundenaufträge 
 * 
 * @return T_DUBLETTEN PIPELINED 
 *
 * @ticket FTTH-2804
 *
 * @usage Schritt 4/7 im Vorbestellungs-Wizard
 */
    function ft_vorbestellung_dublettencheck (
        piv_nachname              in varchar2,
        piv_vorname               in varchar2,
        pid_geburtsdatum          in date,
        piv_firmenname            in varchar2 -- wird angeblich in Kürze verwendet
        ,
        piv_strasse               in varchar2 -- derzeit unbenutzt
        ,
        piv_hausnummer            in varchar2 -- derzeit unbenutzt
        ,
        piv_plz                   in varchar2 -- derzeit unbenutzt
        ,
        piv_ort                   in varchar2 -- derzeit unbenutzt
        ,
        piv_iban                  in varchar2,
        pin_ignore_service_errors in natural default 0 -- derzeit unbenutzt, spielt ohne Fuzzy keine Rolle
        ,
        pin_find_1_only           in natural default 0,
        piv_suchbereich           in varchar2 default null
    ) return t_dubletten
        pipelined
    is
    -- Bestimmt, wie präzise im Glascontainer/Preorderbuffer nach Duplikation gesucht wird:
        c_edit_distance  constant naturaln := 1; -- 0 = exakter Treffer, 1 = nah dran, ... 100 = völlig unterschiedlich
                                                    -- Der Wert "2" ist schon recht großzügig.
                                                    -- Ab "3" werden unbrauchbare Treffer mit ausgegeben.
        c_fake_dubletten boolean;

    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name  constant logs.routine_name%type := 'ft_vorbestellung_dublettencheck';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_nachname', piv_nachname);
            pck_format.p_add('piv_vorname', piv_vorname);
            pck_format.p_add('pid_geburtsdatum', pid_geburtsdatum);
            pck_format.p_add('piv_firmenname', piv_firmenname);
            pck_format.p_add('piv_strasse', piv_strasse);
            pck_format.p_add('piv_hausnummer', piv_hausnummer);
            pck_format.p_add('piv_plz', piv_plz);
            pck_format.p_add('piv_ort', piv_ort);
            pck_format.p_add('piv_iban', piv_iban);
            pck_format.p_add('pin_ignore_service_errors', pin_ignore_service_errors);
            pck_format.p_add('piv_suchbereich', piv_suchbereich);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
    -- nur in der Entwicklungs- oder Testumgebung werden Fake-Daten angezeigt:
        c_fake_dubletten :=
            false
            and -- Spaßbremse
             pck_env.fv_db_name in ( 'NMCE', 'NMCE3', 'NMCS' );

    -- Plausi-Check:
    -- Suche ohne Ergbebnis beenden, wenn die Voraussetzungen fehlen
        if
            ( piv_nachname is null
              or piv_vorname is null )
            and piv_firmenname is null
        then
            return;
        end if;

    -- Am wenigsten aufwändige Suche zuerst:
    -- Suche im Preorderbuffer über persönliche Daten oder IBAN  
        if piv_suchbereich is null
           or piv_suchbereich in ( 'POB', 'POB-N', 'POB-B' ) then
            for chk_pob in (
        -- Vergleiche Adresse oder IBAN im Preorder-Buffer:
                select
                    'POB'                                               as src,
                    'POB'                                               as link -- //// anders benennen
                    ,
                    'Auftrag in neuem Glascontainer-Fenster öffnen ...' as link_title,
                    id                                                  as id,
                    customernumber                                      as kundennummer,
                    null                                                as rule_number,
                    null                                                as score,
                    customer_name_first                                 as vorname,
                    customer_name_last                                  as nachname,
                    customer_birthdate                                  as geburtsdatum,
                    customer_businessname                               as firmenname
          -- @ticket FTTH-4719: Adresse wird ausschließlich anhand der HAUS_LFD_NR ermittelt
          -- , install_addr_street      AS strasse
          -- , install_addr_housenumber AS hausnummer
          -- , install_addr_zipcode     AS plz
          -- , install_addr_city        AS ort
                    ,
                    (
                        select
                            adresse_kompl
                        from
                            pob_adressen
                        where
                            haus_lfd_nr = p.houseserialnumber
                    )                                                   as adresse_kompl,
                    account_iban                                        as iban
                from
                    ftth_ws_sync_preorders p
                where
                    state in ( pck_glascontainer.status_created          -- 'CREATED'
                    , pck_glascontainer.status_in_review        -- 'IN_REVIEW'
                    , pck_glascontainer.status_siebel_processed -- 'SIEBEL_PROCESSED'
                     )
                    and -- rudimentäre Ähnlichkeitssuche im Preorderbuffer.
                     ( customer_birthdate = pid_geburtsdatum )
                    and
               -- Aufträge werden als potenzielle Dubletten betrachtet, wenn...:
                     (    -- Fall 1: IBAN ist identisch
                    -------------------------------------------------------------------------------------------------------------
                     upper(account_iban) = upper(replace(piv_iban, ' '))
                          or -- oder Fall 2: Vor- und Nachname sind sehr ähnlich
                    -------------------------------------------------------------------------------------------------------------
                           ( piv_firmenname is null
                               and utl_match.edit_distance(
                        upper(customer_name_last),
                        upper(piv_nachname)
                    ) between 0 and c_edit_distance
                               and utl_match.edit_distance(
                        upper(customer_name_first),
                        upper(piv_vorname)
                    ) between 0 and c_edit_distance )
                          or -- oder Fall 3: Firmenname ist sehr ähnlich:
                    -------------------------------------------------------------------------------------------------------------
                           ( piv_firmenname is not null
                               and utl_match.edit_distance(
                        upper(customer_businessname),
                        upper(piv_firmenname)
                    ) between 0 and c_edit_distance )

                    /*** 2024-06-18: Weitere Prüfungen werden erstmal nicht durchgeführt
                    OR -- oder Fall 4: Die Adresse ist sehr ähnlich, wobei PLZ und Hausnummer (nicht Zusatz) identisch sein müssen und
                       -- Straße bzw. Ort sehr ähnlich:
                    -------------------------------------------------------------------------------------------------------------
                       (install_addr_zipcode = piv_plz AND
                        UTL_MATCH.edit_distance(upper(install_addr_street), upper(piv_strasse)) BETWEEN 0 AND C_EDIT_DISTANCE AND
                        install_addr_housenumber = piv_hausnummer AND -- Zusatz wird ignoriert
                        UTL_MATCH.edit_distance(upper(install_addr_city), upper(piv_ort)) BETWEEN 0 AND C_EDIT_DISTANCE
                       )
                     ***/ )
         -- /// auch mit HAUS_LFD_NR, Tel, Email etc. vergleichen?
            ) loop
                pipe row ( new t_dublette(chk_pob.src,
                                          chk_pob.id,
                                          chk_pob.kundennummer -- neu 2024-05-22
                                          ,
                                          chk_pob.rule_number,
                                          chk_pob.score,
                                          chk_pob.vorname,
                                          chk_pob.nachname,
                                          chk_pob.geburtsdatum,
                                          chk_pob.firmenname,
                                          to_char(null)  -- chk_pob.strasse     @deprecated @ticket FTTH-5038
                                          ,
                                          to_char(null)  -- chk_pob.hausnummer  @deprecated @ticket FTTH-5038
                                          ,
                                          to_char(null)  -- chk_pob.plz         @deprecated @ticket FTTH-5038
                                          ,
                                          to_char(null)  -- chk_pob.ort         @deprecated @ticket FTTH-5038
                                          ,
                                          chk_pob.iban,
                                          chk_pob.adresse_kompl) );

                if pin_find_1_only = 1 then
                    return;
                end if;
            end loop;

            if c_fake_dubletten then
        -- MOCK/FAKE/DEMO-DATEN aus dem POB:
        -- /0/
                pipe row ( new t_dublette('POB', 'rPZaERggl1AgIjPrw1PQ16m0ctV5pg', '', 1, 85,
                                          'Jane', 'Doe', date '2000-01-01', '' -- Firmenname
                                          , '' -- 'Marconistr.'  @deprecated @ticket FTTH-5038
                                          ,
                                          '' -- '16'           @deprecated @ticket FTTH-5038
                                          , '' -- '50769'        @deprecated @ticket FTTH-5038
                                          , '' -- 'Koeln'        @deprecated @ticket FTTH-5038
                                          , 'DE02120300000000202051'
                           -- @ticket FTTH-5038: Adresse komplett
                                          , 'Marconistr. 16, 50769 Köln') );

            end if; -- /Fake POB
        end if; -- /Suchbereich POB



    -- SIEBEL,
    -- es wird nur noch 1 x gegen V_SIEBEL_KUNDENDATEN geprüft anstatt, wie Fuzzy es macht,
    -- zwei Abfragen (IBAN, Phonetische Suche) durchzuführen
        if piv_suchbereich is null
           or piv_suchbereich in ( 'SIE' ) then
            if c_fake_dubletten then
                for siebel_perfekter_bestandskunde in (
                    select
                        global_id,
                        k.kundennummer,
                        anrede,
                        case upper(anrede)
                            when 'HERR' then
                                'MISTER'
                            when 'FRAU' then
                                'MISS'
                        end,
                        titel,
                        vorname,
                        nachname,
                        geburtsdatum,
                        firmenname,
                        strasse
                     -- @ticket FTTH-5038: Erweiterte/Zusatz-Felder aus der Siebel-View abfragen,
                     -- damit man daraus die ADRESSE_KOMPLETT bauen kann:
                        ,
                        hausnr_von,
                        hausnr_zusatz_von,
                        hausnr_bis,
                        hausnr_zusatz_bis
                     --------------------
                        ,
                        plz,
                        ort,
                        ap_email,
                        ap_mobil_country,
                        ap_mobil_onkz || ap_x_mobil_nr,
                        iban
                    from
                        v_siebel_kundendaten  k-- Fake-Daten
                        left join v_ist_kunde_geloescht g on k.kundennummer = g.kundennummer
                    where
                            gueltig = 'Y'
                        and
                       -- perfekter Bestandskunde:
                         anrede is not null
                        and vorname is not null
                        and regexp_like ( trim(both '-' from trim(nachname)),
                                          '^[a-zA-Z \-]{2,30}$' )
                        and geburtsdatum is not null
                        and ap_email is not null
                        and ap_mobil_country is not null
                        and ap_mobil_onkz || ap_x_mobil_nr is not null
                        and iban is not null    -- //// eigentlich müsste man auch die IBAN auf Gültigkeit prüfen....
                        and nvl(g.x_dsgvo_cust_locked, 'N') = 'N'-- FTTH-5490
                ) loop
                    pipe row ( new t_dublette('SIE'                                        -- src
                    ,
                                              siebel_perfekter_bestandskunde.global_id     -- row_id (global_id)
                                              ,
                                              siebel_perfekter_bestandskunde.kundennummer  -- kundennummer
                                              ,
                                              1                                            -- rule_number
                                              ,
                                              85                                           -- score
                                              ,
                                              siebel_perfekter_bestandskunde.vorname       -- Vorname
                                              ,
                                              siebel_perfekter_bestandskunde.nachname      -- Nachname
                                              ,
                                              siebel_perfekter_bestandskunde.geburtsdatum  -- Geburtsdatum
                                              ,
                                              siebel_perfekter_bestandskunde.firmenname    -- Firmenname
                                              ,
                                              '' -- siebel_perfekter_bestandskunde.strasse    @deprecated @ticket FTTH-5038
                                              ,
                                              '' -- siebel_perfekter_bestandskunde.hausnummer @deprecated @ticket FTTH-5038
                                              ,
                                              '' -- siebel_perfekter_bestandskunde.plz        @deprecated @ticket FTTH-5038
                                              ,
                                              '' -- siebel_perfekter_bestandskunde.ort        @deprecated @ticket FTTH-5038
                                              ,
                                              siebel_perfekter_bestandskunde.iban          -- IBAN
                           -- neu @ticket FTTH-5038:
                                              ,
                                              pck_adresse.adresse_komplett(
                                                           piv_strasse               => siebel_perfekter_bestandskunde.strasse,
                                                           piv_hausnummer            => siebel_perfekter_bestandskunde.hausnr_von,
                                                           piv_hausnummer_zusatz     => siebel_perfekter_bestandskunde.hausnr_zusatz_von
                                                           ,
                                                           piv_hausnummer_bis        => siebel_perfekter_bestandskunde.hausnr_bis,
                                                           piv_hausnummer_zusatz_bis => siebel_perfekter_bestandskunde.hausnr_zusatz_bis
                                                           ,
                                                           piv_gebaeudeteil          => null -- kommt in der Siebel-View nicht vor
                                                           ,
                                                           piv_plz                   => siebel_perfekter_bestandskunde.plz,
                                                           piv_ort                   => siebel_perfekter_bestandskunde.ort,
                                                           piv_ortsteil              => null -- kommt in der Siebel-View nicht vor
                                                       )) );

                    exit; -- Schluss nach einer Zeile  
                end loop;
          -- /Fake: perfekter Bestandskunde


                for siebel_geburtsdatum_fehlt in (
                    select
                        global_id,
                        k.kundennummer,
                        anrede,
                        case upper(anrede)
                            when 'HERR' then
                                'MISTER'
                            when 'FRAU' then
                                'MISS'
                        end,
                        titel,
                        vorname,
                        nachname,
                        geburtsdatum,
                        firmenname,
                        strasse
                     -- @ticket FTTH-5038: Erweiterte/Zusatz-Felder aus der Siebel-View abfragen,
                     -- damit man daraus die ADRESSE_KOMPLETT bauen kann:
                        ,
                        hausnr_von,
                        hausnr_zusatz_von,
                        hausnr_bis,
                        hausnr_zusatz_bis,
                        plz,
                        ort,
                        ap_email,
                        ap_mobil_country,
                        ap_mobil_onkz || ap_x_mobil_nr,
                        iban
                    from
                        v_siebel_kundendaten  k -- Fake-Daten
                        left join v_ist_kunde_geloescht g on k.kundennummer = g.kundennummer
                    where
                            gueltig = 'Y'
                        and anrede is not null
                        and vorname is not null
                        and regexp_like ( trim(both '-' from trim(nachname)),
                                          '^[a-zA-Z \-]{2,30}$' )
                        and geburtsdatum is null
                        and -- Geburtsdatum fehlt
                         ap_email is not null
                        and ap_mobil_country is not null
                        and ap_mobil_onkz || ap_x_mobil_nr is not null
                        and iban is not null
                        and nvl(g.x_dsgvo_cust_locked, 'N') = 'N'-- FTTH-5490
                ) loop
                    pipe row ( new t_dublette('SIE'                                        -- src
                    ,
                                              siebel_geburtsdatum_fehlt.global_id     -- row_id (global_id)
                                              ,
                                              siebel_geburtsdatum_fehlt.kundennummer  -- kundennummer
                                              ,
                                              1                                            -- rule_number
                                              ,
                                              85                                           -- score
                                              ,
                                              siebel_geburtsdatum_fehlt.vorname       -- Vorname
                                              ,
                                              siebel_geburtsdatum_fehlt.nachname || ' [Geburtsdatum fehlt]',
                                              siebel_geburtsdatum_fehlt.geburtsdatum  -- Geburtsdatum
                                              ,
                                              siebel_geburtsdatum_fehlt.firmenname    -- Firmenname
                                              ,
                                              '' -- siebel_geburtsdatum_fehlt.strasse     @deprecated @ticket FTTH-5038
                                              ,
                                              '' -- siebel_geburtsdatum_fehlt.hausnummer  @deprecated @ticket FTTH-5038
                                              ,
                                              '' -- siebel_geburtsdatum_fehlt.plz         @deprecated @ticket FTTH-5038
                                              ,
                                              '' -- siebel_geburtsdatum_fehlt.ort         @deprecated @ticket FTTH-5038
                                              ,
                                              siebel_geburtsdatum_fehlt.iban          -- IBAN
                           -- neu @ticket FTTH-5038:
                                              ,
                                              pck_adresse.adresse_komplett(
                                                           piv_strasse               => siebel_geburtsdatum_fehlt.strasse,
                                                           piv_hausnummer            => siebel_geburtsdatum_fehlt.hausnr_von,
                                                           piv_hausnummer_zusatz     => siebel_geburtsdatum_fehlt.hausnr_zusatz_von,
                                                           piv_hausnummer_bis        => siebel_geburtsdatum_fehlt.hausnr_bis,
                                                           piv_hausnummer_zusatz_bis => siebel_geburtsdatum_fehlt.hausnr_zusatz_bis,
                                                           piv_gebaeudeteil          => null -- kommt in der Siebel-View nicht vor
                                                           ,
                                                           piv_plz                   => siebel_geburtsdatum_fehlt.plz,
                                                           piv_ort                   => siebel_geburtsdatum_fehlt.ort,
                                                           piv_ortsteil              => null -- kommt in der Siebel-View nicht vor
                                                       )) );

                    exit; -- Schluss nach einer Zeile  
                end loop;
              -- /Fake: Geburtsdatum fehlt

                for siebel_email_fehlt in (
                    select
                        global_id,
                        k.kundennummer,
                        anrede,
                        case upper(anrede)
                            when 'HERR' then
                                'MISTER'
                            when 'FRAU' then
                                'MISS'
                        end,
                        titel,
                        vorname,
                        nachname,
                        geburtsdatum,
                        firmenname,
                        strasse
                     -- @ticket FTTH-5038: Erweiterte/Zusatz-Felder aus der Siebel-View abfragen,
                     -- damit man daraus die ADRESSE_KOMPLETT bauen kann:
                        ,
                        hausnr_von,
                        hausnr_zusatz_von,
                        hausnr_bis,
                        hausnr_zusatz_bis,
                        plz,
                        ort,
                        ap_email,
                        ap_mobil_country,
                        ap_mobil_onkz || ap_x_mobil_nr,
                        iban
                    from
                        v_siebel_kundendaten  k -- Fake-Daten
                        left join v_ist_kunde_geloescht g on k.kundennummer = g.kundennummer
                    where
                            gueltig = 'Y'
                        and anrede is not null
                        and vorname is not null
                        and regexp_like ( trim(both '-' from trim(nachname)),
                                          '^[a-zA-Z \-]{2,30}$' )
                        and geburtsdatum is not null
                        and ap_email is null
                        and -- Email fehlt
                         ap_mobil_country is not null
                        and ap_mobil_onkz || ap_x_mobil_nr is not null
                        and iban is not null
                        and nvl(g.x_dsgvo_cust_locked, 'N') = 'N'-- FTTH-5490
                ) loop
                    pipe row ( new t_dublette('SIE'                                        -- src
                    ,
                                              siebel_email_fehlt.global_id     -- row_id (global_id)
                                              ,
                                              siebel_email_fehlt.kundennummer  -- kundennummer
                                              ,
                                              1                                            -- rule_number
                                              ,
                                              85                                           -- score
                                              ,
                                              siebel_email_fehlt.vorname       -- Vorname
                                              ,
                                              siebel_email_fehlt.nachname || ' [Email fehlt]',
                                              siebel_email_fehlt.geburtsdatum  -- Geburtsdatum
                                              ,
                                              siebel_email_fehlt.firmenname    -- Firmenname
                                              ,
                                              '' -- siebel_email_fehlt.strasse       @deprecated @ticket FTTH-5038
                                              ,
                                              '' -- siebel_email_fehlt.hausnummer    @deprecated @ticket FTTH-5038
                                              ,
                                              '' -- siebel_email_fehlt.plz           @deprecated @ticket FTTH-5038
                                              ,
                                              '' -- siebel_email_fehlt.ort           @deprecated @ticket FTTH-5038
                                              ,
                                              siebel_email_fehlt.iban          -- IBAN
                           -- neu @ticket FTTH-5038:
                                              ,
                                              pck_adresse.adresse_komplett(
                                                           piv_strasse               => siebel_email_fehlt.strasse,
                                                           piv_hausnummer            => siebel_email_fehlt.hausnr_von,
                                                           piv_hausnummer_zusatz     => siebel_email_fehlt.hausnr_zusatz_von,
                                                           piv_hausnummer_bis        => siebel_email_fehlt.hausnr_bis,
                                                           piv_hausnummer_zusatz_bis => siebel_email_fehlt.hausnr_zusatz_bis,
                                                           piv_gebaeudeteil          => null -- kommt in der Siebel-View nicht vor
                                                           ,
                                                           piv_plz                   => siebel_email_fehlt.plz,
                                                           piv_ort                   => siebel_email_fehlt.ort,
                                                           piv_ortsteil              => null -- kommt in der Siebel-View nicht vor
                                                       )) );

                    exit; -- Schluss nach einer Zeile  
                end loop;
              -- /Fake: Email fehlt              

        --/Fake-Daten SIEBEL----------------------------------------------------------
            end if; -- /C_FAKE_DUBLETTEN

    -- SIEBEL, als Ablösung von Fuzzy
            for chk_siebel in (
                select
                    global_id,
                    k.kundennummer,
                    anrede,
                    case upper(anrede)
                        when 'HERR' then
                            'MISTER'
                        when 'FRAU' then
                            'MISS'
                    end,
                    titel,
                    vorname,
                    nachname,
                    geburtsdatum,
                    firmenname,
                    strasse
             -- @ticket FTTH-5038: Erweiterte/Zusatz-Felder aus der Siebel-View abfragen,
             -- damit man daraus die ADRESSE_KOMPLETT bauen kann:
                    ,
                    hausnr_von,
                    hausnr_zusatz_von,
                    hausnr_bis,
                    hausnr_zusatz_bis
              --------------------------
                    ,
                    plz,
                    ort,
                    ap_email,
                    ap_mobil_country,
                    ap_mobil_onkz || ap_x_mobil_nr,
                    iban
                from
                    mv_siebel_kundendaten k -- 2024-07-17: Anstatt auf V_SIEBEL_KUNDENDATEN, welches ein Synonym ist für
                                    -- V_APX_GC_CUSTOMERDATA"@"SIEBP.NETCOLOGNE.INTERN@SIEBEL_INF,
                                    -- wird aufgrund der erheblich besseren Performance (< 10 Sek. vs. > 2 Min.)
                                    -- für die Siebel-Ähnlichkeitssuche nun die Materialized View angesprochen
                                    -- (deren Aktualisierungs-Intervall: 1 x täglich)
               -- /////// prüfen: Kann die MV nicht an praktisch allen anderen Stellen in diesem Package
               --         ebenfalls verwendet werden, anstatt V_SIEBEL_KUNDENDATEN?
                    left join v_ist_kunde_geloescht g on k.kundennummer = g.kundennummer
                where
                    (-- Suche mit Vor- und Nachname:
                     ( piv_firmenname is null
                        and upper(nachname) like '%'
                        || trim(upper(piv_nachname))
                        || '%'
                           and upper(vorname) like '%'
                                                   || trim(upper(piv_vorname))
                                                   || '%'
                        and ( geburtsdatum = pid_geburtsdatum
                              or geburtsdatum is null ) )
                      or ( -- Suche mit Firmenname:
                       piv_firmenname is not null
                           and upper(firmenname) like '%'
                                                      || trim(upper(piv_firmenname))
                                                      || '%' ) )
                    and nvl(g.x_dsgvo_cust_locked, 'N') = 'N'-- FTTH-5490
        -- AND GUELTIG = 'Y' -- 2024-07-17 Dies entfällt, da in der MVIEW sowieso nur gültige enthalten sind.
       -- @weiter 2024-06-19: oder allein der Firmenname wird geprüft
            ) loop
                pipe row ( new t_dublette('SIE',
                                          chk_siebel.global_id,
                                          chk_siebel.kundennummer,
                                          '' -- chk_siebel.rule_number
                                          ,
                                          '' -- chk_siebel.score
                                          ,
                                          chk_siebel.vorname,
                                          chk_siebel.nachname,
                                          chk_siebel.geburtsdatum,
                                          chk_siebel.firmenname,
                                          '' -- chk_siebel.strasse      @depreacted @ticket FTTH-5038
                                          ,
                                          '' -- chk_siebel.hausnummer   @depreacted @ticket FTTH-5038
                                          ,
                                          '' -- chk_siebel.plz          @depreacted @ticket FTTH-5038
                                          ,
                                          '' -- chk_siebel.ort          @depreacted @ticket FTTH-5038
                                          ,
                                          chk_siebel.iban
                   -- neu @ticket FTTH-5038:
                                          ,
                                          pck_adresse.adresse_komplett(
                                                   piv_strasse               => chk_siebel.strasse,
                                                   piv_hausnummer            => chk_siebel.hausnr_von,
                                                   piv_hausnummer_zusatz     => chk_siebel.hausnr_zusatz_von,
                                                   piv_hausnummer_bis        => chk_siebel.hausnr_bis,
                                                   piv_hausnummer_zusatz_bis => chk_siebel.hausnr_zusatz_bis,
                                                   piv_gebaeudeteil          => null -- kommt in der Siebel-View nicht vor
                                                   ,
                                                   piv_plz                   => chk_siebel.plz,
                                                   piv_ort                   => chk_siebel.ort,
                                                   piv_ortsteil              => null -- kommt in der Siebel-View nicht vor
                                               )) );

                if pin_find_1_only = 1 then
                    return;
                end if;
            end loop;

        end if;

    -- SIEBEL,
    -- Vergleich über IBAN ohne Fuzzy:
        if piv_suchbereich is null
           or piv_suchbereich in ( 'SIE', 'BNK' ) then
            for chk_sie_iban in (
                select
                    global_id,
                    k.kundennummer,
                    anrede,
                    case upper(anrede)
                        when 'HERR' then
                            'MISTER'
                        when 'FRAU' then
                            'MISS'
                    end,
                    titel,
                    vorname,
                    nachname,
                    geburtsdatum,
                    firmenname,
                    strasse
                 -- @ticket FTTH-5038: Erweiterte/Zusatz-Felder aus der Siebel-View abfragen,
                 -- damit man daraus die ADRESSE_KOMPLETT bauen kann:
                    ,
                    hausnr_von,
                    hausnr_zusatz_von,
                    hausnr_bis,
                    hausnr_zusatz_bis
                 --------------------
                    ,
                    plz,
                    ort,
                    ap_email,
                    ap_mobil_country,
                    ap_mobil_onkz || ap_x_mobil_nr,
                    iban
                from
                    mv_siebel_kundendaten k -- 2024-07-17: Anstatt auf V_SIEBEL_KUNDENDATEN, welches ein Synonym ist für
                                    -- V_APX_GC_CUSTOMERDATA"@"SIEBP.NETCOLOGNE.INTERN@SIEBEL_INF,
                                    -- wird aufgrund der erheblich besseren Performance (< 10 Sek. vs. > 2 Min.)
                                    -- für die Siebel-Ähnlichkeitssuche nun die Materialized View angesprochen
                                    -- (deren Aktualisierungs-Intervall: 1 x täglich)
                    left join v_ist_kunde_geloescht g on k.kundennummer = g.kundennummer
                where
                        iban = replace(piv_iban, ' ') -- geprüft am 2024-06-18: Es gibt lediglich 4 IBANs, die mit 'de' anstatt 'DE' beginnen:
                                                -- dafür opfere ich keinen möglicherweise bestehenden Index auf IBAN bei der Abfrage
            -- AND GUELTIG = 'Y' -- MV besitzt ausschließlich gültige Daten
                    and nvl(g.x_dsgvo_cust_locked, 'N') = 'N'-- FTTH-5490
            ) loop
                pipe row ( new t_dublette('BNK',
                                          chk_sie_iban.global_id,
                                          chk_sie_iban.kundennummer,
                                          '' -- chk_sie_iban.rule_number
                                          ,
                                          '' -- chk_sie_iban.score
                                          ,
                                          chk_sie_iban.vorname,
                                          chk_sie_iban.nachname,
                                          chk_sie_iban.geburtsdatum,
                                          chk_sie_iban.firmenname,
                                          '' -- chk_sie_iban.strasse     @deprecated @ticket FTTH-5038
                                          ,
                                          '' -- chk_sie_iban.hausnummer  @deprecated @ticket FTTH-5038
                                          ,
                                          '' -- chk_sie_iban.plz         @deprecated @ticket FTTH-5038
                                          ,
                                          '' -- chk_sie_iban.ort         @deprecated @ticket FTTH-5038
                                          ,
                                          chk_sie_iban.iban
               -- neu @ticket FTTH-5038:
                                          ,
                                          pck_adresse.adresse_komplett(
                                                   piv_strasse               => chk_sie_iban.strasse,
                                                   piv_hausnummer            => chk_sie_iban.hausnr_von,
                                                   piv_hausnummer_zusatz     => chk_sie_iban.hausnr_zusatz_von,
                                                   piv_hausnummer_bis        => chk_sie_iban.hausnr_bis,
                                                   piv_hausnummer_zusatz_bis => chk_sie_iban.hausnr_zusatz_bis,
                                                   piv_gebaeudeteil          => null -- kommt in der Siebel-View nicht vor
                                                   ,
                                                   piv_plz                   => chk_sie_iban.plz,
                                                   piv_ort                   => chk_sie_iban.ort,
                                                   piv_ortsteil              => null -- kommt in der Siebel-View nicht vor
                                               )) );

                if pin_find_1_only = 1 then
                    return;
                end if;
            end loop;
        end if;

--/SIEBEL----------------------------------------------------------

        return;
    exception
        when no_data_needed then
            return;
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end ft_vorbestellung_dublettencheck;     

  -- @progress 2024-08-08 @karolina



 /**
 * Gibt TRUE zurück und füllt die entsprechenden OUT-Felder, wenn anhand der Eingabe-Parameter ein Sprung
 * von APEX-Seite 14 ("Vorbestellung") zu Seite 100 ("Auftragserfassung") möglich ist, wobei dann in APEX
 * die zu den piv_...-Eingabefeldern zugehörigen Items vorbelegt werden
 *
 * @ticket SKV-172883: Prüfen, ob in dieser Function eine weitere Bedingung abgeprüft werden muss ("can_branch")
 * 
 * @param piv_haus_lfd_nr  [IN] 
 * @param piv_kundennummer [IN] 
 * @param piv_mandant      [IN] 
 * @param pov_ausbaustatus [OUT] 
 * @param pov_usermessage  [OUT] 
 * @param pov_link         [OUT] 
 * 
 * @return BOOLEAN
 * @ticket FTTH-4084
 * @usage  APEX Seite 14, Branch "Aufruf aus SIEBEL: Weiter zur Erfassung". Der eigehende Link aus Siebel
 *         sieht beispielsweise so aus:
 *         https://romae.netcologne.intern/ords_e/r/roma/glascontainer/vorbestellung?request=siebel&p14_haus_lfd_nr=1157662&p14_kundennummer=13009180&p14_mandant=nc
 * (DEV):  https://romae.netcologne.intern/ords_e/r/roma/glascontainer/vorbestellung?request=siebel&p14_haus_lfd_nr=1637690&p14_kundennummer=13009180&p14_mandant=nc
 * @unittest:
 * SELECT * FROM TABLE(ut.run('UT_GLASCONTAINER', a_tags => 'SIEBEL_VORBESTELLUNG_BRANCH'));
 */
    function siebel_vorbestellung_branch (
        piv_haus_lfd_nr      in varchar2,
        piv_kundennummer     in varchar2,
        piv_mandant          in varchar2,
        pov_ausbaustatus     out varchar2,
        pov_wholebuy_partner out varchar2,
        pov_technologie      out varchar2
     -- hier min/max bandbreite hinzufügen, ggf. TCOM_ADR_BSA.FTTH_DURCHSATZ?
        ,
        pov_usermessage      out varchar2,
        pov_link_objektinfo  out varchar2
    ) return boolean is

        v_haus_lfd_nr_gefunden       number;
        v_eigentuemerdaten_notwendig varchar2(1);
        can_branch                   boolean := false;
        txt_objektinfo               constant varchar2(1000) := 'Eine Erfassung des Auftrags im Glascontainer ist deshalb nicht möglich. ' || 'Öffnen Sie gegebenenfalls die Objektinfo-App für weitere Informationen.'
        ;
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name              constant logs.routine_name%type := 'siebel_vorbestellung_branch';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_haus_lfd_nr', piv_haus_lfd_nr);
            pck_format.p_add('piv_kundennummer', piv_kundennummer);
            pck_format.p_add('piv_mandant', piv_mandant);
      -- (OUT): pov_ausbaustatus
      -- (OUT): pov_usermessage
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
  -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------
        function fv_link_objektinfo return varchar2 is
        begin
            return apex_page.get_url(
                p_application => 1200,
                p_page        => 1
        --p_session           => 
        --p_request           => 
        --p_debug             => 
        --p_clear_cache       => 
                ,
                p_items       => 'P0_HAUS_LFD_NR',
                p_values      => piv_haus_lfd_nr
        --p_printer_friendly  => 
        --p_trace             =>         
            );
        end;

    begin

 --   pov_usermessage := NULL; -- Resetten, damit man bei erfolglosem Branch beim nächsten Seitenaufruf wieder normal
                             -- weitermachen kann

  /* Es wird geprüft, ob die übergebene Hauslfdnr. in der TCOM_ADR_BSA den Ausbaustatus "HomesReady" 
     oder der DG_ADR_BSA den Ausbaustatus "HomesConnected" hat
     und sich nicht in einem Eigennetz Vermarktungscluster befindet,
     andernfalls wird eine sprechende 
     Hinweismeldung angezeigt und ein Link in die Objektinfo.
  */
  -- Plausi 2024-09-03:
        if piv_haus_lfd_nr is null
           or piv_kundennummer is null
        or piv_mandant is null then
            return false;
        end if;

    -- @todo @weiter 2024-08-14: Eigene Funktion für die Selektion des Ausbaustatus schreiben und hier nur referenzieren.

    -- Wurde ergänzt am 2024-08-20: Das Objekt darf sich nicht in einem Eigennetz-Vermarktungscluster befinden.
        declare
            v_vc_eigennetz_name vermarktungscluster.bezeichnung%type;
        begin
            select
                max(bezeichnung),
                max(status),
                max(dt.dnsttp_bez)
            into
                v_vc_eigennetz_name -- Der Name des Vermarktungsclusters genügt als Begründung für den Ausstieg
                ,
                pov_ausbaustatus,
                pov_technologie -- Diese Felder sind nur noch "just for info", falls die aufrufende Seite
                                               -- sie der Vollständigkeit halber darstellen möchte
            from
                     vermarktungscluster_objekt vco
                join vermarktungscluster vc on ( vc.vc_lfd_nr = vco.vc_lfd_nr )
                join tab_dienst_typ      dt on ( dt.dnsttp_lfd_nr = vc.dnsttp_lfd_nr )
            where
                    vco.haus_lfd_nr = piv_haus_lfd_nr
                and vc.wholebuy is null -- Vermarktungscluster ist NetCologne-Eigennetz
                and vc.status in ( 'PREMARKETING', 'UNDERCONSTRUCTION' ) -- neu 2025-03-18
                ;

      -- Ausstieg wenn Eigennetz gefunden:
            if v_vc_eigennetz_name is not null then
                pov_usermessage := 'Das Objekt HAUS_LFD_NR '
                                   || piv_haus_lfd_nr
                                   || ' befindet sich im Eigennetz (Vermarktungscluster "'
                                   || v_vc_eigennetz_name
                                   || ', Status'
                                   || pov_ausbaustatus
                                   || '"). '
                                   || txt_objektinfo;

                pov_link_objektinfo := fv_link_objektinfo;
                return false;
            end if;

        end;    

    -- weiter in den BSA-Tabellen suchen:

    -- Erste Prüfung in TCOM_ADR_BSA:
        select
            max(haus_lfd_nr),
            fv_vc_status_webservice(max(ausbaustatus_nc))
      -- , ausbaustatus_kurzform : TCOM HomesReady     = ready
      --                             DG HomesConnected = connected
            ,
            max(substr(eigentuemerdaten_notwendig, 1, 1)) -- "X" = ja
        into
            v_haus_lfd_nr_gefunden,
            pov_ausbaustatus,
            v_eigentuemerdaten_notwendig
        from
            tcom_adr_bsa
        where
                haus_lfd_nr = piv_haus_lfd_nr
            and mapping_status = 'OK';

        if v_haus_lfd_nr_gefunden is not null then
            pov_wholebuy_partner := anbieter_telekom;
        end if;

    -- Falls dort nicht gefunden, Prüfung in DG_ADR_BSA
        if pov_wholebuy_partner is null 
    -- 2025-03-18 @ticket FTTH-5113: 
           or pov_ausbaustatus is null -- Es gibt Einträge von HAUS_LFD_NRn ohne NC_AUSBAUSTATUS,
                                -- für die in der DG_ADR_BSA der gewünschte Treffer gefunden werden kann,
                                -- also nun auch in solchen Fällen weitersuchen.
            then
            select
                max(haus_lfd_nr)
        -- , fv_vc_status_webservice(max(ausbaustatus)) -- @ticket FTTH-5330: anstatt AUSBAUSTATUS auf AUSBAUSTATUS_NC schauen
                ,
                fv_vc_status_webservice(max(ausbaustatus_nc))
            into
                v_haus_lfd_nr_gefunden,
                pov_ausbaustatus
          -- Eigentümerdaten-Feld nicht vorhanden in dieser Tabelle
            from
                dg_adr_bsa
            where
                    haus_lfd_nr = piv_haus_lfd_nr
                and mapping_status = 'OK';

            if v_haus_lfd_nr_gefunden is not null then
                pov_wholebuy_partner := anbieter_deutsche_glasfaser;
            end if;
        end if;

    -- Liegen die Voraussetzungen vor, in die Vorbestellung zu verzweigen?
        case
            when
                pov_wholebuy_partner = anbieter_telekom
                and pov_ausbaustatus = 'HOMES_READY'
            then
                can_branch := true;
                pov_technologie := 'FTTH BSA L2';
            when
                pov_wholebuy_partner = anbieter_deutsche_glasfaser 
              -- @ticket FTTH-5330, siehe Kommentar: 
              -- "Der AUSBAUSSTATUS "homesPrepared" wird dabei auf den AUSBAUSTATUS_NC "homesConnected" gemappt."         
                and pov_ausbaustatus = 'HOMES_CONNECTED'
            then
                can_branch := true;
                pov_technologie := 'FTTH BSA L2 DG';
            else -- Verzweigen nicht möglich, da die Daten dies nicht hergeben:
                can_branch := false;
        end case;

        if not can_branch then
            pov_usermessage := 'Der Ausbaustatus des Objekts HAUS_LFD_NR '
                               || piv_haus_lfd_nr
                               ||
                case
                    when pov_ausbaustatus is null then
                        ' konnte nicht ermittelt werden'
                    else ' ist ' || pov_ausbaustatus
                end
                               || '. '
                               || txt_objektinfo;

            pov_link_objektinfo := fv_link_objektinfo;
        end if;

        return can_branch;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => qualified_name(cv_routine_name),
                piv_scope        => g_scope
            );

            raise;
    end siebel_vorbestellung_branch;      


  /**      
   * Gibt 1 zurück, wenn für ein Objekt die Notwendigkeit der Eigentümerdaten besteht,
   * 0 wenn nicht und NULL wenn dazu keine Informationen vorliegen.
   *
   * @param pin_haus_lfd_nr       [IN ]  Objekt-ID
   * @param piv_wholebuy_partner  [IN ]  Wholebuy-Partner für dieses Objekt, falls zutreffend ('TCOM' oder 'DG')
   *                                     ansonsten NULL
   *                                     Wenn gesetzt, kann unter Umständen die Abfrage effizienter ausgeführt werden
   *
   * @usage  Die Prozedur berücksichtigt Vermarktungscluster-Objektzuordnungen sowie die Informationen
   *         in der Tabelle TCOM_ADR_BSA
   *
   * @example
   * SELECT
   *   pck_glascontainer_order.fn_eigentuemerdaten_notwendig(
   *       pin_haus_lfd_nr      => 1484499
   *     , piv_wholebuy_partner => 'TCOM')
   * FROM dual;   
   */
    function fn_eigentuemerdaten_notwendig (
        pin_haus_lfd_nr      in number,
        piv_wholebuy_partner in varchar2
    ) return natural is

        v_eigentuemerdaten_notwendig natural;
        v_haus_lfd_nr_gefunden       number;
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name              constant logs.routine_name%type := 'fn_eigentuemerdaten_notwendig';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_haus_lfd_nr', pin_haus_lfd_nr);
            pck_format.p_add('piv_wholebuy_partner', piv_wholebuy_partner);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
  -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------     
    begin
        case piv_wholebuy_partner
            when 'DG' then
                return 0; -- Deutsche Glasfaser verlangt niemals Eigentümerdaten
            when anbieter_telekom then
                select
                    decode(
                        max(eigentuemerdaten_notwendig),
                        'X',
                        1
                    ),
                    max(haus_lfd_nr)
                into
                    v_eigentuemerdaten_notwendig,
                    v_haus_lfd_nr_gefunden
                from
                    tcom_adr_bsa
                where
                    haus_lfd_nr = pin_haus_lfd_nr;
        -- In der Tabelle kommt nur 'X' oder NULL vor. Wenn es also einen Eintrag gibt,
        -- wovon auszugehen ist, dann gilt NULL als ein Nein (=0).
                if
                    v_haus_lfd_nr_gefunden is not null
                    and v_eigentuemerdaten_notwendig is null
                then
                    v_eigentuemerdaten_notwendig := 0;
                end if;
            else
                null; -- kein Wholebuy-Partner (NULL) oder unbekannter Wert
        end case;

    -- Wenn bis hier keine Infos gefunden wurden, dann
        if v_eigentuemerdaten_notwendig is null then
    -- prüfen, ob es (aus welchem Grund auch immer) ersatzweise einen Eintrag in VCO gibt:
            select
                max(eigentuemerdaten_notwendig) -- 1, 0 oder NULL.
            into v_eigentuemerdaten_notwendig
            from
                vermarktungscluster_objekt vco
            where
                haus_lfd_nr = pin_haus_lfd_nr;

        end if;

    -- Wenn jetzt immer noch nichts vorhanden ist, und gleichzeitig der WHOLEBUY-Partner NULL ist
    -- (d.h. die Wholebuy-Information lag dem aufrufenden Programm evtl nicht vor), dann rufen wir
    -- diese Funktion rekursiv für die Telekom auf - denn das ist (Stand 2024-08) der einzige Ort,
    -- wo die Information stehen könnte:
        if
            v_eigentuemerdaten_notwendig is null
            and piv_wholebuy_partner is null
        then
            return fn_eigentuemerdaten_notwendig(pin_haus_lfd_nr, anbieter_telekom);
        end if;

        return v_eigentuemerdaten_notwendig;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end;

  -- @progress 2024-08-27 ---------------

/**
 * Gibt das Datum des voraussichtlichen (FTTH-)Fertigstellungstermins für eine Adresse zurück
 *
 * @ticket FTTH-4084
 *
 * @param piv_wholebuy  Entweder TCOM oder DG (Stand 2024-08)
 */
    function fd_ausbau_plan_termin (
   --   pin_haus_lfd_nr  IN NUMBER   DEFAULT NULL -- /// implementieren sobald erforderlich
   -- , pin_vc_lfd_nr    IN NUMBER   DEFAULT NULL -- /// implementieren sobald erforderlich
        piv_wholebuy in varchar2 default null
    ) return date is
        v_termin date;
    begin
        if --pin_haus_lfd_nr IS NULL AND
       --pin_vc_lfd_nr   IS NULL AND
         piv_wholebuy is null then
            raise_application_error(c_plausi_error_number, 'Es wurde kein Parameter zur Ermittlung des Plan-Termins übergeben');
        end if;
        if piv_wholebuy is not null then
            case piv_wholebuy
                when anbieter_telekom then
                    v_termin := trunc(sysdate) + 180;
                when anbieter_deutsche_glasfaser then
                    v_termin := trunc(sysdate) + 14; -- abgestimmt mit Holger Lüchow
            end case;

            return v_termin;
        end if;

        return v_termin;
    end fd_ausbau_plan_termin;

  -- @progress 2024-09-03

/**
 * Liefert die Nummer des nächsten Steps zurück, der nach dem Klicken von "Weiter" bei der 
 * Bestellerfassung anhand der eingegebenen oder im Hintergrund ermittelten Daten aufgerufen werden muss,
 * oder den Wert 110 für "gehe zur Zusammenfassung".
 * NULL wird zurückgegeben, wenn hier keine Bedingung implementiert ist;
 * in diesem Fall ziehen die noch vorhandenen Branches in APEX.
 *
 * @param  pin_step                        [IN ]  Nummer des aktuellen Steps, auf dem sich der Button "Weiter" befindet (:P100_STEP)
 * @param  piv_kontext                     [IN ]  NULL oder ein definierter Wert. Derzeit nur: "SIEBEL"
 * @param  piv_kundenstatus                [IN ]  N|B (Neukunde|Bestandskunde)
 * @param  piv_technologie                 [IN ]  Ausbautechnologie ('FTTH', 'FTTH BSA L2' etc...)
 * @param  piv_rolle                       [IN ]  TENANT|
 * @param  piv_eigentuemerdaten_notwendig  [IN ]  "1" oder "X"=ja, "0"=nein, NULL=unbekannt
 *
 * @usage APEX P100: Vor der Ausführung der Processing/Branches (derzeit nur relevant bei den Steps 3, 4, und 5) wird
 *                   diese Step-Nummer in das neue Hidden Item P100_NEXT_STEP eingetragen. Alle Entscheidungen, die hier
 *                   nicht getroffen werden, haben zur Folge, dass P100_NEXT_STEP auf NULL gesetzt wird und somit der
 *                   Branch namens "NEXT STEP" nicht zieht.
 * @ticket FTTH-4222
 */
    function fn_next_step (
        pin_step                       in natural,
        piv_kontext                    in varchar2,
        piv_kundenstatus               in varchar2,
        piv_technologie                in varchar2 default null,
        piv_rolle                      in varchar2 default null,
        piv_eigentuemerdaten_notwendig in natural default null
    ) return natural is

        v_next_step                natural;
        step_1_produktauswahl      constant naturaln := 1;
        step_2_neukunde            constant naturaln := 2;
        step_3_bestandskunde       constant naturaln := 3;
        step_4_dublettenpruefung   constant naturaln := 4;
        step_5_anbieterwechsel     constant naturaln := 5;
        step_6_gee                 constant naturaln := 6;
        zusammenfassung            constant naturaln := 110; -- bewirkt, dass zur Seite 110 gesprungen wird
                                                          -- (siehe APEX Branch "NEXT STEP: Zusammenfassung")    

        kontext_siebel             constant varchar2(30) := 'SIEBEL';
        kundenstatus_bestandskunde constant varchar2(30) := 'B';
        kundenstatus_neukunde      constant varchar2(30) := 'N';
        rolle_eigentumer           constant varchar2(30) := 'OWNER';
        rolle_mieter               constant varchar2(30) := 'TENANT';
        rolle_teileigentuemer      constant varchar2(30) := 'PART_OWNER';
        technologie_ftth           constant varchar2(30) := 'FTTH';
        technologie_ftth_bsa_l2    constant varchar2(30) := 'FTTH BSA L2';
        technologie_ftth_bsa_l2_dg constant varchar2(30) := 'FTTH BSA L2 DG';
        bestellung_ist_wholebuy    constant boolean := nvl(piv_technologie in(technologie_ftth_bsa_l2, technologie_ftth_bsa_l2_dg), false
        );
        eigentuemerdaten_notwendig constant boolean :=
            case
                when nullif(piv_eigentuemerdaten_notwendig, 0) is not null then
                    true
                else false
            end;
        kunde_ist_eigentuemer      constant boolean :=
            case piv_rolle
                when rolle_eigentumer then
                    true
                when rolle_teileigentuemer then
                    false
                when rolle_mieter then
                    false
                else false
            end;
-- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name            constant logs.routine_name%type := 'fn_next_step';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_step', pin_step);
            pck_format.p_add('piv_kontext', piv_kontext);
            pck_format.p_add('piv_kundenstatus', piv_kundenstatus);
            pck_format.p_add('piv_technologie', piv_technologie);
            pck_format.p_add('piv_rolle', piv_rolle);
            pck_format.p_add('piv_eigentuemerdaten_notwendig', piv_eigentuemerdaten_notwendig);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
-- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------     
    begin
        case pin_step -- aktueller Step
      ---------------------------
            when step_1_produktauswahl then -- Produkt/Tarifauswahl
                null; -- Returnwert bleibt leer => Item P100_NEXT_STEP wird NULL => Branch "NEXT STEP" wird nicht ausgeführt, sondern irgendeiner danach
      ---------------------------
            when step_2_neukunde then -- Neukunde
                null; -- Returnwert bleibt leer => Item P100_NEXT_STEP wird NULL => Branch "NEXT STEP" wird nicht ausgeführt, sondern irgendeiner danach
      ----------------------------
            when step_3_bestandskunde then -- Bestandskunde:
         -- Üblicherweise werden nach den Bestandskundendaten die Eigentümerdaten abgefragt
         -- (die Dublettensuche wird per Definition für Bestandskunden niemals aufgerufen).
         -- Grundsätzlich also:
                v_next_step := step_6_gee;

         -- Im Falle einer Verlinkung aus SIEBEL soll die GEE-Abfrage unter bestimmten Bedinungen entfallen.
         -- @ticket FTTH-4084:
                if piv_kontext = kontext_siebel -- @ticket FTTH-4222: bei SIEBEL-Vorbestellung, die durch Verlinkung aufgerufen wird
                 then
         -- Hierbei handelt es sich IMMER um eine Wholebuy-Bestellung, da ansonsten der Kontext nicht SIEBEL sein kann
         -- (passende Statuswerte wurden in den ..._ADR_BSA-Tabellen nicht gefunden - in dem Fall bekäme der User 
         -- einen Link zur Objektinfo angezeigt).
         -- Ticket 4084 sagt: "Sind keine Eigentümerdaten angefordert oder ist der Kundentyp Eigentümer, wird der GEE-Step nicht angezeigt."
         -- "Sind für die Adresse Eigentümerdaten angefordert, wird der GEE-Step für Mieter oder Teileigentümer angezeigt" 
         -- (ist bereits oben als Normalfall festgelegt)
                    if ( not eigentuemerdaten_notwendig )
                    or kunde_ist_eigentuemer then
                        v_next_step := zusammenfassung; -- GEE nicht anzeigen
                    end if;
           -- (fast dieselbe Bedingung gilt im Folgenden auch für Step 4!)

                end if;
      ---------------------------
            when step_4_dublettenpruefung then -- Dublettenprüfung
                v_next_step := step_5_anbieterwechsel; -- grundsätzlich. Gilt immer für Neukunden.
                if piv_kundenstatus = kundenstatus_bestandskunde -- das ist immer dann der Fall, wenn bei der Dublettensuche 
                                                         -- ein Treffer gelandet wurde und daher der Kunde fortan als 
                                                         -- Bestandskunde weitergeführt wird
                 then
                    v_next_step := step_6_gee; -- grundsätzlich für Bestandskunden

              -- //// die gleiche Bedingung wie in Step 5 s.u. implementieren???
                    if
                        bestellung_ist_wholebuy
                        and ( ( not eigentuemerdaten_notwendig )
                        or kunde_ist_eigentuemer ) 
                -- //// Aufpassen: Bei Eigentümern generell die GEE-Abfrage weglassen oder nur unter diesen bestimmten Bedinungen???
                    then
                        v_next_step := zusammenfassung; -- GEE nicht anzeigen
                    end if;

                end if;
      ---------------------------
            when step_5_anbieterwechsel then -- Anbieterwechsel
        -- grundsätzlich:
                v_next_step := step_6_gee;

        -- @ticket FTTH-4084:
                if piv_kontext = kontext_siebel then
                    if ( not eigentuemerdaten_notwendig )
                    or kunde_ist_eigentuemer then
                        v_next_step := zusammenfassung; -- GEE nicht anzeigen
                    end if;
                end if;

        -- @ticket FTTH-3360
        /*  ehemals in APEX:
        IF piv_technologie IN ('FTTH BSA L2', 'FTTH BSA L2 DG') AND piv_rolle = 'OWNER'
        OR
        (piv_technologie IN ('FTTH BSA L2', 'FTTH BSA L2 DG') 
          AND piv_rolle != 'OWNER' 
          AND EIGENTUEMERDATEN_NOTWENDIG = 0
        )
        */
        -- @ticket FTTH-3360
                if bestellung_ist_wholebuy then
                    if piv_rolle = 'OWNER' -- (AK 4)
                    or (
                        piv_rolle in ( 'TENANT', 'PART_OWNER' )
                        and not eigentuemerdaten_notwendig -- (AK 5)
                    ) then
                        v_next_step := zusammenfassung; -- GEE nicht anzeigen
            -- AK 6: gehe zur GEE, Zuweisung ist bereits oben erfolgt
                    end if;
                end if;

      ---------------------------
            when step_6_gee then -- GEE (Grundstückseigentümer-Erklärung)
                v_next_step := zusammenfassung;
      ---------------------------
            else
                null; -- Returnwert bleibt leer => Item P100_NEXT_STEP wird NULL => Branch "NEXT STEP" wird nicht ausgeführt
        end case;

        return v_next_step;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end fn_next_step;  



/**
 * Wertet das User-Verhalten in der Bestellerfassung anonym aus und gibt die Zahlen pipelined zurück,
 * die dann vom Classic Report auf Seite 10056 im Glascontainer angezeigt werden.
 *
 * Die Spalten im Ergebnis sind:
 * POS                    Anzeige-Reihenfolge
 * INFOLEVEL              [0..3] Einrückungsebene
 * VORGANG                String (AUFRUF|BESTELLUNG) zur Kontrolle des Ergebnisse, wird nicht angezeigt
 * ANZAHL                 Gezählte Ereignisse. Entspricht derselben Zahl in der ganz rechten Spalte, diese ist dort
 *                        nur aus Gründen der Report-Darstellung erneut vorhanden - so muss man bei Abfragen nicht wissen, 
 *                        in welcher Spalte D1...D4 sie steht
 * D0, D1, D2, D3, D4     Der gemäß @ticket FTTH-4003 anzuzeigende Text 
 *
 * @param pid_von  [IN ]  Tagesdatum entsprechend dem Eingabefeld "von"
 * @param pid_bis  [IN ]  Tagesdatum entsprechend dem Eingabefeld "vbis"
 *
 * @example Order-Statistik vom gestrigen Tag:
 * SELECT * FROM TABLE(PCK_GLASCONTAINER_ORDER.FP_ORDER_TRACKING(SYSDATE-1)) ORDER BY POS NULLS LAST;
 */
    function fp_order_tracking (
        pid_von in date default null,
        pid_bis in date default null
    ) return t_order_trackings
        pipelined
    is

        datum_von                constant date := trunc(coalesce(pid_von, date '2024-09-20')); -- erster Tag der Datenerfassung
        datum_bis                constant date := trunc(coalesce(pid_bis, pid_von, sysdate));
    --------------------------
        aufrufe                  naturaln := 0;
        aufrufe_siebel           naturaln := 0;
    --------------------------
        einstieg_neukunde        naturaln := 0;
        dubletten_nicht_gefunden naturaln := 0;
        dublette_gefunden_inp    naturaln := 0;
        dublette_gefunden_sie    naturaln := 0;
        dublette_gefunden_pob    naturaln := 0;
        einstieg_bestandskunde   naturaln := 0; -- entspricht BESTELLUNGEN_B
    --------------------------
        bestellungen             naturaln := 0;
    --BESTELLUNGEN_N              NATURALN := 0; -- diese Zahl wird in der Auswertung momentan nicht gerendet. Ersetzt durch "EINSTIEG_NEUKUNDE"
    --BESTELLUNGEN_B              NATURALN := 0; -- diese Zahl wird in der Auswertung momentan nicht gerendet. Ersetzt durch "EINSTIEG_BESTANDSKUNDE"

        pos_unbekannt            natural := null;

        function bold (
            i_text in varchar2
        ) return varchar2 is
        begin
            return '<b>'
                   || i_text
                   || '</b>';
        end;

    begin
        for d in (
     -- Für den Einstieg in die Bestellerfassung aus dem Glascontainer selbst zählt der Klick auf den Menüpunkt
     -- "Vorbestellung". Dieser liefert den REQUEST = 'GC' und landet auf Seite 14 zwecks Adresseingabe.
            with aufrufe_bestellstrecke as (
                select
                    trunc(datum) as datum,
                    'GC'         as d0
                from
                    pob_tracking
                where
                    trunc(datum) between datum_von and datum_bis
                    and app_page_id = 14
                    and upper(request) = 'GC'
     -- Beim Aufruf der Vorbestellung durch SIEBEL wird die Adresseingabe übergangen. Dies passiert, indem ein
     -- Pre-Rendering-Branch auf Seite 14 den User direkt auf Seite 100 leitet (mit REQUEST = 'SIEBEL'). 
     -- Daher darf in diesem Fall nicht die Seite 14 gezählt werden, sondern erst die Seite 100 nach Weiterleitung.
                union all
                select
                    trunc(datum),
                    'SIEBEL' as d0
                from
                    pob_tracking
                where
                    trunc(datum) between datum_von and datum_bis
                    and app_page_id = 100
                    and upper(request) = 'SIEBEL'
            ), bestellung as (
                select
                    trunc(datum) as datum
                  -- , CASE KUNDENSTATUS WHEN 'N' THEN 'NEUKUNDE' WHEN 'B' THEN 'BESTANDSKUNDE' ELSE '?' || KUNDENSTATUS END AS d1
                  -- Erfolgt der Einstieg als Neukunde oder Bestandskunde?
                  -- Dies lässt sich allein über die Werte in den Dubletten-Spalten ermitteln:
                  -- Für Bestandskunden wird keine Dublettenprüfung aufgerufen, daher stehen dort keine Zahlen.
                    ,
                    case
                        when dubletten_sie is null
                             and dubletten_pob is null then
                            'BESTANDSKUNDE'
                        else
                            'NEUKUNDE'
                    end          as d1 -- "Einstieg als..."

               -- gleiches Thema:              
              --  , CASE WHEN kundenstatus = 'N' THEN
              --        -- Dubletten
              --        CASE when nvl(dubletten_sie, 0) + nvl(dubletten_pob, 0) = 0 then '' -- KEINE DUBLETTE
              --             ELSE kundendaten -- INP|SIE|POB
              --        END 
              --    END AS D2
                    ,
                    case
                        when dubletten_sie is not null
                             or dubletten_pob is not null then -- Es wurden Dubletten gesucht bzw. präsentiert (auch: 0)
                                case
                                    when nvl(dubletten_sie, 0) + nvl(dubletten_pob, 0) = 0 then
                                        '-' -- gesucht, aber keine Dublette gefunden
                                    else
                                        kundendaten -- INP|SIE|POB
                                end
                    end          as d2
                from
                    v_pob_tracking
                where
                        request = 'BTN_VORBESTELLUNG_ERFASSEN'
                    and kundenstatus is not null
                    and trunc(datum) between datum_von and datum_bis
            )
      -- Auswertung:
            select
                datum,
                vorgang,
                d0,
                d1,
                d2,
                d3,
                count(*) as anzahl
            from
                (
                    select
                        datum,
                        'AUFRUF' as vorgang,
                        d0,
                        null     as d1,
                        null     as d2,
                        null     as d3
                    from
                        aufrufe_bestellstrecke
                    union all
                    select
                        datum,
                        'BESTELLUNG' as vorgang,
                        null         as d0,
                        d1,
                        d2,
                        null         as d3
                    from
                        bestellung
                )
            group by
                datum,
                vorgang,
                d0,
                d1,
                d2,
                d3
            order by
                datum,
                vorgang,
                d0,
                d1,
                d2,
                d3
        ) loop
            case d.vorgang
                when 'AUFRUF' then
                    aufrufe := aufrufe + d.anzahl;
                    if d.d0 = 'SIEBEL' then
                        aufrufe_siebel := aufrufe_siebel + d.anzahl;
                    end if;

                when 'BESTELLUNG' then
                    bestellungen := bestellungen + d.anzahl;
                  /*
                  CASE d.d1
                       -- dies hält fest, welcher Kundenstatus beim Absenden der Bestellung vorlag,
                       -- und nicht, mit welchem Kundenstatus (vor Dublettenprüfung) der Bestellvorgang begonnen wurde
                       WHEN 'BESTANDSKUNDE' THEN BESTELLUNGEN_B := BESTELLUNGEN_B + d.anzahl; -- diese Zahl wird in der Auswertung momentan nicht gerendet
                       WHEN 'NEUKUNDE'      THEN BESTELLUNGEN_N := BESTELLUNGEN_N + d.anzahl; -- diese Zahl wird in der Auswertung momentan nicht gerendet
                       ELSE NULL;
                  END CASE;
                  */
                    case
                        when d.d2 is null then -- es wurde keine Dublettensuche durchgeführt, daher muss es sich
                         -- zu Beginn der Bestellung um einen Bestandskunden gehandelt haben:
                            einstieg_bestandskunde := einstieg_bestandskunde + d.anzahl;
                        else
                          -- Änderung zum Wortlaut des Tickets: Wenn Dubletten-Daten übernommen werden, dann
                          -- ändert sich per Definition der Kundenstatus von NEUKUNDE auf BESTANDSKUNDE.
                          -- Daher war die Frage nach "Bestellt als Neukunde" falsch betitelt, sondern es geht nur darum,
                          -- ob dem Glascontainer-User Dubletten angezeigt wurden oder nicht.
                          -- Das Wording wird demzufolge geändert auf "Einstieg als Neukunde" (siehe unten)                       
                            einstieg_neukunde := einstieg_neukunde + d.anzahl;
                            case d.d2 -- "KUNDENDATEN"
                                when 'INP' then
                                    dublette_gefunden_inp := dublette_gefunden_inp + d.anzahl;
                                when 'SIE' then
                                    dublette_gefunden_sie := dublette_gefunden_sie + d.anzahl;
                                when 'POB' then
                                    dublette_gefunden_pob := dublette_gefunden_pob + d.anzahl;
                                else -- '-'
                                    dubletten_nicht_gefunden := dubletten_nicht_gefunden + d.anzahl;
                            end case;

                    end case;

                else
                    null;
            end case;
        end loop;

    -- Vorgang: D0
        pipe row ( new t_order_tracking(
            pos       => 10,
            infolevel => 0,
            anzahl    => aufrufe,
            vorgang   => 'AUFRUF',
            d0        => 'Bestellstrecke aufgerufen',
            d1        => bold(aufrufe)
        ) );

        if aufrufe_siebel > 0 then
            pipe row ( new t_order_tracking(
                pos       => 11,
                infolevel => 0,
                anzahl    => aufrufe_siebel,
                vorgang   => 'AUFRUF',
                d0        => '(davon aus SIEBEL)',
                d1        => bold(aufrufe_siebel)
            ) );
        end if;
    -- D1:
        pipe row ( new t_order_tracking(
            pos       => 110,
            infolevel => 1,
            anzahl    => einstieg_neukunde,
            vorgang   => 'BESTELLUNG',
            d1        => 'Einstieg als Neukunde',
            d2        => bold(einstieg_neukunde)
        ) );

        pipe row ( new t_order_tracking(
            pos       => 111,
            infolevel => 2,
            anzahl    => dubletten_nicht_gefunden,
            vorgang   => 'BESTELLUNG',
            d2        => 'keine Dublette gefunden',
            d3        => bold(dubletten_nicht_gefunden)
        ) );

        pipe row ( new t_order_tracking(
            pos       => 112,
            infolevel => 2,
            anzahl    => dublette_gefunden_inp,
            vorgang   => 'BESTELLUNG',
            d2        => 'mit erfassten Daten bestellt, obwohl Dublette gefunden',
            d3        => bold(dublette_gefunden_inp)
        ) );

        pipe row ( new t_order_tracking(
            pos       => 112,
            infolevel => 2,
            anzahl    => dublette_gefunden_pob,
            vorgang   => 'BESTELLUNG',
            d2        => 'mit bestehenden POB-Daten bestellt',
            d3        => bold(dublette_gefunden_pob)
        ) );

        pipe row ( new t_order_tracking(
            pos       => 112,
            infolevel => 2,
            anzahl    => dublette_gefunden_sie,
            vorgang   => 'BESTELLUNG',
            d2        => 'mit bestehenden Siebel-Daten bestellt',
            d3        => bold(dublette_gefunden_sie)
        ) );

        pipe row ( new t_order_tracking(
            pos       => 120,
            infolevel => 1,
            anzahl    => einstieg_bestandskunde,
            vorgang   => 'BESTELLUNG',
            d1        => 'Einstieg als Bestandskunde',
            d2        => bold(einstieg_bestandskunde)
        ) );

        pipe row ( new t_order_tracking(
            pos       => 1010,
            infolevel => 3,
            anzahl    => bestellungen,
            vorgang   => 'BESTELLUNG',
            d3        => '"Kostenpflichtig bestellen" angeklickt',
            d4        => bold(bestellungen)
        ) );

        return;
    end fp_order_tracking;


/**
 * Wertet das User-Verhalten in der Bestellerfassung anonym aus und gibt die Zahlen pipelined zurück,
 * die dann vom Classic Report auf Seite 10056 im Glascontainer angezeigt werden.
 *
 * Die Spalten im Ergebnis sind:
 * POS                    Anzeige-Reihenfolge
 * INFOLEVEL              [0..3] Einrückungsebene
 * VORGANG                String (AUFRUF|BESTELLUNG) zur Kontrolle des Ergebnisse, wird nicht angezeigt
 * ANZAHL                 Gezählte Ereignisse. Entspricht derselben Zahl in der ganz rechten Spalte, diese ist dort
 *                        nur aus Gründen der Report-Darstellung erneut vorhanden - so muss man bei Abfragen nicht wissen, 
 *                        in welcher Spalte D1...D4 sie steht
 * D0, D1, D2, D3, D4     Der gemäß @ticket FTTH-4003 anzuzeigende Text 
 *
 * @param pid_von  [IN ]  Tagesdatum entsprechend dem Eingabefeld "von"
 * @param pid_bis  [IN ]  Tagesdatum entsprechend dem Eingabefeld "vbis"
 *
 * @example Order-Statistik vom gestrigen Tag:
 * SELECT * FROM TABLE(PCK_GLASCONTAINER_ORDER.FP_ORDER_TRACKING(SYSDATE-1)) ORDER BY POS NULLS LAST;
 */
    function fp_order_tracking2 (
        pid_von in date default null,
        pid_bis in date default null,
        piv_vkz in varchar2 default null
    ) return t_order_trackings
        pipelined
    is

        datum_von               constant date := trunc(coalesce(pid_von, date '2024-09-20')); -- erster Tag der Datenerfassung
        datum_bis               constant date := trunc(coalesce(pid_bis, pid_von, sysdate));
    --------------------------
        aufrufe                 naturaln := 0;
        aufrufe_siebel          naturaln := 0;
    --------------------------
        einstieg_neukunde       naturaln := 0;
        keine_dublette_gefunden naturaln := 0;
        dublette_gefunden_inp   naturaln := 0;
        dublette_gefunden_sie   naturaln := 0;
        dublette_gefunden_pob   naturaln := 0;
        einstieg_bestandskunde  naturaln := 0; -- entspricht BESTELLUNGEN_B
    --------------------------
        bestellungen            naturaln := 0;
    --BESTELLUNGEN_N              NATURALN := 0; -- diese Zahl wird in der Auswertung momentan nicht gerendet. Ersetzt durch "EINSTIEG_NEUKUNDE"
    --BESTELLUNGEN_B              NATURALN := 0; -- diese Zahl wird in der Auswertung momentan nicht gerendet. Ersetzt durch "EINSTIEG_BESTANDSKUNDE"

        pos_unbekannt           natural := null;

        function bold (
            i_text in varchar2
        ) return varchar2 is
        begin
            return '<b>'
                   || i_text
                   || '</b>';
        end;

    begin
        for d in (
            select
                task
        --- Diese Spalten der Tracking-View werden nicht verwendet, stehen aber zur Verfügung:
        ---   , COUNT(*)                AS page_views
        ---   , MIN(REQUEST)            AS MIN_REQUEST
        ---   , MAX(REQUEST)            AS MAX_REQUEST
        ---   , MIN(ID)                 AS MIN_ID
        ---   , MAX(ID)                 AS MAX_ID
        ---   , ROUND((MAX(DATUM) - MIN(DATUM)) * 24 * 60 * 60) AS DAUER_SEKUNDEN
                ,
                max(task_request)       as task_request
        ---   , MAX(TASK_VKZ)           AS TASK_VKZ
                ,
                max(first_kundenstatus) as kundenstatus_beginn,
                max(last_kundenstatus)  as kundenstatus_ende,
                max(scope)              as max_scope,
                max(last_dubletten_sie) as dubletten_sie -- war: MAX(DUBLETTEN_SIE)
                ,
                max(last_dubletten_pob) as dubletten_pob -- war: MAX(DUBLETTEN_POB)
                ,
                max(kundendaten)        as kundendaten
        ---   , MAX(LAST_KUNDENDATEN)   AS LAST_KUNDENDATEN
            from
                v_pob_tracking
            where
                trunc(datum) between datum_von and datum_bis
                and ( piv_vkz is null
                      or task_vkz = piv_vkz )
                and task is not null
            group by
                task
  -- HAVING MAX(SCOPE) > 0 -- steuert, ob Nur solche Tasks gezählt werden, bei denen eine bestimmte Wizard-Seite erreicht wurde 
                             -- (also nicht lediglich die Seite "Vorbestellung" aufgerufen und danach Abbruch)
                             -- Am 2024-10-10 wünschte Florian aber nicht, dass wir hier bereits aussieben, daher auskommentiert
        ) loop
            aufrufe := 1 + aufrufe;
            if d.task_request = 'SIEBEL' then
                aufrufe_siebel := 1 + aufrufe_siebel;
            end if;
            case d.kundenstatus_beginn
                when 'N' then
                    einstieg_neukunde := 1 + einstieg_neukunde;
        /*
        CASE d.KUNDENDATEN
                              WHEN 'INP' THEN DUBLETTE_GEFUNDEN_INP := DUBLETTE_GEFUNDEN_INP + 1;
                              WHEN 'SIE' THEN DUBLETTE_GEFUNDEN_SIE := DUBLETTE_GEFUNDEN_SIE + 1;
                              WHEN 'POB' THEN DUBLETTE_GEFUNDEN_POB := DUBLETTE_GEFUNDEN_POB + 1;
                              ELSE -- '-'
                                    KEINE_DUBLETTE_GEFUNDEN := KEINE_DUBLETTE_GEFUNDEN + 1;
        END CASE;  
        */
                    case d.kundendaten
                        when 'INP' then
                            case
                                when
                                    d.dubletten_sie = 0
                                    and d.dubletten_pob = 0
                                then
                                    keine_dublette_gefunden := keine_dublette_gefunden + 1;
                                else
                                    dublette_gefunden_inp := dublette_gefunden_inp + 1;
                            end case;
                        when 'SIE' then
                            dublette_gefunden_sie := dublette_gefunden_sie + 1;
                        when 'POB' then
                            dublette_gefunden_pob := dublette_gefunden_pob + 1;
                        else -- sonstige Konstellationen: 
                            keine_dublette_gefunden := keine_dublette_gefunden + 1;
                    end case;

                when 'B' then
                    einstieg_bestandskunde := 1 + einstieg_bestandskunde;
                else
                    null;
            end case;

            if d.max_scope >= 99 then
      -- ab 99: "Kostenpflichtig bestellen" angeklickt, 100 = Bestellung erfolgreich!
      -- Dieser wichtige Unterschied wird momentan nicht ausgewertet
                bestellungen := 1 + bestellungen;
            end if;
      -- BESTELLUNGEN

        end loop;

    -- Für jeden im Loop kumulierten Wert die entsprechende Report-Zeile ausgeben:
        pipe row ( new t_order_tracking(
            pos       => 10,
            infolevel => 0,
            anzahl    => aufrufe,
            vorgang   => 'AUFRUF',
            d0        => 'Bestellstrecke aufgerufen',
            d1        => bold(aufrufe)
        ) );

        if aufrufe_siebel > 0 then
            pipe row ( new t_order_tracking(
                pos       => 11,
                infolevel => 0,
                anzahl    => aufrufe_siebel,
                vorgang   => 'AUFRUF',
                d0        => '(davon aus SIEBEL)',
                d1        => bold(aufrufe_siebel)
            ) );
        end if;

        pipe row ( new t_order_tracking(
            pos       => 110,
            infolevel => 1,
            anzahl    => einstieg_neukunde,
            vorgang   => 'BESTELLUNG',
            d1        => 'Einstieg als Neukunde',
            d2        => bold(einstieg_neukunde)
        ) );

        pipe row ( new t_order_tracking(
            pos       => 111,
            infolevel => 2,
            anzahl    => keine_dublette_gefunden,
            vorgang   => 'BESTELLUNG',
            d2        => 'keine Dublette gefunden',
            d3        => bold(keine_dublette_gefunden)
        ) );

        pipe row ( new t_order_tracking(
            pos       => 112,
            infolevel => 2,
            anzahl    => dublette_gefunden_inp,
            vorgang   => 'BESTELLUNG',
            d2        => 'Dublette nicht übernommen (erfasste Daten verwendet)',
            d3        => bold(dublette_gefunden_inp)
        ) );

        pipe row ( new t_order_tracking(
            pos       => 112,
            infolevel => 2,
            anzahl    => dublette_gefunden_pob,
            vorgang   => 'BESTELLUNG',
            d2        => 'POB-Dublette übernommen',
            d3        => bold(dublette_gefunden_pob)
        ) );

        pipe row ( new t_order_tracking(
            pos       => 112,
            infolevel => 2,
            anzahl    => dublette_gefunden_sie,
            vorgang   => 'BESTELLUNG',
            d2        => 'Siebel-Dublette übernommen',
            d3        => bold(dublette_gefunden_sie)
        ) );

        pipe row ( new t_order_tracking(
            pos       => 120,
            infolevel => 1,
            anzahl    => einstieg_bestandskunde,
            vorgang   => 'BESTELLUNG',
            d1        => 'Einstieg als Bestandskunde',
            d2        => bold(einstieg_bestandskunde)
        ) );

        pipe row ( new t_order_tracking(
            pos       => 1010,
            infolevel => 3,
            anzahl    => bestellungen,
            vorgang   => 'BESTELLUNG',
            d3        => '"Kostenpflichtig bestellen" angeklickt',
            d4        => bold(bestellungen)
        ) );

        return;
    end fp_order_tracking2;

-- @progress 2024-09-25    

  /**
   * Gibt eine neue Connectivity-ID zurück, die der bisherigen Connectivity-ID einen numerischen Suffix anfügt
   * bzw. bei bereits vorhandenem Suffix diesen um 1 erhöht.
   *
   * @param piv_id  [IN ]  Bestehende externe auftragsnummer ("Connectivity-ID"), z.B. CS-S-0000000770
   *
   * @ticket FTTH-3815
   * @example SELECT PCK_GLASCONTAINER_ORDER.neue_externe_auftragsnummer('CS-S-0000000770') FROM DUAL
   */
    function neue_externe_auftragsnummer (
        piv_id in varchar2
    ) return varchar2 is
        v_id_neu          varchar2(100);
        v_suffix          natural;
        v_pos_bindestrich natural;
    begin
    -- Shortcut: leeres Argument liefert leeres Ergebnis
        if piv_id is null then
            return null;
        end if;

    -- prüfen, ob eine zu lange ID eintrifft:
        if length(piv_id) > 97 then -- damit VARCHAR2(100) anschließend mit Suffix nicht überläuft
            raise_application_error(c_plausi_error_number, 'Ungültige Externe Auftragsnummer');
        end if;
    -- Es ist nicht die Aufgabe dieser Funktion zu prüfen, ob die eingehende ID valide ist.

    -- Erstellungsregel:
    -- [alte Nummer]-09
    -- Suffix aus Bindestrich und 2 Ziffern anfügen, beginnend mit 01, 
    -- wenn die alte Nummer noch kein Suffix hat, ansonsten um 1 erhöhen.

    -- Hat die ID bereits ein nummerisches Suffix? 
    -- muss exakt 2-stellig sein, wenn man es wortwörtlich auslegt
        if regexp_like(piv_id, '^.*-[0-9]{2}$') then
            v_pos_bindestrich := instr(piv_id, '-', -1);
            v_suffix := coalesce(cast(substr(piv_id, v_pos_bindestrich + 1) as number
                default null on conversion error
            ),
                                 0);

        else
            v_pos_bindestrich := length(piv_id) + 1; -- um das neue Suffix dahinter anzuhängen
            v_suffix := 0; -- es gibt noch kein Suffix
        end if;

    -- Neues Suffix erstellen, das bisherige (respektive 0) wird im 1 erhöht,
    -- aber maximal auf 99:
        v_suffix := 1 + v_suffix;
        if v_suffix > 99 then
            raise_application_error(c_plausi_error_number, 'Neue Externe Auftragsnummer kann nicht erstellt werden: Suffix-Nummernkreis ist aufgebraucht'
            );
        end if;

    -- neues Suffix anhängen:
        v_id_neu := substr(piv_id, 1, v_pos_bindestrich - 1)
                    || '-'
                    || lpad(v_suffix, 2, '0');

        return v_id_neu;
    end;  

--@progress 2024-10-01

/**
 * Ruft den Webservice auf, der eine neue Connectivity-ID für einen Auftrag generiert, und gibt diese zurück
 *
 * @param piv_uuid             [IN ]  ID des Auftrags im Preorderbuffer
 * @param piv_connectivity_id  [IN ]  Bestehende Externe Auftragsnummer
 * @param piv_app_user         [IN ]  Kürzel des Glascontainer-Users
 *
 * @ticket FTTH-3815
 */
    function fv_neue_externe_auftragsnummer (
        piv_uuid            in varchar2,
        piv_connectivity_id in varchar2,
        piv_app_user        in varchar2
    ) return varchar2 is

        vj_json                       json_object_t := new json_object_t(c_empty_json);
        v_ws_response                 clob;
        v_neue_externe_auftragsnummer ftth_ws_sync_preorders.connectivity_id%type;
        fehlermeldung_prefix          constant varchar2(100) := 'Es konnte keine neue Auftragsnummer generiert werden. Die Fehlermeldung lautet: '
        ;
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name               constant logs.routine_name%type := 'fv_neue_externe_auftragsnummer';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_uuid', piv_uuid);
            pck_format.p_add('piv_connectivity_id', piv_connectivity_id);
            pck_format.p_add('piv_app_user', piv_app_user);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
  -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------     
    begin

    -- Der Body ist sehr einfach gestrickt, so dass wir hierfür keine eigene Function verwenden
        vj_json.put('connectivityId', piv_connectivity_id);
        vj_json.put('changedBy', piv_app_user);
        v_ws_response := pck_pob_rest.fv_connectivity_id_increment(
            piv_kontext  => pck_pob_rest.kontext_preorderbuffer,
            piv_app_user => piv_app_user,
            piv_uuid     => piv_uuid,
            pic_body     => vj_json.to_clob()
        );

    -- Wenn alles OK war, dann den zurückerhaltenen Body parsen, um an die neue ID zu kommen:
        v_neue_externe_auftragsnummer := json_value(v_ws_response, '$.connectivityId' returning varchar2 error on error);
        return v_neue_externe_auftragsnummer;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name
            );
            raise;
    end fv_neue_externe_auftragsnummer;

-- @progress 2025-01-21

/**
 * Nimmt von APEX den fertigen JSON-Body für eine "Vorbestellung erfassen" entgegen
 * und schickt den Auftrag an den Preorderbuffer.
 *
 * @krakar
 * @ticket FTTH-4464
 */
    function fn_vorbestellung_erfassen (
        piv_app_user                           in varchar2 -- OK
        ,
        piv_vkz                                in varchar2 -- OK
        ,
        piv_kundenstatus                       in varchar2 -- N = Neukunde, B = Bestandskunde
        ,
        piv_abw                                in varchar2,
        piv_abw_anrede                         in varchar2,
        piv_abw_anschlussinhaber               in varchar2,
        piv_abw_nachname                       in varchar2,
        piv_abw_rufnummer                      in varchar2,
        piv_abw_vorname                        in varchar2,
        piv_abw_vorwahl                        in varchar2,
        piv_aktion                             in varchar2,
        piv_bisheriger_anbieter                in varchar2,
        piv_gee_eigentuemer_einverstanden      in varchar2,
        piv_gee_firma                          in varchar2,
        piv_gee_kontaktdaten_bekannt           in varchar2,
        piv_gee_titel                          in varchar2,
        piv_haus_lfd_nr                        in varchar2,
        piv_kosten_hausanschluss               in varchar2,
        piv_kunde_anrede                       in varchar2,
        piv_kunde_email                        in varchar2,
        piv_kunde_firmenname                   in varchar2,
        pid_kunde_geburtsdatum                 in date,
        piv_kunde_iban                         in varchar2,
        piv_kunde_kontoinhaber                 in varchar2,
        piv_kunde_nachname                     in varchar2,
        piv_kundennummer                       in varchar2,
        piv_kunde_rufnummer                    in varchar2,
        piv_kunde_sepamandat                   in varchar2,
        piv_kunde_soho                         in varchar2,
        piv_kunde_titel                        in varchar2,
        piv_kunde_vorname                      in varchar2,
        piv_kunde_vorwahl                      in varchar2,
        piv_mandant                            in varchar2,
        piv_mandant_display                    in varchar2
    -- neu in die Parameter aufgenommen:
        ,
        piv_wohndauer                          in varchar2,
        piv_voradresse_plz                     in varchar2,
        piv_voradresse_ort                     in varchar2,
        piv_voradresse_strasse                 in varchar2,
        piv_voradresse_hausnr                  in varchar2,
        piv_installationsadresse_plz           in varchar2,
        piv_installationsadresse_ort           in varchar2,
        piv_installationsadresse_strasse       in varchar2,
        piv_installationsadresse_hausnr        in varchar2,
        piv_installationsadresse_hausnr_zusatz in varchar2 -- @ticket FTTH-4158, neuer Parameter
    -- Anbieterwechsel:
        ,
        piv_abw_bisheriger_anbieter            in varchar2 -- OK
        ,
        piv_abw_rufnummernmitnahme             in varchar2 -- OK
        ,
        piv_abw_rufnummernmitnahme_vorwahl     in varchar2,
        piv_abw_rufnummernmitnahme_rufnummer   in varchar2
    ---
        ,
        piv_gee_rolle                          in varchar2 -- OK
        ,
        piv_gee_anzahl_we                      in varchar2,
        piv_gee_rechtsform                     in varchar2,
        piv_gee_plz                            in varchar2,
        piv_gee_ort                            in varchar2,
        piv_gee_strasse                        in varchar2,
        piv_gee_hausnr                         in varchar2,
        piv_gee_hausnr_zusatz                  in varchar2,
        piv_gee_land                           in varchar2,
        piv_gee_email                          in varchar2,
        piv_gee_vorwahl                        in varchar2,
        piv_gee_rufnummer                      in varchar2,
        piv_gee_anrede                         in varchar2,
        piv_gee_vorname                        in varchar2,
        piv_gee_nachname                       in varchar2,
        pib_gee_informationspflicht            in boolean  
    -- productRequest:
        ,
        piv_produkt                            in varchar2,
        piv_router_auswahl                     in varchar2,
        piv_router_eigentum                    in varchar2,
        piv_einrichtungsservice                in varchar2,
        piv_ont_provider                       in varchar2 --@ticket @ticket FTTH-5008 nach Versionierung bereit zur Entfernung
    --
        ,
        pib_check_agb                          in boolean,
        pib_check_widerruf                     in boolean
    --
        ,
        piv_ausbaustatus                       in varchar2,
        pid_ausbau_plan_termin                 in date
    --
        ,
        pib_is_duplicate                       in boolean default null,
        piv_update_cus_in_siebel               in varchar2 default 'FALSE' --@ticket: FTTH-5228
    ) return ftth_ws_sync_preorders.id%type is

        vj_internal_order   clob;
        v_webservice_log_id ftth_webservice_aufrufe.id%type; -- für den Fall, dass der Auftrag nicht erfolgreich vom Webserver
                                                         -- verarbeitet wird, können mit dieser ID die gesendeten Daten
                                                         -- ausgelesen werden
        v_uuid              ftth_ws_sync_preorders.id%type;
-- Hilfsroutine zur Fehlerbehandlung------------------------------------------
  -- Parameterliste aktualisiert am 2024-12-31 0930
        cv_routine_name     constant logs.routine_name%type := 'fn_vorbestellung_erfassen';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_app_user', piv_app_user);
            pck_format.p_add('piv_vkz', piv_vkz);
            pck_format.p_add('piv_kundenstatus', piv_kundenstatus);
            pck_format.p_add('piv_abw', piv_abw);
            pck_format.p_add('piv_abw_anrede', piv_abw_anrede);
            pck_format.p_add('piv_abw_anschlussinhaber', piv_abw_anschlussinhaber);
            pck_format.p_add('piv_abw_nachname', piv_abw_nachname);
            pck_format.p_add('piv_abw_rufnummer', piv_abw_rufnummer);
            pck_format.p_add('piv_abw_vorname', piv_abw_vorname);
            pck_format.p_add('piv_abw_vorwahl', piv_abw_vorwahl);
            pck_format.p_add('piv_aktion', piv_aktion);
            pck_format.p_add('piv_bisheriger_anbieter', piv_bisheriger_anbieter);
            pck_format.p_add('piv_gee_eigentuemer_einverstanden', piv_gee_eigentuemer_einverstanden);
            pck_format.p_add('piv_gee_firma', piv_gee_firma);
            pck_format.p_add('piv_gee_kontaktdaten_bekannt', piv_gee_kontaktdaten_bekannt);
            pck_format.p_add('piv_gee_titel', piv_gee_titel);
            pck_format.p_add('piv_haus_lfd_nr', piv_haus_lfd_nr);
            pck_format.p_add('piv_kosten_hausanschluss', piv_kosten_hausanschluss);
            pck_format.p_add('piv_kunde_anrede', piv_kunde_anrede);
            pck_format.p_add('piv_kunde_email', piv_kunde_email);
            pck_format.p_add('piv_kunde_firmenname', piv_kunde_firmenname);
            pck_format.p_add('pid_kunde_geburtsdatum', pid_kunde_geburtsdatum);
            pck_format.p_add('piv_kunde_iban', piv_kunde_iban);
            pck_format.p_add('piv_kunde_kontoinhaber', piv_kunde_kontoinhaber);
            pck_format.p_add('piv_kunde_nachname', piv_kunde_nachname);
            pck_format.p_add('piv_kundennummer', piv_kundennummer);
            pck_format.p_add('piv_kunde_rufnummer', piv_kunde_rufnummer);
            pck_format.p_add('piv_kunde_sepamandat', piv_kunde_sepamandat);
            pck_format.p_add('piv_kunde_soho', piv_kunde_soho);
            pck_format.p_add('piv_kunde_titel', piv_kunde_titel);
            pck_format.p_add('piv_kunde_vorname', piv_kunde_vorname);
            pck_format.p_add('piv_kunde_vorwahl', piv_kunde_vorwahl);
            pck_format.p_add('piv_mandant', piv_mandant);
            pck_format.p_add('piv_mandant_display', piv_mandant_display);
            pck_format.p_add('piv_wohndauer', piv_wohndauer);
            pck_format.p_add('piv_voradresse_plz', piv_voradresse_plz);
            pck_format.p_add('piv_voradresse_ort', piv_voradresse_ort);
            pck_format.p_add('piv_voradresse_strasse', piv_voradresse_strasse);
            pck_format.p_add('piv_voradresse_hausnr', piv_voradresse_hausnr);
            pck_format.p_add('piv_installationsadresse_plz', piv_installationsadresse_plz);
            pck_format.p_add('piv_installationsadresse_ort', piv_installationsadresse_ort);
            pck_format.p_add('piv_installationsadresse_strasse', piv_installationsadresse_strasse);
            pck_format.p_add('piv_installationsadresse_hausnr', piv_installationsadresse_hausnr);
            pck_format.p_add('piv_installationsadresse_hausnr_zusatz', piv_installationsadresse_hausnr_zusatz);
            pck_format.p_add('piv_abw_bisheriger_anbieter', piv_abw_bisheriger_anbieter);
            pck_format.p_add('piv_abw_rufnummernmitnahme', piv_abw_rufnummernmitnahme);
            pck_format.p_add('piv_abw_rufnummernmitnahme_vorwahl', piv_abw_rufnummernmitnahme_vorwahl);
            pck_format.p_add('piv_abw_rufnummernmitnahme_rufnummer', piv_abw_rufnummernmitnahme_rufnummer);
            pck_format.p_add('piv_gee_rolle', piv_gee_rolle);
            pck_format.p_add('piv_gee_anzahl_we', piv_gee_anzahl_we);
            pck_format.p_add('piv_gee_rechtsform', piv_gee_rechtsform);
            pck_format.p_add('piv_gee_plz', piv_gee_plz);
            pck_format.p_add('piv_gee_ort', piv_gee_ort);
            pck_format.p_add('piv_gee_strasse', piv_gee_strasse);
            pck_format.p_add('piv_gee_hausnr', piv_gee_hausnr);
            pck_format.p_add('piv_gee_hausnr_zusatz', piv_gee_hausnr_zusatz);
            pck_format.p_add('piv_gee_land', piv_gee_land);
            pck_format.p_add('piv_gee_email', piv_gee_email);
            pck_format.p_add('piv_gee_vorwahl', piv_gee_vorwahl);
            pck_format.p_add('piv_gee_rufnummer', piv_gee_rufnummer);
            pck_format.p_add('piv_gee_anrede', piv_gee_anrede);
            pck_format.p_add('piv_gee_vorname', piv_gee_vorname);
            pck_format.p_add('piv_gee_nachname', piv_gee_nachname);
            pck_format.p_add('pib_gee_informationspflicht', pib_gee_informationspflicht);
            pck_format.p_add('piv_produkt', piv_produkt);
            pck_format.p_add('piv_router_auswahl', piv_router_auswahl);
            pck_format.p_add('piv_router_eigentum', piv_router_eigentum);
            pck_format.p_add('piv_einrichtungsservice', piv_einrichtungsservice);
            pck_format.p_add('piv_ont_provider', piv_ont_provider); --@ticket @ticket FTTH-5008 nach Versionierung bereit zur Entfernung
            pck_format.p_add('pib_check_agb', pib_check_agb);
            pck_format.p_add('pib_check_widerruf', pib_check_widerruf);
            pck_format.p_add('piv_ausbaustatus', piv_ausbaustatus);
            pck_format.p_add('pid_ausbau_plan_termin', pid_ausbau_plan_termin);
            pck_format.p_add('pib_is_duplicate', pib_is_duplicate);
            pck_format.p_add('piv_update_cus_in_siebel', piv_update_cus_in_siebel); --@ticket: FTTH-5228
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
-- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 

    -- inline:
        procedure validieren (
            pib_bedingung    in boolean,
            piv_errormessage in varchar2
        ) is
        begin
            if not coalesce(pib_bedingung, false) then
                raise_application_error(c_plausi_error_number, piv_errormessage);
            end if;
        end;

    begin


    -- nochmalige Prüfungen der wichtigsten Daten:
        validieren(piv_app_user is not null, 'Username fehlt');
        validieren(piv_vkz is not null, 'VKZ fehlt');
            -- piv_kunde_anrede (darf leer sein)
        validieren(piv_kunde_vorname is not null, 'Kunde: Vorname fehlt');
        validieren(piv_kunde_nachname is not null, 'Kunde: Nachname fehlt');
        validieren(pid_kunde_geburtsdatum is not null, 'Kunde: Geburtsdatum fehlt');
        validieren(piv_kunde_email is not null, 'Kunde: Email fehlt');
        validieren(piv_mandant is not null, 'Mandant fehlt');
        validieren(piv_installationsadresse_plz is not null, 'Installationsadresse: PLZ fehlt');
        validieren(piv_installationsadresse_ort is not null, 'Installationsadresse: Ort fehlt');
        validieren(piv_installationsadresse_strasse is not null, 'Installationsadresse: Straße fehlt');
        validieren(piv_installationsadresse_hausnr is not null, 'Installationsadresse: Hausnr. fehlt');
        validieren(piv_haus_lfd_nr is not null, 'Installationsadresse: HAUS_LFD_NR fehlt');    

    -- @ticket FTTH-4084:
    -- validieren(piv_vc_status IS NOT NULL, 'Ausbaustatus liegt nicht vor'); -- //// zunächst prüfen, ob das Feld wirklich IMMER gefüllt sein muss

    -- nur bei Neukunden:
    -- @ticket FTTH-4282: Prüfung nicht mehr aussetzen, denn zuvor wird nun eine leere Wohndauer auf NO_RESIDENT gemappt
        if piv_kundenstatus = neukunde then
            validieren(piv_wohndauer is not null, 'Kunde: Wohndauer fehlt');
        end if;
        validieren(piv_kunde_vorwahl is not null, 'Kunde: Ländervorwahl fehlt');
        validieren(piv_kunde_rufnummer is not null, 'Kunde: Rufnummer fehlt');
            -- piv_kunde_titel (darf leer sein)

    -- Zuordnung zum Datensatz:
        vj_internal_order := fj_internal_order(
            piv_app_user                                                  => piv_app_user,
            piv_vkz                                                       => piv_vkz,
            piv_kundenstatus                                              => piv_kundenstatus,
            piv_gee_kontaktdaten_bekannt                                  => piv_gee_kontaktdaten_bekannt,
            piv_propertyownerdeclaration_propertyownerrole                => piv_gee_rolle,
            piv_abw_anschlussinhaber                                      => piv_abw_anschlussinhaber
       --
            ,
            piv_customernumber                                            => piv_kundennummer,
            piv_customer_businessname                                     => piv_kunde_firmenname,
            piv_customer_salutation                                       => piv_kunde_anrede,
            piv_customer_name_first                                       => piv_kunde_vorname,
            piv_customer_name_last                                        => piv_kunde_nachname,
            pid_customer_birthdate                                        => pid_kunde_geburtsdatum,
            piv_customer_email                                            => piv_kunde_email,
            piv_customer_residentstatus                                   => piv_wohndauer,
            piv_customer_phonenumber_countrycode                          => piv_kunde_vorwahl,
            piv_customer_phonenumber_number                               => piv_kunde_rufnummer,
            piv_customer_title                                            => piv_kunde_titel,
            piv_customer_previousaddress_zipcode                          => piv_voradresse_plz,
            piv_customer_previousaddress_city                             => piv_voradresse_ort,
            piv_customer_previousaddress_street                           => piv_voradresse_strasse,
            piv_customer_previousaddress_housenumber                      => piv_voradresse_hausnr -- keine postaladdition im Ggs. zu landlord etc.?
            ,
            piv_client                                                    => piv_mandant,
            piv_installation_address_zipcode                              => piv_installationsadresse_plz,
            piv_installation_address_city                                 => piv_installationsadresse_ort,
            piv_installation_address_street                               => piv_installationsadresse_strasse,
            piv_installation_address_housenumber                          => piv_installationsadresse_hausnr,
            piv_installation_address_postal_addition                      => piv_installationsadresse_hausnr_zusatz,
            piv_houseserialnumber                                         => piv_haus_lfd_nr
       -- Anbieterwechsel:
            ,
            piv_providerchange_currentprovider                            => piv_abw_bisheriger_anbieter,
            pib_providerchange_keepcurrentlandlinenumber                  => to_boolean(piv_abw_rufnummernmitnahme),
            piv_providerchange_landlinephonenumber_countrycode            => '49' -- //// +49? piv_abw_rufnummernmitnahme_laendervorwahl wird ja nicht erfasst
            ,
            piv_providerchange_landlinephonenumber_areacode               => piv_abw_rufnummernmitnahme_vorwahl,
            piv_providerchange_landlinephonenumber_number                 => piv_abw_rufnummernmitnahme_rufnummer,
            piv_providerchange_contractownersalutation                    => piv_abw_anrede,
            piv_providerchange_contractownername_first                    => piv_abw_vorname,
            piv_providerchange_contractownername_last                     => piv_abw_nachname,
            piv_accountdetails_accountholder                              => piv_kunde_kontoinhaber,
            piv_accountdetails_iban                                       => piv_kunde_iban
       ---
            ,
            piv_propertyownerdeclaration_residentialunit                  => piv_gee_anzahl_we,
            piv_propertyownerdeclaration_landlord_legalform               => piv_gee_rechtsform,
            piv_propertyownerdeclaration_landlord_businessorname          => piv_gee_firma,
            piv_propertyownerdeclaration_landlord_address_zipcode         => piv_gee_plz,
            piv_propertyownerdeclaration_landlord_address_city            => piv_gee_ort,
            piv_propertyownerdeclaration_landlord_address_street          => piv_gee_strasse,
            piv_propertyownerdeclaration_landlord_address_housenumber     => piv_gee_hausnr,
            piv_propertyownerdeclaration_landlord_address_postaladdition  => piv_gee_hausnr_zusatz,
            piv_propertyownerdeclaration_landlord_address_country         => piv_gee_land,
            piv_propertyownerdeclaration_landlord_email                   => piv_gee_email,
            piv_propertyownerdeclaration_landlord_phonenumber_countrycode => piv_gee_vorwahl -- //// Achtung: Ländervorwahl *+*49, nicht Ortsnetz!
            ,
            piv_propertyownerdeclaration_landlord_phonenumber_number      => piv_gee_rufnummer,
            piv_propertyownerdeclaration_landlord_salutation              => piv_gee_anrede,
            piv_propertyownerdeclaration_landlord_title                   => piv_gee_titel,
            piv_propertyownerdeclaration_landlord_name_first              => piv_gee_vorname,
            piv_propertyownerdeclaration_landlord_name_last               => piv_gee_nachname,
            pib_propertyownerdeclaration_landlordagreedtobecontacted      => pib_gee_informationspflicht 
       ---
            ,
            piv_productrequest_templateid                                 => piv_produkt,
            piv_productrequest_devicecategory                             => piv_router_auswahl,
            piv_productrequest_deviceownership                            => piv_router_eigentum,
            piv_productrequest_installationservice                        => piv_einrichtungsservice,
            piv_productrequest_ontprovider                                => piv_ont_provider --@ticket @ticket FTTH-5008 nach Versionierung bereit zur Entfernung
       ---
            ,
            pib_summary_generaltermsandconditions                         => pib_check_agb,
            pib_summary_waiverightofrevocation                            => pib_check_widerruf
       ---
            ,
            piv_expansionstatus                                           => fv_vc_status_webservice(piv_ausbaustatus),
            pid_availabilitydate                                          => pid_ausbau_plan_termin,
            piv_createdby                                                 => piv_app_user,
            pib_isduplicate                                               => pib_is_duplicate,
            piv_update_cus_in_siebel                                      => piv_update_cus_in_siebel --@ticket: FTTH-5228
        );

    -- Auftrag zum Webservice senden und sofort die neue orderId zurückerhalten:
        v_uuid := pck_pob_rest.fn_internal_order_post(
            piv_kontext  => pck_pob_rest.kontext_preorderbuffer,
            piv_app_user => piv_app_user,
            pic_body     => vj_internal_order
        );

        return v_uuid;
    exception
        when e_plausi_error then
            raise;
        when others then
        -- nur unerwartete Fehler loggen:
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise; -- (hier sollte bereits eine benutzer-geeignete Fehlermeldung aus dem PCK_POB_REST vorliegen)
    end fn_vorbestellung_erfassen;

-- @progress 2025-02-05



/**
 * Extrahiert aus der JSON-Antwort, die vom Availability Check stammt, alle im Rahmen einer Landline Promotion als 
 * verfügbar zurückgemeldeten Technologien und deren Verfügbarkeitsdatum in einer HTML-Tabelle
 *
 * @param piv_json  [IN] Vollständiges JSON-Dokument vom Availability Check (light)
 * @ticket FTTH-4456
 *
 * @example -- Ersetze {...} mit dem tatsächlichen JSON:
 * SELECT PCK_GLASCONTAINER_ORDER.fv_landline_promotions('{...}')
 *   FROM DUAL;
 */
    function fv_landline_promotions_html (
        piv_json    in varchar2,
        piv_html_id in varchar2 default null
    ) return varchar2 is

        v_technologien           varchar(4000);
        v_verfuegbarkeiten       varchar2(4000);
        v_count_technologien     naturaln := 0;
        v_count_verfuegbarkeiten natural;
        v_tabelle                varchar2(4000);
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name          constant logs.routine_name%type := 'fv_landline_promotions_html';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_json', piv_json);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------     
    begin
  -- Beispiel-JSON: Es geht um das Array "landlinePromotions".
  /* 
{
    "fallback": "NONE",
    "address": {
        "zipCode": "41539",
        "city": "Dormagen",
        "district": "Dormagen-Nord",
        "street": "Holbeinweg",
        "source": "STRAV",
        "houseNumber": "4",
        "areaCode": "2133",
        "mandant": "NC",
        "hausLfdnr": 2280201
    },
    "objectInformation": {
        "status": "HOMES_PREPARED",
        "ausbauStatus": "HOMES_PREPARED",
        "ausbauStatusNetzbau": "HOMES_PREPARED",
        "ausbauAccessTyp": "FTTH",
        "landingpagePk": "",
        "landingpageGk": "",
        "availabilityDate": "April 2025",
        "availabilityDateRaw": "2025-04-01",
        "availabilityDateHalfYear": "1. Halbjahr 2025",
        "plannedBandwidth": "1000 Mbit/s",
        "maxBandwidth": "1000 Mbit/s",
        "minBandwidth": 0,
        "customerOrderRequired": false,
        "houseConnectionPrice": 0.0,
        "technicalPromotionBandwidth": 1000,
        "geeStatus": "ERTEILT",
        "geeValidFrom": "24.09.2024",
        "inkassoType": "LEER",
        "inkassoTypeValidFrom": null,
        "ftthAusbauArt": "UNKNOWN",
        "woWi": false,
        "wholebuy": {
            "eigentuemerdatenErforderlich": false,
            "partner": null,
            "partnerLabel": null,
            "accessType": null
        },
        "mergedAccessType": "FTTH",
        "anzahlWeGes": 1
    },
    "landlinePromotions": [
        {
            "technology": "FTTH",
            "isNetCologneNetwork": true,
            "promotionId": "2-2WREECC",
            "maxDownload": 1000,
            "minDownload": 0,
            "availability": "PRESALE",
            "plannedAvailabilityDate": "2025-04-02T00:00:00.000+02:00",
            "plannedAvailabilityDateDescription": "April 2025",
            "priceListName": "PL PK 2023-09",
            "priceListRowId": "G-002552",
            "priority": 0,
            "ausbauStatus": "HOMES_PREPARED"
        },
        {
            "technology": "FTTC",
            "isNetCologneNetwork": false,
            "promotionId": "2-2WREGUC",
            "maxDownload": 50,
            "minDownload": 0,
            "availability": "REALIZABLE",
            "plannedAvailabilityDate": null,
            "plannedAvailabilityDateDescription": "",
            "priceListName": "PL PK 2023-09",
            "priceListRowId": "G-002552",
            "priority": 1,
            "ausbauStatus": "UNBEKANNT"
        }
    ],
    "tvPromotions": [
        "NET_TV_INTERNET",
        "NET_TV_APP"
    ]
}  
  */
  -- Besprochen am 2025-02-26: Wir liefern eine Tabelle mit 4 Spalten zurück.
  -- [Technologie | maxDownload | availability | plannedAvailabilityDateDescription]
  --        aufsteigend sortiert über das Feld "priority" (0, 1, 2, ... mit 0 = höchste Prio)
  -- Als Überschrift: "Folgende Technologien sind an der angegenbenen Adresse in Siebel verfügbar"
  -- Unterhalb: "Schließen" sowie ein neuer Link zu Siebel:
  -- https://ncvsweb01p.netcologne.intern/siebel/app/ecommunications/deu?SWECmd=Login
  -- (ncvsweb01p: das p für PROD ersetzen durch entsprechendes Umgebungskürzel)

        for t in (
            select
                technology,
                to_number(max_download default null on conversion error) as max_download,
                substr(availability, 1, 10)                              as availability,
                availability_description
            from
                    json_table ( piv_json, '$.landlinePromotions[*]'
                        columns (
                            technology varchar2 ( 100 ) path '$.technology',
                            max_download varchar2 ( 30 ) path '$.maxDownload',
                            availability varchar2 ( 100 ) path '$.availability',
                            availability_description varchar2 ( 100 ) path '$.plannedAvailabilityDateDescription'
                        )
                    )
                j
        ) loop
            v_count_technologien := 1 + v_count_technologien;
            v_tabelle := v_tabelle
                         || '<tr>'
                         || '<td>'
                         || t.technology
                         || '</td>'
                         || '<td class="numeric">'
                         ||
                case
                    when t.max_download is not null then
                        t.max_download || ' Mbit/s'
                end
                         || '</td>'
                         || '<td>'
                         || t.availability
                         || '</td>'
                         || '<td>'
                         || t.availability_description
                         || '</td>'
                         || '</tr>';

        end loop;

        v_tabelle := '<table'
                     ||
            case
                when piv_html_id is not null then
                    ' id="'
                    || piv_html_id
                    || '"'
            end
                     || '>'
                     || '<caption>Technologien an dieser Installationsadresse:</caption>'
                     || '<tr><th>Technologie</th><th>max. Download</th><th>Verfügbarkeit</th><th>Datum</th></tr>'
                     ||
            case
                when v_count_technologien = 0 then
                    '<tr><td colspan="4">- keine Angaben zu den Technologien verfügbar - </td></tr>'
                else v_tabelle
            end
                     || '</table>';

        return v_tabelle;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end fv_landline_promotions_html;

-- @progress 2025-02-19

/**
 * Ruft den Anschlusscheck auf und gibt eine Tabelle der vorhandenen Landline-Promotions
 * und deren Verfügbarkeit für eine HausLfdNr zurück
 */
    function fv_anschlusscheck_technologien (
        pin_haus_lfd_nr in integer,
        piv_app_user    in varchar2,
        piv_html_id     in varchar2 default null
    ) return varchar2 is

        v_json          varchar2(32767); -- 32k ist wesentlich größer als die Antwort vom Anschlusscheck
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'fv_anschlusscheck_technologien';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_haus_lfd_nr', pin_haus_lfd_nr);
            pck_format.p_add('piv_app_user', piv_app_user);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 

    begin
        begin
            v_json := pck_pob_rest.fv_availability(
                pin_haus_lfd_nr => pin_haus_lfd_nr,
                piv_username    => piv_app_user
            );
        exception
        -- @ticket FTTH-5156: Es handelte sich um einen falsch mitgeteilten URL-Parameter
            when others then
                return '<div class="fehler">Der Adresscheck liefert kein auswertbares Ergebnis '
                       || chr(38)
                       || 'mdash; '
                       || rtrim(sqlerrm, ':')
                       || '</div>';
        end;

      -- HTML-Tabelle mit den Infos für den Glascontainer-Dialog zurückschicken:
        return fv_landline_promotions_html(
            piv_json    => v_json,
            piv_html_id => piv_html_id
        );
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end fv_anschlusscheck_technologien;  

-- @progress 2025-02-04

    function fv_href_siebel (
        piv_umgebung in varchar2 default null
    ) return varchar2
        deterministic
    is
        v_subdomain        varchar2(100);
        v_umgebung_postfix varchar2(10);
    begin
        v_umgebung_postfix := coalesce(piv_umgebung,
                                       case sys_context('USERENV', 'DB_NAME')
                                              when 'NMCE' then
                                                  'e'
                                              when 'NMCE3' then
                                                  'e3'
                                              when 'NMCS' then
                                                  's'
                                              when 'NMCU' then
                                                  'u'
                                              when 'NMCX' then
                                                  'x'
                                              when 'NMC' then
                                                  'p'
                                          end
        );
    -- Produktion:  ncvsweb01p
    -- Entwicklung: ncvsweb01e
        v_subdomain := 'ncvsweb01' || v_umgebung_postfix;
        return 'https://'
               || v_subdomain
               || '.netcologne.intern/siebel/app/ecommunications/deu?SWECmd=Login';
    end;

-- @progress 2025-03-26

/**
 * Ersetzt die gleichnamige FUNCTION und verwendet die HAUS_LFD_NR der zu prüfenden Installationsadresse
 * anstatt einzelner Adressfelder
 */
    function ft_vorbestellung_dublettencheck (
        piv_nachname              in varchar2,
        piv_vorname               in varchar2,
        pid_geburtsdatum          in date,
        piv_firmenname            in varchar2 -- wird in Kürze verwendet
  -- ,pin_haus_lfd_nr           IN INTEGER  -- @ticket FTTH-5038, aber: derzeit nicht verwendet
        ,
        piv_iban                  in varchar2,
        pin_ignore_service_errors in natural default 0 -- derzeit unbenutzt, spielt ohne Fuzzy keine Rolle
        ,
        pin_find_1_only           in natural default 0,
        piv_suchbereich           in varchar2 default null
    ) return t_dubletten
        pipelined
    is
    -- Bestimmt, wie präzise im Glascontainer/Preorderbuffer nach Duplikation gesucht wird:
        c_edit_distance   constant naturaln := 1; -- 0 = exakter Treffer, 1 = nah dran, ... 100 = völlig unterschiedlich
                                                    -- Der Wert "2" ist schon recht großzügig.
                                                    -- Ab "3" werden unbrauchbare Treffer mit ausgegeben.
        show_dummy_siebel constant boolean := false;    -- muss in der Produktion FALSE sein
        show_dummy_pob    constant boolean := false;    -- muss in der Produktion FALSE sein
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name   constant logs.routine_name%type := 'ft_vorbestellung_dublettencheck';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_nachname', piv_nachname);
            pck_format.p_add('piv_vorname', piv_vorname);
            pck_format.p_add('pid_geburtsdatum', pid_geburtsdatum);
            pck_format.p_add('piv_firmenname', piv_firmenname);
    --  pck_format.p_add('pin_haus_lfd_nr',           pin_haus_lfd_nr);
            pck_format.p_add('piv_iban', piv_iban);
            pck_format.p_add('pin_ignore_service_errors', pin_ignore_service_errors);
            pck_format.p_add('piv_suchbereich', piv_suchbereich);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
    -- Plausi-Check:
    -- Suche ohne Ergbebnis beenden, wenn die Voraussetzungen fehlen
        if
            ( piv_nachname is null
              or piv_vorname is null )
            and piv_firmenname is null
        then
            return;
        end if;

    -- Damit in der Entwicklungsumgebung überhaupt ein Report angezeigt wird (und man diesen somit konfigurieren kann!),
    -- kann hier eine Dummy-Zeile ausgegeben werden:
        if
            piv_suchbereich = 'SIE'
            and show_dummy_siebel
        then
            pipe row ( new t_dublette('SIE', '4711', '4711', null, null,
                                      'DUMMY Vorname', 'DUMMY Nachname', date '2000-01-01', 'DUMMY Firmenname', 'DUMMY Straße',
                                      '4711', '12345', 'DUMMY Ort', 'DE01 2345 6789 0123 4567 89', 'DUMMY Adresse mit Straße, PLZ Ort' -- @ticket FTTH-5038: Adresse komplett
                                      ) );

        end if;

        if
            piv_suchbereich = 'POB'
            and show_dummy_pob
        then
            pipe row ( new t_dublette('POB', '4711', '4711', null, null,
                                      'DUMMY Vorname', 'DUMMY Nachname', date '2000-01-01', 'DUMMY Firmenname', 'DUMMY Straße',
                                      '4711', '12345', 'DUMMY Ort', 'DE01 2345 6789 0123 4567 89', 'DUMMY Adresse mit Straße, PLZ Ort' -- @ticket FTTH-5038: Adresse komplett
                                      ) );
        end if;     

    -- Am wenigsten aufwändige Suche zuerst:
    -- Suche im Preorderbuffer über persönliche Daten oder IBAN  
        if piv_suchbereich is null
           or piv_suchbereich in ( 'POB', 'POB-N', 'POB-B' ) then
            for chk_pob in (
        -- Vergleiche Adresse oder IBAN im Preorder-Buffer:
                select
                    'POB'                                               as src,
                    'POB'                                               as link -- //// anders benennen
                    ,
                    'Auftrag in neuem Glascontainer-Fenster öffnen ...' as link_title,
                    pob.id                                              as id,
                    pob.customernumber                                  as kundennummer,
                    null                                                as rule_number,
                    null                                                as score,
                    pob.customer_name_first                             as vorname,
                    pob.customer_name_last                              as nachname,
                    pob.customer_birthdate                              as geburtsdatum,
                    pob.customer_businessname                           as firmenname,
                    pob.install_addr_street                             as strasse,
                    pob.install_addr_housenumber                        as hausnummer,
                    pob.install_addr_zipcode                            as plz,
                    pob.install_addr_city                               as ort,
                    pob.account_iban                                    as iban,
                    adr.adresse_kompl                                   as adresse_kompl
                from
                    ftth_ws_sync_preorders pob
                    left join pob_adressen           adr on ( adr.haus_lfd_nr = pob.houseserialnumber )
                where
                    pob.state in ( 'CREATED', 'IN_REVIEW', 'SIEBEL_PROCESSED' )
                    and -- rudimentäre Ähnlichkeitssuche im Preorderbuffer.
                     ( pob.customer_birthdate = pid_geburtsdatum )
                    and
               -- Aufträge werden als potenzielle Dubletten betrachtet, wenn...:
                     (    -- Fall 1: IBAN ist identisch
                    -------------------------------------------------------------------------------------------------------------
                     upper(pob.account_iban) = upper(replace(piv_iban, ' '))
                          or -- oder Fall 2: Vor- und Nachname sind sehr ähnlich
                    -------------------------------------------------------------------------------------------------------------
                           ( piv_firmenname is null
                               and utl_match.edit_distance(
                        upper(pob.customer_name_last),
                        upper(piv_nachname)
                    ) between 0 and c_edit_distance
                               and utl_match.edit_distance(
                        upper(pob.customer_name_first),
                        upper(piv_vorname)
                    ) between 0 and c_edit_distance )
                          or -- oder Fall 3: Firmenname ist sehr ähnlich:
                    -------------------------------------------------------------------------------------------------------------
                           ( piv_firmenname is not null
                               and utl_match.edit_distance(
                        upper(pob.customer_businessname),
                        upper(piv_firmenname)
                    ) between 0 and c_edit_distance )

                    -- 2024-06-18: Adressvergleiche werden erstmal nicht durchgeführt
                    --OR -- oder Fall 4: Die Adresse ist sehr ähnlich, wobei PLZ und Hausnummer (nicht Zusatz) identisch sein müssen und
                    --   -- Straße bzw. Ort sehr ähnlich:
                    ---------------------------------------------------------------------------------------------------------------
                    --   (install_addr_zipcode = piv_plz AND
                    --    UTL_MATCH.edit_distance(upper(install_addr_street), upper(piv_strasse)) BETWEEN 0 AND C_EDIT_DISTANCE AND
                    --    install_addr_housenumber = piv_hausnummer AND -- Zusatz wird ignoriert
                    --    UTL_MATCH.edit_distance(upper(install_addr_city), upper(piv_ort)) BETWEEN 0 AND C_EDIT_DISTANCE
                    --   )
                     )
            ) loop
                pipe row ( new t_dublette(chk_pob.src,
                                          chk_pob.id,
                                          chk_pob.kundennummer -- neu 2024-05-22
                                          ,
                                          chk_pob.rule_number,
                                          chk_pob.score,
                                          chk_pob.vorname,
                                          chk_pob.nachname,
                                          chk_pob.geburtsdatum,
                                          chk_pob.firmenname,
                                          chk_pob.strasse,
                                          chk_pob.hausnummer,
                                          chk_pob.plz,
                                          chk_pob.ort,
                                          chk_pob.iban,
                                          substr(chk_pob.adresse_kompl, 1, 200) -- neu 2025-03-27 @FTTH-5038: Adresse komplett
                                          ) );

                if pin_find_1_only = 1 then
                    return;
                end if;
            end loop;
        end if; -- /Suchbereich POB  

    -- SIEBEL,
    -- es wird nur noch 1 x gegen V_SIEBEL_KUNDENDATEN geprüft anstatt, wie Fuzzy es macht,
    -- zwei Abfragen (IBAN, Phonetische Suche) durchzuführen
        if piv_suchbereich is null
           or piv_suchbereich in ( 'SIE' ) then
    -- SIEBEL, als Ablösung von Fuzzy
            for chk_siebel in (
                select
                    global_id,
                    k.kundennummer,
                    anrede,
                    case upper(anrede)
                        when 'HERR' then
                            'MISTER'
                        when 'FRAU' then
                            'MISS'
                    end,
                    titel,
                    vorname,
                    nachname,
                    geburtsdatum,
                    firmenname,
                    strasse
                 -- @ticket FTTH-5038: Erweiterte/Zusatz-Felder aus der Siebel-View abfragen,
                 -- damit man daraus die ADRESSE_KOMPLETT bauen kann:
                    ,
                    hausnr_von,
                    hausnr_zusatz_von,
                    hausnr_bis,
                    hausnr_zusatz_bis
                 --------------------
                    ,
                    plz,
                    ort,
                    ap_email,
                    ap_mobil_country,
                    ap_mobil_onkz || ap_x_mobil_nr,
                    iban
                from
                    mv_siebel_kundendaten k -- 2024-07-17: Anstatt auf V_SIEBEL_KUNDENDATEN, welches ein Synonym ist für
                                        -- V_APX_GC_CUSTOMERDATA"@"SIEBP.NETCOLOGNE.INTERN@SIEBEL_INF,
                                        -- wird aufgrund der erheblich besseren Performance (< 10 Sek. vs. > 2 Min.)
                                        -- für die Siebel-Ähnlichkeitssuche nun die Materialized View angesprochen
                                        -- (deren Aktualisierungs-Intervall: 1 x täglich)
                    left join v_ist_kunde_geloescht g on k.kundennummer = g.kundennummer
                where
                    (-- Suche mit Vor- und Nachname:
                     ( piv_firmenname is null
                        and upper(nachname) like '%'
                        || trim(upper(piv_nachname))
                        || '%'
                           and upper(vorname) like '%'
                                                   || trim(upper(piv_vorname))
                                                   || '%'
                        and ( geburtsdatum = pid_geburtsdatum
                              or geburtsdatum is null ) )
                      or ( -- Suche mit Firmenname:
                       piv_firmenname is not null
                           and upper(firmenname) like '%'
                                                      || trim(upper(piv_firmenname))
                                                      || '%' ) )
                    and nvl(g.x_dsgvo_cust_locked, 'N') = 'N'-- FTTH-5490
            -- AND GUELTIG = 'Y' -- 2024-07-17 Dies entfällt, da in der MVIEW sowieso nur gültige enthalten sind.
           -- @weiter 2024-06-19: oder allein der Firmenname wird geprüft
            ) loop
                pipe row ( new t_dublette('SIE',
                                          chk_siebel.global_id,
                                          chk_siebel.kundennummer,
                                          '' -- chk_siebel.rule_number
                                          ,
                                          '' -- chk_siebel.score
                                          ,
                                          chk_siebel.vorname,
                                          chk_siebel.nachname,
                                          chk_siebel.geburtsdatum,
                                          chk_siebel.firmenname,
                                          ''-- chk_siebel.strasse     @deprecated @ticket FTTH-5038
                                          ,
                                          ''-- chk_siebel.hausnummer  @deprecated @ticket FTTH-5038
                                          ,
                                          ''-- chk_siebel.plz         @deprecated @ticket FTTH-5038
                                          ,
                                          ''-- chk_siebel.ort         @deprecated @ticket FTTH-5038
                                          ,
                                          chk_siebel.iban
                 -- neu @ticket FTTH-5038:
                                          ,
                                          pck_adresse.adresse_komplett(
                                                   piv_strasse               => chk_siebel.strasse,
                                                   piv_hausnummer            => chk_siebel.hausnr_von,
                                                   piv_hausnummer_zusatz     => chk_siebel.hausnr_zusatz_von,
                                                   piv_hausnummer_bis        => chk_siebel.hausnr_bis,
                                                   piv_hausnummer_zusatz_bis => chk_siebel.hausnr_zusatz_bis,
                                                   piv_gebaeudeteil          => null -- kommt in der Siebel-View nicht vor
                                                   ,
                                                   piv_plz                   => chk_siebel.plz,
                                                   piv_ort                   => chk_siebel.ort,
                                                   piv_ortsteil              => null -- kommt in der Siebel-View nicht vor
                                               )) );

                if pin_find_1_only = 1 then
                    return;
                end if;
            end loop;
        end if; -- /suchbereich SIE (1 von 2)

    -- SIEBEL,
    -- Vergleich über IBAN ohne Fuzzy:
        if piv_suchbereich is null
           or piv_suchbereich in ( 'SIE', 'BNK' ) then
            for chk_sie_iban in (
                select
                    global_id,
                    k.kundennummer,
                    anrede,
                    case upper(anrede)
                        when 'HERR' then
                            'MISTER'
                        when 'FRAU' then
                            'MISS'
                    end,
                    titel,
                    vorname,
                    nachname,
                    geburtsdatum,
                    firmenname,
                    strasse
                 -- @ticket FTTH-5038: Erweiterte/Zusatz-Felder aus der Siebel-View abfragen,
                 -- damit man daraus die ADRESSE_KOMPLETT bauen kann:
                    ,
                    hausnr_von,
                    hausnr_zusatz_von,
                    hausnr_bis,
                    hausnr_zusatz_bis
                 --------------------
                    ,
                    plz,
                    ort,
                    ap_email,
                    ap_mobil_country,
                    ap_mobil_onkz || ap_x_mobil_nr,
                    iban
                from
                    mv_siebel_kundendaten k -- 2024-07-17: Anstatt auf V_SIEBEL_KUNDENDATEN, welches ein Synonym ist für
                                    -- V_APX_GC_CUSTOMERDATA"@"SIEBP.NETCOLOGNE.INTERN@SIEBEL_INF,
                                    -- wird aufgrund der erheblich besseren Performance (< 10 Sek. vs. > 2 Min.)
                                    -- für die Siebel-Ähnlichkeitssuche nun die Materialized View angesprochen
                                    -- (deren Aktualisierungs-Intervall: 1 x täglich)
                    left join v_ist_kunde_geloescht g on k.kundennummer = g.kundennummer
                where
                        iban = replace(piv_iban, ' ') -- geprüft am 2024-06-18: Es gibt lediglich 4 IBANs, die mit 'de' anstatt 'DE' beginnen:
                                                -- dafür opfere ich keinen möglicherweise bestehenden Index auf IBAN bei der Abfrage
            -- AND GUELTIG = 'Y' -- MV besitzt ausschließlich gültige Daten
                    and nvl(g.x_dsgvo_cust_locked, 'N') = 'N'-- FTTH-5490
            ) loop
                pipe row ( new t_dublette('BNK',
                                          chk_sie_iban.global_id,
                                          chk_sie_iban.kundennummer,
                                          '' -- chk_sie_iban.rule_number
                                          ,
                                          '' -- chk_sie_iban.score
                                          ,
                                          chk_sie_iban.vorname,
                                          chk_sie_iban.nachname,
                                          chk_sie_iban.geburtsdatum,
                                          chk_sie_iban.firmenname,
                                          '' -- chk_sie_iban.strasse       @deprecated @ticket FTTH-5038
                                          ,
                                          '' -- chk_sie_iban.hausnummer    @deprecated @ticket FTTH-5038
                                          ,
                                          '' -- chk_sie_iban.plz           @deprecated @ticket FTTH-5038
                                          ,
                                          '' -- chk_sie_iban.ort           @deprecated @ticket FTTH-5038
                                          ,
                                          chk_sie_iban.iban
               -- neu @ticket FTTH-5038:
                                          ,
                                          pck_adresse.adresse_komplett(
                                                   piv_strasse               => chk_sie_iban.strasse,
                                                   piv_hausnummer            => chk_sie_iban.hausnr_von,
                                                   piv_hausnummer_zusatz     => chk_sie_iban.hausnr_zusatz_von,
                                                   piv_hausnummer_bis        => chk_sie_iban.hausnr_bis,
                                                   piv_hausnummer_zusatz_bis => chk_sie_iban.hausnr_zusatz_bis,
                                                   piv_gebaeudeteil          => null -- kommt in der Siebel-View nicht vor
                                                   ,
                                                   piv_plz                   => chk_sie_iban.plz,
                                                   piv_ort                   => chk_sie_iban.ort,
                                                   piv_ortsteil              => null -- kommt in der Siebel-View nicht vor
                                               )) );

                if pin_find_1_only = 1 then
                    return;
                end if;
            end loop;
        end if; -- /suchbereich SIE (2 von 2)

--/SIEBEL----------------------------------------------------------

        return;
    exception
        when no_data_needed then
            return;
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end ft_vorbestellung_dublettencheck;     

  /*
  --@ticket FTTH-6261
  -- Availability Check Light Aufrufen und die maximal mögliche Bandbreite ermitteln
  */
    function fv_anschlusscheck_get_max_bandbreite (
        pin_haus_lfd_nr in number,
        piv_app_user    in varchar2
    ) return number is

        v_json          varchar2(32767); -- 32k ist wesentlich größer als die Antwort vom Anschlusscheck
        l_ret           number;
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'fv_anschlusscheck_get_max_bandbreite';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_haus_lfd_nr', pin_haus_lfd_nr);
            pck_format.p_add('piv_app_user', piv_app_user);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 

    begin
        v_json := pck_pob_rest.fv_availability(
            pin_haus_lfd_nr => pin_haus_lfd_nr,
            piv_username    => piv_app_user
        );
        select
            jt.technical_planned_bandwidth
        into l_ret
        from
            dual,
            json_table ( v_json, '$.objectInformation'
                    columns (
                        technical_planned_bandwidth number path '$.technicalPlannedBandwidth'
                    )
                )
            jt;

        return l_ret;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end fv_anschlusscheck_get_max_bandbreite;

    function fv_format_bandwith (
        pi_bandwith in number
    ) return varchar2 as
        l_ret varchar2(500 char);
    begin
        l_ret := pi_bandwith || ' Mbit/s';
        return l_ret;
    end fv_format_bandwith;

end pck_glascontainer_order;
/


-- sqlcl_snapshot {"hash":"9cbcc074ab53c39974c1dd12741613ce030710cc","type":"PACKAGE_BODY","name":"PCK_GLASCONTAINER_ORDER","schemaName":"ROMA_MAIN","sxml":""}