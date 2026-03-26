create or replace package body rk_main.pck_isr_wirkbereich_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in isr_wirkbereich%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'wbr_uid = '
                        || to_char(pir_row.wbr_uid)
                        || cv_sep
                        || ', wbr_bezeichnung = '
                        || pir_row.wbr_bezeichnung
                        || cv_sep
                        || ', wbr_responsible = '
                        || pir_row.wbr_responsible
                        || cv_sep
                        || ', wbr_accountable = '
                        || pir_row.wbr_accountable
                        || cv_sep
                        || ', wbr_supportive = '
                        || pir_row.wbr_supportive
                        || cv_sep
                        || ', wbr_consulted = '
                        || pir_row.wbr_consulted
                        || cv_sep
                        || ', wbi_informed = '
                        || pir_row.wbi_informed
                        || cv_sep
                        || ', i2a_uids = '
                        || pir_row.i2a_uids
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
            v_retval := '<table><tr><th>ISR_WIRKBEREICH</th><th>Column</th></tr>'
                        || '<tr><td>wbr_uid</td><td>'
                        || to_char(pir_row.wbr_uid)
                        || '</td></tr>'
                        || '<tr><td>wbr_bezeichnung</td><td>'
                        || pir_row.wbr_bezeichnung
                        || '</td></tr>'
                        || '<tr><td>wbr_responsible</td><td>'
                        || pir_row.wbr_responsible
                        || '</td></tr>'
                        || '<tr><td>wbr_accountable</td><td>'
                        || pir_row.wbr_accountable
                        || '</td></tr>'
                        || '<tr><td>wbr_supportive</td><td>'
                        || pir_row.wbr_supportive
                        || '</td></tr>'
                        || '<tr><td>wbr_consulted</td><td>'
                        || pir_row.wbr_consulted
                        || '</td></tr>'
                        || '<tr><td>wbi_informed</td><td>'
                        || pir_row.wbi_informed
                        || '</td></tr>'
                        || '<tr><td>i2a_uids</td><td>'
                        || pir_row.i2a_uids
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
        pior_isr_wirkbereich in out isr_wirkbereich%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_isr_wirkbereich.inserted := sysdate;
        pior_isr_wirkbereich.inserted_by := pck_env.fv_user;
        insert into isr_wirkbereich values pior_isr_wirkbereich returning wbr_uid into pior_isr_wirkbereich.wbr_uid;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle isr_wirkbereich! Parameter: ' || fv_print(pir_row => pior_isr_wirkbereich);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_isr_wirkbereich in isr_wirkbereich%rowtype
    ) is
        r_isr_wirkbereich isr_wirkbereich%rowtype;

  -- fuer exceptions
        v_routine_name    logs.routine_name%type;
        c_message         clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_isr_wirkbereich := pir_isr_wirkbereich;
        r_isr_wirkbereich.inserted := sysdate;
        r_isr_wirkbereich.updated := sysdate;
        r_isr_wirkbereich.inserted_by := pck_env.fv_user;
        r_isr_wirkbereich.updated_by := pck_env.fv_user;
        merge into isr_wirkbereich
        using dual on ( wbr_uid = r_isr_wirkbereich.wbr_uid )
        when matched then update
        set wbr_bezeichnung = r_isr_wirkbereich.wbr_bezeichnung,
            wbr_responsible = r_isr_wirkbereich.wbr_responsible,
            wbr_accountable = r_isr_wirkbereich.wbr_accountable,
            wbr_supportive = r_isr_wirkbereich.wbr_supportive,
            wbr_consulted = r_isr_wirkbereich.wbr_consulted,
            wbi_informed = r_isr_wirkbereich.wbi_informed,
            i2a_uids = r_isr_wirkbereich.i2a_uids,
            updated = r_isr_wirkbereich.updated,
            updated_by = r_isr_wirkbereich.updated_by
        when not matched then
        insert (
            wbr_bezeichnung,
            wbr_responsible,
            wbr_accountable,
            wbr_supportive,
            wbr_consulted,
            wbi_informed,
            i2a_uids,
            inserted,
            inserted_by )
        values
            ( r_isr_wirkbereich.wbr_bezeichnung,
              r_isr_wirkbereich.wbr_responsible,
              r_isr_wirkbereich.wbr_accountable,
              r_isr_wirkbereich.wbr_supportive,
              r_isr_wirkbereich.wbr_consulted,
              r_isr_wirkbereich.wbi_informed,
              r_isr_wirkbereich.i2a_uids,
              r_isr_wirkbereich.inserted,
              r_isr_wirkbereich.inserted_by );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_isr_wirkbereich);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

/* Update-Alternative M. Schmenner */
    procedure p_update (
        pir_isr_wirkbereich in isr_wirkbereich%rowtype,
        piv_art             in varchar2
    ) is
        r_isr_wirkbereich isr_wirkbereich%rowtype;        

-- fuer exceptions        
        v_routine_name    logs.routine_name%type;
        c_message         clob;
    begin        
  -- fuer exceptions      
        v_routine_name := gcv_package_name || '.P_UPDATE';
        case piv_art
            when '<full>' then    
      -- Übernehmen der Eingabedaten  
                r_isr_wirkbereich := pir_isr_wirkbereich;  
      -- Ergänzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_isr_wirkbereich.inserted,
                    r_isr_wirkbereich.inserted_by
                from
                    isr_wirkbereich
                where
                    wbr_uid = pir_isr_wirkbereich.wbr_uid;  
      -- Ergänzen der Update-Daten  
                r_isr_wirkbereich.updated := sysdate;
                r_isr_wirkbereich.updated_by := pck_env.fv_user;
                update isr_wirkbereich
                set
                    row = r_isr_wirkbereich
                where
                    wbr_uid = pir_isr_wirkbereich.wbr_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then      
  -- Fehlerprotokollierung      
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_isr_wirkbereich);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;        

---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_wbr_uid in isr_wirkbereich.wbr_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_wbr_uid: ' || to_char(pin_wbr_uid);
        delete from isr_wirkbereich
        where
            wbr_uid = pin_wbr_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle isr_wirkbereich! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle isr_wirkbereich! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_isr_wirkbereich_dml;
/


-- sqlcl_snapshot {"hash":"baa8abcd3f81327065a9a032123ab6a57e4df927","type":"PACKAGE_BODY","name":"PCK_ISR_WIRKBEREICH_DML","schemaName":"RK_MAIN","sxml":""}