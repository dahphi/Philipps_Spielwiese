create or replace package body rk_main.pck_isr_oam_adressat_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in isr_oam_adressat%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'adr_uid = '
                        || to_char(pir_row.adr_uid)
                        || cv_sep
                        || ', msn_uid = '
                        || to_char(pir_row.msn_uid)
                        || cv_sep
                        || ', adr_rolle = '
                        || pir_row.adr_rolle
                        || cv_sep
                        || ', adr_responsible = '
                        || to_char(pir_row.adr_responsible)
                        || cv_sep
                        || ', adr_accountable = '
                        || to_char(pir_row.adr_accountable)
                        || cv_sep
                        || ', adr_consulted = '
                        || to_char(pir_row.adr_consulted)
                        || cv_sep
                        || ', adr_informed = '
                        || to_char(pir_row.adr_informed)
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
                        || ', adr_san = '
                        || pir_row.adr_san
                        || cv_sep
                        || ', adr_bereich = '
                        || pir_row.adr_bereich
                        || cv_sep
                        || ', adr_oe = '
                        || pir_row.adr_oe
                        || cv_sep
                        || ', adr_support = '
                        || to_char(pir_row.adr_support)
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
            v_retval := '<table><tr><th>ISR_OAM_ADRESSAT</th><th>Column</th></tr>'
                        || '<tr><td>adr_uid</td><td>'
                        || to_char(pir_row.adr_uid)
                        || '</td></tr>'
                        || '<tr><td>msn_uid</td><td>'
                        || to_char(pir_row.msn_uid)
                        || '</td></tr>'
                        || '<tr><td>adr_rolle</td><td>'
                        || pir_row.adr_rolle
                        || '</td></tr>'
                        || '<tr><td>adr_responsible</td><td>'
                        || to_char(pir_row.adr_responsible)
                        || '</td></tr>'
                        || '<tr><td>adr_accountable</td><td>'
                        || to_char(pir_row.adr_accountable)
                        || '</td></tr>'
                        || '<tr><td>adr_consulted</td><td>'
                        || to_char(pir_row.adr_consulted)
                        || '</td></tr>'
                        || '<tr><td>adr_informed</td><td>'
                        || to_char(pir_row.adr_informed)
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
                        || '<tr><td>adr_san</td><td>'
                        || pir_row.adr_san
                        || '</td></tr>'
                        || '<tr><td>adr_bereich</td><td>'
                        || pir_row.adr_bereich
                        || '</td></tr>'
                        || '<tr><td>adr_oe</td><td>'
                        || pir_row.adr_oe
                        || '</td></tr>'
                        || '<tr><td>adr_support</td><td>'
                        || to_char(pir_row.adr_support)
                        || '</td></tr>'
                        || '</table>';
        else
            v_retval := null;
        end if;

        return v_retval;
    end fv_print;

---------------------------------------------------------------------------------------------------

    procedure p_insert (
        pior_isr_oam_adressat in out isr_oam_adressat%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_isr_oam_adressat.inserted := sysdate;
        pior_isr_oam_adressat.inserted_by := pck_env.fv_user;
        insert into isr_oam_adressat values pior_isr_oam_adressat returning adr_uid into pior_isr_oam_adressat.adr_uid;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle isr_oam_adressat! Parameter: ' || fv_print(pir_row => pior_isr_oam_adressat);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_isr_oam_adressat in isr_oam_adressat%rowtype
    ) is
        r_isr_oam_adressat isr_oam_adressat%rowtype;

  -- fuer exceptions
        v_routine_name     logs.routine_name%type;
        c_message          clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_isr_oam_adressat := pir_isr_oam_adressat;
        r_isr_oam_adressat.inserted := sysdate;
        r_isr_oam_adressat.updated := sysdate;
        r_isr_oam_adressat.inserted_by := pck_env.fv_user;
        r_isr_oam_adressat.updated_by := pck_env.fv_user;
        merge into isr_oam_adressat
        using dual on ( adr_uid = r_isr_oam_adressat.adr_uid )
        when matched then update
        set msn_uid = r_isr_oam_adressat.msn_uid,
            adr_rolle = r_isr_oam_adressat.adr_rolle,
            adr_responsible = r_isr_oam_adressat.adr_responsible,
            adr_accountable = r_isr_oam_adressat.adr_accountable,
            adr_consulted = r_isr_oam_adressat.adr_consulted,
            adr_informed = r_isr_oam_adressat.adr_informed,
            updated = r_isr_oam_adressat.updated,
            updated_by = r_isr_oam_adressat.updated_by,
            adr_san = r_isr_oam_adressat.adr_san,
            adr_bereich = r_isr_oam_adressat.adr_bereich,
            adr_oe = r_isr_oam_adressat.adr_oe,
            adr_support = r_isr_oam_adressat.adr_support
        when not matched then
        insert (
            msn_uid,
            adr_rolle,
            adr_responsible,
            adr_accountable,
            adr_consulted,
            adr_informed,
            inserted,
            inserted_by,
            adr_san,
            adr_bereich,
            adr_oe,
            adr_support,
            freigabeprozess )
        values
            ( r_isr_oam_adressat.msn_uid,
              r_isr_oam_adressat.adr_rolle,
              r_isr_oam_adressat.adr_responsible,
              r_isr_oam_adressat.adr_accountable,
              r_isr_oam_adressat.adr_consulted,
              r_isr_oam_adressat.adr_informed,
              r_isr_oam_adressat.inserted,
              r_isr_oam_adressat.inserted_by,
              r_isr_oam_adressat.adr_san,
              r_isr_oam_adressat.adr_bereich,
              r_isr_oam_adressat.adr_oe,
              r_isr_oam_adressat.adr_support,
              2 );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_isr_oam_adressat);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

    procedure p_update (
        pir_isr_oam_adressat in isr_oam_adressat%rowtype,
        piv_art              in varchar2
    ) is
        r_isr_oam_adressat isr_oam_adressat%rowtype;

  -- fuer exceptions
        v_routine_name     logs.routine_name%type;
        c_message          clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_UPDATE';
        r_isr_oam_adressat.msn_uid := pir_isr_oam_adressat.msn_uid;
        r_isr_oam_adressat.adr_rolle := pir_isr_oam_adressat.adr_rolle;
        r_isr_oam_adressat.adr_responsible := pir_isr_oam_adressat.adr_responsible;
        r_isr_oam_adressat.adr_accountable := pir_isr_oam_adressat.adr_accountable;
        r_isr_oam_adressat.adr_consulted := pir_isr_oam_adressat.adr_consulted;
        r_isr_oam_adressat.adr_informed := pir_isr_oam_adressat.adr_informed;
        r_isr_oam_adressat.updated := sysdate;
        r_isr_oam_adressat.updated_by := pck_env.fv_user;
        r_isr_oam_adressat.adr_san := pir_isr_oam_adressat.adr_san;
        r_isr_oam_adressat.adr_bereich := pir_isr_oam_adressat.adr_bereich;
        r_isr_oam_adressat.adr_oe := pir_isr_oam_adressat.adr_oe;
        r_isr_oam_adressat.adr_support := pir_isr_oam_adressat.adr_support;
        case piv_art
            when '<replace>' then
                update isr_oam_adressat
                set
                    adr_uid = pir_isr_oam_adressat.adr_uid
                where
                    adr_uid = pir_isr_oam_adressat.adr_uid;

            when '<full>' then    
      -- �bernehmen der Eingabedaten  
                r_isr_oam_adressat := pir_isr_oam_adressat;  
      -- Erg�nzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_isr_oam_adressat.inserted,
                    r_isr_oam_adressat.inserted_by
                from
                    isr_oam_adressat
                where
                    adr_uid = pir_isr_oam_adressat.adr_uid;  
      -- Erg�nzen der Update-Daten  
                r_isr_oam_adressat.updated := sysdate;
                r_isr_oam_adressat.updated_by := pck_env.fv_user;
                update isr_oam_adressat
                set
                    row = r_isr_oam_adressat
                where
                    adr_uid = pir_isr_oam_adressat.adr_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_isr_oam_adressat);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;


---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_adr_uid in isr_oam_adressat.adr_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_adr_uid: ' || to_char(pin_adr_uid);
        delete from isr_oam_adressat
        where
            adr_uid = pin_adr_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle isr_oam_adressat! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle isr_oam_adressat! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

    procedure p_delete_for_msn (
        pin_msn_uid in isr_oam_adressat.msn_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE_FOR_MSN';
        v_parameter := 'Parameter: pin_msn_uid: ' || to_char(pin_msn_uid);
        delete from isr_oam_adressat
        where
            msn_uid = pin_msn_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschende DS existierrn nicht. Tabelle isr_oam_adressat! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle isr_oam_adressat! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete_for_msn;

end pck_isr_oam_adressat_dml;
/


-- sqlcl_snapshot {"hash":"a3f36c77176414c28da0e2e00e62a65bfc03cbf1","type":"PACKAGE_BODY","name":"PCK_ISR_OAM_ADRESSAT_DML","schemaName":"RK_MAIN","sxml":""}