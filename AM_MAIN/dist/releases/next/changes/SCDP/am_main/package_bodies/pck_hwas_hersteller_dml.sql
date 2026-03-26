-- liquibase formatted sql
-- changeset AM_MAIN:1774557117567 stripComments:false logicalFilePath:SCDP/am_main/package_bodies/pck_hwas_hersteller_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_bodies/pck_hwas_hersteller_dml.sql:null:24cb60498ebc385725aaaa32e097d01513c1cfc3:create

create or replace package body am_main.pck_hwas_hersteller_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in hwas_hersteller%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'hst_uid = '
                        || to_char(pir_row.hst_uid)
                        || cv_sep
                        || ', hst_bezeichnung = '
                        || pir_row.hst_bezeichnung
                        || cv_sep
                        || ', hst_beschreibung = '
                        || pir_row.hst_beschreibung
                        || cv_sep
                        || ', hst_url = '
                        || pir_row.hst_url
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
            v_retval := '<table><tr><th>HWAS_HERSTELLER</th><th>Column</th></tr>'
                        || '<tr><td>hst_uid</td><td>'
                        || to_char(pir_row.hst_uid)
                        || '</td></tr>'
                        || '<tr><td>hst_bezeichnung</td><td>'
                        || pir_row.hst_bezeichnung
                        || '</td></tr>'
                        || '<tr><td>hst_beschreibung</td><td>'
                        || pir_row.hst_beschreibung
                        || '</td></tr>'
                        || '<tr><td>hst_url</td><td>'
                        || pir_row.hst_url
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
                        || '</table>';
        else
            v_retval := null;
        end if;

        return v_retval;
    end fv_print;

---------------------------------------------------------------------------------------------------

    procedure p_insert (
        pior_hwas_hersteller in out hwas_hersteller%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_hwas_hersteller.inserted := sysdate;
        pior_hwas_hersteller.inserted_by := pck_env.fv_user;
        insert into hwas_hersteller values pior_hwas_hersteller returning hst_uid into pior_hwas_hersteller.hst_uid;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle hwas_hersteller! Parameter: ' || fv_print(pir_row => pior_hwas_hersteller);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_hwas_hersteller in hwas_hersteller%rowtype
    ) is
        r_hwas_hersteller hwas_hersteller%rowtype;

  -- fuer exceptions
        v_routine_name    logs.routine_name%type;
        c_message         clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_hwas_hersteller := pir_hwas_hersteller;
        r_hwas_hersteller.inserted := sysdate;
        r_hwas_hersteller.updated := sysdate;
        r_hwas_hersteller.inserted_by := pck_env.fv_user;
        r_hwas_hersteller.updated_by := pck_env.fv_user;
        merge into hwas_hersteller
        using dual on ( hst_uid = r_hwas_hersteller.hst_uid )
        when matched then update
        set hst_bezeichnung = r_hwas_hersteller.hst_bezeichnung,
            hst_beschreibung = r_hwas_hersteller.hst_beschreibung,
            hst_url = r_hwas_hersteller.hst_url,
            updated = r_hwas_hersteller.updated,
            updated_by = r_hwas_hersteller.updated_by
        when not matched then
        insert (
            hst_bezeichnung,
            hst_beschreibung,
            hst_url,
            inserted,
            inserted_by )
        values
            ( r_hwas_hersteller.hst_bezeichnung,
              r_hwas_hersteller.hst_beschreibung,
              r_hwas_hersteller.hst_url,
              r_hwas_hersteller.inserted,
              r_hwas_hersteller.inserted_by );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_hwas_hersteller);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

/* Update-Alternative M. Schmenner */
    procedure p_update (
        pir_hwas_hersteller in hwas_hersteller%rowtype,
        piv_art             in varchar2
    ) is
        r_hwas_hersteller hwas_hersteller%rowtype;        

-- fuer exceptions        
        v_routine_name    logs.routine_name%type;
        c_message         clob;
    begin        
  -- fuer exceptions      
        v_routine_name := gcv_package_name || '.P_UPDATE';
        case piv_art
            when '<full>' then    
      -- Ã?bernehmen der Eingabedaten  
                r_hwas_hersteller := pir_hwas_hersteller;  
      -- ErgÃ¤nzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_hwas_hersteller.inserted,
                    r_hwas_hersteller.inserted_by
                from
                    hwas_hersteller
                where
                    hst_uid = pir_hwas_hersteller.hst_uid;  
      -- ErgÃ¤nzen der Update-Daten  
                r_hwas_hersteller.updated := sysdate;
                r_hwas_hersteller.updated_by := pck_env.fv_user;
                update hwas_hersteller
                set
                    row = r_hwas_hersteller
                where
                    hst_uid = pir_hwas_hersteller.hst_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then      
  -- Fehlerprotokollierung      
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_hwas_hersteller);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;        

--------------------------------------------------------------------------------------------------------------------------
    procedure p_insert_hwdb_hersteller is

  -- fuer exceptions
        v_routine_name           logs.routine_name%type;
        c_message                clob;
        r_hwdb_hersteller_import hwas_hersteller%rowtype;
        cursor c_neuer_hersteller is
        select distinct
            hersteller
        from
            am_int.hwdb_hosts
        where
            hersteller in (
                select
                    hersteller
                from
                    am_int.hwdb_hosts
                minus
                select
                    hst_bezeichnung
                from
                    hwas_hersteller
            );

    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        r_hwdb_hersteller_import.inserted := sysdate;
        r_hwdb_hersteller_import.inserted_by := pck_env.fv_user;
        for i in c_neuer_hersteller loop
            r_hwdb_hersteller_import.hst_uid := to_number ( sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' );
            r_hwdb_hersteller_import.hst_bezeichnung := i.hersteller;
            r_hwdb_hersteller_import.hst_beschreibung := 'aus HWDB';
--dbms_output.put_line( i.hersteller);

            insert into hwas_hersteller values r_hwdb_hersteller_import;

        end loop;

    exception
        when others then
    -- Fehlerprotokollierung
    --c_message := 'Fehler bei Insert in Tabelle hwas_modell! Parameter: ' || fv_print( pir_row => pior_hwas_modell );
    --pck_logs.p_error( piv_routine_name => v_routine_name, pic_message => c_message );
            raise;
    end p_insert_hwdb_hersteller;
---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_hst_uid in hwas_hersteller.hst_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_hst_uid: ' || to_char(pin_hst_uid);
        delete from hwas_hersteller
        where
            hst_uid = pin_hst_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle hwas_hersteller! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle hwas_hersteller! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_hwas_hersteller_dml;
/

