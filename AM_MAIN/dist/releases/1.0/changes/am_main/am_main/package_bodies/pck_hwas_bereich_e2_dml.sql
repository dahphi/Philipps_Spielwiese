-- liquibase formatted sql
-- changeset AM_MAIN:1774600103859 stripComments:false logicalFilePath:am_main/am_main/package_bodies/pck_hwas_bereich_e2_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_bodies/pck_hwas_bereich_e2_dml.sql:null:adf676a86e2571d14b1bc88bf05fcc62880d20c3:create

create or replace package body am_main.pck_hwas_bereich_e2_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in hwas_bereich_e2%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'be2_uid = '
                        || to_char(pir_row.be2_uid)
                        || cv_sep
                        || ', be2_bezeichnung = '
                        || pir_row.be2_bezeichnung
                        || cv_sep
                        || ', be2_nummer = '
                        || to_char(pir_row.be2_nummer)
                        || cv_sep
                        || ', kd1_uid = '
                        || to_char(pir_row.kd1_uid)
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
            v_retval := '<table><tr><th>HWAS_BEREICH_E2</th><th>Column</th></tr>'
                        || '<tr><td>be2_uid</td><td>'
                        || to_char(pir_row.be2_uid)
                        || '</td></tr>'
                        || '<tr><td>be2_bezeichnung</td><td>'
                        || pir_row.be2_bezeichnung
                        || '</td></tr>'
                        || '<tr><td>be2_nummer</td><td>'
                        || to_char(pir_row.be2_nummer)
                        || '</td></tr>'
                        || '<tr><td>kd1_uid</td><td>'
                        || to_char(pir_row.kd1_uid)
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
        pior_hwas_bereich_e2 in out hwas_bereich_e2%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_hwas_bereich_e2.inserted := sysdate;
        pior_hwas_bereich_e2.inserted_by := pck_env.fv_user;
        insert into hwas_bereich_e2 values pior_hwas_bereich_e2 returning be2_uid into pior_hwas_bereich_e2.be2_uid;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle hwas_bereich_e2! Parameter: ' || fv_print(pir_row => pior_hwas_bereich_e2);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_hwas_bereich_e2 in hwas_bereich_e2%rowtype
    ) is
        r_hwas_bereich_e2 hwas_bereich_e2%rowtype;

  -- fuer exceptions
        v_routine_name    logs.routine_name%type;
        c_message         clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_hwas_bereich_e2 := pir_hwas_bereich_e2;
        r_hwas_bereich_e2.inserted := sysdate;
        r_hwas_bereich_e2.updated := sysdate;
        r_hwas_bereich_e2.inserted_by := pck_env.fv_user;
        r_hwas_bereich_e2.updated_by := pck_env.fv_user;
        merge into hwas_bereich_e2
        using dual on ( be2_uid = r_hwas_bereich_e2.be2_uid )
        when matched then update
        set be2_bezeichnung = r_hwas_bereich_e2.be2_bezeichnung,
            be2_nummer = r_hwas_bereich_e2.be2_nummer,
            kd1_uid = r_hwas_bereich_e2.kd1_uid,
            updated = r_hwas_bereich_e2.updated,
            updated_by = r_hwas_bereich_e2.updated_by
        when not matched then
        insert (
            be2_bezeichnung,
            be2_nummer,
            kd1_uid,
            inserted,
            inserted_by )
        values
            ( r_hwas_bereich_e2.be2_bezeichnung,
              r_hwas_bereich_e2.be2_nummer,
              r_hwas_bereich_e2.kd1_uid,
              r_hwas_bereich_e2.inserted,
              r_hwas_bereich_e2.inserted_by );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_hwas_bereich_e2);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

/* Update-Alternative M. Schmenner */
    procedure p_update (
        pir_hwas_bereich_e2 in hwas_bereich_e2%rowtype,
        piv_art             in varchar2
    ) is
        r_hwas_bereich_e2 hwas_bereich_e2%rowtype;        

-- fuer exceptions        
        v_routine_name    logs.routine_name%type;
        c_message         clob;
    begin        
  -- fuer exceptions      
        v_routine_name := gcv_package_name || '.P_UPDATE';
        case piv_art
            when '<full>' then    
      -- Ã?bernehmen der Eingabedaten  
                r_hwas_bereich_e2 := pir_hwas_bereich_e2;  
      -- ErgÃ¤nzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_hwas_bereich_e2.inserted,
                    r_hwas_bereich_e2.inserted_by
                from
                    hwas_bereich_e2
                where
                    be2_uid = pir_hwas_bereich_e2.be2_uid;  
      -- ErgÃ¤nzen der Update-Daten  
                r_hwas_bereich_e2.updated := sysdate;
                r_hwas_bereich_e2.updated_by := pck_env.fv_user;
                update hwas_bereich_e2
                set
                    row = r_hwas_bereich_e2
                where
                    be2_uid = pir_hwas_bereich_e2.be2_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then      
  -- Fehlerprotokollierung      
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_hwas_bereich_e2);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;        

---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_be2_uid in hwas_bereich_e2.be2_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_be2_uid: ' || to_char(pin_be2_uid);
        delete from hwas_bereich_e2
        where
            be2_uid = pin_be2_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle hwas_bereich_e2! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle hwas_bereich_e2! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_hwas_bereich_e2_dml;
/

