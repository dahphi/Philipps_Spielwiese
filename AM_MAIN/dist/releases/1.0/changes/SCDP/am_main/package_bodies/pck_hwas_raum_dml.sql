-- liquibase formatted sql
-- changeset AM_MAIN:1774556570849 stripComments:false logicalFilePath:SCDP/am_main/package_bodies/pck_hwas_raum_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_bodies/pck_hwas_raum_dml.sql:null:122faf24c8463bcbc25a45e78b334317c8b94eba:create

create or replace package body am_main.pck_hwas_raum_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in hwas_raum%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'rm_uid = '
                        || to_char(pir_row.rm_uid)
                        || cv_sep
                        || ', rm_beschreibung = '
                        || pir_row.rm_beschreibung
                        || cv_sep
                        || ', geb_uid = '
                        || to_char(pir_row.geb_uid)
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
                        || ', raum = '
                        || pir_row.raum
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
            v_retval := '<table><tr><th>HWAS_RAUM</th><th>Column</th></tr>'
                        || '<tr><td>rm_uid</td><td>'
                        || to_char(pir_row.rm_uid)
                        || '</td></tr>'
                        || '<tr><td>rm_beschreibung</td><td>'
                        || pir_row.rm_beschreibung
                        || '</td></tr>'
                        || '<tr><td>geb_uid</td><td>'
                        || to_char(pir_row.geb_uid)
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
                        || '<tr><td>raum</td><td>'
                        || pir_row.raum
                        || '</td></tr>'
                        || '</table>';
        else
            v_retval := null;
        end if;

        return v_retval;
    end fv_print;

---------------------------------------------------------------------------------------------------

    procedure p_insert (
        pior_hwas_raum in out hwas_raum%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_hwas_raum.inserted := sysdate;
        pior_hwas_raum.inserted_by := pck_env.fv_user;
        insert into hwas_raum values pior_hwas_raum returning rm_uid into pior_hwas_raum.rm_uid;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle hwas_raum! Parameter: ' || fv_print(pir_row => pior_hwas_raum);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_hwas_raum in hwas_raum%rowtype
    ) is
        r_hwas_raum    hwas_raum%rowtype;

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_hwas_raum := pir_hwas_raum;
        r_hwas_raum.inserted := sysdate;
        r_hwas_raum.updated := sysdate;
        r_hwas_raum.inserted_by := pck_env.fv_user;
        r_hwas_raum.updated_by := pck_env.fv_user;
        merge into hwas_raum
        using dual on ( rm_uid = r_hwas_raum.rm_uid )
        when matched then update
        set rm_beschreibung = r_hwas_raum.rm_beschreibung,
            geb_uid = r_hwas_raum.geb_uid,
            updated = r_hwas_raum.updated,
            updated_by = r_hwas_raum.updated_by,
            raum = r_hwas_raum.raum
        when not matched then
        insert (
            rm_beschreibung,
            geb_uid,
            inserted,
            inserted_by,
            raum )
        values
            ( r_hwas_raum.rm_beschreibung,
              r_hwas_raum.geb_uid,
              r_hwas_raum.inserted,
              r_hwas_raum.inserted_by,
              r_hwas_raum.raum );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_hwas_raum);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

/* Update-Alternative M. Schmenner */
    procedure p_update (
        pir_hwas_raum in hwas_raum%rowtype,
        piv_art       in varchar2
    ) is
        r_hwas_raum    hwas_raum%rowtype;        

-- fuer exceptions        
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin        
  -- fuer exceptions      
        v_routine_name := gcv_package_name || '.P_UPDATE';
        case piv_art
            when '<full>' then    
      -- Übernehmen der Eingabedaten  
                r_hwas_raum := pir_hwas_raum;  
      -- Ergänzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_hwas_raum.inserted,
                    r_hwas_raum.inserted_by
                from
                    hwas_raum
                where
                    rm_uid = pir_hwas_raum.rm_uid;  
      -- Ergänzen der Update-Daten  
                r_hwas_raum.updated := sysdate;
                r_hwas_raum.updated_by := pck_env.fv_user;
                update hwas_raum
                set
                    row = r_hwas_raum
                where
                    rm_uid = pir_hwas_raum.rm_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then      
  -- Fehlerprotokollierung      
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_hwas_raum);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;        

---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_rm_uid in hwas_raum.rm_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_rm_uid: ' || to_char(pin_rm_uid);
        delete from hwas_raum
        where
            rm_uid = pin_rm_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle hwas_raum! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle hwas_raum! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

---------------------------------------------------------------------------------------------------

    procedure p_insert_hwas_raum is

  -- fuer exceptions
        v_routine_name     logs.routine_name%type;
        c_message          clob;
        v_site             varchar2(128);
        r_hwas_raum_import hwas_raum%rowtype;
        cursor c_neuer_raum is
        select distinct
            raum,
            itr.site,
            standortpfad
        from
                 itwo_raum itr
            join itwo_site its on itr.site = its.site
        where
            raum in (
                select
                    raum
                from
                    itwo_raum
                minus
                select
                    raum
                from
                    hwas_raum
            )
            and itr.site != 'COL_Verwaltung'
            and itr.site != 'STD'
            and raum != 'unbekannt';

    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        r_hwas_raum_import.inserted := sysdate;
        r_hwas_raum_import.inserted_by := pck_env.fv_user;
        for i in c_neuer_raum loop
  --dbms_output.put_line( i.RAUM ||i.site);
            select
                geb_uid
            into v_site
            from
                     hwas_gebaeude hg
                join itwo_raum vir on hg.site = vir.site
            where
                    vir.raum = i.raum
                and vir.site = i.site;
--dbms_output.put_line( v_site);
--select GEB_UID into v_site from HWAS_GEBAEUDE hg join itwo_site vir on hg.SITE = vir.site where vir.raum = i.raum;

            r_hwas_raum_import.rm_uid := to_number ( sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' );
            r_hwas_raum_import.rm_beschreibung := 'aus HWDB';
            r_hwas_raum_import.geb_uid := v_site;
            r_hwas_raum_import.raum := i.raum;
  --dbms_output.put_line( i.RAUM);

            insert into hwas_raum values r_hwas_raum_import;

        end loop;

    exception
        when others then
            null;
    -- Fehlerprotokollierung
    --c_message := 'Fehler bei Insert in Tabelle HWAS_RAUM! Parameter: ' || fv_print( pir_row => pior_HWAS_RAUM );
    --pck_logs.p_error( piv_routine_name => v_routine_name, pic_message => c_message );
            raise;
    end p_insert_hwas_raum;

end pck_hwas_raum_dml;
/

