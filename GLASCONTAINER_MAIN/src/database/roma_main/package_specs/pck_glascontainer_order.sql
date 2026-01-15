create or replace package roma_main.pck_glascontainer_order as 
/**
 * Hilfsroutinen für die Applikation 2022 "Glascontainer" zur Durchführung von
 * internen Vorbestellungen (Seiten 100, 110)
 *
 * @author  WISAND  Andreas Wismann  <wismann@when-others.com>
 * @date    2024-04-18
 * @url     Fehler-Logs beim Absenden einer Vorbestellung (Entwicklungsumgebung):
 *          https://testdock01dmz.netcologne.intern:9000/grafana/explore?left=%7B"datasource":"JJ_ifyhMz","queries":%5B%7B"datasource":%7B"type":"loki","uid":"JJ_ifyhMz"%7D,"editorMode":"code","expr":"%7Bswarm_stack%3D%5C"dss-pk-e%5C", swarm_service%3D~%60.%2A%28business-ftth-bff%29$%60%7D","queryType":"range","refId":"A"%7D%5D,"range":%7B"from":"now-3h","to":"now"%7D%7D&orgId=1
 * @url     Fehler-Logs beim Absenden einer Vorbestellung (Produktion):
 *          https://proddock01dmz.netcologne.intern:9000/grafana/explore?left=%7B"datasource":"gTwldlhMz","queries":%5B%7B"refId":"A","datasource":%7B"type":"loki","uid":"gTwldlhMz"%7D,"editorMode":"builder","expr":"%7Bswarm_service%3D%5C"dss-pk_dss-business-ftth-bff%5C"%7D %7C%3D %60%60","queryType":"range"%7D%5D,"range":%7B"from":"now-3h","to":"now"%7D%7D&orgId=1
 *
 * @unittest
 * SELECT * FROM TABLE(UT.RUN('UT_GLASCONTAINER', a_tags => 'PCK_GLASCONTAINER_ORDER'));
 */

  -- Umlaut-Test: ÄÖÜäöüß?

    version constant varchar2(30) := '2025-05-21 0900';

  -- Alle Fehlermeldungen aus diesem Package benutzen diesen Scope: 
    g_scope constant logs.scope%type := 'GLASCONTAINER';
    bestandskunde constant varchar2(1) := 'B';
    neukunde constant varchar2(1) := 'N';
    anbieter_telekom constant varchar2(4) := 'TCOM';
    anbieter_deutsche_glasfaser constant varchar2(2) := 'DG';
    c_plausi_error_number constant integer := -20002;
    e_plausi_error exception;
    pragma exception_init ( e_plausi_error,
    c_plausi_error_number );   

  /**
   * Dieser TYP ist der Gegenentwurf zu PCK_FUZZYDOUBLE::T_FUZZY_PERSON,
   * da die Fuzzy-Abfrage möglicherweise komplett aus dem Glascontainer herausgenommen wird
   */
    type t_dublette is record (
            src              varchar2(3) -- SIE|POB
            ,
            row_id           varchar2(100)  -- technischer PK entweder aus dem Preorderbuffer (UUID) oder Siebel (global_id)
            ,
            kundennummer     varchar2(100)  --
            ,
            rule_number      integer        -- derzeit unbenutzt
            ,
            score            number         -- derzeit unbenutzt
            ,
            vorname          varchar2(100),
            nachname         varchar2(100),
            geburtsdatum     date,
            firmenname       varchar2(100),
            strasse          varchar2(100) -- @deprecated (nur noch adresse_komplett verwenden)
            ,
            hausnummer       varchar2(30)  -- @deprecated
            ,
            plz              varchar2(10),
            ort              varchar2(100),
            iban             varchar2(100)
          -- im Gegensatz zu T_FUZZY_PERSON gibt es hier keine "Kontonummer" oder "BIC" mehr, denn diese Felder wurden nie benutzt.
            ,
            adresse_komplett varchar2(200) -- neu 2025-03-27, Länge tatsächlich ermittelt am 2025-03-26: max. 85
    );
    type t_dubletten is
        table of t_dublette;
    type t_order_tracking is record (
            pos       number        -- Sortierung
            ,
            infolevel number        -- "Einrückung" 0...4: In dieser >Displayspalte steht der Beschreibungstext
            ,
            vorgang   varchar2(255),
            anzahl    number        -- zur besseren Auswertung per SQL: Gleiche Information wie in der rechten Displayspalte
                              -- (diese variiert aber mit dem Infolevel)
            ,
            d0        varchar2(255) -- Displayspalte 0
            ,
            d1        varchar2(255) -- Displayspalte 1
            ,
            d2        varchar2(255) -- Displayspalte 2
            ,
            d3        varchar2(255) -- Displayspalte 3
            ,
            d4        varchar2(255) -- Displayspalte 4   
    );
    type t_order_trackings is
        table of t_order_tracking;

  /** 
  * Gibt den Versionsstring des Package Bodies zurück 
  */
    function get_body_version return varchar2
        deterministic; 

/** 
 * Ermöglicht den direkten Sprung zu einer anderen Maske.
 * 
 * @param siehe APEX App 2022 P100
 *
 * @usage Diese Prozedur kann nach Ausbau bzw. Deaktivierung der Test-Buttons entfernt werden
 *
 * @version 2024-04-18 0730
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
        piov_ont_provider              in out varchar2,
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
        piov_siebel_message            in out varchar2,
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
    );

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
        piov_ont_provider                  in out varchar2,
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
    );  

 /**
 * Nimmt von APEX die gesammelten Daten der Seite "Vorbestellung erfassen" entgegen,
 * validiert noch einmal kontextsensitiv und schickt den Auftrag an den Preorderbuffer.
 *
 * @ticket FTTH-2829
 *
 * @exception   Fachliche Exceptions werden als Benutzer-lesbare Validierungen formuliert
 *              (C_PLAUSI_ERROR_NUMBER = -20002)
 * @exception   Alle technischen Exceptions werden geraised.
 *
 * ////@deprecated: in APEX ersetzt durch FN_VORBESTELLUNG_ERFASSEN
 *
 */
    procedure p_vorbestellung_erfassen (
        piv_app_user                           in varchar2,
        piv_vkz                                in varchar2,
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
        piv_ont_provider                       in varchar2
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
    );  


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
        piov_installationsadresse_komplett    in out varchar2  --@krakar @ticket FTTH-4622
        ,
        piov_abw_bisheriger_anbieter          in out varchar2,
        piov_abw_rufnummernmitnahme           in out varchar2,
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
        piov_ont_provider                     in out varchar2,
        piov_check_agb                        in out varchar2,
        piov_check_widerruf                   in out varchar2,
        piov_vc_status                        in out varchar2,
        piod_vc_ausbau_plan_termin            in out date,
        piov_is_duplicate                     in out varchar2
    );

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
    );

/**
 * Gibt einen String zurück, der das Verfügbarkeitsdatum eines Vermarktungsclusters in Halbjahren beschreibt
 *
 * @ticket FTTH-2829
 */
    function fv_verfuegbarkeit_halbjahr (
        pid_plan_termin in date
    ) return varchar2;

-- @progress 2024-05-15

  /**
   * Prüft, ob die von Siebel erhaltenen Kundendaten für eine Bestellung im Glascontainer
   * valide zu verwenden sind, und gibt entweder die Werte an die Ausgabe-Items zurück
   * oder erzeugt einen Application Error mit Nutzer-lesbarem Fehlertext
   *
   * @param  piv_kundennummer [IN]
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
    );

/**  
 * Liefert die Ergebnisse der Dublettenprüfung für die Glascontainer-Bestellstrecke.
 * Achtung: Dies ist der Prototyp einer Dublettensuche, der die Fuzzy-Suche zumindest verübergehend ablöst
 * (ersetzt PCK_FUZZYDOUBLE.ft_vorbestellung_dublettencheck)
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
        piv_firmenname            in varchar2 -- wird in Kürze verwendet
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
        pipelined;   

/**
 * Gibt den vom Webservice erwarteten Statuswert zurück, siehe @ticket FTTH-1972
 * 
 * @param piv_status [IN ] Statuswert, der in der Tabelle VERMARKTUNGSCLUSTER verwendet wird:
 *                         ZUSAMMENGROSSGESCHRIEBEN; 
 *                         es darf aber auch ein bereits normalisierter Wert sein
 *
 * @return
 * Status NULL ergibt Statusdisplay NULL.
 *
 * @todo //// konsolidieren mit gleichnamiger FUNCTION im PCK_VERMARKTUNGSCLUSTER
 */
    function fv_vc_status_webservice (
        piv_status vermarktungscluster.status%type
    ) return varchar2
        deterministic;  


 /**
 * Gibt TRUE zurück und füllt die entsprechenden OUT-Felder, wenn anhand der Eingabe-Parameter ein Sprung
 * von APEX-Seite 14 ("Vorbestellung") zu Seite 100 ("Auftragserfassung") möglich ist, wobei dann in APEX
 * die zu den piv_...-Eingabefeldern zugehörigen Items vorbelegt werden
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
        pov_technologie      out varchar2,
        pov_usermessage      out varchar2,
        pov_link_objektinfo  out varchar2
    ) return boolean;  

  /**      
   * Gibt 1 zurück, wenn für ein Objekt die Notwendigkeit der Eigentümerdaten besteht,
   * 0 wenn nicht und NULL wenn dazu keine Informationen vorliegen.
   *
   * @param pin_haus_lfd_nr       [IN ]  Objekt-ID
   * @param piv_wholebuy_partner  [IN ] Wholebuy-Partner für dieses Objekt, falls zutreffend ('TCOM' oder 'DG')
   *                                    ansonsten NULL
   *                                    Wenn gesetzt, kann unter Umständen die Abfrage effizienter ausgeführt werden
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
    ) return natural;


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
    ) return date;  


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
    ) return natural;  


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
 * D0, D1, D2, D3, D4     Der gemäß @ticket FTTH-4003 anzuzeigende Text (Display-Spalten von links nach rechts)
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
        pipelined;

    function fp_order_tracking2 (
        pid_von in date default null,
        pid_bis in date default null,
        piv_vkz in varchar2 default null
    ) return t_order_trackings
        pipelined;

    function neue_externe_auftragsnummer (
        piv_id in varchar2
    ) return varchar2;    

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
    ) return varchar2;

-- @progress 2025-01-21

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
        piv_ont_provider                       in varchar2
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
    ) return ftth_ws_sync_preorders.id%type;

-- @progress 2025-01-05

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
    ) return varchar2;

/**
 * Ruft den Anschlusscheck auf und gibt eine Tabelle der vorhandenen Landline-Promotions
 * und deren Verfügbarkeit für eine HausLfdNr zurück
 */
    function fv_anschlusscheck_technologien (
        pin_haus_lfd_nr in integer,
        piv_app_user    in varchar2,
        piv_html_id     in varchar2 default null
    ) return varchar2;

    function fv_href_siebel (
        piv_umgebung in varchar2 default null
    ) return varchar2
        deterministic;


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
        pipelined;

  /*
  --@ticket FTTH-6261
  -- Availability Check Light Aufrufen und die maximal mögliche Bandbreite ermitteln
  */
    function fv_anschlusscheck_get_max_bandbreite (
        pin_haus_lfd_nr in number,
        piv_app_user    in varchar2
    ) return number;

    function fv_format_bandwith (
        pi_bandwith in number
    ) return varchar2;

end;
/


-- sqlcl_snapshot {"hash":"e1172707c7b2c892418131f7a31b680d9f306fd7","type":"PACKAGE_SPEC","name":"PCK_GLASCONTAINER_ORDER","schemaName":"ROMA_MAIN","sxml":""}