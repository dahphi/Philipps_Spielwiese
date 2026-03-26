create or replace package body am_main.pck_hwas_tk_technologie_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in hwas_tk_technologie%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'tkt_uid = '
                        || to_char(pir_row.tkt_uid)
                        || cv_sep
                        || ', tkt_bezeichnung = '
                        || pir_row.tkt_bezeichnung
                        || cv_sep
                        || ', tkt_highlights = '
                        || pir_row.tkt_highlights
                        || cv_sep
                        || ', ak3_uid = '
                        || to_char(pir_row.ak3_uid)
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
                        || ', tkt_lebenszyklus_status = '
                        || pir_row.tkt_lebenszyklus_status
                        || cv_sep
                        || ', bip_uid = '
                        || to_char(pir_row.bip_uid)
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
            v_retval := '<table><tr><th>HWAS_TK_TECHNOLOGIE</th><th>Column</th></tr>'
                        || '<tr><td>tkt_uid</td><td>'
                        || to_char(pir_row.tkt_uid)
                        || '</td></tr>'
                        || '<tr><td>tkt_bezeichnung</td><td>'
                        || pir_row.tkt_bezeichnung
                        || '</td></tr>'
                        || '<tr><td>tkt_highlights</td><td>'
                        || pir_row.tkt_highlights
                        || '</td></tr>'
                        || '<tr><td>ak3_uid</td><td>'
                        || to_char(pir_row.ak3_uid)
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
                        || '<tr><td>tkt_lebenszyklus_status</td><td>'
                        || pir_row.tkt_lebenszyklus_status
                        || '</td></tr>'
                        || '<tr><td>bip_uid</td><td>'
                        || to_char(pir_row.bip_uid)
                        || '</td></tr>'
                        || '</table>';
        else
            v_retval := null;
        end if;

        return v_retval;
    end fv_print;

---------------------------------------------------------------------------------------------------

    procedure p_insert (
        pior_hwas_tk_technologie in out hwas_tk_technologie%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_hwas_tk_technologie.inserted := sysdate;
        pior_hwas_tk_technologie.inserted_by := pck_env.fv_user;
        insert into hwas_tk_technologie values pior_hwas_tk_technologie returning tkt_uid into pior_hwas_tk_technologie.tkt_uid;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle hwas_tk_technologie! Parameter: ' || fv_print(pir_row => pior_hwas_tk_technologie
            );
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_hwas_tk_technologie in hwas_tk_technologie%rowtype
    ) is
        r_hwas_tk_technologie hwas_tk_technologie%rowtype;

  -- fuer exceptions
        v_routine_name        logs.routine_name%type;
        c_message             clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_hwas_tk_technologie := pir_hwas_tk_technologie;
        r_hwas_tk_technologie.inserted := sysdate;
        r_hwas_tk_technologie.updated := sysdate;
        r_hwas_tk_technologie.inserted_by := pck_env.fv_user;
        r_hwas_tk_technologie.updated_by := pck_env.fv_user;
        merge into hwas_tk_technologie
        using dual on ( tkt_uid = r_hwas_tk_technologie.tkt_uid )
        when matched then update
        set tkt_bezeichnung = r_hwas_tk_technologie.tkt_bezeichnung,
            tkt_highlights = r_hwas_tk_technologie.tkt_highlights,
            ak3_uid = r_hwas_tk_technologie.ak3_uid,
            updated = r_hwas_tk_technologie.updated,
            updated_by = r_hwas_tk_technologie.updated_by,
            tkt_lebenszyklus_status = r_hwas_tk_technologie.tkt_lebenszyklus_status,
            bip_uid = r_hwas_tk_technologie.bip_uid
        when not matched then
        insert (
            tkt_bezeichnung,
            tkt_highlights,
            ak3_uid,
            inserted,
            inserted_by,
            tkt_lebenszyklus_status,
            bip_uid )
        values
            ( r_hwas_tk_technologie.tkt_bezeichnung,
              r_hwas_tk_technologie.tkt_highlights,
              r_hwas_tk_technologie.ak3_uid,
              r_hwas_tk_technologie.inserted,
              r_hwas_tk_technologie.inserted_by,
              r_hwas_tk_technologie.tkt_lebenszyklus_status,
              r_hwas_tk_technologie.bip_uid );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_hwas_tk_technologie);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

    procedure p_update (
        pir_hwas_tk_technologie in hwas_tk_technologie%rowtype,
        piv_art                 in varchar2
    ) is
        r_hwas_tk_technologie hwas_tk_technologie%rowtype;

  -- fuer exceptions
        v_routine_name        logs.routine_name%type;
        c_message             clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_UPDATE';
        r_hwas_tk_technologie.tkt_bezeichnung := pir_hwas_tk_technologie.tkt_bezeichnung;
        r_hwas_tk_technologie.tkt_highlights := pir_hwas_tk_technologie.tkt_highlights;
        r_hwas_tk_technologie.ak3_uid := pir_hwas_tk_technologie.ak3_uid;
        r_hwas_tk_technologie.updated := sysdate;
        r_hwas_tk_technologie.updated_by := pck_env.fv_user;
        r_hwas_tk_technologie.tkt_lebenszyklus_status := pir_hwas_tk_technologie.tkt_lebenszyklus_status;
        r_hwas_tk_technologie.bip_uid := pir_hwas_tk_technologie.bip_uid;
        case piv_art
            when '<replace>' then
                update hwas_tk_technologie
                set
                    tkt_uid = pir_hwas_tk_technologie.tkt_uid
                where
                    tkt_uid = pir_hwas_tk_technologie.tkt_uid;

            when '<full>' then    
      -- Übernehmen der Eingabedaten  
                r_hwas_tk_technologie := pir_hwas_tk_technologie;  
      -- Ergänzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_hwas_tk_technologie.inserted,
                    r_hwas_tk_technologie.inserted_by
                from
                    hwas_tk_technologie
                where
                    tkt_uid = pir_hwas_tk_technologie.tkt_uid;  
      -- Ergänzen der Update-Daten  
                r_hwas_tk_technologie.updated := sysdate;
                r_hwas_tk_technologie.updated_by := pck_env.fv_user;
                update hwas_tk_technologie
                set
                    row = r_hwas_tk_technologie
                where
                    tkt_uid = pir_hwas_tk_technologie.tkt_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_hwas_tk_technologie);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;


---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_tkt_uid in hwas_tk_technologie.tkt_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_tkt_uid: ' || to_char(pin_tkt_uid);
        delete from hwas_tk_technologie
        where
            tkt_uid = pin_tkt_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle hwas_tk_technologie! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle hwas_tk_technologie! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_hwas_tk_technologie_dml;
/


-- sqlcl_snapshot {"hash":"6bf9c5d66037b692a0faaec7434afba4341879b4","type":"PACKAGE_BODY","name":"PCK_HWAS_TK_TECHNOLOGIE_DML","schemaName":"AM_MAIN","sxml":""}