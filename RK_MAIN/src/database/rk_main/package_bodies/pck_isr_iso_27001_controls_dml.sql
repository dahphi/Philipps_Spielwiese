create or replace package body rk_main.pck_isr_iso_27001_controls_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in isr_iso_27001_controls%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'i2c_uid = '
                        || to_char(pir_row.i2c_uid)
                        || cv_sep
                        || ', i2c_control = '
                        || pir_row.i2c_control
                        || cv_sep
                        || ', i2c_control_objective = '
                        || pir_row.i2c_control_objective
                        || cv_sep
                        || ', CONTROL_JAHR = '
                        || pir_row.control_jahr
                        || cv_sep
                        || ', KAP_UID_FK = '
                        || pir_row.kap_uid_fk
                        || cv_sep
                        || ', UMSETZUNGSHINWEIS = '
                        || pir_row.umsetzungshinweis
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
            v_retval := '<table><tr><th>ISR_ISO_27001_CONTROLS</th><th>Column</th></tr>'
                        || '<tr><td>i2c_uid</td><td>'
                        || to_char(pir_row.i2c_uid)
                        || '</td></tr>'
                        || '<tr><td>i2c_control</td><td>'
                        || pir_row.i2c_control
                        || '</td></tr>'
                        || '<tr><td>i2c_control_objective</td><td>'
                        || pir_row.i2c_control_objective
                        || '</td></tr>'
                        || '<tr><td>CONTROL_JAHR</td><td>'
                        || pir_row.control_jahr
                        || '</td></tr>'
                        || '<tr><td>KAP_UID_FK</td><td>'
                        || pir_row.kap_uid_fk
                        || '</td></tr>'
                        || '<tr><td>UMSETZUNGSHINWEIS</td><td>'
                        || pir_row.umsetzungshinweis
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
        pior_isr_iso_27001_controls in out isr_iso_27001_controls%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_isr_iso_27001_controls.inserted := sysdate;
        pior_isr_iso_27001_controls.inserted_by := pck_env.fv_user;
        insert into isr_iso_27001_controls values pior_isr_iso_27001_controls returning i2c_uid into pior_isr_iso_27001_controls.i2c_uid
        ;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle isr_iso_27001_controls! Parameter: ' || fv_print(pir_row => pior_isr_iso_27001_controls
            );
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-- Insert into Rel. Table
    procedure p_insert (
        pi_msn_uid in isr_massnahme_iso_27001.msn_uid%type,
        pi_i2c_uid in isr_massnahme_iso_27001.i2c_uid%type
    ) is
        v_conter   number := 0;
        v_sequence number;
    begin
        select
            count(*)
        into v_conter
        from
            isr_massnahme_iso_27001
        where
                msn_uid = pi_msn_uid
            and i2c_uid = pi_i2c_uid;

        if v_conter = 0 then

	--v_sequence := MASSNAHME_ISO_CONTROLS_SEQ.NEXTVAL;
            insert into isr_massnahme_iso_27001 (
        --MI_ID,
                msn_uid,
                i2c_uid,
                inserted,
                inserted_by
            ) values (
          --v_sequence,
             pi_msn_uid,
                       pi_i2c_uid,
                       sysdate,
                       v('APP_USER') );

        end if;

    end p_insert;

--Del from Rel Table
    procedure p_delete (
        pi_msn_uid in isr_massnahme_iso_27001.msn_uid%type
    ) is
    begin
        delete from isr_massnahme_iso_27001
        where
            msn_uid = pi_msn_uid;

    end p_delete;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_isr_iso_27001_controls in isr_iso_27001_controls%rowtype
    ) is
        r_isr_iso_27001_controls isr_iso_27001_controls%rowtype;

  -- fuer exceptions
        v_routine_name           logs.routine_name%type;
        c_message                clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_isr_iso_27001_controls := pir_isr_iso_27001_controls;
        r_isr_iso_27001_controls.inserted := sysdate;
        r_isr_iso_27001_controls.updated := sysdate;
        r_isr_iso_27001_controls.inserted_by := pck_env.fv_user;
        r_isr_iso_27001_controls.updated_by := pck_env.fv_user;
        merge into isr_iso_27001_controls
        using dual on ( i2c_uid = r_isr_iso_27001_controls.i2c_uid )
        when matched then update
        set i2c_control = r_isr_iso_27001_controls.i2c_control,
            i2c_control_objective = r_isr_iso_27001_controls.i2c_control_objective,
            control_jahr = r_isr_iso_27001_controls.control_jahr,
            kap_uid_fk = r_isr_iso_27001_controls.kap_uid_fk,
            umsetzungshinweis = r_isr_iso_27001_controls.umsetzungshinweis,
            updated = r_isr_iso_27001_controls.updated,
            updated_by = r_isr_iso_27001_controls.updated_by
        when not matched then
        insert (
            i2c_control,
            i2c_control_objective,
            control_jahr,
            kap_uid_fk,
            umsetzungshinweis,
            inserted,
            inserted_by )
        values
            ( r_isr_iso_27001_controls.i2c_control,
              r_isr_iso_27001_controls.i2c_control_objective,
              r_isr_iso_27001_controls.control_jahr,
              r_isr_iso_27001_controls.kap_uid_fk,
              r_isr_iso_27001_controls.umsetzungshinweis,
              r_isr_iso_27001_controls.inserted,
              r_isr_iso_27001_controls.inserted_by );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_isr_iso_27001_controls);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

    procedure p_update (
        pir_isr_iso_27001_controls in isr_iso_27001_controls%rowtype,
        piv_art                    in varchar2
    ) is
        r_isr_iso_27001_controls isr_iso_27001_controls%rowtype;

  -- fuer exceptions
        v_routine_name           logs.routine_name%type;
        c_message                clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_UPDATE';
        r_isr_iso_27001_controls.i2c_control := pir_isr_iso_27001_controls.i2c_control;
        r_isr_iso_27001_controls.i2c_control_objective := pir_isr_iso_27001_controls.i2c_control_objective;
        r_isr_iso_27001_controls.control_jahr := pir_isr_iso_27001_controls.control_jahr;
        r_isr_iso_27001_controls.kap_uid_fk := pir_isr_iso_27001_controls.kap_uid_fk;
        r_isr_iso_27001_controls.umsetzungshinweis := pir_isr_iso_27001_controls.umsetzungshinweis;
        r_isr_iso_27001_controls.updated := sysdate;
        r_isr_iso_27001_controls.updated_by := pck_env.fv_user;
        case piv_art
            when '<replace>' then
                update isr_iso_27001_controls
                set
                    i2c_uid = pir_isr_iso_27001_controls.i2c_uid
                where
                    i2c_uid = pir_isr_iso_27001_controls.i2c_uid;

            when '<full>' then    
      -- �bernehmen der Eingabedaten  
                r_isr_iso_27001_controls := pir_isr_iso_27001_controls;  
      -- Erg�nzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_isr_iso_27001_controls.inserted,
                    r_isr_iso_27001_controls.inserted_by
                from
                    isr_iso_27001_controls
                where
                    i2c_uid = pir_isr_iso_27001_controls.i2c_uid;  
      -- Erg�nzen der Update-Daten  
                r_isr_iso_27001_controls.updated := sysdate;
                r_isr_iso_27001_controls.updated_by := pck_env.fv_user;
                update isr_iso_27001_controls
                set
                    row = r_isr_iso_27001_controls
                where
                    i2c_uid = pir_isr_iso_27001_controls.i2c_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_isr_iso_27001_controls);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;


---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_i2c_uid in isr_iso_27001_controls.i2c_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_i2c_uid: ' || to_char(pin_i2c_uid);
        delete from isr_iso_27001_controls
        where
            i2c_uid = pin_i2c_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle isr_iso_27001_controls! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle isr_iso_27001_controls! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_isr_iso_27001_controls_dml;
/


-- sqlcl_snapshot {"hash":"7f8f0557100a58717f0010a66b5752a6e25cbe4e","type":"PACKAGE_BODY","name":"PCK_ISR_ISO_27001_CONTROLS_DML","schemaName":"RK_MAIN","sxml":""}