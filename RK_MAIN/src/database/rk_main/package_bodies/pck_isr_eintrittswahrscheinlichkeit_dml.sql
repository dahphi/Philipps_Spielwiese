create or replace package body rk_main.pck_isr_eintrittswahrscheinlichkeit_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in isr_eintrittswahrscheinlichkeit%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'ews_uid = '
                        || to_char(pir_row.ews_uid)
                        || cv_sep
                        || ', ews_bezeichnung = '
                        || pir_row.ews_bezeichnung
                        || cv_sep
                        || ', ews_wert = '
                        || to_char(pir_row.ews_wert)
                        || cv_sep
                        || ', ews_prozentsatz = '
                        || to_char(pir_row.ews_prozentsatz)
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
                        || ', ews_kriterien = '
                        || pir_row.ews_kriterien
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
            v_retval := '<table><tr><th>ISR_EINTRITTSWAHRSCHEINLICHKEIT</th><th>Column</th></tr>'
                        || '<tr><td>ews_uid</td><td>'
                        || to_char(pir_row.ews_uid)
                        || '</td></tr>'
                        || '<tr><td>ews_bezeichnung</td><td>'
                        || pir_row.ews_bezeichnung
                        || '</td></tr>'
                        || '<tr><td>ews_wert</td><td>'
                        || to_char(pir_row.ews_wert)
                        || '</td></tr>'
                        || '<tr><td>ews_prozentsatz</td><td>'
                        || to_char(pir_row.ews_prozentsatz)
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
                        || '<tr><td>ews_kriterien</td><td>'
                        || pir_row.ews_kriterien
                        || '</td></tr>'
                        || '</table>';
        else
            v_retval := null;
        end if;

        return v_retval;
    end fv_print;

---------------------------------------------------------------------------------------------------

    procedure p_insert (
        pior_isr_eintrittswahrscheinlichkeit in out isr_eintrittswahrscheinlichkeit%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_isr_eintrittswahrscheinlichkeit.inserted := sysdate;
        pior_isr_eintrittswahrscheinlichkeit.inserted_by := pck_env.fv_user;
        insert into isr_eintrittswahrscheinlichkeit values pior_isr_eintrittswahrscheinlichkeit returning ews_uid into pior_isr_eintrittswahrscheinlichkeit.ews_uid
        ;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle isr_eintrittswahrscheinlichkeit! Parameter: ' || fv_print(pir_row => pior_isr_eintrittswahrscheinlichkeit
            );
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_isr_eintrittswahrscheinlichkeit in isr_eintrittswahrscheinlichkeit%rowtype
    ) is
        r_isr_eintrittswahrscheinlichkeit isr_eintrittswahrscheinlichkeit%rowtype;

  -- fuer exceptions
        v_routine_name                    logs.routine_name%type;
        c_message                         clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_isr_eintrittswahrscheinlichkeit := pir_isr_eintrittswahrscheinlichkeit;
        r_isr_eintrittswahrscheinlichkeit.inserted := sysdate;
        r_isr_eintrittswahrscheinlichkeit.updated := sysdate;
        r_isr_eintrittswahrscheinlichkeit.inserted_by := pck_env.fv_user;
        r_isr_eintrittswahrscheinlichkeit.updated_by := pck_env.fv_user;
        merge into isr_eintrittswahrscheinlichkeit
        using dual on ( ews_uid = r_isr_eintrittswahrscheinlichkeit.ews_uid )
        when matched then update
        set ews_bezeichnung = r_isr_eintrittswahrscheinlichkeit.ews_bezeichnung,
            ews_wert = r_isr_eintrittswahrscheinlichkeit.ews_wert,
            ews_prozentsatz = r_isr_eintrittswahrscheinlichkeit.ews_prozentsatz,
            updated = r_isr_eintrittswahrscheinlichkeit.updated,
            updated_by = r_isr_eintrittswahrscheinlichkeit.updated_by,
            ews_kriterien = r_isr_eintrittswahrscheinlichkeit.ews_kriterien
        when not matched then
        insert (
            ews_bezeichnung,
            ews_wert,
            ews_prozentsatz,
            inserted,
            inserted_by,
            ews_kriterien )
        values
            ( r_isr_eintrittswahrscheinlichkeit.ews_bezeichnung,
              r_isr_eintrittswahrscheinlichkeit.ews_wert,
              r_isr_eintrittswahrscheinlichkeit.ews_prozentsatz,
              r_isr_eintrittswahrscheinlichkeit.inserted,
              r_isr_eintrittswahrscheinlichkeit.inserted_by,
              r_isr_eintrittswahrscheinlichkeit.ews_kriterien );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_isr_eintrittswahrscheinlichkeit);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

/* Update-Alternative M. Schmenner */
    procedure p_update (
        pir_isr_eintrittswahrscheinlichkeit in isr_eintrittswahrscheinlichkeit%rowtype,
        piv_art                             in varchar2
    ) is
        r_isr_eintrittswahrscheinlichkeit isr_eintrittswahrscheinlichkeit%rowtype;        

-- fuer exceptions        
        v_routine_name                    logs.routine_name%type;
        c_message                         clob;
    begin        
  -- fuer exceptions      
        v_routine_name := gcv_package_name || '.P_UPDATE';
        case piv_art
            when '<full>' then    
      -- Übernehmen der Eingabedaten  
                r_isr_eintrittswahrscheinlichkeit := pir_isr_eintrittswahrscheinlichkeit;  
      -- Ergänzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_isr_eintrittswahrscheinlichkeit.inserted,
                    r_isr_eintrittswahrscheinlichkeit.inserted_by
                from
                    isr_eintrittswahrscheinlichkeit
                where
                    ews_uid = pir_isr_eintrittswahrscheinlichkeit.ews_uid;  
      -- Ergänzen der Update-Daten  
                r_isr_eintrittswahrscheinlichkeit.updated := sysdate;
                r_isr_eintrittswahrscheinlichkeit.updated_by := pck_env.fv_user;
                update isr_eintrittswahrscheinlichkeit
                set
                    row = r_isr_eintrittswahrscheinlichkeit
                where
                    ews_uid = pir_isr_eintrittswahrscheinlichkeit.ews_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then      
  -- Fehlerprotokollierung      
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_isr_eintrittswahrscheinlichkeit);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;        

---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_ews_uid in isr_eintrittswahrscheinlichkeit.ews_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_ews_uid: ' || to_char(pin_ews_uid);
        delete from isr_eintrittswahrscheinlichkeit
        where
            ews_uid = pin_ews_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle isr_eintrittswahrscheinlichkeit! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle isr_eintrittswahrscheinlichkeit! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_isr_eintrittswahrscheinlichkeit_dml;
/


-- sqlcl_snapshot {"hash":"e1f6f48ecece21d16cee8b748a8ad4f1ef359585","type":"PACKAGE_BODY","name":"PCK_ISR_EINTRITTSWAHRSCHEINLICHKEIT_DML","schemaName":"RK_MAIN","sxml":""}