-- liquibase formatted sql
-- changeset AM_MAIN:1774600112529 stripComments:false logicalFilePath:am_main/am_main/package_bodies/pck_hwas_krit_dienstlstg_e1_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_bodies/pck_hwas_krit_dienstlstg_e1_dml.sql:null:39e1e6e0126626c3c9fd8720bbae54c69b8b8320:create

create or replace package body am_main.pck_hwas_krit_dienstlstg_e1_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in hwas_krit_dienstlstg_e1%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'kd1_uid = '
                        || to_char(pir_row.kd1_uid)
                        || cv_sep
                        || ', kd1_bezeichnung = '
                        || pir_row.kd1_bezeichnung
                        || cv_sep
                        || ', kd1_nummer = '
                        || to_char(pir_row.kd1_nummer)
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
                        || ', kd1_link = '
                        || pir_row.kd1_link
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
            v_retval := '<table><tr><th>HWAS_KRIT_DIENSTLSTG_E1</th><th>Column</th></tr>'
                        || '<tr><td>kd1_uid</td><td>'
                        || to_char(pir_row.kd1_uid)
                        || '</td></tr>'
                        || '<tr><td>kd1_bezeichnung</td><td>'
                        || pir_row.kd1_bezeichnung
                        || '</td></tr>'
                        || '<tr><td>kd1_nummer</td><td>'
                        || to_char(pir_row.kd1_nummer)
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
                        || '<tr><td>kd1_link</td><td>'
                        || pir_row.kd1_link
                        || '</td></tr>'
                        || '</table>';
        else
            v_retval := null;
        end if;

        return v_retval;
    end fv_print;

---------------------------------------------------------------------------------------------------

    procedure p_insert (
        pior_hwas_krit_dienstlstg_e1 in out hwas_krit_dienstlstg_e1%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_hwas_krit_dienstlstg_e1.inserted := sysdate;
        pior_hwas_krit_dienstlstg_e1.inserted_by := pck_env.fv_user;
        insert into hwas_krit_dienstlstg_e1 values pior_hwas_krit_dienstlstg_e1 returning kd1_uid into pior_hwas_krit_dienstlstg_e1.kd1_uid
        ;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle hwas_krit_dienstlstg_e1! Parameter: ' || fv_print(pir_row => pior_hwas_krit_dienstlstg_e1
            );
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_hwas_krit_dienstlstg_e1 in hwas_krit_dienstlstg_e1%rowtype
    ) is
        r_hwas_krit_dienstlstg_e1 hwas_krit_dienstlstg_e1%rowtype;

  -- fuer exceptions
        v_routine_name            logs.routine_name%type;
        c_message                 clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_hwas_krit_dienstlstg_e1 := pir_hwas_krit_dienstlstg_e1;
        r_hwas_krit_dienstlstg_e1.inserted := sysdate;
        r_hwas_krit_dienstlstg_e1.updated := sysdate;
        r_hwas_krit_dienstlstg_e1.inserted_by := pck_env.fv_user;
        r_hwas_krit_dienstlstg_e1.updated_by := pck_env.fv_user;
        merge into hwas_krit_dienstlstg_e1
        using dual on ( kd1_uid = r_hwas_krit_dienstlstg_e1.kd1_uid )
        when matched then update
        set kd1_bezeichnung = r_hwas_krit_dienstlstg_e1.kd1_bezeichnung,
            kd1_nummer = r_hwas_krit_dienstlstg_e1.kd1_nummer,
            updated = r_hwas_krit_dienstlstg_e1.updated,
            updated_by = r_hwas_krit_dienstlstg_e1.updated_by,
            kd1_link = r_hwas_krit_dienstlstg_e1.kd1_link
        when not matched then
        insert (
            kd1_bezeichnung,
            kd1_nummer,
            inserted,
            inserted_by,
            kd1_link )
        values
            ( r_hwas_krit_dienstlstg_e1.kd1_bezeichnung,
              r_hwas_krit_dienstlstg_e1.kd1_nummer,
              r_hwas_krit_dienstlstg_e1.inserted,
              r_hwas_krit_dienstlstg_e1.inserted_by,
              r_hwas_krit_dienstlstg_e1.kd1_link );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_hwas_krit_dienstlstg_e1);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

/* Update-Alternative M. Schmenner */
    procedure p_update (
        pir_hwas_krit_dienstlstg_e1 in hwas_krit_dienstlstg_e1%rowtype,
        piv_art                     in varchar2
    ) is
        r_hwas_krit_dienstlstg_e1 hwas_krit_dienstlstg_e1%rowtype;        

-- fuer exceptions        
        v_routine_name            logs.routine_name%type;
        c_message                 clob;
    begin        
  -- fuer exceptions      
        v_routine_name := gcv_package_name || '.P_UPDATE';
        case piv_art
            when '<full>' then    
      -- Übernehmen der Eingabedaten  
                r_hwas_krit_dienstlstg_e1 := pir_hwas_krit_dienstlstg_e1;  
      -- Ergänzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_hwas_krit_dienstlstg_e1.inserted,
                    r_hwas_krit_dienstlstg_e1.inserted_by
                from
                    hwas_krit_dienstlstg_e1
                where
                    kd1_uid = pir_hwas_krit_dienstlstg_e1.kd1_uid;  
      -- Ergänzen der Update-Daten  
                r_hwas_krit_dienstlstg_e1.updated := sysdate;
                r_hwas_krit_dienstlstg_e1.updated_by := pck_env.fv_user;
                update hwas_krit_dienstlstg_e1
                set
                    row = r_hwas_krit_dienstlstg_e1
                where
                    kd1_uid = pir_hwas_krit_dienstlstg_e1.kd1_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then      
  -- Fehlerprotokollierung      
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_hwas_krit_dienstlstg_e1);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;        

---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_kd1_uid in hwas_krit_dienstlstg_e1.kd1_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_kd1_uid: ' || to_char(pin_kd1_uid);
        delete from hwas_krit_dienstlstg_e1
        where
            kd1_uid = pin_kd1_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle hwas_krit_dienstlstg_e1! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle hwas_krit_dienstlstg_e1! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_hwas_krit_dienstlstg_e1_dml;
/

