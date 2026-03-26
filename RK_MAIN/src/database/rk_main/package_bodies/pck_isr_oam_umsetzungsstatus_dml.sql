create or replace package body rk_main.pck_isr_oam_umsetzungsstatus_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in isr_oam_umsetzungsstatus%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'uss_uid = '
                        || to_char(pir_row.uss_uid)
                        || cv_sep
                        || ', uss_bezeichnung = '
                        || pir_row.uss_bezeichnung
                        || cv_sep
                        || ', uss_beschreibung = '
                        || pir_row.uss_beschreibung
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
            v_retval := '<table><tr><th>ISR_OAM_UMSETZUNGSSTATUS</th><th>Column</th></tr>'
                        || '<tr><td>uss_uid</td><td>'
                        || to_char(pir_row.uss_uid)
                        || '</td></tr>'
                        || '<tr><td>uss_bezeichnung</td><td>'
                        || pir_row.uss_bezeichnung
                        || '</td></tr>'
                        || '<tr><td>uss_beschreibung</td><td>'
                        || pir_row.uss_beschreibung
                        || '</td></tr>'
                        || '</table>';
        else
            v_retval := null;
        end if;

        return v_retval;
    end fv_print;

---------------------------------------------------------------------------------------------------

    procedure p_insert (
        pior_isr_oam_umsetzungsstatus in out isr_oam_umsetzungsstatus%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_isr_oam_umsetzungsstatus.inserted := sysdate;
        pior_isr_oam_umsetzungsstatus.inserted_by := pck_env.fv_user;
        insert into isr_oam_umsetzungsstatus values pior_isr_oam_umsetzungsstatus returning uss_uid into pior_isr_oam_umsetzungsstatus.uss_uid
        ;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle isr_oam_umsetzungsstatus! Parameter: ' || fv_print(pir_row => pior_isr_oam_umsetzungsstatus
            );
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_isr_oam_umsetzungsstatus in isr_oam_umsetzungsstatus%rowtype
    ) is
        r_isr_oam_umsetzungsstatus isr_oam_umsetzungsstatus%rowtype;

  -- fuer exceptions
        v_routine_name             logs.routine_name%type;
        c_message                  clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_isr_oam_umsetzungsstatus := pir_isr_oam_umsetzungsstatus;
        merge into isr_oam_umsetzungsstatus
        using dual on ( uss_uid = r_isr_oam_umsetzungsstatus.uss_uid )
        when matched then update
        set uss_bezeichnung = r_isr_oam_umsetzungsstatus.uss_bezeichnung,
            uss_beschreibung = r_isr_oam_umsetzungsstatus.uss_beschreibung
        when not matched then
        insert (
            uss_bezeichnung,
            uss_beschreibung )
        values
            ( r_isr_oam_umsetzungsstatus.uss_bezeichnung,
              r_isr_oam_umsetzungsstatus.uss_beschreibung );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_isr_oam_umsetzungsstatus);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

/* Update-Alternative M. Schmenner */
    procedure p_update (
        pir_isr_oam_umsetzungsstatus in isr_oam_umsetzungsstatus%rowtype,
        piv_art                      in varchar2
    ) is
        r_isr_oam_umsetzungsstatus isr_oam_umsetzungsstatus%rowtype;        

-- fuer exceptions        
        v_routine_name             logs.routine_name%type;
        c_message                  clob;
    begin        
  -- fuer exceptions      
        v_routine_name := gcv_package_name || '.P_UPDATE';
        case piv_art
            when '<full>' then    
      -- Übernehmen der Eingabedaten  
                r_isr_oam_umsetzungsstatus := pir_isr_oam_umsetzungsstatus;  
      -- Ergänzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_isr_oam_umsetzungsstatus.inserted,
                    r_isr_oam_umsetzungsstatus.inserted_by
                from
                    isr_oam_umsetzungsstatus
                where
                    uss_uid = pir_isr_oam_umsetzungsstatus.uss_uid;  
      -- Ergänzen der Update-Daten  
                r_isr_oam_umsetzungsstatus.updated := sysdate;
                r_isr_oam_umsetzungsstatus.updated_by := pck_env.fv_user;
                update isr_oam_umsetzungsstatus
                set
                    row = r_isr_oam_umsetzungsstatus
                where
                    uss_uid = pir_isr_oam_umsetzungsstatus.uss_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then      
  -- Fehlerprotokollierung      
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_isr_oam_umsetzungsstatus);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;        

---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_uss_uid in isr_oam_umsetzungsstatus.uss_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_uss_uid: ' || to_char(pin_uss_uid);
        delete from isr_oam_umsetzungsstatus
        where
            uss_uid = pin_uss_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle isr_oam_umsetzungsstatus! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle isr_oam_umsetzungsstatus! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_isr_oam_umsetzungsstatus_dml;
/


-- sqlcl_snapshot {"hash":"284d76341566a685e1d569a86208d57692b77430","type":"PACKAGE_BODY","name":"PCK_ISR_OAM_UMSETZUNGSSTATUS_DML","schemaName":"RK_MAIN","sxml":""}