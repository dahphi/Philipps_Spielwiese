-- liquibase formatted sql
-- changeset AM_MAIN:1774556568715 stripComments:false logicalFilePath:SCDP/am_main/package_bodies/pck_hwas_betriebssystem_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_bodies/pck_hwas_betriebssystem_dml.sql:null:68f57e93b2654b3f566080d22f1850b85d64f0f2:create

create or replace package body am_main.pck_hwas_betriebssystem_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in hwas_betriebssystem%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'SYSTEM_ID = '
                        || to_char(pir_row.system_id)
                        || cv_sep
                        || ', HST_UID_FK = '
                        || pir_row.hst_uid_fk
                        || cv_sep
                        || ', BEZEICHNUNG = '
                        || pir_row.bezeichnung
                        || cv_sep
                        || ', BEMERKUNG = '
                        || pir_row.bemerkung
                        || cv_sep
                        || ', INSERTED = '
                        || to_char(pir_row.inserted, 'DD.MM.YYYY')
                        || cv_sep
                        || ', UPDATED = '
                        || to_char(pir_row.updated, 'DD.MM.YYYY')
                        || cv_sep
                        || ', INSERTED_BY = '
                        || pir_row.inserted_by
                        || cv_sep
                        || ', UPDATED_BY = '
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
            v_retval := '<table><tr><th>HWAS_BETRIEBSSYSTEM</th><th>Column</th></tr>'
                        || '<tr><td>SYSTEM_ID</td><td>'
                        || to_char(pir_row.system_id)
                        || '</td></tr>'
                        || '<tr><td>HST_UID_FK</td><td>'
                        || pir_row.hst_uid_fk
                        || '</td></tr>'
                        || '<tr><td>BEZEICHNUNG</td><td>'
                        || pir_row.bezeichnung
                        || '</td></tr>'
                        || '<tr><td>BEMERKUNG</td><td>'
                        || pir_row.bemerkung
                        || '</td></tr>'
                        || '<tr><td>INSERTED</td><td>'
                        || to_char(pir_row.inserted, 'DD.MM.YYYY')
                        || '</td></tr>'
                        || '<tr><td>UPDATED</td><td>'
                        || to_char(pir_row.updated, 'DD.MM.YYYY')
                        || '</td></tr>'
                        || '<tr><td>INSERTED_BY</td><td>'
                        || pir_row.inserted_by
                        || '</td></tr>'
                        || '<tr><td>UPDATED_BY</td><td>'
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
        pior_hwas_betriebssystem in out hwas_betriebssystem%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_hwas_betriebssystem.inserted := sysdate;
        pior_hwas_betriebssystem.inserted_by := pck_env.fv_user;
        insert into hwas_betriebssystem values pior_hwas_betriebssystem returning system_id into pior_hwas_betriebssystem.system_id;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle hwas_betriebssystem! Parameter: ' || fv_print(pir_row => pior_hwas_betriebssystem
            );
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_hwas_betriebssystem in hwas_betriebssystem%rowtype
    ) is
        r_hwas_betriebssystem hwas_betriebssystem%rowtype;

  -- fuer exceptions
        v_routine_name        logs.routine_name%type;
        c_message             clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_hwas_betriebssystem := pir_hwas_betriebssystem;
        r_hwas_betriebssystem.inserted := sysdate;
        r_hwas_betriebssystem.updated := sysdate;
        r_hwas_betriebssystem.inserted_by := pck_env.fv_user;
        r_hwas_betriebssystem.updated_by := pck_env.fv_user;
        merge into hwas_betriebssystem
        using dual on ( system_id = r_hwas_betriebssystem.system_id )
        when matched then update
        set hst_uid_fk = r_hwas_betriebssystem.hst_uid_fk,
            bezeichnung = r_hwas_betriebssystem.bezeichnung,
            bemerkung = r_hwas_betriebssystem.bemerkung,
            updated = r_hwas_betriebssystem.updated,
            updated_by = r_hwas_betriebssystem.updated_by
        when not matched then
        insert (
            hst_uid_fk,
            bezeichnung,
            bemerkung,
            inserted,
            inserted_by )
        values
            ( r_hwas_betriebssystem.hst_uid_fk,
              r_hwas_betriebssystem.bezeichnung,
              r_hwas_betriebssystem.bemerkung,
              r_hwas_betriebssystem.inserted,
              r_hwas_betriebssystem.inserted_by );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_hwas_betriebssystem);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

    procedure p_update (
        pir_hwas_betriebssystem in hwas_betriebssystem%rowtype,
        piv_art                 in varchar2
    ) is
        r_hwas_betriebssystem hwas_betriebssystem%rowtype;        

-- fuer exceptions        
        v_routine_name        logs.routine_name%type;
        c_message             clob;
    begin        
  -- fuer exceptions      
        v_routine_name := gcv_package_name || '.P_UPDATE';
        case piv_art
            when '<full>' then    
      -- Ã?bernehmen der Eingabedaten  
                r_hwas_betriebssystem := pir_hwas_betriebssystem;  
      -- ErgÃ¤nzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_hwas_betriebssystem.inserted,
                    r_hwas_betriebssystem.inserted_by
                from
                    hwas_betriebssystem
                where
                    system_id = pir_hwas_betriebssystem.system_id;  
      -- ErgÃ¤nzen der Update-Daten  
                r_hwas_betriebssystem.updated := sysdate;
                r_hwas_betriebssystem.updated_by := pck_env.fv_user;
                update hwas_betriebssystem
                set
                    row = r_hwas_betriebssystem
                where
                    system_id = pir_hwas_betriebssystem.system_id;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then      
  -- Fehlerprotokollierung      
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_hwas_betriebssystem);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;        

---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_system_id in hwas_betriebssystem.system_id%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_SYSTEM_ID: ' || to_char(pin_system_id);
        delete from hwas_betriebssystem
        where
            system_id = pin_system_id;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle hwas_betriebssystem! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle hwas_betriebssystem! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_hwas_betriebssystem_dml;
/

