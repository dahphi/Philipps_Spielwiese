-- liquibase formatted sql
-- changeset AM_MAIN:1774557117136 stripComments:false logicalFilePath:SCDP/am_main/package_bodies/pck_hwas_gebaeude_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_bodies/pck_hwas_gebaeude_dml.sql:null:59ce5ceeb1ce36b8b4c5e2d1d456885abb4e290b:create

create or replace package body am_main.pck_hwas_gebaeude_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in hwas_gebaeude%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'geb_uid = '
                        || to_char(pir_row.geb_uid)
                        || cv_sep
                        || ', geb_bezeichnung = '
                        || pir_row.geb_bezeichnung
                        || cv_sep
                        || ', geb_beschreibung = '
                        || pir_row.geb_beschreibung
                        || cv_sep
                        || ', geb_strasse_hnr = '
                        || pir_row.geb_strasse_hnr
                        || cv_sep
                        || ', geb_adresszusatz = '
                        || pir_row.geb_adresszusatz
                        || cv_sep
                        || ', geb_plz = '
                        || pir_row.geb_plz
                        || cv_sep
                        || ', geb_ort = '
                        || pir_row.geb_ort
                        || cv_sep
                        || ', inserted = '
                        || to_char(pir_row.inserted, 'DD.MM.YYYY')
                        || cv_sep
                        || ', updated = '
                        || to_char(pir_row.updated, 'DD.MM.YYYY')
                        || cv_sep
                        || ', inserted_by = '
                        || pir_row.inserted_by
                        || cv_sep
                        || ', updated_by = '
                        || pir_row.updated_by
                        || cv_sep
                        || ', geb_kritis_relevant = '
                        || to_char(pir_row.geb_kritis_relevant)
                        || cv_sep
                        || ', site = '
                        || pir_row.site
                        || cv_sep
                        || ', DATA_CUSTODIAN = '
                        || pir_row.data_custodian
                        || cv_sep;

            if ( piv_output_type = 'no' ) then
                v_retval := replace(
                    trim(v_retval),
                    cv_sep,
                    null
                );
            else
                v_retval := replace(
                    trim(v_retval),
                    cv_sep,
                    chr(10)
                );
            end if;

        elsif ( piv_output_type = 'html' ) then
            v_retval := '<table><tr><th>HWAS_GEBAEUDE</th><th>Column</th></tr>'
                        || '<tr><td>geb_uid</td><td>'
                        || to_char(pir_row.geb_uid)
                        || '</td></tr>'
                        || '<tr><td>geb_bezeichnung</td><td>'
                        || pir_row.geb_bezeichnung
                        || '</td></tr>'
                        || '<tr><td>geb_beschreibung</td><td>'
                        || pir_row.geb_beschreibung
                        || '</td></tr>'
                        || '<tr><td>geb_strasse_hnr</td><td>'
                        || pir_row.geb_strasse_hnr
                        || '</td></tr>'
                        || '<tr><td>geb_adresszusatz</td><td>'
                        || pir_row.geb_adresszusatz
                        || '</td></tr>'
                        || '<tr><td>geb_plz</td><td>'
                        || pir_row.geb_plz
                        || '</td></tr>'
                        || '<tr><td>geb_ort</td><td>'
                        || pir_row.geb_ort
                        || '</td></tr>'
                        || '<tr><td>inserted</td><td>'
                        || to_char(pir_row.inserted, 'DD.MM.YYYY')
                        || '</td></tr>'
                        || '<tr><td>updated</td><td>'
                        || to_char(pir_row.updated, 'DD.MM.YYYY')
                        || '</td></tr>'
                        || '<tr><td>inserted_by</td><td>'
                        || pir_row.inserted_by
                        || '</td></tr>'
                        || '<tr><td>updated_by</td><td>'
                        || pir_row.updated_by
                        || '</td></tr>'
                        || '<tr><td>geb_kritis_relevant</td><td>'
                        || to_char(pir_row.geb_kritis_relevant)
                        || '</td></tr>'
                        || '<tr><td>site</td><td>'
                        || pir_row.site
                        || '</td></tr>'
                        || '<tr><td>DATA_CUSTODIAN</td><td>'
                        || pir_row.data_custodian
                        || '</td></tr>'
                        || '</table>';
        else
            v_retval := null;
        end if;

        return v_retval;
    end fv_print;

---------------------------------------------------------------------------------------------------

    procedure p_insert (
        pior_hwas_gebaeude in out hwas_gebaeude%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_hwas_gebaeude.inserted := sysdate;
        pior_hwas_gebaeude.inserted_by := pck_env.fv_user;
        insert into hwas_gebaeude values pior_hwas_gebaeude returning geb_uid into pior_hwas_gebaeude.geb_uid;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle hwas_gebaeude! Parameter: ' || fv_print(pir_row => pior_hwas_gebaeude);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_hwas_gebaeude in hwas_gebaeude%rowtype
    ) is
        r_hwas_gebaeude hwas_gebaeude%rowtype;

  -- fuer exceptions
        v_routine_name  logs.routine_name%type;
        c_message       clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_hwas_gebaeude := pir_hwas_gebaeude;
        r_hwas_gebaeude.inserted := sysdate;
        r_hwas_gebaeude.updated := sysdate;
        r_hwas_gebaeude.inserted_by := pck_env.fv_user;
        r_hwas_gebaeude.updated_by := pck_env.fv_user;
        merge into hwas_gebaeude
        using dual on ( geb_uid = r_hwas_gebaeude.geb_uid )
        when matched then update
        set geb_bezeichnung = r_hwas_gebaeude.geb_bezeichnung,
            geb_beschreibung = r_hwas_gebaeude.geb_beschreibung,
            geb_strasse_hnr = r_hwas_gebaeude.geb_strasse_hnr,
            geb_adresszusatz = r_hwas_gebaeude.geb_adresszusatz,
            geb_plz = r_hwas_gebaeude.geb_plz,
            geb_ort = r_hwas_gebaeude.geb_ort,
            updated = r_hwas_gebaeude.updated,
            updated_by = r_hwas_gebaeude.updated_by,
            geb_kritis_relevant = r_hwas_gebaeude.geb_kritis_relevant,
            site = r_hwas_gebaeude.site,
            data_custodian = r_hwas_gebaeude.data_custodian
        when not matched then
        insert (
            geb_bezeichnung,
            geb_beschreibung,
            geb_strasse_hnr,
            geb_adresszusatz,
            geb_plz,
            geb_ort,
            inserted,
            inserted_by,
            geb_kritis_relevant,
            site,
            data_custodian )
        values
            ( r_hwas_gebaeude.geb_bezeichnung,
              r_hwas_gebaeude.geb_beschreibung,
              r_hwas_gebaeude.geb_strasse_hnr,
              r_hwas_gebaeude.geb_adresszusatz,
              r_hwas_gebaeude.geb_plz,
              r_hwas_gebaeude.geb_ort,
              r_hwas_gebaeude.inserted,
              r_hwas_gebaeude.inserted_by,
              r_hwas_gebaeude.geb_kritis_relevant,
              r_hwas_gebaeude.site,
              r_hwas_gebaeude.data_custodian );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_hwas_gebaeude);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

/* Update-Alternative M. Schmenner */
    procedure p_update (
        pir_hwas_gebaeude in hwas_gebaeude%rowtype,
        piv_art           in varchar2
    ) is
        r_hwas_gebaeude hwas_gebaeude%rowtype;        

-- fuer exceptions        
        v_routine_name  logs.routine_name%type;
        c_message       clob;
    begin        
  -- fuer exceptions      
        v_routine_name := gcv_package_name || '.P_UPDATE';
        case piv_art
            when '<full>' then    
      -- Übernehmen der Eingabedaten  
                r_hwas_gebaeude := pir_hwas_gebaeude;  
      -- Ergänzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_hwas_gebaeude.inserted,
                    r_hwas_gebaeude.inserted_by
                from
                    hwas_gebaeude
                where
                    geb_uid = pir_hwas_gebaeude.geb_uid;  
      -- Ergänzen der Update-Daten  
                r_hwas_gebaeude.updated := sysdate;
                r_hwas_gebaeude.updated_by := pck_env.fv_user;
                update hwas_gebaeude
                set
                    row = r_hwas_gebaeude
                where
                    geb_uid = pir_hwas_gebaeude.geb_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then      
  -- Fehlerprotokollierung      
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_hwas_gebaeude);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;        

---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_geb_uid in hwas_gebaeude.geb_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_geb_uid: ' || to_char(pin_geb_uid);
        delete from hwas_gebaeude
        where
            geb_uid = pin_geb_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle hwas_gebaeude! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle hwas_gebaeude! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;
---------------------------------------------------------------------------------------------------
    procedure p_insert_itwo_site is

  -- fuer exceptions
        v_routine_name     logs.routine_name%type;
        c_message          clob;
        r_itwo_site_import hwas_gebaeude%rowtype;
        cursor c_neue_site is
        select distinct
            site,
            plz,
            stadt,
            strasse,
            haus_nr,
            obj_id
        from
            itwo_site
        where
            site in (
                select
                    site
                from
                    itwo_site
                minus
                select
                    site
                from
                    hwas_gebaeude
            );

    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        r_itwo_site_import.inserted := sysdate;
        r_itwo_site_import.inserted_by := pck_env.fv_user;
        for i in c_neue_site loop
            r_itwo_site_import.geb_uid := to_number ( sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' );
            r_itwo_site_import.geb_bezeichnung := i.site;
            r_itwo_site_import.geb_strasse_hnr := i.strasse
                                                  || ' '
                                                  || i.haus_nr;
            r_itwo_site_import.geb_plz := i.plz;
            r_itwo_site_import.geb_ort := i.stadt;
            r_itwo_site_import.geb_kritis_relevant := 0;
            r_itwo_site_import.site := i.site;
--dbms_output.put_line( i.SITE);

            insert into hwas_gebaeude values r_itwo_site_import;

        end loop;

    exception
        when others then
            null;
    -- Fehlerprotokollierung
    --c_message := 'Fehler bei Insert in Tabelle HWAS_GEBAEUDE! Parameter: ' || fv_print( pir_row => pior_HWAS_GEBAEUDE );
    --pck_logs.p_error( piv_routine_name => v_routine_name, pic_message => c_message );
            raise;
    end p_insert_itwo_site;

end pck_hwas_gebaeude_dml;
/

