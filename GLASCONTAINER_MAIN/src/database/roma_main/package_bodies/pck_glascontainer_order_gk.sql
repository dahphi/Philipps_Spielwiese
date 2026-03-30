create or replace package body pck_glascontainer_order_gk as

  /**
  * Hilfsroutinen für die Applikation 2022 "Glascontainer" zur Durchführung von
  * internen Vorbestellungen (Seiten 100, 110)
  */

  -- Umlaut-Test: ÄÖÜäöüß?

  -- Wird zum Erstellen eines JSON_OBJECT_T gebraucht 
    c_empty_json constant varchar2(2) := '{}';
    json_true    constant varchar2(5) := 'true';
    json_false   constant varchar2(5) := 'false'; 

  -- zum schnelleren Auffinden von Flags 0|1 im Quellcode:
    c_nein       constant varchar2(1) := '0';
    c_ja         constant varchar2(1) := '1';


---------------------------------------------------------------------------------------------------

    procedure p_gk_daten_acheck_light (
        pin_haus_lfd_nr           in number,
        piv_app_user              in varchar2,
        pov_mandant               out varchar2,
        pov_wholebuy_partner      out varchar2,
        pov_ausbaus_status        out varchar2,
        pov_merged_access_type    out varchar2,
        pov_planned_bandwidth     out varchar2,
        pov_eigentuemerdaten      out varchar2,
        pov_adress_complete       out varchar2,
        pov_availability_date_raw out varchar2
    ) is

        v_json                  varchar2(32767); -- 32k ist wesentlich größer als die Antwort vom Anschlusscheck
        v_ausbaustatus_landline varchar2(100);

  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name         constant logs.routine_name%type := 'p_gk_daten_acheck_light';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_haus_lfd_nr', pin_haus_lfd_nr);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
  -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 

    begin
        v_json := pck_pob_rest.fv_availability(
            pin_haus_lfd_nr => pin_haus_lfd_nr,
            piv_username    => piv_app_user
        );
  --dbms_output.put_line(v_json);

        select
            jt.planned_bandwidth,
            jt.eigentuemerdaten,
            jt.partner,
            jt.merged_access_type,
            jt.adress_complete,
            jt.mandant,
            jt.ausbau_status
        into
            pov_planned_bandwidth,
            pov_eigentuemerdaten,
            pov_wholebuy_partner,
            pov_merged_access_type,
            pov_adress_complete,
            pov_mandant,
            pov_ausbaus_status
        from
            dual,
            json_table ( v_json, '$'
                    columns (
                        planned_bandwidth varchar2 path '$.objectInformation.technicalPlannedBandwidth',
                        eigentuemerdaten varchar2 path '$.objectInformation.wholebuy.eigentuemerdatenErforderlich',
                        partner varchar2 path '$.objectInformation.wholebuy.partner',
                        ausbau_status varchar2 path '$.objectInformation.ausbauStatus',
                        merged_access_type varchar2 path '$.objectInformation.mergedAccessType',
                        availabilitydateraw varchar2 path '$.objectInformation.availabilityDateRaw',
                        adress_complete varchar2 path '$.address.addressComplete',
                        mandant varchar2 path '$.address.mandant'
                    )
                )
            jt;
    -- AvailabilityDate ermitteln:
        pov_availability_date_raw := pck_glascontainer_order_gk.f_get_availability_date(v_json);

    -- Ausbaustatus soll aus den LandlinePromotions ermittelt werden, wenn eine vorhanden ist
    -- Diese müssen über den mergedAccessType abgeglichen werden.
    -- Und es exisitert nicht immer Eintrag mit der entsprechenden Technologie 
        begin
            select
                jt.ausbaustatus
            into v_ausbaustatus_landline
            from
                dual,
                json_table ( v_json, '$'
                        columns (
                            nested path '$.landlinePromotions[*]'
                                columns (
                                    technology varchar2 ( 50 ) path '$.technology',
                                    ausbaustatus varchar2 ( 50 ) path '$.ausbauStatus'
                                )
                        )
                    )
                jt
            where
                jt.technology = pov_merged_access_type;

        exception
            when others then
                v_ausbaustatus_landline := null;
        end;

        if ( v_ausbaustatus_landline is not null ) then
            pov_ausbaus_status := v_ausbaustatus_landline;
        end if;
        if ( pov_ausbaus_status is null ) then
            pov_ausbaus_status := 'UNBEKANNT';
        end if;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end p_gk_daten_acheck_light;

    function f_get_availability_date (
        pi_json in varchar2
    ) return varchar2 as

        l_ret                varchar2(50);
        l_availability_date  varchar2(50);
        l_merged_access_type varchar2(50 char);
        l_ausbau_status      varchar2(50 char);

    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name      constant logs.routine_name%type := 'p_gk_daten_acheck_light';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pi_json', pi_json);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;

    begin
        select
            jt.merged_access_type,
            jt.ausbau_status,
            availabilitydateraw
        into
            l_merged_access_type,
            l_ausbau_status,
            l_availability_date
        from
                json_table ( pi_json, '$'
                    columns (
                        merged_access_type varchar2 path '$.objectInformation.mergedAccessType',
                        ausbau_status varchar2 path '$.objectInformation.ausbauStatus',
                        availabilitydateraw varchar2 ( 50 ) path '$.objectInformation.availabilityDateRaw'
                    )
                )
            jt;

        if
            l_merged_access_type in ( 'FTTH_BSA_L2', 'FTTH_BSA_L2_DG' )
            and l_ausbau_status in ( 'AREAPLANNED', 'PREMARKETING', 'UNDER_CONSTRUCTION' )
        then
            l_ret := l_availability_date;
        else
            select
                case
                    when jt.availability = 'REALIZABLE' then
                        plannedavailabilitydate
                    else
                        null
                end as availability_date
            into l_availability_date
            from
                    json_table ( pi_json, '$'
                        columns (
                            merged_access_type varchar2 path '$.objectInformation.mergedAccessType',
                            nested path '$.landlinePromotions[*]'
                                columns (
                                    technology varchar2 ( 50 ) path '$.technology',
                                    ausbau_status_llp varchar2 ( 50 ) path '$.ausbauStatus',
                                    availability varchar2 ( 50 ) path '$.availability',
                                    plannedavailabilitydate varchar2 ( 50 ) path '$.plannedAvailabilityDate'
                                )
                        )
                    )
                jt  -- Variante 1 Homes Connected: Landline Promotion Ausbaustatus ist Homes Connected und Technologie und Merged Access Type = FTTH_BSA_L2_DG
            where
                ( jt.merged_access_type = 'FTTH_BSA_L2_DG'
                  and jt.ausbau_status_llp = 'HOMES_CONNECTED'
                  and jt.technology = 'FTTH_BSA_L2_DG' )
                or
              -- Variante 2 Homes Ready: Landline Promotion Ausbaustatus ist Homes Ready und Technologie und Merged Access Type = FTTH_BSA_L2
                 ( jt.merged_access_type = 'FTTH_BSA_L2'
                     and jt.ausbau_status_llp = 'HOMES_READY'
                     and jt.technology = 'FTTH_BSA_L2' );

            l_ret := l_availability_date;
        end if;

        return l_ret;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end f_get_availability_date;

---------------------------------------------------------------------------------------------------

    function fv_format_knd_nr (
        pin_knd_nr       in number,
        piv_unter_knd_nr in varchar2
    ) return varchar2 is
        v_ret_knd_nr varchar2(100);
    begin
        if ( pin_knd_nr is not null ) then
            v_ret_knd_nr := pin_knd_nr;
            if ( piv_unter_knd_nr is not null ) then
                v_ret_knd_nr := v_ret_knd_nr
                                || '-'
                                || lpad(piv_unter_knd_nr, 4, '0');
            end if;

        else
            v_ret_knd_nr := null;
        end if;

        return v_ret_knd_nr;
    exception
        when others then
            return null;
    end fv_format_knd_nr;

---------------------------------------------------------------------------------------------------

    function fv_format_haus_lfd_nr (
        pin_haus_lfd_nr in number
    ) return varchar2 is
        v_ret_hlfdnr_link varchar2(1000);
    begin
        if ( pin_haus_lfd_nr is not null ) then
            v_ret_hlfdnr_link := '<a href="'
                                 || pck_objektinfo.fv_url_objektinfo()
                                 || pin_haus_lfd_nr
                                 || '" target="_blank">'
                                 || pin_haus_lfd_nr
                                 || '</a>';
        else
            v_ret_hlfdnr_link := null;
        end if;

        return v_ret_hlfdnr_link;
    exception
        when others then
            return null;
    end;

---------------------------------------------------------------------------------------------------

    function fv_format_bandwith (
        pi_bandwith in number
    ) return varchar2 as
        l_ret varchar2(500 char);
    begin
        l_ret := pi_bandwith || ' Mbit/s';
        return l_ret;
    end fv_format_bandwith;

---------------------------------------------------------------------------------------------------

    function fv_check_link_parameter (
        piv_parameter       in varchar2,
        piv_parameter_name  in varchar2,
        piv_check_typ       in varchar2 default 'NOT NULL',
        piv_check_condition in varchar2 default null
    ) return varchar2 is
        v_ret_error_message varchar2(4000);
        n_anz               pls_integer;
    begin
        if ( piv_check_typ = 'NOT NULL' ) then
            if ( piv_parameter is null ) then
                case piv_parameter_name
                    when 'P150_HAUS_LFD_NR' then
                        v_ret_error_message := 'Fehler: Die Installationsadresse ist ungültig oder fehlt.';
                    when 'P150_KND_NR' then
                        v_ret_error_message := 'Fehler: Bitte prüfen Sie die Kundennummer.';
                    when 'P150_UNTER_KND_NR' then
                        v_ret_error_message := 'Fehler: Bitte prüfen Sie die Unterkundennummer.';
                    when 'P150_AUFTRAGS_NR' then
                        v_ret_error_message := 'Fehler: Die Auftragsnummer fehlt.';
                    when 'P150_ROW_ID' then
                        v_ret_error_message := 'Fehler: Die eindeutige Auftrags-ID (Row-ID) fehlt.';
                    when 'P150_GK_INST_ADRESSE' then
                        v_ret_error_message := 'Fehler: Die Installationsadresse ist ungültig oder fehlt.';
                    when 'P150_FIRMA' then
                        v_ret_error_message := 'Fehler: Bitte prüfen Sie den Firmennamen.';
                    else
                        v_ret_error_message := 'Fehler: Parameter <'
                                               || piv_parameter_name
                                               || '> ist leer.';
                end case;

            else
                v_ret_error_message := null;
            end if;
        elsif ( piv_check_typ = 'IN' ) then
            select
                count(1)
            into n_anz
            from
                dual
            where
                piv_parameter in (
                    select
                        *
                    from
                        apex_string.split(piv_check_condition, ',')
                );

            if ( n_anz = 0 ) then
                case piv_parameter_name
                    when 'P150_BU' then
                        v_ret_error_message := 'Fehler: Die ausgewählte Business Unit ist nicht zulässig.';
                    else
                        v_ret_error_message := 'Fehler: Parameter <'
                                               || piv_parameter_name
                                               || '> ist nicht in '
                                               || piv_check_condition
                                               || '.';
                end case;

            end if;

        else
            v_ret_error_message := null;
        end if;

        return v_ret_error_message;
    end fv_check_link_parameter;

--------------------------------------------------------------------------------------------------- 

    function fv_check_gk_wb_order (
        pin_haus_lfd_nr in number,
        piv_app_user    in varchar2
    ) return varchar2 is

        v_ret_order_yn  varchar2(1);
        v_json          varchar2(32767); -- 32k ist wesentlich größer als die Antwort vom Anschlusscheck
        n_anz           pls_integer;

  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'fv_check_gk_wb_order';

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
            count(1)
        into n_anz
        from
            (
                select
                    jt.merged_access_type,
                    jt.ausbau_status,
                    jt.technology,
                    jt.ausbau_status_llp -- Ausbaustatus von der Landline Promotion wo MergedAccesstype = Technology ist
                from
                    dual,
                    json_table ( v_json, '$'
                            columns (
                                merged_access_type varchar2 path '$.objectInformation.mergedAccessType',
                                ausbau_status varchar2 path '$.objectInformation.ausbauStatus',
                                nested path '$.landlinePromotions[*]'
                                    columns (
                                        technology varchar2 ( 50 ) path '$.technology',
                                        ausbau_status_llp varchar2 ( 50 ) path '$.ausbauStatus'
                                    )
                            )
                        )
                    jt
            ) acheck
        where -- Variante 1 Not Conncected: Merged Access Type entweder FTTH_BSA_L2, FTTH_BSA_L2_DG und Ausbaustatus Areaplanned, Premarketing oder Under Construction
            ( acheck.merged_access_type in ( 'FTTH_BSA_L2', 'FTTH_BSA_L2_DG' )
              and acheck.ausbau_status in ( 'AREAPLANNED', 'PREMARKETING', 'UNDER_CONSTRUCTION' ) )
            or
           -- Variante 2 Homes Connected: Landline Promotion Ausbaustatus ist Homes Connected und Technologie und Merged Access Type = FTTH_BSA_L2_DG
             ( acheck.merged_access_type in ( 'FTTH_BSA_L2_DG' )
                 and acheck.ausbau_status_llp in ( 'HOMES_CONNECTED' )
                 and acheck.technology in ( 'FTTH_BSA_L2_DG' ) )
           -- Variante 3 Homes Ready: Landline Promotion Ausbaustatus ist Homes Ready und Technologie und Merged Access Type = FTTH_BSA_L2
            or ( acheck.merged_access_type in ( 'FTTH_BSA_L2' )
                 and acheck.ausbau_status_llp in ( 'HOMES_READY' )
                 and acheck.technology in ( 'FTTH_BSA_L2' ) );

        if ( n_anz = 0 ) then
            v_ret_order_yn := 'N';
        else
            v_ret_order_yn := 'Y';
        end if;

        return v_ret_order_yn;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end fv_check_gk_wb_order;

--------------------------------------------------------------------------------------------------- 

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
    ) return t_gk_order_trackings
        pipelined
    is

        datum_von           constant date := trunc(coalesce(pid_von, date '2024-09-20')); -- erster Tag der Datenerfassung
        datum_bis           constant date := trunc(coalesce(pid_bis, pid_von, sysdate));
    --------------------------
        aufrufe             naturaln := 0;
        aufrufe_siebel      naturaln := 0;
    --------------------------
        bu_gk_gefunden      naturaln := 0;
        ba_gk_gefunden      naturaln := 0;
        bu_nc_gefunden      naturaln := 0;
        ba_nc_gefunden      naturaln := 0;
        keine_bu_gefunden   naturaln := 0;
        eigentuemer_daten_y naturaln := 0;
        eigentuemer_daten_n naturaln := 0;
        page_160_visited    naturaln := 0;
        page_170_visited    naturaln := 0;



    --------------------------
        bestellungen        naturaln := 0;
        pos_unbekannt       natural := null;

        function bold (
            i_text in varchar2
        ) return varchar2 is
        begin
            return '<b>'
                   || i_text
                   || '</b>';
        end;

        function italics (
            i_text in varchar2
        ) return varchar2 is
        begin
            return '<i>'
                   || i_text
                   || '</i>';
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
                max(task_request)      as task_request,
                max(bu)                as bu,
                max(eigentuemer_daten) as eigentuemer_daten,
                max(scope)             as max_scope
        ---   , MAX(LAST_KUNDENDATEN)   AS LAST_KUNDENDATEN
            from
                v_pob_tracking_gk
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
            aufrufe := aufrufe + 1;
            if d.task_request = 'SIEBEL GK' then
                aufrufe_siebel := 1 + aufrufe_siebel;
            end if;
            case d.bu
                when 'BU GK' then
                    bu_gk_gefunden := bu_gk_gefunden + 1;
                when 'BA GK' then
                    ba_gk_gefunden := ba_gk_gefunden + 1;
                when 'BU NC' then
                    bu_nc_gefunden := bu_nc_gefunden + 1;
                when 'BA NC' then
                    ba_nc_gefunden := ba_nc_gefunden + 1;
                else
                    keine_bu_gefunden := keine_bu_gefunden + 1;
            end case;

            if ( upper(nvl(d.eigentuemer_daten, 'FALSE')) = 'TRUE' ) then
                eigentuemer_daten_y := eigentuemer_daten_y + 1;
            else
                eigentuemer_daten_n := eigentuemer_daten_n + 1;
            end if;

            case d.max_scope
                when '2' then
                    page_160_visited := page_160_visited + 1;
                when '3' then
                    page_160_visited := page_160_visited + 1;
                    page_170_visited := page_170_visited + 1;
                else
                    null;
            end case;

            if d.max_scope >= 99 then
                page_160_visited := page_160_visited + 1;
                if ( upper(nvl(d.eigentuemer_daten, 'FALSE')) = 'TRUE' ) then
                    page_170_visited := page_170_visited + 1;
                end if;
      -- ab 99: "Kostenpflichtig bestellen" angeklickt, 100 = Bestellung erfolgreich!
      -- Dieser wichtige Unterschied wird momentan nicht ausgewertet
                bestellungen := bestellungen + 1;
            end if;

        end loop;

    -- Für jeden im Loop kumulierten Wert die entsprechende Report-Zeile ausgeben:
        pipe row ( new t_gk_order_tracking(
            pos       => 10,
            infolevel => 0,
            anzahl    => aufrufe,
            vorgang   => 'AUFRUF',
            d0        => 'GK Bestellstrecke aufgerufen',
            d1        => bold(aufrufe)
        ) );

        if aufrufe_siebel > 0 then
            pipe row ( new t_gk_order_tracking(
                pos       => 11,
                infolevel => 0,
                anzahl    => aufrufe_siebel,
                vorgang   => 'AUFRUF',
                d0        => '(davon über SIEBEL Link)',
                d1        => bold(aufrufe_siebel)
            ) );
        end if;

        pipe row ( new t_gk_order_tracking(
            pos       => 111,
            infolevel => 2,
            anzahl    => bu_gk_gefunden,
            vorgang   => 'BESTELLUNG',
            d1        => italics('BU GK'),
            d2        => bold(bu_gk_gefunden)
        ) );

        pipe row ( new t_gk_order_tracking(
            pos       => 112,
            infolevel => 2,
            anzahl    => ba_gk_gefunden,
            vorgang   => 'BESTELLUNG',
            d1        => italics('BA GK'),
            d2        => bold(ba_gk_gefunden)
        ) );

        pipe row ( new t_gk_order_tracking(
            pos       => 112,
            infolevel => 2,
            anzahl    => bu_nc_gefunden,
            vorgang   => 'BESTELLUNG',
            d1        => italics('BU NC'),
            d2        => bold(bu_nc_gefunden)
        ) );

        pipe row ( new t_gk_order_tracking(
            pos       => 112,
            infolevel => 2,
            anzahl    => ba_nc_gefunden,
            vorgang   => 'BESTELLUNG',
            d1        => italics('BA NC'),
            d2        => bold(ba_nc_gefunden)
        ) );

        pipe row ( new t_gk_order_tracking(
            pos       => 112,
            infolevel => 2,
            anzahl    => keine_bu_gefunden,
            vorgang   => 'BESTELLUNG',
            d1        => italics('falsche BU'),
            d2        => bold(keine_bu_gefunden)
        ) );

        pipe row ( new t_gk_order_tracking(
            pos       => 300,
            infolevel => 2,
            anzahl    => page_160_visited,
            vorgang   => 'BESTELLUNG',
            d2        => 'Kundendaten aufgerufen',
            d3        => bold(page_160_visited)
        ) );

        pipe row ( new t_gk_order_tracking(
            pos       => 400,
            infolevel => 2,
            anzahl    => eigentuemer_daten_y,
            vorgang   => 'BESTELLUNG',
            d3        =>('Eigentümerdaten notwendig'),
            d4        => bold(eigentuemer_daten_y)
        ) );

        pipe row ( new t_gk_order_tracking(
            pos       => 400,
            infolevel => 2,
            anzahl    => eigentuemer_daten_n,
            vorgang   => 'BESTELLUNG',
            d3        =>('Eigentümerdaten nicht notwendig'),
            d4        => bold(eigentuemer_daten_n)
        ) );

        pipe row ( new t_gk_order_tracking(
            pos       => 500,
            infolevel => 2,
            anzahl    => page_170_visited,
            vorgang   => 'BESTELLUNG',
            d3        => 'Eigentümerdaten aufgerufen',
            d4        => bold(page_170_visited)
        ) );

        pipe row ( new t_gk_order_tracking(
            pos       => 1010,
            infolevel => 3,
            anzahl    => bestellungen,
            vorgang   => 'BESTELLUNG',
            d5        => '"Kostenpflichtig bestellen" angeklickt',
            d6        => bold(bestellungen)
        ) );

        return;
    end fp_order_tracking2;

--------------------------------------------------------------------------------------------------- 

    function fj_gk_order (
        piv_gee_kontaktdaten_bekannt                                  in varchar2, -- 1|0
        piv_customernumber                                            in varchar2,
        piv_subcustomernumber                                         in varchar2,
        piv_siebelordernumber                                         in varchar2,
        piv_siebelorderrowid                                          in varchar2,
        piv_client                                                    in varchar2,
        piv_templateid                                                in varchar2,-- ftth-connectivity-100-50
                          --piv_expansionStatus                                                                 IN VARCHAR2,--AREA_PLANNED
        piv_availabilitydate                                          in varchar2,--2025-11-27
        piv_createdby                                                 in varchar2,
        piv_houseserialnumber                                         in varchar2,
        piv_propertyownerdeclaration_propertyownerrole                in varchar2,
        piv_propertyownerdeclaration_residentialunit                  in varchar2,
        piv_propertyownerdeclaration_landlord_legalform               in varchar2,
        piv_propertyownerdeclaration_landlord_businessorname          in varchar2,
        piv_propertyownerdeclaration_landlord_salutation              in varchar2,
        piv_propertyownerdeclaration_landlord_title                   in varchar2,
        piv_propertyownerdeclaration_landlord_name_first              in varchar2,
        piv_propertyownerdeclaration_landlord_name_last               in varchar2,
        piv_propertyownerdeclaration_landlord_address_street          in varchar2,
        piv_propertyownerdeclaration_landlord_address_housenumber     in varchar2,
        piv_propertyownerdeclaration_landlord_address_zipcode         in varchar2,
        piv_propertyownerdeclaration_landlord_address_city            in varchar2,
        piv_propertyownerdeclaration_landlord_address_postaladdition  in varchar2,
        piv_propertyownerdeclaration_landlord_address_country         in varchar2,
        piv_propertyownerdeclaration_landlord_email                   in varchar2,
        piv_propertyownerdeclaration_landlord_phonenumber_countrycode in varchar2,
        piv_propertyownerdeclaration_landlord_phonenumber_areacode    in varchar2,
        piv_propertyownerdeclaration_landlord_phonenumber_number      in varchar2,
        piv_contactpersons                                            in t_contact_persons
    ) return clob is
        vj_body json_object_t := new json_object_t(c_empty_json);
    begin
/*
{
  "customerNumber": "string",
  "subCustomerNumber": 0,
  "siebelOrderNumber": "string",
  "siebelOrderRowId": "string",
  "client": "NC",
  "templateId": "ftth-connectivity-100-50",
  "expansionStatus": "AREA_PLANNED",
  "availabilityDate": "2025-11-27",
  "createdBy": "string",
  "installation": {
    "houseSerialNumber": 0
  },
  "propertyOwnerDeclaration": {
    "propertyOwnerRole": "TENANT",
    "residentialUnit": "ONE",
    "email": "user@example.com",
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
      "phoneNumber": {
        "countryCode": "string",
        "areaCode": "string",
        "number": "string"
      }
    }
  },
  "contactPersons": [
    {
      "type": "string",
      "siebelRowId": "string",
      "salutation": "string",
      "firstName": "string",
      "lastName": "string",
      "email": "string"
      "phoneNumber": {
        "countryCode": "string",
        "areaCode": "strin",
        "number": "string"
      }
      "mobilePhoneNumber": {
        "countryCode": "string",
        "areaCode": "strin",
        "number": "string"
      }
    }
  ]
}
*/

        vj_body.put('customerNumber', piv_customernumber);
        vj_body.put('subCustomerNumber', to_number(piv_subcustomernumber));
        vj_body.put('siebelOrderNumber', piv_siebelordernumber);
        vj_body.put('siebelOrderRowId', piv_siebelorderrowid);
        vj_body.put('client', piv_client);
        vj_body.put('templateId', piv_templateid);
    --vj_body.put('expansionStatus', piv_expansionStatus);
   -- vj_body.put('availabilityDate' , piv_availabilityDate);
        vj_body.put('createdBy', piv_createdby);
        << installation >> declare
            vj_installation json_object_t := new json_object_t(c_empty_json);
        begin
            vj_installation.put('houseSerialNumber', to_number(piv_houseserialnumber));
        end;

        << propertyownerdeclaration >> declare
            vj_propertyownerdeclaration json_object_t := new json_object_t(c_empty_json);
        begin
            vj_propertyownerdeclaration.put('propertyOwnerRole', piv_propertyownerdeclaration_propertyownerrole);
            vj_propertyownerdeclaration.put('residentialUnit', piv_propertyownerdeclaration_residentialunit);
      --vj_propertyownerdeclaration.put('email'            , piv_propertyOwnerDeclaration_landlord_email);

            if piv_gee_kontaktdaten_bekannt = 1 then
                declare
                    vj_landlord             json_object_t := new json_object_t(c_empty_json);
                    vj_landlord_address     json_object_t := new json_object_t(c_empty_json);
                    vj_landlord_phonenumber json_object_t := new json_object_t(c_empty_json);
                    vj_landlord_name        json_object_t := new json_object_t(c_empty_json);
                begin
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
                    vj_landlord_phonenumber.put('areaCode', piv_propertyownerdeclaration_landlord_phonenumber_areacode);
                    vj_landlord_phonenumber.put('number', piv_propertyownerdeclaration_landlord_phonenumber_number);
                    vj_landlord.put('phoneNumber', vj_landlord_phonenumber);
                    vj_propertyownerdeclaration.put('landlord', vj_landlord);
                end; -- Eigentuemerdaten erforderlich
            end if;

            vj_body.put('propertyOwnerDeclaration', vj_propertyownerdeclaration);
        end propertyownerdeclaration;

        << installation >> declare
            vj_installation json_object_t := new json_object_t(c_empty_json);
        begin
            vj_installation.put('houseSerialNumber', to_number(piv_houseserialnumber));
            vj_body.put('installation', vj_installation);
        end installation;

        << contactpersons >> declare
            vj_contactpersons    json_array_t := new json_array_t();
            vj_contactperson     json_object_t := new json_object_t(c_empty_json);
            vj_phonenumber       json_object_t := new json_object_t(c_empty_json);
            vj_mobilephonenumber json_object_t := new json_object_t(c_empty_json);
            vj_name              json_object_t := new json_object_t(c_empty_json);
        begin

      -- Schleife über die Collection
            for i in 1..piv_contactpersons.count loop
                vj_contactperson.put('type',
                                     piv_contactpersons(i).contact_type);
                vj_contactperson.put('siebelRowId',
                                     piv_contactpersons(i).siebelrowid);
                vj_contactperson.put('salutation',
                                     piv_contactpersons(i).salutation);
                vj_name.put('first',
                            piv_contactpersons(i).firstname);
                vj_name.put('last',
                            piv_contactpersons(i).lastname);
                vj_contactperson.put('name', vj_name);
                vj_contactperson.put('email',
                                     piv_contactpersons(i).email);
                vj_phonenumber.put('countryCode',
                                   piv_contactpersons(i).phonenumber_countrycode);
                vj_phonenumber.put('areaCode',
                                   piv_contactpersons(i).phonenumber_areacode);
                vj_phonenumber.put('number',
                                   piv_contactpersons(i).phonenumber_number);
                vj_contactperson.put('landlinePhoneNumber', vj_phonenumber);
                vj_mobilephonenumber.put('countryCode',
                                         piv_contactpersons(i).mobilephonenumber_countrycode);
                vj_mobilephonenumber.put('areaCode',
                                         piv_contactpersons(i).mobilephonenumber_areacode);
                vj_mobilephonenumber.put('number',
                                         piv_contactpersons(i).mobilephonenumber_number);
                vj_contactperson.put('mobilePhoneNumber', vj_mobilephonenumber);
                vj_contactpersons.append(vj_contactperson);
            end loop;

            vj_body.put('contactPersons', vj_contactpersons);
        end contactpersons;

        return vj_body.to_clob();
    end fj_gk_order;

--------------------------------------------------------------------------------------------------- 

    function fn_gk_vorbestellung (
        piv_app_user                         in varchar2,
        piv_gee_kontaktdaten_bekannt         in varchar2, -- 1|0
        piv_customernumber                   in varchar2,
        piv_subcustomernumber                in varchar2,
        piv_siebelordernumber                in varchar2,
        piv_siebelorderrowid                 in varchar2,
        piv_client                           in varchar2,
        piv_templateid                       in varchar2,-- ftth-connectivity-100-50
                                  --piv_expansionStatus                                        IN VARCHAR2,--AREA_PLANNED
        piv_availabilitydate                 in varchar2,--2025-11-27
        piv_createdby                        in varchar2,
        piv_houseserialnumber                in varchar2,
        piv_propertyownerrole                in varchar2,
        piv_residentialunit                  in varchar2,
        piv_landlord_legalform               in varchar2,
        piv_landlord_businessorname          in varchar2,
        piv_landlord_salutation              in varchar2,
        piv_landlord_title                   in varchar2,
        piv_landlord_name_first              in varchar2,
        piv_landlord_name_last               in varchar2,
        piv_landlord_address_street          in varchar2,
        piv_landlord_address_housenumber     in varchar2,
        piv_landlord_address_zipcode         in varchar2,
        piv_landlord_address_city            in varchar2,
        piv_landlord_address_postaladdition  in varchar2,
        piv_landlord_address_country         in varchar2,
        piv_landlord_email                   in varchar2,
        piv_landlord_phonenumber_countrycode in varchar2,
        piv_landlord_phonenumber_areacode    in varchar2,
        piv_landlord_phonenumber_number      in varchar2,
        piv_contactpersons                   in t_contact_persons
/*
                                  piv_landlord_contactPersons_type                           IN VARCHAR2,
                                  piv_landlord_contactPersons_siebelRowId                    IN VARCHAR2,
                                  piv_landlord_contactPersons_salutation                     IN VARCHAR2,
                                  piv_landlord_contactPersons_firstName                      IN VARCHAR2,
                                  piv_landlord_contactPersons_lastName                       IN VARCHAR2,
                                  piv_landlord_contactPersons_phoneNumber_countryCode        IN VARCHAR2,
                                  piv_landlord_contactPersons_phoneNumber_areaCode           IN VARCHAR2,
                                  piv_landlord_contactPersons_phoneNumber_number             IN VARCHAR2,
                                  piv_landlord_contactPersons_mobilePhoneNumber_countryCode  IN VARCHAR2,
                                  piv_landlord_contactPersons_mobilePhoneNumber_areaCode     IN VARCHAR2,
                                  piv_landlord_contactPersons_mobilePhoneNumber_number       IN VARCHAR2,
                                  piv_landlord_contactPersons_email                          IN VARCHAR2
                                  */
    ) return ftth_ws_sync_preorders.id%type is

        vj_internal_order_gk clob;
        v_webservice_log_id  ftth_webservice_aufrufe.id%type; -- für den Fall, dass der Auftrag nicht erfolgreich vom Webserver
                                                         -- verarbeitet wird, können mit dieser ID die gesendeten Daten
                                                         -- ausgelesen werden
        v_uuid               ftth_ws_sync_preorders.id%type;

-- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name      constant logs.routine_name%type := 'fn_gk_vorbestellung';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_gee_kontaktdaten_bekannt', piv_gee_kontaktdaten_bekannt);
            pck_format.p_add('piv_customernumber', piv_customernumber);
            pck_format.p_add('piv_subCustomerNumber', piv_subcustomernumber);
            pck_format.p_add('piv_siebelOrderNumber', piv_siebelordernumber);
            pck_format.p_add('piv_siebelOrderRowId', piv_siebelorderrowid);
            pck_format.p_add('piv_client', piv_client);
            pck_format.p_add('piv_templateId', piv_templateid);
      --pck_format.p_add('piv_expansionStatus'                                      , piv_expansionStatus);
            pck_format.p_add('piv_availabilityDate', piv_availabilitydate);
            pck_format.p_add('piv_createdBy', piv_createdby);
            pck_format.p_add('piv_houseSerialNumber', piv_houseserialnumber);
            pck_format.p_add('piv_propertyOwnerRole', piv_propertyownerrole);
            pck_format.p_add('piv_residentialUnit', piv_residentialunit);
            pck_format.p_add('piv_landlord_legalForm', piv_landlord_legalform);
            pck_format.p_add('piv_landlord_businessOrName', piv_landlord_businessorname);
            pck_format.p_add('piv_landlord_salutation', piv_landlord_salutation);
            pck_format.p_add('piv_landlord_title', piv_landlord_title);
            pck_format.p_add('piv_landlord_name_first', piv_landlord_name_first);
            pck_format.p_add('piv_landlord_name_last', piv_landlord_name_last);
            pck_format.p_add('piv_landlord_address_street', piv_landlord_address_street);
            pck_format.p_add('piv_landlord_address_houseNumber', piv_landlord_address_housenumber);
            pck_format.p_add('piv_landlord_address_zipCode', piv_landlord_address_zipcode);
            pck_format.p_add('piv_landlord_address_city', piv_landlord_address_city);
            pck_format.p_add('piv_landlord_address_postalAddition', piv_landlord_address_postaladdition);
            pck_format.p_add('piv_landlord_address_country', piv_landlord_address_country);
            pck_format.p_add('piv_landlord_email', piv_landlord_email);
            pck_format.p_add('piv_landlord_phoneNumber_countryCode', piv_landlord_phonenumber_countrycode);
            pck_format.p_add('piv_landlord_phoneNumber_areaCode', piv_landlord_phonenumber_areacode);
            pck_format.p_add('piv_landlord_phoneNumber_number', piv_landlord_phonenumber_number);
/*
      pck_format.p_add('piv_landlord_contactPersons_type'                         , piv_landlord_contactPersons_type);
      pck_format.p_add('piv_landlord_contactPersons_siebelRowId'                  , piv_landlord_contactPersons_siebelRowId);
      pck_format.p_add('piv_landlord_contactPersons_salutation'                   , piv_landlord_contactPersons_salutation);
      pck_format.p_add('piv_landlord_contactPersons_firstName'                    , piv_landlord_contactPersons_firstName);
      pck_format.p_add('piv_landlord_contactPersons_lastName'                     , piv_landlord_contactPersons_lastName);
      pck_format.p_add('piv_landlord_contactPersons_phoneNumber_countryCode'      , piv_landlord_contactPersons_phoneNumber_countryCode);
      pck_format.p_add('piv_landlord_contactPersons_phoneNumber_areaCode'         , piv_landlord_contactPersons_phoneNumber_areaCode);
      pck_format.p_add('piv_landlord_contactPersons_phoneNumber_number'           , piv_landlord_contactPersons_phoneNumber_number);
      pck_format.p_add('piv_landlord_contactPersons_mobilePhoneNumber_countryCode', piv_landlord_contactPersons_mobilePhoneNumber_countryCode);
      pck_format.p_add('piv_landlord_contactPersons_mobilePhoneNumber_areaCode'   , piv_landlord_contactPersons_mobilePhoneNumber_areaCode);
      pck_format.p_add('piv_landlord_contactPersons_mobilePhoneNumber_number'     , piv_landlord_contactPersons_mobilePhoneNumber_number);
      pck_format.p_add('piv_landlord_contactPersons_email'                        , piv_landlord_contactPersons_email);
*/
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
-- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin

    -- Zuordnung zum Datensatz:
        vj_internal_order_gk := fj_gk_order(
            piv_gee_kontaktdaten_bekannt                                  => piv_gee_kontaktdaten_bekannt, -- 1|0
            piv_customernumber                                            => piv_customernumber,
            piv_subcustomernumber                                         => piv_subcustomernumber,
            piv_siebelordernumber                                         => piv_siebelordernumber,
            piv_siebelorderrowid                                          => piv_siebelorderrowid,
            piv_client                                                    => piv_client,
            piv_templateid                                                => piv_templateid,-- ftth-connectivity-100-50
        --piv_expansionStatus                                                                 => piv_expansionStatus,--AREA_PLANNED
            piv_availabilitydate                                          => piv_availabilitydate,--2025-11-27
            piv_createdby                                                 => piv_createdby,
            piv_houseserialnumber                                         => piv_houseserialnumber,
            piv_propertyownerdeclaration_propertyownerrole                => piv_propertyownerrole,
            piv_propertyownerdeclaration_residentialunit                  => piv_residentialunit,
            piv_propertyownerdeclaration_landlord_legalform               => piv_landlord_legalform,
            piv_propertyownerdeclaration_landlord_businessorname          => piv_landlord_businessorname,
            piv_propertyownerdeclaration_landlord_salutation              => piv_landlord_salutation,
            piv_propertyownerdeclaration_landlord_title                   => piv_landlord_title,
            piv_propertyownerdeclaration_landlord_name_first              => piv_landlord_name_first,
            piv_propertyownerdeclaration_landlord_name_last               => piv_landlord_name_last,
            piv_propertyownerdeclaration_landlord_address_street          => piv_landlord_address_street,
            piv_propertyownerdeclaration_landlord_address_housenumber     => piv_landlord_address_housenumber,
            piv_propertyownerdeclaration_landlord_address_zipcode         => piv_landlord_address_zipcode,
            piv_propertyownerdeclaration_landlord_address_city            => piv_landlord_address_city,
            piv_propertyownerdeclaration_landlord_address_postaladdition  => piv_landlord_address_postaladdition,
            piv_propertyownerdeclaration_landlord_address_country         => piv_landlord_address_country,
            piv_propertyownerdeclaration_landlord_email                   => piv_landlord_email,
            piv_propertyownerdeclaration_landlord_phonenumber_countrycode => piv_landlord_phonenumber_countrycode,
            piv_propertyownerdeclaration_landlord_phonenumber_areacode    => piv_landlord_phonenumber_areacode,
            piv_propertyownerdeclaration_landlord_phonenumber_number      => piv_landlord_phonenumber_number,
            piv_contactpersons                                            => piv_contactpersons
/*
piv_propertyOwnerDeclaration_landlord_contactPersons_type                           => piv_landlord_contactPersons_type,
        piv_propertyOwnerDeclaration_landlord_contactPersons_siebelRowId                    => piv_landlord_contactPersons_siebelRowId,
        piv_propertyOwnerDeclaration_landlord_contactPersons_salutation                     => piv_landlord_contactPersons_salutation,
        piv_propertyOwnerDeclaration_landlord_contactPersons_firstName                      => piv_landlord_contactPersons_firstName,
        piv_propertyOwnerDeclaration_landlord_contactPersons_lastName                       => piv_landlord_contactPersons_lastName,
        piv_propertyOwnerDeclaration_landlord_contactPersons_phoneNumber_countryCode        => piv_landlord_contactPersons_phoneNumber_countryCode,
        piv_propertyOwnerDeclaration_landlord_contactPersons_phoneNumber_areaCode           => piv_landlord_contactPersons_phoneNumber_areaCode,
        piv_propertyOwnerDeclaration_landlord_contactPersons_phoneNumber_number             => piv_landlord_contactPersons_phoneNumber_number,
        piv_propertyOwnerDeclaration_landlord_contactPersons_mobilePhoneNumber_countryCode  => piv_landlord_contactPersons_mobilePhoneNumber_countryCode,
        piv_propertyOwnerDeclaration_landlord_contactPersons_mobilePhoneNumber_areaCode     => piv_landlord_contactPersons_mobilePhoneNumber_areaCode,
        piv_propertyOwnerDeclaration_landlord_contactPersons_mobilePhoneNumber_number       => piv_landlord_contactPersons_mobilePhoneNumber_number,
        piv_propertyOwnerDeclaration_landlord_contactPersons_email                          => piv_landlord_contactPersons_email
   */
        );

    -- Auftrag zum Webservice senden und sofort die neue orderId zurückerhalten:

        v_uuid := pck_pob_rest.fn_internal_order_gk_post(
            piv_kontext  => pck_pob_rest.kontext_preorderbuffer,
            piv_app_user => piv_app_user,
            pic_body     => vj_internal_order_gk
        );

  --v_uuid := 2;
        pck_logs.p_error(
            pic_message      => vj_internal_order_gk,
            piv_routine_name => cv_routine_name,
            piv_scope        => g_scope
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

    end fn_gk_vorbestellung;

--------------------------------------------------------------------------------------------------- 

    function fp_funnel_gk (
        pid_von in date default null,
        pid_bis in date default null,
        piv_vkz in varchar2 default null
    ) return t_gk_funnels
        pipelined
    is
        n_anz_target number;
        n_target     number;
    begin
        for item in (
            select
                pos_calc,
                l,
                sum(anzahl_calc)   anz,
                sum(anzahl_target) anz_target
            from
                (
                    select
                        pos,
                        anzahl,
                        case pos
                            when 500 then
                                400
                            else
                                pos
                        end pos_calc,
                        case coalesce(d0, d2, d3, d5)
                            when 'Eigentümerdaten nicht notwendig' then
                                0
                            when 'Eigentümerdaten aufgerufen'      then
                                anzahl
                            when 'Eigentümerdaten notwendig'       then
                                0
                            else
                                anzahl
                        end anzahl_calc,
                        case coalesce(d0, d2, d3, d5)
                            when 'Eigentümerdaten nicht notwendig' then
                                'Eigentümerdaten aufgerufen'
                            when 'Eigentümerdaten aufgerufen'      then
                                'Eigentümerdaten aufgerufen'
                            when 'Eigentümerdaten notwendig'       then
                                'Eigentümerdaten aufgerufen'
                            else
                                coalesce(d0, d2, d3, d5)
                        end l,
                        case coalesce(d0, d2, d3, d5)
                            when 'Eigentümerdaten nicht notwendig' then
                                0
                            when 'Eigentümerdaten aufgerufen'      then
                                0
                            when 'Eigentümerdaten notwendig'       then
                                anzahl
                            else
                                anzahl
                        end anzahl_target
                    from
                        table ( pck_glascontainer_order_gk.fp_order_tracking2(pid_von, pid_bis, piv_vkz) )
                    where
                        pos in ( 10, 300, 400, 500, 1010 )
                    order by
                        pos
                )
            group by
                pos_calc,
                l
        ) loop
            if ( item.pos_calc = 10 ) then
                n_anz_target := item.anz;
            end if;

            if ( item.pos_calc = 400 ) then
                n_target := item.anz;
            else
                n_target := n_anz_target;
            end if;

            pipe row ( new t_gk_funnel(
                pos           => item.pos_calc,
                anzahl        => item.anz,
                anzahl_target => n_target,
                l             => item.l
            ) );

        end loop;
    end fp_funnel_gk;

end pck_glascontainer_order_gk;
/


-- sqlcl_snapshot {"hash":"6876cd39cdf63be2b8d33a674f1a67264ef1ef64","type":"PACKAGE_BODY","name":"PCK_GLASCONTAINER_ORDER_GK","schemaName":"ROMA_MAIN","sxml":""}