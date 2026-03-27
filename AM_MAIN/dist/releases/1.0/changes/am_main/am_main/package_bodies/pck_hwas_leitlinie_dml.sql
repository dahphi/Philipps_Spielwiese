-- liquibase formatted sql
-- changeset AM_MAIN:1774600113501 stripComments:false logicalFilePath:am_main/am_main/package_bodies/pck_hwas_leitlinie_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_bodies/pck_hwas_leitlinie_dml.sql:null:50bcf2ede28c27adb5dae1b08e3940d5525812d7:create

create or replace package body am_main.pck_hwas_leitlinie_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in hwas_leitlinie%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'll_uid = '
                        || to_char(pir_row.ll_uid)
                        || cv_sep
                        || ', ll_titel = '
                        || pir_row.ll_titel
                        || cv_sep
                        || ', ll_beschreibung = '
                        || pir_row.ll_beschreibung
                        || cv_sep
                        || ', ll_ansprechpartner = '
                        || pir_row.ll_ansprechpartner
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
            v_retval := '<table><tr><th>HWAS_LEITLINIE</th><th>Column</th></tr>'
                        || '<tr><td>ll_uid</td><td>'
                        || to_char(pir_row.ll_uid)
                        || '</td></tr>'
                        || '<tr><td>ll_titel</td><td>'
                        || pir_row.ll_titel
                        || '</td></tr>'
                        || '<tr><td>ll_beschreibung</td><td>'
                        || pir_row.ll_beschreibung
                        || '</td></tr>'
                        || '<tr><td>ll_ansprechpartner</td><td>'
                        || pir_row.ll_ansprechpartner
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
        pior_hwas_leitlinie in out hwas_leitlinie%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_hwas_leitlinie.inserted := sysdate;
        pior_hwas_leitlinie.inserted_by := pck_env.fv_user;
        insert into hwas_leitlinie values pior_hwas_leitlinie returning ll_uid into pior_hwas_leitlinie.ll_uid;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle hwas_leitlinie! Parameter: ' || fv_print(pir_row => pior_hwas_leitlinie);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_hwas_leitlinie in hwas_leitlinie%rowtype
    ) is
        r_hwas_leitlinie hwas_leitlinie%rowtype;

  -- fuer exceptions
        v_routine_name   logs.routine_name%type;
        c_message        clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_hwas_leitlinie := pir_hwas_leitlinie;
        r_hwas_leitlinie.inserted := sysdate;
        r_hwas_leitlinie.updated := sysdate;
        r_hwas_leitlinie.inserted_by := pck_env.fv_user;
        r_hwas_leitlinie.updated_by := pck_env.fv_user;
        merge into hwas_leitlinie
        using dual on ( ll_uid = r_hwas_leitlinie.ll_uid )
        when matched then update
        set ll_titel = r_hwas_leitlinie.ll_titel,
            ll_beschreibung = r_hwas_leitlinie.ll_beschreibung,
            ll_ansprechpartner = r_hwas_leitlinie.ll_ansprechpartner,
            updated = r_hwas_leitlinie.updated,
            updated_by = r_hwas_leitlinie.updated_by
        when not matched then
        insert (
            ll_titel,
            ll_beschreibung,
            ll_ansprechpartner,
            inserted,
            inserted_by )
        values
            ( r_hwas_leitlinie.ll_titel,
              r_hwas_leitlinie.ll_beschreibung,
              r_hwas_leitlinie.ll_ansprechpartner,
              r_hwas_leitlinie.inserted,
              r_hwas_leitlinie.inserted_by );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_hwas_leitlinie);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

/* Update-Alternative M. Schmenner */
    procedure p_update (
        pir_hwas_leitlinie in hwas_leitlinie%rowtype,
        piv_art            in varchar2
    ) is
        r_hwas_leitlinie hwas_leitlinie%rowtype;        

-- fuer exceptions        
        v_routine_name   logs.routine_name%type;
        c_message        clob;
    begin        
  -- fuer exceptions      
        v_routine_name := gcv_package_name || '.P_UPDATE';
        case piv_art
            when '<full>' then    
      -- Übernehmen der Eingabedaten  
                r_hwas_leitlinie := pir_hwas_leitlinie;  
      -- Ergänzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_hwas_leitlinie.inserted,
                    r_hwas_leitlinie.inserted_by
                from
                    hwas_leitlinie
                where
                    ll_uid = pir_hwas_leitlinie.ll_uid;  
      -- Ergänzen der Update-Daten  
                r_hwas_leitlinie.updated := sysdate;
                r_hwas_leitlinie.updated_by := pck_env.fv_user;
                update hwas_leitlinie
                set
                    row = r_hwas_leitlinie
                where
                    ll_uid = pir_hwas_leitlinie.ll_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then      
  -- Fehlerprotokollierung      
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_hwas_leitlinie);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;        

---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_ll_uid in hwas_leitlinie.ll_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_ll_uid: ' || to_char(pin_ll_uid);
        delete from hwas_leitlinie
        where
            ll_uid = pin_ll_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle hwas_leitlinie! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle hwas_leitlinie! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_hwas_leitlinie_dml;
/

