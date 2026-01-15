create or replace package body roma_main.pck_vermarktungscluster as
/**
 * @creation 2023-05
 *
 * @author WISAND  <wismann@when-others.com> 
 *
 * @usage Vor jeglichen Änderungen an diesem Package unbedingt prüfen, ob alle
 *        Unit-Tests im Vorhinein erfolgreich sind:
 *        SELECT * FROM TABLE(ut.run('UT_VERMARKTUNGSCLUSTER')); 
 *
 * @pre-condition  Es besteht kein Unique Key auf VERMARKTUNGSCLUSTER_OBJEKT.HAUS_LFD_NR:
 *                 Dieser ist nun angelegt und muss deployed werden! 
 *                 Ein Objekt kann bisher (technisch) mehreren Vermarktungsclustern zugeordnet sein.
 */

  -- Umlaute/Euro-Zeichen: ÄÖÜäöüß?
    body_version     constant varchar2(30) := '2025-04-16 1030';
    g_application    constant apex_applications.application_id%type := 1210;
    monitoring_aktiv constant boolean := true;
  -- In diesem Package verwendete APEX Collections:
    aktionsliste     constant apex_collections.collection_name%type := 'AKTIONSLISTE';
    checked          constant apex_collections.n002%type := 1; -- der Wert für eine angehakte Checkbox
    not_checked      constant apex_collections.n002%type := 0; -- der Wert für eine nicht angehakte Checkbox (bitte beachten:
                                                        -- aus Effizienzgründen sollten Datensätze mit nicht angehakter Checkbox
                                                        -- aus der Collection GELÖSCHT werden, aber es funktioniert ebenfalls
                                                        -- (nur eben langsamer) mit dem Speichern des Wertes 0

    c_datei_leer     constant integer := -20987;
    e_datei_leer exception;
    pragma exception_init ( e_datei_leer, -20987 );

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
 * Löscht alle Collections, deren Namen mit dem übergebenen LIKE-Muster übereinstimmen
 *
 * @param piv_collection_name_like   Suchmuster für den Collection-Namen, beispielsweise 'P4%'
 */
    procedure p_reset_alle_collections (
        piv_collection_name_like in varchar2
    ) is
    begin
        for coll in (
            select
                collection_name
            from
                apex_collections
            where
                collection_name like piv_collection_name_like
        ) loop
            begin
                apex_collection.delete_collection(coll.collection_name);
            exception
                when others then
                    null;
            end;
        end loop;

        apex_collection.create_or_truncate_collection(pck_vermarktungscluster.collection_p4_checkbox);
    end;



/**
 * Ordnet alle in der Collection P4_CHECKBOX angehakten HAUS_LFD_NRn 
 * dem Vermarktungscluster zu
 *
 * @ticket FTTH-1787: Wenn der Vermarktungscluster UNDERCONSTRUCTION ist, 
 * müssen die HAUS_LFD_NRn zuvor an den Webservice geschickt werden @ticket FTTH-1891, @ticket FTTH-1972
 *
 * @exception  Wenn die Auswahl leer ist und folglich keine Zuordnung stattfindet,
 *             wird eine User Defined Exception ausgegeben, damit APEX dies
 *             als Benutzerhinweis darstellen kann.
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
    ) is

        v_zaehler       naturaln := 0;
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'auswahl_zuordnen';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_vc_lfd_nr', pin_vc_lfd_nr);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        for c in (
            select
                n001 as haus_lfd_nr
            from
                apex_collections
            where
                    collection_name = collection_p4_checkbox
                and n002 = 1
            order by
                1
        ) loop
            v_zaehler := 1 + v_zaehler;
            p_objekt_zuordnen(
                pin_haus_lfd_nr => c.haus_lfd_nr,
                pin_vc_lfd_nr   => pin_vc_lfd_nr,
                pin_modus       => c_modus_alternativ
            );

        end loop;

        if v_zaehler = 0 then
            raise_application_error(c_plausi_error_number, 'Sie haben keine Adressen ausgewählt');
        end if;
    exception
        when others then
            if sqlcode <> c_plausi_error_number then
                pck_logs.p_error(
                    pic_message      => fcl_params(),
                    piv_routine_name => cv_routine_name,
                    piv_scope        => g_scope
                );
            end if;

            raise;
    end auswahl_zuordnen;
/**
 * Ordnet einem Vermarktungscluster alle Objekte des ausgewählten Gebiets zu
 *
 * @param pin_vc_lfd_nr  ID des Vermarktungsclusters, dem die Objekte zugeordnet werden sollen
 * @param piv_gebiet     Auswahl in der Selectliste "Ausbaugebiet" (kann nicht gleichzeitig mit piv_typ gesetzt werden)
 * @param piv_typ        Auswahl in der Selectliste "Ausbaugebiet Typ" (kann nicht gleichzeitig mit piv_gebiet gesetzt werden)
 *
 * @return  Im Modus "ZAEHLEN" wird die Anzahl der zuordenbaren Objekte zurückgegeben,
 *          ansonsten
 * @usage Benutzer klickt in 1210:4 auf den Button "Komplettes Gebiet zuordnen"
 */
    function komplettes_gebiet_zuordnen (
        pin_vc_lfd_nr in vermarktungscluster.vc_lfd_nr%type,
        piv_gebiet    in strav.gebiet.gebiet%type,
        piv_typ       in strav.gebiet.typ%type
    ) return natural is

        v_counter       naturaln := 0;
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'komplettes_gebiet_zuordnen';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_vc_lfd_nr', pin_vc_lfd_nr);
            pck_format.p_add('piv_gebiet', piv_gebiet);
            pck_format.p_add('piv_typ', piv_typ);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------       
    begin
        if
            piv_gebiet is null
            and piv_typ is null
        then
            raise_application_error(c_plausi_error_number, 'Angabe zum Gebiet oder zum Typ fehlt');
        end if;

        if
            piv_gebiet is not null
            and piv_typ is not null
        then
            raise_application_error(c_plausi_error_number, 'Es kann nicht zugleich nach Gebiet und Gebietstyp gesucht werden');
        end if;

        for c in (
            select
                haus.haus_lfd_nr
            from
                     strav.haus
                join strav.haus_gebiet on ( haus.haus_lfd_nr = haus_gebiet.haus_lfd_nr )
                left join strav.gebiet on gebiet.id = haus_gebiet.gebiet_id
            where
                ( gebiet_id = piv_gebiet
                  or gebiet.typ = piv_typ ) -- gebiet.typ war bisher nicht Bestandteil der Selektion
               -- nicht zuordnen, was sowieso bereits zugeordnet ist:
                and haus.haus_lfd_nr not in (
                    select
                        haus_lfd_nr
                    from
                        vermarktungscluster_objekt
                    where
                        vc_lfd_nr = pin_vc_lfd_nr
                )
            union -- Smallworld:
            select
                haus.haus_lfd_nr
            from
                     strav.haus
                join sw_ausbaugebiet_objekt@geswp.netcologne.intern@sw$admin ago on ( ago.haus_lfd_nr = haus.haus_lfd_nr )
                join sw_ausbaugebiet@geswp.netcologne.intern@sw$admin        ag on ( ag.id = ago.id )
              -- 2022-11-30 neu
                left join tab_ausbaugebiet_typ@geswp.netcologne.intern@sw$admin   t on ( t.ausbgbttp_id = ag.ausbgbttp_id )
            where
                ( ag.id = piv_gebiet
                  or t.ausbgbttp_bez = piv_typ )
                and haus.haus_lfd_nr not in (
                    select
                        haus_lfd_nr
                    from
                        vermarktungscluster_objekt
                    where
                        vc_lfd_nr = pin_vc_lfd_nr
                )
        ) loop
            p_objekt_zuordnen(
                pin_haus_lfd_nr => c.haus_lfd_nr,
                pin_vc_lfd_nr   => pin_vc_lfd_nr,
                pin_modus       => c_modus_alternativ
            );

            v_counter := 1 + v_counter;
        end loop;

        return v_counter;
    exception
        when others then
            if sqlcode <> c_plausi_error_number then
                pck_logs.p_error(
                    pic_message      => fcl_params(),
                    piv_routine_name => cv_routine_name,
                    piv_scope        => g_scope
                );
            end if;

            raise;
    end;

/**
 * Gibt einen Hashwert aus bis zu 5 Parametern zurück, Länge 32 Zeichen. 
 * Wenn alle Eingangsparameter NULL sind, wird NULL zurückgegeben.
 */
    function fv_parameter_hash (
        piv_1 in varchar2 default null,
        piv_2 in varchar2 default null,
        piv_3 in varchar2 default null,
        piv_4 in varchar2 default null,
        piv_5 in varchar2 default null
    ) return varchar2 is
        sep    constant varchar2(1) := '|';
        v_hash varchar2(32);
    begin
        if
            piv_1 is null
            and piv_2 is null
            and piv_3 is null
            and piv_4 is null
            and piv_5 is null
        then
            return null;
        end if;

        select
            substr(
                standard_hash( -- ist leider nur eine SQL-Funktion
                piv_1
                              || sep
                              || piv_2
                              || sep
                              || piv_3
                              || sep
                              || piv_4
                              || sep
                              || piv_5, 'MD5'),
                1,
                32
            )
        into v_hash
        from
            dual;

        return v_hash;
    end;
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
    ) is

        n_gefunden      naturaln := 0;
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'asp_set_checkbox';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_collection_name', piv_collection_name);
            pck_format.p_add('pin_key', pin_key);
            pck_format.p_add('pin_checked', pin_checked);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------     
    begin
        for c in ( -- leider liefert die Abfrage im Report die HAUS_LFD_NR nicht eindeutig als PK des Reports,
        -- daher muss geloopt werden)
            select
                seq_id
            from
                apex_collections
            where
                    collection_name = piv_collection_name
                and n001 = pin_key
        ) loop
        -- User hat bestehendes Häkchen geändert:
            n_gefunden := 1 + n_gefunden;
            if nvl(pin_checked, 0) = 1 then
                apex_collection.update_member_attribute(
                    p_collection_name => piv_collection_name,
                    p_seq             => c.seq_id,
                    p_attr_number     => 2,
                    p_number_value    => pin_checked
                );

            else -- 2022-11-17: Die nicht angehakten Zeilen werden nun in der Collection gelöscht anstatt aktualisiert, 
         -- weil sonst der Report stetig steigende Pagination-Höchstwerte ermittelt
                apex_collection.delete_member(
                    p_collection_name => piv_collection_name,
                    p_seq             => c.seq_id
                );
            end if;

        end loop;

        if n_gefunden = 0 then
         -- User hat erstmals auf diese Zeile geklickt:
            apex_collection.add_member(
                p_collection_name => piv_collection_name,
                p_n001            => pin_key,
                p_n002            => pin_checked
            );

        end if;

    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end;

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
    ) is

        v_keys               clob;
        v_c001               apex_application_global.vc_arr2;
        n_n001               apex_application_global.n_arr;
        n_n002               apex_application_global.n_arr;
        n_anzahl_neue_zeilen naturaln := 0;
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name      constant logs.routine_name%type := 'asp_set_checkboxes';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_collection_name', piv_collection_name);
            pck_format.p_add('pin_checked', pin_checked);
            pck_format.p_add('pin_keys', pin_keys);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        if pin_keys is null then
            return;
        end if;
        for c in (
            with objekte as (
                select /*+MATERIALIZE*/ distinct
                    column_value as haus_lfd_nr
                from
                    table ( apex_string.split_numbers(pin_keys, ',') )
            ), checkboxen as (
                select
                    seq_id,
                    n001
                from
                    apex_collections
                where
                        collection_name = piv_collection_name
                   -- fachliche Schlüssel filtern (leider ist N001 als Collection-Spalte nicht indizierbar)
                    and n001 in (
                        select
                            haus_lfd_nr
                        from
                            objekte
                    )
            )
            select
                seq_id,
                haus_lfd_nr
            from
                objekte
                left join checkboxen on ( objekte.haus_lfd_nr = checkboxen.n001 )
        ) loop

            -- @@2022-11-17 @weiter: Algorithmus optimieren, indem zunächst der Unterschied bei pin_checked gemacht wird!

            if c.seq_id is null then -- Zeile ist momentan nicht angehakt:
            -- In Array speichern und nach dem Loop mit ADD_MEMBERS im bulk erzeugen:
                n_anzahl_neue_zeilen := 1 + n_anzahl_neue_zeilen;
                v_c001(n_anzahl_neue_zeilen) := null; -- wird von der API nur zum Zählen benötigt, Inhalt = leer
                n_n001(n_anzahl_neue_zeilen) := c.haus_lfd_nr;
                n_n002(n_anzahl_neue_zeilen) := pin_checked;
            else --es besteht bereits eine Angehakt-Zeile:
                if pin_checked = 1 then --  @deprecated: sollte nicht mehr auftreten,
                    apex_collection.update_member_attribute(
                        p_collection_name => piv_collection_name,
                        p_seq             => c.seq_id,
                        p_attr_number     => 2,
                        p_number_value    => pin_checked
                    );

                else -- 2022-11-17, ... da wir ja ab heute die nicht mehr angehakten sofort löschen!
                    apex_collection.delete_member(
                        p_collection_name => piv_collection_name,
                        p_seq             => c.seq_id
                    );
                end if;
            end if;
        end loop;

        if
            pin_checked = 1
            and n_anzahl_neue_zeilen > 0
        then
            apex_collection.add_members(
                p_collection_name => piv_collection_name,
                p_c001            => v_c001,
                p_n001            => n_n001,
                p_n002            => n_n002
            );
        end if;

    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end;

/**
 * Setzt alle Auswahl-Häkchen für die in den _keys_-Parametern aufgelisteten Schlüssel
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
    ) is
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'asp_header_checked';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_collection_name', piv_collection_name);
            pck_format.p_add('pin_keys_1', pin_keys_1);
            pck_format.p_add('pin_keys_2', pin_keys_2);
            pck_format.p_add('pin_keys_3', pin_keys_3);
            pck_format.p_add('pin_keys_4', pin_keys_4);
            pck_format.p_add('pin_keys_5', pin_keys_5);
            pck_format.p_add('pin_keys_6', pin_keys_6);
            pck_format.p_add('pin_keys_7', pin_keys_7);
            pck_format.p_add('pin_keys_8', pin_keys_8);
            pck_format.p_add('pin_keys_9', pin_keys_9);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        if pin_keys_1 is not null then
            asp_set_checkboxes(piv_collection_name, checked, pin_keys_1);
        end if;
        if pin_keys_2 is not null then
            asp_set_checkboxes(piv_collection_name, checked, pin_keys_2);
        end if;
        if pin_keys_3 is not null then
            asp_set_checkboxes(piv_collection_name, checked, pin_keys_3);
        end if;
        if pin_keys_4 is not null then
            asp_set_checkboxes(piv_collection_name, checked, pin_keys_4);
        end if;
        if pin_keys_5 is not null then
            asp_set_checkboxes(piv_collection_name, checked, pin_keys_5);
        end if;
        if pin_keys_6 is not null then
            asp_set_checkboxes(piv_collection_name, checked, pin_keys_6);
        end if;
        if pin_keys_7 is not null then
            asp_set_checkboxes(piv_collection_name, checked, pin_keys_7);
        end if;
        if pin_keys_8 is not null then
            asp_set_checkboxes(piv_collection_name, checked, pin_keys_8);
        end if;
        if pin_keys_9 is not null then
            asp_set_checkboxes(piv_collection_name, checked, pin_keys_9);
        end if;
        if pin_keys_10 is not null then
            asp_set_checkboxes(piv_collection_name, checked, pin_keys_10);
        end if;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end;    

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
    ) is
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'asp_header_not_checked';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_collection_name', piv_collection_name);
            pck_format.p_add('pin_keys_1', pin_keys_1);
            pck_format.p_add('pin_keys_2', pin_keys_2);
            pck_format.p_add('pin_keys_3', pin_keys_3);
            pck_format.p_add('pin_keys_4', pin_keys_4);
            pck_format.p_add('pin_keys_5', pin_keys_5);
            pck_format.p_add('pin_keys_6', pin_keys_6);
            pck_format.p_add('pin_keys_7', pin_keys_7);
            pck_format.p_add('pin_keys_8', pin_keys_8);
            pck_format.p_add('pin_keys_9', pin_keys_9);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        if pin_keys_1 is not null then
            asp_set_checkboxes(piv_collection_name, not_checked, pin_keys_1);
        end if;
        if pin_keys_2 is not null then
            asp_set_checkboxes(piv_collection_name, not_checked, pin_keys_2);
        end if;
        if pin_keys_3 is not null then
            asp_set_checkboxes(piv_collection_name, not_checked, pin_keys_3);
        end if;
        if pin_keys_4 is not null then
            asp_set_checkboxes(piv_collection_name, not_checked, pin_keys_4);
        end if;
        if pin_keys_5 is not null then
            asp_set_checkboxes(piv_collection_name, not_checked, pin_keys_5);
        end if;
        if pin_keys_6 is not null then
            asp_set_checkboxes(piv_collection_name, not_checked, pin_keys_6);
        end if;
        if pin_keys_7 is not null then
            asp_set_checkboxes(piv_collection_name, not_checked, pin_keys_7);
        end if;
        if pin_keys_8 is not null then
            asp_set_checkboxes(piv_collection_name, not_checked, pin_keys_8);
        end if;
        if pin_keys_9 is not null then
            asp_set_checkboxes(piv_collection_name, not_checked, pin_keys_9);
        end if;
        if pin_keys_10 is not null then
            asp_set_checkboxes(piv_collection_name, not_checked, pin_keys_10);
        end if;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end;    

/**    
 * Liefert den SQL-Abfragestring für den Report auf Seite 4 zurück
 *
 * @param pin_ausbaugebiet       ID des Gebiets, falls ausgewählt (zu befüllen mit P4_SEARCH_GEBIET) 
 * @param piv_ausbaugebiet_typ   Name des Ausbaugebiet-Typs (nicht weiter dokumentiert, zu befüllen mit P4_SEARCH_TYP) 
 * @param piv_adresse            Inhalt des Eingabefeldes "Adresssuche" (zu befüllen mit P4_SEARCH_ALL)
 * @param pin_vc_lfd_nr          (optional) ID des Vermarktungsclusters, dem die Adressen zugeordnet werden sollen 
 * @param pib_auswahl_bearbeiten (optional) wenn TRUE, zeigt der Report nur die bereits ausgewählten Adressen an
 *                               und ignoriert die übergebenen Filter-Parameter (piv_search_all etc.)
 *
 * @usage Der String war bisher in APEX hinterlegt, nicht dokumentiert.
 * @ticket FTTH-5143: Umbau auf V_ADRESSEN und angepasste Adressfelder
 */
    function fv_query_p4 (
        pin_ausbaugebiet     in varchar2,
        piv_ausbaugebiet_typ in varchar2,
        piv_adresse          in varchar2,
        pin_vc_lfd_nr        in vermarktungscluster.vc_lfd_nr%type default null,
        pib_skip_checkboxes  in boolean default null
    ) return varchar2 is

        use_checkboxes       constant boolean := nvl(not pib_skip_checkboxes, true);
        use_adresssuche      constant boolean := trim(piv_adresse) is not null;
        use_ausbaugebiet     constant boolean := nvl(pin_ausbaugebiet, 0) <> 0;         -- Der "NULL Return Value" in APEX ist inzwischen NULL anstatt 0
        use_ausbaugebiet_typ constant boolean := nvl(piv_ausbaugebiet_typ, '0') <> '0'; -- Der "NULL Return Value" in APEX ist inzwischen NULL anstatt 0
        use_db_links         constant boolean := true
        or use_adresssuche
        or upper(piv_ausbaugebiet_typ) = 'ADMINISTRATION';
        v_query              varchar2(32767);
-- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name      constant logs.routine_name%type := 'fv_query_p4';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_ausbaugebiet', pin_ausbaugebiet);
            pck_format.p_add('piv_ausbaugebiet_typ', piv_ausbaugebiet_typ);
            pck_format.p_add('piv_adresse', piv_adresse);
            pck_format.p_add('pin_vc_lfd_nr', pin_vc_lfd_nr);
            pck_format.p_add('pib_skip_checkboxes', pib_skip_checkboxes);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
-- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        v_query :=
            case
                when use_checkboxes then
----------------
                    'WITH CHECKBOXES AS (SELECT SEQ_ID, N001, N002 FROM APEX_COLLECTIONS WHERE COLLECTION_NAME='''
                    || collection_p4_checkbox
                    || ''')'
                    ||
----------------        
    -- "BEREITS_ZUGEORDNET" bedeutet im Gegensatz zur früheren Version, dass eine Zuordnung
    -- zu genau demjenigen Cluster besteht, das oben im Formular angezeigt wird (nicht "zu irgendeinem" wie früher,
    -- denn diese Frage lässt sich ja bereits mit der Spalte VERMARKTUNGSCLUSTER beantworten)
                     '
    SELECT '
                    || 'CASE WHEN NVL(bereits_zugeordnet, 0) = 0 THEN APEX_ITEM.CHECKBOX2(p_idx=>1,p_value=>haus_lfd_nr,'
                    || -- p_item_id=>''checkbox_'' || haus_lfd_nr,
                     'p_attributes=>''class="checkbox--ir"''' 
----------------
                    || '|| CASE WHEN NVL(CHECKBOXES.N002, 0) =1 THEN '' checked'' END'
                    ||
----------------
    -- Ist die Adresse bereits zugeordnet, wird statt der Checkbox ein Golfplatz-Fähnchen angezeigt:
                     ') ELSE ''<span class="noCheckbox fa fa-flag-swallowtail"/>'' END AS CHECKBOX_AUSWAHL,'
                else 'SELECT' -- ohne Checkboxen-Option wird im SQL auf die erste Spalte ("CHECKBOX_AUSWAHL") komplett verzichtet
            end
            || ' gebiet,typ,id,ort_kompl,plz,str,hnr_kompl,gebaeudeteil_name,haus_lfd_nr,we_ges,dnsttp_bez,gee_status, gee_erteilt_am,
    bereits_zugeordnet,termin,ausbaustatus,vermarktungscluster
    FROM (
    SELECT gebiet,typ,id,ort_kompl,plz,str,hnr_kompl,gebaeudeteil_name,haus_lfd_nr,we_ges,dnsttp_bez,gee_status, gee_erteilt_am,
    bereits_zugeordnet,termin,ausbaustatus,vermarktungscluster,
    dense_rank () over (PARTITION BY haus_lfd_nr ORDER BY x DESC) dr
    FROM (
    SELECT 1 x,
        g.gebiet, 
        g.typ, 
        g.id,
        a.ort,
        a.ort_kompl, 
        a.plz, 
        a.str,
        a.hnr,
        a.hnr_kompl,
        a.gebaeudeteil_name,
        a.haus_lfd_nr haus_lfd_nr,
        h.haus_we_ges we_ges,
        tdt.dnsttp_bez dnsttp_bez, 
        strav.pck_ems_query.fv_gee_status(pin_haus_lfd_nr=> h.haus_lfd_nr) gee_status, 
        strav.pck_ems_query.fd_gee_erteilt_am(pin_haus_lfd_nr=> h.haus_lfd_nr) gee_erteilt_am,
        case when vco.vc_lfd_nr = '
            || nvl(
            to_char(pin_vc_lfd_nr),
            ''''''
        )
            || ' then 1 end AS bereits_zugeordnet,
        (select bezeichnung from vermarktungscluster where vc_lfd_nr = vco.vc_lfd_nr ) AS vermarktungscluster,        
        hast.has_termin termin,
        hast.has_ausbau_status ausbaustatus
    FROM strav.haus                      h
    JOIN V_ADRESSEN                      a  ON (a.haus_lfd_nr = h.haus_lfd_nr)
    LEFT JOIN strav.haus_gebiet          hg   ON hg.haus_lfd_nr = h.haus_lfd_nr 
    LEFT JOIN strav.gebiet               g    ON g.id = hg.gebiet_id
    LEFT JOIN strav.haus_daten           hd   ON hd.haus_lfd_nr = h.haus_lfd_nr
    LEFT JOIN tab_dienst_typ             tdt  ON tdt.dnsttp_lfd_nr = hd.hsb_dnsttp_lfd_nr
    LEFT JOIN vermarktungscluster_objekt vco  ON vco.haus_lfd_nr = h.haus_lfD_nr 
    LEFT JOIN strav.haus_ausbau_status   hast ON hast.haus_lfd_nr = h.haus_lfd_nr'
            || '
        WHERE 1=0 '
            ||
            case
                when use_ausbaugebiet then
                    'OR g.id = '
                    || pin_ausbaugebiet
                    || ' '
            end
            ||
            case
                when use_ausbaugebiet_typ then
                    'OR g.typ = '''
                    || piv_ausbaugebiet_typ
                    || ''' '
            end
            ||
            case
                when use_adresssuche then
                    'OR '''
                    || piv_adresse
                    || ''' IS NOT NULL '     -- oder im Adressfeld
            end
            ||
            case
                when use_db_links then
                    '
  UNION ALL              
        SELECT 2 x,
        ag.NAME gebiet, 
        t.ausbgbttp_bez typ, 
        ag.id,
        a.ort,
        a.ort_kompl, 
        a.plz, 
        a.str, 
        a.hnr,
        a.hnr_kompl,
        a.gebaeudeteil_name,
        h.haus_lfd_nr haus_lfd_nr,
        h.haus_we_ges we_ges,
        tdt.dnsttp_bez dnsttp_bez, 
        strav.pck_ems_query.fv_gee_status(pin_haus_lfd_nr=> h.haus_lfd_nr) gee_status, 
        strav.pck_ems_query.fd_gee_erteilt_am(pin_haus_lfd_nr=> h.haus_lfd_nr) gee_erteilt_am,
        case when vco.vc_lfd_nr = '
                    || nvl(
                        to_char(pin_vc_lfd_nr),
                        ''''''
                    )
                    || ' then 1 end AS bereits_zugeordnet,
        (select bezeichnung from vermarktungscluster where vc_lfd_nr = vco.vc_lfd_nr )  vermarktungscluster,        
        hast.has_termin termin,
        hast.has_ausbau_status ausbaustatus
    FROM strav.haus                                                   h
    JOIN v_adressen a on (a.haus_lfd_nr = h.haus_lfd_nr)
    LEFT JOIN SW_AUSBAUGEBIET_OBJEKT@GESWP.NETCOLOGNE.INTERN@SW$ADMIN ago  ON ago.haus_lfd_nr = h.haus_lfd_nr 
    LEFT JOIN SW_AUSBAUGEBIET@GESWP.NETCOLOGNE.INTERN@SW$ADMIN        ag   ON ag.id = ago.id
    LEFT JOIN tab_ausbaugebiet_typ@GESWP.NETCOLOGNE.INTERN@SW$ADMIN   t    ON t.ausbgbttp_id = ag.ausbgbttp_id 
    LEFT JOIN strav.haus_daten                                        hd   ON hd.haus_lfd_nr = h.haus_lfd_nr
    LEFT JOIN tab_dienst_typ                                          tdt  ON tdt.dnsttp_lfd_nr = hd.hsb_dnsttp_lfd_nr
    LEFT JOIN vermarktungscluster_objekt                              vco  on vco.haus_lfd_nr = h.haus_lfd_nr 
    LEFT JOIN strav.haus_ausbau_status                                hast on hast.haus_lfd_nr = h.haus_lfd_nr'
                    || '
        WHERE 1=0 '
                    ||
                        case
                            when use_ausbaugebiet then
                                'OR ag.id = '
                                || pin_ausbaugebiet
                                || ' '
                        end
                    ||
                        case
                            when use_ausbaugebiet_typ then
                                'OR t.ausbgbttp_bez = '''
                                || piv_ausbaugebiet_typ
                                || ''' '
                        end
                    || case
                        when use_adresssuche then
                            'OR '''
                            || piv_adresse
                            || ''' IS NOT NULL '     -- oder Remote im Adressfeld
                    end
            end -- USE_DB_LINKS
            || ')'
            ||
            case
                when use_adresssuche then
                    '
        WHERE 1=1 '
                    || pck_strav_query.fcl_adress_where_query(
                        piv_search_all => piv_adresse,
                        piv_do_search  => 'Y',
                        piv_alias      => null
                    )
            end
            || ')' 
---------------- 
            || ' ADRESSEN '
            ||
            case
                when use_checkboxes then
                    'LEFT JOIN CHECKBOXES ON (CHECKBOXES.N001 = ADRESSEN.HAUS_LFD_NR)'
            end
---------------- 
            || ' WHERE dr=1';
          -- überflüssige Shortcuts rauswerfen:
        return replace(
            replace(v_query, '1=0 OR '),
            '1=1 AND '
        );
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end fv_query_p4;

/**
 * nur als Sicherung für fv_query_p4 vor dem Umbau, @ticket FTTH-5143
 * /////////// nach Test FTTH-5143 löschen
 */
    function fv_query_p4_alt (
        pin_ausbaugebiet     in varchar2,
        piv_ausbaugebiet_typ in varchar2,
        piv_adresse          in varchar2,
        pin_vc_lfd_nr        in vermarktungscluster.vc_lfd_nr%type default null,
        pib_skip_checkboxes  in boolean default null
    ) return varchar2 is

        use_checkboxes       constant boolean := nvl(not pib_skip_checkboxes, true);
        use_adresssuche      constant boolean := trim(piv_adresse) is not null;
        use_ausbaugebiet     constant boolean := nvl(pin_ausbaugebiet, 0) <> 0;         -- Der "NULL Return Value" in APEX ist inzwischen NULL anstatt 0
        use_ausbaugebiet_typ constant boolean := nvl(piv_ausbaugebiet_typ, '0') <> '0'; -- Der "NULL Return Value" in APEX ist inzwischen NULL anstatt 0
        use_db_links         constant boolean := true
        or use_adresssuche
        or upper(piv_ausbaugebiet_typ) = 'ADMINISTRATION';
        v_query              varchar2(32767);
-- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name      constant logs.routine_name%type := 'fv_query_p4_alt';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_ausbaugebiet', pin_ausbaugebiet);
            pck_format.p_add('piv_ausbaugebiet_typ', piv_ausbaugebiet_typ);
            pck_format.p_add('piv_adresse', piv_adresse);
            pck_format.p_add('pin_vc_lfd_nr', pin_vc_lfd_nr);
            pck_format.p_add('pib_skip_checkboxes', pib_skip_checkboxes);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
-- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        v_query :=
            case
                when use_checkboxes then
----------------
                    'WITH CHECKBOXES AS (SELECT SEQ_ID, N001, N002 FROM APEX_COLLECTIONS WHERE COLLECTION_NAME='''
                    || collection_p4_checkbox
                    || ''')'
                    ||
----------------        
    -- "BEREITS_ZUGEORDNET" bedeutet im Gegensatz zur früheren Version, dass eine Zuordnung
    -- zu genau demjenigen Cluster besteht, das oben im Formular angezeigt wird (nicht "zu irgendeinem" wie früher,
    -- denn diese Frage lässt sich ja bereits mit der Spalte VERMARKTUNGSCLUSTER beantworten)
                     '
    SELECT '
                    || 'CASE WHEN NVL(bereits_zugeordnet, 0) = 0 THEN APEX_ITEM.CHECKBOX2(p_idx=>1,p_value=>haus_lfd_nr,'
                    || -- p_item_id=>''checkbox_'' || haus_lfd_nr,
                     'p_attributes=>''class="checkbox--ir"''' 
----------------
                    || '|| CASE WHEN NVL(CHECKBOXES.N002, 0) =1 THEN '' checked'' END'
                    ||
----------------
    -- Ist die Adresse bereits zugeordnet, wird statt der Checkbox ein Golfplatz-Fähnchen angezeigt:
                     ') ELSE ''<span class="noCheckbox fa fa-flag-swallowtail"/>'' END AS CHECKBOX_AUSWAHL,'
                else 'SELECT' -- ohne Checkboxen-Option wird im SQL auf die erste Spalte ("CHECKBOX_AUSWAHL") komplett verzichtet
            end
            || ' gebiet,typ,id,ort,plz,str,hnr,hnr_zus,haus_lfd_nr,we_ges,dnsttp_bez,gee_status, gee_erteilt_am,
    bereits_zugeordnet,termin,ausbaustatus,vermarktungscluster
    FROM (
    SELECT gebiet,typ,id,ort,plz,str,hnr,hnr_zus,haus_lfd_nr,we_ges,dnsttp_bez,gee_status, gee_erteilt_am,
    bereits_zugeordnet,termin,ausbaustatus,vermarktungscluster,
    dense_rank () over (PARTITION BY haus_lfd_nr ORDER BY x DESC) dr
    FROM (
    SELECT 1 x,
        g.gebiet, 
        g.typ, 
        g.id,
        p.plz_oname ort, 
        p.plz_plz plz, 
        s.str_name46 str, 
        h.haus_hnr hnr, 
        h.haus_hnr_zus hnr_zus,
        h.haus_lfd_nr haus_lfd_nr,
        h.haus_we_ges we_ges,
        tdt.dnsttp_bez dnsttp_bez, 
        strav.pck_ems_query.fv_gee_status(pin_haus_lfd_nr=> h.haus_lfd_nr) gee_status, 
        strav.pck_ems_query.fd_gee_erteilt_am(pin_haus_lfd_nr=> h.haus_lfd_nr) gee_erteilt_am,
        case when vco.vc_lfd_nr = '
            || nvl(
            to_char(pin_vc_lfd_nr),
            ''''''
        )
            || ' then 1 end AS bereits_zugeordnet,
        (select bezeichnung from vermarktungscluster where vc_lfd_nr = vco.vc_lfd_nr ) AS vermarktungscluster,        
        hast.has_termin termin,
        hast.has_ausbau_status ausbaustatus
    FROM strav.haus                      h
    JOIN strav.stra_db                   s    ON s.str_lfd_nr = h.str_lfd_nr
    JOIN strav.plz_da                    p    ON p.plz_plz = s.str_plz AND p.plz_alort = s.str_alort
    LEFT JOIN strav.haus_gebiet          hg   ON hg.haus_lfd_nr = h.haus_lfd_nr 
    LEFT JOIN strav.gebiet               g    ON g.id = hg.gebiet_id
    LEFT JOIN strav.haus_daten           hd   ON hd.haus_lfd_nr = h.haus_lfd_nr
    LEFT JOIN tab_dienst_typ             tdt  ON tdt.dnsttp_lfd_nr = hd.hsb_dnsttp_lfd_nr
    LEFT JOIN vermarktungscluster_objekt vco  ON vco.haus_lfd_nr = h.haus_lfD_nr 
    LEFT JOIN strav.haus_ausbau_status   hast ON hast.haus_lfd_nr = h.haus_lfd_nr'
            || '
        WHERE 1=0 '
            ||
            case
                when use_ausbaugebiet then
                    'OR g.id = '
                    || pin_ausbaugebiet
                    || ' '
            end
            ||
            case
                when use_ausbaugebiet_typ then
                    'OR g.typ = '''
                    || piv_ausbaugebiet_typ
                    || ''' '
            end
            ||
            case
                when use_adresssuche then
                    'OR '''
                    || piv_adresse
                    || ''' IS NOT NULL '     -- oder im Adressfeld
            end
            ||
            case
                when use_db_links then
                    '
  UNION ALL              
        SELECT 2 x,
        ag.NAME gebiet, 
        t.ausbgbttp_bez typ, 
        ag.id,
        p.plz_oname ort, 
        p.plz_plz plz, 
        s.str_name46 str, 
        h.haus_hnr hnr, 
        h.haus_hnr_zus hnr_zus,
        h.haus_lfd_nr haus_lfd_nr,
        h.haus_we_ges we_ges,
        tdt.dnsttp_bez dnsttp_bez, 
        strav.pck_ems_query.fv_gee_status(pin_haus_lfd_nr=> h.haus_lfd_nr) gee_status, 
        strav.pck_ems_query.fd_gee_erteilt_am(pin_haus_lfd_nr=> h.haus_lfd_nr) gee_erteilt_am,
        case when vco.vc_lfd_nr = '
                    || nvl(
                        to_char(pin_vc_lfd_nr),
                        ''''''
                    )
                    || ' then 1 end AS bereits_zugeordnet,
        (select bezeichnung from vermarktungscluster where vc_lfd_nr = vco.vc_lfd_nr )  vermarktungscluster,        
        hast.has_termin termin,
        hast.has_ausbau_status ausbaustatus
    FROM strav.haus                                                   h
    JOIN strav.stra_db                                                s    ON s.str_lfd_nr = h.str_lfd_nr
    JOIN strav.plz_da                                                 p    ON p.plz_plz = s.str_plz AND p.plz_alort = s.str_alort
    LEFT JOIN SW_AUSBAUGEBIET_OBJEKT@GESWP.NETCOLOGNE.INTERN@SW$ADMIN ago  ON ago.haus_lfd_nr = h.haus_lfd_nr 
    LEFT JOIN SW_AUSBAUGEBIET@GESWP.NETCOLOGNE.INTERN@SW$ADMIN        ag   ON ag.id = ago.id
    LEFT JOIN tab_ausbaugebiet_typ@GESWP.NETCOLOGNE.INTERN@SW$ADMIN   t    ON t.ausbgbttp_id = ag.ausbgbttp_id 
    LEFT JOIN strav.haus_daten                                        hd   ON hd.haus_lfd_nr = h.haus_lfd_nr
    LEFT JOIN tab_dienst_typ                                          tdt  ON tdt.dnsttp_lfd_nr = hd.hsb_dnsttp_lfd_nr
    LEFT JOIN vermarktungscluster_objekt                              vco  on vco.haus_lfd_nr = h.haus_lfd_nr 
    LEFT JOIN strav.haus_ausbau_status                                hast on hast.haus_lfd_nr = h.haus_lfd_nr'
                    || '
        WHERE 1=0 '
                    ||
                        case
                            when use_ausbaugebiet then
                                'OR ag.id = '
                                || pin_ausbaugebiet
                                || ' '
                        end
                    ||
                        case
                            when use_ausbaugebiet_typ then
                                'OR t.ausbgbttp_bez = '''
                                || piv_ausbaugebiet_typ
                                || ''' '
                        end
                    || case
                        when use_adresssuche then
                            'OR '''
                            || piv_adresse
                            || ''' IS NOT NULL '     -- oder Remote im Adressfeld
                    end
            end -- USE_DB_LINKS
            || ')'
            ||
            case
                when use_adresssuche then
                    '
        WHERE 1=1 '
                    || pck_strav_query.fcl_adress_where_query(
                        piv_search_all => piv_adresse,
                        piv_do_search  => 'Y',
                        piv_alias      => null
                    )
            end
            || ')' 
---------------- 
            || ' ADRESSEN '
            ||
            case
                when use_checkboxes then
                    'LEFT JOIN CHECKBOXES ON (CHECKBOXES.N001 = ADRESSEN.HAUS_LFD_NR)'
            end
---------------- 
            || ' WHERE dr=1';
          -- überflüssige Shortcuts rauswerfen:
        return replace(
            replace(v_query, '1=0 OR '),
            '1=1 AND '
        );
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end fv_query_p4_alt;    

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
 */
    procedure p_alle_ergebnisse_auswaehlen (
        pin_ausbaugebiet     in varchar2,
        piv_ausbaugebiet_typ in varchar2,
        piv_adresse          in varchar2
    ) is

        v_parameter_hash       varchar2(100);
        hashed_collection_name apex_collections.collection_name%type;
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name        constant logs.routine_name%type := 'p_alle_ergebnisse_auswaehlen';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_ausbaugebiet', pin_ausbaugebiet);
            pck_format.p_add('piv_ausbaugebiet_typ', piv_ausbaugebiet_typ);
            pck_format.p_add('piv_adresse', piv_adresse);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
  -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------   
    begin
      -- Da der Adressenreport auf Collections basiert, existiert für alle aktuell
      -- angebotenen Adressen genau eine Collection, deren Name sich 
      -- aus den Werten der drei Eingabe-Items definiert.
        v_parameter_hash := fv_parameter_hash(pin_ausbaugebiet, piv_ausbaugebiet_typ, piv_adresse);
        hashed_collection_name :=
            case
                when v_parameter_hash is not null then
                    collection_p4_adressen || v_parameter_hash
            end -- sonst: NULL
            ;
        if hashed_collection_name is null then
            return;
        end if;

      -- Alle im Report angebotenen Adressen selektieren, 
      -- die nicht bereits angehakt sind:
        for c in (
            select
                to_number(c009) as haus_lfd_nr
            from
                apex_collections
            where
                collection_name = hashed_collection_name
            minus
            select
                n001
            from
                apex_collections
            where
                    collection_name = collection_p4_checkbox
      -- es spielt keine Rolle, ob mit UPDATE_MEMBER oder DELETE_MEMBER
      -- gearbeitet wird:
                and n002 = checked
        ) loop
            apex_collection.add_member(
                p_collection_name => collection_p4_checkbox,
                p_n001            => c.haus_lfd_nr,
                p_n002            => checked
            );
        end loop;

    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end p_alle_ergebnisse_auswaehlen;



/**
 * Erzeugt eine Collection auf der Basis von fv_query_p4 und gibt anstatt der
 * Original-Abfrage die Abfrage auf ebendiese Collection zurück
 */
    function fv_query_p4_collection (
        pin_ausbaugebiet       in varchar2,
        piv_ausbaugebiet_typ   in varchar2,
        piv_adresse            in varchar2,        
    --  piv_do_search          IN VARCHAR2,
        pin_vc_lfd_nr          in vermarktungscluster.vc_lfd_nr%type default null,
        pib_auswahl_bearbeiten in boolean default null
    ) return varchar2 is

        v_original_query       varchar2(32767);
        v_collection_query     varchar2(32767);
        v_parameter_hash       varchar2(100); -- @prüfen: (32) zu klein¿
        hashed_collection_name apex_collections.collection_name%type;
        adressensuche          constant boolean := nvl(not pib_auswahl_bearbeiten, true);
        -----------------------------------
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name        constant logs.routine_name%type := 'fv_query_p4_collection';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_ausbaugebiet', pin_ausbaugebiet);
            pck_format.p_add('piv_ausbaugebiet_typ', piv_ausbaugebiet_typ);
            pck_format.p_add('piv_adresse', piv_adresse);
            pck_format.p_add('pin_vc_lfd_nr', pin_vc_lfd_nr);
            pck_format.p_add('pib_auswahl_bearbeiten', pib_auswahl_bearbeiten);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------         
    begin
        v_parameter_hash := fv_parameter_hash(pin_ausbaugebiet, piv_ausbaugebiet_typ, piv_adresse);

        -- @HASHED_COLLECTION_NAME
        hashed_collection_name :=
            case
                when v_parameter_hash is not null then
                    collection_p4_adressen || v_parameter_hash
            end -- sonst: NULL
            ;
        if hashed_collection_name is not null then
        -- Zunächst alle Adressen selektieren, um daraus eine Collection zu erzeugen:
            v_original_query := fv_query_p4(
                pin_ausbaugebiet     => pin_ausbaugebiet,
                piv_ausbaugebiet_typ => piv_ausbaugebiet_typ,
                piv_adresse          => piv_adresse,
                pin_vc_lfd_nr        => pin_vc_lfd_nr,
                pib_skip_checkboxes  => true
            );

            if not apex_collection.collection_exists(hashed_collection_name) then
                begin
                    apex_collection.create_collection_from_query_b(
                        p_collection_name => hashed_collection_name,
                        p_query           => v_original_query
                    );
                exception
                    -- Durch parallelen Aufruf (APEX REGION Refresh oder schnelles 
                    -- Umschalten der Selectliste) kann es zu einer Race Condition kommen:
                    -- Während die erste Collection noch "in der Mache" ist, glaubt dieser
                    -- Prozess, es gäbe sie noch nicht und würde die Daten doppelt erstellen.
                    when others then
                      -- "Anwendungs-Collection ist vorhanden"
                        if sqlcode not in ( - 20101, - 20104 ) then
                            raise;
                        end if;
                end;

            end if;

        end if;

        v_collection_query :=
            case
                when adressensuche -- Normaler Modus der Seite
                 then
        -- Zeile einkommentieren, um beim Debugging mehr Infos zu sehen:
        -- '--' || to_char(sysdate, 'HH:MI:SS') || ': ' || pin_ausbaugebiet || ', ' || piv_ausbaugebiet_typ || ', ' || piv_adresse' || CHR(10) ||
                    'WITH CHECKBOXES AS (SELECT SEQ_ID, N001, N002'
                    || ' FROM APEX_COLLECTIONS WHERE COLLECTION_NAME='''
                    || collection_p4_checkbox
                    || ''')'
                    || ', ADRESSEN AS ('
                    || 'SELECT'
                    || ' C001 AS gebiet'
                    || ',C002 AS typ'
                    || ',C003 AS id'
                    || ',C004 AS ort_kompl'         -- FTTH-5143 war: ort
                    || ',C005 AS plz'
                    || ',C006 AS str'
                    || ',C007 AS hnr_kompl'         -- FTTH-5143 war: hnr
                    || ',C008 AS gebaeudeteil_name' -- FTTH-5143 war: hnr_zus
                    || ',C009 AS haus_lfd_nr'
                    || ',C010 AS we_ges'
                    || ',C011 AS dnsttp_bez'
                    || ',C012 AS gee_status'
                    || ',C013 AS gee_erteilt_am'
                    || ',C014 AS bereits_zugeordnet'
                    || ',C015 AS termin'
                    || ',C016 AS ausbaustatus'
                    || ',C017 AS vermarktungscluster
           FROM APEX_COLLECTIONS WHERE COLLECTION_NAME = ''' 
           -- Wenn HASHED_COLLECTION_NAME NULL ist, werden zwar zur Lauffzeit keine Daten ausgegeben,
           -- aber die Abfrage bleibt valide, damit der Interactive Report
           -- weiterhin fehlerfrei mit dem SQL arbeiten kann!
                    || hashed_collection_name
                    || ''')'
        ----->>
                    || '
            SELECT N002 AS CHECKED,'
                    || 'CASE WHEN NVL(bereits_zugeordnet, 0) = 0 THEN APEX_ITEM.CHECKBOX2(p_idx=>1,p_value=>haus_lfd_nr,'
                    || 'p_attributes=>''class="checkbox--ir"'''
                    || '|| CASE WHEN NVL(CHECKBOXES.N002, 0) =1 THEN '' checked'' END'
                    ||
            -- Ist die Adresse bereits zugeordnet, wird statt der Checkbox ein Golfplatz-Fähnchen angezeigt:
                     ') ELSE ''<span class="noCheckbox fa fa-flag-swallowtail"/>'' END AS CHECKBOX_AUSWAHL,'

     -- || ' gebiet, typ, id, ort, plz, str, hnr, hnr_zus, haus_lfd_nr,' -- FTTH-5143: ersetzt durch:
                    || ' gebiet, typ, id, ort_kompl, plz, str, hnr_kompl, gebaeudeteil_name, haus_lfd_nr,'
                    || ' we_ges, dnsttp_bez, gee_status, gee_erteilt_am,'
                    || ' bereits_zugeordnet, termin, ausbaustatus, vermarktungscluster'
                    || ' FROM ADRESSEN'
                    || ' LEFT JOIN CHECKBOXES ON (CHECKBOXES.N001 = ADRESSEN.HAUS_LFD_NR)'
                else -- Modus "Ausgewählte Adressen prüfen":
                 'WITH '
                     || ' CHECKBOXES AS (SELECT SEQ_ID, N001, N002'
                     || ' FROM APEX_COLLECTIONS WHERE COLLECTION_NAME='''
                     || collection_p4_checkbox
                     || ''''
                     || ' AND N002=1' -- nur die angehakten
                     || ')'
        ----->>
                     || ' SELECT CHECKBOXES.N002 AS CHECKED,'
                     || 'APEX_ITEM.CHECKBOX2(p_idx => 1, p_value => CHECKBOXES.N001,' -- HAUS_LFD_NR
                     || 'p_attributes=>''class="checkbox--ir"'''
                     || ' || CASE WHEN NVL(CHECKBOXES.N002, 0) =1 THEN '' checked'' END ) AS CHECKBOX_AUSWAHL,'
                     || ' TO_CHAR(NULL) AS gebiet, TO_CHAR(NULL) AS typ, TO_NUMBER(NULL) AS id,'
     -- || ' ort, plz, str, hnr, hnr_zus, CHECKBOXES.N001 AS haus_lfd_nr,' -- @ticket FTTH-5143 ersetzt durch:
                     || ' ort_kompl, plz, str, hnr_kompl, gebaeudeteil_name, CHECKBOXES.N001 AS haus_lfd_nr,'
                     || ' we AS we_ges, TO_CHAR(NULL) AS dnsttp_bez, TO_CHAR(NULL) AS gee_status, TO_CHAR(NULL) AS gee_erteilt_am,'
                     || ' TO_NUMBER(NULL) AS bereits_zugeordnet, TO_CHAR(NULL) AS termin, TO_CHAR(NULL) AS ausbaustatus,'
                     || ' VC.BEZEICHNUNG AS vermarktungscluster'
                     || ' FROM CHECKBOXES'
            -- LEFT JOIN weil nicht sicher ist, ob (auch in DEV) jedes HAUS eine Adresse besitzt:
                     || ' LEFT JOIN V_ADRESSEN ON (CHECKBOXES.N001 = V_ADRESSEN.HAUS_LFD_NR)'
                     || ' LEFT JOIN VERMARKTUNGSCLUSTER_OBJEKT VCO ON (CHECKBOXES.N001 = VCO.HAUS_LFD_NR)'
                     || ' LEFT JOIN VERMARKTUNGSCLUSTER VC ON (VC.VC_LFD_NR = VCO.VC_LFD_NR)'
            end;

        return v_collection_query;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end fv_query_p4_collection;
/**
 * Löscht alle Zuordnungen eines Objekts zu Vermarktungsclustern 
 * (eigentlich sollte nur eine einzige existieren, jedoch
 * besitzt das Datenmodell bei Anlage dieses Packages leider keinen Unique Key auf
 * VERMARKTUNGSCLUSTER_OBJEKT.HAUS_LFD_NR)
 *
 * @param pin_haus_lfd_nr   ID des Objekts, dessen Zuordnung(en) entfernt werden sollen
 *
 * @usage Es wird das offizielle DML-Package aufgerufen
 */
    procedure p_delete_haus_zuordnungen (
        pin_haus_lfd_nr in vermarktungscluster_objekt.haus_lfd_nr%type
    ) is
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'p_delete_haus_zuordnungen';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_haus_lfd_nr', pin_haus_lfd_nr);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        -- aufgrund des fehlenden Unique Keys muss geloopt werden:
        for vco in (
            select
                vco_lfd_nr
            from
                vermarktungscluster_objekt
            where
                haus_lfd_nr = pin_haus_lfd_nr
        ) loop
            pck_vermarktungsclstr_obj_dml.p_delete(pin_vco_lfd_nr => vco.vco_lfd_nr);
        end loop;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end;

/**
 * Fügt der Tabelle VERMARKTUNGSCLUSTER_OBJEKT eine neue Zeile hinzu und gibt
 * die ID der neuen Zuordnung zurück
 *
 * @param pin_haus_lfd_nr   ID des Objekts, dessen Zuordnung festgelegt wird
 * @param pin_vc_lfd_nr     ID des zuzuordnenden Vermarktungsclusters
 *
 * @usage Es wird das offizielle DML-Package aufgerufen
 */
    function fn_insert_haus_zuordnung (
        pin_haus_lfd_nr in vermarktungscluster_objekt.haus_lfd_nr%type,
        pin_vc_lfd_nr   in vermarktungscluster_objekt.vc_lfd_nr%type
    ) return vermarktungscluster_objekt.vco_lfd_nr%type is

        vr_vermarktungscluster_obj vermarktungscluster_objekt%rowtype;
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name            constant logs.routine_name%type := 'p_insert_haus_zuordnung';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_haus_lfd_nr', pin_haus_lfd_nr);
            pck_format.p_add('pin_vc_lfd_nr', pin_vc_lfd_nr);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------         
    begin
        vr_vermarktungscluster_obj.haus_lfd_nr := pin_haus_lfd_nr;
        vr_vermarktungscluster_obj.vc_lfd_nr := pin_vc_lfd_nr;
        pck_vermarktungsclstr_obj_dml.p_insert(pior_vermarktungscluster_obj => vr_vermarktungscluster_obj);
        return vr_vermarktungscluster_obj.vco_lfd_nr;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end;

/** 2022-11-02: Rein technisches Package - nicht direkt von außen zugänglich machen
 *
 * Versucht zunächst, eine bestehende Zuordnung von Haus und Vermarktungscluster
 * zu aktualisieren; existiert eine solche nicht, wird eine neue Zuordnung eingefügt.
 *
 * @param pin_haus_lfd_nr   ID des Objekts, dessen Zuordnung festgelegt wird
 * @param pin_vc_lfd_nr     ID des zuzuordnenden Vermarktungsclusters
 * @param pin_vco_lfd_nr    Falls das aufrufende Programm den PK der Zuordnung
 *                          bereits kennt, kann dieser hier übergeben werden, 
 *                          um eine Abfrage einzusparen - die nötige Üereinstimmung
 *                          wird hier jedoch nicht geprüft, sondern als gegeben betrachtet
 *
 * @usage Es wird das offizielle DML-Package aufgerufen.
 *        Bei bestehender Zuordnung findet ein MERGE auf die Tabelle VERMARKTUNGSCLUSTER_OBJEKT
 *        statt, bei nicht bestehender Zuordnung ein INSERT.
 *
 * @deprecated
    PROCEDURE p_haus_vmc_zuordnen (
        pin_haus_lfd_nr IN vermarktungscluster_objekt.haus_lfd_nr%TYPE,
        pin_vc_lfd_nr   IN vermarktungscluster_objekt.vc_lfd_nr%TYPE,
        pin_vco_lfd_nr  IN vermarktungscluster_objekt.vco_lfd_nr%TYPE DEFAULT NULL
    ) IS
        vr_vermarktungscluster_obj vermarktungscluster_objekt%rowtype;
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name            CONSTANT logs.routine_name%TYPE := 'p_haus_vmc_zuordnen';
        FUNCTION fcl_params RETURN logs.message%TYPE IS
        BEGIN
            pck_format.p_add('pin_haus_lfd_nr', pin_haus_lfd_nr);
            pck_format.p_add('pin_vc_lfd_nr', pin_vc_lfd_nr);
            pck_format.p_add('pin_vco_lfd_nr', pin_vco_lfd_nr);
            RETURN pck_format.fcl_params(cv_routine_name);
        END fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------         
    BEGIN
        vr_vermarktungscluster_obj.haus_lfd_nr := pin_haus_lfd_nr;
        vr_vermarktungscluster_obj.vc_lfd_nr   := pin_vc_lfd_nr;

        -- Das aufrufende Programm hat keinen VCO-Key mitgegeben,
        -- Dann diesen hier ermitteln:
        IF pin_vco_lfd_nr IS NULL THEN
            SELECT MAX(vco_lfd_nr)
              INTO vr_vermarktungscluster_obj.vco_lfd_nr
              FROM vermarktungscluster_objekt
             WHERE haus_lfd_nr = pin_haus_lfd_nr;
        ELSE
            vr_vermarktungscluster_obj.vco_lfd_nr := pin_vco_lfd_nr;
        END IF;

        -- Wenn es keinen bestehenden Datensatz gibt, kann anhand des VCO-PK
        -- auch nichts gemerged werden. In dem Fall brauchen wir ein INSERT.
        IF vr_vermarktungscluster_obj.vco_lfd_nr IS NULL THEN
            pck_vermarktungsclstr_obj_dml.p_insert(pior_vermarktungscluster_obj => vr_vermarktungscluster_obj);
        ELSE
            pck_vermarktungsclstr_obj_dml.p_merge(pir_vermarktungscluster_obj => vr_vermarktungscluster_obj);
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            pck_logs.p_error(pic_message => fcl_params(), piv_routine_name => cv_routine_name);
            RAISE;
    END;
 */

/**
 * Schreibt in einer Autonomen Transaktion den Fehler beim Ausführen einer bestimmten Zeile
 * zurück in die Collection, so dass auch nach einem vollständigen Rollback in der
 * Abarbeitung jederzeit nachverfolgt werden kann, welche Zeilen die Probleme 
 * verursacht haben
 *
 * @param piv_aktion        IN  Derzeit nur implementiert: 'AKTIONSLISTE' 
 * @param pin_seq_id        IN  Technische ID der Collection-Zeile
 * @param piv_fehlermeldung IN  Zu loggende Fehlermeldung, typischerweise die SQLERRM
 * 
 */
    procedure p_log_aktionsliste (
        piv_aktion        in varchar2,
        pin_seq_id        in apex_collections.seq_id%type,
        pin_fehlercode    in integer,
        piv_fehlermeldung in varchar2
    ) is
        pragma autonomous_transaction;
    begin
        apex_collection.update_member_attribute(
            p_collection_name => aktionsliste,
            p_seq             => pin_seq_id,
            p_attr_number     => 4,
            p_number_value    => pin_fehlercode
        );

        apex_collection.update_member_attribute(
            p_collection_name => aktionsliste,
            p_seq             => pin_seq_id,
            p_attr_number     => 4,
            p_attr_value      => substr(piv_fehlermeldung, 1, 4000)
        );

        commit;
    exception
        when others then
            rollback;
    end;

    function collection_name_aktionsliste return varchar2
        deterministic
    is
    begin
        -- SELECT SEQ_ID
        -- notwendige Daten ----------- 
        --      , N001 AS ZEILENNUMMER_CSV
        --      , N002 AS GEPLANTE_AKTION
        --      , N003 AS STATUS (AKTION)
        --        N004 AS FEHLERCODE (nach Ausführung der Aktion) -- 2023-12-21 war: AS VCO_LFD_NR (nach Ausführung der Aktion)
        --      , N005 AS PROBLEMKATEGORIE (vor Ausführung der Aktion)
        --      , C001 AS HAUS_LFD_NUMMER
        --      , C002 AS VMC_ALT
        --      , C003 AS VMC_NEU
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
        return aktionsliste;
    end;

/**
 * Liest die APEX Collection namens AKTIONSLISTE und führt alle Aktionen durch,
 * die dort auf "ausführen = ja" eingestellt sind. 
 * Es gilt das "Alles oder Nichts"-Prinzip: Sämtliche Aktionen werden zurückgerollt, 
 * wenn eine einzige fehlschlägt.
 *
 * @param piv_aktion  IN  Derzeit nur implementiert: 'AKTIONSLISTE'
 *
 * @usage Getestet wurde mit etwa 5000 Datensätzen: Diese Menge ist klein genug,
 *        um den Prozess synchron aus APEX heraus aufzurufen. Bei einer erheblich
 *        größeren Anzahl von Aktionen sollte geprüft werden, ob ein asynchroner
 *        Prozessaufruf der bessere Weg ist.
 *
 * @return  Anzahl der kritischen Fehler (0..n), die bei der Ausführung aufgetreten sind.
 *          Wenn dies > 0 ist, dann wurden alle Aktionen zurückgerollt.
 */
    function p_listenaktionen_ausfuehren (
        piv_aktion in varchar2
    ) return naturaln is

        ausfuehren                        constant naturaln := 1;
        nicht_ausfuehren                  constant naturaln := 0;
        v_anzahl_zugeordnet               naturaln := 0;
        v_anzahl_fehler                   naturaln := 0;
        v_max_csv_zeilennummer            natural;
        v_max_csv_zeilennummer_zugeordnet natural;
        vn_vco_lfd_nr                     vermarktungscluster_objekt.vco_lfd_nr%type;
        v_vco_lfd_nr_list                 clob := 'Liste'; 
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name                   constant logs.routine_name%type := 'p_listenaktionen_ausfuehren';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_aktion', piv_aktion);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------         
    begin
/*
--/////--2023-12-21 (nur zur Überprüfung @ticket FTTH-3197)---------------------
IF MONITORING_AKTIV THEN
pck_logs.p_error(
   pic_message      => fcl_params()
  ,piv_routine_name => '/// ' || cv_routine_name
  ,piv_scope        => G_SCOPE
);
END IF;
--/////-------------------------------------------------------------------------
*/
        savepoint before_listenaktionen;
        for c in (
            select
                seq_id,
                n001 as zeilennummer_csv,
                n002 as geplante_aktion,
                n003 as status,
                n005 as problemkategorie,
                c001 as haus_lfd_nummer,
                c002 as vmc_alt,
                c003 as vmc_neu,
                c005 as validierung,
                   --- für das anschließende UPDATE_MEMBER:
                c006,
                c007,
                c008,
                c009,
                c010,
                c011,
                c012,
                c013,
                c014,
                c015
            from
                apex_collections
            where
                collection_name = aktionsliste
            order by
                n001
        ) loop
            begin
                v_max_csv_zeilennummer := c.zeilennummer_csv;
                if c.status = ausfuehren then
                    v_anzahl_zugeordnet := 1 + v_anzahl_zugeordnet;
                    vn_vco_lfd_nr := fn_objekt_zuordnen(
                        pin_haus_lfd_nr => c.haus_lfd_nummer,
                        pin_vc_lfd_nr   => c.vmc_neu,
                        pin_modus       => c.geplante_aktion
                    );

                    if
                        monitoring_aktiv
                        and v_max_csv_zeilennummer <= 1000
                    then
                        begin
                            v_vco_lfd_nr_list := concat(v_vco_lfd_nr_list,(', '
                                                                           || vn_vco_lfd_nr));
                        exception
                            when others then
                                null; -- //////////
                        end;
                    end if;

                    v_max_csv_zeilennummer_zugeordnet := c.zeilennummer_csv;
                    -- vn_vco_lfd_nr wird zurzeit nicht weiter verwendet/ausgewertet! ///
                    apex_collection.update_member(
                        p_collection_name => aktionsliste,
                        p_seq             => c.seq_id,
                        p_n001            => c.zeilennummer_csv,
                        p_n002            => c.geplante_aktion,
                        p_n003            => c.status,
                        p_n004            => null -- wird im Logging upgedatet, falls ein Fehler aufgetreten ist
                        ,
                        p_n005            => c.problemkategorie,
                        p_c001            => c.haus_lfd_nummer,
                        p_c002            => c.vmc_alt -- derzeit leer
                        ,
                        p_c003            => c.vmc_neu,
                        p_c004            => null -- SQLERRM
                        ,
                        p_c005            => c.validierung,
                        p_c006            => c.c006,
                        p_c007            => c.c007,
                        p_c008            => c.c008,
                        p_c009            => c.c009,
                        p_c010            => c.c010,
                        p_c011            => c.c011,
                        p_c012            => c.c012,
                        p_c013            => c.c013,
                        p_c014            => c.c014,
                        p_c015            => c.c015
                    );

                else -- Aktion NICHT ausführen (da vom Benutzer ausgeschlossen):
                     -- loggen, aber der Fehlerzähler wird nicht erhöht, 
                     -- denn es handelt sich nicht um einen Fehler!
                    p_log_aktionsliste(
                        piv_aktion        => aktionsliste,
                        pin_seq_id        => c.seq_id,
                        pin_fehlercode    => 0 -- kein Fehler, aber auch nicht ausgeführt!
                        ,
                        piv_fehlermeldung => c_aktion_wurde_ausgeschlossen
                    );
                end if;

            exception -- beim DML für irgendeine Zuordnung ist ein unvorhergesehener Fehler aufgetreten:
                when others then 
                -- Technisches Logging:
                    pck_logs.p_error(
                        pic_message      => fcl_params(),
                        piv_routine_name => cv_routine_name,
                        piv_scope        => g_scope
                    );              
                -- Dies sorgt dafür, dass zum Schluss sämtliche Aktionen zurückgerollt werden:
                    v_anzahl_fehler := 1 + v_anzahl_fehler;
                -- Fachliches Logging:
                    p_log_aktionsliste(
                        piv_aktion        => aktionsliste,
                        pin_seq_id        => c.seq_id,
                        pin_fehlercode    => sqlcode,
                        piv_fehlermeldung => sqlerrm
                    );
                -- dennoch weitermachen, damit alle aufgetretenen Fehler
                -- (nicht nur der erste) einzeln protokolliert werden können
                    continue;
            end;
        end loop;

--/////--2023-12-21 (nur zur Überprüfung @ticket FTTH-3197)---------------------
        if monitoring_aktiv then
            pck_logs.p_error(
                pic_message      => 'Anzahl Fehler: '
                               || v_anzahl_fehler
                               || ', Anzahl zugeordnet: '
                               || v_anzahl_zugeordnet
                               || ', max. CSV: '
                               || v_max_csv_zeilennummer
                               || ', max CSV (zugeordnet): '
                               || v_max_csv_zeilennummer_zugeordnet,
                piv_routine_name => '/// ' || cv_routine_name,
                piv_scope        => g_scope
            );

            pck_logs.p_error(
                pic_message      => v_vco_lfd_nr_list,
                piv_routine_name => '/// ' || cv_routine_name,
                piv_scope        => g_scope
            );

        end if;
--/////-------------------------------------------------------------------------        

        if v_anzahl_fehler > 0 then
            rollback to before_listenaktionen;
        end if;
        return v_anzahl_fehler;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end;

/**
 * Reagiert per AJAX auf das Umschalten des Schalters "Ausführen" im STEP-3
 * des Listenimport-Wizards (APEX 1210:11)
 *
 * @param pin_seq_id            Primärschlüssel der entsprechenden APEX_COLLECTION:
 *                              Collection-Zeile (nicht CSV-Zeile!), deren Zustand
 *                              geändert werden soll
 * @param pin_schalterstellung  0=nicht ausführen, 1=ausführen
 *
 * @usage  Dies dient dazu, dass auch beim Wechsel der Ansicht im Interactive Grid
 *         alle getätigten Schaltvorgänge persistiert werden
 */
    procedure p_aktion_umschalten (
        pin_seq_id           in apex_collections.seq_id%type,
        pin_schalterstellung in naturaln
    ) is
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'p_aktion_umschalten';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_seq_id', pin_seq_id);
            pck_format.p_add('pin_schalterstellung', pin_schalterstellung);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------     
    begin
        if pin_schalterstellung not in ( 0, 1 ) then
            raise_application_error(c_plausi_error_number,
                                    'Schalterstellung wurde fehlerhaft übermittelt: '
                                    || nvl(
                to_char(pin_schalterstellung),
                'NULL'
            ));
        end if;

        if not nvl(pin_seq_id, 0) > 0 then
            raise_application_error(c_plausi_error_number,
                                    'SEQ_ID wurde fehlerhaft übermittelt: '
                                    || nvl(
                to_char(pin_seq_id),
                'NULL'
            ));
        end if;

        apex_collection.update_member_attribute(
            p_collection_name => aktionsliste,
            p_seq             => pin_seq_id,
            p_attr_number     => 3,
            p_number_value    => pin_schalterstellung
        );

    exception
        when others then
            if sqlcode <> c_plausi_error_number then
                pck_logs.p_error(
                    pic_message      => fcl_params(),
                    piv_routine_name => cv_routine_name,
                    piv_scope        => g_scope
                );
            end if;

            raise;
    end;
/**
 * Setzt alle Zeilen der Aktionsliste auf "nicht ausführen",
 * die in irgendeine Problemkategorie fallen (gelb und rot markierte)
 */
    procedure p_alle_auffaelligen_deaktivieren is
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'p_alle_auffaelligen_deaktivieren';

        function fcl_params return logs.message%type is
        begin
            return null; -- diese procedure besitzt keine Parameter
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        for r in (
            select
                seq_id
            from
                apex_collections
            where
                    collection_name = aktionsliste
                and n005 is not null
        ) loop
            apex_collection.update_member_attribute(
                p_collection_name => aktionsliste,
                p_seq             => r.seq_id,
                p_attr_number     => 3,
                p_number_value    => 0
            );
        end loop;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end;
/**
 * Setzt alle Zeilen der Aktionsliste auf "nicht ausführen",
 * die in eine schwerwiegende Problemkategorie fallen und so die Ausführung
 * der gesamten Liste verhindern würden (nur rot markierte)
 */
    procedure p_showstopper_deaktivieren is
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'p_showstopper_deaktivieren';

        function fcl_params return logs.message%type is
        begin
            return null; -- diese procedure besitzt keine Parameter
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        for r in (
            select
                seq_id
            from
                apex_collections
            where
                    collection_name = aktionsliste
                and n005 < 0
        ) loop
            apex_collection.update_member_attribute(
                p_collection_name => aktionsliste,
                p_seq             => r.seq_id,
                p_attr_number     => 3,
                p_number_value    => 0
            );
        end loop;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end;
/**   
 * Gibt den Inhalt einer in APEX_APPLICATION_TEMP_FILES hochgeladenenen Datei zurück
 *
 * @param pin_file_id  Identifier der Datei (Spalte APEX_APPLICATION_TEMP_FILES.ID)
 *
 * @exception  Alle Exceptions werden geworfen. Kein Logging.
 */
    function f_blob_content_temp_files (
        pin_file_id in apex_application_temp_files.id%type
    ) return blob is

        v_blob_content  blob;
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'f_blob_content_temp_files';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_file_id', pin_file_id);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------         
    begin
        select
            blob_content
        into v_blob_content
        from
            apex_application_temp_files
        where
            id = pin_file_id;

        return v_blob_content;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end;



/**
 * Liest die Importliste (APEX 1210:11), erzeugt die Collection AKTIONSLISTE dynamisch 
 * und befüllt sie mit den vom Wizard (STEP-2) erzeugten Aktionsdaten, die dann
 * in STEP-3 vom Benutzer verworfen oder bestätigt werden
 *
 * @param pib_blob_content       [IN] Importliste (Dateiinhalt)
 * @param piv_dateiname          [IN] Dateiname der Importliste
 * @param pin_start_zeilennummer [IN] In welcher Zeile  (1, 2, 3, ...) beginnen die Daten
 * @param pin_spaltennummer_haus [IN] In welcher Spalte (1, 2, 3, ...) steht die HAUS_LFD_NR
 * @param pin_aktion             [IN] Auswahl des Users, was mit den Daten der Importliste geschehen soll:
 *                                    
 * @param piv_vmc_neu            [IN] LFD_NR des Vermarktungsclusters, der zur ausgewählten Aktion gehört
 * @param piv_zeilentrenner      [IN]  (optional, default: chr(10)) Alternatives Zeichen für End-of-Line in der CSV-Datei
 *
 * @ticket FTTH-5143: 2 Detailtabellen ersetzt
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
    ) is

        aktionsliste_exists boolean := apex_collection.collection_exists(aktionsliste);
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name     constant logs.routine_name%type := 'p_create_aktionsliste';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('length(pib_blob_content)',
                             dbms_lob.getlength(pib_blob_content));
            pck_format.p_add('piv_dateiname', piv_dateiname);
            pck_format.p_add('pin_start_zeilennummer', pin_start_zeilennummer);
            pck_format.p_add('pin_spaltennummer_haus', pin_spaltennummer_haus);
            pck_format.p_add('pin_aktion', pin_aktion);
            pck_format.p_add('piv_vmc_neu', piv_vmc_neu);
            pck_format.p_add('piv_spaltentrenner', piv_spaltentrenner);
            pck_format.p_add('piv_zeilentrenner', piv_zeilentrenner);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------       
    begin
          -- ggf umbauen auf CREATE_COLLECTION_FROM_QUERY2 ///
        apex_collection.create_or_truncate_collection(aktionsliste);
        for aktion in (
            with liste_step_3 as (
            -------------------------------
                select
                    line_number as n001,
                    pin_aktion  as n002,
                    1           as n003, -- ja, default=ausführen
                    case pin_spaltennummer_haus
                        when 1  then
                            col001
                        when 2  then
                            col002
                        when 3  then
                            col003
                        when 4  then
                            col004
                        when 5  then
                            col005
                        when 6  then
                            col006
                        when 7  then
                            col007
                        when 8  then
                            col008
                        when 9  then
                            col009
                        when 10 then
                            col010
                        when 11 then
                            col011
                        when 12 then
                            col012
                        when 13 then
                            col013
                        when 14 then
                            col014
                        when 15 then
                            col015
                        when 16 then
                            col016
                        when 17 then
                            col017
                        when 18 then
                            col018
                        when 19 then
                            col019
                        when 20 then
                            col020
                        when 21 then
                            col021
                        when 22 then
                            col022
                        when 23 then
                            col023
                        when 24 then
                            col024
                        when 25 then
                            col025
                        when 26 then
                            col026
                        when 27 then
                            col027
                        when 28 then
                            col028
                        when 29 then
                            col029
                        when 30 then
                            col030
                        when 31 then
                            col031
                        when 32 then
                            col032
                        when 33 then
                            col033
                        when 34 then
                            col034
                        when 35 then
                            col035
                        when 36 then
                            col036
                        when 37 then
                            col037
                        when 38 then
                            col038
                        when 39 then
                            col039
                        when 40 then
                            col040
                        when 41 then
                            col041
                        when 42 then
                            col042
                        when 43 then
                            col043
                        when 44 then
                            col044
                        when 45 then
                            col045
                        when 46 then
                            col046
                        when 47 then
                            col047
                        when 48 then
                            col048
                        when 49 then
                            col049
                        when 50 then
                            col050
                    end         as c001,
                    null        as c002, -- //// war: piv_vmc_alt hier den bestehenden VMC selektieren
                    piv_vmc_neu as c003
                from
                    table ( apex_data_parser.parse(
                        p_content           => pib_blob_content,
                        p_file_name         => piv_dateiname,
                        p_csv_col_delimiter => piv_spaltentrenner,
                        p_csv_row_delimiter => piv_zeilentrenner,
                        p_skip_rows         => pin_start_zeilennummer - 1
                    ) )
            ) ---->
            select
                n001,
                n002,
                n003,
                c001,
                c002,
                c003,
                case
                    -- Problemkategorie OBJEKT:
                    when a.haus_lfd_nr is null then
                        c_plausi_objekt              
                    -- Problemkategorie ADRESSE:
                    when a.adresse_kompl is null then
                        c_plausi_adresse
                    -- Problemkategorie ZUORDNUNG/1:
                    when pin_aktion = c_modus_aufheben
                         and vmc_alt.bezeichnung is null then
                        c_plausi_zuordnung
                    -- Problemkategorie ZUORDNUNG/2:
                    when pin_aktion = c_modus_einfach
                         and vmc_alt.bezeichnung is not null then
                        c_plausi_zuordnung
                    -- Problemkategorie ZUORDNUNG/3:
                    when pin_aktion = c_modus_alternativ
                         and vmc_alt.bezeichnung is null then
                        c_plausi_zuordnung
                end                 as problemkategorie,
                case 
                    -- Problemkategorie OBJEKT:
                    when a.haus_lfd_nr is null then
                        'HAUS_LFD_NR konnte nicht gefunden werden (schließen Sie diese Aktion aus, damit die Liste verarbeitet werden kann)'              
                    -- Problemkategorie ADRESSE:
                    when a.adresse_kompl is null then 
                      --  'Keine Adresse zu HAUS_LFD_NR ' || LISTE_STEP_3.C001 || ' gefunden'
                        'Keine Adresse zu dieser HAUS_LFD_NR gefunden'
                    -- Problemkategorie ZUORDNUNG/1:
                    when pin_aktion = c_modus_aufheben
                         and vmc_alt.bezeichnung is null then 
                    --'HAUS_LFD_NR ' || LISTE_STEP_3.C001 || ' ist keinem Vermarktungscluster zugeordnet'
                        'Adresse ist keinem Vermarktungscluster zugeordnet'
                    -- Problemkategorie ZUORDNUNG/2:
                    when pin_aktion = c_modus_einfach
                         and vmc_alt.bezeichnung is not null then
                    --'HAUS_LFD_NR ' || LISTE_STEP_3.C001 || ' ist bereits einem Vermarktungscluster zugeordnet'
                        'Adresse ist bereits einem Vermarktungscluster zugeordnet'
                    -- Problemkategorie ZUORDNUNG/3:
                    when pin_aktion = c_modus_alternativ
                         and vmc_alt.bezeichnung is null then
                    --'HAUS_LFD_NR ' || LISTE_STEP_3.C001 || ' ist bisher keinem Vermarktungscluster zugeordnet'
                        'Adresse ist bisher keinem Vermarktungscluster zugeordnet'
                end                 as validierung,
                a.adresse_kompl,
                a.str,
                a.hnr_kompl,
                a.gebaeudeteil_name,
                a.plz,
                a.ort_kompl,
                vmc_alt.bezeichnung as vmc_alt_bezeichnung,
                vmc_neu.bezeichnung as vmc_neu_bezeichnung,
                vco.vc_lfd_nr       as vco_vc_lfd_nr
            from
                     liste_step_3
                join v_adressen                 a on ( a.haus_lfd_nr = to_number(liste_step_3.c001) ) -- @ticket FTTH-5143: 2 Detailtabellen ersetzt.
          --   wichtig: Wir müssen davon ausgehen, dass jede HAUS_LFD_NR eine Entsprechnung in V_ADRESSEN hat.
          --   Deshalb JOIN.
          --   Der zunächst so belassene LEFT JOIN an dieser Stelle bewirkt einen Laufzeitfehler, vermutlich
          --   weil zu viele Resourcen belegt werden (APEX zeigt nur: "Error" ohne Erläuterung, nachdem die Seite ca.
          --   eine Sekunde lang arbeitet)
                left join vermarktungscluster        vmc_neu on ( vmc_neu.vc_lfd_nr = to_number(liste_step_3.c003) )
          -- bisherigen Vermarktungscluster aus ROMA ermitteln:
                left join vermarktungscluster_objekt vco on ( vco.haus_lfd_nr = liste_step_3.c001 )
                left join vermarktungscluster        vmc_alt on ( vmc_alt.vc_lfd_nr = vco.vc_lfd_nr ) -- war: TO_NUMBER(LISTE_STEP_3.C002)
        ) loop
            apex_collection.add_member(
                p_collection_name => aktionsliste,
                p_n001            => aktion.n001,
                p_n002            => aktion.n002,
                p_n003            => aktion.n003,
                p_n005            => aktion.problemkategorie,
                p_c001            => aktion.c001,
                p_c002            => aktion.c002,
                p_c003            => aktion.c003
            -- ,p_c004               später: ERROR_MESSAGE
                ,
                p_c005            => aktion.validierung
               --- anreichern mit Display-Daten, z.B. Haus-Adressen:
                ,
                p_c006            => aktion.adresse_kompl,
                p_c007            => aktion.vmc_alt_bezeichnung,
                p_c008            => aktion.vmc_neu_bezeichnung
            -- ,p_c009               nicht verwendet
            -- ,p_c010               nicht verwendet
                ,
                p_c011            => aktion.str,
                p_c012            => aktion.hnr_kompl,
                p_c013            => aktion.gebaeudeteil_name -- @ticket FTTH-5143: p_c013 wurde bisher nicht verwendet
                ,
                p_c014            => aktion.plz,
                p_c015            => aktion.ort_kompl
            );
        end loop;

    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            if sqlcode = -01722 then -- "ungültige Zahl", typisch wenn Komma anstatt Semikolon verwendet wurde.
                raise_application_error(c_plausi_error_number, 'Ungültige Zahl. Mögliche Ursache: Die Datei verwendet Komma (anstatt wie erwartet Semikolon) als Spalten-Trennzeichen'
                );
            end if;
            raise;
    end p_create_aktionsliste;

/**
 * Gibt den Inhalt jeder nicht-leeren Spalte einer bestimmten Zeile 
 * einer CSV-Datei zurück, sowie deren Spaltennummer.
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
        pipelined
    is
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'get_header_columns';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pib_blob_content (length)',
                             dbms_lob.getlength(pib_blob_content));
            pck_format.p_add('piv_dateiname', piv_dateiname);
            pck_format.p_add('pin_zeilennummer', pin_zeilennummer);
            pck_format.p_add('piv_spaltentrenner', piv_spaltentrenner);
            pck_format.p_add('piv_zeilentrenner', piv_zeilentrenner);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------     
    begin
        for c in (
            select
                line_number,
                col001,
                col002,
                col003,
                col004,
                col005,
                col006,
                col007,
                col008,
                col009,
                col010,
                col011,
                col012,
                col013,
                col014,
                col015,
                col016,
                col017,
                col018,
                col019,
                col020,
                col021,
                col022,
                col023,
                col024,
                col025,
                col026,
                col027,
                col028,
                col029,
                col030,
                col031,
                col032,
                col033,
                col034,
                col035,
                col036,
                col037,
                col038,
                col039,
                col040,
                col041,
                col042,
                col043,
                col044,
                col045,
                col046,
                col047,
                col048,
                col049,
                col050
            from
                table ( apex_data_parser.parse(
                    p_content   => pib_blob_content,
                    p_file_name => piv_dateiname
                    -----   , p_skip_rows => pin_zeilennummer - 1
                    ,
                    p_max_rows  => 3
                ) )
            where
                line_number = pin_zeilennummer
        ) loop
            if c.col001 is not null then
                pipe row ( new t_lov_entry(c.col001, 1) );
            end if;

            if c.col002 is not null then
                pipe row ( new t_lov_entry(c.col002, 2) );
            end if;

            if c.col003 is not null then
                pipe row ( new t_lov_entry(c.col003, 3) );
            end if;

            if c.col004 is not null then
                pipe row ( new t_lov_entry(c.col004, 4) );
            end if;

            if c.col005 is not null then
                pipe row ( new t_lov_entry(c.col005, 5) );
            end if;

            if c.col006 is not null then
                pipe row ( new t_lov_entry(c.col006, 6) );
            end if;

            if c.col007 is not null then
                pipe row ( new t_lov_entry(c.col007, 7) );
            end if;

            if c.col008 is not null then
                pipe row ( new t_lov_entry(c.col008, 8) );
            end if;

            if c.col009 is not null then
                pipe row ( new t_lov_entry(c.col009, 9) );
            end if;

            if c.col010 is not null then
                pipe row ( new t_lov_entry(c.col010, 10) );
            end if;

            if c.col011 is not null then
                pipe row ( new t_lov_entry(c.col011, 11) );
            end if;

            if c.col012 is not null then
                pipe row ( new t_lov_entry(c.col012, 12) );
            end if;

            if c.col013 is not null then
                pipe row ( new t_lov_entry(c.col013, 13) );
            end if;

            if c.col014 is not null then
                pipe row ( new t_lov_entry(c.col014, 14) );
            end if;

            if c.col015 is not null then
                pipe row ( new t_lov_entry(c.col015, 15) );
            end if;

            if c.col016 is not null then
                pipe row ( new t_lov_entry(c.col016, 16) );
            end if;

            if c.col017 is not null then
                pipe row ( new t_lov_entry(c.col017, 17) );
            end if;

            if c.col018 is not null then
                pipe row ( new t_lov_entry(c.col018, 18) );
            end if;

            if c.col019 is not null then
                pipe row ( new t_lov_entry(c.col019, 19) );
            end if;

            if c.col020 is not null then
                pipe row ( new t_lov_entry(c.col020, 20) );
            end if;

            if c.col021 is not null then
                pipe row ( new t_lov_entry(c.col021, 21) );
            end if;

            if c.col022 is not null then
                pipe row ( new t_lov_entry(c.col022, 22) );
            end if;

            if c.col023 is not null then
                pipe row ( new t_lov_entry(c.col023, 23) );
            end if;

            if c.col024 is not null then
                pipe row ( new t_lov_entry(c.col024, 24) );
            end if;

            if c.col025 is not null then
                pipe row ( new t_lov_entry(c.col025, 25) );
            end if;

            if c.col026 is not null then
                pipe row ( new t_lov_entry(c.col026, 26) );
            end if;

            if c.col027 is not null then
                pipe row ( new t_lov_entry(c.col027, 27) );
            end if;

            if c.col028 is not null then
                pipe row ( new t_lov_entry(c.col028, 28) );
            end if;

            if c.col029 is not null then
                pipe row ( new t_lov_entry(c.col029, 29) );
            end if;

            if c.col030 is not null then
                pipe row ( new t_lov_entry(c.col030, 30) );
            end if;

            if c.col031 is not null then
                pipe row ( new t_lov_entry(c.col031, 31) );
            end if;

            if c.col032 is not null then
                pipe row ( new t_lov_entry(c.col032, 32) );
            end if;

            if c.col033 is not null then
                pipe row ( new t_lov_entry(c.col033, 33) );
            end if;

            if c.col034 is not null then
                pipe row ( new t_lov_entry(c.col034, 34) );
            end if;

            if c.col035 is not null then
                pipe row ( new t_lov_entry(c.col035, 35) );
            end if;

            if c.col036 is not null then
                pipe row ( new t_lov_entry(c.col036, 36) );
            end if;

            if c.col037 is not null then
                pipe row ( new t_lov_entry(c.col037, 37) );
            end if;

            if c.col038 is not null then
                pipe row ( new t_lov_entry(c.col038, 38) );
            end if;

            if c.col039 is not null then
                pipe row ( new t_lov_entry(c.col039, 39) );
            end if;

            if c.col040 is not null then
                pipe row ( new t_lov_entry(c.col040, 40) );
            end if;

            if c.col041 is not null then
                pipe row ( new t_lov_entry(c.col041, 41) );
            end if;

            if c.col042 is not null then
                pipe row ( new t_lov_entry(c.col042, 42) );
            end if;

            if c.col043 is not null then
                pipe row ( new t_lov_entry(c.col043, 43) );
            end if;

            if c.col044 is not null then
                pipe row ( new t_lov_entry(c.col044, 44) );
            end if;

            if c.col045 is not null then
                pipe row ( new t_lov_entry(c.col045, 45) );
            end if;

            if c.col046 is not null then
                pipe row ( new t_lov_entry(c.col046, 46) );
            end if;

            if c.col047 is not null then
                pipe row ( new t_lov_entry(c.col047, 47) );
            end if;

            if c.col048 is not null then
                pipe row ( new t_lov_entry(c.col048, 48) );
            end if;

            if c.col049 is not null then
                pipe row ( new t_lov_entry(c.col049, 49) );
            end if;

            if c.col050 is not null then
                pipe row ( new t_lov_entry(c.col050, 50) );
            end if;

        end loop;

        return;
    exception
        when no_data_needed then
            raise; -- Standardverhalten für Pipelined Functions, kein Logging!
        when e_datei_leer then
            null; -- damit muss sich der APEX-Wizard beschäftigen;
              -- im Fall von RAISE wäre eine Endlos-Fehlerschleife mit APEX Error Page die Folge!
              -- @weiter 2024-01-04: Error Page wird nun zwar vermieden, aber der Wizard muss noch selbst herausfinden, dass die Datei leer ist
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end;
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
 * @param pon_zeilennummer    Falls gefüllt, ist dies die Nummer der Zeile, in der die gesuchte Überschrift gefunden wurde
 * @param pon_spaltennummer   Falls gefüllt, ist dies die Nummer der Spalte, in der die gesuchte Überschrift gefunden wurde
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
    ) is
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'p_finde_spalte_in_csv_header';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pib_blob_content (length)',
                             dbms_lob.getlength(pib_blob_content));
            pck_format.p_add('piv_dateiname', piv_dateiname);
            pck_format.p_add('piv_suchmuster', piv_suchmuster);
            pck_format.p_add('pin_zeilennummer', pin_zeilennummer);
            pck_format.p_add('piv_spaltentrenner', piv_spaltentrenner);
            pck_format.p_add('piv_zeilentrenner', piv_zeilentrenner);
            pck_format.p_add('pin_scan_zeilen', pin_scan_zeilen);
        -- (OUT): pon_zeilennummer
        -- (OUT): pon_spaltennummer
        -- (OUT): pov_spaltenname
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------      
        function treffer (
            i_spaltenname   in varchar2,
            i_zeilennummer  in naturaln,
            i_spaltennummer in naturaln
        ) return boolean is
        begin
            if upper(i_spaltenname) like upper(piv_suchmuster) then
                pon_zeilennummer := i_zeilennummer;
                pon_spaltennummer := i_spaltennummer;
                pov_spaltenname := i_spaltenname;
                return true;
            end if;

            return false;
        end treffer;

    begin
        if pib_blob_content is null then
            raise_application_error(c_plausi_error_number, 'Datei ist leer');
        end if;
        << column_scan >> for zeile in (
            select
                line_number,
                col001,
                col002,
                col003,
                col004,
                col005,
                col006,
                col007,
                col008,
                col009,
                col010,
                col011,
                col012,
                col013,
                col014,
                col015,
                col016,
                col017,
                col018,
                col019,
                col020,
                col021,
                col022,
                col023,
                col024,
                col025,
                col026,
                col027,
                col028,
                col029,
                col030,
                col031,
                col032,
                col033,
                col034,
                col035,
                col036,
                col037,
                col038,
                col039,
                col040,
                col041,
                col042,
                col043,
                col044,
                col045,
                col046,
                col047,
                col048,
                col049,
                col050
            from
                table ( apex_data_parser.parse(
                    p_content   => pib_blob_content,
                    p_file_name => piv_dateiname,
                    p_max_rows  => pin_scan_zeilen
                ) )
            where
                pin_zeilennummer is null
                or line_number = pin_zeilennummer
        ) loop
            if treffer(zeile.col001, zeile.line_number, 1) then
                return;
            end if;

            if treffer(zeile.col002, zeile.line_number, 2) then
                return;
            end if;

            if treffer(zeile.col003, zeile.line_number, 3) then
                return;
            end if;

            if treffer(zeile.col004, zeile.line_number, 4) then
                return;
            end if;

            if treffer(zeile.col005, zeile.line_number, 5) then
                return;
            end if;

            if treffer(zeile.col006, zeile.line_number, 6) then
                return;
            end if;

            if treffer(zeile.col007, zeile.line_number, 7) then
                return;
            end if;

            if treffer(zeile.col008, zeile.line_number, 8) then
                return;
            end if;

            if treffer(zeile.col009, zeile.line_number, 9) then
                return;
            end if;

            if treffer(zeile.col010, zeile.line_number, 10) then
                return;
            end if;

            if treffer(zeile.col011, zeile.line_number, 11) then
                return;
            end if;

            if treffer(zeile.col012, zeile.line_number, 12) then
                return;
            end if;

            if treffer(zeile.col013, zeile.line_number, 13) then
                return;
            end if;

            if treffer(zeile.col014, zeile.line_number, 14) then
                return;
            end if;

            if treffer(zeile.col015, zeile.line_number, 15) then
                return;
            end if;

            if treffer(zeile.col016, zeile.line_number, 16) then
                return;
            end if;

            if treffer(zeile.col017, zeile.line_number, 17) then
                return;
            end if;

            if treffer(zeile.col018, zeile.line_number, 18) then
                return;
            end if;

            if treffer(zeile.col019, zeile.line_number, 19) then
                return;
            end if;

            if treffer(zeile.col020, zeile.line_number, 20) then
                return;
            end if;

            if treffer(zeile.col021, zeile.line_number, 21) then
                return;
            end if;

            if treffer(zeile.col022, zeile.line_number, 22) then
                return;
            end if;

            if treffer(zeile.col023, zeile.line_number, 23) then
                return;
            end if;

            if treffer(zeile.col024, zeile.line_number, 24) then
                return;
            end if;

            if treffer(zeile.col025, zeile.line_number, 25) then
                return;
            end if;

            if treffer(zeile.col026, zeile.line_number, 26) then
                return;
            end if;

            if treffer(zeile.col027, zeile.line_number, 27) then
                return;
            end if;

            if treffer(zeile.col028, zeile.line_number, 28) then
                return;
            end if;

            if treffer(zeile.col029, zeile.line_number, 29) then
                return;
            end if;

            if treffer(zeile.col030, zeile.line_number, 30) then
                return;
            end if;

            if treffer(zeile.col031, zeile.line_number, 31) then
                return;
            end if;

            if treffer(zeile.col032, zeile.line_number, 32) then
                return;
            end if;

            if treffer(zeile.col033, zeile.line_number, 33) then
                return;
            end if;

            if treffer(zeile.col034, zeile.line_number, 34) then
                return;
            end if;

            if treffer(zeile.col035, zeile.line_number, 35) then
                return;
            end if;

            if treffer(zeile.col036, zeile.line_number, 36) then
                return;
            end if;

            if treffer(zeile.col037, zeile.line_number, 37) then
                return;
            end if;

            if treffer(zeile.col038, zeile.line_number, 38) then
                return;
            end if;

            if treffer(zeile.col039, zeile.line_number, 39) then
                return;
            end if;

            if treffer(zeile.col040, zeile.line_number, 40) then
                return;
            end if;

            if treffer(zeile.col041, zeile.line_number, 41) then
                return;
            end if;

            if treffer(zeile.col042, zeile.line_number, 42) then
                return;
            end if;

            if treffer(zeile.col043, zeile.line_number, 43) then
                return;
            end if;

            if treffer(zeile.col044, zeile.line_number, 44) then
                return;
            end if;

            if treffer(zeile.col045, zeile.line_number, 45) then
                return;
            end if;

            if treffer(zeile.col046, zeile.line_number, 46) then
                return;
            end if;

            if treffer(zeile.col047, zeile.line_number, 47) then
                return;
            end if;

            if treffer(zeile.col048, zeile.line_number, 48) then
                return;
            end if;

            if treffer(zeile.col049, zeile.line_number, 49) then
                return;
            end if;

            if treffer(zeile.col050, zeile.line_number, 50) then
                return;
            end if;

        end loop;

    exception
        when e_datei_leer then
            null; -- damit muss sich der APEX-Wizard beschäftigen;
              -- im Fall von RAISE wäre eine Endlos-Fehlerschleife mit APEX Error Page die Folge!
        when others then
            if sqlcode <> c_plausi_error_number then
                pck_logs.p_error(
                    pic_message      => fcl_params(),
                    piv_routine_name => cv_routine_name,
                    piv_scope        => g_scope
                );
            end if;

            raise;
    end p_finde_spalte_in_csv_header;
/**
 * Ordnet ein Objekt einem Vermarktungscluster zu oder löscht die Zuordnung.
 * Per Modus-Parameter kann bestimmt werden,
 * ob bei Neuzuordnung die bestehende Zuordnung aufgehoben wird (default),
 * eine weitere Verknüpfung hinzugefügt wird (//// darf ab 2022-10 nicht mehr funktionieren),
 * oder die Funktion eine Exception wirft. 
 * Die ID der Verknüpfung aus der Tabelle VERMARKTUNGSCLUSTER_OBJEKT wird zurückgegeben.
 * Besteht die gewünschte Zuordnung bereits, wird keine DML-Aktion ausgeführt (da überflüssig),
 * stattdessen wird nur die existierende ID zurückgegeben. 
 *
 * @param pin_haus_lfd_nr  ID des Objekts, das zugeordnet werden soll
 * @param pin_vc_lfd_nr    ID des Vermarktungsclusters, mit dem das Objekt nun verknüpft werden soll.
 *                         Falls NULL und pin_modus = AUFHEBEN, wird eine bestehende Verknüpfung gelöscht.
 * @param pin_modus        Angewendete Geschäftslogik, siehe: C_MODUS_AUFHEBEN|C_MODUS_INITIAL|C_MODUS_ALTERNATIV|C_MODUS_MEHRFACH
 *
 * @return  ID der neuen Verknüpfung aus Tabelle VERMARKTUNGSCLUSTER_OBJEKT
 * @return  NULL, wenn die Verknüpfung aufgehoben wurde
 *
 * @exception  USER DEFINED (-20001): Verstoß gegen Geschäftsregel
 */
    function fn_objekt_zuordnen (
        pin_haus_lfd_nr in vermarktungscluster_objekt.haus_lfd_nr%type,
        pin_vc_lfd_nr   in vermarktungscluster_objekt.vc_lfd_nr%type,
        pin_modus       in t_config_smallint
    ) return vermarktungscluster_objekt.vco_lfd_nr%type is

        v_haus_lfd_nr              haus.haus_lfd_nr%type;
        vn_max_cluster_lfd_nr      vermarktungscluster_objekt.vc_lfd_nr%type;
        vn_anzahl_zuordnungen      natural;
        vn_existierende_vco_lfd_nr natural;
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name            constant logs.routine_name%type := 'fn_objekt_zuordnen';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_haus_lfd_nr', pin_haus_lfd_nr);
            pck_format.p_add('pin_vc_lfd_nr', pin_vc_lfd_nr);
            pck_format.p_add('pin_modus', pin_modus);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------         
    begin
        -- Plausi-Checks:
        if pin_haus_lfd_nr is null -- AND pin_modus <> C_MODUS_AUFHEBEN 
         then
            -- (2022-11-02: Es _IST_ also auch ein Fehler, die nicht bestehenden Verknüpfungen einer leeren HAUS_LFD_NR zu löschen)
            raise_application_error(c_plausi_error_number, 'Zuordnung einer leeren HAUS_LFD_NR kann nicht bearbeitet werden');
        end if;
        if
            pin_vc_lfd_nr is null
            and ( pin_modus is null
                  or pin_modus <> c_modus_aufheben )
        then
            raise_application_error(c_plausi_error_number, 'Vermarktungscluster für Zuordnung von HAUS_LFD_NR '
                                                           || pin_haus_lfd_nr
                                                           || ' fehlt');
        end if;

        if pin_modus = c_modus_aufheben then
        /*
          DELETE VERMARKTUNGSCLUSTER_OBJEKT 
           WHERE haus_lfd_nr = pin_haus_lfd_nr;
        */ -- stattdessen das offizielle DML-Package benutzen:
            p_delete_haus_zuordnungen(pin_haus_lfd_nr);
            return null;
        end if;
        if pin_modus = c_modus_einfach then
          -- In jedem Fall eine ggf. bestehende Zuordnung löschen
          -- DELETE VERMARKTUNGSCLUSTER_OBJEKT 
          -- WHERE haus_lfd_nr = pin_haus_lfd_nr;
          -- -- stattdessen das offizielle DML-Package benutzen:
            p_delete_haus_zuordnungen(pin_haus_lfd_nr);
        end if;
        begin
            select
                h.haus_lfd_nr,
                count(distinct vco.vco_lfd_nr) as anzahl_zuordnungen,
                max(vco.vc_lfd_nr)             as max_cluster,
                (
                    select
                        max(vco_lfd_nr)
                    from
                        vermarktungscluster_objekt
                    where
                            haus_lfd_nr = pin_haus_lfd_nr
                        and vc_lfd_nr = pin_vc_lfd_nr
                )                              as existierende_vco_lfd_nr
            into
                v_haus_lfd_nr,
                vn_anzahl_zuordnungen,
                vn_max_cluster_lfd_nr,
                vn_existierende_vco_lfd_nr
            from
                haus                       h
                left join vermarktungscluster_objekt vco on ( vco.haus_lfd_nr = h.haus_lfd_nr )
            where
                h.haus_lfd_nr = pin_haus_lfd_nr
            group by
                h.haus_lfd_nr;

        exception
            when no_data_found then -- das Haus gibt es nicht in Tabelle HAUS:
                raise_application_error(c_plausi_error_number, 'HAUS_LFD_NR '
                                                               || pin_haus_lfd_nr
                                                               || ' existiert nicht');
        end;
        -- Geschäftsregeln
        ------------------------------------------------------------------------
        -- Sofern die Verküpfung bereits existiert, wird nur die bestehende ID
        -- zurückgegeben, aber keine DML-Operation durchgeführt
        if vn_existierende_vco_lfd_nr is not null then
            if monitoring_aktiv then
                pck_logs.p_error(
                    pic_message      => 'vn_existierende_vco_lfd_nr: ' || vn_existierende_vco_lfd_nr,
                    piv_routine_name => '/// ' || cv_routine_name,
                    piv_scope        => g_scope
                );
            end if;

            return vn_existierende_vco_lfd_nr;
        end if;
        ------------------------------------------------------------------------
        -- Eine neue Verknüpfung soll angelegt werden, weil die gewünschte
        -- noch nicht existiert.
        ------------------------------------------------------------------------
        /* 2022-10-25 Diese prüfung wurde auskommentiert, da aufgrund @ticket FTTH-561
           das Umhängen eines Objekts zu einem anderen Vermarkungscluster IMMER
           ohne zu Nörgeln funktionieren soll.

        -- 0) C_MODUS_EINFACH: Bei bereits bestehender Zuordnung ist
        --    kein Umhängen erlaubt. Fehler ausgeben.
        IF
            vn_anzahl_zuordnungen >= 1
            AND pin_modus = C_MODUS_EINFACH
        THEN
            raise_application_error(c_plausi_error_number, 'Es besteht bereits eine Zuordnung zu einem Vermarktungscluster ' --
                                                           || '(HAUS_LFD_NR='
                                                           || pin_haus_lfd_nr
                                                           || ', VC_LFD_NR='
                                                           || vn_max_cluster_lfd_nr
                                                           || ')');
        END IF;
        */
        -- 1) C_MODUS_ALTERNATIV: Bereits bestehende Zuordnungen werden aufgehoben
        -- und stattdessen die neue eingerichtet (@ticket https://jira.netcologne.intern/browse/FTTH-561)
        if
            vn_anzahl_zuordnungen > 0
            and pin_modus = c_modus_alternativ -- Standard: Umhängen
        then
            p_delete_haus_zuordnungen(pin_haus_lfd_nr);
        end if;

        -- 2) C_MODUS_MEHRFACH erfordert keine weiteren Aktionen, allerdings ist es aus dem 
        -- Datenmodell nicht ersichtlich, ob die Mehrfachzuordnung überhaupt sinnvoll ist.
        -- Denn es existiert kein Unique Key auf VERMARKRUNGSCLUSTER_OBJEKT.HAUS_LFD_NR,
        -- jedoch spricht das @ticket FTTH-561 von einer Regel "pro Objekt maximal ein Vermarktungscluster"
        -- (also ist dies vermutlich "weich" in der APEX-App 1210 implementiert)

        -- Eintragen der neuen Zuordnung:
        return fn_insert_haus_zuordnung(
            pin_haus_lfd_nr => pin_haus_lfd_nr,
            pin_vc_lfd_nr   => pin_vc_lfd_nr
        );
    exception
        when others then
            -- Plausi-Fehler werden nicht hier, sondern gegebenenfalls
            -- vom aufrufenden Programm geloggt.
            if monitoring_aktiv
            or ( sqlcode <> c_plausi_error_number ) then
                pck_logs.p_error(
                    pic_message      => fcl_params(),
                    piv_routine_name => cv_routine_name,
                    piv_scope        => g_scope
                );
            end if;

            raise;
    end fn_objekt_zuordnen;
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
 * @date 2023-04-04 Parameter pin_modus ist nicht mehr optional  
 */
    procedure p_objekt_zuordnen (
        pin_haus_lfd_nr in vermarktungscluster_objekt.haus_lfd_nr%type,
        pin_vc_lfd_nr   in vermarktungscluster_objekt.vc_lfd_nr%type,
        pin_modus       in t_config_smallint
    ) is

        void_vco_lfd_nr vermarktungscluster_objekt.vco_lfd_nr%type;
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'p_objekt_zuordnen';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_haus_lfd_nr', pin_haus_lfd_nr);
            pck_format.p_add('pin_vc_lfd_nr', pin_vc_lfd_nr);
            pck_format.p_add('pin_modus', pin_modus);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------         
    begin
        void_vco_lfd_nr := fn_objekt_zuordnen(
            pin_haus_lfd_nr => pin_haus_lfd_nr,
            pin_vc_lfd_nr   => pin_vc_lfd_nr,
            pin_modus       => pin_modus
        );
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end p_objekt_zuordnen;
/**
 * Gibt die Anzahl der Zeilen in einer APEX Collection zurück, deren Spalte N001
 * den Wert 1 besitzt (i.e. Checkboxen, die angehakt sind)
 *
 * @param piv_collection_name  Name der Collection, die die Checkboxen speichert
 */
    function fn_count_checked_members (
        piv_collection_name in apex_collections.collection_name%type
    ) return naturaln is
        v_count natural;
    begin
        select
            count(*)
        into v_count
        from
            apex_collections
        where
                collection_name = piv_collection_name
            and n002 = 1;

        return v_count;
    end fn_count_checked_members;

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
        deterministic
    is
    begin
    -- Plausi Shortcut:
        if piv_aktueller_status is null then
      -- Der initiale Status kann beim Anlegen aus allen Werten gewählt werden:
            return 'AREAPLANNED,PREMARKETING,UNDERCONSTRUCTION';
        end if;

    -- Welche Status sind erlaubt
        case upper(piv_aktueller_status)
            when vc_status_areaplanned then
                return 'AREAPLANNED,PREMARKETING,UNDERCONSTRUCTION';
            when vc_status_premarketing then
                return 'PREMARKETING,UNDERCONSTRUCTION';
            when vc_status_underconstruction then
                return 'UNDERCONSTRUCTION'; -- final, kein anderer Status erlaubt
            else
                raise_application_error(-20002, 'Status "'
                                                || piv_aktueller_status
                                                || '" für Vermarktungscluster nicht definiert');
        end case;

    end fv_vc_folgestatus;
/**
 * Gibt den Display-Wert für einen Vermarktungscluster-Status zurück (PascalCase)
 * 
 * @param piv_status [IN ] Statuswert, der in der Tabelle VERMARKTUNGSCLUSTER verwendet wird:
 *                         ZUSAMMENGROSSGESCHRIEBEN
 *
 * @return
 * Jeder unbekannte Wert wird 1:1 zurückgegeben.
 * Status NULL ergibt Statusdisplay NULL.
 */
    function fv_vc_status_display (
        piv_status vermarktungscluster.status%type
    ) return varchar2
        deterministic
    is
    begin
        return
            case upper(trim(piv_status))
                when vc_status_areaplanned then
                    'AreaPlanned'
                when vc_status_premarketing then
                    'PreMarketing'
                when vc_status_underconstruction then
                    'UnderConstruction'
                else piv_status
            end;
    end fv_vc_status_display; 

/**
 * Gibt den vom Webservice erwarteten Statuswert zurück, siehe @ticket FTTH-1972
 * 
 * @param piv_status [IN ] Statuswert, der in der Tabelle VERMARKTUNGSCLUSTER verwendet wird:
 *                         ZUSAMMENGROSSGESCHRIEBEN
 *
 * @return
 * Jeder unbekannte Wert wird 1:1 zurückgegeben.
 * Status NULL ergibt Statusdisplay NULL.
 */
    function fv_vc_status_webservice (
        piv_status vermarktungscluster.status%type
    ) return varchar2
        deterministic
    is
    begin
  /*
    -- in Version 0.05 der Spezifikation wurde wieder alles geändert :-(
    RETURN CASE upper(trim(piv_status))
           WHEN VC_STATUS_AREAPLANNED       THEN 'AREA_PLANNED'
           WHEN VC_STATUS_PREMARKETING      THEN 'PRE_MARKETING'
           WHEN VC_STATUS_UNDERCONSTRUCTION THEN 'UNDER_CONSTRUCTION'
           ELSE piv_status
           END;
    -- Stand vom 2023-07-11:
    RETURN CASE upper(trim(piv_status))
           WHEN VC_STATUS_AREAPLANNED       THEN 'AreaPlanned'
           WHEN VC_STATUS_PREMARKETING      THEN 'PreMarketing'
           WHEN VC_STATUS_UNDERCONSTRUCTION THEN 'UnderConstruction'
           ELSE piv_status
           END;  
  */  
    -- vorläufiger neuester Stand:
        return
            case upper(trim(piv_status))
                when vc_status_areaplanned then
                    'AREA_PLANNED'
                when vc_status_premarketing then
                    'PRE_MARKETING'
                when vc_status_underconstruction then
                    'UNDER_CONSTRUCTION'
                else piv_status
            end;
    end fv_vc_status_webservice;   

/**  
 * Ändert den Status eines Vermarktungsclusters
 *
 * @param pin_vc_lfd_nr  [IN ] PK des Vermarktungsclusters
 * @param piv_status_alt [IN ] Bestehender Status in der exakten Schreibweise von VERMARKTUNGSCLUSTER.STATUS.
 *                             Dient 
 *                             a) zur Überprüfung, ob bei Verwendung des DML-Packages die unvermeidliche
 *                             Verzögerung zwischen Aufruf der APEX-Seite, hiesigem SELECT und nachfolgendem UPDATE
 *                             dazu geführt hat, dass inzwischen Concurrent Updates stattgefunden haben 
 *                             (durchaus möglich),
 *                             b) zur Überprüfung, ob der beabsichtigte Folgestatus erlaubt ist.
 *                             Nur wenn diese prüfungen ausdrücklich nicht erwünscht sind, darf
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
    ) is

        vr_vermarktungscluster vermarktungscluster%rowtype;
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name        constant logs.routine_name%type := 'p_update_status';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_vc_lfd_nr', pin_vc_lfd_nr);
            pck_format.p_add('piv_status_alt', piv_status_alt);
            pck_format.p_add('piv_status_neu', piv_status_neu);
            pck_format.p_add('piv_username', piv_username);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
  -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------     
    begin
    -- Plausi alter Wert:
        if piv_status_alt is null then -- Kein Status darf NULL sein,
    -- leider ist das nicht durch einen Constraint abgesichert
            raise_application_error(c_plausi_error_number, 'Bestehender Status des Vermarktungsclusters wurde nicht mitgeteilt');
        end if;

    -- Plausi neuer Wert:
        if piv_status_neu is null then
            raise_application_error(c_plausi_error_number, 'Leerer Status nicht erlaubt für Vermarktungscluster');
        end if;

    -- Plausi Primary Key:
        if pin_vc_lfd_nr is null then
            raise_application_error(c_plausi_error_number, 'Statuswechsel nicht möglich: VC_LFD_NR ist leer');
        end if;

    -- Aktuelle Daten lesen (das DML-Package will es so)
        select
            *
        into vr_vermarktungscluster
        from
            vermarktungscluster
        where
            vc_lfd_nr = pin_vc_lfd_nr;

    -- Plausi alter Wert vs frisch gelesener Wert:
        if nvl(vr_vermarktungscluster.status, '-') <> piv_status_alt then
            raise_application_error(c_plausi_error_number, 'Der Status des Vermarktungsclusters wurde bereits von anderer Stelle geändert'
            );
        end if;

    -- Plausi Folgestatus:
    -- ///// @todo: Eigene Funktion hierfür bauen. Dieser simple Algorithmus
    -- funktioniert nur, solange keiner der Status literal in irgendeinem anderen
    -- enthalten ist
        if pck_vermarktungscluster.fv_vc_folgestatus(piv_aktueller_status => vr_vermarktungscluster.status) not like '%'
                                                                                                                     || piv_status_neu
                                                                                                                     || '%' then
            raise_application_error(c_plausi_error_number, 'Der Status des Vermarktungsclusters wurde bereits von anderer Stelle geändert'
            );
        end if;
    -- Keine Bedenken, dann Status aktualisieren.
        vr_vermarktungscluster.status := piv_status_neu;
        pck_vermarktungscluster_dml.p_update(
            pir_vermarktungscluster => vr_vermarktungscluster,
            piv_art                 => 'ALL' -- muss leider hier hartkodiert werden.
        );

    -- Aufruf Webservice, @ticket FTTH-1787
        if piv_status_neu = vc_status_underconstruction then
      -- Wenn der Webservice-Aufruf nicht gelingt, darf der Status nicht geändert werden:
            if not fb_ws_vermarktungscluster_objektmeldung(
                pin_vc_lfd_nr   => pin_vc_lfd_nr,
                pit_objektliste => null,
                piv_username    => piv_username
            ) then
                raise_application_error(c_ws_error_number, 'Die Statusänderung kann nicht durchgeführt werden: Der REST Webservice-Aufruf lieferte einen Fehler zurück'
                );
            end if;
        end if;

    exception
        when others then
            if sqlcode <> c_plausi_error_number then
                pck_logs.p_error(
                    pic_message      => fcl_params(),
                    piv_routine_name => cv_routine_name,
                    piv_scope        => g_scope
                );
            end if;

            raise;
    end p_update_status;
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
 * @param pib_force_update [IN ] Wenn TRUE, wird der REST-Aufruf in jedem Fall durchgeführt,
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
    ) return boolean is

        v_vc_status             vermarktungscluster.status%type;
        v_vc_ausbau_plan_termin vermarktungscluster.ausbau_plan_termin%type;
        v_ws_statuscode         integer;
        v_returnvalue           boolean;
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name         constant logs.routine_name%type := 'fb_ws_vermarktungscluster_objektmeldung';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_vc_lfd_nr', pin_vc_lfd_nr);
            pck_format.p_add('pit_objektliste',
                             print(pit_objektliste));
            pck_format.p_add('piv_username', piv_username);
            pck_format.p_add('pin_force_update', pin_force_update);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
  -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 

    begin
    -- Plausi 1:
        if pin_vc_lfd_nr is null then
            raise_application_error(c_plausi_error_number, 'Vermarktungscluster für Objektzuordnung ist NULL');
        end if;

    -- Plausi 2: Inhalt der Liste prüfen
    -- Entfällt, weil...
              -- 2023-07-12: Aufgrund der immer bestehenden Problematik, 
              -- dass der synchronisierte POB quasi nie ganz aktuell sein dürfte,
              -- muss dazu übergegangen werden, jedes Mal die komplette Zuordnungsliste 
              -- des Vermarktungsclusters zu senden, und nicht nur die neu hinzugefügten Adressen.
              -- Von daher wird die v_objektliste bis auf Weiteres ignoriert.
              -- Der POB-Server aktualisiert nur diejenigen HAUS_LFD_NRn, die er kennt.    
    /*
    IF pit_objektliste IS NOT NULL AND pit_objektliste.count = 0 THEN -- 0 ist nicht gleich NULL!
        RAISE_APPLICATION_ERROR(C_PLAUSI_ERROR_NUMBER,
        'Objektliste für Zuordnung zum Vermarktungscluster ist leer');      
    END IF;
    */
    -- Plausi 3: Status des Vermarktungsclusters auslesen
        begin
            select
                status,
                ausbau_plan_termin
            into
                v_vc_status,
                v_vc_ausbau_plan_termin
            from
                vermarktungscluster
            where
                vc_lfd_nr = pin_vc_lfd_nr;

        exception
            when no_data_found then
                raise_application_error(c_plausi_error_number, 'Vermarktungscluster mit VC_LFD_NR "'
                                                               || pin_vc_lfd_nr
                                                               || '" existiert nicht');
        end;
    -- Geschäftsregel: Nur wenn Status = UNDERCONSTRUCTION, muss die Objektliste
    -- dem Webservice mitgeteilt werden. In allen anderen Fällen gibt die 
    -- Funktion per se NULL zurück.

        if pin_force_update > 0
        or v_vc_status in ( vc_status_underconstruction ) then
    -- Objektliste zusammenstellen und an WS senden
            declare
                vj_marketing_status_update json_object_t := new json_object_t('{}');
                vj_haus_lfd_nr_liste       json_array_t := new json_array_t('[]');
                vt_objektliste             t_objektliste;
            begin
      ---IF pit_objektliste IS NOT NULL THEN
          -- Liste wurde gefüllt übergeben:

      ---    vt_objektliste := pit_objektliste;
      ---  ELSE
          -- Es wurde keine Liste übergeben
          -- bzw Liste wird seit 2023-07-12 ignoriert:
          -- Ermittle die aktuellen Objekte selbst, egal ob sie im POB vorkommen oder nicht
                vt_objektliste := t_objektliste();
                for obj in (
                    select
                        haus_lfd_nr
                    from
                        vermarktungscluster_objekt
                    where
                        vc_lfd_nr = pin_vc_lfd_nr
                    order by
                        1
                ) loop
                    vt_objektliste.extend();
                    vt_objektliste(vt_objektliste.count) := obj.haus_lfd_nr;
                end loop;
        ---END IF;

        -- Leere Liste darf nicht an den Webservice gesendet werden,
        -- da dieser sonst mit einem HTTP Status 400 (Bad Request) antwortet
                if vt_objektliste.count > 0 then
          -- Liste auslesen und in JSON umwandeln:
                    for i in 1..vt_objektliste.count loop
                        vj_haus_lfd_nr_liste.append(vt_objektliste(i));
                    end loop;
          -- Webservice aufrufen und Antwort auswerten
                    vj_marketing_status_update.put('status',
                                                   fv_vc_status_webservice(v_vc_status));
          -- @ticket FTTH-1972 FTTH-2023-04-25: zusätzlich auch das Plandatum mitsenden:
                    vj_marketing_status_update.put('availabilityDate',
                                                   to_char(v_vc_ausbau_plan_termin, 'YYYY-MM-DD'));
                    vj_marketing_status_update.put('houseSerialNumberList', vj_haus_lfd_nr_liste);

          -- Rest Call durchführen
                    pck_pob_rest.p_vermarktungscluster_objektmeldung_post(
                        pic_body        => vj_marketing_status_update.to_clob,
                        piv_username    => piv_username,
                        piv_application => g_application
                    );

                end if;
        -- ///// Return-Status auswerten
            end;

            v_returnvalue := true;
        end if;

        return v_returnvalue; -- NULL, falls kein Aufruf stattfand
    exception
        when e_plausi then
            raise;
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name
            );
            raise;
    end fb_ws_vermarktungscluster_objektmeldung;

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/**
 * Ordnet alle in der Collection P4_CHECKBOX angehakten HAUS_LFD_NRn 
 * dem Vermarktungscluster zu
 *
 * @ticket FTTH-1787: Wenn der Vermarktungscluster UNDERCONSTRUCTION ist, 
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
    ) is
        v_zaehler     naturaln := 0;
        v_objektliste t_objektliste := t_objektliste();
    begin
        -- Schritt 1: Alle Objekte in eine statische Liste einlesen,
        -- damit diese konsistent weiterbenutzt werden kann
        for c in (
            select
                n001 as haus_lfd_nr
            from
                apex_collections
            where
                    collection_name = collection_p4_checkbox
                and n002 = 1
            order by
                1
        ) loop
            v_objektliste.extend();
            v_objektliste(v_objektliste.count) := c.haus_lfd_nr;
        end loop;

        if v_objektliste.count = 0 then
            raise_application_error(c_plausi_error_number, 'Sie haben keine Adressen ausgewählt');
        end if;

        -- Ab hier ist die Notwendigkeit eines Webservice-Calls gegeben.
        -- Schritt 2: Zuordnung durchführen (dies muss vor der Statusmeldung in Schritt 3 geschehen)
        for i in 1..v_objektliste.count loop
            p_objekt_zuordnen(
                pin_haus_lfd_nr => v_objektliste(i),
                pin_vc_lfd_nr   => pin_vc_lfd_nr,
                pin_modus       => c_modus_alternativ
            );
        end loop;

        -- Schritt 3: @ticket FTTH-1787
        -- Wenn bei einem bestehenden Vermarktungscluster im Status "Under Construction" 
        -- neue Objekte hinzugefügt werden, muss ebenfalls eine Mitteilung 
        -- mit der Liste der HAUD_LFD_NRn an den Preorder-Buffer gesendet werden.
        if not pck_vermarktungscluster.fb_ws_vermarktungscluster_objektmeldung(
            pin_vc_lfd_nr   => pin_vc_lfd_nr
              -- 2023-07-12: Aufgrund der immer bestehenden Problematik, 
              -- dass der synchronisierte POB quasi nie ganz aktuell sein dürfte,
              -- muss dazu übergegangen werden, jedes Mal die komplette Zuordnungsliste 
              -- des Vermarktungsclusters zu senden, und nicht nur die neu hinzugefügten Adressen.
              -- Von daher wird die v_objektliste bis auf Weiteres nicht mehr an die Objektmeldungs-Funktion gesendet.
              -- Der POB-Server aktualisiert nur diejenigen HAUS_LFD_NRn, die er kennt.
            ,
            pit_objektliste => null -- war: v_objektliste
            ,
            piv_username    => piv_username
        ) then
            raise_application_error(-20001, 'Die Zuordnung kann nicht durchgeführt werden: Der REST Webservice-Aufruf lieferte einen Fehler zurück'
            ); 
           -- //// welchen¿
        end if;

    end p_objektauswahl_vc_zuordnen;
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Nach dem Test entfernen:
/*
  PROCEDURE APEX_UNIT_TEST_FTTH_2162 (piv_username IN VARCHAR2)
  IS
    vn_test CONSTANT VERMARKTUNGSCLUSTER.VC_LFD_NR%TYPE := 5;
  BEGIN
    NULL;
    DELETE VERMARKTUNGSCLUSTER_OBJEKT WHERE VC_LFD_NR = vn_test;
    UPDATE VERMARKTUNGSCLUSTER SET STATUS = 'AREAPLANNED' WHERE VC_LFD_NR = vn_test;
    -- Neue Sätze einfügen:
    INSERT INTO VERMARKTUNGSCLUSTER_OBJEKT(vc_lfd_nr, inserted_by, haus_lfd_nr)
    SELECT vn_test, piv_username, haus_lfd_nr FROM VMC_UNIT_TEST_FTTH_2162;
  END APEX_UNIT_TEST_FTTH_2162;
*/  

/**
 * für das Fehler-Logging: Liefert die ersten 4000 Zeichen einer kommaseparierten
 * Liste mit HAUS_LFD_NRn, wie sie in diesem Package verwendet wird
 *
 * @param pit_objektliste [IN ]  Beliebig große TABLE OF NUMBER
 */
    function print (
        pit_objektliste t_objektliste
    ) return varchar2 
  --ACCESSIBLE BY (PACKAGE UT_VERMARKTUNGSCLUSTER)
     is

        c_ellipsis         constant varchar2(5) := '[...]';
        c_max_print_length constant naturaln := 4000;
        v_string           varchar2(32767);
        v_anzahl_elemente  natural;
        v_next_element     varchar2(100);
    begin
        if pit_objektliste is null then
            return null;
        end if;
        v_anzahl_elemente := pit_objektliste.count;
        if v_anzahl_elemente = 0 then
            return null;
        end if;
        v_string := to_char(pit_objektliste(1));
        if v_anzahl_elemente = 1 then
            return v_string;
        end if;
        << concatenation >> for i in 2..v_anzahl_elemente loop
            v_next_element := ',' || pit_objektliste(i);
            if length(v_string || v_next_element) <= c_max_print_length then
                v_string := v_string || v_next_element;
            else
        -- so viel wegschneiden, dass ',[...]' mindestens noch hinten dran passt:
                v_string := substr(v_string,
                                   1,
                                   c_max_print_length - 1 - length(c_ellipsis));
        -- dann auf die Stelle vor dem letzten Komma kürzen 
        -- (hierbei wird möglicherweise ein leeres Element unnötig weggeworfen,
        -- das ist aber letztlich wurscht)
                v_string := substr(v_string,
                                   1,
                                   instr(v_string, ',', -1) - 1)
                            || ','
                            || c_ellipsis;

                exit concatenation;
            end if;

        end loop;

        return v_string;
    end;

    procedure sanitize (
        pin_vc_lfd_nr in vermarktungscluster_objekt.vc_lfd_nr%type default null
    ) is
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'sanitize';

        function fcl_params return logs.message%type is
        begin
            return null; -- diese procedure besitzt keine Parameter
        end fcl_params;
  -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------   
    begin
    -- Alle Vermarktungscluster herausfinden, denen Objekte zugeordnet sind:
        for vc in (
            select distinct
                vc_lfd_nr
            from
                vermarktungscluster_objekt
            where
                ( pin_vc_lfd_nr is null
                  or vc_lfd_nr = pin_vc_lfd_nr )
            order by
                vc_lfd_nr
        ) loop
            if not fb_ws_vermarktungscluster_objektmeldung(
                pin_vc_lfd_nr   => vc.vc_lfd_nr,
                pit_objektliste => null -- ///// implementiert¿
                ,
                piv_username    => 'SAN'
            ) then
                raise_application_error(-20000, 'Sanitize fehlgeschlagen bei VC_LFD_NR=' || vc.vc_lfd_nr);
            end if;
        end loop;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => 'SAN'
            );

            raise;
    end sanitize;



/**
 * Refresht die Materialized View MV_VERMARKTUNGSCLUSTER_STATISTIK
 *
 * @usage Aufruf nächtlich durch Scheduler-Job "JOB_VERMARKTCLUSTER_STAT"
 */
    procedure p_statistik_aktualisieren is

        logging         constant boolean := true; -- FALSE: Nur die Materialized View wird aktualisiert,
                                      -- TRUE:  Zusätzlich wird ein Info-Eintrag in die Tabelle LOGS geschrieben
        v_time_start    date;
        v_count         natural;
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'p_statistik_aktualisieren';

        function fcl_params return logs.message%type is
        begin
            return null; -- diese procedure besitzt keine Parameter
        end fcl_params;
  -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------   
    begin
        v_time_start := sysdate; -- sekundengenau reicht
        dbms_mview.refresh('MV_VERMARKTUNGSCLUSTER_STATISTIK');
        if logging then
            select
                count(*)
            into v_count
            from
                mv_vermarktungscluster_statistik;

            pck_logs.p_set_log_level_info;
            pck_logs.p_info(
                pic_message      => 'MV_VERMARKTUNGSCLUSTER_STATISTIK aktualisiert: '
                               || ceil((sysdate - v_time_start) * 60 * 60 * 24)
                               || ' Sek.'
                               || ' / '
                               || v_count
                               || ' Zeilen',
                piv_routine_name => $$plsql_unit
                                    || '.'
                                    || cv_routine_name
            );

        end if;

    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => $$plsql_unit
                                    || '.'
                                    || cv_routine_name
            );

            raise;
    end p_statistik_aktualisieren;



/**  
 * Sendet eine Objektmeldung an den PreOrderbuffer für alle Vermarktungscluster,
 * die sich in der übergebenen Vermarktungscluster-Liste befinden
 *
 * @param piv_vc_liste [IN ] Kommaseparierte Liste mit Laufenden Nummern von Vermarktungsclustern
 *
 * @usage für jeden Vermarktungscluster wird nur ein einziges Update gesendet, 
 * auch wenn sich dessen Laufende Nummer mehrfach in der Liste befinden sollte
wird nicht mehr benötigt: ersetzt durch p_update_mit_meldung_pob
  PROCEDURE p_vermarktungscluster_meldung (piv_vc_liste IN VARCHAR2)
  IS
  BEGIN
  -- //////
  pck_logs.p_error('/// Liste: ' || piv_vc_liste); RETURN;

    -- Plausi:
    IF piv_vc_liste IS NULL THEN RETURN; END IF;

    FOR vc IN (
      SELECT DISTINCT column_value as LFD_NR
        FROM TABLE(APEX_STRING.SPLIT(TRIM(BOTH ',' FROM piv_vc_liste), ','))
       WHERE column_value IS NOT NULL
       ORDER BY 1
    ) LOOP
      IF NOT fb_ws_vermarktungscluster_objektmeldung(
          pin_vc_lfd_nr    => vc.lfd_nr
        , pit_objektliste  => NULL
        , piv_username     => '1210:1'
        , pin_force_update => TRUE -- da hier der Status des Vermarktungsclusters keine Rolle spielen darf
      ) THEN
        RAISE_APPLICATION_ERROR(C_WS_ERROR_NUMBER,
        'Die Änderung am Vermarktungscluster kann nicht durchgeführt werden: '
        || 'Der REST Webservice-Aufruf lieferte einen Fehler zurück');
      END IF;
    END LOOP;
  END p_vermarktungscluster_meldung;
 */


/**
 * Führt ein Update einer Vermarktungscluster-Zeile durch und ruft anschließend
 * (falls nötig, dies wird geprüft) einen Aufruf des Preorderbuffer Webservices auf. 
 * Wenn dieser fehlschlägt, wird das Update zurückgerollt und eine Exception geworfen.
 */
    procedure p_update_mit_meldung_pob (
        pir_vermarktungscluster in vermarktungscluster%rowtype
    ) is

        v_vermarktungscluster_alt vermarktungscluster%rowtype;
        vn_force_rest_update      natural;
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name           constant logs.routine_name%type := 'p_update_mit_meldung_pob';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pir_vermarktungscluster.vc_lfd_nr', pir_vermarktungscluster.vc_lfd_nr);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
  -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        if pir_vermarktungscluster.vc_lfd_nr is null then
            raise_application_error(c_plausi_error_number, 'Vermarktungscluster (VC_LFD_NR) ist leer');
        end if;

    -- Alte Werte retten, um die Notwendigkeit eines REST-Updates zu bestimmen:
        begin
            select
                *
            into v_vermarktungscluster_alt
            from
                vermarktungscluster
            where
                vc_lfd_nr = pir_vermarktungscluster.vc_lfd_nr;

        exception
            when no_data_found then
                raise_application_error(c_plausi_error_number, 'Vermarktungscluster (VC_LFD_NR='
                                                               || pir_vermarktungscluster.vc_lfd_nr
                                                               || ') wurde nicht gefunden');
        end;

    -- Aufruf der regulären Update-Routine:
        pck_vermarktungscluster_dml.p_update(
            pir_vermarktungscluster => pir_vermarktungscluster,
            piv_art                 => 'ALL'
        );
    -- Liegen Gründe für ein REST-Update vor¿
    -- für jeden Grund wird die Variable vn_rest_erforderlich um 1 erhöht.
        select -- 1.: Wenn ein neues Plandatum gesetzt wurde:
            decode(v_vermarktungscluster_alt.ausbau_plan_termin, pir_vermarktungscluster.ausbau_plan_termin, 0, 1)
           -- 2.: Wenn der Status auf UNDERCONSTRUCTION geändert wurde:
             +
            case
                when v_vermarktungscluster_alt.status != vc_status_underconstruction
                     and pir_vermarktungscluster.status = vc_status_underconstruction then
                        1
                else
                    0
            end
        into vn_force_rest_update
        from
            dual;

    -- Anschließend Meldung an den Webservice, falls es mindestens einen Grund dafür gibt (@ticket FTTH-2040)
        if vn_force_rest_update > 0 then
            if not fb_ws_vermarktungscluster_objektmeldung(
                pin_vc_lfd_nr    => pir_vermarktungscluster.vc_lfd_nr,
                pit_objektliste  => null,
                piv_username     => '1210:1',
                pin_force_update => vn_force_rest_update
                                -- da ja mindestens ein Grund vorliegt, 
                                -- den die Objektmeldung nicht mehr ermitteln soll
            ) then
                raise_application_error(c_ws_error_number, 'Die Änderung am Vermarktungscluster kann nicht durchgeführt werden: ' || 'Der REST Webservice-Aufruf lieferte einen Fehler zurück'
                );
            end if;
        end if;

    exception
        when e_plausi then
      -- nicht loggen
            raise;
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name
            );
            raise;
    end p_update_mit_meldung_pob;

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
    ) is
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'p_delete_haus_zuordnungen';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_vc_lfd_nr', pin_vc_lfd_nr);
            pck_format.p_add('pib_delete_vco', pib_delete_vco);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
        if pib_delete_vco then
            for zuordnung in (
                select
                    vco_lfd_nr -- ID
                from
                    vermarktungscluster_objekt
                where
                    vc_lfd_nr = pin_vc_lfd_nr
                order by
                    1
            ) loop
                pck_vermarktungsclstr_obj_dml.p_delete(pin_vco_lfd_nr => zuordnung.vco_lfd_nr);
            end loop;
        end if;
        -- Sollten Zuordnungen existieren, aber diese Löschung findet nicht statt, 
        -- dann wird dadurch (Stand: 2023-08) nicht verhindert,
        -- dass der Cluster dennoch gelöscht werden kann, denn es existiert kein Foreign Key
        -- zwischen VERMARKTUNGSCLUSTER_OBJEKT und VERMARKTUNGSCLUSTER.
        -- Die Folge wären verwaiste Zuordnungs-Datensätze (siehe Kommentar in FTTH-2636).
        -- //// @klären, ob ein FK hinzugefügt werden kann
        pck_vermarktungscluster_dml.p_delete(pin_vc_lfd_nr);
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end;  


-- @progress 2023-09-07 --------------------------------------------------------
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
 *
 * @example
 * BEGIN PCK_VERMARKTUNGSCLUSTER.siebel_ready_objekte_entfernen; END;
 * SELECT * FROM FTTH_LOG_SIEBEL_READY_VCO;
 */
    procedure siebel_ready_objekte_entfernen (
        pin_vc_lfd_nr in vermarktungscluster_objekt.vc_lfd_nr%type default null
    ) is
    -----------------------------------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------------------------
        testbetrieb     naturaln := 0; -- 0 = produktiver Betrieb, wo tatsächlich gelöscht wird 
                                  -- 1 = Testbetrieb (Löschkandidaten werden ermittelt, geloggt, aber nicht gelöscht)

    -- (diesen Parameter nach erfolgreicher Testphase auf 0 setzen, nach erfolgreicher Inbetriebnahme entfernen)
    -----------------------------------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------------------------

        v_count_loop    naturaln := 0;
        v_count_fehler  naturaln := 0;
        uhrzeit         ftth_log_siebel_ready_vco.datum%type := sysdate;
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'siebel_ready_objekte_entfernen';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_vc_lfd_nr', pin_vc_lfd_nr);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
  -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
    begin
    -- Alle Siebel-ready Objekte finden, die einem Vermarktungscluster zugeordnet sind:
        for objekte in (
            select
                vco_lfd_nr,
                haus_lfd_nr,
                vc_lfd_nr
            from
                v_ftth_vco_siebel_ready siebel
            where
                    siebel.ready = 1
                and vco_lfd_nr is not null -- dadurch werden bereits gelöschte nicht erneut "gelöscht"
         -- Eingangsparameter beachten:
                and ( pin_vc_lfd_nr is null
                      or pin_vc_lfd_nr = vc_lfd_nr )
         -----------------------------------------------------------------------
         -----------------------------------------------------------------------
         --- zumindest in der Testphase, wo das Löschen nur geloggt, aber nicht tatsächlich ausgeführt wird:
         --- nicht erneut löschen, wenn bereits gelöscht wurde
                and ( testbetrieb = 0
                      or haus_lfd_nr not in ( -- bereits zuvor "gelöschte":
                    select
                        haus_lfd_nr
                    from
                        ftth_log_siebel_ready_vco
                    where
                        fehler is null
                ) )
         -----------------------------------------------------------------------
         -----------------------------------------------------------------------
            order by
                vco_lfd_nr,
                haus_lfd_nr
        ) loop
            v_count_loop := 1 + v_count_loop;
      -- Zuordnung entfernen:
            begin
                if testbetrieb = 1 then
                    null;
                else
                    pck_vermarktungsclstr_obj_dml.p_delete(pin_vco_lfd_nr => objekte.vco_lfd_nr);
                end if;

                insert into ftth_log_siebel_ready_vco (
                    datum,
                    haus_lfd_nr,
                    vc_lfd_nr,
                    modus
                ) values ( uhrzeit,
                           objekte.haus_lfd_nr,
                           objekte.vc_lfd_nr,
                           case
                               when testbetrieb = 0 then
                                   c_modus_aufheben
                           end -- im Testbetrieb: Spalte bleibt leer
                );

            exception
                when others then
                    v_count_fehler := 1 + v_count_fehler; -- Konsequenz¿ Ganzen Prozess scheitern lassen¿ Ausgabe¿
                    insert into ftth_log_siebel_ready_vco (
                        datum,
                        haus_lfd_nr,
                        vc_lfd_nr,
                        modus,
                        fehler
                    ) values ( uhrzeit,
                               objekte.haus_lfd_nr,
                               objekte.vc_lfd_nr,
                               c_modus_aufheben,
                               1 ); -- weiter loopen (Fehler wurde eingetragen und wird am Ende
           -- nochmals in die Gesamtübersicht geschrieben)
            end;

        end loop;

        pck_logs.p_set_log_level_info;
        pck_logs.p_info(
            pic_message      =>
                         case testbetrieb
                             when 0 then
                                 'Anzahl Siebel-ready-Objekte aus Vermarktungsclustern entfernt: '
                             when 1 then
                                 'Anzahl Siebel-ready Loeschkandidaten: '
                         end
                         || to_char(v_count_loop - v_count_fehler)
                         || ', Fehler: '
                         || v_count_fehler,
            piv_routine_name => cv_routine_name,
            piv_action       => 'JOB_SIEBELREADY_VCO_DEL',
            piv_scope        => g_scope
        );

    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end;
-- @progress 2023-11-08 --------------------------------------------------------
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
 * @example  prüfen, welche Löschungen rückgängig gemacht werden können, die gestern
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
    ) return naturaln is

        v_count_loop    naturaln := 0;
        v_count_fehler  naturaln := 0;
        uhrzeit         ftth_log_siebel_ready_vco.datum%type := sysdate;
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'undo_siebel_ready_objekte_entf';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pid_datum', pid_datum);
            pck_format.p_add('pin_vc_lfd_nr', pin_vc_lfd_nr);
            pck_format.p_add('piv_action', piv_action);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
  -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------     
    begin
        for geloescht in (
            select
                id,
                haus_lfd_nr,
                vc_lfd_nr
            from
                ftth_log_siebel_ready_vco
            where
                    trunc(ftth_log_siebel_ready_vco.datum) = trunc(pid_datum)
                and ( pin_vc_lfd_nr is null
                      or pin_vc_lfd_nr = ftth_log_siebel_ready_vco.vc_lfd_nr )
                and modus = c_modus_aufheben
                and fehler is null
            order by
                id
        ) loop
            v_count_loop := 1 + v_count_loop;
      -- Zuordnung wiederherstellen:
            begin
                p_objekt_zuordnen(
                    pin_haus_lfd_nr => geloescht.haus_lfd_nr,
                    pin_vc_lfd_nr   => geloescht.vc_lfd_nr,
                    pin_modus       => c_modus_einfach
                );

        -- Log-Tabelle: Der alte Eintrag wird aktualisiert
        -- sowie ein neuer hinzugefügt
                update ftth_log_siebel_ready_vco
                set
                    fehler = c_modus_aufheben -- sozusagen "Das Aufheben war ein Fehler"
                where
                    ftth_log_siebel_ready_vco.id = geloescht.id;

                insert into ftth_log_siebel_ready_vco (
                    datum,
                    haus_lfd_nr,
                    vc_lfd_nr,
                    modus
                ) values ( uhrzeit,
                           geloescht.haus_lfd_nr,
                           geloescht.vc_lfd_nr,
                           c_modus_wiedereinsetzen );

            exception
                when others then
                    v_count_fehler := 1 + v_count_fehler; -- Ausgabe¿
                    update ftth_log_siebel_ready_vco
                    set
                        fehler = 1,
                        modus = c_modus_wiedereinsetzen,
                        datum = uhrzeit
                    where
                        ftth_log_siebel_ready_vco.id = geloescht.id;

            end;

        end loop;
    -- Gesamt-Log:
        pck_logs.p_set_log_level_info;
        pck_logs.p_info(
            pic_message      => 'Anzahl aus Vermarktungsclustern gelöschte Siebel-ready-Objekte wiederhergestellt: '
                           || to_char(v_count_loop - v_count_fehler)
                           || ', Fehler: '
                           || v_count_fehler,
            piv_routine_name => cv_routine_name,
            piv_action       => piv_action,
            piv_scope        => g_scope
        );

        return
            case
                when v_count_fehler = 0 then
                    v_count_loop
                else -1 * v_count_fehler
            end;
    end undo_siebel_ready_objekte_entf;
-- @progress 2023-11-09 --------------------------------------------------------
/**
 * Liefert zum Schlüssel eines Wholebuy-Partners (z.B. 'TCOM') den dazugehörigen
 * Namen ('Telekom')
 *
 * @param piv_wholebuy_key  Schlüssel des Wholebuy-Partners
 */
    function fv_wholebuy_partner_display (
        piv_wholebuy_key in varchar2
    ) return varchar2 is

        v_wholebuy_partner enum.singular%type;
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name    constant logs.routine_name%type := 'fv_wholebuy_partner_display';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_wholebuy_key', piv_wholebuy_key);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
  -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------     
    begin
        select
            max(singular)
        into v_wholebuy_partner
        from
            enum
        where
                domain = 'WHOLEBUY_PARTNER'
            and key = piv_wholebuy_key
            and sprache = '*';

        return v_wholebuy_partner;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name
            );
            raise;
    end fv_wholebuy_partner_display;
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
        piv_url_gk                     in varchar2,
        piv_status                     in varchar2,
        piv_aktiv                      in integer,
        pin_mindestbandbreite          in number,
        pin_kosten_hausanschluss       in number,
        pin_kundenauftrag_erforderlich in integer,
        piv_netwissen_seite            in varchar2,
        piv_wholebuy                   in varchar2,
        piv_anlage_typ                 in varchar2 default 'MANUELL'
    ) return vermarktungscluster.vc_lfd_nr%type is

        vr_vermarktungscluster vermarktungscluster%rowtype;
        v_wholebuy             enum.key%type;
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name        constant logs.routine_name%type := 'fn_merge_cluster';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_vc_lfd_nr', pin_vc_lfd_nr);
            pck_format.p_add('piv_mandant', piv_mandant);
            pck_format.p_add('piv_bezeichnung', piv_bezeichnung);
            pck_format.p_add('pid_ausbau_plan_termin', pid_ausbau_plan_termin);
            pck_format.p_add('pin_dnsttp_lfd_nr', pin_dnsttp_lfd_nr);
            pck_format.p_add('piv_url', piv_url);
            pck_format.p_add('piv_url_gk', piv_url_gk);
            pck_format.p_add('piv_status', piv_status);
            pck_format.p_add('piv_aktiv', piv_aktiv);
            pck_format.p_add('pin_mindestbandbreite', pin_mindestbandbreite);
            pck_format.p_add('pin_kosten_hausanschluss', pin_kosten_hausanschluss);
            pck_format.p_add('pin_kundenauftrag_erforderlich', pin_kundenauftrag_erforderlich);
            pck_format.p_add('piv_netwissen_seite', piv_netwissen_seite);
            pck_format.p_add('piv_wholebuy', piv_wholebuy);
            pck_format.p_add('piv_anlage_typ', piv_anlage_typ);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
  -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------  
    begin  
    -- @todo 
    -- /// Plausi ...
    -- Enum:
        v_wholebuy := upper(substr(
            trim(piv_wholebuy),
            1,
            30
        )); -- mehr Zeichen sind nicht erlaubt
        if v_wholebuy in ( 'N', 'NEIN', '-' ) then -- das kommt ggf. von APEX
            v_wholebuy := null;
        end if;

        if
            v_wholebuy is not null
            and fv_wholebuy_partner_display(v_wholebuy) is null
        then
            raise_application_error(c_plausi_error_number, 'Wholebuy-Partner existiert nicht (Kürzel: '
                                                           || v_wholebuy
                                                           || ')');
        end if;

    -- Nach prüfung zuordnen:
        vr_vermarktungscluster.vc_lfd_nr := pin_vc_lfd_nr;
        vr_vermarktungscluster.mandant := piv_mandant;
        vr_vermarktungscluster.bezeichnung := piv_bezeichnung;
        vr_vermarktungscluster.ausbau_plan_termin := pid_ausbau_plan_termin;
        vr_vermarktungscluster.dnsttp_lfd_nr := pin_dnsttp_lfd_nr;
        vr_vermarktungscluster.url := piv_url;
        vr_vermarktungscluster.url_gk := piv_url_gk;
        vr_vermarktungscluster.status := piv_status;
        vr_vermarktungscluster.aktiv := piv_aktiv;
        vr_vermarktungscluster.mindestbandbreite := pin_mindestbandbreite;
        vr_vermarktungscluster.kosten_hausanschluss := pin_kosten_hausanschluss;
        vr_vermarktungscluster.kundenauftrag_erforderlich := pin_kundenauftrag_erforderlich;
        vr_vermarktungscluster.netwissen_seite := piv_netwissen_seite;
        vr_vermarktungscluster.wholebuy := v_wholebuy;
        vr_vermarktungscluster.anlage_typ := piv_anlage_typ;

    -- Die Audit-Spalten (INSERTED_BY, UPDATED_BY) werden vom PCK_VERMARKTUNGSCLUSTER_DML hinzugefügt.

    -- DML-Package aufrufen:
        if vr_vermarktungscluster.vc_lfd_nr is null then
      -- Neuen Vermarktungscluster anlegen:
            pck_vermarktungscluster_dml.p_insert(vr_vermarktungscluster);
        else
      -- für das Update existiert eine spezielle Routine, 
      -- die auch den Aufruf eines Webservice übernimmt:
      -- @REST
            p_update_mit_meldung_pob(vr_vermarktungscluster);
        end if;

        return vr_vermarktungscluster.vc_lfd_nr;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end fn_merge_cluster;

-- @progress 2023-11-14 --------------------------------------------------------
/**
 * Sendet eine Zusammenfassung aller WHOLEBUY-Vermarktungscluster an den Preorder-Buffer
 *
 * @ticket FTTH-2907, @ticket FTTH-2901
 * @usage Wird durch JOB_VMC_WHOLEBUY_POB nächtlich aufgerufen 
 *
 * @example
 * BEGIN PCK_VERMARKTUNGSCLUSTER.p_wholebuy_objektmeldung; END;
 */
    procedure p_wholebuy_objektmeldung is

        vj_wholebuy_objektmeldung json_array_t := new json_array_t('[]');
        vj_haus_lfd_nr_liste      json_array_t;
        vj_partner                json_object_t;
        v_counter_pro_partner     naturaln := 0;
        v_wholebuy_partner_alt    vermarktungscluster.wholebuy%type := '-';

  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name           constant logs.routine_name%type := 'p_wholebuy_objektmeldung';

        function fcl_params return logs.message%type is
        begin
            return null; -- diese procedure besitzt keine Parameter
        end fcl_params;
  -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
        procedure gruppenwechsel_partner (
            i_partner_neu in varchar2
        ) is
        begin
            if v_counter_pro_partner > 0 then
                vj_partner.put('partner', v_wholebuy_partner_alt);
                vj_partner.put('count', v_counter_pro_partner); -- 2023-12-14 optional, dient nur der Kontrolle
                vj_partner.put('hausLfdnrList', vj_haus_lfd_nr_liste);
                vj_wholebuy_objektmeldung.append(vj_partner);
            end if;
      -- neue Gruppe initialisieren:
            if i_partner_neu is not null then
                v_wholebuy_partner_alt := i_partner_neu;
                v_counter_pro_partner := 0;
                vj_partner := new json_object_t('{}');
                vj_haus_lfd_nr_liste := new json_array_t('[]');
            end if;

        end;

    begin
        for objekt in (
            select
                vc.wholebuy as wholebuy_partner,
                vco.haus_lfd_nr
          -- ENUM.singular AS wholebuy_partner
            from
                     vermarktungscluster vc
                join vermarktungscluster_objekt vco on ( vco.vc_lfd_nr = vc.vc_lfd_nr )
            where
                vc.wholebuy is not null
            order by
                wholebuy_partner -- Spalte für Gruppenwechsel
                ,
                vco.haus_lfd_nr
        ) loop
            if objekt.wholebuy_partner <> v_wholebuy_partner_alt then
                gruppenwechsel_partner(objekt.wholebuy_partner);
            end if;
            v_counter_pro_partner := 1 + v_counter_pro_partner;
            vj_haus_lfd_nr_liste.append(objekt.haus_lfd_nr);
        end loop;

        gruppenwechsel_partner(null);
    -- DBMS_OUTPUT.PUT_LINE(vj_wholebuy_objektmeldung.stringify());

    -- @REST
        pck_pob_rest.p_wholebuy_post_objektmeldung(
            pic_body        => vj_wholebuy_objektmeldung.to_clob,
            piv_application => g_application
        );
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end p_wholebuy_objektmeldung;

  -- @progress 2024-02-28 --

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
    ) return vermarktungscluster%rowtype is

        vr_vermarktungscluster vermarktungscluster%rowtype;
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name        constant logs.routine_name%type := 'fr_vermarktungscluster';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_haus_lfd_nr', pin_haus_lfd_nr);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------
    begin
        if pin_haus_lfd_nr is null then
            return null;
        end if;
        for vm in ( -- Der übliche APEX-Kunstgriff: Wir erwarten 0 oder 1 Zeile;
                -- durch den Loop wird die NO_DATA_FOUND-Exception verhindert
            select
                *
            from
                vermarktungscluster
            where
                vc_lfd_nr = (
                    select
                        vc_lfd_nr
                    from
                        vermarktungscluster_objekt
                    where
                        haus_lfd_nr = pin_haus_lfd_nr
                )
        ) loop
            vr_vermarktungscluster.vc_lfd_nr := vm.vc_lfd_nr;
            vr_vermarktungscluster.bezeichnung := vm.bezeichnung;
            vr_vermarktungscluster.dnsttp_lfd_nr := vm.dnsttp_lfd_nr;
            vr_vermarktungscluster.url := vm.url;
        -- @ticket FTTH-2190 "VM-Cluster-Tool um optionales LP-Ziel für GK erweitern":
            vr_vermarktungscluster.url_gk := vm.url_gk;
            vr_vermarktungscluster.status := vm.status;
            vr_vermarktungscluster.ausbau_plan_termin := vm.ausbau_plan_termin;
            vr_vermarktungscluster.aktiv := vm.aktiv;
            vr_vermarktungscluster.mindestbandbreite := vm.mindestbandbreite;
            vr_vermarktungscluster.zielbandbreite_geplant := vm.zielbandbreite_geplant;
            vr_vermarktungscluster.kosten_hausanschluss := vm.kosten_hausanschluss;
            vr_vermarktungscluster.kundenauftrag_erforderlich := vm.kundenauftrag_erforderlich;
            vr_vermarktungscluster.netwissen_seite := vm.netwissen_seite;
            vr_vermarktungscluster.inserted := vm.inserted;
            vr_vermarktungscluster.updated := vm.updated;
            vr_vermarktungscluster.inserted_by := vm.inserted_by;
            vr_vermarktungscluster.updated_by := vm.updated_by;
            vr_vermarktungscluster.wholebuy := vm.wholebuy;
        end loop;

        return vr_vermarktungscluster;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name,
                piv_scope        => g_scope
            );

            raise;
    end fr_vermarktungscluster;

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
    ) is

        c_updated       constant date := sysdate;
        c_updated_by    constant varchar2(30) := 'TCOM_ADR_BSA';
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'p_update_eigentuemerdaten_notwendig';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pin_vc_lfd_nr', pin_vc_lfd_nr);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
  -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------   
    begin
        -- Durch MERGE (anstatt UPDATE ... SET ... WHERE ...) nur diejenigen Rohdaten aus TCOM_ADR_BSA holen, 
        -- bei denen die Werte in der Spalte EIGENTUEMERDATEN_NOTWENDIG verschieden von den bisherigen Einträgen
        -- in VERMARKTUNGSCLUSTER_OBJEKT sind, so dass keine überflüssigen Updates in VCO stattfinden:
        merge into vermarktungscluster_objekt ziel
        using (
               -- Menge der eindeutigen Zeilen in TCOM_ADR_BSA:
            with tcom_adr_bsa_eindeutig as (
               -- Stand 2024-06-26 sind leider noch recht viele HAUS_LFD_NRn nicht eindeutig in der Produktion,
               -- teils mit widersprüchlichen Daten oder Adressen,
               -- daher werden für das Update nur die Eindeutigen in diesem Subselect herangezogen,
               -- wo MAPPING_STATUS = OK ist und die HAUS_LFD_NR genau 1 x in der Tabelle vorkommt:
                select
                    t.haus_lfd_nr
                       -- Mapping bereits hier, damit weiter unten der Vergleich auf Update-Notwendigkeit einfach wird:
                    ,
                    max(decode(t.eigentuemerdaten_notwendig, 'X', 1, 0)) as eigentuemerdaten_notwendig
                from
                    tcom_adr_bsa t
                where
                    t.mapping_status = 'OK'
                group by
                    t.haus_lfd_nr
                having
                    count(*) = 1 -- nur den Datenpool berücksichten, dessen HAUS_LFD_NRn eindeutig sind
                                                            -- (so wie es eigentlich sein sollte, aber Stand 2024-06 nicht ist)
            ) -- davon nur update-bedürftige Spaltenwerte berücksichtigen, d.h.
           -- HAUS_LFD_NR muss in VCO vorkommen und sich von TCOM_ADR_BSA.EIGENTUEMERDATEN_NOTEWENDIG unterscheiden:
            select
                tcom.haus_lfd_nr,
                tcom.eigentuemerdaten_notwendig
            from
                     vermarktungscluster_objekt vco
                join tcom_adr_bsa_eindeutig tcom on ( vco.haus_lfd_nr = tcom.haus_lfd_nr
                  -- Explizite Werte oder NULL weichen voneinander ab:
                                                      and decode(tcom.eigentuemerdaten_notwendig, null, -1, tcom.eigentuemerdaten_notwendig
                                                      ) <> decode(vco.eigentuemerdaten_notwendig, null, -1, vco.eigentuemerdaten_notwendig
                                                      ) )
        ) quelle on ( quelle.haus_lfd_nr = ziel.haus_lfd_nr )
        when matched then -- matched heißt hier: HAUS_LFD_NR ist gleich, aber Spalte EIGENTUEMERDATEN_NOTWENDIG nicht.
            -- Mapping der Werte:
            -- 1 = Eigentümerdaten notwendig wenn 'X'
            -- 0 = Eigentümerdaten nicht notwendig, da Zeile zwar in TCOM_ADR_BSA enthalten, aber Spaltenwert ist NULL
            -- NULL = Zeile mit dieser HAUS_LFD_NR ist nicht in TCOM_ADR_BSA enthalten
         update
        set ziel.eigentuemerdaten_notwendig = quelle.eigentuemerdaten_notwendig
                     -- Audit-Spalten:
        ,
            ziel.updated = c_updated,
            ziel.updated_by = c_updated_by; -- typische Menge an täglichen Updates, Stand 2024-06-27: ~350

    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name
            );
            raise;
    end;

end pck_vermarktungscluster;
/


-- sqlcl_snapshot {"hash":"f270b5e1ceb4b4b22d1c57bd4c4de0cc1a5177ce","type":"PACKAGE_BODY","name":"PCK_VERMARKTUNGSCLUSTER","schemaName":"ROMA_MAIN","sxml":""}